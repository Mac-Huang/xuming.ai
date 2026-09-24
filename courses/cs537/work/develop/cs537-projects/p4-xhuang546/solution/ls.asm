
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
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
   f:	53                   	push   %ebx
  10:	bb 01 00 00 00       	mov    $0x1,%ebx
  15:	51                   	push   %ecx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 31                	mov    (%ecx),%esi
  1b:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1e:	83 fe 01             	cmp    $0x1,%esi
  21:	7e 1f                	jle    42 <main+0x42>
  23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  27:	90                   	nop
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 34 9f             	push   (%edi,%ebx,4)
  for(i=1; i<argc; i++)
  2e:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
  31:	e8 ca 00 00 00       	call   100 <ls>
  for(i=1; i<argc; i++)
  36:	83 c4 10             	add    $0x10,%esp
  39:	39 de                	cmp    %ebx,%esi
  3b:	75 eb                	jne    28 <main+0x28>
  exit();
  3d:	e8 51 05 00 00       	call   593 <exit>
    ls(".");
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	68 50 0e 00 00       	push   $0xe50
  4a:	e8 b1 00 00 00       	call   100 <ls>
    exit();
  4f:	e8 3f 05 00 00       	call   593 <exit>
  54:	66 90                	xchg   %ax,%ax
  56:	66 90                	xchg   %ax,%ax
  58:	66 90                	xchg   %ax,%ax
  5a:	66 90                	xchg   %ax,%ax
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <fmtname>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	56                   	push   %esi
  6c:	e8 5f 03 00 00       	call   3d0 <strlen>
  71:	83 c4 10             	add    $0x10,%esp
  74:	01 f0                	add    %esi,%eax
  76:	89 c3                	mov    %eax,%ebx
  78:	73 0f                	jae    89 <fmtname+0x29>
  7a:	eb 12                	jmp    8e <fmtname+0x2e>
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  83:	39 c6                	cmp    %eax,%esi
  85:	77 0a                	ja     91 <fmtname+0x31>
  87:	89 c3                	mov    %eax,%ebx
  89:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8c:	75 f2                	jne    80 <fmtname+0x20>
  p++;
  8e:	83 c3 01             	add    $0x1,%ebx
  if(strlen(p) >= DIRSIZ)
  91:	83 ec 0c             	sub    $0xc,%esp
  94:	53                   	push   %ebx
  95:	e8 36 03 00 00       	call   3d0 <strlen>
  9a:	83 c4 10             	add    $0x10,%esp
  9d:	83 f8 0d             	cmp    $0xd,%eax
  a0:	77 4a                	ja     ec <fmtname+0x8c>
  memmove(buf, p, strlen(p));
  a2:	83 ec 0c             	sub    $0xc,%esp
  a5:	53                   	push   %ebx
  a6:	e8 25 03 00 00       	call   3d0 <strlen>
  ab:	83 c4 0c             	add    $0xc,%esp
  ae:	50                   	push   %eax
  af:	53                   	push   %ebx
  b0:	68 1c 15 00 00       	push   $0x151c
  b5:	e8 a6 04 00 00       	call   560 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ba:	89 1c 24             	mov    %ebx,(%esp)
  bd:	e8 0e 03 00 00       	call   3d0 <strlen>
  c2:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
  c5:	bb 1c 15 00 00       	mov    $0x151c,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	89 c6                	mov    %eax,%esi
  cc:	e8 ff 02 00 00       	call   3d0 <strlen>
  d1:	ba 0e 00 00 00       	mov    $0xe,%edx
  d6:	83 c4 0c             	add    $0xc,%esp
  d9:	29 f2                	sub    %esi,%edx
  db:	05 1c 15 00 00       	add    $0x151c,%eax
  e0:	52                   	push   %edx
  e1:	6a 20                	push   $0x20
  e3:	50                   	push   %eax
  e4:	e8 17 03 00 00       	call   400 <memset>
  return buf;
  e9:	83 c4 10             	add    $0x10,%esp
}
  ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ef:	89 d8                	mov    %ebx,%eax
  f1:	5b                   	pop    %ebx
  f2:	5e                   	pop    %esi
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000100 <ls>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 64 02 00 00    	sub    $0x264,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
 10f:	6a 00                	push   $0x0
 111:	57                   	push   %edi
 112:	e8 bc 04 00 00       	call   5d3 <open>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	0f 88 9e 01 00 00    	js     2c0 <ls+0x1c0>
  if(fstat(fd, &st) < 0){
 122:	83 ec 08             	sub    $0x8,%esp
 125:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 12b:	89 c3                	mov    %eax,%ebx
 12d:	56                   	push   %esi
 12e:	50                   	push   %eax
 12f:	e8 b7 04 00 00       	call   5eb <fstat>
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	0f 88 c1 01 00 00    	js     300 <ls+0x200>
  switch(st.type){
 13f:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 146:	66 83 f8 01          	cmp    $0x1,%ax
 14a:	74 64                	je     1b0 <ls+0xb0>
 14c:	66 83 f8 02          	cmp    $0x2,%ax
 150:	74 1e                	je     170 <ls+0x70>
  close(fd);
 152:	83 ec 0c             	sub    $0xc,%esp
 155:	53                   	push   %ebx
 156:	e8 60 04 00 00       	call   5bb <close>
 15b:	83 c4 10             	add    $0x10,%esp
}
 15e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 161:	5b                   	pop    %ebx
 162:	5e                   	pop    %esi
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    
 166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16d:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 170:	83 ec 0c             	sub    $0xc,%esp
 173:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 179:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 17f:	57                   	push   %edi
 180:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 186:	e8 d5 fe ff ff       	call   60 <fmtname>
 18b:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 191:	59                   	pop    %ecx
 192:	5f                   	pop    %edi
 193:	52                   	push   %edx
 194:	56                   	push   %esi
 195:	6a 02                	push   $0x2
 197:	50                   	push   %eax
 198:	68 30 0e 00 00       	push   $0xe30
 19d:	6a 01                	push   $0x1
 19f:	e8 6c 05 00 00       	call   710 <printf>
    break;
 1a4:	83 c4 20             	add    $0x20,%esp
 1a7:	eb a9                	jmp    152 <ls+0x52>
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1b0:	83 ec 0c             	sub    $0xc,%esp
 1b3:	57                   	push   %edi
 1b4:	e8 17 02 00 00       	call   3d0 <strlen>
 1b9:	83 c4 10             	add    $0x10,%esp
 1bc:	83 c0 10             	add    $0x10,%eax
 1bf:	3d 00 02 00 00       	cmp    $0x200,%eax
 1c4:	0f 87 16 01 00 00    	ja     2e0 <ls+0x1e0>
    strcpy(buf, path);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	57                   	push   %edi
 1ce:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 1d4:	57                   	push   %edi
 1d5:	e8 66 01 00 00       	call   340 <strcpy>
    p = buf+strlen(buf);
 1da:	89 3c 24             	mov    %edi,(%esp)
 1dd:	e8 ee 01 00 00       	call   3d0 <strlen>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e2:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1e5:	01 f8                	add    %edi,%eax
    *p++ = '/';
 1e7:	8d 48 01             	lea    0x1(%eax),%ecx
    p = buf+strlen(buf);
 1ea:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    *p++ = '/';
 1f0:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 1f6:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 200:	83 ec 04             	sub    $0x4,%esp
 203:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 209:	6a 10                	push   $0x10
 20b:	50                   	push   %eax
 20c:	53                   	push   %ebx
 20d:	e8 99 03 00 00       	call   5ab <read>
 212:	83 c4 10             	add    $0x10,%esp
 215:	83 f8 10             	cmp    $0x10,%eax
 218:	0f 85 34 ff ff ff    	jne    152 <ls+0x52>
      if(de.inum == 0)
 21e:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 225:	00 
 226:	74 d8                	je     200 <ls+0x100>
      memmove(p, de.name, DIRSIZ);
 228:	83 ec 04             	sub    $0x4,%esp
 22b:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 231:	6a 0e                	push   $0xe
 233:	50                   	push   %eax
 234:	ff b5 a4 fd ff ff    	push   -0x25c(%ebp)
 23a:	e8 21 03 00 00       	call   560 <memmove>
      p[DIRSIZ] = 0;
 23f:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 245:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 249:	58                   	pop    %eax
 24a:	5a                   	pop    %edx
 24b:	56                   	push   %esi
 24c:	57                   	push   %edi
 24d:	e8 7e 02 00 00       	call   4d0 <stat>
 252:	83 c4 10             	add    $0x10,%esp
 255:	85 c0                	test   %eax,%eax
 257:	0f 88 cb 00 00 00    	js     328 <ls+0x228>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 25d:	83 ec 0c             	sub    $0xc,%esp
 260:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 266:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 26c:	57                   	push   %edi
 26d:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 274:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 27a:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 280:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 286:	e8 d5 fd ff ff       	call   60 <fmtname>
 28b:	5a                   	pop    %edx
 28c:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 292:	59                   	pop    %ecx
 293:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 299:	51                   	push   %ecx
 29a:	52                   	push   %edx
 29b:	ff b5 b4 fd ff ff    	push   -0x24c(%ebp)
 2a1:	50                   	push   %eax
 2a2:	68 30 0e 00 00       	push   $0xe30
 2a7:	6a 01                	push   $0x1
 2a9:	e8 62 04 00 00       	call   710 <printf>
 2ae:	83 c4 20             	add    $0x20,%esp
 2b1:	e9 4a ff ff ff       	jmp    200 <ls+0x100>
 2b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "ls: cannot open %s\n", path);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	57                   	push   %edi
 2c4:	68 08 0e 00 00       	push   $0xe08
 2c9:	6a 02                	push   $0x2
 2cb:	e8 40 04 00 00       	call   710 <printf>
    return;
 2d0:	83 c4 10             	add    $0x10,%esp
}
 2d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    
 2db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2df:	90                   	nop
      printf(1, "ls: path too long\n");
 2e0:	83 ec 08             	sub    $0x8,%esp
 2e3:	68 3d 0e 00 00       	push   $0xe3d
 2e8:	6a 01                	push   $0x1
 2ea:	e8 21 04 00 00       	call   710 <printf>
      break;
 2ef:	83 c4 10             	add    $0x10,%esp
 2f2:	e9 5b fe ff ff       	jmp    152 <ls+0x52>
 2f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fe:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot stat %s\n", path);
 300:	83 ec 04             	sub    $0x4,%esp
 303:	57                   	push   %edi
 304:	68 1c 0e 00 00       	push   $0xe1c
 309:	6a 02                	push   $0x2
 30b:	e8 00 04 00 00       	call   710 <printf>
    close(fd);
 310:	89 1c 24             	mov    %ebx,(%esp)
 313:	e8 a3 02 00 00       	call   5bb <close>
    return;
 318:	83 c4 10             	add    $0x10,%esp
}
 31b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31e:	5b                   	pop    %ebx
 31f:	5e                   	pop    %esi
 320:	5f                   	pop    %edi
 321:	5d                   	pop    %ebp
 322:	c3                   	ret    
 323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 327:	90                   	nop
        printf(1, "ls: cannot stat %s\n", buf);
 328:	83 ec 04             	sub    $0x4,%esp
 32b:	57                   	push   %edi
 32c:	68 1c 0e 00 00       	push   $0xe1c
 331:	6a 01                	push   $0x1
 333:	e8 d8 03 00 00       	call   710 <printf>
        continue;
 338:	83 c4 10             	add    $0x10,%esp
 33b:	e9 c0 fe ff ff       	jmp    200 <ls+0x100>

