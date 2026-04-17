
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
80100028:	bc d0 f6 11 80       	mov    $0x8011f6d0,%esp

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
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 86 10 80       	push   $0x80108640
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 a5 43 00 00       	call   80104400 <initlock>
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
80100092:	68 47 86 10 80       	push   $0x80108647
80100097:	50                   	push   %eax
80100098:	e8 33 42 00 00       	call   801042d0 <initsleeplock>
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
801000e4:	e8 e7 44 00 00       	call   801045d0 <acquire>
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
80100162:	e8 09 44 00 00       	call   80104570 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 41 00 00       	call   80104310 <acquiresleep>
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
801001a1:	68 4e 86 10 80       	push   $0x8010864e
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
801001be:	e8 ed 41 00 00       	call   801043b0 <holdingsleep>
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
801001dc:	68 5f 86 10 80       	push   $0x8010865f
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
801001ff:	e8 ac 41 00 00       	call   801043b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 41 00 00       	call   80104370 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 b0 43 00 00       	call   801045d0 <acquire>
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
8010026c:	e9 ff 42 00 00       	jmp    80104570 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 86 10 80       	push   $0x80108666
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
801002a0:	e8 2b 43 00 00       	call   801045d0 <acquire>
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
801002cd:	e8 9e 3d 00 00       	call   80104070 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 99 36 00 00       	call   80103980 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 0f 11 80       	push   $0x80110f20
801002f6:	e8 75 42 00 00       	call   80104570 <release>
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
8010034c:	e8 1f 42 00 00       	call   80104570 <release>
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
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 86 10 80       	push   $0x8010866d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 07 90 10 80 	movl   $0x80109007,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 40 00 00       	call   80104420 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 86 10 80       	push   $0x80108681
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
8010041a:	e8 61 59 00 00       	call   80105d80 <uartputc>
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
80100505:	e8 76 58 00 00       	call   80105d80 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 6a 58 00 00       	call   80105d80 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 5e 58 00 00       	call   80105d80 <uartputc>
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
80100551:	e8 da 41 00 00       	call   80104730 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 25 41 00 00       	call   80104690 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 85 86 10 80       	push   $0x80108685
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
801005ab:	e8 20 40 00 00       	call   801045d0 <acquire>
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
801005e4:	e8 87 3f 00 00       	call   80104570 <release>
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
80100636:	0f b6 92 b0 86 10 80 	movzbl -0x7fef7950(%edx),%edx
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
801007e8:	e8 e3 3d 00 00       	call   801045d0 <acquire>
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
80100838:	bf 98 86 10 80       	mov    $0x80108698,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 0f 11 80       	push   $0x80110f20
8010085b:	e8 10 3d 00 00       	call   80104570 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 9f 86 10 80       	push   $0x8010869f
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
80100893:	e8 38 3d 00 00       	call   801045d0 <acquire>
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
801009d0:	e8 9b 3b 00 00       	call   80104570 <release>
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
80100a0e:	e9 fd 37 00 00       	jmp    80104210 <procdump>
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
80100a44:	e8 e7 36 00 00       	call   80104130 <wakeup>
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
80100a66:	68 a8 86 10 80       	push   $0x801086a8
80100a6b:	68 20 0f 11 80       	push   $0x80110f20
80100a70:	e8 8b 39 00 00       	call   80104400 <initlock>

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
80100abc:	e8 bf 2e 00 00       	call   80103980 <myproc>
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
80100b34:	e8 57 64 00 00       	call   80106f90 <setupkvm>
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
80100ba3:	e8 18 62 00 00       	call   80106dc0 <allocuvm>
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
80100bd9:	e8 f2 60 00 00       	call   80106cd0 <loaduvm>
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
80100c1b:	e8 f0 62 00 00       	call   80106f10 <freevm>
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
80100c62:	e8 59 61 00 00       	call   80106dc0 <allocuvm>
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
80100c83:	e8 a8 63 00 00       	call   80107030 <clearpteu>
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
80100cd3:	e8 b8 3b 00 00       	call   80104890 <strlen>
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
80100ce7:	e8 a4 3b 00 00       	call   80104890 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 03 65 00 00       	call   80107200 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 fa 61 00 00       	call   80106f10 <freevm>
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
80100d63:	e8 98 64 00 00       	call   80107200 <copyout>
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
80100da1:	e8 aa 3a 00 00       	call   80104850 <safestrcpy>
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
80100dcd:	e8 6e 5d 00 00       	call   80106b40 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 36 61 00 00       	call   80106f10 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 c1 86 10 80       	push   $0x801086c1
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
80100e16:	68 cd 86 10 80       	push   $0x801086cd
80100e1b:	68 60 0f 11 80       	push   $0x80110f60
80100e20:	e8 db 35 00 00       	call   80104400 <initlock>
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
80100e41:	e8 8a 37 00 00       	call   801045d0 <acquire>
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
80100e71:	e8 fa 36 00 00       	call   80104570 <release>
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
80100e8a:	e8 e1 36 00 00       	call   80104570 <release>
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
80100eaf:	e8 1c 37 00 00       	call   801045d0 <acquire>
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
80100ecc:	e8 9f 36 00 00       	call   80104570 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 d4 86 10 80       	push   $0x801086d4
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
80100f01:	e8 ca 36 00 00       	call   801045d0 <acquire>
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
80100f3c:	e8 2f 36 00 00       	call   80104570 <release>

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
80100f6e:	e9 fd 35 00 00       	jmp    80104570 <release>
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
80100fbc:	68 dc 86 10 80       	push   $0x801086dc
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
801010a2:	68 e6 86 10 80       	push   $0x801086e6
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
80101177:	68 b3 90 10 80       	push   $0x801090b3
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
801011b1:	68 b9 90 10 80       	push   $0x801090b9
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
80101227:	68 ef 86 10 80       	push   $0x801086ef
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
801012e4:	68 02 87 10 80       	push   $0x80108702
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
80101325:	e8 66 33 00 00       	call   80104690 <memset>
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
8010135a:	bb 94 19 11 80       	mov    $0x80111994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 19 11 80       	push   $0x80111960
8010136a:	e8 61 32 00 00       	call   801045d0 <acquire>
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
801013d7:	e8 94 31 00 00       	call   80104570 <release>

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
80101405:	e8 66 31 00 00       	call   80104570 <release>
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
80101438:	68 18 87 10 80       	push   $0x80108718
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
80101515:	68 28 87 10 80       	push   $0x80108728
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
80101541:	e8 ea 31 00 00       	call   80104730 <memmove>
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
8010156c:	68 3b 87 10 80       	push   $0x8010873b
80101571:	68 60 19 11 80       	push   $0x80111960
80101576:	e8 85 2e 00 00       	call   80104400 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 42 87 10 80       	push   $0x80108742
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 3c 2d 00 00       	call   801042d0 <initsleeplock>
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
801015bc:	e8 6f 31 00 00       	call   80104730 <memmove>
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
801015f3:	68 a8 87 10 80       	push   $0x801087a8
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
8010168e:	e8 fd 2f 00 00       	call   80104690 <memset>
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
801016c3:	68 48 87 10 80       	push   $0x80108748
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
80101731:	e8 fa 2f 00 00       	call   80104730 <memmove>
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
8010175a:	68 60 19 11 80       	push   $0x80111960
8010175f:	e8 6c 2e 00 00       	call   801045d0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010176f:	e8 fc 2d 00 00       	call   80104570 <release>
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
801017a2:	e8 69 2b 00 00       	call   80104310 <acquiresleep>
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
80101818:	e8 13 2f 00 00       	call   80104730 <memmove>
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
8010183d:	68 60 87 10 80       	push   $0x80108760
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 5a 87 10 80       	push   $0x8010875a
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
80101873:	e8 38 2b 00 00       	call   801043b0 <holdingsleep>
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
8010188f:	e9 dc 2a 00 00       	jmp    80104370 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 6f 87 10 80       	push   $0x8010876f
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
801018c0:	e8 4b 2a 00 00       	call   80104310 <acquiresleep>
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
801018da:	e8 91 2a 00 00       	call   80104370 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
801018e6:	e8 e5 2c 00 00       	call   801045d0 <acquire>
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
80101900:	e9 6b 2c 00 00       	jmp    80104570 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 19 11 80       	push   $0x80111960
80101910:	e8 bb 2c 00 00       	call   801045d0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010191f:	e8 4c 2c 00 00       	call   80104570 <release>
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
80101a23:	e8 88 29 00 00       	call   801043b0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 31 29 00 00       	call   80104370 <releasesleep>
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
80101a53:	68 6f 87 10 80       	push   $0x8010876f
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
80101b37:	e8 f4 2b 00 00       	call   80104730 <memmove>
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
80101c33:	e8 f8 2a 00 00       	call   80104730 <memmove>
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
80101cce:	e8 cd 2a 00 00       	call   801047a0 <strncmp>
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
80101d2d:	e8 6e 2a 00 00       	call   801047a0 <strncmp>
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
80101d72:	68 89 87 10 80       	push   $0x80108789
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 77 87 10 80       	push   $0x80108777
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
80101daa:	e8 d1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 19 11 80       	push   $0x80111960
80101dba:	e8 11 28 00 00       	call   801045d0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
80101dca:	e8 a1 27 00 00       	call   80104570 <release>
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
80101e27:	e8 04 29 00 00       	call   80104730 <memmove>
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
80101e8c:	e8 1f 25 00 00       	call   801043b0 <holdingsleep>
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
80101eae:	e8 bd 24 00 00       	call   80104370 <releasesleep>
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
80101edb:	e8 50 28 00 00       	call   80104730 <memmove>
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
80101f2b:	e8 80 24 00 00       	call   801043b0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 21 24 00 00       	call   80104370 <releasesleep>
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
80101f6d:	e8 3e 24 00 00       	call   801043b0 <holdingsleep>
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
80101f90:	e8 1b 24 00 00       	call   801043b0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 c4 23 00 00       	call   80104370 <releasesleep>
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
80101fcf:	68 6f 87 10 80       	push   $0x8010876f
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
8010203d:	e8 ae 27 00 00       	call   801047f0 <strncpy>
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
8010207b:	68 98 87 10 80       	push   $0x80108798
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 92 8d 10 80       	push   $0x80108d92
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
8010219b:	68 04 88 10 80       	push   $0x80108804
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 fb 87 10 80       	push   $0x801087fb
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 16 88 10 80       	push   $0x80108816
801021cb:	68 00 36 11 80       	push   $0x80113600
801021d0:	e8 2b 22 00 00       	call   80104400 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 37 11 80       	mov    0x80113784,%eax
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
8010224e:	e8 7d 23 00 00       	call   801045d0 <acquire>

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
801022ad:	e8 7e 1e 00 00       	call   80104130 <wakeup>

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
801022cb:	e8 a0 22 00 00       	call   80104570 <release>

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
801022ee:	e8 bd 20 00 00       	call   801043b0 <holdingsleep>
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
80102328:	e8 a3 22 00 00       	call   801045d0 <acquire>

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
80102369:	e8 02 1d 00 00       	call   80104070 <sleep>
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
80102386:	e9 e5 21 00 00       	jmp    80104570 <release>
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
801023aa:	68 45 88 10 80       	push   $0x80108845
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 30 88 10 80       	push   $0x80108830
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 1a 88 10 80       	push   $0x8010881a
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
801023fe:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
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
8010241a:	68 64 88 10 80       	push   $0x80108864
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
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb d0 f6 11 80    	cmp    $0x8011f6d0,%ebx
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
801024f2:	e8 99 21 00 00       	call   80104690 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 36 11 80       	mov    0x80113678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
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
80102523:	68 40 36 11 80       	push   $0x80113640
80102528:	e8 a3 20 00 00       	call   801045d0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 28 20 00 00       	jmp    80104570 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 96 88 10 80       	push   $0x80108896
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
801025f4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
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
8010261b:	68 9c 88 10 80       	push   $0x8010889c
80102620:	68 40 36 11 80       	push   $0x80113640
80102625:	e8 d6 1d 00 00       	call   80104400 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
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
80102680:	a1 74 36 11 80       	mov    0x80113674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 36 11 80    	mov    %edx,0x80113678
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
801026ae:	68 40 36 11 80       	push   $0x80113640
801026b3:	e8 18 1f 00 00       	call   801045d0 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 36 11 80    	mov    0x80113674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 36 11 80       	push   $0x80113640
801026e1:	e8 8a 1e 00 00       	call   80104570 <release>
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
80102708:	8b 1d 7c 36 11 80    	mov    0x8011367c,%ebx
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
8010272b:	0f b6 91 e0 89 10 80 	movzbl -0x7fef7620(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 e0 88 10 80 	movzbl -0x7fef7720(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 36 11 80    	mov    %edx,0x8011367c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 c0 88 10 80 	mov    -0x7fef7740(,%eax,4),%eax
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
80102775:	89 1d 7c 36 11 80    	mov    %ebx,0x8011367c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 e0 89 10 80 	movzbl -0x7fef7620(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 36 11 80       	mov    %eax,0x8011367c
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
801027f0:	a1 80 36 11 80       	mov    0x80113680,%eax
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
801028f0:	a1 80 36 11 80       	mov    0x80113680,%eax
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
80102910:	a1 80 36 11 80       	mov    0x80113680,%eax
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
8010297e:	a1 80 36 11 80       	mov    0x80113680,%eax
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
80102af7:	e8 e4 1b 00 00       	call   801046e0 <memcmp>
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
80102bc0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
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
80102be0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 36 11 80    	push   0x801136e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 36 11 80 	push   -0x7feec914(,%edi,4)
80102c04:	ff 35 e4 36 11 80    	push   0x801136e4
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
80102c24:	e8 07 1b 00 00       	call   80104730 <memmove>
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
80102c44:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
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
80102c67:	ff 35 d4 36 11 80    	push   0x801136d4
80102c6d:	ff 35 e4 36 11 80    	push   0x801136e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
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
80102cca:	68 e0 8a 10 80       	push   $0x80108ae0
80102ccf:	68 a0 36 11 80       	push   $0x801136a0
80102cd4:	e8 27 17 00 00       	call   80104400 <initlock>
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
80102ce9:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
80102cf7:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
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
80102d40:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
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
80102d66:	68 a0 36 11 80       	push   $0x801136a0
80102d6b:	e8 60 18 00 00       	call   801045d0 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 a0 36 11 80       	push   $0x801136a0
80102d80:	68 a0 36 11 80       	push   $0x801136a0
80102d85:	e8 e6 12 00 00       	call   80104070 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d9b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
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
80102db2:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102db7:	68 a0 36 11 80       	push   $0x801136a0
80102dbc:	e8 af 17 00 00       	call   80104570 <release>
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
80102dd9:	68 a0 36 11 80       	push   $0x801136a0
80102dde:	e8 ed 17 00 00       	call   801045d0 <acquire>
  log.outstanding -= 1;
80102de3:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102de8:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 a0 36 11 80       	push   $0x801136a0
80102e1c:	e8 4f 17 00 00       	call   80104570 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 a0 36 11 80       	push   $0x801136a0
80102e36:	e8 95 17 00 00       	call   801045d0 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102e42:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 df 12 00 00       	call   80104130 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e58:	e8 13 17 00 00       	call   80104570 <release>
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
80102e70:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 36 11 80    	push   0x801136e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 36 11 80 	push   -0x7feec914(,%ebx,4)
80102e94:	ff 35 e4 36 11 80    	push   0x801136e4
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
80102eb4:	e8 77 18 00 00       	call   80104730 <memmove>
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
80102ed4:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 36 11 80       	push   $0x801136a0
80102f08:	e8 23 12 00 00       	call   80104130 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102f14:	e8 57 16 00 00       	call   80104570 <release>
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
80102f27:	68 e4 8a 10 80       	push   $0x80108ae4
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
80102f47:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 a0 36 11 80       	push   $0x801136a0
80102f76:	e8 55 16 00 00       	call   801045d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
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
80102f97:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 b6 15 00 00       	jmp    80104570 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 f3 8a 10 80       	push   $0x80108af3
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 09 8b 10 80       	push   $0x80108b09
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
80103007:	e8 54 09 00 00       	call   80103960 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 4d 09 00 00       	call   80103960 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 24 8b 10 80       	push   $0x80108b24
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 49 29 00 00       	call   80105970 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 d4 08 00 00       	call   80103900 <mycpu>
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
80103046:	e8 e5 3a 00 00       	call   80106b30 <switchkvm>
  seginit();
8010304b:	e8 d0 38 00 00       	call   80106920 <seginit>
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
80103077:	68 d0 f6 11 80       	push   $0x8011f6d0
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 8a 3f 00 00       	call   80107010 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 8b 38 00 00       	call   80106920 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 f7 2b 00 00       	call   80105ca0 <uartinit>
  pinit();         // process table
801030a9:	e8 32 08 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 3d 28 00 00       	call   801058f0 <tvinit>
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
801030ca:	68 8c c4 10 80       	push   $0x8010c48c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 57 16 00 00       	call   80104730 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 84 37 11 80 b0 	imul   $0xb0,0x80113784,%eax
801030e3:	00 00 00 
801030e6:	05 a0 37 11 80       	add    $0x801137a0,%eax
801030eb:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 84 37 11 80 b0 	imul   $0xb0,0x80113784,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 37 11 80       	add    $0x801137a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 e2 07 00 00       	call   80103900 <mycpu>
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
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
8010313b:	b0 10 00 
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
80103182:	e8 29 08 00 00       	call   801039b0 <userinit>
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
801031be:	68 38 8b 10 80       	push   $0x80108b38
801031c3:	56                   	push   %esi
801031c4:	e8 17 15 00 00       	call   801046e0 <memcmp>
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
80103276:	68 3d 8b 10 80       	push   $0x80108b3d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 5c 14 00 00       	call   801046e0 <memcmp>
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
801032d6:	a3 80 36 11 80       	mov    %eax,0x80113680
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
80103357:	88 0d 80 37 11 80    	mov    %cl,0x80113780
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 84 37 11 80    	mov    0x80113784,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 84 37 11 80    	mov    %ecx,0x80113784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 37 11 80    	mov    %bl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 42 8b 10 80       	push   $0x80108b42
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
801033c2:	68 38 8b 10 80       	push   $0x80108b38
801033c7:	53                   	push   %ebx
801033c8:	e8 13 13 00 00       	call   801046e0 <memcmp>
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
801033f8:	68 5c 8b 10 80       	push   $0x80108b5c
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
801034a3:	68 7b 8b 10 80       	push   $0x80108b7b
801034a8:	50                   	push   %eax
801034a9:	e8 52 0f 00 00       	call   80104400 <initlock>
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
8010353f:	e8 8c 10 00 00       	call   801045d0 <acquire>
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
8010355f:	e8 cc 0b 00 00       	call   80104130 <wakeup>
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
80103584:	e9 e7 0f 00 00       	jmp    80104570 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 d7 0f 00 00       	call   80104570 <release>
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
801035c4:	e8 67 0b 00 00       	call   80104130 <wakeup>
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
801035dd:	e8 ee 0f 00 00       	call   801045d0 <acquire>
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
80103628:	e8 53 03 00 00       	call   80103980 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 f3 0a 00 00       	call   80104130 <wakeup>
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
8010366c:	e8 ff 0e 00 00       	call   80104570 <release>
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
801036ba:	e8 71 0a 00 00       	call   80104130 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 a9 0e 00 00       	call   80104570 <release>
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
801036e6:	e8 e5 0e 00 00       	call   801045d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 7b 02 00 00       	call   80103980 <myproc>
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
80103776:	e8 b5 09 00 00       	call   80104130 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 ed 0d 00 00       	call   80104570 <release>
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
80103799:	e8 d2 0d 00 00       	call   80104570 <release>
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
801037b4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 20 3d 11 80       	push   $0x80113d20
801037c1:	e8 0a 0e 00 00       	call   801045d0 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 13                	jmp    801037de <allocproc+0x2e>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 84 02 00 00    	add    $0x284,%ebx
801037d6:	81 fb 54 de 11 80    	cmp    $0x8011de54,%ebx
801037dc:	74 7a                	je     80103858 <allocproc+0xa8>
    if(p->state == UNUSED)
801037de:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e1:	85 c0                	test   %eax,%eax
801037e3:	75 eb                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e5:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
801037ea:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037ed:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037f4:	89 43 10             	mov    %eax,0x10(%ebx)
801037f7:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037fa:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
801037ff:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103805:	e8 66 0d 00 00       	call   80104570 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010380a:	e8 71 ee ff ff       	call   80102680 <kalloc>
8010380f:	83 c4 10             	add    $0x10,%esp
80103812:	89 43 08             	mov    %eax,0x8(%ebx)
80103815:	85 c0                	test   %eax,%eax
80103817:	74 58                	je     80103871 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103819:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010381f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103822:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103827:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010382a:	c7 40 14 e2 58 10 80 	movl   $0x801058e2,0x14(%eax)
  p->context = (struct context*)sp;
80103831:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103834:	6a 14                	push   $0x14
80103836:	6a 00                	push   $0x0
80103838:	50                   	push   %eax
80103839:	e8 52 0e 00 00       	call   80104690 <memset>
  p->context->eip = (uint)forkret;
8010383e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103841:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103844:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)
}
8010384b:	89 d8                	mov    %ebx,%eax
8010384d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103850:	c9                   	leave  
80103851:	c3                   	ret    
80103852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103858:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010385b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010385d:	68 20 3d 11 80       	push   $0x80113d20
80103862:	e8 09 0d 00 00       	call   80104570 <release>
}
80103867:	89 d8                	mov    %ebx,%eax
  return 0;
80103869:	83 c4 10             	add    $0x10,%esp
}
8010386c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386f:	c9                   	leave  
80103870:	c3                   	ret    
    p->state = UNUSED;
80103871:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103878:	31 db                	xor    %ebx,%ebx
}
8010387a:	89 d8                	mov    %ebx,%eax
8010387c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010387f:	c9                   	leave  
80103880:	c3                   	ret    
80103881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010388f:	90                   	nop

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103896:	68 20 3d 11 80       	push   $0x80113d20
8010389b:	e8 d0 0c 00 00       	call   80104570 <release>

  if (first) {
801038a0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	85 c0                	test   %eax,%eax
801038aa:	75 04                	jne    801038b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ac:	c9                   	leave  
801038ad:	c3                   	ret    
801038ae:	66 90                	xchg   %ax,%ax
    first = 0;
801038b0:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801038b7:	00 00 00 
    iinit(ROOTDEV);
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	6a 01                	push   $0x1
801038bf:	e8 9c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038cb:	e8 f0 f3 ff ff       	call   80102cc0 <initlog>
}
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	c9                   	leave  
801038d4:	c3                   	ret    
801038d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038e0 <pinit>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038e6:	68 80 8b 10 80       	push   $0x80108b80
801038eb:	68 20 3d 11 80       	push   $0x80113d20
801038f0:	e8 0b 0b 00 00       	call   80104400 <initlock>
}
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	c9                   	leave  
801038f9:	c3                   	ret    
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <mycpu>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103905:	9c                   	pushf  
80103906:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103907:	f6 c4 02             	test   $0x2,%ah
8010390a:	75 46                	jne    80103952 <mycpu+0x52>
  apicid = lapicid();
8010390c:	e8 df ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103911:	8b 35 84 37 11 80    	mov    0x80113784,%esi
80103917:	85 f6                	test   %esi,%esi
80103919:	7e 2a                	jle    80103945 <mycpu+0x45>
8010391b:	31 d2                	xor    %edx,%edx
8010391d:	eb 08                	jmp    80103927 <mycpu+0x27>
8010391f:	90                   	nop
80103920:	83 c2 01             	add    $0x1,%edx
80103923:	39 f2                	cmp    %esi,%edx
80103925:	74 1e                	je     80103945 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103927:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010392d:	0f b6 99 a0 37 11 80 	movzbl -0x7feec860(%ecx),%ebx
80103934:	39 c3                	cmp    %eax,%ebx
80103936:	75 e8                	jne    80103920 <mycpu+0x20>
}
80103938:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010393b:	8d 81 a0 37 11 80    	lea    -0x7feec860(%ecx),%eax
}
80103941:	5b                   	pop    %ebx
80103942:	5e                   	pop    %esi
80103943:	5d                   	pop    %ebp
80103944:	c3                   	ret    
  panic("unknown apicid\n");
80103945:	83 ec 0c             	sub    $0xc,%esp
80103948:	68 87 8b 10 80       	push   $0x80108b87
8010394d:	e8 2e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103952:	83 ec 0c             	sub    $0xc,%esp
80103955:	68 64 8c 10 80       	push   $0x80108c64
8010395a:	e8 21 ca ff ff       	call   80100380 <panic>
8010395f:	90                   	nop

80103960 <cpuid>:
cpuid() {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103966:	e8 95 ff ff ff       	call   80103900 <mycpu>
}
8010396b:	c9                   	leave  
  return mycpu()-cpus;
8010396c:	2d a0 37 11 80       	sub    $0x801137a0,%eax
80103971:	c1 f8 04             	sar    $0x4,%eax
80103974:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397a:	c3                   	ret    
8010397b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010397f:	90                   	nop

80103980 <myproc>:
myproc(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103987:	e8 f4 0a 00 00       	call   80104480 <pushcli>
  c = mycpu();
8010398c:	e8 6f ff ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103991:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103997:	e8 34 0b 00 00       	call   801044d0 <popcli>
}
8010399c:	89 d8                	mov    %ebx,%eax
8010399e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a1:	c9                   	leave  
801039a2:	c3                   	ret    
801039a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039b0 <userinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039b7:	e8 f4 fd ff ff       	call   801037b0 <allocproc>
801039bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039be:	a3 54 de 11 80       	mov    %eax,0x8011de54
  if((p->pgdir = setupkvm()) == 0)
801039c3:	e8 c8 35 00 00       	call   80106f90 <setupkvm>
801039c8:	89 43 04             	mov    %eax,0x4(%ebx)
801039cb:	85 c0                	test   %eax,%eax
801039cd:	0f 84 bd 00 00 00    	je     80103a90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d3:	83 ec 04             	sub    $0x4,%esp
801039d6:	68 2c 00 00 00       	push   $0x2c
801039db:	68 60 c4 10 80       	push   $0x8010c460
801039e0:	50                   	push   %eax
801039e1:	e8 6a 32 00 00       	call   80106c50 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039e6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ef:	6a 4c                	push   $0x4c
801039f1:	6a 00                	push   $0x0
801039f3:	ff 73 18             	push   0x18(%ebx)
801039f6:	e8 95 0c 00 00       	call   80104690 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	8b 43 18             	mov    0x18(%ebx),%eax
801039fe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a03:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a06:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a21:	8b 43 18             	mov    0x18(%ebx),%eax
80103a24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a40:	8b 43 18             	mov    0x18(%ebx),%eax
80103a43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 b0 8b 10 80       	push   $0x80108bb0
80103a54:	50                   	push   %eax
80103a55:	e8 f6 0d 00 00       	call   80104850 <safestrcpy>
  p->cwd = namei("/");
80103a5a:	c7 04 24 b9 8b 10 80 	movl   $0x80108bb9,(%esp)
80103a61:	e8 3a e6 ff ff       	call   801020a0 <namei>
80103a66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a69:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a70:	e8 5b 0b 00 00       	call   801045d0 <acquire>
  p->state = RUNNABLE;
80103a75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a7c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a83:	e8 e8 0a 00 00       	call   80104570 <release>
}
80103a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8b:	83 c4 10             	add    $0x10,%esp
80103a8e:	c9                   	leave  
80103a8f:	c3                   	ret    
    panic("userinit: out of memory?");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 97 8b 10 80       	push   $0x80108b97
80103a98:	e8 e3 c8 ff ff       	call   80100380 <panic>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi

80103aa0 <growproc>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aa8:	e8 d3 09 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103aad:	e8 4e fe ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ab2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab8:	e8 13 0a 00 00       	call   801044d0 <popcli>
  sz = curproc->sz;
80103abd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103abf:	85 f6                	test   %esi,%esi
80103ac1:	7f 1d                	jg     80103ae0 <growproc+0x40>
  } else if(n < 0){
80103ac3:	75 3b                	jne    80103b00 <growproc+0x60>
  switchuvm(curproc);
80103ac5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ac8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aca:	53                   	push   %ebx
80103acb:	e8 70 30 00 00       	call   80106b40 <switchuvm>
  return 0;
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	31 c0                	xor    %eax,%eax
}
80103ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad8:	5b                   	pop    %ebx
80103ad9:	5e                   	pop    %esi
80103ada:	5d                   	pop    %ebp
80103adb:	c3                   	ret    
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	push   0x4(%ebx)
80103aea:	e8 d1 32 00 00       	call   80106dc0 <allocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 cf                	jne    80103ac5 <growproc+0x25>
      return -1;
80103af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103afb:	eb d8                	jmp    80103ad5 <growproc+0x35>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 d1 33 00 00       	call   80106ee0 <deallocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 af                	jne    80103ac5 <growproc+0x25>
80103b16:	eb de                	jmp    80103af6 <growproc+0x56>
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <fork>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b29:	e8 52 09 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103b2e:	e8 cd fd ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103b33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b39:	e8 92 09 00 00       	call   801044d0 <popcli>
  if((np = allocproc()) == 0){
80103b3e:	e8 6d fc ff ff       	call   801037b0 <allocproc>
80103b43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b46:	85 c0                	test   %eax,%eax
80103b48:	0f 84 c7 00 00 00    	je     80103c15 <fork+0xf5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b4e:	83 ec 08             	sub    $0x8,%esp
80103b51:	ff 33                	push   (%ebx)
80103b53:	89 c7                	mov    %eax,%edi
80103b55:	ff 73 04             	push   0x4(%ebx)
80103b58:	e8 23 35 00 00       	call   80107080 <copyuvm>
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	89 47 04             	mov    %eax,0x4(%edi)
80103b63:	85 c0                	test   %eax,%eax
80103b65:	0f 84 b1 00 00 00    	je     80103c1c <fork+0xfc>
  np->sz = curproc->sz;
80103b6b:	8b 03                	mov    (%ebx),%eax
80103b6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  copy_maps(curproc,np);
80103b70:	83 ec 08             	sub    $0x8,%esp
  np->sz = curproc->sz;
80103b73:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b75:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b78:	89 c8                	mov    %ecx,%eax
80103b7a:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b7d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b82:	8b 73 18             	mov    0x18(%ebx),%esi
80103b85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  copy_maps(curproc,np);
80103b87:	50                   	push   %eax
80103b88:	89 c7                	mov    %eax,%edi
  for(i = 0; i < NOFILE; i++)
80103b8a:	31 f6                	xor    %esi,%esi
  copy_maps(curproc,np);
80103b8c:	53                   	push   %ebx
80103b8d:	e8 2e 47 00 00       	call   801082c0 <copy_maps>
  np->tf->eax = 0;
80103b92:	8b 47 18             	mov    0x18(%edi),%eax
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103b9f:	90                   	nop
    if(curproc->ofile[i])
80103ba0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	74 13                	je     80103bbb <fork+0x9b>
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
80103bc1:	75 dd                	jne    80103ba0 <fork+0x80>
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
80103be1:	e8 6a 0c 00 00       	call   80104850 <safestrcpy>
  pid = np->pid;
80103be6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103be9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bf0:	e8 db 09 00 00       	call   801045d0 <acquire>
  np->state = RUNNABLE;
80103bf5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bfc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c03:	e8 68 09 00 00       	call   80104570 <release>
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
80103c1a:	eb ef                	jmp    80103c0b <fork+0xeb>
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
80103c40:	eb c9                	jmp    80103c0b <fork+0xeb>
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
80103c59:	e8 a2 fc ff ff       	call   80103900 <mycpu>
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
80103c74:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    acquire(&ptable.lock);
80103c79:	68 20 3d 11 80       	push   $0x80113d20
80103c7e:	e8 4d 09 00 00       	call   801045d0 <acquire>
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
80103ca0:	e8 9b 2e 00 00       	call   80106b40 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ca5:	58                   	pop    %eax
80103ca6:	5a                   	pop    %edx
80103ca7:	ff 73 1c             	push   0x1c(%ebx)
80103caa:	57                   	push   %edi
      p->state = RUNNING;
80103cab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103cb2:	e8 f4 0b 00 00       	call   801048ab <swtch>
      switchkvm();
80103cb7:	e8 74 2e 00 00       	call   80106b30 <switchkvm>
      c->proc = 0;
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc9:	81 c3 84 02 00 00    	add    $0x284,%ebx
80103ccf:	81 fb 54 de 11 80    	cmp    $0x8011de54,%ebx
80103cd5:	75 b9                	jne    80103c90 <scheduler+0x40>
    release(&ptable.lock);
80103cd7:	83 ec 0c             	sub    $0xc,%esp
80103cda:	68 20 3d 11 80       	push   $0x80113d20
80103cdf:	e8 8c 08 00 00       	call   80104570 <release>
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
80103cf5:	e8 86 07 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103cfa:	e8 01 fc ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103cff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d05:	e8 c6 07 00 00       	call   801044d0 <popcli>
  if(!holding(&ptable.lock))
80103d0a:	83 ec 0c             	sub    $0xc,%esp
80103d0d:	68 20 3d 11 80       	push   $0x80113d20
80103d12:	e8 19 08 00 00       	call   80104530 <holding>
80103d17:	83 c4 10             	add    $0x10,%esp
80103d1a:	85 c0                	test   %eax,%eax
80103d1c:	74 4f                	je     80103d6d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d1e:	e8 dd fb ff ff       	call   80103900 <mycpu>
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
80103d39:	e8 c2 fb ff ff       	call   80103900 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d3e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d47:	e8 b4 fb ff ff       	call   80103900 <mycpu>
80103d4c:	83 ec 08             	sub    $0x8,%esp
80103d4f:	ff 70 04             	push   0x4(%eax)
80103d52:	53                   	push   %ebx
80103d53:	e8 53 0b 00 00       	call   801048ab <swtch>
  mycpu()->intena = intena;
80103d58:	e8 a3 fb ff ff       	call   80103900 <mycpu>
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
80103d70:	68 bb 8b 10 80       	push   $0x80108bbb
80103d75:	e8 06 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d7a:	83 ec 0c             	sub    $0xc,%esp
80103d7d:	68 e7 8b 10 80       	push   $0x80108be7
80103d82:	e8 f9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d87:	83 ec 0c             	sub    $0xc,%esp
80103d8a:	68 d9 8b 10 80       	push   $0x80108bd9
80103d8f:	e8 ec c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	68 cd 8b 10 80       	push   $0x80108bcd
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
80103db9:	e8 c2 fb ff ff       	call   80103980 <myproc>
  if(curproc == initproc)
80103dbe:	39 05 54 de 11 80    	cmp    %eax,0x8011de54
80103dc4:	0f 84 17 01 00 00    	je     80103ee1 <exit+0x131>
80103dca:	89 c3                	mov    %eax,%ebx
  delete_mmaps(myproc());
80103dcc:	e8 af fb ff ff       	call   80103980 <myproc>
80103dd1:	83 ec 0c             	sub    $0xc,%esp
80103dd4:	8d 73 28             	lea    0x28(%ebx),%esi
80103dd7:	8d 7b 68             	lea    0x68(%ebx),%edi
80103dda:	50                   	push   %eax
80103ddb:	e8 40 47 00 00       	call   80108520 <delete_mmaps>
  for(fd = 0; fd < NOFILE; fd++){
80103de0:	83 c4 10             	add    $0x10,%esp
80103de3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103de7:	90                   	nop
    if(curproc->ofile[fd]){
80103de8:	8b 06                	mov    (%esi),%eax
80103dea:	85 c0                	test   %eax,%eax
80103dec:	74 12                	je     80103e00 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103dee:	83 ec 0c             	sub    $0xc,%esp
80103df1:	50                   	push   %eax
80103df2:	e8 f9 d0 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103df7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103dfd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e00:	83 c6 04             	add    $0x4,%esi
80103e03:	39 fe                	cmp    %edi,%esi
80103e05:	75 e1                	jne    80103de8 <exit+0x38>
  begin_op();
80103e07:	e8 54 ef ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
80103e0c:	83 ec 0c             	sub    $0xc,%esp
80103e0f:	ff 73 68             	push   0x68(%ebx)
80103e12:	e8 99 da ff ff       	call   801018b0 <iput>
  end_op();
80103e17:	e8 b4 ef ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80103e1c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e23:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e2a:	e8 a1 07 00 00       	call   801045d0 <acquire>
  wakeup1(curproc->parent);
80103e2f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e32:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e35:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103e3a:	eb 10                	jmp    80103e4c <exit+0x9c>
80103e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e40:	05 84 02 00 00       	add    $0x284,%eax
80103e45:	3d 54 de 11 80       	cmp    $0x8011de54,%eax
80103e4a:	74 1e                	je     80103e6a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103e4c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e50:	75 ee                	jne    80103e40 <exit+0x90>
80103e52:	3b 50 20             	cmp    0x20(%eax),%edx
80103e55:	75 e9                	jne    80103e40 <exit+0x90>
      p->state = RUNNABLE;
80103e57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e5e:	05 84 02 00 00       	add    $0x284,%eax
80103e63:	3d 54 de 11 80       	cmp    $0x8011de54,%eax
80103e68:	75 e2                	jne    80103e4c <exit+0x9c>
      p->parent = initproc;
80103e6a:	8b 0d 54 de 11 80    	mov    0x8011de54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e70:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103e75:	eb 17                	jmp    80103e8e <exit+0xde>
80103e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7e:	66 90                	xchg   %ax,%ax
80103e80:	81 c2 84 02 00 00    	add    $0x284,%edx
80103e86:	81 fa 54 de 11 80    	cmp    $0x8011de54,%edx
80103e8c:	74 3a                	je     80103ec8 <exit+0x118>
    if(p->parent == curproc){
80103e8e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e91:	75 ed                	jne    80103e80 <exit+0xd0>
      if(p->state == ZOMBIE)
80103e93:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e97:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e9a:	75 e4                	jne    80103e80 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e9c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ea1:	eb 11                	jmp    80103eb4 <exit+0x104>
80103ea3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ea7:	90                   	nop
80103ea8:	05 84 02 00 00       	add    $0x284,%eax
80103ead:	3d 54 de 11 80       	cmp    $0x8011de54,%eax
80103eb2:	74 cc                	je     80103e80 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103eb4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eb8:	75 ee                	jne    80103ea8 <exit+0xf8>
80103eba:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ebd:	75 e9                	jne    80103ea8 <exit+0xf8>
      p->state = RUNNABLE;
80103ebf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ec6:	eb e0                	jmp    80103ea8 <exit+0xf8>
  curproc->state = ZOMBIE;
80103ec8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ecf:	e8 1c fe ff ff       	call   80103cf0 <sched>
  panic("zombie exit");
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	68 08 8c 10 80       	push   $0x80108c08
80103edc:	e8 9f c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ee1:	83 ec 0c             	sub    $0xc,%esp
80103ee4:	68 fb 8b 10 80       	push   $0x80108bfb
80103ee9:	e8 92 c4 ff ff       	call   80100380 <panic>
80103eee:	66 90                	xchg   %ax,%ax

80103ef0 <wait>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
  pushcli();
80103ef5:	e8 86 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103efa:	e8 01 fa ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103eff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f05:	e8 c6 05 00 00       	call   801044d0 <popcli>
  acquire(&ptable.lock);
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 20 3d 11 80       	push   $0x80113d20
80103f12:	e8 b9 06 00 00       	call   801045d0 <acquire>
80103f17:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f1a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f1c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103f21:	eb 13                	jmp    80103f36 <wait+0x46>
80103f23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f27:	90                   	nop
80103f28:	81 c3 84 02 00 00    	add    $0x284,%ebx
80103f2e:	81 fb 54 de 11 80    	cmp    $0x8011de54,%ebx
80103f34:	74 1e                	je     80103f54 <wait+0x64>
      if(p->parent != curproc)
80103f36:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f39:	75 ed                	jne    80103f28 <wait+0x38>
      if(p->state == ZOMBIE){
80103f3b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f3f:	74 5f                	je     80103fa0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f41:	81 c3 84 02 00 00    	add    $0x284,%ebx
      havekids = 1;
80103f47:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f4c:	81 fb 54 de 11 80    	cmp    $0x8011de54,%ebx
80103f52:	75 e2                	jne    80103f36 <wait+0x46>
    if(!havekids || curproc->killed){
80103f54:	85 c0                	test   %eax,%eax
80103f56:	0f 84 9a 00 00 00    	je     80103ff6 <wait+0x106>
80103f5c:	8b 46 24             	mov    0x24(%esi),%eax
80103f5f:	85 c0                	test   %eax,%eax
80103f61:	0f 85 8f 00 00 00    	jne    80103ff6 <wait+0x106>
  pushcli();
80103f67:	e8 14 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103f6c:	e8 8f f9 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103f71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f77:	e8 54 05 00 00       	call   801044d0 <popcli>
  if(p == 0)
80103f7c:	85 db                	test   %ebx,%ebx
80103f7e:	0f 84 89 00 00 00    	je     8010400d <wait+0x11d>
  p->chan = chan;
80103f84:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f87:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f8e:	e8 5d fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103f93:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f9a:	e9 7b ff ff ff       	jmp    80103f1a <wait+0x2a>
80103f9f:	90                   	nop
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
80103fb9:	e8 52 2f 00 00       	call   80106f10 <freevm>
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
80103fde:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103fe5:	e8 86 05 00 00       	call   80104570 <release>
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
80103ffe:	68 20 3d 11 80       	push   $0x80113d20
80104003:	e8 68 05 00 00       	call   80104570 <release>
      return -1;
80104008:	83 c4 10             	add    $0x10,%esp
8010400b:	eb e0                	jmp    80103fed <wait+0xfd>
    panic("sleep");
8010400d:	83 ec 0c             	sub    $0xc,%esp
80104010:	68 14 8c 10 80       	push   $0x80108c14
80104015:	e8 66 c3 ff ff       	call   80100380 <panic>
8010401a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104020 <yield>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	53                   	push   %ebx
80104024:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104027:	68 20 3d 11 80       	push   $0x80113d20
8010402c:	e8 9f 05 00 00       	call   801045d0 <acquire>
  pushcli();
80104031:	e8 4a 04 00 00       	call   80104480 <pushcli>
  c = mycpu();
80104036:	e8 c5 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010403b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104041:	e8 8a 04 00 00       	call   801044d0 <popcli>
  myproc()->state = RUNNABLE;
80104046:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010404d:	e8 9e fc ff ff       	call   80103cf0 <sched>
  release(&ptable.lock);
80104052:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104059:	e8 12 05 00 00       	call   80104570 <release>
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
8010407f:	e8 fc 03 00 00       	call   80104480 <pushcli>
  c = mycpu();
80104084:	e8 77 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80104089:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010408f:	e8 3c 04 00 00       	call   801044d0 <popcli>
  if(p == 0)
80104094:	85 db                	test   %ebx,%ebx
80104096:	0f 84 87 00 00 00    	je     80104123 <sleep+0xb3>
  if(lk == 0)
8010409c:	85 f6                	test   %esi,%esi
8010409e:	74 76                	je     80104116 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040a0:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
801040a6:	74 50                	je     801040f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	68 20 3d 11 80       	push   $0x80113d20
801040b0:	e8 1b 05 00 00       	call   801045d0 <acquire>
    release(lk);
801040b5:	89 34 24             	mov    %esi,(%esp)
801040b8:	e8 b3 04 00 00       	call   80104570 <release>
  p->chan = chan;
801040bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040c7:	e8 24 fc ff ff       	call   80103cf0 <sched>
  p->chan = 0;
801040cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040d3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801040da:	e8 91 04 00 00       	call   80104570 <release>
    acquire(lk);
801040df:	89 75 08             	mov    %esi,0x8(%ebp)
801040e2:	83 c4 10             	add    $0x10,%esp
}
801040e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040e8:	5b                   	pop    %ebx
801040e9:	5e                   	pop    %esi
801040ea:	5f                   	pop    %edi
801040eb:	5d                   	pop    %ebp
    acquire(lk);
801040ec:	e9 df 04 00 00       	jmp    801045d0 <acquire>
801040f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104102:	e8 e9 fb ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80104107:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010410e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104111:	5b                   	pop    %ebx
80104112:	5e                   	pop    %esi
80104113:	5f                   	pop    %edi
80104114:	5d                   	pop    %ebp
80104115:	c3                   	ret    
    panic("sleep without lk");
80104116:	83 ec 0c             	sub    $0xc,%esp
80104119:	68 1a 8c 10 80       	push   $0x80108c1a
8010411e:	e8 5d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104123:	83 ec 0c             	sub    $0xc,%esp
80104126:	68 14 8c 10 80       	push   $0x80108c14
8010412b:	e8 50 c2 ff ff       	call   80100380 <panic>

80104130 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
80104137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010413a:	68 20 3d 11 80       	push   $0x80113d20
8010413f:	e8 8c 04 00 00       	call   801045d0 <acquire>
80104144:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104147:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010414c:	eb 0e                	jmp    8010415c <wakeup+0x2c>
8010414e:	66 90                	xchg   %ax,%ax
80104150:	05 84 02 00 00       	add    $0x284,%eax
80104155:	3d 54 de 11 80       	cmp    $0x8011de54,%eax
8010415a:	74 1e                	je     8010417a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010415c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104160:	75 ee                	jne    80104150 <wakeup+0x20>
80104162:	3b 58 20             	cmp    0x20(%eax),%ebx
80104165:	75 e9                	jne    80104150 <wakeup+0x20>
      p->state = RUNNABLE;
80104167:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010416e:	05 84 02 00 00       	add    $0x284,%eax
80104173:	3d 54 de 11 80       	cmp    $0x8011de54,%eax
80104178:	75 e2                	jne    8010415c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010417a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104181:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104184:	c9                   	leave  
  release(&ptable.lock);
80104185:	e9 e6 03 00 00       	jmp    80104570 <release>
8010418a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104190 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 10             	sub    $0x10,%esp
80104197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010419a:	68 20 3d 11 80       	push   $0x80113d20
8010419f:	e8 2c 04 00 00       	call   801045d0 <acquire>
801041a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041a7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801041ac:	eb 0e                	jmp    801041bc <kill+0x2c>
801041ae:	66 90                	xchg   %ax,%ax
801041b0:	05 84 02 00 00       	add    $0x284,%eax
801041b5:	3d 54 de 11 80       	cmp    $0x8011de54,%eax
801041ba:	74 34                	je     801041f0 <kill+0x60>
    if(p->pid == pid){
801041bc:	39 58 10             	cmp    %ebx,0x10(%eax)
801041bf:	75 ef                	jne    801041b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041c1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041c5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041cc:	75 07                	jne    801041d5 <kill+0x45>
        p->state = RUNNABLE;
801041ce:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041d5:	83 ec 0c             	sub    $0xc,%esp
801041d8:	68 20 3d 11 80       	push   $0x80113d20
801041dd:	e8 8e 03 00 00       	call   80104570 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041e5:	83 c4 10             	add    $0x10,%esp
801041e8:	31 c0                	xor    %eax,%eax
}
801041ea:	c9                   	leave  
801041eb:	c3                   	ret    
801041ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	68 20 3d 11 80       	push   $0x80113d20
801041f8:	e8 73 03 00 00       	call   80104570 <release>
}
801041fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104200:	83 c4 10             	add    $0x10,%esp
80104203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104208:	c9                   	leave  
80104209:	c3                   	ret    
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104210 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104218:	53                   	push   %ebx
80104219:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010421e:	83 ec 3c             	sub    $0x3c,%esp
80104221:	eb 27                	jmp    8010424a <procdump+0x3a>
80104223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104227:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	68 07 90 10 80       	push   $0x80109007
80104230:	e8 6b c4 ff ff       	call   801006a0 <cprintf>
80104235:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104238:	81 c3 84 02 00 00    	add    $0x284,%ebx
8010423e:	81 fb c0 de 11 80    	cmp    $0x8011dec0,%ebx
80104244:	0f 84 7e 00 00 00    	je     801042c8 <procdump+0xb8>
    if(p->state == UNUSED)
8010424a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010424d:	85 c0                	test   %eax,%eax
8010424f:	74 e7                	je     80104238 <procdump+0x28>
      state = "???";
80104251:	ba 2b 8c 10 80       	mov    $0x80108c2b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104256:	83 f8 05             	cmp    $0x5,%eax
80104259:	77 11                	ja     8010426c <procdump+0x5c>
8010425b:	8b 14 85 8c 8c 10 80 	mov    -0x7fef7374(,%eax,4),%edx
      state = "???";
80104262:	b8 2b 8c 10 80       	mov    $0x80108c2b,%eax
80104267:	85 d2                	test   %edx,%edx
80104269:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010426c:	53                   	push   %ebx
8010426d:	52                   	push   %edx
8010426e:	ff 73 a4             	push   -0x5c(%ebx)
80104271:	68 2f 8c 10 80       	push   $0x80108c2f
80104276:	e8 25 c4 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010427b:	83 c4 10             	add    $0x10,%esp
8010427e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104282:	75 a4                	jne    80104228 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104284:	83 ec 08             	sub    $0x8,%esp
80104287:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010428a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010428d:	50                   	push   %eax
8010428e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104291:	8b 40 0c             	mov    0xc(%eax),%eax
80104294:	83 c0 08             	add    $0x8,%eax
80104297:	50                   	push   %eax
80104298:	e8 83 01 00 00       	call   80104420 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010429d:	83 c4 10             	add    $0x10,%esp
801042a0:	8b 17                	mov    (%edi),%edx
801042a2:	85 d2                	test   %edx,%edx
801042a4:	74 82                	je     80104228 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801042a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801042ac:	52                   	push   %edx
801042ad:	68 81 86 10 80       	push   $0x80108681
801042b2:	e8 e9 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042b7:	83 c4 10             	add    $0x10,%esp
801042ba:	39 fe                	cmp    %edi,%esi
801042bc:	75 e2                	jne    801042a0 <procdump+0x90>
801042be:	e9 65 ff ff ff       	jmp    80104228 <procdump+0x18>
801042c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042c7:	90                   	nop
  }
}
801042c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042cb:	5b                   	pop    %ebx
801042cc:	5e                   	pop    %esi
801042cd:	5f                   	pop    %edi
801042ce:	5d                   	pop    %ebp
801042cf:	c3                   	ret    

801042d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042da:	68 a4 8c 10 80       	push   $0x80108ca4
801042df:	8d 43 04             	lea    0x4(%ebx),%eax
801042e2:	50                   	push   %eax
801042e3:	e8 18 01 00 00       	call   80104400 <initlock>
  lk->name = name;
801042e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104301:	c9                   	leave  
80104302:	c3                   	ret    
80104303:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104310 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
80104315:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104318:	8d 73 04             	lea    0x4(%ebx),%esi
8010431b:	83 ec 0c             	sub    $0xc,%esp
8010431e:	56                   	push   %esi
8010431f:	e8 ac 02 00 00       	call   801045d0 <acquire>
  while (lk->locked) {
80104324:	8b 13                	mov    (%ebx),%edx
80104326:	83 c4 10             	add    $0x10,%esp
80104329:	85 d2                	test   %edx,%edx
8010432b:	74 16                	je     80104343 <acquiresleep+0x33>
8010432d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104330:	83 ec 08             	sub    $0x8,%esp
80104333:	56                   	push   %esi
80104334:	53                   	push   %ebx
80104335:	e8 36 fd ff ff       	call   80104070 <sleep>
  while (lk->locked) {
8010433a:	8b 03                	mov    (%ebx),%eax
8010433c:	83 c4 10             	add    $0x10,%esp
8010433f:	85 c0                	test   %eax,%eax
80104341:	75 ed                	jne    80104330 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104343:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104349:	e8 32 f6 ff ff       	call   80103980 <myproc>
8010434e:	8b 40 10             	mov    0x10(%eax),%eax
80104351:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104354:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104357:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010435a:	5b                   	pop    %ebx
8010435b:	5e                   	pop    %esi
8010435c:	5d                   	pop    %ebp
  release(&lk->lk);
8010435d:	e9 0e 02 00 00       	jmp    80104570 <release>
80104362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104370 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104378:	8d 73 04             	lea    0x4(%ebx),%esi
8010437b:	83 ec 0c             	sub    $0xc,%esp
8010437e:	56                   	push   %esi
8010437f:	e8 4c 02 00 00       	call   801045d0 <acquire>
  lk->locked = 0;
80104384:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010438a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104391:	89 1c 24             	mov    %ebx,(%esp)
80104394:	e8 97 fd ff ff       	call   80104130 <wakeup>
  release(&lk->lk);
80104399:	89 75 08             	mov    %esi,0x8(%ebp)
8010439c:	83 c4 10             	add    $0x10,%esp
}
8010439f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043a2:	5b                   	pop    %ebx
801043a3:	5e                   	pop    %esi
801043a4:	5d                   	pop    %ebp
  release(&lk->lk);
801043a5:	e9 c6 01 00 00       	jmp    80104570 <release>
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	57                   	push   %edi
801043b4:	31 ff                	xor    %edi,%edi
801043b6:	56                   	push   %esi
801043b7:	53                   	push   %ebx
801043b8:	83 ec 18             	sub    $0x18,%esp
801043bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043be:	8d 73 04             	lea    0x4(%ebx),%esi
801043c1:	56                   	push   %esi
801043c2:	e8 09 02 00 00       	call   801045d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043c7:	8b 03                	mov    (%ebx),%eax
801043c9:	83 c4 10             	add    $0x10,%esp
801043cc:	85 c0                	test   %eax,%eax
801043ce:	75 18                	jne    801043e8 <holdingsleep+0x38>
  release(&lk->lk);
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	56                   	push   %esi
801043d4:	e8 97 01 00 00       	call   80104570 <release>
  return r;
}
801043d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043dc:	89 f8                	mov    %edi,%eax
801043de:	5b                   	pop    %ebx
801043df:	5e                   	pop    %esi
801043e0:	5f                   	pop    %edi
801043e1:	5d                   	pop    %ebp
801043e2:	c3                   	ret    
801043e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801043e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043eb:	e8 90 f5 ff ff       	call   80103980 <myproc>
801043f0:	39 58 10             	cmp    %ebx,0x10(%eax)
801043f3:	0f 94 c0             	sete   %al
801043f6:	0f b6 c0             	movzbl %al,%eax
801043f9:	89 c7                	mov    %eax,%edi
801043fb:	eb d3                	jmp    801043d0 <holdingsleep+0x20>
801043fd:	66 90                	xchg   %ax,%ax
801043ff:	90                   	nop

80104400 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104406:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010440f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104412:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104419:	5d                   	pop    %ebp
8010441a:	c3                   	ret    
8010441b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010441f:	90                   	nop

80104420 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104420:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104421:	31 d2                	xor    %edx,%edx
{
80104423:	89 e5                	mov    %esp,%ebp
80104425:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104426:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104429:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010442c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010442f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104430:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104436:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010443c:	77 1a                	ja     80104458 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010443e:	8b 58 04             	mov    0x4(%eax),%ebx
80104441:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104444:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104447:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104449:	83 fa 0a             	cmp    $0xa,%edx
8010444c:	75 e2                	jne    80104430 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010444e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104451:	c9                   	leave  
80104452:	c3                   	ret    
80104453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104457:	90                   	nop
  for(; i < 10; i++)
80104458:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010445b:	8d 51 28             	lea    0x28(%ecx),%edx
8010445e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104460:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104466:	83 c0 04             	add    $0x4,%eax
80104469:	39 d0                	cmp    %edx,%eax
8010446b:	75 f3                	jne    80104460 <getcallerpcs+0x40>
}
8010446d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104470:	c9                   	leave  
80104471:	c3                   	ret    
80104472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104480 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 04             	sub    $0x4,%esp
80104487:	9c                   	pushf  
80104488:	5b                   	pop    %ebx
  asm volatile("cli");
80104489:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010448a:	e8 71 f4 ff ff       	call   80103900 <mycpu>
8010448f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104495:	85 c0                	test   %eax,%eax
80104497:	74 17                	je     801044b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104499:	e8 62 f4 ff ff       	call   80103900 <mycpu>
8010449e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a8:	c9                   	leave  
801044a9:	c3                   	ret    
801044aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801044b0:	e8 4b f4 ff ff       	call   80103900 <mycpu>
801044b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044c1:	eb d6                	jmp    80104499 <pushcli+0x19>
801044c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <popcli>:

void
popcli(void)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044d6:	9c                   	pushf  
801044d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044d8:	f6 c4 02             	test   $0x2,%ah
801044db:	75 35                	jne    80104512 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044dd:	e8 1e f4 ff ff       	call   80103900 <mycpu>
801044e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044e9:	78 34                	js     8010451f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044eb:	e8 10 f4 ff ff       	call   80103900 <mycpu>
801044f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044f6:	85 d2                	test   %edx,%edx
801044f8:	74 06                	je     80104500 <popcli+0x30>
    sti();
}
801044fa:	c9                   	leave  
801044fb:	c3                   	ret    
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104500:	e8 fb f3 ff ff       	call   80103900 <mycpu>
80104505:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010450b:	85 c0                	test   %eax,%eax
8010450d:	74 eb                	je     801044fa <popcli+0x2a>
  asm volatile("sti");
8010450f:	fb                   	sti    
}
80104510:	c9                   	leave  
80104511:	c3                   	ret    
    panic("popcli - interruptible");
80104512:	83 ec 0c             	sub    $0xc,%esp
80104515:	68 af 8c 10 80       	push   $0x80108caf
8010451a:	e8 61 be ff ff       	call   80100380 <panic>
    panic("popcli");
8010451f:	83 ec 0c             	sub    $0xc,%esp
80104522:	68 c6 8c 10 80       	push   $0x80108cc6
80104527:	e8 54 be ff ff       	call   80100380 <panic>
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <holding>:
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 75 08             	mov    0x8(%ebp),%esi
80104538:	31 db                	xor    %ebx,%ebx
  pushcli();
8010453a:	e8 41 ff ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010453f:	8b 06                	mov    (%esi),%eax
80104541:	85 c0                	test   %eax,%eax
80104543:	75 0b                	jne    80104550 <holding+0x20>
  popcli();
80104545:	e8 86 ff ff ff       	call   801044d0 <popcli>
}
8010454a:	89 d8                	mov    %ebx,%eax
8010454c:	5b                   	pop    %ebx
8010454d:	5e                   	pop    %esi
8010454e:	5d                   	pop    %ebp
8010454f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104550:	8b 5e 08             	mov    0x8(%esi),%ebx
80104553:	e8 a8 f3 ff ff       	call   80103900 <mycpu>
80104558:	39 c3                	cmp    %eax,%ebx
8010455a:	0f 94 c3             	sete   %bl
  popcli();
8010455d:	e8 6e ff ff ff       	call   801044d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104562:	0f b6 db             	movzbl %bl,%ebx
}
80104565:	89 d8                	mov    %ebx,%eax
80104567:	5b                   	pop    %ebx
80104568:	5e                   	pop    %esi
80104569:	5d                   	pop    %ebp
8010456a:	c3                   	ret    
8010456b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010456f:	90                   	nop

80104570 <release>:
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104578:	e8 03 ff ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010457d:	8b 03                	mov    (%ebx),%eax
8010457f:	85 c0                	test   %eax,%eax
80104581:	75 15                	jne    80104598 <release+0x28>
  popcli();
80104583:	e8 48 ff ff ff       	call   801044d0 <popcli>
    panic("release");
80104588:	83 ec 0c             	sub    $0xc,%esp
8010458b:	68 cd 8c 10 80       	push   $0x80108ccd
80104590:	e8 eb bd ff ff       	call   80100380 <panic>
80104595:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104598:	8b 73 08             	mov    0x8(%ebx),%esi
8010459b:	e8 60 f3 ff ff       	call   80103900 <mycpu>
801045a0:	39 c6                	cmp    %eax,%esi
801045a2:	75 df                	jne    80104583 <release+0x13>
  popcli();
801045a4:	e8 27 ff ff ff       	call   801044d0 <popcli>
  lk->pcs[0] = 0;
801045a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801045c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c5:	5b                   	pop    %ebx
801045c6:	5e                   	pop    %esi
801045c7:	5d                   	pop    %ebp
  popcli();
801045c8:	e9 03 ff ff ff       	jmp    801044d0 <popcli>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi

801045d0 <acquire>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801045d7:	e8 a4 fe ff ff       	call   80104480 <pushcli>
  if(holding(lk))
801045dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801045df:	e8 9c fe ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045e4:	8b 03                	mov    (%ebx),%eax
801045e6:	85 c0                	test   %eax,%eax
801045e8:	75 7e                	jne    80104668 <acquire+0x98>
  popcli();
801045ea:	e8 e1 fe ff ff       	call   801044d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801045ef:	b9 01 00 00 00       	mov    $0x1,%ecx
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801045f8:	8b 55 08             	mov    0x8(%ebp),%edx
801045fb:	89 c8                	mov    %ecx,%eax
801045fd:	f0 87 02             	lock xchg %eax,(%edx)
80104600:	85 c0                	test   %eax,%eax
80104602:	75 f4                	jne    801045f8 <acquire+0x28>
  __sync_synchronize();
80104604:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104609:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010460c:	e8 ef f2 ff ff       	call   80103900 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104611:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104614:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104616:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104619:	31 c0                	xor    %eax,%eax
8010461b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010461f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104620:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104626:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010462c:	77 1a                	ja     80104648 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010462e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104631:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104635:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104638:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010463a:	83 f8 0a             	cmp    $0xa,%eax
8010463d:	75 e1                	jne    80104620 <acquire+0x50>
}
8010463f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104642:	c9                   	leave  
80104643:	c3                   	ret    
80104644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104648:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010464c:	8d 51 34             	lea    0x34(%ecx),%edx
8010464f:	90                   	nop
    pcs[i] = 0;
80104650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104656:	83 c0 04             	add    $0x4,%eax
80104659:	39 c2                	cmp    %eax,%edx
8010465b:	75 f3                	jne    80104650 <acquire+0x80>
}
8010465d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104660:	c9                   	leave  
80104661:	c3                   	ret    
80104662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104668:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010466b:	e8 90 f2 ff ff       	call   80103900 <mycpu>
80104670:	39 c3                	cmp    %eax,%ebx
80104672:	0f 85 72 ff ff ff    	jne    801045ea <acquire+0x1a>
  popcli();
80104678:	e8 53 fe ff ff       	call   801044d0 <popcli>
    panic("acquire");
8010467d:	83 ec 0c             	sub    $0xc,%esp
80104680:	68 d5 8c 10 80       	push   $0x80108cd5
80104685:	e8 f6 bc ff ff       	call   80100380 <panic>
8010468a:	66 90                	xchg   %ax,%ax
8010468c:	66 90                	xchg   %ax,%ax
8010468e:	66 90                	xchg   %ax,%ax

80104690 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	8b 55 08             	mov    0x8(%ebp),%edx
80104697:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010469a:	53                   	push   %ebx
8010469b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010469e:	89 d7                	mov    %edx,%edi
801046a0:	09 cf                	or     %ecx,%edi
801046a2:	83 e7 03             	and    $0x3,%edi
801046a5:	75 29                	jne    801046d0 <memset+0x40>
    c &= 0xFF;
801046a7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046aa:	c1 e0 18             	shl    $0x18,%eax
801046ad:	89 fb                	mov    %edi,%ebx
801046af:	c1 e9 02             	shr    $0x2,%ecx
801046b2:	c1 e3 10             	shl    $0x10,%ebx
801046b5:	09 d8                	or     %ebx,%eax
801046b7:	09 f8                	or     %edi,%eax
801046b9:	c1 e7 08             	shl    $0x8,%edi
801046bc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046be:	89 d7                	mov    %edx,%edi
801046c0:	fc                   	cld    
801046c1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046c3:	5b                   	pop    %ebx
801046c4:	89 d0                	mov    %edx,%eax
801046c6:	5f                   	pop    %edi
801046c7:	5d                   	pop    %ebp
801046c8:	c3                   	ret    
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801046d0:	89 d7                	mov    %edx,%edi
801046d2:	fc                   	cld    
801046d3:	f3 aa                	rep stos %al,%es:(%edi)
801046d5:	5b                   	pop    %ebx
801046d6:	89 d0                	mov    %edx,%eax
801046d8:	5f                   	pop    %edi
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop

801046e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	8b 75 10             	mov    0x10(%ebp),%esi
801046e7:	8b 55 08             	mov    0x8(%ebp),%edx
801046ea:	53                   	push   %ebx
801046eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046ee:	85 f6                	test   %esi,%esi
801046f0:	74 2e                	je     80104720 <memcmp+0x40>
801046f2:	01 c6                	add    %eax,%esi
801046f4:	eb 14                	jmp    8010470a <memcmp+0x2a>
801046f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104700:	83 c0 01             	add    $0x1,%eax
80104703:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104706:	39 f0                	cmp    %esi,%eax
80104708:	74 16                	je     80104720 <memcmp+0x40>
    if(*s1 != *s2)
8010470a:	0f b6 0a             	movzbl (%edx),%ecx
8010470d:	0f b6 18             	movzbl (%eax),%ebx
80104710:	38 d9                	cmp    %bl,%cl
80104712:	74 ec                	je     80104700 <memcmp+0x20>
      return *s1 - *s2;
80104714:	0f b6 c1             	movzbl %cl,%eax
80104717:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104719:	5b                   	pop    %ebx
8010471a:	5e                   	pop    %esi
8010471b:	5d                   	pop    %ebp
8010471c:	c3                   	ret    
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
80104720:	5b                   	pop    %ebx
  return 0;
80104721:	31 c0                	xor    %eax,%eax
}
80104723:	5e                   	pop    %esi
80104724:	5d                   	pop    %ebp
80104725:	c3                   	ret    
80104726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472d:	8d 76 00             	lea    0x0(%esi),%esi

80104730 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	8b 55 08             	mov    0x8(%ebp),%edx
80104737:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010473a:	56                   	push   %esi
8010473b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010473e:	39 d6                	cmp    %edx,%esi
80104740:	73 26                	jae    80104768 <memmove+0x38>
80104742:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104745:	39 fa                	cmp    %edi,%edx
80104747:	73 1f                	jae    80104768 <memmove+0x38>
80104749:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010474c:	85 c9                	test   %ecx,%ecx
8010474e:	74 0c                	je     8010475c <memmove+0x2c>
      *--d = *--s;
80104750:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104754:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104757:	83 e8 01             	sub    $0x1,%eax
8010475a:	73 f4                	jae    80104750 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010475c:	5e                   	pop    %esi
8010475d:	89 d0                	mov    %edx,%eax
8010475f:	5f                   	pop    %edi
80104760:	5d                   	pop    %ebp
80104761:	c3                   	ret    
80104762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104768:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010476b:	89 d7                	mov    %edx,%edi
8010476d:	85 c9                	test   %ecx,%ecx
8010476f:	74 eb                	je     8010475c <memmove+0x2c>
80104771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104778:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104779:	39 c6                	cmp    %eax,%esi
8010477b:	75 fb                	jne    80104778 <memmove+0x48>
}
8010477d:	5e                   	pop    %esi
8010477e:	89 d0                	mov    %edx,%eax
80104780:	5f                   	pop    %edi
80104781:	5d                   	pop    %ebp
80104782:	c3                   	ret    
80104783:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104790:	eb 9e                	jmp    80104730 <memmove>
80104792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	8b 75 10             	mov    0x10(%ebp),%esi
801047a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047aa:	53                   	push   %ebx
801047ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801047ae:	85 f6                	test   %esi,%esi
801047b0:	74 2e                	je     801047e0 <strncmp+0x40>
801047b2:	01 d6                	add    %edx,%esi
801047b4:	eb 18                	jmp    801047ce <strncmp+0x2e>
801047b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
801047c0:	38 d8                	cmp    %bl,%al
801047c2:	75 14                	jne    801047d8 <strncmp+0x38>
    n--, p++, q++;
801047c4:	83 c2 01             	add    $0x1,%edx
801047c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047ca:	39 f2                	cmp    %esi,%edx
801047cc:	74 12                	je     801047e0 <strncmp+0x40>
801047ce:	0f b6 01             	movzbl (%ecx),%eax
801047d1:	0f b6 1a             	movzbl (%edx),%ebx
801047d4:	84 c0                	test   %al,%al
801047d6:	75 e8                	jne    801047c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047d8:	29 d8                	sub    %ebx,%eax
}
801047da:	5b                   	pop    %ebx
801047db:	5e                   	pop    %esi
801047dc:	5d                   	pop    %ebp
801047dd:	c3                   	ret    
801047de:	66 90                	xchg   %ax,%ax
801047e0:	5b                   	pop    %ebx
    return 0;
801047e1:	31 c0                	xor    %eax,%eax
}
801047e3:	5e                   	pop    %esi
801047e4:	5d                   	pop    %ebp
801047e5:	c3                   	ret    
801047e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ed:	8d 76 00             	lea    0x0(%esi),%esi

801047f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	57                   	push   %edi
801047f4:	56                   	push   %esi
801047f5:	8b 75 08             	mov    0x8(%ebp),%esi
801047f8:	53                   	push   %ebx
801047f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801047fc:	89 f0                	mov    %esi,%eax
801047fe:	eb 15                	jmp    80104815 <strncpy+0x25>
80104800:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104804:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104807:	83 c0 01             	add    $0x1,%eax
8010480a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010480e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104811:	84 d2                	test   %dl,%dl
80104813:	74 09                	je     8010481e <strncpy+0x2e>
80104815:	89 cb                	mov    %ecx,%ebx
80104817:	83 e9 01             	sub    $0x1,%ecx
8010481a:	85 db                	test   %ebx,%ebx
8010481c:	7f e2                	jg     80104800 <strncpy+0x10>
    ;
  while(n-- > 0)
8010481e:	89 c2                	mov    %eax,%edx
80104820:	85 c9                	test   %ecx,%ecx
80104822:	7e 17                	jle    8010483b <strncpy+0x4b>
80104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104828:	83 c2 01             	add    $0x1,%edx
8010482b:	89 c1                	mov    %eax,%ecx
8010482d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104831:	29 d1                	sub    %edx,%ecx
80104833:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104837:	85 c9                	test   %ecx,%ecx
80104839:	7f ed                	jg     80104828 <strncpy+0x38>
  return os;
}
8010483b:	5b                   	pop    %ebx
8010483c:	89 f0                	mov    %esi,%eax
8010483e:	5e                   	pop    %esi
8010483f:	5f                   	pop    %edi
80104840:	5d                   	pop    %ebp
80104841:	c3                   	ret    
80104842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104850 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	8b 55 10             	mov    0x10(%ebp),%edx
80104857:	8b 75 08             	mov    0x8(%ebp),%esi
8010485a:	53                   	push   %ebx
8010485b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010485e:	85 d2                	test   %edx,%edx
80104860:	7e 25                	jle    80104887 <safestrcpy+0x37>
80104862:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104866:	89 f2                	mov    %esi,%edx
80104868:	eb 16                	jmp    80104880 <safestrcpy+0x30>
8010486a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104870:	0f b6 08             	movzbl (%eax),%ecx
80104873:	83 c0 01             	add    $0x1,%eax
80104876:	83 c2 01             	add    $0x1,%edx
80104879:	88 4a ff             	mov    %cl,-0x1(%edx)
8010487c:	84 c9                	test   %cl,%cl
8010487e:	74 04                	je     80104884 <safestrcpy+0x34>
80104880:	39 d8                	cmp    %ebx,%eax
80104882:	75 ec                	jne    80104870 <safestrcpy+0x20>
    ;
  *s = 0;
80104884:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104887:	89 f0                	mov    %esi,%eax
80104889:	5b                   	pop    %ebx
8010488a:	5e                   	pop    %esi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi

80104890 <strlen>:

int
strlen(const char *s)
{
80104890:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104891:	31 c0                	xor    %eax,%eax
{
80104893:	89 e5                	mov    %esp,%ebp
80104895:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104898:	80 3a 00             	cmpb   $0x0,(%edx)
8010489b:	74 0c                	je     801048a9 <strlen+0x19>
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
801048a0:	83 c0 01             	add    $0x1,%eax
801048a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048a7:	75 f7                	jne    801048a0 <strlen+0x10>
    ;
  return n;
}
801048a9:	5d                   	pop    %ebp
801048aa:	c3                   	ret    

801048ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048b3:	55                   	push   %ebp
  pushl %ebx
801048b4:	53                   	push   %ebx
  pushl %esi
801048b5:	56                   	push   %esi
  pushl %edi
801048b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048bb:	5f                   	pop    %edi
  popl %esi
801048bc:	5e                   	pop    %esi
  popl %ebx
801048bd:	5b                   	pop    %ebx
  popl %ebp
801048be:	5d                   	pop    %ebp
  ret
801048bf:	c3                   	ret    

801048c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	53                   	push   %ebx
801048c4:	83 ec 04             	sub    $0x4,%esp
801048c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048ca:	e8 b1 f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048cf:	8b 00                	mov    (%eax),%eax
801048d1:	39 d8                	cmp    %ebx,%eax
801048d3:	76 1b                	jbe    801048f0 <fetchint+0x30>
801048d5:	8d 53 04             	lea    0x4(%ebx),%edx
801048d8:	39 d0                	cmp    %edx,%eax
801048da:	72 14                	jb     801048f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048df:	8b 13                	mov    (%ebx),%edx
801048e1:	89 10                	mov    %edx,(%eax)
  return 0;
801048e3:	31 c0                	xor    %eax,%eax
}
801048e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e8:	c9                   	leave  
801048e9:	c3                   	ret    
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801048f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048f5:	eb ee                	jmp    801048e5 <fetchint+0x25>
801048f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fe:	66 90                	xchg   %ax,%ax

80104900 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	83 ec 04             	sub    $0x4,%esp
80104907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010490a:	e8 71 f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
8010490f:	39 18                	cmp    %ebx,(%eax)
80104911:	76 2d                	jbe    80104940 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104913:	8b 55 0c             	mov    0xc(%ebp),%edx
80104916:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104918:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010491a:	39 d3                	cmp    %edx,%ebx
8010491c:	73 22                	jae    80104940 <fetchstr+0x40>
8010491e:	89 d8                	mov    %ebx,%eax
80104920:	eb 0d                	jmp    8010492f <fetchstr+0x2f>
80104922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104928:	83 c0 01             	add    $0x1,%eax
8010492b:	39 c2                	cmp    %eax,%edx
8010492d:	76 11                	jbe    80104940 <fetchstr+0x40>
    if(*s == 0)
8010492f:	80 38 00             	cmpb   $0x0,(%eax)
80104932:	75 f4                	jne    80104928 <fetchstr+0x28>
      return s - *pp;
80104934:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104939:	c9                   	leave  
8010493a:	c3                   	ret    
8010493b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010493f:	90                   	nop
80104940:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104943:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104948:	c9                   	leave  
80104949:	c3                   	ret    
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104955:	e8 26 f0 ff ff       	call   80103980 <myproc>
8010495a:	8b 55 08             	mov    0x8(%ebp),%edx
8010495d:	8b 40 18             	mov    0x18(%eax),%eax
80104960:	8b 40 44             	mov    0x44(%eax),%eax
80104963:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104966:	e8 15 f0 ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010496b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010496e:	8b 00                	mov    (%eax),%eax
80104970:	39 c6                	cmp    %eax,%esi
80104972:	73 1c                	jae    80104990 <argint+0x40>
80104974:	8d 53 08             	lea    0x8(%ebx),%edx
80104977:	39 d0                	cmp    %edx,%eax
80104979:	72 15                	jb     80104990 <argint+0x40>
  *ip = *(int*)(addr);
8010497b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010497e:	8b 53 04             	mov    0x4(%ebx),%edx
80104981:	89 10                	mov    %edx,(%eax)
  return 0;
80104983:	31 c0                	xor    %eax,%eax
}
80104985:	5b                   	pop    %ebx
80104986:	5e                   	pop    %esi
80104987:	5d                   	pop    %ebp
80104988:	c3                   	ret    
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104995:	eb ee                	jmp    80104985 <argint+0x35>
80104997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	57                   	push   %edi
801049a4:	56                   	push   %esi
801049a5:	53                   	push   %ebx
801049a6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801049a9:	e8 d2 ef ff ff       	call   80103980 <myproc>
801049ae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049b0:	e8 cb ef ff ff       	call   80103980 <myproc>
801049b5:	8b 55 08             	mov    0x8(%ebp),%edx
801049b8:	8b 40 18             	mov    0x18(%eax),%eax
801049bb:	8b 40 44             	mov    0x44(%eax),%eax
801049be:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049c1:	e8 ba ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049c6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049c9:	8b 00                	mov    (%eax),%eax
801049cb:	39 c7                	cmp    %eax,%edi
801049cd:	73 31                	jae    80104a00 <argptr+0x60>
801049cf:	8d 4b 08             	lea    0x8(%ebx),%ecx
801049d2:	39 c8                	cmp    %ecx,%eax
801049d4:	72 2a                	jb     80104a00 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049d6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801049d9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049dc:	85 d2                	test   %edx,%edx
801049de:	78 20                	js     80104a00 <argptr+0x60>
801049e0:	8b 16                	mov    (%esi),%edx
801049e2:	39 c2                	cmp    %eax,%edx
801049e4:	76 1a                	jbe    80104a00 <argptr+0x60>
801049e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049e9:	01 c3                	add    %eax,%ebx
801049eb:	39 da                	cmp    %ebx,%edx
801049ed:	72 11                	jb     80104a00 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801049ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801049f2:	89 02                	mov    %eax,(%edx)
  return 0;
801049f4:	31 c0                	xor    %eax,%eax
}
801049f6:	83 c4 0c             	add    $0xc,%esp
801049f9:	5b                   	pop    %ebx
801049fa:	5e                   	pop    %esi
801049fb:	5f                   	pop    %edi
801049fc:	5d                   	pop    %ebp
801049fd:	c3                   	ret    
801049fe:	66 90                	xchg   %ax,%ax
    return -1;
80104a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a05:	eb ef                	jmp    801049f6 <argptr+0x56>
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a15:	e8 66 ef ff ff       	call   80103980 <myproc>
80104a1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a1d:	8b 40 18             	mov    0x18(%eax),%eax
80104a20:	8b 40 44             	mov    0x44(%eax),%eax
80104a23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a26:	e8 55 ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a2e:	8b 00                	mov    (%eax),%eax
80104a30:	39 c6                	cmp    %eax,%esi
80104a32:	73 44                	jae    80104a78 <argstr+0x68>
80104a34:	8d 53 08             	lea    0x8(%ebx),%edx
80104a37:	39 d0                	cmp    %edx,%eax
80104a39:	72 3d                	jb     80104a78 <argstr+0x68>
  *ip = *(int*)(addr);
80104a3b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104a3e:	e8 3d ef ff ff       	call   80103980 <myproc>
  if(addr >= curproc->sz)
80104a43:	3b 18                	cmp    (%eax),%ebx
80104a45:	73 31                	jae    80104a78 <argstr+0x68>
  *pp = (char*)addr;
80104a47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a4a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a4c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a4e:	39 d3                	cmp    %edx,%ebx
80104a50:	73 26                	jae    80104a78 <argstr+0x68>
80104a52:	89 d8                	mov    %ebx,%eax
80104a54:	eb 11                	jmp    80104a67 <argstr+0x57>
80104a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
80104a60:	83 c0 01             	add    $0x1,%eax
80104a63:	39 c2                	cmp    %eax,%edx
80104a65:	76 11                	jbe    80104a78 <argstr+0x68>
    if(*s == 0)
80104a67:	80 38 00             	cmpb   $0x0,(%eax)
80104a6a:	75 f4                	jne    80104a60 <argstr+0x50>
      return s - *pp;
80104a6c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104a6e:	5b                   	pop    %ebx
80104a6f:	5e                   	pop    %esi
80104a70:	5d                   	pop    %ebp
80104a71:	c3                   	ret    
80104a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a78:	5b                   	pop    %ebx
    return -1;
80104a79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a7e:	5e                   	pop    %esi
80104a7f:	5d                   	pop    %ebp
80104a80:	c3                   	ret    
80104a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8f:	90                   	nop

80104a90 <syscall>:
[SYS_getpgdirinfo]  sys_getpgdirinfo,
};

void
syscall(void)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a97:	e8 e4 ee ff ff       	call   80103980 <myproc>
80104a9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a9e:	8b 40 18             	mov    0x18(%eax),%eax
80104aa1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104aa4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104aa7:	83 fa 19             	cmp    $0x19,%edx
80104aaa:	77 24                	ja     80104ad0 <syscall+0x40>
80104aac:	8b 14 85 00 8d 10 80 	mov    -0x7fef7300(,%eax,4),%edx
80104ab3:	85 d2                	test   %edx,%edx
80104ab5:	74 19                	je     80104ad0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104ab7:	ff d2                	call   *%edx
80104ab9:	89 c2                	mov    %eax,%edx
80104abb:	8b 43 18             	mov    0x18(%ebx),%eax
80104abe:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ac1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac4:	c9                   	leave  
80104ac5:	c3                   	ret    
80104ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104acd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ad0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ad1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ad4:	50                   	push   %eax
80104ad5:	ff 73 10             	push   0x10(%ebx)
80104ad8:	68 dd 8c 10 80       	push   $0x80108cdd
80104add:	e8 be bb ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104ae2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ae5:	83 c4 10             	add    $0x10,%esp
80104ae8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104aef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af2:	c9                   	leave  
80104af3:	c3                   	ret    
80104af4:	66 90                	xchg   %ax,%ax
80104af6:	66 90                	xchg   %ax,%ax
80104af8:	66 90                	xchg   %ax,%ax
80104afa:	66 90                	xchg   %ax,%ax
80104afc:	66 90                	xchg   %ax,%ax
80104afe:	66 90                	xchg   %ax,%ax

80104b00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b05:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b08:	53                   	push   %ebx
80104b09:	83 ec 34             	sub    $0x34,%esp
80104b0c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b12:	57                   	push   %edi
80104b13:	50                   	push   %eax
{
80104b14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b17:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b1a:	e8 a1 d5 ff ff       	call   801020c0 <nameiparent>
80104b1f:	83 c4 10             	add    $0x10,%esp
80104b22:	85 c0                	test   %eax,%eax
80104b24:	0f 84 46 01 00 00    	je     80104c70 <create+0x170>
    return 0;
  ilock(dp);
80104b2a:	83 ec 0c             	sub    $0xc,%esp
80104b2d:	89 c3                	mov    %eax,%ebx
80104b2f:	50                   	push   %eax
80104b30:	e8 4b cc ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b35:	83 c4 0c             	add    $0xc,%esp
80104b38:	6a 00                	push   $0x0
80104b3a:	57                   	push   %edi
80104b3b:	53                   	push   %ebx
80104b3c:	e8 9f d1 ff ff       	call   80101ce0 <dirlookup>
80104b41:	83 c4 10             	add    $0x10,%esp
80104b44:	89 c6                	mov    %eax,%esi
80104b46:	85 c0                	test   %eax,%eax
80104b48:	74 56                	je     80104ba0 <create+0xa0>
    iunlockput(dp);
80104b4a:	83 ec 0c             	sub    $0xc,%esp
80104b4d:	53                   	push   %ebx
80104b4e:	e8 bd ce ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104b53:	89 34 24             	mov    %esi,(%esp)
80104b56:	e8 25 cc ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b5b:	83 c4 10             	add    $0x10,%esp
80104b5e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b63:	75 1b                	jne    80104b80 <create+0x80>
80104b65:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b6a:	75 14                	jne    80104b80 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b6f:	89 f0                	mov    %esi,%eax
80104b71:	5b                   	pop    %ebx
80104b72:	5e                   	pop    %esi
80104b73:	5f                   	pop    %edi
80104b74:	5d                   	pop    %ebp
80104b75:	c3                   	ret    
80104b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104b80:	83 ec 0c             	sub    $0xc,%esp
80104b83:	56                   	push   %esi
    return 0;
80104b84:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104b86:	e8 85 ce ff ff       	call   80101a10 <iunlockput>
    return 0;
80104b8b:	83 c4 10             	add    $0x10,%esp
}
80104b8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b91:	89 f0                	mov    %esi,%eax
80104b93:	5b                   	pop    %ebx
80104b94:	5e                   	pop    %esi
80104b95:	5f                   	pop    %edi
80104b96:	5d                   	pop    %ebp
80104b97:	c3                   	ret    
80104b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104ba0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104ba4:	83 ec 08             	sub    $0x8,%esp
80104ba7:	50                   	push   %eax
80104ba8:	ff 33                	push   (%ebx)
80104baa:	e8 61 ca ff ff       	call   80101610 <ialloc>
80104baf:	83 c4 10             	add    $0x10,%esp
80104bb2:	89 c6                	mov    %eax,%esi
80104bb4:	85 c0                	test   %eax,%eax
80104bb6:	0f 84 cd 00 00 00    	je     80104c89 <create+0x189>
  ilock(ip);
80104bbc:	83 ec 0c             	sub    $0xc,%esp
80104bbf:	50                   	push   %eax
80104bc0:	e8 bb cb ff ff       	call   80101780 <ilock>
  ip->major = major;
80104bc5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104bc9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bcd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104bd1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104bd5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bda:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bde:	89 34 24             	mov    %esi,(%esp)
80104be1:	e8 ea ca ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104be6:	83 c4 10             	add    $0x10,%esp
80104be9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bee:	74 30                	je     80104c20 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104bf0:	83 ec 04             	sub    $0x4,%esp
80104bf3:	ff 76 04             	push   0x4(%esi)
80104bf6:	57                   	push   %edi
80104bf7:	53                   	push   %ebx
80104bf8:	e8 e3 d3 ff ff       	call   80101fe0 <dirlink>
80104bfd:	83 c4 10             	add    $0x10,%esp
80104c00:	85 c0                	test   %eax,%eax
80104c02:	78 78                	js     80104c7c <create+0x17c>
  iunlockput(dp);
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	53                   	push   %ebx
80104c08:	e8 03 ce ff ff       	call   80101a10 <iunlockput>
  return ip;
80104c0d:	83 c4 10             	add    $0x10,%esp
}
80104c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c13:	89 f0                	mov    %esi,%eax
80104c15:	5b                   	pop    %ebx
80104c16:	5e                   	pop    %esi
80104c17:	5f                   	pop    %edi
80104c18:	5d                   	pop    %ebp
80104c19:	c3                   	ret    
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c28:	53                   	push   %ebx
80104c29:	e8 a2 ca ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c2e:	83 c4 0c             	add    $0xc,%esp
80104c31:	ff 76 04             	push   0x4(%esi)
80104c34:	68 88 8d 10 80       	push   $0x80108d88
80104c39:	56                   	push   %esi
80104c3a:	e8 a1 d3 ff ff       	call   80101fe0 <dirlink>
80104c3f:	83 c4 10             	add    $0x10,%esp
80104c42:	85 c0                	test   %eax,%eax
80104c44:	78 18                	js     80104c5e <create+0x15e>
80104c46:	83 ec 04             	sub    $0x4,%esp
80104c49:	ff 73 04             	push   0x4(%ebx)
80104c4c:	68 87 8d 10 80       	push   $0x80108d87
80104c51:	56                   	push   %esi
80104c52:	e8 89 d3 ff ff       	call   80101fe0 <dirlink>
80104c57:	83 c4 10             	add    $0x10,%esp
80104c5a:	85 c0                	test   %eax,%eax
80104c5c:	79 92                	jns    80104bf0 <create+0xf0>
      panic("create dots");
80104c5e:	83 ec 0c             	sub    $0xc,%esp
80104c61:	68 7b 8d 10 80       	push   $0x80108d7b
80104c66:	e8 15 b7 ff ff       	call   80100380 <panic>
80104c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop
}
80104c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c73:	31 f6                	xor    %esi,%esi
}
80104c75:	5b                   	pop    %ebx
80104c76:	89 f0                	mov    %esi,%eax
80104c78:	5e                   	pop    %esi
80104c79:	5f                   	pop    %edi
80104c7a:	5d                   	pop    %ebp
80104c7b:	c3                   	ret    
    panic("create: dirlink");
80104c7c:	83 ec 0c             	sub    $0xc,%esp
80104c7f:	68 8a 8d 10 80       	push   $0x80108d8a
80104c84:	e8 f7 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104c89:	83 ec 0c             	sub    $0xc,%esp
80104c8c:	68 6c 8d 10 80       	push   $0x80108d6c
80104c91:	e8 ea b6 ff ff       	call   80100380 <panic>
80104c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ca0 <argfd>:
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ca5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ca8:	83 ec 18             	sub    $0x18,%esp
80104cab:	8b 75 0c             	mov    0xc(%ebp),%esi
80104cae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  if(argint(n, &fd) < 0)
80104cb1:	50                   	push   %eax
80104cb2:	ff 75 08             	push   0x8(%ebp)
80104cb5:	e8 96 fc ff ff       	call   80104950 <argint>
80104cba:	83 c4 10             	add    $0x10,%esp
80104cbd:	85 c0                	test   %eax,%eax
80104cbf:	78 2f                	js     80104cf0 <argfd+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cc1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cc5:	77 29                	ja     80104cf0 <argfd+0x50>
80104cc7:	e8 b4 ec ff ff       	call   80103980 <myproc>
80104ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ccf:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104cd3:	85 c0                	test   %eax,%eax
80104cd5:	74 19                	je     80104cf0 <argfd+0x50>
  if(pfd)
80104cd7:	85 f6                	test   %esi,%esi
80104cd9:	74 02                	je     80104cdd <argfd+0x3d>
    *pfd = fd;
80104cdb:	89 16                	mov    %edx,(%esi)
  return 0;
80104cdd:	31 d2                	xor    %edx,%edx
  if(pf)
80104cdf:	85 db                	test   %ebx,%ebx
80104ce1:	74 02                	je     80104ce5 <argfd+0x45>
    *pf = f;
80104ce3:	89 03                	mov    %eax,(%ebx)
}
80104ce5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ce8:	89 d0                	mov    %edx,%eax
80104cea:	5b                   	pop    %ebx
80104ceb:	5e                   	pop    %esi
80104cec:	5d                   	pop    %ebp
80104ced:	c3                   	ret    
80104cee:	66 90                	xchg   %ax,%ax
    return -1;
80104cf0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80104cf5:	eb ee                	jmp    80104ce5 <argfd+0x45>
80104cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfe:	66 90                	xchg   %ax,%ax

80104d00 <sys_dup>:
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	56                   	push   %esi
80104d04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d05:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104d08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d0b:	50                   	push   %eax
80104d0c:	6a 00                	push   $0x0
80104d0e:	e8 3d fc ff ff       	call   80104950 <argint>
80104d13:	83 c4 10             	add    $0x10,%esp
80104d16:	85 c0                	test   %eax,%eax
80104d18:	78 36                	js     80104d50 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d1e:	77 30                	ja     80104d50 <sys_dup+0x50>
80104d20:	e8 5b ec ff ff       	call   80103980 <myproc>
80104d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d2c:	85 f6                	test   %esi,%esi
80104d2e:	74 20                	je     80104d50 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104d30:	e8 4b ec ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d35:	31 db                	xor    %ebx,%ebx
80104d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104d40:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d44:	85 d2                	test   %edx,%edx
80104d46:	74 18                	je     80104d60 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104d48:	83 c3 01             	add    $0x1,%ebx
80104d4b:	83 fb 10             	cmp    $0x10,%ebx
80104d4e:	75 f0                	jne    80104d40 <sys_dup+0x40>
}
80104d50:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d58:	89 d8                	mov    %ebx,%eax
80104d5a:	5b                   	pop    %ebx
80104d5b:	5e                   	pop    %esi
80104d5c:	5d                   	pop    %ebp
80104d5d:	c3                   	ret    
80104d5e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104d60:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104d63:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d67:	56                   	push   %esi
80104d68:	e8 33 c1 ff ff       	call   80100ea0 <filedup>
  return fd;
80104d6d:	83 c4 10             	add    $0x10,%esp
}
80104d70:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d73:	89 d8                	mov    %ebx,%eax
80104d75:	5b                   	pop    %ebx
80104d76:	5e                   	pop    %esi
80104d77:	5d                   	pop    %ebp
80104d78:	c3                   	ret    
80104d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d80 <sys_read>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104d88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d8b:	53                   	push   %ebx
80104d8c:	6a 00                	push   $0x0
80104d8e:	e8 bd fb ff ff       	call   80104950 <argint>
80104d93:	83 c4 10             	add    $0x10,%esp
80104d96:	85 c0                	test   %eax,%eax
80104d98:	78 5e                	js     80104df8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d9e:	77 58                	ja     80104df8 <sys_read+0x78>
80104da0:	e8 db eb ff ff       	call   80103980 <myproc>
80104da5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104da8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104dac:	85 f6                	test   %esi,%esi
80104dae:	74 48                	je     80104df8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104db0:	83 ec 08             	sub    $0x8,%esp
80104db3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104db6:	50                   	push   %eax
80104db7:	6a 02                	push   $0x2
80104db9:	e8 92 fb ff ff       	call   80104950 <argint>
80104dbe:	83 c4 10             	add    $0x10,%esp
80104dc1:	85 c0                	test   %eax,%eax
80104dc3:	78 33                	js     80104df8 <sys_read+0x78>
80104dc5:	83 ec 04             	sub    $0x4,%esp
80104dc8:	ff 75 f0             	push   -0x10(%ebp)
80104dcb:	53                   	push   %ebx
80104dcc:	6a 01                	push   $0x1
80104dce:	e8 cd fb ff ff       	call   801049a0 <argptr>
80104dd3:	83 c4 10             	add    $0x10,%esp
80104dd6:	85 c0                	test   %eax,%eax
80104dd8:	78 1e                	js     80104df8 <sys_read+0x78>
  return fileread(f, p, n);
80104dda:	83 ec 04             	sub    $0x4,%esp
80104ddd:	ff 75 f0             	push   -0x10(%ebp)
80104de0:	ff 75 f4             	push   -0xc(%ebp)
80104de3:	56                   	push   %esi
80104de4:	e8 37 c2 ff ff       	call   80101020 <fileread>
80104de9:	83 c4 10             	add    $0x10,%esp
}
80104dec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104def:	5b                   	pop    %ebx
80104df0:	5e                   	pop    %esi
80104df1:	5d                   	pop    %ebp
80104df2:	c3                   	ret    
80104df3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104df7:	90                   	nop
    return -1;
80104df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dfd:	eb ed                	jmp    80104dec <sys_read+0x6c>
80104dff:	90                   	nop

80104e00 <sys_write>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e05:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e0b:	53                   	push   %ebx
80104e0c:	6a 00                	push   $0x0
80104e0e:	e8 3d fb ff ff       	call   80104950 <argint>
80104e13:	83 c4 10             	add    $0x10,%esp
80104e16:	85 c0                	test   %eax,%eax
80104e18:	78 5e                	js     80104e78 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e1e:	77 58                	ja     80104e78 <sys_write+0x78>
80104e20:	e8 5b eb ff ff       	call   80103980 <myproc>
80104e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e2c:	85 f6                	test   %esi,%esi
80104e2e:	74 48                	je     80104e78 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e30:	83 ec 08             	sub    $0x8,%esp
80104e33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e36:	50                   	push   %eax
80104e37:	6a 02                	push   $0x2
80104e39:	e8 12 fb ff ff       	call   80104950 <argint>
80104e3e:	83 c4 10             	add    $0x10,%esp
80104e41:	85 c0                	test   %eax,%eax
80104e43:	78 33                	js     80104e78 <sys_write+0x78>
80104e45:	83 ec 04             	sub    $0x4,%esp
80104e48:	ff 75 f0             	push   -0x10(%ebp)
80104e4b:	53                   	push   %ebx
80104e4c:	6a 01                	push   $0x1
80104e4e:	e8 4d fb ff ff       	call   801049a0 <argptr>
80104e53:	83 c4 10             	add    $0x10,%esp
80104e56:	85 c0                	test   %eax,%eax
80104e58:	78 1e                	js     80104e78 <sys_write+0x78>
  return filewrite(f, p, n);
80104e5a:	83 ec 04             	sub    $0x4,%esp
80104e5d:	ff 75 f0             	push   -0x10(%ebp)
80104e60:	ff 75 f4             	push   -0xc(%ebp)
80104e63:	56                   	push   %esi
80104e64:	e8 47 c2 ff ff       	call   801010b0 <filewrite>
80104e69:	83 c4 10             	add    $0x10,%esp
}
80104e6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e6f:	5b                   	pop    %ebx
80104e70:	5e                   	pop    %esi
80104e71:	5d                   	pop    %ebp
80104e72:	c3                   	ret    
80104e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e77:	90                   	nop
    return -1;
80104e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e7d:	eb ed                	jmp    80104e6c <sys_write+0x6c>
80104e7f:	90                   	nop

80104e80 <sys_close>:
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e85:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e8b:	50                   	push   %eax
80104e8c:	6a 00                	push   $0x0
80104e8e:	e8 bd fa ff ff       	call   80104950 <argint>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 3e                	js     80104ed8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e9e:	77 38                	ja     80104ed8 <sys_close+0x58>
80104ea0:	e8 db ea ff ff       	call   80103980 <myproc>
80104ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ea8:	8d 5a 08             	lea    0x8(%edx),%ebx
80104eab:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104eaf:	85 f6                	test   %esi,%esi
80104eb1:	74 25                	je     80104ed8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104eb3:	e8 c8 ea ff ff       	call   80103980 <myproc>
  fileclose(f);
80104eb8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ebb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104ec2:	00 
  fileclose(f);
80104ec3:	56                   	push   %esi
80104ec4:	e8 27 c0 ff ff       	call   80100ef0 <fileclose>
  return 0;
80104ec9:	83 c4 10             	add    $0x10,%esp
80104ecc:	31 c0                	xor    %eax,%eax
}
80104ece:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed1:	5b                   	pop    %ebx
80104ed2:	5e                   	pop    %esi
80104ed3:	5d                   	pop    %ebp
80104ed4:	c3                   	ret    
80104ed5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104edd:	eb ef                	jmp    80104ece <sys_close+0x4e>
80104edf:	90                   	nop

80104ee0 <sys_fstat>:
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ee5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ee8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eeb:	53                   	push   %ebx
80104eec:	6a 00                	push   $0x0
80104eee:	e8 5d fa ff ff       	call   80104950 <argint>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	78 46                	js     80104f40 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104efa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104efe:	77 40                	ja     80104f40 <sys_fstat+0x60>
80104f00:	e8 7b ea ff ff       	call   80103980 <myproc>
80104f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f0c:	85 f6                	test   %esi,%esi
80104f0e:	74 30                	je     80104f40 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f10:	83 ec 04             	sub    $0x4,%esp
80104f13:	6a 14                	push   $0x14
80104f15:	53                   	push   %ebx
80104f16:	6a 01                	push   $0x1
80104f18:	e8 83 fa ff ff       	call   801049a0 <argptr>
80104f1d:	83 c4 10             	add    $0x10,%esp
80104f20:	85 c0                	test   %eax,%eax
80104f22:	78 1c                	js     80104f40 <sys_fstat+0x60>
  return filestat(f, st);
80104f24:	83 ec 08             	sub    $0x8,%esp
80104f27:	ff 75 f4             	push   -0xc(%ebp)
80104f2a:	56                   	push   %esi
80104f2b:	e8 a0 c0 ff ff       	call   80100fd0 <filestat>
80104f30:	83 c4 10             	add    $0x10,%esp
}
80104f33:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f36:	5b                   	pop    %ebx
80104f37:	5e                   	pop    %esi
80104f38:	5d                   	pop    %ebp
80104f39:	c3                   	ret    
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f45:	eb ec                	jmp    80104f33 <sys_fstat+0x53>
80104f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <sys_link>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f55:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f58:	53                   	push   %ebx
80104f59:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f5c:	50                   	push   %eax
80104f5d:	6a 00                	push   $0x0
80104f5f:	e8 ac fa ff ff       	call   80104a10 <argstr>
80104f64:	83 c4 10             	add    $0x10,%esp
80104f67:	85 c0                	test   %eax,%eax
80104f69:	0f 88 fb 00 00 00    	js     8010506a <sys_link+0x11a>
80104f6f:	83 ec 08             	sub    $0x8,%esp
80104f72:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f75:	50                   	push   %eax
80104f76:	6a 01                	push   $0x1
80104f78:	e8 93 fa ff ff       	call   80104a10 <argstr>
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	85 c0                	test   %eax,%eax
80104f82:	0f 88 e2 00 00 00    	js     8010506a <sys_link+0x11a>
  begin_op();
80104f88:	e8 d3 dd ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
80104f8d:	83 ec 0c             	sub    $0xc,%esp
80104f90:	ff 75 d4             	push   -0x2c(%ebp)
80104f93:	e8 08 d1 ff ff       	call   801020a0 <namei>
80104f98:	83 c4 10             	add    $0x10,%esp
80104f9b:	89 c3                	mov    %eax,%ebx
80104f9d:	85 c0                	test   %eax,%eax
80104f9f:	0f 84 e4 00 00 00    	je     80105089 <sys_link+0x139>
  ilock(ip);
80104fa5:	83 ec 0c             	sub    $0xc,%esp
80104fa8:	50                   	push   %eax
80104fa9:	e8 d2 c7 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fb6:	0f 84 b5 00 00 00    	je     80105071 <sys_link+0x121>
  iupdate(ip);
80104fbc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104fbf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104fc4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fc7:	53                   	push   %ebx
80104fc8:	e8 03 c7 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80104fcd:	89 1c 24             	mov    %ebx,(%esp)
80104fd0:	e8 8b c8 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fd5:	58                   	pop    %eax
80104fd6:	5a                   	pop    %edx
80104fd7:	57                   	push   %edi
80104fd8:	ff 75 d0             	push   -0x30(%ebp)
80104fdb:	e8 e0 d0 ff ff       	call   801020c0 <nameiparent>
80104fe0:	83 c4 10             	add    $0x10,%esp
80104fe3:	89 c6                	mov    %eax,%esi
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	74 5b                	je     80105044 <sys_link+0xf4>
  ilock(dp);
80104fe9:	83 ec 0c             	sub    $0xc,%esp
80104fec:	50                   	push   %eax
80104fed:	e8 8e c7 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ff2:	8b 03                	mov    (%ebx),%eax
80104ff4:	83 c4 10             	add    $0x10,%esp
80104ff7:	39 06                	cmp    %eax,(%esi)
80104ff9:	75 3d                	jne    80105038 <sys_link+0xe8>
80104ffb:	83 ec 04             	sub    $0x4,%esp
80104ffe:	ff 73 04             	push   0x4(%ebx)
80105001:	57                   	push   %edi
80105002:	56                   	push   %esi
80105003:	e8 d8 cf ff ff       	call   80101fe0 <dirlink>
80105008:	83 c4 10             	add    $0x10,%esp
8010500b:	85 c0                	test   %eax,%eax
8010500d:	78 29                	js     80105038 <sys_link+0xe8>
  iunlockput(dp);
8010500f:	83 ec 0c             	sub    $0xc,%esp
80105012:	56                   	push   %esi
80105013:	e8 f8 c9 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105018:	89 1c 24             	mov    %ebx,(%esp)
8010501b:	e8 90 c8 ff ff       	call   801018b0 <iput>
  end_op();
80105020:	e8 ab dd ff ff       	call   80102dd0 <end_op>
  return 0;
80105025:	83 c4 10             	add    $0x10,%esp
80105028:	31 c0                	xor    %eax,%eax
}
8010502a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010502d:	5b                   	pop    %ebx
8010502e:	5e                   	pop    %esi
8010502f:	5f                   	pop    %edi
80105030:	5d                   	pop    %ebp
80105031:	c3                   	ret    
80105032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105038:	83 ec 0c             	sub    $0xc,%esp
8010503b:	56                   	push   %esi
8010503c:	e8 cf c9 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105041:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	53                   	push   %ebx
80105048:	e8 33 c7 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010504d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105052:	89 1c 24             	mov    %ebx,(%esp)
80105055:	e8 76 c6 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010505a:	89 1c 24             	mov    %ebx,(%esp)
8010505d:	e8 ae c9 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105062:	e8 69 dd ff ff       	call   80102dd0 <end_op>
  return -1;
80105067:	83 c4 10             	add    $0x10,%esp
8010506a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506f:	eb b9                	jmp    8010502a <sys_link+0xda>
    iunlockput(ip);
80105071:	83 ec 0c             	sub    $0xc,%esp
80105074:	53                   	push   %ebx
80105075:	e8 96 c9 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010507a:	e8 51 dd ff ff       	call   80102dd0 <end_op>
    return -1;
8010507f:	83 c4 10             	add    $0x10,%esp
80105082:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105087:	eb a1                	jmp    8010502a <sys_link+0xda>
    end_op();
80105089:	e8 42 dd ff ff       	call   80102dd0 <end_op>
    return -1;
8010508e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105093:	eb 95                	jmp    8010502a <sys_link+0xda>
80105095:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050a0 <sys_unlink>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801050a5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050a8:	53                   	push   %ebx
801050a9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 5c f9 ff ff       	call   80104a10 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 7a 01 00 00    	js     80105239 <sys_unlink+0x199>
  begin_op();
801050bf:	e8 9c dc ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050c4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801050c7:	83 ec 08             	sub    $0x8,%esp
801050ca:	53                   	push   %ebx
801050cb:	ff 75 c0             	push   -0x40(%ebp)
801050ce:	e8 ed cf ff ff       	call   801020c0 <nameiparent>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801050d9:	85 c0                	test   %eax,%eax
801050db:	0f 84 62 01 00 00    	je     80105243 <sys_unlink+0x1a3>
  ilock(dp);
801050e1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	57                   	push   %edi
801050e8:	e8 93 c6 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050ed:	58                   	pop    %eax
801050ee:	5a                   	pop    %edx
801050ef:	68 88 8d 10 80       	push   $0x80108d88
801050f4:	53                   	push   %ebx
801050f5:	e8 c6 cb ff ff       	call   80101cc0 <namecmp>
801050fa:	83 c4 10             	add    $0x10,%esp
801050fd:	85 c0                	test   %eax,%eax
801050ff:	0f 84 fb 00 00 00    	je     80105200 <sys_unlink+0x160>
80105105:	83 ec 08             	sub    $0x8,%esp
80105108:	68 87 8d 10 80       	push   $0x80108d87
8010510d:	53                   	push   %ebx
8010510e:	e8 ad cb ff ff       	call   80101cc0 <namecmp>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	0f 84 e2 00 00 00    	je     80105200 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010511e:	83 ec 04             	sub    $0x4,%esp
80105121:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105124:	50                   	push   %eax
80105125:	53                   	push   %ebx
80105126:	57                   	push   %edi
80105127:	e8 b4 cb ff ff       	call   80101ce0 <dirlookup>
8010512c:	83 c4 10             	add    $0x10,%esp
8010512f:	89 c3                	mov    %eax,%ebx
80105131:	85 c0                	test   %eax,%eax
80105133:	0f 84 c7 00 00 00    	je     80105200 <sys_unlink+0x160>
  ilock(ip);
80105139:	83 ec 0c             	sub    $0xc,%esp
8010513c:	50                   	push   %eax
8010513d:	e8 3e c6 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010514a:	0f 8e 1c 01 00 00    	jle    8010526c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105150:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105155:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105158:	74 66                	je     801051c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010515a:	83 ec 04             	sub    $0x4,%esp
8010515d:	6a 10                	push   $0x10
8010515f:	6a 00                	push   $0x0
80105161:	57                   	push   %edi
80105162:	e8 29 f5 ff ff       	call   80104690 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105167:	6a 10                	push   $0x10
80105169:	ff 75 c4             	push   -0x3c(%ebp)
8010516c:	57                   	push   %edi
8010516d:	ff 75 b4             	push   -0x4c(%ebp)
80105170:	e8 1b ca ff ff       	call   80101b90 <writei>
80105175:	83 c4 20             	add    $0x20,%esp
80105178:	83 f8 10             	cmp    $0x10,%eax
8010517b:	0f 85 de 00 00 00    	jne    8010525f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105181:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105186:	0f 84 94 00 00 00    	je     80105220 <sys_unlink+0x180>
  iunlockput(dp);
8010518c:	83 ec 0c             	sub    $0xc,%esp
8010518f:	ff 75 b4             	push   -0x4c(%ebp)
80105192:	e8 79 c8 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105197:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010519c:	89 1c 24             	mov    %ebx,(%esp)
8010519f:	e8 2c c5 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801051a4:	89 1c 24             	mov    %ebx,(%esp)
801051a7:	e8 64 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051ac:	e8 1f dc ff ff       	call   80102dd0 <end_op>
  return 0;
801051b1:	83 c4 10             	add    $0x10,%esp
801051b4:	31 c0                	xor    %eax,%eax
}
801051b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051b9:	5b                   	pop    %ebx
801051ba:	5e                   	pop    %esi
801051bb:	5f                   	pop    %edi
801051bc:	5d                   	pop    %ebp
801051bd:	c3                   	ret    
801051be:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051c4:	76 94                	jbe    8010515a <sys_unlink+0xba>
801051c6:	be 20 00 00 00       	mov    $0x20,%esi
801051cb:	eb 0b                	jmp    801051d8 <sys_unlink+0x138>
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
801051d0:	83 c6 10             	add    $0x10,%esi
801051d3:	3b 73 58             	cmp    0x58(%ebx),%esi
801051d6:	73 82                	jae    8010515a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051d8:	6a 10                	push   $0x10
801051da:	56                   	push   %esi
801051db:	57                   	push   %edi
801051dc:	53                   	push   %ebx
801051dd:	e8 ae c8 ff ff       	call   80101a90 <readi>
801051e2:	83 c4 10             	add    $0x10,%esp
801051e5:	83 f8 10             	cmp    $0x10,%eax
801051e8:	75 68                	jne    80105252 <sys_unlink+0x1b2>
    if(de.inum != 0)
801051ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051ef:	74 df                	je     801051d0 <sys_unlink+0x130>
    iunlockput(ip);
801051f1:	83 ec 0c             	sub    $0xc,%esp
801051f4:	53                   	push   %ebx
801051f5:	e8 16 c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051fa:	83 c4 10             	add    $0x10,%esp
801051fd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	ff 75 b4             	push   -0x4c(%ebp)
80105206:	e8 05 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010520b:	e8 c0 db ff ff       	call   80102dd0 <end_op>
  return -1;
80105210:	83 c4 10             	add    $0x10,%esp
80105213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105218:	eb 9c                	jmp    801051b6 <sys_unlink+0x116>
8010521a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105220:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105223:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105226:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010522b:	50                   	push   %eax
8010522c:	e8 9f c4 ff ff       	call   801016d0 <iupdate>
80105231:	83 c4 10             	add    $0x10,%esp
80105234:	e9 53 ff ff ff       	jmp    8010518c <sys_unlink+0xec>
    return -1;
80105239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523e:	e9 73 ff ff ff       	jmp    801051b6 <sys_unlink+0x116>
    end_op();
80105243:	e8 88 db ff ff       	call   80102dd0 <end_op>
    return -1;
80105248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524d:	e9 64 ff ff ff       	jmp    801051b6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105252:	83 ec 0c             	sub    $0xc,%esp
80105255:	68 ac 8d 10 80       	push   $0x80108dac
8010525a:	e8 21 b1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010525f:	83 ec 0c             	sub    $0xc,%esp
80105262:	68 be 8d 10 80       	push   $0x80108dbe
80105267:	e8 14 b1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010526c:	83 ec 0c             	sub    $0xc,%esp
8010526f:	68 9a 8d 10 80       	push   $0x80108d9a
80105274:	e8 07 b1 ff ff       	call   80100380 <panic>
80105279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105280 <sys_open>:

int
sys_open(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105285:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105288:	53                   	push   %ebx
80105289:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010528c:	50                   	push   %eax
8010528d:	6a 00                	push   $0x0
8010528f:	e8 7c f7 ff ff       	call   80104a10 <argstr>
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	85 c0                	test   %eax,%eax
80105299:	0f 88 8e 00 00 00    	js     8010532d <sys_open+0xad>
8010529f:	83 ec 08             	sub    $0x8,%esp
801052a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052a5:	50                   	push   %eax
801052a6:	6a 01                	push   $0x1
801052a8:	e8 a3 f6 ff ff       	call   80104950 <argint>
801052ad:	83 c4 10             	add    $0x10,%esp
801052b0:	85 c0                	test   %eax,%eax
801052b2:	78 79                	js     8010532d <sys_open+0xad>
    return -1;

  begin_op();
801052b4:	e8 a7 da ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
801052b9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052bd:	75 79                	jne    80105338 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801052bf:	83 ec 0c             	sub    $0xc,%esp
801052c2:	ff 75 e0             	push   -0x20(%ebp)
801052c5:	e8 d6 cd ff ff       	call   801020a0 <namei>
801052ca:	83 c4 10             	add    $0x10,%esp
801052cd:	89 c6                	mov    %eax,%esi
801052cf:	85 c0                	test   %eax,%eax
801052d1:	0f 84 7e 00 00 00    	je     80105355 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801052d7:	83 ec 0c             	sub    $0xc,%esp
801052da:	50                   	push   %eax
801052db:	e8 a0 c4 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052e0:	83 c4 10             	add    $0x10,%esp
801052e3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052e8:	0f 84 c2 00 00 00    	je     801053b0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052ee:	e8 3d bb ff ff       	call   80100e30 <filealloc>
801052f3:	89 c7                	mov    %eax,%edi
801052f5:	85 c0                	test   %eax,%eax
801052f7:	74 23                	je     8010531c <sys_open+0x9c>
  struct proc *curproc = myproc();
801052f9:	e8 82 e6 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052fe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105300:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105304:	85 d2                	test   %edx,%edx
80105306:	74 60                	je     80105368 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105308:	83 c3 01             	add    $0x1,%ebx
8010530b:	83 fb 10             	cmp    $0x10,%ebx
8010530e:	75 f0                	jne    80105300 <sys_open+0x80>
    if(f)
      fileclose(f);
80105310:	83 ec 0c             	sub    $0xc,%esp
80105313:	57                   	push   %edi
80105314:	e8 d7 bb ff ff       	call   80100ef0 <fileclose>
80105319:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010531c:	83 ec 0c             	sub    $0xc,%esp
8010531f:	56                   	push   %esi
80105320:	e8 eb c6 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105325:	e8 a6 da ff ff       	call   80102dd0 <end_op>
    return -1;
8010532a:	83 c4 10             	add    $0x10,%esp
8010532d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105332:	eb 6d                	jmp    801053a1 <sys_open+0x121>
80105334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105338:	83 ec 0c             	sub    $0xc,%esp
8010533b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010533e:	31 c9                	xor    %ecx,%ecx
80105340:	ba 02 00 00 00       	mov    $0x2,%edx
80105345:	6a 00                	push   $0x0
80105347:	e8 b4 f7 ff ff       	call   80104b00 <create>
    if(ip == 0){
8010534c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010534f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105351:	85 c0                	test   %eax,%eax
80105353:	75 99                	jne    801052ee <sys_open+0x6e>
      end_op();
80105355:	e8 76 da ff ff       	call   80102dd0 <end_op>
      return -1;
8010535a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010535f:	eb 40                	jmp    801053a1 <sys_open+0x121>
80105361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105368:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010536b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010536f:	56                   	push   %esi
80105370:	e8 eb c4 ff ff       	call   80101860 <iunlock>
  end_op();
80105375:	e8 56 da ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
8010537a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105383:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105386:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105389:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010538b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105392:	f7 d0                	not    %eax
80105394:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105397:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010539a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010539d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801053a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a4:	89 d8                	mov    %ebx,%eax
801053a6:	5b                   	pop    %ebx
801053a7:	5e                   	pop    %esi
801053a8:	5f                   	pop    %edi
801053a9:	5d                   	pop    %ebp
801053aa:	c3                   	ret    
801053ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053af:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801053b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801053b3:	85 c9                	test   %ecx,%ecx
801053b5:	0f 84 33 ff ff ff    	je     801052ee <sys_open+0x6e>
801053bb:	e9 5c ff ff ff       	jmp    8010531c <sys_open+0x9c>

801053c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053c6:	e8 95 d9 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053cb:	83 ec 08             	sub    $0x8,%esp
801053ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053d1:	50                   	push   %eax
801053d2:	6a 00                	push   $0x0
801053d4:	e8 37 f6 ff ff       	call   80104a10 <argstr>
801053d9:	83 c4 10             	add    $0x10,%esp
801053dc:	85 c0                	test   %eax,%eax
801053de:	78 30                	js     80105410 <sys_mkdir+0x50>
801053e0:	83 ec 0c             	sub    $0xc,%esp
801053e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e6:	31 c9                	xor    %ecx,%ecx
801053e8:	ba 01 00 00 00       	mov    $0x1,%edx
801053ed:	6a 00                	push   $0x0
801053ef:	e8 0c f7 ff ff       	call   80104b00 <create>
801053f4:	83 c4 10             	add    $0x10,%esp
801053f7:	85 c0                	test   %eax,%eax
801053f9:	74 15                	je     80105410 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053fb:	83 ec 0c             	sub    $0xc,%esp
801053fe:	50                   	push   %eax
801053ff:	e8 0c c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105404:	e8 c7 d9 ff ff       	call   80102dd0 <end_op>
  return 0;
80105409:	83 c4 10             	add    $0x10,%esp
8010540c:	31 c0                	xor    %eax,%eax
}
8010540e:	c9                   	leave  
8010540f:	c3                   	ret    
    end_op();
80105410:	e8 bb d9 ff ff       	call   80102dd0 <end_op>
    return -1;
80105415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010541a:	c9                   	leave  
8010541b:	c3                   	ret    
8010541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105420 <sys_mknod>:

int
sys_mknod(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105426:	e8 35 d9 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010542b:	83 ec 08             	sub    $0x8,%esp
8010542e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105431:	50                   	push   %eax
80105432:	6a 00                	push   $0x0
80105434:	e8 d7 f5 ff ff       	call   80104a10 <argstr>
80105439:	83 c4 10             	add    $0x10,%esp
8010543c:	85 c0                	test   %eax,%eax
8010543e:	78 60                	js     801054a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105440:	83 ec 08             	sub    $0x8,%esp
80105443:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105446:	50                   	push   %eax
80105447:	6a 01                	push   $0x1
80105449:	e8 02 f5 ff ff       	call   80104950 <argint>
  if((argstr(0, &path)) < 0 ||
8010544e:	83 c4 10             	add    $0x10,%esp
80105451:	85 c0                	test   %eax,%eax
80105453:	78 4b                	js     801054a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105455:	83 ec 08             	sub    $0x8,%esp
80105458:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010545b:	50                   	push   %eax
8010545c:	6a 02                	push   $0x2
8010545e:	e8 ed f4 ff ff       	call   80104950 <argint>
     argint(1, &major) < 0 ||
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	78 36                	js     801054a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010546a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010546e:	83 ec 0c             	sub    $0xc,%esp
80105471:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105475:	ba 03 00 00 00       	mov    $0x3,%edx
8010547a:	50                   	push   %eax
8010547b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010547e:	e8 7d f6 ff ff       	call   80104b00 <create>
     argint(2, &minor) < 0 ||
80105483:	83 c4 10             	add    $0x10,%esp
80105486:	85 c0                	test   %eax,%eax
80105488:	74 16                	je     801054a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010548a:	83 ec 0c             	sub    $0xc,%esp
8010548d:	50                   	push   %eax
8010548e:	e8 7d c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105493:	e8 38 d9 ff ff       	call   80102dd0 <end_op>
  return 0;
80105498:	83 c4 10             	add    $0x10,%esp
8010549b:	31 c0                	xor    %eax,%eax
}
8010549d:	c9                   	leave  
8010549e:	c3                   	ret    
8010549f:	90                   	nop
    end_op();
801054a0:	e8 2b d9 ff ff       	call   80102dd0 <end_op>
    return -1;
801054a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054aa:	c9                   	leave  
801054ab:	c3                   	ret    
801054ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054b0 <sys_chdir>:

int
sys_chdir(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	56                   	push   %esi
801054b4:	53                   	push   %ebx
801054b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801054b8:	e8 c3 e4 ff ff       	call   80103980 <myproc>
801054bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801054bf:	e8 9c d8 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054c4:	83 ec 08             	sub    $0x8,%esp
801054c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ca:	50                   	push   %eax
801054cb:	6a 00                	push   $0x0
801054cd:	e8 3e f5 ff ff       	call   80104a10 <argstr>
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	85 c0                	test   %eax,%eax
801054d7:	78 77                	js     80105550 <sys_chdir+0xa0>
801054d9:	83 ec 0c             	sub    $0xc,%esp
801054dc:	ff 75 f4             	push   -0xc(%ebp)
801054df:	e8 bc cb ff ff       	call   801020a0 <namei>
801054e4:	83 c4 10             	add    $0x10,%esp
801054e7:	89 c3                	mov    %eax,%ebx
801054e9:	85 c0                	test   %eax,%eax
801054eb:	74 63                	je     80105550 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054ed:	83 ec 0c             	sub    $0xc,%esp
801054f0:	50                   	push   %eax
801054f1:	e8 8a c2 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
801054f6:	83 c4 10             	add    $0x10,%esp
801054f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054fe:	75 30                	jne    80105530 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	53                   	push   %ebx
80105504:	e8 57 c3 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105509:	58                   	pop    %eax
8010550a:	ff 76 68             	push   0x68(%esi)
8010550d:	e8 9e c3 ff ff       	call   801018b0 <iput>
  end_op();
80105512:	e8 b9 d8 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105517:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	31 c0                	xor    %eax,%eax
}
8010551f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105522:	5b                   	pop    %ebx
80105523:	5e                   	pop    %esi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	53                   	push   %ebx
80105534:	e8 d7 c4 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105539:	e8 92 d8 ff ff       	call   80102dd0 <end_op>
    return -1;
8010553e:	83 c4 10             	add    $0x10,%esp
80105541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105546:	eb d7                	jmp    8010551f <sys_chdir+0x6f>
80105548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop
    end_op();
80105550:	e8 7b d8 ff ff       	call   80102dd0 <end_op>
    return -1;
80105555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555a:	eb c3                	jmp    8010551f <sys_chdir+0x6f>
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_exec>:

int
sys_exec(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	57                   	push   %edi
80105564:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105565:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010556b:	53                   	push   %ebx
8010556c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105572:	50                   	push   %eax
80105573:	6a 00                	push   $0x0
80105575:	e8 96 f4 ff ff       	call   80104a10 <argstr>
8010557a:	83 c4 10             	add    $0x10,%esp
8010557d:	85 c0                	test   %eax,%eax
8010557f:	0f 88 87 00 00 00    	js     8010560c <sys_exec+0xac>
80105585:	83 ec 08             	sub    $0x8,%esp
80105588:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010558e:	50                   	push   %eax
8010558f:	6a 01                	push   $0x1
80105591:	e8 ba f3 ff ff       	call   80104950 <argint>
80105596:	83 c4 10             	add    $0x10,%esp
80105599:	85 c0                	test   %eax,%eax
8010559b:	78 6f                	js     8010560c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010559d:	83 ec 04             	sub    $0x4,%esp
801055a0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801055a6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055a8:	68 80 00 00 00       	push   $0x80
801055ad:	6a 00                	push   $0x0
801055af:	56                   	push   %esi
801055b0:	e8 db f0 ff ff       	call   80104690 <memset>
801055b5:	83 c4 10             	add    $0x10,%esp
801055b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055bf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055c0:	83 ec 08             	sub    $0x8,%esp
801055c3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801055c9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801055d0:	50                   	push   %eax
801055d1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055d7:	01 f8                	add    %edi,%eax
801055d9:	50                   	push   %eax
801055da:	e8 e1 f2 ff ff       	call   801048c0 <fetchint>
801055df:	83 c4 10             	add    $0x10,%esp
801055e2:	85 c0                	test   %eax,%eax
801055e4:	78 26                	js     8010560c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801055e6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055ec:	85 c0                	test   %eax,%eax
801055ee:	74 30                	je     80105620 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055f0:	83 ec 08             	sub    $0x8,%esp
801055f3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801055f6:	52                   	push   %edx
801055f7:	50                   	push   %eax
801055f8:	e8 03 f3 ff ff       	call   80104900 <fetchstr>
801055fd:	83 c4 10             	add    $0x10,%esp
80105600:	85 c0                	test   %eax,%eax
80105602:	78 08                	js     8010560c <sys_exec+0xac>
  for(i=0;; i++){
80105604:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105607:	83 fb 20             	cmp    $0x20,%ebx
8010560a:	75 b4                	jne    801055c0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010560c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010560f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105614:	5b                   	pop    %ebx
80105615:	5e                   	pop    %esi
80105616:	5f                   	pop    %edi
80105617:	5d                   	pop    %ebp
80105618:	c3                   	ret    
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105620:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105627:	00 00 00 00 
  return exec(path, argv);
8010562b:	83 ec 08             	sub    $0x8,%esp
8010562e:	56                   	push   %esi
8010562f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105635:	e8 76 b4 ff ff       	call   80100ab0 <exec>
8010563a:	83 c4 10             	add    $0x10,%esp
}
8010563d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105640:	5b                   	pop    %ebx
80105641:	5e                   	pop    %esi
80105642:	5f                   	pop    %edi
80105643:	5d                   	pop    %ebp
80105644:	c3                   	ret    
80105645:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_pipe>:

int
sys_pipe(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105655:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105658:	53                   	push   %ebx
80105659:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010565c:	6a 08                	push   $0x8
8010565e:	50                   	push   %eax
8010565f:	6a 00                	push   $0x0
80105661:	e8 3a f3 ff ff       	call   801049a0 <argptr>
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	85 c0                	test   %eax,%eax
8010566b:	78 4a                	js     801056b7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010566d:	83 ec 08             	sub    $0x8,%esp
80105670:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105673:	50                   	push   %eax
80105674:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105677:	50                   	push   %eax
80105678:	e8 b3 dd ff ff       	call   80103430 <pipealloc>
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	85 c0                	test   %eax,%eax
80105682:	78 33                	js     801056b7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105684:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105687:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105689:	e8 f2 e2 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010568e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105690:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105694:	85 f6                	test   %esi,%esi
80105696:	74 28                	je     801056c0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105698:	83 c3 01             	add    $0x1,%ebx
8010569b:	83 fb 10             	cmp    $0x10,%ebx
8010569e:	75 f0                	jne    80105690 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	ff 75 e0             	push   -0x20(%ebp)
801056a6:	e8 45 b8 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
801056ab:	58                   	pop    %eax
801056ac:	ff 75 e4             	push   -0x1c(%ebp)
801056af:	e8 3c b8 ff ff       	call   80100ef0 <fileclose>
    return -1;
801056b4:	83 c4 10             	add    $0x10,%esp
801056b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056bc:	eb 53                	jmp    80105711 <sys_pipe+0xc1>
801056be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056c0:	8d 73 08             	lea    0x8(%ebx),%esi
801056c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056ca:	e8 b1 e2 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056cf:	31 d2                	xor    %edx,%edx
801056d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056d8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056dc:	85 c9                	test   %ecx,%ecx
801056de:	74 20                	je     80105700 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801056e0:	83 c2 01             	add    $0x1,%edx
801056e3:	83 fa 10             	cmp    $0x10,%edx
801056e6:	75 f0                	jne    801056d8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801056e8:	e8 93 e2 ff ff       	call   80103980 <myproc>
801056ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056f4:	00 
801056f5:	eb a9                	jmp    801056a0 <sys_pipe+0x50>
801056f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105700:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105704:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105707:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105709:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010570c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010570f:	31 c0                	xor    %eax,%eax
}
80105711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105714:	5b                   	pop    %ebx
80105715:	5e                   	pop    %esi
80105716:	5f                   	pop    %edi
80105717:	5d                   	pop    %ebp
80105718:	c3                   	ret    
80105719:	66 90                	xchg   %ax,%ax
8010571b:	66 90                	xchg   %ax,%ax
8010571d:	66 90                	xchg   %ax,%ax
8010571f:	90                   	nop

80105720 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105720:	e9 fb e3 ff ff       	jmp    80103b20 <fork>
80105725:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_exit>:
}

int
sys_exit(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 08             	sub    $0x8,%esp
  exit();
80105736:	e8 75 e6 ff ff       	call   80103db0 <exit>
  return 0;  // not reached
}
8010573b:	31 c0                	xor    %eax,%eax
8010573d:	c9                   	leave  
8010573e:	c3                   	ret    
8010573f:	90                   	nop

80105740 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105740:	e9 ab e7 ff ff       	jmp    80103ef0 <wait>
80105745:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_kill>:
}

int
sys_kill(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105756:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105759:	50                   	push   %eax
8010575a:	6a 00                	push   $0x0
8010575c:	e8 ef f1 ff ff       	call   80104950 <argint>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	85 c0                	test   %eax,%eax
80105766:	78 18                	js     80105780 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	ff 75 f4             	push   -0xc(%ebp)
8010576e:	e8 1d ea ff ff       	call   80104190 <kill>
80105773:	83 c4 10             	add    $0x10,%esp
}
80105776:	c9                   	leave  
80105777:	c3                   	ret    
80105778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577f:	90                   	nop
80105780:	c9                   	leave  
    return -1;
80105781:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105786:	c3                   	ret    
80105787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578e:	66 90                	xchg   %ax,%ax

80105790 <sys_getpid>:

int
sys_getpid(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105796:	e8 e5 e1 ff ff       	call   80103980 <myproc>
8010579b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010579e:	c9                   	leave  
8010579f:	c3                   	ret    

801057a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057aa:	50                   	push   %eax
801057ab:	6a 00                	push   $0x0
801057ad:	e8 9e f1 ff ff       	call   80104950 <argint>
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	85 c0                	test   %eax,%eax
801057b7:	78 27                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057b9:	e8 c2 e1 ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
801057be:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057c1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057c3:	ff 75 f4             	push   -0xc(%ebp)
801057c6:	e8 d5 e2 ff ff       	call   80103aa0 <growproc>
801057cb:	83 c4 10             	add    $0x10,%esp
801057ce:	85 c0                	test   %eax,%eax
801057d0:	78 0e                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057d2:	89 d8                	mov    %ebx,%eax
801057d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057d7:	c9                   	leave  
801057d8:	c3                   	ret    
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057e5:	eb eb                	jmp    801057d2 <sys_sbrk+0x32>
801057e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ee:	66 90                	xchg   %ax,%ax

801057f0 <sys_sleep>:

int
sys_sleep(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057fa:	50                   	push   %eax
801057fb:	6a 00                	push   $0x0
801057fd:	e8 4e f1 ff ff       	call   80104950 <argint>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	85 c0                	test   %eax,%eax
80105807:	0f 88 8a 00 00 00    	js     80105897 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	68 80 de 11 80       	push   $0x8011de80
80105815:	e8 b6 ed ff ff       	call   801045d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010581a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010581d:	8b 1d 60 de 11 80    	mov    0x8011de60,%ebx
  while(ticks - ticks0 < n){
80105823:	83 c4 10             	add    $0x10,%esp
80105826:	85 d2                	test   %edx,%edx
80105828:	75 27                	jne    80105851 <sys_sleep+0x61>
8010582a:	eb 54                	jmp    80105880 <sys_sleep+0x90>
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	68 80 de 11 80       	push   $0x8011de80
80105838:	68 60 de 11 80       	push   $0x8011de60
8010583d:	e8 2e e8 ff ff       	call   80104070 <sleep>
  while(ticks - ticks0 < n){
80105842:	a1 60 de 11 80       	mov    0x8011de60,%eax
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	29 d8                	sub    %ebx,%eax
8010584c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010584f:	73 2f                	jae    80105880 <sys_sleep+0x90>
    if(myproc()->killed){
80105851:	e8 2a e1 ff ff       	call   80103980 <myproc>
80105856:	8b 40 24             	mov    0x24(%eax),%eax
80105859:	85 c0                	test   %eax,%eax
8010585b:	74 d3                	je     80105830 <sys_sleep+0x40>
      release(&tickslock);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	68 80 de 11 80       	push   $0x8011de80
80105865:	e8 06 ed ff ff       	call   80104570 <release>
  }
  release(&tickslock);
  return 0;
}
8010586a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    
80105877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	68 80 de 11 80       	push   $0x8011de80
80105888:	e8 e3 ec ff ff       	call   80104570 <release>
  return 0;
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	31 c0                	xor    %eax,%eax
}
80105892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105895:	c9                   	leave  
80105896:	c3                   	ret    
    return -1;
80105897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589c:	eb f4                	jmp    80105892 <sys_sleep+0xa2>
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	53                   	push   %ebx
801058a4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058a7:	68 80 de 11 80       	push   $0x8011de80
801058ac:	e8 1f ed ff ff       	call   801045d0 <acquire>
  xticks = ticks;
801058b1:	8b 1d 60 de 11 80    	mov    0x8011de60,%ebx
  release(&tickslock);
801058b7:	c7 04 24 80 de 11 80 	movl   $0x8011de80,(%esp)
801058be:	e8 ad ec ff ff       	call   80104570 <release>
  return xticks;
}
801058c3:	89 d8                	mov    %ebx,%eax
801058c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c8:	c9                   	leave  
801058c9:	c3                   	ret    

801058ca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058ca:	1e                   	push   %ds
  pushl %es
801058cb:	06                   	push   %es
  pushl %fs
801058cc:	0f a0                	push   %fs
  pushl %gs
801058ce:	0f a8                	push   %gs
  pushal
801058d0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058d1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058d5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058d7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058d9:	54                   	push   %esp
  call trap
801058da:	e8 c1 00 00 00       	call   801059a0 <trap>
  addl $4, %esp
801058df:	83 c4 04             	add    $0x4,%esp

801058e2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058e2:	61                   	popa   
  popl %gs
801058e3:	0f a9                	pop    %gs
  popl %fs
801058e5:	0f a1                	pop    %fs
  popl %es
801058e7:	07                   	pop    %es
  popl %ds
801058e8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058e9:	83 c4 08             	add    $0x8,%esp
  iret
801058ec:	cf                   	iret   
801058ed:	66 90                	xchg   %ax,%ax
801058ef:	90                   	nop

801058f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801058f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801058f1:	31 c0                	xor    %eax,%eax
{
801058f3:	89 e5                	mov    %esp,%ebp
801058f5:	83 ec 08             	sub    $0x8,%esp
801058f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105900:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80105907:	c7 04 c5 c2 de 11 80 	movl   $0x8e000008,-0x7fee213e(,%eax,8)
8010590e:	08 00 00 8e 
80105912:	66 89 14 c5 c0 de 11 	mov    %dx,-0x7fee2140(,%eax,8)
80105919:	80 
8010591a:	c1 ea 10             	shr    $0x10,%edx
8010591d:	66 89 14 c5 c6 de 11 	mov    %dx,-0x7fee213a(,%eax,8)
80105924:	80 
  for(i = 0; i < 256; i++)
80105925:	83 c0 01             	add    $0x1,%eax
80105928:	3d 00 01 00 00       	cmp    $0x100,%eax
8010592d:	75 d1                	jne    80105900 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010592f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105932:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80105937:	c7 05 c2 e0 11 80 08 	movl   $0xef000008,0x8011e0c2
8010593e:	00 00 ef 
  initlock(&tickslock, "time");
80105941:	68 cd 8d 10 80       	push   $0x80108dcd
80105946:	68 80 de 11 80       	push   $0x8011de80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010594b:	66 a3 c0 e0 11 80    	mov    %ax,0x8011e0c0
80105951:	c1 e8 10             	shr    $0x10,%eax
80105954:	66 a3 c6 e0 11 80    	mov    %ax,0x8011e0c6
  initlock(&tickslock, "time");
8010595a:	e8 a1 ea ff ff       	call   80104400 <initlock>
}
8010595f:	83 c4 10             	add    $0x10,%esp
80105962:	c9                   	leave  
80105963:	c3                   	ret    
80105964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop

80105970 <idtinit>:

void
idtinit(void)
{
80105970:	55                   	push   %ebp
  pd[0] = size-1;
80105971:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105976:	89 e5                	mov    %esp,%ebp
80105978:	83 ec 10             	sub    $0x10,%esp
8010597b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010597f:	b8 c0 de 11 80       	mov    $0x8011dec0,%eax
80105984:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105988:	c1 e8 10             	shr    $0x10,%eax
8010598b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010598f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105992:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105995:	c9                   	leave  
80105996:	c3                   	ret    
80105997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599e:	66 90                	xchg   %ax,%ax

801059a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	57                   	push   %edi
801059a4:	56                   	push   %esi
801059a5:	53                   	push   %ebx
801059a6:	83 ec 1c             	sub    $0x1c,%esp
801059a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801059ac:	8b 43 30             	mov    0x30(%ebx),%eax
801059af:	83 f8 40             	cmp    $0x40,%eax
801059b2:	0f 84 70 01 00 00    	je     80105b28 <trap+0x188>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059b8:	83 e8 0e             	sub    $0xe,%eax
801059bb:	83 f8 31             	cmp    $0x31,%eax
801059be:	0f 87 cc 00 00 00    	ja     80105a90 <trap+0xf0>
801059c4:	ff 24 85 88 8e 10 80 	jmp    *-0x7fef7178(,%eax,4)
801059cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059cf:	90                   	nop
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801059d0:	e8 8b df ff ff       	call   80103960 <cpuid>
801059d5:	85 c0                	test   %eax,%eax
801059d7:	0f 84 33 02 00 00    	je     80105c10 <trap+0x270>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801059dd:	e8 2e cf ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059e2:	e8 99 df ff ff       	call   80103980 <myproc>
801059e7:	85 c0                	test   %eax,%eax
801059e9:	74 1d                	je     80105a08 <trap+0x68>
801059eb:	e8 90 df ff ff       	call   80103980 <myproc>
801059f0:	8b 50 24             	mov    0x24(%eax),%edx
801059f3:	85 d2                	test   %edx,%edx
801059f5:	74 11                	je     80105a08 <trap+0x68>
801059f7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059fb:	83 e0 03             	and    $0x3,%eax
801059fe:	66 83 f8 03          	cmp    $0x3,%ax
80105a02:	0f 84 e8 01 00 00    	je     80105bf0 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a08:	e8 73 df ff ff       	call   80103980 <myproc>
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	74 0f                	je     80105a20 <trap+0x80>
80105a11:	e8 6a df ff ff       	call   80103980 <myproc>
80105a16:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a1a:	0f 84 f0 00 00 00    	je     80105b10 <trap+0x170>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a20:	e8 5b df ff ff       	call   80103980 <myproc>
80105a25:	85 c0                	test   %eax,%eax
80105a27:	74 1d                	je     80105a46 <trap+0xa6>
80105a29:	e8 52 df ff ff       	call   80103980 <myproc>
80105a2e:	8b 40 24             	mov    0x24(%eax),%eax
80105a31:	85 c0                	test   %eax,%eax
80105a33:	74 11                	je     80105a46 <trap+0xa6>
80105a35:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a39:	83 e0 03             	and    $0x3,%eax
80105a3c:	66 83 f8 03          	cmp    $0x3,%ax
80105a40:	0f 84 0f 01 00 00    	je     80105b55 <trap+0x1b5>
    exit();
}
80105a46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a49:	5b                   	pop    %ebx
80105a4a:	5e                   	pop    %esi
80105a4b:	5f                   	pop    %edi
80105a4c:	5d                   	pop    %ebp
80105a4d:	c3                   	ret    
80105a4e:	66 90                	xchg   %ax,%ax

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a50:	0f 20 d0             	mov    %cr2,%eax
    if (handle_page_fault(rcr2()))
80105a53:	83 ec 0c             	sub    $0xc,%esp
80105a56:	50                   	push   %eax
80105a57:	e8 a4 26 00 00       	call   80108100 <handle_page_fault>
80105a5c:	83 c4 10             	add    $0x10,%esp
80105a5f:	85 c0                	test   %eax,%eax
80105a61:	0f 85 7b ff ff ff    	jne    801059e2 <trap+0x42>
        cprintf("Segmentation Fault\n");
80105a67:	83 ec 0c             	sub    $0xc,%esp
80105a6a:	68 d2 8d 10 80       	push   $0x80108dd2
80105a6f:	e8 2c ac ff ff       	call   801006a0 <cprintf>
        myproc()->killed = 1;
80105a74:	e8 07 df ff ff       	call   80103980 <myproc>
80105a79:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        exit();
80105a80:	e8 2b e3 ff ff       	call   80103db0 <exit>
80105a85:	83 c4 10             	add    $0x10,%esp
80105a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8f:	90                   	nop
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a90:	e8 eb de ff ff       	call   80103980 <myproc>
80105a95:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a98:	85 c0                	test   %eax,%eax
80105a9a:	0f 84 a4 01 00 00    	je     80105c44 <trap+0x2a4>
80105aa0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105aa4:	0f 84 9a 01 00 00    	je     80105c44 <trap+0x2a4>
80105aaa:	0f 20 d1             	mov    %cr2,%ecx
80105aad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ab0:	e8 ab de ff ff       	call   80103960 <cpuid>
80105ab5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105abb:	8b 43 34             	mov    0x34(%ebx),%eax
80105abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ac1:	e8 ba de ff ff       	call   80103980 <myproc>
80105ac6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ac9:	e8 b2 de ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ace:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ad1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ad4:	51                   	push   %ecx
80105ad5:	57                   	push   %edi
80105ad6:	52                   	push   %edx
80105ad7:	ff 75 e4             	push   -0x1c(%ebp)
80105ada:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105adb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105ade:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ae1:	56                   	push   %esi
80105ae2:	ff 70 10             	push   0x10(%eax)
80105ae5:	68 44 8e 10 80       	push   $0x80108e44
80105aea:	e8 b1 ab ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105aef:	83 c4 20             	add    $0x20,%esp
80105af2:	e8 89 de ff ff       	call   80103980 <myproc>
80105af7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105afe:	e8 7d de ff ff       	call   80103980 <myproc>
80105b03:	85 c0                	test   %eax,%eax
80105b05:	0f 85 e0 fe ff ff    	jne    801059eb <trap+0x4b>
80105b0b:	e9 f8 fe ff ff       	jmp    80105a08 <trap+0x68>
  if(myproc() && myproc()->state == RUNNING &&
80105b10:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b14:	0f 85 06 ff ff ff    	jne    80105a20 <trap+0x80>
    yield();
80105b1a:	e8 01 e5 ff ff       	call   80104020 <yield>
80105b1f:	e9 fc fe ff ff       	jmp    80105a20 <trap+0x80>
80105b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105b28:	e8 53 de ff ff       	call   80103980 <myproc>
80105b2d:	8b 70 24             	mov    0x24(%eax),%esi
80105b30:	85 f6                	test   %esi,%esi
80105b32:	0f 85 c8 00 00 00    	jne    80105c00 <trap+0x260>
    myproc()->tf = tf;
80105b38:	e8 43 de ff ff       	call   80103980 <myproc>
80105b3d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b40:	e8 4b ef ff ff       	call   80104a90 <syscall>
    if(myproc()->killed)
80105b45:	e8 36 de ff ff       	call   80103980 <myproc>
80105b4a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b4d:	85 c9                	test   %ecx,%ecx
80105b4f:	0f 84 f1 fe ff ff    	je     80105a46 <trap+0xa6>
}
80105b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b58:	5b                   	pop    %ebx
80105b59:	5e                   	pop    %esi
80105b5a:	5f                   	pop    %edi
80105b5b:	5d                   	pop    %ebp
      exit();
80105b5c:	e9 4f e2 ff ff       	jmp    80103db0 <exit>
80105b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b68:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b6b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b6f:	e8 ec dd ff ff       	call   80103960 <cpuid>
80105b74:	57                   	push   %edi
80105b75:	56                   	push   %esi
80105b76:	50                   	push   %eax
80105b77:	68 ec 8d 10 80       	push   $0x80108dec
80105b7c:	e8 1f ab ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105b81:	e8 8a cd ff ff       	call   80102910 <lapiceoi>
    break;
80105b86:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b89:	e8 f2 dd ff ff       	call   80103980 <myproc>
80105b8e:	85 c0                	test   %eax,%eax
80105b90:	0f 85 55 fe ff ff    	jne    801059eb <trap+0x4b>
80105b96:	e9 6d fe ff ff       	jmp    80105a08 <trap+0x68>
80105b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b9f:	90                   	nop
    kbdintr();
80105ba0:	e8 2b cc ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
80105ba5:	e8 66 cd ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105baa:	e8 d1 dd ff ff       	call   80103980 <myproc>
80105baf:	85 c0                	test   %eax,%eax
80105bb1:	0f 85 34 fe ff ff    	jne    801059eb <trap+0x4b>
80105bb7:	e9 4c fe ff ff       	jmp    80105a08 <trap+0x68>
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105bc0:	e8 1b 02 00 00       	call   80105de0 <uartintr>
    lapiceoi();
80105bc5:	e8 46 cd ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bca:	e8 b1 dd ff ff       	call   80103980 <myproc>
80105bcf:	85 c0                	test   %eax,%eax
80105bd1:	0f 85 14 fe ff ff    	jne    801059eb <trap+0x4b>
80105bd7:	e9 2c fe ff ff       	jmp    80105a08 <trap+0x68>
80105bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105be0:	e8 5b c6 ff ff       	call   80102240 <ideintr>
80105be5:	e9 f3 fd ff ff       	jmp    801059dd <trap+0x3d>
80105bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105bf0:	e8 bb e1 ff ff       	call   80103db0 <exit>
80105bf5:	e9 0e fe ff ff       	jmp    80105a08 <trap+0x68>
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105c00:	e8 ab e1 ff ff       	call   80103db0 <exit>
80105c05:	e9 2e ff ff ff       	jmp    80105b38 <trap+0x198>
80105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105c10:	83 ec 0c             	sub    $0xc,%esp
80105c13:	68 80 de 11 80       	push   $0x8011de80
80105c18:	e8 b3 e9 ff ff       	call   801045d0 <acquire>
      wakeup(&ticks);
80105c1d:	c7 04 24 60 de 11 80 	movl   $0x8011de60,(%esp)
      ticks++;
80105c24:	83 05 60 de 11 80 01 	addl   $0x1,0x8011de60
      wakeup(&ticks);
80105c2b:	e8 00 e5 ff ff       	call   80104130 <wakeup>
      release(&tickslock);
80105c30:	c7 04 24 80 de 11 80 	movl   $0x8011de80,(%esp)
80105c37:	e8 34 e9 ff ff       	call   80104570 <release>
80105c3c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105c3f:	e9 99 fd ff ff       	jmp    801059dd <trap+0x3d>
80105c44:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c47:	e8 14 dd ff ff       	call   80103960 <cpuid>
80105c4c:	83 ec 0c             	sub    $0xc,%esp
80105c4f:	56                   	push   %esi
80105c50:	57                   	push   %edi
80105c51:	50                   	push   %eax
80105c52:	ff 73 30             	push   0x30(%ebx)
80105c55:	68 10 8e 10 80       	push   $0x80108e10
80105c5a:	e8 41 aa ff ff       	call   801006a0 <cprintf>
      panic("trap");
80105c5f:	83 c4 14             	add    $0x14,%esp
80105c62:	68 e6 8d 10 80       	push   $0x80108de6
80105c67:	e8 14 a7 ff ff       	call   80100380 <panic>
80105c6c:	66 90                	xchg   %ax,%ax
80105c6e:	66 90                	xchg   %ax,%ax

80105c70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c70:	a1 c0 e6 11 80       	mov    0x8011e6c0,%eax
80105c75:	85 c0                	test   %eax,%eax
80105c77:	74 17                	je     80105c90 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c79:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c7e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c7f:	a8 01                	test   $0x1,%al
80105c81:	74 0d                	je     80105c90 <uartgetc+0x20>
80105c83:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c88:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c89:	0f b6 c0             	movzbl %al,%eax
80105c8c:	c3                   	ret    
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c95:	c3                   	ret    
80105c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9d:	8d 76 00             	lea    0x0(%esi),%esi

80105ca0 <uartinit>:
{
80105ca0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ca1:	31 c9                	xor    %ecx,%ecx
80105ca3:	89 c8                	mov    %ecx,%eax
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	57                   	push   %edi
80105ca8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105cad:	56                   	push   %esi
80105cae:	89 fa                	mov    %edi,%edx
80105cb0:	53                   	push   %ebx
80105cb1:	83 ec 1c             	sub    $0x1c,%esp
80105cb4:	ee                   	out    %al,(%dx)
80105cb5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105cba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105cbf:	89 f2                	mov    %esi,%edx
80105cc1:	ee                   	out    %al,(%dx)
80105cc2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105cc7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ccc:	ee                   	out    %al,(%dx)
80105ccd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105cd2:	89 c8                	mov    %ecx,%eax
80105cd4:	89 da                	mov    %ebx,%edx
80105cd6:	ee                   	out    %al,(%dx)
80105cd7:	b8 03 00 00 00       	mov    $0x3,%eax
80105cdc:	89 f2                	mov    %esi,%edx
80105cde:	ee                   	out    %al,(%dx)
80105cdf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ce4:	89 c8                	mov    %ecx,%eax
80105ce6:	ee                   	out    %al,(%dx)
80105ce7:	b8 01 00 00 00       	mov    $0x1,%eax
80105cec:	89 da                	mov    %ebx,%edx
80105cee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cef:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cf4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105cf5:	3c ff                	cmp    $0xff,%al
80105cf7:	74 78                	je     80105d71 <uartinit+0xd1>
  uart = 1;
80105cf9:	c7 05 c0 e6 11 80 01 	movl   $0x1,0x8011e6c0
80105d00:	00 00 00 
80105d03:	89 fa                	mov    %edi,%edx
80105d05:	ec                   	in     (%dx),%al
80105d06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d0b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d0c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105d0f:	bf 50 8f 10 80       	mov    $0x80108f50,%edi
80105d14:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105d19:	6a 00                	push   $0x0
80105d1b:	6a 04                	push   $0x4
80105d1d:	e8 5e c7 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105d22:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80105d26:	83 c4 10             	add    $0x10,%esp
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105d30:	a1 c0 e6 11 80       	mov    0x8011e6c0,%eax
80105d35:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d3a:	85 c0                	test   %eax,%eax
80105d3c:	75 14                	jne    80105d52 <uartinit+0xb2>
80105d3e:	eb 23                	jmp    80105d63 <uartinit+0xc3>
    microdelay(10);
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	6a 0a                	push   $0xa
80105d45:	e8 e6 cb ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d4a:	83 c4 10             	add    $0x10,%esp
80105d4d:	83 eb 01             	sub    $0x1,%ebx
80105d50:	74 07                	je     80105d59 <uartinit+0xb9>
80105d52:	89 f2                	mov    %esi,%edx
80105d54:	ec                   	in     (%dx),%al
80105d55:	a8 20                	test   $0x20,%al
80105d57:	74 e7                	je     80105d40 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d59:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105d5d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d62:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105d63:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105d67:	83 c7 01             	add    $0x1,%edi
80105d6a:	88 45 e7             	mov    %al,-0x19(%ebp)
80105d6d:	84 c0                	test   %al,%al
80105d6f:	75 bf                	jne    80105d30 <uartinit+0x90>
}
80105d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d74:	5b                   	pop    %ebx
80105d75:	5e                   	pop    %esi
80105d76:	5f                   	pop    %edi
80105d77:	5d                   	pop    %ebp
80105d78:	c3                   	ret    
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d80 <uartputc>:
  if(!uart)
80105d80:	a1 c0 e6 11 80       	mov    0x8011e6c0,%eax
80105d85:	85 c0                	test   %eax,%eax
80105d87:	74 47                	je     80105dd0 <uartputc+0x50>
{
80105d89:	55                   	push   %ebp
80105d8a:	89 e5                	mov    %esp,%ebp
80105d8c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d8d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d92:	53                   	push   %ebx
80105d93:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d98:	eb 18                	jmp    80105db2 <uartputc+0x32>
80105d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	6a 0a                	push   $0xa
80105da5:	e8 86 cb ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105daa:	83 c4 10             	add    $0x10,%esp
80105dad:	83 eb 01             	sub    $0x1,%ebx
80105db0:	74 07                	je     80105db9 <uartputc+0x39>
80105db2:	89 f2                	mov    %esi,%edx
80105db4:	ec                   	in     (%dx),%al
80105db5:	a8 20                	test   $0x20,%al
80105db7:	74 e7                	je     80105da0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105db9:	8b 45 08             	mov    0x8(%ebp),%eax
80105dbc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dc1:	ee                   	out    %al,(%dx)
}
80105dc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dc5:	5b                   	pop    %ebx
80105dc6:	5e                   	pop    %esi
80105dc7:	5d                   	pop    %ebp
80105dc8:	c3                   	ret    
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dd0:	c3                   	ret    
80105dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ddf:	90                   	nop

80105de0 <uartintr>:

void
uartintr(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105de6:	68 70 5c 10 80       	push   $0x80105c70
80105deb:	e8 90 aa ff ff       	call   80100880 <consoleintr>
}
80105df0:	83 c4 10             	add    $0x10,%esp
80105df3:	c9                   	leave  
80105df4:	c3                   	ret    

80105df5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105df5:	6a 00                	push   $0x0
  pushl $0
80105df7:	6a 00                	push   $0x0
  jmp alltraps
80105df9:	e9 cc fa ff ff       	jmp    801058ca <alltraps>

80105dfe <vector1>:
.globl vector1
vector1:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $1
80105e00:	6a 01                	push   $0x1
  jmp alltraps
80105e02:	e9 c3 fa ff ff       	jmp    801058ca <alltraps>

80105e07 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $2
80105e09:	6a 02                	push   $0x2
  jmp alltraps
80105e0b:	e9 ba fa ff ff       	jmp    801058ca <alltraps>

80105e10 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e10:	6a 00                	push   $0x0
  pushl $3
80105e12:	6a 03                	push   $0x3
  jmp alltraps
80105e14:	e9 b1 fa ff ff       	jmp    801058ca <alltraps>

80105e19 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $4
80105e1b:	6a 04                	push   $0x4
  jmp alltraps
80105e1d:	e9 a8 fa ff ff       	jmp    801058ca <alltraps>

80105e22 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $5
80105e24:	6a 05                	push   $0x5
  jmp alltraps
80105e26:	e9 9f fa ff ff       	jmp    801058ca <alltraps>

80105e2b <vector6>:
.globl vector6
vector6:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $6
80105e2d:	6a 06                	push   $0x6
  jmp alltraps
80105e2f:	e9 96 fa ff ff       	jmp    801058ca <alltraps>

80105e34 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $7
80105e36:	6a 07                	push   $0x7
  jmp alltraps
80105e38:	e9 8d fa ff ff       	jmp    801058ca <alltraps>

80105e3d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e3d:	6a 08                	push   $0x8
  jmp alltraps
80105e3f:	e9 86 fa ff ff       	jmp    801058ca <alltraps>

80105e44 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $9
80105e46:	6a 09                	push   $0x9
  jmp alltraps
80105e48:	e9 7d fa ff ff       	jmp    801058ca <alltraps>

80105e4d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e4d:	6a 0a                	push   $0xa
  jmp alltraps
80105e4f:	e9 76 fa ff ff       	jmp    801058ca <alltraps>

80105e54 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e54:	6a 0b                	push   $0xb
  jmp alltraps
80105e56:	e9 6f fa ff ff       	jmp    801058ca <alltraps>

80105e5b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e5b:	6a 0c                	push   $0xc
  jmp alltraps
80105e5d:	e9 68 fa ff ff       	jmp    801058ca <alltraps>

80105e62 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e62:	6a 0d                	push   $0xd
  jmp alltraps
80105e64:	e9 61 fa ff ff       	jmp    801058ca <alltraps>

80105e69 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e69:	6a 0e                	push   $0xe
  jmp alltraps
80105e6b:	e9 5a fa ff ff       	jmp    801058ca <alltraps>

80105e70 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e70:	6a 00                	push   $0x0
  pushl $15
80105e72:	6a 0f                	push   $0xf
  jmp alltraps
80105e74:	e9 51 fa ff ff       	jmp    801058ca <alltraps>

80105e79 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e79:	6a 00                	push   $0x0
  pushl $16
80105e7b:	6a 10                	push   $0x10
  jmp alltraps
80105e7d:	e9 48 fa ff ff       	jmp    801058ca <alltraps>

80105e82 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e82:	6a 11                	push   $0x11
  jmp alltraps
80105e84:	e9 41 fa ff ff       	jmp    801058ca <alltraps>

80105e89 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $18
80105e8b:	6a 12                	push   $0x12
  jmp alltraps
80105e8d:	e9 38 fa ff ff       	jmp    801058ca <alltraps>

80105e92 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $19
80105e94:	6a 13                	push   $0x13
  jmp alltraps
80105e96:	e9 2f fa ff ff       	jmp    801058ca <alltraps>

80105e9b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e9b:	6a 00                	push   $0x0
  pushl $20
80105e9d:	6a 14                	push   $0x14
  jmp alltraps
80105e9f:	e9 26 fa ff ff       	jmp    801058ca <alltraps>

80105ea4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $21
80105ea6:	6a 15                	push   $0x15
  jmp alltraps
80105ea8:	e9 1d fa ff ff       	jmp    801058ca <alltraps>

80105ead <vector22>:
.globl vector22
vector22:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $22
80105eaf:	6a 16                	push   $0x16
  jmp alltraps
80105eb1:	e9 14 fa ff ff       	jmp    801058ca <alltraps>

80105eb6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $23
80105eb8:	6a 17                	push   $0x17
  jmp alltraps
80105eba:	e9 0b fa ff ff       	jmp    801058ca <alltraps>

80105ebf <vector24>:
.globl vector24
vector24:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $24
80105ec1:	6a 18                	push   $0x18
  jmp alltraps
80105ec3:	e9 02 fa ff ff       	jmp    801058ca <alltraps>

80105ec8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ec8:	6a 00                	push   $0x0
  pushl $25
80105eca:	6a 19                	push   $0x19
  jmp alltraps
80105ecc:	e9 f9 f9 ff ff       	jmp    801058ca <alltraps>

80105ed1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ed1:	6a 00                	push   $0x0
  pushl $26
80105ed3:	6a 1a                	push   $0x1a
  jmp alltraps
80105ed5:	e9 f0 f9 ff ff       	jmp    801058ca <alltraps>

80105eda <vector27>:
.globl vector27
vector27:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $27
80105edc:	6a 1b                	push   $0x1b
  jmp alltraps
80105ede:	e9 e7 f9 ff ff       	jmp    801058ca <alltraps>

80105ee3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $28
80105ee5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ee7:	e9 de f9 ff ff       	jmp    801058ca <alltraps>

80105eec <vector29>:
.globl vector29
vector29:
  pushl $0
80105eec:	6a 00                	push   $0x0
  pushl $29
80105eee:	6a 1d                	push   $0x1d
  jmp alltraps
80105ef0:	e9 d5 f9 ff ff       	jmp    801058ca <alltraps>

80105ef5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $30
80105ef7:	6a 1e                	push   $0x1e
  jmp alltraps
80105ef9:	e9 cc f9 ff ff       	jmp    801058ca <alltraps>

80105efe <vector31>:
.globl vector31
vector31:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $31
80105f00:	6a 1f                	push   $0x1f
  jmp alltraps
80105f02:	e9 c3 f9 ff ff       	jmp    801058ca <alltraps>

80105f07 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $32
80105f09:	6a 20                	push   $0x20
  jmp alltraps
80105f0b:	e9 ba f9 ff ff       	jmp    801058ca <alltraps>

80105f10 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $33
80105f12:	6a 21                	push   $0x21
  jmp alltraps
80105f14:	e9 b1 f9 ff ff       	jmp    801058ca <alltraps>

80105f19 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f19:	6a 00                	push   $0x0
  pushl $34
80105f1b:	6a 22                	push   $0x22
  jmp alltraps
80105f1d:	e9 a8 f9 ff ff       	jmp    801058ca <alltraps>

80105f22 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $35
80105f24:	6a 23                	push   $0x23
  jmp alltraps
80105f26:	e9 9f f9 ff ff       	jmp    801058ca <alltraps>

80105f2b <vector36>:
.globl vector36
vector36:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $36
80105f2d:	6a 24                	push   $0x24
  jmp alltraps
80105f2f:	e9 96 f9 ff ff       	jmp    801058ca <alltraps>

80105f34 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $37
80105f36:	6a 25                	push   $0x25
  jmp alltraps
80105f38:	e9 8d f9 ff ff       	jmp    801058ca <alltraps>

80105f3d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f3d:	6a 00                	push   $0x0
  pushl $38
80105f3f:	6a 26                	push   $0x26
  jmp alltraps
80105f41:	e9 84 f9 ff ff       	jmp    801058ca <alltraps>

80105f46 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $39
80105f48:	6a 27                	push   $0x27
  jmp alltraps
80105f4a:	e9 7b f9 ff ff       	jmp    801058ca <alltraps>

80105f4f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f4f:	6a 00                	push   $0x0
  pushl $40
80105f51:	6a 28                	push   $0x28
  jmp alltraps
80105f53:	e9 72 f9 ff ff       	jmp    801058ca <alltraps>

80105f58 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f58:	6a 00                	push   $0x0
  pushl $41
80105f5a:	6a 29                	push   $0x29
  jmp alltraps
80105f5c:	e9 69 f9 ff ff       	jmp    801058ca <alltraps>

80105f61 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f61:	6a 00                	push   $0x0
  pushl $42
80105f63:	6a 2a                	push   $0x2a
  jmp alltraps
80105f65:	e9 60 f9 ff ff       	jmp    801058ca <alltraps>

80105f6a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $43
80105f6c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f6e:	e9 57 f9 ff ff       	jmp    801058ca <alltraps>

80105f73 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $44
80105f75:	6a 2c                	push   $0x2c
  jmp alltraps
80105f77:	e9 4e f9 ff ff       	jmp    801058ca <alltraps>

80105f7c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f7c:	6a 00                	push   $0x0
  pushl $45
80105f7e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f80:	e9 45 f9 ff ff       	jmp    801058ca <alltraps>

80105f85 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f85:	6a 00                	push   $0x0
  pushl $46
80105f87:	6a 2e                	push   $0x2e
  jmp alltraps
80105f89:	e9 3c f9 ff ff       	jmp    801058ca <alltraps>

80105f8e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $47
80105f90:	6a 2f                	push   $0x2f
  jmp alltraps
80105f92:	e9 33 f9 ff ff       	jmp    801058ca <alltraps>

80105f97 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $48
80105f99:	6a 30                	push   $0x30
  jmp alltraps
80105f9b:	e9 2a f9 ff ff       	jmp    801058ca <alltraps>

80105fa0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $49
80105fa2:	6a 31                	push   $0x31
  jmp alltraps
80105fa4:	e9 21 f9 ff ff       	jmp    801058ca <alltraps>

80105fa9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $50
80105fab:	6a 32                	push   $0x32
  jmp alltraps
80105fad:	e9 18 f9 ff ff       	jmp    801058ca <alltraps>

80105fb2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $51
80105fb4:	6a 33                	push   $0x33
  jmp alltraps
80105fb6:	e9 0f f9 ff ff       	jmp    801058ca <alltraps>

80105fbb <vector52>:
.globl vector52
vector52:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $52
80105fbd:	6a 34                	push   $0x34
  jmp alltraps
80105fbf:	e9 06 f9 ff ff       	jmp    801058ca <alltraps>

80105fc4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $53
80105fc6:	6a 35                	push   $0x35
  jmp alltraps
80105fc8:	e9 fd f8 ff ff       	jmp    801058ca <alltraps>

80105fcd <vector54>:
.globl vector54
vector54:
  pushl $0
80105fcd:	6a 00                	push   $0x0
  pushl $54
80105fcf:	6a 36                	push   $0x36
  jmp alltraps
80105fd1:	e9 f4 f8 ff ff       	jmp    801058ca <alltraps>

80105fd6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $55
80105fd8:	6a 37                	push   $0x37
  jmp alltraps
80105fda:	e9 eb f8 ff ff       	jmp    801058ca <alltraps>

80105fdf <vector56>:
.globl vector56
vector56:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $56
80105fe1:	6a 38                	push   $0x38
  jmp alltraps
80105fe3:	e9 e2 f8 ff ff       	jmp    801058ca <alltraps>

80105fe8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105fe8:	6a 00                	push   $0x0
  pushl $57
80105fea:	6a 39                	push   $0x39
  jmp alltraps
80105fec:	e9 d9 f8 ff ff       	jmp    801058ca <alltraps>

80105ff1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105ff1:	6a 00                	push   $0x0
  pushl $58
80105ff3:	6a 3a                	push   $0x3a
  jmp alltraps
80105ff5:	e9 d0 f8 ff ff       	jmp    801058ca <alltraps>

80105ffa <vector59>:
.globl vector59
vector59:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $59
80105ffc:	6a 3b                	push   $0x3b
  jmp alltraps
80105ffe:	e9 c7 f8 ff ff       	jmp    801058ca <alltraps>

80106003 <vector60>:
.globl vector60
vector60:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $60
80106005:	6a 3c                	push   $0x3c
  jmp alltraps
80106007:	e9 be f8 ff ff       	jmp    801058ca <alltraps>

8010600c <vector61>:
.globl vector61
vector61:
  pushl $0
8010600c:	6a 00                	push   $0x0
  pushl $61
8010600e:	6a 3d                	push   $0x3d
  jmp alltraps
80106010:	e9 b5 f8 ff ff       	jmp    801058ca <alltraps>

80106015 <vector62>:
.globl vector62
vector62:
  pushl $0
80106015:	6a 00                	push   $0x0
  pushl $62
80106017:	6a 3e                	push   $0x3e
  jmp alltraps
80106019:	e9 ac f8 ff ff       	jmp    801058ca <alltraps>

8010601e <vector63>:
.globl vector63
vector63:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $63
80106020:	6a 3f                	push   $0x3f
  jmp alltraps
80106022:	e9 a3 f8 ff ff       	jmp    801058ca <alltraps>

80106027 <vector64>:
.globl vector64
vector64:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $64
80106029:	6a 40                	push   $0x40
  jmp alltraps
8010602b:	e9 9a f8 ff ff       	jmp    801058ca <alltraps>

80106030 <vector65>:
.globl vector65
vector65:
  pushl $0
80106030:	6a 00                	push   $0x0
  pushl $65
80106032:	6a 41                	push   $0x41
  jmp alltraps
80106034:	e9 91 f8 ff ff       	jmp    801058ca <alltraps>

80106039 <vector66>:
.globl vector66
vector66:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $66
8010603b:	6a 42                	push   $0x42
  jmp alltraps
8010603d:	e9 88 f8 ff ff       	jmp    801058ca <alltraps>

80106042 <vector67>:
.globl vector67
vector67:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $67
80106044:	6a 43                	push   $0x43
  jmp alltraps
80106046:	e9 7f f8 ff ff       	jmp    801058ca <alltraps>

8010604b <vector68>:
.globl vector68
vector68:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $68
8010604d:	6a 44                	push   $0x44
  jmp alltraps
8010604f:	e9 76 f8 ff ff       	jmp    801058ca <alltraps>

80106054 <vector69>:
.globl vector69
vector69:
  pushl $0
80106054:	6a 00                	push   $0x0
  pushl $69
80106056:	6a 45                	push   $0x45
  jmp alltraps
80106058:	e9 6d f8 ff ff       	jmp    801058ca <alltraps>

8010605d <vector70>:
.globl vector70
vector70:
  pushl $0
8010605d:	6a 00                	push   $0x0
  pushl $70
8010605f:	6a 46                	push   $0x46
  jmp alltraps
80106061:	e9 64 f8 ff ff       	jmp    801058ca <alltraps>

80106066 <vector71>:
.globl vector71
vector71:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $71
80106068:	6a 47                	push   $0x47
  jmp alltraps
8010606a:	e9 5b f8 ff ff       	jmp    801058ca <alltraps>

8010606f <vector72>:
.globl vector72
vector72:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $72
80106071:	6a 48                	push   $0x48
  jmp alltraps
80106073:	e9 52 f8 ff ff       	jmp    801058ca <alltraps>

80106078 <vector73>:
.globl vector73
vector73:
  pushl $0
80106078:	6a 00                	push   $0x0
  pushl $73
8010607a:	6a 49                	push   $0x49
  jmp alltraps
8010607c:	e9 49 f8 ff ff       	jmp    801058ca <alltraps>

80106081 <vector74>:
.globl vector74
vector74:
  pushl $0
80106081:	6a 00                	push   $0x0
  pushl $74
80106083:	6a 4a                	push   $0x4a
  jmp alltraps
80106085:	e9 40 f8 ff ff       	jmp    801058ca <alltraps>

8010608a <vector75>:
.globl vector75
vector75:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $75
8010608c:	6a 4b                	push   $0x4b
  jmp alltraps
8010608e:	e9 37 f8 ff ff       	jmp    801058ca <alltraps>

80106093 <vector76>:
.globl vector76
vector76:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $76
80106095:	6a 4c                	push   $0x4c
  jmp alltraps
80106097:	e9 2e f8 ff ff       	jmp    801058ca <alltraps>

8010609c <vector77>:
.globl vector77
vector77:
  pushl $0
8010609c:	6a 00                	push   $0x0
  pushl $77
8010609e:	6a 4d                	push   $0x4d
  jmp alltraps
801060a0:	e9 25 f8 ff ff       	jmp    801058ca <alltraps>

801060a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801060a5:	6a 00                	push   $0x0
  pushl $78
801060a7:	6a 4e                	push   $0x4e
  jmp alltraps
801060a9:	e9 1c f8 ff ff       	jmp    801058ca <alltraps>

801060ae <vector79>:
.globl vector79
vector79:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $79
801060b0:	6a 4f                	push   $0x4f
  jmp alltraps
801060b2:	e9 13 f8 ff ff       	jmp    801058ca <alltraps>

801060b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $80
801060b9:	6a 50                	push   $0x50
  jmp alltraps
801060bb:	e9 0a f8 ff ff       	jmp    801058ca <alltraps>

801060c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801060c0:	6a 00                	push   $0x0
  pushl $81
801060c2:	6a 51                	push   $0x51
  jmp alltraps
801060c4:	e9 01 f8 ff ff       	jmp    801058ca <alltraps>

801060c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $82
801060cb:	6a 52                	push   $0x52
  jmp alltraps
801060cd:	e9 f8 f7 ff ff       	jmp    801058ca <alltraps>

801060d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $83
801060d4:	6a 53                	push   $0x53
  jmp alltraps
801060d6:	e9 ef f7 ff ff       	jmp    801058ca <alltraps>

801060db <vector84>:
.globl vector84
vector84:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $84
801060dd:	6a 54                	push   $0x54
  jmp alltraps
801060df:	e9 e6 f7 ff ff       	jmp    801058ca <alltraps>

801060e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $85
801060e6:	6a 55                	push   $0x55
  jmp alltraps
801060e8:	e9 dd f7 ff ff       	jmp    801058ca <alltraps>

801060ed <vector86>:
.globl vector86
vector86:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $86
801060ef:	6a 56                	push   $0x56
  jmp alltraps
801060f1:	e9 d4 f7 ff ff       	jmp    801058ca <alltraps>

801060f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $87
801060f8:	6a 57                	push   $0x57
  jmp alltraps
801060fa:	e9 cb f7 ff ff       	jmp    801058ca <alltraps>

801060ff <vector88>:
.globl vector88
vector88:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $88
80106101:	6a 58                	push   $0x58
  jmp alltraps
80106103:	e9 c2 f7 ff ff       	jmp    801058ca <alltraps>

80106108 <vector89>:
.globl vector89
vector89:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $89
8010610a:	6a 59                	push   $0x59
  jmp alltraps
8010610c:	e9 b9 f7 ff ff       	jmp    801058ca <alltraps>

80106111 <vector90>:
.globl vector90
vector90:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $90
80106113:	6a 5a                	push   $0x5a
  jmp alltraps
80106115:	e9 b0 f7 ff ff       	jmp    801058ca <alltraps>

8010611a <vector91>:
.globl vector91
vector91:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $91
8010611c:	6a 5b                	push   $0x5b
  jmp alltraps
8010611e:	e9 a7 f7 ff ff       	jmp    801058ca <alltraps>

80106123 <vector92>:
.globl vector92
vector92:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $92
80106125:	6a 5c                	push   $0x5c
  jmp alltraps
80106127:	e9 9e f7 ff ff       	jmp    801058ca <alltraps>

8010612c <vector93>:
.globl vector93
vector93:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $93
8010612e:	6a 5d                	push   $0x5d
  jmp alltraps
80106130:	e9 95 f7 ff ff       	jmp    801058ca <alltraps>

80106135 <vector94>:
.globl vector94
vector94:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $94
80106137:	6a 5e                	push   $0x5e
  jmp alltraps
80106139:	e9 8c f7 ff ff       	jmp    801058ca <alltraps>

8010613e <vector95>:
.globl vector95
vector95:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $95
80106140:	6a 5f                	push   $0x5f
  jmp alltraps
80106142:	e9 83 f7 ff ff       	jmp    801058ca <alltraps>

80106147 <vector96>:
.globl vector96
vector96:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $96
80106149:	6a 60                	push   $0x60
  jmp alltraps
8010614b:	e9 7a f7 ff ff       	jmp    801058ca <alltraps>

80106150 <vector97>:
.globl vector97
vector97:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $97
80106152:	6a 61                	push   $0x61
  jmp alltraps
80106154:	e9 71 f7 ff ff       	jmp    801058ca <alltraps>

80106159 <vector98>:
.globl vector98
vector98:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $98
8010615b:	6a 62                	push   $0x62
  jmp alltraps
8010615d:	e9 68 f7 ff ff       	jmp    801058ca <alltraps>

80106162 <vector99>:
.globl vector99
vector99:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $99
80106164:	6a 63                	push   $0x63
  jmp alltraps
80106166:	e9 5f f7 ff ff       	jmp    801058ca <alltraps>

8010616b <vector100>:
.globl vector100
vector100:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $100
8010616d:	6a 64                	push   $0x64
  jmp alltraps
8010616f:	e9 56 f7 ff ff       	jmp    801058ca <alltraps>

80106174 <vector101>:
.globl vector101
vector101:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $101
80106176:	6a 65                	push   $0x65
  jmp alltraps
80106178:	e9 4d f7 ff ff       	jmp    801058ca <alltraps>

8010617d <vector102>:
.globl vector102
vector102:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $102
8010617f:	6a 66                	push   $0x66
  jmp alltraps
80106181:	e9 44 f7 ff ff       	jmp    801058ca <alltraps>

80106186 <vector103>:
.globl vector103
vector103:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $103
80106188:	6a 67                	push   $0x67
  jmp alltraps
8010618a:	e9 3b f7 ff ff       	jmp    801058ca <alltraps>

8010618f <vector104>:
.globl vector104
vector104:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $104
80106191:	6a 68                	push   $0x68
  jmp alltraps
80106193:	e9 32 f7 ff ff       	jmp    801058ca <alltraps>

80106198 <vector105>:
.globl vector105
vector105:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $105
8010619a:	6a 69                	push   $0x69
  jmp alltraps
8010619c:	e9 29 f7 ff ff       	jmp    801058ca <alltraps>

801061a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $106
801061a3:	6a 6a                	push   $0x6a
  jmp alltraps
801061a5:	e9 20 f7 ff ff       	jmp    801058ca <alltraps>

801061aa <vector107>:
.globl vector107
vector107:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $107
801061ac:	6a 6b                	push   $0x6b
  jmp alltraps
801061ae:	e9 17 f7 ff ff       	jmp    801058ca <alltraps>

801061b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $108
801061b5:	6a 6c                	push   $0x6c
  jmp alltraps
801061b7:	e9 0e f7 ff ff       	jmp    801058ca <alltraps>

801061bc <vector109>:
.globl vector109
vector109:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $109
801061be:	6a 6d                	push   $0x6d
  jmp alltraps
801061c0:	e9 05 f7 ff ff       	jmp    801058ca <alltraps>

801061c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $110
801061c7:	6a 6e                	push   $0x6e
  jmp alltraps
801061c9:	e9 fc f6 ff ff       	jmp    801058ca <alltraps>

801061ce <vector111>:
.globl vector111
vector111:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $111
801061d0:	6a 6f                	push   $0x6f
  jmp alltraps
801061d2:	e9 f3 f6 ff ff       	jmp    801058ca <alltraps>

801061d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $112
801061d9:	6a 70                	push   $0x70
  jmp alltraps
801061db:	e9 ea f6 ff ff       	jmp    801058ca <alltraps>

801061e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $113
801061e2:	6a 71                	push   $0x71
  jmp alltraps
801061e4:	e9 e1 f6 ff ff       	jmp    801058ca <alltraps>

801061e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $114
801061eb:	6a 72                	push   $0x72
  jmp alltraps
801061ed:	e9 d8 f6 ff ff       	jmp    801058ca <alltraps>

801061f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $115
801061f4:	6a 73                	push   $0x73
  jmp alltraps
801061f6:	e9 cf f6 ff ff       	jmp    801058ca <alltraps>

801061fb <vector116>:
.globl vector116
vector116:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $116
801061fd:	6a 74                	push   $0x74
  jmp alltraps
801061ff:	e9 c6 f6 ff ff       	jmp    801058ca <alltraps>

80106204 <vector117>:
.globl vector117
vector117:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $117
80106206:	6a 75                	push   $0x75
  jmp alltraps
80106208:	e9 bd f6 ff ff       	jmp    801058ca <alltraps>

8010620d <vector118>:
.globl vector118
vector118:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $118
8010620f:	6a 76                	push   $0x76
  jmp alltraps
80106211:	e9 b4 f6 ff ff       	jmp    801058ca <alltraps>

80106216 <vector119>:
.globl vector119
vector119:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $119
80106218:	6a 77                	push   $0x77
  jmp alltraps
8010621a:	e9 ab f6 ff ff       	jmp    801058ca <alltraps>

8010621f <vector120>:
.globl vector120
vector120:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $120
80106221:	6a 78                	push   $0x78
  jmp alltraps
80106223:	e9 a2 f6 ff ff       	jmp    801058ca <alltraps>

80106228 <vector121>:
.globl vector121
vector121:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $121
8010622a:	6a 79                	push   $0x79
  jmp alltraps
8010622c:	e9 99 f6 ff ff       	jmp    801058ca <alltraps>

80106231 <vector122>:
.globl vector122
vector122:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $122
80106233:	6a 7a                	push   $0x7a
  jmp alltraps
80106235:	e9 90 f6 ff ff       	jmp    801058ca <alltraps>

8010623a <vector123>:
.globl vector123
vector123:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $123
8010623c:	6a 7b                	push   $0x7b
  jmp alltraps
8010623e:	e9 87 f6 ff ff       	jmp    801058ca <alltraps>

80106243 <vector124>:
.globl vector124
vector124:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $124
80106245:	6a 7c                	push   $0x7c
  jmp alltraps
80106247:	e9 7e f6 ff ff       	jmp    801058ca <alltraps>

8010624c <vector125>:
.globl vector125
vector125:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $125
8010624e:	6a 7d                	push   $0x7d
  jmp alltraps
80106250:	e9 75 f6 ff ff       	jmp    801058ca <alltraps>

80106255 <vector126>:
.globl vector126
vector126:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $126
80106257:	6a 7e                	push   $0x7e
  jmp alltraps
80106259:	e9 6c f6 ff ff       	jmp    801058ca <alltraps>

8010625e <vector127>:
.globl vector127
vector127:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $127
80106260:	6a 7f                	push   $0x7f
  jmp alltraps
80106262:	e9 63 f6 ff ff       	jmp    801058ca <alltraps>

80106267 <vector128>:
.globl vector128
vector128:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $128
80106269:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010626e:	e9 57 f6 ff ff       	jmp    801058ca <alltraps>

80106273 <vector129>:
.globl vector129
vector129:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $129
80106275:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010627a:	e9 4b f6 ff ff       	jmp    801058ca <alltraps>

8010627f <vector130>:
.globl vector130
vector130:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $130
80106281:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106286:	e9 3f f6 ff ff       	jmp    801058ca <alltraps>

8010628b <vector131>:
.globl vector131
vector131:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $131
8010628d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106292:	e9 33 f6 ff ff       	jmp    801058ca <alltraps>

80106297 <vector132>:
.globl vector132
vector132:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $132
80106299:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010629e:	e9 27 f6 ff ff       	jmp    801058ca <alltraps>

801062a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $133
801062a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062aa:	e9 1b f6 ff ff       	jmp    801058ca <alltraps>

801062af <vector134>:
.globl vector134
vector134:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $134
801062b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062b6:	e9 0f f6 ff ff       	jmp    801058ca <alltraps>

801062bb <vector135>:
.globl vector135
vector135:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $135
801062bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062c2:	e9 03 f6 ff ff       	jmp    801058ca <alltraps>

801062c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $136
801062c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801062ce:	e9 f7 f5 ff ff       	jmp    801058ca <alltraps>

801062d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $137
801062d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062da:	e9 eb f5 ff ff       	jmp    801058ca <alltraps>

801062df <vector138>:
.globl vector138
vector138:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $138
801062e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801062e6:	e9 df f5 ff ff       	jmp    801058ca <alltraps>

801062eb <vector139>:
.globl vector139
vector139:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $139
801062ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062f2:	e9 d3 f5 ff ff       	jmp    801058ca <alltraps>

801062f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $140
801062f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062fe:	e9 c7 f5 ff ff       	jmp    801058ca <alltraps>

80106303 <vector141>:
.globl vector141
vector141:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $141
80106305:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010630a:	e9 bb f5 ff ff       	jmp    801058ca <alltraps>

8010630f <vector142>:
.globl vector142
vector142:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $142
80106311:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106316:	e9 af f5 ff ff       	jmp    801058ca <alltraps>

8010631b <vector143>:
.globl vector143
vector143:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $143
8010631d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106322:	e9 a3 f5 ff ff       	jmp    801058ca <alltraps>

80106327 <vector144>:
.globl vector144
vector144:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $144
80106329:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010632e:	e9 97 f5 ff ff       	jmp    801058ca <alltraps>

80106333 <vector145>:
.globl vector145
vector145:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $145
80106335:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010633a:	e9 8b f5 ff ff       	jmp    801058ca <alltraps>

8010633f <vector146>:
.globl vector146
vector146:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $146
80106341:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106346:	e9 7f f5 ff ff       	jmp    801058ca <alltraps>

8010634b <vector147>:
.globl vector147
vector147:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $147
8010634d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106352:	e9 73 f5 ff ff       	jmp    801058ca <alltraps>

80106357 <vector148>:
.globl vector148
vector148:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $148
80106359:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010635e:	e9 67 f5 ff ff       	jmp    801058ca <alltraps>

80106363 <vector149>:
.globl vector149
vector149:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $149
80106365:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010636a:	e9 5b f5 ff ff       	jmp    801058ca <alltraps>

8010636f <vector150>:
.globl vector150
vector150:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $150
80106371:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106376:	e9 4f f5 ff ff       	jmp    801058ca <alltraps>

8010637b <vector151>:
.globl vector151
vector151:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $151
8010637d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106382:	e9 43 f5 ff ff       	jmp    801058ca <alltraps>

80106387 <vector152>:
.globl vector152
vector152:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $152
80106389:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010638e:	e9 37 f5 ff ff       	jmp    801058ca <alltraps>

80106393 <vector153>:
.globl vector153
vector153:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $153
80106395:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010639a:	e9 2b f5 ff ff       	jmp    801058ca <alltraps>

8010639f <vector154>:
.globl vector154
vector154:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $154
801063a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063a6:	e9 1f f5 ff ff       	jmp    801058ca <alltraps>

801063ab <vector155>:
.globl vector155
vector155:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $155
801063ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063b2:	e9 13 f5 ff ff       	jmp    801058ca <alltraps>

801063b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $156
801063b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063be:	e9 07 f5 ff ff       	jmp    801058ca <alltraps>

801063c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $157
801063c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063ca:	e9 fb f4 ff ff       	jmp    801058ca <alltraps>

801063cf <vector158>:
.globl vector158
vector158:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $158
801063d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063d6:	e9 ef f4 ff ff       	jmp    801058ca <alltraps>

801063db <vector159>:
.globl vector159
vector159:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $159
801063dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801063e2:	e9 e3 f4 ff ff       	jmp    801058ca <alltraps>

801063e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $160
801063e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801063ee:	e9 d7 f4 ff ff       	jmp    801058ca <alltraps>

801063f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $161
801063f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063fa:	e9 cb f4 ff ff       	jmp    801058ca <alltraps>

801063ff <vector162>:
.globl vector162
vector162:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $162
80106401:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106406:	e9 bf f4 ff ff       	jmp    801058ca <alltraps>

8010640b <vector163>:
.globl vector163
vector163:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $163
8010640d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106412:	e9 b3 f4 ff ff       	jmp    801058ca <alltraps>

80106417 <vector164>:
.globl vector164
vector164:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $164
80106419:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010641e:	e9 a7 f4 ff ff       	jmp    801058ca <alltraps>

80106423 <vector165>:
.globl vector165
vector165:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $165
80106425:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010642a:	e9 9b f4 ff ff       	jmp    801058ca <alltraps>

8010642f <vector166>:
.globl vector166
vector166:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $166
80106431:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106436:	e9 8f f4 ff ff       	jmp    801058ca <alltraps>

8010643b <vector167>:
.globl vector167
vector167:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $167
8010643d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106442:	e9 83 f4 ff ff       	jmp    801058ca <alltraps>

80106447 <vector168>:
.globl vector168
vector168:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $168
80106449:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010644e:	e9 77 f4 ff ff       	jmp    801058ca <alltraps>

80106453 <vector169>:
.globl vector169
vector169:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $169
80106455:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010645a:	e9 6b f4 ff ff       	jmp    801058ca <alltraps>

8010645f <vector170>:
.globl vector170
vector170:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $170
80106461:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106466:	e9 5f f4 ff ff       	jmp    801058ca <alltraps>

8010646b <vector171>:
.globl vector171
vector171:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $171
8010646d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106472:	e9 53 f4 ff ff       	jmp    801058ca <alltraps>

80106477 <vector172>:
.globl vector172
vector172:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $172
80106479:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010647e:	e9 47 f4 ff ff       	jmp    801058ca <alltraps>

80106483 <vector173>:
.globl vector173
vector173:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $173
80106485:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010648a:	e9 3b f4 ff ff       	jmp    801058ca <alltraps>

8010648f <vector174>:
.globl vector174
vector174:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $174
80106491:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106496:	e9 2f f4 ff ff       	jmp    801058ca <alltraps>

8010649b <vector175>:
.globl vector175
vector175:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $175
8010649d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064a2:	e9 23 f4 ff ff       	jmp    801058ca <alltraps>

801064a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $176
801064a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064ae:	e9 17 f4 ff ff       	jmp    801058ca <alltraps>

801064b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $177
801064b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064ba:	e9 0b f4 ff ff       	jmp    801058ca <alltraps>

801064bf <vector178>:
.globl vector178
vector178:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $178
801064c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064c6:	e9 ff f3 ff ff       	jmp    801058ca <alltraps>

801064cb <vector179>:
.globl vector179
vector179:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $179
801064cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064d2:	e9 f3 f3 ff ff       	jmp    801058ca <alltraps>

801064d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $180
801064d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064de:	e9 e7 f3 ff ff       	jmp    801058ca <alltraps>

801064e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $181
801064e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801064ea:	e9 db f3 ff ff       	jmp    801058ca <alltraps>

801064ef <vector182>:
.globl vector182
vector182:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $182
801064f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064f6:	e9 cf f3 ff ff       	jmp    801058ca <alltraps>

801064fb <vector183>:
.globl vector183
vector183:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $183
801064fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106502:	e9 c3 f3 ff ff       	jmp    801058ca <alltraps>

80106507 <vector184>:
.globl vector184
vector184:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $184
80106509:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010650e:	e9 b7 f3 ff ff       	jmp    801058ca <alltraps>

80106513 <vector185>:
.globl vector185
vector185:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $185
80106515:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010651a:	e9 ab f3 ff ff       	jmp    801058ca <alltraps>

8010651f <vector186>:
.globl vector186
vector186:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $186
80106521:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106526:	e9 9f f3 ff ff       	jmp    801058ca <alltraps>

8010652b <vector187>:
.globl vector187
vector187:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $187
8010652d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106532:	e9 93 f3 ff ff       	jmp    801058ca <alltraps>

80106537 <vector188>:
.globl vector188
vector188:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $188
80106539:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010653e:	e9 87 f3 ff ff       	jmp    801058ca <alltraps>

80106543 <vector189>:
.globl vector189
vector189:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $189
80106545:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010654a:	e9 7b f3 ff ff       	jmp    801058ca <alltraps>

8010654f <vector190>:
.globl vector190
vector190:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $190
80106551:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106556:	e9 6f f3 ff ff       	jmp    801058ca <alltraps>

8010655b <vector191>:
.globl vector191
vector191:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $191
8010655d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106562:	e9 63 f3 ff ff       	jmp    801058ca <alltraps>

80106567 <vector192>:
.globl vector192
vector192:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $192
80106569:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010656e:	e9 57 f3 ff ff       	jmp    801058ca <alltraps>

80106573 <vector193>:
.globl vector193
vector193:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $193
80106575:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010657a:	e9 4b f3 ff ff       	jmp    801058ca <alltraps>

8010657f <vector194>:
.globl vector194
vector194:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $194
80106581:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106586:	e9 3f f3 ff ff       	jmp    801058ca <alltraps>

8010658b <vector195>:
.globl vector195
vector195:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $195
8010658d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106592:	e9 33 f3 ff ff       	jmp    801058ca <alltraps>

80106597 <vector196>:
.globl vector196
vector196:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $196
80106599:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010659e:	e9 27 f3 ff ff       	jmp    801058ca <alltraps>

801065a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $197
801065a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065aa:	e9 1b f3 ff ff       	jmp    801058ca <alltraps>

801065af <vector198>:
.globl vector198
vector198:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $198
801065b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065b6:	e9 0f f3 ff ff       	jmp    801058ca <alltraps>

801065bb <vector199>:
.globl vector199
vector199:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $199
801065bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065c2:	e9 03 f3 ff ff       	jmp    801058ca <alltraps>

801065c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $200
801065c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801065ce:	e9 f7 f2 ff ff       	jmp    801058ca <alltraps>

801065d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $201
801065d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065da:	e9 eb f2 ff ff       	jmp    801058ca <alltraps>

801065df <vector202>:
.globl vector202
vector202:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $202
801065e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801065e6:	e9 df f2 ff ff       	jmp    801058ca <alltraps>

801065eb <vector203>:
.globl vector203
vector203:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $203
801065ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065f2:	e9 d3 f2 ff ff       	jmp    801058ca <alltraps>

801065f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $204
801065f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065fe:	e9 c7 f2 ff ff       	jmp    801058ca <alltraps>

80106603 <vector205>:
.globl vector205
vector205:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $205
80106605:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010660a:	e9 bb f2 ff ff       	jmp    801058ca <alltraps>

8010660f <vector206>:
.globl vector206
vector206:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $206
80106611:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106616:	e9 af f2 ff ff       	jmp    801058ca <alltraps>

8010661b <vector207>:
.globl vector207
vector207:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $207
8010661d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106622:	e9 a3 f2 ff ff       	jmp    801058ca <alltraps>

80106627 <vector208>:
.globl vector208
vector208:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $208
80106629:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010662e:	e9 97 f2 ff ff       	jmp    801058ca <alltraps>

80106633 <vector209>:
.globl vector209
vector209:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $209
80106635:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010663a:	e9 8b f2 ff ff       	jmp    801058ca <alltraps>

8010663f <vector210>:
.globl vector210
vector210:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $210
80106641:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106646:	e9 7f f2 ff ff       	jmp    801058ca <alltraps>

8010664b <vector211>:
.globl vector211
vector211:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $211
8010664d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106652:	e9 73 f2 ff ff       	jmp    801058ca <alltraps>

80106657 <vector212>:
.globl vector212
vector212:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $212
80106659:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010665e:	e9 67 f2 ff ff       	jmp    801058ca <alltraps>

80106663 <vector213>:
.globl vector213
vector213:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $213
80106665:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010666a:	e9 5b f2 ff ff       	jmp    801058ca <alltraps>

8010666f <vector214>:
.globl vector214
vector214:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $214
80106671:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106676:	e9 4f f2 ff ff       	jmp    801058ca <alltraps>

8010667b <vector215>:
.globl vector215
vector215:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $215
8010667d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106682:	e9 43 f2 ff ff       	jmp    801058ca <alltraps>

80106687 <vector216>:
.globl vector216
vector216:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $216
80106689:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010668e:	e9 37 f2 ff ff       	jmp    801058ca <alltraps>

80106693 <vector217>:
.globl vector217
vector217:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $217
80106695:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010669a:	e9 2b f2 ff ff       	jmp    801058ca <alltraps>

8010669f <vector218>:
.globl vector218
vector218:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $218
801066a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066a6:	e9 1f f2 ff ff       	jmp    801058ca <alltraps>

801066ab <vector219>:
.globl vector219
vector219:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $219
801066ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066b2:	e9 13 f2 ff ff       	jmp    801058ca <alltraps>

801066b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $220
801066b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066be:	e9 07 f2 ff ff       	jmp    801058ca <alltraps>

801066c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $221
801066c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066ca:	e9 fb f1 ff ff       	jmp    801058ca <alltraps>

801066cf <vector222>:
.globl vector222
vector222:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $222
801066d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066d6:	e9 ef f1 ff ff       	jmp    801058ca <alltraps>

801066db <vector223>:
.globl vector223
vector223:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $223
801066dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801066e2:	e9 e3 f1 ff ff       	jmp    801058ca <alltraps>

801066e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $224
801066e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801066ee:	e9 d7 f1 ff ff       	jmp    801058ca <alltraps>

801066f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $225
801066f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066fa:	e9 cb f1 ff ff       	jmp    801058ca <alltraps>

801066ff <vector226>:
.globl vector226
vector226:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $226
80106701:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106706:	e9 bf f1 ff ff       	jmp    801058ca <alltraps>

8010670b <vector227>:
.globl vector227
vector227:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $227
8010670d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106712:	e9 b3 f1 ff ff       	jmp    801058ca <alltraps>

80106717 <vector228>:
.globl vector228
vector228:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $228
80106719:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010671e:	e9 a7 f1 ff ff       	jmp    801058ca <alltraps>

80106723 <vector229>:
.globl vector229
vector229:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $229
80106725:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010672a:	e9 9b f1 ff ff       	jmp    801058ca <alltraps>

8010672f <vector230>:
.globl vector230
vector230:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $230
80106731:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106736:	e9 8f f1 ff ff       	jmp    801058ca <alltraps>

8010673b <vector231>:
.globl vector231
vector231:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $231
8010673d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106742:	e9 83 f1 ff ff       	jmp    801058ca <alltraps>

80106747 <vector232>:
.globl vector232
vector232:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $232
80106749:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010674e:	e9 77 f1 ff ff       	jmp    801058ca <alltraps>

80106753 <vector233>:
.globl vector233
vector233:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $233
80106755:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010675a:	e9 6b f1 ff ff       	jmp    801058ca <alltraps>

8010675f <vector234>:
.globl vector234
vector234:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $234
80106761:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106766:	e9 5f f1 ff ff       	jmp    801058ca <alltraps>

8010676b <vector235>:
.globl vector235
vector235:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $235
8010676d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106772:	e9 53 f1 ff ff       	jmp    801058ca <alltraps>

80106777 <vector236>:
.globl vector236
vector236:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $236
80106779:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010677e:	e9 47 f1 ff ff       	jmp    801058ca <alltraps>

80106783 <vector237>:
.globl vector237
vector237:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $237
80106785:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010678a:	e9 3b f1 ff ff       	jmp    801058ca <alltraps>

8010678f <vector238>:
.globl vector238
vector238:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $238
80106791:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106796:	e9 2f f1 ff ff       	jmp    801058ca <alltraps>

8010679b <vector239>:
.globl vector239
vector239:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $239
8010679d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067a2:	e9 23 f1 ff ff       	jmp    801058ca <alltraps>

801067a7 <vector240>:
.globl vector240
vector240:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $240
801067a9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067ae:	e9 17 f1 ff ff       	jmp    801058ca <alltraps>

801067b3 <vector241>:
.globl vector241
vector241:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $241
801067b5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067ba:	e9 0b f1 ff ff       	jmp    801058ca <alltraps>

801067bf <vector242>:
.globl vector242
vector242:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $242
801067c1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067c6:	e9 ff f0 ff ff       	jmp    801058ca <alltraps>

801067cb <vector243>:
.globl vector243
vector243:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $243
801067cd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067d2:	e9 f3 f0 ff ff       	jmp    801058ca <alltraps>

801067d7 <vector244>:
.globl vector244
vector244:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $244
801067d9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067de:	e9 e7 f0 ff ff       	jmp    801058ca <alltraps>

801067e3 <vector245>:
.globl vector245
vector245:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $245
801067e5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801067ea:	e9 db f0 ff ff       	jmp    801058ca <alltraps>

801067ef <vector246>:
.globl vector246
vector246:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $246
801067f1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067f6:	e9 cf f0 ff ff       	jmp    801058ca <alltraps>

801067fb <vector247>:
.globl vector247
vector247:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $247
801067fd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106802:	e9 c3 f0 ff ff       	jmp    801058ca <alltraps>

80106807 <vector248>:
.globl vector248
vector248:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $248
80106809:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010680e:	e9 b7 f0 ff ff       	jmp    801058ca <alltraps>

80106813 <vector249>:
.globl vector249
vector249:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $249
80106815:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010681a:	e9 ab f0 ff ff       	jmp    801058ca <alltraps>

8010681f <vector250>:
.globl vector250
vector250:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $250
80106821:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106826:	e9 9f f0 ff ff       	jmp    801058ca <alltraps>

8010682b <vector251>:
.globl vector251
vector251:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $251
8010682d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106832:	e9 93 f0 ff ff       	jmp    801058ca <alltraps>

80106837 <vector252>:
.globl vector252
vector252:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $252
80106839:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010683e:	e9 87 f0 ff ff       	jmp    801058ca <alltraps>

80106843 <vector253>:
.globl vector253
vector253:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $253
80106845:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010684a:	e9 7b f0 ff ff       	jmp    801058ca <alltraps>

8010684f <vector254>:
.globl vector254
vector254:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $254
80106851:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106856:	e9 6f f0 ff ff       	jmp    801058ca <alltraps>

8010685b <vector255>:
.globl vector255
vector255:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $255
8010685d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106862:	e9 63 f0 ff ff       	jmp    801058ca <alltraps>
80106867:	66 90                	xchg   %ax,%ax
80106869:	66 90                	xchg   %ax,%ax
8010686b:	66 90                	xchg   %ax,%ax
8010686d:	66 90                	xchg   %ax,%ax
8010686f:	90                   	nop

80106870 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	57                   	push   %edi
80106874:	56                   	push   %esi
80106875:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106876:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010687c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106882:	83 ec 1c             	sub    $0x1c,%esp
80106885:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106888:	39 d3                	cmp    %edx,%ebx
8010688a:	73 49                	jae    801068d5 <deallocuvm.part.0+0x65>
8010688c:	89 c7                	mov    %eax,%edi
8010688e:	eb 0c                	jmp    8010689c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106890:	83 c0 01             	add    $0x1,%eax
80106893:	c1 e0 16             	shl    $0x16,%eax
80106896:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106898:	39 da                	cmp    %ebx,%edx
8010689a:	76 39                	jbe    801068d5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010689c:	89 d8                	mov    %ebx,%eax
8010689e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801068a1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801068a4:	f6 c1 01             	test   $0x1,%cl
801068a7:	74 e7                	je     80106890 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801068a9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068ab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801068b1:	c1 ee 0a             	shr    $0xa,%esi
801068b4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801068ba:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801068c1:	85 f6                	test   %esi,%esi
801068c3:	74 cb                	je     80106890 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801068c5:	8b 06                	mov    (%esi),%eax
801068c7:	a8 01                	test   $0x1,%al
801068c9:	75 15                	jne    801068e0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801068cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068d1:	39 da                	cmp    %ebx,%edx
801068d3:	77 c7                	ja     8010689c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801068d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068db:	5b                   	pop    %ebx
801068dc:	5e                   	pop    %esi
801068dd:	5f                   	pop    %edi
801068de:	5d                   	pop    %ebp
801068df:	c3                   	ret    
      if(pa == 0)
801068e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068e5:	74 25                	je     8010690c <deallocuvm.part.0+0x9c>
      kfree(v);
801068e7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801068ea:	05 00 00 00 80       	add    $0x80000000,%eax
801068ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801068f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801068f8:	50                   	push   %eax
801068f9:	e8 c2 bb ff ff       	call   801024c0 <kfree>
      *pte = 0;
801068fe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106904:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106907:	83 c4 10             	add    $0x10,%esp
8010690a:	eb 8c                	jmp    80106898 <deallocuvm.part.0+0x28>
        panic("kfree");
8010690c:	83 ec 0c             	sub    $0xc,%esp
8010690f:	68 96 88 10 80       	push   $0x80108896
80106914:	e8 67 9a ff ff       	call   80100380 <panic>
80106919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106920 <seginit>:
{
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106926:	e8 35 d0 ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
8010692b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106930:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106936:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010693a:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80106941:	ff 00 00 
80106944:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
8010694b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010694e:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80106955:	ff 00 00 
80106958:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
8010695f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106962:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80106969:	ff 00 00 
8010696c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80106973:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106976:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
8010697d:	ff 00 00 
80106980:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80106987:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010698a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
8010698f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106993:	c1 e8 10             	shr    $0x10,%eax
80106996:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010699a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010699d:	0f 01 10             	lgdtl  (%eax)
}
801069a0:	c9                   	leave  
801069a1:	c3                   	ret    
801069a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069b0 <walkpgdir>:
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
801069b6:	83 ec 0c             	sub    $0xc,%esp
801069b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
801069bc:	8b 55 08             	mov    0x8(%ebp),%edx
801069bf:	89 fe                	mov    %edi,%esi
801069c1:	c1 ee 16             	shr    $0x16,%esi
801069c4:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
801069c7:	8b 1e                	mov    (%esi),%ebx
801069c9:	f6 c3 01             	test   $0x1,%bl
801069cc:	74 22                	je     801069f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801069d4:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
801069da:	89 f8                	mov    %edi,%eax
}
801069dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801069df:	c1 e8 0a             	shr    $0xa,%eax
801069e2:	25 fc 0f 00 00       	and    $0xffc,%eax
801069e7:	01 d8                	add    %ebx,%eax
}
801069e9:	5b                   	pop    %ebx
801069ea:	5e                   	pop    %esi
801069eb:	5f                   	pop    %edi
801069ec:	5d                   	pop    %ebp
801069ed:	c3                   	ret    
801069ee:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801069f0:	8b 45 10             	mov    0x10(%ebp),%eax
801069f3:	85 c0                	test   %eax,%eax
801069f5:	74 31                	je     80106a28 <walkpgdir+0x78>
801069f7:	e8 84 bc ff ff       	call   80102680 <kalloc>
801069fc:	89 c3                	mov    %eax,%ebx
801069fe:	85 c0                	test   %eax,%eax
80106a00:	74 26                	je     80106a28 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80106a02:	83 ec 04             	sub    $0x4,%esp
80106a05:	68 00 10 00 00       	push   $0x1000
80106a0a:	6a 00                	push   $0x0
80106a0c:	50                   	push   %eax
80106a0d:	e8 7e dc ff ff       	call   80104690 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a12:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a18:	83 c4 10             	add    $0x10,%esp
80106a1b:	83 c8 07             	or     $0x7,%eax
80106a1e:	89 06                	mov    %eax,(%esi)
80106a20:	eb b8                	jmp    801069da <walkpgdir+0x2a>
80106a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106a2b:	31 c0                	xor    %eax,%eax
}
80106a2d:	5b                   	pop    %ebx
80106a2e:	5e                   	pop    %esi
80106a2f:	5f                   	pop    %edi
80106a30:	5d                   	pop    %ebp
80106a31:	c3                   	ret    
80106a32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a40 <mappages>:
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
80106a46:	83 ec 1c             	sub    $0x1c,%esp
80106a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a4c:	8b 55 10             	mov    0x10(%ebp),%edx
  a = (char*)PGROUNDDOWN((uint)va);
80106a4f:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a51:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106a55:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106a5a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a60:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a63:	8b 45 14             	mov    0x14(%ebp),%eax
80106a66:	29 d8                	sub    %ebx,%eax
80106a68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a6b:	eb 3a                	jmp    80106aa7 <mappages+0x67>
80106a6d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106a70:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a77:	c1 ea 0a             	shr    $0xa,%edx
80106a7a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106a80:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a87:	85 c0                	test   %eax,%eax
80106a89:	74 75                	je     80106b00 <mappages+0xc0>
    if(*pte & PTE_P)
80106a8b:	f6 00 01             	testb  $0x1,(%eax)
80106a8e:	0f 85 86 00 00 00    	jne    80106b1a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106a94:	0b 75 18             	or     0x18(%ebp),%esi
80106a97:	83 ce 01             	or     $0x1,%esi
80106a9a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106a9c:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80106a9f:	74 6f                	je     80106b10 <mappages+0xd0>
    a += PGSIZE;
80106aa1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106aa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106aaa:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106aad:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106ab0:	89 d8                	mov    %ebx,%eax
80106ab2:	c1 e8 16             	shr    $0x16,%eax
80106ab5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106ab8:	8b 07                	mov    (%edi),%eax
80106aba:	a8 01                	test   $0x1,%al
80106abc:	75 b2                	jne    80106a70 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106abe:	e8 bd bb ff ff       	call   80102680 <kalloc>
80106ac3:	85 c0                	test   %eax,%eax
80106ac5:	74 39                	je     80106b00 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106ac7:	83 ec 04             	sub    $0x4,%esp
80106aca:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106acd:	68 00 10 00 00       	push   $0x1000
80106ad2:	6a 00                	push   $0x0
80106ad4:	50                   	push   %eax
80106ad5:	e8 b6 db ff ff       	call   80104690 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ada:	8b 55 dc             	mov    -0x24(%ebp),%edx
  return &pgtab[PTX(va)];
80106add:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ae0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ae6:	83 c8 07             	or     $0x7,%eax
80106ae9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106aeb:	89 d8                	mov    %ebx,%eax
80106aed:	c1 e8 0a             	shr    $0xa,%eax
80106af0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106af5:	01 d0                	add    %edx,%eax
80106af7:	eb 92                	jmp    80106a8b <mappages+0x4b>
80106af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b08:	5b                   	pop    %ebx
80106b09:	5e                   	pop    %esi
80106b0a:	5f                   	pop    %edi
80106b0b:	5d                   	pop    %ebp
80106b0c:	c3                   	ret    
80106b0d:	8d 76 00             	lea    0x0(%esi),%esi
80106b10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b13:	31 c0                	xor    %eax,%eax
}
80106b15:	5b                   	pop    %ebx
80106b16:	5e                   	pop    %esi
80106b17:	5f                   	pop    %edi
80106b18:	5d                   	pop    %ebp
80106b19:	c3                   	ret    
      panic("remap");
80106b1a:	83 ec 0c             	sub    $0xc,%esp
80106b1d:	68 58 8f 10 80       	push   $0x80108f58
80106b22:	e8 59 98 ff ff       	call   80100380 <panic>
80106b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b2e:	66 90                	xchg   %ax,%ax

80106b30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b30:	a1 c4 e6 11 80       	mov    0x8011e6c4,%eax
80106b35:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b3a:	0f 22 d8             	mov    %eax,%cr3
}
80106b3d:	c3                   	ret    
80106b3e:	66 90                	xchg   %ax,%ax

80106b40 <switchuvm>:
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	53                   	push   %ebx
80106b46:	83 ec 1c             	sub    $0x1c,%esp
80106b49:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b4c:	85 f6                	test   %esi,%esi
80106b4e:	0f 84 cb 00 00 00    	je     80106c1f <switchuvm+0xdf>
  if(p->kstack == 0)
80106b54:	8b 46 08             	mov    0x8(%esi),%eax
80106b57:	85 c0                	test   %eax,%eax
80106b59:	0f 84 da 00 00 00    	je     80106c39 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106b5f:	8b 46 04             	mov    0x4(%esi),%eax
80106b62:	85 c0                	test   %eax,%eax
80106b64:	0f 84 c2 00 00 00    	je     80106c2c <switchuvm+0xec>
  pushcli();
80106b6a:	e8 11 d9 ff ff       	call   80104480 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b6f:	e8 8c cd ff ff       	call   80103900 <mycpu>
80106b74:	89 c3                	mov    %eax,%ebx
80106b76:	e8 85 cd ff ff       	call   80103900 <mycpu>
80106b7b:	89 c7                	mov    %eax,%edi
80106b7d:	e8 7e cd ff ff       	call   80103900 <mycpu>
80106b82:	83 c7 08             	add    $0x8,%edi
80106b85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b88:	e8 73 cd ff ff       	call   80103900 <mycpu>
80106b8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b90:	ba 67 00 00 00       	mov    $0x67,%edx
80106b95:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b9c:	83 c0 08             	add    $0x8,%eax
80106b9f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ba6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106bab:	83 c1 08             	add    $0x8,%ecx
80106bae:	c1 e8 18             	shr    $0x18,%eax
80106bb1:	c1 e9 10             	shr    $0x10,%ecx
80106bb4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106bba:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106bc0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106bc5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bcc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106bd1:	e8 2a cd ff ff       	call   80103900 <mycpu>
80106bd6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106bdd:	e8 1e cd ff ff       	call   80103900 <mycpu>
80106be2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106be6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106be9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bef:	e8 0c cd ff ff       	call   80103900 <mycpu>
80106bf4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bf7:	e8 04 cd ff ff       	call   80103900 <mycpu>
80106bfc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106c00:	b8 28 00 00 00       	mov    $0x28,%eax
80106c05:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106c08:	8b 46 04             	mov    0x4(%esi),%eax
80106c0b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c10:	0f 22 d8             	mov    %eax,%cr3
}
80106c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c16:	5b                   	pop    %ebx
80106c17:	5e                   	pop    %esi
80106c18:	5f                   	pop    %edi
80106c19:	5d                   	pop    %ebp
  popcli();
80106c1a:	e9 b1 d8 ff ff       	jmp    801044d0 <popcli>
    panic("switchuvm: no process");
80106c1f:	83 ec 0c             	sub    $0xc,%esp
80106c22:	68 5e 8f 10 80       	push   $0x80108f5e
80106c27:	e8 54 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106c2c:	83 ec 0c             	sub    $0xc,%esp
80106c2f:	68 89 8f 10 80       	push   $0x80108f89
80106c34:	e8 47 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106c39:	83 ec 0c             	sub    $0xc,%esp
80106c3c:	68 74 8f 10 80       	push   $0x80108f74
80106c41:	e8 3a 97 ff ff       	call   80100380 <panic>
80106c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c4d:	8d 76 00             	lea    0x0(%esi),%esi

80106c50 <inituvm>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 1c             	sub    $0x1c,%esp
80106c59:	8b 75 10             	mov    0x10(%ebp),%esi
80106c5c:	8b 55 08             	mov    0x8(%ebp),%edx
80106c5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106c62:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c68:	77 50                	ja     80106cba <inituvm+0x6a>
80106c6a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  mem = kalloc();
80106c6d:	e8 0e ba ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80106c72:	83 ec 04             	sub    $0x4,%esp
80106c75:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106c7a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c7c:	6a 00                	push   $0x0
80106c7e:	50                   	push   %eax
80106c7f:	e8 0c da ff ff       	call   80104690 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c87:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c8d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106c94:	50                   	push   %eax
80106c95:	68 00 10 00 00       	push   $0x1000
80106c9a:	6a 00                	push   $0x0
80106c9c:	52                   	push   %edx
80106c9d:	e8 9e fd ff ff       	call   80106a40 <mappages>
  memmove(mem, init, sz);
80106ca2:	89 75 10             	mov    %esi,0x10(%ebp)
80106ca5:	83 c4 20             	add    $0x20,%esp
80106ca8:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106cab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cb1:	5b                   	pop    %ebx
80106cb2:	5e                   	pop    %esi
80106cb3:	5f                   	pop    %edi
80106cb4:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106cb5:	e9 76 da ff ff       	jmp    80104730 <memmove>
    panic("inituvm: more than a page");
80106cba:	83 ec 0c             	sub    $0xc,%esp
80106cbd:	68 9d 8f 10 80       	push   $0x80108f9d
80106cc2:	e8 b9 96 ff ff       	call   80100380 <panic>
80106cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cce:	66 90                	xchg   %ax,%ax

80106cd0 <loaduvm>:
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
80106cd6:	83 ec 1c             	sub    $0x1c,%esp
80106cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cdc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106cdf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ce4:	0f 85 bb 00 00 00    	jne    80106da5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106cea:	01 f0                	add    %esi,%eax
80106cec:	89 f3                	mov    %esi,%ebx
80106cee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cf1:	8b 45 14             	mov    0x14(%ebp),%eax
80106cf4:	01 f0                	add    %esi,%eax
80106cf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106cf9:	85 f6                	test   %esi,%esi
80106cfb:	0f 84 87 00 00 00    	je     80106d88 <loaduvm+0xb8>
80106d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106d08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106d0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106d0e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106d10:	89 c2                	mov    %eax,%edx
80106d12:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106d15:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106d18:	f6 c2 01             	test   $0x1,%dl
80106d1b:	75 13                	jne    80106d30 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106d1d:	83 ec 0c             	sub    $0xc,%esp
80106d20:	68 b7 8f 10 80       	push   $0x80108fb7
80106d25:	e8 56 96 ff ff       	call   80100380 <panic>
80106d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106d30:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d33:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106d39:	25 fc 0f 00 00       	and    $0xffc,%eax
80106d3e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106d45:	85 c0                	test   %eax,%eax
80106d47:	74 d4                	je     80106d1d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106d49:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d4b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106d4e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106d53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106d58:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106d5e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d61:	29 d9                	sub    %ebx,%ecx
80106d63:	05 00 00 00 80       	add    $0x80000000,%eax
80106d68:	57                   	push   %edi
80106d69:	51                   	push   %ecx
80106d6a:	50                   	push   %eax
80106d6b:	ff 75 10             	push   0x10(%ebp)
80106d6e:	e8 1d ad ff ff       	call   80101a90 <readi>
80106d73:	83 c4 10             	add    $0x10,%esp
80106d76:	39 f8                	cmp    %edi,%eax
80106d78:	75 1e                	jne    80106d98 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106d7a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106d80:	89 f0                	mov    %esi,%eax
80106d82:	29 d8                	sub    %ebx,%eax
80106d84:	39 c6                	cmp    %eax,%esi
80106d86:	77 80                	ja     80106d08 <loaduvm+0x38>
}
80106d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d8b:	31 c0                	xor    %eax,%eax
}
80106d8d:	5b                   	pop    %ebx
80106d8e:	5e                   	pop    %esi
80106d8f:	5f                   	pop    %edi
80106d90:	5d                   	pop    %ebp
80106d91:	c3                   	ret    
80106d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106da0:	5b                   	pop    %ebx
80106da1:	5e                   	pop    %esi
80106da2:	5f                   	pop    %edi
80106da3:	5d                   	pop    %ebp
80106da4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106da5:	83 ec 0c             	sub    $0xc,%esp
80106da8:	68 58 90 10 80       	push   $0x80109058
80106dad:	e8 ce 95 ff ff       	call   80100380 <panic>
80106db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106dc0 <allocuvm>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	57                   	push   %edi
80106dc4:	56                   	push   %esi
80106dc5:	53                   	push   %ebx
80106dc6:	83 ec 0c             	sub    $0xc,%esp
  if(newsz >= MMAPBASE) // KERNBASE
80106dc9:	81 7d 10 ff ff ff 5f 	cmpl   $0x5fffffff,0x10(%ebp)
80106dd0:	0f 87 aa 00 00 00    	ja     80106e80 <allocuvm+0xc0>
  if(newsz < oldsz)
80106dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dd9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106ddc:	0f 82 a0 00 00 00    	jb     80106e82 <allocuvm+0xc2>
  a = PGROUNDUP(oldsz);
80106de2:	8b 45 0c             	mov    0xc(%ebp),%eax
80106de5:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106deb:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106df1:	39 75 10             	cmp    %esi,0x10(%ebp)
80106df4:	0f 86 96 00 00 00    	jbe    80106e90 <allocuvm+0xd0>
80106dfa:	8b 45 10             	mov    0x10(%ebp),%eax
80106dfd:	83 e8 01             	sub    $0x1,%eax
80106e00:	29 f0                	sub    %esi,%eax
80106e02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e07:	8d bc 06 00 10 00 00 	lea    0x1000(%esi,%eax,1),%edi
80106e0e:	eb 3d                	jmp    80106e4d <allocuvm+0x8d>
    memset(mem, 0, PGSIZE);
80106e10:	83 ec 04             	sub    $0x4,%esp
80106e13:	68 00 10 00 00       	push   $0x1000
80106e18:	6a 00                	push   $0x0
80106e1a:	50                   	push   %eax
80106e1b:	e8 70 d8 ff ff       	call   80104690 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e20:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e26:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106e2d:	50                   	push   %eax
80106e2e:	68 00 10 00 00       	push   $0x1000
80106e33:	56                   	push   %esi
80106e34:	ff 75 08             	push   0x8(%ebp)
80106e37:	e8 04 fc ff ff       	call   80106a40 <mappages>
80106e3c:	83 c4 20             	add    $0x20,%esp
80106e3f:	85 c0                	test   %eax,%eax
80106e41:	78 5d                	js     80106ea0 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106e43:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e49:	39 fe                	cmp    %edi,%esi
80106e4b:	74 43                	je     80106e90 <allocuvm+0xd0>
    mem = kalloc();
80106e4d:	e8 2e b8 ff ff       	call   80102680 <kalloc>
80106e52:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106e54:	85 c0                	test   %eax,%eax
80106e56:	75 b8                	jne    80106e10 <allocuvm+0x50>
      cprintf("allocuvm out of memory\n");
80106e58:	83 ec 0c             	sub    $0xc,%esp
80106e5b:	68 d5 8f 10 80       	push   $0x80108fd5
80106e60:	e8 3b 98 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106e65:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e68:	83 c4 10             	add    $0x10,%esp
80106e6b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e6e:	74 10                	je     80106e80 <allocuvm+0xc0>
80106e70:	89 c1                	mov    %eax,%ecx
80106e72:	8b 55 10             	mov    0x10(%ebp),%edx
80106e75:	8b 45 08             	mov    0x8(%ebp),%eax
80106e78:	e8 f3 f9 ff ff       	call   80106870 <deallocuvm.part.0>
80106e7d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
80106e80:	31 c0                	xor    %eax,%eax
}
80106e82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return newsz;
80106e90:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e96:	5b                   	pop    %ebx
80106e97:	5e                   	pop    %esi
80106e98:	5f                   	pop    %edi
80106e99:	5d                   	pop    %ebp
80106e9a:	c3                   	ret    
80106e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e9f:	90                   	nop
      cprintf("allocuvm out of memory (2)\n");
80106ea0:	83 ec 0c             	sub    $0xc,%esp
80106ea3:	68 ed 8f 10 80       	push   $0x80108fed
80106ea8:	e8 f3 97 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80106ead:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eb0:	83 c4 10             	add    $0x10,%esp
80106eb3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106eb6:	74 0d                	je     80106ec5 <allocuvm+0x105>
80106eb8:	89 c1                	mov    %eax,%ecx
80106eba:	8b 55 10             	mov    0x10(%ebp),%edx
80106ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80106ec0:	e8 ab f9 ff ff       	call   80106870 <deallocuvm.part.0>
      kfree(mem);
80106ec5:	83 ec 0c             	sub    $0xc,%esp
80106ec8:	53                   	push   %ebx
80106ec9:	e8 f2 b5 ff ff       	call   801024c0 <kfree>
      return 0;
80106ece:	83 c4 10             	add    $0x10,%esp
}
80106ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ed4:	31 c0                	xor    %eax,%eax
}
80106ed6:	5b                   	pop    %ebx
80106ed7:	5e                   	pop    %esi
80106ed8:	5f                   	pop    %edi
80106ed9:	5d                   	pop    %ebp
80106eda:	c3                   	ret    
80106edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106edf:	90                   	nop

80106ee0 <deallocuvm>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ee6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106eec:	39 d1                	cmp    %edx,%ecx
80106eee:	73 10                	jae    80106f00 <deallocuvm+0x20>
}
80106ef0:	5d                   	pop    %ebp
80106ef1:	e9 7a f9 ff ff       	jmp    80106870 <deallocuvm.part.0>
80106ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106efd:	8d 76 00             	lea    0x0(%esi),%esi
80106f00:	89 d0                	mov    %edx,%eax
80106f02:	5d                   	pop    %ebp
80106f03:	c3                   	ret    
80106f04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f0f:	90                   	nop

80106f10 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 0c             	sub    $0xc,%esp
80106f19:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f1c:	85 f6                	test   %esi,%esi
80106f1e:	74 59                	je     80106f79 <freevm+0x69>
  if(newsz >= oldsz)
80106f20:	31 c9                	xor    %ecx,%ecx
80106f22:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f27:	89 f0                	mov    %esi,%eax
80106f29:	89 f3                	mov    %esi,%ebx
80106f2b:	e8 40 f9 ff ff       	call   80106870 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f30:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106f36:	eb 0f                	jmp    80106f47 <freevm+0x37>
80106f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3f:	90                   	nop
80106f40:	83 c3 04             	add    $0x4,%ebx
80106f43:	39 df                	cmp    %ebx,%edi
80106f45:	74 23                	je     80106f6a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f47:	8b 03                	mov    (%ebx),%eax
80106f49:	a8 01                	test   $0x1,%al
80106f4b:	74 f3                	je     80106f40 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f52:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f55:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f58:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f5d:	50                   	push   %eax
80106f5e:	e8 5d b5 ff ff       	call   801024c0 <kfree>
80106f63:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f66:	39 df                	cmp    %ebx,%edi
80106f68:	75 dd                	jne    80106f47 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f6a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f70:	5b                   	pop    %ebx
80106f71:	5e                   	pop    %esi
80106f72:	5f                   	pop    %edi
80106f73:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f74:	e9 47 b5 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80106f79:	83 ec 0c             	sub    $0xc,%esp
80106f7c:	68 09 90 10 80       	push   $0x80109009
80106f81:	e8 fa 93 ff ff       	call   80100380 <panic>
80106f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8d:	8d 76 00             	lea    0x0(%esi),%esi

80106f90 <setupkvm>:
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	56                   	push   %esi
80106f94:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f95:	e8 e6 b6 ff ff       	call   80102680 <kalloc>
80106f9a:	89 c6                	mov    %eax,%esi
80106f9c:	85 c0                	test   %eax,%eax
80106f9e:	74 42                	je     80106fe2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106fa0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fa3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80106fa8:	68 00 10 00 00       	push   $0x1000
80106fad:	6a 00                	push   $0x0
80106faf:	50                   	push   %eax
80106fb0:	e8 db d6 ff ff       	call   80104690 <memset>
80106fb5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106fb8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106fbb:	8b 53 08             	mov    0x8(%ebx),%edx
80106fbe:	83 ec 0c             	sub    $0xc,%esp
80106fc1:	ff 73 0c             	push   0xc(%ebx)
80106fc4:	29 c2                	sub    %eax,%edx
80106fc6:	50                   	push   %eax
80106fc7:	52                   	push   %edx
80106fc8:	ff 33                	push   (%ebx)
80106fca:	56                   	push   %esi
80106fcb:	e8 70 fa ff ff       	call   80106a40 <mappages>
80106fd0:	83 c4 20             	add    $0x20,%esp
80106fd3:	85 c0                	test   %eax,%eax
80106fd5:	78 19                	js     80106ff0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106fd7:	83 c3 10             	add    $0x10,%ebx
80106fda:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80106fe0:	75 d6                	jne    80106fb8 <setupkvm+0x28>
}
80106fe2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fe5:	89 f0                	mov    %esi,%eax
80106fe7:	5b                   	pop    %ebx
80106fe8:	5e                   	pop    %esi
80106fe9:	5d                   	pop    %ebp
80106fea:	c3                   	ret    
80106feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fef:	90                   	nop
      freevm(pgdir);
80106ff0:	83 ec 0c             	sub    $0xc,%esp
80106ff3:	56                   	push   %esi
      return 0;
80106ff4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106ff6:	e8 15 ff ff ff       	call   80106f10 <freevm>
      return 0;
80106ffb:	83 c4 10             	add    $0x10,%esp
}
80106ffe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107001:	89 f0                	mov    %esi,%eax
80107003:	5b                   	pop    %ebx
80107004:	5e                   	pop    %esi
80107005:	5d                   	pop    %ebp
80107006:	c3                   	ret    
80107007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700e:	66 90                	xchg   %ax,%ax

80107010 <kvmalloc>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107016:	e8 75 ff ff ff       	call   80106f90 <setupkvm>
8010701b:	a3 c4 e6 11 80       	mov    %eax,0x8011e6c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107020:	05 00 00 00 80       	add    $0x80000000,%eax
80107025:	0f 22 d8             	mov    %eax,%cr3
}
80107028:	c9                   	leave  
80107029:	c3                   	ret    
8010702a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107030 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	83 ec 08             	sub    $0x8,%esp
80107036:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107039:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010703c:	89 c1                	mov    %eax,%ecx
8010703e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107041:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107044:	f6 c2 01             	test   $0x1,%dl
80107047:	75 17                	jne    80107060 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107049:	83 ec 0c             	sub    $0xc,%esp
8010704c:	68 1a 90 10 80       	push   $0x8010901a
80107051:	e8 2a 93 ff ff       	call   80100380 <panic>
80107056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010705d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107060:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107063:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107069:	25 fc 0f 00 00       	and    $0xffc,%eax
8010706e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107075:	85 c0                	test   %eax,%eax
80107077:	74 d0                	je     80107049 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107079:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010707c:	c9                   	leave  
8010707d:	c3                   	ret    
8010707e:	66 90                	xchg   %ax,%ax

80107080 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107089:	e8 02 ff ff ff       	call   80106f90 <setupkvm>
8010708e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107091:	85 c0                	test   %eax,%eax
80107093:	0f 84 c0 00 00 00    	je     80107159 <copyuvm+0xd9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107099:	8b 55 0c             	mov    0xc(%ebp),%edx
8010709c:	85 d2                	test   %edx,%edx
8010709e:	0f 84 b5 00 00 00    	je     80107159 <copyuvm+0xd9>
801070a4:	31 f6                	xor    %esi,%esi
801070a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801070b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801070b3:	89 f0                	mov    %esi,%eax
801070b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801070b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801070bb:	a8 01                	test   $0x1,%al
801070bd:	75 11                	jne    801070d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801070bf:	83 ec 0c             	sub    $0xc,%esp
801070c2:	68 24 90 10 80       	push   $0x80109024
801070c7:	e8 b4 92 ff ff       	call   80100380 <panic>
801070cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801070d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801070d7:	c1 ea 0a             	shr    $0xa,%edx
801070da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801070e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801070e7:	85 c0                	test   %eax,%eax
801070e9:	74 d4                	je     801070bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801070eb:	8b 38                	mov    (%eax),%edi
801070ed:	f7 c7 01 00 00 00    	test   $0x1,%edi
801070f3:	0f 84 9b 00 00 00    	je     80107194 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801070f9:	89 fb                	mov    %edi,%ebx
    flags = PTE_FLAGS(*pte);
801070fb:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80107101:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107104:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
8010710a:	e8 71 b5 ff ff       	call   80102680 <kalloc>
8010710f:	89 c7                	mov    %eax,%edi
80107111:	85 c0                	test   %eax,%eax
80107113:	74 5f                	je     80107174 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107115:	83 ec 04             	sub    $0x4,%esp
80107118:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
8010711e:	68 00 10 00 00       	push   $0x1000
80107123:	53                   	push   %ebx
80107124:	50                   	push   %eax
80107125:	e8 06 d6 ff ff       	call   80104730 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010712a:	58                   	pop    %eax
8010712b:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107131:	ff 75 e4             	push   -0x1c(%ebp)
80107134:	50                   	push   %eax
80107135:	68 00 10 00 00       	push   $0x1000
8010713a:	56                   	push   %esi
8010713b:	ff 75 e0             	push   -0x20(%ebp)
8010713e:	e8 fd f8 ff ff       	call   80106a40 <mappages>
80107143:	83 c4 20             	add    $0x20,%esp
80107146:	85 c0                	test   %eax,%eax
80107148:	78 1e                	js     80107168 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
8010714a:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107150:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107153:	0f 87 57 ff ff ff    	ja     801070b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107159:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010715c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010715f:	5b                   	pop    %ebx
80107160:	5e                   	pop    %esi
80107161:	5f                   	pop    %edi
80107162:	5d                   	pop    %ebp
80107163:	c3                   	ret    
80107164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107168:	83 ec 0c             	sub    $0xc,%esp
8010716b:	57                   	push   %edi
8010716c:	e8 4f b3 ff ff       	call   801024c0 <kfree>
      goto bad;
80107171:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107174:	83 ec 0c             	sub    $0xc,%esp
80107177:	ff 75 e0             	push   -0x20(%ebp)
8010717a:	e8 91 fd ff ff       	call   80106f10 <freevm>
  return 0;
8010717f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107186:	83 c4 10             	add    $0x10,%esp
}
80107189:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010718c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010718f:	5b                   	pop    %ebx
80107190:	5e                   	pop    %esi
80107191:	5f                   	pop    %edi
80107192:	5d                   	pop    %ebp
80107193:	c3                   	ret    
      panic("copyuvm: page not present");
80107194:	83 ec 0c             	sub    $0xc,%esp
80107197:	68 3e 90 10 80       	push   $0x8010903e
8010719c:	e8 df 91 ff ff       	call   80100380 <panic>
801071a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071af:	90                   	nop

801071b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801071b9:	89 c1                	mov    %eax,%ecx
801071bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801071c1:	f6 c2 01             	test   $0x1,%dl
801071c4:	0f 84 00 01 00 00    	je     801072ca <uva2ka.cold>
  return &pgtab[PTX(va)];
801071ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801071d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801071d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801071d9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801071e0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801071e7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071ea:	05 00 00 00 80       	add    $0x80000000,%eax
801071ef:	83 fa 05             	cmp    $0x5,%edx
801071f2:	ba 00 00 00 00       	mov    $0x0,%edx
801071f7:	0f 45 c2             	cmovne %edx,%eax
}
801071fa:	c3                   	ret    
801071fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071ff:	90                   	nop

80107200 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	8b 75 14             	mov    0x14(%ebp),%esi
8010720c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010720f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107212:	85 f6                	test   %esi,%esi
80107214:	75 51                	jne    80107267 <copyout+0x67>
80107216:	e9 a5 00 00 00       	jmp    801072c0 <copyout+0xc0>
8010721b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010721f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107220:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107226:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010722c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107232:	74 75                	je     801072a9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107234:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107236:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107239:	29 c3                	sub    %eax,%ebx
8010723b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107241:	39 f3                	cmp    %esi,%ebx
80107243:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107246:	29 f8                	sub    %edi,%eax
80107248:	83 ec 04             	sub    $0x4,%esp
8010724b:	01 c1                	add    %eax,%ecx
8010724d:	53                   	push   %ebx
8010724e:	52                   	push   %edx
8010724f:	51                   	push   %ecx
80107250:	e8 db d4 ff ff       	call   80104730 <memmove>
    len -= n;
    buf += n;
80107255:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107258:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010725e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107261:	01 da                	add    %ebx,%edx
  while(len > 0){
80107263:	29 de                	sub    %ebx,%esi
80107265:	74 59                	je     801072c0 <copyout+0xc0>
  if(*pde & PTE_P){
80107267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010726a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010726c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010726e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107271:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107277:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010727a:	f6 c1 01             	test   $0x1,%cl
8010727d:	0f 84 4e 00 00 00    	je     801072d1 <copyout.cold>
  return &pgtab[PTX(va)];
80107283:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107285:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010728b:	c1 eb 0c             	shr    $0xc,%ebx
8010728e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107294:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010729b:	89 d9                	mov    %ebx,%ecx
8010729d:	83 e1 05             	and    $0x5,%ecx
801072a0:	83 f9 05             	cmp    $0x5,%ecx
801072a3:	0f 84 77 ff ff ff    	je     80107220 <copyout+0x20>
  }
  return 0;
}
801072a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072b1:	5b                   	pop    %ebx
801072b2:	5e                   	pop    %esi
801072b3:	5f                   	pop    %edi
801072b4:	5d                   	pop    %ebp
801072b5:	c3                   	ret    
801072b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072bd:	8d 76 00             	lea    0x0(%esi),%esi
801072c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072c3:	31 c0                	xor    %eax,%eax
}
801072c5:	5b                   	pop    %ebx
801072c6:	5e                   	pop    %esi
801072c7:	5f                   	pop    %edi
801072c8:	5d                   	pop    %ebp
801072c9:	c3                   	ret    

801072ca <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801072ca:	a1 00 00 00 00       	mov    0x0,%eax
801072cf:	0f 0b                	ud2    

801072d1 <copyout.cold>:
801072d1:	a1 00 00 00 00       	mov    0x0,%eax
801072d6:	0f 0b                	ud2    
801072d8:	66 90                	xchg   %ax,%ax
801072da:	66 90                	xchg   %ax,%ax
801072dc:	66 90                	xchg   %ax,%ax
801072de:	66 90                	xchg   %ax,%ax

801072e0 <sys_getwmapinfo>:
/**
 * @brief System call to retrieve detailed information about all memory mappings in the process's address space.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_getwmapinfo(void) {
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	56                   	push   %esi
801072e4:	53                   	push   %ebx
    struct wmapinfo *info;
    if (argptr(0, (void *)&info, sizeof(*info)) < 0) {
801072e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_getwmapinfo(void) {
801072e8:	83 ec 14             	sub    $0x14,%esp
    if (argptr(0, (void *)&info, sizeof(*info)) < 0) {
801072eb:	68 84 01 00 00       	push   $0x184
801072f0:	50                   	push   %eax
801072f1:	6a 00                	push   $0x0
801072f3:	e8 a8 d6 ff ff       	call   801049a0 <argptr>
801072f8:	83 c4 10             	add    $0x10,%esp
801072fb:	85 c0                	test   %eax,%eax
801072fd:	78 6d                	js     8010736c <sys_getwmapinfo+0x8c>
        cprintf("getwmapinfo arg ERROR\n");
        return FAILED;
    }

    // TODO: get mmap information into the buffer
    struct proc* p = myproc();
801072ff:	e8 7c c6 ff ff       	call   80103980 <myproc>
    int count = 0;
    struct mmap_region* cur_node = p->mmap_head;
    for(int i = 0; cur_node != 0;i++)
    {
        
        info->addr[i]           = cur_node->addr;
80107304:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    struct mmap_region* cur_node = p->mmap_head;
80107307:	8b 80 7c 02 00 00    	mov    0x27c(%eax),%eax
    for(int i = 0; cur_node != 0;i++)
8010730d:	85 c0                	test   %eax,%eax
8010730f:	74 57                	je     80107368 <sys_getwmapinfo+0x88>
80107311:	8d 53 04             	lea    0x4(%ebx),%edx
    int count = 0;
80107314:	31 c9                	xor    %ecx,%ecx
80107316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731d:	8d 76 00             	lea    0x0(%esi),%esi
        info->addr[i]           = cur_node->addr;
80107320:	8b 30                	mov    (%eax),%esi
        info->fd[i]             = cur_node->fd;
        info->refcnt[i]         = cur_node->refcnt;
        info->n_loaded_pages[i] = cur_node->n_loaded_pages;
 
        cur_node = cur_node->next;
        count++;
80107322:	83 c1 01             	add    $0x1,%ecx
    for(int i = 0; cur_node != 0;i++)
80107325:	83 c2 04             	add    $0x4,%edx
        info->addr[i]           = cur_node->addr;
80107328:	89 72 fc             	mov    %esi,-0x4(%edx)
        info->length[i]         = cur_node->length;
8010732b:	8b 70 04             	mov    0x4(%eax),%esi
8010732e:	89 72 3c             	mov    %esi,0x3c(%edx)
        info->flags[i]          = cur_node->flags;
80107331:	8b 70 08             	mov    0x8(%eax),%esi
80107334:	89 72 7c             	mov    %esi,0x7c(%edx)
        info->fd[i]             = cur_node->fd;
80107337:	8b 70 0c             	mov    0xc(%eax),%esi
8010733a:	89 b2 bc 00 00 00    	mov    %esi,0xbc(%edx)
        info->refcnt[i]         = cur_node->refcnt;
80107340:	8b 70 14             	mov    0x14(%eax),%esi
80107343:	89 b2 fc 00 00 00    	mov    %esi,0xfc(%edx)
        info->n_loaded_pages[i] = cur_node->n_loaded_pages;
80107349:	8b 70 18             	mov    0x18(%eax),%esi
8010734c:	89 b2 3c 01 00 00    	mov    %esi,0x13c(%edx)
        cur_node = cur_node->next;
80107352:	8b 40 1c             	mov    0x1c(%eax),%eax
    for(int i = 0; cur_node != 0;i++)
80107355:	85 c0                	test   %eax,%eax
80107357:	75 c7                	jne    80107320 <sys_getwmapinfo+0x40>
    }
    info->total_mmaps = count;
80107359:	89 0b                	mov    %ecx,(%ebx)


    return 0;
8010735b:	31 c0                	xor    %eax,%eax
}
8010735d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107360:	5b                   	pop    %ebx
80107361:	5e                   	pop    %esi
80107362:	5d                   	pop    %ebp
80107363:	c3                   	ret    
80107364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    int count = 0;
80107368:	31 c9                	xor    %ecx,%ecx
8010736a:	eb ed                	jmp    80107359 <sys_getwmapinfo+0x79>
        cprintf("getwmapinfo arg ERROR\n");
8010736c:	83 ec 0c             	sub    $0xc,%esp
8010736f:	68 7b 90 10 80       	push   $0x8010907b
80107374:	e8 27 93 ff ff       	call   801006a0 <cprintf>
        return FAILED;
80107379:	83 c4 10             	add    $0x10,%esp
8010737c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107381:	eb da                	jmp    8010735d <sys_getwmapinfo+0x7d>
80107383:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010738a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107390 <sys_getpgdirinfo>:
 * @brief System call to retrieve information about the current page directory.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int sys_getpgdirinfo(void) 
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
    struct pgdirinfo *info;
    if (argptr(0, (void *)&info, sizeof(*info)) < 0) 
80107395:	8d 45 e4             	lea    -0x1c(%ebp),%eax
{
80107398:	53                   	push   %ebx
80107399:	83 ec 30             	sub    $0x30,%esp
    if (argptr(0, (void *)&info, sizeof(*info)) < 0) 
8010739c:	68 04 01 00 00       	push   $0x104
801073a1:	50                   	push   %eax
801073a2:	6a 00                	push   $0x0
801073a4:	e8 f7 d5 ff ff       	call   801049a0 <argptr>
801073a9:	83 c4 10             	add    $0x10,%esp
801073ac:	85 c0                	test   %eax,%eax
801073ae:	0f 88 13 01 00 00    	js     801074c7 <sys_getpgdirinfo+0x137>
        return FAILED;
    }

    // TODO: get page directory information into the buffer

    struct proc* p = myproc();
801073b4:	e8 c7 c5 ff ff       	call   80103980 <myproc>
            count++;
        }
        cur_node = cur_node->next;
    }

    info->n_upages = count;
801073b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    struct mmap_region* cur_node = p->mmap_head;
801073bc:	8b b8 7c 02 00 00    	mov    0x27c(%eax),%edi
    struct proc* p = myproc();
801073c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for(int i = 0; cur_node != 0;i++)
801073c5:	85 ff                	test   %edi,%edi
801073c7:	0f 84 f6 00 00 00    	je     801074c3 <sys_getpgdirinfo+0x133>
    int count = 0;
801073cd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801073d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        uint length = cur_node->length;
801073d8:	8b 47 04             	mov    0x4(%edi),%eax
        uint addr   = cur_node->addr;
801073db:	8b 37                	mov    (%edi),%esi
        int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;
801073dd:	89 c1                	mov    %eax,%ecx
        uint addr   = cur_node->addr;
801073df:	89 75 cc             	mov    %esi,-0x34(%ebp)
        int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;
801073e2:	c1 e9 0c             	shr    $0xc,%ecx
801073e5:	a9 ff 0f 00 00       	test   $0xfff,%eax
801073ea:	0f 85 c8 00 00 00    	jne    801074b8 <sys_getpgdirinfo+0x128>
801073f0:	89 4d d0             	mov    %ecx,-0x30(%ebp)
        for(int j = 0; j < repeat; j++)
801073f3:	85 c9                	test   %ecx,%ecx
801073f5:	0f 84 85 00 00 00    	je     80107480 <sys_getpgdirinfo+0xf0>
    int count = 0;
801073fb:	8b 4d cc             	mov    -0x34(%ebp),%ecx
801073fe:	31 db                	xor    %ebx,%ebx
80107400:	eb 1c                	jmp    8010741e <sys_getpgdirinfo+0x8e>
80107402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            uint physical_address = PTE_ADDR(*pte);
80107408:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010740d:	89 84 b2 84 00 00 00 	mov    %eax,0x84(%edx,%esi,4)
        for(int j = 0; j < repeat; j++)
80107414:	83 c3 01             	add    $0x1,%ebx
80107417:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
8010741a:	7e 4a                	jle    80107466 <sys_getpgdirinfo+0xd6>
            info->va[count] = cur_node->addr + j * PGSIZE;
8010741c:	8b 0f                	mov    (%edi),%ecx
8010741e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
            pte_t *pte = walkpgdir(p->pgdir, (void*)(addr + j * PGSIZE), 0);
80107421:	83 ec 04             	sub    $0x4,%esp
80107424:	8d 34 18             	lea    (%eax,%ebx,1),%esi
            info->va[count] = cur_node->addr + j * PGSIZE;
80107427:	89 d8                	mov    %ebx,%eax
80107429:	c1 e0 0c             	shl    $0xc,%eax
8010742c:	01 c1                	add    %eax,%ecx
            pte_t *pte = walkpgdir(p->pgdir, (void*)(addr + j * PGSIZE), 0);
8010742e:	03 45 cc             	add    -0x34(%ebp),%eax
            info->va[count] = cur_node->addr + j * PGSIZE;
80107431:	89 4c b2 04          	mov    %ecx,0x4(%edx,%esi,4)
            pte_t *pte = walkpgdir(p->pgdir, (void*)(addr + j * PGSIZE), 0);
80107435:	6a 00                	push   $0x0
80107437:	50                   	push   %eax
80107438:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010743b:	ff 70 04             	push   0x4(%eax)
8010743e:	e8 6d f5 ff ff       	call   801069b0 <walkpgdir>
            if (pte == 0)
80107443:	83 c4 10             	add    $0x10,%esp
80107446:	85 c0                	test   %eax,%eax
80107448:	74 56                	je     801074a0 <sys_getpgdirinfo+0x110>
            if ((*pte & PTE_P) == 0) 
8010744a:	8b 00                	mov    (%eax),%eax
                info->pa[count] = -1;
8010744c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            if ((*pte & PTE_P) == 0) 
8010744f:	a8 01                	test   $0x1,%al
80107451:	75 b5                	jne    80107408 <sys_getpgdirinfo+0x78>
                info->pa[count] = 0;
80107453:	c7 84 b2 84 00 00 00 	movl   $0x0,0x84(%edx,%esi,4)
8010745a:	00 00 00 00 
        for(int j = 0; j < repeat; j++)
8010745e:	83 c3 01             	add    $0x1,%ebx
80107461:	39 5d d0             	cmp    %ebx,-0x30(%ebp)
80107464:	7f b6                	jg     8010741c <sys_getpgdirinfo+0x8c>
80107466:	8b 75 d0             	mov    -0x30(%ebp),%esi
80107469:	8d 46 ff             	lea    -0x1(%esi),%eax
8010746c:	85 f6                	test   %esi,%esi
8010746e:	be 00 00 00 00       	mov    $0x0,%esi
80107473:	0f 4e c6             	cmovle %esi,%eax
80107476:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80107479:	8d 44 06 01          	lea    0x1(%esi,%eax,1),%eax
8010747d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        cur_node = cur_node->next;
80107480:	8b 7f 1c             	mov    0x1c(%edi),%edi
    for(int i = 0; cur_node != 0;i++)
80107483:	85 ff                	test   %edi,%edi
80107485:	0f 85 4d ff ff ff    	jne    801073d8 <sys_getpgdirinfo+0x48>
    info->n_upages = count;
8010748b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010748e:	89 02                	mov    %eax,(%edx)


    return 0;
80107490:	31 c0                	xor    %eax,%eax
}
80107492:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107495:	5b                   	pop    %ebx
80107496:	5e                   	pop    %esi
80107497:	5f                   	pop    %edi
80107498:	5d                   	pop    %ebp
80107499:	c3                   	ret    
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                info->pa[count] = -1;
801074a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074a3:	c7 84 b2 84 00 00 00 	movl   $0xffffffff,0x84(%edx,%esi,4)
801074aa:	ff ff ff ff 
                continue;
801074ae:	e9 61 ff ff ff       	jmp    80107414 <sys_getpgdirinfo+0x84>
801074b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074b7:	90                   	nop
        int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;
801074b8:	8d 41 01             	lea    0x1(%ecx),%eax
801074bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
        for(int j = 0; j < repeat; j++)
801074be:	e9 38 ff ff ff       	jmp    801073fb <sys_getpgdirinfo+0x6b>
    info->n_upages = count;
801074c3:	31 c0                	xor    %eax,%eax
801074c5:	eb c7                	jmp    8010748e <sys_getpgdirinfo+0xfe>
        return FAILED;
801074c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074cc:	eb c4                	jmp    80107492 <sys_getpgdirinfo+0x102>
801074ce:	66 90                	xchg   %ax,%ax

801074d0 <validate_input>:
 * @brief validates input parameters for memory mapping.
 *
 * @return 0 if input is valid, or a negative error code if validation fails.
 */
int validate_input(uint addr, int length, int flags, int fd, struct file *f) 
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	8b 45 10             	mov    0x10(%ebp),%eax
    // Getting flags
    int fixed  = (flags & MAP_FIXED)     != 0; 
801074d6:	89 c2                	mov    %eax,%edx
    int shared = (flags & MAP_SHARED)    != 0; 
    int priv   = (flags & MAP_PRIVATE)   != 0; 
    int anon   = (flags & MAP_ANONYMOUS) != 0;
801074d8:	89 c1                	mov    %eax,%ecx
    int fixed  = (flags & MAP_FIXED)     != 0; 
801074da:	c1 ea 03             	shr    $0x3,%edx
    int anon   = (flags & MAP_ANONYMOUS) != 0;
801074dd:	83 e1 04             	and    $0x4,%ecx
    int fixed  = (flags & MAP_FIXED)     != 0; 
801074e0:	83 e2 01             	and    $0x1,%edx
 
    // Private and shared flag cannot be both set
    if(priv && shared)
801074e3:	a8 02                	test   $0x2,%al
801074e5:	74 04                	je     801074eb <validate_input+0x1b>
801074e7:	a8 01                	test   $0x1,%al
801074e9:	75 2d                	jne    80107518 <validate_input+0x48>
        return -1;

    // if flag is fixed then addr has to be multiple of PGSIZE 
    int is_addr_multiple_page_size = addr % PGSIZE == 0; 
    if(fixed && !is_addr_multiple_page_size)
801074eb:	f7 45 08 ff 0f 00 00 	testl  $0xfff,0x8(%ebp)
801074f2:	74 04                	je     801074f8 <validate_input+0x28>
801074f4:	84 d2                	test   %dl,%dl
801074f6:	75 20                	jne    80107518 <validate_input+0x48>
        return -1;

    // if you not in anonymous flag then the file stuff needs to be valid
    // in the wmap function when the argfd fails to get file then 
    // it sets fd to -1 and f to 0 
    if(!anon && fd == -1 && f == 0)
801074f8:	0b 4d 18             	or     0x18(%ebp),%ecx
801074fb:	75 06                	jne    80107503 <validate_input+0x33>
801074fd:	83 7d 14 ff          	cmpl   $0xffffffff,0x14(%ebp)
80107501:	74 15                	je     80107518 <validate_input+0x48>
        return -1;

    if(length <= 0)
80107503:	8b 55 0c             	mov    0xc(%ebp),%edx
80107506:	31 c0                	xor    %eax,%eax
        return -1;

    return 0;
}
80107508:	5d                   	pop    %ebp
    if(length <= 0)
80107509:	85 d2                	test   %edx,%edx
8010750b:	0f 9e c0             	setle  %al
8010750e:	f7 d8                	neg    %eax
}
80107510:	c3                   	ret    
80107511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80107518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010751d:	5d                   	pop    %ebp
8010751e:	c3                   	ret    
8010751f:	90                   	nop

80107520 <find_unused_mmap>:
 * and returns a pointer to it.
 *
 * @return Pointer to the unused mmap structure if found, or NULL if not found.
 */
struct mmap_region *find_unused_mmap(struct proc *proc) 
{
80107520:	55                   	push   %ebp
    
    for(int i = 0; i < MAX_NMMAP;i++)
80107521:	31 c0                	xor    %eax,%eax
{
80107523:	89 e5                	mov    %esp,%ebp
80107525:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010752f:	90                   	nop
    {
        // checking if a map is valid or not by checking if address > 0
        int valid = proc->mmaps[i].addr > 0;
80107530:	89 c2                	mov    %eax,%edx
80107532:	c1 e2 05             	shl    $0x5,%edx
        if (!valid)
80107535:	83 7c 11 7c 00       	cmpl   $0x0,0x7c(%ecx,%edx,1)
8010753a:	74 14                	je     80107550 <find_unused_mmap+0x30>
    for(int i = 0; i < MAX_NMMAP;i++)
8010753c:	83 c0 01             	add    $0x1,%eax
8010753f:	83 f8 10             	cmp    $0x10,%eax
80107542:	75 ec                	jne    80107530 <find_unused_mmap+0x10>
        {
            return &proc->mmaps[i];
        }
    }
    return (struct mmap_region*)0;
80107544:	31 c0                	xor    %eax,%eax
}
80107546:	5d                   	pop    %ebp
80107547:	c3                   	ret    
80107548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010754f:	90                   	nop
            return &proc->mmaps[i];
80107550:	8d 44 11 7c          	lea    0x7c(%ecx,%edx,1),%eax
}
80107554:	5d                   	pop    %ebp
80107555:	c3                   	ret    
80107556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010755d:	8d 76 00             	lea    0x0(%esi),%esi

80107560 <fix_addr_place_mmap>:
 * @param addr The fixed address for the mapping.
 * @param length The length of the mapping.
 * @return Pointer to the placed mmap structure if successful, or NULL if failed.
 */
struct mmap_region *fix_addr_place_mmap(struct proc *proc, uint addr, int length, int flags) 
{
80107560:	55                   	push   %ebp
    for(int i = 0; i < MAX_NMMAP;i++)
80107561:	31 c0                	xor    %eax,%eax
{
80107563:	89 e5                	mov    %esp,%ebp
80107565:	57                   	push   %edi
80107566:	56                   	push   %esi
80107567:	53                   	push   %ebx
80107568:	83 ec 08             	sub    $0x8,%esp
8010756b:	8b 7d 08             	mov    0x8(%ebp),%edi
    for(int i = 0; i < MAX_NMMAP;i++)
8010756e:	66 90                	xchg   %ax,%ax
        int valid = proc->mmaps[i].addr > 0;
80107570:	89 c3                	mov    %eax,%ebx
80107572:	c1 e3 05             	shl    $0x5,%ebx
        if (!valid)
80107575:	8b 54 1f 7c          	mov    0x7c(%edi,%ebx,1),%edx
80107579:	85 d2                	test   %edx,%edx
8010757b:	74 1b                	je     80107598 <fix_addr_place_mmap+0x38>
    for(int i = 0; i < MAX_NMMAP;i++)
8010757d:	83 c0 01             	add    $0x1,%eax
80107580:	83 f8 10             	cmp    $0x10,%eax
80107583:	75 eb                	jne    80107570 <fix_addr_place_mmap+0x10>
    // This means that there is no valid maps or that all of the map slots are taken 
    struct mmap_region* unused_map = find_unused_mmap(proc);
    if (unused_map == 0)
    {
        DPRINT("XV6: couldn't find space in mmaps\n");
        return (struct mmap_region*)0;
80107585:	31 d2                	xor    %edx,%edx
        unused_map->next = 0;
    }

    DPRINT("XV6: fix_addr_place_mmap: 0x%x fd:0x%x\n", unused_map->addr, unused_map->fd);
    return unused_map;
}
80107587:	83 c4 08             	add    $0x8,%esp
8010758a:	89 d0                	mov    %edx,%eax
8010758c:	5b                   	pop    %ebx
8010758d:	5e                   	pop    %esi
8010758e:	5f                   	pop    %edi
8010758f:	5d                   	pop    %ebp
80107590:	c3                   	ret    
80107591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 * @brief resets the fields of an mmap_region struct to their default values.
 *
 * @param mmap Pointer to the mmap_region struct to reset.
 */
void init_one_mmap(struct mmap_region *mmap) {
    mmap->addr = 0; // note to future changed this from a 0 to a -1
80107598:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
8010759b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010759e:	8b 45 0c             	mov    0xc(%ebp),%eax
801075a1:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
    mmap->length = -1;
801075a8:	c7 86 80 00 00 00 ff 	movl   $0xffffffff,0x80(%esi)
801075af:	ff ff ff 
    mmap->flags = -1;
801075b2:	c7 86 84 00 00 00 ff 	movl   $0xffffffff,0x84(%esi)
801075b9:	ff ff ff 
    mmap->fd = -1;
801075bc:	c7 86 88 00 00 00 ff 	movl   $0xffffffff,0x88(%esi)
801075c3:	ff ff ff 
    mmap->f = 0;
801075c6:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801075cd:	00 00 00 
    mmap->refcnt = 0;
801075d0:	c7 86 90 00 00 00 00 	movl   $0x0,0x90(%esi)
801075d7:	00 00 00 
    mmap->n_loaded_pages = 0;
801075da:	c7 86 94 00 00 00 00 	movl   $0x0,0x94(%esi)
801075e1:	00 00 00 
    mmap->next = 0;
801075e4:	c7 86 98 00 00 00 00 	movl   $0x0,0x98(%esi)
801075eb:	00 00 00 
    for(cur = proc->mmap_head; cur != 0 && cur->next != 0 && (cur->next->addr < addr); cur = cur->next) { }
801075ee:	8b 8f 7c 02 00 00    	mov    0x27c(%edi),%ecx
    mmap->addr = 0; // note to future changed this from a 0 to a -1
801075f4:	89 75 ec             	mov    %esi,-0x14(%ebp)
    for(cur = proc->mmap_head; cur != 0 && cur->next != 0 && (cur->next->addr < addr); cur = cur->next) { }
801075f7:	eb 1a                	jmp    80107613 <fix_addr_place_mmap+0xb3>
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107600:	8b 51 1c             	mov    0x1c(%ecx),%edx
80107603:	85 d2                	test   %edx,%edx
80107605:	0f 84 d5 00 00 00    	je     801076e0 <fix_addr_place_mmap+0x180>
8010760b:	8b 32                	mov    (%edx),%esi
8010760d:	39 c6                	cmp    %eax,%esi
8010760f:	73 7f                	jae    80107690 <fix_addr_place_mmap+0x130>
80107611:	89 d1                	mov    %edx,%ecx
80107613:	85 c9                	test   %ecx,%ecx
80107615:	75 e9                	jne    80107600 <fix_addr_place_mmap+0xa0>
    uint lower_bound = is_first                ? 0x60000000  : cur->addr + cur->length;
80107617:	8b 45 f0             	mov    -0x10(%ebp),%eax
    upper_bound      = (!is_empty && is_first) ? cur->addr   : upper_bound;
8010761a:	c6 45 f0 00          	movb   $0x0,-0x10(%ebp)
    uint lower_bound = is_first                ? 0x60000000  : cur->addr + cur->length;
8010761e:	ba 00 00 00 60       	mov    $0x60000000,%edx
    uint upper_bound = is_last                 ? 0x80000000  : cur->next->addr;
80107623:	be 00 00 00 80       	mov    $0x80000000,%esi
    if(lower_bound > addr)
80107628:	39 55 0c             	cmp    %edx,0xc(%ebp)
8010762b:	0f 82 54 ff ff ff    	jb     80107585 <fix_addr_place_mmap+0x25>
    if(addr + length > upper_bound)
80107631:	8b 55 10             	mov    0x10(%ebp),%edx
80107634:	03 55 0c             	add    0xc(%ebp),%edx
80107637:	39 f2                	cmp    %esi,%edx
80107639:	0f 87 46 ff ff ff    	ja     80107585 <fix_addr_place_mmap+0x25>
    unused_map->addr   = addr;
8010763f:	c1 e0 05             	shl    $0x5,%eax
            return &proc->mmaps[i];
80107642:	8d 54 1f 7c          	lea    0x7c(%edi,%ebx,1),%edx
    unused_map->addr   = addr;
80107646:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107649:	01 f8                	add    %edi,%eax
    if(!is_empty && cur->addr > addr)
8010764b:	80 7d f0 00          	cmpb   $0x0,-0x10(%ebp)
    unused_map->addr   = addr;
8010764f:	89 58 7c             	mov    %ebx,0x7c(%eax)
    unused_map->flags  = flags;
80107652:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107655:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
    unused_map->length = length;
8010765b:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010765e:	89 98 80 00 00 00    	mov    %ebx,0x80(%eax)
    if(!is_empty && cur->addr > addr)
80107664:	0f 84 96 00 00 00    	je     80107700 <fix_addr_place_mmap+0x1a0>
8010766a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010766d:	39 01                	cmp    %eax,(%ecx)
8010766f:	76 37                	jbe    801076a8 <fix_addr_place_mmap+0x148>
        unused_map->next = cur;
80107671:	8b 45 ec             	mov    -0x14(%ebp),%eax
        proc->mmap_head = unused_map;
80107674:	89 97 7c 02 00 00    	mov    %edx,0x27c(%edi)
        unused_map->next = cur;
8010767a:	89 88 98 00 00 00    	mov    %ecx,0x98(%eax)
}
80107680:	83 c4 08             	add    $0x8,%esp
80107683:	89 d0                	mov    %edx,%eax
80107685:	5b                   	pop    %ebx
80107686:	5e                   	pop    %esi
80107687:	5f                   	pop    %edi
80107688:	5d                   	pop    %ebp
80107689:	c3                   	ret    
8010768a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107690:	8b 45 f0             	mov    -0x10(%ebp),%eax
    int is_first     = is_empty                ? 1           : cur->addr > addr; 
80107693:	8b 11                	mov    (%ecx),%edx
    uint lower_bound = is_first                ? 0x60000000  : cur->addr + cur->length;
80107695:	39 55 0c             	cmp    %edx,0xc(%ebp)
80107698:	72 55                	jb     801076ef <fix_addr_place_mmap+0x18f>
    upper_bound      = (!is_empty && is_first) ? cur->addr   : upper_bound;
8010769a:	c6 45 f0 01          	movb   $0x1,-0x10(%ebp)
    uint lower_bound = is_first                ? 0x60000000  : cur->addr + cur->length;
8010769e:	03 51 04             	add    0x4(%ecx),%edx
    upper_bound      = (!is_empty && is_first) ? cur->addr   : upper_bound;
801076a1:	eb 85                	jmp    80107628 <fix_addr_place_mmap+0xc8>
801076a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076a7:	90                   	nop
    else if(!is_empty && cur->next == 0)
801076a8:	8b 41 1c             	mov    0x1c(%ecx),%eax
        cur->next = unused_map;
801076ab:	89 51 1c             	mov    %edx,0x1c(%ecx)
    else if(!is_empty && cur->next == 0)
801076ae:	85 c0                	test   %eax,%eax
801076b0:	74 13                	je     801076c5 <fix_addr_place_mmap+0x165>
        unused_map->next = temp;
801076b2:	8b 7d ec             	mov    -0x14(%ebp),%edi
801076b5:	89 87 98 00 00 00    	mov    %eax,0x98(%edi)
}
801076bb:	83 c4 08             	add    $0x8,%esp
801076be:	89 d0                	mov    %edx,%eax
801076c0:	5b                   	pop    %ebx
801076c1:	5e                   	pop    %esi
801076c2:	5f                   	pop    %edi
801076c3:	5d                   	pop    %ebp
801076c4:	c3                   	ret    
        unused_map->next = 0;
801076c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801076c8:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
801076cf:	00 00 00 
801076d2:	e9 b0 fe ff ff       	jmp    80107587 <fix_addr_place_mmap+0x27>
801076d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076de:	66 90                	xchg   %ax,%ax
    int is_first     = is_empty                ? 1           : cur->addr > addr; 
801076e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076e3:	8b 11                	mov    (%ecx),%edx
    uint upper_bound = is_last                 ? 0x80000000  : cur->next->addr;
801076e5:	be 00 00 00 80       	mov    $0x80000000,%esi
    uint lower_bound = is_first                ? 0x60000000  : cur->addr + cur->length;
801076ea:	39 55 0c             	cmp    %edx,0xc(%ebp)
801076ed:	73 ab                	jae    8010769a <fix_addr_place_mmap+0x13a>
801076ef:	89 d6                	mov    %edx,%esi
    upper_bound      = (!is_empty && is_first) ? cur->addr   : upper_bound;
801076f1:	c6 45 f0 01          	movb   $0x1,-0x10(%ebp)
    uint lower_bound = is_first                ? 0x60000000  : cur->addr + cur->length;
801076f5:	ba 00 00 00 60       	mov    $0x60000000,%edx
801076fa:	e9 29 ff ff ff       	jmp    80107628 <fix_addr_place_mmap+0xc8>
801076ff:	90                   	nop
        proc->mmap_head = unused_map;
80107700:	89 97 7c 02 00 00    	mov    %edx,0x27c(%edi)
        unused_map->next = 0;
80107706:	e9 7c fe ff ff       	jmp    80107587 <fix_addr_place_mmap+0x27>
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop

80107710 <find_addr_place_mmap>:
{
80107710:	55                   	push   %ebp
    for(int i = 0; i < MAX_NMMAP;i++)
80107711:	31 d2                	xor    %edx,%edx
{
80107713:	89 e5                	mov    %esp,%ebp
80107715:	57                   	push   %edi
80107716:	56                   	push   %esi
80107717:	53                   	push   %ebx
80107718:	83 ec 0c             	sub    $0xc,%esp
    for(int i = 0; i < MAX_NMMAP;i++)
8010771b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010771e:	66 90                	xchg   %ax,%ax
        int valid = proc->mmaps[i].addr > 0;
80107720:	89 d0                	mov    %edx,%eax
80107722:	c1 e0 05             	shl    $0x5,%eax
        if (!valid)
80107725:	8b 5c 01 7c          	mov    0x7c(%ecx,%eax,1),%ebx
80107729:	85 db                	test   %ebx,%ebx
8010772b:	74 23                	je     80107750 <find_addr_place_mmap+0x40>
    for(int i = 0; i < MAX_NMMAP;i++)
8010772d:	83 c2 01             	add    $0x1,%edx
80107730:	83 fa 10             	cmp    $0x10,%edx
80107733:	75 eb                	jne    80107720 <find_addr_place_mmap+0x10>
        return (struct mmap_region*)0;
80107735:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
}
8010773c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010773f:	83 c4 0c             	add    $0xc,%esp
80107742:	5b                   	pop    %ebx
80107743:	5e                   	pop    %esi
80107744:	5f                   	pop    %edi
80107745:	5d                   	pop    %ebp
80107746:	c3                   	ret    
80107747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010774e:	66 90                	xchg   %ax,%ax
            return &proc->mmaps[i];
80107750:	8b 7d 08             	mov    0x8(%ebp),%edi
    uint addr = 0x60000000;
80107753:	bb 00 00 00 60       	mov    $0x60000000,%ebx
            return &proc->mmaps[i];
80107758:	8d 7c 07 7c          	lea    0x7c(%edi,%eax,1),%edi
    mmap->addr = 0; // note to future changed this from a 0 to a -1
8010775c:	03 45 08             	add    0x8(%ebp),%eax
8010775f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107762:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
    mmap->length = -1;
80107769:	c7 80 80 00 00 00 ff 	movl   $0xffffffff,0x80(%eax)
80107770:	ff ff ff 
    mmap->flags = -1;
80107773:	c7 80 84 00 00 00 ff 	movl   $0xffffffff,0x84(%eax)
8010777a:	ff ff ff 
    mmap->fd = -1;
8010777d:	c7 80 88 00 00 00 ff 	movl   $0xffffffff,0x88(%eax)
80107784:	ff ff ff 
    mmap->f = 0;
80107787:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010778e:	00 00 00 
    mmap->refcnt = 0;
80107791:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80107798:	00 00 00 
    mmap->n_loaded_pages = 0;
8010779b:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
801077a2:	00 00 00 
    mmap->next = 0;
801077a5:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
801077ac:	00 00 00 
    for(cur = proc->mmap_head; cur != 0 && cur->next != 0; cur = cur->next) 
801077af:	8b 45 08             	mov    0x8(%ebp),%eax
            return &proc->mmaps[i];
801077b2:	89 7d f0             	mov    %edi,-0x10(%ebp)
    for(cur = proc->mmap_head; cur != 0 && cur->next != 0; cur = cur->next) 
801077b5:	8b b0 7c 02 00 00    	mov    0x27c(%eax),%esi
801077bb:	85 f6                	test   %esi,%esi
801077bd:	0f 84 9d 00 00 00    	je     80107860 <find_addr_place_mmap+0x150>
801077c3:	89 55 e8             	mov    %edx,-0x18(%ebp)
801077c6:	8b 7d 0c             	mov    0xc(%ebp),%edi
801077c9:	eb 15                	jmp    801077e0 <find_addr_place_mmap+0xd0>
801077cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077cf:	90                   	nop
        if (addr + length < cur->next->addr)
801077d0:	8b 10                	mov    (%eax),%edx
801077d2:	8d 0c 1f             	lea    (%edi,%ebx,1),%ecx
801077d5:	39 d1                	cmp    %edx,%ecx
801077d7:	72 0e                	jb     801077e7 <find_addr_place_mmap+0xd7>
        addr = cur->next->addr + cur->next->length;
801077d9:	8b 58 04             	mov    0x4(%eax),%ebx
801077dc:	89 c6                	mov    %eax,%esi
801077de:	01 d3                	add    %edx,%ebx
    for(cur = proc->mmap_head; cur != 0 && cur->next != 0; cur = cur->next) 
801077e0:	8b 46 1c             	mov    0x1c(%esi),%eax
801077e3:	85 c0                	test   %eax,%eax
801077e5:	75 e9                	jne    801077d0 <find_addr_place_mmap+0xc0>
801077e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
    addr = (addr%PGSIZE==0) ? addr :(addr/PGSIZE+1) * PGSIZE; 
801077ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801077f0:	74 0c                	je     801077fe <find_addr_place_mmap+0xee>
801077f2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801077f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    unused_map->flags         = flags;
801077fe:	8b 45 10             	mov    0x10(%ebp),%eax
    unused_map->addr          = addr;
80107801:	c1 e2 05             	shl    $0x5,%edx
80107804:	03 55 08             	add    0x8(%ebp),%edx
80107807:	89 5a 7c             	mov    %ebx,0x7c(%edx)
    unused_map->flags         = flags;
8010780a:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
    unused_map->length        = length;
80107810:	8b 45 0c             	mov    0xc(%ebp),%eax
80107813:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
    if(!is_empty && cur->addr > addr)
80107819:	39 1e                	cmp    %ebx,(%esi)
8010781b:	77 23                	ja     80107840 <find_addr_place_mmap+0x130>
    else if(!is_empty && cur->next == 0)
8010781d:	8b 46 1c             	mov    0x1c(%esi),%eax
80107820:	85 c0                	test   %eax,%eax
80107822:	74 74                	je     80107898 <find_addr_place_mmap+0x188>
        cur->next = unused_map;
80107824:	8b 7d f0             	mov    -0x10(%ebp),%edi
80107827:	89 7e 1c             	mov    %edi,0x1c(%esi)
        unused_map->next = temp;
8010782a:	8b 7d ec             	mov    -0x14(%ebp),%edi
8010782d:	89 87 98 00 00 00    	mov    %eax,0x98(%edi)
}
80107833:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107836:	83 c4 0c             	add    $0xc,%esp
80107839:	5b                   	pop    %ebx
8010783a:	5e                   	pop    %esi
8010783b:	5f                   	pop    %edi
8010783c:	5d                   	pop    %ebp
8010783d:	c3                   	ret    
8010783e:	66 90                	xchg   %ax,%ax
        proc->mmap_head = unused_map;
80107840:	8b 45 08             	mov    0x8(%ebp),%eax
80107843:	8b 7d f0             	mov    -0x10(%ebp),%edi
80107846:	89 b8 7c 02 00 00    	mov    %edi,0x27c(%eax)
        unused_map->next = cur;
8010784c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010784f:	89 b0 98 00 00 00    	mov    %esi,0x98(%eax)
}
80107855:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107858:	83 c4 0c             	add    $0xc,%esp
8010785b:	5b                   	pop    %ebx
8010785c:	5e                   	pop    %esi
8010785d:	5f                   	pop    %edi
8010785e:	5d                   	pop    %ebp
8010785f:	c3                   	ret    
    unused_map->addr          = addr;
80107860:	8b 45 ec             	mov    -0x14(%ebp),%eax
    unused_map->flags         = flags;
80107863:	8b 7d 10             	mov    0x10(%ebp),%edi
80107866:	89 b8 84 00 00 00    	mov    %edi,0x84(%eax)
    unused_map->length        = length;
8010786c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    unused_map->addr          = addr;
8010786f:	c7 40 7c 00 00 00 60 	movl   $0x60000000,0x7c(%eax)
    unused_map->length        = length;
80107876:	89 b8 80 00 00 00    	mov    %edi,0x80(%eax)
        proc->mmap_head = unused_map;
8010787c:	8b 45 08             	mov    0x8(%ebp),%eax
8010787f:	8b 7d f0             	mov    -0x10(%ebp),%edi
80107882:	89 b8 7c 02 00 00    	mov    %edi,0x27c(%eax)
}
80107888:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010788b:	83 c4 0c             	add    $0xc,%esp
8010788e:	5b                   	pop    %ebx
8010788f:	5e                   	pop    %esi
80107890:	5f                   	pop    %edi
80107891:	5d                   	pop    %ebp
80107892:	c3                   	ret    
80107893:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107897:	90                   	nop
        cur->next = unused_map;
80107898:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010789b:	89 46 1c             	mov    %eax,0x1c(%esi)
        unused_map->next = 0;
8010789e:	8b 45 ec             	mov    -0x14(%ebp),%eax
801078a1:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
801078a8:	00 00 00 
}
801078ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078ae:	83 c4 0c             	add    $0xc,%esp
801078b1:	5b                   	pop    %ebx
801078b2:	5e                   	pop    %esi
801078b3:	5f                   	pop    %edi
801078b4:	5d                   	pop    %ebp
801078b5:	c3                   	ret    
801078b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078bd:	8d 76 00             	lea    0x0(%esi),%esi

801078c0 <sys_wmap>:
int sys_wmap(void) {
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	57                   	push   %edi
801078c4:	56                   	push   %esi
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0 || argint(2, &flags) < 0) {
801078c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
int sys_wmap(void) {
801078c8:	53                   	push   %ebx
801078c9:	83 ec 34             	sub    $0x34,%esp
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0 || argint(2, &flags) < 0) {
801078cc:	50                   	push   %eax
801078cd:	6a 00                	push   $0x0
801078cf:	e8 7c d0 ff ff       	call   80104950 <argint>
801078d4:	83 c4 10             	add    $0x10,%esp
801078d7:	85 c0                	test   %eax,%eax
801078d9:	0f 88 f9 00 00 00    	js     801079d8 <sys_wmap+0x118>
801078df:	83 ec 08             	sub    $0x8,%esp
801078e2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801078e5:	50                   	push   %eax
801078e6:	6a 01                	push   $0x1
801078e8:	e8 63 d0 ff ff       	call   80104950 <argint>
801078ed:	83 c4 10             	add    $0x10,%esp
801078f0:	85 c0                	test   %eax,%eax
801078f2:	0f 88 e0 00 00 00    	js     801079d8 <sys_wmap+0x118>
801078f8:	83 ec 08             	sub    $0x8,%esp
801078fb:	8d 45 dc             	lea    -0x24(%ebp),%eax
801078fe:	50                   	push   %eax
801078ff:	6a 02                	push   $0x2
80107901:	e8 4a d0 ff ff       	call   80104950 <argint>
80107906:	83 c4 10             	add    $0x10,%esp
80107909:	85 c0                	test   %eax,%eax
8010790b:	0f 88 c7 00 00 00    	js     801079d8 <sys_wmap+0x118>
    if (argfd(3, &fd, &f) < 0) {
80107911:	83 ec 04             	sub    $0x4,%esp
80107914:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107917:	50                   	push   %eax
80107918:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010791b:	50                   	push   %eax
8010791c:	6a 03                	push   $0x3
8010791e:	e8 7d d3 ff ff       	call   80104ca0 <argfd>
80107923:	83 c4 10             	add    $0x10,%esp
80107926:	85 c0                	test   %eax,%eax
80107928:	0f 89 8a 00 00 00    	jns    801079b8 <sys_wmap+0xf8>
        fd = -1;
8010792e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
        f = 0;
80107935:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010793a:	31 c0                	xor    %eax,%eax
8010793c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (validate_input(addr, length, flags, fd, f) < 0) {
80107943:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80107946:	8b 75 d8             	mov    -0x28(%ebp),%esi
80107949:	83 ec 0c             	sub    $0xc,%esp
8010794c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
8010794f:	50                   	push   %eax
80107950:	52                   	push   %edx
80107951:	53                   	push   %ebx
80107952:	56                   	push   %esi
80107953:	57                   	push   %edi
80107954:	e8 77 fb ff ff       	call   801074d0 <validate_input>
80107959:	83 c4 20             	add    $0x20,%esp
8010795c:	85 c0                	test   %eax,%eax
8010795e:	0f 88 92 00 00 00    	js     801079f6 <sys_wmap+0x136>
    if(fixed)
80107964:	f6 c3 08             	test   $0x8,%bl
80107967:	75 37                	jne    801079a0 <sys_wmap+0xe0>
        mapping = find_addr_place_mmap(myproc(),length,flags);
80107969:	e8 12 c0 ff ff       	call   80103980 <myproc>
8010796e:	83 ec 04             	sub    $0x4,%esp
80107971:	53                   	push   %ebx
80107972:	56                   	push   %esi
80107973:	50                   	push   %eax
80107974:	e8 97 fd ff ff       	call   80107710 <find_addr_place_mmap>
80107979:	83 c4 10             	add    $0x10,%esp
    if(mapping == 0)
8010797c:	85 c0                	test   %eax,%eax
8010797e:	74 6f                	je     801079ef <sys_wmap+0x12f>
    mapping->f  = f;
80107980:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107983:	89 50 10             	mov    %edx,0x10(%eax)
    mapping->fd = fd;
80107986:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107989:	89 50 0c             	mov    %edx,0xc(%eax)
    return mapping->addr;
8010798c:	8b 00                	mov    (%eax),%eax
}
8010798e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107991:	5b                   	pop    %ebx
80107992:	5e                   	pop    %esi
80107993:	5f                   	pop    %edi
80107994:	5d                   	pop    %ebp
80107995:	c3                   	ret    
80107996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010799d:	8d 76 00             	lea    0x0(%esi),%esi
        mapping = fix_addr_place_mmap(myproc(),addr,length,flags);
801079a0:	e8 db bf ff ff       	call   80103980 <myproc>
801079a5:	53                   	push   %ebx
801079a6:	56                   	push   %esi
801079a7:	57                   	push   %edi
801079a8:	50                   	push   %eax
801079a9:	e8 b2 fb ff ff       	call   80107560 <fix_addr_place_mmap>
801079ae:	83 c4 10             	add    $0x10,%esp
801079b1:	eb c9                	jmp    8010797c <sys_wmap+0xbc>
801079b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079b7:	90                   	nop
        f = filedup(f);
801079b8:	83 ec 0c             	sub    $0xc,%esp
801079bb:	ff 75 e4             	push   -0x1c(%ebp)
801079be:	e8 dd 94 ff ff       	call   80100ea0 <filedup>
    if (validate_input(addr, length, flags, fd, f) < 0) {
801079c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
801079c6:	83 c4 10             	add    $0x10,%esp
        f = filedup(f);
801079c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079cc:	e9 72 ff ff ff       	jmp    80107943 <sys_wmap+0x83>
801079d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf("wmap arg ERROR: size or flags\n");
801079d8:	83 ec 0c             	sub    $0xc,%esp
801079db:	68 f8 90 10 80       	push   $0x801090f8
801079e0:	e8 bb 8c ff ff       	call   801006a0 <cprintf>
        return FAILED;
801079e5:	83 c4 10             	add    $0x10,%esp
801079e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079ed:	eb 9f                	jmp    8010798e <sys_wmap+0xce>
        return FAILED;
801079ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079f4:	eb 98                	jmp    8010798e <sys_wmap+0xce>
        cprintf("wmap ERROR: invalid input\n");
801079f6:	83 ec 0c             	sub    $0xc,%esp
801079f9:	68 92 90 10 80       	push   $0x80109092
801079fe:	e8 9d 8c ff ff       	call   801006a0 <cprintf>
        return FAILED;
80107a03:	83 c4 10             	add    $0x10,%esp
80107a06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a0b:	eb 81                	jmp    8010798e <sys_wmap+0xce>
80107a0d:	8d 76 00             	lea    0x0(%esi),%esi

80107a10 <write_to_file>:
int write_to_file(struct file *f, uint va, int offset, int n_bytes) {
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	57                   	push   %edi
80107a14:	56                   	push   %esi
80107a15:	53                   	push   %ebx
    int i = 0;
80107a16:	31 db                	xor    %ebx,%ebx
int write_to_file(struct file *f, uint va, int offset, int n_bytes) {
80107a18:	83 ec 1c             	sub    $0x1c,%esp
    while (i < n_bytes) {
80107a1b:	8b 45 14             	mov    0x14(%ebp),%eax
int write_to_file(struct file *f, uint va, int offset, int n_bytes) {
80107a1e:	8b 75 08             	mov    0x8(%ebp),%esi
    while (i < n_bytes) {
80107a21:	85 c0                	test   %eax,%eax
80107a23:	7f 32                	jg     80107a57 <write_to_file+0x47>
80107a25:	e9 96 00 00 00       	jmp    80107ac0 <write_to_file+0xb0>
80107a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        iunlock(f->ip);
80107a30:	83 ec 0c             	sub    $0xc,%esp
80107a33:	ff 76 10             	push   0x10(%esi)
            offset += r;
80107a36:	01 45 10             	add    %eax,0x10(%ebp)
80107a39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        iunlock(f->ip);
80107a3c:	e8 1f 9e ff ff       	call   80101860 <iunlock>
        end_op();
80107a41:	e8 8a b3 ff ff       	call   80102dd0 <end_op>
        if (r != n1)
80107a46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a49:	83 c4 10             	add    $0x10,%esp
80107a4c:	39 c7                	cmp    %eax,%edi
80107a4e:	75 5c                	jne    80107aac <write_to_file+0x9c>
        i += r;
80107a50:	01 fb                	add    %edi,%ebx
    while (i < n_bytes) {
80107a52:	39 5d 14             	cmp    %ebx,0x14(%ebp)
80107a55:	7e 69                	jle    80107ac0 <write_to_file+0xb0>
        int n1 = n_bytes - i;
80107a57:	8b 7d 14             	mov    0x14(%ebp),%edi
80107a5a:	b8 00 06 00 00       	mov    $0x600,%eax
80107a5f:	29 df                	sub    %ebx,%edi
80107a61:	39 c7                	cmp    %eax,%edi
80107a63:	0f 4f f8             	cmovg  %eax,%edi
        begin_op();
80107a66:	e8 f5 b2 ff ff       	call   80102d60 <begin_op>
        ilock(f->ip);
80107a6b:	83 ec 0c             	sub    $0xc,%esp
80107a6e:	ff 76 10             	push   0x10(%esi)
80107a71:	e8 0a 9d ff ff       	call   80101780 <ilock>
        if ((r = writei(f->ip, (char *)va + i, offset, n1)) > 0)
80107a76:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a79:	57                   	push   %edi
80107a7a:	ff 75 10             	push   0x10(%ebp)
80107a7d:	01 d8                	add    %ebx,%eax
80107a7f:	50                   	push   %eax
80107a80:	ff 76 10             	push   0x10(%esi)
80107a83:	e8 08 a1 ff ff       	call   80101b90 <writei>
80107a88:	83 c4 20             	add    $0x20,%esp
80107a8b:	85 c0                	test   %eax,%eax
80107a8d:	7f a1                	jg     80107a30 <write_to_file+0x20>
        iunlock(f->ip);
80107a8f:	83 ec 0c             	sub    $0xc,%esp
80107a92:	ff 76 10             	push   0x10(%esi)
80107a95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a98:	e8 c3 9d ff ff       	call   80101860 <iunlock>
        end_op();
80107a9d:	e8 2e b3 ff ff       	call   80102dd0 <end_op>
        if (r < 0)
80107aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107aa5:	83 c4 10             	add    $0x10,%esp
80107aa8:	85 c0                	test   %eax,%eax
80107aaa:	75 24                	jne    80107ad0 <write_to_file+0xc0>
            panic("wmap: short filewrite");
80107aac:	83 ec 0c             	sub    $0xc,%esp
80107aaf:	68 ad 90 10 80       	push   $0x801090ad
80107ab4:	e8 c7 88 ff ff       	call   80100380 <panic>
80107ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    r = (i == n_bytes ? n_bytes : -1);
80107ac0:	39 5d 14             	cmp    %ebx,0x14(%ebp)
80107ac3:	75 0b                	jne    80107ad0 <write_to_file+0xc0>
}
80107ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ac8:	89 d8                	mov    %ebx,%eax
80107aca:	5b                   	pop    %ebx
80107acb:	5e                   	pop    %esi
80107acc:	5f                   	pop    %edi
80107acd:	5d                   	pop    %ebp
80107ace:	c3                   	ret    
80107acf:	90                   	nop
80107ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    r = (i == n_bytes ? n_bytes : -1);
80107ad3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80107ad8:	89 d8                	mov    %ebx,%eax
80107ada:	5b                   	pop    %ebx
80107adb:	5e                   	pop    %esi
80107adc:	5f                   	pop    %edi
80107add:	5d                   	pop    %ebp
80107ade:	c3                   	ret    
80107adf:	90                   	nop

80107ae0 <remove_physical_map>:
{
80107ae0:	55                   	push   %ebp
80107ae1:	89 e5                	mov    %esp,%ebp
80107ae3:	57                   	push   %edi
80107ae4:	56                   	push   %esi
80107ae5:	53                   	push   %ebx
80107ae6:	83 ec 1c             	sub    $0x1c,%esp
80107ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
    int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;
80107aec:	85 c0                	test   %eax,%eax
80107aee:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80107af4:	0f 49 d0             	cmovns %eax,%edx
80107af7:	25 ff 0f 00 00       	and    $0xfff,%eax
80107afc:	c1 fa 0c             	sar    $0xc,%edx
80107aff:	83 f8 01             	cmp    $0x1,%eax
80107b02:	83 da ff             	sbb    $0xffffffff,%edx
    for(int i = 0; i < repeat;i++)
80107b05:	85 d2                	test   %edx,%edx
80107b07:	0f 8e c3 00 00 00    	jle    80107bd0 <remove_physical_map+0xf0>
80107b0d:	31 ff                	xor    %edi,%edi
    int count = 0;
80107b0f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107b16:	8b 75 08             	mov    0x8(%ebp),%esi
80107b19:	89 fb                	mov    %edi,%ebx
80107b1b:	89 d7                	mov    %edx,%edi
80107b1d:	eb 0e                	jmp    80107b2d <remove_physical_map+0x4d>
80107b1f:	90                   	nop
    for(int i = 0; i < repeat;i++)
80107b20:	83 c3 01             	add    $0x1,%ebx
80107b23:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b29:	39 df                	cmp    %ebx,%edi
80107b2b:	74 5e                	je     80107b8b <remove_physical_map+0xab>
        pte_t *pte = walkpgdir(myproc()->pgdir, (void*)(addr + i * PGSIZE), 0);
80107b2d:	e8 4e be ff ff       	call   80103980 <myproc>
80107b32:	83 ec 04             	sub    $0x4,%esp
80107b35:	6a 00                	push   $0x0
80107b37:	56                   	push   %esi
80107b38:	ff 70 04             	push   0x4(%eax)
80107b3b:	e8 70 ee ff ff       	call   801069b0 <walkpgdir>
        if (pte == 0) continue;
80107b40:	83 c4 10             	add    $0x10,%esp
        pte_t *pte = walkpgdir(myproc()->pgdir, (void*)(addr + i * PGSIZE), 0);
80107b43:	89 c2                	mov    %eax,%edx
        if (pte == 0) continue;
80107b45:	85 c0                	test   %eax,%eax
80107b47:	74 d7                	je     80107b20 <remove_physical_map+0x40>
        if ((*pte & PTE_P) == 0) continue;
80107b49:	8b 00                	mov    (%eax),%eax
80107b4b:	a8 01                	test   $0x1,%al
80107b4d:	74 d1                	je     80107b20 <remove_physical_map+0x40>
        count++;
80107b4f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
        if(remove == 1)
80107b53:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
80107b57:	75 c7                	jne    80107b20 <remove_physical_map+0x40>
            if ((map->flags & MAP_ANONYMOUS) == 0 && (map->flags & MAP_SHARED) == 0)
80107b59:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107b5c:	f6 41 08 06          	testb  $0x6,0x8(%ecx)
80107b60:	74 3e                	je     80107ba0 <remove_physical_map+0xc0>
            uint physical_address = PTE_ADDR(*pte);
80107b62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(P2V(physical_address));
80107b67:	83 ec 0c             	sub    $0xc,%esp
            *pte = 0;
80107b6a:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    for(int i = 0; i < repeat;i++)
80107b70:	83 c3 01             	add    $0x1,%ebx
            kfree(P2V(physical_address));
80107b73:	05 00 00 00 80       	add    $0x80000000,%eax
    for(int i = 0; i < repeat;i++)
80107b78:	81 c6 00 10 00 00    	add    $0x1000,%esi
            kfree(P2V(physical_address));
80107b7e:	50                   	push   %eax
80107b7f:	e8 3c a9 ff ff       	call   801024c0 <kfree>
80107b84:	83 c4 10             	add    $0x10,%esp
    for(int i = 0; i < repeat;i++)
80107b87:	39 df                	cmp    %ebx,%edi
80107b89:	75 a2                	jne    80107b2d <remove_physical_map+0x4d>
}
80107b8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b91:	5b                   	pop    %ebx
80107b92:	5e                   	pop    %esi
80107b93:	5f                   	pop    %edi
80107b94:	5d                   	pop    %ebp
80107b95:	c3                   	ret    
80107b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b9d:	8d 76 00             	lea    0x0(%esi),%esi
                write_to_file(map->f,map->addr + i * PGSIZE,map->f->off * i * PGSIZE,PGSIZE);
80107ba0:	8b 49 10             	mov    0x10(%ecx),%ecx
80107ba3:	68 00 10 00 00       	push   $0x1000
80107ba8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107bab:	8b 55 14             	mov    0x14(%ebp),%edx
80107bae:	8b 41 14             	mov    0x14(%ecx),%eax
80107bb1:	0f af c3             	imul   %ebx,%eax
80107bb4:	c1 e0 0c             	shl    $0xc,%eax
80107bb7:	50                   	push   %eax
80107bb8:	89 d8                	mov    %ebx,%eax
80107bba:	c1 e0 0c             	shl    $0xc,%eax
80107bbd:	03 02                	add    (%edx),%eax
80107bbf:	50                   	push   %eax
80107bc0:	51                   	push   %ecx
80107bc1:	e8 4a fe ff ff       	call   80107a10 <write_to_file>
            uint physical_address = PTE_ADDR(*pte);
80107bc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107bc9:	83 c4 10             	add    $0x10,%esp
80107bcc:	8b 02                	mov    (%edx),%eax
80107bce:	eb 92                	jmp    80107b62 <remove_physical_map+0x82>
    int count = 0;
80107bd0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bdd:	5b                   	pop    %ebx
80107bde:	5e                   	pop    %esi
80107bdf:	5f                   	pop    %edi
80107be0:	5d                   	pop    %ebp
80107be1:	c3                   	ret    
80107be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107bf0 <remove_map>:
{
80107bf0:	55                   	push   %ebp
80107bf1:	89 e5                	mov    %esp,%ebp
80107bf3:	57                   	push   %edi
80107bf4:	56                   	push   %esi
80107bf5:	53                   	push   %ebx
80107bf6:	83 ec 1c             	sub    $0x1c,%esp
80107bf9:	8b 75 08             	mov    0x8(%ebp),%esi
    struct proc* p = myproc();
80107bfc:	e8 7f bd ff ff       	call   80103980 <myproc>
    struct mmap_region* cur_node = p->mmap_head;
80107c01:	8b 98 7c 02 00 00    	mov    0x27c(%eax),%ebx
    struct proc* p = myproc();
80107c07:	89 c7                	mov    %eax,%edi
    for(int i = 0; cur_node != 0 && cur_node->next != 0;i++)
80107c09:	eb 0f                	jmp    80107c1a <remove_map+0x2a>
80107c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c0f:	90                   	nop
        if(cur_node->addr > addr)
80107c10:	39 c6                	cmp    %eax,%esi
80107c12:	72 5c                	jb     80107c70 <remove_map+0x80>
        if(cur_node->next->addr == addr)
80107c14:	39 32                	cmp    %esi,(%edx)
80107c16:	74 68                	je     80107c80 <remove_map+0x90>
80107c18:	89 d3                	mov    %edx,%ebx
    for(int i = 0; cur_node != 0 && cur_node->next != 0;i++)
80107c1a:	85 db                	test   %ebx,%ebx
80107c1c:	0f 84 00 0a 00 00    	je     80108622 <remove_map.cold>
80107c22:	8b 53 1c             	mov    0x1c(%ebx),%edx
        if(cur_node->addr > addr)
80107c25:	8b 03                	mov    (%ebx),%eax
    for(int i = 0; cur_node != 0 && cur_node->next != 0;i++)
80107c27:	85 d2                	test   %edx,%edx
80107c29:	75 e5                	jne    80107c10 <remove_map+0x20>
    if(cur_node->addr == addr)
80107c2b:	39 c6                	cmp    %eax,%esi
80107c2d:	75 41                	jne    80107c70 <remove_map+0x80>
        int should_remove = cur_node->refcnt<=0;
80107c2f:	8b 43 14             	mov    0x14(%ebx),%eax
80107c32:	31 d2                	xor    %edx,%edx
        cur_node->next->n_loaded_pages -= should_remove * remove_physical_map(addr,cur_node->length,should_remove,cur_node);
80107c34:	53                   	push   %ebx
        int should_remove = cur_node->refcnt<=0;
80107c35:	85 c0                	test   %eax,%eax
80107c37:	0f 9e c2             	setle  %dl
        cur_node->next->n_loaded_pages -= should_remove * remove_physical_map(addr,cur_node->length,should_remove,cur_node);
80107c3a:	52                   	push   %edx
80107c3b:	ff 73 04             	push   0x4(%ebx)
80107c3e:	56                   	push   %esi
80107c3f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107c42:	e8 99 fe ff ff       	call   80107ae0 <remove_physical_map>
80107c47:	8b 4b 1c             	mov    0x1c(%ebx),%ecx
80107c4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        return 0;
80107c4d:	83 c4 10             	add    $0x10,%esp
        cur_node->next->n_loaded_pages -= should_remove * remove_physical_map(addr,cur_node->length,should_remove,cur_node);
80107c50:	0f af c2             	imul   %edx,%eax
80107c53:	29 41 18             	sub    %eax,0x18(%ecx)
        p->mmap_head = cur_node->next;
80107c56:	8b 43 1c             	mov    0x1c(%ebx),%eax
80107c59:	89 87 7c 02 00 00    	mov    %eax,0x27c(%edi)
}
80107c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
80107c62:	31 c0                	xor    %eax,%eax
}
80107c64:	5b                   	pop    %ebx
80107c65:	5e                   	pop    %esi
80107c66:	5f                   	pop    %edi
80107c67:	5d                   	pop    %ebp
80107c68:	c3                   	ret    
80107c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return FAILED;
80107c73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c78:	5b                   	pop    %ebx
80107c79:	5e                   	pop    %esi
80107c7a:	5f                   	pop    %edi
80107c7b:	5d                   	pop    %ebp
80107c7c:	c3                   	ret    
80107c7d:	8d 76 00             	lea    0x0(%esi),%esi
            int should_remove = cur_node->refcnt<=0;
80107c80:	8b 4b 14             	mov    0x14(%ebx),%ecx
80107c83:	31 c0                	xor    %eax,%eax
            cur_node->next->n_loaded_pages -= should_remove * remove_physical_map(addr,cur_node->next->length,should_remove,cur_node);
80107c85:	53                   	push   %ebx
            int should_remove = cur_node->refcnt<=0;
80107c86:	85 c9                	test   %ecx,%ecx
80107c88:	0f 9e c0             	setle  %al
80107c8b:	89 c7                	mov    %eax,%edi
            cur_node->next->n_loaded_pages -= should_remove * remove_physical_map(addr,cur_node->next->length,should_remove,cur_node);
80107c8d:	57                   	push   %edi
80107c8e:	ff 72 04             	push   0x4(%edx)
80107c91:	56                   	push   %esi
80107c92:	e8 49 fe ff ff       	call   80107ae0 <remove_physical_map>
80107c97:	8b 53 1c             	mov    0x1c(%ebx),%edx
            return 0;
80107c9a:	83 c4 10             	add    $0x10,%esp
            cur_node->next->n_loaded_pages -= should_remove * remove_physical_map(addr,cur_node->next->length,should_remove,cur_node);
80107c9d:	0f af c7             	imul   %edi,%eax
80107ca0:	29 42 18             	sub    %eax,0x18(%edx)
            cur_node->next = cur_node->next->next;   
80107ca3:	8b 43 1c             	mov    0x1c(%ebx),%eax
80107ca6:	8b 40 1c             	mov    0x1c(%eax),%eax
80107ca9:	89 43 1c             	mov    %eax,0x1c(%ebx)
}
80107cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80107caf:	31 c0                	xor    %eax,%eax
}
80107cb1:	5b                   	pop    %ebx
80107cb2:	5e                   	pop    %esi
80107cb3:	5f                   	pop    %edi
80107cb4:	5d                   	pop    %ebp
80107cb5:	c3                   	ret    
80107cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cbd:	8d 76 00             	lea    0x0(%esi),%esi

80107cc0 <sys_wunmap>:
int sys_wunmap(void) {
80107cc0:	55                   	push   %ebp
80107cc1:	89 e5                	mov    %esp,%ebp
80107cc3:	83 ec 20             	sub    $0x20,%esp
    if (argint(0, (int *)&addr) < 0) {
80107cc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107cc9:	50                   	push   %eax
80107cca:	6a 00                	push   $0x0
80107ccc:	e8 7f cc ff ff       	call   80104950 <argint>
80107cd1:	83 c4 10             	add    $0x10,%esp
80107cd4:	85 c0                	test   %eax,%eax
80107cd6:	78 3f                	js     80107d17 <sys_wunmap+0x57>
    if (addr % PGSIZE != 0) {
80107cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107ce0:	75 1e                	jne    80107d00 <sys_wunmap+0x40>
    if (remove_map(addr) < 0) {
80107ce2:	83 ec 0c             	sub    $0xc,%esp
80107ce5:	50                   	push   %eax
80107ce6:	e8 05 ff ff ff       	call   80107bf0 <remove_map>
80107ceb:	83 c4 10             	add    $0x10,%esp
80107cee:	85 c0                	test   %eax,%eax
80107cf0:	78 3c                	js     80107d2e <sys_wunmap+0x6e>
}
80107cf2:	c9                   	leave  
    return 0;
80107cf3:	31 c0                	xor    %eax,%eax
}
80107cf5:	c3                   	ret    
80107cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cfd:	8d 76 00             	lea    0x0(%esi),%esi
        cprintf("wunmap ERROR: addr not page aligned\n");
80107d00:	83 ec 0c             	sub    $0xc,%esp
80107d03:	68 18 91 10 80       	push   $0x80109118
80107d08:	e8 93 89 ff ff       	call   801006a0 <cprintf>
        return FAILED;
80107d0d:	83 c4 10             	add    $0x10,%esp
80107d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d15:	c9                   	leave  
80107d16:	c3                   	ret    
        cprintf("wunmap arg ERROR: addr\n");
80107d17:	83 ec 0c             	sub    $0xc,%esp
80107d1a:	68 c3 90 10 80       	push   $0x801090c3
80107d1f:	e8 7c 89 ff ff       	call   801006a0 <cprintf>
        return FAILED;
80107d24:	83 c4 10             	add    $0x10,%esp
80107d27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d2c:	c9                   	leave  
80107d2d:	c3                   	ret    
        cprintf("wunmap ERROR: unmap failed\n");
80107d2e:	83 ec 0c             	sub    $0xc,%esp
80107d31:	68 db 90 10 80       	push   $0x801090db
80107d36:	e8 65 89 ff ff       	call   801006a0 <cprintf>
        return FAILED;
80107d3b:	83 c4 10             	add    $0x10,%esp
80107d3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d43:	c9                   	leave  
80107d44:	c3                   	ret    
80107d45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107d50 <sys_wpunmap>:
int sys_wpunmap(void) {
80107d50:	55                   	push   %ebp
80107d51:	89 e5                	mov    %esp,%ebp
80107d53:	57                   	push   %edi
80107d54:	56                   	push   %esi
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0) {
80107d55:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_wpunmap(void) {
80107d58:	53                   	push   %ebx
80107d59:	83 ec 34             	sub    $0x34,%esp
    if (argint(0, (int *)&addr) < 0 || argint(1, &length) < 0) {
80107d5c:	50                   	push   %eax
80107d5d:	6a 00                	push   $0x0
80107d5f:	e8 ec cb ff ff       	call   80104950 <argint>
80107d64:	83 c4 10             	add    $0x10,%esp
80107d67:	85 c0                	test   %eax,%eax
80107d69:	0f 88 84 02 00 00    	js     80107ff3 <sys_wpunmap+0x2a3>
80107d6f:	83 ec 08             	sub    $0x8,%esp
80107d72:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107d75:	50                   	push   %eax
80107d76:	6a 01                	push   $0x1
80107d78:	e8 d3 cb ff ff       	call   80104950 <argint>
80107d7d:	83 c4 10             	add    $0x10,%esp
80107d80:	85 c0                	test   %eax,%eax
80107d82:	0f 88 6b 02 00 00    	js     80107ff3 <sys_wpunmap+0x2a3>
    if ((addr+length) % PGSIZE != 0) {
80107d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107d8e:	01 c2                	add    %eax,%edx
80107d90:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80107d96:	0f 85 8b 02 00 00    	jne    80108027 <sys_wpunmap+0x2d7>
    if (length <= 0){
80107d9c:	85 c0                	test   %eax,%eax
80107d9e:	0f 8e 69 02 00 00    	jle    8010800d <sys_wpunmap+0x2bd>
    struct proc* p = myproc();
80107da4:	e8 d7 bb ff ff       	call   80103980 <myproc>
    struct mmap_region* cur_node = p->mmap_head;
80107da9:	8b 98 7c 02 00 00    	mov    0x27c(%eax),%ebx
    struct proc* p = myproc();
80107daf:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for(int i = 0; cur_node != 0;i++)
80107db2:	85 db                	test   %ebx,%ebx
80107db4:	0f 84 6f 08 00 00    	je     80108629 <sys_wpunmap.cold>
        int upper_bound = addr + length <= cur_node->addr + cur_node->length;
80107dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        int lower_bound = addr          >= cur_node->addr;
80107dbd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    struct mmap_region* prev_node = 0;
80107dc0:	31 f6                	xor    %esi,%esi
        int upper_bound = addr + length <= cur_node->addr + cur_node->length;
80107dc2:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107dc5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
80107dc8:	eb 15                	jmp    80107ddf <sys_wpunmap+0x8f>
80107dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cur_node = cur_node->next;
80107dd0:	8b 43 1c             	mov    0x1c(%ebx),%eax
    for(int i = 0; cur_node != 0;i++)
80107dd3:	89 de                	mov    %ebx,%esi
80107dd5:	85 c0                	test   %eax,%eax
80107dd7:	0f 84 64 02 00 00    	je     80108041 <sys_wpunmap+0x2f1>
80107ddd:	89 c3                	mov    %eax,%ebx
        int lower_bound = addr          >= cur_node->addr;
80107ddf:	8b 03                	mov    (%ebx),%eax
        int upper_bound = addr + length <= cur_node->addr + cur_node->length;
80107de1:	8b 53 04             	mov    0x4(%ebx),%edx
80107de4:	01 c2                	add    %eax,%edx
        if(lower_bound && upper_bound)
80107de6:	39 c8                	cmp    %ecx,%eax
80107de8:	77 e6                	ja     80107dd0 <sys_wpunmap+0x80>
80107dea:	39 d7                	cmp    %edx,%edi
80107dec:	77 e2                	ja     80107dd0 <sys_wpunmap+0x80>
    int lower_is_equal = addr == cur_node->addr;
80107dee:	39 c8                	cmp    %ecx,%eax
80107df0:	0f 94 45 d4          	sete   -0x2c(%ebp)
    int upper_is_equal = addr + length == cur_node->addr + cur_node->length;
80107df4:	39 d7                	cmp    %edx,%edi
80107df6:	0f 94 45 d0          	sete   -0x30(%ebp)
    if(lower_is_equal && upper_is_equal)
80107dfa:	80 7d d4 00          	cmpb   $0x0,-0x2c(%ebp)
80107dfe:	74 06                	je     80107e06 <sys_wpunmap+0xb6>
80107e00:	80 7d d0 00          	cmpb   $0x0,-0x30(%ebp)
80107e04:	75 72                	jne    80107e78 <sys_wpunmap+0x128>
    else if(!lower_is_equal && upper_is_equal)
80107e06:	39 c8                	cmp    %ecx,%eax
80107e08:	74 0a                	je     80107e14 <sys_wpunmap+0xc4>
80107e0a:	80 7d d0 00          	cmpb   $0x0,-0x30(%ebp)
80107e0e:	0f 85 94 00 00 00    	jne    80107ea8 <sys_wpunmap+0x158>
    else if(lower_is_equal && !upper_is_equal)
80107e14:	39 d7                	cmp    %edx,%edi
80107e16:	74 20                	je     80107e38 <sys_wpunmap+0xe8>
80107e18:	80 7d d4 00          	cmpb   $0x0,-0x2c(%ebp)
80107e1c:	0f 85 be 00 00 00    	jne    80107ee0 <sys_wpunmap+0x190>
    else if (!lower_is_equal && !upper_is_equal)
80107e22:	80 7d d0 00          	cmpb   $0x0,-0x30(%ebp)
80107e26:	74 18                	je     80107e40 <sys_wpunmap+0xf0>
        return 0;
80107e28:	31 c0                	xor    %eax,%eax
}
80107e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e2d:	5b                   	pop    %ebx
80107e2e:	5e                   	pop    %esi
80107e2f:	5f                   	pop    %edi
80107e30:	5d                   	pop    %ebp
80107e31:	c3                   	ret    
80107e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if (!lower_is_equal && !upper_is_equal)
80107e38:	80 7d d4 00          	cmpb   $0x0,-0x2c(%ebp)
80107e3c:	75 ea                	jne    80107e28 <sys_wpunmap+0xd8>
80107e3e:	eb e2                	jmp    80107e22 <sys_wpunmap+0xd2>
        struct mmap_region* unused_map = find_unused_mmap(myproc()); 
80107e40:	e8 3b bb ff ff       	call   80103980 <myproc>
    for(int i = 0; i < MAX_NMMAP;i++)
80107e45:	31 c9                	xor    %ecx,%ecx
        struct mmap_region* unused_map = find_unused_mmap(myproc()); 
80107e47:	89 c2                	mov    %eax,%edx
    for(int i = 0; i < MAX_NMMAP;i++)
80107e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        int valid = proc->mmaps[i].addr > 0;
80107e50:	89 c8                	mov    %ecx,%eax
80107e52:	c1 e0 05             	shl    $0x5,%eax
        if (!valid)
80107e55:	8b 7c 02 7c          	mov    0x7c(%edx,%eax,1),%edi
80107e59:	85 ff                	test   %edi,%edi
80107e5b:	0f 84 a4 00 00 00    	je     80107f05 <sys_wpunmap+0x1b5>
    for(int i = 0; i < MAX_NMMAP;i++)
80107e61:	83 c1 01             	add    $0x1,%ecx
80107e64:	83 f9 10             	cmp    $0x10,%ecx
80107e67:	75 e7                	jne    80107e50 <sys_wpunmap+0x100>
            cur_node->n_loaded_pages -= remove_physical_map(cur_node->addr,cur_node->length,1,cur_node);
80107e69:	53                   	push   %ebx
80107e6a:	6a 01                	push   $0x1
80107e6c:	ff 73 04             	push   0x4(%ebx)
80107e6f:	ff 33                	push   (%ebx)
80107e71:	eb 0c                	jmp    80107e7f <sys_wpunmap+0x12f>
80107e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107e77:	90                   	nop
        cur_node->n_loaded_pages -= remove_physical_map(addr,length,1,cur_node);
80107e78:	53                   	push   %ebx
80107e79:	6a 01                	push   $0x1
80107e7b:	ff 75 cc             	push   -0x34(%ebp)
80107e7e:	51                   	push   %ecx
            cur_node->n_loaded_pages -= remove_physical_map(cur_node->addr,cur_node->length,1,cur_node);
80107e7f:	e8 5c fc ff ff       	call   80107ae0 <remove_physical_map>
            if(prev_node == 0) // this means its first :D
80107e84:	83 c4 10             	add    $0x10,%esp
            cur_node->n_loaded_pages -= remove_physical_map(cur_node->addr,cur_node->length,1,cur_node);
80107e87:	29 43 18             	sub    %eax,0x18(%ebx)
            if(prev_node == 0) // this means its first :D
80107e8a:	85 f6                	test   %esi,%esi
80107e8c:	75 9a                	jne    80107e28 <sys_wpunmap+0xd8>
                p->mmap_head->next = cur_node->next;
80107e8e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80107e91:	8b 53 1c             	mov    0x1c(%ebx),%edx
80107e94:	8b 80 7c 02 00 00    	mov    0x27c(%eax),%eax
80107e9a:	89 50 1c             	mov    %edx,0x1c(%eax)
            return 0;
80107e9d:	31 c0                	xor    %eax,%eax
80107e9f:	eb 89                	jmp    80107e2a <sys_wpunmap+0xda>
80107ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cur_node->length = length1;
80107ea8:	8b 45 cc             	mov    -0x34(%ebp),%eax
80107eab:	89 43 04             	mov    %eax,0x4(%ebx)
        cur_node->n_loaded_pages -= remove_physical_map(addr,length,1,cur_node);
80107eae:	53                   	push   %ebx
80107eaf:	6a 01                	push   $0x1
80107eb1:	50                   	push   %eax
80107eb2:	51                   	push   %ecx
80107eb3:	e8 28 fc ff ff       	call   80107ae0 <remove_physical_map>
80107eb8:	29 43 18             	sub    %eax,0x18(%ebx)
        remove_physical_map(addr,length,1,cur_node);
80107ebb:	53                   	push   %ebx
80107ebc:	6a 01                	push   $0x1
80107ebe:	ff 75 e4             	push   -0x1c(%ebp)
80107ec1:	ff 75 e0             	push   -0x20(%ebp)
80107ec4:	e8 17 fc ff ff       	call   80107ae0 <remove_physical_map>
        return 0;
80107ec9:	83 c4 20             	add    $0x20,%esp
}
80107ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
80107ecf:	31 c0                	xor    %eax,%eax
}
80107ed1:	5b                   	pop    %ebx
80107ed2:	5e                   	pop    %esi
80107ed3:	5f                   	pop    %edi
80107ed4:	5d                   	pop    %ebp
80107ed5:	c3                   	ret    
80107ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107edd:	8d 76 00             	lea    0x0(%esi),%esi
        int length1 = (cur_node->addr + cur_node->length) - (addr+length);
80107ee0:	29 fa                	sub    %edi,%edx
        cur_node->addr   = addr1;
80107ee2:	89 3b                	mov    %edi,(%ebx)
        int length1 = (cur_node->addr + cur_node->length) - (addr+length);
80107ee4:	89 53 04             	mov    %edx,0x4(%ebx)
        cur_node->n_loaded_pages -= remove_physical_map(addr,length,1,cur_node);
80107ee7:	53                   	push   %ebx
80107ee8:	6a 01                	push   $0x1
80107eea:	ff 75 e4             	push   -0x1c(%ebp)
80107eed:	ff 75 e0             	push   -0x20(%ebp)
80107ef0:	e8 eb fb ff ff       	call   80107ae0 <remove_physical_map>
        return 0;
80107ef5:	83 c4 10             	add    $0x10,%esp
        cur_node->n_loaded_pages -= remove_physical_map(addr,length,1,cur_node);
80107ef8:	29 43 18             	sub    %eax,0x18(%ebx)
}
80107efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107efe:	5b                   	pop    %ebx
        return 0;
80107eff:	31 c0                	xor    %eax,%eax
}
80107f01:	5e                   	pop    %esi
80107f02:	5f                   	pop    %edi
80107f03:	5d                   	pop    %ebp
80107f04:	c3                   	ret    
    mmap->addr = 0; // note to future changed this from a 0 to a -1
80107f05:	8d 34 02             	lea    (%edx,%eax,1),%esi
            return &proc->mmaps[i];
80107f08:	8d 7c 02 7c          	lea    0x7c(%edx,%eax,1),%edi
        uint length1 = addr - cur_node->addr;
80107f0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
        uint addr2   = addr+length;
80107f0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    mmap->addr = 0; // note to future changed this from a 0 to a -1
80107f12:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
    mmap->length = -1;
80107f19:	c7 86 80 00 00 00 ff 	movl   $0xffffffff,0x80(%esi)
80107f20:	ff ff ff 
        uint addr2   = addr+length;
80107f23:	01 c2                	add    %eax,%edx
    mmap->flags = -1;
80107f25:	c7 86 84 00 00 00 ff 	movl   $0xffffffff,0x84(%esi)
80107f2c:	ff ff ff 
    mmap->fd = -1;
80107f2f:	c7 86 88 00 00 00 ff 	movl   $0xffffffff,0x88(%esi)
80107f36:	ff ff ff 
    mmap->f = 0;
80107f39:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80107f40:	00 00 00 
    mmap->refcnt = 0;
80107f43:	c7 86 90 00 00 00 00 	movl   $0x0,0x90(%esi)
80107f4a:	00 00 00 
    mmap->n_loaded_pages = 0;
80107f4d:	c7 86 94 00 00 00 00 	movl   $0x0,0x94(%esi)
80107f54:	00 00 00 
    mmap->next = 0;
80107f57:	c7 86 98 00 00 00 00 	movl   $0x0,0x98(%esi)
80107f5e:	00 00 00 
        uint addr1   = cur_node->addr;
80107f61:	8b 0b                	mov    (%ebx),%ecx
            return &proc->mmaps[i];
80107f63:	89 7d d4             	mov    %edi,-0x2c(%ebp)
        uint length1 = addr - cur_node->addr;
80107f66:	29 c8                	sub    %ecx,%eax
        uint length2 = (cur_node->addr + cur_node->length) - (addr+length);
80107f68:	89 cf                	mov    %ecx,%edi
80107f6a:	89 55 d0             	mov    %edx,-0x30(%ebp)
80107f6d:	29 d7                	sub    %edx,%edi
80107f6f:	03 7b 04             	add    0x4(%ebx),%edi
        cur_node->length = length1;
80107f72:	89 43 04             	mov    %eax,0x4(%ebx)
        cur_node->n_loaded_pages = remove_physical_map(cur_node->addr,cur_node->length,0,cur_node);
80107f75:	53                   	push   %ebx
80107f76:	6a 00                	push   $0x0
80107f78:	50                   	push   %eax
80107f79:	51                   	push   %ecx
80107f7a:	e8 61 fb ff ff       	call   80107ae0 <remove_physical_map>
        unused_map->addr   = addr2;
80107f7f:	8b 55 d0             	mov    -0x30(%ebp),%edx
        cur_node->n_loaded_pages = remove_physical_map(cur_node->addr,cur_node->length,0,cur_node);
80107f82:	89 43 18             	mov    %eax,0x18(%ebx)
        unused_map->addr   = addr2;
80107f85:	89 56 7c             	mov    %edx,0x7c(%esi)
        unused_map->length = length2;
80107f88:	89 be 80 00 00 00    	mov    %edi,0x80(%esi)
        unused_map->f      = cur_node->f;
80107f8e:	8b 43 10             	mov    0x10(%ebx),%eax
80107f91:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
        unused_map->flags  = cur_node->flags;
80107f97:	8b 43 08             	mov    0x8(%ebx),%eax
80107f9a:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
        unused_map->refcnt = cur_node->refcnt;
80107fa0:	8b 43 14             	mov    0x14(%ebx),%eax
80107fa3:	89 86 90 00 00 00    	mov    %eax,0x90(%esi)
        unused_map->fd     = cur_node->fd;
80107fa9:	8b 43 0c             	mov    0xc(%ebx),%eax
80107fac:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
        unused_map->n_loaded_pages = remove_physical_map(unused_map->addr,unused_map->length,0,cur_node);
80107fb2:	53                   	push   %ebx
80107fb3:	6a 00                	push   $0x0
80107fb5:	57                   	push   %edi
80107fb6:	52                   	push   %edx
80107fb7:	e8 24 fb ff ff       	call   80107ae0 <remove_physical_map>
        remove_physical_map(addr,length,1,cur_node);
80107fbc:	83 c4 20             	add    $0x20,%esp
        unused_map->n_loaded_pages = remove_physical_map(unused_map->addr,unused_map->length,0,cur_node);
80107fbf:	89 86 94 00 00 00    	mov    %eax,0x94(%esi)
        unused_map->refcnt = cur_node->refcnt; 
80107fc5:	8b 43 14             	mov    0x14(%ebx),%eax
80107fc8:	89 86 90 00 00 00    	mov    %eax,0x90(%esi)
        remove_physical_map(addr,length,1,cur_node);
80107fce:	53                   	push   %ebx
80107fcf:	6a 01                	push   $0x1
80107fd1:	ff 75 e4             	push   -0x1c(%ebp)
80107fd4:	ff 75 e0             	push   -0x20(%ebp)
80107fd7:	e8 04 fb ff ff       	call   80107ae0 <remove_physical_map>
        struct mmap_region* temp = cur_node->next;
80107fdc:	8b 43 1c             	mov    0x1c(%ebx),%eax
        cur_node->next   = unused_map;
80107fdf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
        return 0;
80107fe2:	83 c4 10             	add    $0x10,%esp
        cur_node->next   = unused_map;
80107fe5:	89 7b 1c             	mov    %edi,0x1c(%ebx)
        unused_map->next = temp;
80107fe8:	89 86 98 00 00 00    	mov    %eax,0x98(%esi)
        return 0;
80107fee:	e9 35 fe ff ff       	jmp    80107e28 <sys_wpunmap+0xd8>
        cprintf("wpunmap arg ERROR: size or flags\n");
80107ff3:	83 ec 0c             	sub    $0xc,%esp
80107ff6:	68 40 91 10 80       	push   $0x80109140
80107ffb:	e8 a0 86 ff ff       	call   801006a0 <cprintf>
        return FAILED;
80108000:	83 c4 10             	add    $0x10,%esp
80108003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108008:	e9 1d fe ff ff       	jmp    80107e2a <sys_wpunmap+0xda>
        cprintf("wpunmap ERROR: partial unmap length <= 0\n");
8010800d:	83 ec 0c             	sub    $0xc,%esp
80108010:	68 9c 91 10 80       	push   $0x8010919c
80108015:	e8 86 86 ff ff       	call   801006a0 <cprintf>
        return FAILED;
8010801a:	83 c4 10             	add    $0x10,%esp
8010801d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108022:	e9 03 fe ff ff       	jmp    80107e2a <sys_wpunmap+0xda>
        cprintf("wpunmap ERROR: partial unmap addr end not page aligned\n");
80108027:	83 ec 0c             	sub    $0xc,%esp
8010802a:	68 64 91 10 80       	push   $0x80109164
8010802f:	e8 6c 86 ff ff       	call   801006a0 <cprintf>
        return FAILED;
80108034:	83 c4 10             	add    $0x10,%esp
80108037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010803c:	e9 e9 fd ff ff       	jmp    80107e2a <sys_wpunmap+0xda>
80108041:	e9 e3 05 00 00       	jmp    80108629 <sys_wpunmap.cold>
80108046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010804d:	8d 76 00             	lea    0x0(%esi),%esi

80108050 <init_one_mmap>:
void init_one_mmap(struct mmap_region *mmap) {
80108050:	55                   	push   %ebp
80108051:	89 e5                	mov    %esp,%ebp
80108053:	8b 45 08             	mov    0x8(%ebp),%eax
    mmap->addr = 0; // note to future changed this from a 0 to a -1
80108056:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    mmap->length = -1;
8010805c:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    mmap->flags = -1;
80108063:	c7 40 08 ff ff ff ff 	movl   $0xffffffff,0x8(%eax)
    mmap->fd = -1;
8010806a:	c7 40 0c ff ff ff ff 	movl   $0xffffffff,0xc(%eax)
    mmap->f = 0;
80108071:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    mmap->refcnt = 0;
80108078:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    mmap->n_loaded_pages = 0;
8010807f:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    mmap->next = 0;
80108086:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
}
8010808d:	5d                   	pop    %ebp
8010808e:	c3                   	ret    
8010808f:	90                   	nop

80108090 <init_mmaps>:
 * @brief initializes memory maps for a process by resetting its mmap structures.
 *
 * @param proc Pointer to the process structure to initialize.
 */
void init_mmaps(struct proc *proc) 
{
80108090:	55                   	push   %ebp
80108091:	89 e5                	mov    %esp,%ebp
80108093:	8b 55 08             	mov    0x8(%ebp),%edx
80108096:	8d 42 7c             	lea    0x7c(%edx),%eax
80108099:	81 c2 7c 02 00 00    	add    $0x27c,%edx
8010809f:	90                   	nop
    mmap->addr = 0; // note to future changed this from a 0 to a -1
801080a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for(int i = 0; i < MAX_NMMAP;i++)
801080a6:	83 c0 20             	add    $0x20,%eax
    mmap->length = -1;
801080a9:	c7 40 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%eax)
    mmap->flags = -1;
801080b0:	c7 40 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%eax)
    mmap->fd = -1;
801080b7:	c7 40 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%eax)
    mmap->f = 0;
801080be:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
    mmap->refcnt = 0;
801080c5:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
    mmap->n_loaded_pages = 0;
801080cc:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    mmap->next = 0;
801080d3:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for(int i = 0; i < MAX_NMMAP;i++)
801080da:	39 d0                	cmp    %edx,%eax
801080dc:	75 c2                	jne    801080a0 <init_mmaps+0x10>
    {
        init_one_mmap(&proc->mmaps[i]);
    }
}
801080de:	5d                   	pop    %ebp
801080df:	c3                   	ret    

801080e0 <get_physical_page>:
 * @return Physical address of the page if found, or 0 if not found.
 */
uint get_physical_page(struct proc *p, uint va, pte_t **pte) 
{
    return 0;
}
801080e0:	31 c0                	xor    %eax,%eax
801080e2:	c3                   	ret    
801080e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801080f0 <count_loaded_pages>:
 * @param end Virtual address end.
 * @return number of loaded pages.
 */
int count_loaded_pages(struct proc *p, uint start, uint end) {
    return 0;
}
801080f0:	31 c0                	xor    %eax,%eax
801080f2:	c3                   	ret    
801080f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108100 <handle_page_fault>:
 *
 * @param pgflt_vaddr The virtual address that caused the page fault.
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int handle_page_fault(uint pgflt_vaddr) 
{  
80108100:	55                   	push   %ebp
80108101:	89 e5                	mov    %esp,%ebp
80108103:	57                   	push   %edi
80108104:	56                   	push   %esi
80108105:	53                   	push   %ebx
80108106:	83 ec 1c             	sub    $0x1c,%esp
80108109:	8b 75 08             	mov    0x8(%ebp),%esi
    DPRINT("XV6: Handle Page Fault Start at 0x%x\n",pgflt_vaddr);
    struct mmap_region* cur_node = myproc()->mmap_head;
8010810c:	e8 6f b8 ff ff       	call   80103980 <myproc>
80108111:	8b 98 7c 02 00 00    	mov    0x27c(%eax),%ebx
    int found = 0;
    for(int i = 0; cur_node != 0;i++)
80108117:	85 db                	test   %ebx,%ebx
80108119:	75 10                	jne    8010812b <handle_page_fault+0x2b>
8010811b:	e9 b0 00 00 00       	jmp    801081d0 <handle_page_fault+0xd0>
        {  
            found = 1;
            break;
        }

        cur_node = cur_node->next;
80108120:	8b 5b 1c             	mov    0x1c(%ebx),%ebx
    for(int i = 0; cur_node != 0;i++)
80108123:	85 db                	test   %ebx,%ebx
80108125:	0f 84 a5 00 00 00    	je     801081d0 <handle_page_fault+0xd0>
        int lower_bound = pgflt_vaddr >= cur_node->addr;
8010812b:	8b 13                	mov    (%ebx),%edx
        int upper_bound = pgflt_vaddr < cur_node->addr + cur_node->length;
8010812d:	8b 4b 04             	mov    0x4(%ebx),%ecx
80108130:	01 d1                	add    %edx,%ecx
        if(lower_bound && upper_bound)
80108132:	39 f1                	cmp    %esi,%ecx
80108134:	76 ea                	jbe    80108120 <handle_page_fault+0x20>
80108136:	39 f2                	cmp    %esi,%edx
80108138:	77 e6                	ja     80108120 <handle_page_fault+0x20>
    if(found)
    {
        DPRINT("XV6: Handle Page Fault: Page Sucessfully found\n");
        pgflt_vaddr = pgflt_vaddr/PGSIZE * PGSIZE; 

        char *mem = kalloc();
8010813a:	e8 41 a5 ff ff       	call   80102680 <kalloc>

        int flags   = cur_node->flags;
        int anon    = (flags & MAP_ANONYMOUS) != 0;
8010813f:	8b 53 08             	mov    0x8(%ebx),%edx
        pgflt_vaddr = pgflt_vaddr/PGSIZE * PGSIZE; 
80108142:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        char *mem = kalloc();
80108148:	89 c7                	mov    %eax,%edi
        int anon    = (flags & MAP_ANONYMOUS) != 0;
8010814a:	83 e2 04             	and    $0x4,%edx
8010814d:	89 55 e4             	mov    %edx,-0x1c(%ebp)

        DPRINT("XV6: pgdr: 0x%x\n",myproc()->pgdir);
        if (mappages(myproc()->pgdir, (void*)pgflt_vaddr, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
80108150:	e8 2b b8 ff ff       	call   80103980 <myproc>
80108155:	83 ec 0c             	sub    $0xc,%esp
80108158:	8d 8f 00 00 00 80    	lea    -0x80000000(%edi),%ecx
8010815e:	6a 06                	push   $0x6
80108160:	51                   	push   %ecx
80108161:	68 00 10 00 00       	push   $0x1000
80108166:	56                   	push   %esi
80108167:	ff 70 04             	push   0x4(%eax)
8010816a:	e8 d1 e8 ff ff       	call   80106a40 <mappages>
8010816f:	83 c4 20             	add    $0x20,%esp
80108172:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108175:	85 c0                	test   %eax,%eax
80108177:	78 78                	js     801081f1 <handle_page_fault+0xf1>
          DPRINT("XV6: failed to physically allocate a page");
          return -1;
        }
        DPRINT("XV6: page is physically allocated here: 0x%x\n",V2P(mem));

        cur_node->n_loaded_pages++;
80108179:	83 43 18 01          	addl   $0x1,0x18(%ebx)

        struct file* f    = cur_node->f;
8010817d:	8b 43 10             	mov    0x10(%ebx),%eax

        if(!anon && f != 0)
80108180:	85 d2                	test   %edx,%edx
80108182:	75 3c                	jne    801081c0 <handle_page_fault+0xc0>
80108184:	85 c0                	test   %eax,%eax
80108186:	74 38                	je     801081c0 <handle_page_fault+0xc0>
        {
            DPRINT("XV6: Handle Page Fault: Starting file-backed-mapping\n");
            int r;
            ilock(cur_node->f->ip);
80108188:	83 ec 0c             	sub    $0xc,%esp
8010818b:	ff 70 10             	push   0x10(%eax)
8010818e:	e8 ed 95 ff ff       	call   80101780 <ilock>
            uint offset = pgflt_vaddr-cur_node->addr;
            r = readi(cur_node->f->ip, (char *)mem, offset, PGSIZE);
80108193:	68 00 10 00 00       	push   $0x1000
            uint offset = pgflt_vaddr-cur_node->addr;
80108198:	89 f0                	mov    %esi,%eax
8010819a:	2b 03                	sub    (%ebx),%eax
            r = readi(cur_node->f->ip, (char *)mem, offset, PGSIZE);
8010819c:	50                   	push   %eax
8010819d:	57                   	push   %edi
8010819e:	8b 43 10             	mov    0x10(%ebx),%eax
801081a1:	ff 70 10             	push   0x10(%eax)
801081a4:	e8 e7 98 ff ff       	call   80101a90 <readi>
            iunlock(cur_node->f->ip);
801081a9:	83 c4 14             	add    $0x14,%esp
            r = readi(cur_node->f->ip, (char *)mem, offset, PGSIZE);
801081ac:	89 c7                	mov    %eax,%edi
            iunlock(cur_node->f->ip);
801081ae:	8b 43 10             	mov    0x10(%ebx),%eax
801081b1:	ff 70 10             	push   0x10(%eax)
801081b4:	e8 a7 96 ff ff       	call   80101860 <iunlock>
            if (r < 0) 
801081b9:	83 c4 10             	add    $0x10,%esp
801081bc:	85 ff                	test   %edi,%edi
801081be:	78 1a                	js     801081da <handle_page_fault+0xda>

        return pgflt_vaddr;
    }
    DPRINT("XV6: Handle Page Fault: Page Was not found\n");
    return 0;
}
801081c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return pgflt_vaddr;
801081c3:	89 f0                	mov    %esi,%eax
}
801081c5:	5b                   	pop    %ebx
801081c6:	5e                   	pop    %esi
801081c7:	5f                   	pop    %edi
801081c8:	5d                   	pop    %ebp
801081c9:	c3                   	ret    
801081ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return 0;
801081d0:	31 c0                	xor    %eax,%eax
}
801081d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081d5:	5b                   	pop    %ebx
801081d6:	5e                   	pop    %esi
801081d7:	5f                   	pop    %edi
801081d8:	5d                   	pop    %ebp
801081d9:	c3                   	ret    
                cprintf("handle_page_fault ERROR: readi failed\n");
801081da:	83 ec 0c             	sub    $0xc,%esp
801081dd:	68 c8 91 10 80       	push   $0x801091c8
801081e2:	e8 b9 84 ff ff       	call   801006a0 <cprintf>
                return FAILED;
801081e7:	83 c4 10             	add    $0x10,%esp
801081ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081ef:	eb e1                	jmp    801081d2 <handle_page_fault+0xd2>
          return -1;
801081f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081f6:	eb da                	jmp    801081d2 <handle_page_fault+0xd2>
801081f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801081ff:	90                   	nop

80108200 <copy_phyiscal_maps>:
 * is read in the parent or a write in its child
 * for its parent if I write I will copy the mapping to all of its children before writing
 * if its a child then I will only copy the mapping before writing
 */
void copy_phyiscal_maps(pde_t* dst, pde_t* src, struct mmap_region* mapping)
{
80108200:	55                   	push   %ebp
80108201:	89 e5                	mov    %esp,%ebp
80108203:	57                   	push   %edi
80108204:	56                   	push   %esi
80108205:	53                   	push   %ebx
80108206:	83 ec 1c             	sub    $0x1c,%esp
80108209:	8b 45 10             	mov    0x10(%ebp),%eax
8010820c:	8b 7d 08             	mov    0x8(%ebp),%edi
    DPRINT("XV6: copy phyiscal pgdir from 0x%x to 0x%x\n",dst,src);
    int length = mapping->length;
8010820f:	8b 50 04             	mov    0x4(%eax),%edx
    uint addr  = mapping->addr;
80108212:	8b 18                	mov    (%eax),%ebx
    int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;
80108214:	85 d2                	test   %edx,%edx
80108216:	8d 82 ff 0f 00 00    	lea    0xfff(%edx),%eax
8010821c:	0f 49 c2             	cmovns %edx,%eax
8010821f:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80108225:	c1 f8 0c             	sar    $0xc,%eax
80108228:	83 fa 01             	cmp    $0x1,%edx
8010822b:	83 d8 ff             	sbb    $0xffffffff,%eax
    for(int i = 0; i < repeat;i++)
8010822e:	89 c2                	mov    %eax,%edx
80108230:	c1 e2 0c             	shl    $0xc,%edx
80108233:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80108236:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108239:	85 c0                	test   %eax,%eax
8010823b:	7e 76                	jle    801082b3 <copy_phyiscal_maps+0xb3>
8010823d:	8d 76 00             	lea    0x0(%esi),%esi
    {
        pte_t *pte = walkpgdir(dst, (void*)(addr + i * PGSIZE), 0);
80108240:	83 ec 04             	sub    $0x4,%esp
80108243:	6a 00                	push   $0x0
80108245:	53                   	push   %ebx
80108246:	57                   	push   %edi
80108247:	e8 64 e7 ff ff       	call   801069b0 <walkpgdir>
        if (pte == 0) continue;
8010824c:	83 c4 10             	add    $0x10,%esp
        pte_t *pte = walkpgdir(dst, (void*)(addr + i * PGSIZE), 0);
8010824f:	89 c6                	mov    %eax,%esi
        if (pte == 0) continue;
80108251:	85 c0                	test   %eax,%eax
80108253:	74 53                	je     801082a8 <copy_phyiscal_maps+0xa8>
        if ((*pte & PTE_P) == 0) continue;
80108255:	f6 00 01             	testb  $0x1,(%eax)
80108258:	74 4e                	je     801082a8 <copy_phyiscal_maps+0xa8>

        char* mem = kalloc();
8010825a:	e8 21 a4 ff ff       	call   80102680 <kalloc>
        void* va = (void*)(addr + i * PGSIZE);
        uint pa = PTE_ADDR(*pte);
        if (mappages(src, va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
8010825f:	83 ec 0c             	sub    $0xc,%esp
        uint pa = PTE_ADDR(*pte);
80108262:	8b 36                	mov    (%esi),%esi
        char* mem = kalloc();
80108264:	89 c2                	mov    %eax,%edx
        if (mappages(src, va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
80108266:	8d 80 00 00 00 80    	lea    -0x80000000(%eax),%eax
8010826c:	6a 06                	push   $0x6
8010826e:	50                   	push   %eax
        uint pa = PTE_ADDR(*pte);
8010826f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        if (mappages(src, va, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0)
80108275:	68 00 10 00 00       	push   $0x1000
8010827a:	53                   	push   %ebx
8010827b:	ff 75 0c             	push   0xc(%ebp)
8010827e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80108281:	e8 ba e7 ff ff       	call   80106a40 <mappages>
80108286:	83 c4 20             	add    $0x20,%esp
80108289:	85 c0                	test   %eax,%eax
8010828b:	78 26                	js     801082b3 <copy_phyiscal_maps+0xb3>
            return;
        }

        // this line below would be removed and replaced by some code in the pgflt handler if 
        // i was implementing copy on write
        memmove(mem, (char *)P2V(pa), PGSIZE);
8010828d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108290:	83 ec 04             	sub    $0x4,%esp
80108293:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80108299:	68 00 10 00 00       	push   $0x1000
8010829e:	56                   	push   %esi
8010829f:	52                   	push   %edx
801082a0:	e8 8b c4 ff ff       	call   80104730 <memmove>
801082a5:	83 c4 10             	add    $0x10,%esp
    for(int i = 0; i < repeat;i++)
801082a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801082ae:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
801082b1:	75 8d                	jne    80108240 <copy_phyiscal_maps+0x40>
    }
}
801082b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082b6:	5b                   	pop    %ebx
801082b7:	5e                   	pop    %esi
801082b8:	5f                   	pop    %edi
801082b9:	5d                   	pop    %ebp
801082ba:	c3                   	ret    
801082bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801082bf:	90                   	nop

801082c0 <copy_maps>:
 * It also increments the reference count of the memory mapping if it is MAP_SHARED.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int copy_maps(struct proc *parent, struct proc *child) 
{
801082c0:	55                   	push   %ebp
801082c1:	89 e5                	mov    %esp,%ebp
801082c3:	57                   	push   %edi
801082c4:	56                   	push   %esi
801082c5:	53                   	push   %ebx
801082c6:	83 ec 1c             	sub    $0x1c,%esp
    // copying over mmapings
    DPRINT("XV6: Fork() starting to copy mappings from parent: 0x%x to child 0x%x\n",parent->pid,child->pid);   
 
    struct mmap_region* cur_mapping  = parent->mmap_head;
801082c9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801082cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    struct mmap_region* cur_mapping  = parent->mmap_head;
801082cf:	8b b0 7c 02 00 00    	mov    0x27c(%eax),%esi
    struct mmap_region* prev_mapping = 0;
    if(cur_mapping == 0)
801082d5:	85 f6                	test   %esi,%esi
801082d7:	74 74                	je     8010834d <copy_maps+0x8d>
801082d9:	8d 43 7c             	lea    0x7c(%ebx),%eax
801082dc:	8d 8b 7c 02 00 00    	lea    0x27c(%ebx),%ecx
801082e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mmap->addr = 0; // note to future changed this from a 0 to a -1
801082e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for(int i = 0; i < MAX_NMMAP;i++)
801082ee:	83 c0 20             	add    $0x20,%eax
    mmap->length = -1;
801082f1:	c7 40 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%eax)
    mmap->flags = -1;
801082f8:	c7 40 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%eax)
    mmap->fd = -1;
801082ff:	c7 40 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%eax)
    mmap->f = 0;
80108306:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
    mmap->refcnt = 0;
8010830d:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
    mmap->n_loaded_pages = 0;
80108314:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    mmap->next = 0;
8010831b:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for(int i = 0; i < MAX_NMMAP;i++)
80108322:	39 c8                	cmp    %ecx,%eax
80108324:	75 c2                	jne    801082e8 <copy_maps+0x28>
    struct mmap_region* prev_mapping = 0;
80108326:	31 ff                	xor    %edi,%edi
80108328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010832f:	90                   	nop
    for(int i = 0; i < MAX_NMMAP;i++)
80108330:	31 c0                	xor    %eax,%eax
80108332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        int valid = proc->mmaps[i].addr > 0;
80108338:	89 c2                	mov    %eax,%edx
8010833a:	c1 e2 05             	shl    $0x5,%edx
        if (!valid)
8010833d:	8b 4c 13 7c          	mov    0x7c(%ebx,%edx,1),%ecx
80108341:	85 c9                	test   %ecx,%ecx
80108343:	74 1b                	je     80108360 <copy_maps+0xa0>
    for(int i = 0; i < MAX_NMMAP;i++)
80108345:	83 c0 01             	add    $0x1,%eax
80108348:	83 f8 10             	cmp    $0x10,%eax
8010834b:	75 eb                	jne    80108338 <copy_maps+0x78>

        prev_mapping = unused_map;
        cur_mapping  = cur_mapping->next;
    }
    return 0;
}
8010834d:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return FAILED;
80108350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108355:	5b                   	pop    %ebx
80108356:	5e                   	pop    %esi
80108357:	5f                   	pop    %edi
80108358:	5d                   	pop    %ebp
80108359:	c3                   	ret    
8010835a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            return &proc->mmaps[i];
80108360:	8d 4c 13 7c          	lea    0x7c(%ebx,%edx,1),%ecx
    mmap->addr = 0; // note to future changed this from a 0 to a -1
80108364:	01 da                	add    %ebx,%edx
80108366:	c7 42 7c 00 00 00 00 	movl   $0x0,0x7c(%edx)
    mmap->length = -1;
8010836d:	c7 82 80 00 00 00 ff 	movl   $0xffffffff,0x80(%edx)
80108374:	ff ff ff 
    mmap->flags = -1;
80108377:	c7 82 84 00 00 00 ff 	movl   $0xffffffff,0x84(%edx)
8010837e:	ff ff ff 
    mmap->fd = -1;
80108381:	c7 82 88 00 00 00 ff 	movl   $0xffffffff,0x88(%edx)
80108388:	ff ff ff 
    mmap->f = 0;
8010838b:	c7 82 8c 00 00 00 00 	movl   $0x0,0x8c(%edx)
80108392:	00 00 00 
    mmap->refcnt = 0;
80108395:	c7 82 90 00 00 00 00 	movl   $0x0,0x90(%edx)
8010839c:	00 00 00 
    mmap->n_loaded_pages = 0;
8010839f:	c7 82 94 00 00 00 00 	movl   $0x0,0x94(%edx)
801083a6:	00 00 00 
    mmap->next = 0;
801083a9:	c7 82 98 00 00 00 00 	movl   $0x0,0x98(%edx)
801083b0:	00 00 00 
            return &proc->mmaps[i];
801083b3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
        int shared  = (cur_mapping->flags&MAP_SHARED) !=0;
801083b6:	8b 4e 08             	mov    0x8(%esi),%ecx
801083b9:	83 e1 02             	and    $0x2,%ecx
801083bc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        int private = (cur_mapping->flags&MAP_PRIVATE)!=0;
801083bf:	8b 4e 08             	mov    0x8(%esi),%ecx
801083c2:	83 e1 01             	and    $0x1,%ecx
801083c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
        unused_map->addr           = cur_mapping->addr;
801083c8:	8b 0e                	mov    (%esi),%ecx
801083ca:	89 4a 7c             	mov    %ecx,0x7c(%edx)
        unused_map->f              = cur_mapping->f;
801083cd:	8b 4e 10             	mov    0x10(%esi),%ecx
801083d0:	89 8a 8c 00 00 00    	mov    %ecx,0x8c(%edx)
        unused_map->fd             = cur_mapping->fd;
801083d6:	8b 4e 0c             	mov    0xc(%esi),%ecx
801083d9:	89 8a 88 00 00 00    	mov    %ecx,0x88(%edx)
        unused_map->flags          = cur_mapping->flags;
801083df:	8b 4e 08             	mov    0x8(%esi),%ecx
801083e2:	89 8a 84 00 00 00    	mov    %ecx,0x84(%edx)
        unused_map->length         = cur_mapping->length;
801083e8:	8b 4e 04             	mov    0x4(%esi),%ecx
801083eb:	89 8a 80 00 00 00    	mov    %ecx,0x80(%edx)
        unused_map->n_loaded_pages = cur_mapping->n_loaded_pages;
801083f1:	8b 4e 18             	mov    0x18(%esi),%ecx
801083f4:	89 8a 94 00 00 00    	mov    %ecx,0x94(%edx)
        unused_map->refcnt         = cur_mapping->refcnt;
801083fa:	8b 4e 14             	mov    0x14(%esi),%ecx
801083fd:	89 8a 90 00 00 00    	mov    %ecx,0x90(%edx)
        if(is_first)
80108403:	85 ff                	test   %edi,%edi
80108405:	74 59                	je     80108460 <copy_maps+0x1a0>
            prev_mapping->next = unused_map;
80108407:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010840a:	89 4f 1c             	mov    %ecx,0x1c(%edi)
        if (shared)
8010840d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80108410:	85 c9                	test   %ecx,%ecx
80108412:	75 5c                	jne    80108470 <copy_maps+0x1b0>
        if(private)
80108414:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108417:	85 c0                	test   %eax,%eax
80108419:	75 15                	jne    80108430 <copy_maps+0x170>
        cur_mapping  = cur_mapping->next;
8010841b:	8b 76 1c             	mov    0x1c(%esi),%esi
    while(cur_mapping != 0)
8010841e:	85 f6                	test   %esi,%esi
80108420:	74 2a                	je     8010844c <copy_maps+0x18c>
            return &proc->mmaps[i];
80108422:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80108425:	e9 06 ff ff ff       	jmp    80108330 <copy_maps+0x70>
8010842a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            copy_phyiscal_maps(parent->pgdir,child->pgdir,cur_mapping);
80108430:	8b 45 08             	mov    0x8(%ebp),%eax
80108433:	83 ec 04             	sub    $0x4,%esp
80108436:	56                   	push   %esi
80108437:	ff 73 04             	push   0x4(%ebx)
8010843a:	ff 70 04             	push   0x4(%eax)
8010843d:	e8 be fd ff ff       	call   80108200 <copy_phyiscal_maps>
        cur_mapping  = cur_mapping->next;
80108442:	8b 76 1c             	mov    0x1c(%esi),%esi
            copy_phyiscal_maps(parent->pgdir,child->pgdir,cur_mapping);
80108445:	83 c4 10             	add    $0x10,%esp
    while(cur_mapping != 0)
80108448:	85 f6                	test   %esi,%esi
8010844a:	75 d6                	jne    80108422 <copy_maps+0x162>
}
8010844c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010844f:	31 c0                	xor    %eax,%eax
}
80108451:	5b                   	pop    %ebx
80108452:	5e                   	pop    %esi
80108453:	5f                   	pop    %edi
80108454:	5d                   	pop    %ebp
80108455:	c3                   	ret    
80108456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010845d:	8d 76 00             	lea    0x0(%esi),%esi
            child->mmap_head = unused_map;
80108460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        if (shared)
80108463:	8b 4d e0             	mov    -0x20(%ebp),%ecx
            child->mmap_head = unused_map;
80108466:	89 bb 7c 02 00 00    	mov    %edi,0x27c(%ebx)
        if (shared)
8010846c:	85 c9                	test   %ecx,%ecx
8010846e:	74 a4                	je     80108414 <copy_maps+0x154>
            int length = unused_map->length;
80108470:	c1 e0 05             	shl    $0x5,%eax
            unused_map->refcnt++;
80108473:	83 82 90 00 00 00 01 	addl   $0x1,0x90(%edx)
            int length = unused_map->length;
8010847a:	01 d8                	add    %ebx,%eax
8010847c:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
            uint addr  = unused_map->addr;
80108482:	8b 78 7c             	mov    0x7c(%eax),%edi
            int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;
80108485:	85 c9                	test   %ecx,%ecx
80108487:	8d 81 ff 0f 00 00    	lea    0xfff(%ecx),%eax
8010848d:	0f 49 c1             	cmovns %ecx,%eax
80108490:	c1 f8 0c             	sar    $0xc,%eax
80108493:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
80108499:	74 03                	je     8010849e <copy_maps+0x1de>
8010849b:	83 c0 01             	add    $0x1,%eax
            for(int i = 0; i < repeat;i++)
8010849e:	85 c0                	test   %eax,%eax
801084a0:	0f 8e 6e ff ff ff    	jle    80108414 <copy_maps+0x154>
801084a6:	c1 e0 0c             	shl    $0xc,%eax
801084a9:	89 75 e0             	mov    %esi,-0x20(%ebp)
801084ac:	8b 75 08             	mov    0x8(%ebp),%esi
801084af:	01 f8                	add    %edi,%eax
801084b1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801084b4:	89 fb                	mov    %edi,%ebx
801084b6:	89 c7                	mov    %eax,%edi
801084b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084bf:	90                   	nop
                pte_t *pte = walkpgdir(parent->pgdir, (void*)(addr + i * PGSIZE), 0);
801084c0:	83 ec 04             	sub    $0x4,%esp
801084c3:	6a 00                	push   $0x0
801084c5:	53                   	push   %ebx
801084c6:	ff 76 04             	push   0x4(%esi)
801084c9:	e8 e2 e4 ff ff       	call   801069b0 <walkpgdir>
                if (pte == 0) continue;
801084ce:	83 c4 10             	add    $0x10,%esp
801084d1:	85 c0                	test   %eax,%eax
801084d3:	74 2d                	je     80108502 <copy_maps+0x242>
                if ((*pte & PTE_P) == 0) continue;
801084d5:	8b 00                	mov    (%eax),%eax
801084d7:	a8 01                	test   $0x1,%al
801084d9:	74 27                	je     80108502 <copy_maps+0x242>
                if (mappages(child->pgdir, va, PGSIZE, pa, PTE_W | PTE_U) < 0)
801084db:	83 ec 0c             	sub    $0xc,%esp
                uint pa = PTE_ADDR(*pte);
801084de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
                if (mappages(child->pgdir, va, PGSIZE, pa, PTE_W | PTE_U) < 0)
801084e3:	6a 06                	push   $0x6
801084e5:	50                   	push   %eax
801084e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801084e9:	68 00 10 00 00       	push   $0x1000
801084ee:	53                   	push   %ebx
801084ef:	ff 70 04             	push   0x4(%eax)
801084f2:	e8 49 e5 ff ff       	call   80106a40 <mappages>
801084f7:	83 c4 20             	add    $0x20,%esp
801084fa:	85 c0                	test   %eax,%eax
801084fc:	0f 88 4b fe ff ff    	js     8010834d <copy_maps+0x8d>
            for(int i = 0; i < repeat;i++)
80108502:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108508:	39 fb                	cmp    %edi,%ebx
8010850a:	75 b4                	jne    801084c0 <copy_maps+0x200>
8010850c:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010850f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80108512:	e9 fd fe ff ff       	jmp    80108414 <copy_maps+0x154>
80108517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010851e:	66 90                	xchg   %ax,%ax

80108520 <delete_mmaps>:
 * It removes mappings with zero reference count and resets the mmap_region struct.
 *
 * @return Returns 0 on success, or FAILED if an error occurs.
 */
int delete_mmaps(struct proc *curproc) 
{
80108520:	55                   	push   %ebp
80108521:	89 e5                	mov    %esp,%ebp
80108523:	57                   	push   %edi
80108524:	56                   	push   %esi
80108525:	53                   	push   %ebx
80108526:	83 ec 1c             	sub    $0x1c,%esp
80108529:	8b 75 08             	mov    0x8(%ebp),%esi
    struct mmap_region* cur_node = curproc->mmap_head;
8010852c:	8b 9e 7c 02 00 00    	mov    0x27c(%esi),%ebx
    while(cur_node != 0)
80108532:	85 db                	test   %ebx,%ebx
80108534:	0f 84 80 00 00 00    	je     801085ba <delete_mmaps+0x9a>
8010853a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    {
        if(cur_node->refcnt <= 0)
80108540:	8b 43 14             	mov    0x14(%ebx),%eax
80108543:	85 c0                	test   %eax,%eax
80108545:	0f 8e c5 00 00 00    	jle    80108610 <delete_mmaps+0xf0>
            // delete mapping
            // delete phyiscacly in memory if it exitsts
            remove_map(cur_node->addr);
        }

        int length = cur_node->length;
8010854b:	8b 53 04             	mov    0x4(%ebx),%edx
        int repeat = (length%PGSIZE == 0) ? length/PGSIZE : (length/PGSIZE)+1;
8010854e:	85 d2                	test   %edx,%edx
80108550:	8d 82 ff 0f 00 00    	lea    0xfff(%edx),%eax
80108556:	0f 49 c2             	cmovns %edx,%eax
80108559:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
8010855f:	c1 f8 0c             	sar    $0xc,%eax
80108562:	83 fa 01             	cmp    $0x1,%edx
80108565:	83 d8 ff             	sbb    $0xffffffff,%eax

        for(int i = 0; i < repeat;i++)
80108568:	31 ff                	xor    %edi,%edi
8010856a:	89 c1                	mov    %eax,%ecx
8010856c:	c1 e1 0c             	shl    $0xc,%ecx
8010856f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108572:	85 c0                	test   %eax,%eax
80108574:	7e 39                	jle    801085af <delete_mmaps+0x8f>
80108576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010857d:	8d 76 00             	lea    0x0(%esi),%esi
        {
            pte_t *pte = walkpgdir(curproc->pgdir, (void*)(cur_node->addr + i * PGSIZE), 0);
80108580:	83 ec 04             	sub    $0x4,%esp
80108583:	6a 00                	push   $0x0
80108585:	8b 03                	mov    (%ebx),%eax
80108587:	01 f8                	add    %edi,%eax
80108589:	50                   	push   %eax
8010858a:	ff 76 04             	push   0x4(%esi)
8010858d:	e8 1e e4 ff ff       	call   801069b0 <walkpgdir>
            if (pte != 0  && (*pte & PTE_P) != 0) 
80108592:	83 c4 10             	add    $0x10,%esp
80108595:	85 c0                	test   %eax,%eax
80108597:	74 0b                	je     801085a4 <delete_mmaps+0x84>
80108599:	f6 00 01             	testb  $0x1,(%eax)
8010859c:	74 06                	je     801085a4 <delete_mmaps+0x84>
            {
                // deleting all of the physical mapping so when the os deletes everything
                // it cannot find the ones with refcnt > 1 or something so that the parent
                // can still use this stuff :D
                *pte = 0;
8010859e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for(int i = 0; i < repeat;i++)
801085a4:	81 c7 00 10 00 00    	add    $0x1000,%edi
801085aa:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801085ad:	75 d1                	jne    80108580 <delete_mmaps+0x60>
            }
        }

        cur_node->refcnt--;
801085af:	83 6b 14 01          	subl   $0x1,0x14(%ebx)
        cur_node = cur_node->next;
801085b3:	8b 5b 1c             	mov    0x1c(%ebx),%ebx
    while(cur_node != 0)
801085b6:	85 db                	test   %ebx,%ebx
801085b8:	75 86                	jne    80108540 <delete_mmaps+0x20>
801085ba:	8d 46 7c             	lea    0x7c(%esi),%eax
801085bd:	81 c6 7c 02 00 00    	add    $0x27c,%esi
801085c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801085c7:	90                   	nop
    mmap->addr = 0; // note to future changed this from a 0 to a -1
801085c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for(int i = 0; i < MAX_NMMAP;i++)
801085ce:	83 c0 20             	add    $0x20,%eax
    mmap->length = -1;
801085d1:	c7 40 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%eax)
    mmap->flags = -1;
801085d8:	c7 40 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%eax)
    mmap->fd = -1;
801085df:	c7 40 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%eax)
    mmap->f = 0;
801085e6:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
    mmap->refcnt = 0;
801085ed:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
    mmap->n_loaded_pages = 0;
801085f4:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    mmap->next = 0;
801085fb:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for(int i = 0; i < MAX_NMMAP;i++)
80108602:	39 c6                	cmp    %eax,%esi
80108604:	75 c2                	jne    801085c8 <delete_mmaps+0xa8>

    init_mmaps(curproc);


    return 0;
80108606:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108609:	31 c0                	xor    %eax,%eax
8010860b:	5b                   	pop    %ebx
8010860c:	5e                   	pop    %esi
8010860d:	5f                   	pop    %edi
8010860e:	5d                   	pop    %ebp
8010860f:	c3                   	ret    
            remove_map(cur_node->addr);
80108610:	83 ec 0c             	sub    $0xc,%esp
80108613:	ff 33                	push   (%ebx)
80108615:	e8 d6 f5 ff ff       	call   80107bf0 <remove_map>
8010861a:	83 c4 10             	add    $0x10,%esp
8010861d:	e9 29 ff ff ff       	jmp    8010854b <delete_mmaps+0x2b>

80108622 <remove_map.cold>:
    if(cur_node->addr == addr)
80108622:	a1 00 00 00 00       	mov    0x0,%eax
80108627:	0f 0b                	ud2    

80108629 <sys_wpunmap.cold>:
    int lower_is_equal = addr == cur_node->addr;
80108629:	a1 00 00 00 00       	mov    0x0,%eax
8010862e:	0f 0b                	ud2    
