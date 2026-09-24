
_test6:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
  struct rusage before, after;
  int i;
  
  printf(1, "TEST_6 START: System time increase test\n");
  
  getrusage(&before);
   e:	bb 88 13 00 00       	mov    $0x1388,%ebx
{
  13:	51                   	push   %ecx
  14:	83 ec 28             	sub    $0x28,%esp
  printf(1, "TEST_6 START: System time increase test\n");
  17:	68 68 07 00 00       	push   $0x768
  1c:	6a 01                	push   $0x1
  1e:	e8 1d 04 00 00       	call   440 <printf>
  getrusage(&before);
  23:	8d 45 d8             	lea    -0x28(%ebp),%eax
  26:	89 04 24             	mov    %eax,(%esp)
  29:	e8 55 03 00 00       	call   383 <getrusage>
  2e:	83 c4 10             	add    $0x10,%esp
  31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  
  for(i = 0; i < 5000; i++){
    getpid();
  38:	e8 26 03 00 00       	call   363 <getpid>
  for(i = 0; i < 5000; i++){
  3d:	83 eb 01             	sub    $0x1,%ebx
  40:	75 f6                	jne    38 <main+0x38>
  }
  
  getrusage(&after);
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	8d 45 e8             	lea    -0x18(%ebp),%eax
  48:	50                   	push   %eax
  49:	e8 35 03 00 00       	call   383 <getrusage>
  
  if(after.stime <= before.stime){
  4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  54:	83 c4 10             	add    $0x10,%esp
  57:	39 c2                	cmp    %eax,%edx
  59:	77 13                	ja     6e <main+0x6e>
    printf(1, "TEST_6 FAIL: stime did not increase (%d -> %d)\n",
  5b:	52                   	push   %edx
  5c:	50                   	push   %eax
  5d:	68 94 07 00 00       	push   $0x794
  62:	6a 01                	push   $0x1
  64:	e8 d7 03 00 00       	call   440 <printf>
           before.stime, after.stime);
    exit();
  69:	e8 75 02 00 00       	call   2e3 <exit>
  }
  
  printf(1, "TEST_6 PASS: stime behavior checked\n",
  6e:	52                   	push   %edx
  6f:	50                   	push   %eax
  70:	68 c4 07 00 00       	push   $0x7c4
  75:	6a 01                	push   $0x1
  77:	e8 c4 03 00 00       	call   440 <printf>
         before.stime, after.stime);
  exit();
  7c:	e8 62 02 00 00       	call   2e3 <exit>
  81:	66 90                	xchg   %ax,%ax
  83:	66 90                	xchg   %ax,%ax
  85:	66 90                	xchg   %ax,%ax
  87:	66 90                	xchg   %ax,%ax
  89:	66 90                	xchg   %ax,%ax
  8b:	66 90                	xchg   %ax,%ax
  8d:	66 90                	xchg   %ax,%ax
  8f:	90                   	nop

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  90:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  91:	31 c0                	xor    %eax,%eax
{
  93:	89 e5                	mov    %esp,%ebp
  95:	53                   	push   %ebx
  96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  99:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  a7:	83 c0 01             	add    $0x1,%eax
  aa:	84 d2                	test   %dl,%dl
  ac:	75 f2                	jne    a0 <strcpy+0x10>
    ;
  return os;
}
  ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b1:	89 c8                	mov    %ecx,%eax
  b3:	c9                   	leave  
  b4:	c3                   	ret    
  b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	53                   	push   %ebx
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
  c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ca:	0f b6 02             	movzbl (%edx),%eax
  cd:	84 c0                	test   %al,%al
  cf:	75 17                	jne    e8 <strcmp+0x28>
  d1:	eb 3a                	jmp    10d <strcmp+0x4d>
  d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  d7:	90                   	nop
  d8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  dc:	83 c2 01             	add    $0x1,%edx
  df:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  e2:	84 c0                	test   %al,%al
  e4:	74 1a                	je     100 <strcmp+0x40>
    p++, q++;
  e6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  e8:	0f b6 19             	movzbl (%ecx),%ebx
  eb:	38 c3                	cmp    %al,%bl
  ed:	74 e9                	je     d8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  ef:	29 d8                	sub    %ebx,%eax
}
  f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  f4:	c9                   	leave  
  f5:	c3                   	ret    
  f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 100:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 104:	31 c0                	xor    %eax,%eax
 106:	29 d8                	sub    %ebx,%eax
}
 108:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 10b:	c9                   	leave  
 10c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 10d:	0f b6 19             	movzbl (%ecx),%ebx
 110:	31 c0                	xor    %eax,%eax
 112:	eb db                	jmp    ef <strcmp+0x2f>
 114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 11f:	90                   	nop

