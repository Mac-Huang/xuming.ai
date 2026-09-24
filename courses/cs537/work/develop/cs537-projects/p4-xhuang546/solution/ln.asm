
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
  if(argc != 3){
   a:	83 39 03             	cmpl   $0x3,(%ecx)
{
   d:	55                   	push   %ebp
   e:	89 e5                	mov    %esp,%ebp
  10:	53                   	push   %ebx
  11:	51                   	push   %ecx
  12:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  15:	74 13                	je     2a <main+0x2a>
    printf(2, "Usage: ln old new\n");
  17:	52                   	push   %edx
  18:	52                   	push   %edx
  19:	68 28 0b 00 00       	push   $0xb28
  1e:	6a 02                	push   $0x2
  20:	e8 0b 04 00 00       	call   430 <printf>
    exit();
  25:	e8 89 02 00 00       	call   2b3 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2a:	50                   	push   %eax
  2b:	50                   	push   %eax
  2c:	ff 73 08             	push   0x8(%ebx)
  2f:	ff 73 04             	push   0x4(%ebx)
  32:	e8 dc 02 00 00       	call   313 <link>
  37:	83 c4 10             	add    $0x10,%esp
  3a:	85 c0                	test   %eax,%eax
  3c:	78 05                	js     43 <main+0x43>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  3e:	e8 70 02 00 00       	call   2b3 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  43:	ff 73 08             	push   0x8(%ebx)
  46:	ff 73 04             	push   0x4(%ebx)
  49:	68 3b 0b 00 00       	push   $0xb3b
  4e:	6a 02                	push   $0x2
  50:	e8 db 03 00 00       	call   430 <printf>
  55:	83 c4 10             	add    $0x10,%esp
  58:	eb e4                	jmp    3e <main+0x3e>
  5a:	66 90                	xchg   %ax,%ax
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  60:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  61:	31 c0                	xor    %eax,%eax
{
  63:	89 e5                	mov    %esp,%ebp
  65:	53                   	push   %ebx
  66:	8b 4d 08             	mov    0x8(%ebp),%ecx
  69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  70:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  74:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  77:	83 c0 01             	add    $0x1,%eax
  7a:	84 d2                	test   %dl,%dl
  7c:	75 f2                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  81:	89 c8                	mov    %ecx,%eax
  83:	c9                   	leave  
  84:	c3                   	ret    
  85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 55 08             	mov    0x8(%ebp),%edx
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  9a:	0f b6 02             	movzbl (%edx),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 17                	jne    b8 <strcmp+0x28>
  a1:	eb 3a                	jmp    dd <strcmp+0x4d>
  a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a7:	90                   	nop
  a8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  ac:	83 c2 01             	add    $0x1,%edx
  af:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  b2:	84 c0                	test   %al,%al
  b4:	74 1a                	je     d0 <strcmp+0x40>
    p++, q++;
  b6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  b8:	0f b6 19             	movzbl (%ecx),%ebx
  bb:	38 c3                	cmp    %al,%bl
  bd:	74 e9                	je     a8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  bf:	29 d8                	sub    %ebx,%eax
}
  c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  c4:	c9                   	leave  
  c5:	c3                   	ret    
  c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
  d0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  d4:	31 c0                	xor    %eax,%eax
  d6:	29 d8                	sub    %ebx,%eax
}
  d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  db:	c9                   	leave  
  dc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
  dd:	0f b6 19             	movzbl (%ecx),%ebx
  e0:	31 c0                	xor    %eax,%eax
  e2:	eb db                	jmp    bf <strcmp+0x2f>
  e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ef:	90                   	nop

000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  f6:	80 3a 00             	cmpb   $0x0,(%edx)
  f9:	74 15                	je     110 <strlen+0x20>
  fb:	31 c0                	xor    %eax,%eax
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	83 c0 01             	add    $0x1,%eax
 103:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 107:	89 c1                	mov    %eax,%ecx
 109:	75 f5                	jne    100 <strlen+0x10>
    ;
  return n;
}
 10b:	89 c8                	mov    %ecx,%eax
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret    
 10f:	90                   	nop
  for(n = 0; s[n]; n++)
 110:	31 c9                	xor    %ecx,%ecx
}
 112:	5d                   	pop    %ebp
 113:	89 c8                	mov    %ecx,%eax
 115:	c3                   	ret    
 116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	8b 7d fc             	mov    -0x4(%ebp),%edi
 135:	89 d0                	mov    %edx,%eax
 137:	c9                   	leave  
 138:	c3                   	ret    
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	75 12                	jne    163 <strchr+0x23>
 151:	eb 1d                	jmp    170 <strchr+0x30>
 153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 157:	90                   	nop
 158:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 15c:	83 c0 01             	add    $0x1,%eax
 15f:	84 d2                	test   %dl,%dl
 161:	74 0d                	je     170 <strchr+0x30>
    if(*s == c)
 163:	38 d1                	cmp    %dl,%cl
 165:	75 f1                	jne    158 <strchr+0x18>
      return (char*)s;
  return 0;
}
 167:	5d                   	pop    %ebp
 168:	c3                   	ret    
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 170:	31 c0                	xor    %eax,%eax
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
 174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 17f:	90                   	nop

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 185:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 188:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 189:	31 db                	xor    %ebx,%ebx
{
 18b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 18e:	eb 27                	jmp    1b7 <gets+0x37>
    cc = read(0, &c, 1);
 190:	83 ec 04             	sub    $0x4,%esp
 193:	6a 01                	push   $0x1
 195:	57                   	push   %edi
 196:	6a 00                	push   $0x0
 198:	e8 2e 01 00 00       	call   2cb <read>
    if(cc < 1)
 19d:	83 c4 10             	add    $0x10,%esp
 1a0:	85 c0                	test   %eax,%eax
 1a2:	7e 1d                	jle    1c1 <gets+0x41>
      break;
    buf[i++] = c;
 1a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a8:	8b 55 08             	mov    0x8(%ebp),%edx
 1ab:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1af:	3c 0a                	cmp    $0xa,%al
 1b1:	74 1d                	je     1d0 <gets+0x50>
 1b3:	3c 0d                	cmp    $0xd,%al
 1b5:	74 19                	je     1d0 <gets+0x50>
  for(i=0; i+1 < max; ){
 1b7:	89 de                	mov    %ebx,%esi
 1b9:	83 c3 01             	add    $0x1,%ebx
 1bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1bf:	7c cf                	jl     190 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1cb:	5b                   	pop    %ebx
 1cc:	5e                   	pop    %esi
 1cd:	5f                   	pop    %edi
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    
  buf[i] = '\0';
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	89 de                	mov    %ebx,%esi
 1d5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    
 1e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ef:	90                   	nop

000001f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 00                	push   $0x0
 1fa:	ff 75 08             	push   0x8(%ebp)
 1fd:	e8 f1 00 00 00       	call   2f3 <open>
  if(fd < 0)
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 c0                	test   %eax,%eax
 207:	78 27                	js     230 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	ff 75 0c             	push   0xc(%ebp)
 20f:	89 c3                	mov    %eax,%ebx
 211:	50                   	push   %eax
 212:	e8 f4 00 00 00       	call   30b <fstat>
  close(fd);
 217:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 21a:	89 c6                	mov    %eax,%esi
  close(fd);
 21c:	e8 ba 00 00 00       	call   2db <close>
  return r;
 221:	83 c4 10             	add    $0x10,%esp
}
 224:	8d 65 f8             	lea    -0x8(%ebp),%esp
 227:	89 f0                	mov    %esi,%eax
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 230:	be ff ff ff ff       	mov    $0xffffffff,%esi
 235:	eb ed                	jmp    224 <stat+0x34>
 237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23e:	66 90                	xchg   %ax,%ax

00000240 <atoi>:

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 247:	0f be 02             	movsbl (%edx),%eax
 24a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 24d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 250:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 255:	77 1e                	ja     275 <atoi+0x35>
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 260:	83 c2 01             	add    $0x1,%edx
 263:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 266:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 26a:	0f be 02             	movsbl (%edx),%eax
 26d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
  return n;
}
 275:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 278:	89 c8                	mov    %ecx,%eax
 27a:	c9                   	leave  
 27b:	c3                   	ret    
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000280 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	8b 45 10             	mov    0x10(%ebp),%eax
 287:	8b 55 08             	mov    0x8(%ebp),%edx
 28a:	56                   	push   %esi
 28b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28e:	85 c0                	test   %eax,%eax
 290:	7e 13                	jle    2a5 <memmove+0x25>
 292:	01 d0                	add    %edx,%eax
  dst = vdst;
 294:	89 d7                	mov    %edx,%edi
 296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2a1:	39 f8                	cmp    %edi,%eax
 2a3:	75 fb                	jne    2a0 <memmove+0x20>
  return vdst;
}
 2a5:	5e                   	pop    %esi
 2a6:	89 d0                	mov    %edx,%eax
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    

