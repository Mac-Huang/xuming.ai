
_echo:     file format elf32-i386


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
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 47                	jle    65 <main+0x65>
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  23:	83 c3 01             	add    $0x1,%ebx
  26:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  2a:	39 f3                	cmp    %esi,%ebx
  2c:	74 22                	je     50 <main+0x50>
  2e:	66 90                	xchg   %ax,%ax
  30:	68 38 0b 00 00       	push   $0xb38
  35:	83 c3 01             	add    $0x1,%ebx
  38:	50                   	push   %eax
  39:	68 3a 0b 00 00       	push   $0xb3a
  3e:	6a 01                	push   $0x1
  40:	e8 fb 03 00 00       	call   440 <printf>
  45:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  49:	83 c4 10             	add    $0x10,%esp
  4c:	39 f3                	cmp    %esi,%ebx
  4e:	75 e0                	jne    30 <main+0x30>
  50:	68 c4 0b 00 00       	push   $0xbc4
  55:	50                   	push   %eax
  56:	68 3a 0b 00 00       	push   $0xb3a
  5b:	6a 01                	push   $0x1
  5d:	e8 de 03 00 00       	call   440 <printf>
  62:	83 c4 10             	add    $0x10,%esp
  exit();
  65:	e8 59 02 00 00       	call   2c3 <exit>
  6a:	66 90                	xchg   %ax,%ax
  6c:	66 90                	xchg   %ax,%ax
  6e:	66 90                	xchg   %ax,%ax

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  70:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  71:	31 c0                	xor    %eax,%eax
{
  73:	89 e5                	mov    %esp,%ebp
  75:	53                   	push   %ebx
  76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  80:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  84:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  87:	83 c0 01             	add    $0x1,%eax
  8a:	84 d2                	test   %dl,%dl
  8c:	75 f2                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  91:	89 c8                	mov    %ecx,%eax
  93:	c9                   	leave  
  94:	c3                   	ret    
  95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
  a4:	8b 55 08             	mov    0x8(%ebp),%edx
  a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  aa:	0f b6 02             	movzbl (%edx),%eax
  ad:	84 c0                	test   %al,%al
  af:	75 17                	jne    c8 <strcmp+0x28>
  b1:	eb 3a                	jmp    ed <strcmp+0x4d>
  b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  b7:	90                   	nop
  b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  bc:	83 c2 01             	add    $0x1,%edx
  bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  c2:	84 c0                	test   %al,%al
  c4:	74 1a                	je     e0 <strcmp+0x40>
    p++, q++;
  c6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  c8:	0f b6 19             	movzbl (%ecx),%ebx
  cb:	38 c3                	cmp    %al,%bl
  cd:	74 e9                	je     b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  cf:	29 d8                	sub    %ebx,%eax
}
  d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d4:	c9                   	leave  
  d5:	c3                   	ret    
  d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
  e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  e4:	31 c0                	xor    %eax,%eax
  e6:	29 d8                	sub    %ebx,%eax
}
  e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  eb:	c9                   	leave  
  ec:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
  ed:	0f b6 19             	movzbl (%ecx),%ebx
  f0:	31 c0                	xor    %eax,%eax
  f2:	eb db                	jmp    cf <strcmp+0x2f>
  f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ff:	90                   	nop

00000100 <strlen>:

uint
strlen(const char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 106:	80 3a 00             	cmpb   $0x0,(%edx)
 109:	74 15                	je     120 <strlen+0x20>
 10b:	31 c0                	xor    %eax,%eax
 10d:	8d 76 00             	lea    0x0(%esi),%esi
 110:	83 c0 01             	add    $0x1,%eax
 113:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 117:	89 c1                	mov    %eax,%ecx
 119:	75 f5                	jne    110 <strlen+0x10>
    ;
  return n;
}
 11b:	89 c8                	mov    %ecx,%eax
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    
 11f:	90                   	nop
  for(n = 0; s[n]; n++)
 120:	31 c9                	xor    %ecx,%ecx
}
 122:	5d                   	pop    %ebp
 123:	89 c8                	mov    %ecx,%eax
 125:	c3                   	ret    
 126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12d:	8d 76 00             	lea    0x0(%esi),%esi

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 137:	8b 4d 10             	mov    0x10(%ebp),%ecx
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	89 d7                	mov    %edx,%edi
 13f:	fc                   	cld    
 140:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 142:	8b 7d fc             	mov    -0x4(%ebp),%edi
 145:	89 d0                	mov    %edx,%eax
 147:	c9                   	leave  
 148:	c3                   	ret    
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 15a:	0f b6 10             	movzbl (%eax),%edx
 15d:	84 d2                	test   %dl,%dl
 15f:	75 12                	jne    173 <strchr+0x23>
 161:	eb 1d                	jmp    180 <strchr+0x30>
 163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 167:	90                   	nop
 168:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 16c:	83 c0 01             	add    $0x1,%eax
 16f:	84 d2                	test   %dl,%dl
 171:	74 0d                	je     180 <strchr+0x30>
    if(*s == c)
 173:	38 d1                	cmp    %dl,%cl
 175:	75 f1                	jne    168 <strchr+0x18>
      return (char*)s;
  return 0;
}
 177:	5d                   	pop    %ebp
 178:	c3                   	ret    
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 180:	31 c0                	xor    %eax,%eax
}
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
 184:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 18f:	90                   	nop

