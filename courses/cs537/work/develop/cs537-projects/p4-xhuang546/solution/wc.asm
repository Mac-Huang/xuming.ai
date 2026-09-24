
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

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
   f:	be 01 00 00 00       	mov    $0x1,%esi
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
  16:	83 ec 18             	sub    $0x18,%esp
  19:	8b 01                	mov    (%ecx),%eax
  1b:	8b 59 04             	mov    0x4(%ecx),%ebx
  1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  21:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
  24:	83 f8 01             	cmp    $0x1,%eax
  27:	7e 56                	jle    7f <main+0x7f>
  29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  30:	83 ec 08             	sub    $0x8,%esp
  33:	6a 00                	push   $0x0
  35:	ff 33                	push   (%ebx)
  37:	e8 d7 03 00 00       	call   413 <open>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	89 c7                	mov    %eax,%edi
  41:	85 c0                	test   %eax,%eax
  43:	78 26                	js     6b <main+0x6b>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
  45:	83 ec 08             	sub    $0x8,%esp
  48:	ff 33                	push   (%ebx)
  for(i = 1; i < argc; i++){
  4a:	83 c6 01             	add    $0x1,%esi
  4d:	83 c3 04             	add    $0x4,%ebx
    wc(fd, argv[i]);
  50:	50                   	push   %eax
  51:	e8 4a 00 00 00       	call   a0 <wc>
    close(fd);
  56:	89 3c 24             	mov    %edi,(%esp)
  59:	e8 9d 03 00 00       	call   3fb <close>
  for(i = 1; i < argc; i++){
  5e:	83 c4 10             	add    $0x10,%esp
  61:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  64:	75 ca                	jne    30 <main+0x30>
  }
  exit();
  66:	e8 68 03 00 00       	call   3d3 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
  6b:	50                   	push   %eax
  6c:	ff 33                	push   (%ebx)
  6e:	68 6b 0c 00 00       	push   $0xc6b
  73:	6a 01                	push   $0x1
  75:	e8 d6 04 00 00       	call   550 <printf>
      exit();
  7a:	e8 54 03 00 00       	call   3d3 <exit>
    wc(0, "");
  7f:	52                   	push   %edx
  80:	52                   	push   %edx
  81:	68 05 0d 00 00       	push   $0xd05
  86:	6a 00                	push   $0x0
  88:	e8 13 00 00 00       	call   a0 <wc>
    exit();
  8d:	e8 41 03 00 00       	call   3d3 <exit>
  92:	66 90                	xchg   %ax,%ax
  94:	66 90                	xchg   %ax,%ax
  96:	66 90                	xchg   %ax,%ax
  98:	66 90                	xchg   %ax,%ax
  9a:	66 90                	xchg   %ax,%ax
  9c:	66 90                	xchg   %ax,%ax
  9e:	66 90                	xchg   %ax,%ax

000000a0 <wc>:
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  l = w = c = 0;
  a6:	31 db                	xor    %ebx,%ebx
{
  a8:	83 ec 1c             	sub    $0x1c,%esp
  inword = 0;
  ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  b2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	68 00 02 00 00       	push   $0x200
  c8:	68 00 13 00 00       	push   $0x1300
  cd:	ff 75 08             	push   0x8(%ebp)
  d0:	e8 16 03 00 00       	call   3eb <read>
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	89 c6                	mov    %eax,%esi
  da:	85 c0                	test   %eax,%eax
  dc:	7e 62                	jle    140 <wc+0xa0>
    for(i=0; i<n; i++){
  de:	31 ff                	xor    %edi,%edi
  e0:	eb 14                	jmp    f6 <wc+0x56>
  e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        inword = 0;
  e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  ef:	83 c7 01             	add    $0x1,%edi
  f2:	39 fe                	cmp    %edi,%esi
  f4:	74 42                	je     138 <wc+0x98>
      if(buf[i] == '\n')
  f6:	0f be 87 00 13 00 00 	movsbl 0x1300(%edi),%eax
        l++;
  fd:	31 c9                	xor    %ecx,%ecx
  ff:	3c 0a                	cmp    $0xa,%al
 101:	0f 94 c1             	sete   %cl
      if(strchr(" \r\t\n\v", buf[i]))
 104:	83 ec 08             	sub    $0x8,%esp
 107:	50                   	push   %eax
        l++;
 108:	01 cb                	add    %ecx,%ebx
      if(strchr(" \r\t\n\v", buf[i]))
 10a:	68 48 0c 00 00       	push   $0xc48
 10f:	e8 4c 01 00 00       	call   260 <strchr>
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	75 cd                	jne    e8 <wc+0x48>
      else if(!inword){
 11b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 11e:	85 d2                	test   %edx,%edx
 120:	75 cd                	jne    ef <wc+0x4f>
    for(i=0; i<n; i++){
 122:	83 c7 01             	add    $0x1,%edi
        w++;
 125:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        inword = 1;
 129:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
 130:	39 fe                	cmp    %edi,%esi
 132:	75 c2                	jne    f6 <wc+0x56>
 134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      c++;
 138:	01 75 dc             	add    %esi,-0x24(%ebp)
 13b:	eb 83                	jmp    c0 <wc+0x20>
 13d:	8d 76 00             	lea    0x0(%esi),%esi
  if(n < 0){
 140:	75 24                	jne    166 <wc+0xc6>
  printf(1, "%d %d %d %s\n", l, w, c, name);
 142:	83 ec 08             	sub    $0x8,%esp
 145:	ff 75 0c             	push   0xc(%ebp)
 148:	ff 75 dc             	push   -0x24(%ebp)
 14b:	ff 75 e0             	push   -0x20(%ebp)
 14e:	53                   	push   %ebx
 14f:	68 5e 0c 00 00       	push   $0xc5e
 154:	6a 01                	push   $0x1
 156:	e8 f5 03 00 00       	call   550 <printf>
}
 15b:	83 c4 20             	add    $0x20,%esp
 15e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 161:	5b                   	pop    %ebx
 162:	5e                   	pop    %esi
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    
    printf(1, "wc: read error\n");
 166:	50                   	push   %eax
 167:	50                   	push   %eax
 168:	68 4e 0c 00 00       	push   $0xc4e
 16d:	6a 01                	push   $0x1
 16f:	e8 dc 03 00 00       	call   550 <printf>
    exit();
 174:	e8 5a 02 00 00       	call   3d3 <exit>
 179:	66 90                	xchg   %ax,%ax
 17b:	66 90                	xchg   %ax,%ax
 17d:	66 90                	xchg   %ax,%ax
 17f:	90                   	nop

00000180 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 180:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 181:	31 c0                	xor    %eax,%eax
{
 183:	89 e5                	mov    %esp,%ebp
 185:	53                   	push   %ebx
 186:	8b 4d 08             	mov    0x8(%ebp),%ecx
 189:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 190:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 194:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 197:	83 c0 01             	add    $0x1,%eax
 19a:	84 d2                	test   %dl,%dl
 19c:	75 f2                	jne    190 <strcpy+0x10>
    ;
  return os;
}
 19e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a1:	89 c8                	mov    %ecx,%eax
 1a3:	c9                   	leave  
 1a4:	c3                   	ret    
 1a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	53                   	push   %ebx
 1b4:	8b 55 08             	mov    0x8(%ebp),%edx
 1b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ba:	0f b6 02             	movzbl (%edx),%eax
 1bd:	84 c0                	test   %al,%al
 1bf:	75 17                	jne    1d8 <strcmp+0x28>
 1c1:	eb 3a                	jmp    1fd <strcmp+0x4d>
 1c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c7:	90                   	nop
 1c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 1cc:	83 c2 01             	add    $0x1,%edx
 1cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1d2:	84 c0                	test   %al,%al
 1d4:	74 1a                	je     1f0 <strcmp+0x40>
    p++, q++;
 1d6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 1d8:	0f b6 19             	movzbl (%ecx),%ebx
 1db:	38 c3                	cmp    %al,%bl
 1dd:	74 e9                	je     1c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 1df:	29 d8                	sub    %ebx,%eax
}
 1e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e4:	c9                   	leave  
 1e5:	c3                   	ret    
 1e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 1f0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 1f4:	31 c0                	xor    %eax,%eax
 1f6:	29 d8                	sub    %ebx,%eax
}
 1f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 1fd:	0f b6 19             	movzbl (%ecx),%ebx
 200:	31 c0                	xor    %eax,%eax
 202:	eb db                	jmp    1df <strcmp+0x2f>
 204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 20f:	90                   	nop

00000210 <strlen>:

uint
strlen(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 216:	80 3a 00             	cmpb   $0x0,(%edx)
 219:	74 15                	je     230 <strlen+0x20>
 21b:	31 c0                	xor    %eax,%eax
 21d:	8d 76 00             	lea    0x0(%esi),%esi
 220:	83 c0 01             	add    $0x1,%eax
 223:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 227:	89 c1                	mov    %eax,%ecx
 229:	75 f5                	jne    220 <strlen+0x10>
    ;
  return n;
}
 22b:	89 c8                	mov    %ecx,%eax
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    
 22f:	90                   	nop
  for(n = 0; s[n]; n++)
 230:	31 c9                	xor    %ecx,%ecx
}
 232:	5d                   	pop    %ebp
 233:	89 c8                	mov    %ecx,%eax
 235:	c3                   	ret    
 236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23d:	8d 76 00             	lea    0x0(%esi),%esi

00000240 <memset>:

void*
memset(void *dst, int c, uint n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 247:	8b 4d 10             	mov    0x10(%ebp),%ecx
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 d7                	mov    %edx,%edi
 24f:	fc                   	cld    
 250:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 252:	8b 7d fc             	mov    -0x4(%ebp),%edi
 255:	89 d0                	mov    %edx,%eax
 257:	c9                   	leave  
 258:	c3                   	ret    
 259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000260 <strchr>:

char*
strchr(const char *s, char c)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 26a:	0f b6 10             	movzbl (%eax),%edx
 26d:	84 d2                	test   %dl,%dl
 26f:	75 12                	jne    283 <strchr+0x23>
 271:	eb 1d                	jmp    290 <strchr+0x30>
 273:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 277:	90                   	nop
 278:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 27c:	83 c0 01             	add    $0x1,%eax
 27f:	84 d2                	test   %dl,%dl
 281:	74 0d                	je     290 <strchr+0x30>
    if(*s == c)
 283:	38 d1                	cmp    %dl,%cl
 285:	75 f1                	jne    278 <strchr+0x18>
      return (char*)s;
  return 0;
}
 287:	5d                   	pop    %ebp
 288:	c3                   	ret    
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 290:	31 c0                	xor    %eax,%eax
}
 292:	5d                   	pop    %ebp
 293:	c3                   	ret    
 294:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 29f:	90                   	nop

000002a0 <gets>:

char*
gets(char *buf, int max)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2a5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 2a8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2a9:	31 db                	xor    %ebx,%ebx
{
 2ab:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2ae:	eb 27                	jmp    2d7 <gets+0x37>
    cc = read(0, &c, 1);
 2b0:	83 ec 04             	sub    $0x4,%esp
 2b3:	6a 01                	push   $0x1
 2b5:	57                   	push   %edi
 2b6:	6a 00                	push   $0x0
 2b8:	e8 2e 01 00 00       	call   3eb <read>
    if(cc < 1)
 2bd:	83 c4 10             	add    $0x10,%esp
 2c0:	85 c0                	test   %eax,%eax
 2c2:	7e 1d                	jle    2e1 <gets+0x41>
      break;
    buf[i++] = c;
 2c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2c8:	8b 55 08             	mov    0x8(%ebp),%edx
 2cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2cf:	3c 0a                	cmp    $0xa,%al
 2d1:	74 1d                	je     2f0 <gets+0x50>
 2d3:	3c 0d                	cmp    $0xd,%al
 2d5:	74 19                	je     2f0 <gets+0x50>
  for(i=0; i+1 < max; ){
 2d7:	89 de                	mov    %ebx,%esi
 2d9:	83 c3 01             	add    $0x1,%ebx
 2dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2df:	7c cf                	jl     2b0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2eb:	5b                   	pop    %ebx
 2ec:	5e                   	pop    %esi
 2ed:	5f                   	pop    %edi
 2ee:	5d                   	pop    %ebp
 2ef:	c3                   	ret    
  buf[i] = '\0';
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	89 de                	mov    %ebx,%esi
 2f5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 2f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2fc:	5b                   	pop    %ebx
 2fd:	5e                   	pop    %esi
 2fe:	5f                   	pop    %edi
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret    
 301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30f:	90                   	nop

00000310 <stat>:

int
stat(const char *n, struct stat *st)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	56                   	push   %esi
 314:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 315:	83 ec 08             	sub    $0x8,%esp
 318:	6a 00                	push   $0x0
 31a:	ff 75 08             	push   0x8(%ebp)
 31d:	e8 f1 00 00 00       	call   413 <open>
  if(fd < 0)
 322:	83 c4 10             	add    $0x10,%esp
 325:	85 c0                	test   %eax,%eax
 327:	78 27                	js     350 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 329:	83 ec 08             	sub    $0x8,%esp
 32c:	ff 75 0c             	push   0xc(%ebp)
 32f:	89 c3                	mov    %eax,%ebx
 331:	50                   	push   %eax
 332:	e8 f4 00 00 00       	call   42b <fstat>
  close(fd);
 337:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 33a:	89 c6                	mov    %eax,%esi
  close(fd);
 33c:	e8 ba 00 00 00       	call   3fb <close>
  return r;
 341:	83 c4 10             	add    $0x10,%esp
}
 344:	8d 65 f8             	lea    -0x8(%ebp),%esp
 347:	89 f0                	mov    %esi,%eax
 349:	5b                   	pop    %ebx
 34a:	5e                   	pop    %esi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    
 34d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 350:	be ff ff ff ff       	mov    $0xffffffff,%esi
 355:	eb ed                	jmp    344 <stat+0x34>
 357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35e:	66 90                	xchg   %ax,%ax

00000360 <atoi>:

int
atoi(const char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 367:	0f be 02             	movsbl (%edx),%eax
 36a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 36d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 370:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 375:	77 1e                	ja     395 <atoi+0x35>
 377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 380:	83 c2 01             	add    $0x1,%edx
 383:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 386:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 38a:	0f be 02             	movsbl (%edx),%eax
 38d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 390:	80 fb 09             	cmp    $0x9,%bl
 393:	76 eb                	jbe    380 <atoi+0x20>
  return n;
}
 395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 398:	89 c8                	mov    %ecx,%eax
 39a:	c9                   	leave  
 39b:	c3                   	ret    
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	8b 45 10             	mov    0x10(%ebp),%eax
 3a7:	8b 55 08             	mov    0x8(%ebp),%edx
 3aa:	56                   	push   %esi
 3ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ae:	85 c0                	test   %eax,%eax
 3b0:	7e 13                	jle    3c5 <memmove+0x25>
 3b2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3b4:	89 d7                	mov    %edx,%edi
 3b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 3c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3c1:	39 f8                	cmp    %edi,%eax
 3c3:	75 fb                	jne    3c0 <memmove+0x20>
  return vdst;
}
 3c5:	5e                   	pop    %esi
 3c6:	89 d0                	mov    %edx,%eax
 3c8:	5f                   	pop    %edi
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3cb:	b8 01 00 00 00       	mov    $0x1,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <exit>:
SYSCALL(exit)
 3d3:	b8 02 00 00 00       	mov    $0x2,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <wait>:
SYSCALL(wait)
 3db:	b8 03 00 00 00       	mov    $0x3,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <pipe>:
SYSCALL(pipe)
 3e3:	b8 04 00 00 00       	mov    $0x4,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <read>:
SYSCALL(read)
 3eb:	b8 05 00 00 00       	mov    $0x5,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <write>:
SYSCALL(write)
 3f3:	b8 10 00 00 00       	mov    $0x10,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <close>:
SYSCALL(close)
 3fb:	b8 15 00 00 00       	mov    $0x15,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <kill>:
SYSCALL(kill)
 403:	b8 06 00 00 00       	mov    $0x6,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <exec>:
SYSCALL(exec)
 40b:	b8 07 00 00 00       	mov    $0x7,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <open>:
SYSCALL(open)
 413:	b8 0f 00 00 00       	mov    $0xf,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <mknod>:
SYSCALL(mknod)
 41b:	b8 11 00 00 00       	mov    $0x11,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <unlink>:
SYSCALL(unlink)
 423:	b8 12 00 00 00       	mov    $0x12,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <fstat>:
SYSCALL(fstat)
 42b:	b8 08 00 00 00       	mov    $0x8,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <link>:
SYSCALL(link)
 433:	b8 13 00 00 00       	mov    $0x13,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <mkdir>:
SYSCALL(mkdir)
 43b:	b8 14 00 00 00       	mov    $0x14,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <chdir>:
SYSCALL(chdir)
 443:	b8 09 00 00 00       	mov    $0x9,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <dup>:
SYSCALL(dup)
 44b:	b8 0a 00 00 00       	mov    $0xa,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <getpid>:
SYSCALL(getpid)
 453:	b8 0b 00 00 00       	mov    $0xb,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <sbrk>:
SYSCALL(sbrk)
 45b:	b8 0c 00 00 00       	mov    $0xc,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <sleep>:
SYSCALL(sleep)
 463:	b8 0d 00 00 00       	mov    $0xd,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <uptime>:
SYSCALL(uptime)
 46b:	b8 0e 00 00 00       	mov    $0xe,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <wmap>:
SYSCALL(wmap)
 473:	b8 16 00 00 00       	mov    $0x16,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <wunmap>:
SYSCALL(wunmap)
 47b:	b8 17 00 00 00       	mov    $0x17,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <wpunmap>:
SYSCALL(wpunmap)
 483:	b8 18 00 00 00       	mov    $0x18,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <getwmapinfo>:
SYSCALL(getwmapinfo)
 48b:	b8 19 00 00 00       	mov    $0x19,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <getpgdirinfo>:
SYSCALL(getpgdirinfo)
 493:	b8 1a 00 00 00       	mov    $0x1a,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    
 49b:	66 90                	xchg   %ax,%ax
 49d:	66 90                	xchg   %ax,%ax
 49f:	90                   	nop

000004a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 3c             	sub    $0x3c,%esp
 4a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4ac:	89 d1                	mov    %edx,%ecx
{
 4ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 4b1:	85 d2                	test   %edx,%edx
 4b3:	0f 89 7f 00 00 00    	jns    538 <printint+0x98>
 4b9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4bd:	74 79                	je     538 <printint+0x98>
    neg = 1;
 4bf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 4c6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 4c8:	31 db                	xor    %ebx,%ebx
 4ca:	8d 75 d7             	lea    -0x29(%ebp),%esi
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4d0:	89 c8                	mov    %ecx,%eax
 4d2:	31 d2                	xor    %edx,%edx
 4d4:	89 cf                	mov    %ecx,%edi
 4d6:	f7 75 c4             	divl   -0x3c(%ebp)
 4d9:	0f b6 92 e0 0c 00 00 	movzbl 0xce0(%edx),%edx
 4e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 4e3:	89 d8                	mov    %ebx,%eax
 4e5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 4e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 4eb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 4ee:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 4f1:	76 dd                	jbe    4d0 <printint+0x30>
  if(neg)
 4f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 4f6:	85 c9                	test   %ecx,%ecx
 4f8:	74 0c                	je     506 <printint+0x66>
    buf[i++] = '-';
 4fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 4ff:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 501:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 506:	8b 7d b8             	mov    -0x48(%ebp),%edi
 509:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 50d:	eb 07                	jmp    516 <printint+0x76>
 50f:	90                   	nop
    putc(fd, buf[i]);
 510:	0f b6 13             	movzbl (%ebx),%edx
 513:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 516:	83 ec 04             	sub    $0x4,%esp
 519:	88 55 d7             	mov    %dl,-0x29(%ebp)
 51c:	6a 01                	push   $0x1
 51e:	56                   	push   %esi
 51f:	57                   	push   %edi
 520:	e8 ce fe ff ff       	call   3f3 <write>
  while(--i >= 0)
 525:	83 c4 10             	add    $0x10,%esp
 528:	39 de                	cmp    %ebx,%esi
 52a:	75 e4                	jne    510 <printint+0x70>
}
 52c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52f:	5b                   	pop    %ebx
 530:	5e                   	pop    %esi
 531:	5f                   	pop    %edi
 532:	5d                   	pop    %ebp
 533:	c3                   	ret    
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 538:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 53f:	eb 87                	jmp    4c8 <printint+0x28>
 541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54f:	90                   	nop

00000550 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 559:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 55c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 55f:	0f b6 13             	movzbl (%ebx),%edx
 562:	84 d2                	test   %dl,%dl
 564:	74 6a                	je     5d0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 566:	8d 45 10             	lea    0x10(%ebp),%eax
 569:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 56c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 56f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 571:	89 45 d0             	mov    %eax,-0x30(%ebp)
 574:	eb 36                	jmp    5ac <printf+0x5c>
 576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57d:	8d 76 00             	lea    0x0(%esi),%esi
 580:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 583:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 588:	83 f8 25             	cmp    $0x25,%eax
 58b:	74 15                	je     5a2 <printf+0x52>
  write(fd, &c, 1);
 58d:	83 ec 04             	sub    $0x4,%esp
 590:	88 55 e7             	mov    %dl,-0x19(%ebp)
 593:	6a 01                	push   $0x1
 595:	57                   	push   %edi
 596:	56                   	push   %esi
 597:	e8 57 fe ff ff       	call   3f3 <write>
 59c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 59f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5a2:	0f b6 13             	movzbl (%ebx),%edx
 5a5:	83 c3 01             	add    $0x1,%ebx
 5a8:	84 d2                	test   %dl,%dl
 5aa:	74 24                	je     5d0 <printf+0x80>
    c = fmt[i] & 0xff;
 5ac:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 5af:	85 c9                	test   %ecx,%ecx
 5b1:	74 cd                	je     580 <printf+0x30>
      }
    } else if(state == '%'){
 5b3:	83 f9 25             	cmp    $0x25,%ecx
 5b6:	75 ea                	jne    5a2 <printf+0x52>
      if(c == 'd'){
 5b8:	83 f8 25             	cmp    $0x25,%eax
 5bb:	0f 84 07 01 00 00    	je     6c8 <printf+0x178>
 5c1:	83 e8 63             	sub    $0x63,%eax
 5c4:	83 f8 15             	cmp    $0x15,%eax
 5c7:	77 17                	ja     5e0 <printf+0x90>
 5c9:	ff 24 85 88 0c 00 00 	jmp    *0xc88(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d3:	5b                   	pop    %ebx
 5d4:	5e                   	pop    %esi
 5d5:	5f                   	pop    %edi
 5d6:	5d                   	pop    %ebp
 5d7:	c3                   	ret    
 5d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop
  write(fd, &c, 1);
 5e0:	83 ec 04             	sub    $0x4,%esp
 5e3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 5e6:	6a 01                	push   $0x1
 5e8:	57                   	push   %edi
 5e9:	56                   	push   %esi
 5ea:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5ee:	e8 00 fe ff ff       	call   3f3 <write>
        putc(fd, c);
 5f3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 5f7:	83 c4 0c             	add    $0xc,%esp
 5fa:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5fd:	6a 01                	push   $0x1
 5ff:	57                   	push   %edi
 600:	56                   	push   %esi
 601:	e8 ed fd ff ff       	call   3f3 <write>
        putc(fd, c);
 606:	83 c4 10             	add    $0x10,%esp
      state = 0;
 609:	31 c9                	xor    %ecx,%ecx
 60b:	eb 95                	jmp    5a2 <printf+0x52>
 60d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 610:	83 ec 0c             	sub    $0xc,%esp
 613:	b9 10 00 00 00       	mov    $0x10,%ecx
 618:	6a 00                	push   $0x0
 61a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 61d:	8b 10                	mov    (%eax),%edx
 61f:	89 f0                	mov    %esi,%eax
 621:	e8 7a fe ff ff       	call   4a0 <printint>
        ap++;
 626:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 62a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 62d:	31 c9                	xor    %ecx,%ecx
 62f:	e9 6e ff ff ff       	jmp    5a2 <printf+0x52>
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 638:	8b 45 d0             	mov    -0x30(%ebp),%eax
 63b:	8b 10                	mov    (%eax),%edx
        ap++;
 63d:	83 c0 04             	add    $0x4,%eax
 640:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 643:	85 d2                	test   %edx,%edx
 645:	0f 84 8d 00 00 00    	je     6d8 <printf+0x188>
        while(*s != 0){
 64b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 64e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 650:	84 c0                	test   %al,%al
 652:	0f 84 4a ff ff ff    	je     5a2 <printf+0x52>
 658:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 65b:	89 d3                	mov    %edx,%ebx
 65d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 660:	83 ec 04             	sub    $0x4,%esp
          s++;
 663:	83 c3 01             	add    $0x1,%ebx
 666:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 669:	6a 01                	push   $0x1
 66b:	57                   	push   %edi
 66c:	56                   	push   %esi
 66d:	e8 81 fd ff ff       	call   3f3 <write>
        while(*s != 0){
 672:	0f b6 03             	movzbl (%ebx),%eax
 675:	83 c4 10             	add    $0x10,%esp
 678:	84 c0                	test   %al,%al
 67a:	75 e4                	jne    660 <printf+0x110>
      state = 0;
 67c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 67f:	31 c9                	xor    %ecx,%ecx
 681:	e9 1c ff ff ff       	jmp    5a2 <printf+0x52>
 686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 690:	83 ec 0c             	sub    $0xc,%esp
 693:	b9 0a 00 00 00       	mov    $0xa,%ecx
 698:	6a 01                	push   $0x1
 69a:	e9 7b ff ff ff       	jmp    61a <printf+0xca>
 69f:	90                   	nop
        putc(fd, *ap);
 6a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 6a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6a6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 6a8:	6a 01                	push   $0x1
 6aa:	57                   	push   %edi
 6ab:	56                   	push   %esi
        putc(fd, *ap);
 6ac:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6af:	e8 3f fd ff ff       	call   3f3 <write>
        ap++;
 6b4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6bb:	31 c9                	xor    %ecx,%ecx
 6bd:	e9 e0 fe ff ff       	jmp    5a2 <printf+0x52>
 6c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 6c8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 6cb:	83 ec 04             	sub    $0x4,%esp
 6ce:	e9 2a ff ff ff       	jmp    5fd <printf+0xad>
 6d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6d7:	90                   	nop
          s = "(null)";
 6d8:	ba 7f 0c 00 00       	mov    $0xc7f,%edx
        while(*s != 0){
 6dd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 6e0:	b8 28 00 00 00       	mov    $0x28,%eax
 6e5:	89 d3                	mov    %edx,%ebx
 6e7:	e9 74 ff ff ff       	jmp    660 <printf+0x110>
 6ec:	66 90                	xchg   %ax,%ax
 6ee:	66 90                	xchg   %ax,%ax

000006f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	a1 00 15 00 00       	mov    0x1500,%eax
{
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	57                   	push   %edi
 6f9:	56                   	push   %esi
 6fa:	53                   	push   %ebx
 6fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 708:	89 c2                	mov    %eax,%edx
 70a:	8b 00                	mov    (%eax),%eax
 70c:	39 ca                	cmp    %ecx,%edx
 70e:	73 30                	jae    740 <free+0x50>
 710:	39 c1                	cmp    %eax,%ecx
 712:	72 04                	jb     718 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 714:	39 c2                	cmp    %eax,%edx
 716:	72 f0                	jb     708 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 718:	8b 73 fc             	mov    -0x4(%ebx),%esi
 71b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 71e:	39 f8                	cmp    %edi,%eax
 720:	74 30                	je     752 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 722:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 725:	8b 42 04             	mov    0x4(%edx),%eax
 728:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 72b:	39 f1                	cmp    %esi,%ecx
 72d:	74 3a                	je     769 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 72f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 731:	5b                   	pop    %ebx
  freep = p;
 732:	89 15 00 15 00 00    	mov    %edx,0x1500
}
 738:	5e                   	pop    %esi
 739:	5f                   	pop    %edi
 73a:	5d                   	pop    %ebp
 73b:	c3                   	ret    
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 740:	39 c2                	cmp    %eax,%edx
 742:	72 c4                	jb     708 <free+0x18>
 744:	39 c1                	cmp    %eax,%ecx
 746:	73 c0                	jae    708 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 748:	8b 73 fc             	mov    -0x4(%ebx),%esi
 74b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 74e:	39 f8                	cmp    %edi,%eax
 750:	75 d0                	jne    722 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 752:	03 70 04             	add    0x4(%eax),%esi
 755:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 758:	8b 02                	mov    (%edx),%eax
 75a:	8b 00                	mov    (%eax),%eax
 75c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 75f:	8b 42 04             	mov    0x4(%edx),%eax
 762:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 765:	39 f1                	cmp    %esi,%ecx
 767:	75 c6                	jne    72f <free+0x3f>
    p->s.size += bp->s.size;
 769:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 76c:	89 15 00 15 00 00    	mov    %edx,0x1500
    p->s.size += bp->s.size;
 772:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 775:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 778:	89 0a                	mov    %ecx,(%edx)
}
 77a:	5b                   	pop    %ebx
 77b:	5e                   	pop    %esi
 77c:	5f                   	pop    %edi
 77d:	5d                   	pop    %ebp
 77e:	c3                   	ret    
 77f:	90                   	nop

00000780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	56                   	push   %esi
 785:	53                   	push   %ebx
 786:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 789:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 78c:	8b 3d 00 15 00 00    	mov    0x1500,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 792:	8d 70 07             	lea    0x7(%eax),%esi
 795:	c1 ee 03             	shr    $0x3,%esi
 798:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 79b:	85 ff                	test   %edi,%edi
 79d:	0f 84 9d 00 00 00    	je     840 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 7a5:	8b 4a 04             	mov    0x4(%edx),%ecx
 7a8:	39 f1                	cmp    %esi,%ecx
 7aa:	73 6a                	jae    816 <malloc+0x96>
 7ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7b1:	39 de                	cmp    %ebx,%esi
 7b3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 7b6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7c0:	eb 17                	jmp    7d9 <malloc+0x59>
 7c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7ca:	8b 48 04             	mov    0x4(%eax),%ecx
 7cd:	39 f1                	cmp    %esi,%ecx
 7cf:	73 4f                	jae    820 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7d1:	8b 3d 00 15 00 00    	mov    0x1500,%edi
 7d7:	89 c2                	mov    %eax,%edx
 7d9:	39 d7                	cmp    %edx,%edi
 7db:	75 eb                	jne    7c8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 7dd:	83 ec 0c             	sub    $0xc,%esp
 7e0:	ff 75 e4             	push   -0x1c(%ebp)
 7e3:	e8 73 fc ff ff       	call   45b <sbrk>
  if(p == (char*)-1)
 7e8:	83 c4 10             	add    $0x10,%esp
 7eb:	83 f8 ff             	cmp    $0xffffffff,%eax
 7ee:	74 1c                	je     80c <malloc+0x8c>
  hp->s.size = nu;
 7f0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7f3:	83 ec 0c             	sub    $0xc,%esp
 7f6:	83 c0 08             	add    $0x8,%eax
 7f9:	50                   	push   %eax
 7fa:	e8 f1 fe ff ff       	call   6f0 <free>
  return freep;
 7ff:	8b 15 00 15 00 00    	mov    0x1500,%edx
      if((p = morecore(nunits)) == 0)
 805:	83 c4 10             	add    $0x10,%esp
 808:	85 d2                	test   %edx,%edx
 80a:	75 bc                	jne    7c8 <malloc+0x48>
        return 0;
  }
}
 80c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 80f:	31 c0                	xor    %eax,%eax
}
 811:	5b                   	pop    %ebx
 812:	5e                   	pop    %esi
 813:	5f                   	pop    %edi
 814:	5d                   	pop    %ebp
 815:	c3                   	ret    
    if(p->s.size >= nunits){
 816:	89 d0                	mov    %edx,%eax
 818:	89 fa                	mov    %edi,%edx
 81a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 820:	39 ce                	cmp    %ecx,%esi
 822:	74 4c                	je     870 <malloc+0xf0>
        p->s.size -= nunits;
 824:	29 f1                	sub    %esi,%ecx
 826:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 829:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 82c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 82f:	89 15 00 15 00 00    	mov    %edx,0x1500
}
 835:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 838:	83 c0 08             	add    $0x8,%eax
}
 83b:	5b                   	pop    %ebx
 83c:	5e                   	pop    %esi
 83d:	5f                   	pop    %edi
 83e:	5d                   	pop    %ebp
 83f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 840:	c7 05 00 15 00 00 04 	movl   $0x1504,0x1500
 847:	15 00 00 
    base.s.size = 0;
 84a:	bf 04 15 00 00       	mov    $0x1504,%edi
    base.s.ptr = freep = prevp = &base;
 84f:	c7 05 04 15 00 00 04 	movl   $0x1504,0x1504
 856:	15 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 859:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 85b:	c7 05 08 15 00 00 00 	movl   $0x0,0x1508
 862:	00 00 00 
    if(p->s.size >= nunits){
 865:	e9 42 ff ff ff       	jmp    7ac <malloc+0x2c>
 86a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 870:	8b 08                	mov    (%eax),%ecx
 872:	89 0a                	mov    %ecx,(%edx)
 874:	eb b9                	jmp    82f <malloc+0xaf>
 876:	66 90                	xchg   %ax,%ax
 878:	66 90                	xchg   %ax,%ax
 87a:	66 90                	xchg   %ax,%ax
 87c:	66 90                	xchg   %ax,%ax
 87e:	66 90                	xchg   %ax,%ax

00000880 <finish>:
#include "wmaptest.h"

// TEST HELPER
void finish() {
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp
 883:	83 ec 10             	sub    $0x10,%esp
    printf(1, "XV6: Test finished.\n");
 886:	68 f1 0c 00 00       	push   $0xcf1
 88b:	6a 01                	push   $0x1
 88d:	e8 be fc ff ff       	call   550 <printf>
    exit();
 892:	e8 3c fb ff ff       	call   3d3 <exit>
 897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 89e:	66 90                	xchg   %ax,%ax

000008a0 <failed>:
}

void failed() {
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	83 ec 10             	sub    $0x10,%esp
    printf(1, "XV6: Test failed.\n");
 8a6:	68 06 0d 00 00       	push   $0xd06
 8ab:	6a 01                	push   $0x1
 8ad:	e8 9e fc ff ff       	call   550 <printf>
    exit();
 8b2:	e8 1c fb ff ff       	call   3d3 <exit>
 8b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8be:	66 90                	xchg   %ax,%ax

000008c0 <print_mmap_info>:
}

/**
 * @brief Prints details of a wmapinfo struct.
 */
void print_mmap_info(struct wmapinfo *info) {
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	56                   	push   %esi
 8c4:	53                   	push   %ebx
 8c5:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "XV6: ------ Total mmaps: %d\n", info->total_mmaps);
 8c8:	83 ec 04             	sub    $0x4,%esp
 8cb:	ff 36                	push   (%esi)
 8cd:	68 19 0d 00 00       	push   $0xd19
 8d2:	6a 01                	push   $0x1
 8d4:	e8 77 fc ff ff       	call   550 <printf>
    for (int i = 0; i < info->total_mmaps; i++) {
 8d9:	8b 06                	mov    (%esi),%eax
 8db:	83 c4 10             	add    $0x10,%esp
 8de:	85 c0                	test   %eax,%eax
 8e0:	7e 4a                	jle    92c <print_mmap_info+0x6c>
 8e2:	31 db                	xor    %ebx,%ebx
 8e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
            i, info->addr[i], info->length[i], info->addr[i] + info->length[i], info->flags[i], info->fd[i], info->refcnt[i], info->n_loaded_pages[i]);
 8e8:	8b 44 9e 04          	mov    0x4(%esi,%ebx,4),%eax
 8ec:	8b 54 9e 44          	mov    0x44(%esi,%ebx,4),%edx
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
 8f0:	83 ec 08             	sub    $0x8,%esp
 8f3:	ff b4 9e 44 01 00 00 	push   0x144(%esi,%ebx,4)
 8fa:	ff b4 9e 04 01 00 00 	push   0x104(%esi,%ebx,4)
 901:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
 904:	ff b4 9e c4 00 00 00 	push   0xc4(%esi,%ebx,4)
 90b:	ff b4 9e 84 00 00 00 	push   0x84(%esi,%ebx,4)
 912:	51                   	push   %ecx
 913:	52                   	push   %edx
 914:	50                   	push   %eax
 915:	53                   	push   %ebx
    for (int i = 0; i < info->total_mmaps; i++) {
 916:	83 c3 01             	add    $0x1,%ebx
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
 919:	68 5c 0d 00 00       	push   $0xd5c
 91e:	6a 01                	push   $0x1
 920:	e8 2b fc ff ff       	call   550 <printf>
    for (int i = 0; i < info->total_mmaps; i++) {
 925:	83 c4 30             	add    $0x30,%esp
 928:	39 1e                	cmp    %ebx,(%esi)
 92a:	7f bc                	jg     8e8 <print_mmap_info+0x28>
    }
}
 92c:	8d 65 f8             	lea    -0x8(%ebp),%esp
 92f:	5b                   	pop    %ebx
 930:	5e                   	pop    %esi
 931:	5d                   	pop    %ebp
 932:	c3                   	ret    
 933:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000940 <test_getwmapinfo>:

void test_getwmapinfo(struct wmapinfo *info) {
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	53                   	push   %ebx
 944:	83 ec 10             	sub    $0x10,%esp
 947:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int ret = getwmapinfo(info);
 94a:	53                   	push   %ebx
 94b:	e8 3b fb ff ff       	call   48b <getwmapinfo>
    if (ret < 0) {
 950:	83 c4 10             	add    $0x10,%esp
 953:	85 c0                	test   %eax,%eax
 955:	78 0c                	js     963 <test_getwmapinfo+0x23>
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
        failed();
    }
    print_mmap_info(info);
 957:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 95a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 95d:	c9                   	leave  
    print_mmap_info(info);
 95e:	e9 5d ff ff ff       	jmp    8c0 <print_mmap_info>
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
 963:	52                   	push   %edx
 964:	50                   	push   %eax
 965:	68 bc 0d 00 00       	push   $0xdbc
 96a:	6a 01                	push   $0x1
 96c:	e8 df fb ff ff       	call   550 <printf>
        failed();
 971:	e8 2a ff ff ff       	call   8a0 <failed>
 976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 97d:	8d 76 00             	lea    0x0(%esi),%esi

00000980 <print_pgdir_info>:

/**
 * @brief Prints details of a pgdirinfo struct.
 */
void print_pgdir_info(struct pgdirinfo *info) {
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	56                   	push   %esi
 984:	53                   	push   %ebx
 985:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "XV6: Total n_upages: %d\n", info->n_upages);
 988:	83 ec 04             	sub    $0x4,%esp
 98b:	ff 36                	push   (%esi)
 98d:	68 36 0d 00 00       	push   $0xd36
 992:	6a 01                	push   $0x1
 994:	e8 b7 fb ff ff       	call   550 <printf>
    for (int i = 0; i < info->n_upages; i++) {
 999:	8b 06                	mov    (%esi),%eax
 99b:	83 c4 10             	add    $0x10,%esp
 99e:	85 c0                	test   %eax,%eax
 9a0:	74 2b                	je     9cd <print_pgdir_info+0x4d>
 9a2:	31 db                	xor    %ebx,%ebx
 9a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
 9a8:	83 ec 0c             	sub    $0xc,%esp
 9ab:	ff b4 9e 84 00 00 00 	push   0x84(%esi,%ebx,4)
 9b2:	ff 74 9e 04          	push   0x4(%esi,%ebx,4)
 9b6:	53                   	push   %ebx
    for (int i = 0; i < info->n_upages; i++) {
 9b7:	83 c3 01             	add    $0x1,%ebx
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
 9ba:	68 dc 0d 00 00       	push   $0xddc
 9bf:	6a 01                	push   $0x1
 9c1:	e8 8a fb ff ff       	call   550 <printf>
    for (int i = 0; i < info->n_upages; i++) {
 9c6:	83 c4 20             	add    $0x20,%esp
 9c9:	39 1e                	cmp    %ebx,(%esi)
 9cb:	77 db                	ja     9a8 <print_pgdir_info+0x28>
            i, info->va[i], info->pa[i]);
    }
}
 9cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
 9d0:	5b                   	pop    %ebx
 9d1:	5e                   	pop    %esi
 9d2:	5d                   	pop    %ebp
 9d3:	c3                   	ret    
 9d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9df:	90                   	nop

000009e0 <test_getpgdirinfo>:

void test_getpgdirinfo(struct pgdirinfo *info) {
 9e0:	55                   	push   %ebp
 9e1:	89 e5                	mov    %esp,%ebp
 9e3:	83 ec 14             	sub    $0x14,%esp
    int ret = getpgdirinfo(info);
 9e6:	ff 75 08             	push   0x8(%ebp)
 9e9:	e8 a5 fa ff ff       	call   493 <getpgdirinfo>
    if (ret < 0) {
 9ee:	83 c4 10             	add    $0x10,%esp
 9f1:	85 c0                	test   %eax,%eax
 9f3:	78 02                	js     9f7 <test_getpgdirinfo+0x17>
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
        failed();
    }
    // print_pgdir_info(info);
}
 9f5:	c9                   	leave  
 9f6:	c3                   	ret    
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
 9f7:	52                   	push   %edx
 9f8:	50                   	push   %eax
 9f9:	68 08 0e 00 00       	push   $0xe08
 9fe:	6a 01                	push   $0x1
 a00:	e8 4b fb ff ff       	call   550 <printf>
        failed();
 a05:	e8 96 fe ff ff       	call   8a0 <failed>
 a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000a10 <create_small_file>:

int create_small_file(char *filename) {
 a10:	55                   	push   %ebp
 a11:	89 e5                	mov    %esp,%ebp
 a13:	56                   	push   %esi
 a14:	53                   	push   %ebx

    // create a file
    int bufflen = 512 + 2;
    char buff[bufflen];
 a15:	89 e0                	mov    %esp,%eax
 a17:	39 c4                	cmp    %eax,%esp
 a19:	74 12                	je     a2d <create_small_file+0x1d>
 a1b:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 a21:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 a28:	00 
 a29:	39 c4                	cmp    %eax,%esp
 a2b:	75 ee                	jne    a1b <create_small_file+0xb>
 a2d:	81 ec 10 02 00 00    	sub    $0x210,%esp
 a33:	83 8c 24 0c 02 00 00 	orl    $0x0,0x20c(%esp)
 a3a:	00 
 a3b:	89 e3                	mov    %esp,%ebx
    int fd = open(filename, O_CREATE | O_RDWR);
 a3d:	83 ec 08             	sub    $0x8,%esp
 a40:	68 02 02 00 00       	push   $0x202
 a45:	ff 75 08             	push   0x8(%ebp)
 a48:	e8 c6 f9 ff ff       	call   413 <open>
    if (fd < 0) {
 a4d:	89 dc                	mov    %ebx,%esp
    int fd = open(filename, O_CREATE | O_RDWR);
 a4f:	89 c6                	mov    %eax,%esi
    if (fd < 0) {
 a51:	85 c0                	test   %eax,%eax
 a53:	78 5a                	js     aaf <create_small_file+0x9f>
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }

    // prepare the content to write
    for (int j = 0; j < bufflen; j++) {
 a55:	31 c0                	xor    %eax,%eax
 a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a5e:	66 90                	xchg   %ax,%ax
        buff[j] = 'a' + (j % 4);
 a60:	89 c2                	mov    %eax,%edx
 a62:	83 e2 03             	and    $0x3,%edx
 a65:	83 c2 61             	add    $0x61,%edx
 a68:	88 14 03             	mov    %dl,(%ebx,%eax,1)
    for (int j = 0; j < bufflen; j++) {
 a6b:	83 c0 01             	add    $0x1,%eax
 a6e:	3d 02 02 00 00       	cmp    $0x202,%eax
 a73:	75 eb                	jne    a60 <create_small_file+0x50>
    }
    buff[bufflen - 1] = '\0';
    buff[bufflen - 2] = '\n';

    // write to file
    if (write(fd, buff, bufflen) != bufflen) {
 a75:	83 ec 04             	sub    $0x4,%esp
    buff[bufflen - 2] = '\n';
 a78:	ba 0a 00 00 00       	mov    $0xa,%edx
 a7d:	66 89 93 00 02 00 00 	mov    %dx,0x200(%ebx)
    if (write(fd, buff, bufflen) != bufflen) {
 a84:	68 02 02 00 00       	push   $0x202
 a89:	53                   	push   %ebx
 a8a:	56                   	push   %esi
 a8b:	e8 63 f9 ff ff       	call   3f3 <write>
 a90:	83 c4 10             	add    $0x10,%esp
 a93:	3d 02 02 00 00       	cmp    $0x202,%eax
 a98:	75 2a                	jne    ac4 <create_small_file+0xb4>
        printf(1, "XV6: Error: Write to file FAILED\n");
        failed();
    }

    close(fd);
 a9a:	83 ec 0c             	sub    $0xc,%esp
 a9d:	56                   	push   %esi
 a9e:	e8 58 f9 ff ff       	call   3fb <close>
    return bufflen;
}
 aa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
 aa6:	b8 02 02 00 00       	mov    $0x202,%eax
 aab:	5b                   	pop    %ebx
 aac:	5e                   	pop    %esi
 aad:	5d                   	pop    %ebp
 aae:	c3                   	ret    
        printf(1, "XV6: Failed to create file %s\n", filename);
 aaf:	51                   	push   %ecx
 ab0:	ff 75 08             	push   0x8(%ebp)
 ab3:	68 2c 0e 00 00       	push   $0xe2c
 ab8:	6a 01                	push   $0x1
 aba:	e8 91 fa ff ff       	call   550 <printf>
        failed();
 abf:	e8 dc fd ff ff       	call   8a0 <failed>
        printf(1, "XV6: Error: Write to file FAILED\n");
 ac4:	50                   	push   %eax
 ac5:	50                   	push   %eax
 ac6:	68 4c 0e 00 00       	push   $0xe4c
 acb:	6a 01                	push   $0x1
 acd:	e8 7e fa ff ff       	call   550 <printf>
        failed();
 ad2:	e8 c9 fd ff ff       	call   8a0 <failed>
 ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 ade:	66 90                	xchg   %ax,%ax

00000ae0 <create_big_file>:

int create_big_file(char *filename, int N_PAGES) {
 ae0:	55                   	push   %ebp
 ae1:	89 e5                	mov    %esp,%ebp
 ae3:	57                   	push   %edi
 ae4:	56                   	push   %esi
 ae5:	53                   	push   %ebx
 ae6:	83 ec 1c             	sub    $0x1c,%esp
 ae9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // create a file
    int bufflen = 512;
    char buff[bufflen + 1];
 aec:	89 e0                	mov    %esp,%eax
 aee:	39 c4                	cmp    %eax,%esp
 af0:	74 12                	je     b04 <create_big_file+0x24>
 af2:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 af8:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 aff:	00 
 b00:	39 c4                	cmp    %eax,%esp
 b02:	75 ee                	jne    af2 <create_big_file+0x12>
 b04:	81 ec 10 02 00 00    	sub    $0x210,%esp
 b0a:	83 8c 24 0c 02 00 00 	orl    $0x0,0x20c(%esp)
 b11:	00 
 b12:	89 e6                	mov    %esp,%esi
    int fd = open(filename, O_CREATE | O_RDWR);
 b14:	83 ec 08             	sub    $0x8,%esp
 b17:	68 02 02 00 00       	push   $0x202
 b1c:	53                   	push   %ebx
 b1d:	e8 f1 f8 ff ff       	call   413 <open>
    if (fd < 0) {
 b22:	89 f4                	mov    %esi,%esp
    int fd = open(filename, O_CREATE | O_RDWR);
 b24:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (fd < 0) {
 b27:	85 c0                	test   %eax,%eax
 b29:	0f 88 9c 00 00 00    	js     bcb <create_big_file+0xeb>
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }
    // write in steps as we cannot have a buffer larger than PGSIZE
    char c = 'a';
    for (int i = 0; i < N_PAGES; i++) {
 b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
 b32:	8d 9e 00 02 00 00    	lea    0x200(%esi),%ebx
 b38:	89 f7                	mov    %esi,%edi
 b3a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 b41:	89 de                	mov    %ebx,%esi
 b43:	85 d2                	test   %edx,%edx
 b45:	7e 56                	jle    b9d <create_big_file+0xbd>
 b47:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
        int m = PGSIZE / bufflen;
        for (int k = 0; k < m; k++) {
 b4b:	31 d2                	xor    %edx,%edx
 b4d:	8d 58 61             	lea    0x61(%eax),%ebx
            // prepare the content to write
            for (int j = 0; j < bufflen; j++) {
 b50:	89 f8                	mov    %edi,%eax
 b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                buff[j] = c;
 b58:	88 18                	mov    %bl,(%eax)
            for (int j = 0; j < bufflen; j++) {
 b5a:	83 c0 01             	add    $0x1,%eax
 b5d:	39 f0                	cmp    %esi,%eax
 b5f:	75 f7                	jne    b58 <create_big_file+0x78>
            }
            buff[bufflen] = '\0';
            // write to file
            if (write(fd, buff, bufflen) != bufflen) {
 b61:	83 ec 04             	sub    $0x4,%esp
            buff[bufflen] = '\0';
 b64:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 b67:	c6 87 00 02 00 00 00 	movb   $0x0,0x200(%edi)
            if (write(fd, buff, bufflen) != bufflen) {
 b6e:	68 00 02 00 00       	push   $0x200
 b73:	57                   	push   %edi
 b74:	ff 75 e0             	push   -0x20(%ebp)
 b77:	e8 77 f8 ff ff       	call   3f3 <write>
 b7c:	83 c4 10             	add    $0x10,%esp
 b7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 b82:	3d 00 02 00 00       	cmp    $0x200,%eax
 b87:	75 2d                	jne    bb6 <create_big_file+0xd6>
        for (int k = 0; k < m; k++) {
 b89:	83 c2 01             	add    $0x1,%edx
 b8c:	83 fa 08             	cmp    $0x8,%edx
 b8f:	75 bf                	jne    b50 <create_big_file+0x70>
    for (int i = 0; i < N_PAGES; i++) {
 b91:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 b95:	8b 45 dc             	mov    -0x24(%ebp),%eax
 b98:	39 45 0c             	cmp    %eax,0xc(%ebp)
 b9b:	75 aa                	jne    b47 <create_big_file+0x67>
                failed();
            }
        }
        c++; // first page is filled with 'a', second with 'b', and so on
    }
    close(fd);
 b9d:	83 ec 0c             	sub    $0xc,%esp
 ba0:	ff 75 e0             	push   -0x20(%ebp)
 ba3:	e8 53 f8 ff ff       	call   3fb <close>
    return N_PAGES * PGSIZE;
 ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 bab:	8d 65 f4             	lea    -0xc(%ebp),%esp
 bae:	5b                   	pop    %ebx
 baf:	5e                   	pop    %esi
    return N_PAGES * PGSIZE;
 bb0:	c1 e0 0c             	shl    $0xc,%eax
}
 bb3:	5f                   	pop    %edi
 bb4:	5d                   	pop    %ebp
 bb5:	c3                   	ret    
                printf(1, "XV6: Write to file FAILED (%d, %d)\n", i, k);
 bb6:	52                   	push   %edx
 bb7:	ff 75 dc             	push   -0x24(%ebp)
 bba:	68 70 0e 00 00       	push   $0xe70
 bbf:	6a 01                	push   $0x1
 bc1:	e8 8a f9 ff ff       	call   550 <printf>
                failed();
 bc6:	e8 d5 fc ff ff       	call   8a0 <failed>
        printf(1, "XV6: Failed to create file %s\n", filename);
 bcb:	50                   	push   %eax
 bcc:	53                   	push   %ebx
 bcd:	68 2c 0e 00 00       	push   $0xe2c
 bd2:	6a 01                	push   $0x1
 bd4:	e8 77 f9 ff ff       	call   550 <printf>
        failed();
 bd9:	e8 c2 fc ff ff       	call   8a0 <failed>
 bde:	66 90                	xchg   %ax,%ax

00000be0 <va_exists>:

void va_exists(struct pgdirinfo *info, uint va, int expected) {
 be0:	55                   	push   %ebp
    int found = 0;
    for (int i = 0; i < info->n_upages; i++) {
 be1:	31 c0                	xor    %eax,%eax
void va_exists(struct pgdirinfo *info, uint va, int expected) {
 be3:	89 e5                	mov    %esp,%ebp
 be5:	53                   	push   %ebx
 be6:	83 ec 04             	sub    $0x4,%esp
 be9:	8b 55 08             	mov    0x8(%ebp),%edx
 bec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    for (int i = 0; i < info->n_upages; i++) {
 bef:	8b 0a                	mov    (%edx),%ecx
 bf1:	85 c9                	test   %ecx,%ecx
 bf3:	75 12                	jne    c07 <va_exists+0x27>
 bf5:	eb 1b                	jmp    c12 <va_exists+0x32>
 bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 bfe:	66 90                	xchg   %ax,%ax
 c00:	83 c0 01             	add    $0x1,%eax
 c03:	39 c1                	cmp    %eax,%ecx
 c05:	74 19                	je     c20 <va_exists+0x40>
        if (info->va[i] == va) {
 c07:	39 5c 82 04          	cmp    %ebx,0x4(%edx,%eax,4)
 c0b:	75 f3                	jne    c00 <va_exists+0x20>
            found = 1;
 c0d:	b8 01 00 00 00       	mov    $0x1,%eax
            break;
        }
    }
    if (found != expected) {
 c12:	3b 45 10             	cmp    0x10(%ebp),%eax
 c15:	75 0d                	jne    c24 <va_exists+0x44>
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
        failed();
    }
}
 c17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 c1a:	c9                   	leave  
 c1b:	c3                   	ret    
 c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int found = 0;
 c20:	31 c0                	xor    %eax,%eax
 c22:	eb ee                	jmp    c12 <va_exists+0x32>
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
 c24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 c28:	ba 4f 0d 00 00       	mov    $0xd4f,%edx
 c2d:	b8 53 0d 00 00       	mov    $0xd53,%eax
 c32:	0f 44 c2             	cmove  %edx,%eax
 c35:	50                   	push   %eax
 c36:	53                   	push   %ebx
 c37:	68 94 0e 00 00       	push   $0xe94
 c3c:	6a 01                	push   $0x1
 c3e:	e8 0d f9 ff ff       	call   550 <printf>
        failed();
 c43:	e8 58 fc ff ff       	call   8a0 <failed>