00000340 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 340:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 341:	31 c0                	xor    %eax,%eax
{
 343:	89 e5                	mov    %esp,%ebp
 345:	53                   	push   %ebx
 346:	8b 4d 08             	mov    0x8(%ebp),%ecx
 349:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 350:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 354:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 357:	83 c0 01             	add    $0x1,%eax
 35a:	84 d2                	test   %dl,%dl
 35c:	75 f2                	jne    350 <strcpy+0x10>
    ;
  return os;
}
 35e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 361:	89 c8                	mov    %ecx,%eax
 363:	c9                   	leave  
 364:	c3                   	ret    
 365:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000370 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 55 08             	mov    0x8(%ebp),%edx
 377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 37a:	0f b6 02             	movzbl (%edx),%eax
 37d:	84 c0                	test   %al,%al
 37f:	75 17                	jne    398 <strcmp+0x28>
 381:	eb 3a                	jmp    3bd <strcmp+0x4d>
 383:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 387:	90                   	nop
 388:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 38c:	83 c2 01             	add    $0x1,%edx
 38f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 392:	84 c0                	test   %al,%al
 394:	74 1a                	je     3b0 <strcmp+0x40>
    p++, q++;
 396:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 398:	0f b6 19             	movzbl (%ecx),%ebx
 39b:	38 c3                	cmp    %al,%bl
 39d:	74 e9                	je     388 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 39f:	29 d8                	sub    %ebx,%eax
}
 3a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3a4:	c9                   	leave  
 3a5:	c3                   	ret    
 3a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 3b0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 3b4:	31 c0                	xor    %eax,%eax
 3b6:	29 d8                	sub    %ebx,%eax
}
 3b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3bb:	c9                   	leave  
 3bc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 3bd:	0f b6 19             	movzbl (%ecx),%ebx
 3c0:	31 c0                	xor    %eax,%eax
 3c2:	eb db                	jmp    39f <strcmp+0x2f>
 3c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3cf:	90                   	nop

000003d0 <strlen>:

uint
strlen(const char *s)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3d6:	80 3a 00             	cmpb   $0x0,(%edx)
 3d9:	74 15                	je     3f0 <strlen+0x20>
 3db:	31 c0                	xor    %eax,%eax
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
 3e0:	83 c0 01             	add    $0x1,%eax
 3e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3e7:	89 c1                	mov    %eax,%ecx
 3e9:	75 f5                	jne    3e0 <strlen+0x10>
    ;
  return n;
}
 3eb:	89 c8                	mov    %ecx,%eax
 3ed:	5d                   	pop    %ebp
 3ee:	c3                   	ret    
 3ef:	90                   	nop
  for(n = 0; s[n]; n++)
 3f0:	31 c9                	xor    %ecx,%ecx
}
 3f2:	5d                   	pop    %ebp
 3f3:	89 c8                	mov    %ecx,%eax
 3f5:	c3                   	ret    
 3f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 407:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	89 d7                	mov    %edx,%edi
 40f:	fc                   	cld    
 410:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 412:	8b 7d fc             	mov    -0x4(%ebp),%edi
 415:	89 d0                	mov    %edx,%eax
 417:	c9                   	leave  
 418:	c3                   	ret    
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 42a:	0f b6 10             	movzbl (%eax),%edx
 42d:	84 d2                	test   %dl,%dl
 42f:	75 12                	jne    443 <strchr+0x23>
 431:	eb 1d                	jmp    450 <strchr+0x30>
 433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 437:	90                   	nop
 438:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 43c:	83 c0 01             	add    $0x1,%eax
 43f:	84 d2                	test   %dl,%dl
 441:	74 0d                	je     450 <strchr+0x30>
    if(*s == c)
 443:	38 d1                	cmp    %dl,%cl
 445:	75 f1                	jne    438 <strchr+0x18>
      return (char*)s;
  return 0;
}
 447:	5d                   	pop    %ebp
 448:	c3                   	ret    
 449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 450:	31 c0                	xor    %eax,%eax
}
 452:	5d                   	pop    %ebp
 453:	c3                   	ret    
 454:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 45f:	90                   	nop

