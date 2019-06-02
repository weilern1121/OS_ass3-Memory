
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
80100028:	bc d0 d5 10 80       	mov    $0x8010d5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 33 10 80       	mov    $0x80103370,%eax
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
80100044:	bb 14 d6 10 80       	mov    $0x8010d614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 84 10 80       	push   $0x80108440
80100051:	68 e0 d5 10 80       	push   $0x8010d5e0
80100056:	e8 35 4f 00 00       	call   80104f90 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 1d 11 80 dc 	movl   $0x80111cdc,0x80111d2c
80100062:	1c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 1d 11 80 dc 	movl   $0x80111cdc,0x80111d30
8010006c:	1c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 1c 11 80       	mov    $0x80111cdc,%edx
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
8010008b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 84 10 80       	push   $0x80108447
80100097:	50                   	push   %eax
80100098:	e8 e3 4d 00 00       	call   80104e80 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 1d 11 80       	mov    0x80111d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 1c 11 80       	cmp    $0x80111cdc,%eax
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
801000df:	68 e0 d5 10 80       	push   $0x8010d5e0
801000e4:	e8 97 4f 00 00       	call   80105080 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 1d 11 80    	mov    0x80111d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
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
80100120:	8b 1d 2c 1d 11 80    	mov    0x80111d2c,%ebx
80100126:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
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
8010015d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100162:	e8 39 50 00 00       	call   801051a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 4d 00 00       	call   80104ec0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ed 23 00 00       	call   80102570 <iderw>
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
80100193:	68 4e 84 10 80       	push   $0x8010844e
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
801001ae:	e8 ad 4d 00 00       	call   80104f60 <holdingsleep>
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
801001c4:	e9 a7 23 00 00       	jmp    80102570 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 84 10 80       	push   $0x8010845f
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
801001ef:	e8 6c 4d 00 00       	call   80104f60 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 4d 00 00       	call   80104f20 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010020b:	e8 70 4e 00 00       	call   80105080 <acquire>
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
80100232:	a1 30 1d 11 80       	mov    0x80111d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 1d 11 80       	mov    0x80111d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 3f 4f 00 00       	jmp    801051a0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 84 10 80       	push   $0x80108466
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
80100280:	e8 9b 15 00 00       	call   80101820 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 ef 4d 00 00       	call   80105080 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 1f 11 80    	mov    0x80111fc0,%edx
801002a7:	39 15 c4 1f 11 80    	cmp    %edx,0x80111fc4
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
801002bb:	68 20 c5 10 80       	push   $0x8010c520
801002c0:	68 c0 1f 11 80       	push   $0x80111fc0
801002c5:	e8 36 43 00 00       	call   80104600 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 1f 11 80    	mov    0x80111fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 1f 11 80    	cmp    0x80111fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 c0 3a 00 00       	call   80103da0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 ac 4e 00 00       	call   801051a0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 44 14 00 00       	call   80101740 <ilock>
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
80100313:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 1f 11 80 	movsbl -0x7feee0c0(%eax),%eax
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
80100348:	68 20 c5 10 80       	push   $0x8010c520
8010034d:	e8 4e 4e 00 00       	call   801051a0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 e6 13 00 00       	call   80101740 <ilock>
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
80100372:	89 15 c0 1f 11 80    	mov    %edx,0x80111fc0
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
80100399:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 52 28 00 00       	call   80102c00 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 6d 84 10 80       	push   $0x8010846d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 06 8a 10 80 	movl   $0x80108a06,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 d3 4b 00 00       	call   80104fb0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 81 84 10 80       	push   $0x80108481
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
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
8010043a:	e8 01 69 00 00       	call   80106d40 <uartputc>
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
801004ec:	e8 4f 68 00 00       	call   80106d40 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 43 68 00 00       	call   80106d40 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 37 68 00 00       	call   80106d40 <uartputc>
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
80100524:	e8 87 4d 00 00       	call   801052b0 <memmove>
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
80100541:	e8 ba 4c 00 00       	call   80105200 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 85 84 10 80       	push   $0x80108485
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
801005b1:	0f b6 92 b0 84 10 80 	movzbl -0x7fef7b50(%edx),%edx
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
8010060f:	e8 0c 12 00 00       	call   80101820 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 60 4a 00 00       	call   80105080 <acquire>
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
80100642:	68 20 c5 10 80       	push   $0x8010c520
80100647:	e8 54 4b 00 00       	call   801051a0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 eb 10 00 00       	call   80101740 <ilock>

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
80100669:	a1 54 c5 10 80       	mov    0x8010c554,%eax
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
8010071a:	68 20 c5 10 80       	push   $0x8010c520
8010071f:	e8 7c 4a 00 00       	call   801051a0 <release>
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
801007d0:	ba 98 84 10 80       	mov    $0x80108498,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 8b 48 00 00       	call   80105080 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 9f 84 10 80       	push   $0x8010849f
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
8010081e:	68 20 c5 10 80       	push   $0x8010c520
80100823:	e8 58 48 00 00       	call   80105080 <acquire>
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
80100851:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100856:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
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
80100883:	68 20 c5 10 80       	push   $0x8010c520
80100888:	e8 13 49 00 00       	call   801051a0 <release>
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
801008a9:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 1f 11 80    	sub    0x80111fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 1f 11 80    	mov    %edx,0x80111fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 1f 11 80    	mov    %cl,-0x7feee0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 1f 11 80    	cmp    %eax,0x80111fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 1f 11 80       	mov    %eax,0x80111fc4
          wakeup(&input.r);
80100911:	68 c0 1f 11 80       	push   $0x80111fc0
80100916:	e8 55 3f 00 00       	call   80104870 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
8010093d:	39 05 c4 1f 11 80    	cmp    %eax,0x80111fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100964:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 1f 11 80 0a 	cmpb   $0xa,-0x7feee0c0(%edx)
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
80100997:	e9 b4 3f 00 00       	jmp    80104950 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 1f 11 80 0a 	movb   $0xa,-0x7feee0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
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
801009c6:	68 a8 84 10 80       	push   $0x801084a8
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 bb 45 00 00       	call   80104f90 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 29 11 80 00 	movl   $0x80100600,0x8011298c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 29 11 80 70 	movl   $0x80100270,0x80112988
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 22 1d 00 00       	call   80102720 <ioapicenable>
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
80100a1c:	e8 7f 33 00 00       	call   80103da0 <myproc>
80100a21:	89 c6                	mov    %eax,%esi

    begin_op();
80100a23:	e8 48 26 00 00       	call   80103070 <begin_op>

    if ((ip = namei(path)) == 0) {
80100a28:	83 ec 0c             	sub    $0xc,%esp
80100a2b:	ff 75 08             	pushl  0x8(%ebp)
80100a2e:	e8 6d 15 00 00       	call   80101fa0 <namei>
80100a33:	83 c4 10             	add    $0x10,%esp
80100a36:	85 c0                	test   %eax,%eax
80100a38:	0f 84 3b 02 00 00    	je     80100c79 <exec+0x269>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
80100a3e:	83 ec 0c             	sub    $0xc,%esp
80100a41:	89 c3                	mov    %eax,%ebx
80100a43:	50                   	push   %eax
80100a44:	e8 f7 0c 00 00       	call   80101740 <ilock>
    pgdir = 0;

    //TODO WE NEED CLOSE AND OPEN SWAP
#if(defined(LIFO) || defined(SCFIFO))
    if (notShell()) {
80100a49:	e8 22 33 00 00       	call   80103d70 <notShell>
80100a4e:	83 c4 10             	add    $0x10,%esp
80100a51:	85 c0                	test   %eax,%eax
80100a53:	0f 85 47 01 00 00    	jne    80100ba0 <exec+0x190>
        curproc->pagesCounter = 0;
    }
#endif

    // Check ELF header
    if (readi(ip, (char *) &elf, 0, sizeof(elf)) != sizeof(elf))
80100a59:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a5f:	6a 34                	push   $0x34
80100a61:	6a 00                	push   $0x0
80100a63:	50                   	push   %eax
80100a64:	53                   	push   %ebx
80100a65:	e8 b6 0f 00 00       	call   80101a20 <readi>
80100a6a:	83 c4 10             	add    $0x10,%esp
80100a6d:	83 f8 34             	cmp    $0x34,%eax
80100a70:	74 1e                	je     80100a90 <exec+0x80>

    bad:
    if (pgdir)
        freevm(pgdir);
    if (ip) {
        iunlockput(ip);
80100a72:	83 ec 0c             	sub    $0xc,%esp
80100a75:	53                   	push   %ebx
80100a76:	e8 55 0f 00 00       	call   801019d0 <iunlockput>
        end_op();
80100a7b:	e8 60 26 00 00       	call   801030e0 <end_op>
80100a80:	83 c4 10             	add    $0x10,%esp
    }
    if (DEBUGMODE == 1)
        cprintf(">EXEC-FAILED-GOTO_BAD!\t");
    return -1;
80100a83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a8b:	5b                   	pop    %ebx
80100a8c:	5e                   	pop    %esi
80100a8d:	5f                   	pop    %edi
80100a8e:	5d                   	pop    %ebp
80100a8f:	c3                   	ret    
    if (elf.magic != ELF_MAGIC)
80100a90:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a97:	45 4c 46 
80100a9a:	75 d6                	jne    80100a72 <exec+0x62>
    if ((pgdir = setupkvm()) == 0)
80100a9c:	e8 ff 76 00 00       	call   801081a0 <setupkvm>
80100aa1:	85 c0                	test   %eax,%eax
80100aa3:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100aa9:	74 c7                	je     80100a72 <exec+0x62>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100aab:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ab2:	00 
80100ab3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100abf:	0f 84 2e 03 00 00    	je     80100df3 <exec+0x3e3>
    sz = 0;
80100ac5:	31 c0                	xor    %eax,%eax
80100ac7:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100acd:	31 ff                	xor    %edi,%edi
80100acf:	89 c6                	mov    %eax,%esi
80100ad1:	e9 8c 00 00 00       	jmp    80100b62 <exec+0x152>
80100ad6:	8d 76 00             	lea    0x0(%esi),%esi
80100ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (ph.type != ELF_PROG_LOAD)
80100ae0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ae7:	75 67                	jne    80100b50 <exec+0x140>
        if (ph.memsz < ph.filesz)
80100ae9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aef:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100af5:	0f 82 8e 00 00 00    	jb     80100b89 <exec+0x179>
80100afb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b01:	0f 82 82 00 00 00    	jb     80100b89 <exec+0x179>
        if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b07:	83 ec 04             	sub    $0x4,%esp
80100b0a:	50                   	push   %eax
80100b0b:	56                   	push   %esi
80100b0c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b12:	e8 a9 73 00 00       	call   80107ec0 <allocuvm>
80100b17:	83 c4 10             	add    $0x10,%esp
80100b1a:	85 c0                	test   %eax,%eax
80100b1c:	89 c6                	mov    %eax,%esi
80100b1e:	74 69                	je     80100b89 <exec+0x179>
        if (ph.vaddr % PGSIZE != 0)
80100b20:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b26:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b2b:	75 5c                	jne    80100b89 <exec+0x179>
        if (loaduvm(pgdir, (char *) ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b2d:	83 ec 0c             	sub    $0xc,%esp
80100b30:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b36:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b3c:	53                   	push   %ebx
80100b3d:	50                   	push   %eax
80100b3e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b44:	e8 47 70 00 00       	call   80107b90 <loaduvm>
80100b49:	83 c4 20             	add    $0x20,%esp
80100b4c:	85 c0                	test   %eax,%eax
80100b4e:	78 39                	js     80100b89 <exec+0x179>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100b50:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b57:	83 c7 01             	add    $0x1,%edi
80100b5a:	39 f8                	cmp    %edi,%eax
80100b5c:	0f 8e aa 00 00 00    	jle    80100c0c <exec+0x1fc>
        if (readi(ip, (char *) &ph, off, sizeof(ph)) != sizeof(ph))
80100b62:	89 f8                	mov    %edi,%eax
80100b64:	6a 20                	push   $0x20
80100b66:	c1 e0 05             	shl    $0x5,%eax
80100b69:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100b6f:	50                   	push   %eax
80100b70:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b76:	50                   	push   %eax
80100b77:	53                   	push   %ebx
80100b78:	e8 a3 0e 00 00       	call   80101a20 <readi>
80100b7d:	83 c4 10             	add    $0x10,%esp
80100b80:	83 f8 20             	cmp    $0x20,%eax
80100b83:	0f 84 57 ff ff ff    	je     80100ae0 <exec+0xd0>
        freevm(pgdir);
80100b89:	83 ec 0c             	sub    $0xc,%esp
80100b8c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b92:	e8 89 75 00 00       	call   80108120 <freevm>
80100b97:	83 c4 10             	add    $0x10,%esp
80100b9a:	e9 d3 fe ff ff       	jmp    80100a72 <exec+0x62>
80100b9f:	90                   	nop
        removeSwapFile(curproc);
80100ba0:	83 ec 0c             	sub    $0xc,%esp
80100ba3:	56                   	push   %esi
80100ba4:	e8 c7 14 00 00       	call   80102070 <removeSwapFile>
        createSwapFile(curproc);
80100ba9:	89 34 24             	mov    %esi,(%esp)
80100bac:	e8 bf 16 00 00       	call   80102270 <createSwapFile>
        for( pg = curproc->pages ; pg < &curproc->pages[MAX_TOTAL_PAGES] ; pg++ ) {
80100bb1:	8d 86 80 00 00 00    	lea    0x80(%esi),%eax
80100bb7:	8d 96 00 04 00 00    	lea    0x400(%esi),%edx
80100bbd:	83 c4 10             	add    $0x10,%esp
            if (pg->active)
80100bc0:	8b 08                	mov    (%eax),%ecx
80100bc2:	85 c9                	test   %ecx,%ecx
80100bc4:	74 30                	je     80100bf6 <exec+0x1e6>
                pg->active = 0;     //page activated
80100bc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                pg->pageid = 0;    // page id
80100bcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                pg->sequel = 0;     // sequel number entering physyc memory
80100bd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                pg->present = 0;    // 1 = in physycal memory
80100bda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                pg->offset = 0;    // page offset in swap file
80100be1:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                pg->physAdress = 0;    // page offset in swap file
80100be8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                pg->virtAdress = 0;
80100bef:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        for( pg = curproc->pages ; pg < &curproc->pages[MAX_TOTAL_PAGES] ; pg++ ) {
80100bf6:	83 c0 1c             	add    $0x1c,%eax
80100bf9:	39 c2                	cmp    %eax,%edx
80100bfb:	77 c3                	ja     80100bc0 <exec+0x1b0>
        curproc->pagesCounter = 0;
80100bfd:	c7 86 44 04 00 00 00 	movl   $0x0,0x444(%esi)
80100c04:	00 00 00 
80100c07:	e9 4d fe ff ff       	jmp    80100a59 <exec+0x49>
80100c0c:	89 f0                	mov    %esi,%eax
80100c0e:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100c14:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c19:	89 c7                	mov    %eax,%edi
80100c1b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c21:	8d 87 00 20 00 00    	lea    0x2000(%edi),%eax
    iunlockput(ip);
80100c27:	83 ec 0c             	sub    $0xc,%esp
80100c2a:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c30:	53                   	push   %ebx
80100c31:	e8 9a 0d 00 00       	call   801019d0 <iunlockput>
    end_op();
80100c36:	e8 a5 24 00 00       	call   801030e0 <end_op>
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100c3b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c41:	83 c4 0c             	add    $0xc,%esp
80100c44:	50                   	push   %eax
80100c45:	57                   	push   %edi
80100c46:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c4c:	e8 6f 72 00 00       	call   80107ec0 <allocuvm>
80100c51:	83 c4 10             	add    $0x10,%esp
80100c54:	85 c0                	test   %eax,%eax
80100c56:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c5c:	75 3a                	jne    80100c98 <exec+0x288>
        freevm(pgdir);
80100c5e:	83 ec 0c             	sub    $0xc,%esp
80100c61:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c67:	e8 b4 74 00 00       	call   80108120 <freevm>
80100c6c:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c74:	e9 0f fe ff ff       	jmp    80100a88 <exec+0x78>
        end_op();
80100c79:	e8 62 24 00 00       	call   801030e0 <end_op>
        cprintf("exec: fail\n");
80100c7e:	83 ec 0c             	sub    $0xc,%esp
80100c81:	68 c1 84 10 80       	push   $0x801084c1
80100c86:	e8 d5 f9 ff ff       	call   80100660 <cprintf>
        return -1;
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c93:	e9 f0 fd ff ff       	jmp    80100a88 <exec+0x78>
    clearpteu(pgdir, (char *) (sz - 2 * PGSIZE));
80100c98:	89 c3                	mov    %eax,%ebx
80100c9a:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ca0:	83 ec 08             	sub    $0x8,%esp
    for (argc = 0; argv[argc]; argc++) {
80100ca3:	31 ff                	xor    %edi,%edi
    clearpteu(pgdir, (char *) (sz - 2 * PGSIZE));
80100ca5:	50                   	push   %eax
80100ca6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cac:	e8 8f 75 00 00       	call   80108240 <clearpteu>
    for (argc = 0; argv[argc]; argc++) {
80100cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb4:	83 c4 10             	add    $0x10,%esp
80100cb7:	8b 00                	mov    (%eax),%eax
80100cb9:	85 c0                	test   %eax,%eax
80100cbb:	0f 84 3e 01 00 00    	je     80100dff <exec+0x3ef>
80100cc1:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100cc7:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100ccd:	eb 06                	jmp    80100cd5 <exec+0x2c5>
80100ccf:	90                   	nop
        if (argc >= MAXARG)
80100cd0:	83 ff 20             	cmp    $0x20,%edi
80100cd3:	74 89                	je     80100c5e <exec+0x24e>
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 ec 0c             	sub    $0xc,%esp
80100cd8:	50                   	push   %eax
80100cd9:	e8 42 47 00 00       	call   80105420 <strlen>
80100cde:	f7 d0                	not    %eax
80100ce0:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ce5:	5a                   	pop    %edx
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce6:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce9:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cec:	e8 2f 47 00 00       	call   80105420 <strlen>
80100cf1:	83 c0 01             	add    $0x1,%eax
80100cf4:	50                   	push   %eax
80100cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf8:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cfb:	53                   	push   %ebx
80100cfc:	56                   	push   %esi
80100cfd:	e8 9e 76 00 00       	call   801083a0 <copyout>
80100d02:	83 c4 20             	add    $0x20,%esp
80100d05:	85 c0                	test   %eax,%eax
80100d07:	0f 88 51 ff ff ff    	js     80100c5e <exec+0x24e>
    for (argc = 0; argv[argc]; argc++) {
80100d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
        ustack[3 + argc] = sp;
80100d10:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    for (argc = 0; argv[argc]; argc++) {
80100d17:	83 c7 01             	add    $0x1,%edi
        ustack[3 + argc] = sp;
80100d1a:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
    for (argc = 0; argv[argc]; argc++) {
80100d20:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d23:	85 c0                	test   %eax,%eax
80100d25:	75 a9                	jne    80100cd0 <exec+0x2c0>
80100d27:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100d2d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d34:	89 da                	mov    %ebx,%edx
    ustack[3 + argc] = 0;
80100d36:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d3d:	00 00 00 00 
    ustack[0] = 0xffffffff;  // fake return PC
80100d41:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d48:	ff ff ff 
    ustack[1] = argc;
80100d4b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100d51:	29 c2                	sub    %eax,%edx
    sp -= (3 + argc + 1) * 4;
80100d53:	83 c0 0c             	add    $0xc,%eax
80100d56:	29 c3                	sub    %eax,%ebx
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100d58:	50                   	push   %eax
80100d59:	51                   	push   %ecx
80100d5a:	53                   	push   %ebx
80100d5b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100d61:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100d67:	e8 34 76 00 00       	call   801083a0 <copyout>
80100d6c:	83 c4 10             	add    $0x10,%esp
80100d6f:	85 c0                	test   %eax,%eax
80100d71:	0f 88 e7 fe ff ff    	js     80100c5e <exec+0x24e>
    for (last = s = path; *s; s++)
80100d77:	8b 45 08             	mov    0x8(%ebp),%eax
80100d7a:	0f b6 00             	movzbl (%eax),%eax
80100d7d:	84 c0                	test   %al,%al
80100d7f:	74 17                	je     80100d98 <exec+0x388>
80100d81:	8b 55 08             	mov    0x8(%ebp),%edx
80100d84:	89 d1                	mov    %edx,%ecx
80100d86:	83 c1 01             	add    $0x1,%ecx
80100d89:	3c 2f                	cmp    $0x2f,%al
80100d8b:	0f b6 01             	movzbl (%ecx),%eax
80100d8e:	0f 44 d1             	cmove  %ecx,%edx
80100d91:	84 c0                	test   %al,%al
80100d93:	75 f1                	jne    80100d86 <exec+0x376>
80100d95:	89 55 08             	mov    %edx,0x8(%ebp)
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d98:	50                   	push   %eax
80100d99:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9c:	6a 10                	push   $0x10
80100d9e:	ff 75 08             	pushl  0x8(%ebp)
80100da1:	50                   	push   %eax
80100da2:	e8 39 46 00 00       	call   801053e0 <safestrcpy>
    oldpgdir = curproc->pgdir;
80100da7:	8b 46 04             	mov    0x4(%esi),%eax
    curproc->tf->eip = elf.entry;  // main
80100daa:	8b 56 18             	mov    0x18(%esi),%edx
    oldpgdir = curproc->pgdir;
80100dad:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
    curproc->pgdir = pgdir;
80100db3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100db9:	89 46 04             	mov    %eax,0x4(%esi)
    curproc->sz = sz;
80100dbc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100dc2:	89 06                	mov    %eax,(%esi)
    curproc->tf->eip = elf.entry;  // main
80100dc4:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100dca:	89 4a 38             	mov    %ecx,0x38(%edx)
    curproc->tf->esp = sp;
80100dcd:	8b 56 18             	mov    0x18(%esi),%edx
80100dd0:	89 5a 44             	mov    %ebx,0x44(%edx)
    switchuvm(curproc);
80100dd3:	89 34 24             	mov    %esi,(%esp)
80100dd6:	e8 25 6c 00 00       	call   80107a00 <switchuvm>
    freevm(oldpgdir);
80100ddb:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100de1:	89 04 24             	mov    %eax,(%esp)
80100de4:	e8 37 73 00 00       	call   80108120 <freevm>
    return 0;
80100de9:	83 c4 10             	add    $0x10,%esp
80100dec:	31 c0                	xor    %eax,%eax
80100dee:	e9 95 fc ff ff       	jmp    80100a88 <exec+0x78>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100df3:	31 ff                	xor    %edi,%edi
80100df5:	b8 00 20 00 00       	mov    $0x2000,%eax
80100dfa:	e9 28 fe ff ff       	jmp    80100c27 <exec+0x217>
    for (argc = 0; argv[argc]; argc++) {
80100dff:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100e05:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e0b:	e9 1d ff ff ff       	jmp    80100d2d <exec+0x31d>

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
80100e16:	68 cd 84 10 80       	push   $0x801084cd
80100e1b:	68 e0 1f 11 80       	push   $0x80111fe0
80100e20:	e8 6b 41 00 00       	call   80104f90 <initlock>
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
80100e34:	bb 14 20 11 80       	mov    $0x80112014,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 e0 1f 11 80       	push   $0x80111fe0
80100e41:	e8 3a 42 00 00       	call   80105080 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	90                   	nop
80100e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb 74 29 11 80    	cmp    $0x80112974,%ebx
80100e59:	73 25                	jae    80100e80 <filealloc+0x50>
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
80100e6c:	68 e0 1f 11 80       	push   $0x80111fe0
80100e71:	e8 2a 43 00 00       	call   801051a0 <release>
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
80100e85:	68 e0 1f 11 80       	push   $0x80111fe0
80100e8a:	e8 11 43 00 00       	call   801051a0 <release>
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
80100eaa:	68 e0 1f 11 80       	push   $0x80111fe0
80100eaf:	e8 cc 41 00 00       	call   80105080 <acquire>
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
80100ec7:	68 e0 1f 11 80       	push   $0x80111fe0
80100ecc:	e8 cf 42 00 00       	call   801051a0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 d4 84 10 80       	push   $0x801084d4
80100ee0:	e8 ab f4 ff ff       	call   80100390 <panic>
80100ee5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
80100efc:	68 e0 1f 11 80       	push   $0x80111fe0
80100f01:	e8 7a 41 00 00       	call   80105080 <acquire>
  if(f->ref < 1)
80100f06:	8b 43 04             	mov    0x4(%ebx),%eax
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 c0                	test   %eax,%eax
80100f0e:	0f 8e 9b 00 00 00    	jle    80100faf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 e8 01             	sub    $0x1,%eax
80100f17:	85 c0                	test   %eax,%eax
80100f19:	89 43 04             	mov    %eax,0x4(%ebx)
80100f1c:	74 1a                	je     80100f38 <fileclose+0x48>
    release(&ftable.lock);
80100f1e:	c7 45 08 e0 1f 11 80 	movl   $0x80111fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f28:	5b                   	pop    %ebx
80100f29:	5e                   	pop    %esi
80100f2a:	5f                   	pop    %edi
80100f2b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f2c:	e9 6f 42 00 00       	jmp    801051a0 <release>
80100f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f38:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f3c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f3e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f41:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f4d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f50:	68 e0 1f 11 80       	push   $0x80111fe0
  ff = *f;
80100f55:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f58:	e8 43 42 00 00       	call   801051a0 <release>
  if(ff.type == FD_PIPE)
80100f5d:	83 c4 10             	add    $0x10,%esp
80100f60:	83 ff 01             	cmp    $0x1,%edi
80100f63:	74 13                	je     80100f78 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f65:	83 ff 02             	cmp    $0x2,%edi
80100f68:	74 26                	je     80100f90 <fileclose+0xa0>
}
80100f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6d:	5b                   	pop    %ebx
80100f6e:	5e                   	pop    %esi
80100f6f:	5f                   	pop    %edi
80100f70:	5d                   	pop    %ebp
80100f71:	c3                   	ret    
80100f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f78:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f7c:	83 ec 08             	sub    $0x8,%esp
80100f7f:	53                   	push   %ebx
80100f80:	56                   	push   %esi
80100f81:	e8 9a 28 00 00       	call   80103820 <pipeclose>
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	eb df                	jmp    80100f6a <fileclose+0x7a>
80100f8b:	90                   	nop
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f90:	e8 db 20 00 00       	call   80103070 <begin_op>
    iput(ff.ip);
80100f95:	83 ec 0c             	sub    $0xc,%esp
80100f98:	ff 75 e0             	pushl  -0x20(%ebp)
80100f9b:	e8 d0 08 00 00       	call   80101870 <iput>
    end_op();
80100fa0:	83 c4 10             	add    $0x10,%esp
}
80100fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa6:	5b                   	pop    %ebx
80100fa7:	5e                   	pop    %esi
80100fa8:	5f                   	pop    %edi
80100fa9:	5d                   	pop    %ebp
    end_op();
80100faa:	e9 31 21 00 00       	jmp    801030e0 <end_op>
    panic("fileclose");
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	68 dc 84 10 80       	push   $0x801084dc
80100fb7:	e8 d4 f3 ff ff       	call   80100390 <panic>
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 04             	sub    $0x4,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fca:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fcd:	75 31                	jne    80101000 <filestat+0x40>
    ilock(f->ip);
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	ff 73 10             	pushl  0x10(%ebx)
80100fd5:	e8 66 07 00 00       	call   80101740 <ilock>
    stati(f->ip, st);
80100fda:	58                   	pop    %eax
80100fdb:	5a                   	pop    %edx
80100fdc:	ff 75 0c             	pushl  0xc(%ebp)
80100fdf:	ff 73 10             	pushl  0x10(%ebx)
80100fe2:	e8 09 0a 00 00       	call   801019f0 <stati>
    iunlock(f->ip);
80100fe7:	59                   	pop    %ecx
80100fe8:	ff 73 10             	pushl  0x10(%ebx)
80100feb:	e8 30 08 00 00       	call   80101820 <iunlock>
    return 0;
80100ff0:	83 c4 10             	add    $0x10,%esp
80100ff3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101005:	eb ee                	jmp    80100ff5 <filestat+0x35>
80101007:	89 f6                	mov    %esi,%esi
80101009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101010 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 0c             	sub    $0xc,%esp
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010101c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010101f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101022:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101026:	74 60                	je     80101088 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101028:	8b 03                	mov    (%ebx),%eax
8010102a:	83 f8 01             	cmp    $0x1,%eax
8010102d:	74 41                	je     80101070 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102f:	83 f8 02             	cmp    $0x2,%eax
80101032:	75 5b                	jne    8010108f <fileread+0x7f>
    ilock(f->ip);
80101034:	83 ec 0c             	sub    $0xc,%esp
80101037:	ff 73 10             	pushl  0x10(%ebx)
8010103a:	e8 01 07 00 00       	call   80101740 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010103f:	57                   	push   %edi
80101040:	ff 73 14             	pushl  0x14(%ebx)
80101043:	56                   	push   %esi
80101044:	ff 73 10             	pushl  0x10(%ebx)
80101047:	e8 d4 09 00 00       	call   80101a20 <readi>
8010104c:	83 c4 20             	add    $0x20,%esp
8010104f:	85 c0                	test   %eax,%eax
80101051:	89 c6                	mov    %eax,%esi
80101053:	7e 03                	jle    80101058 <fileread+0x48>
      f->off += r;
80101055:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	ff 73 10             	pushl  0x10(%ebx)
8010105e:	e8 bd 07 00 00       	call   80101820 <iunlock>
    return r;
80101063:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101069:	89 f0                	mov    %esi,%eax
8010106b:	5b                   	pop    %ebx
8010106c:	5e                   	pop    %esi
8010106d:	5f                   	pop    %edi
8010106e:	5d                   	pop    %ebp
8010106f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101070:	8b 43 0c             	mov    0xc(%ebx),%eax
80101073:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	5b                   	pop    %ebx
8010107a:	5e                   	pop    %esi
8010107b:	5f                   	pop    %edi
8010107c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010107d:	e9 4e 29 00 00       	jmp    801039d0 <piperead>
80101082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101088:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010108d:	eb d7                	jmp    80101066 <fileread+0x56>
  panic("fileread");
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	68 e6 84 10 80       	push   $0x801084e6
80101097:	e8 f4 f2 ff ff       	call   80100390 <panic>
8010109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	55                   	push   %ebp
801010a1:	89 e5                	mov    %esp,%ebp
801010a3:	57                   	push   %edi
801010a4:	56                   	push   %esi
801010a5:	53                   	push   %ebx
801010a6:	83 ec 1c             	sub    $0x1c,%esp
801010a9:	8b 75 08             	mov    0x8(%ebp),%esi
801010ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801010af:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
801010b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010bc:	0f 84 aa 00 00 00    	je     8010116c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801010c2:	8b 06                	mov    (%esi),%eax
801010c4:	83 f8 01             	cmp    $0x1,%eax
801010c7:	0f 84 c3 00 00 00    	je     80101190 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010cd:	83 f8 02             	cmp    $0x2,%eax
801010d0:	0f 85 d9 00 00 00    	jne    801011af <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010d9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010db:	85 c0                	test   %eax,%eax
801010dd:	7f 34                	jg     80101113 <filewrite+0x73>
801010df:	e9 9c 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010eb:	83 ec 0c             	sub    $0xc,%esp
801010ee:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010f4:	e8 27 07 00 00       	call   80101820 <iunlock>
      end_op();
801010f9:	e8 e2 1f 00 00       	call   801030e0 <end_op>
801010fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101101:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101104:	39 c3                	cmp    %eax,%ebx
80101106:	0f 85 96 00 00 00    	jne    801011a2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010110c:	01 df                	add    %ebx,%edi
    while(i < n){
8010110e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101111:	7e 6d                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101113:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101116:	b8 00 06 00 00       	mov    $0x600,%eax
8010111b:	29 fb                	sub    %edi,%ebx
8010111d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101123:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101126:	e8 45 1f 00 00       	call   80103070 <begin_op>
      ilock(f->ip);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	ff 76 10             	pushl  0x10(%esi)
80101131:	e8 0a 06 00 00       	call   80101740 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101136:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101139:	53                   	push   %ebx
8010113a:	ff 76 14             	pushl  0x14(%esi)
8010113d:	01 f8                	add    %edi,%eax
8010113f:	50                   	push   %eax
80101140:	ff 76 10             	pushl  0x10(%esi)
80101143:	e8 d8 09 00 00       	call   80101b20 <writei>
80101148:	83 c4 20             	add    $0x20,%esp
8010114b:	85 c0                	test   %eax,%eax
8010114d:	7f 99                	jg     801010e8 <filewrite+0x48>
      iunlock(f->ip);
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	ff 76 10             	pushl  0x10(%esi)
80101155:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101158:	e8 c3 06 00 00       	call   80101820 <iunlock>
      end_op();
8010115d:	e8 7e 1f 00 00       	call   801030e0 <end_op>
      if(r < 0)
80101162:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101165:	83 c4 10             	add    $0x10,%esp
80101168:	85 c0                	test   %eax,%eax
8010116a:	74 98                	je     80101104 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010116c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010116f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101174:	89 f8                	mov    %edi,%eax
80101176:	5b                   	pop    %ebx
80101177:	5e                   	pop    %esi
80101178:	5f                   	pop    %edi
80101179:	5d                   	pop    %ebp
8010117a:	c3                   	ret    
8010117b:	90                   	nop
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101180:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101183:	75 e7                	jne    8010116c <filewrite+0xcc>
}
80101185:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101188:	89 f8                	mov    %edi,%eax
8010118a:	5b                   	pop    %ebx
8010118b:	5e                   	pop    %esi
8010118c:	5f                   	pop    %edi
8010118d:	5d                   	pop    %ebp
8010118e:	c3                   	ret    
8010118f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101190:	8b 46 0c             	mov    0xc(%esi),%eax
80101193:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	5b                   	pop    %ebx
8010119a:	5e                   	pop    %esi
8010119b:	5f                   	pop    %edi
8010119c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010119d:	e9 1e 27 00 00       	jmp    801038c0 <pipewrite>
        panic("short filewrite");
801011a2:	83 ec 0c             	sub    $0xc,%esp
801011a5:	68 ef 84 10 80       	push   $0x801084ef
801011aa:	e8 e1 f1 ff ff       	call   80100390 <panic>
  panic("filewrite");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 f5 84 10 80       	push   $0x801084f5
801011b7:	e8 d4 f1 ff ff       	call   80100390 <panic>
801011bc:	66 90                	xchg   %ax,%ax
801011be:	66 90                	xchg   %ax,%ax

801011c0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011c9:	8b 0d e0 29 11 80    	mov    0x801129e0,%ecx
{
801011cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011d2:	85 c9                	test   %ecx,%ecx
801011d4:	0f 84 87 00 00 00    	je     80101261 <balloc+0xa1>
801011da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	89 f0                	mov    %esi,%eax
801011e9:	c1 f8 0c             	sar    $0xc,%eax
801011ec:	03 05 f8 29 11 80    	add    0x801129f8,%eax
801011f2:	50                   	push   %eax
801011f3:	ff 75 d8             	pushl  -0x28(%ebp)
801011f6:	e8 d5 ee ff ff       	call   801000d0 <bread>
801011fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011fe:	a1 e0 29 11 80       	mov    0x801129e0,%eax
80101203:	83 c4 10             	add    $0x10,%esp
80101206:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101209:	31 c0                	xor    %eax,%eax
8010120b:	eb 2f                	jmp    8010123c <balloc+0x7c>
8010120d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101210:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101215:	bb 01 00 00 00       	mov    $0x1,%ebx
8010121a:	83 e1 07             	and    $0x7,%ecx
8010121d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010121f:	89 c1                	mov    %eax,%ecx
80101221:	c1 f9 03             	sar    $0x3,%ecx
80101224:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101229:	85 df                	test   %ebx,%edi
8010122b:	89 fa                	mov    %edi,%edx
8010122d:	74 41                	je     80101270 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010122f:	83 c0 01             	add    $0x1,%eax
80101232:	83 c6 01             	add    $0x1,%esi
80101235:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010123a:	74 05                	je     80101241 <balloc+0x81>
8010123c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010123f:	77 cf                	ja     80101210 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	ff 75 e4             	pushl  -0x1c(%ebp)
80101247:	e8 94 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010124c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101253:	83 c4 10             	add    $0x10,%esp
80101256:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101259:	39 05 e0 29 11 80    	cmp    %eax,0x801129e0
8010125f:	77 80                	ja     801011e1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101261:	83 ec 0c             	sub    $0xc,%esp
80101264:	68 ff 84 10 80       	push   $0x801084ff
80101269:	e8 22 f1 ff ff       	call   80100390 <panic>
8010126e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101270:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101273:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101276:	09 da                	or     %ebx,%edx
80101278:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010127c:	57                   	push   %edi
8010127d:	e8 be 1f 00 00       	call   80103240 <log_write>
        brelse(bp);
80101282:	89 3c 24             	mov    %edi,(%esp)
80101285:	e8 56 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010128a:	58                   	pop    %eax
8010128b:	5a                   	pop    %edx
8010128c:	56                   	push   %esi
8010128d:	ff 75 d8             	pushl  -0x28(%ebp)
80101290:	e8 3b ee ff ff       	call   801000d0 <bread>
80101295:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101297:	8d 40 5c             	lea    0x5c(%eax),%eax
8010129a:	83 c4 0c             	add    $0xc,%esp
8010129d:	68 00 02 00 00       	push   $0x200
801012a2:	6a 00                	push   $0x0
801012a4:	50                   	push   %eax
801012a5:	e8 56 3f 00 00       	call   80105200 <memset>
  log_write(bp);
801012aa:	89 1c 24             	mov    %ebx,(%esp)
801012ad:	e8 8e 1f 00 00       	call   80103240 <log_write>
  brelse(bp);
801012b2:	89 1c 24             	mov    %ebx,(%esp)
801012b5:	e8 26 ef ff ff       	call   801001e0 <brelse>
}
801012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012bd:	89 f0                	mov    %esi,%eax
801012bf:	5b                   	pop    %ebx
801012c0:	5e                   	pop    %esi
801012c1:	5f                   	pop    %edi
801012c2:	5d                   	pop    %ebp
801012c3:	c3                   	ret    
801012c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012d8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	bb 34 2a 11 80       	mov    $0x80112a34,%ebx
{
801012df:	83 ec 28             	sub    $0x28,%esp
801012e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012e5:	68 00 2a 11 80       	push   $0x80112a00
801012ea:	e8 91 3d 00 00       	call   80105080 <acquire>
801012ef:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012f5:	eb 17                	jmp    8010130e <iget+0x3e>
801012f7:	89 f6                	mov    %esi,%esi
801012f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101300:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101306:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
8010130c:	73 22                	jae    80101330 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010130e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101311:	85 c9                	test   %ecx,%ecx
80101313:	7e 04                	jle    80101319 <iget+0x49>
80101315:	39 3b                	cmp    %edi,(%ebx)
80101317:	74 4f                	je     80101368 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101319:	85 f6                	test   %esi,%esi
8010131b:	75 e3                	jne    80101300 <iget+0x30>
8010131d:	85 c9                	test   %ecx,%ecx
8010131f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101322:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101328:	81 fb 54 46 11 80    	cmp    $0x80114654,%ebx
8010132e:	72 de                	jb     8010130e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101330:	85 f6                	test   %esi,%esi
80101332:	74 5b                	je     8010138f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101334:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101337:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101339:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010133c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101343:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010134a:	68 00 2a 11 80       	push   $0x80112a00
8010134f:	e8 4c 3e 00 00       	call   801051a0 <release>

  return ip;
80101354:	83 c4 10             	add    $0x10,%esp
}
80101357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135a:	89 f0                	mov    %esi,%eax
8010135c:	5b                   	pop    %ebx
8010135d:	5e                   	pop    %esi
8010135e:	5f                   	pop    %edi
8010135f:	5d                   	pop    %ebp
80101360:	c3                   	ret    
80101361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101368:	39 53 04             	cmp    %edx,0x4(%ebx)
8010136b:	75 ac                	jne    80101319 <iget+0x49>
      release(&icache.lock);
8010136d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101370:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101373:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101375:	68 00 2a 11 80       	push   $0x80112a00
      ip->ref++;
8010137a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010137d:	e8 1e 3e 00 00       	call   801051a0 <release>
      return ip;
80101382:	83 c4 10             	add    $0x10,%esp
}
80101385:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101388:	89 f0                	mov    %esi,%eax
8010138a:	5b                   	pop    %ebx
8010138b:	5e                   	pop    %esi
8010138c:	5f                   	pop    %edi
8010138d:	5d                   	pop    %ebp
8010138e:	c3                   	ret    
    panic("iget: no inodes");
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	68 15 85 10 80       	push   $0x80108515
80101397:	e8 f4 ef ff ff       	call   80100390 <panic>
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	89 c6                	mov    %eax,%esi
801013a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013ab:	83 fa 0b             	cmp    $0xb,%edx
801013ae:	77 18                	ja     801013c8 <bmap+0x28>
801013b0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801013b3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801013b6:	85 db                	test   %ebx,%ebx
801013b8:	74 76                	je     80101430 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013bd:	89 d8                	mov    %ebx,%eax
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5f                   	pop    %edi
801013c2:	5d                   	pop    %ebp
801013c3:	c3                   	ret    
801013c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013c8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013cb:	83 fb 7f             	cmp    $0x7f,%ebx
801013ce:	0f 87 90 00 00 00    	ja     80101464 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013d4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013da:	8b 00                	mov    (%eax),%eax
801013dc:	85 d2                	test   %edx,%edx
801013de:	74 70                	je     80101450 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013e0:	83 ec 08             	sub    $0x8,%esp
801013e3:	52                   	push   %edx
801013e4:	50                   	push   %eax
801013e5:	e8 e6 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013ea:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ee:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013f1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013f3:	8b 1a                	mov    (%edx),%ebx
801013f5:	85 db                	test   %ebx,%ebx
801013f7:	75 1d                	jne    80101416 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013f9:	8b 06                	mov    (%esi),%eax
801013fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013fe:	e8 bd fd ff ff       	call   801011c0 <balloc>
80101403:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101406:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101409:	89 c3                	mov    %eax,%ebx
8010140b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010140d:	57                   	push   %edi
8010140e:	e8 2d 1e 00 00       	call   80103240 <log_write>
80101413:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101416:	83 ec 0c             	sub    $0xc,%esp
80101419:	57                   	push   %edi
8010141a:	e8 c1 ed ff ff       	call   801001e0 <brelse>
8010141f:	83 c4 10             	add    $0x10,%esp
}
80101422:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101425:	89 d8                	mov    %ebx,%eax
80101427:	5b                   	pop    %ebx
80101428:	5e                   	pop    %esi
80101429:	5f                   	pop    %edi
8010142a:	5d                   	pop    %ebp
8010142b:	c3                   	ret    
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101430:	8b 00                	mov    (%eax),%eax
80101432:	e8 89 fd ff ff       	call   801011c0 <balloc>
80101437:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010143a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010143d:	89 c3                	mov    %eax,%ebx
}
8010143f:	89 d8                	mov    %ebx,%eax
80101441:	5b                   	pop    %ebx
80101442:	5e                   	pop    %esi
80101443:	5f                   	pop    %edi
80101444:	5d                   	pop    %ebp
80101445:	c3                   	ret    
80101446:	8d 76 00             	lea    0x0(%esi),%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101450:	e8 6b fd ff ff       	call   801011c0 <balloc>
80101455:	89 c2                	mov    %eax,%edx
80101457:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010145d:	8b 06                	mov    (%esi),%eax
8010145f:	e9 7c ff ff ff       	jmp    801013e0 <bmap+0x40>
  panic("bmap: out of range");
80101464:	83 ec 0c             	sub    $0xc,%esp
80101467:	68 25 85 10 80       	push   $0x80108525
8010146c:	e8 1f ef ff ff       	call   80100390 <panic>
80101471:	eb 0d                	jmp    80101480 <readsb>
80101473:	90                   	nop
80101474:	90                   	nop
80101475:	90                   	nop
80101476:	90                   	nop
80101477:	90                   	nop
80101478:	90                   	nop
80101479:	90                   	nop
8010147a:	90                   	nop
8010147b:	90                   	nop
8010147c:	90                   	nop
8010147d:	90                   	nop
8010147e:	90                   	nop
8010147f:	90                   	nop

80101480 <readsb>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	53                   	push   %ebx
80101485:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101488:	83 ec 08             	sub    $0x8,%esp
8010148b:	6a 01                	push   $0x1
8010148d:	ff 75 08             	pushl  0x8(%ebp)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
80101495:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101497:	8d 40 5c             	lea    0x5c(%eax),%eax
8010149a:	83 c4 0c             	add    $0xc,%esp
8010149d:	6a 1c                	push   $0x1c
8010149f:	50                   	push   %eax
801014a0:	56                   	push   %esi
801014a1:	e8 0a 3e 00 00       	call   801052b0 <memmove>
  brelse(bp);
801014a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014a9:	83 c4 10             	add    $0x10,%esp
}
801014ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014af:	5b                   	pop    %ebx
801014b0:	5e                   	pop    %esi
801014b1:	5d                   	pop    %ebp
  brelse(bp);
801014b2:	e9 29 ed ff ff       	jmp    801001e0 <brelse>
801014b7:	89 f6                	mov    %esi,%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014c0 <bfree>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	53                   	push   %ebx
801014c5:	89 d3                	mov    %edx,%ebx
801014c7:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
801014c9:	83 ec 08             	sub    $0x8,%esp
801014cc:	68 e0 29 11 80       	push   $0x801129e0
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	5a                   	pop    %edx
801014d9:	89 da                	mov    %ebx,%edx
801014db:	c1 ea 0c             	shr    $0xc,%edx
801014de:	03 15 f8 29 11 80    	add    0x801129f8,%edx
801014e4:	52                   	push   %edx
801014e5:	56                   	push   %esi
801014e6:	e8 e5 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ed:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014f0:	ba 01 00 00 00       	mov    $0x1,%edx
801014f5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014fe:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101501:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101503:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101508:	85 d1                	test   %edx,%ecx
8010150a:	74 25                	je     80101531 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010150c:	f7 d2                	not    %edx
8010150e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101510:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101513:	21 ca                	and    %ecx,%edx
80101515:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101519:	56                   	push   %esi
8010151a:	e8 21 1d 00 00       	call   80103240 <log_write>
  brelse(bp);
8010151f:	89 34 24             	mov    %esi,(%esp)
80101522:	e8 b9 ec ff ff       	call   801001e0 <brelse>
}
80101527:	83 c4 10             	add    $0x10,%esp
8010152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152d:	5b                   	pop    %ebx
8010152e:	5e                   	pop    %esi
8010152f:	5d                   	pop    %ebp
80101530:	c3                   	ret    
    panic("freeing free block");
80101531:	83 ec 0c             	sub    $0xc,%esp
80101534:	68 38 85 10 80       	push   $0x80108538
80101539:	e8 52 ee ff ff       	call   80100390 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <iinit>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	53                   	push   %ebx
80101544:	bb 40 2a 11 80       	mov    $0x80112a40,%ebx
80101549:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010154c:	68 4b 85 10 80       	push   $0x8010854b
80101551:	68 00 2a 11 80       	push   $0x80112a00
80101556:	e8 35 3a 00 00       	call   80104f90 <initlock>
8010155b:	83 c4 10             	add    $0x10,%esp
8010155e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101560:	83 ec 08             	sub    $0x8,%esp
80101563:	68 52 85 10 80       	push   $0x80108552
80101568:	53                   	push   %ebx
80101569:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010156f:	e8 0c 39 00 00       	call   80104e80 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101574:	83 c4 10             	add    $0x10,%esp
80101577:	81 fb 60 46 11 80    	cmp    $0x80114660,%ebx
8010157d:	75 e1                	jne    80101560 <iinit+0x20>
  readsb(dev, &sb);
8010157f:	83 ec 08             	sub    $0x8,%esp
80101582:	68 e0 29 11 80       	push   $0x801129e0
80101587:	ff 75 08             	pushl  0x8(%ebp)
8010158a:	e8 f1 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010158f:	ff 35 f8 29 11 80    	pushl  0x801129f8
80101595:	ff 35 f4 29 11 80    	pushl  0x801129f4
8010159b:	ff 35 f0 29 11 80    	pushl  0x801129f0
801015a1:	ff 35 ec 29 11 80    	pushl  0x801129ec
801015a7:	ff 35 e8 29 11 80    	pushl  0x801129e8
801015ad:	ff 35 e4 29 11 80    	pushl  0x801129e4
801015b3:	ff 35 e0 29 11 80    	pushl  0x801129e0
801015b9:	68 fc 85 10 80       	push   $0x801085fc
801015be:	e8 9d f0 ff ff       	call   80100660 <cprintf>
}
801015c3:	83 c4 30             	add    $0x30,%esp
801015c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015c9:	c9                   	leave  
801015ca:	c3                   	ret    
801015cb:	90                   	nop
801015cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015d0 <ialloc>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	57                   	push   %edi
801015d4:	56                   	push   %esi
801015d5:	53                   	push   %ebx
801015d6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015d9:	83 3d e8 29 11 80 01 	cmpl   $0x1,0x801129e8
{
801015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e3:	8b 75 08             	mov    0x8(%ebp),%esi
801015e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015e9:	0f 86 91 00 00 00    	jbe    80101680 <ialloc+0xb0>
801015ef:	bb 01 00 00 00       	mov    $0x1,%ebx
801015f4:	eb 21                	jmp    80101617 <ialloc+0x47>
801015f6:	8d 76 00             	lea    0x0(%esi),%esi
801015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101600:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101603:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101606:	57                   	push   %edi
80101607:	e8 d4 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010160c:	83 c4 10             	add    $0x10,%esp
8010160f:	39 1d e8 29 11 80    	cmp    %ebx,0x801129e8
80101615:	76 69                	jbe    80101680 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101617:	89 d8                	mov    %ebx,%eax
80101619:	83 ec 08             	sub    $0x8,%esp
8010161c:	c1 e8 03             	shr    $0x3,%eax
8010161f:	03 05 f4 29 11 80    	add    0x801129f4,%eax
80101625:	50                   	push   %eax
80101626:	56                   	push   %esi
80101627:	e8 a4 ea ff ff       	call   801000d0 <bread>
8010162c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010162e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101630:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101633:	83 e0 07             	and    $0x7,%eax
80101636:	c1 e0 06             	shl    $0x6,%eax
80101639:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010163d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101641:	75 bd                	jne    80101600 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101643:	83 ec 04             	sub    $0x4,%esp
80101646:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101649:	6a 40                	push   $0x40
8010164b:	6a 00                	push   $0x0
8010164d:	51                   	push   %ecx
8010164e:	e8 ad 3b 00 00       	call   80105200 <memset>
      dip->type = type;
80101653:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101657:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010165a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010165d:	89 3c 24             	mov    %edi,(%esp)
80101660:	e8 db 1b 00 00       	call   80103240 <log_write>
      brelse(bp);
80101665:	89 3c 24             	mov    %edi,(%esp)
80101668:	e8 73 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010166d:	83 c4 10             	add    $0x10,%esp
}
80101670:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101673:	89 da                	mov    %ebx,%edx
80101675:	89 f0                	mov    %esi,%eax
}
80101677:	5b                   	pop    %ebx
80101678:	5e                   	pop    %esi
80101679:	5f                   	pop    %edi
8010167a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010167b:	e9 50 fc ff ff       	jmp    801012d0 <iget>
  panic("ialloc: no inodes");
80101680:	83 ec 0c             	sub    $0xc,%esp
80101683:	68 58 85 10 80       	push   $0x80108558
80101688:	e8 03 ed ff ff       	call   80100390 <panic>
8010168d:	8d 76 00             	lea    0x0(%esi),%esi

80101690 <iupdate>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101698:	83 ec 08             	sub    $0x8,%esp
8010169b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010169e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016a1:	c1 e8 03             	shr    $0x3,%eax
801016a4:	03 05 f4 29 11 80    	add    0x801129f4,%eax
801016aa:	50                   	push   %eax
801016ab:	ff 73 a4             	pushl  -0x5c(%ebx)
801016ae:	e8 1d ea ff ff       	call   801000d0 <bread>
801016b3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801016b8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016bf:	83 e0 07             	and    $0x7,%eax
801016c2:	c1 e0 06             	shl    $0x6,%eax
801016c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016c9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016cc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016d0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016d3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016d7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016db:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016df:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016e3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016e7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ed:	6a 34                	push   $0x34
801016ef:	53                   	push   %ebx
801016f0:	50                   	push   %eax
801016f1:	e8 ba 3b 00 00       	call   801052b0 <memmove>
  log_write(bp);
801016f6:	89 34 24             	mov    %esi,(%esp)
801016f9:	e8 42 1b 00 00       	call   80103240 <log_write>
  brelse(bp);
801016fe:	89 75 08             	mov    %esi,0x8(%ebp)
80101701:	83 c4 10             	add    $0x10,%esp
}
80101704:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101707:	5b                   	pop    %ebx
80101708:	5e                   	pop    %esi
80101709:	5d                   	pop    %ebp
  brelse(bp);
8010170a:	e9 d1 ea ff ff       	jmp    801001e0 <brelse>
8010170f:	90                   	nop

80101710 <idup>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	53                   	push   %ebx
80101714:	83 ec 10             	sub    $0x10,%esp
80101717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010171a:	68 00 2a 11 80       	push   $0x80112a00
8010171f:	e8 5c 39 00 00       	call   80105080 <acquire>
  ip->ref++;
80101724:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101728:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
8010172f:	e8 6c 3a 00 00       	call   801051a0 <release>
}
80101734:	89 d8                	mov    %ebx,%eax
80101736:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101739:	c9                   	leave  
8010173a:	c3                   	ret    
8010173b:	90                   	nop
8010173c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101740 <ilock>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101748:	85 db                	test   %ebx,%ebx
8010174a:	0f 84 b7 00 00 00    	je     80101807 <ilock+0xc7>
80101750:	8b 53 08             	mov    0x8(%ebx),%edx
80101753:	85 d2                	test   %edx,%edx
80101755:	0f 8e ac 00 00 00    	jle    80101807 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010175b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010175e:	83 ec 0c             	sub    $0xc,%esp
80101761:	50                   	push   %eax
80101762:	e8 59 37 00 00       	call   80104ec0 <acquiresleep>
  if(ip->valid == 0){
80101767:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010176a:	83 c4 10             	add    $0x10,%esp
8010176d:	85 c0                	test   %eax,%eax
8010176f:	74 0f                	je     80101780 <ilock+0x40>
}
80101771:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101774:	5b                   	pop    %ebx
80101775:	5e                   	pop    %esi
80101776:	5d                   	pop    %ebp
80101777:	c3                   	ret    
80101778:	90                   	nop
80101779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101780:	8b 43 04             	mov    0x4(%ebx),%eax
80101783:	83 ec 08             	sub    $0x8,%esp
80101786:	c1 e8 03             	shr    $0x3,%eax
80101789:	03 05 f4 29 11 80    	add    0x801129f4,%eax
8010178f:	50                   	push   %eax
80101790:	ff 33                	pushl  (%ebx)
80101792:	e8 39 e9 ff ff       	call   801000d0 <bread>
80101797:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101799:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010179c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010179f:	83 e0 07             	and    $0x7,%eax
801017a2:	c1 e0 06             	shl    $0x6,%eax
801017a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017a9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017af:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017b3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017b7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017bb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017bf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017c3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017c7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017cb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ce:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d1:	6a 34                	push   $0x34
801017d3:	50                   	push   %eax
801017d4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017d7:	50                   	push   %eax
801017d8:	e8 d3 3a 00 00       	call   801052b0 <memmove>
    brelse(bp);
801017dd:	89 34 24             	mov    %esi,(%esp)
801017e0:	e8 fb e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801017e5:	83 c4 10             	add    $0x10,%esp
801017e8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017ed:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017f4:	0f 85 77 ff ff ff    	jne    80101771 <ilock+0x31>
      panic("ilock: no type");
801017fa:	83 ec 0c             	sub    $0xc,%esp
801017fd:	68 70 85 10 80       	push   $0x80108570
80101802:	e8 89 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101807:	83 ec 0c             	sub    $0xc,%esp
8010180a:	68 6a 85 10 80       	push   $0x8010856a
8010180f:	e8 7c eb ff ff       	call   80100390 <panic>
80101814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010181a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101820 <iunlock>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	56                   	push   %esi
80101824:	53                   	push   %ebx
80101825:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101828:	85 db                	test   %ebx,%ebx
8010182a:	74 28                	je     80101854 <iunlock+0x34>
8010182c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010182f:	83 ec 0c             	sub    $0xc,%esp
80101832:	56                   	push   %esi
80101833:	e8 28 37 00 00       	call   80104f60 <holdingsleep>
80101838:	83 c4 10             	add    $0x10,%esp
8010183b:	85 c0                	test   %eax,%eax
8010183d:	74 15                	je     80101854 <iunlock+0x34>
8010183f:	8b 43 08             	mov    0x8(%ebx),%eax
80101842:	85 c0                	test   %eax,%eax
80101844:	7e 0e                	jle    80101854 <iunlock+0x34>
  releasesleep(&ip->lock);
80101846:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101849:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010184c:	5b                   	pop    %ebx
8010184d:	5e                   	pop    %esi
8010184e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010184f:	e9 cc 36 00 00       	jmp    80104f20 <releasesleep>
    panic("iunlock");
80101854:	83 ec 0c             	sub    $0xc,%esp
80101857:	68 7f 85 10 80       	push   $0x8010857f
8010185c:	e8 2f eb ff ff       	call   80100390 <panic>
80101861:	eb 0d                	jmp    80101870 <iput>
80101863:	90                   	nop
80101864:	90                   	nop
80101865:	90                   	nop
80101866:	90                   	nop
80101867:	90                   	nop
80101868:	90                   	nop
80101869:	90                   	nop
8010186a:	90                   	nop
8010186b:	90                   	nop
8010186c:	90                   	nop
8010186d:	90                   	nop
8010186e:	90                   	nop
8010186f:	90                   	nop

80101870 <iput>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	57                   	push   %edi
80101874:	56                   	push   %esi
80101875:	53                   	push   %ebx
80101876:	83 ec 28             	sub    $0x28,%esp
80101879:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010187c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010187f:	57                   	push   %edi
80101880:	e8 3b 36 00 00       	call   80104ec0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101885:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 d2                	test   %edx,%edx
8010188d:	74 07                	je     80101896 <iput+0x26>
8010188f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101894:	74 32                	je     801018c8 <iput+0x58>
  releasesleep(&ip->lock);
80101896:	83 ec 0c             	sub    $0xc,%esp
80101899:	57                   	push   %edi
8010189a:	e8 81 36 00 00       	call   80104f20 <releasesleep>
  acquire(&icache.lock);
8010189f:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
801018a6:	e8 d5 37 00 00       	call   80105080 <acquire>
  ip->ref--;
801018ab:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018af:	83 c4 10             	add    $0x10,%esp
801018b2:	c7 45 08 00 2a 11 80 	movl   $0x80112a00,0x8(%ebp)
}
801018b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018bc:	5b                   	pop    %ebx
801018bd:	5e                   	pop    %esi
801018be:	5f                   	pop    %edi
801018bf:	5d                   	pop    %ebp
  release(&icache.lock);
801018c0:	e9 db 38 00 00       	jmp    801051a0 <release>
801018c5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018c8:	83 ec 0c             	sub    $0xc,%esp
801018cb:	68 00 2a 11 80       	push   $0x80112a00
801018d0:	e8 ab 37 00 00       	call   80105080 <acquire>
    int r = ip->ref;
801018d5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018d8:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
801018df:	e8 bc 38 00 00       	call   801051a0 <release>
    if(r == 1){
801018e4:	83 c4 10             	add    $0x10,%esp
801018e7:	83 fe 01             	cmp    $0x1,%esi
801018ea:	75 aa                	jne    80101896 <iput+0x26>
801018ec:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018f2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018f5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018f8:	89 cf                	mov    %ecx,%edi
801018fa:	eb 0b                	jmp    80101907 <iput+0x97>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101900:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101903:	39 fe                	cmp    %edi,%esi
80101905:	74 19                	je     80101920 <iput+0xb0>
    if(ip->addrs[i]){
80101907:	8b 16                	mov    (%esi),%edx
80101909:	85 d2                	test   %edx,%edx
8010190b:	74 f3                	je     80101900 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010190d:	8b 03                	mov    (%ebx),%eax
8010190f:	e8 ac fb ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
80101914:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010191a:	eb e4                	jmp    80101900 <iput+0x90>
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101920:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101926:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101929:	85 c0                	test   %eax,%eax
8010192b:	75 33                	jne    80101960 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010192d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101930:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101937:	53                   	push   %ebx
80101938:	e8 53 fd ff ff       	call   80101690 <iupdate>
      ip->type = 0;
8010193d:	31 c0                	xor    %eax,%eax
8010193f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101943:	89 1c 24             	mov    %ebx,(%esp)
80101946:	e8 45 fd ff ff       	call   80101690 <iupdate>
      ip->valid = 0;
8010194b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101952:	83 c4 10             	add    $0x10,%esp
80101955:	e9 3c ff ff ff       	jmp    80101896 <iput+0x26>
8010195a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101960:	83 ec 08             	sub    $0x8,%esp
80101963:	50                   	push   %eax
80101964:	ff 33                	pushl  (%ebx)
80101966:	e8 65 e7 ff ff       	call   801000d0 <bread>
8010196b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101971:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101974:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101977:	8d 70 5c             	lea    0x5c(%eax),%esi
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	89 cf                	mov    %ecx,%edi
8010197f:	eb 0e                	jmp    8010198f <iput+0x11f>
80101981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101988:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010198b:	39 fe                	cmp    %edi,%esi
8010198d:	74 0f                	je     8010199e <iput+0x12e>
      if(a[j])
8010198f:	8b 16                	mov    (%esi),%edx
80101991:	85 d2                	test   %edx,%edx
80101993:	74 f3                	je     80101988 <iput+0x118>
        bfree(ip->dev, a[j]);
80101995:	8b 03                	mov    (%ebx),%eax
80101997:	e8 24 fb ff ff       	call   801014c0 <bfree>
8010199c:	eb ea                	jmp    80101988 <iput+0x118>
    brelse(bp);
8010199e:	83 ec 0c             	sub    $0xc,%esp
801019a1:	ff 75 e4             	pushl  -0x1c(%ebp)
801019a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019a7:	e8 34 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ac:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019b2:	8b 03                	mov    (%ebx),%eax
801019b4:	e8 07 fb ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019b9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019c0:	00 00 00 
801019c3:	83 c4 10             	add    $0x10,%esp
801019c6:	e9 62 ff ff ff       	jmp    8010192d <iput+0xbd>
801019cb:	90                   	nop
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019d0 <iunlockput>:
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	53                   	push   %ebx
801019d4:	83 ec 10             	sub    $0x10,%esp
801019d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019da:	53                   	push   %ebx
801019db:	e8 40 fe ff ff       	call   80101820 <iunlock>
  iput(ip);
801019e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019e3:	83 c4 10             	add    $0x10,%esp
}
801019e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019e9:	c9                   	leave  
  iput(ip);
801019ea:	e9 81 fe ff ff       	jmp    80101870 <iput>
801019ef:	90                   	nop

801019f0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	8b 55 08             	mov    0x8(%ebp),%edx
801019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019f9:	8b 0a                	mov    (%edx),%ecx
801019fb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019fe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a01:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a04:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a08:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a0b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a0f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a13:	8b 52 58             	mov    0x58(%edx),%edx
80101a16:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a19:	5d                   	pop    %ebp
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	53                   	push   %ebx
80101a26:	83 ec 1c             	sub    $0x1c,%esp
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a37:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a40:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a43:	0f 84 a7 00 00 00    	je     80101af0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a4c:	8b 40 58             	mov    0x58(%eax),%eax
80101a4f:	39 c6                	cmp    %eax,%esi
80101a51:	0f 87 ba 00 00 00    	ja     80101b11 <readi+0xf1>
80101a57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a5a:	89 f9                	mov    %edi,%ecx
80101a5c:	01 f1                	add    %esi,%ecx
80101a5e:	0f 82 ad 00 00 00    	jb     80101b11 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a64:	89 c2                	mov    %eax,%edx
80101a66:	29 f2                	sub    %esi,%edx
80101a68:	39 c8                	cmp    %ecx,%eax
80101a6a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a6d:	31 ff                	xor    %edi,%edi
80101a6f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a74:	74 6c                	je     80101ae2 <readi+0xc2>
80101a76:	8d 76 00             	lea    0x0(%esi),%esi
80101a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a83:	89 f2                	mov    %esi,%edx
80101a85:	c1 ea 09             	shr    $0x9,%edx
80101a88:	89 d8                	mov    %ebx,%eax
80101a8a:	e8 11 f9 ff ff       	call   801013a0 <bmap>
80101a8f:	83 ec 08             	sub    $0x8,%esp
80101a92:	50                   	push   %eax
80101a93:	ff 33                	pushl  (%ebx)
80101a95:	e8 36 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a9d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9f:	89 f0                	mov    %esi,%eax
80101aa1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aa6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101aab:	83 c4 0c             	add    $0xc,%esp
80101aae:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ab0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101ab4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab7:	29 fb                	sub    %edi,%ebx
80101ab9:	39 d9                	cmp    %ebx,%ecx
80101abb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101abe:	53                   	push   %ebx
80101abf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ac0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ac2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ac5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ac7:	e8 e4 37 00 00       	call   801052b0 <memmove>
    brelse(bp);
80101acc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101acf:	89 14 24             	mov    %edx,(%esp)
80101ad2:	e8 09 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ad7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101ada:	83 c4 10             	add    $0x10,%esp
80101add:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ae0:	77 9e                	ja     80101a80 <readi+0x60>
  }
  return n;
80101ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ae5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae8:	5b                   	pop    %ebx
80101ae9:	5e                   	pop    %esi
80101aea:	5f                   	pop    %edi
80101aeb:	5d                   	pop    %ebp
80101aec:	c3                   	ret    
80101aed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101af0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101af4:	66 83 f8 09          	cmp    $0x9,%ax
80101af8:	77 17                	ja     80101b11 <readi+0xf1>
80101afa:	8b 04 c5 80 29 11 80 	mov    -0x7feed680(,%eax,8),%eax
80101b01:	85 c0                	test   %eax,%eax
80101b03:	74 0c                	je     80101b11 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b0b:	5b                   	pop    %ebx
80101b0c:	5e                   	pop    %esi
80101b0d:	5f                   	pop    %edi
80101b0e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b0f:	ff e0                	jmp    *%eax
      return -1;
80101b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b16:	eb cd                	jmp    80101ae5 <readi+0xc5>
80101b18:	90                   	nop
80101b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 1c             	sub    $0x1c,%esp
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b43:	0f 84 b7 00 00 00    	je     80101c00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b4f:	0f 82 eb 00 00 00    	jb     80101c40 <writei+0x120>
80101b55:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b58:	31 d2                	xor    %edx,%edx
80101b5a:	89 f8                	mov    %edi,%eax
80101b5c:	01 f0                	add    %esi,%eax
80101b5e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b61:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b66:	0f 87 d4 00 00 00    	ja     80101c40 <writei+0x120>
80101b6c:	85 d2                	test   %edx,%edx
80101b6e:	0f 85 cc 00 00 00    	jne    80101c40 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b74:	85 ff                	test   %edi,%edi
80101b76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b7d:	74 72                	je     80101bf1 <writei+0xd1>
80101b7f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b83:	89 f2                	mov    %esi,%edx
80101b85:	c1 ea 09             	shr    $0x9,%edx
80101b88:	89 f8                	mov    %edi,%eax
80101b8a:	e8 11 f8 ff ff       	call   801013a0 <bmap>
80101b8f:	83 ec 08             	sub    $0x8,%esp
80101b92:	50                   	push   %eax
80101b93:	ff 37                	pushl  (%edi)
80101b95:	e8 36 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b9a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b9d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba2:	89 f0                	mov    %esi,%eax
80101ba4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ba9:	83 c4 0c             	add    $0xc,%esp
80101bac:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bb1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bb3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bb7:	39 d9                	cmp    %ebx,%ecx
80101bb9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bbc:	53                   	push   %ebx
80101bbd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bc2:	50                   	push   %eax
80101bc3:	e8 e8 36 00 00       	call   801052b0 <memmove>
    log_write(bp);
80101bc8:	89 3c 24             	mov    %edi,(%esp)
80101bcb:	e8 70 16 00 00       	call   80103240 <log_write>
    brelse(bp);
80101bd0:	89 3c 24             	mov    %edi,(%esp)
80101bd3:	e8 08 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bd8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bdb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bde:	83 c4 10             	add    $0x10,%esp
80101be1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101be4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101be7:	77 97                	ja     80101b80 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101be9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bec:	3b 70 58             	cmp    0x58(%eax),%esi
80101bef:	77 37                	ja     80101c28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bf7:	5b                   	pop    %ebx
80101bf8:	5e                   	pop    %esi
80101bf9:	5f                   	pop    %edi
80101bfa:	5d                   	pop    %ebp
80101bfb:	c3                   	ret    
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c04:	66 83 f8 09          	cmp    $0x9,%ax
80101c08:	77 36                	ja     80101c40 <writei+0x120>
80101c0a:	8b 04 c5 84 29 11 80 	mov    -0x7feed67c(,%eax,8),%eax
80101c11:	85 c0                	test   %eax,%eax
80101c13:	74 2b                	je     80101c40 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101c15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c1f:	ff e0                	jmp    *%eax
80101c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c2b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c2e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c31:	50                   	push   %eax
80101c32:	e8 59 fa ff ff       	call   80101690 <iupdate>
80101c37:	83 c4 10             	add    $0x10,%esp
80101c3a:	eb b5                	jmp    80101bf1 <writei+0xd1>
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c45:	eb ad                	jmp    80101bf4 <writei+0xd4>
80101c47:	89 f6                	mov    %esi,%esi
80101c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c56:	6a 0e                	push   $0xe
80101c58:	ff 75 0c             	pushl  0xc(%ebp)
80101c5b:	ff 75 08             	pushl  0x8(%ebp)
80101c5e:	e8 bd 36 00 00       	call   80105320 <strncmp>
}
80101c63:	c9                   	leave  
80101c64:	c3                   	ret    
80101c65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	83 ec 1c             	sub    $0x1c,%esp
80101c79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c81:	0f 85 85 00 00 00    	jne    80101d0c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c87:	8b 53 58             	mov    0x58(%ebx),%edx
80101c8a:	31 ff                	xor    %edi,%edi
80101c8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c8f:	85 d2                	test   %edx,%edx
80101c91:	74 3e                	je     80101cd1 <dirlookup+0x61>
80101c93:	90                   	nop
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c98:	6a 10                	push   $0x10
80101c9a:	57                   	push   %edi
80101c9b:	56                   	push   %esi
80101c9c:	53                   	push   %ebx
80101c9d:	e8 7e fd ff ff       	call   80101a20 <readi>
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	83 f8 10             	cmp    $0x10,%eax
80101ca8:	75 55                	jne    80101cff <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101caa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101caf:	74 18                	je     80101cc9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101cb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cb4:	83 ec 04             	sub    $0x4,%esp
80101cb7:	6a 0e                	push   $0xe
80101cb9:	50                   	push   %eax
80101cba:	ff 75 0c             	pushl  0xc(%ebp)
80101cbd:	e8 5e 36 00 00       	call   80105320 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101cc2:	83 c4 10             	add    $0x10,%esp
80101cc5:	85 c0                	test   %eax,%eax
80101cc7:	74 17                	je     80101ce0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101cc9:	83 c7 10             	add    $0x10,%edi
80101ccc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ccf:	72 c7                	jb     80101c98 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cd4:	31 c0                	xor    %eax,%eax
}
80101cd6:	5b                   	pop    %ebx
80101cd7:	5e                   	pop    %esi
80101cd8:	5f                   	pop    %edi
80101cd9:	5d                   	pop    %ebp
80101cda:	c3                   	ret    
80101cdb:	90                   	nop
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101ce0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ce3:	85 c0                	test   %eax,%eax
80101ce5:	74 05                	je     80101cec <dirlookup+0x7c>
        *poff = off;
80101ce7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cea:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cec:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cf0:	8b 03                	mov    (%ebx),%eax
80101cf2:	e8 d9 f5 ff ff       	call   801012d0 <iget>
}
80101cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cfa:	5b                   	pop    %ebx
80101cfb:	5e                   	pop    %esi
80101cfc:	5f                   	pop    %edi
80101cfd:	5d                   	pop    %ebp
80101cfe:	c3                   	ret    
      panic("dirlookup read");
80101cff:	83 ec 0c             	sub    $0xc,%esp
80101d02:	68 99 85 10 80       	push   $0x80108599
80101d07:	e8 84 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d0c:	83 ec 0c             	sub    $0xc,%esp
80101d0f:	68 87 85 10 80       	push   $0x80108587
80101d14:	e8 77 e6 ff ff       	call   80100390 <panic>
80101d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	57                   	push   %edi
80101d24:	56                   	push   %esi
80101d25:	53                   	push   %ebx
80101d26:	89 cf                	mov    %ecx,%edi
80101d28:	89 c3                	mov    %eax,%ebx
80101d2a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d2d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d33:	0f 84 67 01 00 00    	je     80101ea0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d39:	e8 62 20 00 00       	call   80103da0 <myproc>
  acquire(&icache.lock);
80101d3e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d41:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d44:	68 00 2a 11 80       	push   $0x80112a00
80101d49:	e8 32 33 00 00       	call   80105080 <acquire>
  ip->ref++;
80101d4e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d52:	c7 04 24 00 2a 11 80 	movl   $0x80112a00,(%esp)
80101d59:	e8 42 34 00 00       	call   801051a0 <release>
80101d5e:	83 c4 10             	add    $0x10,%esp
80101d61:	eb 08                	jmp    80101d6b <namex+0x4b>
80101d63:	90                   	nop
80101d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d6b:	0f b6 03             	movzbl (%ebx),%eax
80101d6e:	3c 2f                	cmp    $0x2f,%al
80101d70:	74 f6                	je     80101d68 <namex+0x48>
  if(*path == 0)
80101d72:	84 c0                	test   %al,%al
80101d74:	0f 84 ee 00 00 00    	je     80101e68 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d7a:	0f b6 03             	movzbl (%ebx),%eax
80101d7d:	3c 2f                	cmp    $0x2f,%al
80101d7f:	0f 84 b3 00 00 00    	je     80101e38 <namex+0x118>
80101d85:	84 c0                	test   %al,%al
80101d87:	89 da                	mov    %ebx,%edx
80101d89:	75 09                	jne    80101d94 <namex+0x74>
80101d8b:	e9 a8 00 00 00       	jmp    80101e38 <namex+0x118>
80101d90:	84 c0                	test   %al,%al
80101d92:	74 0a                	je     80101d9e <namex+0x7e>
    path++;
80101d94:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d97:	0f b6 02             	movzbl (%edx),%eax
80101d9a:	3c 2f                	cmp    $0x2f,%al
80101d9c:	75 f2                	jne    80101d90 <namex+0x70>
80101d9e:	89 d1                	mov    %edx,%ecx
80101da0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101da2:	83 f9 0d             	cmp    $0xd,%ecx
80101da5:	0f 8e 91 00 00 00    	jle    80101e3c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101dab:	83 ec 04             	sub    $0x4,%esp
80101dae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101db1:	6a 0e                	push   $0xe
80101db3:	53                   	push   %ebx
80101db4:	57                   	push   %edi
80101db5:	e8 f6 34 00 00       	call   801052b0 <memmove>
    path++;
80101dba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101dbd:	83 c4 10             	add    $0x10,%esp
    path++;
80101dc0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101dc2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101dc5:	75 11                	jne    80101dd8 <namex+0xb8>
80101dc7:	89 f6                	mov    %esi,%esi
80101dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101dd0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101dd3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101dd6:	74 f8                	je     80101dd0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	56                   	push   %esi
80101ddc:	e8 5f f9 ff ff       	call   80101740 <ilock>
    if(ip->type != T_DIR){
80101de1:	83 c4 10             	add    $0x10,%esp
80101de4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101de9:	0f 85 91 00 00 00    	jne    80101e80 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101def:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101df2:	85 d2                	test   %edx,%edx
80101df4:	74 09                	je     80101dff <namex+0xdf>
80101df6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101df9:	0f 84 b7 00 00 00    	je     80101eb6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dff:	83 ec 04             	sub    $0x4,%esp
80101e02:	6a 00                	push   $0x0
80101e04:	57                   	push   %edi
80101e05:	56                   	push   %esi
80101e06:	e8 65 fe ff ff       	call   80101c70 <dirlookup>
80101e0b:	83 c4 10             	add    $0x10,%esp
80101e0e:	85 c0                	test   %eax,%eax
80101e10:	74 6e                	je     80101e80 <namex+0x160>
  iunlock(ip);
80101e12:	83 ec 0c             	sub    $0xc,%esp
80101e15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e18:	56                   	push   %esi
80101e19:	e8 02 fa ff ff       	call   80101820 <iunlock>
  iput(ip);
80101e1e:	89 34 24             	mov    %esi,(%esp)
80101e21:	e8 4a fa ff ff       	call   80101870 <iput>
80101e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e29:	83 c4 10             	add    $0x10,%esp
80101e2c:	89 c6                	mov    %eax,%esi
80101e2e:	e9 38 ff ff ff       	jmp    80101d6b <namex+0x4b>
80101e33:	90                   	nop
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101e38:	89 da                	mov    %ebx,%edx
80101e3a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e3c:	83 ec 04             	sub    $0x4,%esp
80101e3f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e42:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e45:	51                   	push   %ecx
80101e46:	53                   	push   %ebx
80101e47:	57                   	push   %edi
80101e48:	e8 63 34 00 00       	call   801052b0 <memmove>
    name[len] = 0;
80101e4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e50:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e53:	83 c4 10             	add    $0x10,%esp
80101e56:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e5a:	89 d3                	mov    %edx,%ebx
80101e5c:	e9 61 ff ff ff       	jmp    80101dc2 <namex+0xa2>
80101e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e6b:	85 c0                	test   %eax,%eax
80101e6d:	75 5d                	jne    80101ecc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e72:	89 f0                	mov    %esi,%eax
80101e74:	5b                   	pop    %ebx
80101e75:	5e                   	pop    %esi
80101e76:	5f                   	pop    %edi
80101e77:	5d                   	pop    %ebp
80101e78:	c3                   	ret    
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e80:	83 ec 0c             	sub    $0xc,%esp
80101e83:	56                   	push   %esi
80101e84:	e8 97 f9 ff ff       	call   80101820 <iunlock>
  iput(ip);
80101e89:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e8c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e8e:	e8 dd f9 ff ff       	call   80101870 <iput>
      return 0;
80101e93:	83 c4 10             	add    $0x10,%esp
}
80101e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e99:	89 f0                	mov    %esi,%eax
80101e9b:	5b                   	pop    %ebx
80101e9c:	5e                   	pop    %esi
80101e9d:	5f                   	pop    %edi
80101e9e:	5d                   	pop    %ebp
80101e9f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101ea0:	ba 01 00 00 00       	mov    $0x1,%edx
80101ea5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eaa:	e8 21 f4 ff ff       	call   801012d0 <iget>
80101eaf:	89 c6                	mov    %eax,%esi
80101eb1:	e9 b5 fe ff ff       	jmp    80101d6b <namex+0x4b>
      iunlock(ip);
80101eb6:	83 ec 0c             	sub    $0xc,%esp
80101eb9:	56                   	push   %esi
80101eba:	e8 61 f9 ff ff       	call   80101820 <iunlock>
      return ip;
80101ebf:	83 c4 10             	add    $0x10,%esp
}
80101ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ec5:	89 f0                	mov    %esi,%eax
80101ec7:	5b                   	pop    %ebx
80101ec8:	5e                   	pop    %esi
80101ec9:	5f                   	pop    %edi
80101eca:	5d                   	pop    %ebp
80101ecb:	c3                   	ret    
    iput(ip);
80101ecc:	83 ec 0c             	sub    $0xc,%esp
80101ecf:	56                   	push   %esi
    return 0;
80101ed0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ed2:	e8 99 f9 ff ff       	call   80101870 <iput>
    return 0;
80101ed7:	83 c4 10             	add    $0x10,%esp
80101eda:	eb 93                	jmp    80101e6f <namex+0x14f>
80101edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ee0 <dirlink>:
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	57                   	push   %edi
80101ee4:	56                   	push   %esi
80101ee5:	53                   	push   %ebx
80101ee6:	83 ec 20             	sub    $0x20,%esp
80101ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101eec:	6a 00                	push   $0x0
80101eee:	ff 75 0c             	pushl  0xc(%ebp)
80101ef1:	53                   	push   %ebx
80101ef2:	e8 79 fd ff ff       	call   80101c70 <dirlookup>
80101ef7:	83 c4 10             	add    $0x10,%esp
80101efa:	85 c0                	test   %eax,%eax
80101efc:	75 67                	jne    80101f65 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101efe:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f01:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f04:	85 ff                	test   %edi,%edi
80101f06:	74 29                	je     80101f31 <dirlink+0x51>
80101f08:	31 ff                	xor    %edi,%edi
80101f0a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f0d:	eb 09                	jmp    80101f18 <dirlink+0x38>
80101f0f:	90                   	nop
80101f10:	83 c7 10             	add    $0x10,%edi
80101f13:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f16:	73 19                	jae    80101f31 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f18:	6a 10                	push   $0x10
80101f1a:	57                   	push   %edi
80101f1b:	56                   	push   %esi
80101f1c:	53                   	push   %ebx
80101f1d:	e8 fe fa ff ff       	call   80101a20 <readi>
80101f22:	83 c4 10             	add    $0x10,%esp
80101f25:	83 f8 10             	cmp    $0x10,%eax
80101f28:	75 4e                	jne    80101f78 <dirlink+0x98>
    if(de.inum == 0)
80101f2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f2f:	75 df                	jne    80101f10 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f34:	83 ec 04             	sub    $0x4,%esp
80101f37:	6a 0e                	push   $0xe
80101f39:	ff 75 0c             	pushl  0xc(%ebp)
80101f3c:	50                   	push   %eax
80101f3d:	e8 3e 34 00 00       	call   80105380 <strncpy>
  de.inum = inum;
80101f42:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f45:	6a 10                	push   $0x10
80101f47:	57                   	push   %edi
80101f48:	56                   	push   %esi
80101f49:	53                   	push   %ebx
  de.inum = inum;
80101f4a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f4e:	e8 cd fb ff ff       	call   80101b20 <writei>
80101f53:	83 c4 20             	add    $0x20,%esp
80101f56:	83 f8 10             	cmp    $0x10,%eax
80101f59:	75 2a                	jne    80101f85 <dirlink+0xa5>
  return 0;
80101f5b:	31 c0                	xor    %eax,%eax
}
80101f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f60:	5b                   	pop    %ebx
80101f61:	5e                   	pop    %esi
80101f62:	5f                   	pop    %edi
80101f63:	5d                   	pop    %ebp
80101f64:	c3                   	ret    
    iput(ip);
80101f65:	83 ec 0c             	sub    $0xc,%esp
80101f68:	50                   	push   %eax
80101f69:	e8 02 f9 ff ff       	call   80101870 <iput>
    return -1;
80101f6e:	83 c4 10             	add    $0x10,%esp
80101f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f76:	eb e5                	jmp    80101f5d <dirlink+0x7d>
      panic("dirlink read");
80101f78:	83 ec 0c             	sub    $0xc,%esp
80101f7b:	68 a8 85 10 80       	push   $0x801085a8
80101f80:	e8 0b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	68 4d 8d 10 80       	push   $0x80108d4d
80101f8d:	e8 fe e3 ff ff       	call   80100390 <panic>
80101f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <namei>:

struct inode*
namei(char *path)
{
80101fa0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fa1:	31 d2                	xor    %edx,%edx
{
80101fa3:	89 e5                	mov    %esp,%ebp
80101fa5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fae:	e8 6d fd ff ff       	call   80101d20 <namex>
}
80101fb3:	c9                   	leave  
80101fb4:	c3                   	ret    
80101fb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fc0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fc1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fc6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fce:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fcf:	e9 4c fd ff ff       	jmp    80101d20 <namex>
80101fd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101fe0 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101fe0:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101fe1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101fe6:	89 e5                	mov    %esp,%ebp
80101fe8:	57                   	push   %edi
80101fe9:	56                   	push   %esi
80101fea:	53                   	push   %ebx
80101feb:	83 ec 10             	sub    $0x10,%esp
80101fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101ff1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101ff8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101fff:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80102003:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80102007:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
8010200a:	85 c9                	test   %ecx,%ecx
8010200c:	79 0a                	jns    80102018 <itoa+0x38>
8010200e:	89 f0                	mov    %esi,%eax
80102010:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80102013:	f7 d9                	neg    %ecx
        *p++ = '-';
80102015:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80102018:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010201a:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010201f:	90                   	nop
80102020:	89 d8                	mov    %ebx,%eax
80102022:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102025:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102028:	f7 ef                	imul   %edi
8010202a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010202d:	29 da                	sub    %ebx,%edx
8010202f:	89 d3                	mov    %edx,%ebx
80102031:	75 ed                	jne    80102020 <itoa+0x40>
    *p = '\0';
80102033:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102036:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010203b:	90                   	nop
8010203c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102040:	89 c8                	mov    %ecx,%eax
80102042:	83 ee 01             	sub    $0x1,%esi
80102045:	f7 eb                	imul   %ebx
80102047:	89 c8                	mov    %ecx,%eax
80102049:	c1 f8 1f             	sar    $0x1f,%eax
8010204c:	c1 fa 02             	sar    $0x2,%edx
8010204f:	29 c2                	sub    %eax,%edx
80102051:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102054:	01 c0                	add    %eax,%eax
80102056:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102058:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010205a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010205f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102061:	88 06                	mov    %al,(%esi)
    }while(i);
80102063:	75 db                	jne    80102040 <itoa+0x60>
    return b;
}
80102065:	8b 45 0c             	mov    0xc(%ebp),%eax
80102068:	83 c4 10             	add    $0x10,%esp
8010206b:	5b                   	pop    %ebx
8010206c:	5e                   	pop    %esi
8010206d:	5f                   	pop    %edi
8010206e:	5d                   	pop    %ebp
8010206f:	c3                   	ret    

80102070 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102076:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102079:	83 ec 40             	sub    $0x40,%esp
8010207c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010207f:	6a 06                	push   $0x6
80102081:	68 b5 85 10 80       	push   $0x801085b5
80102086:	56                   	push   %esi
80102087:	e8 24 32 00 00       	call   801052b0 <memmove>
  itoa(p->pid, path+ 6);
8010208c:	58                   	pop    %eax
8010208d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102090:	5a                   	pop    %edx
80102091:	50                   	push   %eax
80102092:	ff 73 10             	pushl  0x10(%ebx)
80102095:	e8 46 ff ff ff       	call   80101fe0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010209a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010209d:	83 c4 10             	add    $0x10,%esp
801020a0:	85 c0                	test   %eax,%eax
801020a2:	0f 84 88 01 00 00    	je     80102230 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
801020a8:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
801020ab:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
801020ae:	50                   	push   %eax
801020af:	e8 3c ee ff ff       	call   80100ef0 <fileclose>

  begin_op();
801020b4:	e8 b7 0f 00 00       	call   80103070 <begin_op>
  return namex(path, 1, name);
801020b9:	89 f0                	mov    %esi,%eax
801020bb:	89 d9                	mov    %ebx,%ecx
801020bd:	ba 01 00 00 00       	mov    $0x1,%edx
801020c2:	e8 59 fc ff ff       	call   80101d20 <namex>
  if((dp = nameiparent(path, name)) == 0)
801020c7:	83 c4 10             	add    $0x10,%esp
801020ca:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801020cc:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801020ce:	0f 84 66 01 00 00    	je     8010223a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801020d4:	83 ec 0c             	sub    $0xc,%esp
801020d7:	50                   	push   %eax
801020d8:	e8 63 f6 ff ff       	call   80101740 <ilock>
  return strncmp(s, t, DIRSIZ);
801020dd:	83 c4 0c             	add    $0xc,%esp
801020e0:	6a 0e                	push   $0xe
801020e2:	68 bd 85 10 80       	push   $0x801085bd
801020e7:	53                   	push   %ebx
801020e8:	e8 33 32 00 00       	call   80105320 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020ed:	83 c4 10             	add    $0x10,%esp
801020f0:	85 c0                	test   %eax,%eax
801020f2:	0f 84 f8 00 00 00    	je     801021f0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801020f8:	83 ec 04             	sub    $0x4,%esp
801020fb:	6a 0e                	push   $0xe
801020fd:	68 bc 85 10 80       	push   $0x801085bc
80102102:	53                   	push   %ebx
80102103:	e8 18 32 00 00       	call   80105320 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102108:	83 c4 10             	add    $0x10,%esp
8010210b:	85 c0                	test   %eax,%eax
8010210d:	0f 84 dd 00 00 00    	je     801021f0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102113:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102116:	83 ec 04             	sub    $0x4,%esp
80102119:	50                   	push   %eax
8010211a:	53                   	push   %ebx
8010211b:	56                   	push   %esi
8010211c:	e8 4f fb ff ff       	call   80101c70 <dirlookup>
80102121:	83 c4 10             	add    $0x10,%esp
80102124:	85 c0                	test   %eax,%eax
80102126:	89 c3                	mov    %eax,%ebx
80102128:	0f 84 c2 00 00 00    	je     801021f0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010212e:	83 ec 0c             	sub    $0xc,%esp
80102131:	50                   	push   %eax
80102132:	e8 09 f6 ff ff       	call   80101740 <ilock>

  if(ip->nlink < 1)
80102137:	83 c4 10             	add    $0x10,%esp
8010213a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010213f:	0f 8e 11 01 00 00    	jle    80102256 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102145:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010214a:	74 74                	je     801021c0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010214c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010214f:	83 ec 04             	sub    $0x4,%esp
80102152:	6a 10                	push   $0x10
80102154:	6a 00                	push   $0x0
80102156:	57                   	push   %edi
80102157:	e8 a4 30 00 00       	call   80105200 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010215c:	6a 10                	push   $0x10
8010215e:	ff 75 b8             	pushl  -0x48(%ebp)
80102161:	57                   	push   %edi
80102162:	56                   	push   %esi
80102163:	e8 b8 f9 ff ff       	call   80101b20 <writei>
80102168:	83 c4 20             	add    $0x20,%esp
8010216b:	83 f8 10             	cmp    $0x10,%eax
8010216e:	0f 85 d5 00 00 00    	jne    80102249 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102174:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102179:	0f 84 91 00 00 00    	je     80102210 <removeSwapFile+0x1a0>
  iunlock(ip);
8010217f:	83 ec 0c             	sub    $0xc,%esp
80102182:	56                   	push   %esi
80102183:	e8 98 f6 ff ff       	call   80101820 <iunlock>
  iput(ip);
80102188:	89 34 24             	mov    %esi,(%esp)
8010218b:	e8 e0 f6 ff ff       	call   80101870 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102190:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102195:	89 1c 24             	mov    %ebx,(%esp)
80102198:	e8 f3 f4 ff ff       	call   80101690 <iupdate>
  iunlock(ip);
8010219d:	89 1c 24             	mov    %ebx,(%esp)
801021a0:	e8 7b f6 ff ff       	call   80101820 <iunlock>
  iput(ip);
801021a5:	89 1c 24             	mov    %ebx,(%esp)
801021a8:	e8 c3 f6 ff ff       	call   80101870 <iput>
  iunlockput(ip);

  end_op();
801021ad:	e8 2e 0f 00 00       	call   801030e0 <end_op>

  return 0;
801021b2:	83 c4 10             	add    $0x10,%esp
801021b5:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801021b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ba:	5b                   	pop    %ebx
801021bb:	5e                   	pop    %esi
801021bc:	5f                   	pop    %edi
801021bd:	5d                   	pop    %ebp
801021be:	c3                   	ret    
801021bf:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801021c0:	83 ec 0c             	sub    $0xc,%esp
801021c3:	53                   	push   %ebx
801021c4:	e8 17 38 00 00       	call   801059e0 <isdirempty>
801021c9:	83 c4 10             	add    $0x10,%esp
801021cc:	85 c0                	test   %eax,%eax
801021ce:	0f 85 78 ff ff ff    	jne    8010214c <removeSwapFile+0xdc>
  iunlock(ip);
801021d4:	83 ec 0c             	sub    $0xc,%esp
801021d7:	53                   	push   %ebx
801021d8:	e8 43 f6 ff ff       	call   80101820 <iunlock>
  iput(ip);
801021dd:	89 1c 24             	mov    %ebx,(%esp)
801021e0:	e8 8b f6 ff ff       	call   80101870 <iput>
801021e5:	83 c4 10             	add    $0x10,%esp
801021e8:	90                   	nop
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801021f0:	83 ec 0c             	sub    $0xc,%esp
801021f3:	56                   	push   %esi
801021f4:	e8 27 f6 ff ff       	call   80101820 <iunlock>
  iput(ip);
801021f9:	89 34 24             	mov    %esi,(%esp)
801021fc:	e8 6f f6 ff ff       	call   80101870 <iput>
    end_op();
80102201:	e8 da 0e 00 00       	call   801030e0 <end_op>
    return -1;
80102206:	83 c4 10             	add    $0x10,%esp
80102209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010220e:	eb a7                	jmp    801021b7 <removeSwapFile+0x147>
    dp->nlink--;
80102210:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102215:	83 ec 0c             	sub    $0xc,%esp
80102218:	56                   	push   %esi
80102219:	e8 72 f4 ff ff       	call   80101690 <iupdate>
8010221e:	83 c4 10             	add    $0x10,%esp
80102221:	e9 59 ff ff ff       	jmp    8010217f <removeSwapFile+0x10f>
80102226:	8d 76 00             	lea    0x0(%esi),%esi
80102229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102235:	e9 7d ff ff ff       	jmp    801021b7 <removeSwapFile+0x147>
    end_op();
8010223a:	e8 a1 0e 00 00       	call   801030e0 <end_op>
    return -1;
8010223f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102244:	e9 6e ff ff ff       	jmp    801021b7 <removeSwapFile+0x147>
    panic("unlink: writei");
80102249:	83 ec 0c             	sub    $0xc,%esp
8010224c:	68 d1 85 10 80       	push   $0x801085d1
80102251:	e8 3a e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102256:	83 ec 0c             	sub    $0xc,%esp
80102259:	68 bf 85 10 80       	push   $0x801085bf
8010225e:	e8 2d e1 ff ff       	call   80100390 <panic>
80102263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102270 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p) {
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	56                   	push   %esi
80102274:	53                   	push   %ebx

    char path[DIGITS];
    memmove(path, "/.swap", 6);
80102275:	8d 75 ea             	lea    -0x16(%ebp),%esi
createSwapFile(struct proc* p) {
80102278:	83 ec 14             	sub    $0x14,%esp
8010227b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    memmove(path, "/.swap", 6);
8010227e:	6a 06                	push   $0x6
80102280:	68 b5 85 10 80       	push   $0x801085b5
80102285:	56                   	push   %esi
80102286:	e8 25 30 00 00       	call   801052b0 <memmove>
    itoa(p->pid, path + 6);
8010228b:	58                   	pop    %eax
8010228c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010228f:	5a                   	pop    %edx
80102290:	50                   	push   %eax
80102291:	ff 73 10             	pushl  0x10(%ebx)
80102294:	e8 47 fd ff ff       	call   80101fe0 <itoa>

    begin_op();
80102299:	e8 d2 0d 00 00       	call   80103070 <begin_op>
    struct inode *in = create(path, T_FILE, 0, 0);
8010229e:	6a 00                	push   $0x0
801022a0:	6a 00                	push   $0x0
801022a2:	6a 02                	push   $0x2
801022a4:	56                   	push   %esi
801022a5:	e8 46 39 00 00       	call   80105bf0 <create>
    iunlock(in);
801022aa:	83 c4 14             	add    $0x14,%esp
    struct inode *in = create(path, T_FILE, 0, 0);
801022ad:	89 c6                	mov    %eax,%esi
    iunlock(in);
801022af:	50                   	push   %eax
801022b0:	e8 6b f5 ff ff       	call   80101820 <iunlock>

    p->swapFile = filealloc();
801022b5:	e8 76 eb ff ff       	call   80100e30 <filealloc>
    if (p->swapFile == 0)
801022ba:	83 c4 10             	add    $0x10,%esp
801022bd:	85 c0                	test   %eax,%eax
    p->swapFile = filealloc();
801022bf:	89 43 7c             	mov    %eax,0x7c(%ebx)
    if (p->swapFile == 0)
801022c2:	74 32                	je     801022f6 <createSwapFile+0x86>
        panic("no slot for files on /store");

    p->swapFile->ip = in;
801022c4:	89 70 10             	mov    %esi,0x10(%eax)
    p->swapFile->type = FD_INODE;
801022c7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022ca:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    p->swapFile->off = 0;
801022d0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022d3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    p->swapFile->readable = O_WRONLY;
801022da:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022dd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
    p->swapFile->writable = O_RDWR;
801022e1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022e4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801022e8:	e8 f3 0d 00 00       	call   801030e0 <end_op>

    return 0;
}
801022ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022f0:	31 c0                	xor    %eax,%eax
801022f2:	5b                   	pop    %ebx
801022f3:	5e                   	pop    %esi
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
        panic("no slot for files on /store");
801022f6:	83 ec 0c             	sub    $0xc,%esp
801022f9:	68 e0 85 10 80       	push   $0x801085e0
801022fe:	e8 8d e0 ff ff       	call   80100390 <panic>
80102303:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102310 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102316:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102319:	8b 50 7c             	mov    0x7c(%eax),%edx
8010231c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010231f:	8b 55 14             	mov    0x14(%ebp),%edx
80102322:	89 55 10             	mov    %edx,0x10(%ebp)
80102325:	8b 40 7c             	mov    0x7c(%eax),%eax
80102328:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010232b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010232c:	e9 6f ed ff ff       	jmp    801010a0 <filewrite>
80102331:	eb 0d                	jmp    80102340 <readFromSwapFile>
80102333:	90                   	nop
80102334:	90                   	nop
80102335:	90                   	nop
80102336:	90                   	nop
80102337:	90                   	nop
80102338:	90                   	nop
80102339:	90                   	nop
8010233a:	90                   	nop
8010233b:	90                   	nop
8010233c:	90                   	nop
8010233d:	90                   	nop
8010233e:	90                   	nop
8010233f:	90                   	nop

80102340 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102346:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102349:	8b 50 7c             	mov    0x7c(%eax),%edx
8010234c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010234f:	8b 55 14             	mov    0x14(%ebp),%edx
80102352:	89 55 10             	mov    %edx,0x10(%ebp)
80102355:	8b 40 7c             	mov    0x7c(%eax),%eax
80102358:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010235b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010235c:	e9 af ec ff ff       	jmp    80101010 <fileread>
80102361:	66 90                	xchg   %ax,%ax
80102363:	66 90                	xchg   %ax,%ax
80102365:	66 90                	xchg   %ax,%ax
80102367:	66 90                	xchg   %ax,%ax
80102369:	66 90                	xchg   %ax,%ax
8010236b:	66 90                	xchg   %ax,%ax
8010236d:	66 90                	xchg   %ax,%ax
8010236f:	90                   	nop

80102370 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	57                   	push   %edi
80102374:	56                   	push   %esi
80102375:	53                   	push   %ebx
80102376:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102379:	85 c0                	test   %eax,%eax
8010237b:	0f 84 b4 00 00 00    	je     80102435 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102381:	8b 58 08             	mov    0x8(%eax),%ebx
80102384:	89 c6                	mov    %eax,%esi
80102386:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010238c:	0f 87 96 00 00 00    	ja     80102428 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102392:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102397:	89 f6                	mov    %esi,%esi
80102399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801023a0:	89 ca                	mov    %ecx,%edx
801023a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023a3:	83 e0 c0             	and    $0xffffffc0,%eax
801023a6:	3c 40                	cmp    $0x40,%al
801023a8:	75 f6                	jne    801023a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023aa:	31 ff                	xor    %edi,%edi
801023ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801023b1:	89 f8                	mov    %edi,%eax
801023b3:	ee                   	out    %al,(%dx)
801023b4:	b8 01 00 00 00       	mov    $0x1,%eax
801023b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801023be:	ee                   	out    %al,(%dx)
801023bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801023c4:	89 d8                	mov    %ebx,%eax
801023c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801023c7:	89 d8                	mov    %ebx,%eax
801023c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801023ce:	c1 f8 08             	sar    $0x8,%eax
801023d1:	ee                   	out    %al,(%dx)
801023d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801023d7:	89 f8                	mov    %edi,%eax
801023d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801023da:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801023de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023e3:	c1 e0 04             	shl    $0x4,%eax
801023e6:	83 e0 10             	and    $0x10,%eax
801023e9:	83 c8 e0             	or     $0xffffffe0,%eax
801023ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801023ed:	f6 06 04             	testb  $0x4,(%esi)
801023f0:	75 16                	jne    80102408 <idestart+0x98>
801023f2:	b8 20 00 00 00       	mov    $0x20,%eax
801023f7:	89 ca                	mov    %ecx,%edx
801023f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801023fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023fd:	5b                   	pop    %ebx
801023fe:	5e                   	pop    %esi
801023ff:	5f                   	pop    %edi
80102400:	5d                   	pop    %ebp
80102401:	c3                   	ret    
80102402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102408:	b8 30 00 00 00       	mov    $0x30,%eax
8010240d:	89 ca                	mov    %ecx,%edx
8010240f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102410:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102415:	83 c6 5c             	add    $0x5c,%esi
80102418:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010241d:	fc                   	cld    
8010241e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102423:	5b                   	pop    %ebx
80102424:	5e                   	pop    %esi
80102425:	5f                   	pop    %edi
80102426:	5d                   	pop    %ebp
80102427:	c3                   	ret    
    panic("incorrect blockno");
80102428:	83 ec 0c             	sub    $0xc,%esp
8010242b:	68 58 86 10 80       	push   $0x80108658
80102430:	e8 5b df ff ff       	call   80100390 <panic>
    panic("idestart");
80102435:	83 ec 0c             	sub    $0xc,%esp
80102438:	68 4f 86 10 80       	push   $0x8010864f
8010243d:	e8 4e df ff ff       	call   80100390 <panic>
80102442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <ideinit>:
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102456:	68 6a 86 10 80       	push   $0x8010866a
8010245b:	68 80 c5 10 80       	push   $0x8010c580
80102460:	e8 2b 2b 00 00       	call   80104f90 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102465:	58                   	pop    %eax
80102466:	a1 20 4d 11 80       	mov    0x80114d20,%eax
8010246b:	5a                   	pop    %edx
8010246c:	83 e8 01             	sub    $0x1,%eax
8010246f:	50                   	push   %eax
80102470:	6a 0e                	push   $0xe
80102472:	e8 a9 02 00 00       	call   80102720 <ioapicenable>
80102477:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010247a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010247f:	90                   	nop
80102480:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102481:	83 e0 c0             	and    $0xffffffc0,%eax
80102484:	3c 40                	cmp    $0x40,%al
80102486:	75 f8                	jne    80102480 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102488:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010248d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102492:	ee                   	out    %al,(%dx)
80102493:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102498:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010249d:	eb 06                	jmp    801024a5 <ideinit+0x55>
8010249f:	90                   	nop
  for(i=0; i<1000; i++){
801024a0:	83 e9 01             	sub    $0x1,%ecx
801024a3:	74 0f                	je     801024b4 <ideinit+0x64>
801024a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801024a6:	84 c0                	test   %al,%al
801024a8:	74 f6                	je     801024a0 <ideinit+0x50>
      havedisk1 = 1;
801024aa:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
801024b1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024b4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801024b9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024be:	ee                   	out    %al,(%dx)
}
801024bf:	c9                   	leave  
801024c0:	c3                   	ret    
801024c1:	eb 0d                	jmp    801024d0 <ideintr>
801024c3:	90                   	nop
801024c4:	90                   	nop
801024c5:	90                   	nop
801024c6:	90                   	nop
801024c7:	90                   	nop
801024c8:	90                   	nop
801024c9:	90                   	nop
801024ca:	90                   	nop
801024cb:	90                   	nop
801024cc:	90                   	nop
801024cd:	90                   	nop
801024ce:	90                   	nop
801024cf:	90                   	nop

801024d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	57                   	push   %edi
801024d4:	56                   	push   %esi
801024d5:	53                   	push   %ebx
801024d6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801024d9:	68 80 c5 10 80       	push   $0x8010c580
801024de:	e8 9d 2b 00 00       	call   80105080 <acquire>

  if((b = idequeue) == 0){
801024e3:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
801024e9:	83 c4 10             	add    $0x10,%esp
801024ec:	85 db                	test   %ebx,%ebx
801024ee:	74 67                	je     80102557 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801024f0:	8b 43 58             	mov    0x58(%ebx),%eax
801024f3:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801024f8:	8b 3b                	mov    (%ebx),%edi
801024fa:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102500:	75 31                	jne    80102533 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102502:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102507:	89 f6                	mov    %esi,%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102510:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102511:	89 c6                	mov    %eax,%esi
80102513:	83 e6 c0             	and    $0xffffffc0,%esi
80102516:	89 f1                	mov    %esi,%ecx
80102518:	80 f9 40             	cmp    $0x40,%cl
8010251b:	75 f3                	jne    80102510 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010251d:	a8 21                	test   $0x21,%al
8010251f:	75 12                	jne    80102533 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102521:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102524:	b9 80 00 00 00       	mov    $0x80,%ecx
80102529:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010252e:	fc                   	cld    
8010252f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102531:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102533:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102536:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102539:	89 f9                	mov    %edi,%ecx
8010253b:	83 c9 02             	or     $0x2,%ecx
8010253e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102540:	53                   	push   %ebx
80102541:	e8 2a 23 00 00       	call   80104870 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102546:	a1 64 c5 10 80       	mov    0x8010c564,%eax
8010254b:	83 c4 10             	add    $0x10,%esp
8010254e:	85 c0                	test   %eax,%eax
80102550:	74 05                	je     80102557 <ideintr+0x87>
    idestart(idequeue);
80102552:	e8 19 fe ff ff       	call   80102370 <idestart>
    release(&idelock);
80102557:	83 ec 0c             	sub    $0xc,%esp
8010255a:	68 80 c5 10 80       	push   $0x8010c580
8010255f:	e8 3c 2c 00 00       	call   801051a0 <release>

  release(&idelock);
}
80102564:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5f                   	pop    %edi
8010256a:	5d                   	pop    %ebp
8010256b:	c3                   	ret    
8010256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102570 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	53                   	push   %ebx
80102574:	83 ec 10             	sub    $0x10,%esp
80102577:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010257a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010257d:	50                   	push   %eax
8010257e:	e8 dd 29 00 00       	call   80104f60 <holdingsleep>
80102583:	83 c4 10             	add    $0x10,%esp
80102586:	85 c0                	test   %eax,%eax
80102588:	0f 84 c6 00 00 00    	je     80102654 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010258e:	8b 03                	mov    (%ebx),%eax
80102590:	83 e0 06             	and    $0x6,%eax
80102593:	83 f8 02             	cmp    $0x2,%eax
80102596:	0f 84 ab 00 00 00    	je     80102647 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010259c:	8b 53 04             	mov    0x4(%ebx),%edx
8010259f:	85 d2                	test   %edx,%edx
801025a1:	74 0d                	je     801025b0 <iderw+0x40>
801025a3:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801025a8:	85 c0                	test   %eax,%eax
801025aa:	0f 84 b1 00 00 00    	je     80102661 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801025b0:	83 ec 0c             	sub    $0xc,%esp
801025b3:	68 80 c5 10 80       	push   $0x8010c580
801025b8:	e8 c3 2a 00 00       	call   80105080 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025bd:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
801025c3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801025c6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025cd:	85 d2                	test   %edx,%edx
801025cf:	75 09                	jne    801025da <iderw+0x6a>
801025d1:	eb 6d                	jmp    80102640 <iderw+0xd0>
801025d3:	90                   	nop
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025d8:	89 c2                	mov    %eax,%edx
801025da:	8b 42 58             	mov    0x58(%edx),%eax
801025dd:	85 c0                	test   %eax,%eax
801025df:	75 f7                	jne    801025d8 <iderw+0x68>
801025e1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801025e4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801025e6:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
801025ec:	74 42                	je     80102630 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025ee:	8b 03                	mov    (%ebx),%eax
801025f0:	83 e0 06             	and    $0x6,%eax
801025f3:	83 f8 02             	cmp    $0x2,%eax
801025f6:	74 23                	je     8010261b <iderw+0xab>
801025f8:	90                   	nop
801025f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102600:	83 ec 08             	sub    $0x8,%esp
80102603:	68 80 c5 10 80       	push   $0x8010c580
80102608:	53                   	push   %ebx
80102609:	e8 f2 1f 00 00       	call   80104600 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010260e:	8b 03                	mov    (%ebx),%eax
80102610:	83 c4 10             	add    $0x10,%esp
80102613:	83 e0 06             	and    $0x6,%eax
80102616:	83 f8 02             	cmp    $0x2,%eax
80102619:	75 e5                	jne    80102600 <iderw+0x90>
  }


  release(&idelock);
8010261b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102625:	c9                   	leave  
  release(&idelock);
80102626:	e9 75 2b 00 00       	jmp    801051a0 <release>
8010262b:	90                   	nop
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102630:	89 d8                	mov    %ebx,%eax
80102632:	e8 39 fd ff ff       	call   80102370 <idestart>
80102637:	eb b5                	jmp    801025ee <iderw+0x7e>
80102639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102640:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102645:	eb 9d                	jmp    801025e4 <iderw+0x74>
    panic("iderw: nothing to do");
80102647:	83 ec 0c             	sub    $0xc,%esp
8010264a:	68 84 86 10 80       	push   $0x80108684
8010264f:	e8 3c dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102654:	83 ec 0c             	sub    $0xc,%esp
80102657:	68 6e 86 10 80       	push   $0x8010866e
8010265c:	e8 2f dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102661:	83 ec 0c             	sub    $0xc,%esp
80102664:	68 99 86 10 80       	push   $0x80108699
80102669:	e8 22 dd ff ff       	call   80100390 <panic>
8010266e:	66 90                	xchg   %ax,%ax

80102670 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102670:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102671:	c7 05 54 46 11 80 00 	movl   $0xfec00000,0x80114654
80102678:	00 c0 fe 
{
8010267b:	89 e5                	mov    %esp,%ebp
8010267d:	56                   	push   %esi
8010267e:	53                   	push   %ebx
  ioapic->reg = reg;
8010267f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102686:	00 00 00 
  return ioapic->data;
80102689:	a1 54 46 11 80       	mov    0x80114654,%eax
8010268e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102691:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102697:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010269d:	0f b6 15 80 47 11 80 	movzbl 0x80114780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801026a4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801026a7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801026aa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801026ad:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801026b0:	39 c2                	cmp    %eax,%edx
801026b2:	74 16                	je     801026ca <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801026b4:	83 ec 0c             	sub    $0xc,%esp
801026b7:	68 b8 86 10 80       	push   $0x801086b8
801026bc:	e8 9f df ff ff       	call   80100660 <cprintf>
801026c1:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
801026c7:	83 c4 10             	add    $0x10,%esp
801026ca:	83 c3 21             	add    $0x21,%ebx
{
801026cd:	ba 10 00 00 00       	mov    $0x10,%edx
801026d2:	b8 20 00 00 00       	mov    $0x20,%eax
801026d7:	89 f6                	mov    %esi,%esi
801026d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801026e0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801026e2:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801026e8:	89 c6                	mov    %eax,%esi
801026ea:	81 ce 00 00 01 00    	or     $0x10000,%esi
801026f0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026f3:	89 71 10             	mov    %esi,0x10(%ecx)
801026f6:	8d 72 01             	lea    0x1(%edx),%esi
801026f9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801026fc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801026fe:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102700:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
80102706:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010270d:	75 d1                	jne    801026e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010270f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102712:	5b                   	pop    %ebx
80102713:	5e                   	pop    %esi
80102714:	5d                   	pop    %ebp
80102715:	c3                   	ret    
80102716:	8d 76 00             	lea    0x0(%esi),%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102720 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102720:	55                   	push   %ebp
  ioapic->reg = reg;
80102721:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
{
80102727:	89 e5                	mov    %esp,%ebp
80102729:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010272c:	8d 50 20             	lea    0x20(%eax),%edx
8010272f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102733:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102735:	8b 0d 54 46 11 80    	mov    0x80114654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010273b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010273e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102741:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102744:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102746:	a1 54 46 11 80       	mov    0x80114654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010274b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010274e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102751:	5d                   	pop    %ebp
80102752:	c3                   	ret    
80102753:	66 90                	xchg   %ax,%ax
80102755:	66 90                	xchg   %ax,%ax
80102757:	66 90                	xchg   %ax,%ax
80102759:	66 90                	xchg   %ax,%ax
8010275b:	66 90                	xchg   %ax,%ax
8010275d:	66 90                	xchg   %ax,%ax
8010275f:	90                   	nop

80102760 <kallocCount>:


//called once via userinit to count number of pages
int
kallocCount(void)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  int count = 0;
  if(kmem.use_lock) //lock check
80102766:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
8010276c:	85 c9                	test   %ecx,%ecx
8010276e:	75 40                	jne    801027b0 <kallocCount+0x50>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102770:	8b 15 98 46 11 80    	mov    0x80114698,%edx
  //count all the pages by iterating the freelist
  while(r){
80102776:	85 d2                	test   %edx,%edx
80102778:	74 5e                	je     801027d8 <kallocCount+0x78>
{
8010277a:	31 c0                	xor    %eax,%eax
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    count++;
    r = r->next;
80102780:	8b 12                	mov    (%edx),%edx
    count++;
80102782:	83 c0 01             	add    $0x1,%eax
  while(r){
80102785:	85 d2                	test   %edx,%edx
80102787:	75 f7                	jne    80102780 <kallocCount+0x20>
  }
  if(kmem.use_lock)//lock check
80102789:	85 c9                	test   %ecx,%ecx
8010278b:	75 03                	jne    80102790 <kallocCount+0x30>
    release(&kmem.lock);
  return count;
}
8010278d:	c9                   	leave  
8010278e:	c3                   	ret    
8010278f:	90                   	nop
    release(&kmem.lock);
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102796:	68 60 46 11 80       	push   $0x80114660
8010279b:	e8 00 2a 00 00       	call   801051a0 <release>
  return count;
801027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027a3:	83 c4 10             	add    $0x10,%esp
}
801027a6:	c9                   	leave  
801027a7:	c3                   	ret    
801027a8:	90                   	nop
801027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801027b0:	83 ec 0c             	sub    $0xc,%esp
801027b3:	68 60 46 11 80       	push   $0x80114660
801027b8:	e8 c3 28 00 00       	call   80105080 <acquire>
  r = kmem.freelist;
801027bd:	8b 15 98 46 11 80    	mov    0x80114698,%edx
  while(r){
801027c3:	83 c4 10             	add    $0x10,%esp
801027c6:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
801027cc:	85 d2                	test   %edx,%edx
801027ce:	75 aa                	jne    8010277a <kallocCount+0x1a>
  int count = 0;
801027d0:	31 c0                	xor    %eax,%eax
801027d2:	eb b5                	jmp    80102789 <kallocCount+0x29>
801027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027d8:	31 c0                	xor    %eax,%eax
}
801027da:	c9                   	leave  
801027db:	c3                   	ret    
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	53                   	push   %ebx
801027e4:	83 ec 04             	sub    $0x4,%esp
801027e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801027ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801027f0:	75 70                	jne    80102862 <kfree+0x82>
801027f2:	81 fb ec 7c 12 80    	cmp    $0x80127cec,%ebx
801027f8:	72 68                	jb     80102862 <kfree+0x82>
801027fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102800:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102805:	77 5b                	ja     80102862 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102807:	83 ec 04             	sub    $0x4,%esp
8010280a:	68 00 10 00 00       	push   $0x1000
8010280f:	6a 01                	push   $0x1
80102811:	53                   	push   %ebx
80102812:	e8 e9 29 00 00       	call   80105200 <memset>

  if(kmem.use_lock)
80102817:	8b 15 94 46 11 80    	mov    0x80114694,%edx
8010281d:	83 c4 10             	add    $0x10,%esp
80102820:	85 d2                	test   %edx,%edx
80102822:	75 2c                	jne    80102850 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102824:	a1 98 46 11 80       	mov    0x80114698,%eax
80102829:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010282b:	a1 94 46 11 80       	mov    0x80114694,%eax
  kmem.freelist = r;
80102830:	89 1d 98 46 11 80    	mov    %ebx,0x80114698
  if(kmem.use_lock)
80102836:	85 c0                	test   %eax,%eax
80102838:	75 06                	jne    80102840 <kfree+0x60>
    release(&kmem.lock);
}
8010283a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010283d:	c9                   	leave  
8010283e:	c3                   	ret    
8010283f:	90                   	nop
    release(&kmem.lock);
80102840:	c7 45 08 60 46 11 80 	movl   $0x80114660,0x8(%ebp)
}
80102847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010284a:	c9                   	leave  
    release(&kmem.lock);
8010284b:	e9 50 29 00 00       	jmp    801051a0 <release>
    acquire(&kmem.lock);
80102850:	83 ec 0c             	sub    $0xc,%esp
80102853:	68 60 46 11 80       	push   $0x80114660
80102858:	e8 23 28 00 00       	call   80105080 <acquire>
8010285d:	83 c4 10             	add    $0x10,%esp
80102860:	eb c2                	jmp    80102824 <kfree+0x44>
    panic("kfree");
80102862:	83 ec 0c             	sub    $0xc,%esp
80102865:	68 ea 86 10 80       	push   $0x801086ea
8010286a:	e8 21 db ff ff       	call   80100390 <panic>
8010286f:	90                   	nop

80102870 <freerange>:
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	56                   	push   %esi
80102874:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102875:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102878:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010287b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102881:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102887:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010288d:	39 de                	cmp    %ebx,%esi
8010288f:	72 23                	jb     801028b4 <freerange+0x44>
80102891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102898:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010289e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028a7:	50                   	push   %eax
801028a8:	e8 33 ff ff ff       	call   801027e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ad:	83 c4 10             	add    $0x10,%esp
801028b0:	39 f3                	cmp    %esi,%ebx
801028b2:	76 e4                	jbe    80102898 <freerange+0x28>
}
801028b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028b7:	5b                   	pop    %ebx
801028b8:	5e                   	pop    %esi
801028b9:	5d                   	pop    %ebp
801028ba:	c3                   	ret    
801028bb:	90                   	nop
801028bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028c0 <kinit1>:
{
801028c0:	55                   	push   %ebp
801028c1:	89 e5                	mov    %esp,%ebp
801028c3:	56                   	push   %esi
801028c4:	53                   	push   %ebx
801028c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801028c8:	83 ec 08             	sub    $0x8,%esp
801028cb:	68 f0 86 10 80       	push   $0x801086f0
801028d0:	68 60 46 11 80       	push   $0x80114660
801028d5:	e8 b6 26 00 00       	call   80104f90 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801028da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801028e0:	c7 05 94 46 11 80 00 	movl   $0x0,0x80114694
801028e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801028ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028fc:	39 de                	cmp    %ebx,%esi
801028fe:	72 1c                	jb     8010291c <kinit1+0x5c>
    kfree(p);
80102900:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102906:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102909:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010290f:	50                   	push   %eax
80102910:	e8 cb fe ff ff       	call   801027e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102915:	83 c4 10             	add    $0x10,%esp
80102918:	39 de                	cmp    %ebx,%esi
8010291a:	73 e4                	jae    80102900 <kinit1+0x40>
}
8010291c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010291f:	5b                   	pop    %ebx
80102920:	5e                   	pop    %esi
80102921:	5d                   	pop    %ebp
80102922:	c3                   	ret    
80102923:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102930 <kinit2>:
{
80102930:	55                   	push   %ebp
80102931:	89 e5                	mov    %esp,%ebp
80102933:	56                   	push   %esi
80102934:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102935:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102938:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010293b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102941:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102947:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010294d:	39 de                	cmp    %ebx,%esi
8010294f:	72 23                	jb     80102974 <kinit2+0x44>
80102951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102958:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010295e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102961:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102967:	50                   	push   %eax
80102968:	e8 73 fe ff ff       	call   801027e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010296d:	83 c4 10             	add    $0x10,%esp
80102970:	39 de                	cmp    %ebx,%esi
80102972:	73 e4                	jae    80102958 <kinit2+0x28>
  kmem.use_lock = 1;
80102974:	c7 05 94 46 11 80 01 	movl   $0x1,0x80114694
8010297b:	00 00 00 
}
8010297e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102981:	5b                   	pop    %ebx
80102982:	5e                   	pop    %esi
80102983:	5d                   	pop    %ebp
80102984:	c3                   	ret    
80102985:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102990 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102990:	a1 94 46 11 80       	mov    0x80114694,%eax
80102995:	85 c0                	test   %eax,%eax
80102997:	75 1f                	jne    801029b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102999:	a1 98 46 11 80       	mov    0x80114698,%eax
  if(r)
8010299e:	85 c0                	test   %eax,%eax
801029a0:	74 0e                	je     801029b0 <kalloc+0x20>
    kmem.freelist = r->next;
801029a2:	8b 10                	mov    (%eax),%edx
801029a4:	89 15 98 46 11 80    	mov    %edx,0x80114698
801029aa:	c3                   	ret    
801029ab:	90                   	nop
801029ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801029b0:	f3 c3                	repz ret 
801029b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801029b8:	55                   	push   %ebp
801029b9:	89 e5                	mov    %esp,%ebp
801029bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029be:	68 60 46 11 80       	push   $0x80114660
801029c3:	e8 b8 26 00 00       	call   80105080 <acquire>
  r = kmem.freelist;
801029c8:	a1 98 46 11 80       	mov    0x80114698,%eax
  if(r)
801029cd:	83 c4 10             	add    $0x10,%esp
801029d0:	8b 15 94 46 11 80    	mov    0x80114694,%edx
801029d6:	85 c0                	test   %eax,%eax
801029d8:	74 08                	je     801029e2 <kalloc+0x52>
    kmem.freelist = r->next;
801029da:	8b 08                	mov    (%eax),%ecx
801029dc:	89 0d 98 46 11 80    	mov    %ecx,0x80114698
  if(kmem.use_lock)
801029e2:	85 d2                	test   %edx,%edx
801029e4:	74 16                	je     801029fc <kalloc+0x6c>
    release(&kmem.lock);
801029e6:	83 ec 0c             	sub    $0xc,%esp
801029e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029ec:	68 60 46 11 80       	push   $0x80114660
801029f1:	e8 aa 27 00 00       	call   801051a0 <release>
  return (char*)r;
801029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801029f9:	83 c4 10             	add    $0x10,%esp
}
801029fc:	c9                   	leave  
801029fd:	c3                   	ret    
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a00:	ba 64 00 00 00       	mov    $0x64,%edx
80102a05:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102a06:	a8 01                	test   $0x1,%al
80102a08:	0f 84 c2 00 00 00    	je     80102ad0 <kbdgetc+0xd0>
80102a0e:	ba 60 00 00 00       	mov    $0x60,%edx
80102a13:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102a14:	0f b6 d0             	movzbl %al,%edx
80102a17:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
80102a1d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102a23:	0f 84 7f 00 00 00    	je     80102aa8 <kbdgetc+0xa8>
{
80102a29:	55                   	push   %ebp
80102a2a:	89 e5                	mov    %esp,%ebp
80102a2c:	53                   	push   %ebx
80102a2d:	89 cb                	mov    %ecx,%ebx
80102a2f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102a32:	84 c0                	test   %al,%al
80102a34:	78 4a                	js     80102a80 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a36:	85 db                	test   %ebx,%ebx
80102a38:	74 09                	je     80102a43 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a3a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a3d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102a40:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102a43:	0f b6 82 20 88 10 80 	movzbl -0x7fef77e0(%edx),%eax
80102a4a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102a4c:	0f b6 82 20 87 10 80 	movzbl -0x7fef78e0(%edx),%eax
80102a53:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a55:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a57:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102a5d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a60:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a63:	8b 04 85 00 87 10 80 	mov    -0x7fef7900(,%eax,4),%eax
80102a6a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102a6e:	74 31                	je     80102aa1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102a70:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a73:	83 fa 19             	cmp    $0x19,%edx
80102a76:	77 40                	ja     80102ab8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a78:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a7b:	5b                   	pop    %ebx
80102a7c:	5d                   	pop    %ebp
80102a7d:	c3                   	ret    
80102a7e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102a80:	83 e0 7f             	and    $0x7f,%eax
80102a83:	85 db                	test   %ebx,%ebx
80102a85:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102a88:	0f b6 82 20 88 10 80 	movzbl -0x7fef77e0(%edx),%eax
80102a8f:	83 c8 40             	or     $0x40,%eax
80102a92:	0f b6 c0             	movzbl %al,%eax
80102a95:	f7 d0                	not    %eax
80102a97:	21 c1                	and    %eax,%ecx
    return 0;
80102a99:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102a9b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102aa1:	5b                   	pop    %ebx
80102aa2:	5d                   	pop    %ebp
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102aa8:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102aab:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102aad:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
80102ab3:	c3                   	ret    
80102ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102ab8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102abb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102abe:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102abf:	83 f9 1a             	cmp    $0x1a,%ecx
80102ac2:	0f 42 c2             	cmovb  %edx,%eax
}
80102ac5:	5d                   	pop    %ebp
80102ac6:	c3                   	ret    
80102ac7:	89 f6                	mov    %esi,%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ad5:	c3                   	ret    
80102ad6:	8d 76 00             	lea    0x0(%esi),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <kbdintr>:

void
kbdintr(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102ae6:	68 00 2a 10 80       	push   $0x80102a00
80102aeb:	e8 20 dd ff ff       	call   80100810 <consoleintr>
}
80102af0:	83 c4 10             	add    $0x10,%esp
80102af3:	c9                   	leave  
80102af4:	c3                   	ret    
80102af5:	66 90                	xchg   %ax,%ax
80102af7:	66 90                	xchg   %ax,%ax
80102af9:	66 90                	xchg   %ax,%ax
80102afb:	66 90                	xchg   %ax,%ax
80102afd:	66 90                	xchg   %ax,%ax
80102aff:	90                   	nop

80102b00 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102b00:	a1 9c 46 11 80       	mov    0x8011469c,%eax
{
80102b05:	55                   	push   %ebp
80102b06:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102b08:	85 c0                	test   %eax,%eax
80102b0a:	0f 84 c8 00 00 00    	je     80102bd8 <lapicinit+0xd8>
  lapic[index] = value;
80102b10:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b17:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b1a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b1d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b2a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b31:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b34:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b37:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b3e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b41:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b44:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b4b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b51:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b58:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b5b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b5e:	8b 50 30             	mov    0x30(%eax),%edx
80102b61:	c1 ea 10             	shr    $0x10,%edx
80102b64:	80 fa 03             	cmp    $0x3,%dl
80102b67:	77 77                	ja     80102be0 <lapicinit+0xe0>
  lapic[index] = value;
80102b69:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b70:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b73:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b76:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b7d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b80:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b83:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b8a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b8d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b90:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b97:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b9d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ba4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102baa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102bb1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb4:	8b 50 20             	mov    0x20(%eax),%edx
80102bb7:	89 f6                	mov    %esi,%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102bc0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102bc6:	80 e6 10             	and    $0x10,%dh
80102bc9:	75 f5                	jne    80102bc0 <lapicinit+0xc0>
  lapic[index] = value;
80102bcb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102bd2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102bd8:	5d                   	pop    %ebp
80102bd9:	c3                   	ret    
80102bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102be0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102be7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bea:	8b 50 20             	mov    0x20(%eax),%edx
80102bed:	e9 77 ff ff ff       	jmp    80102b69 <lapicinit+0x69>
80102bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102c00:	8b 15 9c 46 11 80    	mov    0x8011469c,%edx
{
80102c06:	55                   	push   %ebp
80102c07:	31 c0                	xor    %eax,%eax
80102c09:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102c0b:	85 d2                	test   %edx,%edx
80102c0d:	74 06                	je     80102c15 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102c0f:	8b 42 20             	mov    0x20(%edx),%eax
80102c12:	c1 e8 18             	shr    $0x18,%eax
}
80102c15:	5d                   	pop    %ebp
80102c16:	c3                   	ret    
80102c17:	89 f6                	mov    %esi,%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c20:	a1 9c 46 11 80       	mov    0x8011469c,%eax
{
80102c25:	55                   	push   %ebp
80102c26:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102c28:	85 c0                	test   %eax,%eax
80102c2a:	74 0d                	je     80102c39 <lapiceoi+0x19>
  lapic[index] = value;
80102c2c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c33:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c36:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c39:	5d                   	pop    %ebp
80102c3a:	c3                   	ret    
80102c3b:	90                   	nop
80102c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c40 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
}
80102c43:	5d                   	pop    %ebp
80102c44:	c3                   	ret    
80102c45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c56:	ba 70 00 00 00       	mov    $0x70,%edx
80102c5b:	89 e5                	mov    %esp,%ebp
80102c5d:	53                   	push   %ebx
80102c5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c64:	ee                   	out    %al,(%dx)
80102c65:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102c6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c70:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c7d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102c80:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102c83:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c8e:	a1 9c 46 11 80       	mov    0x8011469c,%eax
80102c93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ca3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ca9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102cb0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cb6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cbc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cbf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cc5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cc8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cd1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cd7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102cda:	5b                   	pop    %ebx
80102cdb:	5d                   	pop    %ebp
80102cdc:	c3                   	ret    
80102cdd:	8d 76 00             	lea    0x0(%esi),%esi

80102ce0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102ce0:	55                   	push   %ebp
80102ce1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ce6:	ba 70 00 00 00       	mov    $0x70,%edx
80102ceb:	89 e5                	mov    %esp,%ebp
80102ced:	57                   	push   %edi
80102cee:	56                   	push   %esi
80102cef:	53                   	push   %ebx
80102cf0:	83 ec 4c             	sub    $0x4c,%esp
80102cf3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf4:	ba 71 00 00 00       	mov    $0x71,%edx
80102cf9:	ec                   	in     (%dx),%al
80102cfa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cfd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102d02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102d05:	8d 76 00             	lea    0x0(%esi),%esi
80102d08:	31 c0                	xor    %eax,%eax
80102d0a:	89 da                	mov    %ebx,%edx
80102d0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d12:	89 ca                	mov    %ecx,%edx
80102d14:	ec                   	in     (%dx),%al
80102d15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d18:	89 da                	mov    %ebx,%edx
80102d1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102d1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d20:	89 ca                	mov    %ecx,%edx
80102d22:	ec                   	in     (%dx),%al
80102d23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d26:	89 da                	mov    %ebx,%edx
80102d28:	b8 04 00 00 00       	mov    $0x4,%eax
80102d2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2e:	89 ca                	mov    %ecx,%edx
80102d30:	ec                   	in     (%dx),%al
80102d31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d34:	89 da                	mov    %ebx,%edx
80102d36:	b8 07 00 00 00       	mov    $0x7,%eax
80102d3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d3c:	89 ca                	mov    %ecx,%edx
80102d3e:	ec                   	in     (%dx),%al
80102d3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d42:	89 da                	mov    %ebx,%edx
80102d44:	b8 08 00 00 00       	mov    $0x8,%eax
80102d49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d4a:	89 ca                	mov    %ecx,%edx
80102d4c:	ec                   	in     (%dx),%al
80102d4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d4f:	89 da                	mov    %ebx,%edx
80102d51:	b8 09 00 00 00       	mov    $0x9,%eax
80102d56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d57:	89 ca                	mov    %ecx,%edx
80102d59:	ec                   	in     (%dx),%al
80102d5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d5c:	89 da                	mov    %ebx,%edx
80102d5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d64:	89 ca                	mov    %ecx,%edx
80102d66:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d67:	84 c0                	test   %al,%al
80102d69:	78 9d                	js     80102d08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102d6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d6f:	89 fa                	mov    %edi,%edx
80102d71:	0f b6 fa             	movzbl %dl,%edi
80102d74:	89 f2                	mov    %esi,%edx
80102d76:	0f b6 f2             	movzbl %dl,%esi
80102d79:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d7c:	89 da                	mov    %ebx,%edx
80102d7e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d81:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d84:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d88:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d8b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d99:	31 c0                	xor    %eax,%eax
80102d9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9c:	89 ca                	mov    %ecx,%edx
80102d9e:	ec                   	in     (%dx),%al
80102d9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da2:	89 da                	mov    %ebx,%edx
80102da4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102da7:	b8 02 00 00 00       	mov    $0x2,%eax
80102dac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dad:	89 ca                	mov    %ecx,%edx
80102daf:	ec                   	in     (%dx),%al
80102db0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db3:	89 da                	mov    %ebx,%edx
80102db5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102db8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbe:	89 ca                	mov    %ecx,%edx
80102dc0:	ec                   	in     (%dx),%al
80102dc1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc4:	89 da                	mov    %ebx,%edx
80102dc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102dc9:	b8 07 00 00 00       	mov    $0x7,%eax
80102dce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dcf:	89 ca                	mov    %ecx,%edx
80102dd1:	ec                   	in     (%dx),%al
80102dd2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd5:	89 da                	mov    %ebx,%edx
80102dd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102dda:	b8 08 00 00 00       	mov    $0x8,%eax
80102ddf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de0:	89 ca                	mov    %ecx,%edx
80102de2:	ec                   	in     (%dx),%al
80102de3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de6:	89 da                	mov    %ebx,%edx
80102de8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102deb:	b8 09 00 00 00       	mov    $0x9,%eax
80102df0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102df1:	89 ca                	mov    %ecx,%edx
80102df3:	ec                   	in     (%dx),%al
80102df4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102df7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102dfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102dfd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102e00:	6a 18                	push   $0x18
80102e02:	50                   	push   %eax
80102e03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102e06:	50                   	push   %eax
80102e07:	e8 44 24 00 00       	call   80105250 <memcmp>
80102e0c:	83 c4 10             	add    $0x10,%esp
80102e0f:	85 c0                	test   %eax,%eax
80102e11:	0f 85 f1 fe ff ff    	jne    80102d08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102e17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e1b:	75 78                	jne    80102e95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e20:	89 c2                	mov    %eax,%edx
80102e22:	83 e0 0f             	and    $0xf,%eax
80102e25:	c1 ea 04             	shr    $0x4,%edx
80102e28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e34:	89 c2                	mov    %eax,%edx
80102e36:	83 e0 0f             	and    $0xf,%eax
80102e39:	c1 ea 04             	shr    $0x4,%edx
80102e3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e48:	89 c2                	mov    %eax,%edx
80102e4a:	83 e0 0f             	and    $0xf,%eax
80102e4d:	c1 ea 04             	shr    $0x4,%edx
80102e50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e5c:	89 c2                	mov    %eax,%edx
80102e5e:	83 e0 0f             	and    $0xf,%eax
80102e61:	c1 ea 04             	shr    $0x4,%edx
80102e64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e70:	89 c2                	mov    %eax,%edx
80102e72:	83 e0 0f             	and    $0xf,%eax
80102e75:	c1 ea 04             	shr    $0x4,%edx
80102e78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e84:	89 c2                	mov    %eax,%edx
80102e86:	83 e0 0f             	and    $0xf,%eax
80102e89:	c1 ea 04             	shr    $0x4,%edx
80102e8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e95:	8b 75 08             	mov    0x8(%ebp),%esi
80102e98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e9b:	89 06                	mov    %eax,(%esi)
80102e9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ea0:	89 46 04             	mov    %eax,0x4(%esi)
80102ea3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ea6:	89 46 08             	mov    %eax,0x8(%esi)
80102ea9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102eac:	89 46 0c             	mov    %eax,0xc(%esi)
80102eaf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102eb2:	89 46 10             	mov    %eax,0x10(%esi)
80102eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102eb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102ebb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ec5:	5b                   	pop    %ebx
80102ec6:	5e                   	pop    %esi
80102ec7:	5f                   	pop    %edi
80102ec8:	5d                   	pop    %ebp
80102ec9:	c3                   	ret    
80102eca:	66 90                	xchg   %ax,%ax
80102ecc:	66 90                	xchg   %ax,%ax
80102ece:	66 90                	xchg   %ax,%ax

80102ed0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ed0:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80102ed6:	85 c9                	test   %ecx,%ecx
80102ed8:	0f 8e 8a 00 00 00    	jle    80102f68 <install_trans+0x98>
{
80102ede:	55                   	push   %ebp
80102edf:	89 e5                	mov    %esp,%ebp
80102ee1:	57                   	push   %edi
80102ee2:	56                   	push   %esi
80102ee3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee4:	31 db                	xor    %ebx,%ebx
{
80102ee6:	83 ec 0c             	sub    $0xc,%esp
80102ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ef0:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80102ef5:	83 ec 08             	sub    $0x8,%esp
80102ef8:	01 d8                	add    %ebx,%eax
80102efa:	83 c0 01             	add    $0x1,%eax
80102efd:	50                   	push   %eax
80102efe:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102f04:	e8 c7 d1 ff ff       	call   801000d0 <bread>
80102f09:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f0b:	58                   	pop    %eax
80102f0c:	5a                   	pop    %edx
80102f0d:	ff 34 9d ec 46 11 80 	pushl  -0x7feeb914(,%ebx,4)
80102f14:	ff 35 e4 46 11 80    	pushl  0x801146e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f1a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f1d:	e8 ae d1 ff ff       	call   801000d0 <bread>
80102f22:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f24:	8d 47 5c             	lea    0x5c(%edi),%eax
80102f27:	83 c4 0c             	add    $0xc,%esp
80102f2a:	68 00 02 00 00       	push   $0x200
80102f2f:	50                   	push   %eax
80102f30:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f33:	50                   	push   %eax
80102f34:	e8 77 23 00 00       	call   801052b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f39:	89 34 24             	mov    %esi,(%esp)
80102f3c:	e8 5f d2 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102f41:	89 3c 24             	mov    %edi,(%esp)
80102f44:	e8 97 d2 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102f49:	89 34 24             	mov    %esi,(%esp)
80102f4c:	e8 8f d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f51:	83 c4 10             	add    $0x10,%esp
80102f54:	39 1d e8 46 11 80    	cmp    %ebx,0x801146e8
80102f5a:	7f 94                	jg     80102ef0 <install_trans+0x20>
  }
}
80102f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f5f:	5b                   	pop    %ebx
80102f60:	5e                   	pop    %esi
80102f61:	5f                   	pop    %edi
80102f62:	5d                   	pop    %ebp
80102f63:	c3                   	ret    
80102f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f68:	f3 c3                	repz ret 
80102f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102f70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	56                   	push   %esi
80102f74:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102f75:	83 ec 08             	sub    $0x8,%esp
80102f78:	ff 35 d4 46 11 80    	pushl  0x801146d4
80102f7e:	ff 35 e4 46 11 80    	pushl  0x801146e4
80102f84:	e8 47 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102f89:	8b 1d e8 46 11 80    	mov    0x801146e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f8f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f92:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102f94:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102f96:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102f99:	7e 16                	jle    80102fb1 <write_head+0x41>
80102f9b:	c1 e3 02             	shl    $0x2,%ebx
80102f9e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102fa0:	8b 8a ec 46 11 80    	mov    -0x7feeb914(%edx),%ecx
80102fa6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102faa:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102fad:	39 da                	cmp    %ebx,%edx
80102faf:	75 ef                	jne    80102fa0 <write_head+0x30>
  }
  bwrite(buf);
80102fb1:	83 ec 0c             	sub    $0xc,%esp
80102fb4:	56                   	push   %esi
80102fb5:	e8 e6 d1 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102fba:	89 34 24             	mov    %esi,(%esp)
80102fbd:	e8 1e d2 ff ff       	call   801001e0 <brelse>
}
80102fc2:	83 c4 10             	add    $0x10,%esp
80102fc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102fc8:	5b                   	pop    %ebx
80102fc9:	5e                   	pop    %esi
80102fca:	5d                   	pop    %ebp
80102fcb:	c3                   	ret    
80102fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fd0 <initlog>:
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 2c             	sub    $0x2c,%esp
80102fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102fda:	68 20 89 10 80       	push   $0x80108920
80102fdf:	68 a0 46 11 80       	push   $0x801146a0
80102fe4:	e8 a7 1f 00 00       	call   80104f90 <initlock>
  readsb(dev, &sb);
80102fe9:	58                   	pop    %eax
80102fea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102fed:	5a                   	pop    %edx
80102fee:	50                   	push   %eax
80102fef:	53                   	push   %ebx
80102ff0:	e8 8b e4 ff ff       	call   80101480 <readsb>
  log.size = sb.nlog;
80102ff5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ffb:	59                   	pop    %ecx
  log.dev = dev;
80102ffc:	89 1d e4 46 11 80    	mov    %ebx,0x801146e4
  log.size = sb.nlog;
80103002:	89 15 d8 46 11 80    	mov    %edx,0x801146d8
  log.start = sb.logstart;
80103008:	a3 d4 46 11 80       	mov    %eax,0x801146d4
  struct buf *buf = bread(log.dev, log.start);
8010300d:	5a                   	pop    %edx
8010300e:	50                   	push   %eax
8010300f:	53                   	push   %ebx
80103010:	e8 bb d0 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103015:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103018:	83 c4 10             	add    $0x10,%esp
8010301b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010301d:	89 1d e8 46 11 80    	mov    %ebx,0x801146e8
  for (i = 0; i < log.lh.n; i++) {
80103023:	7e 1c                	jle    80103041 <initlog+0x71>
80103025:	c1 e3 02             	shl    $0x2,%ebx
80103028:	31 d2                	xor    %edx,%edx
8010302a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103030:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103034:	83 c2 04             	add    $0x4,%edx
80103037:	89 8a e8 46 11 80    	mov    %ecx,-0x7feeb918(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010303d:	39 d3                	cmp    %edx,%ebx
8010303f:	75 ef                	jne    80103030 <initlog+0x60>
  brelse(buf);
80103041:	83 ec 0c             	sub    $0xc,%esp
80103044:	50                   	push   %eax
80103045:	e8 96 d1 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010304a:	e8 81 fe ff ff       	call   80102ed0 <install_trans>
  log.lh.n = 0;
8010304f:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
80103056:	00 00 00 
  write_head(); // clear the log
80103059:	e8 12 ff ff ff       	call   80102f70 <write_head>
}
8010305e:	83 c4 10             	add    $0x10,%esp
80103061:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103064:	c9                   	leave  
80103065:	c3                   	ret    
80103066:	8d 76 00             	lea    0x0(%esi),%esi
80103069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103070 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103076:	68 a0 46 11 80       	push   $0x801146a0
8010307b:	e8 00 20 00 00       	call   80105080 <acquire>
80103080:	83 c4 10             	add    $0x10,%esp
80103083:	eb 18                	jmp    8010309d <begin_op+0x2d>
80103085:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103088:	83 ec 08             	sub    $0x8,%esp
8010308b:	68 a0 46 11 80       	push   $0x801146a0
80103090:	68 a0 46 11 80       	push   $0x801146a0
80103095:	e8 66 15 00 00       	call   80104600 <sleep>
8010309a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010309d:	a1 e0 46 11 80       	mov    0x801146e0,%eax
801030a2:	85 c0                	test   %eax,%eax
801030a4:	75 e2                	jne    80103088 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801030a6:	a1 dc 46 11 80       	mov    0x801146dc,%eax
801030ab:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
801030b1:	83 c0 01             	add    $0x1,%eax
801030b4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030b7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801030ba:	83 fa 1e             	cmp    $0x1e,%edx
801030bd:	7f c9                	jg     80103088 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801030bf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030c2:	a3 dc 46 11 80       	mov    %eax,0x801146dc
      release(&log.lock);
801030c7:	68 a0 46 11 80       	push   $0x801146a0
801030cc:	e8 cf 20 00 00       	call   801051a0 <release>
      break;
    }
  }
}
801030d1:	83 c4 10             	add    $0x10,%esp
801030d4:	c9                   	leave  
801030d5:	c3                   	ret    
801030d6:	8d 76 00             	lea    0x0(%esi),%esi
801030d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	57                   	push   %edi
801030e4:	56                   	push   %esi
801030e5:	53                   	push   %ebx
801030e6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801030e9:	68 a0 46 11 80       	push   $0x801146a0
801030ee:	e8 8d 1f 00 00       	call   80105080 <acquire>
  log.outstanding -= 1;
801030f3:	a1 dc 46 11 80       	mov    0x801146dc,%eax
  if(log.committing)
801030f8:	8b 35 e0 46 11 80    	mov    0x801146e0,%esi
801030fe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103101:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103104:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103106:	89 1d dc 46 11 80    	mov    %ebx,0x801146dc
  if(log.committing)
8010310c:	0f 85 1a 01 00 00    	jne    8010322c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103112:	85 db                	test   %ebx,%ebx
80103114:	0f 85 ee 00 00 00    	jne    80103208 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010311a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010311d:	c7 05 e0 46 11 80 01 	movl   $0x1,0x801146e0
80103124:	00 00 00 
  release(&log.lock);
80103127:	68 a0 46 11 80       	push   $0x801146a0
8010312c:	e8 6f 20 00 00       	call   801051a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103131:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80103137:	83 c4 10             	add    $0x10,%esp
8010313a:	85 c9                	test   %ecx,%ecx
8010313c:	0f 8e 85 00 00 00    	jle    801031c7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103142:	a1 d4 46 11 80       	mov    0x801146d4,%eax
80103147:	83 ec 08             	sub    $0x8,%esp
8010314a:	01 d8                	add    %ebx,%eax
8010314c:	83 c0 01             	add    $0x1,%eax
8010314f:	50                   	push   %eax
80103150:	ff 35 e4 46 11 80    	pushl  0x801146e4
80103156:	e8 75 cf ff ff       	call   801000d0 <bread>
8010315b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010315d:	58                   	pop    %eax
8010315e:	5a                   	pop    %edx
8010315f:	ff 34 9d ec 46 11 80 	pushl  -0x7feeb914(,%ebx,4)
80103166:	ff 35 e4 46 11 80    	pushl  0x801146e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010316c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010316f:	e8 5c cf ff ff       	call   801000d0 <bread>
80103174:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103176:	8d 40 5c             	lea    0x5c(%eax),%eax
80103179:	83 c4 0c             	add    $0xc,%esp
8010317c:	68 00 02 00 00       	push   $0x200
80103181:	50                   	push   %eax
80103182:	8d 46 5c             	lea    0x5c(%esi),%eax
80103185:	50                   	push   %eax
80103186:	e8 25 21 00 00       	call   801052b0 <memmove>
    bwrite(to);  // write the log
8010318b:	89 34 24             	mov    %esi,(%esp)
8010318e:	e8 0d d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103193:	89 3c 24             	mov    %edi,(%esp)
80103196:	e8 45 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010319b:	89 34 24             	mov    %esi,(%esp)
8010319e:	e8 3d d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801031a3:	83 c4 10             	add    $0x10,%esp
801031a6:	3b 1d e8 46 11 80    	cmp    0x801146e8,%ebx
801031ac:	7c 94                	jl     80103142 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801031ae:	e8 bd fd ff ff       	call   80102f70 <write_head>
    install_trans(); // Now install writes to home locations
801031b3:	e8 18 fd ff ff       	call   80102ed0 <install_trans>
    log.lh.n = 0;
801031b8:	c7 05 e8 46 11 80 00 	movl   $0x0,0x801146e8
801031bf:	00 00 00 
    write_head();    // Erase the transaction from the log
801031c2:	e8 a9 fd ff ff       	call   80102f70 <write_head>
    acquire(&log.lock);
801031c7:	83 ec 0c             	sub    $0xc,%esp
801031ca:	68 a0 46 11 80       	push   $0x801146a0
801031cf:	e8 ac 1e 00 00       	call   80105080 <acquire>
    wakeup(&log);
801031d4:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
    log.committing = 0;
801031db:	c7 05 e0 46 11 80 00 	movl   $0x0,0x801146e0
801031e2:	00 00 00 
    wakeup(&log);
801031e5:	e8 86 16 00 00       	call   80104870 <wakeup>
    release(&log.lock);
801031ea:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
801031f1:	e8 aa 1f 00 00       	call   801051a0 <release>
801031f6:	83 c4 10             	add    $0x10,%esp
}
801031f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fc:	5b                   	pop    %ebx
801031fd:	5e                   	pop    %esi
801031fe:	5f                   	pop    %edi
801031ff:	5d                   	pop    %ebp
80103200:	c3                   	ret    
80103201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103208:	83 ec 0c             	sub    $0xc,%esp
8010320b:	68 a0 46 11 80       	push   $0x801146a0
80103210:	e8 5b 16 00 00       	call   80104870 <wakeup>
  release(&log.lock);
80103215:	c7 04 24 a0 46 11 80 	movl   $0x801146a0,(%esp)
8010321c:	e8 7f 1f 00 00       	call   801051a0 <release>
80103221:	83 c4 10             	add    $0x10,%esp
}
80103224:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103227:	5b                   	pop    %ebx
80103228:	5e                   	pop    %esi
80103229:	5f                   	pop    %edi
8010322a:	5d                   	pop    %ebp
8010322b:	c3                   	ret    
    panic("log.committing");
8010322c:	83 ec 0c             	sub    $0xc,%esp
8010322f:	68 24 89 10 80       	push   $0x80108924
80103234:	e8 57 d1 ff ff       	call   80100390 <panic>
80103239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103240 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	53                   	push   %ebx
80103244:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103247:	8b 15 e8 46 11 80    	mov    0x801146e8,%edx
{
8010324d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103250:	83 fa 1d             	cmp    $0x1d,%edx
80103253:	0f 8f 9d 00 00 00    	jg     801032f6 <log_write+0xb6>
80103259:	a1 d8 46 11 80       	mov    0x801146d8,%eax
8010325e:	83 e8 01             	sub    $0x1,%eax
80103261:	39 c2                	cmp    %eax,%edx
80103263:	0f 8d 8d 00 00 00    	jge    801032f6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103269:	a1 dc 46 11 80       	mov    0x801146dc,%eax
8010326e:	85 c0                	test   %eax,%eax
80103270:	0f 8e 8d 00 00 00    	jle    80103303 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	68 a0 46 11 80       	push   $0x801146a0
8010327e:	e8 fd 1d 00 00       	call   80105080 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103283:	8b 0d e8 46 11 80    	mov    0x801146e8,%ecx
80103289:	83 c4 10             	add    $0x10,%esp
8010328c:	83 f9 00             	cmp    $0x0,%ecx
8010328f:	7e 57                	jle    801032e8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103291:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103294:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103296:	3b 15 ec 46 11 80    	cmp    0x801146ec,%edx
8010329c:	75 0b                	jne    801032a9 <log_write+0x69>
8010329e:	eb 38                	jmp    801032d8 <log_write+0x98>
801032a0:	39 14 85 ec 46 11 80 	cmp    %edx,-0x7feeb914(,%eax,4)
801032a7:	74 2f                	je     801032d8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801032a9:	83 c0 01             	add    $0x1,%eax
801032ac:	39 c1                	cmp    %eax,%ecx
801032ae:	75 f0                	jne    801032a0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801032b0:	89 14 85 ec 46 11 80 	mov    %edx,-0x7feeb914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801032b7:	83 c0 01             	add    $0x1,%eax
801032ba:	a3 e8 46 11 80       	mov    %eax,0x801146e8
  b->flags |= B_DIRTY; // prevent eviction
801032bf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801032c2:	c7 45 08 a0 46 11 80 	movl   $0x801146a0,0x8(%ebp)
}
801032c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032cc:	c9                   	leave  
  release(&log.lock);
801032cd:	e9 ce 1e 00 00       	jmp    801051a0 <release>
801032d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801032d8:	89 14 85 ec 46 11 80 	mov    %edx,-0x7feeb914(,%eax,4)
801032df:	eb de                	jmp    801032bf <log_write+0x7f>
801032e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032e8:	8b 43 08             	mov    0x8(%ebx),%eax
801032eb:	a3 ec 46 11 80       	mov    %eax,0x801146ec
  if (i == log.lh.n)
801032f0:	75 cd                	jne    801032bf <log_write+0x7f>
801032f2:	31 c0                	xor    %eax,%eax
801032f4:	eb c1                	jmp    801032b7 <log_write+0x77>
    panic("too big a transaction");
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	68 33 89 10 80       	push   $0x80108933
801032fe:	e8 8d d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103303:	83 ec 0c             	sub    $0xc,%esp
80103306:	68 49 89 10 80       	push   $0x80108949
8010330b:	e8 80 d0 ff ff       	call   80100390 <panic>

80103310 <mpmain>:
  mpmain();
}

// Common CPU setup code.
static void
mpmain(void) {
80103310:	55                   	push   %ebp
80103311:	89 e5                	mov    %esp,%ebp
80103313:	53                   	push   %ebx
80103314:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103317:	e8 34 0a 00 00       	call   80103d50 <cpuid>
8010331c:	89 c3                	mov    %eax,%ebx
8010331e:	e8 2d 0a 00 00       	call   80103d50 <cpuid>
80103323:	83 ec 04             	sub    $0x4,%esp
80103326:	53                   	push   %ebx
80103327:	50                   	push   %eax
80103328:	68 64 89 10 80       	push   $0x80108964
8010332d:	e8 2e d3 ff ff       	call   80100660 <cprintf>
    idtinit();       // load idt register
80103332:	e8 39 33 00 00       	call   80106670 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103337:	e8 94 09 00 00       	call   80103cd0 <mycpu>
8010333c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010333e:	b8 01 00 00 00       	mov    $0x1,%eax
80103343:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
8010334a:	e8 b1 0f 00 00       	call   80104300 <scheduler>
8010334f:	90                   	nop

80103350 <mpenter>:
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103356:	e8 85 46 00 00       	call   801079e0 <switchkvm>
  seginit();
8010335b:	e8 b0 45 00 00       	call   80107910 <seginit>
  lapicinit();
80103360:	e8 9b f7 ff ff       	call   80102b00 <lapicinit>
  mpmain();
80103365:	e8 a6 ff ff ff       	call   80103310 <mpmain>
8010336a:	66 90                	xchg   %ax,%ax
8010336c:	66 90                	xchg   %ax,%ax
8010336e:	66 90                	xchg   %ax,%ax

80103370 <main>:
{
80103370:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103374:	83 e4 f0             	and    $0xfffffff0,%esp
80103377:	ff 71 fc             	pushl  -0x4(%ecx)
8010337a:	55                   	push   %ebp
8010337b:	89 e5                	mov    %esp,%ebp
8010337d:	53                   	push   %ebx
8010337e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010337f:	83 ec 08             	sub    $0x8,%esp
80103382:	68 00 00 40 80       	push   $0x80400000
80103387:	68 ec 7c 12 80       	push   $0x80127cec
8010338c:	e8 2f f5 ff ff       	call   801028c0 <kinit1>
  kvmalloc();      // kernel page table
80103391:	e8 8a 4e 00 00       	call   80108220 <kvmalloc>
  mpinit();        // detect other processors
80103396:	e8 75 01 00 00       	call   80103510 <mpinit>
  lapicinit();     // interrupt controller
8010339b:	e8 60 f7 ff ff       	call   80102b00 <lapicinit>
  seginit();       // segment descriptors
801033a0:	e8 6b 45 00 00       	call   80107910 <seginit>
  picinit();       // disable pic
801033a5:	e8 46 03 00 00       	call   801036f0 <picinit>
  ioapicinit();    // another interrupt controller
801033aa:	e8 c1 f2 ff ff       	call   80102670 <ioapicinit>
  consoleinit();   // console hardware
801033af:	e8 0c d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801033b4:	e8 c7 38 00 00       	call   80106c80 <uartinit>
  pinit();         // process table
801033b9:	e8 f2 08 00 00       	call   80103cb0 <pinit>
  tvinit();        // trap vectors
801033be:	e8 2d 32 00 00       	call   801065f0 <tvinit>
  binit();         // buffer cache
801033c3:	e8 78 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801033c8:	e8 43 da ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801033cd:	e8 7e f0 ff ff       	call   80102450 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801033d2:	83 c4 0c             	add    $0xc,%esp
801033d5:	68 8a 00 00 00       	push   $0x8a
801033da:	68 8c c4 10 80       	push   $0x8010c48c
801033df:	68 00 70 00 80       	push   $0x80007000
801033e4:	e8 c7 1e 00 00       	call   801052b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801033e9:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
801033f0:	00 00 00 
801033f3:	83 c4 10             	add    $0x10,%esp
801033f6:	05 a0 47 11 80       	add    $0x801147a0,%eax
801033fb:	3d a0 47 11 80       	cmp    $0x801147a0,%eax
80103400:	76 71                	jbe    80103473 <main+0x103>
80103402:	bb a0 47 11 80       	mov    $0x801147a0,%ebx
80103407:	89 f6                	mov    %esi,%esi
80103409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103410:	e8 bb 08 00 00       	call   80103cd0 <mycpu>
80103415:	39 d8                	cmp    %ebx,%eax
80103417:	74 41                	je     8010345a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103419:	e8 72 f5 ff ff       	call   80102990 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010341e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80103423:	c7 05 f8 6f 00 80 50 	movl   $0x80103350,0x80006ff8
8010342a:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010342d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103434:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103437:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010343c:	0f b6 03             	movzbl (%ebx),%eax
8010343f:	83 ec 08             	sub    $0x8,%esp
80103442:	68 00 70 00 00       	push   $0x7000
80103447:	50                   	push   %eax
80103448:	e8 03 f8 ff ff       	call   80102c50 <lapicstartap>
8010344d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103450:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103456:	85 c0                	test   %eax,%eax
80103458:	74 f6                	je     80103450 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010345a:	69 05 20 4d 11 80 b0 	imul   $0xb0,0x80114d20,%eax
80103461:	00 00 00 
80103464:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010346a:	05 a0 47 11 80       	add    $0x801147a0,%eax
8010346f:	39 c3                	cmp    %eax,%ebx
80103471:	72 9d                	jb     80103410 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103473:	83 ec 08             	sub    $0x8,%esp
80103476:	68 00 00 00 8e       	push   $0x8e000000
8010347b:	68 00 00 40 80       	push   $0x80400000
80103480:	e8 ab f4 ff ff       	call   80102930 <kinit2>
  userinit();      // first user process
80103485:	e8 16 0a 00 00       	call   80103ea0 <userinit>
  mpmain();        // finish this processor's setup
8010348a:	e8 81 fe ff ff       	call   80103310 <mpmain>
8010348f:	90                   	nop

80103490 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103495:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010349b:	53                   	push   %ebx
  e = addr+len;
8010349c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010349f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801034a2:	39 de                	cmp    %ebx,%esi
801034a4:	72 10                	jb     801034b6 <mpsearch1+0x26>
801034a6:	eb 50                	jmp    801034f8 <mpsearch1+0x68>
801034a8:	90                   	nop
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034b0:	39 fb                	cmp    %edi,%ebx
801034b2:	89 fe                	mov    %edi,%esi
801034b4:	76 42                	jbe    801034f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034b6:	83 ec 04             	sub    $0x4,%esp
801034b9:	8d 7e 10             	lea    0x10(%esi),%edi
801034bc:	6a 04                	push   $0x4
801034be:	68 78 89 10 80       	push   $0x80108978
801034c3:	56                   	push   %esi
801034c4:	e8 87 1d 00 00       	call   80105250 <memcmp>
801034c9:	83 c4 10             	add    $0x10,%esp
801034cc:	85 c0                	test   %eax,%eax
801034ce:	75 e0                	jne    801034b0 <mpsearch1+0x20>
801034d0:	89 f1                	mov    %esi,%ecx
801034d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801034d8:	0f b6 11             	movzbl (%ecx),%edx
801034db:	83 c1 01             	add    $0x1,%ecx
801034de:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801034e0:	39 f9                	cmp    %edi,%ecx
801034e2:	75 f4                	jne    801034d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034e4:	84 c0                	test   %al,%al
801034e6:	75 c8                	jne    801034b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801034e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034eb:	89 f0                	mov    %esi,%eax
801034ed:	5b                   	pop    %ebx
801034ee:	5e                   	pop    %esi
801034ef:	5f                   	pop    %edi
801034f0:	5d                   	pop    %ebp
801034f1:	c3                   	ret    
801034f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034fb:	31 f6                	xor    %esi,%esi
}
801034fd:	89 f0                	mov    %esi,%eax
801034ff:	5b                   	pop    %ebx
80103500:	5e                   	pop    %esi
80103501:	5f                   	pop    %edi
80103502:	5d                   	pop    %ebp
80103503:	c3                   	ret    
80103504:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010350a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103510 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103519:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103520:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103527:	c1 e0 08             	shl    $0x8,%eax
8010352a:	09 d0                	or     %edx,%eax
8010352c:	c1 e0 04             	shl    $0x4,%eax
8010352f:	85 c0                	test   %eax,%eax
80103531:	75 1b                	jne    8010354e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103533:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010353a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103541:	c1 e0 08             	shl    $0x8,%eax
80103544:	09 d0                	or     %edx,%eax
80103546:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103549:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010354e:	ba 00 04 00 00       	mov    $0x400,%edx
80103553:	e8 38 ff ff ff       	call   80103490 <mpsearch1>
80103558:	85 c0                	test   %eax,%eax
8010355a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010355d:	0f 84 3d 01 00 00    	je     801036a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103566:	8b 58 04             	mov    0x4(%eax),%ebx
80103569:	85 db                	test   %ebx,%ebx
8010356b:	0f 84 4f 01 00 00    	je     801036c0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103571:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103577:	83 ec 04             	sub    $0x4,%esp
8010357a:	6a 04                	push   $0x4
8010357c:	68 95 89 10 80       	push   $0x80108995
80103581:	56                   	push   %esi
80103582:	e8 c9 1c 00 00       	call   80105250 <memcmp>
80103587:	83 c4 10             	add    $0x10,%esp
8010358a:	85 c0                	test   %eax,%eax
8010358c:	0f 85 2e 01 00 00    	jne    801036c0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103592:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103599:	3c 01                	cmp    $0x1,%al
8010359b:	0f 95 c2             	setne  %dl
8010359e:	3c 04                	cmp    $0x4,%al
801035a0:	0f 95 c0             	setne  %al
801035a3:	20 c2                	and    %al,%dl
801035a5:	0f 85 15 01 00 00    	jne    801036c0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801035ab:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801035b2:	66 85 ff             	test   %di,%di
801035b5:	74 1a                	je     801035d1 <mpinit+0xc1>
801035b7:	89 f0                	mov    %esi,%eax
801035b9:	01 f7                	add    %esi,%edi
  sum = 0;
801035bb:	31 d2                	xor    %edx,%edx
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035c0:	0f b6 08             	movzbl (%eax),%ecx
801035c3:	83 c0 01             	add    $0x1,%eax
801035c6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035c8:	39 c7                	cmp    %eax,%edi
801035ca:	75 f4                	jne    801035c0 <mpinit+0xb0>
801035cc:	84 d2                	test   %dl,%dl
801035ce:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801035d1:	85 f6                	test   %esi,%esi
801035d3:	0f 84 e7 00 00 00    	je     801036c0 <mpinit+0x1b0>
801035d9:	84 d2                	test   %dl,%dl
801035db:	0f 85 df 00 00 00    	jne    801036c0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801035e1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801035e7:	a3 9c 46 11 80       	mov    %eax,0x8011469c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035ec:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801035f3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801035f9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035fe:	01 d6                	add    %edx,%esi
80103600:	39 c6                	cmp    %eax,%esi
80103602:	76 23                	jbe    80103627 <mpinit+0x117>
    switch(*p){
80103604:	0f b6 10             	movzbl (%eax),%edx
80103607:	80 fa 04             	cmp    $0x4,%dl
8010360a:	0f 87 ca 00 00 00    	ja     801036da <mpinit+0x1ca>
80103610:	ff 24 95 bc 89 10 80 	jmp    *-0x7fef7644(,%edx,4)
80103617:	89 f6                	mov    %esi,%esi
80103619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103620:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103623:	39 c6                	cmp    %eax,%esi
80103625:	77 dd                	ja     80103604 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103627:	85 db                	test   %ebx,%ebx
80103629:	0f 84 9e 00 00 00    	je     801036cd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010362f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103632:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103636:	74 15                	je     8010364d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103638:	b8 70 00 00 00       	mov    $0x70,%eax
8010363d:	ba 22 00 00 00       	mov    $0x22,%edx
80103642:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103643:	ba 23 00 00 00       	mov    $0x23,%edx
80103648:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103649:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010364c:	ee                   	out    %al,(%dx)
  }
}
8010364d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103650:	5b                   	pop    %ebx
80103651:	5e                   	pop    %esi
80103652:	5f                   	pop    %edi
80103653:	5d                   	pop    %ebp
80103654:	c3                   	ret    
80103655:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103658:	8b 0d 20 4d 11 80    	mov    0x80114d20,%ecx
8010365e:	83 f9 07             	cmp    $0x7,%ecx
80103661:	7f 19                	jg     8010367c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103663:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103667:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010366d:	83 c1 01             	add    $0x1,%ecx
80103670:	89 0d 20 4d 11 80    	mov    %ecx,0x80114d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103676:	88 97 a0 47 11 80    	mov    %dl,-0x7feeb860(%edi)
      p += sizeof(struct mpproc);
8010367c:	83 c0 14             	add    $0x14,%eax
      continue;
8010367f:	e9 7c ff ff ff       	jmp    80103600 <mpinit+0xf0>
80103684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103688:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010368c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010368f:	88 15 80 47 11 80    	mov    %dl,0x80114780
      continue;
80103695:	e9 66 ff ff ff       	jmp    80103600 <mpinit+0xf0>
8010369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801036a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801036a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801036aa:	e8 e1 fd ff ff       	call   80103490 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036af:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801036b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036b4:	0f 85 a9 fe ff ff    	jne    80103563 <mpinit+0x53>
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	68 7d 89 10 80       	push   $0x8010897d
801036c8:	e8 c3 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801036cd:	83 ec 0c             	sub    $0xc,%esp
801036d0:	68 9c 89 10 80       	push   $0x8010899c
801036d5:	e8 b6 cc ff ff       	call   80100390 <panic>
      ismp = 0;
801036da:	31 db                	xor    %ebx,%ebx
801036dc:	e9 26 ff ff ff       	jmp    80103607 <mpinit+0xf7>
801036e1:	66 90                	xchg   %ax,%ax
801036e3:	66 90                	xchg   %ax,%ax
801036e5:	66 90                	xchg   %ax,%ax
801036e7:	66 90                	xchg   %ax,%ax
801036e9:	66 90                	xchg   %ax,%ax
801036eb:	66 90                	xchg   %ax,%ax
801036ed:	66 90                	xchg   %ax,%ax
801036ef:	90                   	nop

801036f0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801036f0:	55                   	push   %ebp
801036f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036f6:	ba 21 00 00 00       	mov    $0x21,%edx
801036fb:	89 e5                	mov    %esp,%ebp
801036fd:	ee                   	out    %al,(%dx)
801036fe:	ba a1 00 00 00       	mov    $0xa1,%edx
80103703:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103704:	5d                   	pop    %ebp
80103705:	c3                   	ret    
80103706:	66 90                	xchg   %ax,%ax
80103708:	66 90                	xchg   %ax,%ax
8010370a:	66 90                	xchg   %ax,%ax
8010370c:	66 90                	xchg   %ax,%ax
8010370e:	66 90                	xchg   %ax,%ax

80103710 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	57                   	push   %edi
80103714:	56                   	push   %esi
80103715:	53                   	push   %ebx
80103716:	83 ec 0c             	sub    $0xc,%esp
80103719:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010371c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010371f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103725:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010372b:	e8 00 d7 ff ff       	call   80100e30 <filealloc>
80103730:	85 c0                	test   %eax,%eax
80103732:	89 03                	mov    %eax,(%ebx)
80103734:	74 22                	je     80103758 <pipealloc+0x48>
80103736:	e8 f5 d6 ff ff       	call   80100e30 <filealloc>
8010373b:	85 c0                	test   %eax,%eax
8010373d:	89 06                	mov    %eax,(%esi)
8010373f:	74 3f                	je     80103780 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103741:	e8 4a f2 ff ff       	call   80102990 <kalloc>
80103746:	85 c0                	test   %eax,%eax
80103748:	89 c7                	mov    %eax,%edi
8010374a:	75 54                	jne    801037a0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010374c:	8b 03                	mov    (%ebx),%eax
8010374e:	85 c0                	test   %eax,%eax
80103750:	75 34                	jne    80103786 <pipealloc+0x76>
80103752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103758:	8b 06                	mov    (%esi),%eax
8010375a:	85 c0                	test   %eax,%eax
8010375c:	74 0c                	je     8010376a <pipealloc+0x5a>
    fileclose(*f1);
8010375e:	83 ec 0c             	sub    $0xc,%esp
80103761:	50                   	push   %eax
80103762:	e8 89 d7 ff ff       	call   80100ef0 <fileclose>
80103767:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010376a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010376d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103772:	5b                   	pop    %ebx
80103773:	5e                   	pop    %esi
80103774:	5f                   	pop    %edi
80103775:	5d                   	pop    %ebp
80103776:	c3                   	ret    
80103777:	89 f6                	mov    %esi,%esi
80103779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103780:	8b 03                	mov    (%ebx),%eax
80103782:	85 c0                	test   %eax,%eax
80103784:	74 e4                	je     8010376a <pipealloc+0x5a>
    fileclose(*f0);
80103786:	83 ec 0c             	sub    $0xc,%esp
80103789:	50                   	push   %eax
8010378a:	e8 61 d7 ff ff       	call   80100ef0 <fileclose>
  if(*f1)
8010378f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103791:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103794:	85 c0                	test   %eax,%eax
80103796:	75 c6                	jne    8010375e <pipealloc+0x4e>
80103798:	eb d0                	jmp    8010376a <pipealloc+0x5a>
8010379a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801037a0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801037a3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801037aa:	00 00 00 
  p->writeopen = 1;
801037ad:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037b4:	00 00 00 
  p->nwrite = 0;
801037b7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037be:	00 00 00 
  p->nread = 0;
801037c1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037c8:	00 00 00 
  initlock(&p->lock, "pipe");
801037cb:	68 d0 89 10 80       	push   $0x801089d0
801037d0:	50                   	push   %eax
801037d1:	e8 ba 17 00 00       	call   80104f90 <initlock>
  (*f0)->type = FD_PIPE;
801037d6:	8b 03                	mov    (%ebx),%eax
  return 0;
801037d8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037db:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037e1:	8b 03                	mov    (%ebx),%eax
801037e3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801037e7:	8b 03                	mov    (%ebx),%eax
801037e9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801037ed:	8b 03                	mov    (%ebx),%eax
801037ef:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801037f2:	8b 06                	mov    (%esi),%eax
801037f4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801037fa:	8b 06                	mov    (%esi),%eax
801037fc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103800:	8b 06                	mov    (%esi),%eax
80103802:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103806:	8b 06                	mov    (%esi),%eax
80103808:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010380b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010380e:	31 c0                	xor    %eax,%eax
}
80103810:	5b                   	pop    %ebx
80103811:	5e                   	pop    %esi
80103812:	5f                   	pop    %edi
80103813:	5d                   	pop    %ebp
80103814:	c3                   	ret    
80103815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103820 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103828:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010382b:	83 ec 0c             	sub    $0xc,%esp
8010382e:	53                   	push   %ebx
8010382f:	e8 4c 18 00 00       	call   80105080 <acquire>
  if(writable){
80103834:	83 c4 10             	add    $0x10,%esp
80103837:	85 f6                	test   %esi,%esi
80103839:	74 45                	je     80103880 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010383b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103841:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103844:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010384b:	00 00 00 
    wakeup(&p->nread);
8010384e:	50                   	push   %eax
8010384f:	e8 1c 10 00 00       	call   80104870 <wakeup>
80103854:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103857:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010385d:	85 d2                	test   %edx,%edx
8010385f:	75 0a                	jne    8010386b <pipeclose+0x4b>
80103861:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103867:	85 c0                	test   %eax,%eax
80103869:	74 35                	je     801038a0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010386b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010386e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103871:	5b                   	pop    %ebx
80103872:	5e                   	pop    %esi
80103873:	5d                   	pop    %ebp
    release(&p->lock);
80103874:	e9 27 19 00 00       	jmp    801051a0 <release>
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103880:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103886:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103889:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103890:	00 00 00 
    wakeup(&p->nwrite);
80103893:	50                   	push   %eax
80103894:	e8 d7 0f 00 00       	call   80104870 <wakeup>
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	eb b9                	jmp    80103857 <pipeclose+0x37>
8010389e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	53                   	push   %ebx
801038a4:	e8 f7 18 00 00       	call   801051a0 <release>
    kfree((char*)p);
801038a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801038ac:	83 c4 10             	add    $0x10,%esp
}
801038af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038b2:	5b                   	pop    %ebx
801038b3:	5e                   	pop    %esi
801038b4:	5d                   	pop    %ebp
    kfree((char*)p);
801038b5:	e9 26 ef ff ff       	jmp    801027e0 <kfree>
801038ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	57                   	push   %edi
801038c4:	56                   	push   %esi
801038c5:	53                   	push   %ebx
801038c6:	83 ec 28             	sub    $0x28,%esp
801038c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801038cc:	53                   	push   %ebx
801038cd:	e8 ae 17 00 00       	call   80105080 <acquire>
  for(i = 0; i < n; i++){
801038d2:	8b 45 10             	mov    0x10(%ebp),%eax
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	85 c0                	test   %eax,%eax
801038da:	0f 8e c9 00 00 00    	jle    801039a9 <pipewrite+0xe9>
801038e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801038e3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801038e9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801038ef:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801038f2:	03 4d 10             	add    0x10(%ebp),%ecx
801038f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038f8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801038fe:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103904:	39 d0                	cmp    %edx,%eax
80103906:	75 71                	jne    80103979 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103908:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010390e:	85 c0                	test   %eax,%eax
80103910:	74 4e                	je     80103960 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103912:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103918:	eb 3a                	jmp    80103954 <pipewrite+0x94>
8010391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103920:	83 ec 0c             	sub    $0xc,%esp
80103923:	57                   	push   %edi
80103924:	e8 47 0f 00 00       	call   80104870 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103929:	5a                   	pop    %edx
8010392a:	59                   	pop    %ecx
8010392b:	53                   	push   %ebx
8010392c:	56                   	push   %esi
8010392d:	e8 ce 0c 00 00       	call   80104600 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103932:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103938:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010393e:	83 c4 10             	add    $0x10,%esp
80103941:	05 00 02 00 00       	add    $0x200,%eax
80103946:	39 c2                	cmp    %eax,%edx
80103948:	75 36                	jne    80103980 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010394a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103950:	85 c0                	test   %eax,%eax
80103952:	74 0c                	je     80103960 <pipewrite+0xa0>
80103954:	e8 47 04 00 00       	call   80103da0 <myproc>
80103959:	8b 40 24             	mov    0x24(%eax),%eax
8010395c:	85 c0                	test   %eax,%eax
8010395e:	74 c0                	je     80103920 <pipewrite+0x60>
        release(&p->lock);
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	53                   	push   %ebx
80103964:	e8 37 18 00 00       	call   801051a0 <release>
        return -1;
80103969:	83 c4 10             	add    $0x10,%esp
8010396c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103971:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103974:	5b                   	pop    %ebx
80103975:	5e                   	pop    %esi
80103976:	5f                   	pop    %edi
80103977:	5d                   	pop    %ebp
80103978:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103979:	89 c2                	mov    %eax,%edx
8010397b:	90                   	nop
8010397c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103980:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103983:	8d 42 01             	lea    0x1(%edx),%eax
80103986:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010398c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103992:	83 c6 01             	add    $0x1,%esi
80103995:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103999:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010399c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010399f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801039a3:	0f 85 4f ff ff ff    	jne    801038f8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801039a9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039af:	83 ec 0c             	sub    $0xc,%esp
801039b2:	50                   	push   %eax
801039b3:	e8 b8 0e 00 00       	call   80104870 <wakeup>
  release(&p->lock);
801039b8:	89 1c 24             	mov    %ebx,(%esp)
801039bb:	e8 e0 17 00 00       	call   801051a0 <release>
  return n;
801039c0:	83 c4 10             	add    $0x10,%esp
801039c3:	8b 45 10             	mov    0x10(%ebp),%eax
801039c6:	eb a9                	jmp    80103971 <pipewrite+0xb1>
801039c8:	90                   	nop
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	57                   	push   %edi
801039d4:	56                   	push   %esi
801039d5:	53                   	push   %ebx
801039d6:	83 ec 18             	sub    $0x18,%esp
801039d9:	8b 75 08             	mov    0x8(%ebp),%esi
801039dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801039df:	56                   	push   %esi
801039e0:	e8 9b 16 00 00       	call   80105080 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039e5:	83 c4 10             	add    $0x10,%esp
801039e8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039ee:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039f4:	75 6a                	jne    80103a60 <piperead+0x90>
801039f6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801039fc:	85 db                	test   %ebx,%ebx
801039fe:	0f 84 c4 00 00 00    	je     80103ac8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103a04:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103a0a:	eb 2d                	jmp    80103a39 <piperead+0x69>
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a10:	83 ec 08             	sub    $0x8,%esp
80103a13:	56                   	push   %esi
80103a14:	53                   	push   %ebx
80103a15:	e8 e6 0b 00 00       	call   80104600 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a1a:	83 c4 10             	add    $0x10,%esp
80103a1d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a23:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a29:	75 35                	jne    80103a60 <piperead+0x90>
80103a2b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103a31:	85 d2                	test   %edx,%edx
80103a33:	0f 84 8f 00 00 00    	je     80103ac8 <piperead+0xf8>
    if(myproc()->killed){
80103a39:	e8 62 03 00 00       	call   80103da0 <myproc>
80103a3e:	8b 48 24             	mov    0x24(%eax),%ecx
80103a41:	85 c9                	test   %ecx,%ecx
80103a43:	74 cb                	je     80103a10 <piperead+0x40>
      release(&p->lock);
80103a45:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103a48:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103a4d:	56                   	push   %esi
80103a4e:	e8 4d 17 00 00       	call   801051a0 <release>
      return -1;
80103a53:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103a56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a59:	89 d8                	mov    %ebx,%eax
80103a5b:	5b                   	pop    %ebx
80103a5c:	5e                   	pop    %esi
80103a5d:	5f                   	pop    %edi
80103a5e:	5d                   	pop    %ebp
80103a5f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a60:	8b 45 10             	mov    0x10(%ebp),%eax
80103a63:	85 c0                	test   %eax,%eax
80103a65:	7e 61                	jle    80103ac8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103a67:	31 db                	xor    %ebx,%ebx
80103a69:	eb 13                	jmp    80103a7e <piperead+0xae>
80103a6b:	90                   	nop
80103a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a70:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a76:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a7c:	74 1f                	je     80103a9d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a7e:	8d 41 01             	lea    0x1(%ecx),%eax
80103a81:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103a87:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103a8d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103a92:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a95:	83 c3 01             	add    $0x1,%ebx
80103a98:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a9b:	75 d3                	jne    80103a70 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a9d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103aa3:	83 ec 0c             	sub    $0xc,%esp
80103aa6:	50                   	push   %eax
80103aa7:	e8 c4 0d 00 00       	call   80104870 <wakeup>
  release(&p->lock);
80103aac:	89 34 24             	mov    %esi,(%esp)
80103aaf:	e8 ec 16 00 00       	call   801051a0 <release>
  return i;
80103ab4:	83 c4 10             	add    $0x10,%esp
}
80103ab7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aba:	89 d8                	mov    %ebx,%eax
80103abc:	5b                   	pop    %ebx
80103abd:	5e                   	pop    %esi
80103abe:	5f                   	pop    %edi
80103abf:	5d                   	pop    %ebp
80103ac0:	c3                   	ret    
80103ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ac8:	31 db                	xor    %ebx,%ebx
80103aca:	eb d1                	jmp    80103a9d <piperead+0xcd>
80103acc:	66 90                	xchg   %ax,%ax
80103ace:	66 90                	xchg   %ax,%ax

80103ad0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	53                   	push   %ebx
#endif


    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ad4:	bb 74 5d 11 80       	mov    $0x80115d74,%ebx
allocproc(void) {
80103ad9:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80103adc:	68 40 5d 11 80       	push   $0x80115d40
80103ae1:	e8 9a 15 00 00       	call   80105080 <acquire>
80103ae6:	83 c4 10             	add    $0x10,%esp
80103ae9:	eb 17                	jmp    80103b02 <allocproc+0x32>
80103aeb:	90                   	nop
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103af0:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
80103af6:	81 fb 74 74 12 80    	cmp    $0x80127474,%ebx
80103afc:	0f 83 2e 01 00 00    	jae    80103c30 <allocproc+0x160>
        if (p->state == UNUSED)
80103b02:	8b 43 0c             	mov    0xc(%ebx),%eax
80103b05:	85 c0                	test   %eax,%eax
80103b07:	75 e7                	jne    80103af0 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103b09:	a1 04 c0 10 80       	mov    0x8010c004,%eax

    release(&ptable.lock);
80103b0e:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
80103b11:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80103b18:	8d 50 01             	lea    0x1(%eax),%edx
80103b1b:	89 43 10             	mov    %eax,0x10(%ebx)
    release(&ptable.lock);
80103b1e:	68 40 5d 11 80       	push   $0x80115d40
    p->pid = nextpid++;
80103b23:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
    release(&ptable.lock);
80103b29:	e8 72 16 00 00       	call   801051a0 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
80103b2e:	e8 5d ee ff ff       	call   80102990 <kalloc>
80103b33:	83 c4 10             	add    $0x10,%esp
80103b36:	85 c0                	test   %eax,%eax
80103b38:	89 43 08             	mov    %eax,0x8(%ebx)
80103b3b:	0f 84 08 01 00 00    	je     80103c49 <allocproc+0x179>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103b41:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
80103b47:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103b4a:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103b4f:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint *) sp = (uint) trapret;
80103b52:	c7 40 14 df 65 10 80 	movl   $0x801065df,0x14(%eax)
    p->context = (struct context *) sp;
80103b59:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103b5c:	6a 14                	push   $0x14
80103b5e:	6a 00                	push   $0x0
80103b60:	50                   	push   %eax
80103b61:	e8 9a 16 00 00       	call   80105200 <memset>
    p->context->eip = (uint) forkret;
80103b66:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103b69:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
80103b6f:	8d 93 40 04 00 00    	lea    0x440(%ebx),%edx
80103b75:	83 c4 10             	add    $0x10,%esp
80103b78:	c7 40 10 60 3c 10 80 	movl   $0x80103c60,0x10(%eax)

    //TODO INIT PROC PAGES FIELDS
#if(defined(LIFO) || defined(SCFIFO))
    p->pagesCounter = 0;
80103b7f:	c7 83 44 04 00 00 00 	movl   $0x0,0x444(%ebx)
80103b86:	00 00 00 
80103b89:	89 c8                	mov    %ecx,%eax
    p->nextpageid = 1;
80103b8b:	c7 83 40 04 00 00 01 	movl   $0x1,0x440(%ebx)
80103b92:	00 00 00 
    p->pagesequel = 0;
80103b95:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
80103b9c:	00 00 00 
    p->pagesinSwap = 0;
80103b9f:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
80103ba6:	00 00 00 

    p->protectedPages = 0;
80103ba9:	c7 83 50 04 00 00 00 	movl   $0x0,0x450(%ebx)
80103bb0:	00 00 00 
    p->pageFaults = 0;
80103bb3:	c7 83 54 04 00 00 00 	movl   $0x0,0x454(%ebx)
80103bba:	00 00 00 
    p->totalPagesInSwap = 0;
80103bbd:	c7 83 58 04 00 00 00 	movl   $0x0,0x458(%ebx)
80103bc4:	00 00 00 
80103bc7:	89 f6                	mov    %esi,%esi
80103bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;
80103bd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103bd6:	83 c0 04             	add    $0x4,%eax
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103bd9:	39 d0                	cmp    %edx,%eax
80103bdb:	75 f3                	jne    80103bd0 <allocproc+0x100>

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103bdd:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103be3:	90                   	nop
80103be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
        pg->active = 0;
80103be8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        pg->pageid = 0;
80103bee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103bf5:	83 c0 1c             	add    $0x1c,%eax
        pg->sequel = 0;
80103bf8:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
        pg->present = 0;
80103bff:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
        pg->offset = 0;
80103c06:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
        pg->physAdress = 0;
80103c0d:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        pg->virtAdress = 0;
80103c14:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103c1b:	39 c8                	cmp    %ecx,%eax
80103c1d:	72 c9                	jb     80103be8 <allocproc+0x118>
    }
#endif

    return p;
}
80103c1f:	89 d8                	mov    %ebx,%eax
80103c21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c24:	c9                   	leave  
80103c25:	c3                   	ret    
80103c26:	8d 76 00             	lea    0x0(%esi),%esi
80103c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&ptable.lock);
80103c30:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80103c33:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
80103c35:	68 40 5d 11 80       	push   $0x80115d40
80103c3a:	e8 61 15 00 00       	call   801051a0 <release>
}
80103c3f:	89 d8                	mov    %ebx,%eax
    return 0;
80103c41:	83 c4 10             	add    $0x10,%esp
}
80103c44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c47:	c9                   	leave  
80103c48:	c3                   	ret    
        p->state = UNUSED;
80103c49:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103c50:	31 db                	xor    %ebx,%ebx
80103c52:	eb cb                	jmp    80103c1f <allocproc+0x14f>
80103c54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c60 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103c66:	68 40 5d 11 80       	push   $0x80115d40
80103c6b:	e8 30 15 00 00       	call   801051a0 <release>

    if (first) {
80103c70:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103c75:	83 c4 10             	add    $0x10,%esp
80103c78:	85 c0                	test   %eax,%eax
80103c7a:	75 04                	jne    80103c80 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103c7c:	c9                   	leave  
80103c7d:	c3                   	ret    
80103c7e:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
80103c80:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
80103c83:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103c8a:	00 00 00 
        iinit(ROOTDEV);
80103c8d:	6a 01                	push   $0x1
80103c8f:	e8 ac d8 ff ff       	call   80101540 <iinit>
        initlog(ROOTDEV);
80103c94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c9b:	e8 30 f3 ff ff       	call   80102fd0 <initlog>
80103ca0:	83 c4 10             	add    $0x10,%esp
}
80103ca3:	c9                   	leave  
80103ca4:	c3                   	ret    
80103ca5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cb0 <pinit>:
pinit(void) {
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103cb6:	68 d5 89 10 80       	push   $0x801089d5
80103cbb:	68 40 5d 11 80       	push   $0x80115d40
80103cc0:	e8 cb 12 00 00       	call   80104f90 <initlock>
}
80103cc5:	83 c4 10             	add    $0x10,%esp
80103cc8:	c9                   	leave  
80103cc9:	c3                   	ret    
80103cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cd0 <mycpu>:
mycpu(void) {
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	56                   	push   %esi
80103cd4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cd5:	9c                   	pushf  
80103cd6:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103cd7:	f6 c4 02             	test   $0x2,%ah
80103cda:	75 5e                	jne    80103d3a <mycpu+0x6a>
    apicid = lapicid();
80103cdc:	e8 1f ef ff ff       	call   80102c00 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103ce1:	8b 35 20 4d 11 80    	mov    0x80114d20,%esi
80103ce7:	85 f6                	test   %esi,%esi
80103ce9:	7e 42                	jle    80103d2d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103ceb:	0f b6 15 a0 47 11 80 	movzbl 0x801147a0,%edx
80103cf2:	39 d0                	cmp    %edx,%eax
80103cf4:	74 30                	je     80103d26 <mycpu+0x56>
80103cf6:	b9 50 48 11 80       	mov    $0x80114850,%ecx
    for (i = 0; i < ncpu; ++i) {
80103cfb:	31 d2                	xor    %edx,%edx
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi
80103d00:	83 c2 01             	add    $0x1,%edx
80103d03:	39 f2                	cmp    %esi,%edx
80103d05:	74 26                	je     80103d2d <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103d07:	0f b6 19             	movzbl (%ecx),%ebx
80103d0a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103d10:	39 c3                	cmp    %eax,%ebx
80103d12:	75 ec                	jne    80103d00 <mycpu+0x30>
80103d14:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103d1a:	05 a0 47 11 80       	add    $0x801147a0,%eax
}
80103d1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d22:	5b                   	pop    %ebx
80103d23:	5e                   	pop    %esi
80103d24:	5d                   	pop    %ebp
80103d25:	c3                   	ret    
        if (cpus[i].apicid == apicid)
80103d26:	b8 a0 47 11 80       	mov    $0x801147a0,%eax
            return &cpus[i];
80103d2b:	eb f2                	jmp    80103d1f <mycpu+0x4f>
    panic("unknown apicid\n");
80103d2d:	83 ec 0c             	sub    $0xc,%esp
80103d30:	68 dc 89 10 80       	push   $0x801089dc
80103d35:	e8 56 c6 ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
80103d3a:	83 ec 0c             	sub    $0xc,%esp
80103d3d:	68 24 8b 10 80       	push   $0x80108b24
80103d42:	e8 49 c6 ff ff       	call   80100390 <panic>
80103d47:	89 f6                	mov    %esi,%esi
80103d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d50 <cpuid>:
cpuid() {
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103d56:	e8 75 ff ff ff       	call   80103cd0 <mycpu>
80103d5b:	2d a0 47 11 80       	sub    $0x801147a0,%eax
}
80103d60:	c9                   	leave  
    return mycpu() - cpus;
80103d61:	c1 f8 04             	sar    $0x4,%eax
80103d64:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103d6a:	c3                   	ret    
80103d6b:	90                   	nop
80103d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d70 <notShell>:
int notShell(void) {
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	53                   	push   %ebx
80103d74:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103d77:	e8 c4 12 00 00       	call   80105040 <pushcli>
    c = mycpu();
80103d7c:	e8 4f ff ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80103d81:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103d87:	e8 b4 13 00 00       	call   80105140 <popcli>
    return myproc()->pid > 2;
80103d8c:	31 c0                	xor    %eax,%eax
80103d8e:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103d92:	0f 9f c0             	setg   %al
}
80103d95:	83 c4 04             	add    $0x4,%esp
80103d98:	5b                   	pop    %ebx
80103d99:	5d                   	pop    %ebp
80103d9a:	c3                   	ret    
80103d9b:	90                   	nop
80103d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103da0 <myproc>:
myproc(void) {
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	53                   	push   %ebx
80103da4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103da7:	e8 94 12 00 00       	call   80105040 <pushcli>
    c = mycpu();
80103dac:	e8 1f ff ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80103db1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103db7:	e8 84 13 00 00       	call   80105140 <popcli>
}
80103dbc:	83 c4 04             	add    $0x4,%esp
80103dbf:	89 d8                	mov    %ebx,%eax
80103dc1:	5b                   	pop    %ebx
80103dc2:	5d                   	pop    %ebp
80103dc3:	c3                   	ret    
80103dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103dd0 <printCurrFrame>:
printCurrFrame(void){
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80103dd9:	e8 62 12 00 00       	call   80105040 <pushcli>
    c = mycpu();
80103dde:	e8 ed fe ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80103de3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80103de9:	e8 52 13 00 00       	call   80105140 <popcli>
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103dee:	8d be 80 00 00 00    	lea    0x80(%esi),%edi
80103df4:	8d 9e 00 04 00 00    	lea    0x400(%esi),%ebx
80103dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cprintf("pageID:%d\toffset:%d\t\tactive:%d\tpresent:%d\tsequal:%d\tphysAdress:%d\t\tvirtAdress:%d\n ",
80103e00:	ff 77 18             	pushl  0x18(%edi)
80103e03:	ff 77 14             	pushl  0x14(%edi)
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103e06:	83 c7 1c             	add    $0x1c,%edi
        cprintf("pageID:%d\toffset:%d\t\tactive:%d\tpresent:%d\tsequal:%d\tphysAdress:%d\t\tvirtAdress:%d\n ",
80103e09:	ff 77 ec             	pushl  -0x14(%edi)
80103e0c:	ff 77 f0             	pushl  -0x10(%edi)
80103e0f:	ff 77 e4             	pushl  -0x1c(%edi)
80103e12:	ff 77 f4             	pushl  -0xc(%edi)
80103e15:	ff 77 e8             	pushl  -0x18(%edi)
80103e18:	68 4c 8b 10 80       	push   $0x80108b4c
80103e1d:	e8 3e c8 ff ff       	call   80100660 <cprintf>
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103e22:	83 c4 20             	add    $0x20,%esp
80103e25:	39 df                	cmp    %ebx,%edi
80103e27:	72 d7                	jb     80103e00 <printCurrFrame+0x30>
    cprintf("\n\n swapFileEntries:\t");
80103e29:	83 ec 0c             	sub    $0xc,%esp
80103e2c:	81 c6 40 04 00 00    	add    $0x440,%esi
80103e32:	68 ec 89 10 80       	push   $0x801089ec
80103e37:	e8 24 c8 ff ff       	call   80100660 <cprintf>
80103e3c:	83 c4 10             	add    $0x10,%esp
80103e3f:	90                   	nop
        cprintf("%d\t",p->swapFileEntries[i]);
80103e40:	83 ec 08             	sub    $0x8,%esp
80103e43:	ff 33                	pushl  (%ebx)
80103e45:	83 c3 04             	add    $0x4,%ebx
80103e48:	68 01 8a 10 80       	push   $0x80108a01
80103e4d:	e8 0e c8 ff ff       	call   80100660 <cprintf>
    for(int i=0; i<16; i++)
80103e52:	83 c4 10             	add    $0x10,%esp
80103e55:	39 f3                	cmp    %esi,%ebx
80103e57:	75 e7                	jne    80103e40 <printCurrFrame+0x70>
    cprintf("\n\n");
80103e59:	83 ec 0c             	sub    $0xc,%esp
80103e5c:	68 05 8a 10 80       	push   $0x80108a05
80103e61:	e8 fa c7 ff ff       	call   80100660 <cprintf>
}
80103e66:	83 c4 10             	add    $0x10,%esp
80103e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e6c:	5b                   	pop    %ebx
80103e6d:	5e                   	pop    %esi
80103e6e:	5f                   	pop    %edi
80103e6f:	5d                   	pop    %ebp
80103e70:	c3                   	ret    
80103e71:	eb 0d                	jmp    80103e80 <panic2>
80103e73:	90                   	nop
80103e74:	90                   	nop
80103e75:	90                   	nop
80103e76:	90                   	nop
80103e77:	90                   	nop
80103e78:	90                   	nop
80103e79:	90                   	nop
80103e7a:	90                   	nop
80103e7b:	90                   	nop
80103e7c:	90                   	nop
80103e7d:	90                   	nop
80103e7e:	90                   	nop
80103e7f:	90                   	nop

80103e80 <panic2>:
panic2(char * str){
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	83 ec 08             	sub    $0x8,%esp
    printCurrFrame();
80103e86:	e8 45 ff ff ff       	call   80103dd0 <printCurrFrame>
    panic(str);
80103e8b:	83 ec 0c             	sub    $0xc,%esp
80103e8e:	ff 75 08             	pushl  0x8(%ebp)
80103e91:	e8 fa c4 ff ff       	call   80100390 <panic>
80103e96:	8d 76 00             	lea    0x0(%esi),%esi
80103e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ea0 <userinit>:
userinit(void) {
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	53                   	push   %ebx
80103ea4:	83 ec 04             	sub    $0x4,%esp
    totalAvailablePages = kallocCount() - 60;
80103ea7:	e8 b4 e8 ff ff       	call   80102760 <kallocCount>
80103eac:	83 e8 3c             	sub    $0x3c,%eax
80103eaf:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
    p = allocproc();
80103eb4:	e8 17 fc ff ff       	call   80103ad0 <allocproc>
80103eb9:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103ebb:	a3 bc c5 10 80       	mov    %eax,0x8010c5bc
    if ((p->pgdir = setupkvm()) == 0)
80103ec0:	e8 db 42 00 00       	call   801081a0 <setupkvm>
80103ec5:	85 c0                	test   %eax,%eax
80103ec7:	89 43 04             	mov    %eax,0x4(%ebx)
80103eca:	0f 84 bd 00 00 00    	je     80103f8d <userinit+0xed>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103ed0:	83 ec 04             	sub    $0x4,%esp
80103ed3:	68 2c 00 00 00       	push   $0x2c
80103ed8:	68 60 c4 10 80       	push   $0x8010c460
80103edd:	50                   	push   %eax
80103ede:	e8 2d 3c 00 00       	call   80107b10 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103ee3:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103ee6:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103eec:	6a 4c                	push   $0x4c
80103eee:	6a 00                	push   $0x0
80103ef0:	ff 73 18             	pushl  0x18(%ebx)
80103ef3:	e8 08 13 00 00       	call   80105200 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ef8:	8b 43 18             	mov    0x18(%ebx),%eax
80103efb:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f00:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103f05:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f08:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103f0f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103f13:	8b 43 18             	mov    0x18(%ebx),%eax
80103f16:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f1a:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103f1e:	8b 43 18             	mov    0x18(%ebx),%eax
80103f21:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f25:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103f29:	8b 43 18             	mov    0x18(%ebx),%eax
80103f2c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103f33:	8b 43 18             	mov    0x18(%ebx),%eax
80103f36:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103f3d:	8b 43 18             	mov    0x18(%ebx),%eax
80103f40:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103f47:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f4a:	6a 10                	push   $0x10
80103f4c:	68 21 8a 10 80       	push   $0x80108a21
80103f51:	50                   	push   %eax
80103f52:	e8 89 14 00 00       	call   801053e0 <safestrcpy>
    p->cwd = namei("/");
80103f57:	c7 04 24 2a 8a 10 80 	movl   $0x80108a2a,(%esp)
80103f5e:	e8 3d e0 ff ff       	call   80101fa0 <namei>
80103f63:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103f66:	c7 04 24 40 5d 11 80 	movl   $0x80115d40,(%esp)
80103f6d:	e8 0e 11 00 00       	call   80105080 <acquire>
    p->state = RUNNABLE;
80103f72:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103f79:	c7 04 24 40 5d 11 80 	movl   $0x80115d40,(%esp)
80103f80:	e8 1b 12 00 00       	call   801051a0 <release>
}
80103f85:	83 c4 10             	add    $0x10,%esp
80103f88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f8b:	c9                   	leave  
80103f8c:	c3                   	ret    
        panic("userinit: out of memory?");
80103f8d:	83 ec 0c             	sub    $0xc,%esp
80103f90:	68 08 8a 10 80       	push   $0x80108a08
80103f95:	e8 f6 c3 ff ff       	call   80100390 <panic>
80103f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fa0 <growproc>:
growproc(int n) {
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
80103fa5:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103fa8:	e8 93 10 00 00       	call   80105040 <pushcli>
    c = mycpu();
80103fad:	e8 1e fd ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80103fb2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103fb8:	e8 83 11 00 00       	call   80105140 <popcli>
    if (n > 0) {
80103fbd:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103fc0:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103fc2:	7f 1c                	jg     80103fe0 <growproc+0x40>
    } else if (n < 0) {
80103fc4:	75 3a                	jne    80104000 <growproc+0x60>
    switchuvm(curproc);
80103fc6:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103fc9:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103fcb:	53                   	push   %ebx
80103fcc:	e8 2f 3a 00 00       	call   80107a00 <switchuvm>
    return 0;
80103fd1:	83 c4 10             	add    $0x10,%esp
80103fd4:	31 c0                	xor    %eax,%eax
}
80103fd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd9:	5b                   	pop    %ebx
80103fda:	5e                   	pop    %esi
80103fdb:	5d                   	pop    %ebp
80103fdc:	c3                   	ret    
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fe0:	83 ec 04             	sub    $0x4,%esp
80103fe3:	01 c6                	add    %eax,%esi
80103fe5:	56                   	push   %esi
80103fe6:	50                   	push   %eax
80103fe7:	ff 73 04             	pushl  0x4(%ebx)
80103fea:	e8 d1 3e 00 00       	call   80107ec0 <allocuvm>
80103fef:	83 c4 10             	add    $0x10,%esp
80103ff2:	85 c0                	test   %eax,%eax
80103ff4:	75 d0                	jne    80103fc6 <growproc+0x26>
            return -1;
80103ff6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ffb:	eb d9                	jmp    80103fd6 <growproc+0x36>
80103ffd:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
80104000:	01 c6                	add    %eax,%esi
80104002:	6a 01                	push   $0x1
80104004:	56                   	push   %esi
80104005:	50                   	push   %eax
80104006:	ff 73 04             	pushl  0x4(%ebx)
80104009:	e8 82 3c 00 00       	call   80107c90 <deallocuvm>
8010400e:	83 c4 10             	add    $0x10,%esp
80104011:	85 c0                	test   %eax,%eax
80104013:	75 b1                	jne    80103fc6 <growproc+0x26>
80104015:	eb df                	jmp    80103ff6 <growproc+0x56>
80104017:	89 f6                	mov    %esi,%esi
80104019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104020 <fork>:
fork(void) {
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	57                   	push   %edi
80104024:	56                   	push   %esi
80104025:	53                   	push   %ebx
80104026:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80104029:	e8 12 10 00 00       	call   80105040 <pushcli>
    c = mycpu();
8010402e:	e8 9d fc ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104033:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104039:	e8 02 11 00 00       	call   80105140 <popcli>
    if ((np = allocproc()) == 0) {
8010403e:	e8 8d fa ff ff       	call   80103ad0 <allocproc>
80104043:	85 c0                	test   %eax,%eax
80104045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104048:	89 c7                	mov    %eax,%edi
8010404a:	0f 84 40 02 00 00    	je     80104290 <fork+0x270>
    createSwapFile(np);
80104050:	83 ec 0c             	sub    $0xc,%esp
80104053:	50                   	push   %eax
80104054:	e8 17 e2 ff ff       	call   80102270 <createSwapFile>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80104059:	5a                   	pop    %edx
8010405a:	59                   	pop    %ecx
8010405b:	ff 33                	pushl  (%ebx)
8010405d:	ff 73 04             	pushl  0x4(%ebx)
80104060:	e8 0b 42 00 00       	call   80108270 <copyuvm>
80104065:	83 c4 10             	add    $0x10,%esp
80104068:	85 c0                	test   %eax,%eax
8010406a:	89 47 04             	mov    %eax,0x4(%edi)
8010406d:	0f 84 27 02 00 00    	je     8010429a <fork+0x27a>
    np->sz = curproc->sz;
80104073:	8b 03                	mov    (%ebx),%eax
80104075:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    *np->tf = *curproc->tf;
80104078:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = curproc->sz;
8010407d:	89 02                	mov    %eax,(%edx)
    np->parent = curproc;
8010407f:	89 5a 14             	mov    %ebx,0x14(%edx)
    *np->tf = *curproc->tf;
80104082:	8b 7a 18             	mov    0x18(%edx),%edi
80104085:	8b 73 18             	mov    0x18(%ebx),%esi
80104088:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    if (notShell()) {
8010408a:	e8 e1 fc ff ff       	call   80103d70 <notShell>
8010408f:	85 c0                	test   %eax,%eax
80104091:	0f 85 91 00 00 00    	jne    80104128 <fork+0x108>
    np->tf->eax = 0;
80104097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    for (i = 0; i < NOFILE; i++)
8010409a:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
8010409c:	8b 40 18             	mov    0x18(%eax),%eax
8010409f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801040a6:	8d 76 00             	lea    0x0(%esi),%esi
801040a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (curproc->ofile[i])
801040b0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801040b4:	85 c0                	test   %eax,%eax
801040b6:	74 13                	je     801040cb <fork+0xab>
            np->ofile[i] = filedup(curproc->ofile[i]);
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	50                   	push   %eax
801040bc:	e8 df cd ff ff       	call   80100ea0 <filedup>
801040c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801040c4:	83 c4 10             	add    $0x10,%esp
801040c7:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
    for (i = 0; i < NOFILE; i++)
801040cb:	83 c6 01             	add    $0x1,%esi
801040ce:	83 fe 10             	cmp    $0x10,%esi
801040d1:	75 dd                	jne    801040b0 <fork+0x90>
    np->cwd = idup(curproc->cwd);
801040d3:	83 ec 0c             	sub    $0xc,%esp
801040d6:	ff 73 68             	pushl  0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040d9:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
801040dc:	e8 2f d6 ff ff       	call   80101710 <idup>
801040e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040e4:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
801040e7:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040ea:	8d 47 6c             	lea    0x6c(%edi),%eax
801040ed:	6a 10                	push   $0x10
801040ef:	53                   	push   %ebx
801040f0:	50                   	push   %eax
801040f1:	e8 ea 12 00 00       	call   801053e0 <safestrcpy>
    pid = np->pid;
801040f6:	8b 5f 10             	mov    0x10(%edi),%ebx
    acquire(&ptable.lock);
801040f9:	c7 04 24 40 5d 11 80 	movl   $0x80115d40,(%esp)
80104100:	e8 7b 0f 00 00       	call   80105080 <acquire>
    np->state = RUNNABLE;
80104105:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
8010410c:	c7 04 24 40 5d 11 80 	movl   $0x80115d40,(%esp)
80104113:	e8 88 10 00 00       	call   801051a0 <release>
    return pid;
80104118:	83 c4 10             	add    $0x10,%esp
}
8010411b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010411e:	89 d8                	mov    %ebx,%eax
80104120:	5b                   	pop    %ebx
80104121:	5e                   	pop    %esi
80104122:	5f                   	pop    %edi
80104123:	5d                   	pop    %ebp
80104124:	c3                   	ret    
80104125:	8d 76 00             	lea    0x0(%esi),%esi
        np->nextpageid = curproc->nextpageid;
80104128:	8b 83 40 04 00 00    	mov    0x440(%ebx),%eax
8010412e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104131:	89 82 40 04 00 00    	mov    %eax,0x440(%edx)
        np->pagesCounter = curproc->pagesCounter;
80104137:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
8010413d:	89 82 44 04 00 00    	mov    %eax,0x444(%edx)
        np->pagesinSwap = curproc->pagesinSwap;
80104143:	8b 83 48 04 00 00    	mov    0x448(%ebx),%eax
80104149:	89 82 48 04 00 00    	mov    %eax,0x448(%edx)
        np->pagesequel = curproc->pagesequel;
8010414f:	8b 83 4c 04 00 00    	mov    0x44c(%ebx),%eax
80104155:	89 82 4c 04 00 00    	mov    %eax,0x44c(%edx)
        np->protectedPages = curproc->protectedPages;
8010415b:	8b 83 50 04 00 00    	mov    0x450(%ebx),%eax
        np->pageFaults = 0;
80104161:	c7 82 54 04 00 00 00 	movl   $0x0,0x454(%edx)
80104168:	00 00 00 
        np->totalPagesInSwap = 0;
8010416b:	c7 82 58 04 00 00 00 	movl   $0x0,0x458(%edx)
80104172:	00 00 00 
        np->protectedPages = curproc->protectedPages;
80104175:	89 82 50 04 00 00    	mov    %eax,0x450(%edx)
        for(int k=0; k<MAX_PSYC_PAGES ; k++)
8010417b:	31 c0                	xor    %eax,%eax
8010417d:	8d 76 00             	lea    0x0(%esi),%esi
            np->swapFileEntries[k]=curproc->swapFileEntries[k];
80104180:	8b 94 83 00 04 00 00 	mov    0x400(%ebx,%eax,4),%edx
80104187:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010418a:	89 94 87 00 04 00 00 	mov    %edx,0x400(%edi,%eax,4)
        for(int k=0; k<MAX_PSYC_PAGES ; k++)
80104191:	83 c0 01             	add    $0x1,%eax
80104194:	83 f8 10             	cmp    $0x10,%eax
80104197:	75 e7                	jne    80104180 <fork+0x160>
        for( pg = np->pages , cg = curproc->pages;
80104199:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
8010419f:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
                pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
801041a5:	8d b7 00 04 00 00    	lea    0x400(%edi),%esi
801041ab:	90                   	nop
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            pg->active = cg->active;
801041b0:	8b 0a                	mov    (%edx),%ecx
                pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
801041b2:	83 c0 1c             	add    $0x1c,%eax
801041b5:	83 c2 1c             	add    $0x1c,%edx
            pg->active = cg->active;
801041b8:	89 48 e4             	mov    %ecx,-0x1c(%eax)
            pg->pageid = cg->pageid;
801041bb:	8b 4a e8             	mov    -0x18(%edx),%ecx
801041be:	89 48 e8             	mov    %ecx,-0x18(%eax)
            pg->sequel = cg->sequel;
801041c1:	8b 4a ec             	mov    -0x14(%edx),%ecx
801041c4:	89 48 ec             	mov    %ecx,-0x14(%eax)
            pg->present = cg->present;
801041c7:	8b 4a f0             	mov    -0x10(%edx),%ecx
801041ca:	89 48 f0             	mov    %ecx,-0x10(%eax)
            pg->offset = cg->offset;
801041cd:	8b 4a f4             	mov    -0xc(%edx),%ecx
801041d0:	89 48 f4             	mov    %ecx,-0xc(%eax)
            pg->physAdress = cg->physAdress;
801041d3:	8b 4a f8             	mov    -0x8(%edx),%ecx
801041d6:	89 48 f8             	mov    %ecx,-0x8(%eax)
            pg->virtAdress = cg->virtAdress;
801041d9:	8b 4a fc             	mov    -0x4(%edx),%ecx
801041dc:	89 48 fc             	mov    %ecx,-0x4(%eax)
        for( pg = np->pages , cg = curproc->pages;
801041df:	39 c6                	cmp    %eax,%esi
801041e1:	77 cd                	ja     801041b0 <fork+0x190>
        for( int k = 0 ; k < MAX_PSYC_PAGES ; k++ ){
801041e3:	31 f6                	xor    %esi,%esi
801041e5:	eb 15                	jmp    801041fc <fork+0x1dc>
801041e7:	89 f6                	mov    %esi,%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801041f0:	83 c6 01             	add    $0x1,%esi
801041f3:	83 fe 10             	cmp    $0x10,%esi
801041f6:	0f 84 9b fe ff ff    	je     80104097 <fork+0x77>
            if( curproc->swapFileEntries[k] > 0 ) {
801041fc:	8b 84 b3 00 04 00 00 	mov    0x400(%ebx,%esi,4),%eax
80104203:	85 c0                	test   %eax,%eax
80104205:	7e e9                	jle    801041f0 <fork+0x1d0>
                memset(buffer, 0, PGSIZE);
80104207:	83 ec 04             	sub    $0x4,%esp
8010420a:	89 f7                	mov    %esi,%edi
8010420c:	68 00 10 00 00       	push   $0x1000
80104211:	6a 00                	push   $0x0
80104213:	c1 e7 0c             	shl    $0xc,%edi
80104216:	68 40 4d 11 80       	push   $0x80114d40
8010421b:	e8 e0 0f 00 00       	call   80105200 <memset>
                if (readFromSwapFile(curproc, buffer, k * PGSIZE, PGSIZE) == -1) {
80104220:	68 00 10 00 00       	push   $0x1000
80104225:	57                   	push   %edi
80104226:	68 40 4d 11 80       	push   $0x80114d40
8010422b:	53                   	push   %ebx
8010422c:	e8 0f e1 ff ff       	call   80102340 <readFromSwapFile>
80104231:	83 c4 20             	add    $0x20,%esp
80104234:	83 f8 ff             	cmp    $0xffffffff,%eax
80104237:	0f 84 86 00 00 00    	je     801042c3 <fork+0x2a3>
                if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
8010423d:	68 00 10 00 00       	push   $0x1000
80104242:	57                   	push   %edi
80104243:	68 40 4d 11 80       	push   $0x80114d40
80104248:	ff 75 e4             	pushl  -0x1c(%ebp)
8010424b:	e8 c0 e0 ff ff       	call   80102310 <writeToSwapFile>
80104250:	83 c4 10             	add    $0x10,%esp
80104253:	83 f8 ff             	cmp    $0xffffffff,%eax
80104256:	75 98                	jne    801041f0 <fork+0x1d0>
                    kfree(np->kstack);
80104258:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010425b:	83 ec 0c             	sub    $0xc,%esp
8010425e:	ff 73 08             	pushl  0x8(%ebx)
80104261:	e8 7a e5 ff ff       	call   801027e0 <kfree>
                    np->kstack = 0;
80104266:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                    np->state = UNUSED;
8010426d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                    removeSwapFile(np); //clear swapFile
80104274:	89 1c 24             	mov    %ebx,(%esp)
80104277:	e8 f4 dd ff ff       	call   80102070 <removeSwapFile>
                    panic2( "FORK WRITE ");
8010427c:	c7 04 24 37 8a 10 80 	movl   $0x80108a37,(%esp)
80104283:	e8 f8 fb ff ff       	call   80103e80 <panic2>
80104288:	90                   	nop
80104289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104290:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104295:	e9 81 fe ff ff       	jmp    8010411b <fork+0xfb>
        kfree(np->kstack);
8010429a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	ff 73 08             	pushl  0x8(%ebx)
801042a3:	e8 38 e5 ff ff       	call   801027e0 <kfree>
        np->kstack = 0;
801042a8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
801042af:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
801042b6:	83 c4 10             	add    $0x10,%esp
801042b9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801042be:	e9 58 fe ff ff       	jmp    8010411b <fork+0xfb>
                    kfree(np->kstack);
801042c3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801042c6:	83 ec 0c             	sub    $0xc,%esp
801042c9:	ff 73 08             	pushl  0x8(%ebx)
801042cc:	e8 0f e5 ff ff       	call   801027e0 <kfree>
                    np->kstack = 0;
801042d1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                    np->state = UNUSED;
801042d8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                    removeSwapFile(np); //clear swapFile
801042df:	89 1c 24             	mov    %ebx,(%esp)
801042e2:	e8 89 dd ff ff       	call   80102070 <removeSwapFile>
                    panic2( "FORK READ ");
801042e7:	c7 04 24 2c 8a 10 80 	movl   $0x80108a2c,(%esp)
801042ee:	e8 8d fb ff ff       	call   80103e80 <panic2>
801042f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104300 <scheduler>:
scheduler(void) {
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	57                   	push   %edi
80104304:	56                   	push   %esi
80104305:	53                   	push   %ebx
80104306:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
80104309:	e8 c2 f9 ff ff       	call   80103cd0 <mycpu>
8010430e:	8d 78 04             	lea    0x4(%eax),%edi
80104311:	89 c6                	mov    %eax,%esi
    c->proc = 0;
80104313:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010431a:	00 00 00 
8010431d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104320:	fb                   	sti    
        acquire(&ptable.lock);
80104321:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104324:	bb 74 5d 11 80       	mov    $0x80115d74,%ebx
        acquire(&ptable.lock);
80104329:	68 40 5d 11 80       	push   $0x80115d40
8010432e:	e8 4d 0d 00 00       	call   80105080 <acquire>
80104333:	83 c4 10             	add    $0x10,%esp
80104336:	8d 76 00             	lea    0x0(%esi),%esi
80104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (p->state != RUNNABLE)
80104340:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104344:	75 33                	jne    80104379 <scheduler+0x79>
            switchuvm(p);
80104346:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80104349:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
8010434f:	53                   	push   %ebx
80104350:	e8 ab 36 00 00       	call   80107a00 <switchuvm>
            swtch(&(c->scheduler), p->context);
80104355:	58                   	pop    %eax
80104356:	5a                   	pop    %edx
80104357:	ff 73 1c             	pushl  0x1c(%ebx)
8010435a:	57                   	push   %edi
            p->state = RUNNING;
8010435b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80104362:	e8 d4 10 00 00       	call   8010543b <swtch>
            switchkvm();
80104367:	e8 74 36 00 00       	call   801079e0 <switchkvm>
            c->proc = 0;
8010436c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104373:	00 00 00 
80104376:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104379:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
8010437f:	81 fb 74 74 12 80    	cmp    $0x80127474,%ebx
80104385:	72 b9                	jb     80104340 <scheduler+0x40>
        release(&ptable.lock);
80104387:	83 ec 0c             	sub    $0xc,%esp
8010438a:	68 40 5d 11 80       	push   $0x80115d40
8010438f:	e8 0c 0e 00 00       	call   801051a0 <release>
        sti();
80104394:	83 c4 10             	add    $0x10,%esp
80104397:	eb 87                	jmp    80104320 <scheduler+0x20>
80104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043a0 <sched>:
sched(void) {
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
    pushcli();
801043a5:	e8 96 0c 00 00       	call   80105040 <pushcli>
    c = mycpu();
801043aa:	e8 21 f9 ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
801043af:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801043b5:	e8 86 0d 00 00       	call   80105140 <popcli>
    if (!holding(&ptable.lock))
801043ba:	83 ec 0c             	sub    $0xc,%esp
801043bd:	68 40 5d 11 80       	push   $0x80115d40
801043c2:	e8 39 0c 00 00       	call   80105000 <holding>
801043c7:	83 c4 10             	add    $0x10,%esp
801043ca:	85 c0                	test   %eax,%eax
801043cc:	74 4f                	je     8010441d <sched+0x7d>
    if (mycpu()->ncli != 1)
801043ce:	e8 fd f8 ff ff       	call   80103cd0 <mycpu>
801043d3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801043da:	75 68                	jne    80104444 <sched+0xa4>
    if (p->state == RUNNING)
801043dc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801043e0:	74 55                	je     80104437 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043e2:	9c                   	pushf  
801043e3:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801043e4:	f6 c4 02             	test   $0x2,%ah
801043e7:	75 41                	jne    8010442a <sched+0x8a>
    intena = mycpu()->intena;
801043e9:	e8 e2 f8 ff ff       	call   80103cd0 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
801043ee:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
801043f1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
801043f7:	e8 d4 f8 ff ff       	call   80103cd0 <mycpu>
801043fc:	83 ec 08             	sub    $0x8,%esp
801043ff:	ff 70 04             	pushl  0x4(%eax)
80104402:	53                   	push   %ebx
80104403:	e8 33 10 00 00       	call   8010543b <swtch>
    mycpu()->intena = intena;
80104408:	e8 c3 f8 ff ff       	call   80103cd0 <mycpu>
}
8010440d:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80104410:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104416:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104419:	5b                   	pop    %ebx
8010441a:	5e                   	pop    %esi
8010441b:	5d                   	pop    %ebp
8010441c:	c3                   	ret    
        panic("sched ptable.lock");
8010441d:	83 ec 0c             	sub    $0xc,%esp
80104420:	68 43 8a 10 80       	push   $0x80108a43
80104425:	e8 66 bf ff ff       	call   80100390 <panic>
        panic("sched interruptible");
8010442a:	83 ec 0c             	sub    $0xc,%esp
8010442d:	68 6f 8a 10 80       	push   $0x80108a6f
80104432:	e8 59 bf ff ff       	call   80100390 <panic>
        panic("sched running");
80104437:	83 ec 0c             	sub    $0xc,%esp
8010443a:	68 61 8a 10 80       	push   $0x80108a61
8010443f:	e8 4c bf ff ff       	call   80100390 <panic>
        panic("sched locks");
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	68 55 8a 10 80       	push   $0x80108a55
8010444c:	e8 3f bf ff ff       	call   80100390 <panic>
80104451:	eb 0d                	jmp    80104460 <exit>
80104453:	90                   	nop
80104454:	90                   	nop
80104455:	90                   	nop
80104456:	90                   	nop
80104457:	90                   	nop
80104458:	90                   	nop
80104459:	90                   	nop
8010445a:	90                   	nop
8010445b:	90                   	nop
8010445c:	90                   	nop
8010445d:	90                   	nop
8010445e:	90                   	nop
8010445f:	90                   	nop

80104460 <exit>:
exit(void) {
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	53                   	push   %ebx
80104466:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104469:	e8 d2 0b 00 00       	call   80105040 <pushcli>
    c = mycpu();
8010446e:	e8 5d f8 ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104473:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104479:	e8 c2 0c 00 00       	call   80105140 <popcli>
    if (curproc == initproc)
8010447e:	39 1d bc c5 10 80    	cmp    %ebx,0x8010c5bc
80104484:	8d 73 28             	lea    0x28(%ebx),%esi
80104487:	8d 7b 68             	lea    0x68(%ebx),%edi
8010448a:	0f 84 11 01 00 00    	je     801045a1 <exit+0x141>
        if (curproc->ofile[fd]) {
80104490:	8b 06                	mov    (%esi),%eax
80104492:	85 c0                	test   %eax,%eax
80104494:	74 12                	je     801044a8 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104496:	83 ec 0c             	sub    $0xc,%esp
80104499:	50                   	push   %eax
8010449a:	e8 51 ca ff ff       	call   80100ef0 <fileclose>
            curproc->ofile[fd] = 0;
8010449f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801044a5:	83 c4 10             	add    $0x10,%esp
801044a8:	83 c6 04             	add    $0x4,%esi
    for (fd = 0; fd < NOFILE; fd++) {
801044ab:	39 fe                	cmp    %edi,%esi
801044ad:	75 e1                	jne    80104490 <exit+0x30>
    begin_op();
801044af:	e8 bc eb ff ff       	call   80103070 <begin_op>
    iput(curproc->cwd);
801044b4:	83 ec 0c             	sub    $0xc,%esp
801044b7:	ff 73 68             	pushl  0x68(%ebx)
801044ba:	e8 b1 d3 ff ff       	call   80101870 <iput>
    end_op();
801044bf:	e8 1c ec ff ff       	call   801030e0 <end_op>
    curproc->cwd = 0;
801044c4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
    if (notShell())
801044cb:	e8 a0 f8 ff ff       	call   80103d70 <notShell>
801044d0:	83 c4 10             	add    $0x10,%esp
801044d3:	85 c0                	test   %eax,%eax
801044d5:	74 0c                	je     801044e3 <exit+0x83>
            removeSwapFile(curproc);
801044d7:	83 ec 0c             	sub    $0xc,%esp
801044da:	53                   	push   %ebx
801044db:	e8 90 db ff ff       	call   80102070 <removeSwapFile>
801044e0:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
801044e3:	83 ec 0c             	sub    $0xc,%esp
801044e6:	68 40 5d 11 80       	push   $0x80115d40
801044eb:	e8 90 0b 00 00       	call   80105080 <acquire>
    wakeup1(curproc->parent);
801044f0:	8b 53 14             	mov    0x14(%ebx),%edx
801044f3:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f6:	b8 74 5d 11 80       	mov    $0x80115d74,%eax
801044fb:	eb 0f                	jmp    8010450c <exit+0xac>
801044fd:	8d 76 00             	lea    0x0(%esi),%esi
80104500:	05 5c 04 00 00       	add    $0x45c,%eax
80104505:	3d 74 74 12 80       	cmp    $0x80127474,%eax
8010450a:	73 1e                	jae    8010452a <exit+0xca>
        if (p->state == SLEEPING && p->chan == chan)
8010450c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104510:	75 ee                	jne    80104500 <exit+0xa0>
80104512:	3b 50 20             	cmp    0x20(%eax),%edx
80104515:	75 e9                	jne    80104500 <exit+0xa0>
            p->state = RUNNABLE;
80104517:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010451e:	05 5c 04 00 00       	add    $0x45c,%eax
80104523:	3d 74 74 12 80       	cmp    $0x80127474,%eax
80104528:	72 e2                	jb     8010450c <exit+0xac>
            p->parent = initproc;
8010452a:	8b 0d bc c5 10 80    	mov    0x8010c5bc,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104530:	ba 74 5d 11 80       	mov    $0x80115d74,%edx
80104535:	eb 17                	jmp    8010454e <exit+0xee>
80104537:	89 f6                	mov    %esi,%esi
80104539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104540:	81 c2 5c 04 00 00    	add    $0x45c,%edx
80104546:	81 fa 74 74 12 80    	cmp    $0x80127474,%edx
8010454c:	73 3a                	jae    80104588 <exit+0x128>
        if (p->parent == curproc) {
8010454e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104551:	75 ed                	jne    80104540 <exit+0xe0>
            if (p->state == ZOMBIE)
80104553:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104557:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010455a:	75 e4                	jne    80104540 <exit+0xe0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010455c:	b8 74 5d 11 80       	mov    $0x80115d74,%eax
80104561:	eb 11                	jmp    80104574 <exit+0x114>
80104563:	90                   	nop
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104568:	05 5c 04 00 00       	add    $0x45c,%eax
8010456d:	3d 74 74 12 80       	cmp    $0x80127474,%eax
80104572:	73 cc                	jae    80104540 <exit+0xe0>
        if (p->state == SLEEPING && p->chan == chan)
80104574:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104578:	75 ee                	jne    80104568 <exit+0x108>
8010457a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010457d:	75 e9                	jne    80104568 <exit+0x108>
            p->state = RUNNABLE;
8010457f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104586:	eb e0                	jmp    80104568 <exit+0x108>
    curproc->state = ZOMBIE;
80104588:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
    sched();
8010458f:	e8 0c fe ff ff       	call   801043a0 <sched>
    panic("zombie exit");
80104594:	83 ec 0c             	sub    $0xc,%esp
80104597:	68 90 8a 10 80       	push   $0x80108a90
8010459c:	e8 ef bd ff ff       	call   80100390 <panic>
        panic("init exiting");
801045a1:	83 ec 0c             	sub    $0xc,%esp
801045a4:	68 83 8a 10 80       	push   $0x80108a83
801045a9:	e8 e2 bd ff ff       	call   80100390 <panic>
801045ae:	66 90                	xchg   %ax,%ax

801045b0 <yield>:
yield(void) {
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	53                   	push   %ebx
801045b4:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
801045b7:	68 40 5d 11 80       	push   $0x80115d40
801045bc:	e8 bf 0a 00 00       	call   80105080 <acquire>
    pushcli();
801045c1:	e8 7a 0a 00 00       	call   80105040 <pushcli>
    c = mycpu();
801045c6:	e8 05 f7 ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
801045cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801045d1:	e8 6a 0b 00 00       	call   80105140 <popcli>
    myproc()->state = RUNNABLE;
801045d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
801045dd:	e8 be fd ff ff       	call   801043a0 <sched>
    release(&ptable.lock);
801045e2:	c7 04 24 40 5d 11 80 	movl   $0x80115d40,(%esp)
801045e9:	e8 b2 0b 00 00       	call   801051a0 <release>
}
801045ee:	83 c4 10             	add    $0x10,%esp
801045f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f4:	c9                   	leave  
801045f5:	c3                   	ret    
801045f6:	8d 76 00             	lea    0x0(%esi),%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104600 <sleep>:
sleep(void *chan, struct spinlock *lk) {
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	56                   	push   %esi
80104605:	53                   	push   %ebx
80104606:	83 ec 0c             	sub    $0xc,%esp
80104609:	8b 7d 08             	mov    0x8(%ebp),%edi
8010460c:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
8010460f:	e8 2c 0a 00 00       	call   80105040 <pushcli>
    c = mycpu();
80104614:	e8 b7 f6 ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104619:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010461f:	e8 1c 0b 00 00       	call   80105140 <popcli>
    if (p == 0)
80104624:	85 db                	test   %ebx,%ebx
80104626:	0f 84 87 00 00 00    	je     801046b3 <sleep+0xb3>
    if (lk == 0)
8010462c:	85 f6                	test   %esi,%esi
8010462e:	74 76                	je     801046a6 <sleep+0xa6>
    if (lk != &ptable.lock) {  //DOC: sleeplock0
80104630:	81 fe 40 5d 11 80    	cmp    $0x80115d40,%esi
80104636:	74 50                	je     80104688 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	68 40 5d 11 80       	push   $0x80115d40
80104640:	e8 3b 0a 00 00       	call   80105080 <acquire>
        release(lk);
80104645:	89 34 24             	mov    %esi,(%esp)
80104648:	e8 53 0b 00 00       	call   801051a0 <release>
    p->chan = chan;
8010464d:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104650:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104657:	e8 44 fd ff ff       	call   801043a0 <sched>
    p->chan = 0;
8010465c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80104663:	c7 04 24 40 5d 11 80 	movl   $0x80115d40,(%esp)
8010466a:	e8 31 0b 00 00       	call   801051a0 <release>
        acquire(lk);
8010466f:	89 75 08             	mov    %esi,0x8(%ebp)
80104672:	83 c4 10             	add    $0x10,%esp
}
80104675:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104678:	5b                   	pop    %ebx
80104679:	5e                   	pop    %esi
8010467a:	5f                   	pop    %edi
8010467b:	5d                   	pop    %ebp
        acquire(lk);
8010467c:	e9 ff 09 00 00       	jmp    80105080 <acquire>
80104681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104688:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010468b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104692:	e8 09 fd ff ff       	call   801043a0 <sched>
    p->chan = 0;
80104697:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010469e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046a1:	5b                   	pop    %ebx
801046a2:	5e                   	pop    %esi
801046a3:	5f                   	pop    %edi
801046a4:	5d                   	pop    %ebp
801046a5:	c3                   	ret    
        panic("sleep without lk");
801046a6:	83 ec 0c             	sub    $0xc,%esp
801046a9:	68 a2 8a 10 80       	push   $0x80108aa2
801046ae:	e8 dd bc ff ff       	call   80100390 <panic>
        panic("sleep");
801046b3:	83 ec 0c             	sub    $0xc,%esp
801046b6:	68 9c 8a 10 80       	push   $0x80108a9c
801046bb:	e8 d0 bc ff ff       	call   80100390 <panic>

801046c0 <wait>:
wait(void) {
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
    pushcli();
801046c5:	e8 76 09 00 00       	call   80105040 <pushcli>
    c = mycpu();
801046ca:	e8 01 f6 ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
801046cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801046d5:	e8 66 0a 00 00       	call   80105140 <popcli>
    acquire(&ptable.lock);
801046da:	83 ec 0c             	sub    $0xc,%esp
801046dd:	68 40 5d 11 80       	push   $0x80115d40
801046e2:	e8 99 09 00 00       	call   80105080 <acquire>
801046e7:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
801046ea:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801046ec:	bb 74 5d 11 80       	mov    $0x80115d74,%ebx
801046f1:	eb 13                	jmp    80104706 <wait+0x46>
801046f3:	90                   	nop
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046f8:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
801046fe:	81 fb 74 74 12 80    	cmp    $0x80127474,%ebx
80104704:	73 1e                	jae    80104724 <wait+0x64>
            if (p->parent != curproc)
80104706:	39 73 14             	cmp    %esi,0x14(%ebx)
80104709:	75 ed                	jne    801046f8 <wait+0x38>
            if (p->state == ZOMBIE) {
8010470b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010470f:	74 3f                	je     80104750 <wait+0x90>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104711:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
            havekids = 1;
80104717:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010471c:	81 fb 74 74 12 80    	cmp    $0x80127474,%ebx
80104722:	72 e2                	jb     80104706 <wait+0x46>
        if (!havekids || curproc->killed) {
80104724:	85 c0                	test   %eax,%eax
80104726:	0f 84 22 01 00 00    	je     8010484e <wait+0x18e>
8010472c:	8b 46 24             	mov    0x24(%esi),%eax
8010472f:	85 c0                	test   %eax,%eax
80104731:	0f 85 17 01 00 00    	jne    8010484e <wait+0x18e>
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104737:	83 ec 08             	sub    $0x8,%esp
8010473a:	68 40 5d 11 80       	push   $0x80115d40
8010473f:	56                   	push   %esi
80104740:	e8 bb fe ff ff       	call   80104600 <sleep>
        havekids = 0;
80104745:	83 c4 10             	add    $0x10,%esp
80104748:	eb a0                	jmp    801046ea <wait+0x2a>
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                kfree(p->kstack);
80104750:	83 ec 0c             	sub    $0xc,%esp
                pid = p->pid;
80104753:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80104756:	ff 73 08             	pushl  0x8(%ebx)
80104759:	e8 82 e0 ff ff       	call   801027e0 <kfree>
                p->kstack = 0;
8010475e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104765:	5a                   	pop    %edx
80104766:	ff 73 04             	pushl  0x4(%ebx)
80104769:	e8 b2 39 00 00       	call   80108120 <freevm>
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010476e:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80104774:	8d 83 00 04 00 00    	lea    0x400(%ebx),%eax
                p->pid = 0;
8010477a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104781:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104788:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010478c:	83 c4 10             	add    $0x10,%esp
                p->killed = 0;
8010478f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104796:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->nextpageid = 0;
8010479d:	c7 83 40 04 00 00 00 	movl   $0x0,0x440(%ebx)
801047a4:	00 00 00 
                p->pagesCounter = 0;
801047a7:	c7 83 44 04 00 00 00 	movl   $0x0,0x444(%ebx)
801047ae:	00 00 00 
                p->pagesinSwap = 0;
801047b1:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
801047b8:	00 00 00 
                p->pagesequel = 0;
801047bb:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
801047c2:	00 00 00 
                p->protectedPages = 0;
801047c5:	c7 83 50 04 00 00 00 	movl   $0x0,0x450(%ebx)
801047cc:	00 00 00 
                p->pageFaults = 0;
801047cf:	c7 83 54 04 00 00 00 	movl   $0x0,0x454(%ebx)
801047d6:	00 00 00 
                p->totalPagesInSwap = 0;
801047d9:	c7 83 58 04 00 00 00 	movl   $0x0,0x458(%ebx)
801047e0:	00 00 00 
801047e3:	90                   	nop
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    pg->active = 0;
801047e8:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
                    pg->pageid = 0;
801047ee:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801047f5:	83 c2 1c             	add    $0x1c,%edx
                    pg->sequel = 0;
801047f8:	c7 42 ec 00 00 00 00 	movl   $0x0,-0x14(%edx)
                    pg->present = 0;
801047ff:	c7 42 f0 00 00 00 00 	movl   $0x0,-0x10(%edx)
                    pg->offset = 0;
80104806:	c7 42 f4 00 00 00 00 	movl   $0x0,-0xc(%edx)
                    pg->physAdress = 0;
8010480d:	c7 42 f8 00 00 00 00 	movl   $0x0,-0x8(%edx)
                    pg->virtAdress = 0;
80104814:	c7 42 fc 00 00 00 00 	movl   $0x0,-0x4(%edx)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010481b:	39 c2                	cmp    %eax,%edx
8010481d:	72 c9                	jb     801047e8 <wait+0x128>
8010481f:	81 c3 40 04 00 00    	add    $0x440,%ebx
80104825:	8d 76 00             	lea    0x0(%esi),%esi
                    p->swapFileEntries[k]=0;
80104828:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010482e:	83 c0 04             	add    $0x4,%eax
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
80104831:	39 d8                	cmp    %ebx,%eax
80104833:	75 f3                	jne    80104828 <wait+0x168>
                release(&ptable.lock);
80104835:	83 ec 0c             	sub    $0xc,%esp
80104838:	68 40 5d 11 80       	push   $0x80115d40
8010483d:	e8 5e 09 00 00       	call   801051a0 <release>
                return pid;
80104842:	83 c4 10             	add    $0x10,%esp
}
80104845:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104848:	89 f0                	mov    %esi,%eax
8010484a:	5b                   	pop    %ebx
8010484b:	5e                   	pop    %esi
8010484c:	5d                   	pop    %ebp
8010484d:	c3                   	ret    
            release(&ptable.lock);
8010484e:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104851:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
80104856:	68 40 5d 11 80       	push   $0x80115d40
8010485b:	e8 40 09 00 00       	call   801051a0 <release>
            return -1;
80104860:	83 c4 10             	add    $0x10,%esp
80104863:	eb e0                	jmp    80104845 <wait+0x185>
80104865:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 10             	sub    $0x10,%esp
80104877:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010487a:	68 40 5d 11 80       	push   $0x80115d40
8010487f:	e8 fc 07 00 00       	call   80105080 <acquire>
80104884:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104887:	b8 74 5d 11 80       	mov    $0x80115d74,%eax
8010488c:	eb 0e                	jmp    8010489c <wakeup+0x2c>
8010488e:	66 90                	xchg   %ax,%ax
80104890:	05 5c 04 00 00       	add    $0x45c,%eax
80104895:	3d 74 74 12 80       	cmp    $0x80127474,%eax
8010489a:	73 1e                	jae    801048ba <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan)
8010489c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801048a0:	75 ee                	jne    80104890 <wakeup+0x20>
801048a2:	3b 58 20             	cmp    0x20(%eax),%ebx
801048a5:	75 e9                	jne    80104890 <wakeup+0x20>
            p->state = RUNNABLE;
801048a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048ae:	05 5c 04 00 00       	add    $0x45c,%eax
801048b3:	3d 74 74 12 80       	cmp    $0x80127474,%eax
801048b8:	72 e2                	jb     8010489c <wakeup+0x2c>
    wakeup1(chan);
    release(&ptable.lock);
801048ba:	c7 45 08 40 5d 11 80 	movl   $0x80115d40,0x8(%ebp)
}
801048c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048c4:	c9                   	leave  
    release(&ptable.lock);
801048c5:	e9 d6 08 00 00       	jmp    801051a0 <release>
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048d0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 10             	sub    $0x10,%esp
801048d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
801048da:	68 40 5d 11 80       	push   $0x80115d40
801048df:	e8 9c 07 00 00       	call   80105080 <acquire>
801048e4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801048e7:	b8 74 5d 11 80       	mov    $0x80115d74,%eax
801048ec:	eb 0e                	jmp    801048fc <kill+0x2c>
801048ee:	66 90                	xchg   %ax,%ax
801048f0:	05 5c 04 00 00       	add    $0x45c,%eax
801048f5:	3d 74 74 12 80       	cmp    $0x80127474,%eax
801048fa:	73 34                	jae    80104930 <kill+0x60>
        if (p->pid == pid) {
801048fc:	39 58 10             	cmp    %ebx,0x10(%eax)
801048ff:	75 ef                	jne    801048f0 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
80104901:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
80104905:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
8010490c:	75 07                	jne    80104915 <kill+0x45>
                p->state = RUNNABLE;
8010490e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
80104915:	83 ec 0c             	sub    $0xc,%esp
80104918:	68 40 5d 11 80       	push   $0x80115d40
8010491d:	e8 7e 08 00 00       	call   801051a0 <release>
            return 0;
80104922:	83 c4 10             	add    $0x10,%esp
80104925:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104927:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010492a:	c9                   	leave  
8010492b:	c3                   	ret    
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80104930:	83 ec 0c             	sub    $0xc,%esp
80104933:	68 40 5d 11 80       	push   $0x80115d40
80104938:	e8 63 08 00 00       	call   801051a0 <release>
    return -1;
8010493d:	83 c4 10             	add    $0x10,%esp
80104940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104948:	c9                   	leave  
80104949:	c3                   	ret    
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	57                   	push   %edi
80104954:	56                   	push   %esi
80104955:	53                   	push   %ebx
    uint pc[10];
    pte_t *currPTE;
    struct page *cg = 0;
    int protected = 0;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104956:	be 74 5d 11 80       	mov    $0x80115d74,%esi
procdump(void) {
8010495b:	83 ec 4c             	sub    $0x4c,%esp
8010495e:	66 90                	xchg   %ax,%ax
        if (p->state == UNUSED)
80104960:	8b 46 0c             	mov    0xc(%esi),%eax
80104963:	85 c0                	test   %eax,%eax
80104965:	0f 84 ab 00 00 00    	je     80104a16 <procdump+0xc6>
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010496b:	83 f8 05             	cmp    $0x5,%eax
            state = states[p->state];
        else
            state = "???";
8010496e:	ba b3 8a 10 80       	mov    $0x80108ab3,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104973:	77 11                	ja     80104986 <procdump+0x36>
80104975:	8b 14 85 24 8c 10 80 	mov    -0x7fef73dc(,%eax,4),%edx
            state = "???";
8010497c:	b8 b3 8a 10 80       	mov    $0x80108ab3,%eax
80104981:	85 d2                	test   %edx,%edx
80104983:	0f 44 d0             	cmove  %eax,%edx
80104986:	8d 9e 80 00 00 00    	lea    0x80(%esi),%ebx
8010498c:	8d be 00 04 00 00    	lea    0x400(%esi),%edi
80104992:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80104995:	eb 10                	jmp    801049a7 <procdump+0x57>
80104997:	89 f6                	mov    %esi,%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

       for (cg = p->pages ; cg < &p->pages[MAX_TOTAL_PAGES]; cg++ ) {
801049a0:	83 c3 1c             	add    $0x1c,%ebx
801049a3:	39 fb                	cmp    %edi,%ebx
801049a5:	73 20                	jae    801049c7 <procdump+0x77>
           if(cg->active){
801049a7:	8b 03                	mov    (%ebx),%eax
801049a9:	85 c0                	test   %eax,%eax
801049ab:	74 f3                	je     801049a0 <procdump+0x50>
               currPTE = walkpgdir2(p->pgdir, cg->virtAdress, 0);
801049ad:	83 ec 04             	sub    $0x4,%esp
       for (cg = p->pages ; cg < &p->pages[MAX_TOTAL_PAGES]; cg++ ) {
801049b0:	83 c3 1c             	add    $0x1c,%ebx
               currPTE = walkpgdir2(p->pgdir, cg->virtAdress, 0);
801049b3:	6a 00                	push   $0x0
801049b5:	ff 73 fc             	pushl  -0x4(%ebx)
801049b8:	ff 76 04             	pushl  0x4(%esi)
801049bb:	e8 e0 2f 00 00       	call   801079a0 <walkpgdir2>
801049c0:	83 c4 10             	add    $0x10,%esp
       for (cg = p->pages ; cg < &p->pages[MAX_TOTAL_PAGES]; cg++ ) {
801049c3:	39 fb                	cmp    %edi,%ebx
801049c5:	72 e0                	jb     801049a7 <procdump+0x57>
801049c7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
           }

        }
       //p->protectedPages = protected;

        cprintf("%d %s %d %d %d %d %d %s", p->pid, state,
801049ca:	8d 46 6c             	lea    0x6c(%esi),%eax
801049cd:	83 ec 0c             	sub    $0xc,%esp
801049d0:	50                   	push   %eax
801049d1:	ff b6 58 04 00 00    	pushl  0x458(%esi)
801049d7:	ff b6 54 04 00 00    	pushl  0x454(%esi)
801049dd:	ff b6 50 04 00 00    	pushl  0x450(%esi)
801049e3:	ff b6 48 04 00 00    	pushl  0x448(%esi)
801049e9:	ff b6 44 04 00 00    	pushl  0x444(%esi)
801049ef:	52                   	push   %edx
801049f0:	ff 76 10             	pushl  0x10(%esi)
801049f3:	68 b7 8a 10 80       	push   $0x80108ab7
801049f8:	e8 63 bc ff ff       	call   80100660 <cprintf>
                p->pagesCounter, p->pagesinSwap, p->protectedPages,
                p->pageFaults, p->totalPagesInSwap, p->name);
        if (p->state == SLEEPING) {
801049fd:	83 c4 30             	add    $0x30,%esp
80104a00:	83 7e 0c 02          	cmpl   $0x2,0xc(%esi)
80104a04:	74 4a                	je     80104a50 <procdump+0x100>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104a06:	83 ec 0c             	sub    $0xc,%esp
80104a09:	68 06 8a 10 80       	push   $0x80108a06
80104a0e:	e8 4d bc ff ff       	call   80100660 <cprintf>
80104a13:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a16:	81 c6 5c 04 00 00    	add    $0x45c,%esi
80104a1c:	81 fe 74 74 12 80    	cmp    $0x80127474,%esi
80104a22:	0f 82 38 ff ff ff    	jb     80104960 <procdump+0x10>
    }
    currentFreePages = kallocCount();
80104a28:	e8 33 dd ff ff       	call   80102760 <kallocCount>
    cprintf(" %d / %d free pages in the system", currentFreePages, totalAvailablePages);
80104a2d:	83 ec 04             	sub    $0x4,%esp
80104a30:	ff 35 b8 c5 10 80    	pushl  0x8010c5b8
80104a36:	50                   	push   %eax
80104a37:	68 a0 8b 10 80       	push   $0x80108ba0
80104a3c:	e8 1f bc ff ff       	call   80100660 <cprintf>
}
80104a41:	83 c4 10             	add    $0x10,%esp
80104a44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a47:	5b                   	pop    %ebx
80104a48:	5e                   	pop    %esi
80104a49:	5f                   	pop    %edi
80104a4a:	5d                   	pop    %ebp
80104a4b:	c3                   	ret    
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            getcallerpcs((uint *) p->context->ebp + 2, pc);
80104a50:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a53:	83 ec 08             	sub    $0x8,%esp
80104a56:	8d 5d c0             	lea    -0x40(%ebp),%ebx
80104a59:	50                   	push   %eax
80104a5a:	8b 46 1c             	mov    0x1c(%esi),%eax
80104a5d:	8b 40 0c             	mov    0xc(%eax),%eax
80104a60:	83 c0 08             	add    $0x8,%eax
80104a63:	50                   	push   %eax
80104a64:	e8 47 05 00 00       	call   80104fb0 <getcallerpcs>
80104a69:	83 c4 10             	add    $0x10,%esp
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104a70:	8b 03                	mov    (%ebx),%eax
80104a72:	85 c0                	test   %eax,%eax
80104a74:	74 90                	je     80104a06 <procdump+0xb6>
                cprintf(" %p", pc[i]);
80104a76:	83 ec 08             	sub    $0x8,%esp
80104a79:	83 c3 04             	add    $0x4,%ebx
80104a7c:	50                   	push   %eax
80104a7d:	68 81 84 10 80       	push   $0x80108481
80104a82:	e8 d9 bb ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104a87:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104a8a:	83 c4 10             	add    $0x10,%esp
80104a8d:	39 c3                	cmp    %eax,%ebx
80104a8f:	75 df                	jne    80104a70 <procdump+0x120>
80104a91:	e9 70 ff ff ff       	jmp    80104a06 <procdump+0xb6>
80104a96:	8d 76 00             	lea    0x0(%esi),%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <checkOnPM>:
    return 1;
}

//return 1 if PM flag is on and W flag is on
int
checkOnPM( void *p ){
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80104aa7:	e8 94 05 00 00       	call   80105040 <pushcli>
    c = mycpu();
80104aac:	e8 1f f2 ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104ab1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104ab7:	e8 84 06 00 00       	call   80105140 <popcli>
    pte_t *pte;
    pte = walkpgdir2(myproc()->pgdir, p, 0);//find the address
80104abc:	83 ec 04             	sub    $0x4,%esp
80104abf:	6a 00                	push   $0x0
80104ac1:	ff 75 08             	pushl  0x8(%ebp)
80104ac4:	ff 73 04             	pushl  0x4(%ebx)
80104ac7:	e8 d4 2e 00 00       	call   801079a0 <walkpgdir2>
//    if( ( ( *pte & PTE_PM ) != 0) && ( ( *pte & PTE_W ) != 0) ) {
    if( ( ( *pte & PTE_PM ) != 0) ) { //TODO - not sure that need to check PTE_W
80104acc:	8b 00                	mov    (%eax),%eax
        return 1;
    }
    return 0;

}
80104ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad1:	c9                   	leave  
    if( ( ( *pte & PTE_PM ) != 0) ) { //TODO - not sure that need to check PTE_W
80104ad2:	c1 e8 0a             	shr    $0xa,%eax
80104ad5:	83 e0 01             	and    $0x1,%eax
}
80104ad8:	c3                   	ret    
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <findFreeEntryInSwapFile>:



int
findFreeEntryInSwapFile(struct proc *p) {
80104ae0:	55                   	push   %ebp
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80104ae1:	31 c0                	xor    %eax,%eax
findFreeEntryInSwapFile(struct proc *p) {
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ae8:	eb 0e                	jmp    80104af8 <findFreeEntryInSwapFile+0x18>
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80104af0:	83 c0 01             	add    $0x1,%eax
80104af3:	83 f8 10             	cmp    $0x10,%eax
80104af6:	74 10                	je     80104b08 <findFreeEntryInSwapFile+0x28>
        if (p->swapFileEntries[i] == 0)
80104af8:	8b 8c 82 00 04 00 00 	mov    0x400(%edx,%eax,4),%ecx
80104aff:	85 c9                	test   %ecx,%ecx
80104b01:	75 ed                	jne    80104af0 <findFreeEntryInSwapFile+0x10>
            return i;
    }
    return -1;
}
80104b03:	5d                   	pop    %ebp
80104b04:	c3                   	ret    
80104b05:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b0d:	5d                   	pop    %ebp
80104b0e:	c3                   	ret    
80104b0f:	90                   	nop

80104b10 <swapOutPage>:


//make sure that before calling to this func to check:
//#if( defined(LIFO) || defined(SCFIFO))
void
swapOutPage(struct proc *p, pde_t *pgdir) {
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	53                   	push   %ebx
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80104b16:	31 ff                	xor    %edi,%edi
swapOutPage(struct proc *p, pde_t *pgdir) {
80104b18:	83 ec 1c             	sub    $0x1c,%esp
80104b1b:	8b 75 08             	mov    0x8(%ebp),%esi
80104b1e:	eb 0c                	jmp    80104b2c <swapOutPage+0x1c>
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80104b20:	83 c7 01             	add    $0x1,%edi
80104b23:	83 ff 10             	cmp    $0x10,%edi
80104b26:	0f 84 4c 01 00 00    	je     80104c78 <swapOutPage+0x168>
        if (p->swapFileEntries[i] == 0)
80104b2c:	8b 84 be 00 04 00 00 	mov    0x400(%esi,%edi,4),%eax
80104b33:	85 c0                	test   %eax,%eax
80104b35:	75 e9                	jne    80104b20 <swapOutPage+0x10>
80104b37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            cprintf("%d  ", p->swapFileEntries[i]);
        }
        panic2("ERROR - there is no free entry in p->swapFileEntries!\n");
    }

    int swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
80104b3a:	89 f8                	mov    %edi,%eax
80104b3c:	8d 9e 00 04 00 00    	lea    0x400(%esi),%ebx
80104b42:	c1 e0 0c             	shl    $0xc,%eax
80104b45:	89 7d d8             	mov    %edi,-0x28(%ebp)
80104b48:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104b4b:	8d 86 80 00 00 00    	lea    0x80(%esi),%eax
80104b51:	89 45 e0             	mov    %eax,-0x20(%ebp)
    struct page *pg = 0;
80104b54:	31 c0                	xor    %eax,%eax
80104b56:	89 c7                	mov    %eax,%edi
    char *tmpAdress;
    struct page *sg;
    pde_t *tmppgtble;

    while( !found && valid < MAX_TOTAL_PAGES ) {
        minSeq = p->pagesequel;
80104b58:	8b 8e 4c 04 00 00    	mov    0x44c(%esi),%ecx
        //search for min sequal page
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
80104b5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (sg->active && sg->present && sg->sequel < minSeq) {
80104b68:	8b 10                	mov    (%eax),%edx
80104b6a:	85 d2                	test   %edx,%edx
80104b6c:	74 12                	je     80104b80 <swapOutPage+0x70>
80104b6e:	8b 50 0c             	mov    0xc(%eax),%edx
80104b71:	85 d2                	test   %edx,%edx
80104b73:	74 0b                	je     80104b80 <swapOutPage+0x70>
80104b75:	8b 50 08             	mov    0x8(%eax),%edx
80104b78:	39 ca                	cmp    %ecx,%edx
80104b7a:	7d 04                	jge    80104b80 <swapOutPage+0x70>
80104b7c:	89 d1                	mov    %edx,%ecx
80104b7e:	89 c7                	mov    %eax,%edi
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
80104b80:	83 c0 1c             	add    $0x1c,%eax
80104b83:	39 d8                	cmp    %ebx,%eax
80104b85:	72 e1                	jb     80104b68 <swapOutPage+0x58>
                pg = sg;
                minSeq = sg->sequel;
            }
        }
        tmpAdress = pg->virtAdress;
        tmppgtble = walkpgdir2(pgdir, tmpAdress, 0); //if A_FLAG is on -turn off
80104b87:	83 ec 04             	sub    $0x4,%esp
80104b8a:	6a 00                	push   $0x0
80104b8c:	ff 77 18             	pushl  0x18(%edi)
80104b8f:	ff 75 0c             	pushl  0xc(%ebp)
80104b92:	e8 09 2e 00 00       	call   801079a0 <walkpgdir2>
        if (*tmppgtble & PTE_A) {
80104b97:	8b 10                	mov    (%eax),%edx
80104b99:	83 c4 10             	add    $0x10,%esp
80104b9c:	f6 c2 20             	test   $0x20,%dl
80104b9f:	0f 85 9b 00 00 00    	jne    80104c40 <swapOutPage+0x130>
80104ba5:	89 f8                	mov    %edi,%eax


//got here - pg is the page to swap out (in both cases)


    if (writeToSwapFile(p, pg->virtAdress, (uint) swapWriteOffset, PGSIZE) == -1)
80104ba7:	68 00 10 00 00       	push   $0x1000
80104bac:	ff 75 dc             	pushl  -0x24(%ebp)
80104baf:	ff 70 18             	pushl  0x18(%eax)
80104bb2:	56                   	push   %esi
80104bb3:	89 fb                	mov    %edi,%ebx
80104bb5:	8b 7d d8             	mov    -0x28(%ebp),%edi
80104bb8:	e8 53 d7 ff ff       	call   80102310 <writeToSwapFile>
80104bbd:	83 c4 10             	add    $0x10,%esp
80104bc0:	83 f8 ff             	cmp    $0xffffffff,%eax
80104bc3:	0f 84 f1 00 00 00    	je     80104cba <swapOutPage+0x1aa>
    pg->present = 0;
    pg->offset = (uint) swapWriteOffset;
    pg->physAdress = 0;

//update page swapping for proc.
    p->swapFileEntries[tmpOffset] = pg->pageid; //update that this entry is swapped out for pageID
80104bc9:	8b 43 04             	mov    0x4(%ebx),%eax
    pg->offset = (uint) swapWriteOffset;
80104bcc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
    p->totalPagesInSwap++;
    p->pagesinSwap++;

//update pte
    pgtble = walkpgdir2(pgdir, (void *) pg->virtAdress, 0);
80104bcf:	83 ec 04             	sub    $0x4,%esp
    pg->sequel = 0;
80104bd2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    pg->present = 0;
80104bd9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    pg->physAdress = 0;
80104be0:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    pg->offset = (uint) swapWriteOffset;
80104be7:	89 4b 10             	mov    %ecx,0x10(%ebx)
    p->swapFileEntries[tmpOffset] = pg->pageid; //update that this entry is swapped out for pageID
80104bea:	89 84 be 00 04 00 00 	mov    %eax,0x400(%esi,%edi,4)
    p->totalPagesInSwap++;
80104bf1:	83 86 58 04 00 00 01 	addl   $0x1,0x458(%esi)
    p->pagesinSwap++;
80104bf8:	83 86 48 04 00 00 01 	addl   $0x1,0x448(%esi)
    pgtble = walkpgdir2(pgdir, (void *) pg->virtAdress, 0);
80104bff:	6a 00                	push   $0x0
80104c01:	ff 73 18             	pushl  0x18(%ebx)
80104c04:	ff 75 0c             	pushl  0xc(%ebp)
80104c07:	e8 94 2d 00 00       	call   801079a0 <walkpgdir2>
    *pgtble = PTE_P_0(*pgtble);
80104c0c:	8b 10                	mov    (%eax),%edx
80104c0e:	89 d1                	mov    %edx,%ecx
    *pgtble = PTE_PG_1(*pgtble);
    kfree(P2V(PTE_ADDR(*pgtble)));
80104c10:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    *pgtble = PTE_P_0(*pgtble);
80104c16:	83 e1 fe             	and    $0xfffffffe,%ecx
    kfree(P2V(PTE_ADDR(*pgtble)));
80104c19:	81 c2 00 00 00 80    	add    $0x80000000,%edx
    *pgtble = PTE_PG_1(*pgtble);
80104c1f:	80 cd 02             	or     $0x2,%ch
80104c22:	89 08                	mov    %ecx,(%eax)
    kfree(P2V(PTE_ADDR(*pgtble)));
80104c24:	89 14 24             	mov    %edx,(%esp)
80104c27:	e8 b4 db ff ff       	call   801027e0 <kfree>

    lcr3(V2P(p->pgdir));
80104c2c:	8b 46 04             	mov    0x4(%esi),%eax
80104c2f:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80104c34:	0f 22 d8             	mov    %eax,%cr3


    if (DEBUGMODE == 2 && notShell() )
        cprintf(">SWAPOUTPAGE-DONE!\n");
}
80104c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c3a:	5b                   	pop    %ebx
80104c3b:	5e                   	pop    %esi
80104c3c:	5f                   	pop    %edi
80104c3d:	5d                   	pop    %ebp
80104c3e:	c3                   	ret    
80104c3f:	90                   	nop
            *tmppgtble = PTE_A_0(*tmppgtble);
80104c40:	83 e2 df             	and    $0xffffffdf,%edx
            valid++;
80104c43:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
            *tmppgtble = PTE_A_0(*tmppgtble);
80104c47:	89 10                	mov    %edx,(%eax)
            pg->sequel = p->pagesequel++;
80104c49:	8b 86 4c 04 00 00    	mov    0x44c(%esi),%eax
80104c4f:	8d 50 01             	lea    0x1(%eax),%edx
80104c52:	89 96 4c 04 00 00    	mov    %edx,0x44c(%esi)
80104c58:	89 47 08             	mov    %eax,0x8(%edi)
            valid++;
80104c5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    while( !found && valid < MAX_TOTAL_PAGES ) {
80104c5e:	83 f8 1f             	cmp    $0x1f,%eax
80104c61:	0f 8e f1 fe ff ff    	jle    80104b58 <swapOutPage+0x48>
        panic2("didnt find page to swap out is SCFIFO");
80104c67:	83 ec 0c             	sub    $0xc,%esp
80104c6a:	68 fc 8b 10 80       	push   $0x80108bfc
80104c6f:	e8 0c f2 ff ff       	call   80103e80 <panic2>
80104c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("p->entries:\t");
80104c78:	83 ec 0c             	sub    $0xc,%esp
80104c7b:	8d 9e 00 04 00 00    	lea    0x400(%esi),%ebx
80104c81:	81 c6 40 04 00 00    	add    $0x440,%esi
80104c87:	68 ec 8a 10 80       	push   $0x80108aec
80104c8c:	e8 cf b9 ff ff       	call   80100660 <cprintf>
80104c91:	83 c4 10             	add    $0x10,%esp
            cprintf("%d  ", p->swapFileEntries[i]);
80104c94:	83 ec 08             	sub    $0x8,%esp
80104c97:	ff 33                	pushl  (%ebx)
80104c99:	83 c3 04             	add    $0x4,%ebx
80104c9c:	68 cf 8a 10 80       	push   $0x80108acf
80104ca1:	e8 ba b9 ff ff       	call   80100660 <cprintf>
        for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80104ca6:	83 c4 10             	add    $0x10,%esp
80104ca9:	39 de                	cmp    %ebx,%esi
80104cab:	75 e7                	jne    80104c94 <swapOutPage+0x184>
        panic2("ERROR - there is no free entry in p->swapFileEntries!\n");
80104cad:	83 ec 0c             	sub    $0xc,%esp
80104cb0:	68 c4 8b 10 80       	push   $0x80108bc4
80104cb5:	e8 c6 f1 ff ff       	call   80103e80 <panic2>
        panic2("writeToSwapFile Error!\n");
80104cba:	83 ec 0c             	sub    $0xc,%esp
80104cbd:	68 d4 8a 10 80       	push   $0x80108ad4
80104cc2:	e8 b9 f1 ff ff       	call   80103e80 <panic2>
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <updatePTE>:

void
updatePTE(void){
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	53                   	push   %ebx
80104cd4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80104cd7:	e8 64 03 00 00       	call   80105040 <pushcli>
    c = mycpu();
80104cdc:	e8 ef ef ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104ce1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104ce7:	e8 54 04 00 00       	call   80105140 <popcli>
    lcr3(V2P(myproc()->pgdir));
80104cec:	8b 43 04             	mov    0x4(%ebx),%eax
80104cef:	05 00 00 00 80       	add    $0x80000000,%eax
80104cf4:	0f 22 d8             	mov    %eax,%cr3
}
80104cf7:	83 c4 04             	add    $0x4,%esp
80104cfa:	5b                   	pop    %ebx
80104cfb:	5d                   	pop    %ebp
80104cfc:	c3                   	ret    
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi

80104d00 <turnOnPM>:
turnOnPM( void *p ){
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	56                   	push   %esi
80104d04:	53                   	push   %ebx
80104d05:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80104d08:	e8 33 03 00 00       	call   80105040 <pushcli>
    c = mycpu();
80104d0d:	e8 be ef ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104d12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104d18:	e8 23 04 00 00       	call   80105140 <popcli>
    pte = walkpgdir2(myproc()->pgdir, p, 0); //find the address
80104d1d:	83 ec 04             	sub    $0x4,%esp
80104d20:	6a 00                	push   $0x0
80104d22:	56                   	push   %esi
80104d23:	ff 73 04             	pushl  0x4(%ebx)
80104d26:	e8 75 2c 00 00       	call   801079a0 <walkpgdir2>
    updatePTE();
80104d2b:	83 c4 10             	add    $0x10,%esp
    *pte = PTE_PM_1(*pte); //turn on flag, defined in mmu.h
80104d2e:	81 08 00 04 00 00    	orl    $0x400,(%eax)
}
80104d34:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d37:	5b                   	pop    %ebx
80104d38:	5e                   	pop    %esi
80104d39:	5d                   	pop    %ebp
    updatePTE();
80104d3a:	eb 94                	jmp    80104cd0 <updatePTE>
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d40 <turnOffPM>:
turnOffPM( void *p ){
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80104d48:	e8 f3 02 00 00       	call   80105040 <pushcli>
    c = mycpu();
80104d4d:	e8 7e ef ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104d52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104d58:	e8 e3 03 00 00       	call   80105140 <popcli>
    pte = walkpgdir2(myproc()->pgdir, p, 0); //find the address
80104d5d:	83 ec 04             	sub    $0x4,%esp
80104d60:	6a 00                	push   $0x0
80104d62:	56                   	push   %esi
80104d63:	ff 73 04             	pushl  0x4(%ebx)
80104d66:	e8 35 2c 00 00       	call   801079a0 <walkpgdir2>
    updatePTE();
80104d6b:	83 c4 10             	add    $0x10,%esp
    *pte = PTE_PM_0(*pte); //turn on flag, defined in mmu.h
80104d6e:	81 20 ff fb ff ff    	andl   $0xfffffbff,(%eax)
}
80104d74:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d77:	5b                   	pop    %ebx
80104d78:	5e                   	pop    %esi
80104d79:	5d                   	pop    %ebp
    updatePTE();
80104d7a:	e9 51 ff ff ff       	jmp    80104cd0 <updatePTE>
80104d7f:	90                   	nop

80104d80 <turnOffW>:
turnOffW( void *p ){
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	53                   	push   %ebx
80104d84:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80104d87:	e8 b4 02 00 00       	call   80105040 <pushcli>
    c = mycpu();
80104d8c:	e8 3f ef ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104d91:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104d97:	e8 a4 03 00 00       	call   80105140 <popcli>
    pte = walkpgdir2(myproc()->pgdir, p, 0);//find the address
80104d9c:	83 ec 04             	sub    $0x4,%esp
80104d9f:	6a 00                	push   $0x0
80104da1:	ff 75 08             	pushl  0x8(%ebp)
80104da4:	ff 73 04             	pushl  0x4(%ebx)
80104da7:	e8 f4 2b 00 00       	call   801079a0 <walkpgdir2>
    if( ( *pte & PTE_PM ) != 0){//check if flag was on before the syscall
80104dac:	8b 10                	mov    (%eax),%edx
80104dae:	83 c4 10             	add    $0x10,%esp
80104db1:	f6 c6 04             	test   $0x4,%dh
80104db4:	74 1a                	je     80104dd0 <turnOffW+0x50>
        *pte = PTE_W_0(*pte);
80104db6:	83 e2 fd             	and    $0xfffffffd,%edx
80104db9:	89 10                	mov    %edx,(%eax)
        updatePTE();
80104dbb:	e8 10 ff ff ff       	call   80104cd0 <updatePTE>
        return 1;
80104dc0:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104dc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc8:	c9                   	leave  
80104dc9:	c3                   	ret    
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd5:	eb ee                	jmp    80104dc5 <turnOffW+0x45>
80104dd7:	89 f6                	mov    %esi,%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <turnOnW>:
turnOnW( void *p ){
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80104de7:	e8 54 02 00 00       	call   80105040 <pushcli>
    c = mycpu();
80104dec:	e8 df ee ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104df1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104df7:	e8 44 03 00 00       	call   80105140 <popcli>
    pte = walkpgdir2(myproc()->pgdir, p, 0);//find the address
80104dfc:	83 ec 04             	sub    $0x4,%esp
80104dff:	6a 00                	push   $0x0
80104e01:	ff 75 08             	pushl  0x8(%ebp)
80104e04:	ff 73 04             	pushl  0x4(%ebx)
80104e07:	e8 94 2b 00 00       	call   801079a0 <walkpgdir2>
    *pte = PTE_W_1(*pte);
80104e0c:	83 08 02             	orl    $0x2,(%eax)
    updatePTE();
80104e0f:	e8 bc fe ff ff       	call   80104cd0 <updatePTE>
}
80104e14:	b8 01 00 00 00       	mov    $0x1,%eax
80104e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e1c:	c9                   	leave  
80104e1d:	c3                   	ret    
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <updateProc>:

//called from umalloc
//0/1 - update protectedPages ; 2/3 - update pagesCounter
void
updateProc(int num){
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	53                   	push   %ebx
80104e24:	83 ec 04             	sub    $0x4,%esp
80104e27:	8b 45 08             	mov    0x8(%ebp),%eax
    switch (num) {
80104e2a:	85 c0                	test   %eax,%eax
80104e2c:	74 2a                	je     80104e58 <updateProc+0x38>
80104e2e:	83 f8 01             	cmp    $0x1,%eax
80104e31:	75 1c                	jne    80104e4f <updateProc+0x2f>
    pushcli();
80104e33:	e8 08 02 00 00       	call   80105040 <pushcli>
    c = mycpu();
80104e38:	e8 93 ee ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104e3d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104e43:	e8 f8 02 00 00       	call   80105140 <popcli>
        case 1:
            myproc()->protectedPages++;
80104e48:	83 83 50 04 00 00 01 	addl   $0x1,0x450(%ebx)
        case 0:
            myproc()->protectedPages--;
            break;

    }
}
80104e4f:	83 c4 04             	add    $0x4,%esp
80104e52:	5b                   	pop    %ebx
80104e53:	5d                   	pop    %ebp
80104e54:	c3                   	ret    
80104e55:	8d 76 00             	lea    0x0(%esi),%esi
    pushcli();
80104e58:	e8 e3 01 00 00       	call   80105040 <pushcli>
    c = mycpu();
80104e5d:	e8 6e ee ff ff       	call   80103cd0 <mycpu>
    p = c->proc;
80104e62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104e68:	e8 d3 02 00 00       	call   80105140 <popcli>
            myproc()->protectedPages--;
80104e6d:	83 ab 50 04 00 00 01 	subl   $0x1,0x450(%ebx)
}
80104e74:	83 c4 04             	add    $0x4,%esp
80104e77:	5b                   	pop    %ebx
80104e78:	5d                   	pop    %ebp
80104e79:	c3                   	ret    
80104e7a:	66 90                	xchg   %ax,%ax
80104e7c:	66 90                	xchg   %ax,%ax
80104e7e:	66 90                	xchg   %ax,%ax

80104e80 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	53                   	push   %ebx
80104e84:	83 ec 0c             	sub    $0xc,%esp
80104e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104e8a:	68 3c 8c 10 80       	push   $0x80108c3c
80104e8f:	8d 43 04             	lea    0x4(%ebx),%eax
80104e92:	50                   	push   %eax
80104e93:	e8 f8 00 00 00       	call   80104f90 <initlock>
  lk->name = name;
80104e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104e9b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ea1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ea4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104eab:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104eae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eb1:	c9                   	leave  
80104eb2:	c3                   	ret    
80104eb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	56                   	push   %esi
80104ec4:	53                   	push   %ebx
80104ec5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ec8:	83 ec 0c             	sub    $0xc,%esp
80104ecb:	8d 73 04             	lea    0x4(%ebx),%esi
80104ece:	56                   	push   %esi
80104ecf:	e8 ac 01 00 00       	call   80105080 <acquire>
  while (lk->locked) {
80104ed4:	8b 13                	mov    (%ebx),%edx
80104ed6:	83 c4 10             	add    $0x10,%esp
80104ed9:	85 d2                	test   %edx,%edx
80104edb:	74 16                	je     80104ef3 <acquiresleep+0x33>
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ee0:	83 ec 08             	sub    $0x8,%esp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
80104ee5:	e8 16 f7 ff ff       	call   80104600 <sleep>
  while (lk->locked) {
80104eea:	8b 03                	mov    (%ebx),%eax
80104eec:	83 c4 10             	add    $0x10,%esp
80104eef:	85 c0                	test   %eax,%eax
80104ef1:	75 ed                	jne    80104ee0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104ef3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ef9:	e8 a2 ee ff ff       	call   80103da0 <myproc>
80104efe:	8b 40 10             	mov    0x10(%eax),%eax
80104f01:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104f04:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104f07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f0a:	5b                   	pop    %ebx
80104f0b:	5e                   	pop    %esi
80104f0c:	5d                   	pop    %ebp
  release(&lk->lk);
80104f0d:	e9 8e 02 00 00       	jmp    801051a0 <release>
80104f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
80104f25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f28:	83 ec 0c             	sub    $0xc,%esp
80104f2b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f2e:	56                   	push   %esi
80104f2f:	e8 4c 01 00 00       	call   80105080 <acquire>
  lk->locked = 0;
80104f34:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104f3a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104f41:	89 1c 24             	mov    %ebx,(%esp)
80104f44:	e8 27 f9 ff ff       	call   80104870 <wakeup>
  release(&lk->lk);
80104f49:	89 75 08             	mov    %esi,0x8(%ebp)
80104f4c:	83 c4 10             	add    $0x10,%esp
}
80104f4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f52:	5b                   	pop    %ebx
80104f53:	5e                   	pop    %esi
80104f54:	5d                   	pop    %ebp
  release(&lk->lk);
80104f55:	e9 46 02 00 00       	jmp    801051a0 <release>
80104f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
80104f65:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104f68:	83 ec 0c             	sub    $0xc,%esp
80104f6b:	8d 5e 04             	lea    0x4(%esi),%ebx
80104f6e:	53                   	push   %ebx
80104f6f:	e8 0c 01 00 00       	call   80105080 <acquire>
  r = lk->locked;
80104f74:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104f76:	89 1c 24             	mov    %ebx,(%esp)
80104f79:	e8 22 02 00 00       	call   801051a0 <release>
  return r;
}
80104f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f81:	89 f0                	mov    %esi,%eax
80104f83:	5b                   	pop    %ebx
80104f84:	5e                   	pop    %esi
80104f85:	5d                   	pop    %ebp
80104f86:	c3                   	ret    
80104f87:	66 90                	xchg   %ax,%ax
80104f89:	66 90                	xchg   %ax,%ax
80104f8b:	66 90                	xchg   %ax,%ax
80104f8d:	66 90                	xchg   %ax,%ax
80104f8f:	90                   	nop

80104f90 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104f96:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104f99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104f9f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104fa2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104fa9:	5d                   	pop    %ebp
80104faa:	c3                   	ret    
80104fab:	90                   	nop
80104fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104fb0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104fb1:	31 d2                	xor    %edx,%edx
{
80104fb3:	89 e5                	mov    %esp,%ebp
80104fb5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104fb6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104fbc:	83 e8 08             	sub    $0x8,%eax
80104fbf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104fc0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104fc6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104fcc:	77 1a                	ja     80104fe8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104fce:	8b 58 04             	mov    0x4(%eax),%ebx
80104fd1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104fd4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104fd7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104fd9:	83 fa 0a             	cmp    $0xa,%edx
80104fdc:	75 e2                	jne    80104fc0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104fde:	5b                   	pop    %ebx
80104fdf:	5d                   	pop    %ebp
80104fe0:	c3                   	ret    
80104fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fe8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104feb:	83 c1 28             	add    $0x28,%ecx
80104fee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ff0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ff6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ff9:	39 c1                	cmp    %eax,%ecx
80104ffb:	75 f3                	jne    80104ff0 <getcallerpcs+0x40>
}
80104ffd:	5b                   	pop    %ebx
80104ffe:	5d                   	pop    %ebp
80104fff:	c3                   	ret    

80105000 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	53                   	push   %ebx
80105004:	83 ec 04             	sub    $0x4,%esp
80105007:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010500a:	8b 02                	mov    (%edx),%eax
8010500c:	85 c0                	test   %eax,%eax
8010500e:	75 10                	jne    80105020 <holding+0x20>
}
80105010:	83 c4 04             	add    $0x4,%esp
80105013:	31 c0                	xor    %eax,%eax
80105015:	5b                   	pop    %ebx
80105016:	5d                   	pop    %ebp
80105017:	c3                   	ret    
80105018:	90                   	nop
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80105020:	8b 5a 08             	mov    0x8(%edx),%ebx
80105023:	e8 a8 ec ff ff       	call   80103cd0 <mycpu>
80105028:	39 c3                	cmp    %eax,%ebx
8010502a:	0f 94 c0             	sete   %al
}
8010502d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80105030:	0f b6 c0             	movzbl %al,%eax
}
80105033:	5b                   	pop    %ebx
80105034:	5d                   	pop    %ebp
80105035:	c3                   	ret    
80105036:	8d 76 00             	lea    0x0(%esi),%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105040 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	53                   	push   %ebx
80105044:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105047:	9c                   	pushf  
80105048:	5b                   	pop    %ebx
  asm volatile("cli");
80105049:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010504a:	e8 81 ec ff ff       	call   80103cd0 <mycpu>
8010504f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105055:	85 c0                	test   %eax,%eax
80105057:	75 11                	jne    8010506a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105059:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010505f:	e8 6c ec ff ff       	call   80103cd0 <mycpu>
80105064:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010506a:	e8 61 ec ff ff       	call   80103cd0 <mycpu>
8010506f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105076:	83 c4 04             	add    $0x4,%esp
80105079:	5b                   	pop    %ebx
8010507a:	5d                   	pop    %ebp
8010507b:	c3                   	ret    
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <acquire>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105085:	e8 b6 ff ff ff       	call   80105040 <pushcli>
  if(holding(lk))
8010508a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010508d:	8b 03                	mov    (%ebx),%eax
8010508f:	85 c0                	test   %eax,%eax
80105091:	0f 85 81 00 00 00    	jne    80105118 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80105097:	ba 01 00 00 00       	mov    $0x1,%edx
8010509c:	eb 05                	jmp    801050a3 <acquire+0x23>
8010509e:	66 90                	xchg   %ax,%ax
801050a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050a3:	89 d0                	mov    %edx,%eax
801050a5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801050a8:	85 c0                	test   %eax,%eax
801050aa:	75 f4                	jne    801050a0 <acquire+0x20>
  __sync_synchronize();
801050ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801050b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050b4:	e8 17 ec ff ff       	call   80103cd0 <mycpu>
  for(i = 0; i < 10; i++){
801050b9:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
801050bb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
801050be:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801050c1:	89 e8                	mov    %ebp,%eax
801050c3:	90                   	nop
801050c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050c8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801050ce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801050d4:	77 1a                	ja     801050f0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801050d6:	8b 58 04             	mov    0x4(%eax),%ebx
801050d9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801050dc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801050df:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801050e1:	83 fa 0a             	cmp    $0xa,%edx
801050e4:	75 e2                	jne    801050c8 <acquire+0x48>
}
801050e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050e9:	5b                   	pop    %ebx
801050ea:	5e                   	pop    %esi
801050eb:	5d                   	pop    %ebp
801050ec:	c3                   	ret    
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
801050f0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801050f3:	83 c1 28             	add    $0x28,%ecx
801050f6:	8d 76 00             	lea    0x0(%esi),%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105100:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105106:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105109:	39 c8                	cmp    %ecx,%eax
8010510b:	75 f3                	jne    80105100 <acquire+0x80>
}
8010510d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105110:	5b                   	pop    %ebx
80105111:	5e                   	pop    %esi
80105112:	5d                   	pop    %ebp
80105113:	c3                   	ret    
80105114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80105118:	8b 73 08             	mov    0x8(%ebx),%esi
8010511b:	e8 b0 eb ff ff       	call   80103cd0 <mycpu>
80105120:	39 c6                	cmp    %eax,%esi
80105122:	0f 85 6f ff ff ff    	jne    80105097 <acquire+0x17>
    panic("acquire");
80105128:	83 ec 0c             	sub    $0xc,%esp
8010512b:	68 47 8c 10 80       	push   $0x80108c47
80105130:	e8 5b b2 ff ff       	call   80100390 <panic>
80105135:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105140 <popcli>:

void
popcli(void)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105146:	9c                   	pushf  
80105147:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105148:	f6 c4 02             	test   $0x2,%ah
8010514b:	75 35                	jne    80105182 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010514d:	e8 7e eb ff ff       	call   80103cd0 <mycpu>
80105152:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105159:	78 34                	js     8010518f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010515b:	e8 70 eb ff ff       	call   80103cd0 <mycpu>
80105160:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105166:	85 d2                	test   %edx,%edx
80105168:	74 06                	je     80105170 <popcli+0x30>
    sti();
}
8010516a:	c9                   	leave  
8010516b:	c3                   	ret    
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105170:	e8 5b eb ff ff       	call   80103cd0 <mycpu>
80105175:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010517b:	85 c0                	test   %eax,%eax
8010517d:	74 eb                	je     8010516a <popcli+0x2a>
  asm volatile("sti");
8010517f:	fb                   	sti    
}
80105180:	c9                   	leave  
80105181:	c3                   	ret    
    panic("popcli - interruptible");
80105182:	83 ec 0c             	sub    $0xc,%esp
80105185:	68 4f 8c 10 80       	push   $0x80108c4f
8010518a:	e8 01 b2 ff ff       	call   80100390 <panic>
    panic("popcli");
8010518f:	83 ec 0c             	sub    $0xc,%esp
80105192:	68 66 8c 10 80       	push   $0x80108c66
80105197:	e8 f4 b1 ff ff       	call   80100390 <panic>
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051a0 <release>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	56                   	push   %esi
801051a4:	53                   	push   %ebx
801051a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801051a8:	8b 03                	mov    (%ebx),%eax
801051aa:	85 c0                	test   %eax,%eax
801051ac:	74 0c                	je     801051ba <release+0x1a>
801051ae:	8b 73 08             	mov    0x8(%ebx),%esi
801051b1:	e8 1a eb ff ff       	call   80103cd0 <mycpu>
801051b6:	39 c6                	cmp    %eax,%esi
801051b8:	74 16                	je     801051d0 <release+0x30>
    panic("release");
801051ba:	83 ec 0c             	sub    $0xc,%esp
801051bd:	68 6d 8c 10 80       	push   $0x80108c6d
801051c2:	e8 c9 b1 ff ff       	call   80100390 <panic>
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
801051d0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801051d7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801051de:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801051e3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801051e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ec:	5b                   	pop    %ebx
801051ed:	5e                   	pop    %esi
801051ee:	5d                   	pop    %ebp
  popcli();
801051ef:	e9 4c ff ff ff       	jmp    80105140 <popcli>
801051f4:	66 90                	xchg   %ax,%ax
801051f6:	66 90                	xchg   %ax,%ax
801051f8:	66 90                	xchg   %ax,%ax
801051fa:	66 90                	xchg   %ax,%ax
801051fc:	66 90                	xchg   %ax,%ax
801051fe:	66 90                	xchg   %ax,%ax

80105200 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	53                   	push   %ebx
80105205:	8b 55 08             	mov    0x8(%ebp),%edx
80105208:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010520b:	f6 c2 03             	test   $0x3,%dl
8010520e:	75 05                	jne    80105215 <memset+0x15>
80105210:	f6 c1 03             	test   $0x3,%cl
80105213:	74 13                	je     80105228 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105215:	89 d7                	mov    %edx,%edi
80105217:	8b 45 0c             	mov    0xc(%ebp),%eax
8010521a:	fc                   	cld    
8010521b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010521d:	5b                   	pop    %ebx
8010521e:	89 d0                	mov    %edx,%eax
80105220:	5f                   	pop    %edi
80105221:	5d                   	pop    %ebp
80105222:	c3                   	ret    
80105223:	90                   	nop
80105224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105228:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010522c:	c1 e9 02             	shr    $0x2,%ecx
8010522f:	89 f8                	mov    %edi,%eax
80105231:	89 fb                	mov    %edi,%ebx
80105233:	c1 e0 18             	shl    $0x18,%eax
80105236:	c1 e3 10             	shl    $0x10,%ebx
80105239:	09 d8                	or     %ebx,%eax
8010523b:	09 f8                	or     %edi,%eax
8010523d:	c1 e7 08             	shl    $0x8,%edi
80105240:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105242:	89 d7                	mov    %edx,%edi
80105244:	fc                   	cld    
80105245:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105247:	5b                   	pop    %ebx
80105248:	89 d0                	mov    %edx,%eax
8010524a:	5f                   	pop    %edi
8010524b:	5d                   	pop    %ebp
8010524c:	c3                   	ret    
8010524d:	8d 76 00             	lea    0x0(%esi),%esi

80105250 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
80105255:	53                   	push   %ebx
80105256:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105259:	8b 75 08             	mov    0x8(%ebp),%esi
8010525c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010525f:	85 db                	test   %ebx,%ebx
80105261:	74 29                	je     8010528c <memcmp+0x3c>
    if(*s1 != *s2)
80105263:	0f b6 16             	movzbl (%esi),%edx
80105266:	0f b6 0f             	movzbl (%edi),%ecx
80105269:	38 d1                	cmp    %dl,%cl
8010526b:	75 2b                	jne    80105298 <memcmp+0x48>
8010526d:	b8 01 00 00 00       	mov    $0x1,%eax
80105272:	eb 14                	jmp    80105288 <memcmp+0x38>
80105274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105278:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010527c:	83 c0 01             	add    $0x1,%eax
8010527f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105284:	38 ca                	cmp    %cl,%dl
80105286:	75 10                	jne    80105298 <memcmp+0x48>
  while(n-- > 0){
80105288:	39 d8                	cmp    %ebx,%eax
8010528a:	75 ec                	jne    80105278 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010528c:	5b                   	pop    %ebx
  return 0;
8010528d:	31 c0                	xor    %eax,%eax
}
8010528f:	5e                   	pop    %esi
80105290:	5f                   	pop    %edi
80105291:	5d                   	pop    %ebp
80105292:	c3                   	ret    
80105293:	90                   	nop
80105294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105298:	0f b6 c2             	movzbl %dl,%eax
}
8010529b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010529c:	29 c8                	sub    %ecx,%eax
}
8010529e:	5e                   	pop    %esi
8010529f:	5f                   	pop    %edi
801052a0:	5d                   	pop    %ebp
801052a1:	c3                   	ret    
801052a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	56                   	push   %esi
801052b4:	53                   	push   %ebx
801052b5:	8b 45 08             	mov    0x8(%ebp),%eax
801052b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801052bb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052be:	39 c3                	cmp    %eax,%ebx
801052c0:	73 26                	jae    801052e8 <memmove+0x38>
801052c2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801052c5:	39 c8                	cmp    %ecx,%eax
801052c7:	73 1f                	jae    801052e8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801052c9:	85 f6                	test   %esi,%esi
801052cb:	8d 56 ff             	lea    -0x1(%esi),%edx
801052ce:	74 0f                	je     801052df <memmove+0x2f>
      *--d = *--s;
801052d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801052d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801052d7:	83 ea 01             	sub    $0x1,%edx
801052da:	83 fa ff             	cmp    $0xffffffff,%edx
801052dd:	75 f1                	jne    801052d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801052df:	5b                   	pop    %ebx
801052e0:	5e                   	pop    %esi
801052e1:	5d                   	pop    %ebp
801052e2:	c3                   	ret    
801052e3:	90                   	nop
801052e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801052e8:	31 d2                	xor    %edx,%edx
801052ea:	85 f6                	test   %esi,%esi
801052ec:	74 f1                	je     801052df <memmove+0x2f>
801052ee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801052f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801052f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801052f7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801052fa:	39 d6                	cmp    %edx,%esi
801052fc:	75 f2                	jne    801052f0 <memmove+0x40>
}
801052fe:	5b                   	pop    %ebx
801052ff:	5e                   	pop    %esi
80105300:	5d                   	pop    %ebp
80105301:	c3                   	ret    
80105302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105310 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105313:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105314:	eb 9a                	jmp    801052b0 <memmove>
80105316:	8d 76 00             	lea    0x0(%esi),%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
80105325:	8b 7d 10             	mov    0x10(%ebp),%edi
80105328:	53                   	push   %ebx
80105329:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010532c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010532f:	85 ff                	test   %edi,%edi
80105331:	74 2f                	je     80105362 <strncmp+0x42>
80105333:	0f b6 01             	movzbl (%ecx),%eax
80105336:	0f b6 1e             	movzbl (%esi),%ebx
80105339:	84 c0                	test   %al,%al
8010533b:	74 37                	je     80105374 <strncmp+0x54>
8010533d:	38 c3                	cmp    %al,%bl
8010533f:	75 33                	jne    80105374 <strncmp+0x54>
80105341:	01 f7                	add    %esi,%edi
80105343:	eb 13                	jmp    80105358 <strncmp+0x38>
80105345:	8d 76 00             	lea    0x0(%esi),%esi
80105348:	0f b6 01             	movzbl (%ecx),%eax
8010534b:	84 c0                	test   %al,%al
8010534d:	74 21                	je     80105370 <strncmp+0x50>
8010534f:	0f b6 1a             	movzbl (%edx),%ebx
80105352:	89 d6                	mov    %edx,%esi
80105354:	38 d8                	cmp    %bl,%al
80105356:	75 1c                	jne    80105374 <strncmp+0x54>
    n--, p++, q++;
80105358:	8d 56 01             	lea    0x1(%esi),%edx
8010535b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010535e:	39 fa                	cmp    %edi,%edx
80105360:	75 e6                	jne    80105348 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105362:	5b                   	pop    %ebx
    return 0;
80105363:	31 c0                	xor    %eax,%eax
}
80105365:	5e                   	pop    %esi
80105366:	5f                   	pop    %edi
80105367:	5d                   	pop    %ebp
80105368:	c3                   	ret    
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105370:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105374:	29 d8                	sub    %ebx,%eax
}
80105376:	5b                   	pop    %ebx
80105377:	5e                   	pop    %esi
80105378:	5f                   	pop    %edi
80105379:	5d                   	pop    %ebp
8010537a:	c3                   	ret    
8010537b:	90                   	nop
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105380 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	56                   	push   %esi
80105384:	53                   	push   %ebx
80105385:	8b 45 08             	mov    0x8(%ebp),%eax
80105388:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010538b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010538e:	89 c2                	mov    %eax,%edx
80105390:	eb 19                	jmp    801053ab <strncpy+0x2b>
80105392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105398:	83 c3 01             	add    $0x1,%ebx
8010539b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010539f:	83 c2 01             	add    $0x1,%edx
801053a2:	84 c9                	test   %cl,%cl
801053a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801053a7:	74 09                	je     801053b2 <strncpy+0x32>
801053a9:	89 f1                	mov    %esi,%ecx
801053ab:	85 c9                	test   %ecx,%ecx
801053ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801053b0:	7f e6                	jg     80105398 <strncpy+0x18>
    ;
  while(n-- > 0)
801053b2:	31 c9                	xor    %ecx,%ecx
801053b4:	85 f6                	test   %esi,%esi
801053b6:	7e 17                	jle    801053cf <strncpy+0x4f>
801053b8:	90                   	nop
801053b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801053c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801053c4:	89 f3                	mov    %esi,%ebx
801053c6:	83 c1 01             	add    $0x1,%ecx
801053c9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801053cb:	85 db                	test   %ebx,%ebx
801053cd:	7f f1                	jg     801053c0 <strncpy+0x40>
  return os;
}
801053cf:	5b                   	pop    %ebx
801053d0:	5e                   	pop    %esi
801053d1:	5d                   	pop    %ebp
801053d2:	c3                   	ret    
801053d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
801053e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801053e8:	8b 45 08             	mov    0x8(%ebp),%eax
801053eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801053ee:	85 c9                	test   %ecx,%ecx
801053f0:	7e 26                	jle    80105418 <safestrcpy+0x38>
801053f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801053f6:	89 c1                	mov    %eax,%ecx
801053f8:	eb 17                	jmp    80105411 <safestrcpy+0x31>
801053fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105400:	83 c2 01             	add    $0x1,%edx
80105403:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105407:	83 c1 01             	add    $0x1,%ecx
8010540a:	84 db                	test   %bl,%bl
8010540c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010540f:	74 04                	je     80105415 <safestrcpy+0x35>
80105411:	39 f2                	cmp    %esi,%edx
80105413:	75 eb                	jne    80105400 <safestrcpy+0x20>
    ;
  *s = 0;
80105415:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105418:	5b                   	pop    %ebx
80105419:	5e                   	pop    %esi
8010541a:	5d                   	pop    %ebp
8010541b:	c3                   	ret    
8010541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105420 <strlen>:

int
strlen(const char *s)
{
80105420:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105421:	31 c0                	xor    %eax,%eax
{
80105423:	89 e5                	mov    %esp,%ebp
80105425:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105428:	80 3a 00             	cmpb   $0x0,(%edx)
8010542b:	74 0c                	je     80105439 <strlen+0x19>
8010542d:	8d 76 00             	lea    0x0(%esi),%esi
80105430:	83 c0 01             	add    $0x1,%eax
80105433:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105437:	75 f7                	jne    80105430 <strlen+0x10>
    ;
  return n;
}
80105439:	5d                   	pop    %ebp
8010543a:	c3                   	ret    

8010543b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010543b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010543f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105443:	55                   	push   %ebp
  pushl %ebx
80105444:	53                   	push   %ebx
  pushl %esi
80105445:	56                   	push   %esi
  pushl %edi
80105446:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105447:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105449:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010544b:	5f                   	pop    %edi
  popl %esi
8010544c:	5e                   	pop    %esi
  popl %ebx
8010544d:	5b                   	pop    %ebx
  popl %ebp
8010544e:	5d                   	pop    %ebp
  ret
8010544f:	c3                   	ret    

80105450 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	53                   	push   %ebx
80105454:	83 ec 04             	sub    $0x4,%esp
80105457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010545a:	e8 41 e9 ff ff       	call   80103da0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010545f:	8b 00                	mov    (%eax),%eax
80105461:	39 d8                	cmp    %ebx,%eax
80105463:	76 1b                	jbe    80105480 <fetchint+0x30>
80105465:	8d 53 04             	lea    0x4(%ebx),%edx
80105468:	39 d0                	cmp    %edx,%eax
8010546a:	72 14                	jb     80105480 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010546c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010546f:	8b 13                	mov    (%ebx),%edx
80105471:	89 10                	mov    %edx,(%eax)
  return 0;
80105473:	31 c0                	xor    %eax,%eax
}
80105475:	83 c4 04             	add    $0x4,%esp
80105478:	5b                   	pop    %ebx
80105479:	5d                   	pop    %ebp
8010547a:	c3                   	ret    
8010547b:	90                   	nop
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105485:	eb ee                	jmp    80105475 <fetchint+0x25>
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	53                   	push   %ebx
80105494:	83 ec 04             	sub    $0x4,%esp
80105497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010549a:	e8 01 e9 ff ff       	call   80103da0 <myproc>

  if(addr >= curproc->sz)
8010549f:	39 18                	cmp    %ebx,(%eax)
801054a1:	76 29                	jbe    801054cc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801054a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801054a6:	89 da                	mov    %ebx,%edx
801054a8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801054aa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801054ac:	39 c3                	cmp    %eax,%ebx
801054ae:	73 1c                	jae    801054cc <fetchstr+0x3c>
    if(*s == 0)
801054b0:	80 3b 00             	cmpb   $0x0,(%ebx)
801054b3:	75 10                	jne    801054c5 <fetchstr+0x35>
801054b5:	eb 39                	jmp    801054f0 <fetchstr+0x60>
801054b7:	89 f6                	mov    %esi,%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801054c0:	80 3a 00             	cmpb   $0x0,(%edx)
801054c3:	74 1b                	je     801054e0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801054c5:	83 c2 01             	add    $0x1,%edx
801054c8:	39 d0                	cmp    %edx,%eax
801054ca:	77 f4                	ja     801054c0 <fetchstr+0x30>
    return -1;
801054cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801054d1:	83 c4 04             	add    $0x4,%esp
801054d4:	5b                   	pop    %ebx
801054d5:	5d                   	pop    %ebp
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801054e0:	83 c4 04             	add    $0x4,%esp
801054e3:	89 d0                	mov    %edx,%eax
801054e5:	29 d8                	sub    %ebx,%eax
801054e7:	5b                   	pop    %ebx
801054e8:	5d                   	pop    %ebp
801054e9:	c3                   	ret    
801054ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801054f0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801054f2:	eb dd                	jmp    801054d1 <fetchstr+0x41>
801054f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105500 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105505:	e8 96 e8 ff ff       	call   80103da0 <myproc>
8010550a:	8b 40 18             	mov    0x18(%eax),%eax
8010550d:	8b 55 08             	mov    0x8(%ebp),%edx
80105510:	8b 40 44             	mov    0x44(%eax),%eax
80105513:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105516:	e8 85 e8 ff ff       	call   80103da0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010551b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010551d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105520:	39 c6                	cmp    %eax,%esi
80105522:	73 1c                	jae    80105540 <argint+0x40>
80105524:	8d 53 08             	lea    0x8(%ebx),%edx
80105527:	39 d0                	cmp    %edx,%eax
80105529:	72 15                	jb     80105540 <argint+0x40>
  *ip = *(int*)(addr);
8010552b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010552e:	8b 53 04             	mov    0x4(%ebx),%edx
80105531:	89 10                	mov    %edx,(%eax)
  return 0;
80105533:	31 c0                	xor    %eax,%eax
}
80105535:	5b                   	pop    %ebx
80105536:	5e                   	pop    %esi
80105537:	5d                   	pop    %ebp
80105538:	c3                   	ret    
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105545:	eb ee                	jmp    80105535 <argint+0x35>
80105547:	89 f6                	mov    %esi,%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	56                   	push   %esi
80105554:	53                   	push   %ebx
80105555:	83 ec 10             	sub    $0x10,%esp
80105558:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010555b:	e8 40 e8 ff ff       	call   80103da0 <myproc>
80105560:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105562:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105565:	83 ec 08             	sub    $0x8,%esp
80105568:	50                   	push   %eax
80105569:	ff 75 08             	pushl  0x8(%ebp)
8010556c:	e8 8f ff ff ff       	call   80105500 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105571:	83 c4 10             	add    $0x10,%esp
80105574:	85 c0                	test   %eax,%eax
80105576:	78 28                	js     801055a0 <argptr+0x50>
80105578:	85 db                	test   %ebx,%ebx
8010557a:	78 24                	js     801055a0 <argptr+0x50>
8010557c:	8b 16                	mov    (%esi),%edx
8010557e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105581:	39 c2                	cmp    %eax,%edx
80105583:	76 1b                	jbe    801055a0 <argptr+0x50>
80105585:	01 c3                	add    %eax,%ebx
80105587:	39 da                	cmp    %ebx,%edx
80105589:	72 15                	jb     801055a0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010558b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010558e:	89 02                	mov    %eax,(%edx)
  return 0;
80105590:	31 c0                	xor    %eax,%eax
}
80105592:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105595:	5b                   	pop    %ebx
80105596:	5e                   	pop    %esi
80105597:	5d                   	pop    %ebp
80105598:	c3                   	ret    
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a5:	eb eb                	jmp    80105592 <argptr+0x42>
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801055b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055b9:	50                   	push   %eax
801055ba:	ff 75 08             	pushl  0x8(%ebp)
801055bd:	e8 3e ff ff ff       	call   80105500 <argint>
801055c2:	83 c4 10             	add    $0x10,%esp
801055c5:	85 c0                	test   %eax,%eax
801055c7:	78 17                	js     801055e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801055c9:	83 ec 08             	sub    $0x8,%esp
801055cc:	ff 75 0c             	pushl  0xc(%ebp)
801055cf:	ff 75 f4             	pushl  -0xc(%ebp)
801055d2:	e8 b9 fe ff ff       	call   80105490 <fetchstr>
801055d7:	83 c4 10             	add    $0x10,%esp
}
801055da:	c9                   	leave  
801055db:	c3                   	ret    
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055e5:	c9                   	leave  
801055e6:	c3                   	ret    
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <syscall>:
[SYS_updateProc]   sys_updateProc,
};

void
syscall(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	53                   	push   %ebx
801055f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801055f7:	e8 a4 e7 ff ff       	call   80103da0 <myproc>
801055fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801055fe:	8b 40 18             	mov    0x18(%eax),%eax
80105601:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105604:	8d 50 ff             	lea    -0x1(%eax),%edx
80105607:	83 fa 1c             	cmp    $0x1c,%edx
8010560a:	77 1c                	ja     80105628 <syscall+0x38>
8010560c:	8b 14 85 a0 8c 10 80 	mov    -0x7fef7360(,%eax,4),%edx
80105613:	85 d2                	test   %edx,%edx
80105615:	74 11                	je     80105628 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105617:	ff d2                	call   *%edx
80105619:	8b 53 18             	mov    0x18(%ebx),%edx
8010561c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010561f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105622:	c9                   	leave  
80105623:	c3                   	ret    
80105624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105628:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105629:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010562c:	50                   	push   %eax
8010562d:	ff 73 10             	pushl  0x10(%ebx)
80105630:	68 75 8c 10 80       	push   $0x80108c75
80105635:	e8 26 b0 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010563a:	8b 43 18             	mov    0x18(%ebx),%eax
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105647:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010564a:	c9                   	leave  
8010564b:	c3                   	ret    
8010564c:	66 90                	xchg   %ax,%ax
8010564e:	66 90                	xchg   %ax,%ax

80105650 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	56                   	push   %esi
80105654:	53                   	push   %ebx
80105655:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105657:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010565a:	89 d6                	mov    %edx,%esi
8010565c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010565f:	50                   	push   %eax
80105660:	6a 00                	push   $0x0
80105662:	e8 99 fe ff ff       	call   80105500 <argint>
80105667:	83 c4 10             	add    $0x10,%esp
8010566a:	85 c0                	test   %eax,%eax
8010566c:	78 2a                	js     80105698 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010566e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105672:	77 24                	ja     80105698 <argfd.constprop.0+0x48>
80105674:	e8 27 e7 ff ff       	call   80103da0 <myproc>
80105679:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010567c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105680:	85 c0                	test   %eax,%eax
80105682:	74 14                	je     80105698 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105684:	85 db                	test   %ebx,%ebx
80105686:	74 02                	je     8010568a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105688:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010568a:	89 06                	mov    %eax,(%esi)
  return 0;
8010568c:	31 c0                	xor    %eax,%eax
}
8010568e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105691:	5b                   	pop    %ebx
80105692:	5e                   	pop    %esi
80105693:	5d                   	pop    %ebp
80105694:	c3                   	ret    
80105695:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569d:	eb ef                	jmp    8010568e <argfd.constprop.0+0x3e>
8010569f:	90                   	nop

801056a0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801056a0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801056a1:	31 c0                	xor    %eax,%eax
{
801056a3:	89 e5                	mov    %esp,%ebp
801056a5:	56                   	push   %esi
801056a6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801056a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801056aa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801056ad:	e8 9e ff ff ff       	call   80105650 <argfd.constprop.0>
801056b2:	85 c0                	test   %eax,%eax
801056b4:	78 42                	js     801056f8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
801056b6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056b9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056bb:	e8 e0 e6 ff ff       	call   80103da0 <myproc>
801056c0:	eb 0e                	jmp    801056d0 <sys_dup+0x30>
801056c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056c8:	83 c3 01             	add    $0x1,%ebx
801056cb:	83 fb 10             	cmp    $0x10,%ebx
801056ce:	74 28                	je     801056f8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801056d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801056d4:	85 d2                	test   %edx,%edx
801056d6:	75 f0                	jne    801056c8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801056d8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
801056dc:	83 ec 0c             	sub    $0xc,%esp
801056df:	ff 75 f4             	pushl  -0xc(%ebp)
801056e2:	e8 b9 b7 ff ff       	call   80100ea0 <filedup>
  return fd;
801056e7:	83 c4 10             	add    $0x10,%esp
}
801056ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056ed:	89 d8                	mov    %ebx,%eax
801056ef:	5b                   	pop    %ebx
801056f0:	5e                   	pop    %esi
801056f1:	5d                   	pop    %ebp
801056f2:	c3                   	ret    
801056f3:	90                   	nop
801056f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801056fb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105700:	89 d8                	mov    %ebx,%eax
80105702:	5b                   	pop    %ebx
80105703:	5e                   	pop    %esi
80105704:	5d                   	pop    %ebp
80105705:	c3                   	ret    
80105706:	8d 76 00             	lea    0x0(%esi),%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105710 <sys_read>:

int
sys_read(void)
{
80105710:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105711:	31 c0                	xor    %eax,%eax
{
80105713:	89 e5                	mov    %esp,%ebp
80105715:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105718:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010571b:	e8 30 ff ff ff       	call   80105650 <argfd.constprop.0>
80105720:	85 c0                	test   %eax,%eax
80105722:	78 4c                	js     80105770 <sys_read+0x60>
80105724:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105727:	83 ec 08             	sub    $0x8,%esp
8010572a:	50                   	push   %eax
8010572b:	6a 02                	push   $0x2
8010572d:	e8 ce fd ff ff       	call   80105500 <argint>
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	85 c0                	test   %eax,%eax
80105737:	78 37                	js     80105770 <sys_read+0x60>
80105739:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573c:	83 ec 04             	sub    $0x4,%esp
8010573f:	ff 75 f0             	pushl  -0x10(%ebp)
80105742:	50                   	push   %eax
80105743:	6a 01                	push   $0x1
80105745:	e8 06 fe ff ff       	call   80105550 <argptr>
8010574a:	83 c4 10             	add    $0x10,%esp
8010574d:	85 c0                	test   %eax,%eax
8010574f:	78 1f                	js     80105770 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105751:	83 ec 04             	sub    $0x4,%esp
80105754:	ff 75 f0             	pushl  -0x10(%ebp)
80105757:	ff 75 f4             	pushl  -0xc(%ebp)
8010575a:	ff 75 ec             	pushl  -0x14(%ebp)
8010575d:	e8 ae b8 ff ff       	call   80101010 <fileread>
80105762:	83 c4 10             	add    $0x10,%esp
}
80105765:	c9                   	leave  
80105766:	c3                   	ret    
80105767:	89 f6                	mov    %esi,%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <sys_write>:

int
sys_write(void)
{
80105780:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105781:	31 c0                	xor    %eax,%eax
{
80105783:	89 e5                	mov    %esp,%ebp
80105785:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105788:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010578b:	e8 c0 fe ff ff       	call   80105650 <argfd.constprop.0>
80105790:	85 c0                	test   %eax,%eax
80105792:	78 4c                	js     801057e0 <sys_write+0x60>
80105794:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105797:	83 ec 08             	sub    $0x8,%esp
8010579a:	50                   	push   %eax
8010579b:	6a 02                	push   $0x2
8010579d:	e8 5e fd ff ff       	call   80105500 <argint>
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	85 c0                	test   %eax,%eax
801057a7:	78 37                	js     801057e0 <sys_write+0x60>
801057a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ac:	83 ec 04             	sub    $0x4,%esp
801057af:	ff 75 f0             	pushl  -0x10(%ebp)
801057b2:	50                   	push   %eax
801057b3:	6a 01                	push   $0x1
801057b5:	e8 96 fd ff ff       	call   80105550 <argptr>
801057ba:	83 c4 10             	add    $0x10,%esp
801057bd:	85 c0                	test   %eax,%eax
801057bf:	78 1f                	js     801057e0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801057c1:	83 ec 04             	sub    $0x4,%esp
801057c4:	ff 75 f0             	pushl  -0x10(%ebp)
801057c7:	ff 75 f4             	pushl  -0xc(%ebp)
801057ca:	ff 75 ec             	pushl  -0x14(%ebp)
801057cd:	e8 ce b8 ff ff       	call   801010a0 <filewrite>
801057d2:	83 c4 10             	add    $0x10,%esp
}
801057d5:	c9                   	leave  
801057d6:	c3                   	ret    
801057d7:	89 f6                	mov    %esi,%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801057e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_close>:

int
sys_close(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801057f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801057f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057fc:	e8 4f fe ff ff       	call   80105650 <argfd.constprop.0>
80105801:	85 c0                	test   %eax,%eax
80105803:	78 2b                	js     80105830 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105805:	e8 96 e5 ff ff       	call   80103da0 <myproc>
8010580a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010580d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105810:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105817:	00 
  fileclose(f);
80105818:	ff 75 f4             	pushl  -0xc(%ebp)
8010581b:	e8 d0 b6 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105820:	83 c4 10             	add    $0x10,%esp
80105823:	31 c0                	xor    %eax,%eax
}
80105825:	c9                   	leave  
80105826:	c3                   	ret    
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105835:	c9                   	leave  
80105836:	c3                   	ret    
80105837:	89 f6                	mov    %esi,%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <sys_fstat>:

int
sys_fstat(void)
{
80105840:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105841:	31 c0                	xor    %eax,%eax
{
80105843:	89 e5                	mov    %esp,%ebp
80105845:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105848:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010584b:	e8 00 fe ff ff       	call   80105650 <argfd.constprop.0>
80105850:	85 c0                	test   %eax,%eax
80105852:	78 2c                	js     80105880 <sys_fstat+0x40>
80105854:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105857:	83 ec 04             	sub    $0x4,%esp
8010585a:	6a 14                	push   $0x14
8010585c:	50                   	push   %eax
8010585d:	6a 01                	push   $0x1
8010585f:	e8 ec fc ff ff       	call   80105550 <argptr>
80105864:	83 c4 10             	add    $0x10,%esp
80105867:	85 c0                	test   %eax,%eax
80105869:	78 15                	js     80105880 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010586b:	83 ec 08             	sub    $0x8,%esp
8010586e:	ff 75 f4             	pushl  -0xc(%ebp)
80105871:	ff 75 f0             	pushl  -0x10(%ebp)
80105874:	e8 47 b7 ff ff       	call   80100fc0 <filestat>
80105879:	83 c4 10             	add    $0x10,%esp
}
8010587c:	c9                   	leave  
8010587d:	c3                   	ret    
8010587e:	66 90                	xchg   %ax,%ax
    return -1;
80105880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105885:	c9                   	leave  
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105890 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	57                   	push   %edi
80105894:	56                   	push   %esi
80105895:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105896:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105899:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010589c:	50                   	push   %eax
8010589d:	6a 00                	push   $0x0
8010589f:	e8 0c fd ff ff       	call   801055b0 <argstr>
801058a4:	83 c4 10             	add    $0x10,%esp
801058a7:	85 c0                	test   %eax,%eax
801058a9:	0f 88 fb 00 00 00    	js     801059aa <sys_link+0x11a>
801058af:	8d 45 d0             	lea    -0x30(%ebp),%eax
801058b2:	83 ec 08             	sub    $0x8,%esp
801058b5:	50                   	push   %eax
801058b6:	6a 01                	push   $0x1
801058b8:	e8 f3 fc ff ff       	call   801055b0 <argstr>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	0f 88 e2 00 00 00    	js     801059aa <sys_link+0x11a>
    return -1;

  begin_op();
801058c8:	e8 a3 d7 ff ff       	call   80103070 <begin_op>
  if((ip = namei(old)) == 0){
801058cd:	83 ec 0c             	sub    $0xc,%esp
801058d0:	ff 75 d4             	pushl  -0x2c(%ebp)
801058d3:	e8 c8 c6 ff ff       	call   80101fa0 <namei>
801058d8:	83 c4 10             	add    $0x10,%esp
801058db:	85 c0                	test   %eax,%eax
801058dd:	89 c3                	mov    %eax,%ebx
801058df:	0f 84 ea 00 00 00    	je     801059cf <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801058e5:	83 ec 0c             	sub    $0xc,%esp
801058e8:	50                   	push   %eax
801058e9:	e8 52 be ff ff       	call   80101740 <ilock>
  if(ip->type == T_DIR){
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058f6:	0f 84 bb 00 00 00    	je     801059b7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801058fc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105901:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105904:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105907:	53                   	push   %ebx
80105908:	e8 83 bd ff ff       	call   80101690 <iupdate>
  iunlock(ip);
8010590d:	89 1c 24             	mov    %ebx,(%esp)
80105910:	e8 0b bf ff ff       	call   80101820 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105915:	58                   	pop    %eax
80105916:	5a                   	pop    %edx
80105917:	57                   	push   %edi
80105918:	ff 75 d0             	pushl  -0x30(%ebp)
8010591b:	e8 a0 c6 ff ff       	call   80101fc0 <nameiparent>
80105920:	83 c4 10             	add    $0x10,%esp
80105923:	85 c0                	test   %eax,%eax
80105925:	89 c6                	mov    %eax,%esi
80105927:	74 5b                	je     80105984 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105929:	83 ec 0c             	sub    $0xc,%esp
8010592c:	50                   	push   %eax
8010592d:	e8 0e be ff ff       	call   80101740 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	8b 03                	mov    (%ebx),%eax
80105937:	39 06                	cmp    %eax,(%esi)
80105939:	75 3d                	jne    80105978 <sys_link+0xe8>
8010593b:	83 ec 04             	sub    $0x4,%esp
8010593e:	ff 73 04             	pushl  0x4(%ebx)
80105941:	57                   	push   %edi
80105942:	56                   	push   %esi
80105943:	e8 98 c5 ff ff       	call   80101ee0 <dirlink>
80105948:	83 c4 10             	add    $0x10,%esp
8010594b:	85 c0                	test   %eax,%eax
8010594d:	78 29                	js     80105978 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010594f:	83 ec 0c             	sub    $0xc,%esp
80105952:	56                   	push   %esi
80105953:	e8 78 c0 ff ff       	call   801019d0 <iunlockput>
  iput(ip);
80105958:	89 1c 24             	mov    %ebx,(%esp)
8010595b:	e8 10 bf ff ff       	call   80101870 <iput>

  end_op();
80105960:	e8 7b d7 ff ff       	call   801030e0 <end_op>

  return 0;
80105965:	83 c4 10             	add    $0x10,%esp
80105968:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010596a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010596d:	5b                   	pop    %ebx
8010596e:	5e                   	pop    %esi
8010596f:	5f                   	pop    %edi
80105970:	5d                   	pop    %ebp
80105971:	c3                   	ret    
80105972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	56                   	push   %esi
8010597c:	e8 4f c0 ff ff       	call   801019d0 <iunlockput>
    goto bad;
80105981:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105984:	83 ec 0c             	sub    $0xc,%esp
80105987:	53                   	push   %ebx
80105988:	e8 b3 bd ff ff       	call   80101740 <ilock>
  ip->nlink--;
8010598d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105992:	89 1c 24             	mov    %ebx,(%esp)
80105995:	e8 f6 bc ff ff       	call   80101690 <iupdate>
  iunlockput(ip);
8010599a:	89 1c 24             	mov    %ebx,(%esp)
8010599d:	e8 2e c0 ff ff       	call   801019d0 <iunlockput>
  end_op();
801059a2:	e8 39 d7 ff ff       	call   801030e0 <end_op>
  return -1;
801059a7:	83 c4 10             	add    $0x10,%esp
}
801059aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801059ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059b2:	5b                   	pop    %ebx
801059b3:	5e                   	pop    %esi
801059b4:	5f                   	pop    %edi
801059b5:	5d                   	pop    %ebp
801059b6:	c3                   	ret    
    iunlockput(ip);
801059b7:	83 ec 0c             	sub    $0xc,%esp
801059ba:	53                   	push   %ebx
801059bb:	e8 10 c0 ff ff       	call   801019d0 <iunlockput>
    end_op();
801059c0:	e8 1b d7 ff ff       	call   801030e0 <end_op>
    return -1;
801059c5:	83 c4 10             	add    $0x10,%esp
801059c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cd:	eb 9b                	jmp    8010596a <sys_link+0xda>
    end_op();
801059cf:	e8 0c d7 ff ff       	call   801030e0 <end_op>
    return -1;
801059d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d9:	eb 8f                	jmp    8010596a <sys_link+0xda>
801059db:	90                   	nop
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059e0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	56                   	push   %esi
801059e5:	53                   	push   %ebx
801059e6:	83 ec 1c             	sub    $0x1c,%esp
801059e9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059ec:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801059f0:	76 3e                	jbe    80105a30 <isdirempty+0x50>
801059f2:	bb 20 00 00 00       	mov    $0x20,%ebx
801059f7:	8d 7d d8             	lea    -0x28(%ebp),%edi
801059fa:	eb 0c                	jmp    80105a08 <isdirempty+0x28>
801059fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a00:	83 c3 10             	add    $0x10,%ebx
80105a03:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105a06:	73 28                	jae    80105a30 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a08:	6a 10                	push   $0x10
80105a0a:	53                   	push   %ebx
80105a0b:	57                   	push   %edi
80105a0c:	56                   	push   %esi
80105a0d:	e8 0e c0 ff ff       	call   80101a20 <readi>
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	83 f8 10             	cmp    $0x10,%eax
80105a18:	75 23                	jne    80105a3d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105a1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a1f:	74 df                	je     80105a00 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105a21:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105a24:	31 c0                	xor    %eax,%eax
}
80105a26:	5b                   	pop    %ebx
80105a27:	5e                   	pop    %esi
80105a28:	5f                   	pop    %edi
80105a29:	5d                   	pop    %ebp
80105a2a:	c3                   	ret    
80105a2b:	90                   	nop
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105a33:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105a38:	5b                   	pop    %ebx
80105a39:	5e                   	pop    %esi
80105a3a:	5f                   	pop    %edi
80105a3b:	5d                   	pop    %ebp
80105a3c:	c3                   	ret    
      panic("isdirempty: readi");
80105a3d:	83 ec 0c             	sub    $0xc,%esp
80105a40:	68 18 8d 10 80       	push   $0x80108d18
80105a45:	e8 46 a9 ff ff       	call   80100390 <panic>
80105a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a50 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	57                   	push   %edi
80105a54:	56                   	push   %esi
80105a55:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105a56:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105a59:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105a5c:	50                   	push   %eax
80105a5d:	6a 00                	push   $0x0
80105a5f:	e8 4c fb ff ff       	call   801055b0 <argstr>
80105a64:	83 c4 10             	add    $0x10,%esp
80105a67:	85 c0                	test   %eax,%eax
80105a69:	0f 88 51 01 00 00    	js     80105bc0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105a6f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105a72:	e8 f9 d5 ff ff       	call   80103070 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105a77:	83 ec 08             	sub    $0x8,%esp
80105a7a:	53                   	push   %ebx
80105a7b:	ff 75 c0             	pushl  -0x40(%ebp)
80105a7e:	e8 3d c5 ff ff       	call   80101fc0 <nameiparent>
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 c0                	test   %eax,%eax
80105a88:	89 c6                	mov    %eax,%esi
80105a8a:	0f 84 37 01 00 00    	je     80105bc7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105a90:	83 ec 0c             	sub    $0xc,%esp
80105a93:	50                   	push   %eax
80105a94:	e8 a7 bc ff ff       	call   80101740 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a99:	58                   	pop    %eax
80105a9a:	5a                   	pop    %edx
80105a9b:	68 bd 85 10 80       	push   $0x801085bd
80105aa0:	53                   	push   %ebx
80105aa1:	e8 aa c1 ff ff       	call   80101c50 <namecmp>
80105aa6:	83 c4 10             	add    $0x10,%esp
80105aa9:	85 c0                	test   %eax,%eax
80105aab:	0f 84 d7 00 00 00    	je     80105b88 <sys_unlink+0x138>
80105ab1:	83 ec 08             	sub    $0x8,%esp
80105ab4:	68 bc 85 10 80       	push   $0x801085bc
80105ab9:	53                   	push   %ebx
80105aba:	e8 91 c1 ff ff       	call   80101c50 <namecmp>
80105abf:	83 c4 10             	add    $0x10,%esp
80105ac2:	85 c0                	test   %eax,%eax
80105ac4:	0f 84 be 00 00 00    	je     80105b88 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105aca:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105acd:	83 ec 04             	sub    $0x4,%esp
80105ad0:	50                   	push   %eax
80105ad1:	53                   	push   %ebx
80105ad2:	56                   	push   %esi
80105ad3:	e8 98 c1 ff ff       	call   80101c70 <dirlookup>
80105ad8:	83 c4 10             	add    $0x10,%esp
80105adb:	85 c0                	test   %eax,%eax
80105add:	89 c3                	mov    %eax,%ebx
80105adf:	0f 84 a3 00 00 00    	je     80105b88 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105ae5:	83 ec 0c             	sub    $0xc,%esp
80105ae8:	50                   	push   %eax
80105ae9:	e8 52 bc ff ff       	call   80101740 <ilock>

  if(ip->nlink < 1)
80105aee:	83 c4 10             	add    $0x10,%esp
80105af1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105af6:	0f 8e e4 00 00 00    	jle    80105be0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105afc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b01:	74 65                	je     80105b68 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105b03:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b06:	83 ec 04             	sub    $0x4,%esp
80105b09:	6a 10                	push   $0x10
80105b0b:	6a 00                	push   $0x0
80105b0d:	57                   	push   %edi
80105b0e:	e8 ed f6 ff ff       	call   80105200 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b13:	6a 10                	push   $0x10
80105b15:	ff 75 c4             	pushl  -0x3c(%ebp)
80105b18:	57                   	push   %edi
80105b19:	56                   	push   %esi
80105b1a:	e8 01 c0 ff ff       	call   80101b20 <writei>
80105b1f:	83 c4 20             	add    $0x20,%esp
80105b22:	83 f8 10             	cmp    $0x10,%eax
80105b25:	0f 85 a8 00 00 00    	jne    80105bd3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105b2b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b30:	74 6e                	je     80105ba0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105b32:	83 ec 0c             	sub    $0xc,%esp
80105b35:	56                   	push   %esi
80105b36:	e8 95 be ff ff       	call   801019d0 <iunlockput>

  ip->nlink--;
80105b3b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b40:	89 1c 24             	mov    %ebx,(%esp)
80105b43:	e8 48 bb ff ff       	call   80101690 <iupdate>
  iunlockput(ip);
80105b48:	89 1c 24             	mov    %ebx,(%esp)
80105b4b:	e8 80 be ff ff       	call   801019d0 <iunlockput>

  end_op();
80105b50:	e8 8b d5 ff ff       	call   801030e0 <end_op>

  return 0;
80105b55:	83 c4 10             	add    $0x10,%esp
80105b58:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105b5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b5d:	5b                   	pop    %ebx
80105b5e:	5e                   	pop    %esi
80105b5f:	5f                   	pop    %edi
80105b60:	5d                   	pop    %ebp
80105b61:	c3                   	ret    
80105b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b68:	83 ec 0c             	sub    $0xc,%esp
80105b6b:	53                   	push   %ebx
80105b6c:	e8 6f fe ff ff       	call   801059e0 <isdirempty>
80105b71:	83 c4 10             	add    $0x10,%esp
80105b74:	85 c0                	test   %eax,%eax
80105b76:	75 8b                	jne    80105b03 <sys_unlink+0xb3>
    iunlockput(ip);
80105b78:	83 ec 0c             	sub    $0xc,%esp
80105b7b:	53                   	push   %ebx
80105b7c:	e8 4f be ff ff       	call   801019d0 <iunlockput>
    goto bad;
80105b81:	83 c4 10             	add    $0x10,%esp
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105b88:	83 ec 0c             	sub    $0xc,%esp
80105b8b:	56                   	push   %esi
80105b8c:	e8 3f be ff ff       	call   801019d0 <iunlockput>
  end_op();
80105b91:	e8 4a d5 ff ff       	call   801030e0 <end_op>
  return -1;
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9e:	eb ba                	jmp    80105b5a <sys_unlink+0x10a>
    dp->nlink--;
80105ba0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105ba5:	83 ec 0c             	sub    $0xc,%esp
80105ba8:	56                   	push   %esi
80105ba9:	e8 e2 ba ff ff       	call   80101690 <iupdate>
80105bae:	83 c4 10             	add    $0x10,%esp
80105bb1:	e9 7c ff ff ff       	jmp    80105b32 <sys_unlink+0xe2>
80105bb6:	8d 76 00             	lea    0x0(%esi),%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc5:	eb 93                	jmp    80105b5a <sys_unlink+0x10a>
    end_op();
80105bc7:	e8 14 d5 ff ff       	call   801030e0 <end_op>
    return -1;
80105bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd1:	eb 87                	jmp    80105b5a <sys_unlink+0x10a>
    panic("unlink: writei");
80105bd3:	83 ec 0c             	sub    $0xc,%esp
80105bd6:	68 d1 85 10 80       	push   $0x801085d1
80105bdb:	e8 b0 a7 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105be0:	83 ec 0c             	sub    $0xc,%esp
80105be3:	68 bf 85 10 80       	push   $0x801085bf
80105be8:	e8 a3 a7 ff ff       	call   80100390 <panic>
80105bed:	8d 76 00             	lea    0x0(%esi),%esi

80105bf0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
80105bf5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105bf6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105bf9:	83 ec 44             	sub    $0x44,%esp
80105bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bff:	8b 55 10             	mov    0x10(%ebp),%edx
80105c02:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105c05:	56                   	push   %esi
80105c06:	ff 75 08             	pushl  0x8(%ebp)
{
80105c09:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80105c0c:	89 55 c0             	mov    %edx,-0x40(%ebp)
80105c0f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105c12:	e8 a9 c3 ff ff       	call   80101fc0 <nameiparent>
80105c17:	83 c4 10             	add    $0x10,%esp
80105c1a:	85 c0                	test   %eax,%eax
80105c1c:	0f 84 4e 01 00 00    	je     80105d70 <create+0x180>
    return 0;
  ilock(dp);
80105c22:	83 ec 0c             	sub    $0xc,%esp
80105c25:	89 c3                	mov    %eax,%ebx
80105c27:	50                   	push   %eax
80105c28:	e8 13 bb ff ff       	call   80101740 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105c2d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105c30:	83 c4 0c             	add    $0xc,%esp
80105c33:	50                   	push   %eax
80105c34:	56                   	push   %esi
80105c35:	53                   	push   %ebx
80105c36:	e8 35 c0 ff ff       	call   80101c70 <dirlookup>
80105c3b:	83 c4 10             	add    $0x10,%esp
80105c3e:	85 c0                	test   %eax,%eax
80105c40:	89 c7                	mov    %eax,%edi
80105c42:	74 3c                	je     80105c80 <create+0x90>
    iunlockput(dp);
80105c44:	83 ec 0c             	sub    $0xc,%esp
80105c47:	53                   	push   %ebx
80105c48:	e8 83 bd ff ff       	call   801019d0 <iunlockput>
    ilock(ip);
80105c4d:	89 3c 24             	mov    %edi,(%esp)
80105c50:	e8 eb ba ff ff       	call   80101740 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105c55:	83 c4 10             	add    $0x10,%esp
80105c58:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105c5d:	0f 85 9d 00 00 00    	jne    80105d00 <create+0x110>
80105c63:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105c68:	0f 85 92 00 00 00    	jne    80105d00 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c71:	89 f8                	mov    %edi,%eax
80105c73:	5b                   	pop    %ebx
80105c74:	5e                   	pop    %esi
80105c75:	5f                   	pop    %edi
80105c76:	5d                   	pop    %ebp
80105c77:	c3                   	ret    
80105c78:	90                   	nop
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80105c80:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105c84:	83 ec 08             	sub    $0x8,%esp
80105c87:	50                   	push   %eax
80105c88:	ff 33                	pushl  (%ebx)
80105c8a:	e8 41 b9 ff ff       	call   801015d0 <ialloc>
80105c8f:	83 c4 10             	add    $0x10,%esp
80105c92:	85 c0                	test   %eax,%eax
80105c94:	89 c7                	mov    %eax,%edi
80105c96:	0f 84 e8 00 00 00    	je     80105d84 <create+0x194>
  ilock(ip);
80105c9c:	83 ec 0c             	sub    $0xc,%esp
80105c9f:	50                   	push   %eax
80105ca0:	e8 9b ba ff ff       	call   80101740 <ilock>
  ip->major = major;
80105ca5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105ca9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105cad:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105cb1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105cb5:	b8 01 00 00 00       	mov    $0x1,%eax
80105cba:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105cbe:	89 3c 24             	mov    %edi,(%esp)
80105cc1:	e8 ca b9 ff ff       	call   80101690 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105cc6:	83 c4 10             	add    $0x10,%esp
80105cc9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80105cce:	74 50                	je     80105d20 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105cd0:	83 ec 04             	sub    $0x4,%esp
80105cd3:	ff 77 04             	pushl  0x4(%edi)
80105cd6:	56                   	push   %esi
80105cd7:	53                   	push   %ebx
80105cd8:	e8 03 c2 ff ff       	call   80101ee0 <dirlink>
80105cdd:	83 c4 10             	add    $0x10,%esp
80105ce0:	85 c0                	test   %eax,%eax
80105ce2:	0f 88 8f 00 00 00    	js     80105d77 <create+0x187>
  iunlockput(dp);
80105ce8:	83 ec 0c             	sub    $0xc,%esp
80105ceb:	53                   	push   %ebx
80105cec:	e8 df bc ff ff       	call   801019d0 <iunlockput>
  return ip;
80105cf1:	83 c4 10             	add    $0x10,%esp
}
80105cf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cf7:	89 f8                	mov    %edi,%eax
80105cf9:	5b                   	pop    %ebx
80105cfa:	5e                   	pop    %esi
80105cfb:	5f                   	pop    %edi
80105cfc:	5d                   	pop    %ebp
80105cfd:	c3                   	ret    
80105cfe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105d00:	83 ec 0c             	sub    $0xc,%esp
80105d03:	57                   	push   %edi
    return 0;
80105d04:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105d06:	e8 c5 bc ff ff       	call   801019d0 <iunlockput>
    return 0;
80105d0b:	83 c4 10             	add    $0x10,%esp
}
80105d0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d11:	89 f8                	mov    %edi,%eax
80105d13:	5b                   	pop    %ebx
80105d14:	5e                   	pop    %esi
80105d15:	5f                   	pop    %edi
80105d16:	5d                   	pop    %ebp
80105d17:	c3                   	ret    
80105d18:	90                   	nop
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105d20:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105d25:	83 ec 0c             	sub    $0xc,%esp
80105d28:	53                   	push   %ebx
80105d29:	e8 62 b9 ff ff       	call   80101690 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105d2e:	83 c4 0c             	add    $0xc,%esp
80105d31:	ff 77 04             	pushl  0x4(%edi)
80105d34:	68 bd 85 10 80       	push   $0x801085bd
80105d39:	57                   	push   %edi
80105d3a:	e8 a1 c1 ff ff       	call   80101ee0 <dirlink>
80105d3f:	83 c4 10             	add    $0x10,%esp
80105d42:	85 c0                	test   %eax,%eax
80105d44:	78 1c                	js     80105d62 <create+0x172>
80105d46:	83 ec 04             	sub    $0x4,%esp
80105d49:	ff 73 04             	pushl  0x4(%ebx)
80105d4c:	68 bc 85 10 80       	push   $0x801085bc
80105d51:	57                   	push   %edi
80105d52:	e8 89 c1 ff ff       	call   80101ee0 <dirlink>
80105d57:	83 c4 10             	add    $0x10,%esp
80105d5a:	85 c0                	test   %eax,%eax
80105d5c:	0f 89 6e ff ff ff    	jns    80105cd0 <create+0xe0>
      panic("create dots");
80105d62:	83 ec 0c             	sub    $0xc,%esp
80105d65:	68 39 8d 10 80       	push   $0x80108d39
80105d6a:	e8 21 a6 ff ff       	call   80100390 <panic>
80105d6f:	90                   	nop
    return 0;
80105d70:	31 ff                	xor    %edi,%edi
80105d72:	e9 f7 fe ff ff       	jmp    80105c6e <create+0x7e>
    panic("create: dirlink");
80105d77:	83 ec 0c             	sub    $0xc,%esp
80105d7a:	68 45 8d 10 80       	push   $0x80108d45
80105d7f:	e8 0c a6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105d84:	83 ec 0c             	sub    $0xc,%esp
80105d87:	68 2a 8d 10 80       	push   $0x80108d2a
80105d8c:	e8 ff a5 ff ff       	call   80100390 <panic>
80105d91:	eb 0d                	jmp    80105da0 <sys_open>
80105d93:	90                   	nop
80105d94:	90                   	nop
80105d95:	90                   	nop
80105d96:	90                   	nop
80105d97:	90                   	nop
80105d98:	90                   	nop
80105d99:	90                   	nop
80105d9a:	90                   	nop
80105d9b:	90                   	nop
80105d9c:	90                   	nop
80105d9d:	90                   	nop
80105d9e:	90                   	nop
80105d9f:	90                   	nop

80105da0 <sys_open>:

int
sys_open(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
80105da5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105da6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105da9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105dac:	50                   	push   %eax
80105dad:	6a 00                	push   $0x0
80105daf:	e8 fc f7 ff ff       	call   801055b0 <argstr>
80105db4:	83 c4 10             	add    $0x10,%esp
80105db7:	85 c0                	test   %eax,%eax
80105db9:	0f 88 1d 01 00 00    	js     80105edc <sys_open+0x13c>
80105dbf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105dc2:	83 ec 08             	sub    $0x8,%esp
80105dc5:	50                   	push   %eax
80105dc6:	6a 01                	push   $0x1
80105dc8:	e8 33 f7 ff ff       	call   80105500 <argint>
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	85 c0                	test   %eax,%eax
80105dd2:	0f 88 04 01 00 00    	js     80105edc <sys_open+0x13c>
    return -1;

  begin_op();
80105dd8:	e8 93 d2 ff ff       	call   80103070 <begin_op>

  if(omode & O_CREATE){
80105ddd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105de1:	0f 85 a9 00 00 00    	jne    80105e90 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105de7:	83 ec 0c             	sub    $0xc,%esp
80105dea:	ff 75 e0             	pushl  -0x20(%ebp)
80105ded:	e8 ae c1 ff ff       	call   80101fa0 <namei>
80105df2:	83 c4 10             	add    $0x10,%esp
80105df5:	85 c0                	test   %eax,%eax
80105df7:	89 c6                	mov    %eax,%esi
80105df9:	0f 84 ac 00 00 00    	je     80105eab <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105dff:	83 ec 0c             	sub    $0xc,%esp
80105e02:	50                   	push   %eax
80105e03:	e8 38 b9 ff ff       	call   80101740 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e08:	83 c4 10             	add    $0x10,%esp
80105e0b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105e10:	0f 84 aa 00 00 00    	je     80105ec0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105e16:	e8 15 b0 ff ff       	call   80100e30 <filealloc>
80105e1b:	85 c0                	test   %eax,%eax
80105e1d:	89 c7                	mov    %eax,%edi
80105e1f:	0f 84 a6 00 00 00    	je     80105ecb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105e25:	e8 76 df ff ff       	call   80103da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e2a:	31 db                	xor    %ebx,%ebx
80105e2c:	eb 0e                	jmp    80105e3c <sys_open+0x9c>
80105e2e:	66 90                	xchg   %ax,%ax
80105e30:	83 c3 01             	add    $0x1,%ebx
80105e33:	83 fb 10             	cmp    $0x10,%ebx
80105e36:	0f 84 ac 00 00 00    	je     80105ee8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105e3c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105e40:	85 d2                	test   %edx,%edx
80105e42:	75 ec                	jne    80105e30 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e44:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105e47:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105e4b:	56                   	push   %esi
80105e4c:	e8 cf b9 ff ff       	call   80101820 <iunlock>
  end_op();
80105e51:	e8 8a d2 ff ff       	call   801030e0 <end_op>

  f->type = FD_INODE;
80105e56:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e5f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105e62:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105e65:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e6c:	89 d0                	mov    %edx,%eax
80105e6e:	f7 d0                	not    %eax
80105e70:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e73:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105e76:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e79:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e80:	89 d8                	mov    %ebx,%eax
80105e82:	5b                   	pop    %ebx
80105e83:	5e                   	pop    %esi
80105e84:	5f                   	pop    %edi
80105e85:	5d                   	pop    %ebp
80105e86:	c3                   	ret    
80105e87:	89 f6                	mov    %esi,%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105e90:	6a 00                	push   $0x0
80105e92:	6a 00                	push   $0x0
80105e94:	6a 02                	push   $0x2
80105e96:	ff 75 e0             	pushl  -0x20(%ebp)
80105e99:	e8 52 fd ff ff       	call   80105bf0 <create>
    if(ip == 0){
80105e9e:	83 c4 10             	add    $0x10,%esp
80105ea1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105ea3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ea5:	0f 85 6b ff ff ff    	jne    80105e16 <sys_open+0x76>
      end_op();
80105eab:	e8 30 d2 ff ff       	call   801030e0 <end_op>
      return -1;
80105eb0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105eb5:	eb c6                	jmp    80105e7d <sys_open+0xdd>
80105eb7:	89 f6                	mov    %esi,%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ec0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ec3:	85 c9                	test   %ecx,%ecx
80105ec5:	0f 84 4b ff ff ff    	je     80105e16 <sys_open+0x76>
    iunlockput(ip);
80105ecb:	83 ec 0c             	sub    $0xc,%esp
80105ece:	56                   	push   %esi
80105ecf:	e8 fc ba ff ff       	call   801019d0 <iunlockput>
    end_op();
80105ed4:	e8 07 d2 ff ff       	call   801030e0 <end_op>
    return -1;
80105ed9:	83 c4 10             	add    $0x10,%esp
80105edc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ee1:	eb 9a                	jmp    80105e7d <sys_open+0xdd>
80105ee3:	90                   	nop
80105ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105ee8:	83 ec 0c             	sub    $0xc,%esp
80105eeb:	57                   	push   %edi
80105eec:	e8 ff af ff ff       	call   80100ef0 <fileclose>
80105ef1:	83 c4 10             	add    $0x10,%esp
80105ef4:	eb d5                	jmp    80105ecb <sys_open+0x12b>
80105ef6:	8d 76 00             	lea    0x0(%esi),%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f00 <sys_mkdir>:

int
sys_mkdir(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105f06:	e8 65 d1 ff ff       	call   80103070 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f0e:	83 ec 08             	sub    $0x8,%esp
80105f11:	50                   	push   %eax
80105f12:	6a 00                	push   $0x0
80105f14:	e8 97 f6 ff ff       	call   801055b0 <argstr>
80105f19:	83 c4 10             	add    $0x10,%esp
80105f1c:	85 c0                	test   %eax,%eax
80105f1e:	78 30                	js     80105f50 <sys_mkdir+0x50>
80105f20:	6a 00                	push   $0x0
80105f22:	6a 00                	push   $0x0
80105f24:	6a 01                	push   $0x1
80105f26:	ff 75 f4             	pushl  -0xc(%ebp)
80105f29:	e8 c2 fc ff ff       	call   80105bf0 <create>
80105f2e:	83 c4 10             	add    $0x10,%esp
80105f31:	85 c0                	test   %eax,%eax
80105f33:	74 1b                	je     80105f50 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f35:	83 ec 0c             	sub    $0xc,%esp
80105f38:	50                   	push   %eax
80105f39:	e8 92 ba ff ff       	call   801019d0 <iunlockput>
  end_op();
80105f3e:	e8 9d d1 ff ff       	call   801030e0 <end_op>
  return 0;
80105f43:	83 c4 10             	add    $0x10,%esp
80105f46:	31 c0                	xor    %eax,%eax
}
80105f48:	c9                   	leave  
80105f49:	c3                   	ret    
80105f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105f50:	e8 8b d1 ff ff       	call   801030e0 <end_op>
    return -1;
80105f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f5a:	c9                   	leave  
80105f5b:	c3                   	ret    
80105f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_mknod>:

int
sys_mknod(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105f66:	e8 05 d1 ff ff       	call   80103070 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105f6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f6e:	83 ec 08             	sub    $0x8,%esp
80105f71:	50                   	push   %eax
80105f72:	6a 00                	push   $0x0
80105f74:	e8 37 f6 ff ff       	call   801055b0 <argstr>
80105f79:	83 c4 10             	add    $0x10,%esp
80105f7c:	85 c0                	test   %eax,%eax
80105f7e:	78 60                	js     80105fe0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105f80:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f83:	83 ec 08             	sub    $0x8,%esp
80105f86:	50                   	push   %eax
80105f87:	6a 01                	push   $0x1
80105f89:	e8 72 f5 ff ff       	call   80105500 <argint>
  if((argstr(0, &path)) < 0 ||
80105f8e:	83 c4 10             	add    $0x10,%esp
80105f91:	85 c0                	test   %eax,%eax
80105f93:	78 4b                	js     80105fe0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105f95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f98:	83 ec 08             	sub    $0x8,%esp
80105f9b:	50                   	push   %eax
80105f9c:	6a 02                	push   $0x2
80105f9e:	e8 5d f5 ff ff       	call   80105500 <argint>
     argint(1, &major) < 0 ||
80105fa3:	83 c4 10             	add    $0x10,%esp
80105fa6:	85 c0                	test   %eax,%eax
80105fa8:	78 36                	js     80105fe0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105faa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105fae:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105faf:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105fb3:	50                   	push   %eax
80105fb4:	6a 03                	push   $0x3
80105fb6:	ff 75 ec             	pushl  -0x14(%ebp)
80105fb9:	e8 32 fc ff ff       	call   80105bf0 <create>
80105fbe:	83 c4 10             	add    $0x10,%esp
80105fc1:	85 c0                	test   %eax,%eax
80105fc3:	74 1b                	je     80105fe0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105fc5:	83 ec 0c             	sub    $0xc,%esp
80105fc8:	50                   	push   %eax
80105fc9:	e8 02 ba ff ff       	call   801019d0 <iunlockput>
  end_op();
80105fce:	e8 0d d1 ff ff       	call   801030e0 <end_op>
  return 0;
80105fd3:	83 c4 10             	add    $0x10,%esp
80105fd6:	31 c0                	xor    %eax,%eax
}
80105fd8:	c9                   	leave  
80105fd9:	c3                   	ret    
80105fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105fe0:	e8 fb d0 ff ff       	call   801030e0 <end_op>
    return -1;
80105fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fea:	c9                   	leave  
80105feb:	c3                   	ret    
80105fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ff0 <sys_chdir>:

int
sys_chdir(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	56                   	push   %esi
80105ff4:	53                   	push   %ebx
80105ff5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ff8:	e8 a3 dd ff ff       	call   80103da0 <myproc>
80105ffd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105fff:	e8 6c d0 ff ff       	call   80103070 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106004:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106007:	83 ec 08             	sub    $0x8,%esp
8010600a:	50                   	push   %eax
8010600b:	6a 00                	push   $0x0
8010600d:	e8 9e f5 ff ff       	call   801055b0 <argstr>
80106012:	83 c4 10             	add    $0x10,%esp
80106015:	85 c0                	test   %eax,%eax
80106017:	78 77                	js     80106090 <sys_chdir+0xa0>
80106019:	83 ec 0c             	sub    $0xc,%esp
8010601c:	ff 75 f4             	pushl  -0xc(%ebp)
8010601f:	e8 7c bf ff ff       	call   80101fa0 <namei>
80106024:	83 c4 10             	add    $0x10,%esp
80106027:	85 c0                	test   %eax,%eax
80106029:	89 c3                	mov    %eax,%ebx
8010602b:	74 63                	je     80106090 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010602d:	83 ec 0c             	sub    $0xc,%esp
80106030:	50                   	push   %eax
80106031:	e8 0a b7 ff ff       	call   80101740 <ilock>
  if(ip->type != T_DIR){
80106036:	83 c4 10             	add    $0x10,%esp
80106039:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010603e:	75 30                	jne    80106070 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106040:	83 ec 0c             	sub    $0xc,%esp
80106043:	53                   	push   %ebx
80106044:	e8 d7 b7 ff ff       	call   80101820 <iunlock>
  iput(curproc->cwd);
80106049:	58                   	pop    %eax
8010604a:	ff 76 68             	pushl  0x68(%esi)
8010604d:	e8 1e b8 ff ff       	call   80101870 <iput>
  end_op();
80106052:	e8 89 d0 ff ff       	call   801030e0 <end_op>
  curproc->cwd = ip;
80106057:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010605a:	83 c4 10             	add    $0x10,%esp
8010605d:	31 c0                	xor    %eax,%eax
}
8010605f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106062:	5b                   	pop    %ebx
80106063:	5e                   	pop    %esi
80106064:	5d                   	pop    %ebp
80106065:	c3                   	ret    
80106066:	8d 76 00             	lea    0x0(%esi),%esi
80106069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	53                   	push   %ebx
80106074:	e8 57 b9 ff ff       	call   801019d0 <iunlockput>
    end_op();
80106079:	e8 62 d0 ff ff       	call   801030e0 <end_op>
    return -1;
8010607e:	83 c4 10             	add    $0x10,%esp
80106081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106086:	eb d7                	jmp    8010605f <sys_chdir+0x6f>
80106088:	90                   	nop
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106090:	e8 4b d0 ff ff       	call   801030e0 <end_op>
    return -1;
80106095:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010609a:	eb c3                	jmp    8010605f <sys_chdir+0x6f>
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060a0 <sys_exec>:

int
sys_exec(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	57                   	push   %edi
801060a4:	56                   	push   %esi
801060a5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060a6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801060ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801060b2:	50                   	push   %eax
801060b3:	6a 00                	push   $0x0
801060b5:	e8 f6 f4 ff ff       	call   801055b0 <argstr>
801060ba:	83 c4 10             	add    $0x10,%esp
801060bd:	85 c0                	test   %eax,%eax
801060bf:	0f 88 87 00 00 00    	js     8010614c <sys_exec+0xac>
801060c5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801060cb:	83 ec 08             	sub    $0x8,%esp
801060ce:	50                   	push   %eax
801060cf:	6a 01                	push   $0x1
801060d1:	e8 2a f4 ff ff       	call   80105500 <argint>
801060d6:	83 c4 10             	add    $0x10,%esp
801060d9:	85 c0                	test   %eax,%eax
801060db:	78 6f                	js     8010614c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801060dd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801060e3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801060e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801060e8:	68 80 00 00 00       	push   $0x80
801060ed:	6a 00                	push   $0x0
801060ef:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801060f5:	50                   	push   %eax
801060f6:	e8 05 f1 ff ff       	call   80105200 <memset>
801060fb:	83 c4 10             	add    $0x10,%esp
801060fe:	eb 2c                	jmp    8010612c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106100:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106106:	85 c0                	test   %eax,%eax
80106108:	74 56                	je     80106160 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010610a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106110:	83 ec 08             	sub    $0x8,%esp
80106113:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106116:	52                   	push   %edx
80106117:	50                   	push   %eax
80106118:	e8 73 f3 ff ff       	call   80105490 <fetchstr>
8010611d:	83 c4 10             	add    $0x10,%esp
80106120:	85 c0                	test   %eax,%eax
80106122:	78 28                	js     8010614c <sys_exec+0xac>
  for(i=0;; i++){
80106124:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106127:	83 fb 20             	cmp    $0x20,%ebx
8010612a:	74 20                	je     8010614c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010612c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106132:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106139:	83 ec 08             	sub    $0x8,%esp
8010613c:	57                   	push   %edi
8010613d:	01 f0                	add    %esi,%eax
8010613f:	50                   	push   %eax
80106140:	e8 0b f3 ff ff       	call   80105450 <fetchint>
80106145:	83 c4 10             	add    $0x10,%esp
80106148:	85 c0                	test   %eax,%eax
8010614a:	79 b4                	jns    80106100 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010614c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010614f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106154:	5b                   	pop    %ebx
80106155:	5e                   	pop    %esi
80106156:	5f                   	pop    %edi
80106157:	5d                   	pop    %ebp
80106158:	c3                   	ret    
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106160:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106166:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106169:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106170:	00 00 00 00 
  return exec(path, argv);
80106174:	50                   	push   %eax
80106175:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010617b:	e8 90 a8 ff ff       	call   80100a10 <exec>
80106180:	83 c4 10             	add    $0x10,%esp
}
80106183:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106186:	5b                   	pop    %ebx
80106187:	5e                   	pop    %esi
80106188:	5f                   	pop    %edi
80106189:	5d                   	pop    %ebp
8010618a:	c3                   	ret    
8010618b:	90                   	nop
8010618c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106190 <sys_pipe>:

int
sys_pipe(void)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	57                   	push   %edi
80106194:	56                   	push   %esi
80106195:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106196:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106199:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010619c:	6a 08                	push   $0x8
8010619e:	50                   	push   %eax
8010619f:	6a 00                	push   $0x0
801061a1:	e8 aa f3 ff ff       	call   80105550 <argptr>
801061a6:	83 c4 10             	add    $0x10,%esp
801061a9:	85 c0                	test   %eax,%eax
801061ab:	0f 88 ae 00 00 00    	js     8010625f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801061b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801061b4:	83 ec 08             	sub    $0x8,%esp
801061b7:	50                   	push   %eax
801061b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061bb:	50                   	push   %eax
801061bc:	e8 4f d5 ff ff       	call   80103710 <pipealloc>
801061c1:	83 c4 10             	add    $0x10,%esp
801061c4:	85 c0                	test   %eax,%eax
801061c6:	0f 88 93 00 00 00    	js     8010625f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061cc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801061cf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801061d1:	e8 ca db ff ff       	call   80103da0 <myproc>
801061d6:	eb 10                	jmp    801061e8 <sys_pipe+0x58>
801061d8:	90                   	nop
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801061e0:	83 c3 01             	add    $0x1,%ebx
801061e3:	83 fb 10             	cmp    $0x10,%ebx
801061e6:	74 60                	je     80106248 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801061e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801061ec:	85 f6                	test   %esi,%esi
801061ee:	75 f0                	jne    801061e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801061f0:	8d 73 08             	lea    0x8(%ebx),%esi
801061f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801061f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801061fa:	e8 a1 db ff ff       	call   80103da0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801061ff:	31 d2                	xor    %edx,%edx
80106201:	eb 0d                	jmp    80106210 <sys_pipe+0x80>
80106203:	90                   	nop
80106204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106208:	83 c2 01             	add    $0x1,%edx
8010620b:	83 fa 10             	cmp    $0x10,%edx
8010620e:	74 28                	je     80106238 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106210:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106214:	85 c9                	test   %ecx,%ecx
80106216:	75 f0                	jne    80106208 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106218:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010621c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010621f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106221:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106224:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106227:	31 c0                	xor    %eax,%eax
}
80106229:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010622c:	5b                   	pop    %ebx
8010622d:	5e                   	pop    %esi
8010622e:	5f                   	pop    %edi
8010622f:	5d                   	pop    %ebp
80106230:	c3                   	ret    
80106231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106238:	e8 63 db ff ff       	call   80103da0 <myproc>
8010623d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106244:	00 
80106245:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106248:	83 ec 0c             	sub    $0xc,%esp
8010624b:	ff 75 e0             	pushl  -0x20(%ebp)
8010624e:	e8 9d ac ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80106253:	58                   	pop    %eax
80106254:	ff 75 e4             	pushl  -0x1c(%ebp)
80106257:	e8 94 ac ff ff       	call   80100ef0 <fileclose>
    return -1;
8010625c:	83 c4 10             	add    $0x10,%esp
8010625f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106264:	eb c3                	jmp    80106229 <sys_pipe+0x99>
80106266:	66 90                	xchg   %ax,%ax
80106268:	66 90                	xchg   %ax,%ax
8010626a:	66 90                	xchg   %ax,%ax
8010626c:	66 90                	xchg   %ax,%ax
8010626e:	66 90                	xchg   %ax,%ax

80106270 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80106276:	e8 35 e3 ff ff       	call   801045b0 <yield>
  return 0;
}
8010627b:	31 c0                	xor    %eax,%eax
8010627d:	c9                   	leave  
8010627e:	c3                   	ret    
8010627f:	90                   	nop

80106280 <sys_fork>:

int
sys_fork(void)
{
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106283:	5d                   	pop    %ebp
  return fork();
80106284:	e9 97 dd ff ff       	jmp    80104020 <fork>
80106289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106290 <sys_exit>:

int
sys_exit(void)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	83 ec 08             	sub    $0x8,%esp
  exit();
80106296:	e8 c5 e1 ff ff       	call   80104460 <exit>
  return 0;  // not reached
}
8010629b:	31 c0                	xor    %eax,%eax
8010629d:	c9                   	leave  
8010629e:	c3                   	ret    
8010629f:	90                   	nop

801062a0 <sys_wait>:

int
sys_wait(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801062a3:	5d                   	pop    %ebp
  return wait();
801062a4:	e9 17 e4 ff ff       	jmp    801046c0 <wait>
801062a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062b0 <sys_kill>:

int
sys_kill(void)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801062b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062b9:	50                   	push   %eax
801062ba:	6a 00                	push   $0x0
801062bc:	e8 3f f2 ff ff       	call   80105500 <argint>
801062c1:	83 c4 10             	add    $0x10,%esp
801062c4:	85 c0                	test   %eax,%eax
801062c6:	78 18                	js     801062e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801062c8:	83 ec 0c             	sub    $0xc,%esp
801062cb:	ff 75 f4             	pushl  -0xc(%ebp)
801062ce:	e8 fd e5 ff ff       	call   801048d0 <kill>
801062d3:	83 c4 10             	add    $0x10,%esp
}
801062d6:	c9                   	leave  
801062d7:	c3                   	ret    
801062d8:	90                   	nop
801062d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062e5:	c9                   	leave  
801062e6:	c3                   	ret    
801062e7:	89 f6                	mov    %esi,%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062f0 <sys_getpid>:

int
sys_getpid(void)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801062f6:	e8 a5 da ff ff       	call   80103da0 <myproc>
801062fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801062fe:	c9                   	leave  
801062ff:	c3                   	ret    

80106300 <sys_sbrk>:

int
sys_sbrk(void)
{
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106304:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106307:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010630a:	50                   	push   %eax
8010630b:	6a 00                	push   $0x0
8010630d:	e8 ee f1 ff ff       	call   80105500 <argint>
80106312:	83 c4 10             	add    $0x10,%esp
80106315:	85 c0                	test   %eax,%eax
80106317:	78 27                	js     80106340 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106319:	e8 82 da ff ff       	call   80103da0 <myproc>
  if(growproc(n) < 0)
8010631e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106321:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106323:	ff 75 f4             	pushl  -0xc(%ebp)
80106326:	e8 75 dc ff ff       	call   80103fa0 <growproc>
8010632b:	83 c4 10             	add    $0x10,%esp
8010632e:	85 c0                	test   %eax,%eax
80106330:	78 0e                	js     80106340 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106332:	89 d8                	mov    %ebx,%eax
80106334:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106337:	c9                   	leave  
80106338:	c3                   	ret    
80106339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106340:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106345:	eb eb                	jmp    80106332 <sys_sbrk+0x32>
80106347:	89 f6                	mov    %esi,%esi
80106349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106350 <sys_sleep>:

int
sys_sleep(void)
{
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106354:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106357:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010635a:	50                   	push   %eax
8010635b:	6a 00                	push   $0x0
8010635d:	e8 9e f1 ff ff       	call   80105500 <argint>
80106362:	83 c4 10             	add    $0x10,%esp
80106365:	85 c0                	test   %eax,%eax
80106367:	0f 88 8a 00 00 00    	js     801063f7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010636d:	83 ec 0c             	sub    $0xc,%esp
80106370:	68 a0 74 12 80       	push   $0x801274a0
80106375:	e8 06 ed ff ff       	call   80105080 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010637a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010637d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106380:	8b 1d e0 7c 12 80    	mov    0x80127ce0,%ebx
  while(ticks - ticks0 < n){
80106386:	85 d2                	test   %edx,%edx
80106388:	75 27                	jne    801063b1 <sys_sleep+0x61>
8010638a:	eb 54                	jmp    801063e0 <sys_sleep+0x90>
8010638c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106390:	83 ec 08             	sub    $0x8,%esp
80106393:	68 a0 74 12 80       	push   $0x801274a0
80106398:	68 e0 7c 12 80       	push   $0x80127ce0
8010639d:	e8 5e e2 ff ff       	call   80104600 <sleep>
  while(ticks - ticks0 < n){
801063a2:	a1 e0 7c 12 80       	mov    0x80127ce0,%eax
801063a7:	83 c4 10             	add    $0x10,%esp
801063aa:	29 d8                	sub    %ebx,%eax
801063ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801063af:	73 2f                	jae    801063e0 <sys_sleep+0x90>
    if(myproc()->killed){
801063b1:	e8 ea d9 ff ff       	call   80103da0 <myproc>
801063b6:	8b 40 24             	mov    0x24(%eax),%eax
801063b9:	85 c0                	test   %eax,%eax
801063bb:	74 d3                	je     80106390 <sys_sleep+0x40>
      release(&tickslock);
801063bd:	83 ec 0c             	sub    $0xc,%esp
801063c0:	68 a0 74 12 80       	push   $0x801274a0
801063c5:	e8 d6 ed ff ff       	call   801051a0 <release>
      return -1;
801063ca:	83 c4 10             	add    $0x10,%esp
801063cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801063d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063d5:	c9                   	leave  
801063d6:	c3                   	ret    
801063d7:	89 f6                	mov    %esi,%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801063e0:	83 ec 0c             	sub    $0xc,%esp
801063e3:	68 a0 74 12 80       	push   $0x801274a0
801063e8:	e8 b3 ed ff ff       	call   801051a0 <release>
  return 0;
801063ed:	83 c4 10             	add    $0x10,%esp
801063f0:	31 c0                	xor    %eax,%eax
}
801063f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063f5:	c9                   	leave  
801063f6:	c3                   	ret    
    return -1;
801063f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063fc:	eb f4                	jmp    801063f2 <sys_sleep+0xa2>
801063fe:	66 90                	xchg   %ax,%ax

80106400 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	53                   	push   %ebx
80106404:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106407:	68 a0 74 12 80       	push   $0x801274a0
8010640c:	e8 6f ec ff ff       	call   80105080 <acquire>
  xticks = ticks;
80106411:	8b 1d e0 7c 12 80    	mov    0x80127ce0,%ebx
  release(&tickslock);
80106417:	c7 04 24 a0 74 12 80 	movl   $0x801274a0,(%esp)
8010641e:	e8 7d ed ff ff       	call   801051a0 <release>
  return xticks;
}
80106423:	89 d8                	mov    %ebx,%eax
80106425:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106428:	c9                   	leave  
80106429:	c3                   	ret    
8010642a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106430 <sys_turnOnPM>:


// TODO MAYBE WE NEED HERE TO PASS PTR

int sys_turnOnPM(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	83 ec 20             	sub    $0x20,%esp
  int p;

  if(argint(0, &p) < 0)
80106436:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106439:	50                   	push   %eax
8010643a:	6a 00                	push   $0x0
8010643c:	e8 bf f0 ff ff       	call   80105500 <argint>
80106441:	83 c4 10             	add    $0x10,%esp
80106444:	85 c0                	test   %eax,%eax
80106446:	78 18                	js     80106460 <sys_turnOnPM+0x30>
    return -1;

  turnOnPM( (void *)p );
80106448:	83 ec 0c             	sub    $0xc,%esp
8010644b:	ff 75 f4             	pushl  -0xc(%ebp)
8010644e:	e8 ad e8 ff ff       	call   80104d00 <turnOnPM>
  return 0;
80106453:	83 c4 10             	add    $0x10,%esp
80106456:	31 c0                	xor    %eax,%eax
}
80106458:	c9                   	leave  
80106459:	c3                   	ret    
8010645a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106465:	c9                   	leave  
80106466:	c3                   	ret    
80106467:	89 f6                	mov    %esi,%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106470 <sys_turnOffPM>:

int sys_turnOffPM(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	83 ec 20             	sub    $0x20,%esp
  int p;

  if(argint(0, &p) < 0)
80106476:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106479:	50                   	push   %eax
8010647a:	6a 00                	push   $0x0
8010647c:	e8 7f f0 ff ff       	call   80105500 <argint>
80106481:	83 c4 10             	add    $0x10,%esp
80106484:	85 c0                	test   %eax,%eax
80106486:	78 18                	js     801064a0 <sys_turnOffPM+0x30>
    return -1;

  turnOffPM( (void *)p );
80106488:	83 ec 0c             	sub    $0xc,%esp
8010648b:	ff 75 f4             	pushl  -0xc(%ebp)
8010648e:	e8 ad e8 ff ff       	call   80104d40 <turnOffPM>
  return 0;
80106493:	83 c4 10             	add    $0x10,%esp
80106496:	31 c0                	xor    %eax,%eax
}
80106498:	c9                   	leave  
80106499:	c3                   	ret    
8010649a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801064a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064a5:	c9                   	leave  
801064a6:	c3                   	ret    
801064a7:	89 f6                	mov    %esi,%esi
801064a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064b0 <sys_checkOnPM>:

int sys_checkOnPM(void)
{
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	83 ec 20             	sub    $0x20,%esp
  int p;

  if(argint(0, &p) < 0)
801064b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064b9:	50                   	push   %eax
801064ba:	6a 00                	push   $0x0
801064bc:	e8 3f f0 ff ff       	call   80105500 <argint>
801064c1:	83 c4 10             	add    $0x10,%esp
801064c4:	85 c0                	test   %eax,%eax
801064c6:	78 18                	js     801064e0 <sys_checkOnPM+0x30>
    return -1;

  return checkOnPM( (void *)p );
801064c8:	83 ec 0c             	sub    $0xc,%esp
801064cb:	ff 75 f4             	pushl  -0xc(%ebp)
801064ce:	e8 cd e5 ff ff       	call   80104aa0 <checkOnPM>
801064d3:	83 c4 10             	add    $0x10,%esp
}
801064d6:	c9                   	leave  
801064d7:	c3                   	ret    
801064d8:	90                   	nop
801064d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801064e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064e5:	c9                   	leave  
801064e6:	c3                   	ret    
801064e7:	89 f6                	mov    %esi,%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064f0 <sys_turnOffW>:

int sys_turnOffW(void)
{
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	83 ec 20             	sub    $0x20,%esp
  int p;

  if(argint(0, &p) < 0)
801064f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064f9:	50                   	push   %eax
801064fa:	6a 00                	push   $0x0
801064fc:	e8 ff ef ff ff       	call   80105500 <argint>
80106501:	83 c4 10             	add    $0x10,%esp
80106504:	85 c0                	test   %eax,%eax
80106506:	78 18                	js     80106520 <sys_turnOffW+0x30>
    return -1;

  return turnOffW( (void *)p );
80106508:	83 ec 0c             	sub    $0xc,%esp
8010650b:	ff 75 f4             	pushl  -0xc(%ebp)
8010650e:	e8 6d e8 ff ff       	call   80104d80 <turnOffW>
80106513:	83 c4 10             	add    $0x10,%esp
}
80106516:	c9                   	leave  
80106517:	c3                   	ret    
80106518:	90                   	nop
80106519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106525:	c9                   	leave  
80106526:	c3                   	ret    
80106527:	89 f6                	mov    %esi,%esi
80106529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106530 <sys_turnOnW>:

int sys_turnOnW(void)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	83 ec 20             	sub    $0x20,%esp
  int p;

  if(argint(0, &p) < 0)
80106536:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106539:	50                   	push   %eax
8010653a:	6a 00                	push   $0x0
8010653c:	e8 bf ef ff ff       	call   80105500 <argint>
80106541:	83 c4 10             	add    $0x10,%esp
80106544:	85 c0                	test   %eax,%eax
80106546:	78 18                	js     80106560 <sys_turnOnW+0x30>
    return -1;

  return turnOnW( (void *)p );
80106548:	83 ec 0c             	sub    $0xc,%esp
8010654b:	ff 75 f4             	pushl  -0xc(%ebp)
8010654e:	e8 8d e8 ff ff       	call   80104de0 <turnOnW>
80106553:	83 c4 10             	add    $0x10,%esp
}
80106556:	c9                   	leave  
80106557:	c3                   	ret    
80106558:	90                   	nop
80106559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106565:	c9                   	leave  
80106566:	c3                   	ret    
80106567:	89 f6                	mov    %esi,%esi
80106569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106570 <sys_updatePTE>:

int sys_updatePTE(void)
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	83 ec 08             	sub    $0x8,%esp
  updatePTE();
80106576:	e8 55 e7 ff ff       	call   80104cd0 <updatePTE>
  return 1;
}
8010657b:	b8 01 00 00 00       	mov    $0x1,%eax
80106580:	c9                   	leave  
80106581:	c3                   	ret    
80106582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106590 <sys_updateProc>:

int sys_updateProc(void)
{
80106590:	55                   	push   %ebp
80106591:	89 e5                	mov    %esp,%ebp
80106593:	83 ec 20             	sub    $0x20,%esp
    int p;

    if(argint(0, &p) < 0)
80106596:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106599:	50                   	push   %eax
8010659a:	6a 00                	push   $0x0
8010659c:	e8 5f ef ff ff       	call   80105500 <argint>
801065a1:	83 c4 10             	add    $0x10,%esp
801065a4:	85 c0                	test   %eax,%eax
801065a6:	78 18                	js     801065c0 <sys_updateProc+0x30>
        return -1;

    updateProc(p);
801065a8:	83 ec 0c             	sub    $0xc,%esp
801065ab:	ff 75 f4             	pushl  -0xc(%ebp)
801065ae:	e8 6d e8 ff ff       	call   80104e20 <updateProc>
    return 0;
801065b3:	83 c4 10             	add    $0x10,%esp
801065b6:	31 c0                	xor    %eax,%eax
801065b8:	c9                   	leave  
801065b9:	c3                   	ret    
801065ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
801065c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065c5:	c9                   	leave  
801065c6:	c3                   	ret    

801065c7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801065c7:	1e                   	push   %ds
  pushl %es
801065c8:	06                   	push   %es
  pushl %fs
801065c9:	0f a0                	push   %fs
  pushl %gs
801065cb:	0f a8                	push   %gs
  pushal
801065cd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801065ce:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801065d2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801065d4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801065d6:	54                   	push   %esp
  call trap
801065d7:	e8 14 01 00 00       	call   801066f0 <trap>
  addl $4, %esp
801065dc:	83 c4 04             	add    $0x4,%esp

801065df <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801065df:	61                   	popa   
  popl %gs
801065e0:	0f a9                	pop    %gs
  popl %fs
801065e2:	0f a1                	pop    %fs
  popl %es
801065e4:	07                   	pop    %es
  popl %ds
801065e5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801065e6:	83 c4 08             	add    $0x8,%esp
  iret
801065e9:	cf                   	iret   
801065ea:	66 90                	xchg   %ax,%ax
801065ec:	66 90                	xchg   %ax,%ax
801065ee:	66 90                	xchg   %ax,%ax

801065f0 <tvinit>:
struct spinlock tickslock;
uint ticks, virtualAddr, problematicPage;
struct proc *p;

void
tvinit(void) {
801065f0:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801065f1:	31 c0                	xor    %eax,%eax
tvinit(void) {
801065f3:	89 e5                	mov    %esp,%ebp
801065f5:	83 ec 08             	sub    $0x8,%esp
801065f8:	90                   	nop
801065f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106600:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106607:	c7 04 c5 e2 74 12 80 	movl   $0x8e000008,-0x7fed8b1e(,%eax,8)
8010660e:	08 00 00 8e 
80106612:	66 89 14 c5 e0 74 12 	mov    %dx,-0x7fed8b20(,%eax,8)
80106619:	80 
8010661a:	c1 ea 10             	shr    $0x10,%edx
8010661d:	66 89 14 c5 e6 74 12 	mov    %dx,-0x7fed8b1a(,%eax,8)
80106624:	80 
80106625:	83 c0 01             	add    $0x1,%eax
80106628:	3d 00 01 00 00       	cmp    $0x100,%eax
8010662d:	75 d1                	jne    80106600 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010662f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

    initlock(&tickslock, "time");
80106634:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106637:	c7 05 e2 76 12 80 08 	movl   $0xef000008,0x801276e2
8010663e:	00 00 ef 
    initlock(&tickslock, "time");
80106641:	68 55 8d 10 80       	push   $0x80108d55
80106646:	68 a0 74 12 80       	push   $0x801274a0
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010664b:	66 a3 e0 76 12 80    	mov    %ax,0x801276e0
80106651:	c1 e8 10             	shr    $0x10,%eax
80106654:	66 a3 e6 76 12 80    	mov    %ax,0x801276e6
    initlock(&tickslock, "time");
8010665a:	e8 31 e9 ff ff       	call   80104f90 <initlock>
}
8010665f:	83 c4 10             	add    $0x10,%esp
80106662:	c9                   	leave  
80106663:	c3                   	ret    
80106664:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010666a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106670 <idtinit>:

void
idtinit(void) {
80106670:	55                   	push   %ebp
  pd[0] = size-1;
80106671:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106676:	89 e5                	mov    %esp,%ebp
80106678:	83 ec 10             	sub    $0x10,%esp
8010667b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010667f:	b8 e0 74 12 80       	mov    $0x801274e0,%eax
80106684:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106688:	c1 e8 10             	shr    $0x10,%eax
8010668b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010668f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106692:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80106695:	c9                   	leave  
80106696:	c3                   	ret    
80106697:	89 f6                	mov    %esi,%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066a0 <findIndexByPageId>:

//used to locate page index ofp age in  p->swapFileEntries
int findIndexByPageId(uint num) {
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	53                   	push   %ebx
801066a4:	83 ec 04             	sub    $0x4,%esp
801066a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p = myproc();
801066aa:	e8 f1 d6 ff ff       	call   80103da0 <myproc>
    for (int i=0; i<16 ;i++) {
801066af:	31 d2                	xor    %edx,%edx
801066b1:	eb 0d                	jmp    801066c0 <findIndexByPageId+0x20>
801066b3:	90                   	nop
801066b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066b8:	83 c2 01             	add    $0x1,%edx
801066bb:	83 fa 10             	cmp    $0x10,%edx
801066be:	74 18                	je     801066d8 <findIndexByPageId+0x38>
        //if this is the pid of file ->return index
        if (p->swapFileEntries[i] == num)
801066c0:	39 9c 90 00 04 00 00 	cmp    %ebx,0x400(%eax,%edx,4)
801066c7:	75 ef                	jne    801066b8 <findIndexByPageId+0x18>
            return i;
    }
    return -1;
}
801066c9:	83 c4 04             	add    $0x4,%esp
801066cc:	89 d0                	mov    %edx,%eax
801066ce:	5b                   	pop    %ebx
801066cf:	5d                   	pop    %ebp
801066d0:	c3                   	ret    
801066d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066d8:	83 c4 04             	add    $0x4,%esp
    return -1;
801066db:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}
801066e0:	89 d0                	mov    %edx,%eax
801066e2:	5b                   	pop    %ebx
801066e3:	5d                   	pop    %ebp
801066e4:	c3                   	ret    
801066e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801066e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	57                   	push   %edi
801066f4:	56                   	push   %esi
801066f5:	53                   	push   %ebx
801066f6:	83 ec 1c             	sub    $0x1c,%esp
801066f9:	8b 75 08             	mov    0x8(%ebp),%esi
    if (tf->trapno == T_SYSCALL) {
801066fc:	8b 46 30             	mov    0x30(%esi),%eax
801066ff:	83 f8 40             	cmp    $0x40,%eax
80106702:	0f 84 f0 00 00 00    	je     801067f8 <trap+0x108>
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
80106708:	83 e8 0e             	sub    $0xe,%eax
8010670b:	83 f8 31             	cmp    $0x31,%eax
8010670e:	77 10                	ja     80106720 <trap+0x30>
80106710:	ff 24 85 e0 8e 10 80 	jmp    *-0x7fef7120(,%eax,4)
80106717:	89 f6                	mov    %esi,%esi
80106719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#endif


            //PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80106720:	e8 7b d6 ff ff       	call   80103da0 <myproc>
80106725:	85 c0                	test   %eax,%eax
80106727:	0f 84 7f 04 00 00    	je     80106bac <trap+0x4bc>
8010672d:	f6 46 3c 03          	testb  $0x3,0x3c(%esi)
80106731:	0f 84 75 04 00 00    	je     80106bac <trap+0x4bc>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106737:	0f 20 d1             	mov    %cr2,%ecx
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
8010673a:	8b 56 38             	mov    0x38(%esi),%edx
8010673d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106740:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106743:	e8 08 d6 ff ff       	call   80103d50 <cpuid>
80106748:	89 c7                	mov    %eax,%edi
8010674a:	8b 46 34             	mov    0x34(%esi),%eax
8010674d:	8b 5e 30             	mov    0x30(%esi),%ebx
80106750:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
80106753:	e8 48 d6 ff ff       	call   80103da0 <myproc>
80106758:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010675b:	e8 40 d6 ff ff       	call   80103da0 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80106760:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106763:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106766:	51                   	push   %ecx
80106767:	52                   	push   %edx
                    myproc()->pid, myproc()->name, tf->trapno,
80106768:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
8010676b:	57                   	push   %edi
8010676c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010676f:	53                   	push   %ebx
                    myproc()->pid, myproc()->name, tf->trapno,
80106770:	83 c2 6c             	add    $0x6c,%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80106773:	52                   	push   %edx
80106774:	ff 70 10             	pushl  0x10(%eax)
80106777:	68 9c 8e 10 80       	push   $0x80108e9c
8010677c:	e8 df 9e ff ff       	call   80100660 <cprintf>
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
80106781:	83 c4 20             	add    $0x20,%esp
80106784:	e8 17 d6 ff ff       	call   80103da0 <myproc>
80106789:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106790:	e8 0b d6 ff ff       	call   80103da0 <myproc>
80106795:	85 c0                	test   %eax,%eax
80106797:	74 1d                	je     801067b6 <trap+0xc6>
80106799:	e8 02 d6 ff ff       	call   80103da0 <myproc>
8010679e:	8b 58 24             	mov    0x24(%eax),%ebx
801067a1:	85 db                	test   %ebx,%ebx
801067a3:	74 11                	je     801067b6 <trap+0xc6>
801067a5:	0f b7 46 3c          	movzwl 0x3c(%esi),%eax
801067a9:	83 e0 03             	and    $0x3,%eax
801067ac:	66 83 f8 03          	cmp    $0x3,%ax
801067b0:	0f 84 52 03 00 00    	je     80106b08 <trap+0x418>
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
801067b6:	e8 e5 d5 ff ff       	call   80103da0 <myproc>
801067bb:	85 c0                	test   %eax,%eax
801067bd:	74 0b                	je     801067ca <trap+0xda>
801067bf:	e8 dc d5 ff ff       	call   80103da0 <myproc>
801067c4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801067c8:	74 66                	je     80106830 <trap+0x140>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801067ca:	e8 d1 d5 ff ff       	call   80103da0 <myproc>
801067cf:	85 c0                	test   %eax,%eax
801067d1:	74 19                	je     801067ec <trap+0xfc>
801067d3:	e8 c8 d5 ff ff       	call   80103da0 <myproc>
801067d8:	8b 48 24             	mov    0x24(%eax),%ecx
801067db:	85 c9                	test   %ecx,%ecx
801067dd:	74 0d                	je     801067ec <trap+0xfc>
801067df:	0f b7 46 3c          	movzwl 0x3c(%esi),%eax
801067e3:	83 e0 03             	and    $0x3,%eax
801067e6:	66 83 f8 03          	cmp    $0x3,%ax
801067ea:	74 35                	je     80106821 <trap+0x131>
        exit();
}
801067ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067ef:	5b                   	pop    %ebx
801067f0:	5e                   	pop    %esi
801067f1:	5f                   	pop    %edi
801067f2:	5d                   	pop    %ebp
801067f3:	c3                   	ret    
801067f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed)
801067f8:	e8 a3 d5 ff ff       	call   80103da0 <myproc>
801067fd:	8b 40 24             	mov    0x24(%eax),%eax
80106800:	85 c0                	test   %eax,%eax
80106802:	0f 85 d8 02 00 00    	jne    80106ae0 <trap+0x3f0>
        myproc()->tf = tf;
80106808:	e8 93 d5 ff ff       	call   80103da0 <myproc>
8010680d:	89 70 18             	mov    %esi,0x18(%eax)
        syscall();
80106810:	e8 db ed ff ff       	call   801055f0 <syscall>
        if (myproc()->killed)
80106815:	e8 86 d5 ff ff       	call   80103da0 <myproc>
8010681a:	8b 40 24             	mov    0x24(%eax),%eax
8010681d:	85 c0                	test   %eax,%eax
8010681f:	74 cb                	je     801067ec <trap+0xfc>
}
80106821:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106824:	5b                   	pop    %ebx
80106825:	5e                   	pop    %esi
80106826:	5f                   	pop    %edi
80106827:	5d                   	pop    %ebp
            exit();
80106828:	e9 33 dc ff ff       	jmp    80104460 <exit>
8010682d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
80106830:	83 7e 30 20          	cmpl   $0x20,0x30(%esi)
80106834:	75 94                	jne    801067ca <trap+0xda>
        yield();
80106836:	e8 75 dd ff ff       	call   801045b0 <yield>
8010683b:	eb 8d                	jmp    801067ca <trap+0xda>
8010683d:	8d 76 00             	lea    0x0(%esi),%esi
            p = myproc();
80106840:	e8 5b d5 ff ff       	call   80103da0 <myproc>
80106845:	a3 80 74 12 80       	mov    %eax,0x80127480
8010684a:	0f 20 d3             	mov    %cr2,%ebx
            problematicPage = PGROUNDDOWN(virtualAddr);
8010684d:	89 d8                	mov    %ebx,%eax
            virtualAddr = rcr2();
8010684f:	89 1d e4 7c 12 80    	mov    %ebx,0x80127ce4
            problematicPage = PGROUNDDOWN(virtualAddr);
80106855:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010685a:	a3 84 74 12 80       	mov    %eax,0x80127484
            pte_t *pfree = walkpgdir2(myproc()->pgdir, (void *) virtualAddr, 0);
8010685f:	e8 3c d5 ff ff       	call   80103da0 <myproc>
80106864:	83 ec 04             	sub    $0x4,%esp
80106867:	6a 00                	push   $0x0
80106869:	53                   	push   %ebx
8010686a:	ff 70 04             	pushl  0x4(%eax)
8010686d:	e8 2e 11 00 00       	call   801079a0 <walkpgdir2>
            if( ( ( *pfree & PTE_PM ) != 0 ) && ( ( *pfree & PTE_W ) == 0 ) ){
80106872:	8b 00                	mov    (%eax),%eax
80106874:	83 c4 10             	add    $0x10,%esp
80106877:	25 02 04 00 00       	and    $0x402,%eax
8010687c:	3d 00 04 00 00       	cmp    $0x400,%eax
80106881:	0f 84 d9 02 00 00    	je     80106b60 <trap+0x470>
            p->pageFaults++;
80106887:	a1 80 74 12 80       	mov    0x80127480,%eax
                if (cg->virtAdress == (char *) problematicPage && !cg->present)
8010688c:	8b 0d 84 74 12 80    	mov    0x80127484,%ecx
            p->pageFaults++;
80106892:	83 80 54 04 00 00 01 	addl   $0x1,0x454(%eax)
            for (cg = p->pages ; cg < &p->pages[MAX_TOTAL_PAGES]; cg++ ) {
80106899:	8d 98 80 00 00 00    	lea    0x80(%eax),%ebx
8010689f:	8d 90 00 04 00 00    	lea    0x400(%eax),%edx
801068a5:	eb 10                	jmp    801068b7 <trap+0x1c7>
801068a7:	89 f6                	mov    %esi,%esi
801068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801068b0:	83 c3 1c             	add    $0x1c,%ebx
801068b3:	39 d3                	cmp    %edx,%ebx
801068b5:	73 0c                	jae    801068c3 <trap+0x1d3>
                if (cg->virtAdress == (char *) problematicPage && !cg->present)
801068b7:	39 4b 18             	cmp    %ecx,0x18(%ebx)
801068ba:	75 f4                	jne    801068b0 <trap+0x1c0>
801068bc:	8b 7b 0c             	mov    0xc(%ebx),%edi
801068bf:	85 ff                	test   %edi,%edi
801068c1:	75 ed                	jne    801068b0 <trap+0x1c0>
            if (cg == &p->pages[MAX_TOTAL_PAGES]) { //if true -didn't find the addr -error
801068c3:	39 da                	cmp    %ebx,%edx
801068c5:	0f 84 19 03 00 00    	je     80106be4 <trap+0x4f4>
            if ((!cg->active) || cg->present) {
801068cb:	8b 13                	mov    (%ebx),%edx
801068cd:	8b 7b 0c             	mov    0xc(%ebx),%edi
801068d0:	85 d2                	test   %edx,%edx
801068d2:	0f 84 18 02 00 00    	je     80106af0 <trap+0x400>
801068d8:	85 ff                	test   %edi,%edi
801068da:	0f 85 38 02 00 00    	jne    80106b18 <trap+0x428>
            if ((p->pagesCounter - p->pagesinSwap) >= 16) {
801068e0:	8b 88 48 04 00 00    	mov    0x448(%eax),%ecx
801068e6:	8b 90 44 04 00 00    	mov    0x444(%eax),%edx
            int flag = 0;
801068ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if ((p->pagesCounter - p->pagesinSwap) >= 16) {
801068f3:	29 ca                	sub    %ecx,%edx
801068f5:	83 fa 0f             	cmp    $0xf,%edx
801068f8:	7e 22                	jle    8010691c <trap+0x22c>
                if( p->pagesinSwap == 16 )
801068fa:	83 f9 10             	cmp    $0x10,%ecx
                    flag = 1;
801068fd:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
                if( p->pagesinSwap == 16 )
80106904:	74 16                	je     8010691c <trap+0x22c>
                    swapOutPage(p, p->pgdir); //func in vm.c - same use in allocuvm
80106906:	83 ec 08             	sub    $0x8,%esp
80106909:	ff 70 04             	pushl  0x4(%eax)
8010690c:	50                   	push   %eax
8010690d:	e8 fe e1 ff ff       	call   80104b10 <swapOutPage>
80106912:	83 c4 10             	add    $0x10,%esp
            int flag = 0;
80106915:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            if ((newAddr = kalloc()) == 0) {
8010691c:	e8 6f c0 ff ff       	call   80102990 <kalloc>
80106921:	85 c0                	test   %eax,%eax
80106923:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106926:	0f 84 52 02 00 00    	je     80106b7e <trap+0x48e>
            memset(newAddr, 0, PGSIZE); //clean the page
8010692c:	83 ec 04             	sub    $0x4,%esp
8010692f:	68 00 10 00 00       	push   $0x1000
80106934:	6a 00                	push   $0x0
80106936:	ff 75 e4             	pushl  -0x1c(%ebp)
80106939:	e8 c2 e8 ff ff       	call   80105200 <memset>
            if (readFromSwapFile(p, newAddr, cg->offset, PGSIZE) == -1)
8010693e:	68 00 10 00 00       	push   $0x1000
80106943:	ff 73 10             	pushl  0x10(%ebx)
80106946:	ff 75 e4             	pushl  -0x1c(%ebp)
80106949:	ff 35 80 74 12 80    	pushl  0x80127480
8010694f:	e8 ec b9 ff ff       	call   80102340 <readFromSwapFile>
80106954:	83 c4 20             	add    $0x20,%esp
80106957:	83 f8 ff             	cmp    $0xffffffff,%eax
8010695a:	0f 84 77 02 00 00    	je     80106bd7 <trap+0x4e7>
            currPTE = walkpgdir2(p->pgdir, (void *) problematicPage, 0);
80106960:	a1 80 74 12 80       	mov    0x80127480,%eax
80106965:	83 ec 04             	sub    $0x4,%esp
80106968:	6a 00                	push   $0x0
8010696a:	ff 35 84 74 12 80    	pushl  0x80127484
80106970:	ff 70 04             	pushl  0x4(%eax)
80106973:	e8 28 10 00 00       	call   801079a0 <walkpgdir2>
80106978:	89 c2                	mov    %eax,%edx
            *currPTE = PTE_P_0(*currPTE);
8010697a:	8b 00                	mov    (%eax),%eax
            *currPTE = PTE_PG_1(*currPTE);
8010697c:	89 55 dc             	mov    %edx,-0x24(%ebp)
            *currPTE = PTE_P_0(*currPTE);
8010697f:	83 e0 fe             	and    $0xfffffffe,%eax
            *currPTE = PTE_PG_1(*currPTE);
80106982:	80 cc 02             	or     $0x2,%ah
80106985:	89 02                	mov    %eax,(%edx)
            mappages2(p->pgdir, (void *) problematicPage, PGSIZE, V2P(newAddr), PTE_U | PTE_W);
80106987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010698a:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106991:	05 00 00 00 80       	add    $0x80000000,%eax
80106996:	50                   	push   %eax
80106997:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010699a:	a1 80 74 12 80       	mov    0x80127480,%eax
8010699f:	68 00 10 00 00       	push   $0x1000
801069a4:	ff 35 84 74 12 80    	pushl  0x80127484
801069aa:	ff 70 04             	pushl  0x4(%eax)
801069ad:	e8 0e 10 00 00       	call   801079c0 <mappages2>
            *currPTE = PTE_PG_0(*currPTE);
801069b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
    struct proc *p = myproc();
801069b5:	83 c4 20             	add    $0x20,%esp
            *currPTE = PTE_PG_0(*currPTE);
801069b8:	8b 02                	mov    (%edx),%eax
801069ba:	80 e4 fd             	and    $0xfd,%ah
801069bd:	83 c8 01             	or     $0x1,%eax
801069c0:	89 02                	mov    %eax,(%edx)
            i = findIndexByPageId(cg->pageid);
801069c2:	8b 53 04             	mov    0x4(%ebx),%edx
801069c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
    struct proc *p = myproc();
801069c8:	e8 d3 d3 ff ff       	call   80103da0 <myproc>
801069cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801069d0:	eb 12                	jmp    801069e4 <trap+0x2f4>
801069d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i=0; i<16 ;i++) {
801069d8:	83 c7 01             	add    $0x1,%edi
801069db:	83 ff 10             	cmp    $0x10,%edi
801069de:	0f 84 8d 01 00 00    	je     80106b71 <trap+0x481>
        if (p->swapFileEntries[i] == num)
801069e4:	3b 94 b8 00 04 00 00 	cmp    0x400(%eax,%edi,4),%edx
801069eb:	75 eb                	jne    801069d8 <trap+0x2e8>
            cg->sequel = p->pagesequel++;
801069ed:	a1 80 74 12 80       	mov    0x80127480,%eax
801069f2:	8b 90 4c 04 00 00    	mov    0x44c(%eax),%edx
801069f8:	8d 4a 01             	lea    0x1(%edx),%ecx
801069fb:	89 88 4c 04 00 00    	mov    %ecx,0x44c(%eax)
80106a01:	89 53 08             	mov    %edx,0x8(%ebx)
            cg->virtAdress = (char *) problematicPage;
80106a04:	8b 15 84 74 12 80    	mov    0x80127484,%edx
            cg->physAdress = (char *) V2P(newAddr);
80106a0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            cg->present = 1;
80106a0d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
            cg->offset = 0;
80106a14:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
            cg->virtAdress = (char *) problematicPage;
80106a1b:	89 53 18             	mov    %edx,0x18(%ebx)
            if(flag)
80106a1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cg->physAdress = (char *) V2P(newAddr);
80106a21:	89 4b 14             	mov    %ecx,0x14(%ebx)
            p->swapFileEntries[i] = 0; //clean entry- page is in RAM
80106a24:	c7 84 b8 00 04 00 00 	movl   $0x0,0x400(%eax,%edi,4)
80106a2b:	00 00 00 00 
            p->pagesinSwap--;
80106a2f:	83 a8 48 04 00 00 01 	subl   $0x1,0x448(%eax)
            if(flag)
80106a36:	85 d2                	test   %edx,%edx
80106a38:	0f 85 55 01 00 00    	jne    80106b93 <trap+0x4a3>
            lcr3(V2P(p->pgdir));
80106a3e:	8b 40 04             	mov    0x4(%eax),%eax
80106a41:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a46:	0f 22 d8             	mov    %eax,%cr3
            lapiceoi();
80106a49:	e8 d2 c1 ff ff       	call   80102c20 <lapiceoi>
            break;
80106a4e:	e9 3d fd ff ff       	jmp    80106790 <trap+0xa0>
80106a53:	90                   	nop
80106a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            if (cpuid() == 0) {
80106a58:	e8 f3 d2 ff ff       	call   80103d50 <cpuid>
80106a5d:	85 c0                	test   %eax,%eax
80106a5f:	0f 84 c3 00 00 00    	je     80106b28 <trap+0x438>
            lapiceoi();
80106a65:	e8 b6 c1 ff ff       	call   80102c20 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106a6a:	e8 31 d3 ff ff       	call   80103da0 <myproc>
80106a6f:	85 c0                	test   %eax,%eax
80106a71:	0f 85 22 fd ff ff    	jne    80106799 <trap+0xa9>
80106a77:	e9 3a fd ff ff       	jmp    801067b6 <trap+0xc6>
80106a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80106a80:	e8 5b c0 ff ff       	call   80102ae0 <kbdintr>
            lapiceoi();
80106a85:	e8 96 c1 ff ff       	call   80102c20 <lapiceoi>
            break;
80106a8a:	e9 01 fd ff ff       	jmp    80106790 <trap+0xa0>
80106a8f:	90                   	nop
            uartintr();
80106a90:	e8 db 02 00 00       	call   80106d70 <uartintr>
            lapiceoi();
80106a95:	e8 86 c1 ff ff       	call   80102c20 <lapiceoi>
            break;
80106a9a:	e9 f1 fc ff ff       	jmp    80106790 <trap+0xa0>
80106a9f:	90                   	nop
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106aa0:	0f b7 5e 3c          	movzwl 0x3c(%esi),%ebx
80106aa4:	8b 7e 38             	mov    0x38(%esi),%edi
80106aa7:	e8 a4 d2 ff ff       	call   80103d50 <cpuid>
80106aac:	57                   	push   %edi
80106aad:	53                   	push   %ebx
80106aae:	50                   	push   %eax
80106aaf:	68 98 8d 10 80       	push   $0x80108d98
80106ab4:	e8 a7 9b ff ff       	call   80100660 <cprintf>
            lapiceoi();
80106ab9:	e8 62 c1 ff ff       	call   80102c20 <lapiceoi>
            break;
80106abe:	83 c4 10             	add    $0x10,%esp
80106ac1:	e9 ca fc ff ff       	jmp    80106790 <trap+0xa0>
80106ac6:	8d 76 00             	lea    0x0(%esi),%esi
80106ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            ideintr();
80106ad0:	e8 fb b9 ff ff       	call   801024d0 <ideintr>
80106ad5:	eb 8e                	jmp    80106a65 <trap+0x375>
80106ad7:	89 f6                	mov    %esi,%esi
80106ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            exit();
80106ae0:	e8 7b d9 ff ff       	call   80104460 <exit>
80106ae5:	e9 1e fd ff ff       	jmp    80106808 <trap+0x118>
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                if (cg->present)
80106af0:	85 ff                	test   %edi,%edi
80106af2:	75 24                	jne    80106b18 <trap+0x428>
                panic("Error - problematic page is not active!\n");
80106af4:	83 ec 0c             	sub    $0xc,%esp
80106af7:	68 14 8e 10 80       	push   $0x80108e14
80106afc:	e8 8f 98 ff ff       	call   80100390 <panic>
80106b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        exit();
80106b08:	e8 53 d9 ff ff       	call   80104460 <exit>
80106b0d:	e9 a4 fc ff ff       	jmp    801067b6 <trap+0xc6>
80106b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    panic("Error - problematic page is present!\n");
80106b18:	83 ec 0c             	sub    $0xc,%esp
80106b1b:	68 ec 8d 10 80       	push   $0x80108dec
80106b20:	e8 6b 98 ff ff       	call   80100390 <panic>
80106b25:	8d 76 00             	lea    0x0(%esi),%esi
                acquire(&tickslock);
80106b28:	83 ec 0c             	sub    $0xc,%esp
80106b2b:	68 a0 74 12 80       	push   $0x801274a0
80106b30:	e8 4b e5 ff ff       	call   80105080 <acquire>
                wakeup(&ticks);
80106b35:	c7 04 24 e0 7c 12 80 	movl   $0x80127ce0,(%esp)
                ticks++;
80106b3c:	83 05 e0 7c 12 80 01 	addl   $0x1,0x80127ce0
                wakeup(&ticks);
80106b43:	e8 28 dd ff ff       	call   80104870 <wakeup>
                release(&tickslock);
80106b48:	c7 04 24 a0 74 12 80 	movl   $0x801274a0,(%esp)
80106b4f:	e8 4c e6 ff ff       	call   801051a0 <release>
80106b54:	83 c4 10             	add    $0x10,%esp
80106b57:	e9 09 ff ff ff       	jmp    80106a65 <trap+0x375>
80106b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                tf->trapno = T_GPFLT;
80106b60:	c7 46 30 0d 00 00 00 	movl   $0xd,0x30(%esi)
                lapiceoi();
80106b67:	e8 b4 c0 ff ff       	call   80102c20 <lapiceoi>
80106b6c:	e9 16 fd ff ff       	jmp    80106887 <trap+0x197>
                panic("didn't find the page offset!\n");
80106b71:	83 ec 0c             	sub    $0xc,%esp
80106b74:	68 79 8d 10 80       	push   $0x80108d79
80106b79:	e8 12 98 ff ff       	call   80100390 <panic>
                cprintf("Error- kalloc in T_PGFLT\n");
80106b7e:	83 ec 0c             	sub    $0xc,%esp
80106b81:	68 5a 8d 10 80       	push   $0x80108d5a
80106b86:	e8 d5 9a ff ff       	call   80100660 <cprintf>
                break;
80106b8b:	83 c4 10             	add    $0x10,%esp
80106b8e:	e9 fd fb ff ff       	jmp    80106790 <trap+0xa0>
                swapOutPage(p, p->pgdir); //func in vm.c - same use in allocuvm
80106b93:	83 ec 08             	sub    $0x8,%esp
80106b96:	ff 70 04             	pushl  0x4(%eax)
80106b99:	50                   	push   %eax
80106b9a:	e8 71 df ff ff       	call   80104b10 <swapOutPage>
80106b9f:	a1 80 74 12 80       	mov    0x80127480,%eax
80106ba4:	83 c4 10             	add    $0x10,%esp
80106ba7:	e9 92 fe ff ff       	jmp    80106a3e <trap+0x34e>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106bac:	0f 20 d7             	mov    %cr2,%edi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106baf:	8b 5e 38             	mov    0x38(%esi),%ebx
80106bb2:	e8 99 d1 ff ff       	call   80103d50 <cpuid>
80106bb7:	83 ec 0c             	sub    $0xc,%esp
80106bba:	57                   	push   %edi
80106bbb:	53                   	push   %ebx
80106bbc:	50                   	push   %eax
80106bbd:	ff 76 30             	pushl  0x30(%esi)
80106bc0:	68 68 8e 10 80       	push   $0x80108e68
80106bc5:	e8 96 9a ff ff       	call   80100660 <cprintf>
                panic("trap");
80106bca:	83 c4 14             	add    $0x14,%esp
80106bcd:	68 74 8d 10 80       	push   $0x80108d74
80106bd2:	e8 b9 97 ff ff       	call   80100390 <panic>
                panic("error - read from swapfile in T_PGFLT");
80106bd7:	83 ec 0c             	sub    $0xc,%esp
80106bda:	68 40 8e 10 80       	push   $0x80108e40
80106bdf:	e8 ac 97 ff ff       	call   80100390 <panic>
                panic("Error- didn't find the trap's page in T_PGFLT\n");
80106be4:	83 ec 0c             	sub    $0xc,%esp
80106be7:	68 bc 8d 10 80       	push   $0x80108dbc
80106bec:	e8 9f 97 ff ff       	call   80100390 <panic>
80106bf1:	66 90                	xchg   %ax,%ax
80106bf3:	66 90                	xchg   %ax,%ax
80106bf5:	66 90                	xchg   %ax,%ax
80106bf7:	66 90                	xchg   %ax,%ax
80106bf9:	66 90                	xchg   %ax,%ax
80106bfb:	66 90                	xchg   %ax,%ax
80106bfd:	66 90                	xchg   %ax,%ax
80106bff:	90                   	nop

80106c00 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106c00:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
{
80106c05:	55                   	push   %ebp
80106c06:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106c08:	85 c0                	test   %eax,%eax
80106c0a:	74 1c                	je     80106c28 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106c0c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106c11:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106c12:	a8 01                	test   $0x1,%al
80106c14:	74 12                	je     80106c28 <uartgetc+0x28>
80106c16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c1b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106c1c:	0f b6 c0             	movzbl %al,%eax
}
80106c1f:	5d                   	pop    %ebp
80106c20:	c3                   	ret    
80106c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106c28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c2d:	5d                   	pop    %ebp
80106c2e:	c3                   	ret    
80106c2f:	90                   	nop

80106c30 <uartputc.part.0>:
uartputc(int c)
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	57                   	push   %edi
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
80106c36:	89 c7                	mov    %eax,%edi
80106c38:	bb 80 00 00 00       	mov    $0x80,%ebx
80106c3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106c42:	83 ec 0c             	sub    $0xc,%esp
80106c45:	eb 1b                	jmp    80106c62 <uartputc.part.0+0x32>
80106c47:	89 f6                	mov    %esi,%esi
80106c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106c50:	83 ec 0c             	sub    $0xc,%esp
80106c53:	6a 0a                	push   $0xa
80106c55:	e8 e6 bf ff ff       	call   80102c40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c5a:	83 c4 10             	add    $0x10,%esp
80106c5d:	83 eb 01             	sub    $0x1,%ebx
80106c60:	74 07                	je     80106c69 <uartputc.part.0+0x39>
80106c62:	89 f2                	mov    %esi,%edx
80106c64:	ec                   	in     (%dx),%al
80106c65:	a8 20                	test   $0x20,%al
80106c67:	74 e7                	je     80106c50 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c69:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106c6e:	89 f8                	mov    %edi,%eax
80106c70:	ee                   	out    %al,(%dx)
}
80106c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c74:	5b                   	pop    %ebx
80106c75:	5e                   	pop    %esi
80106c76:	5f                   	pop    %edi
80106c77:	5d                   	pop    %ebp
80106c78:	c3                   	ret    
80106c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c80 <uartinit>:
{
80106c80:	55                   	push   %ebp
80106c81:	31 c9                	xor    %ecx,%ecx
80106c83:	89 c8                	mov    %ecx,%eax
80106c85:	89 e5                	mov    %esp,%ebp
80106c87:	57                   	push   %edi
80106c88:	56                   	push   %esi
80106c89:	53                   	push   %ebx
80106c8a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106c8f:	89 da                	mov    %ebx,%edx
80106c91:	83 ec 0c             	sub    $0xc,%esp
80106c94:	ee                   	out    %al,(%dx)
80106c95:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106c9a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106c9f:	89 fa                	mov    %edi,%edx
80106ca1:	ee                   	out    %al,(%dx)
80106ca2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106ca7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106cac:	ee                   	out    %al,(%dx)
80106cad:	be f9 03 00 00       	mov    $0x3f9,%esi
80106cb2:	89 c8                	mov    %ecx,%eax
80106cb4:	89 f2                	mov    %esi,%edx
80106cb6:	ee                   	out    %al,(%dx)
80106cb7:	b8 03 00 00 00       	mov    $0x3,%eax
80106cbc:	89 fa                	mov    %edi,%edx
80106cbe:	ee                   	out    %al,(%dx)
80106cbf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106cc4:	89 c8                	mov    %ecx,%eax
80106cc6:	ee                   	out    %al,(%dx)
80106cc7:	b8 01 00 00 00       	mov    $0x1,%eax
80106ccc:	89 f2                	mov    %esi,%edx
80106cce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ccf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106cd4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106cd5:	3c ff                	cmp    $0xff,%al
80106cd7:	74 5a                	je     80106d33 <uartinit+0xb3>
  uart = 1;
80106cd9:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
80106ce0:	00 00 00 
80106ce3:	89 da                	mov    %ebx,%edx
80106ce5:	ec                   	in     (%dx),%al
80106ce6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ceb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106cec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106cef:	bb a8 8f 10 80       	mov    $0x80108fa8,%ebx
  ioapicenable(IRQ_COM1, 0);
80106cf4:	6a 00                	push   $0x0
80106cf6:	6a 04                	push   $0x4
80106cf8:	e8 23 ba ff ff       	call   80102720 <ioapicenable>
80106cfd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106d00:	b8 78 00 00 00       	mov    $0x78,%eax
80106d05:	eb 13                	jmp    80106d1a <uartinit+0x9a>
80106d07:	89 f6                	mov    %esi,%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d10:	83 c3 01             	add    $0x1,%ebx
80106d13:	0f be 03             	movsbl (%ebx),%eax
80106d16:	84 c0                	test   %al,%al
80106d18:	74 19                	je     80106d33 <uartinit+0xb3>
  if(!uart)
80106d1a:	8b 15 c0 c5 10 80    	mov    0x8010c5c0,%edx
80106d20:	85 d2                	test   %edx,%edx
80106d22:	74 ec                	je     80106d10 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106d24:	83 c3 01             	add    $0x1,%ebx
80106d27:	e8 04 ff ff ff       	call   80106c30 <uartputc.part.0>
80106d2c:	0f be 03             	movsbl (%ebx),%eax
80106d2f:	84 c0                	test   %al,%al
80106d31:	75 e7                	jne    80106d1a <uartinit+0x9a>
}
80106d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d36:	5b                   	pop    %ebx
80106d37:	5e                   	pop    %esi
80106d38:	5f                   	pop    %edi
80106d39:	5d                   	pop    %ebp
80106d3a:	c3                   	ret    
80106d3b:	90                   	nop
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d40 <uartputc>:
  if(!uart)
80106d40:	8b 15 c0 c5 10 80    	mov    0x8010c5c0,%edx
{
80106d46:	55                   	push   %ebp
80106d47:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106d49:	85 d2                	test   %edx,%edx
{
80106d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106d4e:	74 10                	je     80106d60 <uartputc+0x20>
}
80106d50:	5d                   	pop    %ebp
80106d51:	e9 da fe ff ff       	jmp    80106c30 <uartputc.part.0>
80106d56:	8d 76 00             	lea    0x0(%esi),%esi
80106d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d60:	5d                   	pop    %ebp
80106d61:	c3                   	ret    
80106d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d70 <uartintr>:

void
uartintr(void)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106d76:	68 00 6c 10 80       	push   $0x80106c00
80106d7b:	e8 90 9a ff ff       	call   80100810 <consoleintr>
}
80106d80:	83 c4 10             	add    $0x10,%esp
80106d83:	c9                   	leave  
80106d84:	c3                   	ret    

80106d85 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $0
80106d87:	6a 00                	push   $0x0
  jmp alltraps
80106d89:	e9 39 f8 ff ff       	jmp    801065c7 <alltraps>

80106d8e <vector1>:
.globl vector1
vector1:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $1
80106d90:	6a 01                	push   $0x1
  jmp alltraps
80106d92:	e9 30 f8 ff ff       	jmp    801065c7 <alltraps>

80106d97 <vector2>:
.globl vector2
vector2:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $2
80106d99:	6a 02                	push   $0x2
  jmp alltraps
80106d9b:	e9 27 f8 ff ff       	jmp    801065c7 <alltraps>

80106da0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106da0:	6a 00                	push   $0x0
  pushl $3
80106da2:	6a 03                	push   $0x3
  jmp alltraps
80106da4:	e9 1e f8 ff ff       	jmp    801065c7 <alltraps>

80106da9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $4
80106dab:	6a 04                	push   $0x4
  jmp alltraps
80106dad:	e9 15 f8 ff ff       	jmp    801065c7 <alltraps>

80106db2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $5
80106db4:	6a 05                	push   $0x5
  jmp alltraps
80106db6:	e9 0c f8 ff ff       	jmp    801065c7 <alltraps>

80106dbb <vector6>:
.globl vector6
vector6:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $6
80106dbd:	6a 06                	push   $0x6
  jmp alltraps
80106dbf:	e9 03 f8 ff ff       	jmp    801065c7 <alltraps>

80106dc4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106dc4:	6a 00                	push   $0x0
  pushl $7
80106dc6:	6a 07                	push   $0x7
  jmp alltraps
80106dc8:	e9 fa f7 ff ff       	jmp    801065c7 <alltraps>

80106dcd <vector8>:
.globl vector8
vector8:
  pushl $8
80106dcd:	6a 08                	push   $0x8
  jmp alltraps
80106dcf:	e9 f3 f7 ff ff       	jmp    801065c7 <alltraps>

80106dd4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106dd4:	6a 00                	push   $0x0
  pushl $9
80106dd6:	6a 09                	push   $0x9
  jmp alltraps
80106dd8:	e9 ea f7 ff ff       	jmp    801065c7 <alltraps>

80106ddd <vector10>:
.globl vector10
vector10:
  pushl $10
80106ddd:	6a 0a                	push   $0xa
  jmp alltraps
80106ddf:	e9 e3 f7 ff ff       	jmp    801065c7 <alltraps>

80106de4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106de4:	6a 0b                	push   $0xb
  jmp alltraps
80106de6:	e9 dc f7 ff ff       	jmp    801065c7 <alltraps>

80106deb <vector12>:
.globl vector12
vector12:
  pushl $12
80106deb:	6a 0c                	push   $0xc
  jmp alltraps
80106ded:	e9 d5 f7 ff ff       	jmp    801065c7 <alltraps>

80106df2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106df2:	6a 0d                	push   $0xd
  jmp alltraps
80106df4:	e9 ce f7 ff ff       	jmp    801065c7 <alltraps>

80106df9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106df9:	6a 0e                	push   $0xe
  jmp alltraps
80106dfb:	e9 c7 f7 ff ff       	jmp    801065c7 <alltraps>

80106e00 <vector15>:
.globl vector15
vector15:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $15
80106e02:	6a 0f                	push   $0xf
  jmp alltraps
80106e04:	e9 be f7 ff ff       	jmp    801065c7 <alltraps>

80106e09 <vector16>:
.globl vector16
vector16:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $16
80106e0b:	6a 10                	push   $0x10
  jmp alltraps
80106e0d:	e9 b5 f7 ff ff       	jmp    801065c7 <alltraps>

80106e12 <vector17>:
.globl vector17
vector17:
  pushl $17
80106e12:	6a 11                	push   $0x11
  jmp alltraps
80106e14:	e9 ae f7 ff ff       	jmp    801065c7 <alltraps>

80106e19 <vector18>:
.globl vector18
vector18:
  pushl $0
80106e19:	6a 00                	push   $0x0
  pushl $18
80106e1b:	6a 12                	push   $0x12
  jmp alltraps
80106e1d:	e9 a5 f7 ff ff       	jmp    801065c7 <alltraps>

80106e22 <vector19>:
.globl vector19
vector19:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $19
80106e24:	6a 13                	push   $0x13
  jmp alltraps
80106e26:	e9 9c f7 ff ff       	jmp    801065c7 <alltraps>

80106e2b <vector20>:
.globl vector20
vector20:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $20
80106e2d:	6a 14                	push   $0x14
  jmp alltraps
80106e2f:	e9 93 f7 ff ff       	jmp    801065c7 <alltraps>

80106e34 <vector21>:
.globl vector21
vector21:
  pushl $0
80106e34:	6a 00                	push   $0x0
  pushl $21
80106e36:	6a 15                	push   $0x15
  jmp alltraps
80106e38:	e9 8a f7 ff ff       	jmp    801065c7 <alltraps>

80106e3d <vector22>:
.globl vector22
vector22:
  pushl $0
80106e3d:	6a 00                	push   $0x0
  pushl $22
80106e3f:	6a 16                	push   $0x16
  jmp alltraps
80106e41:	e9 81 f7 ff ff       	jmp    801065c7 <alltraps>

80106e46 <vector23>:
.globl vector23
vector23:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $23
80106e48:	6a 17                	push   $0x17
  jmp alltraps
80106e4a:	e9 78 f7 ff ff       	jmp    801065c7 <alltraps>

80106e4f <vector24>:
.globl vector24
vector24:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $24
80106e51:	6a 18                	push   $0x18
  jmp alltraps
80106e53:	e9 6f f7 ff ff       	jmp    801065c7 <alltraps>

80106e58 <vector25>:
.globl vector25
vector25:
  pushl $0
80106e58:	6a 00                	push   $0x0
  pushl $25
80106e5a:	6a 19                	push   $0x19
  jmp alltraps
80106e5c:	e9 66 f7 ff ff       	jmp    801065c7 <alltraps>

80106e61 <vector26>:
.globl vector26
vector26:
  pushl $0
80106e61:	6a 00                	push   $0x0
  pushl $26
80106e63:	6a 1a                	push   $0x1a
  jmp alltraps
80106e65:	e9 5d f7 ff ff       	jmp    801065c7 <alltraps>

80106e6a <vector27>:
.globl vector27
vector27:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $27
80106e6c:	6a 1b                	push   $0x1b
  jmp alltraps
80106e6e:	e9 54 f7 ff ff       	jmp    801065c7 <alltraps>

80106e73 <vector28>:
.globl vector28
vector28:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $28
80106e75:	6a 1c                	push   $0x1c
  jmp alltraps
80106e77:	e9 4b f7 ff ff       	jmp    801065c7 <alltraps>

80106e7c <vector29>:
.globl vector29
vector29:
  pushl $0
80106e7c:	6a 00                	push   $0x0
  pushl $29
80106e7e:	6a 1d                	push   $0x1d
  jmp alltraps
80106e80:	e9 42 f7 ff ff       	jmp    801065c7 <alltraps>

80106e85 <vector30>:
.globl vector30
vector30:
  pushl $0
80106e85:	6a 00                	push   $0x0
  pushl $30
80106e87:	6a 1e                	push   $0x1e
  jmp alltraps
80106e89:	e9 39 f7 ff ff       	jmp    801065c7 <alltraps>

80106e8e <vector31>:
.globl vector31
vector31:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $31
80106e90:	6a 1f                	push   $0x1f
  jmp alltraps
80106e92:	e9 30 f7 ff ff       	jmp    801065c7 <alltraps>

80106e97 <vector32>:
.globl vector32
vector32:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $32
80106e99:	6a 20                	push   $0x20
  jmp alltraps
80106e9b:	e9 27 f7 ff ff       	jmp    801065c7 <alltraps>

80106ea0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106ea0:	6a 00                	push   $0x0
  pushl $33
80106ea2:	6a 21                	push   $0x21
  jmp alltraps
80106ea4:	e9 1e f7 ff ff       	jmp    801065c7 <alltraps>

80106ea9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106ea9:	6a 00                	push   $0x0
  pushl $34
80106eab:	6a 22                	push   $0x22
  jmp alltraps
80106ead:	e9 15 f7 ff ff       	jmp    801065c7 <alltraps>

80106eb2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $35
80106eb4:	6a 23                	push   $0x23
  jmp alltraps
80106eb6:	e9 0c f7 ff ff       	jmp    801065c7 <alltraps>

80106ebb <vector36>:
.globl vector36
vector36:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $36
80106ebd:	6a 24                	push   $0x24
  jmp alltraps
80106ebf:	e9 03 f7 ff ff       	jmp    801065c7 <alltraps>

80106ec4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106ec4:	6a 00                	push   $0x0
  pushl $37
80106ec6:	6a 25                	push   $0x25
  jmp alltraps
80106ec8:	e9 fa f6 ff ff       	jmp    801065c7 <alltraps>

80106ecd <vector38>:
.globl vector38
vector38:
  pushl $0
80106ecd:	6a 00                	push   $0x0
  pushl $38
80106ecf:	6a 26                	push   $0x26
  jmp alltraps
80106ed1:	e9 f1 f6 ff ff       	jmp    801065c7 <alltraps>

80106ed6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $39
80106ed8:	6a 27                	push   $0x27
  jmp alltraps
80106eda:	e9 e8 f6 ff ff       	jmp    801065c7 <alltraps>

80106edf <vector40>:
.globl vector40
vector40:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $40
80106ee1:	6a 28                	push   $0x28
  jmp alltraps
80106ee3:	e9 df f6 ff ff       	jmp    801065c7 <alltraps>

80106ee8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106ee8:	6a 00                	push   $0x0
  pushl $41
80106eea:	6a 29                	push   $0x29
  jmp alltraps
80106eec:	e9 d6 f6 ff ff       	jmp    801065c7 <alltraps>

80106ef1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ef1:	6a 00                	push   $0x0
  pushl $42
80106ef3:	6a 2a                	push   $0x2a
  jmp alltraps
80106ef5:	e9 cd f6 ff ff       	jmp    801065c7 <alltraps>

80106efa <vector43>:
.globl vector43
vector43:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $43
80106efc:	6a 2b                	push   $0x2b
  jmp alltraps
80106efe:	e9 c4 f6 ff ff       	jmp    801065c7 <alltraps>

80106f03 <vector44>:
.globl vector44
vector44:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $44
80106f05:	6a 2c                	push   $0x2c
  jmp alltraps
80106f07:	e9 bb f6 ff ff       	jmp    801065c7 <alltraps>

80106f0c <vector45>:
.globl vector45
vector45:
  pushl $0
80106f0c:	6a 00                	push   $0x0
  pushl $45
80106f0e:	6a 2d                	push   $0x2d
  jmp alltraps
80106f10:	e9 b2 f6 ff ff       	jmp    801065c7 <alltraps>

80106f15 <vector46>:
.globl vector46
vector46:
  pushl $0
80106f15:	6a 00                	push   $0x0
  pushl $46
80106f17:	6a 2e                	push   $0x2e
  jmp alltraps
80106f19:	e9 a9 f6 ff ff       	jmp    801065c7 <alltraps>

80106f1e <vector47>:
.globl vector47
vector47:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $47
80106f20:	6a 2f                	push   $0x2f
  jmp alltraps
80106f22:	e9 a0 f6 ff ff       	jmp    801065c7 <alltraps>

80106f27 <vector48>:
.globl vector48
vector48:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $48
80106f29:	6a 30                	push   $0x30
  jmp alltraps
80106f2b:	e9 97 f6 ff ff       	jmp    801065c7 <alltraps>

80106f30 <vector49>:
.globl vector49
vector49:
  pushl $0
80106f30:	6a 00                	push   $0x0
  pushl $49
80106f32:	6a 31                	push   $0x31
  jmp alltraps
80106f34:	e9 8e f6 ff ff       	jmp    801065c7 <alltraps>

80106f39 <vector50>:
.globl vector50
vector50:
  pushl $0
80106f39:	6a 00                	push   $0x0
  pushl $50
80106f3b:	6a 32                	push   $0x32
  jmp alltraps
80106f3d:	e9 85 f6 ff ff       	jmp    801065c7 <alltraps>

80106f42 <vector51>:
.globl vector51
vector51:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $51
80106f44:	6a 33                	push   $0x33
  jmp alltraps
80106f46:	e9 7c f6 ff ff       	jmp    801065c7 <alltraps>

80106f4b <vector52>:
.globl vector52
vector52:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $52
80106f4d:	6a 34                	push   $0x34
  jmp alltraps
80106f4f:	e9 73 f6 ff ff       	jmp    801065c7 <alltraps>

80106f54 <vector53>:
.globl vector53
vector53:
  pushl $0
80106f54:	6a 00                	push   $0x0
  pushl $53
80106f56:	6a 35                	push   $0x35
  jmp alltraps
80106f58:	e9 6a f6 ff ff       	jmp    801065c7 <alltraps>

80106f5d <vector54>:
.globl vector54
vector54:
  pushl $0
80106f5d:	6a 00                	push   $0x0
  pushl $54
80106f5f:	6a 36                	push   $0x36
  jmp alltraps
80106f61:	e9 61 f6 ff ff       	jmp    801065c7 <alltraps>

80106f66 <vector55>:
.globl vector55
vector55:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $55
80106f68:	6a 37                	push   $0x37
  jmp alltraps
80106f6a:	e9 58 f6 ff ff       	jmp    801065c7 <alltraps>

80106f6f <vector56>:
.globl vector56
vector56:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $56
80106f71:	6a 38                	push   $0x38
  jmp alltraps
80106f73:	e9 4f f6 ff ff       	jmp    801065c7 <alltraps>

80106f78 <vector57>:
.globl vector57
vector57:
  pushl $0
80106f78:	6a 00                	push   $0x0
  pushl $57
80106f7a:	6a 39                	push   $0x39
  jmp alltraps
80106f7c:	e9 46 f6 ff ff       	jmp    801065c7 <alltraps>

80106f81 <vector58>:
.globl vector58
vector58:
  pushl $0
80106f81:	6a 00                	push   $0x0
  pushl $58
80106f83:	6a 3a                	push   $0x3a
  jmp alltraps
80106f85:	e9 3d f6 ff ff       	jmp    801065c7 <alltraps>

80106f8a <vector59>:
.globl vector59
vector59:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $59
80106f8c:	6a 3b                	push   $0x3b
  jmp alltraps
80106f8e:	e9 34 f6 ff ff       	jmp    801065c7 <alltraps>

80106f93 <vector60>:
.globl vector60
vector60:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $60
80106f95:	6a 3c                	push   $0x3c
  jmp alltraps
80106f97:	e9 2b f6 ff ff       	jmp    801065c7 <alltraps>

80106f9c <vector61>:
.globl vector61
vector61:
  pushl $0
80106f9c:	6a 00                	push   $0x0
  pushl $61
80106f9e:	6a 3d                	push   $0x3d
  jmp alltraps
80106fa0:	e9 22 f6 ff ff       	jmp    801065c7 <alltraps>

80106fa5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106fa5:	6a 00                	push   $0x0
  pushl $62
80106fa7:	6a 3e                	push   $0x3e
  jmp alltraps
80106fa9:	e9 19 f6 ff ff       	jmp    801065c7 <alltraps>

80106fae <vector63>:
.globl vector63
vector63:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $63
80106fb0:	6a 3f                	push   $0x3f
  jmp alltraps
80106fb2:	e9 10 f6 ff ff       	jmp    801065c7 <alltraps>

80106fb7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $64
80106fb9:	6a 40                	push   $0x40
  jmp alltraps
80106fbb:	e9 07 f6 ff ff       	jmp    801065c7 <alltraps>

80106fc0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106fc0:	6a 00                	push   $0x0
  pushl $65
80106fc2:	6a 41                	push   $0x41
  jmp alltraps
80106fc4:	e9 fe f5 ff ff       	jmp    801065c7 <alltraps>

80106fc9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106fc9:	6a 00                	push   $0x0
  pushl $66
80106fcb:	6a 42                	push   $0x42
  jmp alltraps
80106fcd:	e9 f5 f5 ff ff       	jmp    801065c7 <alltraps>

80106fd2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $67
80106fd4:	6a 43                	push   $0x43
  jmp alltraps
80106fd6:	e9 ec f5 ff ff       	jmp    801065c7 <alltraps>

80106fdb <vector68>:
.globl vector68
vector68:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $68
80106fdd:	6a 44                	push   $0x44
  jmp alltraps
80106fdf:	e9 e3 f5 ff ff       	jmp    801065c7 <alltraps>

80106fe4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106fe4:	6a 00                	push   $0x0
  pushl $69
80106fe6:	6a 45                	push   $0x45
  jmp alltraps
80106fe8:	e9 da f5 ff ff       	jmp    801065c7 <alltraps>

80106fed <vector70>:
.globl vector70
vector70:
  pushl $0
80106fed:	6a 00                	push   $0x0
  pushl $70
80106fef:	6a 46                	push   $0x46
  jmp alltraps
80106ff1:	e9 d1 f5 ff ff       	jmp    801065c7 <alltraps>

80106ff6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $71
80106ff8:	6a 47                	push   $0x47
  jmp alltraps
80106ffa:	e9 c8 f5 ff ff       	jmp    801065c7 <alltraps>

80106fff <vector72>:
.globl vector72
vector72:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $72
80107001:	6a 48                	push   $0x48
  jmp alltraps
80107003:	e9 bf f5 ff ff       	jmp    801065c7 <alltraps>

80107008 <vector73>:
.globl vector73
vector73:
  pushl $0
80107008:	6a 00                	push   $0x0
  pushl $73
8010700a:	6a 49                	push   $0x49
  jmp alltraps
8010700c:	e9 b6 f5 ff ff       	jmp    801065c7 <alltraps>

80107011 <vector74>:
.globl vector74
vector74:
  pushl $0
80107011:	6a 00                	push   $0x0
  pushl $74
80107013:	6a 4a                	push   $0x4a
  jmp alltraps
80107015:	e9 ad f5 ff ff       	jmp    801065c7 <alltraps>

8010701a <vector75>:
.globl vector75
vector75:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $75
8010701c:	6a 4b                	push   $0x4b
  jmp alltraps
8010701e:	e9 a4 f5 ff ff       	jmp    801065c7 <alltraps>

80107023 <vector76>:
.globl vector76
vector76:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $76
80107025:	6a 4c                	push   $0x4c
  jmp alltraps
80107027:	e9 9b f5 ff ff       	jmp    801065c7 <alltraps>

8010702c <vector77>:
.globl vector77
vector77:
  pushl $0
8010702c:	6a 00                	push   $0x0
  pushl $77
8010702e:	6a 4d                	push   $0x4d
  jmp alltraps
80107030:	e9 92 f5 ff ff       	jmp    801065c7 <alltraps>

80107035 <vector78>:
.globl vector78
vector78:
  pushl $0
80107035:	6a 00                	push   $0x0
  pushl $78
80107037:	6a 4e                	push   $0x4e
  jmp alltraps
80107039:	e9 89 f5 ff ff       	jmp    801065c7 <alltraps>

8010703e <vector79>:
.globl vector79
vector79:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $79
80107040:	6a 4f                	push   $0x4f
  jmp alltraps
80107042:	e9 80 f5 ff ff       	jmp    801065c7 <alltraps>

80107047 <vector80>:
.globl vector80
vector80:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $80
80107049:	6a 50                	push   $0x50
  jmp alltraps
8010704b:	e9 77 f5 ff ff       	jmp    801065c7 <alltraps>

80107050 <vector81>:
.globl vector81
vector81:
  pushl $0
80107050:	6a 00                	push   $0x0
  pushl $81
80107052:	6a 51                	push   $0x51
  jmp alltraps
80107054:	e9 6e f5 ff ff       	jmp    801065c7 <alltraps>

80107059 <vector82>:
.globl vector82
vector82:
  pushl $0
80107059:	6a 00                	push   $0x0
  pushl $82
8010705b:	6a 52                	push   $0x52
  jmp alltraps
8010705d:	e9 65 f5 ff ff       	jmp    801065c7 <alltraps>

80107062 <vector83>:
.globl vector83
vector83:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $83
80107064:	6a 53                	push   $0x53
  jmp alltraps
80107066:	e9 5c f5 ff ff       	jmp    801065c7 <alltraps>

8010706b <vector84>:
.globl vector84
vector84:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $84
8010706d:	6a 54                	push   $0x54
  jmp alltraps
8010706f:	e9 53 f5 ff ff       	jmp    801065c7 <alltraps>

80107074 <vector85>:
.globl vector85
vector85:
  pushl $0
80107074:	6a 00                	push   $0x0
  pushl $85
80107076:	6a 55                	push   $0x55
  jmp alltraps
80107078:	e9 4a f5 ff ff       	jmp    801065c7 <alltraps>

8010707d <vector86>:
.globl vector86
vector86:
  pushl $0
8010707d:	6a 00                	push   $0x0
  pushl $86
8010707f:	6a 56                	push   $0x56
  jmp alltraps
80107081:	e9 41 f5 ff ff       	jmp    801065c7 <alltraps>

80107086 <vector87>:
.globl vector87
vector87:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $87
80107088:	6a 57                	push   $0x57
  jmp alltraps
8010708a:	e9 38 f5 ff ff       	jmp    801065c7 <alltraps>

8010708f <vector88>:
.globl vector88
vector88:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $88
80107091:	6a 58                	push   $0x58
  jmp alltraps
80107093:	e9 2f f5 ff ff       	jmp    801065c7 <alltraps>

80107098 <vector89>:
.globl vector89
vector89:
  pushl $0
80107098:	6a 00                	push   $0x0
  pushl $89
8010709a:	6a 59                	push   $0x59
  jmp alltraps
8010709c:	e9 26 f5 ff ff       	jmp    801065c7 <alltraps>

801070a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801070a1:	6a 00                	push   $0x0
  pushl $90
801070a3:	6a 5a                	push   $0x5a
  jmp alltraps
801070a5:	e9 1d f5 ff ff       	jmp    801065c7 <alltraps>

801070aa <vector91>:
.globl vector91
vector91:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $91
801070ac:	6a 5b                	push   $0x5b
  jmp alltraps
801070ae:	e9 14 f5 ff ff       	jmp    801065c7 <alltraps>

801070b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $92
801070b5:	6a 5c                	push   $0x5c
  jmp alltraps
801070b7:	e9 0b f5 ff ff       	jmp    801065c7 <alltraps>

801070bc <vector93>:
.globl vector93
vector93:
  pushl $0
801070bc:	6a 00                	push   $0x0
  pushl $93
801070be:	6a 5d                	push   $0x5d
  jmp alltraps
801070c0:	e9 02 f5 ff ff       	jmp    801065c7 <alltraps>

801070c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801070c5:	6a 00                	push   $0x0
  pushl $94
801070c7:	6a 5e                	push   $0x5e
  jmp alltraps
801070c9:	e9 f9 f4 ff ff       	jmp    801065c7 <alltraps>

801070ce <vector95>:
.globl vector95
vector95:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $95
801070d0:	6a 5f                	push   $0x5f
  jmp alltraps
801070d2:	e9 f0 f4 ff ff       	jmp    801065c7 <alltraps>

801070d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $96
801070d9:	6a 60                	push   $0x60
  jmp alltraps
801070db:	e9 e7 f4 ff ff       	jmp    801065c7 <alltraps>

801070e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801070e0:	6a 00                	push   $0x0
  pushl $97
801070e2:	6a 61                	push   $0x61
  jmp alltraps
801070e4:	e9 de f4 ff ff       	jmp    801065c7 <alltraps>

801070e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801070e9:	6a 00                	push   $0x0
  pushl $98
801070eb:	6a 62                	push   $0x62
  jmp alltraps
801070ed:	e9 d5 f4 ff ff       	jmp    801065c7 <alltraps>

801070f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $99
801070f4:	6a 63                	push   $0x63
  jmp alltraps
801070f6:	e9 cc f4 ff ff       	jmp    801065c7 <alltraps>

801070fb <vector100>:
.globl vector100
vector100:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $100
801070fd:	6a 64                	push   $0x64
  jmp alltraps
801070ff:	e9 c3 f4 ff ff       	jmp    801065c7 <alltraps>

80107104 <vector101>:
.globl vector101
vector101:
  pushl $0
80107104:	6a 00                	push   $0x0
  pushl $101
80107106:	6a 65                	push   $0x65
  jmp alltraps
80107108:	e9 ba f4 ff ff       	jmp    801065c7 <alltraps>

8010710d <vector102>:
.globl vector102
vector102:
  pushl $0
8010710d:	6a 00                	push   $0x0
  pushl $102
8010710f:	6a 66                	push   $0x66
  jmp alltraps
80107111:	e9 b1 f4 ff ff       	jmp    801065c7 <alltraps>

80107116 <vector103>:
.globl vector103
vector103:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $103
80107118:	6a 67                	push   $0x67
  jmp alltraps
8010711a:	e9 a8 f4 ff ff       	jmp    801065c7 <alltraps>

8010711f <vector104>:
.globl vector104
vector104:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $104
80107121:	6a 68                	push   $0x68
  jmp alltraps
80107123:	e9 9f f4 ff ff       	jmp    801065c7 <alltraps>

80107128 <vector105>:
.globl vector105
vector105:
  pushl $0
80107128:	6a 00                	push   $0x0
  pushl $105
8010712a:	6a 69                	push   $0x69
  jmp alltraps
8010712c:	e9 96 f4 ff ff       	jmp    801065c7 <alltraps>

80107131 <vector106>:
.globl vector106
vector106:
  pushl $0
80107131:	6a 00                	push   $0x0
  pushl $106
80107133:	6a 6a                	push   $0x6a
  jmp alltraps
80107135:	e9 8d f4 ff ff       	jmp    801065c7 <alltraps>

8010713a <vector107>:
.globl vector107
vector107:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $107
8010713c:	6a 6b                	push   $0x6b
  jmp alltraps
8010713e:	e9 84 f4 ff ff       	jmp    801065c7 <alltraps>

80107143 <vector108>:
.globl vector108
vector108:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $108
80107145:	6a 6c                	push   $0x6c
  jmp alltraps
80107147:	e9 7b f4 ff ff       	jmp    801065c7 <alltraps>

8010714c <vector109>:
.globl vector109
vector109:
  pushl $0
8010714c:	6a 00                	push   $0x0
  pushl $109
8010714e:	6a 6d                	push   $0x6d
  jmp alltraps
80107150:	e9 72 f4 ff ff       	jmp    801065c7 <alltraps>

80107155 <vector110>:
.globl vector110
vector110:
  pushl $0
80107155:	6a 00                	push   $0x0
  pushl $110
80107157:	6a 6e                	push   $0x6e
  jmp alltraps
80107159:	e9 69 f4 ff ff       	jmp    801065c7 <alltraps>

8010715e <vector111>:
.globl vector111
vector111:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $111
80107160:	6a 6f                	push   $0x6f
  jmp alltraps
80107162:	e9 60 f4 ff ff       	jmp    801065c7 <alltraps>

80107167 <vector112>:
.globl vector112
vector112:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $112
80107169:	6a 70                	push   $0x70
  jmp alltraps
8010716b:	e9 57 f4 ff ff       	jmp    801065c7 <alltraps>

80107170 <vector113>:
.globl vector113
vector113:
  pushl $0
80107170:	6a 00                	push   $0x0
  pushl $113
80107172:	6a 71                	push   $0x71
  jmp alltraps
80107174:	e9 4e f4 ff ff       	jmp    801065c7 <alltraps>

80107179 <vector114>:
.globl vector114
vector114:
  pushl $0
80107179:	6a 00                	push   $0x0
  pushl $114
8010717b:	6a 72                	push   $0x72
  jmp alltraps
8010717d:	e9 45 f4 ff ff       	jmp    801065c7 <alltraps>

80107182 <vector115>:
.globl vector115
vector115:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $115
80107184:	6a 73                	push   $0x73
  jmp alltraps
80107186:	e9 3c f4 ff ff       	jmp    801065c7 <alltraps>

8010718b <vector116>:
.globl vector116
vector116:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $116
8010718d:	6a 74                	push   $0x74
  jmp alltraps
8010718f:	e9 33 f4 ff ff       	jmp    801065c7 <alltraps>

80107194 <vector117>:
.globl vector117
vector117:
  pushl $0
80107194:	6a 00                	push   $0x0
  pushl $117
80107196:	6a 75                	push   $0x75
  jmp alltraps
80107198:	e9 2a f4 ff ff       	jmp    801065c7 <alltraps>

8010719d <vector118>:
.globl vector118
vector118:
  pushl $0
8010719d:	6a 00                	push   $0x0
  pushl $118
8010719f:	6a 76                	push   $0x76
  jmp alltraps
801071a1:	e9 21 f4 ff ff       	jmp    801065c7 <alltraps>

801071a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $119
801071a8:	6a 77                	push   $0x77
  jmp alltraps
801071aa:	e9 18 f4 ff ff       	jmp    801065c7 <alltraps>

801071af <vector120>:
.globl vector120
vector120:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $120
801071b1:	6a 78                	push   $0x78
  jmp alltraps
801071b3:	e9 0f f4 ff ff       	jmp    801065c7 <alltraps>

801071b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801071b8:	6a 00                	push   $0x0
  pushl $121
801071ba:	6a 79                	push   $0x79
  jmp alltraps
801071bc:	e9 06 f4 ff ff       	jmp    801065c7 <alltraps>

801071c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801071c1:	6a 00                	push   $0x0
  pushl $122
801071c3:	6a 7a                	push   $0x7a
  jmp alltraps
801071c5:	e9 fd f3 ff ff       	jmp    801065c7 <alltraps>

801071ca <vector123>:
.globl vector123
vector123:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $123
801071cc:	6a 7b                	push   $0x7b
  jmp alltraps
801071ce:	e9 f4 f3 ff ff       	jmp    801065c7 <alltraps>

801071d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $124
801071d5:	6a 7c                	push   $0x7c
  jmp alltraps
801071d7:	e9 eb f3 ff ff       	jmp    801065c7 <alltraps>

801071dc <vector125>:
.globl vector125
vector125:
  pushl $0
801071dc:	6a 00                	push   $0x0
  pushl $125
801071de:	6a 7d                	push   $0x7d
  jmp alltraps
801071e0:	e9 e2 f3 ff ff       	jmp    801065c7 <alltraps>

801071e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801071e5:	6a 00                	push   $0x0
  pushl $126
801071e7:	6a 7e                	push   $0x7e
  jmp alltraps
801071e9:	e9 d9 f3 ff ff       	jmp    801065c7 <alltraps>

801071ee <vector127>:
.globl vector127
vector127:
  pushl $0
801071ee:	6a 00                	push   $0x0
  pushl $127
801071f0:	6a 7f                	push   $0x7f
  jmp alltraps
801071f2:	e9 d0 f3 ff ff       	jmp    801065c7 <alltraps>

801071f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $128
801071f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801071fe:	e9 c4 f3 ff ff       	jmp    801065c7 <alltraps>

80107203 <vector129>:
.globl vector129
vector129:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $129
80107205:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010720a:	e9 b8 f3 ff ff       	jmp    801065c7 <alltraps>

8010720f <vector130>:
.globl vector130
vector130:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $130
80107211:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107216:	e9 ac f3 ff ff       	jmp    801065c7 <alltraps>

8010721b <vector131>:
.globl vector131
vector131:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $131
8010721d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107222:	e9 a0 f3 ff ff       	jmp    801065c7 <alltraps>

80107227 <vector132>:
.globl vector132
vector132:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $132
80107229:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010722e:	e9 94 f3 ff ff       	jmp    801065c7 <alltraps>

80107233 <vector133>:
.globl vector133
vector133:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $133
80107235:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010723a:	e9 88 f3 ff ff       	jmp    801065c7 <alltraps>

8010723f <vector134>:
.globl vector134
vector134:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $134
80107241:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107246:	e9 7c f3 ff ff       	jmp    801065c7 <alltraps>

8010724b <vector135>:
.globl vector135
vector135:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $135
8010724d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107252:	e9 70 f3 ff ff       	jmp    801065c7 <alltraps>

80107257 <vector136>:
.globl vector136
vector136:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $136
80107259:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010725e:	e9 64 f3 ff ff       	jmp    801065c7 <alltraps>

80107263 <vector137>:
.globl vector137
vector137:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $137
80107265:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010726a:	e9 58 f3 ff ff       	jmp    801065c7 <alltraps>

8010726f <vector138>:
.globl vector138
vector138:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $138
80107271:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107276:	e9 4c f3 ff ff       	jmp    801065c7 <alltraps>

8010727b <vector139>:
.globl vector139
vector139:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $139
8010727d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107282:	e9 40 f3 ff ff       	jmp    801065c7 <alltraps>

80107287 <vector140>:
.globl vector140
vector140:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $140
80107289:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010728e:	e9 34 f3 ff ff       	jmp    801065c7 <alltraps>

80107293 <vector141>:
.globl vector141
vector141:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $141
80107295:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010729a:	e9 28 f3 ff ff       	jmp    801065c7 <alltraps>

8010729f <vector142>:
.globl vector142
vector142:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $142
801072a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801072a6:	e9 1c f3 ff ff       	jmp    801065c7 <alltraps>

801072ab <vector143>:
.globl vector143
vector143:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $143
801072ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801072b2:	e9 10 f3 ff ff       	jmp    801065c7 <alltraps>

801072b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $144
801072b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801072be:	e9 04 f3 ff ff       	jmp    801065c7 <alltraps>

801072c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $145
801072c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801072ca:	e9 f8 f2 ff ff       	jmp    801065c7 <alltraps>

801072cf <vector146>:
.globl vector146
vector146:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $146
801072d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801072d6:	e9 ec f2 ff ff       	jmp    801065c7 <alltraps>

801072db <vector147>:
.globl vector147
vector147:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $147
801072dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801072e2:	e9 e0 f2 ff ff       	jmp    801065c7 <alltraps>

801072e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $148
801072e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801072ee:	e9 d4 f2 ff ff       	jmp    801065c7 <alltraps>

801072f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $149
801072f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801072fa:	e9 c8 f2 ff ff       	jmp    801065c7 <alltraps>

801072ff <vector150>:
.globl vector150
vector150:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $150
80107301:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107306:	e9 bc f2 ff ff       	jmp    801065c7 <alltraps>

8010730b <vector151>:
.globl vector151
vector151:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $151
8010730d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107312:	e9 b0 f2 ff ff       	jmp    801065c7 <alltraps>

80107317 <vector152>:
.globl vector152
vector152:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $152
80107319:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010731e:	e9 a4 f2 ff ff       	jmp    801065c7 <alltraps>

80107323 <vector153>:
.globl vector153
vector153:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $153
80107325:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010732a:	e9 98 f2 ff ff       	jmp    801065c7 <alltraps>

8010732f <vector154>:
.globl vector154
vector154:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $154
80107331:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107336:	e9 8c f2 ff ff       	jmp    801065c7 <alltraps>

8010733b <vector155>:
.globl vector155
vector155:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $155
8010733d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107342:	e9 80 f2 ff ff       	jmp    801065c7 <alltraps>

80107347 <vector156>:
.globl vector156
vector156:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $156
80107349:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010734e:	e9 74 f2 ff ff       	jmp    801065c7 <alltraps>

80107353 <vector157>:
.globl vector157
vector157:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $157
80107355:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010735a:	e9 68 f2 ff ff       	jmp    801065c7 <alltraps>

8010735f <vector158>:
.globl vector158
vector158:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $158
80107361:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107366:	e9 5c f2 ff ff       	jmp    801065c7 <alltraps>

8010736b <vector159>:
.globl vector159
vector159:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $159
8010736d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107372:	e9 50 f2 ff ff       	jmp    801065c7 <alltraps>

80107377 <vector160>:
.globl vector160
vector160:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $160
80107379:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010737e:	e9 44 f2 ff ff       	jmp    801065c7 <alltraps>

80107383 <vector161>:
.globl vector161
vector161:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $161
80107385:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010738a:	e9 38 f2 ff ff       	jmp    801065c7 <alltraps>

8010738f <vector162>:
.globl vector162
vector162:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $162
80107391:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107396:	e9 2c f2 ff ff       	jmp    801065c7 <alltraps>

8010739b <vector163>:
.globl vector163
vector163:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $163
8010739d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801073a2:	e9 20 f2 ff ff       	jmp    801065c7 <alltraps>

801073a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $164
801073a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801073ae:	e9 14 f2 ff ff       	jmp    801065c7 <alltraps>

801073b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $165
801073b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801073ba:	e9 08 f2 ff ff       	jmp    801065c7 <alltraps>

801073bf <vector166>:
.globl vector166
vector166:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $166
801073c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801073c6:	e9 fc f1 ff ff       	jmp    801065c7 <alltraps>

801073cb <vector167>:
.globl vector167
vector167:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $167
801073cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801073d2:	e9 f0 f1 ff ff       	jmp    801065c7 <alltraps>

801073d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $168
801073d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801073de:	e9 e4 f1 ff ff       	jmp    801065c7 <alltraps>

801073e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $169
801073e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801073ea:	e9 d8 f1 ff ff       	jmp    801065c7 <alltraps>

801073ef <vector170>:
.globl vector170
vector170:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $170
801073f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801073f6:	e9 cc f1 ff ff       	jmp    801065c7 <alltraps>

801073fb <vector171>:
.globl vector171
vector171:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $171
801073fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107402:	e9 c0 f1 ff ff       	jmp    801065c7 <alltraps>

80107407 <vector172>:
.globl vector172
vector172:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $172
80107409:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010740e:	e9 b4 f1 ff ff       	jmp    801065c7 <alltraps>

80107413 <vector173>:
.globl vector173
vector173:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $173
80107415:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010741a:	e9 a8 f1 ff ff       	jmp    801065c7 <alltraps>

8010741f <vector174>:
.globl vector174
vector174:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $174
80107421:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107426:	e9 9c f1 ff ff       	jmp    801065c7 <alltraps>

8010742b <vector175>:
.globl vector175
vector175:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $175
8010742d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107432:	e9 90 f1 ff ff       	jmp    801065c7 <alltraps>

80107437 <vector176>:
.globl vector176
vector176:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $176
80107439:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010743e:	e9 84 f1 ff ff       	jmp    801065c7 <alltraps>

80107443 <vector177>:
.globl vector177
vector177:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $177
80107445:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010744a:	e9 78 f1 ff ff       	jmp    801065c7 <alltraps>

8010744f <vector178>:
.globl vector178
vector178:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $178
80107451:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107456:	e9 6c f1 ff ff       	jmp    801065c7 <alltraps>

8010745b <vector179>:
.globl vector179
vector179:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $179
8010745d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107462:	e9 60 f1 ff ff       	jmp    801065c7 <alltraps>

80107467 <vector180>:
.globl vector180
vector180:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $180
80107469:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010746e:	e9 54 f1 ff ff       	jmp    801065c7 <alltraps>

80107473 <vector181>:
.globl vector181
vector181:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $181
80107475:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010747a:	e9 48 f1 ff ff       	jmp    801065c7 <alltraps>

8010747f <vector182>:
.globl vector182
vector182:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $182
80107481:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107486:	e9 3c f1 ff ff       	jmp    801065c7 <alltraps>

8010748b <vector183>:
.globl vector183
vector183:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $183
8010748d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107492:	e9 30 f1 ff ff       	jmp    801065c7 <alltraps>

80107497 <vector184>:
.globl vector184
vector184:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $184
80107499:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010749e:	e9 24 f1 ff ff       	jmp    801065c7 <alltraps>

801074a3 <vector185>:
.globl vector185
vector185:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $185
801074a5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801074aa:	e9 18 f1 ff ff       	jmp    801065c7 <alltraps>

801074af <vector186>:
.globl vector186
vector186:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $186
801074b1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801074b6:	e9 0c f1 ff ff       	jmp    801065c7 <alltraps>

801074bb <vector187>:
.globl vector187
vector187:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $187
801074bd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801074c2:	e9 00 f1 ff ff       	jmp    801065c7 <alltraps>

801074c7 <vector188>:
.globl vector188
vector188:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $188
801074c9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801074ce:	e9 f4 f0 ff ff       	jmp    801065c7 <alltraps>

801074d3 <vector189>:
.globl vector189
vector189:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $189
801074d5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801074da:	e9 e8 f0 ff ff       	jmp    801065c7 <alltraps>

801074df <vector190>:
.globl vector190
vector190:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $190
801074e1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801074e6:	e9 dc f0 ff ff       	jmp    801065c7 <alltraps>

801074eb <vector191>:
.globl vector191
vector191:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $191
801074ed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801074f2:	e9 d0 f0 ff ff       	jmp    801065c7 <alltraps>

801074f7 <vector192>:
.globl vector192
vector192:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $192
801074f9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801074fe:	e9 c4 f0 ff ff       	jmp    801065c7 <alltraps>

80107503 <vector193>:
.globl vector193
vector193:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $193
80107505:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010750a:	e9 b8 f0 ff ff       	jmp    801065c7 <alltraps>

8010750f <vector194>:
.globl vector194
vector194:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $194
80107511:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107516:	e9 ac f0 ff ff       	jmp    801065c7 <alltraps>

8010751b <vector195>:
.globl vector195
vector195:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $195
8010751d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107522:	e9 a0 f0 ff ff       	jmp    801065c7 <alltraps>

80107527 <vector196>:
.globl vector196
vector196:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $196
80107529:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010752e:	e9 94 f0 ff ff       	jmp    801065c7 <alltraps>

80107533 <vector197>:
.globl vector197
vector197:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $197
80107535:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010753a:	e9 88 f0 ff ff       	jmp    801065c7 <alltraps>

8010753f <vector198>:
.globl vector198
vector198:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $198
80107541:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107546:	e9 7c f0 ff ff       	jmp    801065c7 <alltraps>

8010754b <vector199>:
.globl vector199
vector199:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $199
8010754d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107552:	e9 70 f0 ff ff       	jmp    801065c7 <alltraps>

80107557 <vector200>:
.globl vector200
vector200:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $200
80107559:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010755e:	e9 64 f0 ff ff       	jmp    801065c7 <alltraps>

80107563 <vector201>:
.globl vector201
vector201:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $201
80107565:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010756a:	e9 58 f0 ff ff       	jmp    801065c7 <alltraps>

8010756f <vector202>:
.globl vector202
vector202:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $202
80107571:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107576:	e9 4c f0 ff ff       	jmp    801065c7 <alltraps>

8010757b <vector203>:
.globl vector203
vector203:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $203
8010757d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107582:	e9 40 f0 ff ff       	jmp    801065c7 <alltraps>

80107587 <vector204>:
.globl vector204
vector204:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $204
80107589:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010758e:	e9 34 f0 ff ff       	jmp    801065c7 <alltraps>

80107593 <vector205>:
.globl vector205
vector205:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $205
80107595:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010759a:	e9 28 f0 ff ff       	jmp    801065c7 <alltraps>

8010759f <vector206>:
.globl vector206
vector206:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $206
801075a1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801075a6:	e9 1c f0 ff ff       	jmp    801065c7 <alltraps>

801075ab <vector207>:
.globl vector207
vector207:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $207
801075ad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801075b2:	e9 10 f0 ff ff       	jmp    801065c7 <alltraps>

801075b7 <vector208>:
.globl vector208
vector208:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $208
801075b9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801075be:	e9 04 f0 ff ff       	jmp    801065c7 <alltraps>

801075c3 <vector209>:
.globl vector209
vector209:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $209
801075c5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801075ca:	e9 f8 ef ff ff       	jmp    801065c7 <alltraps>

801075cf <vector210>:
.globl vector210
vector210:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $210
801075d1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801075d6:	e9 ec ef ff ff       	jmp    801065c7 <alltraps>

801075db <vector211>:
.globl vector211
vector211:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $211
801075dd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801075e2:	e9 e0 ef ff ff       	jmp    801065c7 <alltraps>

801075e7 <vector212>:
.globl vector212
vector212:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $212
801075e9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801075ee:	e9 d4 ef ff ff       	jmp    801065c7 <alltraps>

801075f3 <vector213>:
.globl vector213
vector213:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $213
801075f5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801075fa:	e9 c8 ef ff ff       	jmp    801065c7 <alltraps>

801075ff <vector214>:
.globl vector214
vector214:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $214
80107601:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107606:	e9 bc ef ff ff       	jmp    801065c7 <alltraps>

8010760b <vector215>:
.globl vector215
vector215:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $215
8010760d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107612:	e9 b0 ef ff ff       	jmp    801065c7 <alltraps>

80107617 <vector216>:
.globl vector216
vector216:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $216
80107619:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010761e:	e9 a4 ef ff ff       	jmp    801065c7 <alltraps>

80107623 <vector217>:
.globl vector217
vector217:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $217
80107625:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010762a:	e9 98 ef ff ff       	jmp    801065c7 <alltraps>

8010762f <vector218>:
.globl vector218
vector218:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $218
80107631:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107636:	e9 8c ef ff ff       	jmp    801065c7 <alltraps>

8010763b <vector219>:
.globl vector219
vector219:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $219
8010763d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107642:	e9 80 ef ff ff       	jmp    801065c7 <alltraps>

80107647 <vector220>:
.globl vector220
vector220:
  pushl $0
80107647:	6a 00                	push   $0x0
  pushl $220
80107649:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010764e:	e9 74 ef ff ff       	jmp    801065c7 <alltraps>

80107653 <vector221>:
.globl vector221
vector221:
  pushl $0
80107653:	6a 00                	push   $0x0
  pushl $221
80107655:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010765a:	e9 68 ef ff ff       	jmp    801065c7 <alltraps>

8010765f <vector222>:
.globl vector222
vector222:
  pushl $0
8010765f:	6a 00                	push   $0x0
  pushl $222
80107661:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107666:	e9 5c ef ff ff       	jmp    801065c7 <alltraps>

8010766b <vector223>:
.globl vector223
vector223:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $223
8010766d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107672:	e9 50 ef ff ff       	jmp    801065c7 <alltraps>

80107677 <vector224>:
.globl vector224
vector224:
  pushl $0
80107677:	6a 00                	push   $0x0
  pushl $224
80107679:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010767e:	e9 44 ef ff ff       	jmp    801065c7 <alltraps>

80107683 <vector225>:
.globl vector225
vector225:
  pushl $0
80107683:	6a 00                	push   $0x0
  pushl $225
80107685:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010768a:	e9 38 ef ff ff       	jmp    801065c7 <alltraps>

8010768f <vector226>:
.globl vector226
vector226:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $226
80107691:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107696:	e9 2c ef ff ff       	jmp    801065c7 <alltraps>

8010769b <vector227>:
.globl vector227
vector227:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $227
8010769d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801076a2:	e9 20 ef ff ff       	jmp    801065c7 <alltraps>

801076a7 <vector228>:
.globl vector228
vector228:
  pushl $0
801076a7:	6a 00                	push   $0x0
  pushl $228
801076a9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801076ae:	e9 14 ef ff ff       	jmp    801065c7 <alltraps>

801076b3 <vector229>:
.globl vector229
vector229:
  pushl $0
801076b3:	6a 00                	push   $0x0
  pushl $229
801076b5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801076ba:	e9 08 ef ff ff       	jmp    801065c7 <alltraps>

801076bf <vector230>:
.globl vector230
vector230:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $230
801076c1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801076c6:	e9 fc ee ff ff       	jmp    801065c7 <alltraps>

801076cb <vector231>:
.globl vector231
vector231:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $231
801076cd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801076d2:	e9 f0 ee ff ff       	jmp    801065c7 <alltraps>

801076d7 <vector232>:
.globl vector232
vector232:
  pushl $0
801076d7:	6a 00                	push   $0x0
  pushl $232
801076d9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801076de:	e9 e4 ee ff ff       	jmp    801065c7 <alltraps>

801076e3 <vector233>:
.globl vector233
vector233:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $233
801076e5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801076ea:	e9 d8 ee ff ff       	jmp    801065c7 <alltraps>

801076ef <vector234>:
.globl vector234
vector234:
  pushl $0
801076ef:	6a 00                	push   $0x0
  pushl $234
801076f1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801076f6:	e9 cc ee ff ff       	jmp    801065c7 <alltraps>

801076fb <vector235>:
.globl vector235
vector235:
  pushl $0
801076fb:	6a 00                	push   $0x0
  pushl $235
801076fd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107702:	e9 c0 ee ff ff       	jmp    801065c7 <alltraps>

80107707 <vector236>:
.globl vector236
vector236:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $236
80107709:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010770e:	e9 b4 ee ff ff       	jmp    801065c7 <alltraps>

80107713 <vector237>:
.globl vector237
vector237:
  pushl $0
80107713:	6a 00                	push   $0x0
  pushl $237
80107715:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010771a:	e9 a8 ee ff ff       	jmp    801065c7 <alltraps>

8010771f <vector238>:
.globl vector238
vector238:
  pushl $0
8010771f:	6a 00                	push   $0x0
  pushl $238
80107721:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107726:	e9 9c ee ff ff       	jmp    801065c7 <alltraps>

8010772b <vector239>:
.globl vector239
vector239:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $239
8010772d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107732:	e9 90 ee ff ff       	jmp    801065c7 <alltraps>

80107737 <vector240>:
.globl vector240
vector240:
  pushl $0
80107737:	6a 00                	push   $0x0
  pushl $240
80107739:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010773e:	e9 84 ee ff ff       	jmp    801065c7 <alltraps>

80107743 <vector241>:
.globl vector241
vector241:
  pushl $0
80107743:	6a 00                	push   $0x0
  pushl $241
80107745:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010774a:	e9 78 ee ff ff       	jmp    801065c7 <alltraps>

8010774f <vector242>:
.globl vector242
vector242:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $242
80107751:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107756:	e9 6c ee ff ff       	jmp    801065c7 <alltraps>

8010775b <vector243>:
.globl vector243
vector243:
  pushl $0
8010775b:	6a 00                	push   $0x0
  pushl $243
8010775d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107762:	e9 60 ee ff ff       	jmp    801065c7 <alltraps>

80107767 <vector244>:
.globl vector244
vector244:
  pushl $0
80107767:	6a 00                	push   $0x0
  pushl $244
80107769:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010776e:	e9 54 ee ff ff       	jmp    801065c7 <alltraps>

80107773 <vector245>:
.globl vector245
vector245:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $245
80107775:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010777a:	e9 48 ee ff ff       	jmp    801065c7 <alltraps>

8010777f <vector246>:
.globl vector246
vector246:
  pushl $0
8010777f:	6a 00                	push   $0x0
  pushl $246
80107781:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107786:	e9 3c ee ff ff       	jmp    801065c7 <alltraps>

8010778b <vector247>:
.globl vector247
vector247:
  pushl $0
8010778b:	6a 00                	push   $0x0
  pushl $247
8010778d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107792:	e9 30 ee ff ff       	jmp    801065c7 <alltraps>

80107797 <vector248>:
.globl vector248
vector248:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $248
80107799:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010779e:	e9 24 ee ff ff       	jmp    801065c7 <alltraps>

801077a3 <vector249>:
.globl vector249
vector249:
  pushl $0
801077a3:	6a 00                	push   $0x0
  pushl $249
801077a5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801077aa:	e9 18 ee ff ff       	jmp    801065c7 <alltraps>

801077af <vector250>:
.globl vector250
vector250:
  pushl $0
801077af:	6a 00                	push   $0x0
  pushl $250
801077b1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801077b6:	e9 0c ee ff ff       	jmp    801065c7 <alltraps>

801077bb <vector251>:
.globl vector251
vector251:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $251
801077bd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801077c2:	e9 00 ee ff ff       	jmp    801065c7 <alltraps>

801077c7 <vector252>:
.globl vector252
vector252:
  pushl $0
801077c7:	6a 00                	push   $0x0
  pushl $252
801077c9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801077ce:	e9 f4 ed ff ff       	jmp    801065c7 <alltraps>

801077d3 <vector253>:
.globl vector253
vector253:
  pushl $0
801077d3:	6a 00                	push   $0x0
  pushl $253
801077d5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801077da:	e9 e8 ed ff ff       	jmp    801065c7 <alltraps>

801077df <vector254>:
.globl vector254
vector254:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $254
801077e1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801077e6:	e9 dc ed ff ff       	jmp    801065c7 <alltraps>

801077eb <vector255>:
.globl vector255
vector255:
  pushl $0
801077eb:	6a 00                	push   $0x0
  pushl $255
801077ed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801077f2:	e9 d0 ed ff ff       	jmp    801065c7 <alltraps>
801077f7:	66 90                	xchg   %ax,%ax
801077f9:	66 90                	xchg   %ax,%ax
801077fb:	66 90                	xchg   %ax,%ax
801077fd:	66 90                	xchg   %ax,%ax
801077ff:	90                   	nop

80107800 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	57                   	push   %edi
80107804:	56                   	push   %esi
80107805:	53                   	push   %ebx
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80107806:	89 d3                	mov    %edx,%ebx
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80107808:	89 d7                	mov    %edx,%edi
    pde = &pgdir[PDX(va)];
8010780a:	c1 eb 16             	shr    $0x16,%ebx
8010780d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80107810:	83 ec 0c             	sub    $0xc,%esp
    if (*pde & PTE_P) {
80107813:	8b 06                	mov    (%esi),%eax
80107815:	a8 01                	test   $0x1,%al
80107817:	74 27                	je     80107840 <walkpgdir+0x40>
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
80107819:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010781e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
80107824:	c1 ef 0a             	shr    $0xa,%edi
}
80107827:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return &pgtab[PTX(va)];
8010782a:	89 fa                	mov    %edi,%edx
8010782c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107832:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107835:	5b                   	pop    %ebx
80107836:	5e                   	pop    %esi
80107837:	5f                   	pop    %edi
80107838:	5d                   	pop    %ebp
80107839:	c3                   	ret    
8010783a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!alloc || (pgtab = (pte_t *) kalloc()) == 0)
80107840:	85 c9                	test   %ecx,%ecx
80107842:	74 2c                	je     80107870 <walkpgdir+0x70>
80107844:	e8 47 b1 ff ff       	call   80102990 <kalloc>
80107849:	85 c0                	test   %eax,%eax
8010784b:	89 c3                	mov    %eax,%ebx
8010784d:	74 21                	je     80107870 <walkpgdir+0x70>
        memset(pgtab, 0, PGSIZE);
8010784f:	83 ec 04             	sub    $0x4,%esp
80107852:	68 00 10 00 00       	push   $0x1000
80107857:	6a 00                	push   $0x0
80107859:	50                   	push   %eax
8010785a:	e8 a1 d9 ff ff       	call   80105200 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010785f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107865:	83 c4 10             	add    $0x10,%esp
80107868:	83 c8 07             	or     $0x7,%eax
8010786b:	89 06                	mov    %eax,(%esi)
8010786d:	eb b5                	jmp    80107824 <walkpgdir+0x24>
8010786f:	90                   	nop
}
80107870:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80107873:	31 c0                	xor    %eax,%eax
}
80107875:	5b                   	pop    %ebx
80107876:	5e                   	pop    %esi
80107877:	5f                   	pop    %edi
80107878:	5d                   	pop    %ebp
80107879:	c3                   	ret    
8010787a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107880 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
    char *a, *last;
    pte_t *pte;

    a = (char *) PGROUNDDOWN((uint) va);
80107886:	89 d3                	mov    %edx,%ebx
80107888:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
8010788e:	83 ec 1c             	sub    $0x1c,%esp
80107891:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
80107894:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107898:	8b 7d 08             	mov    0x8(%ebp),%edi
8010789b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
            panic("remap");
        *pte = pa | perm | PTE_P;
801078a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801078a6:	29 df                	sub    %ebx,%edi
801078a8:	83 c8 01             	or     $0x1,%eax
801078ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
801078ae:	eb 15                	jmp    801078c5 <mappages+0x45>
        if (*pte & PTE_P)
801078b0:	f6 00 01             	testb  $0x1,(%eax)
801078b3:	75 45                	jne    801078fa <mappages+0x7a>
        *pte = pa | perm | PTE_P;
801078b5:	0b 75 dc             	or     -0x24(%ebp),%esi
        if (a == last)
801078b8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
        *pte = pa | perm | PTE_P;
801078bb:	89 30                	mov    %esi,(%eax)
        if (a == last)
801078bd:	74 31                	je     801078f0 <mappages+0x70>
            break;
        a += PGSIZE;
801078bf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
801078c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078c8:	b9 01 00 00 00       	mov    $0x1,%ecx
801078cd:	89 da                	mov    %ebx,%edx
801078cf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801078d2:	e8 29 ff ff ff       	call   80107800 <walkpgdir>
801078d7:	85 c0                	test   %eax,%eax
801078d9:	75 d5                	jne    801078b0 <mappages+0x30>
        pa += PGSIZE;
    }
    return 0;
}
801078db:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
801078de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078e3:	5b                   	pop    %ebx
801078e4:	5e                   	pop    %esi
801078e5:	5f                   	pop    %edi
801078e6:	5d                   	pop    %ebp
801078e7:	c3                   	ret    
801078e8:	90                   	nop
801078e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801078f3:	31 c0                	xor    %eax,%eax
}
801078f5:	5b                   	pop    %ebx
801078f6:	5e                   	pop    %esi
801078f7:	5f                   	pop    %edi
801078f8:	5d                   	pop    %ebp
801078f9:	c3                   	ret    
            panic("remap");
801078fa:	83 ec 0c             	sub    $0xc,%esp
801078fd:	68 b0 8f 10 80       	push   $0x80108fb0
80107902:	e8 89 8a ff ff       	call   80100390 <panic>
80107907:	89 f6                	mov    %esi,%esi
80107909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107910 <seginit>:
seginit(void) {
80107910:	55                   	push   %ebp
80107911:	89 e5                	mov    %esp,%ebp
80107913:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
80107916:	e8 35 c4 ff ff       	call   80103d50 <cpuid>
8010791b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107921:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107926:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010792a:	c7 80 18 48 11 80 ff 	movl   $0xffff,-0x7feeb7e8(%eax)
80107931:	ff 00 00 
80107934:	c7 80 1c 48 11 80 00 	movl   $0xcf9a00,-0x7feeb7e4(%eax)
8010793b:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010793e:	c7 80 20 48 11 80 ff 	movl   $0xffff,-0x7feeb7e0(%eax)
80107945:	ff 00 00 
80107948:	c7 80 24 48 11 80 00 	movl   $0xcf9200,-0x7feeb7dc(%eax)
8010794f:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80107952:	c7 80 28 48 11 80 ff 	movl   $0xffff,-0x7feeb7d8(%eax)
80107959:	ff 00 00 
8010795c:	c7 80 2c 48 11 80 00 	movl   $0xcffa00,-0x7feeb7d4(%eax)
80107963:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107966:	c7 80 30 48 11 80 ff 	movl   $0xffff,-0x7feeb7d0(%eax)
8010796d:	ff 00 00 
80107970:	c7 80 34 48 11 80 00 	movl   $0xcff200,-0x7feeb7cc(%eax)
80107977:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
8010797a:	05 10 48 11 80       	add    $0x80114810,%eax
  pd[1] = (uint)p;
8010797f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107983:	c1 e8 10             	shr    $0x10,%eax
80107986:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010798a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010798d:	0f 01 10             	lgdtl  (%eax)
}
80107990:	c9                   	leave  
80107991:	c3                   	ret    
80107992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079a0 <walkpgdir2>:
walkpgdir2(pde_t *pgdir, const void *va, int alloc) {
801079a0:	55                   	push   %ebp
801079a1:	89 e5                	mov    %esp,%ebp
    return walkpgdir(pgdir, va, alloc);
801079a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801079a6:	8b 55 0c             	mov    0xc(%ebp),%edx
801079a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801079ac:	5d                   	pop    %ebp
    return walkpgdir(pgdir, va, alloc);
801079ad:	e9 4e fe ff ff       	jmp    80107800 <walkpgdir>
801079b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079c0 <mappages2>:


// global use for mappages
int
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
    return mappages(pgdir, va, size, pa, perm);
801079c3:	8b 4d 18             	mov    0x18(%ebp),%ecx
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801079c6:	8b 55 0c             	mov    0xc(%ebp),%edx
801079c9:	8b 45 08             	mov    0x8(%ebp),%eax
    return mappages(pgdir, va, size, pa, perm);
801079cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801079cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
801079d2:	89 4d 08             	mov    %ecx,0x8(%ebp)
801079d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
801079d8:	5d                   	pop    %ebp
    return mappages(pgdir, va, size, pa, perm);
801079d9:	e9 a2 fe ff ff       	jmp    80107880 <mappages>
801079de:	66 90                	xchg   %ax,%ax

801079e0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void) {
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801079e0:	a1 e8 7c 12 80       	mov    0x80127ce8,%eax
switchkvm(void) {
801079e5:	55                   	push   %ebp
801079e6:	89 e5                	mov    %esp,%ebp
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801079e8:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801079ed:	0f 22 d8             	mov    %eax,%cr3
}
801079f0:	5d                   	pop    %ebp
801079f1:	c3                   	ret    
801079f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a00 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p) {
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	57                   	push   %edi
80107a04:	56                   	push   %esi
80107a05:	53                   	push   %ebx
80107a06:	83 ec 1c             	sub    $0x1c,%esp
80107a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (p == 0)
80107a0c:	85 db                	test   %ebx,%ebx
80107a0e:	0f 84 cb 00 00 00    	je     80107adf <switchuvm+0xdf>
        panic("switchuvm: no process");
    if (p->kstack == 0)
80107a14:	8b 43 08             	mov    0x8(%ebx),%eax
80107a17:	85 c0                	test   %eax,%eax
80107a19:	0f 84 da 00 00 00    	je     80107af9 <switchuvm+0xf9>
        panic("switchuvm: no kstack");
    if (p->pgdir == 0)
80107a1f:	8b 43 04             	mov    0x4(%ebx),%eax
80107a22:	85 c0                	test   %eax,%eax
80107a24:	0f 84 c2 00 00 00    	je     80107aec <switchuvm+0xec>
        panic("switchuvm: no pgdir");

    pushcli();
80107a2a:	e8 11 d6 ff ff       	call   80105040 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a2f:	e8 9c c2 ff ff       	call   80103cd0 <mycpu>
80107a34:	89 c6                	mov    %eax,%esi
80107a36:	e8 95 c2 ff ff       	call   80103cd0 <mycpu>
80107a3b:	89 c7                	mov    %eax,%edi
80107a3d:	e8 8e c2 ff ff       	call   80103cd0 <mycpu>
80107a42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a45:	83 c7 08             	add    $0x8,%edi
80107a48:	e8 83 c2 ff ff       	call   80103cd0 <mycpu>
80107a4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107a50:	83 c0 08             	add    $0x8,%eax
80107a53:	ba 67 00 00 00       	mov    $0x67,%edx
80107a58:	c1 e8 18             	shr    $0x18,%eax
80107a5b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107a62:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107a69:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
    mycpu()->gdt[SEG_TSS].s = 0;
    mycpu()->ts.ss0 = SEG_KDATA << 3;
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80107a6f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107a74:	83 c1 08             	add    $0x8,%ecx
80107a77:	c1 e9 10             	shr    $0x10,%ecx
80107a7a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107a80:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107a85:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a8c:	be 10 00 00 00       	mov    $0x10,%esi
    mycpu()->gdt[SEG_TSS].s = 0;
80107a91:	e8 3a c2 ff ff       	call   80103cd0 <mycpu>
80107a96:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
80107a9d:	e8 2e c2 ff ff       	call   80103cd0 <mycpu>
80107aa2:	66 89 70 10          	mov    %si,0x10(%eax)
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
80107aa6:	8b 73 08             	mov    0x8(%ebx),%esi
80107aa9:	e8 22 c2 ff ff       	call   80103cd0 <mycpu>
80107aae:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107ab4:	89 70 0c             	mov    %esi,0xc(%eax)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80107ab7:	e8 14 c2 ff ff       	call   80103cd0 <mycpu>
80107abc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107ac0:	b8 28 00 00 00       	mov    $0x28,%eax
80107ac5:	0f 00 d8             	ltr    %ax
    ltr(SEG_TSS << 3);
    lcr3(V2P(p->pgdir));  // switch to process's address space
80107ac8:	8b 43 04             	mov    0x4(%ebx),%eax
80107acb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107ad0:	0f 22 d8             	mov    %eax,%cr3
    popcli();
}
80107ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ad6:	5b                   	pop    %ebx
80107ad7:	5e                   	pop    %esi
80107ad8:	5f                   	pop    %edi
80107ad9:	5d                   	pop    %ebp
    popcli();
80107ada:	e9 61 d6 ff ff       	jmp    80105140 <popcli>
        panic("switchuvm: no process");
80107adf:	83 ec 0c             	sub    $0xc,%esp
80107ae2:	68 b6 8f 10 80       	push   $0x80108fb6
80107ae7:	e8 a4 88 ff ff       	call   80100390 <panic>
        panic("switchuvm: no pgdir");
80107aec:	83 ec 0c             	sub    $0xc,%esp
80107aef:	68 e1 8f 10 80       	push   $0x80108fe1
80107af4:	e8 97 88 ff ff       	call   80100390 <panic>
        panic("switchuvm: no kstack");
80107af9:	83 ec 0c             	sub    $0xc,%esp
80107afc:	68 cc 8f 10 80       	push   $0x80108fcc
80107b01:	e8 8a 88 ff ff       	call   80100390 <panic>
80107b06:	8d 76 00             	lea    0x0(%esi),%esi
80107b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b10 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz) {
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	57                   	push   %edi
80107b14:	56                   	push   %esi
80107b15:	53                   	push   %ebx
80107b16:	83 ec 1c             	sub    $0x1c,%esp
80107b19:	8b 75 10             	mov    0x10(%ebp),%esi
80107b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80107b1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
    char *mem;

    if (sz >= PGSIZE)
80107b22:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
inituvm(pde_t *pgdir, char *init, uint sz) {
80107b28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE)
80107b2b:	77 49                	ja     80107b76 <inituvm+0x66>
        panic("inituvm: more than a page");
    mem = kalloc();
80107b2d:	e8 5e ae ff ff       	call   80102990 <kalloc>
    memset(mem, 0, PGSIZE);
80107b32:	83 ec 04             	sub    $0x4,%esp
    mem = kalloc();
80107b35:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80107b37:	68 00 10 00 00       	push   $0x1000
80107b3c:	6a 00                	push   $0x0
80107b3e:	50                   	push   %eax
80107b3f:	e8 bc d6 ff ff       	call   80105200 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107b44:	58                   	pop    %eax
80107b45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b50:	5a                   	pop    %edx
80107b51:	6a 06                	push   $0x6
80107b53:	50                   	push   %eax
80107b54:	31 d2                	xor    %edx,%edx
80107b56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b59:	e8 22 fd ff ff       	call   80107880 <mappages>
    memmove(mem, init, sz);
80107b5e:	89 75 10             	mov    %esi,0x10(%ebp)
80107b61:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107b64:	83 c4 10             	add    $0x10,%esp
80107b67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b6d:	5b                   	pop    %ebx
80107b6e:	5e                   	pop    %esi
80107b6f:	5f                   	pop    %edi
80107b70:	5d                   	pop    %ebp
    memmove(mem, init, sz);
80107b71:	e9 3a d7 ff ff       	jmp    801052b0 <memmove>
        panic("inituvm: more than a page");
80107b76:	83 ec 0c             	sub    $0xc,%esp
80107b79:	68 f5 8f 10 80       	push   $0x80108ff5
80107b7e:	e8 0d 88 ff ff       	call   80100390 <panic>
80107b83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b90 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
80107b90:	55                   	push   %ebp
80107b91:	89 e5                	mov    %esp,%ebp
80107b93:	57                   	push   %edi
80107b94:	56                   	push   %esi
80107b95:	53                   	push   %ebx
80107b96:	83 ec 0c             	sub    $0xc,%esp
    uint i, pa, n;
    pte_t *pte;

    if ((uint) addr % PGSIZE != 0)
80107b99:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107ba0:	0f 85 91 00 00 00    	jne    80107c37 <loaduvm+0xa7>
        panic("loaduvm: addr must be page aligned");
    for (i = 0; i < sz; i += PGSIZE) {
80107ba6:	8b 75 18             	mov    0x18(%ebp),%esi
80107ba9:	31 db                	xor    %ebx,%ebx
80107bab:	85 f6                	test   %esi,%esi
80107bad:	75 1a                	jne    80107bc9 <loaduvm+0x39>
80107baf:	eb 6f                	jmp    80107c20 <loaduvm+0x90>
80107bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bb8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107bbe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107bc4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107bc7:	76 57                	jbe    80107c20 <loaduvm+0x90>
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
80107bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80107bcf:	31 c9                	xor    %ecx,%ecx
80107bd1:	01 da                	add    %ebx,%edx
80107bd3:	e8 28 fc ff ff       	call   80107800 <walkpgdir>
80107bd8:	85 c0                	test   %eax,%eax
80107bda:	74 4e                	je     80107c2a <loaduvm+0x9a>
            panic("loaduvm: address should exist");
        pa = PTE_ADDR(*pte);
80107bdc:	8b 00                	mov    (%eax),%eax
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, P2V(pa), offset + i, n) != n)
80107bde:	8b 4d 14             	mov    0x14(%ebp),%ecx
        if (sz - i < PGSIZE)
80107be1:	bf 00 10 00 00       	mov    $0x1000,%edi
        pa = PTE_ADDR(*pte);
80107be6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE)
80107beb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107bf1:	0f 46 fe             	cmovbe %esi,%edi
        if (readi(ip, P2V(pa), offset + i, n) != n)
80107bf4:	01 d9                	add    %ebx,%ecx
80107bf6:	05 00 00 00 80       	add    $0x80000000,%eax
80107bfb:	57                   	push   %edi
80107bfc:	51                   	push   %ecx
80107bfd:	50                   	push   %eax
80107bfe:	ff 75 10             	pushl  0x10(%ebp)
80107c01:	e8 1a 9e ff ff       	call   80101a20 <readi>
80107c06:	83 c4 10             	add    $0x10,%esp
80107c09:	39 f8                	cmp    %edi,%eax
80107c0b:	74 ab                	je     80107bb8 <loaduvm+0x28>
            return -1;
    }
    return 0;
}
80107c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107c15:	5b                   	pop    %ebx
80107c16:	5e                   	pop    %esi
80107c17:	5f                   	pop    %edi
80107c18:	5d                   	pop    %ebp
80107c19:	c3                   	ret    
80107c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107c23:	31 c0                	xor    %eax,%eax
}
80107c25:	5b                   	pop    %ebx
80107c26:	5e                   	pop    %esi
80107c27:	5f                   	pop    %edi
80107c28:	5d                   	pop    %ebp
80107c29:	c3                   	ret    
            panic("loaduvm: address should exist");
80107c2a:	83 ec 0c             	sub    $0xc,%esp
80107c2d:	68 0f 90 10 80       	push   $0x8010900f
80107c32:	e8 59 87 ff ff       	call   80100390 <panic>
        panic("loaduvm: addr must be page aligned");
80107c37:	83 ec 0c             	sub    $0xc,%esp
80107c3a:	68 8c 90 10 80       	push   $0x8010908c
80107c3f:	e8 4c 87 ff ff       	call   80100390 <panic>
80107c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c50 <haveMoreRoom>:

int haveMoreRoom(void){
80107c50:	55                   	push   %ebp
80107c51:	89 e5                	mov    %esp,%ebp
80107c53:	83 ec 08             	sub    $0x8,%esp
    struct proc *p=myproc();
80107c56:	e8 45 c1 ff ff       	call   80103da0 <myproc>
    struct page *pg;
    for(pg=p->pages; pg< &p->pages[MAX_TOTAL_PAGES]; pg++){
80107c5b:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80107c61:	8d 88 00 04 00 00    	lea    0x400(%eax),%ecx
        if(!pg->active)
80107c67:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80107c6d:	85 c0                	test   %eax,%eax
80107c6f:	75 0d                	jne    80107c7e <haveMoreRoom+0x2e>
80107c71:	eb 17                	jmp    80107c8a <haveMoreRoom+0x3a>
80107c73:	90                   	nop
80107c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c78:	8b 02                	mov    (%edx),%eax
80107c7a:	85 c0                	test   %eax,%eax
80107c7c:	74 0c                	je     80107c8a <haveMoreRoom+0x3a>
    for(pg=p->pages; pg< &p->pages[MAX_TOTAL_PAGES]; pg++){
80107c7e:	83 c2 1c             	add    $0x1c,%edx
80107c81:	39 ca                	cmp    %ecx,%edx
80107c83:	72 f3                	jb     80107c78 <haveMoreRoom+0x28>
            return 0;
    }
    return 1;
80107c85:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107c8a:	c9                   	leave  
80107c8b:	c3                   	ret    
80107c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107c90 <deallocuvm>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int growproc) {
80107c90:	55                   	push   %ebp
80107c91:	89 e5                	mov    %esp,%ebp
80107c93:	57                   	push   %edi
80107c94:	56                   	push   %esi
80107c95:	53                   	push   %ebx
80107c96:	83 ec 1c             	sub    $0x1c,%esp
        cprintf("DEALLOCUVM-");
    pte_t *pte;
    uint a, pa;
#if(defined(LIFO) || defined(SCFIFO))
    struct page *pg;
    struct proc *p = myproc();
80107c99:	e8 02 c1 ff ff       	call   80103da0 <myproc>
80107c9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#endif
    if (newsz >= oldsz) {
80107ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ca4:	39 45 10             	cmp    %eax,0x10(%ebp)
80107ca7:	0f 83 56 01 00 00    	jae    80107e03 <deallocuvm+0x173>
        if (DEBUGMODE == 2 && notShell())
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
80107cad:	8b 45 10             	mov    0x10(%ebp),%eax
80107cb0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107cb6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; a < oldsz; a += PGSIZE) {
80107cbc:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107cbf:	0f 86 3b 01 00 00    	jbe    80107e00 <deallocuvm+0x170>
                    pa = PTE_ADDR(*pte);
                    if (pa == 0)
                        panic("kfree");
                    if (notShell() && growproc) {
                        //scan pages table and remove page that page.virtAdress == a
                        for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107cc8:	05 00 04 00 00       	add    $0x400,%eax
80107ccd:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107cd0:	eb 4d                	jmp    80107d1f <deallocuvm+0x8f>
80107cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (pa == 0)
80107cd8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107cde:	0f 84 c4 01 00 00    	je     80107ea8 <deallocuvm+0x218>
            if (notShell() && growproc) {
80107ce4:	e8 87 c0 ff ff       	call   80103d70 <notShell>
80107ce9:	8b 55 14             	mov    0x14(%ebp),%edx
80107cec:	85 d2                	test   %edx,%edx
80107cee:	74 08                	je     80107cf8 <deallocuvm+0x68>
80107cf0:	85 c0                	test   %eax,%eax
80107cf2:	0f 85 30 01 00 00    	jne    80107e28 <deallocuvm+0x198>
            kfree(v);
80107cf8:	83 ec 0c             	sub    $0xc,%esp
            char *v = P2V(pa);
80107cfb:	81 c6 00 00 00 80    	add    $0x80000000,%esi
            kfree(v);
80107d01:	56                   	push   %esi
80107d02:	e8 d9 aa ff ff       	call   801027e0 <kfree>
            *pte = 0;
80107d07:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80107d0d:	83 c4 10             	add    $0x10,%esp
    for (; a < oldsz; a += PGSIZE) {
80107d10:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d16:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107d19:	0f 86 e1 00 00 00    	jbe    80107e00 <deallocuvm+0x170>
        pte = walkpgdir(pgdir, (char *) a, 0);
80107d1f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d22:	31 c9                	xor    %ecx,%ecx
80107d24:	89 da                	mov    %ebx,%edx
80107d26:	e8 d5 fa ff ff       	call   80107800 <walkpgdir>
        if (!pte)
80107d2b:	85 c0                	test   %eax,%eax
        pte = walkpgdir(pgdir, (char *) a, 0);
80107d2d:	89 c7                	mov    %eax,%edi
        if (!pte)
80107d2f:	0f 84 db 00 00 00    	je     80107e10 <deallocuvm+0x180>
        else if ((*pte & PTE_P) != 0) {
80107d35:	8b 30                	mov    (%eax),%esi
80107d37:	f7 c6 01 00 00 00    	test   $0x1,%esi
80107d3d:	75 99                	jne    80107cd8 <deallocuvm+0x48>
            if ((*pte & PTE_PG) != 0) {
80107d3f:	f7 c6 00 02 00 00    	test   $0x200,%esi
80107d45:	74 c9                	je     80107d10 <deallocuvm+0x80>
                    if (pa == 0)
80107d47:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107d4d:	0f 84 55 01 00 00    	je     80107ea8 <deallocuvm+0x218>
                    if (notShell() && growproc) {
80107d53:	e8 18 c0 ff ff       	call   80103d70 <notShell>
80107d58:	8b 75 14             	mov    0x14(%ebp),%esi
80107d5b:	85 f6                	test   %esi,%esi
80107d5d:	74 b1                	je     80107d10 <deallocuvm+0x80>
80107d5f:	85 c0                	test   %eax,%eax
80107d61:	74 ad                	je     80107d10 <deallocuvm+0x80>
                        for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d66:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107d69:	83 e8 80             	sub    $0xffffff80,%eax
80107d6c:	eb 09                	jmp    80107d77 <deallocuvm+0xe7>
80107d6e:	66 90                	xchg   %ax,%ax
80107d70:	83 c0 1c             	add    $0x1c,%eax
80107d73:	39 d0                	cmp    %edx,%eax
80107d75:	73 99                	jae    80107d10 <deallocuvm+0x80>
                            if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
80107d77:	8b 08                	mov    (%eax),%ecx
80107d79:	85 c9                	test   %ecx,%ecx
80107d7b:	74 f3                	je     80107d70 <deallocuvm+0xe0>
80107d7d:	3b 58 18             	cmp    0x18(%eax),%ebx
80107d80:	75 ee                	jne    80107d70 <deallocuvm+0xe0>
                            {
                                int k;
                                for( k = 0 ; k < MAX_PSYC_PAGES ; k++){
                                    if( p->swapFileEntries[k] == pg->pageid ) {
80107d82:	8b 48 04             	mov    0x4(%eax),%ecx
                                for( k = 0 ; k < MAX_PSYC_PAGES ; k++){
80107d85:	31 d2                	xor    %edx,%edx
80107d87:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80107d8a:	eb 0c                	jmp    80107d98 <deallocuvm+0x108>
80107d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d90:	83 c2 01             	add    $0x1,%edx
80107d93:	83 fa 10             	cmp    $0x10,%edx
80107d96:	74 17                	je     80107daf <deallocuvm+0x11f>
                                    if( p->swapFileEntries[k] == pg->pageid ) {
80107d98:	39 8c 96 00 04 00 00 	cmp    %ecx,0x400(%esi,%edx,4)
80107d9f:	75 ef                	jne    80107d90 <deallocuvm+0x100>
                                        p->swapFileEntries[k] = 0;
80107da1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107da4:	c7 84 91 00 04 00 00 	movl   $0x0,0x400(%ecx,%edx,4)
80107dab:	00 00 00 00 
                                    }
                                }


                                //remove page
                                pg->active = 0;
80107daf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                                pg->pageid = 0;
80107db5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    for (; a < oldsz; a += PGSIZE) {
80107dbc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                                pg->sequel = 0;
80107dc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                                pg->present = 0;
80107dc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                                pg->offset = 0;      //TODO - check if there is a need to save offset
80107dd0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                                pg->physAdress = 0;
80107dd7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                                pg->virtAdress = 0;
80107dde:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)

                                //update proc
                                p->pagesCounter--;
80107de5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107de8:	83 a8 44 04 00 00 01 	subl   $0x1,0x444(%eax)
                                p->pagesinSwap--;
80107def:	83 a8 48 04 00 00 01 	subl   $0x1,0x448(%eax)
    for (; a < oldsz; a += PGSIZE) {
80107df6:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107df9:	0f 87 20 ff ff ff    	ja     80107d1f <deallocuvm+0x8f>
80107dff:	90                   	nop
#endif
        }
    }
    if (DEBUGMODE == 2 && notShell())
        cprintf(">DEALLOCUVM-DONE!\t");
    return newsz;
80107e00:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e06:	5b                   	pop    %ebx
80107e07:	5e                   	pop    %esi
80107e08:	5f                   	pop    %edi
80107e09:	5d                   	pop    %ebp
80107e0a:	c3                   	ret    
80107e0b:	90                   	nop
80107e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107e10:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107e16:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
80107e1c:	e9 ef fe ff ff       	jmp    80107d10 <deallocuvm+0x80>
80107e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107e2e:	83 e8 80             	sub    $0xffffff80,%eax
80107e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                        if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
80107e38:	8b 08                	mov    (%eax),%ecx
80107e3a:	85 c9                	test   %ecx,%ecx
80107e3c:	74 05                	je     80107e43 <deallocuvm+0x1b3>
80107e3e:	3b 58 18             	cmp    0x18(%eax),%ebx
80107e41:	74 1d                	je     80107e60 <deallocuvm+0x1d0>
                    for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107e43:	83 c0 1c             	add    $0x1c,%eax
80107e46:	39 d0                	cmp    %edx,%eax
80107e48:	72 ee                	jb     80107e38 <deallocuvm+0x1a8>
                    if (pg == &p->pages[MAX_TOTAL_PAGES])//if true ->didn't find the virtAdress
80107e4a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80107e4d:	0f 85 a5 fe ff ff    	jne    80107cf8 <deallocuvm+0x68>
                        panic("deallocuvm Error - didn't find the virtAdress!");
80107e53:	83 ec 0c             	sub    $0xc,%esp
80107e56:	68 b0 90 10 80       	push   $0x801090b0
80107e5b:	e8 30 85 ff ff       	call   80100390 <panic>
                            p->pagesCounter--;
80107e60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
                            pg->active = 0;
80107e63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                            pg->pageid = 0;
80107e69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                            pg->sequel = 0;
80107e70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                            pg->present = 0;
80107e77:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                            pg->offset = 0;      //TODO - check if there is a need to save offset
80107e7e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                            pg->physAdress = 0;
80107e85:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                            pg->virtAdress = 0;
80107e8c:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
                            p->pagesCounter--;
80107e93:	83 a9 44 04 00 00 01 	subl   $0x1,0x444(%ecx)
                    if (pg == &p->pages[MAX_TOTAL_PAGES])//if true ->didn't find the virtAdress
80107e9a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80107e9d:	0f 85 55 fe ff ff    	jne    80107cf8 <deallocuvm+0x68>
80107ea3:	eb ae                	jmp    80107e53 <deallocuvm+0x1c3>
80107ea5:	8d 76 00             	lea    0x0(%esi),%esi
                panic("kfree");
80107ea8:	83 ec 0c             	sub    $0xc,%esp
80107eab:	68 ea 86 10 80       	push   $0x801086ea
80107eb0:	e8 db 84 ff ff       	call   80100390 <panic>
80107eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ec0 <allocuvm>:
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80107ec0:	55                   	push   %ebp
80107ec1:	89 e5                	mov    %esp,%ebp
80107ec3:	57                   	push   %edi
80107ec4:	56                   	push   %esi
80107ec5:	53                   	push   %ebx
80107ec6:	83 ec 1c             	sub    $0x1c,%esp
    struct proc *p = myproc();
80107ec9:	e8 d2 be ff ff       	call   80103da0 <myproc>
80107ece:	89 c7                	mov    %eax,%edi
    if (newsz >= KERNBASE)
80107ed0:	8b 45 10             	mov    0x10(%ebp),%eax
80107ed3:	85 c0                	test   %eax,%eax
80107ed5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ed8:	0f 88 ea 01 00 00    	js     801080c8 <allocuvm+0x208>
    if (newsz < oldsz)
80107ede:	3b 45 0c             	cmp    0xc(%ebp),%eax
        return oldsz;
80107ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (newsz < oldsz)
80107ee4:	0f 82 ce 00 00 00    	jb     80107fb8 <allocuvm+0xf8>
    a = PGROUNDUP(oldsz);
80107eea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107ef0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; a < newsz; a += PGSIZE) {
80107ef6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107ef9:	0f 86 bc 00 00 00    	jbe    80107fbb <allocuvm+0xfb>
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107eff:	8d 87 00 04 00 00    	lea    0x400(%edi),%eax
80107f05:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107f08:	eb 62                	jmp    80107f6c <allocuvm+0xac>
80107f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        mem = kalloc();
80107f10:	e8 7b aa ff ff       	call   80102990 <kalloc>
        if (mem == 0) {
80107f15:	85 c0                	test   %eax,%eax
        mem = kalloc();
80107f17:	89 c6                	mov    %eax,%esi
        if (mem == 0) {
80107f19:	0f 84 e4 00 00 00    	je     80108003 <allocuvm+0x143>
        memset(mem, 0, PGSIZE);
80107f1f:	83 ec 04             	sub    $0x4,%esp
80107f22:	68 00 10 00 00       	push   $0x1000
80107f27:	6a 00                	push   $0x0
80107f29:	50                   	push   %eax
80107f2a:	e8 d1 d2 ff ff       	call   80105200 <memset>
        if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80107f2f:	59                   	pop    %ecx
80107f30:	58                   	pop    %eax
80107f31:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107f37:	6a 06                	push   $0x6
80107f39:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f3e:	89 da                	mov    %ebx,%edx
80107f40:	50                   	push   %eax
80107f41:	8b 45 08             	mov    0x8(%ebp),%eax
80107f44:	e8 37 f9 ff ff       	call   80107880 <mappages>
80107f49:	83 c4 10             	add    $0x10,%esp
80107f4c:	85 c0                	test   %eax,%eax
80107f4e:	0f 88 86 01 00 00    	js     801080da <allocuvm+0x21a>
        if (notShell()) {
80107f54:	e8 17 be ff ff       	call   80103d70 <notShell>
80107f59:	85 c0                	test   %eax,%eax
80107f5b:	0f 85 cf 00 00 00    	jne    80108030 <allocuvm+0x170>
    for (; a < newsz; a += PGSIZE) {
80107f61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f67:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107f6a:	76 4f                	jbe    80107fbb <allocuvm+0xfb>
        if (notShell()) {
80107f6c:	e8 ff bd ff ff       	call   80103d70 <notShell>
80107f71:	85 c0                	test   %eax,%eax
80107f73:	74 9b                	je     80107f10 <allocuvm+0x50>
    struct proc *p=myproc();
80107f75:	e8 26 be ff ff       	call   80103da0 <myproc>
    for(pg=p->pages; pg< &p->pages[MAX_TOTAL_PAGES]; pg++){
80107f7a:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80107f80:	8d 88 00 04 00 00    	lea    0x400(%eax),%ecx
        if(!pg->active)
80107f86:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80107f8c:	85 c0                	test   %eax,%eax
80107f8e:	75 0e                	jne    80107f9e <allocuvm+0xde>
80107f90:	eb 3e                	jmp    80107fd0 <allocuvm+0x110>
80107f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107f98:	8b 02                	mov    (%edx),%eax
80107f9a:	85 c0                	test   %eax,%eax
80107f9c:	74 32                	je     80107fd0 <allocuvm+0x110>
    for(pg=p->pages; pg< &p->pages[MAX_TOTAL_PAGES]; pg++){
80107f9e:	83 c2 1c             	add    $0x1c,%edx
80107fa1:	39 ca                	cmp    %ecx,%edx
80107fa3:	72 f3                	jb     80107f98 <allocuvm+0xd8>
                panic("got 32 pages and requested for another page!");
80107fa5:	83 ec 0c             	sub    $0xc,%esp
80107fa8:	68 e0 90 10 80       	push   $0x801090e0
80107fad:	e8 de 83 ff ff       	call   80100390 <panic>
80107fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return oldsz;
80107fb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107fbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fc1:	5b                   	pop    %ebx
80107fc2:	5e                   	pop    %esi
80107fc3:	5f                   	pop    %edi
80107fc4:	5d                   	pop    %ebp
80107fc5:	c3                   	ret    
80107fc6:	8d 76 00             	lea    0x0(%esi),%esi
80107fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES) {
80107fd0:	8b 87 44 04 00 00    	mov    0x444(%edi),%eax
80107fd6:	2b 87 48 04 00 00    	sub    0x448(%edi),%eax
80107fdc:	83 f8 0f             	cmp    $0xf,%eax
80107fdf:	0f 8e 2b ff ff ff    	jle    80107f10 <allocuvm+0x50>
                swapOutPage(p, pgdir);
80107fe5:	83 ec 08             	sub    $0x8,%esp
80107fe8:	ff 75 08             	pushl  0x8(%ebp)
80107feb:	57                   	push   %edi
80107fec:	e8 1f cb ff ff       	call   80104b10 <swapOutPage>
80107ff1:	83 c4 10             	add    $0x10,%esp
        mem = kalloc();
80107ff4:	e8 97 a9 ff ff       	call   80102990 <kalloc>
        if (mem == 0) {
80107ff9:	85 c0                	test   %eax,%eax
        mem = kalloc();
80107ffb:	89 c6                	mov    %eax,%esi
        if (mem == 0) {
80107ffd:	0f 85 1c ff ff ff    	jne    80107f1f <allocuvm+0x5f>
            deallocuvm(pgdir, newsz, oldsz, 0);
80108003:	6a 00                	push   $0x0
80108005:	ff 75 0c             	pushl  0xc(%ebp)
80108008:	ff 75 10             	pushl  0x10(%ebp)
8010800b:	ff 75 08             	pushl  0x8(%ebp)
8010800e:	e8 7d fc ff ff       	call   80107c90 <deallocuvm>
            return 0;
80108013:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010801a:	83 c4 10             	add    $0x10,%esp
}
8010801d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108020:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108023:	5b                   	pop    %ebx
80108024:	5e                   	pop    %esi
80108025:	5f                   	pop    %edi
80108026:	5d                   	pop    %ebp
80108027:	c3                   	ret    
80108028:	90                   	nop
80108029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                if (!pg->active)
80108030:	8b 97 80 00 00 00    	mov    0x80(%edi),%edx
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80108036:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
                if (!pg->active)
8010803c:	85 d2                	test   %edx,%edx
8010803e:	74 19                	je     80108059 <allocuvm+0x199>
80108040:	8b 55 e0             	mov    -0x20(%ebp),%edx
80108043:	90                   	nop
80108044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80108048:	83 c0 1c             	add    $0x1c,%eax
8010804b:	39 d0                	cmp    %edx,%eax
8010804d:	0f 83 b4 00 00 00    	jae    80108107 <allocuvm+0x247>
                if (!pg->active)
80108053:	8b 08                	mov    (%eax),%ecx
80108055:	85 c9                	test   %ecx,%ecx
80108057:	75 ef                	jne    80108048 <allocuvm+0x188>
            p->pagesCounter++;
80108059:	83 87 44 04 00 00 01 	addl   $0x1,0x444(%edi)
            pg->active = 1;
80108060:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
            pg->pageid = p->nextpageid++;
80108066:	8b 97 40 04 00 00    	mov    0x440(%edi),%edx
8010806c:	8d 4a 01             	lea    0x1(%edx),%ecx
8010806f:	89 8f 40 04 00 00    	mov    %ecx,0x440(%edi)
80108075:	89 50 04             	mov    %edx,0x4(%eax)
            pg->present = 1;
80108078:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
            pg->offset = 0;
8010807f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
            pg->sequel = p->pagesequel++;
80108086:	8b 97 4c 04 00 00    	mov    0x44c(%edi),%edx
8010808c:	8d 4a 01             	lea    0x1(%edx),%ecx
8010808f:	89 8f 4c 04 00 00    	mov    %ecx,0x44c(%edi)
80108095:	89 50 08             	mov    %edx,0x8(%eax)
            pgtble = walkpgdir(pgdir, (char *) a, 0);
80108098:	31 c9                	xor    %ecx,%ecx
            pg->physAdress = mem;
8010809a:	89 70 14             	mov    %esi,0x14(%eax)
            pg->virtAdress = (char *) a;
8010809d:	89 58 18             	mov    %ebx,0x18(%eax)
            pgtble = walkpgdir(pgdir, (char *) a, 0);
801080a0:	89 da                	mov    %ebx,%edx
801080a2:	8b 45 08             	mov    0x8(%ebp),%eax
801080a5:	e8 56 f7 ff ff       	call   80107800 <walkpgdir>
            *pgtble = PTE_PG_0(*pgtble); // Not Paged out to secondary storage
801080aa:	8b 10                	mov    (%eax),%edx
801080ac:	80 e6 fd             	and    $0xfd,%dh
801080af:	83 ca 01             	or     $0x1,%edx
801080b2:	89 10                	mov    %edx,(%eax)
            lcr3(V2P(p->pgdir));
801080b4:	8b 47 04             	mov    0x4(%edi),%eax
801080b7:	05 00 00 00 80       	add    $0x80000000,%eax
801080bc:	0f 22 d8             	mov    %eax,%cr3
801080bf:	e9 9d fe ff ff       	jmp    80107f61 <allocuvm+0xa1>
801080c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return 0;
801080c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801080cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080d5:	5b                   	pop    %ebx
801080d6:	5e                   	pop    %esi
801080d7:	5f                   	pop    %edi
801080d8:	5d                   	pop    %ebp
801080d9:	c3                   	ret    
            deallocuvm(pgdir, newsz, oldsz, 0);
801080da:	6a 00                	push   $0x0
801080dc:	ff 75 0c             	pushl  0xc(%ebp)
801080df:	ff 75 10             	pushl  0x10(%ebp)
801080e2:	ff 75 08             	pushl  0x8(%ebp)
801080e5:	e8 a6 fb ff ff       	call   80107c90 <deallocuvm>
            kfree(mem);
801080ea:	89 34 24             	mov    %esi,(%esp)
801080ed:	e8 ee a6 ff ff       	call   801027e0 <kfree>
            return 0;
801080f2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801080f9:	83 c4 10             	add    $0x10,%esp
}
801080fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801080ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108102:	5b                   	pop    %ebx
80108103:	5e                   	pop    %esi
80108104:	5f                   	pop    %edi
80108105:	5d                   	pop    %ebp
80108106:	c3                   	ret    
            panic("no page in proc");
80108107:	83 ec 0c             	sub    $0xc,%esp
8010810a:	68 2d 90 10 80       	push   $0x8010902d
8010810f:	e8 7c 82 ff ff       	call   80100390 <panic>
80108114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010811a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108120 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir) {
80108120:	55                   	push   %ebp
80108121:	89 e5                	mov    %esp,%ebp
80108123:	57                   	push   %edi
80108124:	56                   	push   %esi
80108125:	53                   	push   %ebx
80108126:	83 ec 0c             	sub    $0xc,%esp
80108129:	8b 75 08             	mov    0x8(%ebp),%esi
    if (DEBUGMODE == 2 && notShell())
        cprintf("FREEVM");
    uint
            i;

    if (pgdir == 0)
8010812c:	85 f6                	test   %esi,%esi
8010812e:	74 59                	je     80108189 <freevm+0x69>
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0, 0);
80108130:	6a 00                	push   $0x0
80108132:	6a 00                	push   $0x0
80108134:	89 f3                	mov    %esi,%ebx
80108136:	68 00 00 00 80       	push   $0x80000000
8010813b:	56                   	push   %esi
8010813c:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108142:	e8 49 fb ff ff       	call   80107c90 <deallocuvm>
80108147:	83 c4 10             	add    $0x10,%esp
8010814a:	eb 0b                	jmp    80108157 <freevm+0x37>
8010814c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108150:	83 c3 04             	add    $0x4,%ebx
    for (i = 0; i < NPDENTRIES; i++) {
80108153:	39 fb                	cmp    %edi,%ebx
80108155:	74 23                	je     8010817a <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
80108157:	8b 03                	mov    (%ebx),%eax
80108159:	a8 01                	test   $0x1,%al
8010815b:	74 f3                	je     80108150 <freevm+0x30>
            char *v = P2V(PTE_ADDR(pgdir[i]));
8010815d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(v);
80108162:	83 ec 0c             	sub    $0xc,%esp
80108165:	83 c3 04             	add    $0x4,%ebx
            char *v = P2V(PTE_ADDR(pgdir[i]));
80108168:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(v);
8010816d:	50                   	push   %eax
8010816e:	e8 6d a6 ff ff       	call   801027e0 <kfree>
80108173:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80108176:	39 fb                	cmp    %edi,%ebx
80108178:	75 dd                	jne    80108157 <freevm+0x37>
        }
    }
    kfree((char *) pgdir);
8010817a:	89 75 08             	mov    %esi,0x8(%ebp)
    if (DEBUGMODE == 2 && notShell())
        cprintf(">FREEVM-DONE!\t");
}
8010817d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108180:	5b                   	pop    %ebx
80108181:	5e                   	pop    %esi
80108182:	5f                   	pop    %edi
80108183:	5d                   	pop    %ebp
    kfree((char *) pgdir);
80108184:	e9 57 a6 ff ff       	jmp    801027e0 <kfree>
        panic("freevm: no pgdir");
80108189:	83 ec 0c             	sub    $0xc,%esp
8010818c:	68 3d 90 10 80       	push   $0x8010903d
80108191:	e8 fa 81 ff ff       	call   80100390 <panic>
80108196:	8d 76 00             	lea    0x0(%esi),%esi
80108199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801081a0 <setupkvm>:
setupkvm(void) {
801081a0:	55                   	push   %ebp
801081a1:	89 e5                	mov    %esp,%ebp
801081a3:	56                   	push   %esi
801081a4:	53                   	push   %ebx
    if ((pgdir = (pde_t *) kalloc()) == 0)
801081a5:	e8 e6 a7 ff ff       	call   80102990 <kalloc>
801081aa:	85 c0                	test   %eax,%eax
801081ac:	89 c6                	mov    %eax,%esi
801081ae:	74 42                	je     801081f2 <setupkvm+0x52>
    memset(pgdir, 0, PGSIZE);
801081b0:	83 ec 04             	sub    $0x4,%esp
    for (k = kmap; k < &kmap[NELEM(kmap)];
801081b3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
    memset(pgdir, 0, PGSIZE);
801081b8:	68 00 10 00 00       	push   $0x1000
801081bd:	6a 00                	push   $0x0
801081bf:	50                   	push   %eax
801081c0:	e8 3b d0 ff ff       	call   80105200 <memset>
801081c5:	83 c4 10             	add    $0x10,%esp
                 (uint) k->phys_start, k->perm) < 0) {
801081c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801081cb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801081ce:	83 ec 08             	sub    $0x8,%esp
801081d1:	8b 13                	mov    (%ebx),%edx
801081d3:	ff 73 0c             	pushl  0xc(%ebx)
801081d6:	50                   	push   %eax
801081d7:	29 c1                	sub    %eax,%ecx
801081d9:	89 f0                	mov    %esi,%eax
801081db:	e8 a0 f6 ff ff       	call   80107880 <mappages>
801081e0:	83 c4 10             	add    $0x10,%esp
801081e3:	85 c0                	test   %eax,%eax
801081e5:	78 19                	js     80108200 <setupkvm+0x60>
    k++)
801081e7:	83 c3 10             	add    $0x10,%ebx
    for (k = kmap; k < &kmap[NELEM(kmap)];
801081ea:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801081f0:	75 d6                	jne    801081c8 <setupkvm+0x28>
}
801081f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801081f5:	89 f0                	mov    %esi,%eax
801081f7:	5b                   	pop    %ebx
801081f8:	5e                   	pop    %esi
801081f9:	5d                   	pop    %ebp
801081fa:	c3                   	ret    
801081fb:	90                   	nop
801081fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        freevm(pgdir);
80108200:	83 ec 0c             	sub    $0xc,%esp
80108203:	56                   	push   %esi
        return 0;
80108204:	31 f6                	xor    %esi,%esi
        freevm(pgdir);
80108206:	e8 15 ff ff ff       	call   80108120 <freevm>
        return 0;
8010820b:	83 c4 10             	add    $0x10,%esp
}
8010820e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108211:	89 f0                	mov    %esi,%eax
80108213:	5b                   	pop    %ebx
80108214:	5e                   	pop    %esi
80108215:	5d                   	pop    %ebp
80108216:	c3                   	ret    
80108217:	89 f6                	mov    %esi,%esi
80108219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108220 <kvmalloc>:
kvmalloc(void) {
80108220:	55                   	push   %ebp
80108221:	89 e5                	mov    %esp,%ebp
80108223:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
80108226:	e8 75 ff ff ff       	call   801081a0 <setupkvm>
8010822b:	a3 e8 7c 12 80       	mov    %eax,0x80127ce8
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80108230:	05 00 00 00 80       	add    $0x80000000,%eax
80108235:	0f 22 d8             	mov    %eax,%cr3
}
80108238:	c9                   	leave  
80108239:	c3                   	ret    
8010823a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108240 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva) {
80108240:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80108241:	31 c9                	xor    %ecx,%ecx
clearpteu(pde_t *pgdir, char *uva) {
80108243:	89 e5                	mov    %esp,%ebp
80108245:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
80108248:	8b 55 0c             	mov    0xc(%ebp),%edx
8010824b:	8b 45 08             	mov    0x8(%ebp),%eax
8010824e:	e8 ad f5 ff ff       	call   80107800 <walkpgdir>
    if (pte == 0)
80108253:	85 c0                	test   %eax,%eax
80108255:	74 05                	je     8010825c <clearpteu+0x1c>
        panic("clearpteu");
    *pte &= ~PTE_U;
80108257:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010825a:	c9                   	leave  
8010825b:	c3                   	ret    
        panic("clearpteu");
8010825c:	83 ec 0c             	sub    $0xc,%esp
8010825f:	68 4e 90 10 80       	push   $0x8010904e
80108264:	e8 27 81 ff ff       	call   80100390 <panic>
80108269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108270 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz) {
80108270:	55                   	push   %ebp
80108271:	89 e5                	mov    %esp,%ebp
80108273:	57                   	push   %edi
80108274:	56                   	push   %esi
80108275:	53                   	push   %ebx
80108276:	83 ec 1c             	sub    $0x1c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0)
80108279:	e8 22 ff ff ff       	call   801081a0 <setupkvm>
8010827e:	85 c0                	test   %eax,%eax
80108280:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108283:	0f 84 a3 00 00 00    	je     8010832c <copyuvm+0xbc>
        return 0;
    for (i = 0; i < sz; i += PGSIZE) {
80108289:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010828c:	85 c9                	test   %ecx,%ecx
8010828e:	0f 84 98 00 00 00    	je     8010832c <copyuvm+0xbc>
80108294:	31 f6                	xor    %esi,%esi
80108296:	eb 4e                	jmp    801082e6 <copyuvm+0x76>
80108298:	90                   	nop
80108299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0)
            goto bad;
        memmove(mem, (char *) P2V(pa), PGSIZE);
801082a0:	83 ec 04             	sub    $0x4,%esp
801082a3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801082a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801082ac:	68 00 10 00 00       	push   $0x1000
801082b1:	57                   	push   %edi
801082b2:	50                   	push   %eax
801082b3:	e8 f8 cf ff ff       	call   801052b0 <memmove>
        if (mappages(d, (void *) i, PGSIZE, V2P(mem), flags) < 0)
801082b8:	58                   	pop    %eax
801082b9:	5a                   	pop    %edx
801082ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801082bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801082c5:	53                   	push   %ebx
801082c6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801082cc:	52                   	push   %edx
801082cd:	89 f2                	mov    %esi,%edx
801082cf:	e8 ac f5 ff ff       	call   80107880 <mappages>
801082d4:	83 c4 10             	add    $0x10,%esp
801082d7:	85 c0                	test   %eax,%eax
801082d9:	78 3c                	js     80108317 <copyuvm+0xa7>
    for (i = 0; i < sz; i += PGSIZE) {
801082db:	81 c6 00 10 00 00    	add    $0x1000,%esi
801082e1:	39 75 0c             	cmp    %esi,0xc(%ebp)
801082e4:	76 46                	jbe    8010832c <copyuvm+0xbc>
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801082e6:	8b 45 08             	mov    0x8(%ebp),%eax
801082e9:	31 c9                	xor    %ecx,%ecx
801082eb:	89 f2                	mov    %esi,%edx
801082ed:	e8 0e f5 ff ff       	call   80107800 <walkpgdir>
801082f2:	85 c0                	test   %eax,%eax
801082f4:	74 41                	je     80108337 <copyuvm+0xc7>
        if ( (!(*pte & PTE_P)) && ( !(*pte & PTE_PG) ) )
801082f6:	8b 18                	mov    (%eax),%ebx
801082f8:	f7 c3 01 02 00 00    	test   $0x201,%ebx
801082fe:	74 44                	je     80108344 <copyuvm+0xd4>
        pa = PTE_ADDR(*pte);
80108300:	89 df                	mov    %ebx,%edi
        flags = PTE_FLAGS(*pte);
80108302:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
        pa = PTE_ADDR(*pte);
80108308:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        if ((mem = kalloc()) == 0)
8010830e:	e8 7d a6 ff ff       	call   80102990 <kalloc>
80108313:	85 c0                	test   %eax,%eax
80108315:	75 89                	jne    801082a0 <copyuvm+0x30>
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-DONE!\t");
    return d;

    bad:
    freevm(d);
80108317:	83 ec 0c             	sub    $0xc,%esp
8010831a:	ff 75 e0             	pushl  -0x20(%ebp)
8010831d:	e8 fe fd ff ff       	call   80108120 <freevm>
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-FAILED!\t");
    return 0;
80108322:	83 c4 10             	add    $0x10,%esp
80108325:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
8010832c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010832f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108332:	5b                   	pop    %ebx
80108333:	5e                   	pop    %esi
80108334:	5f                   	pop    %edi
80108335:	5d                   	pop    %ebp
80108336:	c3                   	ret    
            panic("copyuvm: pte should exist");
80108337:	83 ec 0c             	sub    $0xc,%esp
8010833a:	68 58 90 10 80       	push   $0x80109058
8010833f:	e8 4c 80 ff ff       	call   80100390 <panic>
            panic("copyuvm: page not present");
80108344:	83 ec 0c             	sub    $0xc,%esp
80108347:	68 72 90 10 80       	push   $0x80109072
8010834c:	e8 3f 80 ff ff       	call   80100390 <panic>
80108351:	eb 0d                	jmp    80108360 <uva2ka>
80108353:	90                   	nop
80108354:	90                   	nop
80108355:	90                   	nop
80108356:	90                   	nop
80108357:	90                   	nop
80108358:	90                   	nop
80108359:	90                   	nop
8010835a:	90                   	nop
8010835b:	90                   	nop
8010835c:	90                   	nop
8010835d:	90                   	nop
8010835e:	90                   	nop
8010835f:	90                   	nop

80108360 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva) {
80108360:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80108361:	31 c9                	xor    %ecx,%ecx
uva2ka(pde_t *pgdir, char *uva) {
80108363:	89 e5                	mov    %esp,%ebp
80108365:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
80108368:	8b 55 0c             	mov    0xc(%ebp),%edx
8010836b:	8b 45 08             	mov    0x8(%ebp),%eax
8010836e:	e8 8d f4 ff ff       	call   80107800 <walkpgdir>
    if ((*pte & PTE_P) == 0)
80108373:	8b 00                	mov    (%eax),%eax
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    return (char *) P2V(PTE_ADDR(*pte));
}
80108375:	c9                   	leave  
    if ((*pte & PTE_U) == 0)
80108376:	89 c2                	mov    %eax,%edx
    return (char *) P2V(PTE_ADDR(*pte));
80108378:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((*pte & PTE_U) == 0)
8010837d:	83 e2 05             	and    $0x5,%edx
    return (char *) P2V(PTE_ADDR(*pte));
80108380:	05 00 00 00 80       	add    $0x80000000,%eax
80108385:	83 fa 05             	cmp    $0x5,%edx
80108388:	ba 00 00 00 00       	mov    $0x0,%edx
8010838d:	0f 45 c2             	cmovne %edx,%eax
}
80108390:	c3                   	ret    
80108391:	eb 0d                	jmp    801083a0 <copyout>
80108393:	90                   	nop
80108394:	90                   	nop
80108395:	90                   	nop
80108396:	90                   	nop
80108397:	90                   	nop
80108398:	90                   	nop
80108399:	90                   	nop
8010839a:	90                   	nop
8010839b:	90                   	nop
8010839c:	90                   	nop
8010839d:	90                   	nop
8010839e:	90                   	nop
8010839f:	90                   	nop

801083a0 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len) {
801083a0:	55                   	push   %ebp
801083a1:	89 e5                	mov    %esp,%ebp
801083a3:	57                   	push   %edi
801083a4:	56                   	push   %esi
801083a5:	53                   	push   %ebx
801083a6:	83 ec 1c             	sub    $0x1c,%esp
801083a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801083ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801083af:	8b 7d 10             	mov    0x10(%ebp),%edi
    char *buf, *pa0;
    uint n, va0;

    buf = (char *) p;
    while (len > 0) {
801083b2:	85 db                	test   %ebx,%ebx
801083b4:	75 40                	jne    801083f6 <copyout+0x56>
801083b6:	eb 70                	jmp    80108428 <copyout+0x88>
801083b8:	90                   	nop
801083b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        va0 = (uint) PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char *) va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (va - va0);
801083c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801083c3:	89 f1                	mov    %esi,%ecx
801083c5:	29 d1                	sub    %edx,%ecx
801083c7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801083cd:	39 d9                	cmp    %ebx,%ecx
801083cf:	0f 47 cb             	cmova  %ebx,%ecx
        if (n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
801083d2:	29 f2                	sub    %esi,%edx
801083d4:	83 ec 04             	sub    $0x4,%esp
801083d7:	01 d0                	add    %edx,%eax
801083d9:	51                   	push   %ecx
801083da:	57                   	push   %edi
801083db:	50                   	push   %eax
801083dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801083df:	e8 cc ce ff ff       	call   801052b0 <memmove>
        len -= n;
        buf += n;
801083e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    while (len > 0) {
801083e7:	83 c4 10             	add    $0x10,%esp
        va = va0 + PGSIZE;
801083ea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
        buf += n;
801083f0:	01 cf                	add    %ecx,%edi
    while (len > 0) {
801083f2:	29 cb                	sub    %ecx,%ebx
801083f4:	74 32                	je     80108428 <copyout+0x88>
        va0 = (uint) PGROUNDDOWN(va);
801083f6:	89 d6                	mov    %edx,%esi
        pa0 = uva2ka(pgdir, (char *) va0);
801083f8:	83 ec 08             	sub    $0x8,%esp
        va0 = (uint) PGROUNDDOWN(va);
801083fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801083fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        pa0 = uva2ka(pgdir, (char *) va0);
80108404:	56                   	push   %esi
80108405:	ff 75 08             	pushl  0x8(%ebp)
80108408:	e8 53 ff ff ff       	call   80108360 <uva2ka>
        if (pa0 == 0)
8010840d:	83 c4 10             	add    $0x10,%esp
80108410:	85 c0                	test   %eax,%eax
80108412:	75 ac                	jne    801083c0 <copyout+0x20>
    }
    return 0;
}
80108414:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80108417:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010841c:	5b                   	pop    %ebx
8010841d:	5e                   	pop    %esi
8010841e:	5f                   	pop    %edi
8010841f:	5d                   	pop    %ebp
80108420:	c3                   	ret    
80108421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108428:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010842b:	31 c0                	xor    %eax,%eax
}
8010842d:	5b                   	pop    %ebx
8010842e:	5e                   	pop    %esi
8010842f:	5f                   	pop    %edi
80108430:	5d                   	pop    %ebp
80108431:	c3                   	ret    
