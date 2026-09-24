
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 58 11 80       	mov    $0x801158d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 72 10 80       	push   $0x801072a0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 b5 43 00 00       	call   80104410 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 72 10 80       	push   $0x801072a7
80100097:	50                   	push   %eax
80100098:	e8 43 42 00 00       	call   801042e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 f7 44 00 00       	call   801045e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 19 44 00 00       	call   80104580 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 41 00 00       	call   80104320 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 72 10 80       	push   $0x801072ae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 fd 41 00 00       	call   801043c0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 72 10 80       	push   $0x801072bf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 41 00 00       	call   801043c0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 41 00 00       	call   80104380 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 c0 43 00 00       	call   801045e0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 0f 43 00 00       	jmp    80104580 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 72 10 80       	push   $0x801072c6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 3b 43 00 00       	call   801045e0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 9e 3d 00 00       	call   80104070 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 36 00 00       	call   80103990 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 85 42 00 00       	call   80104580 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 2f 42 00 00       	call   80104580 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 72 10 80       	push   $0x801072cd
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 fb 7b 10 80 	movl   $0x80107bfb,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 63 40 00 00       	call   80104430 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 72 10 80       	push   $0x801072e1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 91 59 00 00       	call   80105db0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 a6 58 00 00       	call   80105db0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 9a 58 00 00       	call   80105db0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 8e 58 00 00       	call   80105db0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 ea 41 00 00       	call   80104740 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 35 41 00 00       	call   801046a0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 e5 72 10 80       	push   $0x801072e5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005ab:	e8 30 40 00 00       	call   801045e0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ef 10 80       	push   $0x8010ef20
801005e4:	e8 97 3f 00 00       	call   80104580 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 10 73 10 80 	movzbl -0x7fef8cf0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ef 10 80       	push   $0x8010ef20
801007e8:	e8 f3 3d 00 00       	call   801045e0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf f8 72 10 80       	mov    $0x801072f8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ef 10 80       	push   $0x8010ef20
8010085b:	e8 20 3d 00 00       	call   80104580 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 ff 72 10 80       	push   $0x801072ff
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ef 10 80       	push   $0x8010ef20
80100893:	e8 48 3d 00 00       	call   801045e0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100945:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010096c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100985:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100999:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b7:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ef 10 80       	push   $0x8010ef20
801009d0:	e8 ab 3b 00 00       	call   80104580 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 0d 38 00 00       	jmp    80104220 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a3f:	68 00 ef 10 80       	push   $0x8010ef00
80100a44:	e8 f7 36 00 00       	call   80104140 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 08 73 10 80       	push   $0x80107308
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 9b 39 00 00       	call   80104410 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 90 	movl   $0x80100590,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 cf 2e 00 00       	call   80103990 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 07 64 00 00       	call   80106f40 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 b8 61 00 00       	call   80106d60 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 92 60 00 00       	call   80106c70 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 a0 62 00 00       	call   80106ec0 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 f9 60 00 00       	call   80106d60 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 58 63 00 00       	call   80106fe0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 c8 3b 00 00       	call   801048a0 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 b4 3b 00 00       	call   801048a0 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 b3 64 00 00       	call   801071b0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 aa 61 00 00       	call   80106ec0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 48 64 00 00       	call   801071b0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 ba 3a 00 00       	call   80104860 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 0e 5d 00 00       	call   80106ae0 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 e6 60 00 00       	call   80106ec0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 21 73 10 80       	push   $0x80107321
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 2d 73 10 80       	push   $0x8010732d
80100e1b:	68 60 ef 10 80       	push   $0x8010ef60
80100e20:	e8 eb 35 00 00       	call   80104410 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ef 10 80       	push   $0x8010ef60
80100e41:	e8 9a 37 00 00       	call   801045e0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ef 10 80       	push   $0x8010ef60
80100e71:	e8 0a 37 00 00       	call   80104580 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ef 10 80       	push   $0x8010ef60
80100e8a:	e8 f1 36 00 00       	call   80104580 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ef 10 80       	push   $0x8010ef60
80100eaf:	e8 2c 37 00 00       	call   801045e0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ef 10 80       	push   $0x8010ef60
80100ecc:	e8 af 36 00 00       	call   80104580 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 34 73 10 80       	push   $0x80107334
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ef 10 80       	push   $0x8010ef60
80100f01:	e8 da 36 00 00       	call   801045e0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 3f 36 00 00       	call   80104580 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 0d 36 00 00       	jmp    80104580 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 3c 73 10 80       	push   $0x8010733c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 46 73 10 80       	push   $0x80107346
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 4f 73 10 80       	push   $0x8010734f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 55 73 10 80       	push   $0x80107355
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 5f 73 10 80       	push   $0x8010735f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 72 73 10 80       	push   $0x80107372
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 76 33 00 00       	call   801046a0 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 f9 10 80       	push   $0x8010f960
8010136a:	e8 71 32 00 00       	call   801045e0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 f9 10 80       	push   $0x8010f960
801013d7:	e8 a4 31 00 00       	call   80104580 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 76 31 00 00       	call   80104580 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 88 73 10 80       	push   $0x80107388
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 98 73 10 80       	push   $0x80107398
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 fa 31 00 00       	call   80104740 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 ab 73 10 80       	push   $0x801073ab
80101571:	68 60 f9 10 80       	push   $0x8010f960
80101576:	e8 95 2e 00 00       	call   80104410 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 b2 73 10 80       	push   $0x801073b2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 4c 2d 00 00       	call   801042e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 15 11 80       	push   $0x801115b4
801015bc:	e8 7f 31 00 00       	call   80104740 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 15 11 80    	push   0x801115cc
801015cf:	ff 35 c8 15 11 80    	push   0x801115c8
801015d5:	ff 35 c4 15 11 80    	push   0x801115c4
801015db:	ff 35 c0 15 11 80    	push   0x801115c0
801015e1:	ff 35 bc 15 11 80    	push   0x801115bc
801015e7:	ff 35 b8 15 11 80    	push   0x801115b8
801015ed:	ff 35 b4 15 11 80    	push   0x801115b4
801015f3:	68 18 74 10 80       	push   $0x80107418
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 0d 30 00 00       	call   801046a0 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 b8 73 10 80       	push   $0x801073b8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 0a 30 00 00       	call   80104740 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 f9 10 80       	push   $0x8010f960
8010175f:	e8 7c 2e 00 00       	call   801045e0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010176f:	e8 0c 2e 00 00       	call   80104580 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 79 2b 00 00       	call   80104320 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 23 2f 00 00       	call   80104740 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 d0 73 10 80       	push   $0x801073d0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 ca 73 10 80       	push   $0x801073ca
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 48 2b 00 00       	call   801043c0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 ec 2a 00 00       	jmp    80104380 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 df 73 10 80       	push   $0x801073df
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 5b 2a 00 00       	call   80104320 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 a1 2a 00 00       	call   80104380 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801018e6:	e8 f5 2c 00 00       	call   801045e0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 7b 2c 00 00       	jmp    80104580 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 f9 10 80       	push   $0x8010f960
80101910:	e8 cb 2c 00 00       	call   801045e0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010191f:	e8 5c 2c 00 00       	call   80104580 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 98 29 00 00       	call   801043c0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 41 29 00 00       	call   80104380 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 df 73 10 80       	push   $0x801073df
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 04 2c 00 00       	call   80104740 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 08 2b 00 00       	call   80104740 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 dd 2a 00 00       	call   801047b0 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 7e 2a 00 00       	call   801047b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 f9 73 10 80       	push   $0x801073f9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 e7 73 10 80       	push   $0x801073e7
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 e1 1b 00 00       	call   80103990 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 f9 10 80       	push   $0x8010f960
80101dba:	e8 21 28 00 00       	call   801045e0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dca:	e8 b1 27 00 00       	call   80104580 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 14 29 00 00       	call   80104740 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 2f 25 00 00       	call   801043c0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 cd 24 00 00       	call   80104380 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 60 28 00 00       	call   80104740 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 90 24 00 00       	call   801043c0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 31 24 00 00       	call   80104380 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 4e 24 00 00       	call   801043c0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 2b 24 00 00       	call   801043c0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 d4 23 00 00       	call   80104380 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 df 73 10 80       	push   $0x801073df
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 be 27 00 00       	call   80104800 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 08 74 10 80       	push   $0x80107408
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 e2 79 10 80       	push   $0x801079e2
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 74 74 10 80       	push   $0x80107474
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 6b 74 10 80       	push   $0x8010746b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 86 74 10 80       	push   $0x80107486
801021cb:	68 00 16 11 80       	push   $0x80111600
801021d0:	e8 3b 22 00 00       	call   80104410 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 16 11 80       	push   $0x80111600
8010224e:	e8 8d 23 00 00       	call   801045e0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 8e 1e 00 00       	call   80104140 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 16 11 80       	push   $0x80111600
801022cb:	e8 b0 22 00 00       	call   80104580 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 cd 20 00 00       	call   801043c0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 16 11 80       	push   $0x80111600
80102328:	e8 b3 22 00 00       	call   801045e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 16 11 80       	push   $0x80111600
80102368:	53                   	push   %ebx
80102369:	e8 02 1d 00 00       	call   80104070 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 f5 21 00 00       	jmp    80104580 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 b5 74 10 80       	push   $0x801074b5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 a0 74 10 80       	push   $0x801074a0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 8a 74 10 80       	push   $0x8010748a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 d4 74 10 80       	push   $0x801074d4
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb d0 58 11 80    	cmp    $0x801158d0,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 a9 21 00 00       	call   801046a0 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 16 11 80       	mov    0x80111678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 16 11 80       	push   $0x80111640
80102528:	e8 b3 20 00 00       	call   801045e0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 38 20 00 00       	jmp    80104580 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 06 75 10 80       	push   $0x80107506
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 0c 75 10 80       	push   $0x8010750c
80102620:	68 40 16 11 80       	push   $0x80111640
80102625:	e8 e6 1d 00 00       	call   80104410 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 16 11 80       	mov    0x80111674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 16 11 80       	push   $0x80111640
801026b3:	e8 28 1f 00 00       	call   801045e0 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 16 11 80       	push   $0x80111640
801026e1:	e8 9a 1e 00 00       	call   80104580 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 40 76 10 80 	movzbl -0x7fef89c0(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 40 75 10 80 	movzbl -0x7fef8ac0(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 20 75 10 80 	mov    -0x7fef8ae0(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 40 76 10 80 	movzbl -0x7fef89c0(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 80 16 11 80       	mov    0x80111680,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 f4 1b 00 00       	call   801046f0 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 16 11 80    	push   0x801116e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102c04:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 17 1b 00 00       	call   80104740 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 d4 16 11 80    	push   0x801116d4
80102c6d:	ff 35 e4 16 11 80    	push   0x801116e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 40 77 10 80       	push   $0x80107740
80102ccf:	68 a0 16 11 80       	push   $0x801116a0
80102cd4:	e8 37 17 00 00       	call   80104410 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 a0 16 11 80       	push   $0x801116a0
80102d6b:	e8 70 18 00 00       	call   801045e0 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 16 11 80       	push   $0x801116a0
80102d80:	68 a0 16 11 80       	push   $0x801116a0
80102d85:	e8 e6 12 00 00       	call   80104070 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102d9b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102db7:	68 a0 16 11 80       	push   $0x801116a0
80102dbc:	e8 bf 17 00 00       	call   80104580 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 a0 16 11 80       	push   $0x801116a0
80102dde:	e8 fd 17 00 00       	call   801045e0 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 16 11 80       	push   $0x801116a0
80102e1c:	e8 5f 17 00 00       	call   80104580 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 16 11 80       	push   $0x801116a0
80102e36:	e8 a5 17 00 00       	call   801045e0 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 ef 12 00 00       	call   80104140 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e58:	e8 23 17 00 00       	call   80104580 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102e94:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 87 18 00 00       	call   80104740 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 16 11 80       	push   $0x801116a0
80102f08:	e8 33 12 00 00       	call   80104140 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f14:	e8 67 16 00 00       	call   80104580 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 44 77 10 80       	push   $0x80107744
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 16 11 80       	push   $0x801116a0
80102f76:	e8 65 16 00 00       	call   801045e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 c6 15 00 00       	jmp    80104580 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 53 77 10 80       	push   $0x80107753
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 69 77 10 80       	push   $0x80107769
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 64 09 00 00       	call   80103970 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 5d 09 00 00       	call   80103970 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 84 77 10 80       	push   $0x80107784
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 79 29 00 00       	call   801059a0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 e4 08 00 00       	call   80103910 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 11 0c 00 00       	call   80103c50 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 85 3a 00 00       	call   80106ad0 <switchkvm>
  seginit();
8010304b:	e8 f0 39 00 00       	call   80106a40 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 d0 58 11 80       	push   $0x801158d0
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 3a 3f 00 00       	call   80106fc0 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 ab 39 00 00       	call   80106a40 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 27 2c 00 00       	call   80105cd0 <uartinit>
  pinit();         // process table
801030a9:	e8 42 08 00 00       	call   801038f0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 6d 28 00 00       	call   80105920 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 8c a4 10 80       	push   $0x8010a48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 67 16 00 00       	call   80104740 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030eb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 f2 07 00 00       	call   80103910 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010313b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 39 08 00 00       	call   801039c0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 98 77 10 80       	push   $0x80107798
801031c3:	56                   	push   %esi
801031c4:	e8 27 15 00 00       	call   801046f0 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 9d 77 10 80       	push   $0x8010779d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 6c 14 00 00       	call   801046f0 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 a2 77 10 80       	push   $0x801077a2
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 98 77 10 80       	push   $0x80107798
801033c7:	53                   	push   %ebx
801033c8:	e8 23 13 00 00       	call   801046f0 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 bc 77 10 80       	push   $0x801077bc
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 db 77 10 80       	push   $0x801077db
801034a8:	50                   	push   %eax
801034a9:	e8 62 0f 00 00       	call   80104410 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 9c 10 00 00       	call   801045e0 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 dc 0b 00 00       	call   80104140 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 f7 0f 00 00       	jmp    80104580 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 e7 0f 00 00       	call   80104580 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 77 0b 00 00       	call   80104140 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 fe 0f 00 00       	call   801045e0 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 63 03 00 00       	call   80103990 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 03 0b 00 00       	call   80104140 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 2a 0a 00 00       	call   80104070 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 0f 0f 00 00       	call   80104580 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 81 0a 00 00       	call   80104140 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 b9 0e 00 00       	call   80104580 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 f5 0e 00 00       	call   801045e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 8b 02 00 00       	call   80103990 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 56 09 00 00       	call   80104070 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 c5 09 00 00       	call   80104140 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 fd 0d 00 00       	call   80104580 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 e2 0d 00 00       	call   80104580 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 20 1d 11 80       	push   $0x80111d20
801037c1:	e8 1a 0e 00 00       	call   801045e0 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801037d6:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
801037dc:	0f 84 86 00 00 00    	je     80103868 <allocproc+0xb8>
    if(p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  memset(&p->rusage, 0, sizeof(p->rusage)); // Initialize `struct rusage`
801037ee:	83 ec 04             	sub    $0x4,%esp
  p->state = EMBRYO;
801037f1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037f8:	89 43 10             	mov    %eax,0x10(%ebx)
801037fb:	8d 50 01             	lea    0x1(%eax),%edx
  memset(&p->rusage, 0, sizeof(p->rusage)); // Initialize `struct rusage`
801037fe:	8d 43 7c             	lea    0x7c(%ebx),%eax
80103801:	6a 10                	push   $0x10
80103803:	6a 00                	push   $0x0
80103805:	50                   	push   %eax
  p->pid = nextpid++;
80103806:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  memset(&p->rusage, 0, sizeof(p->rusage)); // Initialize `struct rusage`
8010380c:	e8 8f 0e 00 00       	call   801046a0 <memset>

  release(&ptable.lock);
80103811:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103818:	e8 63 0d 00 00       	call   80104580 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010381d:	e8 5e ee ff ff       	call   80102680 <kalloc>
80103822:	83 c4 10             	add    $0x10,%esp
80103825:	89 43 08             	mov    %eax,0x8(%ebx)
80103828:	85 c0                	test   %eax,%eax
8010382a:	74 55                	je     80103881 <allocproc+0xd1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010382c:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103832:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103835:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010383a:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010383d:	c7 40 14 07 59 10 80 	movl   $0x80105907,0x14(%eax)
  p->context = (struct context*)sp;
80103844:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103847:	6a 14                	push   $0x14
80103849:	6a 00                	push   $0x0
8010384b:	50                   	push   %eax
8010384c:	e8 4f 0e 00 00       	call   801046a0 <memset>
  p->context->eip = (uint)forkret;
80103851:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103854:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103857:	c7 40 10 a0 38 10 80 	movl   $0x801038a0,0x10(%eax)
}
8010385e:	89 d8                	mov    %ebx,%eax
80103860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103863:	c9                   	leave  
80103864:	c3                   	ret    
80103865:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103868:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010386b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010386d:	68 20 1d 11 80       	push   $0x80111d20
80103872:	e8 09 0d 00 00       	call   80104580 <release>
}
80103877:	89 d8                	mov    %ebx,%eax
  return 0;
80103879:	83 c4 10             	add    $0x10,%esp
}
8010387c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010387f:	c9                   	leave  
80103880:	c3                   	ret    
    p->state = UNUSED;
80103881:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103888:	31 db                	xor    %ebx,%ebx
}
8010388a:	89 d8                	mov    %ebx,%eax
8010388c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010388f:	c9                   	leave  
80103890:	c3                   	ret    
80103891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010389f:	90                   	nop

801038a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038a6:	68 20 1d 11 80       	push   $0x80111d20
801038ab:	e8 d0 0c 00 00       	call   80104580 <release>

  if (first) {
801038b0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	85 c0                	test   %eax,%eax
801038ba:	75 04                	jne    801038c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038bc:	c9                   	leave  
801038bd:	c3                   	ret    
801038be:	66 90                	xchg   %ax,%ax
    first = 0;
801038c0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038c7:	00 00 00 
    iinit(ROOTDEV);
801038ca:	83 ec 0c             	sub    $0xc,%esp
801038cd:	6a 01                	push   $0x1
801038cf:	e8 8c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038db:	e8 e0 f3 ff ff       	call   80102cc0 <initlog>
}
801038e0:	83 c4 10             	add    $0x10,%esp
801038e3:	c9                   	leave  
801038e4:	c3                   	ret    
801038e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038f0 <pinit>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038f6:	68 e0 77 10 80       	push   $0x801077e0
801038fb:	68 20 1d 11 80       	push   $0x80111d20
80103900:	e8 0b 0b 00 00       	call   80104410 <initlock>
}
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	c9                   	leave  
80103909:	c3                   	ret    
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103910 <mycpu>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103915:	9c                   	pushf  
80103916:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103917:	f6 c4 02             	test   $0x2,%ah
8010391a:	75 46                	jne    80103962 <mycpu+0x52>
  apicid = lapicid();
8010391c:	e8 cf ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103921:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103927:	85 f6                	test   %esi,%esi
80103929:	7e 2a                	jle    80103955 <mycpu+0x45>
8010392b:	31 d2                	xor    %edx,%edx
8010392d:	eb 08                	jmp    80103937 <mycpu+0x27>
8010392f:	90                   	nop
80103930:	83 c2 01             	add    $0x1,%edx
80103933:	39 f2                	cmp    %esi,%edx
80103935:	74 1e                	je     80103955 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103937:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010393d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103944:	39 c3                	cmp    %eax,%ebx
80103946:	75 e8                	jne    80103930 <mycpu+0x20>
}
80103948:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010394b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103951:	5b                   	pop    %ebx
80103952:	5e                   	pop    %esi
80103953:	5d                   	pop    %ebp
80103954:	c3                   	ret    
  panic("unknown apicid\n");
80103955:	83 ec 0c             	sub    $0xc,%esp
80103958:	68 e7 77 10 80       	push   $0x801077e7
8010395d:	e8 1e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	68 c4 78 10 80       	push   $0x801078c4
8010396a:	e8 11 ca ff ff       	call   80100380 <panic>
8010396f:	90                   	nop

80103970 <cpuid>:
cpuid() {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103976:	e8 95 ff ff ff       	call   80103910 <mycpu>
}
8010397b:	c9                   	leave  
  return mycpu()-cpus;
8010397c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103981:	c1 f8 04             	sar    $0x4,%eax
80103984:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010398a:	c3                   	ret    
8010398b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010398f:	90                   	nop

80103990 <myproc>:
myproc(void) {
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
80103994:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103997:	e8 f4 0a 00 00       	call   80104490 <pushcli>
  c = mycpu();
8010399c:	e8 6f ff ff ff       	call   80103910 <mycpu>
  p = c->proc;
801039a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039a7:	e8 34 0b 00 00       	call   801044e0 <popcli>
}
801039ac:	89 d8                	mov    %ebx,%eax
801039ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039b1:	c9                   	leave  
801039b2:	c3                   	ret    
801039b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039c0 <userinit>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	53                   	push   %ebx
801039c4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039c7:	e8 e4 fd ff ff       	call   801037b0 <allocproc>
801039cc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ce:	a3 54 40 11 80       	mov    %eax,0x80114054
  if((p->pgdir = setupkvm()) == 0)
801039d3:	e8 68 35 00 00       	call   80106f40 <setupkvm>
801039d8:	89 43 04             	mov    %eax,0x4(%ebx)
801039db:	85 c0                	test   %eax,%eax
801039dd:	0f 84 bd 00 00 00    	je     80103aa0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039e3:	83 ec 04             	sub    $0x4,%esp
801039e6:	68 2c 00 00 00       	push   $0x2c
801039eb:	68 60 a4 10 80       	push   $0x8010a460
801039f0:	50                   	push   %eax
801039f1:	e8 fa 31 00 00       	call   80106bf0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039f6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039f9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ff:	6a 4c                	push   $0x4c
80103a01:	6a 00                	push   $0x0
80103a03:	ff 73 18             	push   0x18(%ebx)
80103a06:	e8 95 0c 00 00       	call   801046a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a13:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a16:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a26:	8b 43 18             	mov    0x18(%ebx),%eax
80103a29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a31:	8b 43 18             	mov    0x18(%ebx),%eax
80103a34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a46:	8b 43 18             	mov    0x18(%ebx),%eax
80103a49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a50:	8b 43 18             	mov    0x18(%ebx),%eax
80103a53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a5d:	6a 10                	push   $0x10
80103a5f:	68 10 78 10 80       	push   $0x80107810
80103a64:	50                   	push   %eax
80103a65:	e8 f6 0d 00 00       	call   80104860 <safestrcpy>
  p->cwd = namei("/");
80103a6a:	c7 04 24 19 78 10 80 	movl   $0x80107819,(%esp)
80103a71:	e8 2a e6 ff ff       	call   801020a0 <namei>
80103a76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a79:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a80:	e8 5b 0b 00 00       	call   801045e0 <acquire>
  p->state = RUNNABLE;
80103a85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a8c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a93:	e8 e8 0a 00 00       	call   80104580 <release>
}
80103a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a9b:	83 c4 10             	add    $0x10,%esp
80103a9e:	c9                   	leave  
80103a9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 f7 77 10 80       	push   $0x801077f7
80103aa8:	e8 d3 c8 ff ff       	call   80100380 <panic>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi

80103ab0 <growproc>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
80103ab5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ab8:	e8 d3 09 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103abd:	e8 4e fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ac2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac8:	e8 13 0a 00 00       	call   801044e0 <popcli>
  sz = curproc->sz;
80103acd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103acf:	85 f6                	test   %esi,%esi
80103ad1:	7f 1d                	jg     80103af0 <growproc+0x40>
  } else if(n < 0){
80103ad3:	75 3b                	jne    80103b10 <growproc+0x60>
  switchuvm(curproc);
80103ad5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ad8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ada:	53                   	push   %ebx
80103adb:	e8 00 30 00 00       	call   80106ae0 <switchuvm>
  return 0;
80103ae0:	83 c4 10             	add    $0x10,%esp
80103ae3:	31 c0                	xor    %eax,%eax
}
80103ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae8:	5b                   	pop    %ebx
80103ae9:	5e                   	pop    %esi
80103aea:	5d                   	pop    %ebp
80103aeb:	c3                   	ret    
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	push   0x4(%ebx)
80103afa:	e8 61 32 00 00       	call   80106d60 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 cf                	jne    80103ad5 <growproc+0x25>
      return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b0b:	eb d8                	jmp    80103ae5 <growproc+0x35>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	push   0x4(%ebx)
80103b1a:	e8 71 33 00 00       	call   80106e90 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 af                	jne    80103ad5 <growproc+0x25>
80103b26:	eb de                	jmp    80103b06 <growproc+0x56>
80103b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <fork>:
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	57                   	push   %edi
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b39:	e8 52 09 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103b3e:	e8 cd fd ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103b43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b49:	e8 92 09 00 00       	call   801044e0 <popcli>
  if((np = allocproc()) == 0){
80103b4e:	e8 5d fc ff ff       	call   801037b0 <allocproc>
80103b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b56:	85 c0                	test   %eax,%eax
80103b58:	0f 84 b7 00 00 00    	je     80103c15 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b5e:	83 ec 08             	sub    $0x8,%esp
80103b61:	ff 33                	push   (%ebx)
80103b63:	89 c7                	mov    %eax,%edi
80103b65:	ff 73 04             	push   0x4(%ebx)
80103b68:	e8 c3 34 00 00       	call   80107030 <copyuvm>
80103b6d:	83 c4 10             	add    $0x10,%esp
80103b70:	89 47 04             	mov    %eax,0x4(%edi)
80103b73:	85 c0                	test   %eax,%eax
80103b75:	0f 84 a1 00 00 00    	je     80103c1c <fork+0xec>
  np->sz = curproc->sz;
80103b7b:	8b 03                	mov    (%ebx),%eax
80103b7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b80:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b82:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b85:	89 c8                	mov    %ecx,%eax
80103b87:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b8a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b8f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b94:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b96:	8b 40 18             	mov    0x18(%eax),%eax
80103b99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ba0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	74 13                	je     80103bbb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	50                   	push   %eax
80103bac:	e8 ef d2 ff ff       	call   80100ea0 <filedup>
80103bb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bb4:	83 c4 10             	add    $0x10,%esp
80103bb7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bbb:	83 c6 01             	add    $0x1,%esi
80103bbe:	83 fe 10             	cmp    $0x10,%esi
80103bc1:	75 dd                	jne    80103ba0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bc3:	83 ec 0c             	sub    $0xc,%esp
80103bc6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bcc:	e8 7f db ff ff       	call   80101750 <idup>
80103bd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bd7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bda:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bdd:	6a 10                	push   $0x10
80103bdf:	53                   	push   %ebx
80103be0:	50                   	push   %eax
80103be1:	e8 7a 0c 00 00       	call   80104860 <safestrcpy>
  pid = np->pid;
80103be6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103be9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bf0:	e8 eb 09 00 00       	call   801045e0 <acquire>
  np->state = RUNNABLE;
80103bf5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bfc:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c03:	e8 78 09 00 00       	call   80104580 <release>
  return pid;
80103c08:	83 c4 10             	add    $0x10,%esp
}
80103c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c0e:	89 d8                	mov    %ebx,%eax
80103c10:	5b                   	pop    %ebx
80103c11:	5e                   	pop    %esi
80103c12:	5f                   	pop    %edi
80103c13:	5d                   	pop    %ebp
80103c14:	c3                   	ret    
    return -1;
80103c15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c1a:	eb ef                	jmp    80103c0b <fork+0xdb>
    kfree(np->kstack);
80103c1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c1f:	83 ec 0c             	sub    $0xc,%esp
80103c22:	ff 73 08             	push   0x8(%ebx)
80103c25:	e8 96 e8 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103c2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c31:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c34:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c40:	eb c9                	jmp    80103c0b <fork+0xdb>
80103c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c50 <scheduler>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c59:	e8 b2 fc ff ff       	call   80103910 <mycpu>
  c->proc = 0;
80103c5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c65:	00 00 00 
  struct cpu *c = mycpu();
80103c68:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c6a:	8d 78 04             	lea    0x4(%eax),%edi
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c70:	fb                   	sti    
    acquire(&ptable.lock);
80103c71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c74:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103c79:	68 20 1d 11 80       	push   $0x80111d20
80103c7e:	e8 5d 09 00 00       	call   801045e0 <acquire>
80103c83:	83 c4 10             	add    $0x10,%esp
80103c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103c90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c94:	75 33                	jne    80103cc9 <scheduler+0x79>
      switchuvm(p);
80103c96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c9f:	53                   	push   %ebx
80103ca0:	e8 3b 2e 00 00       	call   80106ae0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ca5:	58                   	pop    %eax
80103ca6:	5a                   	pop    %edx
80103ca7:	ff 73 1c             	push   0x1c(%ebx)
80103caa:	57                   	push   %edi
      p->state = RUNNING;
80103cab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103cb2:	e8 04 0c 00 00       	call   801048bb <swtch>
      switchkvm();
80103cb7:	e8 14 2e 00 00       	call   80106ad0 <switchkvm>
      c->proc = 0;
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc9:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103ccf:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
80103cd5:	75 b9                	jne    80103c90 <scheduler+0x40>
    release(&ptable.lock);