00000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 195:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 198:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 199:	31 db                	xor    %ebx,%ebx
{
 19b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 19e:	eb 27                	jmp    1c7 <gets+0x37>
    cc = read(0, &c, 1);
 1a0:	83 ec 04             	sub    $0x4,%esp
 1a3:	6a 01                	push   $0x1
 1a5:	57                   	push   %edi
 1a6:	6a 00                	push   $0x0
 1a8:	e8 2e 01 00 00       	call   2db <read>
    if(cc < 1)
 1ad:	83 c4 10             	add    $0x10,%esp
 1b0:	85 c0                	test   %eax,%eax
 1b2:	7e 1d                	jle    1d1 <gets+0x41>
      break;
    buf[i++] = c;
 1b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1b8:	8b 55 08             	mov    0x8(%ebp),%edx
 1bb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1bf:	3c 0a                	cmp    $0xa,%al
 1c1:	74 1d                	je     1e0 <gets+0x50>
 1c3:	3c 0d                	cmp    $0xd,%al
 1c5:	74 19                	je     1e0 <gets+0x50>
  for(i=0; i+1 < max; ){
 1c7:	89 de                	mov    %ebx,%esi
 1c9:	83 c3 01             	add    $0x1,%ebx
 1cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1cf:	7c cf                	jl     1a0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1db:	5b                   	pop    %ebx
 1dc:	5e                   	pop    %esi
 1dd:	5f                   	pop    %edi
 1de:	5d                   	pop    %ebp
 1df:	c3                   	ret    
  buf[i] = '\0';
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	89 de                	mov    %ebx,%esi
 1e5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ec:	5b                   	pop    %ebx
 1ed:	5e                   	pop    %esi
 1ee:	5f                   	pop    %edi
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    
 1f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ff:	90                   	nop

00000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	6a 00                	push   $0x0
 20a:	ff 75 08             	push   0x8(%ebp)
 20d:	e8 f1 00 00 00       	call   303 <open>
  if(fd < 0)
 212:	83 c4 10             	add    $0x10,%esp
 215:	85 c0                	test   %eax,%eax
 217:	78 27                	js     240 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	ff 75 0c             	push   0xc(%ebp)
 21f:	89 c3                	mov    %eax,%ebx
 221:	50                   	push   %eax
 222:	e8 f4 00 00 00       	call   31b <fstat>
  close(fd);
 227:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 22a:	89 c6                	mov    %eax,%esi
  close(fd);
 22c:	e8 ba 00 00 00       	call   2eb <close>
  return r;
 231:	83 c4 10             	add    $0x10,%esp
}
 234:	8d 65 f8             	lea    -0x8(%ebp),%esp
 237:	89 f0                	mov    %esi,%eax
 239:	5b                   	pop    %ebx
 23a:	5e                   	pop    %esi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
 23d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 240:	be ff ff ff ff       	mov    $0xffffffff,%esi
 245:	eb ed                	jmp    234 <stat+0x34>
 247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24e:	66 90                	xchg   %ax,%ax

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	0f be 02             	movsbl (%edx),%eax
 25a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 25d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 260:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 265:	77 1e                	ja     285 <atoi+0x35>
 267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 270:	83 c2 01             	add    $0x1,%edx
 273:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 276:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 27a:	0f be 02             	movsbl (%edx),%eax
 27d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	76 eb                	jbe    270 <atoi+0x20>
  return n;
}
 285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 288:	89 c8                	mov    %ecx,%eax
 28a:	c9                   	leave  
 28b:	c3                   	ret    
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	8b 45 10             	mov    0x10(%ebp),%eax
 297:	8b 55 08             	mov    0x8(%ebp),%edx
 29a:	56                   	push   %esi
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7e 13                	jle    2b5 <memmove+0x25>
 2a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2a4:	89 d7                	mov    %edx,%edi
 2a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2b1:	39 f8                	cmp    %edi,%eax
 2b3:	75 fb                	jne    2b0 <memmove+0x20>
  return vdst;
}
 2b5:	5e                   	pop    %esi
 2b6:	89 d0                	mov    %edx,%eax
 2b8:	5f                   	pop    %edi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret    