00000460 <gets>:

char*
gets(char *buf, int max)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 465:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 468:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 469:	31 db                	xor    %ebx,%ebx
{
 46b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 46e:	eb 27                	jmp    497 <gets+0x37>
    cc = read(0, &c, 1);
 470:	83 ec 04             	sub    $0x4,%esp
 473:	6a 01                	push   $0x1
 475:	57                   	push   %edi
 476:	6a 00                	push   $0x0
 478:	e8 2e 01 00 00       	call   5ab <read>
    if(cc < 1)
 47d:	83 c4 10             	add    $0x10,%esp
 480:	85 c0                	test   %eax,%eax
 482:	7e 1d                	jle    4a1 <gets+0x41>
      break;
    buf[i++] = c;
 484:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 488:	8b 55 08             	mov    0x8(%ebp),%edx
 48b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 48f:	3c 0a                	cmp    $0xa,%al
 491:	74 1d                	je     4b0 <gets+0x50>
 493:	3c 0d                	cmp    $0xd,%al
 495:	74 19                	je     4b0 <gets+0x50>
  for(i=0; i+1 < max; ){
 497:	89 de                	mov    %ebx,%esi
 499:	83 c3 01             	add    $0x1,%ebx
 49c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 49f:	7c cf                	jl     470 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ab:	5b                   	pop    %ebx
 4ac:	5e                   	pop    %esi
 4ad:	5f                   	pop    %edi
 4ae:	5d                   	pop    %ebp
 4af:	c3                   	ret    
  buf[i] = '\0';
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	89 de                	mov    %ebx,%esi
 4b5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 4b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bc:	5b                   	pop    %ebx
 4bd:	5e                   	pop    %esi
 4be:	5f                   	pop    %edi
 4bf:	5d                   	pop    %ebp
 4c0:	c3                   	ret    
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cf:	90                   	nop

000004d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	56                   	push   %esi
 4d4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d5:	83 ec 08             	sub    $0x8,%esp
 4d8:	6a 00                	push   $0x0
 4da:	ff 75 08             	push   0x8(%ebp)
 4dd:	e8 f1 00 00 00       	call   5d3 <open>
  if(fd < 0)
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	85 c0                	test   %eax,%eax
 4e7:	78 27                	js     510 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4e9:	83 ec 08             	sub    $0x8,%esp
 4ec:	ff 75 0c             	push   0xc(%ebp)
 4ef:	89 c3                	mov    %eax,%ebx
 4f1:	50                   	push   %eax
 4f2:	e8 f4 00 00 00       	call   5eb <fstat>
  close(fd);
 4f7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4fa:	89 c6                	mov    %eax,%esi
  close(fd);
 4fc:	e8 ba 00 00 00       	call   5bb <close>
  return r;
 501:	83 c4 10             	add    $0x10,%esp
}
 504:	8d 65 f8             	lea    -0x8(%ebp),%esp
 507:	89 f0                	mov    %esi,%eax
 509:	5b                   	pop    %ebx
 50a:	5e                   	pop    %esi
 50b:	5d                   	pop    %ebp
 50c:	c3                   	ret    
 50d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 510:	be ff ff ff ff       	mov    $0xffffffff,%esi
 515:	eb ed                	jmp    504 <stat+0x34>
 517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51e:	66 90                	xchg   %ax,%ax

00000520 <atoi>:

int
atoi(const char *s)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	53                   	push   %ebx
 524:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 527:	0f be 02             	movsbl (%edx),%eax
 52a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 52d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 530:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 535:	77 1e                	ja     555 <atoi+0x35>
 537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 540:	83 c2 01             	add    $0x1,%edx
 543:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 546:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 54a:	0f be 02             	movsbl (%edx),%eax
 54d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 550:	80 fb 09             	cmp    $0x9,%bl
 553:	76 eb                	jbe    540 <atoi+0x20>
  return n;
}
 555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 558:	89 c8                	mov    %ecx,%eax
 55a:	c9                   	leave  
 55b:	c3                   	ret    
 55c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000560 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	8b 45 10             	mov    0x10(%ebp),%eax
 567:	8b 55 08             	mov    0x8(%ebp),%edx
 56a:	56                   	push   %esi
 56b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 56e:	85 c0                	test   %eax,%eax
 570:	7e 13                	jle    585 <memmove+0x25>
 572:	01 d0                	add    %edx,%eax
  dst = vdst;
 574:	89 d7                	mov    %edx,%edi
 576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 57d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 580:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 581:	39 f8                	cmp    %edi,%eax
 583:	75 fb                	jne    580 <memmove+0x20>
  return vdst;
}
 585:	5e                   	pop    %esi
 586:	89 d0                	mov    %edx,%eax
 588:	5f                   	pop    %edi
 589:	5d                   	pop    %ebp
 58a:	c3                   	ret    

0000058b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 58b:	b8 01 00 00 00       	mov    $0x1,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <exit>:
SYSCALL(exit)
 593:	b8 02 00 00 00       	mov    $0x2,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <wait>:
SYSCALL(wait)
 59b:	b8 03 00 00 00       	mov    $0x3,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <pipe>:
SYSCALL(pipe)
 5a3:	b8 04 00 00 00       	mov    $0x4,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <read>:
SYSCALL(read)
 5ab:	b8 05 00 00 00       	mov    $0x5,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <write>:
SYSCALL(write)
 5b3:	b8 10 00 00 00       	mov    $0x10,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <close>:
SYSCALL(close)
 5bb:	b8 15 00 00 00       	mov    $0x15,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <kill>:
SYSCALL(kill)
 5c3:	b8 06 00 00 00       	mov    $0x6,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <exec>:
SYSCALL(exec)
 5cb:	b8 07 00 00 00       	mov    $0x7,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <open>:
SYSCALL(open)
 5d3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <mknod>:
SYSCALL(mknod)
 5db:	b8 11 00 00 00       	mov    $0x11,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <unlink>:
SYSCALL(unlink)
 5e3:	b8 12 00 00 00       	mov    $0x12,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <fstat>:
SYSCALL(fstat)
 5eb:	b8 08 00 00 00       	mov    $0x8,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <link>:
SYSCALL(link)
 5f3:	b8 13 00 00 00       	mov    $0x13,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <mkdir>:
SYSCALL(mkdir)
 5fb:	b8 14 00 00 00       	mov    $0x14,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <chdir>:
SYSCALL(chdir)
 603:	b8 09 00 00 00       	mov    $0x9,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <dup>:
SYSCALL(dup)
 60b:	b8 0a 00 00 00       	mov    $0xa,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <getpid>:
SYSCALL(getpid)
 613:	b8 0b 00 00 00       	mov    $0xb,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <sbrk>:
SYSCALL(sbrk)
 61b:	b8 0c 00 00 00       	mov    $0xc,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <sleep>:
SYSCALL(sleep)
 623:	b8 0d 00 00 00       	mov    $0xd,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <uptime>:
SYSCALL(uptime)
 62b:	b8 0e 00 00 00       	mov    $0xe,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <wmap>:
SYSCALL(wmap)
 633:	b8 16 00 00 00       	mov    $0x16,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <wunmap>:
SYSCALL(wunmap)
 63b:	b8 17 00 00 00       	mov    $0x17,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <wpunmap>:
SYSCALL(wpunmap)
 643:	b8 18 00 00 00       	mov    $0x18,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <getwmapinfo>:
SYSCALL(getwmapinfo)
 64b:	b8 19 00 00 00       	mov    $0x19,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <getpgdirinfo>:
SYSCALL(getpgdirinfo)
 653:	b8 1a 00 00 00       	mov    $0x1a,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    
 65b:	66 90                	xchg   %ax,%ax
 65d:	66 90                	xchg   %ax,%ax
 65f:	90                   	nop

