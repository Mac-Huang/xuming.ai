
_test_15:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// Does not check for deallocation of pages
// ====================================================================

char *test_name = "TEST_15";

int main() {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
    printf(1, "XV6: %s\n", test_name);

    // validate initial state
    struct wmapinfo info;
    printf(1, "XV6: Initial State: \n");
    test_getwmapinfo(&info);
   f:	8d b5 64 fe ff ff    	lea    -0x19c(%ebp),%esi
int main() {
  15:	53                   	push   %ebx
  16:	51                   	push   %ecx
  17:	81 ec ac 01 00 00    	sub    $0x1ac,%esp
    printf(1, "XV6: %s\n", test_name);
  1d:	ff 35 c0 14 00 00    	push   0x14c0
  23:	68 a8 0c 00 00       	push   $0xca8
  28:	6a 01                	push   $0x1
  2a:	e8 81 05 00 00       	call   5b0 <printf>
    printf(1, "XV6: Initial State: \n");
  2f:	58                   	pop    %eax
  30:	5a                   	pop    %edx
  31:	68 b1 0c 00 00       	push   $0xcb1
  36:	6a 01                	push   $0x1
  38:	e8 73 05 00 00       	call   5b0 <printf>
    test_getwmapinfo(&info);
  3d:	89 34 24             	mov    %esi,(%esp)
  40:	e8 5b 09 00 00       	call   9a0 <test_getwmapinfo>
    int N_PAGES = 10;
    int fd = -1;
    int fixed_anon_shared = MAP_FIXED | MAP_ANONYMOUS | MAP_SHARED;

    // 1. create an anonymous private Map 1
    printf(1, "XV6: Place one map. \n");
  45:	59                   	pop    %ecx
  46:	5b                   	pop    %ebx
  47:	68 c7 0c 00 00       	push   $0xcc7
  4c:	6a 01                	push   $0x1
  4e:	e8 5d 05 00 00       	call   5b0 <printf>
    int addr = MMAPBASE;
    int len = PGSIZE * N_PAGES;
    uint map = wmap(addr, len, fixed_anon_shared, fd);
  53:	6a ff                	push   $0xffffffff
  55:	6a 0e                	push   $0xe
  57:	68 00 a0 00 00       	push   $0xa000
  5c:	68 00 00 00 60       	push   $0x60000000
  61:	e8 6d 04 00 00       	call   4d3 <wmap>
    if (map != addr) {
  66:	83 c4 20             	add    $0x20,%esp
    uint map = wmap(addr, len, fixed_anon_shared, fd);
  69:	89 c3                	mov    %eax,%ebx
    if (map != addr) {
  6b:	3d 00 00 00 60       	cmp    $0x60000000,%eax
  70:	74 1a                	je     8c <main+0x8c>
        printf(1, "XV6: expected map at 0x%x, but found at 0x%x\n", addr, map);
  72:	50                   	push   %eax
  73:	68 00 00 00 60       	push   $0x60000000
  78:	68 40 0d 00 00       	push   $0xd40
  7d:	6a 01                	push   $0x1
  7f:	e8 2c 05 00 00       	call   5b0 <printf>
        failed();
  84:	e8 77 08 00 00       	call   900 <failed>
  89:	83 c4 10             	add    $0x10,%esp
    }

    // 2. write some data to all the pages of the mapping
    char val = 'a';
    char *arr = (char *)map;
    for (int i = 0; i < len; i++) {
  8c:	8d bb 00 a0 00 00    	lea    0xa000(%ebx),%edi
    uint map = wmap(addr, len, fixed_anon_shared, fd);
  92:	89 d8                	mov    %ebx,%eax
  94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        arr[i] = val;
  98:	c6 00 61             	movb   $0x61,(%eax)
    for (int i = 0; i < len; i++) {
  9b:	83 c0 01             	add    $0x1,%eax
  9e:	39 f8                	cmp    %edi,%eax
  a0:	75 f6                	jne    98 <main+0x98>
    }

    int newval = 'x';
    // validate mid state
    printf(1, "XV6: Current State: \n");
  a2:	83 ec 08             	sub    $0x8,%esp
  a5:	68 dd 0c 00 00       	push   $0xcdd
  aa:	6a 01                	push   $0x1
  ac:	e8 ff 04 00 00       	call   5b0 <printf>
    test_getwmapinfo(&info);
  b1:	89 34 24             	mov    %esi,(%esp)
  b4:	e8 e7 08 00 00       	call   9a0 <test_getwmapinfo>

    int pid = fork();
  b9:	e8 6d 03 00 00       	call   42b <fork>
    if (pid == 0) {
  be:	83 c4 10             	add    $0x10,%esp
  c1:	85 c0                	test   %eax,%eax
  c3:	74 6f                	je     134 <main+0x134>
        printf(1, "XV6: Child modified the data in Map 1.\n");
        // child process exits
        exit();
    } else {
        // parent process waits for the child to exit
        wait();
  c5:	e8 71 03 00 00       	call   43b <wait>

        // validate mid state
        printf(1, "XV6: Parent State: \n");
  ca:	83 ec 08             	sub    $0x8,%esp
  cd:	68 22 0d 00 00       	push   $0xd22
  d2:	6a 01                	push   $0x1
  d4:	e8 d7 04 00 00       	call   5b0 <printf>
        test_getwmapinfo(&info);
  d9:	89 34 24             	mov    %esi,(%esp)
  dc:	e8 bf 08 00 00       	call   9a0 <test_getwmapinfo>
  e1:	83 c4 10             	add    $0x10,%esp
  e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

        // 5. the parent process should see the new data in Map 1
        char *arr = (char *)map;
        for (int i = 0; i < len; i++) {
            if (arr[i] != newval) {
  e8:	0f be 03             	movsbl (%ebx),%eax
  eb:	3c 78                	cmp    $0x78,%al
  ed:	74 17                	je     106 <main+0x106>
                printf(1, "XV6: Parent sees %d at Map 1, but expected %d\n", arr[i], val);
  ef:	6a 61                	push   $0x61
  f1:	50                   	push   %eax
  f2:	68 04 0e 00 00       	push   $0xe04
  f7:	6a 01                	push   $0x1
  f9:	e8 b2 04 00 00       	call   5b0 <printf>
                failed();
  fe:	e8 fd 07 00 00       	call   900 <failed>
 103:	83 c4 10             	add    $0x10,%esp
        for (int i = 0; i < len; i++) {
 106:	83 c3 01             	add    $0x1,%ebx
 109:	39 df                	cmp    %ebx,%edi
 10b:	75 db                	jne    e8 <main+0xe8>
            }
        }
        printf(1, "XV6: Parent sees the new data in Map 1.\n");
 10d:	83 ec 08             	sub    $0x8,%esp
 110:	68 34 0e 00 00       	push   $0xe34
 115:	6a 01                	push   $0x1
 117:	e8 94 04 00 00       	call   5b0 <printf>

        finish();
 11c:	e8 bf 07 00 00       	call   8e0 <finish>
    }

    // test ends
    finish();
 121:	e8 ba 07 00 00       	call   8e0 <finish>
 126:	8d 65 f0             	lea    -0x10(%ebp),%esp
 129:	31 c0                	xor    %eax,%eax
 12b:	59                   	pop    %ecx
 12c:	5b                   	pop    %ebx
 12d:	5e                   	pop    %esi
 12e:	5f                   	pop    %edi
 12f:	5d                   	pop    %ebp
 130:	8d 61 fc             	lea    -0x4(%ecx),%esp
 133:	c3                   	ret    
        printf(1, "XV6: Child process starts\n");
 134:	51                   	push   %ecx
 135:	51                   	push   %ecx
 136:	68 f3 0c 00 00       	push   $0xcf3
 13b:	6a 01                	push   $0x1
 13d:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
 143:	e8 68 04 00 00       	call   5b0 <printf>
        printf(1, "XV6: Child State: \n");
 148:	5f                   	pop    %edi
 149:	58                   	pop    %eax
 14a:	68 0e 0d 00 00       	push   $0xd0e
 14f:	6a 01                	push   $0x1
 151:	e8 5a 04 00 00       	call   5b0 <printf>
        test_getwmapinfo(&info);
 156:	89 34 24             	mov    %esi,(%esp)
        for (int i = 0; i < len; i++) {
 159:	31 f6                	xor    %esi,%esi
        test_getwmapinfo(&info);
 15b:	e8 40 08 00 00       	call   9a0 <test_getwmapinfo>
        for (int i = 0; i < len; i++) {
 160:	8b 85 54 fe ff ff    	mov    -0x1ac(%ebp),%eax
        test_getwmapinfo(&info);
 166:	83 c4 10             	add    $0x10,%esp
            if (arr3[i] != val) {
 169:	0f be 14 1e          	movsbl (%esi,%ebx,1),%edx
 16d:	80 fa 61             	cmp    $0x61,%dl
 170:	74 23                	je     195 <main+0x195>
                printf(1, "XV6: Child sees '%c' at Map 1, but expected '%c'\n", arr3[i], val);
 172:	6a 61                	push   $0x61
 174:	52                   	push   %edx
 175:	68 70 0d 00 00       	push   $0xd70
 17a:	6a 01                	push   $0x1
 17c:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
 182:	e8 29 04 00 00       	call   5b0 <printf>
                failed();
 187:	e8 74 07 00 00       	call   900 <failed>
 18c:	8b 85 54 fe ff ff    	mov    -0x1ac(%ebp),%eax
 192:	83 c4 10             	add    $0x10,%esp
        for (int i = 0; i < len; i++) {
 195:	83 c6 01             	add    $0x1,%esi
 198:	81 fe 00 a0 00 00    	cmp    $0xa000,%esi
 19e:	75 c9                	jne    169 <main+0x169>
        printf(1, "XV6: Child sees the same data as the parent in Map 1.\n");
 1a0:	52                   	push   %edx
 1a1:	52                   	push   %edx
 1a2:	68 a4 0d 00 00       	push   $0xda4
 1a7:	6a 01                	push   $0x1
 1a9:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
 1af:	e8 fc 03 00 00       	call   5b0 <printf>
 1b4:	8b 85 54 fe ff ff    	mov    -0x1ac(%ebp),%eax
 1ba:	83 c4 10             	add    $0x10,%esp
            arr3[i] = newval;
 1bd:	c6 04 18 78          	movb   $0x78,(%eax,%ebx,1)
        for (int i = 0; i < len; i++) {
 1c1:	83 c0 01             	add    $0x1,%eax
 1c4:	3d 00 a0 00 00       	cmp    $0xa000,%eax
 1c9:	75 f2                	jne    1bd <main+0x1bd>
        printf(1, "XV6: Child modified the data in Map 1.\n");
 1cb:	50                   	push   %eax
 1cc:	50                   	push   %eax
 1cd:	68 dc 0d 00 00       	push   $0xddc
 1d2:	6a 01                	push   $0x1
 1d4:	e8 d7 03 00 00       	call   5b0 <printf>
        exit();
 1d9:	e8 55 02 00 00       	call   433 <exit>
 1de:	66 90                	xchg   %ax,%ax

000001e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1e0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1e1:	31 c0                	xor    %eax,%eax
{
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	53                   	push   %ebx
 1e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1f0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1f7:	83 c0 01             	add    $0x1,%eax
 1fa:	84 d2                	test   %dl,%dl
 1fc:	75 f2                	jne    1f0 <strcpy+0x10>
    ;
  return os;
}
 1fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 201:	89 c8                	mov    %ecx,%eax
 203:	c9                   	leave  
 204:	c3                   	ret    
 205:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 55 08             	mov    0x8(%ebp),%edx
 217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 21a:	0f b6 02             	movzbl (%edx),%eax
 21d:	84 c0                	test   %al,%al
 21f:	75 17                	jne    238 <strcmp+0x28>
 221:	eb 3a                	jmp    25d <strcmp+0x4d>
 223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 227:	90                   	nop
 228:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 22c:	83 c2 01             	add    $0x1,%edx
 22f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 232:	84 c0                	test   %al,%al
 234:	74 1a                	je     250 <strcmp+0x40>
    p++, q++;
 236:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 238:	0f b6 19             	movzbl (%ecx),%ebx
 23b:	38 c3                	cmp    %al,%bl
 23d:	74 e9                	je     228 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 23f:	29 d8                	sub    %ebx,%eax
}
 241:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 244:	c9                   	leave  
 245:	c3                   	ret    
 246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 250:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 254:	31 c0                	xor    %eax,%eax
 256:	29 d8                	sub    %ebx,%eax
}
 258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 25b:	c9                   	leave  
 25c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 25d:	0f b6 19             	movzbl (%ecx),%ebx
 260:	31 c0                	xor    %eax,%eax
 262:	eb db                	jmp    23f <strcmp+0x2f>
 264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 26f:	90                   	nop

00000270 <strlen>:

uint
strlen(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 276:	80 3a 00             	cmpb   $0x0,(%edx)
 279:	74 15                	je     290 <strlen+0x20>
 27b:	31 c0                	xor    %eax,%eax
 27d:	8d 76 00             	lea    0x0(%esi),%esi
 280:	83 c0 01             	add    $0x1,%eax
 283:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 287:	89 c1                	mov    %eax,%ecx
 289:	75 f5                	jne    280 <strlen+0x10>
    ;
  return n;
}
 28b:	89 c8                	mov    %ecx,%eax
 28d:	5d                   	pop    %ebp
 28e:	c3                   	ret    
 28f:	90                   	nop
  for(n = 0; s[n]; n++)
 290:	31 c9                	xor    %ecx,%ecx
}
 292:	5d                   	pop    %ebp
 293:	89 c8                	mov    %ecx,%eax
 295:	c3                   	ret    
 296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29d:	8d 76 00             	lea    0x0(%esi),%esi

000002a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 d7                	mov    %edx,%edi
 2af:	fc                   	cld    
 2b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2b2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 2b5:	89 d0                	mov    %edx,%eax
 2b7:	c9                   	leave  
 2b8:	c3                   	ret    
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002c0 <strchr>:

char*
strchr(const char *s, char c)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ca:	0f b6 10             	movzbl (%eax),%edx
 2cd:	84 d2                	test   %dl,%dl
 2cf:	75 12                	jne    2e3 <strchr+0x23>
 2d1:	eb 1d                	jmp    2f0 <strchr+0x30>
 2d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2d7:	90                   	nop
 2d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2dc:	83 c0 01             	add    $0x1,%eax
 2df:	84 d2                	test   %dl,%dl
 2e1:	74 0d                	je     2f0 <strchr+0x30>
    if(*s == c)
 2e3:	38 d1                	cmp    %dl,%cl
 2e5:	75 f1                	jne    2d8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2e7:	5d                   	pop    %ebp
 2e8:	c3                   	ret    
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2f0:	31 c0                	xor    %eax,%eax
}
 2f2:	5d                   	pop    %ebp
 2f3:	c3                   	ret    
 2f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ff:	90                   	nop

00000300 <gets>:

char*
gets(char *buf, int max)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 305:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 308:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 309:	31 db                	xor    %ebx,%ebx
{
 30b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 30e:	eb 27                	jmp    337 <gets+0x37>
    cc = read(0, &c, 1);
 310:	83 ec 04             	sub    $0x4,%esp
 313:	6a 01                	push   $0x1
 315:	57                   	push   %edi
 316:	6a 00                	push   $0x0
 318:	e8 2e 01 00 00       	call   44b <read>
    if(cc < 1)
 31d:	83 c4 10             	add    $0x10,%esp
 320:	85 c0                	test   %eax,%eax
 322:	7e 1d                	jle    341 <gets+0x41>
      break;
    buf[i++] = c;
 324:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 328:	8b 55 08             	mov    0x8(%ebp),%edx
 32b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 32f:	3c 0a                	cmp    $0xa,%al
 331:	74 1d                	je     350 <gets+0x50>
 333:	3c 0d                	cmp    $0xd,%al
 335:	74 19                	je     350 <gets+0x50>
  for(i=0; i+1 < max; ){
 337:	89 de                	mov    %ebx,%esi
 339:	83 c3 01             	add    $0x1,%ebx
 33c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 33f:	7c cf                	jl     310 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 348:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34b:	5b                   	pop    %ebx
 34c:	5e                   	pop    %esi
 34d:	5f                   	pop    %edi
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    
  buf[i] = '\0';
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	89 de                	mov    %ebx,%esi
 355:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 359:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35c:	5b                   	pop    %ebx
 35d:	5e                   	pop    %esi
 35e:	5f                   	pop    %edi
 35f:	5d                   	pop    %ebp
 360:	c3                   	ret    
 361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36f:	90                   	nop

00000370 <stat>:

int
stat(const char *n, struct stat *st)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	56                   	push   %esi
 374:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 375:	83 ec 08             	sub    $0x8,%esp
 378:	6a 00                	push   $0x0
 37a:	ff 75 08             	push   0x8(%ebp)
 37d:	e8 f1 00 00 00       	call   473 <open>
  if(fd < 0)
 382:	83 c4 10             	add    $0x10,%esp
 385:	85 c0                	test   %eax,%eax
 387:	78 27                	js     3b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 389:	83 ec 08             	sub    $0x8,%esp
 38c:	ff 75 0c             	push   0xc(%ebp)
 38f:	89 c3                	mov    %eax,%ebx
 391:	50                   	push   %eax
 392:	e8 f4 00 00 00       	call   48b <fstat>
  close(fd);
 397:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 39a:	89 c6                	mov    %eax,%esi
  close(fd);
 39c:	e8 ba 00 00 00       	call   45b <close>
  return r;
 3a1:	83 c4 10             	add    $0x10,%esp
}
 3a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3a7:	89 f0                	mov    %esi,%eax
 3a9:	5b                   	pop    %ebx
 3aa:	5e                   	pop    %esi
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3b5:	eb ed                	jmp    3a4 <stat+0x34>
 3b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3be:	66 90                	xchg   %ax,%ax

000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	53                   	push   %ebx
 3c4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c7:	0f be 02             	movsbl (%edx),%eax
 3ca:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3cd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3d5:	77 1e                	ja     3f5 <atoi+0x35>
 3d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3de:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 3e0:	83 c2 01             	add    $0x1,%edx
 3e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ea:	0f be 02             	movsbl (%edx),%eax
 3ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3f0:	80 fb 09             	cmp    $0x9,%bl
 3f3:	76 eb                	jbe    3e0 <atoi+0x20>
  return n;
}
 3f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3f8:	89 c8                	mov    %ecx,%eax
 3fa:	c9                   	leave  
 3fb:	c3                   	ret    
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	8b 45 10             	mov    0x10(%ebp),%eax
 407:	8b 55 08             	mov    0x8(%ebp),%edx
 40a:	56                   	push   %esi
 40b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 40e:	85 c0                	test   %eax,%eax
 410:	7e 13                	jle    425 <memmove+0x25>
 412:	01 d0                	add    %edx,%eax
  dst = vdst;
 414:	89 d7                	mov    %edx,%edi
 416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 420:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 421:	39 f8                	cmp    %edi,%eax
 423:	75 fb                	jne    420 <memmove+0x20>
  return vdst;
}
 425:	5e                   	pop    %esi
 426:	89 d0                	mov    %edx,%eax
 428:	5f                   	pop    %edi
 429:	5d                   	pop    %ebp
 42a:	c3                   	ret    

0000042b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42b:	b8 01 00 00 00       	mov    $0x1,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <exit>:
SYSCALL(exit)
 433:	b8 02 00 00 00       	mov    $0x2,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <wait>:
SYSCALL(wait)
 43b:	b8 03 00 00 00       	mov    $0x3,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <pipe>:
SYSCALL(pipe)
 443:	b8 04 00 00 00       	mov    $0x4,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <read>:
SYSCALL(read)
 44b:	b8 05 00 00 00       	mov    $0x5,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <write>:
SYSCALL(write)
 453:	b8 10 00 00 00       	mov    $0x10,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <close>:
SYSCALL(close)
 45b:	b8 15 00 00 00       	mov    $0x15,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <kill>:
SYSCALL(kill)
 463:	b8 06 00 00 00       	mov    $0x6,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <exec>:
SYSCALL(exec)
 46b:	b8 07 00 00 00       	mov    $0x7,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <open>:
SYSCALL(open)
 473:	b8 0f 00 00 00       	mov    $0xf,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <mknod>:
SYSCALL(mknod)
 47b:	b8 11 00 00 00       	mov    $0x11,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <unlink>:
SYSCALL(unlink)
 483:	b8 12 00 00 00       	mov    $0x12,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <fstat>:
SYSCALL(fstat)
 48b:	b8 08 00 00 00       	mov    $0x8,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <link>:
SYSCALL(link)
 493:	b8 13 00 00 00       	mov    $0x13,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <mkdir>:
SYSCALL(mkdir)
 49b:	b8 14 00 00 00       	mov    $0x14,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <chdir>:
SYSCALL(chdir)
 4a3:	b8 09 00 00 00       	mov    $0x9,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <dup>:
SYSCALL(dup)
 4ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <getpid>:
SYSCALL(getpid)
 4b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <sbrk>:
SYSCALL(sbrk)
 4bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <sleep>:
SYSCALL(sleep)
 4c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <uptime>:
SYSCALL(uptime)
 4cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <wmap>:
SYSCALL(wmap)
 4d3:	b8 16 00 00 00       	mov    $0x16,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <wunmap>:
SYSCALL(wunmap)
 4db:	b8 17 00 00 00       	mov    $0x17,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <wpunmap>:
SYSCALL(wpunmap)
 4e3:	b8 18 00 00 00       	mov    $0x18,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <getwmapinfo>:
SYSCALL(getwmapinfo)
 4eb:	b8 19 00 00 00       	mov    $0x19,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <getpgdirinfo>:
SYSCALL(getpgdirinfo)
 4f3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    
 4fb:	66 90                	xchg   %ax,%ax
 4fd:	66 90                	xchg   %ax,%ax
 4ff:	90                   	nop

00000500 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 3c             	sub    $0x3c,%esp
 509:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 50c:	89 d1                	mov    %edx,%ecx
{
 50e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 511:	85 d2                	test   %edx,%edx
 513:	0f 89 7f 00 00 00    	jns    598 <printint+0x98>
 519:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 51d:	74 79                	je     598 <printint+0x98>
    neg = 1;
 51f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 526:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 528:	31 db                	xor    %ebx,%ebx
 52a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 52d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 530:	89 c8                	mov    %ecx,%eax
 532:	31 d2                	xor    %edx,%edx
 534:	89 cf                	mov    %ecx,%edi
 536:	f7 75 c4             	divl   -0x3c(%ebp)
 539:	0f b6 92 bc 0e 00 00 	movzbl 0xebc(%edx),%edx
 540:	89 45 c0             	mov    %eax,-0x40(%ebp)
 543:	89 d8                	mov    %ebx,%eax
 545:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 548:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 54b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 54e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 551:	76 dd                	jbe    530 <printint+0x30>
  if(neg)
 553:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 556:	85 c9                	test   %ecx,%ecx
 558:	74 0c                	je     566 <printint+0x66>
    buf[i++] = '-';
 55a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 55f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 561:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 566:	8b 7d b8             	mov    -0x48(%ebp),%edi
 569:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 56d:	eb 07                	jmp    576 <printint+0x76>
 56f:	90                   	nop
    putc(fd, buf[i]);
 570:	0f b6 13             	movzbl (%ebx),%edx
 573:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 576:	83 ec 04             	sub    $0x4,%esp
 579:	88 55 d7             	mov    %dl,-0x29(%ebp)
 57c:	6a 01                	push   $0x1
 57e:	56                   	push   %esi
 57f:	57                   	push   %edi
 580:	e8 ce fe ff ff       	call   453 <write>
  while(--i >= 0)
 585:	83 c4 10             	add    $0x10,%esp
 588:	39 de                	cmp    %ebx,%esi
 58a:	75 e4                	jne    570 <printint+0x70>
}
 58c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58f:	5b                   	pop    %ebx
 590:	5e                   	pop    %esi
 591:	5f                   	pop    %edi
 592:	5d                   	pop    %ebp
 593:	c3                   	ret    
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 598:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 59f:	eb 87                	jmp    528 <printint+0x28>
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5af:	90                   	nop

000005b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 5bc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 5bf:	0f b6 13             	movzbl (%ebx),%edx
 5c2:	84 d2                	test   %dl,%dl
 5c4:	74 6a                	je     630 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 5c6:	8d 45 10             	lea    0x10(%ebp),%eax
 5c9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 5cc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5cf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 5d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5d4:	eb 36                	jmp    60c <printf+0x5c>
 5d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
 5e0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5e3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 5e8:	83 f8 25             	cmp    $0x25,%eax
 5eb:	74 15                	je     602 <printf+0x52>
  write(fd, &c, 1);
 5ed:	83 ec 04             	sub    $0x4,%esp
 5f0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5f3:	6a 01                	push   $0x1
 5f5:	57                   	push   %edi
 5f6:	56                   	push   %esi
 5f7:	e8 57 fe ff ff       	call   453 <write>
 5fc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 5ff:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 602:	0f b6 13             	movzbl (%ebx),%edx
 605:	83 c3 01             	add    $0x1,%ebx
 608:	84 d2                	test   %dl,%dl
 60a:	74 24                	je     630 <printf+0x80>
    c = fmt[i] & 0xff;
 60c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 60f:	85 c9                	test   %ecx,%ecx
 611:	74 cd                	je     5e0 <printf+0x30>
      }
    } else if(state == '%'){
 613:	83 f9 25             	cmp    $0x25,%ecx
 616:	75 ea                	jne    602 <printf+0x52>
      if(c == 'd'){
 618:	83 f8 25             	cmp    $0x25,%eax
 61b:	0f 84 07 01 00 00    	je     728 <printf+0x178>
 621:	83 e8 63             	sub    $0x63,%eax
 624:	83 f8 15             	cmp    $0x15,%eax
 627:	77 17                	ja     640 <printf+0x90>
 629:	ff 24 85 64 0e 00 00 	jmp    *0xe64(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 630:	8d 65 f4             	lea    -0xc(%ebp),%esp
 633:	5b                   	pop    %ebx
 634:	5e                   	pop    %esi
 635:	5f                   	pop    %edi
 636:	5d                   	pop    %ebp
 637:	c3                   	ret    
 638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop
  write(fd, &c, 1);
 640:	83 ec 04             	sub    $0x4,%esp
 643:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 646:	6a 01                	push   $0x1
 648:	57                   	push   %edi
 649:	56                   	push   %esi
 64a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 64e:	e8 00 fe ff ff       	call   453 <write>
        putc(fd, c);
 653:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 657:	83 c4 0c             	add    $0xc,%esp
 65a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 65d:	6a 01                	push   $0x1
 65f:	57                   	push   %edi
 660:	56                   	push   %esi
 661:	e8 ed fd ff ff       	call   453 <write>
        putc(fd, c);
 666:	83 c4 10             	add    $0x10,%esp
      state = 0;
 669:	31 c9                	xor    %ecx,%ecx
 66b:	eb 95                	jmp    602 <printf+0x52>
 66d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 670:	83 ec 0c             	sub    $0xc,%esp
 673:	b9 10 00 00 00       	mov    $0x10,%ecx
 678:	6a 00                	push   $0x0
 67a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 67d:	8b 10                	mov    (%eax),%edx
 67f:	89 f0                	mov    %esi,%eax
 681:	e8 7a fe ff ff       	call   500 <printint>
        ap++;
 686:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 68a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 68d:	31 c9                	xor    %ecx,%ecx
 68f:	e9 6e ff ff ff       	jmp    602 <printf+0x52>
 694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 698:	8b 45 d0             	mov    -0x30(%ebp),%eax
 69b:	8b 10                	mov    (%eax),%edx
        ap++;
 69d:	83 c0 04             	add    $0x4,%eax
 6a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6a3:	85 d2                	test   %edx,%edx
 6a5:	0f 84 8d 00 00 00    	je     738 <printf+0x188>
        while(*s != 0){
 6ab:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 6ae:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 6b0:	84 c0                	test   %al,%al
 6b2:	0f 84 4a ff ff ff    	je     602 <printf+0x52>
 6b8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 6bb:	89 d3                	mov    %edx,%ebx
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 6c0:	83 ec 04             	sub    $0x4,%esp
          s++;
 6c3:	83 c3 01             	add    $0x1,%ebx
 6c6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6c9:	6a 01                	push   $0x1
 6cb:	57                   	push   %edi
 6cc:	56                   	push   %esi
 6cd:	e8 81 fd ff ff       	call   453 <write>
        while(*s != 0){
 6d2:	0f b6 03             	movzbl (%ebx),%eax
 6d5:	83 c4 10             	add    $0x10,%esp
 6d8:	84 c0                	test   %al,%al
 6da:	75 e4                	jne    6c0 <printf+0x110>
      state = 0;
 6dc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 6df:	31 c9                	xor    %ecx,%ecx
 6e1:	e9 1c ff ff ff       	jmp    602 <printf+0x52>
 6e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6f8:	6a 01                	push   $0x1
 6fa:	e9 7b ff ff ff       	jmp    67a <printf+0xca>
 6ff:	90                   	nop
        putc(fd, *ap);
 700:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 703:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 706:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 708:	6a 01                	push   $0x1
 70a:	57                   	push   %edi
 70b:	56                   	push   %esi
        putc(fd, *ap);
 70c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 70f:	e8 3f fd ff ff       	call   453 <write>
        ap++;
 714:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 718:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71b:	31 c9                	xor    %ecx,%ecx
 71d:	e9 e0 fe ff ff       	jmp    602 <printf+0x52>
 722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 728:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 72b:	83 ec 04             	sub    $0x4,%esp
 72e:	e9 2a ff ff ff       	jmp    65d <printf+0xad>
 733:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 737:	90                   	nop
          s = "(null)";
 738:	ba 5d 0e 00 00       	mov    $0xe5d,%edx
        while(*s != 0){
 73d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 740:	b8 28 00 00 00       	mov    $0x28,%eax
 745:	89 d3                	mov    %edx,%ebx
 747:	e9 74 ff ff ff       	jmp    6c0 <printf+0x110>
 74c:	66 90                	xchg   %ax,%ax
 74e:	66 90                	xchg   %ax,%ax

00000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 751:	a1 c4 14 00 00       	mov    0x14c4,%eax
{
 756:	89 e5                	mov    %esp,%ebp
 758:	57                   	push   %edi
 759:	56                   	push   %esi
 75a:	53                   	push   %ebx
 75b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 75e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 768:	89 c2                	mov    %eax,%edx
 76a:	8b 00                	mov    (%eax),%eax
 76c:	39 ca                	cmp    %ecx,%edx
 76e:	73 30                	jae    7a0 <free+0x50>
 770:	39 c1                	cmp    %eax,%ecx
 772:	72 04                	jb     778 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	39 c2                	cmp    %eax,%edx
 776:	72 f0                	jb     768 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 778:	8b 73 fc             	mov    -0x4(%ebx),%esi
 77b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 77e:	39 f8                	cmp    %edi,%eax
 780:	74 30                	je     7b2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 782:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 785:	8b 42 04             	mov    0x4(%edx),%eax
 788:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 78b:	39 f1                	cmp    %esi,%ecx
 78d:	74 3a                	je     7c9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 78f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 791:	5b                   	pop    %ebx
  freep = p;
 792:	89 15 c4 14 00 00    	mov    %edx,0x14c4
}
 798:	5e                   	pop    %esi
 799:	5f                   	pop    %edi
 79a:	5d                   	pop    %ebp
 79b:	c3                   	ret    
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	39 c2                	cmp    %eax,%edx
 7a2:	72 c4                	jb     768 <free+0x18>
 7a4:	39 c1                	cmp    %eax,%ecx
 7a6:	73 c0                	jae    768 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 7a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ae:	39 f8                	cmp    %edi,%eax
 7b0:	75 d0                	jne    782 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 7b2:	03 70 04             	add    0x4(%eax),%esi
 7b5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b8:	8b 02                	mov    (%edx),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 7bf:	8b 42 04             	mov    0x4(%edx),%eax
 7c2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7c5:	39 f1                	cmp    %esi,%ecx
 7c7:	75 c6                	jne    78f <free+0x3f>
    p->s.size += bp->s.size;
 7c9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 7cc:	89 15 c4 14 00 00    	mov    %edx,0x14c4
    p->s.size += bp->s.size;
 7d2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 7d5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7d8:	89 0a                	mov    %ecx,(%edx)
}
 7da:	5b                   	pop    %ebx
 7db:	5e                   	pop    %esi
 7dc:	5f                   	pop    %edi
 7dd:	5d                   	pop    %ebp
 7de:	c3                   	ret    
 7df:	90                   	nop

000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
 7e6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7ec:	8b 3d c4 14 00 00    	mov    0x14c4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	8d 70 07             	lea    0x7(%eax),%esi
 7f5:	c1 ee 03             	shr    $0x3,%esi
 7f8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 7fb:	85 ff                	test   %edi,%edi
 7fd:	0f 84 9d 00 00 00    	je     8a0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 803:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 805:	8b 4a 04             	mov    0x4(%edx),%ecx
 808:	39 f1                	cmp    %esi,%ecx
 80a:	73 6a                	jae    876 <malloc+0x96>
 80c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 811:	39 de                	cmp    %ebx,%esi
 813:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 816:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 81d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 820:	eb 17                	jmp    839 <malloc+0x59>
 822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 82a:	8b 48 04             	mov    0x4(%eax),%ecx
 82d:	39 f1                	cmp    %esi,%ecx
 82f:	73 4f                	jae    880 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 831:	8b 3d c4 14 00 00    	mov    0x14c4,%edi
 837:	89 c2                	mov    %eax,%edx
 839:	39 d7                	cmp    %edx,%edi
 83b:	75 eb                	jne    828 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 83d:	83 ec 0c             	sub    $0xc,%esp
 840:	ff 75 e4             	push   -0x1c(%ebp)
 843:	e8 73 fc ff ff       	call   4bb <sbrk>
  if(p == (char*)-1)
 848:	83 c4 10             	add    $0x10,%esp
 84b:	83 f8 ff             	cmp    $0xffffffff,%eax
 84e:	74 1c                	je     86c <malloc+0x8c>
  hp->s.size = nu;
 850:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 853:	83 ec 0c             	sub    $0xc,%esp
 856:	83 c0 08             	add    $0x8,%eax
 859:	50                   	push   %eax
 85a:	e8 f1 fe ff ff       	call   750 <free>
  return freep;
 85f:	8b 15 c4 14 00 00    	mov    0x14c4,%edx
      if((p = morecore(nunits)) == 0)
 865:	83 c4 10             	add    $0x10,%esp
 868:	85 d2                	test   %edx,%edx
 86a:	75 bc                	jne    828 <malloc+0x48>
        return 0;
  }
}
 86c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 86f:	31 c0                	xor    %eax,%eax
}
 871:	5b                   	pop    %ebx
 872:	5e                   	pop    %esi
 873:	5f                   	pop    %edi
 874:	5d                   	pop    %ebp
 875:	c3                   	ret    
    if(p->s.size >= nunits){
 876:	89 d0                	mov    %edx,%eax
 878:	89 fa                	mov    %edi,%edx
 87a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 880:	39 ce                	cmp    %ecx,%esi
 882:	74 4c                	je     8d0 <malloc+0xf0>
        p->s.size -= nunits;
 884:	29 f1                	sub    %esi,%ecx
 886:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 889:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 88c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 88f:	89 15 c4 14 00 00    	mov    %edx,0x14c4
}
 895:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 898:	83 c0 08             	add    $0x8,%eax
}
 89b:	5b                   	pop    %ebx
 89c:	5e                   	pop    %esi
 89d:	5f                   	pop    %edi
 89e:	5d                   	pop    %ebp
 89f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 8a0:	c7 05 c4 14 00 00 c8 	movl   $0x14c8,0x14c4
 8a7:	14 00 00 
    base.s.size = 0;
 8aa:	bf c8 14 00 00       	mov    $0x14c8,%edi
    base.s.ptr = freep = prevp = &base;
 8af:	c7 05 c8 14 00 00 c8 	movl   $0x14c8,0x14c8
 8b6:	14 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 8bb:	c7 05 cc 14 00 00 00 	movl   $0x0,0x14cc
 8c2:	00 00 00 
    if(p->s.size >= nunits){
 8c5:	e9 42 ff ff ff       	jmp    80c <malloc+0x2c>
 8ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 8d0:	8b 08                	mov    (%eax),%ecx
 8d2:	89 0a                	mov    %ecx,(%edx)
 8d4:	eb b9                	jmp    88f <malloc+0xaf>
 8d6:	66 90                	xchg   %ax,%ax
 8d8:	66 90                	xchg   %ax,%ax
 8da:	66 90                	xchg   %ax,%ax
 8dc:	66 90                	xchg   %ax,%ax
 8de:	66 90                	xchg   %ax,%ax

000008e0 <finish>:
#include "wmaptest.h"

// TEST HELPER
void finish() {
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp
 8e3:	83 ec 10             	sub    $0x10,%esp
    printf(1, "XV6: Test finished.\n");
 8e6:	68 cd 0e 00 00       	push   $0xecd
 8eb:	6a 01                	push   $0x1
 8ed:	e8 be fc ff ff       	call   5b0 <printf>
    exit();
 8f2:	e8 3c fb ff ff       	call   433 <exit>
 8f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8fe:	66 90                	xchg   %ax,%ax

00000900 <failed>:
}

void failed() {
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	83 ec 10             	sub    $0x10,%esp
    printf(1, "XV6: Test failed.\n");
 906:	68 e2 0e 00 00       	push   $0xee2
 90b:	6a 01                	push   $0x1
 90d:	e8 9e fc ff ff       	call   5b0 <printf>
    exit();
 912:	e8 1c fb ff ff       	call   433 <exit>
 917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 91e:	66 90                	xchg   %ax,%ax

00000920 <print_mmap_info>:
}

/**
 * @brief Prints details of a wmapinfo struct.
 */
void print_mmap_info(struct wmapinfo *info) {
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	56                   	push   %esi
 924:	53                   	push   %ebx
 925:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "XV6: ------ Total mmaps: %d\n", info->total_mmaps);
 928:	83 ec 04             	sub    $0x4,%esp
 92b:	ff 36                	push   (%esi)
 92d:	68 f5 0e 00 00       	push   $0xef5
 932:	6a 01                	push   $0x1
 934:	e8 77 fc ff ff       	call   5b0 <printf>
    for (int i = 0; i < info->total_mmaps; i++) {
 939:	8b 06                	mov    (%esi),%eax
 93b:	83 c4 10             	add    $0x10,%esp
 93e:	85 c0                	test   %eax,%eax
 940:	7e 4a                	jle    98c <print_mmap_info+0x6c>
 942:	31 db                	xor    %ebx,%ebx
 944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
            i, info->addr[i], info->length[i], info->addr[i] + info->length[i], info->flags[i], info->fd[i], info->refcnt[i], info->n_loaded_pages[i]);
 948:	8b 44 9e 04          	mov    0x4(%esi,%ebx,4),%eax
 94c:	8b 54 9e 44          	mov    0x44(%esi,%ebx,4),%edx
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
 950:	83 ec 08             	sub    $0x8,%esp
 953:	ff b4 9e 44 01 00 00 	push   0x144(%esi,%ebx,4)
 95a:	ff b4 9e 04 01 00 00 	push   0x104(%esi,%ebx,4)
 961:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
 964:	ff b4 9e c4 00 00 00 	push   0xc4(%esi,%ebx,4)
 96b:	ff b4 9e 84 00 00 00 	push   0x84(%esi,%ebx,4)
 972:	51                   	push   %ecx
 973:	52                   	push   %edx
 974:	50                   	push   %eax
 975:	53                   	push   %ebx
    for (int i = 0; i < info->total_mmaps; i++) {
 976:	83 c3 01             	add    $0x1,%ebx
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
 979:	68 38 0f 00 00       	push   $0xf38
 97e:	6a 01                	push   $0x1
 980:	e8 2b fc ff ff       	call   5b0 <printf>
    for (int i = 0; i < info->total_mmaps; i++) {
 985:	83 c4 30             	add    $0x30,%esp
 988:	39 1e                	cmp    %ebx,(%esi)
 98a:	7f bc                	jg     948 <print_mmap_info+0x28>
    }
}
 98c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 98f:	5b                   	pop    %ebx
 990:	5e                   	pop    %esi
 991:	5d                   	pop    %ebp
 992:	c3                   	ret    
 993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 99a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000009a0 <test_getwmapinfo>:

void test_getwmapinfo(struct wmapinfo *info) {
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	53                   	push   %ebx
 9a4:	83 ec 10             	sub    $0x10,%esp
 9a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int ret = getwmapinfo(info);
 9aa:	53                   	push   %ebx
 9ab:	e8 3b fb ff ff       	call   4eb <getwmapinfo>
    if (ret < 0) {
 9b0:	83 c4 10             	add    $0x10,%esp
 9b3:	85 c0                	test   %eax,%eax
 9b5:	78 0c                	js     9c3 <test_getwmapinfo+0x23>
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
        failed();
    }
    print_mmap_info(info);
 9b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 9ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 9bd:	c9                   	leave  
    print_mmap_info(info);
 9be:	e9 5d ff ff ff       	jmp    920 <print_mmap_info>
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
 9c3:	52                   	push   %edx
 9c4:	50                   	push   %eax
 9c5:	68 98 0f 00 00       	push   $0xf98
 9ca:	6a 01                	push   $0x1
 9cc:	e8 df fb ff ff       	call   5b0 <printf>
        failed();
 9d1:	e8 2a ff ff ff       	call   900 <failed>
 9d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9dd:	8d 76 00             	lea    0x0(%esi),%esi

000009e0 <print_pgdir_info>:

/**
 * @brief Prints details of a pgdirinfo struct.
 */
void print_pgdir_info(struct pgdirinfo *info) {
 9e0:	55                   	push   %ebp
 9e1:	89 e5                	mov    %esp,%ebp
 9e3:	56                   	push   %esi
 9e4:	53                   	push   %ebx
 9e5:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "XV6: Total n_upages: %d\n", info->n_upages);
 9e8:	83 ec 04             	sub    $0x4,%esp
 9eb:	ff 36                	push   (%esi)
 9ed:	68 12 0f 00 00       	push   $0xf12
 9f2:	6a 01                	push   $0x1
 9f4:	e8 b7 fb ff ff       	call   5b0 <printf>
    for (int i = 0; i < info->n_upages; i++) {
 9f9:	8b 06                	mov    (%esi),%eax
 9fb:	83 c4 10             	add    $0x10,%esp
 9fe:	85 c0                	test   %eax,%eax
 a00:	74 2b                	je     a2d <print_pgdir_info+0x4d>
 a02:	31 db                	xor    %ebx,%ebx
 a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
 a08:	83 ec 0c             	sub    $0xc,%esp
 a0b:	ff b4 9e 84 00 00 00 	push   0x84(%esi,%ebx,4)
 a12:	ff 74 9e 04          	push   0x4(%esi,%ebx,4)
 a16:	53                   	push   %ebx
    for (int i = 0; i < info->n_upages; i++) {
 a17:	83 c3 01             	add    $0x1,%ebx
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
 a1a:	68 b8 0f 00 00       	push   $0xfb8
 a1f:	6a 01                	push   $0x1
 a21:	e8 8a fb ff ff       	call   5b0 <printf>
    for (int i = 0; i < info->n_upages; i++) {
 a26:	83 c4 20             	add    $0x20,%esp
 a29:	39 1e                	cmp    %ebx,(%esi)
 a2b:	77 db                	ja     a08 <print_pgdir_info+0x28>
            i, info->va[i], info->pa[i]);
    }
}
 a2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 a30:	5b                   	pop    %ebx
 a31:	5e                   	pop    %esi
 a32:	5d                   	pop    %ebp
 a33:	c3                   	ret    
 a34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a3f:	90                   	nop

00000a40 <test_getpgdirinfo>:

void test_getpgdirinfo(struct pgdirinfo *info) {
 a40:	55                   	push   %ebp
 a41:	89 e5                	mov    %esp,%ebp
 a43:	83 ec 14             	sub    $0x14,%esp
    int ret = getpgdirinfo(info);
 a46:	ff 75 08             	push   0x8(%ebp)
 a49:	e8 a5 fa ff ff       	call   4f3 <getpgdirinfo>
    if (ret < 0) {
 a4e:	83 c4 10             	add    $0x10,%esp
 a51:	85 c0                	test   %eax,%eax
 a53:	78 02                	js     a57 <test_getpgdirinfo+0x17>
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
        failed();
    }
    // print_pgdir_info(info);
}
 a55:	c9                   	leave  
 a56:	c3                   	ret    
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
 a57:	52                   	push   %edx
 a58:	50                   	push   %eax
 a59:	68 e4 0f 00 00       	push   $0xfe4
 a5e:	6a 01                	push   $0x1
 a60:	e8 4b fb ff ff       	call   5b0 <printf>
        failed();
 a65:	e8 96 fe ff ff       	call   900 <failed>
 a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000a70 <create_small_file>:

int create_small_file(char *filename) {
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
 a73:	56                   	push   %esi
 a74:	53                   	push   %ebx

    // create a file
    int bufflen = 512 + 2;
    char buff[bufflen];
 a75:	89 e0                	mov    %esp,%eax
 a77:	39 c4                	cmp    %eax,%esp
 a79:	74 12                	je     a8d <create_small_file+0x1d>
 a7b:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 a81:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 a88:	00 
 a89:	39 c4                	cmp    %eax,%esp
 a8b:	75 ee                	jne    a7b <create_small_file+0xb>
 a8d:	81 ec 10 02 00 00    	sub    $0x210,%esp
 a93:	83 8c 24 0c 02 00 00 	orl    $0x0,0x20c(%esp)
 a9a:	00 
 a9b:	89 e3                	mov    %esp,%ebx
    int fd = open(filename, O_CREATE | O_RDWR);
 a9d:	83 ec 08             	sub    $0x8,%esp
 aa0:	68 02 02 00 00       	push   $0x202
 aa5:	ff 75 08             	push   0x8(%ebp)
 aa8:	e8 c6 f9 ff ff       	call   473 <open>
    if (fd < 0) {
 aad:	89 dc                	mov    %ebx,%esp
    int fd = open(filename, O_CREATE | O_RDWR);
 aaf:	89 c6                	mov    %eax,%esi
    if (fd < 0) {
 ab1:	85 c0                	test   %eax,%eax
 ab3:	78 5a                	js     b0f <create_small_file+0x9f>
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }

    // prepare the content to write
    for (int j = 0; j < bufflen; j++) {
 ab5:	31 c0                	xor    %eax,%eax
 ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 abe:	66 90                	xchg   %ax,%ax
        buff[j] = 'a' + (j % 4);
 ac0:	89 c2                	mov    %eax,%edx
 ac2:	83 e2 03             	and    $0x3,%edx
 ac5:	83 c2 61             	add    $0x61,%edx
 ac8:	88 14 03             	mov    %dl,(%ebx,%eax,1)
    for (int j = 0; j < bufflen; j++) {
 acb:	83 c0 01             	add    $0x1,%eax
 ace:	3d 02 02 00 00       	cmp    $0x202,%eax
 ad3:	75 eb                	jne    ac0 <create_small_file+0x50>
    }
    buff[bufflen - 1] = '\0';
    buff[bufflen - 2] = '\n';

    // write to file
    if (write(fd, buff, bufflen) != bufflen) {
 ad5:	83 ec 04             	sub    $0x4,%esp
    buff[bufflen - 2] = '\n';
 ad8:	ba 0a 00 00 00       	mov    $0xa,%edx
 add:	66 89 93 00 02 00 00 	mov    %dx,0x200(%ebx)
    if (write(fd, buff, bufflen) != bufflen) {
 ae4:	68 02 02 00 00       	push   $0x202
 ae9:	53                   	push   %ebx
 aea:	56                   	push   %esi
 aeb:	e8 63 f9 ff ff       	call   453 <write>
 af0:	83 c4 10             	add    $0x10,%esp
 af3:	3d 02 02 00 00       	cmp    $0x202,%eax
 af8:	75 2a                	jne    b24 <create_small_file+0xb4>
        printf(1, "XV6: Error: Write to file FAILED\n");
        failed();
    }

    close(fd);
 afa:	83 ec 0c             	sub    $0xc,%esp
 afd:	56                   	push   %esi
 afe:	e8 58 f9 ff ff       	call   45b <close>
    return bufflen;
}
 b03:	8d 65 f8             	lea    -0x8(%ebp),%esp
 b06:	b8 02 02 00 00       	mov    $0x202,%eax
 b0b:	5b                   	pop    %ebx
 b0c:	5e                   	pop    %esi
 b0d:	5d                   	pop    %ebp
 b0e:	c3                   	ret    
        printf(1, "XV6: Failed to create file %s\n", filename);
 b0f:	51                   	push   %ecx
 b10:	ff 75 08             	push   0x8(%ebp)
 b13:	68 08 10 00 00       	push   $0x1008
 b18:	6a 01                	push   $0x1
 b1a:	e8 91 fa ff ff       	call   5b0 <printf>
        failed();
 b1f:	e8 dc fd ff ff       	call   900 <failed>
        printf(1, "XV6: Error: Write to file FAILED\n");
 b24:	50                   	push   %eax
 b25:	50                   	push   %eax
 b26:	68 28 10 00 00       	push   $0x1028
 b2b:	6a 01                	push   $0x1
 b2d:	e8 7e fa ff ff       	call   5b0 <printf>
        failed();
 b32:	e8 c9 fd ff ff       	call   900 <failed>
 b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b3e:	66 90                	xchg   %ax,%ax

00000b40 <create_big_file>:

int create_big_file(char *filename, int N_PAGES) {
 b40:	55                   	push   %ebp
 b41:	89 e5                	mov    %esp,%ebp
 b43:	57                   	push   %edi
 b44:	56                   	push   %esi
 b45:	53                   	push   %ebx
 b46:	83 ec 1c             	sub    $0x1c,%esp
 b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // create a file
    int bufflen = 512;
    char buff[bufflen + 1];
 b4c:	89 e0                	mov    %esp,%eax
 b4e:	39 c4                	cmp    %eax,%esp
 b50:	74 12                	je     b64 <create_big_file+0x24>
 b52:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 b58:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 b5f:	00 
 b60:	39 c4                	cmp    %eax,%esp
 b62:	75 ee                	jne    b52 <create_big_file+0x12>
 b64:	81 ec 10 02 00 00    	sub    $0x210,%esp
 b6a:	83 8c 24 0c 02 00 00 	orl    $0x0,0x20c(%esp)
 b71:	00 
 b72:	89 e6                	mov    %esp,%esi
    int fd = open(filename, O_CREATE | O_RDWR);
 b74:	83 ec 08             	sub    $0x8,%esp
 b77:	68 02 02 00 00       	push   $0x202
 b7c:	53                   	push   %ebx
 b7d:	e8 f1 f8 ff ff       	call   473 <open>
    if (fd < 0) {
 b82:	89 f4                	mov    %esi,%esp
    int fd = open(filename, O_CREATE | O_RDWR);
 b84:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (fd < 0) {
 b87:	85 c0                	test   %eax,%eax
 b89:	0f 88 9c 00 00 00    	js     c2b <create_big_file+0xeb>
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }
    // write in steps as we cannot have a buffer larger than PGSIZE
    char c = 'a';
    for (int i = 0; i < N_PAGES; i++) {
 b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
 b92:	8d 9e 00 02 00 00    	lea    0x200(%esi),%ebx
 b98:	89 f7                	mov    %esi,%edi
 b9a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 ba1:	89 de                	mov    %ebx,%esi
 ba3:	85 d2                	test   %edx,%edx
 ba5:	7e 56                	jle    bfd <create_big_file+0xbd>
 ba7:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
        int m = PGSIZE / bufflen;
        for (int k = 0; k < m; k++) {
 bab:	31 d2                	xor    %edx,%edx
 bad:	8d 58 61             	lea    0x61(%eax),%ebx
            // prepare the content to write
            for (int j = 0; j < bufflen; j++) {
 bb0:	89 f8                	mov    %edi,%eax
 bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                buff[j] = c;
 bb8:	88 18                	mov    %bl,(%eax)
            for (int j = 0; j < bufflen; j++) {
 bba:	83 c0 01             	add    $0x1,%eax
 bbd:	39 f0                	cmp    %esi,%eax
 bbf:	75 f7                	jne    bb8 <create_big_file+0x78>
            }
            buff[bufflen] = '\0';
            // write to file
            if (write(fd, buff, bufflen) != bufflen) {
 bc1:	83 ec 04             	sub    $0x4,%esp
            buff[bufflen] = '\0';
 bc4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 bc7:	c6 87 00 02 00 00 00 	movb   $0x0,0x200(%edi)
            if (write(fd, buff, bufflen) != bufflen) {
 bce:	68 00 02 00 00       	push   $0x200
 bd3:	57                   	push   %edi
 bd4:	ff 75 e0             	push   -0x20(%ebp)
 bd7:	e8 77 f8 ff ff       	call   453 <write>
 bdc:	83 c4 10             	add    $0x10,%esp
 bdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 be2:	3d 00 02 00 00       	cmp    $0x200,%eax
 be7:	75 2d                	jne    c16 <create_big_file+0xd6>
        for (int k = 0; k < m; k++) {
 be9:	83 c2 01             	add    $0x1,%edx
 bec:	83 fa 08             	cmp    $0x8,%edx
 bef:	75 bf                	jne    bb0 <create_big_file+0x70>
    for (int i = 0; i < N_PAGES; i++) {
 bf1:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 bf5:	8b 45 dc             	mov    -0x24(%ebp),%eax
 bf8:	39 45 0c             	cmp    %eax,0xc(%ebp)
 bfb:	75 aa                	jne    ba7 <create_big_file+0x67>
                failed();
            }
        }
        c++; // first page is filled with 'a', second with 'b', and so on
    }
    close(fd);
 bfd:	83 ec 0c             	sub    $0xc,%esp
 c00:	ff 75 e0             	push   -0x20(%ebp)
 c03:	e8 53 f8 ff ff       	call   45b <close>
    return N_PAGES * PGSIZE;
 c08:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 c0e:	5b                   	pop    %ebx
 c0f:	5e                   	pop    %esi
    return N_PAGES * PGSIZE;
 c10:	c1 e0 0c             	shl    $0xc,%eax
}
 c13:	5f                   	pop    %edi
 c14:	5d                   	pop    %ebp
 c15:	c3                   	ret    
                printf(1, "XV6: Write to file FAILED (%d, %d)\n", i, k);
 c16:	52                   	push   %edx
 c17:	ff 75 dc             	push   -0x24(%ebp)
 c1a:	68 4c 10 00 00       	push   $0x104c
 c1f:	6a 01                	push   $0x1
 c21:	e8 8a f9 ff ff       	call   5b0 <printf>
                failed();
 c26:	e8 d5 fc ff ff       	call   900 <failed>
        printf(1, "XV6: Failed to create file %s\n", filename);
 c2b:	50                   	push   %eax
 c2c:	53                   	push   %ebx
 c2d:	68 08 10 00 00       	push   $0x1008
 c32:	6a 01                	push   $0x1
 c34:	e8 77 f9 ff ff       	call   5b0 <printf>
        failed();
 c39:	e8 c2 fc ff ff       	call   900 <failed>
 c3e:	66 90                	xchg   %ax,%ax

00000c40 <va_exists>:

void va_exists(struct pgdirinfo *info, uint va, int expected) {
 c40:	55                   	push   %ebp
    int found = 0;
    for (int i = 0; i < info->n_upages; i++) {
 c41:	31 c0                	xor    %eax,%eax
void va_exists(struct pgdirinfo *info, uint va, int expected) {
 c43:	89 e5                	mov    %esp,%ebp
 c45:	53                   	push   %ebx
 c46:	83 ec 04             	sub    $0x4,%esp
 c49:	8b 55 08             	mov    0x8(%ebp),%edx
 c4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    for (int i = 0; i < info->n_upages; i++) {
 c4f:	8b 0a                	mov    (%edx),%ecx
 c51:	85 c9                	test   %ecx,%ecx
 c53:	75 12                	jne    c67 <va_exists+0x27>
 c55:	eb 1b                	jmp    c72 <va_exists+0x32>
 c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c5e:	66 90                	xchg   %ax,%ax
 c60:	83 c0 01             	add    $0x1,%eax
 c63:	39 c1                	cmp    %eax,%ecx
 c65:	74 19                	je     c80 <va_exists+0x40>
        if (info->va[i] == va) {
 c67:	39 5c 82 04          	cmp    %ebx,0x4(%edx,%eax,4)
 c6b:	75 f3                	jne    c60 <va_exists+0x20>
            found = 1;
 c6d:	b8 01 00 00 00       	mov    $0x1,%eax
            break;
        }
    }
    if (found != expected) {
 c72:	3b 45 10             	cmp    0x10(%ebp),%eax
 c75:	75 0d                	jne    c84 <va_exists+0x44>
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
        failed();
    }
}
 c77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 c7a:	c9                   	leave  
 c7b:	c3                   	ret    
 c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int found = 0;
 c80:	31 c0                	xor    %eax,%eax
 c82:	eb ee                	jmp    c72 <va_exists+0x32>
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
 c84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 c88:	ba 2b 0f 00 00       	mov    $0xf2b,%edx
 c8d:	b8 2f 0f 00 00       	mov    $0xf2f,%eax
 c92:	0f 44 c2             	cmove  %edx,%eax
 c95:	50                   	push   %eax
 c96:	53                   	push   %ebx
 c97:	68 70 10 00 00       	push   $0x1070
 c9c:	6a 01                	push   $0x1
 c9e:	e8 0d f9 ff ff       	call   5b0 <printf>
        failed();
 ca3:	e8 58 fc ff ff       	call   900 <failed>