000002bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bb:	b8 01 00 00 00       	mov    $0x1,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <exit>:
SYSCALL(exit)
 2c3:	b8 02 00 00 00       	mov    $0x2,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <wait>:
SYSCALL(wait)
 2cb:	b8 03 00 00 00       	mov    $0x3,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <pipe>:
SYSCALL(pipe)
 2d3:	b8 04 00 00 00       	mov    $0x4,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <read>:
SYSCALL(read)
 2db:	b8 05 00 00 00       	mov    $0x5,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <write>:
SYSCALL(write)
 2e3:	b8 10 00 00 00       	mov    $0x10,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <close>:
SYSCALL(close)
 2eb:	b8 15 00 00 00       	mov    $0x15,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <kill>:
SYSCALL(kill)
 2f3:	b8 06 00 00 00       	mov    $0x6,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <exec>:
SYSCALL(exec)
 2fb:	b8 07 00 00 00       	mov    $0x7,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <open>:
SYSCALL(open)
 303:	b8 0f 00 00 00       	mov    $0xf,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <mknod>:
SYSCALL(mknod)
 30b:	b8 11 00 00 00       	mov    $0x11,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <unlink>:
SYSCALL(unlink)
 313:	b8 12 00 00 00       	mov    $0x12,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <fstat>:
SYSCALL(fstat)
 31b:	b8 08 00 00 00       	mov    $0x8,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <link>:
SYSCALL(link)
 323:	b8 13 00 00 00       	mov    $0x13,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <mkdir>:
SYSCALL(mkdir)
 32b:	b8 14 00 00 00       	mov    $0x14,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <chdir>:
SYSCALL(chdir)
 333:	b8 09 00 00 00       	mov    $0x9,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <dup>:
SYSCALL(dup)
 33b:	b8 0a 00 00 00       	mov    $0xa,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <getpid>:
SYSCALL(getpid)
 343:	b8 0b 00 00 00       	mov    $0xb,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <sbrk>:
SYSCALL(sbrk)
 34b:	b8 0c 00 00 00       	mov    $0xc,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <sleep>:
SYSCALL(sleep)
 353:	b8 0d 00 00 00       	mov    $0xd,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <uptime>:
SYSCALL(uptime)
 35b:	b8 0e 00 00 00       	mov    $0xe,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <wmap>:
SYSCALL(wmap)
 363:	b8 16 00 00 00       	mov    $0x16,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <wunmap>:
SYSCALL(wunmap)
 36b:	b8 17 00 00 00       	mov    $0x17,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <wpunmap>:
SYSCALL(wpunmap)
 373:	b8 18 00 00 00       	mov    $0x18,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <getwmapinfo>:
SYSCALL(getwmapinfo)
 37b:	b8 19 00 00 00       	mov    $0x19,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <getpgdirinfo>:
SYSCALL(getpgdirinfo)
 383:	b8 1a 00 00 00       	mov    $0x1a,%eax
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
 3c9:	0f b6 92 a0 0b 00 00 	movzbl 0xba0(%edx),%edx
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
 410:	e8 ce fe ff ff       	call   2e3 <write>
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
 487:	e8 57 fe ff ff       	call   2e3 <write>
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
 4b9:	ff 24 85 48 0b 00 00 	jmp    *0xb48(,%eax,4)
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
 4de:	e8 00 fe ff ff       	call   2e3 <write>
        putc(fd, c);
 4e3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 4e7:	83 c4 0c             	add    $0xc,%esp
 4ea:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4ed:	6a 01                	push   $0x1
 4ef:	57                   	push   %edi
 4f0:	56                   	push   %esi
 4f1:	e8 ed fd ff ff       	call   2e3 <write>
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
 55d:	e8 81 fd ff ff       	call   2e3 <write>
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
 59f:	e8 3f fd ff ff       	call   2e3 <write>
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
 5c8:	ba 3f 0b 00 00       	mov    $0xb3f,%edx
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
 5e1:	a1 8c 11 00 00       	mov    0x118c,%eax
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
 622:	89 15 8c 11 00 00    	mov    %edx,0x118c
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
 65c:	89 15 8c 11 00 00    	mov    %edx,0x118c
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
 67c:	8b 3d 8c 11 00 00    	mov    0x118c,%edi
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
 6c1:	8b 3d 8c 11 00 00    	mov    0x118c,%edi
 6c7:	89 c2                	mov    %eax,%edx
 6c9:	39 d7                	cmp    %edx,%edi
 6cb:	75 eb                	jne    6b8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6cd:	83 ec 0c             	sub    $0xc,%esp
 6d0:	ff 75 e4             	push   -0x1c(%ebp)
 6d3:	e8 73 fc ff ff       	call   34b <sbrk>
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
 6ef:	8b 15 8c 11 00 00    	mov    0x118c,%edx
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
 71f:	89 15 8c 11 00 00    	mov    %edx,0x118c
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
 730:	c7 05 8c 11 00 00 90 	movl   $0x1190,0x118c
 737:	11 00 00 
    base.s.size = 0;
 73a:	bf 90 11 00 00       	mov    $0x1190,%edi
    base.s.ptr = freep = prevp = &base;
 73f:	c7 05 90 11 00 00 90 	movl   $0x1190,0x1190
 746:	11 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 749:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 74b:	c7 05 94 11 00 00 00 	movl   $0x0,0x1194
 752:	00 00 00 
    if(p->s.size >= nunits){
 755:	e9 42 ff ff ff       	jmp    69c <malloc+0x2c>
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 760:	8b 08                	mov    (%eax),%ecx
 762:	89 0a                	mov    %ecx,(%edx)
 764:	eb b9                	jmp    71f <malloc+0xaf>
 766:	66 90                	xchg   %ax,%ax
 768:	66 90                	xchg   %ax,%ax
 76a:	66 90                	xchg   %ax,%ax
 76c:	66 90                	xchg   %ax,%ax
 76e:	66 90                	xchg   %ax,%ax

00000770 <finish>:
#include "wmaptest.h"

// TEST HELPER
void finish() {
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	83 ec 10             	sub    $0x10,%esp
    printf(1, "XV6: Test finished.\n");
 776:	68 b1 0b 00 00       	push   $0xbb1
 77b:	6a 01                	push   $0x1
 77d:	e8 be fc ff ff       	call   440 <printf>
    exit();
 782:	e8 3c fb ff ff       	call   2c3 <exit>
 787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 78e:	66 90                	xchg   %ax,%ax

00000790 <failed>:
}

void failed() {
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	83 ec 10             	sub    $0x10,%esp
    printf(1, "XV6: Test failed.\n");
 796:	68 c6 0b 00 00       	push   $0xbc6
 79b:	6a 01                	push   $0x1
 79d:	e8 9e fc ff ff       	call   440 <printf>
    exit();
 7a2:	e8 1c fb ff ff       	call   2c3 <exit>
 7a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ae:	66 90                	xchg   %ax,%ax

000007b0 <print_mmap_info>:
}

/**
 * @brief Prints details of a wmapinfo struct.
 */
void print_mmap_info(struct wmapinfo *info) {
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	56                   	push   %esi
 7b4:	53                   	push   %ebx
 7b5:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "XV6: ------ Total mmaps: %d\n", info->total_mmaps);
 7b8:	83 ec 04             	sub    $0x4,%esp
 7bb:	ff 36                	push   (%esi)
 7bd:	68 d9 0b 00 00       	push   $0xbd9
 7c2:	6a 01                	push   $0x1
 7c4:	e8 77 fc ff ff       	call   440 <printf>
    for (int i = 0; i < info->total_mmaps; i++) {
 7c9:	8b 06                	mov    (%esi),%eax
 7cb:	83 c4 10             	add    $0x10,%esp
 7ce:	85 c0                	test   %eax,%eax
 7d0:	7e 4a                	jle    81c <print_mmap_info+0x6c>
 7d2:	31 db                	xor    %ebx,%ebx
 7d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
            i, info->addr[i], info->length[i], info->addr[i] + info->length[i], info->flags[i], info->fd[i], info->refcnt[i], info->n_loaded_pages[i]);
 7d8:	8b 44 9e 04          	mov    0x4(%esi,%ebx,4),%eax
 7dc:	8b 54 9e 44          	mov    0x44(%esi,%ebx,4),%edx
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
 7e0:	83 ec 08             	sub    $0x8,%esp
 7e3:	ff b4 9e 44 01 00 00 	push   0x144(%esi,%ebx,4)
 7ea:	ff b4 9e 04 01 00 00 	push   0x104(%esi,%ebx,4)
 7f1:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
 7f4:	ff b4 9e c4 00 00 00 	push   0xc4(%esi,%ebx,4)
 7fb:	ff b4 9e 84 00 00 00 	push   0x84(%esi,%ebx,4)
 802:	51                   	push   %ecx
 803:	52                   	push   %edx
 804:	50                   	push   %eax
 805:	53                   	push   %ebx
    for (int i = 0; i < info->total_mmaps; i++) {
 806:	83 c3 01             	add    $0x1,%ebx
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
 809:	68 1c 0c 00 00       	push   $0xc1c
 80e:	6a 01                	push   $0x1
 810:	e8 2b fc ff ff       	call   440 <printf>
    for (int i = 0; i < info->total_mmaps; i++) {
 815:	83 c4 30             	add    $0x30,%esp
 818:	39 1e                	cmp    %ebx,(%esi)
 81a:	7f bc                	jg     7d8 <print_mmap_info+0x28>
    }
}
 81c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 81f:	5b                   	pop    %ebx
 820:	5e                   	pop    %esi
 821:	5d                   	pop    %ebp
 822:	c3                   	ret    
 823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000830 <test_getwmapinfo>:

void test_getwmapinfo(struct wmapinfo *info) {
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	53                   	push   %ebx
 834:	83 ec 10             	sub    $0x10,%esp
 837:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int ret = getwmapinfo(info);
 83a:	53                   	push   %ebx
 83b:	e8 3b fb ff ff       	call   37b <getwmapinfo>
    if (ret < 0) {
 840:	83 c4 10             	add    $0x10,%esp
 843:	85 c0                	test   %eax,%eax
 845:	78 0c                	js     853 <test_getwmapinfo+0x23>
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
        failed();
    }
    print_mmap_info(info);
 847:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 84a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 84d:	c9                   	leave  
    print_mmap_info(info);
 84e:	e9 5d ff ff ff       	jmp    7b0 <print_mmap_info>
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
 853:	52                   	push   %edx
 854:	50                   	push   %eax
 855:	68 7c 0c 00 00       	push   $0xc7c
 85a:	6a 01                	push   $0x1
 85c:	e8 df fb ff ff       	call   440 <printf>
        failed();
 861:	e8 2a ff ff ff       	call   790 <failed>
 866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 86d:	8d 76 00             	lea    0x0(%esi),%esi

00000870 <print_pgdir_info>:

/**
 * @brief Prints details of a pgdirinfo struct.
 */
void print_pgdir_info(struct pgdirinfo *info) {
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	56                   	push   %esi
 874:	53                   	push   %ebx
 875:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "XV6: Total n_upages: %d\n", info->n_upages);
 878:	83 ec 04             	sub    $0x4,%esp
 87b:	ff 36                	push   (%esi)
 87d:	68 f6 0b 00 00       	push   $0xbf6
 882:	6a 01                	push   $0x1
 884:	e8 b7 fb ff ff       	call   440 <printf>
    for (int i = 0; i < info->n_upages; i++) {
 889:	8b 06                	mov    (%esi),%eax
 88b:	83 c4 10             	add    $0x10,%esp
 88e:	85 c0                	test   %eax,%eax
 890:	74 2b                	je     8bd <print_pgdir_info+0x4d>
 892:	31 db                	xor    %ebx,%ebx
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
 898:	83 ec 0c             	sub    $0xc,%esp
 89b:	ff b4 9e 84 00 00 00 	push   0x84(%esi,%ebx,4)
 8a2:	ff 74 9e 04          	push   0x4(%esi,%ebx,4)
 8a6:	53                   	push   %ebx
    for (int i = 0; i < info->n_upages; i++) {
 8a7:	83 c3 01             	add    $0x1,%ebx
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
 8aa:	68 9c 0c 00 00       	push   $0xc9c
 8af:	6a 01                	push   $0x1
 8b1:	e8 8a fb ff ff       	call   440 <printf>
    for (int i = 0; i < info->n_upages; i++) {
 8b6:	83 c4 20             	add    $0x20,%esp
 8b9:	39 1e                	cmp    %ebx,(%esi)
 8bb:	77 db                	ja     898 <print_pgdir_info+0x28>
            i, info->va[i], info->pa[i]);
    }
}
 8bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8c0:	5b                   	pop    %ebx
 8c1:	5e                   	pop    %esi
 8c2:	5d                   	pop    %ebp
 8c3:	c3                   	ret    
 8c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8cf:	90                   	nop

000008d0 <test_getpgdirinfo>:

void test_getpgdirinfo(struct pgdirinfo *info) {
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	83 ec 14             	sub    $0x14,%esp
    int ret = getpgdirinfo(info);
 8d6:	ff 75 08             	push   0x8(%ebp)
 8d9:	e8 a5 fa ff ff       	call   383 <getpgdirinfo>
    if (ret < 0) {
 8de:	83 c4 10             	add    $0x10,%esp
 8e1:	85 c0                	test   %eax,%eax
 8e3:	78 02                	js     8e7 <test_getpgdirinfo+0x17>
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
        failed();
    }
    // print_pgdir_info(info);
}
 8e5:	c9                   	leave  
 8e6:	c3                   	ret    
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
 8e7:	52                   	push   %edx
 8e8:	50                   	push   %eax
 8e9:	68 c8 0c 00 00       	push   $0xcc8
 8ee:	6a 01                	push   $0x1
 8f0:	e8 4b fb ff ff       	call   440 <printf>
        failed();
 8f5:	e8 96 fe ff ff       	call   790 <failed>
 8fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000900 <create_small_file>:

int create_small_file(char *filename) {
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	56                   	push   %esi
 904:	53                   	push   %ebx

    // create a file
    int bufflen = 512 + 2;
    char buff[bufflen];
 905:	89 e0                	mov    %esp,%eax
 907:	39 c4                	cmp    %eax,%esp
 909:	74 12                	je     91d <create_small_file+0x1d>
 90b:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 911:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 918:	00 
 919:	39 c4                	cmp    %eax,%esp
 91b:	75 ee                	jne    90b <create_small_file+0xb>
 91d:	81 ec 10 02 00 00    	sub    $0x210,%esp
 923:	83 8c 24 0c 02 00 00 	orl    $0x0,0x20c(%esp)
 92a:	00 
 92b:	89 e3                	mov    %esp,%ebx
    int fd = open(filename, O_CREATE | O_RDWR);
 92d:	83 ec 08             	sub    $0x8,%esp
 930:	68 02 02 00 00       	push   $0x202
 935:	ff 75 08             	push   0x8(%ebp)
 938:	e8 c6 f9 ff ff       	call   303 <open>
    if (fd < 0) {
 93d:	89 dc                	mov    %ebx,%esp
    int fd = open(filename, O_CREATE | O_RDWR);
 93f:	89 c6                	mov    %eax,%esi
    if (fd < 0) {
 941:	85 c0                	test   %eax,%eax
 943:	78 5a                	js     99f <create_small_file+0x9f>
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }

    // prepare the content to write
    for (int j = 0; j < bufflen; j++) {
 945:	31 c0                	xor    %eax,%eax
 947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 94e:	66 90                	xchg   %ax,%ax
        buff[j] = 'a' + (j % 4);
 950:	89 c2                	mov    %eax,%edx
 952:	83 e2 03             	and    $0x3,%edx
 955:	83 c2 61             	add    $0x61,%edx
 958:	88 14 03             	mov    %dl,(%ebx,%eax,1)
    for (int j = 0; j < bufflen; j++) {
 95b:	83 c0 01             	add    $0x1,%eax
 95e:	3d 02 02 00 00       	cmp    $0x202,%eax
 963:	75 eb                	jne    950 <create_small_file+0x50>
    }
    buff[bufflen - 1] = '\0';
    buff[bufflen - 2] = '\n';

    // write to file
    if (write(fd, buff, bufflen) != bufflen) {
 965:	83 ec 04             	sub    $0x4,%esp
    buff[bufflen - 2] = '\n';
 968:	ba 0a 00 00 00       	mov    $0xa,%edx
 96d:	66 89 93 00 02 00 00 	mov    %dx,0x200(%ebx)
    if (write(fd, buff, bufflen) != bufflen) {
 974:	68 02 02 00 00       	push   $0x202
 979:	53                   	push   %ebx
 97a:	56                   	push   %esi
 97b:	e8 63 f9 ff ff       	call   2e3 <write>
 980:	83 c4 10             	add    $0x10,%esp
 983:	3d 02 02 00 00       	cmp    $0x202,%eax
 988:	75 2a                	jne    9b4 <create_small_file+0xb4>
        printf(1, "XV6: Error: Write to file FAILED\n");
        failed();
    }

    close(fd);
 98a:	83 ec 0c             	sub    $0xc,%esp
 98d:	56                   	push   %esi
 98e:	e8 58 f9 ff ff       	call   2eb <close>
    return bufflen;
}
 993:	8d 65 f8             	lea    -0x8(%ebp),%esp
 996:	b8 02 02 00 00       	mov    $0x202,%eax
 99b:	5b                   	pop    %ebx
 99c:	5e                   	pop    %esi
 99d:	5d                   	pop    %ebp
 99e:	c3                   	ret    
        printf(1, "XV6: Failed to create file %s\n", filename);
 99f:	51                   	push   %ecx
 9a0:	ff 75 08             	push   0x8(%ebp)
 9a3:	68 ec 0c 00 00       	push   $0xcec
 9a8:	6a 01                	push   $0x1
 9aa:	e8 91 fa ff ff       	call   440 <printf>
        failed();
 9af:	e8 dc fd ff ff       	call   790 <failed>
        printf(1, "XV6: Error: Write to file FAILED\n");
 9b4:	50                   	push   %eax
 9b5:	50                   	push   %eax
 9b6:	68 0c 0d 00 00       	push   $0xd0c
 9bb:	6a 01                	push   $0x1
 9bd:	e8 7e fa ff ff       	call   440 <printf>
        failed();
 9c2:	e8 c9 fd ff ff       	call   790 <failed>
 9c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9ce:	66 90                	xchg   %ax,%ax

000009d0 <create_big_file>:

int create_big_file(char *filename, int N_PAGES) {
 9d0:	55                   	push   %ebp
 9d1:	89 e5                	mov    %esp,%ebp
 9d3:	57                   	push   %edi
 9d4:	56                   	push   %esi
 9d5:	53                   	push   %ebx
 9d6:	83 ec 1c             	sub    $0x1c,%esp
 9d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // create a file
    int bufflen = 512;
    char buff[bufflen + 1];
 9dc:	89 e0                	mov    %esp,%eax
 9de:	39 c4                	cmp    %eax,%esp
 9e0:	74 12                	je     9f4 <create_big_file+0x24>
 9e2:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 9e8:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 9ef:	00 
 9f0:	39 c4                	cmp    %eax,%esp
 9f2:	75 ee                	jne    9e2 <create_big_file+0x12>
 9f4:	81 ec 10 02 00 00    	sub    $0x210,%esp
 9fa:	83 8c 24 0c 02 00 00 	orl    $0x0,0x20c(%esp)
 a01:	00 
 a02:	89 e6                	mov    %esp,%esi
    int fd = open(filename, O_CREATE | O_RDWR);
 a04:	83 ec 08             	sub    $0x8,%esp
 a07:	68 02 02 00 00       	push   $0x202
 a0c:	53                   	push   %ebx
 a0d:	e8 f1 f8 ff ff       	call   303 <open>
    if (fd < 0) {
 a12:	89 f4                	mov    %esi,%esp
    int fd = open(filename, O_CREATE | O_RDWR);
 a14:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (fd < 0) {
 a17:	85 c0                	test   %eax,%eax
 a19:	0f 88 9c 00 00 00    	js     abb <create_big_file+0xeb>
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }
    // write in steps as we cannot have a buffer larger than PGSIZE
    char c = 'a';
    for (int i = 0; i < N_PAGES; i++) {
 a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
 a22:	8d 9e 00 02 00 00    	lea    0x200(%esi),%ebx
 a28:	89 f7                	mov    %esi,%edi
 a2a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 a31:	89 de                	mov    %ebx,%esi
 a33:	85 d2                	test   %edx,%edx
 a35:	7e 56                	jle    a8d <create_big_file+0xbd>
 a37:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
        int m = PGSIZE / bufflen;
        for (int k = 0; k < m; k++) {
 a3b:	31 d2                	xor    %edx,%edx
 a3d:	8d 58 61             	lea    0x61(%eax),%ebx
            // prepare the content to write
            for (int j = 0; j < bufflen; j++) {
 a40:	89 f8                	mov    %edi,%eax
 a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                buff[j] = c;
 a48:	88 18                	mov    %bl,(%eax)
            for (int j = 0; j < bufflen; j++) {
 a4a:	83 c0 01             	add    $0x1,%eax
 a4d:	39 f0                	cmp    %esi,%eax
 a4f:	75 f7                	jne    a48 <create_big_file+0x78>
            }
            buff[bufflen] = '\0';
            // write to file
            if (write(fd, buff, bufflen) != bufflen) {
 a51:	83 ec 04             	sub    $0x4,%esp
            buff[bufflen] = '\0';
 a54:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 a57:	c6 87 00 02 00 00 00 	movb   $0x0,0x200(%edi)
            if (write(fd, buff, bufflen) != bufflen) {
 a5e:	68 00 02 00 00       	push   $0x200
 a63:	57                   	push   %edi
 a64:	ff 75 e0             	push   -0x20(%ebp)
 a67:	e8 77 f8 ff ff       	call   2e3 <write>
 a6c:	83 c4 10             	add    $0x10,%esp
 a6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 a72:	3d 00 02 00 00       	cmp    $0x200,%eax
 a77:	75 2d                	jne    aa6 <create_big_file+0xd6>
        for (int k = 0; k < m; k++) {
 a79:	83 c2 01             	add    $0x1,%edx
 a7c:	83 fa 08             	cmp    $0x8,%edx
 a7f:	75 bf                	jne    a40 <create_big_file+0x70>
    for (int i = 0; i < N_PAGES; i++) {
 a81:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 a85:	8b 45 dc             	mov    -0x24(%ebp),%eax
 a88:	39 45 0c             	cmp    %eax,0xc(%ebp)
 a8b:	75 aa                	jne    a37 <create_big_file+0x67>
                failed();
            }
        }
        c++; // first page is filled with 'a', second with 'b', and so on
    }
    close(fd);
 a8d:	83 ec 0c             	sub    $0xc,%esp
 a90:	ff 75 e0             	push   -0x20(%ebp)
 a93:	e8 53 f8 ff ff       	call   2eb <close>
    return N_PAGES * PGSIZE;
 a98:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 a9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a9e:	5b                   	pop    %ebx
 a9f:	5e                   	pop    %esi
    return N_PAGES * PGSIZE;
 aa0:	c1 e0 0c             	shl    $0xc,%eax
}
 aa3:	5f                   	pop    %edi
 aa4:	5d                   	pop    %ebp
 aa5:	c3                   	ret    
                printf(1, "XV6: Write to file FAILED (%d, %d)\n", i, k);
 aa6:	52                   	push   %edx
 aa7:	ff 75 dc             	push   -0x24(%ebp)
 aaa:	68 30 0d 00 00       	push   $0xd30
 aaf:	6a 01                	push   $0x1
 ab1:	e8 8a f9 ff ff       	call   440 <printf>
                failed();
 ab6:	e8 d5 fc ff ff       	call   790 <failed>
        printf(1, "XV6: Failed to create file %s\n", filename);
 abb:	50                   	push   %eax
 abc:	53                   	push   %ebx
 abd:	68 ec 0c 00 00       	push   $0xcec
 ac2:	6a 01                	push   $0x1
 ac4:	e8 77 f9 ff ff       	call   440 <printf>
        failed();
 ac9:	e8 c2 fc ff ff       	call   790 <failed>
 ace:	66 90                	xchg   %ax,%ax

00000ad0 <va_exists>:

void va_exists(struct pgdirinfo *info, uint va, int expected) {
 ad0:	55                   	push   %ebp
    int found = 0;
    for (int i = 0; i < info->n_upages; i++) {
 ad1:	31 c0                	xor    %eax,%eax
void va_exists(struct pgdirinfo *info, uint va, int expected) {
 ad3:	89 e5                	mov    %esp,%ebp
 ad5:	53                   	push   %ebx
 ad6:	83 ec 04             	sub    $0x4,%esp
 ad9:	8b 55 08             	mov    0x8(%ebp),%edx
 adc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    for (int i = 0; i < info->n_upages; i++) {
 adf:	8b 0a                	mov    (%edx),%ecx
 ae1:	85 c9                	test   %ecx,%ecx
 ae3:	75 12                	jne    af7 <va_exists+0x27>
 ae5:	eb 1b                	jmp    b02 <va_exists+0x32>
 ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 aee:	66 90                	xchg   %ax,%ax
 af0:	83 c0 01             	add    $0x1,%eax
 af3:	39 c1                	cmp    %eax,%ecx
 af5:	74 19                	je     b10 <va_exists+0x40>
        if (info->va[i] == va) {
 af7:	39 5c 82 04          	cmp    %ebx,0x4(%edx,%eax,4)
 afb:	75 f3                	jne    af0 <va_exists+0x20>
            found = 1;
 afd:	b8 01 00 00 00       	mov    $0x1,%eax
            break;
        }
    }
    if (found != expected) {
 b02:	3b 45 10             	cmp    0x10(%ebp),%eax
 b05:	75 0d                	jne    b14 <va_exists+0x44>
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
        failed();
    }
}
 b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 b0a:	c9                   	leave  
 b0b:	c3                   	ret    
 b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int found = 0;
 b10:	31 c0                	xor    %eax,%eax
 b12:	eb ee                	jmp    b02 <va_exists+0x32>
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
 b14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 b18:	ba 0f 0c 00 00       	mov    $0xc0f,%edx
 b1d:	b8 13 0c 00 00       	mov    $0xc13,%eax
 b22:	0f 44 c2             	cmove  %edx,%eax
 b25:	50                   	push   %eax
 b26:	53                   	push   %ebx
 b27:	68 54 0d 00 00       	push   $0xd54
 b2c:	6a 01                	push   $0x1
 b2e:	e8 0d f9 ff ff       	call   440 <printf>
        failed();
 b33:	e8 58 fc ff ff       	call   790 <failed>