00000660 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 3c             	sub    $0x3c,%esp
 669:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 66c:	89 d1                	mov    %edx,%ecx
{
 66e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 671:	85 d2                	test   %edx,%edx
 673:	0f 89 7f 00 00 00    	jns    6f8 <printint+0x98>
 679:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 67d:	74 79                	je     6f8 <printint+0x98>
    neg = 1;
 67f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 686:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 688:	31 db                	xor    %ebx,%ebx
 68a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 68d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 690:	89 c8                	mov    %ecx,%eax
 692:	31 d2                	xor    %edx,%edx
 694:	89 cf                	mov    %ecx,%edi
 696:	f7 75 c4             	divl   -0x3c(%ebp)
 699:	0f b6 92 b4 0e 00 00 	movzbl 0xeb4(%edx),%edx
 6a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 6a3:	89 d8                	mov    %ebx,%eax
 6a5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 6a8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 6ab:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 6ae:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 6b1:	76 dd                	jbe    690 <printint+0x30>
  if(neg)
 6b3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 6b6:	85 c9                	test   %ecx,%ecx
 6b8:	74 0c                	je     6c6 <printint+0x66>
    buf[i++] = '-';
 6ba:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 6bf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 6c1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 6c6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 6c9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 6cd:	eb 07                	jmp    6d6 <printint+0x76>
 6cf:	90                   	nop
    putc(fd, buf[i]);
 6d0:	0f b6 13             	movzbl (%ebx),%edx
 6d3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 6d6:	83 ec 04             	sub    $0x4,%esp
 6d9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 6dc:	6a 01                	push   $0x1
 6de:	56                   	push   %esi
 6df:	57                   	push   %edi
 6e0:	e8 ce fe ff ff       	call   5b3 <write>
  while(--i >= 0)
 6e5:	83 c4 10             	add    $0x10,%esp
 6e8:	39 de                	cmp    %ebx,%esi
 6ea:	75 e4                	jne    6d0 <printint+0x70>
}
 6ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ef:	5b                   	pop    %ebx
 6f0:	5e                   	pop    %esi
 6f1:	5f                   	pop    %edi
 6f2:	5d                   	pop    %ebp
 6f3:	c3                   	ret    
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6f8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 6ff:	eb 87                	jmp    688 <printint+0x28>
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70f:	90                   	nop

