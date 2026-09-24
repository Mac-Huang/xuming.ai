#include "types.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"
#include "fcntl.h"

#include "memlayout.h"
#include "wmap.h"

// ====================================================================
// Function Declarations
// ====================================================================

int validate_input(uint addr, int length, int flags, int fd, struct file *f);
struct mmap_region *fix_addr_place_mmap(struct proc *proc, uint addr, int length, int flags);
struct mmap_region *find_addr_place_mmap(struct proc *proc, int length, int flags);
struct mmap_region *find_unused_mmap(struct proc *proc);
void init_one_mmap(struct mmap_region *mmap);
void init_mmaps(struct proc *proc);
uint get_physical_page(struct proc *p, uint va, pte_t **pte);
int count_loaded_pages(struct proc *p, uint start, uint end);
int write_to_file(struct file *f, uint va, int offset, int n_bytes);
int remove_map(uint addr);

// ====================================================================
// System Calls
// ====================================================================
/**
 * @brief System call to create a new memory mapping in the process's address space.
 *
 * @return Returns the starting address of the mapping if successful, or FAILED if an error occurs.
 */
int sys_wmap(void) {
    uint addr;
    int length, flags;
    int fd;
    struct file *f;
    struct proc *curproc;
    struct mmap_region *mmap;
    // Integer arguements
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0 || argint(2, &flags) < 0) {
        cprintf("wmap arg ERROR: size or flags\n");
        return FAILED;
    }
    // File descriptor arguement
    if (argfd(3, &fd, &f) < 0) {
        fd = -1;
        f = 0;
    } else {
        // NOTE: without filedup(), if the file is closed before pgfault handler
        // reads the file, xv6 will panic. Close it in munmap in case of full unmapping.
        f = filedup(f);
    }

    // Validate input
    if (validate_input(addr, length, flags, fd, f) < 0) {
        if (f)
            fileclose(f);
        cprintf("wmap ERROR: invalid input\n");
        return FAILED;
    }

    // Anonymous mappings ignore fd/f.
    if (flags & MAP_ANONYMOUS) {
        if (f)
            fileclose(f);
        f = 0;
    }

    curproc = myproc();
    if (flags & MAP_FIXED)
        mmap = fix_addr_place_mmap(curproc, addr, length, flags);
    else
        mmap = find_addr_place_mmap(curproc, length, flags);

    if (mmap == 0) {
        if (f)
            fileclose(f);
        cprintf("wmap ERROR: failed to place mapping\n");
        return FAILED;
    }

    mmap->length = length;
    mmap->flags = flags;
    mmap->fd = fd;
    mmap->f = f;
    mmap->refcnt = 0;
    mmap->n_loaded_pages = 0;
    curproc->total_mmaps++;

    return mmap->addr;
}