80103cd7:	83 ec 0c             	sub    $0xc,%esp
80103cda:	68 20 1d 11 80       	push   $0x80111d20
80103cdf:	e8 9c 08 00 00       	call   80104580 <release>
    sti();
80103ce4:	83 c4 10             	add    $0x10,%esp
80103ce7:	eb 87                	jmp    80103c70 <scheduler+0x20>
80103ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cf0 <sched>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	56                   	push   %esi
80103cf4:	53                   	push   %ebx
  pushcli();
80103cf5:	e8 96 07 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103cfa:	e8 11 fc ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103cff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d05:	e8 d6 07 00 00       	call   801044e0 <popcli>
  if(!holding(&ptable.lock))
80103d0a:	83 ec 0c             	sub    $0xc,%esp
80103d0d:	68 20 1d 11 80       	push   $0x80111d20
80103d12:	e8 29 08 00 00       	call   80104540 <holding>
80103d17:	83 c4 10             	add    $0x10,%esp
80103d1a:	85 c0                	test   %eax,%eax
80103d1c:	74 4f                	je     80103d6d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d1e:	e8 ed fb ff ff       	call   80103910 <mycpu>
80103d23:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d2a:	75 68                	jne    80103d94 <sched+0xa4>
  if(p->state == RUNNING)
80103d2c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d30:	74 55                	je     80103d87 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d32:	9c                   	pushf  
80103d33:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d34:	f6 c4 02             	test   $0x2,%ah
80103d37:	75 41                	jne    80103d7a <sched+0x8a>
  intena = mycpu()->intena;
80103d39:	e8 d2 fb ff ff       	call   80103910 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d3e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d47:	e8 c4 fb ff ff       	call   80103910 <mycpu>
80103d4c:	83 ec 08             	sub    $0x8,%esp
80103d4f:	ff 70 04             	push   0x4(%eax)
80103d52:	53                   	push   %ebx
80103d53:	e8 63 0b 00 00       	call   801048bb <swtch>
  mycpu()->intena = intena;
80103d58:	e8 b3 fb ff ff       	call   80103910 <mycpu>
}
80103d5d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d60:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d69:	5b                   	pop    %ebx
80103d6a:	5e                   	pop    %esi
80103d6b:	5d                   	pop    %ebp
80103d6c:	c3                   	ret    
    panic("sched ptable.lock");
80103d6d:	83 ec 0c             	sub    $0xc,%esp
80103d70:	68 1b 78 10 80       	push   $0x8010781b
80103d75:	e8 06 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d7a:	83 ec 0c             	sub    $0xc,%esp
80103d7d:	68 47 78 10 80       	push   $0x80107847
80103d82:	e8 f9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d87:	83 ec 0c             	sub    $0xc,%esp
80103d8a:	68 39 78 10 80       	push   $0x80107839
80103d8f:	e8 ec c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	68 2d 78 10 80       	push   $0x8010782d
80103d9c:	e8 df c5 ff ff       	call   80100380 <panic>
80103da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop

80103db0 <exit>:
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103db9:	e8 d2 fb ff ff       	call   80103990 <myproc>
  if(curproc == initproc)
80103dbe:	39 05 54 40 11 80    	cmp    %eax,0x80114054
80103dc4:	0f 84 07 01 00 00    	je     80103ed1 <exit+0x121>
80103dca:	89 c3                	mov    %eax,%ebx
80103dcc:	8d 70 28             	lea    0x28(%eax),%esi
80103dcf:	8d 78 68             	lea    0x68(%eax),%edi
80103dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103dd8:	8b 06                	mov    (%esi),%eax
80103dda:	85 c0                	test   %eax,%eax
80103ddc:	74 12                	je     80103df0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dde:	83 ec 0c             	sub    $0xc,%esp
80103de1:	50                   	push   %eax
80103de2:	e8 09 d1 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103de7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ded:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103df0:	83 c6 04             	add    $0x4,%esi
80103df3:	39 f7                	cmp    %esi,%edi
80103df5:	75 e1                	jne    80103dd8 <exit+0x28>
  begin_op();
80103df7:	e8 64 ef ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
80103dfc:	83 ec 0c             	sub    $0xc,%esp
80103dff:	ff 73 68             	push   0x68(%ebx)
80103e02:	e8 a9 da ff ff       	call   801018b0 <iput>
  end_op();
80103e07:	e8 c4 ef ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80103e0c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e13:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e1a:	e8 c1 07 00 00       	call   801045e0 <acquire>
  wakeup1(curproc->parent);
80103e1f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e22:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e25:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e2a:	eb 10                	jmp    80103e3c <exit+0x8c>
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e30:	05 8c 00 00 00       	add    $0x8c,%eax
80103e35:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103e3a:	74 1e                	je     80103e5a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103e3c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e40:	75 ee                	jne    80103e30 <exit+0x80>
80103e42:	3b 50 20             	cmp    0x20(%eax),%edx
80103e45:	75 e9                	jne    80103e30 <exit+0x80>
      p->state = RUNNABLE;
80103e47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e4e:	05 8c 00 00 00       	add    $0x8c,%eax
80103e53:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103e58:	75 e2                	jne    80103e3c <exit+0x8c>
      p->parent = initproc;
80103e5a:	8b 0d 54 40 11 80    	mov    0x80114054,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e60:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103e65:	eb 17                	jmp    80103e7e <exit+0xce>
80103e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6e:	66 90                	xchg   %ax,%ax
80103e70:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103e76:	81 fa 54 40 11 80    	cmp    $0x80114054,%edx
80103e7c:	74 3a                	je     80103eb8 <exit+0x108>
    if(p->parent == curproc){
80103e7e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e81:	75 ed                	jne    80103e70 <exit+0xc0>
      if(p->state == ZOMBIE)
80103e83:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e87:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e8a:	75 e4                	jne    80103e70 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e8c:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e91:	eb 11                	jmp    80103ea4 <exit+0xf4>
80103e93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e97:	90                   	nop
80103e98:	05 8c 00 00 00       	add    $0x8c,%eax
80103e9d:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80103ea2:	74 cc                	je     80103e70 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103ea4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ea8:	75 ee                	jne    80103e98 <exit+0xe8>
80103eaa:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ead:	75 e9                	jne    80103e98 <exit+0xe8>
      p->state = RUNNABLE;
80103eaf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103eb6:	eb e0                	jmp    80103e98 <exit+0xe8>
  curproc->state = ZOMBIE;
80103eb8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ebf:	e8 2c fe ff ff       	call   80103cf0 <sched>
  panic("zombie exit");
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	68 68 78 10 80       	push   $0x80107868
80103ecc:	e8 af c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ed1:	83 ec 0c             	sub    $0xc,%esp
80103ed4:	68 5b 78 10 80       	push   $0x8010785b
80103ed9:	e8 a2 c4 ff ff       	call   80100380 <panic>
80103ede:	66 90                	xchg   %ax,%ax

80103ee0 <wait>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  pushcli();
80103ee5:	e8 a6 05 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103eea:	e8 21 fa ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103eef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ef5:	e8 e6 05 00 00       	call   801044e0 <popcli>
  acquire(&ptable.lock);
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 20 1d 11 80       	push   $0x80111d20
80103f02:	e8 d9 06 00 00       	call   801045e0 <acquire>
80103f07:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f0a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103f11:	eb 13                	jmp    80103f26 <wait+0x46>
80103f13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f17:	90                   	nop
80103f18:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103f1e:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
80103f24:	74 1e                	je     80103f44 <wait+0x64>
      if(p->parent != curproc)
80103f26:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f29:	75 ed                	jne    80103f18 <wait+0x38>
      if(p->state == ZOMBIE){
80103f2b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f2f:	74 6f                	je     80103fa0 <wait+0xc0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f31:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
80103f37:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f3c:	81 fb 54 40 11 80    	cmp    $0x80114054,%ebx
80103f42:	75 e2                	jne    80103f26 <wait+0x46>
    if(!havekids || curproc->killed){
80103f44:	85 c0                	test   %eax,%eax
80103f46:	0f 84 aa 00 00 00    	je     80103ff6 <wait+0x116>
80103f4c:	8b 46 24             	mov    0x24(%esi),%eax
80103f4f:	85 c0                	test   %eax,%eax
80103f51:	0f 85 9f 00 00 00    	jne    80103ff6 <wait+0x116>
  pushcli();
80103f57:	e8 34 05 00 00       	call   80104490 <pushcli>
  c = mycpu();
80103f5c:	e8 af f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103f61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f67:	e8 74 05 00 00       	call   801044e0 <popcli>
  if(p == 0)
80103f6c:	85 db                	test   %ebx,%ebx
80103f6e:	0f 84 99 00 00 00    	je     8010400d <wait+0x12d>
  p->rusage.nvcsw++; // Voluntary context switch: process blocks (sleeping) and yields CPU.
80103f74:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
  p->chan = chan;
80103f7b:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f7e:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f85:	e8 66 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103f8a:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f91:	e9 74 ff ff ff       	jmp    80103f0a <wait+0x2a>
80103f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103fa0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103fa3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fa6:	ff 73 08             	push   0x8(%ebx)
80103fa9:	e8 12 e5 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
80103fae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fb5:	5a                   	pop    %edx
80103fb6:	ff 73 04             	push   0x4(%ebx)
80103fb9:	e8 02 2f 00 00       	call   80106ec0 <freevm>
        p->pid = 0;
80103fbe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fc5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fcc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fd0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fd7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fde:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103fe5:	e8 96 05 00 00       	call   80104580 <release>
        return pid;
80103fea:	83 c4 10             	add    $0x10,%esp
}
80103fed:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ff0:	89 f0                	mov    %esi,%eax
80103ff2:	5b                   	pop    %ebx
80103ff3:	5e                   	pop    %esi
80103ff4:	5d                   	pop    %ebp
80103ff5:	c3                   	ret    
      release(&ptable.lock);
80103ff6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ff9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103ffe:	68 20 1d 11 80       	push   $0x80111d20
80104003:	e8 78 05 00 00       	call   80104580 <release>
      return -1;
80104008:	83 c4 10             	add    $0x10,%esp
8010400b:	eb e0                	jmp    80103fed <wait+0x10d>
    panic("sleep");
8010400d:	83 ec 0c             	sub    $0xc,%esp
80104010:	68 74 78 10 80       	push   $0x80107874
80104015:	e8 66 c3 ff ff       	call   80100380 <panic>
8010401a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104020 <yield>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	53                   	push   %ebx
80104024:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104027:	68 20 1d 11 80       	push   $0x80111d20
8010402c:	e8 af 05 00 00       	call   801045e0 <acquire>
  pushcli();
80104031:	e8 5a 04 00 00       	call   80104490 <pushcli>
  c = mycpu();
80104036:	e8 d5 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010403b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104041:	e8 9a 04 00 00       	call   801044e0 <popcli>
  myproc()->state = RUNNABLE;
80104046:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010404d:	e8 9e fc ff ff       	call   80103cf0 <sched>
  release(&ptable.lock);
80104052:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104059:	e8 22 05 00 00       	call   80104580 <release>
}
8010405e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104061:	83 c4 10             	add    $0x10,%esp
80104064:	c9                   	leave  
80104065:	c3                   	ret    
80104066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406d:	8d 76 00             	lea    0x0(%esi),%esi

80104070 <sleep>:
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 0c             	sub    $0xc,%esp
80104079:	8b 7d 08             	mov    0x8(%ebp),%edi
8010407c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010407f:	e8 0c 04 00 00       	call   80104490 <pushcli>
  c = mycpu();
80104084:	e8 87 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104089:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010408f:	e8 4c 04 00 00       	call   801044e0 <popcli>
  if(p == 0)
80104094:	85 db                	test   %ebx,%ebx
80104096:	0f 84 96 00 00 00    	je     80104132 <sleep+0xc2>
  if(lk == 0)
8010409c:	85 f6                	test   %esi,%esi
8010409e:	0f 84 81 00 00 00    	je     80104125 <sleep+0xb5>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040a4:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
801040aa:	74 54                	je     80104100 <sleep+0x90>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040ac:	83 ec 0c             	sub    $0xc,%esp
801040af:	68 20 1d 11 80       	push   $0x80111d20
801040b4:	e8 27 05 00 00       	call   801045e0 <acquire>
    release(lk);
801040b9:	89 34 24             	mov    %esi,(%esp)
801040bc:	e8 bf 04 00 00       	call   80104580 <release>
  p->rusage.nvcsw++; // Voluntary context switch: process blocks (sleeping) and yields CPU.
801040c1:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
  p->chan = chan;
801040c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040d2:	e8 19 fc ff ff       	call   80103cf0 <sched>
  p->chan = 0;
801040d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040de:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040e5:	e8 96 04 00 00       	call   80104580 <release>
    acquire(lk);
801040ea:	89 75 08             	mov    %esi,0x8(%ebp)
801040ed:	83 c4 10             	add    $0x10,%esp
}
801040f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040f3:	5b                   	pop    %ebx
801040f4:	5e                   	pop    %esi
801040f5:	5f                   	pop    %edi
801040f6:	5d                   	pop    %ebp
    acquire(lk);
801040f7:	e9 e4 04 00 00       	jmp    801045e0 <acquire>
801040fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  p->rusage.nvcsw++; // Voluntary context switch: process blocks (sleeping) and yields CPU.
80104100:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
  p->chan = chan;
80104107:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010410a:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104111:	e8 da fb ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80104116:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010411d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104120:	5b                   	pop    %ebx
80104121:	5e                   	pop    %esi
80104122:	5f                   	pop    %edi
80104123:	5d                   	pop    %ebp
80104124:	c3                   	ret    
    panic("sleep without lk");
80104125:	83 ec 0c             	sub    $0xc,%esp
80104128:	68 7a 78 10 80       	push   $0x8010787a
8010412d:	e8 4e c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104132:	83 ec 0c             	sub    $0xc,%esp
80104135:	68 74 78 10 80       	push   $0x80107874
8010413a:	e8 41 c2 ff ff       	call   80100380 <panic>
8010413f:	90                   	nop

80104140 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 10             	sub    $0x10,%esp
80104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010414a:	68 20 1d 11 80       	push   $0x80111d20
8010414f:	e8 8c 04 00 00       	call   801045e0 <acquire>
80104154:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104157:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010415c:	eb 0e                	jmp    8010416c <wakeup+0x2c>
8010415e:	66 90                	xchg   %ax,%ax
80104160:	05 8c 00 00 00       	add    $0x8c,%eax
80104165:	3d 54 40 11 80       	cmp    $0x80114054,%eax
8010416a:	74 1e                	je     8010418a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010416c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104170:	75 ee                	jne    80104160 <wakeup+0x20>
80104172:	3b 58 20             	cmp    0x20(%eax),%ebx
80104175:	75 e9                	jne    80104160 <wakeup+0x20>
      p->state = RUNNABLE;
80104177:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010417e:	05 8c 00 00 00       	add    $0x8c,%eax
80104183:	3d 54 40 11 80       	cmp    $0x80114054,%eax
80104188:	75 e2                	jne    8010416c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010418a:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
80104191:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104194:	c9                   	leave  
  release(&ptable.lock);
80104195:	e9 e6 03 00 00       	jmp    80104580 <release>
8010419a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
801041a4:	83 ec 10             	sub    $0x10,%esp
801041a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041aa:	68 20 1d 11 80       	push   $0x80111d20
801041af:	e8 2c 04 00 00       	call   801045e0 <acquire>
801041b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b7:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801041bc:	eb 0e                	jmp    801041cc <kill+0x2c>
801041be:	66 90                	xchg   %ax,%ax
801041c0:	05 8c 00 00 00       	add    $0x8c,%eax
801041c5:	3d 54 40 11 80       	cmp    $0x80114054,%eax
801041ca:	74 34                	je     80104200 <kill+0x60>
    if(p->pid == pid){
801041cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801041cf:	75 ef                	jne    801041c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041dc:	75 07                	jne    801041e5 <kill+0x45>
        p->state = RUNNABLE;
801041de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041e5:	83 ec 0c             	sub    $0xc,%esp
801041e8:	68 20 1d 11 80       	push   $0x80111d20
801041ed:	e8 8e 03 00 00       	call   80104580 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041f5:	83 c4 10             	add    $0x10,%esp
801041f8:	31 c0                	xor    %eax,%eax
}
801041fa:	c9                   	leave  
801041fb:	c3                   	ret    
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104200:	83 ec 0c             	sub    $0xc,%esp
80104203:	68 20 1d 11 80       	push   $0x80111d20
80104208:	e8 73 03 00 00       	call   80104580 <release>
}
8010420d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104210:	83 c4 10             	add    $0x10,%esp
80104213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104218:	c9                   	leave  
80104219:	c3                   	ret    
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	57                   	push   %edi
80104224:	56                   	push   %esi
80104225:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104228:	53                   	push   %ebx
80104229:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010422e:	83 ec 3c             	sub    $0x3c,%esp
80104231:	eb 27                	jmp    8010425a <procdump+0x3a>
80104233:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104237:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104238:	83 ec 0c             	sub    $0xc,%esp
8010423b:	68 fb 7b 10 80       	push   $0x80107bfb
80104240:	e8 5b c4 ff ff       	call   801006a0 <cprintf>
80104245:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104248:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010424e:	81 fb c0 40 11 80    	cmp    $0x801140c0,%ebx
80104254:	0f 84 7e 00 00 00    	je     801042d8 <procdump+0xb8>
    if(p->state == UNUSED)
8010425a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010425d:	85 c0                	test   %eax,%eax
8010425f:	74 e7                	je     80104248 <procdump+0x28>
      state = "???";
80104261:	ba 8b 78 10 80       	mov    $0x8010788b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104266:	83 f8 05             	cmp    $0x5,%eax
80104269:	77 11                	ja     8010427c <procdump+0x5c>
8010426b:	8b 14 85 ec 78 10 80 	mov    -0x7fef8714(,%eax,4),%edx
      state = "???";
80104272:	b8 8b 78 10 80       	mov    $0x8010788b,%eax
80104277:	85 d2                	test   %edx,%edx
80104279:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010427c:	53                   	push   %ebx
8010427d:	52                   	push   %edx
8010427e:	ff 73 a4             	push   -0x5c(%ebx)
80104281:	68 8f 78 10 80       	push   $0x8010788f
80104286:	e8 15 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010428b:	83 c4 10             	add    $0x10,%esp
8010428e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104292:	75 a4                	jne    80104238 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104294:	83 ec 08             	sub    $0x8,%esp
80104297:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010429a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010429d:	50                   	push   %eax
8010429e:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042a1:	8b 40 0c             	mov    0xc(%eax),%eax
801042a4:	83 c0 08             	add    $0x8,%eax
801042a7:	50                   	push   %eax
801042a8:	e8 83 01 00 00       	call   80104430 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042ad:	83 c4 10             	add    $0x10,%esp
801042b0:	8b 17                	mov    (%edi),%edx
801042b2:	85 d2                	test   %edx,%edx
801042b4:	74 82                	je     80104238 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042b6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042b9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801042bc:	52                   	push   %edx
801042bd:	68 e1 72 10 80       	push   $0x801072e1
801042c2:	e8 d9 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042c7:	83 c4 10             	add    $0x10,%esp
801042ca:	39 fe                	cmp    %edi,%esi
801042cc:	75 e2                	jne    801042b0 <procdump+0x90>
801042ce:	e9 65 ff ff ff       	jmp    80104238 <procdump+0x18>
801042d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d7:	90                   	nop
  }
}
801042d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042db:	5b                   	pop    %ebx
801042dc:	5e                   	pop    %esi
801042dd:	5f                   	pop    %edi
801042de:	5d                   	pop    %ebp
801042df:	c3                   	ret    

801042e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 0c             	sub    $0xc,%esp
801042e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042ea:	68 04 79 10 80       	push   $0x80107904
801042ef:	8d 43 04             	lea    0x4(%ebx),%eax
801042f2:	50                   	push   %eax
801042f3:	e8 18 01 00 00       	call   80104410 <initlock>
  lk->name = name;
801042f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104301:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104304:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010430b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010430e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104311:	c9                   	leave  
80104312:	c3                   	ret    
80104313:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104320 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	56                   	push   %esi
80104324:	53                   	push   %ebx
80104325:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104328:	8d 73 04             	lea    0x4(%ebx),%esi
8010432b:	83 ec 0c             	sub    $0xc,%esp
8010432e:	56                   	push   %esi
8010432f:	e8 ac 02 00 00       	call   801045e0 <acquire>
  while (lk->locked) {
80104334:	8b 13                	mov    (%ebx),%edx
80104336:	83 c4 10             	add    $0x10,%esp
80104339:	85 d2                	test   %edx,%edx
8010433b:	74 16                	je     80104353 <acquiresleep+0x33>
8010433d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104340:	83 ec 08             	sub    $0x8,%esp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
80104345:	e8 26 fd ff ff       	call   80104070 <sleep>
  while (lk->locked) {
8010434a:	8b 03                	mov    (%ebx),%eax
8010434c:	83 c4 10             	add    $0x10,%esp
8010434f:	85 c0                	test   %eax,%eax
80104351:	75 ed                	jne    80104340 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104353:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104359:	e8 32 f6 ff ff       	call   80103990 <myproc>
8010435e:	8b 40 10             	mov    0x10(%eax),%eax
80104361:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104364:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104367:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010436a:	5b                   	pop    %ebx
8010436b:	5e                   	pop    %esi
8010436c:	5d                   	pop    %ebp
  release(&lk->lk);
8010436d:	e9 0e 02 00 00       	jmp    80104580 <release>
80104372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104380 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104388:	8d 73 04             	lea    0x4(%ebx),%esi
8010438b:	83 ec 0c             	sub    $0xc,%esp
8010438e:	56                   	push   %esi
8010438f:	e8 4c 02 00 00       	call   801045e0 <acquire>
  lk->locked = 0;
80104394:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010439a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043a1:	89 1c 24             	mov    %ebx,(%esp)
801043a4:	e8 97 fd ff ff       	call   80104140 <wakeup>
  release(&lk->lk);
801043a9:	89 75 08             	mov    %esi,0x8(%ebp)
801043ac:	83 c4 10             	add    $0x10,%esp
}
801043af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043b2:	5b                   	pop    %ebx
801043b3:	5e                   	pop    %esi
801043b4:	5d                   	pop    %ebp
  release(&lk->lk);
801043b5:	e9 c6 01 00 00       	jmp    80104580 <release>
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	57                   	push   %edi
801043c4:	31 ff                	xor    %edi,%edi
801043c6:	56                   	push   %esi
801043c7:	53                   	push   %ebx
801043c8:	83 ec 18             	sub    $0x18,%esp
801043cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043ce:	8d 73 04             	lea    0x4(%ebx),%esi
801043d1:	56                   	push   %esi
801043d2:	e8 09 02 00 00       	call   801045e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043d7:	8b 03                	mov    (%ebx),%eax
801043d9:	83 c4 10             	add    $0x10,%esp
801043dc:	85 c0                	test   %eax,%eax
801043de:	75 18                	jne    801043f8 <holdingsleep+0x38>
  release(&lk->lk);
801043e0:	83 ec 0c             	sub    $0xc,%esp
801043e3:	56                   	push   %esi
801043e4:	e8 97 01 00 00       	call   80104580 <release>
  return r;
}
801043e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043ec:	89 f8                	mov    %edi,%eax
801043ee:	5b                   	pop    %ebx
801043ef:	5e                   	pop    %esi
801043f0:	5f                   	pop    %edi
801043f1:	5d                   	pop    %ebp
801043f2:	c3                   	ret    
801043f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801043f8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043fb:	e8 90 f5 ff ff       	call   80103990 <myproc>
80104400:	39 58 10             	cmp    %ebx,0x10(%eax)
80104403:	0f 94 c0             	sete   %al
80104406:	0f b6 c0             	movzbl %al,%eax
80104409:	89 c7                	mov    %eax,%edi
8010440b:	eb d3                	jmp    801043e0 <holdingsleep+0x20>
8010440d:	66 90                	xchg   %ax,%ax
8010440f:	90                   	nop

80104410 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104416:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010441f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104422:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104429:	5d                   	pop    %ebp
8010442a:	c3                   	ret    
8010442b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010442f:	90                   	nop

80104430 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104430:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104431:	31 d2                	xor    %edx,%edx
{
80104433:	89 e5                	mov    %esp,%ebp
80104435:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104436:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104439:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010443c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010443f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104440:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104446:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010444c:	77 1a                	ja     80104468 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010444e:	8b 58 04             	mov    0x4(%eax),%ebx
80104451:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104454:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104457:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104459:	83 fa 0a             	cmp    $0xa,%edx
8010445c:	75 e2                	jne    80104440 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010445e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104461:	c9                   	leave  
80104462:	c3                   	ret    
80104463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104467:	90                   	nop
  for(; i < 10; i++)
80104468:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010446b:	8d 51 28             	lea    0x28(%ecx),%edx
8010446e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104476:	83 c0 04             	add    $0x4,%eax
80104479:	39 d0                	cmp    %edx,%eax
8010447b:	75 f3                	jne    80104470 <getcallerpcs+0x40>
}
8010447d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104480:	c9                   	leave  
80104481:	c3                   	ret    
80104482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104490 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	53                   	push   %ebx
80104494:	83 ec 04             	sub    $0x4,%esp
80104497:	9c                   	pushf  
80104498:	5b                   	pop    %ebx
  asm volatile("cli");
80104499:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010449a:	e8 71 f4 ff ff       	call   80103910 <mycpu>
8010449f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044a5:	85 c0                	test   %eax,%eax
801044a7:	74 17                	je     801044c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044a9:	e8 62 f4 ff ff       	call   80103910 <mycpu>
801044ae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044b8:	c9                   	leave  
801044b9:	c3                   	ret    
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801044c0:	e8 4b f4 ff ff       	call   80103910 <mycpu>
801044c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044d1:	eb d6                	jmp    801044a9 <pushcli+0x19>
801044d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <popcli>:

void
popcli(void)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044e6:	9c                   	pushf  
801044e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044e8:	f6 c4 02             	test   $0x2,%ah
801044eb:	75 35                	jne    80104522 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044ed:	e8 1e f4 ff ff       	call   80103910 <mycpu>
801044f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044f9:	78 34                	js     8010452f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044fb:	e8 10 f4 ff ff       	call   80103910 <mycpu>
80104500:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104506:	85 d2                	test   %edx,%edx
80104508:	74 06                	je     80104510 <popcli+0x30>
    sti();
}
8010450a:	c9                   	leave  
8010450b:	c3                   	ret    
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104510:	e8 fb f3 ff ff       	call   80103910 <mycpu>
80104515:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010451b:	85 c0                	test   %eax,%eax
8010451d:	74 eb                	je     8010450a <popcli+0x2a>
  asm volatile("sti");
8010451f:	fb                   	sti    
}
80104520:	c9                   	leave  
80104521:	c3                   	ret    
    panic("popcli - interruptible");
80104522:	83 ec 0c             	sub    $0xc,%esp
80104525:	68 0f 79 10 80       	push   $0x8010790f
8010452a:	e8 51 be ff ff       	call   80100380 <panic>
    panic("popcli");
8010452f:	83 ec 0c             	sub    $0xc,%esp
80104532:	68 26 79 10 80       	push   $0x80107926
80104537:	e8 44 be ff ff       	call   80100380 <panic>
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104540 <holding>:
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	56                   	push   %esi
80104544:	53                   	push   %ebx
80104545:	8b 75 08             	mov    0x8(%ebp),%esi
80104548:	31 db                	xor    %ebx,%ebx
  pushcli();
8010454a:	e8 41 ff ff ff       	call   80104490 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010454f:	8b 06                	mov    (%esi),%eax
80104551:	85 c0                	test   %eax,%eax
80104553:	75 0b                	jne    80104560 <holding+0x20>
  popcli();
80104555:	e8 86 ff ff ff       	call   801044e0 <popcli>
}
8010455a:	89 d8                	mov    %ebx,%eax
8010455c:	5b                   	pop    %ebx
8010455d:	5e                   	pop    %esi
8010455e:	5d                   	pop    %ebp
8010455f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104560:	8b 5e 08             	mov    0x8(%esi),%ebx
80104563:	e8 a8 f3 ff ff       	call   80103910 <mycpu>
80104568:	39 c3                	cmp    %eax,%ebx
8010456a:	0f 94 c3             	sete   %bl
  popcli();
8010456d:	e8 6e ff ff ff       	call   801044e0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104572:	0f b6 db             	movzbl %bl,%ebx
}
80104575:	89 d8                	mov    %ebx,%eax
80104577:	5b                   	pop    %ebx
80104578:	5e                   	pop    %esi
80104579:	5d                   	pop    %ebp
8010457a:	c3                   	ret    
8010457b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010457f:	90                   	nop

80104580 <release>:
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104588:	e8 03 ff ff ff       	call   80104490 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010458d:	8b 03                	mov    (%ebx),%eax
8010458f:	85 c0                	test   %eax,%eax
80104591:	75 15                	jne    801045a8 <release+0x28>
  popcli();
80104593:	e8 48 ff ff ff       	call   801044e0 <popcli>
    panic("release");
