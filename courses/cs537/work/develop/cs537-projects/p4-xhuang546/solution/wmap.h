// Flags for mmap
#define MAP_PRIVATE 0x0001
#define MAP_SHARED 0x0002
#define MAP_ANONYMOUS 0x0004
#define MAP_FIXED 0x0008

// When mmap fails, returns -1
#define FAILED -1

#define MAX_UPAGE_INFO 32

struct pgdirinfo {
    uint n_upages;           // the number of allocated physical pages in the process's user address space
    uint va[MAX_UPAGE_INFO]; // the virtual addresses of the allocated physical pages in the process's user address space
    uint pa[MAX_UPAGE_INFO]; // the physical addresses of the allocated physical pages in the process's user address space
};

#define MAX_WMMAP_INFO 16

struct wmapinfo {
    int total_mmaps;                    // Total number of mmap regions
    int addr[MAX_WMMAP_INFO];           // Starting address of mapping
    int length[MAX_WMMAP_INFO];         // Size of mapping
    int flags[MAX_WMMAP_INFO];          // Flags of mapping
    int fd[MAX_WMMAP_INFO];             // File descriptor if mapping is not anonymous
    int refcnt[MAX_WMMAP_INFO];         // Reference count of this mapping: NOTE: refcnt > 0 means children are using it
    int n_loaded_pages[MAX_WMMAP_INFO]; // Number of pages physically loaded into memory
};