/**
 * @brief System call to remove an existing memory mapping from the process's address space.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_wunmap(void) {
    uint addr;

    // Validate input.
    if (argint(0, (int *)&addr) < 0) {
        cprintf("wunmap arg ERROR: addr\n");
        return FAILED;
    }
    if (addr % PGSIZE != 0) {
        cprintf("wunmap ERROR: addr not page aligned\n");
        return FAILED;
    }
    if (addr < 0x60000000 || addr >= 0x80000000) {
        cprintf("wunmap ERROR: addr out of mmap range\n");
        return FAILED;
    }

    // remove_map() enforces "addr must be the start of an existing mapping".
    if (remove_map(addr) < 0) {
        cprintf("wunmap ERROR: unmap failed\n");
        return FAILED;
    }

    return 0;
}

/**
 * @brief System call to partially remove a part of existing memory mapping from the process's address space.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_wpunmap(void) {
    uint addr;
    int length;
    struct proc *curproc;
    struct mmap_region *prev, *cur, *right;
    uint map_start, map_end, unmap_end;
    uint left_len, right_len;
    uint va_start, va;
    pte_t *pte;

    // validate input
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0) {
        cprintf("wpunmap arg ERROR: size or flags\n");
        return FAILED;
    }
    if ((addr+length) % PGSIZE != 0) {
        cprintf("wpunmap ERROR: partial unmap addr end not page aligned\n");
        return FAILED;
    }
    if (length <= 0){
        cprintf("wpunmap ERROR: partial unmap length <= 0\n");
        return FAILED;
    }
    if (addr < 0x60000000 || addr >= 0x80000000) {
        cprintf("wpunmap ERROR: addr out of mmap range\n");
        return FAILED;
    }

    curproc = myproc();
    unmap_end = addr + (uint)length;
    if (unmap_end < addr) {
        cprintf("wpunmap ERROR: overflow\n");
        return FAILED;
    }

    // Find map that fully contains [addr, unmap_end).
    prev = 0;
    cur = curproc->mmap_head;
    while (cur) {
        map_start = cur->addr;
        map_end = cur->addr + (uint)cur->length;
        if (addr >= map_start && unmap_end <= map_end)
            break;
        prev = cur;
        cur = cur->next;
    }
    if (cur == 0) {
        cprintf("wpunmap ERROR: no containing map\n");
        return FAILED;
    }

    // Per README: partial unmap is only required for anonymous private maps.
    if ((cur->flags & MAP_ANONYMOUS) == 0 || (cur->flags & MAP_PRIVATE) == 0 || (cur->flags & MAP_SHARED)) {
        cprintf("wpunmap ERROR: unsupported flags for partial unmap\n");
        return FAILED;
    }

    left_len = addr - map_start;
    right_len = map_end - unmap_end;
    right = 0;

    // For middle split, reserve a second mmap slot first.
    if (left_len > 0 && right_len > 0) {
        right = find_unused_mmap(curproc);
        if (right == 0) {
            cprintf("wpunmap ERROR: no free mmap slot for split\n");
            return FAILED;
        }
    }

    // Remove fully-covered pages from page table.
    // If addr is not page-aligned, keep its first partial page.
    va_start = PGROUNDUP(addr);
    for (va = va_start; va < unmap_end; va += PGSIZE) {
        pte = walkpgdir(curproc->pgdir, (void *)va, 0);
        if (pte == 0 || (*pte & PTE_P) == 0)
            continue;
        kfree(P2V(PTE_ADDR(*pte)));
        *pte = 0;
    }
    switchuvm(curproc);

    if (left_len == 0 && right_len == 0) {
        // Full removal.
        if (prev == 0)
            curproc->mmap_head = cur->next;
        else
            prev->next = cur->next;
        if (cur->f)
            fileclose(cur->f);
        init_one_mmap(cur);
        if (curproc->total_mmaps > 0)
            curproc->total_mmaps--;
    } else if (left_len == 0) {
        // Trim from front.
        cur->addr = unmap_end;
        cur->length = right_len;
    } else if (right_len == 0) {
        // Trim from tail.
        cur->length = left_len;
    } else {
        // Split into [left] and [right].
        init_one_mmap(right);
        right->addr = unmap_end;
        right->length = right_len;
        right->flags = cur->flags;
        right->fd = cur->fd;
        right->f = cur->f;
        right->refcnt = cur->refcnt;
        right->n_loaded_pages = 0;
        right->next = cur->next;

        cur->length = left_len;
        cur->next = right;
        curproc->total_mmaps++;
    }

    return 0;
}


/**
 * @brief System call to retrieve detailed information about all memory mappings in the process's address space.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_getwmapinfo(void) {
    struct wmapinfo *info;
    struct proc *curproc;
    struct mmap_region *mmap;
    int i;

    if (argptr(0, (void *)&info, sizeof(*info)) < 0) {
        cprintf("getwmapinfo arg ERROR\n");
        return FAILED;
    }

    memset(info, 0, sizeof(*info));
    curproc = myproc();
    info->total_mmaps = curproc->total_mmaps;

    mmap = curproc->mmap_head;
    i = 0;
    while (mmap && i < MAX_WMMAP_INFO) {
        info->addr[i] = mmap->addr;
        info->length[i] = mmap->length;
        info->flags[i] = mmap->flags;
        info->fd[i] = mmap->fd;
        info->refcnt[i] = mmap->refcnt;
        info->n_loaded_pages[i] = count_loaded_pages(curproc, mmap->addr, mmap->addr + (uint)mmap->length);
        mmap->n_loaded_pages = info->n_loaded_pages[i];
        mmap = mmap->next;
        i++;
    }

    return 0;
}

/**
 * @brief System call to retrieve information about the current page directory.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_getpgdirinfo(void) {
    struct pgdirinfo *info;
    struct proc *curproc;
    uint va, pa;
    int nfill;

    if (argptr(0, (void *)&info, sizeof(*info)) < 0) {
        return FAILED;
    }

    memset(info, 0, sizeof(*info));
    curproc = myproc();
    nfill = 0;

    for (va = 0; va < KERNBASE; va += PGSIZE) {
        pa = get_physical_page(curproc, va, 0);
        if (pa == 0)
            continue;

        if (nfill < MAX_UPAGE_INFO) {
            info->va[nfill] = va;
            info->pa[nfill] = pa;
            nfill++;
        }
        info->n_upages++;
    }

    return 0;
}

// ====================================================================
// Functions related to wmap
// ====================================================================

/**
 * @brief validates input parameters for memory mapping.
 *
 * @return 0 if input is valid, or a negative error code if validation fails.
 */