80104598:	83 ec 0c             	sub    $0xc,%esp
8010459b:	68 2d 79 10 80       	push   $0x8010792d
801045a0:	e8 db bd ff ff       	call   80100380 <panic>
801045a5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801045a8:	8b 73 08             	mov    0x8(%ebx),%esi
801045ab:	e8 60 f3 ff ff       	call   80103910 <mycpu>
801045b0:	39 c6                	cmp    %eax,%esi
801045b2:	75 df                	jne    80104593 <release+0x13>
  popcli();
801045b4:	e8 27 ff ff ff       	call   801044e0 <popcli>
  lk->pcs[0] = 0;
801045b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045c0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045c7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045cc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045d5:	5b                   	pop    %ebx
801045d6:	5e                   	pop    %esi
801045d7:	5d                   	pop    %ebp
  popcli();
801045d8:	e9 03 ff ff ff       	jmp    801044e0 <popcli>
801045dd:	8d 76 00             	lea    0x0(%esi),%esi

801045e0 <acquire>:
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	53                   	push   %ebx
801045e4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801045e7:	e8 a4 fe ff ff       	call   80104490 <pushcli>
  if(holding(lk))
801045ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045ef:	e8 9c fe ff ff       	call   80104490 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045f4:	8b 03                	mov    (%ebx),%eax
801045f6:	85 c0                	test   %eax,%eax
801045f8:	75 7e                	jne    80104678 <acquire+0x98>
  popcli();
801045fa:	e8 e1 fe ff ff       	call   801044e0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801045ff:	b9 01 00 00 00       	mov    $0x1,%ecx
80104604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104608:	8b 55 08             	mov    0x8(%ebp),%edx
8010460b:	89 c8                	mov    %ecx,%eax
8010460d:	f0 87 02             	lock xchg %eax,(%edx)
80104610:	85 c0                	test   %eax,%eax
80104612:	75 f4                	jne    80104608 <acquire+0x28>
  __sync_synchronize();
80104614:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104619:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010461c:	e8 ef f2 ff ff       	call   80103910 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104621:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104624:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104626:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104629:	31 c0                	xor    %eax,%eax
8010462b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010462f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104630:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104636:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010463c:	77 1a                	ja     80104658 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010463e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104641:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104645:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104648:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010464a:	83 f8 0a             	cmp    $0xa,%eax
8010464d:	75 e1                	jne    80104630 <acquire+0x50>
}
8010464f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104652:	c9                   	leave  
80104653:	c3                   	ret    
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104658:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010465c:	8d 51 34             	lea    0x34(%ecx),%edx
8010465f:	90                   	nop
    pcs[i] = 0;
80104660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104666:	83 c0 04             	add    $0x4,%eax
80104669:	39 c2                	cmp    %eax,%edx
8010466b:	75 f3                	jne    80104660 <acquire+0x80>
}
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104670:	c9                   	leave  
80104671:	c3                   	ret    
80104672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104678:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010467b:	e8 90 f2 ff ff       	call   80103910 <mycpu>
80104680:	39 c3                	cmp    %eax,%ebx
80104682:	0f 85 72 ff ff ff    	jne    801045fa <acquire+0x1a>
  popcli();
80104688:	e8 53 fe ff ff       	call   801044e0 <popcli>
    panic("acquire");
8010468d:	83 ec 0c             	sub    $0xc,%esp
80104690:	68 35 79 10 80       	push   $0x80107935
80104695:	e8 e6 bc ff ff       	call   80100380 <panic>
8010469a:	66 90                	xchg   %ax,%ax
8010469c:	66 90                	xchg   %ax,%ax
8010469e:	66 90                	xchg   %ax,%ax

801046a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	57                   	push   %edi
801046a4:	8b 55 08             	mov    0x8(%ebp),%edx
801046a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046aa:	53                   	push   %ebx
801046ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801046ae:	89 d7                	mov    %edx,%edi
801046b0:	09 cf                	or     %ecx,%edi
801046b2:	83 e7 03             	and    $0x3,%edi
801046b5:	75 29                	jne    801046e0 <memset+0x40>
    c &= 0xFF;
801046b7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046ba:	c1 e0 18             	shl    $0x18,%eax
801046bd:	89 fb                	mov    %edi,%ebx
801046bf:	c1 e9 02             	shr    $0x2,%ecx
801046c2:	c1 e3 10             	shl    $0x10,%ebx
801046c5:	09 d8                	or     %ebx,%eax
801046c7:	09 f8                	or     %edi,%eax
801046c9:	c1 e7 08             	shl    $0x8,%edi
801046cc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046ce:	89 d7                	mov    %edx,%edi
801046d0:	fc                   	cld    
801046d1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046d3:	5b                   	pop    %ebx
801046d4:	89 d0                	mov    %edx,%eax
801046d6:	5f                   	pop    %edi
801046d7:	5d                   	pop    %ebp
801046d8:	c3                   	ret    
801046d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801046e0:	89 d7                	mov    %edx,%edi
801046e2:	fc                   	cld    
801046e3:	f3 aa                	rep stos %al,%es:(%edi)
801046e5:	5b                   	pop    %ebx
801046e6:	89 d0                	mov    %edx,%eax
801046e8:	5f                   	pop    %edi
801046e9:	5d                   	pop    %ebp
801046ea:	c3                   	ret    
801046eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046ef:	90                   	nop

801046f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	56                   	push   %esi
801046f4:	8b 75 10             	mov    0x10(%ebp),%esi
801046f7:	8b 55 08             	mov    0x8(%ebp),%edx
801046fa:	53                   	push   %ebx
801046fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046fe:	85 f6                	test   %esi,%esi
80104700:	74 2e                	je     80104730 <memcmp+0x40>
80104702:	01 c6                	add    %eax,%esi
80104704:	eb 14                	jmp    8010471a <memcmp+0x2a>
80104706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104710:	83 c0 01             	add    $0x1,%eax
80104713:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104716:	39 f0                	cmp    %esi,%eax
80104718:	74 16                	je     80104730 <memcmp+0x40>
    if(*s1 != *s2)
8010471a:	0f b6 0a             	movzbl (%edx),%ecx
8010471d:	0f b6 18             	movzbl (%eax),%ebx
80104720:	38 d9                	cmp    %bl,%cl
80104722:	74 ec                	je     80104710 <memcmp+0x20>
      return *s1 - *s2;
80104724:	0f b6 c1             	movzbl %cl,%eax
80104727:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104729:	5b                   	pop    %ebx
8010472a:	5e                   	pop    %esi
8010472b:	5d                   	pop    %ebp
8010472c:	c3                   	ret    
8010472d:	8d 76 00             	lea    0x0(%esi),%esi
80104730:	5b                   	pop    %ebx
  return 0;
80104731:	31 c0                	xor    %eax,%eax
}
80104733:	5e                   	pop    %esi
80104734:	5d                   	pop    %ebp
80104735:	c3                   	ret    
80104736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473d:	8d 76 00             	lea    0x0(%esi),%esi

80104740 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	57                   	push   %edi
80104744:	8b 55 08             	mov    0x8(%ebp),%edx
80104747:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010474a:	56                   	push   %esi
8010474b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010474e:	39 d6                	cmp    %edx,%esi
80104750:	73 26                	jae    80104778 <memmove+0x38>
80104752:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104755:	39 fa                	cmp    %edi,%edx
80104757:	73 1f                	jae    80104778 <memmove+0x38>
80104759:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010475c:	85 c9                	test   %ecx,%ecx
8010475e:	74 0c                	je     8010476c <memmove+0x2c>
      *--d = *--s;
80104760:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104764:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104767:	83 e8 01             	sub    $0x1,%eax
8010476a:	73 f4                	jae    80104760 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010476c:	5e                   	pop    %esi
8010476d:	89 d0                	mov    %edx,%eax
8010476f:	5f                   	pop    %edi
80104770:	5d                   	pop    %ebp
80104771:	c3                   	ret    
80104772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104778:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010477b:	89 d7                	mov    %edx,%edi
8010477d:	85 c9                	test   %ecx,%ecx
8010477f:	74 eb                	je     8010476c <memmove+0x2c>
80104781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104788:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104789:	39 c6                	cmp    %eax,%esi
8010478b:	75 fb                	jne    80104788 <memmove+0x48>
}
8010478d:	5e                   	pop    %esi
8010478e:	89 d0                	mov    %edx,%eax
80104790:	5f                   	pop    %edi
80104791:	5d                   	pop    %ebp
80104792:	c3                   	ret    
80104793:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801047a0:	eb 9e                	jmp    80104740 <memmove>
801047a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047b0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	8b 75 10             	mov    0x10(%ebp),%esi
801047b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047ba:	53                   	push   %ebx
801047bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801047be:	85 f6                	test   %esi,%esi
801047c0:	74 2e                	je     801047f0 <strncmp+0x40>
801047c2:	01 d6                	add    %edx,%esi
801047c4:	eb 18                	jmp    801047de <strncmp+0x2e>
801047c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
801047d0:	38 d8                	cmp    %bl,%al
801047d2:	75 14                	jne    801047e8 <strncmp+0x38>
    n--, p++, q++;
801047d4:	83 c2 01             	add    $0x1,%edx
801047d7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047da:	39 f2                	cmp    %esi,%edx
801047dc:	74 12                	je     801047f0 <strncmp+0x40>
801047de:	0f b6 01             	movzbl (%ecx),%eax
801047e1:	0f b6 1a             	movzbl (%edx),%ebx
801047e4:	84 c0                	test   %al,%al
801047e6:	75 e8                	jne    801047d0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047e8:	29 d8                	sub    %ebx,%eax
}
801047ea:	5b                   	pop    %ebx
801047eb:	5e                   	pop    %esi
801047ec:	5d                   	pop    %ebp
801047ed:	c3                   	ret    
801047ee:	66 90                	xchg   %ax,%ax
801047f0:	5b                   	pop    %ebx
    return 0;
801047f1:	31 c0                	xor    %eax,%eax
}
801047f3:	5e                   	pop    %esi
801047f4:	5d                   	pop    %ebp
801047f5:	c3                   	ret    
801047f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fd:	8d 76 00             	lea    0x0(%esi),%esi

80104800 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	57                   	push   %edi
80104804:	56                   	push   %esi
80104805:	8b 75 08             	mov    0x8(%ebp),%esi
80104808:	53                   	push   %ebx
80104809:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010480c:	89 f0                	mov    %esi,%eax
8010480e:	eb 15                	jmp    80104825 <strncpy+0x25>
80104810:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104814:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104817:	83 c0 01             	add    $0x1,%eax
8010481a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010481e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104821:	84 d2                	test   %dl,%dl
80104823:	74 09                	je     8010482e <strncpy+0x2e>
80104825:	89 cb                	mov    %ecx,%ebx
80104827:	83 e9 01             	sub    $0x1,%ecx
8010482a:	85 db                	test   %ebx,%ebx
8010482c:	7f e2                	jg     80104810 <strncpy+0x10>
    ;
  while(n-- > 0)
8010482e:	89 c2                	mov    %eax,%edx
80104830:	85 c9                	test   %ecx,%ecx
80104832:	7e 17                	jle    8010484b <strncpy+0x4b>
80104834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104838:	83 c2 01             	add    $0x1,%edx
8010483b:	89 c1                	mov    %eax,%ecx
8010483d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104841:	29 d1                	sub    %edx,%ecx
80104843:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104847:	85 c9                	test   %ecx,%ecx
80104849:	7f ed                	jg     80104838 <strncpy+0x38>
  return os;
}
8010484b:	5b                   	pop    %ebx
8010484c:	89 f0                	mov    %esi,%eax
8010484e:	5e                   	pop    %esi
8010484f:	5f                   	pop    %edi
80104850:	5d                   	pop    %ebp
80104851:	c3                   	ret    
80104852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104860 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	8b 55 10             	mov    0x10(%ebp),%edx
80104867:	8b 75 08             	mov    0x8(%ebp),%esi
8010486a:	53                   	push   %ebx
8010486b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010486e:	85 d2                	test   %edx,%edx
80104870:	7e 25                	jle    80104897 <safestrcpy+0x37>
80104872:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104876:	89 f2                	mov    %esi,%edx
80104878:	eb 16                	jmp    80104890 <safestrcpy+0x30>
8010487a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104880:	0f b6 08             	movzbl (%eax),%ecx
80104883:	83 c0 01             	add    $0x1,%eax
80104886:	83 c2 01             	add    $0x1,%edx
80104889:	88 4a ff             	mov    %cl,-0x1(%edx)
8010488c:	84 c9                	test   %cl,%cl
8010488e:	74 04                	je     80104894 <safestrcpy+0x34>
80104890:	39 d8                	cmp    %ebx,%eax
80104892:	75 ec                	jne    80104880 <safestrcpy+0x20>
    ;
  *s = 0;
80104894:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104897:	89 f0                	mov    %esi,%eax
80104899:	5b                   	pop    %ebx
8010489a:	5e                   	pop    %esi
8010489b:	5d                   	pop    %ebp
8010489c:	c3                   	ret    
8010489d:	8d 76 00             	lea    0x0(%esi),%esi

801048a0 <strlen>:

int
strlen(const char *s)
{
801048a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048a1:	31 c0                	xor    %eax,%eax
{
801048a3:	89 e5                	mov    %esp,%ebp
801048a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048a8:	80 3a 00             	cmpb   $0x0,(%edx)
801048ab:	74 0c                	je     801048b9 <strlen+0x19>
801048ad:	8d 76 00             	lea    0x0(%esi),%esi
801048b0:	83 c0 01             	add    $0x1,%eax
801048b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048b7:	75 f7                	jne    801048b0 <strlen+0x10>
    ;
  return n;
}
801048b9:	5d                   	pop    %ebp
801048ba:	c3                   	ret    

801048bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048c3:	55                   	push   %ebp
  pushl %ebx
801048c4:	53                   	push   %ebx
  pushl %esi
801048c5:	56                   	push   %esi
  pushl %edi
801048c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048cb:	5f                   	pop    %edi
  popl %esi
801048cc:	5e                   	pop    %esi
  popl %ebx
801048cd:	5b                   	pop    %ebx
  popl %ebp
801048ce:	5d                   	pop    %ebp
  ret
801048cf:	c3                   	ret    

801048d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 04             	sub    $0x4,%esp
801048d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048da:	e8 b1 f0 ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048df:	8b 00                	mov    (%eax),%eax
801048e1:	39 d8                	cmp    %ebx,%eax
801048e3:	76 1b                	jbe    80104900 <fetchint+0x30>
801048e5:	8d 53 04             	lea    0x4(%ebx),%edx
801048e8:	39 d0                	cmp    %edx,%eax
801048ea:	72 14                	jb     80104900 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ef:	8b 13                	mov    (%ebx),%edx
801048f1:	89 10                	mov    %edx,(%eax)
  return 0;
801048f3:	31 c0                	xor    %eax,%eax
}
801048f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f8:	c9                   	leave  
801048f9:	c3                   	ret    
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104905:	eb ee                	jmp    801048f5 <fetchint+0x25>
80104907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490e:	66 90                	xchg   %ax,%ax

80104910 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 04             	sub    $0x4,%esp
80104917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010491a:	e8 71 f0 ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz)
8010491f:	39 18                	cmp    %ebx,(%eax)
80104921:	76 2d                	jbe    80104950 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104923:	8b 55 0c             	mov    0xc(%ebp),%edx
80104926:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104928:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010492a:	39 d3                	cmp    %edx,%ebx
8010492c:	73 22                	jae    80104950 <fetchstr+0x40>
8010492e:	89 d8                	mov    %ebx,%eax
80104930:	eb 0d                	jmp    8010493f <fetchstr+0x2f>
80104932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104938:	83 c0 01             	add    $0x1,%eax
8010493b:	39 c2                	cmp    %eax,%edx
8010493d:	76 11                	jbe    80104950 <fetchstr+0x40>
    if(*s == 0)
8010493f:	80 38 00             	cmpb   $0x0,(%eax)
80104942:	75 f4                	jne    80104938 <fetchstr+0x28>
      return s - *pp;
80104944:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104949:	c9                   	leave  
8010494a:	c3                   	ret    
8010494b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010494f:	90                   	nop
80104950:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104953:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104958:	c9                   	leave  
80104959:	c3                   	ret    
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104960 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104965:	e8 26 f0 ff ff       	call   80103990 <myproc>
8010496a:	8b 55 08             	mov    0x8(%ebp),%edx
8010496d:	8b 40 18             	mov    0x18(%eax),%eax
80104970:	8b 40 44             	mov    0x44(%eax),%eax
80104973:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104976:	e8 15 f0 ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010497b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010497e:	8b 00                	mov    (%eax),%eax
80104980:	39 c6                	cmp    %eax,%esi
80104982:	73 1c                	jae    801049a0 <argint+0x40>
80104984:	8d 53 08             	lea    0x8(%ebx),%edx
80104987:	39 d0                	cmp    %edx,%eax
80104989:	72 15                	jb     801049a0 <argint+0x40>
  *ip = *(int*)(addr);
8010498b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010498e:	8b 53 04             	mov    0x4(%ebx),%edx
80104991:	89 10                	mov    %edx,(%eax)
  return 0;
80104993:	31 c0                	xor    %eax,%eax
}
80104995:	5b                   	pop    %ebx
80104996:	5e                   	pop    %esi
80104997:	5d                   	pop    %ebp
80104998:	c3                   	ret    
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049a5:	eb ee                	jmp    80104995 <argint+0x35>
801049a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ae:	66 90                	xchg   %ax,%ax

801049b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	56                   	push   %esi
801049b5:	53                   	push   %ebx
801049b6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801049b9:	e8 d2 ef ff ff       	call   80103990 <myproc>
801049be:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049c0:	e8 cb ef ff ff       	call   80103990 <myproc>
801049c5:	8b 55 08             	mov    0x8(%ebp),%edx
801049c8:	8b 40 18             	mov    0x18(%eax),%eax
801049cb:	8b 40 44             	mov    0x44(%eax),%eax
801049ce:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049d1:	e8 ba ef ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049d6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049d9:	8b 00                	mov    (%eax),%eax
801049db:	39 c7                	cmp    %eax,%edi
801049dd:	73 31                	jae    80104a10 <argptr+0x60>
801049df:	8d 4b 08             	lea    0x8(%ebx),%ecx
801049e2:	39 c8                	cmp    %ecx,%eax
801049e4:	72 2a                	jb     80104a10 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049e6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801049e9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049ec:	85 d2                	test   %edx,%edx
801049ee:	78 20                	js     80104a10 <argptr+0x60>
801049f0:	8b 16                	mov    (%esi),%edx
801049f2:	39 c2                	cmp    %eax,%edx
801049f4:	76 1a                	jbe    80104a10 <argptr+0x60>
801049f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049f9:	01 c3                	add    %eax,%ebx
801049fb:	39 da                	cmp    %ebx,%edx
801049fd:	72 11                	jb     80104a10 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801049ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a02:	89 02                	mov    %eax,(%edx)
  return 0;
80104a04:	31 c0                	xor    %eax,%eax
}
80104a06:	83 c4 0c             	add    $0xc,%esp
80104a09:	5b                   	pop    %ebx
80104a0a:	5e                   	pop    %esi
80104a0b:	5f                   	pop    %edi
80104a0c:	5d                   	pop    %ebp
80104a0d:	c3                   	ret    
80104a0e:	66 90                	xchg   %ax,%ax
    return -1;
80104a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a15:	eb ef                	jmp    80104a06 <argptr+0x56>
80104a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a25:	e8 66 ef ff ff       	call   80103990 <myproc>
80104a2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a2d:	8b 40 18             	mov    0x18(%eax),%eax
80104a30:	8b 40 44             	mov    0x44(%eax),%eax
80104a33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a36:	e8 55 ef ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a3e:	8b 00                	mov    (%eax),%eax
80104a40:	39 c6                	cmp    %eax,%esi
80104a42:	73 44                	jae    80104a88 <argstr+0x68>
80104a44:	8d 53 08             	lea    0x8(%ebx),%edx
80104a47:	39 d0                	cmp    %edx,%eax
80104a49:	72 3d                	jb     80104a88 <argstr+0x68>
  *ip = *(int*)(addr);
80104a4b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a4e:	e8 3d ef ff ff       	call   80103990 <myproc>
  if(addr >= curproc->sz)
80104a53:	3b 18                	cmp    (%eax),%ebx
80104a55:	73 31                	jae    80104a88 <argstr+0x68>
  *pp = (char*)addr;
80104a57:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a5e:	39 d3                	cmp    %edx,%ebx
80104a60:	73 26                	jae    80104a88 <argstr+0x68>
80104a62:	89 d8                	mov    %ebx,%eax
80104a64:	eb 11                	jmp    80104a77 <argstr+0x57>
80104a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi
80104a70:	83 c0 01             	add    $0x1,%eax
80104a73:	39 c2                	cmp    %eax,%edx
80104a75:	76 11                	jbe    80104a88 <argstr+0x68>
    if(*s == 0)
80104a77:	80 38 00             	cmpb   $0x0,(%eax)
80104a7a:	75 f4                	jne    80104a70 <argstr+0x50>
      return s - *pp;
80104a7c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a7e:	5b                   	pop    %ebx
80104a7f:	5e                   	pop    %esi
80104a80:	5d                   	pop    %ebp
80104a81:	c3                   	ret    
80104a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a88:	5b                   	pop    %ebx
    return -1;
80104a89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a8e:	5e                   	pop    %esi
80104a8f:	5d                   	pop    %ebp
80104a90:	c3                   	ret    
80104a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9f:	90                   	nop

80104aa0 <syscall>:
[SYS_getrusage] sys_getrusage,
};

void
syscall(void)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104aa7:	e8 e4 ee ff ff       	call   80103990 <myproc>
80104aac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104aae:	8b 40 18             	mov    0x18(%eax),%eax
80104ab1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ab4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ab7:	83 fa 15             	cmp    $0x15,%edx
80104aba:	77 24                	ja     80104ae0 <syscall+0x40>
80104abc:	8b 14 85 60 79 10 80 	mov    -0x7fef86a0(,%eax,4),%edx
80104ac3:	85 d2                	test   %edx,%edx
80104ac5:	74 19                	je     80104ae0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104ac7:	ff d2                	call   *%edx
80104ac9:	89 c2                	mov    %eax,%edx
80104acb:	8b 43 18             	mov    0x18(%ebx),%eax
80104ace:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ad1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad4:	c9                   	leave  
80104ad5:	c3                   	ret    
80104ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104add:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ae0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ae1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ae4:	50                   	push   %eax
80104ae5:	ff 73 10             	push   0x10(%ebx)
80104ae8:	68 3d 79 10 80       	push   $0x8010793d
80104aed:	e8 ae bb ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104af2:	8b 43 18             	mov    0x18(%ebx),%eax
80104af5:	83 c4 10             	add    $0x10,%esp
80104af8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b02:	c9                   	leave  
80104b03:	c3                   	ret    
80104b04:	66 90                	xchg   %ax,%ax
80104b06:	66 90                	xchg   %ax,%ax
80104b08:	66 90                	xchg   %ax,%ax
80104b0a:	66 90                	xchg   %ax,%ax
80104b0c:	66 90                	xchg   %ax,%ax
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b18:	53                   	push   %ebx
80104b19:	83 ec 34             	sub    $0x34,%esp
80104b1c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b22:	57                   	push   %edi
80104b23:	50                   	push   %eax
{
80104b24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b2a:	e8 91 d5 ff ff       	call   801020c0 <nameiparent>
80104b2f:	83 c4 10             	add    $0x10,%esp
80104b32:	85 c0                	test   %eax,%eax
80104b34:	0f 84 46 01 00 00    	je     80104c80 <create+0x170>
    return 0;
  ilock(dp);
80104b3a:	83 ec 0c             	sub    $0xc,%esp
80104b3d:	89 c3                	mov    %eax,%ebx
80104b3f:	50                   	push   %eax
80104b40:	e8 3b cc ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b45:	83 c4 0c             	add    $0xc,%esp
80104b48:	6a 00                	push   $0x0
80104b4a:	57                   	push   %edi
80104b4b:	53                   	push   %ebx
80104b4c:	e8 8f d1 ff ff       	call   80101ce0 <dirlookup>
80104b51:	83 c4 10             	add    $0x10,%esp
80104b54:	89 c6                	mov    %eax,%esi
80104b56:	85 c0                	test   %eax,%eax
80104b58:	74 56                	je     80104bb0 <create+0xa0>
    iunlockput(dp);
80104b5a:	83 ec 0c             	sub    $0xc,%esp
80104b5d:	53                   	push   %ebx
80104b5e:	e8 ad ce ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104b63:	89 34 24             	mov    %esi,(%esp)
80104b66:	e8 15 cc ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b6b:	83 c4 10             	add    $0x10,%esp
80104b6e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b73:	75 1b                	jne    80104b90 <create+0x80>
80104b75:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b7a:	75 14                	jne    80104b90 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b7f:	89 f0                	mov    %esi,%eax
80104b81:	5b                   	pop    %ebx
80104b82:	5e                   	pop    %esi
80104b83:	5f                   	pop    %edi
80104b84:	5d                   	pop    %ebp
80104b85:	c3                   	ret    
80104b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	56                   	push   %esi
    return 0;
80104b94:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104b96:	e8 75 ce ff ff       	call   80101a10 <iunlockput>
    return 0;
80104b9b:	83 c4 10             	add    $0x10,%esp
}
80104b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba1:	89 f0                	mov    %esi,%eax
80104ba3:	5b                   	pop    %ebx
80104ba4:	5e                   	pop    %esi
80104ba5:	5f                   	pop    %edi
80104ba6:	5d                   	pop    %ebp
80104ba7:	c3                   	ret    
80104ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104bb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bb4:	83 ec 08             	sub    $0x8,%esp
80104bb7:	50                   	push   %eax
80104bb8:	ff 33                	push   (%ebx)
80104bba:	e8 51 ca ff ff       	call   80101610 <ialloc>
80104bbf:	83 c4 10             	add    $0x10,%esp
80104bc2:	89 c6                	mov    %eax,%esi
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	0f 84 cd 00 00 00    	je     80104c99 <create+0x189>
  ilock(ip);
80104bcc:	83 ec 0c             	sub    $0xc,%esp
80104bcf:	50                   	push   %eax
80104bd0:	e8 ab cb ff ff       	call   80101780 <ilock>
  ip->major = major;
80104bd5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104bd9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bdd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104be1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104be5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bee:	89 34 24             	mov    %esi,(%esp)
80104bf1:	e8 da ca ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bf6:	83 c4 10             	add    $0x10,%esp
80104bf9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bfe:	74 30                	je     80104c30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c00:	83 ec 04             	sub    $0x4,%esp
80104c03:	ff 76 04             	push   0x4(%esi)
80104c06:	57                   	push   %edi
80104c07:	53                   	push   %ebx
80104c08:	e8 d3 d3 ff ff       	call   80101fe0 <dirlink>
80104c0d:	83 c4 10             	add    $0x10,%esp
80104c10:	85 c0                	test   %eax,%eax
80104c12:	78 78                	js     80104c8c <create+0x17c>
  iunlockput(dp);
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	53                   	push   %ebx
80104c18:	e8 f3 cd ff ff       	call   80101a10 <iunlockput>
  return ip;
80104c1d:	83 c4 10             	add    $0x10,%esp
}
80104c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c23:	89 f0                	mov    %esi,%eax
80104c25:	5b                   	pop    %ebx
80104c26:	5e                   	pop    %esi
80104c27:	5f                   	pop    %edi
80104c28:	5d                   	pop    %ebp
80104c29:	c3                   	ret    
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c38:	53                   	push   %ebx
80104c39:	e8 92 ca ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c3e:	83 c4 0c             	add    $0xc,%esp
80104c41:	ff 76 04             	push   0x4(%esi)
80104c44:	68 d8 79 10 80       	push   $0x801079d8
80104c49:	56                   	push   %esi
80104c4a:	e8 91 d3 ff ff       	call   80101fe0 <dirlink>
80104c4f:	83 c4 10             	add    $0x10,%esp
80104c52:	85 c0                	test   %eax,%eax
80104c54:	78 18                	js     80104c6e <create+0x15e>
80104c56:	83 ec 04             	sub    $0x4,%esp
80104c59:	ff 73 04             	push   0x4(%ebx)
80104c5c:	68 d7 79 10 80       	push   $0x801079d7
80104c61:	56                   	push   %esi
80104c62:	e8 79 d3 ff ff       	call   80101fe0 <dirlink>
80104c67:	83 c4 10             	add    $0x10,%esp
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	79 92                	jns    80104c00 <create+0xf0>
      panic("create dots");
80104c6e:	83 ec 0c             	sub    $0xc,%esp
80104c71:	68 cb 79 10 80       	push   $0x801079cb
80104c76:	e8 05 b7 ff ff       	call   80100380 <panic>
80104c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop
}
80104c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c83:	31 f6                	xor    %esi,%esi
}
80104c85:	5b                   	pop    %ebx
80104c86:	89 f0                	mov    %esi,%eax
80104c88:	5e                   	pop    %esi
80104c89:	5f                   	pop    %edi
80104c8a:	5d                   	pop    %ebp
80104c8b:	c3                   	ret    
    panic("create: dirlink");