000002ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ab:	b8 01 00 00 00       	mov    $0x1,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <exit>:
SYSCALL(exit)
 2b3:	b8 02 00 00 00       	mov    $0x2,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <wait>:
SYSCALL(wait)
 2bb:	b8 03 00 00 00       	mov    $0x3,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <pipe>:
SYSCALL(pipe)
 2c3:	b8 04 00 00 00       	mov    $0x4,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <read>:
SYSCALL(read)
 2cb:	b8 05 00 00 00       	mov    $0x5,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <write>:
SYSCALL(write)
 2d3:	b8 10 00 00 00       	mov    $0x10,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <close>:
SYSCALL(close)
 2db:	b8 15 00 00 00       	mov    $0x15,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <kill>:
SYSCALL(kill)
 2e3:	b8 06 00 00 00       	mov    $0x6,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <exec>:
SYSCALL(exec)
 2eb:	b8 07 00 00 00       	mov    $0x7,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <open>:
SYSCALL(open)
 2f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <mknod>:
SYSCALL(mknod)
 2fb:	b8 11 00 00 00       	mov    $0x11,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <unlink>:
SYSCALL(unlink)
 303:	b8 12 00 00 00       	mov    $0x12,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <fstat>:
SYSCALL(fstat)
 30b:	b8 08 00 00 00       	mov    $0x8,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <link>:
SYSCALL(link)
 313:	b8 13 00 00 00       	mov    $0x13,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mkdir>:
SYSCALL(mkdir)
 31b:	b8 14 00 00 00       	mov    $0x14,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <chdir>:
SYSCALL(chdir)
 323:	b8 09 00 00 00       	mov    $0x9,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <dup>:
SYSCALL(dup)
 32b:	b8 0a 00 00 00       	mov    $0xa,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getpid>:
SYSCALL(getpid)
 333:	b8 0b 00 00 00       	mov    $0xb,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <sbrk>:
SYSCALL(sbrk)
 33b:	b8 0c 00 00 00       	mov    $0xc,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sleep>:
SYSCALL(sleep)
 343:	b8 0d 00 00 00       	mov    $0xd,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <uptime>:
SYSCALL(uptime)
 34b:	b8 0e 00 00 00       	mov    $0xe,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <wmap>:
SYSCALL(wmap)
 353:	b8 16 00 00 00       	mov    $0x16,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <wunmap>:
SYSCALL(wunmap)
 35b:	b8 17 00 00 00       	mov    $0x17,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <wpunmap>:
SYSCALL(wpunmap)
 363:	b8 18 00 00 00       	mov    $0x18,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <getwmapinfo>:
SYSCALL(getwmapinfo)
 36b:	b8 19 00 00 00       	mov    $0x19,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <getpgdirinfo>:
SYSCALL(getpgdirinfo)
 373:	b8 1a 00 00 00       	mov    $0x1a,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    
 37b:	66 90                	xchg   %ax,%ax
 37d:	66 90                	xchg   %ax,%ax
 37f:	90                   	nop