int validate_input(uint addr, int length, int flags, int fd, struct file *f) {
    uint end;
    int known_flags = MAP_PRIVATE | MAP_SHARED | MAP_ANONYMOUS | MAP_FIXED;

    if (length <= 0) return FAILED;

    // Exactly one of MAP_PRIVATE or MAP_SHARED must be set.
    if (!!(flags & MAP_PRIVATE) == !!(flags & MAP_SHARED)) return FAILED;

    // Reject unknown bits.
    if (flags & ~known_flags) return FAILED;

    // File-backed mappings require a valid fd/file.
    if (!(flags & MAP_ANONYMOUS) && (fd < 0 || f == 0)) return FAILED;

    // Per-process mmap limit.
    if (myproc()->total_mmaps >= MAX_NMMAP) return FAILED;

    // Mapping length must fit in the mmap address window.
    if ((uint)length > (uint)(0x80000000 - 0x60000000)) return FAILED;

    if (flags & MAP_FIXED) {
        if (addr % PGSIZE != 0) return FAILED;
        if (addr < 0x60000000 || addr >= 0x80000000) return FAILED;

        end = addr + (uint)length;
        if (end < addr) return FAILED;       // overflow
        if (end > 0x80000000) return FAILED; // out of mmap range
    }

    return 0;
}

/**
 * @brief searches for an unused mmap structure in the process's mmap list
 * and returns a pointer to it.
 *
 * @return Pointer to the unused mmap structure if found, or NULL if not found.
 */
struct mmap_region *find_unused_mmap(struct proc *proc) {
    int i;
    for (i = 0; i < MAX_NMMAP; i++) {
        if (proc->mmaps[i].addr == (uint)-1)
            return &proc->mmaps[i];
    }
    return (struct mmap_region*)0;
}

/**
 * @brief places an mmap structure in the process's mmap list at a fixed address
 * if the address is available and does not overlap with existing mappings.
 *
 * @param addr The fixed address for the mapping.
 * @param length The length of the mapping.
 * @return Pointer to the placed mmap structure if successful, or NULL if failed.
 */
struct mmap_region *fix_addr_place_mmap(struct proc *proc, uint addr, int length, int flags) {
    struct mmap_region *prev, *cur, *slot;
    uint start, end, cur_start, cur_end;

    (void)flags;
    slot = find_unused_mmap(proc);
    if (slot == 0)
        return (struct mmap_region*)0;

    start = addr;
    end = addr + (uint)length;
    prev = 0;
    cur = proc->mmap_head;

    while (cur) {
        cur_start = cur->addr;
        cur_end = cur->addr + (uint)cur->length;

        // half-open interval overlap check: [start, end) and [cur_start, cur_end)
        if (start < cur_end && cur_start < end)
            return (struct mmap_region*)0;

        if (cur_start > start)
            break;

        prev = cur;
        cur = cur->next;
    }