80104c8c:	83 ec 0c             	sub    $0xc,%esp
80104c8f:	68 da 79 10 80       	push   $0x801079da
80104c94:	e8 e7 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104c99:	83 ec 0c             	sub    $0xc,%esp
80104c9c:	68 bc 79 10 80       	push   $0x801079bc
80104ca1:	e8 da b6 ff ff       	call   80100380 <panic>
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi

80104cb0 <sys_dup>:
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104cb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104cb8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cbb:	50                   	push   %eax
80104cbc:	6a 00                	push   $0x0
80104cbe:	e8 9d fc ff ff       	call   80104960 <argint>
80104cc3:	83 c4 10             	add    $0x10,%esp
80104cc6:	85 c0                	test   %eax,%eax
80104cc8:	78 36                	js     80104d00 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cce:	77 30                	ja     80104d00 <sys_dup+0x50>
80104cd0:	e8 bb ec ff ff       	call   80103990 <myproc>
80104cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cd8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104cdc:	85 f6                	test   %esi,%esi
80104cde:	74 20                	je     80104d00 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ce0:	e8 ab ec ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ce5:	31 db                	xor    %ebx,%ebx
80104ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104cf0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104cf4:	85 d2                	test   %edx,%edx
80104cf6:	74 18                	je     80104d10 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104cf8:	83 c3 01             	add    $0x1,%ebx
80104cfb:	83 fb 10             	cmp    $0x10,%ebx
80104cfe:	75 f0                	jne    80104cf0 <sys_dup+0x40>
}
80104d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d08:	89 d8                	mov    %ebx,%eax
80104d0a:	5b                   	pop    %ebx
80104d0b:	5e                   	pop    %esi
80104d0c:	5d                   	pop    %ebp
80104d0d:	c3                   	ret    
80104d0e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d10:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d13:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d17:	56                   	push   %esi
80104d18:	e8 83 c1 ff ff       	call   80100ea0 <filedup>
  return fd;
80104d1d:	83 c4 10             	add    $0x10,%esp
}
80104d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d23:	89 d8                	mov    %ebx,%eax
80104d25:	5b                   	pop    %ebx
80104d26:	5e                   	pop    %esi
80104d27:	5d                   	pop    %ebp
80104d28:	c3                   	ret    
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d30 <sys_read>:
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d35:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d38:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d3b:	53                   	push   %ebx
80104d3c:	6a 00                	push   $0x0
80104d3e:	e8 1d fc ff ff       	call   80104960 <argint>
80104d43:	83 c4 10             	add    $0x10,%esp
80104d46:	85 c0                	test   %eax,%eax
80104d48:	78 5e                	js     80104da8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d4a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d4e:	77 58                	ja     80104da8 <sys_read+0x78>
80104d50:	e8 3b ec ff ff       	call   80103990 <myproc>
80104d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d58:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d5c:	85 f6                	test   %esi,%esi
80104d5e:	74 48                	je     80104da8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d60:	83 ec 08             	sub    $0x8,%esp
80104d63:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d66:	50                   	push   %eax
80104d67:	6a 02                	push   $0x2
80104d69:	e8 f2 fb ff ff       	call   80104960 <argint>
80104d6e:	83 c4 10             	add    $0x10,%esp
80104d71:	85 c0                	test   %eax,%eax
80104d73:	78 33                	js     80104da8 <sys_read+0x78>
80104d75:	83 ec 04             	sub    $0x4,%esp
80104d78:	ff 75 f0             	push   -0x10(%ebp)
80104d7b:	53                   	push   %ebx
80104d7c:	6a 01                	push   $0x1
80104d7e:	e8 2d fc ff ff       	call   801049b0 <argptr>
80104d83:	83 c4 10             	add    $0x10,%esp
80104d86:	85 c0                	test   %eax,%eax
80104d88:	78 1e                	js     80104da8 <sys_read+0x78>
  return fileread(f, p, n);
80104d8a:	83 ec 04             	sub    $0x4,%esp
80104d8d:	ff 75 f0             	push   -0x10(%ebp)
80104d90:	ff 75 f4             	push   -0xc(%ebp)
80104d93:	56                   	push   %esi
80104d94:	e8 87 c2 ff ff       	call   80101020 <fileread>
80104d99:	83 c4 10             	add    $0x10,%esp
}
80104d9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d9f:	5b                   	pop    %ebx
80104da0:	5e                   	pop    %esi
80104da1:	5d                   	pop    %ebp
80104da2:	c3                   	ret    
80104da3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104da7:	90                   	nop
    return -1;
80104da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dad:	eb ed                	jmp    80104d9c <sys_read+0x6c>
80104daf:	90                   	nop

80104db0 <sys_write>:
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104db5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104db8:	83 ec 10             	sub    $0x10,%esp
  myproc()->rusage.write_count++; // No matter fd/ptr is valid or not
80104dbb:	e8 d0 eb ff ff       	call   80103990 <myproc>
  if(argint(n, &fd) < 0)
80104dc0:	83 ec 08             	sub    $0x8,%esp
  myproc()->rusage.write_count++; // No matter fd/ptr is valid or not
80104dc3:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
  if(argint(n, &fd) < 0)
80104dca:	53                   	push   %ebx
80104dcb:	6a 00                	push   $0x0
80104dcd:	e8 8e fb ff ff       	call   80104960 <argint>
80104dd2:	83 c4 10             	add    $0x10,%esp
80104dd5:	85 c0                	test   %eax,%eax
80104dd7:	78 5f                	js     80104e38 <sys_write+0x88>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dd9:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ddd:	77 59                	ja     80104e38 <sys_write+0x88>
80104ddf:	e8 ac eb ff ff       	call   80103990 <myproc>
80104de4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104de7:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104deb:	85 f6                	test   %esi,%esi
80104ded:	74 49                	je     80104e38 <sys_write+0x88>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104def:	83 ec 08             	sub    $0x8,%esp
80104df2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104df5:	50                   	push   %eax
80104df6:	6a 02                	push   $0x2
80104df8:	e8 63 fb ff ff       	call   80104960 <argint>
80104dfd:	83 c4 10             	add    $0x10,%esp
80104e00:	85 c0                	test   %eax,%eax
80104e02:	78 34                	js     80104e38 <sys_write+0x88>
80104e04:	83 ec 04             	sub    $0x4,%esp
80104e07:	ff 75 f0             	push   -0x10(%ebp)
80104e0a:	53                   	push   %ebx
80104e0b:	6a 01                	push   $0x1
80104e0d:	e8 9e fb ff ff       	call   801049b0 <argptr>
80104e12:	83 c4 10             	add    $0x10,%esp
80104e15:	85 c0                	test   %eax,%eax
80104e17:	78 1f                	js     80104e38 <sys_write+0x88>
  return filewrite(f, p, n);
80104e19:	83 ec 04             	sub    $0x4,%esp
80104e1c:	ff 75 f0             	push   -0x10(%ebp)
80104e1f:	ff 75 f4             	push   -0xc(%ebp)
80104e22:	56                   	push   %esi
80104e23:	e8 88 c2 ff ff       	call   801010b0 <filewrite>
80104e28:	83 c4 10             	add    $0x10,%esp
}
80104e2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e2e:	5b                   	pop    %ebx
80104e2f:	5e                   	pop    %esi
80104e30:	5d                   	pop    %ebp
80104e31:	c3                   	ret    
80104e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104e38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e3d:	eb ec                	jmp    80104e2b <sys_write+0x7b>
80104e3f:	90                   	nop

80104e40 <sys_close>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e45:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e4b:	50                   	push   %eax
80104e4c:	6a 00                	push   $0x0
80104e4e:	e8 0d fb ff ff       	call   80104960 <argint>
80104e53:	83 c4 10             	add    $0x10,%esp
80104e56:	85 c0                	test   %eax,%eax
80104e58:	78 3e                	js     80104e98 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e5e:	77 38                	ja     80104e98 <sys_close+0x58>
80104e60:	e8 2b eb ff ff       	call   80103990 <myproc>
80104e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e68:	8d 5a 08             	lea    0x8(%edx),%ebx
80104e6b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104e6f:	85 f6                	test   %esi,%esi
80104e71:	74 25                	je     80104e98 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104e73:	e8 18 eb ff ff       	call   80103990 <myproc>
  fileclose(f);
80104e78:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e7b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104e82:	00 
  fileclose(f);
80104e83:	56                   	push   %esi
80104e84:	e8 67 c0 ff ff       	call   80100ef0 <fileclose>
  return 0;
80104e89:	83 c4 10             	add    $0x10,%esp
80104e8c:	31 c0                	xor    %eax,%eax
}
80104e8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e91:	5b                   	pop    %ebx
80104e92:	5e                   	pop    %esi
80104e93:	5d                   	pop    %ebp
80104e94:	c3                   	ret    
80104e95:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e9d:	eb ef                	jmp    80104e8e <sys_close+0x4e>
80104e9f:	90                   	nop

80104ea0 <sys_fstat>:
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ea5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ea8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eab:	53                   	push   %ebx
80104eac:	6a 00                	push   $0x0
80104eae:	e8 ad fa ff ff       	call   80104960 <argint>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	78 46                	js     80104f00 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ebe:	77 40                	ja     80104f00 <sys_fstat+0x60>
80104ec0:	e8 cb ea ff ff       	call   80103990 <myproc>
80104ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ec8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ecc:	85 f6                	test   %esi,%esi
80104ece:	74 30                	je     80104f00 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ed0:	83 ec 04             	sub    $0x4,%esp
80104ed3:	6a 14                	push   $0x14
80104ed5:	53                   	push   %ebx
80104ed6:	6a 01                	push   $0x1
80104ed8:	e8 d3 fa ff ff       	call   801049b0 <argptr>
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	78 1c                	js     80104f00 <sys_fstat+0x60>
  return filestat(f, st);
80104ee4:	83 ec 08             	sub    $0x8,%esp
80104ee7:	ff 75 f4             	push   -0xc(%ebp)
80104eea:	56                   	push   %esi
80104eeb:	e8 e0 c0 ff ff       	call   80100fd0 <filestat>
80104ef0:	83 c4 10             	add    $0x10,%esp
}
80104ef3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ef6:	5b                   	pop    %ebx
80104ef7:	5e                   	pop    %esi
80104ef8:	5d                   	pop    %ebp
80104ef9:	c3                   	ret    
80104efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f05:	eb ec                	jmp    80104ef3 <sys_fstat+0x53>
80104f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0e:	66 90                	xchg   %ax,%ax

80104f10 <sys_link>:
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f15:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f18:	53                   	push   %ebx
80104f19:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f1c:	50                   	push   %eax
80104f1d:	6a 00                	push   $0x0
80104f1f:	e8 fc fa ff ff       	call   80104a20 <argstr>
80104f24:	83 c4 10             	add    $0x10,%esp
80104f27:	85 c0                	test   %eax,%eax
80104f29:	0f 88 fb 00 00 00    	js     8010502a <sys_link+0x11a>
80104f2f:	83 ec 08             	sub    $0x8,%esp
80104f32:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f35:	50                   	push   %eax
80104f36:	6a 01                	push   $0x1
80104f38:	e8 e3 fa ff ff       	call   80104a20 <argstr>
80104f3d:	83 c4 10             	add    $0x10,%esp
80104f40:	85 c0                	test   %eax,%eax
80104f42:	0f 88 e2 00 00 00    	js     8010502a <sys_link+0x11a>
  begin_op();
80104f48:	e8 13 de ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
80104f4d:	83 ec 0c             	sub    $0xc,%esp
80104f50:	ff 75 d4             	push   -0x2c(%ebp)
80104f53:	e8 48 d1 ff ff       	call   801020a0 <namei>
80104f58:	83 c4 10             	add    $0x10,%esp
80104f5b:	89 c3                	mov    %eax,%ebx
80104f5d:	85 c0                	test   %eax,%eax
80104f5f:	0f 84 e4 00 00 00    	je     80105049 <sys_link+0x139>
  ilock(ip);
80104f65:	83 ec 0c             	sub    $0xc,%esp
80104f68:	50                   	push   %eax
80104f69:	e8 12 c8 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80104f6e:	83 c4 10             	add    $0x10,%esp
80104f71:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f76:	0f 84 b5 00 00 00    	je     80105031 <sys_link+0x121>
  iupdate(ip);
80104f7c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f7f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f84:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f87:	53                   	push   %ebx
80104f88:	e8 43 c7 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80104f8d:	89 1c 24             	mov    %ebx,(%esp)
80104f90:	e8 cb c8 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f95:	58                   	pop    %eax
80104f96:	5a                   	pop    %edx
80104f97:	57                   	push   %edi
80104f98:	ff 75 d0             	push   -0x30(%ebp)
80104f9b:	e8 20 d1 ff ff       	call   801020c0 <nameiparent>
80104fa0:	83 c4 10             	add    $0x10,%esp
80104fa3:	89 c6                	mov    %eax,%esi
80104fa5:	85 c0                	test   %eax,%eax
80104fa7:	74 5b                	je     80105004 <sys_link+0xf4>
  ilock(dp);
80104fa9:	83 ec 0c             	sub    $0xc,%esp
80104fac:	50                   	push   %eax
80104fad:	e8 ce c7 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fb2:	8b 03                	mov    (%ebx),%eax
80104fb4:	83 c4 10             	add    $0x10,%esp
80104fb7:	39 06                	cmp    %eax,(%esi)
80104fb9:	75 3d                	jne    80104ff8 <sys_link+0xe8>
80104fbb:	83 ec 04             	sub    $0x4,%esp
80104fbe:	ff 73 04             	push   0x4(%ebx)
80104fc1:	57                   	push   %edi
80104fc2:	56                   	push   %esi
80104fc3:	e8 18 d0 ff ff       	call   80101fe0 <dirlink>
80104fc8:	83 c4 10             	add    $0x10,%esp
80104fcb:	85 c0                	test   %eax,%eax
80104fcd:	78 29                	js     80104ff8 <sys_link+0xe8>
  iunlockput(dp);
80104fcf:	83 ec 0c             	sub    $0xc,%esp
80104fd2:	56                   	push   %esi
80104fd3:	e8 38 ca ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80104fd8:	89 1c 24             	mov    %ebx,(%esp)
80104fdb:	e8 d0 c8 ff ff       	call   801018b0 <iput>
  end_op();
80104fe0:	e8 eb dd ff ff       	call   80102dd0 <end_op>
  return 0;
80104fe5:	83 c4 10             	add    $0x10,%esp
80104fe8:	31 c0                	xor    %eax,%eax
}
80104fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fed:	5b                   	pop    %ebx
80104fee:	5e                   	pop    %esi
80104fef:	5f                   	pop    %edi
80104ff0:	5d                   	pop    %ebp
80104ff1:	c3                   	ret    
80104ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104ff8:	83 ec 0c             	sub    $0xc,%esp
80104ffb:	56                   	push   %esi
80104ffc:	e8 0f ca ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105001:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105004:	83 ec 0c             	sub    $0xc,%esp
80105007:	53                   	push   %ebx
80105008:	e8 73 c7 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010500d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105012:	89 1c 24             	mov    %ebx,(%esp)
80105015:	e8 b6 c6 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010501a:	89 1c 24             	mov    %ebx,(%esp)
8010501d:	e8 ee c9 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105022:	e8 a9 dd ff ff       	call   80102dd0 <end_op>
  return -1;
80105027:	83 c4 10             	add    $0x10,%esp
8010502a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502f:	eb b9                	jmp    80104fea <sys_link+0xda>
    iunlockput(ip);
80105031:	83 ec 0c             	sub    $0xc,%esp
80105034:	53                   	push   %ebx
80105035:	e8 d6 c9 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010503a:	e8 91 dd ff ff       	call   80102dd0 <end_op>
    return -1;
8010503f:	83 c4 10             	add    $0x10,%esp
80105042:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105047:	eb a1                	jmp    80104fea <sys_link+0xda>
    end_op();
80105049:	e8 82 dd ff ff       	call   80102dd0 <end_op>
    return -1;
8010504e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105053:	eb 95                	jmp    80104fea <sys_link+0xda>
80105055:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105060 <sys_unlink>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105065:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105068:	53                   	push   %ebx
80105069:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010506c:	50                   	push   %eax
8010506d:	6a 00                	push   $0x0
8010506f:	e8 ac f9 ff ff       	call   80104a20 <argstr>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	0f 88 7a 01 00 00    	js     801051f9 <sys_unlink+0x199>
  begin_op();
8010507f:	e8 dc dc ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105084:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105087:	83 ec 08             	sub    $0x8,%esp
8010508a:	53                   	push   %ebx
8010508b:	ff 75 c0             	push   -0x40(%ebp)
8010508e:	e8 2d d0 ff ff       	call   801020c0 <nameiparent>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105099:	85 c0                	test   %eax,%eax
8010509b:	0f 84 62 01 00 00    	je     80105203 <sys_unlink+0x1a3>
  ilock(dp);
801050a1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	57                   	push   %edi
801050a8:	e8 d3 c6 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050ad:	58                   	pop    %eax
801050ae:	5a                   	pop    %edx
801050af:	68 d8 79 10 80       	push   $0x801079d8
801050b4:	53                   	push   %ebx
801050b5:	e8 06 cc ff ff       	call   80101cc0 <namecmp>
801050ba:	83 c4 10             	add    $0x10,%esp
801050bd:	85 c0                	test   %eax,%eax
801050bf:	0f 84 fb 00 00 00    	je     801051c0 <sys_unlink+0x160>
801050c5:	83 ec 08             	sub    $0x8,%esp
801050c8:	68 d7 79 10 80       	push   $0x801079d7
801050cd:	53                   	push   %ebx
801050ce:	e8 ed cb ff ff       	call   80101cc0 <namecmp>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	0f 84 e2 00 00 00    	je     801051c0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050de:	83 ec 04             	sub    $0x4,%esp
801050e1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050e4:	50                   	push   %eax
801050e5:	53                   	push   %ebx
801050e6:	57                   	push   %edi
801050e7:	e8 f4 cb ff ff       	call   80101ce0 <dirlookup>
801050ec:	83 c4 10             	add    $0x10,%esp
801050ef:	89 c3                	mov    %eax,%ebx
801050f1:	85 c0                	test   %eax,%eax
801050f3:	0f 84 c7 00 00 00    	je     801051c0 <sys_unlink+0x160>
  ilock(ip);
801050f9:	83 ec 0c             	sub    $0xc,%esp
801050fc:	50                   	push   %eax
801050fd:	e8 7e c6 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105102:	83 c4 10             	add    $0x10,%esp
80105105:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010510a:	0f 8e 1c 01 00 00    	jle    8010522c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105110:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105115:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105118:	74 66                	je     80105180 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010511a:	83 ec 04             	sub    $0x4,%esp
8010511d:	6a 10                	push   $0x10
8010511f:	6a 00                	push   $0x0
80105121:	57                   	push   %edi
80105122:	e8 79 f5 ff ff       	call   801046a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105127:	6a 10                	push   $0x10
80105129:	ff 75 c4             	push   -0x3c(%ebp)
8010512c:	57                   	push   %edi
8010512d:	ff 75 b4             	push   -0x4c(%ebp)
80105130:	e8 5b ca ff ff       	call   80101b90 <writei>
80105135:	83 c4 20             	add    $0x20,%esp
80105138:	83 f8 10             	cmp    $0x10,%eax
8010513b:	0f 85 de 00 00 00    	jne    8010521f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105141:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105146:	0f 84 94 00 00 00    	je     801051e0 <sys_unlink+0x180>
  iunlockput(dp);
8010514c:	83 ec 0c             	sub    $0xc,%esp
8010514f:	ff 75 b4             	push   -0x4c(%ebp)
80105152:	e8 b9 c8 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105157:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010515c:	89 1c 24             	mov    %ebx,(%esp)
8010515f:	e8 6c c5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105164:	89 1c 24             	mov    %ebx,(%esp)
80105167:	e8 a4 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010516c:	e8 5f dc ff ff       	call   80102dd0 <end_op>
  return 0;
80105171:	83 c4 10             	add    $0x10,%esp
80105174:	31 c0                	xor    %eax,%eax
}
80105176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105179:	5b                   	pop    %ebx
8010517a:	5e                   	pop    %esi
8010517b:	5f                   	pop    %edi
8010517c:	5d                   	pop    %ebp
8010517d:	c3                   	ret    
8010517e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105180:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105184:	76 94                	jbe    8010511a <sys_unlink+0xba>
80105186:	be 20 00 00 00       	mov    $0x20,%esi
8010518b:	eb 0b                	jmp    80105198 <sys_unlink+0x138>
8010518d:	8d 76 00             	lea    0x0(%esi),%esi
80105190:	83 c6 10             	add    $0x10,%esi
80105193:	3b 73 58             	cmp    0x58(%ebx),%esi
80105196:	73 82                	jae    8010511a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105198:	6a 10                	push   $0x10
8010519a:	56                   	push   %esi
8010519b:	57                   	push   %edi
8010519c:	53                   	push   %ebx
8010519d:	e8 ee c8 ff ff       	call   80101a90 <readi>
801051a2:	83 c4 10             	add    $0x10,%esp
801051a5:	83 f8 10             	cmp    $0x10,%eax
801051a8:	75 68                	jne    80105212 <sys_unlink+0x1b2>
    if(de.inum != 0)
801051aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051af:	74 df                	je     80105190 <sys_unlink+0x130>
    iunlockput(ip);
801051b1:	83 ec 0c             	sub    $0xc,%esp
801051b4:	53                   	push   %ebx
801051b5:	e8 56 c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051ba:	83 c4 10             	add    $0x10,%esp
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801051c0:	83 ec 0c             	sub    $0xc,%esp
801051c3:	ff 75 b4             	push   -0x4c(%ebp)
801051c6:	e8 45 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051cb:	e8 00 dc ff ff       	call   80102dd0 <end_op>
  return -1;
801051d0:	83 c4 10             	add    $0x10,%esp
801051d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d8:	eb 9c                	jmp    80105176 <sys_unlink+0x116>
801051da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801051e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801051e3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801051e6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801051eb:	50                   	push   %eax
801051ec:	e8 df c4 ff ff       	call   801016d0 <iupdate>
801051f1:	83 c4 10             	add    $0x10,%esp
801051f4:	e9 53 ff ff ff       	jmp    8010514c <sys_unlink+0xec>
    return -1;
801051f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051fe:	e9 73 ff ff ff       	jmp    80105176 <sys_unlink+0x116>
    end_op();
80105203:	e8 c8 db ff ff       	call   80102dd0 <end_op>
    return -1;
80105208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520d:	e9 64 ff ff ff       	jmp    80105176 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105212:	83 ec 0c             	sub    $0xc,%esp
80105215:	68 fc 79 10 80       	push   $0x801079fc
8010521a:	e8 61 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010521f:	83 ec 0c             	sub    $0xc,%esp
80105222:	68 0e 7a 10 80       	push   $0x80107a0e
80105227:	e8 54 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010522c:	83 ec 0c             	sub    $0xc,%esp
8010522f:	68 ea 79 10 80       	push   $0x801079ea
80105234:	e8 47 b1 ff ff       	call   80100380 <panic>
80105239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105240 <sys_open>:

int
sys_open(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	57                   	push   %edi
80105244:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105245:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105248:	53                   	push   %ebx
80105249:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010524c:	50                   	push   %eax
8010524d:	6a 00                	push   $0x0
8010524f:	e8 cc f7 ff ff       	call   80104a20 <argstr>
80105254:	83 c4 10             	add    $0x10,%esp
80105257:	85 c0                	test   %eax,%eax
80105259:	0f 88 8e 00 00 00    	js     801052ed <sys_open+0xad>
8010525f:	83 ec 08             	sub    $0x8,%esp
80105262:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105265:	50                   	push   %eax
80105266:	6a 01                	push   $0x1
80105268:	e8 f3 f6 ff ff       	call   80104960 <argint>
8010526d:	83 c4 10             	add    $0x10,%esp
80105270:	85 c0                	test   %eax,%eax
80105272:	78 79                	js     801052ed <sys_open+0xad>
    return -1;

  begin_op();
80105274:	e8 e7 da ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80105279:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010527d:	75 79                	jne    801052f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010527f:	83 ec 0c             	sub    $0xc,%esp
80105282:	ff 75 e0             	push   -0x20(%ebp)
80105285:	e8 16 ce ff ff       	call   801020a0 <namei>
8010528a:	83 c4 10             	add    $0x10,%esp
8010528d:	89 c6                	mov    %eax,%esi
8010528f:	85 c0                	test   %eax,%eax
80105291:	0f 84 7e 00 00 00    	je     80105315 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105297:	83 ec 0c             	sub    $0xc,%esp
8010529a:	50                   	push   %eax
8010529b:	e8 e0 c4 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052a0:	83 c4 10             	add    $0x10,%esp
801052a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052a8:	0f 84 c2 00 00 00    	je     80105370 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052ae:	e8 7d bb ff ff       	call   80100e30 <filealloc>
801052b3:	89 c7                	mov    %eax,%edi
801052b5:	85 c0                	test   %eax,%eax
801052b7:	74 23                	je     801052dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801052b9:	e8 d2 e6 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052c4:	85 d2                	test   %edx,%edx
801052c6:	74 60                	je     80105328 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801052c8:	83 c3 01             	add    $0x1,%ebx
801052cb:	83 fb 10             	cmp    $0x10,%ebx
801052ce:	75 f0                	jne    801052c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052d0:	83 ec 0c             	sub    $0xc,%esp
801052d3:	57                   	push   %edi
801052d4:	e8 17 bc ff ff       	call   80100ef0 <fileclose>
801052d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052dc:	83 ec 0c             	sub    $0xc,%esp
801052df:	56                   	push   %esi
801052e0:	e8 2b c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
801052e5:	e8 e6 da ff ff       	call   80102dd0 <end_op>
    return -1;
801052ea:	83 c4 10             	add    $0x10,%esp
801052ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052f2:	eb 6d                	jmp    80105361 <sys_open+0x121>
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052fe:	31 c9                	xor    %ecx,%ecx
80105300:	ba 02 00 00 00       	mov    $0x2,%edx
80105305:	6a 00                	push   $0x0
80105307:	e8 04 f8 ff ff       	call   80104b10 <create>
    if(ip == 0){
8010530c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010530f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105311:	85 c0                	test   %eax,%eax
80105313:	75 99                	jne    801052ae <sys_open+0x6e>
      end_op();
80105315:	e8 b6 da ff ff       	call   80102dd0 <end_op>
      return -1;
8010531a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010531f:	eb 40                	jmp    80105361 <sys_open+0x121>
80105321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105328:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010532b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010532f:	56                   	push   %esi
80105330:	e8 2b c5 ff ff       	call   80101860 <iunlock>
  end_op();
80105335:	e8 96 da ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
8010533a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105340:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105343:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105346:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105349:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010534b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105352:	f7 d0                	not    %eax
80105354:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105357:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010535a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010535d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105361:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105364:	89 d8                	mov    %ebx,%eax
80105366:	5b                   	pop    %ebx
80105367:	5e                   	pop    %esi
80105368:	5f                   	pop    %edi
80105369:	5d                   	pop    %ebp
8010536a:	c3                   	ret    
8010536b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010536f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105370:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105373:	85 c9                	test   %ecx,%ecx
80105375:	0f 84 33 ff ff ff    	je     801052ae <sys_open+0x6e>
8010537b:	e9 5c ff ff ff       	jmp    801052dc <sys_open+0x9c>

80105380 <sys_mkdir>:

int
sys_mkdir(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105386:	e8 d5 d9 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010538b:	83 ec 08             	sub    $0x8,%esp
8010538e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105391:	50                   	push   %eax
80105392:	6a 00                	push   $0x0
80105394:	e8 87 f6 ff ff       	call   80104a20 <argstr>
80105399:	83 c4 10             	add    $0x10,%esp
8010539c:	85 c0                	test   %eax,%eax
8010539e:	78 30                	js     801053d0 <sys_mkdir+0x50>
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a6:	31 c9                	xor    %ecx,%ecx
801053a8:	ba 01 00 00 00       	mov    $0x1,%edx
801053ad:	6a 00                	push   $0x0
801053af:	e8 5c f7 ff ff       	call   80104b10 <create>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	74 15                	je     801053d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053bb:	83 ec 0c             	sub    $0xc,%esp
801053be:	50                   	push   %eax
801053bf:	e8 4c c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053c4:	e8 07 da ff ff       	call   80102dd0 <end_op>
  return 0;
801053c9:	83 c4 10             	add    $0x10,%esp
801053cc:	31 c0                	xor    %eax,%eax
}
801053ce:	c9                   	leave  
801053cf:	c3                   	ret    
    end_op();
801053d0:	e8 fb d9 ff ff       	call   80102dd0 <end_op>
    return -1;
801053d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053da:	c9                   	leave  
801053db:	c3                   	ret    
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053e0 <sys_mknod>:

int
sys_mknod(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053e6:	e8 75 d9 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053eb:	83 ec 08             	sub    $0x8,%esp
801053ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053f1:	50                   	push   %eax
801053f2:	6a 00                	push   $0x0
801053f4:	e8 27 f6 ff ff       	call   80104a20 <argstr>
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	85 c0                	test   %eax,%eax
801053fe:	78 60                	js     80105460 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105400:	83 ec 08             	sub    $0x8,%esp
80105403:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105406:	50                   	push   %eax
80105407:	6a 01                	push   $0x1
80105409:	e8 52 f5 ff ff       	call   80104960 <argint>
  if((argstr(0, &path)) < 0 ||
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	85 c0                	test   %eax,%eax
80105413:	78 4b                	js     80105460 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105415:	83 ec 08             	sub    $0x8,%esp
80105418:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010541b:	50                   	push   %eax
8010541c:	6a 02                	push   $0x2
8010541e:	e8 3d f5 ff ff       	call   80104960 <argint>
     argint(1, &major) < 0 ||
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	78 36                	js     80105460 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010542a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010542e:	83 ec 0c             	sub    $0xc,%esp
80105431:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105435:	ba 03 00 00 00       	mov    $0x3,%edx
8010543a:	50                   	push   %eax
8010543b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010543e:	e8 cd f6 ff ff       	call   80104b10 <create>
     argint(2, &minor) < 0 ||
80105443:	83 c4 10             	add    $0x10,%esp
80105446:	85 c0                	test   %eax,%eax
80105448:	74 16                	je     80105460 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010544a:	83 ec 0c             	sub    $0xc,%esp
8010544d:	50                   	push   %eax
8010544e:	e8 bd c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105453:	e8 78 d9 ff ff       	call   80102dd0 <end_op>
  return 0;
80105458:	83 c4 10             	add    $0x10,%esp
8010545b:	31 c0                	xor    %eax,%eax
}
8010545d:	c9                   	leave  
8010545e:	c3                   	ret    
8010545f:	90                   	nop
    end_op();
80105460:	e8 6b d9 ff ff       	call   80102dd0 <end_op>
    return -1;
80105465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010546a:	c9                   	leave  
8010546b:	c3                   	ret    
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_chdir>:

int
sys_chdir(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	56                   	push   %esi
80105474:	53                   	push   %ebx
80105475:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105478:	e8 13 e5 ff ff       	call   80103990 <myproc>
8010547d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010547f:	e8 dc d8 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105484:	83 ec 08             	sub    $0x8,%esp
80105487:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010548a:	50                   	push   %eax
8010548b:	6a 00                	push   $0x0
8010548d:	e8 8e f5 ff ff       	call   80104a20 <argstr>
80105492:	83 c4 10             	add    $0x10,%esp
80105495:	85 c0                	test   %eax,%eax
80105497:	78 77                	js     80105510 <sys_chdir+0xa0>
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	ff 75 f4             	push   -0xc(%ebp)
8010549f:	e8 fc cb ff ff       	call   801020a0 <namei>
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	89 c3                	mov    %eax,%ebx
801054a9:	85 c0                	test   %eax,%eax
801054ab:	74 63                	je     80105510 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054ad:	83 ec 0c             	sub    $0xc,%esp
801054b0:	50                   	push   %eax
801054b1:	e8 ca c2 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054be:	75 30                	jne    801054f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	53                   	push   %ebx
801054c4:	e8 97 c3 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
801054c9:	58                   	pop    %eax
801054ca:	ff 76 68             	push   0x68(%esi)
801054cd:	e8 de c3 ff ff       	call   801018b0 <iput>
  end_op();
801054d2:	e8 f9 d8 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
801054d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054da:	83 c4 10             	add    $0x10,%esp
801054dd:	31 c0                	xor    %eax,%eax
}
801054df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054e2:	5b                   	pop    %ebx
801054e3:	5e                   	pop    %esi
801054e4:	5d                   	pop    %ebp
801054e5:	c3                   	ret    
801054e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	53                   	push   %ebx
801054f4:	e8 17 c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801054f9:	e8 d2 d8 ff ff       	call   80102dd0 <end_op>
    return -1;
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105506:	eb d7                	jmp    801054df <sys_chdir+0x6f>
80105508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
    end_op();
80105510:	e8 bb d8 ff ff       	call   80102dd0 <end_op>
    return -1;
80105515:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551a:	eb c3                	jmp    801054df <sys_chdir+0x6f>
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_exec>:

int
sys_exec(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	57                   	push   %edi
80105524:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105525:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010552b:	53                   	push   %ebx
8010552c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105532:	50                   	push   %eax
80105533:	6a 00                	push   $0x0
80105535:	e8 e6 f4 ff ff       	call   80104a20 <argstr>
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	85 c0                	test   %eax,%eax
8010553f:	0f 88 87 00 00 00    	js     801055cc <sys_exec+0xac>
80105545:	83 ec 08             	sub    $0x8,%esp
80105548:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010554e:	50                   	push   %eax
8010554f:	6a 01                	push   $0x1
80105551:	e8 0a f4 ff ff       	call   80104960 <argint>
80105556:	83 c4 10             	add    $0x10,%esp
80105559:	85 c0                	test   %eax,%eax
8010555b:	78 6f                	js     801055cc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010555d:	83 ec 04             	sub    $0x4,%esp
80105560:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105566:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105568:	68 80 00 00 00       	push   $0x80
8010556d:	6a 00                	push   $0x0
8010556f:	56                   	push   %esi
80105570:	e8 2b f1 ff ff       	call   801046a0 <memset>
80105575:	83 c4 10             	add    $0x10,%esp
80105578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010557f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105580:	83 ec 08             	sub    $0x8,%esp
80105583:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105589:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105590:	50                   	push   %eax
80105591:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105597:	01 f8                	add    %edi,%eax
80105599:	50                   	push   %eax
8010559a:	e8 31 f3 ff ff       	call   801048d0 <fetchint>
8010559f:	83 c4 10             	add    $0x10,%esp
801055a2:	85 c0                	test   %eax,%eax
801055a4:	78 26                	js     801055cc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801055a6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055ac:	85 c0                	test   %eax,%eax
801055ae:	74 30                	je     801055e0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055b0:	83 ec 08             	sub    $0x8,%esp
801055b3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801055b6:	52                   	push   %edx
801055b7:	50                   	push   %eax
801055b8:	e8 53 f3 ff ff       	call   80104910 <fetchstr>
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	85 c0                	test   %eax,%eax
801055c2:	78 08                	js     801055cc <sys_exec+0xac>
  for(i=0;; i++){
801055c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055c7:	83 fb 20             	cmp    $0x20,%ebx
801055ca:	75 b4                	jne    80105580 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801055cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d4:	5b                   	pop    %ebx
801055d5:	5e                   	pop    %esi
801055d6:	5f                   	pop    %edi
801055d7:	5d                   	pop    %ebp
801055d8:	c3                   	ret    
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801055e0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055e7:	00 00 00 00 
  return exec(path, argv);
801055eb:	83 ec 08             	sub    $0x8,%esp
801055ee:	56                   	push   %esi
801055ef:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801055f5:	e8 b6 b4 ff ff       	call   80100ab0 <exec>
801055fa:	83 c4 10             	add    $0x10,%esp
}
801055fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105600:	5b                   	pop    %ebx
80105601:	5e                   	pop    %esi
80105602:	5f                   	pop    %edi
80105603:	5d                   	pop    %ebp
80105604:	c3                   	ret    
80105605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_pipe>:

int
sys_pipe(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105615:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105618:	53                   	push   %ebx
80105619:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010561c:	6a 08                	push   $0x8
8010561e:	50                   	push   %eax
8010561f:	6a 00                	push   $0x0
80105621:	e8 8a f3 ff ff       	call   801049b0 <argptr>
80105626:	83 c4 10             	add    $0x10,%esp
80105629:	85 c0                	test   %eax,%eax
8010562b:	78 4a                	js     80105677 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010562d:	83 ec 08             	sub    $0x8,%esp
80105630:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105633:	50                   	push   %eax
80105634:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105637:	50                   	push   %eax
80105638:	e8 f3 dd ff ff       	call   80103430 <pipealloc>
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	85 c0                	test   %eax,%eax
80105642:	78 33                	js     80105677 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105644:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105647:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105649:	e8 42 e3 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010564e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105650:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105654:	85 f6                	test   %esi,%esi
80105656:	74 28                	je     80105680 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105658:	83 c3 01             	add    $0x1,%ebx
8010565b:	83 fb 10             	cmp    $0x10,%ebx
8010565e:	75 f0                	jne    80105650 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	ff 75 e0             	push   -0x20(%ebp)
80105666:	e8 85 b8 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010566b:	58                   	pop    %eax
8010566c:	ff 75 e4             	push   -0x1c(%ebp)
8010566f:	e8 7c b8 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105674:	83 c4 10             	add    $0x10,%esp
80105677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567c:	eb 53                	jmp    801056d1 <sys_pipe+0xc1>
8010567e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105680:	8d 73 08             	lea    0x8(%ebx),%esi
80105683:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105687:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010568a:	e8 01 e3 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010568f:	31 d2                	xor    %edx,%edx
80105691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105698:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010569c:	85 c9                	test   %ecx,%ecx
8010569e:	74 20                	je     801056c0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801056a0:	83 c2 01             	add    $0x1,%edx
801056a3:	83 fa 10             	cmp    $0x10,%edx
801056a6:	75 f0                	jne    80105698 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801056a8:	e8 e3 e2 ff ff       	call   80103990 <myproc>
801056ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056b4:	00 
801056b5:	eb a9                	jmp    80105660 <sys_pipe+0x50>
801056b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056cf:	31 c0                	xor    %eax,%eax
}
801056d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056d4:	5b                   	pop    %ebx
801056d5:	5e                   	pop    %esi
801056d6:	5f                   	pop    %edi
801056d7:	5d                   	pop    %ebp
801056d8:	c3                   	ret    
801056d9:	66 90                	xchg   %ax,%ax
801056db:	66 90                	xchg   %ax,%ax
801056dd:	66 90                	xchg   %ax,%ax
801056df:	90                   	nop

801056e0 <sys_fork>:
#include "stat.h"

int
sys_fork(void)
{
  return fork();
801056e0:	e9 4b e4 ff ff       	jmp    80103b30 <fork>
801056e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056f0 <sys_exit>:
}

int
sys_exit(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801056f6:	e8 b5 e6 ff ff       	call   80103db0 <exit>
  return 0;  // not reached
}
801056fb:	31 c0                	xor    %eax,%eax
801056fd:	c9                   	leave  
801056fe:	c3                   	ret    
801056ff:	90                   	nop

80105700 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105700:	e9 db e7 ff ff       	jmp    80103ee0 <wait>
80105705:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_kill>:
}

int
sys_kill(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105716:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105719:	50                   	push   %eax
8010571a:	6a 00                	push   $0x0
8010571c:	e8 3f f2 ff ff       	call   80104960 <argint>
80105721:	83 c4 10             	add    $0x10,%esp
80105724:	85 c0                	test   %eax,%eax
80105726:	78 18                	js     80105740 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105728:	83 ec 0c             	sub    $0xc,%esp
8010572b:	ff 75 f4             	push   -0xc(%ebp)
8010572e:	e8 6d ea ff ff       	call   801041a0 <kill>
80105733:	83 c4 10             	add    $0x10,%esp
}
80105736:	c9                   	leave  
80105737:	c3                   	ret    
80105738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573f:	90                   	nop
80105740:	c9                   	leave  
    return -1;
80105741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105746:	c3                   	ret    
80105747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574e:	66 90                	xchg   %ax,%ax

80105750 <sys_getpid>:

int
sys_getpid(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105756:	e8 35 e2 ff ff       	call   80103990 <myproc>
8010575b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010575e:	c9                   	leave  
8010575f:	c3                   	ret    

80105760 <sys_sbrk>:

int
sys_sbrk(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105764:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105767:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010576a:	50                   	push   %eax
8010576b:	6a 00                	push   $0x0
8010576d:	e8 ee f1 ff ff       	call   80104960 <argint>
80105772:	83 c4 10             	add    $0x10,%esp
80105775:	85 c0                	test   %eax,%eax
80105777:	78 27                	js     801057a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105779:	e8 12 e2 ff ff       	call   80103990 <myproc>
  if(growproc(n) < 0)
8010577e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105781:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105783:	ff 75 f4             	push   -0xc(%ebp)
80105786:	e8 25 e3 ff ff       	call   80103ab0 <growproc>
8010578b:	83 c4 10             	add    $0x10,%esp
8010578e:	85 c0                	test   %eax,%eax
80105790:	78 0e                	js     801057a0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105792:	89 d8                	mov    %ebx,%eax
80105794:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105797:	c9                   	leave  
80105798:	c3                   	ret    
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057a0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057a5:	eb eb                	jmp    80105792 <sys_sbrk+0x32>
801057a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ae:	66 90                	xchg   %ax,%ax

801057b0 <sys_sleep>:

int
sys_sleep(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ba:	50                   	push   %eax
801057bb:	6a 00                	push   $0x0
801057bd:	e8 9e f1 ff ff       	call   80104960 <argint>
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	85 c0                	test   %eax,%eax
801057c7:	0f 88 8a 00 00 00    	js     80105857 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801057cd:	83 ec 0c             	sub    $0xc,%esp
801057d0:	68 80 40 11 80       	push   $0x80114080
801057d5:	e8 06 ee ff ff       	call   801045e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801057dd:	8b 1d 60 40 11 80    	mov    0x80114060,%ebx
  while(ticks - ticks0 < n){
801057e3:	83 c4 10             	add    $0x10,%esp
801057e6:	85 d2                	test   %edx,%edx
801057e8:	75 27                	jne    80105811 <sys_sleep+0x61>
801057ea:	eb 54                	jmp    80105840 <sys_sleep+0x90>
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	68 80 40 11 80       	push   $0x80114080
801057f8:	68 60 40 11 80       	push   $0x80114060
801057fd:	e8 6e e8 ff ff       	call   80104070 <sleep>
  while(ticks - ticks0 < n){
80105802:	a1 60 40 11 80       	mov    0x80114060,%eax
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	29 d8                	sub    %ebx,%eax
8010580c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010580f:	73 2f                	jae    80105840 <sys_sleep+0x90>
    if(myproc()->killed){
80105811:	e8 7a e1 ff ff       	call   80103990 <myproc>
80105816:	8b 40 24             	mov    0x24(%eax),%eax
80105819:	85 c0                	test   %eax,%eax
8010581b:	74 d3                	je     801057f0 <sys_sleep+0x40>
      release(&tickslock);
8010581d:	83 ec 0c             	sub    $0xc,%esp
80105820:	68 80 40 11 80       	push   $0x80114080
80105825:	e8 56 ed ff ff       	call   80104580 <release>
  }
  release(&tickslock);
  return 0;
}
8010582a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105835:	c9                   	leave  
80105836:	c3                   	ret    
80105837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	68 80 40 11 80       	push   $0x80114080
80105848:	e8 33 ed ff ff       	call   80104580 <release>
  return 0;
8010584d:	83 c4 10             	add    $0x10,%esp
80105850:	31 c0                	xor    %eax,%eax
}
80105852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105855:	c9                   	leave  
80105856:	c3                   	ret    
    return -1;
80105857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585c:	eb f4                	jmp    80105852 <sys_sleep+0xa2>
8010585e:	66 90                	xchg   %ax,%ax

80105860 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	53                   	push   %ebx
80105864:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105867:	68 80 40 11 80       	push   $0x80114080
8010586c:	e8 6f ed ff ff       	call   801045e0 <acquire>
  xticks = ticks;
80105871:	8b 1d 60 40 11 80    	mov    0x80114060,%ebx
  release(&tickslock);
80105877:	c7 04 24 80 40 11 80 	movl   $0x80114080,(%esp)
8010587e:	e8 fd ec ff ff       	call   80104580 <release>
  return xticks;
}
80105883:	89 d8                	mov    %ebx,%eax
80105885:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105888:	c9                   	leave  
80105889:	c3                   	ret    
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105890 <sys_getrusage>:

// New feature `getrusage()` to get the information of the
// current process, which can provide user some insight of the process
int
sys_getrusage(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	83 ec 1c             	sub    $0x1c,%esp
  struct rusage *u;

  if(argptr(0, (void*)&u, sizeof(struct rusage)) < 0)
80105896:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105899:	6a 10                	push   $0x10
8010589b:	50                   	push   %eax
8010589c:	6a 00                	push   $0x0
8010589e:	e8 0d f1 ff ff       	call   801049b0 <argptr>
801058a3:	83 c4 10             	add    $0x10,%esp
801058a6:	85 c0                	test   %eax,%eax
801058a8:	78 3e                	js     801058e8 <sys_getrusage+0x58>
    return -1;
  if(u == 0)
801058aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ad:	85 c0                	test   %eax,%eax
801058af:	74 37                	je     801058e8 <sys_getrusage+0x58>
    return -1;

  struct proc *p = myproc();
801058b1:	e8 da e0 ff ff       	call   80103990 <myproc>
  if(p == 0)
801058b6:	85 c0                	test   %eax,%eax
801058b8:	74 2e                	je     801058e8 <sys_getrusage+0x58>
    return -1;

  u->utime = p->rusage.utime;
801058ba:	8b 48 7c             	mov    0x7c(%eax),%ecx
801058bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058c0:	89 0a                	mov    %ecx,(%edx)
  u->stime = p->rusage.stime;
801058c2:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
801058c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058cb:	89 4a 04             	mov    %ecx,0x4(%edx)
  u->nvcsw = p->rusage.nvcsw;
801058ce:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801058d4:	89 4a 08             	mov    %ecx,0x8(%edx)
  u->write_count = p->rusage.write_count;
801058d7:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801058dd:	89 42 0c             	mov    %eax,0xc(%edx)

  return 0;
801058e0:	31 c0                	xor    %eax,%eax
}
801058e2:	c9                   	leave  
801058e3:	c3                   	ret    
801058e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058e8:	c9                   	leave  
    return -1;
801058e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058ee:	c3                   	ret    

801058ef <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058ef:	1e                   	push   %ds
  pushl %es
801058f0:	06                   	push   %es
  pushl %fs
801058f1:	0f a0                	push   %fs
  pushl %gs
801058f3:	0f a8                	push   %gs
  pushal
801058f5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058f6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058fa:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058fc:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058fe:	54                   	push   %esp
  call trap
801058ff:	e8 cc 00 00 00       	call   801059d0 <trap>
  addl $4, %esp
80105904:	83 c4 04             	add    $0x4,%esp

80105907 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105907:	61                   	popa   
  popl %gs
80105908:	0f a9                	pop    %gs
  popl %fs
8010590a:	0f a1                	pop    %fs
  popl %es
8010590c:	07                   	pop    %es
  popl %ds
8010590d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010590e:	83 c4 08             	add    $0x8,%esp
  iret
80105911:	cf                   	iret   
80105912:	66 90                	xchg   %ax,%ax
80105914:	66 90                	xchg   %ax,%ax
80105916:	66 90                	xchg   %ax,%ax
80105918:	66 90                	xchg   %ax,%ax
8010591a:	66 90                	xchg   %ax,%ax
8010591c:	66 90                	xchg   %ax,%ax
8010591e:	66 90                	xchg   %ax,%ax

80105920 <tvinit>:
struct spinlock tickslock;
uint ticks;

    void
tvinit(void)
{
80105920:	55                   	push   %ebp
    int i;

    for(i = 0; i < 256; i++)
80105921:	31 c0                	xor    %eax,%eax
{
80105923:	89 e5                	mov    %esp,%ebp
80105925:	83 ec 08             	sub    $0x8,%esp
80105928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592f:	90                   	nop
        SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105930:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105937:	c7 04 c5 c2 40 11 80 	movl   $0x8e000008,-0x7feebf3e(,%eax,8)
8010593e:	08 00 00 8e 
80105942:	66 89 14 c5 c0 40 11 	mov    %dx,-0x7feebf40(,%eax,8)
80105949:	80 
8010594a:	c1 ea 10             	shr    $0x10,%edx
8010594d:	66 89 14 c5 c6 40 11 	mov    %dx,-0x7feebf3a(,%eax,8)
80105954:	80 
    for(i = 0; i < 256; i++)
80105955:	83 c0 01             	add    $0x1,%eax
80105958:	3d 00 01 00 00       	cmp    $0x100,%eax
8010595d:	75 d1                	jne    80105930 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

    initlock(&tickslock, "time");
8010595f:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105962:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105967:	c7 05 c2 42 11 80 08 	movl   $0xef000008,0x801142c2
8010596e:	00 00 ef 
    initlock(&tickslock, "time");
80105971:	68 1d 7a 10 80       	push   $0x80107a1d
80105976:	68 80 40 11 80       	push   $0x80114080
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010597b:	66 a3 c0 42 11 80    	mov    %ax,0x801142c0
80105981:	c1 e8 10             	shr    $0x10,%eax
80105984:	66 a3 c6 42 11 80    	mov    %ax,0x801142c6
    initlock(&tickslock, "time");
8010598a:	e8 81 ea ff ff       	call   80104410 <initlock>
}
8010598f:	83 c4 10             	add    $0x10,%esp
80105992:	c9                   	leave  
80105993:	c3                   	ret    
80105994:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010599f:	90                   	nop

801059a0 <idtinit>:

    void
idtinit(void)
{
801059a0:	55                   	push   %ebp
  pd[0] = size-1;
801059a1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059a6:	89 e5                	mov    %esp,%ebp
801059a8:	83 ec 10             	sub    $0x10,%esp
801059ab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059af:	b8 c0 40 11 80       	mov    $0x801140c0,%eax
801059b4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059b8:	c1 e8 10             	shr    $0x10,%eax
801059bb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059bf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059c2:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
801059c5:	c9                   	leave  
801059c6:	c3                   	ret    
801059c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ce:	66 90                	xchg   %ax,%ax

801059d0 <trap>:

//PAGEBREAK: 41
    void
trap(struct trapframe *tf)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	57                   	push   %edi
801059d4:	56                   	push   %esi
801059d5:	53                   	push   %ebx
801059d6:	83 ec 1c             	sub    $0x1c,%esp
801059d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(tf->trapno == T_SYSCALL){
801059dc:	8b 43 30             	mov    0x30(%ebx),%eax
801059df:	83 f8 40             	cmp    $0x40,%eax
801059e2:	0f 84 70 01 00 00    	je     80105b58 <trap+0x188>
        if(myproc()->killed)
            exit();
        return;
    }

    switch(tf->trapno){
801059e8:	83 e8 20             	sub    $0x20,%eax
801059eb:	83 f8 1f             	cmp    $0x1f,%eax
801059ee:	0f 87 8c 00 00 00    	ja     80105a80 <trap+0xb0>
801059f4:	ff 24 85 c4 7a 10 80 	jmp    *-0x7fef853c(,%eax,4)
801059fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059ff:	90                   	nop
                release(&tickslock);
            }
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE:
            ideintr();
80105a00:	e8 3b c8 ff ff       	call   80102240 <ideintr>
            lapiceoi();
80105a05:	e8 06 cf ff ff       	call   80102910 <lapiceoi>
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a0a:	e8 81 df ff ff       	call   80103990 <myproc>
80105a0f:	85 c0                	test   %eax,%eax
80105a11:	74 1d                	je     80105a30 <trap+0x60>
80105a13:	e8 78 df ff ff       	call   80103990 <myproc>
80105a18:	8b 50 24             	mov    0x24(%eax),%edx
80105a1b:	85 d2                	test   %edx,%edx
80105a1d:	74 11                	je     80105a30 <trap+0x60>
80105a1f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a23:	83 e0 03             	and    $0x3,%eax
80105a26:	66 83 f8 03          	cmp    $0x3,%ax
80105a2a:	0f 84 10 02 00 00    	je     80105c40 <trap+0x270>
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if(myproc() && myproc()->state == RUNNING &&
80105a30:	e8 5b df ff ff       	call   80103990 <myproc>
80105a35:	85 c0                	test   %eax,%eax
80105a37:	74 0f                	je     80105a48 <trap+0x78>
80105a39:	e8 52 df ff ff       	call   80103990 <myproc>
80105a3e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a42:	0f 84 c0 00 00 00    	je     80105b08 <trap+0x138>
            tf->trapno == T_IRQ0+IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a48:	e8 43 df ff ff       	call   80103990 <myproc>
80105a4d:	85 c0                	test   %eax,%eax
80105a4f:	74 1d                	je     80105a6e <trap+0x9e>
80105a51:	e8 3a df ff ff       	call   80103990 <myproc>
80105a56:	8b 40 24             	mov    0x24(%eax),%eax
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	74 11                	je     80105a6e <trap+0x9e>
80105a5d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a61:	83 e0 03             	and    $0x3,%eax
80105a64:	66 83 f8 03          	cmp    $0x3,%ax
80105a68:	0f 84 17 01 00 00    	je     80105b85 <trap+0x1b5>
        exit();
}
80105a6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a71:	5b                   	pop    %ebx
80105a72:	5e                   	pop    %esi
80105a73:	5f                   	pop    %edi
80105a74:	5d                   	pop    %ebp
80105a75:	c3                   	ret    
80105a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7d:	8d 76 00             	lea    0x0(%esi),%esi
            if(myproc() == 0 || (tf->cs&3) == 0){
80105a80:	e8 0b df ff ff       	call   80103990 <myproc>
80105a85:	85 c0                	test   %eax,%eax
80105a87:	0f 84 dd 01 00 00    	je     80105c6a <trap+0x29a>
80105a8d:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a91:	0f 84 d3 01 00 00    	je     80105c6a <trap+0x29a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a97:	0f 20 d1             	mov    %cr2,%ecx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a9a:	8b 53 38             	mov    0x38(%ebx),%edx
80105a9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105aa0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105aa3:	e8 c8 de ff ff       	call   80103970 <cpuid>
80105aa8:	8b 73 30             	mov    0x30(%ebx),%esi
80105aab:	89 c7                	mov    %eax,%edi
80105aad:	8b 43 34             	mov    0x34(%ebx),%eax
80105ab0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    myproc()->pid, myproc()->name, tf->trapno,
80105ab3:	e8 d8 de ff ff       	call   80103990 <myproc>
80105ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105abb:	e8 d0 de ff ff       	call   80103990 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ac0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ac3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ac6:	51                   	push   %ecx
80105ac7:	52                   	push   %edx
80105ac8:	57                   	push   %edi
80105ac9:	ff 75 e4             	push   -0x1c(%ebp)
80105acc:	56                   	push   %esi
                    myproc()->pid, myproc()->name, tf->trapno,
80105acd:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105ad0:	83 c6 6c             	add    $0x6c,%esi
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ad3:	56                   	push   %esi
80105ad4:	ff 70 10             	push   0x10(%eax)
80105ad7:	68 80 7a 10 80       	push   $0x80107a80
80105adc:	e8 bf ab ff ff       	call   801006a0 <cprintf>
            myproc()->killed = 1;
80105ae1:	83 c4 20             	add    $0x20,%esp
80105ae4:	e8 a7 de ff ff       	call   80103990 <myproc>
80105ae9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105af0:	e8 9b de ff ff       	call   80103990 <myproc>
80105af5:	85 c0                	test   %eax,%eax
80105af7:	0f 85 16 ff ff ff    	jne    80105a13 <trap+0x43>
80105afd:	e9 2e ff ff ff       	jmp    80105a30 <trap+0x60>
80105b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc() && myproc()->state == RUNNING &&
80105b08:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b0c:	0f 85 36 ff ff ff    	jne    80105a48 <trap+0x78>
        yield();
80105b12:	e8 09 e5 ff ff       	call   80104020 <yield>
80105b17:	e9 2c ff ff ff       	jmp    80105a48 <trap+0x78>
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b20:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b23:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b27:	e8 44 de ff ff       	call   80103970 <cpuid>
80105b2c:	57                   	push   %edi
80105b2d:	56                   	push   %esi
80105b2e:	50                   	push   %eax
80105b2f:	68 28 7a 10 80       	push   $0x80107a28
80105b34:	e8 67 ab ff ff       	call   801006a0 <cprintf>
            lapiceoi();
80105b39:	e8 d2 cd ff ff       	call   80102910 <lapiceoi>
            break;
80105b3e:	83 c4 10             	add    $0x10,%esp
    if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b41:	e8 4a de ff ff       	call   80103990 <myproc>
80105b46:	85 c0                	test   %eax,%eax
80105b48:	0f 85 c5 fe ff ff    	jne    80105a13 <trap+0x43>
80105b4e:	e9 dd fe ff ff       	jmp    80105a30 <trap+0x60>
80105b53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b57:	90                   	nop
        if(myproc()->killed)
80105b58:	e8 33 de ff ff       	call   80103990 <myproc>
80105b5d:	8b 70 24             	mov    0x24(%eax),%esi
80105b60:	85 f6                	test   %esi,%esi
80105b62:	0f 85 f8 00 00 00    	jne    80105c60 <trap+0x290>
        myproc()->tf = tf;
80105b68:	e8 23 de ff ff       	call   80103990 <myproc>
80105b6d:	89 58 18             	mov    %ebx,0x18(%eax)
        syscall();
80105b70:	e8 2b ef ff ff       	call   80104aa0 <syscall>
        if(myproc()->killed)
80105b75:	e8 16 de ff ff       	call   80103990 <myproc>
80105b7a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b7d:	85 c9                	test   %ecx,%ecx
80105b7f:	0f 84 e9 fe ff ff    	je     80105a6e <trap+0x9e>
}
80105b85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b88:	5b                   	pop    %ebx
80105b89:	5e                   	pop    %esi
80105b8a:	5f                   	pop    %edi
80105b8b:	5d                   	pop    %ebp
            exit();
80105b8c:	e9 1f e2 ff ff       	jmp    80103db0 <exit>
80105b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
80105b98:	e8 73 02 00 00       	call   80105e10 <uartintr>
            lapiceoi();
80105b9d:	e8 6e cd ff ff       	call   80102910 <lapiceoi>
    if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ba2:	e8 e9 dd ff ff       	call   80103990 <myproc>
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	0f 85 64 fe ff ff    	jne    80105a13 <trap+0x43>
80105baf:	e9 7c fe ff ff       	jmp    80105a30 <trap+0x60>
80105bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80105bb8:	e8 13 cc ff ff       	call   801027d0 <kbdintr>
            lapiceoi();
80105bbd:	e8 4e cd ff ff       	call   80102910 <lapiceoi>
    if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bc2:	e8 c9 dd ff ff       	call   80103990 <myproc>
80105bc7:	85 c0                	test   %eax,%eax
80105bc9:	0f 85 44 fe ff ff    	jne    80105a13 <trap+0x43>
80105bcf:	e9 5c fe ff ff       	jmp    80105a30 <trap+0x60>
80105bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            struct proc *p = myproc(); // myproc() is an interface to return
80105bd8:	e8 b3 dd ff ff       	call   80103990 <myproc>
            if (p){ 
80105bdd:	85 c0                	test   %eax,%eax
80105bdf:	74 14                	je     80105bf5 <trap+0x225>
                if ((tf->cs&3) == 0) p->rusage.stime++;
80105be1:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105be5:	66 83 e2 03          	and    $0x3,%dx
80105be9:	74 65                	je     80105c50 <trap+0x280>
                if ((tf->cs&3) == DPL_USER) p->rusage.utime++;
80105beb:	66 83 fa 03          	cmp    $0x3,%dx
80105bef:	75 04                	jne    80105bf5 <trap+0x225>
80105bf1:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
            if(cpuid() == 0){
80105bf5:	e8 76 dd ff ff       	call   80103970 <cpuid>
80105bfa:	85 c0                	test   %eax,%eax
80105bfc:	0f 85 03 fe ff ff    	jne    80105a05 <trap+0x35>
                acquire(&tickslock);
80105c02:	83 ec 0c             	sub    $0xc,%esp
80105c05:	68 80 40 11 80       	push   $0x80114080
80105c0a:	e8 d1 e9 ff ff       	call   801045e0 <acquire>
                wakeup(&ticks);
80105c0f:	c7 04 24 60 40 11 80 	movl   $0x80114060,(%esp)
                ticks++;
80105c16:	83 05 60 40 11 80 01 	addl   $0x1,0x80114060
                wakeup(&ticks);
80105c1d:	e8 1e e5 ff ff       	call   80104140 <wakeup>
                release(&tickslock);
80105c22:	c7 04 24 80 40 11 80 	movl   $0x80114080,(%esp)
80105c29:	e8 52 e9 ff ff       	call   80104580 <release>
80105c2e:	83 c4 10             	add    $0x10,%esp
            lapiceoi();
80105c31:	e9 cf fd ff ff       	jmp    80105a05 <trap+0x35>
80105c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
        exit();
80105c40:	e8 6b e1 ff ff       	call   80103db0 <exit>
80105c45:	e9 e6 fd ff ff       	jmp    80105a30 <trap+0x60>
80105c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                if ((tf->cs&3) == 0) p->rusage.stime++;
80105c50:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
80105c57:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
80105c5b:	83 e2 03             	and    $0x3,%edx
80105c5e:	eb 8b                	jmp    80105beb <trap+0x21b>
            exit();
80105c60:	e8 4b e1 ff ff       	call   80103db0 <exit>
80105c65:	e9 fe fe ff ff       	jmp    80105b68 <trap+0x198>
80105c6a:	0f 20 d7             	mov    %cr2,%edi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c6d:	8b 73 38             	mov    0x38(%ebx),%esi
80105c70:	e8 fb dc ff ff       	call   80103970 <cpuid>
80105c75:	83 ec 0c             	sub    $0xc,%esp
80105c78:	57                   	push   %edi
80105c79:	56                   	push   %esi
80105c7a:	50                   	push   %eax
80105c7b:	ff 73 30             	push   0x30(%ebx)
80105c7e:	68 4c 7a 10 80       	push   $0x80107a4c
80105c83:	e8 18 aa ff ff       	call   801006a0 <cprintf>
                panic("trap");
80105c88:	83 c4 14             	add    $0x14,%esp
80105c8b:	68 22 7a 10 80       	push   $0x80107a22
80105c90:	e8 eb a6 ff ff       	call   80100380 <panic>
80105c95:	66 90                	xchg   %ax,%ax
80105c97:	66 90                	xchg   %ax,%ax
80105c99:	66 90                	xchg   %ax,%ax
80105c9b:	66 90                	xchg   %ax,%ax
80105c9d:	66 90                	xchg   %ax,%ax
80105c9f:	90                   	nop

80105ca0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ca0:	a1 c0 48 11 80       	mov    0x801148c0,%eax
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	74 17                	je     80105cc0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ca9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105caf:	a8 01                	test   $0x1,%al
80105cb1:	74 0d                	je     80105cc0 <uartgetc+0x20>
80105cb3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cb8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105cb9:	0f b6 c0             	movzbl %al,%eax
80105cbc:	c3                   	ret    
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc5:	c3                   	ret    
80105cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ccd:	8d 76 00             	lea    0x0(%esi),%esi

80105cd0 <uartinit>:
{
80105cd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cd1:	31 c9                	xor    %ecx,%ecx
80105cd3:	89 c8                	mov    %ecx,%eax
80105cd5:	89 e5                	mov    %esp,%ebp
80105cd7:	57                   	push   %edi
80105cd8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105cdd:	56                   	push   %esi
80105cde:	89 fa                	mov    %edi,%edx
80105ce0:	53                   	push   %ebx
80105ce1:	83 ec 1c             	sub    $0x1c,%esp
80105ce4:	ee                   	out    %al,(%dx)
80105ce5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105cea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105cef:	89 f2                	mov    %esi,%edx
80105cf1:	ee                   	out    %al,(%dx)
80105cf2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105cf7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cfc:	ee                   	out    %al,(%dx)
80105cfd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105d02:	89 c8                	mov    %ecx,%eax
80105d04:	89 da                	mov    %ebx,%edx
80105d06:	ee                   	out    %al,(%dx)
80105d07:	b8 03 00 00 00       	mov    $0x3,%eax
80105d0c:	89 f2                	mov    %esi,%edx
80105d0e:	ee                   	out    %al,(%dx)
80105d0f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d14:	89 c8                	mov    %ecx,%eax
80105d16:	ee                   	out    %al,(%dx)
80105d17:	b8 01 00 00 00       	mov    $0x1,%eax
80105d1c:	89 da                	mov    %ebx,%edx
80105d1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d1f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d24:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d25:	3c ff                	cmp    $0xff,%al
80105d27:	74 78                	je     80105da1 <uartinit+0xd1>
  uart = 1;
80105d29:	c7 05 c0 48 11 80 01 	movl   $0x1,0x801148c0
80105d30:	00 00 00 
80105d33:	89 fa                	mov    %edi,%edx
80105d35:	ec                   	in     (%dx),%al
80105d36:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d3b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d3c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105d3f:	bf 44 7b 10 80       	mov    $0x80107b44,%edi
80105d44:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105d49:	6a 00                	push   $0x0
80105d4b:	6a 04                	push   $0x4
80105d4d:	e8 2e c7 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105d52:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105d56:	83 c4 10             	add    $0x10,%esp
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105d60:	a1 c0 48 11 80       	mov    0x801148c0,%eax
80105d65:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d6a:	85 c0                	test   %eax,%eax
80105d6c:	75 14                	jne    80105d82 <uartinit+0xb2>
80105d6e:	eb 23                	jmp    80105d93 <uartinit+0xc3>
    microdelay(10);
80105d70:	83 ec 0c             	sub    $0xc,%esp
80105d73:	6a 0a                	push   $0xa
80105d75:	e8 b6 cb ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d7a:	83 c4 10             	add    $0x10,%esp
80105d7d:	83 eb 01             	sub    $0x1,%ebx
80105d80:	74 07                	je     80105d89 <uartinit+0xb9>
80105d82:	89 f2                	mov    %esi,%edx
80105d84:	ec                   	in     (%dx),%al
80105d85:	a8 20                	test   $0x20,%al
80105d87:	74 e7                	je     80105d70 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d89:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105d8d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d92:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105d93:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105d97:	83 c7 01             	add    $0x1,%edi
80105d9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105d9d:	84 c0                	test   %al,%al
80105d9f:	75 bf                	jne    80105d60 <uartinit+0x90>
}
80105da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da4:	5b                   	pop    %ebx
80105da5:	5e                   	pop    %esi
80105da6:	5f                   	pop    %edi
80105da7:	5d                   	pop    %ebp
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105db0 <uartputc>:
  if(!uart)
80105db0:	a1 c0 48 11 80       	mov    0x801148c0,%eax
80105db5:	85 c0                	test   %eax,%eax
80105db7:	74 47                	je     80105e00 <uartputc+0x50>
{
80105db9:	55                   	push   %ebp
80105dba:	89 e5                	mov    %esp,%ebp
80105dbc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105dbd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105dc2:	53                   	push   %ebx
80105dc3:	bb 80 00 00 00       	mov    $0x80,%ebx
80105dc8:	eb 18                	jmp    80105de2 <uartputc+0x32>
80105dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	6a 0a                	push   $0xa
80105dd5:	e8 56 cb ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105dda:	83 c4 10             	add    $0x10,%esp
80105ddd:	83 eb 01             	sub    $0x1,%ebx
80105de0:	74 07                	je     80105de9 <uartputc+0x39>
80105de2:	89 f2                	mov    %esi,%edx
80105de4:	ec                   	in     (%dx),%al
80105de5:	a8 20                	test   $0x20,%al
80105de7:	74 e7                	je     80105dd0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105de9:	8b 45 08             	mov    0x8(%ebp),%eax
80105dec:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105df1:	ee                   	out    %al,(%dx)
}
80105df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105df5:	5b                   	pop    %ebx
80105df6:	5e                   	pop    %esi
80105df7:	5d                   	pop    %ebp
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e00:	c3                   	ret    
80105e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0f:	90                   	nop

80105e10 <uartintr>:

void
uartintr(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e16:	68 a0 5c 10 80       	push   $0x80105ca0
80105e1b:	e8 60 aa ff ff       	call   80100880 <consoleintr>
}
80105e20:	83 c4 10             	add    $0x10,%esp
80105e23:	c9                   	leave  
80105e24:	c3                   	ret    

80105e25 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e25:	6a 00                	push   $0x0
  pushl $0
80105e27:	6a 00                	push   $0x0
  jmp alltraps
80105e29:	e9 c1 fa ff ff       	jmp    801058ef <alltraps>

80105e2e <vector1>:
.globl vector1
vector1:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $1
80105e30:	6a 01                	push   $0x1
  jmp alltraps
80105e32:	e9 b8 fa ff ff       	jmp    801058ef <alltraps>

80105e37 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $2
80105e39:	6a 02                	push   $0x2
  jmp alltraps
80105e3b:	e9 af fa ff ff       	jmp    801058ef <alltraps>

80105e40 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $3
80105e42:	6a 03                	push   $0x3
  jmp alltraps
80105e44:	e9 a6 fa ff ff       	jmp    801058ef <alltraps>

80105e49 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $4
80105e4b:	6a 04                	push   $0x4
  jmp alltraps
80105e4d:	e9 9d fa ff ff       	jmp    801058ef <alltraps>

80105e52 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $5
80105e54:	6a 05                	push   $0x5
  jmp alltraps
80105e56:	e9 94 fa ff ff       	jmp    801058ef <alltraps>

80105e5b <vector6>:
.globl vector6
vector6:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $6
80105e5d:	6a 06                	push   $0x6
  jmp alltraps
80105e5f:	e9 8b fa ff ff       	jmp    801058ef <alltraps>

80105e64 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $7
80105e66:	6a 07                	push   $0x7
  jmp alltraps
80105e68:	e9 82 fa ff ff       	jmp    801058ef <alltraps>

80105e6d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e6d:	6a 08                	push   $0x8
  jmp alltraps
80105e6f:	e9 7b fa ff ff       	jmp    801058ef <alltraps>

80105e74 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e74:	6a 00                	push   $0x0
  pushl $9
80105e76:	6a 09                	push   $0x9
  jmp alltraps
80105e78:	e9 72 fa ff ff       	jmp    801058ef <alltraps>

80105e7d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e7d:	6a 0a                	push   $0xa
  jmp alltraps
80105e7f:	e9 6b fa ff ff       	jmp    801058ef <alltraps>

80105e84 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e84:	6a 0b                	push   $0xb
  jmp alltraps
80105e86:	e9 64 fa ff ff       	jmp    801058ef <alltraps>

80105e8b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e8b:	6a 0c                	push   $0xc
  jmp alltraps
80105e8d:	e9 5d fa ff ff       	jmp    801058ef <alltraps>

80105e92 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e92:	6a 0d                	push   $0xd
  jmp alltraps
80105e94:	e9 56 fa ff ff       	jmp    801058ef <alltraps>

80105e99 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e99:	6a 0e                	push   $0xe
  jmp alltraps
80105e9b:	e9 4f fa ff ff       	jmp    801058ef <alltraps>

80105ea0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $15
80105ea2:	6a 0f                	push   $0xf
  jmp alltraps
80105ea4:	e9 46 fa ff ff       	jmp    801058ef <alltraps>

80105ea9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $16
80105eab:	6a 10                	push   $0x10
  jmp alltraps
80105ead:	e9 3d fa ff ff       	jmp    801058ef <alltraps>

80105eb2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105eb2:	6a 11                	push   $0x11
  jmp alltraps
80105eb4:	e9 36 fa ff ff       	jmp    801058ef <alltraps>

80105eb9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105eb9:	6a 00                	push   $0x0
  pushl $18
80105ebb:	6a 12                	push   $0x12
  jmp alltraps
80105ebd:	e9 2d fa ff ff       	jmp    801058ef <alltraps>

80105ec2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $19
80105ec4:	6a 13                	push   $0x13
  jmp alltraps
80105ec6:	e9 24 fa ff ff       	jmp    801058ef <alltraps>

80105ecb <vector20>:
.globl vector20
vector20:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $20
80105ecd:	6a 14                	push   $0x14
  jmp alltraps
80105ecf:	e9 1b fa ff ff       	jmp    801058ef <alltraps>

80105ed4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ed4:	6a 00                	push   $0x0
  pushl $21
80105ed6:	6a 15                	push   $0x15
  jmp alltraps
80105ed8:	e9 12 fa ff ff       	jmp    801058ef <alltraps>

80105edd <vector22>:
.globl vector22
vector22:
  pushl $0
80105edd:	6a 00                	push   $0x0
  pushl $22
80105edf:	6a 16                	push   $0x16
  jmp alltraps
80105ee1:	e9 09 fa ff ff       	jmp    801058ef <alltraps>

80105ee6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $23
80105ee8:	6a 17                	push   $0x17
  jmp alltraps
80105eea:	e9 00 fa ff ff       	jmp    801058ef <alltraps>

80105eef <vector24>:
.globl vector24
vector24:
  pushl $0
80105eef:	6a 00                	push   $0x0
  pushl $24
80105ef1:	6a 18                	push   $0x18
  jmp alltraps
80105ef3:	e9 f7 f9 ff ff       	jmp    801058ef <alltraps>

80105ef8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ef8:	6a 00                	push   $0x0
  pushl $25
80105efa:	6a 19                	push   $0x19
  jmp alltraps
80105efc:	e9 ee f9 ff ff       	jmp    801058ef <alltraps>

80105f01 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f01:	6a 00                	push   $0x0
  pushl $26
80105f03:	6a 1a                	push   $0x1a
  jmp alltraps
80105f05:	e9 e5 f9 ff ff       	jmp    801058ef <alltraps>

80105f0a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $27
80105f0c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f0e:	e9 dc f9 ff ff       	jmp    801058ef <alltraps>

80105f13 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $28
80105f15:	6a 1c                	push   $0x1c
  jmp alltraps
80105f17:	e9 d3 f9 ff ff       	jmp    801058ef <alltraps>

80105f1c <vector29>:
.globl vector29
vector29:
  pushl $0
80105f1c:	6a 00                	push   $0x0
  pushl $29
80105f1e:	6a 1d                	push   $0x1d
  jmp alltraps
80105f20:	e9 ca f9 ff ff       	jmp    801058ef <alltraps>

80105f25 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f25:	6a 00                	push   $0x0
  pushl $30
80105f27:	6a 1e                	push   $0x1e
  jmp alltraps
80105f29:	e9 c1 f9 ff ff       	jmp    801058ef <alltraps>

80105f2e <vector31>:
.globl vector31
vector31:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $31
80105f30:	6a 1f                	push   $0x1f
  jmp alltraps
80105f32:	e9 b8 f9 ff ff       	jmp    801058ef <alltraps>

80105f37 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $32
80105f39:	6a 20                	push   $0x20
  jmp alltraps
80105f3b:	e9 af f9 ff ff       	jmp    801058ef <alltraps>

80105f40 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $33
80105f42:	6a 21                	push   $0x21
  jmp alltraps
80105f44:	e9 a6 f9 ff ff       	jmp    801058ef <alltraps>

80105f49 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $34
80105f4b:	6a 22                	push   $0x22
  jmp alltraps
80105f4d:	e9 9d f9 ff ff       	jmp    801058ef <alltraps>

80105f52 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $35
80105f54:	6a 23                	push   $0x23
  jmp alltraps
80105f56:	e9 94 f9 ff ff       	jmp    801058ef <alltraps>

80105f5b <vector36>:
.globl vector36
vector36:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $36
80105f5d:	6a 24                	push   $0x24
  jmp alltraps
80105f5f:	e9 8b f9 ff ff       	jmp    801058ef <alltraps>

80105f64 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $37
80105f66:	6a 25                	push   $0x25
  jmp alltraps
80105f68:	e9 82 f9 ff ff       	jmp    801058ef <alltraps>

80105f6d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $38
80105f6f:	6a 26                	push   $0x26
  jmp alltraps
80105f71:	e9 79 f9 ff ff       	jmp    801058ef <alltraps>

80105f76 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $39
80105f78:	6a 27                	push   $0x27
  jmp alltraps
80105f7a:	e9 70 f9 ff ff       	jmp    801058ef <alltraps>

80105f7f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $40
80105f81:	6a 28                	push   $0x28
  jmp alltraps
80105f83:	e9 67 f9 ff ff       	jmp    801058ef <alltraps>

80105f88 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $41
80105f8a:	6a 29                	push   $0x29
  jmp alltraps
80105f8c:	e9 5e f9 ff ff       	jmp    801058ef <alltraps>

80105f91 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f91:	6a 00                	push   $0x0
  pushl $42
80105f93:	6a 2a                	push   $0x2a
  jmp alltraps
80105f95:	e9 55 f9 ff ff       	jmp    801058ef <alltraps>

80105f9a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $43
80105f9c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f9e:	e9 4c f9 ff ff       	jmp    801058ef <alltraps>

80105fa3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $44
80105fa5:	6a 2c                	push   $0x2c
  jmp alltraps
80105fa7:	e9 43 f9 ff ff       	jmp    801058ef <alltraps>

80105fac <vector45>:
.globl vector45
vector45:
  pushl $0
80105fac:	6a 00                	push   $0x0
  pushl $45
80105fae:	6a 2d                	push   $0x2d
  jmp alltraps
80105fb0:	e9 3a f9 ff ff       	jmp    801058ef <alltraps>

80105fb5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $46
80105fb7:	6a 2e                	push   $0x2e
  jmp alltraps
80105fb9:	e9 31 f9 ff ff       	jmp    801058ef <alltraps>

80105fbe <vector47>:
.globl vector47
vector47:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $47
80105fc0:	6a 2f                	push   $0x2f
  jmp alltraps
80105fc2:	e9 28 f9 ff ff       	jmp    801058ef <alltraps>

80105fc7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $48
80105fc9:	6a 30                	push   $0x30
  jmp alltraps
80105fcb:	e9 1f f9 ff ff       	jmp    801058ef <alltraps>

80105fd0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $49
80105fd2:	6a 31                	push   $0x31
  jmp alltraps
80105fd4:	e9 16 f9 ff ff       	jmp    801058ef <alltraps>

80105fd9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $50
80105fdb:	6a 32                	push   $0x32
  jmp alltraps
80105fdd:	e9 0d f9 ff ff       	jmp    801058ef <alltraps>

80105fe2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $51
80105fe4:	6a 33                	push   $0x33
  jmp alltraps
80105fe6:	e9 04 f9 ff ff       	jmp    801058ef <alltraps>

80105feb <vector52>:
.globl vector52
vector52:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $52
80105fed:	6a 34                	push   $0x34
  jmp alltraps
80105fef:	e9 fb f8 ff ff       	jmp    801058ef <alltraps>

80105ff4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $53
80105ff6:	6a 35                	push   $0x35
  jmp alltraps
80105ff8:	e9 f2 f8 ff ff       	jmp    801058ef <alltraps>

80105ffd <vector54>:
.globl vector54
vector54:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $54
80105fff:	6a 36                	push   $0x36
  jmp alltraps
80106001:	e9 e9 f8 ff ff       	jmp    801058ef <alltraps>

80106006 <vector55>:
.globl vector55
vector55:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $55
80106008:	6a 37                	push   $0x37
  jmp alltraps
8010600a:	e9 e0 f8 ff ff       	jmp    801058ef <alltraps>

8010600f <vector56>:
.globl vector56
vector56:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $56
80106011:	6a 38                	push   $0x38
  jmp alltraps
80106013:	e9 d7 f8 ff ff       	jmp    801058ef <alltraps>

80106018 <vector57>:
.globl vector57
vector57:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $57
8010601a:	6a 39                	push   $0x39
  jmp alltraps
8010601c:	e9 ce f8 ff ff       	jmp    801058ef <alltraps>

80106021 <vector58>:
.globl vector58
vector58:
  pushl $0
80106021:	6a 00                	push   $0x0
  pushl $58
80106023:	6a 3a                	push   $0x3a
  jmp alltraps
80106025:	e9 c5 f8 ff ff       	jmp    801058ef <alltraps>

8010602a <vector59>:
.globl vector59
vector59:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $59
8010602c:	6a 3b                	push   $0x3b
  jmp alltraps
8010602e:	e9 bc f8 ff ff       	jmp    801058ef <alltraps>

80106033 <vector60>:
.globl vector60
vector60:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $60
80106035:	6a 3c                	push   $0x3c
  jmp alltraps
80106037:	e9 b3 f8 ff ff       	jmp    801058ef <alltraps>

8010603c <vector61>:
.globl vector61
vector61:
  pushl $0
8010603c:	6a 00                	push   $0x0
  pushl $61
8010603e:	6a 3d                	push   $0x3d
  jmp alltraps
80106040:	e9 aa f8 ff ff       	jmp    801058ef <alltraps>

80106045 <vector62>:
.globl vector62
vector62:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $62
80106047:	6a 3e                	push   $0x3e
  jmp alltraps
80106049:	e9 a1 f8 ff ff       	jmp    801058ef <alltraps>

8010604e <vector63>:
.globl vector63
vector63:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $63
80106050:	6a 3f                	push   $0x3f
  jmp alltraps
80106052:	e9 98 f8 ff ff       	jmp    801058ef <alltraps>

80106057 <vector64>:
.globl vector64
vector64:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $64
80106059:	6a 40                	push   $0x40
  jmp alltraps
8010605b:	e9 8f f8 ff ff       	jmp    801058ef <alltraps>

80106060 <vector65>:
.globl vector65
vector65:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $65
80106062:	6a 41                	push   $0x41
  jmp alltraps
80106064:	e9 86 f8 ff ff       	jmp    801058ef <alltraps>

80106069 <vector66>:
.globl vector66
vector66:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $66
8010606b:	6a 42                	push   $0x42
  jmp alltraps
8010606d:	e9 7d f8 ff ff       	jmp    801058ef <alltraps>

80106072 <vector67>:
.globl vector67
vector67:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $67
80106074:	6a 43                	push   $0x43
  jmp alltraps
80106076:	e9 74 f8 ff ff       	jmp    801058ef <alltraps>

8010607b <vector68>:
.globl vector68
vector68:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $68
8010607d:	6a 44                	push   $0x44
  jmp alltraps
8010607f:	e9 6b f8 ff ff       	jmp    801058ef <alltraps>

80106084 <vector69>:
.globl vector69
vector69:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $69
80106086:	6a 45                	push   $0x45
  jmp alltraps
80106088:	e9 62 f8 ff ff       	jmp    801058ef <alltraps>

8010608d <vector70>:
.globl vector70
vector70:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $70
8010608f:	6a 46                	push   $0x46
  jmp alltraps
80106091:	e9 59 f8 ff ff       	jmp    801058ef <alltraps>

80106096 <vector71>:
.globl vector71
vector71:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $71
80106098:	6a 47                	push   $0x47
  jmp alltraps
8010609a:	e9 50 f8 ff ff       	jmp    801058ef <alltraps>

8010609f <vector72>:
.globl vector72
vector72:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $72
801060a1:	6a 48                	push   $0x48
  jmp alltraps
801060a3:	e9 47 f8 ff ff       	jmp    801058ef <alltraps>

801060a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $73
801060aa:	6a 49                	push   $0x49
  jmp alltraps
801060ac:	e9 3e f8 ff ff       	jmp    801058ef <alltraps>

801060b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $74
801060b3:	6a 4a                	push   $0x4a
  jmp alltraps
801060b5:	e9 35 f8 ff ff       	jmp    801058ef <alltraps>

801060ba <vector75>:
.globl vector75
vector75:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $75
801060bc:	6a 4b                	push   $0x4b
  jmp alltraps
801060be:	e9 2c f8 ff ff       	jmp    801058ef <alltraps>

801060c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $76
801060c5:	6a 4c                	push   $0x4c
  jmp alltraps
801060c7:	e9 23 f8 ff ff       	jmp    801058ef <alltraps>

801060cc <vector77>:
.globl vector77
vector77:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $77
801060ce:	6a 4d                	push   $0x4d
  jmp alltraps
801060d0:	e9 1a f8 ff ff       	jmp    801058ef <alltraps>

801060d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $78
801060d7:	6a 4e                	push   $0x4e
  jmp alltraps
801060d9:	e9 11 f8 ff ff       	jmp    801058ef <alltraps>

801060de <vector79>:
.globl vector79
vector79:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $79
801060e0:	6a 4f                	push   $0x4f
  jmp alltraps
801060e2:	e9 08 f8 ff ff       	jmp    801058ef <alltraps>

801060e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $80
801060e9:	6a 50                	push   $0x50
  jmp alltraps
801060eb:	e9 ff f7 ff ff       	jmp    801058ef <alltraps>

801060f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $81
801060f2:	6a 51                	push   $0x51
  jmp alltraps
801060f4:	e9 f6 f7 ff ff       	jmp    801058ef <alltraps>

801060f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $82
801060fb:	6a 52                	push   $0x52
  jmp alltraps
801060fd:	e9 ed f7 ff ff       	jmp    801058ef <alltraps>

80106102 <vector83>:
.globl vector83
vector83:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $83
80106104:	6a 53                	push   $0x53
  jmp alltraps
80106106:	e9 e4 f7 ff ff       	jmp    801058ef <alltraps>

8010610b <vector84>:
.globl vector84
vector84:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $84
8010610d:	6a 54                	push   $0x54
  jmp alltraps
8010610f:	e9 db f7 ff ff       	jmp    801058ef <alltraps>

80106114 <vector85>:
.globl vector85
vector85:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $85
80106116:	6a 55                	push   $0x55
  jmp alltraps
80106118:	e9 d2 f7 ff ff       	jmp    801058ef <alltraps>

8010611d <vector86>:
.globl vector86
vector86:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $86
8010611f:	6a 56                	push   $0x56
  jmp alltraps
80106121:	e9 c9 f7 ff ff       	jmp    801058ef <alltraps>

80106126 <vector87>:
.globl vector87
vector87:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $87
80106128:	6a 57                	push   $0x57
  jmp alltraps
8010612a:	e9 c0 f7 ff ff       	jmp    801058ef <alltraps>

8010612f <vector88>:
.globl vector88
vector88:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $88
80106131:	6a 58                	push   $0x58
  jmp alltraps
80106133:	e9 b7 f7 ff ff       	jmp    801058ef <alltraps>

80106138 <vector89>:
.globl vector89
vector89:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $89
8010613a:	6a 59                	push   $0x59
  jmp alltraps
8010613c:	e9 ae f7 ff ff       	jmp    801058ef <alltraps>

80106141 <vector90>:
.globl vector90
vector90:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $90
80106143:	6a 5a                	push   $0x5a
  jmp alltraps
80106145:	e9 a5 f7 ff ff       	jmp    801058ef <alltraps>

8010614a <vector91>:
.globl vector91
vector91:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $91
8010614c:	6a 5b                	push   $0x5b
  jmp alltraps
8010614e:	e9 9c f7 ff ff       	jmp    801058ef <alltraps>

80106153 <vector92>:
.globl vector92
vector92:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $92
80106155:	6a 5c                	push   $0x5c
  jmp alltraps
80106157:	e9 93 f7 ff ff       	jmp    801058ef <alltraps>

8010615c <vector93>:
.globl vector93
vector93:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $93
8010615e:	6a 5d                	push   $0x5d
  jmp alltraps
80106160:	e9 8a f7 ff ff       	jmp    801058ef <alltraps>

80106165 <vector94>:
.globl vector94
vector94:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $94
80106167:	6a 5e                	push   $0x5e
  jmp alltraps
80106169:	e9 81 f7 ff ff       	jmp    801058ef <alltraps>

8010616e <vector95>:
.globl vector95
vector95:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $95
80106170:	6a 5f                	push   $0x5f
  jmp alltraps
80106172:	e9 78 f7 ff ff       	jmp    801058ef <alltraps>

80106177 <vector96>:
.globl vector96
vector96:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $96
80106179:	6a 60                	push   $0x60
  jmp alltraps
8010617b:	e9 6f f7 ff ff       	jmp    801058ef <alltraps>

80106180 <vector97>:
.globl vector97
vector97:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $97
80106182:	6a 61                	push   $0x61
  jmp alltraps
80106184:	e9 66 f7 ff ff       	jmp    801058ef <alltraps>

80106189 <vector98>:
.globl vector98
vector98:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $98
8010618b:	6a 62                	push   $0x62
  jmp alltraps
8010618d:	e9 5d f7 ff ff       	jmp    801058ef <alltraps>

80106192 <vector99>:
.globl vector99
vector99:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $99
80106194:	6a 63                	push   $0x63
  jmp alltraps
80106196:	e9 54 f7 ff ff       	jmp    801058ef <alltraps>

8010619b <vector100>:
.globl vector100
vector100:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $100
8010619d:	6a 64                	push   $0x64
  jmp alltraps
8010619f:	e9 4b f7 ff ff       	jmp    801058ef <alltraps>

801061a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $101
801061a6:	6a 65                	push   $0x65
  jmp alltraps
801061a8:	e9 42 f7 ff ff       	jmp    801058ef <alltraps>

801061ad <vector102>:
.globl vector102
vector102:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $102
801061af:	6a 66                	push   $0x66
  jmp alltraps
801061b1:	e9 39 f7 ff ff       	jmp    801058ef <alltraps>

801061b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $103
801061b8:	6a 67                	push   $0x67
  jmp alltraps
801061ba:	e9 30 f7 ff ff       	jmp    801058ef <alltraps>

801061bf <vector104>:
.globl vector104
vector104:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $104
801061c1:	6a 68                	push   $0x68
  jmp alltraps
801061c3:	e9 27 f7 ff ff       	jmp    801058ef <alltraps>

801061c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $105
801061ca:	6a 69                	push   $0x69
  jmp alltraps
801061cc:	e9 1e f7 ff ff       	jmp    801058ef <alltraps>

801061d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $106
801061d3:	6a 6a                	push   $0x6a
  jmp alltraps
801061d5:	e9 15 f7 ff ff       	jmp    801058ef <alltraps>

801061da <vector107>:
.globl vector107
vector107:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $107
801061dc:	6a 6b                	push   $0x6b
  jmp alltraps
801061de:	e9 0c f7 ff ff       	jmp    801058ef <alltraps>

801061e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $108
801061e5:	6a 6c                	push   $0x6c
  jmp alltraps
801061e7:	e9 03 f7 ff ff       	jmp    801058ef <alltraps>

801061ec <vector109>:
.globl vector109
vector109:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $109
801061ee:	6a 6d                	push   $0x6d
  jmp alltraps
801061f0:	e9 fa f6 ff ff       	jmp    801058ef <alltraps>

801061f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $110
801061f7:	6a 6e                	push   $0x6e
  jmp alltraps
801061f9:	e9 f1 f6 ff ff       	jmp    801058ef <alltraps>

801061fe <vector111>:
.globl vector111
vector111:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $111
80106200:	6a 6f                	push   $0x6f
  jmp alltraps
80106202:	e9 e8 f6 ff ff       	jmp    801058ef <alltraps>

80106207 <vector112>:
.globl vector112
vector112:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $112
80106209:	6a 70                	push   $0x70
  jmp alltraps
8010620b:	e9 df f6 ff ff       	jmp    801058ef <alltraps>

80106210 <vector113>:
.globl vector113
vector113:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $113
80106212:	6a 71                	push   $0x71
  jmp alltraps
80106214:	e9 d6 f6 ff ff       	jmp    801058ef <alltraps>

80106219 <vector114>:
.globl vector114
vector114:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $114
8010621b:	6a 72                	push   $0x72
  jmp alltraps
8010621d:	e9 cd f6 ff ff       	jmp    801058ef <alltraps>

80106222 <vector115>:
.globl vector115
vector115:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $115
80106224:	6a 73                	push   $0x73
  jmp alltraps
80106226:	e9 c4 f6 ff ff       	jmp    801058ef <alltraps>

8010622b <vector116>:
.globl vector116
vector116:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $116
8010622d:	6a 74                	push   $0x74
  jmp alltraps
8010622f:	e9 bb f6 ff ff       	jmp    801058ef <alltraps>

80106234 <vector117>:
.globl vector117
vector117:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $117
80106236:	6a 75                	push   $0x75
  jmp alltraps
80106238:	e9 b2 f6 ff ff       	jmp    801058ef <alltraps>

8010623d <vector118>:
.globl vector118
vector118:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $118
8010623f:	6a 76                	push   $0x76
  jmp alltraps
80106241:	e9 a9 f6 ff ff       	jmp    801058ef <alltraps>

80106246 <vector119>:
.globl vector119
vector119:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $119
80106248:	6a 77                	push   $0x77
  jmp alltraps
8010624a:	e9 a0 f6 ff ff       	jmp    801058ef <alltraps>

8010624f <vector120>:
.globl vector120
vector120:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $120
80106251:	6a 78                	push   $0x78
  jmp alltraps
80106253:	e9 97 f6 ff ff       	jmp    801058ef <alltraps>

80106258 <vector121>:
.globl vector121
vector121:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $121
8010625a:	6a 79                	push   $0x79
  jmp alltraps
8010625c:	e9 8e f6 ff ff       	jmp    801058ef <alltraps>

80106261 <vector122>:
.globl vector122
vector122:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $122
80106263:	6a 7a                	push   $0x7a
  jmp alltraps
80106265:	e9 85 f6 ff ff       	jmp    801058ef <alltraps>

8010626a <vector123>:
.globl vector123
vector123:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $123
8010626c:	6a 7b                	push   $0x7b
  jmp alltraps
8010626e:	e9 7c f6 ff ff       	jmp    801058ef <alltraps>

80106273 <vector124>:
.globl vector124
vector124:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $124
80106275:	6a 7c                	push   $0x7c
  jmp alltraps
80106277:	e9 73 f6 ff ff       	jmp    801058ef <alltraps>

8010627c <vector125>:
.globl vector125
vector125:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $125
8010627e:	6a 7d                	push   $0x7d
  jmp alltraps
80106280:	e9 6a f6 ff ff       	jmp    801058ef <alltraps>

80106285 <vector126>:
.globl vector126
vector126:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $126
80106287:	6a 7e                	push   $0x7e
  jmp alltraps
80106289:	e9 61 f6 ff ff       	jmp    801058ef <alltraps>

8010628e <vector127>:
.globl vector127
vector127:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $127
80106290:	6a 7f                	push   $0x7f
  jmp alltraps
80106292:	e9 58 f6 ff ff       	jmp    801058ef <alltraps>

80106297 <vector128>:
.globl vector128
vector128:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $128
80106299:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010629e:	e9 4c f6 ff ff       	jmp    801058ef <alltraps>

801062a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $129
801062a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801062aa:	e9 40 f6 ff ff       	jmp    801058ef <alltraps>

801062af <vector130>:
.globl vector130
vector130:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $130
801062b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801062b6:	e9 34 f6 ff ff       	jmp    801058ef <alltraps>

801062bb <vector131>:
.globl vector131
vector131:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $131
801062bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062c2:	e9 28 f6 ff ff       	jmp    801058ef <alltraps>

801062c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $132
801062c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062ce:	e9 1c f6 ff ff       	jmp    801058ef <alltraps>

801062d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $133
801062d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062da:	e9 10 f6 ff ff       	jmp    801058ef <alltraps>

801062df <vector134>:
.globl vector134
vector134:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $134
801062e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062e6:	e9 04 f6 ff ff       	jmp    801058ef <alltraps>

801062eb <vector135>:
.globl vector135
vector135:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $135
801062ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062f2:	e9 f8 f5 ff ff       	jmp    801058ef <alltraps>

801062f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $136
801062f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801062fe:	e9 ec f5 ff ff       	jmp    801058ef <alltraps>

80106303 <vector137>:
.globl vector137
vector137:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $137
80106305:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010630a:	e9 e0 f5 ff ff       	jmp    801058ef <alltraps>

8010630f <vector138>:
.globl vector138
vector138:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $138
80106311:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106316:	e9 d4 f5 ff ff       	jmp    801058ef <alltraps>

8010631b <vector139>:
.globl vector139
vector139:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $139
8010631d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106322:	e9 c8 f5 ff ff       	jmp    801058ef <alltraps>

80106327 <vector140>:
.globl vector140
vector140:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $140
80106329:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010632e:	e9 bc f5 ff ff       	jmp    801058ef <alltraps>

80106333 <vector141>:
.globl vector141
vector141:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $141
80106335:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010633a:	e9 b0 f5 ff ff       	jmp    801058ef <alltraps>

8010633f <vector142>:
.globl vector142
vector142:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $142
80106341:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106346:	e9 a4 f5 ff ff       	jmp    801058ef <alltraps>

8010634b <vector143>:
.globl vector143
vector143:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $143
8010634d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106352:	e9 98 f5 ff ff       	jmp    801058ef <alltraps>

80106357 <vector144>:
.globl vector144
vector144:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $144
80106359:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010635e:	e9 8c f5 ff ff       	jmp    801058ef <alltraps>

80106363 <vector145>:
.globl vector145
vector145:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $145
80106365:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010636a:	e9 80 f5 ff ff       	jmp    801058ef <alltraps>

8010636f <vector146>:
.globl vector146
vector146:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $146
80106371:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106376:	e9 74 f5 ff ff       	jmp    801058ef <alltraps>

8010637b <vector147>:
.globl vector147
vector147:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $147
8010637d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106382:	e9 68 f5 ff ff       	jmp    801058ef <alltraps>

80106387 <vector148>:
.globl vector148
vector148:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $148
80106389:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010638e:	e9 5c f5 ff ff       	jmp    801058ef <alltraps>

80106393 <vector149>:
.globl vector149
vector149:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $149
80106395:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010639a:	e9 50 f5 ff ff       	jmp    801058ef <alltraps>

8010639f <vector150>:
.globl vector150
vector150:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $150
801063a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801063a6:	e9 44 f5 ff ff       	jmp    801058ef <alltraps>

801063ab <vector151>:
.globl vector151
vector151:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $151
801063ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801063b2:	e9 38 f5 ff ff       	jmp    801058ef <alltraps>

801063b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $152
801063b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801063be:	e9 2c f5 ff ff       	jmp    801058ef <alltraps>

801063c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $153
801063c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063ca:	e9 20 f5 ff ff       	jmp    801058ef <alltraps>

801063cf <vector154>:
.globl vector154
vector154:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $154
801063d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063d6:	e9 14 f5 ff ff       	jmp    801058ef <alltraps>

801063db <vector155>:
.globl vector155
vector155:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $155
801063dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063e2:	e9 08 f5 ff ff       	jmp    801058ef <alltraps>

801063e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $156
801063e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063ee:	e9 fc f4 ff ff       	jmp    801058ef <alltraps>

801063f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $157
801063f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063fa:	e9 f0 f4 ff ff       	jmp    801058ef <alltraps>

801063ff <vector158>:
.globl vector158
vector158:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $158
80106401:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106406:	e9 e4 f4 ff ff       	jmp    801058ef <alltraps>

8010640b <vector159>:
.globl vector159
vector159:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $159
8010640d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106412:	e9 d8 f4 ff ff       	jmp    801058ef <alltraps>

80106417 <vector160>:
.globl vector160
vector160:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $160
80106419:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010641e:	e9 cc f4 ff ff       	jmp    801058ef <alltraps>

80106423 <vector161>:
.globl vector161
vector161:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $161
80106425:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010642a:	e9 c0 f4 ff ff       	jmp    801058ef <alltraps>

8010642f <vector162>:
.globl vector162
vector162:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $162
80106431:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106436:	e9 b4 f4 ff ff       	jmp    801058ef <alltraps>

8010643b <vector163>:
.globl vector163
vector163:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $163
8010643d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106442:	e9 a8 f4 ff ff       	jmp    801058ef <alltraps>

80106447 <vector164>:
.globl vector164
vector164:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $164
80106449:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010644e:	e9 9c f4 ff ff       	jmp    801058ef <alltraps>

80106453 <vector165>:
.globl vector165
vector165:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $165
80106455:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010645a:	e9 90 f4 ff ff       	jmp    801058ef <alltraps>

8010645f <vector166>:
.globl vector166
vector166:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $166
80106461:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106466:	e9 84 f4 ff ff       	jmp    801058ef <alltraps>

8010646b <vector167>:
.globl vector167
vector167:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $167
8010646d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106472:	e9 78 f4 ff ff       	jmp    801058ef <alltraps>

80106477 <vector168>:
.globl vector168
vector168:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $168
80106479:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010647e:	e9 6c f4 ff ff       	jmp    801058ef <alltraps>

80106483 <vector169>:
.globl vector169
vector169:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $169
80106485:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010648a:	e9 60 f4 ff ff       	jmp    801058ef <alltraps>

8010648f <vector170>:
.globl vector170
vector170:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $170
80106491:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106496:	e9 54 f4 ff ff       	jmp    801058ef <alltraps>

8010649b <vector171>:
.globl vector171
vector171:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $171
8010649d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801064a2:	e9 48 f4 ff ff       	jmp    801058ef <alltraps>

801064a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $172
801064a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801064ae:	e9 3c f4 ff ff       	jmp    801058ef <alltraps>

801064b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $173
801064b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801064ba:	e9 30 f4 ff ff       	jmp    801058ef <alltraps>

801064bf <vector174>:
.globl vector174
vector174:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $174
801064c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064c6:	e9 24 f4 ff ff       	jmp    801058ef <alltraps>

801064cb <vector175>:
.globl vector175
vector175:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $175
801064cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064d2:	e9 18 f4 ff ff       	jmp    801058ef <alltraps>

801064d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $176
801064d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064de:	e9 0c f4 ff ff       	jmp    801058ef <alltraps>

801064e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $177
801064e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064ea:	e9 00 f4 ff ff       	jmp    801058ef <alltraps>

801064ef <vector178>:
.globl vector178
vector178:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $178
801064f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064f6:	e9 f4 f3 ff ff       	jmp    801058ef <alltraps>

801064fb <vector179>:
.globl vector179
vector179:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $179
801064fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106502:	e9 e8 f3 ff ff       	jmp    801058ef <alltraps>

80106507 <vector180>:
.globl vector180
vector180:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $180
80106509:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010650e:	e9 dc f3 ff ff       	jmp    801058ef <alltraps>

80106513 <vector181>:
.globl vector181
vector181:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $181
80106515:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010651a:	e9 d0 f3 ff ff       	jmp    801058ef <alltraps>

8010651f <vector182>:
.globl vector182
vector182:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $182
80106521:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106526:	e9 c4 f3 ff ff       	jmp    801058ef <alltraps>

8010652b <vector183>:
.globl vector183
vector183:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $183
8010652d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106532:	e9 b8 f3 ff ff       	jmp    801058ef <alltraps>

80106537 <vector184>:
.globl vector184
vector184:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $184
80106539:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010653e:	e9 ac f3 ff ff       	jmp    801058ef <alltraps>

80106543 <vector185>:
.globl vector185
vector185:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $185
80106545:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010654a:	e9 a0 f3 ff ff       	jmp    801058ef <alltraps>

8010654f <vector186>:
.globl vector186
vector186:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $186
80106551:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106556:	e9 94 f3 ff ff       	jmp    801058ef <alltraps>

8010655b <vector187>:
.globl vector187
vector187:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $187
8010655d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106562:	e9 88 f3 ff ff       	jmp    801058ef <alltraps>

80106567 <vector188>:
.globl vector188
vector188:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $188
80106569:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010656e:	e9 7c f3 ff ff       	jmp    801058ef <alltraps>

80106573 <vector189>:
.globl vector189
vector189:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $189
80106575:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010657a:	e9 70 f3 ff ff       	jmp    801058ef <alltraps>

8010657f <vector190>:
.globl vector190
vector190:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $190
80106581:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106586:	e9 64 f3 ff ff       	jmp    801058ef <alltraps>

8010658b <vector191>:
.globl vector191
vector191:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $191
8010658d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106592:	e9 58 f3 ff ff       	jmp    801058ef <alltraps>

80106597 <vector192>:
.globl vector192
vector192:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $192
80106599:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010659e:	e9 4c f3 ff ff       	jmp    801058ef <alltraps>

801065a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $193
801065a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801065aa:	e9 40 f3 ff ff       	jmp    801058ef <alltraps>

801065af <vector194>:
.globl vector194
vector194:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $194
801065b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801065b6:	e9 34 f3 ff ff       	jmp    801058ef <alltraps>

801065bb <vector195>:
.globl vector195
vector195:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $195
801065bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065c2:	e9 28 f3 ff ff       	jmp    801058ef <alltraps>

801065c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $196
801065c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065ce:	e9 1c f3 ff ff       	jmp    801058ef <alltraps>

801065d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $197
801065d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065da:	e9 10 f3 ff ff       	jmp    801058ef <alltraps>

801065df <vector198>:
.globl vector198
vector198:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $198
801065e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065e6:	e9 04 f3 ff ff       	jmp    801058ef <alltraps>

801065eb <vector199>:
.globl vector199
vector199:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $199
801065ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065f2:	e9 f8 f2 ff ff       	jmp    801058ef <alltraps>

801065f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $200
801065f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801065fe:	e9 ec f2 ff ff       	jmp    801058ef <alltraps>

80106603 <vector201>:
.globl vector201
vector201:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $201
80106605:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010660a:	e9 e0 f2 ff ff       	jmp    801058ef <alltraps>

8010660f <vector202>:
.globl vector202
vector202:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $202
80106611:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106616:	e9 d4 f2 ff ff       	jmp    801058ef <alltraps>

8010661b <vector203>:
.globl vector203
vector203:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $203
8010661d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106622:	e9 c8 f2 ff ff       	jmp    801058ef <alltraps>

80106627 <vector204>:
.globl vector204
vector204:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $204
80106629:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010662e:	e9 bc f2 ff ff       	jmp    801058ef <alltraps>

80106633 <vector205>:
.globl vector205
vector205:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $205
80106635:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010663a:	e9 b0 f2 ff ff       	jmp    801058ef <alltraps>

8010663f <vector206>:
.globl vector206
vector206:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $206
80106641:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106646:	e9 a4 f2 ff ff       	jmp    801058ef <alltraps>

8010664b <vector207>:
.globl vector207
vector207:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $207
8010664d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106652:	e9 98 f2 ff ff       	jmp    801058ef <alltraps>

80106657 <vector208>:
.globl vector208
vector208:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $208
80106659:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010665e:	e9 8c f2 ff ff       	jmp    801058ef <alltraps>

80106663 <vector209>:
.globl vector209
vector209:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $209
80106665:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010666a:	e9 80 f2 ff ff       	jmp    801058ef <alltraps>

8010666f <vector210>:
.globl vector210
vector210:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $210
80106671:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106676:	e9 74 f2 ff ff       	jmp    801058ef <alltraps>

8010667b <vector211>:
.globl vector211
vector211:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $211
8010667d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106682:	e9 68 f2 ff ff       	jmp    801058ef <alltraps>

80106687 <vector212>:
.globl vector212
vector212:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $212
80106689:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010668e:	e9 5c f2 ff ff       	jmp    801058ef <alltraps>

80106693 <vector213>:
.globl vector213
vector213:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $213
80106695:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010669a:	e9 50 f2 ff ff       	jmp    801058ef <alltraps>

8010669f <vector214>:
.globl vector214
vector214:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $214
801066a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801066a6:	e9 44 f2 ff ff       	jmp    801058ef <alltraps>

801066ab <vector215>:
.globl vector215
vector215:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $215
801066ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801066b2:	e9 38 f2 ff ff       	jmp    801058ef <alltraps>

801066b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $216
801066b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801066be:	e9 2c f2 ff ff       	jmp    801058ef <alltraps>

801066c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $217
801066c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066ca:	e9 20 f2 ff ff       	jmp    801058ef <alltraps>

801066cf <vector218>:
.globl vector218
vector218:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $218
801066d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066d6:	e9 14 f2 ff ff       	jmp    801058ef <alltraps>

801066db <vector219>:
.globl vector219
vector219:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $219
801066dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066e2:	e9 08 f2 ff ff       	jmp    801058ef <alltraps>

801066e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $220
801066e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066ee:	e9 fc f1 ff ff       	jmp    801058ef <alltraps>

801066f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $221
801066f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066fa:	e9 f0 f1 ff ff       	jmp    801058ef <alltraps>

801066ff <vector222>:
.globl vector222
vector222:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $222
80106701:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106706:	e9 e4 f1 ff ff       	jmp    801058ef <alltraps>

8010670b <vector223>:
.globl vector223
vector223:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $223
8010670d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106712:	e9 d8 f1 ff ff       	jmp    801058ef <alltraps>

80106717 <vector224>:
.globl vector224
vector224:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $224
80106719:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010671e:	e9 cc f1 ff ff       	jmp    801058ef <alltraps>

80106723 <vector225>:
.globl vector225
vector225:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $225
80106725:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010672a:	e9 c0 f1 ff ff       	jmp    801058ef <alltraps>

8010672f <vector226>:
.globl vector226
vector226:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $226
80106731:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106736:	e9 b4 f1 ff ff       	jmp    801058ef <alltraps>

8010673b <vector227>:
.globl vector227
vector227:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $227
8010673d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106742:	e9 a8 f1 ff ff       	jmp    801058ef <alltraps>

80106747 <vector228>:
.globl vector228
vector228:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $228
80106749:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010674e:	e9 9c f1 ff ff       	jmp    801058ef <alltraps>

80106753 <vector229>:
.globl vector229
vector229:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $229
80106755:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010675a:	e9 90 f1 ff ff       	jmp    801058ef <alltraps>

8010675f <vector230>:
.globl vector230
vector230:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $230
80106761:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106766:	e9 84 f1 ff ff       	jmp    801058ef <alltraps>

8010676b <vector231>:
.globl vector231
vector231:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $231
8010676d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106772:	e9 78 f1 ff ff       	jmp    801058ef <alltraps>

80106777 <vector232>:
.globl vector232
vector232:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $232
80106779:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010677e:	e9 6c f1 ff ff       	jmp    801058ef <alltraps>

80106783 <vector233>:
.globl vector233
vector233:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $233
80106785:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010678a:	e9 60 f1 ff ff       	jmp    801058ef <alltraps>

8010678f <vector234>:
.globl vector234
vector234:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $234
80106791:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106796:	e9 54 f1 ff ff       	jmp    801058ef <alltraps>

8010679b <vector235>:
.globl vector235
vector235:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $235
8010679d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801067a2:	e9 48 f1 ff ff       	jmp    801058ef <alltraps>

801067a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $236
801067a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801067ae:	e9 3c f1 ff ff       	jmp    801058ef <alltraps>

801067b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $237
801067b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801067ba:	e9 30 f1 ff ff       	jmp    801058ef <alltraps>

801067bf <vector238>:
.globl vector238
vector238:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $238
801067c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067c6:	e9 24 f1 ff ff       	jmp    801058ef <alltraps>

801067cb <vector239>:
.globl vector239
vector239:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $239
801067cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067d2:	e9 18 f1 ff ff       	jmp    801058ef <alltraps>

801067d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $240
801067d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067de:	e9 0c f1 ff ff       	jmp    801058ef <alltraps>

801067e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $241
801067e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067ea:	e9 00 f1 ff ff       	jmp    801058ef <alltraps>

801067ef <vector242>:
.globl vector242
vector242:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $242
801067f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067f6:	e9 f4 f0 ff ff       	jmp    801058ef <alltraps>

801067fb <vector243>:
.globl vector243
vector243:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $243
801067fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106802:	e9 e8 f0 ff ff       	jmp    801058ef <alltraps>

80106807 <vector244>:
.globl vector244
vector244:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $244
80106809:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010680e:	e9 dc f0 ff ff       	jmp    801058ef <alltraps>

80106813 <vector245>:
.globl vector245
vector245:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $245
80106815:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010681a:	e9 d0 f0 ff ff       	jmp    801058ef <alltraps>

8010681f <vector246>:
.globl vector246
vector246:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $246
80106821:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106826:	e9 c4 f0 ff ff       	jmp    801058ef <alltraps>

8010682b <vector247>:
.globl vector247
vector247:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $247
8010682d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106832:	e9 b8 f0 ff ff       	jmp    801058ef <alltraps>

80106837 <vector248>:
.globl vector248
vector248:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $248
80106839:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010683e:	e9 ac f0 ff ff       	jmp    801058ef <alltraps>

80106843 <vector249>:
.globl vector249
vector249:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $249
80106845:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010684a:	e9 a0 f0 ff ff       	jmp    801058ef <alltraps>

8010684f <vector250>:
.globl vector250
vector250:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $250
80106851:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106856:	e9 94 f0 ff ff       	jmp    801058ef <alltraps>

8010685b <vector251>:
.globl vector251
vector251:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $251
8010685d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106862:	e9 88 f0 ff ff       	jmp    801058ef <alltraps>

80106867 <vector252>:
.globl vector252
vector252:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $252
80106869:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010686e:	e9 7c f0 ff ff       	jmp    801058ef <alltraps>

80106873 <vector253>:
.globl vector253
vector253:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $253
80106875:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010687a:	e9 70 f0 ff ff       	jmp    801058ef <alltraps>

8010687f <vector254>:
.globl vector254
vector254:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $254
80106881:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106886:	e9 64 f0 ff ff       	jmp    801058ef <alltraps>

8010688b <vector255>:
.globl vector255
vector255:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $255
8010688d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106892:	e9 58 f0 ff ff       	jmp    801058ef <alltraps>
80106897:	66 90                	xchg   %ax,%ax
80106899:	66 90                	xchg   %ax,%ax
8010689b:	66 90                	xchg   %ax,%ax
8010689d:	66 90                	xchg   %ax,%ax
8010689f:	90                   	nop

801068a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	57                   	push   %edi
801068a4:	56                   	push   %esi
801068a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801068a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801068ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801068b2:	83 ec 1c             	sub    $0x1c,%esp
801068b5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801068b8:	39 d3                	cmp    %edx,%ebx
801068ba:	73 49                	jae    80106905 <deallocuvm.part.0+0x65>
801068bc:	89 c7                	mov    %eax,%edi
801068be:	eb 0c                	jmp    801068cc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068c0:	83 c0 01             	add    $0x1,%eax
801068c3:	c1 e0 16             	shl    $0x16,%eax
801068c6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801068c8:	39 da                	cmp    %ebx,%edx
801068ca:	76 39                	jbe    80106905 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801068cc:	89 d8                	mov    %ebx,%eax
801068ce:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801068d1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801068d4:	f6 c1 01             	test   $0x1,%cl
801068d7:	74 e7                	je     801068c0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801068d9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068db:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801068e1:	c1 ee 0a             	shr    $0xa,%esi
801068e4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801068ea:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801068f1:	85 f6                	test   %esi,%esi
801068f3:	74 cb                	je     801068c0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801068f5:	8b 06                	mov    (%esi),%eax
801068f7:	a8 01                	test   $0x1,%al
801068f9:	75 15                	jne    80106910 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801068fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106901:	39 da                	cmp    %ebx,%edx
80106903:	77 c7                	ja     801068cc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106905:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106908:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010690b:	5b                   	pop    %ebx
8010690c:	5e                   	pop    %esi
8010690d:	5f                   	pop    %edi
8010690e:	5d                   	pop    %ebp
8010690f:	c3                   	ret    
      if(pa == 0)
80106910:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106915:	74 25                	je     8010693c <deallocuvm.part.0+0x9c>
      kfree(v);
80106917:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010691a:	05 00 00 00 80       	add    $0x80000000,%eax
8010691f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106922:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106928:	50                   	push   %eax
80106929:	e8 92 bb ff ff       	call   801024c0 <kfree>
      *pte = 0;
8010692e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106934:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106937:	83 c4 10             	add    $0x10,%esp
8010693a:	eb 8c                	jmp    801068c8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010693c:	83 ec 0c             	sub    $0xc,%esp
8010693f:	68 06 75 10 80       	push   $0x80107506
80106944:	e8 37 9a ff ff       	call   80100380 <panic>
80106949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106950 <mappages>:
{
80106950:	55                   	push   %ebp
80106951:	89 e5                	mov    %esp,%ebp
80106953:	57                   	push   %edi
80106954:	56                   	push   %esi
80106955:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106956:	89 d3                	mov    %edx,%ebx
80106958:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010695e:	83 ec 1c             	sub    $0x1c,%esp
80106961:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106964:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106968:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010696d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106970:	8b 45 08             	mov    0x8(%ebp),%eax
80106973:	29 d8                	sub    %ebx,%eax
80106975:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106978:	eb 3d                	jmp    801069b7 <mappages+0x67>
8010697a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106980:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106982:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106987:	c1 ea 0a             	shr    $0xa,%edx
8010698a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106990:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106997:	85 c0                	test   %eax,%eax
80106999:	74 75                	je     80106a10 <mappages+0xc0>
    if(*pte & PTE_P)
8010699b:	f6 00 01             	testb  $0x1,(%eax)
8010699e:	0f 85 86 00 00 00    	jne    80106a2a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801069a4:	0b 75 0c             	or     0xc(%ebp),%esi
801069a7:	83 ce 01             	or     $0x1,%esi
801069aa:	89 30                	mov    %esi,(%eax)
    if(a == last)
801069ac:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801069af:	74 6f                	je     80106a20 <mappages+0xd0>
    a += PGSIZE;
801069b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801069b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801069ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801069bd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801069c0:	89 d8                	mov    %ebx,%eax
801069c2:	c1 e8 16             	shr    $0x16,%eax
801069c5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801069c8:	8b 07                	mov    (%edi),%eax
801069ca:	a8 01                	test   $0x1,%al
801069cc:	75 b2                	jne    80106980 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801069ce:	e8 ad bc ff ff       	call   80102680 <kalloc>
801069d3:	85 c0                	test   %eax,%eax
801069d5:	74 39                	je     80106a10 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801069d7:	83 ec 04             	sub    $0x4,%esp
801069da:	89 45 d8             	mov    %eax,-0x28(%ebp)
801069dd:	68 00 10 00 00       	push   $0x1000
801069e2:	6a 00                	push   $0x0
801069e4:	50                   	push   %eax
801069e5:	e8 b6 dc ff ff       	call   801046a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801069ed:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069f0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801069f6:	83 c8 07             	or     $0x7,%eax
801069f9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801069fb:	89 d8                	mov    %ebx,%eax
801069fd:	c1 e8 0a             	shr    $0xa,%eax
80106a00:	25 fc 0f 00 00       	and    $0xffc,%eax
80106a05:	01 d0                	add    %edx,%eax
80106a07:	eb 92                	jmp    8010699b <mappages+0x4b>
80106a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a18:	5b                   	pop    %ebx
80106a19:	5e                   	pop    %esi
80106a1a:	5f                   	pop    %edi
80106a1b:	5d                   	pop    %ebp
80106a1c:	c3                   	ret    
80106a1d:	8d 76 00             	lea    0x0(%esi),%esi
80106a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a23:	31 c0                	xor    %eax,%eax
}
80106a25:	5b                   	pop    %ebx
80106a26:	5e                   	pop    %esi
80106a27:	5f                   	pop    %edi
80106a28:	5d                   	pop    %ebp
80106a29:	c3                   	ret    
      panic("remap");
80106a2a:	83 ec 0c             	sub    $0xc,%esp
80106a2d:	68 4c 7b 10 80       	push   $0x80107b4c
80106a32:	e8 49 99 ff ff       	call   80100380 <panic>
80106a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a3e:	66 90                	xchg   %ax,%ax

80106a40 <seginit>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106a46:	e8 25 cf ff ff       	call   80103970 <cpuid>
  pd[0] = size-1;
80106a4b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106a50:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a5a:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106a61:	ff 00 00 
80106a64:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106a6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a6e:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106a75:	ff 00 00 
80106a78:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106a7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a82:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106a89:	ff 00 00 
80106a8c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106a93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a96:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106a9d:	ff 00 00 
80106aa0:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106aa7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106aaa:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106aaf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ab3:	c1 e8 10             	shr    $0x10,%eax
80106ab6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106aba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106abd:	0f 01 10             	lgdtl  (%eax)
}
80106ac0:	c9                   	leave  
80106ac1:	c3                   	ret    
80106ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ad0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ad0:	a1 c4 48 11 80       	mov    0x801148c4,%eax
80106ad5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ada:	0f 22 d8             	mov    %eax,%cr3
}
80106add:	c3                   	ret    
80106ade:	66 90                	xchg   %ax,%ax

80106ae0 <switchuvm>:
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	57                   	push   %edi
80106ae4:	56                   	push   %esi
80106ae5:	53                   	push   %ebx
80106ae6:	83 ec 1c             	sub    $0x1c,%esp
80106ae9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106aec:	85 f6                	test   %esi,%esi
80106aee:	0f 84 cb 00 00 00    	je     80106bbf <switchuvm+0xdf>
  if(p->kstack == 0)
80106af4:	8b 46 08             	mov    0x8(%esi),%eax
80106af7:	85 c0                	test   %eax,%eax
80106af9:	0f 84 da 00 00 00    	je     80106bd9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106aff:	8b 46 04             	mov    0x4(%esi),%eax
80106b02:	85 c0                	test   %eax,%eax
80106b04:	0f 84 c2 00 00 00    	je     80106bcc <switchuvm+0xec>
  pushcli();
80106b0a:	e8 81 d9 ff ff       	call   80104490 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b0f:	e8 fc cd ff ff       	call   80103910 <mycpu>
80106b14:	89 c3                	mov    %eax,%ebx
80106b16:	e8 f5 cd ff ff       	call   80103910 <mycpu>
80106b1b:	89 c7                	mov    %eax,%edi
80106b1d:	e8 ee cd ff ff       	call   80103910 <mycpu>
80106b22:	83 c7 08             	add    $0x8,%edi
80106b25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b28:	e8 e3 cd ff ff       	call   80103910 <mycpu>
80106b2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b30:	ba 67 00 00 00       	mov    $0x67,%edx
80106b35:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b3c:	83 c0 08             	add    $0x8,%eax
80106b3f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b46:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b4b:	83 c1 08             	add    $0x8,%ecx
80106b4e:	c1 e8 18             	shr    $0x18,%eax
80106b51:	c1 e9 10             	shr    $0x10,%ecx
80106b54:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106b5a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b60:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b65:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b6c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106b71:	e8 9a cd ff ff       	call   80103910 <mycpu>
80106b76:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b7d:	e8 8e cd ff ff       	call   80103910 <mycpu>
80106b82:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b86:	8b 5e 08             	mov    0x8(%esi),%ebx
80106b89:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b8f:	e8 7c cd ff ff       	call   80103910 <mycpu>
80106b94:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b97:	e8 74 cd ff ff       	call   80103910 <mycpu>
80106b9c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ba0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ba5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ba8:	8b 46 04             	mov    0x4(%esi),%eax
80106bab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bb0:	0f 22 d8             	mov    %eax,%cr3
}
80106bb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bb6:	5b                   	pop    %ebx
80106bb7:	5e                   	pop    %esi
80106bb8:	5f                   	pop    %edi
80106bb9:	5d                   	pop    %ebp
  popcli();
80106bba:	e9 21 d9 ff ff       	jmp    801044e0 <popcli>
    panic("switchuvm: no process");
80106bbf:	83 ec 0c             	sub    $0xc,%esp
80106bc2:	68 52 7b 10 80       	push   $0x80107b52
80106bc7:	e8 b4 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106bcc:	83 ec 0c             	sub    $0xc,%esp
80106bcf:	68 7d 7b 10 80       	push   $0x80107b7d
80106bd4:	e8 a7 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106bd9:	83 ec 0c             	sub    $0xc,%esp
80106bdc:	68 68 7b 10 80       	push   $0x80107b68
80106be1:	e8 9a 97 ff ff       	call   80100380 <panic>
80106be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bed:	8d 76 00             	lea    0x0(%esi),%esi

80106bf0 <inituvm>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 1c             	sub    $0x1c,%esp
80106bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bfc:	8b 75 10             	mov    0x10(%ebp),%esi
80106bff:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106c05:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c0b:	77 4b                	ja     80106c58 <inituvm+0x68>
  mem = kalloc();
80106c0d:	e8 6e ba ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80106c12:	83 ec 04             	sub    $0x4,%esp
80106c15:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106c1a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c1c:	6a 00                	push   $0x0
80106c1e:	50                   	push   %eax
80106c1f:	e8 7c da ff ff       	call   801046a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c24:	58                   	pop    %eax
80106c25:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c2b:	5a                   	pop    %edx
80106c2c:	6a 06                	push   $0x6
80106c2e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c33:	31 d2                	xor    %edx,%edx
80106c35:	50                   	push   %eax
80106c36:	89 f8                	mov    %edi,%eax
80106c38:	e8 13 fd ff ff       	call   80106950 <mappages>
  memmove(mem, init, sz);
80106c3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c40:	89 75 10             	mov    %esi,0x10(%ebp)
80106c43:	83 c4 10             	add    $0x10,%esp
80106c46:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106c49:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c4f:	5b                   	pop    %ebx
80106c50:	5e                   	pop    %esi
80106c51:	5f                   	pop    %edi
80106c52:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c53:	e9 e8 da ff ff       	jmp    80104740 <memmove>
    panic("inituvm: more than a page");
80106c58:	83 ec 0c             	sub    $0xc,%esp
80106c5b:	68 91 7b 10 80       	push   $0x80107b91
80106c60:	e8 1b 97 ff ff       	call   80100380 <panic>
80106c65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c70 <loaduvm>:
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	57                   	push   %edi
80106c74:	56                   	push   %esi
80106c75:	53                   	push   %ebx
80106c76:	83 ec 1c             	sub    $0x1c,%esp
80106c79:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c7c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106c7f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106c84:	0f 85 bb 00 00 00    	jne    80106d45 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106c8a:	01 f0                	add    %esi,%eax
80106c8c:	89 f3                	mov    %esi,%ebx
80106c8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c91:	8b 45 14             	mov    0x14(%ebp),%eax
80106c94:	01 f0                	add    %esi,%eax
80106c96:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106c99:	85 f6                	test   %esi,%esi
80106c9b:	0f 84 87 00 00 00    	je     80106d28 <loaduvm+0xb8>
80106ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106cab:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106cae:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106cb0:	89 c2                	mov    %eax,%edx
80106cb2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106cb5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106cb8:	f6 c2 01             	test   $0x1,%dl
80106cbb:	75 13                	jne    80106cd0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106cbd:	83 ec 0c             	sub    $0xc,%esp
80106cc0:	68 ab 7b 10 80       	push   $0x80107bab
80106cc5:	e8 b6 96 ff ff       	call   80100380 <panic>
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106cd0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cd3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106cd9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106cde:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ce5:	85 c0                	test   %eax,%eax
80106ce7:	74 d4                	je     80106cbd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106ce9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ceb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106cee:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106cf3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106cf8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106cfe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d01:	29 d9                	sub    %ebx,%ecx
80106d03:	05 00 00 00 80       	add    $0x80000000,%eax
80106d08:	57                   	push   %edi
80106d09:	51                   	push   %ecx
80106d0a:	50                   	push   %eax
80106d0b:	ff 75 10             	push   0x10(%ebp)
80106d0e:	e8 7d ad ff ff       	call   80101a90 <readi>
80106d13:	83 c4 10             	add    $0x10,%esp
80106d16:	39 f8                	cmp    %edi,%eax
80106d18:	75 1e                	jne    80106d38 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106d1a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106d20:	89 f0                	mov    %esi,%eax
80106d22:	29 d8                	sub    %ebx,%eax
80106d24:	39 c6                	cmp    %eax,%esi
80106d26:	77 80                	ja     80106ca8 <loaduvm+0x38>
}
80106d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d2b:	31 c0                	xor    %eax,%eax
}
80106d2d:	5b                   	pop    %ebx
80106d2e:	5e                   	pop    %esi
80106d2f:	5f                   	pop    %edi
80106d30:	5d                   	pop    %ebp
80106d31:	c3                   	ret    
80106d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d40:	5b                   	pop    %ebx
80106d41:	5e                   	pop    %esi
80106d42:	5f                   	pop    %edi
80106d43:	5d                   	pop    %ebp
80106d44:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106d45:	83 ec 0c             	sub    $0xc,%esp
80106d48:	68 4c 7c 10 80       	push   $0x80107c4c
80106d4d:	e8 2e 96 ff ff       	call   80100380 <panic>
80106d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d60 <allocuvm>:
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106d69:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106d6c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106d6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d72:	85 c0                	test   %eax,%eax
80106d74:	0f 88 b6 00 00 00    	js     80106e30 <allocuvm+0xd0>
  if(newsz < oldsz)
80106d7a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106d80:	0f 82 9a 00 00 00    	jb     80106e20 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106d86:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106d8c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106d92:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d95:	77 44                	ja     80106ddb <allocuvm+0x7b>
80106d97:	e9 87 00 00 00       	jmp    80106e23 <allocuvm+0xc3>
80106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106da0:	83 ec 04             	sub    $0x4,%esp
80106da3:	68 00 10 00 00       	push   $0x1000
80106da8:	6a 00                	push   $0x0
80106daa:	50                   	push   %eax
80106dab:	e8 f0 d8 ff ff       	call   801046a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106db0:	58                   	pop    %eax
80106db1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106db7:	5a                   	pop    %edx
80106db8:	6a 06                	push   $0x6
80106dba:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dbf:	89 f2                	mov    %esi,%edx
80106dc1:	50                   	push   %eax
80106dc2:	89 f8                	mov    %edi,%eax
80106dc4:	e8 87 fb ff ff       	call   80106950 <mappages>
80106dc9:	83 c4 10             	add    $0x10,%esp
80106dcc:	85 c0                	test   %eax,%eax
80106dce:	78 78                	js     80106e48 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106dd0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106dd6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106dd9:	76 48                	jbe    80106e23 <allocuvm+0xc3>
    mem = kalloc();
80106ddb:	e8 a0 b8 ff ff       	call   80102680 <kalloc>
80106de0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106de2:	85 c0                	test   %eax,%eax
80106de4:	75 ba                	jne    80106da0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106de6:	83 ec 0c             	sub    $0xc,%esp
80106de9:	68 c9 7b 10 80       	push   $0x80107bc9
80106dee:	e8 ad 98 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106df3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106df6:	83 c4 10             	add    $0x10,%esp
80106df9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106dfc:	74 32                	je     80106e30 <allocuvm+0xd0>
80106dfe:	8b 55 10             	mov    0x10(%ebp),%edx
80106e01:	89 c1                	mov    %eax,%ecx
80106e03:	89 f8                	mov    %edi,%eax
80106e05:	e8 96 fa ff ff       	call   801068a0 <deallocuvm.part.0>
      return 0;
80106e0a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e17:	5b                   	pop    %ebx
80106e18:	5e                   	pop    %esi
80106e19:	5f                   	pop    %edi
80106e1a:	5d                   	pop    %ebp
80106e1b:	c3                   	ret    
80106e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106e20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e29:	5b                   	pop    %ebx
80106e2a:	5e                   	pop    %esi
80106e2b:	5f                   	pop    %edi
80106e2c:	5d                   	pop    %ebp
80106e2d:	c3                   	ret    
80106e2e:	66 90                	xchg   %ax,%ax
    return 0;
80106e30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e3d:	5b                   	pop    %ebx
80106e3e:	5e                   	pop    %esi
80106e3f:	5f                   	pop    %edi
80106e40:	5d                   	pop    %ebp
80106e41:	c3                   	ret    
80106e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106e48:	83 ec 0c             	sub    $0xc,%esp
80106e4b:	68 e1 7b 10 80       	push   $0x80107be1
80106e50:	e8 4b 98 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106e55:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e58:	83 c4 10             	add    $0x10,%esp
80106e5b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e5e:	74 0c                	je     80106e6c <allocuvm+0x10c>
80106e60:	8b 55 10             	mov    0x10(%ebp),%edx
80106e63:	89 c1                	mov    %eax,%ecx
80106e65:	89 f8                	mov    %edi,%eax
80106e67:	e8 34 fa ff ff       	call   801068a0 <deallocuvm.part.0>
      kfree(mem);
80106e6c:	83 ec 0c             	sub    $0xc,%esp
80106e6f:	53                   	push   %ebx
80106e70:	e8 4b b6 ff ff       	call   801024c0 <kfree>
      return 0;
80106e75:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106e7c:	83 c4 10             	add    $0x10,%esp
}
80106e7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e90 <deallocuvm>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e96:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e99:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e9c:	39 d1                	cmp    %edx,%ecx
80106e9e:	73 10                	jae    80106eb0 <deallocuvm+0x20>
}
80106ea0:	5d                   	pop    %ebp
80106ea1:	e9 fa f9 ff ff       	jmp    801068a0 <deallocuvm.part.0>
80106ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ead:	8d 76 00             	lea    0x0(%esi),%esi
80106eb0:	89 d0                	mov    %edx,%eax
80106eb2:	5d                   	pop    %ebp
80106eb3:	c3                   	ret    
80106eb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ebf:	90                   	nop

80106ec0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 0c             	sub    $0xc,%esp
80106ec9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ecc:	85 f6                	test   %esi,%esi
80106ece:	74 59                	je     80106f29 <freevm+0x69>
  if(newsz >= oldsz)
80106ed0:	31 c9                	xor    %ecx,%ecx
80106ed2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ed7:	89 f0                	mov    %esi,%eax
80106ed9:	89 f3                	mov    %esi,%ebx
80106edb:	e8 c0 f9 ff ff       	call   801068a0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ee0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ee6:	eb 0f                	jmp    80106ef7 <freevm+0x37>
80106ee8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eef:	90                   	nop
80106ef0:	83 c3 04             	add    $0x4,%ebx
80106ef3:	39 df                	cmp    %ebx,%edi
80106ef5:	74 23                	je     80106f1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ef7:	8b 03                	mov    (%ebx),%eax
80106ef9:	a8 01                	test   $0x1,%al
80106efb:	74 f3                	je     80106ef0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106efd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f02:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f05:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f08:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f0d:	50                   	push   %eax
80106f0e:	e8 ad b5 ff ff       	call   801024c0 <kfree>
80106f13:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f16:	39 df                	cmp    %ebx,%edi
80106f18:	75 dd                	jne    80106ef7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f20:	5b                   	pop    %ebx
80106f21:	5e                   	pop    %esi
80106f22:	5f                   	pop    %edi
80106f23:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f24:	e9 97 b5 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80106f29:	83 ec 0c             	sub    $0xc,%esp
80106f2c:	68 fd 7b 10 80       	push   $0x80107bfd
80106f31:	e8 4a 94 ff ff       	call   80100380 <panic>
80106f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3d:	8d 76 00             	lea    0x0(%esi),%esi

80106f40 <setupkvm>:
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	56                   	push   %esi
80106f44:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f45:	e8 36 b7 ff ff       	call   80102680 <kalloc>
80106f4a:	89 c6                	mov    %eax,%esi
80106f4c:	85 c0                	test   %eax,%eax
80106f4e:	74 42                	je     80106f92 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106f50:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f53:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f58:	68 00 10 00 00       	push   $0x1000
80106f5d:	6a 00                	push   $0x0
80106f5f:	50                   	push   %eax
80106f60:	e8 3b d7 ff ff       	call   801046a0 <memset>
80106f65:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f68:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f6b:	83 ec 08             	sub    $0x8,%esp
80106f6e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f71:	ff 73 0c             	push   0xc(%ebx)
80106f74:	8b 13                	mov    (%ebx),%edx
80106f76:	50                   	push   %eax
80106f77:	29 c1                	sub    %eax,%ecx
80106f79:	89 f0                	mov    %esi,%eax
80106f7b:	e8 d0 f9 ff ff       	call   80106950 <mappages>
80106f80:	83 c4 10             	add    $0x10,%esp
80106f83:	85 c0                	test   %eax,%eax
80106f85:	78 19                	js     80106fa0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f87:	83 c3 10             	add    $0x10,%ebx
80106f8a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f90:	75 d6                	jne    80106f68 <setupkvm+0x28>
}
80106f92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f95:	89 f0                	mov    %esi,%eax
80106f97:	5b                   	pop    %ebx
80106f98:	5e                   	pop    %esi
80106f99:	5d                   	pop    %ebp
80106f9a:	c3                   	ret    
80106f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f9f:	90                   	nop
      freevm(pgdir);
80106fa0:	83 ec 0c             	sub    $0xc,%esp
80106fa3:	56                   	push   %esi
      return 0;
80106fa4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106fa6:	e8 15 ff ff ff       	call   80106ec0 <freevm>
      return 0;
80106fab:	83 c4 10             	add    $0x10,%esp
}
80106fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fb1:	89 f0                	mov    %esi,%eax
80106fb3:	5b                   	pop    %ebx
80106fb4:	5e                   	pop    %esi
80106fb5:	5d                   	pop    %ebp
80106fb6:	c3                   	ret    
80106fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fbe:	66 90                	xchg   %ax,%ax

