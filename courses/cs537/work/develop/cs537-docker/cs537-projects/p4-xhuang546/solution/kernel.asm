
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc d0 b6 13 80       	mov    $0x8013b6d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 31 10 80       	mov    $0x801031c0,%eax
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
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 89 10 80       	push   $0x801089e0
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 45 45 00 00       	call   801045a0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
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
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 89 10 80       	push   $0x801089e7
80100097:	50                   	push   %eax
80100098:	e8 d3 43 00 00       	call   80104470 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
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
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 87 46 00 00       	call   80104770 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 a9 45 00 00       	call   80104710 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 43 00 00       	call   801044b0 <acquiresleep>
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
801001a1:	68 ee 89 10 80       	push   $0x801089ee
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
801001be:	e8 8d 43 00 00       	call   80104550 <holdingsleep>
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
801001dc:	68 ff 89 10 80       	push   $0x801089ff
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
801001ff:	e8 4c 43 00 00       	call   80104550 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 fc 42 00 00       	call   80104510 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 50 45 00 00       	call   80104770 <acquire>
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
80100242:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 9f 44 00 00       	jmp    80104710 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 8a 10 80       	push   $0x80108a06
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
80100299:	c7 04 24 20 0f 11 80 	movl   $0x80110f20,(%esp)
801002a0:	e8 cb 44 00 00       	call   80104770 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002b5:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
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
801002c3:	68 20 0f 11 80       	push   $0x80110f20
801002c8:	68 00 0f 11 80       	push   $0x80110f00
801002cd:	e8 3e 3f 00 00       	call   80104210 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 f9 37 00 00       	call   80103ae0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 0f 11 80       	push   $0x80110f20
801002f6:	e8 15 44 00 00       	call   80104710 <release>
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
8010031b:	89 15 00 0f 11 80    	mov    %edx,0x80110f00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 0e 11 80 	movsbl -0x7feef180(%edx),%ecx
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
80100347:	68 20 0f 11 80       	push   $0x80110f20
8010034c:	e8 bf 43 00 00       	call   80104710 <release>
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
8010036d:	a3 00 0f 11 80       	mov    %eax,0x80110f00
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
80100389:	c7 05 54 0f 11 80 00 	movl   $0x0,0x80110f54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 b2 26 00 00       	call   80102a50 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 8a 10 80       	push   $0x80108a0d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 07 94 10 80 	movl   $0x80109407,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 f3 41 00 00       	call   801045c0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 8a 10 80       	push   $0x80108a21
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 0f 11 80 01 	movl   $0x1,0x80110f58
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
8010041a:	e8 21 5b 00 00       	call   80105f40 <uartputc>
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
80100505:	e8 36 5a 00 00       	call   80105f40 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 2a 5a 00 00       	call   80105f40 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 1e 5a 00 00       	call   80105f40 <uartputc>
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
80100551:	e8 7a 43 00 00       	call   801048d0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 c5 42 00 00       	call   80104830 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 8a 10 80       	push   $0x80108a25
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
801005a4:	c7 04 24 20 0f 11 80 	movl   $0x80110f20,(%esp)
801005ab:	e8 c0 41 00 00       	call   80104770 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
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
801005df:	68 20 0f 11 80       	push   $0x80110f20
801005e4:	e8 27 41 00 00       	call   80104710 <release>
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
80100636:	0f b6 92 50 8a 10 80 	movzbl -0x7fef75b0(%edx),%edx
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
80100662:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
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
801006a9:	a1 54 0f 11 80       	mov    0x80110f54,%eax
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
80100760:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
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
801007a8:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 0f 11 80       	mov    0x80110f58,%eax
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
801007e3:	68 20 0f 11 80       	push   $0x80110f20
801007e8:	e8 83 3f 00 00       	call   80104770 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
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
80100838:	bf 38 8a 10 80       	mov    $0x80108a38,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 0f 11 80       	push   $0x80110f20
8010085b:	e8 b0 3e 00 00       	call   80104710 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 8a 10 80       	push   $0x80108a3f
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
8010088e:	68 20 0f 11 80       	push   $0x80110f20
80100893:	e8 d8 3e 00 00       	call   80104770 <acquire>
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
801008d3:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 0f 11 80    	sub    0x80110f00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 0f 11 80    	mov    %ecx,0x80110f08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 0e 11 80    	mov    %bl,-0x7feef180(%eax)
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
80100927:	a1 00 0f 11 80       	mov    0x80110f00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 0f 11 80    	cmp    %eax,0x80110f08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100945:	39 05 04 0f 11 80    	cmp    %eax,0x80110f04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
        input.e--;
8010096c:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100985:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked){
80100999:	a1 58 0f 11 80       	mov    0x80110f58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 0f 11 80       	mov    0x80110f08,%eax
801009b7:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 0f 11 80       	push   $0x80110f20
801009d0:	e8 3b 3d 00 00       	call   80104710 <release>
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
80100a0e:	e9 9d 39 00 00       	jmp    801043b0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 0e 11 80 0a 	movb   $0xa,-0x7feef180(%eax)
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
80100a32:	a1 08 0f 11 80       	mov    0x80110f08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 0f 11 80       	mov    %eax,0x80110f04
          wakeup(&input.r);
80100a3f:	68 00 0f 11 80       	push   $0x80110f00
80100a44:	e8 87 38 00 00       	call   801042d0 <wakeup>
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
80100a66:	68 48 8a 10 80       	push   $0x80108a48
80100a6b:	68 20 0f 11 80       	push   $0x80110f20
80100a70:	e8 2b 3b 00 00       	call   801045a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 19 11 80 90 	movl   $0x80100590,0x8011190c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 19 11 80 80 	movl   $0x80100280,0x80111908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 0f 11 80 01 	movl   $0x1,0x80110f54
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
80100abc:	e8 1f 30 00 00       	call   80103ae0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 f4 23 00 00       	call   80102ec0 <begin_op>

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
80100b0f:	e8 1c 24 00 00       	call   80102f30 <end_op>
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
80100b34:	e8 17 66 00 00       	call   80107150 <setupkvm>
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
80100ba3:	e8 d8 63 00 00       	call   80106f80 <allocuvm>
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
80100bd9:	e8 b2 62 00 00       	call   80106e90 <loaduvm>
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
80100c1b:	e8 b0 64 00 00       	call   801070d0 <freevm>
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
80100c51:	e8 da 22 00 00       	call   80102f30 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 19 63 00 00       	call   80106f80 <allocuvm>
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
80100c83:	e8 68 65 00 00       	call   801071f0 <clearpteu>
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
80100cd3:	e8 58 3d 00 00       	call   80104a30 <strlen>
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
80100ce7:	e8 44 3d 00 00       	call   80104a30 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 c3 66 00 00       	call   801073c0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 ba 63 00 00       	call   801070d0 <freevm>
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
80100d63:	e8 58 66 00 00       	call   801073c0 <copyout>
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
80100da1:	e8 4a 3c 00 00       	call   801049f0 <safestrcpy>
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
80100dcd:	e8 2e 5f 00 00       	call   80106d00 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 f6 62 00 00       	call   801070d0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 47 21 00 00       	call   80102f30 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 61 8a 10 80       	push   $0x80108a61
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
80100e16:	68 6d 8a 10 80       	push   $0x80108a6d
80100e1b:	68 60 0f 11 80       	push   $0x80110f60
80100e20:	e8 7b 37 00 00       	call   801045a0 <initlock>
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
80100e34:	bb 94 0f 11 80       	mov    $0x80110f94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 0f 11 80       	push   $0x80110f60
80100e41:	e8 2a 39 00 00       	call   80104770 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 18 11 80    	cmp    $0x801118f4,%ebx
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
80100e6c:	68 60 0f 11 80       	push   $0x80110f60
80100e71:	e8 9a 38 00 00       	call   80104710 <release>
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
80100e85:	68 60 0f 11 80       	push   $0x80110f60
80100e8a:	e8 81 38 00 00       	call   80104710 <release>
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
80100eaa:	68 60 0f 11 80       	push   $0x80110f60
80100eaf:	e8 bc 38 00 00       	call   80104770 <acquire>
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
80100ec7:	68 60 0f 11 80       	push   $0x80110f60
80100ecc:	e8 3f 38 00 00       	call   80104710 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 74 8a 10 80       	push   $0x80108a74
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
80100efc:	68 60 0f 11 80       	push   $0x80110f60
80100f01:	e8 6a 38 00 00       	call   80104770 <acquire>
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
80100f34:	68 60 0f 11 80       	push   $0x80110f60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 cf 37 00 00       	call   80104710 <release>

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
80100f60:	c7 45 08 60 0f 11 80 	movl   $0x80110f60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 9d 37 00 00       	jmp    80104710 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 43 1f 00 00       	call   80102ec0 <begin_op>
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
80100f92:	e9 99 1f 00 00       	jmp    80102f30 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 e2 26 00 00       	call   80103690 <pipeclose>
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
80100fbc:	68 7c 8a 10 80       	push   $0x80108a7c
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
8010108d:	e9 9e 27 00 00       	jmp    80103830 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 86 8a 10 80       	push   $0x80108a86
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
80101109:	e8 22 1e 00 00       	call   80102f30 <end_op>

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
8010112e:	e8 8d 1d 00 00       	call   80102ec0 <begin_op>
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
80101165:	e8 c6 1d 00 00       	call   80102f30 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 97 96 10 80       	push   $0x80109697
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
801011a9:	e9 82 25 00 00       	jmp    80103730 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 9d 96 10 80       	push   $0x8010969d
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
801011c8:	03 05 cc 35 11 80    	add    0x801135cc,%eax
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
8010120d:	e8 8e 1e 00 00       	call   801030a0 <log_write>
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
80101227:	68 8f 8a 10 80       	push   $0x80108a8f
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
80101249:	8b 0d b4 35 11 80    	mov    0x801135b4,%ecx
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
8010126c:	03 05 cc 35 11 80    	add    0x801135cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 35 11 80       	mov    0x801135b4,%eax
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
801012d9:	39 05 b4 35 11 80    	cmp    %eax,0x801135b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 a2 8a 10 80       	push   $0x80108aa2
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
801012fd:	e8 9e 1d 00 00       	call   801030a0 <log_write>
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
80101325:	e8 06 35 00 00       	call   80104830 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 6e 1d 00 00       	call   801030a0 <log_write>
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
8010135a:	bb 94 19 11 80       	mov    $0x80111994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 19 11 80       	push   $0x80111960
8010136a:	e8 01 34 00 00       	call   80104770 <acquire>
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
8010138a:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
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
801013a9:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
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
801013d2:	68 60 19 11 80       	push   $0x80111960
801013d7:	e8 34 33 00 00       	call   80104710 <release>

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
801013fd:	68 60 19 11 80       	push   $0x80111960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 06 33 00 00       	call   80104710 <release>
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
8010141d:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 b8 8a 10 80       	push   $0x80108ab8
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
801014c5:	e8 d6 1b 00 00       	call   801030a0 <log_write>
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
80101515:	68 c8 8a 10 80       	push   $0x80108ac8
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
80101541:	e8 8a 33 00 00       	call   801048d0 <memmove>
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
80101564:	bb a0 19 11 80       	mov    $0x801119a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 db 8a 10 80       	push   $0x80108adb
80101571:	68 60 19 11 80       	push   $0x80111960
80101576:	e8 25 30 00 00       	call   801045a0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 e2 8a 10 80       	push   $0x80108ae2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 dc 2e 00 00       	call   80104470 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 35 11 80    	cmp    $0x801135c0,%ebx
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
801015b7:	68 b4 35 11 80       	push   $0x801135b4
801015bc:	e8 0f 33 00 00       	call   801048d0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 35 11 80    	push   0x801135cc
801015cf:	ff 35 c8 35 11 80    	push   0x801135c8
801015d5:	ff 35 c4 35 11 80    	push   0x801135c4
801015db:	ff 35 c0 35 11 80    	push   0x801135c0
801015e1:	ff 35 bc 35 11 80    	push   0x801135bc
801015e7:	ff 35 b8 35 11 80    	push   0x801135b8
801015ed:	ff 35 b4 35 11 80    	push   0x801135b4
801015f3:	68 48 8b 10 80       	push   $0x80108b48
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
8010161c:	83 3d bc 35 11 80 01 	cmpl   $0x1,0x801135bc
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
8010164f:	3b 3d bc 35 11 80    	cmp    0x801135bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 35 11 80    	add    0x801135c8,%eax
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
8010168e:	e8 9d 31 00 00       	call   80104830 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 fb 19 00 00       	call   801030a0 <log_write>
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
801016c3:	68 e8 8a 10 80       	push   $0x80108ae8
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
801016e4:	03 05 c8 35 11 80    	add    0x801135c8,%eax
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
80101731:	e8 9a 31 00 00       	call   801048d0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 62 19 00 00       	call   801030a0 <log_write>
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
8010175a:	68 60 19 11 80       	push   $0x80111960
8010175f:	e8 0c 30 00 00       	call   80104770 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010176f:	e8 9c 2f 00 00       	call   80104710 <release>
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
801017a2:	e8 09 2d 00 00       	call   801044b0 <acquiresleep>
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
801017c9:	03 05 c8 35 11 80    	add    0x801135c8,%eax
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
80101818:	e8 b3 30 00 00       	call   801048d0 <memmove>
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
8010183d:	68 00 8b 10 80       	push   $0x80108b00
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 fa 8a 10 80       	push   $0x80108afa
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
80101873:	e8 d8 2c 00 00       	call   80104550 <holdingsleep>
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
8010188f:	e9 7c 2c 00 00       	jmp    80104510 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 0f 8b 10 80       	push   $0x80108b0f
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
801018c0:	e8 eb 2b 00 00       	call   801044b0 <acquiresleep>
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
801018da:	e8 31 2c 00 00       	call   80104510 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
801018e6:	e8 85 2e 00 00       	call   80104770 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 19 11 80 	movl   $0x80111960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 0b 2e 00 00       	jmp    80104710 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 19 11 80       	push   $0x80111960
80101910:	e8 5b 2e 00 00       	call   80104770 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010191f:	e8 ec 2d 00 00       	call   80104710 <release>
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
80101a23:	e8 28 2b 00 00       	call   80104550 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 d1 2a 00 00       	call   80104510 <releasesleep>
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
80101a53:	68 0f 8b 10 80       	push   $0x80108b0f
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
80101b37:	e8 94 2d 00 00       	call   801048d0 <memmove>
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
80101b6a:	8b 04 c5 00 19 11 80 	mov    -0x7feee700(,%eax,8),%eax
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
80101c33:	e8 98 2c 00 00       	call   801048d0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 60 14 00 00       	call   801030a0 <log_write>
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
80101c7a:	8b 04 c5 04 19 11 80 	mov    -0x7feee6fc(,%eax,8),%eax
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
80101cce:	e8 6d 2c 00 00       	call   80104940 <strncmp>
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
80101d2d:	e8 0e 2c 00 00       	call   80104940 <strncmp>
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
80101d72:	68 29 8b 10 80       	push   $0x80108b29
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 17 8b 10 80       	push   $0x80108b17
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
80101daa:	e8 31 1d 00 00       	call   80103ae0 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 19 11 80       	push   $0x80111960
80101dba:	e8 b1 29 00 00       	call   80104770 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
80101dca:	e8 41 29 00 00       	call   80104710 <release>
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
80101e27:	e8 a4 2a 00 00       	call   801048d0 <memmove>
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
80101e8c:	e8 bf 26 00 00       	call   80104550 <holdingsleep>
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
80101eae:	e8 5d 26 00 00       	call   80104510 <releasesleep>
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
80101edb:	e8 f0 29 00 00       	call   801048d0 <memmove>
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
80101f2b:	e8 20 26 00 00       	call   80104550 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 c1 25 00 00       	call   80104510 <releasesleep>
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
80101f6d:	e8 de 25 00 00       	call   80104550 <holdingsleep>
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
80101f90:	e8 bb 25 00 00       	call   80104550 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 64 25 00 00       	call   80104510 <releasesleep>
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
80101fcf:	68 0f 8b 10 80       	push   $0x80108b0f
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
8010203d:	e8 4e 29 00 00       	call   80104990 <strncpy>
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
8010207b:	68 38 8b 10 80       	push   $0x80108b38
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 92 91 10 80       	push   $0x80109192
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
8010219b:	68 a4 8b 10 80       	push   $0x80108ba4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 9b 8b 10 80       	push   $0x80108b9b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 b6 8b 10 80       	push   $0x80108bb6
801021cb:	68 00 36 11 80       	push   $0x80113600
801021d0:	e8 cb 23 00 00       	call   801045a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 f7 12 80       	mov    0x8012f784,%eax
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
8010221a:	c7 05 e0 35 11 80 01 	movl   $0x1,0x801135e0
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
80102249:	68 00 36 11 80       	push   $0x80113600
8010224e:	e8 1d 25 00 00       	call   80104770 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 35 11 80    	mov    0x801135e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 35 11 80       	mov    %eax,0x801135e4

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
801022ad:	e8 1e 20 00 00       	call   801042d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 35 11 80       	mov    0x801135e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 36 11 80       	push   $0x80113600
801022cb:	e8 40 24 00 00       	call   80104710 <release>

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
801022ee:	e8 5d 22 00 00       	call   80104550 <holdingsleep>
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
80102313:	a1 e0 35 11 80       	mov    0x801135e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 36 11 80       	push   $0x80113600
80102328:	e8 43 24 00 00       	call   80104770 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 35 11 80       	mov    0x801135e4,%eax
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
8010234e:	39 1d e4 35 11 80    	cmp    %ebx,0x801135e4
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
80102363:	68 00 36 11 80       	push   $0x80113600
80102368:	53                   	push   %ebx
80102369:	e8 a2 1e 00 00       	call   80104210 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 36 11 80 	movl   $0x80113600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 85 23 00 00       	jmp    80104710 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 35 11 80       	mov    $0x801135e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 e5 8b 10 80       	push   $0x80108be5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 d0 8b 10 80       	push   $0x80108bd0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 ba 8b 10 80       	push   $0x80108bba
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
801023d1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 f7 12 80 	movzbl 0x8012f780,%edx
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
8010241a:	68 04 8c 10 80       	push   $0x80108c04
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102444:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
8010245e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102481:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102495:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 36 11 80       	mov    0x80113634,%eax
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
801024c3:	56                   	push   %esi
801024c4:	8b 75 08             	mov    0x8(%ebp),%esi
801024c7:	53                   	push   %ebx
  struct run *r;
  int idx;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024c8:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
801024ce:	0f 85 a6 00 00 00    	jne    8010257a <kfree+0xba>
801024d4:	81 fe d0 b6 13 80    	cmp    $0x8013b6d0,%esi
801024da:	0f 82 9a 00 00 00    	jb     8010257a <kfree+0xba>
801024e0:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
801024e6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801024ec:	0f 87 88 00 00 00    	ja     8010257a <kfree+0xba>
    panic("kfree");

  if(kmem.use_lock)
801024f2:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024f8:	85 d2                	test   %edx,%edx
801024fa:	75 54                	jne    80102550 <kfree+0x90>
  return V2P(v) / PGSIZE;
801024fc:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
  idx = pageindex(v);
  if(kmem.refcnt[idx] < 1)
801024ff:	83 c3 18             	add    $0x18,%ebx
80102502:	0f b7 84 1b 4c 36 11 	movzwl -0x7feec9b4(%ebx,%ebx,1),%eax
80102509:	80 
8010250a:	66 85 c0             	test   %ax,%ax
8010250d:	74 78                	je     80102587 <kfree+0xc7>
    panic("kfree ref");
  kmem.refcnt[idx]--;
8010250f:	83 e8 01             	sub    $0x1,%eax
80102512:	66 89 84 1b 4c 36 11 	mov    %ax,-0x7feec9b4(%ebx,%ebx,1)
80102519:	80 
  if(kmem.refcnt[idx] > 0){
8010251a:	66 85 c0             	test   %ax,%ax
8010251d:	75 20                	jne    8010253f <kfree+0x7f>
      release(&kmem.lock);
    return;
  }

  // Fill with junk to catch dangling refs only when the page is truly free.
  memset(v, 1, PGSIZE);
8010251f:	83 ec 04             	sub    $0x4,%esp
80102522:	68 00 10 00 00       	push   $0x1000
80102527:	6a 01                	push   $0x1
80102529:	56                   	push   %esi
8010252a:	e8 01 23 00 00       	call   80104830 <memset>
  r = (struct run*)v;
  r->next = kmem.freelist;
8010252f:	a1 78 36 11 80       	mov    0x80113678,%eax
  kmem.freelist = r;
  if(kmem.use_lock)
80102534:	83 c4 10             	add    $0x10,%esp
  r->next = kmem.freelist;
80102537:	89 06                	mov    %eax,(%esi)
  kmem.freelist = r;
80102539:	89 35 78 36 11 80    	mov    %esi,0x80113678
  if(kmem.use_lock)
8010253f:	a1 74 36 11 80       	mov    0x80113674,%eax
80102544:	85 c0                	test   %eax,%eax
80102546:	75 20                	jne    80102568 <kfree+0xa8>
    release(&kmem.lock);
}
80102548:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010254b:	5b                   	pop    %ebx
8010254c:	5e                   	pop    %esi
8010254d:	5d                   	pop    %ebp
8010254e:	c3                   	ret    
8010254f:	90                   	nop
    acquire(&kmem.lock);
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 40 36 11 80       	push   $0x80113640
80102558:	e8 13 22 00 00       	call   80104770 <acquire>
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	eb 9a                	jmp    801024fc <kfree+0x3c>
80102562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&kmem.lock);
80102568:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
8010256f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102572:	5b                   	pop    %ebx
80102573:	5e                   	pop    %esi
80102574:	5d                   	pop    %ebp
      release(&kmem.lock);
80102575:	e9 96 21 00 00       	jmp    80104710 <release>
    panic("kfree");
8010257a:	83 ec 0c             	sub    $0xc,%esp
8010257d:	68 36 8c 10 80       	push   $0x80108c36
80102582:	e8 f9 dd ff ff       	call   80100380 <panic>
    panic("kfree ref");
80102587:	83 ec 0c             	sub    $0xc,%esp
8010258a:	68 3c 8c 10 80       	push   $0x80108c3c
8010258f:	e8 ec dd ff ff       	call   80100380 <panic>
80102594:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010259f:	90                   	nop

801025a0 <freerange>:
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025a4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025a7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025aa:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025bd:	39 de                	cmp    %ebx,%esi
801025bf:	72 39                	jb     801025fa <freerange+0x5a>
801025c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return V2P(v) / PGSIZE;
801025c8:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kmem.refcnt[pageindex(p)] = 1;
801025ce:	ba 01 00 00 00       	mov    $0x1,%edx
    kfree(p);
801025d3:	83 ec 0c             	sub    $0xc,%esp
  return V2P(v) / PGSIZE;
801025d6:	c1 e8 0c             	shr    $0xc,%eax
    kmem.refcnt[pageindex(p)] = 1;
801025d9:	66 89 94 00 7c 36 11 	mov    %dx,-0x7feec984(%eax,%eax,1)
801025e0:	80 
    kfree(p);
801025e1:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025ed:	50                   	push   %eax
801025ee:	e8 cd fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801025f3:	83 c4 10             	add    $0x10,%esp
801025f6:	39 f3                	cmp    %esi,%ebx
801025f8:	76 ce                	jbe    801025c8 <freerange+0x28>
}
801025fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025fd:	5b                   	pop    %ebx
801025fe:	5e                   	pop    %esi
801025ff:	5d                   	pop    %ebp
80102600:	c3                   	ret    
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260f:	90                   	nop

80102610 <kinit2>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102614:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102617:	8b 75 0c             	mov    0xc(%ebp),%esi
8010261a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 39                	jb     8010266a <kinit2+0x5a>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return V2P(v) / PGSIZE;
80102638:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kmem.refcnt[pageindex(p)] = 1;
8010263e:	ba 01 00 00 00       	mov    $0x1,%edx
    kfree(p);
80102643:	83 ec 0c             	sub    $0xc,%esp
  return V2P(v) / PGSIZE;
80102646:	c1 e8 0c             	shr    $0xc,%eax
    kmem.refcnt[pageindex(p)] = 1;
80102649:	66 89 94 00 7c 36 11 	mov    %dx,-0x7feec984(%eax,%eax,1)
80102650:	80 
    kfree(p);
80102651:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102657:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265d:	50                   	push   %eax
8010265e:	e8 5d fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102663:	83 c4 10             	add    $0x10,%esp
80102666:	39 de                	cmp    %ebx,%esi
80102668:	73 ce                	jae    80102638 <kinit2+0x28>
  kmem.use_lock = 1;
8010266a:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
80102671:	00 00 00 
}
80102674:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102677:	5b                   	pop    %ebx
80102678:	5e                   	pop    %esi
80102679:	5d                   	pop    %ebp
8010267a:	c3                   	ret    
8010267b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010267f:	90                   	nop

80102680 <kinit1>:
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx
80102685:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102688:	83 ec 08             	sub    $0x8,%esp
8010268b:	68 46 8c 10 80       	push   $0x80108c46
80102690:	68 40 36 11 80       	push   $0x80113640
80102695:	e8 06 1f 00 00       	call   801045a0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010269a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010269d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026a0:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801026a7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026aa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026bc:	39 de                	cmp    %ebx,%esi
801026be:	72 32                	jb     801026f2 <kinit1+0x72>
  return V2P(v) / PGSIZE;
801026c0:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
    kmem.refcnt[pageindex(p)] = 1;
801026c6:	ba 01 00 00 00       	mov    $0x1,%edx
    kfree(p);
801026cb:	83 ec 0c             	sub    $0xc,%esp
  return V2P(v) / PGSIZE;
801026ce:	c1 e8 0c             	shr    $0xc,%eax
    kmem.refcnt[pageindex(p)] = 1;
801026d1:	66 89 94 00 7c 36 11 	mov    %dx,-0x7feec984(%eax,%eax,1)
801026d8:	80 
    kfree(p);
801026d9:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026e5:	50                   	push   %eax
801026e6:	e8 d5 fd ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801026eb:	83 c4 10             	add    $0x10,%esp
801026ee:	39 de                	cmp    %ebx,%esi
801026f0:	73 ce                	jae    801026c0 <kinit1+0x40>
}
801026f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026f5:	5b                   	pop    %ebx
801026f6:	5e                   	pop    %esi
801026f7:	5d                   	pop    %ebp
801026f8:	c3                   	ret    
801026f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102700 <kaddref>:

void
kaddref(char *v)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	53                   	push   %ebx
80102704:	83 ec 04             	sub    $0x4,%esp
80102707:	8b 45 08             	mov    0x8(%ebp),%eax
  int idx;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010270a:	a9 ff 0f 00 00       	test   $0xfff,%eax
8010270f:	75 77                	jne    80102788 <kaddref+0x88>
80102711:	3d d0 b6 13 80       	cmp    $0x8013b6d0,%eax
80102716:	72 70                	jb     80102788 <kaddref+0x88>
80102718:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010271e:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102724:	77 62                	ja     80102788 <kaddref+0x88>
    panic("kaddref");

  if(kmem.use_lock)
80102726:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010272c:	85 d2                	test   %edx,%edx
8010272e:	75 30                	jne    80102760 <kaddref+0x60>
  return V2P(v) / PGSIZE;
80102730:	89 d8                	mov    %ebx,%eax
80102732:	c1 e8 0c             	shr    $0xc,%eax
    acquire(&kmem.lock);
  idx = pageindex(v);
  if(kmem.refcnt[idx] < 1)
80102735:	83 c0 18             	add    $0x18,%eax
80102738:	0f b7 94 00 4c 36 11 	movzwl -0x7feec9b4(%eax,%eax,1),%edx
8010273f:	80 
80102740:	66 85 d2             	test   %dx,%dx
80102743:	74 50                	je     80102795 <kaddref+0x95>
    panic("kaddref ref");
  kmem.refcnt[idx]++;
80102745:	83 c2 01             	add    $0x1,%edx
80102748:	66 89 94 00 4c 36 11 	mov    %dx,-0x7feec9b4(%eax,%eax,1)
8010274f:	80 
  if(kmem.use_lock)
80102750:	a1 74 36 11 80       	mov    0x80113674,%eax
80102755:	85 c0                	test   %eax,%eax
80102757:	75 1f                	jne    80102778 <kaddref+0x78>
    release(&kmem.lock);
}
80102759:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010275c:	c9                   	leave  
8010275d:	c3                   	ret    
8010275e:	66 90                	xchg   %ax,%ax
    acquire(&kmem.lock);
80102760:	83 ec 0c             	sub    $0xc,%esp
80102763:	68 40 36 11 80       	push   $0x80113640
80102768:	e8 03 20 00 00       	call   80104770 <acquire>
8010276d:	83 c4 10             	add    $0x10,%esp
80102770:	eb be                	jmp    80102730 <kaddref+0x30>
80102772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102778:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
8010277f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102782:	c9                   	leave  
    release(&kmem.lock);
80102783:	e9 88 1f 00 00       	jmp    80104710 <release>
    panic("kaddref");
80102788:	83 ec 0c             	sub    $0xc,%esp
8010278b:	68 4b 8c 10 80       	push   $0x80108c4b
80102790:	e8 eb db ff ff       	call   80100380 <panic>
    panic("kaddref ref");
80102795:	83 ec 0c             	sub    $0xc,%esp
80102798:	68 53 8c 10 80       	push   $0x80108c53
8010279d:	e8 de db ff ff       	call   80100380 <panic>
801027a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801027b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  int idx;

  if(kmem.use_lock)
801027b6:	8b 0d 74 36 11 80    	mov    0x80113674,%ecx
801027bc:	85 c9                	test   %ecx,%ecx
801027be:	75 60                	jne    80102820 <kalloc+0x70>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027c0:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801027c5:	85 c0                	test   %eax,%eax
801027c7:	74 36                	je     801027ff <kalloc+0x4f>
    kmem.freelist = r->next;
801027c9:	8b 10                	mov    (%eax),%edx
801027cb:	89 15 78 36 11 80    	mov    %edx,0x80113678
  return V2P(v) / PGSIZE;
801027d1:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801027d7:	c1 ea 0c             	shr    $0xc,%edx
  if(r){
    idx = pageindex((char*)r);
    if(kmem.refcnt[idx] != 0)
801027da:	66 83 bc 12 7c 36 11 	cmpw   $0x0,-0x7feec984(%edx,%edx,1)
801027e1:	80 00 
801027e3:	8d 4a 18             	lea    0x18(%edx),%ecx
801027e6:	75 53                	jne    8010283b <kalloc+0x8b>
      panic("kalloc ref");
    kmem.refcnt[idx] = 1;
801027e8:	ba 01 00 00 00       	mov    $0x1,%edx
801027ed:	66 89 94 09 4c 36 11 	mov    %dx,-0x7feec9b4(%ecx,%ecx,1)
801027f4:	80 
  }
  if(kmem.use_lock)
801027f5:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801027fb:	85 d2                	test   %edx,%edx
801027fd:	75 09                	jne    80102808 <kalloc+0x58>
    release(&kmem.lock);
  return (char*)r;
}
801027ff:	c9                   	leave  
80102800:	c3                   	ret    
80102801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80102808:	83 ec 0c             	sub    $0xc,%esp
8010280b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010280e:	68 40 36 11 80       	push   $0x80113640
80102813:	e8 f8 1e 00 00       	call   80104710 <release>
  return (char*)r;
80102818:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
8010281b:	83 c4 10             	add    $0x10,%esp
}
8010281e:	c9                   	leave  
8010281f:	c3                   	ret    
    acquire(&kmem.lock);
80102820:	83 ec 0c             	sub    $0xc,%esp
80102823:	68 40 36 11 80       	push   $0x80113640
80102828:	e8 43 1f 00 00       	call   80104770 <acquire>
  r = kmem.freelist;
8010282d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102832:	83 c4 10             	add    $0x10,%esp
80102835:	85 c0                	test   %eax,%eax
80102837:	75 90                	jne    801027c9 <kalloc+0x19>
80102839:	eb ba                	jmp    801027f5 <kalloc+0x45>
      panic("kalloc ref");
8010283b:	83 ec 0c             	sub    $0xc,%esp
8010283e:	68 5f 8c 10 80       	push   $0x80108c5f
80102843:	e8 38 db ff ff       	call   80100380 <panic>
80102848:	66 90                	xchg   %ax,%ax
8010284a:	66 90                	xchg   %ax,%ax
8010284c:	66 90                	xchg   %ax,%ax
8010284e:	66 90                	xchg   %ax,%ax

80102850 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	ba 64 00 00 00       	mov    $0x64,%edx
80102855:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102856:	a8 01                	test   $0x1,%al
80102858:	0f 84 c2 00 00 00    	je     80102920 <kbdgetc+0xd0>
{
8010285e:	55                   	push   %ebp
8010285f:	ba 60 00 00 00       	mov    $0x60,%edx
80102864:	89 e5                	mov    %esp,%ebp
80102866:	53                   	push   %ebx
80102867:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102868:	8b 1d 7c f6 12 80    	mov    0x8012f67c,%ebx
  data = inb(KBDATAP);
8010286e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102871:	3c e0                	cmp    $0xe0,%al
80102873:	74 5b                	je     801028d0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102875:	89 da                	mov    %ebx,%edx
80102877:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010287a:	84 c0                	test   %al,%al
8010287c:	78 62                	js     801028e0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010287e:	85 d2                	test   %edx,%edx
80102880:	74 09                	je     8010288b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102882:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102885:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102888:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010288b:	0f b6 91 a0 8d 10 80 	movzbl -0x7fef7260(%ecx),%edx
  shift ^= togglecode[data];
80102892:	0f b6 81 a0 8c 10 80 	movzbl -0x7fef7360(%ecx),%eax
  shift |= shiftcode[data];
80102899:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010289b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010289d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010289f:	89 15 7c f6 12 80    	mov    %edx,0x8012f67c
  c = charcode[shift & (CTL | SHIFT)][data];
801028a5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028a8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801028ab:	8b 04 85 80 8c 10 80 	mov    -0x7fef7380(,%eax,4),%eax
801028b2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801028b6:	74 0b                	je     801028c3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801028b8:	8d 50 9f             	lea    -0x61(%eax),%edx
801028bb:	83 fa 19             	cmp    $0x19,%edx
801028be:	77 48                	ja     80102908 <kbdgetc+0xb8>
      c += 'A' - 'a';
801028c0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c6:	c9                   	leave  
801028c7:	c3                   	ret    
801028c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop
    shift |= E0ESC;
801028d0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801028d3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801028d5:	89 1d 7c f6 12 80    	mov    %ebx,0x8012f67c
}
801028db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028de:	c9                   	leave  
801028df:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801028e0:	83 e0 7f             	and    $0x7f,%eax
801028e3:	85 d2                	test   %edx,%edx
801028e5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801028e8:	0f b6 81 a0 8d 10 80 	movzbl -0x7fef7260(%ecx),%eax
801028ef:	83 c8 40             	or     $0x40,%eax
801028f2:	0f b6 c0             	movzbl %al,%eax
801028f5:	f7 d0                	not    %eax
801028f7:	21 d8                	and    %ebx,%eax
}
801028f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801028fc:	a3 7c f6 12 80       	mov    %eax,0x8012f67c
    return 0;
80102901:	31 c0                	xor    %eax,%eax
}
80102903:	c9                   	leave  
80102904:	c3                   	ret    
80102905:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102908:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010290b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010290e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102911:	c9                   	leave  
      c += 'a' - 'A';
80102912:	83 f9 1a             	cmp    $0x1a,%ecx
80102915:	0f 42 c2             	cmovb  %edx,%eax
}
80102918:	c3                   	ret    
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102925:	c3                   	ret    
80102926:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292d:	8d 76 00             	lea    0x0(%esi),%esi

80102930 <kbdintr>:

void
kbdintr(void)
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
80102933:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102936:	68 50 28 10 80       	push   $0x80102850
8010293b:	e8 40 df ff ff       	call   80100880 <consoleintr>
}
80102940:	83 c4 10             	add    $0x10,%esp
80102943:	c9                   	leave  
80102944:	c3                   	ret    
80102945:	66 90                	xchg   %ax,%ax
80102947:	66 90                	xchg   %ax,%ax
80102949:	66 90                	xchg   %ax,%ax
8010294b:	66 90                	xchg   %ax,%ax
8010294d:	66 90                	xchg   %ax,%ax
8010294f:	90                   	nop

80102950 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102950:	a1 80 f6 12 80       	mov    0x8012f680,%eax
80102955:	85 c0                	test   %eax,%eax
80102957:	0f 84 cb 00 00 00    	je     80102a28 <lapicinit+0xd8>
  lapic[index] = value;
8010295d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102964:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010296a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102971:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102974:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102977:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010297e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102981:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102984:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010298b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010298e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102991:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102998:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010299b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029a5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029ab:	8b 50 30             	mov    0x30(%eax),%edx
801029ae:	c1 ea 10             	shr    $0x10,%edx
801029b1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801029b7:	75 77                	jne    80102a30 <lapicinit+0xe0>
  lapic[index] = value;
801029b9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801029c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029cd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029da:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029dd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029e7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029fa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a01:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a04:	8b 50 20             	mov    0x20(%eax),%edx
80102a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a10:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a16:	80 e6 10             	and    $0x10,%dh
80102a19:	75 f5                	jne    80102a10 <lapicinit+0xc0>
  lapic[index] = value;
80102a1b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a22:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a25:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a28:	c3                   	ret    
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a30:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a37:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a3d:	e9 77 ff ff ff       	jmp    801029b9 <lapicinit+0x69>
80102a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a50 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a50:	a1 80 f6 12 80       	mov    0x8012f680,%eax
80102a55:	85 c0                	test   %eax,%eax
80102a57:	74 07                	je     80102a60 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a59:	8b 40 20             	mov    0x20(%eax),%eax
80102a5c:	c1 e8 18             	shr    $0x18,%eax
80102a5f:	c3                   	ret    
    return 0;
80102a60:	31 c0                	xor    %eax,%eax
}
80102a62:	c3                   	ret    
80102a63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a70 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a70:	a1 80 f6 12 80       	mov    0x8012f680,%eax
80102a75:	85 c0                	test   %eax,%eax
80102a77:	74 0d                	je     80102a86 <lapiceoi+0x16>
  lapic[index] = value;
80102a79:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a80:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a83:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a86:	c3                   	ret    
80102a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8e:	66 90                	xchg   %ax,%ax

80102a90 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a90:	c3                   	ret    
80102a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a9f:	90                   	nop

80102aa0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102aa0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102aa6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aab:	89 e5                	mov    %esp,%ebp
80102aad:	53                   	push   %ebx
80102aae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ab1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ab4:	ee                   	out    %al,(%dx)
80102ab5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aba:	ba 71 00 00 00       	mov    $0x71,%edx
80102abf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ac0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ac2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ac5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102acb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102acd:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102ad0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102ad2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ad5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102ad8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102ade:	a1 80 f6 12 80       	mov    0x8012f680,%eax
80102ae3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ae9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102af3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102af9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b00:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b03:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b06:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b0c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b0f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b15:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b18:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b21:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b27:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b2d:	c9                   	leave  
80102b2e:	c3                   	ret    
80102b2f:	90                   	nop

80102b30 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102b30:	55                   	push   %ebp
80102b31:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b36:	ba 70 00 00 00       	mov    $0x70,%edx
80102b3b:	89 e5                	mov    %esp,%ebp
80102b3d:	57                   	push   %edi
80102b3e:	56                   	push   %esi
80102b3f:	53                   	push   %ebx
80102b40:	83 ec 4c             	sub    $0x4c,%esp
80102b43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b44:	ba 71 00 00 00       	mov    $0x71,%edx
80102b49:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b4a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b52:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b55:	8d 76 00             	lea    0x0(%esi),%esi
80102b58:	31 c0                	xor    %eax,%eax
80102b5a:	89 da                	mov    %ebx,%edx
80102b5c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b62:	89 ca                	mov    %ecx,%edx
80102b64:	ec                   	in     (%dx),%al
80102b65:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b68:	89 da                	mov    %ebx,%edx
80102b6a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b70:	89 ca                	mov    %ecx,%edx
80102b72:	ec                   	in     (%dx),%al
80102b73:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b76:	89 da                	mov    %ebx,%edx
80102b78:	b8 04 00 00 00       	mov    $0x4,%eax
80102b7d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7e:	89 ca                	mov    %ecx,%edx
80102b80:	ec                   	in     (%dx),%al
80102b81:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b84:	89 da                	mov    %ebx,%edx
80102b86:	b8 07 00 00 00       	mov    $0x7,%eax
80102b8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8c:	89 ca                	mov    %ecx,%edx
80102b8e:	ec                   	in     (%dx),%al
80102b8f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b92:	89 da                	mov    %ebx,%edx
80102b94:	b8 08 00 00 00       	mov    $0x8,%eax
80102b99:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9a:	89 ca                	mov    %ecx,%edx
80102b9c:	ec                   	in     (%dx),%al
80102b9d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b9f:	89 da                	mov    %ebx,%edx
80102ba1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ba6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba7:	89 ca                	mov    %ecx,%edx
80102ba9:	ec                   	in     (%dx),%al
80102baa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bac:	89 da                	mov    %ebx,%edx
80102bae:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bb3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb4:	89 ca                	mov    %ecx,%edx
80102bb6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102bb7:	84 c0                	test   %al,%al
80102bb9:	78 9d                	js     80102b58 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102bbb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102bbf:	89 fa                	mov    %edi,%edx
80102bc1:	0f b6 fa             	movzbl %dl,%edi
80102bc4:	89 f2                	mov    %esi,%edx
80102bc6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102bc9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102bcd:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd0:	89 da                	mov    %ebx,%edx
80102bd2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102bd5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102bd8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bdc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102bdf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102be2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102be6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102be9:	31 c0                	xor    %eax,%eax
80102beb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bec:	89 ca                	mov    %ecx,%edx
80102bee:	ec                   	in     (%dx),%al
80102bef:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf2:	89 da                	mov    %ebx,%edx
80102bf4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102bf7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bfc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfd:	89 ca                	mov    %ecx,%edx
80102bff:	ec                   	in     (%dx),%al
80102c00:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c03:	89 da                	mov    %ebx,%edx
80102c05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c08:	b8 04 00 00 00       	mov    $0x4,%eax
80102c0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0e:	89 ca                	mov    %ecx,%edx
80102c10:	ec                   	in     (%dx),%al
80102c11:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c14:	89 da                	mov    %ebx,%edx
80102c16:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c19:	b8 07 00 00 00       	mov    $0x7,%eax
80102c1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1f:	89 ca                	mov    %ecx,%edx
80102c21:	ec                   	in     (%dx),%al
80102c22:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c25:	89 da                	mov    %ebx,%edx
80102c27:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c2a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c2f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c30:	89 ca                	mov    %ecx,%edx
80102c32:	ec                   	in     (%dx),%al
80102c33:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c36:	89 da                	mov    %ebx,%edx
80102c38:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c3b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c40:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c41:	89 ca                	mov    %ecx,%edx
80102c43:	ec                   	in     (%dx),%al
80102c44:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c47:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c4d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c50:	6a 18                	push   $0x18
80102c52:	50                   	push   %eax
80102c53:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c56:	50                   	push   %eax
80102c57:	e8 24 1c 00 00       	call   80104880 <memcmp>
80102c5c:	83 c4 10             	add    $0x10,%esp
80102c5f:	85 c0                	test   %eax,%eax
80102c61:	0f 85 f1 fe ff ff    	jne    80102b58 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c67:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c6b:	75 78                	jne    80102ce5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c70:	89 c2                	mov    %eax,%edx
80102c72:	83 e0 0f             	and    $0xf,%eax
80102c75:	c1 ea 04             	shr    $0x4,%edx
80102c78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c81:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c84:	89 c2                	mov    %eax,%edx
80102c86:	83 e0 0f             	and    $0xf,%eax
80102c89:	c1 ea 04             	shr    $0x4,%edx
80102c8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c92:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c95:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c98:	89 c2                	mov    %eax,%edx
80102c9a:	83 e0 0f             	and    $0xf,%eax
80102c9d:	c1 ea 04             	shr    $0x4,%edx
80102ca0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ca3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ca6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ca9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cac:	89 c2                	mov    %eax,%edx
80102cae:	83 e0 0f             	and    $0xf,%eax
80102cb1:	c1 ea 04             	shr    $0x4,%edx
80102cb4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cb7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cbd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cc0:	89 c2                	mov    %eax,%edx
80102cc2:	83 e0 0f             	and    $0xf,%eax
80102cc5:	c1 ea 04             	shr    $0x4,%edx
80102cc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ccb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102cd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cd4:	89 c2                	mov    %eax,%edx
80102cd6:	83 e0 0f             	and    $0xf,%eax
80102cd9:	c1 ea 04             	shr    $0x4,%edx
80102cdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ce5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ce8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ceb:	89 06                	mov    %eax,(%esi)
80102ced:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cf0:	89 46 04             	mov    %eax,0x4(%esi)
80102cf3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cf6:	89 46 08             	mov    %eax,0x8(%esi)
80102cf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cfc:	89 46 0c             	mov    %eax,0xc(%esi)
80102cff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d02:	89 46 10             	mov    %eax,0x10(%esi)
80102d05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d08:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d0b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d15:	5b                   	pop    %ebx
80102d16:	5e                   	pop    %esi
80102d17:	5f                   	pop    %edi
80102d18:	5d                   	pop    %ebp
80102d19:	c3                   	ret    
80102d1a:	66 90                	xchg   %ax,%ax
80102d1c:	66 90                	xchg   %ax,%ax
80102d1e:	66 90                	xchg   %ax,%ax

80102d20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d20:	8b 0d e8 f6 12 80    	mov    0x8012f6e8,%ecx
80102d26:	85 c9                	test   %ecx,%ecx
80102d28:	0f 8e 8a 00 00 00    	jle    80102db8 <install_trans+0x98>
{
80102d2e:	55                   	push   %ebp
80102d2f:	89 e5                	mov    %esp,%ebp
80102d31:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d32:	31 ff                	xor    %edi,%edi
{
80102d34:	56                   	push   %esi
80102d35:	53                   	push   %ebx
80102d36:	83 ec 0c             	sub    $0xc,%esp
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d40:	a1 d4 f6 12 80       	mov    0x8012f6d4,%eax
80102d45:	83 ec 08             	sub    $0x8,%esp
80102d48:	01 f8                	add    %edi,%eax
80102d4a:	83 c0 01             	add    $0x1,%eax
80102d4d:	50                   	push   %eax
80102d4e:	ff 35 e4 f6 12 80    	push   0x8012f6e4
80102d54:	e8 77 d3 ff ff       	call   801000d0 <bread>
80102d59:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d5b:	58                   	pop    %eax
80102d5c:	5a                   	pop    %edx
80102d5d:	ff 34 bd ec f6 12 80 	push   -0x7fed0914(,%edi,4)
80102d64:	ff 35 e4 f6 12 80    	push   0x8012f6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d6a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d6d:	e8 5e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d72:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d75:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d77:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d7a:	68 00 02 00 00       	push   $0x200
80102d7f:	50                   	push   %eax
80102d80:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d83:	50                   	push   %eax
80102d84:	e8 47 1b 00 00       	call   801048d0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d89:	89 1c 24             	mov    %ebx,(%esp)
80102d8c:	e8 1f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d91:	89 34 24             	mov    %esi,(%esp)
80102d94:	e8 57 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d99:	89 1c 24             	mov    %ebx,(%esp)
80102d9c:	e8 4f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	39 3d e8 f6 12 80    	cmp    %edi,0x8012f6e8
80102daa:	7f 94                	jg     80102d40 <install_trans+0x20>
  }
}
80102dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102daf:	5b                   	pop    %ebx
80102db0:	5e                   	pop    %esi
80102db1:	5f                   	pop    %edi
80102db2:	5d                   	pop    %ebp
80102db3:	c3                   	ret    
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102db8:	c3                   	ret    
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102dc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	53                   	push   %ebx
80102dc4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102dc7:	ff 35 d4 f6 12 80    	push   0x8012f6d4
80102dcd:	ff 35 e4 f6 12 80    	push   0x8012f6e4
80102dd3:	e8 f8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102dd8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ddb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ddd:	a1 e8 f6 12 80       	mov    0x8012f6e8,%eax
80102de2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102de5:	85 c0                	test   %eax,%eax
80102de7:	7e 19                	jle    80102e02 <write_head+0x42>
80102de9:	31 d2                	xor    %edx,%edx
80102deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102def:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102df0:	8b 0c 95 ec f6 12 80 	mov    -0x7fed0914(,%edx,4),%ecx
80102df7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dfb:	83 c2 01             	add    $0x1,%edx
80102dfe:	39 d0                	cmp    %edx,%eax
80102e00:	75 ee                	jne    80102df0 <write_head+0x30>
  }
  bwrite(buf);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	53                   	push   %ebx
80102e06:	e8 a5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e0b:	89 1c 24             	mov    %ebx,(%esp)
80102e0e:	e8 dd d3 ff ff       	call   801001f0 <brelse>
}
80102e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e16:	83 c4 10             	add    $0x10,%esp
80102e19:	c9                   	leave  
80102e1a:	c3                   	ret    
80102e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e1f:	90                   	nop

80102e20 <initlog>:
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
80102e24:	83 ec 2c             	sub    $0x2c,%esp
80102e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e2a:	68 a0 8e 10 80       	push   $0x80108ea0
80102e2f:	68 a0 f6 12 80       	push   $0x8012f6a0
80102e34:	e8 67 17 00 00       	call   801045a0 <initlock>
  readsb(dev, &sb);
80102e39:	58                   	pop    %eax
80102e3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e3d:	5a                   	pop    %edx
80102e3e:	50                   	push   %eax
80102e3f:	53                   	push   %ebx
80102e40:	e8 db e6 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102e45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e48:	59                   	pop    %ecx
  log.dev = dev;
80102e49:	89 1d e4 f6 12 80    	mov    %ebx,0x8012f6e4
  log.size = sb.nlog;
80102e4f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e52:	a3 d4 f6 12 80       	mov    %eax,0x8012f6d4
  log.size = sb.nlog;
80102e57:	89 15 d8 f6 12 80    	mov    %edx,0x8012f6d8
  struct buf *buf = bread(log.dev, log.start);
80102e5d:	5a                   	pop    %edx
80102e5e:	50                   	push   %eax
80102e5f:	53                   	push   %ebx
80102e60:	e8 6b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e65:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e68:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102e6b:	89 1d e8 f6 12 80    	mov    %ebx,0x8012f6e8
  for (i = 0; i < log.lh.n; i++) {
80102e71:	85 db                	test   %ebx,%ebx
80102e73:	7e 1d                	jle    80102e92 <initlog+0x72>
80102e75:	31 d2                	xor    %edx,%edx
80102e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102e80:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e84:	89 0c 95 ec f6 12 80 	mov    %ecx,-0x7fed0914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e8b:	83 c2 01             	add    $0x1,%edx
80102e8e:	39 d3                	cmp    %edx,%ebx
80102e90:	75 ee                	jne    80102e80 <initlog+0x60>
  brelse(buf);
80102e92:	83 ec 0c             	sub    $0xc,%esp
80102e95:	50                   	push   %eax
80102e96:	e8 55 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e9b:	e8 80 fe ff ff       	call   80102d20 <install_trans>
  log.lh.n = 0;
80102ea0:	c7 05 e8 f6 12 80 00 	movl   $0x0,0x8012f6e8
80102ea7:	00 00 00 
  write_head(); // clear the log
80102eaa:	e8 11 ff ff ff       	call   80102dc0 <write_head>
}
80102eaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eb2:	83 c4 10             	add    $0x10,%esp
80102eb5:	c9                   	leave  
80102eb6:	c3                   	ret    
80102eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ebe:	66 90                	xchg   %ax,%ax

80102ec0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ec6:	68 a0 f6 12 80       	push   $0x8012f6a0
80102ecb:	e8 a0 18 00 00       	call   80104770 <acquire>
80102ed0:	83 c4 10             	add    $0x10,%esp
80102ed3:	eb 18                	jmp    80102eed <begin_op+0x2d>
80102ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ed8:	83 ec 08             	sub    $0x8,%esp
80102edb:	68 a0 f6 12 80       	push   $0x8012f6a0
80102ee0:	68 a0 f6 12 80       	push   $0x8012f6a0
80102ee5:	e8 26 13 00 00       	call   80104210 <sleep>
80102eea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102eed:	a1 e0 f6 12 80       	mov    0x8012f6e0,%eax
80102ef2:	85 c0                	test   %eax,%eax
80102ef4:	75 e2                	jne    80102ed8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ef6:	a1 dc f6 12 80       	mov    0x8012f6dc,%eax
80102efb:	8b 15 e8 f6 12 80    	mov    0x8012f6e8,%edx
80102f01:	83 c0 01             	add    $0x1,%eax
80102f04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f0a:	83 fa 1e             	cmp    $0x1e,%edx
80102f0d:	7f c9                	jg     80102ed8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f0f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f12:	a3 dc f6 12 80       	mov    %eax,0x8012f6dc
      release(&log.lock);
80102f17:	68 a0 f6 12 80       	push   $0x8012f6a0
80102f1c:	e8 ef 17 00 00       	call   80104710 <release>
      break;
    }
  }
}
80102f21:	83 c4 10             	add    $0x10,%esp
80102f24:	c9                   	leave  
80102f25:	c3                   	ret    
80102f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f2d:	8d 76 00             	lea    0x0(%esi),%esi

80102f30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	57                   	push   %edi
80102f34:	56                   	push   %esi
80102f35:	53                   	push   %ebx
80102f36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f39:	68 a0 f6 12 80       	push   $0x8012f6a0
80102f3e:	e8 2d 18 00 00       	call   80104770 <acquire>
  log.outstanding -= 1;
80102f43:	a1 dc f6 12 80       	mov    0x8012f6dc,%eax
  if(log.committing)
80102f48:	8b 35 e0 f6 12 80    	mov    0x8012f6e0,%esi
80102f4e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f51:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f54:	89 1d dc f6 12 80    	mov    %ebx,0x8012f6dc
  if(log.committing)
80102f5a:	85 f6                	test   %esi,%esi
80102f5c:	0f 85 22 01 00 00    	jne    80103084 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f62:	85 db                	test   %ebx,%ebx
80102f64:	0f 85 f6 00 00 00    	jne    80103060 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f6a:	c7 05 e0 f6 12 80 01 	movl   $0x1,0x8012f6e0
80102f71:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f74:	83 ec 0c             	sub    $0xc,%esp
80102f77:	68 a0 f6 12 80       	push   $0x8012f6a0
80102f7c:	e8 8f 17 00 00       	call   80104710 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f81:	8b 0d e8 f6 12 80    	mov    0x8012f6e8,%ecx
80102f87:	83 c4 10             	add    $0x10,%esp
80102f8a:	85 c9                	test   %ecx,%ecx
80102f8c:	7f 42                	jg     80102fd0 <end_op+0xa0>
    acquire(&log.lock);
80102f8e:	83 ec 0c             	sub    $0xc,%esp
80102f91:	68 a0 f6 12 80       	push   $0x8012f6a0
80102f96:	e8 d5 17 00 00       	call   80104770 <acquire>
    wakeup(&log);
80102f9b:	c7 04 24 a0 f6 12 80 	movl   $0x8012f6a0,(%esp)
    log.committing = 0;
80102fa2:	c7 05 e0 f6 12 80 00 	movl   $0x0,0x8012f6e0
80102fa9:	00 00 00 
    wakeup(&log);
80102fac:	e8 1f 13 00 00       	call   801042d0 <wakeup>
    release(&log.lock);
80102fb1:	c7 04 24 a0 f6 12 80 	movl   $0x8012f6a0,(%esp)
80102fb8:	e8 53 17 00 00       	call   80104710 <release>
80102fbd:	83 c4 10             	add    $0x10,%esp
}
80102fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fc3:	5b                   	pop    %ebx
80102fc4:	5e                   	pop    %esi
80102fc5:	5f                   	pop    %edi
80102fc6:	5d                   	pop    %ebp
80102fc7:	c3                   	ret    
80102fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fd0:	a1 d4 f6 12 80       	mov    0x8012f6d4,%eax
80102fd5:	83 ec 08             	sub    $0x8,%esp
80102fd8:	01 d8                	add    %ebx,%eax
80102fda:	83 c0 01             	add    $0x1,%eax
80102fdd:	50                   	push   %eax
80102fde:	ff 35 e4 f6 12 80    	push   0x8012f6e4
80102fe4:	e8 e7 d0 ff ff       	call   801000d0 <bread>
80102fe9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102feb:	58                   	pop    %eax
80102fec:	5a                   	pop    %edx
80102fed:	ff 34 9d ec f6 12 80 	push   -0x7fed0914(,%ebx,4)
80102ff4:	ff 35 e4 f6 12 80    	push   0x8012f6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102ffa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ffd:	e8 ce d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103002:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103005:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103007:	8d 40 5c             	lea    0x5c(%eax),%eax
8010300a:	68 00 02 00 00       	push   $0x200
8010300f:	50                   	push   %eax
80103010:	8d 46 5c             	lea    0x5c(%esi),%eax
80103013:	50                   	push   %eax
80103014:	e8 b7 18 00 00       	call   801048d0 <memmove>
    bwrite(to);  // write the log
80103019:	89 34 24             	mov    %esi,(%esp)
8010301c:	e8 8f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103021:	89 3c 24             	mov    %edi,(%esp)
80103024:	e8 c7 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103029:	89 34 24             	mov    %esi,(%esp)
8010302c:	e8 bf d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103031:	83 c4 10             	add    $0x10,%esp
80103034:	3b 1d e8 f6 12 80    	cmp    0x8012f6e8,%ebx
8010303a:	7c 94                	jl     80102fd0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010303c:	e8 7f fd ff ff       	call   80102dc0 <write_head>
    install_trans(); // Now install writes to home locations
80103041:	e8 da fc ff ff       	call   80102d20 <install_trans>
    log.lh.n = 0;
80103046:	c7 05 e8 f6 12 80 00 	movl   $0x0,0x8012f6e8
8010304d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103050:	e8 6b fd ff ff       	call   80102dc0 <write_head>
80103055:	e9 34 ff ff ff       	jmp    80102f8e <end_op+0x5e>
8010305a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103060:	83 ec 0c             	sub    $0xc,%esp
80103063:	68 a0 f6 12 80       	push   $0x8012f6a0
80103068:	e8 63 12 00 00       	call   801042d0 <wakeup>
  release(&log.lock);
8010306d:	c7 04 24 a0 f6 12 80 	movl   $0x8012f6a0,(%esp)
80103074:	e8 97 16 00 00       	call   80104710 <release>
80103079:	83 c4 10             	add    $0x10,%esp
}
8010307c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010307f:	5b                   	pop    %ebx
80103080:	5e                   	pop    %esi
80103081:	5f                   	pop    %edi
80103082:	5d                   	pop    %ebp
80103083:	c3                   	ret    
    panic("log.committing");
80103084:	83 ec 0c             	sub    $0xc,%esp
80103087:	68 a4 8e 10 80       	push   $0x80108ea4
8010308c:	e8 ef d2 ff ff       	call   80100380 <panic>
80103091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103098:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010309f:	90                   	nop

801030a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	53                   	push   %ebx
801030a4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030a7:	8b 15 e8 f6 12 80    	mov    0x8012f6e8,%edx
{
801030ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030b0:	83 fa 1d             	cmp    $0x1d,%edx
801030b3:	0f 8f 85 00 00 00    	jg     8010313e <log_write+0x9e>
801030b9:	a1 d8 f6 12 80       	mov    0x8012f6d8,%eax
801030be:	83 e8 01             	sub    $0x1,%eax
801030c1:	39 c2                	cmp    %eax,%edx
801030c3:	7d 79                	jge    8010313e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030c5:	a1 dc f6 12 80       	mov    0x8012f6dc,%eax
801030ca:	85 c0                	test   %eax,%eax
801030cc:	7e 7d                	jle    8010314b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
801030ce:	83 ec 0c             	sub    $0xc,%esp
801030d1:	68 a0 f6 12 80       	push   $0x8012f6a0
801030d6:	e8 95 16 00 00       	call   80104770 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801030db:	8b 15 e8 f6 12 80    	mov    0x8012f6e8,%edx
801030e1:	83 c4 10             	add    $0x10,%esp
801030e4:	85 d2                	test   %edx,%edx
801030e6:	7e 4a                	jle    80103132 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030e8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801030eb:	31 c0                	xor    %eax,%eax
801030ed:	eb 08                	jmp    801030f7 <log_write+0x57>
801030ef:	90                   	nop
801030f0:	83 c0 01             	add    $0x1,%eax
801030f3:	39 c2                	cmp    %eax,%edx
801030f5:	74 29                	je     80103120 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030f7:	39 0c 85 ec f6 12 80 	cmp    %ecx,-0x7fed0914(,%eax,4)
801030fe:	75 f0                	jne    801030f0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103100:	89 0c 85 ec f6 12 80 	mov    %ecx,-0x7fed0914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103107:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010310a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010310d:	c7 45 08 a0 f6 12 80 	movl   $0x8012f6a0,0x8(%ebp)
}
80103114:	c9                   	leave  
  release(&log.lock);
80103115:	e9 f6 15 00 00       	jmp    80104710 <release>
8010311a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103120:	89 0c 95 ec f6 12 80 	mov    %ecx,-0x7fed0914(,%edx,4)
    log.lh.n++;
80103127:	83 c2 01             	add    $0x1,%edx
8010312a:	89 15 e8 f6 12 80    	mov    %edx,0x8012f6e8
80103130:	eb d5                	jmp    80103107 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103132:	8b 43 08             	mov    0x8(%ebx),%eax
80103135:	a3 ec f6 12 80       	mov    %eax,0x8012f6ec
  if (i == log.lh.n)
8010313a:	75 cb                	jne    80103107 <log_write+0x67>
8010313c:	eb e9                	jmp    80103127 <log_write+0x87>
    panic("too big a transaction");
8010313e:	83 ec 0c             	sub    $0xc,%esp
80103141:	68 b3 8e 10 80       	push   $0x80108eb3
80103146:	e8 35 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010314b:	83 ec 0c             	sub    $0xc,%esp
8010314e:	68 c9 8e 10 80       	push   $0x80108ec9
80103153:	e8 28 d2 ff ff       	call   80100380 <panic>
80103158:	66 90                	xchg   %ax,%ax
8010315a:	66 90                	xchg   %ax,%ax
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	53                   	push   %ebx
80103164:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103167:	e8 54 09 00 00       	call   80103ac0 <cpuid>
8010316c:	89 c3                	mov    %eax,%ebx
8010316e:	e8 4d 09 00 00       	call   80103ac0 <cpuid>
80103173:	83 ec 04             	sub    $0x4,%esp
80103176:	53                   	push   %ebx
80103177:	50                   	push   %eax
80103178:	68 e4 8e 10 80       	push   $0x80108ee4
8010317d:	e8 1e d5 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103182:	e8 89 29 00 00       	call   80105b10 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103187:	e8 d4 08 00 00       	call   80103a60 <mycpu>
8010318c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010318e:	b8 01 00 00 00       	mov    $0x1,%eax
80103193:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010319a:	e8 31 0c 00 00       	call   80103dd0 <scheduler>
8010319f:	90                   	nop

801031a0 <mpenter>:
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031a6:	e8 45 3b 00 00       	call   80106cf0 <switchkvm>
  seginit();
801031ab:	e8 30 39 00 00       	call   80106ae0 <seginit>
  lapicinit();
801031b0:	e8 9b f7 ff ff       	call   80102950 <lapicinit>
  mpmain();
801031b5:	e8 a6 ff ff ff       	call   80103160 <mpmain>
801031ba:	66 90                	xchg   %ax,%ax
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <main>:
{
801031c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031c4:	83 e4 f0             	and    $0xfffffff0,%esp
801031c7:	ff 71 fc             	push   -0x4(%ecx)
801031ca:	55                   	push   %ebp
801031cb:	89 e5                	mov    %esp,%ebp
801031cd:	53                   	push   %ebx
801031ce:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031cf:	83 ec 08             	sub    $0x8,%esp
801031d2:	68 00 00 40 80       	push   $0x80400000
801031d7:	68 d0 b6 13 80       	push   $0x8013b6d0
801031dc:	e8 9f f4 ff ff       	call   80102680 <kinit1>
  kvmalloc();      // kernel page table
801031e1:	e8 ea 3f 00 00       	call   801071d0 <kvmalloc>
  mpinit();        // detect other processors
801031e6:	e8 85 01 00 00       	call   80103370 <mpinit>
  lapicinit();     // interrupt controller
801031eb:	e8 60 f7 ff ff       	call   80102950 <lapicinit>
  seginit();       // segment descriptors
801031f0:	e8 eb 38 00 00       	call   80106ae0 <seginit>
  picinit();       // disable pic
801031f5:	e8 76 03 00 00       	call   80103570 <picinit>
  ioapicinit();    // another interrupt controller
801031fa:	e8 d1 f1 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
801031ff:	e8 5c d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103204:	e8 57 2c 00 00       	call   80105e60 <uartinit>
  pinit();         // process table
80103209:	e8 32 08 00 00       	call   80103a40 <pinit>
  tvinit();        // trap vectors
8010320e:	e8 7d 28 00 00       	call   80105a90 <tvinit>
  binit();         // buffer cache
80103213:	e8 28 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103218:	e8 f3 db ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
8010321d:	e8 9e ef ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103222:	83 c4 0c             	add    $0xc,%esp
80103225:	68 8a 00 00 00       	push   $0x8a
8010322a:	68 8c c4 10 80       	push   $0x8010c48c
8010322f:	68 00 70 00 80       	push   $0x80007000
80103234:	e8 97 16 00 00       	call   801048d0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103239:	83 c4 10             	add    $0x10,%esp
8010323c:	69 05 84 f7 12 80 b0 	imul   $0xb0,0x8012f784,%eax
80103243:	00 00 00 
80103246:	05 a0 f7 12 80       	add    $0x8012f7a0,%eax
8010324b:	3d a0 f7 12 80       	cmp    $0x8012f7a0,%eax
80103250:	76 7e                	jbe    801032d0 <main+0x110>
80103252:	bb a0 f7 12 80       	mov    $0x8012f7a0,%ebx
80103257:	eb 20                	jmp    80103279 <main+0xb9>
80103259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103260:	69 05 84 f7 12 80 b0 	imul   $0xb0,0x8012f784,%eax
80103267:	00 00 00 
8010326a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103270:	05 a0 f7 12 80       	add    $0x8012f7a0,%eax
80103275:	39 c3                	cmp    %eax,%ebx
80103277:	73 57                	jae    801032d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103279:	e8 e2 07 00 00       	call   80103a60 <mycpu>
8010327e:	39 c3                	cmp    %eax,%ebx
80103280:	74 de                	je     80103260 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103282:	e8 29 f5 ff ff       	call   801027b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103287:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010328a:	c7 05 f8 6f 00 80 a0 	movl   $0x801031a0,0x80006ff8
80103291:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103294:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010329b:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010329e:	05 00 10 00 00       	add    $0x1000,%eax
801032a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801032a8:	0f b6 03             	movzbl (%ebx),%eax
801032ab:	68 00 70 00 00       	push   $0x7000
801032b0:	50                   	push   %eax
801032b1:	e8 ea f7 ff ff       	call   80102aa0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032b6:	83 c4 10             	add    $0x10,%esp
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032c6:	85 c0                	test   %eax,%eax
801032c8:	74 f6                	je     801032c0 <main+0x100>
801032ca:	eb 94                	jmp    80103260 <main+0xa0>
801032cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032d0:	83 ec 08             	sub    $0x8,%esp
801032d3:	68 00 00 00 8e       	push   $0x8e000000
801032d8:	68 00 00 40 80       	push   $0x80400000
801032dd:	e8 2e f3 ff ff       	call   80102610 <kinit2>
  userinit();      // first user process
801032e2:	e8 29 08 00 00       	call   80103b10 <userinit>
  mpmain();        // finish this processor's setup
801032e7:	e8 74 fe ff ff       	call   80103160 <mpmain>
801032ec:	66 90                	xchg   %ax,%ax
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032fb:	53                   	push   %ebx
  e = addr+len;
801032fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103302:	39 de                	cmp    %ebx,%esi
80103304:	72 10                	jb     80103316 <mpsearch1+0x26>
80103306:	eb 50                	jmp    80103358 <mpsearch1+0x68>
80103308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010330f:	90                   	nop
80103310:	89 fe                	mov    %edi,%esi
80103312:	39 fb                	cmp    %edi,%ebx
80103314:	76 42                	jbe    80103358 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103316:	83 ec 04             	sub    $0x4,%esp
80103319:	8d 7e 10             	lea    0x10(%esi),%edi
8010331c:	6a 04                	push   $0x4
8010331e:	68 f8 8e 10 80       	push   $0x80108ef8
80103323:	56                   	push   %esi
80103324:	e8 57 15 00 00       	call   80104880 <memcmp>
80103329:	83 c4 10             	add    $0x10,%esp
8010332c:	85 c0                	test   %eax,%eax
8010332e:	75 e0                	jne    80103310 <mpsearch1+0x20>
80103330:	89 f2                	mov    %esi,%edx
80103332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103338:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010333b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010333e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103340:	39 fa                	cmp    %edi,%edx
80103342:	75 f4                	jne    80103338 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103344:	84 c0                	test   %al,%al
80103346:	75 c8                	jne    80103310 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103348:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334b:	89 f0                	mov    %esi,%eax
8010334d:	5b                   	pop    %ebx
8010334e:	5e                   	pop    %esi
8010334f:	5f                   	pop    %edi
80103350:	5d                   	pop    %ebp
80103351:	c3                   	ret    
80103352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103358:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010335b:	31 f6                	xor    %esi,%esi
}
8010335d:	5b                   	pop    %ebx
8010335e:	89 f0                	mov    %esi,%eax
80103360:	5e                   	pop    %esi
80103361:	5f                   	pop    %edi
80103362:	5d                   	pop    %ebp
80103363:	c3                   	ret    
80103364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010336f:	90                   	nop

80103370 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	57                   	push   %edi
80103374:	56                   	push   %esi
80103375:	53                   	push   %ebx
80103376:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103379:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103380:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103387:	c1 e0 08             	shl    $0x8,%eax
8010338a:	09 d0                	or     %edx,%eax
8010338c:	c1 e0 04             	shl    $0x4,%eax
8010338f:	75 1b                	jne    801033ac <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103391:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103398:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010339f:	c1 e0 08             	shl    $0x8,%eax
801033a2:	09 d0                	or     %edx,%eax
801033a4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033a7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033ac:	ba 00 04 00 00       	mov    $0x400,%edx
801033b1:	e8 3a ff ff ff       	call   801032f0 <mpsearch1>
801033b6:	89 c3                	mov    %eax,%ebx
801033b8:	85 c0                	test   %eax,%eax
801033ba:	0f 84 40 01 00 00    	je     80103500 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033c0:	8b 73 04             	mov    0x4(%ebx),%esi
801033c3:	85 f6                	test   %esi,%esi
801033c5:	0f 84 25 01 00 00    	je     801034f0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
801033cb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033ce:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801033d4:	6a 04                	push   $0x4
801033d6:	68 fd 8e 10 80       	push   $0x80108efd
801033db:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801033df:	e8 9c 14 00 00       	call   80104880 <memcmp>
801033e4:	83 c4 10             	add    $0x10,%esp
801033e7:	85 c0                	test   %eax,%eax
801033e9:	0f 85 01 01 00 00    	jne    801034f0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801033ef:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033f6:	3c 01                	cmp    $0x1,%al
801033f8:	74 08                	je     80103402 <mpinit+0x92>
801033fa:	3c 04                	cmp    $0x4,%al
801033fc:	0f 85 ee 00 00 00    	jne    801034f0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103402:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103409:	66 85 d2             	test   %dx,%dx
8010340c:	74 22                	je     80103430 <mpinit+0xc0>
8010340e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103411:	89 f0                	mov    %esi,%eax
  sum = 0;
80103413:	31 d2                	xor    %edx,%edx
80103415:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103418:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010341f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103422:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103424:	39 c7                	cmp    %eax,%edi
80103426:	75 f0                	jne    80103418 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103428:	84 d2                	test   %dl,%dl
8010342a:	0f 85 c0 00 00 00    	jne    801034f0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103430:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103436:	a3 80 f6 12 80       	mov    %eax,0x8012f680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010343b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103442:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103448:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010344d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103450:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103457:	90                   	nop
80103458:	39 d0                	cmp    %edx,%eax
8010345a:	73 15                	jae    80103471 <mpinit+0x101>
    switch(*p){
8010345c:	0f b6 08             	movzbl (%eax),%ecx
8010345f:	80 f9 02             	cmp    $0x2,%cl
80103462:	74 4c                	je     801034b0 <mpinit+0x140>
80103464:	77 3a                	ja     801034a0 <mpinit+0x130>
80103466:	84 c9                	test   %cl,%cl
80103468:	74 56                	je     801034c0 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010346a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010346d:	39 d0                	cmp    %edx,%eax
8010346f:	72 eb                	jb     8010345c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103471:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103474:	85 f6                	test   %esi,%esi
80103476:	0f 84 d9 00 00 00    	je     80103555 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010347c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103480:	74 15                	je     80103497 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103482:	b8 70 00 00 00       	mov    $0x70,%eax
80103487:	ba 22 00 00 00       	mov    $0x22,%edx
8010348c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010348d:	ba 23 00 00 00       	mov    $0x23,%edx
80103492:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103493:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103496:	ee                   	out    %al,(%dx)
  }
}
80103497:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010349a:	5b                   	pop    %ebx
8010349b:	5e                   	pop    %esi
8010349c:	5f                   	pop    %edi
8010349d:	5d                   	pop    %ebp
8010349e:	c3                   	ret    
8010349f:	90                   	nop
    switch(*p){
801034a0:	83 e9 03             	sub    $0x3,%ecx
801034a3:	80 f9 01             	cmp    $0x1,%cl
801034a6:	76 c2                	jbe    8010346a <mpinit+0xfa>
801034a8:	31 f6                	xor    %esi,%esi
801034aa:	eb ac                	jmp    80103458 <mpinit+0xe8>
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801034b0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801034b4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801034b7:	88 0d 80 f7 12 80    	mov    %cl,0x8012f780
      continue;
801034bd:	eb 99                	jmp    80103458 <mpinit+0xe8>
801034bf:	90                   	nop
      if(ncpu < NCPU) {
801034c0:	8b 0d 84 f7 12 80    	mov    0x8012f784,%ecx
801034c6:	83 f9 07             	cmp    $0x7,%ecx
801034c9:	7f 19                	jg     801034e4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034cb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801034d1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801034d5:	83 c1 01             	add    $0x1,%ecx
801034d8:	89 0d 84 f7 12 80    	mov    %ecx,0x8012f784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034de:	88 9f a0 f7 12 80    	mov    %bl,-0x7fed0860(%edi)
      p += sizeof(struct mpproc);
801034e4:	83 c0 14             	add    $0x14,%eax
      continue;
801034e7:	e9 6c ff ff ff       	jmp    80103458 <mpinit+0xe8>
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	68 02 8f 10 80       	push   $0x80108f02
801034f8:	e8 83 ce ff ff       	call   80100380 <panic>
801034fd:	8d 76 00             	lea    0x0(%esi),%esi
{
80103500:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103505:	eb 13                	jmp    8010351a <mpinit+0x1aa>
80103507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103510:	89 f3                	mov    %esi,%ebx
80103512:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103518:	74 d6                	je     801034f0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010351a:	83 ec 04             	sub    $0x4,%esp
8010351d:	8d 73 10             	lea    0x10(%ebx),%esi
80103520:	6a 04                	push   $0x4
80103522:	68 f8 8e 10 80       	push   $0x80108ef8
80103527:	53                   	push   %ebx
80103528:	e8 53 13 00 00       	call   80104880 <memcmp>
8010352d:	83 c4 10             	add    $0x10,%esp
80103530:	85 c0                	test   %eax,%eax
80103532:	75 dc                	jne    80103510 <mpinit+0x1a0>
80103534:	89 da                	mov    %ebx,%edx
80103536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010353d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103540:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103543:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103546:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103548:	39 d6                	cmp    %edx,%esi
8010354a:	75 f4                	jne    80103540 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010354c:	84 c0                	test   %al,%al
8010354e:	75 c0                	jne    80103510 <mpinit+0x1a0>
80103550:	e9 6b fe ff ff       	jmp    801033c0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103555:	83 ec 0c             	sub    $0xc,%esp
80103558:	68 1c 8f 10 80       	push   $0x80108f1c
8010355d:	e8 1e ce ff ff       	call   80100380 <panic>
80103562:	66 90                	xchg   %ax,%ax
80103564:	66 90                	xchg   %ax,%ax
80103566:	66 90                	xchg   %ax,%ax
80103568:	66 90                	xchg   %ax,%ax
8010356a:	66 90                	xchg   %ax,%ax
8010356c:	66 90                	xchg   %ax,%ax
8010356e:	66 90                	xchg   %ax,%ax

80103570 <picinit>:
80103570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103575:	ba 21 00 00 00       	mov    $0x21,%edx
8010357a:	ee                   	out    %al,(%dx)
8010357b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103580:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103581:	c3                   	ret    
80103582:	66 90                	xchg   %ax,%ax
80103584:	66 90                	xchg   %ax,%ax
80103586:	66 90                	xchg   %ax,%ax
80103588:	66 90                	xchg   %ax,%ax
8010358a:	66 90                	xchg   %ax,%ax
8010358c:	66 90                	xchg   %ax,%ax
8010358e:	66 90                	xchg   %ax,%ax

80103590 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 0c             	sub    $0xc,%esp
80103599:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010359c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010359f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801035a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035ab:	e8 80 d8 ff ff       	call   80100e30 <filealloc>
801035b0:	89 03                	mov    %eax,(%ebx)
801035b2:	85 c0                	test   %eax,%eax
801035b4:	0f 84 a8 00 00 00    	je     80103662 <pipealloc+0xd2>
801035ba:	e8 71 d8 ff ff       	call   80100e30 <filealloc>
801035bf:	89 06                	mov    %eax,(%esi)
801035c1:	85 c0                	test   %eax,%eax
801035c3:	0f 84 87 00 00 00    	je     80103650 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035c9:	e8 e2 f1 ff ff       	call   801027b0 <kalloc>
801035ce:	89 c7                	mov    %eax,%edi
801035d0:	85 c0                	test   %eax,%eax
801035d2:	0f 84 b0 00 00 00    	je     80103688 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801035d8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035df:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035e2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801035e5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035ec:	00 00 00 
  p->nwrite = 0;
801035ef:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035f6:	00 00 00 
  p->nread = 0;
801035f9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103600:	00 00 00 
  initlock(&p->lock, "pipe");
80103603:	68 3b 8f 10 80       	push   $0x80108f3b
80103608:	50                   	push   %eax
80103609:	e8 92 0f 00 00       	call   801045a0 <initlock>
  (*f0)->type = FD_PIPE;
8010360e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103610:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103613:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103619:	8b 03                	mov    (%ebx),%eax
8010361b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010361f:	8b 03                	mov    (%ebx),%eax
80103621:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103625:	8b 03                	mov    (%ebx),%eax
80103627:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010362a:	8b 06                	mov    (%esi),%eax
8010362c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103632:	8b 06                	mov    (%esi),%eax
80103634:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103638:	8b 06                	mov    (%esi),%eax
8010363a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010363e:	8b 06                	mov    (%esi),%eax
80103640:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103643:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103646:	31 c0                	xor    %eax,%eax
}
80103648:	5b                   	pop    %ebx
80103649:	5e                   	pop    %esi
8010364a:	5f                   	pop    %edi
8010364b:	5d                   	pop    %ebp
8010364c:	c3                   	ret    
8010364d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103650:	8b 03                	mov    (%ebx),%eax
80103652:	85 c0                	test   %eax,%eax
80103654:	74 1e                	je     80103674 <pipealloc+0xe4>
    fileclose(*f0);
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	50                   	push   %eax
8010365a:	e8 91 d8 ff ff       	call   80100ef0 <fileclose>
8010365f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103662:	8b 06                	mov    (%esi),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	74 0c                	je     80103674 <pipealloc+0xe4>
    fileclose(*f1);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	50                   	push   %eax
8010366c:	e8 7f d8 ff ff       	call   80100ef0 <fileclose>
80103671:	83 c4 10             	add    $0x10,%esp
}
80103674:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103688:	8b 03                	mov    (%ebx),%eax
8010368a:	85 c0                	test   %eax,%eax
8010368c:	75 c8                	jne    80103656 <pipealloc+0xc6>
8010368e:	eb d2                	jmp    80103662 <pipealloc+0xd2>

80103690 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	56                   	push   %esi
80103694:	53                   	push   %ebx
80103695:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103698:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010369b:	83 ec 0c             	sub    $0xc,%esp
8010369e:	53                   	push   %ebx
8010369f:	e8 cc 10 00 00       	call   80104770 <acquire>
  if(writable){
801036a4:	83 c4 10             	add    $0x10,%esp
801036a7:	85 f6                	test   %esi,%esi
801036a9:	74 65                	je     80103710 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801036ab:	83 ec 0c             	sub    $0xc,%esp
801036ae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801036b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036bb:	00 00 00 
    wakeup(&p->nread);
801036be:	50                   	push   %eax
801036bf:	e8 0c 0c 00 00       	call   801042d0 <wakeup>
801036c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036cd:	85 d2                	test   %edx,%edx
801036cf:	75 0a                	jne    801036db <pipeclose+0x4b>
801036d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036d7:	85 c0                	test   %eax,%eax
801036d9:	74 15                	je     801036f0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036e1:	5b                   	pop    %ebx
801036e2:	5e                   	pop    %esi
801036e3:	5d                   	pop    %ebp
    release(&p->lock);
801036e4:	e9 27 10 00 00       	jmp    80104710 <release>
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036f0:	83 ec 0c             	sub    $0xc,%esp
801036f3:	53                   	push   %ebx
801036f4:	e8 17 10 00 00       	call   80104710 <release>
    kfree((char*)p);
801036f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036fc:	83 c4 10             	add    $0x10,%esp
}
801036ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103702:	5b                   	pop    %ebx
80103703:	5e                   	pop    %esi
80103704:	5d                   	pop    %ebp
    kfree((char*)p);
80103705:	e9 b6 ed ff ff       	jmp    801024c0 <kfree>
8010370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103719:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103720:	00 00 00 
    wakeup(&p->nwrite);
80103723:	50                   	push   %eax
80103724:	e8 a7 0b 00 00       	call   801042d0 <wakeup>
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	eb 99                	jmp    801036c7 <pipeclose+0x37>
8010372e:	66 90                	xchg   %ax,%ax

80103730 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 28             	sub    $0x28,%esp
80103739:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010373c:	53                   	push   %ebx
8010373d:	e8 2e 10 00 00       	call   80104770 <acquire>
  for(i = 0; i < n; i++){
80103742:	8b 45 10             	mov    0x10(%ebp),%eax
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	85 c0                	test   %eax,%eax
8010374a:	0f 8e c0 00 00 00    	jle    80103810 <pipewrite+0xe0>
80103750:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103753:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103759:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010375f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103762:	03 45 10             	add    0x10(%ebp),%eax
80103765:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103768:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010376e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103774:	89 ca                	mov    %ecx,%edx
80103776:	05 00 02 00 00       	add    $0x200,%eax
8010377b:	39 c1                	cmp    %eax,%ecx
8010377d:	74 3f                	je     801037be <pipewrite+0x8e>
8010377f:	eb 67                	jmp    801037e8 <pipewrite+0xb8>
80103781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103788:	e8 53 03 00 00       	call   80103ae0 <myproc>
8010378d:	8b 48 24             	mov    0x24(%eax),%ecx
80103790:	85 c9                	test   %ecx,%ecx
80103792:	75 34                	jne    801037c8 <pipewrite+0x98>
      wakeup(&p->nread);
80103794:	83 ec 0c             	sub    $0xc,%esp
80103797:	57                   	push   %edi
80103798:	e8 33 0b 00 00       	call   801042d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010379d:	58                   	pop    %eax
8010379e:	5a                   	pop    %edx
8010379f:	53                   	push   %ebx
801037a0:	56                   	push   %esi
801037a1:	e8 6a 0a 00 00       	call   80104210 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037a6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037ac:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037b2:	83 c4 10             	add    $0x10,%esp
801037b5:	05 00 02 00 00       	add    $0x200,%eax
801037ba:	39 c2                	cmp    %eax,%edx
801037bc:	75 2a                	jne    801037e8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801037be:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037c4:	85 c0                	test   %eax,%eax
801037c6:	75 c0                	jne    80103788 <pipewrite+0x58>
        release(&p->lock);
801037c8:	83 ec 0c             	sub    $0xc,%esp
801037cb:	53                   	push   %ebx
801037cc:	e8 3f 0f 00 00       	call   80104710 <release>
        return -1;
801037d1:	83 c4 10             	add    $0x10,%esp
801037d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037dc:	5b                   	pop    %ebx
801037dd:	5e                   	pop    %esi
801037de:	5f                   	pop    %edi
801037df:	5d                   	pop    %ebp
801037e0:	c3                   	ret    
801037e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037e8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801037eb:	8d 4a 01             	lea    0x1(%edx),%ecx
801037ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037f4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801037fa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801037fd:	83 c6 01             	add    $0x1,%esi
80103800:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103803:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103807:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010380a:	0f 85 58 ff ff ff    	jne    80103768 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103810:	83 ec 0c             	sub    $0xc,%esp
80103813:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103819:	50                   	push   %eax
8010381a:	e8 b1 0a 00 00       	call   801042d0 <wakeup>
  release(&p->lock);
8010381f:	89 1c 24             	mov    %ebx,(%esp)
80103822:	e8 e9 0e 00 00       	call   80104710 <release>
  return n;
80103827:	8b 45 10             	mov    0x10(%ebp),%eax
8010382a:	83 c4 10             	add    $0x10,%esp
8010382d:	eb aa                	jmp    801037d9 <pipewrite+0xa9>
8010382f:	90                   	nop

80103830 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	57                   	push   %edi
80103834:	56                   	push   %esi
80103835:	53                   	push   %ebx
80103836:	83 ec 18             	sub    $0x18,%esp
80103839:	8b 75 08             	mov    0x8(%ebp),%esi
8010383c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010383f:	56                   	push   %esi
80103840:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103846:	e8 25 0f 00 00       	call   80104770 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010384b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103851:	83 c4 10             	add    $0x10,%esp
80103854:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010385a:	74 2f                	je     8010388b <piperead+0x5b>
8010385c:	eb 37                	jmp    80103895 <piperead+0x65>
8010385e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103860:	e8 7b 02 00 00       	call   80103ae0 <myproc>
80103865:	8b 48 24             	mov    0x24(%eax),%ecx
80103868:	85 c9                	test   %ecx,%ecx
8010386a:	0f 85 80 00 00 00    	jne    801038f0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103870:	83 ec 08             	sub    $0x8,%esp
80103873:	56                   	push   %esi
80103874:	53                   	push   %ebx
80103875:	e8 96 09 00 00       	call   80104210 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010387a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103880:	83 c4 10             	add    $0x10,%esp
80103883:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103889:	75 0a                	jne    80103895 <piperead+0x65>
8010388b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103891:	85 c0                	test   %eax,%eax
80103893:	75 cb                	jne    80103860 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103895:	8b 55 10             	mov    0x10(%ebp),%edx
80103898:	31 db                	xor    %ebx,%ebx
8010389a:	85 d2                	test   %edx,%edx
8010389c:	7f 20                	jg     801038be <piperead+0x8e>
8010389e:	eb 2c                	jmp    801038cc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038a0:	8d 48 01             	lea    0x1(%eax),%ecx
801038a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801038a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801038ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801038b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038b6:	83 c3 01             	add    $0x1,%ebx
801038b9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801038bc:	74 0e                	je     801038cc <piperead+0x9c>
    if(p->nread == p->nwrite)
801038be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801038ca:	75 d4                	jne    801038a0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801038cc:	83 ec 0c             	sub    $0xc,%esp
801038cf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801038d5:	50                   	push   %eax
801038d6:	e8 f5 09 00 00       	call   801042d0 <wakeup>
  release(&p->lock);
801038db:	89 34 24             	mov    %esi,(%esp)
801038de:	e8 2d 0e 00 00       	call   80104710 <release>
  return i;
801038e3:	83 c4 10             	add    $0x10,%esp
}
801038e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038e9:	89 d8                	mov    %ebx,%eax
801038eb:	5b                   	pop    %ebx
801038ec:	5e                   	pop    %esi
801038ed:	5f                   	pop    %edi
801038ee:	5d                   	pop    %ebp
801038ef:	c3                   	ret    
      release(&p->lock);
801038f0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038f8:	56                   	push   %esi
801038f9:	e8 12 0e 00 00       	call   80104710 <release>
      return -1;
801038fe:	83 c4 10             	add    $0x10,%esp
}
80103901:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103904:	89 d8                	mov    %ebx,%eax
80103906:	5b                   	pop    %ebx
80103907:	5e                   	pop    %esi
80103908:	5f                   	pop    %edi
80103909:	5d                   	pop    %ebp
8010390a:	c3                   	ret    
8010390b:	66 90                	xchg   %ax,%ax
8010390d:	66 90                	xchg   %ax,%ax
8010390f:	90                   	nop

80103910 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103914:	bb 54 fd 12 80       	mov    $0x8012fd54,%ebx
{
80103919:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010391c:	68 20 fd 12 80       	push   $0x8012fd20
80103921:	e8 4a 0e 00 00       	call   80104770 <acquire>
80103926:	83 c4 10             	add    $0x10,%esp
80103929:	eb 17                	jmp    80103942 <allocproc+0x32>
8010392b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010392f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103930:	81 c3 84 02 00 00    	add    $0x284,%ebx
80103936:	81 fb 54 9e 13 80    	cmp    $0x80139e54,%ebx
8010393c:	0f 84 7e 00 00 00    	je     801039c0 <allocproc+0xb0>
    if(p->state == UNUSED)
80103942:	8b 43 0c             	mov    0xc(%ebx),%eax
80103945:	85 c0                	test   %eax,%eax
80103947:	75 e7                	jne    80103930 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103949:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
8010394e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103951:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103958:	89 43 10             	mov    %eax,0x10(%ebx)
8010395b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010395e:	68 20 fd 12 80       	push   $0x8012fd20
  p->pid = nextpid++;
80103963:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103969:	e8 a2 0d 00 00       	call   80104710 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010396e:	e8 3d ee ff ff       	call   801027b0 <kalloc>
80103973:	83 c4 10             	add    $0x10,%esp
80103976:	89 43 08             	mov    %eax,0x8(%ebx)
80103979:	85 c0                	test   %eax,%eax
8010397b:	74 5c                	je     801039d9 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010397d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103983:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103986:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010398b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010398e:	c7 40 14 82 5a 10 80 	movl   $0x80105a82,0x14(%eax)
  p->context = (struct context*)sp;
80103995:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103998:	6a 14                	push   $0x14
8010399a:	6a 00                	push   $0x0
8010399c:	50                   	push   %eax
8010399d:	e8 8e 0e 00 00       	call   80104830 <memset>
  p->context->eip = (uint)forkret;
801039a2:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039a5:	c7 40 10 f0 39 10 80 	movl   $0x801039f0,0x10(%eax)
  init_mmaps(p);
801039ac:	89 1c 24             	mov    %ebx,(%esp)
801039af:	e8 2c 4a 00 00       	call   801083e0 <init_mmaps>

  return p;
}
801039b4:	89 d8                	mov    %ebx,%eax
  return p;
801039b6:	83 c4 10             	add    $0x10,%esp
}
801039b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039bc:	c9                   	leave  
801039bd:	c3                   	ret    
801039be:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
801039c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801039c3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801039c5:	68 20 fd 12 80       	push   $0x8012fd20
801039ca:	e8 41 0d 00 00       	call   80104710 <release>
}
801039cf:	89 d8                	mov    %ebx,%eax
  return 0;
801039d1:	83 c4 10             	add    $0x10,%esp
}
801039d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039d7:	c9                   	leave  
801039d8:	c3                   	ret    
    p->state = UNUSED;
801039d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039e0:	31 db                	xor    %ebx,%ebx
}
801039e2:	89 d8                	mov    %ebx,%eax
801039e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039e7:	c9                   	leave  
801039e8:	c3                   	ret    
801039e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039f6:	68 20 fd 12 80       	push   $0x8012fd20
801039fb:	e8 10 0d 00 00       	call   80104710 <release>

  if (first) {
80103a00:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103a05:	83 c4 10             	add    $0x10,%esp
80103a08:	85 c0                	test   %eax,%eax
80103a0a:	75 04                	jne    80103a10 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a0c:	c9                   	leave  
80103a0d:	c3                   	ret    
80103a0e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a10:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103a17:	00 00 00 
    iinit(ROOTDEV);
80103a1a:	83 ec 0c             	sub    $0xc,%esp
80103a1d:	6a 01                	push   $0x1
80103a1f:	e8 3c db ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103a24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a2b:	e8 f0 f3 ff ff       	call   80102e20 <initlog>
}
80103a30:	83 c4 10             	add    $0x10,%esp
80103a33:	c9                   	leave  
80103a34:	c3                   	ret    
80103a35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a40 <pinit>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a46:	68 40 8f 10 80       	push   $0x80108f40
80103a4b:	68 20 fd 12 80       	push   $0x8012fd20
80103a50:	e8 4b 0b 00 00       	call   801045a0 <initlock>
}
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	c9                   	leave  
80103a59:	c3                   	ret    
80103a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a60 <mycpu>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	56                   	push   %esi
80103a64:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a65:	9c                   	pushf  
80103a66:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a67:	f6 c4 02             	test   $0x2,%ah
80103a6a:	75 46                	jne    80103ab2 <mycpu+0x52>
  apicid = lapicid();
80103a6c:	e8 df ef ff ff       	call   80102a50 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a71:	8b 35 84 f7 12 80    	mov    0x8012f784,%esi
80103a77:	85 f6                	test   %esi,%esi
80103a79:	7e 2a                	jle    80103aa5 <mycpu+0x45>
80103a7b:	31 d2                	xor    %edx,%edx
80103a7d:	eb 08                	jmp    80103a87 <mycpu+0x27>
80103a7f:	90                   	nop
80103a80:	83 c2 01             	add    $0x1,%edx
80103a83:	39 f2                	cmp    %esi,%edx
80103a85:	74 1e                	je     80103aa5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a87:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a8d:	0f b6 99 a0 f7 12 80 	movzbl -0x7fed0860(%ecx),%ebx
80103a94:	39 c3                	cmp    %eax,%ebx
80103a96:	75 e8                	jne    80103a80 <mycpu+0x20>
}
80103a98:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a9b:	8d 81 a0 f7 12 80    	lea    -0x7fed0860(%ecx),%eax
}
80103aa1:	5b                   	pop    %ebx
80103aa2:	5e                   	pop    %esi
80103aa3:	5d                   	pop    %ebp
80103aa4:	c3                   	ret    
  panic("unknown apicid\n");
80103aa5:	83 ec 0c             	sub    $0xc,%esp
80103aa8:	68 47 8f 10 80       	push   $0x80108f47
80103aad:	e8 ce c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ab2:	83 ec 0c             	sub    $0xc,%esp
80103ab5:	68 24 90 10 80       	push   $0x80109024
80103aba:	e8 c1 c8 ff ff       	call   80100380 <panic>
80103abf:	90                   	nop

80103ac0 <cpuid>:
cpuid() {
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ac6:	e8 95 ff ff ff       	call   80103a60 <mycpu>
}
80103acb:	c9                   	leave  
  return mycpu()-cpus;
80103acc:	2d a0 f7 12 80       	sub    $0x8012f7a0,%eax
80103ad1:	c1 f8 04             	sar    $0x4,%eax
80103ad4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103ada:	c3                   	ret    
80103adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103adf:	90                   	nop

80103ae0 <myproc>:
myproc(void) {
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ae7:	e8 34 0b 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103aec:	e8 6f ff ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103af1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103af7:	e8 74 0b 00 00       	call   80104670 <popcli>
}
80103afc:	89 d8                	mov    %ebx,%eax
80103afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b01:	c9                   	leave  
80103b02:	c3                   	ret    
80103b03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b10 <userinit>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
80103b14:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b17:	e8 f4 fd ff ff       	call   80103910 <allocproc>
80103b1c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b1e:	a3 54 9e 13 80       	mov    %eax,0x80139e54
  if((p->pgdir = setupkvm()) == 0)
80103b23:	e8 28 36 00 00       	call   80107150 <setupkvm>
80103b28:	89 43 04             	mov    %eax,0x4(%ebx)
80103b2b:	85 c0                	test   %eax,%eax
80103b2d:	0f 84 bd 00 00 00    	je     80103bf0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b33:	83 ec 04             	sub    $0x4,%esp
80103b36:	68 2c 00 00 00       	push   $0x2c
80103b3b:	68 60 c4 10 80       	push   $0x8010c460
80103b40:	50                   	push   %eax
80103b41:	e8 ca 32 00 00       	call   80106e10 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b46:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b49:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b4f:	6a 4c                	push   $0x4c
80103b51:	6a 00                	push   $0x0
80103b53:	ff 73 18             	push   0x18(%ebx)
80103b56:	e8 d5 0c 00 00       	call   80104830 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b5b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b5e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b63:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b66:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b6b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b6f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b72:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b76:	8b 43 18             	mov    0x18(%ebx),%eax
80103b79:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b7d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b81:	8b 43 18             	mov    0x18(%ebx),%eax
80103b84:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b88:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b8c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b8f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b96:	8b 43 18             	mov    0x18(%ebx),%eax
80103b99:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ba0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ba3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103baa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bad:	6a 10                	push   $0x10
80103baf:	68 70 8f 10 80       	push   $0x80108f70
80103bb4:	50                   	push   %eax
80103bb5:	e8 36 0e 00 00       	call   801049f0 <safestrcpy>
  p->cwd = namei("/");
80103bba:	c7 04 24 79 8f 10 80 	movl   $0x80108f79,(%esp)
80103bc1:	e8 da e4 ff ff       	call   801020a0 <namei>
80103bc6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bc9:	c7 04 24 20 fd 12 80 	movl   $0x8012fd20,(%esp)
80103bd0:	e8 9b 0b 00 00       	call   80104770 <acquire>
  p->state = RUNNABLE;
80103bd5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bdc:	c7 04 24 20 fd 12 80 	movl   $0x8012fd20,(%esp)
80103be3:	e8 28 0b 00 00       	call   80104710 <release>
}
80103be8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103beb:	83 c4 10             	add    $0x10,%esp
80103bee:	c9                   	leave  
80103bef:	c3                   	ret    
    panic("userinit: out of memory?");
80103bf0:	83 ec 0c             	sub    $0xc,%esp
80103bf3:	68 57 8f 10 80       	push   $0x80108f57
80103bf8:	e8 83 c7 ff ff       	call   80100380 <panic>
80103bfd:	8d 76 00             	lea    0x0(%esi),%esi

80103c00 <growproc>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
80103c05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c08:	e8 13 0a 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103c0d:	e8 4e fe ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103c12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c18:	e8 53 0a 00 00       	call   80104670 <popcli>
  sz = curproc->sz;
80103c1d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c1f:	85 f6                	test   %esi,%esi
80103c21:	7f 1d                	jg     80103c40 <growproc+0x40>
  } else if(n < 0){
80103c23:	75 3b                	jne    80103c60 <growproc+0x60>
  switchuvm(curproc);
80103c25:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c28:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c2a:	53                   	push   %ebx
80103c2b:	e8 d0 30 00 00       	call   80106d00 <switchuvm>
  return 0;
80103c30:	83 c4 10             	add    $0x10,%esp
80103c33:	31 c0                	xor    %eax,%eax
}
80103c35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c38:	5b                   	pop    %ebx
80103c39:	5e                   	pop    %esi
80103c3a:	5d                   	pop    %ebp
80103c3b:	c3                   	ret    
80103c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 04             	push   0x4(%ebx)
80103c4a:	e8 31 33 00 00       	call   80106f80 <allocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 cf                	jne    80103c25 <growproc+0x25>
      return -1;
80103c56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c5b:	eb d8                	jmp    80103c35 <growproc+0x35>
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c60:	83 ec 04             	sub    $0x4,%esp
80103c63:	01 c6                	add    %eax,%esi
80103c65:	56                   	push   %esi
80103c66:	50                   	push   %eax
80103c67:	ff 73 04             	push   0x4(%ebx)
80103c6a:	e8 31 34 00 00       	call   801070a0 <deallocuvm>
80103c6f:	83 c4 10             	add    $0x10,%esp
80103c72:	85 c0                	test   %eax,%eax
80103c74:	75 af                	jne    80103c25 <growproc+0x25>
80103c76:	eb de                	jmp    80103c56 <growproc+0x56>
80103c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7f:	90                   	nop

80103c80 <fork>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c89:	e8 92 09 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103c8e:	e8 cd fd ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103c93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c99:	e8 d2 09 00 00       	call   80104670 <popcli>
  if((np = allocproc()) == 0){
80103c9e:	e8 6d fc ff ff       	call   80103910 <allocproc>
80103ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ca6:	85 c0                	test   %eax,%eax
80103ca8:	0f 84 d7 00 00 00    	je     80103d85 <fork+0x105>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103cae:	83 ec 08             	sub    $0x8,%esp
80103cb1:	ff 33                	push   (%ebx)
80103cb3:	89 c7                	mov    %eax,%edi
80103cb5:	ff 73 04             	push   0x4(%ebx)
80103cb8:	e8 83 35 00 00       	call   80107240 <copyuvm>
80103cbd:	83 c4 10             	add    $0x10,%esp
80103cc0:	89 47 04             	mov    %eax,0x4(%edi)
80103cc3:	85 c0                	test   %eax,%eax
80103cc5:	0f 84 c1 00 00 00    	je     80103d8c <fork+0x10c>
  if(copy_maps(curproc, np) < 0){
80103ccb:	83 ec 08             	sub    $0x8,%esp
80103cce:	ff 75 e4             	push   -0x1c(%ebp)
80103cd1:	53                   	push   %ebx
80103cd2:	e8 e9 49 00 00       	call   801086c0 <copy_maps>
80103cd7:	83 c4 10             	add    $0x10,%esp
80103cda:	85 c0                	test   %eax,%eax
80103cdc:	0f 88 d2 00 00 00    	js     80103db4 <fork+0x134>
  np->sz = curproc->sz;
80103ce2:	8b 03                	mov    (%ebx),%eax
80103ce4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ce7:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ce9:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103cec:	89 c8                	mov    %ecx,%eax
80103cee:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103cf1:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cf6:	8b 73 18             	mov    0x18(%ebx),%esi
80103cf9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cfb:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cfd:	8b 40 18             	mov    0x18(%eax),%eax
80103d00:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80103d10:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d14:	85 c0                	test   %eax,%eax
80103d16:	74 13                	je     80103d2b <fork+0xab>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d18:	83 ec 0c             	sub    $0xc,%esp
80103d1b:	50                   	push   %eax
80103d1c:	e8 7f d1 ff ff       	call   80100ea0 <filedup>
80103d21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d24:	83 c4 10             	add    $0x10,%esp
80103d27:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d2b:	83 c6 01             	add    $0x1,%esi
80103d2e:	83 fe 10             	cmp    $0x10,%esi
80103d31:	75 dd                	jne    80103d10 <fork+0x90>
  np->cwd = idup(curproc->cwd);
80103d33:	83 ec 0c             	sub    $0xc,%esp
80103d36:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d39:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d3c:	e8 0f da ff ff       	call   80101750 <idup>
80103d41:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d44:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d47:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d4a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d4d:	6a 10                	push   $0x10
80103d4f:	53                   	push   %ebx
80103d50:	50                   	push   %eax
80103d51:	e8 9a 0c 00 00       	call   801049f0 <safestrcpy>
  pid = np->pid;
80103d56:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d59:	c7 04 24 20 fd 12 80 	movl   $0x8012fd20,(%esp)
80103d60:	e8 0b 0a 00 00       	call   80104770 <acquire>
  np->state = RUNNABLE;
80103d65:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d6c:	c7 04 24 20 fd 12 80 	movl   $0x8012fd20,(%esp)
80103d73:	e8 98 09 00 00       	call   80104710 <release>
  return pid;
80103d78:	83 c4 10             	add    $0x10,%esp
}
80103d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d7e:	89 d8                	mov    %ebx,%eax
80103d80:	5b                   	pop    %ebx
80103d81:	5e                   	pop    %esi
80103d82:	5f                   	pop    %edi
80103d83:	5d                   	pop    %ebp
80103d84:	c3                   	ret    
    return -1;
80103d85:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d8a:	eb ef                	jmp    80103d7b <fork+0xfb>
    kfree(np->kstack);
80103d8c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d8f:	83 ec 0c             	sub    $0xc,%esp
80103d92:	89 d8                	mov    %ebx,%eax
    kfree(np->kstack);
80103d94:	ff 70 08             	push   0x8(%eax)
80103d97:	e8 24 e7 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103d9c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103da3:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103da6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103dad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103db2:	eb c7                	jmp    80103d7b <fork+0xfb>
    freevm(np->pgdir);
80103db4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103db7:	83 ec 0c             	sub    $0xc,%esp
80103dba:	ff 73 04             	push   0x4(%ebx)
80103dbd:	e8 0e 33 00 00       	call   801070d0 <freevm>
    np->pgdir = 0;
80103dc2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
80103dc9:	89 d8                	mov    %ebx,%eax
    kfree(np->kstack);
80103dcb:	5a                   	pop    %edx
80103dcc:	eb c6                	jmp    80103d94 <fork+0x114>
80103dce:	66 90                	xchg   %ax,%ax

80103dd0 <scheduler>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103dd9:	e8 82 fc ff ff       	call   80103a60 <mycpu>
  c->proc = 0;
80103dde:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103de5:	00 00 00 
  struct cpu *c = mycpu();
80103de8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103dea:	8d 78 04             	lea    0x4(%eax),%edi
80103ded:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103df0:	fb                   	sti    
    acquire(&ptable.lock);
80103df1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df4:	bb 54 fd 12 80       	mov    $0x8012fd54,%ebx
    acquire(&ptable.lock);
80103df9:	68 20 fd 12 80       	push   $0x8012fd20
80103dfe:	e8 6d 09 00 00       	call   80104770 <acquire>
80103e03:	83 c4 10             	add    $0x10,%esp
80103e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103e10:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e14:	75 33                	jne    80103e49 <scheduler+0x79>
      switchuvm(p);
80103e16:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e19:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e1f:	53                   	push   %ebx
80103e20:	e8 db 2e 00 00       	call   80106d00 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e25:	58                   	pop    %eax
80103e26:	5a                   	pop    %edx
80103e27:	ff 73 1c             	push   0x1c(%ebx)
80103e2a:	57                   	push   %edi
      p->state = RUNNING;
80103e2b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e32:	e8 14 0c 00 00       	call   80104a4b <swtch>
      switchkvm();
80103e37:	e8 b4 2e 00 00       	call   80106cf0 <switchkvm>
      c->proc = 0;
80103e3c:	83 c4 10             	add    $0x10,%esp
80103e3f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e46:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e49:	81 c3 84 02 00 00    	add    $0x284,%ebx
80103e4f:	81 fb 54 9e 13 80    	cmp    $0x80139e54,%ebx
80103e55:	75 b9                	jne    80103e10 <scheduler+0x40>
    release(&ptable.lock);
80103e57:	83 ec 0c             	sub    $0xc,%esp
80103e5a:	68 20 fd 12 80       	push   $0x8012fd20
80103e5f:	e8 ac 08 00 00       	call   80104710 <release>
    sti();
80103e64:	83 c4 10             	add    $0x10,%esp
80103e67:	eb 87                	jmp    80103df0 <scheduler+0x20>
80103e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e70 <sched>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	56                   	push   %esi
80103e74:	53                   	push   %ebx
  pushcli();
80103e75:	e8 a6 07 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103e7a:	e8 e1 fb ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80103e7f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e85:	e8 e6 07 00 00       	call   80104670 <popcli>
  if(!holding(&ptable.lock))
80103e8a:	83 ec 0c             	sub    $0xc,%esp
80103e8d:	68 20 fd 12 80       	push   $0x8012fd20
80103e92:	e8 39 08 00 00       	call   801046d0 <holding>
80103e97:	83 c4 10             	add    $0x10,%esp
80103e9a:	85 c0                	test   %eax,%eax
80103e9c:	74 4f                	je     80103eed <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e9e:	e8 bd fb ff ff       	call   80103a60 <mycpu>
80103ea3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eaa:	75 68                	jne    80103f14 <sched+0xa4>
  if(p->state == RUNNING)
80103eac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103eb0:	74 55                	je     80103f07 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103eb2:	9c                   	pushf  
80103eb3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103eb4:	f6 c4 02             	test   $0x2,%ah
80103eb7:	75 41                	jne    80103efa <sched+0x8a>
  intena = mycpu()->intena;
80103eb9:	e8 a2 fb ff ff       	call   80103a60 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ebe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ec1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ec7:	e8 94 fb ff ff       	call   80103a60 <mycpu>
80103ecc:	83 ec 08             	sub    $0x8,%esp
80103ecf:	ff 70 04             	push   0x4(%eax)
80103ed2:	53                   	push   %ebx
80103ed3:	e8 73 0b 00 00       	call   80104a4b <swtch>
  mycpu()->intena = intena;
80103ed8:	e8 83 fb ff ff       	call   80103a60 <mycpu>
}
80103edd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ee0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ee6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ee9:	5b                   	pop    %ebx
80103eea:	5e                   	pop    %esi
80103eeb:	5d                   	pop    %ebp
80103eec:	c3                   	ret    
    panic("sched ptable.lock");
80103eed:	83 ec 0c             	sub    $0xc,%esp
80103ef0:	68 7b 8f 10 80       	push   $0x80108f7b
80103ef5:	e8 86 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 a7 8f 10 80       	push   $0x80108fa7
80103f02:	e8 79 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f07:	83 ec 0c             	sub    $0xc,%esp
80103f0a:	68 99 8f 10 80       	push   $0x80108f99
80103f0f:	e8 6c c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f14:	83 ec 0c             	sub    $0xc,%esp
80103f17:	68 8d 8f 10 80       	push   $0x80108f8d
80103f1c:	e8 5f c4 ff ff       	call   80100380 <panic>
80103f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2f:	90                   	nop

80103f30 <exit>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	57                   	push   %edi
80103f34:	56                   	push   %esi
80103f35:	53                   	push   %ebx
80103f36:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103f39:	e8 a2 fb ff ff       	call   80103ae0 <myproc>
  if(curproc == initproc)
80103f3e:	39 05 54 9e 13 80    	cmp    %eax,0x80139e54
80103f44:	0f 84 17 01 00 00    	je     80104061 <exit+0x131>
  if(delete_mmaps(curproc) < 0)
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	89 c3                	mov    %eax,%ebx
80103f4f:	50                   	push   %eax
80103f50:	e8 fb 48 00 00       	call   80108850 <delete_mmaps>
80103f55:	83 c4 10             	add    $0x10,%esp
80103f58:	85 c0                	test   %eax,%eax
80103f5a:	0f 88 0e 01 00 00    	js     8010406e <exit+0x13e>
80103f60:	8d 73 28             	lea    0x28(%ebx),%esi
80103f63:	8d 7b 68             	lea    0x68(%ebx),%edi
80103f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103f70:	8b 06                	mov    (%esi),%eax
80103f72:	85 c0                	test   %eax,%eax
80103f74:	74 12                	je     80103f88 <exit+0x58>
      fileclose(curproc->ofile[fd]);
80103f76:	83 ec 0c             	sub    $0xc,%esp
80103f79:	50                   	push   %eax
80103f7a:	e8 71 cf ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103f7f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f85:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f88:	83 c6 04             	add    $0x4,%esi
80103f8b:	39 f7                	cmp    %esi,%edi
80103f8d:	75 e1                	jne    80103f70 <exit+0x40>
  begin_op();
80103f8f:	e8 2c ef ff ff       	call   80102ec0 <begin_op>
  iput(curproc->cwd);
80103f94:	83 ec 0c             	sub    $0xc,%esp
80103f97:	ff 73 68             	push   0x68(%ebx)
80103f9a:	e8 11 d9 ff ff       	call   801018b0 <iput>
  end_op();
80103f9f:	e8 8c ef ff ff       	call   80102f30 <end_op>
  curproc->cwd = 0;
80103fa4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103fab:	c7 04 24 20 fd 12 80 	movl   $0x8012fd20,(%esp)
80103fb2:	e8 b9 07 00 00       	call   80104770 <acquire>
  wakeup1(curproc->parent);
80103fb7:	8b 53 14             	mov    0x14(%ebx),%edx
80103fba:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fbd:	b8 54 fd 12 80       	mov    $0x8012fd54,%eax
80103fc2:	eb 10                	jmp    80103fd4 <exit+0xa4>
80103fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fc8:	05 84 02 00 00       	add    $0x284,%eax
80103fcd:	3d 54 9e 13 80       	cmp    $0x80139e54,%eax
80103fd2:	74 1e                	je     80103ff2 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
80103fd4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fd8:	75 ee                	jne    80103fc8 <exit+0x98>
80103fda:	3b 50 20             	cmp    0x20(%eax),%edx
80103fdd:	75 e9                	jne    80103fc8 <exit+0x98>
      p->state = RUNNABLE;
80103fdf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fe6:	05 84 02 00 00       	add    $0x284,%eax
80103feb:	3d 54 9e 13 80       	cmp    $0x80139e54,%eax
80103ff0:	75 e2                	jne    80103fd4 <exit+0xa4>
      p->parent = initproc;
80103ff2:	8b 0d 54 9e 13 80    	mov    0x80139e54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff8:	ba 54 fd 12 80       	mov    $0x8012fd54,%edx
80103ffd:	eb 0f                	jmp    8010400e <exit+0xde>
80103fff:	90                   	nop
80104000:	81 c2 84 02 00 00    	add    $0x284,%edx
80104006:	81 fa 54 9e 13 80    	cmp    $0x80139e54,%edx
8010400c:	74 3a                	je     80104048 <exit+0x118>
    if(p->parent == curproc){
8010400e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104011:	75 ed                	jne    80104000 <exit+0xd0>
      if(p->state == ZOMBIE)
80104013:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104017:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010401a:	75 e4                	jne    80104000 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010401c:	b8 54 fd 12 80       	mov    $0x8012fd54,%eax
80104021:	eb 11                	jmp    80104034 <exit+0x104>
80104023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104027:	90                   	nop
80104028:	05 84 02 00 00       	add    $0x284,%eax
8010402d:	3d 54 9e 13 80       	cmp    $0x80139e54,%eax
80104032:	74 cc                	je     80104000 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104034:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104038:	75 ee                	jne    80104028 <exit+0xf8>
8010403a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010403d:	75 e9                	jne    80104028 <exit+0xf8>
      p->state = RUNNABLE;
8010403f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104046:	eb e0                	jmp    80104028 <exit+0xf8>
  curproc->state = ZOMBIE;
80104048:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010404f:	e8 1c fe ff ff       	call   80103e70 <sched>
  panic("zombie exit");
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	68 c8 8f 10 80       	push   $0x80108fc8
8010405c:	e8 1f c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104061:	83 ec 0c             	sub    $0xc,%esp
80104064:	68 bb 8f 10 80       	push   $0x80108fbb
80104069:	e8 12 c3 ff ff       	call   80100380 <panic>
    cprintf("delete_mmaps failed in exit for pid %d\n", curproc->pid);
8010406e:	50                   	push   %eax
8010406f:	50                   	push   %eax
80104070:	ff 73 10             	push   0x10(%ebx)
80104073:	68 4c 90 10 80       	push   $0x8010904c
80104078:	e8 23 c6 ff ff       	call   801006a0 <cprintf>
8010407d:	83 c4 10             	add    $0x10,%esp
80104080:	e9 db fe ff ff       	jmp    80103f60 <exit+0x30>
80104085:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104090 <wait>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	56                   	push   %esi
80104094:	53                   	push   %ebx
  pushcli();
80104095:	e8 86 05 00 00       	call   80104620 <pushcli>
  c = mycpu();
8010409a:	e8 c1 f9 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
8010409f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040a5:	e8 c6 05 00 00       	call   80104670 <popcli>
  acquire(&ptable.lock);
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 20 fd 12 80       	push   $0x8012fd20
801040b2:	e8 b9 06 00 00       	call   80104770 <acquire>
801040b7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040bc:	bb 54 fd 12 80       	mov    $0x8012fd54,%ebx
801040c1:	eb 13                	jmp    801040d6 <wait+0x46>
801040c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c7:	90                   	nop
801040c8:	81 c3 84 02 00 00    	add    $0x284,%ebx
801040ce:	81 fb 54 9e 13 80    	cmp    $0x80139e54,%ebx
801040d4:	74 1e                	je     801040f4 <wait+0x64>
      if(p->parent != curproc)
801040d6:	39 73 14             	cmp    %esi,0x14(%ebx)
801040d9:	75 ed                	jne    801040c8 <wait+0x38>
      if(p->state == ZOMBIE){
801040db:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040df:	74 5f                	je     80104140 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e1:	81 c3 84 02 00 00    	add    $0x284,%ebx
      havekids = 1;
801040e7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ec:	81 fb 54 9e 13 80    	cmp    $0x80139e54,%ebx
801040f2:	75 e2                	jne    801040d6 <wait+0x46>
    if(!havekids || curproc->killed){
801040f4:	85 c0                	test   %eax,%eax
801040f6:	0f 84 9a 00 00 00    	je     80104196 <wait+0x106>
801040fc:	8b 46 24             	mov    0x24(%esi),%eax
801040ff:	85 c0                	test   %eax,%eax
80104101:	0f 85 8f 00 00 00    	jne    80104196 <wait+0x106>
  pushcli();
80104107:	e8 14 05 00 00       	call   80104620 <pushcli>
  c = mycpu();
8010410c:	e8 4f f9 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80104111:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104117:	e8 54 05 00 00       	call   80104670 <popcli>
  if(p == 0)
8010411c:	85 db                	test   %ebx,%ebx
8010411e:	0f 84 89 00 00 00    	je     801041ad <wait+0x11d>
  p->chan = chan;
80104124:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104127:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010412e:	e8 3d fd ff ff       	call   80103e70 <sched>
  p->chan = 0;
80104133:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010413a:	e9 7b ff ff ff       	jmp    801040ba <wait+0x2a>
8010413f:	90                   	nop
        kfree(p->kstack);
80104140:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104143:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104146:	ff 73 08             	push   0x8(%ebx)
80104149:	e8 72 e3 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010414e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104155:	5a                   	pop    %edx
80104156:	ff 73 04             	push   0x4(%ebx)
80104159:	e8 72 2f 00 00       	call   801070d0 <freevm>
        p->pid = 0;
8010415e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104165:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010416c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104170:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104177:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010417e:	c7 04 24 20 fd 12 80 	movl   $0x8012fd20,(%esp)
80104185:	e8 86 05 00 00       	call   80104710 <release>
        return pid;
8010418a:	83 c4 10             	add    $0x10,%esp
}
8010418d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104190:	89 f0                	mov    %esi,%eax
80104192:	5b                   	pop    %ebx
80104193:	5e                   	pop    %esi
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret    
      release(&ptable.lock);
80104196:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104199:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010419e:	68 20 fd 12 80       	push   $0x8012fd20
801041a3:	e8 68 05 00 00       	call   80104710 <release>
      return -1;
801041a8:	83 c4 10             	add    $0x10,%esp
801041ab:	eb e0                	jmp    8010418d <wait+0xfd>
    panic("sleep");
801041ad:	83 ec 0c             	sub    $0xc,%esp
801041b0:	68 d4 8f 10 80       	push   $0x80108fd4
801041b5:	e8 c6 c1 ff ff       	call   80100380 <panic>
801041ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041c0 <yield>:
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041c7:	68 20 fd 12 80       	push   $0x8012fd20
801041cc:	e8 9f 05 00 00       	call   80104770 <acquire>
  pushcli();
801041d1:	e8 4a 04 00 00       	call   80104620 <pushcli>
  c = mycpu();
801041d6:	e8 85 f8 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
801041db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041e1:	e8 8a 04 00 00       	call   80104670 <popcli>
  myproc()->state = RUNNABLE;
801041e6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041ed:	e8 7e fc ff ff       	call   80103e70 <sched>
  release(&ptable.lock);
801041f2:	c7 04 24 20 fd 12 80 	movl   $0x8012fd20,(%esp)
801041f9:	e8 12 05 00 00       	call   80104710 <release>
}
801041fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104201:	83 c4 10             	add    $0x10,%esp
80104204:	c9                   	leave  
80104205:	c3                   	ret    
80104206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420d:	8d 76 00             	lea    0x0(%esi),%esi

80104210 <sleep>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
80104216:	83 ec 0c             	sub    $0xc,%esp
80104219:	8b 7d 08             	mov    0x8(%ebp),%edi
8010421c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010421f:	e8 fc 03 00 00       	call   80104620 <pushcli>
  c = mycpu();
80104224:	e8 37 f8 ff ff       	call   80103a60 <mycpu>
  p = c->proc;
80104229:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010422f:	e8 3c 04 00 00       	call   80104670 <popcli>
  if(p == 0)
80104234:	85 db                	test   %ebx,%ebx
80104236:	0f 84 87 00 00 00    	je     801042c3 <sleep+0xb3>
  if(lk == 0)
8010423c:	85 f6                	test   %esi,%esi
8010423e:	74 76                	je     801042b6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104240:	81 fe 20 fd 12 80    	cmp    $0x8012fd20,%esi
80104246:	74 50                	je     80104298 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104248:	83 ec 0c             	sub    $0xc,%esp
8010424b:	68 20 fd 12 80       	push   $0x8012fd20
80104250:	e8 1b 05 00 00       	call   80104770 <acquire>
    release(lk);
80104255:	89 34 24             	mov    %esi,(%esp)
80104258:	e8 b3 04 00 00       	call   80104710 <release>
  p->chan = chan;
8010425d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104260:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104267:	e8 04 fc ff ff       	call   80103e70 <sched>
  p->chan = 0;
8010426c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104273:	c7 04 24 20 fd 12 80 	movl   $0x8012fd20,(%esp)
8010427a:	e8 91 04 00 00       	call   80104710 <release>
    acquire(lk);
8010427f:	89 75 08             	mov    %esi,0x8(%ebp)
80104282:	83 c4 10             	add    $0x10,%esp
}
80104285:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104288:	5b                   	pop    %ebx
80104289:	5e                   	pop    %esi
8010428a:	5f                   	pop    %edi
8010428b:	5d                   	pop    %ebp
    acquire(lk);
8010428c:	e9 df 04 00 00       	jmp    80104770 <acquire>
80104291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104298:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010429b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042a2:	e8 c9 fb ff ff       	call   80103e70 <sched>
  p->chan = 0;
801042a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b1:	5b                   	pop    %ebx
801042b2:	5e                   	pop    %esi
801042b3:	5f                   	pop    %edi
801042b4:	5d                   	pop    %ebp
801042b5:	c3                   	ret    
    panic("sleep without lk");
801042b6:	83 ec 0c             	sub    $0xc,%esp
801042b9:	68 da 8f 10 80       	push   $0x80108fda
801042be:	e8 bd c0 ff ff       	call   80100380 <panic>
    panic("sleep");
801042c3:	83 ec 0c             	sub    $0xc,%esp
801042c6:	68 d4 8f 10 80       	push   $0x80108fd4
801042cb:	e8 b0 c0 ff ff       	call   80100380 <panic>

801042d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 10             	sub    $0x10,%esp
801042d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042da:	68 20 fd 12 80       	push   $0x8012fd20
801042df:	e8 8c 04 00 00       	call   80104770 <acquire>
801042e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042e7:	b8 54 fd 12 80       	mov    $0x8012fd54,%eax
801042ec:	eb 0e                	jmp    801042fc <wakeup+0x2c>
801042ee:	66 90                	xchg   %ax,%ax
801042f0:	05 84 02 00 00       	add    $0x284,%eax
801042f5:	3d 54 9e 13 80       	cmp    $0x80139e54,%eax
801042fa:	74 1e                	je     8010431a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801042fc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104300:	75 ee                	jne    801042f0 <wakeup+0x20>
80104302:	3b 58 20             	cmp    0x20(%eax),%ebx
80104305:	75 e9                	jne    801042f0 <wakeup+0x20>
      p->state = RUNNABLE;
80104307:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010430e:	05 84 02 00 00       	add    $0x284,%eax
80104313:	3d 54 9e 13 80       	cmp    $0x80139e54,%eax
80104318:	75 e2                	jne    801042fc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010431a:	c7 45 08 20 fd 12 80 	movl   $0x8012fd20,0x8(%ebp)
}
80104321:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104324:	c9                   	leave  
  release(&ptable.lock);
80104325:	e9 e6 03 00 00       	jmp    80104710 <release>
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
80104337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010433a:	68 20 fd 12 80       	push   $0x8012fd20
8010433f:	e8 2c 04 00 00       	call   80104770 <acquire>
80104344:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104347:	b8 54 fd 12 80       	mov    $0x8012fd54,%eax
8010434c:	eb 0e                	jmp    8010435c <kill+0x2c>
8010434e:	66 90                	xchg   %ax,%ax
80104350:	05 84 02 00 00       	add    $0x284,%eax
80104355:	3d 54 9e 13 80       	cmp    $0x80139e54,%eax
8010435a:	74 34                	je     80104390 <kill+0x60>
    if(p->pid == pid){
8010435c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010435f:	75 ef                	jne    80104350 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104361:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104365:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010436c:	75 07                	jne    80104375 <kill+0x45>
        p->state = RUNNABLE;
8010436e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104375:	83 ec 0c             	sub    $0xc,%esp
80104378:	68 20 fd 12 80       	push   $0x8012fd20
8010437d:	e8 8e 03 00 00       	call   80104710 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104385:	83 c4 10             	add    $0x10,%esp
80104388:	31 c0                	xor    %eax,%eax
}
8010438a:	c9                   	leave  
8010438b:	c3                   	ret    
8010438c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104390:	83 ec 0c             	sub    $0xc,%esp
80104393:	68 20 fd 12 80       	push   $0x8012fd20
80104398:	e8 73 03 00 00       	call   80104710 <release>
}
8010439d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043a0:	83 c4 10             	add    $0x10,%esp
801043a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043a8:	c9                   	leave  
801043a9:	c3                   	ret    
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	57                   	push   %edi
801043b4:	56                   	push   %esi
801043b5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043b8:	53                   	push   %ebx
801043b9:	bb c0 fd 12 80       	mov    $0x8012fdc0,%ebx
801043be:	83 ec 3c             	sub    $0x3c,%esp
801043c1:	eb 27                	jmp    801043ea <procdump+0x3a>
801043c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043c7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	68 07 94 10 80       	push   $0x80109407
801043d0:	e8 cb c2 ff ff       	call   801006a0 <cprintf>
801043d5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d8:	81 c3 84 02 00 00    	add    $0x284,%ebx
801043de:	81 fb c0 9e 13 80    	cmp    $0x80139ec0,%ebx
801043e4:	0f 84 7e 00 00 00    	je     80104468 <procdump+0xb8>
    if(p->state == UNUSED)
801043ea:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043ed:	85 c0                	test   %eax,%eax
801043ef:	74 e7                	je     801043d8 <procdump+0x28>
      state = "???";
801043f1:	ba eb 8f 10 80       	mov    $0x80108feb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043f6:	83 f8 05             	cmp    $0x5,%eax
801043f9:	77 11                	ja     8010440c <procdump+0x5c>
801043fb:	8b 14 85 74 90 10 80 	mov    -0x7fef6f8c(,%eax,4),%edx
      state = "???";
80104402:	b8 eb 8f 10 80       	mov    $0x80108feb,%eax
80104407:	85 d2                	test   %edx,%edx
80104409:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010440c:	53                   	push   %ebx
8010440d:	52                   	push   %edx
8010440e:	ff 73 a4             	push   -0x5c(%ebx)
80104411:	68 ef 8f 10 80       	push   $0x80108fef
80104416:	e8 85 c2 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010441b:	83 c4 10             	add    $0x10,%esp
8010441e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104422:	75 a4                	jne    801043c8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104424:	83 ec 08             	sub    $0x8,%esp
80104427:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010442a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010442d:	50                   	push   %eax
8010442e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104431:	8b 40 0c             	mov    0xc(%eax),%eax
80104434:	83 c0 08             	add    $0x8,%eax
80104437:	50                   	push   %eax
80104438:	e8 83 01 00 00       	call   801045c0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010443d:	83 c4 10             	add    $0x10,%esp
80104440:	8b 17                	mov    (%edi),%edx
80104442:	85 d2                	test   %edx,%edx
80104444:	74 82                	je     801043c8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104446:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104449:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010444c:	52                   	push   %edx
8010444d:	68 21 8a 10 80       	push   $0x80108a21
80104452:	e8 49 c2 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104457:	83 c4 10             	add    $0x10,%esp
8010445a:	39 fe                	cmp    %edi,%esi
8010445c:	75 e2                	jne    80104440 <procdump+0x90>
8010445e:	e9 65 ff ff ff       	jmp    801043c8 <procdump+0x18>
80104463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104467:	90                   	nop
  }
}
80104468:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010446b:	5b                   	pop    %ebx
8010446c:	5e                   	pop    %esi
8010446d:	5f                   	pop    %edi
8010446e:	5d                   	pop    %ebp
8010446f:	c3                   	ret    

80104470 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	53                   	push   %ebx
80104474:	83 ec 0c             	sub    $0xc,%esp
80104477:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010447a:	68 8c 90 10 80       	push   $0x8010908c
8010447f:	8d 43 04             	lea    0x4(%ebx),%eax
80104482:	50                   	push   %eax
80104483:	e8 18 01 00 00       	call   801045a0 <initlock>
  lk->name = name;
80104488:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010448b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104491:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104494:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010449b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010449e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a1:	c9                   	leave  
801044a2:	c3                   	ret    
801044a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
801044b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044b8:	8d 73 04             	lea    0x4(%ebx),%esi
801044bb:	83 ec 0c             	sub    $0xc,%esp
801044be:	56                   	push   %esi
801044bf:	e8 ac 02 00 00       	call   80104770 <acquire>
  while (lk->locked) {
801044c4:	8b 13                	mov    (%ebx),%edx
801044c6:	83 c4 10             	add    $0x10,%esp
801044c9:	85 d2                	test   %edx,%edx
801044cb:	74 16                	je     801044e3 <acquiresleep+0x33>
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044d0:	83 ec 08             	sub    $0x8,%esp
801044d3:	56                   	push   %esi
801044d4:	53                   	push   %ebx
801044d5:	e8 36 fd ff ff       	call   80104210 <sleep>
  while (lk->locked) {
801044da:	8b 03                	mov    (%ebx),%eax
801044dc:	83 c4 10             	add    $0x10,%esp
801044df:	85 c0                	test   %eax,%eax
801044e1:	75 ed                	jne    801044d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044e9:	e8 f2 f5 ff ff       	call   80103ae0 <myproc>
801044ee:	8b 40 10             	mov    0x10(%eax),%eax
801044f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044fa:	5b                   	pop    %ebx
801044fb:	5e                   	pop    %esi
801044fc:	5d                   	pop    %ebp
  release(&lk->lk);
801044fd:	e9 0e 02 00 00       	jmp    80104710 <release>
80104502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104510 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104518:	8d 73 04             	lea    0x4(%ebx),%esi
8010451b:	83 ec 0c             	sub    $0xc,%esp
8010451e:	56                   	push   %esi
8010451f:	e8 4c 02 00 00       	call   80104770 <acquire>
  lk->locked = 0;
80104524:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010452a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104531:	89 1c 24             	mov    %ebx,(%esp)
80104534:	e8 97 fd ff ff       	call   801042d0 <wakeup>
  release(&lk->lk);
80104539:	89 75 08             	mov    %esi,0x8(%ebp)
8010453c:	83 c4 10             	add    $0x10,%esp
}
8010453f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104542:	5b                   	pop    %ebx
80104543:	5e                   	pop    %esi
80104544:	5d                   	pop    %ebp
  release(&lk->lk);
80104545:	e9 c6 01 00 00       	jmp    80104710 <release>
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104550 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	57                   	push   %edi
80104554:	31 ff                	xor    %edi,%edi
80104556:	56                   	push   %esi
80104557:	53                   	push   %ebx
80104558:	83 ec 18             	sub    $0x18,%esp
8010455b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010455e:	8d 73 04             	lea    0x4(%ebx),%esi
80104561:	56                   	push   %esi
80104562:	e8 09 02 00 00       	call   80104770 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104567:	8b 03                	mov    (%ebx),%eax
80104569:	83 c4 10             	add    $0x10,%esp
8010456c:	85 c0                	test   %eax,%eax
8010456e:	75 18                	jne    80104588 <holdingsleep+0x38>
  release(&lk->lk);
80104570:	83 ec 0c             	sub    $0xc,%esp
80104573:	56                   	push   %esi
80104574:	e8 97 01 00 00       	call   80104710 <release>
  return r;
}
80104579:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010457c:	89 f8                	mov    %edi,%eax
8010457e:	5b                   	pop    %ebx
8010457f:	5e                   	pop    %esi
80104580:	5f                   	pop    %edi
80104581:	5d                   	pop    %ebp
80104582:	c3                   	ret    
80104583:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104587:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104588:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010458b:	e8 50 f5 ff ff       	call   80103ae0 <myproc>
80104590:	39 58 10             	cmp    %ebx,0x10(%eax)
80104593:	0f 94 c0             	sete   %al
80104596:	0f b6 c0             	movzbl %al,%eax
80104599:	89 c7                	mov    %eax,%edi
8010459b:	eb d3                	jmp    80104570 <holdingsleep+0x20>
8010459d:	66 90                	xchg   %ax,%ax
8010459f:	90                   	nop

801045a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045b9:	5d                   	pop    %ebp
801045ba:	c3                   	ret    
801045bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045bf:	90                   	nop

801045c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045c0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045c1:	31 d2                	xor    %edx,%edx
{
801045c3:	89 e5                	mov    %esp,%ebp
801045c5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801045c6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801045c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801045cc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801045cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045d0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045dc:	77 1a                	ja     801045f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045de:	8b 58 04             	mov    0x4(%eax),%ebx
801045e1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801045e4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801045e7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045e9:	83 fa 0a             	cmp    $0xa,%edx
801045ec:	75 e2                	jne    801045d0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f1:	c9                   	leave  
801045f2:	c3                   	ret    
801045f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f7:	90                   	nop
  for(; i < 10; i++)
801045f8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801045fb:	8d 51 28             	lea    0x28(%ecx),%edx
801045fe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104606:	83 c0 04             	add    $0x4,%eax
80104609:	39 d0                	cmp    %edx,%eax
8010460b:	75 f3                	jne    80104600 <getcallerpcs+0x40>
}
8010460d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104610:	c9                   	leave  
80104611:	c3                   	ret    
80104612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104620 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 04             	sub    $0x4,%esp
80104627:	9c                   	pushf  
80104628:	5b                   	pop    %ebx
  asm volatile("cli");
80104629:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010462a:	e8 31 f4 ff ff       	call   80103a60 <mycpu>
8010462f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104635:	85 c0                	test   %eax,%eax
80104637:	74 17                	je     80104650 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104639:	e8 22 f4 ff ff       	call   80103a60 <mycpu>
8010463e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104648:	c9                   	leave  
80104649:	c3                   	ret    
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104650:	e8 0b f4 ff ff       	call   80103a60 <mycpu>
80104655:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010465b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104661:	eb d6                	jmp    80104639 <pushcli+0x19>
80104663:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104670 <popcli>:

void
popcli(void)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104676:	9c                   	pushf  
80104677:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104678:	f6 c4 02             	test   $0x2,%ah
8010467b:	75 35                	jne    801046b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010467d:	e8 de f3 ff ff       	call   80103a60 <mycpu>
80104682:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104689:	78 34                	js     801046bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010468b:	e8 d0 f3 ff ff       	call   80103a60 <mycpu>
80104690:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104696:	85 d2                	test   %edx,%edx
80104698:	74 06                	je     801046a0 <popcli+0x30>
    sti();
}
8010469a:	c9                   	leave  
8010469b:	c3                   	ret    
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046a0:	e8 bb f3 ff ff       	call   80103a60 <mycpu>
801046a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046ab:	85 c0                	test   %eax,%eax
801046ad:	74 eb                	je     8010469a <popcli+0x2a>
  asm volatile("sti");
801046af:	fb                   	sti    
}
801046b0:	c9                   	leave  
801046b1:	c3                   	ret    
    panic("popcli - interruptible");
801046b2:	83 ec 0c             	sub    $0xc,%esp
801046b5:	68 97 90 10 80       	push   $0x80109097
801046ba:	e8 c1 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046bf:	83 ec 0c             	sub    $0xc,%esp
801046c2:	68 ae 90 10 80       	push   $0x801090ae
801046c7:	e8 b4 bc ff ff       	call   80100380 <panic>
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <holding>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	8b 75 08             	mov    0x8(%ebp),%esi
801046d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801046da:	e8 41 ff ff ff       	call   80104620 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046df:	8b 06                	mov    (%esi),%eax
801046e1:	85 c0                	test   %eax,%eax
801046e3:	75 0b                	jne    801046f0 <holding+0x20>
  popcli();
801046e5:	e8 86 ff ff ff       	call   80104670 <popcli>
}
801046ea:	89 d8                	mov    %ebx,%eax
801046ec:	5b                   	pop    %ebx
801046ed:	5e                   	pop    %esi
801046ee:	5d                   	pop    %ebp
801046ef:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
801046f0:	8b 5e 08             	mov    0x8(%esi),%ebx
801046f3:	e8 68 f3 ff ff       	call   80103a60 <mycpu>
801046f8:	39 c3                	cmp    %eax,%ebx
801046fa:	0f 94 c3             	sete   %bl
  popcli();
801046fd:	e8 6e ff ff ff       	call   80104670 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104702:	0f b6 db             	movzbl %bl,%ebx
}
80104705:	89 d8                	mov    %ebx,%eax
80104707:	5b                   	pop    %ebx
80104708:	5e                   	pop    %esi
80104709:	5d                   	pop    %ebp
8010470a:	c3                   	ret    
8010470b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010470f:	90                   	nop

80104710 <release>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104718:	e8 03 ff ff ff       	call   80104620 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010471d:	8b 03                	mov    (%ebx),%eax
8010471f:	85 c0                	test   %eax,%eax
80104721:	75 15                	jne    80104738 <release+0x28>
  popcli();
80104723:	e8 48 ff ff ff       	call   80104670 <popcli>
    panic("release");
80104728:	83 ec 0c             	sub    $0xc,%esp
8010472b:	68 b5 90 10 80       	push   $0x801090b5
80104730:	e8 4b bc ff ff       	call   80100380 <panic>
80104735:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104738:	8b 73 08             	mov    0x8(%ebx),%esi
8010473b:	e8 20 f3 ff ff       	call   80103a60 <mycpu>
80104740:	39 c6                	cmp    %eax,%esi
80104742:	75 df                	jne    80104723 <release+0x13>
  popcli();
80104744:	e8 27 ff ff ff       	call   80104670 <popcli>
  lk->pcs[0] = 0;
80104749:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104750:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104757:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010475c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104762:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104765:	5b                   	pop    %ebx
80104766:	5e                   	pop    %esi
80104767:	5d                   	pop    %ebp
  popcli();
80104768:	e9 03 ff ff ff       	jmp    80104670 <popcli>
8010476d:	8d 76 00             	lea    0x0(%esi),%esi

80104770 <acquire>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104777:	e8 a4 fe ff ff       	call   80104620 <pushcli>
  if(holding(lk))
8010477c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010477f:	e8 9c fe ff ff       	call   80104620 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104784:	8b 03                	mov    (%ebx),%eax
80104786:	85 c0                	test   %eax,%eax
80104788:	75 7e                	jne    80104808 <acquire+0x98>
  popcli();
8010478a:	e8 e1 fe ff ff       	call   80104670 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010478f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104798:	8b 55 08             	mov    0x8(%ebp),%edx
8010479b:	89 c8                	mov    %ecx,%eax
8010479d:	f0 87 02             	lock xchg %eax,(%edx)
801047a0:	85 c0                	test   %eax,%eax
801047a2:	75 f4                	jne    80104798 <acquire+0x28>
  __sync_synchronize();
801047a4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047ac:	e8 af f2 ff ff       	call   80103a60 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801047b4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801047b6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801047b9:	31 c0                	xor    %eax,%eax
801047bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801047c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047cc:	77 1a                	ja     801047e8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801047ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801047d1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801047d5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801047d8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801047da:	83 f8 0a             	cmp    $0xa,%eax
801047dd:	75 e1                	jne    801047c0 <acquire+0x50>
}
801047df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047e2:	c9                   	leave  
801047e3:	c3                   	ret    
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801047e8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801047ec:	8d 51 34             	lea    0x34(%ecx),%edx
801047ef:	90                   	nop
    pcs[i] = 0;
801047f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047f6:	83 c0 04             	add    $0x4,%eax
801047f9:	39 c2                	cmp    %eax,%edx
801047fb:	75 f3                	jne    801047f0 <acquire+0x80>
}
801047fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104800:	c9                   	leave  
80104801:	c3                   	ret    
80104802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104808:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010480b:	e8 50 f2 ff ff       	call   80103a60 <mycpu>
80104810:	39 c3                	cmp    %eax,%ebx
80104812:	0f 85 72 ff ff ff    	jne    8010478a <acquire+0x1a>
  popcli();
80104818:	e8 53 fe ff ff       	call   80104670 <popcli>
    panic("acquire");
8010481d:	83 ec 0c             	sub    $0xc,%esp
80104820:	68 bd 90 10 80       	push   $0x801090bd
80104825:	e8 56 bb ff ff       	call   80100380 <panic>
8010482a:	66 90                	xchg   %ax,%ax
8010482c:	66 90                	xchg   %ax,%ax
8010482e:	66 90                	xchg   %ax,%ax

80104830 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	8b 55 08             	mov    0x8(%ebp),%edx
80104837:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010483a:	53                   	push   %ebx
8010483b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010483e:	89 d7                	mov    %edx,%edi
80104840:	09 cf                	or     %ecx,%edi
80104842:	83 e7 03             	and    $0x3,%edi
80104845:	75 29                	jne    80104870 <memset+0x40>
    c &= 0xFF;
80104847:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010484a:	c1 e0 18             	shl    $0x18,%eax
8010484d:	89 fb                	mov    %edi,%ebx
8010484f:	c1 e9 02             	shr    $0x2,%ecx
80104852:	c1 e3 10             	shl    $0x10,%ebx
80104855:	09 d8                	or     %ebx,%eax
80104857:	09 f8                	or     %edi,%eax
80104859:	c1 e7 08             	shl    $0x8,%edi
8010485c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010485e:	89 d7                	mov    %edx,%edi
80104860:	fc                   	cld    
80104861:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104863:	5b                   	pop    %ebx
80104864:	89 d0                	mov    %edx,%eax
80104866:	5f                   	pop    %edi
80104867:	5d                   	pop    %ebp
80104868:	c3                   	ret    
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104870:	89 d7                	mov    %edx,%edi
80104872:	fc                   	cld    
80104873:	f3 aa                	rep stos %al,%es:(%edi)
80104875:	5b                   	pop    %ebx
80104876:	89 d0                	mov    %edx,%eax
80104878:	5f                   	pop    %edi
80104879:	5d                   	pop    %ebp
8010487a:	c3                   	ret    
8010487b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010487f:	90                   	nop

80104880 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	8b 75 10             	mov    0x10(%ebp),%esi
80104887:	8b 55 08             	mov    0x8(%ebp),%edx
8010488a:	53                   	push   %ebx
8010488b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010488e:	85 f6                	test   %esi,%esi
80104890:	74 2e                	je     801048c0 <memcmp+0x40>
80104892:	01 c6                	add    %eax,%esi
80104894:	eb 14                	jmp    801048aa <memcmp+0x2a>
80104896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048a0:	83 c0 01             	add    $0x1,%eax
801048a3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048a6:	39 f0                	cmp    %esi,%eax
801048a8:	74 16                	je     801048c0 <memcmp+0x40>
    if(*s1 != *s2)
801048aa:	0f b6 0a             	movzbl (%edx),%ecx
801048ad:	0f b6 18             	movzbl (%eax),%ebx
801048b0:	38 d9                	cmp    %bl,%cl
801048b2:	74 ec                	je     801048a0 <memcmp+0x20>
      return *s1 - *s2;
801048b4:	0f b6 c1             	movzbl %cl,%eax
801048b7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048b9:	5b                   	pop    %ebx
801048ba:	5e                   	pop    %esi
801048bb:	5d                   	pop    %ebp
801048bc:	c3                   	ret    
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
801048c0:	5b                   	pop    %ebx
  return 0;
801048c1:	31 c0                	xor    %eax,%eax
}
801048c3:	5e                   	pop    %esi
801048c4:	5d                   	pop    %ebp
801048c5:	c3                   	ret    
801048c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048cd:	8d 76 00             	lea    0x0(%esi),%esi

801048d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	57                   	push   %edi
801048d4:	8b 55 08             	mov    0x8(%ebp),%edx
801048d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048da:	56                   	push   %esi
801048db:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048de:	39 d6                	cmp    %edx,%esi
801048e0:	73 26                	jae    80104908 <memmove+0x38>
801048e2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801048e5:	39 fa                	cmp    %edi,%edx
801048e7:	73 1f                	jae    80104908 <memmove+0x38>
801048e9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801048ec:	85 c9                	test   %ecx,%ecx
801048ee:	74 0c                	je     801048fc <memmove+0x2c>
      *--d = *--s;
801048f0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801048f4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801048f7:	83 e8 01             	sub    $0x1,%eax
801048fa:	73 f4                	jae    801048f0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048fc:	5e                   	pop    %esi
801048fd:	89 d0                	mov    %edx,%eax
801048ff:	5f                   	pop    %edi
80104900:	5d                   	pop    %ebp
80104901:	c3                   	ret    
80104902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104908:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010490b:	89 d7                	mov    %edx,%edi
8010490d:	85 c9                	test   %ecx,%ecx
8010490f:	74 eb                	je     801048fc <memmove+0x2c>
80104911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104918:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104919:	39 c6                	cmp    %eax,%esi
8010491b:	75 fb                	jne    80104918 <memmove+0x48>
}
8010491d:	5e                   	pop    %esi
8010491e:	89 d0                	mov    %edx,%eax
80104920:	5f                   	pop    %edi
80104921:	5d                   	pop    %ebp
80104922:	c3                   	ret    
80104923:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104930 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104930:	eb 9e                	jmp    801048d0 <memmove>
80104932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104940 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	8b 75 10             	mov    0x10(%ebp),%esi
80104947:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010494a:	53                   	push   %ebx
8010494b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010494e:	85 f6                	test   %esi,%esi
80104950:	74 2e                	je     80104980 <strncmp+0x40>
80104952:	01 d6                	add    %edx,%esi
80104954:	eb 18                	jmp    8010496e <strncmp+0x2e>
80104956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
80104960:	38 d8                	cmp    %bl,%al
80104962:	75 14                	jne    80104978 <strncmp+0x38>
    n--, p++, q++;
80104964:	83 c2 01             	add    $0x1,%edx
80104967:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010496a:	39 f2                	cmp    %esi,%edx
8010496c:	74 12                	je     80104980 <strncmp+0x40>
8010496e:	0f b6 01             	movzbl (%ecx),%eax
80104971:	0f b6 1a             	movzbl (%edx),%ebx
80104974:	84 c0                	test   %al,%al
80104976:	75 e8                	jne    80104960 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104978:	29 d8                	sub    %ebx,%eax
}
8010497a:	5b                   	pop    %ebx
8010497b:	5e                   	pop    %esi
8010497c:	5d                   	pop    %ebp
8010497d:	c3                   	ret    
8010497e:	66 90                	xchg   %ax,%ax
80104980:	5b                   	pop    %ebx
    return 0;
80104981:	31 c0                	xor    %eax,%eax
}
80104983:	5e                   	pop    %esi
80104984:	5d                   	pop    %ebp
80104985:	c3                   	ret    
80104986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498d:	8d 76 00             	lea    0x0(%esi),%esi

80104990 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	8b 75 08             	mov    0x8(%ebp),%esi
80104998:	53                   	push   %ebx
80104999:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010499c:	89 f0                	mov    %esi,%eax
8010499e:	eb 15                	jmp    801049b5 <strncpy+0x25>
801049a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049a7:	83 c0 01             	add    $0x1,%eax
801049aa:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801049ae:	88 50 ff             	mov    %dl,-0x1(%eax)
801049b1:	84 d2                	test   %dl,%dl
801049b3:	74 09                	je     801049be <strncpy+0x2e>
801049b5:	89 cb                	mov    %ecx,%ebx
801049b7:	83 e9 01             	sub    $0x1,%ecx
801049ba:	85 db                	test   %ebx,%ebx
801049bc:	7f e2                	jg     801049a0 <strncpy+0x10>
    ;
  while(n-- > 0)
801049be:	89 c2                	mov    %eax,%edx
801049c0:	85 c9                	test   %ecx,%ecx
801049c2:	7e 17                	jle    801049db <strncpy+0x4b>
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801049c8:	83 c2 01             	add    $0x1,%edx
801049cb:	89 c1                	mov    %eax,%ecx
801049cd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801049d1:	29 d1                	sub    %edx,%ecx
801049d3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801049d7:	85 c9                	test   %ecx,%ecx
801049d9:	7f ed                	jg     801049c8 <strncpy+0x38>
  return os;
}
801049db:	5b                   	pop    %ebx
801049dc:	89 f0                	mov    %esi,%eax
801049de:	5e                   	pop    %esi
801049df:	5f                   	pop    %edi
801049e0:	5d                   	pop    %ebp
801049e1:	c3                   	ret    
801049e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	8b 55 10             	mov    0x10(%ebp),%edx
801049f7:	8b 75 08             	mov    0x8(%ebp),%esi
801049fa:	53                   	push   %ebx
801049fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801049fe:	85 d2                	test   %edx,%edx
80104a00:	7e 25                	jle    80104a27 <safestrcpy+0x37>
80104a02:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a06:	89 f2                	mov    %esi,%edx
80104a08:	eb 16                	jmp    80104a20 <safestrcpy+0x30>
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a10:	0f b6 08             	movzbl (%eax),%ecx
80104a13:	83 c0 01             	add    $0x1,%eax
80104a16:	83 c2 01             	add    $0x1,%edx
80104a19:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a1c:	84 c9                	test   %cl,%cl
80104a1e:	74 04                	je     80104a24 <safestrcpy+0x34>
80104a20:	39 d8                	cmp    %ebx,%eax
80104a22:	75 ec                	jne    80104a10 <safestrcpy+0x20>
    ;
  *s = 0;
80104a24:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a27:	89 f0                	mov    %esi,%eax
80104a29:	5b                   	pop    %ebx
80104a2a:	5e                   	pop    %esi
80104a2b:	5d                   	pop    %ebp
80104a2c:	c3                   	ret    
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi

80104a30 <strlen>:

int
strlen(const char *s)
{
80104a30:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a31:	31 c0                	xor    %eax,%eax
{
80104a33:	89 e5                	mov    %esp,%ebp
80104a35:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a38:	80 3a 00             	cmpb   $0x0,(%edx)
80104a3b:	74 0c                	je     80104a49 <strlen+0x19>
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	83 c0 01             	add    $0x1,%eax
80104a43:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a47:	75 f7                	jne    80104a40 <strlen+0x10>
    ;
  return n;
}
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret    

80104a4b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a4b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a4f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a53:	55                   	push   %ebp
  pushl %ebx
80104a54:	53                   	push   %ebx
  pushl %esi
80104a55:	56                   	push   %esi
  pushl %edi
80104a56:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a57:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a59:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a5b:	5f                   	pop    %edi
  popl %esi
80104a5c:	5e                   	pop    %esi
  popl %ebx
80104a5d:	5b                   	pop    %ebx
  popl %ebp
80104a5e:	5d                   	pop    %ebp
  ret
80104a5f:	c3                   	ret    

80104a60 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 04             	sub    $0x4,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a6a:	e8 71 f0 ff ff       	call   80103ae0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a6f:	8b 00                	mov    (%eax),%eax
80104a71:	39 d8                	cmp    %ebx,%eax
80104a73:	76 1b                	jbe    80104a90 <fetchint+0x30>
80104a75:	8d 53 04             	lea    0x4(%ebx),%edx
80104a78:	39 d0                	cmp    %edx,%eax
80104a7a:	72 14                	jb     80104a90 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a7f:	8b 13                	mov    (%ebx),%edx
80104a81:	89 10                	mov    %edx,(%eax)
  return 0;
80104a83:	31 c0                	xor    %eax,%eax
}
80104a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a88:	c9                   	leave  
80104a89:	c3                   	ret    
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a95:	eb ee                	jmp    80104a85 <fetchint+0x25>
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 04             	sub    $0x4,%esp
80104aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104aaa:	e8 31 f0 ff ff       	call   80103ae0 <myproc>

  if(addr >= curproc->sz)
80104aaf:	39 18                	cmp    %ebx,(%eax)
80104ab1:	76 2d                	jbe    80104ae0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ab6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ab8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104aba:	39 d3                	cmp    %edx,%ebx
80104abc:	73 22                	jae    80104ae0 <fetchstr+0x40>
80104abe:	89 d8                	mov    %ebx,%eax
80104ac0:	eb 0d                	jmp    80104acf <fetchstr+0x2f>
80104ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ac8:	83 c0 01             	add    $0x1,%eax
80104acb:	39 c2                	cmp    %eax,%edx
80104acd:	76 11                	jbe    80104ae0 <fetchstr+0x40>
    if(*s == 0)
80104acf:	80 38 00             	cmpb   $0x0,(%eax)
80104ad2:	75 f4                	jne    80104ac8 <fetchstr+0x28>
      return s - *pp;
80104ad4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad9:	c9                   	leave  
80104ada:	c3                   	ret    
80104adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104adf:	90                   	nop
80104ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104ae3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ae8:	c9                   	leave  
80104ae9:	c3                   	ret    
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104af0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104af5:	e8 e6 ef ff ff       	call   80103ae0 <myproc>
80104afa:	8b 55 08             	mov    0x8(%ebp),%edx
80104afd:	8b 40 18             	mov    0x18(%eax),%eax
80104b00:	8b 40 44             	mov    0x44(%eax),%eax
80104b03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b06:	e8 d5 ef ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b0b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b0e:	8b 00                	mov    (%eax),%eax
80104b10:	39 c6                	cmp    %eax,%esi
80104b12:	73 1c                	jae    80104b30 <argint+0x40>
80104b14:	8d 53 08             	lea    0x8(%ebx),%edx
80104b17:	39 d0                	cmp    %edx,%eax
80104b19:	72 15                	jb     80104b30 <argint+0x40>
  *ip = *(int*)(addr);
80104b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b1e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b21:	89 10                	mov    %edx,(%eax)
  return 0;
80104b23:	31 c0                	xor    %eax,%eax
}
80104b25:	5b                   	pop    %ebx
80104b26:	5e                   	pop    %esi
80104b27:	5d                   	pop    %ebp
80104b28:	c3                   	ret    
80104b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b35:	eb ee                	jmp    80104b25 <argint+0x35>
80104b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	53                   	push   %ebx
80104b46:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b49:	e8 92 ef ff ff       	call   80103ae0 <myproc>
80104b4e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b50:	e8 8b ef ff ff       	call   80103ae0 <myproc>
80104b55:	8b 55 08             	mov    0x8(%ebp),%edx
80104b58:	8b 40 18             	mov    0x18(%eax),%eax
80104b5b:	8b 40 44             	mov    0x44(%eax),%eax
80104b5e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b61:	e8 7a ef ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b66:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b69:	8b 00                	mov    (%eax),%eax
80104b6b:	39 c7                	cmp    %eax,%edi
80104b6d:	73 31                	jae    80104ba0 <argptr+0x60>
80104b6f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b72:	39 c8                	cmp    %ecx,%eax
80104b74:	72 2a                	jb     80104ba0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b76:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b79:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b7c:	85 d2                	test   %edx,%edx
80104b7e:	78 20                	js     80104ba0 <argptr+0x60>
80104b80:	8b 16                	mov    (%esi),%edx
80104b82:	39 c2                	cmp    %eax,%edx
80104b84:	76 1a                	jbe    80104ba0 <argptr+0x60>
80104b86:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b89:	01 c3                	add    %eax,%ebx
80104b8b:	39 da                	cmp    %ebx,%edx
80104b8d:	72 11                	jb     80104ba0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b92:	89 02                	mov    %eax,(%edx)
  return 0;
80104b94:	31 c0                	xor    %eax,%eax
}
80104b96:	83 c4 0c             	add    $0xc,%esp
80104b99:	5b                   	pop    %ebx
80104b9a:	5e                   	pop    %esi
80104b9b:	5f                   	pop    %edi
80104b9c:	5d                   	pop    %ebp
80104b9d:	c3                   	ret    
80104b9e:	66 90                	xchg   %ax,%ax
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba5:	eb ef                	jmp    80104b96 <argptr+0x56>
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bb5:	e8 26 ef ff ff       	call   80103ae0 <myproc>
80104bba:	8b 55 08             	mov    0x8(%ebp),%edx
80104bbd:	8b 40 18             	mov    0x18(%eax),%eax
80104bc0:	8b 40 44             	mov    0x44(%eax),%eax
80104bc3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bc6:	e8 15 ef ff ff       	call   80103ae0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bcb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bce:	8b 00                	mov    (%eax),%eax
80104bd0:	39 c6                	cmp    %eax,%esi
80104bd2:	73 44                	jae    80104c18 <argstr+0x68>
80104bd4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bd7:	39 d0                	cmp    %edx,%eax
80104bd9:	72 3d                	jb     80104c18 <argstr+0x68>
  *ip = *(int*)(addr);
80104bdb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104bde:	e8 fd ee ff ff       	call   80103ae0 <myproc>
  if(addr >= curproc->sz)
80104be3:	3b 18                	cmp    (%eax),%ebx
80104be5:	73 31                	jae    80104c18 <argstr+0x68>
  *pp = (char*)addr;
80104be7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bee:	39 d3                	cmp    %edx,%ebx
80104bf0:	73 26                	jae    80104c18 <argstr+0x68>
80104bf2:	89 d8                	mov    %ebx,%eax
80104bf4:	eb 11                	jmp    80104c07 <argstr+0x57>
80104bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi
80104c00:	83 c0 01             	add    $0x1,%eax
80104c03:	39 c2                	cmp    %eax,%edx
80104c05:	76 11                	jbe    80104c18 <argstr+0x68>
    if(*s == 0)
80104c07:	80 38 00             	cmpb   $0x0,(%eax)
80104c0a:	75 f4                	jne    80104c00 <argstr+0x50>
      return s - *pp;
80104c0c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c0e:	5b                   	pop    %ebx
80104c0f:	5e                   	pop    %esi
80104c10:	5d                   	pop    %ebp
80104c11:	c3                   	ret    
80104c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c18:	5b                   	pop    %ebx
    return -1;
80104c19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c1e:	5e                   	pop    %esi
80104c1f:	5d                   	pop    %ebp
80104c20:	c3                   	ret    
80104c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop

80104c30 <syscall>:
[SYS_getpgdirinfo]  sys_getpgdirinfo,
};

void
syscall(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c37:	e8 a4 ee ff ff       	call   80103ae0 <myproc>
80104c3c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c3e:	8b 40 18             	mov    0x18(%eax),%eax
80104c41:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c44:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c47:	83 fa 19             	cmp    $0x19,%edx
80104c4a:	77 24                	ja     80104c70 <syscall+0x40>
80104c4c:	8b 14 85 00 91 10 80 	mov    -0x7fef6f00(,%eax,4),%edx
80104c53:	85 d2                	test   %edx,%edx
80104c55:	74 19                	je     80104c70 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c57:	ff d2                	call   *%edx
80104c59:	89 c2                	mov    %eax,%edx
80104c5b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c5e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c64:	c9                   	leave  
80104c65:	c3                   	ret    
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c70:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c71:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c74:	50                   	push   %eax
80104c75:	ff 73 10             	push   0x10(%ebx)
80104c78:	68 c5 90 10 80       	push   $0x801090c5
80104c7d:	e8 1e ba ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104c82:	8b 43 18             	mov    0x18(%ebx),%eax
80104c85:	83 c4 10             	add    $0x10,%esp
80104c88:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c92:	c9                   	leave  
80104c93:	c3                   	ret    
80104c94:	66 90                	xchg   %ax,%ax
80104c96:	66 90                	xchg   %ax,%ax
80104c98:	66 90                	xchg   %ax,%ax
80104c9a:	66 90                	xchg   %ax,%ax
80104c9c:	66 90                	xchg   %ax,%ax
80104c9e:	66 90                	xchg   %ax,%ax

80104ca0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	57                   	push   %edi
80104ca4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ca5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ca8:	53                   	push   %ebx
80104ca9:	83 ec 34             	sub    $0x34,%esp
80104cac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104caf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104cb2:	57                   	push   %edi
80104cb3:	50                   	push   %eax
{
80104cb4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104cb7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cba:	e8 01 d4 ff ff       	call   801020c0 <nameiparent>
80104cbf:	83 c4 10             	add    $0x10,%esp
80104cc2:	85 c0                	test   %eax,%eax
80104cc4:	0f 84 46 01 00 00    	je     80104e10 <create+0x170>
    return 0;
  ilock(dp);
80104cca:	83 ec 0c             	sub    $0xc,%esp
80104ccd:	89 c3                	mov    %eax,%ebx
80104ccf:	50                   	push   %eax
80104cd0:	e8 ab ca ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cd5:	83 c4 0c             	add    $0xc,%esp
80104cd8:	6a 00                	push   $0x0
80104cda:	57                   	push   %edi
80104cdb:	53                   	push   %ebx
80104cdc:	e8 ff cf ff ff       	call   80101ce0 <dirlookup>
80104ce1:	83 c4 10             	add    $0x10,%esp
80104ce4:	89 c6                	mov    %eax,%esi
80104ce6:	85 c0                	test   %eax,%eax
80104ce8:	74 56                	je     80104d40 <create+0xa0>
    iunlockput(dp);
80104cea:	83 ec 0c             	sub    $0xc,%esp
80104ced:	53                   	push   %ebx
80104cee:	e8 1d cd ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104cf3:	89 34 24             	mov    %esi,(%esp)
80104cf6:	e8 85 ca ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104cfb:	83 c4 10             	add    $0x10,%esp
80104cfe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d03:	75 1b                	jne    80104d20 <create+0x80>
80104d05:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d0a:	75 14                	jne    80104d20 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d0f:	89 f0                	mov    %esi,%eax
80104d11:	5b                   	pop    %ebx
80104d12:	5e                   	pop    %esi
80104d13:	5f                   	pop    %edi
80104d14:	5d                   	pop    %ebp
80104d15:	c3                   	ret    
80104d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d20:	83 ec 0c             	sub    $0xc,%esp
80104d23:	56                   	push   %esi
    return 0;
80104d24:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d26:	e8 e5 cc ff ff       	call   80101a10 <iunlockput>
    return 0;
80104d2b:	83 c4 10             	add    $0x10,%esp
}
80104d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d31:	89 f0                	mov    %esi,%eax
80104d33:	5b                   	pop    %ebx
80104d34:	5e                   	pop    %esi
80104d35:	5f                   	pop    %edi
80104d36:	5d                   	pop    %ebp
80104d37:	c3                   	ret    
80104d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d40:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d44:	83 ec 08             	sub    $0x8,%esp
80104d47:	50                   	push   %eax
80104d48:	ff 33                	push   (%ebx)
80104d4a:	e8 c1 c8 ff ff       	call   80101610 <ialloc>
80104d4f:	83 c4 10             	add    $0x10,%esp
80104d52:	89 c6                	mov    %eax,%esi
80104d54:	85 c0                	test   %eax,%eax
80104d56:	0f 84 cd 00 00 00    	je     80104e29 <create+0x189>
  ilock(ip);
80104d5c:	83 ec 0c             	sub    $0xc,%esp
80104d5f:	50                   	push   %eax
80104d60:	e8 1b ca ff ff       	call   80101780 <ilock>
  ip->major = major;
80104d65:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d69:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d6d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d71:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d75:	b8 01 00 00 00       	mov    $0x1,%eax
80104d7a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d7e:	89 34 24             	mov    %esi,(%esp)
80104d81:	e8 4a c9 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d86:	83 c4 10             	add    $0x10,%esp
80104d89:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d8e:	74 30                	je     80104dc0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d90:	83 ec 04             	sub    $0x4,%esp
80104d93:	ff 76 04             	push   0x4(%esi)
80104d96:	57                   	push   %edi
80104d97:	53                   	push   %ebx
80104d98:	e8 43 d2 ff ff       	call   80101fe0 <dirlink>
80104d9d:	83 c4 10             	add    $0x10,%esp
80104da0:	85 c0                	test   %eax,%eax
80104da2:	78 78                	js     80104e1c <create+0x17c>
  iunlockput(dp);
80104da4:	83 ec 0c             	sub    $0xc,%esp
80104da7:	53                   	push   %ebx
80104da8:	e8 63 cc ff ff       	call   80101a10 <iunlockput>
  return ip;
80104dad:	83 c4 10             	add    $0x10,%esp
}
80104db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104db3:	89 f0                	mov    %esi,%eax
80104db5:	5b                   	pop    %ebx
80104db6:	5e                   	pop    %esi
80104db7:	5f                   	pop    %edi
80104db8:	5d                   	pop    %ebp
80104db9:	c3                   	ret    
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104dc0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104dc3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104dc8:	53                   	push   %ebx
80104dc9:	e8 02 c9 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dce:	83 c4 0c             	add    $0xc,%esp
80104dd1:	ff 76 04             	push   0x4(%esi)
80104dd4:	68 88 91 10 80       	push   $0x80109188
80104dd9:	56                   	push   %esi
80104dda:	e8 01 d2 ff ff       	call   80101fe0 <dirlink>
80104ddf:	83 c4 10             	add    $0x10,%esp
80104de2:	85 c0                	test   %eax,%eax
80104de4:	78 18                	js     80104dfe <create+0x15e>
80104de6:	83 ec 04             	sub    $0x4,%esp
80104de9:	ff 73 04             	push   0x4(%ebx)
80104dec:	68 87 91 10 80       	push   $0x80109187
80104df1:	56                   	push   %esi
80104df2:	e8 e9 d1 ff ff       	call   80101fe0 <dirlink>
80104df7:	83 c4 10             	add    $0x10,%esp
80104dfa:	85 c0                	test   %eax,%eax
80104dfc:	79 92                	jns    80104d90 <create+0xf0>
      panic("create dots");
80104dfe:	83 ec 0c             	sub    $0xc,%esp
80104e01:	68 7b 91 10 80       	push   $0x8010917b
80104e06:	e8 75 b5 ff ff       	call   80100380 <panic>
80104e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e0f:	90                   	nop
}
80104e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e13:	31 f6                	xor    %esi,%esi
}
80104e15:	5b                   	pop    %ebx
80104e16:	89 f0                	mov    %esi,%eax
80104e18:	5e                   	pop    %esi
80104e19:	5f                   	pop    %edi
80104e1a:	5d                   	pop    %ebp
80104e1b:	c3                   	ret    
    panic("create: dirlink");
80104e1c:	83 ec 0c             	sub    $0xc,%esp
80104e1f:	68 8a 91 10 80       	push   $0x8010918a
80104e24:	e8 57 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e29:	83 ec 0c             	sub    $0xc,%esp
80104e2c:	68 6c 91 10 80       	push   $0x8010916c
80104e31:	e8 4a b5 ff ff       	call   80100380 <panic>
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi

80104e40 <argfd>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e45:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e48:	83 ec 18             	sub    $0x18,%esp
80104e4b:	8b 75 0c             	mov    0xc(%ebp),%esi
80104e4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if(argint(n, &fd) < 0)
80104e51:	50                   	push   %eax
80104e52:	ff 75 08             	push   0x8(%ebp)
80104e55:	e8 96 fc ff ff       	call   80104af0 <argint>
80104e5a:	83 c4 10             	add    $0x10,%esp
80104e5d:	85 c0                	test   %eax,%eax
80104e5f:	78 2f                	js     80104e90 <argfd+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e61:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e65:	77 29                	ja     80104e90 <argfd+0x50>
80104e67:	e8 74 ec ff ff       	call   80103ae0 <myproc>
80104e6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e6f:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104e73:	85 c0                	test   %eax,%eax
80104e75:	74 19                	je     80104e90 <argfd+0x50>
  if(pfd)
80104e77:	85 f6                	test   %esi,%esi
80104e79:	74 02                	je     80104e7d <argfd+0x3d>
    *pfd = fd;
80104e7b:	89 16                	mov    %edx,(%esi)
  return 0;
80104e7d:	31 d2                	xor    %edx,%edx
  if(pf)
80104e7f:	85 db                	test   %ebx,%ebx
80104e81:	74 02                	je     80104e85 <argfd+0x45>
    *pf = f;
80104e83:	89 03                	mov    %eax,(%ebx)
}
80104e85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e88:	89 d0                	mov    %edx,%eax
80104e8a:	5b                   	pop    %ebx
80104e8b:	5e                   	pop    %esi
80104e8c:	5d                   	pop    %ebp
80104e8d:	c3                   	ret    
80104e8e:	66 90                	xchg   %ax,%ax
    return -1;
80104e90:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80104e95:	eb ee                	jmp    80104e85 <argfd+0x45>
80104e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <sys_dup>:
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ea5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ea8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eab:	50                   	push   %eax
80104eac:	6a 00                	push   $0x0
80104eae:	e8 3d fc ff ff       	call   80104af0 <argint>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	78 36                	js     80104ef0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ebe:	77 30                	ja     80104ef0 <sys_dup+0x50>
80104ec0:	e8 1b ec ff ff       	call   80103ae0 <myproc>
80104ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ec8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104ecc:	85 f6                	test   %esi,%esi
80104ece:	74 20                	je     80104ef0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104ed0:	e8 0b ec ff ff       	call   80103ae0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ed5:	31 db                	xor    %ebx,%ebx
80104ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ede:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ee0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ee4:	85 d2                	test   %edx,%edx
80104ee6:	74 18                	je     80104f00 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ee8:	83 c3 01             	add    $0x1,%ebx
80104eeb:	83 fb 10             	cmp    $0x10,%ebx
80104eee:	75 f0                	jne    80104ee0 <sys_dup+0x40>
}
80104ef0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ef3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ef8:	89 d8                	mov    %ebx,%eax
80104efa:	5b                   	pop    %ebx
80104efb:	5e                   	pop    %esi
80104efc:	5d                   	pop    %ebp
80104efd:	c3                   	ret    
80104efe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f00:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f03:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f07:	56                   	push   %esi
80104f08:	e8 93 bf ff ff       	call   80100ea0 <filedup>
  return fd;
80104f0d:	83 c4 10             	add    $0x10,%esp
}
80104f10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f13:	89 d8                	mov    %ebx,%eax
80104f15:	5b                   	pop    %ebx
80104f16:	5e                   	pop    %esi
80104f17:	5d                   	pop    %ebp
80104f18:	c3                   	ret    
80104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f20 <sys_read>:
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f25:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2b:	53                   	push   %ebx
80104f2c:	6a 00                	push   $0x0
80104f2e:	e8 bd fb ff ff       	call   80104af0 <argint>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 5e                	js     80104f98 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f3e:	77 58                	ja     80104f98 <sys_read+0x78>
80104f40:	e8 9b eb ff ff       	call   80103ae0 <myproc>
80104f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f48:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f4c:	85 f6                	test   %esi,%esi
80104f4e:	74 48                	je     80104f98 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f50:	83 ec 08             	sub    $0x8,%esp
80104f53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f56:	50                   	push   %eax
80104f57:	6a 02                	push   $0x2
80104f59:	e8 92 fb ff ff       	call   80104af0 <argint>
80104f5e:	83 c4 10             	add    $0x10,%esp
80104f61:	85 c0                	test   %eax,%eax
80104f63:	78 33                	js     80104f98 <sys_read+0x78>
80104f65:	83 ec 04             	sub    $0x4,%esp
80104f68:	ff 75 f0             	push   -0x10(%ebp)
80104f6b:	53                   	push   %ebx
80104f6c:	6a 01                	push   $0x1
80104f6e:	e8 cd fb ff ff       	call   80104b40 <argptr>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 1e                	js     80104f98 <sys_read+0x78>
  return fileread(f, p, n);
80104f7a:	83 ec 04             	sub    $0x4,%esp
80104f7d:	ff 75 f0             	push   -0x10(%ebp)
80104f80:	ff 75 f4             	push   -0xc(%ebp)
80104f83:	56                   	push   %esi
80104f84:	e8 97 c0 ff ff       	call   80101020 <fileread>
80104f89:	83 c4 10             	add    $0x10,%esp
}
80104f8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f8f:	5b                   	pop    %ebx
80104f90:	5e                   	pop    %esi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f97:	90                   	nop
    return -1;
80104f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f9d:	eb ed                	jmp    80104f8c <sys_read+0x6c>
80104f9f:	90                   	nop

80104fa0 <sys_write>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	53                   	push   %ebx
80104fac:	6a 00                	push   $0x0
80104fae:	e8 3d fb ff ff       	call   80104af0 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 5e                	js     80105018 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 58                	ja     80105018 <sys_write+0x78>
80104fc0:	e8 1b eb ff ff       	call   80103ae0 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 48                	je     80105018 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd0:	83 ec 08             	sub    $0x8,%esp
80104fd3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd6:	50                   	push   %eax
80104fd7:	6a 02                	push   $0x2
80104fd9:	e8 12 fb ff ff       	call   80104af0 <argint>
80104fde:	83 c4 10             	add    $0x10,%esp
80104fe1:	85 c0                	test   %eax,%eax
80104fe3:	78 33                	js     80105018 <sys_write+0x78>
80104fe5:	83 ec 04             	sub    $0x4,%esp
80104fe8:	ff 75 f0             	push   -0x10(%ebp)
80104feb:	53                   	push   %ebx
80104fec:	6a 01                	push   $0x1
80104fee:	e8 4d fb ff ff       	call   80104b40 <argptr>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 1e                	js     80105018 <sys_write+0x78>
  return filewrite(f, p, n);
80104ffa:	83 ec 04             	sub    $0x4,%esp
80104ffd:	ff 75 f0             	push   -0x10(%ebp)
80105000:	ff 75 f4             	push   -0xc(%ebp)
80105003:	56                   	push   %esi
80105004:	e8 a7 c0 ff ff       	call   801010b0 <filewrite>
80105009:	83 c4 10             	add    $0x10,%esp
}
8010500c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010500f:	5b                   	pop    %ebx
80105010:	5e                   	pop    %esi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret    
80105013:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105017:	90                   	nop
    return -1;
80105018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501d:	eb ed                	jmp    8010500c <sys_write+0x6c>
8010501f:	90                   	nop

80105020 <sys_close>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	50                   	push   %eax
8010502c:	6a 00                	push   $0x0
8010502e:	e8 bd fa ff ff       	call   80104af0 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 3e                	js     80105078 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 38                	ja     80105078 <sys_close+0x58>
80105040:	e8 9b ea ff ff       	call   80103ae0 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8d 5a 08             	lea    0x8(%edx),%ebx
8010504b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010504f:	85 f6                	test   %esi,%esi
80105051:	74 25                	je     80105078 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105053:	e8 88 ea ff ff       	call   80103ae0 <myproc>
  fileclose(f);
80105058:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010505b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105062:	00 
  fileclose(f);
80105063:	56                   	push   %esi
80105064:	e8 87 be ff ff       	call   80100ef0 <fileclose>
  return 0;
80105069:	83 c4 10             	add    $0x10,%esp
8010506c:	31 c0                	xor    %eax,%eax
}
8010506e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105071:	5b                   	pop    %ebx
80105072:	5e                   	pop    %esi
80105073:	5d                   	pop    %ebp
80105074:	c3                   	ret    
80105075:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507d:	eb ef                	jmp    8010506e <sys_close+0x4e>
8010507f:	90                   	nop

80105080 <sys_fstat>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105085:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105088:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010508b:	53                   	push   %ebx
8010508c:	6a 00                	push   $0x0
8010508e:	e8 5d fa ff ff       	call   80104af0 <argint>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	78 46                	js     801050e0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010509a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010509e:	77 40                	ja     801050e0 <sys_fstat+0x60>
801050a0:	e8 3b ea ff ff       	call   80103ae0 <myproc>
801050a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050ac:	85 f6                	test   %esi,%esi
801050ae:	74 30                	je     801050e0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050b0:	83 ec 04             	sub    $0x4,%esp
801050b3:	6a 14                	push   $0x14
801050b5:	53                   	push   %ebx
801050b6:	6a 01                	push   $0x1
801050b8:	e8 83 fa ff ff       	call   80104b40 <argptr>
801050bd:	83 c4 10             	add    $0x10,%esp
801050c0:	85 c0                	test   %eax,%eax
801050c2:	78 1c                	js     801050e0 <sys_fstat+0x60>
  return filestat(f, st);
801050c4:	83 ec 08             	sub    $0x8,%esp
801050c7:	ff 75 f4             	push   -0xc(%ebp)
801050ca:	56                   	push   %esi
801050cb:	e8 00 bf ff ff       	call   80100fd0 <filestat>
801050d0:	83 c4 10             	add    $0x10,%esp
}
801050d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050d6:	5b                   	pop    %ebx
801050d7:	5e                   	pop    %esi
801050d8:	5d                   	pop    %ebp
801050d9:	c3                   	ret    
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050e5:	eb ec                	jmp    801050d3 <sys_fstat+0x53>
801050e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ee:	66 90                	xchg   %ax,%ax

801050f0 <sys_link>:
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	57                   	push   %edi
801050f4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050f8:	53                   	push   %ebx
801050f9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050fc:	50                   	push   %eax
801050fd:	6a 00                	push   $0x0
801050ff:	e8 ac fa ff ff       	call   80104bb0 <argstr>
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	85 c0                	test   %eax,%eax
80105109:	0f 88 fb 00 00 00    	js     8010520a <sys_link+0x11a>
8010510f:	83 ec 08             	sub    $0x8,%esp
80105112:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105115:	50                   	push   %eax
80105116:	6a 01                	push   $0x1
80105118:	e8 93 fa ff ff       	call   80104bb0 <argstr>
8010511d:	83 c4 10             	add    $0x10,%esp
80105120:	85 c0                	test   %eax,%eax
80105122:	0f 88 e2 00 00 00    	js     8010520a <sys_link+0x11a>
  begin_op();
80105128:	e8 93 dd ff ff       	call   80102ec0 <begin_op>
  if((ip = namei(old)) == 0){
8010512d:	83 ec 0c             	sub    $0xc,%esp
80105130:	ff 75 d4             	push   -0x2c(%ebp)
80105133:	e8 68 cf ff ff       	call   801020a0 <namei>
80105138:	83 c4 10             	add    $0x10,%esp
8010513b:	89 c3                	mov    %eax,%ebx
8010513d:	85 c0                	test   %eax,%eax
8010513f:	0f 84 e4 00 00 00    	je     80105229 <sys_link+0x139>
  ilock(ip);
80105145:	83 ec 0c             	sub    $0xc,%esp
80105148:	50                   	push   %eax
80105149:	e8 32 c6 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010514e:	83 c4 10             	add    $0x10,%esp
80105151:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105156:	0f 84 b5 00 00 00    	je     80105211 <sys_link+0x121>
  iupdate(ip);
8010515c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010515f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105164:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105167:	53                   	push   %ebx
80105168:	e8 63 c5 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010516d:	89 1c 24             	mov    %ebx,(%esp)
80105170:	e8 eb c6 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105175:	58                   	pop    %eax
80105176:	5a                   	pop    %edx
80105177:	57                   	push   %edi
80105178:	ff 75 d0             	push   -0x30(%ebp)
8010517b:	e8 40 cf ff ff       	call   801020c0 <nameiparent>
80105180:	83 c4 10             	add    $0x10,%esp
80105183:	89 c6                	mov    %eax,%esi
80105185:	85 c0                	test   %eax,%eax
80105187:	74 5b                	je     801051e4 <sys_link+0xf4>
  ilock(dp);
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	50                   	push   %eax
8010518d:	e8 ee c5 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105192:	8b 03                	mov    (%ebx),%eax
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	39 06                	cmp    %eax,(%esi)
80105199:	75 3d                	jne    801051d8 <sys_link+0xe8>
8010519b:	83 ec 04             	sub    $0x4,%esp
8010519e:	ff 73 04             	push   0x4(%ebx)
801051a1:	57                   	push   %edi
801051a2:	56                   	push   %esi
801051a3:	e8 38 ce ff ff       	call   80101fe0 <dirlink>
801051a8:	83 c4 10             	add    $0x10,%esp
801051ab:	85 c0                	test   %eax,%eax
801051ad:	78 29                	js     801051d8 <sys_link+0xe8>
  iunlockput(dp);
801051af:	83 ec 0c             	sub    $0xc,%esp
801051b2:	56                   	push   %esi
801051b3:	e8 58 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
801051b8:	89 1c 24             	mov    %ebx,(%esp)
801051bb:	e8 f0 c6 ff ff       	call   801018b0 <iput>
  end_op();
801051c0:	e8 6b dd ff ff       	call   80102f30 <end_op>
  return 0;
801051c5:	83 c4 10             	add    $0x10,%esp
801051c8:	31 c0                	xor    %eax,%eax
}
801051ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051cd:	5b                   	pop    %ebx
801051ce:	5e                   	pop    %esi
801051cf:	5f                   	pop    %edi
801051d0:	5d                   	pop    %ebp
801051d1:	c3                   	ret    
801051d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801051d8:	83 ec 0c             	sub    $0xc,%esp
801051db:	56                   	push   %esi
801051dc:	e8 2f c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051e1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051e4:	83 ec 0c             	sub    $0xc,%esp
801051e7:	53                   	push   %ebx
801051e8:	e8 93 c5 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801051ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051f2:	89 1c 24             	mov    %ebx,(%esp)
801051f5:	e8 d6 c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801051fa:	89 1c 24             	mov    %ebx,(%esp)
801051fd:	e8 0e c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105202:	e8 29 dd ff ff       	call   80102f30 <end_op>
  return -1;
80105207:	83 c4 10             	add    $0x10,%esp
8010520a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520f:	eb b9                	jmp    801051ca <sys_link+0xda>
    iunlockput(ip);
80105211:	83 ec 0c             	sub    $0xc,%esp
80105214:	53                   	push   %ebx
80105215:	e8 f6 c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010521a:	e8 11 dd ff ff       	call   80102f30 <end_op>
    return -1;
8010521f:	83 c4 10             	add    $0x10,%esp
80105222:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105227:	eb a1                	jmp    801051ca <sys_link+0xda>
    end_op();
80105229:	e8 02 dd ff ff       	call   80102f30 <end_op>
    return -1;
8010522e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105233:	eb 95                	jmp    801051ca <sys_link+0xda>
80105235:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010523c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105240 <sys_unlink>:
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	57                   	push   %edi
80105244:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105245:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105248:	53                   	push   %ebx
80105249:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010524c:	50                   	push   %eax
8010524d:	6a 00                	push   $0x0
8010524f:	e8 5c f9 ff ff       	call   80104bb0 <argstr>
80105254:	83 c4 10             	add    $0x10,%esp
80105257:	85 c0                	test   %eax,%eax
80105259:	0f 88 7a 01 00 00    	js     801053d9 <sys_unlink+0x199>
  begin_op();
8010525f:	e8 5c dc ff ff       	call   80102ec0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105264:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105267:	83 ec 08             	sub    $0x8,%esp
8010526a:	53                   	push   %ebx
8010526b:	ff 75 c0             	push   -0x40(%ebp)
8010526e:	e8 4d ce ff ff       	call   801020c0 <nameiparent>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105279:	85 c0                	test   %eax,%eax
8010527b:	0f 84 62 01 00 00    	je     801053e3 <sys_unlink+0x1a3>
  ilock(dp);
80105281:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105284:	83 ec 0c             	sub    $0xc,%esp
80105287:	57                   	push   %edi
80105288:	e8 f3 c4 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010528d:	58                   	pop    %eax
8010528e:	5a                   	pop    %edx
8010528f:	68 88 91 10 80       	push   $0x80109188
80105294:	53                   	push   %ebx
80105295:	e8 26 ca ff ff       	call   80101cc0 <namecmp>
8010529a:	83 c4 10             	add    $0x10,%esp
8010529d:	85 c0                	test   %eax,%eax
8010529f:	0f 84 fb 00 00 00    	je     801053a0 <sys_unlink+0x160>
801052a5:	83 ec 08             	sub    $0x8,%esp
801052a8:	68 87 91 10 80       	push   $0x80109187
801052ad:	53                   	push   %ebx
801052ae:	e8 0d ca ff ff       	call   80101cc0 <namecmp>
801052b3:	83 c4 10             	add    $0x10,%esp
801052b6:	85 c0                	test   %eax,%eax
801052b8:	0f 84 e2 00 00 00    	je     801053a0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801052be:	83 ec 04             	sub    $0x4,%esp
801052c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052c4:	50                   	push   %eax
801052c5:	53                   	push   %ebx
801052c6:	57                   	push   %edi
801052c7:	e8 14 ca ff ff       	call   80101ce0 <dirlookup>
801052cc:	83 c4 10             	add    $0x10,%esp
801052cf:	89 c3                	mov    %eax,%ebx
801052d1:	85 c0                	test   %eax,%eax
801052d3:	0f 84 c7 00 00 00    	je     801053a0 <sys_unlink+0x160>
  ilock(ip);
801052d9:	83 ec 0c             	sub    $0xc,%esp
801052dc:	50                   	push   %eax
801052dd:	e8 9e c4 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801052e2:	83 c4 10             	add    $0x10,%esp
801052e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052ea:	0f 8e 1c 01 00 00    	jle    8010540c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052f8:	74 66                	je     80105360 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052fa:	83 ec 04             	sub    $0x4,%esp
801052fd:	6a 10                	push   $0x10
801052ff:	6a 00                	push   $0x0
80105301:	57                   	push   %edi
80105302:	e8 29 f5 ff ff       	call   80104830 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105307:	6a 10                	push   $0x10
80105309:	ff 75 c4             	push   -0x3c(%ebp)
8010530c:	57                   	push   %edi
8010530d:	ff 75 b4             	push   -0x4c(%ebp)
80105310:	e8 7b c8 ff ff       	call   80101b90 <writei>
80105315:	83 c4 20             	add    $0x20,%esp
80105318:	83 f8 10             	cmp    $0x10,%eax
8010531b:	0f 85 de 00 00 00    	jne    801053ff <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105321:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105326:	0f 84 94 00 00 00    	je     801053c0 <sys_unlink+0x180>
  iunlockput(dp);
8010532c:	83 ec 0c             	sub    $0xc,%esp
8010532f:	ff 75 b4             	push   -0x4c(%ebp)
80105332:	e8 d9 c6 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105337:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010533c:	89 1c 24             	mov    %ebx,(%esp)
8010533f:	e8 8c c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105344:	89 1c 24             	mov    %ebx,(%esp)
80105347:	e8 c4 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010534c:	e8 df db ff ff       	call   80102f30 <end_op>
  return 0;
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	31 c0                	xor    %eax,%eax
}
80105356:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105359:	5b                   	pop    %ebx
8010535a:	5e                   	pop    %esi
8010535b:	5f                   	pop    %edi
8010535c:	5d                   	pop    %ebp
8010535d:	c3                   	ret    
8010535e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105360:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105364:	76 94                	jbe    801052fa <sys_unlink+0xba>
80105366:	be 20 00 00 00       	mov    $0x20,%esi
8010536b:	eb 0b                	jmp    80105378 <sys_unlink+0x138>
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
80105370:	83 c6 10             	add    $0x10,%esi
80105373:	3b 73 58             	cmp    0x58(%ebx),%esi
80105376:	73 82                	jae    801052fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105378:	6a 10                	push   $0x10
8010537a:	56                   	push   %esi
8010537b:	57                   	push   %edi
8010537c:	53                   	push   %ebx
8010537d:	e8 0e c7 ff ff       	call   80101a90 <readi>
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	83 f8 10             	cmp    $0x10,%eax
80105388:	75 68                	jne    801053f2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010538a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010538f:	74 df                	je     80105370 <sys_unlink+0x130>
    iunlockput(ip);
80105391:	83 ec 0c             	sub    $0xc,%esp
80105394:	53                   	push   %ebx
80105395:	e8 76 c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010539a:	83 c4 10             	add    $0x10,%esp
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	ff 75 b4             	push   -0x4c(%ebp)
801053a6:	e8 65 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053ab:	e8 80 db ff ff       	call   80102f30 <end_op>
  return -1;
801053b0:	83 c4 10             	add    $0x10,%esp
801053b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b8:	eb 9c                	jmp    80105356 <sys_unlink+0x116>
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801053c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801053c3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801053c6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801053cb:	50                   	push   %eax
801053cc:	e8 ff c2 ff ff       	call   801016d0 <iupdate>
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	e9 53 ff ff ff       	jmp    8010532c <sys_unlink+0xec>
    return -1;
801053d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053de:	e9 73 ff ff ff       	jmp    80105356 <sys_unlink+0x116>
    end_op();
801053e3:	e8 48 db ff ff       	call   80102f30 <end_op>
    return -1;
801053e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ed:	e9 64 ff ff ff       	jmp    80105356 <sys_unlink+0x116>
      panic("isdirempty: readi");
801053f2:	83 ec 0c             	sub    $0xc,%esp
801053f5:	68 ac 91 10 80       	push   $0x801091ac
801053fa:	e8 81 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053ff:	83 ec 0c             	sub    $0xc,%esp
80105402:	68 be 91 10 80       	push   $0x801091be
80105407:	e8 74 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010540c:	83 ec 0c             	sub    $0xc,%esp
8010540f:	68 9a 91 10 80       	push   $0x8010919a
80105414:	e8 67 af ff ff       	call   80100380 <panic>
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105420 <sys_open>:

int
sys_open(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	57                   	push   %edi
80105424:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105425:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105428:	53                   	push   %ebx
80105429:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010542c:	50                   	push   %eax
8010542d:	6a 00                	push   $0x0
8010542f:	e8 7c f7 ff ff       	call   80104bb0 <argstr>
80105434:	83 c4 10             	add    $0x10,%esp
80105437:	85 c0                	test   %eax,%eax
80105439:	0f 88 8e 00 00 00    	js     801054cd <sys_open+0xad>
8010543f:	83 ec 08             	sub    $0x8,%esp
80105442:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105445:	50                   	push   %eax
80105446:	6a 01                	push   $0x1
80105448:	e8 a3 f6 ff ff       	call   80104af0 <argint>
8010544d:	83 c4 10             	add    $0x10,%esp
80105450:	85 c0                	test   %eax,%eax
80105452:	78 79                	js     801054cd <sys_open+0xad>
    return -1;

  begin_op();
80105454:	e8 67 da ff ff       	call   80102ec0 <begin_op>

  if(omode & O_CREATE){
80105459:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010545d:	75 79                	jne    801054d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010545f:	83 ec 0c             	sub    $0xc,%esp
80105462:	ff 75 e0             	push   -0x20(%ebp)
80105465:	e8 36 cc ff ff       	call   801020a0 <namei>
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	89 c6                	mov    %eax,%esi
8010546f:	85 c0                	test   %eax,%eax
80105471:	0f 84 7e 00 00 00    	je     801054f5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105477:	83 ec 0c             	sub    $0xc,%esp
8010547a:	50                   	push   %eax
8010547b:	e8 00 c3 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105480:	83 c4 10             	add    $0x10,%esp
80105483:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105488:	0f 84 c2 00 00 00    	je     80105550 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010548e:	e8 9d b9 ff ff       	call   80100e30 <filealloc>
80105493:	89 c7                	mov    %eax,%edi
80105495:	85 c0                	test   %eax,%eax
80105497:	74 23                	je     801054bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105499:	e8 42 e6 ff ff       	call   80103ae0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010549e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054a4:	85 d2                	test   %edx,%edx
801054a6:	74 60                	je     80105508 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801054a8:	83 c3 01             	add    $0x1,%ebx
801054ab:	83 fb 10             	cmp    $0x10,%ebx
801054ae:	75 f0                	jne    801054a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	57                   	push   %edi
801054b4:	e8 37 ba ff ff       	call   80100ef0 <fileclose>
801054b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801054bc:	83 ec 0c             	sub    $0xc,%esp
801054bf:	56                   	push   %esi
801054c0:	e8 4b c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
801054c5:	e8 66 da ff ff       	call   80102f30 <end_op>
    return -1;
801054ca:	83 c4 10             	add    $0x10,%esp
801054cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054d2:	eb 6d                	jmp    80105541 <sys_open+0x121>
801054d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054de:	31 c9                	xor    %ecx,%ecx
801054e0:	ba 02 00 00 00       	mov    $0x2,%edx
801054e5:	6a 00                	push   $0x0
801054e7:	e8 b4 f7 ff ff       	call   80104ca0 <create>
    if(ip == 0){
801054ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054f1:	85 c0                	test   %eax,%eax
801054f3:	75 99                	jne    8010548e <sys_open+0x6e>
      end_op();
801054f5:	e8 36 da ff ff       	call   80102f30 <end_op>
      return -1;
801054fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054ff:	eb 40                	jmp    80105541 <sys_open+0x121>
80105501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105508:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010550b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010550f:	56                   	push   %esi
80105510:	e8 4b c3 ff ff       	call   80101860 <iunlock>
  end_op();
80105515:	e8 16 da ff ff       	call   80102f30 <end_op>

  f->type = FD_INODE;
8010551a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105520:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105523:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105526:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105529:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010552b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105532:	f7 d0                	not    %eax
80105534:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105537:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010553a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010553d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105541:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105544:	89 d8                	mov    %ebx,%eax
80105546:	5b                   	pop    %ebx
80105547:	5e                   	pop    %esi
80105548:	5f                   	pop    %edi
80105549:	5d                   	pop    %ebp
8010554a:	c3                   	ret    
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105550:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105553:	85 c9                	test   %ecx,%ecx
80105555:	0f 84 33 ff ff ff    	je     8010548e <sys_open+0x6e>
8010555b:	e9 5c ff ff ff       	jmp    801054bc <sys_open+0x9c>

80105560 <sys_mkdir>:

int
sys_mkdir(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105566:	e8 55 d9 ff ff       	call   80102ec0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010556b:	83 ec 08             	sub    $0x8,%esp
8010556e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105571:	50                   	push   %eax
80105572:	6a 00                	push   $0x0
80105574:	e8 37 f6 ff ff       	call   80104bb0 <argstr>
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	85 c0                	test   %eax,%eax
8010557e:	78 30                	js     801055b0 <sys_mkdir+0x50>
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105586:	31 c9                	xor    %ecx,%ecx
80105588:	ba 01 00 00 00       	mov    $0x1,%edx
8010558d:	6a 00                	push   $0x0
8010558f:	e8 0c f7 ff ff       	call   80104ca0 <create>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	74 15                	je     801055b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010559b:	83 ec 0c             	sub    $0xc,%esp
8010559e:	50                   	push   %eax
8010559f:	e8 6c c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
801055a4:	e8 87 d9 ff ff       	call   80102f30 <end_op>
  return 0;
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	31 c0                	xor    %eax,%eax
}
801055ae:	c9                   	leave  
801055af:	c3                   	ret    
    end_op();
801055b0:	e8 7b d9 ff ff       	call   80102f30 <end_op>
    return -1;
801055b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ba:	c9                   	leave  
801055bb:	c3                   	ret    
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_mknod>:

int
sys_mknod(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801055c6:	e8 f5 d8 ff ff       	call   80102ec0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801055cb:	83 ec 08             	sub    $0x8,%esp
801055ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055d1:	50                   	push   %eax
801055d2:	6a 00                	push   $0x0
801055d4:	e8 d7 f5 ff ff       	call   80104bb0 <argstr>
801055d9:	83 c4 10             	add    $0x10,%esp
801055dc:	85 c0                	test   %eax,%eax
801055de:	78 60                	js     80105640 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055e0:	83 ec 08             	sub    $0x8,%esp
801055e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e6:	50                   	push   %eax
801055e7:	6a 01                	push   $0x1
801055e9:	e8 02 f5 ff ff       	call   80104af0 <argint>
  if((argstr(0, &path)) < 0 ||
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 4b                	js     80105640 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055f5:	83 ec 08             	sub    $0x8,%esp
801055f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055fb:	50                   	push   %eax
801055fc:	6a 02                	push   $0x2
801055fe:	e8 ed f4 ff ff       	call   80104af0 <argint>
     argint(1, &major) < 0 ||
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	85 c0                	test   %eax,%eax
80105608:	78 36                	js     80105640 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010560a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010560e:	83 ec 0c             	sub    $0xc,%esp
80105611:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105615:	ba 03 00 00 00       	mov    $0x3,%edx
8010561a:	50                   	push   %eax
8010561b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010561e:	e8 7d f6 ff ff       	call   80104ca0 <create>
     argint(2, &minor) < 0 ||
80105623:	83 c4 10             	add    $0x10,%esp
80105626:	85 c0                	test   %eax,%eax
80105628:	74 16                	je     80105640 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010562a:	83 ec 0c             	sub    $0xc,%esp
8010562d:	50                   	push   %eax
8010562e:	e8 dd c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105633:	e8 f8 d8 ff ff       	call   80102f30 <end_op>
  return 0;
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	31 c0                	xor    %eax,%eax
}
8010563d:	c9                   	leave  
8010563e:	c3                   	ret    
8010563f:	90                   	nop
    end_op();
80105640:	e8 eb d8 ff ff       	call   80102f30 <end_op>
    return -1;
80105645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_chdir>:

int
sys_chdir(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	56                   	push   %esi
80105654:	53                   	push   %ebx
80105655:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105658:	e8 83 e4 ff ff       	call   80103ae0 <myproc>
8010565d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010565f:	e8 5c d8 ff ff       	call   80102ec0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105664:	83 ec 08             	sub    $0x8,%esp
80105667:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566a:	50                   	push   %eax
8010566b:	6a 00                	push   $0x0
8010566d:	e8 3e f5 ff ff       	call   80104bb0 <argstr>
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	85 c0                	test   %eax,%eax
80105677:	78 77                	js     801056f0 <sys_chdir+0xa0>
80105679:	83 ec 0c             	sub    $0xc,%esp
8010567c:	ff 75 f4             	push   -0xc(%ebp)
8010567f:	e8 1c ca ff ff       	call   801020a0 <namei>
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	89 c3                	mov    %eax,%ebx
80105689:	85 c0                	test   %eax,%eax
8010568b:	74 63                	je     801056f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010568d:	83 ec 0c             	sub    $0xc,%esp
80105690:	50                   	push   %eax
80105691:	e8 ea c0 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105696:	83 c4 10             	add    $0x10,%esp
80105699:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010569e:	75 30                	jne    801056d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	53                   	push   %ebx
801056a4:	e8 b7 c1 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
801056a9:	58                   	pop    %eax
801056aa:	ff 76 68             	push   0x68(%esi)
801056ad:	e8 fe c1 ff ff       	call   801018b0 <iput>
  end_op();
801056b2:	e8 79 d8 ff ff       	call   80102f30 <end_op>
  curproc->cwd = ip;
801056b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	31 c0                	xor    %eax,%eax
}
801056bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056c2:	5b                   	pop    %ebx
801056c3:	5e                   	pop    %esi
801056c4:	5d                   	pop    %ebp
801056c5:	c3                   	ret    
801056c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	53                   	push   %ebx
801056d4:	e8 37 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
801056d9:	e8 52 d8 ff ff       	call   80102f30 <end_op>
    return -1;
801056de:	83 c4 10             	add    $0x10,%esp
801056e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e6:	eb d7                	jmp    801056bf <sys_chdir+0x6f>
801056e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop
    end_op();
801056f0:	e8 3b d8 ff ff       	call   80102f30 <end_op>
    return -1;
801056f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fa:	eb c3                	jmp    801056bf <sys_chdir+0x6f>
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_exec>:

int
sys_exec(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105705:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010570b:	53                   	push   %ebx
8010570c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105712:	50                   	push   %eax
80105713:	6a 00                	push   $0x0
80105715:	e8 96 f4 ff ff       	call   80104bb0 <argstr>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	85 c0                	test   %eax,%eax
8010571f:	0f 88 87 00 00 00    	js     801057ac <sys_exec+0xac>
80105725:	83 ec 08             	sub    $0x8,%esp
80105728:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010572e:	50                   	push   %eax
8010572f:	6a 01                	push   $0x1
80105731:	e8 ba f3 ff ff       	call   80104af0 <argint>
80105736:	83 c4 10             	add    $0x10,%esp
80105739:	85 c0                	test   %eax,%eax
8010573b:	78 6f                	js     801057ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010573d:	83 ec 04             	sub    $0x4,%esp
80105740:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105746:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105748:	68 80 00 00 00       	push   $0x80
8010574d:	6a 00                	push   $0x0
8010574f:	56                   	push   %esi
80105750:	e8 db f0 ff ff       	call   80104830 <memset>
80105755:	83 c4 10             	add    $0x10,%esp
80105758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105760:	83 ec 08             	sub    $0x8,%esp
80105763:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105769:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105770:	50                   	push   %eax
80105771:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105777:	01 f8                	add    %edi,%eax
80105779:	50                   	push   %eax
8010577a:	e8 e1 f2 ff ff       	call   80104a60 <fetchint>
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	85 c0                	test   %eax,%eax
80105784:	78 26                	js     801057ac <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105786:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010578c:	85 c0                	test   %eax,%eax
8010578e:	74 30                	je     801057c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105790:	83 ec 08             	sub    $0x8,%esp
80105793:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105796:	52                   	push   %edx
80105797:	50                   	push   %eax
80105798:	e8 03 f3 ff ff       	call   80104aa0 <fetchstr>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 08                	js     801057ac <sys_exec+0xac>
  for(i=0;; i++){
801057a4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057a7:	83 fb 20             	cmp    $0x20,%ebx
801057aa:	75 b4                	jne    80105760 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057b4:	5b                   	pop    %ebx
801057b5:	5e                   	pop    %esi
801057b6:	5f                   	pop    %edi
801057b7:	5d                   	pop    %ebp
801057b8:	c3                   	ret    
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801057c0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057c7:	00 00 00 00 
  return exec(path, argv);
801057cb:	83 ec 08             	sub    $0x8,%esp
801057ce:	56                   	push   %esi
801057cf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801057d5:	e8 d6 b2 ff ff       	call   80100ab0 <exec>
801057da:	83 c4 10             	add    $0x10,%esp
}
801057dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057e0:	5b                   	pop    %ebx
801057e1:	5e                   	pop    %esi
801057e2:	5f                   	pop    %edi
801057e3:	5d                   	pop    %ebp
801057e4:	c3                   	ret    
801057e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_pipe>:

int
sys_pipe(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057f8:	53                   	push   %ebx
801057f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057fc:	6a 08                	push   $0x8
801057fe:	50                   	push   %eax
801057ff:	6a 00                	push   $0x0
80105801:	e8 3a f3 ff ff       	call   80104b40 <argptr>
80105806:	83 c4 10             	add    $0x10,%esp
80105809:	85 c0                	test   %eax,%eax
8010580b:	78 4a                	js     80105857 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010580d:	83 ec 08             	sub    $0x8,%esp
80105810:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105813:	50                   	push   %eax
80105814:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105817:	50                   	push   %eax
80105818:	e8 73 dd ff ff       	call   80103590 <pipealloc>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	78 33                	js     80105857 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105824:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105827:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105829:	e8 b2 e2 ff ff       	call   80103ae0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010582e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105830:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105834:	85 f6                	test   %esi,%esi
80105836:	74 28                	je     80105860 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105838:	83 c3 01             	add    $0x1,%ebx
8010583b:	83 fb 10             	cmp    $0x10,%ebx
8010583e:	75 f0                	jne    80105830 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	ff 75 e0             	push   -0x20(%ebp)
80105846:	e8 a5 b6 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010584b:	58                   	pop    %eax
8010584c:	ff 75 e4             	push   -0x1c(%ebp)
8010584f:	e8 9c b6 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585c:	eb 53                	jmp    801058b1 <sys_pipe+0xc1>
8010585e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105860:	8d 73 08             	lea    0x8(%ebx),%esi
80105863:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105867:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010586a:	e8 71 e2 ff ff       	call   80103ae0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010586f:	31 d2                	xor    %edx,%edx
80105871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105878:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010587c:	85 c9                	test   %ecx,%ecx
8010587e:	74 20                	je     801058a0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105880:	83 c2 01             	add    $0x1,%edx
80105883:	83 fa 10             	cmp    $0x10,%edx
80105886:	75 f0                	jne    80105878 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105888:	e8 53 e2 ff ff       	call   80103ae0 <myproc>
8010588d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105894:	00 
80105895:	eb a9                	jmp    80105840 <sys_pipe+0x50>
80105897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801058a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058af:	31 c0                	xor    %eax,%eax
}
801058b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058b4:	5b                   	pop    %ebx
801058b5:	5e                   	pop    %esi
801058b6:	5f                   	pop    %edi
801058b7:	5d                   	pop    %ebp
801058b8:	c3                   	ret    
801058b9:	66 90                	xchg   %ax,%ax
801058bb:	66 90                	xchg   %ax,%ax
801058bd:	66 90                	xchg   %ax,%ax
801058bf:	90                   	nop

801058c0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801058c0:	e9 bb e3 ff ff       	jmp    80103c80 <fork>
801058c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_exit>:
}

int
sys_exit(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801058d6:	e8 55 e6 ff ff       	call   80103f30 <exit>
  return 0;  // not reached
}
801058db:	31 c0                	xor    %eax,%eax
801058dd:	c9                   	leave  
801058de:	c3                   	ret    
801058df:	90                   	nop

801058e0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058e0:	e9 ab e7 ff ff       	jmp    80104090 <wait>
801058e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058f0 <sys_kill>:
}

int
sys_kill(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058f9:	50                   	push   %eax
801058fa:	6a 00                	push   $0x0
801058fc:	e8 ef f1 ff ff       	call   80104af0 <argint>
80105901:	83 c4 10             	add    $0x10,%esp
80105904:	85 c0                	test   %eax,%eax
80105906:	78 18                	js     80105920 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105908:	83 ec 0c             	sub    $0xc,%esp
8010590b:	ff 75 f4             	push   -0xc(%ebp)
8010590e:	e8 1d ea ff ff       	call   80104330 <kill>
80105913:	83 c4 10             	add    $0x10,%esp
}
80105916:	c9                   	leave  
80105917:	c3                   	ret    
80105918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591f:	90                   	nop
80105920:	c9                   	leave  
    return -1;
80105921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105926:	c3                   	ret    
80105927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592e:	66 90                	xchg   %ax,%ax

80105930 <sys_getpid>:

int
sys_getpid(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105936:	e8 a5 e1 ff ff       	call   80103ae0 <myproc>
8010593b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010593e:	c9                   	leave  
8010593f:	c3                   	ret    

80105940 <sys_sbrk>:

int
sys_sbrk(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105944:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105947:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010594a:	50                   	push   %eax
8010594b:	6a 00                	push   $0x0
8010594d:	e8 9e f1 ff ff       	call   80104af0 <argint>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 27                	js     80105980 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105959:	e8 82 e1 ff ff       	call   80103ae0 <myproc>
  if(growproc(n) < 0)
8010595e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105961:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105963:	ff 75 f4             	push   -0xc(%ebp)
80105966:	e8 95 e2 ff ff       	call   80103c00 <growproc>
8010596b:	83 c4 10             	add    $0x10,%esp
8010596e:	85 c0                	test   %eax,%eax
80105970:	78 0e                	js     80105980 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105972:	89 d8                	mov    %ebx,%eax
80105974:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105977:	c9                   	leave  
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105980:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105985:	eb eb                	jmp    80105972 <sys_sbrk+0x32>
80105987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598e:	66 90                	xchg   %ax,%ax

80105990 <sys_sleep>:

int
sys_sleep(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105994:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105997:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010599a:	50                   	push   %eax
8010599b:	6a 00                	push   $0x0
8010599d:	e8 4e f1 ff ff       	call   80104af0 <argint>
801059a2:	83 c4 10             	add    $0x10,%esp
801059a5:	85 c0                	test   %eax,%eax
801059a7:	0f 88 8a 00 00 00    	js     80105a37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059ad:	83 ec 0c             	sub    $0xc,%esp
801059b0:	68 80 9e 13 80       	push   $0x80139e80
801059b5:	e8 b6 ed ff ff       	call   80104770 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801059ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801059bd:	8b 1d 60 9e 13 80    	mov    0x80139e60,%ebx
  while(ticks - ticks0 < n){
801059c3:	83 c4 10             	add    $0x10,%esp
801059c6:	85 d2                	test   %edx,%edx
801059c8:	75 27                	jne    801059f1 <sys_sleep+0x61>
801059ca:	eb 54                	jmp    80105a20 <sys_sleep+0x90>
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801059d0:	83 ec 08             	sub    $0x8,%esp
801059d3:	68 80 9e 13 80       	push   $0x80139e80
801059d8:	68 60 9e 13 80       	push   $0x80139e60
801059dd:	e8 2e e8 ff ff       	call   80104210 <sleep>
  while(ticks - ticks0 < n){
801059e2:	a1 60 9e 13 80       	mov    0x80139e60,%eax
801059e7:	83 c4 10             	add    $0x10,%esp
801059ea:	29 d8                	sub    %ebx,%eax
801059ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059ef:	73 2f                	jae    80105a20 <sys_sleep+0x90>
    if(myproc()->killed){
801059f1:	e8 ea e0 ff ff       	call   80103ae0 <myproc>
801059f6:	8b 40 24             	mov    0x24(%eax),%eax
801059f9:	85 c0                	test   %eax,%eax
801059fb:	74 d3                	je     801059d0 <sys_sleep+0x40>
      release(&tickslock);
801059fd:	83 ec 0c             	sub    $0xc,%esp
80105a00:	68 80 9e 13 80       	push   $0x80139e80
80105a05:	e8 06 ed ff ff       	call   80104710 <release>
  }
  release(&tickslock);
  return 0;
}
80105a0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a15:	c9                   	leave  
80105a16:	c3                   	ret    
80105a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	68 80 9e 13 80       	push   $0x80139e80
80105a28:	e8 e3 ec ff ff       	call   80104710 <release>
  return 0;
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	31 c0                	xor    %eax,%eax
}
80105a32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a35:	c9                   	leave  
80105a36:	c3                   	ret    
    return -1;
80105a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3c:	eb f4                	jmp    80105a32 <sys_sleep+0xa2>
80105a3e:	66 90                	xchg   %ax,%ax

80105a40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	53                   	push   %ebx
80105a44:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a47:	68 80 9e 13 80       	push   $0x80139e80
80105a4c:	e8 1f ed ff ff       	call   80104770 <acquire>
  xticks = ticks;
80105a51:	8b 1d 60 9e 13 80    	mov    0x80139e60,%ebx
  release(&tickslock);
80105a57:	c7 04 24 80 9e 13 80 	movl   $0x80139e80,(%esp)
80105a5e:	e8 ad ec ff ff       	call   80104710 <release>
  return xticks;
}
80105a63:	89 d8                	mov    %ebx,%eax
80105a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a68:	c9                   	leave  
80105a69:	c3                   	ret    

80105a6a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a6a:	1e                   	push   %ds
  pushl %es
80105a6b:	06                   	push   %es
  pushl %fs
80105a6c:	0f a0                	push   %fs
  pushl %gs
80105a6e:	0f a8                	push   %gs
  pushal
80105a70:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a71:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a75:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a77:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a79:	54                   	push   %esp
  call trap
80105a7a:	e8 c1 00 00 00       	call   80105b40 <trap>
  addl $4, %esp
80105a7f:	83 c4 04             	add    $0x4,%esp

80105a82 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a82:	61                   	popa   
  popl %gs
80105a83:	0f a9                	pop    %gs
  popl %fs
80105a85:	0f a1                	pop    %fs
  popl %es
80105a87:	07                   	pop    %es
  popl %ds
80105a88:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a89:	83 c4 08             	add    $0x8,%esp
  iret
80105a8c:	cf                   	iret   
80105a8d:	66 90                	xchg   %ax,%ax
80105a8f:	90                   	nop

80105a90 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a90:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a91:	31 c0                	xor    %eax,%eax
{
80105a93:	89 e5                	mov    %esp,%ebp
80105a95:	83 ec 08             	sub    $0x8,%esp
80105a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105aa0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80105aa7:	c7 04 c5 c2 9e 13 80 	movl   $0x8e000008,-0x7fec613e(,%eax,8)
80105aae:	08 00 00 8e 
80105ab2:	66 89 14 c5 c0 9e 13 	mov    %dx,-0x7fec6140(,%eax,8)
80105ab9:	80 
80105aba:	c1 ea 10             	shr    $0x10,%edx
80105abd:	66 89 14 c5 c6 9e 13 	mov    %dx,-0x7fec613a(,%eax,8)
80105ac4:	80 
  for(i = 0; i < 256; i++)
80105ac5:	83 c0 01             	add    $0x1,%eax
80105ac8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105acd:	75 d1                	jne    80105aa0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105acf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ad2:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80105ad7:	c7 05 c2 a0 13 80 08 	movl   $0xef000008,0x8013a0c2
80105ade:	00 00 ef 
  initlock(&tickslock, "time");
80105ae1:	68 cd 91 10 80       	push   $0x801091cd
80105ae6:	68 80 9e 13 80       	push   $0x80139e80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105aeb:	66 a3 c0 a0 13 80    	mov    %ax,0x8013a0c0
80105af1:	c1 e8 10             	shr    $0x10,%eax
80105af4:	66 a3 c6 a0 13 80    	mov    %ax,0x8013a0c6
  initlock(&tickslock, "time");
80105afa:	e8 a1 ea ff ff       	call   801045a0 <initlock>
}
80105aff:	83 c4 10             	add    $0x10,%esp
80105b02:	c9                   	leave  
80105b03:	c3                   	ret    
80105b04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b0f:	90                   	nop

80105b10 <idtinit>:

void
idtinit(void)
{
80105b10:	55                   	push   %ebp
  pd[0] = size-1;
80105b11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b16:	89 e5                	mov    %esp,%ebp
80105b18:	83 ec 10             	sub    $0x10,%esp
80105b1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b1f:	b8 c0 9e 13 80       	mov    $0x80139ec0,%eax
80105b24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b28:	c1 e8 10             	shr    $0x10,%eax
80105b2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b35:	c9                   	leave  
80105b36:	c3                   	ret    
80105b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3e:	66 90                	xchg   %ax,%ax

80105b40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
80105b45:	53                   	push   %ebx
80105b46:	83 ec 1c             	sub    $0x1c,%esp
80105b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b4c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b4f:	83 f8 40             	cmp    $0x40,%eax
80105b52:	0f 84 38 01 00 00    	je     80105c90 <trap+0x150>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b58:	83 e8 0e             	sub    $0xe,%eax
80105b5b:	83 f8 31             	cmp    $0x31,%eax
80105b5e:	0f 87 8c 00 00 00    	ja     80105bf0 <trap+0xb0>
80105b64:	ff 24 85 88 92 10 80 	jmp    *-0x7fef6d78(,%eax,4)
80105b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b6f:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105b70:	e8 4b df ff ff       	call   80103ac0 <cpuid>
80105b75:	85 c0                	test   %eax,%eax
80105b77:	0f 84 53 02 00 00    	je     80105dd0 <trap+0x290>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105b7d:	e8 ee ce ff ff       	call   80102a70 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b82:	e8 59 df ff ff       	call   80103ae0 <myproc>
80105b87:	85 c0                	test   %eax,%eax
80105b89:	74 1d                	je     80105ba8 <trap+0x68>
80105b8b:	e8 50 df ff ff       	call   80103ae0 <myproc>
80105b90:	8b 50 24             	mov    0x24(%eax),%edx
80105b93:	85 d2                	test   %edx,%edx
80105b95:	74 11                	je     80105ba8 <trap+0x68>
80105b97:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b9b:	83 e0 03             	and    $0x3,%eax
80105b9e:	66 83 f8 03          	cmp    $0x3,%ax
80105ba2:	0f 84 08 02 00 00    	je     80105db0 <trap+0x270>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ba8:	e8 33 df ff ff       	call   80103ae0 <myproc>
80105bad:	85 c0                	test   %eax,%eax
80105baf:	74 0f                	je     80105bc0 <trap+0x80>
80105bb1:	e8 2a df ff ff       	call   80103ae0 <myproc>
80105bb6:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105bba:	0f 84 b8 00 00 00    	je     80105c78 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bc0:	e8 1b df ff ff       	call   80103ae0 <myproc>
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	74 1d                	je     80105be6 <trap+0xa6>
80105bc9:	e8 12 df ff ff       	call   80103ae0 <myproc>
80105bce:	8b 40 24             	mov    0x24(%eax),%eax
80105bd1:	85 c0                	test   %eax,%eax
80105bd3:	74 11                	je     80105be6 <trap+0xa6>
80105bd5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bd9:	83 e0 03             	and    $0x3,%eax
80105bdc:	66 83 f8 03          	cmp    $0x3,%ax
80105be0:	0f 84 d7 00 00 00    	je     80105cbd <trap+0x17d>
    exit();
}
80105be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be9:	5b                   	pop    %ebx
80105bea:	5e                   	pop    %esi
80105beb:	5f                   	pop    %edi
80105bec:	5d                   	pop    %ebp
80105bed:	c3                   	ret    
80105bee:	66 90                	xchg   %ax,%ax
    if(myproc() == 0 || (tf->cs&3) == 0){
80105bf0:	e8 eb de ff ff       	call   80103ae0 <myproc>
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	0f 84 07 02 00 00    	je     80105e04 <trap+0x2c4>
80105bfd:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c01:	0f 84 fd 01 00 00    	je     80105e04 <trap+0x2c4>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c07:	0f 20 d1             	mov    %cr2,%ecx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c0a:	8b 53 38             	mov    0x38(%ebx),%edx
80105c0d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105c10:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105c13:	e8 a8 de ff ff       	call   80103ac0 <cpuid>
80105c18:	8b 73 30             	mov    0x30(%ebx),%esi
80105c1b:	89 c7                	mov    %eax,%edi
80105c1d:	8b 43 34             	mov    0x34(%ebx),%eax
80105c20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105c23:	e8 b8 de ff ff       	call   80103ae0 <myproc>
80105c28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c2b:	e8 b0 de ff ff       	call   80103ae0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c30:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c33:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c36:	51                   	push   %ecx
80105c37:	52                   	push   %edx
80105c38:	57                   	push   %edi
80105c39:	ff 75 e4             	push   -0x1c(%ebp)
80105c3c:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c3d:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c40:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c43:	56                   	push   %esi
80105c44:	ff 70 10             	push   0x10(%eax)
80105c47:	68 44 92 10 80       	push   $0x80109244
80105c4c:	e8 4f aa ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105c51:	83 c4 20             	add    $0x20,%esp
80105c54:	e8 87 de ff ff       	call   80103ae0 <myproc>
80105c59:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c60:	e8 7b de ff ff       	call   80103ae0 <myproc>
80105c65:	85 c0                	test   %eax,%eax
80105c67:	0f 85 1e ff ff ff    	jne    80105b8b <trap+0x4b>
80105c6d:	e9 36 ff ff ff       	jmp    80105ba8 <trap+0x68>
80105c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105c78:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c7c:	0f 85 3e ff ff ff    	jne    80105bc0 <trap+0x80>
    yield();
80105c82:	e8 39 e5 ff ff       	call   801041c0 <yield>
80105c87:	e9 34 ff ff ff       	jmp    80105bc0 <trap+0x80>
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105c90:	e8 4b de ff ff       	call   80103ae0 <myproc>
80105c95:	8b 70 24             	mov    0x24(%eax),%esi
80105c98:	85 f6                	test   %esi,%esi
80105c9a:	0f 85 20 01 00 00    	jne    80105dc0 <trap+0x280>
    myproc()->tf = tf;
80105ca0:	e8 3b de ff ff       	call   80103ae0 <myproc>
80105ca5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105ca8:	e8 83 ef ff ff       	call   80104c30 <syscall>
    if(myproc()->killed)
80105cad:	e8 2e de ff ff       	call   80103ae0 <myproc>
80105cb2:	8b 48 24             	mov    0x24(%eax),%ecx
80105cb5:	85 c9                	test   %ecx,%ecx
80105cb7:	0f 84 29 ff ff ff    	je     80105be6 <trap+0xa6>
}
80105cbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cc0:	5b                   	pop    %ebx
80105cc1:	5e                   	pop    %esi
80105cc2:	5f                   	pop    %edi
80105cc3:	5d                   	pop    %ebp
      exit();
80105cc4:	e9 67 e2 ff ff       	jmp    80103f30 <exit>
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105cd0:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cd3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105cd7:	e8 e4 dd ff ff       	call   80103ac0 <cpuid>
80105cdc:	57                   	push   %edi
80105cdd:	56                   	push   %esi
80105cde:	50                   	push   %eax
80105cdf:	68 ec 91 10 80       	push   $0x801091ec
80105ce4:	e8 b7 a9 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105ce9:	e8 82 cd ff ff       	call   80102a70 <lapiceoi>
    break;
80105cee:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cf1:	e8 ea dd ff ff       	call   80103ae0 <myproc>
80105cf6:	85 c0                	test   %eax,%eax
80105cf8:	0f 85 8d fe ff ff    	jne    80105b8b <trap+0x4b>
80105cfe:	e9 a5 fe ff ff       	jmp    80105ba8 <trap+0x68>
80105d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d07:	90                   	nop
    kbdintr();
80105d08:	e8 23 cc ff ff       	call   80102930 <kbdintr>
    lapiceoi();
80105d0d:	e8 5e cd ff ff       	call   80102a70 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d12:	e8 c9 dd ff ff       	call   80103ae0 <myproc>
80105d17:	85 c0                	test   %eax,%eax
80105d19:	0f 85 6c fe ff ff    	jne    80105b8b <trap+0x4b>
80105d1f:	e9 84 fe ff ff       	jmp    80105ba8 <trap+0x68>
80105d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d28:	e8 73 02 00 00       	call   80105fa0 <uartintr>
    lapiceoi();
80105d2d:	e8 3e cd ff ff       	call   80102a70 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d32:	e8 a9 dd ff ff       	call   80103ae0 <myproc>
80105d37:	85 c0                	test   %eax,%eax
80105d39:	0f 85 4c fe ff ff    	jne    80105b8b <trap+0x4b>
80105d3f:	e9 64 fe ff ff       	jmp    80105ba8 <trap+0x68>
80105d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105d48:	e8 f3 c4 ff ff       	call   80102240 <ideintr>
80105d4d:	e9 2b fe ff ff       	jmp    80105b7d <trap+0x3d>
80105d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d58:	e8 83 dd ff ff       	call   80103ae0 <myproc>
80105d5d:	85 c0                	test   %eax,%eax
80105d5f:	0f 84 9f 00 00 00    	je     80105e04 <trap+0x2c4>
80105d65:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d69:	0f 84 95 00 00 00    	je     80105e04 <trap+0x2c4>
80105d6f:	0f 20 d0             	mov    %cr2,%eax
    if(handle_page_fault(rcr2()) < 0){
80105d72:	83 ec 0c             	sub    $0xc,%esp
80105d75:	50                   	push   %eax
80105d76:	e8 85 27 00 00       	call   80108500 <handle_page_fault>
80105d7b:	83 c4 10             	add    $0x10,%esp
80105d7e:	85 c0                	test   %eax,%eax
80105d80:	0f 89 fc fd ff ff    	jns    80105b82 <trap+0x42>
      cprintf("Segmentation Fault\n");
80105d86:	83 ec 0c             	sub    $0xc,%esp
80105d89:	68 d7 91 10 80       	push   $0x801091d7
80105d8e:	e8 0d a9 ff ff       	call   801006a0 <cprintf>
      myproc()->killed = 1;
80105d93:	e8 48 dd ff ff       	call   80103ae0 <myproc>
80105d98:	83 c4 10             	add    $0x10,%esp
80105d9b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105da2:	e9 db fd ff ff       	jmp    80105b82 <trap+0x42>
80105da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dae:	66 90                	xchg   %ax,%ax
    exit();
80105db0:	e8 7b e1 ff ff       	call   80103f30 <exit>
80105db5:	e9 ee fd ff ff       	jmp    80105ba8 <trap+0x68>
80105dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105dc0:	e8 6b e1 ff ff       	call   80103f30 <exit>
80105dc5:	e9 d6 fe ff ff       	jmp    80105ca0 <trap+0x160>
80105dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	68 80 9e 13 80       	push   $0x80139e80
80105dd8:	e8 93 e9 ff ff       	call   80104770 <acquire>
      wakeup(&ticks);
80105ddd:	c7 04 24 60 9e 13 80 	movl   $0x80139e60,(%esp)
      ticks++;
80105de4:	83 05 60 9e 13 80 01 	addl   $0x1,0x80139e60
      wakeup(&ticks);
80105deb:	e8 e0 e4 ff ff       	call   801042d0 <wakeup>
      release(&tickslock);
80105df0:	c7 04 24 80 9e 13 80 	movl   $0x80139e80,(%esp)
80105df7:	e8 14 e9 ff ff       	call   80104710 <release>
80105dfc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105dff:	e9 79 fd ff ff       	jmp    80105b7d <trap+0x3d>
80105e04:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e07:	8b 73 38             	mov    0x38(%ebx),%esi
80105e0a:	e8 b1 dc ff ff       	call   80103ac0 <cpuid>
80105e0f:	83 ec 0c             	sub    $0xc,%esp
80105e12:	57                   	push   %edi
80105e13:	56                   	push   %esi
80105e14:	50                   	push   %eax
80105e15:	ff 73 30             	push   0x30(%ebx)
80105e18:	68 10 92 10 80       	push   $0x80109210
80105e1d:	e8 7e a8 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105e22:	83 c4 14             	add    $0x14,%esp
80105e25:	68 d2 91 10 80       	push   $0x801091d2
80105e2a:	e8 51 a5 ff ff       	call   80100380 <panic>
80105e2f:	90                   	nop

80105e30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e30:	a1 c0 a6 13 80       	mov    0x8013a6c0,%eax
80105e35:	85 c0                	test   %eax,%eax
80105e37:	74 17                	je     80105e50 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e39:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e3e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e3f:	a8 01                	test   $0x1,%al
80105e41:	74 0d                	je     80105e50 <uartgetc+0x20>
80105e43:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e48:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e49:	0f b6 c0             	movzbl %al,%eax
80105e4c:	c3                   	ret    
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e55:	c3                   	ret    
80105e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi

80105e60 <uartinit>:
{
80105e60:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e61:	31 c9                	xor    %ecx,%ecx
80105e63:	89 c8                	mov    %ecx,%eax
80105e65:	89 e5                	mov    %esp,%ebp
80105e67:	57                   	push   %edi
80105e68:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e6d:	56                   	push   %esi
80105e6e:	89 fa                	mov    %edi,%edx
80105e70:	53                   	push   %ebx
80105e71:	83 ec 1c             	sub    $0x1c,%esp
80105e74:	ee                   	out    %al,(%dx)
80105e75:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e7f:	89 f2                	mov    %esi,%edx
80105e81:	ee                   	out    %al,(%dx)
80105e82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e8c:	ee                   	out    %al,(%dx)
80105e8d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e92:	89 c8                	mov    %ecx,%eax
80105e94:	89 da                	mov    %ebx,%edx
80105e96:	ee                   	out    %al,(%dx)
80105e97:	b8 03 00 00 00       	mov    $0x3,%eax
80105e9c:	89 f2                	mov    %esi,%edx
80105e9e:	ee                   	out    %al,(%dx)
80105e9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ea4:	89 c8                	mov    %ecx,%eax
80105ea6:	ee                   	out    %al,(%dx)
80105ea7:	b8 01 00 00 00       	mov    $0x1,%eax
80105eac:	89 da                	mov    %ebx,%edx
80105eae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eaf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105eb4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105eb5:	3c ff                	cmp    $0xff,%al
80105eb7:	74 78                	je     80105f31 <uartinit+0xd1>
  uart = 1;
80105eb9:	c7 05 c0 a6 13 80 01 	movl   $0x1,0x8013a6c0
80105ec0:	00 00 00 
80105ec3:	89 fa                	mov    %edi,%edx
80105ec5:	ec                   	in     (%dx),%al
80105ec6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ecb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105ecc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105ecf:	bf 50 93 10 80       	mov    $0x80109350,%edi
80105ed4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105ed9:	6a 00                	push   $0x0
80105edb:	6a 04                	push   $0x4
80105edd:	e8 9e c5 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105ee2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105ee6:	83 c4 10             	add    $0x10,%esp
80105ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105ef0:	a1 c0 a6 13 80       	mov    0x8013a6c0,%eax
80105ef5:	bb 80 00 00 00       	mov    $0x80,%ebx
80105efa:	85 c0                	test   %eax,%eax
80105efc:	75 14                	jne    80105f12 <uartinit+0xb2>
80105efe:	eb 23                	jmp    80105f23 <uartinit+0xc3>
    microdelay(10);
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	6a 0a                	push   $0xa
80105f05:	e8 86 cb ff ff       	call   80102a90 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f0a:	83 c4 10             	add    $0x10,%esp
80105f0d:	83 eb 01             	sub    $0x1,%ebx
80105f10:	74 07                	je     80105f19 <uartinit+0xb9>
80105f12:	89 f2                	mov    %esi,%edx
80105f14:	ec                   	in     (%dx),%al
80105f15:	a8 20                	test   $0x20,%al
80105f17:	74 e7                	je     80105f00 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f19:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105f1d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f22:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105f23:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105f27:	83 c7 01             	add    $0x1,%edi
80105f2a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f2d:	84 c0                	test   %al,%al
80105f2f:	75 bf                	jne    80105ef0 <uartinit+0x90>
}
80105f31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f34:	5b                   	pop    %ebx
80105f35:	5e                   	pop    %esi
80105f36:	5f                   	pop    %edi
80105f37:	5d                   	pop    %ebp
80105f38:	c3                   	ret    
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f40 <uartputc>:
  if(!uart)
80105f40:	a1 c0 a6 13 80       	mov    0x8013a6c0,%eax
80105f45:	85 c0                	test   %eax,%eax
80105f47:	74 47                	je     80105f90 <uartputc+0x50>
{
80105f49:	55                   	push   %ebp
80105f4a:	89 e5                	mov    %esp,%ebp
80105f4c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f4d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f52:	53                   	push   %ebx
80105f53:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f58:	eb 18                	jmp    80105f72 <uartputc+0x32>
80105f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f60:	83 ec 0c             	sub    $0xc,%esp
80105f63:	6a 0a                	push   $0xa
80105f65:	e8 26 cb ff ff       	call   80102a90 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f6a:	83 c4 10             	add    $0x10,%esp
80105f6d:	83 eb 01             	sub    $0x1,%ebx
80105f70:	74 07                	je     80105f79 <uartputc+0x39>
80105f72:	89 f2                	mov    %esi,%edx
80105f74:	ec                   	in     (%dx),%al
80105f75:	a8 20                	test   $0x20,%al
80105f77:	74 e7                	je     80105f60 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f79:	8b 45 08             	mov    0x8(%ebp),%eax
80105f7c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f81:	ee                   	out    %al,(%dx)
}
80105f82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f85:	5b                   	pop    %ebx
80105f86:	5e                   	pop    %esi
80105f87:	5d                   	pop    %ebp
80105f88:	c3                   	ret    
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f90:	c3                   	ret    
80105f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9f:	90                   	nop

80105fa0 <uartintr>:

void
uartintr(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fa6:	68 30 5e 10 80       	push   $0x80105e30
80105fab:	e8 d0 a8 ff ff       	call   80100880 <consoleintr>
}
80105fb0:	83 c4 10             	add    $0x10,%esp
80105fb3:	c9                   	leave  
80105fb4:	c3                   	ret    

80105fb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $0
80105fb7:	6a 00                	push   $0x0
  jmp alltraps
80105fb9:	e9 ac fa ff ff       	jmp    80105a6a <alltraps>

80105fbe <vector1>:
.globl vector1
vector1:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $1
80105fc0:	6a 01                	push   $0x1
  jmp alltraps
80105fc2:	e9 a3 fa ff ff       	jmp    80105a6a <alltraps>

80105fc7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $2
80105fc9:	6a 02                	push   $0x2
  jmp alltraps
80105fcb:	e9 9a fa ff ff       	jmp    80105a6a <alltraps>

80105fd0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $3
80105fd2:	6a 03                	push   $0x3
  jmp alltraps
80105fd4:	e9 91 fa ff ff       	jmp    80105a6a <alltraps>

80105fd9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $4
80105fdb:	6a 04                	push   $0x4
  jmp alltraps
80105fdd:	e9 88 fa ff ff       	jmp    80105a6a <alltraps>

80105fe2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $5
80105fe4:	6a 05                	push   $0x5
  jmp alltraps
80105fe6:	e9 7f fa ff ff       	jmp    80105a6a <alltraps>

80105feb <vector6>:
.globl vector6
vector6:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $6
80105fed:	6a 06                	push   $0x6
  jmp alltraps
80105fef:	e9 76 fa ff ff       	jmp    80105a6a <alltraps>

80105ff4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $7
80105ff6:	6a 07                	push   $0x7
  jmp alltraps
80105ff8:	e9 6d fa ff ff       	jmp    80105a6a <alltraps>

80105ffd <vector8>:
.globl vector8
vector8:
  pushl $8
80105ffd:	6a 08                	push   $0x8
  jmp alltraps
80105fff:	e9 66 fa ff ff       	jmp    80105a6a <alltraps>

80106004 <vector9>:
.globl vector9
vector9:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $9
80106006:	6a 09                	push   $0x9
  jmp alltraps
80106008:	e9 5d fa ff ff       	jmp    80105a6a <alltraps>

8010600d <vector10>:
.globl vector10
vector10:
  pushl $10
8010600d:	6a 0a                	push   $0xa
  jmp alltraps
8010600f:	e9 56 fa ff ff       	jmp    80105a6a <alltraps>

80106014 <vector11>:
.globl vector11
vector11:
  pushl $11
80106014:	6a 0b                	push   $0xb
  jmp alltraps
80106016:	e9 4f fa ff ff       	jmp    80105a6a <alltraps>

8010601b <vector12>:
.globl vector12
vector12:
  pushl $12
8010601b:	6a 0c                	push   $0xc
  jmp alltraps
8010601d:	e9 48 fa ff ff       	jmp    80105a6a <alltraps>

80106022 <vector13>:
.globl vector13
vector13:
  pushl $13
80106022:	6a 0d                	push   $0xd
  jmp alltraps
80106024:	e9 41 fa ff ff       	jmp    80105a6a <alltraps>

80106029 <vector14>:
.globl vector14
vector14:
  pushl $14
80106029:	6a 0e                	push   $0xe
  jmp alltraps
8010602b:	e9 3a fa ff ff       	jmp    80105a6a <alltraps>

80106030 <vector15>:
.globl vector15
vector15:
  pushl $0
80106030:	6a 00                	push   $0x0
  pushl $15
80106032:	6a 0f                	push   $0xf
  jmp alltraps
80106034:	e9 31 fa ff ff       	jmp    80105a6a <alltraps>

80106039 <vector16>:
.globl vector16
vector16:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $16
8010603b:	6a 10                	push   $0x10
  jmp alltraps
8010603d:	e9 28 fa ff ff       	jmp    80105a6a <alltraps>

80106042 <vector17>:
.globl vector17
vector17:
  pushl $17
80106042:	6a 11                	push   $0x11
  jmp alltraps
80106044:	e9 21 fa ff ff       	jmp    80105a6a <alltraps>

80106049 <vector18>:
.globl vector18
vector18:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $18
8010604b:	6a 12                	push   $0x12
  jmp alltraps
8010604d:	e9 18 fa ff ff       	jmp    80105a6a <alltraps>

80106052 <vector19>:
.globl vector19
vector19:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $19
80106054:	6a 13                	push   $0x13
  jmp alltraps
80106056:	e9 0f fa ff ff       	jmp    80105a6a <alltraps>

8010605b <vector20>:
.globl vector20
vector20:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $20
8010605d:	6a 14                	push   $0x14
  jmp alltraps
8010605f:	e9 06 fa ff ff       	jmp    80105a6a <alltraps>

80106064 <vector21>:
.globl vector21
vector21:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $21
80106066:	6a 15                	push   $0x15
  jmp alltraps
80106068:	e9 fd f9 ff ff       	jmp    80105a6a <alltraps>

8010606d <vector22>:
.globl vector22
vector22:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $22
8010606f:	6a 16                	push   $0x16
  jmp alltraps
80106071:	e9 f4 f9 ff ff       	jmp    80105a6a <alltraps>

80106076 <vector23>:
.globl vector23
vector23:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $23
80106078:	6a 17                	push   $0x17
  jmp alltraps
8010607a:	e9 eb f9 ff ff       	jmp    80105a6a <alltraps>

8010607f <vector24>:
.globl vector24
vector24:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $24
80106081:	6a 18                	push   $0x18
  jmp alltraps
80106083:	e9 e2 f9 ff ff       	jmp    80105a6a <alltraps>

80106088 <vector25>:
.globl vector25
vector25:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $25
8010608a:	6a 19                	push   $0x19
  jmp alltraps
8010608c:	e9 d9 f9 ff ff       	jmp    80105a6a <alltraps>

80106091 <vector26>:
.globl vector26
vector26:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $26
80106093:	6a 1a                	push   $0x1a
  jmp alltraps
80106095:	e9 d0 f9 ff ff       	jmp    80105a6a <alltraps>

8010609a <vector27>:
.globl vector27
vector27:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $27
8010609c:	6a 1b                	push   $0x1b
  jmp alltraps
8010609e:	e9 c7 f9 ff ff       	jmp    80105a6a <alltraps>

801060a3 <vector28>:
.globl vector28
vector28:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $28
801060a5:	6a 1c                	push   $0x1c
  jmp alltraps
801060a7:	e9 be f9 ff ff       	jmp    80105a6a <alltraps>

801060ac <vector29>:
.globl vector29
vector29:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $29
801060ae:	6a 1d                	push   $0x1d
  jmp alltraps
801060b0:	e9 b5 f9 ff ff       	jmp    80105a6a <alltraps>

801060b5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $30
801060b7:	6a 1e                	push   $0x1e
  jmp alltraps
801060b9:	e9 ac f9 ff ff       	jmp    80105a6a <alltraps>

801060be <vector31>:
.globl vector31
vector31:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $31
801060c0:	6a 1f                	push   $0x1f
  jmp alltraps
801060c2:	e9 a3 f9 ff ff       	jmp    80105a6a <alltraps>

801060c7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $32
801060c9:	6a 20                	push   $0x20
  jmp alltraps
801060cb:	e9 9a f9 ff ff       	jmp    80105a6a <alltraps>

801060d0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $33
801060d2:	6a 21                	push   $0x21
  jmp alltraps
801060d4:	e9 91 f9 ff ff       	jmp    80105a6a <alltraps>

801060d9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $34
801060db:	6a 22                	push   $0x22
  jmp alltraps
801060dd:	e9 88 f9 ff ff       	jmp    80105a6a <alltraps>

801060e2 <vector35>:
.globl vector35
vector35:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $35
801060e4:	6a 23                	push   $0x23
  jmp alltraps
801060e6:	e9 7f f9 ff ff       	jmp    80105a6a <alltraps>

801060eb <vector36>:
.globl vector36
vector36:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $36
801060ed:	6a 24                	push   $0x24
  jmp alltraps
801060ef:	e9 76 f9 ff ff       	jmp    80105a6a <alltraps>

801060f4 <vector37>:
.globl vector37
vector37:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $37
801060f6:	6a 25                	push   $0x25
  jmp alltraps
801060f8:	e9 6d f9 ff ff       	jmp    80105a6a <alltraps>

801060fd <vector38>:
.globl vector38
vector38:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $38
801060ff:	6a 26                	push   $0x26
  jmp alltraps
80106101:	e9 64 f9 ff ff       	jmp    80105a6a <alltraps>

80106106 <vector39>:
.globl vector39
vector39:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $39
80106108:	6a 27                	push   $0x27
  jmp alltraps
8010610a:	e9 5b f9 ff ff       	jmp    80105a6a <alltraps>

8010610f <vector40>:
.globl vector40
vector40:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $40
80106111:	6a 28                	push   $0x28
  jmp alltraps
80106113:	e9 52 f9 ff ff       	jmp    80105a6a <alltraps>

80106118 <vector41>:
.globl vector41
vector41:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $41
8010611a:	6a 29                	push   $0x29
  jmp alltraps
8010611c:	e9 49 f9 ff ff       	jmp    80105a6a <alltraps>

80106121 <vector42>:
.globl vector42
vector42:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $42
80106123:	6a 2a                	push   $0x2a
  jmp alltraps
80106125:	e9 40 f9 ff ff       	jmp    80105a6a <alltraps>

8010612a <vector43>:
.globl vector43
vector43:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $43
8010612c:	6a 2b                	push   $0x2b
  jmp alltraps
8010612e:	e9 37 f9 ff ff       	jmp    80105a6a <alltraps>

80106133 <vector44>:
.globl vector44
vector44:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $44
80106135:	6a 2c                	push   $0x2c
  jmp alltraps
80106137:	e9 2e f9 ff ff       	jmp    80105a6a <alltraps>

8010613c <vector45>:
.globl vector45
vector45:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $45
8010613e:	6a 2d                	push   $0x2d
  jmp alltraps
80106140:	e9 25 f9 ff ff       	jmp    80105a6a <alltraps>

80106145 <vector46>:
.globl vector46
vector46:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $46
80106147:	6a 2e                	push   $0x2e
  jmp alltraps
80106149:	e9 1c f9 ff ff       	jmp    80105a6a <alltraps>

8010614e <vector47>:
.globl vector47
vector47:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $47
80106150:	6a 2f                	push   $0x2f
  jmp alltraps
80106152:	e9 13 f9 ff ff       	jmp    80105a6a <alltraps>

80106157 <vector48>:
.globl vector48
vector48:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $48
80106159:	6a 30                	push   $0x30
  jmp alltraps
8010615b:	e9 0a f9 ff ff       	jmp    80105a6a <alltraps>

80106160 <vector49>:
.globl vector49
vector49:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $49
80106162:	6a 31                	push   $0x31
  jmp alltraps
80106164:	e9 01 f9 ff ff       	jmp    80105a6a <alltraps>

80106169 <vector50>:
.globl vector50
vector50:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $50
8010616b:	6a 32                	push   $0x32
  jmp alltraps
8010616d:	e9 f8 f8 ff ff       	jmp    80105a6a <alltraps>

80106172 <vector51>:
.globl vector51
vector51:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $51
80106174:	6a 33                	push   $0x33
  jmp alltraps
80106176:	e9 ef f8 ff ff       	jmp    80105a6a <alltraps>

8010617b <vector52>:
.globl vector52
vector52:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $52
8010617d:	6a 34                	push   $0x34
  jmp alltraps
8010617f:	e9 e6 f8 ff ff       	jmp    80105a6a <alltraps>

80106184 <vector53>:
.globl vector53
vector53:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $53
80106186:	6a 35                	push   $0x35
  jmp alltraps
80106188:	e9 dd f8 ff ff       	jmp    80105a6a <alltraps>

8010618d <vector54>:
.globl vector54
vector54:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $54
8010618f:	6a 36                	push   $0x36
  jmp alltraps
80106191:	e9 d4 f8 ff ff       	jmp    80105a6a <alltraps>

80106196 <vector55>:
.globl vector55
vector55:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $55
80106198:	6a 37                	push   $0x37
  jmp alltraps
8010619a:	e9 cb f8 ff ff       	jmp    80105a6a <alltraps>

8010619f <vector56>:
.globl vector56
vector56:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $56
801061a1:	6a 38                	push   $0x38
  jmp alltraps
801061a3:	e9 c2 f8 ff ff       	jmp    80105a6a <alltraps>

801061a8 <vector57>:
.globl vector57
vector57:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $57
801061aa:	6a 39                	push   $0x39
  jmp alltraps
801061ac:	e9 b9 f8 ff ff       	jmp    80105a6a <alltraps>

801061b1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $58
801061b3:	6a 3a                	push   $0x3a
  jmp alltraps
801061b5:	e9 b0 f8 ff ff       	jmp    80105a6a <alltraps>

801061ba <vector59>:
.globl vector59
vector59:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $59
801061bc:	6a 3b                	push   $0x3b
  jmp alltraps
801061be:	e9 a7 f8 ff ff       	jmp    80105a6a <alltraps>

801061c3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $60
801061c5:	6a 3c                	push   $0x3c
  jmp alltraps
801061c7:	e9 9e f8 ff ff       	jmp    80105a6a <alltraps>

801061cc <vector61>:
.globl vector61
vector61:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $61
801061ce:	6a 3d                	push   $0x3d
  jmp alltraps
801061d0:	e9 95 f8 ff ff       	jmp    80105a6a <alltraps>

801061d5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $62
801061d7:	6a 3e                	push   $0x3e
  jmp alltraps
801061d9:	e9 8c f8 ff ff       	jmp    80105a6a <alltraps>

801061de <vector63>:
.globl vector63
vector63:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $63
801061e0:	6a 3f                	push   $0x3f
  jmp alltraps
801061e2:	e9 83 f8 ff ff       	jmp    80105a6a <alltraps>

801061e7 <vector64>:
.globl vector64
vector64:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $64
801061e9:	6a 40                	push   $0x40
  jmp alltraps
801061eb:	e9 7a f8 ff ff       	jmp    80105a6a <alltraps>

801061f0 <vector65>:
.globl vector65
vector65:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $65
801061f2:	6a 41                	push   $0x41
  jmp alltraps
801061f4:	e9 71 f8 ff ff       	jmp    80105a6a <alltraps>

801061f9 <vector66>:
.globl vector66
vector66:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $66
801061fb:	6a 42                	push   $0x42
  jmp alltraps
801061fd:	e9 68 f8 ff ff       	jmp    80105a6a <alltraps>

80106202 <vector67>:
.globl vector67
vector67:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $67
80106204:	6a 43                	push   $0x43
  jmp alltraps
80106206:	e9 5f f8 ff ff       	jmp    80105a6a <alltraps>

8010620b <vector68>:
.globl vector68
vector68:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $68
8010620d:	6a 44                	push   $0x44
  jmp alltraps
8010620f:	e9 56 f8 ff ff       	jmp    80105a6a <alltraps>

80106214 <vector69>:
.globl vector69
vector69:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $69
80106216:	6a 45                	push   $0x45
  jmp alltraps
80106218:	e9 4d f8 ff ff       	jmp    80105a6a <alltraps>

8010621d <vector70>:
.globl vector70
vector70:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $70
8010621f:	6a 46                	push   $0x46
  jmp alltraps
80106221:	e9 44 f8 ff ff       	jmp    80105a6a <alltraps>

80106226 <vector71>:
.globl vector71
vector71:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $71
80106228:	6a 47                	push   $0x47
  jmp alltraps
8010622a:	e9 3b f8 ff ff       	jmp    80105a6a <alltraps>

8010622f <vector72>:
.globl vector72
vector72:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $72
80106231:	6a 48                	push   $0x48
  jmp alltraps
80106233:	e9 32 f8 ff ff       	jmp    80105a6a <alltraps>

80106238 <vector73>:
.globl vector73
vector73:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $73
8010623a:	6a 49                	push   $0x49
  jmp alltraps
8010623c:	e9 29 f8 ff ff       	jmp    80105a6a <alltraps>

80106241 <vector74>:
.globl vector74
vector74:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $74
80106243:	6a 4a                	push   $0x4a
  jmp alltraps
80106245:	e9 20 f8 ff ff       	jmp    80105a6a <alltraps>

8010624a <vector75>:
.globl vector75
vector75:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $75
8010624c:	6a 4b                	push   $0x4b
  jmp alltraps
8010624e:	e9 17 f8 ff ff       	jmp    80105a6a <alltraps>

80106253 <vector76>:
.globl vector76
vector76:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $76
80106255:	6a 4c                	push   $0x4c
  jmp alltraps
80106257:	e9 0e f8 ff ff       	jmp    80105a6a <alltraps>

8010625c <vector77>:
.globl vector77
vector77:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $77
8010625e:	6a 4d                	push   $0x4d
  jmp alltraps
80106260:	e9 05 f8 ff ff       	jmp    80105a6a <alltraps>

80106265 <vector78>:
.globl vector78
vector78:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $78
80106267:	6a 4e                	push   $0x4e
  jmp alltraps
80106269:	e9 fc f7 ff ff       	jmp    80105a6a <alltraps>

8010626e <vector79>:
.globl vector79
vector79:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $79
80106270:	6a 4f                	push   $0x4f
  jmp alltraps
80106272:	e9 f3 f7 ff ff       	jmp    80105a6a <alltraps>

80106277 <vector80>:
.globl vector80
vector80:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $80
80106279:	6a 50                	push   $0x50
  jmp alltraps
8010627b:	e9 ea f7 ff ff       	jmp    80105a6a <alltraps>

80106280 <vector81>:
.globl vector81
vector81:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $81
80106282:	6a 51                	push   $0x51
  jmp alltraps
80106284:	e9 e1 f7 ff ff       	jmp    80105a6a <alltraps>

80106289 <vector82>:
.globl vector82
vector82:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $82
8010628b:	6a 52                	push   $0x52
  jmp alltraps
8010628d:	e9 d8 f7 ff ff       	jmp    80105a6a <alltraps>

80106292 <vector83>:
.globl vector83
vector83:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $83
80106294:	6a 53                	push   $0x53
  jmp alltraps
80106296:	e9 cf f7 ff ff       	jmp    80105a6a <alltraps>

8010629b <vector84>:
.globl vector84
vector84:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $84
8010629d:	6a 54                	push   $0x54
  jmp alltraps
8010629f:	e9 c6 f7 ff ff       	jmp    80105a6a <alltraps>

801062a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $85
801062a6:	6a 55                	push   $0x55
  jmp alltraps
801062a8:	e9 bd f7 ff ff       	jmp    80105a6a <alltraps>

801062ad <vector86>:
.globl vector86
vector86:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $86
801062af:	6a 56                	push   $0x56
  jmp alltraps
801062b1:	e9 b4 f7 ff ff       	jmp    80105a6a <alltraps>

801062b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $87
801062b8:	6a 57                	push   $0x57
  jmp alltraps
801062ba:	e9 ab f7 ff ff       	jmp    80105a6a <alltraps>

801062bf <vector88>:
.globl vector88
vector88:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $88
801062c1:	6a 58                	push   $0x58
  jmp alltraps
801062c3:	e9 a2 f7 ff ff       	jmp    80105a6a <alltraps>

801062c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $89
801062ca:	6a 59                	push   $0x59
  jmp alltraps
801062cc:	e9 99 f7 ff ff       	jmp    80105a6a <alltraps>

801062d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $90
801062d3:	6a 5a                	push   $0x5a
  jmp alltraps
801062d5:	e9 90 f7 ff ff       	jmp    80105a6a <alltraps>

801062da <vector91>:
.globl vector91
vector91:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $91
801062dc:	6a 5b                	push   $0x5b
  jmp alltraps
801062de:	e9 87 f7 ff ff       	jmp    80105a6a <alltraps>

801062e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $92
801062e5:	6a 5c                	push   $0x5c
  jmp alltraps
801062e7:	e9 7e f7 ff ff       	jmp    80105a6a <alltraps>

801062ec <vector93>:
.globl vector93
vector93:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $93
801062ee:	6a 5d                	push   $0x5d
  jmp alltraps
801062f0:	e9 75 f7 ff ff       	jmp    80105a6a <alltraps>

801062f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $94
801062f7:	6a 5e                	push   $0x5e
  jmp alltraps
801062f9:	e9 6c f7 ff ff       	jmp    80105a6a <alltraps>

801062fe <vector95>:
.globl vector95
vector95:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $95
80106300:	6a 5f                	push   $0x5f
  jmp alltraps
80106302:	e9 63 f7 ff ff       	jmp    80105a6a <alltraps>

80106307 <vector96>:
.globl vector96
vector96:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $96
80106309:	6a 60                	push   $0x60
  jmp alltraps
8010630b:	e9 5a f7 ff ff       	jmp    80105a6a <alltraps>

80106310 <vector97>:
.globl vector97
vector97:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $97
80106312:	6a 61                	push   $0x61
  jmp alltraps
80106314:	e9 51 f7 ff ff       	jmp    80105a6a <alltraps>

80106319 <vector98>:
.globl vector98
vector98:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $98
8010631b:	6a 62                	push   $0x62
  jmp alltraps
8010631d:	e9 48 f7 ff ff       	jmp    80105a6a <alltraps>

80106322 <vector99>:
.globl vector99
vector99:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $99
80106324:	6a 63                	push   $0x63
  jmp alltraps
80106326:	e9 3f f7 ff ff       	jmp    80105a6a <alltraps>

8010632b <vector100>:
.globl vector100
vector100:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $100
8010632d:	6a 64                	push   $0x64
  jmp alltraps
8010632f:	e9 36 f7 ff ff       	jmp    80105a6a <alltraps>

80106334 <vector101>:
.globl vector101
vector101:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $101
80106336:	6a 65                	push   $0x65
  jmp alltraps
80106338:	e9 2d f7 ff ff       	jmp    80105a6a <alltraps>

8010633d <vector102>:
.globl vector102
vector102:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $102
8010633f:	6a 66                	push   $0x66
  jmp alltraps
80106341:	e9 24 f7 ff ff       	jmp    80105a6a <alltraps>

80106346 <vector103>:
.globl vector103
vector103:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $103
80106348:	6a 67                	push   $0x67
  jmp alltraps
8010634a:	e9 1b f7 ff ff       	jmp    80105a6a <alltraps>

8010634f <vector104>:
.globl vector104
vector104:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $104
80106351:	6a 68                	push   $0x68
  jmp alltraps
80106353:	e9 12 f7 ff ff       	jmp    80105a6a <alltraps>

80106358 <vector105>:
.globl vector105
vector105:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $105
8010635a:	6a 69                	push   $0x69
  jmp alltraps
8010635c:	e9 09 f7 ff ff       	jmp    80105a6a <alltraps>

80106361 <vector106>:
.globl vector106
vector106:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $106
80106363:	6a 6a                	push   $0x6a
  jmp alltraps
80106365:	e9 00 f7 ff ff       	jmp    80105a6a <alltraps>

8010636a <vector107>:
.globl vector107
vector107:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $107
8010636c:	6a 6b                	push   $0x6b
  jmp alltraps
8010636e:	e9 f7 f6 ff ff       	jmp    80105a6a <alltraps>

80106373 <vector108>:
.globl vector108
vector108:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $108
80106375:	6a 6c                	push   $0x6c
  jmp alltraps
80106377:	e9 ee f6 ff ff       	jmp    80105a6a <alltraps>

8010637c <vector109>:
.globl vector109
vector109:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $109
8010637e:	6a 6d                	push   $0x6d
  jmp alltraps
80106380:	e9 e5 f6 ff ff       	jmp    80105a6a <alltraps>

80106385 <vector110>:
.globl vector110
vector110:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $110
80106387:	6a 6e                	push   $0x6e
  jmp alltraps
80106389:	e9 dc f6 ff ff       	jmp    80105a6a <alltraps>

8010638e <vector111>:
.globl vector111
vector111:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $111
80106390:	6a 6f                	push   $0x6f
  jmp alltraps
80106392:	e9 d3 f6 ff ff       	jmp    80105a6a <alltraps>

80106397 <vector112>:
.globl vector112
vector112:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $112
80106399:	6a 70                	push   $0x70
  jmp alltraps
8010639b:	e9 ca f6 ff ff       	jmp    80105a6a <alltraps>

801063a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $113
801063a2:	6a 71                	push   $0x71
  jmp alltraps
801063a4:	e9 c1 f6 ff ff       	jmp    80105a6a <alltraps>

801063a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $114
801063ab:	6a 72                	push   $0x72
  jmp alltraps
801063ad:	e9 b8 f6 ff ff       	jmp    80105a6a <alltraps>

801063b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $115
801063b4:	6a 73                	push   $0x73
  jmp alltraps
801063b6:	e9 af f6 ff ff       	jmp    80105a6a <alltraps>

801063bb <vector116>:
.globl vector116
vector116:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $116
801063bd:	6a 74                	push   $0x74
  jmp alltraps
801063bf:	e9 a6 f6 ff ff       	jmp    80105a6a <alltraps>

801063c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $117
801063c6:	6a 75                	push   $0x75
  jmp alltraps
801063c8:	e9 9d f6 ff ff       	jmp    80105a6a <alltraps>

801063cd <vector118>:
.globl vector118
vector118:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $118
801063cf:	6a 76                	push   $0x76
  jmp alltraps
801063d1:	e9 94 f6 ff ff       	jmp    80105a6a <alltraps>

801063d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $119
801063d8:	6a 77                	push   $0x77
  jmp alltraps
801063da:	e9 8b f6 ff ff       	jmp    80105a6a <alltraps>

801063df <vector120>:
.globl vector120
vector120:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $120
801063e1:	6a 78                	push   $0x78
  jmp alltraps
801063e3:	e9 82 f6 ff ff       	jmp    80105a6a <alltraps>

801063e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $121
801063ea:	6a 79                	push   $0x79
  jmp alltraps
801063ec:	e9 79 f6 ff ff       	jmp    80105a6a <alltraps>

801063f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $122
801063f3:	6a 7a                	push   $0x7a
  jmp alltraps
801063f5:	e9 70 f6 ff ff       	jmp    80105a6a <alltraps>

801063fa <vector123>:
.globl vector123
vector123:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $123
801063fc:	6a 7b                	push   $0x7b
  jmp alltraps
801063fe:	e9 67 f6 ff ff       	jmp    80105a6a <alltraps>

80106403 <vector124>:
.globl vector124
vector124:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $124
80106405:	6a 7c                	push   $0x7c
  jmp alltraps
80106407:	e9 5e f6 ff ff       	jmp    80105a6a <alltraps>

8010640c <vector125>:
.globl vector125
vector125:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $125
8010640e:	6a 7d                	push   $0x7d
  jmp alltraps
80106410:	e9 55 f6 ff ff       	jmp    80105a6a <alltraps>

80106415 <vector126>:
.globl vector126
vector126:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $126
80106417:	6a 7e                	push   $0x7e
  jmp alltraps
80106419:	e9 4c f6 ff ff       	jmp    80105a6a <alltraps>

8010641e <vector127>:
.globl vector127
vector127:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $127
80106420:	6a 7f                	push   $0x7f
  jmp alltraps
80106422:	e9 43 f6 ff ff       	jmp    80105a6a <alltraps>

80106427 <vector128>:
.globl vector128
vector128:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $128
80106429:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010642e:	e9 37 f6 ff ff       	jmp    80105a6a <alltraps>

80106433 <vector129>:
.globl vector129
vector129:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $129
80106435:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010643a:	e9 2b f6 ff ff       	jmp    80105a6a <alltraps>

8010643f <vector130>:
.globl vector130
vector130:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $130
80106441:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106446:	e9 1f f6 ff ff       	jmp    80105a6a <alltraps>

8010644b <vector131>:
.globl vector131
vector131:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $131
8010644d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106452:	e9 13 f6 ff ff       	jmp    80105a6a <alltraps>

80106457 <vector132>:
.globl vector132
vector132:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $132
80106459:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010645e:	e9 07 f6 ff ff       	jmp    80105a6a <alltraps>

80106463 <vector133>:
.globl vector133
vector133:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $133
80106465:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010646a:	e9 fb f5 ff ff       	jmp    80105a6a <alltraps>

8010646f <vector134>:
.globl vector134
vector134:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $134
80106471:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106476:	e9 ef f5 ff ff       	jmp    80105a6a <alltraps>

8010647b <vector135>:
.globl vector135
vector135:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $135
8010647d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106482:	e9 e3 f5 ff ff       	jmp    80105a6a <alltraps>

80106487 <vector136>:
.globl vector136
vector136:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $136
80106489:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010648e:	e9 d7 f5 ff ff       	jmp    80105a6a <alltraps>

80106493 <vector137>:
.globl vector137
vector137:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $137
80106495:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010649a:	e9 cb f5 ff ff       	jmp    80105a6a <alltraps>

8010649f <vector138>:
.globl vector138
vector138:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $138
801064a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064a6:	e9 bf f5 ff ff       	jmp    80105a6a <alltraps>

801064ab <vector139>:
.globl vector139
vector139:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $139
801064ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064b2:	e9 b3 f5 ff ff       	jmp    80105a6a <alltraps>

801064b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $140
801064b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064be:	e9 a7 f5 ff ff       	jmp    80105a6a <alltraps>

801064c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $141
801064c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064ca:	e9 9b f5 ff ff       	jmp    80105a6a <alltraps>

801064cf <vector142>:
.globl vector142
vector142:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $142
801064d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064d6:	e9 8f f5 ff ff       	jmp    80105a6a <alltraps>

801064db <vector143>:
.globl vector143
vector143:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $143
801064dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064e2:	e9 83 f5 ff ff       	jmp    80105a6a <alltraps>

801064e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $144
801064e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064ee:	e9 77 f5 ff ff       	jmp    80105a6a <alltraps>

801064f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $145
801064f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064fa:	e9 6b f5 ff ff       	jmp    80105a6a <alltraps>

801064ff <vector146>:
.globl vector146
vector146:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $146
80106501:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106506:	e9 5f f5 ff ff       	jmp    80105a6a <alltraps>

8010650b <vector147>:
.globl vector147
vector147:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $147
8010650d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106512:	e9 53 f5 ff ff       	jmp    80105a6a <alltraps>

80106517 <vector148>:
.globl vector148
vector148:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $148
80106519:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010651e:	e9 47 f5 ff ff       	jmp    80105a6a <alltraps>

80106523 <vector149>:
.globl vector149
vector149:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $149
80106525:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010652a:	e9 3b f5 ff ff       	jmp    80105a6a <alltraps>

8010652f <vector150>:
.globl vector150
vector150:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $150
80106531:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106536:	e9 2f f5 ff ff       	jmp    80105a6a <alltraps>

8010653b <vector151>:
.globl vector151
vector151:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $151
8010653d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106542:	e9 23 f5 ff ff       	jmp    80105a6a <alltraps>

80106547 <vector152>:
.globl vector152
vector152:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $152
80106549:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010654e:	e9 17 f5 ff ff       	jmp    80105a6a <alltraps>

80106553 <vector153>:
.globl vector153
vector153:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $153
80106555:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010655a:	e9 0b f5 ff ff       	jmp    80105a6a <alltraps>

8010655f <vector154>:
.globl vector154
vector154:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $154
80106561:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106566:	e9 ff f4 ff ff       	jmp    80105a6a <alltraps>

8010656b <vector155>:
.globl vector155
vector155:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $155
8010656d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106572:	e9 f3 f4 ff ff       	jmp    80105a6a <alltraps>

80106577 <vector156>:
.globl vector156
vector156:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $156
80106579:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010657e:	e9 e7 f4 ff ff       	jmp    80105a6a <alltraps>

80106583 <vector157>:
.globl vector157
vector157:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $157
80106585:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010658a:	e9 db f4 ff ff       	jmp    80105a6a <alltraps>

8010658f <vector158>:
.globl vector158
vector158:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $158
80106591:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106596:	e9 cf f4 ff ff       	jmp    80105a6a <alltraps>

8010659b <vector159>:
.globl vector159
vector159:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $159
8010659d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065a2:	e9 c3 f4 ff ff       	jmp    80105a6a <alltraps>

801065a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $160
801065a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065ae:	e9 b7 f4 ff ff       	jmp    80105a6a <alltraps>

801065b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $161
801065b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065ba:	e9 ab f4 ff ff       	jmp    80105a6a <alltraps>

801065bf <vector162>:
.globl vector162
vector162:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $162
801065c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065c6:	e9 9f f4 ff ff       	jmp    80105a6a <alltraps>

801065cb <vector163>:
.globl vector163
vector163:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $163
801065cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065d2:	e9 93 f4 ff ff       	jmp    80105a6a <alltraps>

801065d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $164
801065d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065de:	e9 87 f4 ff ff       	jmp    80105a6a <alltraps>

801065e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $165
801065e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065ea:	e9 7b f4 ff ff       	jmp    80105a6a <alltraps>

801065ef <vector166>:
.globl vector166
vector166:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $166
801065f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065f6:	e9 6f f4 ff ff       	jmp    80105a6a <alltraps>

801065fb <vector167>:
.globl vector167
vector167:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $167
801065fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106602:	e9 63 f4 ff ff       	jmp    80105a6a <alltraps>

80106607 <vector168>:
.globl vector168
vector168:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $168
80106609:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010660e:	e9 57 f4 ff ff       	jmp    80105a6a <alltraps>

80106613 <vector169>:
.globl vector169
vector169:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $169
80106615:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010661a:	e9 4b f4 ff ff       	jmp    80105a6a <alltraps>

8010661f <vector170>:
.globl vector170
vector170:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $170
80106621:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106626:	e9 3f f4 ff ff       	jmp    80105a6a <alltraps>

8010662b <vector171>:
.globl vector171
vector171:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $171
8010662d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106632:	e9 33 f4 ff ff       	jmp    80105a6a <alltraps>

80106637 <vector172>:
.globl vector172
vector172:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $172
80106639:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010663e:	e9 27 f4 ff ff       	jmp    80105a6a <alltraps>

80106643 <vector173>:
.globl vector173
vector173:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $173
80106645:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010664a:	e9 1b f4 ff ff       	jmp    80105a6a <alltraps>

8010664f <vector174>:
.globl vector174
vector174:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $174
80106651:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106656:	e9 0f f4 ff ff       	jmp    80105a6a <alltraps>

8010665b <vector175>:
.globl vector175
vector175:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $175
8010665d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106662:	e9 03 f4 ff ff       	jmp    80105a6a <alltraps>

80106667 <vector176>:
.globl vector176
vector176:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $176
80106669:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010666e:	e9 f7 f3 ff ff       	jmp    80105a6a <alltraps>

80106673 <vector177>:
.globl vector177
vector177:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $177
80106675:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010667a:	e9 eb f3 ff ff       	jmp    80105a6a <alltraps>

8010667f <vector178>:
.globl vector178
vector178:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $178
80106681:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106686:	e9 df f3 ff ff       	jmp    80105a6a <alltraps>

8010668b <vector179>:
.globl vector179
vector179:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $179
8010668d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106692:	e9 d3 f3 ff ff       	jmp    80105a6a <alltraps>

80106697 <vector180>:
.globl vector180
vector180:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $180
80106699:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010669e:	e9 c7 f3 ff ff       	jmp    80105a6a <alltraps>

801066a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $181
801066a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066aa:	e9 bb f3 ff ff       	jmp    80105a6a <alltraps>

801066af <vector182>:
.globl vector182
vector182:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $182
801066b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066b6:	e9 af f3 ff ff       	jmp    80105a6a <alltraps>

801066bb <vector183>:
.globl vector183
vector183:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $183
801066bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066c2:	e9 a3 f3 ff ff       	jmp    80105a6a <alltraps>

801066c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $184
801066c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066ce:	e9 97 f3 ff ff       	jmp    80105a6a <alltraps>

801066d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $185
801066d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066da:	e9 8b f3 ff ff       	jmp    80105a6a <alltraps>

801066df <vector186>:
.globl vector186
vector186:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $186
801066e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066e6:	e9 7f f3 ff ff       	jmp    80105a6a <alltraps>

801066eb <vector187>:
.globl vector187
vector187:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $187
801066ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066f2:	e9 73 f3 ff ff       	jmp    80105a6a <alltraps>

801066f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $188
801066f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801066fe:	e9 67 f3 ff ff       	jmp    80105a6a <alltraps>

80106703 <vector189>:
.globl vector189
vector189:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $189
80106705:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010670a:	e9 5b f3 ff ff       	jmp    80105a6a <alltraps>

8010670f <vector190>:
.globl vector190
vector190:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $190
80106711:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106716:	e9 4f f3 ff ff       	jmp    80105a6a <alltraps>

8010671b <vector191>:
.globl vector191
vector191:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $191
8010671d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106722:	e9 43 f3 ff ff       	jmp    80105a6a <alltraps>

80106727 <vector192>:
.globl vector192
vector192:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $192
80106729:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010672e:	e9 37 f3 ff ff       	jmp    80105a6a <alltraps>

80106733 <vector193>:
.globl vector193
vector193:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $193
80106735:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010673a:	e9 2b f3 ff ff       	jmp    80105a6a <alltraps>

8010673f <vector194>:
.globl vector194
vector194:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $194
80106741:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106746:	e9 1f f3 ff ff       	jmp    80105a6a <alltraps>

8010674b <vector195>:
.globl vector195
vector195:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $195
8010674d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106752:	e9 13 f3 ff ff       	jmp    80105a6a <alltraps>

80106757 <vector196>:
.globl vector196
vector196:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $196
80106759:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010675e:	e9 07 f3 ff ff       	jmp    80105a6a <alltraps>

80106763 <vector197>:
.globl vector197
vector197:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $197
80106765:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010676a:	e9 fb f2 ff ff       	jmp    80105a6a <alltraps>

8010676f <vector198>:
.globl vector198
vector198:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $198
80106771:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106776:	e9 ef f2 ff ff       	jmp    80105a6a <alltraps>

8010677b <vector199>:
.globl vector199
vector199:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $199
8010677d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106782:	e9 e3 f2 ff ff       	jmp    80105a6a <alltraps>

80106787 <vector200>:
.globl vector200
vector200:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $200
80106789:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010678e:	e9 d7 f2 ff ff       	jmp    80105a6a <alltraps>

80106793 <vector201>:
.globl vector201
vector201:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $201
80106795:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010679a:	e9 cb f2 ff ff       	jmp    80105a6a <alltraps>

8010679f <vector202>:
.globl vector202
vector202:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $202
801067a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067a6:	e9 bf f2 ff ff       	jmp    80105a6a <alltraps>

801067ab <vector203>:
.globl vector203
vector203:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $203
801067ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067b2:	e9 b3 f2 ff ff       	jmp    80105a6a <alltraps>

801067b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $204
801067b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067be:	e9 a7 f2 ff ff       	jmp    80105a6a <alltraps>

801067c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $205
801067c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067ca:	e9 9b f2 ff ff       	jmp    80105a6a <alltraps>

801067cf <vector206>:
.globl vector206
vector206:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $206
801067d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067d6:	e9 8f f2 ff ff       	jmp    80105a6a <alltraps>

801067db <vector207>:
.globl vector207
vector207:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $207
801067dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067e2:	e9 83 f2 ff ff       	jmp    80105a6a <alltraps>

801067e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $208
801067e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067ee:	e9 77 f2 ff ff       	jmp    80105a6a <alltraps>

801067f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $209
801067f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067fa:	e9 6b f2 ff ff       	jmp    80105a6a <alltraps>

801067ff <vector210>:
.globl vector210
vector210:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $210
80106801:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106806:	e9 5f f2 ff ff       	jmp    80105a6a <alltraps>

8010680b <vector211>:
.globl vector211
vector211:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $211
8010680d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106812:	e9 53 f2 ff ff       	jmp    80105a6a <alltraps>

80106817 <vector212>:
.globl vector212
vector212:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $212
80106819:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010681e:	e9 47 f2 ff ff       	jmp    80105a6a <alltraps>

80106823 <vector213>:
.globl vector213
vector213:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $213
80106825:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010682a:	e9 3b f2 ff ff       	jmp    80105a6a <alltraps>

8010682f <vector214>:
.globl vector214
vector214:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $214
80106831:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106836:	e9 2f f2 ff ff       	jmp    80105a6a <alltraps>

8010683b <vector215>:
.globl vector215
vector215:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $215
8010683d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106842:	e9 23 f2 ff ff       	jmp    80105a6a <alltraps>

80106847 <vector216>:
.globl vector216
vector216:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $216
80106849:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010684e:	e9 17 f2 ff ff       	jmp    80105a6a <alltraps>

80106853 <vector217>:
.globl vector217
vector217:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $217
80106855:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010685a:	e9 0b f2 ff ff       	jmp    80105a6a <alltraps>

8010685f <vector218>:
.globl vector218
vector218:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $218
80106861:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106866:	e9 ff f1 ff ff       	jmp    80105a6a <alltraps>

8010686b <vector219>:
.globl vector219
vector219:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $219
8010686d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106872:	e9 f3 f1 ff ff       	jmp    80105a6a <alltraps>

80106877 <vector220>:
.globl vector220
vector220:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $220
80106879:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010687e:	e9 e7 f1 ff ff       	jmp    80105a6a <alltraps>

80106883 <vector221>:
.globl vector221
vector221:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $221
80106885:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010688a:	e9 db f1 ff ff       	jmp    80105a6a <alltraps>

8010688f <vector222>:
.globl vector222
vector222:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $222
80106891:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106896:	e9 cf f1 ff ff       	jmp    80105a6a <alltraps>

8010689b <vector223>:
.globl vector223
vector223:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $223
8010689d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068a2:	e9 c3 f1 ff ff       	jmp    80105a6a <alltraps>

801068a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $224
801068a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068ae:	e9 b7 f1 ff ff       	jmp    80105a6a <alltraps>

801068b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $225
801068b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068ba:	e9 ab f1 ff ff       	jmp    80105a6a <alltraps>

801068bf <vector226>:
.globl vector226
vector226:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $226
801068c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068c6:	e9 9f f1 ff ff       	jmp    80105a6a <alltraps>

801068cb <vector227>:
.globl vector227
vector227:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $227
801068cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068d2:	e9 93 f1 ff ff       	jmp    80105a6a <alltraps>

801068d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $228
801068d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068de:	e9 87 f1 ff ff       	jmp    80105a6a <alltraps>

801068e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $229
801068e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068ea:	e9 7b f1 ff ff       	jmp    80105a6a <alltraps>

801068ef <vector230>:
.globl vector230
vector230:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $230
801068f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068f6:	e9 6f f1 ff ff       	jmp    80105a6a <alltraps>

801068fb <vector231>:
.globl vector231
vector231:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $231
801068fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106902:	e9 63 f1 ff ff       	jmp    80105a6a <alltraps>

80106907 <vector232>:
.globl vector232
vector232:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $232
80106909:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010690e:	e9 57 f1 ff ff       	jmp    80105a6a <alltraps>

80106913 <vector233>:
.globl vector233
vector233:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $233
80106915:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010691a:	e9 4b f1 ff ff       	jmp    80105a6a <alltraps>

8010691f <vector234>:
.globl vector234
vector234:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $234
80106921:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106926:	e9 3f f1 ff ff       	jmp    80105a6a <alltraps>

8010692b <vector235>:
.globl vector235
vector235:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $235
8010692d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106932:	e9 33 f1 ff ff       	jmp    80105a6a <alltraps>

80106937 <vector236>:
.globl vector236
vector236:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $236
80106939:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010693e:	e9 27 f1 ff ff       	jmp    80105a6a <alltraps>

80106943 <vector237>:
.globl vector237
vector237:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $237
80106945:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010694a:	e9 1b f1 ff ff       	jmp    80105a6a <alltraps>

8010694f <vector238>:
.globl vector238
vector238:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $238
80106951:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106956:	e9 0f f1 ff ff       	jmp    80105a6a <alltraps>

8010695b <vector239>:
.globl vector239
vector239:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $239
8010695d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106962:	e9 03 f1 ff ff       	jmp    80105a6a <alltraps>

80106967 <vector240>:
.globl vector240
vector240:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $240
80106969:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010696e:	e9 f7 f0 ff ff       	jmp    80105a6a <alltraps>

80106973 <vector241>:
.globl vector241
vector241:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $241
80106975:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010697a:	e9 eb f0 ff ff       	jmp    80105a6a <alltraps>

8010697f <vector242>:
.globl vector242
vector242:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $242
80106981:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106986:	e9 df f0 ff ff       	jmp    80105a6a <alltraps>

8010698b <vector243>:
.globl vector243
vector243:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $243
8010698d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106992:	e9 d3 f0 ff ff       	jmp    80105a6a <alltraps>

80106997 <vector244>:
.globl vector244
vector244:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $244
80106999:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010699e:	e9 c7 f0 ff ff       	jmp    80105a6a <alltraps>

801069a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $245
801069a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069aa:	e9 bb f0 ff ff       	jmp    80105a6a <alltraps>

801069af <vector246>:
.globl vector246
vector246:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $246
801069b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069b6:	e9 af f0 ff ff       	jmp    80105a6a <alltraps>

801069bb <vector247>:
.globl vector247
vector247:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $247
801069bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069c2:	e9 a3 f0 ff ff       	jmp    80105a6a <alltraps>

801069c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $248
801069c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069ce:	e9 97 f0 ff ff       	jmp    80105a6a <alltraps>

801069d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $249
801069d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069da:	e9 8b f0 ff ff       	jmp    80105a6a <alltraps>

801069df <vector250>:
.globl vector250
vector250:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $250
801069e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069e6:	e9 7f f0 ff ff       	jmp    80105a6a <alltraps>

801069eb <vector251>:
.globl vector251
vector251:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $251
801069ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069f2:	e9 73 f0 ff ff       	jmp    80105a6a <alltraps>

801069f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $252
801069f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801069fe:	e9 67 f0 ff ff       	jmp    80105a6a <alltraps>

80106a03 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $253
80106a05:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a0a:	e9 5b f0 ff ff       	jmp    80105a6a <alltraps>

80106a0f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $254
80106a11:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a16:	e9 4f f0 ff ff       	jmp    80105a6a <alltraps>

80106a1b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $255
80106a1d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a22:	e9 43 f0 ff ff       	jmp    80105a6a <alltraps>
80106a27:	66 90                	xchg   %ax,%ax
80106a29:	66 90                	xchg   %ax,%ax
80106a2b:	66 90                	xchg   %ax,%ax
80106a2d:	66 90                	xchg   %ax,%ax
80106a2f:	90                   	nop

80106a30 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	57                   	push   %edi
80106a34:	56                   	push   %esi
80106a35:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a36:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a3c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a42:	83 ec 1c             	sub    $0x1c,%esp
80106a45:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a48:	39 d3                	cmp    %edx,%ebx
80106a4a:	73 49                	jae    80106a95 <deallocuvm.part.0+0x65>
80106a4c:	89 c7                	mov    %eax,%edi
80106a4e:	eb 0c                	jmp    80106a5c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a50:	83 c0 01             	add    $0x1,%eax
80106a53:	c1 e0 16             	shl    $0x16,%eax
80106a56:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a58:	39 da                	cmp    %ebx,%edx
80106a5a:	76 39                	jbe    80106a95 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106a5c:	89 d8                	mov    %ebx,%eax
80106a5e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106a61:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106a64:	f6 c1 01             	test   $0x1,%cl
80106a67:	74 e7                	je     80106a50 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106a69:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a6b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106a71:	c1 ee 0a             	shr    $0xa,%esi
80106a74:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106a7a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106a81:	85 f6                	test   %esi,%esi
80106a83:	74 cb                	je     80106a50 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106a85:	8b 06                	mov    (%esi),%eax
80106a87:	a8 01                	test   $0x1,%al
80106a89:	75 15                	jne    80106aa0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106a8b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a91:	39 da                	cmp    %ebx,%edx
80106a93:	77 c7                	ja     80106a5c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a9b:	5b                   	pop    %ebx
80106a9c:	5e                   	pop    %esi
80106a9d:	5f                   	pop    %edi
80106a9e:	5d                   	pop    %ebp
80106a9f:	c3                   	ret    
      if(pa == 0)
80106aa0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106aa5:	74 25                	je     80106acc <deallocuvm.part.0+0x9c>
      kfree(v);
80106aa7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106aaa:	05 00 00 00 80       	add    $0x80000000,%eax
80106aaf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ab2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106ab8:	50                   	push   %eax
80106ab9:	e8 02 ba ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106abe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ac7:	83 c4 10             	add    $0x10,%esp
80106aca:	eb 8c                	jmp    80106a58 <deallocuvm.part.0+0x28>
        panic("kfree");
80106acc:	83 ec 0c             	sub    $0xc,%esp
80106acf:	68 36 8c 10 80       	push   $0x80108c36
80106ad4:	e8 a7 98 ff ff       	call   80100380 <panic>
80106ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ae0 <seginit>:
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ae6:	e8 d5 cf ff ff       	call   80103ac0 <cpuid>
  pd[0] = size-1;
80106aeb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106af0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106af6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106afa:	c7 80 18 f8 12 80 ff 	movl   $0xffff,-0x7fed07e8(%eax)
80106b01:	ff 00 00 
80106b04:	c7 80 1c f8 12 80 00 	movl   $0xcf9a00,-0x7fed07e4(%eax)
80106b0b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b0e:	c7 80 20 f8 12 80 ff 	movl   $0xffff,-0x7fed07e0(%eax)
80106b15:	ff 00 00 
80106b18:	c7 80 24 f8 12 80 00 	movl   $0xcf9200,-0x7fed07dc(%eax)
80106b1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b22:	c7 80 28 f8 12 80 ff 	movl   $0xffff,-0x7fed07d8(%eax)
80106b29:	ff 00 00 
80106b2c:	c7 80 2c f8 12 80 00 	movl   $0xcffa00,-0x7fed07d4(%eax)
80106b33:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b36:	c7 80 30 f8 12 80 ff 	movl   $0xffff,-0x7fed07d0(%eax)
80106b3d:	ff 00 00 
80106b40:	c7 80 34 f8 12 80 00 	movl   $0xcff200,-0x7fed07cc(%eax)
80106b47:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b4a:	05 10 f8 12 80       	add    $0x8012f810,%eax
  pd[1] = (uint)p;
80106b4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106b53:	c1 e8 10             	shr    $0x10,%eax
80106b56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106b5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106b5d:	0f 01 10             	lgdtl  (%eax)
}
80106b60:	c9                   	leave  
80106b61:	c3                   	ret    
80106b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b70 <walkpgdir>:
{
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
80106b76:	83 ec 0c             	sub    $0xc,%esp
80106b79:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
80106b7c:	8b 55 08             	mov    0x8(%ebp),%edx
80106b7f:	89 fe                	mov    %edi,%esi
80106b81:	c1 ee 16             	shr    $0x16,%esi
80106b84:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80106b87:	8b 1e                	mov    (%esi),%ebx
80106b89:	f6 c3 01             	test   $0x1,%bl
80106b8c:	74 22                	je     80106bb0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b8e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106b94:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
80106b9a:	89 f8                	mov    %edi,%eax
}
80106b9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106b9f:	c1 e8 0a             	shr    $0xa,%eax
80106ba2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ba7:	01 d8                	add    %ebx,%eax
}
80106ba9:	5b                   	pop    %ebx
80106baa:	5e                   	pop    %esi
80106bab:	5f                   	pop    %edi
80106bac:	5d                   	pop    %ebp
80106bad:	c3                   	ret    
80106bae:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bb0:	8b 45 10             	mov    0x10(%ebp),%eax
80106bb3:	85 c0                	test   %eax,%eax
80106bb5:	74 31                	je     80106be8 <walkpgdir+0x78>
80106bb7:	e8 f4 bb ff ff       	call   801027b0 <kalloc>
80106bbc:	89 c3                	mov    %eax,%ebx
80106bbe:	85 c0                	test   %eax,%eax
80106bc0:	74 26                	je     80106be8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80106bc2:	83 ec 04             	sub    $0x4,%esp
80106bc5:	68 00 10 00 00       	push   $0x1000
80106bca:	6a 00                	push   $0x0
80106bcc:	50                   	push   %eax
80106bcd:	e8 5e dc ff ff       	call   80104830 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bd2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bd8:	83 c4 10             	add    $0x10,%esp
80106bdb:	83 c8 07             	or     $0x7,%eax
80106bde:	89 06                	mov    %eax,(%esi)
80106be0:	eb b8                	jmp    80106b9a <walkpgdir+0x2a>
80106be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106beb:	31 c0                	xor    %eax,%eax
}
80106bed:	5b                   	pop    %ebx
80106bee:	5e                   	pop    %esi
80106bef:	5f                   	pop    %edi
80106bf0:	5d                   	pop    %ebp
80106bf1:	c3                   	ret    
80106bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c00 <mappages>:
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
80106c06:	83 ec 1c             	sub    $0x1c,%esp
80106c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c0c:	8b 55 10             	mov    0x10(%ebp),%edx
  a = (char*)PGROUNDDOWN((uint)va);
80106c0f:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c11:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106c15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106c1a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c20:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c23:	8b 45 14             	mov    0x14(%ebp),%eax
80106c26:	29 d8                	sub    %ebx,%eax
80106c28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c2b:	eb 3a                	jmp    80106c67 <mappages+0x67>
80106c2d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c30:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c37:	c1 ea 0a             	shr    $0xa,%edx
80106c3a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c40:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c47:	85 c0                	test   %eax,%eax
80106c49:	74 75                	je     80106cc0 <mappages+0xc0>
    if(*pte & PTE_P)
80106c4b:	f6 00 01             	testb  $0x1,(%eax)
80106c4e:	0f 85 86 00 00 00    	jne    80106cda <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106c54:	0b 75 18             	or     0x18(%ebp),%esi
80106c57:	83 ce 01             	or     $0x1,%esi
80106c5a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c5c:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80106c5f:	74 6f                	je     80106cd0 <mappages+0xd0>
    a += PGSIZE;
80106c61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106c67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106c6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106c6d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c70:	89 d8                	mov    %ebx,%eax
80106c72:	c1 e8 16             	shr    $0x16,%eax
80106c75:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c78:	8b 07                	mov    (%edi),%eax
80106c7a:	a8 01                	test   $0x1,%al
80106c7c:	75 b2                	jne    80106c30 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c7e:	e8 2d bb ff ff       	call   801027b0 <kalloc>
80106c83:	85 c0                	test   %eax,%eax
80106c85:	74 39                	je     80106cc0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c87:	83 ec 04             	sub    $0x4,%esp
80106c8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c8d:	68 00 10 00 00       	push   $0x1000
80106c92:	6a 00                	push   $0x0
80106c94:	50                   	push   %eax
80106c95:	e8 96 db ff ff       	call   80104830 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
80106c9d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ca0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ca6:	83 c8 07             	or     $0x7,%eax
80106ca9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106cab:	89 d8                	mov    %ebx,%eax
80106cad:	c1 e8 0a             	shr    $0xa,%eax
80106cb0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106cb5:	01 d0                	add    %edx,%eax
80106cb7:	eb 92                	jmp    80106c4b <mappages+0x4b>
80106cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cc8:	5b                   	pop    %ebx
80106cc9:	5e                   	pop    %esi
80106cca:	5f                   	pop    %edi
80106ccb:	5d                   	pop    %ebp
80106ccc:	c3                   	ret    
80106ccd:	8d 76 00             	lea    0x0(%esi),%esi
80106cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cd3:	31 c0                	xor    %eax,%eax
}
80106cd5:	5b                   	pop    %ebx
80106cd6:	5e                   	pop    %esi
80106cd7:	5f                   	pop    %edi
80106cd8:	5d                   	pop    %ebp
80106cd9:	c3                   	ret    
      panic("remap");
80106cda:	83 ec 0c             	sub    $0xc,%esp
80106cdd:	68 58 93 10 80       	push   $0x80109358
80106ce2:	e8 99 96 ff ff       	call   80100380 <panic>
80106ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cee:	66 90                	xchg   %ax,%ax

80106cf0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cf0:	a1 c4 a6 13 80       	mov    0x8013a6c4,%eax
80106cf5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cfa:	0f 22 d8             	mov    %eax,%cr3
}
80106cfd:	c3                   	ret    
80106cfe:	66 90                	xchg   %ax,%ax

80106d00 <switchuvm>:
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 1c             	sub    $0x1c,%esp
80106d09:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d0c:	85 f6                	test   %esi,%esi
80106d0e:	0f 84 cb 00 00 00    	je     80106ddf <switchuvm+0xdf>
  if(p->kstack == 0)
80106d14:	8b 46 08             	mov    0x8(%esi),%eax
80106d17:	85 c0                	test   %eax,%eax
80106d19:	0f 84 da 00 00 00    	je     80106df9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d1f:	8b 46 04             	mov    0x4(%esi),%eax
80106d22:	85 c0                	test   %eax,%eax
80106d24:	0f 84 c2 00 00 00    	je     80106dec <switchuvm+0xec>
  pushcli();
80106d2a:	e8 f1 d8 ff ff       	call   80104620 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d2f:	e8 2c cd ff ff       	call   80103a60 <mycpu>
80106d34:	89 c3                	mov    %eax,%ebx
80106d36:	e8 25 cd ff ff       	call   80103a60 <mycpu>
80106d3b:	89 c7                	mov    %eax,%edi
80106d3d:	e8 1e cd ff ff       	call   80103a60 <mycpu>
80106d42:	83 c7 08             	add    $0x8,%edi
80106d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d48:	e8 13 cd ff ff       	call   80103a60 <mycpu>
80106d4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d50:	ba 67 00 00 00       	mov    $0x67,%edx
80106d55:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d5c:	83 c0 08             	add    $0x8,%eax
80106d5f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d66:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d6b:	83 c1 08             	add    $0x8,%ecx
80106d6e:	c1 e8 18             	shr    $0x18,%eax
80106d71:	c1 e9 10             	shr    $0x10,%ecx
80106d74:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d7a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d80:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d85:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d8c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106d91:	e8 ca cc ff ff       	call   80103a60 <mycpu>
80106d96:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d9d:	e8 be cc ff ff       	call   80103a60 <mycpu>
80106da2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106da6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106da9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106daf:	e8 ac cc ff ff       	call   80103a60 <mycpu>
80106db4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106db7:	e8 a4 cc ff ff       	call   80103a60 <mycpu>
80106dbc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106dc0:	b8 28 00 00 00       	mov    $0x28,%eax
80106dc5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106dc8:	8b 46 04             	mov    0x4(%esi),%eax
80106dcb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106dd0:	0f 22 d8             	mov    %eax,%cr3
}
80106dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dd6:	5b                   	pop    %ebx
80106dd7:	5e                   	pop    %esi
80106dd8:	5f                   	pop    %edi
80106dd9:	5d                   	pop    %ebp
  popcli();
80106dda:	e9 91 d8 ff ff       	jmp    80104670 <popcli>
    panic("switchuvm: no process");
80106ddf:	83 ec 0c             	sub    $0xc,%esp
80106de2:	68 5e 93 10 80       	push   $0x8010935e
80106de7:	e8 94 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106dec:	83 ec 0c             	sub    $0xc,%esp
80106def:	68 89 93 10 80       	push   $0x80109389
80106df4:	e8 87 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106df9:	83 ec 0c             	sub    $0xc,%esp
80106dfc:	68 74 93 10 80       	push   $0x80109374
80106e01:	e8 7a 95 ff ff       	call   80100380 <panic>
80106e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e0d:	8d 76 00             	lea    0x0(%esi),%esi

80106e10 <inituvm>:
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	83 ec 1c             	sub    $0x1c,%esp
80106e19:	8b 75 10             	mov    0x10(%ebp),%esi
80106e1c:	8b 55 08             	mov    0x8(%ebp),%edx
80106e1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106e22:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e28:	77 50                	ja     80106e7a <inituvm+0x6a>
80106e2a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
80106e2d:	e8 7e b9 ff ff       	call   801027b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106e32:	83 ec 04             	sub    $0x4,%esp
80106e35:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e3a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e3c:	6a 00                	push   $0x0
80106e3e:	50                   	push   %eax
80106e3f:	e8 ec d9 ff ff       	call   80104830 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e47:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e4d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106e54:	50                   	push   %eax
80106e55:	68 00 10 00 00       	push   $0x1000
80106e5a:	6a 00                	push   $0x0
80106e5c:	52                   	push   %edx
80106e5d:	e8 9e fd ff ff       	call   80106c00 <mappages>
  memmove(mem, init, sz);
80106e62:	89 75 10             	mov    %esi,0x10(%ebp)
80106e65:	83 c4 20             	add    $0x20,%esp
80106e68:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e6b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e71:	5b                   	pop    %ebx
80106e72:	5e                   	pop    %esi
80106e73:	5f                   	pop    %edi
80106e74:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e75:	e9 56 da ff ff       	jmp    801048d0 <memmove>
    panic("inituvm: more than a page");
80106e7a:	83 ec 0c             	sub    $0xc,%esp
80106e7d:	68 9d 93 10 80       	push   $0x8010939d
80106e82:	e8 f9 94 ff ff       	call   80100380 <panic>
80106e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e8e:	66 90                	xchg   %ax,%ax

80106e90 <loaduvm>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 1c             	sub    $0x1c,%esp
80106e99:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e9c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106e9f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ea4:	0f 85 bb 00 00 00    	jne    80106f65 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106eaa:	01 f0                	add    %esi,%eax
80106eac:	89 f3                	mov    %esi,%ebx
80106eae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106eb1:	8b 45 14             	mov    0x14(%ebp),%eax
80106eb4:	01 f0                	add    %esi,%eax
80106eb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106eb9:	85 f6                	test   %esi,%esi
80106ebb:	0f 84 87 00 00 00    	je     80106f48 <loaduvm+0xb8>
80106ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106ecb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106ece:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106ed0:	89 c2                	mov    %eax,%edx
80106ed2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106ed5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106ed8:	f6 c2 01             	test   $0x1,%dl
80106edb:	75 13                	jne    80106ef0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106edd:	83 ec 0c             	sub    $0xc,%esp
80106ee0:	68 b7 93 10 80       	push   $0x801093b7
80106ee5:	e8 96 94 ff ff       	call   80100380 <panic>
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ef0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ef3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106ef9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106efe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f05:	85 c0                	test   %eax,%eax
80106f07:	74 d4                	je     80106edd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f09:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f0b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f0e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106f13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f18:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f1e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f21:	29 d9                	sub    %ebx,%ecx
80106f23:	05 00 00 00 80       	add    $0x80000000,%eax
80106f28:	57                   	push   %edi
80106f29:	51                   	push   %ecx
80106f2a:	50                   	push   %eax
80106f2b:	ff 75 10             	push   0x10(%ebp)
80106f2e:	e8 5d ab ff ff       	call   80101a90 <readi>
80106f33:	83 c4 10             	add    $0x10,%esp
80106f36:	39 f8                	cmp    %edi,%eax
80106f38:	75 1e                	jne    80106f58 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f3a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106f40:	89 f0                	mov    %esi,%eax
80106f42:	29 d8                	sub    %ebx,%eax
80106f44:	39 c6                	cmp    %eax,%esi
80106f46:	77 80                	ja     80106ec8 <loaduvm+0x38>
}
80106f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f4b:	31 c0                	xor    %eax,%eax
}
80106f4d:	5b                   	pop    %ebx
80106f4e:	5e                   	pop    %esi
80106f4f:	5f                   	pop    %edi
80106f50:	5d                   	pop    %ebp
80106f51:	c3                   	ret    
80106f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f60:	5b                   	pop    %ebx
80106f61:	5e                   	pop    %esi
80106f62:	5f                   	pop    %edi
80106f63:	5d                   	pop    %ebp
80106f64:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106f65:	83 ec 0c             	sub    $0xc,%esp
80106f68:	68 58 94 10 80       	push   $0x80109458
80106f6d:	e8 0e 94 ff ff       	call   80100380 <panic>
80106f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f80 <allocuvm>:
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
80106f86:	83 ec 0c             	sub    $0xc,%esp
  if(newsz >= MMAPBASE) // KERNBASE
80106f89:	81 7d 10 ff ff ff 5f 	cmpl   $0x5fffffff,0x10(%ebp)
80106f90:	0f 87 aa 00 00 00    	ja     80107040 <allocuvm+0xc0>
  if(newsz < oldsz)
80106f96:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f99:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f9c:	0f 82 a0 00 00 00    	jb     80107042 <allocuvm+0xc2>
  a = PGROUNDUP(oldsz);
80106fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fa5:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106fab:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106fb1:	39 75 10             	cmp    %esi,0x10(%ebp)
80106fb4:	0f 86 96 00 00 00    	jbe    80107050 <allocuvm+0xd0>
80106fba:	8b 45 10             	mov    0x10(%ebp),%eax
80106fbd:	83 e8 01             	sub    $0x1,%eax
80106fc0:	29 f0                	sub    %esi,%eax
80106fc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fc7:	8d bc 06 00 10 00 00 	lea    0x1000(%esi,%eax,1),%edi
80106fce:	eb 3d                	jmp    8010700d <allocuvm+0x8d>
    memset(mem, 0, PGSIZE);
80106fd0:	83 ec 04             	sub    $0x4,%esp
80106fd3:	68 00 10 00 00       	push   $0x1000
80106fd8:	6a 00                	push   $0x0
80106fda:	50                   	push   %eax
80106fdb:	e8 50 d8 ff ff       	call   80104830 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fe0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fe6:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106fed:	50                   	push   %eax
80106fee:	68 00 10 00 00       	push   $0x1000
80106ff3:	56                   	push   %esi
80106ff4:	ff 75 08             	push   0x8(%ebp)
80106ff7:	e8 04 fc ff ff       	call   80106c00 <mappages>
80106ffc:	83 c4 20             	add    $0x20,%esp
80106fff:	85 c0                	test   %eax,%eax
80107001:	78 5d                	js     80107060 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80107003:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107009:	39 fe                	cmp    %edi,%esi
8010700b:	74 43                	je     80107050 <allocuvm+0xd0>
    mem = kalloc();
8010700d:	e8 9e b7 ff ff       	call   801027b0 <kalloc>
80107012:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107014:	85 c0                	test   %eax,%eax
80107016:	75 b8                	jne    80106fd0 <allocuvm+0x50>
      cprintf("allocuvm out of memory\n");
80107018:	83 ec 0c             	sub    $0xc,%esp
8010701b:	68 d5 93 10 80       	push   $0x801093d5
80107020:	e8 7b 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107025:	8b 45 0c             	mov    0xc(%ebp),%eax
80107028:	83 c4 10             	add    $0x10,%esp
8010702b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010702e:	74 10                	je     80107040 <allocuvm+0xc0>
80107030:	89 c1                	mov    %eax,%ecx
80107032:	8b 55 10             	mov    0x10(%ebp),%edx
80107035:	8b 45 08             	mov    0x8(%ebp),%eax
80107038:	e8 f3 f9 ff ff       	call   80106a30 <deallocuvm.part.0>
8010703d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
80107040:	31 c0                	xor    %eax,%eax
}
80107042:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107045:	5b                   	pop    %ebx
80107046:	5e                   	pop    %esi
80107047:	5f                   	pop    %edi
80107048:	5d                   	pop    %ebp
80107049:	c3                   	ret    
8010704a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return newsz;
80107050:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107053:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107056:	5b                   	pop    %ebx
80107057:	5e                   	pop    %esi
80107058:	5f                   	pop    %edi
80107059:	5d                   	pop    %ebp
8010705a:	c3                   	ret    
8010705b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010705f:	90                   	nop
      cprintf("allocuvm out of memory (2)\n");
80107060:	83 ec 0c             	sub    $0xc,%esp
80107063:	68 ed 93 10 80       	push   $0x801093ed
80107068:	e8 33 96 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
8010706d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107070:	83 c4 10             	add    $0x10,%esp
80107073:	39 45 10             	cmp    %eax,0x10(%ebp)
80107076:	74 0d                	je     80107085 <allocuvm+0x105>
80107078:	89 c1                	mov    %eax,%ecx
8010707a:	8b 55 10             	mov    0x10(%ebp),%edx
8010707d:	8b 45 08             	mov    0x8(%ebp),%eax
80107080:	e8 ab f9 ff ff       	call   80106a30 <deallocuvm.part.0>
      kfree(mem);
80107085:	83 ec 0c             	sub    $0xc,%esp
80107088:	53                   	push   %ebx
80107089:	e8 32 b4 ff ff       	call   801024c0 <kfree>
      return 0;
8010708e:	83 c4 10             	add    $0x10,%esp
}
80107091:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107094:	31 c0                	xor    %eax,%eax
}
80107096:	5b                   	pop    %ebx
80107097:	5e                   	pop    %esi
80107098:	5f                   	pop    %edi
80107099:	5d                   	pop    %ebp
8010709a:	c3                   	ret    
8010709b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010709f:	90                   	nop

801070a0 <deallocuvm>:
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801070a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801070ac:	39 d1                	cmp    %edx,%ecx
801070ae:	73 10                	jae    801070c0 <deallocuvm+0x20>
}
801070b0:	5d                   	pop    %ebp
801070b1:	e9 7a f9 ff ff       	jmp    80106a30 <deallocuvm.part.0>
801070b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bd:	8d 76 00             	lea    0x0(%esi),%esi
801070c0:	89 d0                	mov    %edx,%eax
801070c2:	5d                   	pop    %ebp
801070c3:	c3                   	ret    
801070c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070cf:	90                   	nop

801070d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 0c             	sub    $0xc,%esp
801070d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801070dc:	85 f6                	test   %esi,%esi
801070de:	74 59                	je     80107139 <freevm+0x69>
  if(newsz >= oldsz)
801070e0:	31 c9                	xor    %ecx,%ecx
801070e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070e7:	89 f0                	mov    %esi,%eax
801070e9:	89 f3                	mov    %esi,%ebx
801070eb:	e8 40 f9 ff ff       	call   80106a30 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801070f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070f6:	eb 0f                	jmp    80107107 <freevm+0x37>
801070f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ff:	90                   	nop
80107100:	83 c3 04             	add    $0x4,%ebx
80107103:	39 df                	cmp    %ebx,%edi
80107105:	74 23                	je     8010712a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107107:	8b 03                	mov    (%ebx),%eax
80107109:	a8 01                	test   $0x1,%al
8010710b:	74 f3                	je     80107100 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010710d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107112:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107115:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107118:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010711d:	50                   	push   %eax
8010711e:	e8 9d b3 ff ff       	call   801024c0 <kfree>
80107123:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107126:	39 df                	cmp    %ebx,%edi
80107128:	75 dd                	jne    80107107 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010712a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010712d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107130:	5b                   	pop    %ebx
80107131:	5e                   	pop    %esi
80107132:	5f                   	pop    %edi
80107133:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107134:	e9 87 b3 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107139:	83 ec 0c             	sub    $0xc,%esp
8010713c:	68 09 94 10 80       	push   $0x80109409
80107141:	e8 3a 92 ff ff       	call   80100380 <panic>
80107146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010714d:	8d 76 00             	lea    0x0(%esi),%esi

80107150 <setupkvm>:
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	56                   	push   %esi
80107154:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107155:	e8 56 b6 ff ff       	call   801027b0 <kalloc>
8010715a:	89 c6                	mov    %eax,%esi
8010715c:	85 c0                	test   %eax,%eax
8010715e:	74 42                	je     801071a2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107160:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107163:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107168:	68 00 10 00 00       	push   $0x1000
8010716d:	6a 00                	push   $0x0
8010716f:	50                   	push   %eax
80107170:	e8 bb d6 ff ff       	call   80104830 <memset>
80107175:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107178:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010717b:	8b 53 08             	mov    0x8(%ebx),%edx
8010717e:	83 ec 0c             	sub    $0xc,%esp
80107181:	ff 73 0c             	push   0xc(%ebx)
80107184:	29 c2                	sub    %eax,%edx
80107186:	50                   	push   %eax
80107187:	52                   	push   %edx
80107188:	ff 33                	push   (%ebx)
8010718a:	56                   	push   %esi
8010718b:	e8 70 fa ff ff       	call   80106c00 <mappages>
80107190:	83 c4 20             	add    $0x20,%esp
80107193:	85 c0                	test   %eax,%eax
80107195:	78 19                	js     801071b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107197:	83 c3 10             	add    $0x10,%ebx
8010719a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801071a0:	75 d6                	jne    80107178 <setupkvm+0x28>
}
801071a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071a5:	89 f0                	mov    %esi,%eax
801071a7:	5b                   	pop    %ebx
801071a8:	5e                   	pop    %esi
801071a9:	5d                   	pop    %ebp
801071aa:	c3                   	ret    
801071ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071af:	90                   	nop
      freevm(pgdir);
801071b0:	83 ec 0c             	sub    $0xc,%esp
801071b3:	56                   	push   %esi
      return 0;
801071b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071b6:	e8 15 ff ff ff       	call   801070d0 <freevm>
      return 0;
801071bb:	83 c4 10             	add    $0x10,%esp
}
801071be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071c1:	89 f0                	mov    %esi,%eax
801071c3:	5b                   	pop    %ebx
801071c4:	5e                   	pop    %esi
801071c5:	5d                   	pop    %ebp
801071c6:	c3                   	ret    
801071c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ce:	66 90                	xchg   %ax,%ax

801071d0 <kvmalloc>:
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071d6:	e8 75 ff ff ff       	call   80107150 <setupkvm>
801071db:	a3 c4 a6 13 80       	mov    %eax,0x8013a6c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071e0:	05 00 00 00 80       	add    $0x80000000,%eax
801071e5:	0f 22 d8             	mov    %eax,%cr3
}
801071e8:	c9                   	leave  
801071e9:	c3                   	ret    
801071ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	83 ec 08             	sub    $0x8,%esp
801071f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071f9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801071fc:	89 c1                	mov    %eax,%ecx
801071fe:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107201:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107204:	f6 c2 01             	test   $0x1,%dl
80107207:	75 17                	jne    80107220 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107209:	83 ec 0c             	sub    $0xc,%esp
8010720c:	68 1a 94 10 80       	push   $0x8010941a
80107211:	e8 6a 91 ff ff       	call   80100380 <panic>
80107216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107220:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107223:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107229:	25 fc 0f 00 00       	and    $0xffc,%eax
8010722e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107235:	85 c0                	test   %eax,%eax
80107237:	74 d0                	je     80107209 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107239:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010723c:	c9                   	leave  
8010723d:	c3                   	ret    
8010723e:	66 90                	xchg   %ax,%ax

80107240 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107249:	e8 02 ff ff ff       	call   80107150 <setupkvm>
8010724e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107251:	85 c0                	test   %eax,%eax
80107253:	0f 84 c0 00 00 00    	je     80107319 <copyuvm+0xd9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107259:	8b 55 0c             	mov    0xc(%ebp),%edx
8010725c:	85 d2                	test   %edx,%edx
8010725e:	0f 84 b5 00 00 00    	je     80107319 <copyuvm+0xd9>
80107264:	31 f6                	xor    %esi,%esi
80107266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107270:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107273:	89 f0                	mov    %esi,%eax
80107275:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107278:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010727b:	a8 01                	test   $0x1,%al
8010727d:	75 11                	jne    80107290 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010727f:	83 ec 0c             	sub    $0xc,%esp
80107282:	68 24 94 10 80       	push   $0x80109424
80107287:	e8 f4 90 ff ff       	call   80100380 <panic>
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107290:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107292:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107297:	c1 ea 0a             	shr    $0xa,%edx
8010729a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801072a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801072a7:	85 c0                	test   %eax,%eax
801072a9:	74 d4                	je     8010727f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801072ab:	8b 38                	mov    (%eax),%edi
801072ad:	f7 c7 01 00 00 00    	test   $0x1,%edi
801072b3:	0f 84 9b 00 00 00    	je     80107354 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801072b9:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
801072bb:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
801072c1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801072c4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
801072ca:	e8 e1 b4 ff ff       	call   801027b0 <kalloc>
801072cf:	89 c7                	mov    %eax,%edi
801072d1:	85 c0                	test   %eax,%eax
801072d3:	74 5f                	je     80107334 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801072d5:	83 ec 04             	sub    $0x4,%esp
801072d8:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801072de:	68 00 10 00 00       	push   $0x1000
801072e3:	53                   	push   %ebx
801072e4:	50                   	push   %eax
801072e5:	e8 e6 d5 ff ff       	call   801048d0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801072ea:	58                   	pop    %eax
801072eb:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801072f1:	ff 75 e4             	push   -0x1c(%ebp)
801072f4:	50                   	push   %eax
801072f5:	68 00 10 00 00       	push   $0x1000
801072fa:	56                   	push   %esi
801072fb:	ff 75 e0             	push   -0x20(%ebp)
801072fe:	e8 fd f8 ff ff       	call   80106c00 <mappages>
80107303:	83 c4 20             	add    $0x20,%esp
80107306:	85 c0                	test   %eax,%eax
80107308:	78 1e                	js     80107328 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
8010730a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107310:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107313:	0f 87 57 ff ff ff    	ja     80107270 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107319:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010731c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010731f:	5b                   	pop    %ebx
80107320:	5e                   	pop    %esi
80107321:	5f                   	pop    %edi
80107322:	5d                   	pop    %ebp
80107323:	c3                   	ret    
80107324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107328:	83 ec 0c             	sub    $0xc,%esp
8010732b:	57                   	push   %edi
8010732c:	e8 8f b1 ff ff       	call   801024c0 <kfree>
      goto bad;
80107331:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107334:	83 ec 0c             	sub    $0xc,%esp
80107337:	ff 75 e0             	push   -0x20(%ebp)
8010733a:	e8 91 fd ff ff       	call   801070d0 <freevm>
  return 0;
8010733f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107346:	83 c4 10             	add    $0x10,%esp
}
80107349:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010734c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010734f:	5b                   	pop    %ebx
80107350:	5e                   	pop    %esi
80107351:	5f                   	pop    %edi
80107352:	5d                   	pop    %ebp
80107353:	c3                   	ret    
      panic("copyuvm: page not present");
80107354:	83 ec 0c             	sub    $0xc,%esp
80107357:	68 3e 94 10 80       	push   $0x8010943e
8010735c:	e8 1f 90 ff ff       	call   80100380 <panic>
80107361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010736f:	90                   	nop

80107370 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107376:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107379:	89 c1                	mov    %eax,%ecx
8010737b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010737e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107381:	f6 c2 01             	test   $0x1,%dl
80107384:	0f 84 00 01 00 00    	je     8010748a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010738a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010738d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107393:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107394:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107399:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801073a0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801073a7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073aa:	05 00 00 00 80       	add    $0x80000000,%eax
801073af:	83 fa 05             	cmp    $0x5,%edx
801073b2:	ba 00 00 00 00       	mov    $0x0,%edx
801073b7:	0f 45 c2             	cmovne %edx,%eax
}
801073ba:	c3                   	ret    
801073bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073bf:	90                   	nop

801073c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
801073c6:	83 ec 0c             	sub    $0xc,%esp
801073c9:	8b 75 14             	mov    0x14(%ebp),%esi
801073cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801073cf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801073d2:	85 f6                	test   %esi,%esi
801073d4:	75 51                	jne    80107427 <copyout+0x67>
801073d6:	e9 a5 00 00 00       	jmp    80107480 <copyout+0xc0>
801073db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073df:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801073e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801073e6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801073ec:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801073f2:	74 75                	je     80107469 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801073f4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073f6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801073f9:	29 c3                	sub    %eax,%ebx
801073fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107401:	39 f3                	cmp    %esi,%ebx
80107403:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107406:	29 f8                	sub    %edi,%eax
80107408:	83 ec 04             	sub    $0x4,%esp
8010740b:	01 c1                	add    %eax,%ecx
8010740d:	53                   	push   %ebx
8010740e:	52                   	push   %edx
8010740f:	51                   	push   %ecx
80107410:	e8 bb d4 ff ff       	call   801048d0 <memmove>
    len -= n;
    buf += n;
80107415:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107418:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010741e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107421:	01 da                	add    %ebx,%edx
  while(len > 0){
80107423:	29 de                	sub    %ebx,%esi
80107425:	74 59                	je     80107480 <copyout+0xc0>
  if(*pde & PTE_P){
80107427:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010742a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010742c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010742e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107431:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107437:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010743a:	f6 c1 01             	test   $0x1,%cl
8010743d:	0f 84 4e 00 00 00    	je     80107491 <copyout.cold>
  return &pgtab[PTX(va)];
80107443:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107445:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010744b:	c1 eb 0c             	shr    $0xc,%ebx
8010744e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107454:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010745b:	89 d9                	mov    %ebx,%ecx
8010745d:	83 e1 05             	and    $0x5,%ecx
80107460:	83 f9 05             	cmp    $0x5,%ecx
80107463:	0f 84 77 ff ff ff    	je     801073e0 <copyout+0x20>
  }
  return 0;
}
80107469:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010746c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107471:	5b                   	pop    %ebx
80107472:	5e                   	pop    %esi
80107473:	5f                   	pop    %edi
80107474:	5d                   	pop    %ebp
80107475:	c3                   	ret    
80107476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010747d:	8d 76 00             	lea    0x0(%esi),%esi
80107480:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107483:	31 c0                	xor    %eax,%eax
}
80107485:	5b                   	pop    %ebx
80107486:	5e                   	pop    %esi
80107487:	5f                   	pop    %edi
80107488:	5d                   	pop    %ebp
80107489:	c3                   	ret    

8010748a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010748a:	a1 00 00 00 00       	mov    0x0,%eax
8010748f:	0f 0b                	ud2    

80107491 <copyout.cold>:
80107491:	a1 00 00 00 00       	mov    0x0,%eax
80107496:	0f 0b                	ud2    
80107498:	66 90                	xchg   %ax,%ax
8010749a:	66 90                	xchg   %ax,%ax
8010749c:	66 90                	xchg   %ax,%ax
8010749e:	66 90                	xchg   %ax,%ax

801074a0 <sys_wpunmap>:
/**
 * @brief System call to partially remove a part of existing memory mapping from the process's address space.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_wpunmap(void) {
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	57                   	push   %edi
801074a4:	56                   	push   %esi
    uint left_len, right_len;
    uint va_start, va;
    pte_t *pte;

    // validate input
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0) {
801074a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_wpunmap(void) {
801074a8:	53                   	push   %ebx
801074a9:	83 ec 44             	sub    $0x44,%esp
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0) {
801074ac:	50                   	push   %eax
801074ad:	6a 00                	push   $0x0
801074af:	e8 3c d6 ff ff       	call   80104af0 <argint>
801074b4:	83 c4 10             	add    $0x10,%esp
801074b7:	85 c0                	test   %eax,%eax
801074b9:	0f 88 1f 03 00 00    	js     801077de <sys_wpunmap+0x33e>
801074bf:	83 ec 08             	sub    $0x8,%esp
801074c2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801074c5:	50                   	push   %eax
801074c6:	6a 01                	push   $0x1
801074c8:	e8 23 d6 ff ff       	call   80104af0 <argint>
801074cd:	83 c4 10             	add    $0x10,%esp
801074d0:	85 c0                	test   %eax,%eax
801074d2:	0f 88 06 03 00 00    	js     801077de <sys_wpunmap+0x33e>
        cprintf("wpunmap arg ERROR: size or flags\n");
        return FAILED;
    }
    if ((addr+length) % PGSIZE != 0) {
801074d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074de:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801074e1:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
801074e7:	0f 85 3f 03 00 00    	jne    8010782c <sys_wpunmap+0x38c>
        cprintf("wpunmap ERROR: partial unmap addr end not page aligned\n");
        return FAILED;
    }
    if (length <= 0){
801074ed:	85 d2                	test   %edx,%edx
801074ef:	0f 8e 51 03 00 00    	jle    80107846 <sys_wpunmap+0x3a6>
        cprintf("wpunmap ERROR: partial unmap length <= 0\n");
        return FAILED;
    }
    if (addr < 0x60000000 || addr >= 0x80000000) {
801074f5:	2d 00 00 00 60       	sub    $0x60000000,%eax
801074fa:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
801074ff:	0f 87 f3 02 00 00    	ja     801077f8 <sys_wpunmap+0x358>
        cprintf("wpunmap ERROR: addr out of mmap range\n");
        return FAILED;
    }

    curproc = myproc();
80107505:	e8 d6 c5 ff ff       	call   80103ae0 <myproc>
8010750a:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010750d:	89 c7                	mov    %eax,%edi
    unmap_end = addr + (uint)length;
8010750f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107512:	89 c6                	mov    %eax,%esi
80107514:	03 75 e4             	add    -0x1c(%ebp),%esi
80107517:	89 75 d0             	mov    %esi,-0x30(%ebp)
8010751a:	0f 82 40 03 00 00    	jb     80107860 <sys_wpunmap+0x3c0>
        return FAILED;
    }

    // Find map that fully contains [addr, unmap_end).
    prev = 0;
    cur = curproc->mmap_head;
80107520:	8b 9f 7c 02 00 00    	mov    0x27c(%edi),%ebx
    while (cur) {
80107526:	8b 75 d0             	mov    -0x30(%ebp),%esi
    prev = 0;
80107529:	31 ff                	xor    %edi,%edi
    while (cur) {
8010752b:	85 db                	test   %ebx,%ebx
8010752d:	75 0b                	jne    8010753a <sys_wpunmap+0x9a>
8010752f:	eb 21                	jmp    80107552 <sys_wpunmap+0xb2>
80107531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107538:	89 d3                	mov    %edx,%ebx
        map_start = cur->addr;
8010753a:	8b 13                	mov    (%ebx),%edx
        map_end = cur->addr + (uint)cur->length;
8010753c:	8b 4b 04             	mov    0x4(%ebx),%ecx
8010753f:	01 d1                	add    %edx,%ecx
        if (addr >= map_start && unmap_end <= map_end)
80107541:	39 ce                	cmp    %ecx,%esi
80107543:	77 04                	ja     80107549 <sys_wpunmap+0xa9>
80107545:	39 d0                	cmp    %edx,%eax
80107547:	73 27                	jae    80107570 <sys_wpunmap+0xd0>
            break;
        prev = cur;
        cur = cur->next;
80107549:	8b 53 1c             	mov    0x1c(%ebx),%edx
    while (cur) {
8010754c:	89 df                	mov    %ebx,%edi
8010754e:	85 d2                	test   %edx,%edx
80107550:	75 e6                	jne    80107538 <sys_wpunmap+0x98>
    }
    if (cur == 0) {
        cprintf("wpunmap ERROR: no containing map\n");
80107552:	83 ec 0c             	sub    $0xc,%esp
80107555:	68 8c 95 10 80       	push   $0x8010958c
8010755a:	e8 41 91 ff ff       	call   801006a0 <cprintf>
        return FAILED;
8010755f:	83 c4 10             	add    $0x10,%esp
80107562:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107567:	e9 71 01 00 00       	jmp    801076dd <sys_wpunmap+0x23d>
8010756c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }

    // Per README: partial unmap is only required for anonymous private maps.
    if ((cur->flags & MAP_ANONYMOUS) == 0 || (cur->flags & MAP_PRIVATE) == 0 || (cur->flags & MAP_SHARED)) {
80107570:	89 7d c0             	mov    %edi,-0x40(%ebp)
80107573:	8b 7b 08             	mov    0x8(%ebx),%edi
80107576:	83 e7 07             	and    $0x7,%edi
80107579:	83 ff 05             	cmp    $0x5,%edi
8010757c:	0f 85 90 02 00 00    	jne    80107812 <sys_wpunmap+0x372>
    left_len = addr - map_start;
    right_len = map_end - unmap_end;
    right = 0;

    // For middle split, reserve a second mmap slot first.
    if (left_len > 0 && right_len > 0) {
80107582:	89 c6                	mov    %eax,%esi
    right_len = map_end - unmap_end;
80107584:	89 cf                	mov    %ecx,%edi
80107586:	2b 7d d0             	sub    -0x30(%ebp),%edi
    if (left_len > 0 && right_len > 0) {
80107589:	29 d6                	sub    %edx,%esi
    right_len = map_end - unmap_end;
8010758b:	89 7d c4             	mov    %edi,-0x3c(%ebp)
    if (left_len > 0 && right_len > 0) {
8010758e:	89 75 c8             	mov    %esi,-0x38(%ebp)
80107591:	74 45                	je     801075d8 <sys_wpunmap+0x138>
80107593:	85 ff                	test   %edi,%edi
80107595:	74 41                	je     801075d8 <sys_wpunmap+0x138>
 *
 * @return Pointer to the unused mmap structure if found, or NULL if not found.
 */
struct mmap_region *find_unused_mmap(struct proc *proc) {
    int i;
    for (i = 0; i < MAX_NMMAP; i++) {
80107597:	8b 75 cc             	mov    -0x34(%ebp),%esi
8010759a:	31 d2                	xor    %edx,%edx
8010759c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (proc->mmaps[i].addr == (uint)-1)
801075a0:	89 d1                	mov    %edx,%ecx
801075a2:	c1 e1 05             	shl    $0x5,%ecx
801075a5:	83 7c 0e 7c ff       	cmpl   $0xffffffff,0x7c(%esi,%ecx,1)
801075aa:	0f 84 58 01 00 00    	je     80107708 <sys_wpunmap+0x268>
    for (i = 0; i < MAX_NMMAP; i++) {
801075b0:	83 c2 01             	add    $0x1,%edx
801075b3:	83 fa 10             	cmp    $0x10,%edx
801075b6:	75 e8                	jne    801075a0 <sys_wpunmap+0x100>
            cprintf("wpunmap ERROR: no free mmap slot for split\n");
801075b8:	83 ec 0c             	sub    $0xc,%esp
801075bb:	68 60 95 10 80       	push   $0x80109560
801075c0:	e8 db 90 ff ff       	call   801006a0 <cprintf>
            return FAILED;
801075c5:	83 c4 10             	add    $0x10,%esp
801075c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075cd:	e9 0b 01 00 00       	jmp    801076dd <sys_wpunmap+0x23d>
801075d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    va_start = PGROUNDUP(addr);
801075d8:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
    for (va = va_start; va < unmap_end; va += PGSIZE) {
801075de:	8b 45 d0             	mov    -0x30(%ebp),%eax
    right = 0;
801075e1:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
    va_start = PGROUNDUP(addr);
801075e8:	89 d6                	mov    %edx,%esi
801075ea:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    for (va = va_start; va < unmap_end; va += PGSIZE) {
801075f0:	39 f0                	cmp    %esi,%eax
801075f2:	76 59                	jbe    8010764d <sys_wpunmap+0x1ad>
    right = 0;
801075f4:	8b 7d cc             	mov    -0x34(%ebp),%edi
801075f7:	89 5d bc             	mov    %ebx,-0x44(%ebp)
801075fa:	89 f3                	mov    %esi,%ebx
801075fc:	89 c6                	mov    %eax,%esi
801075fe:	66 90                	xchg   %ax,%ax
        pte = walkpgdir(curproc->pgdir, (void *)va, 0);
80107600:	83 ec 04             	sub    $0x4,%esp
80107603:	6a 00                	push   $0x0
80107605:	53                   	push   %ebx
80107606:	ff 77 04             	push   0x4(%edi)
80107609:	e8 62 f5 ff ff       	call   80106b70 <walkpgdir>
        if (pte == 0 || (*pte & PTE_P) == 0)
8010760e:	83 c4 10             	add    $0x10,%esp
80107611:	85 c0                	test   %eax,%eax
80107613:	74 2b                	je     80107640 <sys_wpunmap+0x1a0>
80107615:	8b 08                	mov    (%eax),%ecx
80107617:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010761a:	f6 c1 01             	test   $0x1,%cl
8010761d:	74 21                	je     80107640 <sys_wpunmap+0x1a0>
        kfree(P2V(PTE_ADDR(*pte)));
8010761f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107625:	83 ec 0c             	sub    $0xc,%esp
80107628:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
8010762e:	51                   	push   %ecx
8010762f:	e8 8c ae ff ff       	call   801024c0 <kfree>
        *pte = 0;
80107634:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107637:	83 c4 10             	add    $0x10,%esp
8010763a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (va = va_start; va < unmap_end; va += PGSIZE) {
80107640:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107646:	39 de                	cmp    %ebx,%esi
80107648:	77 b6                	ja     80107600 <sys_wpunmap+0x160>
8010764a:	8b 5d bc             	mov    -0x44(%ebp),%ebx
    switchuvm(curproc);
8010764d:	83 ec 0c             	sub    $0xc,%esp
80107650:	ff 75 cc             	push   -0x34(%ebp)
80107653:	e8 a8 f6 ff ff       	call   80106d00 <switchuvm>
    if (left_len == 0 && right_len == 0) {
80107658:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010765b:	83 c4 10             	add    $0x10,%esp
8010765e:	0b 45 c4             	or     -0x3c(%ebp),%eax
80107661:	0f 85 81 00 00 00    	jne    801076e8 <sys_wpunmap+0x248>
        if (prev == 0)
80107667:	8b 4d c0             	mov    -0x40(%ebp),%ecx
            curproc->mmap_head = cur->next;
8010766a:	8b 43 1c             	mov    0x1c(%ebx),%eax
        if (prev == 0)
8010766d:	85 c9                	test   %ecx,%ecx
8010766f:	0f 84 5b 01 00 00    	je     801077d0 <sys_wpunmap+0x330>
            prev->next = cur->next;
80107675:	8b 75 c0             	mov    -0x40(%ebp),%esi
80107678:	89 46 1c             	mov    %eax,0x1c(%esi)
        if (cur->f)
8010767b:	8b 43 10             	mov    0x10(%ebx),%eax
8010767e:	85 c0                	test   %eax,%eax
80107680:	74 0c                	je     8010768e <sys_wpunmap+0x1ee>
            fileclose(cur->f);
80107682:	83 ec 0c             	sub    $0xc,%esp
80107685:	50                   	push   %eax
80107686:	e8 65 98 ff ff       	call   80100ef0 <fileclose>
8010768b:	83 c4 10             	add    $0x10,%esp
        if (curproc->total_mmaps > 0)
8010768e:	8b 7d cc             	mov    -0x34(%ebp),%edi
 * @brief resets the fields of an mmap_region struct to their default values.
 *
 * @param mmap Pointer to the mmap_region struct to reset.
 */
void init_one_mmap(struct mmap_region *mmap) {
    mmap->addr = -1;
80107691:	c7 03 ff ff ff ff    	movl   $0xffffffff,(%ebx)
    return 0;
80107697:	31 c0                	xor    %eax,%eax
    mmap->length = -1;
80107699:	c7 43 04 ff ff ff ff 	movl   $0xffffffff,0x4(%ebx)
    mmap->flags = -1;
801076a0:	c7 43 08 ff ff ff ff 	movl   $0xffffffff,0x8(%ebx)
    mmap->fd = -1;
801076a7:	c7 43 0c ff ff ff ff 	movl   $0xffffffff,0xc(%ebx)
    mmap->f = 0;
801076ae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    mmap->refcnt = 0;
801076b5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    mmap->n_loaded_pages = 0;
801076bc:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
    mmap->next = 0;
801076c3:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
        if (curproc->total_mmaps > 0)
801076ca:	8b 97 80 02 00 00    	mov    0x280(%edi),%edx
801076d0:	85 d2                	test   %edx,%edx
801076d2:	7e 09                	jle    801076dd <sys_wpunmap+0x23d>
            curproc->total_mmaps--;
801076d4:	83 ea 01             	sub    $0x1,%edx
801076d7:	89 97 80 02 00 00    	mov    %edx,0x280(%edi)
}
801076dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076e0:	5b                   	pop    %ebx
801076e1:	5e                   	pop    %esi
801076e2:	5f                   	pop    %edi
801076e3:	5d                   	pop    %ebp
801076e4:	c3                   	ret    
801076e5:	8d 76 00             	lea    0x0(%esi),%esi
    } else if (left_len == 0) {
801076e8:	8b 55 c8             	mov    -0x38(%ebp),%edx
801076eb:	85 d2                	test   %edx,%edx
801076ed:	75 49                	jne    80107738 <sys_wpunmap+0x298>
        cur->addr = unmap_end;
801076ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
801076f2:	89 03                	mov    %eax,(%ebx)
        cur->length = right_len;
801076f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801076f7:	89 43 04             	mov    %eax,0x4(%ebx)
}
801076fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801076fd:	31 c0                	xor    %eax,%eax
}
801076ff:	5b                   	pop    %ebx
80107700:	5e                   	pop    %esi
80107701:	5f                   	pop    %edi
80107702:	5d                   	pop    %ebp
80107703:	c3                   	ret    
80107704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            return &proc->mmaps[i];
80107708:	8b 7d cc             	mov    -0x34(%ebp),%edi
    va_start = PGROUNDUP(addr);
8010770b:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80107711:	89 d6                	mov    %edx,%esi
            return &proc->mmaps[i];
80107713:	8d 7c 0f 7c          	lea    0x7c(%edi,%ecx,1),%edi
    va_start = PGROUNDUP(addr);
80107717:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
            return &proc->mmaps[i];
8010771d:	89 7d b8             	mov    %edi,-0x48(%ebp)
    for (va = va_start; va < unmap_end; va += PGSIZE) {
80107720:	3b 75 d0             	cmp    -0x30(%ebp),%esi
80107723:	73 2a                	jae    8010774f <sys_wpunmap+0x2af>
80107725:	89 5d bc             	mov    %ebx,-0x44(%ebp)
80107728:	8b 7d cc             	mov    -0x34(%ebp),%edi
8010772b:	89 f3                	mov    %esi,%ebx
8010772d:	8b 75 d0             	mov    -0x30(%ebp),%esi
80107730:	e9 cb fe ff ff       	jmp    80107600 <sys_wpunmap+0x160>
80107735:	8d 76 00             	lea    0x0(%esi),%esi
    } else if (right_len == 0) {
80107738:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010773b:	85 c0                	test   %eax,%eax
8010773d:	75 1e                	jne    8010775d <sys_wpunmap+0x2bd>
        cur->length = left_len;
8010773f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80107742:	89 43 04             	mov    %eax,0x4(%ebx)
}
80107745:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107748:	31 c0                	xor    %eax,%eax
}
8010774a:	5b                   	pop    %ebx
8010774b:	5e                   	pop    %esi
8010774c:	5f                   	pop    %edi
8010774d:	5d                   	pop    %ebp
8010774e:	c3                   	ret    
    switchuvm(curproc);
8010774f:	83 ec 0c             	sub    $0xc,%esp
80107752:	ff 75 cc             	push   -0x34(%ebp)
80107755:	e8 a6 f5 ff ff       	call   80106d00 <switchuvm>
8010775a:	83 c4 10             	add    $0x10,%esp
    mmap->flags = -1;
8010775d:	8b 75 b8             	mov    -0x48(%ebp),%esi
        right->addr = unmap_end;
80107760:	8b 45 d0             	mov    -0x30(%ebp),%eax
80107763:	89 06                	mov    %eax,(%esi)
        right->length = right_len;
80107765:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    mmap->flags = -1;
80107768:	c7 46 08 ff ff ff ff 	movl   $0xffffffff,0x8(%esi)
    mmap->fd = -1;
8010776f:	c7 46 0c ff ff ff ff 	movl   $0xffffffff,0xc(%esi)
    mmap->f = 0;
80107776:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
    mmap->refcnt = 0;
8010777d:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
    mmap->next = 0;
80107784:	c7 46 1c 00 00 00 00 	movl   $0x0,0x1c(%esi)
    mmap->n_loaded_pages = 0;
8010778b:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
        right->length = right_len;
80107792:	89 46 04             	mov    %eax,0x4(%esi)
        right->flags = cur->flags;
80107795:	8b 43 08             	mov    0x8(%ebx),%eax
80107798:	89 46 08             	mov    %eax,0x8(%esi)
        right->fd = cur->fd;
8010779b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010779e:	89 46 0c             	mov    %eax,0xc(%esi)
        right->f = cur->f;
801077a1:	8b 43 10             	mov    0x10(%ebx),%eax
801077a4:	89 46 10             	mov    %eax,0x10(%esi)
        right->refcnt = cur->refcnt;
801077a7:	8b 43 14             	mov    0x14(%ebx),%eax
801077aa:	89 46 14             	mov    %eax,0x14(%esi)
        right->next = cur->next;
801077ad:	8b 43 1c             	mov    0x1c(%ebx),%eax
801077b0:	89 46 1c             	mov    %eax,0x1c(%esi)
        cur->length = left_len;
801077b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
        cur->next = right;
801077b6:	89 73 1c             	mov    %esi,0x1c(%ebx)
        cur->length = left_len;
801077b9:	89 43 04             	mov    %eax,0x4(%ebx)
        curproc->total_mmaps++;
801077bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
801077bf:	83 80 80 02 00 00 01 	addl   $0x1,0x280(%eax)
}
801077c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801077c9:	31 c0                	xor    %eax,%eax
}
801077cb:	5b                   	pop    %ebx
801077cc:	5e                   	pop    %esi
801077cd:	5f                   	pop    %edi
801077ce:	5d                   	pop    %ebp
801077cf:	c3                   	ret    
            curproc->mmap_head = cur->next;
801077d0:	8b 7d cc             	mov    -0x34(%ebp),%edi
801077d3:	89 87 7c 02 00 00    	mov    %eax,0x27c(%edi)
801077d9:	e9 9d fe ff ff       	jmp    8010767b <sys_wpunmap+0x1db>
        cprintf("wpunmap arg ERROR: size or flags\n");
801077de:	83 ec 0c             	sub    $0xc,%esp
801077e1:	68 7c 94 10 80       	push   $0x8010947c
801077e6:	e8 b5 8e ff ff       	call   801006a0 <cprintf>
        return FAILED;
801077eb:	83 c4 10             	add    $0x10,%esp
801077ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077f3:	e9 e5 fe ff ff       	jmp    801076dd <sys_wpunmap+0x23d>
        cprintf("wpunmap ERROR: addr out of mmap range\n");
801077f8:	83 ec 0c             	sub    $0xc,%esp
801077fb:	68 04 95 10 80       	push   $0x80109504
80107800:	e8 9b 8e ff ff       	call   801006a0 <cprintf>
        return FAILED;
80107805:	83 c4 10             	add    $0x10,%esp
80107808:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010780d:	e9 cb fe ff ff       	jmp    801076dd <sys_wpunmap+0x23d>
        cprintf("wpunmap ERROR: unsupported flags for partial unmap\n");
80107812:	83 ec 0c             	sub    $0xc,%esp
80107815:	68 2c 95 10 80       	push   $0x8010952c
8010781a:	e8 81 8e ff ff       	call   801006a0 <cprintf>
        return FAILED;
8010781f:	83 c4 10             	add    $0x10,%esp
80107822:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107827:	e9 b1 fe ff ff       	jmp    801076dd <sys_wpunmap+0x23d>
        cprintf("wpunmap ERROR: partial unmap addr end not page aligned\n");
8010782c:	83 ec 0c             	sub    $0xc,%esp
8010782f:	68 a0 94 10 80       	push   $0x801094a0
80107834:	e8 67 8e ff ff       	call   801006a0 <cprintf>
        return FAILED;
80107839:	83 c4 10             	add    $0x10,%esp
8010783c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107841:	e9 97 fe ff ff       	jmp    801076dd <sys_wpunmap+0x23d>
        cprintf("wpunmap ERROR: partial unmap length <= 0\n");
80107846:	83 ec 0c             	sub    $0xc,%esp
80107849:	68 d8 94 10 80       	push   $0x801094d8
8010784e:	e8 4d 8e ff ff       	call   801006a0 <cprintf>
        return FAILED;
80107853:	83 c4 10             	add    $0x10,%esp
80107856:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010785b:	e9 7d fe ff ff       	jmp    801076dd <sys_wpunmap+0x23d>
        cprintf("wpunmap ERROR: overflow\n");
80107860:	83 ec 0c             	sub    $0xc,%esp
80107863:	68 46 96 10 80       	push   $0x80109646
80107868:	e8 33 8e ff ff       	call   801006a0 <cprintf>
        return FAILED;
8010786d:	83 c4 10             	add    $0x10,%esp
80107870:	83 c8 ff             	or     $0xffffffff,%eax
80107873:	e9 65 fe ff ff       	jmp    801076dd <sys_wpunmap+0x23d>
80107878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010787f:	90                   	nop

80107880 <sys_getwmapinfo>:
int sys_getwmapinfo(void) {
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
    if (argptr(0, (void *)&info, sizeof(*info)) < 0) {
80107885:	8d 45 e4             	lea    -0x1c(%ebp),%eax
int sys_getwmapinfo(void) {
80107888:	53                   	push   %ebx
80107889:	83 ec 40             	sub    $0x40,%esp
    if (argptr(0, (void *)&info, sizeof(*info)) < 0) {
8010788c:	68 84 01 00 00       	push   $0x184
80107891:	50                   	push   %eax
80107892:	6a 00                	push   $0x0
80107894:	e8 a7 d2 ff ff       	call   80104b40 <argptr>
80107899:	83 c4 10             	add    $0x10,%esp
8010789c:	85 c0                	test   %eax,%eax
8010789e:	0f 88 25 01 00 00    	js     801079c9 <sys_getwmapinfo+0x149>
    memset(info, 0, sizeof(*info));
801078a4:	83 ec 04             	sub    $0x4,%esp
801078a7:	68 84 01 00 00       	push   $0x184
801078ac:	6a 00                	push   $0x0
801078ae:	ff 75 e4             	push   -0x1c(%ebp)
801078b1:	e8 7a cf ff ff       	call   80104830 <memset>
    curproc = myproc();
801078b6:	e8 25 c2 ff ff       	call   80103ae0 <myproc>
    i = 0;
801078bb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    while (mmap && i < MAX_WMMAP_INFO) {
801078c2:	83 c4 10             	add    $0x10,%esp
    info->total_mmaps = curproc->total_mmaps;
801078c5:	8b 90 80 02 00 00    	mov    0x280(%eax),%edx
    curproc = myproc();
801078cb:	89 c3                	mov    %eax,%ebx
801078cd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    info->total_mmaps = curproc->total_mmaps;
801078d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078d3:	89 10                	mov    %edx,(%eax)
    mmap = curproc->mmap_head;
801078d5:	8b bb 7c 02 00 00    	mov    0x27c(%ebx),%edi
        info->addr[i] = mmap->addr;
801078db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078de:	89 fe                	mov    %edi,%esi
    while (mmap && i < MAX_WMMAP_INFO) {
801078e0:	85 ff                	test   %edi,%edi
801078e2:	0f 84 cc 00 00 00    	je     801079b4 <sys_getwmapinfo+0x134>
801078e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ef:	90                   	nop
        info->addr[i] = mmap->addr;
801078f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
801078f3:	8b 0e                	mov    (%esi),%ecx
801078f5:	8d 3c 98             	lea    (%eax,%ebx,4),%edi
801078f8:	89 4f 04             	mov    %ecx,0x4(%edi)
        info->length[i] = mmap->length;
801078fb:	8b 4e 04             	mov    0x4(%esi),%ecx
801078fe:	89 4f 44             	mov    %ecx,0x44(%edi)
        info->flags[i] = mmap->flags;
80107901:	8b 4e 08             	mov    0x8(%esi),%ecx
80107904:	89 8f 84 00 00 00    	mov    %ecx,0x84(%edi)
        info->fd[i] = mmap->fd;
8010790a:	8b 4e 0c             	mov    0xc(%esi),%ecx
8010790d:	89 8f c4 00 00 00    	mov    %ecx,0xc4(%edi)
        info->refcnt[i] = mmap->refcnt;
80107913:	8b 4e 14             	mov    0x14(%esi),%ecx
80107916:	89 8f 04 01 00 00    	mov    %ecx,0x104(%edi)
        info->n_loaded_pages[i] = count_loaded_pages(curproc, mmap->addr, mmap->addr + (uint)mmap->length);
8010791c:	8b 1e                	mov    (%esi),%ebx
8010791e:	89 da                	mov    %ebx,%edx
80107920:	03 56 04             	add    0x4(%esi),%edx
80107923:	0f 82 97 00 00 00    	jb     801079c0 <sys_getwmapinfo+0x140>
    int cnt;

    cnt = 0;
    if (end < start)
        return 0;
    for (va = start; va < end; va += PGSIZE) {
80107929:	39 d3                	cmp    %edx,%ebx
8010792b:	0f 83 8f 00 00 00    	jae    801079c0 <sys_getwmapinfo+0x140>
    cnt = 0;
80107931:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
80107938:	89 75 cc             	mov    %esi,-0x34(%ebp)
8010793b:	8b 75 c4             	mov    -0x3c(%ebp),%esi
8010793e:	89 7d c8             	mov    %edi,-0x38(%ebp)
80107941:	89 df                	mov    %ebx,%edi
80107943:	89 d3                	mov    %edx,%ebx
80107945:	8d 76 00             	lea    0x0(%esi),%esi
    entry = walkpgdir(p->pgdir, (const void *)va, 0);
80107948:	83 ec 04             	sub    $0x4,%esp
8010794b:	6a 00                	push   $0x0
8010794d:	57                   	push   %edi
8010794e:	ff 76 04             	push   0x4(%esi)
80107951:	e8 1a f2 ff ff       	call   80106b70 <walkpgdir>
    if (entry == 0)
80107956:	83 c4 10             	add    $0x10,%esp
80107959:	85 c0                	test   %eax,%eax
8010795b:	74 18                	je     80107975 <sys_getwmapinfo+0xf5>
    if (((*entry & PTE_P) == 0) || ((*entry & PTE_U) == 0))
8010795d:	8b 00                	mov    (%eax),%eax
8010795f:	89 c1                	mov    %eax,%ecx
80107961:	83 e1 05             	and    $0x5,%ecx
80107964:	83 f9 05             	cmp    $0x5,%ecx
80107967:	75 0c                	jne    80107975 <sys_getwmapinfo+0xf5>
    return PTE_ADDR(*entry);
80107969:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (get_physical_page(p, va, 0) != 0)
            cnt++;
8010796e:	83 f8 01             	cmp    $0x1,%eax
80107971:	83 5d d4 ff          	sbbl   $0xffffffff,-0x2c(%ebp)
    for (va = start; va < end; va += PGSIZE) {
80107975:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010797b:	39 fb                	cmp    %edi,%ebx
8010797d:	77 c9                	ja     80107948 <sys_getwmapinfo+0xc8>
        mmap->n_loaded_pages = info->n_loaded_pages[i];
8010797f:	8b 75 cc             	mov    -0x34(%ebp),%esi
80107982:	8b 7d c8             	mov    -0x38(%ebp),%edi
80107985:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107988:	8b 55 d0             	mov    -0x30(%ebp),%edx
        info->n_loaded_pages[i] = count_loaded_pages(curproc, mmap->addr, mmap->addr + (uint)mmap->length);
8010798b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
8010798e:	89 9f 44 01 00 00    	mov    %ebx,0x144(%edi)
        mmap->n_loaded_pages = info->n_loaded_pages[i];
80107994:	8b 8c 90 44 01 00 00 	mov    0x144(%eax,%edx,4),%ecx
        i++;
8010799b:	83 c2 01             	add    $0x1,%edx
8010799e:	89 55 d0             	mov    %edx,-0x30(%ebp)
        mmap->n_loaded_pages = info->n_loaded_pages[i];
801079a1:	89 4e 18             	mov    %ecx,0x18(%esi)
        mmap = mmap->next;
801079a4:	8b 76 1c             	mov    0x1c(%esi),%esi
    while (mmap && i < MAX_WMMAP_INFO) {
801079a7:	85 f6                	test   %esi,%esi
801079a9:	74 09                	je     801079b4 <sys_getwmapinfo+0x134>
801079ab:	83 fa 0f             	cmp    $0xf,%edx
801079ae:	0f 8e 3c ff ff ff    	jle    801078f0 <sys_getwmapinfo+0x70>
    return 0;
801079b4:	31 c0                	xor    %eax,%eax
}
801079b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079b9:	5b                   	pop    %ebx
801079ba:	5e                   	pop    %esi
801079bb:	5f                   	pop    %edi
801079bc:	5d                   	pop    %ebp
801079bd:	c3                   	ret    
801079be:	66 90                	xchg   %ax,%ax
    cnt = 0;
801079c0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801079c7:	eb bf                	jmp    80107988 <sys_getwmapinfo+0x108>
        cprintf("getwmapinfo arg ERROR\n");
801079c9:	83 ec 0c             	sub    $0xc,%esp
801079cc:	68 5f 96 10 80       	push   $0x8010965f
801079d1:	e8 ca 8c ff ff       	call   801006a0 <cprintf>
        return FAILED;
801079d6:	83 c4 10             	add    $0x10,%esp
801079d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079de:	eb d6                	jmp    801079b6 <sys_getwmapinfo+0x136>

801079e0 <sys_getpgdirinfo>:
int sys_getpgdirinfo(void) {
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	57                   	push   %edi
801079e4:	56                   	push   %esi
    if (argptr(0, (void *)&info, sizeof(*info)) < 0) {
801079e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
int sys_getpgdirinfo(void) {
801079e8:	53                   	push   %ebx
801079e9:	83 ec 20             	sub    $0x20,%esp
    if (argptr(0, (void *)&info, sizeof(*info)) < 0) {
801079ec:	68 04 01 00 00       	push   $0x104
801079f1:	50                   	push   %eax
801079f2:	6a 00                	push   $0x0
801079f4:	e8 47 d1 ff ff       	call   80104b40 <argptr>
801079f9:	83 c4 10             	add    $0x10,%esp
801079fc:	85 c0                	test   %eax,%eax
801079fe:	78 73                	js     80107a73 <sys_getpgdirinfo+0x93>
    memset(info, 0, sizeof(*info));
80107a00:	83 ec 04             	sub    $0x4,%esp
    nfill = 0;
80107a03:	31 db                	xor    %ebx,%ebx
    for (va = 0; va < KERNBASE; va += PGSIZE) {
80107a05:	31 ff                	xor    %edi,%edi
    memset(info, 0, sizeof(*info));
80107a07:	68 04 01 00 00       	push   $0x104
80107a0c:	6a 00                	push   $0x0
80107a0e:	ff 75 e4             	push   -0x1c(%ebp)
80107a11:	e8 1a ce ff ff       	call   80104830 <memset>
    curproc = myproc();
80107a16:	e8 c5 c0 ff ff       	call   80103ae0 <myproc>
80107a1b:	83 c4 10             	add    $0x10,%esp
80107a1e:	89 c6                	mov    %eax,%esi
    entry = walkpgdir(p->pgdir, (const void *)va, 0);
80107a20:	83 ec 04             	sub    $0x4,%esp
80107a23:	6a 00                	push   $0x0
80107a25:	57                   	push   %edi
80107a26:	ff 76 04             	push   0x4(%esi)
80107a29:	e8 42 f1 ff ff       	call   80106b70 <walkpgdir>
    if (entry == 0)
80107a2e:	83 c4 10             	add    $0x10,%esp
80107a31:	85 c0                	test   %eax,%eax
80107a33:	74 2c                	je     80107a61 <sys_getpgdirinfo+0x81>
    if (((*entry & PTE_P) == 0) || ((*entry & PTE_U) == 0))
80107a35:	8b 00                	mov    (%eax),%eax
80107a37:	89 c2                	mov    %eax,%edx
80107a39:	83 e2 05             	and    $0x5,%edx
80107a3c:	83 fa 05             	cmp    $0x5,%edx
80107a3f:	75 20                	jne    80107a61 <sys_getpgdirinfo+0x81>
        if (pa == 0)
80107a41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a46:	74 19                	je     80107a61 <sys_getpgdirinfo+0x81>
            info->va[nfill] = va;
80107a48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        if (nfill < MAX_UPAGE_INFO) {
80107a4b:	83 fb 1f             	cmp    $0x1f,%ebx
80107a4e:	7f 0e                	jg     80107a5e <sys_getpgdirinfo+0x7e>
            info->va[nfill] = va;
80107a50:	89 7c 9a 04          	mov    %edi,0x4(%edx,%ebx,4)
            info->pa[nfill] = pa;
80107a54:	89 84 9a 84 00 00 00 	mov    %eax,0x84(%edx,%ebx,4)
            nfill++;
80107a5b:	83 c3 01             	add    $0x1,%ebx
        info->n_upages++;
80107a5e:	83 02 01             	addl   $0x1,(%edx)
    for (va = 0; va < KERNBASE; va += PGSIZE) {
80107a61:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107a67:	79 b7                	jns    80107a20 <sys_getpgdirinfo+0x40>
    return 0;
80107a69:	31 c0                	xor    %eax,%eax
}
80107a6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a6e:	5b                   	pop    %ebx
80107a6f:	5e                   	pop    %esi
80107a70:	5f                   	pop    %edi
80107a71:	5d                   	pop    %ebp
80107a72:	c3                   	ret    
        return FAILED;
80107a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a78:	eb f1                	jmp    80107a6b <sys_getpgdirinfo+0x8b>
80107a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a80 <validate_input>:
int validate_input(uint addr, int length, int flags, int fd, struct file *f) {
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	56                   	push   %esi
80107a84:	8b 75 0c             	mov    0xc(%ebp),%esi
80107a87:	53                   	push   %ebx
80107a88:	8b 5d 10             	mov    0x10(%ebp),%ebx
    if (length <= 0) return FAILED;
80107a8b:	85 f6                	test   %esi,%esi
80107a8d:	0f 8e 7d 00 00 00    	jle    80107b10 <validate_input+0x90>
    if (!!(flags & MAP_PRIVATE) == !!(flags & MAP_SHARED)) return FAILED;
80107a93:	89 da                	mov    %ebx,%edx
80107a95:	89 d8                	mov    %ebx,%eax
80107a97:	f7 d2                	not    %edx
80107a99:	d1 e8                	shr    %eax
80107a9b:	83 e2 01             	and    $0x1,%edx
80107a9e:	83 e0 01             	and    $0x1,%eax
80107aa1:	38 c2                	cmp    %al,%dl
80107aa3:	75 6b                	jne    80107b10 <validate_input+0x90>
    if (flags & ~known_flags) return FAILED;
80107aa5:	f7 c3 f0 ff ff ff    	test   $0xfffffff0,%ebx
80107aab:	75 63                	jne    80107b10 <validate_input+0x90>
    if (!(flags & MAP_ANONYMOUS) && (fd < 0 || f == 0)) return FAILED;
80107aad:	f6 c3 04             	test   $0x4,%bl
80107ab0:	75 0e                	jne    80107ac0 <validate_input+0x40>
80107ab2:	8b 55 14             	mov    0x14(%ebp),%edx
80107ab5:	85 d2                	test   %edx,%edx
80107ab7:	78 57                	js     80107b10 <validate_input+0x90>
80107ab9:	8b 45 18             	mov    0x18(%ebp),%eax
80107abc:	85 c0                	test   %eax,%eax
80107abe:	74 50                	je     80107b10 <validate_input+0x90>
    if (myproc()->total_mmaps >= MAX_NMMAP) return FAILED;
80107ac0:	e8 1b c0 ff ff       	call   80103ae0 <myproc>
80107ac5:	83 b8 80 02 00 00 0f 	cmpl   $0xf,0x280(%eax)
80107acc:	7f 42                	jg     80107b10 <validate_input+0x90>
    if ((uint)length > (uint)(0x80000000 - 0x60000000)) return FAILED;
80107ace:	81 fe 00 00 00 20    	cmp    $0x20000000,%esi
80107ad4:	7f 3a                	jg     80107b10 <validate_input+0x90>
    if (flags & MAP_FIXED) {
80107ad6:	89 d8                	mov    %ebx,%eax
80107ad8:	83 e0 08             	and    $0x8,%eax
80107adb:	74 2f                	je     80107b0c <validate_input+0x8c>
        if (addr % PGSIZE != 0) return FAILED;
80107add:	f7 45 08 ff 0f 00 00 	testl  $0xfff,0x8(%ebp)
80107ae4:	75 2a                	jne    80107b10 <validate_input+0x90>
        if (addr < 0x60000000 || addr >= 0x80000000) return FAILED;
80107ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ae9:	2d 00 00 00 60       	sub    $0x60000000,%eax
80107aee:	3d ff ff ff 1f       	cmp    $0x1fffffff,%eax
80107af3:	77 1b                	ja     80107b10 <validate_input+0x90>
        end = addr + (uint)length;
80107af5:	31 d2                	xor    %edx,%edx
80107af7:	03 75 08             	add    0x8(%ebp),%esi
80107afa:	0f 92 c2             	setb   %dl
        if (end > 0x80000000) return FAILED; // out of mmap range
80107afd:	31 c0                	xor    %eax,%eax
80107aff:	81 fe 00 00 00 80    	cmp    $0x80000000,%esi
80107b05:	0f 97 c0             	seta   %al
80107b08:	09 d0                	or     %edx,%eax
80107b0a:	f7 d8                	neg    %eax
}
80107b0c:	5b                   	pop    %ebx
80107b0d:	5e                   	pop    %esi
80107b0e:	5d                   	pop    %ebp
80107b0f:	c3                   	ret    
    if (length <= 0) return FAILED;
80107b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b15:	eb f5                	jmp    80107b0c <validate_input+0x8c>
80107b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b1e:	66 90                	xchg   %ax,%ax

80107b20 <find_unused_mmap>:
struct mmap_region *find_unused_mmap(struct proc *proc) {
80107b20:	55                   	push   %ebp
    for (i = 0; i < MAX_NMMAP; i++) {
80107b21:	31 c0                	xor    %eax,%eax
struct mmap_region *find_unused_mmap(struct proc *proc) {
80107b23:	89 e5                	mov    %esp,%ebp
80107b25:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b2f:	90                   	nop
        if (proc->mmaps[i].addr == (uint)-1)
80107b30:	89 c2                	mov    %eax,%edx
80107b32:	c1 e2 05             	shl    $0x5,%edx
80107b35:	83 7c 11 7c ff       	cmpl   $0xffffffff,0x7c(%ecx,%edx,1)
80107b3a:	74 14                	je     80107b50 <find_unused_mmap+0x30>
    for (i = 0; i < MAX_NMMAP; i++) {
80107b3c:	83 c0 01             	add    $0x1,%eax
80107b3f:	83 f8 10             	cmp    $0x10,%eax
80107b42:	75 ec                	jne    80107b30 <find_unused_mmap+0x10>
    return (struct mmap_region*)0;
80107b44:	31 c0                	xor    %eax,%eax
}
80107b46:	5d                   	pop    %ebp
80107b47:	c3                   	ret    
80107b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b4f:	90                   	nop
            return &proc->mmaps[i];
80107b50:	8d 44 11 7c          	lea    0x7c(%ecx,%edx,1),%eax
}
80107b54:	5d                   	pop    %ebp
80107b55:	c3                   	ret    
80107b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b5d:	8d 76 00             	lea    0x0(%esi),%esi

80107b60 <fix_addr_place_mmap>:
struct mmap_region *fix_addr_place_mmap(struct proc *proc, uint addr, int length, int flags) {
80107b60:	55                   	push   %ebp
    for (i = 0; i < MAX_NMMAP; i++) {
80107b61:	31 d2                	xor    %edx,%edx
struct mmap_region *fix_addr_place_mmap(struct proc *proc, uint addr, int length, int flags) {
80107b63:	89 e5                	mov    %esp,%ebp
80107b65:	57                   	push   %edi
80107b66:	56                   	push   %esi
80107b67:	53                   	push   %ebx
80107b68:	83 ec 10             	sub    $0x10,%esp
80107b6b:	8b 75 0c             	mov    0xc(%ebp),%esi
    for (i = 0; i < MAX_NMMAP; i++) {
80107b6e:	8b 45 08             	mov    0x8(%ebp),%eax
80107b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (proc->mmaps[i].addr == (uint)-1)
80107b78:	89 d3                	mov    %edx,%ebx
80107b7a:	c1 e3 05             	shl    $0x5,%ebx
80107b7d:	83 7c 18 7c ff       	cmpl   $0xffffffff,0x7c(%eax,%ebx,1)
80107b82:	74 1c                	je     80107ba0 <fix_addr_place_mmap+0x40>
    for (i = 0; i < MAX_NMMAP; i++) {
80107b84:	83 c2 01             	add    $0x1,%edx
80107b87:	83 fa 10             	cmp    $0x10,%edx
80107b8a:	75 ec                	jne    80107b78 <fix_addr_place_mmap+0x18>
        return (struct mmap_region*)0;
80107b8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
}
80107b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b96:	83 c4 10             	add    $0x10,%esp
80107b99:	5b                   	pop    %ebx
80107b9a:	5e                   	pop    %esi
80107b9b:	5f                   	pop    %edi
80107b9c:	5d                   	pop    %ebp
80107b9d:	c3                   	ret    
80107b9e:	66 90                	xchg   %ax,%ax
            return &proc->mmaps[i];
80107ba0:	8b 45 08             	mov    0x8(%ebp),%eax
    prev = 0;
80107ba3:	31 c9                	xor    %ecx,%ecx
            return &proc->mmaps[i];
80107ba5:	8d 44 18 7c          	lea    0x7c(%eax,%ebx,1),%eax
80107ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    end = addr + (uint)length;
80107bac:	8b 45 10             	mov    0x10(%ebp),%eax
80107baf:	01 f0                	add    %esi,%eax
80107bb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    cur = proc->mmap_head;
80107bb4:	8b 45 08             	mov    0x8(%ebp),%eax
80107bb7:	8b 80 7c 02 00 00    	mov    0x27c(%eax),%eax
    while (cur) {
80107bbd:	85 c0                	test   %eax,%eax
80107bbf:	0f 84 17 01 00 00    	je     80107cdc <fix_addr_place_mmap+0x17c>
80107bc5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107bc8:	89 cf                	mov    %ecx,%edi
80107bca:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80107bcd:	89 55 e8             	mov    %edx,-0x18(%ebp)
80107bd0:	eb 19                	jmp    80107beb <fix_addr_place_mmap+0x8b>
80107bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (cur_start > start)
80107bd8:	39 d6                	cmp    %edx,%esi
80107bda:	72 22                	jb     80107bfe <fix_addr_place_mmap+0x9e>
        cur = cur->next;
80107bdc:	8b 50 1c             	mov    0x1c(%eax),%edx
    while (cur) {
80107bdf:	89 c7                	mov    %eax,%edi
80107be1:	85 d2                	test   %edx,%edx
80107be3:	0f 84 87 00 00 00    	je     80107c70 <fix_addr_place_mmap+0x110>
80107be9:	89 d0                	mov    %edx,%eax
        cur_start = cur->addr;
80107beb:	8b 10                	mov    (%eax),%edx
        cur_end = cur->addr + (uint)cur->length;
80107bed:	8b 48 04             	mov    0x4(%eax),%ecx
80107bf0:	01 d1                	add    %edx,%ecx
        if (start < cur_end && cur_start < end)
80107bf2:	39 ce                	cmp    %ecx,%esi
80107bf4:	73 e2                	jae    80107bd8 <fix_addr_place_mmap+0x78>
80107bf6:	39 d3                	cmp    %edx,%ebx
80107bf8:	77 92                	ja     80107b8c <fix_addr_place_mmap+0x2c>
        if (cur_start > start)
80107bfa:	39 d6                	cmp    %edx,%esi
80107bfc:	73 de                	jae    80107bdc <fix_addr_place_mmap+0x7c>
    mmap->flags = -1;
80107bfe:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107c01:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80107c04:	89 f9                	mov    %edi,%ecx
80107c06:	03 5d 08             	add    0x8(%ebp),%ebx
80107c09:	c1 e2 05             	shl    $0x5,%edx
80107c0c:	03 55 08             	add    0x8(%ebp),%edx
80107c0f:	c7 82 84 00 00 00 ff 	movl   $0xffffffff,0x84(%edx)
80107c16:	ff ff ff 
    mmap->fd = -1;
80107c19:	c7 82 88 00 00 00 ff 	movl   $0xffffffff,0x88(%edx)
80107c20:	ff ff ff 
    mmap->f = 0;
80107c23:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80107c2a:	00 00 00 
    mmap->refcnt = 0;
80107c2d:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80107c34:	00 00 00 
    mmap->n_loaded_pages = 0;
80107c37:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80107c3e:	00 00 00 
    slot->addr = addr;
80107c41:	89 72 7c             	mov    %esi,0x7c(%edx)
    slot->length = length;
80107c44:	8b 75 10             	mov    0x10(%ebp),%esi
80107c47:	89 b2 80 00 00 00    	mov    %esi,0x80(%edx)
    slot->next = cur;
80107c4d:	89 83 98 00 00 00    	mov    %eax,0x98(%ebx)
    if (prev == 0)
80107c53:	85 ff                	test   %edi,%edi
80107c55:	75 74                	jne    80107ccb <fix_addr_place_mmap+0x16b>
        proc->mmap_head = slot;
80107c57:	8b 45 08             	mov    0x8(%ebp),%eax
80107c5a:	8b 7d f0             	mov    -0x10(%ebp),%edi
80107c5d:	89 b8 7c 02 00 00    	mov    %edi,0x27c(%eax)
}
80107c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c66:	83 c4 10             	add    $0x10,%esp
80107c69:	5b                   	pop    %ebx
80107c6a:	5e                   	pop    %esi
80107c6b:	5f                   	pop    %edi
80107c6c:	5d                   	pop    %ebp
80107c6d:	c3                   	ret    
80107c6e:	66 90                	xchg   %ax,%ax
80107c70:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107c73:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    mmap->flags = -1;
80107c76:	89 c1                	mov    %eax,%ecx
80107c78:	8b 45 08             	mov    0x8(%ebp),%eax
    slot->length = length;
80107c7b:	8b 7d 10             	mov    0x10(%ebp),%edi
    mmap->flags = -1;
80107c7e:	c1 e2 05             	shl    $0x5,%edx
80107c81:	03 55 08             	add    0x8(%ebp),%edx
80107c84:	c7 82 84 00 00 00 ff 	movl   $0xffffffff,0x84(%edx)
80107c8b:	ff ff ff 
    mmap->fd = -1;
80107c8e:	01 d8                	add    %ebx,%eax
80107c90:	c7 82 88 00 00 00 ff 	movl   $0xffffffff,0x88(%edx)
80107c97:	ff ff ff 
    mmap->f = 0;
80107c9a:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80107ca1:	00 00 00 
    mmap->refcnt = 0;
80107ca4:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80107cab:	00 00 00 
    mmap->n_loaded_pages = 0;
80107cae:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80107cb5:	00 00 00 
    slot->addr = addr;
80107cb8:	89 72 7c             	mov    %esi,0x7c(%edx)
    slot->length = length;
80107cbb:	89 ba 80 00 00 00    	mov    %edi,0x80(%edx)
    slot->next = cur;
80107cc1:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80107cc8:	00 00 00 
        prev->next = slot;
80107ccb:	8b 7d f0             	mov    -0x10(%ebp),%edi
}
80107cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
        prev->next = slot;
80107cd1:	89 79 1c             	mov    %edi,0x1c(%ecx)
}
80107cd4:	83 c4 10             	add    $0x10,%esp
80107cd7:	5b                   	pop    %ebx
80107cd8:	5e                   	pop    %esi
80107cd9:	5f                   	pop    %edi
80107cda:	5d                   	pop    %ebp
80107cdb:	c3                   	ret    
    slot->length = length;
80107cdc:	8b 45 10             	mov    0x10(%ebp),%eax
    mmap->flags = -1;
80107cdf:	03 5d 08             	add    0x8(%ebp),%ebx
80107ce2:	c7 83 84 00 00 00 ff 	movl   $0xffffffff,0x84(%ebx)
80107ce9:	ff ff ff 
    mmap->fd = -1;
80107cec:	c7 83 88 00 00 00 ff 	movl   $0xffffffff,0x88(%ebx)
80107cf3:	ff ff ff 
    mmap->f = 0;
80107cf6:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80107cfd:	00 00 00 
    mmap->refcnt = 0;
80107d00:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80107d07:	00 00 00 
    mmap->n_loaded_pages = 0;
80107d0a:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80107d11:	00 00 00 
    slot->addr = addr;
80107d14:	89 73 7c             	mov    %esi,0x7c(%ebx)
    slot->length = length;
80107d17:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
    slot->next = cur;
80107d1d:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80107d24:	00 00 00 
    if (prev == 0)
80107d27:	e9 2b ff ff ff       	jmp    80107c57 <fix_addr_place_mmap+0xf7>
80107d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107d30 <find_addr_place_mmap>:
struct mmap_region *find_addr_place_mmap(struct proc *proc, int length, int flags) {
80107d30:	55                   	push   %ebp
    for (i = 0; i < MAX_NMMAP; i++) {
80107d31:	31 c9                	xor    %ecx,%ecx
struct mmap_region *find_addr_place_mmap(struct proc *proc, int length, int flags) {
80107d33:	89 e5                	mov    %esp,%ebp
80107d35:	57                   	push   %edi
80107d36:	56                   	push   %esi
80107d37:	53                   	push   %ebx
80107d38:	83 ec 0c             	sub    $0xc,%esp
    for (i = 0; i < MAX_NMMAP; i++) {
80107d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80107d3e:	66 90                	xchg   %ax,%ax
        if (proc->mmaps[i].addr == (uint)-1)
80107d40:	89 cf                	mov    %ecx,%edi
80107d42:	c1 e7 05             	shl    $0x5,%edi
80107d45:	83 7c 38 7c ff       	cmpl   $0xffffffff,0x7c(%eax,%edi,1)
80107d4a:	74 14                	je     80107d60 <find_addr_place_mmap+0x30>
    for (i = 0; i < MAX_NMMAP; i++) {
80107d4c:	83 c1 01             	add    $0x1,%ecx
80107d4f:	83 f9 10             	cmp    $0x10,%ecx
80107d52:	75 ec                	jne    80107d40 <find_addr_place_mmap+0x10>
}
80107d54:	83 c4 0c             	add    $0xc,%esp
        return (struct mmap_region*)0;
80107d57:	31 db                	xor    %ebx,%ebx
}
80107d59:	89 d8                	mov    %ebx,%eax
80107d5b:	5b                   	pop    %ebx
80107d5c:	5e                   	pop    %esi
80107d5d:	5f                   	pop    %edi
80107d5e:	5d                   	pop    %ebp
80107d5f:	c3                   	ret    
    cur = proc->mmap_head;
80107d60:	8b 45 08             	mov    0x8(%ebp),%eax
    prev = 0;
80107d63:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    cur = proc->mmap_head;
80107d6a:	8b 90 7c 02 00 00    	mov    0x27c(%eax),%edx
    addr = 0x60000000;
80107d70:	b8 00 00 00 60       	mov    $0x60000000,%eax
    while (cur) {
80107d75:	85 d2                	test   %edx,%edx
80107d77:	0f 84 16 01 00 00    	je     80107e93 <find_addr_place_mmap+0x163>
80107d7d:	89 7d ec             	mov    %edi,-0x14(%ebp)
80107d80:	31 f6                	xor    %esi,%esi
80107d82:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107d85:	89 4d f0             	mov    %ecx,-0x10(%ebp)
80107d88:	eb 08                	jmp    80107d92 <find_addr_place_mmap+0x62>
80107d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d90:	89 ca                	mov    %ecx,%edx
        end = addr + (uint)length;
80107d92:	89 c3                	mov    %eax,%ebx
        if (end < addr || end > cur->addr)
80107d94:	8b 0a                	mov    (%edx),%ecx
80107d96:	01 fb                	add    %edi,%ebx
80107d98:	72 08                	jb     80107da2 <find_addr_place_mmap+0x72>
80107d9a:	39 cb                	cmp    %ecx,%ebx
80107d9c:	0f 86 be 00 00 00    	jbe    80107e60 <find_addr_place_mmap+0x130>
        addr = PGROUNDUP(cur_end);
80107da2:	8b 42 04             	mov    0x4(%edx),%eax
80107da5:	89 d6                	mov    %edx,%esi
80107da7:	8d 84 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%eax
        cur = cur->next;
80107dae:	8b 4a 1c             	mov    0x1c(%edx),%ecx
        addr = PGROUNDUP(cur_end);
80107db1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    while (cur) {
80107db6:	85 c9                	test   %ecx,%ecx
80107db8:	75 d6                	jne    80107d90 <find_addr_place_mmap+0x60>
    end = addr + (uint)length;
80107dba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107dbd:	89 ce                	mov    %ecx,%esi
80107dbf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107dc2:	8b 7d ec             	mov    -0x14(%ebp),%edi
80107dc5:	01 c3                	add    %eax,%ebx
    if (end < addr || addr < 0x60000000 || end > 0x80000000)
80107dc7:	3d ff ff ff 5f       	cmp    $0x5fffffff,%eax
80107dcc:	0f 96 45 ec          	setbe  -0x14(%ebp)
80107dd0:	39 d8                	cmp    %ebx,%eax
80107dd2:	0f 97 45 f0          	seta   -0x10(%ebp)
80107dd6:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107ddc:	0f 97 c3             	seta   %bl
80107ddf:	0a 5d f0             	or     -0x10(%ebp),%bl
80107de2:	0f 85 6c ff ff ff    	jne    80107d54 <find_addr_place_mmap+0x24>
80107de8:	80 7d ec 00          	cmpb   $0x0,-0x14(%ebp)
80107dec:	0f 85 62 ff ff ff    	jne    80107d54 <find_addr_place_mmap+0x24>
            return &proc->mmaps[i];
80107df2:	8b 5d 08             	mov    0x8(%ebp),%ebx
    mmap->flags = -1;
80107df5:	c1 e1 05             	shl    $0x5,%ecx
80107df8:	03 4d 08             	add    0x8(%ebp),%ecx
80107dfb:	c7 81 84 00 00 00 ff 	movl   $0xffffffff,0x84(%ecx)
80107e02:	ff ff ff 
    mmap->fd = -1;
80107e05:	c7 81 88 00 00 00 ff 	movl   $0xffffffff,0x88(%ecx)
80107e0c:	ff ff ff 
            return &proc->mmaps[i];
80107e0f:	8d 5c 3b 7c          	lea    0x7c(%ebx,%edi,1),%ebx
    mmap->f = 0;
80107e13:	03 7d 08             	add    0x8(%ebp),%edi
80107e16:	c7 87 8c 00 00 00 00 	movl   $0x0,0x8c(%edi)
80107e1d:	00 00 00 
    mmap->refcnt = 0;
80107e20:	c7 87 90 00 00 00 00 	movl   $0x0,0x90(%edi)
80107e27:	00 00 00 
    mmap->n_loaded_pages = 0;
80107e2a:	c7 87 94 00 00 00 00 	movl   $0x0,0x94(%edi)
80107e31:	00 00 00 
    slot->addr = addr;
80107e34:	89 41 7c             	mov    %eax,0x7c(%ecx)
    slot->length = length;
80107e37:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e3a:	89 81 80 00 00 00    	mov    %eax,0x80(%ecx)
    slot->next = cur;
80107e40:	89 b7 98 00 00 00    	mov    %esi,0x98(%edi)
    if (prev == 0)
80107e46:	85 d2                	test   %edx,%edx
80107e48:	74 36                	je     80107e80 <find_addr_place_mmap+0x150>
        prev->next = slot;
80107e4a:	89 5a 1c             	mov    %ebx,0x1c(%edx)
}
80107e4d:	83 c4 0c             	add    $0xc,%esp
80107e50:	89 d8                	mov    %ebx,%eax
80107e52:	5b                   	pop    %ebx
80107e53:	5e                   	pop    %esi
80107e54:	5f                   	pop    %edi
80107e55:	5d                   	pop    %ebp
80107e56:	c3                   	ret    
80107e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e5e:	66 90                	xchg   %ax,%ax
    if (end < addr || addr < 0x60000000 || end > 0x80000000)
80107e60:	3d ff ff ff 5f       	cmp    $0x5fffffff,%eax
80107e65:	8b 7d ec             	mov    -0x14(%ebp),%edi
80107e68:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107e6b:	89 75 e8             	mov    %esi,-0x18(%ebp)
80107e6e:	0f 96 45 ec          	setbe  -0x14(%ebp)
80107e72:	89 d6                	mov    %edx,%esi
80107e74:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107e77:	e9 54 ff ff ff       	jmp    80107dd0 <find_addr_place_mmap+0xa0>
80107e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        proc->mmap_head = slot;
80107e80:	8b 45 08             	mov    0x8(%ebp),%eax
80107e83:	89 98 7c 02 00 00    	mov    %ebx,0x27c(%eax)
}
80107e89:	83 c4 0c             	add    $0xc,%esp
80107e8c:	89 d8                	mov    %ebx,%eax
80107e8e:	5b                   	pop    %ebx
80107e8f:	5e                   	pop    %esi
80107e90:	5f                   	pop    %edi
80107e91:	5d                   	pop    %ebp
80107e92:	c3                   	ret    
    end = addr + (uint)length;
80107e93:	8b 75 0c             	mov    0xc(%ebp),%esi
80107e96:	c6 45 ec 00          	movb   $0x0,-0x14(%ebp)
80107e9a:	8d 9e 00 00 00 60    	lea    0x60000000(%esi),%ebx
80107ea0:	31 f6                	xor    %esi,%esi
80107ea2:	e9 29 ff ff ff       	jmp    80107dd0 <find_addr_place_mmap+0xa0>
80107ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eae:	66 90                	xchg   %ax,%ax

80107eb0 <sys_wmap>:
int sys_wmap(void) {
80107eb0:	55                   	push   %ebp
80107eb1:	89 e5                	mov    %esp,%ebp
80107eb3:	53                   	push   %ebx
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0 || argint(2, &flags) < 0) {
80107eb4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
int sys_wmap(void) {
80107eb7:	83 ec 2c             	sub    $0x2c,%esp
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0 || argint(2, &flags) < 0) {
80107eba:	50                   	push   %eax
80107ebb:	6a 00                	push   $0x0
80107ebd:	e8 2e cc ff ff       	call   80104af0 <argint>
80107ec2:	83 c4 10             	add    $0x10,%esp
80107ec5:	85 c0                	test   %eax,%eax
80107ec7:	0f 88 3b 01 00 00    	js     80108008 <sys_wmap+0x158>
80107ecd:	83 ec 08             	sub    $0x8,%esp
80107ed0:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107ed3:	50                   	push   %eax
80107ed4:	6a 01                	push   $0x1
80107ed6:	e8 15 cc ff ff       	call   80104af0 <argint>
80107edb:	83 c4 10             	add    $0x10,%esp
80107ede:	85 c0                	test   %eax,%eax
80107ee0:	0f 88 22 01 00 00    	js     80108008 <sys_wmap+0x158>
80107ee6:	83 ec 08             	sub    $0x8,%esp
80107ee9:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107eec:	50                   	push   %eax
80107eed:	6a 02                	push   $0x2
80107eef:	e8 fc cb ff ff       	call   80104af0 <argint>
80107ef4:	83 c4 10             	add    $0x10,%esp
80107ef7:	85 c0                	test   %eax,%eax
80107ef9:	0f 88 09 01 00 00    	js     80108008 <sys_wmap+0x158>
    if (argfd(3, &fd, &f) < 0) {
80107eff:	83 ec 04             	sub    $0x4,%esp
80107f02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f05:	50                   	push   %eax
80107f06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107f09:	50                   	push   %eax
80107f0a:	6a 03                	push   $0x3
80107f0c:	e8 2f cf ff ff       	call   80104e40 <argfd>
80107f11:	83 c4 10             	add    $0x10,%esp
80107f14:	85 c0                	test   %eax,%eax
80107f16:	0f 89 cc 00 00 00    	jns    80107fe8 <sys_wmap+0x138>
        fd = -1;
80107f1c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
        f = 0;
80107f23:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107f28:	31 c0                	xor    %eax,%eax
80107f2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (validate_input(addr, length, flags, fd, f) < 0) {
80107f31:	83 ec 0c             	sub    $0xc,%esp
80107f34:	50                   	push   %eax
80107f35:	52                   	push   %edx
80107f36:	ff 75 ec             	push   -0x14(%ebp)
80107f39:	ff 75 e8             	push   -0x18(%ebp)
80107f3c:	ff 75 e4             	push   -0x1c(%ebp)
80107f3f:	e8 3c fb ff ff       	call   80107a80 <validate_input>
80107f44:	83 c4 20             	add    $0x20,%esp
80107f47:	85 c0                	test   %eax,%eax
80107f49:	0f 88 d0 00 00 00    	js     8010801f <sys_wmap+0x16f>
    if (flags & MAP_ANONYMOUS) {
80107f4f:	f6 45 ec 04          	testb  $0x4,-0x14(%ebp)
80107f53:	74 1a                	je     80107f6f <sys_wmap+0xbf>
        if (f)
80107f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f58:	85 c0                	test   %eax,%eax
80107f5a:	74 0c                	je     80107f68 <sys_wmap+0xb8>
            fileclose(f);
80107f5c:	83 ec 0c             	sub    $0xc,%esp
80107f5f:	50                   	push   %eax
80107f60:	e8 8b 8f ff ff       	call   80100ef0 <fileclose>
80107f65:	83 c4 10             	add    $0x10,%esp
        f = 0;
80107f68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    curproc = myproc();
80107f6f:	e8 6c bb ff ff       	call   80103ae0 <myproc>
80107f74:	89 c3                	mov    %eax,%ebx
    if (flags & MAP_FIXED)
80107f76:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f79:	a8 08                	test   $0x8,%al
80107f7b:	75 53                	jne    80107fd0 <sys_wmap+0x120>
        mmap = find_addr_place_mmap(curproc, length, flags);
80107f7d:	83 ec 04             	sub    $0x4,%esp
80107f80:	50                   	push   %eax
80107f81:	ff 75 e8             	push   -0x18(%ebp)
80107f84:	53                   	push   %ebx
80107f85:	e8 a6 fd ff ff       	call   80107d30 <find_addr_place_mmap>
80107f8a:	83 c4 10             	add    $0x10,%esp
        if (f)
80107f8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    if (mmap == 0) {
80107f90:	85 c0                	test   %eax,%eax
80107f92:	0f 84 b4 00 00 00    	je     8010804c <sys_wmap+0x19c>
    mmap->length = length;
80107f98:	8b 4d e8             	mov    -0x18(%ebp),%ecx
    mmap->f = f;
80107f9b:	89 50 10             	mov    %edx,0x10(%eax)
    mmap->refcnt = 0;
80107f9e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    mmap->length = length;
80107fa5:	89 48 04             	mov    %ecx,0x4(%eax)
    mmap->flags = flags;
80107fa8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    mmap->n_loaded_pages = 0;
80107fab:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    mmap->flags = flags;
80107fb2:	89 48 08             	mov    %ecx,0x8(%eax)
    mmap->fd = fd;
80107fb5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107fb8:	89 48 0c             	mov    %ecx,0xc(%eax)
    curproc->total_mmaps++;
80107fbb:	83 83 80 02 00 00 01 	addl   $0x1,0x280(%ebx)
    return mmap->addr;
80107fc2:	8b 00                	mov    (%eax),%eax
}
80107fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107fc7:	c9                   	leave  
80107fc8:	c3                   	ret    
80107fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        mmap = fix_addr_place_mmap(curproc, addr, length, flags);
80107fd0:	50                   	push   %eax
80107fd1:	ff 75 e8             	push   -0x18(%ebp)
80107fd4:	ff 75 e4             	push   -0x1c(%ebp)
80107fd7:	53                   	push   %ebx
80107fd8:	e8 83 fb ff ff       	call   80107b60 <fix_addr_place_mmap>
80107fdd:	83 c4 10             	add    $0x10,%esp
80107fe0:	eb ab                	jmp    80107f8d <sys_wmap+0xdd>
80107fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        f = filedup(f);
80107fe8:	83 ec 0c             	sub    $0xc,%esp
80107feb:	ff 75 f4             	push   -0xc(%ebp)
80107fee:	e8 ad 8e ff ff       	call   80100ea0 <filedup>
    if (validate_input(addr, length, flags, fd, f) < 0) {
80107ff3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107ff6:	83 c4 10             	add    $0x10,%esp
        f = filedup(f);
80107ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ffc:	e9 30 ff ff ff       	jmp    80107f31 <sys_wmap+0x81>
80108001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf("wmap arg ERROR: size or flags\n");
80108008:	83 ec 0c             	sub    $0xc,%esp
8010800b:	68 b0 95 10 80       	push   $0x801095b0
80108010:	e8 8b 86 ff ff       	call   801006a0 <cprintf>
        return FAILED;
80108015:	83 c4 10             	add    $0x10,%esp
80108018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010801d:	eb a5                	jmp    80107fc4 <sys_wmap+0x114>
        if (f)
8010801f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108022:	85 c0                	test   %eax,%eax
80108024:	74 0c                	je     80108032 <sys_wmap+0x182>
            fileclose(f);
80108026:	83 ec 0c             	sub    $0xc,%esp
80108029:	50                   	push   %eax
8010802a:	e8 c1 8e ff ff       	call   80100ef0 <fileclose>
8010802f:	83 c4 10             	add    $0x10,%esp
        cprintf("wmap ERROR: invalid input\n");
80108032:	83 ec 0c             	sub    $0xc,%esp
80108035:	68 76 96 10 80       	push   $0x80109676
8010803a:	e8 61 86 ff ff       	call   801006a0 <cprintf>
        return FAILED;
8010803f:	83 c4 10             	add    $0x10,%esp
80108042:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108047:	e9 78 ff ff ff       	jmp    80107fc4 <sys_wmap+0x114>
        if (f)
8010804c:	85 d2                	test   %edx,%edx
8010804e:	74 0c                	je     8010805c <sys_wmap+0x1ac>
            fileclose(f);
80108050:	83 ec 0c             	sub    $0xc,%esp
80108053:	52                   	push   %edx
80108054:	e8 97 8e ff ff       	call   80100ef0 <fileclose>
80108059:	83 c4 10             	add    $0x10,%esp
        cprintf("wmap ERROR: failed to place mapping\n");
8010805c:	83 ec 0c             	sub    $0xc,%esp
8010805f:	68 d0 95 10 80       	push   $0x801095d0
80108064:	e8 37 86 ff ff       	call   801006a0 <cprintf>
        return FAILED;
80108069:	83 c4 10             	add    $0x10,%esp
8010806c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108071:	e9 4e ff ff ff       	jmp    80107fc4 <sys_wmap+0x114>
80108076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010807d:	8d 76 00             	lea    0x0(%esi),%esi

80108080 <write_to_file>:
int write_to_file(struct file *f, uint va, int offset, int n_bytes) {
80108080:	55                   	push   %ebp
80108081:	89 e5                	mov    %esp,%ebp
80108083:	57                   	push   %edi
80108084:	56                   	push   %esi
80108085:	53                   	push   %ebx
    int i = 0;
80108086:	31 db                	xor    %ebx,%ebx
int write_to_file(struct file *f, uint va, int offset, int n_bytes) {
80108088:	83 ec 1c             	sub    $0x1c,%esp
    while (i < n_bytes) {
8010808b:	8b 45 14             	mov    0x14(%ebp),%eax
int write_to_file(struct file *f, uint va, int offset, int n_bytes) {
8010808e:	8b 75 08             	mov    0x8(%ebp),%esi
    while (i < n_bytes) {
80108091:	85 c0                	test   %eax,%eax
80108093:	7f 32                	jg     801080c7 <write_to_file+0x47>
80108095:	e9 96 00 00 00       	jmp    80108130 <write_to_file+0xb0>
8010809a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        iunlock(f->ip);
801080a0:	83 ec 0c             	sub    $0xc,%esp
801080a3:	ff 76 10             	push   0x10(%esi)
            offset += r;
801080a6:	01 45 10             	add    %eax,0x10(%ebp)
801080a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        iunlock(f->ip);
801080ac:	e8 af 97 ff ff       	call   80101860 <iunlock>
        end_op();
801080b1:	e8 7a ae ff ff       	call   80102f30 <end_op>
        if (r != n1)
801080b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080b9:	83 c4 10             	add    $0x10,%esp
801080bc:	39 c7                	cmp    %eax,%edi
801080be:	75 5c                	jne    8010811c <write_to_file+0x9c>
        i += r;
801080c0:	01 fb                	add    %edi,%ebx
    while (i < n_bytes) {
801080c2:	39 5d 14             	cmp    %ebx,0x14(%ebp)
801080c5:	7e 69                	jle    80108130 <write_to_file+0xb0>
        int n1 = n_bytes - i;
801080c7:	8b 7d 14             	mov    0x14(%ebp),%edi
801080ca:	b8 00 06 00 00       	mov    $0x600,%eax
801080cf:	29 df                	sub    %ebx,%edi
801080d1:	39 c7                	cmp    %eax,%edi
801080d3:	0f 4f f8             	cmovg  %eax,%edi
        begin_op();
801080d6:	e8 e5 ad ff ff       	call   80102ec0 <begin_op>
        ilock(f->ip);
801080db:	83 ec 0c             	sub    $0xc,%esp
801080de:	ff 76 10             	push   0x10(%esi)
801080e1:	e8 9a 96 ff ff       	call   80101780 <ilock>
        if ((r = writei(f->ip, (char *)va + i, offset, n1)) > 0)
801080e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801080e9:	57                   	push   %edi
801080ea:	ff 75 10             	push   0x10(%ebp)
801080ed:	01 d8                	add    %ebx,%eax
801080ef:	50                   	push   %eax
801080f0:	ff 76 10             	push   0x10(%esi)
801080f3:	e8 98 9a ff ff       	call   80101b90 <writei>
801080f8:	83 c4 20             	add    $0x20,%esp
801080fb:	85 c0                	test   %eax,%eax
801080fd:	7f a1                	jg     801080a0 <write_to_file+0x20>
        iunlock(f->ip);
801080ff:	83 ec 0c             	sub    $0xc,%esp
80108102:	ff 76 10             	push   0x10(%esi)
80108105:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108108:	e8 53 97 ff ff       	call   80101860 <iunlock>
        end_op();
8010810d:	e8 1e ae ff ff       	call   80102f30 <end_op>
        if (r < 0)
80108112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108115:	83 c4 10             	add    $0x10,%esp
80108118:	85 c0                	test   %eax,%eax
8010811a:	75 24                	jne    80108140 <write_to_file+0xc0>
            panic("wmap: short filewrite");
8010811c:	83 ec 0c             	sub    $0xc,%esp
8010811f:	68 91 96 10 80       	push   $0x80109691
80108124:	e8 57 82 ff ff       	call   80100380 <panic>
80108129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    r = (i == n_bytes ? n_bytes : -1);
80108130:	39 5d 14             	cmp    %ebx,0x14(%ebp)
80108133:	75 0b                	jne    80108140 <write_to_file+0xc0>
}
80108135:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108138:	89 d8                	mov    %ebx,%eax
8010813a:	5b                   	pop    %ebx
8010813b:	5e                   	pop    %esi
8010813c:	5f                   	pop    %edi
8010813d:	5d                   	pop    %ebp
8010813e:	c3                   	ret    
8010813f:	90                   	nop
80108140:	8d 65 f4             	lea    -0xc(%ebp),%esp
    r = (i == n_bytes ? n_bytes : -1);
80108143:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80108148:	89 d8                	mov    %ebx,%eax
8010814a:	5b                   	pop    %ebx
8010814b:	5e                   	pop    %esi
8010814c:	5f                   	pop    %edi
8010814d:	5d                   	pop    %ebp
8010814e:	c3                   	ret    
8010814f:	90                   	nop

80108150 <remove_map>:
int remove_map(uint addr) {
80108150:	55                   	push   %ebp
80108151:	89 e5                	mov    %esp,%ebp
80108153:	57                   	push   %edi
80108154:	56                   	push   %esi
80108155:	53                   	push   %ebx
80108156:	83 ec 2c             	sub    $0x2c,%esp
80108159:	8b 75 08             	mov    0x8(%ebp),%esi
    curproc = myproc();
8010815c:	e8 7f b9 ff ff       	call   80103ae0 <myproc>
    prev = 0;
80108161:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
80108168:	31 d2                	xor    %edx,%edx
    cur = curproc->mmap_head;
8010816a:	8b b8 7c 02 00 00    	mov    0x27c(%eax),%edi
    curproc = myproc();
80108170:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while (cur && cur->addr != addr) {
80108173:	85 ff                	test   %edi,%edi
80108175:	75 18                	jne    8010818f <remove_map+0x3f>
80108177:	e9 54 01 00 00       	jmp    801082d0 <remove_map+0x180>
8010817c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cur = cur->next;
80108180:	8b 47 1c             	mov    0x1c(%edi),%eax
    while (cur && cur->addr != addr) {
80108183:	89 fa                	mov    %edi,%edx
80108185:	85 c0                	test   %eax,%eax
80108187:	0f 84 43 01 00 00    	je     801082d0 <remove_map+0x180>
8010818d:	89 c7                	mov    %eax,%edi
8010818f:	39 37                	cmp    %esi,(%edi)
80108191:	75 ed                	jne    80108180 <remove_map+0x30>
    end = cur->addr + (uint)cur->length;
80108193:	8b 47 04             	mov    0x4(%edi),%eax
80108196:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    for (va = start; va < end; va += PGSIZE) {
80108199:	31 db                	xor    %ebx,%ebx
    end = cur->addr + (uint)cur->length;
8010819b:	01 f0                	add    %esi,%eax
8010819d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (va = start; va < end; va += PGSIZE) {
801081a0:	39 c6                	cmp    %eax,%esi
801081a2:	0f 83 99 00 00 00    	jae    80108241 <remove_map+0xf1>
801081a8:	89 7d d8             	mov    %edi,-0x28(%ebp)
801081ab:	89 df                	mov    %ebx,%edi
801081ad:	8d 76 00             	lea    0x0(%esi),%esi
        pte = walkpgdir(curproc->pgdir, (void *)va, 0);
801081b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081b3:	83 ec 04             	sub    $0x4,%esp
801081b6:	6a 00                	push   $0x0
801081b8:	56                   	push   %esi
801081b9:	ff 70 04             	push   0x4(%eax)
801081bc:	e8 af e9 ff ff       	call   80106b70 <walkpgdir>
        if (pte == 0 || (*pte & PTE_P) == 0)
801081c1:	83 c4 10             	add    $0x10,%esp
        pte = walkpgdir(curproc->pgdir, (void *)va, 0);
801081c4:	89 c3                	mov    %eax,%ebx
        if (pte == 0 || (*pte & PTE_P) == 0)
801081c6:	85 c0                	test   %eax,%eax
801081c8:	74 5f                	je     80108229 <remove_map+0xd9>
801081ca:	8b 00                	mov    (%eax),%eax
801081cc:	a8 01                	test   $0x1,%al
801081ce:	74 59                	je     80108229 <remove_map+0xd9>
        if (!(cur->flags & MAP_ANONYMOUS) && (cur->flags & MAP_SHARED) && cur->f) {
801081d0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801081d3:	8b 51 08             	mov    0x8(%ecx),%edx
801081d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
801081d9:	83 e2 06             	and    $0x6,%edx
801081dc:	83 fa 02             	cmp    $0x2,%edx
801081df:	75 2c                	jne    8010820d <remove_map+0xbd>
801081e1:	8b 51 10             	mov    0x10(%ecx),%edx
801081e4:	85 d2                	test   %edx,%edx
801081e6:	74 25                	je     8010820d <remove_map+0xbd>
            if (write_to_file(cur->f, va, offset, page_bytes) < 0)
801081e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081eb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801081f0:	29 f0                	sub    %esi,%eax
801081f2:	39 c8                	cmp    %ecx,%eax
801081f4:	0f 47 c1             	cmova  %ecx,%eax
801081f7:	50                   	push   %eax
801081f8:	57                   	push   %edi
801081f9:	56                   	push   %esi
801081fa:	52                   	push   %edx
801081fb:	e8 80 fe ff ff       	call   80108080 <write_to_file>
80108200:	83 c4 10             	add    $0x10,%esp
80108203:	85 c0                	test   %eax,%eax
80108205:	0f 88 c5 00 00 00    	js     801082d0 <remove_map+0x180>
        kfree(P2V(PTE_ADDR(*pte)));
8010820b:	8b 03                	mov    (%ebx),%eax
8010820d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108212:	83 ec 0c             	sub    $0xc,%esp
80108215:	05 00 00 00 80       	add    $0x80000000,%eax
8010821a:	50                   	push   %eax
8010821b:	e8 a0 a2 ff ff       	call   801024c0 <kfree>
        *pte = 0;
80108220:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80108226:	83 c4 10             	add    $0x10,%esp
    for (va = start; va < end; va += PGSIZE) {
80108229:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010822f:	81 c7 00 10 00 00    	add    $0x1000,%edi
80108235:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80108238:	0f 87 72 ff ff ff    	ja     801081b0 <remove_map+0x60>
8010823e:	8b 7d d8             	mov    -0x28(%ebp),%edi
    switchuvm(curproc);
80108241:	83 ec 0c             	sub    $0xc,%esp
80108244:	ff 75 e0             	push   -0x20(%ebp)
80108247:	e8 b4 ea ff ff       	call   80106d00 <switchuvm>
    if (prev == 0)
8010824c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
        curproc->mmap_head = cur->next;
8010824f:	8b 47 1c             	mov    0x1c(%edi),%eax
    if (prev == 0)
80108252:	83 c4 10             	add    $0x10,%esp
80108255:	85 d2                	test   %edx,%edx
80108257:	0f 84 83 00 00 00    	je     801082e0 <remove_map+0x190>
        prev->next = cur->next;
8010825d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80108260:	89 43 1c             	mov    %eax,0x1c(%ebx)
    if (cur->f)
80108263:	8b 47 10             	mov    0x10(%edi),%eax
80108266:	85 c0                	test   %eax,%eax
80108268:	74 0c                	je     80108276 <remove_map+0x126>
        fileclose(cur->f);
8010826a:	83 ec 0c             	sub    $0xc,%esp
8010826d:	50                   	push   %eax
8010826e:	e8 7d 8c ff ff       	call   80100ef0 <fileclose>
80108273:	83 c4 10             	add    $0x10,%esp
    if (curproc->total_mmaps > 0)
80108276:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    mmap->addr = -1;
80108279:	c7 07 ff ff ff ff    	movl   $0xffffffff,(%edi)
    return 0;
8010827f:	31 d2                	xor    %edx,%edx
    mmap->length = -1;
80108281:	c7 47 04 ff ff ff ff 	movl   $0xffffffff,0x4(%edi)
    mmap->flags = -1;
80108288:	c7 47 08 ff ff ff ff 	movl   $0xffffffff,0x8(%edi)
    mmap->fd = -1;
8010828f:	c7 47 0c ff ff ff ff 	movl   $0xffffffff,0xc(%edi)
    mmap->f = 0;
80108296:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
    mmap->refcnt = 0;
8010829d:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    mmap->n_loaded_pages = 0;
801082a4:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
    mmap->next = 0;
801082ab:	c7 47 1c 00 00 00 00 	movl   $0x0,0x1c(%edi)
    if (curproc->total_mmaps > 0)
801082b2:	8b 81 80 02 00 00    	mov    0x280(%ecx),%eax
801082b8:	85 c0                	test   %eax,%eax
801082ba:	7e 19                	jle    801082d5 <remove_map+0x185>
        curproc->total_mmaps--;
801082bc:	83 e8 01             	sub    $0x1,%eax
801082bf:	89 81 80 02 00 00    	mov    %eax,0x280(%ecx)
}
801082c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082c8:	89 d0                	mov    %edx,%eax
801082ca:	5b                   	pop    %ebx
801082cb:	5e                   	pop    %esi
801082cc:	5f                   	pop    %edi
801082cd:	5d                   	pop    %ebp
801082ce:	c3                   	ret    
801082cf:	90                   	nop
        return FAILED;
801082d0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
801082d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082d8:	89 d0                	mov    %edx,%eax
801082da:	5b                   	pop    %ebx
801082db:	5e                   	pop    %esi
801082dc:	5f                   	pop    %edi
801082dd:	5d                   	pop    %ebp
801082de:	c3                   	ret    
801082df:	90                   	nop
        curproc->mmap_head = cur->next;
801082e0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801082e3:	89 83 7c 02 00 00    	mov    %eax,0x27c(%ebx)
801082e9:	e9 75 ff ff ff       	jmp    80108263 <remove_map+0x113>
801082ee:	66 90                	xchg   %ax,%ax

801082f0 <sys_wunmap>:
int sys_wunmap(void) {
801082f0:	55                   	push   %ebp
801082f1:	89 e5                	mov    %esp,%ebp
801082f3:	83 ec 20             	sub    $0x20,%esp
    if (argint(0, (int *)&addr) < 0) {
801082f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801082f9:	50                   	push   %eax
801082fa:	6a 00                	push   $0x0
801082fc:	e8 ef c7 ff ff       	call   80104af0 <argint>
80108301:	83 c4 10             	add    $0x10,%esp
80108304:	85 c0                	test   %eax,%eax
80108306:	78 5e                	js     80108366 <sys_wunmap+0x76>
    if (addr % PGSIZE != 0) {
80108308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010830b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80108310:	75 3d                	jne    8010834f <sys_wunmap+0x5f>
    if (addr < 0x60000000 || addr >= 0x80000000) {
80108312:	8d 90 00 00 00 a0    	lea    -0x60000000(%eax),%edx
80108318:	81 fa ff ff ff 1f    	cmp    $0x1fffffff,%edx
8010831e:	77 18                	ja     80108338 <sys_wunmap+0x48>
    if (remove_map(addr) < 0) {
80108320:	83 ec 0c             	sub    $0xc,%esp
80108323:	50                   	push   %eax
80108324:	e8 27 fe ff ff       	call   80108150 <remove_map>
80108329:	83 c4 10             	add    $0x10,%esp
8010832c:	85 c0                	test   %eax,%eax
8010832e:	78 4d                	js     8010837d <sys_wunmap+0x8d>
}
80108330:	c9                   	leave  
    return 0;
80108331:	31 c0                	xor    %eax,%eax
}
80108333:	c3                   	ret    
80108334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("wunmap ERROR: addr out of mmap range\n");
80108338:	83 ec 0c             	sub    $0xc,%esp
8010833b:	68 20 96 10 80       	push   $0x80109620
80108340:	e8 5b 83 ff ff       	call   801006a0 <cprintf>
        return FAILED;
80108345:	83 c4 10             	add    $0x10,%esp
80108348:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010834d:	c9                   	leave  
8010834e:	c3                   	ret    
        cprintf("wunmap ERROR: addr not page aligned\n");
8010834f:	83 ec 0c             	sub    $0xc,%esp
80108352:	68 f8 95 10 80       	push   $0x801095f8
80108357:	e8 44 83 ff ff       	call   801006a0 <cprintf>
        return FAILED;
8010835c:	83 c4 10             	add    $0x10,%esp
8010835f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108364:	c9                   	leave  
80108365:	c3                   	ret    
        cprintf("wunmap arg ERROR: addr\n");
80108366:	83 ec 0c             	sub    $0xc,%esp
80108369:	68 a7 96 10 80       	push   $0x801096a7
8010836e:	e8 2d 83 ff ff       	call   801006a0 <cprintf>
        return FAILED;
80108373:	83 c4 10             	add    $0x10,%esp
80108376:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010837b:	c9                   	leave  
8010837c:	c3                   	ret    
        cprintf("wunmap ERROR: unmap failed\n");
8010837d:	83 ec 0c             	sub    $0xc,%esp
80108380:	68 bf 96 10 80       	push   $0x801096bf
80108385:	e8 16 83 ff ff       	call   801006a0 <cprintf>
        return FAILED;
8010838a:	83 c4 10             	add    $0x10,%esp
8010838d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108392:	c9                   	leave  
80108393:	c3                   	ret    
80108394:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010839b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010839f:	90                   	nop

801083a0 <init_one_mmap>:
void init_one_mmap(struct mmap_region *mmap) {
801083a0:	55                   	push   %ebp
801083a1:	89 e5                	mov    %esp,%ebp
801083a3:	8b 45 08             	mov    0x8(%ebp),%eax
    mmap->addr = -1;
801083a6:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    mmap->length = -1;
801083ac:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    mmap->flags = -1;
801083b3:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
    mmap->fd = -1;
801083ba:	c7 40 0c ff ff ff ff 	movl   $0xffffffff,0xc(%eax)
    mmap->f = 0;
801083c1:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    mmap->refcnt = 0;
801083c8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    mmap->n_loaded_pages = 0;
801083cf:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    mmap->next = 0;
801083d6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
}
801083dd:	5d                   	pop    %ebp
801083de:	c3                   	ret    
801083df:	90                   	nop

801083e0 <init_mmaps>:
void init_mmaps(struct proc *proc) {
801083e0:	55                   	push   %ebp
801083e1:	89 e5                	mov    %esp,%ebp
801083e3:	8b 55 08             	mov    0x8(%ebp),%edx
    proc->mmap_head = 0;
801083e6:	c7 82 7c 02 00 00 00 	movl   $0x0,0x27c(%edx)
801083ed:	00 00 00 
    proc->total_mmaps = 0;
801083f0:	8d 42 7c             	lea    0x7c(%edx),%eax
801083f3:	81 c2 7c 02 00 00    	add    $0x27c,%edx
801083f9:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
    mmap->addr = -1;
80108400:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    for (i = 0; i < MAX_NMMAP; i++)
80108406:	83 c0 20             	add    $0x20,%eax
    mmap->length = -1;
80108409:	c7 40 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%eax)
    mmap->flags = -1;
80108410:	c7 40 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%eax)
    mmap->fd = -1;
80108417:	c7 40 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%eax)
    mmap->f = 0;
8010841e:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
    mmap->refcnt = 0;
80108425:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
    mmap->n_loaded_pages = 0;
8010842c:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    mmap->next = 0;
80108433:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for (i = 0; i < MAX_NMMAP; i++)
8010843a:	39 d0                	cmp    %edx,%eax
8010843c:	75 c2                	jne    80108400 <init_mmaps+0x20>
}
8010843e:	5d                   	pop    %ebp
8010843f:	c3                   	ret    

80108440 <get_physical_page>:
uint get_physical_page(struct proc *p, uint va, pte_t **pte) {
80108440:	55                   	push   %ebp
80108441:	89 e5                	mov    %esp,%ebp
80108443:	53                   	push   %ebx
80108444:	83 ec 08             	sub    $0x8,%esp
    entry = walkpgdir(p->pgdir, (const void *)va, 0);
80108447:	8b 45 08             	mov    0x8(%ebp),%eax
uint get_physical_page(struct proc *p, uint va, pte_t **pte) {
8010844a:	8b 5d 10             	mov    0x10(%ebp),%ebx
    entry = walkpgdir(p->pgdir, (const void *)va, 0);
8010844d:	6a 00                	push   $0x0
8010844f:	ff 75 0c             	push   0xc(%ebp)
80108452:	ff 70 04             	push   0x4(%eax)
80108455:	e8 16 e7 ff ff       	call   80106b70 <walkpgdir>
    if (pte)
8010845a:	83 c4 10             	add    $0x10,%esp
8010845d:	85 db                	test   %ebx,%ebx
8010845f:	74 02                	je     80108463 <get_physical_page+0x23>
        *pte = entry;
80108461:	89 03                	mov    %eax,(%ebx)
    if (entry == 0)
80108463:	85 c0                	test   %eax,%eax
80108465:	74 21                	je     80108488 <get_physical_page+0x48>
    if (((*entry & PTE_P) == 0) || ((*entry & PTE_U) == 0))
80108467:	8b 00                	mov    (%eax),%eax
}
80108469:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010846c:	c9                   	leave  
    if (((*entry & PTE_P) == 0) || ((*entry & PTE_U) == 0))
8010846d:	89 c2                	mov    %eax,%edx
    return PTE_ADDR(*entry);
8010846f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if (((*entry & PTE_P) == 0) || ((*entry & PTE_U) == 0))
80108474:	83 e2 05             	and    $0x5,%edx
    return PTE_ADDR(*entry);
80108477:	83 fa 05             	cmp    $0x5,%edx
8010847a:	ba 00 00 00 00       	mov    $0x0,%edx
8010847f:	0f 45 c2             	cmovne %edx,%eax
}
80108482:	c3                   	ret    
80108483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108487:	90                   	nop
80108488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        return 0;
8010848b:	31 c0                	xor    %eax,%eax
}
8010848d:	c9                   	leave  
8010848e:	c3                   	ret    
8010848f:	90                   	nop

80108490 <count_loaded_pages>:
int count_loaded_pages(struct proc *p, uint start, uint end) {
80108490:	55                   	push   %ebp
80108491:	89 e5                	mov    %esp,%ebp
80108493:	57                   	push   %edi
80108494:	56                   	push   %esi
        return 0;
80108495:	31 f6                	xor    %esi,%esi
int count_loaded_pages(struct proc *p, uint start, uint end) {
80108497:	53                   	push   %ebx
80108498:	83 ec 0c             	sub    $0xc,%esp
8010849b:	8b 7d 08             	mov    0x8(%ebp),%edi
8010849e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (end < start)
801084a1:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801084a4:	72 41                	jb     801084e7 <count_loaded_pages+0x57>
    for (va = start; va < end; va += PGSIZE) {
801084a6:	76 3f                	jbe    801084e7 <count_loaded_pages+0x57>
801084a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084af:	90                   	nop
    entry = walkpgdir(p->pgdir, (const void *)va, 0);
801084b0:	83 ec 04             	sub    $0x4,%esp
801084b3:	6a 00                	push   $0x0
801084b5:	53                   	push   %ebx
801084b6:	ff 77 04             	push   0x4(%edi)
801084b9:	e8 b2 e6 ff ff       	call   80106b70 <walkpgdir>
    if (entry == 0)
801084be:	83 c4 10             	add    $0x10,%esp
801084c1:	85 c0                	test   %eax,%eax
801084c3:	74 17                	je     801084dc <count_loaded_pages+0x4c>
    if (((*entry & PTE_P) == 0) || ((*entry & PTE_U) == 0))
801084c5:	8b 00                	mov    (%eax),%eax
801084c7:	89 c1                	mov    %eax,%ecx
801084c9:	83 e1 05             	and    $0x5,%ecx
801084cc:	83 f9 05             	cmp    $0x5,%ecx
801084cf:	75 0b                	jne    801084dc <count_loaded_pages+0x4c>
    return PTE_ADDR(*entry);
801084d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            cnt++;
801084d6:	83 f8 01             	cmp    $0x1,%eax
801084d9:	83 de ff             	sbb    $0xffffffff,%esi
    for (va = start; va < end; va += PGSIZE) {
801084dc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801084e2:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801084e5:	77 c9                	ja     801084b0 <count_loaded_pages+0x20>
    }
    return cnt;
}
801084e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084ea:	89 f0                	mov    %esi,%eax
801084ec:	5b                   	pop    %ebx
801084ed:	5e                   	pop    %esi
801084ee:	5f                   	pop    %edi
801084ef:	5d                   	pop    %ebp
801084f0:	c3                   	ret    
801084f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084ff:	90                   	nop

80108500 <handle_page_fault>:
 * maps it to the corresponding virtual address, and reads content from a file if necessary.
 *
 * @param pgflt_vaddr The virtual address that caused the page fault.
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int handle_page_fault(uint pgflt_vaddr) {
80108500:	55                   	push   %ebp
80108501:	89 e5                	mov    %esp,%ebp
80108503:	57                   	push   %edi
80108504:	56                   	push   %esi
80108505:	53                   	push   %ebx
80108506:	83 ec 1c             	sub    $0x1c,%esp
80108509:	8b 75 08             	mov    0x8(%ebp),%esi
    uint va, map_end, offset, n_bytes;
    char *mem;
    int r;
    pte_t *pte;

    curproc = myproc();
8010850c:	e8 cf b5 ff ff       	call   80103ae0 <myproc>
    if (curproc == 0)
80108511:	85 c0                	test   %eax,%eax
80108513:	74 29                	je     8010853e <handle_page_fault+0x3e>
        return FAILED;

    mmap = curproc->mmap_head;
80108515:	8b 98 7c 02 00 00    	mov    0x27c(%eax),%ebx
8010851b:	89 c7                	mov    %eax,%edi
    while (mmap) {
8010851d:	85 db                	test   %ebx,%ebx
8010851f:	74 1d                	je     8010853e <handle_page_fault+0x3e>
80108521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        map_end = mmap->addr + (uint)mmap->length;
80108528:	8b 03                	mov    (%ebx),%eax
8010852a:	8b 53 04             	mov    0x4(%ebx),%edx
8010852d:	01 c2                	add    %eax,%edx
        if (pgflt_vaddr >= mmap->addr && pgflt_vaddr < map_end)
8010852f:	39 f2                	cmp    %esi,%edx
80108531:	76 04                	jbe    80108537 <handle_page_fault+0x37>
80108533:	39 f0                	cmp    %esi,%eax
80108535:	76 19                	jbe    80108550 <handle_page_fault+0x50>
            break;
        mmap = mmap->next;
80108537:	8b 5b 1c             	mov    0x1c(%ebx),%ebx
    while (mmap) {
8010853a:	85 db                	test   %ebx,%ebx
8010853c:	75 ea                	jne    80108528 <handle_page_fault+0x28>
            if (pte && (*pte & PTE_P)) {
                kfree(P2V(PTE_ADDR(*pte)));
                *pte = 0;
                switchuvm(curproc);
            }
            return FAILED;
8010853e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }
    }

    mmap->n_loaded_pages++;
    return 0;
}
80108543:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108546:	5b                   	pop    %ebx
80108547:	5e                   	pop    %esi
80108548:	5f                   	pop    %edi
80108549:	5d                   	pop    %ebp
8010854a:	c3                   	ret    
8010854b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010854f:	90                   	nop
    va = PGROUNDDOWN(pgflt_vaddr);
80108550:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if (va < mmap->addr || va >= map_end)
80108556:	39 f2                	cmp    %esi,%edx
80108558:	76 e4                	jbe    8010853e <handle_page_fault+0x3e>
8010855a:	39 f0                	cmp    %esi,%eax
8010855c:	77 e0                	ja     8010853e <handle_page_fault+0x3e>
    entry = walkpgdir(p->pgdir, (const void *)va, 0);
8010855e:	83 ec 04             	sub    $0x4,%esp
80108561:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108564:	6a 00                	push   $0x0
80108566:	56                   	push   %esi
80108567:	ff 77 04             	push   0x4(%edi)
8010856a:	e8 01 e6 ff ff       	call   80106b70 <walkpgdir>
    if (entry == 0)
8010856f:	83 c4 10             	add    $0x10,%esp
80108572:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108575:	85 c0                	test   %eax,%eax
80108577:	74 10                	je     80108589 <handle_page_fault+0x89>
    if (((*entry & PTE_P) == 0) || ((*entry & PTE_U) == 0))
80108579:	8b 08                	mov    (%eax),%ecx
8010857b:	89 c8                	mov    %ecx,%eax
8010857d:	83 e0 05             	and    $0x5,%eax
80108580:	83 f8 05             	cmp    $0x5,%eax
80108583:	0f 84 bf 00 00 00    	je     80108648 <handle_page_fault+0x148>
80108589:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    mem = kalloc();
8010858c:	e8 1f a2 ff ff       	call   801027b0 <kalloc>
    if (mem == 0)
80108591:	85 c0                	test   %eax,%eax
80108593:	74 a9                	je     8010853e <handle_page_fault+0x3e>
    memset(mem, 0, PGSIZE);
80108595:	83 ec 04             	sub    $0x4,%esp
80108598:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010859b:	68 00 10 00 00       	push   $0x1000
801085a0:	6a 00                	push   $0x0
801085a2:	50                   	push   %eax
801085a3:	e8 88 c2 ff ff       	call   80104830 <memset>
    if (mappages(curproc->pgdir, (void *)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
801085a8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801085ab:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801085b2:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
801085b8:	50                   	push   %eax
801085b9:	68 00 10 00 00       	push   $0x1000
801085be:	56                   	push   %esi
801085bf:	ff 77 04             	push   0x4(%edi)
801085c2:	e8 39 e6 ff ff       	call   80106c00 <mappages>
801085c7:	83 c4 20             	add    $0x20,%esp
801085ca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801085cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801085d0:	85 c0                	test   %eax,%eax
801085d2:	0f 88 86 00 00 00    	js     8010865e <handle_page_fault+0x15e>
801085d8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    if (!(mmap->flags & MAP_ANONYMOUS) && mmap->f) {
801085db:	f6 43 08 04          	testb  $0x4,0x8(%ebx)
801085df:	75 54                	jne    80108635 <handle_page_fault+0x135>
801085e1:	8b 4b 10             	mov    0x10(%ebx),%ecx
801085e4:	85 c9                	test   %ecx,%ecx
801085e6:	74 4d                	je     80108635 <handle_page_fault+0x135>
        ilock(mmap->f->ip);
801085e8:	83 ec 0c             	sub    $0xc,%esp
        offset = va - mmap->addr;
801085eb:	89 f0                	mov    %esi,%eax
801085ed:	2b 03                	sub    (%ebx),%eax
        ilock(mmap->f->ip);
801085ef:	ff 71 10             	push   0x10(%ecx)
        offset = va - mmap->addr;
801085f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        ilock(mmap->f->ip);
801085f5:	e8 86 91 ff ff       	call   80101780 <ilock>
        n_bytes = map_end - va;
801085fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        r = readi(mmap->f->ip, (char *)va, offset, n_bytes);
801085fd:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108602:	8b 45 e0             	mov    -0x20(%ebp),%eax
        n_bytes = map_end - va;
80108605:	29 f2                	sub    %esi,%edx
        r = readi(mmap->f->ip, (char *)va, offset, n_bytes);
80108607:	39 ca                	cmp    %ecx,%edx
80108609:	0f 47 d1             	cmova  %ecx,%edx
8010860c:	52                   	push   %edx
8010860d:	50                   	push   %eax
8010860e:	56                   	push   %esi
8010860f:	8b 43 10             	mov    0x10(%ebx),%eax
80108612:	ff 70 10             	push   0x10(%eax)
80108615:	e8 76 94 ff ff       	call   80101a90 <readi>
        iunlock(mmap->f->ip);
8010861a:	8b 53 10             	mov    0x10(%ebx),%edx
8010861d:	83 c4 14             	add    $0x14,%esp
        r = readi(mmap->f->ip, (char *)va, offset, n_bytes);
80108620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        iunlock(mmap->f->ip);
80108623:	ff 72 10             	push   0x10(%edx)
80108626:	e8 35 92 ff ff       	call   80101860 <iunlock>
        if (r < 0) {
8010862b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010862e:	83 c4 10             	add    $0x10,%esp
80108631:	85 c0                	test   %eax,%eax
80108633:	78 3f                	js     80108674 <handle_page_fault+0x174>
    mmap->n_loaded_pages++;
80108635:	83 43 18 01          	addl   $0x1,0x18(%ebx)
}
80108639:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010863c:	31 c0                	xor    %eax,%eax
}
8010863e:	5b                   	pop    %ebx
8010863f:	5e                   	pop    %esi
80108640:	5f                   	pop    %edi
80108641:	5d                   	pop    %ebp
80108642:	c3                   	ret    
80108643:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108647:	90                   	nop
        return 0;
80108648:	31 c0                	xor    %eax,%eax
    if (get_physical_page(curproc, va, &pte) != 0)
8010864a:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80108650:	0f 84 33 ff ff ff    	je     80108589 <handle_page_fault+0x89>
}
80108656:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108659:	5b                   	pop    %ebx
8010865a:	5e                   	pop    %esi
8010865b:	5f                   	pop    %edi
8010865c:	5d                   	pop    %ebp
8010865d:	c3                   	ret    
        kfree(mem);
8010865e:	83 ec 0c             	sub    $0xc,%esp
80108661:	51                   	push   %ecx
80108662:	e8 59 9e ff ff       	call   801024c0 <kfree>
        return FAILED;
80108667:	83 c4 10             	add    $0x10,%esp
8010866a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010866f:	e9 cf fe ff ff       	jmp    80108543 <handle_page_fault+0x43>
            pte = walkpgdir(curproc->pgdir, (void *)va, 0);
80108674:	50                   	push   %eax
80108675:	6a 00                	push   $0x0
80108677:	56                   	push   %esi
80108678:	ff 77 04             	push   0x4(%edi)
8010867b:	e8 f0 e4 ff ff       	call   80106b70 <walkpgdir>
            if (pte && (*pte & PTE_P)) {
80108680:	83 c4 10             	add    $0x10,%esp
            pte = walkpgdir(curproc->pgdir, (void *)va, 0);
80108683:	89 c3                	mov    %eax,%ebx
            if (pte && (*pte & PTE_P)) {
80108685:	85 c0                	test   %eax,%eax
80108687:	0f 84 b1 fe ff ff    	je     8010853e <handle_page_fault+0x3e>
8010868d:	8b 00                	mov    (%eax),%eax
8010868f:	a8 01                	test   $0x1,%al
80108691:	0f 84 a7 fe ff ff    	je     8010853e <handle_page_fault+0x3e>
                kfree(P2V(PTE_ADDR(*pte)));
80108697:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010869c:	83 ec 0c             	sub    $0xc,%esp
8010869f:	05 00 00 00 80       	add    $0x80000000,%eax
801086a4:	50                   	push   %eax
801086a5:	e8 16 9e ff ff       	call   801024c0 <kfree>
                *pte = 0;
801086aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
                switchuvm(curproc);
801086b0:	89 3c 24             	mov    %edi,(%esp)
801086b3:	e8 48 e6 ff ff       	call   80106d00 <switchuvm>
801086b8:	83 c4 10             	add    $0x10,%esp
801086bb:	e9 7e fe ff ff       	jmp    8010853e <handle_page_fault+0x3e>

801086c0 <copy_maps>:
 * It also copies the physical pages if the memory mapping is MAP_PRIVATE.
 * It also increments the reference count of the memory mapping if it is MAP_SHARED.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int copy_maps(struct proc *parent, struct proc *child) {
801086c0:	55                   	push   %ebp
801086c1:	89 e5                	mov    %esp,%ebp
801086c3:	57                   	push   %edi
801086c4:	56                   	push   %esi
801086c5:	53                   	push   %ebx
801086c6:	83 ec 1c             	sub    $0x1c,%esp
    struct mmap_region *pm, *cm;
    uint va, end, pa;
    char *mem;

    pm = parent->mmap_head;
801086c9:	8b 45 08             	mov    0x8(%ebp),%eax
801086cc:	8b 80 7c 02 00 00    	mov    0x27c(%eax),%eax
    while (pm) {
801086d2:	85 c0                	test   %eax,%eax
801086d4:	0f 84 44 01 00 00    	je     8010881e <copy_maps+0x15e>
801086da:	89 c7                	mov    %eax,%edi
        // Child must inherit the same virtual ranges.
        cm = fix_addr_place_mmap(child, pm->addr, pm->length, pm->flags);
801086dc:	ff 77 08             	push   0x8(%edi)
801086df:	ff 77 04             	push   0x4(%edi)
801086e2:	ff 37                	push   (%edi)
801086e4:	ff 75 0c             	push   0xc(%ebp)
801086e7:	e8 74 f4 ff ff       	call   80107b60 <fix_addr_place_mmap>
        if (cm == 0)
801086ec:	83 c4 10             	add    $0x10,%esp
        cm = fix_addr_place_mmap(child, pm->addr, pm->length, pm->flags);
801086ef:	89 c3                	mov    %eax,%ebx
        if (cm == 0)
801086f1:	85 c0                	test   %eax,%eax
801086f3:	0f 84 3b 01 00 00    	je     80108834 <copy_maps+0x174>
            return FAILED;

        cm->length = pm->length;
801086f9:	8b 47 04             	mov    0x4(%edi),%eax
801086fc:	89 43 04             	mov    %eax,0x4(%ebx)
        cm->flags = pm->flags;
801086ff:	8b 47 08             	mov    0x8(%edi),%eax
80108702:	89 43 08             	mov    %eax,0x8(%ebx)
        cm->fd = pm->fd;
80108705:	8b 47 0c             	mov    0xc(%edi),%eax
80108708:	89 43 0c             	mov    %eax,0xc(%ebx)
        cm->f = pm->f ? filedup(pm->f) : 0;
8010870b:	8b 47 10             	mov    0x10(%edi),%eax
8010870e:	85 c0                	test   %eax,%eax
80108710:	74 0c                	je     8010871e <copy_maps+0x5e>
80108712:	83 ec 0c             	sub    $0xc,%esp
80108715:	50                   	push   %eax
80108716:	e8 85 87 ff ff       	call   80100ea0 <filedup>
8010871b:	83 c4 10             	add    $0x10,%esp
8010871e:	89 43 10             	mov    %eax,0x10(%ebx)
        cm->refcnt = (pm->flags & MAP_SHARED) ? (pm->refcnt + 1) : 0;
80108721:	8b 47 08             	mov    0x8(%edi),%eax
80108724:	83 e0 02             	and    $0x2,%eax
80108727:	74 06                	je     8010872f <copy_maps+0x6f>
80108729:	8b 47 14             	mov    0x14(%edi),%eax
8010872c:	83 c0 01             	add    $0x1,%eax
8010872f:	89 43 14             	mov    %eax,0x14(%ebx)
        cm->n_loaded_pages = pm->n_loaded_pages;
80108732:	8b 47 18             	mov    0x18(%edi),%eax
80108735:	89 43 18             	mov    %eax,0x18(%ebx)
        child->total_mmaps++;
80108738:	8b 45 0c             	mov    0xc(%ebp),%eax
8010873b:	83 80 80 02 00 00 01 	addl   $0x1,0x280(%eax)

        // Copy/share already loaded pages. Unloaded pages remain demand-paged.
        end = pm->addr + (uint)pm->length;
80108742:	8b 1f                	mov    (%edi),%ebx
80108744:	8b 47 04             	mov    0x4(%edi),%eax
80108747:	01 d8                	add    %ebx,%eax
80108749:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (va = pm->addr; va < end; va += PGSIZE) {
8010874c:	39 c3                	cmp    %eax,%ebx
8010874e:	0f 83 bf 00 00 00    	jae    80108813 <copy_maps+0x153>
80108754:	89 7d e0             	mov    %edi,-0x20(%ebp)
80108757:	eb 45                	jmp    8010879e <copy_maps+0xde>
80108759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            pa = get_physical_page(parent, va, 0);
            if (pa == 0)
                continue;

            if (pm->flags & MAP_SHARED) {
                kaddref((char *)P2V(pa));
80108760:	83 ec 0c             	sub    $0xc,%esp
80108763:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
80108769:	57                   	push   %edi
8010876a:	e8 91 9f ff ff       	call   80102700 <kaddref>
                if (mappages(child->pgdir, (void *)va, PGSIZE, pa, PTE_W | PTE_U) < 0) {
8010876f:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80108776:	56                   	push   %esi
            } else {
                mem = kalloc();
                if (mem == 0)
                    return FAILED;
                memmove(mem, (char *)P2V(pa), PGSIZE);
                if (mappages(child->pgdir, (void *)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80108777:	8b 45 0c             	mov    0xc(%ebp),%eax
8010877a:	68 00 10 00 00       	push   $0x1000
8010877f:	53                   	push   %ebx
80108780:	ff 70 04             	push   0x4(%eax)
80108783:	e8 78 e4 ff ff       	call   80106c00 <mappages>
80108788:	83 c4 20             	add    $0x20,%esp
8010878b:	85 c0                	test   %eax,%eax
8010878d:	0f 88 95 00 00 00    	js     80108828 <copy_maps+0x168>
        for (va = pm->addr; va < end; va += PGSIZE) {
80108793:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108799:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010879c:	76 72                	jbe    80108810 <copy_maps+0x150>
    entry = walkpgdir(p->pgdir, (const void *)va, 0);
8010879e:	8b 45 08             	mov    0x8(%ebp),%eax
801087a1:	83 ec 04             	sub    $0x4,%esp
801087a4:	6a 00                	push   $0x0
801087a6:	53                   	push   %ebx
801087a7:	ff 70 04             	push   0x4(%eax)
801087aa:	e8 c1 e3 ff ff       	call   80106b70 <walkpgdir>
    if (entry == 0)
801087af:	83 c4 10             	add    $0x10,%esp
801087b2:	85 c0                	test   %eax,%eax
801087b4:	74 dd                	je     80108793 <copy_maps+0xd3>
    if (((*entry & PTE_P) == 0) || ((*entry & PTE_U) == 0))
801087b6:	8b 30                	mov    (%eax),%esi
801087b8:	89 f0                	mov    %esi,%eax
801087ba:	83 e0 05             	and    $0x5,%eax
801087bd:	83 f8 05             	cmp    $0x5,%eax
801087c0:	75 d1                	jne    80108793 <copy_maps+0xd3>
            if (pa == 0)
801087c2:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801087c8:	74 c9                	je     80108793 <copy_maps+0xd3>
            if (pm->flags & MAP_SHARED) {
801087ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087cd:	f6 40 08 02          	testb  $0x2,0x8(%eax)
801087d1:	75 8d                	jne    80108760 <copy_maps+0xa0>
                mem = kalloc();
801087d3:	e8 d8 9f ff ff       	call   801027b0 <kalloc>
801087d8:	89 c7                	mov    %eax,%edi
                if (mem == 0)
801087da:	85 c0                	test   %eax,%eax
801087dc:	74 56                	je     80108834 <copy_maps+0x174>
                memmove(mem, (char *)P2V(pa), PGSIZE);
801087de:	83 ec 04             	sub    $0x4,%esp
801087e1:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801087e7:	68 00 10 00 00       	push   $0x1000
801087ec:	56                   	push   %esi
801087ed:	50                   	push   %eax
801087ee:	e8 dd c0 ff ff       	call   801048d0 <memmove>
                if (mappages(child->pgdir, (void *)va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
801087f3:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801087f9:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80108800:	50                   	push   %eax
80108801:	e9 71 ff ff ff       	jmp    80108777 <copy_maps+0xb7>
80108806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010880d:	8d 76 00             	lea    0x0(%esi),%esi
80108810:	8b 7d e0             	mov    -0x20(%ebp),%edi
                    return FAILED;
                }
            }
        }

        pm = pm->next;
80108813:	8b 7f 1c             	mov    0x1c(%edi),%edi
    while (pm) {
80108816:	85 ff                	test   %edi,%edi
80108818:	0f 85 be fe ff ff    	jne    801086dc <copy_maps+0x1c>
    }

    return 0;
8010881e:	31 c0                	xor    %eax,%eax
80108820:	eb 17                	jmp    80108839 <copy_maps+0x179>
80108822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    kfree(mem);
80108828:	83 ec 0c             	sub    $0xc,%esp
8010882b:	57                   	push   %edi
8010882c:	e8 8f 9c ff ff       	call   801024c0 <kfree>
                    return FAILED;
80108831:	83 c4 10             	add    $0x10,%esp
80108834:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010883c:	5b                   	pop    %ebx
8010883d:	5e                   	pop    %esi
8010883e:	5f                   	pop    %edi
8010883f:	5d                   	pop    %ebp
80108840:	c3                   	ret    
80108841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010884f:	90                   	nop

80108850 <delete_mmaps>:
 * @brief deletes memory mappings of a process during its exit.
 * It removes mappings with zero reference count and resets the mmap_region struct.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int delete_mmaps(struct proc *curproc) {
80108850:	55                   	push   %ebp
80108851:	89 e5                	mov    %esp,%ebp
80108853:	57                   	push   %edi
80108854:	56                   	push   %esi
80108855:	53                   	push   %ebx
80108856:	83 ec 1c             	sub    $0x1c,%esp
    struct mmap_region *mmap, *next;
    uint start, end, va, page_bytes, offset;
    pte_t *pte;

    mmap = curproc->mmap_head;
80108859:	8b 45 08             	mov    0x8(%ebp),%eax
8010885c:	8b 80 7c 02 00 00    	mov    0x27c(%eax),%eax
80108862:	89 45 d8             	mov    %eax,-0x28(%ebp)
    while (mmap) {
80108865:	85 c0                	test   %eax,%eax
80108867:	0f 84 2a 01 00 00    	je     80108997 <delete_mmaps+0x147>
8010886d:	8d 76 00             	lea    0x0(%esi),%esi
        next = mmap->next;
80108870:	8b 45 d8             	mov    -0x28(%ebp),%eax
        start = mmap->addr;
        end = mmap->addr + (uint)mmap->length;

        for (va = start; va < end; va += PGSIZE) {
80108873:	31 c9                	xor    %ecx,%ecx
80108875:	89 c7                	mov    %eax,%edi
        next = mmap->next;
80108877:	8b 40 1c             	mov    0x1c(%eax),%eax
        start = mmap->addr;
8010887a:	8b 37                	mov    (%edi),%esi
        next = mmap->next;
8010887c:	89 45 d8             	mov    %eax,-0x28(%ebp)
        end = mmap->addr + (uint)mmap->length;
8010887f:	8b 47 04             	mov    0x4(%edi),%eax
80108882:	01 f0                	add    %esi,%eax
80108884:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (va = start; va < end; va += PGSIZE) {
80108887:	39 c6                	cmp    %eax,%esi
80108889:	0f 83 9a 00 00 00    	jae    80108929 <delete_mmaps+0xd9>
8010888f:	89 7d dc             	mov    %edi,-0x24(%ebp)
80108892:	89 cf                	mov    %ecx,%edi
80108894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            pte = walkpgdir(curproc->pgdir, (void *)va, 0);
80108898:	8b 45 08             	mov    0x8(%ebp),%eax
8010889b:	83 ec 04             	sub    $0x4,%esp
8010889e:	6a 00                	push   $0x0
801088a0:	56                   	push   %esi
801088a1:	ff 70 04             	push   0x4(%eax)
801088a4:	e8 c7 e2 ff ff       	call   80106b70 <walkpgdir>
            if (pte == 0 || (*pte & PTE_P) == 0)
801088a9:	83 c4 10             	add    $0x10,%esp
            pte = walkpgdir(curproc->pgdir, (void *)va, 0);
801088ac:	89 c3                	mov    %eax,%ebx
            if (pte == 0 || (*pte & PTE_P) == 0)
801088ae:	85 c0                	test   %eax,%eax
801088b0:	74 5f                	je     80108911 <delete_mmaps+0xc1>
801088b2:	8b 00                	mov    (%eax),%eax
801088b4:	a8 01                	test   $0x1,%al
801088b6:	74 59                	je     80108911 <delete_mmaps+0xc1>
                continue;

            if (!(mmap->flags & MAP_ANONYMOUS) && (mmap->flags & MAP_SHARED) && mmap->f) {
801088b8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801088bb:	8b 51 08             	mov    0x8(%ecx),%edx
801088be:	89 55 e0             	mov    %edx,-0x20(%ebp)
801088c1:	83 e2 06             	and    $0x6,%edx
801088c4:	83 fa 02             	cmp    $0x2,%edx
801088c7:	75 2c                	jne    801088f5 <delete_mmaps+0xa5>
801088c9:	8b 51 10             	mov    0x10(%ecx),%edx
801088cc:	85 d2                	test   %edx,%edx
801088ce:	74 25                	je     801088f5 <delete_mmaps+0xa5>
                offset = va - start;
                page_bytes = end - va;
                if (page_bytes > PGSIZE)
                    page_bytes = PGSIZE;
                if (write_to_file(mmap->f, va, offset, page_bytes) < 0)
801088d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801088d3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801088d8:	29 f0                	sub    %esi,%eax
801088da:	39 c8                	cmp    %ecx,%eax
801088dc:	0f 47 c1             	cmova  %ecx,%eax
801088df:	50                   	push   %eax
801088e0:	57                   	push   %edi
801088e1:	56                   	push   %esi
801088e2:	52                   	push   %edx
801088e3:	e8 98 f7 ff ff       	call   80108080 <write_to_file>
801088e8:	83 c4 10             	add    $0x10,%esp
801088eb:	85 c0                	test   %eax,%eax
801088ed:	0f 88 c7 00 00 00    	js     801089ba <delete_mmaps+0x16a>
                    return FAILED;
            }

            kfree(P2V(PTE_ADDR(*pte)));
801088f3:	8b 03                	mov    (%ebx),%eax
801088f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088fa:	83 ec 0c             	sub    $0xc,%esp
801088fd:	05 00 00 00 80       	add    $0x80000000,%eax
80108902:	50                   	push   %eax
80108903:	e8 b8 9b ff ff       	call   801024c0 <kfree>
            *pte = 0;
80108908:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010890e:	83 c4 10             	add    $0x10,%esp
        for (va = start; va < end; va += PGSIZE) {
80108911:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108917:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010891d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80108920:	0f 87 72 ff ff ff    	ja     80108898 <delete_mmaps+0x48>
80108926:	8b 7d dc             	mov    -0x24(%ebp),%edi
        }

        if (mmap->f)
80108929:	8b 47 10             	mov    0x10(%edi),%eax
8010892c:	85 c0                	test   %eax,%eax
8010892e:	74 0c                	je     8010893c <delete_mmaps+0xec>
            fileclose(mmap->f);
80108930:	83 ec 0c             	sub    $0xc,%esp
80108933:	50                   	push   %eax
80108934:	e8 b7 85 ff ff       	call   80100ef0 <fileclose>
80108939:	83 c4 10             	add    $0x10,%esp
        init_one_mmap(mmap);
        if (curproc->total_mmaps > 0)
8010893c:	8b 45 08             	mov    0x8(%ebp),%eax
    mmap->addr = -1;
8010893f:	c7 07 ff ff ff ff    	movl   $0xffffffff,(%edi)
    mmap->length = -1;
80108945:	c7 47 04 ff ff ff ff 	movl   $0xffffffff,0x4(%edi)
    mmap->flags = -1;
8010894c:	c7 47 08 ff ff ff ff 	movl   $0xffffffff,0x8(%edi)
    mmap->fd = -1;
80108953:	c7 47 0c ff ff ff ff 	movl   $0xffffffff,0xc(%edi)
    mmap->f = 0;
8010895a:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
    mmap->refcnt = 0;
80108961:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    mmap->n_loaded_pages = 0;
80108968:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
    mmap->next = 0;
8010896f:	c7 47 1c 00 00 00 00 	movl   $0x0,0x1c(%edi)
        if (curproc->total_mmaps > 0)
80108976:	8b 80 80 02 00 00    	mov    0x280(%eax),%eax
8010897c:	85 c0                	test   %eax,%eax
8010897e:	7e 0c                	jle    8010898c <delete_mmaps+0x13c>
            curproc->total_mmaps--;
80108980:	8b 7d 08             	mov    0x8(%ebp),%edi
80108983:	83 e8 01             	sub    $0x1,%eax
80108986:	89 87 80 02 00 00    	mov    %eax,0x280(%edi)
    while (mmap) {
8010898c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010898f:	85 c0                	test   %eax,%eax
80108991:	0f 85 d9 fe ff ff    	jne    80108870 <delete_mmaps+0x20>

        mmap = next;
    }

    curproc->mmap_head = 0;
80108997:	8b 45 08             	mov    0x8(%ebp),%eax
    switchuvm(curproc);
8010899a:	83 ec 0c             	sub    $0xc,%esp
    curproc->mmap_head = 0;
8010899d:	c7 80 7c 02 00 00 00 	movl   $0x0,0x27c(%eax)
801089a4:	00 00 00 
    switchuvm(curproc);
801089a7:	50                   	push   %eax
801089a8:	e8 53 e3 ff ff       	call   80106d00 <switchuvm>
    return 0;
801089ad:	83 c4 10             	add    $0x10,%esp
}
801089b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801089b3:	31 c0                	xor    %eax,%eax
}
801089b5:	5b                   	pop    %ebx
801089b6:	5e                   	pop    %esi
801089b7:	5f                   	pop    %edi
801089b8:	5d                   	pop    %ebp
801089b9:	c3                   	ret    
801089ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
                    return FAILED;
801089bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801089c2:	5b                   	pop    %ebx
801089c3:	5e                   	pop    %esi
801089c4:	5f                   	pop    %edi
801089c5:	5d                   	pop    %ebp
801089c6:	c3                   	ret    