00000120 <strlen>:

uint
strlen(const char *s)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 126:	80 3a 00             	cmpb   $0x0,(%edx)
 129:	74 15                	je     140 <strlen+0x20>
 12b:	31 c0                	xor    %eax,%eax
 12d:	8d 76 00             	lea    0x0(%esi),%esi
 130:	83 c0 01             	add    $0x1,%eax
 133:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 137:	89 c1                	mov    %eax,%ecx
 139:	75 f5                	jne    130 <strlen+0x10>
    ;
  return n;
}
 13b:	89 c8                	mov    %ecx,%eax
 13d:	5d                   	pop    %ebp
 13e:	c3                   	ret    
 13f:	90                   	nop
  for(n = 0; s[n]; n++)
 140:	31 c9                	xor    %ecx,%ecx
}
 142:	5d                   	pop    %ebp
 143:	89 c8                	mov    %ecx,%eax
 145:	c3                   	ret    
 146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14d:	8d 76 00             	lea    0x0(%esi),%esi

00000150 <memset>:

void*
memset(void *dst, int c, uint n)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 157:	8b 4d 10             	mov    0x10(%ebp),%ecx
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	89 d7                	mov    %edx,%edi
 15f:	fc                   	cld    
 160:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 162:	8b 7d fc             	mov    -0x4(%ebp),%edi
 165:	89 d0                	mov    %edx,%eax
 167:	c9                   	leave  
 168:	c3                   	ret    
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000170 <strchr>:

char*
strchr(const char *s, char c)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 17a:	0f b6 10             	movzbl (%eax),%edx
 17d:	84 d2                	test   %dl,%dl
 17f:	75 12                	jne    193 <strchr+0x23>
 181:	eb 1d                	jmp    1a0 <strchr+0x30>
 183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 187:	90                   	nop
 188:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 18c:	83 c0 01             	add    $0x1,%eax
 18f:	84 d2                	test   %dl,%dl
 191:	74 0d                	je     1a0 <strchr+0x30>
    if(*s == c)
 193:	38 d1                	cmp    %dl,%cl
 195:	75 f1                	jne    188 <strchr+0x18>
      return (char*)s;
  return 0;
}
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1a0:	31 c0                	xor    %eax,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    
 1a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1af:	90                   	nop

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1b5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1b8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1b9:	31 db                	xor    %ebx,%ebx
{
 1bb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1be:	eb 27                	jmp    1e7 <gets+0x37>
    cc = read(0, &c, 1);
 1c0:	83 ec 04             	sub    $0x4,%esp
 1c3:	6a 01                	push   $0x1
 1c5:	57                   	push   %edi
 1c6:	6a 00                	push   $0x0
 1c8:	e8 2e 01 00 00       	call   2fb <read>
    if(cc < 1)
 1cd:	83 c4 10             	add    $0x10,%esp
 1d0:	85 c0                	test   %eax,%eax
 1d2:	7e 1d                	jle    1f1 <gets+0x41>
      break;
    buf[i++] = c;
 1d4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1d8:	8b 55 08             	mov    0x8(%ebp),%edx
 1db:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1df:	3c 0a                	cmp    $0xa,%al
 1e1:	74 1d                	je     200 <gets+0x50>
 1e3:	3c 0d                	cmp    $0xd,%al
 1e5:	74 19                	je     200 <gets+0x50>
  for(i=0; i+1 < max; ){
 1e7:	89 de                	mov    %ebx,%esi
 1e9:	83 c3 01             	add    $0x1,%ebx
 1ec:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ef:	7c cf                	jl     1c0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1fb:	5b                   	pop    %ebx
 1fc:	5e                   	pop    %esi
 1fd:	5f                   	pop    %edi
 1fe:	5d                   	pop    %ebp
 1ff:	c3                   	ret    
  buf[i] = '\0';
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	89 de                	mov    %ebx,%esi
 205:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 209:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20c:	5b                   	pop    %ebx
 20d:	5e                   	pop    %esi
 20e:	5f                   	pop    %edi
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret    
 211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21f:	90                   	nop

00000220 <stat>:

int
stat(const char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 225:	83 ec 08             	sub    $0x8,%esp
 228:	6a 00                	push   $0x0
 22a:	ff 75 08             	push   0x8(%ebp)
 22d:	e8 f1 00 00 00       	call   323 <open>
  if(fd < 0)
 232:	83 c4 10             	add    $0x10,%esp
 235:	85 c0                	test   %eax,%eax
 237:	78 27                	js     260 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	ff 75 0c             	push   0xc(%ebp)
 23f:	89 c3                	mov    %eax,%ebx
 241:	50                   	push   %eax
 242:	e8 f4 00 00 00       	call   33b <fstat>
  close(fd);
 247:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 24a:	89 c6                	mov    %eax,%esi
  close(fd);
 24c:	e8 ba 00 00 00       	call   30b <close>
  return r;
 251:	83 c4 10             	add    $0x10,%esp
}
 254:	8d 65 f8             	lea    -0x8(%ebp),%esp
 257:	89 f0                	mov    %esi,%eax
 259:	5b                   	pop    %ebx
 25a:	5e                   	pop    %esi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
 25d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 260:	be ff ff ff ff       	mov    $0xffffffff,%esi
 265:	eb ed                	jmp    254 <stat+0x34>
 267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26e:	66 90                	xchg   %ax,%ax

00000270 <atoi>:

int
atoi(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 277:	0f be 02             	movsbl (%edx),%eax
 27a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 27d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 280:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 285:	77 1e                	ja     2a5 <atoi+0x35>
 287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 290:	83 c2 01             	add    $0x1,%edx
 293:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 296:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 29a:	0f be 02             	movsbl (%edx),%eax
 29d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2a0:	80 fb 09             	cmp    $0x9,%bl
 2a3:	76 eb                	jbe    290 <atoi+0x20>
  return n;
}
 2a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2a8:	89 c8                	mov    %ecx,%eax
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	8b 45 10             	mov    0x10(%ebp),%eax
 2b7:	8b 55 08             	mov    0x8(%ebp),%edx
 2ba:	56                   	push   %esi
 2bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2be:	85 c0                	test   %eax,%eax
 2c0:	7e 13                	jle    2d5 <memmove+0x25>
 2c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2c4:	89 d7                	mov    %edx,%edi
 2c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2d0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2d1:	39 f8                	cmp    %edi,%eax
 2d3:	75 fb                	jne    2d0 <memmove+0x20>
  return vdst;
}
 2d5:	5e                   	pop    %esi
 2d6:	89 d0                	mov    %edx,%eax
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    

000002db <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2db:	b8 01 00 00 00       	mov    $0x1,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <exit>:
SYSCALL(exit)
 2e3:	b8 02 00 00 00       	mov    $0x2,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <wait>:
SYSCALL(wait)
 2eb:	b8 03 00 00 00       	mov    $0x3,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <pipe>:
SYSCALL(pipe)
 2f3:	b8 04 00 00 00       	mov    $0x4,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <read>:
SYSCALL(read)
 2fb:	b8 05 00 00 00       	mov    $0x5,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <write>:
SYSCALL(write)
 303:	b8 10 00 00 00       	mov    $0x10,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <close>:
SYSCALL(close)
 30b:	b8 15 00 00 00       	mov    $0x15,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <kill>:
SYSCALL(kill)
 313:	b8 06 00 00 00       	mov    $0x6,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <exec>:
SYSCALL(exec)
 31b:	b8 07 00 00 00       	mov    $0x7,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <open>:
SYSCALL(open)
 323:	b8 0f 00 00 00       	mov    $0xf,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <mknod>:
SYSCALL(mknod)
 32b:	b8 11 00 00 00       	mov    $0x11,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <unlink>:
SYSCALL(unlink)
 333:	b8 12 00 00 00       	mov    $0x12,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <fstat>:
SYSCALL(fstat)
 33b:	b8 08 00 00 00       	mov    $0x8,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <link>:
SYSCALL(link)
 343:	b8 13 00 00 00       	mov    $0x13,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <mkdir>:
SYSCALL(mkdir)
 34b:	b8 14 00 00 00       	mov    $0x14,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <chdir>:
SYSCALL(chdir)
 353:	b8 09 00 00 00       	mov    $0x9,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <dup>:
SYSCALL(dup)
 35b:	b8 0a 00 00 00       	mov    $0xa,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <getpid>:
SYSCALL(getpid)
 363:	b8 0b 00 00 00       	mov    $0xb,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <sbrk>:
SYSCALL(sbrk)
 36b:	b8 0c 00 00 00       	mov    $0xc,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <sleep>:
SYSCALL(sleep)
 373:	b8 0d 00 00 00       	mov    $0xd,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <uptime>:
SYSCALL(uptime)
 37b:	b8 0e 00 00 00       	mov    $0xe,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <getrusage>:
SYSCALL(getrusage)
 383:	b8 16 00 00 00       	mov    $0x16,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    
 38b:	66 90                	xchg   %ax,%ax
 38d:	66 90                	xchg   %ax,%ax
 38f:	90                   	nop

00000390 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	83 ec 3c             	sub    $0x3c,%esp
 399:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 39c:	89 d1                	mov    %edx,%ecx
{
 39e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 3a1:	85 d2                	test   %edx,%edx
 3a3:	0f 89 7f 00 00 00    	jns    428 <printint+0x98>
 3a9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3ad:	74 79                	je     428 <printint+0x98>
    neg = 1;
 3af:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3b6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3b8:	31 db                	xor    %ebx,%ebx
 3ba:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3c0:	89 c8                	mov    %ecx,%eax
 3c2:	31 d2                	xor    %edx,%edx
 3c4:	89 cf                	mov    %ecx,%edi
 3c6:	f7 75 c4             	divl   -0x3c(%ebp)
 3c9:	0f b6 92 48 08 00 00 	movzbl 0x848(%edx),%edx
 3d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3d3:	89 d8                	mov    %ebx,%eax
 3d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 3d8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 3db:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 3de:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 3e1:	76 dd                	jbe    3c0 <printint+0x30>
  if(neg)
 3e3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3e6:	85 c9                	test   %ecx,%ecx
 3e8:	74 0c                	je     3f6 <printint+0x66>
    buf[i++] = '-';
 3ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 3ef:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 3f1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 3f6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3f9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3fd:	eb 07                	jmp    406 <printint+0x76>
 3ff:	90                   	nop
    putc(fd, buf[i]);
 400:	0f b6 13             	movzbl (%ebx),%edx
 403:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 406:	83 ec 04             	sub    $0x4,%esp
 409:	88 55 d7             	mov    %dl,-0x29(%ebp)
 40c:	6a 01                	push   $0x1
 40e:	56                   	push   %esi
 40f:	57                   	push   %edi
 410:	e8 ee fe ff ff       	call   303 <write>
  while(--i >= 0)
 415:	83 c4 10             	add    $0x10,%esp
 418:	39 de                	cmp    %ebx,%esi
 41a:	75 e4                	jne    400 <printint+0x70>
}
 41c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41f:	5b                   	pop    %ebx
 420:	5e                   	pop    %esi
 421:	5f                   	pop    %edi
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    
 424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 428:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 42f:	eb 87                	jmp    3b8 <printint+0x28>
 431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop

00000440 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 449:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 44c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 44f:	0f b6 13             	movzbl (%ebx),%edx
 452:	84 d2                	test   %dl,%dl
 454:	74 6a                	je     4c0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 456:	8d 45 10             	lea    0x10(%ebp),%eax
 459:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 45c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 45f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 461:	89 45 d0             	mov    %eax,-0x30(%ebp)
 464:	eb 36                	jmp    49c <printf+0x5c>
 466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46d:	8d 76 00             	lea    0x0(%esi),%esi
 470:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 473:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 478:	83 f8 25             	cmp    $0x25,%eax
 47b:	74 15                	je     492 <printf+0x52>
  write(fd, &c, 1);
 47d:	83 ec 04             	sub    $0x4,%esp
 480:	88 55 e7             	mov    %dl,-0x19(%ebp)
 483:	6a 01                	push   $0x1
 485:	57                   	push   %edi
 486:	56                   	push   %esi
 487:	e8 77 fe ff ff       	call   303 <write>
 48c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 48f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 492:	0f b6 13             	movzbl (%ebx),%edx
 495:	83 c3 01             	add    $0x1,%ebx
 498:	84 d2                	test   %dl,%dl
 49a:	74 24                	je     4c0 <printf+0x80>
    c = fmt[i] & 0xff;
 49c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 49f:	85 c9                	test   %ecx,%ecx
 4a1:	74 cd                	je     470 <printf+0x30>
      }
    } else if(state == '%'){
 4a3:	83 f9 25             	cmp    $0x25,%ecx
 4a6:	75 ea                	jne    492 <printf+0x52>
      if(c == 'd'){
 4a8:	83 f8 25             	cmp    $0x25,%eax
 4ab:	0f 84 07 01 00 00    	je     5b8 <printf+0x178>
 4b1:	83 e8 63             	sub    $0x63,%eax
 4b4:	83 f8 15             	cmp    $0x15,%eax
 4b7:	77 17                	ja     4d0 <printf+0x90>
 4b9:	ff 24 85 f0 07 00 00 	jmp    *0x7f0(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c3:	5b                   	pop    %ebx
 4c4:	5e                   	pop    %esi
 4c5:	5f                   	pop    %edi
 4c6:	5d                   	pop    %ebp
 4c7:	c3                   	ret    
 4c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop
  write(fd, &c, 1);
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 4d6:	6a 01                	push   $0x1
 4d8:	57                   	push   %edi
 4d9:	56                   	push   %esi
 4da:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4de:	e8 20 fe ff ff       	call   303 <write>
        putc(fd, c);
 4e3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 4e7:	83 c4 0c             	add    $0xc,%esp
 4ea:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4ed:	6a 01                	push   $0x1
 4ef:	57                   	push   %edi
 4f0:	56                   	push   %esi
 4f1:	e8 0d fe ff ff       	call   303 <write>
        putc(fd, c);
 4f6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f9:	31 c9                	xor    %ecx,%ecx
 4fb:	eb 95                	jmp    492 <printf+0x52>
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 500:	83 ec 0c             	sub    $0xc,%esp
 503:	b9 10 00 00 00       	mov    $0x10,%ecx
 508:	6a 00                	push   $0x0
 50a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 50d:	8b 10                	mov    (%eax),%edx
 50f:	89 f0                	mov    %esi,%eax
 511:	e8 7a fe ff ff       	call   390 <printint>
        ap++;
 516:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 51a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51d:	31 c9                	xor    %ecx,%ecx
 51f:	e9 6e ff ff ff       	jmp    492 <printf+0x52>
 524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 528:	8b 45 d0             	mov    -0x30(%ebp),%eax
 52b:	8b 10                	mov    (%eax),%edx
        ap++;
 52d:	83 c0 04             	add    $0x4,%eax
 530:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 533:	85 d2                	test   %edx,%edx
 535:	0f 84 8d 00 00 00    	je     5c8 <printf+0x188>
        while(*s != 0){
 53b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 53e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 540:	84 c0                	test   %al,%al
 542:	0f 84 4a ff ff ff    	je     492 <printf+0x52>
 548:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 54b:	89 d3                	mov    %edx,%ebx
 54d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 550:	83 ec 04             	sub    $0x4,%esp
          s++;
 553:	83 c3 01             	add    $0x1,%ebx
 556:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 559:	6a 01                	push   $0x1
 55b:	57                   	push   %edi
 55c:	56                   	push   %esi
 55d:	e8 a1 fd ff ff       	call   303 <write>
        while(*s != 0){
 562:	0f b6 03             	movzbl (%ebx),%eax
 565:	83 c4 10             	add    $0x10,%esp
 568:	84 c0                	test   %al,%al
 56a:	75 e4                	jne    550 <printf+0x110>
      state = 0;
 56c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 56f:	31 c9                	xor    %ecx,%ecx
 571:	e9 1c ff ff ff       	jmp    492 <printf+0x52>
 576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 580:	83 ec 0c             	sub    $0xc,%esp
 583:	b9 0a 00 00 00       	mov    $0xa,%ecx
 588:	6a 01                	push   $0x1
 58a:	e9 7b ff ff ff       	jmp    50a <printf+0xca>
 58f:	90                   	nop
        putc(fd, *ap);
 590:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 593:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 596:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 598:	6a 01                	push   $0x1
 59a:	57                   	push   %edi
 59b:	56                   	push   %esi
        putc(fd, *ap);
 59c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 59f:	e8 5f fd ff ff       	call   303 <write>
        ap++;
 5a4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5a8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ab:	31 c9                	xor    %ecx,%ecx
 5ad:	e9 e0 fe ff ff       	jmp    492 <printf+0x52>
 5b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 5b8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5bb:	83 ec 04             	sub    $0x4,%esp
 5be:	e9 2a ff ff ff       	jmp    4ed <printf+0xad>
 5c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5c7:	90                   	nop
          s = "(null)";
 5c8:	ba e9 07 00 00       	mov    $0x7e9,%edx
        while(*s != 0){
 5cd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5d0:	b8 28 00 00 00       	mov    $0x28,%eax
 5d5:	89 d3                	mov    %edx,%ebx
 5d7:	e9 74 ff ff ff       	jmp    550 <printf+0x110>
 5dc:	66 90                	xchg   %ax,%ax
 5de:	66 90                	xchg   %ax,%ax

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	a1 f4 0a 00 00       	mov    0xaf4,%eax
{
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	53                   	push   %ebx
 5eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f8:	89 c2                	mov    %eax,%edx
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	39 ca                	cmp    %ecx,%edx
 5fe:	73 30                	jae    630 <free+0x50>
 600:	39 c1                	cmp    %eax,%ecx
 602:	72 04                	jb     608 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 604:	39 c2                	cmp    %eax,%edx
 606:	72 f0                	jb     5f8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 608:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60e:	39 f8                	cmp    %edi,%eax
 610:	74 30                	je     642 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 612:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 615:	8b 42 04             	mov    0x4(%edx),%eax
 618:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 61b:	39 f1                	cmp    %esi,%ecx
 61d:	74 3a                	je     659 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 61f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 621:	5b                   	pop    %ebx
  freep = p;
 622:	89 15 f4 0a 00 00    	mov    %edx,0xaf4
}
 628:	5e                   	pop    %esi
 629:	5f                   	pop    %edi
 62a:	5d                   	pop    %ebp
 62b:	c3                   	ret    
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 630:	39 c2                	cmp    %eax,%edx
 632:	72 c4                	jb     5f8 <free+0x18>
 634:	39 c1                	cmp    %eax,%ecx
 636:	73 c0                	jae    5f8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 638:	8b 73 fc             	mov    -0x4(%ebx),%esi
 63b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 63e:	39 f8                	cmp    %edi,%eax
 640:	75 d0                	jne    612 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 642:	03 70 04             	add    0x4(%eax),%esi
 645:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 648:	8b 02                	mov    (%edx),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 64f:	8b 42 04             	mov    0x4(%edx),%eax
 652:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 655:	39 f1                	cmp    %esi,%ecx
 657:	75 c6                	jne    61f <free+0x3f>
    p->s.size += bp->s.size;
 659:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 65c:	89 15 f4 0a 00 00    	mov    %edx,0xaf4
    p->s.size += bp->s.size;
 662:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 665:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 668:	89 0a                	mov    %ecx,(%edx)
}
 66a:	5b                   	pop    %ebx
 66b:	5e                   	pop    %esi
 66c:	5f                   	pop    %edi
 66d:	5d                   	pop    %ebp
 66e:	c3                   	ret    
 66f:	90                   	nop

00000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 679:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 67c:	8b 3d f4 0a 00 00    	mov    0xaf4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 682:	8d 70 07             	lea    0x7(%eax),%esi
 685:	c1 ee 03             	shr    $0x3,%esi
 688:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 68b:	85 ff                	test   %edi,%edi
 68d:	0f 84 9d 00 00 00    	je     730 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 693:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 695:	8b 4a 04             	mov    0x4(%edx),%ecx
 698:	39 f1                	cmp    %esi,%ecx
 69a:	73 6a                	jae    706 <malloc+0x96>
 69c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6a1:	39 de                	cmp    %ebx,%esi
 6a3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6a6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6b0:	eb 17                	jmp    6c9 <malloc+0x59>
 6b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6ba:	8b 48 04             	mov    0x4(%eax),%ecx
 6bd:	39 f1                	cmp    %esi,%ecx
 6bf:	73 4f                	jae    710 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6c1:	8b 3d f4 0a 00 00    	mov    0xaf4,%edi
 6c7:	89 c2                	mov    %eax,%edx
 6c9:	39 d7                	cmp    %edx,%edi
 6cb:	75 eb                	jne    6b8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6cd:	83 ec 0c             	sub    $0xc,%esp
 6d0:	ff 75 e4             	push   -0x1c(%ebp)
 6d3:	e8 93 fc ff ff       	call   36b <sbrk>
  if(p == (char*)-1)
 6d8:	83 c4 10             	add    $0x10,%esp
 6db:	83 f8 ff             	cmp    $0xffffffff,%eax
 6de:	74 1c                	je     6fc <malloc+0x8c>
  hp->s.size = nu;
 6e0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6e3:	83 ec 0c             	sub    $0xc,%esp
 6e6:	83 c0 08             	add    $0x8,%eax
 6e9:	50                   	push   %eax
 6ea:	e8 f1 fe ff ff       	call   5e0 <free>
  return freep;
 6ef:	8b 15 f4 0a 00 00    	mov    0xaf4,%edx
      if((p = morecore(nunits)) == 0)
 6f5:	83 c4 10             	add    $0x10,%esp
 6f8:	85 d2                	test   %edx,%edx
 6fa:	75 bc                	jne    6b8 <malloc+0x48>
        return 0;
  }
}
 6fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6ff:	31 c0                	xor    %eax,%eax
}
 701:	5b                   	pop    %ebx
 702:	5e                   	pop    %esi
 703:	5f                   	pop    %edi
 704:	5d                   	pop    %ebp
 705:	c3                   	ret    
    if(p->s.size >= nunits){
 706:	89 d0                	mov    %edx,%eax
 708:	89 fa                	mov    %edi,%edx
 70a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 710:	39 ce                	cmp    %ecx,%esi
 712:	74 4c                	je     760 <malloc+0xf0>
        p->s.size -= nunits;
 714:	29 f1                	sub    %esi,%ecx
 716:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 719:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 71c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 71f:	89 15 f4 0a 00 00    	mov    %edx,0xaf4
}
 725:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 728:	83 c0 08             	add    $0x8,%eax
}
 72b:	5b                   	pop    %ebx
 72c:	5e                   	pop    %esi
 72d:	5f                   	pop    %edi
 72e:	5d                   	pop    %ebp
 72f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 730:	c7 05 f4 0a 00 00 f8 	movl   $0xaf8,0xaf4
 737:	0a 00 00 
    base.s.size = 0;
 73a:	bf f8 0a 00 00       	mov    $0xaf8,%edi
    base.s.ptr = freep = prevp = &base;
 73f:	c7 05 f8 0a 00 00 f8 	movl   $0xaf8,0xaf8
 746:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 749:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 74b:	c7 05 fc 0a 00 00 00 	movl   $0x0,0xafc
 752:	00 00 00 
    if(p->s.size >= nunits){
 755:	e9 42 ff ff ff       	jmp    69c <malloc+0x2c>
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 760:	8b 08                	mov    (%eax),%ecx
 762:	89 0a                	mov    %ecx,(%edx)
 764:	eb b9                	jmp    71f <malloc+0xaf>