80106fc0 <kvmalloc>:
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106fc6:	e8 75 ff ff ff       	call   80106f40 <setupkvm>
80106fcb:	a3 c4 48 11 80       	mov    %eax,0x801148c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fd0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fd5:	0f 22 d8             	mov    %eax,%cr3
}
80106fd8:	c9                   	leave  
80106fd9:	c3                   	ret    
80106fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fe0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	83 ec 08             	sub    $0x8,%esp
80106fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106fe9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106fec:	89 c1                	mov    %eax,%ecx
80106fee:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106ff1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106ff4:	f6 c2 01             	test   $0x1,%dl
80106ff7:	75 17                	jne    80107010 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106ff9:	83 ec 0c             	sub    $0xc,%esp
80106ffc:	68 0e 7c 10 80       	push   $0x80107c0e
80107001:	e8 7a 93 ff ff       	call   80100380 <panic>
80107006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107010:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107013:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107019:	25 fc 0f 00 00       	and    $0xffc,%eax
8010701e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107025:	85 c0                	test   %eax,%eax
80107027:	74 d0                	je     80106ff9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107029:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010702c:	c9                   	leave  
8010702d:	c3                   	ret    
8010702e:	66 90                	xchg   %ax,%ax

80107030 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107039:	e8 02 ff ff ff       	call   80106f40 <setupkvm>
8010703e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107041:	85 c0                	test   %eax,%eax
80107043:	0f 84 bd 00 00 00    	je     80107106 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010704c:	85 c9                	test   %ecx,%ecx
8010704e:	0f 84 b2 00 00 00    	je     80107106 <copyuvm+0xd6>
80107054:	31 f6                	xor    %esi,%esi
80107056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107060:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107063:	89 f0                	mov    %esi,%eax
80107065:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107068:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010706b:	a8 01                	test   $0x1,%al
8010706d:	75 11                	jne    80107080 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010706f:	83 ec 0c             	sub    $0xc,%esp
80107072:	68 18 7c 10 80       	push   $0x80107c18
80107077:	e8 04 93 ff ff       	call   80100380 <panic>
8010707c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107080:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107082:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107087:	c1 ea 0a             	shr    $0xa,%edx
8010708a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107090:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107097:	85 c0                	test   %eax,%eax
80107099:	74 d4                	je     8010706f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010709b:	8b 00                	mov    (%eax),%eax
8010709d:	a8 01                	test   $0x1,%al
8010709f:	0f 84 9f 00 00 00    	je     80107144 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801070a5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801070a7:	25 ff 0f 00 00       	and    $0xfff,%eax
801070ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801070af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801070b5:	e8 c6 b5 ff ff       	call   80102680 <kalloc>
801070ba:	89 c3                	mov    %eax,%ebx
801070bc:	85 c0                	test   %eax,%eax
801070be:	74 64                	je     80107124 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801070c0:	83 ec 04             	sub    $0x4,%esp
801070c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801070c9:	68 00 10 00 00       	push   $0x1000
801070ce:	57                   	push   %edi
801070cf:	50                   	push   %eax
801070d0:	e8 6b d6 ff ff       	call   80104740 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801070d5:	58                   	pop    %eax
801070d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070dc:	5a                   	pop    %edx
801070dd:	ff 75 e4             	push   -0x1c(%ebp)
801070e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070e5:	89 f2                	mov    %esi,%edx
801070e7:	50                   	push   %eax
801070e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070eb:	e8 60 f8 ff ff       	call   80106950 <mappages>
801070f0:	83 c4 10             	add    $0x10,%esp
801070f3:	85 c0                	test   %eax,%eax
801070f5:	78 21                	js     80107118 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801070f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107100:	0f 87 5a ff ff ff    	ja     80107060 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107106:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107109:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010710c:	5b                   	pop    %ebx
8010710d:	5e                   	pop    %esi
8010710e:	5f                   	pop    %edi
8010710f:	5d                   	pop    %ebp
80107110:	c3                   	ret    
80107111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107118:	83 ec 0c             	sub    $0xc,%esp
8010711b:	53                   	push   %ebx
8010711c:	e8 9f b3 ff ff       	call   801024c0 <kfree>
      goto bad;