    init_one_mmap(slot);
    slot->addr = addr;
    slot->length = length;
    slot->next = cur;

    if (prev == 0)
        proc->mmap_head = slot;
    else
        prev->next = slot;

    return slot;
}

/**
 * @brief finds a suitable address for the mapping and places an mmap structure
 * in the process's mmap list.
 *
 * @param length The length of the mapping.
 * @return Pointer to the placed mmap structure if successful, or NULL if failed.
 */
struct mmap_region *find_addr_place_mmap(struct proc *proc, int length, int flags) {
    struct mmap_region *prev, *cur, *slot;
    uint addr, end, cur_end;

    (void)flags;
    slot = find_unused_mmap(proc);
    if (slot == 0)
        return (struct mmap_region*)0;

    addr = 0x60000000;
    prev = 0;
    cur = proc->mmap_head;

    while (cur) {
        end = addr + (uint)length;
        if (end < addr || end > cur->addr)
            goto advance;
        break;

advance:
        cur_end = cur->addr + (uint)cur->length;
        addr = PGROUNDUP(cur_end);
        prev = cur;
        cur = cur->next;
    }

    end = addr + (uint)length;
    if (end < addr || addr < 0x60000000 || end > 0x80000000)
        return (struct mmap_region*)0;

    init_one_mmap(slot);
    slot->addr = addr;
    slot->length = length;
    slot->next = cur;

    if (prev == 0)
        proc->mmap_head = slot;
    else
        prev->next = slot;

    return slot;
}

// ====================================================================
// Functions related to unmapping
// ====================================================================

/**
 * @brief removes a memory mapping at a given virtual address from the process's
 * address space. It deallocates physical pages if necessary, decrements reference counts,
 * and updates the process's memory mapping list.
 *
 * @param addr The virtual address of the memory mapping to remove.
 * @return 0 if successful, or a negative error code if an error occurs.
 */
int remove_map(uint addr) {
    struct proc *curproc;
    struct mmap_region *prev, *cur;
    uint start, end, va, page_bytes, offset;
    pte_t *pte;

    curproc = myproc();
    prev = 0;
    cur = curproc->mmap_head;

    // Find mapping that starts exactly at addr.
    while (cur && cur->addr != addr) {
        prev = cur;
        cur = cur->next;
    }
    if (cur == 0)
        return FAILED;

    start = cur->addr;
    end = cur->addr + (uint)cur->length;

    // Remove mapped pages from this process.
    for (va = start; va < end; va += PGSIZE) {
        pte = walkpgdir(curproc->pgdir, (void *)va, 0);
        if (pte == 0 || (*pte & PTE_P) == 0)
            continue; // Demand paging: page may never have been loaded.

        // MAP_SHARED file-backed pages are written back on unmap.
        if (!(cur->flags & MAP_ANONYMOUS) && (cur->flags & MAP_SHARED) && cur->f) {
            offset = va - start;
            page_bytes = end - va;
            if (page_bytes > PGSIZE)
                page_bytes = PGSIZE;
            if (write_to_file(cur->f, va, offset, page_bytes) < 0)
                return FAILED;
        }

        kfree(P2V(PTE_ADDR(*pte)));
        *pte = 0;
    }

    // Flush TLB after clearing PTEs.
    switchuvm(curproc);

    // Unlink from mmap list.
    if (prev == 0)
        curproc->mmap_head = cur->next;
    else
        prev->next = cur->next;

    if (cur->f)
        fileclose(cur->f);
    init_one_mmap(cur);
    if (curproc->total_mmaps > 0)
        curproc->total_mmaps--;

    return 0;
}

/**
 * @brief writes the contents of a memory region to a file at the specified offset.
 *
 * @return The number of bytes written if successful, or -1 if an error occurs.
 */
