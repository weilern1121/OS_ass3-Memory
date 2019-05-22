
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 32 10 80       	mov    $0x80103270,%eax
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
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 7a 10 80       	push   $0x80107a60
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 a5 48 00 00       	call   80104900 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 7a 10 80       	push   $0x80107a67
80100097:	50                   	push   %eax
80100098:	e8 53 47 00 00       	call   801047f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 07 49 00 00       	call   801049f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 a9 49 00 00       	call   80104b10 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 46 00 00       	call   80104830 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 23 00 00       	call   801024f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 6e 7a 10 80       	push   $0x80107a6e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 47 00 00       	call   801048d0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 27 23 00 00       	jmp    801024f0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 7a 10 80       	push   $0x80107a7f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 46 00 00       	call   801048d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 46 00 00       	call   80104890 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 e0 47 00 00       	call   801049f0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 af 48 00 00       	jmp    80104b10 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 7a 10 80       	push   $0x80107a86
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 1b 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 5f 47 00 00       	call   801049f0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 06 41 00 00       	call   801043d0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 80 39 00 00       	call   80103c60 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 1c 48 00 00       	call   80104b10 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 c4 13 00 00       	call   801016c0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 be 47 00 00       	call   80104b10 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 66 13 00 00       	call   801016c0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 52 27 00 00       	call   80102b00 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 7a 10 80       	push   $0x80107a8d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 7b 84 10 80 	movl   $0x8010847b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 43 45 00 00       	call   80104920 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 7a 10 80       	push   $0x80107aa1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 f1 5d 00 00       	call   80106230 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 3f 5d 00 00       	call   80106230 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 5d 00 00       	call   80106230 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 5d 00 00       	call   80106230 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 f7 46 00 00       	call   80104c20 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 2a 46 00 00       	call   80104b70 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 7a 10 80       	push   $0x80107aa5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 d0 7a 10 80 	movzbl -0x7fef8530(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 8c 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 d0 43 00 00       	call   801049f0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 c4 44 00 00       	call   80104b10 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 6b 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 ec 43 00 00       	call   80104b10 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba b8 7a 10 80       	mov    $0x80107ab8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 fb 41 00 00       	call   801049f0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 7a 10 80       	push   $0x80107abf
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 c8 41 00 00       	call   801049f0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100856:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 83 42 00 00       	call   80104b10 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100911:	68 a0 0f 11 80       	push   $0x80110fa0
80100916:	e8 25 3d 00 00       	call   80104640 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010093d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100964:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 84 3d 00 00       	jmp    80104720 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 c8 7a 10 80       	push   $0x80107ac8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 2b 3f 00 00       	call   80104900 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 a2 1c 00 00       	call   801026a0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv) {
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3 + MAXARG + 1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
80100a1c:	e8 3f 32 00 00       	call   80103c60 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

    begin_op();
80100a27:	e8 44 25 00 00       	call   80102f70 <begin_op>

    if ((ip = namei(path)) == 0) {
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 e9 14 00 00       	call   80101f20 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 73 0c 00 00       	call   801016c0 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char *) &elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 42 0f 00 00       	call   801019a0 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

    bad:
    if (pgdir)
        freevm(pgdir);
    if (ip) {
        iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 e1 0e 00 00       	call   80101950 <iunlockput>
        end_op();
80100a6f:	e8 6c 25 00 00       	call   80102fe0 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
    }
    if (DEBUGMODE == 1)
        cprintf(">EXEC-FAILED-GOTO_BAD!\t");
    return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
    if ((pgdir = setupkvm()) == 0)
80100a94:	e8 67 6c 00 00       	call   80107700 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
    sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 bc 02 00 00    	je     80100d7b <exec+0x36b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
        if (ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
        if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 65 67 00 00       	call   80107260 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
        if (ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
        if (loaduvm(pgdir, (char *) ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 13 65 00 00       	call   80107040 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
        if (readi(ip, (char *) &ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 43 0e 00 00       	call   801019a0 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
        freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 c9 6a 00 00       	call   80107640 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
    iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 b6 0d 00 00       	call   80101950 <iunlockput>
    end_op();
80100b9a:	e8 41 24 00 00       	call   80102fe0 <end_op>
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 b1 66 00 00       	call   80107260 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
        freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 7a 6a 00 00       	call   80107640 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
        end_op();
80100bd3:	e8 08 24 00 00       	call   80102fe0 <end_op>
        cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 e1 7a 10 80       	push   $0x80107ae1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
        return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
    clearpteu(pgdir, (char *) (sz - 2 * PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
    for (argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
    clearpteu(pgdir, (char *) (sz - 2 * PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 95 6b 00 00       	call   801077a0 <clearpteu>
    for (argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 52 41 00 00       	call   80104d90 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	59                   	pop    %ecx
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 3f 41 00 00       	call   80104d90 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 5e 6d 00 00       	call   801079c0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
    for (argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
        ustack[3 + argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    for (argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
        ustack[3 + argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    for (argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
    ustack[3 + argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
    ustack[1] = argc;
80100ca1:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
    sp -= (3 + argc + 1) * 4;
80100ca7:	89 df                	mov    %ebx,%edi
    ustack[0] = 0xffffffff;  // fake return PC
80100ca9:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cb0:	ff ff ff 
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100cb3:	29 c1                	sub    %eax,%ecx
    sp -= (3 + argc + 1) * 4;
80100cb5:	83 c0 0c             	add    $0xc,%eax
80100cb8:	29 c7                	sub    %eax,%edi
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100cba:	50                   	push   %eax
80100cbb:	52                   	push   %edx
80100cbc:	57                   	push   %edi
80100cbd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100cc3:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100cc9:	e8 f2 6c 00 00       	call   801079c0 <copyout>
80100cce:	83 c4 10             	add    $0x10,%esp
80100cd1:	85 c0                	test   %eax,%eax
80100cd3:	0f 88 df fe ff ff    	js     80100bb8 <exec+0x1a8>
    for (last = s = path; *s; s++)
80100cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdc:	0f b6 00             	movzbl (%eax),%eax
80100cdf:	84 c0                	test   %al,%al
80100ce1:	74 17                	je     80100cfa <exec+0x2ea>
80100ce3:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce6:	89 d1                	mov    %edx,%ecx
80100ce8:	83 c1 01             	add    $0x1,%ecx
80100ceb:	3c 2f                	cmp    $0x2f,%al
80100ced:	0f b6 01             	movzbl (%ecx),%eax
80100cf0:	0f 44 d1             	cmove  %ecx,%edx
80100cf3:	84 c0                	test   %al,%al
80100cf5:	75 f1                	jne    80100ce8 <exec+0x2d8>
80100cf7:	89 55 08             	mov    %edx,0x8(%ebp)
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cfa:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100d00:	52                   	push   %edx
80100d01:	6a 10                	push   $0x10
80100d03:	ff 75 08             	pushl  0x8(%ebp)
80100d06:	89 d8                	mov    %ebx,%eax
80100d08:	83 c0 6c             	add    $0x6c,%eax
80100d0b:	50                   	push   %eax
80100d0c:	e8 3f 40 00 00       	call   80104d50 <safestrcpy>
    oldpgdir = curproc->pgdir;
80100d11:	89 d8                	mov    %ebx,%eax
    if (curproc->swapFile) {
80100d13:	83 c4 10             	add    $0x10,%esp
    curproc->pgdir = pgdir;
80100d16:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
    if (curproc->swapFile) {
80100d1c:	83 78 7c 00          	cmpl   $0x0,0x7c(%eax)
    oldpgdir = curproc->pgdir;
80100d20:	8b 5b 04             	mov    0x4(%ebx),%ebx
    curproc->pgdir = pgdir;
80100d23:	89 50 04             	mov    %edx,0x4(%eax)
    if (curproc->swapFile) {
80100d26:	74 1e                	je     80100d46 <exec+0x336>
        removeSwapFile(curproc);
80100d28:	83 ec 0c             	sub    $0xc,%esp
80100d2b:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100d31:	50                   	push   %eax
80100d32:	e8 b9 12 00 00       	call   80101ff0 <removeSwapFile>
        createSwapFile(curproc);
80100d37:	58                   	pop    %eax
80100d38:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d3e:	e8 ad 14 00 00       	call   801021f0 <createSwapFile>
80100d43:	83 c4 10             	add    $0x10,%esp
    curproc->sz = sz;
80100d46:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    switchuvm(curproc);
80100d4c:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80100d4f:	89 31                	mov    %esi,(%ecx)
    curproc->tf->eip = elf.entry;  // main
80100d51:	8b 41 18             	mov    0x18(%ecx),%eax
80100d54:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d5a:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
80100d5d:	8b 41 18             	mov    0x18(%ecx),%eax
80100d60:	89 78 44             	mov    %edi,0x44(%eax)
    switchuvm(curproc);
80100d63:	51                   	push   %ecx
80100d64:	e8 47 61 00 00       	call   80106eb0 <switchuvm>
    freevm(oldpgdir);
80100d69:	89 1c 24             	mov    %ebx,(%esp)
80100d6c:	e8 cf 68 00 00       	call   80107640 <freevm>
    return 0;
80100d71:	83 c4 10             	add    $0x10,%esp
80100d74:	31 c0                	xor    %eax,%eax
80100d76:	e9 01 fd ff ff       	jmp    80100a7c <exec+0x6c>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100d7b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d80:	e9 0c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d85:	66 90                	xchg   %ax,%ax
80100d87:	66 90                	xchg   %ax,%ax
80100d89:	66 90                	xchg   %ax,%ax
80100d8b:	66 90                	xchg   %ax,%ax
80100d8d:	66 90                	xchg   %ax,%ax
80100d8f:	90                   	nop

80100d90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d96:	68 ed 7a 10 80       	push   $0x80107aed
80100d9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100da0:	e8 5b 3b 00 00       	call   80104900 <initlock>
}
80100da5:	83 c4 10             	add    $0x10,%esp
80100da8:	c9                   	leave  
80100da9:	c3                   	ret    
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100db0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100db9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dbc:	68 c0 0f 11 80       	push   $0x80110fc0
80100dc1:	e8 2a 3c 00 00       	call   801049f0 <acquire>
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	eb 10                	jmp    80100ddb <filealloc+0x2b>
80100dcb:	90                   	nop
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100dd9:	73 25                	jae    80100e00 <filealloc+0x50>
    if(f->ref == 0){
80100ddb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	75 ee                	jne    80100dd0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100de2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100de5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dec:	68 c0 0f 11 80       	push   $0x80110fc0
80100df1:	e8 1a 3d 00 00       	call   80104b10 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100df6:	89 d8                	mov    %ebx,%eax
      return f;
80100df8:	83 c4 10             	add    $0x10,%esp
}
80100dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dfe:	c9                   	leave  
80100dff:	c3                   	ret    
  release(&ftable.lock);
80100e00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e03:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e05:	68 c0 0f 11 80       	push   $0x80110fc0
80100e0a:	e8 01 3d 00 00       	call   80104b10 <release>
}
80100e0f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e11:	83 c4 10             	add    $0x10,%esp
}
80100e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e17:	c9                   	leave  
80100e18:	c3                   	ret    
80100e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
80100e24:	83 ec 10             	sub    $0x10,%esp
80100e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e2a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e2f:	e8 bc 3b 00 00       	call   801049f0 <acquire>
  if(f->ref < 1)
80100e34:	8b 43 04             	mov    0x4(%ebx),%eax
80100e37:	83 c4 10             	add    $0x10,%esp
80100e3a:	85 c0                	test   %eax,%eax
80100e3c:	7e 1a                	jle    80100e58 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e3e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e41:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e44:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e47:	68 c0 0f 11 80       	push   $0x80110fc0
80100e4c:	e8 bf 3c 00 00       	call   80104b10 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 f4 7a 10 80       	push   $0x80107af4
80100e60:	e8 2b f5 ff ff       	call   80100390 <panic>
80100e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	57                   	push   %edi
80100e74:	56                   	push   %esi
80100e75:	53                   	push   %ebx
80100e76:	83 ec 28             	sub    $0x28,%esp
80100e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e7c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e81:	e8 6a 3b 00 00       	call   801049f0 <acquire>
  if(f->ref < 1)
80100e86:	8b 43 04             	mov    0x4(%ebx),%eax
80100e89:	83 c4 10             	add    $0x10,%esp
80100e8c:	85 c0                	test   %eax,%eax
80100e8e:	0f 8e 9b 00 00 00    	jle    80100f2f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e94:	83 e8 01             	sub    $0x1,%eax
80100e97:	85 c0                	test   %eax,%eax
80100e99:	89 43 04             	mov    %eax,0x4(%ebx)
80100e9c:	74 1a                	je     80100eb8 <fileclose+0x48>
    release(&ftable.lock);
80100e9e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ea8:	5b                   	pop    %ebx
80100ea9:	5e                   	pop    %esi
80100eaa:	5f                   	pop    %edi
80100eab:	5d                   	pop    %ebp
    release(&ftable.lock);
80100eac:	e9 5f 3c 00 00       	jmp    80104b10 <release>
80100eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100eb8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ebc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100ebe:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ec1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ec4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eca:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ecd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ed8:	e8 33 3c 00 00       	call   80104b10 <release>
  if(ff.type == FD_PIPE)
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	83 ff 01             	cmp    $0x1,%edi
80100ee3:	74 13                	je     80100ef8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ee5:	83 ff 02             	cmp    $0x2,%edi
80100ee8:	74 26                	je     80100f10 <fileclose+0xa0>
}
80100eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eed:	5b                   	pop    %ebx
80100eee:	5e                   	pop    %esi
80100eef:	5f                   	pop    %edi
80100ef0:	5d                   	pop    %ebp
80100ef1:	c3                   	ret    
80100ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ef8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100efc:	83 ec 08             	sub    $0x8,%esp
80100eff:	53                   	push   %ebx
80100f00:	56                   	push   %esi
80100f01:	e8 1a 28 00 00       	call   80103720 <pipeclose>
80100f06:	83 c4 10             	add    $0x10,%esp
80100f09:	eb df                	jmp    80100eea <fileclose+0x7a>
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f10:	e8 5b 20 00 00       	call   80102f70 <begin_op>
    iput(ff.ip);
80100f15:	83 ec 0c             	sub    $0xc,%esp
80100f18:	ff 75 e0             	pushl  -0x20(%ebp)
80100f1b:	e8 d0 08 00 00       	call   801017f0 <iput>
    end_op();
80100f20:	83 c4 10             	add    $0x10,%esp
}
80100f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f26:	5b                   	pop    %ebx
80100f27:	5e                   	pop    %esi
80100f28:	5f                   	pop    %edi
80100f29:	5d                   	pop    %ebp
    end_op();
80100f2a:	e9 b1 20 00 00       	jmp    80102fe0 <end_op>
    panic("fileclose");
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	68 fc 7a 10 80       	push   $0x80107afc
80100f37:	e8 54 f4 ff ff       	call   80100390 <panic>
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	53                   	push   %ebx
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f4a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f4d:	75 31                	jne    80100f80 <filestat+0x40>
    ilock(f->ip);
80100f4f:	83 ec 0c             	sub    $0xc,%esp
80100f52:	ff 73 10             	pushl  0x10(%ebx)
80100f55:	e8 66 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f5a:	58                   	pop    %eax
80100f5b:	5a                   	pop    %edx
80100f5c:	ff 75 0c             	pushl  0xc(%ebp)
80100f5f:	ff 73 10             	pushl  0x10(%ebx)
80100f62:	e8 09 0a 00 00       	call   80101970 <stati>
    iunlock(f->ip);
80100f67:	59                   	pop    %ecx
80100f68:	ff 73 10             	pushl  0x10(%ebx)
80100f6b:	e8 30 08 00 00       	call   801017a0 <iunlock>
    return 0;
80100f70:	83 c4 10             	add    $0x10,%esp
80100f73:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f85:	eb ee                	jmp    80100f75 <filestat+0x35>
80100f87:	89 f6                	mov    %esi,%esi
80100f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f90 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	57                   	push   %edi
80100f94:	56                   	push   %esi
80100f95:	53                   	push   %ebx
80100f96:	83 ec 0c             	sub    $0xc,%esp
80100f99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fa2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fa6:	74 60                	je     80101008 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fa8:	8b 03                	mov    (%ebx),%eax
80100faa:	83 f8 01             	cmp    $0x1,%eax
80100fad:	74 41                	je     80100ff0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100faf:	83 f8 02             	cmp    $0x2,%eax
80100fb2:	75 5b                	jne    8010100f <fileread+0x7f>
    ilock(f->ip);
80100fb4:	83 ec 0c             	sub    $0xc,%esp
80100fb7:	ff 73 10             	pushl  0x10(%ebx)
80100fba:	e8 01 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fbf:	57                   	push   %edi
80100fc0:	ff 73 14             	pushl  0x14(%ebx)
80100fc3:	56                   	push   %esi
80100fc4:	ff 73 10             	pushl  0x10(%ebx)
80100fc7:	e8 d4 09 00 00       	call   801019a0 <readi>
80100fcc:	83 c4 20             	add    $0x20,%esp
80100fcf:	85 c0                	test   %eax,%eax
80100fd1:	89 c6                	mov    %eax,%esi
80100fd3:	7e 03                	jle    80100fd8 <fileread+0x48>
      f->off += r;
80100fd5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fd8:	83 ec 0c             	sub    $0xc,%esp
80100fdb:	ff 73 10             	pushl  0x10(%ebx)
80100fde:	e8 bd 07 00 00       	call   801017a0 <iunlock>
    return r;
80100fe3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	89 f0                	mov    %esi,%eax
80100feb:	5b                   	pop    %ebx
80100fec:	5e                   	pop    %esi
80100fed:	5f                   	pop    %edi
80100fee:	5d                   	pop    %ebp
80100fef:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100ff0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100ff3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff9:	5b                   	pop    %ebx
80100ffa:	5e                   	pop    %esi
80100ffb:	5f                   	pop    %edi
80100ffc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100ffd:	e9 ce 28 00 00       	jmp    801038d0 <piperead>
80101002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101008:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010100d:	eb d7                	jmp    80100fe6 <fileread+0x56>
  panic("fileread");
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 06 7b 10 80       	push   $0x80107b06
80101017:	e8 74 f3 ff ff       	call   80100390 <panic>
8010101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101020 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 1c             	sub    $0x1c,%esp
80101029:	8b 75 08             	mov    0x8(%ebp),%esi
8010102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010102f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101033:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101036:	8b 45 10             	mov    0x10(%ebp),%eax
80101039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010103c:	0f 84 aa 00 00 00    	je     801010ec <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101042:	8b 06                	mov    (%esi),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	0f 84 c3 00 00 00    	je     80101110 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104d:	83 f8 02             	cmp    $0x2,%eax
80101050:	0f 85 d9 00 00 00    	jne    8010112f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101059:	31 ff                	xor    %edi,%edi
    while(i < n){
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 34                	jg     80101093 <filewrite+0x73>
8010105f:	e9 9c 00 00 00       	jmp    80101100 <filewrite+0xe0>
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101068:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101071:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101074:	e8 27 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101079:	e8 62 1f 00 00       	call   80102fe0 <end_op>
8010107e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101081:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101084:	39 c3                	cmp    %eax,%ebx
80101086:	0f 85 96 00 00 00    	jne    80101122 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010108c:	01 df                	add    %ebx,%edi
    while(i < n){
8010108e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101091:	7e 6d                	jle    80101100 <filewrite+0xe0>
      int n1 = n - i;
80101093:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101096:	b8 00 06 00 00       	mov    $0x600,%eax
8010109b:	29 fb                	sub    %edi,%ebx
8010109d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010a3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010a6:	e8 c5 1e 00 00       	call   80102f70 <begin_op>
      ilock(f->ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 76 10             	pushl  0x10(%esi)
801010b1:	e8 0a 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b9:	53                   	push   %ebx
801010ba:	ff 76 14             	pushl  0x14(%esi)
801010bd:	01 f8                	add    %edi,%eax
801010bf:	50                   	push   %eax
801010c0:	ff 76 10             	pushl  0x10(%esi)
801010c3:	e8 d8 09 00 00       	call   80101aa0 <writei>
801010c8:	83 c4 20             	add    $0x20,%esp
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 99                	jg     80101068 <filewrite+0x48>
      iunlock(f->ip);
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	ff 76 10             	pushl  0x10(%esi)
801010d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010d8:	e8 c3 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010dd:	e8 fe 1e 00 00       	call   80102fe0 <end_op>
      if(r < 0)
801010e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e5:	83 c4 10             	add    $0x10,%esp
801010e8:	85 c0                	test   %eax,%eax
801010ea:	74 98                	je     80101084 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010f4:	89 f8                	mov    %edi,%eax
801010f6:	5b                   	pop    %ebx
801010f7:	5e                   	pop    %esi
801010f8:	5f                   	pop    %edi
801010f9:	5d                   	pop    %ebp
801010fa:	c3                   	ret    
801010fb:	90                   	nop
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101100:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101103:	75 e7                	jne    801010ec <filewrite+0xcc>
}
80101105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101108:	89 f8                	mov    %edi,%eax
8010110a:	5b                   	pop    %ebx
8010110b:	5e                   	pop    %esi
8010110c:	5f                   	pop    %edi
8010110d:	5d                   	pop    %ebp
8010110e:	c3                   	ret    
8010110f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101110:	8b 46 0c             	mov    0xc(%esi),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010111d:	e9 9e 26 00 00       	jmp    801037c0 <pipewrite>
        panic("short filewrite");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 0f 7b 10 80       	push   $0x80107b0f
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 15 7b 10 80       	push   $0x80107b15
80101137:	e8 54 f2 ff ff       	call   80100390 <panic>
8010113c:	66 90                	xchg   %ax,%ax
8010113e:	66 90                	xchg   %ax,%ax

80101140 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101149:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010114f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101152:	85 c9                	test   %ecx,%ecx
80101154:	0f 84 87 00 00 00    	je     801011e1 <balloc+0xa1>
8010115a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101161:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101164:	83 ec 08             	sub    $0x8,%esp
80101167:	89 f0                	mov    %esi,%eax
80101169:	c1 f8 0c             	sar    $0xc,%eax
8010116c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101172:	50                   	push   %eax
80101173:	ff 75 d8             	pushl  -0x28(%ebp)
80101176:	e8 55 ef ff ff       	call   801000d0 <bread>
8010117b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101183:	83 c4 10             	add    $0x10,%esp
80101186:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101189:	31 c0                	xor    %eax,%eax
8010118b:	eb 2f                	jmp    801011bc <balloc+0x7c>
8010118d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101190:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101192:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101195:	bb 01 00 00 00       	mov    $0x1,%ebx
8010119a:	83 e1 07             	and    $0x7,%ecx
8010119d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010119f:	89 c1                	mov    %eax,%ecx
801011a1:	c1 f9 03             	sar    $0x3,%ecx
801011a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011a9:	85 df                	test   %ebx,%edi
801011ab:	89 fa                	mov    %edi,%edx
801011ad:	74 41                	je     801011f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011af:	83 c0 01             	add    $0x1,%eax
801011b2:	83 c6 01             	add    $0x1,%esi
801011b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011ba:	74 05                	je     801011c1 <balloc+0x81>
801011bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011bf:	77 cf                	ja     80101190 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801011c7:	e8 14 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801011cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011d3:	83 c4 10             	add    $0x10,%esp
801011d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011d9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801011df:	77 80                	ja     80101161 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011e1:	83 ec 0c             	sub    $0xc,%esp
801011e4:	68 1f 7b 10 80       	push   $0x80107b1f
801011e9:	e8 a2 f1 ff ff       	call   80100390 <panic>
801011ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011f6:	09 da                	or     %ebx,%edx
801011f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011fc:	57                   	push   %edi
801011fd:	e8 3e 1f 00 00       	call   80103140 <log_write>
        brelse(bp);
80101202:	89 3c 24             	mov    %edi,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010120a:	58                   	pop    %eax
8010120b:	5a                   	pop    %edx
8010120c:	56                   	push   %esi
8010120d:	ff 75 d8             	pushl  -0x28(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101217:	8d 40 5c             	lea    0x5c(%eax),%eax
8010121a:	83 c4 0c             	add    $0xc,%esp
8010121d:	68 00 02 00 00       	push   $0x200
80101222:	6a 00                	push   $0x0
80101224:	50                   	push   %eax
80101225:	e8 46 39 00 00       	call   80104b70 <memset>
  log_write(bp);
8010122a:	89 1c 24             	mov    %ebx,(%esp)
8010122d:	e8 0e 1f 00 00       	call   80103140 <log_write>
  brelse(bp);
80101232:	89 1c 24             	mov    %ebx,(%esp)
80101235:	e8 a6 ef ff ff       	call   801001e0 <brelse>
}
8010123a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010123d:	89 f0                	mov    %esi,%eax
8010123f:	5b                   	pop    %ebx
80101240:	5e                   	pop    %esi
80101241:	5f                   	pop    %edi
80101242:	5d                   	pop    %ebp
80101243:	c3                   	ret    
80101244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010124a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101250 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101258:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010125f:	83 ec 28             	sub    $0x28,%esp
80101262:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101265:	68 e0 19 11 80       	push   $0x801119e0
8010126a:	e8 81 37 00 00       	call   801049f0 <acquire>
8010126f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101275:	eb 17                	jmp    8010128e <iget+0x3e>
80101277:	89 f6                	mov    %esi,%esi
80101279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101280:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101286:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010128c:	73 22                	jae    801012b0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010128e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101291:	85 c9                	test   %ecx,%ecx
80101293:	7e 04                	jle    80101299 <iget+0x49>
80101295:	39 3b                	cmp    %edi,(%ebx)
80101297:	74 4f                	je     801012e8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101299:	85 f6                	test   %esi,%esi
8010129b:	75 e3                	jne    80101280 <iget+0x30>
8010129d:	85 c9                	test   %ecx,%ecx
8010129f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012a8:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012ae:	72 de                	jb     8010128e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 5b                	je     8010130f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012b4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012b7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012b9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012bc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012c3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ca:	68 e0 19 11 80       	push   $0x801119e0
801012cf:	e8 3c 38 00 00       	call   80104b10 <release>

  return ip;
801012d4:	83 c4 10             	add    $0x10,%esp
}
801012d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012da:	89 f0                	mov    %esi,%eax
801012dc:	5b                   	pop    %ebx
801012dd:	5e                   	pop    %esi
801012de:	5f                   	pop    %edi
801012df:	5d                   	pop    %ebp
801012e0:	c3                   	ret    
801012e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012e8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012eb:	75 ac                	jne    80101299 <iget+0x49>
      release(&icache.lock);
801012ed:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012f0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012f3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012f5:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
801012fa:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012fd:	e8 0e 38 00 00       	call   80104b10 <release>
      return ip;
80101302:	83 c4 10             	add    $0x10,%esp
}
80101305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101308:	89 f0                	mov    %esi,%eax
8010130a:	5b                   	pop    %ebx
8010130b:	5e                   	pop    %esi
8010130c:	5f                   	pop    %edi
8010130d:	5d                   	pop    %ebp
8010130e:	c3                   	ret    
    panic("iget: no inodes");
8010130f:	83 ec 0c             	sub    $0xc,%esp
80101312:	68 35 7b 10 80       	push   $0x80107b35
80101317:	e8 74 f0 ff ff       	call   80100390 <panic>
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
80101324:	56                   	push   %esi
80101325:	53                   	push   %ebx
80101326:	89 c6                	mov    %eax,%esi
80101328:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010132b:	83 fa 0b             	cmp    $0xb,%edx
8010132e:	77 18                	ja     80101348 <bmap+0x28>
80101330:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101333:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101336:	85 db                	test   %ebx,%ebx
80101338:	74 76                	je     801013b0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 d8                	mov    %ebx,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101348:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010134b:	83 fb 7f             	cmp    $0x7f,%ebx
8010134e:	0f 87 90 00 00 00    	ja     801013e4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101354:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010135a:	8b 00                	mov    (%eax),%eax
8010135c:	85 d2                	test   %edx,%edx
8010135e:	74 70                	je     801013d0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101360:	83 ec 08             	sub    $0x8,%esp
80101363:	52                   	push   %edx
80101364:	50                   	push   %eax
80101365:	e8 66 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010136a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010136e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101371:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101373:	8b 1a                	mov    (%edx),%ebx
80101375:	85 db                	test   %ebx,%ebx
80101377:	75 1d                	jne    80101396 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101379:	8b 06                	mov    (%esi),%eax
8010137b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010137e:	e8 bd fd ff ff       	call   80101140 <balloc>
80101383:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101386:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101389:	89 c3                	mov    %eax,%ebx
8010138b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010138d:	57                   	push   %edi
8010138e:	e8 ad 1d 00 00       	call   80103140 <log_write>
80101393:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101396:	83 ec 0c             	sub    $0xc,%esp
80101399:	57                   	push   %edi
8010139a:	e8 41 ee ff ff       	call   801001e0 <brelse>
8010139f:	83 c4 10             	add    $0x10,%esp
}
801013a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013a5:	89 d8                	mov    %ebx,%eax
801013a7:	5b                   	pop    %ebx
801013a8:	5e                   	pop    %esi
801013a9:	5f                   	pop    %edi
801013aa:	5d                   	pop    %ebp
801013ab:	c3                   	ret    
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801013b0:	8b 00                	mov    (%eax),%eax
801013b2:	e8 89 fd ff ff       	call   80101140 <balloc>
801013b7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801013bd:	89 c3                	mov    %eax,%ebx
}
801013bf:	89 d8                	mov    %ebx,%eax
801013c1:	5b                   	pop    %ebx
801013c2:	5e                   	pop    %esi
801013c3:	5f                   	pop    %edi
801013c4:	5d                   	pop    %ebp
801013c5:	c3                   	ret    
801013c6:	8d 76 00             	lea    0x0(%esi),%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013d0:	e8 6b fd ff ff       	call   80101140 <balloc>
801013d5:	89 c2                	mov    %eax,%edx
801013d7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013dd:	8b 06                	mov    (%esi),%eax
801013df:	e9 7c ff ff ff       	jmp    80101360 <bmap+0x40>
  panic("bmap: out of range");
801013e4:	83 ec 0c             	sub    $0xc,%esp
801013e7:	68 45 7b 10 80       	push   $0x80107b45
801013ec:	e8 9f ef ff ff       	call   80100390 <panic>
801013f1:	eb 0d                	jmp    80101400 <readsb>
801013f3:	90                   	nop
801013f4:	90                   	nop
801013f5:	90                   	nop
801013f6:	90                   	nop
801013f7:	90                   	nop
801013f8:	90                   	nop
801013f9:	90                   	nop
801013fa:	90                   	nop
801013fb:	90                   	nop
801013fc:	90                   	nop
801013fd:	90                   	nop
801013fe:	90                   	nop
801013ff:	90                   	nop

80101400 <readsb>:
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	56                   	push   %esi
80101404:	53                   	push   %ebx
80101405:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101408:	83 ec 08             	sub    $0x8,%esp
8010140b:	6a 01                	push   $0x1
8010140d:	ff 75 08             	pushl  0x8(%ebp)
80101410:	e8 bb ec ff ff       	call   801000d0 <bread>
80101415:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101417:	8d 40 5c             	lea    0x5c(%eax),%eax
8010141a:	83 c4 0c             	add    $0xc,%esp
8010141d:	6a 1c                	push   $0x1c
8010141f:	50                   	push   %eax
80101420:	56                   	push   %esi
80101421:	e8 fa 37 00 00       	call   80104c20 <memmove>
  brelse(bp);
80101426:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101429:	83 c4 10             	add    $0x10,%esp
}
8010142c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010142f:	5b                   	pop    %ebx
80101430:	5e                   	pop    %esi
80101431:	5d                   	pop    %ebp
  brelse(bp);
80101432:	e9 a9 ed ff ff       	jmp    801001e0 <brelse>
80101437:	89 f6                	mov    %esi,%esi
80101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101440 <bfree>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	89 d3                	mov    %edx,%ebx
80101447:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101449:	83 ec 08             	sub    $0x8,%esp
8010144c:	68 c0 19 11 80       	push   $0x801119c0
80101451:	50                   	push   %eax
80101452:	e8 a9 ff ff ff       	call   80101400 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101457:	58                   	pop    %eax
80101458:	5a                   	pop    %edx
80101459:	89 da                	mov    %ebx,%edx
8010145b:	c1 ea 0c             	shr    $0xc,%edx
8010145e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101464:	52                   	push   %edx
80101465:	56                   	push   %esi
80101466:	e8 65 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010146b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010146d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101470:	ba 01 00 00 00       	mov    $0x1,%edx
80101475:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101478:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010147e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101481:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101483:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101488:	85 d1                	test   %edx,%ecx
8010148a:	74 25                	je     801014b1 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010148c:	f7 d2                	not    %edx
8010148e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101490:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101493:	21 ca                	and    %ecx,%edx
80101495:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101499:	56                   	push   %esi
8010149a:	e8 a1 1c 00 00       	call   80103140 <log_write>
  brelse(bp);
8010149f:	89 34 24             	mov    %esi,(%esp)
801014a2:	e8 39 ed ff ff       	call   801001e0 <brelse>
}
801014a7:	83 c4 10             	add    $0x10,%esp
801014aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ad:	5b                   	pop    %ebx
801014ae:	5e                   	pop    %esi
801014af:	5d                   	pop    %ebp
801014b0:	c3                   	ret    
    panic("freeing free block");
801014b1:	83 ec 0c             	sub    $0xc,%esp
801014b4:	68 58 7b 10 80       	push   $0x80107b58
801014b9:	e8 d2 ee ff ff       	call   80100390 <panic>
801014be:	66 90                	xchg   %ax,%ax

801014c0 <iinit>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801014c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014cc:	68 6b 7b 10 80       	push   $0x80107b6b
801014d1:	68 e0 19 11 80       	push   $0x801119e0
801014d6:	e8 25 34 00 00       	call   80104900 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 72 7b 10 80       	push   $0x80107b72
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 fc 32 00 00       	call   801047f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014f4:	83 c4 10             	add    $0x10,%esp
801014f7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014fd:	75 e1                	jne    801014e0 <iinit+0x20>
  readsb(dev, &sb);
801014ff:	83 ec 08             	sub    $0x8,%esp
80101502:	68 c0 19 11 80       	push   $0x801119c0
80101507:	ff 75 08             	pushl  0x8(%ebp)
8010150a:	e8 f1 fe ff ff       	call   80101400 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010150f:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101515:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010151b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101521:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101527:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010152d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101533:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101539:	68 1c 7c 10 80       	push   $0x80107c1c
8010153e:	e8 1d f1 ff ff       	call   80100660 <cprintf>
}
80101543:	83 c4 30             	add    $0x30,%esp
80101546:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101549:	c9                   	leave  
8010154a:	c3                   	ret    
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101550 <ialloc>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101560:	8b 45 0c             	mov    0xc(%ebp),%eax
80101563:	8b 75 08             	mov    0x8(%ebp),%esi
80101566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101569:	0f 86 91 00 00 00    	jbe    80101600 <ialloc+0xb0>
8010156f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101574:	eb 21                	jmp    80101597 <ialloc+0x47>
80101576:	8d 76 00             	lea    0x0(%esi),%esi
80101579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101580:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101583:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101586:	57                   	push   %edi
80101587:	e8 54 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101595:	76 69                	jbe    80101600 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101597:	89 d8                	mov    %ebx,%eax
80101599:	83 ec 08             	sub    $0x8,%esp
8010159c:	c1 e8 03             	shr    $0x3,%eax
8010159f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015a5:	50                   	push   %eax
801015a6:	56                   	push   %esi
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015ae:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015b0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015b3:	83 e0 07             	and    $0x7,%eax
801015b6:	c1 e0 06             	shl    $0x6,%eax
801015b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015c1:	75 bd                	jne    80101580 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015c3:	83 ec 04             	sub    $0x4,%esp
801015c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015c9:	6a 40                	push   $0x40
801015cb:	6a 00                	push   $0x0
801015cd:	51                   	push   %ecx
801015ce:	e8 9d 35 00 00       	call   80104b70 <memset>
      dip->type = type;
801015d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015dd:	89 3c 24             	mov    %edi,(%esp)
801015e0:	e8 5b 1b 00 00       	call   80103140 <log_write>
      brelse(bp);
801015e5:	89 3c 24             	mov    %edi,(%esp)
801015e8:	e8 f3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ed:	83 c4 10             	add    $0x10,%esp
}
801015f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015f3:	89 da                	mov    %ebx,%edx
801015f5:	89 f0                	mov    %esi,%eax
}
801015f7:	5b                   	pop    %ebx
801015f8:	5e                   	pop    %esi
801015f9:	5f                   	pop    %edi
801015fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801015fb:	e9 50 fc ff ff       	jmp    80101250 <iget>
  panic("ialloc: no inodes");
80101600:	83 ec 0c             	sub    $0xc,%esp
80101603:	68 78 7b 10 80       	push   $0x80107b78
80101608:	e8 83 ed ff ff       	call   80100390 <panic>
8010160d:	8d 76 00             	lea    0x0(%esi),%esi

80101610 <iupdate>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101621:	c1 e8 03             	shr    $0x3,%eax
80101624:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010162a:	50                   	push   %eax
8010162b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010162e:	e8 9d ea ff ff       	call   801000d0 <bread>
80101633:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101635:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101638:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010163f:	83 e0 07             	and    $0x7,%eax
80101642:	c1 e0 06             	shl    $0x6,%eax
80101645:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101649:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010164c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101650:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101653:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101657:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010165b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010165f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101663:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101667:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010166a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166d:	6a 34                	push   $0x34
8010166f:	53                   	push   %ebx
80101670:	50                   	push   %eax
80101671:	e8 aa 35 00 00       	call   80104c20 <memmove>
  log_write(bp);
80101676:	89 34 24             	mov    %esi,(%esp)
80101679:	e8 c2 1a 00 00       	call   80103140 <log_write>
  brelse(bp);
8010167e:	89 75 08             	mov    %esi,0x8(%ebp)
80101681:	83 c4 10             	add    $0x10,%esp
}
80101684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101687:	5b                   	pop    %ebx
80101688:	5e                   	pop    %esi
80101689:	5d                   	pop    %ebp
  brelse(bp);
8010168a:	e9 51 eb ff ff       	jmp    801001e0 <brelse>
8010168f:	90                   	nop

80101690 <idup>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 10             	sub    $0x10,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	68 e0 19 11 80       	push   $0x801119e0
8010169f:	e8 4c 33 00 00       	call   801049f0 <acquire>
  ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016a8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016af:	e8 5c 34 00 00       	call   80104b10 <release>
}
801016b4:	89 d8                	mov    %ebx,%eax
801016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016b9:	c9                   	leave  
801016ba:	c3                   	ret    
801016bb:	90                   	nop
801016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016c0 <ilock>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016c8:	85 db                	test   %ebx,%ebx
801016ca:	0f 84 b7 00 00 00    	je     80101787 <ilock+0xc7>
801016d0:	8b 53 08             	mov    0x8(%ebx),%edx
801016d3:	85 d2                	test   %edx,%edx
801016d5:	0f 8e ac 00 00 00    	jle    80101787 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016db:	8d 43 0c             	lea    0xc(%ebx),%eax
801016de:	83 ec 0c             	sub    $0xc,%esp
801016e1:	50                   	push   %eax
801016e2:	e8 49 31 00 00       	call   80104830 <acquiresleep>
  if(ip->valid == 0){
801016e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ea:	83 c4 10             	add    $0x10,%esp
801016ed:	85 c0                	test   %eax,%eax
801016ef:	74 0f                	je     80101700 <ilock+0x40>
}
801016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f4:	5b                   	pop    %ebx
801016f5:	5e                   	pop    %esi
801016f6:	5d                   	pop    %ebp
801016f7:	c3                   	ret    
801016f8:	90                   	nop
801016f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101700:	8b 43 04             	mov    0x4(%ebx),%eax
80101703:	83 ec 08             	sub    $0x8,%esp
80101706:	c1 e8 03             	shr    $0x3,%eax
80101709:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010170f:	50                   	push   %eax
80101710:	ff 33                	pushl  (%ebx)
80101712:	e8 b9 e9 ff ff       	call   801000d0 <bread>
80101717:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101719:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101729:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010172c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010172f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101733:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101737:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010173b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010173f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101743:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101747:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010174b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010174e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101751:	6a 34                	push   $0x34
80101753:	50                   	push   %eax
80101754:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101757:	50                   	push   %eax
80101758:	e8 c3 34 00 00       	call   80104c20 <memmove>
    brelse(bp);
8010175d:	89 34 24             	mov    %esi,(%esp)
80101760:	e8 7b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101765:	83 c4 10             	add    $0x10,%esp
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 77 ff ff ff    	jne    801016f1 <ilock+0x31>
      panic("ilock: no type");
8010177a:	83 ec 0c             	sub    $0xc,%esp
8010177d:	68 90 7b 10 80       	push   $0x80107b90
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 8a 7b 10 80       	push   $0x80107b8a
8010178f:	e8 fc eb ff ff       	call   80100390 <panic>
80101794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010179a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017a0 <iunlock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	74 28                	je     801017d4 <iunlock+0x34>
801017ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801017af:	83 ec 0c             	sub    $0xc,%esp
801017b2:	56                   	push   %esi
801017b3:	e8 18 31 00 00       	call   801048d0 <holdingsleep>
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 c0                	test   %eax,%eax
801017bd:	74 15                	je     801017d4 <iunlock+0x34>
801017bf:	8b 43 08             	mov    0x8(%ebx),%eax
801017c2:	85 c0                	test   %eax,%eax
801017c4:	7e 0e                	jle    801017d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017cc:	5b                   	pop    %ebx
801017cd:	5e                   	pop    %esi
801017ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017cf:	e9 bc 30 00 00       	jmp    80104890 <releasesleep>
    panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 9f 7b 10 80       	push   $0x80107b9f
801017dc:	e8 af eb ff ff       	call   80100390 <panic>
801017e1:	eb 0d                	jmp    801017f0 <iput>
801017e3:	90                   	nop
801017e4:	90                   	nop
801017e5:	90                   	nop
801017e6:	90                   	nop
801017e7:	90                   	nop
801017e8:	90                   	nop
801017e9:	90                   	nop
801017ea:	90                   	nop
801017eb:	90                   	nop
801017ec:	90                   	nop
801017ed:	90                   	nop
801017ee:	90                   	nop
801017ef:	90                   	nop

801017f0 <iput>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 28             	sub    $0x28,%esp
801017f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ff:	57                   	push   %edi
80101800:	e8 2b 30 00 00       	call   80104830 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101805:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 d2                	test   %edx,%edx
8010180d:	74 07                	je     80101816 <iput+0x26>
8010180f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101814:	74 32                	je     80101848 <iput+0x58>
  releasesleep(&ip->lock);
80101816:	83 ec 0c             	sub    $0xc,%esp
80101819:	57                   	push   %edi
8010181a:	e8 71 30 00 00       	call   80104890 <releasesleep>
  acquire(&icache.lock);
8010181f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101826:	e8 c5 31 00 00       	call   801049f0 <acquire>
  ip->ref--;
8010182b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5f                   	pop    %edi
8010183f:	5d                   	pop    %ebp
  release(&icache.lock);
80101840:	e9 cb 32 00 00       	jmp    80104b10 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 e0 19 11 80       	push   $0x801119e0
80101850:	e8 9b 31 00 00       	call   801049f0 <acquire>
    int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101858:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010185f:	e8 ac 32 00 00       	call   80104b10 <release>
    if(r == 1){
80101864:	83 c4 10             	add    $0x10,%esp
80101867:	83 fe 01             	cmp    $0x1,%esi
8010186a:	75 aa                	jne    80101816 <iput+0x26>
8010186c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101872:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101875:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101878:	89 cf                	mov    %ecx,%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x97>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101883:	39 fe                	cmp    %edi,%esi
80101885:	74 19                	je     801018a0 <iput+0xb0>
    if(ip->addrs[i]){
80101887:	8b 16                	mov    (%esi),%edx
80101889:	85 d2                	test   %edx,%edx
8010188b:	74 f3                	je     80101880 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010188d:	8b 03                	mov    (%ebx),%eax
8010188f:	e8 ac fb ff ff       	call   80101440 <bfree>
      ip->addrs[i] = 0;
80101894:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010189a:	eb e4                	jmp    80101880 <iput+0x90>
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018a0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018a9:	85 c0                	test   %eax,%eax
801018ab:	75 33                	jne    801018e0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018ad:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018b0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018b7:	53                   	push   %ebx
801018b8:	e8 53 fd ff ff       	call   80101610 <iupdate>
      ip->type = 0;
801018bd:	31 c0                	xor    %eax,%eax
801018bf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018c3:	89 1c 24             	mov    %ebx,(%esp)
801018c6:	e8 45 fd ff ff       	call   80101610 <iupdate>
      ip->valid = 0;
801018cb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018d2:	83 c4 10             	add    $0x10,%esp
801018d5:	e9 3c ff ff ff       	jmp    80101816 <iput+0x26>
801018da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	83 ec 08             	sub    $0x8,%esp
801018e3:	50                   	push   %eax
801018e4:	ff 33                	pushl  (%ebx)
801018e6:	e8 e5 e7 ff ff       	call   801000d0 <bread>
801018eb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018f1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018f7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018fa:	83 c4 10             	add    $0x10,%esp
801018fd:	89 cf                	mov    %ecx,%edi
801018ff:	eb 0e                	jmp    8010190f <iput+0x11f>
80101901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101908:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010190b:	39 fe                	cmp    %edi,%esi
8010190d:	74 0f                	je     8010191e <iput+0x12e>
      if(a[j])
8010190f:	8b 16                	mov    (%esi),%edx
80101911:	85 d2                	test   %edx,%edx
80101913:	74 f3                	je     80101908 <iput+0x118>
        bfree(ip->dev, a[j]);
80101915:	8b 03                	mov    (%ebx),%eax
80101917:	e8 24 fb ff ff       	call   80101440 <bfree>
8010191c:	eb ea                	jmp    80101908 <iput+0x118>
    brelse(bp);
8010191e:	83 ec 0c             	sub    $0xc,%esp
80101921:	ff 75 e4             	pushl  -0x1c(%ebp)
80101924:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101927:	e8 b4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010192c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101932:	8b 03                	mov    (%ebx),%eax
80101934:	e8 07 fb ff ff       	call   80101440 <bfree>
    ip->addrs[NDIRECT] = 0;
80101939:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101940:	00 00 00 
80101943:	83 c4 10             	add    $0x10,%esp
80101946:	e9 62 ff ff ff       	jmp    801018ad <iput+0xbd>
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <iunlockput>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	53                   	push   %ebx
80101954:	83 ec 10             	sub    $0x10,%esp
80101957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010195a:	53                   	push   %ebx
8010195b:	e8 40 fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101960:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101963:	83 c4 10             	add    $0x10,%esp
}
80101966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101969:	c9                   	leave  
  iput(ip);
8010196a:	e9 81 fe ff ff       	jmp    801017f0 <iput>
8010196f:	90                   	nop

80101970 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	8b 55 08             	mov    0x8(%ebp),%edx
80101976:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101979:	8b 0a                	mov    (%edx),%ecx
8010197b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010197e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101981:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101984:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101988:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010198b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010198f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101993:	8b 52 58             	mov    0x58(%edx),%edx
80101996:	89 50 10             	mov    %edx,0x10(%eax)
}
80101999:	5d                   	pop    %ebp
8010199a:	c3                   	ret    
8010199b:	90                   	nop
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019a0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 1c             	sub    $0x1c,%esp
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	8b 75 0c             	mov    0xc(%ebp),%esi
801019af:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019b2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019b7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019bd:	8b 75 10             	mov    0x10(%ebp),%esi
801019c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019c3:	0f 84 a7 00 00 00    	je     80101a70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019cc:	8b 40 58             	mov    0x58(%eax),%eax
801019cf:	39 c6                	cmp    %eax,%esi
801019d1:	0f 87 ba 00 00 00    	ja     80101a91 <readi+0xf1>
801019d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019da:	89 f9                	mov    %edi,%ecx
801019dc:	01 f1                	add    %esi,%ecx
801019de:	0f 82 ad 00 00 00    	jb     80101a91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019e4:	89 c2                	mov    %eax,%edx
801019e6:	29 f2                	sub    %esi,%edx
801019e8:	39 c8                	cmp    %ecx,%eax
801019ea:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ed:	31 ff                	xor    %edi,%edi
801019ef:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f4:	74 6c                	je     80101a62 <readi+0xc2>
801019f6:	8d 76 00             	lea    0x0(%esi),%esi
801019f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a03:	89 f2                	mov    %esi,%edx
80101a05:	c1 ea 09             	shr    $0x9,%edx
80101a08:	89 d8                	mov    %ebx,%eax
80101a0a:	e8 11 f9 ff ff       	call   80101320 <bmap>
80101a0f:	83 ec 08             	sub    $0x8,%esp
80101a12:	50                   	push   %eax
80101a13:	ff 33                	pushl  (%ebx)
80101a15:	e8 b6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a1d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1f:	89 f0                	mov    %esi,%eax
80101a21:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a26:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a2b:	83 c4 0c             	add    $0xc,%esp
80101a2e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a30:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a34:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a37:	29 fb                	sub    %edi,%ebx
80101a39:	39 d9                	cmp    %ebx,%ecx
80101a3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a3e:	53                   	push   %ebx
80101a3f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a40:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a42:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a45:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a47:	e8 d4 31 00 00       	call   80104c20 <memmove>
    brelse(bp);
80101a4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a4f:	89 14 24             	mov    %edx,(%esp)
80101a52:	e8 89 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a5a:	83 c4 10             	add    $0x10,%esp
80101a5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a60:	77 9e                	ja     80101a00 <readi+0x60>
  }
  return n;
80101a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5f                   	pop    %edi
80101a6b:	5d                   	pop    %ebp
80101a6c:	c3                   	ret    
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a74:	66 83 f8 09          	cmp    $0x9,%ax
80101a78:	77 17                	ja     80101a91 <readi+0xf1>
80101a7a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a81:	85 c0                	test   %eax,%eax
80101a83:	74 0c                	je     80101a91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a8b:	5b                   	pop    %ebx
80101a8c:	5e                   	pop    %esi
80101a8d:	5f                   	pop    %edi
80101a8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a8f:	ff e0                	jmp    *%eax
      return -1;
80101a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a96:	eb cd                	jmp    80101a65 <readi+0xc5>
80101a98:	90                   	nop
80101a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aaf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ab7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101abd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 b7 00 00 00    	je     80101b80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	39 70 58             	cmp    %esi,0x58(%eax)
80101acf:	0f 82 eb 00 00 00    	jb     80101bc0 <writei+0x120>
80101ad5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ad8:	31 d2                	xor    %edx,%edx
80101ada:	89 f8                	mov    %edi,%eax
80101adc:	01 f0                	add    %esi,%eax
80101ade:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ae1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ae6:	0f 87 d4 00 00 00    	ja     80101bc0 <writei+0x120>
80101aec:	85 d2                	test   %edx,%edx
80101aee:	0f 85 cc 00 00 00    	jne    80101bc0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af4:	85 ff                	test   %edi,%edi
80101af6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101afd:	74 72                	je     80101b71 <writei+0xd1>
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 f8                	mov    %edi,%eax
80101b0a:	e8 11 f8 ff ff       	call   80101320 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 37                	pushl  (%edi)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b1d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b20:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b22:	89 f0                	mov    %esi,%eax
80101b24:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b29:	83 c4 0c             	add    $0xc,%esp
80101b2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b37:	39 d9                	cmp    %ebx,%ecx
80101b39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b3c:	53                   	push   %ebx
80101b3d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b40:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b42:	50                   	push   %eax
80101b43:	e8 d8 30 00 00       	call   80104c20 <memmove>
    log_write(bp);
80101b48:	89 3c 24             	mov    %edi,(%esp)
80101b4b:	e8 f0 15 00 00       	call   80103140 <log_write>
    brelse(bp);
80101b50:	89 3c 24             	mov    %edi,(%esp)
80101b53:	e8 88 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b5b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b5e:	83 c4 10             	add    $0x10,%esp
80101b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b67:	77 97                	ja     80101b00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b6f:	77 37                	ja     80101ba8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b77:	5b                   	pop    %ebx
80101b78:	5e                   	pop    %esi
80101b79:	5f                   	pop    %edi
80101b7a:	5d                   	pop    %ebp
80101b7b:	c3                   	ret    
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 36                	ja     80101bc0 <writei+0x120>
80101b8a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 2b                	je     80101bc0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b9f:	ff e0                	jmp    *%eax
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ba8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bb1:	50                   	push   %eax
80101bb2:	e8 59 fa ff ff       	call   80101610 <iupdate>
80101bb7:	83 c4 10             	add    $0x10,%esp
80101bba:	eb b5                	jmp    80101b71 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bc5:	eb ad                	jmp    80101b74 <writei+0xd4>
80101bc7:	89 f6                	mov    %esi,%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bd6:	6a 0e                	push   $0xe
80101bd8:	ff 75 0c             	pushl  0xc(%ebp)
80101bdb:	ff 75 08             	pushl  0x8(%ebp)
80101bde:	e8 ad 30 00 00       	call   80104c90 <strncmp>
}
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    
80101be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 1c             	sub    $0x1c,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c01:	0f 85 85 00 00 00    	jne    80101c8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c07:	8b 53 58             	mov    0x58(%ebx),%edx
80101c0a:	31 ff                	xor    %edi,%edi
80101c0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0f:	85 d2                	test   %edx,%edx
80101c11:	74 3e                	je     80101c51 <dirlookup+0x61>
80101c13:	90                   	nop
80101c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c18:	6a 10                	push   $0x10
80101c1a:	57                   	push   %edi
80101c1b:	56                   	push   %esi
80101c1c:	53                   	push   %ebx
80101c1d:	e8 7e fd ff ff       	call   801019a0 <readi>
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	83 f8 10             	cmp    $0x10,%eax
80101c28:	75 55                	jne    80101c7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c2f:	74 18                	je     80101c49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c34:	83 ec 04             	sub    $0x4,%esp
80101c37:	6a 0e                	push   $0xe
80101c39:	50                   	push   %eax
80101c3a:	ff 75 0c             	pushl  0xc(%ebp)
80101c3d:	e8 4e 30 00 00       	call   80104c90 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 17                	je     80101c60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c49:	83 c7 10             	add    $0x10,%edi
80101c4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c4f:	72 c7                	jb     80101c18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c54:	31 c0                	xor    %eax,%eax
}
80101c56:	5b                   	pop    %ebx
80101c57:	5e                   	pop    %esi
80101c58:	5f                   	pop    %edi
80101c59:	5d                   	pop    %ebp
80101c5a:	c3                   	ret    
80101c5b:	90                   	nop
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c60:	8b 45 10             	mov    0x10(%ebp),%eax
80101c63:	85 c0                	test   %eax,%eax
80101c65:	74 05                	je     80101c6c <dirlookup+0x7c>
        *poff = off;
80101c67:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c70:	8b 03                	mov    (%ebx),%eax
80101c72:	e8 d9 f5 ff ff       	call   80101250 <iget>
}
80101c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7a:	5b                   	pop    %ebx
80101c7b:	5e                   	pop    %esi
80101c7c:	5f                   	pop    %edi
80101c7d:	5d                   	pop    %ebp
80101c7e:	c3                   	ret    
      panic("dirlookup read");
80101c7f:	83 ec 0c             	sub    $0xc,%esp
80101c82:	68 b9 7b 10 80       	push   $0x80107bb9
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 a7 7b 10 80       	push   $0x80107ba7
80101c94:	e8 f7 e6 ff ff       	call   80100390 <panic>
80101c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ca0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	89 cf                	mov    %ecx,%edi
80101ca8:	89 c3                	mov    %eax,%ebx
80101caa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cad:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cb3:	0f 84 67 01 00 00    	je     80101e20 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cb9:	e8 a2 1f 00 00       	call   80103c60 <myproc>
  acquire(&icache.lock);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cc1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cc4:	68 e0 19 11 80       	push   $0x801119e0
80101cc9:	e8 22 2d 00 00       	call   801049f0 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cd9:	e8 32 2e 00 00       	call   80104b10 <release>
80101cde:	83 c4 10             	add    $0x10,%esp
80101ce1:	eb 08                	jmp    80101ceb <namex+0x4b>
80101ce3:	90                   	nop
80101ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ce8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ceb:	0f b6 03             	movzbl (%ebx),%eax
80101cee:	3c 2f                	cmp    $0x2f,%al
80101cf0:	74 f6                	je     80101ce8 <namex+0x48>
  if(*path == 0)
80101cf2:	84 c0                	test   %al,%al
80101cf4:	0f 84 ee 00 00 00    	je     80101de8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cfa:	0f b6 03             	movzbl (%ebx),%eax
80101cfd:	3c 2f                	cmp    $0x2f,%al
80101cff:	0f 84 b3 00 00 00    	je     80101db8 <namex+0x118>
80101d05:	84 c0                	test   %al,%al
80101d07:	89 da                	mov    %ebx,%edx
80101d09:	75 09                	jne    80101d14 <namex+0x74>
80101d0b:	e9 a8 00 00 00       	jmp    80101db8 <namex+0x118>
80101d10:	84 c0                	test   %al,%al
80101d12:	74 0a                	je     80101d1e <namex+0x7e>
    path++;
80101d14:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d17:	0f b6 02             	movzbl (%edx),%eax
80101d1a:	3c 2f                	cmp    $0x2f,%al
80101d1c:	75 f2                	jne    80101d10 <namex+0x70>
80101d1e:	89 d1                	mov    %edx,%ecx
80101d20:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d22:	83 f9 0d             	cmp    $0xd,%ecx
80101d25:	0f 8e 91 00 00 00    	jle    80101dbc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d2b:	83 ec 04             	sub    $0x4,%esp
80101d2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d31:	6a 0e                	push   $0xe
80101d33:	53                   	push   %ebx
80101d34:	57                   	push   %edi
80101d35:	e8 e6 2e 00 00       	call   80104c20 <memmove>
    path++;
80101d3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d3d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d40:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d42:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d45:	75 11                	jne    80101d58 <namex+0xb8>
80101d47:	89 f6                	mov    %esi,%esi
80101d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d56:	74 f8                	je     80101d50 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d58:	83 ec 0c             	sub    $0xc,%esp
80101d5b:	56                   	push   %esi
80101d5c:	e8 5f f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d61:	83 c4 10             	add    $0x10,%esp
80101d64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d69:	0f 85 91 00 00 00    	jne    80101e00 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d72:	85 d2                	test   %edx,%edx
80101d74:	74 09                	je     80101d7f <namex+0xdf>
80101d76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d79:	0f 84 b7 00 00 00    	je     80101e36 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d7f:	83 ec 04             	sub    $0x4,%esp
80101d82:	6a 00                	push   $0x0
80101d84:	57                   	push   %edi
80101d85:	56                   	push   %esi
80101d86:	e8 65 fe ff ff       	call   80101bf0 <dirlookup>
80101d8b:	83 c4 10             	add    $0x10,%esp
80101d8e:	85 c0                	test   %eax,%eax
80101d90:	74 6e                	je     80101e00 <namex+0x160>
  iunlock(ip);
80101d92:	83 ec 0c             	sub    $0xc,%esp
80101d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d98:	56                   	push   %esi
80101d99:	e8 02 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d9e:	89 34 24             	mov    %esi,(%esp)
80101da1:	e8 4a fa ff ff       	call   801017f0 <iput>
80101da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da9:	83 c4 10             	add    $0x10,%esp
80101dac:	89 c6                	mov    %eax,%esi
80101dae:	e9 38 ff ff ff       	jmp    80101ceb <namex+0x4b>
80101db3:	90                   	nop
80101db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101db8:	89 da                	mov    %ebx,%edx
80101dba:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dbc:	83 ec 04             	sub    $0x4,%esp
80101dbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc5:	51                   	push   %ecx
80101dc6:	53                   	push   %ebx
80101dc7:	57                   	push   %edi
80101dc8:	e8 53 2e 00 00       	call   80104c20 <memmove>
    name[len] = 0;
80101dcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dd3:	83 c4 10             	add    $0x10,%esp
80101dd6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dda:	89 d3                	mov    %edx,%ebx
80101ddc:	e9 61 ff ff ff       	jmp    80101d42 <namex+0xa2>
80101de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101deb:	85 c0                	test   %eax,%eax
80101ded:	75 5d                	jne    80101e4c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101def:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df2:	89 f0                	mov    %esi,%eax
80101df4:	5b                   	pop    %ebx
80101df5:	5e                   	pop    %esi
80101df6:	5f                   	pop    %edi
80101df7:	5d                   	pop    %ebp
80101df8:	c3                   	ret    
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e00:	83 ec 0c             	sub    $0xc,%esp
80101e03:	56                   	push   %esi
80101e04:	e8 97 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101e09:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e0c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e0e:	e8 dd f9 ff ff       	call   801017f0 <iput>
      return 0;
80101e13:	83 c4 10             	add    $0x10,%esp
}
80101e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e19:	89 f0                	mov    %esi,%eax
80101e1b:	5b                   	pop    %ebx
80101e1c:	5e                   	pop    %esi
80101e1d:	5f                   	pop    %edi
80101e1e:	5d                   	pop    %ebp
80101e1f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e20:	ba 01 00 00 00       	mov    $0x1,%edx
80101e25:	b8 01 00 00 00       	mov    $0x1,%eax
80101e2a:	e8 21 f4 ff ff       	call   80101250 <iget>
80101e2f:	89 c6                	mov    %eax,%esi
80101e31:	e9 b5 fe ff ff       	jmp    80101ceb <namex+0x4b>
      iunlock(ip);
80101e36:	83 ec 0c             	sub    $0xc,%esp
80101e39:	56                   	push   %esi
80101e3a:	e8 61 f9 ff ff       	call   801017a0 <iunlock>
      return ip;
80101e3f:	83 c4 10             	add    $0x10,%esp
}
80101e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e45:	89 f0                	mov    %esi,%eax
80101e47:	5b                   	pop    %ebx
80101e48:	5e                   	pop    %esi
80101e49:	5f                   	pop    %edi
80101e4a:	5d                   	pop    %ebp
80101e4b:	c3                   	ret    
    iput(ip);
80101e4c:	83 ec 0c             	sub    $0xc,%esp
80101e4f:	56                   	push   %esi
    return 0;
80101e50:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e52:	e8 99 f9 ff ff       	call   801017f0 <iput>
    return 0;
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	eb 93                	jmp    80101def <namex+0x14f>
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e60 <dirlink>:
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	83 ec 20             	sub    $0x20,%esp
80101e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e6c:	6a 00                	push   $0x0
80101e6e:	ff 75 0c             	pushl  0xc(%ebp)
80101e71:	53                   	push   %ebx
80101e72:	e8 79 fd ff ff       	call   80101bf0 <dirlookup>
80101e77:	83 c4 10             	add    $0x10,%esp
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	75 67                	jne    80101ee5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e7e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e81:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e84:	85 ff                	test   %edi,%edi
80101e86:	74 29                	je     80101eb1 <dirlink+0x51>
80101e88:	31 ff                	xor    %edi,%edi
80101e8a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e8d:	eb 09                	jmp    80101e98 <dirlink+0x38>
80101e8f:	90                   	nop
80101e90:	83 c7 10             	add    $0x10,%edi
80101e93:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e96:	73 19                	jae    80101eb1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e98:	6a 10                	push   $0x10
80101e9a:	57                   	push   %edi
80101e9b:	56                   	push   %esi
80101e9c:	53                   	push   %ebx
80101e9d:	e8 fe fa ff ff       	call   801019a0 <readi>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	83 f8 10             	cmp    $0x10,%eax
80101ea8:	75 4e                	jne    80101ef8 <dirlink+0x98>
    if(de.inum == 0)
80101eaa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eaf:	75 df                	jne    80101e90 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101eb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb4:	83 ec 04             	sub    $0x4,%esp
80101eb7:	6a 0e                	push   $0xe
80101eb9:	ff 75 0c             	pushl  0xc(%ebp)
80101ebc:	50                   	push   %eax
80101ebd:	e8 2e 2e 00 00       	call   80104cf0 <strncpy>
  de.inum = inum;
80101ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec5:	6a 10                	push   $0x10
80101ec7:	57                   	push   %edi
80101ec8:	56                   	push   %esi
80101ec9:	53                   	push   %ebx
  de.inum = inum;
80101eca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ece:	e8 cd fb ff ff       	call   80101aa0 <writei>
80101ed3:	83 c4 20             	add    $0x20,%esp
80101ed6:	83 f8 10             	cmp    $0x10,%eax
80101ed9:	75 2a                	jne    80101f05 <dirlink+0xa5>
  return 0;
80101edb:	31 c0                	xor    %eax,%eax
}
80101edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
    iput(ip);
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	50                   	push   %eax
80101ee9:	e8 02 f9 ff ff       	call   801017f0 <iput>
    return -1;
80101eee:	83 c4 10             	add    $0x10,%esp
80101ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef6:	eb e5                	jmp    80101edd <dirlink+0x7d>
      panic("dirlink read");
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 c8 7b 10 80       	push   $0x80107bc8
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 11 82 10 80       	push   $0x80108211
80101f0d:	e8 7e e4 ff ff       	call   80100390 <panic>
80101f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <namei>:

struct inode*
namei(char *path)
{
80101f20:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f21:	31 d2                	xor    %edx,%edx
{
80101f23:	89 e5                	mov    %esp,%ebp
80101f25:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f2e:	e8 6d fd ff ff       	call   80101ca0 <namex>
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    
80101f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f40:	55                   	push   %ebp
  return namex(path, 1, name);
80101f41:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f46:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f4e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f4f:	e9 4c fd ff ff       	jmp    80101ca0 <namex>
80101f54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f60 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f60:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f61:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101f66:	89 e5                	mov    %esp,%ebp
80101f68:	57                   	push   %edi
80101f69:	56                   	push   %esi
80101f6a:	53                   	push   %ebx
80101f6b:	83 ec 10             	sub    $0x10,%esp
80101f6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f71:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f78:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f7f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101f83:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101f87:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101f8a:	85 c9                	test   %ecx,%ecx
80101f8c:	79 0a                	jns    80101f98 <itoa+0x38>
80101f8e:	89 f0                	mov    %esi,%eax
80101f90:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80101f93:	f7 d9                	neg    %ecx
        *p++ = '-';
80101f95:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80101f98:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f9a:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f9f:	90                   	nop
80101fa0:	89 d8                	mov    %ebx,%eax
80101fa2:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80101fa5:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101fa8:	f7 ef                	imul   %edi
80101faa:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101fad:	29 da                	sub    %ebx,%edx
80101faf:	89 d3                	mov    %edx,%ebx
80101fb1:	75 ed                	jne    80101fa0 <itoa+0x40>
    *p = '\0';
80101fb3:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101fb6:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101fbb:	90                   	nop
80101fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fc0:	89 c8                	mov    %ecx,%eax
80101fc2:	83 ee 01             	sub    $0x1,%esi
80101fc5:	f7 eb                	imul   %ebx
80101fc7:	89 c8                	mov    %ecx,%eax
80101fc9:	c1 f8 1f             	sar    $0x1f,%eax
80101fcc:	c1 fa 02             	sar    $0x2,%edx
80101fcf:	29 c2                	sub    %eax,%edx
80101fd1:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101fd4:	01 c0                	add    %eax,%eax
80101fd6:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101fd8:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
80101fda:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101fdf:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80101fe1:	88 06                	mov    %al,(%esi)
    }while(i);
80101fe3:	75 db                	jne    80101fc0 <itoa+0x60>
    return b;
}
80101fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5f                   	pop    %edi
80101fee:	5d                   	pop    %ebp
80101fef:	c3                   	ret    

80101ff0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101ff6:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80101ff9:	83 ec 40             	sub    $0x40,%esp
80101ffc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80101fff:	6a 06                	push   $0x6
80102001:	68 d5 7b 10 80       	push   $0x80107bd5
80102006:	56                   	push   %esi
80102007:	e8 14 2c 00 00       	call   80104c20 <memmove>
  itoa(p->pid, path+ 6);
8010200c:	58                   	pop    %eax
8010200d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102010:	5a                   	pop    %edx
80102011:	50                   	push   %eax
80102012:	ff 73 10             	pushl  0x10(%ebx)
80102015:	e8 46 ff ff ff       	call   80101f60 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010201a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010201d:	83 c4 10             	add    $0x10,%esp
80102020:	85 c0                	test   %eax,%eax
80102022:	0f 84 88 01 00 00    	je     801021b0 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102028:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010202b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010202e:	50                   	push   %eax
8010202f:	e8 3c ee ff ff       	call   80100e70 <fileclose>

  begin_op();
80102034:	e8 37 0f 00 00       	call   80102f70 <begin_op>
  return namex(path, 1, name);
80102039:	89 f0                	mov    %esi,%eax
8010203b:	89 d9                	mov    %ebx,%ecx
8010203d:	ba 01 00 00 00       	mov    $0x1,%edx
80102042:	e8 59 fc ff ff       	call   80101ca0 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010204c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010204e:	0f 84 66 01 00 00    	je     801021ba <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102054:	83 ec 0c             	sub    $0xc,%esp
80102057:	50                   	push   %eax
80102058:	e8 63 f6 ff ff       	call   801016c0 <ilock>
  return strncmp(s, t, DIRSIZ);
8010205d:	83 c4 0c             	add    $0xc,%esp
80102060:	6a 0e                	push   $0xe
80102062:	68 dd 7b 10 80       	push   $0x80107bdd
80102067:	53                   	push   %ebx
80102068:	e8 23 2c 00 00       	call   80104c90 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010206d:	83 c4 10             	add    $0x10,%esp
80102070:	85 c0                	test   %eax,%eax
80102072:	0f 84 f8 00 00 00    	je     80102170 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102078:	83 ec 04             	sub    $0x4,%esp
8010207b:	6a 0e                	push   $0xe
8010207d:	68 dc 7b 10 80       	push   $0x80107bdc
80102082:	53                   	push   %ebx
80102083:	e8 08 2c 00 00       	call   80104c90 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	85 c0                	test   %eax,%eax
8010208d:	0f 84 dd 00 00 00    	je     80102170 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102093:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102096:	83 ec 04             	sub    $0x4,%esp
80102099:	50                   	push   %eax
8010209a:	53                   	push   %ebx
8010209b:	56                   	push   %esi
8010209c:	e8 4f fb ff ff       	call   80101bf0 <dirlookup>
801020a1:	83 c4 10             	add    $0x10,%esp
801020a4:	85 c0                	test   %eax,%eax
801020a6:	89 c3                	mov    %eax,%ebx
801020a8:	0f 84 c2 00 00 00    	je     80102170 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
801020ae:	83 ec 0c             	sub    $0xc,%esp
801020b1:	50                   	push   %eax
801020b2:	e8 09 f6 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
801020b7:	83 c4 10             	add    $0x10,%esp
801020ba:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801020bf:	0f 8e 11 01 00 00    	jle    801021d6 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801020c5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020ca:	74 74                	je     80102140 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801020cc:	8d 7d d8             	lea    -0x28(%ebp),%edi
801020cf:	83 ec 04             	sub    $0x4,%esp
801020d2:	6a 10                	push   $0x10
801020d4:	6a 00                	push   $0x0
801020d6:	57                   	push   %edi
801020d7:	e8 94 2a 00 00       	call   80104b70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020dc:	6a 10                	push   $0x10
801020de:	ff 75 b8             	pushl  -0x48(%ebp)
801020e1:	57                   	push   %edi
801020e2:	56                   	push   %esi
801020e3:	e8 b8 f9 ff ff       	call   80101aa0 <writei>
801020e8:	83 c4 20             	add    $0x20,%esp
801020eb:	83 f8 10             	cmp    $0x10,%eax
801020ee:	0f 85 d5 00 00 00    	jne    801021c9 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020f4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020f9:	0f 84 91 00 00 00    	je     80102190 <removeSwapFile+0x1a0>
  iunlock(ip);
801020ff:	83 ec 0c             	sub    $0xc,%esp
80102102:	56                   	push   %esi
80102103:	e8 98 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102108:	89 34 24             	mov    %esi,(%esp)
8010210b:	e8 e0 f6 ff ff       	call   801017f0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102110:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102115:	89 1c 24             	mov    %ebx,(%esp)
80102118:	e8 f3 f4 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
8010211d:	89 1c 24             	mov    %ebx,(%esp)
80102120:	e8 7b f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102125:	89 1c 24             	mov    %ebx,(%esp)
80102128:	e8 c3 f6 ff ff       	call   801017f0 <iput>
  iunlockput(ip);

  end_op();
8010212d:	e8 ae 0e 00 00       	call   80102fe0 <end_op>

  return 0;
80102132:	83 c4 10             	add    $0x10,%esp
80102135:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102137:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010213a:	5b                   	pop    %ebx
8010213b:	5e                   	pop    %esi
8010213c:	5f                   	pop    %edi
8010213d:	5d                   	pop    %ebp
8010213e:	c3                   	ret    
8010213f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102140:	83 ec 0c             	sub    $0xc,%esp
80102143:	53                   	push   %ebx
80102144:	e8 07 32 00 00       	call   80105350 <isdirempty>
80102149:	83 c4 10             	add    $0x10,%esp
8010214c:	85 c0                	test   %eax,%eax
8010214e:	0f 85 78 ff ff ff    	jne    801020cc <removeSwapFile+0xdc>
  iunlock(ip);
80102154:	83 ec 0c             	sub    $0xc,%esp
80102157:	53                   	push   %ebx
80102158:	e8 43 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
8010215d:	89 1c 24             	mov    %ebx,(%esp)
80102160:	e8 8b f6 ff ff       	call   801017f0 <iput>
80102165:	83 c4 10             	add    $0x10,%esp
80102168:	90                   	nop
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	56                   	push   %esi
80102174:	e8 27 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102179:	89 34 24             	mov    %esi,(%esp)
8010217c:	e8 6f f6 ff ff       	call   801017f0 <iput>
    end_op();
80102181:	e8 5a 0e 00 00       	call   80102fe0 <end_op>
    return -1;
80102186:	83 c4 10             	add    $0x10,%esp
80102189:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010218e:	eb a7                	jmp    80102137 <removeSwapFile+0x147>
    dp->nlink--;
80102190:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	56                   	push   %esi
80102199:	e8 72 f4 ff ff       	call   80101610 <iupdate>
8010219e:	83 c4 10             	add    $0x10,%esp
801021a1:	e9 59 ff ff ff       	jmp    801020ff <removeSwapFile+0x10f>
801021a6:	8d 76 00             	lea    0x0(%esi),%esi
801021a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801021b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b5:	e9 7d ff ff ff       	jmp    80102137 <removeSwapFile+0x147>
    end_op();
801021ba:	e8 21 0e 00 00       	call   80102fe0 <end_op>
    return -1;
801021bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c4:	e9 6e ff ff ff       	jmp    80102137 <removeSwapFile+0x147>
    panic("unlink: writei");
801021c9:	83 ec 0c             	sub    $0xc,%esp
801021cc:	68 f1 7b 10 80       	push   $0x80107bf1
801021d1:	e8 ba e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021d6:	83 ec 0c             	sub    $0xc,%esp
801021d9:	68 df 7b 10 80       	push   $0x80107bdf
801021de:	e8 ad e1 ff ff       	call   80100390 <panic>
801021e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021f0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p) {
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	56                   	push   %esi
801021f4:	53                   	push   %ebx

    char path[DIGITS];
    memmove(path, "/.swap", 6);
801021f5:	8d 75 ea             	lea    -0x16(%ebp),%esi
createSwapFile(struct proc* p) {
801021f8:	83 ec 14             	sub    $0x14,%esp
801021fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    memmove(path, "/.swap", 6);
801021fe:	6a 06                	push   $0x6
80102200:	68 d5 7b 10 80       	push   $0x80107bd5
80102205:	56                   	push   %esi
80102206:	e8 15 2a 00 00       	call   80104c20 <memmove>
    itoa(p->pid, path + 6);
8010220b:	58                   	pop    %eax
8010220c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010220f:	5a                   	pop    %edx
80102210:	50                   	push   %eax
80102211:	ff 73 10             	pushl  0x10(%ebx)
80102214:	e8 47 fd ff ff       	call   80101f60 <itoa>

    begin_op();
80102219:	e8 52 0d 00 00       	call   80102f70 <begin_op>
    struct inode *in = create(path, T_FILE, 0, 0);
8010221e:	6a 00                	push   $0x0
80102220:	6a 00                	push   $0x0
80102222:	6a 02                	push   $0x2
80102224:	56                   	push   %esi
80102225:	e8 36 33 00 00       	call   80105560 <create>
    iunlock(in);
8010222a:	83 c4 14             	add    $0x14,%esp
    struct inode *in = create(path, T_FILE, 0, 0);
8010222d:	89 c6                	mov    %eax,%esi
    iunlock(in);
8010222f:	50                   	push   %eax
80102230:	e8 6b f5 ff ff       	call   801017a0 <iunlock>

    p->swapFile = filealloc();
80102235:	e8 76 eb ff ff       	call   80100db0 <filealloc>
    if (p->swapFile == 0)
8010223a:	83 c4 10             	add    $0x10,%esp
8010223d:	85 c0                	test   %eax,%eax
    p->swapFile = filealloc();
8010223f:	89 43 7c             	mov    %eax,0x7c(%ebx)
    if (p->swapFile == 0)
80102242:	74 32                	je     80102276 <createSwapFile+0x86>
        panic("no slot for files on /store");

    p->swapFile->ip = in;
80102244:	89 70 10             	mov    %esi,0x10(%eax)
    p->swapFile->type = FD_INODE;
80102247:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010224a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    p->swapFile->off = 0;
80102250:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102253:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    p->swapFile->readable = O_WRONLY;
8010225a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010225d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
    p->swapFile->writable = O_RDWR;
80102261:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102264:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102268:	e8 73 0d 00 00       	call   80102fe0 <end_op>

    return 0;
}
8010226d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102270:	31 c0                	xor    %eax,%eax
80102272:	5b                   	pop    %ebx
80102273:	5e                   	pop    %esi
80102274:	5d                   	pop    %ebp
80102275:	c3                   	ret    
        panic("no slot for files on /store");
80102276:	83 ec 0c             	sub    $0xc,%esp
80102279:	68 00 7c 10 80       	push   $0x80107c00
8010227e:	e8 0d e1 ff ff       	call   80100390 <panic>
80102283:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102296:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102299:	8b 50 7c             	mov    0x7c(%eax),%edx
8010229c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010229f:	8b 55 14             	mov    0x14(%ebp),%edx
801022a2:	89 55 10             	mov    %edx,0x10(%ebp)
801022a5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022a8:	89 45 08             	mov    %eax,0x8(%ebp)

}
801022ab:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
801022ac:	e9 6f ed ff ff       	jmp    80101020 <filewrite>
801022b1:	eb 0d                	jmp    801022c0 <readFromSwapFile>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022c9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022cc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
801022cf:	8b 55 14             	mov    0x14(%ebp),%edx
801022d2:	89 55 10             	mov    %edx,0x10(%ebp)
801022d5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022d8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801022db:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801022dc:	e9 af ec ff ff       	jmp    80100f90 <fileread>
801022e1:	66 90                	xchg   %ax,%ax
801022e3:	66 90                	xchg   %ax,%ax
801022e5:	66 90                	xchg   %ax,%ax
801022e7:	66 90                	xchg   %ax,%ax
801022e9:	66 90                	xchg   %ax,%ax
801022eb:	66 90                	xchg   %ax,%ax
801022ed:	66 90                	xchg   %ax,%ax
801022ef:	90                   	nop

801022f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	57                   	push   %edi
801022f4:	56                   	push   %esi
801022f5:	53                   	push   %ebx
801022f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801022f9:	85 c0                	test   %eax,%eax
801022fb:	0f 84 b4 00 00 00    	je     801023b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102301:	8b 58 08             	mov    0x8(%eax),%ebx
80102304:	89 c6                	mov    %eax,%esi
80102306:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010230c:	0f 87 96 00 00 00    	ja     801023a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102312:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102317:	89 f6                	mov    %esi,%esi
80102319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102320:	89 ca                	mov    %ecx,%edx
80102322:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102323:	83 e0 c0             	and    $0xffffffc0,%eax
80102326:	3c 40                	cmp    $0x40,%al
80102328:	75 f6                	jne    80102320 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010232a:	31 ff                	xor    %edi,%edi
8010232c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102331:	89 f8                	mov    %edi,%eax
80102333:	ee                   	out    %al,(%dx)
80102334:	b8 01 00 00 00       	mov    $0x1,%eax
80102339:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010233e:	ee                   	out    %al,(%dx)
8010233f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102344:	89 d8                	mov    %ebx,%eax
80102346:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102347:	89 d8                	mov    %ebx,%eax
80102349:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010234e:	c1 f8 08             	sar    $0x8,%eax
80102351:	ee                   	out    %al,(%dx)
80102352:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102357:	89 f8                	mov    %edi,%eax
80102359:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010235a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010235e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102363:	c1 e0 04             	shl    $0x4,%eax
80102366:	83 e0 10             	and    $0x10,%eax
80102369:	83 c8 e0             	or     $0xffffffe0,%eax
8010236c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010236d:	f6 06 04             	testb  $0x4,(%esi)
80102370:	75 16                	jne    80102388 <idestart+0x98>
80102372:	b8 20 00 00 00       	mov    $0x20,%eax
80102377:	89 ca                	mov    %ecx,%edx
80102379:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010237a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010237d:	5b                   	pop    %ebx
8010237e:	5e                   	pop    %esi
8010237f:	5f                   	pop    %edi
80102380:	5d                   	pop    %ebp
80102381:	c3                   	ret    
80102382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102388:	b8 30 00 00 00       	mov    $0x30,%eax
8010238d:	89 ca                	mov    %ecx,%edx
8010238f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102390:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102395:	83 c6 5c             	add    $0x5c,%esi
80102398:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010239d:	fc                   	cld    
8010239e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801023a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023a3:	5b                   	pop    %ebx
801023a4:	5e                   	pop    %esi
801023a5:	5f                   	pop    %edi
801023a6:	5d                   	pop    %ebp
801023a7:	c3                   	ret    
    panic("incorrect blockno");
801023a8:	83 ec 0c             	sub    $0xc,%esp
801023ab:	68 78 7c 10 80       	push   $0x80107c78
801023b0:	e8 db df ff ff       	call   80100390 <panic>
    panic("idestart");
801023b5:	83 ec 0c             	sub    $0xc,%esp
801023b8:	68 6f 7c 10 80       	push   $0x80107c6f
801023bd:	e8 ce df ff ff       	call   80100390 <panic>
801023c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <ideinit>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023d6:	68 8a 7c 10 80       	push   $0x80107c8a
801023db:	68 80 b5 10 80       	push   $0x8010b580
801023e0:	e8 1b 25 00 00       	call   80104900 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023e5:	58                   	pop    %eax
801023e6:	a1 00 3d 11 80       	mov    0x80113d00,%eax
801023eb:	5a                   	pop    %edx
801023ec:	83 e8 01             	sub    $0x1,%eax
801023ef:	50                   	push   %eax
801023f0:	6a 0e                	push   $0xe
801023f2:	e8 a9 02 00 00       	call   801026a0 <ioapicenable>
801023f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ff:	90                   	nop
80102400:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102401:	83 e0 c0             	and    $0xffffffc0,%eax
80102404:	3c 40                	cmp    $0x40,%al
80102406:	75 f8                	jne    80102400 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102408:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010240d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102412:	ee                   	out    %al,(%dx)
80102413:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102418:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010241d:	eb 06                	jmp    80102425 <ideinit+0x55>
8010241f:	90                   	nop
  for(i=0; i<1000; i++){
80102420:	83 e9 01             	sub    $0x1,%ecx
80102423:	74 0f                	je     80102434 <ideinit+0x64>
80102425:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102426:	84 c0                	test   %al,%al
80102428:	74 f6                	je     80102420 <ideinit+0x50>
      havedisk1 = 1;
8010242a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102431:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102434:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102439:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010243e:	ee                   	out    %al,(%dx)
}
8010243f:	c9                   	leave  
80102440:	c3                   	ret    
80102441:	eb 0d                	jmp    80102450 <ideintr>
80102443:	90                   	nop
80102444:	90                   	nop
80102445:	90                   	nop
80102446:	90                   	nop
80102447:	90                   	nop
80102448:	90                   	nop
80102449:	90                   	nop
8010244a:	90                   	nop
8010244b:	90                   	nop
8010244c:	90                   	nop
8010244d:	90                   	nop
8010244e:	90                   	nop
8010244f:	90                   	nop

80102450 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	57                   	push   %edi
80102454:	56                   	push   %esi
80102455:	53                   	push   %ebx
80102456:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102459:	68 80 b5 10 80       	push   $0x8010b580
8010245e:	e8 8d 25 00 00       	call   801049f0 <acquire>

  if((b = idequeue) == 0){
80102463:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102469:	83 c4 10             	add    $0x10,%esp
8010246c:	85 db                	test   %ebx,%ebx
8010246e:	74 67                	je     801024d7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102470:	8b 43 58             	mov    0x58(%ebx),%eax
80102473:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102478:	8b 3b                	mov    (%ebx),%edi
8010247a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102480:	75 31                	jne    801024b3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102482:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102487:	89 f6                	mov    %esi,%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102490:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102491:	89 c6                	mov    %eax,%esi
80102493:	83 e6 c0             	and    $0xffffffc0,%esi
80102496:	89 f1                	mov    %esi,%ecx
80102498:	80 f9 40             	cmp    $0x40,%cl
8010249b:	75 f3                	jne    80102490 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010249d:	a8 21                	test   $0x21,%al
8010249f:	75 12                	jne    801024b3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801024a1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801024a4:	b9 80 00 00 00       	mov    $0x80,%ecx
801024a9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024ae:	fc                   	cld    
801024af:	f3 6d                	rep insl (%dx),%es:(%edi)
801024b1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024b3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801024b6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801024b9:	89 f9                	mov    %edi,%ecx
801024bb:	83 c9 02             	or     $0x2,%ecx
801024be:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801024c0:	53                   	push   %ebx
801024c1:	e8 7a 21 00 00       	call   80104640 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801024c6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801024cb:	83 c4 10             	add    $0x10,%esp
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 05                	je     801024d7 <ideintr+0x87>
    idestart(idequeue);
801024d2:	e8 19 fe ff ff       	call   801022f0 <idestart>
    release(&idelock);
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	68 80 b5 10 80       	push   $0x8010b580
801024df:	e8 2c 26 00 00       	call   80104b10 <release>

  release(&idelock);
}
801024e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024e7:	5b                   	pop    %ebx
801024e8:	5e                   	pop    %esi
801024e9:	5f                   	pop    %edi
801024ea:	5d                   	pop    %ebp
801024eb:	c3                   	ret    
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	53                   	push   %ebx
801024f4:	83 ec 10             	sub    $0x10,%esp
801024f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801024fd:	50                   	push   %eax
801024fe:	e8 cd 23 00 00       	call   801048d0 <holdingsleep>
80102503:	83 c4 10             	add    $0x10,%esp
80102506:	85 c0                	test   %eax,%eax
80102508:	0f 84 c6 00 00 00    	je     801025d4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010250e:	8b 03                	mov    (%ebx),%eax
80102510:	83 e0 06             	and    $0x6,%eax
80102513:	83 f8 02             	cmp    $0x2,%eax
80102516:	0f 84 ab 00 00 00    	je     801025c7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010251c:	8b 53 04             	mov    0x4(%ebx),%edx
8010251f:	85 d2                	test   %edx,%edx
80102521:	74 0d                	je     80102530 <iderw+0x40>
80102523:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102528:	85 c0                	test   %eax,%eax
8010252a:	0f 84 b1 00 00 00    	je     801025e1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 80 b5 10 80       	push   $0x8010b580
80102538:	e8 b3 24 00 00       	call   801049f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010253d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102543:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102546:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010254d:	85 d2                	test   %edx,%edx
8010254f:	75 09                	jne    8010255a <iderw+0x6a>
80102551:	eb 6d                	jmp    801025c0 <iderw+0xd0>
80102553:	90                   	nop
80102554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102558:	89 c2                	mov    %eax,%edx
8010255a:	8b 42 58             	mov    0x58(%edx),%eax
8010255d:	85 c0                	test   %eax,%eax
8010255f:	75 f7                	jne    80102558 <iderw+0x68>
80102561:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102564:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102566:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010256c:	74 42                	je     801025b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010256e:	8b 03                	mov    (%ebx),%eax
80102570:	83 e0 06             	and    $0x6,%eax
80102573:	83 f8 02             	cmp    $0x2,%eax
80102576:	74 23                	je     8010259b <iderw+0xab>
80102578:	90                   	nop
80102579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102580:	83 ec 08             	sub    $0x8,%esp
80102583:	68 80 b5 10 80       	push   $0x8010b580
80102588:	53                   	push   %ebx
80102589:	e8 42 1e 00 00       	call   801043d0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010258e:	8b 03                	mov    (%ebx),%eax
80102590:	83 c4 10             	add    $0x10,%esp
80102593:	83 e0 06             	and    $0x6,%eax
80102596:	83 f8 02             	cmp    $0x2,%eax
80102599:	75 e5                	jne    80102580 <iderw+0x90>
  }


  release(&idelock);
8010259b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801025a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025a5:	c9                   	leave  
  release(&idelock);
801025a6:	e9 65 25 00 00       	jmp    80104b10 <release>
801025ab:	90                   	nop
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801025b0:	89 d8                	mov    %ebx,%eax
801025b2:	e8 39 fd ff ff       	call   801022f0 <idestart>
801025b7:	eb b5                	jmp    8010256e <iderw+0x7e>
801025b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025c0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801025c5:	eb 9d                	jmp    80102564 <iderw+0x74>
    panic("iderw: nothing to do");
801025c7:	83 ec 0c             	sub    $0xc,%esp
801025ca:	68 a4 7c 10 80       	push   $0x80107ca4
801025cf:	e8 bc dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	68 8e 7c 10 80       	push   $0x80107c8e
801025dc:	e8 af dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025e1:	83 ec 0c             	sub    $0xc,%esp
801025e4:	68 b9 7c 10 80       	push   $0x80107cb9
801025e9:	e8 a2 dd ff ff       	call   80100390 <panic>
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025f1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801025f8:	00 c0 fe 
{
801025fb:	89 e5                	mov    %esp,%ebp
801025fd:	56                   	push   %esi
801025fe:	53                   	push   %ebx
  ioapic->reg = reg;
801025ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102606:	00 00 00 
  return ioapic->data;
80102609:	a1 34 36 11 80       	mov    0x80113634,%eax
8010260e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102617:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010261d:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102624:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102627:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010262a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010262d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102630:	39 c2                	cmp    %eax,%edx
80102632:	74 16                	je     8010264a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102634:	83 ec 0c             	sub    $0xc,%esp
80102637:	68 d8 7c 10 80       	push   $0x80107cd8
8010263c:	e8 1f e0 ff ff       	call   80100660 <cprintf>
80102641:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102647:	83 c4 10             	add    $0x10,%esp
8010264a:	83 c3 21             	add    $0x21,%ebx
{
8010264d:	ba 10 00 00 00       	mov    $0x10,%edx
80102652:	b8 20 00 00 00       	mov    $0x20,%eax
80102657:	89 f6                	mov    %esi,%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102660:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102662:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102668:	89 c6                	mov    %eax,%esi
8010266a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102670:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102673:	89 71 10             	mov    %esi,0x10(%ecx)
80102676:	8d 72 01             	lea    0x1(%edx),%esi
80102679:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010267c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010267e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102680:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102686:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010268d:	75 d1                	jne    80102660 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010268f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102692:	5b                   	pop    %ebx
80102693:	5e                   	pop    %esi
80102694:	5d                   	pop    %ebp
80102695:	c3                   	ret    
80102696:	8d 76 00             	lea    0x0(%esi),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801026a0:	55                   	push   %ebp
  ioapic->reg = reg;
801026a1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
801026a7:	89 e5                	mov    %esp,%ebp
801026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801026ac:	8d 50 20             	lea    0x20(%eax),%edx
801026af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801026b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026b5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801026c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026c6:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801026ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret    
801026d3:	66 90                	xchg   %ax,%ax
801026d5:	66 90                	xchg   %ax,%ax
801026d7:	66 90                	xchg   %ax,%ax
801026d9:	66 90                	xchg   %ax,%ax
801026db:	66 90                	xchg   %ax,%ax
801026dd:	66 90                	xchg   %ax,%ax
801026df:	90                   	nop

801026e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	53                   	push   %ebx
801026e4:	83 ec 04             	sub    $0x4,%esp
801026e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026f0:	75 70                	jne    80102762 <kfree+0x82>
801026f2:	81 fb a8 69 12 80    	cmp    $0x801269a8,%ebx
801026f8:	72 68                	jb     80102762 <kfree+0x82>
801026fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102700:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102705:	77 5b                	ja     80102762 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102707:	83 ec 04             	sub    $0x4,%esp
8010270a:	68 00 10 00 00       	push   $0x1000
8010270f:	6a 01                	push   $0x1
80102711:	53                   	push   %ebx
80102712:	e8 59 24 00 00       	call   80104b70 <memset>

  if(kmem.use_lock)
80102717:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	85 d2                	test   %edx,%edx
80102722:	75 2c                	jne    80102750 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102724:	a1 78 36 11 80       	mov    0x80113678,%eax
80102729:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010272b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102730:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102736:	85 c0                	test   %eax,%eax
80102738:	75 06                	jne    80102740 <kfree+0x60>
    release(&kmem.lock);
}
8010273a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010273d:	c9                   	leave  
8010273e:	c3                   	ret    
8010273f:	90                   	nop
    release(&kmem.lock);
80102740:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102747:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010274a:	c9                   	leave  
    release(&kmem.lock);
8010274b:	e9 c0 23 00 00       	jmp    80104b10 <release>
    acquire(&kmem.lock);
80102750:	83 ec 0c             	sub    $0xc,%esp
80102753:	68 40 36 11 80       	push   $0x80113640
80102758:	e8 93 22 00 00       	call   801049f0 <acquire>
8010275d:	83 c4 10             	add    $0x10,%esp
80102760:	eb c2                	jmp    80102724 <kfree+0x44>
    panic("kfree");
80102762:	83 ec 0c             	sub    $0xc,%esp
80102765:	68 0a 7d 10 80       	push   $0x80107d0a
8010276a:	e8 21 dc ff ff       	call   80100390 <panic>
8010276f:	90                   	nop

80102770 <freerange>:
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	56                   	push   %esi
80102774:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102775:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102778:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010277b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102781:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102787:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010278d:	39 de                	cmp    %ebx,%esi
8010278f:	72 23                	jb     801027b4 <freerange+0x44>
80102791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102798:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010279e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027a7:	50                   	push   %eax
801027a8:	e8 33 ff ff ff       	call   801026e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	39 f3                	cmp    %esi,%ebx
801027b2:	76 e4                	jbe    80102798 <freerange+0x28>
}
801027b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027b7:	5b                   	pop    %ebx
801027b8:	5e                   	pop    %esi
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret    
801027bb:	90                   	nop
801027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027c0 <kinit1>:
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	56                   	push   %esi
801027c4:	53                   	push   %ebx
801027c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801027c8:	83 ec 08             	sub    $0x8,%esp
801027cb:	68 10 7d 10 80       	push   $0x80107d10
801027d0:	68 40 36 11 80       	push   $0x80113640
801027d5:	e8 26 21 00 00       	call   80104900 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801027da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801027e0:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801027e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801027ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027fc:	39 de                	cmp    %ebx,%esi
801027fe:	72 1c                	jb     8010281c <kinit1+0x5c>
    kfree(p);
80102800:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102806:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102809:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010280f:	50                   	push   %eax
80102810:	e8 cb fe ff ff       	call   801026e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102815:	83 c4 10             	add    $0x10,%esp
80102818:	39 de                	cmp    %ebx,%esi
8010281a:	73 e4                	jae    80102800 <kinit1+0x40>
}
8010281c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010281f:	5b                   	pop    %ebx
80102820:	5e                   	pop    %esi
80102821:	5d                   	pop    %ebp
80102822:	c3                   	ret    
80102823:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102830 <kinit2>:
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	56                   	push   %esi
80102834:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102835:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102838:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010283b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102841:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102847:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010284d:	39 de                	cmp    %ebx,%esi
8010284f:	72 23                	jb     80102874 <kinit2+0x44>
80102851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102858:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010285e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102861:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102867:	50                   	push   %eax
80102868:	e8 73 fe ff ff       	call   801026e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010286d:	83 c4 10             	add    $0x10,%esp
80102870:	39 de                	cmp    %ebx,%esi
80102872:	73 e4                	jae    80102858 <kinit2+0x28>
  kmem.use_lock = 1;
80102874:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010287b:	00 00 00 
}
8010287e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102881:	5b                   	pop    %ebx
80102882:	5e                   	pop    %esi
80102883:	5d                   	pop    %ebp
80102884:	c3                   	ret    
80102885:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102890 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102890:	a1 74 36 11 80       	mov    0x80113674,%eax
80102895:	85 c0                	test   %eax,%eax
80102897:	75 1f                	jne    801028b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102899:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010289e:	85 c0                	test   %eax,%eax
801028a0:	74 0e                	je     801028b0 <kalloc+0x20>
    kmem.freelist = r->next;
801028a2:	8b 10                	mov    (%eax),%edx
801028a4:	89 15 78 36 11 80    	mov    %edx,0x80113678
801028aa:	c3                   	ret    
801028ab:	90                   	nop
801028ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801028b0:	f3 c3                	repz ret 
801028b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801028b8:	55                   	push   %ebp
801028b9:	89 e5                	mov    %esp,%ebp
801028bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801028be:	68 40 36 11 80       	push   $0x80113640
801028c3:	e8 28 21 00 00       	call   801049f0 <acquire>
  r = kmem.freelist;
801028c8:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801028cd:	83 c4 10             	add    $0x10,%esp
801028d0:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801028d6:	85 c0                	test   %eax,%eax
801028d8:	74 08                	je     801028e2 <kalloc+0x52>
    kmem.freelist = r->next;
801028da:	8b 08                	mov    (%eax),%ecx
801028dc:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
801028e2:	85 d2                	test   %edx,%edx
801028e4:	74 16                	je     801028fc <kalloc+0x6c>
    release(&kmem.lock);
801028e6:	83 ec 0c             	sub    $0xc,%esp
801028e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028ec:	68 40 36 11 80       	push   $0x80113640
801028f1:	e8 1a 22 00 00       	call   80104b10 <release>
  return (char*)r;
801028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801028f9:	83 c4 10             	add    $0x10,%esp
}
801028fc:	c9                   	leave  
801028fd:	c3                   	ret    
801028fe:	66 90                	xchg   %ax,%ax

80102900 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102900:	ba 64 00 00 00       	mov    $0x64,%edx
80102905:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102906:	a8 01                	test   $0x1,%al
80102908:	0f 84 c2 00 00 00    	je     801029d0 <kbdgetc+0xd0>
8010290e:	ba 60 00 00 00       	mov    $0x60,%edx
80102913:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102914:	0f b6 d0             	movzbl %al,%edx
80102917:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010291d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102923:	0f 84 7f 00 00 00    	je     801029a8 <kbdgetc+0xa8>
{
80102929:	55                   	push   %ebp
8010292a:	89 e5                	mov    %esp,%ebp
8010292c:	53                   	push   %ebx
8010292d:	89 cb                	mov    %ecx,%ebx
8010292f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102932:	84 c0                	test   %al,%al
80102934:	78 4a                	js     80102980 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102936:	85 db                	test   %ebx,%ebx
80102938:	74 09                	je     80102943 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010293a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010293d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102940:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102943:	0f b6 82 40 7e 10 80 	movzbl -0x7fef81c0(%edx),%eax
8010294a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010294c:	0f b6 82 40 7d 10 80 	movzbl -0x7fef82c0(%edx),%eax
80102953:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102955:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102957:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010295d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102960:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102963:	8b 04 85 20 7d 10 80 	mov    -0x7fef82e0(,%eax,4),%eax
8010296a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010296e:	74 31                	je     801029a1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102970:	8d 50 9f             	lea    -0x61(%eax),%edx
80102973:	83 fa 19             	cmp    $0x19,%edx
80102976:	77 40                	ja     801029b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102978:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010297b:	5b                   	pop    %ebx
8010297c:	5d                   	pop    %ebp
8010297d:	c3                   	ret    
8010297e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102980:	83 e0 7f             	and    $0x7f,%eax
80102983:	85 db                	test   %ebx,%ebx
80102985:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102988:	0f b6 82 40 7e 10 80 	movzbl -0x7fef81c0(%edx),%eax
8010298f:	83 c8 40             	or     $0x40,%eax
80102992:	0f b6 c0             	movzbl %al,%eax
80102995:	f7 d0                	not    %eax
80102997:	21 c1                	and    %eax,%ecx
    return 0;
80102999:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010299b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801029a1:	5b                   	pop    %ebx
801029a2:	5d                   	pop    %ebp
801029a3:	c3                   	ret    
801029a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801029a8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801029ab:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801029ad:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
801029b3:	c3                   	ret    
801029b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801029b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801029be:	5b                   	pop    %ebx
      c += 'a' - 'A';
801029bf:	83 f9 1a             	cmp    $0x1a,%ecx
801029c2:	0f 42 c2             	cmovb  %edx,%eax
}
801029c5:	5d                   	pop    %ebp
801029c6:	c3                   	ret    
801029c7:	89 f6                	mov    %esi,%esi
801029c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801029d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029d5:	c3                   	ret    
801029d6:	8d 76 00             	lea    0x0(%esi),%esi
801029d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029e0 <kbdintr>:

void
kbdintr(void)
{
801029e0:	55                   	push   %ebp
801029e1:	89 e5                	mov    %esp,%ebp
801029e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029e6:	68 00 29 10 80       	push   $0x80102900
801029eb:	e8 20 de ff ff       	call   80100810 <consoleintr>
}
801029f0:	83 c4 10             	add    $0x10,%esp
801029f3:	c9                   	leave  
801029f4:	c3                   	ret    
801029f5:	66 90                	xchg   %ax,%ax
801029f7:	66 90                	xchg   %ax,%ax
801029f9:	66 90                	xchg   %ax,%ax
801029fb:	66 90                	xchg   %ax,%ax
801029fd:	66 90                	xchg   %ax,%ax
801029ff:	90                   	nop

80102a00 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a00:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102a05:	55                   	push   %ebp
80102a06:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a08:	85 c0                	test   %eax,%eax
80102a0a:	0f 84 c8 00 00 00    	je     80102ad8 <lapicinit+0xd8>
  lapic[index] = value;
80102a10:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a17:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a1d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a2a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a31:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a34:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a37:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a3e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a41:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a44:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a4b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a51:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a58:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a5e:	8b 50 30             	mov    0x30(%eax),%edx
80102a61:	c1 ea 10             	shr    $0x10,%edx
80102a64:	80 fa 03             	cmp    $0x3,%dl
80102a67:	77 77                	ja     80102ae0 <lapicinit+0xe0>
  lapic[index] = value;
80102a69:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a70:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a73:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a76:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a7d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a80:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a83:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a8a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a90:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a97:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a9d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102aa4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aaa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ab1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab4:	8b 50 20             	mov    0x20(%eax),%edx
80102ab7:	89 f6                	mov    %esi,%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ac0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ac6:	80 e6 10             	and    $0x10,%dh
80102ac9:	75 f5                	jne    80102ac0 <lapicinit+0xc0>
  lapic[index] = value;
80102acb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102ad2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102ad8:	5d                   	pop    %ebp
80102ad9:	c3                   	ret    
80102ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102ae0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ae7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aea:	8b 50 20             	mov    0x20(%eax),%edx
80102aed:	e9 77 ff ff ff       	jmp    80102a69 <lapicinit+0x69>
80102af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b00:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
80102b06:	55                   	push   %ebp
80102b07:	31 c0                	xor    %eax,%eax
80102b09:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b0b:	85 d2                	test   %edx,%edx
80102b0d:	74 06                	je     80102b15 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102b0f:	8b 42 20             	mov    0x20(%edx),%eax
80102b12:	c1 e8 18             	shr    $0x18,%eax
}
80102b15:	5d                   	pop    %ebp
80102b16:	c3                   	ret    
80102b17:	89 f6                	mov    %esi,%esi
80102b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b20:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102b25:	55                   	push   %ebp
80102b26:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b28:	85 c0                	test   %eax,%eax
80102b2a:	74 0d                	je     80102b39 <lapiceoi+0x19>
  lapic[index] = value;
80102b2c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b33:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b36:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b39:	5d                   	pop    %ebp
80102b3a:	c3                   	ret    
80102b3b:	90                   	nop
80102b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b40 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
}
80102b43:	5d                   	pop    %ebp
80102b44:	c3                   	ret    
80102b45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b56:	ba 70 00 00 00       	mov    $0x70,%edx
80102b5b:	89 e5                	mov    %esp,%ebp
80102b5d:	53                   	push   %ebx
80102b5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b64:	ee                   	out    %al,(%dx)
80102b65:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b70:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b7d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102b80:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102b83:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b8e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102b93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ba3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ba9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102bb0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bb6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bbc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bbf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bc5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bc8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102bd1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bd7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102bda:	5b                   	pop    %ebx
80102bdb:	5d                   	pop    %ebp
80102bdc:	c3                   	ret    
80102bdd:	8d 76 00             	lea    0x0(%esi),%esi

80102be0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102be0:	55                   	push   %ebp
80102be1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102be6:	ba 70 00 00 00       	mov    $0x70,%edx
80102beb:	89 e5                	mov    %esp,%ebp
80102bed:	57                   	push   %edi
80102bee:	56                   	push   %esi
80102bef:	53                   	push   %ebx
80102bf0:	83 ec 4c             	sub    $0x4c,%esp
80102bf3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bf9:	ec                   	in     (%dx),%al
80102bfa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bfd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c05:	8d 76 00             	lea    0x0(%esi),%esi
80102c08:	31 c0                	xor    %eax,%eax
80102c0a:	89 da                	mov    %ebx,%edx
80102c0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c12:	89 ca                	mov    %ecx,%edx
80102c14:	ec                   	in     (%dx),%al
80102c15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c18:	89 da                	mov    %ebx,%edx
80102c1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c20:	89 ca                	mov    %ecx,%edx
80102c22:	ec                   	in     (%dx),%al
80102c23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c26:	89 da                	mov    %ebx,%edx
80102c28:	b8 04 00 00 00       	mov    $0x4,%eax
80102c2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2e:	89 ca                	mov    %ecx,%edx
80102c30:	ec                   	in     (%dx),%al
80102c31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c34:	89 da                	mov    %ebx,%edx
80102c36:	b8 07 00 00 00       	mov    $0x7,%eax
80102c3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3c:	89 ca                	mov    %ecx,%edx
80102c3e:	ec                   	in     (%dx),%al
80102c3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c42:	89 da                	mov    %ebx,%edx
80102c44:	b8 08 00 00 00       	mov    $0x8,%eax
80102c49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4a:	89 ca                	mov    %ecx,%edx
80102c4c:	ec                   	in     (%dx),%al
80102c4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4f:	89 da                	mov    %ebx,%edx
80102c51:	b8 09 00 00 00       	mov    $0x9,%eax
80102c56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c57:	89 ca                	mov    %ecx,%edx
80102c59:	ec                   	in     (%dx),%al
80102c5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c5c:	89 da                	mov    %ebx,%edx
80102c5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c64:	89 ca                	mov    %ecx,%edx
80102c66:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c67:	84 c0                	test   %al,%al
80102c69:	78 9d                	js     80102c08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c6f:	89 fa                	mov    %edi,%edx
80102c71:	0f b6 fa             	movzbl %dl,%edi
80102c74:	89 f2                	mov    %esi,%edx
80102c76:	0f b6 f2             	movzbl %dl,%esi
80102c79:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7c:	89 da                	mov    %ebx,%edx
80102c7e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c81:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c84:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c88:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c8b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c99:	31 c0                	xor    %eax,%eax
80102c9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9c:	89 ca                	mov    %ecx,%edx
80102c9e:	ec                   	in     (%dx),%al
80102c9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca2:	89 da                	mov    %ebx,%edx
80102ca4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ca7:	b8 02 00 00 00       	mov    $0x2,%eax
80102cac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cad:	89 ca                	mov    %ecx,%edx
80102caf:	ec                   	in     (%dx),%al
80102cb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb3:	89 da                	mov    %ebx,%edx
80102cb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102cb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbe:	89 ca                	mov    %ecx,%edx
80102cc0:	ec                   	in     (%dx),%al
80102cc1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc4:	89 da                	mov    %ebx,%edx
80102cc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102cc9:	b8 07 00 00 00       	mov    $0x7,%eax
80102cce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccf:	89 ca                	mov    %ecx,%edx
80102cd1:	ec                   	in     (%dx),%al
80102cd2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd5:	89 da                	mov    %ebx,%edx
80102cd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102cda:	b8 08 00 00 00       	mov    $0x8,%eax
80102cdf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce0:	89 ca                	mov    %ecx,%edx
80102ce2:	ec                   	in     (%dx),%al
80102ce3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce6:	89 da                	mov    %ebx,%edx
80102ce8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ceb:	b8 09 00 00 00       	mov    $0x9,%eax
80102cf0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf1:	89 ca                	mov    %ecx,%edx
80102cf3:	ec                   	in     (%dx),%al
80102cf4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cf7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cfd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d00:	6a 18                	push   $0x18
80102d02:	50                   	push   %eax
80102d03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d06:	50                   	push   %eax
80102d07:	e8 b4 1e 00 00       	call   80104bc0 <memcmp>
80102d0c:	83 c4 10             	add    $0x10,%esp
80102d0f:	85 c0                	test   %eax,%eax
80102d11:	0f 85 f1 fe ff ff    	jne    80102c08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d1b:	75 78                	jne    80102d95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d20:	89 c2                	mov    %eax,%edx
80102d22:	83 e0 0f             	and    $0xf,%eax
80102d25:	c1 ea 04             	shr    $0x4,%edx
80102d28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d34:	89 c2                	mov    %eax,%edx
80102d36:	83 e0 0f             	and    $0xf,%eax
80102d39:	c1 ea 04             	shr    $0x4,%edx
80102d3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d48:	89 c2                	mov    %eax,%edx
80102d4a:	83 e0 0f             	and    $0xf,%eax
80102d4d:	c1 ea 04             	shr    $0x4,%edx
80102d50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d5c:	89 c2                	mov    %eax,%edx
80102d5e:	83 e0 0f             	and    $0xf,%eax
80102d61:	c1 ea 04             	shr    $0x4,%edx
80102d64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d70:	89 c2                	mov    %eax,%edx
80102d72:	83 e0 0f             	and    $0xf,%eax
80102d75:	c1 ea 04             	shr    $0x4,%edx
80102d78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d84:	89 c2                	mov    %eax,%edx
80102d86:	83 e0 0f             	and    $0xf,%eax
80102d89:	c1 ea 04             	shr    $0x4,%edx
80102d8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d95:	8b 75 08             	mov    0x8(%ebp),%esi
80102d98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d9b:	89 06                	mov    %eax,(%esi)
80102d9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102da0:	89 46 04             	mov    %eax,0x4(%esi)
80102da3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102da6:	89 46 08             	mov    %eax,0x8(%esi)
80102da9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dac:	89 46 0c             	mov    %eax,0xc(%esi)
80102daf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102db2:	89 46 10             	mov    %eax,0x10(%esi)
80102db5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102db8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102dbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dc5:	5b                   	pop    %ebx
80102dc6:	5e                   	pop    %esi
80102dc7:	5f                   	pop    %edi
80102dc8:	5d                   	pop    %ebp
80102dc9:	c3                   	ret    
80102dca:	66 90                	xchg   %ax,%ax
80102dcc:	66 90                	xchg   %ax,%ax
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dd0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102dd6:	85 c9                	test   %ecx,%ecx
80102dd8:	0f 8e 8a 00 00 00    	jle    80102e68 <install_trans+0x98>
{
80102dde:	55                   	push   %ebp
80102ddf:	89 e5                	mov    %esp,%ebp
80102de1:	57                   	push   %edi
80102de2:	56                   	push   %esi
80102de3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102de4:	31 db                	xor    %ebx,%ebx
{
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102df0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102df5:	83 ec 08             	sub    $0x8,%esp
80102df8:	01 d8                	add    %ebx,%eax
80102dfa:	83 c0 01             	add    $0x1,%eax
80102dfd:	50                   	push   %eax
80102dfe:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e04:	e8 c7 d2 ff ff       	call   801000d0 <bread>
80102e09:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e0b:	58                   	pop    %eax
80102e0c:	5a                   	pop    %edx
80102e0d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e14:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e1a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e1d:	e8 ae d2 ff ff       	call   801000d0 <bread>
80102e22:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e24:	8d 47 5c             	lea    0x5c(%edi),%eax
80102e27:	83 c4 0c             	add    $0xc,%esp
80102e2a:	68 00 02 00 00       	push   $0x200
80102e2f:	50                   	push   %eax
80102e30:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e33:	50                   	push   %eax
80102e34:	e8 e7 1d 00 00       	call   80104c20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e39:	89 34 24             	mov    %esi,(%esp)
80102e3c:	e8 5f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e41:	89 3c 24             	mov    %edi,(%esp)
80102e44:	e8 97 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e49:	89 34 24             	mov    %esi,(%esp)
80102e4c:	e8 8f d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e51:	83 c4 10             	add    $0x10,%esp
80102e54:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102e5a:	7f 94                	jg     80102df0 <install_trans+0x20>
  }
}
80102e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e5f:	5b                   	pop    %ebx
80102e60:	5e                   	pop    %esi
80102e61:	5f                   	pop    %edi
80102e62:	5d                   	pop    %ebp
80102e63:	c3                   	ret    
80102e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e68:	f3 c3                	repz ret 
80102e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	56                   	push   %esi
80102e74:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102e7e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e89:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102e8f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e92:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102e94:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102e96:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e99:	7e 16                	jle    80102eb1 <write_head+0x41>
80102e9b:	c1 e3 02             	shl    $0x2,%ebx
80102e9e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ea0:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102ea6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102eaa:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102ead:	39 da                	cmp    %ebx,%edx
80102eaf:	75 ef                	jne    80102ea0 <write_head+0x30>
  }
  bwrite(buf);
80102eb1:	83 ec 0c             	sub    $0xc,%esp
80102eb4:	56                   	push   %esi
80102eb5:	e8 e6 d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102eba:	89 34 24             	mov    %esi,(%esp)
80102ebd:	e8 1e d3 ff ff       	call   801001e0 <brelse>
}
80102ec2:	83 c4 10             	add    $0x10,%esp
80102ec5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ec8:	5b                   	pop    %ebx
80102ec9:	5e                   	pop    %esi
80102eca:	5d                   	pop    %ebp
80102ecb:	c3                   	ret    
80102ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ed0 <initlog>:
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 2c             	sub    $0x2c,%esp
80102ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eda:	68 40 7f 10 80       	push   $0x80107f40
80102edf:	68 80 36 11 80       	push   $0x80113680
80102ee4:	e8 17 1a 00 00       	call   80104900 <initlock>
  readsb(dev, &sb);
80102ee9:	58                   	pop    %eax
80102eea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102eed:	5a                   	pop    %edx
80102eee:	50                   	push   %eax
80102eef:	53                   	push   %ebx
80102ef0:	e8 0b e5 ff ff       	call   80101400 <readsb>
  log.size = sb.nlog;
80102ef5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102efb:	59                   	pop    %ecx
  log.dev = dev;
80102efc:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102f02:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102f08:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
80102f0d:	5a                   	pop    %edx
80102f0e:	50                   	push   %eax
80102f0f:	53                   	push   %ebx
80102f10:	e8 bb d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102f15:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f18:	83 c4 10             	add    $0x10,%esp
80102f1b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102f1d:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102f23:	7e 1c                	jle    80102f41 <initlog+0x71>
80102f25:	c1 e3 02             	shl    $0x2,%ebx
80102f28:	31 d2                	xor    %edx,%edx
80102f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102f30:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f34:	83 c2 04             	add    $0x4,%edx
80102f37:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102f3d:	39 d3                	cmp    %edx,%ebx
80102f3f:	75 ef                	jne    80102f30 <initlog+0x60>
  brelse(buf);
80102f41:	83 ec 0c             	sub    $0xc,%esp
80102f44:	50                   	push   %eax
80102f45:	e8 96 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f4a:	e8 81 fe ff ff       	call   80102dd0 <install_trans>
  log.lh.n = 0;
80102f4f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102f56:	00 00 00 
  write_head(); // clear the log
80102f59:	e8 12 ff ff ff       	call   80102e70 <write_head>
}
80102f5e:	83 c4 10             	add    $0x10,%esp
80102f61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f64:	c9                   	leave  
80102f65:	c3                   	ret    
80102f66:	8d 76 00             	lea    0x0(%esi),%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f76:	68 80 36 11 80       	push   $0x80113680
80102f7b:	e8 70 1a 00 00       	call   801049f0 <acquire>
80102f80:	83 c4 10             	add    $0x10,%esp
80102f83:	eb 18                	jmp    80102f9d <begin_op+0x2d>
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f88:	83 ec 08             	sub    $0x8,%esp
80102f8b:	68 80 36 11 80       	push   $0x80113680
80102f90:	68 80 36 11 80       	push   $0x80113680
80102f95:	e8 36 14 00 00       	call   801043d0 <sleep>
80102f9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f9d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102fa2:	85 c0                	test   %eax,%eax
80102fa4:	75 e2                	jne    80102f88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fa6:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102fab:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102fb1:	83 c0 01             	add    $0x1,%eax
80102fb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fba:	83 fa 1e             	cmp    $0x1e,%edx
80102fbd:	7f c9                	jg     80102f88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fbf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102fc2:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102fc7:	68 80 36 11 80       	push   $0x80113680
80102fcc:	e8 3f 1b 00 00       	call   80104b10 <release>
      break;
    }
  }
}
80102fd1:	83 c4 10             	add    $0x10,%esp
80102fd4:	c9                   	leave  
80102fd5:	c3                   	ret    
80102fd6:	8d 76 00             	lea    0x0(%esi),%esi
80102fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fe0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
80102fe5:	53                   	push   %ebx
80102fe6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fe9:	68 80 36 11 80       	push   $0x80113680
80102fee:	e8 fd 19 00 00       	call   801049f0 <acquire>
  log.outstanding -= 1;
80102ff3:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102ff8:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102ffe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103001:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103004:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103006:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
8010300c:	0f 85 1a 01 00 00    	jne    8010312c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103012:	85 db                	test   %ebx,%ebx
80103014:	0f 85 ee 00 00 00    	jne    80103108 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010301a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010301d:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80103024:	00 00 00 
  release(&log.lock);
80103027:	68 80 36 11 80       	push   $0x80113680
8010302c:	e8 df 1a 00 00       	call   80104b10 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103031:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103037:	83 c4 10             	add    $0x10,%esp
8010303a:	85 c9                	test   %ecx,%ecx
8010303c:	0f 8e 85 00 00 00    	jle    801030c7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103042:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80103047:	83 ec 08             	sub    $0x8,%esp
8010304a:	01 d8                	add    %ebx,%eax
8010304c:	83 c0 01             	add    $0x1,%eax
8010304f:	50                   	push   %eax
80103050:	ff 35 c4 36 11 80    	pushl  0x801136c4
80103056:	e8 75 d0 ff ff       	call   801000d0 <bread>
8010305b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010305d:	58                   	pop    %eax
8010305e:	5a                   	pop    %edx
8010305f:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80103066:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
8010306c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010306f:	e8 5c d0 ff ff       	call   801000d0 <bread>
80103074:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103076:	8d 40 5c             	lea    0x5c(%eax),%eax
80103079:	83 c4 0c             	add    $0xc,%esp
8010307c:	68 00 02 00 00       	push   $0x200
80103081:	50                   	push   %eax
80103082:	8d 46 5c             	lea    0x5c(%esi),%eax
80103085:	50                   	push   %eax
80103086:	e8 95 1b 00 00       	call   80104c20 <memmove>
    bwrite(to);  // write the log
8010308b:	89 34 24             	mov    %esi,(%esp)
8010308e:	e8 0d d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103093:	89 3c 24             	mov    %edi,(%esp)
80103096:	e8 45 d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010309b:	89 34 24             	mov    %esi,(%esp)
8010309e:	e8 3d d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030a3:	83 c4 10             	add    $0x10,%esp
801030a6:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
801030ac:	7c 94                	jl     80103042 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030ae:	e8 bd fd ff ff       	call   80102e70 <write_head>
    install_trans(); // Now install writes to home locations
801030b3:	e8 18 fd ff ff       	call   80102dd0 <install_trans>
    log.lh.n = 0;
801030b8:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
801030bf:	00 00 00 
    write_head();    // Erase the transaction from the log
801030c2:	e8 a9 fd ff ff       	call   80102e70 <write_head>
    acquire(&log.lock);
801030c7:	83 ec 0c             	sub    $0xc,%esp
801030ca:	68 80 36 11 80       	push   $0x80113680
801030cf:	e8 1c 19 00 00       	call   801049f0 <acquire>
    wakeup(&log);
801030d4:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
801030db:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
801030e2:	00 00 00 
    wakeup(&log);
801030e5:	e8 56 15 00 00       	call   80104640 <wakeup>
    release(&log.lock);
801030ea:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030f1:	e8 1a 1a 00 00       	call   80104b10 <release>
801030f6:	83 c4 10             	add    $0x10,%esp
}
801030f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030fc:	5b                   	pop    %ebx
801030fd:	5e                   	pop    %esi
801030fe:	5f                   	pop    %edi
801030ff:	5d                   	pop    %ebp
80103100:	c3                   	ret    
80103101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103108:	83 ec 0c             	sub    $0xc,%esp
8010310b:	68 80 36 11 80       	push   $0x80113680
80103110:	e8 2b 15 00 00       	call   80104640 <wakeup>
  release(&log.lock);
80103115:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
8010311c:	e8 ef 19 00 00       	call   80104b10 <release>
80103121:	83 c4 10             	add    $0x10,%esp
}
80103124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103127:	5b                   	pop    %ebx
80103128:	5e                   	pop    %esi
80103129:	5f                   	pop    %edi
8010312a:	5d                   	pop    %ebp
8010312b:	c3                   	ret    
    panic("log.committing");
8010312c:	83 ec 0c             	sub    $0xc,%esp
8010312f:	68 44 7f 10 80       	push   $0x80107f44
80103134:	e8 57 d2 ff ff       	call   80100390 <panic>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103140 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103140:	55                   	push   %ebp
80103141:	89 e5                	mov    %esp,%ebp
80103143:	53                   	push   %ebx
80103144:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103147:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
8010314d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103150:	83 fa 1d             	cmp    $0x1d,%edx
80103153:	0f 8f 9d 00 00 00    	jg     801031f6 <log_write+0xb6>
80103159:	a1 b8 36 11 80       	mov    0x801136b8,%eax
8010315e:	83 e8 01             	sub    $0x1,%eax
80103161:	39 c2                	cmp    %eax,%edx
80103163:	0f 8d 8d 00 00 00    	jge    801031f6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103169:	a1 bc 36 11 80       	mov    0x801136bc,%eax
8010316e:	85 c0                	test   %eax,%eax
80103170:	0f 8e 8d 00 00 00    	jle    80103203 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103176:	83 ec 0c             	sub    $0xc,%esp
80103179:	68 80 36 11 80       	push   $0x80113680
8010317e:	e8 6d 18 00 00       	call   801049f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103183:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103189:	83 c4 10             	add    $0x10,%esp
8010318c:	83 f9 00             	cmp    $0x0,%ecx
8010318f:	7e 57                	jle    801031e8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103191:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103194:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103196:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
8010319c:	75 0b                	jne    801031a9 <log_write+0x69>
8010319e:	eb 38                	jmp    801031d8 <log_write+0x98>
801031a0:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
801031a7:	74 2f                	je     801031d8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801031a9:	83 c0 01             	add    $0x1,%eax
801031ac:	39 c1                	cmp    %eax,%ecx
801031ae:	75 f0                	jne    801031a0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801031b0:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801031b7:	83 c0 01             	add    $0x1,%eax
801031ba:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
801031bf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801031c2:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
801031c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031cc:	c9                   	leave  
  release(&log.lock);
801031cd:	e9 3e 19 00 00       	jmp    80104b10 <release>
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031d8:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
801031df:	eb de                	jmp    801031bf <log_write+0x7f>
801031e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031e8:	8b 43 08             	mov    0x8(%ebx),%eax
801031eb:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
801031f0:	75 cd                	jne    801031bf <log_write+0x7f>
801031f2:	31 c0                	xor    %eax,%eax
801031f4:	eb c1                	jmp    801031b7 <log_write+0x77>
    panic("too big a transaction");
801031f6:	83 ec 0c             	sub    $0xc,%esp
801031f9:	68 53 7f 10 80       	push   $0x80107f53
801031fe:	e8 8d d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103203:	83 ec 0c             	sub    $0xc,%esp
80103206:	68 69 7f 10 80       	push   $0x80107f69
8010320b:	e8 80 d1 ff ff       	call   80100390 <panic>

80103210 <mpmain>:
  mpmain();
}

// Common CPU setup code.
static void
mpmain(void) {
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	53                   	push   %ebx
80103214:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103217:	e8 24 0a 00 00       	call   80103c40 <cpuid>
8010321c:	89 c3                	mov    %eax,%ebx
8010321e:	e8 1d 0a 00 00       	call   80103c40 <cpuid>
80103223:	83 ec 04             	sub    $0x4,%esp
80103226:	53                   	push   %ebx
80103227:	50                   	push   %eax
80103228:	68 84 7f 10 80       	push   $0x80107f84
8010322d:	e8 2e d4 ff ff       	call   80100660 <cprintf>
    idtinit();       // load idt register
80103232:	e8 09 2c 00 00       	call   80105e40 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103237:	e8 84 09 00 00       	call   80103bc0 <mycpu>
8010323c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010323e:	b8 01 00 00 00       	mov    $0x1,%eax
80103243:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
8010324a:	e8 81 0e 00 00       	call   801040d0 <scheduler>
8010324f:	90                   	nop

80103250 <mpenter>:
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103256:	e8 35 3c 00 00       	call   80106e90 <switchkvm>
  seginit();
8010325b:	e8 a0 3b 00 00       	call   80106e00 <seginit>
  lapicinit();
80103260:	e8 9b f7 ff ff       	call   80102a00 <lapicinit>
  mpmain();
80103265:	e8 a6 ff ff ff       	call   80103210 <mpmain>
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <main>:
{
80103270:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103274:	83 e4 f0             	and    $0xfffffff0,%esp
80103277:	ff 71 fc             	pushl  -0x4(%ecx)
8010327a:	55                   	push   %ebp
8010327b:	89 e5                	mov    %esp,%ebp
8010327d:	53                   	push   %ebx
8010327e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010327f:	83 ec 08             	sub    $0x8,%esp
80103282:	68 00 00 40 80       	push   $0x80400000
80103287:	68 a8 69 12 80       	push   $0x801269a8
8010328c:	e8 2f f5 ff ff       	call   801027c0 <kinit1>
  kvmalloc();      // kernel page table
80103291:	e8 ea 44 00 00       	call   80107780 <kvmalloc>
  mpinit();        // detect other processors
80103296:	e8 75 01 00 00       	call   80103410 <mpinit>
  lapicinit();     // interrupt controller
8010329b:	e8 60 f7 ff ff       	call   80102a00 <lapicinit>
  seginit();       // segment descriptors
801032a0:	e8 5b 3b 00 00       	call   80106e00 <seginit>
  picinit();       // disable pic
801032a5:	e8 46 03 00 00       	call   801035f0 <picinit>
  ioapicinit();    // another interrupt controller
801032aa:	e8 41 f3 ff ff       	call   801025f0 <ioapicinit>
  consoleinit();   // console hardware
801032af:	e8 0c d7 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801032b4:	e8 b7 2e 00 00       	call   80106170 <uartinit>
  pinit();         // process table
801032b9:	e8 e2 08 00 00       	call   80103ba0 <pinit>
  tvinit();        // trap vectors
801032be:	e8 fd 2a 00 00       	call   80105dc0 <tvinit>
  binit();         // buffer cache
801032c3:	e8 78 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032c8:	e8 c3 da ff ff       	call   80100d90 <fileinit>
  ideinit();       // disk 
801032cd:	e8 fe f0 ff ff       	call   801023d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032d2:	83 c4 0c             	add    $0xc,%esp
801032d5:	68 8a 00 00 00       	push   $0x8a
801032da:	68 8c b4 10 80       	push   $0x8010b48c
801032df:	68 00 70 00 80       	push   $0x80007000
801032e4:	e8 37 19 00 00       	call   80104c20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032e9:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801032f0:	00 00 00 
801032f3:	83 c4 10             	add    $0x10,%esp
801032f6:	05 80 37 11 80       	add    $0x80113780,%eax
801032fb:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80103300:	76 71                	jbe    80103373 <main+0x103>
80103302:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80103307:	89 f6                	mov    %esi,%esi
80103309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103310:	e8 ab 08 00 00       	call   80103bc0 <mycpu>
80103315:	39 d8                	cmp    %ebx,%eax
80103317:	74 41                	je     8010335a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103319:	e8 72 f5 ff ff       	call   80102890 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010331e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103323:	c7 05 f8 6f 00 80 50 	movl   $0x80103250,0x80006ff8
8010332a:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010332d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103334:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103337:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010333c:	0f b6 03             	movzbl (%ebx),%eax
8010333f:	83 ec 08             	sub    $0x8,%esp
80103342:	68 00 70 00 00       	push   $0x7000
80103347:	50                   	push   %eax
80103348:	e8 03 f8 ff ff       	call   80102b50 <lapicstartap>
8010334d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103350:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103356:	85 c0                	test   %eax,%eax
80103358:	74 f6                	je     80103350 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010335a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103361:	00 00 00 
80103364:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010336a:	05 80 37 11 80       	add    $0x80113780,%eax
8010336f:	39 c3                	cmp    %eax,%ebx
80103371:	72 9d                	jb     80103310 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103373:	83 ec 08             	sub    $0x8,%esp
80103376:	68 00 00 00 8e       	push   $0x8e000000
8010337b:	68 00 00 40 80       	push   $0x80400000
80103380:	e8 ab f4 ff ff       	call   80102830 <kinit2>
  userinit();      // first user process
80103385:	e8 06 09 00 00       	call   80103c90 <userinit>
  mpmain();        // finish this processor's setup
8010338a:	e8 81 fe ff ff       	call   80103210 <mpmain>
8010338f:	90                   	nop

80103390 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103395:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010339b:	53                   	push   %ebx
  e = addr+len;
8010339c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010339f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033a2:	39 de                	cmp    %ebx,%esi
801033a4:	72 10                	jb     801033b6 <mpsearch1+0x26>
801033a6:	eb 50                	jmp    801033f8 <mpsearch1+0x68>
801033a8:	90                   	nop
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033b0:	39 fb                	cmp    %edi,%ebx
801033b2:	89 fe                	mov    %edi,%esi
801033b4:	76 42                	jbe    801033f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b6:	83 ec 04             	sub    $0x4,%esp
801033b9:	8d 7e 10             	lea    0x10(%esi),%edi
801033bc:	6a 04                	push   $0x4
801033be:	68 98 7f 10 80       	push   $0x80107f98
801033c3:	56                   	push   %esi
801033c4:	e8 f7 17 00 00       	call   80104bc0 <memcmp>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	85 c0                	test   %eax,%eax
801033ce:	75 e0                	jne    801033b0 <mpsearch1+0x20>
801033d0:	89 f1                	mov    %esi,%ecx
801033d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033d8:	0f b6 11             	movzbl (%ecx),%edx
801033db:	83 c1 01             	add    $0x1,%ecx
801033de:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801033e0:	39 f9                	cmp    %edi,%ecx
801033e2:	75 f4                	jne    801033d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033e4:	84 c0                	test   %al,%al
801033e6:	75 c8                	jne    801033b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033eb:	89 f0                	mov    %esi,%eax
801033ed:	5b                   	pop    %ebx
801033ee:	5e                   	pop    %esi
801033ef:	5f                   	pop    %edi
801033f0:	5d                   	pop    %ebp
801033f1:	c3                   	ret    
801033f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033fb:	31 f6                	xor    %esi,%esi
}
801033fd:	89 f0                	mov    %esi,%eax
801033ff:	5b                   	pop    %ebx
80103400:	5e                   	pop    %esi
80103401:	5f                   	pop    %edi
80103402:	5d                   	pop    %ebp
80103403:	c3                   	ret    
80103404:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010340a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103410 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103419:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103420:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103427:	c1 e0 08             	shl    $0x8,%eax
8010342a:	09 d0                	or     %edx,%eax
8010342c:	c1 e0 04             	shl    $0x4,%eax
8010342f:	85 c0                	test   %eax,%eax
80103431:	75 1b                	jne    8010344e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103433:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010343a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103441:	c1 e0 08             	shl    $0x8,%eax
80103444:	09 d0                	or     %edx,%eax
80103446:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103449:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010344e:	ba 00 04 00 00       	mov    $0x400,%edx
80103453:	e8 38 ff ff ff       	call   80103390 <mpsearch1>
80103458:	85 c0                	test   %eax,%eax
8010345a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010345d:	0f 84 3d 01 00 00    	je     801035a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103466:	8b 58 04             	mov    0x4(%eax),%ebx
80103469:	85 db                	test   %ebx,%ebx
8010346b:	0f 84 4f 01 00 00    	je     801035c0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103471:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103477:	83 ec 04             	sub    $0x4,%esp
8010347a:	6a 04                	push   $0x4
8010347c:	68 b5 7f 10 80       	push   $0x80107fb5
80103481:	56                   	push   %esi
80103482:	e8 39 17 00 00       	call   80104bc0 <memcmp>
80103487:	83 c4 10             	add    $0x10,%esp
8010348a:	85 c0                	test   %eax,%eax
8010348c:	0f 85 2e 01 00 00    	jne    801035c0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103492:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103499:	3c 01                	cmp    $0x1,%al
8010349b:	0f 95 c2             	setne  %dl
8010349e:	3c 04                	cmp    $0x4,%al
801034a0:	0f 95 c0             	setne  %al
801034a3:	20 c2                	and    %al,%dl
801034a5:	0f 85 15 01 00 00    	jne    801035c0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801034ab:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801034b2:	66 85 ff             	test   %di,%di
801034b5:	74 1a                	je     801034d1 <mpinit+0xc1>
801034b7:	89 f0                	mov    %esi,%eax
801034b9:	01 f7                	add    %esi,%edi
  sum = 0;
801034bb:	31 d2                	xor    %edx,%edx
801034bd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034c0:	0f b6 08             	movzbl (%eax),%ecx
801034c3:	83 c0 01             	add    $0x1,%eax
801034c6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034c8:	39 c7                	cmp    %eax,%edi
801034ca:	75 f4                	jne    801034c0 <mpinit+0xb0>
801034cc:	84 d2                	test   %dl,%dl
801034ce:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801034d1:	85 f6                	test   %esi,%esi
801034d3:	0f 84 e7 00 00 00    	je     801035c0 <mpinit+0x1b0>
801034d9:	84 d2                	test   %dl,%dl
801034db:	0f 85 df 00 00 00    	jne    801035c0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034e1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801034e7:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034ec:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801034f3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801034f9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034fe:	01 d6                	add    %edx,%esi
80103500:	39 c6                	cmp    %eax,%esi
80103502:	76 23                	jbe    80103527 <mpinit+0x117>
    switch(*p){
80103504:	0f b6 10             	movzbl (%eax),%edx
80103507:	80 fa 04             	cmp    $0x4,%dl
8010350a:	0f 87 ca 00 00 00    	ja     801035da <mpinit+0x1ca>
80103510:	ff 24 95 dc 7f 10 80 	jmp    *-0x7fef8024(,%edx,4)
80103517:	89 f6                	mov    %esi,%esi
80103519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103520:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103523:	39 c6                	cmp    %eax,%esi
80103525:	77 dd                	ja     80103504 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103527:	85 db                	test   %ebx,%ebx
80103529:	0f 84 9e 00 00 00    	je     801035cd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010352f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103532:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103536:	74 15                	je     8010354d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103538:	b8 70 00 00 00       	mov    $0x70,%eax
8010353d:	ba 22 00 00 00       	mov    $0x22,%edx
80103542:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103543:	ba 23 00 00 00       	mov    $0x23,%edx
80103548:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103549:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010354c:	ee                   	out    %al,(%dx)
  }
}
8010354d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103550:	5b                   	pop    %ebx
80103551:	5e                   	pop    %esi
80103552:	5f                   	pop    %edi
80103553:	5d                   	pop    %ebp
80103554:	c3                   	ret    
80103555:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103558:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
8010355e:	83 f9 07             	cmp    $0x7,%ecx
80103561:	7f 19                	jg     8010357c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103563:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103567:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010356d:	83 c1 01             	add    $0x1,%ecx
80103570:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103576:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
8010357c:	83 c0 14             	add    $0x14,%eax
      continue;
8010357f:	e9 7c ff ff ff       	jmp    80103500 <mpinit+0xf0>
80103584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103588:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010358c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010358f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
80103595:	e9 66 ff ff ff       	jmp    80103500 <mpinit+0xf0>
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801035a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801035a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801035aa:	e8 e1 fd ff ff       	call   80103390 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035af:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801035b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035b4:	0f 85 a9 fe ff ff    	jne    80103463 <mpinit+0x53>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	68 9d 7f 10 80       	push   $0x80107f9d
801035c8:	e8 c3 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801035cd:	83 ec 0c             	sub    $0xc,%esp
801035d0:	68 bc 7f 10 80       	push   $0x80107fbc
801035d5:	e8 b6 cd ff ff       	call   80100390 <panic>
      ismp = 0;
801035da:	31 db                	xor    %ebx,%ebx
801035dc:	e9 26 ff ff ff       	jmp    80103507 <mpinit+0xf7>
801035e1:	66 90                	xchg   %ax,%ax
801035e3:	66 90                	xchg   %ax,%ax
801035e5:	66 90                	xchg   %ax,%ax
801035e7:	66 90                	xchg   %ax,%ax
801035e9:	66 90                	xchg   %ax,%ax
801035eb:	66 90                	xchg   %ax,%ax
801035ed:	66 90                	xchg   %ax,%ax
801035ef:	90                   	nop

801035f0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035f0:	55                   	push   %ebp
801035f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035f6:	ba 21 00 00 00       	mov    $0x21,%edx
801035fb:	89 e5                	mov    %esp,%ebp
801035fd:	ee                   	out    %al,(%dx)
801035fe:	ba a1 00 00 00       	mov    $0xa1,%edx
80103603:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103604:	5d                   	pop    %ebp
80103605:	c3                   	ret    
80103606:	66 90                	xchg   %ax,%ax
80103608:	66 90                	xchg   %ax,%ax
8010360a:	66 90                	xchg   %ax,%ax
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 0c             	sub    $0xc,%esp
80103619:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010361c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010361f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103625:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010362b:	e8 80 d7 ff ff       	call   80100db0 <filealloc>
80103630:	85 c0                	test   %eax,%eax
80103632:	89 03                	mov    %eax,(%ebx)
80103634:	74 22                	je     80103658 <pipealloc+0x48>
80103636:	e8 75 d7 ff ff       	call   80100db0 <filealloc>
8010363b:	85 c0                	test   %eax,%eax
8010363d:	89 06                	mov    %eax,(%esi)
8010363f:	74 3f                	je     80103680 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103641:	e8 4a f2 ff ff       	call   80102890 <kalloc>
80103646:	85 c0                	test   %eax,%eax
80103648:	89 c7                	mov    %eax,%edi
8010364a:	75 54                	jne    801036a0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010364c:	8b 03                	mov    (%ebx),%eax
8010364e:	85 c0                	test   %eax,%eax
80103650:	75 34                	jne    80103686 <pipealloc+0x76>
80103652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103658:	8b 06                	mov    (%esi),%eax
8010365a:	85 c0                	test   %eax,%eax
8010365c:	74 0c                	je     8010366a <pipealloc+0x5a>
    fileclose(*f1);
8010365e:	83 ec 0c             	sub    $0xc,%esp
80103661:	50                   	push   %eax
80103662:	e8 09 d8 ff ff       	call   80100e70 <fileclose>
80103667:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010366a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010366d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103672:	5b                   	pop    %ebx
80103673:	5e                   	pop    %esi
80103674:	5f                   	pop    %edi
80103675:	5d                   	pop    %ebp
80103676:	c3                   	ret    
80103677:	89 f6                	mov    %esi,%esi
80103679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103680:	8b 03                	mov    (%ebx),%eax
80103682:	85 c0                	test   %eax,%eax
80103684:	74 e4                	je     8010366a <pipealloc+0x5a>
    fileclose(*f0);
80103686:	83 ec 0c             	sub    $0xc,%esp
80103689:	50                   	push   %eax
8010368a:	e8 e1 d7 ff ff       	call   80100e70 <fileclose>
  if(*f1)
8010368f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103691:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103694:	85 c0                	test   %eax,%eax
80103696:	75 c6                	jne    8010365e <pipealloc+0x4e>
80103698:	eb d0                	jmp    8010366a <pipealloc+0x5a>
8010369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801036a0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801036a3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801036aa:	00 00 00 
  p->writeopen = 1;
801036ad:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801036b4:	00 00 00 
  p->nwrite = 0;
801036b7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801036be:	00 00 00 
  p->nread = 0;
801036c1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036c8:	00 00 00 
  initlock(&p->lock, "pipe");
801036cb:	68 f0 7f 10 80       	push   $0x80107ff0
801036d0:	50                   	push   %eax
801036d1:	e8 2a 12 00 00       	call   80104900 <initlock>
  (*f0)->type = FD_PIPE;
801036d6:	8b 03                	mov    (%ebx),%eax
  return 0;
801036d8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036db:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036e1:	8b 03                	mov    (%ebx),%eax
801036e3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036e7:	8b 03                	mov    (%ebx),%eax
801036e9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036ed:	8b 03                	mov    (%ebx),%eax
801036ef:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036f2:	8b 06                	mov    (%esi),%eax
801036f4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036fa:	8b 06                	mov    (%esi),%eax
801036fc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103700:	8b 06                	mov    (%esi),%eax
80103702:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103706:	8b 06                	mov    (%esi),%eax
80103708:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010370b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010370e:	31 c0                	xor    %eax,%eax
}
80103710:	5b                   	pop    %ebx
80103711:	5e                   	pop    %esi
80103712:	5f                   	pop    %edi
80103713:	5d                   	pop    %ebp
80103714:	c3                   	ret    
80103715:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103720 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	56                   	push   %esi
80103724:	53                   	push   %ebx
80103725:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103728:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010372b:	83 ec 0c             	sub    $0xc,%esp
8010372e:	53                   	push   %ebx
8010372f:	e8 bc 12 00 00       	call   801049f0 <acquire>
  if(writable){
80103734:	83 c4 10             	add    $0x10,%esp
80103737:	85 f6                	test   %esi,%esi
80103739:	74 45                	je     80103780 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010373b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103741:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103744:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010374b:	00 00 00 
    wakeup(&p->nread);
8010374e:	50                   	push   %eax
8010374f:	e8 ec 0e 00 00       	call   80104640 <wakeup>
80103754:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103757:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010375d:	85 d2                	test   %edx,%edx
8010375f:	75 0a                	jne    8010376b <pipeclose+0x4b>
80103761:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103767:	85 c0                	test   %eax,%eax
80103769:	74 35                	je     801037a0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010376b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010376e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103771:	5b                   	pop    %ebx
80103772:	5e                   	pop    %esi
80103773:	5d                   	pop    %ebp
    release(&p->lock);
80103774:	e9 97 13 00 00       	jmp    80104b10 <release>
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103780:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103786:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103789:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103790:	00 00 00 
    wakeup(&p->nwrite);
80103793:	50                   	push   %eax
80103794:	e8 a7 0e 00 00       	call   80104640 <wakeup>
80103799:	83 c4 10             	add    $0x10,%esp
8010379c:	eb b9                	jmp    80103757 <pipeclose+0x37>
8010379e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	53                   	push   %ebx
801037a4:	e8 67 13 00 00       	call   80104b10 <release>
    kfree((char*)p);
801037a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037ac:	83 c4 10             	add    $0x10,%esp
}
801037af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b2:	5b                   	pop    %ebx
801037b3:	5e                   	pop    %esi
801037b4:	5d                   	pop    %ebp
    kfree((char*)p);
801037b5:	e9 26 ef ff ff       	jmp    801026e0 <kfree>
801037ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	57                   	push   %edi
801037c4:	56                   	push   %esi
801037c5:	53                   	push   %ebx
801037c6:	83 ec 28             	sub    $0x28,%esp
801037c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037cc:	53                   	push   %ebx
801037cd:	e8 1e 12 00 00       	call   801049f0 <acquire>
  for(i = 0; i < n; i++){
801037d2:	8b 45 10             	mov    0x10(%ebp),%eax
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	85 c0                	test   %eax,%eax
801037da:	0f 8e c9 00 00 00    	jle    801038a9 <pipewrite+0xe9>
801037e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037e3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037e9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037ef:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037f2:	03 4d 10             	add    0x10(%ebp),%ecx
801037f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801037fe:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103804:	39 d0                	cmp    %edx,%eax
80103806:	75 71                	jne    80103879 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103808:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010380e:	85 c0                	test   %eax,%eax
80103810:	74 4e                	je     80103860 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103812:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103818:	eb 3a                	jmp    80103854 <pipewrite+0x94>
8010381a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103820:	83 ec 0c             	sub    $0xc,%esp
80103823:	57                   	push   %edi
80103824:	e8 17 0e 00 00       	call   80104640 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103829:	5a                   	pop    %edx
8010382a:	59                   	pop    %ecx
8010382b:	53                   	push   %ebx
8010382c:	56                   	push   %esi
8010382d:	e8 9e 0b 00 00       	call   801043d0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103832:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103838:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010383e:	83 c4 10             	add    $0x10,%esp
80103841:	05 00 02 00 00       	add    $0x200,%eax
80103846:	39 c2                	cmp    %eax,%edx
80103848:	75 36                	jne    80103880 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010384a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103850:	85 c0                	test   %eax,%eax
80103852:	74 0c                	je     80103860 <pipewrite+0xa0>
80103854:	e8 07 04 00 00       	call   80103c60 <myproc>
80103859:	8b 40 24             	mov    0x24(%eax),%eax
8010385c:	85 c0                	test   %eax,%eax
8010385e:	74 c0                	je     80103820 <pipewrite+0x60>
        release(&p->lock);
80103860:	83 ec 0c             	sub    $0xc,%esp
80103863:	53                   	push   %ebx
80103864:	e8 a7 12 00 00       	call   80104b10 <release>
        return -1;
80103869:	83 c4 10             	add    $0x10,%esp
8010386c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103871:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103874:	5b                   	pop    %ebx
80103875:	5e                   	pop    %esi
80103876:	5f                   	pop    %edi
80103877:	5d                   	pop    %ebp
80103878:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103879:	89 c2                	mov    %eax,%edx
8010387b:	90                   	nop
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103880:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103883:	8d 42 01             	lea    0x1(%edx),%eax
80103886:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010388c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103892:	83 c6 01             	add    $0x1,%esi
80103895:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103899:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010389c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010389f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801038a3:	0f 85 4f ff ff ff    	jne    801037f8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038a9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038af:	83 ec 0c             	sub    $0xc,%esp
801038b2:	50                   	push   %eax
801038b3:	e8 88 0d 00 00       	call   80104640 <wakeup>
  release(&p->lock);
801038b8:	89 1c 24             	mov    %ebx,(%esp)
801038bb:	e8 50 12 00 00       	call   80104b10 <release>
  return n;
801038c0:	83 c4 10             	add    $0x10,%esp
801038c3:	8b 45 10             	mov    0x10(%ebp),%eax
801038c6:	eb a9                	jmp    80103871 <pipewrite+0xb1>
801038c8:	90                   	nop
801038c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	83 ec 18             	sub    $0x18,%esp
801038d9:	8b 75 08             	mov    0x8(%ebp),%esi
801038dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038df:	56                   	push   %esi
801038e0:	e8 0b 11 00 00       	call   801049f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038ee:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038f4:	75 6a                	jne    80103960 <piperead+0x90>
801038f6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801038fc:	85 db                	test   %ebx,%ebx
801038fe:	0f 84 c4 00 00 00    	je     801039c8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103904:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010390a:	eb 2d                	jmp    80103939 <piperead+0x69>
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103910:	83 ec 08             	sub    $0x8,%esp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
80103915:	e8 b6 0a 00 00       	call   801043d0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010391a:	83 c4 10             	add    $0x10,%esp
8010391d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103923:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103929:	75 35                	jne    80103960 <piperead+0x90>
8010392b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103931:	85 d2                	test   %edx,%edx
80103933:	0f 84 8f 00 00 00    	je     801039c8 <piperead+0xf8>
    if(myproc()->killed){
80103939:	e8 22 03 00 00       	call   80103c60 <myproc>
8010393e:	8b 48 24             	mov    0x24(%eax),%ecx
80103941:	85 c9                	test   %ecx,%ecx
80103943:	74 cb                	je     80103910 <piperead+0x40>
      release(&p->lock);
80103945:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103948:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010394d:	56                   	push   %esi
8010394e:	e8 bd 11 00 00       	call   80104b10 <release>
      return -1;
80103953:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103956:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103959:	89 d8                	mov    %ebx,%eax
8010395b:	5b                   	pop    %ebx
8010395c:	5e                   	pop    %esi
8010395d:	5f                   	pop    %edi
8010395e:	5d                   	pop    %ebp
8010395f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103960:	8b 45 10             	mov    0x10(%ebp),%eax
80103963:	85 c0                	test   %eax,%eax
80103965:	7e 61                	jle    801039c8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103967:	31 db                	xor    %ebx,%ebx
80103969:	eb 13                	jmp    8010397e <piperead+0xae>
8010396b:	90                   	nop
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103970:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103976:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010397c:	74 1f                	je     8010399d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010397e:	8d 41 01             	lea    0x1(%ecx),%eax
80103981:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103987:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010398d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103992:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103995:	83 c3 01             	add    $0x1,%ebx
80103998:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010399b:	75 d3                	jne    80103970 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010399d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801039a3:	83 ec 0c             	sub    $0xc,%esp
801039a6:	50                   	push   %eax
801039a7:	e8 94 0c 00 00       	call   80104640 <wakeup>
  release(&p->lock);
801039ac:	89 34 24             	mov    %esi,(%esp)
801039af:	e8 5c 11 00 00       	call   80104b10 <release>
  return i;
801039b4:	83 c4 10             	add    $0x10,%esp
}
801039b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039ba:	89 d8                	mov    %ebx,%eax
801039bc:	5b                   	pop    %ebx
801039bd:	5e                   	pop    %esi
801039be:	5f                   	pop    %edi
801039bf:	5d                   	pop    %ebp
801039c0:	c3                   	ret    
801039c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039c8:	31 db                	xor    %ebx,%ebx
801039ca:	eb d1                	jmp    8010399d <piperead+0xcd>
801039cc:	66 90                	xchg   %ax,%ax
801039ce:	66 90                	xchg   %ax,%ax

801039d0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void) {
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
    struct page *pg;
    char *sp;

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039d4:	bb 54 4d 11 80       	mov    $0x80114d54,%ebx
allocproc(void) {
801039d9:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
801039dc:	68 20 4d 11 80       	push   $0x80114d20
801039e1:	e8 0a 10 00 00       	call   801049f0 <acquire>
801039e6:	83 c4 10             	add    $0x10,%esp
801039e9:	eb 17                	jmp    80103a02 <allocproc+0x32>
801039eb:	90                   	nop
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039f0:	81 c3 50 04 00 00    	add    $0x450,%ebx
801039f6:	81 fb 54 61 12 80    	cmp    $0x80126154,%ebx
801039fc:	0f 83 fe 00 00 00    	jae    80103b00 <allocproc+0x130>
        if (p->state == UNUSED)
80103a02:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a05:	85 c0                	test   %eax,%eax
80103a07:	75 e7                	jne    801039f0 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103a09:	a1 04 b0 10 80       	mov    0x8010b004,%eax

    release(&ptable.lock);
80103a0e:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
80103a11:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80103a18:	8d 50 01             	lea    0x1(%eax),%edx
80103a1b:	89 43 10             	mov    %eax,0x10(%ebx)
    release(&ptable.lock);
80103a1e:	68 20 4d 11 80       	push   $0x80114d20
    p->pid = nextpid++;
80103a23:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    release(&ptable.lock);
80103a29:	e8 e2 10 00 00       	call   80104b10 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
80103a2e:	e8 5d ee ff ff       	call   80102890 <kalloc>
80103a33:	83 c4 10             	add    $0x10,%esp
80103a36:	85 c0                	test   %eax,%eax
80103a38:	89 43 08             	mov    %eax,0x8(%ebx)
80103a3b:	0f 84 d8 00 00 00    	je     80103b19 <allocproc+0x149>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103a41:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
80103a47:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103a4a:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103a4f:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint *) sp = (uint) trapret;
80103a52:	c7 40 14 b2 5d 10 80 	movl   $0x80105db2,0x14(%eax)
    p->context = (struct context *) sp;
80103a59:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103a5c:	6a 14                	push   $0x14
80103a5e:	6a 00                	push   $0x0
80103a60:	50                   	push   %eax
80103a61:	e8 0a 11 00 00       	call   80104b70 <memset>
    p->context->eip = (uint) forkret;
80103a66:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a69:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
80103a6f:	8d 93 40 04 00 00    	lea    0x440(%ebx),%edx
80103a75:	83 c4 10             	add    $0x10,%esp
80103a78:	c7 40 10 30 3b 10 80 	movl   $0x80103b30,0x10(%eax)

    //TODO INIT PROC PAGES FIELDS
    p->pagesCounter = 0;
80103a7f:	c7 83 44 04 00 00 00 	movl   $0x0,0x444(%ebx)
80103a86:	00 00 00 
80103a89:	89 c8                	mov    %ecx,%eax
    p->nextpageid = 1;
80103a8b:	c7 83 40 04 00 00 01 	movl   $0x1,0x440(%ebx)
80103a92:	00 00 00 
//    p->swapOffset = 0;
    p->pagesequel = 0;
80103a95:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
80103a9c:	00 00 00 
    p->pagesinSwap = 0;
80103a9f:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
80103aa6:	00 00 00 
80103aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;
80103ab0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103ab6:	83 c0 04             	add    $0x4,%eax
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103ab9:	39 d0                	cmp    %edx,%eax
80103abb:	75 f3                	jne    80103ab0 <allocproc+0xe0>

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103abd:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103ac3:	90                   	nop
80103ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
        pg->offset = 0;
80103ac8:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        pg->pageid = 0;
80103acf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103ad6:	83 c0 1c             	add    $0x1c,%eax
        pg->present = 0;
80103ad9:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
        pg->sequel = 0;
80103ae0:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
        pg->physAdress = 0;
80103ae7:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        pg->virtAdress = 0;
80103aee:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103af5:	39 c8                	cmp    %ecx,%eax
80103af7:	72 cf                	jb     80103ac8 <allocproc+0xf8>
    }


    return p;
}
80103af9:	89 d8                	mov    %ebx,%eax
80103afb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103afe:	c9                   	leave  
80103aff:	c3                   	ret    
    release(&ptable.lock);
80103b00:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80103b03:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
80103b05:	68 20 4d 11 80       	push   $0x80114d20
80103b0a:	e8 01 10 00 00       	call   80104b10 <release>
}
80103b0f:	89 d8                	mov    %ebx,%eax
    return 0;
80103b11:	83 c4 10             	add    $0x10,%esp
}
80103b14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b17:	c9                   	leave  
80103b18:	c3                   	ret    
        p->state = UNUSED;
80103b19:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103b20:	31 db                	xor    %ebx,%ebx
80103b22:	eb d5                	jmp    80103af9 <allocproc+0x129>
80103b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b30 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103b36:	68 20 4d 11 80       	push   $0x80114d20
80103b3b:	e8 d0 0f 00 00       	call   80104b10 <release>

    if (first) {
80103b40:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	85 c0                	test   %eax,%eax
80103b4a:	75 04                	jne    80103b50 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103b4c:	c9                   	leave  
80103b4d:	c3                   	ret    
80103b4e:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
80103b50:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
80103b53:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b5a:	00 00 00 
        iinit(ROOTDEV);
80103b5d:	6a 01                	push   $0x1
80103b5f:	e8 5c d9 ff ff       	call   801014c0 <iinit>
        initlog(ROOTDEV);
80103b64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b6b:	e8 60 f3 ff ff       	call   80102ed0 <initlog>
80103b70:	83 c4 10             	add    $0x10,%esp
}
80103b73:	c9                   	leave  
80103b74:	c3                   	ret    
80103b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b80 <notShell>:
    return nextpid>3;
80103b80:	31 c0                	xor    %eax,%eax
80103b82:	83 3d 04 b0 10 80 03 	cmpl   $0x3,0x8010b004
int notShell(void){
80103b89:	55                   	push   %ebp
80103b8a:	89 e5                	mov    %esp,%ebp
}
80103b8c:	5d                   	pop    %ebp
    return nextpid>3;
80103b8d:	0f 9f c0             	setg   %al
}
80103b90:	c3                   	ret    
80103b91:	eb 0d                	jmp    80103ba0 <pinit>
80103b93:	90                   	nop
80103b94:	90                   	nop
80103b95:	90                   	nop
80103b96:	90                   	nop
80103b97:	90                   	nop
80103b98:	90                   	nop
80103b99:	90                   	nop
80103b9a:	90                   	nop
80103b9b:	90                   	nop
80103b9c:	90                   	nop
80103b9d:	90                   	nop
80103b9e:	90                   	nop
80103b9f:	90                   	nop

80103ba0 <pinit>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ba6:	68 f5 7f 10 80       	push   $0x80107ff5
80103bab:	68 20 4d 11 80       	push   $0x80114d20
80103bb0:	e8 4b 0d 00 00       	call   80104900 <initlock>
}
80103bb5:	83 c4 10             	add    $0x10,%esp
80103bb8:	c9                   	leave  
80103bb9:	c3                   	ret    
80103bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bc0 <mycpu>:
mycpu(void) {
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	56                   	push   %esi
80103bc4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bc5:	9c                   	pushf  
80103bc6:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103bc7:	f6 c4 02             	test   $0x2,%ah
80103bca:	75 5e                	jne    80103c2a <mycpu+0x6a>
    apicid = lapicid();
80103bcc:	e8 2f ef ff ff       	call   80102b00 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103bd1:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103bd7:	85 f6                	test   %esi,%esi
80103bd9:	7e 42                	jle    80103c1d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103bdb:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103be2:	39 d0                	cmp    %edx,%eax
80103be4:	74 30                	je     80103c16 <mycpu+0x56>
80103be6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
    for (i = 0; i < ncpu; ++i) {
80103beb:	31 d2                	xor    %edx,%edx
80103bed:	8d 76 00             	lea    0x0(%esi),%esi
80103bf0:	83 c2 01             	add    $0x1,%edx
80103bf3:	39 f2                	cmp    %esi,%edx
80103bf5:	74 26                	je     80103c1d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103bf7:	0f b6 19             	movzbl (%ecx),%ebx
80103bfa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103c00:	39 c3                	cmp    %eax,%ebx
80103c02:	75 ec                	jne    80103bf0 <mycpu+0x30>
80103c04:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103c0a:	05 80 37 11 80       	add    $0x80113780,%eax
}
80103c0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c12:	5b                   	pop    %ebx
80103c13:	5e                   	pop    %esi
80103c14:	5d                   	pop    %ebp
80103c15:	c3                   	ret    
        if (cpus[i].apicid == apicid)
80103c16:	b8 80 37 11 80       	mov    $0x80113780,%eax
            return &cpus[i];
80103c1b:	eb f2                	jmp    80103c0f <mycpu+0x4f>
    panic("unknown apicid\n");
80103c1d:	83 ec 0c             	sub    $0xc,%esp
80103c20:	68 fc 7f 10 80       	push   $0x80107ffc
80103c25:	e8 66 c7 ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
80103c2a:	83 ec 0c             	sub    $0xc,%esp
80103c2d:	68 d8 80 10 80       	push   $0x801080d8
80103c32:	e8 59 c7 ff ff       	call   80100390 <panic>
80103c37:	89 f6                	mov    %esi,%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c40 <cpuid>:
cpuid() {
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c46:	e8 75 ff ff ff       	call   80103bc0 <mycpu>
80103c4b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103c50:	c9                   	leave  
  return mycpu()-cpus;
80103c51:	c1 f8 04             	sar    $0x4,%eax
80103c54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c5a:	c3                   	ret    
80103c5b:	90                   	nop
80103c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c60 <myproc>:
myproc(void) {
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
80103c64:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103c67:	e8 44 0d 00 00       	call   801049b0 <pushcli>
    c = mycpu();
80103c6c:	e8 4f ff ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
80103c71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103c77:	e8 34 0e 00 00       	call   80104ab0 <popcli>
}
80103c7c:	83 c4 04             	add    $0x4,%esp
80103c7f:	89 d8                	mov    %ebx,%eax
80103c81:	5b                   	pop    %ebx
80103c82:	5d                   	pop    %ebp
80103c83:	c3                   	ret    
80103c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c90 <userinit>:
userinit(void) {
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	53                   	push   %ebx
80103c94:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103c97:	e8 34 fd ff ff       	call   801039d0 <allocproc>
80103c9c:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103c9e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
    if ((p->pgdir = setupkvm()) == 0)
80103ca3:	e8 58 3a 00 00       	call   80107700 <setupkvm>
80103ca8:	85 c0                	test   %eax,%eax
80103caa:	89 43 04             	mov    %eax,0x4(%ebx)
80103cad:	0f 84 bd 00 00 00    	je     80103d70 <userinit+0xe0>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103cb3:	83 ec 04             	sub    $0x4,%esp
80103cb6:	68 2c 00 00 00       	push   $0x2c
80103cbb:	68 60 b4 10 80       	push   $0x8010b460
80103cc0:	50                   	push   %eax
80103cc1:	e8 fa 32 00 00       	call   80106fc0 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103cc6:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103cc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103ccf:	6a 4c                	push   $0x4c
80103cd1:	6a 00                	push   $0x0
80103cd3:	ff 73 18             	pushl  0x18(%ebx)
80103cd6:	e8 95 0e 00 00       	call   80104b70 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cdb:	8b 43 18             	mov    0x18(%ebx),%eax
80103cde:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ce3:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103ce8:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ceb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cef:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103cf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cfd:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103d01:	8b 43 18             	mov    0x18(%ebx),%eax
80103d04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d08:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103d0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103d16:	8b 43 18             	mov    0x18(%ebx),%eax
80103d19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103d20:	8b 43 18             	mov    0x18(%ebx),%eax
80103d23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103d2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d2d:	6a 10                	push   $0x10
80103d2f:	68 25 80 10 80       	push   $0x80108025
80103d34:	50                   	push   %eax
80103d35:	e8 16 10 00 00       	call   80104d50 <safestrcpy>
    p->cwd = namei("/");
80103d3a:	c7 04 24 2e 80 10 80 	movl   $0x8010802e,(%esp)
80103d41:	e8 da e1 ff ff       	call   80101f20 <namei>
80103d46:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103d49:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80103d50:	e8 9b 0c 00 00       	call   801049f0 <acquire>
    p->state = RUNNABLE;
80103d55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103d5c:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80103d63:	e8 a8 0d 00 00       	call   80104b10 <release>
}
80103d68:	83 c4 10             	add    $0x10,%esp
80103d6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d6e:	c9                   	leave  
80103d6f:	c3                   	ret    
        panic("userinit: out of memory?");
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	68 0c 80 10 80       	push   $0x8010800c
80103d78:	e8 13 c6 ff ff       	call   80100390 <panic>
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi

80103d80 <growproc>:
growproc(int n) {
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
80103d85:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103d88:	e8 23 0c 00 00       	call   801049b0 <pushcli>
    c = mycpu();
80103d8d:	e8 2e fe ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
80103d92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103d98:	e8 13 0d 00 00       	call   80104ab0 <popcli>
    if (n > 0) {
80103d9d:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103da0:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103da2:	7f 1c                	jg     80103dc0 <growproc+0x40>
    } else if (n < 0) {
80103da4:	75 3a                	jne    80103de0 <growproc+0x60>
    switchuvm(curproc);
80103da6:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103da9:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103dab:	53                   	push   %ebx
80103dac:	e8 ff 30 00 00       	call   80106eb0 <switchuvm>
    return 0;
80103db1:	83 c4 10             	add    $0x10,%esp
80103db4:	31 c0                	xor    %eax,%eax
}
80103db6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db9:	5b                   	pop    %ebx
80103dba:	5e                   	pop    %esi
80103dbb:	5d                   	pop    %ebp
80103dbc:	c3                   	ret    
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103dc0:	83 ec 04             	sub    $0x4,%esp
80103dc3:	01 c6                	add    %eax,%esi
80103dc5:	56                   	push   %esi
80103dc6:	50                   	push   %eax
80103dc7:	ff 73 04             	pushl  0x4(%ebx)
80103dca:	e8 91 34 00 00       	call   80107260 <allocuvm>
80103dcf:	83 c4 10             	add    $0x10,%esp
80103dd2:	85 c0                	test   %eax,%eax
80103dd4:	75 d0                	jne    80103da6 <growproc+0x26>
            return -1;
80103dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ddb:	eb d9                	jmp    80103db6 <growproc+0x36>
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103de0:	83 ec 04             	sub    $0x4,%esp
80103de3:	01 c6                	add    %eax,%esi
80103de5:	56                   	push   %esi
80103de6:	50                   	push   %eax
80103de7:	ff 73 04             	pushl  0x4(%ebx)
80103dea:	e8 41 33 00 00       	call   80107130 <deallocuvm>
80103def:	83 c4 10             	add    $0x10,%esp
80103df2:	85 c0                	test   %eax,%eax
80103df4:	75 b0                	jne    80103da6 <growproc+0x26>
80103df6:	eb de                	jmp    80103dd6 <growproc+0x56>
80103df8:	90                   	nop
80103df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e00 <fork>:
fork(void) {
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80103e09:	e8 a2 0b 00 00       	call   801049b0 <pushcli>
    c = mycpu();
80103e0e:	e8 ad fd ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
80103e13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103e19:	e8 92 0c 00 00       	call   80104ab0 <popcli>
    if ((np = allocproc()) == 0) {
80103e1e:	e8 ad fb ff ff       	call   801039d0 <allocproc>
80103e23:	85 c0                	test   %eax,%eax
80103e25:	0f 84 77 02 00 00    	je     801040a2 <fork+0x2a2>
    if (firstRun) {
80103e2b:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
80103e31:	89 c2                	mov    %eax,%edx
80103e33:	85 c9                	test   %ecx,%ecx
80103e35:	0f 85 45 02 00 00    	jne    80104080 <fork+0x280>
    createSwapFile(np);
80103e3b:	83 ec 0c             	sub    $0xc,%esp
80103e3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103e41:	52                   	push   %edx
80103e42:	e8 a9 e3 ff ff       	call   801021f0 <createSwapFile>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103e47:	58                   	pop    %eax
80103e48:	5a                   	pop    %edx
80103e49:	ff 33                	pushl  (%ebx)
80103e4b:	ff 73 04             	pushl  0x4(%ebx)
80103e4e:	e8 cd 39 00 00       	call   80107820 <copyuvm>
80103e53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e56:	83 c4 10             	add    $0x10,%esp
80103e59:	85 c0                	test   %eax,%eax
80103e5b:	89 42 04             	mov    %eax,0x4(%edx)
80103e5e:	0f 84 45 02 00 00    	je     801040a9 <fork+0x2a9>
    np->sz = curproc->sz;
80103e64:	8b 03                	mov    (%ebx),%eax
    *np->tf = *curproc->tf;
80103e66:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->parent = curproc;
80103e6b:	89 5a 14             	mov    %ebx,0x14(%edx)
    *np->tf = *curproc->tf;
80103e6e:	8b 7a 18             	mov    0x18(%edx),%edi
    np->sz = curproc->sz;
80103e71:	89 02                	mov    %eax,(%edx)
    *np->tf = *curproc->tf;
80103e73:	8b 73 18             	mov    0x18(%ebx),%esi
80103e76:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->nextpageid = curproc->nextpageid;
80103e78:	8b 83 40 04 00 00    	mov    0x440(%ebx),%eax
80103e7e:	89 82 40 04 00 00    	mov    %eax,0x440(%edx)
    np->pagesCounter = curproc->pagesCounter;
80103e84:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
80103e8a:	89 82 44 04 00 00    	mov    %eax,0x444(%edx)
    np->pagesequel = curproc->pagesequel;
80103e90:	8b 83 4c 04 00 00    	mov    0x44c(%ebx),%eax
80103e96:	89 82 4c 04 00 00    	mov    %eax,0x44c(%edx)
    np->pagesinSwap = curproc->pagesinSwap;
80103e9c:	8b 83 48 04 00 00    	mov    0x448(%ebx),%eax
80103ea2:	89 82 48 04 00 00    	mov    %eax,0x448(%edx)
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103ea8:	31 c0                	xor    %eax,%eax
80103eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        np->swapFileEntries[k]=curproc->swapFileEntries[k];
80103eb0:	8b 8c 83 00 04 00 00 	mov    0x400(%ebx,%eax,4),%ecx
80103eb7:	89 8c 82 00 04 00 00 	mov    %ecx,0x400(%edx,%eax,4)
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103ebe:	83 c0 01             	add    $0x1,%eax
80103ec1:	83 f8 10             	cmp    $0x10,%eax
80103ec4:	75 ea                	jne    80103eb0 <fork+0xb0>
    for( pg = np->pages , cg = curproc->pages;
80103ec6:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
80103ecc:	8d 8b 80 00 00 00    	lea    0x80(%ebx),%ecx
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103ed2:	8d ba 00 04 00 00    	lea    0x400(%edx),%edi
80103ed8:	90                   	nop
80103ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        pg->offset = cg->offset;
80103ee0:	8b 71 10             	mov    0x10(%ecx),%esi
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103ee3:	83 c0 1c             	add    $0x1c,%eax
80103ee6:	83 c1 1c             	add    $0x1c,%ecx
        pg->offset = cg->offset;
80103ee9:	89 70 f4             	mov    %esi,-0xc(%eax)
        pg->pageid = cg->pageid;
80103eec:	8b 71 e8             	mov    -0x18(%ecx),%esi
80103eef:	89 70 e8             	mov    %esi,-0x18(%eax)
        pg->present = cg->present;
80103ef2:	8b 71 f0             	mov    -0x10(%ecx),%esi
80103ef5:	89 70 f0             	mov    %esi,-0x10(%eax)
        pg->sequel = cg->sequel;
80103ef8:	8b 71 ec             	mov    -0x14(%ecx),%esi
80103efb:	89 70 ec             	mov    %esi,-0x14(%eax)
        pg->physAdress = cg->physAdress;
80103efe:	8b 71 f8             	mov    -0x8(%ecx),%esi
80103f01:	89 70 f8             	mov    %esi,-0x8(%eax)
        pg->virtAdress = cg->virtAdress;
80103f04:	8b 71 fc             	mov    -0x4(%ecx),%esi
80103f07:	89 70 fc             	mov    %esi,-0x4(%eax)
    for( pg = np->pages , cg = curproc->pages;
80103f0a:	39 c7                	cmp    %eax,%edi
80103f0c:	77 d2                	ja     80103ee0 <fork+0xe0>
    if (!firstRun) {
80103f0e:	8b 3d 08 b0 10 80    	mov    0x8010b008,%edi
80103f14:	85 ff                	test   %edi,%edi
80103f16:	0f 85 c4 00 00 00    	jne    80103fe0 <fork+0x1e0>
        for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80103f1c:	83 bb 44 04 00 00 10 	cmpl   $0x10,0x444(%ebx)
80103f23:	7f 40                	jg     80103f65 <fork+0x165>
80103f25:	e9 b6 00 00 00       	jmp    80103fe0 <fork+0x1e0>
80103f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
80103f30:	68 00 10 00 00       	push   $0x1000
80103f35:	51                   	push   %ecx
80103f36:	68 20 3d 11 80       	push   $0x80113d20
80103f3b:	52                   	push   %edx
80103f3c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103f3f:	e8 4c e3 ff ff       	call   80102290 <writeToSwapFile>
80103f44:	83 c4 10             	add    $0x10,%esp
80103f47:	83 f8 ff             	cmp    $0xffffffff,%eax
80103f4a:	89 c6                	mov    %eax,%esi
80103f4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f4f:	0f 84 42 01 00 00    	je     80104097 <fork+0x297>
        for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80103f55:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
80103f5b:	83 c7 01             	add    $0x1,%edi
80103f5e:	83 e8 10             	sub    $0x10,%eax
80103f61:	39 f8                	cmp    %edi,%eax
80103f63:	7e 7b                	jle    80103fe0 <fork+0x1e0>
            memset(buffer, 0, PGSIZE);
80103f65:	83 ec 04             	sub    $0x4,%esp
80103f68:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103f6b:	68 00 10 00 00       	push   $0x1000
80103f70:	6a 00                	push   $0x0
80103f72:	68 20 3d 11 80       	push   $0x80113d20
80103f77:	e8 f4 0b 00 00       	call   80104b70 <memset>
80103f7c:	89 f9                	mov    %edi,%ecx
            if (readFromSwapFile(curproc, buffer, k * PGSIZE, PGSIZE) == -1) {
80103f7e:	68 00 10 00 00       	push   $0x1000
80103f83:	c1 e1 0c             	shl    $0xc,%ecx
80103f86:	51                   	push   %ecx
80103f87:	68 20 3d 11 80       	push   $0x80113d20
80103f8c:	53                   	push   %ebx
80103f8d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103f90:	e8 2b e3 ff ff       	call   801022c0 <readFromSwapFile>
80103f95:	83 c4 20             	add    $0x20,%esp
80103f98:	83 f8 ff             	cmp    $0xffffffff,%eax
80103f9b:	89 c6                	mov    %eax,%esi
80103f9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103fa0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103fa3:	75 8b                	jne    80103f30 <fork+0x130>
                kfree(np->kstack);
80103fa5:	83 ec 0c             	sub    $0xc,%esp
80103fa8:	ff 72 08             	pushl  0x8(%edx)
80103fab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
                kfree(np->kstack);
80103fae:	e8 2d e7 ff ff       	call   801026e0 <kfree>
                np->kstack = 0;
80103fb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fb6:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
                np->state = UNUSED;
80103fbd:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
                removeSwapFile(np); //clear swapFile
80103fc4:	89 14 24             	mov    %edx,(%esp)
80103fc7:	e8 24 e0 ff ff       	call   80101ff0 <removeSwapFile>
                return -1;
80103fcc:	83 c4 10             	add    $0x10,%esp
}
80103fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fd2:	89 f0                	mov    %esi,%eax
80103fd4:	5b                   	pop    %ebx
80103fd5:	5e                   	pop    %esi
80103fd6:	5f                   	pop    %edi
80103fd7:	5d                   	pop    %ebp
80103fd8:	c3                   	ret    
80103fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    np->tf->eax = 0;
80103fe0:	8b 42 18             	mov    0x18(%edx),%eax
    for (i = 0; i < NOFILE; i++)
80103fe3:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80103fe5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[i])
80103ff0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ff4:	85 c0                	test   %eax,%eax
80103ff6:	74 16                	je     8010400e <fork+0x20e>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103ff8:	83 ec 0c             	sub    $0xc,%esp
80103ffb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103ffe:	50                   	push   %eax
80103fff:	e8 1c ce ff ff       	call   80100e20 <filedup>
80104004:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104007:	83 c4 10             	add    $0x10,%esp
8010400a:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++)
8010400e:	83 c6 01             	add    $0x1,%esi
80104011:	83 fe 10             	cmp    $0x10,%esi
80104014:	75 da                	jne    80103ff0 <fork+0x1f0>
    np->cwd = idup(curproc->cwd);
80104016:	83 ec 0c             	sub    $0xc,%esp
80104019:	ff 73 68             	pushl  0x68(%ebx)
8010401c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010401f:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
80104022:	e8 69 d6 ff ff       	call   80101690 <idup>
80104027:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010402a:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
8010402d:	89 42 68             	mov    %eax,0x68(%edx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104030:	8d 42 6c             	lea    0x6c(%edx),%eax
80104033:	6a 10                	push   $0x10
80104035:	53                   	push   %ebx
80104036:	50                   	push   %eax
80104037:	e8 14 0d 00 00       	call   80104d50 <safestrcpy>
    pid = np->pid;
8010403c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010403f:	8b 72 10             	mov    0x10(%edx),%esi
    acquire(&ptable.lock);
80104042:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80104049:	e8 a2 09 00 00       	call   801049f0 <acquire>
    np->state = RUNNABLE;
8010404e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104051:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
    release(&ptable.lock);
80104058:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
8010405f:	e8 ac 0a 00 00       	call   80104b10 <release>
    firstRun = 0;
80104064:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
8010406b:	00 00 00 
    return pid;
8010406e:	83 c4 10             	add    $0x10,%esp
}
80104071:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104074:	89 f0                	mov    %esi,%eax
80104076:	5b                   	pop    %ebx
80104077:	5e                   	pop    %esi
80104078:	5f                   	pop    %edi
80104079:	5d                   	pop    %ebp
8010407a:	c3                   	ret    
8010407b:	90                   	nop
8010407c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        createSwapFile(curproc);
80104080:	83 ec 0c             	sub    $0xc,%esp
80104083:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104086:	53                   	push   %ebx
80104087:	e8 64 e1 ff ff       	call   801021f0 <createSwapFile>
8010408c:	83 c4 10             	add    $0x10,%esp
8010408f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104092:	e9 a4 fd ff ff       	jmp    80103e3b <fork+0x3b>
                kfree(np->kstack);
80104097:	83 ec 0c             	sub    $0xc,%esp
8010409a:	ff 72 08             	pushl  0x8(%edx)
8010409d:	e9 0c ff ff ff       	jmp    80103fae <fork+0x1ae>
        return -1;
801040a2:	be ff ff ff ff       	mov    $0xffffffff,%esi
801040a7:	eb c8                	jmp    80104071 <fork+0x271>
        kfree(np->kstack);
801040a9:	83 ec 0c             	sub    $0xc,%esp
801040ac:	ff 72 08             	pushl  0x8(%edx)
        return -1;
801040af:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->kstack);
801040b4:	e8 27 e6 ff ff       	call   801026e0 <kfree>
        np->kstack = 0;
801040b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        return -1;
801040bc:	83 c4 10             	add    $0x10,%esp
        np->kstack = 0;
801040bf:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
        np->state = UNUSED;
801040c6:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
        return -1;
801040cd:	eb a2                	jmp    80104071 <fork+0x271>
801040cf:	90                   	nop

801040d0 <scheduler>:
scheduler(void) {
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	57                   	push   %edi
801040d4:	56                   	push   %esi
801040d5:	53                   	push   %ebx
801040d6:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
801040d9:	e8 e2 fa ff ff       	call   80103bc0 <mycpu>
801040de:	8d 78 04             	lea    0x4(%eax),%edi
801040e1:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801040e3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040ea:	00 00 00 
801040ed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801040f0:	fb                   	sti    
        acquire(&ptable.lock);
801040f1:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040f4:	bb 54 4d 11 80       	mov    $0x80114d54,%ebx
        acquire(&ptable.lock);
801040f9:	68 20 4d 11 80       	push   $0x80114d20
801040fe:	e8 ed 08 00 00       	call   801049f0 <acquire>
80104103:	83 c4 10             	add    $0x10,%esp
80104106:	8d 76 00             	lea    0x0(%esi),%esi
80104109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (p->state != RUNNABLE)
80104110:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104114:	75 33                	jne    80104149 <scheduler+0x79>
            switchuvm(p);
80104116:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80104119:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
8010411f:	53                   	push   %ebx
80104120:	e8 8b 2d 00 00       	call   80106eb0 <switchuvm>
            swtch(&(c->scheduler), p->context);
80104125:	58                   	pop    %eax
80104126:	5a                   	pop    %edx
80104127:	ff 73 1c             	pushl  0x1c(%ebx)
8010412a:	57                   	push   %edi
            p->state = RUNNING;
8010412b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80104132:	e8 74 0c 00 00       	call   80104dab <swtch>
            switchkvm();
80104137:	e8 54 2d 00 00       	call   80106e90 <switchkvm>
            c->proc = 0;
8010413c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104143:	00 00 00 
80104146:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104149:	81 c3 50 04 00 00    	add    $0x450,%ebx
8010414f:	81 fb 54 61 12 80    	cmp    $0x80126154,%ebx
80104155:	72 b9                	jb     80104110 <scheduler+0x40>
        release(&ptable.lock);
80104157:	83 ec 0c             	sub    $0xc,%esp
8010415a:	68 20 4d 11 80       	push   $0x80114d20
8010415f:	e8 ac 09 00 00       	call   80104b10 <release>
        sti();
80104164:	83 c4 10             	add    $0x10,%esp
80104167:	eb 87                	jmp    801040f0 <scheduler+0x20>
80104169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104170 <sched>:
sched(void) {
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
    pushcli();
80104175:	e8 36 08 00 00       	call   801049b0 <pushcli>
    c = mycpu();
8010417a:	e8 41 fa ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
8010417f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104185:	e8 26 09 00 00       	call   80104ab0 <popcli>
    if (!holding(&ptable.lock))
8010418a:	83 ec 0c             	sub    $0xc,%esp
8010418d:	68 20 4d 11 80       	push   $0x80114d20
80104192:	e8 d9 07 00 00       	call   80104970 <holding>
80104197:	83 c4 10             	add    $0x10,%esp
8010419a:	85 c0                	test   %eax,%eax
8010419c:	74 4f                	je     801041ed <sched+0x7d>
    if (mycpu()->ncli != 1)
8010419e:	e8 1d fa ff ff       	call   80103bc0 <mycpu>
801041a3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041aa:	75 68                	jne    80104214 <sched+0xa4>
    if (p->state == RUNNING)
801041ac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041b0:	74 55                	je     80104207 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041b2:	9c                   	pushf  
801041b3:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801041b4:	f6 c4 02             	test   $0x2,%ah
801041b7:	75 41                	jne    801041fa <sched+0x8a>
    intena = mycpu()->intena;
801041b9:	e8 02 fa ff ff       	call   80103bc0 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
801041be:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
801041c1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
801041c7:	e8 f4 f9 ff ff       	call   80103bc0 <mycpu>
801041cc:	83 ec 08             	sub    $0x8,%esp
801041cf:	ff 70 04             	pushl  0x4(%eax)
801041d2:	53                   	push   %ebx
801041d3:	e8 d3 0b 00 00       	call   80104dab <swtch>
    mycpu()->intena = intena;
801041d8:	e8 e3 f9 ff ff       	call   80103bc0 <mycpu>
}
801041dd:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
801041e0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801041e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e9:	5b                   	pop    %ebx
801041ea:	5e                   	pop    %esi
801041eb:	5d                   	pop    %ebp
801041ec:	c3                   	ret    
        panic("sched ptable.lock");
801041ed:	83 ec 0c             	sub    $0xc,%esp
801041f0:	68 30 80 10 80       	push   $0x80108030
801041f5:	e8 96 c1 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
801041fa:	83 ec 0c             	sub    $0xc,%esp
801041fd:	68 5c 80 10 80       	push   $0x8010805c
80104202:	e8 89 c1 ff ff       	call   80100390 <panic>
        panic("sched running");
80104207:	83 ec 0c             	sub    $0xc,%esp
8010420a:	68 4e 80 10 80       	push   $0x8010804e
8010420f:	e8 7c c1 ff ff       	call   80100390 <panic>
        panic("sched locks");
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	68 42 80 10 80       	push   $0x80108042
8010421c:	e8 6f c1 ff ff       	call   80100390 <panic>
80104221:	eb 0d                	jmp    80104230 <exit>
80104223:	90                   	nop
80104224:	90                   	nop
80104225:	90                   	nop
80104226:	90                   	nop
80104227:	90                   	nop
80104228:	90                   	nop
80104229:	90                   	nop
8010422a:	90                   	nop
8010422b:	90                   	nop
8010422c:	90                   	nop
8010422d:	90                   	nop
8010422e:	90                   	nop
8010422f:	90                   	nop

80104230 <exit>:
exit(void) {
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	57                   	push   %edi
80104234:	56                   	push   %esi
80104235:	53                   	push   %ebx
80104236:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104239:	e8 72 07 00 00       	call   801049b0 <pushcli>
    c = mycpu();
8010423e:	e8 7d f9 ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
80104243:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104249:	e8 62 08 00 00       	call   80104ab0 <popcli>
    if (curproc == initproc)
8010424e:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80104254:	8d 73 28             	lea    0x28(%ebx),%esi
80104257:	8d 7b 68             	lea    0x68(%ebx),%edi
8010425a:	0f 84 11 01 00 00    	je     80104371 <exit+0x141>
        if (curproc->ofile[fd]) {
80104260:	8b 06                	mov    (%esi),%eax
80104262:	85 c0                	test   %eax,%eax
80104264:	74 12                	je     80104278 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104266:	83 ec 0c             	sub    $0xc,%esp
80104269:	50                   	push   %eax
8010426a:	e8 01 cc ff ff       	call   80100e70 <fileclose>
            curproc->ofile[fd] = 0;
8010426f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104275:	83 c4 10             	add    $0x10,%esp
80104278:	83 c6 04             	add    $0x4,%esi
    for (fd = 0; fd < NOFILE; fd++) {
8010427b:	39 fe                	cmp    %edi,%esi
8010427d:	75 e1                	jne    80104260 <exit+0x30>
    begin_op();
8010427f:	e8 ec ec ff ff       	call   80102f70 <begin_op>
    iput(curproc->cwd);
80104284:	83 ec 0c             	sub    $0xc,%esp
80104287:	ff 73 68             	pushl  0x68(%ebx)
8010428a:	e8 61 d5 ff ff       	call   801017f0 <iput>
    end_op();
8010428f:	e8 4c ed ff ff       	call   80102fe0 <end_op>
    if (curproc->swapFile)
80104294:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104297:	83 c4 10             	add    $0x10,%esp
    curproc->cwd = 0;
8010429a:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
    if (curproc->swapFile)
801042a1:	85 c0                	test   %eax,%eax
801042a3:	74 0c                	je     801042b1 <exit+0x81>
        removeSwapFile(curproc);
801042a5:	83 ec 0c             	sub    $0xc,%esp
801042a8:	53                   	push   %ebx
801042a9:	e8 42 dd ff ff       	call   80101ff0 <removeSwapFile>
801042ae:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
801042b1:	83 ec 0c             	sub    $0xc,%esp
801042b4:	68 20 4d 11 80       	push   $0x80114d20
801042b9:	e8 32 07 00 00       	call   801049f0 <acquire>
    wakeup1(curproc->parent);
801042be:	8b 53 14             	mov    0x14(%ebx),%edx
801042c1:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042c4:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
801042c9:	eb 11                	jmp    801042dc <exit+0xac>
801042cb:	90                   	nop
801042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d0:	05 50 04 00 00       	add    $0x450,%eax
801042d5:	3d 54 61 12 80       	cmp    $0x80126154,%eax
801042da:	73 1e                	jae    801042fa <exit+0xca>
        if (p->state == SLEEPING && p->chan == chan)
801042dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042e0:	75 ee                	jne    801042d0 <exit+0xa0>
801042e2:	3b 50 20             	cmp    0x20(%eax),%edx
801042e5:	75 e9                	jne    801042d0 <exit+0xa0>
            p->state = RUNNABLE;
801042e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ee:	05 50 04 00 00       	add    $0x450,%eax
801042f3:	3d 54 61 12 80       	cmp    $0x80126154,%eax
801042f8:	72 e2                	jb     801042dc <exit+0xac>
            p->parent = initproc;
801042fa:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104300:	ba 54 4d 11 80       	mov    $0x80114d54,%edx
80104305:	eb 17                	jmp    8010431e <exit+0xee>
80104307:	89 f6                	mov    %esi,%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104310:	81 c2 50 04 00 00    	add    $0x450,%edx
80104316:	81 fa 54 61 12 80    	cmp    $0x80126154,%edx
8010431c:	73 3a                	jae    80104358 <exit+0x128>
        if (p->parent == curproc) {
8010431e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104321:	75 ed                	jne    80104310 <exit+0xe0>
            if (p->state == ZOMBIE)
80104323:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104327:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010432a:	75 e4                	jne    80104310 <exit+0xe0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010432c:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
80104331:	eb 11                	jmp    80104344 <exit+0x114>
80104333:	90                   	nop
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104338:	05 50 04 00 00       	add    $0x450,%eax
8010433d:	3d 54 61 12 80       	cmp    $0x80126154,%eax
80104342:	73 cc                	jae    80104310 <exit+0xe0>
        if (p->state == SLEEPING && p->chan == chan)
80104344:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104348:	75 ee                	jne    80104338 <exit+0x108>
8010434a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010434d:	75 e9                	jne    80104338 <exit+0x108>
            p->state = RUNNABLE;
8010434f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104356:	eb e0                	jmp    80104338 <exit+0x108>
    curproc->state = ZOMBIE;
80104358:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
    sched();
8010435f:	e8 0c fe ff ff       	call   80104170 <sched>
    panic("zombie exit");
80104364:	83 ec 0c             	sub    $0xc,%esp
80104367:	68 7d 80 10 80       	push   $0x8010807d
8010436c:	e8 1f c0 ff ff       	call   80100390 <panic>
        panic("init exiting");
80104371:	83 ec 0c             	sub    $0xc,%esp
80104374:	68 70 80 10 80       	push   $0x80108070
80104379:	e8 12 c0 ff ff       	call   80100390 <panic>
8010437e:	66 90                	xchg   %ax,%ax

80104380 <yield>:
yield(void) {
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104387:	68 20 4d 11 80       	push   $0x80114d20
8010438c:	e8 5f 06 00 00       	call   801049f0 <acquire>
    pushcli();
80104391:	e8 1a 06 00 00       	call   801049b0 <pushcli>
    c = mycpu();
80104396:	e8 25 f8 ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
8010439b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801043a1:	e8 0a 07 00 00       	call   80104ab0 <popcli>
    myproc()->state = RUNNABLE;
801043a6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
801043ad:	e8 be fd ff ff       	call   80104170 <sched>
    release(&ptable.lock);
801043b2:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
801043b9:	e8 52 07 00 00       	call   80104b10 <release>
}
801043be:	83 c4 10             	add    $0x10,%esp
801043c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043c4:	c9                   	leave  
801043c5:	c3                   	ret    
801043c6:	8d 76 00             	lea    0x0(%esi),%esi
801043c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043d0 <sleep>:
sleep(void *chan, struct spinlock *lk) {
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	57                   	push   %edi
801043d4:	56                   	push   %esi
801043d5:	53                   	push   %ebx
801043d6:	83 ec 0c             	sub    $0xc,%esp
801043d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043dc:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
801043df:	e8 cc 05 00 00       	call   801049b0 <pushcli>
    c = mycpu();
801043e4:	e8 d7 f7 ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
801043e9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801043ef:	e8 bc 06 00 00       	call   80104ab0 <popcli>
    if (p == 0)
801043f4:	85 db                	test   %ebx,%ebx
801043f6:	0f 84 87 00 00 00    	je     80104483 <sleep+0xb3>
    if (lk == 0)
801043fc:	85 f6                	test   %esi,%esi
801043fe:	74 76                	je     80104476 <sleep+0xa6>
    if (lk != &ptable.lock) {  //DOC: sleeplock0
80104400:	81 fe 20 4d 11 80    	cmp    $0x80114d20,%esi
80104406:	74 50                	je     80104458 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	68 20 4d 11 80       	push   $0x80114d20
80104410:	e8 db 05 00 00       	call   801049f0 <acquire>
        release(lk);
80104415:	89 34 24             	mov    %esi,(%esp)
80104418:	e8 f3 06 00 00       	call   80104b10 <release>
    p->chan = chan;
8010441d:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104420:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104427:	e8 44 fd ff ff       	call   80104170 <sched>
    p->chan = 0;
8010442c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80104433:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
8010443a:	e8 d1 06 00 00       	call   80104b10 <release>
        acquire(lk);
8010443f:	89 75 08             	mov    %esi,0x8(%ebp)
80104442:	83 c4 10             	add    $0x10,%esp
}
80104445:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104448:	5b                   	pop    %ebx
80104449:	5e                   	pop    %esi
8010444a:	5f                   	pop    %edi
8010444b:	5d                   	pop    %ebp
        acquire(lk);
8010444c:	e9 9f 05 00 00       	jmp    801049f0 <acquire>
80104451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104458:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010445b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104462:	e8 09 fd ff ff       	call   80104170 <sched>
    p->chan = 0;
80104467:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010446e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104471:	5b                   	pop    %ebx
80104472:	5e                   	pop    %esi
80104473:	5f                   	pop    %edi
80104474:	5d                   	pop    %ebp
80104475:	c3                   	ret    
        panic("sleep without lk");
80104476:	83 ec 0c             	sub    $0xc,%esp
80104479:	68 8f 80 10 80       	push   $0x8010808f
8010447e:	e8 0d bf ff ff       	call   80100390 <panic>
        panic("sleep");
80104483:	83 ec 0c             	sub    $0xc,%esp
80104486:	68 89 80 10 80       	push   $0x80108089
8010448b:	e8 00 bf ff ff       	call   80100390 <panic>

80104490 <wait>:
wait(void) {
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	53                   	push   %ebx
80104496:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104499:	e8 12 05 00 00       	call   801049b0 <pushcli>
    c = mycpu();
8010449e:	e8 1d f7 ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
801044a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801044a9:	e8 02 06 00 00       	call   80104ab0 <popcli>
    acquire(&ptable.lock);
801044ae:	83 ec 0c             	sub    $0xc,%esp
801044b1:	68 20 4d 11 80       	push   $0x80114d20
801044b6:	e8 35 05 00 00       	call   801049f0 <acquire>
801044bb:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
801044be:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044c0:	bb 54 4d 11 80       	mov    $0x80114d54,%ebx
801044c5:	eb 17                	jmp    801044de <wait+0x4e>
801044c7:	89 f6                	mov    %esi,%esi
801044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801044d0:	81 c3 50 04 00 00    	add    $0x450,%ebx
801044d6:	81 fb 54 61 12 80    	cmp    $0x80126154,%ebx
801044dc:	73 1e                	jae    801044fc <wait+0x6c>
            if (p->parent != curproc)
801044de:	39 73 14             	cmp    %esi,0x14(%ebx)
801044e1:	75 ed                	jne    801044d0 <wait+0x40>
            if (p->state == ZOMBIE) {
801044e3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044e7:	74 3f                	je     80104528 <wait+0x98>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044e9:	81 c3 50 04 00 00    	add    $0x450,%ebx
            havekids = 1;
801044ef:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044f4:	81 fb 54 61 12 80    	cmp    $0x80126154,%ebx
801044fa:	72 e2                	jb     801044de <wait+0x4e>
        if (!havekids || curproc->killed) {
801044fc:	85 c0                	test   %eax,%eax
801044fe:	0f 84 23 01 00 00    	je     80104627 <wait+0x197>
80104504:	8b 46 24             	mov    0x24(%esi),%eax
80104507:	85 c0                	test   %eax,%eax
80104509:	0f 85 18 01 00 00    	jne    80104627 <wait+0x197>
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010450f:	83 ec 08             	sub    $0x8,%esp
80104512:	68 20 4d 11 80       	push   $0x80114d20
80104517:	56                   	push   %esi
80104518:	e8 b3 fe ff ff       	call   801043d0 <sleep>
        havekids = 0;
8010451d:	83 c4 10             	add    $0x10,%esp
80104520:	eb 9c                	jmp    801044be <wait+0x2e>
80104522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                kfree(p->kstack);
80104528:	83 ec 0c             	sub    $0xc,%esp
                pid = p->pid;
8010452b:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
8010452e:	ff 73 08             	pushl  0x8(%ebx)
80104531:	8d bb 40 04 00 00    	lea    0x440(%ebx),%edi
80104537:	e8 a4 e1 ff ff       	call   801026e0 <kfree>
                p->kstack = 0;
8010453c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104543:	5a                   	pop    %edx
80104544:	ff 73 04             	pushl  0x4(%ebx)
80104547:	e8 f4 30 00 00       	call   80107640 <freevm>
8010454c:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
                p->pid = 0;
80104552:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104559:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104560:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
80104564:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
8010456b:	83 c4 10             	add    $0x10,%esp
                p->state = UNUSED;
8010456e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->pagesCounter = -1;
80104575:	c7 83 44 04 00 00 ff 	movl   $0xffffffff,0x444(%ebx)
8010457c:	ff ff ff 
8010457f:	89 ca                	mov    %ecx,%edx
                p->nextpageid = 0;
80104581:	c7 83 40 04 00 00 00 	movl   $0x0,0x440(%ebx)
80104588:	00 00 00 
                p->pagesequel = 0;
8010458b:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
80104592:	00 00 00 
                p->pagesinSwap = 0;
80104595:	89 c8                	mov    %ecx,%eax
80104597:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
8010459e:	00 00 00 
801045a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    p->swapFileEntries[k]=0;
801045a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801045ae:	83 c0 04             	add    $0x4,%eax
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
801045b1:	39 c7                	cmp    %eax,%edi
801045b3:	75 f3                	jne    801045a8 <wait+0x118>
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801045b5:	83 eb 80             	sub    $0xffffff80,%ebx
801045b8:	90                   	nop
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    pg->active = 0;
801045c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
                    pg->offset = 0;
801045c6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801045cd:	83 c3 1c             	add    $0x1c,%ebx
                    pg->pageid = 0;
801045d0:	c7 43 e8 00 00 00 00 	movl   $0x0,-0x18(%ebx)
                    pg->present = -1;
801045d7:	c7 43 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebx)
                    pg->sequel = -1;
801045de:	c7 43 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebx)
                    pg->physAdress = 0;
801045e5:	c7 43 f8 00 00 00 00 	movl   $0x0,-0x8(%ebx)
                    pg->virtAdress = 0;
801045ec:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801045f3:	39 cb                	cmp    %ecx,%ebx
801045f5:	72 c9                	jb     801045c0 <wait+0x130>
801045f7:	89 f6                	mov    %esi,%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    p->swapFileEntries[k]=0;
80104600:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
80104606:	83 c2 04             	add    $0x4,%edx
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
80104609:	39 d0                	cmp    %edx,%eax
8010460b:	75 f3                	jne    80104600 <wait+0x170>
                release(&ptable.lock);
8010460d:	83 ec 0c             	sub    $0xc,%esp
80104610:	68 20 4d 11 80       	push   $0x80114d20
80104615:	e8 f6 04 00 00       	call   80104b10 <release>
                return pid;
8010461a:	83 c4 10             	add    $0x10,%esp
}
8010461d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104620:	89 f0                	mov    %esi,%eax
80104622:	5b                   	pop    %ebx
80104623:	5e                   	pop    %esi
80104624:	5f                   	pop    %edi
80104625:	5d                   	pop    %ebp
80104626:	c3                   	ret    
            release(&ptable.lock);
80104627:	83 ec 0c             	sub    $0xc,%esp
            return -1;
8010462a:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
8010462f:	68 20 4d 11 80       	push   $0x80114d20
80104634:	e8 d7 04 00 00       	call   80104b10 <release>
            return -1;
80104639:	83 c4 10             	add    $0x10,%esp
8010463c:	eb df                	jmp    8010461d <wait+0x18d>
8010463e:	66 90                	xchg   %ax,%ax

80104640 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	53                   	push   %ebx
80104644:	83 ec 10             	sub    $0x10,%esp
80104647:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010464a:	68 20 4d 11 80       	push   $0x80114d20
8010464f:	e8 9c 03 00 00       	call   801049f0 <acquire>
80104654:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104657:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
8010465c:	eb 0e                	jmp    8010466c <wakeup+0x2c>
8010465e:	66 90                	xchg   %ax,%ax
80104660:	05 50 04 00 00       	add    $0x450,%eax
80104665:	3d 54 61 12 80       	cmp    $0x80126154,%eax
8010466a:	73 1e                	jae    8010468a <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan)
8010466c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104670:	75 ee                	jne    80104660 <wakeup+0x20>
80104672:	3b 58 20             	cmp    0x20(%eax),%ebx
80104675:	75 e9                	jne    80104660 <wakeup+0x20>
            p->state = RUNNABLE;
80104677:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010467e:	05 50 04 00 00       	add    $0x450,%eax
80104683:	3d 54 61 12 80       	cmp    $0x80126154,%eax
80104688:	72 e2                	jb     8010466c <wakeup+0x2c>
    wakeup1(chan);
    release(&ptable.lock);
8010468a:	c7 45 08 20 4d 11 80 	movl   $0x80114d20,0x8(%ebp)
}
80104691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104694:	c9                   	leave  
    release(&ptable.lock);
80104695:	e9 76 04 00 00       	jmp    80104b10 <release>
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046a0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 10             	sub    $0x10,%esp
801046a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
801046aa:	68 20 4d 11 80       	push   $0x80114d20
801046af:	e8 3c 03 00 00       	call   801049f0 <acquire>
801046b4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801046b7:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
801046bc:	eb 0e                	jmp    801046cc <kill+0x2c>
801046be:	66 90                	xchg   %ax,%ax
801046c0:	05 50 04 00 00       	add    $0x450,%eax
801046c5:	3d 54 61 12 80       	cmp    $0x80126154,%eax
801046ca:	73 34                	jae    80104700 <kill+0x60>
        if (p->pid == pid) {
801046cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801046cf:	75 ef                	jne    801046c0 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
801046d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
801046d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
801046dc:	75 07                	jne    801046e5 <kill+0x45>
                p->state = RUNNABLE;
801046de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
801046e5:	83 ec 0c             	sub    $0xc,%esp
801046e8:	68 20 4d 11 80       	push   $0x80114d20
801046ed:	e8 1e 04 00 00       	call   80104b10 <release>
            return 0;
801046f2:	83 c4 10             	add    $0x10,%esp
801046f5:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801046f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046fa:	c9                   	leave  
801046fb:	c3                   	ret    
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80104700:	83 ec 0c             	sub    $0xc,%esp
80104703:	68 20 4d 11 80       	push   $0x80114d20
80104708:	e8 03 04 00 00       	call   80104b10 <release>
    return -1;
8010470d:	83 c4 10             	add    $0x10,%esp
80104710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104718:	c9                   	leave  
80104719:	c3                   	ret    
8010471a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104720 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	57                   	push   %edi
80104724:	56                   	push   %esi
80104725:	53                   	push   %ebx
80104726:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104729:	bb 54 4d 11 80       	mov    $0x80114d54,%ebx
procdump(void) {
8010472e:	83 ec 3c             	sub    $0x3c,%esp
80104731:	eb 27                	jmp    8010475a <procdump+0x3a>
80104733:	90                   	nop
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	68 7b 84 10 80       	push   $0x8010847b
80104740:	e8 1b bf ff ff       	call   80100660 <cprintf>
80104745:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104748:	81 c3 50 04 00 00    	add    $0x450,%ebx
8010474e:	81 fb 54 61 12 80    	cmp    $0x80126154,%ebx
80104754:	0f 83 86 00 00 00    	jae    801047e0 <procdump+0xc0>
        if (p->state == UNUSED)
8010475a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010475d:	85 c0                	test   %eax,%eax
8010475f:	74 e7                	je     80104748 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104761:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104764:	ba a0 80 10 80       	mov    $0x801080a0,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104769:	77 11                	ja     8010477c <procdump+0x5c>
8010476b:	8b 14 85 00 81 10 80 	mov    -0x7fef7f00(,%eax,4),%edx
            state = "???";
80104772:	b8 a0 80 10 80       	mov    $0x801080a0,%eax
80104777:	85 d2                	test   %edx,%edx
80104779:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
8010477c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010477f:	50                   	push   %eax
80104780:	52                   	push   %edx
80104781:	ff 73 10             	pushl  0x10(%ebx)
80104784:	68 a4 80 10 80       	push   $0x801080a4
80104789:	e8 d2 be ff ff       	call   80100660 <cprintf>
        if (p->state == SLEEPING) {
8010478e:	83 c4 10             	add    $0x10,%esp
80104791:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104795:	75 a1                	jne    80104738 <procdump+0x18>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
80104797:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010479a:	83 ec 08             	sub    $0x8,%esp
8010479d:	8d 7d c0             	lea    -0x40(%ebp),%edi
801047a0:	50                   	push   %eax
801047a1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801047a4:	8b 40 0c             	mov    0xc(%eax),%eax
801047a7:	83 c0 08             	add    $0x8,%eax
801047aa:	50                   	push   %eax
801047ab:	e8 70 01 00 00       	call   80104920 <getcallerpcs>
801047b0:	83 c4 10             	add    $0x10,%esp
801047b3:	90                   	nop
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
801047b8:	8b 17                	mov    (%edi),%edx
801047ba:	85 d2                	test   %edx,%edx
801047bc:	0f 84 76 ff ff ff    	je     80104738 <procdump+0x18>
                cprintf(" %p", pc[i]);
801047c2:	83 ec 08             	sub    $0x8,%esp
801047c5:	83 c7 04             	add    $0x4,%edi
801047c8:	52                   	push   %edx
801047c9:	68 a1 7a 10 80       	push   $0x80107aa1
801047ce:	e8 8d be ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801047d3:	83 c4 10             	add    $0x10,%esp
801047d6:	39 fe                	cmp    %edi,%esi
801047d8:	75 de                	jne    801047b8 <procdump+0x98>
801047da:	e9 59 ff ff ff       	jmp    80104738 <procdump+0x18>
801047df:	90                   	nop
    }
}
801047e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047e3:	5b                   	pop    %ebx
801047e4:	5e                   	pop    %esi
801047e5:	5f                   	pop    %edi
801047e6:	5d                   	pop    %ebp
801047e7:	c3                   	ret    
801047e8:	66 90                	xchg   %ax,%ax
801047ea:	66 90                	xchg   %ax,%ax
801047ec:	66 90                	xchg   %ax,%ax
801047ee:	66 90                	xchg   %ax,%ax

801047f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 0c             	sub    $0xc,%esp
801047f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801047fa:	68 18 81 10 80       	push   $0x80108118
801047ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104802:	50                   	push   %eax
80104803:	e8 f8 00 00 00       	call   80104900 <initlock>
  lk->name = name;
80104808:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010480b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104811:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104814:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010481b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010481e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104821:	c9                   	leave  
80104822:	c3                   	ret    
80104823:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104838:	83 ec 0c             	sub    $0xc,%esp
8010483b:	8d 73 04             	lea    0x4(%ebx),%esi
8010483e:	56                   	push   %esi
8010483f:	e8 ac 01 00 00       	call   801049f0 <acquire>
  while (lk->locked) {
80104844:	8b 13                	mov    (%ebx),%edx
80104846:	83 c4 10             	add    $0x10,%esp
80104849:	85 d2                	test   %edx,%edx
8010484b:	74 16                	je     80104863 <acquiresleep+0x33>
8010484d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104850:	83 ec 08             	sub    $0x8,%esp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	e8 76 fb ff ff       	call   801043d0 <sleep>
  while (lk->locked) {
8010485a:	8b 03                	mov    (%ebx),%eax
8010485c:	83 c4 10             	add    $0x10,%esp
8010485f:	85 c0                	test   %eax,%eax
80104861:	75 ed                	jne    80104850 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104863:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104869:	e8 f2 f3 ff ff       	call   80103c60 <myproc>
8010486e:	8b 40 10             	mov    0x10(%eax),%eax
80104871:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104874:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104877:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010487a:	5b                   	pop    %ebx
8010487b:	5e                   	pop    %esi
8010487c:	5d                   	pop    %ebp
  release(&lk->lk);
8010487d:	e9 8e 02 00 00       	jmp    80104b10 <release>
80104882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104898:	83 ec 0c             	sub    $0xc,%esp
8010489b:	8d 73 04             	lea    0x4(%ebx),%esi
8010489e:	56                   	push   %esi
8010489f:	e8 4c 01 00 00       	call   801049f0 <acquire>
  lk->locked = 0;
801048a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801048aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801048b1:	89 1c 24             	mov    %ebx,(%esp)
801048b4:	e8 87 fd ff ff       	call   80104640 <wakeup>
  release(&lk->lk);
801048b9:	89 75 08             	mov    %esi,0x8(%ebp)
801048bc:	83 c4 10             	add    $0x10,%esp
}
801048bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048c2:	5b                   	pop    %ebx
801048c3:	5e                   	pop    %esi
801048c4:	5d                   	pop    %ebp
  release(&lk->lk);
801048c5:	e9 46 02 00 00       	jmp    80104b10 <release>
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
801048d5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801048d8:	83 ec 0c             	sub    $0xc,%esp
801048db:	8d 5e 04             	lea    0x4(%esi),%ebx
801048de:	53                   	push   %ebx
801048df:	e8 0c 01 00 00       	call   801049f0 <acquire>
  r = lk->locked;
801048e4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801048e6:	89 1c 24             	mov    %ebx,(%esp)
801048e9:	e8 22 02 00 00       	call   80104b10 <release>
  return r;
}
801048ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048f1:	89 f0                	mov    %esi,%eax
801048f3:	5b                   	pop    %ebx
801048f4:	5e                   	pop    %esi
801048f5:	5d                   	pop    %ebp
801048f6:	c3                   	ret    
801048f7:	66 90                	xchg   %ax,%ax
801048f9:	66 90                	xchg   %ax,%ax
801048fb:	66 90                	xchg   %ax,%ax
801048fd:	66 90                	xchg   %ax,%ax
801048ff:	90                   	nop

80104900 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104906:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104909:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010490f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104912:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104919:	5d                   	pop    %ebp
8010491a:	c3                   	ret    
8010491b:	90                   	nop
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104920 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104920:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104921:	31 d2                	xor    %edx,%edx
{
80104923:	89 e5                	mov    %esp,%ebp
80104925:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104926:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104929:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010492c:	83 e8 08             	sub    $0x8,%eax
8010492f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104930:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104936:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010493c:	77 1a                	ja     80104958 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010493e:	8b 58 04             	mov    0x4(%eax),%ebx
80104941:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104944:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104947:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104949:	83 fa 0a             	cmp    $0xa,%edx
8010494c:	75 e2                	jne    80104930 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010494e:	5b                   	pop    %ebx
8010494f:	5d                   	pop    %ebp
80104950:	c3                   	ret    
80104951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104958:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010495b:	83 c1 28             	add    $0x28,%ecx
8010495e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104960:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104966:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104969:	39 c1                	cmp    %eax,%ecx
8010496b:	75 f3                	jne    80104960 <getcallerpcs+0x40>
}
8010496d:	5b                   	pop    %ebx
8010496e:	5d                   	pop    %ebp
8010496f:	c3                   	ret    

80104970 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 04             	sub    $0x4,%esp
80104977:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010497a:	8b 02                	mov    (%edx),%eax
8010497c:	85 c0                	test   %eax,%eax
8010497e:	75 10                	jne    80104990 <holding+0x20>
}
80104980:	83 c4 04             	add    $0x4,%esp
80104983:	31 c0                	xor    %eax,%eax
80104985:	5b                   	pop    %ebx
80104986:	5d                   	pop    %ebp
80104987:	c3                   	ret    
80104988:	90                   	nop
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104990:	8b 5a 08             	mov    0x8(%edx),%ebx
80104993:	e8 28 f2 ff ff       	call   80103bc0 <mycpu>
80104998:	39 c3                	cmp    %eax,%ebx
8010499a:	0f 94 c0             	sete   %al
}
8010499d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
801049a0:	0f b6 c0             	movzbl %al,%eax
}
801049a3:	5b                   	pop    %ebx
801049a4:	5d                   	pop    %ebp
801049a5:	c3                   	ret    
801049a6:	8d 76 00             	lea    0x0(%esi),%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	53                   	push   %ebx
801049b4:	83 ec 04             	sub    $0x4,%esp
801049b7:	9c                   	pushf  
801049b8:	5b                   	pop    %ebx
  asm volatile("cli");
801049b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801049ba:	e8 01 f2 ff ff       	call   80103bc0 <mycpu>
801049bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049c5:	85 c0                	test   %eax,%eax
801049c7:	75 11                	jne    801049da <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801049c9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801049cf:	e8 ec f1 ff ff       	call   80103bc0 <mycpu>
801049d4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801049da:	e8 e1 f1 ff ff       	call   80103bc0 <mycpu>
801049df:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049e6:	83 c4 04             	add    $0x4,%esp
801049e9:	5b                   	pop    %ebx
801049ea:	5d                   	pop    %ebp
801049eb:	c3                   	ret    
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049f0 <acquire>:
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801049f5:	e8 b6 ff ff ff       	call   801049b0 <pushcli>
  if(holding(lk))
801049fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801049fd:	8b 03                	mov    (%ebx),%eax
801049ff:	85 c0                	test   %eax,%eax
80104a01:	0f 85 81 00 00 00    	jne    80104a88 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104a07:	ba 01 00 00 00       	mov    $0x1,%edx
80104a0c:	eb 05                	jmp    80104a13 <acquire+0x23>
80104a0e:	66 90                	xchg   %ax,%ax
80104a10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a13:	89 d0                	mov    %edx,%eax
80104a15:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104a18:	85 c0                	test   %eax,%eax
80104a1a:	75 f4                	jne    80104a10 <acquire+0x20>
  __sync_synchronize();
80104a1c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104a21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a24:	e8 97 f1 ff ff       	call   80103bc0 <mycpu>
  for(i = 0; i < 10; i++){
80104a29:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
80104a2b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
80104a2e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104a31:	89 e8                	mov    %ebp,%eax
80104a33:	90                   	nop
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a38:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a3e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a44:	77 1a                	ja     80104a60 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104a46:	8b 58 04             	mov    0x4(%eax),%ebx
80104a49:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a4c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a4f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a51:	83 fa 0a             	cmp    $0xa,%edx
80104a54:	75 e2                	jne    80104a38 <acquire+0x48>
}
80104a56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a59:	5b                   	pop    %ebx
80104a5a:	5e                   	pop    %esi
80104a5b:	5d                   	pop    %ebp
80104a5c:	c3                   	ret    
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
80104a60:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a63:	83 c1 28             	add    $0x28,%ecx
80104a66:	8d 76 00             	lea    0x0(%esi),%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a76:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a79:	39 c8                	cmp    %ecx,%eax
80104a7b:	75 f3                	jne    80104a70 <acquire+0x80>
}
80104a7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a80:	5b                   	pop    %ebx
80104a81:	5e                   	pop    %esi
80104a82:	5d                   	pop    %ebp
80104a83:	c3                   	ret    
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104a88:	8b 73 08             	mov    0x8(%ebx),%esi
80104a8b:	e8 30 f1 ff ff       	call   80103bc0 <mycpu>
80104a90:	39 c6                	cmp    %eax,%esi
80104a92:	0f 85 6f ff ff ff    	jne    80104a07 <acquire+0x17>
    panic("acquire");
80104a98:	83 ec 0c             	sub    $0xc,%esp
80104a9b:	68 23 81 10 80       	push   $0x80108123
80104aa0:	e8 eb b8 ff ff       	call   80100390 <panic>
80104aa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ab0 <popcli>:

void
popcli(void)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ab6:	9c                   	pushf  
80104ab7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ab8:	f6 c4 02             	test   $0x2,%ah
80104abb:	75 35                	jne    80104af2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104abd:	e8 fe f0 ff ff       	call   80103bc0 <mycpu>
80104ac2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104ac9:	78 34                	js     80104aff <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104acb:	e8 f0 f0 ff ff       	call   80103bc0 <mycpu>
80104ad0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ad6:	85 d2                	test   %edx,%edx
80104ad8:	74 06                	je     80104ae0 <popcli+0x30>
    sti();
}
80104ada:	c9                   	leave  
80104adb:	c3                   	ret    
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ae0:	e8 db f0 ff ff       	call   80103bc0 <mycpu>
80104ae5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104aeb:	85 c0                	test   %eax,%eax
80104aed:	74 eb                	je     80104ada <popcli+0x2a>
  asm volatile("sti");
80104aef:	fb                   	sti    
}
80104af0:	c9                   	leave  
80104af1:	c3                   	ret    
    panic("popcli - interruptible");
80104af2:	83 ec 0c             	sub    $0xc,%esp
80104af5:	68 2b 81 10 80       	push   $0x8010812b
80104afa:	e8 91 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104aff:	83 ec 0c             	sub    $0xc,%esp
80104b02:	68 42 81 10 80       	push   $0x80108142
80104b07:	e8 84 b8 ff ff       	call   80100390 <panic>
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b10 <release>:
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
80104b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104b18:	8b 03                	mov    (%ebx),%eax
80104b1a:	85 c0                	test   %eax,%eax
80104b1c:	74 0c                	je     80104b2a <release+0x1a>
80104b1e:	8b 73 08             	mov    0x8(%ebx),%esi
80104b21:	e8 9a f0 ff ff       	call   80103bc0 <mycpu>
80104b26:	39 c6                	cmp    %eax,%esi
80104b28:	74 16                	je     80104b40 <release+0x30>
    panic("release");
80104b2a:	83 ec 0c             	sub    $0xc,%esp
80104b2d:	68 49 81 10 80       	push   $0x80108149
80104b32:	e8 59 b8 ff ff       	call   80100390 <panic>
80104b37:	89 f6                	mov    %esi,%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104b40:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b47:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b4e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b53:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b59:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b5c:	5b                   	pop    %ebx
80104b5d:	5e                   	pop    %esi
80104b5e:	5d                   	pop    %ebp
  popcli();
80104b5f:	e9 4c ff ff ff       	jmp    80104ab0 <popcli>
80104b64:	66 90                	xchg   %ax,%ax
80104b66:	66 90                	xchg   %ax,%ax
80104b68:	66 90                	xchg   %ax,%ax
80104b6a:	66 90                	xchg   %ax,%ax
80104b6c:	66 90                	xchg   %ax,%ax
80104b6e:	66 90                	xchg   %ax,%ax

80104b70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	53                   	push   %ebx
80104b75:	8b 55 08             	mov    0x8(%ebp),%edx
80104b78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b7b:	f6 c2 03             	test   $0x3,%dl
80104b7e:	75 05                	jne    80104b85 <memset+0x15>
80104b80:	f6 c1 03             	test   $0x3,%cl
80104b83:	74 13                	je     80104b98 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104b85:	89 d7                	mov    %edx,%edi
80104b87:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b8a:	fc                   	cld    
80104b8b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b8d:	5b                   	pop    %ebx
80104b8e:	89 d0                	mov    %edx,%eax
80104b90:	5f                   	pop    %edi
80104b91:	5d                   	pop    %ebp
80104b92:	c3                   	ret    
80104b93:	90                   	nop
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104b98:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b9c:	c1 e9 02             	shr    $0x2,%ecx
80104b9f:	89 f8                	mov    %edi,%eax
80104ba1:	89 fb                	mov    %edi,%ebx
80104ba3:	c1 e0 18             	shl    $0x18,%eax
80104ba6:	c1 e3 10             	shl    $0x10,%ebx
80104ba9:	09 d8                	or     %ebx,%eax
80104bab:	09 f8                	or     %edi,%eax
80104bad:	c1 e7 08             	shl    $0x8,%edi
80104bb0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104bb2:	89 d7                	mov    %edx,%edi
80104bb4:	fc                   	cld    
80104bb5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104bb7:	5b                   	pop    %ebx
80104bb8:	89 d0                	mov    %edx,%eax
80104bba:	5f                   	pop    %edi
80104bbb:	5d                   	pop    %ebp
80104bbc:	c3                   	ret    
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi

80104bc0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
80104bc5:	53                   	push   %ebx
80104bc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104bc9:	8b 75 08             	mov    0x8(%ebp),%esi
80104bcc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bcf:	85 db                	test   %ebx,%ebx
80104bd1:	74 29                	je     80104bfc <memcmp+0x3c>
    if(*s1 != *s2)
80104bd3:	0f b6 16             	movzbl (%esi),%edx
80104bd6:	0f b6 0f             	movzbl (%edi),%ecx
80104bd9:	38 d1                	cmp    %dl,%cl
80104bdb:	75 2b                	jne    80104c08 <memcmp+0x48>
80104bdd:	b8 01 00 00 00       	mov    $0x1,%eax
80104be2:	eb 14                	jmp    80104bf8 <memcmp+0x38>
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104be8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104bec:	83 c0 01             	add    $0x1,%eax
80104bef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104bf4:	38 ca                	cmp    %cl,%dl
80104bf6:	75 10                	jne    80104c08 <memcmp+0x48>
  while(n-- > 0){
80104bf8:	39 d8                	cmp    %ebx,%eax
80104bfa:	75 ec                	jne    80104be8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104bfc:	5b                   	pop    %ebx
  return 0;
80104bfd:	31 c0                	xor    %eax,%eax
}
80104bff:	5e                   	pop    %esi
80104c00:	5f                   	pop    %edi
80104c01:	5d                   	pop    %ebp
80104c02:	c3                   	ret    
80104c03:	90                   	nop
80104c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104c08:	0f b6 c2             	movzbl %dl,%eax
}
80104c0b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104c0c:	29 c8                	sub    %ecx,%eax
}
80104c0e:	5e                   	pop    %esi
80104c0f:	5f                   	pop    %edi
80104c10:	5d                   	pop    %ebp
80104c11:	c3                   	ret    
80104c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	8b 45 08             	mov    0x8(%ebp),%eax
80104c28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c2b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c2e:	39 c3                	cmp    %eax,%ebx
80104c30:	73 26                	jae    80104c58 <memmove+0x38>
80104c32:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104c35:	39 c8                	cmp    %ecx,%eax
80104c37:	73 1f                	jae    80104c58 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104c39:	85 f6                	test   %esi,%esi
80104c3b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104c3e:	74 0f                	je     80104c4f <memmove+0x2f>
      *--d = *--s;
80104c40:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104c47:	83 ea 01             	sub    $0x1,%edx
80104c4a:	83 fa ff             	cmp    $0xffffffff,%edx
80104c4d:	75 f1                	jne    80104c40 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c4f:	5b                   	pop    %ebx
80104c50:	5e                   	pop    %esi
80104c51:	5d                   	pop    %ebp
80104c52:	c3                   	ret    
80104c53:	90                   	nop
80104c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104c58:	31 d2                	xor    %edx,%edx
80104c5a:	85 f6                	test   %esi,%esi
80104c5c:	74 f1                	je     80104c4f <memmove+0x2f>
80104c5e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104c60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104c67:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104c6a:	39 d6                	cmp    %edx,%esi
80104c6c:	75 f2                	jne    80104c60 <memmove+0x40>
}
80104c6e:	5b                   	pop    %ebx
80104c6f:	5e                   	pop    %esi
80104c70:	5d                   	pop    %ebp
80104c71:	c3                   	ret    
80104c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104c83:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104c84:	eb 9a                	jmp    80104c20 <memmove>
80104c86:	8d 76 00             	lea    0x0(%esi),%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
80104c95:	8b 7d 10             	mov    0x10(%ebp),%edi
80104c98:	53                   	push   %ebx
80104c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104c9f:	85 ff                	test   %edi,%edi
80104ca1:	74 2f                	je     80104cd2 <strncmp+0x42>
80104ca3:	0f b6 01             	movzbl (%ecx),%eax
80104ca6:	0f b6 1e             	movzbl (%esi),%ebx
80104ca9:	84 c0                	test   %al,%al
80104cab:	74 37                	je     80104ce4 <strncmp+0x54>
80104cad:	38 c3                	cmp    %al,%bl
80104caf:	75 33                	jne    80104ce4 <strncmp+0x54>
80104cb1:	01 f7                	add    %esi,%edi
80104cb3:	eb 13                	jmp    80104cc8 <strncmp+0x38>
80104cb5:	8d 76 00             	lea    0x0(%esi),%esi
80104cb8:	0f b6 01             	movzbl (%ecx),%eax
80104cbb:	84 c0                	test   %al,%al
80104cbd:	74 21                	je     80104ce0 <strncmp+0x50>
80104cbf:	0f b6 1a             	movzbl (%edx),%ebx
80104cc2:	89 d6                	mov    %edx,%esi
80104cc4:	38 d8                	cmp    %bl,%al
80104cc6:	75 1c                	jne    80104ce4 <strncmp+0x54>
    n--, p++, q++;
80104cc8:	8d 56 01             	lea    0x1(%esi),%edx
80104ccb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104cce:	39 fa                	cmp    %edi,%edx
80104cd0:	75 e6                	jne    80104cb8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104cd2:	5b                   	pop    %ebx
    return 0;
80104cd3:	31 c0                	xor    %eax,%eax
}
80104cd5:	5e                   	pop    %esi
80104cd6:	5f                   	pop    %edi
80104cd7:	5d                   	pop    %ebp
80104cd8:	c3                   	ret    
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ce0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104ce4:	29 d8                	sub    %ebx,%eax
}
80104ce6:	5b                   	pop    %ebx
80104ce7:	5e                   	pop    %esi
80104ce8:	5f                   	pop    %edi
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    
80104ceb:	90                   	nop
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cf0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	53                   	push   %ebx
80104cf5:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104cfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cfe:	89 c2                	mov    %eax,%edx
80104d00:	eb 19                	jmp    80104d1b <strncpy+0x2b>
80104d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d08:	83 c3 01             	add    $0x1,%ebx
80104d0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104d0f:	83 c2 01             	add    $0x1,%edx
80104d12:	84 c9                	test   %cl,%cl
80104d14:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d17:	74 09                	je     80104d22 <strncpy+0x32>
80104d19:	89 f1                	mov    %esi,%ecx
80104d1b:	85 c9                	test   %ecx,%ecx
80104d1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104d20:	7f e6                	jg     80104d08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d22:	31 c9                	xor    %ecx,%ecx
80104d24:	85 f6                	test   %esi,%esi
80104d26:	7e 17                	jle    80104d3f <strncpy+0x4f>
80104d28:	90                   	nop
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104d30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104d34:	89 f3                	mov    %esi,%ebx
80104d36:	83 c1 01             	add    $0x1,%ecx
80104d39:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104d3b:	85 db                	test   %ebx,%ebx
80104d3d:	7f f1                	jg     80104d30 <strncpy+0x40>
  return os;
}
80104d3f:	5b                   	pop    %ebx
80104d40:	5e                   	pop    %esi
80104d41:	5d                   	pop    %ebp
80104d42:	c3                   	ret    
80104d43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
80104d55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d58:	8b 45 08             	mov    0x8(%ebp),%eax
80104d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104d5e:	85 c9                	test   %ecx,%ecx
80104d60:	7e 26                	jle    80104d88 <safestrcpy+0x38>
80104d62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104d66:	89 c1                	mov    %eax,%ecx
80104d68:	eb 17                	jmp    80104d81 <safestrcpy+0x31>
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d70:	83 c2 01             	add    $0x1,%edx
80104d73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104d77:	83 c1 01             	add    $0x1,%ecx
80104d7a:	84 db                	test   %bl,%bl
80104d7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104d7f:	74 04                	je     80104d85 <safestrcpy+0x35>
80104d81:	39 f2                	cmp    %esi,%edx
80104d83:	75 eb                	jne    80104d70 <safestrcpy+0x20>
    ;
  *s = 0;
80104d85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104d88:	5b                   	pop    %ebx
80104d89:	5e                   	pop    %esi
80104d8a:	5d                   	pop    %ebp
80104d8b:	c3                   	ret    
80104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d90 <strlen>:

int
strlen(const char *s)
{
80104d90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d91:	31 c0                	xor    %eax,%eax
{
80104d93:	89 e5                	mov    %esp,%ebp
80104d95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d98:	80 3a 00             	cmpb   $0x0,(%edx)
80104d9b:	74 0c                	je     80104da9 <strlen+0x19>
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
80104da0:	83 c0 01             	add    $0x1,%eax
80104da3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104da7:	75 f7                	jne    80104da0 <strlen+0x10>
    ;
  return n;
}
80104da9:	5d                   	pop    %ebp
80104daa:	c3                   	ret    

80104dab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104dab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104daf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104db3:	55                   	push   %ebp
  pushl %ebx
80104db4:	53                   	push   %ebx
  pushl %esi
80104db5:	56                   	push   %esi
  pushl %edi
80104db6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104db7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104db9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104dbb:	5f                   	pop    %edi
  popl %esi
80104dbc:	5e                   	pop    %esi
  popl %ebx
80104dbd:	5b                   	pop    %ebx
  popl %ebp
80104dbe:	5d                   	pop    %ebp
  ret
80104dbf:	c3                   	ret    

80104dc0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	53                   	push   %ebx
80104dc4:	83 ec 04             	sub    $0x4,%esp
80104dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104dca:	e8 91 ee ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dcf:	8b 00                	mov    (%eax),%eax
80104dd1:	39 d8                	cmp    %ebx,%eax
80104dd3:	76 1b                	jbe    80104df0 <fetchint+0x30>
80104dd5:	8d 53 04             	lea    0x4(%ebx),%edx
80104dd8:	39 d0                	cmp    %edx,%eax
80104dda:	72 14                	jb     80104df0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ddf:	8b 13                	mov    (%ebx),%edx
80104de1:	89 10                	mov    %edx,(%eax)
  return 0;
80104de3:	31 c0                	xor    %eax,%eax
}
80104de5:	83 c4 04             	add    $0x4,%esp
80104de8:	5b                   	pop    %ebx
80104de9:	5d                   	pop    %ebp
80104dea:	c3                   	ret    
80104deb:	90                   	nop
80104dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104df5:	eb ee                	jmp    80104de5 <fetchint+0x25>
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	53                   	push   %ebx
80104e04:	83 ec 04             	sub    $0x4,%esp
80104e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104e0a:	e8 51 ee ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz)
80104e0f:	39 18                	cmp    %ebx,(%eax)
80104e11:	76 29                	jbe    80104e3c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104e16:	89 da                	mov    %ebx,%edx
80104e18:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104e1a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104e1c:	39 c3                	cmp    %eax,%ebx
80104e1e:	73 1c                	jae    80104e3c <fetchstr+0x3c>
    if(*s == 0)
80104e20:	80 3b 00             	cmpb   $0x0,(%ebx)
80104e23:	75 10                	jne    80104e35 <fetchstr+0x35>
80104e25:	eb 39                	jmp    80104e60 <fetchstr+0x60>
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e30:	80 3a 00             	cmpb   $0x0,(%edx)
80104e33:	74 1b                	je     80104e50 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104e35:	83 c2 01             	add    $0x1,%edx
80104e38:	39 d0                	cmp    %edx,%eax
80104e3a:	77 f4                	ja     80104e30 <fetchstr+0x30>
    return -1;
80104e3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104e41:	83 c4 04             	add    $0x4,%esp
80104e44:	5b                   	pop    %ebx
80104e45:	5d                   	pop    %ebp
80104e46:	c3                   	ret    
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e50:	83 c4 04             	add    $0x4,%esp
80104e53:	89 d0                	mov    %edx,%eax
80104e55:	29 d8                	sub    %ebx,%eax
80104e57:	5b                   	pop    %ebx
80104e58:	5d                   	pop    %ebp
80104e59:	c3                   	ret    
80104e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104e60:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104e62:	eb dd                	jmp    80104e41 <fetchstr+0x41>
80104e64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e75:	e8 e6 ed ff ff       	call   80103c60 <myproc>
80104e7a:	8b 40 18             	mov    0x18(%eax),%eax
80104e7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e80:	8b 40 44             	mov    0x44(%eax),%eax
80104e83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e86:	e8 d5 ed ff ff       	call   80103c60 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e8b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e8d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e90:	39 c6                	cmp    %eax,%esi
80104e92:	73 1c                	jae    80104eb0 <argint+0x40>
80104e94:	8d 53 08             	lea    0x8(%ebx),%edx
80104e97:	39 d0                	cmp    %edx,%eax
80104e99:	72 15                	jb     80104eb0 <argint+0x40>
  *ip = *(int*)(addr);
80104e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104ea1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ea3:	31 c0                	xor    %eax,%eax
}
80104ea5:	5b                   	pop    %ebx
80104ea6:	5e                   	pop    %esi
80104ea7:	5d                   	pop    %ebp
80104ea8:	c3                   	ret    
80104ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104eb5:	eb ee                	jmp    80104ea5 <argint+0x35>
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
80104ec5:	83 ec 10             	sub    $0x10,%esp
80104ec8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104ecb:	e8 90 ed ff ff       	call   80103c60 <myproc>
80104ed0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ed2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ed5:	83 ec 08             	sub    $0x8,%esp
80104ed8:	50                   	push   %eax
80104ed9:	ff 75 08             	pushl  0x8(%ebp)
80104edc:	e8 8f ff ff ff       	call   80104e70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ee1:	83 c4 10             	add    $0x10,%esp
80104ee4:	85 c0                	test   %eax,%eax
80104ee6:	78 28                	js     80104f10 <argptr+0x50>
80104ee8:	85 db                	test   %ebx,%ebx
80104eea:	78 24                	js     80104f10 <argptr+0x50>
80104eec:	8b 16                	mov    (%esi),%edx
80104eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef1:	39 c2                	cmp    %eax,%edx
80104ef3:	76 1b                	jbe    80104f10 <argptr+0x50>
80104ef5:	01 c3                	add    %eax,%ebx
80104ef7:	39 da                	cmp    %ebx,%edx
80104ef9:	72 15                	jb     80104f10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104efb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104efe:	89 02                	mov    %eax,(%edx)
  return 0;
80104f00:	31 c0                	xor    %eax,%eax
}
80104f02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f05:	5b                   	pop    %ebx
80104f06:	5e                   	pop    %esi
80104f07:	5d                   	pop    %ebp
80104f08:	c3                   	ret    
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f15:	eb eb                	jmp    80104f02 <argptr+0x42>
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f29:	50                   	push   %eax
80104f2a:	ff 75 08             	pushl  0x8(%ebp)
80104f2d:	e8 3e ff ff ff       	call   80104e70 <argint>
80104f32:	83 c4 10             	add    $0x10,%esp
80104f35:	85 c0                	test   %eax,%eax
80104f37:	78 17                	js     80104f50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f39:	83 ec 08             	sub    $0x8,%esp
80104f3c:	ff 75 0c             	pushl  0xc(%ebp)
80104f3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f42:	e8 b9 fe ff ff       	call   80104e00 <fetchstr>
80104f47:	83 c4 10             	add    $0x10,%esp
}
80104f4a:	c9                   	leave  
80104f4b:	c3                   	ret    
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f55:	c9                   	leave  
80104f56:	c3                   	ret    
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f67:	e8 f4 ec ff ff       	call   80103c60 <myproc>
80104f6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f6e:	8b 40 18             	mov    0x18(%eax),%eax
80104f71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f77:	83 fa 15             	cmp    $0x15,%edx
80104f7a:	77 1c                	ja     80104f98 <syscall+0x38>
80104f7c:	8b 14 85 80 81 10 80 	mov    -0x7fef7e80(,%eax,4),%edx
80104f83:	85 d2                	test   %edx,%edx
80104f85:	74 11                	je     80104f98 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104f87:	ff d2                	call   *%edx
80104f89:	8b 53 18             	mov    0x18(%ebx),%edx
80104f8c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f92:	c9                   	leave  
80104f93:	c3                   	ret    
80104f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104f98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f99:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104f9c:	50                   	push   %eax
80104f9d:	ff 73 10             	pushl  0x10(%ebx)
80104fa0:	68 51 81 10 80       	push   $0x80108151
80104fa5:	e8 b6 b6 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104faa:	8b 43 18             	mov    0x18(%ebx),%eax
80104fad:	83 c4 10             	add    $0x10,%esp
80104fb0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104fb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fba:	c9                   	leave  
80104fbb:	c3                   	ret    
80104fbc:	66 90                	xchg   %ax,%ax
80104fbe:	66 90                	xchg   %ax,%ax

80104fc0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
80104fc5:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104fc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104fca:	89 d6                	mov    %edx,%esi
80104fcc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fcf:	50                   	push   %eax
80104fd0:	6a 00                	push   $0x0
80104fd2:	e8 99 fe ff ff       	call   80104e70 <argint>
80104fd7:	83 c4 10             	add    $0x10,%esp
80104fda:	85 c0                	test   %eax,%eax
80104fdc:	78 2a                	js     80105008 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fde:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fe2:	77 24                	ja     80105008 <argfd.constprop.0+0x48>
80104fe4:	e8 77 ec ff ff       	call   80103c60 <myproc>
80104fe9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ff0:	85 c0                	test   %eax,%eax
80104ff2:	74 14                	je     80105008 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80104ff4:	85 db                	test   %ebx,%ebx
80104ff6:	74 02                	je     80104ffa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ff8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
80104ffa:	89 06                	mov    %eax,(%esi)
  return 0;
80104ffc:	31 c0                	xor    %eax,%eax
}
80104ffe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105001:	5b                   	pop    %ebx
80105002:	5e                   	pop    %esi
80105003:	5d                   	pop    %ebp
80105004:	c3                   	ret    
80105005:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105008:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010500d:	eb ef                	jmp    80104ffe <argfd.constprop.0+0x3e>
8010500f:	90                   	nop

80105010 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105010:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105011:	31 c0                	xor    %eax,%eax
{
80105013:	89 e5                	mov    %esp,%ebp
80105015:	56                   	push   %esi
80105016:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105017:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010501a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010501d:	e8 9e ff ff ff       	call   80104fc0 <argfd.constprop.0>
80105022:	85 c0                	test   %eax,%eax
80105024:	78 42                	js     80105068 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105026:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105029:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010502b:	e8 30 ec ff ff       	call   80103c60 <myproc>
80105030:	eb 0e                	jmp    80105040 <sys_dup+0x30>
80105032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105038:	83 c3 01             	add    $0x1,%ebx
8010503b:	83 fb 10             	cmp    $0x10,%ebx
8010503e:	74 28                	je     80105068 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105040:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105044:	85 d2                	test   %edx,%edx
80105046:	75 f0                	jne    80105038 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105048:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010504c:	83 ec 0c             	sub    $0xc,%esp
8010504f:	ff 75 f4             	pushl  -0xc(%ebp)
80105052:	e8 c9 bd ff ff       	call   80100e20 <filedup>
  return fd;
80105057:	83 c4 10             	add    $0x10,%esp
}
8010505a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010505d:	89 d8                	mov    %ebx,%eax
8010505f:	5b                   	pop    %ebx
80105060:	5e                   	pop    %esi
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	90                   	nop
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105068:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010506b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105070:	89 d8                	mov    %ebx,%eax
80105072:	5b                   	pop    %ebx
80105073:	5e                   	pop    %esi
80105074:	5d                   	pop    %ebp
80105075:	c3                   	ret    
80105076:	8d 76 00             	lea    0x0(%esi),%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <sys_read>:

int
sys_read(void)
{
80105080:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105081:	31 c0                	xor    %eax,%eax
{
80105083:	89 e5                	mov    %esp,%ebp
80105085:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105088:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010508b:	e8 30 ff ff ff       	call   80104fc0 <argfd.constprop.0>
80105090:	85 c0                	test   %eax,%eax
80105092:	78 4c                	js     801050e0 <sys_read+0x60>
80105094:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105097:	83 ec 08             	sub    $0x8,%esp
8010509a:	50                   	push   %eax
8010509b:	6a 02                	push   $0x2
8010509d:	e8 ce fd ff ff       	call   80104e70 <argint>
801050a2:	83 c4 10             	add    $0x10,%esp
801050a5:	85 c0                	test   %eax,%eax
801050a7:	78 37                	js     801050e0 <sys_read+0x60>
801050a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ac:	83 ec 04             	sub    $0x4,%esp
801050af:	ff 75 f0             	pushl  -0x10(%ebp)
801050b2:	50                   	push   %eax
801050b3:	6a 01                	push   $0x1
801050b5:	e8 06 fe ff ff       	call   80104ec0 <argptr>
801050ba:	83 c4 10             	add    $0x10,%esp
801050bd:	85 c0                	test   %eax,%eax
801050bf:	78 1f                	js     801050e0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801050c1:	83 ec 04             	sub    $0x4,%esp
801050c4:	ff 75 f0             	pushl  -0x10(%ebp)
801050c7:	ff 75 f4             	pushl  -0xc(%ebp)
801050ca:	ff 75 ec             	pushl  -0x14(%ebp)
801050cd:	e8 be be ff ff       	call   80100f90 <fileread>
801050d2:	83 c4 10             	add    $0x10,%esp
}
801050d5:	c9                   	leave  
801050d6:	c3                   	ret    
801050d7:	89 f6                	mov    %esi,%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
801050e7:	89 f6                	mov    %esi,%esi
801050e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050f0 <sys_write>:

int
sys_write(void)
{
801050f0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050f1:	31 c0                	xor    %eax,%eax
{
801050f3:	89 e5                	mov    %esp,%ebp
801050f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050fb:	e8 c0 fe ff ff       	call   80104fc0 <argfd.constprop.0>
80105100:	85 c0                	test   %eax,%eax
80105102:	78 4c                	js     80105150 <sys_write+0x60>
80105104:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105107:	83 ec 08             	sub    $0x8,%esp
8010510a:	50                   	push   %eax
8010510b:	6a 02                	push   $0x2
8010510d:	e8 5e fd ff ff       	call   80104e70 <argint>
80105112:	83 c4 10             	add    $0x10,%esp
80105115:	85 c0                	test   %eax,%eax
80105117:	78 37                	js     80105150 <sys_write+0x60>
80105119:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010511c:	83 ec 04             	sub    $0x4,%esp
8010511f:	ff 75 f0             	pushl  -0x10(%ebp)
80105122:	50                   	push   %eax
80105123:	6a 01                	push   $0x1
80105125:	e8 96 fd ff ff       	call   80104ec0 <argptr>
8010512a:	83 c4 10             	add    $0x10,%esp
8010512d:	85 c0                	test   %eax,%eax
8010512f:	78 1f                	js     80105150 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105131:	83 ec 04             	sub    $0x4,%esp
80105134:	ff 75 f0             	pushl  -0x10(%ebp)
80105137:	ff 75 f4             	pushl  -0xc(%ebp)
8010513a:	ff 75 ec             	pushl  -0x14(%ebp)
8010513d:	e8 de be ff ff       	call   80101020 <filewrite>
80105142:	83 c4 10             	add    $0x10,%esp
}
80105145:	c9                   	leave  
80105146:	c3                   	ret    
80105147:	89 f6                	mov    %esi,%esi
80105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105155:	c9                   	leave  
80105156:	c3                   	ret    
80105157:	89 f6                	mov    %esi,%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <sys_close>:

int
sys_close(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105166:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105169:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010516c:	e8 4f fe ff ff       	call   80104fc0 <argfd.constprop.0>
80105171:	85 c0                	test   %eax,%eax
80105173:	78 2b                	js     801051a0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105175:	e8 e6 ea ff ff       	call   80103c60 <myproc>
8010517a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010517d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105180:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105187:	00 
  fileclose(f);
80105188:	ff 75 f4             	pushl  -0xc(%ebp)
8010518b:	e8 e0 bc ff ff       	call   80100e70 <fileclose>
  return 0;
80105190:	83 c4 10             	add    $0x10,%esp
80105193:	31 c0                	xor    %eax,%eax
}
80105195:	c9                   	leave  
80105196:	c3                   	ret    
80105197:	89 f6                	mov    %esi,%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    
801051a7:	89 f6                	mov    %esi,%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <sys_fstat>:

int
sys_fstat(void)
{
801051b0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051b1:	31 c0                	xor    %eax,%eax
{
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051b8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801051bb:	e8 00 fe ff ff       	call   80104fc0 <argfd.constprop.0>
801051c0:	85 c0                	test   %eax,%eax
801051c2:	78 2c                	js     801051f0 <sys_fstat+0x40>
801051c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051c7:	83 ec 04             	sub    $0x4,%esp
801051ca:	6a 14                	push   $0x14
801051cc:	50                   	push   %eax
801051cd:	6a 01                	push   $0x1
801051cf:	e8 ec fc ff ff       	call   80104ec0 <argptr>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	78 15                	js     801051f0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801051db:	83 ec 08             	sub    $0x8,%esp
801051de:	ff 75 f4             	pushl  -0xc(%ebp)
801051e1:	ff 75 f0             	pushl  -0x10(%ebp)
801051e4:	e8 57 bd ff ff       	call   80100f40 <filestat>
801051e9:	83 c4 10             	add    $0x10,%esp
}
801051ec:	c9                   	leave  
801051ed:	c3                   	ret    
801051ee:	66 90                	xchg   %ax,%ax
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f5:	c9                   	leave  
801051f6:	c3                   	ret    
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
80105205:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105206:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105209:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 0c fd ff ff       	call   80104f20 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 fb 00 00 00    	js     8010531a <sys_link+0x11a>
8010521f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105222:	83 ec 08             	sub    $0x8,%esp
80105225:	50                   	push   %eax
80105226:	6a 01                	push   $0x1
80105228:	e8 f3 fc ff ff       	call   80104f20 <argstr>
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	85 c0                	test   %eax,%eax
80105232:	0f 88 e2 00 00 00    	js     8010531a <sys_link+0x11a>
    return -1;

  begin_op();
80105238:	e8 33 dd ff ff       	call   80102f70 <begin_op>
  if((ip = namei(old)) == 0){
8010523d:	83 ec 0c             	sub    $0xc,%esp
80105240:	ff 75 d4             	pushl  -0x2c(%ebp)
80105243:	e8 d8 cc ff ff       	call   80101f20 <namei>
80105248:	83 c4 10             	add    $0x10,%esp
8010524b:	85 c0                	test   %eax,%eax
8010524d:	89 c3                	mov    %eax,%ebx
8010524f:	0f 84 ea 00 00 00    	je     8010533f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105255:	83 ec 0c             	sub    $0xc,%esp
80105258:	50                   	push   %eax
80105259:	e8 62 c4 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105266:	0f 84 bb 00 00 00    	je     80105327 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010526c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105271:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105274:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105277:	53                   	push   %ebx
80105278:	e8 93 c3 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
8010527d:	89 1c 24             	mov    %ebx,(%esp)
80105280:	e8 1b c5 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105285:	58                   	pop    %eax
80105286:	5a                   	pop    %edx
80105287:	57                   	push   %edi
80105288:	ff 75 d0             	pushl  -0x30(%ebp)
8010528b:	e8 b0 cc ff ff       	call   80101f40 <nameiparent>
80105290:	83 c4 10             	add    $0x10,%esp
80105293:	85 c0                	test   %eax,%eax
80105295:	89 c6                	mov    %eax,%esi
80105297:	74 5b                	je     801052f4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	50                   	push   %eax
8010529d:	e8 1e c4 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	8b 03                	mov    (%ebx),%eax
801052a7:	39 06                	cmp    %eax,(%esi)
801052a9:	75 3d                	jne    801052e8 <sys_link+0xe8>
801052ab:	83 ec 04             	sub    $0x4,%esp
801052ae:	ff 73 04             	pushl  0x4(%ebx)
801052b1:	57                   	push   %edi
801052b2:	56                   	push   %esi
801052b3:	e8 a8 cb ff ff       	call   80101e60 <dirlink>
801052b8:	83 c4 10             	add    $0x10,%esp
801052bb:	85 c0                	test   %eax,%eax
801052bd:	78 29                	js     801052e8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801052bf:	83 ec 0c             	sub    $0xc,%esp
801052c2:	56                   	push   %esi
801052c3:	e8 88 c6 ff ff       	call   80101950 <iunlockput>
  iput(ip);
801052c8:	89 1c 24             	mov    %ebx,(%esp)
801052cb:	e8 20 c5 ff ff       	call   801017f0 <iput>

  end_op();
801052d0:	e8 0b dd ff ff       	call   80102fe0 <end_op>

  return 0;
801052d5:	83 c4 10             	add    $0x10,%esp
801052d8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801052da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052dd:	5b                   	pop    %ebx
801052de:	5e                   	pop    %esi
801052df:	5f                   	pop    %edi
801052e0:	5d                   	pop    %ebp
801052e1:	c3                   	ret    
801052e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052e8:	83 ec 0c             	sub    $0xc,%esp
801052eb:	56                   	push   %esi
801052ec:	e8 5f c6 ff ff       	call   80101950 <iunlockput>
    goto bad;
801052f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	53                   	push   %ebx
801052f8:	e8 c3 c3 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
801052fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105302:	89 1c 24             	mov    %ebx,(%esp)
80105305:	e8 06 c3 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
8010530a:	89 1c 24             	mov    %ebx,(%esp)
8010530d:	e8 3e c6 ff ff       	call   80101950 <iunlockput>
  end_op();
80105312:	e8 c9 dc ff ff       	call   80102fe0 <end_op>
  return -1;
80105317:	83 c4 10             	add    $0x10,%esp
}
8010531a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010531d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105322:	5b                   	pop    %ebx
80105323:	5e                   	pop    %esi
80105324:	5f                   	pop    %edi
80105325:	5d                   	pop    %ebp
80105326:	c3                   	ret    
    iunlockput(ip);
80105327:	83 ec 0c             	sub    $0xc,%esp
8010532a:	53                   	push   %ebx
8010532b:	e8 20 c6 ff ff       	call   80101950 <iunlockput>
    end_op();
80105330:	e8 ab dc ff ff       	call   80102fe0 <end_op>
    return -1;
80105335:	83 c4 10             	add    $0x10,%esp
80105338:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533d:	eb 9b                	jmp    801052da <sys_link+0xda>
    end_op();
8010533f:	e8 9c dc ff ff       	call   80102fe0 <end_op>
    return -1;
80105344:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105349:	eb 8f                	jmp    801052da <sys_link+0xda>
8010534b:	90                   	nop
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105350 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	57                   	push   %edi
80105354:	56                   	push   %esi
80105355:	53                   	push   %ebx
80105356:	83 ec 1c             	sub    $0x1c,%esp
80105359:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010535c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105360:	76 3e                	jbe    801053a0 <isdirempty+0x50>
80105362:	bb 20 00 00 00       	mov    $0x20,%ebx
80105367:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010536a:	eb 0c                	jmp    80105378 <isdirempty+0x28>
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105370:	83 c3 10             	add    $0x10,%ebx
80105373:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105376:	73 28                	jae    801053a0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105378:	6a 10                	push   $0x10
8010537a:	53                   	push   %ebx
8010537b:	57                   	push   %edi
8010537c:	56                   	push   %esi
8010537d:	e8 1e c6 ff ff       	call   801019a0 <readi>
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	83 f8 10             	cmp    $0x10,%eax
80105388:	75 23                	jne    801053ad <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010538a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010538f:	74 df                	je     80105370 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105391:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105394:	31 c0                	xor    %eax,%eax
}
80105396:	5b                   	pop    %ebx
80105397:	5e                   	pop    %esi
80105398:	5f                   	pop    %edi
80105399:	5d                   	pop    %ebp
8010539a:	c3                   	ret    
8010539b:	90                   	nop
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801053a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801053a8:	5b                   	pop    %ebx
801053a9:	5e                   	pop    %esi
801053aa:	5f                   	pop    %edi
801053ab:	5d                   	pop    %ebp
801053ac:	c3                   	ret    
      panic("isdirempty: readi");
801053ad:	83 ec 0c             	sub    $0xc,%esp
801053b0:	68 dc 81 10 80       	push   $0x801081dc
801053b5:	e8 d6 af ff ff       	call   80100390 <panic>
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053c0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
801053c5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801053c6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053c9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801053cc:	50                   	push   %eax
801053cd:	6a 00                	push   $0x0
801053cf:	e8 4c fb ff ff       	call   80104f20 <argstr>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	0f 88 51 01 00 00    	js     80105530 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801053df:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801053e2:	e8 89 db ff ff       	call   80102f70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053e7:	83 ec 08             	sub    $0x8,%esp
801053ea:	53                   	push   %ebx
801053eb:	ff 75 c0             	pushl  -0x40(%ebp)
801053ee:	e8 4d cb ff ff       	call   80101f40 <nameiparent>
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	85 c0                	test   %eax,%eax
801053f8:	89 c6                	mov    %eax,%esi
801053fa:	0f 84 37 01 00 00    	je     80105537 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105400:	83 ec 0c             	sub    $0xc,%esp
80105403:	50                   	push   %eax
80105404:	e8 b7 c2 ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105409:	58                   	pop    %eax
8010540a:	5a                   	pop    %edx
8010540b:	68 dd 7b 10 80       	push   $0x80107bdd
80105410:	53                   	push   %ebx
80105411:	e8 ba c7 ff ff       	call   80101bd0 <namecmp>
80105416:	83 c4 10             	add    $0x10,%esp
80105419:	85 c0                	test   %eax,%eax
8010541b:	0f 84 d7 00 00 00    	je     801054f8 <sys_unlink+0x138>
80105421:	83 ec 08             	sub    $0x8,%esp
80105424:	68 dc 7b 10 80       	push   $0x80107bdc
80105429:	53                   	push   %ebx
8010542a:	e8 a1 c7 ff ff       	call   80101bd0 <namecmp>
8010542f:	83 c4 10             	add    $0x10,%esp
80105432:	85 c0                	test   %eax,%eax
80105434:	0f 84 be 00 00 00    	je     801054f8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010543a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010543d:	83 ec 04             	sub    $0x4,%esp
80105440:	50                   	push   %eax
80105441:	53                   	push   %ebx
80105442:	56                   	push   %esi
80105443:	e8 a8 c7 ff ff       	call   80101bf0 <dirlookup>
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	85 c0                	test   %eax,%eax
8010544d:	89 c3                	mov    %eax,%ebx
8010544f:	0f 84 a3 00 00 00    	je     801054f8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105455:	83 ec 0c             	sub    $0xc,%esp
80105458:	50                   	push   %eax
80105459:	e8 62 c2 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
8010545e:	83 c4 10             	add    $0x10,%esp
80105461:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105466:	0f 8e e4 00 00 00    	jle    80105550 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010546c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105471:	74 65                	je     801054d8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105473:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105476:	83 ec 04             	sub    $0x4,%esp
80105479:	6a 10                	push   $0x10
8010547b:	6a 00                	push   $0x0
8010547d:	57                   	push   %edi
8010547e:	e8 ed f6 ff ff       	call   80104b70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105483:	6a 10                	push   $0x10
80105485:	ff 75 c4             	pushl  -0x3c(%ebp)
80105488:	57                   	push   %edi
80105489:	56                   	push   %esi
8010548a:	e8 11 c6 ff ff       	call   80101aa0 <writei>
8010548f:	83 c4 20             	add    $0x20,%esp
80105492:	83 f8 10             	cmp    $0x10,%eax
80105495:	0f 85 a8 00 00 00    	jne    80105543 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010549b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a0:	74 6e                	je     80105510 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801054a2:	83 ec 0c             	sub    $0xc,%esp
801054a5:	56                   	push   %esi
801054a6:	e8 a5 c4 ff ff       	call   80101950 <iunlockput>

  ip->nlink--;
801054ab:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054b0:	89 1c 24             	mov    %ebx,(%esp)
801054b3:	e8 58 c1 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
801054b8:	89 1c 24             	mov    %ebx,(%esp)
801054bb:	e8 90 c4 ff ff       	call   80101950 <iunlockput>

  end_op();
801054c0:	e8 1b db ff ff       	call   80102fe0 <end_op>

  return 0;
801054c5:	83 c4 10             	add    $0x10,%esp
801054c8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801054ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054cd:	5b                   	pop    %ebx
801054ce:	5e                   	pop    %esi
801054cf:	5f                   	pop    %edi
801054d0:	5d                   	pop    %ebp
801054d1:	c3                   	ret    
801054d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801054d8:	83 ec 0c             	sub    $0xc,%esp
801054db:	53                   	push   %ebx
801054dc:	e8 6f fe ff ff       	call   80105350 <isdirempty>
801054e1:	83 c4 10             	add    $0x10,%esp
801054e4:	85 c0                	test   %eax,%eax
801054e6:	75 8b                	jne    80105473 <sys_unlink+0xb3>
    iunlockput(ip);
801054e8:	83 ec 0c             	sub    $0xc,%esp
801054eb:	53                   	push   %ebx
801054ec:	e8 5f c4 ff ff       	call   80101950 <iunlockput>
    goto bad;
801054f1:	83 c4 10             	add    $0x10,%esp
801054f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801054f8:	83 ec 0c             	sub    $0xc,%esp
801054fb:	56                   	push   %esi
801054fc:	e8 4f c4 ff ff       	call   80101950 <iunlockput>
  end_op();
80105501:	e8 da da ff ff       	call   80102fe0 <end_op>
  return -1;
80105506:	83 c4 10             	add    $0x10,%esp
80105509:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550e:	eb ba                	jmp    801054ca <sys_unlink+0x10a>
    dp->nlink--;
80105510:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105515:	83 ec 0c             	sub    $0xc,%esp
80105518:	56                   	push   %esi
80105519:	e8 f2 c0 ff ff       	call   80101610 <iupdate>
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	e9 7c ff ff ff       	jmp    801054a2 <sys_unlink+0xe2>
80105526:	8d 76 00             	lea    0x0(%esi),%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105535:	eb 93                	jmp    801054ca <sys_unlink+0x10a>
    end_op();
80105537:	e8 a4 da ff ff       	call   80102fe0 <end_op>
    return -1;
8010553c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105541:	eb 87                	jmp    801054ca <sys_unlink+0x10a>
    panic("unlink: writei");
80105543:	83 ec 0c             	sub    $0xc,%esp
80105546:	68 f1 7b 10 80       	push   $0x80107bf1
8010554b:	e8 40 ae ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	68 df 7b 10 80       	push   $0x80107bdf
80105558:	e8 33 ae ff ff       	call   80100390 <panic>
8010555d:	8d 76 00             	lea    0x0(%esi),%esi

80105560 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	57                   	push   %edi
80105564:	56                   	push   %esi
80105565:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105566:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105569:	83 ec 44             	sub    $0x44,%esp
8010556c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010556f:	8b 55 10             	mov    0x10(%ebp),%edx
80105572:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105575:	56                   	push   %esi
80105576:	ff 75 08             	pushl  0x8(%ebp)
{
80105579:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010557c:	89 55 c0             	mov    %edx,-0x40(%ebp)
8010557f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105582:	e8 b9 c9 ff ff       	call   80101f40 <nameiparent>
80105587:	83 c4 10             	add    $0x10,%esp
8010558a:	85 c0                	test   %eax,%eax
8010558c:	0f 84 4e 01 00 00    	je     801056e0 <create+0x180>
    return 0;
  ilock(dp);
80105592:	83 ec 0c             	sub    $0xc,%esp
80105595:	89 c3                	mov    %eax,%ebx
80105597:	50                   	push   %eax
80105598:	e8 23 c1 ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010559d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801055a0:	83 c4 0c             	add    $0xc,%esp
801055a3:	50                   	push   %eax
801055a4:	56                   	push   %esi
801055a5:	53                   	push   %ebx
801055a6:	e8 45 c6 ff ff       	call   80101bf0 <dirlookup>
801055ab:	83 c4 10             	add    $0x10,%esp
801055ae:	85 c0                	test   %eax,%eax
801055b0:	89 c7                	mov    %eax,%edi
801055b2:	74 3c                	je     801055f0 <create+0x90>
    iunlockput(dp);
801055b4:	83 ec 0c             	sub    $0xc,%esp
801055b7:	53                   	push   %ebx
801055b8:	e8 93 c3 ff ff       	call   80101950 <iunlockput>
    ilock(ip);
801055bd:	89 3c 24             	mov    %edi,(%esp)
801055c0:	e8 fb c0 ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801055c5:	83 c4 10             	add    $0x10,%esp
801055c8:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801055cd:	0f 85 9d 00 00 00    	jne    80105670 <create+0x110>
801055d3:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801055d8:	0f 85 92 00 00 00    	jne    80105670 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801055de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055e1:	89 f8                	mov    %edi,%eax
801055e3:	5b                   	pop    %ebx
801055e4:	5e                   	pop    %esi
801055e5:	5f                   	pop    %edi
801055e6:	5d                   	pop    %ebp
801055e7:	c3                   	ret    
801055e8:	90                   	nop
801055e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801055f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801055f4:	83 ec 08             	sub    $0x8,%esp
801055f7:	50                   	push   %eax
801055f8:	ff 33                	pushl  (%ebx)
801055fa:	e8 51 bf ff ff       	call   80101550 <ialloc>
801055ff:	83 c4 10             	add    $0x10,%esp
80105602:	85 c0                	test   %eax,%eax
80105604:	89 c7                	mov    %eax,%edi
80105606:	0f 84 e8 00 00 00    	je     801056f4 <create+0x194>
  ilock(ip);
8010560c:	83 ec 0c             	sub    $0xc,%esp
8010560f:	50                   	push   %eax
80105610:	e8 ab c0 ff ff       	call   801016c0 <ilock>
  ip->major = major;
80105615:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105619:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010561d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105621:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105625:	b8 01 00 00 00       	mov    $0x1,%eax
8010562a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010562e:	89 3c 24             	mov    %edi,(%esp)
80105631:	e8 da bf ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010563e:	74 50                	je     80105690 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105640:	83 ec 04             	sub    $0x4,%esp
80105643:	ff 77 04             	pushl  0x4(%edi)
80105646:	56                   	push   %esi
80105647:	53                   	push   %ebx
80105648:	e8 13 c8 ff ff       	call   80101e60 <dirlink>
8010564d:	83 c4 10             	add    $0x10,%esp
80105650:	85 c0                	test   %eax,%eax
80105652:	0f 88 8f 00 00 00    	js     801056e7 <create+0x187>
  iunlockput(dp);
80105658:	83 ec 0c             	sub    $0xc,%esp
8010565b:	53                   	push   %ebx
8010565c:	e8 ef c2 ff ff       	call   80101950 <iunlockput>
  return ip;
80105661:	83 c4 10             	add    $0x10,%esp
}
80105664:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105667:	89 f8                	mov    %edi,%eax
80105669:	5b                   	pop    %ebx
8010566a:	5e                   	pop    %esi
8010566b:	5f                   	pop    %edi
8010566c:	5d                   	pop    %ebp
8010566d:	c3                   	ret    
8010566e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	57                   	push   %edi
    return 0;
80105674:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105676:	e8 d5 c2 ff ff       	call   80101950 <iunlockput>
    return 0;
8010567b:	83 c4 10             	add    $0x10,%esp
}
8010567e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105681:	89 f8                	mov    %edi,%eax
80105683:	5b                   	pop    %ebx
80105684:	5e                   	pop    %esi
80105685:	5f                   	pop    %edi
80105686:	5d                   	pop    %ebp
80105687:	c3                   	ret    
80105688:	90                   	nop
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105690:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105695:	83 ec 0c             	sub    $0xc,%esp
80105698:	53                   	push   %ebx
80105699:	e8 72 bf ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010569e:	83 c4 0c             	add    $0xc,%esp
801056a1:	ff 77 04             	pushl  0x4(%edi)
801056a4:	68 dd 7b 10 80       	push   $0x80107bdd
801056a9:	57                   	push   %edi
801056aa:	e8 b1 c7 ff ff       	call   80101e60 <dirlink>
801056af:	83 c4 10             	add    $0x10,%esp
801056b2:	85 c0                	test   %eax,%eax
801056b4:	78 1c                	js     801056d2 <create+0x172>
801056b6:	83 ec 04             	sub    $0x4,%esp
801056b9:	ff 73 04             	pushl  0x4(%ebx)
801056bc:	68 dc 7b 10 80       	push   $0x80107bdc
801056c1:	57                   	push   %edi
801056c2:	e8 99 c7 ff ff       	call   80101e60 <dirlink>
801056c7:	83 c4 10             	add    $0x10,%esp
801056ca:	85 c0                	test   %eax,%eax
801056cc:	0f 89 6e ff ff ff    	jns    80105640 <create+0xe0>
      panic("create dots");
801056d2:	83 ec 0c             	sub    $0xc,%esp
801056d5:	68 fd 81 10 80       	push   $0x801081fd
801056da:	e8 b1 ac ff ff       	call   80100390 <panic>
801056df:	90                   	nop
    return 0;
801056e0:	31 ff                	xor    %edi,%edi
801056e2:	e9 f7 fe ff ff       	jmp    801055de <create+0x7e>
    panic("create: dirlink");
801056e7:	83 ec 0c             	sub    $0xc,%esp
801056ea:	68 09 82 10 80       	push   $0x80108209
801056ef:	e8 9c ac ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801056f4:	83 ec 0c             	sub    $0xc,%esp
801056f7:	68 ee 81 10 80       	push   $0x801081ee
801056fc:	e8 8f ac ff ff       	call   80100390 <panic>
80105701:	eb 0d                	jmp    80105710 <sys_open>
80105703:	90                   	nop
80105704:	90                   	nop
80105705:	90                   	nop
80105706:	90                   	nop
80105707:	90                   	nop
80105708:	90                   	nop
80105709:	90                   	nop
8010570a:	90                   	nop
8010570b:	90                   	nop
8010570c:	90                   	nop
8010570d:	90                   	nop
8010570e:	90                   	nop
8010570f:	90                   	nop

80105710 <sys_open>:

int
sys_open(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	56                   	push   %esi
80105715:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105716:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105719:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010571c:	50                   	push   %eax
8010571d:	6a 00                	push   $0x0
8010571f:	e8 fc f7 ff ff       	call   80104f20 <argstr>
80105724:	83 c4 10             	add    $0x10,%esp
80105727:	85 c0                	test   %eax,%eax
80105729:	0f 88 1d 01 00 00    	js     8010584c <sys_open+0x13c>
8010572f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105732:	83 ec 08             	sub    $0x8,%esp
80105735:	50                   	push   %eax
80105736:	6a 01                	push   $0x1
80105738:	e8 33 f7 ff ff       	call   80104e70 <argint>
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	85 c0                	test   %eax,%eax
80105742:	0f 88 04 01 00 00    	js     8010584c <sys_open+0x13c>
    return -1;

  begin_op();
80105748:	e8 23 d8 ff ff       	call   80102f70 <begin_op>

  if(omode & O_CREATE){
8010574d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105751:	0f 85 a9 00 00 00    	jne    80105800 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105757:	83 ec 0c             	sub    $0xc,%esp
8010575a:	ff 75 e0             	pushl  -0x20(%ebp)
8010575d:	e8 be c7 ff ff       	call   80101f20 <namei>
80105762:	83 c4 10             	add    $0x10,%esp
80105765:	85 c0                	test   %eax,%eax
80105767:	89 c6                	mov    %eax,%esi
80105769:	0f 84 ac 00 00 00    	je     8010581b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010576f:	83 ec 0c             	sub    $0xc,%esp
80105772:	50                   	push   %eax
80105773:	e8 48 bf ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105780:	0f 84 aa 00 00 00    	je     80105830 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105786:	e8 25 b6 ff ff       	call   80100db0 <filealloc>
8010578b:	85 c0                	test   %eax,%eax
8010578d:	89 c7                	mov    %eax,%edi
8010578f:	0f 84 a6 00 00 00    	je     8010583b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105795:	e8 c6 e4 ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010579a:	31 db                	xor    %ebx,%ebx
8010579c:	eb 0e                	jmp    801057ac <sys_open+0x9c>
8010579e:	66 90                	xchg   %ax,%ax
801057a0:	83 c3 01             	add    $0x1,%ebx
801057a3:	83 fb 10             	cmp    $0x10,%ebx
801057a6:	0f 84 ac 00 00 00    	je     80105858 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801057ac:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057b0:	85 d2                	test   %edx,%edx
801057b2:	75 ec                	jne    801057a0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057b4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801057b7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801057bb:	56                   	push   %esi
801057bc:	e8 df bf ff ff       	call   801017a0 <iunlock>
  end_op();
801057c1:	e8 1a d8 ff ff       	call   80102fe0 <end_op>

  f->type = FD_INODE;
801057c6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801057cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057cf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801057d2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801057d5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801057dc:	89 d0                	mov    %edx,%eax
801057de:	f7 d0                	not    %eax
801057e0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057e3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801057e6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057e9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801057ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057f0:	89 d8                	mov    %ebx,%eax
801057f2:	5b                   	pop    %ebx
801057f3:	5e                   	pop    %esi
801057f4:	5f                   	pop    %edi
801057f5:	5d                   	pop    %ebp
801057f6:	c3                   	ret    
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105800:	6a 00                	push   $0x0
80105802:	6a 00                	push   $0x0
80105804:	6a 02                	push   $0x2
80105806:	ff 75 e0             	pushl  -0x20(%ebp)
80105809:	e8 52 fd ff ff       	call   80105560 <create>
    if(ip == 0){
8010580e:	83 c4 10             	add    $0x10,%esp
80105811:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105813:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105815:	0f 85 6b ff ff ff    	jne    80105786 <sys_open+0x76>
      end_op();
8010581b:	e8 c0 d7 ff ff       	call   80102fe0 <end_op>
      return -1;
80105820:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105825:	eb c6                	jmp    801057ed <sys_open+0xdd>
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105830:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105833:	85 c9                	test   %ecx,%ecx
80105835:	0f 84 4b ff ff ff    	je     80105786 <sys_open+0x76>
    iunlockput(ip);
8010583b:	83 ec 0c             	sub    $0xc,%esp
8010583e:	56                   	push   %esi
8010583f:	e8 0c c1 ff ff       	call   80101950 <iunlockput>
    end_op();
80105844:	e8 97 d7 ff ff       	call   80102fe0 <end_op>
    return -1;
80105849:	83 c4 10             	add    $0x10,%esp
8010584c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105851:	eb 9a                	jmp    801057ed <sys_open+0xdd>
80105853:	90                   	nop
80105854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105858:	83 ec 0c             	sub    $0xc,%esp
8010585b:	57                   	push   %edi
8010585c:	e8 0f b6 ff ff       	call   80100e70 <fileclose>
80105861:	83 c4 10             	add    $0x10,%esp
80105864:	eb d5                	jmp    8010583b <sys_open+0x12b>
80105866:	8d 76 00             	lea    0x0(%esi),%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105870 <sys_mkdir>:

int
sys_mkdir(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105876:	e8 f5 d6 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010587b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010587e:	83 ec 08             	sub    $0x8,%esp
80105881:	50                   	push   %eax
80105882:	6a 00                	push   $0x0
80105884:	e8 97 f6 ff ff       	call   80104f20 <argstr>
80105889:	83 c4 10             	add    $0x10,%esp
8010588c:	85 c0                	test   %eax,%eax
8010588e:	78 30                	js     801058c0 <sys_mkdir+0x50>
80105890:	6a 00                	push   $0x0
80105892:	6a 00                	push   $0x0
80105894:	6a 01                	push   $0x1
80105896:	ff 75 f4             	pushl  -0xc(%ebp)
80105899:	e8 c2 fc ff ff       	call   80105560 <create>
8010589e:	83 c4 10             	add    $0x10,%esp
801058a1:	85 c0                	test   %eax,%eax
801058a3:	74 1b                	je     801058c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058a5:	83 ec 0c             	sub    $0xc,%esp
801058a8:	50                   	push   %eax
801058a9:	e8 a2 c0 ff ff       	call   80101950 <iunlockput>
  end_op();
801058ae:	e8 2d d7 ff ff       	call   80102fe0 <end_op>
  return 0;
801058b3:	83 c4 10             	add    $0x10,%esp
801058b6:	31 c0                	xor    %eax,%eax
}
801058b8:	c9                   	leave  
801058b9:	c3                   	ret    
801058ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801058c0:	e8 1b d7 ff ff       	call   80102fe0 <end_op>
    return -1;
801058c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058ca:	c9                   	leave  
801058cb:	c3                   	ret    
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_mknod>:

int
sys_mknod(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801058d6:	e8 95 d6 ff ff       	call   80102f70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801058db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058de:	83 ec 08             	sub    $0x8,%esp
801058e1:	50                   	push   %eax
801058e2:	6a 00                	push   $0x0
801058e4:	e8 37 f6 ff ff       	call   80104f20 <argstr>
801058e9:	83 c4 10             	add    $0x10,%esp
801058ec:	85 c0                	test   %eax,%eax
801058ee:	78 60                	js     80105950 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801058f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058f3:	83 ec 08             	sub    $0x8,%esp
801058f6:	50                   	push   %eax
801058f7:	6a 01                	push   $0x1
801058f9:	e8 72 f5 ff ff       	call   80104e70 <argint>
  if((argstr(0, &path)) < 0 ||
801058fe:	83 c4 10             	add    $0x10,%esp
80105901:	85 c0                	test   %eax,%eax
80105903:	78 4b                	js     80105950 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105905:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105908:	83 ec 08             	sub    $0x8,%esp
8010590b:	50                   	push   %eax
8010590c:	6a 02                	push   $0x2
8010590e:	e8 5d f5 ff ff       	call   80104e70 <argint>
     argint(1, &major) < 0 ||
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	85 c0                	test   %eax,%eax
80105918:	78 36                	js     80105950 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010591a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010591e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
8010591f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105923:	50                   	push   %eax
80105924:	6a 03                	push   $0x3
80105926:	ff 75 ec             	pushl  -0x14(%ebp)
80105929:	e8 32 fc ff ff       	call   80105560 <create>
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	85 c0                	test   %eax,%eax
80105933:	74 1b                	je     80105950 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105935:	83 ec 0c             	sub    $0xc,%esp
80105938:	50                   	push   %eax
80105939:	e8 12 c0 ff ff       	call   80101950 <iunlockput>
  end_op();
8010593e:	e8 9d d6 ff ff       	call   80102fe0 <end_op>
  return 0;
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	31 c0                	xor    %eax,%eax
}
80105948:	c9                   	leave  
80105949:	c3                   	ret    
8010594a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105950:	e8 8b d6 ff ff       	call   80102fe0 <end_op>
    return -1;
80105955:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010595a:	c9                   	leave  
8010595b:	c3                   	ret    
8010595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105960 <sys_chdir>:

int
sys_chdir(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	56                   	push   %esi
80105964:	53                   	push   %ebx
80105965:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105968:	e8 f3 e2 ff ff       	call   80103c60 <myproc>
8010596d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010596f:	e8 fc d5 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105974:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105977:	83 ec 08             	sub    $0x8,%esp
8010597a:	50                   	push   %eax
8010597b:	6a 00                	push   $0x0
8010597d:	e8 9e f5 ff ff       	call   80104f20 <argstr>
80105982:	83 c4 10             	add    $0x10,%esp
80105985:	85 c0                	test   %eax,%eax
80105987:	78 77                	js     80105a00 <sys_chdir+0xa0>
80105989:	83 ec 0c             	sub    $0xc,%esp
8010598c:	ff 75 f4             	pushl  -0xc(%ebp)
8010598f:	e8 8c c5 ff ff       	call   80101f20 <namei>
80105994:	83 c4 10             	add    $0x10,%esp
80105997:	85 c0                	test   %eax,%eax
80105999:	89 c3                	mov    %eax,%ebx
8010599b:	74 63                	je     80105a00 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010599d:	83 ec 0c             	sub    $0xc,%esp
801059a0:	50                   	push   %eax
801059a1:	e8 1a bd ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
801059a6:	83 c4 10             	add    $0x10,%esp
801059a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059ae:	75 30                	jne    801059e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	53                   	push   %ebx
801059b4:	e8 e7 bd ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
801059b9:	58                   	pop    %eax
801059ba:	ff 76 68             	pushl  0x68(%esi)
801059bd:	e8 2e be ff ff       	call   801017f0 <iput>
  end_op();
801059c2:	e8 19 d6 ff ff       	call   80102fe0 <end_op>
  curproc->cwd = ip;
801059c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801059ca:	83 c4 10             	add    $0x10,%esp
801059cd:	31 c0                	xor    %eax,%eax
}
801059cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059d2:	5b                   	pop    %ebx
801059d3:	5e                   	pop    %esi
801059d4:	5d                   	pop    %ebp
801059d5:	c3                   	ret    
801059d6:	8d 76 00             	lea    0x0(%esi),%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	53                   	push   %ebx
801059e4:	e8 67 bf ff ff       	call   80101950 <iunlockput>
    end_op();
801059e9:	e8 f2 d5 ff ff       	call   80102fe0 <end_op>
    return -1;
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059f6:	eb d7                	jmp    801059cf <sys_chdir+0x6f>
801059f8:	90                   	nop
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a00:	e8 db d5 ff ff       	call   80102fe0 <end_op>
    return -1;
80105a05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0a:	eb c3                	jmp    801059cf <sys_chdir+0x6f>
80105a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a10 <sys_exec>:

int
sys_exec(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	57                   	push   %edi
80105a14:	56                   	push   %esi
80105a15:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a16:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a1c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a22:	50                   	push   %eax
80105a23:	6a 00                	push   $0x0
80105a25:	e8 f6 f4 ff ff       	call   80104f20 <argstr>
80105a2a:	83 c4 10             	add    $0x10,%esp
80105a2d:	85 c0                	test   %eax,%eax
80105a2f:	0f 88 87 00 00 00    	js     80105abc <sys_exec+0xac>
80105a35:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a3b:	83 ec 08             	sub    $0x8,%esp
80105a3e:	50                   	push   %eax
80105a3f:	6a 01                	push   $0x1
80105a41:	e8 2a f4 ff ff       	call   80104e70 <argint>
80105a46:	83 c4 10             	add    $0x10,%esp
80105a49:	85 c0                	test   %eax,%eax
80105a4b:	78 6f                	js     80105abc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a4d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a53:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105a56:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a58:	68 80 00 00 00       	push   $0x80
80105a5d:	6a 00                	push   $0x0
80105a5f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a65:	50                   	push   %eax
80105a66:	e8 05 f1 ff ff       	call   80104b70 <memset>
80105a6b:	83 c4 10             	add    $0x10,%esp
80105a6e:	eb 2c                	jmp    80105a9c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105a70:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a76:	85 c0                	test   %eax,%eax
80105a78:	74 56                	je     80105ad0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a7a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105a80:	83 ec 08             	sub    $0x8,%esp
80105a83:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105a86:	52                   	push   %edx
80105a87:	50                   	push   %eax
80105a88:	e8 73 f3 ff ff       	call   80104e00 <fetchstr>
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	85 c0                	test   %eax,%eax
80105a92:	78 28                	js     80105abc <sys_exec+0xac>
  for(i=0;; i++){
80105a94:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a97:	83 fb 20             	cmp    $0x20,%ebx
80105a9a:	74 20                	je     80105abc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a9c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105aa2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105aa9:	83 ec 08             	sub    $0x8,%esp
80105aac:	57                   	push   %edi
80105aad:	01 f0                	add    %esi,%eax
80105aaf:	50                   	push   %eax
80105ab0:	e8 0b f3 ff ff       	call   80104dc0 <fetchint>
80105ab5:	83 c4 10             	add    $0x10,%esp
80105ab8:	85 c0                	test   %eax,%eax
80105aba:	79 b4                	jns    80105a70 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105abc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105abf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ac4:	5b                   	pop    %ebx
80105ac5:	5e                   	pop    %esi
80105ac6:	5f                   	pop    %edi
80105ac7:	5d                   	pop    %ebp
80105ac8:	c3                   	ret    
80105ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105ad0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ad6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105ad9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ae0:	00 00 00 00 
  return exec(path, argv);
80105ae4:	50                   	push   %eax
80105ae5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105aeb:	e8 20 af ff ff       	call   80100a10 <exec>
80105af0:	83 c4 10             	add    $0x10,%esp
}
80105af3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105af6:	5b                   	pop    %ebx
80105af7:	5e                   	pop    %esi
80105af8:	5f                   	pop    %edi
80105af9:	5d                   	pop    %ebp
80105afa:	c3                   	ret    
80105afb:	90                   	nop
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_pipe>:

int
sys_pipe(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b06:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b09:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b0c:	6a 08                	push   $0x8
80105b0e:	50                   	push   %eax
80105b0f:	6a 00                	push   $0x0
80105b11:	e8 aa f3 ff ff       	call   80104ec0 <argptr>
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	0f 88 ae 00 00 00    	js     80105bcf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b21:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b24:	83 ec 08             	sub    $0x8,%esp
80105b27:	50                   	push   %eax
80105b28:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b2b:	50                   	push   %eax
80105b2c:	e8 df da ff ff       	call   80103610 <pipealloc>
80105b31:	83 c4 10             	add    $0x10,%esp
80105b34:	85 c0                	test   %eax,%eax
80105b36:	0f 88 93 00 00 00    	js     80105bcf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b3c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b3f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b41:	e8 1a e1 ff ff       	call   80103c60 <myproc>
80105b46:	eb 10                	jmp    80105b58 <sys_pipe+0x58>
80105b48:	90                   	nop
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b50:	83 c3 01             	add    $0x1,%ebx
80105b53:	83 fb 10             	cmp    $0x10,%ebx
80105b56:	74 60                	je     80105bb8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105b58:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b5c:	85 f6                	test   %esi,%esi
80105b5e:	75 f0                	jne    80105b50 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105b60:	8d 73 08             	lea    0x8(%ebx),%esi
80105b63:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b6a:	e8 f1 e0 ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b6f:	31 d2                	xor    %edx,%edx
80105b71:	eb 0d                	jmp    80105b80 <sys_pipe+0x80>
80105b73:	90                   	nop
80105b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b78:	83 c2 01             	add    $0x1,%edx
80105b7b:	83 fa 10             	cmp    $0x10,%edx
80105b7e:	74 28                	je     80105ba8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105b80:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b84:	85 c9                	test   %ecx,%ecx
80105b86:	75 f0                	jne    80105b78 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105b88:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105b8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b8f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b91:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b94:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b97:	31 c0                	xor    %eax,%eax
}
80105b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b9c:	5b                   	pop    %ebx
80105b9d:	5e                   	pop    %esi
80105b9e:	5f                   	pop    %edi
80105b9f:	5d                   	pop    %ebp
80105ba0:	c3                   	ret    
80105ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105ba8:	e8 b3 e0 ff ff       	call   80103c60 <myproc>
80105bad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105bb4:	00 
80105bb5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105bb8:	83 ec 0c             	sub    $0xc,%esp
80105bbb:	ff 75 e0             	pushl  -0x20(%ebp)
80105bbe:	e8 ad b2 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105bc3:	58                   	pop    %eax
80105bc4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105bc7:	e8 a4 b2 ff ff       	call   80100e70 <fileclose>
    return -1;
80105bcc:	83 c4 10             	add    $0x10,%esp
80105bcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd4:	eb c3                	jmp    80105b99 <sys_pipe+0x99>
80105bd6:	66 90                	xchg   %ax,%ax
80105bd8:	66 90                	xchg   %ax,%ax
80105bda:	66 90                	xchg   %ax,%ax
80105bdc:	66 90                	xchg   %ax,%ax
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105be6:	e8 95 e7 ff ff       	call   80104380 <yield>
  return 0;
}
80105beb:	31 c0                	xor    %eax,%eax
80105bed:	c9                   	leave  
80105bee:	c3                   	ret    
80105bef:	90                   	nop

80105bf0 <sys_fork>:

int
sys_fork(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105bf3:	5d                   	pop    %ebp
  return fork();
80105bf4:	e9 07 e2 ff ff       	jmp    80103e00 <fork>
80105bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_exit>:

int
sys_exit(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c06:	e8 25 e6 ff ff       	call   80104230 <exit>
  return 0;  // not reached
}
80105c0b:	31 c0                	xor    %eax,%eax
80105c0d:	c9                   	leave  
80105c0e:	c3                   	ret    
80105c0f:	90                   	nop

80105c10 <sys_wait>:

int
sys_wait(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105c13:	5d                   	pop    %ebp
  return wait();
80105c14:	e9 77 e8 ff ff       	jmp    80104490 <wait>
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c20 <sys_kill>:

int
sys_kill(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c29:	50                   	push   %eax
80105c2a:	6a 00                	push   $0x0
80105c2c:	e8 3f f2 ff ff       	call   80104e70 <argint>
80105c31:	83 c4 10             	add    $0x10,%esp
80105c34:	85 c0                	test   %eax,%eax
80105c36:	78 18                	js     80105c50 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c38:	83 ec 0c             	sub    $0xc,%esp
80105c3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c3e:	e8 5d ea ff ff       	call   801046a0 <kill>
80105c43:	83 c4 10             	add    $0x10,%esp
}
80105c46:	c9                   	leave  
80105c47:	c3                   	ret    
80105c48:	90                   	nop
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c55:	c9                   	leave  
80105c56:	c3                   	ret    
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c60 <sys_getpid>:

int
sys_getpid(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c66:	e8 f5 df ff ff       	call   80103c60 <myproc>
80105c6b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c6e:	c9                   	leave  
80105c6f:	c3                   	ret    

80105c70 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c7a:	50                   	push   %eax
80105c7b:	6a 00                	push   $0x0
80105c7d:	e8 ee f1 ff ff       	call   80104e70 <argint>
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	85 c0                	test   %eax,%eax
80105c87:	78 27                	js     80105cb0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c89:	e8 d2 df ff ff       	call   80103c60 <myproc>
  if(growproc(n) < 0)
80105c8e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c91:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c93:	ff 75 f4             	pushl  -0xc(%ebp)
80105c96:	e8 e5 e0 ff ff       	call   80103d80 <growproc>
80105c9b:	83 c4 10             	add    $0x10,%esp
80105c9e:	85 c0                	test   %eax,%eax
80105ca0:	78 0e                	js     80105cb0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ca2:	89 d8                	mov    %ebx,%eax
80105ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ca7:	c9                   	leave  
80105ca8:	c3                   	ret    
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105cb0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cb5:	eb eb                	jmp    80105ca2 <sys_sbrk+0x32>
80105cb7:	89 f6                	mov    %esi,%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cc0 <sys_sleep>:

int
sys_sleep(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105cc7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cca:	50                   	push   %eax
80105ccb:	6a 00                	push   $0x0
80105ccd:	e8 9e f1 ff ff       	call   80104e70 <argint>
80105cd2:	83 c4 10             	add    $0x10,%esp
80105cd5:	85 c0                	test   %eax,%eax
80105cd7:	0f 88 8a 00 00 00    	js     80105d67 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105cdd:	83 ec 0c             	sub    $0xc,%esp
80105ce0:	68 60 61 12 80       	push   $0x80126160
80105ce5:	e8 06 ed ff ff       	call   801049f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ced:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105cf0:	8b 1d a0 69 12 80    	mov    0x801269a0,%ebx
  while(ticks - ticks0 < n){
80105cf6:	85 d2                	test   %edx,%edx
80105cf8:	75 27                	jne    80105d21 <sys_sleep+0x61>
80105cfa:	eb 54                	jmp    80105d50 <sys_sleep+0x90>
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d00:	83 ec 08             	sub    $0x8,%esp
80105d03:	68 60 61 12 80       	push   $0x80126160
80105d08:	68 a0 69 12 80       	push   $0x801269a0
80105d0d:	e8 be e6 ff ff       	call   801043d0 <sleep>
  while(ticks - ticks0 < n){
80105d12:	a1 a0 69 12 80       	mov    0x801269a0,%eax
80105d17:	83 c4 10             	add    $0x10,%esp
80105d1a:	29 d8                	sub    %ebx,%eax
80105d1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d1f:	73 2f                	jae    80105d50 <sys_sleep+0x90>
    if(myproc()->killed){
80105d21:	e8 3a df ff ff       	call   80103c60 <myproc>
80105d26:	8b 40 24             	mov    0x24(%eax),%eax
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	74 d3                	je     80105d00 <sys_sleep+0x40>
      release(&tickslock);
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	68 60 61 12 80       	push   $0x80126160
80105d35:	e8 d6 ed ff ff       	call   80104b10 <release>
      return -1;
80105d3a:	83 c4 10             	add    $0x10,%esp
80105d3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105d42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d45:	c9                   	leave  
80105d46:	c3                   	ret    
80105d47:	89 f6                	mov    %esi,%esi
80105d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105d50:	83 ec 0c             	sub    $0xc,%esp
80105d53:	68 60 61 12 80       	push   $0x80126160
80105d58:	e8 b3 ed ff ff       	call   80104b10 <release>
  return 0;
80105d5d:	83 c4 10             	add    $0x10,%esp
80105d60:	31 c0                	xor    %eax,%eax
}
80105d62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d65:	c9                   	leave  
80105d66:	c3                   	ret    
    return -1;
80105d67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d6c:	eb f4                	jmp    80105d62 <sys_sleep+0xa2>
80105d6e:	66 90                	xchg   %ax,%ax

80105d70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	53                   	push   %ebx
80105d74:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d77:	68 60 61 12 80       	push   $0x80126160
80105d7c:	e8 6f ec ff ff       	call   801049f0 <acquire>
  xticks = ticks;
80105d81:	8b 1d a0 69 12 80    	mov    0x801269a0,%ebx
  release(&tickslock);
80105d87:	c7 04 24 60 61 12 80 	movl   $0x80126160,(%esp)
80105d8e:	e8 7d ed ff ff       	call   80104b10 <release>
  return xticks;
}
80105d93:	89 d8                	mov    %ebx,%eax
80105d95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d98:	c9                   	leave  
80105d99:	c3                   	ret    

80105d9a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d9a:	1e                   	push   %ds
  pushl %es
80105d9b:	06                   	push   %es
  pushl %fs
80105d9c:	0f a0                	push   %fs
  pushl %gs
80105d9e:	0f a8                	push   %gs
  pushal
80105da0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105da1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105da5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105da7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105da9:	54                   	push   %esp
  call trap
80105daa:	e8 c1 00 00 00       	call   80105e70 <trap>
  addl $4, %esp
80105daf:	83 c4 04             	add    $0x4,%esp

80105db2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105db2:	61                   	popa   
  popl %gs
80105db3:	0f a9                	pop    %gs
  popl %fs
80105db5:	0f a1                	pop    %fs
  popl %es
80105db7:	07                   	pop    %es
  popl %ds
80105db8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105db9:	83 c4 08             	add    $0x8,%esp
  iret
80105dbc:	cf                   	iret   
80105dbd:	66 90                	xchg   %ax,%ax
80105dbf:	90                   	nop

80105dc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105dc0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105dc1:	31 c0                	xor    %eax,%eax
{
80105dc3:	89 e5                	mov    %esp,%ebp
80105dc5:	83 ec 08             	sub    $0x8,%esp
80105dc8:	90                   	nop
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105dd0:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105dd7:	c7 04 c5 a2 61 12 80 	movl   $0x8e000008,-0x7fed9e5e(,%eax,8)
80105dde:	08 00 00 8e 
80105de2:	66 89 14 c5 a0 61 12 	mov    %dx,-0x7fed9e60(,%eax,8)
80105de9:	80 
80105dea:	c1 ea 10             	shr    $0x10,%edx
80105ded:	66 89 14 c5 a6 61 12 	mov    %dx,-0x7fed9e5a(,%eax,8)
80105df4:	80 
  for(i = 0; i < 256; i++)
80105df5:	83 c0 01             	add    $0x1,%eax
80105df8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105dfd:	75 d1                	jne    80105dd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dff:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

  initlock(&tickslock, "time");
80105e04:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e07:	c7 05 a2 63 12 80 08 	movl   $0xef000008,0x801263a2
80105e0e:	00 00 ef 
  initlock(&tickslock, "time");
80105e11:	68 19 82 10 80       	push   $0x80108219
80105e16:	68 60 61 12 80       	push   $0x80126160
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e1b:	66 a3 a0 63 12 80    	mov    %ax,0x801263a0
80105e21:	c1 e8 10             	shr    $0x10,%eax
80105e24:	66 a3 a6 63 12 80    	mov    %ax,0x801263a6
  initlock(&tickslock, "time");
80105e2a:	e8 d1 ea ff ff       	call   80104900 <initlock>
}
80105e2f:	83 c4 10             	add    $0x10,%esp
80105e32:	c9                   	leave  
80105e33:	c3                   	ret    
80105e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105e40 <idtinit>:

void
idtinit(void)
{
80105e40:	55                   	push   %ebp
  pd[0] = size-1;
80105e41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e46:	89 e5                	mov    %esp,%ebp
80105e48:	83 ec 10             	sub    $0x10,%esp
80105e4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e4f:	b8 a0 61 12 80       	mov    $0x801261a0,%eax
80105e54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e58:	c1 e8 10             	shr    $0x10,%eax
80105e5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e65:	c9                   	leave  
80105e66:	c3                   	ret    
80105e67:	89 f6                	mov    %esi,%esi
80105e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	57                   	push   %edi
80105e74:	56                   	push   %esi
80105e75:	53                   	push   %ebx
80105e76:	83 ec 1c             	sub    $0x1c,%esp
80105e79:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105e7c:	8b 47 30             	mov    0x30(%edi),%eax
80105e7f:	83 f8 40             	cmp    $0x40,%eax
80105e82:	0f 84 f0 00 00 00    	je     80105f78 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e88:	83 e8 20             	sub    $0x20,%eax
80105e8b:	83 f8 1f             	cmp    $0x1f,%eax
80105e8e:	77 10                	ja     80105ea0 <trap+0x30>
80105e90:	ff 24 85 c0 82 10 80 	jmp    *-0x7fef7d40(,%eax,4)
80105e97:	89 f6                	mov    %esi,%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    //TODO CASE TRAP 14 PGFLT IF IN SWITCH FILE: BRING FROM THERE, ELSE GO DEFAULT

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ea0:	e8 bb dd ff ff       	call   80103c60 <myproc>
80105ea5:	85 c0                	test   %eax,%eax
80105ea7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105eaa:	0f 84 14 02 00 00    	je     801060c4 <trap+0x254>
80105eb0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105eb4:	0f 84 0a 02 00 00    	je     801060c4 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105eba:	0f 20 d1             	mov    %cr2,%ecx
80105ebd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ec0:	e8 7b dd ff ff       	call   80103c40 <cpuid>
80105ec5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ec8:	8b 47 34             	mov    0x34(%edi),%eax
80105ecb:	8b 77 30             	mov    0x30(%edi),%esi
80105ece:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105ed1:	e8 8a dd ff ff       	call   80103c60 <myproc>
80105ed6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ed9:	e8 82 dd ff ff       	call   80103c60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ede:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ee1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ee4:	51                   	push   %ecx
80105ee5:	53                   	push   %ebx
80105ee6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105ee7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eea:	ff 75 e4             	pushl  -0x1c(%ebp)
80105eed:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105eee:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ef1:	52                   	push   %edx
80105ef2:	ff 70 10             	pushl  0x10(%eax)
80105ef5:	68 7c 82 10 80       	push   $0x8010827c
80105efa:	e8 61 a7 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105eff:	83 c4 20             	add    $0x20,%esp
80105f02:	e8 59 dd ff ff       	call   80103c60 <myproc>
80105f07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f0e:	e8 4d dd ff ff       	call   80103c60 <myproc>
80105f13:	85 c0                	test   %eax,%eax
80105f15:	74 1d                	je     80105f34 <trap+0xc4>
80105f17:	e8 44 dd ff ff       	call   80103c60 <myproc>
80105f1c:	8b 50 24             	mov    0x24(%eax),%edx
80105f1f:	85 d2                	test   %edx,%edx
80105f21:	74 11                	je     80105f34 <trap+0xc4>
80105f23:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f27:	83 e0 03             	and    $0x3,%eax
80105f2a:	66 83 f8 03          	cmp    $0x3,%ax
80105f2e:	0f 84 4c 01 00 00    	je     80106080 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105f34:	e8 27 dd ff ff       	call   80103c60 <myproc>
80105f39:	85 c0                	test   %eax,%eax
80105f3b:	74 0b                	je     80105f48 <trap+0xd8>
80105f3d:	e8 1e dd ff ff       	call   80103c60 <myproc>
80105f42:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f46:	74 68                	je     80105fb0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f48:	e8 13 dd ff ff       	call   80103c60 <myproc>
80105f4d:	85 c0                	test   %eax,%eax
80105f4f:	74 19                	je     80105f6a <trap+0xfa>
80105f51:	e8 0a dd ff ff       	call   80103c60 <myproc>
80105f56:	8b 40 24             	mov    0x24(%eax),%eax
80105f59:	85 c0                	test   %eax,%eax
80105f5b:	74 0d                	je     80105f6a <trap+0xfa>
80105f5d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f61:	83 e0 03             	and    $0x3,%eax
80105f64:	66 83 f8 03          	cmp    $0x3,%ax
80105f68:	74 37                	je     80105fa1 <trap+0x131>
    exit();
}
80105f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f6d:	5b                   	pop    %ebx
80105f6e:	5e                   	pop    %esi
80105f6f:	5f                   	pop    %edi
80105f70:	5d                   	pop    %ebp
80105f71:	c3                   	ret    
80105f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105f78:	e8 e3 dc ff ff       	call   80103c60 <myproc>
80105f7d:	8b 58 24             	mov    0x24(%eax),%ebx
80105f80:	85 db                	test   %ebx,%ebx
80105f82:	0f 85 e8 00 00 00    	jne    80106070 <trap+0x200>
    myproc()->tf = tf;
80105f88:	e8 d3 dc ff ff       	call   80103c60 <myproc>
80105f8d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105f90:	e8 cb ef ff ff       	call   80104f60 <syscall>
    if(myproc()->killed)
80105f95:	e8 c6 dc ff ff       	call   80103c60 <myproc>
80105f9a:	8b 48 24             	mov    0x24(%eax),%ecx
80105f9d:	85 c9                	test   %ecx,%ecx
80105f9f:	74 c9                	je     80105f6a <trap+0xfa>
}
80105fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fa4:	5b                   	pop    %ebx
80105fa5:	5e                   	pop    %esi
80105fa6:	5f                   	pop    %edi
80105fa7:	5d                   	pop    %ebp
      exit();
80105fa8:	e9 83 e2 ff ff       	jmp    80104230 <exit>
80105fad:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105fb0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105fb4:	75 92                	jne    80105f48 <trap+0xd8>
    yield();
80105fb6:	e8 c5 e3 ff ff       	call   80104380 <yield>
80105fbb:	eb 8b                	jmp    80105f48 <trap+0xd8>
80105fbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105fc0:	e8 7b dc ff ff       	call   80103c40 <cpuid>
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	0f 84 c3 00 00 00    	je     80106090 <trap+0x220>
    lapiceoi();
80105fcd:	e8 4e cb ff ff       	call   80102b20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fd2:	e8 89 dc ff ff       	call   80103c60 <myproc>
80105fd7:	85 c0                	test   %eax,%eax
80105fd9:	0f 85 38 ff ff ff    	jne    80105f17 <trap+0xa7>
80105fdf:	e9 50 ff ff ff       	jmp    80105f34 <trap+0xc4>
80105fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fe8:	e8 f3 c9 ff ff       	call   801029e0 <kbdintr>
    lapiceoi();
80105fed:	e8 2e cb ff ff       	call   80102b20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ff2:	e8 69 dc ff ff       	call   80103c60 <myproc>
80105ff7:	85 c0                	test   %eax,%eax
80105ff9:	0f 85 18 ff ff ff    	jne    80105f17 <trap+0xa7>
80105fff:	e9 30 ff ff ff       	jmp    80105f34 <trap+0xc4>
80106004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106008:	e8 53 02 00 00       	call   80106260 <uartintr>
    lapiceoi();
8010600d:	e8 0e cb ff ff       	call   80102b20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106012:	e8 49 dc ff ff       	call   80103c60 <myproc>
80106017:	85 c0                	test   %eax,%eax
80106019:	0f 85 f8 fe ff ff    	jne    80105f17 <trap+0xa7>
8010601f:	e9 10 ff ff ff       	jmp    80105f34 <trap+0xc4>
80106024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106028:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010602c:	8b 77 38             	mov    0x38(%edi),%esi
8010602f:	e8 0c dc ff ff       	call   80103c40 <cpuid>
80106034:	56                   	push   %esi
80106035:	53                   	push   %ebx
80106036:	50                   	push   %eax
80106037:	68 24 82 10 80       	push   $0x80108224
8010603c:	e8 1f a6 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106041:	e8 da ca ff ff       	call   80102b20 <lapiceoi>
    break;
80106046:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106049:	e8 12 dc ff ff       	call   80103c60 <myproc>
8010604e:	85 c0                	test   %eax,%eax
80106050:	0f 85 c1 fe ff ff    	jne    80105f17 <trap+0xa7>
80106056:	e9 d9 fe ff ff       	jmp    80105f34 <trap+0xc4>
8010605b:	90                   	nop
8010605c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106060:	e8 eb c3 ff ff       	call   80102450 <ideintr>
80106065:	e9 63 ff ff ff       	jmp    80105fcd <trap+0x15d>
8010606a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106070:	e8 bb e1 ff ff       	call   80104230 <exit>
80106075:	e9 0e ff ff ff       	jmp    80105f88 <trap+0x118>
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106080:	e8 ab e1 ff ff       	call   80104230 <exit>
80106085:	e9 aa fe ff ff       	jmp    80105f34 <trap+0xc4>
8010608a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	68 60 61 12 80       	push   $0x80126160
80106098:	e8 53 e9 ff ff       	call   801049f0 <acquire>
      wakeup(&ticks);
8010609d:	c7 04 24 a0 69 12 80 	movl   $0x801269a0,(%esp)
      ticks++;
801060a4:	83 05 a0 69 12 80 01 	addl   $0x1,0x801269a0
      wakeup(&ticks);
801060ab:	e8 90 e5 ff ff       	call   80104640 <wakeup>
      release(&tickslock);
801060b0:	c7 04 24 60 61 12 80 	movl   $0x80126160,(%esp)
801060b7:	e8 54 ea ff ff       	call   80104b10 <release>
801060bc:	83 c4 10             	add    $0x10,%esp
801060bf:	e9 09 ff ff ff       	jmp    80105fcd <trap+0x15d>
801060c4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060c7:	e8 74 db ff ff       	call   80103c40 <cpuid>
801060cc:	83 ec 0c             	sub    $0xc,%esp
801060cf:	56                   	push   %esi
801060d0:	53                   	push   %ebx
801060d1:	50                   	push   %eax
801060d2:	ff 77 30             	pushl  0x30(%edi)
801060d5:	68 48 82 10 80       	push   $0x80108248
801060da:	e8 81 a5 ff ff       	call   80100660 <cprintf>
      panic("trap");
801060df:	83 c4 14             	add    $0x14,%esp
801060e2:	68 1e 82 10 80       	push   $0x8010821e
801060e7:	e8 a4 a2 ff ff       	call   80100390 <panic>
801060ec:	66 90                	xchg   %ax,%ax
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060f0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
801060f5:	55                   	push   %ebp
801060f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060f8:	85 c0                	test   %eax,%eax
801060fa:	74 1c                	je     80106118 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106101:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106102:	a8 01                	test   $0x1,%al
80106104:	74 12                	je     80106118 <uartgetc+0x28>
80106106:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010610b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010610c:	0f b6 c0             	movzbl %al,%eax
}
8010610f:	5d                   	pop    %ebp
80106110:	c3                   	ret    
80106111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010611d:	5d                   	pop    %ebp
8010611e:	c3                   	ret    
8010611f:	90                   	nop

80106120 <uartputc.part.0>:
uartputc(int c)
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	57                   	push   %edi
80106124:	56                   	push   %esi
80106125:	53                   	push   %ebx
80106126:	89 c7                	mov    %eax,%edi
80106128:	bb 80 00 00 00       	mov    $0x80,%ebx
8010612d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106132:	83 ec 0c             	sub    $0xc,%esp
80106135:	eb 1b                	jmp    80106152 <uartputc.part.0+0x32>
80106137:	89 f6                	mov    %esi,%esi
80106139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106140:	83 ec 0c             	sub    $0xc,%esp
80106143:	6a 0a                	push   $0xa
80106145:	e8 f6 c9 ff ff       	call   80102b40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010614a:	83 c4 10             	add    $0x10,%esp
8010614d:	83 eb 01             	sub    $0x1,%ebx
80106150:	74 07                	je     80106159 <uartputc.part.0+0x39>
80106152:	89 f2                	mov    %esi,%edx
80106154:	ec                   	in     (%dx),%al
80106155:	a8 20                	test   $0x20,%al
80106157:	74 e7                	je     80106140 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106159:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010615e:	89 f8                	mov    %edi,%eax
80106160:	ee                   	out    %al,(%dx)
}
80106161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106164:	5b                   	pop    %ebx
80106165:	5e                   	pop    %esi
80106166:	5f                   	pop    %edi
80106167:	5d                   	pop    %ebp
80106168:	c3                   	ret    
80106169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106170 <uartinit>:
{
80106170:	55                   	push   %ebp
80106171:	31 c9                	xor    %ecx,%ecx
80106173:	89 c8                	mov    %ecx,%eax
80106175:	89 e5                	mov    %esp,%ebp
80106177:	57                   	push   %edi
80106178:	56                   	push   %esi
80106179:	53                   	push   %ebx
8010617a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010617f:	89 da                	mov    %ebx,%edx
80106181:	83 ec 0c             	sub    $0xc,%esp
80106184:	ee                   	out    %al,(%dx)
80106185:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010618a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010618f:	89 fa                	mov    %edi,%edx
80106191:	ee                   	out    %al,(%dx)
80106192:	b8 0c 00 00 00       	mov    $0xc,%eax
80106197:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010619c:	ee                   	out    %al,(%dx)
8010619d:	be f9 03 00 00       	mov    $0x3f9,%esi
801061a2:	89 c8                	mov    %ecx,%eax
801061a4:	89 f2                	mov    %esi,%edx
801061a6:	ee                   	out    %al,(%dx)
801061a7:	b8 03 00 00 00       	mov    $0x3,%eax
801061ac:	89 fa                	mov    %edi,%edx
801061ae:	ee                   	out    %al,(%dx)
801061af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801061b4:	89 c8                	mov    %ecx,%eax
801061b6:	ee                   	out    %al,(%dx)
801061b7:	b8 01 00 00 00       	mov    $0x1,%eax
801061bc:	89 f2                	mov    %esi,%edx
801061be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801061c5:	3c ff                	cmp    $0xff,%al
801061c7:	74 5a                	je     80106223 <uartinit+0xb3>
  uart = 1;
801061c9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801061d0:	00 00 00 
801061d3:	89 da                	mov    %ebx,%edx
801061d5:	ec                   	in     (%dx),%al
801061d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061db:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801061dc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801061df:	bb 40 83 10 80       	mov    $0x80108340,%ebx
  ioapicenable(IRQ_COM1, 0);
801061e4:	6a 00                	push   $0x0
801061e6:	6a 04                	push   $0x4
801061e8:	e8 b3 c4 ff ff       	call   801026a0 <ioapicenable>
801061ed:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801061f0:	b8 78 00 00 00       	mov    $0x78,%eax
801061f5:	eb 13                	jmp    8010620a <uartinit+0x9a>
801061f7:	89 f6                	mov    %esi,%esi
801061f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106200:	83 c3 01             	add    $0x1,%ebx
80106203:	0f be 03             	movsbl (%ebx),%eax
80106206:	84 c0                	test   %al,%al
80106208:	74 19                	je     80106223 <uartinit+0xb3>
  if(!uart)
8010620a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106210:	85 d2                	test   %edx,%edx
80106212:	74 ec                	je     80106200 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106214:	83 c3 01             	add    $0x1,%ebx
80106217:	e8 04 ff ff ff       	call   80106120 <uartputc.part.0>
8010621c:	0f be 03             	movsbl (%ebx),%eax
8010621f:	84 c0                	test   %al,%al
80106221:	75 e7                	jne    8010620a <uartinit+0x9a>
}
80106223:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106226:	5b                   	pop    %ebx
80106227:	5e                   	pop    %esi
80106228:	5f                   	pop    %edi
80106229:	5d                   	pop    %ebp
8010622a:	c3                   	ret    
8010622b:	90                   	nop
8010622c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106230 <uartputc>:
  if(!uart)
80106230:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106236:	55                   	push   %ebp
80106237:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106239:	85 d2                	test   %edx,%edx
{
8010623b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010623e:	74 10                	je     80106250 <uartputc+0x20>
}
80106240:	5d                   	pop    %ebp
80106241:	e9 da fe ff ff       	jmp    80106120 <uartputc.part.0>
80106246:	8d 76 00             	lea    0x0(%esi),%esi
80106249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106250:	5d                   	pop    %ebp
80106251:	c3                   	ret    
80106252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106260 <uartintr>:

void
uartintr(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106266:	68 f0 60 10 80       	push   $0x801060f0
8010626b:	e8 a0 a5 ff ff       	call   80100810 <consoleintr>
}
80106270:	83 c4 10             	add    $0x10,%esp
80106273:	c9                   	leave  
80106274:	c3                   	ret    

80106275 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $0
80106277:	6a 00                	push   $0x0
  jmp alltraps
80106279:	e9 1c fb ff ff       	jmp    80105d9a <alltraps>

8010627e <vector1>:
.globl vector1
vector1:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $1
80106280:	6a 01                	push   $0x1
  jmp alltraps
80106282:	e9 13 fb ff ff       	jmp    80105d9a <alltraps>

80106287 <vector2>:
.globl vector2
vector2:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $2
80106289:	6a 02                	push   $0x2
  jmp alltraps
8010628b:	e9 0a fb ff ff       	jmp    80105d9a <alltraps>

80106290 <vector3>:
.globl vector3
vector3:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $3
80106292:	6a 03                	push   $0x3
  jmp alltraps
80106294:	e9 01 fb ff ff       	jmp    80105d9a <alltraps>

80106299 <vector4>:
.globl vector4
vector4:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $4
8010629b:	6a 04                	push   $0x4
  jmp alltraps
8010629d:	e9 f8 fa ff ff       	jmp    80105d9a <alltraps>

801062a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $5
801062a4:	6a 05                	push   $0x5
  jmp alltraps
801062a6:	e9 ef fa ff ff       	jmp    80105d9a <alltraps>

801062ab <vector6>:
.globl vector6
vector6:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $6
801062ad:	6a 06                	push   $0x6
  jmp alltraps
801062af:	e9 e6 fa ff ff       	jmp    80105d9a <alltraps>

801062b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $7
801062b6:	6a 07                	push   $0x7
  jmp alltraps
801062b8:	e9 dd fa ff ff       	jmp    80105d9a <alltraps>

801062bd <vector8>:
.globl vector8
vector8:
  pushl $8
801062bd:	6a 08                	push   $0x8
  jmp alltraps
801062bf:	e9 d6 fa ff ff       	jmp    80105d9a <alltraps>

801062c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $9
801062c6:	6a 09                	push   $0x9
  jmp alltraps
801062c8:	e9 cd fa ff ff       	jmp    80105d9a <alltraps>

801062cd <vector10>:
.globl vector10
vector10:
  pushl $10
801062cd:	6a 0a                	push   $0xa
  jmp alltraps
801062cf:	e9 c6 fa ff ff       	jmp    80105d9a <alltraps>

801062d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062d4:	6a 0b                	push   $0xb
  jmp alltraps
801062d6:	e9 bf fa ff ff       	jmp    80105d9a <alltraps>

801062db <vector12>:
.globl vector12
vector12:
  pushl $12
801062db:	6a 0c                	push   $0xc
  jmp alltraps
801062dd:	e9 b8 fa ff ff       	jmp    80105d9a <alltraps>

801062e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062e2:	6a 0d                	push   $0xd
  jmp alltraps
801062e4:	e9 b1 fa ff ff       	jmp    80105d9a <alltraps>

801062e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062e9:	6a 0e                	push   $0xe
  jmp alltraps
801062eb:	e9 aa fa ff ff       	jmp    80105d9a <alltraps>

801062f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $15
801062f2:	6a 0f                	push   $0xf
  jmp alltraps
801062f4:	e9 a1 fa ff ff       	jmp    80105d9a <alltraps>

801062f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $16
801062fb:	6a 10                	push   $0x10
  jmp alltraps
801062fd:	e9 98 fa ff ff       	jmp    80105d9a <alltraps>

80106302 <vector17>:
.globl vector17
vector17:
  pushl $17
80106302:	6a 11                	push   $0x11
  jmp alltraps
80106304:	e9 91 fa ff ff       	jmp    80105d9a <alltraps>

80106309 <vector18>:
.globl vector18
vector18:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $18
8010630b:	6a 12                	push   $0x12
  jmp alltraps
8010630d:	e9 88 fa ff ff       	jmp    80105d9a <alltraps>

80106312 <vector19>:
.globl vector19
vector19:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $19
80106314:	6a 13                	push   $0x13
  jmp alltraps
80106316:	e9 7f fa ff ff       	jmp    80105d9a <alltraps>

8010631b <vector20>:
.globl vector20
vector20:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $20
8010631d:	6a 14                	push   $0x14
  jmp alltraps
8010631f:	e9 76 fa ff ff       	jmp    80105d9a <alltraps>

80106324 <vector21>:
.globl vector21
vector21:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $21
80106326:	6a 15                	push   $0x15
  jmp alltraps
80106328:	e9 6d fa ff ff       	jmp    80105d9a <alltraps>

8010632d <vector22>:
.globl vector22
vector22:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $22
8010632f:	6a 16                	push   $0x16
  jmp alltraps
80106331:	e9 64 fa ff ff       	jmp    80105d9a <alltraps>

80106336 <vector23>:
.globl vector23
vector23:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $23
80106338:	6a 17                	push   $0x17
  jmp alltraps
8010633a:	e9 5b fa ff ff       	jmp    80105d9a <alltraps>

8010633f <vector24>:
.globl vector24
vector24:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $24
80106341:	6a 18                	push   $0x18
  jmp alltraps
80106343:	e9 52 fa ff ff       	jmp    80105d9a <alltraps>

80106348 <vector25>:
.globl vector25
vector25:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $25
8010634a:	6a 19                	push   $0x19
  jmp alltraps
8010634c:	e9 49 fa ff ff       	jmp    80105d9a <alltraps>

80106351 <vector26>:
.globl vector26
vector26:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $26
80106353:	6a 1a                	push   $0x1a
  jmp alltraps
80106355:	e9 40 fa ff ff       	jmp    80105d9a <alltraps>

8010635a <vector27>:
.globl vector27
vector27:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $27
8010635c:	6a 1b                	push   $0x1b
  jmp alltraps
8010635e:	e9 37 fa ff ff       	jmp    80105d9a <alltraps>

80106363 <vector28>:
.globl vector28
vector28:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $28
80106365:	6a 1c                	push   $0x1c
  jmp alltraps
80106367:	e9 2e fa ff ff       	jmp    80105d9a <alltraps>

8010636c <vector29>:
.globl vector29
vector29:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $29
8010636e:	6a 1d                	push   $0x1d
  jmp alltraps
80106370:	e9 25 fa ff ff       	jmp    80105d9a <alltraps>

80106375 <vector30>:
.globl vector30
vector30:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $30
80106377:	6a 1e                	push   $0x1e
  jmp alltraps
80106379:	e9 1c fa ff ff       	jmp    80105d9a <alltraps>

8010637e <vector31>:
.globl vector31
vector31:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $31
80106380:	6a 1f                	push   $0x1f
  jmp alltraps
80106382:	e9 13 fa ff ff       	jmp    80105d9a <alltraps>

80106387 <vector32>:
.globl vector32
vector32:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $32
80106389:	6a 20                	push   $0x20
  jmp alltraps
8010638b:	e9 0a fa ff ff       	jmp    80105d9a <alltraps>

80106390 <vector33>:
.globl vector33
vector33:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $33
80106392:	6a 21                	push   $0x21
  jmp alltraps
80106394:	e9 01 fa ff ff       	jmp    80105d9a <alltraps>

80106399 <vector34>:
.globl vector34
vector34:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $34
8010639b:	6a 22                	push   $0x22
  jmp alltraps
8010639d:	e9 f8 f9 ff ff       	jmp    80105d9a <alltraps>

801063a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $35
801063a4:	6a 23                	push   $0x23
  jmp alltraps
801063a6:	e9 ef f9 ff ff       	jmp    80105d9a <alltraps>

801063ab <vector36>:
.globl vector36
vector36:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $36
801063ad:	6a 24                	push   $0x24
  jmp alltraps
801063af:	e9 e6 f9 ff ff       	jmp    80105d9a <alltraps>

801063b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $37
801063b6:	6a 25                	push   $0x25
  jmp alltraps
801063b8:	e9 dd f9 ff ff       	jmp    80105d9a <alltraps>

801063bd <vector38>:
.globl vector38
vector38:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $38
801063bf:	6a 26                	push   $0x26
  jmp alltraps
801063c1:	e9 d4 f9 ff ff       	jmp    80105d9a <alltraps>

801063c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $39
801063c8:	6a 27                	push   $0x27
  jmp alltraps
801063ca:	e9 cb f9 ff ff       	jmp    80105d9a <alltraps>

801063cf <vector40>:
.globl vector40
vector40:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $40
801063d1:	6a 28                	push   $0x28
  jmp alltraps
801063d3:	e9 c2 f9 ff ff       	jmp    80105d9a <alltraps>

801063d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $41
801063da:	6a 29                	push   $0x29
  jmp alltraps
801063dc:	e9 b9 f9 ff ff       	jmp    80105d9a <alltraps>

801063e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $42
801063e3:	6a 2a                	push   $0x2a
  jmp alltraps
801063e5:	e9 b0 f9 ff ff       	jmp    80105d9a <alltraps>

801063ea <vector43>:
.globl vector43
vector43:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $43
801063ec:	6a 2b                	push   $0x2b
  jmp alltraps
801063ee:	e9 a7 f9 ff ff       	jmp    80105d9a <alltraps>

801063f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $44
801063f5:	6a 2c                	push   $0x2c
  jmp alltraps
801063f7:	e9 9e f9 ff ff       	jmp    80105d9a <alltraps>

801063fc <vector45>:
.globl vector45
vector45:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $45
801063fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106400:	e9 95 f9 ff ff       	jmp    80105d9a <alltraps>

80106405 <vector46>:
.globl vector46
vector46:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $46
80106407:	6a 2e                	push   $0x2e
  jmp alltraps
80106409:	e9 8c f9 ff ff       	jmp    80105d9a <alltraps>

8010640e <vector47>:
.globl vector47
vector47:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $47
80106410:	6a 2f                	push   $0x2f
  jmp alltraps
80106412:	e9 83 f9 ff ff       	jmp    80105d9a <alltraps>

80106417 <vector48>:
.globl vector48
vector48:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $48
80106419:	6a 30                	push   $0x30
  jmp alltraps
8010641b:	e9 7a f9 ff ff       	jmp    80105d9a <alltraps>

80106420 <vector49>:
.globl vector49
vector49:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $49
80106422:	6a 31                	push   $0x31
  jmp alltraps
80106424:	e9 71 f9 ff ff       	jmp    80105d9a <alltraps>

80106429 <vector50>:
.globl vector50
vector50:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $50
8010642b:	6a 32                	push   $0x32
  jmp alltraps
8010642d:	e9 68 f9 ff ff       	jmp    80105d9a <alltraps>

80106432 <vector51>:
.globl vector51
vector51:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $51
80106434:	6a 33                	push   $0x33
  jmp alltraps
80106436:	e9 5f f9 ff ff       	jmp    80105d9a <alltraps>

8010643b <vector52>:
.globl vector52
vector52:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $52
8010643d:	6a 34                	push   $0x34
  jmp alltraps
8010643f:	e9 56 f9 ff ff       	jmp    80105d9a <alltraps>

80106444 <vector53>:
.globl vector53
vector53:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $53
80106446:	6a 35                	push   $0x35
  jmp alltraps
80106448:	e9 4d f9 ff ff       	jmp    80105d9a <alltraps>

8010644d <vector54>:
.globl vector54
vector54:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $54
8010644f:	6a 36                	push   $0x36
  jmp alltraps
80106451:	e9 44 f9 ff ff       	jmp    80105d9a <alltraps>

80106456 <vector55>:
.globl vector55
vector55:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $55
80106458:	6a 37                	push   $0x37
  jmp alltraps
8010645a:	e9 3b f9 ff ff       	jmp    80105d9a <alltraps>

8010645f <vector56>:
.globl vector56
vector56:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $56
80106461:	6a 38                	push   $0x38
  jmp alltraps
80106463:	e9 32 f9 ff ff       	jmp    80105d9a <alltraps>

80106468 <vector57>:
.globl vector57
vector57:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $57
8010646a:	6a 39                	push   $0x39
  jmp alltraps
8010646c:	e9 29 f9 ff ff       	jmp    80105d9a <alltraps>

80106471 <vector58>:
.globl vector58
vector58:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $58
80106473:	6a 3a                	push   $0x3a
  jmp alltraps
80106475:	e9 20 f9 ff ff       	jmp    80105d9a <alltraps>

8010647a <vector59>:
.globl vector59
vector59:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $59
8010647c:	6a 3b                	push   $0x3b
  jmp alltraps
8010647e:	e9 17 f9 ff ff       	jmp    80105d9a <alltraps>

80106483 <vector60>:
.globl vector60
vector60:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $60
80106485:	6a 3c                	push   $0x3c
  jmp alltraps
80106487:	e9 0e f9 ff ff       	jmp    80105d9a <alltraps>

8010648c <vector61>:
.globl vector61
vector61:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $61
8010648e:	6a 3d                	push   $0x3d
  jmp alltraps
80106490:	e9 05 f9 ff ff       	jmp    80105d9a <alltraps>

80106495 <vector62>:
.globl vector62
vector62:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $62
80106497:	6a 3e                	push   $0x3e
  jmp alltraps
80106499:	e9 fc f8 ff ff       	jmp    80105d9a <alltraps>

8010649e <vector63>:
.globl vector63
vector63:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $63
801064a0:	6a 3f                	push   $0x3f
  jmp alltraps
801064a2:	e9 f3 f8 ff ff       	jmp    80105d9a <alltraps>

801064a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $64
801064a9:	6a 40                	push   $0x40
  jmp alltraps
801064ab:	e9 ea f8 ff ff       	jmp    80105d9a <alltraps>

801064b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $65
801064b2:	6a 41                	push   $0x41
  jmp alltraps
801064b4:	e9 e1 f8 ff ff       	jmp    80105d9a <alltraps>

801064b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $66
801064bb:	6a 42                	push   $0x42
  jmp alltraps
801064bd:	e9 d8 f8 ff ff       	jmp    80105d9a <alltraps>

801064c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $67
801064c4:	6a 43                	push   $0x43
  jmp alltraps
801064c6:	e9 cf f8 ff ff       	jmp    80105d9a <alltraps>

801064cb <vector68>:
.globl vector68
vector68:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $68
801064cd:	6a 44                	push   $0x44
  jmp alltraps
801064cf:	e9 c6 f8 ff ff       	jmp    80105d9a <alltraps>

801064d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $69
801064d6:	6a 45                	push   $0x45
  jmp alltraps
801064d8:	e9 bd f8 ff ff       	jmp    80105d9a <alltraps>

801064dd <vector70>:
.globl vector70
vector70:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $70
801064df:	6a 46                	push   $0x46
  jmp alltraps
801064e1:	e9 b4 f8 ff ff       	jmp    80105d9a <alltraps>

801064e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $71
801064e8:	6a 47                	push   $0x47
  jmp alltraps
801064ea:	e9 ab f8 ff ff       	jmp    80105d9a <alltraps>

801064ef <vector72>:
.globl vector72
vector72:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $72
801064f1:	6a 48                	push   $0x48
  jmp alltraps
801064f3:	e9 a2 f8 ff ff       	jmp    80105d9a <alltraps>

801064f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $73
801064fa:	6a 49                	push   $0x49
  jmp alltraps
801064fc:	e9 99 f8 ff ff       	jmp    80105d9a <alltraps>

80106501 <vector74>:
.globl vector74
vector74:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $74
80106503:	6a 4a                	push   $0x4a
  jmp alltraps
80106505:	e9 90 f8 ff ff       	jmp    80105d9a <alltraps>

8010650a <vector75>:
.globl vector75
vector75:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $75
8010650c:	6a 4b                	push   $0x4b
  jmp alltraps
8010650e:	e9 87 f8 ff ff       	jmp    80105d9a <alltraps>

80106513 <vector76>:
.globl vector76
vector76:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $76
80106515:	6a 4c                	push   $0x4c
  jmp alltraps
80106517:	e9 7e f8 ff ff       	jmp    80105d9a <alltraps>

8010651c <vector77>:
.globl vector77
vector77:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $77
8010651e:	6a 4d                	push   $0x4d
  jmp alltraps
80106520:	e9 75 f8 ff ff       	jmp    80105d9a <alltraps>

80106525 <vector78>:
.globl vector78
vector78:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $78
80106527:	6a 4e                	push   $0x4e
  jmp alltraps
80106529:	e9 6c f8 ff ff       	jmp    80105d9a <alltraps>

8010652e <vector79>:
.globl vector79
vector79:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $79
80106530:	6a 4f                	push   $0x4f
  jmp alltraps
80106532:	e9 63 f8 ff ff       	jmp    80105d9a <alltraps>

80106537 <vector80>:
.globl vector80
vector80:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $80
80106539:	6a 50                	push   $0x50
  jmp alltraps
8010653b:	e9 5a f8 ff ff       	jmp    80105d9a <alltraps>

80106540 <vector81>:
.globl vector81
vector81:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $81
80106542:	6a 51                	push   $0x51
  jmp alltraps
80106544:	e9 51 f8 ff ff       	jmp    80105d9a <alltraps>

80106549 <vector82>:
.globl vector82
vector82:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $82
8010654b:	6a 52                	push   $0x52
  jmp alltraps
8010654d:	e9 48 f8 ff ff       	jmp    80105d9a <alltraps>

80106552 <vector83>:
.globl vector83
vector83:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $83
80106554:	6a 53                	push   $0x53
  jmp alltraps
80106556:	e9 3f f8 ff ff       	jmp    80105d9a <alltraps>

8010655b <vector84>:
.globl vector84
vector84:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $84
8010655d:	6a 54                	push   $0x54
  jmp alltraps
8010655f:	e9 36 f8 ff ff       	jmp    80105d9a <alltraps>

80106564 <vector85>:
.globl vector85
vector85:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $85
80106566:	6a 55                	push   $0x55
  jmp alltraps
80106568:	e9 2d f8 ff ff       	jmp    80105d9a <alltraps>

8010656d <vector86>:
.globl vector86
vector86:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $86
8010656f:	6a 56                	push   $0x56
  jmp alltraps
80106571:	e9 24 f8 ff ff       	jmp    80105d9a <alltraps>

80106576 <vector87>:
.globl vector87
vector87:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $87
80106578:	6a 57                	push   $0x57
  jmp alltraps
8010657a:	e9 1b f8 ff ff       	jmp    80105d9a <alltraps>

8010657f <vector88>:
.globl vector88
vector88:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $88
80106581:	6a 58                	push   $0x58
  jmp alltraps
80106583:	e9 12 f8 ff ff       	jmp    80105d9a <alltraps>

80106588 <vector89>:
.globl vector89
vector89:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $89
8010658a:	6a 59                	push   $0x59
  jmp alltraps
8010658c:	e9 09 f8 ff ff       	jmp    80105d9a <alltraps>

80106591 <vector90>:
.globl vector90
vector90:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $90
80106593:	6a 5a                	push   $0x5a
  jmp alltraps
80106595:	e9 00 f8 ff ff       	jmp    80105d9a <alltraps>

8010659a <vector91>:
.globl vector91
vector91:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $91
8010659c:	6a 5b                	push   $0x5b
  jmp alltraps
8010659e:	e9 f7 f7 ff ff       	jmp    80105d9a <alltraps>

801065a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $92
801065a5:	6a 5c                	push   $0x5c
  jmp alltraps
801065a7:	e9 ee f7 ff ff       	jmp    80105d9a <alltraps>

801065ac <vector93>:
.globl vector93
vector93:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $93
801065ae:	6a 5d                	push   $0x5d
  jmp alltraps
801065b0:	e9 e5 f7 ff ff       	jmp    80105d9a <alltraps>

801065b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $94
801065b7:	6a 5e                	push   $0x5e
  jmp alltraps
801065b9:	e9 dc f7 ff ff       	jmp    80105d9a <alltraps>

801065be <vector95>:
.globl vector95
vector95:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $95
801065c0:	6a 5f                	push   $0x5f
  jmp alltraps
801065c2:	e9 d3 f7 ff ff       	jmp    80105d9a <alltraps>

801065c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $96
801065c9:	6a 60                	push   $0x60
  jmp alltraps
801065cb:	e9 ca f7 ff ff       	jmp    80105d9a <alltraps>

801065d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $97
801065d2:	6a 61                	push   $0x61
  jmp alltraps
801065d4:	e9 c1 f7 ff ff       	jmp    80105d9a <alltraps>

801065d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $98
801065db:	6a 62                	push   $0x62
  jmp alltraps
801065dd:	e9 b8 f7 ff ff       	jmp    80105d9a <alltraps>

801065e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $99
801065e4:	6a 63                	push   $0x63
  jmp alltraps
801065e6:	e9 af f7 ff ff       	jmp    80105d9a <alltraps>

801065eb <vector100>:
.globl vector100
vector100:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $100
801065ed:	6a 64                	push   $0x64
  jmp alltraps
801065ef:	e9 a6 f7 ff ff       	jmp    80105d9a <alltraps>

801065f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $101
801065f6:	6a 65                	push   $0x65
  jmp alltraps
801065f8:	e9 9d f7 ff ff       	jmp    80105d9a <alltraps>

801065fd <vector102>:
.globl vector102
vector102:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $102
801065ff:	6a 66                	push   $0x66
  jmp alltraps
80106601:	e9 94 f7 ff ff       	jmp    80105d9a <alltraps>

80106606 <vector103>:
.globl vector103
vector103:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $103
80106608:	6a 67                	push   $0x67
  jmp alltraps
8010660a:	e9 8b f7 ff ff       	jmp    80105d9a <alltraps>

8010660f <vector104>:
.globl vector104
vector104:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $104
80106611:	6a 68                	push   $0x68
  jmp alltraps
80106613:	e9 82 f7 ff ff       	jmp    80105d9a <alltraps>

80106618 <vector105>:
.globl vector105
vector105:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $105
8010661a:	6a 69                	push   $0x69
  jmp alltraps
8010661c:	e9 79 f7 ff ff       	jmp    80105d9a <alltraps>

80106621 <vector106>:
.globl vector106
vector106:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $106
80106623:	6a 6a                	push   $0x6a
  jmp alltraps
80106625:	e9 70 f7 ff ff       	jmp    80105d9a <alltraps>

8010662a <vector107>:
.globl vector107
vector107:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $107
8010662c:	6a 6b                	push   $0x6b
  jmp alltraps
8010662e:	e9 67 f7 ff ff       	jmp    80105d9a <alltraps>

80106633 <vector108>:
.globl vector108
vector108:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $108
80106635:	6a 6c                	push   $0x6c
  jmp alltraps
80106637:	e9 5e f7 ff ff       	jmp    80105d9a <alltraps>

8010663c <vector109>:
.globl vector109
vector109:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $109
8010663e:	6a 6d                	push   $0x6d
  jmp alltraps
80106640:	e9 55 f7 ff ff       	jmp    80105d9a <alltraps>

80106645 <vector110>:
.globl vector110
vector110:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $110
80106647:	6a 6e                	push   $0x6e
  jmp alltraps
80106649:	e9 4c f7 ff ff       	jmp    80105d9a <alltraps>

8010664e <vector111>:
.globl vector111
vector111:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $111
80106650:	6a 6f                	push   $0x6f
  jmp alltraps
80106652:	e9 43 f7 ff ff       	jmp    80105d9a <alltraps>

80106657 <vector112>:
.globl vector112
vector112:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $112
80106659:	6a 70                	push   $0x70
  jmp alltraps
8010665b:	e9 3a f7 ff ff       	jmp    80105d9a <alltraps>

80106660 <vector113>:
.globl vector113
vector113:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $113
80106662:	6a 71                	push   $0x71
  jmp alltraps
80106664:	e9 31 f7 ff ff       	jmp    80105d9a <alltraps>

80106669 <vector114>:
.globl vector114
vector114:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $114
8010666b:	6a 72                	push   $0x72
  jmp alltraps
8010666d:	e9 28 f7 ff ff       	jmp    80105d9a <alltraps>

80106672 <vector115>:
.globl vector115
vector115:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $115
80106674:	6a 73                	push   $0x73
  jmp alltraps
80106676:	e9 1f f7 ff ff       	jmp    80105d9a <alltraps>

8010667b <vector116>:
.globl vector116
vector116:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $116
8010667d:	6a 74                	push   $0x74
  jmp alltraps
8010667f:	e9 16 f7 ff ff       	jmp    80105d9a <alltraps>

80106684 <vector117>:
.globl vector117
vector117:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $117
80106686:	6a 75                	push   $0x75
  jmp alltraps
80106688:	e9 0d f7 ff ff       	jmp    80105d9a <alltraps>

8010668d <vector118>:
.globl vector118
vector118:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $118
8010668f:	6a 76                	push   $0x76
  jmp alltraps
80106691:	e9 04 f7 ff ff       	jmp    80105d9a <alltraps>

80106696 <vector119>:
.globl vector119
vector119:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $119
80106698:	6a 77                	push   $0x77
  jmp alltraps
8010669a:	e9 fb f6 ff ff       	jmp    80105d9a <alltraps>

8010669f <vector120>:
.globl vector120
vector120:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $120
801066a1:	6a 78                	push   $0x78
  jmp alltraps
801066a3:	e9 f2 f6 ff ff       	jmp    80105d9a <alltraps>

801066a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $121
801066aa:	6a 79                	push   $0x79
  jmp alltraps
801066ac:	e9 e9 f6 ff ff       	jmp    80105d9a <alltraps>

801066b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $122
801066b3:	6a 7a                	push   $0x7a
  jmp alltraps
801066b5:	e9 e0 f6 ff ff       	jmp    80105d9a <alltraps>

801066ba <vector123>:
.globl vector123
vector123:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $123
801066bc:	6a 7b                	push   $0x7b
  jmp alltraps
801066be:	e9 d7 f6 ff ff       	jmp    80105d9a <alltraps>

801066c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $124
801066c5:	6a 7c                	push   $0x7c
  jmp alltraps
801066c7:	e9 ce f6 ff ff       	jmp    80105d9a <alltraps>

801066cc <vector125>:
.globl vector125
vector125:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $125
801066ce:	6a 7d                	push   $0x7d
  jmp alltraps
801066d0:	e9 c5 f6 ff ff       	jmp    80105d9a <alltraps>

801066d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $126
801066d7:	6a 7e                	push   $0x7e
  jmp alltraps
801066d9:	e9 bc f6 ff ff       	jmp    80105d9a <alltraps>

801066de <vector127>:
.globl vector127
vector127:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $127
801066e0:	6a 7f                	push   $0x7f
  jmp alltraps
801066e2:	e9 b3 f6 ff ff       	jmp    80105d9a <alltraps>

801066e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $128
801066e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066ee:	e9 a7 f6 ff ff       	jmp    80105d9a <alltraps>

801066f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $129
801066f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066fa:	e9 9b f6 ff ff       	jmp    80105d9a <alltraps>

801066ff <vector130>:
.globl vector130
vector130:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $130
80106701:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106706:	e9 8f f6 ff ff       	jmp    80105d9a <alltraps>

8010670b <vector131>:
.globl vector131
vector131:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $131
8010670d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106712:	e9 83 f6 ff ff       	jmp    80105d9a <alltraps>

80106717 <vector132>:
.globl vector132
vector132:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $132
80106719:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010671e:	e9 77 f6 ff ff       	jmp    80105d9a <alltraps>

80106723 <vector133>:
.globl vector133
vector133:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $133
80106725:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010672a:	e9 6b f6 ff ff       	jmp    80105d9a <alltraps>

8010672f <vector134>:
.globl vector134
vector134:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $134
80106731:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106736:	e9 5f f6 ff ff       	jmp    80105d9a <alltraps>

8010673b <vector135>:
.globl vector135
vector135:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $135
8010673d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106742:	e9 53 f6 ff ff       	jmp    80105d9a <alltraps>

80106747 <vector136>:
.globl vector136
vector136:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $136
80106749:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010674e:	e9 47 f6 ff ff       	jmp    80105d9a <alltraps>

80106753 <vector137>:
.globl vector137
vector137:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $137
80106755:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010675a:	e9 3b f6 ff ff       	jmp    80105d9a <alltraps>

8010675f <vector138>:
.globl vector138
vector138:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $138
80106761:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106766:	e9 2f f6 ff ff       	jmp    80105d9a <alltraps>

8010676b <vector139>:
.globl vector139
vector139:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $139
8010676d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106772:	e9 23 f6 ff ff       	jmp    80105d9a <alltraps>

80106777 <vector140>:
.globl vector140
vector140:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $140
80106779:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010677e:	e9 17 f6 ff ff       	jmp    80105d9a <alltraps>

80106783 <vector141>:
.globl vector141
vector141:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $141
80106785:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010678a:	e9 0b f6 ff ff       	jmp    80105d9a <alltraps>

8010678f <vector142>:
.globl vector142
vector142:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $142
80106791:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106796:	e9 ff f5 ff ff       	jmp    80105d9a <alltraps>

8010679b <vector143>:
.globl vector143
vector143:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $143
8010679d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067a2:	e9 f3 f5 ff ff       	jmp    80105d9a <alltraps>

801067a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $144
801067a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067ae:	e9 e7 f5 ff ff       	jmp    80105d9a <alltraps>

801067b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $145
801067b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067ba:	e9 db f5 ff ff       	jmp    80105d9a <alltraps>

801067bf <vector146>:
.globl vector146
vector146:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $146
801067c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067c6:	e9 cf f5 ff ff       	jmp    80105d9a <alltraps>

801067cb <vector147>:
.globl vector147
vector147:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $147
801067cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067d2:	e9 c3 f5 ff ff       	jmp    80105d9a <alltraps>

801067d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $148
801067d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067de:	e9 b7 f5 ff ff       	jmp    80105d9a <alltraps>

801067e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $149
801067e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067ea:	e9 ab f5 ff ff       	jmp    80105d9a <alltraps>

801067ef <vector150>:
.globl vector150
vector150:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $150
801067f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067f6:	e9 9f f5 ff ff       	jmp    80105d9a <alltraps>

801067fb <vector151>:
.globl vector151
vector151:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $151
801067fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106802:	e9 93 f5 ff ff       	jmp    80105d9a <alltraps>

80106807 <vector152>:
.globl vector152
vector152:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $152
80106809:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010680e:	e9 87 f5 ff ff       	jmp    80105d9a <alltraps>

80106813 <vector153>:
.globl vector153
vector153:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $153
80106815:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010681a:	e9 7b f5 ff ff       	jmp    80105d9a <alltraps>

8010681f <vector154>:
.globl vector154
vector154:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $154
80106821:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106826:	e9 6f f5 ff ff       	jmp    80105d9a <alltraps>

8010682b <vector155>:
.globl vector155
vector155:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $155
8010682d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106832:	e9 63 f5 ff ff       	jmp    80105d9a <alltraps>

80106837 <vector156>:
.globl vector156
vector156:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $156
80106839:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010683e:	e9 57 f5 ff ff       	jmp    80105d9a <alltraps>

80106843 <vector157>:
.globl vector157
vector157:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $157
80106845:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010684a:	e9 4b f5 ff ff       	jmp    80105d9a <alltraps>

8010684f <vector158>:
.globl vector158
vector158:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $158
80106851:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106856:	e9 3f f5 ff ff       	jmp    80105d9a <alltraps>

8010685b <vector159>:
.globl vector159
vector159:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $159
8010685d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106862:	e9 33 f5 ff ff       	jmp    80105d9a <alltraps>

80106867 <vector160>:
.globl vector160
vector160:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $160
80106869:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010686e:	e9 27 f5 ff ff       	jmp    80105d9a <alltraps>

80106873 <vector161>:
.globl vector161
vector161:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $161
80106875:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010687a:	e9 1b f5 ff ff       	jmp    80105d9a <alltraps>

8010687f <vector162>:
.globl vector162
vector162:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $162
80106881:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106886:	e9 0f f5 ff ff       	jmp    80105d9a <alltraps>

8010688b <vector163>:
.globl vector163
vector163:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $163
8010688d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106892:	e9 03 f5 ff ff       	jmp    80105d9a <alltraps>

80106897 <vector164>:
.globl vector164
vector164:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $164
80106899:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010689e:	e9 f7 f4 ff ff       	jmp    80105d9a <alltraps>

801068a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $165
801068a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068aa:	e9 eb f4 ff ff       	jmp    80105d9a <alltraps>

801068af <vector166>:
.globl vector166
vector166:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $166
801068b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068b6:	e9 df f4 ff ff       	jmp    80105d9a <alltraps>

801068bb <vector167>:
.globl vector167
vector167:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $167
801068bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068c2:	e9 d3 f4 ff ff       	jmp    80105d9a <alltraps>

801068c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $168
801068c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068ce:	e9 c7 f4 ff ff       	jmp    80105d9a <alltraps>

801068d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $169
801068d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068da:	e9 bb f4 ff ff       	jmp    80105d9a <alltraps>

801068df <vector170>:
.globl vector170
vector170:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $170
801068e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068e6:	e9 af f4 ff ff       	jmp    80105d9a <alltraps>

801068eb <vector171>:
.globl vector171
vector171:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $171
801068ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068f2:	e9 a3 f4 ff ff       	jmp    80105d9a <alltraps>

801068f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $172
801068f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068fe:	e9 97 f4 ff ff       	jmp    80105d9a <alltraps>

80106903 <vector173>:
.globl vector173
vector173:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $173
80106905:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010690a:	e9 8b f4 ff ff       	jmp    80105d9a <alltraps>

8010690f <vector174>:
.globl vector174
vector174:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $174
80106911:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106916:	e9 7f f4 ff ff       	jmp    80105d9a <alltraps>

8010691b <vector175>:
.globl vector175
vector175:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $175
8010691d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106922:	e9 73 f4 ff ff       	jmp    80105d9a <alltraps>

80106927 <vector176>:
.globl vector176
vector176:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $176
80106929:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010692e:	e9 67 f4 ff ff       	jmp    80105d9a <alltraps>

80106933 <vector177>:
.globl vector177
vector177:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $177
80106935:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010693a:	e9 5b f4 ff ff       	jmp    80105d9a <alltraps>

8010693f <vector178>:
.globl vector178
vector178:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $178
80106941:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106946:	e9 4f f4 ff ff       	jmp    80105d9a <alltraps>

8010694b <vector179>:
.globl vector179
vector179:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $179
8010694d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106952:	e9 43 f4 ff ff       	jmp    80105d9a <alltraps>

80106957 <vector180>:
.globl vector180
vector180:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $180
80106959:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010695e:	e9 37 f4 ff ff       	jmp    80105d9a <alltraps>

80106963 <vector181>:
.globl vector181
vector181:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $181
80106965:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010696a:	e9 2b f4 ff ff       	jmp    80105d9a <alltraps>

8010696f <vector182>:
.globl vector182
vector182:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $182
80106971:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106976:	e9 1f f4 ff ff       	jmp    80105d9a <alltraps>

8010697b <vector183>:
.globl vector183
vector183:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $183
8010697d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106982:	e9 13 f4 ff ff       	jmp    80105d9a <alltraps>

80106987 <vector184>:
.globl vector184
vector184:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $184
80106989:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010698e:	e9 07 f4 ff ff       	jmp    80105d9a <alltraps>

80106993 <vector185>:
.globl vector185
vector185:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $185
80106995:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010699a:	e9 fb f3 ff ff       	jmp    80105d9a <alltraps>

8010699f <vector186>:
.globl vector186
vector186:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $186
801069a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069a6:	e9 ef f3 ff ff       	jmp    80105d9a <alltraps>

801069ab <vector187>:
.globl vector187
vector187:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $187
801069ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069b2:	e9 e3 f3 ff ff       	jmp    80105d9a <alltraps>

801069b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $188
801069b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069be:	e9 d7 f3 ff ff       	jmp    80105d9a <alltraps>

801069c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $189
801069c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069ca:	e9 cb f3 ff ff       	jmp    80105d9a <alltraps>

801069cf <vector190>:
.globl vector190
vector190:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $190
801069d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069d6:	e9 bf f3 ff ff       	jmp    80105d9a <alltraps>

801069db <vector191>:
.globl vector191
vector191:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $191
801069dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069e2:	e9 b3 f3 ff ff       	jmp    80105d9a <alltraps>

801069e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $192
801069e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069ee:	e9 a7 f3 ff ff       	jmp    80105d9a <alltraps>

801069f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $193
801069f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069fa:	e9 9b f3 ff ff       	jmp    80105d9a <alltraps>

801069ff <vector194>:
.globl vector194
vector194:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $194
80106a01:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a06:	e9 8f f3 ff ff       	jmp    80105d9a <alltraps>

80106a0b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $195
80106a0d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a12:	e9 83 f3 ff ff       	jmp    80105d9a <alltraps>

80106a17 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $196
80106a19:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a1e:	e9 77 f3 ff ff       	jmp    80105d9a <alltraps>

80106a23 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $197
80106a25:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a2a:	e9 6b f3 ff ff       	jmp    80105d9a <alltraps>

80106a2f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $198
80106a31:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a36:	e9 5f f3 ff ff       	jmp    80105d9a <alltraps>

80106a3b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $199
80106a3d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a42:	e9 53 f3 ff ff       	jmp    80105d9a <alltraps>

80106a47 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $200
80106a49:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a4e:	e9 47 f3 ff ff       	jmp    80105d9a <alltraps>

80106a53 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $201
80106a55:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a5a:	e9 3b f3 ff ff       	jmp    80105d9a <alltraps>

80106a5f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $202
80106a61:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a66:	e9 2f f3 ff ff       	jmp    80105d9a <alltraps>

80106a6b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $203
80106a6d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a72:	e9 23 f3 ff ff       	jmp    80105d9a <alltraps>

80106a77 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $204
80106a79:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a7e:	e9 17 f3 ff ff       	jmp    80105d9a <alltraps>

80106a83 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $205
80106a85:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a8a:	e9 0b f3 ff ff       	jmp    80105d9a <alltraps>

80106a8f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $206
80106a91:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a96:	e9 ff f2 ff ff       	jmp    80105d9a <alltraps>

80106a9b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $207
80106a9d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106aa2:	e9 f3 f2 ff ff       	jmp    80105d9a <alltraps>

80106aa7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $208
80106aa9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106aae:	e9 e7 f2 ff ff       	jmp    80105d9a <alltraps>

80106ab3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $209
80106ab5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106aba:	e9 db f2 ff ff       	jmp    80105d9a <alltraps>

80106abf <vector210>:
.globl vector210
vector210:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $210
80106ac1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ac6:	e9 cf f2 ff ff       	jmp    80105d9a <alltraps>

80106acb <vector211>:
.globl vector211
vector211:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $211
80106acd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ad2:	e9 c3 f2 ff ff       	jmp    80105d9a <alltraps>

80106ad7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $212
80106ad9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ade:	e9 b7 f2 ff ff       	jmp    80105d9a <alltraps>

80106ae3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $213
80106ae5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106aea:	e9 ab f2 ff ff       	jmp    80105d9a <alltraps>

80106aef <vector214>:
.globl vector214
vector214:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $214
80106af1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106af6:	e9 9f f2 ff ff       	jmp    80105d9a <alltraps>

80106afb <vector215>:
.globl vector215
vector215:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $215
80106afd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b02:	e9 93 f2 ff ff       	jmp    80105d9a <alltraps>

80106b07 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $216
80106b09:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b0e:	e9 87 f2 ff ff       	jmp    80105d9a <alltraps>

80106b13 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $217
80106b15:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b1a:	e9 7b f2 ff ff       	jmp    80105d9a <alltraps>

80106b1f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $218
80106b21:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b26:	e9 6f f2 ff ff       	jmp    80105d9a <alltraps>

80106b2b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $219
80106b2d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b32:	e9 63 f2 ff ff       	jmp    80105d9a <alltraps>

80106b37 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $220
80106b39:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b3e:	e9 57 f2 ff ff       	jmp    80105d9a <alltraps>

80106b43 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $221
80106b45:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b4a:	e9 4b f2 ff ff       	jmp    80105d9a <alltraps>

80106b4f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $222
80106b51:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b56:	e9 3f f2 ff ff       	jmp    80105d9a <alltraps>

80106b5b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $223
80106b5d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b62:	e9 33 f2 ff ff       	jmp    80105d9a <alltraps>

80106b67 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $224
80106b69:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b6e:	e9 27 f2 ff ff       	jmp    80105d9a <alltraps>

80106b73 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $225
80106b75:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b7a:	e9 1b f2 ff ff       	jmp    80105d9a <alltraps>

80106b7f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $226
80106b81:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b86:	e9 0f f2 ff ff       	jmp    80105d9a <alltraps>

80106b8b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $227
80106b8d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b92:	e9 03 f2 ff ff       	jmp    80105d9a <alltraps>

80106b97 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $228
80106b99:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b9e:	e9 f7 f1 ff ff       	jmp    80105d9a <alltraps>

80106ba3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $229
80106ba5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106baa:	e9 eb f1 ff ff       	jmp    80105d9a <alltraps>

80106baf <vector230>:
.globl vector230
vector230:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $230
80106bb1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106bb6:	e9 df f1 ff ff       	jmp    80105d9a <alltraps>

80106bbb <vector231>:
.globl vector231
vector231:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $231
80106bbd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106bc2:	e9 d3 f1 ff ff       	jmp    80105d9a <alltraps>

80106bc7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $232
80106bc9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bce:	e9 c7 f1 ff ff       	jmp    80105d9a <alltraps>

80106bd3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $233
80106bd5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106bda:	e9 bb f1 ff ff       	jmp    80105d9a <alltraps>

80106bdf <vector234>:
.globl vector234
vector234:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $234
80106be1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106be6:	e9 af f1 ff ff       	jmp    80105d9a <alltraps>

80106beb <vector235>:
.globl vector235
vector235:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $235
80106bed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106bf2:	e9 a3 f1 ff ff       	jmp    80105d9a <alltraps>

80106bf7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $236
80106bf9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bfe:	e9 97 f1 ff ff       	jmp    80105d9a <alltraps>

80106c03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $237
80106c05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c0a:	e9 8b f1 ff ff       	jmp    80105d9a <alltraps>

80106c0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $238
80106c11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c16:	e9 7f f1 ff ff       	jmp    80105d9a <alltraps>

80106c1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $239
80106c1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c22:	e9 73 f1 ff ff       	jmp    80105d9a <alltraps>

80106c27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $240
80106c29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c2e:	e9 67 f1 ff ff       	jmp    80105d9a <alltraps>

80106c33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $241
80106c35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c3a:	e9 5b f1 ff ff       	jmp    80105d9a <alltraps>

80106c3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $242
80106c41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c46:	e9 4f f1 ff ff       	jmp    80105d9a <alltraps>

80106c4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $243
80106c4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c52:	e9 43 f1 ff ff       	jmp    80105d9a <alltraps>

80106c57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $244
80106c59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c5e:	e9 37 f1 ff ff       	jmp    80105d9a <alltraps>

80106c63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $245
80106c65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c6a:	e9 2b f1 ff ff       	jmp    80105d9a <alltraps>

80106c6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $246
80106c71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c76:	e9 1f f1 ff ff       	jmp    80105d9a <alltraps>

80106c7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $247
80106c7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c82:	e9 13 f1 ff ff       	jmp    80105d9a <alltraps>

80106c87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $248
80106c89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c8e:	e9 07 f1 ff ff       	jmp    80105d9a <alltraps>

80106c93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $249
80106c95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c9a:	e9 fb f0 ff ff       	jmp    80105d9a <alltraps>

80106c9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $250
80106ca1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ca6:	e9 ef f0 ff ff       	jmp    80105d9a <alltraps>

80106cab <vector251>:
.globl vector251
vector251:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $251
80106cad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106cb2:	e9 e3 f0 ff ff       	jmp    80105d9a <alltraps>

80106cb7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $252
80106cb9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cbe:	e9 d7 f0 ff ff       	jmp    80105d9a <alltraps>

80106cc3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $253
80106cc5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106cca:	e9 cb f0 ff ff       	jmp    80105d9a <alltraps>

80106ccf <vector254>:
.globl vector254
vector254:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $254
80106cd1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106cd6:	e9 bf f0 ff ff       	jmp    80105d9a <alltraps>

80106cdb <vector255>:
.globl vector255
vector255:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $255
80106cdd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ce2:	e9 b3 f0 ff ff       	jmp    80105d9a <alltraps>
80106ce7:	66 90                	xchg   %ax,%ax
80106ce9:	66 90                	xchg   %ax,%ax
80106ceb:	66 90                	xchg   %ax,%ax
80106ced:	66 90                	xchg   %ax,%ax
80106cef:	90                   	nop

80106cf0 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
//    if (DEBUGMODE == 2&& notShell())
//        cprintf("WALKPGDIR-");
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80106cf6:	89 d3                	mov    %edx,%ebx
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106cf8:	89 d7                	mov    %edx,%edi
    pde = &pgdir[PDX(va)];
80106cfa:	c1 eb 16             	shr    $0x16,%ebx
80106cfd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106d00:	83 ec 0c             	sub    $0xc,%esp
    if (*pde & PTE_P) {
80106d03:	8b 06                	mov    (%esi),%eax
80106d05:	a8 01                	test   $0x1,%al
80106d07:	74 27                	je     80106d30 <walkpgdir+0x40>
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
80106d09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d0e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
//    if (DEBUGMODE == 2&& notShell())
//        cprintf(">WALKPGDIR-DONE!\t");
    return &pgtab[PTX(va)];
80106d14:	c1 ef 0a             	shr    $0xa,%edi
}
80106d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return &pgtab[PTX(va)];
80106d1a:	89 fa                	mov    %edi,%edx
80106d1c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d22:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106d25:	5b                   	pop    %ebx
80106d26:	5e                   	pop    %esi
80106d27:	5f                   	pop    %edi
80106d28:	5d                   	pop    %ebp
80106d29:	c3                   	ret    
80106d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!alloc)
80106d30:	85 c9                	test   %ecx,%ecx
80106d32:	74 2c                	je     80106d60 <walkpgdir+0x70>
        if ((pgtab = (pte_t *) kalloc()) == 0)
80106d34:	e8 57 bb ff ff       	call   80102890 <kalloc>
80106d39:	85 c0                	test   %eax,%eax
80106d3b:	89 c3                	mov    %eax,%ebx
80106d3d:	74 21                	je     80106d60 <walkpgdir+0x70>
        memset(pgtab, 0, PGSIZE);
80106d3f:	83 ec 04             	sub    $0x4,%esp
80106d42:	68 00 10 00 00       	push   $0x1000
80106d47:	6a 00                	push   $0x0
80106d49:	50                   	push   %eax
80106d4a:	e8 21 de ff ff       	call   80104b70 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d4f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d55:	83 c4 10             	add    $0x10,%esp
80106d58:	83 c8 07             	or     $0x7,%eax
80106d5b:	89 06                	mov    %eax,(%esi)
80106d5d:	eb b5                	jmp    80106d14 <walkpgdir+0x24>
80106d5f:	90                   	nop
}
80106d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80106d63:	31 c0                	xor    %eax,%eax
}
80106d65:	5b                   	pop    %ebx
80106d66:	5e                   	pop    %esi
80106d67:	5f                   	pop    %edi
80106d68:	5d                   	pop    %ebp
80106d69:	c3                   	ret    
80106d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d70 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d76:	89 d3                	mov    %edx,%ebx
80106d78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d7e:	83 ec 1c             	sub    $0x1c,%esp
80106d81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d84:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d88:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d96:	29 df                	sub    %ebx,%edi
80106d98:	83 c8 01             	or     $0x1,%eax
80106d9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d9e:	eb 15                	jmp    80106db5 <mappages+0x45>
    if(*pte & PTE_P)
80106da0:	f6 00 01             	testb  $0x1,(%eax)
80106da3:	75 45                	jne    80106dea <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106da5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106da8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106dab:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106dad:	74 31                	je     80106de0 <mappages+0x70>
      break;
    a += PGSIZE;
80106daf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106db5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106db8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106dbd:	89 da                	mov    %ebx,%edx
80106dbf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106dc2:	e8 29 ff ff ff       	call   80106cf0 <walkpgdir>
80106dc7:	85 c0                	test   %eax,%eax
80106dc9:	75 d5                	jne    80106da0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106dcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106dce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dd3:	5b                   	pop    %ebx
80106dd4:	5e                   	pop    %esi
80106dd5:	5f                   	pop    %edi
80106dd6:	5d                   	pop    %ebp
80106dd7:	c3                   	ret    
80106dd8:	90                   	nop
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106de3:	31 c0                	xor    %eax,%eax
}
80106de5:	5b                   	pop    %ebx
80106de6:	5e                   	pop    %esi
80106de7:	5f                   	pop    %edi
80106de8:	5d                   	pop    %ebp
80106de9:	c3                   	ret    
      panic("remap");
80106dea:	83 ec 0c             	sub    $0xc,%esp
80106ded:	68 48 83 10 80       	push   $0x80108348
80106df2:	e8 99 95 ff ff       	call   80100390 <panic>
80106df7:	89 f6                	mov    %esi,%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e00 <seginit>:
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e06:	e8 35 ce ff ff       	call   80103c40 <cpuid>
80106e0b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106e11:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e16:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e1a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106e21:	ff 00 00 
80106e24:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106e2b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e2e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106e35:	ff 00 00 
80106e38:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106e3f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e42:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106e49:	ff 00 00 
80106e4c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106e53:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e56:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106e5d:	ff 00 00 
80106e60:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106e67:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e6a:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106e6f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e73:	c1 e8 10             	shr    $0x10,%eax
80106e76:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e7a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e7d:	0f 01 10             	lgdtl  (%eax)
}
80106e80:	c9                   	leave  
80106e81:	c3                   	ret    
80106e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e90 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e90:	a1 a4 69 12 80       	mov    0x801269a4,%eax
{
80106e95:	55                   	push   %ebp
80106e96:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e98:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e9d:	0f 22 d8             	mov    %eax,%cr3
}
80106ea0:	5d                   	pop    %ebp
80106ea1:	c3                   	ret    
80106ea2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106eb0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	57                   	push   %edi
80106eb4:	56                   	push   %esi
80106eb5:	53                   	push   %ebx
80106eb6:	83 ec 1c             	sub    $0x1c,%esp
80106eb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106ebc:	85 db                	test   %ebx,%ebx
80106ebe:	0f 84 cb 00 00 00    	je     80106f8f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106ec4:	8b 43 08             	mov    0x8(%ebx),%eax
80106ec7:	85 c0                	test   %eax,%eax
80106ec9:	0f 84 da 00 00 00    	je     80106fa9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106ecf:	8b 43 04             	mov    0x4(%ebx),%eax
80106ed2:	85 c0                	test   %eax,%eax
80106ed4:	0f 84 c2 00 00 00    	je     80106f9c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
80106eda:	e8 d1 da ff ff       	call   801049b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106edf:	e8 dc cc ff ff       	call   80103bc0 <mycpu>
80106ee4:	89 c6                	mov    %eax,%esi
80106ee6:	e8 d5 cc ff ff       	call   80103bc0 <mycpu>
80106eeb:	89 c7                	mov    %eax,%edi
80106eed:	e8 ce cc ff ff       	call   80103bc0 <mycpu>
80106ef2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ef5:	83 c7 08             	add    $0x8,%edi
80106ef8:	e8 c3 cc ff ff       	call   80103bc0 <mycpu>
80106efd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f00:	83 c0 08             	add    $0x8,%eax
80106f03:	ba 67 00 00 00       	mov    $0x67,%edx
80106f08:	c1 e8 18             	shr    $0x18,%eax
80106f0b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106f12:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106f19:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f1f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f24:	83 c1 08             	add    $0x8,%ecx
80106f27:	c1 e9 10             	shr    $0x10,%ecx
80106f2a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106f30:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f35:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f3c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106f41:	e8 7a cc ff ff       	call   80103bc0 <mycpu>
80106f46:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f4d:	e8 6e cc ff ff       	call   80103bc0 <mycpu>
80106f52:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f56:	8b 73 08             	mov    0x8(%ebx),%esi
80106f59:	e8 62 cc ff ff       	call   80103bc0 <mycpu>
80106f5e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f64:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f67:	e8 54 cc ff ff       	call   80103bc0 <mycpu>
80106f6c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f70:	b8 28 00 00 00       	mov    $0x28,%eax
80106f75:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f78:	8b 43 04             	mov    0x4(%ebx),%eax
80106f7b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f80:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f86:	5b                   	pop    %ebx
80106f87:	5e                   	pop    %esi
80106f88:	5f                   	pop    %edi
80106f89:	5d                   	pop    %ebp
  popcli();
80106f8a:	e9 21 db ff ff       	jmp    80104ab0 <popcli>
    panic("switchuvm: no process");
80106f8f:	83 ec 0c             	sub    $0xc,%esp
80106f92:	68 4e 83 10 80       	push   $0x8010834e
80106f97:	e8 f4 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106f9c:	83 ec 0c             	sub    $0xc,%esp
80106f9f:	68 79 83 10 80       	push   $0x80108379
80106fa4:	e8 e7 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106fa9:	83 ec 0c             	sub    $0xc,%esp
80106fac:	68 64 83 10 80       	push   $0x80108364
80106fb1:	e8 da 93 ff ff       	call   80100390 <panic>
80106fb6:	8d 76 00             	lea    0x0(%esi),%esi
80106fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fc0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
80106fc9:	8b 75 10             	mov    0x10(%ebp),%esi
80106fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80106fcf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106fd2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106fd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106fdb:	77 49                	ja     80107026 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106fdd:	e8 ae b8 ff ff       	call   80102890 <kalloc>
  memset(mem, 0, PGSIZE);
80106fe2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106fe5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106fe7:	68 00 10 00 00       	push   $0x1000
80106fec:	6a 00                	push   $0x0
80106fee:	50                   	push   %eax
80106fef:	e8 7c db ff ff       	call   80104b70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ff4:	58                   	pop    %eax
80106ff5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ffb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107000:	5a                   	pop    %edx
80107001:	6a 06                	push   $0x6
80107003:	50                   	push   %eax
80107004:	31 d2                	xor    %edx,%edx
80107006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107009:	e8 62 fd ff ff       	call   80106d70 <mappages>
  memmove(mem, init, sz);
8010700e:	89 75 10             	mov    %esi,0x10(%ebp)
80107011:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107014:	83 c4 10             	add    $0x10,%esp
80107017:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010701a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010701d:	5b                   	pop    %ebx
8010701e:	5e                   	pop    %esi
8010701f:	5f                   	pop    %edi
80107020:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107021:	e9 fa db ff ff       	jmp    80104c20 <memmove>
    panic("inituvm: more than a page");
80107026:	83 ec 0c             	sub    $0xc,%esp
80107029:	68 8d 83 10 80       	push   $0x8010838d
8010702e:	e8 5d 93 ff ff       	call   80100390 <panic>
80107033:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107040 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107049:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107050:	0f 85 91 00 00 00    	jne    801070e7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107056:	8b 75 18             	mov    0x18(%ebp),%esi
80107059:	31 db                	xor    %ebx,%ebx
8010705b:	85 f6                	test   %esi,%esi
8010705d:	75 1a                	jne    80107079 <loaduvm+0x39>
8010705f:	eb 6f                	jmp    801070d0 <loaduvm+0x90>
80107061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107068:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010706e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107074:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107077:	76 57                	jbe    801070d0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107079:	8b 55 0c             	mov    0xc(%ebp),%edx
8010707c:	8b 45 08             	mov    0x8(%ebp),%eax
8010707f:	31 c9                	xor    %ecx,%ecx
80107081:	01 da                	add    %ebx,%edx
80107083:	e8 68 fc ff ff       	call   80106cf0 <walkpgdir>
80107088:	85 c0                	test   %eax,%eax
8010708a:	74 4e                	je     801070da <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010708c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010708e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107091:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107096:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010709b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801070a1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070a4:	01 d9                	add    %ebx,%ecx
801070a6:	05 00 00 00 80       	add    $0x80000000,%eax
801070ab:	57                   	push   %edi
801070ac:	51                   	push   %ecx
801070ad:	50                   	push   %eax
801070ae:	ff 75 10             	pushl  0x10(%ebp)
801070b1:	e8 ea a8 ff ff       	call   801019a0 <readi>
801070b6:	83 c4 10             	add    $0x10,%esp
801070b9:	39 f8                	cmp    %edi,%eax
801070bb:	74 ab                	je     80107068 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801070bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070c5:	5b                   	pop    %ebx
801070c6:	5e                   	pop    %esi
801070c7:	5f                   	pop    %edi
801070c8:	5d                   	pop    %ebp
801070c9:	c3                   	ret    
801070ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070d3:	31 c0                	xor    %eax,%eax
}
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
      panic("loaduvm: address should exist");
801070da:	83 ec 0c             	sub    $0xc,%esp
801070dd:	68 a7 83 10 80       	push   $0x801083a7
801070e2:	e8 a9 92 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801070e7:	83 ec 0c             	sub    $0xc,%esp
801070ea:	68 58 85 10 80       	push   $0x80108558
801070ef:	e8 9c 92 ff ff       	call   80100390 <panic>
801070f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107100 <findFreeEntryInSwapFile>:

int
findFreeEntryInSwapFile(struct proc *p){
80107100:	55                   	push   %ebp
  for(int i=0; i<MAX_PSYC_PAGES; i++){
80107101:	31 c0                	xor    %eax,%eax
findFreeEntryInSwapFile(struct proc *p){
80107103:	89 e5                	mov    %esp,%ebp
80107105:	8b 55 08             	mov    0x8(%ebp),%edx
80107108:	eb 0e                	jmp    80107118 <findFreeEntryInSwapFile+0x18>
8010710a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(int i=0; i<MAX_PSYC_PAGES; i++){
80107110:	83 c0 01             	add    $0x1,%eax
80107113:	83 f8 10             	cmp    $0x10,%eax
80107116:	74 10                	je     80107128 <findFreeEntryInSwapFile+0x28>
    if(!p->swapFileEntries[i])
80107118:	8b 8c 82 00 04 00 00 	mov    0x400(%edx,%eax,4),%ecx
8010711f:	85 c9                	test   %ecx,%ecx
80107121:	75 ed                	jne    80107110 <findFreeEntryInSwapFile+0x10>
      return i;
  }
  return -1;
}
80107123:	5d                   	pop    %ebp
80107124:	c3                   	ret    
80107125:	8d 76 00             	lea    0x0(%esi),%esi
  return -1;
80107128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010712d:	5d                   	pop    %ebp
8010712e:	c3                   	ret    
8010712f:	90                   	nop

80107130 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	53                   	push   %ebx
80107136:	83 ec 1c             	sub    $0x1c,%esp
80107139:	8b 7d 08             	mov    0x8(%ebp),%edi
8010713c:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (DEBUGMODE == 2&& notShell())
8010713f:	e8 3c ca ff ff       	call   80103b80 <notShell>
80107144:	85 c0                	test   %eax,%eax
80107146:	0f 85 cc 00 00 00    	jne    80107218 <deallocuvm+0xe8>
    cprintf("DEALLOCUVM-");
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz){
8010714c:	39 75 10             	cmp    %esi,0x10(%ebp)
8010714f:	0f 83 ab 00 00 00    	jae    80107200 <deallocuvm+0xd0>
    if (DEBUGMODE == 2&&notShell())
      cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
    return oldsz;
  }

  a = PGROUNDUP(newsz);
80107155:	8b 45 10             	mov    0x10(%ebp),%eax
80107158:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010715e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107164:	39 de                	cmp    %ebx,%esi
80107166:	77 43                	ja     801071ab <deallocuvm+0x7b>
80107168:	eb 66                	jmp    801071d0 <deallocuvm+0xa0>
8010716a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107170:	8b 10                	mov    (%eax),%edx
80107172:	f6 c2 01             	test   $0x1,%dl
80107175:	74 2a                	je     801071a1 <deallocuvm+0x71>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107177:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010717d:	0f 84 c1 00 00 00    	je     80107244 <deallocuvm+0x114>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107183:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107186:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010718c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010718f:	52                   	push   %edx
80107190:	e8 4b b5 ff ff       	call   801026e0 <kfree>
      *pte = 0;
80107195:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107198:	83 c4 10             	add    $0x10,%esp
8010719b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801071a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071a7:	39 de                	cmp    %ebx,%esi
801071a9:	76 25                	jbe    801071d0 <deallocuvm+0xa0>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071ab:	31 c9                	xor    %ecx,%ecx
801071ad:	89 da                	mov    %ebx,%edx
801071af:	89 f8                	mov    %edi,%eax
801071b1:	e8 3a fb ff ff       	call   80106cf0 <walkpgdir>
    if(!pte)
801071b6:	85 c0                	test   %eax,%eax
801071b8:	75 b6                	jne    80107170 <deallocuvm+0x40>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801071ba:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801071c0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801071c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071cc:	39 de                	cmp    %ebx,%esi
801071ce:	77 db                	ja     801071ab <deallocuvm+0x7b>
    }
  }
  if (DEBUGMODE == 2&& notShell())
801071d0:	e8 ab c9 ff ff       	call   80103b80 <notShell>
801071d5:	85 c0                	test   %eax,%eax
801071d7:	75 0f                	jne    801071e8 <deallocuvm+0xb8>
    cprintf(">DEALLOCUVM-DONE!\t");
  return newsz;
801071d9:	8b 45 10             	mov    0x10(%ebp),%eax
}
801071dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071df:	5b                   	pop    %ebx
801071e0:	5e                   	pop    %esi
801071e1:	5f                   	pop    %edi
801071e2:	5d                   	pop    %ebp
801071e3:	c3                   	ret    
801071e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(">DEALLOCUVM-DONE!\t");
801071e8:	83 ec 0c             	sub    $0xc,%esp
801071eb:	68 d1 83 10 80       	push   $0x801083d1
801071f0:	e8 6b 94 ff ff       	call   80100660 <cprintf>
801071f5:	83 c4 10             	add    $0x10,%esp
801071f8:	eb df                	jmp    801071d9 <deallocuvm+0xa9>
801071fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (DEBUGMODE == 2&&notShell())
80107200:	e8 7b c9 ff ff       	call   80103b80 <notShell>
80107205:	85 c0                	test   %eax,%eax
80107207:	75 27                	jne    80107230 <deallocuvm+0x100>
    return oldsz;
80107209:	89 f0                	mov    %esi,%eax
}
8010720b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010720e:	5b                   	pop    %ebx
8010720f:	5e                   	pop    %esi
80107210:	5f                   	pop    %edi
80107211:	5d                   	pop    %ebp
80107212:	c3                   	ret    
80107213:	90                   	nop
80107214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("DEALLOCUVM-");
80107218:	83 ec 0c             	sub    $0xc,%esp
8010721b:	68 c5 83 10 80       	push   $0x801083c5
80107220:	e8 3b 94 ff ff       	call   80100660 <cprintf>
80107225:	83 c4 10             	add    $0x10,%esp
80107228:	e9 1f ff ff ff       	jmp    8010714c <deallocuvm+0x1c>
8010722d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
80107230:	83 ec 0c             	sub    $0xc,%esp
80107233:	68 7c 85 10 80       	push   $0x8010857c
80107238:	e8 23 94 ff ff       	call   80100660 <cprintf>
8010723d:	83 c4 10             	add    $0x10,%esp
    return oldsz;
80107240:	89 f0                	mov    %esi,%eax
80107242:	eb c7                	jmp    8010720b <deallocuvm+0xdb>
        panic("kfree");
80107244:	83 ec 0c             	sub    $0xc,%esp
80107247:	68 0a 7d 10 80       	push   $0x80107d0a
8010724c:	e8 3f 91 ff ff       	call   80100390 <panic>
80107251:	eb 0d                	jmp    80107260 <allocuvm>
80107253:	90                   	nop
80107254:	90                   	nop
80107255:	90                   	nop
80107256:	90                   	nop
80107257:	90                   	nop
80107258:	90                   	nop
80107259:	90                   	nop
8010725a:	90                   	nop
8010725b:	90                   	nop
8010725c:	90                   	nop
8010725d:	90                   	nop
8010725e:	90                   	nop
8010725f:	90                   	nop

80107260 <allocuvm>:
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	57                   	push   %edi
80107264:	56                   	push   %esi
80107265:	53                   	push   %ebx
80107266:	83 ec 2c             	sub    $0x2c,%esp
  if (DEBUGMODE == 2&& notShell())
80107269:	e8 12 c9 ff ff       	call   80103b80 <notShell>
8010726e:	85 c0                	test   %eax,%eax
80107270:	0f 85 f2 02 00 00    	jne    80107568 <allocuvm+0x308>
  struct proc *p = myproc();
80107276:	e8 e5 c9 ff ff       	call   80103c60 <myproc>
8010727b:	89 c6                	mov    %eax,%esi
  if (newsz >= KERNBASE){
8010727d:	8b 45 10             	mov    0x10(%ebp),%eax
80107280:	85 c0                	test   %eax,%eax
80107282:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107285:	0f 88 0c 03 00 00    	js     80107597 <allocuvm+0x337>
  if (newsz < oldsz){
8010728b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010728e:	39 45 10             	cmp    %eax,0x10(%ebp)
80107291:	0f 82 e6 02 00 00    	jb     8010757d <allocuvm+0x31d>
  a = PGROUNDUP(oldsz);
80107297:	8b 45 0c             	mov    0xc(%ebp),%eax
8010729a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010729f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for (; a < newsz; a += PGSIZE) {
801072a4:	39 45 10             	cmp    %eax,0x10(%ebp)
  a = PGROUNDUP(oldsz);
801072a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for (; a < newsz; a += PGSIZE) {
801072aa:	0f 86 71 01 00 00    	jbe    80107421 <allocuvm+0x1c1>
    if(p->pagesCounter == MAX_TOTAL_PAGES)
801072b0:	8b 86 44 04 00 00    	mov    0x444(%esi),%eax
801072b6:	83 f8 20             	cmp    $0x20,%eax
801072b9:	0f 84 72 03 00 00    	je     80107631 <allocuvm+0x3d1>
      for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
801072bf:	8d 8e 00 04 00 00    	lea    0x400(%esi),%ecx
  struct page *pg=0, *cg=0;
801072c5:	31 db                	xor    %ebx,%ebx
  int maxSeq = 0, swapWriteOffset,tmpOffset;
801072c7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
      for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
801072ce:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801072d1:	eb 27                	jmp    801072fa <allocuvm+0x9a>
801072d3:	90                   	nop
801072d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (; a < newsz; a += PGSIZE) {
801072d8:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
801072df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072e2:	39 45 10             	cmp    %eax,0x10(%ebp)
801072e5:	0f 86 36 01 00 00    	jbe    80107421 <allocuvm+0x1c1>
    if(p->pagesCounter == MAX_TOTAL_PAGES)
801072eb:	8b 86 44 04 00 00    	mov    0x444(%esi),%eax
801072f1:	83 f8 20             	cmp    $0x20,%eax
801072f4:	0f 84 37 03 00 00    	je     80107631 <allocuvm+0x3d1>
    if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2 ) {
801072fa:	2b 86 48 04 00 00    	sub    0x448(%esi),%eax
80107300:	83 f8 0f             	cmp    $0xf,%eax
80107303:	7e 0a                	jle    8010730f <allocuvm+0xaf>
80107305:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80107309:	0f 8f 39 01 00 00    	jg     80107448 <allocuvm+0x1e8>
    mem = kalloc();
8010730f:	e8 7c b5 ff ff       	call   80102890 <kalloc>
    if (mem == 0) {
80107314:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107316:	89 c7                	mov    %eax,%edi
    if (mem == 0) {
80107318:	0f 84 f1 01 00 00    	je     8010750f <allocuvm+0x2af>
    memset(mem, 0, PGSIZE);
8010731e:	83 ec 04             	sub    $0x4,%esp
80107321:	68 00 10 00 00       	push   $0x1000
80107326:	6a 00                	push   $0x0
80107328:	50                   	push   %eax
80107329:	e8 42 d8 ff ff       	call   80104b70 <memset>
    if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
8010732e:	58                   	pop    %eax
8010732f:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107335:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010733a:	5a                   	pop    %edx
8010733b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010733e:	6a 06                	push   $0x6
80107340:	50                   	push   %eax
80107341:	8b 45 08             	mov    0x8(%ebp),%eax
80107344:	e8 27 fa ff ff       	call   80106d70 <mappages>
80107349:	83 c4 10             	add    $0x10,%esp
8010734c:	85 c0                	test   %eax,%eax
8010734e:	0f 88 89 02 00 00    	js     801075dd <allocuvm+0x37d>
    if(p->pid > 2) {
80107354:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80107358:	0f 8e 7a ff ff ff    	jle    801072d8 <allocuvm+0x78>
        if (!pg->active)
8010735e:	8b 8e 80 00 00 00    	mov    0x80(%esi),%ecx
      for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107364:	8d 9e 80 00 00 00    	lea    0x80(%esi),%ebx
8010736a:	8b 45 e0             	mov    -0x20(%ebp),%eax
        if (!pg->active)
8010736d:	85 c9                	test   %ecx,%ecx
8010736f:	74 18                	je     80107389 <allocuvm+0x129>
80107371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107378:	83 c3 1c             	add    $0x1c,%ebx
8010737b:	39 c3                	cmp    %eax,%ebx
8010737d:	0f 83 a1 02 00 00    	jae    80107624 <allocuvm+0x3c4>
        if (!pg->active)
80107383:	8b 13                	mov    (%ebx),%edx
80107385:	85 d2                	test   %edx,%edx
80107387:	75 ef                	jne    80107378 <allocuvm+0x118>
      p->pagesCounter++;
80107389:	83 86 44 04 00 00 01 	addl   $0x1,0x444(%esi)
      pg->active = 1;
80107390:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
        cprintf( "FUCK YOU !\n");
80107396:	83 ec 0c             	sub    $0xc,%esp
      pg->pageid = p->nextpageid++;
80107399:	8b 86 40 04 00 00    	mov    0x440(%esi),%eax
8010739f:	8d 50 01             	lea    0x1(%eax),%edx
801073a2:	89 96 40 04 00 00    	mov    %edx,0x440(%esi)
801073a8:	89 43 04             	mov    %eax,0x4(%ebx)
      pg->present = 1;
801073ab:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      pg->offset = 0;
801073b2:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
      pg->sequel = p->pagesequel++;
801073b9:	8b 86 4c 04 00 00    	mov    0x44c(%esi),%eax
801073bf:	8d 50 01             	lea    0x1(%eax),%edx
801073c2:	89 96 4c 04 00 00    	mov    %edx,0x44c(%esi)
      pg->physAdress = mem;
801073c8:	89 7b 14             	mov    %edi,0x14(%ebx)
      pg->virtAdress = (char *)a;
801073cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      pg->sequel = p->pagesequel++;
801073ce:	89 43 08             	mov    %eax,0x8(%ebx)
      pg->virtAdress = (char *)a;
801073d1:	89 7b 18             	mov    %edi,0x18(%ebx)
        cprintf( "FUCK YOU !\n");
801073d4:	68 71 84 10 80       	push   $0x80108471
801073d9:	e8 82 92 ff ff       	call   80100660 <cprintf>
      pgtble = walkpgdir(pgdir, (char *)a, 0);
801073de:	8b 45 08             	mov    0x8(%ebp),%eax
801073e1:	31 c9                	xor    %ecx,%ecx
801073e3:	89 fa                	mov    %edi,%edx
801073e5:	e8 06 f9 ff ff       	call   80106cf0 <walkpgdir>
801073ea:	89 c7                	mov    %eax,%edi
        cprintf( "FUCK YOU 2!\n");
801073ec:	c7 04 24 7d 84 10 80 	movl   $0x8010847d,(%esp)
801073f3:	e8 68 92 ff ff       	call   80100660 <cprintf>
      *pgtble = PTE_PG_0(pgtble); // Not Paged out to secondary storage
801073f8:	89 f8                	mov    %edi,%eax
801073fa:	80 e4 fd             	and    $0xfd,%ah
801073fd:	89 07                	mov    %eax,(%edi)
        cprintf( "FUCK YOU 3!\n");
801073ff:	c7 04 24 8a 84 10 80 	movl   $0x8010848a,(%esp)
80107406:	e8 55 92 ff ff       	call   80100660 <cprintf>
  for (; a < newsz; a += PGSIZE) {
8010740b:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
        cprintf( "FUCK YOU 3!\n");
80107412:	83 c4 10             	add    $0x10,%esp
  for (; a < newsz; a += PGSIZE) {
80107415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107418:	39 45 10             	cmp    %eax,0x10(%ebp)
8010741b:	0f 87 ca fe ff ff    	ja     801072eb <allocuvm+0x8b>
  if (DEBUGMODE == 2&& notShell())
80107421:	e8 5a c7 ff ff       	call   80103b80 <notShell>
80107426:	85 c0                	test   %eax,%eax
80107428:	0f 84 5e 01 00 00    	je     8010758c <allocuvm+0x32c>
    cprintf(">ALLOCUVM-DONE!\t");
8010742e:	83 ec 0c             	sub    $0xc,%esp
80107431:	68 97 84 10 80       	push   $0x80108497
80107436:	e8 25 92 ff ff       	call   80100660 <cprintf>
8010743b:	83 c4 10             	add    $0x10,%esp
8010743e:	e9 49 01 00 00       	jmp    8010758c <allocuvm+0x32c>
80107443:	90                   	nop
80107444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
80107448:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010744b:	8d 86 80 00 00 00    	lea    0x80(%esi),%eax
80107451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          if (cg->active && cg->present && cg->sequel > maxSeq) {
80107458:	8b 08                	mov    (%eax),%ecx
8010745a:	85 c9                	test   %ecx,%ecx
8010745c:	74 1a                	je     80107478 <allocuvm+0x218>
8010745e:	8b 78 0c             	mov    0xc(%eax),%edi
80107461:	85 ff                	test   %edi,%edi
80107463:	74 13                	je     80107478 <allocuvm+0x218>
80107465:	8b 48 08             	mov    0x8(%eax),%ecx
80107468:	3b 4d dc             	cmp    -0x24(%ebp),%ecx
8010746b:	7e 0b                	jle    80107478 <allocuvm+0x218>
8010746d:	89 c3                	mov    %eax,%ebx
8010746f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80107472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
80107478:	83 c0 1c             	add    $0x1c,%eax
8010747b:	39 d0                	cmp    %edx,%eax
8010747d:	72 d9                	jb     80107458 <allocuvm+0x1f8>
  for(int i=0; i<MAX_PSYC_PAGES; i++){
8010747f:	31 ff                	xor    %edi,%edi
80107481:	eb 11                	jmp    80107494 <allocuvm+0x234>
80107483:	90                   	nop
80107484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107488:	83 c7 01             	add    $0x1,%edi
8010748b:	83 ff 10             	cmp    $0x10,%edi
8010748e:	0f 84 c4 00 00 00    	je     80107558 <allocuvm+0x2f8>
    if(!p->swapFileEntries[i])
80107494:	8b 8c be 00 04 00 00 	mov    0x400(%esi,%edi,4),%ecx
8010749b:	85 c9                	test   %ecx,%ecx
8010749d:	75 e9                	jne    80107488 <allocuvm+0x228>
        cprintf( "FUCK YOU !\n");
8010749f:	83 ec 0c             	sub    $0xc,%esp
801074a2:	68 71 84 10 80       	push   $0x80108471
801074a7:	e8 b4 91 ff ff       	call   80100660 <cprintf>
      swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
801074ac:	89 fa                	mov    %edi,%edx
        writeToSwapFile(p ,pg->physAdress, (uint) swapWriteOffset, PGSIZE);
801074ae:	68 00 10 00 00       	push   $0x1000
      swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
801074b3:	c1 e2 0c             	shl    $0xc,%edx
        writeToSwapFile(p ,pg->physAdress, (uint) swapWriteOffset, PGSIZE);
801074b6:	52                   	push   %edx
801074b7:	ff 73 14             	pushl  0x14(%ebx)
801074ba:	56                   	push   %esi
801074bb:	89 55 d8             	mov    %edx,-0x28(%ebp)
801074be:	e8 cd ad ff ff       	call   80102290 <writeToSwapFile>
        cprintf( "FUCK YOU 2!\n");
801074c3:	83 c4 14             	add    $0x14,%esp
801074c6:	68 7d 84 10 80       	push   $0x8010847d
801074cb:	e8 90 91 ff ff       	call   80100660 <cprintf>
      pg->offset = (uint) swapWriteOffset;
801074d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
      pg->present = 0;
801074d3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
      p->pagesinSwap++;
801074da:	83 c4 10             	add    $0x10,%esp
      pg->physAdress = 0;
801074dd:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
      pg->sequel = 0;
801074e4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
      pg->offset = (uint) swapWriteOffset;
801074eb:	89 53 10             	mov    %edx,0x10(%ebx)
      p->swapFileEntries[tmpOffset] = 1; //update that this entry is taken
801074ee:	c7 84 be 00 04 00 00 	movl   $0x1,0x400(%esi,%edi,4)
801074f5:	01 00 00 00 
      p->pagesinSwap++;
801074f9:	83 86 48 04 00 00 01 	addl   $0x1,0x448(%esi)
    mem = kalloc();
80107500:	e8 8b b3 ff ff       	call   80102890 <kalloc>
    if (mem == 0) {
80107505:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107507:	89 c7                	mov    %eax,%edi
    if (mem == 0) {
80107509:	0f 85 0f fe ff ff    	jne    8010731e <allocuvm+0xbe>
      cprintf("allocuvm out of memory\n");
8010750f:	83 ec 0c             	sub    $0xc,%esp
80107512:	68 f5 83 10 80       	push   $0x801083f5
80107517:	e8 44 91 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010751c:	83 c4 0c             	add    $0xc,%esp
8010751f:	ff 75 0c             	pushl  0xc(%ebp)
80107522:	ff 75 10             	pushl  0x10(%ebp)
80107525:	ff 75 08             	pushl  0x8(%ebp)
80107528:	e8 03 fc ff ff       	call   80107130 <deallocuvm>
      if (DEBUGMODE == 2&& notShell())
8010752d:	e8 4e c6 ff ff       	call   80103b80 <notShell>
80107532:	83 c4 10             	add    $0x10,%esp
80107535:	85 c0                	test   %eax,%eax
80107537:	74 67                	je     801075a0 <allocuvm+0x340>
        cprintf(">ALLOCUVM-FAILED-mem == 0\t");
80107539:	83 ec 0c             	sub    $0xc,%esp
8010753c:	68 0d 84 10 80       	push   $0x8010840d
80107541:	e8 1a 91 ff ff       	call   80100660 <cprintf>
80107546:	83 c4 10             	add    $0x10,%esp
      return 0;
80107549:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
80107550:	eb 3a                	jmp    8010758c <allocuvm+0x32c>
80107552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          panic("ERROR - there is no free entry in p->swapFileEntries!\n");
80107558:	83 ec 0c             	sub    $0xc,%esp
8010755b:	68 d0 85 10 80       	push   $0x801085d0
80107560:	e8 2b 8e ff ff       	call   80100390 <panic>
80107565:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("ALLOCUVM-");
80107568:	83 ec 0c             	sub    $0xc,%esp
8010756b:	68 c7 83 10 80       	push   $0x801083c7
80107570:	e8 eb 90 ff ff       	call   80100660 <cprintf>
80107575:	83 c4 10             	add    $0x10,%esp
80107578:	e9 f9 fc ff ff       	jmp    80107276 <allocuvm+0x16>
    if (DEBUGMODE == 2&& notShell())
8010757d:	e8 fe c5 ff ff       	call   80103b80 <notShell>
80107582:	85 c0                	test   %eax,%eax
80107584:	75 2c                	jne    801075b2 <allocuvm+0x352>
    return oldsz;
80107586:	8b 45 0c             	mov    0xc(%ebp),%eax
80107589:	89 45 d4             	mov    %eax,-0x2c(%ebp)
}
8010758c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010758f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107592:	5b                   	pop    %ebx
80107593:	5e                   	pop    %esi
80107594:	5f                   	pop    %edi
80107595:	5d                   	pop    %ebp
80107596:	c3                   	ret    
    if (DEBUGMODE == 2&& notShell())
80107597:	e8 e4 c5 ff ff       	call   80103b80 <notShell>
8010759c:	85 c0                	test   %eax,%eax
8010759e:	75 24                	jne    801075c4 <allocuvm+0x364>
      return 0;
801075a0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
}
801075a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801075aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ad:	5b                   	pop    %ebx
801075ae:	5e                   	pop    %esi
801075af:	5f                   	pop    %edi
801075b0:	5d                   	pop    %ebp
801075b1:	c3                   	ret    
      cprintf(">ALLOCUVM-FAILED");
801075b2:	83 ec 0c             	sub    $0xc,%esp
801075b5:	68 e4 83 10 80       	push   $0x801083e4
801075ba:	e8 a1 90 ff ff       	call   80100660 <cprintf>
801075bf:	83 c4 10             	add    $0x10,%esp
801075c2:	eb c2                	jmp    80107586 <allocuvm+0x326>
      cprintf(">ALLOCUVM-FAILED");
801075c4:	83 ec 0c             	sub    $0xc,%esp
801075c7:	68 e4 83 10 80       	push   $0x801083e4
801075cc:	e8 8f 90 ff ff       	call   80100660 <cprintf>
801075d1:	83 c4 10             	add    $0x10,%esp
    return 0;
801075d4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801075db:	eb af                	jmp    8010758c <allocuvm+0x32c>
      cprintf("allocuvm out of memory (2)\n");
801075dd:	83 ec 0c             	sub    $0xc,%esp
801075e0:	68 28 84 10 80       	push   $0x80108428
801075e5:	e8 76 90 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801075ea:	83 c4 0c             	add    $0xc,%esp
801075ed:	ff 75 0c             	pushl  0xc(%ebp)
801075f0:	ff 75 10             	pushl  0x10(%ebp)
801075f3:	ff 75 08             	pushl  0x8(%ebp)
801075f6:	e8 35 fb ff ff       	call   80107130 <deallocuvm>
      kfree(mem);
801075fb:	89 3c 24             	mov    %edi,(%esp)
801075fe:	e8 dd b0 ff ff       	call   801026e0 <kfree>
      if (DEBUGMODE == 2&& notShell())
80107603:	e8 78 c5 ff ff       	call   80103b80 <notShell>
80107608:	83 c4 10             	add    $0x10,%esp
8010760b:	85 c0                	test   %eax,%eax
8010760d:	74 91                	je     801075a0 <allocuvm+0x340>
        cprintf(">ALLOCUVM-FAILED-mappages<0\t");
8010760f:	83 ec 0c             	sub    $0xc,%esp
80107612:	68 44 84 10 80       	push   $0x80108444
80107617:	e8 44 90 ff ff       	call   80100660 <cprintf>
8010761c:	83 c4 10             	add    $0x10,%esp
8010761f:	e9 7c ff ff ff       	jmp    801075a0 <allocuvm+0x340>
      panic("no page in proc");
80107624:	83 ec 0c             	sub    $0xc,%esp
80107627:	68 61 84 10 80       	push   $0x80108461
8010762c:	e8 5f 8d ff ff       	call   80100390 <panic>
      panic("got 32 pages and requested for another page!");
80107631:	83 ec 0c             	sub    $0xc,%esp
80107634:	68 a0 85 10 80       	push   $0x801085a0
80107639:	e8 52 8d ff ff       	call   80100390 <panic>
8010763e:	66 90                	xchg   %ax,%ax

80107640 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	57                   	push   %edi
80107644:	56                   	push   %esi
80107645:	53                   	push   %ebx
80107646:	83 ec 0c             	sub    $0xc,%esp
80107649:	8b 75 08             	mov    0x8(%ebp),%esi
  if (DEBUGMODE == 2&& notShell())
8010764c:	e8 2f c5 ff ff       	call   80103b80 <notShell>
80107651:	85 c0                	test   %eax,%eax
80107653:	0f 85 81 00 00 00    	jne    801076da <freevm+0x9a>
    cprintf("FREEVM");
  uint i;

  if(pgdir == 0)
80107659:	85 f6                	test   %esi,%esi
8010765b:	0f 84 8e 00 00 00    	je     801076ef <freevm+0xaf>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107661:	83 ec 04             	sub    $0x4,%esp
80107664:	89 f3                	mov    %esi,%ebx
80107666:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010766c:	6a 00                	push   $0x0
8010766e:	68 00 00 00 80       	push   $0x80000000
80107673:	56                   	push   %esi
80107674:	e8 b7 fa ff ff       	call   80107130 <deallocuvm>
80107679:	83 c4 10             	add    $0x10,%esp
8010767c:	eb 09                	jmp    80107687 <freevm+0x47>
8010767e:	66 90                	xchg   %ax,%ax
80107680:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107683:	39 fb                	cmp    %edi,%ebx
80107685:	74 23                	je     801076aa <freevm+0x6a>
    if(pgdir[i] & PTE_P){
80107687:	8b 03                	mov    (%ebx),%eax
80107689:	a8 01                	test   $0x1,%al
8010768b:	74 f3                	je     80107680 <freevm+0x40>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010768d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107692:	83 ec 0c             	sub    $0xc,%esp
80107695:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107698:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010769d:	50                   	push   %eax
8010769e:	e8 3d b0 ff ff       	call   801026e0 <kfree>
801076a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076a6:	39 fb                	cmp    %edi,%ebx
801076a8:	75 dd                	jne    80107687 <freevm+0x47>
    }
  }
  kfree((char*)pgdir);
801076aa:	83 ec 0c             	sub    $0xc,%esp
801076ad:	56                   	push   %esi
801076ae:	e8 2d b0 ff ff       	call   801026e0 <kfree>
  if (DEBUGMODE == 2&& notShell())
801076b3:	e8 c8 c4 ff ff       	call   80103b80 <notShell>
801076b8:	83 c4 10             	add    $0x10,%esp
801076bb:	85 c0                	test   %eax,%eax
801076bd:	75 08                	jne    801076c7 <freevm+0x87>
    cprintf(">FREEVM-DONE!\t");
}
801076bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076c2:	5b                   	pop    %ebx
801076c3:	5e                   	pop    %esi
801076c4:	5f                   	pop    %edi
801076c5:	5d                   	pop    %ebp
801076c6:	c3                   	ret    
    cprintf(">FREEVM-DONE!\t");
801076c7:	c7 45 08 c0 84 10 80 	movl   $0x801084c0,0x8(%ebp)
}
801076ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d1:	5b                   	pop    %ebx
801076d2:	5e                   	pop    %esi
801076d3:	5f                   	pop    %edi
801076d4:	5d                   	pop    %ebp
    cprintf(">FREEVM-DONE!\t");
801076d5:	e9 86 8f ff ff       	jmp    80100660 <cprintf>
    cprintf("FREEVM");
801076da:	83 ec 0c             	sub    $0xc,%esp
801076dd:	68 a8 84 10 80       	push   $0x801084a8
801076e2:	e8 79 8f ff ff       	call   80100660 <cprintf>
801076e7:	83 c4 10             	add    $0x10,%esp
801076ea:	e9 6a ff ff ff       	jmp    80107659 <freevm+0x19>
    panic("freevm: no pgdir");
801076ef:	83 ec 0c             	sub    $0xc,%esp
801076f2:	68 af 84 10 80       	push   $0x801084af
801076f7:	e8 94 8c ff ff       	call   80100390 <panic>
801076fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107700 <setupkvm>:
{
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	56                   	push   %esi
80107704:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107705:	e8 86 b1 ff ff       	call   80102890 <kalloc>
8010770a:	85 c0                	test   %eax,%eax
8010770c:	89 c6                	mov    %eax,%esi
8010770e:	74 42                	je     80107752 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107710:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107713:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107718:	68 00 10 00 00       	push   $0x1000
8010771d:	6a 00                	push   $0x0
8010771f:	50                   	push   %eax
80107720:	e8 4b d4 ff ff       	call   80104b70 <memset>
80107725:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107728:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010772b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010772e:	83 ec 08             	sub    $0x8,%esp
80107731:	8b 13                	mov    (%ebx),%edx
80107733:	ff 73 0c             	pushl  0xc(%ebx)
80107736:	50                   	push   %eax
80107737:	29 c1                	sub    %eax,%ecx
80107739:	89 f0                	mov    %esi,%eax
8010773b:	e8 30 f6 ff ff       	call   80106d70 <mappages>
80107740:	83 c4 10             	add    $0x10,%esp
80107743:	85 c0                	test   %eax,%eax
80107745:	78 19                	js     80107760 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107747:	83 c3 10             	add    $0x10,%ebx
8010774a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107750:	75 d6                	jne    80107728 <setupkvm+0x28>
}
80107752:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107755:	89 f0                	mov    %esi,%eax
80107757:	5b                   	pop    %ebx
80107758:	5e                   	pop    %esi
80107759:	5d                   	pop    %ebp
8010775a:	c3                   	ret    
8010775b:	90                   	nop
8010775c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107760:	83 ec 0c             	sub    $0xc,%esp
80107763:	56                   	push   %esi
      return 0;
80107764:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107766:	e8 d5 fe ff ff       	call   80107640 <freevm>
      return 0;
8010776b:	83 c4 10             	add    $0x10,%esp
}
8010776e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107771:	89 f0                	mov    %esi,%eax
80107773:	5b                   	pop    %ebx
80107774:	5e                   	pop    %esi
80107775:	5d                   	pop    %ebp
80107776:	c3                   	ret    
80107777:	89 f6                	mov    %esi,%esi
80107779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107780 <kvmalloc>:
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107786:	e8 75 ff ff ff       	call   80107700 <setupkvm>
8010778b:	a3 a4 69 12 80       	mov    %eax,0x801269a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107790:	05 00 00 00 80       	add    $0x80000000,%eax
80107795:	0f 22 d8             	mov    %eax,%cr3
}
80107798:	c9                   	leave  
80107799:	c3                   	ret    
8010779a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077a0:	55                   	push   %ebp
801077a1:	89 e5                	mov    %esp,%ebp
801077a3:	56                   	push   %esi
801077a4:	53                   	push   %ebx
801077a5:	8b 75 0c             	mov    0xc(%ebp),%esi
801077a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (DEBUGMODE == 2&& notShell())
801077ab:	e8 d0 c3 ff ff       	call   80103b80 <notShell>
801077b0:	85 c0                	test   %eax,%eax
801077b2:	75 44                	jne    801077f8 <clearpteu+0x58>
    cprintf("CLEARPTEU-");
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077b4:	31 c9                	xor    %ecx,%ecx
801077b6:	89 f2                	mov    %esi,%edx
801077b8:	89 d8                	mov    %ebx,%eax
801077ba:	e8 31 f5 ff ff       	call   80106cf0 <walkpgdir>
  if(pte == 0)
801077bf:	85 c0                	test   %eax,%eax
801077c1:	74 47                	je     8010780a <clearpteu+0x6a>
    panic("clearpteu");
  *pte &= ~PTE_U;
801077c3:	83 20 fb             	andl   $0xfffffffb,(%eax)
  if (DEBUGMODE == 2&& notShell())
801077c6:	e8 b5 c3 ff ff       	call   80103b80 <notShell>
801077cb:	85 c0                	test   %eax,%eax
801077cd:	75 11                	jne    801077e0 <clearpteu+0x40>
    cprintf(">CLEARPTEU-DONE!\t");
}
801077cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077d2:	5b                   	pop    %ebx
801077d3:	5e                   	pop    %esi
801077d4:	5d                   	pop    %ebp
801077d5:	c3                   	ret    
801077d6:	8d 76 00             	lea    0x0(%esi),%esi
801077d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf(">CLEARPTEU-DONE!\t");
801077e0:	c7 45 08 e4 84 10 80 	movl   $0x801084e4,0x8(%ebp)
}
801077e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077ea:	5b                   	pop    %ebx
801077eb:	5e                   	pop    %esi
801077ec:	5d                   	pop    %ebp
    cprintf(">CLEARPTEU-DONE!\t");
801077ed:	e9 6e 8e ff ff       	jmp    80100660 <cprintf>
801077f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("CLEARPTEU-");
801077f8:	83 ec 0c             	sub    $0xc,%esp
801077fb:	68 cf 84 10 80       	push   $0x801084cf
80107800:	e8 5b 8e ff ff       	call   80100660 <cprintf>
80107805:	83 c4 10             	add    $0x10,%esp
80107808:	eb aa                	jmp    801077b4 <clearpteu+0x14>
    panic("clearpteu");
8010780a:	83 ec 0c             	sub    $0xc,%esp
8010780d:	68 da 84 10 80       	push   $0x801084da
80107812:	e8 79 8b ff ff       	call   80100390 <panic>
80107817:	89 f6                	mov    %esi,%esi
80107819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107820 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107820:	55                   	push   %ebp
80107821:	89 e5                	mov    %esp,%ebp
80107823:	57                   	push   %edi
80107824:	56                   	push   %esi
80107825:	53                   	push   %ebx
80107826:	83 ec 1c             	sub    $0x1c,%esp
  if (DEBUGMODE == 2&& notShell())
80107829:	e8 52 c3 ff ff       	call   80103b80 <notShell>
8010782e:	85 c0                	test   %eax,%eax
80107830:	0f 85 ea 00 00 00    	jne    80107920 <copyuvm+0x100>
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107836:	e8 c5 fe ff ff       	call   80107700 <setupkvm>
8010783b:	85 c0                	test   %eax,%eax
8010783d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107840:	0f 84 a9 00 00 00    	je     801078ef <copyuvm+0xcf>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107846:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107849:	85 c9                	test   %ecx,%ecx
8010784b:	0f 84 e7 00 00 00    	je     80107938 <copyuvm+0x118>
80107851:	31 f6                	xor    %esi,%esi
80107853:	eb 4d                	jmp    801078a2 <copyuvm+0x82>
80107855:	8d 76 00             	lea    0x0(%esi),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107858:	83 ec 04             	sub    $0x4,%esp
8010785b:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107861:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107864:	68 00 10 00 00       	push   $0x1000
80107869:	57                   	push   %edi
8010786a:	50                   	push   %eax
8010786b:	e8 b0 d3 ff ff       	call   80104c20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107870:	58                   	pop    %eax
80107871:	5a                   	pop    %edx
80107872:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107875:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107878:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010787d:	53                   	push   %ebx
8010787e:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107884:	52                   	push   %edx
80107885:	89 f2                	mov    %esi,%edx
80107887:	e8 e4 f4 ff ff       	call   80106d70 <mappages>
8010788c:	83 c4 10             	add    $0x10,%esp
8010788f:	85 c0                	test   %eax,%eax
80107891:	78 45                	js     801078d8 <copyuvm+0xb8>
  for(i = 0; i < sz; i += PGSIZE){
80107893:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107899:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010789c:	0f 86 96 00 00 00    	jbe    80107938 <copyuvm+0x118>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078a2:	8b 45 08             	mov    0x8(%ebp),%eax
801078a5:	31 c9                	xor    %ecx,%ecx
801078a7:	89 f2                	mov    %esi,%edx
801078a9:	e8 42 f4 ff ff       	call   80106cf0 <walkpgdir>
801078ae:	85 c0                	test   %eax,%eax
801078b0:	0f 84 a6 00 00 00    	je     8010795c <copyuvm+0x13c>
    if(!(*pte & PTE_P))
801078b6:	8b 18                	mov    (%eax),%ebx
801078b8:	f6 c3 01             	test   $0x1,%bl
801078bb:	0f 84 a8 00 00 00    	je     80107969 <copyuvm+0x149>
    pa = PTE_ADDR(*pte);
801078c1:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801078c3:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801078c9:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801078cf:	e8 bc af ff ff       	call   80102890 <kalloc>
801078d4:	85 c0                	test   %eax,%eax
801078d6:	75 80                	jne    80107858 <copyuvm+0x38>
  if (DEBUGMODE == 2&& notShell())
    cprintf(">COPYUVM-DONE!\t");
  return d;

bad:
  freevm(d);
801078d8:	83 ec 0c             	sub    $0xc,%esp
801078db:	ff 75 e0             	pushl  -0x20(%ebp)
801078de:	e8 5d fd ff ff       	call   80107640 <freevm>
  if (DEBUGMODE == 2&& notShell())
801078e3:	e8 98 c2 ff ff       	call   80103b80 <notShell>
801078e8:	83 c4 10             	add    $0x10,%esp
801078eb:	85 c0                	test   %eax,%eax
801078ed:	75 19                	jne    80107908 <copyuvm+0xe8>
    cprintf(">COPYUVM-FAILED!\t");
  return 0;
801078ef:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801078f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078fc:	5b                   	pop    %ebx
801078fd:	5e                   	pop    %esi
801078fe:	5f                   	pop    %edi
801078ff:	5d                   	pop    %ebp
80107900:	c3                   	ret    
80107901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(">COPYUVM-FAILED!\t");
80107908:	83 ec 0c             	sub    $0xc,%esp
8010790b:	68 43 85 10 80       	push   $0x80108543
80107910:	e8 4b 8d ff ff       	call   80100660 <cprintf>
80107915:	83 c4 10             	add    $0x10,%esp
80107918:	eb d5                	jmp    801078ef <copyuvm+0xcf>
8010791a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("COPYUVM-");
80107920:	83 ec 0c             	sub    $0xc,%esp
80107923:	68 f6 84 10 80       	push   $0x801084f6
80107928:	e8 33 8d ff ff       	call   80100660 <cprintf>
8010792d:	83 c4 10             	add    $0x10,%esp
80107930:	e9 01 ff ff ff       	jmp    80107836 <copyuvm+0x16>
80107935:	8d 76 00             	lea    0x0(%esi),%esi
  if (DEBUGMODE == 2&& notShell())
80107938:	e8 43 c2 ff ff       	call   80103b80 <notShell>
8010793d:	85 c0                	test   %eax,%eax
8010793f:	74 b5                	je     801078f6 <copyuvm+0xd6>
    cprintf(">COPYUVM-DONE!\t");
80107941:	83 ec 0c             	sub    $0xc,%esp
80107944:	68 33 85 10 80       	push   $0x80108533
80107949:	e8 12 8d ff ff       	call   80100660 <cprintf>
}
8010794e:	8b 45 e0             	mov    -0x20(%ebp),%eax
    cprintf(">COPYUVM-DONE!\t");
80107951:	83 c4 10             	add    $0x10,%esp
}
80107954:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107957:	5b                   	pop    %ebx
80107958:	5e                   	pop    %esi
80107959:	5f                   	pop    %edi
8010795a:	5d                   	pop    %ebp
8010795b:	c3                   	ret    
      panic("copyuvm: pte should exist");
8010795c:	83 ec 0c             	sub    $0xc,%esp
8010795f:	68 ff 84 10 80       	push   $0x801084ff
80107964:	e8 27 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107969:	83 ec 0c             	sub    $0xc,%esp
8010796c:	68 19 85 10 80       	push   $0x80108519
80107971:	e8 1a 8a ff ff       	call   80100390 <panic>
80107976:	8d 76 00             	lea    0x0(%esi),%esi
80107979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107980 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107980:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107981:	31 c9                	xor    %ecx,%ecx
{
80107983:	89 e5                	mov    %esp,%ebp
80107985:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107988:	8b 55 0c             	mov    0xc(%ebp),%edx
8010798b:	8b 45 08             	mov    0x8(%ebp),%eax
8010798e:	e8 5d f3 ff ff       	call   80106cf0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107993:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107995:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107996:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107998:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010799d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079a0:	05 00 00 00 80       	add    $0x80000000,%eax
801079a5:	83 fa 05             	cmp    $0x5,%edx
801079a8:	ba 00 00 00 00       	mov    $0x0,%edx
801079ad:	0f 45 c2             	cmovne %edx,%eax
}
801079b0:	c3                   	ret    
801079b1:	eb 0d                	jmp    801079c0 <copyout>
801079b3:	90                   	nop
801079b4:	90                   	nop
801079b5:	90                   	nop
801079b6:	90                   	nop
801079b7:	90                   	nop
801079b8:	90                   	nop
801079b9:	90                   	nop
801079ba:	90                   	nop
801079bb:	90                   	nop
801079bc:	90                   	nop
801079bd:	90                   	nop
801079be:	90                   	nop
801079bf:	90                   	nop

801079c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	57                   	push   %edi
801079c4:	56                   	push   %esi
801079c5:	53                   	push   %ebx
801079c6:	83 ec 1c             	sub    $0x1c,%esp
801079c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801079cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801079cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801079d2:	85 db                	test   %ebx,%ebx
801079d4:	75 40                	jne    80107a16 <copyout+0x56>
801079d6:	eb 70                	jmp    80107a48 <copyout+0x88>
801079d8:	90                   	nop
801079d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801079e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801079e3:	89 f1                	mov    %esi,%ecx
801079e5:	29 d1                	sub    %edx,%ecx
801079e7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801079ed:	39 d9                	cmp    %ebx,%ecx
801079ef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801079f2:	29 f2                	sub    %esi,%edx
801079f4:	83 ec 04             	sub    $0x4,%esp
801079f7:	01 d0                	add    %edx,%eax
801079f9:	51                   	push   %ecx
801079fa:	57                   	push   %edi
801079fb:	50                   	push   %eax
801079fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801079ff:	e8 1c d2 ff ff       	call   80104c20 <memmove>
    len -= n;
    buf += n;
80107a04:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107a07:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107a0a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107a10:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107a12:	29 cb                	sub    %ecx,%ebx
80107a14:	74 32                	je     80107a48 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107a16:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a18:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107a1b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107a1e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107a24:	56                   	push   %esi
80107a25:	ff 75 08             	pushl  0x8(%ebp)
80107a28:	e8 53 ff ff ff       	call   80107980 <uva2ka>
    if(pa0 == 0)
80107a2d:	83 c4 10             	add    $0x10,%esp
80107a30:	85 c0                	test   %eax,%eax
80107a32:	75 ac                	jne    801079e0 <copyout+0x20>
  }
  return 0;
}
80107a34:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a3c:	5b                   	pop    %ebx
80107a3d:	5e                   	pop    %esi
80107a3e:	5f                   	pop    %edi
80107a3f:	5d                   	pop    %ebp
80107a40:	c3                   	ret    
80107a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a4b:	31 c0                	xor    %eax,%eax
}
80107a4d:	5b                   	pop    %ebx
80107a4e:	5e                   	pop    %esi
80107a4f:	5f                   	pop    %edi
80107a50:	5d                   	pop    %ebp
80107a51:	c3                   	ret    
