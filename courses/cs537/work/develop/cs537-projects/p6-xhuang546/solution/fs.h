// On-disk file system format.
// Both the kernel and user programs use this header file.


#define ROOTINO 1  // root i-number
#define BSIZE 512  // block size

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:
struct superblock {
  uint size;         // Size of file system image (blocks)
  uint nblocks;      // Number of data blocks
  uint ninodes;      // Number of inodes.
  uint nlog;         // Number of log blocks
  uint logstart;     // Block number of first log block
  uint inodestart;   // Block number of first inode block
  uint bmapstart;    // Block number of first free map block
};

// Reduce NDIRECT from 12 to 11 to reserve space for xattr block pointer
#define NDIRECT 11
#define NINDIRECT (BSIZE / sizeof(uint))
#define MAXFILE (NDIRECT + NINDIRECT)

// Extended attributes (xattr) constants
#define NXATTR 32           // Maximum number of xattrs per file
#define XATTR_KEYSIZE 8     // Maximum key length (bytes)
#define XATTR_VALSIZE 512   // Maximum value size (one block)

// On-disk xattr entry structure (must be exactly 16 bytes)
// 32 entries * 16 bytes = 512 bytes = one block
struct xattrent {
  char key[XATTR_KEYSIZE];  // 8 bytes - attribute key (null-padded)
  uint size;                // 4 bytes - size of value in bytes
  uint blocknum;            // 4 bytes - block number containing value
};

// On-disk inode structure
struct dinode {
  short type;           // File type
  short major;          // Major device number (T_DEV only)
  short minor;          // Minor device number (T_DEV only)
  short nlink;          // Number of links to inode in file system
  uint size;            // Size of file (bytes)
  uint addrs[NDIRECT+1];   // Data block addresses (11 direct + 1 indirect)
  uint xattr;           // Block number of xattr directory (0 if none)
};

// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Block containing inode i
#define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)

// Bitmap bits per block
#define BPB           (BSIZE*8)

// Block of free map containing bit for block b
#define BBLOCK(b, sb) (b/BPB + sb.bmapstart)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

struct dirent {
  ushort inum;
  char name[DIRSIZ];
};