int write_to_file(struct file *f, uint va, int offset, int n_bytes) {
    int r;
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * 512;
    int i = 0;
    while (i < n_bytes) {
        int n1 = n_bytes - i;
        if (n1 > max)
            n1 = max;
        begin_op();
        ilock(f->ip);
        if ((r = writei(f->ip, (char *)va + i, offset, n1)) > 0)
            offset += r;
        iunlock(f->ip);
        end_op();

        if (r < 0)
            break;
        if (r != n1)
            panic("wmap: short filewrite");
        i += r;
    }
    r = (i == n_bytes ? n_bytes : -1);
    return r;
}

// ====================================================================
// Common Functions
// ====================================================================

/**
 * @brief resets the fields of an mmap_region struct to their default values.
 *
 * @param mmap Pointer to the mmap_region struct to reset.
 */
void init_one_mmap(struct mmap_region *mmap) {
    mmap->addr = -1;
    mmap->length = -1;
    mmap->flags = -1;
    mmap->fd = -1;
    mmap->f = 0;
    mmap->refcnt = 0;
    mmap->n_loaded_pages = 0;
    mmap->next = 0;
}

/**
 * @brief initializes memory maps for a process by resetting its mmap structures.
 *
 * @param proc Pointer to the process structure to initialize.
 */
void init_mmaps(struct proc *proc) {
    int i;

    proc->mmap_head = 0;
    proc->total_mmaps = 0;
    for (i = 0; i < MAX_NMMAP; i++)
        init_one_mmap(&proc->mmaps[i]);
}

/**
 * @brief retrieves the physical address of a page from its virtual address in the process's address space.
 *
 * @param va Virtual address of the page.
 * @param pte Pointer to the page table entry. this will be updated with the address of the page table entry.
 * @return Physical address of the page if found, or 0 if not found.
 */
uint get_physical_page(struct proc *p, uint va, pte_t **pte) {
    pte_t *entry;

    entry = walkpgdir(p->pgdir, (const void *)va, 0);
    if (pte)
        *pte = entry;
    if (entry == 0)
        return 0;
    if (((*entry & PTE_P) == 0) || ((*entry & PTE_U) == 0))
        return 0;

    return PTE_ADDR(*entry);
}

/**
 * @brief find the loaded pages number of a virtual address range
 *
 * @param start Virtual address start.
 * @param end Virtual address end.
 * @return number of loaded pages.
 */
int count_loaded_pages(struct proc *p, uint start, uint end) {
    uint va;
    int cnt;

    cnt = 0;
    if (end < start)
        return 0;
    for (va = start; va < end; va += PGSIZE) {
        if (get_physical_page(p, va, 0) != 0)
            cnt++;
    }
    return cnt;
}

// ====================================================================
// Functions related to demand allocation
// ====================================================================