80107121:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107124:	83 ec 0c             	sub    $0xc,%esp
80107127:	ff 75 e0             	push   -0x20(%ebp)
8010712a:	e8 91 fd ff ff       	call   80106ec0 <freevm>
  return 0;
8010712f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107136:	83 c4 10             	add    $0x10,%esp
}
80107139:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010713c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010713f:	5b                   	pop    %ebx
80107140:	5e                   	pop    %esi
80107141:	5f                   	pop    %edi
80107142:	5d                   	pop    %ebp
80107143:	c3                   	ret    
      panic("copyuvm: page not present");
80107144:	83 ec 0c             	sub    $0xc,%esp
80107147:	68 32 7c 10 80       	push   $0x80107c32
8010714c:	e8 2f 92 ff ff       	call   80100380 <panic>
80107151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715f:	90                   	nop

80107160 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107166:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107169:	89 c1                	mov    %eax,%ecx
8010716b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010716e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107171:	f6 c2 01             	test   $0x1,%dl
80107174:	0f 84 00 01 00 00    	je     8010727a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010717a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010717d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107183:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107184:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107189:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107190:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107192:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107197:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010719a:	05 00 00 00 80       	add    $0x80000000,%eax
8010719f:	83 fa 05             	cmp    $0x5,%edx
801071a2:	ba 00 00 00 00       	mov    $0x0,%edx
801071a7:	0f 45 c2             	cmovne %edx,%eax
}
801071aa:	c3                   	ret    
801071ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071af:	90                   	nop