00000710 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 719:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 71c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 71f:	0f b6 13             	movzbl (%ebx),%edx
 722:	84 d2                	test   %dl,%dl
 724:	74 6a                	je     790 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 726:	8d 45 10             	lea    0x10(%ebp),%eax
 729:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 72c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 72f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 731:	89 45 d0             	mov    %eax,-0x30(%ebp)
 734:	eb 36                	jmp    76c <printf+0x5c>
 736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 73d:	8d 76 00             	lea    0x0(%esi),%esi
 740:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 743:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 748:	83 f8 25             	cmp    $0x25,%eax
 74b:	74 15                	je     762 <printf+0x52>
  write(fd, &c, 1);
 74d:	83 ec 04             	sub    $0x4,%esp
 750:	88 55 e7             	mov    %dl,-0x19(%ebp)
 753:	6a 01                	push   $0x1
 755:	57                   	push   %edi
 756:	56                   	push   %esi
 757:	e8 57 fe ff ff       	call   5b3 <write>
 75c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 75f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 762:	0f b6 13             	movzbl (%ebx),%edx
 765:	83 c3 01             	add    $0x1,%ebx
 768:	84 d2                	test   %dl,%dl
 76a:	74 24                	je     790 <printf+0x80>
    c = fmt[i] & 0xff;
 76c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 76f:	85 c9                	test   %ecx,%ecx
 771:	74 cd                	je     740 <printf+0x30>
      }
    } else if(state == '%'){
 773:	83 f9 25             	cmp    $0x25,%ecx
 776:	75 ea                	jne    762 <printf+0x52>
      if(c == 'd'){
 778:	83 f8 25             	cmp    $0x25,%eax
 77b:	0f 84 07 01 00 00    	je     888 <printf+0x178>
 781:	83 e8 63             	sub    $0x63,%eax
 784:	83 f8 15             	cmp    $0x15,%eax
 787:	77 17                	ja     7a0 <printf+0x90>
 789:	ff 24 85 5c 0e 00 00 	jmp    *0xe5c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 790:	8d 65 f4             	lea    -0xc(%ebp),%esp
 793:	5b                   	pop    %ebx
 794:	5e                   	pop    %esi
 795:	5f                   	pop    %edi
 796:	5d                   	pop    %ebp
 797:	c3                   	ret    
 798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 79f:	90                   	nop
  write(fd, &c, 1);
 7a0:	83 ec 04             	sub    $0x4,%esp
 7a3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 7a6:	6a 01                	push   $0x1
 7a8:	57                   	push   %edi
 7a9:	56                   	push   %esi
 7aa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7ae:	e8 00 fe ff ff       	call   5b3 <write>
        putc(fd, c);
 7b3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 7b7:	83 c4 0c             	add    $0xc,%esp
 7ba:	88 55 e7             	mov    %dl,-0x19(%ebp)
 7bd:	6a 01                	push   $0x1
 7bf:	57                   	push   %edi
 7c0:	56                   	push   %esi
 7c1:	e8 ed fd ff ff       	call   5b3 <write>
        putc(fd, c);
 7c6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7c9:	31 c9                	xor    %ecx,%ecx
 7cb:	eb 95                	jmp    762 <printf+0x52>
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 7d0:	83 ec 0c             	sub    $0xc,%esp
 7d3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7d8:	6a 00                	push   $0x0
 7da:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7dd:	8b 10                	mov    (%eax),%edx
 7df:	89 f0                	mov    %esi,%eax
 7e1:	e8 7a fe ff ff       	call   660 <printint>
        ap++;
 7e6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 7ea:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7ed:	31 c9                	xor    %ecx,%ecx
 7ef:	e9 6e ff ff ff       	jmp    762 <printf+0x52>
 7f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 7f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7fb:	8b 10                	mov    (%eax),%edx
        ap++;
 7fd:	83 c0 04             	add    $0x4,%eax
 800:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 803:	85 d2                	test   %edx,%edx
 805:	0f 84 8d 00 00 00    	je     898 <printf+0x188>
        while(*s != 0){
 80b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 80e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 810:	84 c0                	test   %al,%al
 812:	0f 84 4a ff ff ff    	je     762 <printf+0x52>
 818:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 81b:	89 d3                	mov    %edx,%ebx
 81d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 820:	83 ec 04             	sub    $0x4,%esp
          s++;
 823:	83 c3 01             	add    $0x1,%ebx
 826:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 829:	6a 01                	push   $0x1
 82b:	57                   	push   %edi
 82c:	56                   	push   %esi
 82d:	e8 81 fd ff ff       	call   5b3 <write>
        while(*s != 0){
 832:	0f b6 03             	movzbl (%ebx),%eax
 835:	83 c4 10             	add    $0x10,%esp
 838:	84 c0                	test   %al,%al
 83a:	75 e4                	jne    820 <printf+0x110>
      state = 0;
 83c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 83f:	31 c9                	xor    %ecx,%ecx
 841:	e9 1c ff ff ff       	jmp    762 <printf+0x52>
 846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 84d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 850:	83 ec 0c             	sub    $0xc,%esp
 853:	b9 0a 00 00 00       	mov    $0xa,%ecx
 858:	6a 01                	push   $0x1
 85a:	e9 7b ff ff ff       	jmp    7da <printf+0xca>
 85f:	90                   	nop
        putc(fd, *ap);
 860:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 863:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 866:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 868:	6a 01                	push   $0x1
 86a:	57                   	push   %edi
 86b:	56                   	push   %esi
        putc(fd, *ap);
 86c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 86f:	e8 3f fd ff ff       	call   5b3 <write>
        ap++;
 874:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 878:	83 c4 10             	add    $0x10,%esp
      state = 0;
 87b:	31 c9                	xor    %ecx,%ecx
 87d:	e9 e0 fe ff ff       	jmp    762 <printf+0x52>
 882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 888:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 88b:	83 ec 04             	sub    $0x4,%esp
 88e:	e9 2a ff ff ff       	jmp    7bd <printf+0xad>
 893:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 897:	90                   	nop
          s = "(null)";
 898:	ba 52 0e 00 00       	mov    $0xe52,%edx
        while(*s != 0){
 89d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 8a0:	b8 28 00 00 00       	mov    $0x28,%eax
 8a5:	89 d3                	mov    %edx,%ebx
 8a7:	e9 74 ff ff ff       	jmp    820 <printf+0x110>
 8ac:	66 90                	xchg   %ax,%ax
 8ae:	66 90                	xchg   %ax,%ax

000008b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b1:	a1 2c 15 00 00       	mov    0x152c,%eax
{
 8b6:	89 e5                	mov    %esp,%ebp
 8b8:	57                   	push   %edi
 8b9:	56                   	push   %esi
 8ba:	53                   	push   %ebx
 8bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 8be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8c8:	89 c2                	mov    %eax,%edx
 8ca:	8b 00                	mov    (%eax),%eax
 8cc:	39 ca                	cmp    %ecx,%edx
 8ce:	73 30                	jae    900 <free+0x50>
 8d0:	39 c1                	cmp    %eax,%ecx
 8d2:	72 04                	jb     8d8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	39 c2                	cmp    %eax,%edx
 8d6:	72 f0                	jb     8c8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8de:	39 f8                	cmp    %edi,%eax
 8e0:	74 30                	je     912 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8e2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8e5:	8b 42 04             	mov    0x4(%edx),%eax
 8e8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 8eb:	39 f1                	cmp    %esi,%ecx
 8ed:	74 3a                	je     929 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8ef:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 8f1:	5b                   	pop    %ebx
  freep = p;
 8f2:	89 15 2c 15 00 00    	mov    %edx,0x152c
}
 8f8:	5e                   	pop    %esi
 8f9:	5f                   	pop    %edi
 8fa:	5d                   	pop    %ebp
 8fb:	c3                   	ret    
 8fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 900:	39 c2                	cmp    %eax,%edx
 902:	72 c4                	jb     8c8 <free+0x18>
 904:	39 c1                	cmp    %eax,%ecx
 906:	73 c0                	jae    8c8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 908:	8b 73 fc             	mov    -0x4(%ebx),%esi
 90b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 90e:	39 f8                	cmp    %edi,%eax
 910:	75 d0                	jne    8e2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 912:	03 70 04             	add    0x4(%eax),%esi
 915:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 918:	8b 02                	mov    (%edx),%eax
 91a:	8b 00                	mov    (%eax),%eax
 91c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 91f:	8b 42 04             	mov    0x4(%edx),%eax
 922:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 925:	39 f1                	cmp    %esi,%ecx
 927:	75 c6                	jne    8ef <free+0x3f>
    p->s.size += bp->s.size;
 929:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 92c:	89 15 2c 15 00 00    	mov    %edx,0x152c
    p->s.size += bp->s.size;
 932:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 935:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 938:	89 0a                	mov    %ecx,(%edx)
}
 93a:	5b                   	pop    %ebx
 93b:	5e                   	pop    %esi
 93c:	5f                   	pop    %edi
 93d:	5d                   	pop    %ebp
 93e:	c3                   	ret    
 93f:	90                   	nop

00000940 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	57                   	push   %edi
 944:	56                   	push   %esi
 945:	53                   	push   %ebx
 946:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 949:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 94c:	8b 3d 2c 15 00 00    	mov    0x152c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 952:	8d 70 07             	lea    0x7(%eax),%esi
 955:	c1 ee 03             	shr    $0x3,%esi
 958:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 95b:	85 ff                	test   %edi,%edi
 95d:	0f 84 9d 00 00 00    	je     a00 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 963:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 965:	8b 4a 04             	mov    0x4(%edx),%ecx
 968:	39 f1                	cmp    %esi,%ecx
 96a:	73 6a                	jae    9d6 <malloc+0x96>
 96c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 971:	39 de                	cmp    %ebx,%esi
 973:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 976:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 97d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 980:	eb 17                	jmp    999 <malloc+0x59>
 982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 988:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 98a:	8b 48 04             	mov    0x4(%eax),%ecx
 98d:	39 f1                	cmp    %esi,%ecx
 98f:	73 4f                	jae    9e0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 991:	8b 3d 2c 15 00 00    	mov    0x152c,%edi
 997:	89 c2                	mov    %eax,%edx
 999:	39 d7                	cmp    %edx,%edi
 99b:	75 eb                	jne    988 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 99d:	83 ec 0c             	sub    $0xc,%esp
 9a0:	ff 75 e4             	push   -0x1c(%ebp)
 9a3:	e8 73 fc ff ff       	call   61b <sbrk>
  if(p == (char*)-1)
 9a8:	83 c4 10             	add    $0x10,%esp
 9ab:	83 f8 ff             	cmp    $0xffffffff,%eax
 9ae:	74 1c                	je     9cc <malloc+0x8c>
  hp->s.size = nu;
 9b0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9b3:	83 ec 0c             	sub    $0xc,%esp
 9b6:	83 c0 08             	add    $0x8,%eax
 9b9:	50                   	push   %eax
 9ba:	e8 f1 fe ff ff       	call   8b0 <free>
  return freep;
 9bf:	8b 15 2c 15 00 00    	mov    0x152c,%edx
      if((p = morecore(nunits)) == 0)
 9c5:	83 c4 10             	add    $0x10,%esp
 9c8:	85 d2                	test   %edx,%edx
 9ca:	75 bc                	jne    988 <malloc+0x48>
        return 0;
  }
}
 9cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9cf:	31 c0                	xor    %eax,%eax
}
 9d1:	5b                   	pop    %ebx
 9d2:	5e                   	pop    %esi
 9d3:	5f                   	pop    %edi
 9d4:	5d                   	pop    %ebp
 9d5:	c3                   	ret    
    if(p->s.size >= nunits){
 9d6:	89 d0                	mov    %edx,%eax
 9d8:	89 fa                	mov    %edi,%edx
 9da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9e0:	39 ce                	cmp    %ecx,%esi
 9e2:	74 4c                	je     a30 <malloc+0xf0>
        p->s.size -= nunits;
 9e4:	29 f1                	sub    %esi,%ecx
 9e6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9e9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9ec:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 9ef:	89 15 2c 15 00 00    	mov    %edx,0x152c
}
 9f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9f8:	83 c0 08             	add    $0x8,%eax
}
 9fb:	5b                   	pop    %ebx
 9fc:	5e                   	pop    %esi
 9fd:	5f                   	pop    %edi
 9fe:	5d                   	pop    %ebp
 9ff:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 a00:	c7 05 2c 15 00 00 30 	movl   $0x1530,0x152c
 a07:	15 00 00 
    base.s.size = 0;
 a0a:	bf 30 15 00 00       	mov    $0x1530,%edi
    base.s.ptr = freep = prevp = &base;
 a0f:	c7 05 30 15 00 00 30 	movl   $0x1530,0x1530
 a16:	15 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a19:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 a1b:	c7 05 34 15 00 00 00 	movl   $0x0,0x1534
 a22:	00 00 00 
    if(p->s.size >= nunits){
 a25:	e9 42 ff ff ff       	jmp    96c <malloc+0x2c>
 a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a30:	8b 08                	mov    (%eax),%ecx
 a32:	89 0a                	mov    %ecx,(%edx)
 a34:	eb b9                	jmp    9ef <malloc+0xaf>
 a36:	66 90                	xchg   %ax,%ax
 a38:	66 90                	xchg   %ax,%ax
 a3a:	66 90                	xchg   %ax,%ax
 a3c:	66 90                	xchg   %ax,%ax
 a3e:	66 90                	xchg   %ax,%ax

00000a40 <finish>:
#include "wmaptest.h"

// TEST HELPER
void finish() {
 a40:	55                   	push   %ebp
 a41:	89 e5                	mov    %esp,%ebp
 a43:	83 ec 10             	sub    $0x10,%esp
    printf(1, "XV6: Test finished.\n");
 a46:	68 c5 0e 00 00       	push   $0xec5
 a4b:	6a 01                	push   $0x1
 a4d:	e8 be fc ff ff       	call   710 <printf>
    exit();
 a52:	e8 3c fb ff ff       	call   593 <exit>
 a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a5e:	66 90                	xchg   %ax,%ax

00000a60 <failed>:
}

void failed() {
 a60:	55                   	push   %ebp
 a61:	89 e5                	mov    %esp,%ebp
 a63:	83 ec 10             	sub    $0x10,%esp
    printf(1, "XV6: Test failed.\n");
 a66:	68 da 0e 00 00       	push   $0xeda
 a6b:	6a 01                	push   $0x1
 a6d:	e8 9e fc ff ff       	call   710 <printf>
    exit();
 a72:	e8 1c fb ff ff       	call   593 <exit>
 a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a7e:	66 90                	xchg   %ax,%ax

00000a80 <print_mmap_info>:
}

/**
 * @brief Prints details of a wmapinfo struct.
 */
void print_mmap_info(struct wmapinfo *info) {
 a80:	55                   	push   %ebp
 a81:	89 e5                	mov    %esp,%ebp
 a83:	56                   	push   %esi
 a84:	53                   	push   %ebx
 a85:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "XV6: ------ Total mmaps: %d\n", info->total_mmaps);
 a88:	83 ec 04             	sub    $0x4,%esp
 a8b:	ff 36                	push   (%esi)
 a8d:	68 ed 0e 00 00       	push   $0xeed
 a92:	6a 01                	push   $0x1
 a94:	e8 77 fc ff ff       	call   710 <printf>
    for (int i = 0; i < info->total_mmaps; i++) {
 a99:	8b 06                	mov    (%esi),%eax
 a9b:	83 c4 10             	add    $0x10,%esp
 a9e:	85 c0                	test   %eax,%eax
 aa0:	7e 4a                	jle    aec <print_mmap_info+0x6c>
 aa2:	31 db                	xor    %ebx,%ebx
 aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
            i, info->addr[i], info->length[i], info->addr[i] + info->length[i], info->flags[i], info->fd[i], info->refcnt[i], info->n_loaded_pages[i]);
 aa8:	8b 44 9e 04          	mov    0x4(%esi,%ebx,4),%eax
 aac:	8b 54 9e 44          	mov    0x44(%esi,%ebx,4),%edx
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
 ab0:	83 ec 08             	sub    $0x8,%esp
 ab3:	ff b4 9e 44 01 00 00 	push   0x144(%esi,%ebx,4)
 aba:	ff b4 9e 04 01 00 00 	push   0x104(%esi,%ebx,4)
 ac1:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
 ac4:	ff b4 9e c4 00 00 00 	push   0xc4(%esi,%ebx,4)
 acb:	ff b4 9e 84 00 00 00 	push   0x84(%esi,%ebx,4)
 ad2:	51                   	push   %ecx
 ad3:	52                   	push   %edx
 ad4:	50                   	push   %eax
 ad5:	53                   	push   %ebx
    for (int i = 0; i < info->total_mmaps; i++) {
 ad6:	83 c3 01             	add    $0x1,%ebx
        printf(1, "XV6: ------ mmap[%d]: va [0x%x] sz [%d] vend [0x%x] flags [0x%x] fd [%d] rc[%d] ld_pg [%d] \n",
 ad9:	68 30 0f 00 00       	push   $0xf30
 ade:	6a 01                	push   $0x1
 ae0:	e8 2b fc ff ff       	call   710 <printf>
    for (int i = 0; i < info->total_mmaps; i++) {
 ae5:	83 c4 30             	add    $0x30,%esp
 ae8:	39 1e                	cmp    %ebx,(%esi)
 aea:	7f bc                	jg     aa8 <print_mmap_info+0x28>
    }
}
 aec:	8d 65 f8             	lea    -0x8(%ebp),%esp
 aef:	5b                   	pop    %ebx
 af0:	5e                   	pop    %esi
 af1:	5d                   	pop    %ebp
 af2:	c3                   	ret    
 af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000b00 <test_getwmapinfo>:

void test_getwmapinfo(struct wmapinfo *info) {
 b00:	55                   	push   %ebp
 b01:	89 e5                	mov    %esp,%ebp
 b03:	53                   	push   %ebx
 b04:	83 ec 10             	sub    $0x10,%esp
 b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int ret = getwmapinfo(info);
 b0a:	53                   	push   %ebx
 b0b:	e8 3b fb ff ff       	call   64b <getwmapinfo>
    if (ret < 0) {
 b10:	83 c4 10             	add    $0x10,%esp
 b13:	85 c0                	test   %eax,%eax
 b15:	78 0c                	js     b23 <test_getwmapinfo+0x23>
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
        failed();
    }
    print_mmap_info(info);
 b17:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 b1d:	c9                   	leave  
    print_mmap_info(info);
 b1e:	e9 5d ff ff ff       	jmp    a80 <print_mmap_info>
        printf(1, "XV6: getwmapinfo() returned %d\n", ret);
 b23:	52                   	push   %edx
 b24:	50                   	push   %eax
 b25:	68 90 0f 00 00       	push   $0xf90
 b2a:	6a 01                	push   $0x1
 b2c:	e8 df fb ff ff       	call   710 <printf>
        failed();
 b31:	e8 2a ff ff ff       	call   a60 <failed>
 b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b3d:	8d 76 00             	lea    0x0(%esi),%esi

00000b40 <print_pgdir_info>:

/**
 * @brief Prints details of a pgdirinfo struct.
 */
void print_pgdir_info(struct pgdirinfo *info) {
 b40:	55                   	push   %ebp
 b41:	89 e5                	mov    %esp,%ebp
 b43:	56                   	push   %esi
 b44:	53                   	push   %ebx
 b45:	8b 75 08             	mov    0x8(%ebp),%esi
    printf(1, "XV6: Total n_upages: %d\n", info->n_upages);
 b48:	83 ec 04             	sub    $0x4,%esp
 b4b:	ff 36                	push   (%esi)
 b4d:	68 0a 0f 00 00       	push   $0xf0a
 b52:	6a 01                	push   $0x1
 b54:	e8 b7 fb ff ff       	call   710 <printf>
    for (int i = 0; i < info->n_upages; i++) {
 b59:	8b 06                	mov    (%esi),%eax
 b5b:	83 c4 10             	add    $0x10,%esp
 b5e:	85 c0                	test   %eax,%eax
 b60:	74 2b                	je     b8d <print_pgdir_info+0x4d>
 b62:	31 db                	xor    %ebx,%ebx
 b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
 b68:	83 ec 0c             	sub    $0xc,%esp
 b6b:	ff b4 9e 84 00 00 00 	push   0x84(%esi,%ebx,4)
 b72:	ff 74 9e 04          	push   0x4(%esi,%ebx,4)
 b76:	53                   	push   %ebx
    for (int i = 0; i < info->n_upages; i++) {
 b77:	83 c3 01             	add    $0x1,%ebx
        printf(1, "XV6: n_upages[%d]: va [0x%x] pa [0x%x] \n",
 b7a:	68 b0 0f 00 00       	push   $0xfb0
 b7f:	6a 01                	push   $0x1
 b81:	e8 8a fb ff ff       	call   710 <printf>
    for (int i = 0; i < info->n_upages; i++) {
 b86:	83 c4 20             	add    $0x20,%esp
 b89:	39 1e                	cmp    %ebx,(%esi)
 b8b:	77 db                	ja     b68 <print_pgdir_info+0x28>
            i, info->va[i], info->pa[i]);
    }
}
 b8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 b90:	5b                   	pop    %ebx
 b91:	5e                   	pop    %esi
 b92:	5d                   	pop    %ebp
 b93:	c3                   	ret    
 b94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b9f:	90                   	nop

00000ba0 <test_getpgdirinfo>:

void test_getpgdirinfo(struct pgdirinfo *info) {
 ba0:	55                   	push   %ebp
 ba1:	89 e5                	mov    %esp,%ebp
 ba3:	83 ec 14             	sub    $0x14,%esp
    int ret = getpgdirinfo(info);
 ba6:	ff 75 08             	push   0x8(%ebp)
 ba9:	e8 a5 fa ff ff       	call   653 <getpgdirinfo>
    if (ret < 0) {
 bae:	83 c4 10             	add    $0x10,%esp
 bb1:	85 c0                	test   %eax,%eax
 bb3:	78 02                	js     bb7 <test_getpgdirinfo+0x17>
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
        failed();
    }
    // print_pgdir_info(info);
}
 bb5:	c9                   	leave  
 bb6:	c3                   	ret    
        printf(1, "XV6: getpgdirinfo() returned %d\n", ret);
 bb7:	52                   	push   %edx
 bb8:	50                   	push   %eax
 bb9:	68 dc 0f 00 00       	push   $0xfdc
 bbe:	6a 01                	push   $0x1
 bc0:	e8 4b fb ff ff       	call   710 <printf>
        failed();
 bc5:	e8 96 fe ff ff       	call   a60 <failed>
 bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000bd0 <create_small_file>:

int create_small_file(char *filename) {
 bd0:	55                   	push   %ebp
 bd1:	89 e5                	mov    %esp,%ebp
 bd3:	56                   	push   %esi
 bd4:	53                   	push   %ebx

    // create a file
    int bufflen = 512 + 2;
    char buff[bufflen];
 bd5:	89 e0                	mov    %esp,%eax
 bd7:	39 c4                	cmp    %eax,%esp
 bd9:	74 12                	je     bed <create_small_file+0x1d>
 bdb:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 be1:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 be8:	00 
 be9:	39 c4                	cmp    %eax,%esp
 beb:	75 ee                	jne    bdb <create_small_file+0xb>
 bed:	81 ec 10 02 00 00    	sub    $0x210,%esp
 bf3:	83 8c 24 0c 02 00 00 	orl    $0x0,0x20c(%esp)
 bfa:	00 
 bfb:	89 e3                	mov    %esp,%ebx
    int fd = open(filename, O_CREATE | O_RDWR);
 bfd:	83 ec 08             	sub    $0x8,%esp
 c00:	68 02 02 00 00       	push   $0x202
 c05:	ff 75 08             	push   0x8(%ebp)
 c08:	e8 c6 f9 ff ff       	call   5d3 <open>
    if (fd < 0) {
 c0d:	89 dc                	mov    %ebx,%esp
    int fd = open(filename, O_CREATE | O_RDWR);
 c0f:	89 c6                	mov    %eax,%esi
    if (fd < 0) {
 c11:	85 c0                	test   %eax,%eax
 c13:	78 5a                	js     c6f <create_small_file+0x9f>
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }

    // prepare the content to write
    for (int j = 0; j < bufflen; j++) {
 c15:	31 c0                	xor    %eax,%eax
 c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c1e:	66 90                	xchg   %ax,%ax
        buff[j] = 'a' + (j % 4);
 c20:	89 c2                	mov    %eax,%edx
 c22:	83 e2 03             	and    $0x3,%edx
 c25:	83 c2 61             	add    $0x61,%edx
 c28:	88 14 03             	mov    %dl,(%ebx,%eax,1)
    for (int j = 0; j < bufflen; j++) {
 c2b:	83 c0 01             	add    $0x1,%eax
 c2e:	3d 02 02 00 00       	cmp    $0x202,%eax
 c33:	75 eb                	jne    c20 <create_small_file+0x50>
    }
    buff[bufflen - 1] = '\0';
    buff[bufflen - 2] = '\n';

    // write to file
    if (write(fd, buff, bufflen) != bufflen) {
 c35:	83 ec 04             	sub    $0x4,%esp
    buff[bufflen - 2] = '\n';
 c38:	ba 0a 00 00 00       	mov    $0xa,%edx
 c3d:	66 89 93 00 02 00 00 	mov    %dx,0x200(%ebx)
    if (write(fd, buff, bufflen) != bufflen) {
 c44:	68 02 02 00 00       	push   $0x202
 c49:	53                   	push   %ebx
 c4a:	56                   	push   %esi
 c4b:	e8 63 f9 ff ff       	call   5b3 <write>
 c50:	83 c4 10             	add    $0x10,%esp
 c53:	3d 02 02 00 00       	cmp    $0x202,%eax
 c58:	75 2a                	jne    c84 <create_small_file+0xb4>
        printf(1, "XV6: Error: Write to file FAILED\n");
        failed();
    }

    close(fd);
 c5a:	83 ec 0c             	sub    $0xc,%esp
 c5d:	56                   	push   %esi
 c5e:	e8 58 f9 ff ff       	call   5bb <close>
    return bufflen;
}
 c63:	8d 65 f8             	lea    -0x8(%ebp),%esp
 c66:	b8 02 02 00 00       	mov    $0x202,%eax
 c6b:	5b                   	pop    %ebx
 c6c:	5e                   	pop    %esi
 c6d:	5d                   	pop    %ebp
 c6e:	c3                   	ret    
        printf(1, "XV6: Failed to create file %s\n", filename);
 c6f:	51                   	push   %ecx
 c70:	ff 75 08             	push   0x8(%ebp)
 c73:	68 00 10 00 00       	push   $0x1000
 c78:	6a 01                	push   $0x1
 c7a:	e8 91 fa ff ff       	call   710 <printf>
        failed();
 c7f:	e8 dc fd ff ff       	call   a60 <failed>
        printf(1, "XV6: Error: Write to file FAILED\n");
 c84:	50                   	push   %eax
 c85:	50                   	push   %eax
 c86:	68 20 10 00 00       	push   $0x1020
 c8b:	6a 01                	push   $0x1
 c8d:	e8 7e fa ff ff       	call   710 <printf>
        failed();
 c92:	e8 c9 fd ff ff       	call   a60 <failed>
 c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c9e:	66 90                	xchg   %ax,%ax

00000ca0 <create_big_file>:

int create_big_file(char *filename, int N_PAGES) {
 ca0:	55                   	push   %ebp
 ca1:	89 e5                	mov    %esp,%ebp
 ca3:	57                   	push   %edi
 ca4:	56                   	push   %esi
 ca5:	53                   	push   %ebx
 ca6:	83 ec 1c             	sub    $0x1c,%esp
 ca9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // create a file
    int bufflen = 512;
    char buff[bufflen + 1];
 cac:	89 e0                	mov    %esp,%eax
 cae:	39 c4                	cmp    %eax,%esp
 cb0:	74 12                	je     cc4 <create_big_file+0x24>
 cb2:	81 ec 00 10 00 00    	sub    $0x1000,%esp
 cb8:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
 cbf:	00 
 cc0:	39 c4                	cmp    %eax,%esp
 cc2:	75 ee                	jne    cb2 <create_big_file+0x12>
 cc4:	81 ec 10 02 00 00    	sub    $0x210,%esp
 cca:	83 8c 24 0c 02 00 00 	orl    $0x0,0x20c(%esp)
 cd1:	00 
 cd2:	89 e6                	mov    %esp,%esi
    int fd = open(filename, O_CREATE | O_RDWR);
 cd4:	83 ec 08             	sub    $0x8,%esp
 cd7:	68 02 02 00 00       	push   $0x202
 cdc:	53                   	push   %ebx
 cdd:	e8 f1 f8 ff ff       	call   5d3 <open>
    if (fd < 0) {
 ce2:	89 f4                	mov    %esi,%esp
    int fd = open(filename, O_CREATE | O_RDWR);
 ce4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (fd < 0) {
 ce7:	85 c0                	test   %eax,%eax
 ce9:	0f 88 9c 00 00 00    	js     d8b <create_big_file+0xeb>
        printf(1, "XV6: Failed to create file %s\n", filename);
        failed();
    }
    // write in steps as we cannot have a buffer larger than PGSIZE
    char c = 'a';
    for (int i = 0; i < N_PAGES; i++) {
 cef:	8b 55 0c             	mov    0xc(%ebp),%edx
 cf2:	8d 9e 00 02 00 00    	lea    0x200(%esi),%ebx
 cf8:	89 f7                	mov    %esi,%edi
 cfa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 d01:	89 de                	mov    %ebx,%esi
 d03:	85 d2                	test   %edx,%edx
 d05:	7e 56                	jle    d5d <create_big_file+0xbd>
 d07:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
        int m = PGSIZE / bufflen;
        for (int k = 0; k < m; k++) {
 d0b:	31 d2                	xor    %edx,%edx
 d0d:	8d 58 61             	lea    0x61(%eax),%ebx
            // prepare the content to write
            for (int j = 0; j < bufflen; j++) {
 d10:	89 f8                	mov    %edi,%eax
 d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                buff[j] = c;
 d18:	88 18                	mov    %bl,(%eax)
            for (int j = 0; j < bufflen; j++) {
 d1a:	83 c0 01             	add    $0x1,%eax
 d1d:	39 f0                	cmp    %esi,%eax
 d1f:	75 f7                	jne    d18 <create_big_file+0x78>
            }
            buff[bufflen] = '\0';
            // write to file
            if (write(fd, buff, bufflen) != bufflen) {
 d21:	83 ec 04             	sub    $0x4,%esp
            buff[bufflen] = '\0';
 d24:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 d27:	c6 87 00 02 00 00 00 	movb   $0x0,0x200(%edi)
            if (write(fd, buff, bufflen) != bufflen) {
 d2e:	68 00 02 00 00       	push   $0x200
 d33:	57                   	push   %edi
 d34:	ff 75 e0             	push   -0x20(%ebp)
 d37:	e8 77 f8 ff ff       	call   5b3 <write>
 d3c:	83 c4 10             	add    $0x10,%esp
 d3f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 d42:	3d 00 02 00 00       	cmp    $0x200,%eax
 d47:	75 2d                	jne    d76 <create_big_file+0xd6>
        for (int k = 0; k < m; k++) {
 d49:	83 c2 01             	add    $0x1,%edx
 d4c:	83 fa 08             	cmp    $0x8,%edx
 d4f:	75 bf                	jne    d10 <create_big_file+0x70>
    for (int i = 0; i < N_PAGES; i++) {
 d51:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 d55:	8b 45 dc             	mov    -0x24(%ebp),%eax
 d58:	39 45 0c             	cmp    %eax,0xc(%ebp)
 d5b:	75 aa                	jne    d07 <create_big_file+0x67>
                failed();
            }
        }
        c++; // first page is filled with 'a', second with 'b', and so on
    }
    close(fd);
 d5d:	83 ec 0c             	sub    $0xc,%esp
 d60:	ff 75 e0             	push   -0x20(%ebp)
 d63:	e8 53 f8 ff ff       	call   5bb <close>
    return N_PAGES * PGSIZE;
 d68:	8b 45 0c             	mov    0xc(%ebp),%eax
}
 d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 d6e:	5b                   	pop    %ebx
 d6f:	5e                   	pop    %esi
    return N_PAGES * PGSIZE;
 d70:	c1 e0 0c             	shl    $0xc,%eax
}
 d73:	5f                   	pop    %edi
 d74:	5d                   	pop    %ebp
 d75:	c3                   	ret    
                printf(1, "XV6: Write to file FAILED (%d, %d)\n", i, k);
 d76:	52                   	push   %edx
 d77:	ff 75 dc             	push   -0x24(%ebp)
 d7a:	68 44 10 00 00       	push   $0x1044
 d7f:	6a 01                	push   $0x1
 d81:	e8 8a f9 ff ff       	call   710 <printf>
                failed();
 d86:	e8 d5 fc ff ff       	call   a60 <failed>
        printf(1, "XV6: Failed to create file %s\n", filename);
 d8b:	50                   	push   %eax
 d8c:	53                   	push   %ebx
 d8d:	68 00 10 00 00       	push   $0x1000
 d92:	6a 01                	push   $0x1
 d94:	e8 77 f9 ff ff       	call   710 <printf>
        failed();
 d99:	e8 c2 fc ff ff       	call   a60 <failed>
 d9e:	66 90                	xchg   %ax,%ax

00000da0 <va_exists>:

void va_exists(struct pgdirinfo *info, uint va, int expected) {
 da0:	55                   	push   %ebp
    int found = 0;
    for (int i = 0; i < info->n_upages; i++) {
 da1:	31 c0                	xor    %eax,%eax
void va_exists(struct pgdirinfo *info, uint va, int expected) {
 da3:	89 e5                	mov    %esp,%ebp
 da5:	53                   	push   %ebx
 da6:	83 ec 04             	sub    $0x4,%esp
 da9:	8b 55 08             	mov    0x8(%ebp),%edx
 dac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    for (int i = 0; i < info->n_upages; i++) {
 daf:	8b 0a                	mov    (%edx),%ecx
 db1:	85 c9                	test   %ecx,%ecx
 db3:	75 12                	jne    dc7 <va_exists+0x27>
 db5:	eb 1b                	jmp    dd2 <va_exists+0x32>
 db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 dbe:	66 90                	xchg   %ax,%ax
 dc0:	83 c0 01             	add    $0x1,%eax
 dc3:	39 c1                	cmp    %eax,%ecx
 dc5:	74 19                	je     de0 <va_exists+0x40>
        if (info->va[i] == va) {
 dc7:	39 5c 82 04          	cmp    %ebx,0x4(%edx,%eax,4)
 dcb:	75 f3                	jne    dc0 <va_exists+0x20>
            found = 1;
 dcd:	b8 01 00 00 00       	mov    $0x1,%eax
            break;
        }
    }
    if (found != expected) {
 dd2:	3b 45 10             	cmp    0x10(%ebp),%eax
 dd5:	75 0d                	jne    de4 <va_exists+0x44>
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
        failed();
    }
}
 dd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 dda:	c9                   	leave  
 ddb:	c3                   	ret    
 ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int found = 0;
 de0:	31 c0                	xor    %eax,%eax
 de2:	eb ee                	jmp    dd2 <va_exists+0x32>
        printf(1, "XV6: expected Virt.Addr. 0x%x to %s in the list of user pages\n", va, expected ? "exist" : "not exist");
 de4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 de8:	ba 23 0f 00 00       	mov    $0xf23,%edx
 ded:	b8 27 0f 00 00       	mov    $0xf27,%eax
 df2:	0f 44 c2             	cmove  %edx,%eax
 df5:	50                   	push   %eax
 df6:	53                   	push   %ebx
 df7:	68 68 10 00 00       	push   $0x1068
 dfc:	6a 01                	push   $0x1
 dfe:	e8 0d f9 ff ff       	call   710 <printf>
        failed();
 e03:	e8 58 fc ff ff       	call   a60 <failed>
