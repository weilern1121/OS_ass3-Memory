
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
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 32 10 80       	mov    $0x801032e0,%eax
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
80100044:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 74 10 80       	push   $0x801074c0
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 75 46 00 00       	call   801046d0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd2c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 fd 10 80 dc 	movl   $0x8010fcdc,0x8010fd30
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc fc 10 80       	mov    $0x8010fcdc,%edx
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
8010008b:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 74 10 80       	push   $0x801074c7
80100097:	50                   	push   %eax
80100098:	e8 23 45 00 00       	call   801045c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc fc 10 80       	cmp    $0x8010fcdc,%eax
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
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 d7 46 00 00       	call   801047c0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 fd 10 80    	mov    0x8010fd30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
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
80100120:	8b 1d 2c fd 10 80    	mov    0x8010fd2c,%ebx
80100126:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc fc 10 80    	cmp    $0x8010fcdc,%ebx
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
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 79 47 00 00       	call   801048e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 44 00 00       	call   80104600 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 3d 23 00 00       	call   801024c0 <iderw>
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
80100193:	68 ce 74 10 80       	push   $0x801074ce
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
801001ae:	e8 ed 44 00 00       	call   801046a0 <holdingsleep>
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
801001c4:	e9 f7 22 00 00       	jmp    801024c0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 74 10 80       	push   $0x801074df
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
801001ef:	e8 ac 44 00 00       	call   801046a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 44 00 00       	call   80104660 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 b0 45 00 00       	call   801047c0 <acquire>
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
80100232:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc fc 10 80 	movl   $0x8010fcdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 fd 10 80       	mov    0x8010fd30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 fd 10 80    	mov    %ebx,0x8010fd30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 7f 46 00 00       	jmp    801048e0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 74 10 80       	push   $0x801074e6
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
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 2f 45 00 00       	call   801047c0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002a7:	39 15 c4 ff 10 80    	cmp    %edx,0x8010ffc4
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
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 c0 ff 10 80       	push   $0x8010ffc0
801002c5:	e8 36 3f 00 00       	call   80104200 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 ff 10 80    	mov    0x8010ffc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 ff 10 80    	cmp    0x8010ffc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 60 39 00 00       	call   80103c40 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 ec 45 00 00       	call   801048e0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
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
80100313:	a3 c0 ff 10 80       	mov    %eax,0x8010ffc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 ff 10 80 	movsbl -0x7fef00c0(%eax),%eax
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
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 8e 45 00 00       	call   801048e0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
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
80100372:	89 15 c0 ff 10 80    	mov    %edx,0x8010ffc0
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
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 c2 27 00 00       	call   80102b70 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 74 10 80       	push   $0x801074ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 c9 7e 10 80 	movl   $0x80107ec9,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 13 43 00 00       	call   801046f0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 75 10 80       	push   $0x80107501
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
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
8010043a:	e8 c1 5b 00 00       	call   80106000 <uartputc>
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
801004ec:	e8 0f 5b 00 00       	call   80106000 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 03 5b 00 00       	call   80106000 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 f7 5a 00 00       	call   80106000 <uartputc>
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
80100524:	e8 c7 44 00 00       	call   801049f0 <memmove>
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
80100541:	e8 fa 43 00 00       	call   80104940 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 75 10 80       	push   $0x80107505
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
801005b1:	0f b6 92 30 75 10 80 	movzbl -0x7fef8ad0(%edx),%edx
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
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 a0 41 00 00       	call   801047c0 <acquire>
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
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 94 42 00 00       	call   801048e0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

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
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
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
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 bc 41 00 00       	call   801048e0 <release>
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
801007d0:	ba 18 75 10 80       	mov    $0x80107518,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 cb 3f 00 00       	call   801047c0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 75 10 80       	push   $0x8010751f
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
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 98 3f 00 00       	call   801047c0 <acquire>
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
80100851:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100856:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
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
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 53 40 00 00       	call   801048e0 <release>
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
801008a9:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 ff 10 80    	sub    0x8010ffc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 ff 10 80    	mov    %edx,0x8010ffc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 ff 10 80    	mov    %cl,-0x7fef00c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 ff 10 80       	mov    0x8010ffc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 ff 10 80    	cmp    %eax,0x8010ffc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 ff 10 80       	mov    %eax,0x8010ffc4
          wakeup(&input.r);
80100911:	68 c0 ff 10 80       	push   $0x8010ffc0
80100916:	e8 a5 3a 00 00       	call   801043c0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
8010093d:	39 05 c4 ff 10 80    	cmp    %eax,0x8010ffc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 ff 10 80       	mov    %eax,0x8010ffc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
80100964:	3b 05 c4 ff 10 80    	cmp    0x8010ffc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 ff 10 80 0a 	cmpb   $0xa,-0x7fef00c0(%edx)
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
80100997:	e9 04 3b 00 00       	jmp    801044a0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 ff 10 80 0a 	movb   $0xa,-0x7fef00c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 ff 10 80       	mov    0x8010ffc8,%eax
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
801009c6:	68 28 75 10 80       	push   $0x80107528
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 fb 3c 00 00       	call   801046d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 09 11 80 00 	movl   $0x80100600,0x8011098c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 09 11 80 70 	movl   $0x80100270,0x80110988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 72 1c 00 00       	call   80102670 <ioapicenable>
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
80100a1c:	e8 1f 32 00 00       	call   80103c40 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

    begin_op();
80100a27:	e8 b4 25 00 00       	call   80102fe0 <begin_op>

    if ((ip = namei(path)) == 0) {
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
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
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char *) &elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
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
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
        end_op();
80100a6f:	e8 dc 25 00 00       	call   80103050 <end_op>
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
80100a94:	e8 97 67 00 00       	call   80107230 <setupkvm>
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
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
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
80100af6:	e8 55 65 00 00       	call   80107050 <allocuvm>
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
80100b28:	e8 c3 63 00 00       	call   80106ef0 <loaduvm>
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
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
        freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 39 66 00 00       	call   801071b0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
    iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
    end_op();
80100b9a:	e8 b1 24 00 00       	call   80103050 <end_op>
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 a1 64 00 00       	call   80107050 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
        freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ea 65 00 00       	call   801071b0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
        end_op();
80100bd3:	e8 78 24 00 00       	call   80103050 <end_op>
        cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 41 75 10 80       	push   $0x80107541
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
80100c06:	e8 c5 66 00 00       	call   801072d0 <clearpteu>
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
80100c39:	e8 22 3f 00 00       	call   80104b60 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 0f 3f 00 00       	call   80104b60 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 be 67 00 00       	call   80107420 <copyout>
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
    ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
    ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
    sp -= (3 + argc + 1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100cc7:	e8 54 67 00 00       	call   80107420 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
    for (last = s = path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 11 3e 00 00       	call   80104b20 <safestrcpy>
    curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
    oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
    curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
    curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
    curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
    curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
    switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 27 60 00 00       	call   80106d60 <switchuvm>
    freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 6f 64 00 00       	call   801071b0 <freevm>
    return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 4d 75 10 80       	push   $0x8010754d
80100d6b:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d70:	e8 5b 39 00 00       	call   801046d0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 14 00 11 80       	mov    $0x80110014,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100d91:	e8 2a 3a 00 00       	call   801047c0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 74 09 11 80    	cmp    $0x80110974,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dc1:	e8 1a 3b 00 00       	call   801048e0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dda:	e8 01 3b 00 00       	call   801048e0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 e0 ff 10 80       	push   $0x8010ffe0
80100dff:	e8 bc 39 00 00       	call   801047c0 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e1c:	e8 bf 3a 00 00       	call   801048e0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 75 10 80       	push   $0x80107554
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 e0 ff 10 80       	push   $0x8010ffe0
80100e51:	e8 6a 39 00 00       	call   801047c0 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 e0 ff 10 80 	movl   $0x8010ffe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 5f 3a 00 00       	jmp    801048e0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 e0 ff 10 80       	push   $0x8010ffe0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 33 3a 00 00       	call   801048e0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 ba 28 00 00       	call   80103790 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 fb 20 00 00       	call   80102fe0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 51 21 00 00       	jmp    80103050 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 5c 75 10 80       	push   $0x8010755c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 6e 29 00 00       	jmp    80103940 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 66 75 10 80       	push   $0x80107566
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 02 20 00 00       	call   80103050 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 65 1f 00 00       	call   80102fe0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 9e 1f 00 00       	call   80103050 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 3e 27 00 00       	jmp    80103830 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 6f 75 10 80       	push   $0x8010756f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 75 75 10 80       	push   $0x80107575
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d e0 09 11 80    	mov    0x801109e0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 f8 09 11 80    	add    0x801109f8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 e0 09 11 80       	mov    0x801109e0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 7f 75 10 80       	push   $0x8010757f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 de 1f 00 00       	call   801031b0 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 46 37 00 00       	call   80104940 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 ae 1f 00 00       	call   801031b0 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 00 0a 11 80       	push   $0x80110a00
8010123a:	e8 81 35 00 00       	call   801047c0 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 00 0a 11 80       	push   $0x80110a00
8010129f:	e8 3c 36 00 00       	call   801048e0 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 00 0a 11 80       	push   $0x80110a00
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 0e 36 00 00       	call   801048e0 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 95 75 10 80       	push   $0x80107595
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 4d 1e 00 00       	call   801031b0 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 a5 75 10 80       	push   $0x801075a5
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 fa 35 00 00       	call   801049f0 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 e0 09 11 80       	push   $0x801109e0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 f8 09 11 80    	add    0x801109f8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 41 1d 00 00       	call   801031b0 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 b8 75 10 80       	push   $0x801075b8
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 cb 75 10 80       	push   $0x801075cb
801014a1:	68 00 0a 11 80       	push   $0x80110a00
801014a6:	e8 25 32 00 00       	call   801046d0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 d2 75 10 80       	push   $0x801075d2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 fc 30 00 00       	call   801045c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 e0 09 11 80       	push   $0x801109e0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 f8 09 11 80    	pushl  0x801109f8
801014e5:	ff 35 f4 09 11 80    	pushl  0x801109f4
801014eb:	ff 35 f0 09 11 80    	pushl  0x801109f0
801014f1:	ff 35 ec 09 11 80    	pushl  0x801109ec
801014f7:	ff 35 e8 09 11 80    	pushl  0x801109e8
801014fd:	ff 35 e4 09 11 80    	pushl  0x801109e4
80101503:	ff 35 e0 09 11 80    	pushl  0x801109e0
80101509:	68 7c 76 10 80       	push   $0x8010767c
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d e8 09 11 80 01 	cmpl   $0x1,0x801109e8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d e8 09 11 80    	cmp    %ebx,0x801109e8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 f4 09 11 80    	add    0x801109f4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 9d 33 00 00       	call   80104940 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 fb 1b 00 00       	call   801031b0 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 d8 75 10 80       	push   $0x801075d8
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 aa 33 00 00       	call   801049f0 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 62 1b 00 00       	call   801031b0 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 00 0a 11 80       	push   $0x80110a00
8010166f:	e8 4c 31 00 00       	call   801047c0 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010167f:	e8 5c 32 00 00       	call   801048e0 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 49 2f 00 00       	call   80104600 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 f4 09 11 80    	add    0x801109f4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 c3 32 00 00       	call   801049f0 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 f0 75 10 80       	push   $0x801075f0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 ea 75 10 80       	push   $0x801075ea
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 18 2f 00 00       	call   801046a0 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 bc 2e 00 00       	jmp    80104660 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 ff 75 10 80       	push   $0x801075ff
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 2b 2e 00 00       	call   80104600 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 71 2e 00 00       	call   80104660 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
801017f6:	e8 c5 2f 00 00       	call   801047c0 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 cb 30 00 00       	jmp    801048e0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 00 0a 11 80       	push   $0x80110a00
80101820:	e8 9b 2f 00 00       	call   801047c0 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010182f:	e8 ac 30 00 00       	call   801048e0 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 d4 2f 00 00       	call   801049f0 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 80 09 11 80 	mov    -0x7feef680(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 d8 2e 00 00       	call   801049f0 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 90 16 00 00       	call   801031b0 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 84 09 11 80 	mov    -0x7feef67c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 ad 2e 00 00       	call   80104a60 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 4e 2e 00 00       	call   80104a60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 19 76 10 80       	push   $0x80107619
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 07 76 10 80       	push   $0x80107607
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 b2 1f 00 00       	call   80103c40 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 00 0a 11 80       	push   $0x80110a00
80101c99:	e8 22 2b 00 00       	call   801047c0 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101ca9:	e8 32 2c 00 00       	call   801048e0 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 e6 2c 00 00       	call   801049f0 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 53 2c 00 00       	call   801049f0 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 2e 2c 00 00       	call   80104ac0 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 28 76 10 80       	push   $0x80107628
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 d1 7c 10 80       	push   $0x80107cd1
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f30 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f30:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f31:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101f36:	89 e5                	mov    %esp,%ebp
80101f38:	57                   	push   %edi
80101f39:	56                   	push   %esi
80101f3a:	53                   	push   %ebx
80101f3b:	83 ec 10             	sub    $0x10,%esp
80101f3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f41:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f48:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f4f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101f53:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101f57:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101f5a:	85 c9                	test   %ecx,%ecx
80101f5c:	79 0a                	jns    80101f68 <itoa+0x38>
80101f5e:	89 f0                	mov    %esi,%eax
80101f60:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80101f63:	f7 d9                	neg    %ecx
        *p++ = '-';
80101f65:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80101f68:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f6a:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f6f:	90                   	nop
80101f70:	89 d8                	mov    %ebx,%eax
80101f72:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80101f75:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101f78:	f7 ef                	imul   %edi
80101f7a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101f7d:	29 da                	sub    %ebx,%edx
80101f7f:	89 d3                	mov    %edx,%ebx
80101f81:	75 ed                	jne    80101f70 <itoa+0x40>
    *p = '\0';
80101f83:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f86:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101f8b:	90                   	nop
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f90:	89 c8                	mov    %ecx,%eax
80101f92:	83 ee 01             	sub    $0x1,%esi
80101f95:	f7 eb                	imul   %ebx
80101f97:	89 c8                	mov    %ecx,%eax
80101f99:	c1 f8 1f             	sar    $0x1f,%eax
80101f9c:	c1 fa 02             	sar    $0x2,%edx
80101f9f:	29 c2                	sub    %eax,%edx
80101fa1:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101fa4:	01 c0                	add    %eax,%eax
80101fa6:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101fa8:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
80101faa:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101faf:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80101fb1:	88 06                	mov    %al,(%esi)
    }while(i);
80101fb3:	75 db                	jne    80101f90 <itoa+0x60>
    return b;
}
80101fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5f                   	pop    %edi
80101fbe:	5d                   	pop    %ebp
80101fbf:	c3                   	ret    

80101fc0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101fc6:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80101fc9:	83 ec 40             	sub    $0x40,%esp
80101fcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80101fcf:	6a 06                	push   $0x6
80101fd1:	68 35 76 10 80       	push   $0x80107635
80101fd6:	56                   	push   %esi
80101fd7:	e8 14 2a 00 00       	call   801049f0 <memmove>
  itoa(p->pid, path+ 6);
80101fdc:	58                   	pop    %eax
80101fdd:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80101fe0:	5a                   	pop    %edx
80101fe1:	50                   	push   %eax
80101fe2:	ff 73 10             	pushl  0x10(%ebx)
80101fe5:	e8 46 ff ff ff       	call   80101f30 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
80101fea:	8b 43 7c             	mov    0x7c(%ebx),%eax
80101fed:	83 c4 10             	add    $0x10,%esp
80101ff0:	85 c0                	test   %eax,%eax
80101ff2:	0f 84 88 01 00 00    	je     80102180 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80101ff8:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
80101ffb:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
80101ffe:	50                   	push   %eax
80101fff:	e8 3c ee ff ff       	call   80100e40 <fileclose>

  begin_op();
80102004:	e8 d7 0f 00 00       	call   80102fe0 <begin_op>
  return namex(path, 1, name);
80102009:	89 f0                	mov    %esi,%eax
8010200b:	89 d9                	mov    %ebx,%ecx
8010200d:	ba 01 00 00 00       	mov    $0x1,%edx
80102012:	e8 59 fc ff ff       	call   80101c70 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010201c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010201e:	0f 84 66 01 00 00    	je     8010218a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102024:	83 ec 0c             	sub    $0xc,%esp
80102027:	50                   	push   %eax
80102028:	e8 63 f6 ff ff       	call   80101690 <ilock>
  return strncmp(s, t, DIRSIZ);
8010202d:	83 c4 0c             	add    $0xc,%esp
80102030:	6a 0e                	push   $0xe
80102032:	68 3d 76 10 80       	push   $0x8010763d
80102037:	53                   	push   %ebx
80102038:	e8 23 2a 00 00       	call   80104a60 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010203d:	83 c4 10             	add    $0x10,%esp
80102040:	85 c0                	test   %eax,%eax
80102042:	0f 84 f8 00 00 00    	je     80102140 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102048:	83 ec 04             	sub    $0x4,%esp
8010204b:	6a 0e                	push   $0xe
8010204d:	68 3c 76 10 80       	push   $0x8010763c
80102052:	53                   	push   %ebx
80102053:	e8 08 2a 00 00       	call   80104a60 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	85 c0                	test   %eax,%eax
8010205d:	0f 84 dd 00 00 00    	je     80102140 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102063:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102066:	83 ec 04             	sub    $0x4,%esp
80102069:	50                   	push   %eax
8010206a:	53                   	push   %ebx
8010206b:	56                   	push   %esi
8010206c:	e8 4f fb ff ff       	call   80101bc0 <dirlookup>
80102071:	83 c4 10             	add    $0x10,%esp
80102074:	85 c0                	test   %eax,%eax
80102076:	89 c3                	mov    %eax,%ebx
80102078:	0f 84 c2 00 00 00    	je     80102140 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010207e:	83 ec 0c             	sub    $0xc,%esp
80102081:	50                   	push   %eax
80102082:	e8 09 f6 ff ff       	call   80101690 <ilock>

  if(ip->nlink < 1)
80102087:	83 c4 10             	add    $0x10,%esp
8010208a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010208f:	0f 8e 11 01 00 00    	jle    801021a6 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102095:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010209a:	74 74                	je     80102110 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010209c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010209f:	83 ec 04             	sub    $0x4,%esp
801020a2:	6a 10                	push   $0x10
801020a4:	6a 00                	push   $0x0
801020a6:	57                   	push   %edi
801020a7:	e8 94 28 00 00       	call   80104940 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ac:	6a 10                	push   $0x10
801020ae:	ff 75 b8             	pushl  -0x48(%ebp)
801020b1:	57                   	push   %edi
801020b2:	56                   	push   %esi
801020b3:	e8 b8 f9 ff ff       	call   80101a70 <writei>
801020b8:	83 c4 20             	add    $0x20,%esp
801020bb:	83 f8 10             	cmp    $0x10,%eax
801020be:	0f 85 d5 00 00 00    	jne    80102199 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020c4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020c9:	0f 84 91 00 00 00    	je     80102160 <removeSwapFile+0x1a0>
  iunlock(ip);
801020cf:	83 ec 0c             	sub    $0xc,%esp
801020d2:	56                   	push   %esi
801020d3:	e8 98 f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
801020d8:	89 34 24             	mov    %esi,(%esp)
801020db:	e8 e0 f6 ff ff       	call   801017c0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801020e0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801020e5:	89 1c 24             	mov    %ebx,(%esp)
801020e8:	e8 f3 f4 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
801020ed:	89 1c 24             	mov    %ebx,(%esp)
801020f0:	e8 7b f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
801020f5:	89 1c 24             	mov    %ebx,(%esp)
801020f8:	e8 c3 f6 ff ff       	call   801017c0 <iput>
  iunlockput(ip);

  end_op();
801020fd:	e8 4e 0f 00 00       	call   80103050 <end_op>

  return 0;
80102102:	83 c4 10             	add    $0x10,%esp
80102105:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102107:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210a:	5b                   	pop    %ebx
8010210b:	5e                   	pop    %esi
8010210c:	5f                   	pop    %edi
8010210d:	5d                   	pop    %ebp
8010210e:	c3                   	ret    
8010210f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	53                   	push   %ebx
80102114:	e8 07 30 00 00       	call   80105120 <isdirempty>
80102119:	83 c4 10             	add    $0x10,%esp
8010211c:	85 c0                	test   %eax,%eax
8010211e:	0f 85 78 ff ff ff    	jne    8010209c <removeSwapFile+0xdc>
  iunlock(ip);
80102124:	83 ec 0c             	sub    $0xc,%esp
80102127:	53                   	push   %ebx
80102128:	e8 43 f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
8010212d:	89 1c 24             	mov    %ebx,(%esp)
80102130:	e8 8b f6 ff ff       	call   801017c0 <iput>
80102135:	83 c4 10             	add    $0x10,%esp
80102138:	90                   	nop
80102139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102140:	83 ec 0c             	sub    $0xc,%esp
80102143:	56                   	push   %esi
80102144:	e8 27 f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
80102149:	89 34 24             	mov    %esi,(%esp)
8010214c:	e8 6f f6 ff ff       	call   801017c0 <iput>
    end_op();
80102151:	e8 fa 0e 00 00       	call   80103050 <end_op>
    return -1;
80102156:	83 c4 10             	add    $0x10,%esp
80102159:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010215e:	eb a7                	jmp    80102107 <removeSwapFile+0x147>
    dp->nlink--;
80102160:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	56                   	push   %esi
80102169:	e8 72 f4 ff ff       	call   801015e0 <iupdate>
8010216e:	83 c4 10             	add    $0x10,%esp
80102171:	e9 59 ff ff ff       	jmp    801020cf <removeSwapFile+0x10f>
80102176:	8d 76 00             	lea    0x0(%esi),%esi
80102179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102185:	e9 7d ff ff ff       	jmp    80102107 <removeSwapFile+0x147>
    end_op();
8010218a:	e8 c1 0e 00 00       	call   80103050 <end_op>
    return -1;
8010218f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102194:	e9 6e ff ff ff       	jmp    80102107 <removeSwapFile+0x147>
    panic("unlink: writei");
80102199:	83 ec 0c             	sub    $0xc,%esp
8010219c:	68 51 76 10 80       	push   $0x80107651
801021a1:	e8 ea e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021a6:	83 ec 0c             	sub    $0xc,%esp
801021a9:	68 3f 76 10 80       	push   $0x8010763f
801021ae:	e8 dd e1 ff ff       	call   80100390 <panic>
801021b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p) {
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	56                   	push   %esi
801021c4:	53                   	push   %ebx

    char path[DIGITS];
    memmove(path, "/.swap", 6);
801021c5:	8d 75 ea             	lea    -0x16(%ebp),%esi
createSwapFile(struct proc* p) {
801021c8:	83 ec 14             	sub    $0x14,%esp
801021cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    memmove(path, "/.swap", 6);
801021ce:	6a 06                	push   $0x6
801021d0:	68 35 76 10 80       	push   $0x80107635
801021d5:	56                   	push   %esi
801021d6:	e8 15 28 00 00       	call   801049f0 <memmove>
    itoa(p->pid, path + 6);
801021db:	58                   	pop    %eax
801021dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801021df:	5a                   	pop    %edx
801021e0:	50                   	push   %eax
801021e1:	ff 73 10             	pushl  0x10(%ebx)
801021e4:	e8 47 fd ff ff       	call   80101f30 <itoa>

    begin_op();
801021e9:	e8 f2 0d 00 00       	call   80102fe0 <begin_op>
    struct inode *in = create(path, T_FILE, 0, 0);
801021ee:	6a 00                	push   $0x0
801021f0:	6a 00                	push   $0x0
801021f2:	6a 02                	push   $0x2
801021f4:	56                   	push   %esi
801021f5:	e8 36 31 00 00       	call   80105330 <create>
    iunlock(in);
801021fa:	83 c4 14             	add    $0x14,%esp
    struct inode *in = create(path, T_FILE, 0, 0);
801021fd:	89 c6                	mov    %eax,%esi
    iunlock(in);
801021ff:	50                   	push   %eax
80102200:	e8 6b f5 ff ff       	call   80101770 <iunlock>

    p->swapFile = filealloc();
80102205:	e8 76 eb ff ff       	call   80100d80 <filealloc>
    if (p->swapFile == 0)
8010220a:	83 c4 10             	add    $0x10,%esp
8010220d:	85 c0                	test   %eax,%eax
    p->swapFile = filealloc();
8010220f:	89 43 7c             	mov    %eax,0x7c(%ebx)
    if (p->swapFile == 0)
80102212:	74 32                	je     80102246 <createSwapFile+0x86>
        panic("no slot for files on /store");

    p->swapFile->ip = in;
80102214:	89 70 10             	mov    %esi,0x10(%eax)
    p->swapFile->type = FD_INODE;
80102217:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010221a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    p->swapFile->off = 0;
80102220:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102223:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    p->swapFile->readable = O_WRONLY;
8010222a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010222d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
    p->swapFile->writable = O_RDWR;
80102231:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102234:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102238:	e8 13 0e 00 00       	call   80103050 <end_op>

    return 0;
}
8010223d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102240:	31 c0                	xor    %eax,%eax
80102242:	5b                   	pop    %ebx
80102243:	5e                   	pop    %esi
80102244:	5d                   	pop    %ebp
80102245:	c3                   	ret    
        panic("no slot for files on /store");
80102246:	83 ec 0c             	sub    $0xc,%esp
80102249:	68 60 76 10 80       	push   $0x80107660
8010224e:	e8 3d e1 ff ff       	call   80100390 <panic>
80102253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102260 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102266:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102269:	8b 50 7c             	mov    0x7c(%eax),%edx
8010226c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010226f:	8b 55 14             	mov    0x14(%ebp),%edx
80102272:	89 55 10             	mov    %edx,0x10(%ebp)
80102275:	8b 40 7c             	mov    0x7c(%eax),%eax
80102278:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010227b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010227c:	e9 6f ed ff ff       	jmp    80100ff0 <filewrite>
80102281:	eb 0d                	jmp    80102290 <readFromSwapFile>
80102283:	90                   	nop
80102284:	90                   	nop
80102285:	90                   	nop
80102286:	90                   	nop
80102287:	90                   	nop
80102288:	90                   	nop
80102289:	90                   	nop
8010228a:	90                   	nop
8010228b:	90                   	nop
8010228c:	90                   	nop
8010228d:	90                   	nop
8010228e:	90                   	nop
8010228f:	90                   	nop

80102290 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102296:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102299:	8b 50 7c             	mov    0x7c(%eax),%edx
8010229c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010229f:	8b 55 14             	mov    0x14(%ebp),%edx
801022a2:	89 55 10             	mov    %edx,0x10(%ebp)
801022a5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022a8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801022ab:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801022ac:	e9 af ec ff ff       	jmp    80100f60 <fileread>
801022b1:	66 90                	xchg   %ax,%ax
801022b3:	66 90                	xchg   %ax,%ax
801022b5:	66 90                	xchg   %ax,%ax
801022b7:	66 90                	xchg   %ax,%ax
801022b9:	66 90                	xchg   %ax,%ax
801022bb:	66 90                	xchg   %ax,%ax
801022bd:	66 90                	xchg   %ax,%ax
801022bf:	90                   	nop

801022c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	57                   	push   %edi
801022c4:	56                   	push   %esi
801022c5:	53                   	push   %ebx
801022c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801022c9:	85 c0                	test   %eax,%eax
801022cb:	0f 84 b4 00 00 00    	je     80102385 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022d1:	8b 58 08             	mov    0x8(%eax),%ebx
801022d4:	89 c6                	mov    %eax,%esi
801022d6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022dc:	0f 87 96 00 00 00    	ja     80102378 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022e7:	89 f6                	mov    %esi,%esi
801022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801022f0:	89 ca                	mov    %ecx,%edx
801022f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f3:	83 e0 c0             	and    $0xffffffc0,%eax
801022f6:	3c 40                	cmp    $0x40,%al
801022f8:	75 f6                	jne    801022f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022fa:	31 ff                	xor    %edi,%edi
801022fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102301:	89 f8                	mov    %edi,%eax
80102303:	ee                   	out    %al,(%dx)
80102304:	b8 01 00 00 00       	mov    $0x1,%eax
80102309:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010230e:	ee                   	out    %al,(%dx)
8010230f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102314:	89 d8                	mov    %ebx,%eax
80102316:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102317:	89 d8                	mov    %ebx,%eax
80102319:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010231e:	c1 f8 08             	sar    $0x8,%eax
80102321:	ee                   	out    %al,(%dx)
80102322:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102327:	89 f8                	mov    %edi,%eax
80102329:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010232a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010232e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102333:	c1 e0 04             	shl    $0x4,%eax
80102336:	83 e0 10             	and    $0x10,%eax
80102339:	83 c8 e0             	or     $0xffffffe0,%eax
8010233c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010233d:	f6 06 04             	testb  $0x4,(%esi)
80102340:	75 16                	jne    80102358 <idestart+0x98>
80102342:	b8 20 00 00 00       	mov    $0x20,%eax
80102347:	89 ca                	mov    %ecx,%edx
80102349:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010234a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010234d:	5b                   	pop    %ebx
8010234e:	5e                   	pop    %esi
8010234f:	5f                   	pop    %edi
80102350:	5d                   	pop    %ebp
80102351:	c3                   	ret    
80102352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102358:	b8 30 00 00 00       	mov    $0x30,%eax
8010235d:	89 ca                	mov    %ecx,%edx
8010235f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102360:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102365:	83 c6 5c             	add    $0x5c,%esi
80102368:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010236d:	fc                   	cld    
8010236e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102370:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102373:	5b                   	pop    %ebx
80102374:	5e                   	pop    %esi
80102375:	5f                   	pop    %edi
80102376:	5d                   	pop    %ebp
80102377:	c3                   	ret    
    panic("incorrect blockno");
80102378:	83 ec 0c             	sub    $0xc,%esp
8010237b:	68 d8 76 10 80       	push   $0x801076d8
80102380:	e8 0b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102385:	83 ec 0c             	sub    $0xc,%esp
80102388:	68 cf 76 10 80       	push   $0x801076cf
8010238d:	e8 fe df ff ff       	call   80100390 <panic>
80102392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023a0 <ideinit>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023a6:	68 ea 76 10 80       	push   $0x801076ea
801023ab:	68 80 a5 10 80       	push   $0x8010a580
801023b0:	e8 1b 23 00 00       	call   801046d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023b5:	58                   	pop    %eax
801023b6:	a1 20 2d 11 80       	mov    0x80112d20,%eax
801023bb:	5a                   	pop    %edx
801023bc:	83 e8 01             	sub    $0x1,%eax
801023bf:	50                   	push   %eax
801023c0:	6a 0e                	push   $0xe
801023c2:	e8 a9 02 00 00       	call   80102670 <ioapicenable>
801023c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023cf:	90                   	nop
801023d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023d1:	83 e0 c0             	and    $0xffffffc0,%eax
801023d4:	3c 40                	cmp    $0x40,%al
801023d6:	75 f8                	jne    801023d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023dd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023e2:	ee                   	out    %al,(%dx)
801023e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ed:	eb 06                	jmp    801023f5 <ideinit+0x55>
801023ef:	90                   	nop
  for(i=0; i<1000; i++){
801023f0:	83 e9 01             	sub    $0x1,%ecx
801023f3:	74 0f                	je     80102404 <ideinit+0x64>
801023f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023f6:	84 c0                	test   %al,%al
801023f8:	74 f6                	je     801023f0 <ideinit+0x50>
      havedisk1 = 1;
801023fa:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102401:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102404:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102409:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010240e:	ee                   	out    %al,(%dx)
}
8010240f:	c9                   	leave  
80102410:	c3                   	ret    
80102411:	eb 0d                	jmp    80102420 <ideintr>
80102413:	90                   	nop
80102414:	90                   	nop
80102415:	90                   	nop
80102416:	90                   	nop
80102417:	90                   	nop
80102418:	90                   	nop
80102419:	90                   	nop
8010241a:	90                   	nop
8010241b:	90                   	nop
8010241c:	90                   	nop
8010241d:	90                   	nop
8010241e:	90                   	nop
8010241f:	90                   	nop

80102420 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	57                   	push   %edi
80102424:	56                   	push   %esi
80102425:	53                   	push   %ebx
80102426:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102429:	68 80 a5 10 80       	push   $0x8010a580
8010242e:	e8 8d 23 00 00       	call   801047c0 <acquire>

  if((b = idequeue) == 0){
80102433:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102439:	83 c4 10             	add    $0x10,%esp
8010243c:	85 db                	test   %ebx,%ebx
8010243e:	74 67                	je     801024a7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102440:	8b 43 58             	mov    0x58(%ebx),%eax
80102443:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102448:	8b 3b                	mov    (%ebx),%edi
8010244a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102450:	75 31                	jne    80102483 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102452:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102457:	89 f6                	mov    %esi,%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102460:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102461:	89 c6                	mov    %eax,%esi
80102463:	83 e6 c0             	and    $0xffffffc0,%esi
80102466:	89 f1                	mov    %esi,%ecx
80102468:	80 f9 40             	cmp    $0x40,%cl
8010246b:	75 f3                	jne    80102460 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010246d:	a8 21                	test   $0x21,%al
8010246f:	75 12                	jne    80102483 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102471:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102474:	b9 80 00 00 00       	mov    $0x80,%ecx
80102479:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010247e:	fc                   	cld    
8010247f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102481:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102483:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102486:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102489:	89 f9                	mov    %edi,%ecx
8010248b:	83 c9 02             	or     $0x2,%ecx
8010248e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102490:	53                   	push   %ebx
80102491:	e8 2a 1f 00 00       	call   801043c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102496:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010249b:	83 c4 10             	add    $0x10,%esp
8010249e:	85 c0                	test   %eax,%eax
801024a0:	74 05                	je     801024a7 <ideintr+0x87>
    idestart(idequeue);
801024a2:	e8 19 fe ff ff       	call   801022c0 <idestart>
    release(&idelock);
801024a7:	83 ec 0c             	sub    $0xc,%esp
801024aa:	68 80 a5 10 80       	push   $0x8010a580
801024af:	e8 2c 24 00 00       	call   801048e0 <release>

  release(&idelock);
}
801024b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024b7:	5b                   	pop    %ebx
801024b8:	5e                   	pop    %esi
801024b9:	5f                   	pop    %edi
801024ba:	5d                   	pop    %ebp
801024bb:	c3                   	ret    
801024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 10             	sub    $0x10,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801024cd:	50                   	push   %eax
801024ce:	e8 cd 21 00 00       	call   801046a0 <holdingsleep>
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	85 c0                	test   %eax,%eax
801024d8:	0f 84 c6 00 00 00    	je     801025a4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024de:	8b 03                	mov    (%ebx),%eax
801024e0:	83 e0 06             	and    $0x6,%eax
801024e3:	83 f8 02             	cmp    $0x2,%eax
801024e6:	0f 84 ab 00 00 00    	je     80102597 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024ec:	8b 53 04             	mov    0x4(%ebx),%edx
801024ef:	85 d2                	test   %edx,%edx
801024f1:	74 0d                	je     80102500 <iderw+0x40>
801024f3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801024f8:	85 c0                	test   %eax,%eax
801024fa:	0f 84 b1 00 00 00    	je     801025b1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 80 a5 10 80       	push   $0x8010a580
80102508:	e8 b3 22 00 00       	call   801047c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010250d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102513:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102516:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010251d:	85 d2                	test   %edx,%edx
8010251f:	75 09                	jne    8010252a <iderw+0x6a>
80102521:	eb 6d                	jmp    80102590 <iderw+0xd0>
80102523:	90                   	nop
80102524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102528:	89 c2                	mov    %eax,%edx
8010252a:	8b 42 58             	mov    0x58(%edx),%eax
8010252d:	85 c0                	test   %eax,%eax
8010252f:	75 f7                	jne    80102528 <iderw+0x68>
80102531:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102534:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102536:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010253c:	74 42                	je     80102580 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010253e:	8b 03                	mov    (%ebx),%eax
80102540:	83 e0 06             	and    $0x6,%eax
80102543:	83 f8 02             	cmp    $0x2,%eax
80102546:	74 23                	je     8010256b <iderw+0xab>
80102548:	90                   	nop
80102549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102550:	83 ec 08             	sub    $0x8,%esp
80102553:	68 80 a5 10 80       	push   $0x8010a580
80102558:	53                   	push   %ebx
80102559:	e8 a2 1c 00 00       	call   80104200 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010255e:	8b 03                	mov    (%ebx),%eax
80102560:	83 c4 10             	add    $0x10,%esp
80102563:	83 e0 06             	and    $0x6,%eax
80102566:	83 f8 02             	cmp    $0x2,%eax
80102569:	75 e5                	jne    80102550 <iderw+0x90>
  }


  release(&idelock);
8010256b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102575:	c9                   	leave  
  release(&idelock);
80102576:	e9 65 23 00 00       	jmp    801048e0 <release>
8010257b:	90                   	nop
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102580:	89 d8                	mov    %ebx,%eax
80102582:	e8 39 fd ff ff       	call   801022c0 <idestart>
80102587:	eb b5                	jmp    8010253e <iderw+0x7e>
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102590:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102595:	eb 9d                	jmp    80102534 <iderw+0x74>
    panic("iderw: nothing to do");
80102597:	83 ec 0c             	sub    $0xc,%esp
8010259a:	68 04 77 10 80       	push   $0x80107704
8010259f:	e8 ec dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025a4:	83 ec 0c             	sub    $0xc,%esp
801025a7:	68 ee 76 10 80       	push   $0x801076ee
801025ac:	e8 df dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025b1:	83 ec 0c             	sub    $0xc,%esp
801025b4:	68 19 77 10 80       	push   $0x80107719
801025b9:	e8 d2 dd ff ff       	call   80100390 <panic>
801025be:	66 90                	xchg   %ax,%ax

801025c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025c0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025c1:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801025c8:	00 c0 fe 
{
801025cb:	89 e5                	mov    %esp,%ebp
801025cd:	56                   	push   %esi
801025ce:	53                   	push   %ebx
  ioapic->reg = reg;
801025cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025d6:	00 00 00 
  return ioapic->data;
801025d9:	a1 54 26 11 80       	mov    0x80112654,%eax
801025de:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801025e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801025e7:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025ed:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025f4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801025f7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025fa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801025fd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102600:	39 c2                	cmp    %eax,%edx
80102602:	74 16                	je     8010261a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102604:	83 ec 0c             	sub    $0xc,%esp
80102607:	68 38 77 10 80       	push   $0x80107738
8010260c:	e8 4f e0 ff ff       	call   80100660 <cprintf>
80102611:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102617:	83 c4 10             	add    $0x10,%esp
8010261a:	83 c3 21             	add    $0x21,%ebx
{
8010261d:	ba 10 00 00 00       	mov    $0x10,%edx
80102622:	b8 20 00 00 00       	mov    $0x20,%eax
80102627:	89 f6                	mov    %esi,%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102630:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102632:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102638:	89 c6                	mov    %eax,%esi
8010263a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102640:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102643:	89 71 10             	mov    %esi,0x10(%ecx)
80102646:	8d 72 01             	lea    0x1(%edx),%esi
80102649:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010264c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010264e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102650:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102656:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010265d:	75 d1                	jne    80102630 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010265f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102662:	5b                   	pop    %ebx
80102663:	5e                   	pop    %esi
80102664:	5d                   	pop    %ebp
80102665:	c3                   	ret    
80102666:	8d 76 00             	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102670:	55                   	push   %ebp
  ioapic->reg = reg;
80102671:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
80102677:	89 e5                	mov    %esp,%ebp
80102679:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010267c:	8d 50 20             	lea    0x20(%eax),%edx
8010267f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102683:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102685:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010268b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010268e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102691:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102694:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102696:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010269b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010269e:	89 50 10             	mov    %edx,0x10(%eax)
}
801026a1:	5d                   	pop    %ebp
801026a2:	c3                   	ret    
801026a3:	66 90                	xchg   %ax,%ax
801026a5:	66 90                	xchg   %ax,%ax
801026a7:	66 90                	xchg   %ax,%ax
801026a9:	66 90                	xchg   %ax,%ax
801026ab:	66 90                	xchg   %ax,%ax
801026ad:	66 90                	xchg   %ax,%ax
801026af:	90                   	nop

801026b0 <kallocCount>:


//called once via userinit to count number of pages
int
kallocCount(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	56                   	push   %esi
801026b4:	53                   	push   %ebx
  struct run *r;
  int count = 0;
  cprintf("CHEKPOINT1\n");
801026b5:	83 ec 0c             	sub    $0xc,%esp
801026b8:	68 6a 77 10 80       	push   $0x8010776a
801026bd:	e8 9e df ff ff       	call   80100660 <cprintf>
  if(kmem.use_lock) //lock check
801026c2:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801026c8:	83 c4 10             	add    $0x10,%esp
801026cb:	85 d2                	test   %edx,%edx
801026cd:	75 61                	jne    80102730 <kallocCount+0x80>
    acquire(&kmem.lock);
  r = kmem.freelist;
  cprintf("CHEKPOINT2\n");
801026cf:	83 ec 0c             	sub    $0xc,%esp
  r = kmem.freelist;
801026d2:	8b 1d 98 26 11 80    	mov    0x80112698,%ebx
  int count = 0;
801026d8:	31 f6                	xor    %esi,%esi
  cprintf("CHEKPOINT2\n");
801026da:	68 76 77 10 80       	push   $0x80107776
801026df:	e8 7c df ff ff       	call   80100660 <cprintf>

  //count all the pages by iterating the freelist
  while(r){
801026e4:	83 c4 10             	add    $0x10,%esp
801026e7:	85 db                	test   %ebx,%ebx
801026e9:	74 0e                	je     801026f9 <kallocCount+0x49>
801026eb:	90                   	nop
801026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    count++;
    r = r->next;
801026f0:	8b 1b                	mov    (%ebx),%ebx
    count++;
801026f2:	83 c6 01             	add    $0x1,%esi
  while(r){
801026f5:	85 db                	test   %ebx,%ebx
801026f7:	75 f7                	jne    801026f0 <kallocCount+0x40>
  }
  cprintf("CHEKPOINT3\n");
801026f9:	83 ec 0c             	sub    $0xc,%esp
801026fc:	68 82 77 10 80       	push   $0x80107782
80102701:	e8 5a df ff ff       	call   80100660 <cprintf>
  if(kmem.use_lock)//lock check
80102706:	a1 94 26 11 80       	mov    0x80112694,%eax
8010270b:	83 c4 10             	add    $0x10,%esp
8010270e:	85 c0                	test   %eax,%eax
80102710:	74 10                	je     80102722 <kallocCount+0x72>
    release(&kmem.lock);
80102712:	83 ec 0c             	sub    $0xc,%esp
80102715:	68 60 26 11 80       	push   $0x80112660
8010271a:	e8 c1 21 00 00       	call   801048e0 <release>
8010271f:	83 c4 10             	add    $0x10,%esp
  return count;
}
80102722:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102725:	89 f0                	mov    %esi,%eax
80102727:	5b                   	pop    %ebx
80102728:	5e                   	pop    %esi
80102729:	5d                   	pop    %ebp
8010272a:	c3                   	ret    
8010272b:	90                   	nop
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102730:	83 ec 0c             	sub    $0xc,%esp
80102733:	68 60 26 11 80       	push   $0x80112660
80102738:	e8 83 20 00 00       	call   801047c0 <acquire>
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	eb 8d                	jmp    801026cf <kallocCount+0x1f>
80102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	53                   	push   %ebx
80102754:	83 ec 04             	sub    $0x4,%esp
80102757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010275a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102760:	75 70                	jne    801027d2 <kfree+0x82>
80102762:	81 fb ec 5c 12 80    	cmp    $0x80125cec,%ebx
80102768:	72 68                	jb     801027d2 <kfree+0x82>
8010276a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102770:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102775:	77 5b                	ja     801027d2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102777:	83 ec 04             	sub    $0x4,%esp
8010277a:	68 00 10 00 00       	push   $0x1000
8010277f:	6a 01                	push   $0x1
80102781:	53                   	push   %ebx
80102782:	e8 b9 21 00 00       	call   80104940 <memset>

  if(kmem.use_lock)
80102787:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010278d:	83 c4 10             	add    $0x10,%esp
80102790:	85 d2                	test   %edx,%edx
80102792:	75 2c                	jne    801027c0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102794:	a1 98 26 11 80       	mov    0x80112698,%eax
80102799:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010279b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
801027a0:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
801027a6:	85 c0                	test   %eax,%eax
801027a8:	75 06                	jne    801027b0 <kfree+0x60>
    release(&kmem.lock);
}
801027aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ad:	c9                   	leave  
801027ae:	c3                   	ret    
801027af:	90                   	nop
    release(&kmem.lock);
801027b0:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
801027b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ba:	c9                   	leave  
    release(&kmem.lock);
801027bb:	e9 20 21 00 00       	jmp    801048e0 <release>
    acquire(&kmem.lock);
801027c0:	83 ec 0c             	sub    $0xc,%esp
801027c3:	68 60 26 11 80       	push   $0x80112660
801027c8:	e8 f3 1f 00 00       	call   801047c0 <acquire>
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	eb c2                	jmp    80102794 <kfree+0x44>
    panic("kfree");
801027d2:	83 ec 0c             	sub    $0xc,%esp
801027d5:	68 8e 77 10 80       	push   $0x8010778e
801027da:	e8 b1 db ff ff       	call   80100390 <panic>
801027df:	90                   	nop

801027e0 <freerange>:
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	56                   	push   %esi
801027e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801027eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027fd:	39 de                	cmp    %ebx,%esi
801027ff:	72 23                	jb     80102824 <freerange+0x44>
80102801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102808:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010280e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102811:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102817:	50                   	push   %eax
80102818:	e8 33 ff ff ff       	call   80102750 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010281d:	83 c4 10             	add    $0x10,%esp
80102820:	39 f3                	cmp    %esi,%ebx
80102822:	76 e4                	jbe    80102808 <freerange+0x28>
}
80102824:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102827:	5b                   	pop    %ebx
80102828:	5e                   	pop    %esi
80102829:	5d                   	pop    %ebp
8010282a:	c3                   	ret    
8010282b:	90                   	nop
8010282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102830 <kinit1>:
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	56                   	push   %esi
80102834:	53                   	push   %ebx
80102835:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102838:	83 ec 08             	sub    $0x8,%esp
8010283b:	68 94 77 10 80       	push   $0x80107794
80102840:	68 60 26 11 80       	push   $0x80112660
80102845:	e8 86 1e 00 00       	call   801046d0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010284a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010284d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102850:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102857:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010285a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102860:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102866:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010286c:	39 de                	cmp    %ebx,%esi
8010286e:	72 1c                	jb     8010288c <kinit1+0x5c>
    kfree(p);
80102870:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102876:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102879:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010287f:	50                   	push   %eax
80102880:	e8 cb fe ff ff       	call   80102750 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102885:	83 c4 10             	add    $0x10,%esp
80102888:	39 de                	cmp    %ebx,%esi
8010288a:	73 e4                	jae    80102870 <kinit1+0x40>
}
8010288c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010288f:	5b                   	pop    %ebx
80102890:	5e                   	pop    %esi
80102891:	5d                   	pop    %ebp
80102892:	c3                   	ret    
80102893:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028a0 <kinit2>:
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	56                   	push   %esi
801028a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801028ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028bd:	39 de                	cmp    %ebx,%esi
801028bf:	72 23                	jb     801028e4 <kinit2+0x44>
801028c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801028c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028d7:	50                   	push   %eax
801028d8:	e8 73 fe ff ff       	call   80102750 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028dd:	83 c4 10             	add    $0x10,%esp
801028e0:	39 de                	cmp    %ebx,%esi
801028e2:	73 e4                	jae    801028c8 <kinit2+0x28>
  kmem.use_lock = 1;
801028e4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801028eb:	00 00 00 
}
801028ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f1:	5b                   	pop    %ebx
801028f2:	5e                   	pop    %esi
801028f3:	5d                   	pop    %ebp
801028f4:	c3                   	ret    
801028f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102900:	a1 94 26 11 80       	mov    0x80112694,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	75 1f                	jne    80102928 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102909:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
8010290e:	85 c0                	test   %eax,%eax
80102910:	74 0e                	je     80102920 <kalloc+0x20>
    kmem.freelist = r->next;
80102912:	8b 10                	mov    (%eax),%edx
80102914:	89 15 98 26 11 80    	mov    %edx,0x80112698
8010291a:	c3                   	ret    
8010291b:	90                   	nop
8010291c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102920:	f3 c3                	repz ret 
80102922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102928:	55                   	push   %ebp
80102929:	89 e5                	mov    %esp,%ebp
8010292b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010292e:	68 60 26 11 80       	push   $0x80112660
80102933:	e8 88 1e 00 00       	call   801047c0 <acquire>
  r = kmem.freelist;
80102938:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
8010293d:	83 c4 10             	add    $0x10,%esp
80102940:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102946:	85 c0                	test   %eax,%eax
80102948:	74 08                	je     80102952 <kalloc+0x52>
    kmem.freelist = r->next;
8010294a:	8b 08                	mov    (%eax),%ecx
8010294c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if(kmem.use_lock)
80102952:	85 d2                	test   %edx,%edx
80102954:	74 16                	je     8010296c <kalloc+0x6c>
    release(&kmem.lock);
80102956:	83 ec 0c             	sub    $0xc,%esp
80102959:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010295c:	68 60 26 11 80       	push   $0x80112660
80102961:	e8 7a 1f 00 00       	call   801048e0 <release>
  return (char*)r;
80102966:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102969:	83 c4 10             	add    $0x10,%esp
}
8010296c:	c9                   	leave  
8010296d:	c3                   	ret    
8010296e:	66 90                	xchg   %ax,%ax

80102970 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102970:	ba 64 00 00 00       	mov    $0x64,%edx
80102975:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102976:	a8 01                	test   $0x1,%al
80102978:	0f 84 c2 00 00 00    	je     80102a40 <kbdgetc+0xd0>
8010297e:	ba 60 00 00 00       	mov    $0x60,%edx
80102983:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102984:	0f b6 d0             	movzbl %al,%edx
80102987:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010298d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102993:	0f 84 7f 00 00 00    	je     80102a18 <kbdgetc+0xa8>
{
80102999:	55                   	push   %ebp
8010299a:	89 e5                	mov    %esp,%ebp
8010299c:	53                   	push   %ebx
8010299d:	89 cb                	mov    %ecx,%ebx
8010299f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801029a2:	84 c0                	test   %al,%al
801029a4:	78 4a                	js     801029f0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801029a6:	85 db                	test   %ebx,%ebx
801029a8:	74 09                	je     801029b3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029aa:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801029ad:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801029b0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801029b3:	0f b6 82 c0 78 10 80 	movzbl -0x7fef8740(%edx),%eax
801029ba:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801029bc:	0f b6 82 c0 77 10 80 	movzbl -0x7fef8840(%edx),%eax
801029c3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029c5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801029c7:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801029cd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801029d0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029d3:	8b 04 85 a0 77 10 80 	mov    -0x7fef8860(,%eax,4),%eax
801029da:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801029de:	74 31                	je     80102a11 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801029e0:	8d 50 9f             	lea    -0x61(%eax),%edx
801029e3:	83 fa 19             	cmp    $0x19,%edx
801029e6:	77 40                	ja     80102a28 <kbdgetc+0xb8>
      c += 'A' - 'a';
801029e8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029eb:	5b                   	pop    %ebx
801029ec:	5d                   	pop    %ebp
801029ed:	c3                   	ret    
801029ee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801029f0:	83 e0 7f             	and    $0x7f,%eax
801029f3:	85 db                	test   %ebx,%ebx
801029f5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801029f8:	0f b6 82 c0 78 10 80 	movzbl -0x7fef8740(%edx),%eax
801029ff:	83 c8 40             	or     $0x40,%eax
80102a02:	0f b6 c0             	movzbl %al,%eax
80102a05:	f7 d0                	not    %eax
80102a07:	21 c1                	and    %eax,%ecx
    return 0;
80102a09:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102a0b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102a11:	5b                   	pop    %ebx
80102a12:	5d                   	pop    %ebp
80102a13:	c3                   	ret    
80102a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102a18:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102a1b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a1d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102a23:	c3                   	ret    
80102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102a28:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a2b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102a2e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102a2f:	83 f9 1a             	cmp    $0x1a,%ecx
80102a32:	0f 42 c2             	cmovb  %edx,%eax
}
80102a35:	5d                   	pop    %ebp
80102a36:	c3                   	ret    
80102a37:	89 f6                	mov    %esi,%esi
80102a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a45:	c3                   	ret    
80102a46:	8d 76 00             	lea    0x0(%esi),%esi
80102a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a50 <kbdintr>:

void
kbdintr(void)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a56:	68 70 29 10 80       	push   $0x80102970
80102a5b:	e8 b0 dd ff ff       	call   80100810 <consoleintr>
}
80102a60:	83 c4 10             	add    $0x10,%esp
80102a63:	c9                   	leave  
80102a64:	c3                   	ret    
80102a65:	66 90                	xchg   %ax,%ax
80102a67:	66 90                	xchg   %ax,%ax
80102a69:	66 90                	xchg   %ax,%ax
80102a6b:	66 90                	xchg   %ax,%ax
80102a6d:	66 90                	xchg   %ax,%ax
80102a6f:	90                   	nop

80102a70 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a70:	a1 9c 26 11 80       	mov    0x8011269c,%eax
{
80102a75:	55                   	push   %ebp
80102a76:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a78:	85 c0                	test   %eax,%eax
80102a7a:	0f 84 c8 00 00 00    	je     80102b48 <lapicinit+0xd8>
  lapic[index] = value;
80102a80:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a87:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a8d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a94:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a97:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a9a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102aa1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aa7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102aae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ab4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102abb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102abe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ac1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ac8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102acb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ace:	8b 50 30             	mov    0x30(%eax),%edx
80102ad1:	c1 ea 10             	shr    $0x10,%edx
80102ad4:	80 fa 03             	cmp    $0x3,%dl
80102ad7:	77 77                	ja     80102b50 <lapicinit+0xe0>
  lapic[index] = value;
80102ad9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ae0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ae6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102aed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102af3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102afa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102afd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b00:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b07:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b0a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b0d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b14:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b17:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b1a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b21:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b24:	8b 50 20             	mov    0x20(%eax),%edx
80102b27:	89 f6                	mov    %esi,%esi
80102b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102b30:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102b36:	80 e6 10             	and    $0x10,%dh
80102b39:	75 f5                	jne    80102b30 <lapicinit+0xc0>
  lapic[index] = value;
80102b3b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b42:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b45:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b48:	5d                   	pop    %ebp
80102b49:	c3                   	ret    
80102b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102b50:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b57:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b5a:	8b 50 20             	mov    0x20(%eax),%edx
80102b5d:	e9 77 ff ff ff       	jmp    80102ad9 <lapicinit+0x69>
80102b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b70 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b70:	8b 15 9c 26 11 80    	mov    0x8011269c,%edx
{
80102b76:	55                   	push   %ebp
80102b77:	31 c0                	xor    %eax,%eax
80102b79:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b7b:	85 d2                	test   %edx,%edx
80102b7d:	74 06                	je     80102b85 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102b7f:	8b 42 20             	mov    0x20(%edx),%eax
80102b82:	c1 e8 18             	shr    $0x18,%eax
}
80102b85:	5d                   	pop    %ebp
80102b86:	c3                   	ret    
80102b87:	89 f6                	mov    %esi,%esi
80102b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b90 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b90:	a1 9c 26 11 80       	mov    0x8011269c,%eax
{
80102b95:	55                   	push   %ebp
80102b96:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b98:	85 c0                	test   %eax,%eax
80102b9a:	74 0d                	je     80102ba9 <lapiceoi+0x19>
  lapic[index] = value;
80102b9c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ba3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102ba9:	5d                   	pop    %ebp
80102baa:	c3                   	ret    
80102bab:	90                   	nop
80102bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102bb0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
}
80102bb3:	5d                   	pop    %ebp
80102bb4:	c3                   	ret    
80102bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102bc0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102bc6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bcb:	89 e5                	mov    %esp,%ebp
80102bcd:	53                   	push   %ebx
80102bce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102bd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102bd4:	ee                   	out    %al,(%dx)
80102bd5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bda:	ba 71 00 00 00       	mov    $0x71,%edx
80102bdf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102be0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102be2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102be5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102beb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bed:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102bf0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102bf3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bf5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102bf8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102bfe:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102c03:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c09:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c0c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c13:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c16:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c19:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c20:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c23:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c26:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c2c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c2f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c35:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c38:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c41:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c47:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102c4a:	5b                   	pop    %ebx
80102c4b:	5d                   	pop    %ebp
80102c4c:	c3                   	ret    
80102c4d:	8d 76 00             	lea    0x0(%esi),%esi

80102c50 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102c50:	55                   	push   %ebp
80102c51:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c56:	ba 70 00 00 00       	mov    $0x70,%edx
80102c5b:	89 e5                	mov    %esp,%ebp
80102c5d:	57                   	push   %edi
80102c5e:	56                   	push   %esi
80102c5f:	53                   	push   %ebx
80102c60:	83 ec 4c             	sub    $0x4c,%esp
80102c63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c64:	ba 71 00 00 00       	mov    $0x71,%edx
80102c69:	ec                   	in     (%dx),%al
80102c6a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c6d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c72:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c75:	8d 76 00             	lea    0x0(%esi),%esi
80102c78:	31 c0                	xor    %eax,%eax
80102c7a:	89 da                	mov    %ebx,%edx
80102c7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c82:	89 ca                	mov    %ecx,%edx
80102c84:	ec                   	in     (%dx),%al
80102c85:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c88:	89 da                	mov    %ebx,%edx
80102c8a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c90:	89 ca                	mov    %ecx,%edx
80102c92:	ec                   	in     (%dx),%al
80102c93:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c96:	89 da                	mov    %ebx,%edx
80102c98:	b8 04 00 00 00       	mov    $0x4,%eax
80102c9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9e:	89 ca                	mov    %ecx,%edx
80102ca0:	ec                   	in     (%dx),%al
80102ca1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca4:	89 da                	mov    %ebx,%edx
80102ca6:	b8 07 00 00 00       	mov    $0x7,%eax
80102cab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cac:	89 ca                	mov    %ecx,%edx
80102cae:	ec                   	in     (%dx),%al
80102caf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb2:	89 da                	mov    %ebx,%edx
80102cb4:	b8 08 00 00 00       	mov    $0x8,%eax
80102cb9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cba:	89 ca                	mov    %ecx,%edx
80102cbc:	ec                   	in     (%dx),%al
80102cbd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cbf:	89 da                	mov    %ebx,%edx
80102cc1:	b8 09 00 00 00       	mov    $0x9,%eax
80102cc6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc7:	89 ca                	mov    %ecx,%edx
80102cc9:	ec                   	in     (%dx),%al
80102cca:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ccc:	89 da                	mov    %ebx,%edx
80102cce:	b8 0a 00 00 00       	mov    $0xa,%eax
80102cd3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd4:	89 ca                	mov    %ecx,%edx
80102cd6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102cd7:	84 c0                	test   %al,%al
80102cd9:	78 9d                	js     80102c78 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102cdb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102cdf:	89 fa                	mov    %edi,%edx
80102ce1:	0f b6 fa             	movzbl %dl,%edi
80102ce4:	89 f2                	mov    %esi,%edx
80102ce6:	0f b6 f2             	movzbl %dl,%esi
80102ce9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cec:	89 da                	mov    %ebx,%edx
80102cee:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102cf1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102cf4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102cf8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102cfb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102cff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d02:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d06:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d09:	31 c0                	xor    %eax,%eax
80102d0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d0c:	89 ca                	mov    %ecx,%edx
80102d0e:	ec                   	in     (%dx),%al
80102d0f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d12:	89 da                	mov    %ebx,%edx
80102d14:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d17:	b8 02 00 00 00       	mov    $0x2,%eax
80102d1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d1d:	89 ca                	mov    %ecx,%edx
80102d1f:	ec                   	in     (%dx),%al
80102d20:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d23:	89 da                	mov    %ebx,%edx
80102d25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d28:	b8 04 00 00 00       	mov    $0x4,%eax
80102d2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2e:	89 ca                	mov    %ecx,%edx
80102d30:	ec                   	in     (%dx),%al
80102d31:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d34:	89 da                	mov    %ebx,%edx
80102d36:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d39:	b8 07 00 00 00       	mov    $0x7,%eax
80102d3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d3f:	89 ca                	mov    %ecx,%edx
80102d41:	ec                   	in     (%dx),%al
80102d42:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d45:	89 da                	mov    %ebx,%edx
80102d47:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d4a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d50:	89 ca                	mov    %ecx,%edx
80102d52:	ec                   	in     (%dx),%al
80102d53:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d56:	89 da                	mov    %ebx,%edx
80102d58:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d5b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d60:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d61:	89 ca                	mov    %ecx,%edx
80102d63:	ec                   	in     (%dx),%al
80102d64:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d67:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102d6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d6d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d70:	6a 18                	push   $0x18
80102d72:	50                   	push   %eax
80102d73:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d76:	50                   	push   %eax
80102d77:	e8 14 1c 00 00       	call   80104990 <memcmp>
80102d7c:	83 c4 10             	add    $0x10,%esp
80102d7f:	85 c0                	test   %eax,%eax
80102d81:	0f 85 f1 fe ff ff    	jne    80102c78 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d87:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d8b:	75 78                	jne    80102e05 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d90:	89 c2                	mov    %eax,%edx
80102d92:	83 e0 0f             	and    $0xf,%eax
80102d95:	c1 ea 04             	shr    $0x4,%edx
80102d98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d9e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102da1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102da4:	89 c2                	mov    %eax,%edx
80102da6:	83 e0 0f             	and    $0xf,%eax
80102da9:	c1 ea 04             	shr    $0x4,%edx
80102dac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102daf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102db2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102db5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102db8:	89 c2                	mov    %eax,%edx
80102dba:	83 e0 0f             	and    $0xf,%eax
80102dbd:	c1 ea 04             	shr    $0x4,%edx
80102dc0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dc3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dc6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102dc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dcc:	89 c2                	mov    %eax,%edx
80102dce:	83 e0 0f             	and    $0xf,%eax
80102dd1:	c1 ea 04             	shr    $0x4,%edx
80102dd4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dd7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dda:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ddd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102de0:	89 c2                	mov    %eax,%edx
80102de2:	83 e0 0f             	and    $0xf,%eax
80102de5:	c1 ea 04             	shr    $0x4,%edx
80102de8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102deb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dee:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102df1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102df4:	89 c2                	mov    %eax,%edx
80102df6:	83 e0 0f             	and    $0xf,%eax
80102df9:	c1 ea 04             	shr    $0x4,%edx
80102dfc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e02:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e05:	8b 75 08             	mov    0x8(%ebp),%esi
80102e08:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e0b:	89 06                	mov    %eax,(%esi)
80102e0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e10:	89 46 04             	mov    %eax,0x4(%esi)
80102e13:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e16:	89 46 08             	mov    %eax,0x8(%esi)
80102e19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e1c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e22:	89 46 10             	mov    %eax,0x10(%esi)
80102e25:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e28:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102e2b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e35:	5b                   	pop    %ebx
80102e36:	5e                   	pop    %esi
80102e37:	5f                   	pop    %edi
80102e38:	5d                   	pop    %ebp
80102e39:	c3                   	ret    
80102e3a:	66 90                	xchg   %ax,%ax
80102e3c:	66 90                	xchg   %ax,%ax
80102e3e:	66 90                	xchg   %ax,%ax

80102e40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e40:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e46:	85 c9                	test   %ecx,%ecx
80102e48:	0f 8e 8a 00 00 00    	jle    80102ed8 <install_trans+0x98>
{
80102e4e:	55                   	push   %ebp
80102e4f:	89 e5                	mov    %esp,%ebp
80102e51:	57                   	push   %edi
80102e52:	56                   	push   %esi
80102e53:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102e54:	31 db                	xor    %ebx,%ebx
{
80102e56:	83 ec 0c             	sub    $0xc,%esp
80102e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e60:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e65:	83 ec 08             	sub    $0x8,%esp
80102e68:	01 d8                	add    %ebx,%eax
80102e6a:	83 c0 01             	add    $0x1,%eax
80102e6d:	50                   	push   %eax
80102e6e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102e74:	e8 57 d2 ff ff       	call   801000d0 <bread>
80102e79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e7b:	58                   	pop    %eax
80102e7c:	5a                   	pop    %edx
80102e7d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102e84:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e8d:	e8 3e d2 ff ff       	call   801000d0 <bread>
80102e92:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102e97:	83 c4 0c             	add    $0xc,%esp
80102e9a:	68 00 02 00 00       	push   $0x200
80102e9f:	50                   	push   %eax
80102ea0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ea3:	50                   	push   %eax
80102ea4:	e8 47 1b 00 00       	call   801049f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 ef d2 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102eb1:	89 3c 24             	mov    %edi,(%esp)
80102eb4:	e8 27 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 1f d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ec1:	83 c4 10             	add    $0x10,%esp
80102ec4:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102eca:	7f 94                	jg     80102e60 <install_trans+0x20>
  }
}
80102ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ecf:	5b                   	pop    %ebx
80102ed0:	5e                   	pop    %esi
80102ed1:	5f                   	pop    %edi
80102ed2:	5d                   	pop    %ebp
80102ed3:	c3                   	ret    
80102ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ed8:	f3 c3                	repz ret 
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ee0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	56                   	push   %esi
80102ee4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ee5:	83 ec 08             	sub    $0x8,%esp
80102ee8:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102eee:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102ef4:	e8 d7 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ef9:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102eff:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f02:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102f04:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102f06:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102f09:	7e 16                	jle    80102f21 <write_head+0x41>
80102f0b:	c1 e3 02             	shl    $0x2,%ebx
80102f0e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102f10:	8b 8a ec 26 11 80    	mov    -0x7feed914(%edx),%ecx
80102f16:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102f1a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102f1d:	39 da                	cmp    %ebx,%edx
80102f1f:	75 ef                	jne    80102f10 <write_head+0x30>
  }
  bwrite(buf);
80102f21:	83 ec 0c             	sub    $0xc,%esp
80102f24:	56                   	push   %esi
80102f25:	e8 76 d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102f2a:	89 34 24             	mov    %esi,(%esp)
80102f2d:	e8 ae d2 ff ff       	call   801001e0 <brelse>
}
80102f32:	83 c4 10             	add    $0x10,%esp
80102f35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f38:	5b                   	pop    %ebx
80102f39:	5e                   	pop    %esi
80102f3a:	5d                   	pop    %ebp
80102f3b:	c3                   	ret    
80102f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f40 <initlog>:
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 2c             	sub    $0x2c,%esp
80102f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102f4a:	68 c0 79 10 80       	push   $0x801079c0
80102f4f:	68 a0 26 11 80       	push   $0x801126a0
80102f54:	e8 77 17 00 00       	call   801046d0 <initlock>
  readsb(dev, &sb);
80102f59:	58                   	pop    %eax
80102f5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f5d:	5a                   	pop    %edx
80102f5e:	50                   	push   %eax
80102f5f:	53                   	push   %ebx
80102f60:	e8 6b e4 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102f65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f6b:	59                   	pop    %ecx
  log.dev = dev;
80102f6c:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102f72:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  log.start = sb.logstart;
80102f78:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  struct buf *buf = bread(log.dev, log.start);
80102f7d:	5a                   	pop    %edx
80102f7e:	50                   	push   %eax
80102f7f:	53                   	push   %ebx
80102f80:	e8 4b d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102f85:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f88:	83 c4 10             	add    $0x10,%esp
80102f8b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102f8d:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102f93:	7e 1c                	jle    80102fb1 <initlog+0x71>
80102f95:	c1 e3 02             	shl    $0x2,%ebx
80102f98:	31 d2                	xor    %edx,%edx
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102fa0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102fa4:	83 c2 04             	add    $0x4,%edx
80102fa7:	89 8a e8 26 11 80    	mov    %ecx,-0x7feed918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102fad:	39 d3                	cmp    %edx,%ebx
80102faf:	75 ef                	jne    80102fa0 <initlog+0x60>
  brelse(buf);
80102fb1:	83 ec 0c             	sub    $0xc,%esp
80102fb4:	50                   	push   %eax
80102fb5:	e8 26 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102fba:	e8 81 fe ff ff       	call   80102e40 <install_trans>
  log.lh.n = 0;
80102fbf:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102fc6:	00 00 00 
  write_head(); // clear the log
80102fc9:	e8 12 ff ff ff       	call   80102ee0 <write_head>
}
80102fce:	83 c4 10             	add    $0x10,%esp
80102fd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fd4:	c9                   	leave  
80102fd5:	c3                   	ret    
80102fd6:	8d 76 00             	lea    0x0(%esi),%esi
80102fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fe0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102fe6:	68 a0 26 11 80       	push   $0x801126a0
80102feb:	e8 d0 17 00 00       	call   801047c0 <acquire>
80102ff0:	83 c4 10             	add    $0x10,%esp
80102ff3:	eb 18                	jmp    8010300d <begin_op+0x2d>
80102ff5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ff8:	83 ec 08             	sub    $0x8,%esp
80102ffb:	68 a0 26 11 80       	push   $0x801126a0
80103000:	68 a0 26 11 80       	push   $0x801126a0
80103005:	e8 f6 11 00 00       	call   80104200 <sleep>
8010300a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010300d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80103012:	85 c0                	test   %eax,%eax
80103014:	75 e2                	jne    80102ff8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103016:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010301b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103021:	83 c0 01             	add    $0x1,%eax
80103024:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103027:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010302a:	83 fa 1e             	cmp    $0x1e,%edx
8010302d:	7f c9                	jg     80102ff8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010302f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103032:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80103037:	68 a0 26 11 80       	push   $0x801126a0
8010303c:	e8 9f 18 00 00       	call   801048e0 <release>
      break;
    }
  }
}
80103041:	83 c4 10             	add    $0x10,%esp
80103044:	c9                   	leave  
80103045:	c3                   	ret    
80103046:	8d 76 00             	lea    0x0(%esi),%esi
80103049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103050 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103059:	68 a0 26 11 80       	push   $0x801126a0
8010305e:	e8 5d 17 00 00       	call   801047c0 <acquire>
  log.outstanding -= 1;
80103063:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80103068:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
8010306e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103071:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103074:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103076:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
8010307c:	0f 85 1a 01 00 00    	jne    8010319c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103082:	85 db                	test   %ebx,%ebx
80103084:	0f 85 ee 00 00 00    	jne    80103178 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010308a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010308d:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80103094:	00 00 00 
  release(&log.lock);
80103097:	68 a0 26 11 80       	push   $0x801126a0
8010309c:	e8 3f 18 00 00       	call   801048e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801030a1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
801030a7:	83 c4 10             	add    $0x10,%esp
801030aa:	85 c9                	test   %ecx,%ecx
801030ac:	0f 8e 85 00 00 00    	jle    80103137 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801030b2:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801030b7:	83 ec 08             	sub    $0x8,%esp
801030ba:	01 d8                	add    %ebx,%eax
801030bc:	83 c0 01             	add    $0x1,%eax
801030bf:	50                   	push   %eax
801030c0:	ff 35 e4 26 11 80    	pushl  0x801126e4
801030c6:	e8 05 d0 ff ff       	call   801000d0 <bread>
801030cb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030cd:	58                   	pop    %eax
801030ce:	5a                   	pop    %edx
801030cf:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
801030d6:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
801030dc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030df:	e8 ec cf ff ff       	call   801000d0 <bread>
801030e4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030e6:	8d 40 5c             	lea    0x5c(%eax),%eax
801030e9:	83 c4 0c             	add    $0xc,%esp
801030ec:	68 00 02 00 00       	push   $0x200
801030f1:	50                   	push   %eax
801030f2:	8d 46 5c             	lea    0x5c(%esi),%eax
801030f5:	50                   	push   %eax
801030f6:	e8 f5 18 00 00       	call   801049f0 <memmove>
    bwrite(to);  // write the log
801030fb:	89 34 24             	mov    %esi,(%esp)
801030fe:	e8 9d d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103103:	89 3c 24             	mov    %edi,(%esp)
80103106:	e8 d5 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010310b:	89 34 24             	mov    %esi,(%esp)
8010310e:	e8 cd d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103113:	83 c4 10             	add    $0x10,%esp
80103116:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
8010311c:	7c 94                	jl     801030b2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010311e:	e8 bd fd ff ff       	call   80102ee0 <write_head>
    install_trans(); // Now install writes to home locations
80103123:	e8 18 fd ff ff       	call   80102e40 <install_trans>
    log.lh.n = 0;
80103128:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
8010312f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103132:	e8 a9 fd ff ff       	call   80102ee0 <write_head>
    acquire(&log.lock);
80103137:	83 ec 0c             	sub    $0xc,%esp
8010313a:	68 a0 26 11 80       	push   $0x801126a0
8010313f:	e8 7c 16 00 00       	call   801047c0 <acquire>
    wakeup(&log);
80103144:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
8010314b:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80103152:	00 00 00 
    wakeup(&log);
80103155:	e8 66 12 00 00       	call   801043c0 <wakeup>
    release(&log.lock);
8010315a:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103161:	e8 7a 17 00 00       	call   801048e0 <release>
80103166:	83 c4 10             	add    $0x10,%esp
}
80103169:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010316c:	5b                   	pop    %ebx
8010316d:	5e                   	pop    %esi
8010316e:	5f                   	pop    %edi
8010316f:	5d                   	pop    %ebp
80103170:	c3                   	ret    
80103171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103178:	83 ec 0c             	sub    $0xc,%esp
8010317b:	68 a0 26 11 80       	push   $0x801126a0
80103180:	e8 3b 12 00 00       	call   801043c0 <wakeup>
  release(&log.lock);
80103185:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
8010318c:	e8 4f 17 00 00       	call   801048e0 <release>
80103191:	83 c4 10             	add    $0x10,%esp
}
80103194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103197:	5b                   	pop    %ebx
80103198:	5e                   	pop    %esi
80103199:	5f                   	pop    %edi
8010319a:	5d                   	pop    %ebp
8010319b:	c3                   	ret    
    panic("log.committing");
8010319c:	83 ec 0c             	sub    $0xc,%esp
8010319f:	68 c4 79 10 80       	push   $0x801079c4
801031a4:	e8 e7 d1 ff ff       	call   80100390 <panic>
801031a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	53                   	push   %ebx
801031b4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031b7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
801031bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031c0:	83 fa 1d             	cmp    $0x1d,%edx
801031c3:	0f 8f 9d 00 00 00    	jg     80103266 <log_write+0xb6>
801031c9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
801031ce:	83 e8 01             	sub    $0x1,%eax
801031d1:	39 c2                	cmp    %eax,%edx
801031d3:	0f 8d 8d 00 00 00    	jge    80103266 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801031d9:	a1 dc 26 11 80       	mov    0x801126dc,%eax
801031de:	85 c0                	test   %eax,%eax
801031e0:	0f 8e 8d 00 00 00    	jle    80103273 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801031e6:	83 ec 0c             	sub    $0xc,%esp
801031e9:	68 a0 26 11 80       	push   $0x801126a0
801031ee:	e8 cd 15 00 00       	call   801047c0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801031f3:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
801031f9:	83 c4 10             	add    $0x10,%esp
801031fc:	83 f9 00             	cmp    $0x0,%ecx
801031ff:	7e 57                	jle    80103258 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103201:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103204:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103206:	3b 15 ec 26 11 80    	cmp    0x801126ec,%edx
8010320c:	75 0b                	jne    80103219 <log_write+0x69>
8010320e:	eb 38                	jmp    80103248 <log_write+0x98>
80103210:	39 14 85 ec 26 11 80 	cmp    %edx,-0x7feed914(,%eax,4)
80103217:	74 2f                	je     80103248 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103219:	83 c0 01             	add    $0x1,%eax
8010321c:	39 c1                	cmp    %eax,%ecx
8010321e:	75 f0                	jne    80103210 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103220:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103227:	83 c0 01             	add    $0x1,%eax
8010322a:	a3 e8 26 11 80       	mov    %eax,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
8010322f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103232:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103239:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010323c:	c9                   	leave  
  release(&log.lock);
8010323d:	e9 9e 16 00 00       	jmp    801048e0 <release>
80103242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103248:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
8010324f:	eb de                	jmp    8010322f <log_write+0x7f>
80103251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103258:	8b 43 08             	mov    0x8(%ebx),%eax
8010325b:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80103260:	75 cd                	jne    8010322f <log_write+0x7f>
80103262:	31 c0                	xor    %eax,%eax
80103264:	eb c1                	jmp    80103227 <log_write+0x77>
    panic("too big a transaction");
80103266:	83 ec 0c             	sub    $0xc,%esp
80103269:	68 d3 79 10 80       	push   $0x801079d3
8010326e:	e8 1d d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103273:	83 ec 0c             	sub    $0xc,%esp
80103276:	68 e9 79 10 80       	push   $0x801079e9
8010327b:	e8 10 d1 ff ff       	call   80100390 <panic>

80103280 <mpmain>:
  mpmain();
}

// Common CPU setup code.
static void
mpmain(void) {
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	53                   	push   %ebx
80103284:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103287:	e8 94 09 00 00       	call   80103c20 <cpuid>
8010328c:	89 c3                	mov    %eax,%ebx
8010328e:	e8 8d 09 00 00       	call   80103c20 <cpuid>
80103293:	83 ec 04             	sub    $0x4,%esp
80103296:	53                   	push   %ebx
80103297:	50                   	push   %eax
80103298:	68 04 7a 10 80       	push   $0x80107a04
8010329d:	e8 be d3 ff ff       	call   80100660 <cprintf>
    idtinit();       // load idt register
801032a2:	e8 69 29 00 00       	call   80105c10 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
801032a7:	e8 f4 08 00 00       	call   80103ba0 <mycpu>
801032ac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801032ae:	b8 01 00 00 00       	mov    $0x1,%eax
801032b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
801032ba:	e8 61 0c 00 00       	call   80103f20 <scheduler>
801032bf:	90                   	nop

801032c0 <mpenter>:
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801032c6:	e8 75 3a 00 00       	call   80106d40 <switchkvm>
  seginit();
801032cb:	e8 a0 39 00 00       	call   80106c70 <seginit>
  lapicinit();
801032d0:	e8 9b f7 ff ff       	call   80102a70 <lapicinit>
  mpmain();
801032d5:	e8 a6 ff ff ff       	call   80103280 <mpmain>
801032da:	66 90                	xchg   %ax,%ax
801032dc:	66 90                	xchg   %ax,%ax
801032de:	66 90                	xchg   %ax,%ax

801032e0 <main>:
{
801032e0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801032e4:	83 e4 f0             	and    $0xfffffff0,%esp
801032e7:	ff 71 fc             	pushl  -0x4(%ecx)
801032ea:	55                   	push   %ebp
801032eb:	89 e5                	mov    %esp,%ebp
801032ed:	53                   	push   %ebx
801032ee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801032ef:	83 ec 08             	sub    $0x8,%esp
801032f2:	68 00 00 40 80       	push   $0x80400000
801032f7:	68 ec 5c 12 80       	push   $0x80125cec
801032fc:	e8 2f f5 ff ff       	call   80102830 <kinit1>
  kvmalloc();      // kernel page table
80103301:	e8 aa 3f 00 00       	call   801072b0 <kvmalloc>
  mpinit();        // detect other processors
80103306:	e8 75 01 00 00       	call   80103480 <mpinit>
  lapicinit();     // interrupt controller
8010330b:	e8 60 f7 ff ff       	call   80102a70 <lapicinit>
  seginit();       // segment descriptors
80103310:	e8 5b 39 00 00       	call   80106c70 <seginit>
  picinit();       // disable pic
80103315:	e8 46 03 00 00       	call   80103660 <picinit>
  ioapicinit();    // another interrupt controller
8010331a:	e8 a1 f2 ff ff       	call   801025c0 <ioapicinit>
  consoleinit();   // console hardware
8010331f:	e8 9c d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103324:	e8 17 2c 00 00       	call   80105f40 <uartinit>
  pinit();         // process table
80103329:	e8 52 08 00 00       	call   80103b80 <pinit>
  tvinit();        // trap vectors
8010332e:	e8 5d 28 00 00       	call   80105b90 <tvinit>
  binit();         // buffer cache
80103333:	e8 08 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103338:	e8 23 da ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
8010333d:	e8 5e f0 ff ff       	call   801023a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103342:	83 c4 0c             	add    $0xc,%esp
80103345:	68 8a 00 00 00       	push   $0x8a
8010334a:	68 8c a4 10 80       	push   $0x8010a48c
8010334f:	68 00 70 00 80       	push   $0x80007000
80103354:	e8 97 16 00 00       	call   801049f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103359:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80103360:	00 00 00 
80103363:	83 c4 10             	add    $0x10,%esp
80103366:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010336b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103370:	76 71                	jbe    801033e3 <main+0x103>
80103372:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103377:	89 f6                	mov    %esi,%esi
80103379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103380:	e8 1b 08 00 00       	call   80103ba0 <mycpu>
80103385:	39 d8                	cmp    %ebx,%eax
80103387:	74 41                	je     801033ca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103389:	e8 72 f5 ff ff       	call   80102900 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010338e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103393:	c7 05 f8 6f 00 80 c0 	movl   $0x801032c0,0x80006ff8
8010339a:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010339d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801033a4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801033a7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801033ac:	0f b6 03             	movzbl (%ebx),%eax
801033af:	83 ec 08             	sub    $0x8,%esp
801033b2:	68 00 70 00 00       	push   $0x7000
801033b7:	50                   	push   %eax
801033b8:	e8 03 f8 ff ff       	call   80102bc0 <lapicstartap>
801033bd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801033c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801033c6:	85 c0                	test   %eax,%eax
801033c8:	74 f6                	je     801033c0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801033ca:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
801033d1:	00 00 00 
801033d4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801033da:	05 a0 27 11 80       	add    $0x801127a0,%eax
801033df:	39 c3                	cmp    %eax,%ebx
801033e1:	72 9d                	jb     80103380 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033e3:	83 ec 08             	sub    $0x8,%esp
801033e6:	68 00 00 00 8e       	push   $0x8e000000
801033eb:	68 00 00 40 80       	push   $0x80400000
801033f0:	e8 ab f4 ff ff       	call   801028a0 <kinit2>
  userinit();      // first user process
801033f5:	e8 76 08 00 00       	call   80103c70 <userinit>
  mpmain();        // finish this processor's setup
801033fa:	e8 81 fe ff ff       	call   80103280 <mpmain>
801033ff:	90                   	nop

80103400 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103405:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010340b:	53                   	push   %ebx
  e = addr+len;
8010340c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010340f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103412:	39 de                	cmp    %ebx,%esi
80103414:	72 10                	jb     80103426 <mpsearch1+0x26>
80103416:	eb 50                	jmp    80103468 <mpsearch1+0x68>
80103418:	90                   	nop
80103419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103420:	39 fb                	cmp    %edi,%ebx
80103422:	89 fe                	mov    %edi,%esi
80103424:	76 42                	jbe    80103468 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103426:	83 ec 04             	sub    $0x4,%esp
80103429:	8d 7e 10             	lea    0x10(%esi),%edi
8010342c:	6a 04                	push   $0x4
8010342e:	68 18 7a 10 80       	push   $0x80107a18
80103433:	56                   	push   %esi
80103434:	e8 57 15 00 00       	call   80104990 <memcmp>
80103439:	83 c4 10             	add    $0x10,%esp
8010343c:	85 c0                	test   %eax,%eax
8010343e:	75 e0                	jne    80103420 <mpsearch1+0x20>
80103440:	89 f1                	mov    %esi,%ecx
80103442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103448:	0f b6 11             	movzbl (%ecx),%edx
8010344b:	83 c1 01             	add    $0x1,%ecx
8010344e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103450:	39 f9                	cmp    %edi,%ecx
80103452:	75 f4                	jne    80103448 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103454:	84 c0                	test   %al,%al
80103456:	75 c8                	jne    80103420 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103458:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010345b:	89 f0                	mov    %esi,%eax
8010345d:	5b                   	pop    %ebx
8010345e:	5e                   	pop    %esi
8010345f:	5f                   	pop    %edi
80103460:	5d                   	pop    %ebp
80103461:	c3                   	ret    
80103462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103468:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010346b:	31 f6                	xor    %esi,%esi
}
8010346d:	89 f0                	mov    %esi,%eax
8010346f:	5b                   	pop    %ebx
80103470:	5e                   	pop    %esi
80103471:	5f                   	pop    %edi
80103472:	5d                   	pop    %ebp
80103473:	c3                   	ret    
80103474:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010347a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103480 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103489:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103490:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103497:	c1 e0 08             	shl    $0x8,%eax
8010349a:	09 d0                	or     %edx,%eax
8010349c:	c1 e0 04             	shl    $0x4,%eax
8010349f:	85 c0                	test   %eax,%eax
801034a1:	75 1b                	jne    801034be <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801034a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801034aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801034b1:	c1 e0 08             	shl    $0x8,%eax
801034b4:	09 d0                	or     %edx,%eax
801034b6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801034b9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801034be:	ba 00 04 00 00       	mov    $0x400,%edx
801034c3:	e8 38 ff ff ff       	call   80103400 <mpsearch1>
801034c8:	85 c0                	test   %eax,%eax
801034ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034cd:	0f 84 3d 01 00 00    	je     80103610 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034d6:	8b 58 04             	mov    0x4(%eax),%ebx
801034d9:	85 db                	test   %ebx,%ebx
801034db:	0f 84 4f 01 00 00    	je     80103630 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801034e7:	83 ec 04             	sub    $0x4,%esp
801034ea:	6a 04                	push   $0x4
801034ec:	68 35 7a 10 80       	push   $0x80107a35
801034f1:	56                   	push   %esi
801034f2:	e8 99 14 00 00       	call   80104990 <memcmp>
801034f7:	83 c4 10             	add    $0x10,%esp
801034fa:	85 c0                	test   %eax,%eax
801034fc:	0f 85 2e 01 00 00    	jne    80103630 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103502:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103509:	3c 01                	cmp    $0x1,%al
8010350b:	0f 95 c2             	setne  %dl
8010350e:	3c 04                	cmp    $0x4,%al
80103510:	0f 95 c0             	setne  %al
80103513:	20 c2                	and    %al,%dl
80103515:	0f 85 15 01 00 00    	jne    80103630 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010351b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103522:	66 85 ff             	test   %di,%di
80103525:	74 1a                	je     80103541 <mpinit+0xc1>
80103527:	89 f0                	mov    %esi,%eax
80103529:	01 f7                	add    %esi,%edi
  sum = 0;
8010352b:	31 d2                	xor    %edx,%edx
8010352d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103530:	0f b6 08             	movzbl (%eax),%ecx
80103533:	83 c0 01             	add    $0x1,%eax
80103536:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103538:	39 c7                	cmp    %eax,%edi
8010353a:	75 f4                	jne    80103530 <mpinit+0xb0>
8010353c:	84 d2                	test   %dl,%dl
8010353e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103541:	85 f6                	test   %esi,%esi
80103543:	0f 84 e7 00 00 00    	je     80103630 <mpinit+0x1b0>
80103549:	84 d2                	test   %dl,%dl
8010354b:	0f 85 df 00 00 00    	jne    80103630 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103551:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103557:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010355c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103563:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103569:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010356e:	01 d6                	add    %edx,%esi
80103570:	39 c6                	cmp    %eax,%esi
80103572:	76 23                	jbe    80103597 <mpinit+0x117>
    switch(*p){
80103574:	0f b6 10             	movzbl (%eax),%edx
80103577:	80 fa 04             	cmp    $0x4,%dl
8010357a:	0f 87 ca 00 00 00    	ja     8010364a <mpinit+0x1ca>
80103580:	ff 24 95 5c 7a 10 80 	jmp    *-0x7fef85a4(,%edx,4)
80103587:	89 f6                	mov    %esi,%esi
80103589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103590:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103593:	39 c6                	cmp    %eax,%esi
80103595:	77 dd                	ja     80103574 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103597:	85 db                	test   %ebx,%ebx
80103599:	0f 84 9e 00 00 00    	je     8010363d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010359f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801035a6:	74 15                	je     801035bd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035a8:	b8 70 00 00 00       	mov    $0x70,%eax
801035ad:	ba 22 00 00 00       	mov    $0x22,%edx
801035b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035b3:	ba 23 00 00 00       	mov    $0x23,%edx
801035b8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801035b9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035bc:	ee                   	out    %al,(%dx)
  }
}
801035bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035c0:	5b                   	pop    %ebx
801035c1:	5e                   	pop    %esi
801035c2:	5f                   	pop    %edi
801035c3:	5d                   	pop    %ebp
801035c4:	c3                   	ret    
801035c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801035c8:	8b 0d 20 2d 11 80    	mov    0x80112d20,%ecx
801035ce:	83 f9 07             	cmp    $0x7,%ecx
801035d1:	7f 19                	jg     801035ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801035d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801035dd:	83 c1 01             	add    $0x1,%ecx
801035e0:	89 0d 20 2d 11 80    	mov    %ecx,0x80112d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035e6:	88 97 a0 27 11 80    	mov    %dl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801035ec:	83 c0 14             	add    $0x14,%eax
      continue;
801035ef:	e9 7c ff ff ff       	jmp    80103570 <mpinit+0xf0>
801035f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801035f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801035fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801035ff:	88 15 80 27 11 80    	mov    %dl,0x80112780
      continue;
80103605:	e9 66 ff ff ff       	jmp    80103570 <mpinit+0xf0>
8010360a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103610:	ba 00 00 01 00       	mov    $0x10000,%edx
80103615:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010361a:	e8 e1 fd ff ff       	call   80103400 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010361f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103624:	0f 85 a9 fe ff ff    	jne    801034d3 <mpinit+0x53>
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	68 1d 7a 10 80       	push   $0x80107a1d
80103638:	e8 53 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010363d:	83 ec 0c             	sub    $0xc,%esp
80103640:	68 3c 7a 10 80       	push   $0x80107a3c
80103645:	e8 46 cd ff ff       	call   80100390 <panic>
      ismp = 0;
8010364a:	31 db                	xor    %ebx,%ebx
8010364c:	e9 26 ff ff ff       	jmp    80103577 <mpinit+0xf7>
80103651:	66 90                	xchg   %ax,%ax
80103653:	66 90                	xchg   %ax,%ax
80103655:	66 90                	xchg   %ax,%ax
80103657:	66 90                	xchg   %ax,%ax
80103659:	66 90                	xchg   %ax,%ax
8010365b:	66 90                	xchg   %ax,%ax
8010365d:	66 90                	xchg   %ax,%ax
8010365f:	90                   	nop

80103660 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103660:	55                   	push   %ebp
80103661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103666:	ba 21 00 00 00       	mov    $0x21,%edx
8010366b:	89 e5                	mov    %esp,%ebp
8010366d:	ee                   	out    %al,(%dx)
8010366e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103673:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103674:	5d                   	pop    %ebp
80103675:	c3                   	ret    
80103676:	66 90                	xchg   %ax,%ax
80103678:	66 90                	xchg   %ax,%ax
8010367a:	66 90                	xchg   %ax,%ax
8010367c:	66 90                	xchg   %ax,%ax
8010367e:	66 90                	xchg   %ax,%ax

80103680 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	57                   	push   %edi
80103684:	56                   	push   %esi
80103685:	53                   	push   %ebx
80103686:	83 ec 0c             	sub    $0xc,%esp
80103689:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010368c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010368f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103695:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010369b:	e8 e0 d6 ff ff       	call   80100d80 <filealloc>
801036a0:	85 c0                	test   %eax,%eax
801036a2:	89 03                	mov    %eax,(%ebx)
801036a4:	74 22                	je     801036c8 <pipealloc+0x48>
801036a6:	e8 d5 d6 ff ff       	call   80100d80 <filealloc>
801036ab:	85 c0                	test   %eax,%eax
801036ad:	89 06                	mov    %eax,(%esi)
801036af:	74 3f                	je     801036f0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801036b1:	e8 4a f2 ff ff       	call   80102900 <kalloc>
801036b6:	85 c0                	test   %eax,%eax
801036b8:	89 c7                	mov    %eax,%edi
801036ba:	75 54                	jne    80103710 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036bc:	8b 03                	mov    (%ebx),%eax
801036be:	85 c0                	test   %eax,%eax
801036c0:	75 34                	jne    801036f6 <pipealloc+0x76>
801036c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801036c8:	8b 06                	mov    (%esi),%eax
801036ca:	85 c0                	test   %eax,%eax
801036cc:	74 0c                	je     801036da <pipealloc+0x5a>
    fileclose(*f1);
801036ce:	83 ec 0c             	sub    $0xc,%esp
801036d1:	50                   	push   %eax
801036d2:	e8 69 d7 ff ff       	call   80100e40 <fileclose>
801036d7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801036da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036e2:	5b                   	pop    %ebx
801036e3:	5e                   	pop    %esi
801036e4:	5f                   	pop    %edi
801036e5:	5d                   	pop    %ebp
801036e6:	c3                   	ret    
801036e7:	89 f6                	mov    %esi,%esi
801036e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801036f0:	8b 03                	mov    (%ebx),%eax
801036f2:	85 c0                	test   %eax,%eax
801036f4:	74 e4                	je     801036da <pipealloc+0x5a>
    fileclose(*f0);
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	50                   	push   %eax
801036fa:	e8 41 d7 ff ff       	call   80100e40 <fileclose>
  if(*f1)
801036ff:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103701:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103704:	85 c0                	test   %eax,%eax
80103706:	75 c6                	jne    801036ce <pipealloc+0x4e>
80103708:	eb d0                	jmp    801036da <pipealloc+0x5a>
8010370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103710:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103713:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010371a:	00 00 00 
  p->writeopen = 1;
8010371d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103724:	00 00 00 
  p->nwrite = 0;
80103727:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010372e:	00 00 00 
  p->nread = 0;
80103731:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103738:	00 00 00 
  initlock(&p->lock, "pipe");
8010373b:	68 70 7a 10 80       	push   $0x80107a70
80103740:	50                   	push   %eax
80103741:	e8 8a 0f 00 00       	call   801046d0 <initlock>
  (*f0)->type = FD_PIPE;
80103746:	8b 03                	mov    (%ebx),%eax
  return 0;
80103748:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010374b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103751:	8b 03                	mov    (%ebx),%eax
80103753:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103757:	8b 03                	mov    (%ebx),%eax
80103759:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010375d:	8b 03                	mov    (%ebx),%eax
8010375f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103762:	8b 06                	mov    (%esi),%eax
80103764:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010376a:	8b 06                	mov    (%esi),%eax
8010376c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103770:	8b 06                	mov    (%esi),%eax
80103772:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103776:	8b 06                	mov    (%esi),%eax
80103778:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010377b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010377e:	31 c0                	xor    %eax,%eax
}
80103780:	5b                   	pop    %ebx
80103781:	5e                   	pop    %esi
80103782:	5f                   	pop    %edi
80103783:	5d                   	pop    %ebp
80103784:	c3                   	ret    
80103785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103790 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	56                   	push   %esi
80103794:	53                   	push   %ebx
80103795:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103798:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010379b:	83 ec 0c             	sub    $0xc,%esp
8010379e:	53                   	push   %ebx
8010379f:	e8 1c 10 00 00       	call   801047c0 <acquire>
  if(writable){
801037a4:	83 c4 10             	add    $0x10,%esp
801037a7:	85 f6                	test   %esi,%esi
801037a9:	74 45                	je     801037f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801037ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037b1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801037b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801037bb:	00 00 00 
    wakeup(&p->nread);
801037be:	50                   	push   %eax
801037bf:	e8 fc 0b 00 00       	call   801043c0 <wakeup>
801037c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801037c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801037cd:	85 d2                	test   %edx,%edx
801037cf:	75 0a                	jne    801037db <pipeclose+0x4b>
801037d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801037d7:	85 c0                	test   %eax,%eax
801037d9:	74 35                	je     80103810 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801037db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801037de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037e1:	5b                   	pop    %ebx
801037e2:	5e                   	pop    %esi
801037e3:	5d                   	pop    %ebp
    release(&p->lock);
801037e4:	e9 f7 10 00 00       	jmp    801048e0 <release>
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801037f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801037f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801037f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103800:	00 00 00 
    wakeup(&p->nwrite);
80103803:	50                   	push   %eax
80103804:	e8 b7 0b 00 00       	call   801043c0 <wakeup>
80103809:	83 c4 10             	add    $0x10,%esp
8010380c:	eb b9                	jmp    801037c7 <pipeclose+0x37>
8010380e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103810:	83 ec 0c             	sub    $0xc,%esp
80103813:	53                   	push   %ebx
80103814:	e8 c7 10 00 00       	call   801048e0 <release>
    kfree((char*)p);
80103819:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010381c:	83 c4 10             	add    $0x10,%esp
}
8010381f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103822:	5b                   	pop    %ebx
80103823:	5e                   	pop    %esi
80103824:	5d                   	pop    %ebp
    kfree((char*)p);
80103825:	e9 26 ef ff ff       	jmp    80102750 <kfree>
8010382a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103830 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	57                   	push   %edi
80103834:	56                   	push   %esi
80103835:	53                   	push   %ebx
80103836:	83 ec 28             	sub    $0x28,%esp
80103839:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010383c:	53                   	push   %ebx
8010383d:	e8 7e 0f 00 00       	call   801047c0 <acquire>
  for(i = 0; i < n; i++){
80103842:	8b 45 10             	mov    0x10(%ebp),%eax
80103845:	83 c4 10             	add    $0x10,%esp
80103848:	85 c0                	test   %eax,%eax
8010384a:	0f 8e c9 00 00 00    	jle    80103919 <pipewrite+0xe9>
80103850:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103853:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103859:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010385f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103862:	03 4d 10             	add    0x10(%ebp),%ecx
80103865:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103868:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010386e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103874:	39 d0                	cmp    %edx,%eax
80103876:	75 71                	jne    801038e9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103878:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010387e:	85 c0                	test   %eax,%eax
80103880:	74 4e                	je     801038d0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103882:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103888:	eb 3a                	jmp    801038c4 <pipewrite+0x94>
8010388a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	57                   	push   %edi
80103894:	e8 27 0b 00 00       	call   801043c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103899:	5a                   	pop    %edx
8010389a:	59                   	pop    %ecx
8010389b:	53                   	push   %ebx
8010389c:	56                   	push   %esi
8010389d:	e8 5e 09 00 00       	call   80104200 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801038ae:	83 c4 10             	add    $0x10,%esp
801038b1:	05 00 02 00 00       	add    $0x200,%eax
801038b6:	39 c2                	cmp    %eax,%edx
801038b8:	75 36                	jne    801038f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801038ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801038c0:	85 c0                	test   %eax,%eax
801038c2:	74 0c                	je     801038d0 <pipewrite+0xa0>
801038c4:	e8 77 03 00 00       	call   80103c40 <myproc>
801038c9:	8b 40 24             	mov    0x24(%eax),%eax
801038cc:	85 c0                	test   %eax,%eax
801038ce:	74 c0                	je     80103890 <pipewrite+0x60>
        release(&p->lock);
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	53                   	push   %ebx
801038d4:	e8 07 10 00 00       	call   801048e0 <release>
        return -1;
801038d9:	83 c4 10             	add    $0x10,%esp
801038dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801038e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038e4:	5b                   	pop    %ebx
801038e5:	5e                   	pop    %esi
801038e6:	5f                   	pop    %edi
801038e7:	5d                   	pop    %ebp
801038e8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038e9:	89 c2                	mov    %eax,%edx
801038eb:	90                   	nop
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801038f3:	8d 42 01             	lea    0x1(%edx),%eax
801038f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801038fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103902:	83 c6 01             	add    $0x1,%esi
80103905:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103909:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010390c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010390f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103913:	0f 85 4f ff ff ff    	jne    80103868 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103919:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010391f:	83 ec 0c             	sub    $0xc,%esp
80103922:	50                   	push   %eax
80103923:	e8 98 0a 00 00       	call   801043c0 <wakeup>
  release(&p->lock);
80103928:	89 1c 24             	mov    %ebx,(%esp)
8010392b:	e8 b0 0f 00 00       	call   801048e0 <release>
  return n;
80103930:	83 c4 10             	add    $0x10,%esp
80103933:	8b 45 10             	mov    0x10(%ebp),%eax
80103936:	eb a9                	jmp    801038e1 <pipewrite+0xb1>
80103938:	90                   	nop
80103939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103940 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
80103946:	83 ec 18             	sub    $0x18,%esp
80103949:	8b 75 08             	mov    0x8(%ebp),%esi
8010394c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010394f:	56                   	push   %esi
80103950:	e8 6b 0e 00 00       	call   801047c0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010395e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103964:	75 6a                	jne    801039d0 <piperead+0x90>
80103966:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010396c:	85 db                	test   %ebx,%ebx
8010396e:	0f 84 c4 00 00 00    	je     80103a38 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103974:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010397a:	eb 2d                	jmp    801039a9 <piperead+0x69>
8010397c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103980:	83 ec 08             	sub    $0x8,%esp
80103983:	56                   	push   %esi
80103984:	53                   	push   %ebx
80103985:	e8 76 08 00 00       	call   80104200 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010398a:	83 c4 10             	add    $0x10,%esp
8010398d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103993:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103999:	75 35                	jne    801039d0 <piperead+0x90>
8010399b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801039a1:	85 d2                	test   %edx,%edx
801039a3:	0f 84 8f 00 00 00    	je     80103a38 <piperead+0xf8>
    if(myproc()->killed){
801039a9:	e8 92 02 00 00       	call   80103c40 <myproc>
801039ae:	8b 48 24             	mov    0x24(%eax),%ecx
801039b1:	85 c9                	test   %ecx,%ecx
801039b3:	74 cb                	je     80103980 <piperead+0x40>
      release(&p->lock);
801039b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801039b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801039bd:	56                   	push   %esi
801039be:	e8 1d 0f 00 00       	call   801048e0 <release>
      return -1;
801039c3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801039c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039c9:	89 d8                	mov    %ebx,%eax
801039cb:	5b                   	pop    %ebx
801039cc:	5e                   	pop    %esi
801039cd:	5f                   	pop    %edi
801039ce:	5d                   	pop    %ebp
801039cf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039d0:	8b 45 10             	mov    0x10(%ebp),%eax
801039d3:	85 c0                	test   %eax,%eax
801039d5:	7e 61                	jle    80103a38 <piperead+0xf8>
    if(p->nread == p->nwrite)
801039d7:	31 db                	xor    %ebx,%ebx
801039d9:	eb 13                	jmp    801039ee <piperead+0xae>
801039db:	90                   	nop
801039dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039ec:	74 1f                	je     80103a0d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801039ee:	8d 41 01             	lea    0x1(%ecx),%eax
801039f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801039f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801039fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103a02:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a05:	83 c3 01             	add    $0x1,%ebx
80103a08:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a0b:	75 d3                	jne    801039e0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a0d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a13:	83 ec 0c             	sub    $0xc,%esp
80103a16:	50                   	push   %eax
80103a17:	e8 a4 09 00 00       	call   801043c0 <wakeup>
  release(&p->lock);
80103a1c:	89 34 24             	mov    %esi,(%esp)
80103a1f:	e8 bc 0e 00 00       	call   801048e0 <release>
  return i;
80103a24:	83 c4 10             	add    $0x10,%esp
}
80103a27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a2a:	89 d8                	mov    %ebx,%eax
80103a2c:	5b                   	pop    %ebx
80103a2d:	5e                   	pop    %esi
80103a2e:	5f                   	pop    %edi
80103a2f:	5d                   	pop    %ebp
80103a30:	c3                   	ret    
80103a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a38:	31 db                	xor    %ebx,%ebx
80103a3a:	eb d1                	jmp    80103a0d <piperead+0xcd>
80103a3c:	66 90                	xchg   %ax,%ax
80103a3e:	66 90                	xchg   %ax,%ax

80103a40 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
#endif


    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a44:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
allocproc(void) {
80103a49:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80103a4c:	68 40 3d 11 80       	push   $0x80113d40
80103a51:	e8 6a 0d 00 00       	call   801047c0 <acquire>
80103a56:	83 c4 10             	add    $0x10,%esp
80103a59:	eb 13                	jmp    80103a6e <allocproc+0x2e>
80103a5b:	90                   	nop
80103a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a60:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
80103a66:	81 fb 74 54 12 80    	cmp    $0x80125474,%ebx
80103a6c:	73 7a                	jae    80103ae8 <allocproc+0xa8>
        if (p->state == UNUSED)
80103a6e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a71:	85 c0                	test   %eax,%eax
80103a73:	75 eb                	jne    80103a60 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103a75:	a1 04 a0 10 80       	mov    0x8010a004,%eax

    release(&ptable.lock);
80103a7a:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
80103a7d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80103a84:	8d 50 01             	lea    0x1(%eax),%edx
80103a87:	89 43 10             	mov    %eax,0x10(%ebx)
    release(&ptable.lock);
80103a8a:	68 40 3d 11 80       	push   $0x80113d40
    p->pid = nextpid++;
80103a8f:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
    release(&ptable.lock);
80103a95:	e8 46 0e 00 00       	call   801048e0 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
80103a9a:	e8 61 ee ff ff       	call   80102900 <kalloc>
80103a9f:	83 c4 10             	add    $0x10,%esp
80103aa2:	85 c0                	test   %eax,%eax
80103aa4:	89 43 08             	mov    %eax,0x8(%ebx)
80103aa7:	74 58                	je     80103b01 <allocproc+0xc1>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103aa9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
80103aaf:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103ab2:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103ab7:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint *) sp = (uint) trapret;
80103aba:	c7 40 14 82 5b 10 80 	movl   $0x80105b82,0x14(%eax)
    p->context = (struct context *) sp;
80103ac1:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103ac4:	6a 14                	push   $0x14
80103ac6:	6a 00                	push   $0x0
80103ac8:	50                   	push   %eax
80103ac9:	e8 72 0e 00 00       	call   80104940 <memset>
    p->context->eip = (uint) forkret;
80103ace:	8b 43 1c             	mov    0x1c(%ebx),%eax
        pg->physAdress = 0;
        pg->virtAdress = 0;
    }
#endif

    return p;
80103ad1:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint) forkret;
80103ad4:	c7 40 10 10 3b 10 80 	movl   $0x80103b10,0x10(%eax)
}
80103adb:	89 d8                	mov    %ebx,%eax
80103add:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ae0:	c9                   	leave  
80103ae1:	c3                   	ret    
80103ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
80103ae8:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80103aeb:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
80103aed:	68 40 3d 11 80       	push   $0x80113d40
80103af2:	e8 e9 0d 00 00       	call   801048e0 <release>
}
80103af7:	89 d8                	mov    %ebx,%eax
    return 0;
80103af9:	83 c4 10             	add    $0x10,%esp
}
80103afc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aff:	c9                   	leave  
80103b00:	c3                   	ret    
        p->state = UNUSED;
80103b01:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103b08:	31 db                	xor    %ebx,%ebx
80103b0a:	eb cf                	jmp    80103adb <allocproc+0x9b>
80103b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b10 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103b16:	68 40 3d 11 80       	push   $0x80113d40
80103b1b:	e8 c0 0d 00 00       	call   801048e0 <release>

    if (first) {
80103b20:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103b25:	83 c4 10             	add    $0x10,%esp
80103b28:	85 c0                	test   %eax,%eax
80103b2a:	75 04                	jne    80103b30 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103b2c:	c9                   	leave  
80103b2d:	c3                   	ret    
80103b2e:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
80103b30:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
80103b33:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103b3a:	00 00 00 
        iinit(ROOTDEV);
80103b3d:	6a 01                	push   $0x1
80103b3f:	e8 4c d9 ff ff       	call   80101490 <iinit>
        initlog(ROOTDEV);
80103b44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b4b:	e8 f0 f3 ff ff       	call   80102f40 <initlog>
80103b50:	83 c4 10             	add    $0x10,%esp
}
80103b53:	c9                   	leave  
80103b54:	c3                   	ret    
80103b55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b60 <notShell>:
    return nextpid > 2;
80103b60:	31 c0                	xor    %eax,%eax
80103b62:	83 3d 04 a0 10 80 02 	cmpl   $0x2,0x8010a004
int notShell(void) {
80103b69:	55                   	push   %ebp
80103b6a:	89 e5                	mov    %esp,%ebp
}
80103b6c:	5d                   	pop    %ebp
    return nextpid > 2;
80103b6d:	0f 9f c0             	setg   %al
}
80103b70:	c3                   	ret    
80103b71:	eb 0d                	jmp    80103b80 <pinit>
80103b73:	90                   	nop
80103b74:	90                   	nop
80103b75:	90                   	nop
80103b76:	90                   	nop
80103b77:	90                   	nop
80103b78:	90                   	nop
80103b79:	90                   	nop
80103b7a:	90                   	nop
80103b7b:	90                   	nop
80103b7c:	90                   	nop
80103b7d:	90                   	nop
80103b7e:	90                   	nop
80103b7f:	90                   	nop

80103b80 <pinit>:
pinit(void) {
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103b86:	68 75 7a 10 80       	push   $0x80107a75
80103b8b:	68 40 3d 11 80       	push   $0x80113d40
80103b90:	e8 3b 0b 00 00       	call   801046d0 <initlock>
}
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	c9                   	leave  
80103b99:	c3                   	ret    
80103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ba0 <mycpu>:
mycpu(void) {
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ba5:	9c                   	pushf  
80103ba6:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103ba7:	f6 c4 02             	test   $0x2,%ah
80103baa:	75 5e                	jne    80103c0a <mycpu+0x6a>
    apicid = lapicid();
80103bac:	e8 bf ef ff ff       	call   80102b70 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103bb1:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
80103bb7:	85 f6                	test   %esi,%esi
80103bb9:	7e 42                	jle    80103bfd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103bbb:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
80103bc2:	39 d0                	cmp    %edx,%eax
80103bc4:	74 30                	je     80103bf6 <mycpu+0x56>
80103bc6:	b9 50 28 11 80       	mov    $0x80112850,%ecx
    for (i = 0; i < ncpu; ++i) {
80103bcb:	31 d2                	xor    %edx,%edx
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi
80103bd0:	83 c2 01             	add    $0x1,%edx
80103bd3:	39 f2                	cmp    %esi,%edx
80103bd5:	74 26                	je     80103bfd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103bd7:	0f b6 19             	movzbl (%ecx),%ebx
80103bda:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103be0:	39 c3                	cmp    %eax,%ebx
80103be2:	75 ec                	jne    80103bd0 <mycpu+0x30>
80103be4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103bea:	05 a0 27 11 80       	add    $0x801127a0,%eax
}
80103bef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf2:	5b                   	pop    %ebx
80103bf3:	5e                   	pop    %esi
80103bf4:	5d                   	pop    %ebp
80103bf5:	c3                   	ret    
        if (cpus[i].apicid == apicid)
80103bf6:	b8 a0 27 11 80       	mov    $0x801127a0,%eax
            return &cpus[i];
80103bfb:	eb f2                	jmp    80103bef <mycpu+0x4f>
    panic("unknown apicid\n");
80103bfd:	83 ec 0c             	sub    $0xc,%esp
80103c00:	68 7c 7a 10 80       	push   $0x80107a7c
80103c05:	e8 86 c7 ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
80103c0a:	83 ec 0c             	sub    $0xc,%esp
80103c0d:	68 68 7b 10 80       	push   $0x80107b68
80103c12:	e8 79 c7 ff ff       	call   80100390 <panic>
80103c17:	89 f6                	mov    %esi,%esi
80103c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c20 <cpuid>:
cpuid() {
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103c26:	e8 75 ff ff ff       	call   80103ba0 <mycpu>
80103c2b:	2d a0 27 11 80       	sub    $0x801127a0,%eax
}
80103c30:	c9                   	leave  
    return mycpu() - cpus;
80103c31:	c1 f8 04             	sar    $0x4,%eax
80103c34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c3a:	c3                   	ret    
80103c3b:	90                   	nop
80103c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c40 <myproc>:
myproc(void) {
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	53                   	push   %ebx
80103c44:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103c47:	e8 34 0b 00 00       	call   80104780 <pushcli>
    c = mycpu();
80103c4c:	e8 4f ff ff ff       	call   80103ba0 <mycpu>
    p = c->proc;
80103c51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103c57:	e8 24 0c 00 00       	call   80104880 <popcli>
}
80103c5c:	83 c4 04             	add    $0x4,%esp
80103c5f:	89 d8                	mov    %ebx,%eax
80103c61:	5b                   	pop    %ebx
80103c62:	5d                   	pop    %ebp
80103c63:	c3                   	ret    
80103c64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c70 <userinit>:
userinit(void) {
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	53                   	push   %ebx
80103c74:	83 ec 04             	sub    $0x4,%esp
    totalAvailablePages = kallocCount();     //TODO - problem here
80103c77:	e8 34 ea ff ff       	call   801026b0 <kallocCount>
80103c7c:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
    p = allocproc();
80103c81:	e8 ba fd ff ff       	call   80103a40 <allocproc>
80103c86:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103c88:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
    if ((p->pgdir = setupkvm()) == 0)
80103c8d:	e8 9e 35 00 00       	call   80107230 <setupkvm>
80103c92:	85 c0                	test   %eax,%eax
80103c94:	89 43 04             	mov    %eax,0x4(%ebx)
80103c97:	0f 84 bd 00 00 00    	je     80103d5a <userinit+0xea>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103c9d:	83 ec 04             	sub    $0x4,%esp
80103ca0:	68 2c 00 00 00       	push   $0x2c
80103ca5:	68 60 a4 10 80       	push   $0x8010a460
80103caa:	50                   	push   %eax
80103cab:	e8 c0 31 00 00       	call   80106e70 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103cb0:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103cb3:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103cb9:	6a 4c                	push   $0x4c
80103cbb:	6a 00                	push   $0x0
80103cbd:	ff 73 18             	pushl  0x18(%ebx)
80103cc0:	e8 7b 0c 00 00       	call   80104940 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cc5:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc8:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ccd:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103cd2:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cd5:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cd9:	8b 43 18             	mov    0x18(%ebx),%eax
80103cdc:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103ce0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ce3:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ce7:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103ceb:	8b 43 18             	mov    0x18(%ebx),%eax
80103cee:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cf2:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103cf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf9:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103d00:	8b 43 18             	mov    0x18(%ebx),%eax
80103d03:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103d0a:	8b 43 18             	mov    0x18(%ebx),%eax
80103d0d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103d14:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d17:	6a 10                	push   $0x10
80103d19:	68 a5 7a 10 80       	push   $0x80107aa5
80103d1e:	50                   	push   %eax
80103d1f:	e8 fc 0d 00 00       	call   80104b20 <safestrcpy>
    p->cwd = namei("/");
80103d24:	c7 04 24 ae 7a 10 80 	movl   $0x80107aae,(%esp)
80103d2b:	e8 c0 e1 ff ff       	call   80101ef0 <namei>
80103d30:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103d33:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103d3a:	e8 81 0a 00 00       	call   801047c0 <acquire>
    p->state = RUNNABLE;
80103d3f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103d46:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103d4d:	e8 8e 0b 00 00       	call   801048e0 <release>
}
80103d52:	83 c4 10             	add    $0x10,%esp
80103d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d58:	c9                   	leave  
80103d59:	c3                   	ret    
        panic("userinit: out of memory?");
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	68 8c 7a 10 80       	push   $0x80107a8c
80103d62:	e8 29 c6 ff ff       	call   80100390 <panic>
80103d67:	89 f6                	mov    %esi,%esi
80103d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d70 <growproc>:
growproc(int n) {
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	56                   	push   %esi
80103d74:	53                   	push   %ebx
80103d75:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103d78:	e8 03 0a 00 00       	call   80104780 <pushcli>
    c = mycpu();
80103d7d:	e8 1e fe ff ff       	call   80103ba0 <mycpu>
    p = c->proc;
80103d82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103d88:	e8 f3 0a 00 00       	call   80104880 <popcli>
    if (n > 0) {
80103d8d:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103d90:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103d92:	7f 1c                	jg     80103db0 <growproc+0x40>
    } else if (n < 0) {
80103d94:	75 3a                	jne    80103dd0 <growproc+0x60>
    switchuvm(curproc);
80103d96:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103d99:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103d9b:	53                   	push   %ebx
80103d9c:	e8 bf 2f 00 00       	call   80106d60 <switchuvm>
    return 0;
80103da1:	83 c4 10             	add    $0x10,%esp
80103da4:	31 c0                	xor    %eax,%eax
}
80103da6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103da9:	5b                   	pop    %ebx
80103daa:	5e                   	pop    %esi
80103dab:	5d                   	pop    %ebp
80103dac:	c3                   	ret    
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103db0:	83 ec 04             	sub    $0x4,%esp
80103db3:	01 c6                	add    %eax,%esi
80103db5:	56                   	push   %esi
80103db6:	50                   	push   %eax
80103db7:	ff 73 04             	pushl  0x4(%ebx)
80103dba:	e8 91 32 00 00       	call   80107050 <allocuvm>
80103dbf:	83 c4 10             	add    $0x10,%esp
80103dc2:	85 c0                	test   %eax,%eax
80103dc4:	75 d0                	jne    80103d96 <growproc+0x26>
            return -1;
80103dc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dcb:	eb d9                	jmp    80103da6 <growproc+0x36>
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi
        curproc->pagesCounter += (PGROUNDUP(n) / PGSIZE);
80103dd0:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
80103dd6:	01 c6                	add    %eax,%esi
        curproc->pagesCounter += (PGROUNDUP(n) / PGSIZE);
80103dd8:	c1 fa 0c             	sar    $0xc,%edx
80103ddb:	01 93 44 04 00 00    	add    %edx,0x444(%ebx)
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
80103de1:	6a 01                	push   $0x1
80103de3:	56                   	push   %esi
80103de4:	50                   	push   %eax
80103de5:	ff 73 04             	pushl  0x4(%ebx)
80103de8:	e8 93 33 00 00       	call   80107180 <deallocuvm>
80103ded:	83 c4 10             	add    $0x10,%esp
80103df0:	85 c0                	test   %eax,%eax
80103df2:	75 a2                	jne    80103d96 <growproc+0x26>
80103df4:	eb d0                	jmp    80103dc6 <growproc+0x56>
80103df6:	8d 76 00             	lea    0x0(%esi),%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <fork>:
fork(void) {
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80103e09:	e8 72 09 00 00       	call   80104780 <pushcli>
    c = mycpu();
80103e0e:	e8 8d fd ff ff       	call   80103ba0 <mycpu>
    p = c->proc;
80103e13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103e19:	e8 62 0a 00 00       	call   80104880 <popcli>
    if ((np = allocproc()) == 0) {
80103e1e:	e8 1d fc ff ff       	call   80103a40 <allocproc>
80103e23:	85 c0                	test   %eax,%eax
80103e25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e28:	0f 84 c1 00 00 00    	je     80103eef <fork+0xef>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103e2e:	83 ec 08             	sub    $0x8,%esp
80103e31:	ff 33                	pushl  (%ebx)
80103e33:	ff 73 04             	pushl  0x4(%ebx)
80103e36:	89 c7                	mov    %eax,%edi
80103e38:	e8 c3 34 00 00       	call   80107300 <copyuvm>
80103e3d:	83 c4 10             	add    $0x10,%esp
80103e40:	85 c0                	test   %eax,%eax
80103e42:	89 47 04             	mov    %eax,0x4(%edi)
80103e45:	0f 84 ab 00 00 00    	je     80103ef6 <fork+0xf6>
    np->sz = curproc->sz;
80103e4b:	8b 03                	mov    (%ebx),%eax
80103e4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e50:	89 01                	mov    %eax,(%ecx)
    np->parent = curproc;
80103e52:	89 59 14             	mov    %ebx,0x14(%ecx)
80103e55:	89 c8                	mov    %ecx,%eax
    *np->tf = *curproc->tf;
80103e57:	8b 79 18             	mov    0x18(%ecx),%edi
80103e5a:	8b 73 18             	mov    0x18(%ebx),%esi
80103e5d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++)
80103e64:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80103e66:	8b 40 18             	mov    0x18(%eax),%eax
80103e69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        if (curproc->ofile[i])
80103e70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e74:	85 c0                	test   %eax,%eax
80103e76:	74 13                	je     80103e8b <fork+0x8b>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103e78:	83 ec 0c             	sub    $0xc,%esp
80103e7b:	50                   	push   %eax
80103e7c:	e8 6f cf ff ff       	call   80100df0 <filedup>
80103e81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e84:	83 c4 10             	add    $0x10,%esp
80103e87:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103e8b:	83 c6 01             	add    $0x1,%esi
80103e8e:	83 fe 10             	cmp    $0x10,%esi
80103e91:	75 dd                	jne    80103e70 <fork+0x70>
    np->cwd = idup(curproc->cwd);
80103e93:	83 ec 0c             	sub    $0xc,%esp
80103e96:	ff 73 68             	pushl  0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e99:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
80103e9c:	e8 bf d7 ff ff       	call   80101660 <idup>
80103ea1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ea4:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
80103ea7:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103eaa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ead:	6a 10                	push   $0x10
80103eaf:	53                   	push   %ebx
80103eb0:	50                   	push   %eax
80103eb1:	e8 6a 0c 00 00       	call   80104b20 <safestrcpy>
    pid = np->pid;
80103eb6:	8b 5f 10             	mov    0x10(%edi),%ebx
    acquire(&ptable.lock);
80103eb9:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103ec0:	e8 fb 08 00 00       	call   801047c0 <acquire>
    np->state = RUNNABLE;
80103ec5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
80103ecc:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103ed3:	e8 08 0a 00 00       	call   801048e0 <release>
    firstRun = 0;
80103ed8:	c7 05 08 a0 10 80 00 	movl   $0x0,0x8010a008
80103edf:	00 00 00 
    return pid;
80103ee2:	83 c4 10             	add    $0x10,%esp
}
80103ee5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ee8:	89 d8                	mov    %ebx,%eax
80103eea:	5b                   	pop    %ebx
80103eeb:	5e                   	pop    %esi
80103eec:	5f                   	pop    %edi
80103eed:	5d                   	pop    %ebp
80103eee:	c3                   	ret    
        return -1;
80103eef:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ef4:	eb ef                	jmp    80103ee5 <fork+0xe5>
        kfree(np->kstack);
80103ef6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ef9:	83 ec 0c             	sub    $0xc,%esp
80103efc:	ff 73 08             	pushl  0x8(%ebx)
80103eff:	e8 4c e8 ff ff       	call   80102750 <kfree>
        np->kstack = 0;
80103f04:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
80103f0b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
80103f12:	83 c4 10             	add    $0x10,%esp
80103f15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f1a:	eb c9                	jmp    80103ee5 <fork+0xe5>
80103f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f20 <scheduler>:
scheduler(void) {
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
80103f29:	e8 72 fc ff ff       	call   80103ba0 <mycpu>
80103f2e:	8d 78 04             	lea    0x4(%eax),%edi
80103f31:	89 c6                	mov    %eax,%esi
    c->proc = 0;
80103f33:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f3a:	00 00 00 
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f40:	fb                   	sti    
        acquire(&ptable.lock);
80103f41:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103f44:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
        acquire(&ptable.lock);
80103f49:	68 40 3d 11 80       	push   $0x80113d40
80103f4e:	e8 6d 08 00 00       	call   801047c0 <acquire>
80103f53:	83 c4 10             	add    $0x10,%esp
80103f56:	8d 76 00             	lea    0x0(%esi),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (p->state != RUNNABLE)
80103f60:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f64:	75 33                	jne    80103f99 <scheduler+0x79>
            switchuvm(p);
80103f66:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80103f69:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
80103f6f:	53                   	push   %ebx
80103f70:	e8 eb 2d 00 00       	call   80106d60 <switchuvm>
            swtch(&(c->scheduler), p->context);
80103f75:	58                   	pop    %eax
80103f76:	5a                   	pop    %edx
80103f77:	ff 73 1c             	pushl  0x1c(%ebx)
80103f7a:	57                   	push   %edi
            p->state = RUNNING;
80103f7b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80103f82:	e8 f4 0b 00 00       	call   80104b7b <swtch>
            switchkvm();
80103f87:	e8 b4 2d 00 00       	call   80106d40 <switchkvm>
            c->proc = 0;
80103f8c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f93:	00 00 00 
80103f96:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103f99:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
80103f9f:	81 fb 74 54 12 80    	cmp    $0x80125474,%ebx
80103fa5:	72 b9                	jb     80103f60 <scheduler+0x40>
        release(&ptable.lock);
80103fa7:	83 ec 0c             	sub    $0xc,%esp
80103faa:	68 40 3d 11 80       	push   $0x80113d40
80103faf:	e8 2c 09 00 00       	call   801048e0 <release>
        sti();
80103fb4:	83 c4 10             	add    $0x10,%esp
80103fb7:	eb 87                	jmp    80103f40 <scheduler+0x20>
80103fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fc0 <sched>:
sched(void) {
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	56                   	push   %esi
80103fc4:	53                   	push   %ebx
    pushcli();
80103fc5:	e8 b6 07 00 00       	call   80104780 <pushcli>
    c = mycpu();
80103fca:	e8 d1 fb ff ff       	call   80103ba0 <mycpu>
    p = c->proc;
80103fcf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103fd5:	e8 a6 08 00 00       	call   80104880 <popcli>
    if (!holding(&ptable.lock))
80103fda:	83 ec 0c             	sub    $0xc,%esp
80103fdd:	68 40 3d 11 80       	push   $0x80113d40
80103fe2:	e8 59 07 00 00       	call   80104740 <holding>
80103fe7:	83 c4 10             	add    $0x10,%esp
80103fea:	85 c0                	test   %eax,%eax
80103fec:	74 4f                	je     8010403d <sched+0x7d>
    if (mycpu()->ncli != 1)
80103fee:	e8 ad fb ff ff       	call   80103ba0 <mycpu>
80103ff3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103ffa:	75 68                	jne    80104064 <sched+0xa4>
    if (p->state == RUNNING)
80103ffc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104000:	74 55                	je     80104057 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104002:	9c                   	pushf  
80104003:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80104004:	f6 c4 02             	test   $0x2,%ah
80104007:	75 41                	jne    8010404a <sched+0x8a>
    intena = mycpu()->intena;
80104009:	e8 92 fb ff ff       	call   80103ba0 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
8010400e:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
80104011:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
80104017:	e8 84 fb ff ff       	call   80103ba0 <mycpu>
8010401c:	83 ec 08             	sub    $0x8,%esp
8010401f:	ff 70 04             	pushl  0x4(%eax)
80104022:	53                   	push   %ebx
80104023:	e8 53 0b 00 00       	call   80104b7b <swtch>
    mycpu()->intena = intena;
80104028:	e8 73 fb ff ff       	call   80103ba0 <mycpu>
}
8010402d:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80104030:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104036:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104039:	5b                   	pop    %ebx
8010403a:	5e                   	pop    %esi
8010403b:	5d                   	pop    %ebp
8010403c:	c3                   	ret    
        panic("sched ptable.lock");
8010403d:	83 ec 0c             	sub    $0xc,%esp
80104040:	68 b0 7a 10 80       	push   $0x80107ab0
80104045:	e8 46 c3 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
8010404a:	83 ec 0c             	sub    $0xc,%esp
8010404d:	68 dc 7a 10 80       	push   $0x80107adc
80104052:	e8 39 c3 ff ff       	call   80100390 <panic>
        panic("sched running");
80104057:	83 ec 0c             	sub    $0xc,%esp
8010405a:	68 ce 7a 10 80       	push   $0x80107ace
8010405f:	e8 2c c3 ff ff       	call   80100390 <panic>
        panic("sched locks");
80104064:	83 ec 0c             	sub    $0xc,%esp
80104067:	68 c2 7a 10 80       	push   $0x80107ac2
8010406c:	e8 1f c3 ff ff       	call   80100390 <panic>
80104071:	eb 0d                	jmp    80104080 <exit>
80104073:	90                   	nop
80104074:	90                   	nop
80104075:	90                   	nop
80104076:	90                   	nop
80104077:	90                   	nop
80104078:	90                   	nop
80104079:	90                   	nop
8010407a:	90                   	nop
8010407b:	90                   	nop
8010407c:	90                   	nop
8010407d:	90                   	nop
8010407e:	90                   	nop
8010407f:	90                   	nop

80104080 <exit>:
exit(void) {
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104089:	e8 f2 06 00 00       	call   80104780 <pushcli>
    c = mycpu();
8010408e:	e8 0d fb ff ff       	call   80103ba0 <mycpu>
    p = c->proc;
80104093:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104099:	e8 e2 07 00 00       	call   80104880 <popcli>
    if (curproc == initproc)
8010409e:	39 35 bc a5 10 80    	cmp    %esi,0x8010a5bc
801040a4:	8d 5e 28             	lea    0x28(%esi),%ebx
801040a7:	8d 7e 68             	lea    0x68(%esi),%edi
801040aa:	0f 84 f1 00 00 00    	je     801041a1 <exit+0x121>
        if (curproc->ofile[fd]) {
801040b0:	8b 03                	mov    (%ebx),%eax
801040b2:	85 c0                	test   %eax,%eax
801040b4:	74 12                	je     801040c8 <exit+0x48>
            fileclose(curproc->ofile[fd]);
801040b6:	83 ec 0c             	sub    $0xc,%esp
801040b9:	50                   	push   %eax
801040ba:	e8 81 cd ff ff       	call   80100e40 <fileclose>
            curproc->ofile[fd] = 0;
801040bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040c5:	83 c4 10             	add    $0x10,%esp
801040c8:	83 c3 04             	add    $0x4,%ebx
    for (fd = 0; fd < NOFILE; fd++) {
801040cb:	39 fb                	cmp    %edi,%ebx
801040cd:	75 e1                	jne    801040b0 <exit+0x30>
    begin_op();
801040cf:	e8 0c ef ff ff       	call   80102fe0 <begin_op>
    iput(curproc->cwd);
801040d4:	83 ec 0c             	sub    $0xc,%esp
801040d7:	ff 76 68             	pushl  0x68(%esi)
801040da:	e8 e1 d6 ff ff       	call   801017c0 <iput>
    end_op();
801040df:	e8 6c ef ff ff       	call   80103050 <end_op>
    curproc->cwd = 0;
801040e4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
    acquire(&ptable.lock);
801040eb:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801040f2:	e8 c9 06 00 00       	call   801047c0 <acquire>
    wakeup1(curproc->parent);
801040f7:	8b 56 14             	mov    0x14(%esi),%edx
801040fa:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040fd:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104102:	eb 10                	jmp    80104114 <exit+0x94>
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104108:	05 5c 04 00 00       	add    $0x45c,%eax
8010410d:	3d 74 54 12 80       	cmp    $0x80125474,%eax
80104112:	73 1e                	jae    80104132 <exit+0xb2>
        if (p->state == SLEEPING && p->chan == chan)
80104114:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104118:	75 ee                	jne    80104108 <exit+0x88>
8010411a:	3b 50 20             	cmp    0x20(%eax),%edx
8010411d:	75 e9                	jne    80104108 <exit+0x88>
            p->state = RUNNABLE;
8010411f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104126:	05 5c 04 00 00       	add    $0x45c,%eax
8010412b:	3d 74 54 12 80       	cmp    $0x80125474,%eax
80104130:	72 e2                	jb     80104114 <exit+0x94>
            p->parent = initproc;
80104132:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104138:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
8010413d:	eb 0f                	jmp    8010414e <exit+0xce>
8010413f:	90                   	nop
80104140:	81 c2 5c 04 00 00    	add    $0x45c,%edx
80104146:	81 fa 74 54 12 80    	cmp    $0x80125474,%edx
8010414c:	73 3a                	jae    80104188 <exit+0x108>
        if (p->parent == curproc) {
8010414e:	39 72 14             	cmp    %esi,0x14(%edx)
80104151:	75 ed                	jne    80104140 <exit+0xc0>
            if (p->state == ZOMBIE)
80104153:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104157:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010415a:	75 e4                	jne    80104140 <exit+0xc0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010415c:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104161:	eb 11                	jmp    80104174 <exit+0xf4>
80104163:	90                   	nop
80104164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104168:	05 5c 04 00 00       	add    $0x45c,%eax
8010416d:	3d 74 54 12 80       	cmp    $0x80125474,%eax
80104172:	73 cc                	jae    80104140 <exit+0xc0>
        if (p->state == SLEEPING && p->chan == chan)
80104174:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104178:	75 ee                	jne    80104168 <exit+0xe8>
8010417a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010417d:	75 e9                	jne    80104168 <exit+0xe8>
            p->state = RUNNABLE;
8010417f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104186:	eb e0                	jmp    80104168 <exit+0xe8>
    curproc->state = ZOMBIE;
80104188:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    sched();
8010418f:	e8 2c fe ff ff       	call   80103fc0 <sched>
    panic("zombie exit");
80104194:	83 ec 0c             	sub    $0xc,%esp
80104197:	68 fd 7a 10 80       	push   $0x80107afd
8010419c:	e8 ef c1 ff ff       	call   80100390 <panic>
        panic("init exiting");
801041a1:	83 ec 0c             	sub    $0xc,%esp
801041a4:	68 f0 7a 10 80       	push   $0x80107af0
801041a9:	e8 e2 c1 ff ff       	call   80100390 <panic>
801041ae:	66 90                	xchg   %ax,%ax

801041b0 <yield>:
yield(void) {
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
801041b4:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
801041b7:	68 40 3d 11 80       	push   $0x80113d40
801041bc:	e8 ff 05 00 00       	call   801047c0 <acquire>
    pushcli();
801041c1:	e8 ba 05 00 00       	call   80104780 <pushcli>
    c = mycpu();
801041c6:	e8 d5 f9 ff ff       	call   80103ba0 <mycpu>
    p = c->proc;
801041cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801041d1:	e8 aa 06 00 00       	call   80104880 <popcli>
    myproc()->state = RUNNABLE;
801041d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
801041dd:	e8 de fd ff ff       	call   80103fc0 <sched>
    release(&ptable.lock);
801041e2:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801041e9:	e8 f2 06 00 00       	call   801048e0 <release>
}
801041ee:	83 c4 10             	add    $0x10,%esp
801041f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041f4:	c9                   	leave  
801041f5:	c3                   	ret    
801041f6:	8d 76 00             	lea    0x0(%esi),%esi
801041f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104200 <sleep>:
sleep(void *chan, struct spinlock *lk) {
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	57                   	push   %edi
80104204:	56                   	push   %esi
80104205:	53                   	push   %ebx
80104206:	83 ec 0c             	sub    $0xc,%esp
80104209:	8b 7d 08             	mov    0x8(%ebp),%edi
8010420c:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
8010420f:	e8 6c 05 00 00       	call   80104780 <pushcli>
    c = mycpu();
80104214:	e8 87 f9 ff ff       	call   80103ba0 <mycpu>
    p = c->proc;
80104219:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010421f:	e8 5c 06 00 00       	call   80104880 <popcli>
    if (p == 0)
80104224:	85 db                	test   %ebx,%ebx
80104226:	0f 84 87 00 00 00    	je     801042b3 <sleep+0xb3>
    if (lk == 0)
8010422c:	85 f6                	test   %esi,%esi
8010422e:	74 76                	je     801042a6 <sleep+0xa6>
    if (lk != &ptable.lock) {  //DOC: sleeplock0
80104230:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
80104236:	74 50                	je     80104288 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104238:	83 ec 0c             	sub    $0xc,%esp
8010423b:	68 40 3d 11 80       	push   $0x80113d40
80104240:	e8 7b 05 00 00       	call   801047c0 <acquire>
        release(lk);
80104245:	89 34 24             	mov    %esi,(%esp)
80104248:	e8 93 06 00 00       	call   801048e0 <release>
    p->chan = chan;
8010424d:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104250:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104257:	e8 64 fd ff ff       	call   80103fc0 <sched>
    p->chan = 0;
8010425c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80104263:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010426a:	e8 71 06 00 00       	call   801048e0 <release>
        acquire(lk);
8010426f:	89 75 08             	mov    %esi,0x8(%ebp)
80104272:	83 c4 10             	add    $0x10,%esp
}
80104275:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104278:	5b                   	pop    %ebx
80104279:	5e                   	pop    %esi
8010427a:	5f                   	pop    %edi
8010427b:	5d                   	pop    %ebp
        acquire(lk);
8010427c:	e9 3f 05 00 00       	jmp    801047c0 <acquire>
80104281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104288:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010428b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104292:	e8 29 fd ff ff       	call   80103fc0 <sched>
    p->chan = 0;
80104297:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010429e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042a1:	5b                   	pop    %ebx
801042a2:	5e                   	pop    %esi
801042a3:	5f                   	pop    %edi
801042a4:	5d                   	pop    %ebp
801042a5:	c3                   	ret    
        panic("sleep without lk");
801042a6:	83 ec 0c             	sub    $0xc,%esp
801042a9:	68 0f 7b 10 80       	push   $0x80107b0f
801042ae:	e8 dd c0 ff ff       	call   80100390 <panic>
        panic("sleep");
801042b3:	83 ec 0c             	sub    $0xc,%esp
801042b6:	68 09 7b 10 80       	push   $0x80107b09
801042bb:	e8 d0 c0 ff ff       	call   80100390 <panic>

801042c0 <wait>:
wait(void) {
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
    pushcli();
801042c5:	e8 b6 04 00 00       	call   80104780 <pushcli>
    c = mycpu();
801042ca:	e8 d1 f8 ff ff       	call   80103ba0 <mycpu>
    p = c->proc;
801042cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801042d5:	e8 a6 05 00 00       	call   80104880 <popcli>
    acquire(&ptable.lock);
801042da:	83 ec 0c             	sub    $0xc,%esp
801042dd:	68 40 3d 11 80       	push   $0x80113d40
801042e2:	e8 d9 04 00 00       	call   801047c0 <acquire>
801042e7:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
801042ea:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042ec:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
801042f1:	eb 13                	jmp    80104306 <wait+0x46>
801042f3:	90                   	nop
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042f8:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
801042fe:	81 fb 74 54 12 80    	cmp    $0x80125474,%ebx
80104304:	73 1e                	jae    80104324 <wait+0x64>
            if (p->parent != curproc)
80104306:	39 73 14             	cmp    %esi,0x14(%ebx)
80104309:	75 ed                	jne    801042f8 <wait+0x38>
            if (p->state == ZOMBIE) {
8010430b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010430f:	74 37                	je     80104348 <wait+0x88>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104311:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
            havekids = 1;
80104317:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010431c:	81 fb 74 54 12 80    	cmp    $0x80125474,%ebx
80104322:	72 e2                	jb     80104306 <wait+0x46>
        if (!havekids || curproc->killed) {
80104324:	85 c0                	test   %eax,%eax
80104326:	74 76                	je     8010439e <wait+0xde>
80104328:	8b 46 24             	mov    0x24(%esi),%eax
8010432b:	85 c0                	test   %eax,%eax
8010432d:	75 6f                	jne    8010439e <wait+0xde>
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010432f:	83 ec 08             	sub    $0x8,%esp
80104332:	68 40 3d 11 80       	push   $0x80113d40
80104337:	56                   	push   %esi
80104338:	e8 c3 fe ff ff       	call   80104200 <sleep>
        havekids = 0;
8010433d:	83 c4 10             	add    $0x10,%esp
80104340:	eb a8                	jmp    801042ea <wait+0x2a>
80104342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                kfree(p->kstack);
80104348:	83 ec 0c             	sub    $0xc,%esp
8010434b:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
8010434e:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80104351:	e8 fa e3 ff ff       	call   80102750 <kfree>
                freevm(p->pgdir);
80104356:	5a                   	pop    %edx
80104357:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
8010435a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104361:	e8 4a 2e 00 00       	call   801071b0 <freevm>
                release(&ptable.lock);
80104366:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
                p->pid = 0;
8010436d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104374:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
8010437b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
8010437f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104386:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
8010438d:	e8 4e 05 00 00       	call   801048e0 <release>
                return pid;
80104392:	83 c4 10             	add    $0x10,%esp
}
80104395:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104398:	89 f0                	mov    %esi,%eax
8010439a:	5b                   	pop    %ebx
8010439b:	5e                   	pop    %esi
8010439c:	5d                   	pop    %ebp
8010439d:	c3                   	ret    
            release(&ptable.lock);
8010439e:	83 ec 0c             	sub    $0xc,%esp
            return -1;
801043a1:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
801043a6:	68 40 3d 11 80       	push   $0x80113d40
801043ab:	e8 30 05 00 00       	call   801048e0 <release>
            return -1;
801043b0:	83 c4 10             	add    $0x10,%esp
801043b3:	eb e0                	jmp    80104395 <wait+0xd5>
801043b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	83 ec 10             	sub    $0x10,%esp
801043c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
801043ca:	68 40 3d 11 80       	push   $0x80113d40
801043cf:	e8 ec 03 00 00       	call   801047c0 <acquire>
801043d4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d7:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801043dc:	eb 0e                	jmp    801043ec <wakeup+0x2c>
801043de:	66 90                	xchg   %ax,%ax
801043e0:	05 5c 04 00 00       	add    $0x45c,%eax
801043e5:	3d 74 54 12 80       	cmp    $0x80125474,%eax
801043ea:	73 1e                	jae    8010440a <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan)
801043ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043f0:	75 ee                	jne    801043e0 <wakeup+0x20>
801043f2:	3b 58 20             	cmp    0x20(%eax),%ebx
801043f5:	75 e9                	jne    801043e0 <wakeup+0x20>
            p->state = RUNNABLE;
801043f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043fe:	05 5c 04 00 00       	add    $0x45c,%eax
80104403:	3d 74 54 12 80       	cmp    $0x80125474,%eax
80104408:	72 e2                	jb     801043ec <wakeup+0x2c>
    wakeup1(chan);
    release(&ptable.lock);
8010440a:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
80104411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104414:	c9                   	leave  
    release(&ptable.lock);
80104415:	e9 c6 04 00 00       	jmp    801048e0 <release>
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
80104424:	83 ec 10             	sub    $0x10,%esp
80104427:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
8010442a:	68 40 3d 11 80       	push   $0x80113d40
8010442f:	e8 8c 03 00 00       	call   801047c0 <acquire>
80104434:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104437:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010443c:	eb 0e                	jmp    8010444c <kill+0x2c>
8010443e:	66 90                	xchg   %ax,%ax
80104440:	05 5c 04 00 00       	add    $0x45c,%eax
80104445:	3d 74 54 12 80       	cmp    $0x80125474,%eax
8010444a:	73 34                	jae    80104480 <kill+0x60>
        if (p->pid == pid) {
8010444c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010444f:	75 ef                	jne    80104440 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
80104451:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
80104455:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
8010445c:	75 07                	jne    80104465 <kill+0x45>
                p->state = RUNNABLE;
8010445e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104465:	83 ec 0c             	sub    $0xc,%esp
80104468:	68 40 3d 11 80       	push   $0x80113d40
8010446d:	e8 6e 04 00 00       	call   801048e0 <release>
            return 0;
80104472:	83 c4 10             	add    $0x10,%esp
80104475:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104477:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010447a:	c9                   	leave  
8010447b:	c3                   	ret    
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	68 40 3d 11 80       	push   $0x80113d40
80104488:	e8 53 04 00 00       	call   801048e0 <release>
    return -1;
8010448d:	83 c4 10             	add    $0x10,%esp
80104490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104498:	c9                   	leave  
80104499:	c3                   	ret    
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
801044a5:	53                   	push   %ebx
801044a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int currentFreePages = 0;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044a9:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
procdump(void) {
801044ae:	83 ec 3c             	sub    $0x3c,%esp
801044b1:	eb 27                	jmp    801044da <procdump+0x3a>
801044b3:	90                   	nop
801044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	68 c9 7e 10 80       	push   $0x80107ec9
801044c0:	e8 9b c1 ff ff       	call   80100660 <cprintf>
801044c5:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044c8:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
801044ce:	81 fb 74 54 12 80    	cmp    $0x80125474,%ebx
801044d4:	0f 83 b6 00 00 00    	jae    80104590 <procdump+0xf0>
        if (p->state == UNUSED)
801044da:	8b 43 0c             	mov    0xc(%ebx),%eax
801044dd:	85 c0                	test   %eax,%eax
801044df:	74 e7                	je     801044c8 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044e1:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
801044e4:	ba 20 7b 10 80       	mov    $0x80107b20,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044e9:	77 11                	ja     801044fc <procdump+0x5c>
801044eb:	8b 14 85 b4 7b 10 80 	mov    -0x7fef844c(,%eax,4),%edx
            state = "???";
801044f2:	b8 20 7b 10 80       	mov    $0x80107b20,%eax
801044f7:	85 d2                	test   %edx,%edx
801044f9:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %d %d %d %d %d %s", p->pid, state, p->name,
801044fc:	8b 83 48 04 00 00    	mov    0x448(%ebx),%eax
80104502:	8b 8b 44 04 00 00    	mov    0x444(%ebx),%ecx
80104508:	83 ec 0c             	sub    $0xc,%esp
8010450b:	ff b3 58 04 00 00    	pushl  0x458(%ebx)
80104511:	ff b3 54 04 00 00    	pushl  0x454(%ebx)
80104517:	ff b3 50 04 00 00    	pushl  0x450(%ebx)
8010451d:	29 c1                	sub    %eax,%ecx
8010451f:	50                   	push   %eax
80104520:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104523:	51                   	push   %ecx
80104524:	50                   	push   %eax
80104525:	52                   	push   %edx
80104526:	ff 73 10             	pushl  0x10(%ebx)
80104529:	68 24 7b 10 80       	push   $0x80107b24
8010452e:	e8 2d c1 ff ff       	call   80100660 <cprintf>
        if (p->state == SLEEPING) {
80104533:	83 c4 30             	add    $0x30,%esp
80104536:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
8010453a:	0f 85 78 ff ff ff    	jne    801044b8 <procdump+0x18>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
80104540:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104543:	83 ec 08             	sub    $0x8,%esp
80104546:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104549:	50                   	push   %eax
8010454a:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010454d:	8b 40 0c             	mov    0xc(%eax),%eax
80104550:	83 c0 08             	add    $0x8,%eax
80104553:	50                   	push   %eax
80104554:	e8 97 01 00 00       	call   801046f0 <getcallerpcs>
80104559:	83 c4 10             	add    $0x10,%esp
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104560:	8b 17                	mov    (%edi),%edx
80104562:	85 d2                	test   %edx,%edx
80104564:	0f 84 4e ff ff ff    	je     801044b8 <procdump+0x18>
                cprintf(" %p", pc[i]);
8010456a:	83 ec 08             	sub    $0x8,%esp
8010456d:	83 c7 04             	add    $0x4,%edi
80104570:	52                   	push   %edx
80104571:	68 01 75 10 80       	push   $0x80107501
80104576:	e8 e5 c0 ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
8010457b:	83 c4 10             	add    $0x10,%esp
8010457e:	39 fe                	cmp    %edi,%esi
80104580:	75 de                	jne    80104560 <procdump+0xc0>
80104582:	e9 31 ff ff ff       	jmp    801044b8 <procdump+0x18>
80104587:	89 f6                	mov    %esi,%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
    currentFreePages = kallocCount();
80104590:	e8 1b e1 ff ff       	call   801026b0 <kallocCount>
    currentFreePages = 100 * currentFreePages;
80104595:	6b c0 64             	imul   $0x64,%eax,%eax
    cprintf(" %d / %d free pages in the system", currentFreePages, totalAvailablePages);
80104598:	83 ec 04             	sub    $0x4,%esp
8010459b:	ff 35 b8 a5 10 80    	pushl  0x8010a5b8
801045a1:	50                   	push   %eax
801045a2:	68 90 7b 10 80       	push   $0x80107b90
801045a7:	e8 b4 c0 ff ff       	call   80100660 <cprintf>
}
801045ac:	83 c4 10             	add    $0x10,%esp
801045af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045b2:	5b                   	pop    %ebx
801045b3:	5e                   	pop    %esi
801045b4:	5f                   	pop    %edi
801045b5:	5d                   	pop    %ebp
801045b6:	c3                   	ret    
801045b7:	66 90                	xchg   %ax,%ax
801045b9:	66 90                	xchg   %ax,%ax
801045bb:	66 90                	xchg   %ax,%ax
801045bd:	66 90                	xchg   %ax,%ax
801045bf:	90                   	nop

801045c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
801045c4:	83 ec 0c             	sub    $0xc,%esp
801045c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045ca:	68 cc 7b 10 80       	push   $0x80107bcc
801045cf:	8d 43 04             	lea    0x4(%ebx),%eax
801045d2:	50                   	push   %eax
801045d3:	e8 f8 00 00 00       	call   801046d0 <initlock>
  lk->name = name;
801045d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045e1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f1:	c9                   	leave  
801045f2:	c3                   	ret    
801045f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104600 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	56                   	push   %esi
80104604:	53                   	push   %ebx
80104605:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104608:	83 ec 0c             	sub    $0xc,%esp
8010460b:	8d 73 04             	lea    0x4(%ebx),%esi
8010460e:	56                   	push   %esi
8010460f:	e8 ac 01 00 00       	call   801047c0 <acquire>
  while (lk->locked) {
80104614:	8b 13                	mov    (%ebx),%edx
80104616:	83 c4 10             	add    $0x10,%esp
80104619:	85 d2                	test   %edx,%edx
8010461b:	74 16                	je     80104633 <acquiresleep+0x33>
8010461d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104620:	83 ec 08             	sub    $0x8,%esp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	e8 d6 fb ff ff       	call   80104200 <sleep>
  while (lk->locked) {
8010462a:	8b 03                	mov    (%ebx),%eax
8010462c:	83 c4 10             	add    $0x10,%esp
8010462f:	85 c0                	test   %eax,%eax
80104631:	75 ed                	jne    80104620 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104633:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104639:	e8 02 f6 ff ff       	call   80103c40 <myproc>
8010463e:	8b 40 10             	mov    0x10(%eax),%eax
80104641:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104644:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104647:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010464a:	5b                   	pop    %ebx
8010464b:	5e                   	pop    %esi
8010464c:	5d                   	pop    %ebp
  release(&lk->lk);
8010464d:	e9 8e 02 00 00       	jmp    801048e0 <release>
80104652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104660 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104668:	83 ec 0c             	sub    $0xc,%esp
8010466b:	8d 73 04             	lea    0x4(%ebx),%esi
8010466e:	56                   	push   %esi
8010466f:	e8 4c 01 00 00       	call   801047c0 <acquire>
  lk->locked = 0;
80104674:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010467a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104681:	89 1c 24             	mov    %ebx,(%esp)
80104684:	e8 37 fd ff ff       	call   801043c0 <wakeup>
  release(&lk->lk);
80104689:	89 75 08             	mov    %esi,0x8(%ebp)
8010468c:	83 c4 10             	add    $0x10,%esp
}
8010468f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104692:	5b                   	pop    %ebx
80104693:	5e                   	pop    %esi
80104694:	5d                   	pop    %ebp
  release(&lk->lk);
80104695:	e9 46 02 00 00       	jmp    801048e0 <release>
8010469a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	8d 5e 04             	lea    0x4(%esi),%ebx
801046ae:	53                   	push   %ebx
801046af:	e8 0c 01 00 00       	call   801047c0 <acquire>
  r = lk->locked;
801046b4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801046b6:	89 1c 24             	mov    %ebx,(%esp)
801046b9:	e8 22 02 00 00       	call   801048e0 <release>
  return r;
}
801046be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c1:	89 f0                	mov    %esi,%eax
801046c3:	5b                   	pop    %ebx
801046c4:	5e                   	pop    %esi
801046c5:	5d                   	pop    %ebp
801046c6:	c3                   	ret    
801046c7:	66 90                	xchg   %ax,%ax
801046c9:	66 90                	xchg   %ax,%ax
801046cb:	66 90                	xchg   %ax,%ax
801046cd:	66 90                	xchg   %ax,%ax
801046cf:	90                   	nop

801046d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046e9:	5d                   	pop    %ebp
801046ea:	c3                   	ret    
801046eb:	90                   	nop
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046f1:	31 d2                	xor    %edx,%edx
{
801046f3:	89 e5                	mov    %esp,%ebp
801046f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046fc:	83 e8 08             	sub    $0x8,%eax
801046ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104700:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104706:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010470c:	77 1a                	ja     80104728 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010470e:	8b 58 04             	mov    0x4(%eax),%ebx
80104711:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104714:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104717:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104719:	83 fa 0a             	cmp    $0xa,%edx
8010471c:	75 e2                	jne    80104700 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010471e:	5b                   	pop    %ebx
8010471f:	5d                   	pop    %ebp
80104720:	c3                   	ret    
80104721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104728:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010472b:	83 c1 28             	add    $0x28,%ecx
8010472e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104736:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104739:	39 c1                	cmp    %eax,%ecx
8010473b:	75 f3                	jne    80104730 <getcallerpcs+0x40>
}
8010473d:	5b                   	pop    %ebx
8010473e:	5d                   	pop    %ebp
8010473f:	c3                   	ret    

80104740 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	53                   	push   %ebx
80104744:	83 ec 04             	sub    $0x4,%esp
80104747:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010474a:	8b 02                	mov    (%edx),%eax
8010474c:	85 c0                	test   %eax,%eax
8010474e:	75 10                	jne    80104760 <holding+0x20>
}
80104750:	83 c4 04             	add    $0x4,%esp
80104753:	31 c0                	xor    %eax,%eax
80104755:	5b                   	pop    %ebx
80104756:	5d                   	pop    %ebp
80104757:	c3                   	ret    
80104758:	90                   	nop
80104759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104760:	8b 5a 08             	mov    0x8(%edx),%ebx
80104763:	e8 38 f4 ff ff       	call   80103ba0 <mycpu>
80104768:	39 c3                	cmp    %eax,%ebx
8010476a:	0f 94 c0             	sete   %al
}
8010476d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104770:	0f b6 c0             	movzbl %al,%eax
}
80104773:	5b                   	pop    %ebx
80104774:	5d                   	pop    %ebp
80104775:	c3                   	ret    
80104776:	8d 76 00             	lea    0x0(%esi),%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 04             	sub    $0x4,%esp
80104787:	9c                   	pushf  
80104788:	5b                   	pop    %ebx
  asm volatile("cli");
80104789:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010478a:	e8 11 f4 ff ff       	call   80103ba0 <mycpu>
8010478f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104795:	85 c0                	test   %eax,%eax
80104797:	75 11                	jne    801047aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104799:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010479f:	e8 fc f3 ff ff       	call   80103ba0 <mycpu>
801047a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801047aa:	e8 f1 f3 ff ff       	call   80103ba0 <mycpu>
801047af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047b6:	83 c4 04             	add    $0x4,%esp
801047b9:	5b                   	pop    %ebx
801047ba:	5d                   	pop    %ebp
801047bb:	c3                   	ret    
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <acquire>:
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801047c5:	e8 b6 ff ff ff       	call   80104780 <pushcli>
  if(holding(lk))
801047ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801047cd:	8b 03                	mov    (%ebx),%eax
801047cf:	85 c0                	test   %eax,%eax
801047d1:	0f 85 81 00 00 00    	jne    80104858 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801047d7:	ba 01 00 00 00       	mov    $0x1,%edx
801047dc:	eb 05                	jmp    801047e3 <acquire+0x23>
801047de:	66 90                	xchg   %ax,%ax
801047e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047e3:	89 d0                	mov    %edx,%eax
801047e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801047e8:	85 c0                	test   %eax,%eax
801047ea:	75 f4                	jne    801047e0 <acquire+0x20>
  __sync_synchronize();
801047ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047f4:	e8 a7 f3 ff ff       	call   80103ba0 <mycpu>
  for(i = 0; i < 10; i++){
801047f9:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
801047fb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
801047fe:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104801:	89 e8                	mov    %ebp,%eax
80104803:	90                   	nop
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104808:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010480e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104814:	77 1a                	ja     80104830 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104816:	8b 58 04             	mov    0x4(%eax),%ebx
80104819:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010481c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010481f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104821:	83 fa 0a             	cmp    $0xa,%edx
80104824:	75 e2                	jne    80104808 <acquire+0x48>
}
80104826:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104829:	5b                   	pop    %ebx
8010482a:	5e                   	pop    %esi
8010482b:	5d                   	pop    %ebp
8010482c:	c3                   	ret    
8010482d:	8d 76 00             	lea    0x0(%esi),%esi
80104830:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104833:	83 c1 28             	add    $0x28,%ecx
80104836:	8d 76 00             	lea    0x0(%esi),%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104840:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104846:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104849:	39 c8                	cmp    %ecx,%eax
8010484b:	75 f3                	jne    80104840 <acquire+0x80>
}
8010484d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104850:	5b                   	pop    %ebx
80104851:	5e                   	pop    %esi
80104852:	5d                   	pop    %ebp
80104853:	c3                   	ret    
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104858:	8b 73 08             	mov    0x8(%ebx),%esi
8010485b:	e8 40 f3 ff ff       	call   80103ba0 <mycpu>
80104860:	39 c6                	cmp    %eax,%esi
80104862:	0f 85 6f ff ff ff    	jne    801047d7 <acquire+0x17>
    panic("acquire");
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	68 d7 7b 10 80       	push   $0x80107bd7
80104870:	e8 1b bb ff ff       	call   80100390 <panic>
80104875:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <popcli>:

void
popcli(void)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104886:	9c                   	pushf  
80104887:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104888:	f6 c4 02             	test   $0x2,%ah
8010488b:	75 35                	jne    801048c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010488d:	e8 0e f3 ff ff       	call   80103ba0 <mycpu>
80104892:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104899:	78 34                	js     801048cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010489b:	e8 00 f3 ff ff       	call   80103ba0 <mycpu>
801048a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048a6:	85 d2                	test   %edx,%edx
801048a8:	74 06                	je     801048b0 <popcli+0x30>
    sti();
}
801048aa:	c9                   	leave  
801048ab:	c3                   	ret    
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048b0:	e8 eb f2 ff ff       	call   80103ba0 <mycpu>
801048b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801048bb:	85 c0                	test   %eax,%eax
801048bd:	74 eb                	je     801048aa <popcli+0x2a>
  asm volatile("sti");
801048bf:	fb                   	sti    
}
801048c0:	c9                   	leave  
801048c1:	c3                   	ret    
    panic("popcli - interruptible");
801048c2:	83 ec 0c             	sub    $0xc,%esp
801048c5:	68 df 7b 10 80       	push   $0x80107bdf
801048ca:	e8 c1 ba ff ff       	call   80100390 <panic>
    panic("popcli");
801048cf:	83 ec 0c             	sub    $0xc,%esp
801048d2:	68 f6 7b 10 80       	push   $0x80107bf6
801048d7:	e8 b4 ba ff ff       	call   80100390 <panic>
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048e0 <release>:
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801048e8:	8b 03                	mov    (%ebx),%eax
801048ea:	85 c0                	test   %eax,%eax
801048ec:	74 0c                	je     801048fa <release+0x1a>
801048ee:	8b 73 08             	mov    0x8(%ebx),%esi
801048f1:	e8 aa f2 ff ff       	call   80103ba0 <mycpu>
801048f6:	39 c6                	cmp    %eax,%esi
801048f8:	74 16                	je     80104910 <release+0x30>
    panic("release");
801048fa:	83 ec 0c             	sub    $0xc,%esp
801048fd:	68 fd 7b 10 80       	push   $0x80107bfd
80104902:	e8 89 ba ff ff       	call   80100390 <panic>
80104907:	89 f6                	mov    %esi,%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104910:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104917:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010491e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104923:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104929:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010492c:	5b                   	pop    %ebx
8010492d:	5e                   	pop    %esi
8010492e:	5d                   	pop    %ebp
  popcli();
8010492f:	e9 4c ff ff ff       	jmp    80104880 <popcli>
80104934:	66 90                	xchg   %ax,%ax
80104936:	66 90                	xchg   %ax,%ax
80104938:	66 90                	xchg   %ax,%ax
8010493a:	66 90                	xchg   %ax,%ax
8010493c:	66 90                	xchg   %ax,%ax
8010493e:	66 90                	xchg   %ax,%ax

80104940 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	53                   	push   %ebx
80104945:	8b 55 08             	mov    0x8(%ebp),%edx
80104948:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010494b:	f6 c2 03             	test   $0x3,%dl
8010494e:	75 05                	jne    80104955 <memset+0x15>
80104950:	f6 c1 03             	test   $0x3,%cl
80104953:	74 13                	je     80104968 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104955:	89 d7                	mov    %edx,%edi
80104957:	8b 45 0c             	mov    0xc(%ebp),%eax
8010495a:	fc                   	cld    
8010495b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010495d:	5b                   	pop    %ebx
8010495e:	89 d0                	mov    %edx,%eax
80104960:	5f                   	pop    %edi
80104961:	5d                   	pop    %ebp
80104962:	c3                   	ret    
80104963:	90                   	nop
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104968:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010496c:	c1 e9 02             	shr    $0x2,%ecx
8010496f:	89 f8                	mov    %edi,%eax
80104971:	89 fb                	mov    %edi,%ebx
80104973:	c1 e0 18             	shl    $0x18,%eax
80104976:	c1 e3 10             	shl    $0x10,%ebx
80104979:	09 d8                	or     %ebx,%eax
8010497b:	09 f8                	or     %edi,%eax
8010497d:	c1 e7 08             	shl    $0x8,%edi
80104980:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104982:	89 d7                	mov    %edx,%edi
80104984:	fc                   	cld    
80104985:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104987:	5b                   	pop    %ebx
80104988:	89 d0                	mov    %edx,%eax
8010498a:	5f                   	pop    %edi
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret    
8010498d:	8d 76 00             	lea    0x0(%esi),%esi

80104990 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	53                   	push   %ebx
80104996:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104999:	8b 75 08             	mov    0x8(%ebp),%esi
8010499c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010499f:	85 db                	test   %ebx,%ebx
801049a1:	74 29                	je     801049cc <memcmp+0x3c>
    if(*s1 != *s2)
801049a3:	0f b6 16             	movzbl (%esi),%edx
801049a6:	0f b6 0f             	movzbl (%edi),%ecx
801049a9:	38 d1                	cmp    %dl,%cl
801049ab:	75 2b                	jne    801049d8 <memcmp+0x48>
801049ad:	b8 01 00 00 00       	mov    $0x1,%eax
801049b2:	eb 14                	jmp    801049c8 <memcmp+0x38>
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049b8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801049bc:	83 c0 01             	add    $0x1,%eax
801049bf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801049c4:	38 ca                	cmp    %cl,%dl
801049c6:	75 10                	jne    801049d8 <memcmp+0x48>
  while(n-- > 0){
801049c8:	39 d8                	cmp    %ebx,%eax
801049ca:	75 ec                	jne    801049b8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801049cc:	5b                   	pop    %ebx
  return 0;
801049cd:	31 c0                	xor    %eax,%eax
}
801049cf:	5e                   	pop    %esi
801049d0:	5f                   	pop    %edi
801049d1:	5d                   	pop    %ebp
801049d2:	c3                   	ret    
801049d3:	90                   	nop
801049d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801049d8:	0f b6 c2             	movzbl %dl,%eax
}
801049db:	5b                   	pop    %ebx
      return *s1 - *s2;
801049dc:	29 c8                	sub    %ecx,%eax
}
801049de:	5e                   	pop    %esi
801049df:	5f                   	pop    %edi
801049e0:	5d                   	pop    %ebp
801049e1:	c3                   	ret    
801049e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	8b 45 08             	mov    0x8(%ebp),%eax
801049f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801049fb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049fe:	39 c3                	cmp    %eax,%ebx
80104a00:	73 26                	jae    80104a28 <memmove+0x38>
80104a02:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104a05:	39 c8                	cmp    %ecx,%eax
80104a07:	73 1f                	jae    80104a28 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104a09:	85 f6                	test   %esi,%esi
80104a0b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104a0e:	74 0f                	je     80104a1f <memmove+0x2f>
      *--d = *--s;
80104a10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104a17:	83 ea 01             	sub    $0x1,%edx
80104a1a:	83 fa ff             	cmp    $0xffffffff,%edx
80104a1d:	75 f1                	jne    80104a10 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a1f:	5b                   	pop    %ebx
80104a20:	5e                   	pop    %esi
80104a21:	5d                   	pop    %ebp
80104a22:	c3                   	ret    
80104a23:	90                   	nop
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104a28:	31 d2                	xor    %edx,%edx
80104a2a:	85 f6                	test   %esi,%esi
80104a2c:	74 f1                	je     80104a1f <memmove+0x2f>
80104a2e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104a30:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a37:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104a3a:	39 d6                	cmp    %edx,%esi
80104a3c:	75 f2                	jne    80104a30 <memmove+0x40>
}
80104a3e:	5b                   	pop    %ebx
80104a3f:	5e                   	pop    %esi
80104a40:	5d                   	pop    %ebp
80104a41:	c3                   	ret    
80104a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a53:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104a54:	eb 9a                	jmp    801049f0 <memmove>
80104a56:	8d 76 00             	lea    0x0(%esi),%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a60 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	57                   	push   %edi
80104a64:	56                   	push   %esi
80104a65:	8b 7d 10             	mov    0x10(%ebp),%edi
80104a68:	53                   	push   %ebx
80104a69:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104a6f:	85 ff                	test   %edi,%edi
80104a71:	74 2f                	je     80104aa2 <strncmp+0x42>
80104a73:	0f b6 01             	movzbl (%ecx),%eax
80104a76:	0f b6 1e             	movzbl (%esi),%ebx
80104a79:	84 c0                	test   %al,%al
80104a7b:	74 37                	je     80104ab4 <strncmp+0x54>
80104a7d:	38 c3                	cmp    %al,%bl
80104a7f:	75 33                	jne    80104ab4 <strncmp+0x54>
80104a81:	01 f7                	add    %esi,%edi
80104a83:	eb 13                	jmp    80104a98 <strncmp+0x38>
80104a85:	8d 76 00             	lea    0x0(%esi),%esi
80104a88:	0f b6 01             	movzbl (%ecx),%eax
80104a8b:	84 c0                	test   %al,%al
80104a8d:	74 21                	je     80104ab0 <strncmp+0x50>
80104a8f:	0f b6 1a             	movzbl (%edx),%ebx
80104a92:	89 d6                	mov    %edx,%esi
80104a94:	38 d8                	cmp    %bl,%al
80104a96:	75 1c                	jne    80104ab4 <strncmp+0x54>
    n--, p++, q++;
80104a98:	8d 56 01             	lea    0x1(%esi),%edx
80104a9b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a9e:	39 fa                	cmp    %edi,%edx
80104aa0:	75 e6                	jne    80104a88 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104aa2:	5b                   	pop    %ebx
    return 0;
80104aa3:	31 c0                	xor    %eax,%eax
}
80104aa5:	5e                   	pop    %esi
80104aa6:	5f                   	pop    %edi
80104aa7:	5d                   	pop    %ebp
80104aa8:	c3                   	ret    
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104ab4:	29 d8                	sub    %ebx,%eax
}
80104ab6:	5b                   	pop    %ebx
80104ab7:	5e                   	pop    %esi
80104ab8:	5f                   	pop    %edi
80104ab9:	5d                   	pop    %ebp
80104aba:	c3                   	ret    
80104abb:	90                   	nop
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ac8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104acb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ace:	89 c2                	mov    %eax,%edx
80104ad0:	eb 19                	jmp    80104aeb <strncpy+0x2b>
80104ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ad8:	83 c3 01             	add    $0x1,%ebx
80104adb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104adf:	83 c2 01             	add    $0x1,%edx
80104ae2:	84 c9                	test   %cl,%cl
80104ae4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ae7:	74 09                	je     80104af2 <strncpy+0x32>
80104ae9:	89 f1                	mov    %esi,%ecx
80104aeb:	85 c9                	test   %ecx,%ecx
80104aed:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104af0:	7f e6                	jg     80104ad8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104af2:	31 c9                	xor    %ecx,%ecx
80104af4:	85 f6                	test   %esi,%esi
80104af6:	7e 17                	jle    80104b0f <strncpy+0x4f>
80104af8:	90                   	nop
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b00:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104b04:	89 f3                	mov    %esi,%ebx
80104b06:	83 c1 01             	add    $0x1,%ecx
80104b09:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104b0b:	85 db                	test   %ebx,%ebx
80104b0d:	7f f1                	jg     80104b00 <strncpy+0x40>
  return os;
}
80104b0f:	5b                   	pop    %ebx
80104b10:	5e                   	pop    %esi
80104b11:	5d                   	pop    %ebp
80104b12:	c3                   	ret    
80104b13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b28:	8b 45 08             	mov    0x8(%ebp),%eax
80104b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b2e:	85 c9                	test   %ecx,%ecx
80104b30:	7e 26                	jle    80104b58 <safestrcpy+0x38>
80104b32:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b36:	89 c1                	mov    %eax,%ecx
80104b38:	eb 17                	jmp    80104b51 <safestrcpy+0x31>
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b40:	83 c2 01             	add    $0x1,%edx
80104b43:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b47:	83 c1 01             	add    $0x1,%ecx
80104b4a:	84 db                	test   %bl,%bl
80104b4c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b4f:	74 04                	je     80104b55 <safestrcpy+0x35>
80104b51:	39 f2                	cmp    %esi,%edx
80104b53:	75 eb                	jne    80104b40 <safestrcpy+0x20>
    ;
  *s = 0;
80104b55:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b58:	5b                   	pop    %ebx
80104b59:	5e                   	pop    %esi
80104b5a:	5d                   	pop    %ebp
80104b5b:	c3                   	ret    
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b60 <strlen>:

int
strlen(const char *s)
{
80104b60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b61:	31 c0                	xor    %eax,%eax
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b68:	80 3a 00             	cmpb   $0x0,(%edx)
80104b6b:	74 0c                	je     80104b79 <strlen+0x19>
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
80104b70:	83 c0 01             	add    $0x1,%eax
80104b73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b77:	75 f7                	jne    80104b70 <strlen+0x10>
    ;
  return n;
}
80104b79:	5d                   	pop    %ebp
80104b7a:	c3                   	ret    

80104b7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104b83:	55                   	push   %ebp
  pushl %ebx
80104b84:	53                   	push   %ebx
  pushl %esi
80104b85:	56                   	push   %esi
  pushl %edi
80104b86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b89:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104b8b:	5f                   	pop    %edi
  popl %esi
80104b8c:	5e                   	pop    %esi
  popl %ebx
80104b8d:	5b                   	pop    %ebx
  popl %ebp
80104b8e:	5d                   	pop    %ebp
  ret
80104b8f:	c3                   	ret    

80104b90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	83 ec 04             	sub    $0x4,%esp
80104b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b9a:	e8 a1 f0 ff ff       	call   80103c40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b9f:	8b 00                	mov    (%eax),%eax
80104ba1:	39 d8                	cmp    %ebx,%eax
80104ba3:	76 1b                	jbe    80104bc0 <fetchint+0x30>
80104ba5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ba8:	39 d0                	cmp    %edx,%eax
80104baa:	72 14                	jb     80104bc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104baf:	8b 13                	mov    (%ebx),%edx
80104bb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bb3:	31 c0                	xor    %eax,%eax
}
80104bb5:	83 c4 04             	add    $0x4,%esp
80104bb8:	5b                   	pop    %ebx
80104bb9:	5d                   	pop    %ebp
80104bba:	c3                   	ret    
80104bbb:	90                   	nop
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc5:	eb ee                	jmp    80104bb5 <fetchint+0x25>
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 04             	sub    $0x4,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bda:	e8 61 f0 ff ff       	call   80103c40 <myproc>

  if(addr >= curproc->sz)
80104bdf:	39 18                	cmp    %ebx,(%eax)
80104be1:	76 29                	jbe    80104c0c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104be3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104be6:	89 da                	mov    %ebx,%edx
80104be8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104bea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104bec:	39 c3                	cmp    %eax,%ebx
80104bee:	73 1c                	jae    80104c0c <fetchstr+0x3c>
    if(*s == 0)
80104bf0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104bf3:	75 10                	jne    80104c05 <fetchstr+0x35>
80104bf5:	eb 39                	jmp    80104c30 <fetchstr+0x60>
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c00:	80 3a 00             	cmpb   $0x0,(%edx)
80104c03:	74 1b                	je     80104c20 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104c05:	83 c2 01             	add    $0x1,%edx
80104c08:	39 d0                	cmp    %edx,%eax
80104c0a:	77 f4                	ja     80104c00 <fetchstr+0x30>
    return -1;
80104c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104c11:	83 c4 04             	add    $0x4,%esp
80104c14:	5b                   	pop    %ebx
80104c15:	5d                   	pop    %ebp
80104c16:	c3                   	ret    
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c20:	83 c4 04             	add    $0x4,%esp
80104c23:	89 d0                	mov    %edx,%eax
80104c25:	29 d8                	sub    %ebx,%eax
80104c27:	5b                   	pop    %ebx
80104c28:	5d                   	pop    %ebp
80104c29:	c3                   	ret    
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c30:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c32:	eb dd                	jmp    80104c11 <fetchstr+0x41>
80104c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c45:	e8 f6 ef ff ff       	call   80103c40 <myproc>
80104c4a:	8b 40 18             	mov    0x18(%eax),%eax
80104c4d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c50:	8b 40 44             	mov    0x44(%eax),%eax
80104c53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c56:	e8 e5 ef ff ff       	call   80103c40 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c5b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c5d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c60:	39 c6                	cmp    %eax,%esi
80104c62:	73 1c                	jae    80104c80 <argint+0x40>
80104c64:	8d 53 08             	lea    0x8(%ebx),%edx
80104c67:	39 d0                	cmp    %edx,%eax
80104c69:	72 15                	jb     80104c80 <argint+0x40>
  *ip = *(int*)(addr);
80104c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c6e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c71:	89 10                	mov    %edx,(%eax)
  return 0;
80104c73:	31 c0                	xor    %eax,%eax
}
80104c75:	5b                   	pop    %ebx
80104c76:	5e                   	pop    %esi
80104c77:	5d                   	pop    %ebp
80104c78:	c3                   	ret    
80104c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c85:	eb ee                	jmp    80104c75 <argint+0x35>
80104c87:	89 f6                	mov    %esi,%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	83 ec 10             	sub    $0x10,%esp
80104c98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c9b:	e8 a0 ef ff ff       	call   80103c40 <myproc>
80104ca0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ca2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ca5:	83 ec 08             	sub    $0x8,%esp
80104ca8:	50                   	push   %eax
80104ca9:	ff 75 08             	pushl  0x8(%ebp)
80104cac:	e8 8f ff ff ff       	call   80104c40 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cb1:	83 c4 10             	add    $0x10,%esp
80104cb4:	85 c0                	test   %eax,%eax
80104cb6:	78 28                	js     80104ce0 <argptr+0x50>
80104cb8:	85 db                	test   %ebx,%ebx
80104cba:	78 24                	js     80104ce0 <argptr+0x50>
80104cbc:	8b 16                	mov    (%esi),%edx
80104cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc1:	39 c2                	cmp    %eax,%edx
80104cc3:	76 1b                	jbe    80104ce0 <argptr+0x50>
80104cc5:	01 c3                	add    %eax,%ebx
80104cc7:	39 da                	cmp    %ebx,%edx
80104cc9:	72 15                	jb     80104ce0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cce:	89 02                	mov    %eax,(%edx)
  return 0;
80104cd0:	31 c0                	xor    %eax,%eax
}
80104cd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cd5:	5b                   	pop    %ebx
80104cd6:	5e                   	pop    %esi
80104cd7:	5d                   	pop    %ebp
80104cd8:	c3                   	ret    
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce5:	eb eb                	jmp    80104cd2 <argptr+0x42>
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104cf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cf9:	50                   	push   %eax
80104cfa:	ff 75 08             	pushl  0x8(%ebp)
80104cfd:	e8 3e ff ff ff       	call   80104c40 <argint>
80104d02:	83 c4 10             	add    $0x10,%esp
80104d05:	85 c0                	test   %eax,%eax
80104d07:	78 17                	js     80104d20 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104d09:	83 ec 08             	sub    $0x8,%esp
80104d0c:	ff 75 0c             	pushl  0xc(%ebp)
80104d0f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d12:	e8 b9 fe ff ff       	call   80104bd0 <fetchstr>
80104d17:	83 c4 10             	add    $0x10,%esp
}
80104d1a:	c9                   	leave  
80104d1b:	c3                   	ret    
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d25:	c9                   	leave  
80104d26:	c3                   	ret    
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	53                   	push   %ebx
80104d34:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d37:	e8 04 ef ff ff       	call   80103c40 <myproc>
80104d3c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d3e:	8b 40 18             	mov    0x18(%eax),%eax
80104d41:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d44:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d47:	83 fa 15             	cmp    $0x15,%edx
80104d4a:	77 1c                	ja     80104d68 <syscall+0x38>
80104d4c:	8b 14 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%edx
80104d53:	85 d2                	test   %edx,%edx
80104d55:	74 11                	je     80104d68 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d57:	ff d2                	call   *%edx
80104d59:	8b 53 18             	mov    0x18(%ebx),%edx
80104d5c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d62:	c9                   	leave  
80104d63:	c3                   	ret    
80104d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d68:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d69:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d6c:	50                   	push   %eax
80104d6d:	ff 73 10             	pushl  0x10(%ebx)
80104d70:	68 05 7c 10 80       	push   $0x80107c05
80104d75:	e8 e6 b8 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104d7a:	8b 43 18             	mov    0x18(%ebx),%eax
80104d7d:	83 c4 10             	add    $0x10,%esp
80104d80:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d8a:	c9                   	leave  
80104d8b:	c3                   	ret    
80104d8c:	66 90                	xchg   %ax,%ax
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	53                   	push   %ebx
80104d95:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104d97:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d9a:	89 d6                	mov    %edx,%esi
80104d9c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d9f:	50                   	push   %eax
80104da0:	6a 00                	push   $0x0
80104da2:	e8 99 fe ff ff       	call   80104c40 <argint>
80104da7:	83 c4 10             	add    $0x10,%esp
80104daa:	85 c0                	test   %eax,%eax
80104dac:	78 2a                	js     80104dd8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104db2:	77 24                	ja     80104dd8 <argfd.constprop.0+0x48>
80104db4:	e8 87 ee ff ff       	call   80103c40 <myproc>
80104db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dbc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	74 14                	je     80104dd8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80104dc4:	85 db                	test   %ebx,%ebx
80104dc6:	74 02                	je     80104dca <argfd.constprop.0+0x3a>
    *pfd = fd;
80104dc8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
80104dca:	89 06                	mov    %eax,(%esi)
  return 0;
80104dcc:	31 c0                	xor    %eax,%eax
}
80104dce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd1:	5b                   	pop    %ebx
80104dd2:	5e                   	pop    %esi
80104dd3:	5d                   	pop    %ebp
80104dd4:	c3                   	ret    
80104dd5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ddd:	eb ef                	jmp    80104dce <argfd.constprop.0+0x3e>
80104ddf:	90                   	nop

80104de0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104de0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104de1:	31 c0                	xor    %eax,%eax
{
80104de3:	89 e5                	mov    %esp,%ebp
80104de5:	56                   	push   %esi
80104de6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104de7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104dea:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104ded:	e8 9e ff ff ff       	call   80104d90 <argfd.constprop.0>
80104df2:	85 c0                	test   %eax,%eax
80104df4:	78 42                	js     80104e38 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104df6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104df9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104dfb:	e8 40 ee ff ff       	call   80103c40 <myproc>
80104e00:	eb 0e                	jmp    80104e10 <sys_dup+0x30>
80104e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e08:	83 c3 01             	add    $0x1,%ebx
80104e0b:	83 fb 10             	cmp    $0x10,%ebx
80104e0e:	74 28                	je     80104e38 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104e10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e14:	85 d2                	test   %edx,%edx
80104e16:	75 f0                	jne    80104e08 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104e18:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
80104e1c:	83 ec 0c             	sub    $0xc,%esp
80104e1f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e22:	e8 c9 bf ff ff       	call   80100df0 <filedup>
  return fd;
80104e27:	83 c4 10             	add    $0x10,%esp
}
80104e2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e2d:	89 d8                	mov    %ebx,%eax
80104e2f:	5b                   	pop    %ebx
80104e30:	5e                   	pop    %esi
80104e31:	5d                   	pop    %ebp
80104e32:	c3                   	ret    
80104e33:	90                   	nop
80104e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e38:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e40:	89 d8                	mov    %ebx,%eax
80104e42:	5b                   	pop    %ebx
80104e43:	5e                   	pop    %esi
80104e44:	5d                   	pop    %ebp
80104e45:	c3                   	ret    
80104e46:	8d 76 00             	lea    0x0(%esi),%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e50 <sys_read>:

int
sys_read(void)
{
80104e50:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e51:	31 c0                	xor    %eax,%eax
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e5b:	e8 30 ff ff ff       	call   80104d90 <argfd.constprop.0>
80104e60:	85 c0                	test   %eax,%eax
80104e62:	78 4c                	js     80104eb0 <sys_read+0x60>
80104e64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e67:	83 ec 08             	sub    $0x8,%esp
80104e6a:	50                   	push   %eax
80104e6b:	6a 02                	push   $0x2
80104e6d:	e8 ce fd ff ff       	call   80104c40 <argint>
80104e72:	83 c4 10             	add    $0x10,%esp
80104e75:	85 c0                	test   %eax,%eax
80104e77:	78 37                	js     80104eb0 <sys_read+0x60>
80104e79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e7c:	83 ec 04             	sub    $0x4,%esp
80104e7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e82:	50                   	push   %eax
80104e83:	6a 01                	push   $0x1
80104e85:	e8 06 fe ff ff       	call   80104c90 <argptr>
80104e8a:	83 c4 10             	add    $0x10,%esp
80104e8d:	85 c0                	test   %eax,%eax
80104e8f:	78 1f                	js     80104eb0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104e91:	83 ec 04             	sub    $0x4,%esp
80104e94:	ff 75 f0             	pushl  -0x10(%ebp)
80104e97:	ff 75 f4             	pushl  -0xc(%ebp)
80104e9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e9d:	e8 be c0 ff ff       	call   80100f60 <fileread>
80104ea2:	83 c4 10             	add    $0x10,%esp
}
80104ea5:	c9                   	leave  
80104ea6:	c3                   	ret    
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <sys_write>:

int
sys_write(void)
{
80104ec0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ec1:	31 c0                	xor    %eax,%eax
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ec8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ecb:	e8 c0 fe ff ff       	call   80104d90 <argfd.constprop.0>
80104ed0:	85 c0                	test   %eax,%eax
80104ed2:	78 4c                	js     80104f20 <sys_write+0x60>
80104ed4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ed7:	83 ec 08             	sub    $0x8,%esp
80104eda:	50                   	push   %eax
80104edb:	6a 02                	push   $0x2
80104edd:	e8 5e fd ff ff       	call   80104c40 <argint>
80104ee2:	83 c4 10             	add    $0x10,%esp
80104ee5:	85 c0                	test   %eax,%eax
80104ee7:	78 37                	js     80104f20 <sys_write+0x60>
80104ee9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eec:	83 ec 04             	sub    $0x4,%esp
80104eef:	ff 75 f0             	pushl  -0x10(%ebp)
80104ef2:	50                   	push   %eax
80104ef3:	6a 01                	push   $0x1
80104ef5:	e8 96 fd ff ff       	call   80104c90 <argptr>
80104efa:	83 c4 10             	add    $0x10,%esp
80104efd:	85 c0                	test   %eax,%eax
80104eff:	78 1f                	js     80104f20 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104f01:	83 ec 04             	sub    $0x4,%esp
80104f04:	ff 75 f0             	pushl  -0x10(%ebp)
80104f07:	ff 75 f4             	pushl  -0xc(%ebp)
80104f0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f0d:	e8 de c0 ff ff       	call   80100ff0 <filewrite>
80104f12:	83 c4 10             	add    $0x10,%esp
}
80104f15:	c9                   	leave  
80104f16:	c3                   	ret    
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f25:	c9                   	leave  
80104f26:	c3                   	ret    
80104f27:	89 f6                	mov    %esi,%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f30 <sys_close>:

int
sys_close(void)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104f36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f3c:	e8 4f fe ff ff       	call   80104d90 <argfd.constprop.0>
80104f41:	85 c0                	test   %eax,%eax
80104f43:	78 2b                	js     80104f70 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104f45:	e8 f6 ec ff ff       	call   80103c40 <myproc>
80104f4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f4d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f50:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f57:	00 
  fileclose(f);
80104f58:	ff 75 f4             	pushl  -0xc(%ebp)
80104f5b:	e8 e0 be ff ff       	call   80100e40 <fileclose>
  return 0;
80104f60:	83 c4 10             	add    $0x10,%esp
80104f63:	31 c0                	xor    %eax,%eax
}
80104f65:	c9                   	leave  
80104f66:	c3                   	ret    
80104f67:	89 f6                	mov    %esi,%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f75:	c9                   	leave  
80104f76:	c3                   	ret    
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f80 <sys_fstat>:

int
sys_fstat(void)
{
80104f80:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f81:	31 c0                	xor    %eax,%eax
{
80104f83:	89 e5                	mov    %esp,%ebp
80104f85:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f8b:	e8 00 fe ff ff       	call   80104d90 <argfd.constprop.0>
80104f90:	85 c0                	test   %eax,%eax
80104f92:	78 2c                	js     80104fc0 <sys_fstat+0x40>
80104f94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f97:	83 ec 04             	sub    $0x4,%esp
80104f9a:	6a 14                	push   $0x14
80104f9c:	50                   	push   %eax
80104f9d:	6a 01                	push   $0x1
80104f9f:	e8 ec fc ff ff       	call   80104c90 <argptr>
80104fa4:	83 c4 10             	add    $0x10,%esp
80104fa7:	85 c0                	test   %eax,%eax
80104fa9:	78 15                	js     80104fc0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104fab:	83 ec 08             	sub    $0x8,%esp
80104fae:	ff 75 f4             	pushl  -0xc(%ebp)
80104fb1:	ff 75 f0             	pushl  -0x10(%ebp)
80104fb4:	e8 57 bf ff ff       	call   80100f10 <filestat>
80104fb9:	83 c4 10             	add    $0x10,%esp
}
80104fbc:	c9                   	leave  
80104fbd:	c3                   	ret    
80104fbe:	66 90                	xchg   %ax,%ax
    return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fc5:	c9                   	leave  
80104fc6:	c3                   	ret    
80104fc7:	89 f6                	mov    %esi,%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fd0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	57                   	push   %edi
80104fd4:	56                   	push   %esi
80104fd5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fd6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104fd9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fdc:	50                   	push   %eax
80104fdd:	6a 00                	push   $0x0
80104fdf:	e8 0c fd ff ff       	call   80104cf0 <argstr>
80104fe4:	83 c4 10             	add    $0x10,%esp
80104fe7:	85 c0                	test   %eax,%eax
80104fe9:	0f 88 fb 00 00 00    	js     801050ea <sys_link+0x11a>
80104fef:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ff2:	83 ec 08             	sub    $0x8,%esp
80104ff5:	50                   	push   %eax
80104ff6:	6a 01                	push   $0x1
80104ff8:	e8 f3 fc ff ff       	call   80104cf0 <argstr>
80104ffd:	83 c4 10             	add    $0x10,%esp
80105000:	85 c0                	test   %eax,%eax
80105002:	0f 88 e2 00 00 00    	js     801050ea <sys_link+0x11a>
    return -1;

  begin_op();
80105008:	e8 d3 df ff ff       	call   80102fe0 <begin_op>
  if((ip = namei(old)) == 0){
8010500d:	83 ec 0c             	sub    $0xc,%esp
80105010:	ff 75 d4             	pushl  -0x2c(%ebp)
80105013:	e8 d8 ce ff ff       	call   80101ef0 <namei>
80105018:	83 c4 10             	add    $0x10,%esp
8010501b:	85 c0                	test   %eax,%eax
8010501d:	89 c3                	mov    %eax,%ebx
8010501f:	0f 84 ea 00 00 00    	je     8010510f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105025:	83 ec 0c             	sub    $0xc,%esp
80105028:	50                   	push   %eax
80105029:	e8 62 c6 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
8010502e:	83 c4 10             	add    $0x10,%esp
80105031:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105036:	0f 84 bb 00 00 00    	je     801050f7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010503c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105041:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105044:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105047:	53                   	push   %ebx
80105048:	e8 93 c5 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
8010504d:	89 1c 24             	mov    %ebx,(%esp)
80105050:	e8 1b c7 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105055:	58                   	pop    %eax
80105056:	5a                   	pop    %edx
80105057:	57                   	push   %edi
80105058:	ff 75 d0             	pushl  -0x30(%ebp)
8010505b:	e8 b0 ce ff ff       	call   80101f10 <nameiparent>
80105060:	83 c4 10             	add    $0x10,%esp
80105063:	85 c0                	test   %eax,%eax
80105065:	89 c6                	mov    %eax,%esi
80105067:	74 5b                	je     801050c4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105069:	83 ec 0c             	sub    $0xc,%esp
8010506c:	50                   	push   %eax
8010506d:	e8 1e c6 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	8b 03                	mov    (%ebx),%eax
80105077:	39 06                	cmp    %eax,(%esi)
80105079:	75 3d                	jne    801050b8 <sys_link+0xe8>
8010507b:	83 ec 04             	sub    $0x4,%esp
8010507e:	ff 73 04             	pushl  0x4(%ebx)
80105081:	57                   	push   %edi
80105082:	56                   	push   %esi
80105083:	e8 a8 cd ff ff       	call   80101e30 <dirlink>
80105088:	83 c4 10             	add    $0x10,%esp
8010508b:	85 c0                	test   %eax,%eax
8010508d:	78 29                	js     801050b8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010508f:	83 ec 0c             	sub    $0xc,%esp
80105092:	56                   	push   %esi
80105093:	e8 88 c8 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105098:	89 1c 24             	mov    %ebx,(%esp)
8010509b:	e8 20 c7 ff ff       	call   801017c0 <iput>

  end_op();
801050a0:	e8 ab df ff ff       	call   80103050 <end_op>

  return 0;
801050a5:	83 c4 10             	add    $0x10,%esp
801050a8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801050aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050ad:	5b                   	pop    %ebx
801050ae:	5e                   	pop    %esi
801050af:	5f                   	pop    %edi
801050b0:	5d                   	pop    %ebp
801050b1:	c3                   	ret    
801050b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801050b8:	83 ec 0c             	sub    $0xc,%esp
801050bb:	56                   	push   %esi
801050bc:	e8 5f c8 ff ff       	call   80101920 <iunlockput>
    goto bad;
801050c1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050c4:	83 ec 0c             	sub    $0xc,%esp
801050c7:	53                   	push   %ebx
801050c8:	e8 c3 c5 ff ff       	call   80101690 <ilock>
  ip->nlink--;
801050cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050d2:	89 1c 24             	mov    %ebx,(%esp)
801050d5:	e8 06 c5 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
801050da:	89 1c 24             	mov    %ebx,(%esp)
801050dd:	e8 3e c8 ff ff       	call   80101920 <iunlockput>
  end_op();
801050e2:	e8 69 df ff ff       	call   80103050 <end_op>
  return -1;
801050e7:	83 c4 10             	add    $0x10,%esp
}
801050ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801050ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f2:	5b                   	pop    %ebx
801050f3:	5e                   	pop    %esi
801050f4:	5f                   	pop    %edi
801050f5:	5d                   	pop    %ebp
801050f6:	c3                   	ret    
    iunlockput(ip);
801050f7:	83 ec 0c             	sub    $0xc,%esp
801050fa:	53                   	push   %ebx
801050fb:	e8 20 c8 ff ff       	call   80101920 <iunlockput>
    end_op();
80105100:	e8 4b df ff ff       	call   80103050 <end_op>
    return -1;
80105105:	83 c4 10             	add    $0x10,%esp
80105108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510d:	eb 9b                	jmp    801050aa <sys_link+0xda>
    end_op();
8010510f:	e8 3c df ff ff       	call   80103050 <end_op>
    return -1;
80105114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105119:	eb 8f                	jmp    801050aa <sys_link+0xda>
8010511b:	90                   	nop
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
80105125:	53                   	push   %ebx
80105126:	83 ec 1c             	sub    $0x1c,%esp
80105129:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010512c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105130:	76 3e                	jbe    80105170 <isdirempty+0x50>
80105132:	bb 20 00 00 00       	mov    $0x20,%ebx
80105137:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010513a:	eb 0c                	jmp    80105148 <isdirempty+0x28>
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105140:	83 c3 10             	add    $0x10,%ebx
80105143:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105146:	73 28                	jae    80105170 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105148:	6a 10                	push   $0x10
8010514a:	53                   	push   %ebx
8010514b:	57                   	push   %edi
8010514c:	56                   	push   %esi
8010514d:	e8 1e c8 ff ff       	call   80101970 <readi>
80105152:	83 c4 10             	add    $0x10,%esp
80105155:	83 f8 10             	cmp    $0x10,%eax
80105158:	75 23                	jne    8010517d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010515a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010515f:	74 df                	je     80105140 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105161:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105164:	31 c0                	xor    %eax,%eax
}
80105166:	5b                   	pop    %ebx
80105167:	5e                   	pop    %esi
80105168:	5f                   	pop    %edi
80105169:	5d                   	pop    %ebp
8010516a:	c3                   	ret    
8010516b:	90                   	nop
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105170:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105173:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105178:	5b                   	pop    %ebx
80105179:	5e                   	pop    %esi
8010517a:	5f                   	pop    %edi
8010517b:	5d                   	pop    %ebp
8010517c:	c3                   	ret    
      panic("isdirempty: readi");
8010517d:	83 ec 0c             	sub    $0xc,%esp
80105180:	68 9c 7c 10 80       	push   $0x80107c9c
80105185:	e8 06 b2 ff ff       	call   80100390 <panic>
8010518a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105190 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105196:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105199:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010519c:	50                   	push   %eax
8010519d:	6a 00                	push   $0x0
8010519f:	e8 4c fb ff ff       	call   80104cf0 <argstr>
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	85 c0                	test   %eax,%eax
801051a9:	0f 88 51 01 00 00    	js     80105300 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801051af:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801051b2:	e8 29 de ff ff       	call   80102fe0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051b7:	83 ec 08             	sub    $0x8,%esp
801051ba:	53                   	push   %ebx
801051bb:	ff 75 c0             	pushl  -0x40(%ebp)
801051be:	e8 4d cd ff ff       	call   80101f10 <nameiparent>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	85 c0                	test   %eax,%eax
801051c8:	89 c6                	mov    %eax,%esi
801051ca:	0f 84 37 01 00 00    	je     80105307 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	50                   	push   %eax
801051d4:	e8 b7 c4 ff ff       	call   80101690 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051d9:	58                   	pop    %eax
801051da:	5a                   	pop    %edx
801051db:	68 3d 76 10 80       	push   $0x8010763d
801051e0:	53                   	push   %ebx
801051e1:	e8 ba c9 ff ff       	call   80101ba0 <namecmp>
801051e6:	83 c4 10             	add    $0x10,%esp
801051e9:	85 c0                	test   %eax,%eax
801051eb:	0f 84 d7 00 00 00    	je     801052c8 <sys_unlink+0x138>
801051f1:	83 ec 08             	sub    $0x8,%esp
801051f4:	68 3c 76 10 80       	push   $0x8010763c
801051f9:	53                   	push   %ebx
801051fa:	e8 a1 c9 ff ff       	call   80101ba0 <namecmp>
801051ff:	83 c4 10             	add    $0x10,%esp
80105202:	85 c0                	test   %eax,%eax
80105204:	0f 84 be 00 00 00    	je     801052c8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010520a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010520d:	83 ec 04             	sub    $0x4,%esp
80105210:	50                   	push   %eax
80105211:	53                   	push   %ebx
80105212:	56                   	push   %esi
80105213:	e8 a8 c9 ff ff       	call   80101bc0 <dirlookup>
80105218:	83 c4 10             	add    $0x10,%esp
8010521b:	85 c0                	test   %eax,%eax
8010521d:	89 c3                	mov    %eax,%ebx
8010521f:	0f 84 a3 00 00 00    	je     801052c8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105225:	83 ec 0c             	sub    $0xc,%esp
80105228:	50                   	push   %eax
80105229:	e8 62 c4 ff ff       	call   80101690 <ilock>

  if(ip->nlink < 1)
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105236:	0f 8e e4 00 00 00    	jle    80105320 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010523c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105241:	74 65                	je     801052a8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105243:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105246:	83 ec 04             	sub    $0x4,%esp
80105249:	6a 10                	push   $0x10
8010524b:	6a 00                	push   $0x0
8010524d:	57                   	push   %edi
8010524e:	e8 ed f6 ff ff       	call   80104940 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105253:	6a 10                	push   $0x10
80105255:	ff 75 c4             	pushl  -0x3c(%ebp)
80105258:	57                   	push   %edi
80105259:	56                   	push   %esi
8010525a:	e8 11 c8 ff ff       	call   80101a70 <writei>
8010525f:	83 c4 20             	add    $0x20,%esp
80105262:	83 f8 10             	cmp    $0x10,%eax
80105265:	0f 85 a8 00 00 00    	jne    80105313 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010526b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105270:	74 6e                	je     801052e0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105272:	83 ec 0c             	sub    $0xc,%esp
80105275:	56                   	push   %esi
80105276:	e8 a5 c6 ff ff       	call   80101920 <iunlockput>

  ip->nlink--;
8010527b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105280:	89 1c 24             	mov    %ebx,(%esp)
80105283:	e8 58 c3 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80105288:	89 1c 24             	mov    %ebx,(%esp)
8010528b:	e8 90 c6 ff ff       	call   80101920 <iunlockput>

  end_op();
80105290:	e8 bb dd ff ff       	call   80103050 <end_op>

  return 0;
80105295:	83 c4 10             	add    $0x10,%esp
80105298:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010529a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010529d:	5b                   	pop    %ebx
8010529e:	5e                   	pop    %esi
8010529f:	5f                   	pop    %edi
801052a0:	5d                   	pop    %ebp
801052a1:	c3                   	ret    
801052a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801052a8:	83 ec 0c             	sub    $0xc,%esp
801052ab:	53                   	push   %ebx
801052ac:	e8 6f fe ff ff       	call   80105120 <isdirempty>
801052b1:	83 c4 10             	add    $0x10,%esp
801052b4:	85 c0                	test   %eax,%eax
801052b6:	75 8b                	jne    80105243 <sys_unlink+0xb3>
    iunlockput(ip);
801052b8:	83 ec 0c             	sub    $0xc,%esp
801052bb:	53                   	push   %ebx
801052bc:	e8 5f c6 ff ff       	call   80101920 <iunlockput>
    goto bad;
801052c1:	83 c4 10             	add    $0x10,%esp
801052c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801052c8:	83 ec 0c             	sub    $0xc,%esp
801052cb:	56                   	push   %esi
801052cc:	e8 4f c6 ff ff       	call   80101920 <iunlockput>
  end_op();
801052d1:	e8 7a dd ff ff       	call   80103050 <end_op>
  return -1;
801052d6:	83 c4 10             	add    $0x10,%esp
801052d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052de:	eb ba                	jmp    8010529a <sys_unlink+0x10a>
    dp->nlink--;
801052e0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801052e5:	83 ec 0c             	sub    $0xc,%esp
801052e8:	56                   	push   %esi
801052e9:	e8 f2 c2 ff ff       	call   801015e0 <iupdate>
801052ee:	83 c4 10             	add    $0x10,%esp
801052f1:	e9 7c ff ff ff       	jmp    80105272 <sys_unlink+0xe2>
801052f6:	8d 76 00             	lea    0x0(%esi),%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105305:	eb 93                	jmp    8010529a <sys_unlink+0x10a>
    end_op();
80105307:	e8 44 dd ff ff       	call   80103050 <end_op>
    return -1;
8010530c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105311:	eb 87                	jmp    8010529a <sys_unlink+0x10a>
    panic("unlink: writei");
80105313:	83 ec 0c             	sub    $0xc,%esp
80105316:	68 51 76 10 80       	push   $0x80107651
8010531b:	e8 70 b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	68 3f 76 10 80       	push   $0x8010763f
80105328:	e8 63 b0 ff ff       	call   80100390 <panic>
8010532d:	8d 76 00             	lea    0x0(%esi),%esi

80105330 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
80105335:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105336:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105339:	83 ec 44             	sub    $0x44,%esp
8010533c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010533f:	8b 55 10             	mov    0x10(%ebp),%edx
80105342:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105345:	56                   	push   %esi
80105346:	ff 75 08             	pushl  0x8(%ebp)
{
80105349:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010534c:	89 55 c0             	mov    %edx,-0x40(%ebp)
8010534f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105352:	e8 b9 cb ff ff       	call   80101f10 <nameiparent>
80105357:	83 c4 10             	add    $0x10,%esp
8010535a:	85 c0                	test   %eax,%eax
8010535c:	0f 84 4e 01 00 00    	je     801054b0 <create+0x180>
    return 0;
  ilock(dp);
80105362:	83 ec 0c             	sub    $0xc,%esp
80105365:	89 c3                	mov    %eax,%ebx
80105367:	50                   	push   %eax
80105368:	e8 23 c3 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010536d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105370:	83 c4 0c             	add    $0xc,%esp
80105373:	50                   	push   %eax
80105374:	56                   	push   %esi
80105375:	53                   	push   %ebx
80105376:	e8 45 c8 ff ff       	call   80101bc0 <dirlookup>
8010537b:	83 c4 10             	add    $0x10,%esp
8010537e:	85 c0                	test   %eax,%eax
80105380:	89 c7                	mov    %eax,%edi
80105382:	74 3c                	je     801053c0 <create+0x90>
    iunlockput(dp);
80105384:	83 ec 0c             	sub    $0xc,%esp
80105387:	53                   	push   %ebx
80105388:	e8 93 c5 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
8010538d:	89 3c 24             	mov    %edi,(%esp)
80105390:	e8 fb c2 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105395:	83 c4 10             	add    $0x10,%esp
80105398:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010539d:	0f 85 9d 00 00 00    	jne    80105440 <create+0x110>
801053a3:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801053a8:	0f 85 92 00 00 00    	jne    80105440 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801053ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053b1:	89 f8                	mov    %edi,%eax
801053b3:	5b                   	pop    %ebx
801053b4:	5e                   	pop    %esi
801053b5:	5f                   	pop    %edi
801053b6:	5d                   	pop    %ebp
801053b7:	c3                   	ret    
801053b8:	90                   	nop
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801053c0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801053c4:	83 ec 08             	sub    $0x8,%esp
801053c7:	50                   	push   %eax
801053c8:	ff 33                	pushl  (%ebx)
801053ca:	e8 51 c1 ff ff       	call   80101520 <ialloc>
801053cf:	83 c4 10             	add    $0x10,%esp
801053d2:	85 c0                	test   %eax,%eax
801053d4:	89 c7                	mov    %eax,%edi
801053d6:	0f 84 e8 00 00 00    	je     801054c4 <create+0x194>
  ilock(ip);
801053dc:	83 ec 0c             	sub    $0xc,%esp
801053df:	50                   	push   %eax
801053e0:	e8 ab c2 ff ff       	call   80101690 <ilock>
  ip->major = major;
801053e5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801053e9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801053ed:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801053f1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801053f5:	b8 01 00 00 00       	mov    $0x1,%eax
801053fa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801053fe:	89 3c 24             	mov    %edi,(%esp)
80105401:	e8 da c1 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105406:	83 c4 10             	add    $0x10,%esp
80105409:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010540e:	74 50                	je     80105460 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105410:	83 ec 04             	sub    $0x4,%esp
80105413:	ff 77 04             	pushl  0x4(%edi)
80105416:	56                   	push   %esi
80105417:	53                   	push   %ebx
80105418:	e8 13 ca ff ff       	call   80101e30 <dirlink>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	0f 88 8f 00 00 00    	js     801054b7 <create+0x187>
  iunlockput(dp);
80105428:	83 ec 0c             	sub    $0xc,%esp
8010542b:	53                   	push   %ebx
8010542c:	e8 ef c4 ff ff       	call   80101920 <iunlockput>
  return ip;
80105431:	83 c4 10             	add    $0x10,%esp
}
80105434:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105437:	89 f8                	mov    %edi,%eax
80105439:	5b                   	pop    %ebx
8010543a:	5e                   	pop    %esi
8010543b:	5f                   	pop    %edi
8010543c:	5d                   	pop    %ebp
8010543d:	c3                   	ret    
8010543e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	57                   	push   %edi
    return 0;
80105444:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105446:	e8 d5 c4 ff ff       	call   80101920 <iunlockput>
    return 0;
8010544b:	83 c4 10             	add    $0x10,%esp
}
8010544e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105451:	89 f8                	mov    %edi,%eax
80105453:	5b                   	pop    %ebx
80105454:	5e                   	pop    %esi
80105455:	5f                   	pop    %edi
80105456:	5d                   	pop    %ebp
80105457:	c3                   	ret    
80105458:	90                   	nop
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105460:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105465:	83 ec 0c             	sub    $0xc,%esp
80105468:	53                   	push   %ebx
80105469:	e8 72 c1 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010546e:	83 c4 0c             	add    $0xc,%esp
80105471:	ff 77 04             	pushl  0x4(%edi)
80105474:	68 3d 76 10 80       	push   $0x8010763d
80105479:	57                   	push   %edi
8010547a:	e8 b1 c9 ff ff       	call   80101e30 <dirlink>
8010547f:	83 c4 10             	add    $0x10,%esp
80105482:	85 c0                	test   %eax,%eax
80105484:	78 1c                	js     801054a2 <create+0x172>
80105486:	83 ec 04             	sub    $0x4,%esp
80105489:	ff 73 04             	pushl  0x4(%ebx)
8010548c:	68 3c 76 10 80       	push   $0x8010763c
80105491:	57                   	push   %edi
80105492:	e8 99 c9 ff ff       	call   80101e30 <dirlink>
80105497:	83 c4 10             	add    $0x10,%esp
8010549a:	85 c0                	test   %eax,%eax
8010549c:	0f 89 6e ff ff ff    	jns    80105410 <create+0xe0>
      panic("create dots");
801054a2:	83 ec 0c             	sub    $0xc,%esp
801054a5:	68 bd 7c 10 80       	push   $0x80107cbd
801054aa:	e8 e1 ae ff ff       	call   80100390 <panic>
801054af:	90                   	nop
    return 0;
801054b0:	31 ff                	xor    %edi,%edi
801054b2:	e9 f7 fe ff ff       	jmp    801053ae <create+0x7e>
    panic("create: dirlink");
801054b7:	83 ec 0c             	sub    $0xc,%esp
801054ba:	68 c9 7c 10 80       	push   $0x80107cc9
801054bf:	e8 cc ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801054c4:	83 ec 0c             	sub    $0xc,%esp
801054c7:	68 ae 7c 10 80       	push   $0x80107cae
801054cc:	e8 bf ae ff ff       	call   80100390 <panic>
801054d1:	eb 0d                	jmp    801054e0 <sys_open>
801054d3:	90                   	nop
801054d4:	90                   	nop
801054d5:	90                   	nop
801054d6:	90                   	nop
801054d7:	90                   	nop
801054d8:	90                   	nop
801054d9:	90                   	nop
801054da:	90                   	nop
801054db:	90                   	nop
801054dc:	90                   	nop
801054dd:	90                   	nop
801054de:	90                   	nop
801054df:	90                   	nop

801054e0 <sys_open>:

int
sys_open(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
801054e5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054ec:	50                   	push   %eax
801054ed:	6a 00                	push   $0x0
801054ef:	e8 fc f7 ff ff       	call   80104cf0 <argstr>
801054f4:	83 c4 10             	add    $0x10,%esp
801054f7:	85 c0                	test   %eax,%eax
801054f9:	0f 88 1d 01 00 00    	js     8010561c <sys_open+0x13c>
801054ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105502:	83 ec 08             	sub    $0x8,%esp
80105505:	50                   	push   %eax
80105506:	6a 01                	push   $0x1
80105508:	e8 33 f7 ff ff       	call   80104c40 <argint>
8010550d:	83 c4 10             	add    $0x10,%esp
80105510:	85 c0                	test   %eax,%eax
80105512:	0f 88 04 01 00 00    	js     8010561c <sys_open+0x13c>
    return -1;

  begin_op();
80105518:	e8 c3 da ff ff       	call   80102fe0 <begin_op>

  if(omode & O_CREATE){
8010551d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105521:	0f 85 a9 00 00 00    	jne    801055d0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105527:	83 ec 0c             	sub    $0xc,%esp
8010552a:	ff 75 e0             	pushl  -0x20(%ebp)
8010552d:	e8 be c9 ff ff       	call   80101ef0 <namei>
80105532:	83 c4 10             	add    $0x10,%esp
80105535:	85 c0                	test   %eax,%eax
80105537:	89 c6                	mov    %eax,%esi
80105539:	0f 84 ac 00 00 00    	je     801055eb <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010553f:	83 ec 0c             	sub    $0xc,%esp
80105542:	50                   	push   %eax
80105543:	e8 48 c1 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105550:	0f 84 aa 00 00 00    	je     80105600 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105556:	e8 25 b8 ff ff       	call   80100d80 <filealloc>
8010555b:	85 c0                	test   %eax,%eax
8010555d:	89 c7                	mov    %eax,%edi
8010555f:	0f 84 a6 00 00 00    	je     8010560b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105565:	e8 d6 e6 ff ff       	call   80103c40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010556a:	31 db                	xor    %ebx,%ebx
8010556c:	eb 0e                	jmp    8010557c <sys_open+0x9c>
8010556e:	66 90                	xchg   %ax,%ax
80105570:	83 c3 01             	add    $0x1,%ebx
80105573:	83 fb 10             	cmp    $0x10,%ebx
80105576:	0f 84 ac 00 00 00    	je     80105628 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010557c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105580:	85 d2                	test   %edx,%edx
80105582:	75 ec                	jne    80105570 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105584:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105587:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010558b:	56                   	push   %esi
8010558c:	e8 df c1 ff ff       	call   80101770 <iunlock>
  end_op();
80105591:	e8 ba da ff ff       	call   80103050 <end_op>

  f->type = FD_INODE;
80105596:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010559c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010559f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055a2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801055a5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055ac:	89 d0                	mov    %edx,%eax
801055ae:	f7 d0                	not    %eax
801055b0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055b3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055b6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055b9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c0:	89 d8                	mov    %ebx,%eax
801055c2:	5b                   	pop    %ebx
801055c3:	5e                   	pop    %esi
801055c4:	5f                   	pop    %edi
801055c5:	5d                   	pop    %ebp
801055c6:	c3                   	ret    
801055c7:	89 f6                	mov    %esi,%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801055d0:	6a 00                	push   $0x0
801055d2:	6a 00                	push   $0x0
801055d4:	6a 02                	push   $0x2
801055d6:	ff 75 e0             	pushl  -0x20(%ebp)
801055d9:	e8 52 fd ff ff       	call   80105330 <create>
    if(ip == 0){
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801055e3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055e5:	0f 85 6b ff ff ff    	jne    80105556 <sys_open+0x76>
      end_op();
801055eb:	e8 60 da ff ff       	call   80103050 <end_op>
      return -1;
801055f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055f5:	eb c6                	jmp    801055bd <sys_open+0xdd>
801055f7:	89 f6                	mov    %esi,%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105600:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105603:	85 c9                	test   %ecx,%ecx
80105605:	0f 84 4b ff ff ff    	je     80105556 <sys_open+0x76>
    iunlockput(ip);
8010560b:	83 ec 0c             	sub    $0xc,%esp
8010560e:	56                   	push   %esi
8010560f:	e8 0c c3 ff ff       	call   80101920 <iunlockput>
    end_op();
80105614:	e8 37 da ff ff       	call   80103050 <end_op>
    return -1;
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105621:	eb 9a                	jmp    801055bd <sys_open+0xdd>
80105623:	90                   	nop
80105624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	57                   	push   %edi
8010562c:	e8 0f b8 ff ff       	call   80100e40 <fileclose>
80105631:	83 c4 10             	add    $0x10,%esp
80105634:	eb d5                	jmp    8010560b <sys_open+0x12b>
80105636:	8d 76 00             	lea    0x0(%esi),%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105640 <sys_mkdir>:

int
sys_mkdir(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105646:	e8 95 d9 ff ff       	call   80102fe0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010564b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010564e:	83 ec 08             	sub    $0x8,%esp
80105651:	50                   	push   %eax
80105652:	6a 00                	push   $0x0
80105654:	e8 97 f6 ff ff       	call   80104cf0 <argstr>
80105659:	83 c4 10             	add    $0x10,%esp
8010565c:	85 c0                	test   %eax,%eax
8010565e:	78 30                	js     80105690 <sys_mkdir+0x50>
80105660:	6a 00                	push   $0x0
80105662:	6a 00                	push   $0x0
80105664:	6a 01                	push   $0x1
80105666:	ff 75 f4             	pushl  -0xc(%ebp)
80105669:	e8 c2 fc ff ff       	call   80105330 <create>
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	85 c0                	test   %eax,%eax
80105673:	74 1b                	je     80105690 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105675:	83 ec 0c             	sub    $0xc,%esp
80105678:	50                   	push   %eax
80105679:	e8 a2 c2 ff ff       	call   80101920 <iunlockput>
  end_op();
8010567e:	e8 cd d9 ff ff       	call   80103050 <end_op>
  return 0;
80105683:	83 c4 10             	add    $0x10,%esp
80105686:	31 c0                	xor    %eax,%eax
}
80105688:	c9                   	leave  
80105689:	c3                   	ret    
8010568a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105690:	e8 bb d9 ff ff       	call   80103050 <end_op>
    return -1;
80105695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569a:	c9                   	leave  
8010569b:	c3                   	ret    
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_mknod>:

int
sys_mknod(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056a6:	e8 35 d9 ff ff       	call   80102fe0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056ae:	83 ec 08             	sub    $0x8,%esp
801056b1:	50                   	push   %eax
801056b2:	6a 00                	push   $0x0
801056b4:	e8 37 f6 ff ff       	call   80104cf0 <argstr>
801056b9:	83 c4 10             	add    $0x10,%esp
801056bc:	85 c0                	test   %eax,%eax
801056be:	78 60                	js     80105720 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056c3:	83 ec 08             	sub    $0x8,%esp
801056c6:	50                   	push   %eax
801056c7:	6a 01                	push   $0x1
801056c9:	e8 72 f5 ff ff       	call   80104c40 <argint>
  if((argstr(0, &path)) < 0 ||
801056ce:	83 c4 10             	add    $0x10,%esp
801056d1:	85 c0                	test   %eax,%eax
801056d3:	78 4b                	js     80105720 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d8:	83 ec 08             	sub    $0x8,%esp
801056db:	50                   	push   %eax
801056dc:	6a 02                	push   $0x2
801056de:	e8 5d f5 ff ff       	call   80104c40 <argint>
     argint(1, &major) < 0 ||
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	85 c0                	test   %eax,%eax
801056e8:	78 36                	js     80105720 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801056ee:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
801056ef:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
801056f3:	50                   	push   %eax
801056f4:	6a 03                	push   $0x3
801056f6:	ff 75 ec             	pushl  -0x14(%ebp)
801056f9:	e8 32 fc ff ff       	call   80105330 <create>
801056fe:	83 c4 10             	add    $0x10,%esp
80105701:	85 c0                	test   %eax,%eax
80105703:	74 1b                	je     80105720 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105705:	83 ec 0c             	sub    $0xc,%esp
80105708:	50                   	push   %eax
80105709:	e8 12 c2 ff ff       	call   80101920 <iunlockput>
  end_op();
8010570e:	e8 3d d9 ff ff       	call   80103050 <end_op>
  return 0;
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	31 c0                	xor    %eax,%eax
}
80105718:	c9                   	leave  
80105719:	c3                   	ret    
8010571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105720:	e8 2b d9 ff ff       	call   80103050 <end_op>
    return -1;
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010572a:	c9                   	leave  
8010572b:	c3                   	ret    
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_chdir>:

int
sys_chdir(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	56                   	push   %esi
80105734:	53                   	push   %ebx
80105735:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105738:	e8 03 e5 ff ff       	call   80103c40 <myproc>
8010573d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010573f:	e8 9c d8 ff ff       	call   80102fe0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105744:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105747:	83 ec 08             	sub    $0x8,%esp
8010574a:	50                   	push   %eax
8010574b:	6a 00                	push   $0x0
8010574d:	e8 9e f5 ff ff       	call   80104cf0 <argstr>
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	85 c0                	test   %eax,%eax
80105757:	78 77                	js     801057d0 <sys_chdir+0xa0>
80105759:	83 ec 0c             	sub    $0xc,%esp
8010575c:	ff 75 f4             	pushl  -0xc(%ebp)
8010575f:	e8 8c c7 ff ff       	call   80101ef0 <namei>
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	85 c0                	test   %eax,%eax
80105769:	89 c3                	mov    %eax,%ebx
8010576b:	74 63                	je     801057d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	50                   	push   %eax
80105771:	e8 1a bf ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010577e:	75 30                	jne    801057b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105780:	83 ec 0c             	sub    $0xc,%esp
80105783:	53                   	push   %ebx
80105784:	e8 e7 bf ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105789:	58                   	pop    %eax
8010578a:	ff 76 68             	pushl  0x68(%esi)
8010578d:	e8 2e c0 ff ff       	call   801017c0 <iput>
  end_op();
80105792:	e8 b9 d8 ff ff       	call   80103050 <end_op>
  curproc->cwd = ip;
80105797:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010579a:	83 c4 10             	add    $0x10,%esp
8010579d:	31 c0                	xor    %eax,%eax
}
8010579f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057a2:	5b                   	pop    %ebx
801057a3:	5e                   	pop    %esi
801057a4:	5d                   	pop    %ebp
801057a5:	c3                   	ret    
801057a6:	8d 76 00             	lea    0x0(%esi),%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	53                   	push   %ebx
801057b4:	e8 67 c1 ff ff       	call   80101920 <iunlockput>
    end_op();
801057b9:	e8 92 d8 ff ff       	call   80103050 <end_op>
    return -1;
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c6:	eb d7                	jmp    8010579f <sys_chdir+0x6f>
801057c8:	90                   	nop
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801057d0:	e8 7b d8 ff ff       	call   80103050 <end_op>
    return -1;
801057d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057da:	eb c3                	jmp    8010579f <sys_chdir+0x6f>
801057dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057e0 <sys_exec>:

int
sys_exec(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	57                   	push   %edi
801057e4:	56                   	push   %esi
801057e5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057e6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057f2:	50                   	push   %eax
801057f3:	6a 00                	push   $0x0
801057f5:	e8 f6 f4 ff ff       	call   80104cf0 <argstr>
801057fa:	83 c4 10             	add    $0x10,%esp
801057fd:	85 c0                	test   %eax,%eax
801057ff:	0f 88 87 00 00 00    	js     8010588c <sys_exec+0xac>
80105805:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010580b:	83 ec 08             	sub    $0x8,%esp
8010580e:	50                   	push   %eax
8010580f:	6a 01                	push   $0x1
80105811:	e8 2a f4 ff ff       	call   80104c40 <argint>
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	85 c0                	test   %eax,%eax
8010581b:	78 6f                	js     8010588c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010581d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105823:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105826:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105828:	68 80 00 00 00       	push   $0x80
8010582d:	6a 00                	push   $0x0
8010582f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105835:	50                   	push   %eax
80105836:	e8 05 f1 ff ff       	call   80104940 <memset>
8010583b:	83 c4 10             	add    $0x10,%esp
8010583e:	eb 2c                	jmp    8010586c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105840:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105846:	85 c0                	test   %eax,%eax
80105848:	74 56                	je     801058a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010584a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105850:	83 ec 08             	sub    $0x8,%esp
80105853:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105856:	52                   	push   %edx
80105857:	50                   	push   %eax
80105858:	e8 73 f3 ff ff       	call   80104bd0 <fetchstr>
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	85 c0                	test   %eax,%eax
80105862:	78 28                	js     8010588c <sys_exec+0xac>
  for(i=0;; i++){
80105864:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105867:	83 fb 20             	cmp    $0x20,%ebx
8010586a:	74 20                	je     8010588c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010586c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105872:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105879:	83 ec 08             	sub    $0x8,%esp
8010587c:	57                   	push   %edi
8010587d:	01 f0                	add    %esi,%eax
8010587f:	50                   	push   %eax
80105880:	e8 0b f3 ff ff       	call   80104b90 <fetchint>
80105885:	83 c4 10             	add    $0x10,%esp
80105888:	85 c0                	test   %eax,%eax
8010588a:	79 b4                	jns    80105840 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010588c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010588f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105894:	5b                   	pop    %ebx
80105895:	5e                   	pop    %esi
80105896:	5f                   	pop    %edi
80105897:	5d                   	pop    %ebp
80105898:	c3                   	ret    
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801058a0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801058a6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801058a9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058b0:	00 00 00 00 
  return exec(path, argv);
801058b4:	50                   	push   %eax
801058b5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801058bb:	e8 50 b1 ff ff       	call   80100a10 <exec>
801058c0:	83 c4 10             	add    $0x10,%esp
}
801058c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058c6:	5b                   	pop    %ebx
801058c7:	5e                   	pop    %esi
801058c8:	5f                   	pop    %edi
801058c9:	5d                   	pop    %ebp
801058ca:	c3                   	ret    
801058cb:	90                   	nop
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_pipe>:

int
sys_pipe(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
801058d5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058dc:	6a 08                	push   $0x8
801058de:	50                   	push   %eax
801058df:	6a 00                	push   $0x0
801058e1:	e8 aa f3 ff ff       	call   80104c90 <argptr>
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	85 c0                	test   %eax,%eax
801058eb:	0f 88 ae 00 00 00    	js     8010599f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058f4:	83 ec 08             	sub    $0x8,%esp
801058f7:	50                   	push   %eax
801058f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058fb:	50                   	push   %eax
801058fc:	e8 7f dd ff ff       	call   80103680 <pipealloc>
80105901:	83 c4 10             	add    $0x10,%esp
80105904:	85 c0                	test   %eax,%eax
80105906:	0f 88 93 00 00 00    	js     8010599f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010590c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010590f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105911:	e8 2a e3 ff ff       	call   80103c40 <myproc>
80105916:	eb 10                	jmp    80105928 <sys_pipe+0x58>
80105918:	90                   	nop
80105919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105920:	83 c3 01             	add    $0x1,%ebx
80105923:	83 fb 10             	cmp    $0x10,%ebx
80105926:	74 60                	je     80105988 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105928:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010592c:	85 f6                	test   %esi,%esi
8010592e:	75 f0                	jne    80105920 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105930:	8d 73 08             	lea    0x8(%ebx),%esi
80105933:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105937:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010593a:	e8 01 e3 ff ff       	call   80103c40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010593f:	31 d2                	xor    %edx,%edx
80105941:	eb 0d                	jmp    80105950 <sys_pipe+0x80>
80105943:	90                   	nop
80105944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105948:	83 c2 01             	add    $0x1,%edx
8010594b:	83 fa 10             	cmp    $0x10,%edx
8010594e:	74 28                	je     80105978 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105950:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105954:	85 c9                	test   %ecx,%ecx
80105956:	75 f0                	jne    80105948 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105958:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010595c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010595f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105961:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105964:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105967:	31 c0                	xor    %eax,%eax
}
80105969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010596c:	5b                   	pop    %ebx
8010596d:	5e                   	pop    %esi
8010596e:	5f                   	pop    %edi
8010596f:	5d                   	pop    %ebp
80105970:	c3                   	ret    
80105971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105978:	e8 c3 e2 ff ff       	call   80103c40 <myproc>
8010597d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105984:	00 
80105985:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	ff 75 e0             	pushl  -0x20(%ebp)
8010598e:	e8 ad b4 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105993:	58                   	pop    %eax
80105994:	ff 75 e4             	pushl  -0x1c(%ebp)
80105997:	e8 a4 b4 ff ff       	call   80100e40 <fileclose>
    return -1;
8010599c:	83 c4 10             	add    $0x10,%esp
8010599f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a4:	eb c3                	jmp    80105969 <sys_pipe+0x99>
801059a6:	66 90                	xchg   %ax,%ax
801059a8:	66 90                	xchg   %ax,%ax
801059aa:	66 90                	xchg   %ax,%ax
801059ac:	66 90                	xchg   %ax,%ax
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 08             	sub    $0x8,%esp
  yield(); 
801059b6:	e8 f5 e7 ff ff       	call   801041b0 <yield>
  return 0;
}
801059bb:	31 c0                	xor    %eax,%eax
801059bd:	c9                   	leave  
801059be:	c3                   	ret    
801059bf:	90                   	nop

801059c0 <sys_fork>:

int
sys_fork(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059c3:	5d                   	pop    %ebp
  return fork();
801059c4:	e9 37 e4 ff ff       	jmp    80103e00 <fork>
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_exit>:

int
sys_exit(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059d6:	e8 a5 e6 ff ff       	call   80104080 <exit>
  return 0;  // not reached
}
801059db:	31 c0                	xor    %eax,%eax
801059dd:	c9                   	leave  
801059de:	c3                   	ret    
801059df:	90                   	nop

801059e0 <sys_wait>:

int
sys_wait(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801059e3:	5d                   	pop    %ebp
  return wait();
801059e4:	e9 d7 e8 ff ff       	jmp    801042c0 <wait>
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_kill>:

int
sys_kill(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f9:	50                   	push   %eax
801059fa:	6a 00                	push   $0x0
801059fc:	e8 3f f2 ff ff       	call   80104c40 <argint>
80105a01:	83 c4 10             	add    $0x10,%esp
80105a04:	85 c0                	test   %eax,%eax
80105a06:	78 18                	js     80105a20 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a08:	83 ec 0c             	sub    $0xc,%esp
80105a0b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a0e:	e8 0d ea ff ff       	call   80104420 <kill>
80105a13:	83 c4 10             	add    $0x10,%esp
}
80105a16:	c9                   	leave  
80105a17:	c3                   	ret    
80105a18:	90                   	nop
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a25:	c9                   	leave  
80105a26:	c3                   	ret    
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a30 <sys_getpid>:

int
sys_getpid(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a36:	e8 05 e2 ff ff       	call   80103c40 <myproc>
80105a3b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a3e:	c9                   	leave  
80105a3f:	c3                   	ret    

80105a40 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a4a:	50                   	push   %eax
80105a4b:	6a 00                	push   $0x0
80105a4d:	e8 ee f1 ff ff       	call   80104c40 <argint>
80105a52:	83 c4 10             	add    $0x10,%esp
80105a55:	85 c0                	test   %eax,%eax
80105a57:	78 27                	js     80105a80 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a59:	e8 e2 e1 ff ff       	call   80103c40 <myproc>
  if(growproc(n) < 0)
80105a5e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a61:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a63:	ff 75 f4             	pushl  -0xc(%ebp)
80105a66:	e8 05 e3 ff ff       	call   80103d70 <growproc>
80105a6b:	83 c4 10             	add    $0x10,%esp
80105a6e:	85 c0                	test   %eax,%eax
80105a70:	78 0e                	js     80105a80 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a72:	89 d8                	mov    %ebx,%eax
80105a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a77:	c9                   	leave  
80105a78:	c3                   	ret    
80105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a80:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a85:	eb eb                	jmp    80105a72 <sys_sbrk+0x32>
80105a87:	89 f6                	mov    %esi,%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a90 <sys_sleep>:

int
sys_sleep(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a9a:	50                   	push   %eax
80105a9b:	6a 00                	push   $0x0
80105a9d:	e8 9e f1 ff ff       	call   80104c40 <argint>
80105aa2:	83 c4 10             	add    $0x10,%esp
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	0f 88 8a 00 00 00    	js     80105b37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105aad:	83 ec 0c             	sub    $0xc,%esp
80105ab0:	68 a0 54 12 80       	push   $0x801254a0
80105ab5:	e8 06 ed ff ff       	call   801047c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105abd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105ac0:	8b 1d e0 5c 12 80    	mov    0x80125ce0,%ebx
  while(ticks - ticks0 < n){
80105ac6:	85 d2                	test   %edx,%edx
80105ac8:	75 27                	jne    80105af1 <sys_sleep+0x61>
80105aca:	eb 54                	jmp    80105b20 <sys_sleep+0x90>
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ad0:	83 ec 08             	sub    $0x8,%esp
80105ad3:	68 a0 54 12 80       	push   $0x801254a0
80105ad8:	68 e0 5c 12 80       	push   $0x80125ce0
80105add:	e8 1e e7 ff ff       	call   80104200 <sleep>
  while(ticks - ticks0 < n){
80105ae2:	a1 e0 5c 12 80       	mov    0x80125ce0,%eax
80105ae7:	83 c4 10             	add    $0x10,%esp
80105aea:	29 d8                	sub    %ebx,%eax
80105aec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105aef:	73 2f                	jae    80105b20 <sys_sleep+0x90>
    if(myproc()->killed){
80105af1:	e8 4a e1 ff ff       	call   80103c40 <myproc>
80105af6:	8b 40 24             	mov    0x24(%eax),%eax
80105af9:	85 c0                	test   %eax,%eax
80105afb:	74 d3                	je     80105ad0 <sys_sleep+0x40>
      release(&tickslock);
80105afd:	83 ec 0c             	sub    $0xc,%esp
80105b00:	68 a0 54 12 80       	push   $0x801254a0
80105b05:	e8 d6 ed ff ff       	call   801048e0 <release>
      return -1;
80105b0a:	83 c4 10             	add    $0x10,%esp
80105b0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105b12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b15:	c9                   	leave  
80105b16:	c3                   	ret    
80105b17:	89 f6                	mov    %esi,%esi
80105b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	68 a0 54 12 80       	push   $0x801254a0
80105b28:	e8 b3 ed ff ff       	call   801048e0 <release>
  return 0;
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	31 c0                	xor    %eax,%eax
}
80105b32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b35:	c9                   	leave  
80105b36:	c3                   	ret    
    return -1;
80105b37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3c:	eb f4                	jmp    80105b32 <sys_sleep+0xa2>
80105b3e:	66 90                	xchg   %ax,%ax

80105b40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	53                   	push   %ebx
80105b44:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b47:	68 a0 54 12 80       	push   $0x801254a0
80105b4c:	e8 6f ec ff ff       	call   801047c0 <acquire>
  xticks = ticks;
80105b51:	8b 1d e0 5c 12 80    	mov    0x80125ce0,%ebx
  release(&tickslock);
80105b57:	c7 04 24 a0 54 12 80 	movl   $0x801254a0,(%esp)
80105b5e:	e8 7d ed ff ff       	call   801048e0 <release>
  return xticks;
}
80105b63:	89 d8                	mov    %ebx,%eax
80105b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b68:	c9                   	leave  
80105b69:	c3                   	ret    

80105b6a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b6a:	1e                   	push   %ds
  pushl %es
80105b6b:	06                   	push   %es
  pushl %fs
80105b6c:	0f a0                	push   %fs
  pushl %gs
80105b6e:	0f a8                	push   %gs
  pushal
80105b70:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b71:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b75:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b77:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b79:	54                   	push   %esp
  call trap
80105b7a:	e8 c1 00 00 00       	call   80105c40 <trap>
  addl $4, %esp
80105b7f:	83 c4 04             	add    $0x4,%esp

80105b82 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b82:	61                   	popa   
  popl %gs
80105b83:	0f a9                	pop    %gs
  popl %fs
80105b85:	0f a1                	pop    %fs
  popl %es
80105b87:	07                   	pop    %es
  popl %ds
80105b88:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b89:	83 c4 08             	add    $0x8,%esp
  iret
80105b8c:	cf                   	iret   
80105b8d:	66 90                	xchg   %ax,%ax
80105b8f:	90                   	nop

80105b90 <tvinit>:
struct spinlock tickslock;
uint ticks, virtualAddr, problematicPage;
struct proc *p;

void
tvinit(void) {
80105b90:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105b91:	31 c0                	xor    %eax,%eax
tvinit(void) {
80105b93:	89 e5                	mov    %esp,%ebp
80105b95:	83 ec 08             	sub    $0x8,%esp
80105b98:	90                   	nop
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105ba0:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
80105ba7:	c7 04 c5 e2 54 12 80 	movl   $0x8e000008,-0x7fedab1e(,%eax,8)
80105bae:	08 00 00 8e 
80105bb2:	66 89 14 c5 e0 54 12 	mov    %dx,-0x7fedab20(,%eax,8)
80105bb9:	80 
80105bba:	c1 ea 10             	shr    $0x10,%edx
80105bbd:	66 89 14 c5 e6 54 12 	mov    %dx,-0x7fedab1a(,%eax,8)
80105bc4:	80 
80105bc5:	83 c0 01             	add    $0x1,%eax
80105bc8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bcd:	75 d1                	jne    80105ba0 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105bcf:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

    initlock(&tickslock, "time");
80105bd4:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105bd7:	c7 05 e2 56 12 80 08 	movl   $0xef000008,0x801256e2
80105bde:	00 00 ef 
    initlock(&tickslock, "time");
80105be1:	68 d9 7c 10 80       	push   $0x80107cd9
80105be6:	68 a0 54 12 80       	push   $0x801254a0
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105beb:	66 a3 e0 56 12 80    	mov    %ax,0x801256e0
80105bf1:	c1 e8 10             	shr    $0x10,%eax
80105bf4:	66 a3 e6 56 12 80    	mov    %ax,0x801256e6
    initlock(&tickslock, "time");
80105bfa:	e8 d1 ea ff ff       	call   801046d0 <initlock>
}
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	c9                   	leave  
80105c03:	c3                   	ret    
80105c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c10 <idtinit>:

void
idtinit(void) {
80105c10:	55                   	push   %ebp
  pd[0] = size-1;
80105c11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c16:	89 e5                	mov    %esp,%ebp
80105c18:	83 ec 10             	sub    $0x10,%esp
80105c1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c1f:	b8 e0 54 12 80       	mov    $0x801254e0,%eax
80105c24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c28:	c1 e8 10             	shr    $0x10,%eax
80105c2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c32:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80105c35:	c9                   	leave  
80105c36:	c3                   	ret    
80105c37:	89 f6                	mov    %esi,%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	57                   	push   %edi
80105c44:	56                   	push   %esi
80105c45:	53                   	push   %ebx
80105c46:	83 ec 1c             	sub    $0x1c,%esp
80105c49:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (tf->trapno == T_SYSCALL) {
80105c4c:	8b 47 30             	mov    0x30(%edi),%eax
80105c4f:	83 f8 40             	cmp    $0x40,%eax
80105c52:	0f 84 f0 00 00 00    	je     80105d48 <trap+0x108>
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
80105c58:	83 e8 20             	sub    $0x20,%eax
80105c5b:	83 f8 1f             	cmp    $0x1f,%eax
80105c5e:	77 10                	ja     80105c70 <trap+0x30>
80105c60:	ff 24 85 80 7d 10 80 	jmp    *-0x7fef8280(,%eax,4)
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#endif


            //PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80105c70:	e8 cb df ff ff       	call   80103c40 <myproc>
80105c75:	85 c0                	test   %eax,%eax
80105c77:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c7a:	0f 84 14 02 00 00    	je     80105e94 <trap+0x254>
80105c80:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105c84:	0f 84 0a 02 00 00    	je     80105e94 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c8a:	0f 20 d1             	mov    %cr2,%ecx
80105c8d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c90:	e8 8b df ff ff       	call   80103c20 <cpuid>
80105c95:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c98:	8b 47 34             	mov    0x34(%edi),%eax
80105c9b:	8b 77 30             	mov    0x30(%edi),%esi
80105c9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
80105ca1:	e8 9a df ff ff       	call   80103c40 <myproc>
80105ca6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ca9:	e8 92 df ff ff       	call   80103c40 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105cb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105cb4:	51                   	push   %ecx
80105cb5:	53                   	push   %ebx
80105cb6:	52                   	push   %edx
                    myproc()->pid, myproc()->name, tf->trapno,
80105cb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cba:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cbd:	56                   	push   %esi
                    myproc()->pid, myproc()->name, tf->trapno,
80105cbe:	83 c2 6c             	add    $0x6c,%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cc1:	52                   	push   %edx
80105cc2:	ff 70 10             	pushl  0x10(%eax)
80105cc5:	68 3c 7d 10 80       	push   $0x80107d3c
80105cca:	e8 91 a9 ff ff       	call   80100660 <cprintf>
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
80105ccf:	83 c4 20             	add    $0x20,%esp
80105cd2:	e8 69 df ff ff       	call   80103c40 <myproc>
80105cd7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105cde:	e8 5d df ff ff       	call   80103c40 <myproc>
80105ce3:	85 c0                	test   %eax,%eax
80105ce5:	74 1d                	je     80105d04 <trap+0xc4>
80105ce7:	e8 54 df ff ff       	call   80103c40 <myproc>
80105cec:	8b 50 24             	mov    0x24(%eax),%edx
80105cef:	85 d2                	test   %edx,%edx
80105cf1:	74 11                	je     80105d04 <trap+0xc4>
80105cf3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105cf7:	83 e0 03             	and    $0x3,%eax
80105cfa:	66 83 f8 03          	cmp    $0x3,%ax
80105cfe:	0f 84 4c 01 00 00    	je     80105e50 <trap+0x210>
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80105d04:	e8 37 df ff ff       	call   80103c40 <myproc>
80105d09:	85 c0                	test   %eax,%eax
80105d0b:	74 0b                	je     80105d18 <trap+0xd8>
80105d0d:	e8 2e df ff ff       	call   80103c40 <myproc>
80105d12:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d16:	74 68                	je     80105d80 <trap+0x140>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105d18:	e8 23 df ff ff       	call   80103c40 <myproc>
80105d1d:	85 c0                	test   %eax,%eax
80105d1f:	74 19                	je     80105d3a <trap+0xfa>
80105d21:	e8 1a df ff ff       	call   80103c40 <myproc>
80105d26:	8b 40 24             	mov    0x24(%eax),%eax
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	74 0d                	je     80105d3a <trap+0xfa>
80105d2d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d31:	83 e0 03             	and    $0x3,%eax
80105d34:	66 83 f8 03          	cmp    $0x3,%ax
80105d38:	74 37                	je     80105d71 <trap+0x131>
        exit();
}
80105d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d3d:	5b                   	pop    %ebx
80105d3e:	5e                   	pop    %esi
80105d3f:	5f                   	pop    %edi
80105d40:	5d                   	pop    %ebp
80105d41:	c3                   	ret    
80105d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (myproc()->killed)
80105d48:	e8 f3 de ff ff       	call   80103c40 <myproc>
80105d4d:	8b 58 24             	mov    0x24(%eax),%ebx
80105d50:	85 db                	test   %ebx,%ebx
80105d52:	0f 85 e8 00 00 00    	jne    80105e40 <trap+0x200>
        myproc()->tf = tf;
80105d58:	e8 e3 de ff ff       	call   80103c40 <myproc>
80105d5d:	89 78 18             	mov    %edi,0x18(%eax)
        syscall();
80105d60:	e8 cb ef ff ff       	call   80104d30 <syscall>
        if (myproc()->killed)
80105d65:	e8 d6 de ff ff       	call   80103c40 <myproc>
80105d6a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d6d:	85 c9                	test   %ecx,%ecx
80105d6f:	74 c9                	je     80105d3a <trap+0xfa>
}
80105d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d74:	5b                   	pop    %ebx
80105d75:	5e                   	pop    %esi
80105d76:	5f                   	pop    %edi
80105d77:	5d                   	pop    %ebp
            exit();
80105d78:	e9 03 e3 ff ff       	jmp    80104080 <exit>
80105d7d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
80105d80:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105d84:	75 92                	jne    80105d18 <trap+0xd8>
        yield();
80105d86:	e8 25 e4 ff ff       	call   801041b0 <yield>
80105d8b:	eb 8b                	jmp    80105d18 <trap+0xd8>
80105d8d:	8d 76 00             	lea    0x0(%esi),%esi
            if (cpuid() == 0) {
80105d90:	e8 8b de ff ff       	call   80103c20 <cpuid>
80105d95:	85 c0                	test   %eax,%eax
80105d97:	0f 84 c3 00 00 00    	je     80105e60 <trap+0x220>
            lapiceoi();
80105d9d:	e8 ee cd ff ff       	call   80102b90 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105da2:	e8 99 de ff ff       	call   80103c40 <myproc>
80105da7:	85 c0                	test   %eax,%eax
80105da9:	0f 85 38 ff ff ff    	jne    80105ce7 <trap+0xa7>
80105daf:	e9 50 ff ff ff       	jmp    80105d04 <trap+0xc4>
80105db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80105db8:	e8 93 cc ff ff       	call   80102a50 <kbdintr>
            lapiceoi();
80105dbd:	e8 ce cd ff ff       	call   80102b90 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105dc2:	e8 79 de ff ff       	call   80103c40 <myproc>
80105dc7:	85 c0                	test   %eax,%eax
80105dc9:	0f 85 18 ff ff ff    	jne    80105ce7 <trap+0xa7>
80105dcf:	e9 30 ff ff ff       	jmp    80105d04 <trap+0xc4>
80105dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
80105dd8:	e8 53 02 00 00       	call   80106030 <uartintr>
            lapiceoi();
80105ddd:	e8 ae cd ff ff       	call   80102b90 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105de2:	e8 59 de ff ff       	call   80103c40 <myproc>
80105de7:	85 c0                	test   %eax,%eax
80105de9:	0f 85 f8 fe ff ff    	jne    80105ce7 <trap+0xa7>
80105def:	e9 10 ff ff ff       	jmp    80105d04 <trap+0xc4>
80105df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105df8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105dfc:	8b 77 38             	mov    0x38(%edi),%esi
80105dff:	e8 1c de ff ff       	call   80103c20 <cpuid>
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
80105e06:	50                   	push   %eax
80105e07:	68 e4 7c 10 80       	push   $0x80107ce4
80105e0c:	e8 4f a8 ff ff       	call   80100660 <cprintf>
            lapiceoi();
80105e11:	e8 7a cd ff ff       	call   80102b90 <lapiceoi>
            break;
80105e16:	83 c4 10             	add    $0x10,%esp
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105e19:	e8 22 de ff ff       	call   80103c40 <myproc>
80105e1e:	85 c0                	test   %eax,%eax
80105e20:	0f 85 c1 fe ff ff    	jne    80105ce7 <trap+0xa7>
80105e26:	e9 d9 fe ff ff       	jmp    80105d04 <trap+0xc4>
80105e2b:	90                   	nop
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ideintr();
80105e30:	e8 eb c5 ff ff       	call   80102420 <ideintr>
80105e35:	e9 63 ff ff ff       	jmp    80105d9d <trap+0x15d>
80105e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
80105e40:	e8 3b e2 ff ff       	call   80104080 <exit>
80105e45:	e9 0e ff ff ff       	jmp    80105d58 <trap+0x118>
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        exit();
80105e50:	e8 2b e2 ff ff       	call   80104080 <exit>
80105e55:	e9 aa fe ff ff       	jmp    80105d04 <trap+0xc4>
80105e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                acquire(&tickslock);
80105e60:	83 ec 0c             	sub    $0xc,%esp
80105e63:	68 a0 54 12 80       	push   $0x801254a0
80105e68:	e8 53 e9 ff ff       	call   801047c0 <acquire>
                wakeup(&ticks);
80105e6d:	c7 04 24 e0 5c 12 80 	movl   $0x80125ce0,(%esp)
                ticks++;
80105e74:	83 05 e0 5c 12 80 01 	addl   $0x1,0x80125ce0
                wakeup(&ticks);
80105e7b:	e8 40 e5 ff ff       	call   801043c0 <wakeup>
                release(&tickslock);
80105e80:	c7 04 24 a0 54 12 80 	movl   $0x801254a0,(%esp)
80105e87:	e8 54 ea ff ff       	call   801048e0 <release>
80105e8c:	83 c4 10             	add    $0x10,%esp
80105e8f:	e9 09 ff ff ff       	jmp    80105d9d <trap+0x15d>
80105e94:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e97:	e8 84 dd ff ff       	call   80103c20 <cpuid>
80105e9c:	83 ec 0c             	sub    $0xc,%esp
80105e9f:	56                   	push   %esi
80105ea0:	53                   	push   %ebx
80105ea1:	50                   	push   %eax
80105ea2:	ff 77 30             	pushl  0x30(%edi)
80105ea5:	68 08 7d 10 80       	push   $0x80107d08
80105eaa:	e8 b1 a7 ff ff       	call   80100660 <cprintf>
                panic("trap");
80105eaf:	83 c4 14             	add    $0x14,%esp
80105eb2:	68 de 7c 10 80       	push   $0x80107cde
80105eb7:	e8 d4 a4 ff ff       	call   80100390 <panic>
80105ebc:	66 90                	xchg   %ax,%ax
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ec0:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
{
80105ec5:	55                   	push   %ebp
80105ec6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ec8:	85 c0                	test   %eax,%eax
80105eca:	74 1c                	je     80105ee8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ecc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ed1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ed2:	a8 01                	test   $0x1,%al
80105ed4:	74 12                	je     80105ee8 <uartgetc+0x28>
80105ed6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105edb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105edc:	0f b6 c0             	movzbl %al,%eax
}
80105edf:	5d                   	pop    %ebp
80105ee0:	c3                   	ret    
80105ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eed:	5d                   	pop    %ebp
80105eee:	c3                   	ret    
80105eef:	90                   	nop

80105ef0 <uartputc.part.0>:
uartputc(int c)
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	57                   	push   %edi
80105ef4:	56                   	push   %esi
80105ef5:	53                   	push   %ebx
80105ef6:	89 c7                	mov    %eax,%edi
80105ef8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105efd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f02:	83 ec 0c             	sub    $0xc,%esp
80105f05:	eb 1b                	jmp    80105f22 <uartputc.part.0+0x32>
80105f07:	89 f6                	mov    %esi,%esi
80105f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105f10:	83 ec 0c             	sub    $0xc,%esp
80105f13:	6a 0a                	push   $0xa
80105f15:	e8 96 cc ff ff       	call   80102bb0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f1a:	83 c4 10             	add    $0x10,%esp
80105f1d:	83 eb 01             	sub    $0x1,%ebx
80105f20:	74 07                	je     80105f29 <uartputc.part.0+0x39>
80105f22:	89 f2                	mov    %esi,%edx
80105f24:	ec                   	in     (%dx),%al
80105f25:	a8 20                	test   $0x20,%al
80105f27:	74 e7                	je     80105f10 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f29:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f2e:	89 f8                	mov    %edi,%eax
80105f30:	ee                   	out    %al,(%dx)
}
80105f31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f34:	5b                   	pop    %ebx
80105f35:	5e                   	pop    %esi
80105f36:	5f                   	pop    %edi
80105f37:	5d                   	pop    %ebp
80105f38:	c3                   	ret    
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f40 <uartinit>:
{
80105f40:	55                   	push   %ebp
80105f41:	31 c9                	xor    %ecx,%ecx
80105f43:	89 c8                	mov    %ecx,%eax
80105f45:	89 e5                	mov    %esp,%ebp
80105f47:	57                   	push   %edi
80105f48:	56                   	push   %esi
80105f49:	53                   	push   %ebx
80105f4a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f4f:	89 da                	mov    %ebx,%edx
80105f51:	83 ec 0c             	sub    $0xc,%esp
80105f54:	ee                   	out    %al,(%dx)
80105f55:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f5a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f5f:	89 fa                	mov    %edi,%edx
80105f61:	ee                   	out    %al,(%dx)
80105f62:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f6c:	ee                   	out    %al,(%dx)
80105f6d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f72:	89 c8                	mov    %ecx,%eax
80105f74:	89 f2                	mov    %esi,%edx
80105f76:	ee                   	out    %al,(%dx)
80105f77:	b8 03 00 00 00       	mov    $0x3,%eax
80105f7c:	89 fa                	mov    %edi,%edx
80105f7e:	ee                   	out    %al,(%dx)
80105f7f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f84:	89 c8                	mov    %ecx,%eax
80105f86:	ee                   	out    %al,(%dx)
80105f87:	b8 01 00 00 00       	mov    $0x1,%eax
80105f8c:	89 f2                	mov    %esi,%edx
80105f8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f8f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f94:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f95:	3c ff                	cmp    $0xff,%al
80105f97:	74 5a                	je     80105ff3 <uartinit+0xb3>
  uart = 1;
80105f99:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105fa0:	00 00 00 
80105fa3:	89 da                	mov    %ebx,%edx
80105fa5:	ec                   	in     (%dx),%al
80105fa6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105faf:	bb 00 7e 10 80       	mov    $0x80107e00,%ebx
  ioapicenable(IRQ_COM1, 0);
80105fb4:	6a 00                	push   $0x0
80105fb6:	6a 04                	push   $0x4
80105fb8:	e8 b3 c6 ff ff       	call   80102670 <ioapicenable>
80105fbd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fc0:	b8 78 00 00 00       	mov    $0x78,%eax
80105fc5:	eb 13                	jmp    80105fda <uartinit+0x9a>
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fd0:	83 c3 01             	add    $0x1,%ebx
80105fd3:	0f be 03             	movsbl (%ebx),%eax
80105fd6:	84 c0                	test   %al,%al
80105fd8:	74 19                	je     80105ff3 <uartinit+0xb3>
  if(!uart)
80105fda:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105fe0:	85 d2                	test   %edx,%edx
80105fe2:	74 ec                	je     80105fd0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105fe4:	83 c3 01             	add    $0x1,%ebx
80105fe7:	e8 04 ff ff ff       	call   80105ef0 <uartputc.part.0>
80105fec:	0f be 03             	movsbl (%ebx),%eax
80105fef:	84 c0                	test   %al,%al
80105ff1:	75 e7                	jne    80105fda <uartinit+0x9a>
}
80105ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff6:	5b                   	pop    %ebx
80105ff7:	5e                   	pop    %esi
80105ff8:	5f                   	pop    %edi
80105ff9:	5d                   	pop    %ebp
80105ffa:	c3                   	ret    
80105ffb:	90                   	nop
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106000 <uartputc>:
  if(!uart)
80106000:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
{
80106006:	55                   	push   %ebp
80106007:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106009:	85 d2                	test   %edx,%edx
{
8010600b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010600e:	74 10                	je     80106020 <uartputc+0x20>
}
80106010:	5d                   	pop    %ebp
80106011:	e9 da fe ff ff       	jmp    80105ef0 <uartputc.part.0>
80106016:	8d 76 00             	lea    0x0(%esi),%esi
80106019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106020:	5d                   	pop    %ebp
80106021:	c3                   	ret    
80106022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106030 <uartintr>:

void
uartintr(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106036:	68 c0 5e 10 80       	push   $0x80105ec0
8010603b:	e8 d0 a7 ff ff       	call   80100810 <consoleintr>
}
80106040:	83 c4 10             	add    $0x10,%esp
80106043:	c9                   	leave  
80106044:	c3                   	ret    

80106045 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $0
80106047:	6a 00                	push   $0x0
  jmp alltraps
80106049:	e9 1c fb ff ff       	jmp    80105b6a <alltraps>

8010604e <vector1>:
.globl vector1
vector1:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $1
80106050:	6a 01                	push   $0x1
  jmp alltraps
80106052:	e9 13 fb ff ff       	jmp    80105b6a <alltraps>

80106057 <vector2>:
.globl vector2
vector2:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $2
80106059:	6a 02                	push   $0x2
  jmp alltraps
8010605b:	e9 0a fb ff ff       	jmp    80105b6a <alltraps>

80106060 <vector3>:
.globl vector3
vector3:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $3
80106062:	6a 03                	push   $0x3
  jmp alltraps
80106064:	e9 01 fb ff ff       	jmp    80105b6a <alltraps>

80106069 <vector4>:
.globl vector4
vector4:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $4
8010606b:	6a 04                	push   $0x4
  jmp alltraps
8010606d:	e9 f8 fa ff ff       	jmp    80105b6a <alltraps>

80106072 <vector5>:
.globl vector5
vector5:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $5
80106074:	6a 05                	push   $0x5
  jmp alltraps
80106076:	e9 ef fa ff ff       	jmp    80105b6a <alltraps>

8010607b <vector6>:
.globl vector6
vector6:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $6
8010607d:	6a 06                	push   $0x6
  jmp alltraps
8010607f:	e9 e6 fa ff ff       	jmp    80105b6a <alltraps>

80106084 <vector7>:
.globl vector7
vector7:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $7
80106086:	6a 07                	push   $0x7
  jmp alltraps
80106088:	e9 dd fa ff ff       	jmp    80105b6a <alltraps>

8010608d <vector8>:
.globl vector8
vector8:
  pushl $8
8010608d:	6a 08                	push   $0x8
  jmp alltraps
8010608f:	e9 d6 fa ff ff       	jmp    80105b6a <alltraps>

80106094 <vector9>:
.globl vector9
vector9:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $9
80106096:	6a 09                	push   $0x9
  jmp alltraps
80106098:	e9 cd fa ff ff       	jmp    80105b6a <alltraps>

8010609d <vector10>:
.globl vector10
vector10:
  pushl $10
8010609d:	6a 0a                	push   $0xa
  jmp alltraps
8010609f:	e9 c6 fa ff ff       	jmp    80105b6a <alltraps>

801060a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801060a4:	6a 0b                	push   $0xb
  jmp alltraps
801060a6:	e9 bf fa ff ff       	jmp    80105b6a <alltraps>

801060ab <vector12>:
.globl vector12
vector12:
  pushl $12
801060ab:	6a 0c                	push   $0xc
  jmp alltraps
801060ad:	e9 b8 fa ff ff       	jmp    80105b6a <alltraps>

801060b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060b2:	6a 0d                	push   $0xd
  jmp alltraps
801060b4:	e9 b1 fa ff ff       	jmp    80105b6a <alltraps>

801060b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060b9:	6a 0e                	push   $0xe
  jmp alltraps
801060bb:	e9 aa fa ff ff       	jmp    80105b6a <alltraps>

801060c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060c0:	6a 00                	push   $0x0
  pushl $15
801060c2:	6a 0f                	push   $0xf
  jmp alltraps
801060c4:	e9 a1 fa ff ff       	jmp    80105b6a <alltraps>

801060c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $16
801060cb:	6a 10                	push   $0x10
  jmp alltraps
801060cd:	e9 98 fa ff ff       	jmp    80105b6a <alltraps>

801060d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060d2:	6a 11                	push   $0x11
  jmp alltraps
801060d4:	e9 91 fa ff ff       	jmp    80105b6a <alltraps>

801060d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $18
801060db:	6a 12                	push   $0x12
  jmp alltraps
801060dd:	e9 88 fa ff ff       	jmp    80105b6a <alltraps>

801060e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $19
801060e4:	6a 13                	push   $0x13
  jmp alltraps
801060e6:	e9 7f fa ff ff       	jmp    80105b6a <alltraps>

801060eb <vector20>:
.globl vector20
vector20:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $20
801060ed:	6a 14                	push   $0x14
  jmp alltraps
801060ef:	e9 76 fa ff ff       	jmp    80105b6a <alltraps>

801060f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $21
801060f6:	6a 15                	push   $0x15
  jmp alltraps
801060f8:	e9 6d fa ff ff       	jmp    80105b6a <alltraps>

801060fd <vector22>:
.globl vector22
vector22:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $22
801060ff:	6a 16                	push   $0x16
  jmp alltraps
80106101:	e9 64 fa ff ff       	jmp    80105b6a <alltraps>

80106106 <vector23>:
.globl vector23
vector23:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $23
80106108:	6a 17                	push   $0x17
  jmp alltraps
8010610a:	e9 5b fa ff ff       	jmp    80105b6a <alltraps>

8010610f <vector24>:
.globl vector24
vector24:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $24
80106111:	6a 18                	push   $0x18
  jmp alltraps
80106113:	e9 52 fa ff ff       	jmp    80105b6a <alltraps>

80106118 <vector25>:
.globl vector25
vector25:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $25
8010611a:	6a 19                	push   $0x19
  jmp alltraps
8010611c:	e9 49 fa ff ff       	jmp    80105b6a <alltraps>

80106121 <vector26>:
.globl vector26
vector26:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $26
80106123:	6a 1a                	push   $0x1a
  jmp alltraps
80106125:	e9 40 fa ff ff       	jmp    80105b6a <alltraps>

8010612a <vector27>:
.globl vector27
vector27:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $27
8010612c:	6a 1b                	push   $0x1b
  jmp alltraps
8010612e:	e9 37 fa ff ff       	jmp    80105b6a <alltraps>

80106133 <vector28>:
.globl vector28
vector28:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $28
80106135:	6a 1c                	push   $0x1c
  jmp alltraps
80106137:	e9 2e fa ff ff       	jmp    80105b6a <alltraps>

8010613c <vector29>:
.globl vector29
vector29:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $29
8010613e:	6a 1d                	push   $0x1d
  jmp alltraps
80106140:	e9 25 fa ff ff       	jmp    80105b6a <alltraps>

80106145 <vector30>:
.globl vector30
vector30:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $30
80106147:	6a 1e                	push   $0x1e
  jmp alltraps
80106149:	e9 1c fa ff ff       	jmp    80105b6a <alltraps>

8010614e <vector31>:
.globl vector31
vector31:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $31
80106150:	6a 1f                	push   $0x1f
  jmp alltraps
80106152:	e9 13 fa ff ff       	jmp    80105b6a <alltraps>

80106157 <vector32>:
.globl vector32
vector32:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $32
80106159:	6a 20                	push   $0x20
  jmp alltraps
8010615b:	e9 0a fa ff ff       	jmp    80105b6a <alltraps>

80106160 <vector33>:
.globl vector33
vector33:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $33
80106162:	6a 21                	push   $0x21
  jmp alltraps
80106164:	e9 01 fa ff ff       	jmp    80105b6a <alltraps>

80106169 <vector34>:
.globl vector34
vector34:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $34
8010616b:	6a 22                	push   $0x22
  jmp alltraps
8010616d:	e9 f8 f9 ff ff       	jmp    80105b6a <alltraps>

80106172 <vector35>:
.globl vector35
vector35:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $35
80106174:	6a 23                	push   $0x23
  jmp alltraps
80106176:	e9 ef f9 ff ff       	jmp    80105b6a <alltraps>

8010617b <vector36>:
.globl vector36
vector36:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $36
8010617d:	6a 24                	push   $0x24
  jmp alltraps
8010617f:	e9 e6 f9 ff ff       	jmp    80105b6a <alltraps>

80106184 <vector37>:
.globl vector37
vector37:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $37
80106186:	6a 25                	push   $0x25
  jmp alltraps
80106188:	e9 dd f9 ff ff       	jmp    80105b6a <alltraps>

8010618d <vector38>:
.globl vector38
vector38:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $38
8010618f:	6a 26                	push   $0x26
  jmp alltraps
80106191:	e9 d4 f9 ff ff       	jmp    80105b6a <alltraps>

80106196 <vector39>:
.globl vector39
vector39:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $39
80106198:	6a 27                	push   $0x27
  jmp alltraps
8010619a:	e9 cb f9 ff ff       	jmp    80105b6a <alltraps>

8010619f <vector40>:
.globl vector40
vector40:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $40
801061a1:	6a 28                	push   $0x28
  jmp alltraps
801061a3:	e9 c2 f9 ff ff       	jmp    80105b6a <alltraps>

801061a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $41
801061aa:	6a 29                	push   $0x29
  jmp alltraps
801061ac:	e9 b9 f9 ff ff       	jmp    80105b6a <alltraps>

801061b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $42
801061b3:	6a 2a                	push   $0x2a
  jmp alltraps
801061b5:	e9 b0 f9 ff ff       	jmp    80105b6a <alltraps>

801061ba <vector43>:
.globl vector43
vector43:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $43
801061bc:	6a 2b                	push   $0x2b
  jmp alltraps
801061be:	e9 a7 f9 ff ff       	jmp    80105b6a <alltraps>

801061c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $44
801061c5:	6a 2c                	push   $0x2c
  jmp alltraps
801061c7:	e9 9e f9 ff ff       	jmp    80105b6a <alltraps>

801061cc <vector45>:
.globl vector45
vector45:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $45
801061ce:	6a 2d                	push   $0x2d
  jmp alltraps
801061d0:	e9 95 f9 ff ff       	jmp    80105b6a <alltraps>

801061d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $46
801061d7:	6a 2e                	push   $0x2e
  jmp alltraps
801061d9:	e9 8c f9 ff ff       	jmp    80105b6a <alltraps>

801061de <vector47>:
.globl vector47
vector47:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $47
801061e0:	6a 2f                	push   $0x2f
  jmp alltraps
801061e2:	e9 83 f9 ff ff       	jmp    80105b6a <alltraps>

801061e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $48
801061e9:	6a 30                	push   $0x30
  jmp alltraps
801061eb:	e9 7a f9 ff ff       	jmp    80105b6a <alltraps>

801061f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $49
801061f2:	6a 31                	push   $0x31
  jmp alltraps
801061f4:	e9 71 f9 ff ff       	jmp    80105b6a <alltraps>

801061f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $50
801061fb:	6a 32                	push   $0x32
  jmp alltraps
801061fd:	e9 68 f9 ff ff       	jmp    80105b6a <alltraps>

80106202 <vector51>:
.globl vector51
vector51:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $51
80106204:	6a 33                	push   $0x33
  jmp alltraps
80106206:	e9 5f f9 ff ff       	jmp    80105b6a <alltraps>

8010620b <vector52>:
.globl vector52
vector52:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $52
8010620d:	6a 34                	push   $0x34
  jmp alltraps
8010620f:	e9 56 f9 ff ff       	jmp    80105b6a <alltraps>

80106214 <vector53>:
.globl vector53
vector53:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $53
80106216:	6a 35                	push   $0x35
  jmp alltraps
80106218:	e9 4d f9 ff ff       	jmp    80105b6a <alltraps>

8010621d <vector54>:
.globl vector54
vector54:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $54
8010621f:	6a 36                	push   $0x36
  jmp alltraps
80106221:	e9 44 f9 ff ff       	jmp    80105b6a <alltraps>

80106226 <vector55>:
.globl vector55
vector55:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $55
80106228:	6a 37                	push   $0x37
  jmp alltraps
8010622a:	e9 3b f9 ff ff       	jmp    80105b6a <alltraps>

8010622f <vector56>:
.globl vector56
vector56:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $56
80106231:	6a 38                	push   $0x38
  jmp alltraps
80106233:	e9 32 f9 ff ff       	jmp    80105b6a <alltraps>

80106238 <vector57>:
.globl vector57
vector57:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $57
8010623a:	6a 39                	push   $0x39
  jmp alltraps
8010623c:	e9 29 f9 ff ff       	jmp    80105b6a <alltraps>

80106241 <vector58>:
.globl vector58
vector58:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $58
80106243:	6a 3a                	push   $0x3a
  jmp alltraps
80106245:	e9 20 f9 ff ff       	jmp    80105b6a <alltraps>

8010624a <vector59>:
.globl vector59
vector59:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $59
8010624c:	6a 3b                	push   $0x3b
  jmp alltraps
8010624e:	e9 17 f9 ff ff       	jmp    80105b6a <alltraps>

80106253 <vector60>:
.globl vector60
vector60:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $60
80106255:	6a 3c                	push   $0x3c
  jmp alltraps
80106257:	e9 0e f9 ff ff       	jmp    80105b6a <alltraps>

8010625c <vector61>:
.globl vector61
vector61:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $61
8010625e:	6a 3d                	push   $0x3d
  jmp alltraps
80106260:	e9 05 f9 ff ff       	jmp    80105b6a <alltraps>

80106265 <vector62>:
.globl vector62
vector62:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $62
80106267:	6a 3e                	push   $0x3e
  jmp alltraps
80106269:	e9 fc f8 ff ff       	jmp    80105b6a <alltraps>

8010626e <vector63>:
.globl vector63
vector63:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $63
80106270:	6a 3f                	push   $0x3f
  jmp alltraps
80106272:	e9 f3 f8 ff ff       	jmp    80105b6a <alltraps>

80106277 <vector64>:
.globl vector64
vector64:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $64
80106279:	6a 40                	push   $0x40
  jmp alltraps
8010627b:	e9 ea f8 ff ff       	jmp    80105b6a <alltraps>

80106280 <vector65>:
.globl vector65
vector65:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $65
80106282:	6a 41                	push   $0x41
  jmp alltraps
80106284:	e9 e1 f8 ff ff       	jmp    80105b6a <alltraps>

80106289 <vector66>:
.globl vector66
vector66:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $66
8010628b:	6a 42                	push   $0x42
  jmp alltraps
8010628d:	e9 d8 f8 ff ff       	jmp    80105b6a <alltraps>

80106292 <vector67>:
.globl vector67
vector67:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $67
80106294:	6a 43                	push   $0x43
  jmp alltraps
80106296:	e9 cf f8 ff ff       	jmp    80105b6a <alltraps>

8010629b <vector68>:
.globl vector68
vector68:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $68
8010629d:	6a 44                	push   $0x44
  jmp alltraps
8010629f:	e9 c6 f8 ff ff       	jmp    80105b6a <alltraps>

801062a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $69
801062a6:	6a 45                	push   $0x45
  jmp alltraps
801062a8:	e9 bd f8 ff ff       	jmp    80105b6a <alltraps>

801062ad <vector70>:
.globl vector70
vector70:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $70
801062af:	6a 46                	push   $0x46
  jmp alltraps
801062b1:	e9 b4 f8 ff ff       	jmp    80105b6a <alltraps>

801062b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $71
801062b8:	6a 47                	push   $0x47
  jmp alltraps
801062ba:	e9 ab f8 ff ff       	jmp    80105b6a <alltraps>

801062bf <vector72>:
.globl vector72
vector72:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $72
801062c1:	6a 48                	push   $0x48
  jmp alltraps
801062c3:	e9 a2 f8 ff ff       	jmp    80105b6a <alltraps>

801062c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $73
801062ca:	6a 49                	push   $0x49
  jmp alltraps
801062cc:	e9 99 f8 ff ff       	jmp    80105b6a <alltraps>

801062d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $74
801062d3:	6a 4a                	push   $0x4a
  jmp alltraps
801062d5:	e9 90 f8 ff ff       	jmp    80105b6a <alltraps>

801062da <vector75>:
.globl vector75
vector75:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $75
801062dc:	6a 4b                	push   $0x4b
  jmp alltraps
801062de:	e9 87 f8 ff ff       	jmp    80105b6a <alltraps>

801062e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $76
801062e5:	6a 4c                	push   $0x4c
  jmp alltraps
801062e7:	e9 7e f8 ff ff       	jmp    80105b6a <alltraps>

801062ec <vector77>:
.globl vector77
vector77:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $77
801062ee:	6a 4d                	push   $0x4d
  jmp alltraps
801062f0:	e9 75 f8 ff ff       	jmp    80105b6a <alltraps>

801062f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $78
801062f7:	6a 4e                	push   $0x4e
  jmp alltraps
801062f9:	e9 6c f8 ff ff       	jmp    80105b6a <alltraps>

801062fe <vector79>:
.globl vector79
vector79:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $79
80106300:	6a 4f                	push   $0x4f
  jmp alltraps
80106302:	e9 63 f8 ff ff       	jmp    80105b6a <alltraps>

80106307 <vector80>:
.globl vector80
vector80:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $80
80106309:	6a 50                	push   $0x50
  jmp alltraps
8010630b:	e9 5a f8 ff ff       	jmp    80105b6a <alltraps>

80106310 <vector81>:
.globl vector81
vector81:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $81
80106312:	6a 51                	push   $0x51
  jmp alltraps
80106314:	e9 51 f8 ff ff       	jmp    80105b6a <alltraps>

80106319 <vector82>:
.globl vector82
vector82:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $82
8010631b:	6a 52                	push   $0x52
  jmp alltraps
8010631d:	e9 48 f8 ff ff       	jmp    80105b6a <alltraps>

80106322 <vector83>:
.globl vector83
vector83:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $83
80106324:	6a 53                	push   $0x53
  jmp alltraps
80106326:	e9 3f f8 ff ff       	jmp    80105b6a <alltraps>

8010632b <vector84>:
.globl vector84
vector84:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $84
8010632d:	6a 54                	push   $0x54
  jmp alltraps
8010632f:	e9 36 f8 ff ff       	jmp    80105b6a <alltraps>

80106334 <vector85>:
.globl vector85
vector85:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $85
80106336:	6a 55                	push   $0x55
  jmp alltraps
80106338:	e9 2d f8 ff ff       	jmp    80105b6a <alltraps>

8010633d <vector86>:
.globl vector86
vector86:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $86
8010633f:	6a 56                	push   $0x56
  jmp alltraps
80106341:	e9 24 f8 ff ff       	jmp    80105b6a <alltraps>

80106346 <vector87>:
.globl vector87
vector87:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $87
80106348:	6a 57                	push   $0x57
  jmp alltraps
8010634a:	e9 1b f8 ff ff       	jmp    80105b6a <alltraps>

8010634f <vector88>:
.globl vector88
vector88:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $88
80106351:	6a 58                	push   $0x58
  jmp alltraps
80106353:	e9 12 f8 ff ff       	jmp    80105b6a <alltraps>

80106358 <vector89>:
.globl vector89
vector89:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $89
8010635a:	6a 59                	push   $0x59
  jmp alltraps
8010635c:	e9 09 f8 ff ff       	jmp    80105b6a <alltraps>

80106361 <vector90>:
.globl vector90
vector90:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $90
80106363:	6a 5a                	push   $0x5a
  jmp alltraps
80106365:	e9 00 f8 ff ff       	jmp    80105b6a <alltraps>

8010636a <vector91>:
.globl vector91
vector91:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $91
8010636c:	6a 5b                	push   $0x5b
  jmp alltraps
8010636e:	e9 f7 f7 ff ff       	jmp    80105b6a <alltraps>

80106373 <vector92>:
.globl vector92
vector92:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $92
80106375:	6a 5c                	push   $0x5c
  jmp alltraps
80106377:	e9 ee f7 ff ff       	jmp    80105b6a <alltraps>

8010637c <vector93>:
.globl vector93
vector93:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $93
8010637e:	6a 5d                	push   $0x5d
  jmp alltraps
80106380:	e9 e5 f7 ff ff       	jmp    80105b6a <alltraps>

80106385 <vector94>:
.globl vector94
vector94:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $94
80106387:	6a 5e                	push   $0x5e
  jmp alltraps
80106389:	e9 dc f7 ff ff       	jmp    80105b6a <alltraps>

8010638e <vector95>:
.globl vector95
vector95:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $95
80106390:	6a 5f                	push   $0x5f
  jmp alltraps
80106392:	e9 d3 f7 ff ff       	jmp    80105b6a <alltraps>

80106397 <vector96>:
.globl vector96
vector96:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $96
80106399:	6a 60                	push   $0x60
  jmp alltraps
8010639b:	e9 ca f7 ff ff       	jmp    80105b6a <alltraps>

801063a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $97
801063a2:	6a 61                	push   $0x61
  jmp alltraps
801063a4:	e9 c1 f7 ff ff       	jmp    80105b6a <alltraps>

801063a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $98
801063ab:	6a 62                	push   $0x62
  jmp alltraps
801063ad:	e9 b8 f7 ff ff       	jmp    80105b6a <alltraps>

801063b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $99
801063b4:	6a 63                	push   $0x63
  jmp alltraps
801063b6:	e9 af f7 ff ff       	jmp    80105b6a <alltraps>

801063bb <vector100>:
.globl vector100
vector100:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $100
801063bd:	6a 64                	push   $0x64
  jmp alltraps
801063bf:	e9 a6 f7 ff ff       	jmp    80105b6a <alltraps>

801063c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $101
801063c6:	6a 65                	push   $0x65
  jmp alltraps
801063c8:	e9 9d f7 ff ff       	jmp    80105b6a <alltraps>

801063cd <vector102>:
.globl vector102
vector102:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $102
801063cf:	6a 66                	push   $0x66
  jmp alltraps
801063d1:	e9 94 f7 ff ff       	jmp    80105b6a <alltraps>

801063d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $103
801063d8:	6a 67                	push   $0x67
  jmp alltraps
801063da:	e9 8b f7 ff ff       	jmp    80105b6a <alltraps>

801063df <vector104>:
.globl vector104
vector104:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $104
801063e1:	6a 68                	push   $0x68
  jmp alltraps
801063e3:	e9 82 f7 ff ff       	jmp    80105b6a <alltraps>

801063e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $105
801063ea:	6a 69                	push   $0x69
  jmp alltraps
801063ec:	e9 79 f7 ff ff       	jmp    80105b6a <alltraps>

801063f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $106
801063f3:	6a 6a                	push   $0x6a
  jmp alltraps
801063f5:	e9 70 f7 ff ff       	jmp    80105b6a <alltraps>

801063fa <vector107>:
.globl vector107
vector107:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $107
801063fc:	6a 6b                	push   $0x6b
  jmp alltraps
801063fe:	e9 67 f7 ff ff       	jmp    80105b6a <alltraps>

80106403 <vector108>:
.globl vector108
vector108:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $108
80106405:	6a 6c                	push   $0x6c
  jmp alltraps
80106407:	e9 5e f7 ff ff       	jmp    80105b6a <alltraps>

8010640c <vector109>:
.globl vector109
vector109:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $109
8010640e:	6a 6d                	push   $0x6d
  jmp alltraps
80106410:	e9 55 f7 ff ff       	jmp    80105b6a <alltraps>

80106415 <vector110>:
.globl vector110
vector110:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $110
80106417:	6a 6e                	push   $0x6e
  jmp alltraps
80106419:	e9 4c f7 ff ff       	jmp    80105b6a <alltraps>

8010641e <vector111>:
.globl vector111
vector111:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $111
80106420:	6a 6f                	push   $0x6f
  jmp alltraps
80106422:	e9 43 f7 ff ff       	jmp    80105b6a <alltraps>

80106427 <vector112>:
.globl vector112
vector112:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $112
80106429:	6a 70                	push   $0x70
  jmp alltraps
8010642b:	e9 3a f7 ff ff       	jmp    80105b6a <alltraps>

80106430 <vector113>:
.globl vector113
vector113:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $113
80106432:	6a 71                	push   $0x71
  jmp alltraps
80106434:	e9 31 f7 ff ff       	jmp    80105b6a <alltraps>

80106439 <vector114>:
.globl vector114
vector114:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $114
8010643b:	6a 72                	push   $0x72
  jmp alltraps
8010643d:	e9 28 f7 ff ff       	jmp    80105b6a <alltraps>

80106442 <vector115>:
.globl vector115
vector115:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $115
80106444:	6a 73                	push   $0x73
  jmp alltraps
80106446:	e9 1f f7 ff ff       	jmp    80105b6a <alltraps>

8010644b <vector116>:
.globl vector116
vector116:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $116
8010644d:	6a 74                	push   $0x74
  jmp alltraps
8010644f:	e9 16 f7 ff ff       	jmp    80105b6a <alltraps>

80106454 <vector117>:
.globl vector117
vector117:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $117
80106456:	6a 75                	push   $0x75
  jmp alltraps
80106458:	e9 0d f7 ff ff       	jmp    80105b6a <alltraps>

8010645d <vector118>:
.globl vector118
vector118:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $118
8010645f:	6a 76                	push   $0x76
  jmp alltraps
80106461:	e9 04 f7 ff ff       	jmp    80105b6a <alltraps>

80106466 <vector119>:
.globl vector119
vector119:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $119
80106468:	6a 77                	push   $0x77
  jmp alltraps
8010646a:	e9 fb f6 ff ff       	jmp    80105b6a <alltraps>

8010646f <vector120>:
.globl vector120
vector120:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $120
80106471:	6a 78                	push   $0x78
  jmp alltraps
80106473:	e9 f2 f6 ff ff       	jmp    80105b6a <alltraps>

80106478 <vector121>:
.globl vector121
vector121:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $121
8010647a:	6a 79                	push   $0x79
  jmp alltraps
8010647c:	e9 e9 f6 ff ff       	jmp    80105b6a <alltraps>

80106481 <vector122>:
.globl vector122
vector122:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $122
80106483:	6a 7a                	push   $0x7a
  jmp alltraps
80106485:	e9 e0 f6 ff ff       	jmp    80105b6a <alltraps>

8010648a <vector123>:
.globl vector123
vector123:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $123
8010648c:	6a 7b                	push   $0x7b
  jmp alltraps
8010648e:	e9 d7 f6 ff ff       	jmp    80105b6a <alltraps>

80106493 <vector124>:
.globl vector124
vector124:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $124
80106495:	6a 7c                	push   $0x7c
  jmp alltraps
80106497:	e9 ce f6 ff ff       	jmp    80105b6a <alltraps>

8010649c <vector125>:
.globl vector125
vector125:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $125
8010649e:	6a 7d                	push   $0x7d
  jmp alltraps
801064a0:	e9 c5 f6 ff ff       	jmp    80105b6a <alltraps>

801064a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $126
801064a7:	6a 7e                	push   $0x7e
  jmp alltraps
801064a9:	e9 bc f6 ff ff       	jmp    80105b6a <alltraps>

801064ae <vector127>:
.globl vector127
vector127:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $127
801064b0:	6a 7f                	push   $0x7f
  jmp alltraps
801064b2:	e9 b3 f6 ff ff       	jmp    80105b6a <alltraps>

801064b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $128
801064b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064be:	e9 a7 f6 ff ff       	jmp    80105b6a <alltraps>

801064c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $129
801064c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064ca:	e9 9b f6 ff ff       	jmp    80105b6a <alltraps>

801064cf <vector130>:
.globl vector130
vector130:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $130
801064d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064d6:	e9 8f f6 ff ff       	jmp    80105b6a <alltraps>

801064db <vector131>:
.globl vector131
vector131:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $131
801064dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064e2:	e9 83 f6 ff ff       	jmp    80105b6a <alltraps>

801064e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $132
801064e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064ee:	e9 77 f6 ff ff       	jmp    80105b6a <alltraps>

801064f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $133
801064f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064fa:	e9 6b f6 ff ff       	jmp    80105b6a <alltraps>

801064ff <vector134>:
.globl vector134
vector134:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $134
80106501:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106506:	e9 5f f6 ff ff       	jmp    80105b6a <alltraps>

8010650b <vector135>:
.globl vector135
vector135:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $135
8010650d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106512:	e9 53 f6 ff ff       	jmp    80105b6a <alltraps>

80106517 <vector136>:
.globl vector136
vector136:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $136
80106519:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010651e:	e9 47 f6 ff ff       	jmp    80105b6a <alltraps>

80106523 <vector137>:
.globl vector137
vector137:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $137
80106525:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010652a:	e9 3b f6 ff ff       	jmp    80105b6a <alltraps>

8010652f <vector138>:
.globl vector138
vector138:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $138
80106531:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106536:	e9 2f f6 ff ff       	jmp    80105b6a <alltraps>

8010653b <vector139>:
.globl vector139
vector139:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $139
8010653d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106542:	e9 23 f6 ff ff       	jmp    80105b6a <alltraps>

80106547 <vector140>:
.globl vector140
vector140:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $140
80106549:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010654e:	e9 17 f6 ff ff       	jmp    80105b6a <alltraps>

80106553 <vector141>:
.globl vector141
vector141:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $141
80106555:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010655a:	e9 0b f6 ff ff       	jmp    80105b6a <alltraps>

8010655f <vector142>:
.globl vector142
vector142:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $142
80106561:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106566:	e9 ff f5 ff ff       	jmp    80105b6a <alltraps>

8010656b <vector143>:
.globl vector143
vector143:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $143
8010656d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106572:	e9 f3 f5 ff ff       	jmp    80105b6a <alltraps>

80106577 <vector144>:
.globl vector144
vector144:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $144
80106579:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010657e:	e9 e7 f5 ff ff       	jmp    80105b6a <alltraps>

80106583 <vector145>:
.globl vector145
vector145:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $145
80106585:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010658a:	e9 db f5 ff ff       	jmp    80105b6a <alltraps>

8010658f <vector146>:
.globl vector146
vector146:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $146
80106591:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106596:	e9 cf f5 ff ff       	jmp    80105b6a <alltraps>

8010659b <vector147>:
.globl vector147
vector147:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $147
8010659d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801065a2:	e9 c3 f5 ff ff       	jmp    80105b6a <alltraps>

801065a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $148
801065a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801065ae:	e9 b7 f5 ff ff       	jmp    80105b6a <alltraps>

801065b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $149
801065b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065ba:	e9 ab f5 ff ff       	jmp    80105b6a <alltraps>

801065bf <vector150>:
.globl vector150
vector150:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $150
801065c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065c6:	e9 9f f5 ff ff       	jmp    80105b6a <alltraps>

801065cb <vector151>:
.globl vector151
vector151:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $151
801065cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065d2:	e9 93 f5 ff ff       	jmp    80105b6a <alltraps>

801065d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $152
801065d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065de:	e9 87 f5 ff ff       	jmp    80105b6a <alltraps>

801065e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $153
801065e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065ea:	e9 7b f5 ff ff       	jmp    80105b6a <alltraps>

801065ef <vector154>:
.globl vector154
vector154:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $154
801065f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065f6:	e9 6f f5 ff ff       	jmp    80105b6a <alltraps>

801065fb <vector155>:
.globl vector155
vector155:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $155
801065fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106602:	e9 63 f5 ff ff       	jmp    80105b6a <alltraps>

80106607 <vector156>:
.globl vector156
vector156:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $156
80106609:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010660e:	e9 57 f5 ff ff       	jmp    80105b6a <alltraps>

80106613 <vector157>:
.globl vector157
vector157:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $157
80106615:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010661a:	e9 4b f5 ff ff       	jmp    80105b6a <alltraps>

8010661f <vector158>:
.globl vector158
vector158:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $158
80106621:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106626:	e9 3f f5 ff ff       	jmp    80105b6a <alltraps>

8010662b <vector159>:
.globl vector159
vector159:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $159
8010662d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106632:	e9 33 f5 ff ff       	jmp    80105b6a <alltraps>

80106637 <vector160>:
.globl vector160
vector160:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $160
80106639:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010663e:	e9 27 f5 ff ff       	jmp    80105b6a <alltraps>

80106643 <vector161>:
.globl vector161
vector161:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $161
80106645:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010664a:	e9 1b f5 ff ff       	jmp    80105b6a <alltraps>

8010664f <vector162>:
.globl vector162
vector162:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $162
80106651:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106656:	e9 0f f5 ff ff       	jmp    80105b6a <alltraps>

8010665b <vector163>:
.globl vector163
vector163:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $163
8010665d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106662:	e9 03 f5 ff ff       	jmp    80105b6a <alltraps>

80106667 <vector164>:
.globl vector164
vector164:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $164
80106669:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010666e:	e9 f7 f4 ff ff       	jmp    80105b6a <alltraps>

80106673 <vector165>:
.globl vector165
vector165:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $165
80106675:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010667a:	e9 eb f4 ff ff       	jmp    80105b6a <alltraps>

8010667f <vector166>:
.globl vector166
vector166:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $166
80106681:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106686:	e9 df f4 ff ff       	jmp    80105b6a <alltraps>

8010668b <vector167>:
.globl vector167
vector167:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $167
8010668d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106692:	e9 d3 f4 ff ff       	jmp    80105b6a <alltraps>

80106697 <vector168>:
.globl vector168
vector168:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $168
80106699:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010669e:	e9 c7 f4 ff ff       	jmp    80105b6a <alltraps>

801066a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $169
801066a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801066aa:	e9 bb f4 ff ff       	jmp    80105b6a <alltraps>

801066af <vector170>:
.globl vector170
vector170:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $170
801066b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066b6:	e9 af f4 ff ff       	jmp    80105b6a <alltraps>

801066bb <vector171>:
.globl vector171
vector171:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $171
801066bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066c2:	e9 a3 f4 ff ff       	jmp    80105b6a <alltraps>

801066c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $172
801066c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066ce:	e9 97 f4 ff ff       	jmp    80105b6a <alltraps>

801066d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $173
801066d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066da:	e9 8b f4 ff ff       	jmp    80105b6a <alltraps>

801066df <vector174>:
.globl vector174
vector174:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $174
801066e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066e6:	e9 7f f4 ff ff       	jmp    80105b6a <alltraps>

801066eb <vector175>:
.globl vector175
vector175:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $175
801066ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066f2:	e9 73 f4 ff ff       	jmp    80105b6a <alltraps>

801066f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $176
801066f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066fe:	e9 67 f4 ff ff       	jmp    80105b6a <alltraps>

80106703 <vector177>:
.globl vector177
vector177:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $177
80106705:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010670a:	e9 5b f4 ff ff       	jmp    80105b6a <alltraps>

8010670f <vector178>:
.globl vector178
vector178:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $178
80106711:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106716:	e9 4f f4 ff ff       	jmp    80105b6a <alltraps>

8010671b <vector179>:
.globl vector179
vector179:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $179
8010671d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106722:	e9 43 f4 ff ff       	jmp    80105b6a <alltraps>

80106727 <vector180>:
.globl vector180
vector180:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $180
80106729:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010672e:	e9 37 f4 ff ff       	jmp    80105b6a <alltraps>

80106733 <vector181>:
.globl vector181
vector181:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $181
80106735:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010673a:	e9 2b f4 ff ff       	jmp    80105b6a <alltraps>

8010673f <vector182>:
.globl vector182
vector182:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $182
80106741:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106746:	e9 1f f4 ff ff       	jmp    80105b6a <alltraps>

8010674b <vector183>:
.globl vector183
vector183:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $183
8010674d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106752:	e9 13 f4 ff ff       	jmp    80105b6a <alltraps>

80106757 <vector184>:
.globl vector184
vector184:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $184
80106759:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010675e:	e9 07 f4 ff ff       	jmp    80105b6a <alltraps>

80106763 <vector185>:
.globl vector185
vector185:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $185
80106765:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010676a:	e9 fb f3 ff ff       	jmp    80105b6a <alltraps>

8010676f <vector186>:
.globl vector186
vector186:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $186
80106771:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106776:	e9 ef f3 ff ff       	jmp    80105b6a <alltraps>

8010677b <vector187>:
.globl vector187
vector187:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $187
8010677d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106782:	e9 e3 f3 ff ff       	jmp    80105b6a <alltraps>

80106787 <vector188>:
.globl vector188
vector188:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $188
80106789:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010678e:	e9 d7 f3 ff ff       	jmp    80105b6a <alltraps>

80106793 <vector189>:
.globl vector189
vector189:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $189
80106795:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010679a:	e9 cb f3 ff ff       	jmp    80105b6a <alltraps>

8010679f <vector190>:
.globl vector190
vector190:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $190
801067a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801067a6:	e9 bf f3 ff ff       	jmp    80105b6a <alltraps>

801067ab <vector191>:
.globl vector191
vector191:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $191
801067ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067b2:	e9 b3 f3 ff ff       	jmp    80105b6a <alltraps>

801067b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $192
801067b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067be:	e9 a7 f3 ff ff       	jmp    80105b6a <alltraps>

801067c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $193
801067c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067ca:	e9 9b f3 ff ff       	jmp    80105b6a <alltraps>

801067cf <vector194>:
.globl vector194
vector194:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $194
801067d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067d6:	e9 8f f3 ff ff       	jmp    80105b6a <alltraps>

801067db <vector195>:
.globl vector195
vector195:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $195
801067dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067e2:	e9 83 f3 ff ff       	jmp    80105b6a <alltraps>

801067e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $196
801067e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067ee:	e9 77 f3 ff ff       	jmp    80105b6a <alltraps>

801067f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $197
801067f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067fa:	e9 6b f3 ff ff       	jmp    80105b6a <alltraps>

801067ff <vector198>:
.globl vector198
vector198:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $198
80106801:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106806:	e9 5f f3 ff ff       	jmp    80105b6a <alltraps>

8010680b <vector199>:
.globl vector199
vector199:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $199
8010680d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106812:	e9 53 f3 ff ff       	jmp    80105b6a <alltraps>

80106817 <vector200>:
.globl vector200
vector200:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $200
80106819:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010681e:	e9 47 f3 ff ff       	jmp    80105b6a <alltraps>

80106823 <vector201>:
.globl vector201
vector201:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $201
80106825:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010682a:	e9 3b f3 ff ff       	jmp    80105b6a <alltraps>

8010682f <vector202>:
.globl vector202
vector202:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $202
80106831:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106836:	e9 2f f3 ff ff       	jmp    80105b6a <alltraps>

8010683b <vector203>:
.globl vector203
vector203:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $203
8010683d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106842:	e9 23 f3 ff ff       	jmp    80105b6a <alltraps>

80106847 <vector204>:
.globl vector204
vector204:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $204
80106849:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010684e:	e9 17 f3 ff ff       	jmp    80105b6a <alltraps>

80106853 <vector205>:
.globl vector205
vector205:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $205
80106855:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010685a:	e9 0b f3 ff ff       	jmp    80105b6a <alltraps>

8010685f <vector206>:
.globl vector206
vector206:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $206
80106861:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106866:	e9 ff f2 ff ff       	jmp    80105b6a <alltraps>

8010686b <vector207>:
.globl vector207
vector207:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $207
8010686d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106872:	e9 f3 f2 ff ff       	jmp    80105b6a <alltraps>

80106877 <vector208>:
.globl vector208
vector208:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $208
80106879:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010687e:	e9 e7 f2 ff ff       	jmp    80105b6a <alltraps>

80106883 <vector209>:
.globl vector209
vector209:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $209
80106885:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010688a:	e9 db f2 ff ff       	jmp    80105b6a <alltraps>

8010688f <vector210>:
.globl vector210
vector210:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $210
80106891:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106896:	e9 cf f2 ff ff       	jmp    80105b6a <alltraps>

8010689b <vector211>:
.globl vector211
vector211:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $211
8010689d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801068a2:	e9 c3 f2 ff ff       	jmp    80105b6a <alltraps>

801068a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $212
801068a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801068ae:	e9 b7 f2 ff ff       	jmp    80105b6a <alltraps>

801068b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $213
801068b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068ba:	e9 ab f2 ff ff       	jmp    80105b6a <alltraps>

801068bf <vector214>:
.globl vector214
vector214:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $214
801068c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068c6:	e9 9f f2 ff ff       	jmp    80105b6a <alltraps>

801068cb <vector215>:
.globl vector215
vector215:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $215
801068cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068d2:	e9 93 f2 ff ff       	jmp    80105b6a <alltraps>

801068d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $216
801068d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068de:	e9 87 f2 ff ff       	jmp    80105b6a <alltraps>

801068e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $217
801068e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068ea:	e9 7b f2 ff ff       	jmp    80105b6a <alltraps>

801068ef <vector218>:
.globl vector218
vector218:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $218
801068f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068f6:	e9 6f f2 ff ff       	jmp    80105b6a <alltraps>

801068fb <vector219>:
.globl vector219
vector219:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $219
801068fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106902:	e9 63 f2 ff ff       	jmp    80105b6a <alltraps>

80106907 <vector220>:
.globl vector220
vector220:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $220
80106909:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010690e:	e9 57 f2 ff ff       	jmp    80105b6a <alltraps>

80106913 <vector221>:
.globl vector221
vector221:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $221
80106915:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010691a:	e9 4b f2 ff ff       	jmp    80105b6a <alltraps>

8010691f <vector222>:
.globl vector222
vector222:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $222
80106921:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106926:	e9 3f f2 ff ff       	jmp    80105b6a <alltraps>

8010692b <vector223>:
.globl vector223
vector223:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $223
8010692d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106932:	e9 33 f2 ff ff       	jmp    80105b6a <alltraps>

80106937 <vector224>:
.globl vector224
vector224:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $224
80106939:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010693e:	e9 27 f2 ff ff       	jmp    80105b6a <alltraps>

80106943 <vector225>:
.globl vector225
vector225:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $225
80106945:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010694a:	e9 1b f2 ff ff       	jmp    80105b6a <alltraps>

8010694f <vector226>:
.globl vector226
vector226:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $226
80106951:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106956:	e9 0f f2 ff ff       	jmp    80105b6a <alltraps>

8010695b <vector227>:
.globl vector227
vector227:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $227
8010695d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106962:	e9 03 f2 ff ff       	jmp    80105b6a <alltraps>

80106967 <vector228>:
.globl vector228
vector228:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $228
80106969:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010696e:	e9 f7 f1 ff ff       	jmp    80105b6a <alltraps>

80106973 <vector229>:
.globl vector229
vector229:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $229
80106975:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010697a:	e9 eb f1 ff ff       	jmp    80105b6a <alltraps>

8010697f <vector230>:
.globl vector230
vector230:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $230
80106981:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106986:	e9 df f1 ff ff       	jmp    80105b6a <alltraps>

8010698b <vector231>:
.globl vector231
vector231:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $231
8010698d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106992:	e9 d3 f1 ff ff       	jmp    80105b6a <alltraps>

80106997 <vector232>:
.globl vector232
vector232:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $232
80106999:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010699e:	e9 c7 f1 ff ff       	jmp    80105b6a <alltraps>

801069a3 <vector233>:
.globl vector233
vector233:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $233
801069a5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801069aa:	e9 bb f1 ff ff       	jmp    80105b6a <alltraps>

801069af <vector234>:
.globl vector234
vector234:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $234
801069b1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069b6:	e9 af f1 ff ff       	jmp    80105b6a <alltraps>

801069bb <vector235>:
.globl vector235
vector235:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $235
801069bd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069c2:	e9 a3 f1 ff ff       	jmp    80105b6a <alltraps>

801069c7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $236
801069c9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069ce:	e9 97 f1 ff ff       	jmp    80105b6a <alltraps>

801069d3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $237
801069d5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069da:	e9 8b f1 ff ff       	jmp    80105b6a <alltraps>

801069df <vector238>:
.globl vector238
vector238:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $238
801069e1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069e6:	e9 7f f1 ff ff       	jmp    80105b6a <alltraps>

801069eb <vector239>:
.globl vector239
vector239:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $239
801069ed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069f2:	e9 73 f1 ff ff       	jmp    80105b6a <alltraps>

801069f7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $240
801069f9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069fe:	e9 67 f1 ff ff       	jmp    80105b6a <alltraps>

80106a03 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $241
80106a05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a0a:	e9 5b f1 ff ff       	jmp    80105b6a <alltraps>

80106a0f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $242
80106a11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a16:	e9 4f f1 ff ff       	jmp    80105b6a <alltraps>

80106a1b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $243
80106a1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a22:	e9 43 f1 ff ff       	jmp    80105b6a <alltraps>

80106a27 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $244
80106a29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a2e:	e9 37 f1 ff ff       	jmp    80105b6a <alltraps>

80106a33 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $245
80106a35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a3a:	e9 2b f1 ff ff       	jmp    80105b6a <alltraps>

80106a3f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $246
80106a41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a46:	e9 1f f1 ff ff       	jmp    80105b6a <alltraps>

80106a4b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $247
80106a4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a52:	e9 13 f1 ff ff       	jmp    80105b6a <alltraps>

80106a57 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $248
80106a59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a5e:	e9 07 f1 ff ff       	jmp    80105b6a <alltraps>

80106a63 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $249
80106a65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a6a:	e9 fb f0 ff ff       	jmp    80105b6a <alltraps>

80106a6f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $250
80106a71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a76:	e9 ef f0 ff ff       	jmp    80105b6a <alltraps>

80106a7b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $251
80106a7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a82:	e9 e3 f0 ff ff       	jmp    80105b6a <alltraps>

80106a87 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $252
80106a89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a8e:	e9 d7 f0 ff ff       	jmp    80105b6a <alltraps>

80106a93 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $253
80106a95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a9a:	e9 cb f0 ff ff       	jmp    80105b6a <alltraps>

80106a9f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $254
80106aa1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106aa6:	e9 bf f0 ff ff       	jmp    80105b6a <alltraps>

80106aab <vector255>:
.globl vector255
vector255:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $255
80106aad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ab2:	e9 b3 f0 ff ff       	jmp    80105b6a <alltraps>
80106ab7:	66 90                	xchg   %ax,%ax
80106ab9:	66 90                	xchg   %ax,%ax
80106abb:	66 90                	xchg   %ax,%ax
80106abd:	66 90                	xchg   %ax,%ax
80106abf:	90                   	nop

80106ac0 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80106ac6:	89 d3                	mov    %edx,%ebx
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106ac8:	89 d7                	mov    %edx,%edi
    pde = &pgdir[PDX(va)];
80106aca:	c1 eb 16             	shr    $0x16,%ebx
80106acd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106ad0:	83 ec 0c             	sub    $0xc,%esp
    if (*pde & PTE_P) {
80106ad3:	8b 06                	mov    (%esi),%eax
80106ad5:	a8 01                	test   $0x1,%al
80106ad7:	74 27                	je     80106b00 <walkpgdir+0x40>
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
80106ad9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ade:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
80106ae4:	c1 ef 0a             	shr    $0xa,%edi
}
80106ae7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return &pgtab[PTX(va)];
80106aea:	89 fa                	mov    %edi,%edx
80106aec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106af2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106af5:	5b                   	pop    %ebx
80106af6:	5e                   	pop    %esi
80106af7:	5f                   	pop    %edi
80106af8:	5d                   	pop    %ebp
80106af9:	c3                   	ret    
80106afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!alloc || (pgtab = (pte_t *) kalloc()) == 0)
80106b00:	85 c9                	test   %ecx,%ecx
80106b02:	74 2c                	je     80106b30 <walkpgdir+0x70>
80106b04:	e8 f7 bd ff ff       	call   80102900 <kalloc>
80106b09:	85 c0                	test   %eax,%eax
80106b0b:	89 c3                	mov    %eax,%ebx
80106b0d:	74 21                	je     80106b30 <walkpgdir+0x70>
        memset(pgtab, 0, PGSIZE);
80106b0f:	83 ec 04             	sub    $0x4,%esp
80106b12:	68 00 10 00 00       	push   $0x1000
80106b17:	6a 00                	push   $0x0
80106b19:	50                   	push   %eax
80106b1a:	e8 21 de ff ff       	call   80104940 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b1f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b25:	83 c4 10             	add    $0x10,%esp
80106b28:	83 c8 07             	or     $0x7,%eax
80106b2b:	89 06                	mov    %eax,(%esi)
80106b2d:	eb b5                	jmp    80106ae4 <walkpgdir+0x24>
80106b2f:	90                   	nop
}
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80106b33:	31 c0                	xor    %eax,%eax
}
80106b35:	5b                   	pop    %ebx
80106b36:	5e                   	pop    %esi
80106b37:	5f                   	pop    %edi
80106b38:	5d                   	pop    %ebp
80106b39:	c3                   	ret    
80106b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b40 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	53                   	push   %ebx
    char *a, *last;
    pte_t *pte;

    a = (char *) PGROUNDDOWN((uint) va);
80106b46:	89 d3                	mov    %edx,%ebx
80106b48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80106b4e:	83 ec 1c             	sub    $0x1c,%esp
80106b51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
80106b54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b58:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b60:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
            panic("remap");
        *pte = pa | perm | PTE_P;
80106b63:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b66:	29 df                	sub    %ebx,%edi
80106b68:	83 c8 01             	or     $0x1,%eax
80106b6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b6e:	eb 15                	jmp    80106b85 <mappages+0x45>
        if (*pte & PTE_P)
80106b70:	f6 00 01             	testb  $0x1,(%eax)
80106b73:	75 45                	jne    80106bba <mappages+0x7a>
        *pte = pa | perm | PTE_P;
80106b75:	0b 75 dc             	or     -0x24(%ebp),%esi
        if (a == last)
80106b78:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
        *pte = pa | perm | PTE_P;
80106b7b:	89 30                	mov    %esi,(%eax)
        if (a == last)
80106b7d:	74 31                	je     80106bb0 <mappages+0x70>
            break;
        a += PGSIZE;
80106b7f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b88:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b8d:	89 da                	mov    %ebx,%edx
80106b8f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b92:	e8 29 ff ff ff       	call   80106ac0 <walkpgdir>
80106b97:	85 c0                	test   %eax,%eax
80106b99:	75 d5                	jne    80106b70 <mappages+0x30>
        pa += PGSIZE;
    }
    return 0;
}
80106b9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80106b9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ba3:	5b                   	pop    %ebx
80106ba4:	5e                   	pop    %esi
80106ba5:	5f                   	pop    %edi
80106ba6:	5d                   	pop    %ebp
80106ba7:	c3                   	ret    
80106ba8:	90                   	nop
80106ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106bb3:	31 c0                	xor    %eax,%eax
}
80106bb5:	5b                   	pop    %ebx
80106bb6:	5e                   	pop    %esi
80106bb7:	5f                   	pop    %edi
80106bb8:	5d                   	pop    %ebp
80106bb9:	c3                   	ret    
            panic("remap");
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	68 08 7e 10 80       	push   $0x80107e08
80106bc2:	e8 c9 97 ff ff       	call   80100390 <panic>
80106bc7:	89 f6                	mov    %esi,%esi
80106bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bd0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int growproc) {
80106bd0:	55                   	push   %ebp
80106bd1:	89 e5                	mov    %esp,%ebp
80106bd3:	57                   	push   %edi
80106bd4:	56                   	push   %esi
80106bd5:	53                   	push   %ebx
        if (DEBUGMODE == 2 && notShell())
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
80106bd6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int growproc) {
80106bdc:	89 c7                	mov    %eax,%edi
    a = PGROUNDUP(newsz);
80106bde:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int growproc) {
80106be4:	83 ec 1c             	sub    $0x1c,%esp
80106be7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    for (; a < oldsz; a += PGSIZE) {
80106bea:	39 d3                	cmp    %edx,%ebx
80106bec:	73 66                	jae    80106c54 <deallocuvm.part.0+0x84>
80106bee:	89 d6                	mov    %edx,%esi
80106bf0:	eb 3d                	jmp    80106c2f <deallocuvm.part.0+0x5f>
80106bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pte = walkpgdir(pgdir, (char *) a, 0);
        if (!pte)
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        else if ((*pte & PTE_P) != 0) {
80106bf8:	8b 10                	mov    (%eax),%edx
80106bfa:	f6 c2 01             	test   $0x1,%dl
80106bfd:	74 26                	je     80106c25 <deallocuvm.part.0+0x55>
            pa = PTE_ADDR(*pte);
            if (pa == 0)
80106bff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c05:	74 58                	je     80106c5f <deallocuvm.part.0+0x8f>
                }
#endif


            char *v = P2V(pa);
            kfree(v);
80106c07:	83 ec 0c             	sub    $0xc,%esp
            char *v = P2V(pa);
80106c0a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            kfree(v);
80106c13:	52                   	push   %edx
80106c14:	e8 37 bb ff ff       	call   80102750 <kfree>
            *pte = 0;
80106c19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c1c:	83 c4 10             	add    $0x10,%esp
80106c1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; a < oldsz; a += PGSIZE) {
80106c25:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c2b:	39 f3                	cmp    %esi,%ebx
80106c2d:	73 25                	jae    80106c54 <deallocuvm.part.0+0x84>
        pte = walkpgdir(pgdir, (char *) a, 0);
80106c2f:	31 c9                	xor    %ecx,%ecx
80106c31:	89 da                	mov    %ebx,%edx
80106c33:	89 f8                	mov    %edi,%eax
80106c35:	e8 86 fe ff ff       	call   80106ac0 <walkpgdir>
        if (!pte)
80106c3a:	85 c0                	test   %eax,%eax
80106c3c:	75 ba                	jne    80106bf8 <deallocuvm.part.0+0x28>
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c3e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c44:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
    for (; a < oldsz; a += PGSIZE) {
80106c4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c50:	39 f3                	cmp    %esi,%ebx
80106c52:	72 db                	jb     80106c2f <deallocuvm.part.0+0x5f>
        }
    }
    if (DEBUGMODE == 2 && notShell())
        cprintf(">DEALLOCUVM-DONE!\t");
    return newsz;
}
80106c54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c5a:	5b                   	pop    %ebx
80106c5b:	5e                   	pop    %esi
80106c5c:	5f                   	pop    %edi
80106c5d:	5d                   	pop    %ebp
80106c5e:	c3                   	ret    
                panic("kfree");
80106c5f:	83 ec 0c             	sub    $0xc,%esp
80106c62:	68 8e 77 10 80       	push   $0x8010778e
80106c67:	e8 24 97 ff ff       	call   80100390 <panic>
80106c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c70 <seginit>:
seginit(void) {
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
80106c76:	e8 a5 cf ff ff       	call   80103c20 <cpuid>
80106c7b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106c81:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
80106c8a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106c91:	ff 00 00 
80106c94:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106c9b:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c9e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106ca5:	ff 00 00 
80106ca8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106caf:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80106cb2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106cb9:	ff 00 00 
80106cbc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106cc3:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cc6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106ccd:	ff 00 00 
80106cd0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106cd7:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
80106cda:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106cdf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ce3:	c1 e8 10             	shr    $0x10,%eax
80106ce6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ced:	0f 01 10             	lgdtl  (%eax)
}
80106cf0:	c9                   	leave  
80106cf1:	c3                   	ret    
80106cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d00 <walkpgdir2>:
walkpgdir2(pde_t *pgdir, const void *va, int alloc) {
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
    return walkpgdir(pgdir, va, alloc);
80106d03:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d06:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d09:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106d0c:	5d                   	pop    %ebp
    return walkpgdir(pgdir, va, alloc);
80106d0d:	e9 ae fd ff ff       	jmp    80106ac0 <walkpgdir>
80106d12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d20 <mappages2>:
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
    return mappages(pgdir, va, size, pa, perm);
80106d23:	8b 4d 18             	mov    0x18(%ebp),%ecx
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80106d26:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d29:	8b 45 08             	mov    0x8(%ebp),%eax
    return mappages(pgdir, va, size, pa, perm);
80106d2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106d2f:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106d32:	89 4d 08             	mov    %ecx,0x8(%ebp)
80106d35:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
80106d38:	5d                   	pop    %ebp
    return mappages(pgdir, va, size, pa, perm);
80106d39:	e9 02 fe ff ff       	jmp    80106b40 <mappages>
80106d3e:	66 90                	xchg   %ax,%ax

80106d40 <switchkvm>:
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d40:	a1 e8 5c 12 80       	mov    0x80125ce8,%eax
switchkvm(void) {
80106d45:	55                   	push   %ebp
80106d46:	89 e5                	mov    %esp,%ebp
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d48:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d4d:	0f 22 d8             	mov    %eax,%cr3
}
80106d50:	5d                   	pop    %ebp
80106d51:	c3                   	ret    
80106d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d60 <switchuvm>:
switchuvm(struct proc *p) {
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 1c             	sub    $0x1c,%esp
80106d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (p == 0)
80106d6c:	85 db                	test   %ebx,%ebx
80106d6e:	0f 84 cb 00 00 00    	je     80106e3f <switchuvm+0xdf>
    if (p->kstack == 0)
80106d74:	8b 43 08             	mov    0x8(%ebx),%eax
80106d77:	85 c0                	test   %eax,%eax
80106d79:	0f 84 da 00 00 00    	je     80106e59 <switchuvm+0xf9>
    if (p->pgdir == 0)
80106d7f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d82:	85 c0                	test   %eax,%eax
80106d84:	0f 84 c2 00 00 00    	je     80106e4c <switchuvm+0xec>
    pushcli();
80106d8a:	e8 f1 d9 ff ff       	call   80104780 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d8f:	e8 0c ce ff ff       	call   80103ba0 <mycpu>
80106d94:	89 c6                	mov    %eax,%esi
80106d96:	e8 05 ce ff ff       	call   80103ba0 <mycpu>
80106d9b:	89 c7                	mov    %eax,%edi
80106d9d:	e8 fe cd ff ff       	call   80103ba0 <mycpu>
80106da2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106da5:	83 c7 08             	add    $0x8,%edi
80106da8:	e8 f3 cd ff ff       	call   80103ba0 <mycpu>
80106dad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106db0:	83 c0 08             	add    $0x8,%eax
80106db3:	ba 67 00 00 00       	mov    $0x67,%edx
80106db8:	c1 e8 18             	shr    $0x18,%eax
80106dbb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106dc2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106dc9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dcf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dd4:	83 c1 08             	add    $0x8,%ecx
80106dd7:	c1 e9 10             	shr    $0x10,%ecx
80106dda:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106de0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106de5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dec:	be 10 00 00 00       	mov    $0x10,%esi
    mycpu()->gdt[SEG_TSS].s = 0;
80106df1:	e8 aa cd ff ff       	call   80103ba0 <mycpu>
80106df6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dfd:	e8 9e cd ff ff       	call   80103ba0 <mycpu>
80106e02:	66 89 70 10          	mov    %si,0x10(%eax)
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
80106e06:	8b 73 08             	mov    0x8(%ebx),%esi
80106e09:	e8 92 cd ff ff       	call   80103ba0 <mycpu>
80106e0e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e14:	89 70 0c             	mov    %esi,0xc(%eax)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e17:	e8 84 cd ff ff       	call   80103ba0 <mycpu>
80106e1c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e20:	b8 28 00 00 00       	mov    $0x28,%eax
80106e25:	0f 00 d8             	ltr    %ax
    lcr3(V2P(p->pgdir));  // switch to process's address space
80106e28:	8b 43 04             	mov    0x4(%ebx),%eax
80106e2b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e30:	0f 22 d8             	mov    %eax,%cr3
}
80106e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e36:	5b                   	pop    %ebx
80106e37:	5e                   	pop    %esi
80106e38:	5f                   	pop    %edi
80106e39:	5d                   	pop    %ebp
    popcli();
80106e3a:	e9 41 da ff ff       	jmp    80104880 <popcli>
        panic("switchuvm: no process");
80106e3f:	83 ec 0c             	sub    $0xc,%esp
80106e42:	68 0e 7e 10 80       	push   $0x80107e0e
80106e47:	e8 44 95 ff ff       	call   80100390 <panic>
        panic("switchuvm: no pgdir");
80106e4c:	83 ec 0c             	sub    $0xc,%esp
80106e4f:	68 39 7e 10 80       	push   $0x80107e39
80106e54:	e8 37 95 ff ff       	call   80100390 <panic>
        panic("switchuvm: no kstack");
80106e59:	83 ec 0c             	sub    $0xc,%esp
80106e5c:	68 24 7e 10 80       	push   $0x80107e24
80106e61:	e8 2a 95 ff ff       	call   80100390 <panic>
80106e66:	8d 76 00             	lea    0x0(%esi),%esi
80106e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e70 <inituvm>:
inituvm(pde_t *pgdir, char *init, uint sz) {
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
80106e76:	83 ec 1c             	sub    $0x1c,%esp
80106e79:	8b 75 10             	mov    0x10(%ebp),%esi
80106e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7f:	8b 7d 0c             	mov    0xc(%ebp),%edi
    if (sz >= PGSIZE)
80106e82:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
inituvm(pde_t *pgdir, char *init, uint sz) {
80106e88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE)
80106e8b:	77 49                	ja     80106ed6 <inituvm+0x66>
    mem = kalloc();
80106e8d:	e8 6e ba ff ff       	call   80102900 <kalloc>
    memset(mem, 0, PGSIZE);
80106e92:	83 ec 04             	sub    $0x4,%esp
    mem = kalloc();
80106e95:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80106e97:	68 00 10 00 00       	push   $0x1000
80106e9c:	6a 00                	push   $0x0
80106e9e:	50                   	push   %eax
80106e9f:	e8 9c da ff ff       	call   80104940 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80106ea4:	58                   	pop    %eax
80106ea5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106eab:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106eb0:	5a                   	pop    %edx
80106eb1:	6a 06                	push   $0x6
80106eb3:	50                   	push   %eax
80106eb4:	31 d2                	xor    %edx,%edx
80106eb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106eb9:	e8 82 fc ff ff       	call   80106b40 <mappages>
    memmove(mem, init, sz);
80106ebe:	89 75 10             	mov    %esi,0x10(%ebp)
80106ec1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106ec4:	83 c4 10             	add    $0x10,%esp
80106ec7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ecd:	5b                   	pop    %ebx
80106ece:	5e                   	pop    %esi
80106ecf:	5f                   	pop    %edi
80106ed0:	5d                   	pop    %ebp
    memmove(mem, init, sz);
80106ed1:	e9 1a db ff ff       	jmp    801049f0 <memmove>
        panic("inituvm: more than a page");
80106ed6:	83 ec 0c             	sub    $0xc,%esp
80106ed9:	68 4d 7e 10 80       	push   $0x80107e4d
80106ede:	e8 ad 94 ff ff       	call   80100390 <panic>
80106ee3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ef0 <loaduvm>:
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 0c             	sub    $0xc,%esp
    if ((uint) addr % PGSIZE != 0)
80106ef9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106f00:	0f 85 91 00 00 00    	jne    80106f97 <loaduvm+0xa7>
    for (i = 0; i < sz; i += PGSIZE) {
80106f06:	8b 75 18             	mov    0x18(%ebp),%esi
80106f09:	31 db                	xor    %ebx,%ebx
80106f0b:	85 f6                	test   %esi,%esi
80106f0d:	75 1a                	jne    80106f29 <loaduvm+0x39>
80106f0f:	eb 6f                	jmp    80106f80 <loaduvm+0x90>
80106f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f18:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f1e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106f24:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106f27:	76 57                	jbe    80106f80 <loaduvm+0x90>
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
80106f29:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2f:	31 c9                	xor    %ecx,%ecx
80106f31:	01 da                	add    %ebx,%edx
80106f33:	e8 88 fb ff ff       	call   80106ac0 <walkpgdir>
80106f38:	85 c0                	test   %eax,%eax
80106f3a:	74 4e                	je     80106f8a <loaduvm+0x9a>
        pa = PTE_ADDR(*pte);
80106f3c:	8b 00                	mov    (%eax),%eax
        if (readi(ip, P2V(pa), offset + i, n) != n)
80106f3e:	8b 4d 14             	mov    0x14(%ebp),%ecx
        if (sz - i < PGSIZE)
80106f41:	bf 00 10 00 00       	mov    $0x1000,%edi
        pa = PTE_ADDR(*pte);
80106f46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE)
80106f4b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f51:	0f 46 fe             	cmovbe %esi,%edi
        if (readi(ip, P2V(pa), offset + i, n) != n)
80106f54:	01 d9                	add    %ebx,%ecx
80106f56:	05 00 00 00 80       	add    $0x80000000,%eax
80106f5b:	57                   	push   %edi
80106f5c:	51                   	push   %ecx
80106f5d:	50                   	push   %eax
80106f5e:	ff 75 10             	pushl  0x10(%ebp)
80106f61:	e8 0a aa ff ff       	call   80101970 <readi>
80106f66:	83 c4 10             	add    $0x10,%esp
80106f69:	39 f8                	cmp    %edi,%eax
80106f6b:	74 ab                	je     80106f18 <loaduvm+0x28>
}
80106f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80106f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret    
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106f83:	31 c0                	xor    %eax,%eax
}
80106f85:	5b                   	pop    %ebx
80106f86:	5e                   	pop    %esi
80106f87:	5f                   	pop    %edi
80106f88:	5d                   	pop    %ebp
80106f89:	c3                   	ret    
            panic("loaduvm: address should exist");
80106f8a:	83 ec 0c             	sub    $0xc,%esp
80106f8d:	68 67 7e 10 80       	push   $0x80107e67
80106f92:	e8 f9 93 ff ff       	call   80100390 <panic>
        panic("loaduvm: addr must be page aligned");
80106f97:	83 ec 0c             	sub    $0xc,%esp
80106f9a:	68 1c 7f 10 80       	push   $0x80107f1c
80106f9f:	e8 ec 93 ff ff       	call   80100390 <panic>
80106fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106fb0 <findFreeEntryInSwapFile>:
findFreeEntryInSwapFile(struct proc *p) {
80106fb0:	55                   	push   %ebp
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80106fb1:	31 c0                	xor    %eax,%eax
findFreeEntryInSwapFile(struct proc *p) {
80106fb3:	89 e5                	mov    %esp,%ebp
80106fb5:	8b 55 08             	mov    0x8(%ebp),%edx
80106fb8:	eb 0e                	jmp    80106fc8 <findFreeEntryInSwapFile+0x18>
80106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80106fc0:	83 c0 01             	add    $0x1,%eax
80106fc3:	83 f8 10             	cmp    $0x10,%eax
80106fc6:	74 10                	je     80106fd8 <findFreeEntryInSwapFile+0x28>
        if (!p->swapFileEntries[i])
80106fc8:	8b 8c 82 00 04 00 00 	mov    0x400(%edx,%eax,4),%ecx
80106fcf:	85 c9                	test   %ecx,%ecx
80106fd1:	75 ed                	jne    80106fc0 <findFreeEntryInSwapFile+0x10>
}
80106fd3:	5d                   	pop    %ebp
80106fd4:	c3                   	ret    
80106fd5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fdd:	5d                   	pop    %ebp
80106fde:	c3                   	ret    
80106fdf:	90                   	nop

80106fe0 <swapOutPage>:
swapOutPage(struct proc *p, pde_t *pgdir) {
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	56                   	push   %esi
80106fe4:	53                   	push   %ebx
80106fe5:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe8:	8d b0 00 04 00 00    	lea    0x400(%eax),%esi
80106fee:	05 40 04 00 00       	add    $0x440,%eax
80106ff3:	89 f3                	mov    %esi,%ebx
80106ff5:	eb 10                	jmp    80107007 <swapOutPage+0x27>
80106ff7:	89 f6                	mov    %esi,%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107000:	83 c3 04             	add    $0x4,%ebx
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80107003:	39 c3                	cmp    %eax,%ebx
80107005:	74 0d                	je     80107014 <swapOutPage+0x34>
        if (!p->swapFileEntries[i])
80107007:	8b 13                	mov    (%ebx),%edx
80107009:	85 d2                	test   %edx,%edx
8010700b:	75 f3                	jne    80107000 <swapOutPage+0x20>
    writeToSwapFile(p, pg->physAdress, (uint) swapWriteOffset, PGSIZE);
8010700d:	a1 14 00 00 00       	mov    0x14,%eax
80107012:	0f 0b                	ud2    
        cprintf("p->entries:\t");
80107014:	83 ec 0c             	sub    $0xc,%esp
80107017:	68 8a 7e 10 80       	push   $0x80107e8a
8010701c:	e8 3f 96 ff ff       	call   80100660 <cprintf>
80107021:	83 c4 10             	add    $0x10,%esp
            cprintf("%d  ", p->swapFileEntries[i]);
80107024:	50                   	push   %eax
80107025:	50                   	push   %eax
80107026:	83 c6 04             	add    $0x4,%esi
80107029:	ff 76 fc             	pushl  -0x4(%esi)
8010702c:	68 85 7e 10 80       	push   $0x80107e85
80107031:	e8 2a 96 ff ff       	call   80100660 <cprintf>
        for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80107036:	83 c4 10             	add    $0x10,%esp
80107039:	39 f3                	cmp    %esi,%ebx
8010703b:	75 e7                	jne    80107024 <swapOutPage+0x44>
        panic("ERROR - there is no free entry in p->swapFileEntries!\n");
8010703d:	83 ec 0c             	sub    $0xc,%esp
80107040:	68 40 7f 10 80       	push   $0x80107f40
80107045:	e8 46 93 ff ff       	call   80100390 <panic>
8010704a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107050 <allocuvm>:
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	57                   	push   %edi
80107054:	56                   	push   %esi
80107055:	53                   	push   %ebx
80107056:	83 ec 1c             	sub    $0x1c,%esp
    if (newsz >= KERNBASE)
80107059:	8b 7d 10             	mov    0x10(%ebp),%edi
8010705c:	85 ff                	test   %edi,%edi
8010705e:	0f 88 93 00 00 00    	js     801070f7 <allocuvm+0xa7>
    if (newsz < oldsz)
80107064:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107067:	0f 82 9b 00 00 00    	jb     80107108 <allocuvm+0xb8>
    a = PGROUNDUP(oldsz);
8010706d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107070:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107076:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; a < newsz; a += PGSIZE) {
8010707c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010707f:	0f 86 86 00 00 00    	jbe    8010710b <allocuvm+0xbb>
80107085:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107088:	8b 7d 08             	mov    0x8(%ebp),%edi
8010708b:	eb 42                	jmp    801070cf <allocuvm+0x7f>
8010708d:	8d 76 00             	lea    0x0(%esi),%esi
        memset(mem, 0, PGSIZE);
80107090:	83 ec 04             	sub    $0x4,%esp
80107093:	68 00 10 00 00       	push   $0x1000
80107098:	6a 00                	push   $0x0
8010709a:	50                   	push   %eax
8010709b:	e8 a0 d8 ff ff       	call   80104940 <memset>
        if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
801070a0:	58                   	pop    %eax
801070a1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070a7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070ac:	5a                   	pop    %edx
801070ad:	6a 06                	push   $0x6
801070af:	50                   	push   %eax
801070b0:	89 da                	mov    %ebx,%edx
801070b2:	89 f8                	mov    %edi,%eax
801070b4:	e8 87 fa ff ff       	call   80106b40 <mappages>
801070b9:	83 c4 10             	add    $0x10,%esp
801070bc:	85 c0                	test   %eax,%eax
801070be:	78 58                	js     80107118 <allocuvm+0xc8>
    for (; a < newsz; a += PGSIZE) {
801070c0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070c6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801070c9:	0f 86 89 00 00 00    	jbe    80107158 <allocuvm+0x108>
        if (notShell()) {
801070cf:	e8 8c ca ff ff       	call   80103b60 <notShell>
        mem = kalloc();
801070d4:	e8 27 b8 ff ff       	call   80102900 <kalloc>
        if (mem == 0) {
801070d9:	85 c0                	test   %eax,%eax
        mem = kalloc();
801070db:	89 c6                	mov    %eax,%esi
        if (mem == 0) {
801070dd:	75 b1                	jne    80107090 <allocuvm+0x40>
            cprintf("allocuvm out of memory\n");
801070df:	83 ec 0c             	sub    $0xc,%esp
801070e2:	68 97 7e 10 80       	push   $0x80107e97
801070e7:	e8 74 95 ff ff       	call   80100660 <cprintf>
    if (newsz >= oldsz) {
801070ec:	83 c4 10             	add    $0x10,%esp
801070ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801070f2:	39 45 10             	cmp    %eax,0x10(%ebp)
801070f5:	77 71                	ja     80107168 <allocuvm+0x118>
}
801070f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
801070fa:	31 ff                	xor    %edi,%edi
}
801070fc:	89 f8                	mov    %edi,%eax
801070fe:	5b                   	pop    %ebx
801070ff:	5e                   	pop    %esi
80107100:	5f                   	pop    %edi
80107101:	5d                   	pop    %ebp
80107102:	c3                   	ret    
80107103:	90                   	nop
80107104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return oldsz;
80107108:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
8010710b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010710e:	89 f8                	mov    %edi,%eax
80107110:	5b                   	pop    %ebx
80107111:	5e                   	pop    %esi
80107112:	5f                   	pop    %edi
80107113:	5d                   	pop    %ebp
80107114:	c3                   	ret    
80107115:	8d 76 00             	lea    0x0(%esi),%esi
            cprintf("allocuvm out of memory (2)\n");
80107118:	83 ec 0c             	sub    $0xc,%esp
8010711b:	68 af 7e 10 80       	push   $0x80107eaf
80107120:	e8 3b 95 ff ff       	call   80100660 <cprintf>
    if (newsz >= oldsz) {
80107125:	83 c4 10             	add    $0x10,%esp
80107128:	8b 45 0c             	mov    0xc(%ebp),%eax
8010712b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010712e:	76 0d                	jbe    8010713d <allocuvm+0xed>
80107130:	89 c1                	mov    %eax,%ecx
80107132:	8b 55 10             	mov    0x10(%ebp),%edx
80107135:	8b 45 08             	mov    0x8(%ebp),%eax
80107138:	e8 93 fa ff ff       	call   80106bd0 <deallocuvm.part.0>
            kfree(mem);
8010713d:	83 ec 0c             	sub    $0xc,%esp
            return 0;
80107140:	31 ff                	xor    %edi,%edi
            kfree(mem);
80107142:	56                   	push   %esi
80107143:	e8 08 b6 ff ff       	call   80102750 <kfree>
            return 0;
80107148:	83 c4 10             	add    $0x10,%esp
}
8010714b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010714e:	89 f8                	mov    %edi,%eax
80107150:	5b                   	pop    %ebx
80107151:	5e                   	pop    %esi
80107152:	5f                   	pop    %edi
80107153:	5d                   	pop    %ebp
80107154:	c3                   	ret    
80107155:	8d 76 00             	lea    0x0(%esi),%esi
80107158:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010715b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010715e:	5b                   	pop    %ebx
8010715f:	89 f8                	mov    %edi,%eax
80107161:	5e                   	pop    %esi
80107162:	5f                   	pop    %edi
80107163:	5d                   	pop    %ebp
80107164:	c3                   	ret    
80107165:	8d 76 00             	lea    0x0(%esi),%esi
80107168:	89 c1                	mov    %eax,%ecx
8010716a:	8b 55 10             	mov    0x10(%ebp),%edx
8010716d:	8b 45 08             	mov    0x8(%ebp),%eax
            return 0;
80107170:	31 ff                	xor    %edi,%edi
80107172:	e8 59 fa ff ff       	call   80106bd0 <deallocuvm.part.0>
80107177:	eb 92                	jmp    8010710b <allocuvm+0xbb>
80107179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107180 <deallocuvm>:
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int growproc) {
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	8b 55 0c             	mov    0xc(%ebp),%edx
80107186:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107189:	8b 45 08             	mov    0x8(%ebp),%eax
    if (newsz >= oldsz) {
8010718c:	39 d1                	cmp    %edx,%ecx
8010718e:	73 10                	jae    801071a0 <deallocuvm+0x20>
}
80107190:	5d                   	pop    %ebp
80107191:	e9 3a fa ff ff       	jmp    80106bd0 <deallocuvm.part.0>
80107196:	8d 76 00             	lea    0x0(%esi),%esi
80107199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071a0:	89 d0                	mov    %edx,%eax
801071a2:	5d                   	pop    %ebp
801071a3:	c3                   	ret    
801071a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir) {
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 0c             	sub    $0xc,%esp
801071b9:	8b 75 08             	mov    0x8(%ebp),%esi
    if (DEBUGMODE == 2 && notShell())
        cprintf("FREEVM");
    uint i;

    if (pgdir == 0)
801071bc:	85 f6                	test   %esi,%esi
801071be:	74 59                	je     80107219 <freevm+0x69>
801071c0:	31 c9                	xor    %ecx,%ecx
801071c2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071c7:	89 f0                	mov    %esi,%eax
801071c9:	e8 02 fa ff ff       	call   80106bd0 <deallocuvm.part.0>
801071ce:	89 f3                	mov    %esi,%ebx
801071d0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071d6:	eb 0f                	jmp    801071e7 <freevm+0x37>
801071d8:	90                   	nop
801071d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071e0:	83 c3 04             	add    $0x4,%ebx
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0, 0);
    for (i = 0; i < NPDENTRIES; i++) {
801071e3:	39 fb                	cmp    %edi,%ebx
801071e5:	74 23                	je     8010720a <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
801071e7:	8b 03                	mov    (%ebx),%eax
801071e9:	a8 01                	test   $0x1,%al
801071eb:	74 f3                	je     801071e0 <freevm+0x30>
            char *v = P2V(PTE_ADDR(pgdir[i]));
801071ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(v);
801071f2:	83 ec 0c             	sub    $0xc,%esp
801071f5:	83 c3 04             	add    $0x4,%ebx
            char *v = P2V(PTE_ADDR(pgdir[i]));
801071f8:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(v);
801071fd:	50                   	push   %eax
801071fe:	e8 4d b5 ff ff       	call   80102750 <kfree>
80107203:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80107206:	39 fb                	cmp    %edi,%ebx
80107208:	75 dd                	jne    801071e7 <freevm+0x37>
        }
    }
    kfree((char *) pgdir);
8010720a:	89 75 08             	mov    %esi,0x8(%ebp)
    if (DEBUGMODE == 2 && notShell())
        cprintf(">FREEVM-DONE!\t");
}
8010720d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107210:	5b                   	pop    %ebx
80107211:	5e                   	pop    %esi
80107212:	5f                   	pop    %edi
80107213:	5d                   	pop    %ebp
    kfree((char *) pgdir);
80107214:	e9 37 b5 ff ff       	jmp    80102750 <kfree>
        panic("freevm: no pgdir");
80107219:	83 ec 0c             	sub    $0xc,%esp
8010721c:	68 cb 7e 10 80       	push   $0x80107ecb
80107221:	e8 6a 91 ff ff       	call   80100390 <panic>
80107226:	8d 76 00             	lea    0x0(%esi),%esi
80107229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107230 <setupkvm>:
setupkvm(void) {
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	56                   	push   %esi
80107234:	53                   	push   %ebx
    if ((pgdir = (pde_t *) kalloc()) == 0)
80107235:	e8 c6 b6 ff ff       	call   80102900 <kalloc>
8010723a:	85 c0                	test   %eax,%eax
8010723c:	89 c6                	mov    %eax,%esi
8010723e:	74 42                	je     80107282 <setupkvm+0x52>
    memset(pgdir, 0, PGSIZE);
80107240:	83 ec 04             	sub    $0x4,%esp
    for (k = kmap; k < &kmap[NELEM(kmap)];
80107243:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
    memset(pgdir, 0, PGSIZE);
80107248:	68 00 10 00 00       	push   $0x1000
8010724d:	6a 00                	push   $0x0
8010724f:	50                   	push   %eax
80107250:	e8 eb d6 ff ff       	call   80104940 <memset>
80107255:	83 c4 10             	add    $0x10,%esp
                 (uint) k->phys_start, k->perm) < 0) {
80107258:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010725b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010725e:	83 ec 08             	sub    $0x8,%esp
80107261:	8b 13                	mov    (%ebx),%edx
80107263:	ff 73 0c             	pushl  0xc(%ebx)
80107266:	50                   	push   %eax
80107267:	29 c1                	sub    %eax,%ecx
80107269:	89 f0                	mov    %esi,%eax
8010726b:	e8 d0 f8 ff ff       	call   80106b40 <mappages>
80107270:	83 c4 10             	add    $0x10,%esp
80107273:	85 c0                	test   %eax,%eax
80107275:	78 19                	js     80107290 <setupkvm+0x60>
    k++)
80107277:	83 c3 10             	add    $0x10,%ebx
    for (k = kmap; k < &kmap[NELEM(kmap)];
8010727a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107280:	75 d6                	jne    80107258 <setupkvm+0x28>
}
80107282:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107285:	89 f0                	mov    %esi,%eax
80107287:	5b                   	pop    %ebx
80107288:	5e                   	pop    %esi
80107289:	5d                   	pop    %ebp
8010728a:	c3                   	ret    
8010728b:	90                   	nop
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        freevm(pgdir);
80107290:	83 ec 0c             	sub    $0xc,%esp
80107293:	56                   	push   %esi
        return 0;
80107294:	31 f6                	xor    %esi,%esi
        freevm(pgdir);
80107296:	e8 15 ff ff ff       	call   801071b0 <freevm>
        return 0;
8010729b:	83 c4 10             	add    $0x10,%esp
}
8010729e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072a1:	89 f0                	mov    %esi,%eax
801072a3:	5b                   	pop    %ebx
801072a4:	5e                   	pop    %esi
801072a5:	5d                   	pop    %ebp
801072a6:	c3                   	ret    
801072a7:	89 f6                	mov    %esi,%esi
801072a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072b0 <kvmalloc>:
kvmalloc(void) {
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
801072b6:	e8 75 ff ff ff       	call   80107230 <setupkvm>
801072bb:	a3 e8 5c 12 80       	mov    %eax,0x80125ce8
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801072c0:	05 00 00 00 80       	add    $0x80000000,%eax
801072c5:	0f 22 d8             	mov    %eax,%cr3
}
801072c8:	c9                   	leave  
801072c9:	c3                   	ret    
801072ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva) {
801072d0:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
801072d1:	31 c9                	xor    %ecx,%ecx
clearpteu(pde_t *pgdir, char *uva) {
801072d3:	89 e5                	mov    %esp,%ebp
801072d5:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
801072d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072db:	8b 45 08             	mov    0x8(%ebp),%eax
801072de:	e8 dd f7 ff ff       	call   80106ac0 <walkpgdir>
    if (pte == 0)
801072e3:	85 c0                	test   %eax,%eax
801072e5:	74 05                	je     801072ec <clearpteu+0x1c>
        panic("clearpteu");
    *pte &= ~PTE_U;
801072e7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072ea:	c9                   	leave  
801072eb:	c3                   	ret    
        panic("clearpteu");
801072ec:	83 ec 0c             	sub    $0xc,%esp
801072ef:	68 dc 7e 10 80       	push   $0x80107edc
801072f4:	e8 97 90 ff ff       	call   80100390 <panic>
801072f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107300 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz) {
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	57                   	push   %edi
80107304:	56                   	push   %esi
80107305:	53                   	push   %ebx
80107306:	83 ec 1c             	sub    $0x1c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0)
80107309:	e8 22 ff ff ff       	call   80107230 <setupkvm>
8010730e:	85 c0                	test   %eax,%eax
80107310:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107313:	0f 84 a0 00 00 00    	je     801073b9 <copyuvm+0xb9>
        return 0;
    for (i = 0; i < sz; i += PGSIZE) {
80107319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010731c:	85 c9                	test   %ecx,%ecx
8010731e:	0f 84 95 00 00 00    	je     801073b9 <copyuvm+0xb9>
80107324:	31 f6                	xor    %esi,%esi
80107326:	eb 4e                	jmp    80107376 <copyuvm+0x76>
80107328:	90                   	nop
80107329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0)
            goto bad;
        memmove(mem, (char *) P2V(pa), PGSIZE);
80107330:	83 ec 04             	sub    $0x4,%esp
80107333:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010733c:	68 00 10 00 00       	push   $0x1000
80107341:	57                   	push   %edi
80107342:	50                   	push   %eax
80107343:	e8 a8 d6 ff ff       	call   801049f0 <memmove>
        if (mappages(d, (void *) i, PGSIZE, V2P(mem), flags) < 0)
80107348:	58                   	pop    %eax
80107349:	5a                   	pop    %edx
8010734a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010734d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107350:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107355:	53                   	push   %ebx
80107356:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010735c:	52                   	push   %edx
8010735d:	89 f2                	mov    %esi,%edx
8010735f:	e8 dc f7 ff ff       	call   80106b40 <mappages>
80107364:	83 c4 10             	add    $0x10,%esp
80107367:	85 c0                	test   %eax,%eax
80107369:	78 39                	js     801073a4 <copyuvm+0xa4>
    for (i = 0; i < sz; i += PGSIZE) {
8010736b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107371:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107374:	76 43                	jbe    801073b9 <copyuvm+0xb9>
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107376:	8b 45 08             	mov    0x8(%ebp),%eax
80107379:	31 c9                	xor    %ecx,%ecx
8010737b:	89 f2                	mov    %esi,%edx
8010737d:	e8 3e f7 ff ff       	call   80106ac0 <walkpgdir>
80107382:	85 c0                	test   %eax,%eax
80107384:	74 3e                	je     801073c4 <copyuvm+0xc4>
        if (!(*pte & PTE_P))
80107386:	8b 18                	mov    (%eax),%ebx
80107388:	f6 c3 01             	test   $0x1,%bl
8010738b:	74 44                	je     801073d1 <copyuvm+0xd1>
        pa = PTE_ADDR(*pte);
8010738d:	89 df                	mov    %ebx,%edi
        flags = PTE_FLAGS(*pte);
8010738f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
        pa = PTE_ADDR(*pte);
80107395:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        if ((mem = kalloc()) == 0)
8010739b:	e8 60 b5 ff ff       	call   80102900 <kalloc>
801073a0:	85 c0                	test   %eax,%eax
801073a2:	75 8c                	jne    80107330 <copyuvm+0x30>
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-DONE!\t");
    return d;

    bad:
    freevm(d);
801073a4:	83 ec 0c             	sub    $0xc,%esp
801073a7:	ff 75 e0             	pushl  -0x20(%ebp)
801073aa:	e8 01 fe ff ff       	call   801071b0 <freevm>
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-FAILED!\t");
    return 0;
801073af:	83 c4 10             	add    $0x10,%esp
801073b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801073b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073bf:	5b                   	pop    %ebx
801073c0:	5e                   	pop    %esi
801073c1:	5f                   	pop    %edi
801073c2:	5d                   	pop    %ebp
801073c3:	c3                   	ret    
            panic("copyuvm: pte should exist");
801073c4:	83 ec 0c             	sub    $0xc,%esp
801073c7:	68 e6 7e 10 80       	push   $0x80107ee6
801073cc:	e8 bf 8f ff ff       	call   80100390 <panic>
            panic("copyuvm: page not present");
801073d1:	83 ec 0c             	sub    $0xc,%esp
801073d4:	68 00 7f 10 80       	push   $0x80107f00
801073d9:	e8 b2 8f ff ff       	call   80100390 <panic>
801073de:	66 90                	xchg   %ax,%ax

801073e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva) {
801073e0:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
801073e1:	31 c9                	xor    %ecx,%ecx
uva2ka(pde_t *pgdir, char *uva) {
801073e3:	89 e5                	mov    %esp,%ebp
801073e5:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
801073e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801073eb:	8b 45 08             	mov    0x8(%ebp),%eax
801073ee:	e8 cd f6 ff ff       	call   80106ac0 <walkpgdir>
    if ((*pte & PTE_P) == 0)
801073f3:	8b 00                	mov    (%eax),%eax
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    return (char *) P2V(PTE_ADDR(*pte));
}
801073f5:	c9                   	leave  
    if ((*pte & PTE_U) == 0)
801073f6:	89 c2                	mov    %eax,%edx
    return (char *) P2V(PTE_ADDR(*pte));
801073f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((*pte & PTE_U) == 0)
801073fd:	83 e2 05             	and    $0x5,%edx
    return (char *) P2V(PTE_ADDR(*pte));
80107400:	05 00 00 00 80       	add    $0x80000000,%eax
80107405:	83 fa 05             	cmp    $0x5,%edx
80107408:	ba 00 00 00 00       	mov    $0x0,%edx
8010740d:	0f 45 c2             	cmovne %edx,%eax
}
80107410:	c3                   	ret    
80107411:	eb 0d                	jmp    80107420 <copyout>
80107413:	90                   	nop
80107414:	90                   	nop
80107415:	90                   	nop
80107416:	90                   	nop
80107417:	90                   	nop
80107418:	90                   	nop
80107419:	90                   	nop
8010741a:	90                   	nop
8010741b:	90                   	nop
8010741c:	90                   	nop
8010741d:	90                   	nop
8010741e:	90                   	nop
8010741f:	90                   	nop

80107420 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len) {
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	57                   	push   %edi
80107424:	56                   	push   %esi
80107425:	53                   	push   %ebx
80107426:	83 ec 1c             	sub    $0x1c,%esp
80107429:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010742c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010742f:	8b 7d 10             	mov    0x10(%ebp),%edi
    char *buf, *pa0;
    uint n, va0;

    buf = (char *) p;
    while (len > 0) {
80107432:	85 db                	test   %ebx,%ebx
80107434:	75 40                	jne    80107476 <copyout+0x56>
80107436:	eb 70                	jmp    801074a8 <copyout+0x88>
80107438:	90                   	nop
80107439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        va0 = (uint) PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char *) va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (va - va0);
80107440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107443:	89 f1                	mov    %esi,%ecx
80107445:	29 d1                	sub    %edx,%ecx
80107447:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010744d:	39 d9                	cmp    %ebx,%ecx
8010744f:	0f 47 cb             	cmova  %ebx,%ecx
        if (n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
80107452:	29 f2                	sub    %esi,%edx
80107454:	83 ec 04             	sub    $0x4,%esp
80107457:	01 d0                	add    %edx,%eax
80107459:	51                   	push   %ecx
8010745a:	57                   	push   %edi
8010745b:	50                   	push   %eax
8010745c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010745f:	e8 8c d5 ff ff       	call   801049f0 <memmove>
        len -= n;
        buf += n;
80107464:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    while (len > 0) {
80107467:	83 c4 10             	add    $0x10,%esp
        va = va0 + PGSIZE;
8010746a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
        buf += n;
80107470:	01 cf                	add    %ecx,%edi
    while (len > 0) {
80107472:	29 cb                	sub    %ecx,%ebx
80107474:	74 32                	je     801074a8 <copyout+0x88>
        va0 = (uint) PGROUNDDOWN(va);
80107476:	89 d6                	mov    %edx,%esi
        pa0 = uva2ka(pgdir, (char *) va0);
80107478:	83 ec 08             	sub    $0x8,%esp
        va0 = (uint) PGROUNDDOWN(va);
8010747b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010747e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        pa0 = uva2ka(pgdir, (char *) va0);
80107484:	56                   	push   %esi
80107485:	ff 75 08             	pushl  0x8(%ebp)
80107488:	e8 53 ff ff ff       	call   801073e0 <uva2ka>
        if (pa0 == 0)
8010748d:	83 c4 10             	add    $0x10,%esp
80107490:	85 c0                	test   %eax,%eax
80107492:	75 ac                	jne    80107440 <copyout+0x20>
    }
    return 0;
}
80107494:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010749c:	5b                   	pop    %ebx
8010749d:	5e                   	pop    %esi
8010749e:	5f                   	pop    %edi
8010749f:	5d                   	pop    %ebp
801074a0:	c3                   	ret    
801074a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801074ab:	31 c0                	xor    %eax,%eax
}
801074ad:	5b                   	pop    %ebx
801074ae:	5e                   	pop    %esi
801074af:	5f                   	pop    %edi
801074b0:	5d                   	pop    %ebp
801074b1:	c3                   	ret    