801071b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 0c             	sub    $0xc,%esp
801071b9:	8b 75 14             	mov    0x14(%ebp),%esi
801071bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801071bf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071c2:	85 f6                	test   %esi,%esi
801071c4:	75 51                	jne    80107217 <copyout+0x67>
801071c6:	e9 a5 00 00 00       	jmp    80107270 <copyout+0xc0>
801071cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071cf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801071d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801071d6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801071dc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801071e2:	74 75                	je     80107259 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801071e4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801071e6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801071e9:	29 c3                	sub    %eax,%ebx
801071eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071f1:	39 f3                	cmp    %esi,%ebx
801071f3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801071f6:	29 f8                	sub    %edi,%eax
801071f8:	83 ec 04             	sub    $0x4,%esp
801071fb:	01 c1                	add    %eax,%ecx
801071fd:	53                   	push   %ebx
801071fe:	52                   	push   %edx
801071ff:	51                   	push   %ecx
80107200:	e8 3b d5 ff ff       	call   80104740 <memmove>
    len -= n;
    buf += n;
80107205:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107208:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010720e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107211:	01 da                	add    %ebx,%edx
  while(len > 0){
80107213:	29 de                	sub    %ebx,%esi
80107215:	74 59                	je     80107270 <copyout+0xc0>
  if(*pde & PTE_P){
80107217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010721a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010721c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010721e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107221:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107227:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010722a:	f6 c1 01             	test   $0x1,%cl
8010722d:	0f 84 4e 00 00 00    	je     80107281 <copyout.cold>
  return &pgtab[PTX(va)];
80107233:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107235:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010723b:	c1 eb 0c             	shr    $0xc,%ebx
8010723e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107244:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010724b:	89 d9                	mov    %ebx,%ecx
8010724d:	83 e1 05             	and    $0x5,%ecx
80107250:	83 f9 05             	cmp    $0x5,%ecx
80107253:	0f 84 77 ff ff ff    	je     801071d0 <copyout+0x20>
  }
  return 0;
}
80107259:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010725c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107261:	5b                   	pop    %ebx
80107262:	5e                   	pop    %esi
80107263:	5f                   	pop    %edi
80107264:	5d                   	pop    %ebp
80107265:	c3                   	ret    
80107266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726d:	8d 76 00             	lea    0x0(%esi),%esi
80107270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107273:	31 c0                	xor    %eax,%eax
}
80107275:	5b                   	pop    %ebx
80107276:	5e                   	pop    %esi
80107277:	5f                   	pop    %edi
80107278:	5d                   	pop    %ebp
80107279:	c3                   	ret    

8010727a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010727a:	a1 00 00 00 00       	mov    0x0,%eax
8010727f:	0f 0b                	ud2    

80107281 <copyout.cold>:
80107281:	a1 00 00 00 00       	mov    0x0,%eax
80107286:	0f 0b                	ud2    