/**
 * @brief This function is called when a page fault occurs. It allocates a physical page,
 * maps it to the corresponding virtual address, and reads content from a file if necessary.
 *
 * @param pgflt_vaddr The virtual address that caused the page fault.
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int handle_page_fault(uint pgflt_vaddr) {
    struct proc *curproc;
    struct mmap_region *mmap;
    uint va, map_end, offset, n_bytes;
    char *mem;
    int r;
    pte_t *pte;

    curproc = myproc();
    if (curproc == 0)
        return FAILED;

    mmap = curproc->mmap_head;
    while (mmap) {
        map_end = mmap->addr + (uint)mmap->length;
        if (pgflt_vaddr >= mmap->addr && pgflt_vaddr < map_end)
            break;
        mmap = mmap->next;
    }
    if (mmap == 0)
        return FAILED;

    va = PGROUNDDOWN(pgflt_vaddr);
    map_end = mmap->addr + (uint)mmap->length;
    if (va < mmap->addr || va >= map_end)
        return FAILED;

    // Already mapped: not a demand-allocation fault for this page.
    if (get_physical_page(curproc, va, &pte) != 0)
        return 0;

    mem = kalloc();
    if (mem == 0)
        return FAILED;
    memset(mem, 0, PGSIZE);

    if (mappages(curproc->pgdir, (void *)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
        kfree(mem);
        return FAILED;
    }

    if (!(mmap->flags & MAP_ANONYMOUS) && mmap->f) {
        offset = va - mmap->addr;
        n_bytes = map_end - va;
        if (n_bytes > PGSIZE)
            n_bytes = PGSIZE;

        ilock(mmap->f->ip);
        r = readi(mmap->f->ip, (char *)va, offset, n_bytes);
        iunlock(mmap->f->ip);
        if (r < 0) {
            pte = walkpgdir(curproc->pgdir, (void *)va, 0);
            if (pte && (*pte & PTE_P)) {
                kfree(P2V(PTE_ADDR(*pte)));
                *pte = 0;
                switchuvm(curproc);
            }
            return FAILED;
        }
    }

    mmap->n_loaded_pages++;
    return 0;
}

// ====================================================================
// Functions related to fork
// ====================================================================

/**
 * @brief copies memory mappings from the parent process to the child process.
 * It also copies the physical pages if the memory mapping is MAP_PRIVATE.
 * It also increments the reference count of the memory mapping if it is MAP_SHARED.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int copy_maps(struct proc *parent, struct proc *child) {
    struct mmap_region *pm, *cm;
    uint va, end, pa;
    char *mem;

    pm = parent->mmap_head;
    while (pm) {
        // Child must inherit the same virtual ranges.
        cm = fix_addr_place_mmap(child, pm->addr, pm->length, pm->flags);
        if (cm == 0)
            return FAILED;

        cm->length = pm->length;
        cm->flags = pm->flags;
        cm->fd = pm->fd;
        cm->f = pm->f ? filedup(pm->f) : 0;
        cm->refcnt = (pm->flags & MAP_SHARED) ? (pm->refcnt + 1) : 0;
        cm->n_loaded_pages = pm->n_loaded_pages;
        child->total_mmaps++;

        // Copy/share already loaded pages. Unloaded pages remain demand-paged.
        end = pm->addr + (uint)pm->length;
        for (va = pm->addr; va < end; va += PGSIZE) {
            pa = get_physical_page(parent, va, 0);
            if (pa == 0)
                continue;

            if (pm->flags & MAP_SHARED) {
                kaddref((char *)P2V(pa));
                if (mappages(child->pgdir, (void *)va, PGSIZE, pa, PTE_W | PTE_U) < 0) {
                    kfree((char *)P2V(pa));
                    return FAILED;
                }
            } else {
                mem = kalloc();
                if (mem == 0)
                    return FAILED;
                memmove(mem, (char *)P2V(pa), PGSIZE);
                if (mappages(child->pgdir, (void *)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
                    kfree(mem);
                    return FAILED;
                }
            }
        }

        pm = pm->next;
    }

    return 0;
}

// ====================================================================
// Functions related to exit
// ====================================================================

/**
 * @brief deletes memory mappings of a process during its exit.
 * It removes mappings with zero reference count and resets the mmap_region struct.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int delete_mmaps(struct proc *curproc) {
    struct mmap_region *mmap, *next;
    uint start, end, va, page_bytes, offset;
    pte_t *pte;

    mmap = curproc->mmap_head;
    while (mmap) {
        next = mmap->next;
        start = mmap->addr;
        end = mmap->addr + (uint)mmap->length;

        for (va = start; va < end; va += PGSIZE) {
            pte = walkpgdir(curproc->pgdir, (void *)va, 0);
            if (pte == 0 || (*pte & PTE_P) == 0)
                continue;

            if (!(mmap->flags & MAP_ANONYMOUS) && (mmap->flags & MAP_SHARED) && mmap->f) {
                offset = va - start;
                page_bytes = end - va;
                if (page_bytes > PGSIZE)
                    page_bytes = PGSIZE;
                if (write_to_file(mmap->f, va, offset, page_bytes) < 0)
                    return FAILED;
            }

            kfree(P2V(PTE_ADDR(*pte)));
            *pte = 0;
        }

        if (mmap->f)
            fileclose(mmap->f);
        init_one_mmap(mmap);
        if (curproc->total_mmaps > 0)
            curproc->total_mmaps--;

        mmap = next;
    }

    curproc->mmap_head = 0;
    switchuvm(curproc);
    return 0;
}
