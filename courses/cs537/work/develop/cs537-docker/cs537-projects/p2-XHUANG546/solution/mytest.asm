
_mytest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
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
  10:	51                   	push   %ecx
  11:	83 ec 50             	sub    $0x50,%esp
  int fails = 0;
  struct rusage a, b;

  printf(1, "=== getrusage() basic tests ===\n");
  14:	68 04 0e 00 00       	push   $0xe04
  19:	6a 01                	push   $0x1
  1b:	e8 60 09 00 00       	call   980 <printf>

  // 0) NULL pointer should fail
  int r = getrusage(0);
  20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  27:	e8 97 08 00 00       	call   8c3 <getrusage>
  if(r != -1){
  2c:	83 c4 10             	add    $0x10,%esp
  2f:	83 f8 ff             	cmp    $0xffffffff,%eax
  32:	0f 84 33 03 00 00    	je     36b <main+0x36b>
    printf(1, "FAIL: getrusage(NULL) expected -1 got=%d\n", r);
  38:	52                   	push   %edx
    fails++;
  39:	bf 01 00 00 00       	mov    $0x1,%edi
    printf(1, "FAIL: getrusage(NULL) expected -1 got=%d\n", r);
  3e:	50                   	push   %eax
  3f:	68 28 0e 00 00       	push   $0xe28
  44:	6a 01                	push   $0x1
  46:	e8 35 09 00 00       	call   980 <printf>
    fails++;
  4b:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "PASS: getrusage(NULL) returns -1\n");
  }

  // 1) Back-to-back sanity/monotonicity
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage(&a)\n"); exit(); }
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	8d 75 c8             	lea    -0x38(%ebp),%esi
  54:	56                   	push   %esi
  55:	e8 69 08 00 00       	call   8c3 <getrusage>
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	85 c0                	test   %eax,%eax
  5f:	0f 88 f3 02 00 00    	js     358 <main+0x358>
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage(&b)\n"); exit(); }
  65:	83 ec 0c             	sub    $0xc,%esp
  68:	8d 45 d8             	lea    -0x28(%ebp),%eax
  6b:	50                   	push   %eax
  6c:	e8 52 08 00 00       	call   8c3 <getrusage>
  71:	83 c4 10             	add    $0x10,%esp
  74:	85 c0                	test   %eax,%eax
  76:	0f 88 07 03 00 00    	js     383 <main+0x383>

  if(b.utime < a.utime || b.stime < a.stime || b.nvcsw < a.nvcsw || b.write_count < a.write_count){
  7c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  7f:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  82:	72 0c                	jb     90 <main+0x90>
  84:	8b 45 cc             	mov    -0x34(%ebp),%eax
  87:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8a:	0f 83 06 03 00 00    	jae    396 <main+0x396>
    printf(1, "FAIL: counters decreased unexpectedly\n");
  90:	51                   	push   %ecx
    print_ru("A", &a);
    print_ru("B", &b);
    fails++;
  91:	83 c7 01             	add    $0x1,%edi
    printf(1, "FAIL: counters decreased unexpectedly\n");
  94:	51                   	push   %ecx
  95:	68 78 0e 00 00       	push   $0xe78
  9a:	6a 01                	push   $0x1
  9c:	e8 df 08 00 00       	call   980 <printf>
  printf(1, "%s: utime=%d stime=%d nvcsw=%d write_count=%d\n",
  a1:	83 c4 0c             	add    $0xc,%esp
  a4:	ff 75 d4             	push   -0x2c(%ebp)
  a7:	ff 75 d0             	push   -0x30(%ebp)
  aa:	ff 75 cc             	push   -0x34(%ebp)
  ad:	ff 75 c8             	push   -0x38(%ebp)
  b0:	68 2a 0d 00 00       	push   $0xd2a
  b5:	68 a0 0e 00 00       	push   $0xea0
  ba:	6a 01                	push   $0x1
  bc:	e8 bf 08 00 00       	call   980 <printf>
  c1:	83 c4 1c             	add    $0x1c,%esp
  c4:	ff 75 e4             	push   -0x1c(%ebp)
  c7:	ff 75 e0             	push   -0x20(%ebp)
  ca:	ff 75 dc             	push   -0x24(%ebp)
  cd:	ff 75 d8             	push   -0x28(%ebp)
  d0:	68 2c 0d 00 00       	push   $0xd2c
  d5:	68 a0 0e 00 00       	push   $0xea0
  da:	6a 01                	push   $0x1
  dc:	e8 9f 08 00 00       	call   980 <printf>
    fails++;
  e1:	83 c4 20             	add    $0x20,%esp
    printf(1, "PASS: monotonic counters\n");
  }

  // 2) write_count increments on successful writes
  const int NWRITE = 20;
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before write success\n"); exit(); }
  e4:	83 ec 0c             	sub    $0xc,%esp
  e7:	bb 14 00 00 00       	mov    $0x14,%ebx
  ec:	56                   	push   %esi
  ed:	e8 d1 07 00 00       	call   8c3 <getrusage>
  f2:	83 c4 10             	add    $0x10,%esp
  f5:	85 c0                	test   %eax,%eax
  f7:	0f 88 da 02 00 00    	js     3d7 <main+0x3d7>
  fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(int i = 0; i < NWRITE; i++){
    write(1, "x", 1);
 100:	83 ec 04             	sub    $0x4,%esp
 103:	6a 01                	push   $0x1
 105:	68 48 0d 00 00       	push   $0xd48
 10a:	6a 01                	push   $0x1
 10c:	e8 32 07 00 00       	call   843 <write>
  for(int i = 0; i < NWRITE; i++){
 111:	83 c4 10             	add    $0x10,%esp
 114:	83 eb 01             	sub    $0x1,%ebx
 117:	75 e7                	jne    100 <main+0x100>
  }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after write success\n"); exit(); }
 119:	83 ec 0c             	sub    $0xc,%esp
 11c:	8d 45 d8             	lea    -0x28(%ebp),%eax
 11f:	50                   	push   %eax
 120:	e8 9e 07 00 00       	call   8c3 <getrusage>
 125:	83 c4 10             	add    $0x10,%esp
 128:	85 c0                	test   %eax,%eax
 12a:	0f 88 94 02 00 00    	js     3c4 <main+0x3c4>
  fails += (check_eq("write_count delta (success writes)",
                     (int)(b.write_count - a.write_count), NWRITE) < 0);
 130:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  fails += (check_eq("write_count delta (success writes)",
 133:	b9 14 00 00 00       	mov    $0x14,%ecx
                     (int)(b.write_count - a.write_count), NWRITE) < 0);
 138:	2b 55 d4             	sub    -0x2c(%ebp),%edx
  fails += (check_eq("write_count delta (success writes)",
 13b:	b8 20 0f 00 00       	mov    $0xf20,%eax
 140:	e8 0b 04 00 00       	call   550 <check_eq>

  // 3) write_count increments on failed writes: bad fd
  const int NFAILFD = 10;
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before bad-fd writes\n"); exit(); }
 145:	83 ec 0c             	sub    $0xc,%esp
 148:	bb 0a 00 00 00       	mov    $0xa,%ebx
 14d:	56                   	push   %esi
  fails += (check_eq("write_count delta (success writes)",
 14e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before bad-fd writes\n"); exit(); }
 151:	e8 6d 07 00 00       	call   8c3 <getrusage>
 156:	83 c4 10             	add    $0x10,%esp
 159:	85 c0                	test   %eax,%eax
 15b:	0f 88 af 02 00 00    	js     410 <main+0x410>
 161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(int i = 0; i < NFAILFD; i++){
    int rc = write(99, "y", 1);
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	6a 01                	push   $0x1
 16d:	68 4a 0d 00 00       	push   $0xd4a
 172:	6a 63                	push   $0x63
 174:	e8 ca 06 00 00       	call   843 <write>
  for(int i = 0; i < NFAILFD; i++){
 179:	83 c4 10             	add    $0x10,%esp
 17c:	83 eb 01             	sub    $0x1,%ebx
 17f:	75 e7                	jne    168 <main+0x168>
    (void)rc; // ignore return
  }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after bad-fd writes\n"); exit(); }
 181:	83 ec 0c             	sub    $0xc,%esp
 184:	8d 45 d8             	lea    -0x28(%ebp),%eax
 187:	50                   	push   %eax
 188:	e8 36 07 00 00       	call   8c3 <getrusage>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	85 c0                	test   %eax,%eax
 192:	0f 88 52 02 00 00    	js     3ea <main+0x3ea>
  fails += (check_eq("write_count delta (bad-fd failed writes)",
 198:	b9 0a 00 00 00       	mov    $0xa,%ecx
                     (int)(b.write_count - a.write_count), NFAILFD) < 0);
 19d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  fails += (check_eq("write_count delta (bad-fd failed writes)",
 1a0:	b8 94 0f 00 00       	mov    $0xf94,%eax
                     (int)(b.write_count - a.write_count), NFAILFD) < 0);
 1a5:	2b 55 d4             	sub    -0x2c(%ebp),%edx
  fails += (check_eq("write_count delta (bad-fd failed writes)",
 1a8:	e8 a3 03 00 00       	call   550 <check_eq>

  // 4) getrusage pointer validation: straddle end of heap should fail
  // Put struct pointer at (sbrk(0) - 1), so sizeof(struct rusage) crosses into unmapped memory.
  char *brk = (char*)sbrk(0);
 1ad:	83 ec 0c             	sub    $0xc,%esp
                     (int)(b.write_count - a.write_count), NWRITE) < 0);
 1b0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  char *brk = (char*)sbrk(0);
 1b3:	6a 00                	push   $0x0
                     (int)(b.write_count - a.write_count), NFAILFD) < 0);
 1b5:	c1 e8 1f             	shr    $0x1f,%eax
                     (int)(b.write_count - a.write_count), NWRITE) < 0);
 1b8:	c1 ea 1f             	shr    $0x1f,%edx
  fails += (check_eq("write_count delta (success writes)",
 1bb:	01 fa                	add    %edi,%edx
  fails += (check_eq("write_count delta (bad-fd failed writes)",
 1bd:	8d 3c 10             	lea    (%eax,%edx,1),%edi
  char *brk = (char*)sbrk(0);
 1c0:	e8 e6 06 00 00       	call   8ab <sbrk>
  struct rusage *bad = (struct rusage*)(brk - 1);
 1c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  char *brk = (char*)sbrk(0);
 1c8:	89 c3                	mov    %eax,%ebx
  r = getrusage(bad);
 1ca:	89 14 24             	mov    %edx,(%esp)
 1cd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
 1d0:	e8 ee 06 00 00       	call   8c3 <getrusage>
  if(r != -1){
 1d5:	83 c4 10             	add    $0x10,%esp
 1d8:	83 f8 ff             	cmp    $0xffffffff,%eax
 1db:	0f 84 42 02 00 00    	je     423 <main+0x423>
    printf(1, "FAIL: getrusage(straddle) expected -1 got=%d (brk=%p bad=%p)\n", r, brk, bad);
 1e1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
 1e4:	83 ec 0c             	sub    $0xc,%esp
    fails++;
 1e7:	83 c7 01             	add    $0x1,%edi
    printf(1, "FAIL: getrusage(straddle) expected -1 got=%d (brk=%p bad=%p)\n", r, brk, bad);
 1ea:	52                   	push   %edx
 1eb:	53                   	push   %ebx
 1ec:	50                   	push   %eax
 1ed:	68 c0 0f 00 00       	push   $0xfc0
 1f2:	6a 01                	push   $0x1
 1f4:	e8 87 07 00 00       	call   980 <printf>
    fails++;
 1f9:	83 c4 20             	add    $0x20,%esp
  } else {
    printf(1, "PASS: getrusage(straddle end-of-heap) returns -1\n");
  }

  // 5) utime grows under pure user-space busy loop
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before busy loop\n"); exit(); }
 1fc:	83 ec 0c             	sub    $0xc,%esp
 1ff:	56                   	push   %esi
 200:	e8 be 06 00 00       	call   8c3 <getrusage>
 205:	83 c4 10             	add    $0x10,%esp
 208:	85 c0                	test   %eax,%eax
 20a:	0f 88 29 02 00 00    	js     439 <main+0x439>
  volatile int sink = 0;
 210:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  for(int i = 0; i < 200000000; i++){
 217:	31 c0                	xor    %eax,%eax
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sink += i;
 220:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 223:	01 c2                	add    %eax,%edx
  for(int i = 0; i < 200000000; i++){
 225:	83 c0 01             	add    $0x1,%eax
    sink += i;
 228:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  for(int i = 0; i < 200000000; i++){
 22b:	3d 00 c2 eb 0b       	cmp    $0xbebc200,%eax
 230:	75 ee                	jne    220 <main+0x220>
  }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after busy loop\n"); exit(); }
 232:	83 ec 0c             	sub    $0xc,%esp
 235:	8d 45 d8             	lea    -0x28(%ebp),%eax
 238:	50                   	push   %eax
 239:	e8 85 06 00 00       	call   8c3 <getrusage>
 23e:	83 c4 10             	add    $0x10,%esp
 241:	85 c0                	test   %eax,%eax
 243:	0f 88 b4 01 00 00    	js     3fd <main+0x3fd>
  (void)sink;
 249:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  fails += (check_ge("utime delta after busy loop", (int)(b.utime - a.utime), 1) < 0);
 24c:	8b 55 d8             	mov    -0x28(%ebp),%edx
 24f:	b8 4c 0d 00 00       	mov    $0xd4c,%eax
 254:	bb 40 0d 03 00       	mov    $0x30d40,%ebx
 259:	2b 55 c8             	sub    -0x38(%ebp),%edx
 25c:	e8 2f 03 00 00       	call   590 <check_ge.constprop.0>

  // 6) stime grows under lots of syscalls (best-effort; use >= 1)
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before syscall loop\n"); exit(); }
 261:	83 ec 0c             	sub    $0xc,%esp
 264:	56                   	push   %esi
  fails += (check_ge("utime delta after busy loop", (int)(b.utime - a.utime), 1) < 0);
 265:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before syscall loop\n"); exit(); }
 268:	e8 56 06 00 00       	call   8c3 <getrusage>
 26d:	83 c4 10             	add    $0x10,%esp
 270:	85 c0                	test   %eax,%eax
 272:	0f 88 e7 01 00 00    	js     45f <main+0x45f>
 278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27f:	90                   	nop
  for(int i = 0; i < 200000; i++){
    getpid();
 280:	e8 1e 06 00 00       	call   8a3 <getpid>
  for(int i = 0; i < 200000; i++){
 285:	83 eb 01             	sub    $0x1,%ebx
 288:	75 f6                	jne    280 <main+0x280>
  }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after syscall loop\n"); exit(); }
 28a:	83 ec 0c             	sub    $0xc,%esp
 28d:	8d 45 d8             	lea    -0x28(%ebp),%eax
 290:	50                   	push   %eax
 291:	e8 2d 06 00 00       	call   8c3 <getrusage>
 296:	83 c4 10             	add    $0x10,%esp
 299:	85 c0                	test   %eax,%eax
 29b:	0f 88 ab 01 00 00    	js     44c <main+0x44c>
  fails += (check_ge("stime delta after syscall loop", (int)(b.stime - a.stime), 1) < 0);
 2a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
 2a4:	b8 c8 10 00 00       	mov    $0x10c8,%eax
 2a9:	2b 55 cc             	sub    -0x34(%ebp),%edx
 2ac:	bb 0a 00 00 00       	mov    $0xa,%ebx
 2b1:	e8 da 02 00 00       	call   590 <check_ge.constprop.0>

  // 7) nvcsw via sleep(): each sleep(1) should block once => +1 voluntary context switch
  const int NSLEEP = 10;
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before sleep loop\n"); exit(); }
 2b6:	83 ec 0c             	sub    $0xc,%esp
 2b9:	56                   	push   %esi
  fails += (check_ge("stime delta after syscall loop", (int)(b.stime - a.stime), 1) < 0);
 2ba:	89 45 b0             	mov    %eax,-0x50(%ebp)
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before sleep loop\n"); exit(); }
 2bd:	e8 01 06 00 00       	call   8c3 <getrusage>
 2c2:	83 c4 10             	add    $0x10,%esp
 2c5:	85 c0                	test   %eax,%eax
 2c7:	0f 88 b8 01 00 00    	js     485 <main+0x485>
  for(int i = 0; i < NSLEEP; i++){
    sleep(1);
 2cd:	83 ec 0c             	sub    $0xc,%esp
 2d0:	6a 01                	push   $0x1
 2d2:	e8 dc 05 00 00       	call   8b3 <sleep>
  for(int i = 0; i < NSLEEP; i++){
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	83 eb 01             	sub    $0x1,%ebx
 2dd:	75 ee                	jne    2cd <main+0x2cd>
  }
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after sleep loop\n"); exit(); }
 2df:	83 ec 0c             	sub    $0xc,%esp
 2e2:	8d 45 d8             	lea    -0x28(%ebp),%eax
 2e5:	50                   	push   %eax
 2e6:	e8 d8 05 00 00       	call   8c3 <getrusage>
 2eb:	83 c4 10             	add    $0x10,%esp
 2ee:	85 c0                	test   %eax,%eax
 2f0:	0f 88 7c 01 00 00    	js     472 <main+0x472>
  fails += (check_eq("nvcsw delta after N sleep(1)", (int)(b.nvcsw - a.nvcsw), NSLEEP) < 0);
 2f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
 2f9:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2fe:	2b 55 d0             	sub    -0x30(%ebp),%edx
 301:	b8 68 0d 00 00       	mov    $0xd68,%eax
 306:	e8 45 02 00 00       	call   550 <check_eq>

  // 8) nvcsw via wait(): parent blocks once waiting for child
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before wait test\n"); exit(); }
 30b:	83 ec 0c             	sub    $0xc,%esp
 30e:	56                   	push   %esi
  fails += (check_eq("nvcsw delta after N sleep(1)", (int)(b.nvcsw - a.nvcsw), NSLEEP) < 0);
 30f:	89 c3                	mov    %eax,%ebx
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before wait test\n"); exit(); }
 311:	e8 ad 05 00 00       	call   8c3 <getrusage>
 316:	83 c4 10             	add    $0x10,%esp
 319:	85 c0                	test   %eax,%eax
 31b:	0f 88 77 01 00 00    	js     498 <main+0x498>
  fails += (check_ge("utime delta after busy loop", (int)(b.utime - a.utime), 1) < 0);
 321:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  fails += (check_ge("stime delta after syscall loop", (int)(b.stime - a.stime), 1) < 0);
 324:	8b 55 b0             	mov    -0x50(%ebp),%edx
  fails += (check_eq("nvcsw delta after N sleep(1)", (int)(b.nvcsw - a.nvcsw), NSLEEP) < 0);
 327:	c1 eb 1f             	shr    $0x1f,%ebx
  fails += (check_ge("utime delta after busy loop", (int)(b.utime - a.utime), 1) < 0);
 32a:	c1 e8 1f             	shr    $0x1f,%eax
  fails += (check_ge("stime delta after syscall loop", (int)(b.stime - a.stime), 1) < 0);
 32d:	c1 ea 1f             	shr    $0x1f,%edx
  fails += (check_ge("utime delta after busy loop", (int)(b.utime - a.utime), 1) < 0);
 330:	01 f8                	add    %edi,%eax
  fails += (check_ge("stime delta after syscall loop", (int)(b.stime - a.stime), 1) < 0);
 332:	01 d0                	add    %edx,%eax
  fails += (check_eq("nvcsw delta after N sleep(1)", (int)(b.nvcsw - a.nvcsw), NSLEEP) < 0);
 334:	01 c3                	add    %eax,%ebx
  int pid = fork();
 336:	e8 e0 04 00 00       	call   81b <fork>
  if(pid < 0){
 33b:	85 c0                	test   %eax,%eax
 33d:	0f 88 c0 01 00 00    	js     503 <main+0x503>
    printf(1, "FAIL: fork() for wait test\n");
    fails++;
  } else if(pid == 0){
 343:	0f 85 62 01 00 00    	jne    4ab <main+0x4ab>
    // child: sleep a bit so parent actually blocks
    sleep(10);
 349:	83 ec 0c             	sub    $0xc,%esp
 34c:	6a 0a                	push   $0xa
 34e:	e8 60 05 00 00       	call   8b3 <sleep>
    exit();
 353:	e8 cb 04 00 00       	call   823 <exit>
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage(&a)\n"); exit(); }
 358:	56                   	push   %esi
 359:	56                   	push   %esi
 35a:	68 00 0d 00 00       	push   $0xd00
 35f:	6a 01                	push   $0x1
 361:	e8 1a 06 00 00       	call   980 <printf>
 366:	e8 b8 04 00 00       	call   823 <exit>
    printf(1, "PASS: getrusage(NULL) returns -1\n");
 36b:	57                   	push   %edi
 36c:	57                   	push   %edi
  int fails = 0;
 36d:	31 ff                	xor    %edi,%edi
    printf(1, "PASS: getrusage(NULL) returns -1\n");
 36f:	68 54 0e 00 00       	push   $0xe54
 374:	6a 01                	push   $0x1
 376:	e8 05 06 00 00       	call   980 <printf>
 37b:	83 c4 10             	add    $0x10,%esp
 37e:	e9 cb fc ff ff       	jmp    4e <main+0x4e>
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage(&b)\n"); exit(); }
 383:	53                   	push   %ebx
 384:	53                   	push   %ebx
 385:	68 15 0d 00 00       	push   $0xd15
 38a:	6a 01                	push   $0x1
 38c:	e8 ef 05 00 00       	call   980 <printf>
 391:	e8 8d 04 00 00       	call   823 <exit>
  if(b.utime < a.utime || b.stime < a.stime || b.nvcsw < a.nvcsw || b.write_count < a.write_count){
 396:	8b 45 d0             	mov    -0x30(%ebp),%eax
 399:	39 45 e0             	cmp    %eax,-0x20(%ebp)
 39c:	0f 82 ee fc ff ff    	jb     90 <main+0x90>
 3a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3a5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
 3a8:	0f 82 e2 fc ff ff    	jb     90 <main+0x90>
    printf(1, "PASS: monotonic counters\n");
 3ae:	52                   	push   %edx
 3af:	52                   	push   %edx
 3b0:	68 2e 0d 00 00       	push   $0xd2e
 3b5:	6a 01                	push   $0x1
 3b7:	e8 c4 05 00 00       	call   980 <printf>
 3bc:	83 c4 10             	add    $0x10,%esp
 3bf:	e9 20 fd ff ff       	jmp    e4 <main+0xe4>
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after write success\n"); exit(); }
 3c4:	50                   	push   %eax
 3c5:	50                   	push   %eax
 3c6:	68 f8 0e 00 00       	push   $0xef8
 3cb:	6a 01                	push   $0x1
 3cd:	e8 ae 05 00 00       	call   980 <printf>
 3d2:	e8 4c 04 00 00       	call   823 <exit>
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before write success\n"); exit(); }
 3d7:	50                   	push   %eax
 3d8:	50                   	push   %eax
 3d9:	68 d0 0e 00 00       	push   $0xed0
 3de:	6a 01                	push   $0x1
 3e0:	e8 9b 05 00 00       	call   980 <printf>
 3e5:	e8 39 04 00 00       	call   823 <exit>
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after bad-fd writes\n"); exit(); }
 3ea:	50                   	push   %eax
 3eb:	50                   	push   %eax
 3ec:	68 6c 0f 00 00       	push   $0xf6c
 3f1:	6a 01                	push   $0x1
 3f3:	e8 88 05 00 00       	call   980 <printf>
 3f8:	e8 26 04 00 00       	call   823 <exit>
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after busy loop\n"); exit(); }
 3fd:	51                   	push   %ecx
 3fe:	51                   	push   %ecx
 3ff:	68 58 10 00 00       	push   $0x1058
 404:	6a 01                	push   $0x1
 406:	e8 75 05 00 00       	call   980 <printf>
 40b:	e8 13 04 00 00       	call   823 <exit>
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before bad-fd writes\n"); exit(); }
 410:	50                   	push   %eax
 411:	50                   	push   %eax
 412:	68 44 0f 00 00       	push   $0xf44
 417:	6a 01                	push   $0x1
 419:	e8 62 05 00 00       	call   980 <printf>
 41e:	e8 00 04 00 00       	call   823 <exit>
    printf(1, "PASS: getrusage(straddle end-of-heap) returns -1\n");
 423:	50                   	push   %eax
 424:	50                   	push   %eax
 425:	68 00 10 00 00       	push   $0x1000
 42a:	6a 01                	push   $0x1
 42c:	e8 4f 05 00 00       	call   980 <printf>
 431:	83 c4 10             	add    $0x10,%esp
 434:	e9 c3 fd ff ff       	jmp    1fc <main+0x1fc>
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before busy loop\n"); exit(); }
 439:	53                   	push   %ebx
 43a:	53                   	push   %ebx
 43b:	68 34 10 00 00       	push   $0x1034
 440:	6a 01                	push   $0x1
 442:	e8 39 05 00 00       	call   980 <printf>
 447:	e8 d7 03 00 00       	call   823 <exit>
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after syscall loop\n"); exit(); }
 44c:	50                   	push   %eax
 44d:	50                   	push   %eax
 44e:	68 a4 10 00 00       	push   $0x10a4
 453:	6a 01                	push   $0x1
 455:	e8 26 05 00 00       	call   980 <printf>
 45a:	e8 c4 03 00 00       	call   823 <exit>
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before syscall loop\n"); exit(); }
 45f:	52                   	push   %edx
 460:	52                   	push   %edx
 461:	68 7c 10 00 00       	push   $0x107c
 466:	6a 01                	push   $0x1
 468:	e8 13 05 00 00       	call   980 <printf>
 46d:	e8 b1 03 00 00       	call   823 <exit>
  if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after sleep loop\n"); exit(); }
 472:	50                   	push   %eax
 473:	50                   	push   %eax
 474:	68 0c 11 00 00       	push   $0x110c
 479:	6a 01                	push   $0x1
 47b:	e8 00 05 00 00       	call   980 <printf>
 480:	e8 9e 03 00 00       	call   823 <exit>
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before sleep loop\n"); exit(); }
 485:	50                   	push   %eax
 486:	50                   	push   %eax
 487:	68 e8 10 00 00       	push   $0x10e8
 48c:	6a 01                	push   $0x1
 48e:	e8 ed 04 00 00       	call   980 <printf>
 493:	e8 8b 03 00 00       	call   823 <exit>
  if(getrusage(&a) < 0){ printf(1, "FAIL: getrusage before wait test\n"); exit(); }
 498:	50                   	push   %eax
 499:	50                   	push   %eax
 49a:	68 30 11 00 00       	push   $0x1130
 49f:	6a 01                	push   $0x1
 4a1:	e8 da 04 00 00       	call   980 <printf>
 4a6:	e8 78 03 00 00       	call   823 <exit>
  } else {
    wait();
 4ab:	e8 7b 03 00 00       	call   82b <wait>
    if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after wait\n"); exit(); }
 4b0:	83 ec 0c             	sub    $0xc,%esp
 4b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
 4b6:	50                   	push   %eax
 4b7:	e8 07 04 00 00       	call   8c3 <getrusage>
 4bc:	83 c4 10             	add    $0x10,%esp
 4bf:	85 c0                	test   %eax,%eax
 4c1:	78 75                	js     538 <main+0x538>
    // Some implementations may count more than 1; require at least 1.
    fails += (check_ge("nvcsw delta after wait()", (int)(b.nvcsw - a.nvcsw), 1) < 0);
 4c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
 4c6:	b8 ce 0d 00 00       	mov    $0xdce,%eax
 4cb:	2b 55 d0             	sub    -0x30(%ebp),%edx
 4ce:	e8 bd 00 00 00       	call   590 <check_ge.constprop.0>
  }

  printf(1, "=== summary ===\n");
 4d3:	51                   	push   %ecx
    fails += (check_ge("nvcsw delta after wait()", (int)(b.nvcsw - a.nvcsw), 1) < 0);
 4d4:	c1 e8 1f             	shr    $0x1f,%eax
  printf(1, "=== summary ===\n");
 4d7:	51                   	push   %ecx
    fails += (check_ge("nvcsw delta after wait()", (int)(b.nvcsw - a.nvcsw), 1) < 0);
 4d8:	01 c3                	add    %eax,%ebx
  printf(1, "=== summary ===\n");
 4da:	68 a1 0d 00 00       	push   $0xda1
 4df:	6a 01                	push   $0x1
 4e1:	e8 9a 04 00 00       	call   980 <printf>
  if(fails == 0){
 4e6:	83 c4 10             	add    $0x10,%esp
 4e9:	85 db                	test   %ebx,%ebx
 4eb:	75 38                	jne    525 <main+0x525>
    printf(1, "ALL PASS\n");
 4ed:	52                   	push   %edx
 4ee:	52                   	push   %edx
 4ef:	68 e7 0d 00 00       	push   $0xde7
 4f4:	6a 01                	push   $0x1
 4f6:	e8 85 04 00 00       	call   980 <printf>
 4fb:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "TOTAL FAILS: %d\n", fails);
  }

  exit();
 4fe:	e8 20 03 00 00       	call   823 <exit>
    printf(1, "FAIL: fork() for wait test\n");
 503:	56                   	push   %esi
    fails++;
 504:	83 c3 01             	add    $0x1,%ebx
    printf(1, "FAIL: fork() for wait test\n");
 507:	56                   	push   %esi
 508:	68 85 0d 00 00       	push   $0xd85
 50d:	6a 01                	push   $0x1
 50f:	e8 6c 04 00 00       	call   980 <printf>
  printf(1, "=== summary ===\n");
 514:	5f                   	pop    %edi
 515:	58                   	pop    %eax
 516:	68 a1 0d 00 00       	push   $0xda1
 51b:	6a 01                	push   $0x1
 51d:	e8 5e 04 00 00       	call   980 <printf>
 522:	83 c4 10             	add    $0x10,%esp
    printf(1, "TOTAL FAILS: %d\n", fails);
 525:	50                   	push   %eax
 526:	53                   	push   %ebx
 527:	68 f1 0d 00 00       	push   $0xdf1
 52c:	6a 01                	push   $0x1
 52e:	e8 4d 04 00 00       	call   980 <printf>
 533:	83 c4 10             	add    $0x10,%esp
 536:	eb c6                	jmp    4fe <main+0x4fe>
    if(getrusage(&b) < 0){ printf(1, "FAIL: getrusage after wait\n"); exit(); }
 538:	53                   	push   %ebx
 539:	53                   	push   %ebx
 53a:	68 b2 0d 00 00       	push   $0xdb2
 53f:	6a 01                	push   $0x1
 541:	e8 3a 04 00 00       	call   980 <printf>
 546:	e8 d8 02 00 00       	call   823 <exit>
 54b:	66 90                	xchg   %ax,%ax
 54d:	66 90                	xchg   %ax,%ax
 54f:	90                   	nop

00000550 <check_eq>:
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	83 ec 08             	sub    $0x8,%esp
  if(got != exp){
 556:	39 ca                	cmp    %ecx,%edx
 558:	75 15                	jne    56f <check_eq+0x1f>
  printf(1, "PASS: %s (%d)\n", name, got);
 55a:	52                   	push   %edx
 55b:	50                   	push   %eax
 55c:	68 c0 0c 00 00       	push   $0xcc0
 561:	6a 01                	push   $0x1
 563:	e8 18 04 00 00       	call   980 <printf>
  return 0;
 568:	83 c4 10             	add    $0x10,%esp
 56b:	31 c0                	xor    %eax,%eax
}
 56d:	c9                   	leave  
 56e:	c3                   	ret    
    printf(1, "FAIL: %s got=%d exp=%d\n", name, got, exp);
 56f:	83 ec 0c             	sub    $0xc,%esp
 572:	51                   	push   %ecx
 573:	52                   	push   %edx
 574:	50                   	push   %eax
 575:	68 a8 0c 00 00       	push   $0xca8
 57a:	6a 01                	push   $0x1
 57c:	e8 ff 03 00 00       	call   980 <printf>
 581:	83 c4 20             	add    $0x20,%esp
 584:	83 c8 ff             	or     $0xffffffff,%eax
}
 587:	c9                   	leave  
 588:	c3                   	ret    
 589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000590 <check_ge.constprop.0>:
check_ge(const char *name, int got, int minv)
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	83 ec 08             	sub    $0x8,%esp
  if(got < minv){
 596:	85 d2                	test   %edx,%edx
 598:	7e 1a                	jle    5b4 <check_ge.constprop.0+0x24>
  printf(1, "PASS: %s (got=%d >= %d)\n", name, got, minv);
 59a:	83 ec 0c             	sub    $0xc,%esp
 59d:	6a 01                	push   $0x1
 59f:	52                   	push   %edx
 5a0:	50                   	push   %eax
 5a1:	68 e7 0c 00 00       	push   $0xce7
 5a6:	6a 01                	push   $0x1
 5a8:	e8 d3 03 00 00       	call   980 <printf>
  return 0;
 5ad:	83 c4 20             	add    $0x20,%esp
 5b0:	31 c0                	xor    %eax,%eax
}
 5b2:	c9                   	leave  
 5b3:	c3                   	ret    
    printf(1, "FAIL: %s got=%d min=%d\n", name, got, minv);
 5b4:	83 ec 0c             	sub    $0xc,%esp
 5b7:	6a 01                	push   $0x1
 5b9:	52                   	push   %edx
 5ba:	50                   	push   %eax
 5bb:	68 cf 0c 00 00       	push   $0xccf
 5c0:	6a 01                	push   $0x1
 5c2:	e8 b9 03 00 00       	call   980 <printf>
 5c7:	83 c4 20             	add    $0x20,%esp
 5ca:	83 c8 ff             	or     $0xffffffff,%eax
}
 5cd:	c9                   	leave  
 5ce:	c3                   	ret    
 5cf:	90                   	nop

000005d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 5d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 5d1:	31 c0                	xor    %eax,%eax
{
 5d3:	89 e5                	mov    %esp,%ebp
 5d5:	53                   	push   %ebx
 5d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 5dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 5e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 5e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 5e7:	83 c0 01             	add    $0x1,%eax
 5ea:	84 d2                	test   %dl,%dl
 5ec:	75 f2                	jne    5e0 <strcpy+0x10>
    ;
  return os;
}
 5ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5f1:	89 c8                	mov    %ecx,%eax
 5f3:	c9                   	leave  
 5f4:	c3                   	ret    
 5f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000600 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	53                   	push   %ebx
 604:	8b 55 08             	mov    0x8(%ebp),%edx
 607:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 60a:	0f b6 02             	movzbl (%edx),%eax
 60d:	84 c0                	test   %al,%al
 60f:	75 17                	jne    628 <strcmp+0x28>
 611:	eb 3a                	jmp    64d <strcmp+0x4d>
 613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 617:	90                   	nop
 618:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 61c:	83 c2 01             	add    $0x1,%edx
 61f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 622:	84 c0                	test   %al,%al
 624:	74 1a                	je     640 <strcmp+0x40>
    p++, q++;
 626:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 628:	0f b6 19             	movzbl (%ecx),%ebx
 62b:	38 c3                	cmp    %al,%bl
 62d:	74 e9                	je     618 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 62f:	29 d8                	sub    %ebx,%eax
}
 631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 634:	c9                   	leave  
 635:	c3                   	ret    
 636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 640:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 644:	31 c0                	xor    %eax,%eax
 646:	29 d8                	sub    %ebx,%eax
}
 648:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 64b:	c9                   	leave  
 64c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 64d:	0f b6 19             	movzbl (%ecx),%ebx
 650:	31 c0                	xor    %eax,%eax
 652:	eb db                	jmp    62f <strcmp+0x2f>
 654:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 65b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 65f:	90                   	nop

00000660 <strlen>:

uint
strlen(const char *s)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 666:	80 3a 00             	cmpb   $0x0,(%edx)
 669:	74 15                	je     680 <strlen+0x20>
 66b:	31 c0                	xor    %eax,%eax
 66d:	8d 76 00             	lea    0x0(%esi),%esi
 670:	83 c0 01             	add    $0x1,%eax
 673:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 677:	89 c1                	mov    %eax,%ecx
 679:	75 f5                	jne    670 <strlen+0x10>
    ;
  return n;
}
 67b:	89 c8                	mov    %ecx,%eax
 67d:	5d                   	pop    %ebp
 67e:	c3                   	ret    
 67f:	90                   	nop
  for(n = 0; s[n]; n++)
 680:	31 c9                	xor    %ecx,%ecx
}
 682:	5d                   	pop    %ebp
 683:	89 c8                	mov    %ecx,%eax
 685:	c3                   	ret    
 686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68d:	8d 76 00             	lea    0x0(%esi),%esi

00000690 <memset>:

void*
memset(void *dst, int c, uint n)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 697:	8b 4d 10             	mov    0x10(%ebp),%ecx
 69a:	8b 45 0c             	mov    0xc(%ebp),%eax
 69d:	89 d7                	mov    %edx,%edi
 69f:	fc                   	cld    
 6a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 6a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 6a5:	89 d0                	mov    %edx,%eax
 6a7:	c9                   	leave  
 6a8:	c3                   	ret    
 6a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000006b0 <strchr>:

char*
strchr(const char *s, char c)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	8b 45 08             	mov    0x8(%ebp),%eax
 6b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 6ba:	0f b6 10             	movzbl (%eax),%edx
 6bd:	84 d2                	test   %dl,%dl
 6bf:	75 12                	jne    6d3 <strchr+0x23>
 6c1:	eb 1d                	jmp    6e0 <strchr+0x30>
 6c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6c7:	90                   	nop
 6c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 6cc:	83 c0 01             	add    $0x1,%eax
 6cf:	84 d2                	test   %dl,%dl
 6d1:	74 0d                	je     6e0 <strchr+0x30>
    if(*s == c)
 6d3:	38 d1                	cmp    %dl,%cl
 6d5:	75 f1                	jne    6c8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 6d7:	5d                   	pop    %ebp
 6d8:	c3                   	ret    
 6d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 6e0:	31 c0                	xor    %eax,%eax
}
 6e2:	5d                   	pop    %ebp
 6e3:	c3                   	ret    
 6e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6ef:	90                   	nop

000006f0 <gets>:

char*
gets(char *buf, int max)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 6f5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 6f8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 6f9:	31 db                	xor    %ebx,%ebx
{
 6fb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 6fe:	eb 27                	jmp    727 <gets+0x37>
    cc = read(0, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	6a 01                	push   $0x1
 705:	57                   	push   %edi
 706:	6a 00                	push   $0x0
 708:	e8 2e 01 00 00       	call   83b <read>
    if(cc < 1)
 70d:	83 c4 10             	add    $0x10,%esp
 710:	85 c0                	test   %eax,%eax
 712:	7e 1d                	jle    731 <gets+0x41>
      break;
    buf[i++] = c;
 714:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 718:	8b 55 08             	mov    0x8(%ebp),%edx
 71b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 71f:	3c 0a                	cmp    $0xa,%al
 721:	74 1d                	je     740 <gets+0x50>
 723:	3c 0d                	cmp    $0xd,%al
 725:	74 19                	je     740 <gets+0x50>
  for(i=0; i+1 < max; ){
 727:	89 de                	mov    %ebx,%esi
 729:	83 c3 01             	add    $0x1,%ebx
 72c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 72f:	7c cf                	jl     700 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 738:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73b:	5b                   	pop    %ebx
 73c:	5e                   	pop    %esi
 73d:	5f                   	pop    %edi
 73e:	5d                   	pop    %ebp
 73f:	c3                   	ret    
  buf[i] = '\0';
 740:	8b 45 08             	mov    0x8(%ebp),%eax
 743:	89 de                	mov    %ebx,%esi
 745:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 749:	8d 65 f4             	lea    -0xc(%ebp),%esp
 74c:	5b                   	pop    %ebx
 74d:	5e                   	pop    %esi
 74e:	5f                   	pop    %edi
 74f:	5d                   	pop    %ebp
 750:	c3                   	ret    
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop

00000760 <stat>:

int
stat(const char *n, struct stat *st)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	56                   	push   %esi
 764:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 765:	83 ec 08             	sub    $0x8,%esp
 768:	6a 00                	push   $0x0
 76a:	ff 75 08             	push   0x8(%ebp)
 76d:	e8 f1 00 00 00       	call   863 <open>
  if(fd < 0)
 772:	83 c4 10             	add    $0x10,%esp
 775:	85 c0                	test   %eax,%eax
 777:	78 27                	js     7a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 779:	83 ec 08             	sub    $0x8,%esp
 77c:	ff 75 0c             	push   0xc(%ebp)
 77f:	89 c3                	mov    %eax,%ebx
 781:	50                   	push   %eax
 782:	e8 f4 00 00 00       	call   87b <fstat>
  close(fd);
 787:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 78a:	89 c6                	mov    %eax,%esi
  close(fd);
 78c:	e8 ba 00 00 00       	call   84b <close>
  return r;
 791:	83 c4 10             	add    $0x10,%esp
}
 794:	8d 65 f8             	lea    -0x8(%ebp),%esp
 797:	89 f0                	mov    %esi,%eax
 799:	5b                   	pop    %ebx
 79a:	5e                   	pop    %esi
 79b:	5d                   	pop    %ebp
 79c:	c3                   	ret    
 79d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 7a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 7a5:	eb ed                	jmp    794 <stat+0x34>
 7a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ae:	66 90                	xchg   %ax,%ax

000007b0 <atoi>:

int
atoi(const char *s)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	53                   	push   %ebx
 7b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7b7:	0f be 02             	movsbl (%edx),%eax
 7ba:	8d 48 d0             	lea    -0x30(%eax),%ecx
 7bd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 7c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 7c5:	77 1e                	ja     7e5 <atoi+0x35>
 7c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ce:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 7d0:	83 c2 01             	add    $0x1,%edx
 7d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 7d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 7da:	0f be 02             	movsbl (%edx),%eax
 7dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 7e0:	80 fb 09             	cmp    $0x9,%bl
 7e3:	76 eb                	jbe    7d0 <atoi+0x20>
  return n;
}
 7e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7e8:	89 c8                	mov    %ecx,%eax
 7ea:	c9                   	leave  
 7eb:	c3                   	ret    
 7ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 7f0:	55                   	push   %ebp
 7f1:	89 e5                	mov    %esp,%ebp
 7f3:	57                   	push   %edi
 7f4:	8b 45 10             	mov    0x10(%ebp),%eax
 7f7:	8b 55 08             	mov    0x8(%ebp),%edx
 7fa:	56                   	push   %esi
 7fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7fe:	85 c0                	test   %eax,%eax
 800:	7e 13                	jle    815 <memmove+0x25>
 802:	01 d0                	add    %edx,%eax
  dst = vdst;
 804:	89 d7                	mov    %edx,%edi
 806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 80d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 810:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 811:	39 f8                	cmp    %edi,%eax
 813:	75 fb                	jne    810 <memmove+0x20>
  return vdst;
}
 815:	5e                   	pop    %esi
 816:	89 d0                	mov    %edx,%eax
 818:	5f                   	pop    %edi
 819:	5d                   	pop    %ebp
 81a:	c3                   	ret    

0000081b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 81b:	b8 01 00 00 00       	mov    $0x1,%eax
 820:	cd 40                	int    $0x40
 822:	c3                   	ret    

00000823 <exit>:
SYSCALL(exit)
 823:	b8 02 00 00 00       	mov    $0x2,%eax
 828:	cd 40                	int    $0x40
 82a:	c3                   	ret    

0000082b <wait>:
SYSCALL(wait)
 82b:	b8 03 00 00 00       	mov    $0x3,%eax
 830:	cd 40                	int    $0x40
 832:	c3                   	ret    

00000833 <pipe>:
SYSCALL(pipe)
 833:	b8 04 00 00 00       	mov    $0x4,%eax
 838:	cd 40                	int    $0x40
 83a:	c3                   	ret    

0000083b <read>:
SYSCALL(read)
 83b:	b8 05 00 00 00       	mov    $0x5,%eax
 840:	cd 40                	int    $0x40
 842:	c3                   	ret    

00000843 <write>:
SYSCALL(write)
 843:	b8 10 00 00 00       	mov    $0x10,%eax
 848:	cd 40                	int    $0x40
 84a:	c3                   	ret    

0000084b <close>:
SYSCALL(close)
 84b:	b8 15 00 00 00       	mov    $0x15,%eax
 850:	cd 40                	int    $0x40
 852:	c3                   	ret    

00000853 <kill>:
SYSCALL(kill)
 853:	b8 06 00 00 00       	mov    $0x6,%eax
 858:	cd 40                	int    $0x40
 85a:	c3                   	ret    

0000085b <exec>:
SYSCALL(exec)
 85b:	b8 07 00 00 00       	mov    $0x7,%eax
 860:	cd 40                	int    $0x40
 862:	c3                   	ret    

00000863 <open>:
SYSCALL(open)
 863:	b8 0f 00 00 00       	mov    $0xf,%eax
 868:	cd 40                	int    $0x40
 86a:	c3                   	ret    

0000086b <mknod>:
SYSCALL(mknod)
 86b:	b8 11 00 00 00       	mov    $0x11,%eax
 870:	cd 40                	int    $0x40
 872:	c3                   	ret    

00000873 <unlink>:
SYSCALL(unlink)
 873:	b8 12 00 00 00       	mov    $0x12,%eax
 878:	cd 40                	int    $0x40
 87a:	c3                   	ret    

0000087b <fstat>:
SYSCALL(fstat)
 87b:	b8 08 00 00 00       	mov    $0x8,%eax
 880:	cd 40                	int    $0x40
 882:	c3                   	ret    

00000883 <link>:
SYSCALL(link)
 883:	b8 13 00 00 00       	mov    $0x13,%eax
 888:	cd 40                	int    $0x40
 88a:	c3                   	ret    

0000088b <mkdir>:
SYSCALL(mkdir)
 88b:	b8 14 00 00 00       	mov    $0x14,%eax
 890:	cd 40                	int    $0x40
 892:	c3                   	ret    

00000893 <chdir>:
SYSCALL(chdir)
 893:	b8 09 00 00 00       	mov    $0x9,%eax
 898:	cd 40                	int    $0x40
 89a:	c3                   	ret    

0000089b <dup>:
SYSCALL(dup)
 89b:	b8 0a 00 00 00       	mov    $0xa,%eax
 8a0:	cd 40                	int    $0x40
 8a2:	c3                   	ret    

000008a3 <getpid>:
SYSCALL(getpid)
 8a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 8a8:	cd 40                	int    $0x40
 8aa:	c3                   	ret    

000008ab <sbrk>:
SYSCALL(sbrk)
 8ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 8b0:	cd 40                	int    $0x40
 8b2:	c3                   	ret    

000008b3 <sleep>:
SYSCALL(sleep)
 8b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 8b8:	cd 40                	int    $0x40
 8ba:	c3                   	ret    

000008bb <uptime>:
SYSCALL(uptime)
 8bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 8c0:	cd 40                	int    $0x40
 8c2:	c3                   	ret    

000008c3 <getrusage>:
SYSCALL(getrusage)
 8c3:	b8 16 00 00 00       	mov    $0x16,%eax
 8c8:	cd 40                	int    $0x40
 8ca:	c3                   	ret    
 8cb:	66 90                	xchg   %ax,%ax
 8cd:	66 90                	xchg   %ax,%ax
 8cf:	90                   	nop

000008d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	57                   	push   %edi
 8d4:	56                   	push   %esi
 8d5:	53                   	push   %ebx
 8d6:	83 ec 3c             	sub    $0x3c,%esp
 8d9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 8dc:	89 d1                	mov    %edx,%ecx
{
 8de:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 8e1:	85 d2                	test   %edx,%edx
 8e3:	0f 89 7f 00 00 00    	jns    968 <printint+0x98>
 8e9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 8ed:	74 79                	je     968 <printint+0x98>
    neg = 1;
 8ef:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 8f6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 8f8:	31 db                	xor    %ebx,%ebx
 8fa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 8fd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 900:	89 c8                	mov    %ecx,%eax
 902:	31 d2                	xor    %edx,%edx
 904:	89 cf                	mov    %ecx,%edi
 906:	f7 75 c4             	divl   -0x3c(%ebp)
 909:	0f b6 92 b4 11 00 00 	movzbl 0x11b4(%edx),%edx
 910:	89 45 c0             	mov    %eax,-0x40(%ebp)
 913:	89 d8                	mov    %ebx,%eax
 915:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 918:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 91b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 91e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 921:	76 dd                	jbe    900 <printint+0x30>
  if(neg)
 923:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 926:	85 c9                	test   %ecx,%ecx
 928:	74 0c                	je     936 <printint+0x66>
    buf[i++] = '-';
 92a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 92f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 931:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 936:	8b 7d b8             	mov    -0x48(%ebp),%edi
 939:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 93d:	eb 07                	jmp    946 <printint+0x76>
 93f:	90                   	nop
    putc(fd, buf[i]);
 940:	0f b6 13             	movzbl (%ebx),%edx
 943:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 946:	83 ec 04             	sub    $0x4,%esp
 949:	88 55 d7             	mov    %dl,-0x29(%ebp)
 94c:	6a 01                	push   $0x1
 94e:	56                   	push   %esi
 94f:	57                   	push   %edi
 950:	e8 ee fe ff ff       	call   843 <write>
  while(--i >= 0)
 955:	83 c4 10             	add    $0x10,%esp
 958:	39 de                	cmp    %ebx,%esi
 95a:	75 e4                	jne    940 <printint+0x70>
}
 95c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 95f:	5b                   	pop    %ebx
 960:	5e                   	pop    %esi
 961:	5f                   	pop    %edi
 962:	5d                   	pop    %ebp
 963:	c3                   	ret    
 964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 968:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 96f:	eb 87                	jmp    8f8 <printint+0x28>
 971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 97f:	90                   	nop

00000980 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	57                   	push   %edi
 984:	56                   	push   %esi
 985:	53                   	push   %ebx
 986:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 989:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 98c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 98f:	0f b6 13             	movzbl (%ebx),%edx
 992:	84 d2                	test   %dl,%dl
 994:	74 6a                	je     a00 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 996:	8d 45 10             	lea    0x10(%ebp),%eax
 999:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 99c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 99f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 9a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 9a4:	eb 36                	jmp    9dc <printf+0x5c>
 9a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9ad:	8d 76 00             	lea    0x0(%esi),%esi
 9b0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 9b3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 9b8:	83 f8 25             	cmp    $0x25,%eax
 9bb:	74 15                	je     9d2 <printf+0x52>
  write(fd, &c, 1);
 9bd:	83 ec 04             	sub    $0x4,%esp
 9c0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 9c3:	6a 01                	push   $0x1
 9c5:	57                   	push   %edi
 9c6:	56                   	push   %esi
 9c7:	e8 77 fe ff ff       	call   843 <write>
 9cc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 9cf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 9d2:	0f b6 13             	movzbl (%ebx),%edx
 9d5:	83 c3 01             	add    $0x1,%ebx
 9d8:	84 d2                	test   %dl,%dl
 9da:	74 24                	je     a00 <printf+0x80>
    c = fmt[i] & 0xff;
 9dc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 9df:	85 c9                	test   %ecx,%ecx
 9e1:	74 cd                	je     9b0 <printf+0x30>
      }
    } else if(state == '%'){
 9e3:	83 f9 25             	cmp    $0x25,%ecx
 9e6:	75 ea                	jne    9d2 <printf+0x52>
      if(c == 'd'){
 9e8:	83 f8 25             	cmp    $0x25,%eax
 9eb:	0f 84 07 01 00 00    	je     af8 <printf+0x178>
 9f1:	83 e8 63             	sub    $0x63,%eax
 9f4:	83 f8 15             	cmp    $0x15,%eax
 9f7:	77 17                	ja     a10 <printf+0x90>
 9f9:	ff 24 85 5c 11 00 00 	jmp    *0x115c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a03:	5b                   	pop    %ebx
 a04:	5e                   	pop    %esi
 a05:	5f                   	pop    %edi
 a06:	5d                   	pop    %ebp
 a07:	c3                   	ret    
 a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a0f:	90                   	nop
  write(fd, &c, 1);
 a10:	83 ec 04             	sub    $0x4,%esp
 a13:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 a16:	6a 01                	push   $0x1
 a18:	57                   	push   %edi
 a19:	56                   	push   %esi
 a1a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 a1e:	e8 20 fe ff ff       	call   843 <write>
        putc(fd, c);
 a23:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 a27:	83 c4 0c             	add    $0xc,%esp
 a2a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 a2d:	6a 01                	push   $0x1
 a2f:	57                   	push   %edi
 a30:	56                   	push   %esi
 a31:	e8 0d fe ff ff       	call   843 <write>
        putc(fd, c);
 a36:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a39:	31 c9                	xor    %ecx,%ecx
 a3b:	eb 95                	jmp    9d2 <printf+0x52>
 a3d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 a40:	83 ec 0c             	sub    $0xc,%esp
 a43:	b9 10 00 00 00       	mov    $0x10,%ecx
 a48:	6a 00                	push   $0x0
 a4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a4d:	8b 10                	mov    (%eax),%edx
 a4f:	89 f0                	mov    %esi,%eax
 a51:	e8 7a fe ff ff       	call   8d0 <printint>
        ap++;
 a56:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 a5a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a5d:	31 c9                	xor    %ecx,%ecx
 a5f:	e9 6e ff ff ff       	jmp    9d2 <printf+0x52>
 a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 a68:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a6b:	8b 10                	mov    (%eax),%edx
        ap++;
 a6d:	83 c0 04             	add    $0x4,%eax
 a70:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 a73:	85 d2                	test   %edx,%edx
 a75:	0f 84 8d 00 00 00    	je     b08 <printf+0x188>
        while(*s != 0){
 a7b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 a7e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 a80:	84 c0                	test   %al,%al
 a82:	0f 84 4a ff ff ff    	je     9d2 <printf+0x52>
 a88:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 a8b:	89 d3                	mov    %edx,%ebx
 a8d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 a90:	83 ec 04             	sub    $0x4,%esp
          s++;
 a93:	83 c3 01             	add    $0x1,%ebx
 a96:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a99:	6a 01                	push   $0x1
 a9b:	57                   	push   %edi
 a9c:	56                   	push   %esi
 a9d:	e8 a1 fd ff ff       	call   843 <write>
        while(*s != 0){
 aa2:	0f b6 03             	movzbl (%ebx),%eax
 aa5:	83 c4 10             	add    $0x10,%esp
 aa8:	84 c0                	test   %al,%al
 aaa:	75 e4                	jne    a90 <printf+0x110>
      state = 0;
 aac:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 aaf:	31 c9                	xor    %ecx,%ecx
 ab1:	e9 1c ff ff ff       	jmp    9d2 <printf+0x52>
 ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 abd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 ac0:	83 ec 0c             	sub    $0xc,%esp
 ac3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 ac8:	6a 01                	push   $0x1
 aca:	e9 7b ff ff ff       	jmp    a4a <printf+0xca>
 acf:	90                   	nop
        putc(fd, *ap);
 ad0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 ad3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 ad6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 ad8:	6a 01                	push   $0x1
 ada:	57                   	push   %edi
 adb:	56                   	push   %esi
        putc(fd, *ap);
 adc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 adf:	e8 5f fd ff ff       	call   843 <write>
        ap++;
 ae4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 ae8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 aeb:	31 c9                	xor    %ecx,%ecx
 aed:	e9 e0 fe ff ff       	jmp    9d2 <printf+0x52>
 af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 af8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 afb:	83 ec 04             	sub    $0x4,%esp
 afe:	e9 2a ff ff ff       	jmp    a2d <printf+0xad>
 b03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b07:	90                   	nop
          s = "(null)";
 b08:	ba 52 11 00 00       	mov    $0x1152,%edx
        while(*s != 0){
 b0d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 b10:	b8 28 00 00 00       	mov    $0x28,%eax
 b15:	89 d3                	mov    %edx,%ebx
 b17:	e9 74 ff ff ff       	jmp    a90 <printf+0x110>
 b1c:	66 90                	xchg   %ax,%ax
 b1e:	66 90                	xchg   %ax,%ax

00000b20 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b20:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b21:	a1 b8 14 00 00       	mov    0x14b8,%eax
{
 b26:	89 e5                	mov    %esp,%ebp
 b28:	57                   	push   %edi
 b29:	56                   	push   %esi
 b2a:	53                   	push   %ebx
 b2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 b2e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b38:	89 c2                	mov    %eax,%edx
 b3a:	8b 00                	mov    (%eax),%eax
 b3c:	39 ca                	cmp    %ecx,%edx
 b3e:	73 30                	jae    b70 <free+0x50>
 b40:	39 c1                	cmp    %eax,%ecx
 b42:	72 04                	jb     b48 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b44:	39 c2                	cmp    %eax,%edx
 b46:	72 f0                	jb     b38 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b48:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b4b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b4e:	39 f8                	cmp    %edi,%eax
 b50:	74 30                	je     b82 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 b52:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 b55:	8b 42 04             	mov    0x4(%edx),%eax
 b58:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 b5b:	39 f1                	cmp    %esi,%ecx
 b5d:	74 3a                	je     b99 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 b5f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 b61:	5b                   	pop    %ebx
  freep = p;
 b62:	89 15 b8 14 00 00    	mov    %edx,0x14b8
}
 b68:	5e                   	pop    %esi
 b69:	5f                   	pop    %edi
 b6a:	5d                   	pop    %ebp
 b6b:	c3                   	ret    
 b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b70:	39 c2                	cmp    %eax,%edx
 b72:	72 c4                	jb     b38 <free+0x18>
 b74:	39 c1                	cmp    %eax,%ecx
 b76:	73 c0                	jae    b38 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 b78:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b7b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b7e:	39 f8                	cmp    %edi,%eax
 b80:	75 d0                	jne    b52 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 b82:	03 70 04             	add    0x4(%eax),%esi
 b85:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b88:	8b 02                	mov    (%edx),%eax
 b8a:	8b 00                	mov    (%eax),%eax
 b8c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 b8f:	8b 42 04             	mov    0x4(%edx),%eax
 b92:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 b95:	39 f1                	cmp    %esi,%ecx
 b97:	75 c6                	jne    b5f <free+0x3f>
    p->s.size += bp->s.size;
 b99:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 b9c:	89 15 b8 14 00 00    	mov    %edx,0x14b8
    p->s.size += bp->s.size;
 ba2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 ba5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 ba8:	89 0a                	mov    %ecx,(%edx)
}
 baa:	5b                   	pop    %ebx
 bab:	5e                   	pop    %esi
 bac:	5f                   	pop    %edi
 bad:	5d                   	pop    %ebp
 bae:	c3                   	ret    
 baf:	90                   	nop

00000bb0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bb0:	55                   	push   %ebp
 bb1:	89 e5                	mov    %esp,%ebp
 bb3:	57                   	push   %edi
 bb4:	56                   	push   %esi
 bb5:	53                   	push   %ebx
 bb6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 bbc:	8b 3d b8 14 00 00    	mov    0x14b8,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bc2:	8d 70 07             	lea    0x7(%eax),%esi
 bc5:	c1 ee 03             	shr    $0x3,%esi
 bc8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 bcb:	85 ff                	test   %edi,%edi
 bcd:	0f 84 9d 00 00 00    	je     c70 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 bd5:	8b 4a 04             	mov    0x4(%edx),%ecx
 bd8:	39 f1                	cmp    %esi,%ecx
 bda:	73 6a                	jae    c46 <malloc+0x96>
 bdc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 be1:	39 de                	cmp    %ebx,%esi
 be3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 be6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 bed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 bf0:	eb 17                	jmp    c09 <malloc+0x59>
 bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bf8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 bfa:	8b 48 04             	mov    0x4(%eax),%ecx
 bfd:	39 f1                	cmp    %esi,%ecx
 bff:	73 4f                	jae    c50 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c01:	8b 3d b8 14 00 00    	mov    0x14b8,%edi
 c07:	89 c2                	mov    %eax,%edx
 c09:	39 d7                	cmp    %edx,%edi
 c0b:	75 eb                	jne    bf8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 c0d:	83 ec 0c             	sub    $0xc,%esp
 c10:	ff 75 e4             	push   -0x1c(%ebp)
 c13:	e8 93 fc ff ff       	call   8ab <sbrk>
  if(p == (char*)-1)
 c18:	83 c4 10             	add    $0x10,%esp
 c1b:	83 f8 ff             	cmp    $0xffffffff,%eax
 c1e:	74 1c                	je     c3c <malloc+0x8c>
  hp->s.size = nu;
 c20:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 c23:	83 ec 0c             	sub    $0xc,%esp
 c26:	83 c0 08             	add    $0x8,%eax
 c29:	50                   	push   %eax
 c2a:	e8 f1 fe ff ff       	call   b20 <free>
  return freep;
 c2f:	8b 15 b8 14 00 00    	mov    0x14b8,%edx
      if((p = morecore(nunits)) == 0)
 c35:	83 c4 10             	add    $0x10,%esp
 c38:	85 d2                	test   %edx,%edx
 c3a:	75 bc                	jne    bf8 <malloc+0x48>
        return 0;
  }
}
 c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 c3f:	31 c0                	xor    %eax,%eax
}
 c41:	5b                   	pop    %ebx
 c42:	5e                   	pop    %esi
 c43:	5f                   	pop    %edi
 c44:	5d                   	pop    %ebp
 c45:	c3                   	ret    
    if(p->s.size >= nunits){
 c46:	89 d0                	mov    %edx,%eax
 c48:	89 fa                	mov    %edi,%edx
 c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 c50:	39 ce                	cmp    %ecx,%esi
 c52:	74 4c                	je     ca0 <malloc+0xf0>
        p->s.size -= nunits;
 c54:	29 f1                	sub    %esi,%ecx
 c56:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 c59:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 c5c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 c5f:	89 15 b8 14 00 00    	mov    %edx,0x14b8
}
 c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 c68:	83 c0 08             	add    $0x8,%eax
}
 c6b:	5b                   	pop    %ebx
 c6c:	5e                   	pop    %esi
 c6d:	5f                   	pop    %edi
 c6e:	5d                   	pop    %ebp
 c6f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 c70:	c7 05 b8 14 00 00 bc 	movl   $0x14bc,0x14b8
 c77:	14 00 00 
    base.s.size = 0;
 c7a:	bf bc 14 00 00       	mov    $0x14bc,%edi
    base.s.ptr = freep = prevp = &base;
 c7f:	c7 05 bc 14 00 00 bc 	movl   $0x14bc,0x14bc
 c86:	14 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c89:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 c8b:	c7 05 c0 14 00 00 00 	movl   $0x0,0x14c0
 c92:	00 00 00 
    if(p->s.size >= nunits){
 c95:	e9 42 ff ff ff       	jmp    bdc <malloc+0x2c>
 c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 ca0:	8b 08                	mov    (%eax),%ecx
 ca2:	89 0a                	mov    %ecx,(%edx)
 ca4:	eb b9                	jmp    c5f <malloc+0xaf>