00000380 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	83 ec 3c             	sub    $0x3c,%esp
 389:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 38c:	89 d1                	mov    %edx,%ecx
{
 38e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 391:	85 d2                	test   %edx,%edx
 393:	0f 89 7f 00 00 00    	jns    418 <printint+0x98>
 399:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 39d:	74 79                	je     418 <printint+0x98>
    neg = 1;
 39f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3a6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3a8:	31 db                	xor    %ebx,%ebx
 3aa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 3b0:	89 c8                	mov    %ecx,%eax
 3b2:	31 d2                	xor    %edx,%edx
 3b4:	89 cf                	mov    %ecx,%edi
 3b6:	f7 75 c4             	divl   -0x3c(%ebp)
 3b9:	0f b6 92 b0 0b 00 00 	movzbl 0xbb0(%edx),%edx
 3c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3c3:	89 d8                	mov    %ebx,%eax
 3c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 3c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 3cb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 3ce:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 3d1:	76 dd                	jbe    3b0 <printint+0x30>
  if(neg)
 3d3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3d6:	85 c9                	test   %ecx,%ecx
 3d8:	74 0c                	je     3e6 <printint+0x66>
    buf[i++] = '-';
 3da:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 3df:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 3e1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 3e6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3e9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3ed:	eb 07                	jmp    3f6 <printint+0x76>
 3ef:	90                   	nop
    putc(fd, buf[i]);
 3f0:	0f b6 13             	movzbl (%ebx),%edx
 3f3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 3f6:	83 ec 04             	sub    $0x4,%esp
 3f9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3fc:	6a 01                	push   $0x1
 3fe:	56                   	push   %esi
 3ff:	57                   	push   %edi
 400:	e8 ce fe ff ff       	call   2d3 <write>
  while(--i >= 0)
 405:	83 c4 10             	add    $0x10,%esp
 408:	39 de                	cmp    %ebx,%esi
 40a:	75 e4                	jne    3f0 <printint+0x70>
}
 40c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40f:	5b                   	pop    %ebx
 410:	5e                   	pop    %esi
 411:	5f                   	pop    %edi
 412:	5d                   	pop    %ebp
 413:	c3                   	ret    
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 418:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 41f:	eb 87                	jmp    3a8 <printint+0x28>
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop

00000430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 439:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 43c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 43f:	0f b6 13             	movzbl (%ebx),%edx
 442:	84 d2                	test   %dl,%dl
 444:	74 6a                	je     4b0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 446:	8d 45 10             	lea    0x10(%ebp),%eax
 449:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 44c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 44f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 451:	89 45 d0             	mov    %eax,-0x30(%ebp)
 454:	eb 36                	jmp    48c <printf+0x5c>
 456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45d:	8d 76 00             	lea    0x0(%esi),%esi
 460:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 463:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 468:	83 f8 25             	cmp    $0x25,%eax
 46b:	74 15                	je     482 <printf+0x52>
  write(fd, &c, 1);
 46d:	83 ec 04             	sub    $0x4,%esp
 470:	88 55 e7             	mov    %dl,-0x19(%ebp)
 473:	6a 01                	push   $0x1
 475:	57                   	push   %edi
 476:	56                   	push   %esi
 477:	e8 57 fe ff ff       	call   2d3 <write>
 47c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 47f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 482:	0f b6 13             	movzbl (%ebx),%edx
 485:	83 c3 01             	add    $0x1,%ebx
 488:	84 d2                	test   %dl,%dl
 48a:	74 24                	je     4b0 <printf+0x80>
    c = fmt[i] & 0xff;
 48c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 48f:	85 c9                	test   %ecx,%ecx
 491:	74 cd                	je     460 <printf+0x30>
      }
    } else if(state == '%'){
 493:	83 f9 25             	cmp    $0x25,%ecx
 496:	75 ea                	jne    482 <printf+0x52>
      if(c == 'd'){
 498:	83 f8 25             	cmp    $0x25,%eax
 49b:	0f 84 07 01 00 00    	je     5a8 <printf+0x178>
 4a1:	83 e8 63             	sub    $0x63,%eax
 4a4:	83 f8 15             	cmp    $0x15,%eax
 4a7:	77 17                	ja     4c0 <printf+0x90>
 4a9:	ff 24 85 58 0b 00 00 	jmp    *0xb58(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b3:	5b                   	pop    %ebx
 4b4:	5e                   	pop    %esi
 4b5:	5f                   	pop    %edi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    
 4b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bf:	90                   	nop
  write(fd, &c, 1);
 4c0:	83 ec 04             	sub    $0x4,%esp
 4c3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 4c6:	6a 01                	push   $0x1
 4c8:	57                   	push   %edi
 4c9:	56                   	push   %esi
 4ca:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4ce:	e8 00 fe ff ff       	call   2d3 <write>
        putc(fd, c);
 4d3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 4d7:	83 c4 0c             	add    $0xc,%esp
 4da:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4dd:	6a 01                	push   $0x1
 4df:	57                   	push   %edi
 4e0:	56                   	push   %esi
 4e1:	e8 ed fd ff ff       	call   2d3 <write>
        putc(fd, c);
 4e6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e9:	31 c9                	xor    %ecx,%ecx
 4eb:	eb 95                	jmp    482 <printf+0x52>
 4ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 4f0:	83 ec 0c             	sub    $0xc,%esp
 4f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f8:	6a 00                	push   $0x0
 4fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4fd:	8b 10                	mov    (%eax),%edx
 4ff:	89 f0                	mov    %esi,%eax
 501:	e8 7a fe ff ff       	call   380 <printint>
        ap++;
 506:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 50a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50d:	31 c9                	xor    %ecx,%ecx
 50f:	e9 6e ff ff ff       	jmp    482 <printf+0x52>
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 518:	8b 45 d0             	mov    -0x30(%ebp),%eax
 51b:	8b 10                	mov    (%eax),%edx
        ap++;
 51d:	83 c0 04             	add    $0x4,%eax
 520:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 523:	85 d2                	test   %edx,%edx
 525:	0f 84 8d 00 00 00    	je     5b8 <printf+0x188>
        while(*s != 0){
 52b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 52e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 530:	84 c0                	test   %al,%al
 532:	0f 84 4a ff ff ff    	je     482 <printf+0x52>
 538:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 53b:	89 d3                	mov    %edx,%ebx
 53d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 540:	83 ec 04             	sub    $0x4,%esp
          s++;
 543:	83 c3 01             	add    $0x1,%ebx
 546:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 549:	6a 01                	push   $0x1
 54b:	57                   	push   %edi
 54c:	56                   	push   %esi
 54d:	e8 81 fd ff ff       	call   2d3 <write>
        while(*s != 0){
 552:	0f b6 03             	movzbl (%ebx),%eax
 555:	83 c4 10             	add    $0x10,%esp
 558:	84 c0                	test   %al,%al
 55a:	75 e4                	jne    540 <printf+0x110>
      state = 0;
 55c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 55f:	31 c9                	xor    %ecx,%ecx
 561:	e9 1c ff ff ff       	jmp    482 <printf+0x52>
 566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	b9 0a 00 00 00       	mov    $0xa,%ecx
 578:	6a 01                	push   $0x1
 57a:	e9 7b ff ff ff       	jmp    4fa <printf+0xca>
 57f:	90                   	nop
        putc(fd, *ap);
 580:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 583:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 586:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 588:	6a 01                	push   $0x1
 58a:	57                   	push   %edi
 58b:	56                   	push   %esi
        putc(fd, *ap);
 58c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 58f:	e8 3f fd ff ff       	call   2d3 <write>
        ap++;
 594:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 598:	83 c4 10             	add    $0x10,%esp
      state = 0;
 59b:	31 c9                	xor    %ecx,%ecx
 59d:	e9 e0 fe ff ff       	jmp    482 <printf+0x52>
 5a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 5a8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5ab:	83 ec 04             	sub    $0x4,%esp
 5ae:	e9 2a ff ff ff       	jmp    4dd <printf+0xad>
 5b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5b7:	90                   	nop
          s = "(null)";
 5b8:	ba 4f 0b 00 00       	mov    $0xb4f,%edx
        while(*s != 0){
 5bd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5c0:	b8 28 00 00 00       	mov    $0x28,%eax
 5c5:	89 d3                	mov    %edx,%ebx
 5c7:	e9 74 ff ff ff       	jmp    540 <printf+0x110>
 5cc:	66 90                	xchg   %ax,%ax
 5ce:	66 90                	xchg   %ax,%ax

000005d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 94 11 00 00       	mov    0x1194,%eax
{
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5e8:	89 c2                	mov    %eax,%edx
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	39 ca                	cmp    %ecx,%edx
 5ee:	73 30                	jae    620 <free+0x50>
 5f0:	39 c1                	cmp    %eax,%ecx
 5f2:	72 04                	jb     5f8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f4:	39 c2                	cmp    %eax,%edx
 5f6:	72 f0                	jb     5e8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5fe:	39 f8                	cmp    %edi,%eax
 600:	74 30                	je     632 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 602:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 605:	8b 42 04             	mov    0x4(%edx),%eax
 608:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 60b:	39 f1                	cmp    %esi,%ecx
 60d:	74 3a                	je     649 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 60f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 611:	5b                   	pop    %ebx
  freep = p;
 612:	89 15 94 11 00 00    	mov    %edx,0x1194
}
 618:	5e                   	pop    %esi
 619:	5f                   	pop    %edi
 61a:	5d                   	pop    %ebp
 61b:	c3                   	ret    
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 620:	39 c2                	cmp    %eax,%edx
 622:	72 c4                	jb     5e8 <free+0x18>
 624:	39 c1                	cmp    %eax,%ecx
 626:	73 c0                	jae    5e8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 628:	8b 73 fc             	mov    -0x4(%ebx),%esi
 62b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 62e:	39 f8                	cmp    %edi,%eax
 630:	75 d0                	jne    602 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 632:	03 70 04             	add    0x4(%eax),%esi
 635:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 638:	8b 02                	mov    (%edx),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 63f:	8b 42 04             	mov    0x4(%edx),%eax
 642:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 645:	39 f1                	cmp    %esi,%ecx
 647:	75 c6                	jne    60f <free+0x3f>
    p->s.size += bp->s.size;
 649:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 64c:	89 15 94 11 00 00    	mov    %edx,0x1194
    p->s.size += bp->s.size;
 652:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 655:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 658:	89 0a                	mov    %ecx,(%edx)
}
 65a:	5b                   	pop    %ebx
 65b:	5e                   	pop    %esi
 65c:	5f                   	pop    %edi
 65d:	5d                   	pop    %ebp
 65e:	c3                   	ret    
 65f:	90                   	nop

00000660 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 669:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 66c:	8b 3d 94 11 00 00    	mov    0x1194,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 672:	8d 70 07             	lea    0x7(%eax),%esi
 675:	c1 ee 03             	shr    $0x3,%esi
 678:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 67b:	85 ff                	test   %edi,%edi
 67d:	0f 84 9d 00 00 00    	je     720 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 683:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 685:	8b 4a 04             	mov    0x4(%edx),%ecx
 688:	39 f1                	cmp    %esi,%ecx
 68a:	73 6a                	jae    6f6 <malloc+0x96>
 68c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 691:	39 de                	cmp    %ebx,%esi
 693:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 696:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 69d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6a0:	eb 17                	jmp    6b9 <malloc+0x59>
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6aa:	8b 48 04             	mov    0x4(%eax),%ecx
 6ad:	39 f1                	cmp    %esi,%ecx
 6af:	73 4f                	jae    700 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6b1:	8b 3d 94 11 00 00    	mov    0x1194,%edi
 6b7:	89 c2                	mov    %eax,%edx
 6b9:	39 d7                	cmp    %edx,%edi
 6bb:	75 eb                	jne    6a8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6bd:	83 ec 0c             	sub    $0xc,%esp
 6c0:	ff 75 e4             	push   -0x1c(%ebp)
 6c3:	e8 73 fc ff ff       	call   33b <sbrk>
  if(p == (char*)-1)
 6c8:	83 c4 10             	add    $0x10,%esp
 6cb:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ce:	74 1c                	je     6ec <malloc+0x8c>
  hp->s.size = nu;
 6d0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6d3:	83 ec 0c             	sub    $0xc,%esp
 6d6:	83 c0 08             	add    $0x8,%eax
 6d9:	50                   	push   %eax
 6da:	e8 f1 fe ff ff       	call   5d0 <free>
  return freep;
 6df:	8b 15 94 11 00 00    	mov    0x1194,%edx
      if((p = morecore(nunits)) == 0)
 6e5:	83 c4 10             	add    $0x10,%esp
 6e8:	85 d2                	test   %edx,%edx
 6ea:	75 bc                	jne    6a8 <malloc+0x48>
        return 0;
  }
}
 6ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6ef:	31 c0                	xor    %eax,%eax
}
 6f1:	5b                   	pop    %ebx
 6f2:	5e                   	pop    %esi
 6f3:	5f                   	pop    %edi
 6f4:	5d                   	pop    %ebp
 6f5:	c3                   	ret    
    if(p->s.size >= nunits){
 6f6:	89 d0                	mov    %edx,%eax
 6f8:	89 fa                	mov    %edi,%edx
 6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 700:	39 ce                	cmp    %ecx,%esi
 702:	74 4c                	je     750 <malloc+0xf0>
        p->s.size -= nunits;
 704:	29 f1                	sub    %esi,%ecx
 706:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 709:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 70c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 70f:	89 15 94 11 00 00    	mov    %edx,0x1194
}
 715:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 718:	83 c0 08             	add    $0x8,%eax
}
 71b:	5b                   	pop    %ebx
 71c:	5e                   	pop    %esi
 71d:	5f                   	pop    %edi
 71e:	5d                   	pop    %ebp
 71f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 720:	c7 05 94 11 00 00 98 	movl   $0x1198,0x1194
 727:	11 00 00 
    base.s.size = 0;
 72a:	bf 98 11 00 00       	mov    $0x1198,%edi
    base.s.ptr = freep = prevp = &base;
 72f:	c7 05 98 11 00 00 98 	movl   $0x1198,0x1198
 736:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 739:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 73b:	c7 05 9c 11 00 00 00 	movl   $0x0,0x119c
 742:	00 00 00 
    if(p->s.size >= nunits){
 745:	e9 42 ff ff ff       	jmp    68c <malloc+0x2c>
 74a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 750:	8b 08                	mov    (%eax),%ecx
 752:	89 0a                	mov    %ecx,(%edx)
 754:	eb b9                	jmp    70f <malloc+0xaf>
 756:	66 90                	xchg   %ax,%ax
 758:	66 90                	xchg   %ax,%ax
 75a:	66 90                	xchg   %ax,%ax
 75c:	66 90                	xchg   %ax,%ax
 75e:	66 90                	xchg   %ax,%ax

00000760 <finish>:
#include "wmaptest.h"

// TEST HELPER
void finish() {
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	83 ec 10             	sub    $0x10,%esp
    printf(1, "XV6: Test finished.\n");
 766:	68 c1 0b 00 00       	push   $0xbc1
 76b:	6a 01                	push   $0x1
 76d:	e8 be fc ff ff       	call   430 <printf>
    exit();
 772:	e8 3c fb ff ff       	call   2b3 <exit>
 777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 77e:	66 90                	xchg   %ax,%ax

00000780 <failed>:
}

void failed() {
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	83 ec 10             	sub    $0x10,%esp
    printf(1, "XV6: Test failed.\n");
 786:	68 d6 0b 00 00       	push   $0xbd6
 78b:	6a 01                	push   $0x1
 78d:	e8 9e fc ff ff       	call   430 <printf>
    exit();
 792:	e8 1c fb ff ff       	call   2b3 <exit>
 797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 79e:	66 90                	xchg   %ax,%ax

000007a0 <print_mmap_info>:
}

/**
 * @brief Prints details of a wmapinfo struct.
 */
void print_mmap_info(struct wmapinfo *info) {
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	56                   	push   %esi
 7a4:	53                   	push   %ebx
 7a5:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "XV6: ------ Total mmaps: %d\n", info->total_mmaps);
 7a8:	83 ec 04             	sub    $0x4,%esp
 7ab:	ff 36                	push   (%esi)
 7ad:	68 e9 0b 00 00       	push   $0xbe9
 7b2:	6a 01                	push   $0x1
 7b4:	e8 77 fc ff ff       	call   430 <printf>
    for (int i = 0; i < info->total_mmaps; i++) {
 7b9:	8b 06                	mov    (%esi),%eax
 7bb:	83 c4 10             	add    $0x10,%esp
 7be:	85 c0                	test   %eax,%eax
 7c0:	7e 4a                	jle    80c <print_mmap_info+0x6c>
 7c2:	31 db                	xor    %ebx,%ebx
 7c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
            i, info->addr[i], info->length[i], info->addr[i] + info->length[i], info->flags[i], info->fd[i], info->refcnt[i], info->n_loaded_pages[i]);
 7c8:	8b 44 9e 04          	mov    0x4(%esi,%ebx,4),%eax
 7cc:	8b 54 9e 44          	mov    0x44(%esi,%ebx,4),%edx
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
 7d0:	83 ec 08             	sub    $0x8,%esp
 7d3:	ff b4 9e 44 01 00 00 	push   0x144(%esi,%ebx,4)
 7da:	ff b4 9e 04 01 00 00 	push   0x104(%esi,%ebx,4)
 7e1:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
 7e4:	ff b4 9e c4 00 00 00 	push   0xc4(%esi,%ebx,4)
 7eb:	ff b4 9e 84 00 00 00 	push   0x84(%esi,%ebx,4)
 7f2:	51                   	push   %ecx
 7f3:	52                   	push   %edx
 7f4:	50                   	push   %eax
 7f5:	53                   	push   %ebx
    for (int i = 0; i < info->total_mmaps; i++) {
 7f6:	83 c3 01             	add    $0x1,%ebx
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
 7f9:	68 2c 0c 00 00       	push   $0xc2c
 7fe:	6a 01                	push   $0x1
 800:	e8 2b fc ff ff       	call   430 <printf>
    for (int i = 0; i < info->total_mmaps; i++) {
 805:	83 c4 30             	add    $0x30,%esp
 808:	39 1e                	cmp    %ebx,(%esi)
 80a:	7f bc                	jg     7c8 <print_mmap_info+0x28>
    }
}
 80c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 80f:	5b                   	pop    %ebx
 810:	5e                   	pop    %esi
 811:	5d                   	pop    %ebp
 812:	c3                   	ret    
 813:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 81a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000820 <test_getwmapinfo>:

void test_getwmapinfo(struct wmapinfo *info) {
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	53                   	push   %ebx
 824:	83 ec 10             	sub    $0x10,%esp
 827:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int ret = getwmapinfo(info);
 82a:	53                   	push   %ebx
 82b:	e8 3b fb ff ff       	call   36b <getwmapinfo>
    if (ret < 0) {
 830:	83 c4 10             	add    $0x10,%esp
 833:	85 c0                	test   %eax,%eax
 835:	78 0c                	js     843 <test_getwmapinfo+0x23>
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
        failed();
    }
    print_mmap_info(info);
 837:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 83a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 83d:	c9                   	leave  
    print_mmap_info(info);
 83e:	e9 5d ff ff ff       	jmp    7a0 <print_mmap_info>
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
 843:	52                   	push   %edx
 844:	50                   	push   %eax
 845:	68 8c 0c 00 00       	push   $0xc8c
 84a:	6a 01                	push   $0x1
 84c:	e8 df fb ff ff       	call   430 <printf>
        failed();
 851:	e8 2a ff ff ff       	call   780 <failed>
 856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 85d:	8d 76 00             	lea    0x0(%esi),%esi

00000860 <print_pgdir_info>:

/**
 * @brief Prints details of a pgdirinfo struct.
 */
void print_pgdir_info(struct pgdirinfo *info) {
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	56                   	push   %esi
 864:	53                   	push   %ebx
 865:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "XV6: Total n_upages: %d\n", info->n_upages);
 868:	83 ec 04             	sub    $0x4,%esp
 86b:	ff 36                	push   (%esi)
 86d:	68 06 0c 00 00       	push   $0xc06
 872:	6a 01                	push   $0x1
 874:	e8 b7 fb ff ff       	call   430 <printf>
    for (int i = 0; i < info->n_upages; i++) {
 879:	8b 06                	mov    (%esi),%eax
 87b:	83 c4 10             	add    $0x10,%esp
 87e:	85 c0                	test   %eax,%eax
 880:	74 2b                	je     8ad <print_pgdir_info+0x4d>
 882:	31 db                	xor    %ebx,%ebx
 884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
 888:	83 ec 0c             	sub    $0xc,%esp
 88b:	ff b4 9e 84 00 00 00 	push   0x84(%esi,%ebx,4)
 892:	ff 74 9e 04          	push   0x4(%esi,%ebx,4)
 896:	53                   	push   %ebx
    for (int i = 0; i < info->n_upages; i++) {
 897:	83 c3 01             	add    $0x1,%ebx
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
 89a:	68 ac 0c 00 00       	push   $0xcac
 89f:	6a 01                	push   $0x1
 8a1:	e8 8a fb ff ff       	call   430 <printf>
    for (int i = 0; i < info->n_upages; i++) {
 8a6:	83 c4 20             	add    $0x20,%esp
 8a9:	39 1e                	cmp    %ebx,(%esi)
 8ab:	77 db                	ja     888 <print_pgdir_info+0x28>
            i, info->va[i], info->pa[i]);
    }
}
 8ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8b0:	5b                   	pop    %ebx
 8b1:	5e                   	pop    %esi
 8b2:	5d                   	pop    %ebp
 8b3:	c3                   	ret    
 8b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8bf:	90                   	nop

000008c0 <test_getpgdirinfo>:

void test_getpgdirinfo(struct pgdirinfo *info) {
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	83 ec 14             	sub    $0x14,%esp
    int ret = getpgdirinfo(info);
 8c6:	ff 75 08             	push   0x8(%ebp)
 8c9:	e8 a5 fa ff ff       	call   373 <getpgdirinfo>
    if (ret < 0) {
 8ce:	83 c4 10             	add    $0x10,%esp
 8d1:	85 c0                	test   %eax,%eax
 8d3:	78 02                	js     8d7 <test_getpgdirinfo+0x17>
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
        failed();
    }
    // print_pgdir_info(info);
}
 8d5:	c9                   	leave  
 8d6:	c3                   	ret    
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
 8d7:	52                   	push   %edx
 8d8:	50                   	push   %eax
 8d9:	68 d8 0c 00 00       	push   $0xcd8
 8de:	6a 01                	push   $0x1
 8e0:	e8 4b fb ff ff       	call   430 <printf>
        failed();
 8e5:	e8 96 fe ff ff       	call   780 <failed>
 8ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000008f0 <create_small_file>:

int create_small_file(char *filename) {
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	56                   	push   %esi
 8f4:	53                   	push   %ebx

    // create a file
    int bufflen = 512 + 2;
    char buff[bufflen];
 8f5:	89 e0                	mov    %esp,%eax
 8f7:	39 c4                	cmp    %eax,%esp
 8f9:	74 12                	je     90d <create_small_file+0x1d>
 8fb:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 901:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 908:	00 
 909:	39 c4                	cmp    %eax,%esp
 90b:	75 ee                	jne    8fb <create_small_file+0xb>
 90d:	81 ec 10 02 00 00    	sub    $0x210,%esp
 913:	83 8c 24 0c 02 00 00 	orl    $0x0,0x20c(%esp)
 91a:	00 
 91b:	89 e3                	mov    %esp,%ebx
    int fd = open(filename, O_CREATE | O_RDWR);
 91d:	83 ec 08             	sub    $0x8,%esp
 920:	68 02 02 00 00       	push   $0x202
 925:	ff 75 08             	push   0x8(%ebp)
 928:	e8 c6 f9 ff ff       	call   2f3 <open>
    if (fd < 0) {
 92d:	89 dc                	mov    %ebx,%esp
    int fd = open(filename, O_CREATE | O_RDWR);
 92f:	89 c6                	mov    %eax,%esi
    if (fd < 0) {
 931:	85 c0                	test   %eax,%eax
 933:	78 5a                	js     98f <create_small_file+0x9f>
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }

    // prepare the content to write
    for (int j = 0; j < bufflen; j++) {
 935:	31 c0                	xor    %eax,%eax
 937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93e:	66 90                	xchg   %ax,%ax
        buff[j] = 'a' + (j % 4);
 940:	89 c2                	mov    %eax,%edx
 942:	83 e2 03             	and    $0x3,%edx
 945:	83 c2 61             	add    $0x61,%edx
 948:	88 14 03             	mov    %dl,(%ebx,%eax,1)
    for (int j = 0; j < bufflen; j++) {
 94b:	83 c0 01             	add    $0x1,%eax
 94e:	3d 02 02 00 00       	cmp    $0x202,%eax
 953:	75 eb                	jne    940 <create_small_file+0x50>
    }
    buff[bufflen - 1] = '\0';
    buff[bufflen - 2] = '\n';

    // write to file
    if (write(fd, buff, bufflen) != bufflen) {
 955:	83 ec 04             	sub    $0x4,%esp
    buff[bufflen - 2] = '\n';
 958:	ba 0a 00 00 00       	mov    $0xa,%edx
 95d:	66 89 93 00 02 00 00 	mov    %dx,0x200(%ebx)
    if (write(fd, buff, bufflen) != bufflen) {
 964:	68 02 02 00 00       	push   $0x202
 969:	53                   	push   %ebx
 96a:	56                   	push   %esi
 96b:	e8 63 f9 ff ff       	call   2d3 <write>
 970:	83 c4 10             	add    $0x10,%esp
 973:	3d 02 02 00 00       	cmp    $0x202,%eax
 978:	75 2a                	jne    9a4 <create_small_file+0xb4>
        printf(1, "XV6: Error: Write to file FAILED\n");
        failed();
    }

    close(fd);
 97a:	83 ec 0c             	sub    $0xc,%esp
 97d:	56                   	push   %esi
 97e:	e8 58 f9 ff ff       	call   2db <close>
    return bufflen;
}
 983:	8d 65 f8             	lea    -0x8(%ebp),%esp
 986:	b8 02 02 00 00       	mov    $0x202,%eax
 98b:	5b                   	pop    %ebx
 98c:	5e                   	pop    %esi
 98d:	5d                   	pop    %ebp
 98e:	c3                   	ret    
        printf(1, "XV6: Failed to create file %s\n", filename);
 98f:	51                   	push   %ecx
 990:	ff 75 08             	push   0x8(%ebp)
 993:	68 fc 0c 00 00       	push   $0xcfc
 998:	6a 01                	push   $0x1
 99a:	e8 91 fa ff ff       	call   430 <printf>
        failed();
 99f:	e8 dc fd ff ff       	call   780 <failed>
        printf(1, "XV6: Error: Write to file FAILED\n");
 9a4:	50                   	push   %eax
 9a5:	50                   	push   %eax
 9a6:	68 1c 0d 00 00       	push   $0xd1c
 9ab:	6a 01                	push   $0x1
 9ad:	e8 7e fa ff ff       	call   430 <printf>
        failed();
 9b2:	e8 c9 fd ff ff       	call   780 <failed>
 9b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9be:	66 90                	xchg   %ax,%ax

000009c0 <create_big_file>:

int create_big_file(char *filename, int N_PAGES) {
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	57                   	push   %edi
 9c4:	56                   	push   %esi
 9c5:	53                   	push   %ebx
 9c6:	83 ec 1c             	sub    $0x1c,%esp
 9c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // create a file
    int bufflen = 512;
    char buff[bufflen + 1];
 9cc:	89 e0                	mov    %esp,%eax
 9ce:	39 c4                	cmp    %eax,%esp
 9d0:	74 12                	je     9e4 <create_big_file+0x24>
 9d2:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 9d8:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 9df:	00 
 9e0:	39 c4                	cmp    %eax,%esp
 9e2:	75 ee                	jne    9d2 <create_big_file+0x12>
 9e4:	81 ec 10 02 00 00    	sub    $0x210,%esp
 9ea:	83 8c 24 0c 02 00 00 	orl    $0x0,0x20c(%esp)
 9f1:	00 
 9f2:	89 e6                	mov    %esp,%esi
    int fd = open(filename, O_CREATE | O_RDWR);
 9f4:	83 ec 08             	sub    $0x8,%esp
 9f7:	68 02 02 00 00       	push   $0x202
 9fc:	53                   	push   %ebx
 9fd:	e8 f1 f8 ff ff       	call   2f3 <open>
    if (fd < 0) {
 a02:	89 f4                	mov    %esi,%esp
    int fd = open(filename, O_CREATE | O_RDWR);
 a04:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (fd < 0) {
 a07:	85 c0                	test   %eax,%eax
 a09:	0f 88 9c 00 00 00    	js     aab <create_big_file+0xeb>
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }
    // write in steps as we cannot have a buffer larger than PGSIZE
    char c = 'a';
    for (int i = 0; i < N_PAGES; i++) {
 a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
 a12:	8d 9e 00 02 00 00    	lea    0x200(%esi),%ebx
 a18:	89 f7                	mov    %esi,%edi
 a1a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 a21:	89 de                	mov    %ebx,%esi
 a23:	85 d2                	test   %edx,%edx
 a25:	7e 56                	jle    a7d <create_big_file+0xbd>
 a27:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
        int m = PGSIZE / bufflen;
        for (int k = 0; k < m; k++) {
 a2b:	31 d2                	xor    %edx,%edx
 a2d:	8d 58 61             	lea    0x61(%eax),%ebx
            // prepare the content to write
            for (int j = 0; j < bufflen; j++) {
 a30:	89 f8                	mov    %edi,%eax
 a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                buff[j] = c;
 a38:	88 18                	mov    %bl,(%eax)
            for (int j = 0; j < bufflen; j++) {
 a3a:	83 c0 01             	add    $0x1,%eax
 a3d:	39 f0                	cmp    %esi,%eax
 a3f:	75 f7                	jne    a38 <create_big_file+0x78>
            }
            buff[bufflen] = '\0';
            // write to file
            if (write(fd, buff, bufflen) != bufflen) {
 a41:	83 ec 04             	sub    $0x4,%esp
            buff[bufflen] = '\0';
 a44:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 a47:	c6 87 00 02 00 00 00 	movb   $0x0,0x200(%edi)
            if (write(fd, buff, bufflen) != bufflen) {
 a4e:	68 00 02 00 00       	push   $0x200
 a53:	57                   	push   %edi
 a54:	ff 75 e0             	push   -0x20(%ebp)
 a57:	e8 77 f8 ff ff       	call   2d3 <write>
 a5c:	83 c4 10             	add    $0x10,%esp
 a5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a62:	3d 00 02 00 00       	cmp    $0x200,%eax
 a67:	75 2d                	jne    a96 <create_big_file+0xd6>
        for (int k = 0; k < m; k++) {
 a69:	83 c2 01             	add    $0x1,%edx
 a6c:	83 fa 08             	cmp    $0x8,%edx
 a6f:	75 bf                	jne    a30 <create_big_file+0x70>
    for (int i = 0; i < N_PAGES; i++) {
 a71:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 a75:	8b 45 dc             	mov    -0x24(%ebp),%eax
 a78:	39 45 0c             	cmp    %eax,0xc(%ebp)
 a7b:	75 aa                	jne    a27 <create_big_file+0x67>
                failed();
            }
        }
        c++; // first page is filled with 'a', second with 'b', and so on
    }
    close(fd);
 a7d:	83 ec 0c             	sub    $0xc,%esp
 a80:	ff 75 e0             	push   -0x20(%ebp)
 a83:	e8 53 f8 ff ff       	call   2db <close>
    return N_PAGES * PGSIZE;
 a88:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 a8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a8e:	5b                   	pop    %ebx
 a8f:	5e                   	pop    %esi
    return N_PAGES * PGSIZE;
 a90:	c1 e0 0c             	shl    $0xc,%eax
}
 a93:	5f                   	pop    %edi
 a94:	5d                   	pop    %ebp
 a95:	c3                   	ret    
                printf(1, "XV6: Write to file FAILED (%d, %d)\n", i, k);
 a96:	52                   	push   %edx
 a97:	ff 75 dc             	push   -0x24(%ebp)
 a9a:	68 40 0d 00 00       	push   $0xd40
 a9f:	6a 01                	push   $0x1
 aa1:	e8 8a f9 ff ff       	call   430 <printf>
                failed();
 aa6:	e8 d5 fc ff ff       	call   780 <failed>
        printf(1, "XV6: Failed to create file %s\n", filename);
 aab:	50                   	push   %eax
 aac:	53                   	push   %ebx
 aad:	68 fc 0c 00 00       	push   $0xcfc
 ab2:	6a 01                	push   $0x1
 ab4:	e8 77 f9 ff ff       	call   430 <printf>
        failed();
 ab9:	e8 c2 fc ff ff       	call   780 <failed>
 abe:	66 90                	xchg   %ax,%ax

00000ac0 <va_exists>:

void va_exists(struct pgdirinfo *info, uint va, int expected) {
 ac0:	55                   	push   %ebp
    int found = 0;
    for (int i = 0; i < info->n_upages; i++) {
 ac1:	31 c0                	xor    %eax,%eax
void va_exists(struct pgdirinfo *info, uint va, int expected) {
 ac3:	89 e5                	mov    %esp,%ebp
 ac5:	53                   	push   %ebx
 ac6:	83 ec 04             	sub    $0x4,%esp
 ac9:	8b 55 08             	mov    0x8(%ebp),%edx
 acc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    for (int i = 0; i < info->n_upages; i++) {
 acf:	8b 0a                	mov    (%edx),%ecx
 ad1:	85 c9                	test   %ecx,%ecx
 ad3:	75 12                	jne    ae7 <va_exists+0x27>
 ad5:	eb 1b                	jmp    af2 <va_exists+0x32>
 ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 ade:	66 90                	xchg   %ax,%ax
 ae0:	83 c0 01             	add    $0x1,%eax
 ae3:	39 c1                	cmp    %eax,%ecx
 ae5:	74 19                	je     b00 <va_exists+0x40>
        if (info->va[i] == va) {
 ae7:	39 5c 82 04          	cmp    %ebx,0x4(%edx,%eax,4)
 aeb:	75 f3                	jne    ae0 <va_exists+0x20>
            found = 1;
 aed:	b8 01 00 00 00       	mov    $0x1,%eax
            break;
        }
    }
    if (found != expected) {
 af2:	3b 45 10             	cmp    0x10(%ebp),%eax
 af5:	75 0d                	jne    b04 <va_exists+0x44>
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
        failed();
    }
}
 af7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 afa:	c9                   	leave  
 afb:	c3                   	ret    
 afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int found = 0;
 b00:	31 c0                	xor    %eax,%eax
 b02:	eb ee                	jmp    af2 <va_exists+0x32>
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
 b04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 b08:	ba 1f 0c 00 00       	mov    $0xc1f,%edx
 b0d:	b8 23 0c 00 00       	mov    $0xc23,%eax
 b12:	0f 44 c2             	cmove  %edx,%eax
 b15:	50                   	push   %eax
 b16:	53                   	push   %ebx
 b17:	68 64 0d 00 00       	push   $0xd64
 b1c:	6a 01                	push   $0x1
 b1e:	e8 0d f9 ff ff       	call   430 <printf>
        failed();
 b23:	e8 58 fc ff ff       	call   780 <failed>
