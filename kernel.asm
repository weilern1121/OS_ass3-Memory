
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 32 10 80       	mov    $0x80103230,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 74 10 80       	push   $0x801074e0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 55 47 00 00       	call   801047b0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 74 10 80       	push   $0x801074e7
80100097:	50                   	push   %eax
80100098:	e8 03 46 00 00       	call   801046a0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
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
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 c7 47 00 00       	call   801048b0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 69 48 00 00       	call   801049d0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 45 00 00       	call   801046e0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
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
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ee 74 10 80       	push   $0x801074ee
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

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
801001ae:	e8 cd 45 00 00       	call   80104780 <holdingsleep>
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
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 f7 22 00 00       	jmp    801024c0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 74 10 80       	push   $0x801074ff
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
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
801001ef:	e8 8c 45 00 00       	call   80104780 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 45 00 00       	call   80104740 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 a0 46 00 00       	call   801048b0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
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
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 6f 47 00 00       	jmp    801049d0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 75 10 80       	push   $0x80107506
80100269:	e8 02 01 00 00       	call   80100370 <panic>
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
80100280:	e8 fb 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 1f 46 00 00       	call   801048b0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 1e 40 00 00       	call   801042e0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 d9 38 00 00       	call   80103bb0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 e5 46 00 00       	call   801049d0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 ad 13 00 00       	call   801016a0 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 85 46 00 00       	call   801049d0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 4d 13 00 00       	call   801016a0 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 32 27 00 00       	call   80102ac0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 0d 75 10 80       	push   $0x8010750d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 77 7e 10 80 	movl   $0x80107e77,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 13 44 00 00       	call   801047d0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 21 75 10 80       	push   $0x80107521
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 91 5c 00 00       	call   801060b0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 d8 5b 00 00       	call   801060b0 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 cc 5b 00 00       	call   801060b0 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 c0 5b 00 00       	call   801060b0 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 b7 45 00 00       	call   80104ad0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 f2 44 00 00       	call   80104a20 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 25 75 10 80       	push   $0x80107525
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 50 75 10 80 	movzbl -0x7fef8ab0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 6c 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 90 42 00 00       	call   801048b0 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 84 43 00 00       	call   801049d0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 4b 10 00 00       	call   801016a0 <ilock>

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
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 be 42 00 00       	call   801049d0 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 38 75 10 80       	mov    $0x80107538,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 e3 40 00 00       	call   801048b0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 3f 75 10 80       	push   $0x8010753f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 a8 40 00 00       	call   801048b0 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100836:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 63 41 00 00       	call   801049d0 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008f1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008f6:	e8 f5 3b 00 00       	call   801044f0 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100934:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 64 3c 00 00       	jmp    801045e0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 48 75 10 80       	push   $0x80107548
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 fb 3d 00 00       	call   801047b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 92 1c 00 00       	call   80102670 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "defs.h"
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv) {
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3 + MAXARG + 1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
801009fc:	e8 af 31 00 00       	call   80103bb0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

    begin_op();
80100a07:	e8 14 25 00 00       	call   80102f20 <begin_op>

    if ((ip = namei(path)) == 0) {
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 d9 14 00 00       	call   80101ef0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 73 0c 00 00       	call   801016a0 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char *) &elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 42 0f 00 00       	call   80101980 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

    bad:
    if (pgdir)
        freevm(pgdir);
    if (ip) {
        iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 e1 0e 00 00       	call   80101930 <iunlockput>
        end_op();
80100a4f:	e8 3c 25 00 00       	call   80102f90 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
    }
    if (DEBUGMODE == 1)
        cprintf(">EXEC-FAILED-GOTO_BAD!\t");
    return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char *) &elf, 0, sizeof(elf)) != sizeof(elf))
        goto bad;
    if (elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
        goto bad;

    if ((pgdir = setupkvm()) == 0)
80100a74:	e8 c7 67 00 00       	call   80107240 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
        goto bad;

    // Load program into memory.
    sz = 0;
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
        if (readi(ip, (char *) &ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 b3 0e 00 00       	call   80101980 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
            goto bad;
        if (ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
            continue;
        if (ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
            goto bad;
        if (ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
            goto bad;
        if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 87 65 00 00       	call   80107090 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
            goto bad;
        if (ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
            goto bad;
        if (loaduvm(pgdir, (char *) ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 91 64 00 00       	call   80106fd0 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cprintf(">EXEC-DONE!\t");
    return 0;

    bad:
    if (pgdir)
        freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 62 66 00 00       	call   801071c0 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
        if (ph.vaddr % PGSIZE != 0)
            goto bad;
        if (loaduvm(pgdir, (char *) ph.vaddr, ip, ph.off, ph.filesz) < 0)
            goto bad;
    }
    iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 c1 0d 00 00       	call   80101930 <iunlockput>
    end_op();
80100b6f:	e8 1c 24 00 00       	call   80102f90 <end_op>
    ip = 0;

    // Allocate two pages at the next page boundary.
    // Make the first inaccessible.  Use the second as the user stack.
    sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
    end_op();
    ip = 0;

    // Allocate two pages at the next page boundary.
    // Make the first inaccessible.  Use the second as the user stack.
    sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 f6 64 00 00       	call   80107090 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
        cprintf(">EXEC-DONE!\t");
    return 0;

    bad:
    if (pgdir)
        freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 0f 66 00 00       	call   801071c0 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
        iunlockput(ip);
        end_op();
    }
    if (DEBUGMODE == 1)
        cprintf(">EXEC-FAILED-GOTO_BAD!\t");
    return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
    struct proc *curproc = myproc();

    begin_op();

    if ((ip = namei(path)) == 0) {
        end_op();
80100bbe:	e8 cd 23 00 00       	call   80102f90 <end_op>
        cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 61 75 10 80       	push   $0x80107561
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
        return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
    // Allocate two pages at the next page boundary.
    // Make the first inaccessible.  Use the second as the user stack.
    sz = PGROUNDUP(sz);
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
        goto bad;
    clearpteu(pgdir, (char *) (sz - 2 * PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for (argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
    // Allocate two pages at the next page boundary.
    // Make the first inaccessible.  Use the second as the user stack.
    sz = PGROUNDUP(sz);
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
        goto bad;
    clearpteu(pgdir, (char *) (sz - 2 * PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 ea 66 00 00       	call   801072e0 <clearpteu>
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for (argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 2e 40 00 00       	call   80104c60 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	59                   	pop    %ecx

    // Push argument strings, prepare rest of stack in ustack.
    for (argc = 0; argv[argc]; argc++) {
        if (argc >= MAXARG)
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 1b 40 00 00       	call   80104c60 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 ea 67 00 00       	call   80107440 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
        goto bad;
    clearpteu(pgdir, (char *) (sz - 2 * PGSIZE));
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for (argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
        if (argc >= MAXARG)
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
            goto bad;
        ustack[3 + argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
        goto bad;
    clearpteu(pgdir, (char *) (sz - 2 * PGSIZE));
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for (argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
        if (argc >= MAXARG)
            goto bad;
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
            goto bad;
        ustack[3 + argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
        goto bad;
    clearpteu(pgdir, (char *) (sz - 2 * PGSIZE));
    sp = sz;

    // Push argument strings, prepare rest of stack in ustack.
    for (argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    }
    ustack[3 + argc] = 0;

    ustack[0] = 0xffffffff;  // fake return PC
    ustack[1] = argc;
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
            goto bad;
        ustack[3 + argc] = sp;
    }
    ustack[3 + argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

    ustack[0] = 0xffffffff;  // fake return PC
    ustack[1] = argc;
80100c95:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer

    sp -= (3 + argc + 1) * 4;
80100c9b:	89 df                	mov    %ebx,%edi
            goto bad;
        ustack[3 + argc] = sp;
    }
    ustack[3 + argc] = 0;

    ustack[0] = 0xffffffff;  // fake return PC
80100c9d:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca4:	ff ff ff 
    ustack[1] = argc;
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100ca7:	29 c1                	sub    %eax,%ecx

    sp -= (3 + argc + 1) * 4;
80100ca9:	83 c0 0c             	add    $0xc,%eax
80100cac:	29 c7                	sub    %eax,%edi
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100cae:	50                   	push   %eax
80100caf:	52                   	push   %edx
80100cb0:	57                   	push   %edi
80100cb1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
    }
    ustack[3 + argc] = 0;

    ustack[0] = 0xffffffff;  // fake return PC
    ustack[1] = argc;
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80100cb7:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

    sp -= (3 + argc + 1) * 4;
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100cbd:	e8 7e 67 00 00       	call   80107440 <copyout>
80100cc2:	83 c4 10             	add    $0x10,%esp
80100cc5:	85 c0                	test   %eax,%eax
80100cc7:	0f 88 d6 fe ff ff    	js     80100ba3 <exec+0x1b3>
        goto bad;

    // Save program name for debugging.
    for (last = s = path; *s; s++)
80100ccd:	8b 45 08             	mov    0x8(%ebp),%eax
80100cd0:	0f b6 10             	movzbl (%eax),%edx
80100cd3:	84 d2                	test   %dl,%dl
80100cd5:	74 19                	je     80100cf0 <exec+0x300>
80100cd7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cda:	83 c0 01             	add    $0x1,%eax
        if (*s == '/')
            last = s + 1;
80100cdd:	80 fa 2f             	cmp    $0x2f,%dl
    sp -= (3 + argc + 1) * 4;
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
        goto bad;

    // Save program name for debugging.
    for (last = s = path; *s; s++)
80100ce0:	0f b6 10             	movzbl (%eax),%edx
        if (*s == '/')
            last = s + 1;
80100ce3:	0f 44 c8             	cmove  %eax,%ecx
80100ce6:	83 c0 01             	add    $0x1,%eax
    sp -= (3 + argc + 1) * 4;
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
        goto bad;

    // Save program name for debugging.
    for (last = s = path; *s; s++)
80100ce9:	84 d2                	test   %dl,%dl
80100ceb:	75 f0                	jne    80100cdd <exec+0x2ed>
80100ced:	89 4d 08             	mov    %ecx,0x8(%ebp)
        if (*s == '/')
            last = s + 1;
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf0:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100cf6:	52                   	push   %edx
80100cf7:	6a 10                	push   $0x10
80100cf9:	ff 75 08             	pushl  0x8(%ebp)
80100cfc:	89 d8                	mov    %ebx,%eax
80100cfe:	83 c0 6c             	add    $0x6c,%eax
80100d01:	50                   	push   %eax
80100d02:	e8 19 3f 00 00       	call   80104c20 <safestrcpy>

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
80100d07:	89 d8                	mov    %ebx,%eax
    curproc->pgdir = pgdir;
    //TODO WE NEED CLOSE AND OPEN SWAP
    if (curproc->swapFile) {
80100d09:	83 c4 10             	add    $0x10,%esp
            last = s + 1;
    safestrcpy(curproc->name, last, sizeof(curproc->name));

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
    curproc->pgdir = pgdir;
80100d0c:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    //TODO WE NEED CLOSE AND OPEN SWAP
    if (curproc->swapFile) {
80100d12:	83 78 7c 00          	cmpl   $0x0,0x7c(%eax)
        if (*s == '/')
            last = s + 1;
    safestrcpy(curproc->name, last, sizeof(curproc->name));

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
80100d16:	8b 5b 04             	mov    0x4(%ebx),%ebx
    curproc->pgdir = pgdir;
80100d19:	89 48 04             	mov    %ecx,0x4(%eax)
    //TODO WE NEED CLOSE AND OPEN SWAP
    if (curproc->swapFile) {
80100d1c:	74 1e                	je     80100d3c <exec+0x34c>
        removeSwapFile(curproc);
80100d1e:	83 ec 0c             	sub    $0xc,%esp
80100d21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100d27:	50                   	push   %eax
80100d28:	e8 a3 12 00 00       	call   80101fd0 <removeSwapFile>
        createSwapFile(curproc);
80100d2d:	58                   	pop    %eax
80100d2e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d34:	e8 97 14 00 00       	call   801021d0 <createSwapFile>
80100d39:	83 c4 10             	add    $0x10,%esp
    }
    curproc->sz = sz;
80100d3c:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    curproc->tf->eip = elf.entry;  // main
    curproc->tf->esp = sp;
    switchuvm(curproc);
80100d42:	83 ec 0c             	sub    $0xc,%esp
    //TODO WE NEED CLOSE AND OPEN SWAP
    if (curproc->swapFile) {
        removeSwapFile(curproc);
        createSwapFile(curproc);
    }
    curproc->sz = sz;
80100d45:	89 31                	mov    %esi,(%ecx)
    curproc->tf->eip = elf.entry;  // main
80100d47:	8b 41 18             	mov    0x18(%ecx),%eax
80100d4a:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d50:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
80100d53:	8b 41 18             	mov    0x18(%ecx),%eax
80100d56:	89 78 44             	mov    %edi,0x44(%eax)
    switchuvm(curproc);
80100d59:	51                   	push   %ecx
80100d5a:	e8 e1 60 00 00       	call   80106e40 <switchuvm>
    freevm(oldpgdir);
80100d5f:	89 1c 24             	mov    %ebx,(%esp)
80100d62:	e8 59 64 00 00       	call   801071c0 <freevm>
    if (DEBUGMODE == 1)
        cprintf(">EXEC-DONE!\t");
    return 0;
80100d67:	83 c4 10             	add    $0x10,%esp
80100d6a:	31 c0                	xor    %eax,%eax
80100d6c:	e9 eb fc ff ff       	jmp    80100a5c <exec+0x6c>
80100d71:	66 90                	xchg   %ax,%ax
80100d73:	66 90                	xchg   %ax,%ax
80100d75:	66 90                	xchg   %ax,%ax
80100d77:	66 90                	xchg   %ax,%ax
80100d79:	66 90                	xchg   %ax,%ax
80100d7b:	66 90                	xchg   %ax,%ax
80100d7d:	66 90                	xchg   %ax,%ax
80100d7f:	90                   	nop

80100d80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d86:	68 6d 75 10 80       	push   $0x8010756d
80100d8b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d90:	e8 1b 3a 00 00       	call   801047b0 <initlock>
}
80100d95:	83 c4 10             	add    $0x10,%esp
80100d98:	c9                   	leave  
80100d99:	c3                   	ret    
80100d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100da0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da9:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100dac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100db1:	e8 fa 3a 00 00       	call   801048b0 <acquire>
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	eb 10                	jmp    80100dcb <filealloc+0x2b>
80100dbb:	90                   	nop
80100dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100dc9:	74 25                	je     80100df0 <filealloc+0x50>
    if(f->ref == 0){
80100dcb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dce:	85 c0                	test   %eax,%eax
80100dd0:	75 ee                	jne    80100dc0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dd2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100dd5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ddc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100de1:	e8 ea 3b 00 00       	call   801049d0 <release>
      return f;
80100de6:	89 d8                	mov    %ebx,%eax
80100de8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100deb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dee:	c9                   	leave  
80100def:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100df0:	83 ec 0c             	sub    $0xc,%esp
80100df3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df8:	e8 d3 3b 00 00       	call   801049d0 <release>
  return 0;
80100dfd:	83 c4 10             	add    $0x10,%esp
80100e00:	31 c0                	xor    %eax,%eax
}
80100e02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e05:	c9                   	leave  
80100e06:	c3                   	ret    
80100e07:	89 f6                	mov    %esi,%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
80100e14:	83 ec 10             	sub    $0x10,%esp
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e1a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1f:	e8 8c 3a 00 00       	call   801048b0 <acquire>
  if(f->ref < 1)
80100e24:	8b 43 04             	mov    0x4(%ebx),%eax
80100e27:	83 c4 10             	add    $0x10,%esp
80100e2a:	85 c0                	test   %eax,%eax
80100e2c:	7e 1a                	jle    80100e48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e31:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e37:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e3c:	e8 8f 3b 00 00       	call   801049d0 <release>
  return f;
}
80100e41:	89 d8                	mov    %ebx,%eax
80100e43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e46:	c9                   	leave  
80100e47:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e48:	83 ec 0c             	sub    $0xc,%esp
80100e4b:	68 74 75 10 80       	push   $0x80107574
80100e50:	e8 1b f5 ff ff       	call   80100370 <panic>
80100e55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e60 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	57                   	push   %edi
80100e64:	56                   	push   %esi
80100e65:	53                   	push   %ebx
80100e66:	83 ec 28             	sub    $0x28,%esp
80100e69:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e6c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e71:	e8 3a 3a 00 00       	call   801048b0 <acquire>
  if(f->ref < 1)
80100e76:	8b 47 04             	mov    0x4(%edi),%eax
80100e79:	83 c4 10             	add    $0x10,%esp
80100e7c:	85 c0                	test   %eax,%eax
80100e7e:	0f 8e 9b 00 00 00    	jle    80100f1f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e84:	83 e8 01             	sub    $0x1,%eax
80100e87:	85 c0                	test   %eax,%eax
80100e89:	89 47 04             	mov    %eax,0x4(%edi)
80100e8c:	74 1a                	je     80100ea8 <fileclose+0x48>
    release(&ftable.lock);
80100e8e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e98:	5b                   	pop    %ebx
80100e99:	5e                   	pop    %esi
80100e9a:	5f                   	pop    %edi
80100e9b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e9c:	e9 2f 3b 00 00       	jmp    801049d0 <release>
80100ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100ea8:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100eac:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100eae:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eb1:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100eb4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eba:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ebd:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ec0:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ec5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ec8:	e8 03 3b 00 00       	call   801049d0 <release>

  if(ff.type == FD_PIPE)
80100ecd:	83 c4 10             	add    $0x10,%esp
80100ed0:	83 fb 01             	cmp    $0x1,%ebx
80100ed3:	74 13                	je     80100ee8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ed5:	83 fb 02             	cmp    $0x2,%ebx
80100ed8:	74 26                	je     80100f00 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100edd:	5b                   	pop    %ebx
80100ede:	5e                   	pop    %esi
80100edf:	5f                   	pop    %edi
80100ee0:	5d                   	pop    %ebp
80100ee1:	c3                   	ret    
80100ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ee8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100eec:	83 ec 08             	sub    $0x8,%esp
80100eef:	53                   	push   %ebx
80100ef0:	56                   	push   %esi
80100ef1:	e8 ca 27 00 00       	call   801036c0 <pipeclose>
80100ef6:	83 c4 10             	add    $0x10,%esp
80100ef9:	eb df                	jmp    80100eda <fileclose+0x7a>
80100efb:	90                   	nop
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100f00:	e8 1b 20 00 00       	call   80102f20 <begin_op>
    iput(ff.ip);
80100f05:	83 ec 0c             	sub    $0xc,%esp
80100f08:	ff 75 e0             	pushl  -0x20(%ebp)
80100f0b:	e8 c0 08 00 00       	call   801017d0 <iput>
    end_op();
80100f10:	83 c4 10             	add    $0x10,%esp
  }
}
80100f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f16:	5b                   	pop    %ebx
80100f17:	5e                   	pop    %esi
80100f18:	5f                   	pop    %edi
80100f19:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100f1a:	e9 71 20 00 00       	jmp    80102f90 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	68 7c 75 10 80       	push   $0x8010757c
80100f27:	e8 44 f4 ff ff       	call   80100370 <panic>
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 04             	sub    $0x4,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f3a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f3d:	75 31                	jne    80100f70 <filestat+0x40>
    ilock(f->ip);
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	ff 73 10             	pushl  0x10(%ebx)
80100f45:	e8 56 07 00 00       	call   801016a0 <ilock>
    stati(f->ip, st);
80100f4a:	58                   	pop    %eax
80100f4b:	5a                   	pop    %edx
80100f4c:	ff 75 0c             	pushl  0xc(%ebp)
80100f4f:	ff 73 10             	pushl  0x10(%ebx)
80100f52:	e8 f9 09 00 00       	call   80101950 <stati>
    iunlock(f->ip);
80100f57:	59                   	pop    %ecx
80100f58:	ff 73 10             	pushl  0x10(%ebx)
80100f5b:	e8 20 08 00 00       	call   80101780 <iunlock>
    return 0;
80100f60:	83 c4 10             	add    $0x10,%esp
80100f63:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f68:	c9                   	leave  
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f80 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 0c             	sub    $0xc,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f92:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f96:	74 60                	je     80100ff8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f98:	8b 03                	mov    (%ebx),%eax
80100f9a:	83 f8 01             	cmp    $0x1,%eax
80100f9d:	74 41                	je     80100fe0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f9f:	83 f8 02             	cmp    $0x2,%eax
80100fa2:	75 5b                	jne    80100fff <fileread+0x7f>
    ilock(f->ip);
80100fa4:	83 ec 0c             	sub    $0xc,%esp
80100fa7:	ff 73 10             	pushl  0x10(%ebx)
80100faa:	e8 f1 06 00 00       	call   801016a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100faf:	57                   	push   %edi
80100fb0:	ff 73 14             	pushl  0x14(%ebx)
80100fb3:	56                   	push   %esi
80100fb4:	ff 73 10             	pushl  0x10(%ebx)
80100fb7:	e8 c4 09 00 00       	call   80101980 <readi>
80100fbc:	83 c4 20             	add    $0x20,%esp
80100fbf:	85 c0                	test   %eax,%eax
80100fc1:	89 c6                	mov    %eax,%esi
80100fc3:	7e 03                	jle    80100fc8 <fileread+0x48>
      f->off += r;
80100fc5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fc8:	83 ec 0c             	sub    $0xc,%esp
80100fcb:	ff 73 10             	pushl  0x10(%ebx)
80100fce:	e8 ad 07 00 00       	call   80101780 <iunlock>
    return r;
80100fd3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fd6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fdb:	5b                   	pop    %ebx
80100fdc:	5e                   	pop    %esi
80100fdd:	5f                   	pop    %edi
80100fde:	5d                   	pop    %ebp
80100fdf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fe0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fe3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	5b                   	pop    %ebx
80100fea:	5e                   	pop    %esi
80100feb:	5f                   	pop    %edi
80100fec:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fed:	e9 6e 28 00 00       	jmp    80103860 <piperead>
80100ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ffd:	eb d9                	jmp    80100fd8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	68 86 75 10 80       	push   $0x80107586
80101007:	e8 64 f3 ff ff       	call   80100370 <panic>
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 1c             	sub    $0x1c,%esp
80101019:	8b 75 08             	mov    0x8(%ebp),%esi
8010101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010101f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101023:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101026:	8b 45 10             	mov    0x10(%ebp),%eax
80101029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010102c:	0f 84 aa 00 00 00    	je     801010dc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101032:	8b 06                	mov    (%esi),%eax
80101034:	83 f8 01             	cmp    $0x1,%eax
80101037:	0f 84 c2 00 00 00    	je     801010ff <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103d:	83 f8 02             	cmp    $0x2,%eax
80101040:	0f 85 d8 00 00 00    	jne    8010111e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101049:	31 ff                	xor    %edi,%edi
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 34                	jg     80101083 <filewrite+0x73>
8010104f:	e9 9c 00 00 00       	jmp    801010f0 <filewrite+0xe0>
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101058:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010105b:	83 ec 0c             	sub    $0xc,%esp
8010105e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101061:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101064:	e8 17 07 00 00       	call   80101780 <iunlock>
      end_op();
80101069:	e8 22 1f 00 00       	call   80102f90 <end_op>
8010106e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101071:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101074:	39 d8                	cmp    %ebx,%eax
80101076:	0f 85 95 00 00 00    	jne    80101111 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010107c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010107e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101081:	7e 6d                	jle    801010f0 <filewrite+0xe0>
      int n1 = n - i;
80101083:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101086:	b8 00 06 00 00       	mov    $0x600,%eax
8010108b:	29 fb                	sub    %edi,%ebx
8010108d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101093:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101096:	e8 85 1e 00 00       	call   80102f20 <begin_op>
      ilock(f->ip);
8010109b:	83 ec 0c             	sub    $0xc,%esp
8010109e:	ff 76 10             	pushl  0x10(%esi)
801010a1:	e8 fa 05 00 00       	call   801016a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010a9:	53                   	push   %ebx
801010aa:	ff 76 14             	pushl  0x14(%esi)
801010ad:	01 f8                	add    %edi,%eax
801010af:	50                   	push   %eax
801010b0:	ff 76 10             	pushl  0x10(%esi)
801010b3:	e8 c8 09 00 00       	call   80101a80 <writei>
801010b8:	83 c4 20             	add    $0x20,%esp
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 99                	jg     80101058 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	ff 76 10             	pushl  0x10(%esi)
801010c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010c8:	e8 b3 06 00 00       	call   80101780 <iunlock>
      end_op();
801010cd:	e8 be 1e 00 00       	call   80102f90 <end_op>

      if(r < 0)
801010d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d5:	83 c4 10             	add    $0x10,%esp
801010d8:	85 c0                	test   %eax,%eax
801010da:	74 98                	je     80101074 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010e4:	5b                   	pop    %ebx
801010e5:	5e                   	pop    %esi
801010e6:	5f                   	pop    %edi
801010e7:	5d                   	pop    %ebp
801010e8:	c3                   	ret    
801010e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010f0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010f3:	75 e7                	jne    801010dc <filewrite+0xcc>
  }
  panic("filewrite");
}
801010f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f8:	89 f8                	mov    %edi,%eax
801010fa:	5b                   	pop    %ebx
801010fb:	5e                   	pop    %esi
801010fc:	5f                   	pop    %edi
801010fd:	5d                   	pop    %ebp
801010fe:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010ff:	8b 46 0c             	mov    0xc(%esi),%eax
80101102:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101108:	5b                   	pop    %ebx
80101109:	5e                   	pop    %esi
8010110a:	5f                   	pop    %edi
8010110b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010110c:	e9 4f 26 00 00       	jmp    80103760 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101111:	83 ec 0c             	sub    $0xc,%esp
80101114:	68 8f 75 10 80       	push   $0x8010758f
80101119:	e8 52 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010111e:	83 ec 0c             	sub    $0xc,%esp
80101121:	68 95 75 10 80       	push   $0x80107595
80101126:	e8 45 f2 ff ff       	call   80100370 <panic>
8010112b:	66 90                	xchg   %ax,%ax
8010112d:	66 90                	xchg   %ax,%ax
8010112f:	90                   	nop

80101130 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	56                   	push   %esi
80101135:	53                   	push   %ebx
80101136:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101139:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010113f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101142:	85 c9                	test   %ecx,%ecx
80101144:	0f 84 85 00 00 00    	je     801011cf <balloc+0x9f>
8010114a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101151:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101154:	83 ec 08             	sub    $0x8,%esp
80101157:	89 f0                	mov    %esi,%eax
80101159:	c1 f8 0c             	sar    $0xc,%eax
8010115c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101162:	50                   	push   %eax
80101163:	ff 75 d8             	pushl  -0x28(%ebp)
80101166:	e8 65 ef ff ff       	call   801000d0 <bread>
8010116b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010116e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101173:	83 c4 10             	add    $0x10,%esp
80101176:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101179:	31 c0                	xor    %eax,%eax
8010117b:	eb 2d                	jmp    801011aa <balloc+0x7a>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101180:	89 c1                	mov    %eax,%ecx
80101182:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101187:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010118a:	83 e1 07             	and    $0x7,%ecx
8010118d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010118f:	89 c1                	mov    %eax,%ecx
80101191:	c1 f9 03             	sar    $0x3,%ecx
80101194:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101199:	85 d7                	test   %edx,%edi
8010119b:	74 43                	je     801011e0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010119d:	83 c0 01             	add    $0x1,%eax
801011a0:	83 c6 01             	add    $0x1,%esi
801011a3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011a8:	74 05                	je     801011af <balloc+0x7f>
801011aa:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011ad:	72 d1                	jb     80101180 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	ff 75 e4             	pushl  -0x1c(%ebp)
801011b5:	e8 26 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011ba:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011c1:	83 c4 10             	add    $0x10,%esp
801011c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011c7:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801011cd:	77 82                	ja     80101151 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	68 9f 75 10 80       	push   $0x8010759f
801011d7:	e8 94 f1 ff ff       	call   80100370 <panic>
801011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011e0:	09 fa                	or     %edi,%edx
801011e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011e5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011ec:	57                   	push   %edi
801011ed:	e8 0e 1f 00 00       	call   80103100 <log_write>
        brelse(bp);
801011f2:	89 3c 24             	mov    %edi,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011fa:	58                   	pop    %eax
801011fb:	5a                   	pop    %edx
801011fc:	56                   	push   %esi
801011fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101200:	e8 cb ee ff ff       	call   801000d0 <bread>
80101205:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101207:	8d 40 5c             	lea    0x5c(%eax),%eax
8010120a:	83 c4 0c             	add    $0xc,%esp
8010120d:	68 00 02 00 00       	push   $0x200
80101212:	6a 00                	push   $0x0
80101214:	50                   	push   %eax
80101215:	e8 06 38 00 00       	call   80104a20 <memset>
  log_write(bp);
8010121a:	89 1c 24             	mov    %ebx,(%esp)
8010121d:	e8 de 1e 00 00       	call   80103100 <log_write>
  brelse(bp);
80101222:	89 1c 24             	mov    %ebx,(%esp)
80101225:	e8 b6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010122a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010122d:	89 f0                	mov    %esi,%eax
8010122f:	5b                   	pop    %ebx
80101230:	5e                   	pop    %esi
80101231:	5f                   	pop    %edi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
80101234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010123a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101240 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101248:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010124f:	83 ec 28             	sub    $0x28,%esp
80101252:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101255:	68 e0 09 11 80       	push   $0x801109e0
8010125a:	e8 51 36 00 00       	call   801048b0 <acquire>
8010125f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101262:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101265:	eb 1b                	jmp    80101282 <iget+0x42>
80101267:	89 f6                	mov    %esi,%esi
80101269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101270:	85 f6                	test   %esi,%esi
80101272:	74 44                	je     801012b8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101274:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010127a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101280:	74 4e                	je     801012d0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101282:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101285:	85 c9                	test   %ecx,%ecx
80101287:	7e e7                	jle    80101270 <iget+0x30>
80101289:	39 3b                	cmp    %edi,(%ebx)
8010128b:	75 e3                	jne    80101270 <iget+0x30>
8010128d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101290:	75 de                	jne    80101270 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101292:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101295:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101298:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010129a:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010129f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012a2:	e8 29 37 00 00       	call   801049d0 <release>
      return ip;
801012a7:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	89 f0                	mov    %esi,%eax
801012af:	5b                   	pop    %ebx
801012b0:	5e                   	pop    %esi
801012b1:	5f                   	pop    %edi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
801012b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012b8:	85 c9                	test   %ecx,%ecx
801012ba:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012bd:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c3:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012c9:	75 b7                	jne    80101282 <iget+0x42>
801012cb:	90                   	nop
801012cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012d0:	85 f6                	test   %esi,%esi
801012d2:	74 2d                	je     80101301 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012d4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012d7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012d9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012dc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012e3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ea:	68 e0 09 11 80       	push   $0x801109e0
801012ef:	e8 dc 36 00 00       	call   801049d0 <release>

  return ip;
801012f4:	83 c4 10             	add    $0x10,%esp
}
801012f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fa:	89 f0                	mov    %esi,%eax
801012fc:	5b                   	pop    %ebx
801012fd:	5e                   	pop    %esi
801012fe:	5f                   	pop    %edi
801012ff:	5d                   	pop    %ebp
80101300:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101301:	83 ec 0c             	sub    $0xc,%esp
80101304:	68 b5 75 10 80       	push   $0x801075b5
80101309:	e8 62 f0 ff ff       	call   80100370 <panic>
8010130e:	66 90                	xchg   %ax,%ax

80101310 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
80101314:	56                   	push   %esi
80101315:	53                   	push   %ebx
80101316:	89 c6                	mov    %eax,%esi
80101318:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010131b:	83 fa 0b             	cmp    $0xb,%edx
8010131e:	77 18                	ja     80101338 <bmap+0x28>
80101320:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101323:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101326:	85 c0                	test   %eax,%eax
80101328:	74 76                	je     801013a0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	5b                   	pop    %ebx
8010132e:	5e                   	pop    %esi
8010132f:	5f                   	pop    %edi
80101330:	5d                   	pop    %ebp
80101331:	c3                   	ret    
80101332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101338:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010133b:	83 fb 7f             	cmp    $0x7f,%ebx
8010133e:	0f 87 83 00 00 00    	ja     801013c7 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101344:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010134a:	85 c0                	test   %eax,%eax
8010134c:	74 6a                	je     801013b8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010134e:	83 ec 08             	sub    $0x8,%esp
80101351:	50                   	push   %eax
80101352:	ff 36                	pushl  (%esi)
80101354:	e8 77 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101359:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010135d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101360:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101362:	8b 1a                	mov    (%edx),%ebx
80101364:	85 db                	test   %ebx,%ebx
80101366:	75 1d                	jne    80101385 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101368:	8b 06                	mov    (%esi),%eax
8010136a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010136d:	e8 be fd ff ff       	call   80101130 <balloc>
80101372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101375:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101378:	89 c3                	mov    %eax,%ebx
8010137a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010137c:	57                   	push   %edi
8010137d:	e8 7e 1d 00 00       	call   80103100 <log_write>
80101382:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101385:	83 ec 0c             	sub    $0xc,%esp
80101388:	57                   	push   %edi
80101389:	e8 52 ee ff ff       	call   801001e0 <brelse>
8010138e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101391:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101394:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101396:	5b                   	pop    %ebx
80101397:	5e                   	pop    %esi
80101398:	5f                   	pop    %edi
80101399:	5d                   	pop    %ebp
8010139a:	c3                   	ret    
8010139b:	90                   	nop
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013a0:	8b 06                	mov    (%esi),%eax
801013a2:	e8 89 fd ff ff       	call   80101130 <balloc>
801013a7:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ad:	5b                   	pop    %ebx
801013ae:	5e                   	pop    %esi
801013af:	5f                   	pop    %edi
801013b0:	5d                   	pop    %ebp
801013b1:	c3                   	ret    
801013b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013b8:	8b 06                	mov    (%esi),%eax
801013ba:	e8 71 fd ff ff       	call   80101130 <balloc>
801013bf:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013c5:	eb 87                	jmp    8010134e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801013c7:	83 ec 0c             	sub    $0xc,%esp
801013ca:	68 c5 75 10 80       	push   $0x801075c5
801013cf:	e8 9c ef ff ff       	call   80100370 <panic>
801013d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013e0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	56                   	push   %esi
801013e4:	53                   	push   %ebx
801013e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013e8:	83 ec 08             	sub    $0x8,%esp
801013eb:	6a 01                	push   $0x1
801013ed:	ff 75 08             	pushl  0x8(%ebp)
801013f0:	e8 db ec ff ff       	call   801000d0 <bread>
801013f5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013fa:	83 c4 0c             	add    $0xc,%esp
801013fd:	6a 1c                	push   $0x1c
801013ff:	50                   	push   %eax
80101400:	56                   	push   %esi
80101401:	e8 ca 36 00 00       	call   80104ad0 <memmove>
  brelse(bp);
80101406:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101409:	83 c4 10             	add    $0x10,%esp
}
8010140c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010140f:	5b                   	pop    %ebx
80101410:	5e                   	pop    %esi
80101411:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101412:	e9 c9 ed ff ff       	jmp    801001e0 <brelse>
80101417:	89 f6                	mov    %esi,%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	89 d3                	mov    %edx,%ebx
80101427:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101429:	83 ec 08             	sub    $0x8,%esp
8010142c:	68 c0 09 11 80       	push   $0x801109c0
80101431:	50                   	push   %eax
80101432:	e8 a9 ff ff ff       	call   801013e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101437:	58                   	pop    %eax
80101438:	5a                   	pop    %edx
80101439:	89 da                	mov    %ebx,%edx
8010143b:	c1 ea 0c             	shr    $0xc,%edx
8010143e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101444:	52                   	push   %edx
80101445:	56                   	push   %esi
80101446:	e8 85 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010144b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010144d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101453:	ba 01 00 00 00       	mov    $0x1,%edx
80101458:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010145b:	c1 fb 03             	sar    $0x3,%ebx
8010145e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101461:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101463:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101468:	85 d1                	test   %edx,%ecx
8010146a:	74 27                	je     80101493 <bfree+0x73>
8010146c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010146e:	f7 d2                	not    %edx
80101470:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101472:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101475:	21 d0                	and    %edx,%eax
80101477:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010147b:	56                   	push   %esi
8010147c:	e8 7f 1c 00 00       	call   80103100 <log_write>
  brelse(bp);
80101481:	89 34 24             	mov    %esi,(%esp)
80101484:	e8 57 ed ff ff       	call   801001e0 <brelse>
}
80101489:	83 c4 10             	add    $0x10,%esp
8010148c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010148f:	5b                   	pop    %ebx
80101490:	5e                   	pop    %esi
80101491:	5d                   	pop    %ebp
80101492:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101493:	83 ec 0c             	sub    $0xc,%esp
80101496:	68 d8 75 10 80       	push   $0x801075d8
8010149b:	e8 d0 ee ff ff       	call   80100370 <panic>

801014a0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	53                   	push   %ebx
801014a4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801014a9:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801014ac:	68 eb 75 10 80       	push   $0x801075eb
801014b1:	68 e0 09 11 80       	push   $0x801109e0
801014b6:	e8 f5 32 00 00       	call   801047b0 <initlock>
801014bb:	83 c4 10             	add    $0x10,%esp
801014be:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014c0:	83 ec 08             	sub    $0x8,%esp
801014c3:	68 f2 75 10 80       	push   $0x801075f2
801014c8:	53                   	push   %ebx
801014c9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014cf:	e8 cc 31 00 00       	call   801046a0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014d4:	83 c4 10             	add    $0x10,%esp
801014d7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014dd:	75 e1                	jne    801014c0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014df:	83 ec 08             	sub    $0x8,%esp
801014e2:	68 c0 09 11 80       	push   $0x801109c0
801014e7:	ff 75 08             	pushl  0x8(%ebp)
801014ea:	e8 f1 fe ff ff       	call   801013e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ef:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014f5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014fb:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101501:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101507:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010150d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101513:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101519:	68 9c 76 10 80       	push   $0x8010769c
8010151e:	e8 3d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101523:	83 c4 30             	add    $0x30,%esp
80101526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101529:	c9                   	leave  
8010152a:	c3                   	ret    
8010152b:	90                   	nop
8010152c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101530 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101540:	8b 45 0c             	mov    0xc(%ebp),%eax
80101543:	8b 75 08             	mov    0x8(%ebp),%esi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 91 00 00 00    	jbe    801015e0 <ialloc+0xb0>
8010154f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101554:	eb 21                	jmp    80101577 <ialloc+0x47>
80101556:	8d 76 00             	lea    0x0(%esi),%esi
80101559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101560:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101566:	57                   	push   %edi
80101567:	e8 74 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010156c:	83 c4 10             	add    $0x10,%esp
8010156f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101575:	76 69                	jbe    801015e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101577:	89 d8                	mov    %ebx,%eax
80101579:	83 ec 08             	sub    $0x8,%esp
8010157c:	c1 e8 03             	shr    $0x3,%eax
8010157f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101585:	50                   	push   %eax
80101586:	56                   	push   %esi
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101590:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101593:	83 e0 07             	and    $0x7,%eax
80101596:	c1 e0 06             	shl    $0x6,%eax
80101599:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015a1:	75 bd                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a3:	83 ec 04             	sub    $0x4,%esp
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	6a 40                	push   $0x40
801015ab:	6a 00                	push   $0x0
801015ad:	51                   	push   %ecx
801015ae:	e8 6d 34 00 00       	call   80104a20 <memset>
      dip->type = type;
801015b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015bd:	89 3c 24             	mov    %edi,(%esp)
801015c0:	e8 3b 1b 00 00       	call   80103100 <log_write>
      brelse(bp);
801015c5:	89 3c 24             	mov    %edi,(%esp)
801015c8:	e8 13 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015cd:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d3:	89 da                	mov    %ebx,%edx
801015d5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d7:	5b                   	pop    %ebx
801015d8:	5e                   	pop    %esi
801015d9:	5f                   	pop    %edi
801015da:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015db:	e9 60 fc ff ff       	jmp    80101240 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015e0:	83 ec 0c             	sub    $0xc,%esp
801015e3:	68 f8 75 10 80       	push   $0x801075f8
801015e8:	e8 83 ed ff ff       	call   80100370 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f8:	83 ec 08             	sub    $0x8,%esp
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010160a:	50                   	push   %eax
8010160b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010160e:	e8 bd ea ff ff       	call   801000d0 <bread>
80101613:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101615:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101618:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010161f:	83 e0 07             	and    $0x7,%eax
80101622:	c1 e0 06             	shl    $0x6,%eax
80101625:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101629:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010162c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101630:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101633:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101637:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010163b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010163f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101643:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101647:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010164a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010164d:	6a 34                	push   $0x34
8010164f:	53                   	push   %ebx
80101650:	50                   	push   %eax
80101651:	e8 7a 34 00 00       	call   80104ad0 <memmove>
  log_write(bp);
80101656:	89 34 24             	mov    %esi,(%esp)
80101659:	e8 a2 1a 00 00       	call   80103100 <log_write>
  brelse(bp);
8010165e:	89 75 08             	mov    %esi,0x8(%ebp)
80101661:	83 c4 10             	add    $0x10,%esp
}
80101664:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101667:	5b                   	pop    %ebx
80101668:	5e                   	pop    %esi
80101669:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010166a:	e9 71 eb ff ff       	jmp    801001e0 <brelse>
8010166f:	90                   	nop

80101670 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	83 ec 10             	sub    $0x10,%esp
80101677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010167a:	68 e0 09 11 80       	push   $0x801109e0
8010167f:	e8 2c 32 00 00       	call   801048b0 <acquire>
  ip->ref++;
80101684:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101688:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010168f:	e8 3c 33 00 00       	call   801049d0 <release>
  return ip;
}
80101694:	89 d8                	mov    %ebx,%eax
80101696:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101699:	c9                   	leave  
8010169a:	c3                   	ret    
8010169b:	90                   	nop
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016a0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016a8:	85 db                	test   %ebx,%ebx
801016aa:	0f 84 b7 00 00 00    	je     80101767 <ilock+0xc7>
801016b0:	8b 53 08             	mov    0x8(%ebx),%edx
801016b3:	85 d2                	test   %edx,%edx
801016b5:	0f 8e ac 00 00 00    	jle    80101767 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
801016bb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016be:	83 ec 0c             	sub    $0xc,%esp
801016c1:	50                   	push   %eax
801016c2:	e8 19 30 00 00       	call   801046e0 <acquiresleep>

  if(ip->valid == 0){
801016c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ca:	83 c4 10             	add    $0x10,%esp
801016cd:	85 c0                	test   %eax,%eax
801016cf:	74 0f                	je     801016e0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016d4:	5b                   	pop    %ebx
801016d5:	5e                   	pop    %esi
801016d6:	5d                   	pop    %ebp
801016d7:	c3                   	ret    
801016d8:	90                   	nop
801016d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e0:	8b 43 04             	mov    0x4(%ebx),%eax
801016e3:	83 ec 08             	sub    $0x8,%esp
801016e6:	c1 e8 03             	shr    $0x3,%eax
801016e9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016ef:	50                   	push   %eax
801016f0:	ff 33                	pushl  (%ebx)
801016f2:	e8 d9 e9 ff ff       	call   801000d0 <bread>
801016f7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101709:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010170c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010170f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101713:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101717:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010171b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010171f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101723:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101727:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010172b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010172e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101731:	6a 34                	push   $0x34
80101733:	50                   	push   %eax
80101734:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101737:	50                   	push   %eax
80101738:	e8 93 33 00 00       	call   80104ad0 <memmove>
    brelse(bp);
8010173d:	89 34 24             	mov    %esi,(%esp)
80101740:	e8 9b ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101745:	83 c4 10             	add    $0x10,%esp
80101748:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010174d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101754:	0f 85 77 ff ff ff    	jne    801016d1 <ilock+0x31>
      panic("ilock: no type");
8010175a:	83 ec 0c             	sub    $0xc,%esp
8010175d:	68 10 76 10 80       	push   $0x80107610
80101762:	e8 09 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101767:	83 ec 0c             	sub    $0xc,%esp
8010176a:	68 0a 76 10 80       	push   $0x8010760a
8010176f:	e8 fc eb ff ff       	call   80100370 <panic>
80101774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010177a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101780 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	74 28                	je     801017b4 <iunlock+0x34>
8010178c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	56                   	push   %esi
80101793:	e8 e8 2f 00 00       	call   80104780 <holdingsleep>
80101798:	83 c4 10             	add    $0x10,%esp
8010179b:	85 c0                	test   %eax,%eax
8010179d:	74 15                	je     801017b4 <iunlock+0x34>
8010179f:	8b 43 08             	mov    0x8(%ebx),%eax
801017a2:	85 c0                	test   %eax,%eax
801017a4:	7e 0e                	jle    801017b4 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
801017a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017ac:	5b                   	pop    %ebx
801017ad:	5e                   	pop    %esi
801017ae:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017af:	e9 8c 2f 00 00       	jmp    80104740 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017b4:	83 ec 0c             	sub    $0xc,%esp
801017b7:	68 1f 76 10 80       	push   $0x8010761f
801017bc:	e8 af eb ff ff       	call   80100370 <panic>
801017c1:	eb 0d                	jmp    801017d0 <iput>
801017c3:	90                   	nop
801017c4:	90                   	nop
801017c5:	90                   	nop
801017c6:	90                   	nop
801017c7:	90                   	nop
801017c8:	90                   	nop
801017c9:	90                   	nop
801017ca:	90                   	nop
801017cb:	90                   	nop
801017cc:	90                   	nop
801017cd:	90                   	nop
801017ce:	90                   	nop
801017cf:	90                   	nop

801017d0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 28             	sub    $0x28,%esp
801017d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017dc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017df:	57                   	push   %edi
801017e0:	e8 fb 2e 00 00       	call   801046e0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017e5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	85 d2                	test   %edx,%edx
801017ed:	74 07                	je     801017f6 <iput+0x26>
801017ef:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017f4:	74 32                	je     80101828 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017f6:	83 ec 0c             	sub    $0xc,%esp
801017f9:	57                   	push   %edi
801017fa:	e8 41 2f 00 00       	call   80104740 <releasesleep>

  acquire(&icache.lock);
801017ff:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101806:	e8 a5 30 00 00       	call   801048b0 <acquire>
  ip->ref--;
8010180b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010180f:	83 c4 10             	add    $0x10,%esp
80101812:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101819:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010181c:	5b                   	pop    %ebx
8010181d:	5e                   	pop    %esi
8010181e:	5f                   	pop    %edi
8010181f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101820:	e9 ab 31 00 00       	jmp    801049d0 <release>
80101825:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101828:	83 ec 0c             	sub    $0xc,%esp
8010182b:	68 e0 09 11 80       	push   $0x801109e0
80101830:	e8 7b 30 00 00       	call   801048b0 <acquire>
    int r = ip->ref;
80101835:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101838:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010183f:	e8 8c 31 00 00       	call   801049d0 <release>
    if(r == 1){
80101844:	83 c4 10             	add    $0x10,%esp
80101847:	83 fb 01             	cmp    $0x1,%ebx
8010184a:	75 aa                	jne    801017f6 <iput+0x26>
8010184c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101852:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101855:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x97>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fb                	cmp    %edi,%ebx
80101865:	74 19                	je     80101880 <iput+0xb0>
    if(ip->addrs[i]){
80101867:	8b 13                	mov    (%ebx),%edx
80101869:	85 d2                	test   %edx,%edx
8010186b:	74 f3                	je     80101860 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010186d:	8b 06                	mov    (%esi),%eax
8010186f:	e8 ac fb ff ff       	call   80101420 <bfree>
      ip->addrs[i] = 0;
80101874:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010187a:	eb e4                	jmp    80101860 <iput+0x90>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 33                	jne    801018c0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010188d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101890:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101897:	56                   	push   %esi
80101898:	e8 53 fd ff ff       	call   801015f0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010189d:	31 c0                	xor    %eax,%eax
8010189f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018a3:	89 34 24             	mov    %esi,(%esp)
801018a6:	e8 45 fd ff ff       	call   801015f0 <iupdate>
      ip->valid = 0;
801018ab:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018b2:	83 c4 10             	add    $0x10,%esp
801018b5:	e9 3c ff ff ff       	jmp    801017f6 <iput+0x26>
801018ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c0:	83 ec 08             	sub    $0x8,%esp
801018c3:	50                   	push   %eax
801018c4:	ff 36                	pushl  (%esi)
801018c6:	e8 05 e8 ff ff       	call   801000d0 <bread>
801018cb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018d1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018d7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018da:	83 c4 10             	add    $0x10,%esp
801018dd:	89 cf                	mov    %ecx,%edi
801018df:	eb 0e                	jmp    801018ef <iput+0x11f>
801018e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018e8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018eb:	39 fb                	cmp    %edi,%ebx
801018ed:	74 0f                	je     801018fe <iput+0x12e>
      if(a[j])
801018ef:	8b 13                	mov    (%ebx),%edx
801018f1:	85 d2                	test   %edx,%edx
801018f3:	74 f3                	je     801018e8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018f5:	8b 06                	mov    (%esi),%eax
801018f7:	e8 24 fb ff ff       	call   80101420 <bfree>
801018fc:	eb ea                	jmp    801018e8 <iput+0x118>
    }
    brelse(bp);
801018fe:	83 ec 0c             	sub    $0xc,%esp
80101901:	ff 75 e4             	pushl  -0x1c(%ebp)
80101904:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101907:	e8 d4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010190c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101912:	8b 06                	mov    (%esi),%eax
80101914:	e8 07 fb ff ff       	call   80101420 <bfree>
    ip->addrs[NDIRECT] = 0;
80101919:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101920:	00 00 00 
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	e9 62 ff ff ff       	jmp    8010188d <iput+0xbd>
8010192b:	90                   	nop
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101930 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 10             	sub    $0x10,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010193a:	53                   	push   %ebx
8010193b:	e8 40 fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101940:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101943:	83 c4 10             	add    $0x10,%esp
}
80101946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101949:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010194a:	e9 81 fe ff ff       	jmp    801017d0 <iput>
8010194f:	90                   	nop

80101950 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	8b 55 08             	mov    0x8(%ebp),%edx
80101956:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101959:	8b 0a                	mov    (%edx),%ecx
8010195b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010195e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101961:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101964:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101968:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010196b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010196f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101973:	8b 52 58             	mov    0x58(%edx),%edx
80101976:	89 50 10             	mov    %edx,0x10(%eax)
}
80101979:	5d                   	pop    %ebp
8010197a:	c3                   	ret    
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	57                   	push   %edi
80101984:	56                   	push   %esi
80101985:	53                   	push   %ebx
80101986:	83 ec 1c             	sub    $0x1c,%esp
80101989:	8b 45 08             	mov    0x8(%ebp),%eax
8010198c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010198f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101992:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101997:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010199a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010199d:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a3:	0f 84 a7 00 00 00    	je     80101a50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019ac:	8b 40 58             	mov    0x58(%eax),%eax
801019af:	39 f0                	cmp    %esi,%eax
801019b1:	0f 82 c1 00 00 00    	jb     80101a78 <readi+0xf8>
801019b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ba:	89 fa                	mov    %edi,%edx
801019bc:	01 f2                	add    %esi,%edx
801019be:	0f 82 b4 00 00 00    	jb     80101a78 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019c4:	89 c1                	mov    %eax,%ecx
801019c6:	29 f1                	sub    %esi,%ecx
801019c8:	39 d0                	cmp    %edx,%eax
801019ca:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019cd:	31 ff                	xor    %edi,%edi
801019cf:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019d1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d4:	74 6d                	je     80101a43 <readi+0xc3>
801019d6:	8d 76 00             	lea    0x0(%esi),%esi
801019d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019e3:	89 f2                	mov    %esi,%edx
801019e5:	c1 ea 09             	shr    $0x9,%edx
801019e8:	89 d8                	mov    %ebx,%eax
801019ea:	e8 21 f9 ff ff       	call   80101310 <bmap>
801019ef:	83 ec 08             	sub    $0x8,%esp
801019f2:	50                   	push   %eax
801019f3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019f5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019fa:	e8 d1 e6 ff ff       	call   801000d0 <bread>
801019ff:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a04:	89 f1                	mov    %esi,%ecx
80101a06:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101a0c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101a0f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a12:	29 cb                	sub    %ecx,%ebx
80101a14:	29 f8                	sub    %edi,%eax
80101a16:	39 c3                	cmp    %eax,%ebx
80101a18:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a1b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101a1f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a20:	01 df                	add    %ebx,%edi
80101a22:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a24:	50                   	push   %eax
80101a25:	ff 75 e0             	pushl  -0x20(%ebp)
80101a28:	e8 a3 30 00 00       	call   80104ad0 <memmove>
    brelse(bp);
80101a2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a30:	89 14 24             	mov    %edx,(%esp)
80101a33:	e8 a8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a38:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a3b:	83 c4 10             	add    $0x10,%esp
80101a3e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a41:	77 9d                	ja     801019e0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a49:	5b                   	pop    %ebx
80101a4a:	5e                   	pop    %esi
80101a4b:	5f                   	pop    %edi
80101a4c:	5d                   	pop    %ebp
80101a4d:	c3                   	ret    
80101a4e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a54:	66 83 f8 09          	cmp    $0x9,%ax
80101a58:	77 1e                	ja     80101a78 <readi+0xf8>
80101a5a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a61:	85 c0                	test   %eax,%eax
80101a63:	74 13                	je     80101a78 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a65:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a6b:	5b                   	pop    %ebx
80101a6c:	5e                   	pop    %esi
80101a6d:	5f                   	pop    %edi
80101a6e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a6f:	ff e0                	jmp    *%eax
80101a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a7d:	eb c7                	jmp    80101a46 <readi+0xc6>
80101a7f:	90                   	nop

80101a80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	57                   	push   %edi
80101a84:	56                   	push   %esi
80101a85:	53                   	push   %ebx
80101a86:	83 ec 1c             	sub    $0x1c,%esp
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a9d:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa3:	0f 84 b7 00 00 00    	je     80101b60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101aa9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aac:	39 70 58             	cmp    %esi,0x58(%eax)
80101aaf:	0f 82 eb 00 00 00    	jb     80101ba0 <writei+0x120>
80101ab5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ab8:	89 f8                	mov    %edi,%eax
80101aba:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101abc:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ac1:	0f 87 d9 00 00 00    	ja     80101ba0 <writei+0x120>
80101ac7:	39 c6                	cmp    %eax,%esi
80101ac9:	0f 87 d1 00 00 00    	ja     80101ba0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101acf:	85 ff                	test   %edi,%edi
80101ad1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ad8:	74 78                	je     80101b52 <writei+0xd2>
80101ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ae3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aea:	c1 ea 09             	shr    $0x9,%edx
80101aed:	89 f8                	mov    %edi,%eax
80101aef:	e8 1c f8 ff ff       	call   80101310 <bmap>
80101af4:	83 ec 08             	sub    $0x8,%esp
80101af7:	50                   	push   %eax
80101af8:	ff 37                	pushl  (%edi)
80101afa:	e8 d1 e5 ff ff       	call   801000d0 <bread>
80101aff:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b04:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101b07:	89 f1                	mov    %esi,%ecx
80101b09:	83 c4 0c             	add    $0xc,%esp
80101b0c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101b12:	29 cb                	sub    %ecx,%ebx
80101b14:	39 c3                	cmp    %eax,%ebx
80101b16:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b19:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101b1d:	53                   	push   %ebx
80101b1e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b21:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b23:	50                   	push   %eax
80101b24:	e8 a7 2f 00 00       	call   80104ad0 <memmove>
    log_write(bp);
80101b29:	89 3c 24             	mov    %edi,(%esp)
80101b2c:	e8 cf 15 00 00       	call   80103100 <log_write>
    brelse(bp);
80101b31:	89 3c 24             	mov    %edi,(%esp)
80101b34:	e8 a7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b39:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b3c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b3f:	83 c4 10             	add    $0x10,%esp
80101b42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b45:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b48:	77 96                	ja     80101ae0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b50:	77 36                	ja     80101b88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b52:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 36                	ja     80101ba0 <writei+0x120>
80101b6a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 2b                	je     80101ba0 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b7f:	ff e0                	jmp    *%eax
80101b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b88:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b8b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b8e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b91:	50                   	push   %eax
80101b92:	e8 59 fa ff ff       	call   801015f0 <iupdate>
80101b97:	83 c4 10             	add    $0x10,%esp
80101b9a:	eb b6                	jmp    80101b52 <writei+0xd2>
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba5:	eb ae                	jmp    80101b55 <writei+0xd5>
80101ba7:	89 f6                	mov    %esi,%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bb6:	6a 0e                	push   $0xe
80101bb8:	ff 75 0c             	pushl  0xc(%ebp)
80101bbb:	ff 75 08             	pushl  0x8(%ebp)
80101bbe:	e8 8d 2f 00 00       	call   80104b50 <strncmp>
}
80101bc3:	c9                   	leave  
80101bc4:	c3                   	ret    
80101bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 1c             	sub    $0x1c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 80 00 00 00    	jne    80101c67 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101be7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 d2                	test   %edx,%edx
80101bf1:	75 0d                	jne    80101c00 <dirlookup+0x30>
80101bf3:	eb 5b                	jmp    80101c50 <dirlookup+0x80>
80101bf5:	8d 76 00             	lea    0x0(%esi),%esi
80101bf8:	83 c7 10             	add    $0x10,%edi
80101bfb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bfe:	76 50                	jbe    80101c50 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c00:	6a 10                	push   $0x10
80101c02:	57                   	push   %edi
80101c03:	56                   	push   %esi
80101c04:	53                   	push   %ebx
80101c05:	e8 76 fd ff ff       	call   80101980 <readi>
80101c0a:	83 c4 10             	add    $0x10,%esp
80101c0d:	83 f8 10             	cmp    $0x10,%eax
80101c10:	75 48                	jne    80101c5a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101c12:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c17:	74 df                	je     80101bf8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c19:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c1c:	83 ec 04             	sub    $0x4,%esp
80101c1f:	6a 0e                	push   $0xe
80101c21:	50                   	push   %eax
80101c22:	ff 75 0c             	pushl  0xc(%ebp)
80101c25:	e8 26 2f 00 00       	call   80104b50 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c2a:	83 c4 10             	add    $0x10,%esp
80101c2d:	85 c0                	test   %eax,%eax
80101c2f:	75 c7                	jne    80101bf8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c31:	8b 45 10             	mov    0x10(%ebp),%eax
80101c34:	85 c0                	test   %eax,%eax
80101c36:	74 05                	je     80101c3d <dirlookup+0x6d>
        *poff = off;
80101c38:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c3d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c41:	8b 03                	mov    (%ebx),%eax
80101c43:	e8 f8 f5 ff ff       	call   80101240 <iget>
    }
  }

  return 0;
}
80101c48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4b:	5b                   	pop    %ebx
80101c4c:	5e                   	pop    %esi
80101c4d:	5f                   	pop    %edi
80101c4e:	5d                   	pop    %ebp
80101c4f:	c3                   	ret    
80101c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c53:	31 c0                	xor    %eax,%eax
}
80101c55:	5b                   	pop    %ebx
80101c56:	5e                   	pop    %esi
80101c57:	5f                   	pop    %edi
80101c58:	5d                   	pop    %ebp
80101c59:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c5a:	83 ec 0c             	sub    $0xc,%esp
80101c5d:	68 39 76 10 80       	push   $0x80107639
80101c62:	e8 09 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c67:	83 ec 0c             	sub    $0xc,%esp
80101c6a:	68 27 76 10 80       	push   $0x80107627
80101c6f:	e8 fc e6 ff ff       	call   80100370 <panic>
80101c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	89 cf                	mov    %ecx,%edi
80101c88:	89 c3                	mov    %eax,%ebx
80101c8a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c8d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c93:	0f 84 53 01 00 00    	je     80101dec <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c99:	e8 12 1f 00 00       	call   80103bb0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c9e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca1:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ca4:	68 e0 09 11 80       	push   $0x801109e0
80101ca9:	e8 02 2c 00 00       	call   801048b0 <acquire>
  ip->ref++;
80101cae:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cb2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb9:	e8 12 2d 00 00       	call   801049d0 <release>
80101cbe:	83 c4 10             	add    $0x10,%esp
80101cc1:	eb 08                	jmp    80101ccb <namex+0x4b>
80101cc3:	90                   	nop
80101cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cc8:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101ccb:	0f b6 03             	movzbl (%ebx),%eax
80101cce:	3c 2f                	cmp    $0x2f,%al
80101cd0:	74 f6                	je     80101cc8 <namex+0x48>
    path++;
  if(*path == 0)
80101cd2:	84 c0                	test   %al,%al
80101cd4:	0f 84 e3 00 00 00    	je     80101dbd <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cda:	0f b6 03             	movzbl (%ebx),%eax
80101cdd:	89 da                	mov    %ebx,%edx
80101cdf:	84 c0                	test   %al,%al
80101ce1:	0f 84 ac 00 00 00    	je     80101d93 <namex+0x113>
80101ce7:	3c 2f                	cmp    $0x2f,%al
80101ce9:	75 09                	jne    80101cf4 <namex+0x74>
80101ceb:	e9 a3 00 00 00       	jmp    80101d93 <namex+0x113>
80101cf0:	84 c0                	test   %al,%al
80101cf2:	74 0a                	je     80101cfe <namex+0x7e>
    path++;
80101cf4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cf7:	0f b6 02             	movzbl (%edx),%eax
80101cfa:	3c 2f                	cmp    $0x2f,%al
80101cfc:	75 f2                	jne    80101cf0 <namex+0x70>
80101cfe:	89 d1                	mov    %edx,%ecx
80101d00:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d02:	83 f9 0d             	cmp    $0xd,%ecx
80101d05:	0f 8e 8d 00 00 00    	jle    80101d98 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d0b:	83 ec 04             	sub    $0x4,%esp
80101d0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d11:	6a 0e                	push   $0xe
80101d13:	53                   	push   %ebx
80101d14:	57                   	push   %edi
80101d15:	e8 b6 2d 00 00       	call   80104ad0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101d1d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d20:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d22:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d25:	75 11                	jne    80101d38 <namex+0xb8>
80101d27:	89 f6                	mov    %esi,%esi
80101d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d30:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d38:	83 ec 0c             	sub    $0xc,%esp
80101d3b:	56                   	push   %esi
80101d3c:	e8 5f f9 ff ff       	call   801016a0 <ilock>
    if(ip->type != T_DIR){
80101d41:	83 c4 10             	add    $0x10,%esp
80101d44:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d49:	0f 85 7f 00 00 00    	jne    80101dce <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d52:	85 d2                	test   %edx,%edx
80101d54:	74 09                	je     80101d5f <namex+0xdf>
80101d56:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d59:	0f 84 a3 00 00 00    	je     80101e02 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d5f:	83 ec 04             	sub    $0x4,%esp
80101d62:	6a 00                	push   $0x0
80101d64:	57                   	push   %edi
80101d65:	56                   	push   %esi
80101d66:	e8 65 fe ff ff       	call   80101bd0 <dirlookup>
80101d6b:	83 c4 10             	add    $0x10,%esp
80101d6e:	85 c0                	test   %eax,%eax
80101d70:	74 5c                	je     80101dce <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d72:	83 ec 0c             	sub    $0xc,%esp
80101d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d78:	56                   	push   %esi
80101d79:	e8 02 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 4a fa ff ff       	call   801017d0 <iput>
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	83 c4 10             	add    $0x10,%esp
80101d8c:	89 c6                	mov    %eax,%esi
80101d8e:	e9 38 ff ff ff       	jmp    80101ccb <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d93:	31 c9                	xor    %ecx,%ecx
80101d95:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d98:	83 ec 04             	sub    $0x4,%esp
80101d9b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d9e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da1:	51                   	push   %ecx
80101da2:	53                   	push   %ebx
80101da3:	57                   	push   %edi
80101da4:	e8 27 2d 00 00       	call   80104ad0 <memmove>
    name[len] = 0;
80101da9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101daf:	83 c4 10             	add    $0x10,%esp
80101db2:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101db6:	89 d3                	mov    %edx,%ebx
80101db8:	e9 65 ff ff ff       	jmp    80101d22 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dc0:	85 c0                	test   %eax,%eax
80101dc2:	75 54                	jne    80101e18 <namex+0x198>
80101dc4:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc9:	5b                   	pop    %ebx
80101dca:	5e                   	pop    %esi
80101dcb:	5f                   	pop    %edi
80101dcc:	5d                   	pop    %ebp
80101dcd:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dce:	83 ec 0c             	sub    $0xc,%esp
80101dd1:	56                   	push   %esi
80101dd2:	e8 a9 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101dd7:	89 34 24             	mov    %esi,(%esp)
80101dda:	e8 f1 f9 ff ff       	call   801017d0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101ddf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101de5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de7:	5b                   	pop    %ebx
80101de8:	5e                   	pop    %esi
80101de9:	5f                   	pop    %edi
80101dea:	5d                   	pop    %ebp
80101deb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dec:	ba 01 00 00 00       	mov    $0x1,%edx
80101df1:	b8 01 00 00 00       	mov    $0x1,%eax
80101df6:	e8 45 f4 ff ff       	call   80101240 <iget>
80101dfb:	89 c6                	mov    %eax,%esi
80101dfd:	e9 c9 fe ff ff       	jmp    80101ccb <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e02:	83 ec 0c             	sub    $0xc,%esp
80101e05:	56                   	push   %esi
80101e06:	e8 75 f9 ff ff       	call   80101780 <iunlock>
      return ip;
80101e0b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e11:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e13:	5b                   	pop    %ebx
80101e14:	5e                   	pop    %esi
80101e15:	5f                   	pop    %edi
80101e16:	5d                   	pop    %ebp
80101e17:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e18:	83 ec 0c             	sub    $0xc,%esp
80101e1b:	56                   	push   %esi
80101e1c:	e8 af f9 ff ff       	call   801017d0 <iput>
    return 0;
80101e21:	83 c4 10             	add    $0x10,%esp
80101e24:	31 c0                	xor    %eax,%eax
80101e26:	eb 9e                	jmp    80101dc6 <namex+0x146>
80101e28:	90                   	nop
80101e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 89 fd ff ff       	call   80101bd0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
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
80101e63:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e66:	76 19                	jbe    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 0e fb ff ff       	call   80101980 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 2e 2d 00 00       	call   80104bc0 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 dd fb ff ff       	call   80101a80 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 12 f9 ff ff       	call   801017d0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 48 76 10 80       	push   $0x80107648
80101ed0:	e8 9b e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 91 7c 10 80       	push   $0x80107c91
80101edd:	e8 8e e4 ff ff       	call   80100370 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 7d fd ff ff       	call   80101c80 <namex>
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
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f1f:	e9 5c fd ff ff       	jmp    80101c80 <namex>
80101f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f30 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f30:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f31:	b8 38 39 00 00       	mov    $0x3938,%eax


#include "fcntl.h"
#define DIGITS 14

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
80101f5c:	78 62                	js     80101fc0 <itoa+0x90>
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
80101f5e:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f60:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f65:	8d 76 00             	lea    0x0(%esi),%esi
80101f68:	89 d8                	mov    %ebx,%eax
80101f6a:	c1 fb 1f             	sar    $0x1f,%ebx
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
    do{ //Move to where representation ends
        ++p;
80101f6d:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101f70:	f7 ef                	imul   %edi
80101f72:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101f75:	29 da                	sub    %ebx,%edx
80101f77:	89 d3                	mov    %edx,%ebx
80101f79:	75 ed                	jne    80101f68 <itoa+0x38>
    *p = '\0';
80101f7b:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f7e:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101f83:	90                   	nop
80101f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f88:	89 c8                	mov    %ecx,%eax
80101f8a:	83 ee 01             	sub    $0x1,%esi
80101f8d:	f7 eb                	imul   %ebx
80101f8f:	89 c8                	mov    %ecx,%eax
80101f91:	c1 f8 1f             	sar    $0x1f,%eax
80101f94:	c1 fa 02             	sar    $0x2,%edx
80101f97:	29 c2                	sub    %eax,%edx
80101f99:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101f9c:	01 c0                	add    %eax,%eax
80101f9e:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101fa0:	85 d2                	test   %edx,%edx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101fa2:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101fa7:	89 d1                	mov    %edx,%ecx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101fa9:	88 06                	mov    %al,(%esi)
        i = i/10;
    }while(i);
80101fab:	75 db                	jne    80101f88 <itoa+0x58>
    return b;
}
80101fad:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fb0:	83 c4 10             	add    $0x10,%esp
80101fb3:	5b                   	pop    %ebx
80101fb4:	5e                   	pop    %esi
80101fb5:	5f                   	pop    %edi
80101fb6:	5d                   	pop    %ebp
80101fb7:	c3                   	ret    
80101fb8:	90                   	nop
80101fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80101fc0:	89 f0                	mov    %esi,%eax
        i *= -1;
80101fc2:	f7 d9                	neg    %ecx

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80101fc4:	8d 76 01             	lea    0x1(%esi),%esi
80101fc7:	c6 00 2d             	movb   $0x2d,(%eax)
80101fca:	eb 92                	jmp    80101f5e <itoa+0x2e>
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fd0 <removeSwapFile>:
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	57                   	push   %edi
80101fd4:	56                   	push   %esi
80101fd5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101fd6:	8d 75 bc             	lea    -0x44(%ebp),%esi
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fd9:	83 ec 40             	sub    $0x40,%esp
80101fdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101fdf:	6a 06                	push   $0x6
80101fe1:	68 55 76 10 80       	push   $0x80107655
80101fe6:	56                   	push   %esi
80101fe7:	e8 e4 2a 00 00       	call   80104ad0 <memmove>
  itoa(p->pid, path+ 6);
80101fec:	58                   	pop    %eax
80101fed:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80101ff0:	5a                   	pop    %edx
80101ff1:	50                   	push   %eax
80101ff2:	ff 73 10             	pushl  0x10(%ebx)
80101ff5:	e8 36 ff ff ff       	call   80101f30 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
80101ffa:	8b 43 7c             	mov    0x7c(%ebx),%eax
80101ffd:	83 c4 10             	add    $0x10,%esp
80102000:	85 c0                	test   %eax,%eax
80102002:	0f 84 88 01 00 00    	je     80102190 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102008:	83 ec 0c             	sub    $0xc,%esp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010200b:	8d 5d ca             	lea    -0x36(%ebp),%ebx

  if(0 == p->swapFile)
  {
    return -1;
  }
  fileclose(p->swapFile);
8010200e:	50                   	push   %eax
8010200f:	e8 4c ee ff ff       	call   80100e60 <fileclose>

  begin_op();
80102014:	e8 07 0f 00 00       	call   80102f20 <begin_op>
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80102019:	89 f0                	mov    %esi,%eax
8010201b:	89 d9                	mov    %ebx,%ecx
8010201d:	ba 01 00 00 00       	mov    $0x1,%edx
80102022:	e8 59 fc ff ff       	call   80101c80 <namex>
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
80102027:	83 c4 10             	add    $0x10,%esp
8010202a:	85 c0                	test   %eax,%eax
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010202c:	89 c6                	mov    %eax,%esi
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
8010202e:	0f 84 66 01 00 00    	je     8010219a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102034:	83 ec 0c             	sub    $0xc,%esp
80102037:	50                   	push   %eax
80102038:	e8 63 f6 ff ff       	call   801016a0 <ilock>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
8010203d:	83 c4 0c             	add    $0xc,%esp
80102040:	6a 0e                	push   $0xe
80102042:	68 5d 76 10 80       	push   $0x8010765d
80102047:	53                   	push   %ebx
80102048:	e8 03 2b 00 00       	call   80104b50 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010204d:	83 c4 10             	add    $0x10,%esp
80102050:	85 c0                	test   %eax,%eax
80102052:	0f 84 f0 00 00 00    	je     80102148 <removeSwapFile+0x178>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80102058:	83 ec 04             	sub    $0x4,%esp
8010205b:	6a 0e                	push   $0xe
8010205d:	68 5c 76 10 80       	push   $0x8010765c
80102062:	53                   	push   %ebx
80102063:	e8 e8 2a 00 00       	call   80104b50 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102068:	83 c4 10             	add    $0x10,%esp
8010206b:	85 c0                	test   %eax,%eax
8010206d:	0f 84 d5 00 00 00    	je     80102148 <removeSwapFile+0x178>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102073:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102076:	83 ec 04             	sub    $0x4,%esp
80102079:	50                   	push   %eax
8010207a:	53                   	push   %ebx
8010207b:	56                   	push   %esi
8010207c:	e8 4f fb ff ff       	call   80101bd0 <dirlookup>
80102081:	83 c4 10             	add    $0x10,%esp
80102084:	85 c0                	test   %eax,%eax
80102086:	89 c3                	mov    %eax,%ebx
80102088:	0f 84 ba 00 00 00    	je     80102148 <removeSwapFile+0x178>
    goto bad;
  ilock(ip);
8010208e:	83 ec 0c             	sub    $0xc,%esp
80102091:	50                   	push   %eax
80102092:	e8 09 f6 ff ff       	call   801016a0 <ilock>

  if(ip->nlink < 1)
80102097:	83 c4 10             	add    $0x10,%esp
8010209a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010209f:	0f 8e 11 01 00 00    	jle    801021b6 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801020a5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020aa:	74 74                	je     80102120 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801020ac:	8d 7d d8             	lea    -0x28(%ebp),%edi
801020af:	83 ec 04             	sub    $0x4,%esp
801020b2:	6a 10                	push   $0x10
801020b4:	6a 00                	push   $0x0
801020b6:	57                   	push   %edi
801020b7:	e8 64 29 00 00       	call   80104a20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020bc:	6a 10                	push   $0x10
801020be:	ff 75 b8             	pushl  -0x48(%ebp)
801020c1:	57                   	push   %edi
801020c2:	56                   	push   %esi
801020c3:	e8 b8 f9 ff ff       	call   80101a80 <writei>
801020c8:	83 c4 20             	add    $0x20,%esp
801020cb:	83 f8 10             	cmp    $0x10,%eax
801020ce:	0f 85 d5 00 00 00    	jne    801021a9 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020d4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020d9:	0f 84 91 00 00 00    	je     80102170 <removeSwapFile+0x1a0>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801020df:	83 ec 0c             	sub    $0xc,%esp
801020e2:	56                   	push   %esi
801020e3:	e8 98 f6 ff ff       	call   80101780 <iunlock>
  iput(ip);
801020e8:	89 34 24             	mov    %esi,(%esp)
801020eb:	e8 e0 f6 ff ff       	call   801017d0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801020f0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801020f5:	89 1c 24             	mov    %ebx,(%esp)
801020f8:	e8 f3 f4 ff ff       	call   801015f0 <iupdate>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801020fd:	89 1c 24             	mov    %ebx,(%esp)
80102100:	e8 7b f6 ff ff       	call   80101780 <iunlock>
  iput(ip);
80102105:	89 1c 24             	mov    %ebx,(%esp)
80102108:	e8 c3 f6 ff ff       	call   801017d0 <iput>

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();
8010210d:	e8 7e 0e 00 00       	call   80102f90 <end_op>

  return 0;
80102112:	83 c4 10             	add    $0x10,%esp
80102115:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102117:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010211a:	5b                   	pop    %ebx
8010211b:	5e                   	pop    %esi
8010211c:	5f                   	pop    %edi
8010211d:	5d                   	pop    %ebp
8010211e:	c3                   	ret    
8010211f:	90                   	nop
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102120:	83 ec 0c             	sub    $0xc,%esp
80102123:	53                   	push   %ebx
80102124:	e8 07 31 00 00       	call   80105230 <isdirempty>
80102129:	83 c4 10             	add    $0x10,%esp
8010212c:	85 c0                	test   %eax,%eax
8010212e:	0f 85 78 ff ff ff    	jne    801020ac <removeSwapFile+0xdc>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102134:	83 ec 0c             	sub    $0xc,%esp
80102137:	53                   	push   %ebx
80102138:	e8 43 f6 ff ff       	call   80101780 <iunlock>
  iput(ip);
8010213d:	89 1c 24             	mov    %ebx,(%esp)
80102140:	e8 8b f6 ff ff       	call   801017d0 <iput>
80102145:	83 c4 10             	add    $0x10,%esp

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102148:	83 ec 0c             	sub    $0xc,%esp
8010214b:	56                   	push   %esi
8010214c:	e8 2f f6 ff ff       	call   80101780 <iunlock>
  iput(ip);
80102151:	89 34 24             	mov    %esi,(%esp)
80102154:	e8 77 f6 ff ff       	call   801017d0 <iput>

  return 0;

  bad:
    iunlockput(dp);
    end_op();
80102159:	e8 32 0e 00 00       	call   80102f90 <end_op>
    return -1;
8010215e:	83 c4 10             	add    $0x10,%esp

}
80102161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

  bad:
    iunlockput(dp);
    end_op();
    return -1;
80102164:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
80102169:	5b                   	pop    %ebx
8010216a:	5e                   	pop    %esi
8010216b:	5f                   	pop    %edi
8010216c:	5d                   	pop    %ebp
8010216d:	c3                   	ret    
8010216e:	66 90                	xchg   %ax,%ax

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80102170:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	56                   	push   %esi
80102179:	e8 72 f4 ff ff       	call   801015f0 <iupdate>
8010217e:	83 c4 10             	add    $0x10,%esp
80102181:	e9 59 ff ff ff       	jmp    801020df <removeSwapFile+0x10f>
80102186:	8d 76 00             	lea    0x0(%esi),%esi
80102189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
  {
    return -1;
80102190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102195:	e9 7d ff ff ff       	jmp    80102117 <removeSwapFile+0x147>
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
  {
    end_op();
8010219a:	e8 f1 0d 00 00       	call   80102f90 <end_op>
    return -1;
8010219f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021a4:	e9 6e ff ff ff       	jmp    80102117 <removeSwapFile+0x147>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801021a9:	83 ec 0c             	sub    $0xc,%esp
801021ac:	68 71 76 10 80       	push   $0x80107671
801021b1:	e8 ba e1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801021b6:	83 ec 0c             	sub    $0xc,%esp
801021b9:	68 5f 76 10 80       	push   $0x8010765f
801021be:	e8 ad e1 ff ff       	call   80100370 <panic>
801021c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021d0 <createSwapFile>:
}


//return 0 on success
int
createSwapFile(struct proc* p) {
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	56                   	push   %esi
801021d4:	53                   	push   %ebx

    char path[DIGITS];
    memmove(path, "/.swap", 6);
801021d5:	8d 75 ea             	lea    -0x16(%ebp),%esi
}


//return 0 on success
int
createSwapFile(struct proc* p) {
801021d8:	83 ec 14             	sub    $0x14,%esp
801021db:	8b 5d 08             	mov    0x8(%ebp),%ebx

    char path[DIGITS];
    memmove(path, "/.swap", 6);
801021de:	6a 06                	push   $0x6
801021e0:	68 55 76 10 80       	push   $0x80107655
801021e5:	56                   	push   %esi
801021e6:	e8 e5 28 00 00       	call   80104ad0 <memmove>
    itoa(p->pid, path + 6);
801021eb:	58                   	pop    %eax
801021ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
801021ef:	5a                   	pop    %edx
801021f0:	50                   	push   %eax
801021f1:	ff 73 10             	pushl  0x10(%ebx)
801021f4:	e8 37 fd ff ff       	call   80101f30 <itoa>

    begin_op();
801021f9:	e8 22 0d 00 00       	call   80102f20 <begin_op>
    struct inode *in = create(path, T_FILE, 0, 0);
801021fe:	6a 00                	push   $0x0
80102200:	6a 00                	push   $0x0
80102202:	6a 02                	push   $0x2
80102204:	56                   	push   %esi
80102205:	e8 36 32 00 00       	call   80105440 <create>
    iunlock(in);
8010220a:	83 c4 14             	add    $0x14,%esp
    char path[DIGITS];
    memmove(path, "/.swap", 6);
    itoa(p->pid, path + 6);

    begin_op();
    struct inode *in = create(path, T_FILE, 0, 0);
8010220d:	89 c6                	mov    %eax,%esi
    iunlock(in);
8010220f:	50                   	push   %eax
80102210:	e8 6b f5 ff ff       	call   80101780 <iunlock>

    p->swapFile = filealloc();
80102215:	e8 86 eb ff ff       	call   80100da0 <filealloc>
    if (p->swapFile == 0)
8010221a:	83 c4 10             	add    $0x10,%esp
8010221d:	85 c0                	test   %eax,%eax

    begin_op();
    struct inode *in = create(path, T_FILE, 0, 0);
    iunlock(in);

    p->swapFile = filealloc();
8010221f:	89 43 7c             	mov    %eax,0x7c(%ebx)
    if (p->swapFile == 0)
80102222:	74 32                	je     80102256 <createSwapFile+0x86>
        panic("no slot for files on /store");

    p->swapFile->ip = in;
80102224:	89 70 10             	mov    %esi,0x10(%eax)
    p->swapFile->type = FD_INODE;
80102227:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010222a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    p->swapFile->off = 0;
80102230:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102233:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    p->swapFile->readable = O_WRONLY;
8010223a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010223d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
    p->swapFile->writable = O_RDWR;
80102241:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102244:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102248:	e8 43 0d 00 00       	call   80102f90 <end_op>

    return 0;
}
8010224d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102250:	31 c0                	xor    %eax,%eax
80102252:	5b                   	pop    %ebx
80102253:	5e                   	pop    %esi
80102254:	5d                   	pop    %ebp
80102255:	c3                   	ret    
    struct inode *in = create(path, T_FILE, 0, 0);
    iunlock(in);

    p->swapFile = filealloc();
    if (p->swapFile == 0)
        panic("no slot for files on /store");
80102256:	83 ec 0c             	sub    $0xc,%esp
80102259:	68 80 76 10 80       	push   $0x80107680
8010225e:	e8 0d e1 ff ff       	call   80100370 <panic>
80102263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102270 <writeToSwapFile>:
}

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102276:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102279:	8b 50 7c             	mov    0x7c(%eax),%edx
8010227c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010227f:	8b 55 14             	mov    0x14(%ebp),%edx
80102282:	89 55 10             	mov    %edx,0x10(%ebp)
80102285:	8b 40 7c             	mov    0x7c(%eax),%eax
80102288:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010228b:	5d                   	pop    %ebp
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return filewrite(p->swapFile, buffer, size);
8010228c:	e9 7f ed ff ff       	jmp    80101010 <filewrite>
80102291:	eb 0d                	jmp    801022a0 <readFromSwapFile>
80102293:	90                   	nop
80102294:	90                   	nop
80102295:	90                   	nop
80102296:	90                   	nop
80102297:	90                   	nop
80102298:	90                   	nop
80102299:	90                   	nop
8010229a:	90                   	nop
8010229b:	90                   	nop
8010229c:	90                   	nop
8010229d:	90                   	nop
8010229e:	90                   	nop
8010229f:	90                   	nop

801022a0 <readFromSwapFile>:
}

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022a9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022ac:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
801022af:	8b 55 14             	mov    0x14(%ebp),%edx
801022b2:	89 55 10             	mov    %edx,0x10(%ebp)
801022b5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022b8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801022bb:	5d                   	pop    %ebp
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return fileread(p->swapFile, buffer,  size);
801022bc:	e9 bf ec ff ff       	jmp    80100f80 <fileread>
801022c1:	66 90                	xchg   %ax,%ax
801022c3:	66 90                	xchg   %ax,%ax
801022c5:	66 90                	xchg   %ax,%ax
801022c7:	66 90                	xchg   %ax,%ax
801022c9:	66 90                	xchg   %ax,%ax
801022cb:	66 90                	xchg   %ax,%ax
801022cd:	66 90                	xchg   %ax,%ax
801022cf:	90                   	nop

801022d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022d0:	55                   	push   %ebp
  if(b == 0)
801022d1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022d3:	89 e5                	mov    %esp,%ebp
801022d5:	56                   	push   %esi
801022d6:	53                   	push   %ebx
  if(b == 0)
801022d7:	0f 84 ad 00 00 00    	je     8010238a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022dd:	8b 58 08             	mov    0x8(%eax),%ebx
801022e0:	89 c1                	mov    %eax,%ecx
801022e2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022e8:	0f 87 8f 00 00 00    	ja     8010237d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022ee:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022f3:	90                   	nop
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f9:	83 e0 c0             	and    $0xffffffc0,%eax
801022fc:	3c 40                	cmp    $0x40,%al
801022fe:	75 f8                	jne    801022f8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102300:	31 f6                	xor    %esi,%esi
80102302:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102307:	89 f0                	mov    %esi,%eax
80102309:	ee                   	out    %al,(%dx)
8010230a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010230f:	b8 01 00 00 00       	mov    $0x1,%eax
80102314:	ee                   	out    %al,(%dx)
80102315:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010231a:	89 d8                	mov    %ebx,%eax
8010231c:	ee                   	out    %al,(%dx)
8010231d:	89 d8                	mov    %ebx,%eax
8010231f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102324:	c1 f8 08             	sar    $0x8,%eax
80102327:	ee                   	out    %al,(%dx)
80102328:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010232d:	89 f0                	mov    %esi,%eax
8010232f:	ee                   	out    %al,(%dx)
80102330:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102334:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102339:	83 e0 01             	and    $0x1,%eax
8010233c:	c1 e0 04             	shl    $0x4,%eax
8010233f:	83 c8 e0             	or     $0xffffffe0,%eax
80102342:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102343:	f6 01 04             	testb  $0x4,(%ecx)
80102346:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010234b:	75 13                	jne    80102360 <idestart+0x90>
8010234d:	b8 20 00 00 00       	mov    $0x20,%eax
80102352:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102353:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102356:	5b                   	pop    %ebx
80102357:	5e                   	pop    %esi
80102358:	5d                   	pop    %ebp
80102359:	c3                   	ret    
8010235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102360:	b8 30 00 00 00       	mov    $0x30,%eax
80102365:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102366:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010236b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010236e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102373:	fc                   	cld    
80102374:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102376:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102379:	5b                   	pop    %ebx
8010237a:	5e                   	pop    %esi
8010237b:	5d                   	pop    %ebp
8010237c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010237d:	83 ec 0c             	sub    $0xc,%esp
80102380:	68 f8 76 10 80       	push   $0x801076f8
80102385:	e8 e6 df ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010238a:	83 ec 0c             	sub    $0xc,%esp
8010238d:	68 ef 76 10 80       	push   $0x801076ef
80102392:	e8 d9 df ff ff       	call   80100370 <panic>
80102397:	89 f6                	mov    %esi,%esi
80102399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023a0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
801023a6:	68 0a 77 10 80       	push   $0x8010770a
801023ab:	68 80 a5 10 80       	push   $0x8010a580
801023b0:	e8 fb 23 00 00       	call   801047b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023b5:	58                   	pop    %eax
801023b6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801023bb:	5a                   	pop    %edx
801023bc:	83 e8 01             	sub    $0x1,%eax
801023bf:	50                   	push   %eax
801023c0:	6a 0e                	push   $0xe
801023c2:	e8 a9 02 00 00       	call   80102670 <ioapicenable>
801023c7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023cf:	90                   	nop
801023d0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023d1:	83 e0 c0             	and    $0xffffffc0,%eax
801023d4:	3c 40                	cmp    $0x40,%al
801023d6:	75 f8                	jne    801023d0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023d8:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023dd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023e2:	ee                   	out    %al,(%dx)
801023e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ed:	eb 06                	jmp    801023f5 <ideinit+0x55>
801023ef:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
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
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102404:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102409:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010240e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
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
}

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
8010242e:	e8 7d 24 00 00       	call   801048b0 <acquire>

  if((b = idequeue) == 0){
80102433:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102439:	83 c4 10             	add    $0x10,%esp
8010243c:	85 db                	test   %ebx,%ebx
8010243e:	74 34                	je     80102474 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102440:	8b 43 58             	mov    0x58(%ebx),%eax
80102443:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102448:	8b 33                	mov    (%ebx),%esi
8010244a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102450:	74 3e                	je     80102490 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102452:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102455:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102458:	83 ce 02             	or     $0x2,%esi
8010245b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010245d:	53                   	push   %ebx
8010245e:	e8 8d 20 00 00       	call   801044f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102463:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102468:	83 c4 10             	add    $0x10,%esp
8010246b:	85 c0                	test   %eax,%eax
8010246d:	74 05                	je     80102474 <ideintr+0x54>
    idestart(idequeue);
8010246f:	e8 5c fe ff ff       	call   801022d0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102474:	83 ec 0c             	sub    $0xc,%esp
80102477:	68 80 a5 10 80       	push   $0x8010a580
8010247c:	e8 4f 25 00 00       	call   801049d0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102484:	5b                   	pop    %ebx
80102485:	5e                   	pop    %esi
80102486:	5f                   	pop    %edi
80102487:	5d                   	pop    %ebp
80102488:	c3                   	ret    
80102489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102490:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102495:	8d 76 00             	lea    0x0(%esi),%esi
80102498:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102499:	89 c1                	mov    %eax,%ecx
8010249b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010249e:	80 f9 40             	cmp    $0x40,%cl
801024a1:	75 f5                	jne    80102498 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024a3:	a8 21                	test   $0x21,%al
801024a5:	75 ab                	jne    80102452 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801024a7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801024aa:	b9 80 00 00 00       	mov    $0x80,%ecx
801024af:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024b4:	fc                   	cld    
801024b5:	f3 6d                	rep insl (%dx),%es:(%edi)
801024b7:	8b 33                	mov    (%ebx),%esi
801024b9:	eb 97                	jmp    80102452 <ideintr+0x32>
801024bb:	90                   	nop
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
801024ce:	e8 ad 22 00 00       	call   80104780 <holdingsleep>
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	85 c0                	test   %eax,%eax
801024d8:	0f 84 ad 00 00 00    	je     8010258b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024de:	8b 03                	mov    (%ebx),%eax
801024e0:	83 e0 06             	and    $0x6,%eax
801024e3:	83 f8 02             	cmp    $0x2,%eax
801024e6:	0f 84 b9 00 00 00    	je     801025a5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024ec:	8b 53 04             	mov    0x4(%ebx),%edx
801024ef:	85 d2                	test   %edx,%edx
801024f1:	74 0d                	je     80102500 <iderw+0x40>
801024f3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801024f8:	85 c0                	test   %eax,%eax
801024fa:	0f 84 98 00 00 00    	je     80102598 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 80 a5 10 80       	push   $0x8010a580
80102508:	e8 a3 23 00 00       	call   801048b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010250d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102513:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102516:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010251d:	85 d2                	test   %edx,%edx
8010251f:	75 09                	jne    8010252a <iderw+0x6a>
80102521:	eb 58                	jmp    8010257b <iderw+0xbb>
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
80102536:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010253c:	74 44                	je     80102582 <iderw+0xc2>
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
80102559:	e8 82 1d 00 00       	call   801042e0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010255e:	8b 03                	mov    (%ebx),%eax
80102560:	83 c4 10             	add    $0x10,%esp
80102563:	83 e0 06             	and    $0x6,%eax
80102566:	83 f8 02             	cmp    $0x2,%eax
80102569:	75 e5                	jne    80102550 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010256b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102575:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102576:	e9 55 24 00 00       	jmp    801049d0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010257b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102580:	eb b2                	jmp    80102534 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102582:	89 d8                	mov    %ebx,%eax
80102584:	e8 47 fd ff ff       	call   801022d0 <idestart>
80102589:	eb b3                	jmp    8010253e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010258b:	83 ec 0c             	sub    $0xc,%esp
8010258e:	68 0e 77 10 80       	push   $0x8010770e
80102593:	e8 d8 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	68 39 77 10 80       	push   $0x80107739
801025a0:	e8 cb dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801025a5:	83 ec 0c             	sub    $0xc,%esp
801025a8:	68 24 77 10 80       	push   $0x80107724
801025ad:	e8 be dd ff ff       	call   80100370 <panic>
801025b2:	66 90                	xchg   %ax,%ax
801025b4:	66 90                	xchg   %ax,%ax
801025b6:	66 90                	xchg   %ax,%ax
801025b8:	66 90                	xchg   %ax,%ax
801025ba:	66 90                	xchg   %ax,%ax
801025bc:	66 90                	xchg   %ax,%ax
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
801025c1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801025c8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025cb:	89 e5                	mov    %esp,%ebp
801025cd:	56                   	push   %esi
801025ce:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025d6:	00 00 00 
  return ioapic->data;
801025d9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801025df:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801025e8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025ee:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025f5:	89 f0                	mov    %esi,%eax
801025f7:	c1 e8 10             	shr    $0x10,%eax
801025fa:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801025fd:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102600:	c1 e8 18             	shr    $0x18,%eax
80102603:	39 d0                	cmp    %edx,%eax
80102605:	74 16                	je     8010261d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102607:	83 ec 0c             	sub    $0xc,%esp
8010260a:	68 58 77 10 80       	push   $0x80107758
8010260f:	e8 4c e0 ff ff       	call   80100660 <cprintf>
80102614:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010261a:	83 c4 10             	add    $0x10,%esp
8010261d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102620:	ba 10 00 00 00       	mov    $0x10,%edx
80102625:	b8 20 00 00 00       	mov    $0x20,%eax
8010262a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102630:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102632:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102638:	89 c3                	mov    %eax,%ebx
8010263a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102640:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102643:	89 59 10             	mov    %ebx,0x10(%ecx)
80102646:	8d 5a 01             	lea    0x1(%edx),%ebx
80102649:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010264c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010264e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102650:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102656:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010265d:	75 d1                	jne    80102630 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
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
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102671:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102677:	89 e5                	mov    %esp,%ebp
80102679:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010267c:	8d 50 20             	lea    0x20(%eax),%edx
8010267f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102683:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102685:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010268b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010268e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102691:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102694:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102696:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010269b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010269e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
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

801026b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	53                   	push   %ebx
801026b4:	83 ec 04             	sub    $0x4,%esp
801026b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026c0:	75 70                	jne    80102732 <kfree+0x82>
801026c2:	81 fb a8 e8 11 80    	cmp    $0x8011e8a8,%ebx
801026c8:	72 68                	jb     80102732 <kfree+0x82>
801026ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026d5:	77 5b                	ja     80102732 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026d7:	83 ec 04             	sub    $0x4,%esp
801026da:	68 00 10 00 00       	push   $0x1000
801026df:	6a 01                	push   $0x1
801026e1:	53                   	push   %ebx
801026e2:	e8 39 23 00 00       	call   80104a20 <memset>

  if(kmem.use_lock)
801026e7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	85 d2                	test   %edx,%edx
801026f2:	75 2c                	jne    80102720 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026f4:	a1 78 26 11 80       	mov    0x80112678,%eax
801026f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026fb:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102700:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102706:	85 c0                	test   %eax,%eax
80102708:	75 06                	jne    80102710 <kfree+0x60>
    release(&kmem.lock);
}
8010270a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010270d:	c9                   	leave  
8010270e:	c3                   	ret    
8010270f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102710:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010271a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010271b:	e9 b0 22 00 00       	jmp    801049d0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102720:	83 ec 0c             	sub    $0xc,%esp
80102723:	68 40 26 11 80       	push   $0x80112640
80102728:	e8 83 21 00 00       	call   801048b0 <acquire>
8010272d:	83 c4 10             	add    $0x10,%esp
80102730:	eb c2                	jmp    801026f4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102732:	83 ec 0c             	sub    $0xc,%esp
80102735:	68 8a 77 10 80       	push   $0x8010778a
8010273a:	e8 31 dc ff ff       	call   80100370 <panic>
8010273f:	90                   	nop

80102740 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
80102744:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102745:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102748:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010274b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102751:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102757:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275d:	39 de                	cmp    %ebx,%esi
8010275f:	72 23                	jb     80102784 <freerange+0x44>
80102761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102768:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010276e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102771:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102777:	50                   	push   %eax
80102778:	e8 33 ff ff ff       	call   801026b0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	39 f3                	cmp    %esi,%ebx
80102782:	76 e4                	jbe    80102768 <freerange+0x28>
    kfree(p);
}
80102784:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102787:	5b                   	pop    %ebx
80102788:	5e                   	pop    %esi
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
80102794:	53                   	push   %ebx
80102795:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102798:	83 ec 08             	sub    $0x8,%esp
8010279b:	68 90 77 10 80       	push   $0x80107790
801027a0:	68 40 26 11 80       	push   $0x80112640
801027a5:	e8 06 20 00 00       	call   801047b0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ad:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801027b0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801027b7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027cc:	39 de                	cmp    %ebx,%esi
801027ce:	72 1c                	jb     801027ec <kinit1+0x5c>
    kfree(p);
801027d0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027d6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027df:	50                   	push   %eax
801027e0:	e8 cb fe ff ff       	call   801026b0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027e5:	83 c4 10             	add    $0x10,%esp
801027e8:	39 de                	cmp    %ebx,%esi
801027ea:	73 e4                	jae    801027d0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801027ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027ef:	5b                   	pop    %ebx
801027f0:	5e                   	pop    %esi
801027f1:	5d                   	pop    %ebp
801027f2:	c3                   	ret    
801027f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	56                   	push   %esi
80102804:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102805:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102808:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010280b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102811:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102817:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010281d:	39 de                	cmp    %ebx,%esi
8010281f:	72 23                	jb     80102844 <kinit2+0x44>
80102821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102828:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010282e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102831:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102837:	50                   	push   %eax
80102838:	e8 73 fe ff ff       	call   801026b0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010283d:	83 c4 10             	add    $0x10,%esp
80102840:	39 de                	cmp    %ebx,%esi
80102842:	73 e4                	jae    80102828 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102844:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010284b:	00 00 00 
}
8010284e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102851:	5b                   	pop    %ebx
80102852:	5e                   	pop    %esi
80102853:	5d                   	pop    %ebp
80102854:	c3                   	ret    
80102855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102860 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	53                   	push   %ebx
80102864:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102867:	a1 74 26 11 80       	mov    0x80112674,%eax
8010286c:	85 c0                	test   %eax,%eax
8010286e:	75 30                	jne    801028a0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102870:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102876:	85 db                	test   %ebx,%ebx
80102878:	74 1c                	je     80102896 <kalloc+0x36>
    kmem.freelist = r->next;
8010287a:	8b 13                	mov    (%ebx),%edx
8010287c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102882:	85 c0                	test   %eax,%eax
80102884:	74 10                	je     80102896 <kalloc+0x36>
    release(&kmem.lock);
80102886:	83 ec 0c             	sub    $0xc,%esp
80102889:	68 40 26 11 80       	push   $0x80112640
8010288e:	e8 3d 21 00 00       	call   801049d0 <release>
80102893:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102896:	89 d8                	mov    %ebx,%eax
80102898:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010289b:	c9                   	leave  
8010289c:	c3                   	ret    
8010289d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801028a0:	83 ec 0c             	sub    $0xc,%esp
801028a3:	68 40 26 11 80       	push   $0x80112640
801028a8:	e8 03 20 00 00       	call   801048b0 <acquire>
  r = kmem.freelist;
801028ad:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801028b3:	83 c4 10             	add    $0x10,%esp
801028b6:	a1 74 26 11 80       	mov    0x80112674,%eax
801028bb:	85 db                	test   %ebx,%ebx
801028bd:	75 bb                	jne    8010287a <kalloc+0x1a>
801028bf:	eb c1                	jmp    80102882 <kalloc+0x22>
801028c1:	66 90                	xchg   %ax,%ax
801028c3:	66 90                	xchg   %ax,%ax
801028c5:	66 90                	xchg   %ax,%ax
801028c7:	66 90                	xchg   %ax,%ax
801028c9:	66 90                	xchg   %ax,%ax
801028cb:	66 90                	xchg   %ax,%ax
801028cd:	66 90                	xchg   %ax,%ax
801028cf:	90                   	nop

801028d0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801028d0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d1:	ba 64 00 00 00       	mov    $0x64,%edx
801028d6:	89 e5                	mov    %esp,%ebp
801028d8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028d9:	a8 01                	test   $0x1,%al
801028db:	0f 84 af 00 00 00    	je     80102990 <kbdgetc+0xc0>
801028e1:	ba 60 00 00 00       	mov    $0x60,%edx
801028e6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028e7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801028ea:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028f0:	74 7e                	je     80102970 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028f2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028f4:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028fa:	79 24                	jns    80102920 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028fc:	f6 c1 40             	test   $0x40,%cl
801028ff:	75 05                	jne    80102906 <kbdgetc+0x36>
80102901:	89 c2                	mov    %eax,%edx
80102903:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102906:	0f b6 82 c0 78 10 80 	movzbl -0x7fef8740(%edx),%eax
8010290d:	83 c8 40             	or     $0x40,%eax
80102910:	0f b6 c0             	movzbl %al,%eax
80102913:	f7 d0                	not    %eax
80102915:	21 c8                	and    %ecx,%eax
80102917:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010291c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010291e:	5d                   	pop    %ebp
8010291f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102920:	f6 c1 40             	test   $0x40,%cl
80102923:	74 09                	je     8010292e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102925:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102928:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010292b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010292e:	0f b6 82 c0 78 10 80 	movzbl -0x7fef8740(%edx),%eax
80102935:	09 c1                	or     %eax,%ecx
80102937:	0f b6 82 c0 77 10 80 	movzbl -0x7fef8840(%edx),%eax
8010293e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102940:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102942:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102948:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010294b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010294e:	8b 04 85 a0 77 10 80 	mov    -0x7fef8860(,%eax,4),%eax
80102955:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102959:	74 c3                	je     8010291e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010295b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010295e:	83 fa 19             	cmp    $0x19,%edx
80102961:	77 1d                	ja     80102980 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102963:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102966:	5d                   	pop    %ebp
80102967:	c3                   	ret    
80102968:	90                   	nop
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102970:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102972:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102979:	5d                   	pop    %ebp
8010297a:	c3                   	ret    
8010297b:	90                   	nop
8010297c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102980:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102983:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102986:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102987:	83 f9 19             	cmp    $0x19,%ecx
8010298a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010298d:	c3                   	ret    
8010298e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102995:	5d                   	pop    %ebp
80102996:	c3                   	ret    
80102997:	89 f6                	mov    %esi,%esi
80102999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029a0 <kbdintr>:

void
kbdintr(void)
{
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
801029a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029a6:	68 d0 28 10 80       	push   $0x801028d0
801029ab:	e8 40 de ff ff       	call   801007f0 <consoleintr>
}
801029b0:	83 c4 10             	add    $0x10,%esp
801029b3:	c9                   	leave  
801029b4:	c3                   	ret    
801029b5:	66 90                	xchg   %ax,%ax
801029b7:	66 90                	xchg   %ax,%ax
801029b9:	66 90                	xchg   %ax,%ax
801029bb:	66 90                	xchg   %ax,%ax
801029bd:	66 90                	xchg   %ax,%ax
801029bf:	90                   	nop

801029c0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801029c5:	55                   	push   %ebp
801029c6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029c8:	85 c0                	test   %eax,%eax
801029ca:	0f 84 c8 00 00 00    	je     80102a98 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029d0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029d7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029da:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029dd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ea:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029f1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029f4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029f7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029fe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a01:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a04:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a0b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a11:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a18:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a1e:	8b 50 30             	mov    0x30(%eax),%edx
80102a21:	c1 ea 10             	shr    $0x10,%edx
80102a24:	80 fa 03             	cmp    $0x3,%dl
80102a27:	77 77                	ja     80102aa0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a29:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a33:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a36:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a3d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a40:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a43:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a4a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a50:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a57:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a5d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a64:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a67:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a6a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a71:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a74:	8b 50 20             	mov    0x20(%eax),%edx
80102a77:	89 f6                	mov    %esi,%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a80:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a86:	80 e6 10             	and    $0x10,%dh
80102a89:	75 f5                	jne    80102a80 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a8b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a92:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a95:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a98:	5d                   	pop    %ebp
80102a99:	c3                   	ret    
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aa0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102aa7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aaa:	8b 50 20             	mov    0x20(%eax),%edx
80102aad:	e9 77 ff ff ff       	jmp    80102a29 <lapicinit+0x69>
80102ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ac0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102ac0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102ac5:	55                   	push   %ebp
80102ac6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102ac8:	85 c0                	test   %eax,%eax
80102aca:	74 0c                	je     80102ad8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102acc:	8b 40 20             	mov    0x20(%eax),%eax
}
80102acf:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102ad0:	c1 e8 18             	shr    $0x18,%eax
}
80102ad3:	c3                   	ret    
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102ad8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102ada:	5d                   	pop    %ebp
80102adb:	c3                   	ret    
80102adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ae0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ae0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ae5:	55                   	push   %ebp
80102ae6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ae8:	85 c0                	test   %eax,%eax
80102aea:	74 0d                	je     80102af9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aec:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102af3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102af9:	5d                   	pop    %ebp
80102afa:	c3                   	ret    
80102afb:	90                   	nop
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
}
80102b03:	5d                   	pop    %ebp
80102b04:	c3                   	ret    
80102b05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b10 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b10:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b11:	ba 70 00 00 00       	mov    $0x70,%edx
80102b16:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b1b:	89 e5                	mov    %esp,%ebp
80102b1d:	53                   	push   %ebx
80102b1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b24:	ee                   	out    %al,(%dx)
80102b25:	ba 71 00 00 00       	mov    $0x71,%edx
80102b2a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b2f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b30:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b32:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b35:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b3b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b3d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b40:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b43:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b45:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b48:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b4e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102b53:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b59:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b5c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b63:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b66:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b69:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b70:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b73:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b76:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b7c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b7f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b85:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b88:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b8e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b91:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b97:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102b9a:	5b                   	pop    %ebx
80102b9b:	5d                   	pop    %ebp
80102b9c:	c3                   	ret    
80102b9d:	8d 76 00             	lea    0x0(%esi),%esi

80102ba0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102ba0:	55                   	push   %ebp
80102ba1:	ba 70 00 00 00       	mov    $0x70,%edx
80102ba6:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bab:	89 e5                	mov    %esp,%ebp
80102bad:	57                   	push   %edi
80102bae:	56                   	push   %esi
80102baf:	53                   	push   %ebx
80102bb0:	83 ec 4c             	sub    $0x4c,%esp
80102bb3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bb4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bb9:	ec                   	in     (%dx),%al
80102bba:	83 e0 04             	and    $0x4,%eax
80102bbd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc0:	31 db                	xor    %ebx,%ebx
80102bc2:	88 45 b7             	mov    %al,-0x49(%ebp)
80102bc5:	bf 70 00 00 00       	mov    $0x70,%edi
80102bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bd0:	89 d8                	mov    %ebx,%eax
80102bd2:	89 fa                	mov    %edi,%edx
80102bd4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bda:	89 ca                	mov    %ecx,%edx
80102bdc:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102bdd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be0:	89 fa                	mov    %edi,%edx
80102be2:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102be5:	b8 02 00 00 00       	mov    $0x2,%eax
80102bea:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102beb:	89 ca                	mov    %ecx,%edx
80102bed:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102bee:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf1:	89 fa                	mov    %edi,%edx
80102bf3:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102bf6:	b8 04 00 00 00       	mov    $0x4,%eax
80102bfb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfc:	89 ca                	mov    %ecx,%edx
80102bfe:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102bff:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c02:	89 fa                	mov    %edi,%edx
80102c04:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c07:	b8 07 00 00 00       	mov    $0x7,%eax
80102c0c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0d:	89 ca                	mov    %ecx,%edx
80102c0f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c10:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c13:	89 fa                	mov    %edi,%edx
80102c15:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c18:	b8 08 00 00 00       	mov    $0x8,%eax
80102c1d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1e:	89 ca                	mov    %ecx,%edx
80102c20:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c21:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c24:	89 fa                	mov    %edi,%edx
80102c26:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102c29:	b8 09 00 00 00       	mov    $0x9,%eax
80102c2e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2f:	89 ca                	mov    %ecx,%edx
80102c31:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c32:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c35:	89 fa                	mov    %edi,%edx
80102c37:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102c3a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c3f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c40:	89 ca                	mov    %ecx,%edx
80102c42:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c43:	84 c0                	test   %al,%al
80102c45:	78 89                	js     80102bd0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c47:	89 d8                	mov    %ebx,%eax
80102c49:	89 fa                	mov    %edi,%edx
80102c4b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4c:	89 ca                	mov    %ecx,%edx
80102c4e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c4f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c52:	89 fa                	mov    %edi,%edx
80102c54:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c57:	b8 02 00 00 00       	mov    $0x2,%eax
80102c5c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5d:	89 ca                	mov    %ecx,%edx
80102c5f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c60:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c63:	89 fa                	mov    %edi,%edx
80102c65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c68:	b8 04 00 00 00       	mov    $0x4,%eax
80102c6d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6e:	89 ca                	mov    %ecx,%edx
80102c70:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c71:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c74:	89 fa                	mov    %edi,%edx
80102c76:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c79:	b8 07 00 00 00       	mov    $0x7,%eax
80102c7e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7f:	89 ca                	mov    %ecx,%edx
80102c81:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c82:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c85:	89 fa                	mov    %edi,%edx
80102c87:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c8a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c8f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c90:	89 ca                	mov    %ecx,%edx
80102c92:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c93:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c96:	89 fa                	mov    %edi,%edx
80102c98:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c9b:	b8 09 00 00 00       	mov    $0x9,%eax
80102ca0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca1:	89 ca                	mov    %ecx,%edx
80102ca3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102ca4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ca7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102caa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cad:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cb0:	6a 18                	push   $0x18
80102cb2:	56                   	push   %esi
80102cb3:	50                   	push   %eax
80102cb4:	e8 b7 1d 00 00       	call   80104a70 <memcmp>
80102cb9:	83 c4 10             	add    $0x10,%esp
80102cbc:	85 c0                	test   %eax,%eax
80102cbe:	0f 85 0c ff ff ff    	jne    80102bd0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102cc4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102cc8:	75 78                	jne    80102d42 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cca:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ccd:	89 c2                	mov    %eax,%edx
80102ccf:	83 e0 0f             	and    $0xf,%eax
80102cd2:	c1 ea 04             	shr    $0x4,%edx
80102cd5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cd8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cdb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cde:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ce1:	89 c2                	mov    %eax,%edx
80102ce3:	83 e0 0f             	and    $0xf,%eax
80102ce6:	c1 ea 04             	shr    $0x4,%edx
80102ce9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cec:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cef:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102cf2:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cf5:	89 c2                	mov    %eax,%edx
80102cf7:	83 e0 0f             	and    $0xf,%eax
80102cfa:	c1 ea 04             	shr    $0x4,%edx
80102cfd:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d00:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d03:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d06:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d09:	89 c2                	mov    %eax,%edx
80102d0b:	83 e0 0f             	and    $0xf,%eax
80102d0e:	c1 ea 04             	shr    $0x4,%edx
80102d11:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d14:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d17:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d1a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d1d:	89 c2                	mov    %eax,%edx
80102d1f:	83 e0 0f             	and    $0xf,%eax
80102d22:	c1 ea 04             	shr    $0x4,%edx
80102d25:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d28:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d31:	89 c2                	mov    %eax,%edx
80102d33:	83 e0 0f             	and    $0xf,%eax
80102d36:	c1 ea 04             	shr    $0x4,%edx
80102d39:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d3c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d3f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d42:	8b 75 08             	mov    0x8(%ebp),%esi
80102d45:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d48:	89 06                	mov    %eax,(%esi)
80102d4a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d4d:	89 46 04             	mov    %eax,0x4(%esi)
80102d50:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d53:	89 46 08             	mov    %eax,0x8(%esi)
80102d56:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d59:	89 46 0c             	mov    %eax,0xc(%esi)
80102d5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d5f:	89 46 10             	mov    %eax,0x10(%esi)
80102d62:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d65:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d68:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d72:	5b                   	pop    %ebx
80102d73:	5e                   	pop    %esi
80102d74:	5f                   	pop    %edi
80102d75:	5d                   	pop    %ebp
80102d76:	c3                   	ret    
80102d77:	66 90                	xchg   %ax,%ax
80102d79:	66 90                	xchg   %ax,%ax
80102d7b:	66 90                	xchg   %ax,%ax
80102d7d:	66 90                	xchg   %ax,%ax
80102d7f:	90                   	nop

80102d80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d80:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d86:	85 c9                	test   %ecx,%ecx
80102d88:	0f 8e 85 00 00 00    	jle    80102e13 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102d8e:	55                   	push   %ebp
80102d8f:	89 e5                	mov    %esp,%ebp
80102d91:	57                   	push   %edi
80102d92:	56                   	push   %esi
80102d93:	53                   	push   %ebx
80102d94:	31 db                	xor    %ebx,%ebx
80102d96:	83 ec 0c             	sub    $0xc,%esp
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102da0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102da5:	83 ec 08             	sub    $0x8,%esp
80102da8:	01 d8                	add    %ebx,%eax
80102daa:	83 c0 01             	add    $0x1,%eax
80102dad:	50                   	push   %eax
80102dae:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102db4:	e8 17 d3 ff ff       	call   801000d0 <bread>
80102db9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dbb:	58                   	pop    %eax
80102dbc:	5a                   	pop    %edx
80102dbd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102dc4:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dca:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dcd:	e8 fe d2 ff ff       	call   801000d0 <bread>
80102dd2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dd4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102dd7:	83 c4 0c             	add    $0xc,%esp
80102dda:	68 00 02 00 00       	push   $0x200
80102ddf:	50                   	push   %eax
80102de0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102de3:	50                   	push   %eax
80102de4:	e8 e7 1c 00 00       	call   80104ad0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102de9:	89 34 24             	mov    %esi,(%esp)
80102dec:	e8 af d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102df1:	89 3c 24             	mov    %edi,(%esp)
80102df4:	e8 e7 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102df9:	89 34 24             	mov    %esi,(%esp)
80102dfc:	e8 df d3 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102e0a:	7f 94                	jg     80102da0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102e0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e0f:	5b                   	pop    %ebx
80102e10:	5e                   	pop    %esi
80102e11:	5f                   	pop    %edi
80102e12:	5d                   	pop    %ebp
80102e13:	f3 c3                	repz ret 
80102e15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
80102e24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e27:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102e2d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e33:	e8 98 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e38:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e3e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e41:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e43:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e45:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e48:	7e 1f                	jle    80102e69 <write_head+0x49>
80102e4a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102e51:	31 d2                	xor    %edx,%edx
80102e53:	90                   	nop
80102e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e58:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102e5e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102e62:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e65:	39 c2                	cmp    %eax,%edx
80102e67:	75 ef                	jne    80102e58 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102e69:	83 ec 0c             	sub    $0xc,%esp
80102e6c:	53                   	push   %ebx
80102e6d:	e8 2e d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e72:	89 1c 24             	mov    %ebx,(%esp)
80102e75:	e8 66 d3 ff ff       	call   801001e0 <brelse>
}
80102e7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e7d:	c9                   	leave  
80102e7e:	c3                   	ret    
80102e7f:	90                   	nop

80102e80 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 2c             	sub    $0x2c,%esp
80102e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e8a:	68 c0 79 10 80       	push   $0x801079c0
80102e8f:	68 80 26 11 80       	push   $0x80112680
80102e94:	e8 17 19 00 00       	call   801047b0 <initlock>
  readsb(dev, &sb);
80102e99:	58                   	pop    %eax
80102e9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e9d:	5a                   	pop    %edx
80102e9e:	50                   	push   %eax
80102e9f:	53                   	push   %ebx
80102ea0:	e8 3b e5 ff ff       	call   801013e0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ea5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102eab:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102eac:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102eb2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102eb8:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ebd:	5a                   	pop    %edx
80102ebe:	50                   	push   %eax
80102ebf:	53                   	push   %ebx
80102ec0:	e8 0b d2 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ec5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ec8:	83 c4 10             	add    $0x10,%esp
80102ecb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ecd:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ed3:	7e 1c                	jle    80102ef1 <initlog+0x71>
80102ed5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102edc:	31 d2                	xor    %edx,%edx
80102ede:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ee0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ee4:	83 c2 04             	add    $0x4,%edx
80102ee7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102eed:	39 da                	cmp    %ebx,%edx
80102eef:	75 ef                	jne    80102ee0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102ef1:	83 ec 0c             	sub    $0xc,%esp
80102ef4:	50                   	push   %eax
80102ef5:	e8 e6 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102efa:	e8 81 fe ff ff       	call   80102d80 <install_trans>
  log.lh.n = 0;
80102eff:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102f06:	00 00 00 
  write_head(); // clear the log
80102f09:	e8 12 ff ff ff       	call   80102e20 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102f0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f11:	c9                   	leave  
80102f12:	c3                   	ret    
80102f13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f26:	68 80 26 11 80       	push   $0x80112680
80102f2b:	e8 80 19 00 00       	call   801048b0 <acquire>
80102f30:	83 c4 10             	add    $0x10,%esp
80102f33:	eb 18                	jmp    80102f4d <begin_op+0x2d>
80102f35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f38:	83 ec 08             	sub    $0x8,%esp
80102f3b:	68 80 26 11 80       	push   $0x80112680
80102f40:	68 80 26 11 80       	push   $0x80112680
80102f45:	e8 96 13 00 00       	call   801042e0 <sleep>
80102f4a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102f4d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102f52:	85 c0                	test   %eax,%eax
80102f54:	75 e2                	jne    80102f38 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f56:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f5b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f61:	83 c0 01             	add    $0x1,%eax
80102f64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f6a:	83 fa 1e             	cmp    $0x1e,%edx
80102f6d:	7f c9                	jg     80102f38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f6f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102f72:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102f77:	68 80 26 11 80       	push   $0x80112680
80102f7c:	e8 4f 1a 00 00       	call   801049d0 <release>
      break;
    }
  }
}
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	c9                   	leave  
80102f85:	c3                   	ret    
80102f86:	8d 76 00             	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
80102f95:	53                   	push   %ebx
80102f96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f99:	68 80 26 11 80       	push   $0x80112680
80102f9e:	e8 0d 19 00 00       	call   801048b0 <acquire>
  log.outstanding -= 1;
80102fa3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102fa8:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102fae:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102fb1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102fb4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102fb6:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102fbb:	0f 85 23 01 00 00    	jne    801030e4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fc1:	85 c0                	test   %eax,%eax
80102fc3:	0f 85 f7 00 00 00    	jne    801030c0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fc9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102fcc:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102fd3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fd6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fd8:	68 80 26 11 80       	push   $0x80112680
80102fdd:	e8 ee 19 00 00       	call   801049d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fe2:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102fe8:	83 c4 10             	add    $0x10,%esp
80102feb:	85 c9                	test   %ecx,%ecx
80102fed:	0f 8e 8a 00 00 00    	jle    8010307d <end_op+0xed>
80102ff3:	90                   	nop
80102ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ff8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102ffd:	83 ec 08             	sub    $0x8,%esp
80103000:	01 d8                	add    %ebx,%eax
80103002:	83 c0 01             	add    $0x1,%eax
80103005:	50                   	push   %eax
80103006:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010300c:	e8 bf d0 ff ff       	call   801000d0 <bread>
80103011:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103013:	58                   	pop    %eax
80103014:	5a                   	pop    %edx
80103015:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
8010301c:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103022:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103025:	e8 a6 d0 ff ff       	call   801000d0 <bread>
8010302a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010302c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010302f:	83 c4 0c             	add    $0xc,%esp
80103032:	68 00 02 00 00       	push   $0x200
80103037:	50                   	push   %eax
80103038:	8d 46 5c             	lea    0x5c(%esi),%eax
8010303b:	50                   	push   %eax
8010303c:	e8 8f 1a 00 00       	call   80104ad0 <memmove>
    bwrite(to);  // write the log
80103041:	89 34 24             	mov    %esi,(%esp)
80103044:	e8 57 d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103049:	89 3c 24             	mov    %edi,(%esp)
8010304c:	e8 8f d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
80103051:	89 34 24             	mov    %esi,(%esp)
80103054:	e8 87 d1 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103059:	83 c4 10             	add    $0x10,%esp
8010305c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80103062:	7c 94                	jl     80102ff8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103064:	e8 b7 fd ff ff       	call   80102e20 <write_head>
    install_trans(); // Now install writes to home locations
80103069:	e8 12 fd ff ff       	call   80102d80 <install_trans>
    log.lh.n = 0;
8010306e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80103075:	00 00 00 
    write_head();    // Erase the transaction from the log
80103078:	e8 a3 fd ff ff       	call   80102e20 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010307d:	83 ec 0c             	sub    $0xc,%esp
80103080:	68 80 26 11 80       	push   $0x80112680
80103085:	e8 26 18 00 00       	call   801048b0 <acquire>
    log.committing = 0;
    wakeup(&log);
8010308a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80103091:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80103098:	00 00 00 
    wakeup(&log);
8010309b:	e8 50 14 00 00       	call   801044f0 <wakeup>
    release(&log.lock);
801030a0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801030a7:	e8 24 19 00 00       	call   801049d0 <release>
801030ac:	83 c4 10             	add    $0x10,%esp
  }
}
801030af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030b2:	5b                   	pop    %ebx
801030b3:	5e                   	pop    %esi
801030b4:	5f                   	pop    %edi
801030b5:	5d                   	pop    %ebp
801030b6:	c3                   	ret    
801030b7:	89 f6                	mov    %esi,%esi
801030b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801030c0:	83 ec 0c             	sub    $0xc,%esp
801030c3:	68 80 26 11 80       	push   $0x80112680
801030c8:	e8 23 14 00 00       	call   801044f0 <wakeup>
  }
  release(&log.lock);
801030cd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801030d4:	e8 f7 18 00 00       	call   801049d0 <release>
801030d9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
801030dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030df:	5b                   	pop    %ebx
801030e0:	5e                   	pop    %esi
801030e1:	5f                   	pop    %edi
801030e2:	5d                   	pop    %ebp
801030e3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
801030e4:	83 ec 0c             	sub    $0xc,%esp
801030e7:	68 c4 79 10 80       	push   $0x801079c4
801030ec:	e8 7f d2 ff ff       	call   80100370 <panic>
801030f1:	eb 0d                	jmp    80103100 <log_write>
801030f3:	90                   	nop
801030f4:	90                   	nop
801030f5:	90                   	nop
801030f6:	90                   	nop
801030f7:	90                   	nop
801030f8:	90                   	nop
801030f9:	90                   	nop
801030fa:	90                   	nop
801030fb:	90                   	nop
801030fc:	90                   	nop
801030fd:	90                   	nop
801030fe:	90                   	nop
801030ff:	90                   	nop

80103100 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	53                   	push   %ebx
80103104:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103107:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010310d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103110:	83 fa 1d             	cmp    $0x1d,%edx
80103113:	0f 8f 97 00 00 00    	jg     801031b0 <log_write+0xb0>
80103119:	a1 b8 26 11 80       	mov    0x801126b8,%eax
8010311e:	83 e8 01             	sub    $0x1,%eax
80103121:	39 c2                	cmp    %eax,%edx
80103123:	0f 8d 87 00 00 00    	jge    801031b0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103129:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010312e:	85 c0                	test   %eax,%eax
80103130:	0f 8e 87 00 00 00    	jle    801031bd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103136:	83 ec 0c             	sub    $0xc,%esp
80103139:	68 80 26 11 80       	push   $0x80112680
8010313e:	e8 6d 17 00 00       	call   801048b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103143:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80103149:	83 c4 10             	add    $0x10,%esp
8010314c:	83 fa 00             	cmp    $0x0,%edx
8010314f:	7e 50                	jle    801031a1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103151:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103154:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103156:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
8010315c:	75 0b                	jne    80103169 <log_write+0x69>
8010315e:	eb 38                	jmp    80103198 <log_write+0x98>
80103160:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80103167:	74 2f                	je     80103198 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103169:	83 c0 01             	add    $0x1,%eax
8010316c:	39 d0                	cmp    %edx,%eax
8010316e:	75 f0                	jne    80103160 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103170:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103177:	83 c2 01             	add    $0x1,%edx
8010317a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80103180:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103183:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
8010318a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010318d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010318e:	e9 3d 18 00 00       	jmp    801049d0 <release>
80103193:	90                   	nop
80103194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103198:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
8010319f:	eb df                	jmp    80103180 <log_write+0x80>
801031a1:	8b 43 08             	mov    0x8(%ebx),%eax
801031a4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
801031a9:	75 d5                	jne    80103180 <log_write+0x80>
801031ab:	eb ca                	jmp    80103177 <log_write+0x77>
801031ad:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
801031b0:	83 ec 0c             	sub    $0xc,%esp
801031b3:	68 d3 79 10 80       	push   $0x801079d3
801031b8:	e8 b3 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
801031bd:	83 ec 0c             	sub    $0xc,%esp
801031c0:	68 e9 79 10 80       	push   $0x801079e9
801031c5:	e8 a6 d1 ff ff       	call   80100370 <panic>
801031ca:	66 90                	xchg   %ax,%ax
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <mpmain>:
  mpmain();
}

// Common CPU setup code.
static void
mpmain(void) {
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	53                   	push   %ebx
801031d4:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031d7:	e8 b4 09 00 00       	call   80103b90 <cpuid>
801031dc:	89 c3                	mov    %eax,%ebx
801031de:	e8 ad 09 00 00       	call   80103b90 <cpuid>
801031e3:	83 ec 04             	sub    $0x4,%esp
801031e6:	53                   	push   %ebx
801031e7:	50                   	push   %eax
801031e8:	68 04 7a 10 80       	push   $0x80107a04
801031ed:	e8 6e d4 ff ff       	call   80100660 <cprintf>
    idtinit();       // load idt register
801031f2:	e8 09 2b 00 00       	call   80105d00 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031f7:	e8 14 09 00 00       	call   80103b10 <mycpu>
801031fc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031fe:	b8 01 00 00 00       	mov    $0x1,%eax
80103203:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
8010320a:	e8 b1 0d 00 00       	call   80103fc0 <scheduler>
8010320f:	90                   	nop

80103210 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103216:	e8 05 3c 00 00       	call   80106e20 <switchkvm>
  seginit();
8010321b:	e8 00 3b 00 00       	call   80106d20 <seginit>
  lapicinit();
80103220:	e8 9b f7 ff ff       	call   801029c0 <lapicinit>
  mpmain();
80103225:	e8 a6 ff ff ff       	call   801031d0 <mpmain>
8010322a:	66 90                	xchg   %ax,%ax
8010322c:	66 90                	xchg   %ax,%ax
8010322e:	66 90                	xchg   %ax,%ax

80103230 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103230:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103234:	83 e4 f0             	and    $0xfffffff0,%esp
80103237:	ff 71 fc             	pushl  -0x4(%ecx)
8010323a:	55                   	push   %ebp
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	53                   	push   %ebx
8010323e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010323f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103244:	83 ec 08             	sub    $0x8,%esp
80103247:	68 00 00 40 80       	push   $0x80400000
8010324c:	68 a8 e8 11 80       	push   $0x8011e8a8
80103251:	e8 3a f5 ff ff       	call   80102790 <kinit1>
  kvmalloc();      // kernel page table
80103256:	e8 65 40 00 00       	call   801072c0 <kvmalloc>
  mpinit();        // detect other processors
8010325b:	e8 70 01 00 00       	call   801033d0 <mpinit>
  lapicinit();     // interrupt controller
80103260:	e8 5b f7 ff ff       	call   801029c0 <lapicinit>
  seginit();       // segment descriptors
80103265:	e8 b6 3a 00 00       	call   80106d20 <seginit>
  picinit();       // disable pic
8010326a:	e8 31 03 00 00       	call   801035a0 <picinit>
  ioapicinit();    // another interrupt controller
8010326f:	e8 4c f3 ff ff       	call   801025c0 <ioapicinit>
  consoleinit();   // console hardware
80103274:	e8 27 d7 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103279:	e8 72 2d 00 00       	call   80105ff0 <uartinit>
  pinit();         // process table
8010327e:	e8 6d 08 00 00       	call   80103af0 <pinit>
  tvinit();        // trap vectors
80103283:	e8 d8 29 00 00       	call   80105c60 <tvinit>
  binit();         // buffer cache
80103288:	e8 b3 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010328d:	e8 ee da ff ff       	call   80100d80 <fileinit>
  ideinit();       // disk 
80103292:	e8 09 f1 ff ff       	call   801023a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103297:	83 c4 0c             	add    $0xc,%esp
8010329a:	68 8a 00 00 00       	push   $0x8a
8010329f:	68 8c a4 10 80       	push   $0x8010a48c
801032a4:	68 00 70 00 80       	push   $0x80007000
801032a9:	e8 22 18 00 00       	call   80104ad0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032ae:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801032b5:	00 00 00 
801032b8:	83 c4 10             	add    $0x10,%esp
801032bb:	05 80 27 11 80       	add    $0x80112780,%eax
801032c0:	39 d8                	cmp    %ebx,%eax
801032c2:	76 6f                	jbe    80103333 <main+0x103>
801032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801032c8:	e8 43 08 00 00       	call   80103b10 <mycpu>
801032cd:	39 d8                	cmp    %ebx,%eax
801032cf:	74 49                	je     8010331a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032d1:	e8 8a f5 ff ff       	call   80102860 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032d6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801032db:	c7 05 f8 6f 00 80 10 	movl   $0x80103210,0x80006ff8
801032e2:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032e5:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801032ec:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ef:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032f4:	0f b6 03             	movzbl (%ebx),%eax
801032f7:	83 ec 08             	sub    $0x8,%esp
801032fa:	68 00 70 00 00       	push   $0x7000
801032ff:	50                   	push   %eax
80103300:	e8 0b f8 ff ff       	call   80102b10 <lapicstartap>
80103305:	83 c4 10             	add    $0x10,%esp
80103308:	90                   	nop
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103310:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103316:	85 c0                	test   %eax,%eax
80103318:	74 f6                	je     80103310 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010331a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103321:	00 00 00 
80103324:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010332a:	05 80 27 11 80       	add    $0x80112780,%eax
8010332f:	39 c3                	cmp    %eax,%ebx
80103331:	72 95                	jb     801032c8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103333:	83 ec 08             	sub    $0x8,%esp
80103336:	68 00 00 00 8e       	push   $0x8e000000
8010333b:	68 00 00 40 80       	push   $0x80400000
80103340:	e8 bb f4 ff ff       	call   80102800 <kinit2>
  userinit();      // first user process
80103345:	e8 96 08 00 00       	call   80103be0 <userinit>
  mpmain();        // finish this processor's setup
8010334a:	e8 81 fe ff ff       	call   801031d0 <mpmain>
8010334f:	90                   	nop

80103350 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103355:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010335b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010335c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010335f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103362:	39 de                	cmp    %ebx,%esi
80103364:	73 48                	jae    801033ae <mpsearch1+0x5e>
80103366:	8d 76 00             	lea    0x0(%esi),%esi
80103369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103370:	83 ec 04             	sub    $0x4,%esp
80103373:	8d 7e 10             	lea    0x10(%esi),%edi
80103376:	6a 04                	push   $0x4
80103378:	68 18 7a 10 80       	push   $0x80107a18
8010337d:	56                   	push   %esi
8010337e:	e8 ed 16 00 00       	call   80104a70 <memcmp>
80103383:	83 c4 10             	add    $0x10,%esp
80103386:	85 c0                	test   %eax,%eax
80103388:	75 1e                	jne    801033a8 <mpsearch1+0x58>
8010338a:	8d 7e 10             	lea    0x10(%esi),%edi
8010338d:	89 f2                	mov    %esi,%edx
8010338f:	31 c9                	xor    %ecx,%ecx
80103391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103398:	0f b6 02             	movzbl (%edx),%eax
8010339b:	83 c2 01             	add    $0x1,%edx
8010339e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801033a0:	39 fa                	cmp    %edi,%edx
801033a2:	75 f4                	jne    80103398 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033a4:	84 c9                	test   %cl,%cl
801033a6:	74 10                	je     801033b8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801033a8:	39 fb                	cmp    %edi,%ebx
801033aa:	89 fe                	mov    %edi,%esi
801033ac:	77 c2                	ja     80103370 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
801033ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801033b1:	31 c0                	xor    %eax,%eax
}
801033b3:	5b                   	pop    %ebx
801033b4:	5e                   	pop    %esi
801033b5:	5f                   	pop    %edi
801033b6:	5d                   	pop    %ebp
801033b7:	c3                   	ret    
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033bb:	89 f0                	mov    %esi,%eax
801033bd:	5b                   	pop    %ebx
801033be:	5e                   	pop    %esi
801033bf:	5f                   	pop    %edi
801033c0:	5d                   	pop    %ebp
801033c1:	c3                   	ret    
801033c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	57                   	push   %edi
801033d4:	56                   	push   %esi
801033d5:	53                   	push   %ebx
801033d6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033e7:	c1 e0 08             	shl    $0x8,%eax
801033ea:	09 d0                	or     %edx,%eax
801033ec:	c1 e0 04             	shl    $0x4,%eax
801033ef:	85 c0                	test   %eax,%eax
801033f1:	75 1b                	jne    8010340e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801033f3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033fa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103401:	c1 e0 08             	shl    $0x8,%eax
80103404:	09 d0                	or     %edx,%eax
80103406:	c1 e0 0a             	shl    $0xa,%eax
80103409:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010340e:	ba 00 04 00 00       	mov    $0x400,%edx
80103413:	e8 38 ff ff ff       	call   80103350 <mpsearch1>
80103418:	85 c0                	test   %eax,%eax
8010341a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010341d:	0f 84 37 01 00 00    	je     8010355a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103426:	8b 58 04             	mov    0x4(%eax),%ebx
80103429:	85 db                	test   %ebx,%ebx
8010342b:	0f 84 43 01 00 00    	je     80103574 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103431:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103437:	83 ec 04             	sub    $0x4,%esp
8010343a:	6a 04                	push   $0x4
8010343c:	68 1d 7a 10 80       	push   $0x80107a1d
80103441:	56                   	push   %esi
80103442:	e8 29 16 00 00       	call   80104a70 <memcmp>
80103447:	83 c4 10             	add    $0x10,%esp
8010344a:	85 c0                	test   %eax,%eax
8010344c:	0f 85 22 01 00 00    	jne    80103574 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103452:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103459:	3c 01                	cmp    $0x1,%al
8010345b:	74 08                	je     80103465 <mpinit+0x95>
8010345d:	3c 04                	cmp    $0x4,%al
8010345f:	0f 85 0f 01 00 00    	jne    80103574 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103465:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010346c:	85 ff                	test   %edi,%edi
8010346e:	74 21                	je     80103491 <mpinit+0xc1>
80103470:	31 d2                	xor    %edx,%edx
80103472:	31 c0                	xor    %eax,%eax
80103474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103478:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010347f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103480:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103483:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103485:	39 c7                	cmp    %eax,%edi
80103487:	75 ef                	jne    80103478 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103489:	84 d2                	test   %dl,%dl
8010348b:	0f 85 e3 00 00 00    	jne    80103574 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103491:	85 f6                	test   %esi,%esi
80103493:	0f 84 db 00 00 00    	je     80103574 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103499:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010349f:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034a4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801034ab:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801034b1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034b6:	01 d6                	add    %edx,%esi
801034b8:	90                   	nop
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034c0:	39 c6                	cmp    %eax,%esi
801034c2:	76 23                	jbe    801034e7 <mpinit+0x117>
801034c4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801034c7:	80 fa 04             	cmp    $0x4,%dl
801034ca:	0f 87 c0 00 00 00    	ja     80103590 <mpinit+0x1c0>
801034d0:	ff 24 95 5c 7a 10 80 	jmp    *-0x7fef85a4(,%edx,4)
801034d7:	89 f6                	mov    %esi,%esi
801034d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034e0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034e3:	39 c6                	cmp    %eax,%esi
801034e5:	77 dd                	ja     801034c4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034e7:	85 db                	test   %ebx,%ebx
801034e9:	0f 84 92 00 00 00    	je     80103581 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034f2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801034f6:	74 15                	je     8010350d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034f8:	ba 22 00 00 00       	mov    $0x22,%edx
801034fd:	b8 70 00 00 00       	mov    $0x70,%eax
80103502:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103503:	ba 23 00 00 00       	mov    $0x23,%edx
80103508:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103509:	83 c8 01             	or     $0x1,%eax
8010350c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010350d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103510:	5b                   	pop    %ebx
80103511:	5e                   	pop    %esi
80103512:	5f                   	pop    %edi
80103513:	5d                   	pop    %ebp
80103514:	c3                   	ret    
80103515:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103518:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010351e:	83 f9 07             	cmp    $0x7,%ecx
80103521:	7f 19                	jg     8010353c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103523:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103527:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010352d:	83 c1 01             	add    $0x1,%ecx
80103530:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103536:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010353c:	83 c0 14             	add    $0x14,%eax
      continue;
8010353f:	e9 7c ff ff ff       	jmp    801034c0 <mpinit+0xf0>
80103544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103548:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010354c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010354f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103555:	e9 66 ff ff ff       	jmp    801034c0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010355a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010355f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103564:	e8 e7 fd ff ff       	call   80103350 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103569:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010356b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010356e:	0f 85 af fe ff ff    	jne    80103423 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103574:	83 ec 0c             	sub    $0xc,%esp
80103577:	68 22 7a 10 80       	push   $0x80107a22
8010357c:	e8 ef cd ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103581:	83 ec 0c             	sub    $0xc,%esp
80103584:	68 3c 7a 10 80       	push   $0x80107a3c
80103589:	e8 e2 cd ff ff       	call   80100370 <panic>
8010358e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103590:	31 db                	xor    %ebx,%ebx
80103592:	e9 30 ff ff ff       	jmp    801034c7 <mpinit+0xf7>
80103597:	66 90                	xchg   %ax,%ax
80103599:	66 90                	xchg   %ax,%ax
8010359b:	66 90                	xchg   %ax,%ax
8010359d:	66 90                	xchg   %ax,%ax
8010359f:	90                   	nop

801035a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035a0:	55                   	push   %ebp
801035a1:	ba 21 00 00 00       	mov    $0x21,%edx
801035a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035ab:	89 e5                	mov    %esp,%ebp
801035ad:	ee                   	out    %al,(%dx)
801035ae:	ba a1 00 00 00       	mov    $0xa1,%edx
801035b3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035b4:	5d                   	pop    %ebp
801035b5:	c3                   	ret    
801035b6:	66 90                	xchg   %ax,%ax
801035b8:	66 90                	xchg   %ax,%ax
801035ba:	66 90                	xchg   %ax,%ax
801035bc:	66 90                	xchg   %ax,%ax
801035be:	66 90                	xchg   %ax,%ax

801035c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
801035c5:	53                   	push   %ebx
801035c6:	83 ec 0c             	sub    $0xc,%esp
801035c9:	8b 75 08             	mov    0x8(%ebp),%esi
801035cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801035d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035db:	e8 c0 d7 ff ff       	call   80100da0 <filealloc>
801035e0:	85 c0                	test   %eax,%eax
801035e2:	89 06                	mov    %eax,(%esi)
801035e4:	0f 84 a8 00 00 00    	je     80103692 <pipealloc+0xd2>
801035ea:	e8 b1 d7 ff ff       	call   80100da0 <filealloc>
801035ef:	85 c0                	test   %eax,%eax
801035f1:	89 03                	mov    %eax,(%ebx)
801035f3:	0f 84 87 00 00 00    	je     80103680 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035f9:	e8 62 f2 ff ff       	call   80102860 <kalloc>
801035fe:	85 c0                	test   %eax,%eax
80103600:	89 c7                	mov    %eax,%edi
80103602:	0f 84 b0 00 00 00    	je     801036b8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103608:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010360b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103612:	00 00 00 
  p->writeopen = 1;
80103615:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010361c:	00 00 00 
  p->nwrite = 0;
8010361f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103626:	00 00 00 
  p->nread = 0;
80103629:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103630:	00 00 00 
  initlock(&p->lock, "pipe");
80103633:	68 70 7a 10 80       	push   $0x80107a70
80103638:	50                   	push   %eax
80103639:	e8 72 11 00 00       	call   801047b0 <initlock>
  (*f0)->type = FD_PIPE;
8010363e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103640:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103643:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103649:	8b 06                	mov    (%esi),%eax
8010364b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010364f:	8b 06                	mov    (%esi),%eax
80103651:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103655:	8b 06                	mov    (%esi),%eax
80103657:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010365a:	8b 03                	mov    (%ebx),%eax
8010365c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103662:	8b 03                	mov    (%ebx),%eax
80103664:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103668:	8b 03                	mov    (%ebx),%eax
8010366a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010366e:	8b 03                	mov    (%ebx),%eax
80103670:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103673:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103676:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103678:	5b                   	pop    %ebx
80103679:	5e                   	pop    %esi
8010367a:	5f                   	pop    %edi
8010367b:	5d                   	pop    %ebp
8010367c:	c3                   	ret    
8010367d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103680:	8b 06                	mov    (%esi),%eax
80103682:	85 c0                	test   %eax,%eax
80103684:	74 1e                	je     801036a4 <pipealloc+0xe4>
    fileclose(*f0);
80103686:	83 ec 0c             	sub    $0xc,%esp
80103689:	50                   	push   %eax
8010368a:	e8 d1 d7 ff ff       	call   80100e60 <fileclose>
8010368f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103692:	8b 03                	mov    (%ebx),%eax
80103694:	85 c0                	test   %eax,%eax
80103696:	74 0c                	je     801036a4 <pipealloc+0xe4>
    fileclose(*f1);
80103698:	83 ec 0c             	sub    $0xc,%esp
8010369b:	50                   	push   %eax
8010369c:	e8 bf d7 ff ff       	call   80100e60 <fileclose>
801036a1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801036a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801036a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036ac:	5b                   	pop    %ebx
801036ad:	5e                   	pop    %esi
801036ae:	5f                   	pop    %edi
801036af:	5d                   	pop    %ebp
801036b0:	c3                   	ret    
801036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036b8:	8b 06                	mov    (%esi),%eax
801036ba:	85 c0                	test   %eax,%eax
801036bc:	75 c8                	jne    80103686 <pipealloc+0xc6>
801036be:	eb d2                	jmp    80103692 <pipealloc+0xd2>

801036c0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	56                   	push   %esi
801036c4:	53                   	push   %ebx
801036c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036cb:	83 ec 0c             	sub    $0xc,%esp
801036ce:	53                   	push   %ebx
801036cf:	e8 dc 11 00 00       	call   801048b0 <acquire>
  if(writable){
801036d4:	83 c4 10             	add    $0x10,%esp
801036d7:	85 f6                	test   %esi,%esi
801036d9:	74 45                	je     80103720 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801036db:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036e1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801036e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036eb:	00 00 00 
    wakeup(&p->nread);
801036ee:	50                   	push   %eax
801036ef:	e8 fc 0d 00 00       	call   801044f0 <wakeup>
801036f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036fd:	85 d2                	test   %edx,%edx
801036ff:	75 0a                	jne    8010370b <pipeclose+0x4b>
80103701:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103707:	85 c0                	test   %eax,%eax
80103709:	74 35                	je     80103740 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010370b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010370e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103711:	5b                   	pop    %ebx
80103712:	5e                   	pop    %esi
80103713:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103714:	e9 b7 12 00 00       	jmp    801049d0 <release>
80103719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103720:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103726:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103729:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103730:	00 00 00 
    wakeup(&p->nwrite);
80103733:	50                   	push   %eax
80103734:	e8 b7 0d 00 00       	call   801044f0 <wakeup>
80103739:	83 c4 10             	add    $0x10,%esp
8010373c:	eb b9                	jmp    801036f7 <pipeclose+0x37>
8010373e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103740:	83 ec 0c             	sub    $0xc,%esp
80103743:	53                   	push   %ebx
80103744:	e8 87 12 00 00       	call   801049d0 <release>
    kfree((char*)p);
80103749:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010374c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010374f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103752:	5b                   	pop    %ebx
80103753:	5e                   	pop    %esi
80103754:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103755:	e9 56 ef ff ff       	jmp    801026b0 <kfree>
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103760 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	57                   	push   %edi
80103764:	56                   	push   %esi
80103765:	53                   	push   %ebx
80103766:	83 ec 28             	sub    $0x28,%esp
80103769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010376c:	53                   	push   %ebx
8010376d:	e8 3e 11 00 00       	call   801048b0 <acquire>
  for(i = 0; i < n; i++){
80103772:	8b 45 10             	mov    0x10(%ebp),%eax
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	85 c0                	test   %eax,%eax
8010377a:	0f 8e b9 00 00 00    	jle    80103839 <pipewrite+0xd9>
80103780:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103783:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103789:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010378f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103795:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103798:	03 4d 10             	add    0x10(%ebp),%ecx
8010379b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010379e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801037a4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801037aa:	39 d0                	cmp    %edx,%eax
801037ac:	74 38                	je     801037e6 <pipewrite+0x86>
801037ae:	eb 59                	jmp    80103809 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801037b0:	e8 fb 03 00 00       	call   80103bb0 <myproc>
801037b5:	8b 48 24             	mov    0x24(%eax),%ecx
801037b8:	85 c9                	test   %ecx,%ecx
801037ba:	75 34                	jne    801037f0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037bc:	83 ec 0c             	sub    $0xc,%esp
801037bf:	57                   	push   %edi
801037c0:	e8 2b 0d 00 00       	call   801044f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037c5:	58                   	pop    %eax
801037c6:	5a                   	pop    %edx
801037c7:	53                   	push   %ebx
801037c8:	56                   	push   %esi
801037c9:	e8 12 0b 00 00       	call   801042e0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037ce:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037d4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037da:	83 c4 10             	add    $0x10,%esp
801037dd:	05 00 02 00 00       	add    $0x200,%eax
801037e2:	39 c2                	cmp    %eax,%edx
801037e4:	75 2a                	jne    80103810 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801037e6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037ec:	85 c0                	test   %eax,%eax
801037ee:	75 c0                	jne    801037b0 <pipewrite+0x50>
        release(&p->lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
801037f3:	53                   	push   %ebx
801037f4:	e8 d7 11 00 00       	call   801049d0 <release>
        return -1;
801037f9:	83 c4 10             	add    $0x10,%esp
801037fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103804:	5b                   	pop    %ebx
80103805:	5e                   	pop    %esi
80103806:	5f                   	pop    %edi
80103807:	5d                   	pop    %ebp
80103808:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103809:	89 c2                	mov    %eax,%edx
8010380b:	90                   	nop
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103810:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103813:	8d 42 01             	lea    0x1(%edx),%eax
80103816:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010381a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103820:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103826:	0f b6 09             	movzbl (%ecx),%ecx
80103829:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010382d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103830:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103833:	0f 85 65 ff ff ff    	jne    8010379e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103839:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010383f:	83 ec 0c             	sub    $0xc,%esp
80103842:	50                   	push   %eax
80103843:	e8 a8 0c 00 00       	call   801044f0 <wakeup>
  release(&p->lock);
80103848:	89 1c 24             	mov    %ebx,(%esp)
8010384b:	e8 80 11 00 00       	call   801049d0 <release>
  return n;
80103850:	83 c4 10             	add    $0x10,%esp
80103853:	8b 45 10             	mov    0x10(%ebp),%eax
80103856:	eb a9                	jmp    80103801 <pipewrite+0xa1>
80103858:	90                   	nop
80103859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103860 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	57                   	push   %edi
80103864:	56                   	push   %esi
80103865:	53                   	push   %ebx
80103866:	83 ec 18             	sub    $0x18,%esp
80103869:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010386c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010386f:	53                   	push   %ebx
80103870:	e8 3b 10 00 00       	call   801048b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103875:	83 c4 10             	add    $0x10,%esp
80103878:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010387e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103884:	75 6a                	jne    801038f0 <piperead+0x90>
80103886:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010388c:	85 f6                	test   %esi,%esi
8010388e:	0f 84 cc 00 00 00    	je     80103960 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103894:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010389a:	eb 2d                	jmp    801038c9 <piperead+0x69>
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038a0:	83 ec 08             	sub    $0x8,%esp
801038a3:	53                   	push   %ebx
801038a4:	56                   	push   %esi
801038a5:	e8 36 0a 00 00       	call   801042e0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038aa:	83 c4 10             	add    $0x10,%esp
801038ad:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801038b3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801038b9:	75 35                	jne    801038f0 <piperead+0x90>
801038bb:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801038c1:	85 d2                	test   %edx,%edx
801038c3:	0f 84 97 00 00 00    	je     80103960 <piperead+0x100>
    if(myproc()->killed){
801038c9:	e8 e2 02 00 00       	call   80103bb0 <myproc>
801038ce:	8b 48 24             	mov    0x24(%eax),%ecx
801038d1:	85 c9                	test   %ecx,%ecx
801038d3:	74 cb                	je     801038a0 <piperead+0x40>
      release(&p->lock);
801038d5:	83 ec 0c             	sub    $0xc,%esp
801038d8:	53                   	push   %ebx
801038d9:	e8 f2 10 00 00       	call   801049d0 <release>
      return -1;
801038de:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038e1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801038e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038e9:	5b                   	pop    %ebx
801038ea:	5e                   	pop    %esi
801038eb:	5f                   	pop    %edi
801038ec:	5d                   	pop    %ebp
801038ed:	c3                   	ret    
801038ee:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038f0:	8b 45 10             	mov    0x10(%ebp),%eax
801038f3:	85 c0                	test   %eax,%eax
801038f5:	7e 69                	jle    80103960 <piperead+0x100>
    if(p->nread == p->nwrite)
801038f7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038fd:	31 c9                	xor    %ecx,%ecx
801038ff:	eb 15                	jmp    80103916 <piperead+0xb6>
80103901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103908:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010390e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103914:	74 5a                	je     80103970 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103916:	8d 70 01             	lea    0x1(%eax),%esi
80103919:	25 ff 01 00 00       	and    $0x1ff,%eax
8010391e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103924:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103929:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010392c:	83 c1 01             	add    $0x1,%ecx
8010392f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103932:	75 d4                	jne    80103908 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103934:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010393a:	83 ec 0c             	sub    $0xc,%esp
8010393d:	50                   	push   %eax
8010393e:	e8 ad 0b 00 00       	call   801044f0 <wakeup>
  release(&p->lock);
80103943:	89 1c 24             	mov    %ebx,(%esp)
80103946:	e8 85 10 00 00       	call   801049d0 <release>
  return i;
8010394b:	8b 45 10             	mov    0x10(%ebp),%eax
8010394e:	83 c4 10             	add    $0x10,%esp
}
80103951:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103954:	5b                   	pop    %ebx
80103955:	5e                   	pop    %esi
80103956:	5f                   	pop    %edi
80103957:	5d                   	pop    %ebp
80103958:	c3                   	ret    
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103960:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103967:	eb cb                	jmp    80103934 <piperead+0xd4>
80103969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103970:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103973:	eb bf                	jmp    80103934 <piperead+0xd4>
80103975:	66 90                	xchg   %ax,%ax
80103977:	66 90                	xchg   %ax,%ax
80103979:	66 90                	xchg   %ax,%ax
8010397b:	66 90                	xchg   %ax,%ax
8010397d:	66 90                	xchg   %ax,%ax
8010397f:	90                   	nop

80103980 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
    struct page *pg;
    char *sp;

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103984:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void) {
80103989:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    struct page *pg;
    char *sp;

    acquire(&ptable.lock);
8010398c:	68 20 3d 11 80       	push   $0x80113d20
80103991:	e8 1a 0f 00 00       	call   801048b0 <acquire>
80103996:	83 c4 10             	add    $0x10,%esp
80103999:	eb 17                	jmp    801039b2 <allocproc+0x32>
8010399b:	90                   	nop
8010399c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a0:	81 c3 8c 02 00 00    	add    $0x28c,%ebx
801039a6:	81 fb 54 e0 11 80    	cmp    $0x8011e054,%ebx
801039ac:	0f 84 ce 00 00 00    	je     80103a80 <allocproc+0x100>
        if (p->state == UNUSED)
801039b2:	8b 43 0c             	mov    0xc(%ebx),%eax
801039b5:	85 c0                	test   %eax,%eax
801039b7:	75 e7                	jne    801039a0 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
801039b9:	a1 04 a0 10 80       	mov    0x8010a004,%eax

    release(&ptable.lock);
801039be:	83 ec 0c             	sub    $0xc,%esp

    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
801039c1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;

    release(&ptable.lock);
801039c8:	68 20 3d 11 80       	push   $0x80113d20
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
801039cd:	8d 50 01             	lea    0x1(%eax),%edx
801039d0:	89 43 10             	mov    %eax,0x10(%ebx)
801039d3:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

    release(&ptable.lock);
801039d9:	e8 f2 0f 00 00       	call   801049d0 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
801039de:	e8 7d ee ff ff       	call   80102860 <kalloc>
801039e3:	83 c4 10             	add    $0x10,%esp
801039e6:	85 c0                	test   %eax,%eax
801039e8:	89 43 08             	mov    %eax,0x8(%ebx)
801039eb:	0f 84 a6 00 00 00    	je     80103a97 <allocproc+0x117>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
801039f1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
801039f7:	83 ec 04             	sub    $0x4,%esp
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
801039fa:	05 9c 0f 00 00       	add    $0xf9c,%eax
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
801039ff:	89 53 18             	mov    %edx,0x18(%ebx)
    p->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;
80103a02:	c7 40 14 52 5c 10 80 	movl   $0x80105c52,0x14(%eax)

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
80103a09:	6a 14                	push   $0x14
80103a0b:	6a 00                	push   $0x0
80103a0d:	50                   	push   %eax
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
80103a0e:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103a11:	e8 0a 10 00 00       	call   80104a20 <memset>
    p->context->eip = (uint) forkret;
80103a16:	8b 43 1c             	mov    0x1c(%ebx),%eax
    //TODO INIT PROC PAGES FIELDS
    p->pagesCounter = 0;
    p->nextpageid = 1;
    p->swapOffset = 0;

    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103a19:	8d 93 84 02 00 00    	lea    0x284(%ebx),%edx
80103a1f:	83 c4 10             	add    $0x10,%esp
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint) forkret;
80103a22:	c7 40 10 a0 3a 10 80 	movl   $0x80103aa0,0x10(%eax)
    //TODO INIT PROC PAGES FIELDS
    p->pagesCounter = 0;
    p->nextpageid = 1;
    p->swapOffset = 0;

    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103a29:	8d 83 84 00 00 00    	lea    0x84(%ebx),%eax
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint) forkret;

    //TODO INIT PROC PAGES FIELDS
    p->pagesCounter = 0;
80103a2f:	c7 83 88 02 00 00 00 	movl   $0x0,0x288(%ebx)
80103a36:	00 00 00 
    p->nextpageid = 1;
80103a39:	c7 83 84 02 00 00 01 	movl   $0x1,0x284(%ebx)
80103a40:	00 00 00 
    p->swapOffset = 0;
80103a43:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103a4a:	00 00 00 
80103a4d:	8d 76 00             	lea    0x0(%esi),%esi

    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
    {
        pg->offset = 0;
80103a50:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        pg->pageid = 0;
80103a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    //TODO INIT PROC PAGES FIELDS
    p->pagesCounter = 0;
    p->nextpageid = 1;
    p->swapOffset = 0;

    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103a5d:	83 c0 10             	add    $0x10,%eax
    {
        pg->offset = 0;
        pg->pageid = 0;
        pg->present = 0;
80103a60:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        pg->sequel = 0;
80103a67:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
    //TODO INIT PROC PAGES FIELDS
    p->pagesCounter = 0;
    p->nextpageid = 1;
    p->swapOffset = 0;

    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103a6e:	39 d0                	cmp    %edx,%eax
80103a70:	72 de                	jb     80103a50 <allocproc+0xd0>
80103a72:	89 d8                	mov    %ebx,%eax
        pg->sequel = 0;
    }


    return p;
}
80103a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a77:	c9                   	leave  
80103a78:	c3                   	ret    
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED)
            goto found;

    release(&ptable.lock);
80103a80:	83 ec 0c             	sub    $0xc,%esp
80103a83:	68 20 3d 11 80       	push   $0x80113d20
80103a88:	e8 43 0f 00 00       	call   801049d0 <release>
    return 0;
80103a8d:	83 c4 10             	add    $0x10,%esp
80103a90:	31 c0                	xor    %eax,%eax
        pg->sequel = 0;
    }


    return p;
}
80103a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a95:	c9                   	leave  
80103a96:	c3                   	ret    

    release(&ptable.lock);

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
        p->state = UNUSED;
80103a97:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103a9e:	eb d4                	jmp    80103a74 <allocproc+0xf4>

80103aa0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103aa6:	68 20 3d 11 80       	push   $0x80113d20
80103aab:	e8 20 0f 00 00       	call   801049d0 <release>

    if (first) {
80103ab0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103ab5:	83 c4 10             	add    $0x10,%esp
80103ab8:	85 c0                	test   %eax,%eax
80103aba:	75 04                	jne    80103ac0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103abc:	c9                   	leave  
80103abd:	c3                   	ret    
80103abe:	66 90                	xchg   %ax,%ax
    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
80103ac0:	83 ec 0c             	sub    $0xc,%esp

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
80103ac3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103aca:	00 00 00 
        iinit(ROOTDEV);
80103acd:	6a 01                	push   $0x1
80103acf:	e8 cc d9 ff ff       	call   801014a0 <iinit>
        initlog(ROOTDEV);
80103ad4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103adb:	e8 a0 f3 ff ff       	call   80102e80 <initlog>
80103ae0:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103ae3:	c9                   	leave  
80103ae4:	c3                   	ret    
80103ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103af0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103af6:	68 75 7a 10 80       	push   $0x80107a75
80103afb:	68 20 3d 11 80       	push   $0x80113d20
80103b00:	e8 ab 0c 00 00       	call   801047b0 <initlock>
}
80103b05:	83 c4 10             	add    $0x10,%esp
80103b08:	c9                   	leave  
80103b09:	c3                   	ret    
80103b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b10 <mycpu>:
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void) {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	56                   	push   %esi
80103b14:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b15:	9c                   	pushf  
80103b16:	58                   	pop    %eax
    int apicid, i;

    if (readeflags() & FL_IF)
80103b17:	f6 c4 02             	test   $0x2,%ah
80103b1a:	75 5b                	jne    80103b77 <mycpu+0x67>
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
80103b1c:	e8 9f ef ff ff       	call   80102ac0 <lapicid>
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103b21:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103b27:	85 f6                	test   %esi,%esi
80103b29:	7e 3f                	jle    80103b6a <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
80103b2b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103b32:	39 d0                	cmp    %edx,%eax
80103b34:	74 30                	je     80103b66 <mycpu+0x56>
80103b36:	b9 30 28 11 80       	mov    $0x80112830,%ecx
80103b3b:	31 d2                	xor    %edx,%edx
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103b40:	83 c2 01             	add    $0x1,%edx
80103b43:	39 f2                	cmp    %esi,%edx
80103b45:	74 23                	je     80103b6a <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
80103b47:	0f b6 19             	movzbl (%ecx),%ebx
80103b4a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b50:	39 d8                	cmp    %ebx,%eax
80103b52:	75 ec                	jne    80103b40 <mycpu+0x30>
            return &cpus[i];
80103b54:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
    }
    panic("unknown apicid\n");
}
80103b5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b5d:	5b                   	pop    %ebx
    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
            return &cpus[i];
80103b5e:	05 80 27 11 80       	add    $0x80112780,%eax
    }
    panic("unknown apicid\n");
}
80103b63:	5e                   	pop    %esi
80103b64:	5d                   	pop    %ebp
80103b65:	c3                   	ret    
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103b66:	31 d2                	xor    %edx,%edx
80103b68:	eb ea                	jmp    80103b54 <mycpu+0x44>
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
80103b6a:	83 ec 0c             	sub    $0xc,%esp
80103b6d:	68 7c 7a 10 80       	push   $0x80107a7c
80103b72:	e8 f9 c7 ff ff       	call   80100370 <panic>
struct cpu*
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
        panic("mycpu called with interrupts enabled\n");
80103b77:	83 ec 0c             	sub    $0xc,%esp
80103b7a:	68 58 7b 10 80       	push   $0x80107b58
80103b7f:	e8 ec c7 ff ff       	call   80100370 <panic>
80103b84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b90 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b96:	e8 75 ff ff ff       	call   80103b10 <mycpu>
80103b9b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103ba0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103ba1:	c1 f8 04             	sar    $0x4,%eax
80103ba4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103baa:	c3                   	ret    
80103bab:	90                   	nop
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bb0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	53                   	push   %ebx
80103bb4:	83 ec 04             	sub    $0x4,%esp
    struct cpu *c;
    struct proc *p;
    pushcli();
80103bb7:	e8 b4 0c 00 00       	call   80104870 <pushcli>
    c = mycpu();
80103bbc:	e8 4f ff ff ff       	call   80103b10 <mycpu>
    p = c->proc;
80103bc1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103bc7:	e8 94 0d 00 00       	call   80104960 <popcli>
    return p;
}
80103bcc:	83 c4 04             	add    $0x4,%esp
80103bcf:	89 d8                	mov    %ebx,%eax
80103bd1:	5b                   	pop    %ebx
80103bd2:	5d                   	pop    %ebp
80103bd3:	c3                   	ret    
80103bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103be0 <userinit>:
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	53                   	push   %ebx
80103be4:	83 ec 04             	sub    $0x4,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
80103be7:	e8 94 fd ff ff       	call   80103980 <allocproc>
80103bec:	89 c3                	mov    %eax,%ebx

    initproc = p;
80103bee:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
    if ((p->pgdir = setupkvm()) == 0)
80103bf3:	e8 48 36 00 00       	call   80107240 <setupkvm>
80103bf8:	85 c0                	test   %eax,%eax
80103bfa:	89 43 04             	mov    %eax,0x4(%ebx)
80103bfd:	0f 84 bd 00 00 00    	je     80103cc0 <userinit+0xe0>
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103c03:	83 ec 04             	sub    $0x4,%esp
80103c06:	68 2c 00 00 00       	push   $0x2c
80103c0b:	68 60 a4 10 80       	push   $0x8010a460
80103c10:	50                   	push   %eax
80103c11:	e8 3a 33 00 00       	call   80106f50 <inituvm>
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
80103c16:	83 c4 0c             	add    $0xc,%esp

    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
80103c19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103c1f:	6a 4c                	push   $0x4c
80103c21:	6a 00                	push   $0x0
80103c23:	ff 73 18             	pushl  0x18(%ebx)
80103c26:	e8 f5 0d 00 00       	call   80104a20 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c33:	b9 23 00 00 00       	mov    $0x23,%ecx
    p->tf->ss = p->tf->ds;
    p->tf->eflags = FL_IF;
    p->tf->esp = PGSIZE;
    p->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
80103c38:	83 c4 0c             	add    $0xc,%esp
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103c46:	8b 43 18             	mov    0x18(%ebx),%eax
80103c49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c4d:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103c51:	8b 43 18             	mov    0x18(%ebx),%eax
80103c54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c58:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103c5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103c66:	8b 43 18             	mov    0x18(%ebx),%eax
80103c69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103c70:	8b 43 18             	mov    0x18(%ebx),%eax
80103c73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
80103c7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c7d:	6a 10                	push   $0x10
80103c7f:	68 a5 7a 10 80       	push   $0x80107aa5
80103c84:	50                   	push   %eax
80103c85:	e8 96 0f 00 00       	call   80104c20 <safestrcpy>
    p->cwd = namei("/");
80103c8a:	c7 04 24 ae 7a 10 80 	movl   $0x80107aae,(%esp)
80103c91:	e8 5a e2 ff ff       	call   80101ef0 <namei>
80103c96:	89 43 68             	mov    %eax,0x68(%ebx)

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
80103c99:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ca0:	e8 0b 0c 00 00       	call   801048b0 <acquire>

    p->state = RUNNABLE;
80103ca5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

    release(&ptable.lock);
80103cac:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cb3:	e8 18 0d 00 00       	call   801049d0 <release>
}
80103cb8:	83 c4 10             	add    $0x10,%esp
80103cbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cbe:	c9                   	leave  
80103cbf:	c3                   	ret    

    p = allocproc();

    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
80103cc0:	83 ec 0c             	sub    $0xc,%esp
80103cc3:	68 8c 7a 10 80       	push   $0x80107a8c
80103cc8:	e8 a3 c6 ff ff       	call   80100370 <panic>
80103ccd:	8d 76 00             	lea    0x0(%esi),%esi

80103cd0 <growproc>:
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	56                   	push   %esi
80103cd4:	53                   	push   %ebx
80103cd5:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103cd8:	e8 93 0b 00 00       	call   80104870 <pushcli>
    c = mycpu();
80103cdd:	e8 2e fe ff ff       	call   80103b10 <mycpu>
    p = c->proc;
80103ce2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ce8:	e8 73 0c 00 00       	call   80104960 <popcli>
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();

    sz = curproc->sz;
    if (n > 0) {
80103ced:	83 fe 00             	cmp    $0x0,%esi
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();

    sz = curproc->sz;
80103cf0:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103cf2:	7e 34                	jle    80103d28 <growproc+0x58>
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cf4:	83 ec 04             	sub    $0x4,%esp
80103cf7:	01 c6                	add    %eax,%esi
80103cf9:	56                   	push   %esi
80103cfa:	50                   	push   %eax
80103cfb:	ff 73 04             	pushl  0x4(%ebx)
80103cfe:	e8 8d 33 00 00       	call   80107090 <allocuvm>
80103d03:	83 c4 10             	add    $0x10,%esp
80103d06:	85 c0                	test   %eax,%eax
80103d08:	74 36                	je     80103d40 <growproc+0x70>
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    curproc->sz = sz;
    switchuvm(curproc);
80103d0a:	83 ec 0c             	sub    $0xc,%esp
            return -1;
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    curproc->sz = sz;
80103d0d:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103d0f:	53                   	push   %ebx
80103d10:	e8 2b 31 00 00       	call   80106e40 <switchuvm>
    return 0;
80103d15:	83 c4 10             	add    $0x10,%esp
80103d18:	31 c0                	xor    %eax,%eax
}
80103d1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d1d:	5b                   	pop    %ebx
80103d1e:	5e                   	pop    %esi
80103d1f:	5d                   	pop    %ebp
80103d20:	c3                   	ret    
80103d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
80103d28:	74 e0                	je     80103d0a <growproc+0x3a>
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d2a:	83 ec 04             	sub    $0x4,%esp
80103d2d:	01 c6                	add    %eax,%esi
80103d2f:	56                   	push   %esi
80103d30:	50                   	push   %eax
80103d31:	ff 73 04             	pushl  0x4(%ebx)
80103d34:	e8 57 34 00 00       	call   80107190 <deallocuvm>
80103d39:	83 c4 10             	add    $0x10,%esp
80103d3c:	85 c0                	test   %eax,%eax
80103d3e:	75 ca                	jne    80103d0a <growproc+0x3a>
    struct proc *curproc = myproc();

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
80103d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d45:	eb d3                	jmp    80103d1a <growproc+0x4a>
80103d47:	89 f6                	mov    %esi,%esi
80103d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d50 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
80103d55:	53                   	push   %ebx
80103d56:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103d59:	e8 12 0b 00 00       	call   80104870 <pushcli>
    c = mycpu();
80103d5e:	e8 ad fd ff ff       	call   80103b10 <mycpu>
    p = c->proc;
80103d63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103d69:	e8 f2 0b 00 00       	call   80104960 <popcli>
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();
    struct page *pg , *cg;
    // Allocate process.
    if ((np = allocproc()) == 0) {
80103d6e:	e8 0d fc ff ff       	call   80103980 <allocproc>
80103d73:	85 c0                	test   %eax,%eax
80103d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d78:	0f 84 13 02 00 00    	je     80103f91 <fork+0x241>
        return -1;
    }


    if (firstRun) {
80103d7e:	8b 35 08 a0 10 80    	mov    0x8010a008,%esi
80103d84:	85 f6                	test   %esi,%esi
80103d86:	0f 85 f4 01 00 00    	jne    80103f80 <fork+0x230>
        createSwapFile(curproc);
    }


    createSwapFile(np);
80103d8c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103d8f:	83 ec 0c             	sub    $0xc,%esp
80103d92:	56                   	push   %esi
80103d93:	e8 38 e4 ff ff       	call   801021d0 <createSwapFile>

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103d98:	5a                   	pop    %edx
80103d99:	59                   	pop    %ecx
80103d9a:	ff 33                	pushl  (%ebx)
80103d9c:	ff 73 04             	pushl  0x4(%ebx)
80103d9f:	e8 6c 35 00 00       	call   80107310 <copyuvm>
80103da4:	83 c4 10             	add    $0x10,%esp
80103da7:	85 c0                	test   %eax,%eax
80103da9:	89 46 04             	mov    %eax,0x4(%esi)
80103dac:	0f 84 e6 01 00 00    	je     80103f98 <fork+0x248>
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103db2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103db5:	8b 03                	mov    (%ebx),%eax
    np->parent = curproc;
    *np->tf = *curproc->tf;
80103db7:	b9 13 00 00 00       	mov    $0x13,%ecx
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103dbc:	89 02                	mov    %eax,(%edx)
    np->parent = curproc;
80103dbe:	89 5a 14             	mov    %ebx,0x14(%edx)
    *np->tf = *curproc->tf;
80103dc1:	8b 7a 18             	mov    0x18(%edx),%edi
80103dc4:	8b 73 18             	mov    0x18(%ebx),%esi
80103dc7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    np->nextpageid = curproc->nextpageid;
80103dc9:	89 d7                	mov    %edx,%edi
    np->pagesCounter = curproc->pagesCounter;
    np->swapOffset = curproc->swapOffset;


    for( pg = np->pages , cg = curproc->pages;
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103dcb:	8d b7 84 02 00 00    	lea    0x284(%edi),%esi
    }
    np->sz = curproc->sz;
    np->parent = curproc;
    *np->tf = *curproc->tf;

    np->nextpageid = curproc->nextpageid;
80103dd1:	8b 83 84 02 00 00    	mov    0x284(%ebx),%eax
80103dd7:	89 82 84 02 00 00    	mov    %eax,0x284(%edx)
    np->pagesCounter = curproc->pagesCounter;
80103ddd:	8b 83 88 02 00 00    	mov    0x288(%ebx),%eax
80103de3:	89 82 88 02 00 00    	mov    %eax,0x288(%edx)
    np->swapOffset = curproc->swapOffset;
80103de9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103def:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)


    for( pg = np->pages , cg = curproc->pages;
80103df5:	8d 82 84 00 00 00    	lea    0x84(%edx),%eax
80103dfb:	8d 93 84 00 00 00    	lea    0x84(%ebx),%edx
80103e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
    {
        pg->offset = cg->offset;
80103e08:	8b 4a 0c             	mov    0xc(%edx),%ecx
    np->pagesCounter = curproc->pagesCounter;
    np->swapOffset = curproc->swapOffset;


    for( pg = np->pages , cg = curproc->pages;
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103e0b:	83 c0 10             	add    $0x10,%eax
80103e0e:	83 c2 10             	add    $0x10,%edx
    {
        pg->offset = cg->offset;
80103e11:	89 48 fc             	mov    %ecx,-0x4(%eax)
        pg->pageid = cg->pageid;
80103e14:	8b 4a f0             	mov    -0x10(%edx),%ecx
80103e17:	89 48 f0             	mov    %ecx,-0x10(%eax)
        pg->present = cg->present;
80103e1a:	8b 4a f8             	mov    -0x8(%edx),%ecx
80103e1d:	89 48 f8             	mov    %ecx,-0x8(%eax)
        pg->sequel = cg->sequel;
80103e20:	8b 4a f4             	mov    -0xc(%edx),%ecx
80103e23:	89 48 f4             	mov    %ecx,-0xc(%eax)
    np->nextpageid = curproc->nextpageid;
    np->pagesCounter = curproc->pagesCounter;
    np->swapOffset = curproc->swapOffset;


    for( pg = np->pages , cg = curproc->pages;
80103e26:	39 f0                	cmp    %esi,%eax
80103e28:	72 de                	jb     80103e08 <fork+0xb8>
        pg->present = cg->present;
        pg->sequel = cg->sequel;
    }

    //TODO FIRST RUN IN BEFORE SHEL LOADED
    if (!firstRun) {
80103e2a:	a1 08 a0 10 80       	mov    0x8010a008,%eax
80103e2f:	85 c0                	test   %eax,%eax
80103e31:	0f 85 b9 00 00 00    	jne    80103ef0 <fork+0x1a0>
        //TODO PAGECOUNTER-16= PAGES IN SWAP FILE
        for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80103e37:	83 bb 88 02 00 00 10 	cmpl   $0x10,0x288(%ebx)
80103e3e:	0f 8e ac 00 00 00    	jle    80103ef0 <fork+0x1a0>
80103e44:	31 ff                	xor    %edi,%edi
80103e46:	eb 35                	jmp    80103e7d <fork+0x12d>
80103e48:	90                   	nop
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                np->state = UNUSED;
                removeSwapFile(np); //clear swapFile
                return -1;
            }

            if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
80103e50:	68 00 10 00 00       	push   $0x1000
80103e55:	52                   	push   %edx
80103e56:	68 20 2d 11 80       	push   $0x80112d20
80103e5b:	ff 75 e4             	pushl  -0x1c(%ebp)
80103e5e:	e8 0d e4 ff ff       	call   80102270 <writeToSwapFile>
80103e63:	83 c4 10             	add    $0x10,%esp
80103e66:	83 f8 ff             	cmp    $0xffffffff,%eax
80103e69:	89 c6                	mov    %eax,%esi
80103e6b:	74 4a                	je     80103eb7 <fork+0x167>
    }

    //TODO FIRST RUN IN BEFORE SHEL LOADED
    if (!firstRun) {
        //TODO PAGECOUNTER-16= PAGES IN SWAP FILE
        for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80103e6d:	8b 83 88 02 00 00    	mov    0x288(%ebx),%eax
80103e73:	83 c7 01             	add    $0x1,%edi
80103e76:	83 e8 10             	sub    $0x10,%eax
80103e79:	39 f8                	cmp    %edi,%eax
80103e7b:	7e 73                	jle    80103ef0 <fork+0x1a0>
        //while (sizeof(curproc->swapFile) >= k * PGSIZE) {
            memset(buffer, 0, PGSIZE);
80103e7d:	83 ec 04             	sub    $0x4,%esp
80103e80:	68 00 10 00 00       	push   $0x1000
80103e85:	6a 00                	push   $0x0
80103e87:	68 20 2d 11 80       	push   $0x80112d20
80103e8c:	e8 8f 0b 00 00       	call   80104a20 <memset>
80103e91:	89 fa                	mov    %edi,%edx

            if (readFromSwapFile(curproc, buffer, k * PGSIZE, PGSIZE) == -1) {
80103e93:	68 00 10 00 00       	push   $0x1000
80103e98:	c1 e2 0c             	shl    $0xc,%edx
80103e9b:	52                   	push   %edx
80103e9c:	68 20 2d 11 80       	push   $0x80112d20
80103ea1:	53                   	push   %ebx
80103ea2:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103ea5:	e8 f6 e3 ff ff       	call   801022a0 <readFromSwapFile>
80103eaa:	83 c4 20             	add    $0x20,%esp
80103ead:	83 f8 ff             	cmp    $0xffffffff,%eax
80103eb0:	89 c6                	mov    %eax,%esi
80103eb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103eb5:	75 99                	jne    80103e50 <fork+0x100>
                removeSwapFile(np); //clear swapFile
                return -1;
            }

            if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
                kfree(np->kstack);
80103eb7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	ff 73 08             	pushl  0x8(%ebx)
80103ec0:	e8 eb e7 ff ff       	call   801026b0 <kfree>
                np->kstack = 0;
80103ec5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                np->state = UNUSED;
80103ecc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                removeSwapFile(np); //clear swapFile
80103ed3:	89 1c 24             	mov    %ebx,(%esp)
80103ed6:	e8 f5 e0 ff ff       	call   80101fd0 <removeSwapFile>
                return -1;
80103edb:	83 c4 10             	add    $0x10,%esp

    release(&ptable.lock);

    firstRun = 0;
    return pid;
}
80103ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ee1:	89 f0                	mov    %esi,%eax
80103ee3:	5b                   	pop    %ebx
80103ee4:	5e                   	pop    %esi
80103ee5:	5f                   	pop    %edi
80103ee6:	5d                   	pop    %ebp
80103ee7:	c3                   	ret    
80103ee8:	90                   	nop
80103ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
    }


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80103ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax

    for (i = 0; i < NOFILE; i++)
80103ef3:	31 f6                	xor    %esi,%esi
        }
    }


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80103ef5:	8b 40 18             	mov    0x18(%eax),%eax
80103ef8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103eff:	90                   	nop

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
80103f00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f04:	85 c0                	test   %eax,%eax
80103f06:	74 13                	je     80103f1b <fork+0x1cb>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103f08:	83 ec 0c             	sub    $0xc,%esp
80103f0b:	50                   	push   %eax
80103f0c:	e8 ff ce ff ff       	call   80100e10 <filedup>
80103f11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103f14:	83 c4 10             	add    $0x10,%esp
80103f17:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103f1b:	83 c6 01             	add    $0x1,%esi
80103f1e:	83 fe 10             	cmp    $0x10,%esi
80103f21:	75 dd                	jne    80103f00 <fork+0x1b0>
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103f23:	83 ec 0c             	sub    $0xc,%esp
80103f26:	ff 73 68             	pushl  0x68(%ebx)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f29:	83 c3 6c             	add    $0x6c,%ebx
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103f2c:	e8 3f d7 ff ff       	call   80101670 <idup>
80103f31:	8b 7d e4             	mov    -0x1c(%ebp),%edi

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f34:	83 c4 0c             	add    $0xc,%esp
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103f37:	89 47 68             	mov    %eax,0x68(%edi)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f3a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f3d:	6a 10                	push   $0x10
80103f3f:	53                   	push   %ebx
80103f40:	50                   	push   %eax
80103f41:	e8 da 0c 00 00       	call   80104c20 <safestrcpy>

    pid = np->pid;
80103f46:	8b 77 10             	mov    0x10(%edi),%esi

    acquire(&ptable.lock);
80103f49:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f50:	e8 5b 09 00 00       	call   801048b0 <acquire>

    np->state = RUNNABLE;
80103f55:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

    release(&ptable.lock);
80103f5c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f63:	e8 68 0a 00 00       	call   801049d0 <release>

    firstRun = 0;
80103f68:	c7 05 08 a0 10 80 00 	movl   $0x0,0x8010a008
80103f6f:	00 00 00 
    return pid;
80103f72:	83 c4 10             	add    $0x10,%esp
}
80103f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f78:	89 f0                	mov    %esi,%eax
80103f7a:	5b                   	pop    %ebx
80103f7b:	5e                   	pop    %esi
80103f7c:	5f                   	pop    %edi
80103f7d:	5d                   	pop    %ebp
80103f7e:	c3                   	ret    
80103f7f:	90                   	nop
        return -1;
    }


    if (firstRun) {
        createSwapFile(curproc);
80103f80:	83 ec 0c             	sub    $0xc,%esp
80103f83:	53                   	push   %ebx
80103f84:	e8 47 e2 ff ff       	call   801021d0 <createSwapFile>
80103f89:	83 c4 10             	add    $0x10,%esp
80103f8c:	e9 fb fd ff ff       	jmp    80103d8c <fork+0x3c>
    struct proc *np;
    struct proc *curproc = myproc();
    struct page *pg , *cg;
    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
80103f91:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103f96:	eb dd                	jmp    80103f75 <fork+0x225>

    createSwapFile(np);

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
80103f98:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f9b:	83 ec 0c             	sub    $0xc,%esp
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
80103f9e:	be ff ff ff ff       	mov    $0xffffffff,%esi

    createSwapFile(np);

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
80103fa3:	ff 73 08             	pushl  0x8(%ebx)
80103fa6:	e8 05 e7 ff ff       	call   801026b0 <kfree>
        np->kstack = 0;
80103fab:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
80103fb2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
80103fb9:	83 c4 10             	add    $0x10,%esp
80103fbc:	eb b7                	jmp    80103f75 <fork+0x225>
80103fbe:	66 90                	xchg   %ax,%ax

80103fc0 <scheduler>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	57                   	push   %edi
80103fc4:	56                   	push   %esi
80103fc5:	53                   	push   %ebx
80103fc6:	83 ec 0c             	sub    $0xc,%esp
    struct proc *p;
    struct cpu *c = mycpu();
80103fc9:	e8 42 fb ff ff       	call   80103b10 <mycpu>
80103fce:	8d 78 04             	lea    0x4(%eax),%edi
80103fd1:	89 c6                	mov    %eax,%esi
    c->proc = 0;
80103fd3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103fda:	00 00 00 
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103fe0:	fb                   	sti    
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103fe1:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103fe4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103fe9:	68 20 3d 11 80       	push   $0x80113d20
80103fee:	e8 bd 08 00 00       	call   801048b0 <acquire>
80103ff3:	83 c4 10             	add    $0x10,%esp
80103ff6:	eb 16                	jmp    8010400e <scheduler+0x4e>
80103ff8:	90                   	nop
80103ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104000:	81 c3 8c 02 00 00    	add    $0x28c,%ebx
80104006:	81 fb 54 e0 11 80    	cmp    $0x8011e054,%ebx
8010400c:	74 52                	je     80104060 <scheduler+0xa0>
            if (p->state != RUNNABLE)
8010400e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104012:	75 ec                	jne    80104000 <scheduler+0x40>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
80104014:	83 ec 0c             	sub    $0xc,%esp
                continue;

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
80104017:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
8010401d:	53                   	push   %ebx
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010401e:	81 c3 8c 02 00 00    	add    $0x28c,%ebx

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
80104024:	e8 17 2e 00 00       	call   80106e40 <switchuvm>
            p->state = RUNNING;

            swtch(&(c->scheduler), p->context);
80104029:	58                   	pop    %eax
8010402a:	5a                   	pop    %edx
8010402b:	ff b3 90 fd ff ff    	pushl  -0x270(%ebx)
80104031:	57                   	push   %edi
            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
            p->state = RUNNING;
80104032:	c7 83 80 fd ff ff 04 	movl   $0x4,-0x280(%ebx)
80104039:	00 00 00 

            swtch(&(c->scheduler), p->context);
8010403c:	e8 3a 0c 00 00       	call   80104c7b <swtch>
            switchkvm();
80104041:	e8 da 2d 00 00       	call   80106e20 <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80104046:	83 c4 10             	add    $0x10,%esp
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104049:	81 fb 54 e0 11 80    	cmp    $0x8011e054,%ebx
            swtch(&(c->scheduler), p->context);
            switchkvm();

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
8010404f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104056:	00 00 00 
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104059:	75 b3                	jne    8010400e <scheduler+0x4e>
8010405b:	90                   	nop
8010405c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&ptable.lock);
80104060:	83 ec 0c             	sub    $0xc,%esp
80104063:	68 20 3d 11 80       	push   $0x80113d20
80104068:	e8 63 09 00 00       	call   801049d0 <release>

    }
8010406d:	83 c4 10             	add    $0x10,%esp
80104070:	e9 6b ff ff ff       	jmp    80103fe0 <scheduler+0x20>
80104075:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104080 <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	56                   	push   %esi
80104084:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104085:	e8 e6 07 00 00       	call   80104870 <pushcli>
    c = mycpu();
8010408a:	e8 81 fa ff ff       	call   80103b10 <mycpu>
    p = c->proc;
8010408f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104095:	e8 c6 08 00 00       	call   80104960 <popcli>
void
sched(void) {
    int intena;
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
8010409a:	83 ec 0c             	sub    $0xc,%esp
8010409d:	68 20 3d 11 80       	push   $0x80113d20
801040a2:	e8 89 07 00 00       	call   80104830 <holding>
801040a7:	83 c4 10             	add    $0x10,%esp
801040aa:	85 c0                	test   %eax,%eax
801040ac:	74 4f                	je     801040fd <sched+0x7d>
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
801040ae:	e8 5d fa ff ff       	call   80103b10 <mycpu>
801040b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801040ba:	75 68                	jne    80104124 <sched+0xa4>
        panic("sched locks");
    if (p->state == RUNNING)
801040bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801040c0:	74 55                	je     80104117 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040c2:	9c                   	pushf  
801040c3:	58                   	pop    %eax
        panic("sched running");
    if (readeflags() & FL_IF)
801040c4:	f6 c4 02             	test   $0x2,%ah
801040c7:	75 41                	jne    8010410a <sched+0x8a>
        panic("sched interruptible");
    intena = mycpu()->intena;
801040c9:	e8 42 fa ff ff       	call   80103b10 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
801040ce:	83 c3 1c             	add    $0x1c,%ebx
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
801040d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
801040d7:	e8 34 fa ff ff       	call   80103b10 <mycpu>
801040dc:	83 ec 08             	sub    $0x8,%esp
801040df:	ff 70 04             	pushl  0x4(%eax)
801040e2:	53                   	push   %ebx
801040e3:	e8 93 0b 00 00       	call   80104c7b <swtch>
    mycpu()->intena = intena;
801040e8:	e8 23 fa ff ff       	call   80103b10 <mycpu>
}
801040ed:	83 c4 10             	add    $0x10,%esp
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
    swtch(&p->context, mycpu()->scheduler);
    mycpu()->intena = intena;
801040f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801040f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040f9:	5b                   	pop    %ebx
801040fa:	5e                   	pop    %esi
801040fb:	5d                   	pop    %ebp
801040fc:	c3                   	ret    
sched(void) {
    int intena;
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
801040fd:	83 ec 0c             	sub    $0xc,%esp
80104100:	68 b0 7a 10 80       	push   $0x80107ab0
80104105:	e8 66 c2 ff ff       	call   80100370 <panic>
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	68 dc 7a 10 80       	push   $0x80107adc
80104112:	e8 59 c2 ff ff       	call   80100370 <panic>
    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
80104117:	83 ec 0c             	sub    $0xc,%esp
8010411a:	68 ce 7a 10 80       	push   $0x80107ace
8010411f:	e8 4c c2 ff ff       	call   80100370 <panic>
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
80104124:	83 ec 0c             	sub    $0xc,%esp
80104127:	68 c2 7a 10 80       	push   $0x80107ac2
8010412c:	e8 3f c2 ff ff       	call   80100370 <panic>
80104131:	eb 0d                	jmp    80104140 <exit>
80104133:	90                   	nop
80104134:	90                   	nop
80104135:	90                   	nop
80104136:	90                   	nop
80104137:	90                   	nop
80104138:	90                   	nop
80104139:	90                   	nop
8010413a:	90                   	nop
8010413b:	90                   	nop
8010413c:	90                   	nop
8010413d:	90                   	nop
8010413e:	90                   	nop
8010413f:	90                   	nop

80104140 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	57                   	push   %edi
80104144:	56                   	push   %esi
80104145:	53                   	push   %ebx
80104146:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104149:	e8 22 07 00 00       	call   80104870 <pushcli>
    c = mycpu();
8010414e:	e8 bd f9 ff ff       	call   80103b10 <mycpu>
    p = c->proc;
80104153:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104159:	e8 02 08 00 00       	call   80104960 <popcli>
exit(void) {
    struct proc *curproc = myproc();
    struct proc *p;
    int fd;

    if (curproc == initproc)
8010415e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80104164:	8d 5e 28             	lea    0x28(%esi),%ebx
80104167:	8d 7e 68             	lea    0x68(%esi),%edi
8010416a:	0f 84 11 01 00 00    	je     80104281 <exit+0x141>
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
80104170:	8b 03                	mov    (%ebx),%eax
80104172:	85 c0                	test   %eax,%eax
80104174:	74 12                	je     80104188 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104176:	83 ec 0c             	sub    $0xc,%esp
80104179:	50                   	push   %eax
8010417a:	e8 e1 cc ff ff       	call   80100e60 <fileclose>
            curproc->ofile[fd] = 0;
8010417f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104185:	83 c4 10             	add    $0x10,%esp
80104188:	83 c3 04             	add    $0x4,%ebx

    if (curproc == initproc)
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
8010418b:	39 df                	cmp    %ebx,%edi
8010418d:	75 e1                	jne    80104170 <exit+0x30>
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }

    begin_op();
8010418f:	e8 8c ed ff ff       	call   80102f20 <begin_op>
    iput(curproc->cwd);
80104194:	83 ec 0c             	sub    $0xc,%esp
80104197:	ff 76 68             	pushl  0x68(%esi)
8010419a:	e8 31 d6 ff ff       	call   801017d0 <iput>
    end_op();
8010419f:	e8 ec ed ff ff       	call   80102f90 <end_op>
    curproc->cwd = 0;

    if (curproc->swapFile)
801041a4:	8b 46 7c             	mov    0x7c(%esi),%eax
801041a7:	83 c4 10             	add    $0x10,%esp
    }

    begin_op();
    iput(curproc->cwd);
    end_op();
    curproc->cwd = 0;
801041aa:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

    if (curproc->swapFile)
801041b1:	85 c0                	test   %eax,%eax
801041b3:	74 0c                	je     801041c1 <exit+0x81>
        removeSwapFile(curproc);
801041b5:	83 ec 0c             	sub    $0xc,%esp
801041b8:	56                   	push   %esi
801041b9:	e8 12 de ff ff       	call   80101fd0 <removeSwapFile>
801041be:	83 c4 10             	add    $0x10,%esp

    acquire(&ptable.lock);
801041c1:	83 ec 0c             	sub    $0xc,%esp
801041c4:	68 20 3d 11 80       	push   $0x80113d20
801041c9:	e8 e2 06 00 00       	call   801048b0 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);
801041ce:	8b 56 14             	mov    0x14(%esi),%edx
801041d1:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d4:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801041d9:	eb 11                	jmp    801041ec <exit+0xac>
801041db:	90                   	nop
801041dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e0:	05 8c 02 00 00       	add    $0x28c,%eax
801041e5:	3d 54 e0 11 80       	cmp    $0x8011e054,%eax
801041ea:	74 1e                	je     8010420a <exit+0xca>
        if (p->state == SLEEPING && p->chan == chan)
801041ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041f0:	75 ee                	jne    801041e0 <exit+0xa0>
801041f2:	3b 50 20             	cmp    0x20(%eax),%edx
801041f5:	75 e9                	jne    801041e0 <exit+0xa0>
            p->state = RUNNABLE;
801041f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041fe:	05 8c 02 00 00       	add    $0x28c,%eax
80104203:	3d 54 e0 11 80       	cmp    $0x8011e054,%eax
80104208:	75 e2                	jne    801041ec <exit+0xac>
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
8010420a:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80104210:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104215:	eb 17                	jmp    8010422e <exit+0xee>
80104217:	89 f6                	mov    %esi,%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104220:	81 c2 8c 02 00 00    	add    $0x28c,%edx
80104226:	81 fa 54 e0 11 80    	cmp    $0x8011e054,%edx
8010422c:	74 3a                	je     80104268 <exit+0x128>
        if (p->parent == curproc) {
8010422e:	39 72 14             	cmp    %esi,0x14(%edx)
80104231:	75 ed                	jne    80104220 <exit+0xe0>
            p->parent = initproc;
            if (p->state == ZOMBIE)
80104233:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
80104237:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010423a:	75 e4                	jne    80104220 <exit+0xe0>
8010423c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104241:	eb 11                	jmp    80104254 <exit+0x114>
80104243:	90                   	nop
80104244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104248:	05 8c 02 00 00       	add    $0x28c,%eax
8010424d:	3d 54 e0 11 80       	cmp    $0x8011e054,%eax
80104252:	74 cc                	je     80104220 <exit+0xe0>
        if (p->state == SLEEPING && p->chan == chan)
80104254:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104258:	75 ee                	jne    80104248 <exit+0x108>
8010425a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010425d:	75 e9                	jne    80104248 <exit+0x108>
            p->state = RUNNABLE;
8010425f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104266:	eb e0                	jmp    80104248 <exit+0x108>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;
80104268:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    sched();
8010426f:	e8 0c fe ff ff       	call   80104080 <sched>
    panic("zombie exit");
80104274:	83 ec 0c             	sub    $0xc,%esp
80104277:	68 fd 7a 10 80       	push   $0x80107afd
8010427c:	e8 ef c0 ff ff       	call   80100370 <panic>
    struct proc *curproc = myproc();
    struct proc *p;
    int fd;

    if (curproc == initproc)
        panic("init exiting");
80104281:	83 ec 0c             	sub    $0xc,%esp
80104284:	68 f0 7a 10 80       	push   $0x80107af0
80104289:	e8 e2 c0 ff ff       	call   80100370 <panic>
8010428e:	66 90                	xchg   %ax,%ax

80104290 <yield>:
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
80104294:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104297:	68 20 3d 11 80       	push   $0x80113d20
8010429c:	e8 0f 06 00 00       	call   801048b0 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801042a1:	e8 ca 05 00 00       	call   80104870 <pushcli>
    c = mycpu();
801042a6:	e8 65 f8 ff ff       	call   80103b10 <mycpu>
    p = c->proc;
801042ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801042b1:	e8 aa 06 00 00       	call   80104960 <popcli>

// Give up the CPU for one scheduling round.
void
yield(void) {
    acquire(&ptable.lock);  //DOC: yieldlock
    myproc()->state = RUNNABLE;
801042b6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
801042bd:	e8 be fd ff ff       	call   80104080 <sched>
    release(&ptable.lock);
801042c2:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801042c9:	e8 02 07 00 00       	call   801049d0 <release>
}
801042ce:	83 c4 10             	add    $0x10,%esp
801042d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d4:	c9                   	leave  
801042d5:	c3                   	ret    
801042d6:	8d 76 00             	lea    0x0(%esi),%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042e0 <sleep>:
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	57                   	push   %edi
801042e4:	56                   	push   %esi
801042e5:	53                   	push   %ebx
801042e6:	83 ec 0c             	sub    $0xc,%esp
801042e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042ec:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801042ef:	e8 7c 05 00 00       	call   80104870 <pushcli>
    c = mycpu();
801042f4:	e8 17 f8 ff ff       	call   80103b10 <mycpu>
    p = c->proc;
801042f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801042ff:	e8 5c 06 00 00       	call   80104960 <popcli>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
    struct proc *p = myproc();

    if (p == 0)
80104304:	85 db                	test   %ebx,%ebx
80104306:	0f 84 87 00 00 00    	je     80104393 <sleep+0xb3>
        panic("sleep");

    if (lk == 0)
8010430c:	85 f6                	test   %esi,%esi
8010430e:	74 76                	je     80104386 <sleep+0xa6>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {  //DOC: sleeplock0
80104310:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104316:	74 50                	je     80104368 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	68 20 3d 11 80       	push   $0x80113d20
80104320:	e8 8b 05 00 00       	call   801048b0 <acquire>
        release(lk);
80104325:	89 34 24             	mov    %esi,(%esp)
80104328:	e8 a3 06 00 00       	call   801049d0 <release>
    }
    // Go to sleep.
    p->chan = chan;
8010432d:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104330:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

    sched();
80104337:	e8 44 fd ff ff       	call   80104080 <sched>

    // Tidy up.
    p->chan = 0;
8010433c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80104343:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010434a:	e8 81 06 00 00       	call   801049d0 <release>
        acquire(lk);
8010434f:	89 75 08             	mov    %esi,0x8(%ebp)
80104352:	83 c4 10             	add    $0x10,%esp
    }
}
80104355:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104358:	5b                   	pop    %ebx
80104359:	5e                   	pop    %esi
8010435a:	5f                   	pop    %edi
8010435b:	5d                   	pop    %ebp
    p->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
8010435c:	e9 4f 05 00 00       	jmp    801048b0 <acquire>
80104361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (lk != &ptable.lock) {  //DOC: sleeplock0
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }
    // Go to sleep.
    p->chan = chan;
80104368:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010436b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

    sched();
80104372:	e8 09 fd ff ff       	call   80104080 <sched>

    // Tidy up.
    p->chan = 0;
80104377:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}
8010437e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104381:	5b                   	pop    %ebx
80104382:	5e                   	pop    %esi
80104383:	5f                   	pop    %edi
80104384:	5d                   	pop    %ebp
80104385:	c3                   	ret    

    if (p == 0)
        panic("sleep");

    if (lk == 0)
        panic("sleep without lk");
80104386:	83 ec 0c             	sub    $0xc,%esp
80104389:	68 0f 7b 10 80       	push   $0x80107b0f
8010438e:	e8 dd bf ff ff       	call   80100370 <panic>
void
sleep(void *chan, struct spinlock *lk) {
    struct proc *p = myproc();

    if (p == 0)
        panic("sleep");
80104393:	83 ec 0c             	sub    $0xc,%esp
80104396:	68 09 7b 10 80       	push   $0x80107b09
8010439b:	e8 d0 bf ff ff       	call   80100370 <panic>

801043a0 <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801043a5:	e8 c6 04 00 00       	call   80104870 <pushcli>
    c = mycpu();
801043aa:	e8 61 f7 ff ff       	call   80103b10 <mycpu>
    p = c->proc;
801043af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801043b5:	e8 a6 05 00 00       	call   80104960 <popcli>
    struct proc *p;
    struct page *pg;
    int havekids, pid;
    struct proc *curproc = myproc();

    acquire(&ptable.lock);
801043ba:	83 ec 0c             	sub    $0xc,%esp
801043bd:	68 20 3d 11 80       	push   $0x80113d20
801043c2:	e8 e9 04 00 00       	call   801048b0 <acquire>
801043c7:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
801043ca:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043cc:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801043d1:	eb 13                	jmp    801043e6 <wait+0x46>
801043d3:	90                   	nop
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d8:	81 c3 8c 02 00 00    	add    $0x28c,%ebx
801043de:	81 fb 54 e0 11 80    	cmp    $0x8011e054,%ebx
801043e4:	74 22                	je     80104408 <wait+0x68>
            if (p->parent != curproc)
801043e6:	39 73 14             	cmp    %esi,0x14(%ebx)
801043e9:	75 ed                	jne    801043d8 <wait+0x38>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
801043eb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043ef:	74 3d                	je     8010442e <wait+0x8e>

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043f1:	81 c3 8c 02 00 00    	add    $0x28c,%ebx
            if (p->parent != curproc)
                continue;
            havekids = 1;
801043f7:	b8 01 00 00 00       	mov    $0x1,%eax

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043fc:	81 fb 54 e0 11 80    	cmp    $0x8011e054,%ebx
80104402:	75 e2                	jne    801043e6 <wait+0x46>
80104404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
80104408:	85 c0                	test   %eax,%eax
8010440a:	0f 84 c3 00 00 00    	je     801044d3 <wait+0x133>
80104410:	8b 46 24             	mov    0x24(%esi),%eax
80104413:	85 c0                	test   %eax,%eax
80104415:	0f 85 b8 00 00 00    	jne    801044d3 <wait+0x133>
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010441b:	83 ec 08             	sub    $0x8,%esp
8010441e:	68 20 3d 11 80       	push   $0x80113d20
80104423:	56                   	push   %esi
80104424:	e8 b7 fe ff ff       	call   801042e0 <sleep>
    }
80104429:	83 c4 10             	add    $0x10,%esp
8010442c:	eb 9c                	jmp    801043ca <wait+0x2a>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
8010442e:	83 ec 0c             	sub    $0xc,%esp
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
80104431:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80104434:	ff 73 08             	pushl  0x8(%ebx)
80104437:	e8 74 e2 ff ff       	call   801026b0 <kfree>
                p->kstack = 0;
8010443c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104443:	5a                   	pop    %edx
80104444:	ff 73 04             	pushl  0x4(%ebx)
80104447:	e8 74 2d 00 00       	call   801071c0 <freevm>
                p->pid = 0;
8010444c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104453:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->state = UNUSED;
                p->pagesCounter = -1;
                p->nextpageid = 0;
                p->swapOffset = 0;

                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010445a:	8d 83 84 00 00 00    	lea    0x84(%ebx),%eax
                kfree(p->kstack);
                p->kstack = 0;
                freevm(p->pgdir);
                p->pid = 0;
                p->parent = 0;
                p->name[0] = 0;
80104460:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
80104464:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
                p->pagesCounter = -1;
                p->nextpageid = 0;
                p->swapOffset = 0;

                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010446b:	83 c4 10             	add    $0x10,%esp
                freevm(p->pgdir);
                p->pid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
8010446e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->pagesCounter = -1;
80104475:	c7 83 88 02 00 00 ff 	movl   $0xffffffff,0x288(%ebx)
8010447c:	ff ff ff 
                p->nextpageid = 0;
                p->swapOffset = 0;

                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010447f:	81 c3 84 02 00 00    	add    $0x284,%ebx
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                p->pagesCounter = -1;
                p->nextpageid = 0;
80104485:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
                p->swapOffset = 0;
8010448b:	c7 83 fc fd ff ff 00 	movl   $0x0,-0x204(%ebx)
80104492:	00 00 00 
80104495:	8d 76 00             	lea    0x0(%esi),%esi

                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
                {
                    pg->offset = 0;
80104498:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                    pg->pageid = 0;
8010449f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                p->state = UNUSED;
                p->pagesCounter = -1;
                p->nextpageid = 0;
                p->swapOffset = 0;

                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801044a5:	83 c0 10             	add    $0x10,%eax
                {
                    pg->offset = 0;
                    pg->pageid = 0;
                    pg->present = -1;
801044a8:	c7 40 f8 ff ff ff ff 	movl   $0xffffffff,-0x8(%eax)
                    pg->sequel = -1;
801044af:	c7 40 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%eax)
                p->state = UNUSED;
                p->pagesCounter = -1;
                p->nextpageid = 0;
                p->swapOffset = 0;

                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801044b6:	39 c3                	cmp    %eax,%ebx
801044b8:	77 de                	ja     80104498 <wait+0xf8>
                    pg->pageid = 0;
                    pg->present = -1;
                    pg->sequel = -1;
                }

                release(&ptable.lock);
801044ba:	83 ec 0c             	sub    $0xc,%esp
801044bd:	68 20 3d 11 80       	push   $0x80113d20
801044c2:	e8 09 05 00 00       	call   801049d0 <release>
                return pid;
801044c7:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801044ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
                    pg->present = -1;
                    pg->sequel = -1;
                }

                release(&ptable.lock);
                return pid;
801044cd:	89 f0                	mov    %esi,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801044cf:	5b                   	pop    %ebx
801044d0:	5e                   	pop    %esi
801044d1:	5d                   	pop    %ebp
801044d2:	c3                   	ret    
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
801044d3:	83 ec 0c             	sub    $0xc,%esp
801044d6:	68 20 3d 11 80       	push   $0x80113d20
801044db:	e8 f0 04 00 00       	call   801049d0 <release>
            return -1;
801044e0:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801044e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
            return -1;
801044e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801044eb:	5b                   	pop    %ebx
801044ec:	5e                   	pop    %esi
801044ed:	5d                   	pop    %ebp
801044ee:	c3                   	ret    
801044ef:	90                   	nop

801044f0 <wakeup>:
            p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 10             	sub    $0x10,%esp
801044f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
801044fa:	68 20 3d 11 80       	push   $0x80113d20
801044ff:	e8 ac 03 00 00       	call   801048b0 <acquire>
80104504:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104507:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010450c:	eb 0e                	jmp    8010451c <wakeup+0x2c>
8010450e:	66 90                	xchg   %ax,%ax
80104510:	05 8c 02 00 00       	add    $0x28c,%eax
80104515:	3d 54 e0 11 80       	cmp    $0x8011e054,%eax
8010451a:	74 1e                	je     8010453a <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan)
8010451c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104520:	75 ee                	jne    80104510 <wakeup+0x20>
80104522:	3b 58 20             	cmp    0x20(%eax),%ebx
80104525:	75 e9                	jne    80104510 <wakeup+0x20>
            p->state = RUNNABLE;
80104527:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010452e:	05 8c 02 00 00       	add    $0x28c,%eax
80104533:	3d 54 e0 11 80       	cmp    $0x8011e054,%eax
80104538:	75 e2                	jne    8010451c <wakeup+0x2c>
// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
8010453a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104544:	c9                   	leave  
// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
80104545:	e9 86 04 00 00       	jmp    801049d0 <release>
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104550 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 10             	sub    $0x10,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
8010455a:	68 20 3d 11 80       	push   $0x80113d20
8010455f:	e8 4c 03 00 00       	call   801048b0 <acquire>
80104564:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104567:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010456c:	eb 0e                	jmp    8010457c <kill+0x2c>
8010456e:	66 90                	xchg   %ax,%ax
80104570:	05 8c 02 00 00       	add    $0x28c,%eax
80104575:	3d 54 e0 11 80       	cmp    $0x8011e054,%eax
8010457a:	74 3c                	je     801045b8 <kill+0x68>
        if (p->pid == pid) {
8010457c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010457f:	75 ef                	jne    80104570 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
80104581:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
    struct proc *p;

    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
80104585:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
8010458c:	74 1a                	je     801045a8 <kill+0x58>
                p->state = RUNNABLE;
            release(&ptable.lock);
8010458e:	83 ec 0c             	sub    $0xc,%esp
80104591:	68 20 3d 11 80       	push   $0x80113d20
80104596:	e8 35 04 00 00       	call   801049d0 <release>
            return 0;
8010459b:	83 c4 10             	add    $0x10,%esp
8010459e:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801045a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045a3:	c9                   	leave  
801045a4:	c3                   	ret    
801045a5:	8d 76 00             	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
                p->state = RUNNABLE;
801045a8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801045af:	eb dd                	jmp    8010458e <kill+0x3e>
801045b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 20 3d 11 80       	push   $0x80113d20
801045c0:	e8 0b 04 00 00       	call   801049d0 <release>
    return -1;
801045c5:	83 c4 10             	add    $0x10,%esp
801045c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d0:	c9                   	leave  
801045d1:	c3                   	ret    
801045d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	53                   	push   %ebx
801045e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801045e9:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801045ee:	83 ec 3c             	sub    $0x3c,%esp
801045f1:	eb 27                	jmp    8010461a <procdump+0x3a>
801045f3:	90                   	nop
801045f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	68 77 7e 10 80       	push   $0x80107e77
80104600:	e8 5b c0 ff ff       	call   80100660 <cprintf>
80104605:	83 c4 10             	add    $0x10,%esp
80104608:	81 c3 8c 02 00 00    	add    $0x28c,%ebx
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010460e:	81 fb c0 e0 11 80    	cmp    $0x8011e0c0,%ebx
80104614:	0f 84 7e 00 00 00    	je     80104698 <procdump+0xb8>
        if (p->state == UNUSED)
8010461a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010461d:	85 c0                	test   %eax,%eax
8010461f:	74 e7                	je     80104608 <procdump+0x28>
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104621:	83 f8 05             	cmp    $0x5,%eax
            state = states[p->state];
        else
            state = "???";
80104624:	ba 20 7b 10 80       	mov    $0x80107b20,%edx
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104629:	77 11                	ja     8010463c <procdump+0x5c>
8010462b:	8b 14 85 80 7b 10 80 	mov    -0x7fef8480(,%eax,4),%edx
            state = states[p->state];
        else
            state = "???";
80104632:	b8 20 7b 10 80       	mov    $0x80107b20,%eax
80104637:	85 d2                	test   %edx,%edx
80104639:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
8010463c:	53                   	push   %ebx
8010463d:	52                   	push   %edx
8010463e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104641:	68 24 7b 10 80       	push   $0x80107b24
80104646:	e8 15 c0 ff ff       	call   80100660 <cprintf>
        if (p->state == SLEEPING) {
8010464b:	83 c4 10             	add    $0x10,%esp
8010464e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104652:	75 a4                	jne    801045f8 <procdump+0x18>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
80104654:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104657:	83 ec 08             	sub    $0x8,%esp
8010465a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010465d:	50                   	push   %eax
8010465e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104661:	8b 40 0c             	mov    0xc(%eax),%eax
80104664:	83 c0 08             	add    $0x8,%eax
80104667:	50                   	push   %eax
80104668:	e8 63 01 00 00       	call   801047d0 <getcallerpcs>
8010466d:	83 c4 10             	add    $0x10,%esp
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104670:	8b 17                	mov    (%edi),%edx
80104672:	85 d2                	test   %edx,%edx
80104674:	74 82                	je     801045f8 <procdump+0x18>
                cprintf(" %p", pc[i]);
80104676:	83 ec 08             	sub    $0x8,%esp
80104679:	83 c7 04             	add    $0x4,%edi
8010467c:	52                   	push   %edx
8010467d:	68 21 75 10 80       	push   $0x80107521
80104682:	e8 d9 bf ff ff       	call   80100660 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104687:	83 c4 10             	add    $0x10,%esp
8010468a:	39 f7                	cmp    %esi,%edi
8010468c:	75 e2                	jne    80104670 <procdump+0x90>
8010468e:	e9 65 ff ff ff       	jmp    801045f8 <procdump+0x18>
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
80104698:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010469b:	5b                   	pop    %ebx
8010469c:	5e                   	pop    %esi
8010469d:	5f                   	pop    %edi
8010469e:	5d                   	pop    %ebp
8010469f:	c3                   	ret    

801046a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 0c             	sub    $0xc,%esp
801046a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801046aa:	68 98 7b 10 80       	push   $0x80107b98
801046af:	8d 43 04             	lea    0x4(%ebx),%eax
801046b2:	50                   	push   %eax
801046b3:	e8 f8 00 00 00       	call   801047b0 <initlock>
  lk->name = name;
801046b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801046bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801046c1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801046c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801046cb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801046ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d1:	c9                   	leave  
801046d2:	c3                   	ret    
801046d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046e8:	83 ec 0c             	sub    $0xc,%esp
801046eb:	8d 73 04             	lea    0x4(%ebx),%esi
801046ee:	56                   	push   %esi
801046ef:	e8 bc 01 00 00       	call   801048b0 <acquire>
  while (lk->locked) {
801046f4:	8b 13                	mov    (%ebx),%edx
801046f6:	83 c4 10             	add    $0x10,%esp
801046f9:	85 d2                	test   %edx,%edx
801046fb:	74 16                	je     80104713 <acquiresleep+0x33>
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104700:	83 ec 08             	sub    $0x8,%esp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	e8 d6 fb ff ff       	call   801042e0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010470a:	8b 03                	mov    (%ebx),%eax
8010470c:	83 c4 10             	add    $0x10,%esp
8010470f:	85 c0                	test   %eax,%eax
80104711:	75 ed                	jne    80104700 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104713:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104719:	e8 92 f4 ff ff       	call   80103bb0 <myproc>
8010471e:	8b 40 10             	mov    0x10(%eax),%eax
80104721:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104724:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104727:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010472a:	5b                   	pop    %ebx
8010472b:	5e                   	pop    %esi
8010472c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010472d:	e9 9e 02 00 00       	jmp    801049d0 <release>
80104732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104740 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	8d 73 04             	lea    0x4(%ebx),%esi
8010474e:	56                   	push   %esi
8010474f:	e8 5c 01 00 00       	call   801048b0 <acquire>
  lk->locked = 0;
80104754:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010475a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104761:	89 1c 24             	mov    %ebx,(%esp)
80104764:	e8 87 fd ff ff       	call   801044f0 <wakeup>
  release(&lk->lk);
80104769:	89 75 08             	mov    %esi,0x8(%ebp)
8010476c:	83 c4 10             	add    $0x10,%esp
}
8010476f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104772:	5b                   	pop    %ebx
80104773:	5e                   	pop    %esi
80104774:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104775:	e9 56 02 00 00       	jmp    801049d0 <release>
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010478e:	53                   	push   %ebx
8010478f:	e8 1c 01 00 00       	call   801048b0 <acquire>
  r = lk->locked;
80104794:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104796:	89 1c 24             	mov    %ebx,(%esp)
80104799:	e8 32 02 00 00       	call   801049d0 <release>
  return r;
}
8010479e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047a1:	89 f0                	mov    %esi,%eax
801047a3:	5b                   	pop    %ebx
801047a4:	5e                   	pop    %esi
801047a5:	5d                   	pop    %ebp
801047a6:	c3                   	ret    
801047a7:	66 90                	xchg   %ax,%ax
801047a9:	66 90                	xchg   %ax,%ax
801047ab:	66 90                	xchg   %ax,%ax
801047ad:	66 90                	xchg   %ax,%ax
801047af:	90                   	nop

801047b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801047b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801047b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801047bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801047c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801047c9:	5d                   	pop    %ebp
801047ca:	c3                   	ret    
801047cb:	90                   	nop
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801047d4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801047d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801047da:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801047dd:	31 c0                	xor    %eax,%eax
801047df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801047e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047ec:	77 1a                	ja     80104808 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801047ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801047f1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047f4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801047f7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047f9:	83 f8 0a             	cmp    $0xa,%eax
801047fc:	75 e2                	jne    801047e0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801047fe:	5b                   	pop    %ebx
801047ff:	5d                   	pop    %ebp
80104800:	c3                   	ret    
80104801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104808:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010480f:	83 c0 01             	add    $0x1,%eax
80104812:	83 f8 0a             	cmp    $0xa,%eax
80104815:	74 e7                	je     801047fe <getcallerpcs+0x2e>
    pcs[i] = 0;
80104817:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010481e:	83 c0 01             	add    $0x1,%eax
80104821:	83 f8 0a             	cmp    $0xa,%eax
80104824:	75 e2                	jne    80104808 <getcallerpcs+0x38>
80104826:	eb d6                	jmp    801047fe <getcallerpcs+0x2e>
80104828:	90                   	nop
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 04             	sub    $0x4,%esp
80104837:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010483a:	8b 02                	mov    (%edx),%eax
8010483c:	85 c0                	test   %eax,%eax
8010483e:	75 10                	jne    80104850 <holding+0x20>
}
80104840:	83 c4 04             	add    $0x4,%esp
80104843:	31 c0                	xor    %eax,%eax
80104845:	5b                   	pop    %ebx
80104846:	5d                   	pop    %ebp
80104847:	c3                   	ret    
80104848:	90                   	nop
80104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104850:	8b 5a 08             	mov    0x8(%edx),%ebx
80104853:	e8 b8 f2 ff ff       	call   80103b10 <mycpu>
80104858:	39 c3                	cmp    %eax,%ebx
8010485a:	0f 94 c0             	sete   %al
}
8010485d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104860:	0f b6 c0             	movzbl %al,%eax
}
80104863:	5b                   	pop    %ebx
80104864:	5d                   	pop    %ebp
80104865:	c3                   	ret    
80104866:	8d 76 00             	lea    0x0(%esi),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 04             	sub    $0x4,%esp
80104877:	9c                   	pushf  
80104878:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104879:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010487a:	e8 91 f2 ff ff       	call   80103b10 <mycpu>
8010487f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104885:	85 c0                	test   %eax,%eax
80104887:	75 11                	jne    8010489a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104889:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010488f:	e8 7c f2 ff ff       	call   80103b10 <mycpu>
80104894:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010489a:	e8 71 f2 ff ff       	call   80103b10 <mycpu>
8010489f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048a6:	83 c4 04             	add    $0x4,%esp
801048a9:	5b                   	pop    %ebx
801048aa:	5d                   	pop    %ebp
801048ab:	c3                   	ret    
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048b0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801048b5:	e8 b6 ff ff ff       	call   80104870 <pushcli>
  if(holding(lk))
801048ba:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801048bd:	8b 03                	mov    (%ebx),%eax
801048bf:	85 c0                	test   %eax,%eax
801048c1:	75 7d                	jne    80104940 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801048c3:	ba 01 00 00 00       	mov    $0x1,%edx
801048c8:	eb 09                	jmp    801048d3 <acquire+0x23>
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048d3:	89 d0                	mov    %edx,%eax
801048d5:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801048d8:	85 c0                	test   %eax,%eax
801048da:	75 f4                	jne    801048d0 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801048dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801048e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048e4:	e8 27 f2 ff ff       	call   80103b10 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048e9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801048eb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801048ee:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048f1:	31 c0                	xor    %eax,%eax
801048f3:	90                   	nop
801048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048f8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048fe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104904:	77 1a                	ja     80104920 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104906:	8b 5a 04             	mov    0x4(%edx),%ebx
80104909:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010490c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
8010490f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104911:	83 f8 0a             	cmp    $0xa,%eax
80104914:	75 e2                	jne    801048f8 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104916:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104919:	5b                   	pop    %ebx
8010491a:	5e                   	pop    %esi
8010491b:	5d                   	pop    %ebp
8010491c:	c3                   	ret    
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104920:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104927:	83 c0 01             	add    $0x1,%eax
8010492a:	83 f8 0a             	cmp    $0xa,%eax
8010492d:	74 e7                	je     80104916 <acquire+0x66>
    pcs[i] = 0;
8010492f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104936:	83 c0 01             	add    $0x1,%eax
80104939:	83 f8 0a             	cmp    $0xa,%eax
8010493c:	75 e2                	jne    80104920 <acquire+0x70>
8010493e:	eb d6                	jmp    80104916 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104940:	8b 73 08             	mov    0x8(%ebx),%esi
80104943:	e8 c8 f1 ff ff       	call   80103b10 <mycpu>
80104948:	39 c6                	cmp    %eax,%esi
8010494a:	0f 85 73 ff ff ff    	jne    801048c3 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104950:	83 ec 0c             	sub    $0xc,%esp
80104953:	68 a3 7b 10 80       	push   $0x80107ba3
80104958:	e8 13 ba ff ff       	call   80100370 <panic>
8010495d:	8d 76 00             	lea    0x0(%esi),%esi

80104960 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104966:	9c                   	pushf  
80104967:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104968:	f6 c4 02             	test   $0x2,%ah
8010496b:	75 52                	jne    801049bf <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010496d:	e8 9e f1 ff ff       	call   80103b10 <mycpu>
80104972:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104978:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010497b:	85 d2                	test   %edx,%edx
8010497d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104983:	78 2d                	js     801049b2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104985:	e8 86 f1 ff ff       	call   80103b10 <mycpu>
8010498a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104990:	85 d2                	test   %edx,%edx
80104992:	74 0c                	je     801049a0 <popcli+0x40>
    sti();
}
80104994:	c9                   	leave  
80104995:	c3                   	ret    
80104996:	8d 76 00             	lea    0x0(%esi),%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049a0:	e8 6b f1 ff ff       	call   80103b10 <mycpu>
801049a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049ab:	85 c0                	test   %eax,%eax
801049ad:	74 e5                	je     80104994 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801049af:	fb                   	sti    
    sti();
}
801049b0:	c9                   	leave  
801049b1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
801049b2:	83 ec 0c             	sub    $0xc,%esp
801049b5:	68 c2 7b 10 80       	push   $0x80107bc2
801049ba:	e8 b1 b9 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801049bf:	83 ec 0c             	sub    $0xc,%esp
801049c2:	68 ab 7b 10 80       	push   $0x80107bab
801049c7:	e8 a4 b9 ff ff       	call   80100370 <panic>
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049d0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801049d8:	8b 03                	mov    (%ebx),%eax
801049da:	85 c0                	test   %eax,%eax
801049dc:	75 12                	jne    801049f0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801049de:	83 ec 0c             	sub    $0xc,%esp
801049e1:	68 c9 7b 10 80       	push   $0x80107bc9
801049e6:	e8 85 b9 ff ff       	call   80100370 <panic>
801049eb:	90                   	nop
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801049f0:	8b 73 08             	mov    0x8(%ebx),%esi
801049f3:	e8 18 f1 ff ff       	call   80103b10 <mycpu>
801049f8:	39 c6                	cmp    %eax,%esi
801049fa:	75 e2                	jne    801049de <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
801049fc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a03:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104a0a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a0f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104a15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a18:	5b                   	pop    %ebx
80104a19:	5e                   	pop    %esi
80104a1a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104a1b:	e9 40 ff ff ff       	jmp    80104960 <popcli>

80104a20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	53                   	push   %ebx
80104a25:	8b 55 08             	mov    0x8(%ebp),%edx
80104a28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a2b:	f6 c2 03             	test   $0x3,%dl
80104a2e:	75 05                	jne    80104a35 <memset+0x15>
80104a30:	f6 c1 03             	test   $0x3,%cl
80104a33:	74 13                	je     80104a48 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104a35:	89 d7                	mov    %edx,%edi
80104a37:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a3a:	fc                   	cld    
80104a3b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a3d:	5b                   	pop    %ebx
80104a3e:	89 d0                	mov    %edx,%eax
80104a40:	5f                   	pop    %edi
80104a41:	5d                   	pop    %ebp
80104a42:	c3                   	ret    
80104a43:	90                   	nop
80104a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104a48:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104a4c:	c1 e9 02             	shr    $0x2,%ecx
80104a4f:	89 fb                	mov    %edi,%ebx
80104a51:	89 f8                	mov    %edi,%eax
80104a53:	c1 e3 18             	shl    $0x18,%ebx
80104a56:	c1 e0 10             	shl    $0x10,%eax
80104a59:	09 d8                	or     %ebx,%eax
80104a5b:	09 f8                	or     %edi,%eax
80104a5d:	c1 e7 08             	shl    $0x8,%edi
80104a60:	09 f8                	or     %edi,%eax
80104a62:	89 d7                	mov    %edx,%edi
80104a64:	fc                   	cld    
80104a65:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a67:	5b                   	pop    %ebx
80104a68:	89 d0                	mov    %edx,%eax
80104a6a:	5f                   	pop    %edi
80104a6b:	5d                   	pop    %ebp
80104a6c:	c3                   	ret    
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
80104a75:	8b 45 10             	mov    0x10(%ebp),%eax
80104a78:	53                   	push   %ebx
80104a79:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a7f:	85 c0                	test   %eax,%eax
80104a81:	74 29                	je     80104aac <memcmp+0x3c>
    if(*s1 != *s2)
80104a83:	0f b6 13             	movzbl (%ebx),%edx
80104a86:	0f b6 0e             	movzbl (%esi),%ecx
80104a89:	38 d1                	cmp    %dl,%cl
80104a8b:	75 2b                	jne    80104ab8 <memcmp+0x48>
80104a8d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104a90:	31 c0                	xor    %eax,%eax
80104a92:	eb 14                	jmp    80104aa8 <memcmp+0x38>
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a98:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104a9d:	83 c0 01             	add    $0x1,%eax
80104aa0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104aa4:	38 ca                	cmp    %cl,%dl
80104aa6:	75 10                	jne    80104ab8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104aa8:	39 f8                	cmp    %edi,%eax
80104aaa:	75 ec                	jne    80104a98 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104aac:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104aad:	31 c0                	xor    %eax,%eax
}
80104aaf:	5e                   	pop    %esi
80104ab0:	5f                   	pop    %edi
80104ab1:	5d                   	pop    %ebp
80104ab2:	c3                   	ret    
80104ab3:	90                   	nop
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104ab8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104abb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104abc:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104abe:	5e                   	pop    %esi
80104abf:	5f                   	pop    %edi
80104ac0:	5d                   	pop    %ebp
80104ac1:	c3                   	ret    
80104ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ad8:	8b 75 0c             	mov    0xc(%ebp),%esi
80104adb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ade:	39 c6                	cmp    %eax,%esi
80104ae0:	73 2e                	jae    80104b10 <memmove+0x40>
80104ae2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104ae5:	39 c8                	cmp    %ecx,%eax
80104ae7:	73 27                	jae    80104b10 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104ae9:	85 db                	test   %ebx,%ebx
80104aeb:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104aee:	74 17                	je     80104b07 <memmove+0x37>
      *--d = *--s;
80104af0:	29 d9                	sub    %ebx,%ecx
80104af2:	89 cb                	mov    %ecx,%ebx
80104af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104af8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104afc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104aff:	83 ea 01             	sub    $0x1,%edx
80104b02:	83 fa ff             	cmp    $0xffffffff,%edx
80104b05:	75 f1                	jne    80104af8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b07:	5b                   	pop    %ebx
80104b08:	5e                   	pop    %esi
80104b09:	5d                   	pop    %ebp
80104b0a:	c3                   	ret    
80104b0b:	90                   	nop
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104b10:	31 d2                	xor    %edx,%edx
80104b12:	85 db                	test   %ebx,%ebx
80104b14:	74 f1                	je     80104b07 <memmove+0x37>
80104b16:	8d 76 00             	lea    0x0(%esi),%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104b20:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104b24:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b27:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104b2a:	39 d3                	cmp    %edx,%ebx
80104b2c:	75 f2                	jne    80104b20 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104b2e:	5b                   	pop    %ebx
80104b2f:	5e                   	pop    %esi
80104b30:	5d                   	pop    %ebp
80104b31:	c3                   	ret    
80104b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b43:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104b44:	eb 8a                	jmp    80104ad0 <memmove>
80104b46:	8d 76 00             	lea    0x0(%esi),%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	57                   	push   %edi
80104b54:	56                   	push   %esi
80104b55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b58:	53                   	push   %ebx
80104b59:	8b 7d 08             	mov    0x8(%ebp),%edi
80104b5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b5f:	85 c9                	test   %ecx,%ecx
80104b61:	74 37                	je     80104b9a <strncmp+0x4a>
80104b63:	0f b6 17             	movzbl (%edi),%edx
80104b66:	0f b6 1e             	movzbl (%esi),%ebx
80104b69:	84 d2                	test   %dl,%dl
80104b6b:	74 3f                	je     80104bac <strncmp+0x5c>
80104b6d:	38 d3                	cmp    %dl,%bl
80104b6f:	75 3b                	jne    80104bac <strncmp+0x5c>
80104b71:	8d 47 01             	lea    0x1(%edi),%eax
80104b74:	01 cf                	add    %ecx,%edi
80104b76:	eb 1b                	jmp    80104b93 <strncmp+0x43>
80104b78:	90                   	nop
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b80:	0f b6 10             	movzbl (%eax),%edx
80104b83:	84 d2                	test   %dl,%dl
80104b85:	74 21                	je     80104ba8 <strncmp+0x58>
80104b87:	0f b6 19             	movzbl (%ecx),%ebx
80104b8a:	83 c0 01             	add    $0x1,%eax
80104b8d:	89 ce                	mov    %ecx,%esi
80104b8f:	38 da                	cmp    %bl,%dl
80104b91:	75 19                	jne    80104bac <strncmp+0x5c>
80104b93:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104b95:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104b98:	75 e6                	jne    80104b80 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104b9a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104b9b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104b9d:	5e                   	pop    %esi
80104b9e:	5f                   	pop    %edi
80104b9f:	5d                   	pop    %ebp
80104ba0:	c3                   	ret    
80104ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104bac:	0f b6 c2             	movzbl %dl,%eax
80104baf:	29 d8                	sub    %ebx,%eax
}
80104bb1:	5b                   	pop    %ebx
80104bb2:	5e                   	pop    %esi
80104bb3:	5f                   	pop    %edi
80104bb4:	5d                   	pop    %ebp
80104bb5:	c3                   	ret    
80104bb6:	8d 76 00             	lea    0x0(%esi),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104bcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104bce:	89 c2                	mov    %eax,%edx
80104bd0:	eb 19                	jmp    80104beb <strncpy+0x2b>
80104bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bd8:	83 c3 01             	add    $0x1,%ebx
80104bdb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104bdf:	83 c2 01             	add    $0x1,%edx
80104be2:	84 c9                	test   %cl,%cl
80104be4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104be7:	74 09                	je     80104bf2 <strncpy+0x32>
80104be9:	89 f1                	mov    %esi,%ecx
80104beb:	85 c9                	test   %ecx,%ecx
80104bed:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104bf0:	7f e6                	jg     80104bd8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104bf2:	31 c9                	xor    %ecx,%ecx
80104bf4:	85 f6                	test   %esi,%esi
80104bf6:	7e 17                	jle    80104c0f <strncpy+0x4f>
80104bf8:	90                   	nop
80104bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c00:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c04:	89 f3                	mov    %esi,%ebx
80104c06:	83 c1 01             	add    $0x1,%ecx
80104c09:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104c0b:	85 db                	test   %ebx,%ebx
80104c0d:	7f f1                	jg     80104c00 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104c0f:	5b                   	pop    %ebx
80104c10:	5e                   	pop    %esi
80104c11:	5d                   	pop    %ebp
80104c12:	c3                   	ret    
80104c13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c28:	8b 45 08             	mov    0x8(%ebp),%eax
80104c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c2e:	85 c9                	test   %ecx,%ecx
80104c30:	7e 26                	jle    80104c58 <safestrcpy+0x38>
80104c32:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c36:	89 c1                	mov    %eax,%ecx
80104c38:	eb 17                	jmp    80104c51 <safestrcpy+0x31>
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c40:	83 c2 01             	add    $0x1,%edx
80104c43:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c47:	83 c1 01             	add    $0x1,%ecx
80104c4a:	84 db                	test   %bl,%bl
80104c4c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c4f:	74 04                	je     80104c55 <safestrcpy+0x35>
80104c51:	39 f2                	cmp    %esi,%edx
80104c53:	75 eb                	jne    80104c40 <safestrcpy+0x20>
    ;
  *s = 0;
80104c55:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c58:	5b                   	pop    %ebx
80104c59:	5e                   	pop    %esi
80104c5a:	5d                   	pop    %ebp
80104c5b:	c3                   	ret    
80104c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c60 <strlen>:

int
strlen(const char *s)
{
80104c60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c61:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104c68:	80 3a 00             	cmpb   $0x0,(%edx)
80104c6b:	74 0c                	je     80104c79 <strlen+0x19>
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
80104c70:	83 c0 01             	add    $0x1,%eax
80104c73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c77:	75 f7                	jne    80104c70 <strlen+0x10>
    ;
  return n;
}
80104c79:	5d                   	pop    %ebp
80104c7a:	c3                   	ret    

80104c7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104c83:	55                   	push   %ebp
  pushl %ebx
80104c84:	53                   	push   %ebx
  pushl %esi
80104c85:	56                   	push   %esi
  pushl %edi
80104c86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c89:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104c8b:	5f                   	pop    %edi
  popl %esi
80104c8c:	5e                   	pop    %esi
  popl %ebx
80104c8d:	5b                   	pop    %ebx
  popl %ebp
80104c8e:	5d                   	pop    %ebp
  ret
80104c8f:	c3                   	ret    

80104c90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
80104c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c9a:	e8 11 ef ff ff       	call   80103bb0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c9f:	8b 00                	mov    (%eax),%eax
80104ca1:	39 d8                	cmp    %ebx,%eax
80104ca3:	76 1b                	jbe    80104cc0 <fetchint+0x30>
80104ca5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ca8:	39 d0                	cmp    %edx,%eax
80104caa:	72 14                	jb     80104cc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104cac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104caf:	8b 13                	mov    (%ebx),%edx
80104cb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104cb3:	31 c0                	xor    %eax,%eax
}
80104cb5:	83 c4 04             	add    $0x4,%esp
80104cb8:	5b                   	pop    %ebx
80104cb9:	5d                   	pop    %ebp
80104cba:	c3                   	ret    
80104cbb:	90                   	nop
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cc5:	eb ee                	jmp    80104cb5 <fetchint+0x25>
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	53                   	push   %ebx
80104cd4:	83 ec 04             	sub    $0x4,%esp
80104cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104cda:	e8 d1 ee ff ff       	call   80103bb0 <myproc>

  if(addr >= curproc->sz)
80104cdf:	39 18                	cmp    %ebx,(%eax)
80104ce1:	76 29                	jbe    80104d0c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104ce3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ce6:	89 da                	mov    %ebx,%edx
80104ce8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104cea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104cec:	39 c3                	cmp    %eax,%ebx
80104cee:	73 1c                	jae    80104d0c <fetchstr+0x3c>
    if(*s == 0)
80104cf0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104cf3:	75 10                	jne    80104d05 <fetchstr+0x35>
80104cf5:	eb 29                	jmp    80104d20 <fetchstr+0x50>
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d00:	80 3a 00             	cmpb   $0x0,(%edx)
80104d03:	74 1b                	je     80104d20 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104d05:	83 c2 01             	add    $0x1,%edx
80104d08:	39 d0                	cmp    %edx,%eax
80104d0a:	77 f4                	ja     80104d00 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104d0c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104d14:	5b                   	pop    %ebx
80104d15:	5d                   	pop    %ebp
80104d16:	c3                   	ret    
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d20:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104d23:	89 d0                	mov    %edx,%eax
80104d25:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104d27:	5b                   	pop    %ebx
80104d28:	5d                   	pop    %ebp
80104d29:	c3                   	ret    
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d35:	e8 76 ee ff ff       	call   80103bb0 <myproc>
80104d3a:	8b 40 18             	mov    0x18(%eax),%eax
80104d3d:	8b 55 08             	mov    0x8(%ebp),%edx
80104d40:	8b 40 44             	mov    0x44(%eax),%eax
80104d43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104d46:	e8 65 ee ff ff       	call   80103bb0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d4b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d4d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d50:	39 c6                	cmp    %eax,%esi
80104d52:	73 1c                	jae    80104d70 <argint+0x40>
80104d54:	8d 53 08             	lea    0x8(%ebx),%edx
80104d57:	39 d0                	cmp    %edx,%eax
80104d59:	72 15                	jb     80104d70 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d5e:	8b 53 04             	mov    0x4(%ebx),%edx
80104d61:	89 10                	mov    %edx,(%eax)
  return 0;
80104d63:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104d65:	5b                   	pop    %ebx
80104d66:	5e                   	pop    %esi
80104d67:	5d                   	pop    %ebp
80104d68:	c3                   	ret    
80104d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d75:	eb ee                	jmp    80104d65 <argint+0x35>
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
80104d85:	83 ec 10             	sub    $0x10,%esp
80104d88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104d8b:	e8 20 ee ff ff       	call   80103bb0 <myproc>
80104d90:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104d92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d95:	83 ec 08             	sub    $0x8,%esp
80104d98:	50                   	push   %eax
80104d99:	ff 75 08             	pushl  0x8(%ebp)
80104d9c:	e8 8f ff ff ff       	call   80104d30 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104da1:	c1 e8 1f             	shr    $0x1f,%eax
80104da4:	83 c4 10             	add    $0x10,%esp
80104da7:	84 c0                	test   %al,%al
80104da9:	75 2d                	jne    80104dd8 <argptr+0x58>
80104dab:	89 d8                	mov    %ebx,%eax
80104dad:	c1 e8 1f             	shr    $0x1f,%eax
80104db0:	84 c0                	test   %al,%al
80104db2:	75 24                	jne    80104dd8 <argptr+0x58>
80104db4:	8b 16                	mov    (%esi),%edx
80104db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db9:	39 c2                	cmp    %eax,%edx
80104dbb:	76 1b                	jbe    80104dd8 <argptr+0x58>
80104dbd:	01 c3                	add    %eax,%ebx
80104dbf:	39 da                	cmp    %ebx,%edx
80104dc1:	72 15                	jb     80104dd8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dc6:	89 02                	mov    %eax,(%edx)
  return 0;
80104dc8:	31 c0                	xor    %eax,%eax
}
80104dca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dcd:	5b                   	pop    %ebx
80104dce:	5e                   	pop    %esi
80104dcf:	5d                   	pop    %ebp
80104dd0:	c3                   	ret    
80104dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ddd:	eb eb                	jmp    80104dca <argptr+0x4a>
80104ddf:	90                   	nop

80104de0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104de6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104de9:	50                   	push   %eax
80104dea:	ff 75 08             	pushl  0x8(%ebp)
80104ded:	e8 3e ff ff ff       	call   80104d30 <argint>
80104df2:	83 c4 10             	add    $0x10,%esp
80104df5:	85 c0                	test   %eax,%eax
80104df7:	78 17                	js     80104e10 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104df9:	83 ec 08             	sub    $0x8,%esp
80104dfc:	ff 75 0c             	pushl  0xc(%ebp)
80104dff:	ff 75 f4             	pushl  -0xc(%ebp)
80104e02:	e8 c9 fe ff ff       	call   80104cd0 <fetchstr>
80104e07:	83 c4 10             	add    $0x10,%esp
}
80104e0a:	c9                   	leave  
80104e0b:	c3                   	ret    
80104e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104e15:	c9                   	leave  
80104e16:	c3                   	ret    
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104e25:	e8 86 ed ff ff       	call   80103bb0 <myproc>

  num = curproc->tf->eax;
80104e2a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104e2d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e2f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e32:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e35:	83 fa 15             	cmp    $0x15,%edx
80104e38:	77 1e                	ja     80104e58 <syscall+0x38>
80104e3a:	8b 14 85 00 7c 10 80 	mov    -0x7fef8400(,%eax,4),%edx
80104e41:	85 d2                	test   %edx,%edx
80104e43:	74 13                	je     80104e58 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104e45:	ff d2                	call   *%edx
80104e47:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e4d:	5b                   	pop    %ebx
80104e4e:	5e                   	pop    %esi
80104e4f:	5d                   	pop    %ebp
80104e50:	c3                   	ret    
80104e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104e58:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e59:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104e5c:	50                   	push   %eax
80104e5d:	ff 73 10             	pushl  0x10(%ebx)
80104e60:	68 d1 7b 10 80       	push   $0x80107bd1
80104e65:	e8 f6 b7 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104e6a:	8b 43 18             	mov    0x18(%ebx),%eax
80104e6d:	83 c4 10             	add    $0x10,%esp
80104e70:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104e77:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e7a:	5b                   	pop    %ebx
80104e7b:	5e                   	pop    %esi
80104e7c:	5d                   	pop    %ebp
80104e7d:	c3                   	ret    
80104e7e:	66 90                	xchg   %ax,%ax

80104e80 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
80104e85:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104e87:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104e8a:	89 d3                	mov    %edx,%ebx
80104e8c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104e8f:	50                   	push   %eax
80104e90:	6a 00                	push   $0x0
80104e92:	e8 99 fe ff ff       	call   80104d30 <argint>
80104e97:	83 c4 10             	add    $0x10,%esp
80104e9a:	85 c0                	test   %eax,%eax
80104e9c:	78 32                	js     80104ed0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e9e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ea2:	77 2c                	ja     80104ed0 <argfd.constprop.0+0x50>
80104ea4:	e8 07 ed ff ff       	call   80103bb0 <myproc>
80104ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104eac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104eb0:	85 c0                	test   %eax,%eax
80104eb2:	74 1c                	je     80104ed0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104eb4:	85 f6                	test   %esi,%esi
80104eb6:	74 02                	je     80104eba <argfd.constprop.0+0x3a>
    *pfd = fd;
80104eb8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104eba:	85 db                	test   %ebx,%ebx
80104ebc:	74 22                	je     80104ee0 <argfd.constprop.0+0x60>
    *pf = f;
80104ebe:	89 03                	mov    %eax,(%ebx)
  return 0;
80104ec0:	31 c0                	xor    %eax,%eax
}
80104ec2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec5:	5b                   	pop    %ebx
80104ec6:	5e                   	pop    %esi
80104ec7:	5d                   	pop    %ebp
80104ec8:	c3                   	ret    
80104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104ed3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104ed8:	5b                   	pop    %ebx
80104ed9:	5e                   	pop    %esi
80104eda:	5d                   	pop    %ebp
80104edb:	c3                   	ret    
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104ee0:	31 c0                	xor    %eax,%eax
80104ee2:	eb de                	jmp    80104ec2 <argfd.constprop.0+0x42>
80104ee4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104eea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ef0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104ef0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ef1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104ef3:	89 e5                	mov    %esp,%ebp
80104ef5:	56                   	push   %esi
80104ef6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ef7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104efa:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104efd:	e8 7e ff ff ff       	call   80104e80 <argfd.constprop.0>
80104f02:	85 c0                	test   %eax,%eax
80104f04:	78 1a                	js     80104f20 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104f06:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104f08:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104f0b:	e8 a0 ec ff ff       	call   80103bb0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104f10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f14:	85 d2                	test   %edx,%edx
80104f16:	74 18                	je     80104f30 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104f18:	83 c3 01             	add    $0x1,%ebx
80104f1b:	83 fb 10             	cmp    $0x10,%ebx
80104f1e:	75 f0                	jne    80104f10 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104f20:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104f28:	5b                   	pop    %ebx
80104f29:	5e                   	pop    %esi
80104f2a:	5d                   	pop    %ebp
80104f2b:	c3                   	ret    
80104f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104f30:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104f34:	83 ec 0c             	sub    $0xc,%esp
80104f37:	ff 75 f4             	pushl  -0xc(%ebp)
80104f3a:	e8 d1 be ff ff       	call   80100e10 <filedup>
  return fd;
80104f3f:	83 c4 10             	add    $0x10,%esp
}
80104f42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104f45:	89 d8                	mov    %ebx,%eax
}
80104f47:	5b                   	pop    %ebx
80104f48:	5e                   	pop    %esi
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret    
80104f4b:	90                   	nop
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f50 <sys_read>:

int
sys_read(void)
{
80104f50:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f51:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104f53:	89 e5                	mov    %esp,%ebp
80104f55:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f5b:	e8 20 ff ff ff       	call   80104e80 <argfd.constprop.0>
80104f60:	85 c0                	test   %eax,%eax
80104f62:	78 4c                	js     80104fb0 <sys_read+0x60>
80104f64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f67:	83 ec 08             	sub    $0x8,%esp
80104f6a:	50                   	push   %eax
80104f6b:	6a 02                	push   $0x2
80104f6d:	e8 be fd ff ff       	call   80104d30 <argint>
80104f72:	83 c4 10             	add    $0x10,%esp
80104f75:	85 c0                	test   %eax,%eax
80104f77:	78 37                	js     80104fb0 <sys_read+0x60>
80104f79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f7c:	83 ec 04             	sub    $0x4,%esp
80104f7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f82:	50                   	push   %eax
80104f83:	6a 01                	push   $0x1
80104f85:	e8 f6 fd ff ff       	call   80104d80 <argptr>
80104f8a:	83 c4 10             	add    $0x10,%esp
80104f8d:	85 c0                	test   %eax,%eax
80104f8f:	78 1f                	js     80104fb0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104f91:	83 ec 04             	sub    $0x4,%esp
80104f94:	ff 75 f0             	pushl  -0x10(%ebp)
80104f97:	ff 75 f4             	pushl  -0xc(%ebp)
80104f9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f9d:	e8 de bf ff ff       	call   80100f80 <fileread>
80104fa2:	83 c4 10             	add    $0x10,%esp
}
80104fa5:	c9                   	leave  
80104fa6:	c3                   	ret    
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104fb5:	c9                   	leave  
80104fb6:	c3                   	ret    
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <sys_write>:

int
sys_write(void)
{
80104fc0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fc1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104fc3:	89 e5                	mov    %esp,%ebp
80104fc5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104fcb:	e8 b0 fe ff ff       	call   80104e80 <argfd.constprop.0>
80104fd0:	85 c0                	test   %eax,%eax
80104fd2:	78 4c                	js     80105020 <sys_write+0x60>
80104fd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd7:	83 ec 08             	sub    $0x8,%esp
80104fda:	50                   	push   %eax
80104fdb:	6a 02                	push   $0x2
80104fdd:	e8 4e fd ff ff       	call   80104d30 <argint>
80104fe2:	83 c4 10             	add    $0x10,%esp
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	78 37                	js     80105020 <sys_write+0x60>
80104fe9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fec:	83 ec 04             	sub    $0x4,%esp
80104fef:	ff 75 f0             	pushl  -0x10(%ebp)
80104ff2:	50                   	push   %eax
80104ff3:	6a 01                	push   $0x1
80104ff5:	e8 86 fd ff ff       	call   80104d80 <argptr>
80104ffa:	83 c4 10             	add    $0x10,%esp
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	78 1f                	js     80105020 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105001:	83 ec 04             	sub    $0x4,%esp
80105004:	ff 75 f0             	pushl  -0x10(%ebp)
80105007:	ff 75 f4             	pushl  -0xc(%ebp)
8010500a:	ff 75 ec             	pushl  -0x14(%ebp)
8010500d:	e8 fe bf ff ff       	call   80101010 <filewrite>
80105012:	83 c4 10             	add    $0x10,%esp
}
80105015:	c9                   	leave  
80105016:	c3                   	ret    
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105025:	c9                   	leave  
80105026:	c3                   	ret    
80105027:	89 f6                	mov    %esi,%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <sys_close>:

int
sys_close(void)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105036:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105039:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010503c:	e8 3f fe ff ff       	call   80104e80 <argfd.constprop.0>
80105041:	85 c0                	test   %eax,%eax
80105043:	78 2b                	js     80105070 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105045:	e8 66 eb ff ff       	call   80103bb0 <myproc>
8010504a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010504d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105050:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105057:	00 
  fileclose(f);
80105058:	ff 75 f4             	pushl  -0xc(%ebp)
8010505b:	e8 00 be ff ff       	call   80100e60 <fileclose>
  return 0;
80105060:	83 c4 10             	add    $0x10,%esp
80105063:	31 c0                	xor    %eax,%eax
}
80105065:	c9                   	leave  
80105066:	c3                   	ret    
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105075:	c9                   	leave  
80105076:	c3                   	ret    
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <sys_fstat>:

int
sys_fstat(void)
{
80105080:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105081:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105083:	89 e5                	mov    %esp,%ebp
80105085:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105088:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010508b:	e8 f0 fd ff ff       	call   80104e80 <argfd.constprop.0>
80105090:	85 c0                	test   %eax,%eax
80105092:	78 2c                	js     801050c0 <sys_fstat+0x40>
80105094:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105097:	83 ec 04             	sub    $0x4,%esp
8010509a:	6a 14                	push   $0x14
8010509c:	50                   	push   %eax
8010509d:	6a 01                	push   $0x1
8010509f:	e8 dc fc ff ff       	call   80104d80 <argptr>
801050a4:	83 c4 10             	add    $0x10,%esp
801050a7:	85 c0                	test   %eax,%eax
801050a9:	78 15                	js     801050c0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801050ab:	83 ec 08             	sub    $0x8,%esp
801050ae:	ff 75 f4             	pushl  -0xc(%ebp)
801050b1:	ff 75 f0             	pushl  -0x10(%ebp)
801050b4:	e8 77 be ff ff       	call   80100f30 <filestat>
801050b9:	83 c4 10             	add    $0x10,%esp
}
801050bc:	c9                   	leave  
801050bd:	c3                   	ret    
801050be:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
801050c5:	c9                   	leave  
801050c6:	c3                   	ret    
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	57                   	push   %edi
801050d4:	56                   	push   %esi
801050d5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801050d9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050dc:	50                   	push   %eax
801050dd:	6a 00                	push   $0x0
801050df:	e8 fc fc ff ff       	call   80104de0 <argstr>
801050e4:	83 c4 10             	add    $0x10,%esp
801050e7:	85 c0                	test   %eax,%eax
801050e9:	0f 88 fb 00 00 00    	js     801051ea <sys_link+0x11a>
801050ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050f2:	83 ec 08             	sub    $0x8,%esp
801050f5:	50                   	push   %eax
801050f6:	6a 01                	push   $0x1
801050f8:	e8 e3 fc ff ff       	call   80104de0 <argstr>
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	85 c0                	test   %eax,%eax
80105102:	0f 88 e2 00 00 00    	js     801051ea <sys_link+0x11a>
    return -1;

  begin_op();
80105108:	e8 13 de ff ff       	call   80102f20 <begin_op>
  if((ip = namei(old)) == 0){
8010510d:	83 ec 0c             	sub    $0xc,%esp
80105110:	ff 75 d4             	pushl  -0x2c(%ebp)
80105113:	e8 d8 cd ff ff       	call   80101ef0 <namei>
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	85 c0                	test   %eax,%eax
8010511d:	89 c3                	mov    %eax,%ebx
8010511f:	0f 84 f3 00 00 00    	je     80105218 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105125:	83 ec 0c             	sub    $0xc,%esp
80105128:	50                   	push   %eax
80105129:	e8 72 c5 ff ff       	call   801016a0 <ilock>
  if(ip->type == T_DIR){
8010512e:	83 c4 10             	add    $0x10,%esp
80105131:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105136:	0f 84 c4 00 00 00    	je     80105200 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010513c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105141:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105144:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105147:	53                   	push   %ebx
80105148:	e8 a3 c4 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
8010514d:	89 1c 24             	mov    %ebx,(%esp)
80105150:	e8 2b c6 ff ff       	call   80101780 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105155:	58                   	pop    %eax
80105156:	5a                   	pop    %edx
80105157:	57                   	push   %edi
80105158:	ff 75 d0             	pushl  -0x30(%ebp)
8010515b:	e8 b0 cd ff ff       	call   80101f10 <nameiparent>
80105160:	83 c4 10             	add    $0x10,%esp
80105163:	85 c0                	test   %eax,%eax
80105165:	89 c6                	mov    %eax,%esi
80105167:	74 5b                	je     801051c4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105169:	83 ec 0c             	sub    $0xc,%esp
8010516c:	50                   	push   %eax
8010516d:	e8 2e c5 ff ff       	call   801016a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105172:	83 c4 10             	add    $0x10,%esp
80105175:	8b 03                	mov    (%ebx),%eax
80105177:	39 06                	cmp    %eax,(%esi)
80105179:	75 3d                	jne    801051b8 <sys_link+0xe8>
8010517b:	83 ec 04             	sub    $0x4,%esp
8010517e:	ff 73 04             	pushl  0x4(%ebx)
80105181:	57                   	push   %edi
80105182:	56                   	push   %esi
80105183:	e8 a8 cc ff ff       	call   80101e30 <dirlink>
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	85 c0                	test   %eax,%eax
8010518d:	78 29                	js     801051b8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010518f:	83 ec 0c             	sub    $0xc,%esp
80105192:	56                   	push   %esi
80105193:	e8 98 c7 ff ff       	call   80101930 <iunlockput>
  iput(ip);
80105198:	89 1c 24             	mov    %ebx,(%esp)
8010519b:	e8 30 c6 ff ff       	call   801017d0 <iput>

  end_op();
801051a0:	e8 eb dd ff ff       	call   80102f90 <end_op>

  return 0;
801051a5:	83 c4 10             	add    $0x10,%esp
801051a8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801051aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ad:	5b                   	pop    %ebx
801051ae:	5e                   	pop    %esi
801051af:	5f                   	pop    %edi
801051b0:	5d                   	pop    %ebp
801051b1:	c3                   	ret    
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
801051b8:	83 ec 0c             	sub    $0xc,%esp
801051bb:	56                   	push   %esi
801051bc:	e8 6f c7 ff ff       	call   80101930 <iunlockput>
    goto bad;
801051c1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	53                   	push   %ebx
801051c8:	e8 d3 c4 ff ff       	call   801016a0 <ilock>
  ip->nlink--;
801051cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051d2:	89 1c 24             	mov    %ebx,(%esp)
801051d5:	e8 16 c4 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
801051da:	89 1c 24             	mov    %ebx,(%esp)
801051dd:	e8 4e c7 ff ff       	call   80101930 <iunlockput>
  end_op();
801051e2:	e8 a9 dd ff ff       	call   80102f90 <end_op>
  return -1;
801051e7:	83 c4 10             	add    $0x10,%esp
}
801051ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801051ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f2:	5b                   	pop    %ebx
801051f3:	5e                   	pop    %esi
801051f4:	5f                   	pop    %edi
801051f5:	5d                   	pop    %ebp
801051f6:	c3                   	ret    
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	53                   	push   %ebx
80105204:	e8 27 c7 ff ff       	call   80101930 <iunlockput>
    end_op();
80105209:	e8 82 dd ff ff       	call   80102f90 <end_op>
    return -1;
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105216:	eb 92                	jmp    801051aa <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105218:	e8 73 dd ff ff       	call   80102f90 <end_op>
    return -1;
8010521d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105222:	eb 86                	jmp    801051aa <sys_link+0xda>
80105224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010522a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105230 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	57                   	push   %edi
80105234:	56                   	push   %esi
80105235:	53                   	push   %ebx
80105236:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105239:	bb 20 00 00 00       	mov    $0x20,%ebx
8010523e:	83 ec 1c             	sub    $0x1c,%esp
80105241:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105244:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105248:	77 0e                	ja     80105258 <isdirempty+0x28>
8010524a:	eb 34                	jmp    80105280 <isdirempty+0x50>
8010524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105250:	83 c3 10             	add    $0x10,%ebx
80105253:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105256:	76 28                	jbe    80105280 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105258:	6a 10                	push   $0x10
8010525a:	53                   	push   %ebx
8010525b:	57                   	push   %edi
8010525c:	56                   	push   %esi
8010525d:	e8 1e c7 ff ff       	call   80101980 <readi>
80105262:	83 c4 10             	add    $0x10,%esp
80105265:	83 f8 10             	cmp    $0x10,%eax
80105268:	75 23                	jne    8010528d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010526a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010526f:	74 df                	je     80105250 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105271:	8d 65 f4             	lea    -0xc(%ebp),%esp

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
80105274:	31 c0                	xor    %eax,%eax
  }
  return 1;
}
80105276:	5b                   	pop    %ebx
80105277:	5e                   	pop    %esi
80105278:	5f                   	pop    %edi
80105279:	5d                   	pop    %ebp
8010527a:	c3                   	ret    
8010527b:	90                   	nop
8010527c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105280:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105283:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105288:	5b                   	pop    %ebx
80105289:	5e                   	pop    %esi
8010528a:	5f                   	pop    %edi
8010528b:	5d                   	pop    %ebp
8010528c:	c3                   	ret    
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010528d:	83 ec 0c             	sub    $0xc,%esp
80105290:	68 5c 7c 10 80       	push   $0x80107c5c
80105295:	e8 d6 b0 ff ff       	call   80100370 <panic>
8010529a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052a0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	57                   	push   %edi
801052a4:	56                   	push   %esi
801052a5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801052a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
801052a9:	83 ec 44             	sub    $0x44,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801052ac:	50                   	push   %eax
801052ad:	6a 00                	push   $0x0
801052af:	e8 2c fb ff ff       	call   80104de0 <argstr>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	0f 88 51 01 00 00    	js     80105410 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801052bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
801052c2:	e8 59 dc ff ff       	call   80102f20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052c7:	83 ec 08             	sub    $0x8,%esp
801052ca:	53                   	push   %ebx
801052cb:	ff 75 c0             	pushl  -0x40(%ebp)
801052ce:	e8 3d cc ff ff       	call   80101f10 <nameiparent>
801052d3:	83 c4 10             	add    $0x10,%esp
801052d6:	85 c0                	test   %eax,%eax
801052d8:	89 c6                	mov    %eax,%esi
801052da:	0f 84 37 01 00 00    	je     80105417 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	50                   	push   %eax
801052e4:	e8 b7 c3 ff ff       	call   801016a0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052e9:	58                   	pop    %eax
801052ea:	5a                   	pop    %edx
801052eb:	68 5d 76 10 80       	push   $0x8010765d
801052f0:	53                   	push   %ebx
801052f1:	e8 ba c8 ff ff       	call   80101bb0 <namecmp>
801052f6:	83 c4 10             	add    $0x10,%esp
801052f9:	85 c0                	test   %eax,%eax
801052fb:	0f 84 d3 00 00 00    	je     801053d4 <sys_unlink+0x134>
80105301:	83 ec 08             	sub    $0x8,%esp
80105304:	68 5c 76 10 80       	push   $0x8010765c
80105309:	53                   	push   %ebx
8010530a:	e8 a1 c8 ff ff       	call   80101bb0 <namecmp>
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	85 c0                	test   %eax,%eax
80105314:	0f 84 ba 00 00 00    	je     801053d4 <sys_unlink+0x134>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010531a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010531d:	83 ec 04             	sub    $0x4,%esp
80105320:	50                   	push   %eax
80105321:	53                   	push   %ebx
80105322:	56                   	push   %esi
80105323:	e8 a8 c8 ff ff       	call   80101bd0 <dirlookup>
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	85 c0                	test   %eax,%eax
8010532d:	89 c3                	mov    %eax,%ebx
8010532f:	0f 84 9f 00 00 00    	je     801053d4 <sys_unlink+0x134>
    goto bad;
  ilock(ip);
80105335:	83 ec 0c             	sub    $0xc,%esp
80105338:	50                   	push   %eax
80105339:	e8 62 c3 ff ff       	call   801016a0 <ilock>

  if(ip->nlink < 1)
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105346:	0f 8e e4 00 00 00    	jle    80105430 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010534c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105351:	74 65                	je     801053b8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105353:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105356:	83 ec 04             	sub    $0x4,%esp
80105359:	6a 10                	push   $0x10
8010535b:	6a 00                	push   $0x0
8010535d:	57                   	push   %edi
8010535e:	e8 bd f6 ff ff       	call   80104a20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105363:	6a 10                	push   $0x10
80105365:	ff 75 c4             	pushl  -0x3c(%ebp)
80105368:	57                   	push   %edi
80105369:	56                   	push   %esi
8010536a:	e8 11 c7 ff ff       	call   80101a80 <writei>
8010536f:	83 c4 20             	add    $0x20,%esp
80105372:	83 f8 10             	cmp    $0x10,%eax
80105375:	0f 85 a8 00 00 00    	jne    80105423 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010537b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105380:	74 76                	je     801053f8 <sys_unlink+0x158>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105382:	83 ec 0c             	sub    $0xc,%esp
80105385:	56                   	push   %esi
80105386:	e8 a5 c5 ff ff       	call   80101930 <iunlockput>

  ip->nlink--;
8010538b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105390:	89 1c 24             	mov    %ebx,(%esp)
80105393:	e8 58 c2 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
80105398:	89 1c 24             	mov    %ebx,(%esp)
8010539b:	e8 90 c5 ff ff       	call   80101930 <iunlockput>

  end_op();
801053a0:	e8 eb db ff ff       	call   80102f90 <end_op>

  return 0;
801053a5:	83 c4 10             	add    $0x10,%esp
801053a8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801053aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053ad:	5b                   	pop    %ebx
801053ae:	5e                   	pop    %esi
801053af:	5f                   	pop    %edi
801053b0:	5d                   	pop    %ebp
801053b1:	c3                   	ret    
801053b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801053b8:	83 ec 0c             	sub    $0xc,%esp
801053bb:	53                   	push   %ebx
801053bc:	e8 6f fe ff ff       	call   80105230 <isdirempty>
801053c1:	83 c4 10             	add    $0x10,%esp
801053c4:	85 c0                	test   %eax,%eax
801053c6:	75 8b                	jne    80105353 <sys_unlink+0xb3>
    iunlockput(ip);
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	53                   	push   %ebx
801053cc:	e8 5f c5 ff ff       	call   80101930 <iunlockput>
    goto bad;
801053d1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	56                   	push   %esi
801053d8:	e8 53 c5 ff ff       	call   80101930 <iunlockput>
  end_op();
801053dd:	e8 ae db ff ff       	call   80102f90 <end_op>
  return -1;
801053e2:	83 c4 10             	add    $0x10,%esp
}
801053e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801053e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053ed:	5b                   	pop    %ebx
801053ee:	5e                   	pop    %esi
801053ef:	5f                   	pop    %edi
801053f0:	5d                   	pop    %ebp
801053f1:	c3                   	ret    
801053f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801053f8:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801053fd:	83 ec 0c             	sub    $0xc,%esp
80105400:	56                   	push   %esi
80105401:	e8 ea c1 ff ff       	call   801015f0 <iupdate>
80105406:	83 c4 10             	add    $0x10,%esp
80105409:	e9 74 ff ff ff       	jmp    80105382 <sys_unlink+0xe2>
8010540e:	66 90                	xchg   %ax,%ax
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105415:	eb 93                	jmp    801053aa <sys_unlink+0x10a>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80105417:	e8 74 db ff ff       	call   80102f90 <end_op>
    return -1;
8010541c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105421:	eb 87                	jmp    801053aa <sys_unlink+0x10a>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105423:	83 ec 0c             	sub    $0xc,%esp
80105426:	68 71 76 10 80       	push   $0x80107671
8010542b:	e8 40 af ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	68 5f 76 10 80       	push   $0x8010765f
80105438:	e8 33 af ff ff       	call   80100370 <panic>
8010543d:	8d 76 00             	lea    0x0(%esi),%esi

80105440 <create>:
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
80105445:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105446:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105449:	83 ec 44             	sub    $0x44,%esp
8010544c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010544f:	8b 55 10             	mov    0x10(%ebp),%edx
80105452:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105455:	56                   	push   %esi
80105456:	ff 75 08             	pushl  0x8(%ebp)
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105459:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010545c:	89 55 c0             	mov    %edx,-0x40(%ebp)
8010545f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105462:	e8 a9 ca ff ff       	call   80101f10 <nameiparent>
80105467:	83 c4 10             	add    $0x10,%esp
8010546a:	85 c0                	test   %eax,%eax
8010546c:	0f 84 ee 00 00 00    	je     80105560 <create+0x120>
    return 0;
  ilock(dp);
80105472:	83 ec 0c             	sub    $0xc,%esp
80105475:	89 c7                	mov    %eax,%edi
80105477:	50                   	push   %eax
80105478:	e8 23 c2 ff ff       	call   801016a0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010547d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105480:	83 c4 0c             	add    $0xc,%esp
80105483:	50                   	push   %eax
80105484:	56                   	push   %esi
80105485:	57                   	push   %edi
80105486:	e8 45 c7 ff ff       	call   80101bd0 <dirlookup>
8010548b:	83 c4 10             	add    $0x10,%esp
8010548e:	85 c0                	test   %eax,%eax
80105490:	89 c3                	mov    %eax,%ebx
80105492:	74 4c                	je     801054e0 <create+0xa0>
    iunlockput(dp);
80105494:	83 ec 0c             	sub    $0xc,%esp
80105497:	57                   	push   %edi
80105498:	e8 93 c4 ff ff       	call   80101930 <iunlockput>
    ilock(ip);
8010549d:	89 1c 24             	mov    %ebx,(%esp)
801054a0:	e8 fb c1 ff ff       	call   801016a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801054a5:	83 c4 10             	add    $0x10,%esp
801054a8:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801054ad:	75 11                	jne    801054c0 <create+0x80>
801054af:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801054b4:	89 d8                	mov    %ebx,%eax
801054b6:	75 08                	jne    801054c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801054b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054bb:	5b                   	pop    %ebx
801054bc:	5e                   	pop    %esi
801054bd:	5f                   	pop    %edi
801054be:	5d                   	pop    %ebp
801054bf:	c3                   	ret    
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	53                   	push   %ebx
801054c4:	e8 67 c4 ff ff       	call   80101930 <iunlockput>
    return 0;
801054c9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801054cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801054cf:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801054d1:	5b                   	pop    %ebx
801054d2:	5e                   	pop    %esi
801054d3:	5f                   	pop    %edi
801054d4:	5d                   	pop    %ebp
801054d5:	c3                   	ret    
801054d6:	8d 76 00             	lea    0x0(%esi),%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801054e0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801054e4:	83 ec 08             	sub    $0x8,%esp
801054e7:	50                   	push   %eax
801054e8:	ff 37                	pushl  (%edi)
801054ea:	e8 41 c0 ff ff       	call   80101530 <ialloc>
801054ef:	83 c4 10             	add    $0x10,%esp
801054f2:	85 c0                	test   %eax,%eax
801054f4:	89 c3                	mov    %eax,%ebx
801054f6:	0f 84 cc 00 00 00    	je     801055c8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
801054fc:	83 ec 0c             	sub    $0xc,%esp
801054ff:	50                   	push   %eax
80105500:	e8 9b c1 ff ff       	call   801016a0 <ilock>
  ip->major = major;
80105505:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105509:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010550d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105511:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105515:	b8 01 00 00 00       	mov    $0x1,%eax
8010551a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010551e:	89 1c 24             	mov    %ebx,(%esp)
80105521:	e8 ca c0 ff ff       	call   801015f0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105526:	83 c4 10             	add    $0x10,%esp
80105529:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010552e:	74 40                	je     80105570 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105530:	83 ec 04             	sub    $0x4,%esp
80105533:	ff 73 04             	pushl  0x4(%ebx)
80105536:	56                   	push   %esi
80105537:	57                   	push   %edi
80105538:	e8 f3 c8 ff ff       	call   80101e30 <dirlink>
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	85 c0                	test   %eax,%eax
80105542:	78 77                	js     801055bb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105544:	83 ec 0c             	sub    $0xc,%esp
80105547:	57                   	push   %edi
80105548:	e8 e3 c3 ff ff       	call   80101930 <iunlockput>

  return ip;
8010554d:	83 c4 10             	add    $0x10,%esp
}
80105550:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80105553:	89 d8                	mov    %ebx,%eax
}
80105555:	5b                   	pop    %ebx
80105556:	5e                   	pop    %esi
80105557:	5f                   	pop    %edi
80105558:	5d                   	pop    %ebp
80105559:	c3                   	ret    
8010555a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105560:	31 c0                	xor    %eax,%eax
80105562:	e9 51 ff ff ff       	jmp    801054b8 <create+0x78>
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105570:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105575:	83 ec 0c             	sub    $0xc,%esp
80105578:	57                   	push   %edi
80105579:	e8 72 c0 ff ff       	call   801015f0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010557e:	83 c4 0c             	add    $0xc,%esp
80105581:	ff 73 04             	pushl  0x4(%ebx)
80105584:	68 5d 76 10 80       	push   $0x8010765d
80105589:	53                   	push   %ebx
8010558a:	e8 a1 c8 ff ff       	call   80101e30 <dirlink>
8010558f:	83 c4 10             	add    $0x10,%esp
80105592:	85 c0                	test   %eax,%eax
80105594:	78 18                	js     801055ae <create+0x16e>
80105596:	83 ec 04             	sub    $0x4,%esp
80105599:	ff 77 04             	pushl  0x4(%edi)
8010559c:	68 5c 76 10 80       	push   $0x8010765c
801055a1:	53                   	push   %ebx
801055a2:	e8 89 c8 ff ff       	call   80101e30 <dirlink>
801055a7:	83 c4 10             	add    $0x10,%esp
801055aa:	85 c0                	test   %eax,%eax
801055ac:	79 82                	jns    80105530 <create+0xf0>
      panic("create dots");
801055ae:	83 ec 0c             	sub    $0xc,%esp
801055b1:	68 7d 7c 10 80       	push   $0x80107c7d
801055b6:	e8 b5 ad ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801055bb:	83 ec 0c             	sub    $0xc,%esp
801055be:	68 89 7c 10 80       	push   $0x80107c89
801055c3:	e8 a8 ad ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801055c8:	83 ec 0c             	sub    $0xc,%esp
801055cb:	68 6e 7c 10 80       	push   $0x80107c6e
801055d0:	e8 9b ad ff ff       	call   80100370 <panic>
801055d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
801055e5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801055e9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055ec:	50                   	push   %eax
801055ed:	6a 00                	push   $0x0
801055ef:	e8 ec f7 ff ff       	call   80104de0 <argstr>
801055f4:	83 c4 10             	add    $0x10,%esp
801055f7:	85 c0                	test   %eax,%eax
801055f9:	0f 88 9e 00 00 00    	js     8010569d <sys_open+0xbd>
801055ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105602:	83 ec 08             	sub    $0x8,%esp
80105605:	50                   	push   %eax
80105606:	6a 01                	push   $0x1
80105608:	e8 23 f7 ff ff       	call   80104d30 <argint>
8010560d:	83 c4 10             	add    $0x10,%esp
80105610:	85 c0                	test   %eax,%eax
80105612:	0f 88 85 00 00 00    	js     8010569d <sys_open+0xbd>
    return -1;

  begin_op();
80105618:	e8 03 d9 ff ff       	call   80102f20 <begin_op>

  if(omode & O_CREATE){
8010561d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105621:	0f 85 89 00 00 00    	jne    801056b0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105627:	83 ec 0c             	sub    $0xc,%esp
8010562a:	ff 75 e0             	pushl  -0x20(%ebp)
8010562d:	e8 be c8 ff ff       	call   80101ef0 <namei>
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	85 c0                	test   %eax,%eax
80105637:	89 c6                	mov    %eax,%esi
80105639:	0f 84 88 00 00 00    	je     801056c7 <sys_open+0xe7>
      end_op();
      return -1;
    }
    ilock(ip);
8010563f:	83 ec 0c             	sub    $0xc,%esp
80105642:	50                   	push   %eax
80105643:	e8 58 c0 ff ff       	call   801016a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105650:	0f 84 ca 00 00 00    	je     80105720 <sys_open+0x140>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105656:	e8 45 b7 ff ff       	call   80100da0 <filealloc>
8010565b:	85 c0                	test   %eax,%eax
8010565d:	89 c7                	mov    %eax,%edi
8010565f:	74 2b                	je     8010568c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105661:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105663:	e8 48 e5 ff ff       	call   80103bb0 <myproc>
80105668:	90                   	nop
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105670:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105674:	85 d2                	test   %edx,%edx
80105676:	74 60                	je     801056d8 <sys_open+0xf8>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105678:	83 c3 01             	add    $0x1,%ebx
8010567b:	83 fb 10             	cmp    $0x10,%ebx
8010567e:	75 f0                	jne    80105670 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	57                   	push   %edi
80105684:	e8 d7 b7 ff ff       	call   80100e60 <fileclose>
80105689:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010568c:	83 ec 0c             	sub    $0xc,%esp
8010568f:	56                   	push   %esi
80105690:	e8 9b c2 ff ff       	call   80101930 <iunlockput>
    end_op();
80105695:	e8 f6 d8 ff ff       	call   80102f90 <end_op>
    return -1;
8010569a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010569d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801056a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801056a5:	5b                   	pop    %ebx
801056a6:	5e                   	pop    %esi
801056a7:	5f                   	pop    %edi
801056a8:	5d                   	pop    %ebp
801056a9:	c3                   	ret    
801056aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801056b0:	6a 00                	push   $0x0
801056b2:	6a 00                	push   $0x0
801056b4:	6a 02                	push   $0x2
801056b6:	ff 75 e0             	pushl  -0x20(%ebp)
801056b9:	e8 82 fd ff ff       	call   80105440 <create>
    if(ip == 0){
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801056c3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801056c5:	75 8f                	jne    80105656 <sys_open+0x76>
      end_op();
801056c7:	e8 c4 d8 ff ff       	call   80102f90 <end_op>
      return -1;
801056cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d1:	eb 41                	jmp    80105714 <sys_open+0x134>
801056d3:	90                   	nop
801056d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056d8:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801056db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056df:	56                   	push   %esi
801056e0:	e8 9b c0 ff ff       	call   80101780 <iunlock>
  end_op();
801056e5:	e8 a6 d8 ff ff       	call   80102f90 <end_op>

  f->type = FD_INODE;
801056ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056f3:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801056f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801056f9:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105700:	89 d0                	mov    %edx,%eax
80105702:	83 e0 01             	and    $0x1,%eax
80105705:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105708:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010570b:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010570e:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105712:	89 d8                	mov    %ebx,%eax
}
80105714:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105717:	5b                   	pop    %ebx
80105718:	5e                   	pop    %esi
80105719:	5f                   	pop    %edi
8010571a:	5d                   	pop    %ebp
8010571b:	c3                   	ret    
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105720:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105723:	85 c9                	test   %ecx,%ecx
80105725:	0f 84 2b ff ff ff    	je     80105656 <sys_open+0x76>
8010572b:	e9 5c ff ff ff       	jmp    8010568c <sys_open+0xac>

80105730 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105736:	e8 e5 d7 ff ff       	call   80102f20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010573b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573e:	83 ec 08             	sub    $0x8,%esp
80105741:	50                   	push   %eax
80105742:	6a 00                	push   $0x0
80105744:	e8 97 f6 ff ff       	call   80104de0 <argstr>
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	85 c0                	test   %eax,%eax
8010574e:	78 30                	js     80105780 <sys_mkdir+0x50>
80105750:	6a 00                	push   $0x0
80105752:	6a 00                	push   $0x0
80105754:	6a 01                	push   $0x1
80105756:	ff 75 f4             	pushl  -0xc(%ebp)
80105759:	e8 e2 fc ff ff       	call   80105440 <create>
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	85 c0                	test   %eax,%eax
80105763:	74 1b                	je     80105780 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105765:	83 ec 0c             	sub    $0xc,%esp
80105768:	50                   	push   %eax
80105769:	e8 c2 c1 ff ff       	call   80101930 <iunlockput>
  end_op();
8010576e:	e8 1d d8 ff ff       	call   80102f90 <end_op>
  return 0;
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	31 c0                	xor    %eax,%eax
}
80105778:	c9                   	leave  
80105779:	c3                   	ret    
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105780:	e8 0b d8 ff ff       	call   80102f90 <end_op>
    return -1;
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_mknod>:

int
sys_mknod(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105796:	e8 85 d7 ff ff       	call   80102f20 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010579b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010579e:	83 ec 08             	sub    $0x8,%esp
801057a1:	50                   	push   %eax
801057a2:	6a 00                	push   $0x0
801057a4:	e8 37 f6 ff ff       	call   80104de0 <argstr>
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	85 c0                	test   %eax,%eax
801057ae:	78 60                	js     80105810 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b3:	83 ec 08             	sub    $0x8,%esp
801057b6:	50                   	push   %eax
801057b7:	6a 01                	push   $0x1
801057b9:	e8 72 f5 ff ff       	call   80104d30 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	85 c0                	test   %eax,%eax
801057c3:	78 4b                	js     80105810 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801057c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c8:	83 ec 08             	sub    $0x8,%esp
801057cb:	50                   	push   %eax
801057cc:	6a 02                	push   $0x2
801057ce:	e8 5d f5 ff ff       	call   80104d30 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 c0                	test   %eax,%eax
801057d8:	78 36                	js     80105810 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801057da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801057de:	50                   	push   %eax
801057df:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
801057e3:	50                   	push   %eax
801057e4:	6a 03                	push   $0x3
801057e6:	ff 75 ec             	pushl  -0x14(%ebp)
801057e9:	e8 52 fc ff ff       	call   80105440 <create>
801057ee:	83 c4 10             	add    $0x10,%esp
801057f1:	85 c0                	test   %eax,%eax
801057f3:	74 1b                	je     80105810 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801057f5:	83 ec 0c             	sub    $0xc,%esp
801057f8:	50                   	push   %eax
801057f9:	e8 32 c1 ff ff       	call   80101930 <iunlockput>
  end_op();
801057fe:	e8 8d d7 ff ff       	call   80102f90 <end_op>
  return 0;
80105803:	83 c4 10             	add    $0x10,%esp
80105806:	31 c0                	xor    %eax,%eax
}
80105808:	c9                   	leave  
80105809:	c3                   	ret    
8010580a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105810:	e8 7b d7 ff ff       	call   80102f90 <end_op>
    return -1;
80105815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010581a:	c9                   	leave  
8010581b:	c3                   	ret    
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_chdir>:

int
sys_chdir(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	56                   	push   %esi
80105824:	53                   	push   %ebx
80105825:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105828:	e8 83 e3 ff ff       	call   80103bb0 <myproc>
8010582d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010582f:	e8 ec d6 ff ff       	call   80102f20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105834:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105837:	83 ec 08             	sub    $0x8,%esp
8010583a:	50                   	push   %eax
8010583b:	6a 00                	push   $0x0
8010583d:	e8 9e f5 ff ff       	call   80104de0 <argstr>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	78 77                	js     801058c0 <sys_chdir+0xa0>
80105849:	83 ec 0c             	sub    $0xc,%esp
8010584c:	ff 75 f4             	pushl  -0xc(%ebp)
8010584f:	e8 9c c6 ff ff       	call   80101ef0 <namei>
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	85 c0                	test   %eax,%eax
80105859:	89 c3                	mov    %eax,%ebx
8010585b:	74 63                	je     801058c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	50                   	push   %eax
80105861:	e8 3a be ff ff       	call   801016a0 <ilock>
  if(ip->type != T_DIR){
80105866:	83 c4 10             	add    $0x10,%esp
80105869:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010586e:	75 30                	jne    801058a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	53                   	push   %ebx
80105874:	e8 07 bf ff ff       	call   80101780 <iunlock>
  iput(curproc->cwd);
80105879:	58                   	pop    %eax
8010587a:	ff 76 68             	pushl  0x68(%esi)
8010587d:	e8 4e bf ff ff       	call   801017d0 <iput>
  end_op();
80105882:	e8 09 d7 ff ff       	call   80102f90 <end_op>
  curproc->cwd = ip;
80105887:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010588a:	83 c4 10             	add    $0x10,%esp
8010588d:	31 c0                	xor    %eax,%eax
}
8010588f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105892:	5b                   	pop    %ebx
80105893:	5e                   	pop    %esi
80105894:	5d                   	pop    %ebp
80105895:	c3                   	ret    
80105896:	8d 76 00             	lea    0x0(%esi),%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801058a0:	83 ec 0c             	sub    $0xc,%esp
801058a3:	53                   	push   %ebx
801058a4:	e8 87 c0 ff ff       	call   80101930 <iunlockput>
    end_op();
801058a9:	e8 e2 d6 ff ff       	call   80102f90 <end_op>
    return -1;
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b6:	eb d7                	jmp    8010588f <sys_chdir+0x6f>
801058b8:	90                   	nop
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801058c0:	e8 cb d6 ff ff       	call   80102f90 <end_op>
    return -1;
801058c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ca:	eb c3                	jmp    8010588f <sys_chdir+0x6f>
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
801058d5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058d6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801058dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058e2:	50                   	push   %eax
801058e3:	6a 00                	push   $0x0
801058e5:	e8 f6 f4 ff ff       	call   80104de0 <argstr>
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	85 c0                	test   %eax,%eax
801058ef:	78 7f                	js     80105970 <sys_exec+0xa0>
801058f1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058f7:	83 ec 08             	sub    $0x8,%esp
801058fa:	50                   	push   %eax
801058fb:	6a 01                	push   $0x1
801058fd:	e8 2e f4 ff ff       	call   80104d30 <argint>
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	85 c0                	test   %eax,%eax
80105907:	78 67                	js     80105970 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105909:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010590f:	83 ec 04             	sub    $0x4,%esp
80105912:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105918:	68 80 00 00 00       	push   $0x80
8010591d:	6a 00                	push   $0x0
8010591f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105925:	50                   	push   %eax
80105926:	31 db                	xor    %ebx,%ebx
80105928:	e8 f3 f0 ff ff       	call   80104a20 <memset>
8010592d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105930:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105936:	83 ec 08             	sub    $0x8,%esp
80105939:	57                   	push   %edi
8010593a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010593d:	50                   	push   %eax
8010593e:	e8 4d f3 ff ff       	call   80104c90 <fetchint>
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	85 c0                	test   %eax,%eax
80105948:	78 26                	js     80105970 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010594a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105950:	85 c0                	test   %eax,%eax
80105952:	74 2c                	je     80105980 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105954:	83 ec 08             	sub    $0x8,%esp
80105957:	56                   	push   %esi
80105958:	50                   	push   %eax
80105959:	e8 72 f3 ff ff       	call   80104cd0 <fetchstr>
8010595e:	83 c4 10             	add    $0x10,%esp
80105961:	85 c0                	test   %eax,%eax
80105963:	78 0b                	js     80105970 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105965:	83 c3 01             	add    $0x1,%ebx
80105968:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010596b:	83 fb 20             	cmp    $0x20,%ebx
8010596e:	75 c0                	jne    80105930 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105970:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105978:	5b                   	pop    %ebx
80105979:	5e                   	pop    %esi
8010597a:	5f                   	pop    %edi
8010597b:	5d                   	pop    %ebp
8010597c:	c3                   	ret    
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105980:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105986:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105989:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105990:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105994:	50                   	push   %eax
80105995:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010599b:	e8 50 b0 ff ff       	call   801009f0 <exec>
801059a0:	83 c4 10             	add    $0x10,%esp
}
801059a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a6:	5b                   	pop    %ebx
801059a7:	5e                   	pop    %esi
801059a8:	5f                   	pop    %edi
801059a9:	5d                   	pop    %ebp
801059aa:	c3                   	ret    
801059ab:	90                   	nop
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_pipe>:

int
sys_pipe(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	57                   	push   %edi
801059b4:	56                   	push   %esi
801059b5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059b6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801059b9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059bc:	6a 08                	push   $0x8
801059be:	50                   	push   %eax
801059bf:	6a 00                	push   $0x0
801059c1:	e8 ba f3 ff ff       	call   80104d80 <argptr>
801059c6:	83 c4 10             	add    $0x10,%esp
801059c9:	85 c0                	test   %eax,%eax
801059cb:	78 4a                	js     80105a17 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801059cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059d0:	83 ec 08             	sub    $0x8,%esp
801059d3:	50                   	push   %eax
801059d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059d7:	50                   	push   %eax
801059d8:	e8 e3 db ff ff       	call   801035c0 <pipealloc>
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	85 c0                	test   %eax,%eax
801059e2:	78 33                	js     80105a17 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801059e4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801059e9:	e8 c2 e1 ff ff       	call   80103bb0 <myproc>
801059ee:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801059f0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801059f4:	85 f6                	test   %esi,%esi
801059f6:	74 30                	je     80105a28 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801059f8:	83 c3 01             	add    $0x1,%ebx
801059fb:	83 fb 10             	cmp    $0x10,%ebx
801059fe:	75 f0                	jne    801059f0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	ff 75 e0             	pushl  -0x20(%ebp)
80105a06:	e8 55 b4 ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
80105a0b:	58                   	pop    %eax
80105a0c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a0f:	e8 4c b4 ff ff       	call   80100e60 <fileclose>
    return -1;
80105a14:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105a17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105a1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105a1f:	5b                   	pop    %ebx
80105a20:	5e                   	pop    %esi
80105a21:	5f                   	pop    %edi
80105a22:	5d                   	pop    %ebp
80105a23:	c3                   	ret    
80105a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105a28:	8d 73 08             	lea    0x8(%ebx),%esi
80105a2b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a2f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105a32:	e8 79 e1 ff ff       	call   80103bb0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105a37:	31 d2                	xor    %edx,%edx
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105a40:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105a44:	85 c9                	test   %ecx,%ecx
80105a46:	74 18                	je     80105a60 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105a48:	83 c2 01             	add    $0x1,%edx
80105a4b:	83 fa 10             	cmp    $0x10,%edx
80105a4e:	75 f0                	jne    80105a40 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105a50:	e8 5b e1 ff ff       	call   80103bb0 <myproc>
80105a55:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a5c:	00 
80105a5d:	eb a1                	jmp    80105a00 <sys_pipe+0x50>
80105a5f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105a60:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105a64:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a67:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a69:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a6c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105a72:	31 c0                	xor    %eax,%eax
}
80105a74:	5b                   	pop    %ebx
80105a75:	5e                   	pop    %esi
80105a76:	5f                   	pop    %edi
80105a77:	5d                   	pop    %ebp
80105a78:	c3                   	ret    
80105a79:	66 90                	xchg   %ax,%ax
80105a7b:	66 90                	xchg   %ax,%ax
80105a7d:	66 90                	xchg   %ax,%ax
80105a7f:	90                   	nop

80105a80 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105a86:	e8 05 e8 ff ff       	call   80104290 <yield>
  return 0;
}
80105a8b:	31 c0                	xor    %eax,%eax
80105a8d:	c9                   	leave  
80105a8e:	c3                   	ret    
80105a8f:	90                   	nop

80105a90 <sys_fork>:

int
sys_fork(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105a93:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105a94:	e9 b7 e2 ff ff       	jmp    80103d50 <fork>
80105a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105aa0 <sys_exit>:
}

int
sys_exit(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105aa6:	e8 95 e6 ff ff       	call   80104140 <exit>
  return 0;  // not reached
}
80105aab:	31 c0                	xor    %eax,%eax
80105aad:	c9                   	leave  
80105aae:	c3                   	ret    
80105aaf:	90                   	nop

80105ab0 <sys_wait>:

int
sys_wait(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105ab3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105ab4:	e9 e7 e8 ff ff       	jmp    801043a0 <wait>
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_kill>:
}

int
sys_kill(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ac6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac9:	50                   	push   %eax
80105aca:	6a 00                	push   $0x0
80105acc:	e8 5f f2 ff ff       	call   80104d30 <argint>
80105ad1:	83 c4 10             	add    $0x10,%esp
80105ad4:	85 c0                	test   %eax,%eax
80105ad6:	78 18                	js     80105af0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ade:	e8 6d ea ff ff       	call   80104550 <kill>
80105ae3:	83 c4 10             	add    $0x10,%esp
}
80105ae6:	c9                   	leave  
80105ae7:	c3                   	ret    
80105ae8:	90                   	nop
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b00 <sys_getpid>:

int
sys_getpid(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b06:	e8 a5 e0 ff ff       	call   80103bb0 <myproc>
80105b0b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b0e:	c9                   	leave  
80105b0f:	c3                   	ret    

80105b10 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105b17:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b1a:	50                   	push   %eax
80105b1b:	6a 00                	push   $0x0
80105b1d:	e8 0e f2 ff ff       	call   80104d30 <argint>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	85 c0                	test   %eax,%eax
80105b27:	78 27                	js     80105b50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b29:	e8 82 e0 ff ff       	call   80103bb0 <myproc>
  if(growproc(n) < 0)
80105b2e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105b31:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b33:	ff 75 f4             	pushl  -0xc(%ebp)
80105b36:	e8 95 e1 ff ff       	call   80103cd0 <growproc>
80105b3b:	83 c4 10             	add    $0x10,%esp
80105b3e:	85 c0                	test   %eax,%eax
80105b40:	78 0e                	js     80105b50 <sys_sbrk+0x40>
    return -1;
  return addr;
80105b42:	89 d8                	mov    %ebx,%eax
}
80105b44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b47:	c9                   	leave  
80105b48:	c3                   	ret    
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b55:	eb ed                	jmp    80105b44 <sys_sbrk+0x34>
80105b57:	89 f6                	mov    %esi,%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b60 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105b67:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b6a:	50                   	push   %eax
80105b6b:	6a 00                	push   $0x0
80105b6d:	e8 be f1 ff ff       	call   80104d30 <argint>
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	85 c0                	test   %eax,%eax
80105b77:	0f 88 8a 00 00 00    	js     80105c07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 60 e0 11 80       	push   $0x8011e060
80105b85:	e8 26 ed ff ff       	call   801048b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b8d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105b90:	8b 1d a0 e8 11 80    	mov    0x8011e8a0,%ebx
  while(ticks - ticks0 < n){
80105b96:	85 d2                	test   %edx,%edx
80105b98:	75 27                	jne    80105bc1 <sys_sleep+0x61>
80105b9a:	eb 54                	jmp    80105bf0 <sys_sleep+0x90>
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ba0:	83 ec 08             	sub    $0x8,%esp
80105ba3:	68 60 e0 11 80       	push   $0x8011e060
80105ba8:	68 a0 e8 11 80       	push   $0x8011e8a0
80105bad:	e8 2e e7 ff ff       	call   801042e0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105bb2:	a1 a0 e8 11 80       	mov    0x8011e8a0,%eax
80105bb7:	83 c4 10             	add    $0x10,%esp
80105bba:	29 d8                	sub    %ebx,%eax
80105bbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105bbf:	73 2f                	jae    80105bf0 <sys_sleep+0x90>
    if(myproc()->killed){
80105bc1:	e8 ea df ff ff       	call   80103bb0 <myproc>
80105bc6:	8b 40 24             	mov    0x24(%eax),%eax
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	74 d3                	je     80105ba0 <sys_sleep+0x40>
      release(&tickslock);
80105bcd:	83 ec 0c             	sub    $0xc,%esp
80105bd0:	68 60 e0 11 80       	push   $0x8011e060
80105bd5:	e8 f6 ed ff ff       	call   801049d0 <release>
      return -1;
80105bda:	83 c4 10             	add    $0x10,%esp
80105bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105be2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105be5:	c9                   	leave  
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	68 60 e0 11 80       	push   $0x8011e060
80105bf8:	e8 d3 ed ff ff       	call   801049d0 <release>
  return 0;
80105bfd:	83 c4 10             	add    $0x10,%esp
80105c00:	31 c0                	xor    %eax,%eax
}
80105c02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c05:	c9                   	leave  
80105c06:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105c07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0c:	eb d4                	jmp    80105be2 <sys_sleep+0x82>
80105c0e:	66 90                	xchg   %ax,%ax

80105c10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	53                   	push   %ebx
80105c14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c17:	68 60 e0 11 80       	push   $0x8011e060
80105c1c:	e8 8f ec ff ff       	call   801048b0 <acquire>
  xticks = ticks;
80105c21:	8b 1d a0 e8 11 80    	mov    0x8011e8a0,%ebx
  release(&tickslock);
80105c27:	c7 04 24 60 e0 11 80 	movl   $0x8011e060,(%esp)
80105c2e:	e8 9d ed ff ff       	call   801049d0 <release>
  return xticks;
}
80105c33:	89 d8                	mov    %ebx,%eax
80105c35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c38:	c9                   	leave  
80105c39:	c3                   	ret    

80105c3a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c3a:	1e                   	push   %ds
  pushl %es
80105c3b:	06                   	push   %es
  pushl %fs
80105c3c:	0f a0                	push   %fs
  pushl %gs
80105c3e:	0f a8                	push   %gs
  pushal
80105c40:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c41:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c45:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c47:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c49:	54                   	push   %esp
  call trap
80105c4a:	e8 e1 00 00 00       	call   80105d30 <trap>
  addl $4, %esp
80105c4f:	83 c4 04             	add    $0x4,%esp

80105c52 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c52:	61                   	popa   
  popl %gs
80105c53:	0f a9                	pop    %gs
  popl %fs
80105c55:	0f a1                	pop    %fs
  popl %es
80105c57:	07                   	pop    %es
  popl %ds
80105c58:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c59:	83 c4 08             	add    $0x8,%esp
  iret
80105c5c:	cf                   	iret   
80105c5d:	66 90                	xchg   %ax,%ax
80105c5f:	90                   	nop

80105c60 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105c60:	31 c0                	xor    %eax,%eax
80105c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c68:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
80105c6f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105c74:	c6 04 c5 a4 e0 11 80 	movb   $0x0,-0x7fee1f5c(,%eax,8)
80105c7b:	00 
80105c7c:	66 89 0c c5 a2 e0 11 	mov    %cx,-0x7fee1f5e(,%eax,8)
80105c83:	80 
80105c84:	c6 04 c5 a5 e0 11 80 	movb   $0x8e,-0x7fee1f5b(,%eax,8)
80105c8b:	8e 
80105c8c:	66 89 14 c5 a0 e0 11 	mov    %dx,-0x7fee1f60(,%eax,8)
80105c93:	80 
80105c94:	c1 ea 10             	shr    $0x10,%edx
80105c97:	66 89 14 c5 a6 e0 11 	mov    %dx,-0x7fee1f5a(,%eax,8)
80105c9e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105c9f:	83 c0 01             	add    $0x1,%eax
80105ca2:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ca7:	75 bf                	jne    80105c68 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ca9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105caa:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105caf:	89 e5                	mov    %esp,%ebp
80105cb1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cb4:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105cb9:	68 99 7c 10 80       	push   $0x80107c99
80105cbe:	68 60 e0 11 80       	push   $0x8011e060
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cc3:	66 89 15 a2 e2 11 80 	mov    %dx,0x8011e2a2
80105cca:	c6 05 a4 e2 11 80 00 	movb   $0x0,0x8011e2a4
80105cd1:	66 a3 a0 e2 11 80    	mov    %ax,0x8011e2a0
80105cd7:	c1 e8 10             	shr    $0x10,%eax
80105cda:	c6 05 a5 e2 11 80 ef 	movb   $0xef,0x8011e2a5
80105ce1:	66 a3 a6 e2 11 80    	mov    %ax,0x8011e2a6

  initlock(&tickslock, "time");
80105ce7:	e8 c4 ea ff ff       	call   801047b0 <initlock>
}
80105cec:	83 c4 10             	add    $0x10,%esp
80105cef:	c9                   	leave  
80105cf0:	c3                   	ret    
80105cf1:	eb 0d                	jmp    80105d00 <idtinit>
80105cf3:	90                   	nop
80105cf4:	90                   	nop
80105cf5:	90                   	nop
80105cf6:	90                   	nop
80105cf7:	90                   	nop
80105cf8:	90                   	nop
80105cf9:	90                   	nop
80105cfa:	90                   	nop
80105cfb:	90                   	nop
80105cfc:	90                   	nop
80105cfd:	90                   	nop
80105cfe:	90                   	nop
80105cff:	90                   	nop

80105d00 <idtinit>:

void
idtinit(void)
{
80105d00:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105d01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d06:	89 e5                	mov    %esp,%ebp
80105d08:	83 ec 10             	sub    $0x10,%esp
80105d0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d0f:	b8 a0 e0 11 80       	mov    $0x8011e0a0,%eax
80105d14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d18:	c1 e8 10             	shr    $0x10,%eax
80105d1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105d1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d25:	c9                   	leave  
80105d26:	c3                   	ret    
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	57                   	push   %edi
80105d34:	56                   	push   %esi
80105d35:	53                   	push   %ebx
80105d36:	83 ec 1c             	sub    $0x1c,%esp
80105d39:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105d3c:	8b 47 30             	mov    0x30(%edi),%eax
80105d3f:	83 f8 40             	cmp    $0x40,%eax
80105d42:	0f 84 88 01 00 00    	je     80105ed0 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d48:	83 e8 20             	sub    $0x20,%eax
80105d4b:	83 f8 1f             	cmp    $0x1f,%eax
80105d4e:	77 10                	ja     80105d60 <trap+0x30>
80105d50:	ff 24 85 40 7d 10 80 	jmp    *-0x7fef82c0(,%eax,4)
80105d57:	89 f6                	mov    %esi,%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    //TODO CASE TRAP 14 PGFLT IF IN SWITCH FILE: BRING FROM THERE, ELSE GO DEFAULT

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d60:	e8 4b de ff ff       	call   80103bb0 <myproc>
80105d65:	85 c0                	test   %eax,%eax
80105d67:	0f 84 d7 01 00 00    	je     80105f44 <trap+0x214>
80105d6d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105d71:	0f 84 cd 01 00 00    	je     80105f44 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d77:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d7a:	8b 57 38             	mov    0x38(%edi),%edx
80105d7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105d80:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105d83:	e8 08 de ff ff       	call   80103b90 <cpuid>
80105d88:	8b 77 34             	mov    0x34(%edi),%esi
80105d8b:	8b 5f 30             	mov    0x30(%edi),%ebx
80105d8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d91:	e8 1a de ff ff       	call   80103bb0 <myproc>
80105d96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d99:	e8 12 de ff ff       	call   80103bb0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105da1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105da4:	51                   	push   %ecx
80105da5:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105da6:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105da9:	ff 75 e4             	pushl  -0x1c(%ebp)
80105dac:	56                   	push   %esi
80105dad:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105dae:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105db1:	52                   	push   %edx
80105db2:	ff 70 10             	pushl  0x10(%eax)
80105db5:	68 fc 7c 10 80       	push   $0x80107cfc
80105dba:	e8 a1 a8 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105dbf:	83 c4 20             	add    $0x20,%esp
80105dc2:	e8 e9 dd ff ff       	call   80103bb0 <myproc>
80105dc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105dce:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd0:	e8 db dd ff ff       	call   80103bb0 <myproc>
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	74 0c                	je     80105de5 <trap+0xb5>
80105dd9:	e8 d2 dd ff ff       	call   80103bb0 <myproc>
80105dde:	8b 50 24             	mov    0x24(%eax),%edx
80105de1:	85 d2                	test   %edx,%edx
80105de3:	75 4b                	jne    80105e30 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105de5:	e8 c6 dd ff ff       	call   80103bb0 <myproc>
80105dea:	85 c0                	test   %eax,%eax
80105dec:	74 0b                	je     80105df9 <trap+0xc9>
80105dee:	e8 bd dd ff ff       	call   80103bb0 <myproc>
80105df3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105df7:	74 4f                	je     80105e48 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105df9:	e8 b2 dd ff ff       	call   80103bb0 <myproc>
80105dfe:	85 c0                	test   %eax,%eax
80105e00:	74 1d                	je     80105e1f <trap+0xef>
80105e02:	e8 a9 dd ff ff       	call   80103bb0 <myproc>
80105e07:	8b 40 24             	mov    0x24(%eax),%eax
80105e0a:	85 c0                	test   %eax,%eax
80105e0c:	74 11                	je     80105e1f <trap+0xef>
80105e0e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e12:	83 e0 03             	and    $0x3,%eax
80105e15:	66 83 f8 03          	cmp    $0x3,%ax
80105e19:	0f 84 da 00 00 00    	je     80105ef9 <trap+0x1c9>
    exit();
}
80105e1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e22:	5b                   	pop    %ebx
80105e23:	5e                   	pop    %esi
80105e24:	5f                   	pop    %edi
80105e25:	5d                   	pop    %ebp
80105e26:	c3                   	ret    
80105e27:	89 f6                	mov    %esi,%esi
80105e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e30:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e34:	83 e0 03             	and    $0x3,%eax
80105e37:	66 83 f8 03          	cmp    $0x3,%ax
80105e3b:	75 a8                	jne    80105de5 <trap+0xb5>
    exit();
80105e3d:	e8 fe e2 ff ff       	call   80104140 <exit>
80105e42:	eb a1                	jmp    80105de5 <trap+0xb5>
80105e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e48:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105e4c:	75 ab                	jne    80105df9 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105e4e:	e8 3d e4 ff ff       	call   80104290 <yield>
80105e53:	eb a4                	jmp    80105df9 <trap+0xc9>
80105e55:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105e58:	e8 33 dd ff ff       	call   80103b90 <cpuid>
80105e5d:	85 c0                	test   %eax,%eax
80105e5f:	0f 84 ab 00 00 00    	je     80105f10 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105e65:	e8 76 cc ff ff       	call   80102ae0 <lapiceoi>
    break;
80105e6a:	e9 61 ff ff ff       	jmp    80105dd0 <trap+0xa0>
80105e6f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105e70:	e8 2b cb ff ff       	call   801029a0 <kbdintr>
    lapiceoi();
80105e75:	e8 66 cc ff ff       	call   80102ae0 <lapiceoi>
    break;
80105e7a:	e9 51 ff ff ff       	jmp    80105dd0 <trap+0xa0>
80105e7f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105e80:	e8 5b 02 00 00       	call   801060e0 <uartintr>
    lapiceoi();
80105e85:	e8 56 cc ff ff       	call   80102ae0 <lapiceoi>
    break;
80105e8a:	e9 41 ff ff ff       	jmp    80105dd0 <trap+0xa0>
80105e8f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e90:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105e94:	8b 77 38             	mov    0x38(%edi),%esi
80105e97:	e8 f4 dc ff ff       	call   80103b90 <cpuid>
80105e9c:	56                   	push   %esi
80105e9d:	53                   	push   %ebx
80105e9e:	50                   	push   %eax
80105e9f:	68 a4 7c 10 80       	push   $0x80107ca4
80105ea4:	e8 b7 a7 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105ea9:	e8 32 cc ff ff       	call   80102ae0 <lapiceoi>
    break;
80105eae:	83 c4 10             	add    $0x10,%esp
80105eb1:	e9 1a ff ff ff       	jmp    80105dd0 <trap+0xa0>
80105eb6:	8d 76 00             	lea    0x0(%esi),%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ec0:	e8 5b c5 ff ff       	call   80102420 <ideintr>
80105ec5:	eb 9e                	jmp    80105e65 <trap+0x135>
80105ec7:	89 f6                	mov    %esi,%esi
80105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105ed0:	e8 db dc ff ff       	call   80103bb0 <myproc>
80105ed5:	8b 58 24             	mov    0x24(%eax),%ebx
80105ed8:	85 db                	test   %ebx,%ebx
80105eda:	75 2c                	jne    80105f08 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
80105edc:	e8 cf dc ff ff       	call   80103bb0 <myproc>
80105ee1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105ee4:	e8 37 ef ff ff       	call   80104e20 <syscall>
    if(myproc()->killed)
80105ee9:	e8 c2 dc ff ff       	call   80103bb0 <myproc>
80105eee:	8b 48 24             	mov    0x24(%eax),%ecx
80105ef1:	85 c9                	test   %ecx,%ecx
80105ef3:	0f 84 26 ff ff ff    	je     80105e1f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105efc:	5b                   	pop    %ebx
80105efd:	5e                   	pop    %esi
80105efe:	5f                   	pop    %edi
80105eff:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105f00:	e9 3b e2 ff ff       	jmp    80104140 <exit>
80105f05:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105f08:	e8 33 e2 ff ff       	call   80104140 <exit>
80105f0d:	eb cd                	jmp    80105edc <trap+0x1ac>
80105f0f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105f10:	83 ec 0c             	sub    $0xc,%esp
80105f13:	68 60 e0 11 80       	push   $0x8011e060
80105f18:	e8 93 e9 ff ff       	call   801048b0 <acquire>
      ticks++;
      wakeup(&ticks);
80105f1d:	c7 04 24 a0 e8 11 80 	movl   $0x8011e8a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105f24:	83 05 a0 e8 11 80 01 	addl   $0x1,0x8011e8a0
      wakeup(&ticks);
80105f2b:	e8 c0 e5 ff ff       	call   801044f0 <wakeup>
      release(&tickslock);
80105f30:	c7 04 24 60 e0 11 80 	movl   $0x8011e060,(%esp)
80105f37:	e8 94 ea ff ff       	call   801049d0 <release>
80105f3c:	83 c4 10             	add    $0x10,%esp
80105f3f:	e9 21 ff ff ff       	jmp    80105e65 <trap+0x135>
80105f44:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f47:	8b 5f 38             	mov    0x38(%edi),%ebx
80105f4a:	e8 41 dc ff ff       	call   80103b90 <cpuid>
80105f4f:	83 ec 0c             	sub    $0xc,%esp
80105f52:	56                   	push   %esi
80105f53:	53                   	push   %ebx
80105f54:	50                   	push   %eax
80105f55:	ff 77 30             	pushl  0x30(%edi)
80105f58:	68 c8 7c 10 80       	push   $0x80107cc8
80105f5d:	e8 fe a6 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105f62:	83 c4 14             	add    $0x14,%esp
80105f65:	68 9e 7c 10 80       	push   $0x80107c9e
80105f6a:	e8 01 a4 ff ff       	call   80100370 <panic>
80105f6f:	90                   	nop

80105f70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f70:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105f75:	55                   	push   %ebp
80105f76:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f78:	85 c0                	test   %eax,%eax
80105f7a:	74 1c                	je     80105f98 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f7c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f81:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f82:	a8 01                	test   $0x1,%al
80105f84:	74 12                	je     80105f98 <uartgetc+0x28>
80105f86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f8b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f8c:	0f b6 c0             	movzbl %al,%eax
}
80105f8f:	5d                   	pop    %ebp
80105f90:	c3                   	ret    
80105f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105f9d:	5d                   	pop    %ebp
80105f9e:	c3                   	ret    
80105f9f:	90                   	nop

80105fa0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	57                   	push   %edi
80105fa4:	56                   	push   %esi
80105fa5:	53                   	push   %ebx
80105fa6:	89 c7                	mov    %eax,%edi
80105fa8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fad:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fb2:	83 ec 0c             	sub    $0xc,%esp
80105fb5:	eb 1b                	jmp    80105fd2 <uartputc.part.0+0x32>
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105fc0:	83 ec 0c             	sub    $0xc,%esp
80105fc3:	6a 0a                	push   $0xa
80105fc5:	e8 36 cb ff ff       	call   80102b00 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	83 eb 01             	sub    $0x1,%ebx
80105fd0:	74 07                	je     80105fd9 <uartputc.part.0+0x39>
80105fd2:	89 f2                	mov    %esi,%edx
80105fd4:	ec                   	in     (%dx),%al
80105fd5:	a8 20                	test   $0x20,%al
80105fd7:	74 e7                	je     80105fc0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fd9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fde:	89 f8                	mov    %edi,%eax
80105fe0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe4:	5b                   	pop    %ebx
80105fe5:	5e                   	pop    %esi
80105fe6:	5f                   	pop    %edi
80105fe7:	5d                   	pop    %ebp
80105fe8:	c3                   	ret    
80105fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ff0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	31 c9                	xor    %ecx,%ecx
80105ff3:	89 c8                	mov    %ecx,%eax
80105ff5:	89 e5                	mov    %esp,%ebp
80105ff7:	57                   	push   %edi
80105ff8:	56                   	push   %esi
80105ff9:	53                   	push   %ebx
80105ffa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105fff:	89 da                	mov    %ebx,%edx
80106001:	83 ec 0c             	sub    $0xc,%esp
80106004:	ee                   	out    %al,(%dx)
80106005:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010600a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010600f:	89 fa                	mov    %edi,%edx
80106011:	ee                   	out    %al,(%dx)
80106012:	b8 0c 00 00 00       	mov    $0xc,%eax
80106017:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010601c:	ee                   	out    %al,(%dx)
8010601d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106022:	89 c8                	mov    %ecx,%eax
80106024:	89 f2                	mov    %esi,%edx
80106026:	ee                   	out    %al,(%dx)
80106027:	b8 03 00 00 00       	mov    $0x3,%eax
8010602c:	89 fa                	mov    %edi,%edx
8010602e:	ee                   	out    %al,(%dx)
8010602f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106034:	89 c8                	mov    %ecx,%eax
80106036:	ee                   	out    %al,(%dx)
80106037:	b8 01 00 00 00       	mov    $0x1,%eax
8010603c:	89 f2                	mov    %esi,%edx
8010603e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010603f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106044:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106045:	3c ff                	cmp    $0xff,%al
80106047:	74 5a                	je     801060a3 <uartinit+0xb3>
    return;
  uart = 1;
80106049:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80106050:	00 00 00 
80106053:	89 da                	mov    %ebx,%edx
80106055:	ec                   	in     (%dx),%al
80106056:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010605b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010605c:	83 ec 08             	sub    $0x8,%esp
8010605f:	bb c0 7d 10 80       	mov    $0x80107dc0,%ebx
80106064:	6a 00                	push   $0x0
80106066:	6a 04                	push   $0x4
80106068:	e8 03 c6 ff ff       	call   80102670 <ioapicenable>
8010606d:	83 c4 10             	add    $0x10,%esp
80106070:	b8 78 00 00 00       	mov    $0x78,%eax
80106075:	eb 13                	jmp    8010608a <uartinit+0x9a>
80106077:	89 f6                	mov    %esi,%esi
80106079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106080:	83 c3 01             	add    $0x1,%ebx
80106083:	0f be 03             	movsbl (%ebx),%eax
80106086:	84 c0                	test   %al,%al
80106088:	74 19                	je     801060a3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010608a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80106090:	85 d2                	test   %edx,%edx
80106092:	74 ec                	je     80106080 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106094:	83 c3 01             	add    $0x1,%ebx
80106097:	e8 04 ff ff ff       	call   80105fa0 <uartputc.part.0>
8010609c:	0f be 03             	movsbl (%ebx),%eax
8010609f:	84 c0                	test   %al,%al
801060a1:	75 e7                	jne    8010608a <uartinit+0x9a>
    uartputc(*p);
}
801060a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060a6:	5b                   	pop    %ebx
801060a7:	5e                   	pop    %esi
801060a8:	5f                   	pop    %edi
801060a9:	5d                   	pop    %ebp
801060aa:	c3                   	ret    
801060ab:	90                   	nop
801060ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060b0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801060b0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801060b6:	55                   	push   %ebp
801060b7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
801060b9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801060bb:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
801060be:	74 10                	je     801060d0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801060c0:	5d                   	pop    %ebp
801060c1:	e9 da fe ff ff       	jmp    80105fa0 <uartputc.part.0>
801060c6:	8d 76 00             	lea    0x0(%esi),%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060d0:	5d                   	pop    %ebp
801060d1:	c3                   	ret    
801060d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060e0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060e6:	68 70 5f 10 80       	push   $0x80105f70
801060eb:	e8 00 a7 ff ff       	call   801007f0 <consoleintr>
}
801060f0:	83 c4 10             	add    $0x10,%esp
801060f3:	c9                   	leave  
801060f4:	c3                   	ret    

801060f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $0
801060f7:	6a 00                	push   $0x0
  jmp alltraps
801060f9:	e9 3c fb ff ff       	jmp    80105c3a <alltraps>

801060fe <vector1>:
.globl vector1
vector1:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $1
80106100:	6a 01                	push   $0x1
  jmp alltraps
80106102:	e9 33 fb ff ff       	jmp    80105c3a <alltraps>

80106107 <vector2>:
.globl vector2
vector2:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $2
80106109:	6a 02                	push   $0x2
  jmp alltraps
8010610b:	e9 2a fb ff ff       	jmp    80105c3a <alltraps>

80106110 <vector3>:
.globl vector3
vector3:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $3
80106112:	6a 03                	push   $0x3
  jmp alltraps
80106114:	e9 21 fb ff ff       	jmp    80105c3a <alltraps>

80106119 <vector4>:
.globl vector4
vector4:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $4
8010611b:	6a 04                	push   $0x4
  jmp alltraps
8010611d:	e9 18 fb ff ff       	jmp    80105c3a <alltraps>

80106122 <vector5>:
.globl vector5
vector5:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $5
80106124:	6a 05                	push   $0x5
  jmp alltraps
80106126:	e9 0f fb ff ff       	jmp    80105c3a <alltraps>

8010612b <vector6>:
.globl vector6
vector6:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $6
8010612d:	6a 06                	push   $0x6
  jmp alltraps
8010612f:	e9 06 fb ff ff       	jmp    80105c3a <alltraps>

80106134 <vector7>:
.globl vector7
vector7:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $7
80106136:	6a 07                	push   $0x7
  jmp alltraps
80106138:	e9 fd fa ff ff       	jmp    80105c3a <alltraps>

8010613d <vector8>:
.globl vector8
vector8:
  pushl $8
8010613d:	6a 08                	push   $0x8
  jmp alltraps
8010613f:	e9 f6 fa ff ff       	jmp    80105c3a <alltraps>

80106144 <vector9>:
.globl vector9
vector9:
  pushl $0
80106144:	6a 00                	push   $0x0
  pushl $9
80106146:	6a 09                	push   $0x9
  jmp alltraps
80106148:	e9 ed fa ff ff       	jmp    80105c3a <alltraps>

8010614d <vector10>:
.globl vector10
vector10:
  pushl $10
8010614d:	6a 0a                	push   $0xa
  jmp alltraps
8010614f:	e9 e6 fa ff ff       	jmp    80105c3a <alltraps>

80106154 <vector11>:
.globl vector11
vector11:
  pushl $11
80106154:	6a 0b                	push   $0xb
  jmp alltraps
80106156:	e9 df fa ff ff       	jmp    80105c3a <alltraps>

8010615b <vector12>:
.globl vector12
vector12:
  pushl $12
8010615b:	6a 0c                	push   $0xc
  jmp alltraps
8010615d:	e9 d8 fa ff ff       	jmp    80105c3a <alltraps>

80106162 <vector13>:
.globl vector13
vector13:
  pushl $13
80106162:	6a 0d                	push   $0xd
  jmp alltraps
80106164:	e9 d1 fa ff ff       	jmp    80105c3a <alltraps>

80106169 <vector14>:
.globl vector14
vector14:
  pushl $14
80106169:	6a 0e                	push   $0xe
  jmp alltraps
8010616b:	e9 ca fa ff ff       	jmp    80105c3a <alltraps>

80106170 <vector15>:
.globl vector15
vector15:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $15
80106172:	6a 0f                	push   $0xf
  jmp alltraps
80106174:	e9 c1 fa ff ff       	jmp    80105c3a <alltraps>

80106179 <vector16>:
.globl vector16
vector16:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $16
8010617b:	6a 10                	push   $0x10
  jmp alltraps
8010617d:	e9 b8 fa ff ff       	jmp    80105c3a <alltraps>

80106182 <vector17>:
.globl vector17
vector17:
  pushl $17
80106182:	6a 11                	push   $0x11
  jmp alltraps
80106184:	e9 b1 fa ff ff       	jmp    80105c3a <alltraps>

80106189 <vector18>:
.globl vector18
vector18:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $18
8010618b:	6a 12                	push   $0x12
  jmp alltraps
8010618d:	e9 a8 fa ff ff       	jmp    80105c3a <alltraps>

80106192 <vector19>:
.globl vector19
vector19:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $19
80106194:	6a 13                	push   $0x13
  jmp alltraps
80106196:	e9 9f fa ff ff       	jmp    80105c3a <alltraps>

8010619b <vector20>:
.globl vector20
vector20:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $20
8010619d:	6a 14                	push   $0x14
  jmp alltraps
8010619f:	e9 96 fa ff ff       	jmp    80105c3a <alltraps>

801061a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $21
801061a6:	6a 15                	push   $0x15
  jmp alltraps
801061a8:	e9 8d fa ff ff       	jmp    80105c3a <alltraps>

801061ad <vector22>:
.globl vector22
vector22:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $22
801061af:	6a 16                	push   $0x16
  jmp alltraps
801061b1:	e9 84 fa ff ff       	jmp    80105c3a <alltraps>

801061b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $23
801061b8:	6a 17                	push   $0x17
  jmp alltraps
801061ba:	e9 7b fa ff ff       	jmp    80105c3a <alltraps>

801061bf <vector24>:
.globl vector24
vector24:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $24
801061c1:	6a 18                	push   $0x18
  jmp alltraps
801061c3:	e9 72 fa ff ff       	jmp    80105c3a <alltraps>

801061c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $25
801061ca:	6a 19                	push   $0x19
  jmp alltraps
801061cc:	e9 69 fa ff ff       	jmp    80105c3a <alltraps>

801061d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $26
801061d3:	6a 1a                	push   $0x1a
  jmp alltraps
801061d5:	e9 60 fa ff ff       	jmp    80105c3a <alltraps>

801061da <vector27>:
.globl vector27
vector27:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $27
801061dc:	6a 1b                	push   $0x1b
  jmp alltraps
801061de:	e9 57 fa ff ff       	jmp    80105c3a <alltraps>

801061e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $28
801061e5:	6a 1c                	push   $0x1c
  jmp alltraps
801061e7:	e9 4e fa ff ff       	jmp    80105c3a <alltraps>

801061ec <vector29>:
.globl vector29
vector29:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $29
801061ee:	6a 1d                	push   $0x1d
  jmp alltraps
801061f0:	e9 45 fa ff ff       	jmp    80105c3a <alltraps>

801061f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $30
801061f7:	6a 1e                	push   $0x1e
  jmp alltraps
801061f9:	e9 3c fa ff ff       	jmp    80105c3a <alltraps>

801061fe <vector31>:
.globl vector31
vector31:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $31
80106200:	6a 1f                	push   $0x1f
  jmp alltraps
80106202:	e9 33 fa ff ff       	jmp    80105c3a <alltraps>

80106207 <vector32>:
.globl vector32
vector32:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $32
80106209:	6a 20                	push   $0x20
  jmp alltraps
8010620b:	e9 2a fa ff ff       	jmp    80105c3a <alltraps>

80106210 <vector33>:
.globl vector33
vector33:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $33
80106212:	6a 21                	push   $0x21
  jmp alltraps
80106214:	e9 21 fa ff ff       	jmp    80105c3a <alltraps>

80106219 <vector34>:
.globl vector34
vector34:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $34
8010621b:	6a 22                	push   $0x22
  jmp alltraps
8010621d:	e9 18 fa ff ff       	jmp    80105c3a <alltraps>

80106222 <vector35>:
.globl vector35
vector35:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $35
80106224:	6a 23                	push   $0x23
  jmp alltraps
80106226:	e9 0f fa ff ff       	jmp    80105c3a <alltraps>

8010622b <vector36>:
.globl vector36
vector36:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $36
8010622d:	6a 24                	push   $0x24
  jmp alltraps
8010622f:	e9 06 fa ff ff       	jmp    80105c3a <alltraps>

80106234 <vector37>:
.globl vector37
vector37:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $37
80106236:	6a 25                	push   $0x25
  jmp alltraps
80106238:	e9 fd f9 ff ff       	jmp    80105c3a <alltraps>

8010623d <vector38>:
.globl vector38
vector38:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $38
8010623f:	6a 26                	push   $0x26
  jmp alltraps
80106241:	e9 f4 f9 ff ff       	jmp    80105c3a <alltraps>

80106246 <vector39>:
.globl vector39
vector39:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $39
80106248:	6a 27                	push   $0x27
  jmp alltraps
8010624a:	e9 eb f9 ff ff       	jmp    80105c3a <alltraps>

8010624f <vector40>:
.globl vector40
vector40:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $40
80106251:	6a 28                	push   $0x28
  jmp alltraps
80106253:	e9 e2 f9 ff ff       	jmp    80105c3a <alltraps>

80106258 <vector41>:
.globl vector41
vector41:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $41
8010625a:	6a 29                	push   $0x29
  jmp alltraps
8010625c:	e9 d9 f9 ff ff       	jmp    80105c3a <alltraps>

80106261 <vector42>:
.globl vector42
vector42:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $42
80106263:	6a 2a                	push   $0x2a
  jmp alltraps
80106265:	e9 d0 f9 ff ff       	jmp    80105c3a <alltraps>

8010626a <vector43>:
.globl vector43
vector43:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $43
8010626c:	6a 2b                	push   $0x2b
  jmp alltraps
8010626e:	e9 c7 f9 ff ff       	jmp    80105c3a <alltraps>

80106273 <vector44>:
.globl vector44
vector44:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $44
80106275:	6a 2c                	push   $0x2c
  jmp alltraps
80106277:	e9 be f9 ff ff       	jmp    80105c3a <alltraps>

8010627c <vector45>:
.globl vector45
vector45:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $45
8010627e:	6a 2d                	push   $0x2d
  jmp alltraps
80106280:	e9 b5 f9 ff ff       	jmp    80105c3a <alltraps>

80106285 <vector46>:
.globl vector46
vector46:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $46
80106287:	6a 2e                	push   $0x2e
  jmp alltraps
80106289:	e9 ac f9 ff ff       	jmp    80105c3a <alltraps>

8010628e <vector47>:
.globl vector47
vector47:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $47
80106290:	6a 2f                	push   $0x2f
  jmp alltraps
80106292:	e9 a3 f9 ff ff       	jmp    80105c3a <alltraps>

80106297 <vector48>:
.globl vector48
vector48:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $48
80106299:	6a 30                	push   $0x30
  jmp alltraps
8010629b:	e9 9a f9 ff ff       	jmp    80105c3a <alltraps>

801062a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $49
801062a2:	6a 31                	push   $0x31
  jmp alltraps
801062a4:	e9 91 f9 ff ff       	jmp    80105c3a <alltraps>

801062a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $50
801062ab:	6a 32                	push   $0x32
  jmp alltraps
801062ad:	e9 88 f9 ff ff       	jmp    80105c3a <alltraps>

801062b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $51
801062b4:	6a 33                	push   $0x33
  jmp alltraps
801062b6:	e9 7f f9 ff ff       	jmp    80105c3a <alltraps>

801062bb <vector52>:
.globl vector52
vector52:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $52
801062bd:	6a 34                	push   $0x34
  jmp alltraps
801062bf:	e9 76 f9 ff ff       	jmp    80105c3a <alltraps>

801062c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $53
801062c6:	6a 35                	push   $0x35
  jmp alltraps
801062c8:	e9 6d f9 ff ff       	jmp    80105c3a <alltraps>

801062cd <vector54>:
.globl vector54
vector54:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $54
801062cf:	6a 36                	push   $0x36
  jmp alltraps
801062d1:	e9 64 f9 ff ff       	jmp    80105c3a <alltraps>

801062d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $55
801062d8:	6a 37                	push   $0x37
  jmp alltraps
801062da:	e9 5b f9 ff ff       	jmp    80105c3a <alltraps>

801062df <vector56>:
.globl vector56
vector56:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $56
801062e1:	6a 38                	push   $0x38
  jmp alltraps
801062e3:	e9 52 f9 ff ff       	jmp    80105c3a <alltraps>

801062e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $57
801062ea:	6a 39                	push   $0x39
  jmp alltraps
801062ec:	e9 49 f9 ff ff       	jmp    80105c3a <alltraps>

801062f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $58
801062f3:	6a 3a                	push   $0x3a
  jmp alltraps
801062f5:	e9 40 f9 ff ff       	jmp    80105c3a <alltraps>

801062fa <vector59>:
.globl vector59
vector59:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $59
801062fc:	6a 3b                	push   $0x3b
  jmp alltraps
801062fe:	e9 37 f9 ff ff       	jmp    80105c3a <alltraps>

80106303 <vector60>:
.globl vector60
vector60:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $60
80106305:	6a 3c                	push   $0x3c
  jmp alltraps
80106307:	e9 2e f9 ff ff       	jmp    80105c3a <alltraps>

8010630c <vector61>:
.globl vector61
vector61:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $61
8010630e:	6a 3d                	push   $0x3d
  jmp alltraps
80106310:	e9 25 f9 ff ff       	jmp    80105c3a <alltraps>

80106315 <vector62>:
.globl vector62
vector62:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $62
80106317:	6a 3e                	push   $0x3e
  jmp alltraps
80106319:	e9 1c f9 ff ff       	jmp    80105c3a <alltraps>

8010631e <vector63>:
.globl vector63
vector63:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $63
80106320:	6a 3f                	push   $0x3f
  jmp alltraps
80106322:	e9 13 f9 ff ff       	jmp    80105c3a <alltraps>

80106327 <vector64>:
.globl vector64
vector64:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $64
80106329:	6a 40                	push   $0x40
  jmp alltraps
8010632b:	e9 0a f9 ff ff       	jmp    80105c3a <alltraps>

80106330 <vector65>:
.globl vector65
vector65:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $65
80106332:	6a 41                	push   $0x41
  jmp alltraps
80106334:	e9 01 f9 ff ff       	jmp    80105c3a <alltraps>

80106339 <vector66>:
.globl vector66
vector66:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $66
8010633b:	6a 42                	push   $0x42
  jmp alltraps
8010633d:	e9 f8 f8 ff ff       	jmp    80105c3a <alltraps>

80106342 <vector67>:
.globl vector67
vector67:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $67
80106344:	6a 43                	push   $0x43
  jmp alltraps
80106346:	e9 ef f8 ff ff       	jmp    80105c3a <alltraps>

8010634b <vector68>:
.globl vector68
vector68:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $68
8010634d:	6a 44                	push   $0x44
  jmp alltraps
8010634f:	e9 e6 f8 ff ff       	jmp    80105c3a <alltraps>

80106354 <vector69>:
.globl vector69
vector69:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $69
80106356:	6a 45                	push   $0x45
  jmp alltraps
80106358:	e9 dd f8 ff ff       	jmp    80105c3a <alltraps>

8010635d <vector70>:
.globl vector70
vector70:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $70
8010635f:	6a 46                	push   $0x46
  jmp alltraps
80106361:	e9 d4 f8 ff ff       	jmp    80105c3a <alltraps>

80106366 <vector71>:
.globl vector71
vector71:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $71
80106368:	6a 47                	push   $0x47
  jmp alltraps
8010636a:	e9 cb f8 ff ff       	jmp    80105c3a <alltraps>

8010636f <vector72>:
.globl vector72
vector72:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $72
80106371:	6a 48                	push   $0x48
  jmp alltraps
80106373:	e9 c2 f8 ff ff       	jmp    80105c3a <alltraps>

80106378 <vector73>:
.globl vector73
vector73:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $73
8010637a:	6a 49                	push   $0x49
  jmp alltraps
8010637c:	e9 b9 f8 ff ff       	jmp    80105c3a <alltraps>

80106381 <vector74>:
.globl vector74
vector74:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $74
80106383:	6a 4a                	push   $0x4a
  jmp alltraps
80106385:	e9 b0 f8 ff ff       	jmp    80105c3a <alltraps>

8010638a <vector75>:
.globl vector75
vector75:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $75
8010638c:	6a 4b                	push   $0x4b
  jmp alltraps
8010638e:	e9 a7 f8 ff ff       	jmp    80105c3a <alltraps>

80106393 <vector76>:
.globl vector76
vector76:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $76
80106395:	6a 4c                	push   $0x4c
  jmp alltraps
80106397:	e9 9e f8 ff ff       	jmp    80105c3a <alltraps>

8010639c <vector77>:
.globl vector77
vector77:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $77
8010639e:	6a 4d                	push   $0x4d
  jmp alltraps
801063a0:	e9 95 f8 ff ff       	jmp    80105c3a <alltraps>

801063a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $78
801063a7:	6a 4e                	push   $0x4e
  jmp alltraps
801063a9:	e9 8c f8 ff ff       	jmp    80105c3a <alltraps>

801063ae <vector79>:
.globl vector79
vector79:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $79
801063b0:	6a 4f                	push   $0x4f
  jmp alltraps
801063b2:	e9 83 f8 ff ff       	jmp    80105c3a <alltraps>

801063b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $80
801063b9:	6a 50                	push   $0x50
  jmp alltraps
801063bb:	e9 7a f8 ff ff       	jmp    80105c3a <alltraps>

801063c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $81
801063c2:	6a 51                	push   $0x51
  jmp alltraps
801063c4:	e9 71 f8 ff ff       	jmp    80105c3a <alltraps>

801063c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $82
801063cb:	6a 52                	push   $0x52
  jmp alltraps
801063cd:	e9 68 f8 ff ff       	jmp    80105c3a <alltraps>

801063d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $83
801063d4:	6a 53                	push   $0x53
  jmp alltraps
801063d6:	e9 5f f8 ff ff       	jmp    80105c3a <alltraps>

801063db <vector84>:
.globl vector84
vector84:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $84
801063dd:	6a 54                	push   $0x54
  jmp alltraps
801063df:	e9 56 f8 ff ff       	jmp    80105c3a <alltraps>

801063e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $85
801063e6:	6a 55                	push   $0x55
  jmp alltraps
801063e8:	e9 4d f8 ff ff       	jmp    80105c3a <alltraps>

801063ed <vector86>:
.globl vector86
vector86:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $86
801063ef:	6a 56                	push   $0x56
  jmp alltraps
801063f1:	e9 44 f8 ff ff       	jmp    80105c3a <alltraps>

801063f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $87
801063f8:	6a 57                	push   $0x57
  jmp alltraps
801063fa:	e9 3b f8 ff ff       	jmp    80105c3a <alltraps>

801063ff <vector88>:
.globl vector88
vector88:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $88
80106401:	6a 58                	push   $0x58
  jmp alltraps
80106403:	e9 32 f8 ff ff       	jmp    80105c3a <alltraps>

80106408 <vector89>:
.globl vector89
vector89:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $89
8010640a:	6a 59                	push   $0x59
  jmp alltraps
8010640c:	e9 29 f8 ff ff       	jmp    80105c3a <alltraps>

80106411 <vector90>:
.globl vector90
vector90:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $90
80106413:	6a 5a                	push   $0x5a
  jmp alltraps
80106415:	e9 20 f8 ff ff       	jmp    80105c3a <alltraps>

8010641a <vector91>:
.globl vector91
vector91:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $91
8010641c:	6a 5b                	push   $0x5b
  jmp alltraps
8010641e:	e9 17 f8 ff ff       	jmp    80105c3a <alltraps>

80106423 <vector92>:
.globl vector92
vector92:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $92
80106425:	6a 5c                	push   $0x5c
  jmp alltraps
80106427:	e9 0e f8 ff ff       	jmp    80105c3a <alltraps>

8010642c <vector93>:
.globl vector93
vector93:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $93
8010642e:	6a 5d                	push   $0x5d
  jmp alltraps
80106430:	e9 05 f8 ff ff       	jmp    80105c3a <alltraps>

80106435 <vector94>:
.globl vector94
vector94:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $94
80106437:	6a 5e                	push   $0x5e
  jmp alltraps
80106439:	e9 fc f7 ff ff       	jmp    80105c3a <alltraps>

8010643e <vector95>:
.globl vector95
vector95:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $95
80106440:	6a 5f                	push   $0x5f
  jmp alltraps
80106442:	e9 f3 f7 ff ff       	jmp    80105c3a <alltraps>

80106447 <vector96>:
.globl vector96
vector96:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $96
80106449:	6a 60                	push   $0x60
  jmp alltraps
8010644b:	e9 ea f7 ff ff       	jmp    80105c3a <alltraps>

80106450 <vector97>:
.globl vector97
vector97:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $97
80106452:	6a 61                	push   $0x61
  jmp alltraps
80106454:	e9 e1 f7 ff ff       	jmp    80105c3a <alltraps>

80106459 <vector98>:
.globl vector98
vector98:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $98
8010645b:	6a 62                	push   $0x62
  jmp alltraps
8010645d:	e9 d8 f7 ff ff       	jmp    80105c3a <alltraps>

80106462 <vector99>:
.globl vector99
vector99:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $99
80106464:	6a 63                	push   $0x63
  jmp alltraps
80106466:	e9 cf f7 ff ff       	jmp    80105c3a <alltraps>

8010646b <vector100>:
.globl vector100
vector100:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $100
8010646d:	6a 64                	push   $0x64
  jmp alltraps
8010646f:	e9 c6 f7 ff ff       	jmp    80105c3a <alltraps>

80106474 <vector101>:
.globl vector101
vector101:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $101
80106476:	6a 65                	push   $0x65
  jmp alltraps
80106478:	e9 bd f7 ff ff       	jmp    80105c3a <alltraps>

8010647d <vector102>:
.globl vector102
vector102:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $102
8010647f:	6a 66                	push   $0x66
  jmp alltraps
80106481:	e9 b4 f7 ff ff       	jmp    80105c3a <alltraps>

80106486 <vector103>:
.globl vector103
vector103:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $103
80106488:	6a 67                	push   $0x67
  jmp alltraps
8010648a:	e9 ab f7 ff ff       	jmp    80105c3a <alltraps>

8010648f <vector104>:
.globl vector104
vector104:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $104
80106491:	6a 68                	push   $0x68
  jmp alltraps
80106493:	e9 a2 f7 ff ff       	jmp    80105c3a <alltraps>

80106498 <vector105>:
.globl vector105
vector105:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $105
8010649a:	6a 69                	push   $0x69
  jmp alltraps
8010649c:	e9 99 f7 ff ff       	jmp    80105c3a <alltraps>

801064a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $106
801064a3:	6a 6a                	push   $0x6a
  jmp alltraps
801064a5:	e9 90 f7 ff ff       	jmp    80105c3a <alltraps>

801064aa <vector107>:
.globl vector107
vector107:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $107
801064ac:	6a 6b                	push   $0x6b
  jmp alltraps
801064ae:	e9 87 f7 ff ff       	jmp    80105c3a <alltraps>

801064b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $108
801064b5:	6a 6c                	push   $0x6c
  jmp alltraps
801064b7:	e9 7e f7 ff ff       	jmp    80105c3a <alltraps>

801064bc <vector109>:
.globl vector109
vector109:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $109
801064be:	6a 6d                	push   $0x6d
  jmp alltraps
801064c0:	e9 75 f7 ff ff       	jmp    80105c3a <alltraps>

801064c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $110
801064c7:	6a 6e                	push   $0x6e
  jmp alltraps
801064c9:	e9 6c f7 ff ff       	jmp    80105c3a <alltraps>

801064ce <vector111>:
.globl vector111
vector111:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $111
801064d0:	6a 6f                	push   $0x6f
  jmp alltraps
801064d2:	e9 63 f7 ff ff       	jmp    80105c3a <alltraps>

801064d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $112
801064d9:	6a 70                	push   $0x70
  jmp alltraps
801064db:	e9 5a f7 ff ff       	jmp    80105c3a <alltraps>

801064e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $113
801064e2:	6a 71                	push   $0x71
  jmp alltraps
801064e4:	e9 51 f7 ff ff       	jmp    80105c3a <alltraps>

801064e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $114
801064eb:	6a 72                	push   $0x72
  jmp alltraps
801064ed:	e9 48 f7 ff ff       	jmp    80105c3a <alltraps>

801064f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $115
801064f4:	6a 73                	push   $0x73
  jmp alltraps
801064f6:	e9 3f f7 ff ff       	jmp    80105c3a <alltraps>

801064fb <vector116>:
.globl vector116
vector116:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $116
801064fd:	6a 74                	push   $0x74
  jmp alltraps
801064ff:	e9 36 f7 ff ff       	jmp    80105c3a <alltraps>

80106504 <vector117>:
.globl vector117
vector117:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $117
80106506:	6a 75                	push   $0x75
  jmp alltraps
80106508:	e9 2d f7 ff ff       	jmp    80105c3a <alltraps>

8010650d <vector118>:
.globl vector118
vector118:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $118
8010650f:	6a 76                	push   $0x76
  jmp alltraps
80106511:	e9 24 f7 ff ff       	jmp    80105c3a <alltraps>

80106516 <vector119>:
.globl vector119
vector119:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $119
80106518:	6a 77                	push   $0x77
  jmp alltraps
8010651a:	e9 1b f7 ff ff       	jmp    80105c3a <alltraps>

8010651f <vector120>:
.globl vector120
vector120:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $120
80106521:	6a 78                	push   $0x78
  jmp alltraps
80106523:	e9 12 f7 ff ff       	jmp    80105c3a <alltraps>

80106528 <vector121>:
.globl vector121
vector121:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $121
8010652a:	6a 79                	push   $0x79
  jmp alltraps
8010652c:	e9 09 f7 ff ff       	jmp    80105c3a <alltraps>

80106531 <vector122>:
.globl vector122
vector122:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $122
80106533:	6a 7a                	push   $0x7a
  jmp alltraps
80106535:	e9 00 f7 ff ff       	jmp    80105c3a <alltraps>

8010653a <vector123>:
.globl vector123
vector123:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $123
8010653c:	6a 7b                	push   $0x7b
  jmp alltraps
8010653e:	e9 f7 f6 ff ff       	jmp    80105c3a <alltraps>

80106543 <vector124>:
.globl vector124
vector124:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $124
80106545:	6a 7c                	push   $0x7c
  jmp alltraps
80106547:	e9 ee f6 ff ff       	jmp    80105c3a <alltraps>

8010654c <vector125>:
.globl vector125
vector125:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $125
8010654e:	6a 7d                	push   $0x7d
  jmp alltraps
80106550:	e9 e5 f6 ff ff       	jmp    80105c3a <alltraps>

80106555 <vector126>:
.globl vector126
vector126:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $126
80106557:	6a 7e                	push   $0x7e
  jmp alltraps
80106559:	e9 dc f6 ff ff       	jmp    80105c3a <alltraps>

8010655e <vector127>:
.globl vector127
vector127:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $127
80106560:	6a 7f                	push   $0x7f
  jmp alltraps
80106562:	e9 d3 f6 ff ff       	jmp    80105c3a <alltraps>

80106567 <vector128>:
.globl vector128
vector128:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $128
80106569:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010656e:	e9 c7 f6 ff ff       	jmp    80105c3a <alltraps>

80106573 <vector129>:
.globl vector129
vector129:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $129
80106575:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010657a:	e9 bb f6 ff ff       	jmp    80105c3a <alltraps>

8010657f <vector130>:
.globl vector130
vector130:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $130
80106581:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106586:	e9 af f6 ff ff       	jmp    80105c3a <alltraps>

8010658b <vector131>:
.globl vector131
vector131:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $131
8010658d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106592:	e9 a3 f6 ff ff       	jmp    80105c3a <alltraps>

80106597 <vector132>:
.globl vector132
vector132:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $132
80106599:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010659e:	e9 97 f6 ff ff       	jmp    80105c3a <alltraps>

801065a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $133
801065a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065aa:	e9 8b f6 ff ff       	jmp    80105c3a <alltraps>

801065af <vector134>:
.globl vector134
vector134:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $134
801065b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065b6:	e9 7f f6 ff ff       	jmp    80105c3a <alltraps>

801065bb <vector135>:
.globl vector135
vector135:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $135
801065bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065c2:	e9 73 f6 ff ff       	jmp    80105c3a <alltraps>

801065c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $136
801065c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065ce:	e9 67 f6 ff ff       	jmp    80105c3a <alltraps>

801065d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $137
801065d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065da:	e9 5b f6 ff ff       	jmp    80105c3a <alltraps>

801065df <vector138>:
.globl vector138
vector138:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $138
801065e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801065e6:	e9 4f f6 ff ff       	jmp    80105c3a <alltraps>

801065eb <vector139>:
.globl vector139
vector139:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $139
801065ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801065f2:	e9 43 f6 ff ff       	jmp    80105c3a <alltraps>

801065f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $140
801065f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801065fe:	e9 37 f6 ff ff       	jmp    80105c3a <alltraps>

80106603 <vector141>:
.globl vector141
vector141:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $141
80106605:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010660a:	e9 2b f6 ff ff       	jmp    80105c3a <alltraps>

8010660f <vector142>:
.globl vector142
vector142:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $142
80106611:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106616:	e9 1f f6 ff ff       	jmp    80105c3a <alltraps>

8010661b <vector143>:
.globl vector143
vector143:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $143
8010661d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106622:	e9 13 f6 ff ff       	jmp    80105c3a <alltraps>

80106627 <vector144>:
.globl vector144
vector144:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $144
80106629:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010662e:	e9 07 f6 ff ff       	jmp    80105c3a <alltraps>

80106633 <vector145>:
.globl vector145
vector145:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $145
80106635:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010663a:	e9 fb f5 ff ff       	jmp    80105c3a <alltraps>

8010663f <vector146>:
.globl vector146
vector146:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $146
80106641:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106646:	e9 ef f5 ff ff       	jmp    80105c3a <alltraps>

8010664b <vector147>:
.globl vector147
vector147:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $147
8010664d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106652:	e9 e3 f5 ff ff       	jmp    80105c3a <alltraps>

80106657 <vector148>:
.globl vector148
vector148:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $148
80106659:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010665e:	e9 d7 f5 ff ff       	jmp    80105c3a <alltraps>

80106663 <vector149>:
.globl vector149
vector149:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $149
80106665:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010666a:	e9 cb f5 ff ff       	jmp    80105c3a <alltraps>

8010666f <vector150>:
.globl vector150
vector150:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $150
80106671:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106676:	e9 bf f5 ff ff       	jmp    80105c3a <alltraps>

8010667b <vector151>:
.globl vector151
vector151:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $151
8010667d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106682:	e9 b3 f5 ff ff       	jmp    80105c3a <alltraps>

80106687 <vector152>:
.globl vector152
vector152:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $152
80106689:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010668e:	e9 a7 f5 ff ff       	jmp    80105c3a <alltraps>

80106693 <vector153>:
.globl vector153
vector153:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $153
80106695:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010669a:	e9 9b f5 ff ff       	jmp    80105c3a <alltraps>

8010669f <vector154>:
.globl vector154
vector154:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $154
801066a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066a6:	e9 8f f5 ff ff       	jmp    80105c3a <alltraps>

801066ab <vector155>:
.globl vector155
vector155:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $155
801066ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066b2:	e9 83 f5 ff ff       	jmp    80105c3a <alltraps>

801066b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $156
801066b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066be:	e9 77 f5 ff ff       	jmp    80105c3a <alltraps>

801066c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $157
801066c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066ca:	e9 6b f5 ff ff       	jmp    80105c3a <alltraps>

801066cf <vector158>:
.globl vector158
vector158:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $158
801066d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066d6:	e9 5f f5 ff ff       	jmp    80105c3a <alltraps>

801066db <vector159>:
.globl vector159
vector159:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $159
801066dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801066e2:	e9 53 f5 ff ff       	jmp    80105c3a <alltraps>

801066e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $160
801066e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801066ee:	e9 47 f5 ff ff       	jmp    80105c3a <alltraps>

801066f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $161
801066f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801066fa:	e9 3b f5 ff ff       	jmp    80105c3a <alltraps>

801066ff <vector162>:
.globl vector162
vector162:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $162
80106701:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106706:	e9 2f f5 ff ff       	jmp    80105c3a <alltraps>

8010670b <vector163>:
.globl vector163
vector163:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $163
8010670d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106712:	e9 23 f5 ff ff       	jmp    80105c3a <alltraps>

80106717 <vector164>:
.globl vector164
vector164:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $164
80106719:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010671e:	e9 17 f5 ff ff       	jmp    80105c3a <alltraps>

80106723 <vector165>:
.globl vector165
vector165:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $165
80106725:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010672a:	e9 0b f5 ff ff       	jmp    80105c3a <alltraps>

8010672f <vector166>:
.globl vector166
vector166:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $166
80106731:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106736:	e9 ff f4 ff ff       	jmp    80105c3a <alltraps>

8010673b <vector167>:
.globl vector167
vector167:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $167
8010673d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106742:	e9 f3 f4 ff ff       	jmp    80105c3a <alltraps>

80106747 <vector168>:
.globl vector168
vector168:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $168
80106749:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010674e:	e9 e7 f4 ff ff       	jmp    80105c3a <alltraps>

80106753 <vector169>:
.globl vector169
vector169:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $169
80106755:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010675a:	e9 db f4 ff ff       	jmp    80105c3a <alltraps>

8010675f <vector170>:
.globl vector170
vector170:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $170
80106761:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106766:	e9 cf f4 ff ff       	jmp    80105c3a <alltraps>

8010676b <vector171>:
.globl vector171
vector171:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $171
8010676d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106772:	e9 c3 f4 ff ff       	jmp    80105c3a <alltraps>

80106777 <vector172>:
.globl vector172
vector172:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $172
80106779:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010677e:	e9 b7 f4 ff ff       	jmp    80105c3a <alltraps>

80106783 <vector173>:
.globl vector173
vector173:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $173
80106785:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010678a:	e9 ab f4 ff ff       	jmp    80105c3a <alltraps>

8010678f <vector174>:
.globl vector174
vector174:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $174
80106791:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106796:	e9 9f f4 ff ff       	jmp    80105c3a <alltraps>

8010679b <vector175>:
.globl vector175
vector175:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $175
8010679d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067a2:	e9 93 f4 ff ff       	jmp    80105c3a <alltraps>

801067a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $176
801067a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067ae:	e9 87 f4 ff ff       	jmp    80105c3a <alltraps>

801067b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $177
801067b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067ba:	e9 7b f4 ff ff       	jmp    80105c3a <alltraps>

801067bf <vector178>:
.globl vector178
vector178:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $178
801067c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067c6:	e9 6f f4 ff ff       	jmp    80105c3a <alltraps>

801067cb <vector179>:
.globl vector179
vector179:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $179
801067cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067d2:	e9 63 f4 ff ff       	jmp    80105c3a <alltraps>

801067d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $180
801067d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067de:	e9 57 f4 ff ff       	jmp    80105c3a <alltraps>

801067e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $181
801067e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801067ea:	e9 4b f4 ff ff       	jmp    80105c3a <alltraps>

801067ef <vector182>:
.globl vector182
vector182:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $182
801067f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801067f6:	e9 3f f4 ff ff       	jmp    80105c3a <alltraps>

801067fb <vector183>:
.globl vector183
vector183:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $183
801067fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106802:	e9 33 f4 ff ff       	jmp    80105c3a <alltraps>

80106807 <vector184>:
.globl vector184
vector184:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $184
80106809:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010680e:	e9 27 f4 ff ff       	jmp    80105c3a <alltraps>

80106813 <vector185>:
.globl vector185
vector185:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $185
80106815:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010681a:	e9 1b f4 ff ff       	jmp    80105c3a <alltraps>

8010681f <vector186>:
.globl vector186
vector186:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $186
80106821:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106826:	e9 0f f4 ff ff       	jmp    80105c3a <alltraps>

8010682b <vector187>:
.globl vector187
vector187:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $187
8010682d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106832:	e9 03 f4 ff ff       	jmp    80105c3a <alltraps>

80106837 <vector188>:
.globl vector188
vector188:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $188
80106839:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010683e:	e9 f7 f3 ff ff       	jmp    80105c3a <alltraps>

80106843 <vector189>:
.globl vector189
vector189:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $189
80106845:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010684a:	e9 eb f3 ff ff       	jmp    80105c3a <alltraps>

8010684f <vector190>:
.globl vector190
vector190:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $190
80106851:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106856:	e9 df f3 ff ff       	jmp    80105c3a <alltraps>

8010685b <vector191>:
.globl vector191
vector191:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $191
8010685d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106862:	e9 d3 f3 ff ff       	jmp    80105c3a <alltraps>

80106867 <vector192>:
.globl vector192
vector192:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $192
80106869:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010686e:	e9 c7 f3 ff ff       	jmp    80105c3a <alltraps>

80106873 <vector193>:
.globl vector193
vector193:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $193
80106875:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010687a:	e9 bb f3 ff ff       	jmp    80105c3a <alltraps>

8010687f <vector194>:
.globl vector194
vector194:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $194
80106881:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106886:	e9 af f3 ff ff       	jmp    80105c3a <alltraps>

8010688b <vector195>:
.globl vector195
vector195:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $195
8010688d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106892:	e9 a3 f3 ff ff       	jmp    80105c3a <alltraps>

80106897 <vector196>:
.globl vector196
vector196:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $196
80106899:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010689e:	e9 97 f3 ff ff       	jmp    80105c3a <alltraps>

801068a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $197
801068a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068aa:	e9 8b f3 ff ff       	jmp    80105c3a <alltraps>

801068af <vector198>:
.globl vector198
vector198:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $198
801068b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068b6:	e9 7f f3 ff ff       	jmp    80105c3a <alltraps>

801068bb <vector199>:
.globl vector199
vector199:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $199
801068bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068c2:	e9 73 f3 ff ff       	jmp    80105c3a <alltraps>

801068c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $200
801068c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068ce:	e9 67 f3 ff ff       	jmp    80105c3a <alltraps>

801068d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $201
801068d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068da:	e9 5b f3 ff ff       	jmp    80105c3a <alltraps>

801068df <vector202>:
.globl vector202
vector202:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $202
801068e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801068e6:	e9 4f f3 ff ff       	jmp    80105c3a <alltraps>

801068eb <vector203>:
.globl vector203
vector203:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $203
801068ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801068f2:	e9 43 f3 ff ff       	jmp    80105c3a <alltraps>

801068f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $204
801068f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801068fe:	e9 37 f3 ff ff       	jmp    80105c3a <alltraps>

80106903 <vector205>:
.globl vector205
vector205:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $205
80106905:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010690a:	e9 2b f3 ff ff       	jmp    80105c3a <alltraps>

8010690f <vector206>:
.globl vector206
vector206:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $206
80106911:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106916:	e9 1f f3 ff ff       	jmp    80105c3a <alltraps>

8010691b <vector207>:
.globl vector207
vector207:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $207
8010691d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106922:	e9 13 f3 ff ff       	jmp    80105c3a <alltraps>

80106927 <vector208>:
.globl vector208
vector208:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $208
80106929:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010692e:	e9 07 f3 ff ff       	jmp    80105c3a <alltraps>

80106933 <vector209>:
.globl vector209
vector209:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $209
80106935:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010693a:	e9 fb f2 ff ff       	jmp    80105c3a <alltraps>

8010693f <vector210>:
.globl vector210
vector210:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $210
80106941:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106946:	e9 ef f2 ff ff       	jmp    80105c3a <alltraps>

8010694b <vector211>:
.globl vector211
vector211:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $211
8010694d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106952:	e9 e3 f2 ff ff       	jmp    80105c3a <alltraps>

80106957 <vector212>:
.globl vector212
vector212:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $212
80106959:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010695e:	e9 d7 f2 ff ff       	jmp    80105c3a <alltraps>

80106963 <vector213>:
.globl vector213
vector213:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $213
80106965:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010696a:	e9 cb f2 ff ff       	jmp    80105c3a <alltraps>

8010696f <vector214>:
.globl vector214
vector214:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $214
80106971:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106976:	e9 bf f2 ff ff       	jmp    80105c3a <alltraps>

8010697b <vector215>:
.globl vector215
vector215:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $215
8010697d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106982:	e9 b3 f2 ff ff       	jmp    80105c3a <alltraps>

80106987 <vector216>:
.globl vector216
vector216:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $216
80106989:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010698e:	e9 a7 f2 ff ff       	jmp    80105c3a <alltraps>

80106993 <vector217>:
.globl vector217
vector217:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $217
80106995:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010699a:	e9 9b f2 ff ff       	jmp    80105c3a <alltraps>

8010699f <vector218>:
.globl vector218
vector218:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $218
801069a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069a6:	e9 8f f2 ff ff       	jmp    80105c3a <alltraps>

801069ab <vector219>:
.globl vector219
vector219:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $219
801069ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069b2:	e9 83 f2 ff ff       	jmp    80105c3a <alltraps>

801069b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $220
801069b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069be:	e9 77 f2 ff ff       	jmp    80105c3a <alltraps>

801069c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $221
801069c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069ca:	e9 6b f2 ff ff       	jmp    80105c3a <alltraps>

801069cf <vector222>:
.globl vector222
vector222:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $222
801069d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069d6:	e9 5f f2 ff ff       	jmp    80105c3a <alltraps>

801069db <vector223>:
.globl vector223
vector223:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $223
801069dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801069e2:	e9 53 f2 ff ff       	jmp    80105c3a <alltraps>

801069e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $224
801069e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801069ee:	e9 47 f2 ff ff       	jmp    80105c3a <alltraps>

801069f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $225
801069f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801069fa:	e9 3b f2 ff ff       	jmp    80105c3a <alltraps>

801069ff <vector226>:
.globl vector226
vector226:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $226
80106a01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a06:	e9 2f f2 ff ff       	jmp    80105c3a <alltraps>

80106a0b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $227
80106a0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a12:	e9 23 f2 ff ff       	jmp    80105c3a <alltraps>

80106a17 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $228
80106a19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a1e:	e9 17 f2 ff ff       	jmp    80105c3a <alltraps>

80106a23 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $229
80106a25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a2a:	e9 0b f2 ff ff       	jmp    80105c3a <alltraps>

80106a2f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $230
80106a31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a36:	e9 ff f1 ff ff       	jmp    80105c3a <alltraps>

80106a3b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $231
80106a3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a42:	e9 f3 f1 ff ff       	jmp    80105c3a <alltraps>

80106a47 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $232
80106a49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a4e:	e9 e7 f1 ff ff       	jmp    80105c3a <alltraps>

80106a53 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $233
80106a55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a5a:	e9 db f1 ff ff       	jmp    80105c3a <alltraps>

80106a5f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $234
80106a61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a66:	e9 cf f1 ff ff       	jmp    80105c3a <alltraps>

80106a6b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $235
80106a6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a72:	e9 c3 f1 ff ff       	jmp    80105c3a <alltraps>

80106a77 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $236
80106a79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a7e:	e9 b7 f1 ff ff       	jmp    80105c3a <alltraps>

80106a83 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $237
80106a85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a8a:	e9 ab f1 ff ff       	jmp    80105c3a <alltraps>

80106a8f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $238
80106a91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a96:	e9 9f f1 ff ff       	jmp    80105c3a <alltraps>

80106a9b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $239
80106a9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106aa2:	e9 93 f1 ff ff       	jmp    80105c3a <alltraps>

80106aa7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $240
80106aa9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106aae:	e9 87 f1 ff ff       	jmp    80105c3a <alltraps>

80106ab3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $241
80106ab5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106aba:	e9 7b f1 ff ff       	jmp    80105c3a <alltraps>

80106abf <vector242>:
.globl vector242
vector242:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $242
80106ac1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ac6:	e9 6f f1 ff ff       	jmp    80105c3a <alltraps>

80106acb <vector243>:
.globl vector243
vector243:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $243
80106acd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ad2:	e9 63 f1 ff ff       	jmp    80105c3a <alltraps>

80106ad7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $244
80106ad9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106ade:	e9 57 f1 ff ff       	jmp    80105c3a <alltraps>

80106ae3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $245
80106ae5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106aea:	e9 4b f1 ff ff       	jmp    80105c3a <alltraps>

80106aef <vector246>:
.globl vector246
vector246:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $246
80106af1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106af6:	e9 3f f1 ff ff       	jmp    80105c3a <alltraps>

80106afb <vector247>:
.globl vector247
vector247:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $247
80106afd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b02:	e9 33 f1 ff ff       	jmp    80105c3a <alltraps>

80106b07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $248
80106b09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b0e:	e9 27 f1 ff ff       	jmp    80105c3a <alltraps>

80106b13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $249
80106b15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b1a:	e9 1b f1 ff ff       	jmp    80105c3a <alltraps>

80106b1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $250
80106b21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b26:	e9 0f f1 ff ff       	jmp    80105c3a <alltraps>

80106b2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $251
80106b2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b32:	e9 03 f1 ff ff       	jmp    80105c3a <alltraps>

80106b37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $252
80106b39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b3e:	e9 f7 f0 ff ff       	jmp    80105c3a <alltraps>

80106b43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $253
80106b45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b4a:	e9 eb f0 ff ff       	jmp    80105c3a <alltraps>

80106b4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $254
80106b51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b56:	e9 df f0 ff ff       	jmp    80105c3a <alltraps>

80106b5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $255
80106b5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b62:	e9 d3 f0 ff ff       	jmp    80105c3a <alltraps>
80106b67:	66 90                	xchg   %ax,%ax
80106b69:	66 90                	xchg   %ax,%ax
80106b6b:	66 90                	xchg   %ax,%ax
80106b6d:	66 90                	xchg   %ax,%ax
80106b6f:	90                   	nop

80106b70 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
80106b76:	89 d3                	mov    %edx,%ebx
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80106b78:	c1 ea 16             	shr    $0x16,%edx
80106b7b:	8d 3c 90             	lea    (%eax,%edx,4),%edi

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106b7e:	83 ec 0c             	sub    $0xc,%esp
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
80106b81:	8b 07                	mov    (%edi),%eax
80106b83:	a8 01                	test   $0x1,%al
80106b85:	74 29                	je     80106bb0 <walkpgdir+0x40>
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
80106b87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b8c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
}
80106b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
80106b95:	c1 eb 0a             	shr    $0xa,%ebx
80106b98:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106b9e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106ba1:	5b                   	pop    %ebx
80106ba2:	5e                   	pop    %esi
80106ba3:	5f                   	pop    %edi
80106ba4:	5d                   	pop    %ebp
80106ba5:	c3                   	ret    
80106ba6:	8d 76 00             	lea    0x0(%esi),%esi
80106ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
    } else {
        if (!alloc)
80106bb0:	85 c9                	test   %ecx,%ecx
80106bb2:	74 2c                	je     80106be0 <walkpgdir+0x70>

        // TODO HERE WE CREATE PYSYC MEMORY;
        // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
        // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.

        if ((pgtab = (pte_t *) kalloc()) == 0)
80106bb4:	e8 a7 bc ff ff       	call   80102860 <kalloc>
80106bb9:	85 c0                	test   %eax,%eax
80106bbb:	89 c6                	mov    %eax,%esi
80106bbd:	74 21                	je     80106be0 <walkpgdir+0x70>
            return 0;
        // Make sure all those PTE_P bits are zero.
        memset(pgtab, 0, PGSIZE);
80106bbf:	83 ec 04             	sub    $0x4,%esp
80106bc2:	68 00 10 00 00       	push   $0x1000
80106bc7:	6a 00                	push   $0x0
80106bc9:	50                   	push   %eax
80106bca:	e8 51 de ff ff       	call   80104a20 <memset>
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bcf:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106bd5:	83 c4 10             	add    $0x10,%esp
80106bd8:	83 c8 07             	or     $0x7,%eax
80106bdb:	89 07                	mov    %eax,(%edi)
80106bdd:	eb b3                	jmp    80106b92 <walkpgdir+0x22>
80106bdf:	90                   	nop
    }
    return &pgtab[PTX(va)];
}
80106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
    } else {
        if (!alloc)
            return 0;
80106be3:	31 c0                	xor    %eax,%eax
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
}
80106be5:	5b                   	pop    %ebx
80106be6:	5e                   	pop    %esi
80106be7:	5f                   	pop    %edi
80106be8:	5d                   	pop    %ebp
80106be9:	c3                   	ret    
80106bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bf0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106bf6:	89 d3                	mov    %edx,%ebx
80106bf8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106bfe:	83 ec 1c             	sub    $0x1c,%esp
80106c01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c08:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c13:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c16:	29 df                	sub    %ebx,%edi
80106c18:	83 c8 01             	or     $0x1,%eax
80106c1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c1e:	eb 15                	jmp    80106c35 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106c20:	f6 00 01             	testb  $0x1,(%eax)
80106c23:	75 45                	jne    80106c6a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c25:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106c28:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c2b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c2d:	74 31                	je     80106c60 <mappages+0x70>
      break;
    a += PGSIZE;
80106c2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c38:	b9 01 00 00 00       	mov    $0x1,%ecx
80106c3d:	89 da                	mov    %ebx,%edx
80106c3f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106c42:	e8 29 ff ff ff       	call   80106b70 <walkpgdir>
80106c47:	85 c0                	test   %eax,%eax
80106c49:	75 d5                	jne    80106c20 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106c4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106c53:	5b                   	pop    %ebx
80106c54:	5e                   	pop    %esi
80106c55:	5f                   	pop    %edi
80106c56:	5d                   	pop    %ebp
80106c57:	c3                   	ret    
80106c58:	90                   	nop
80106c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106c63:	31 c0                	xor    %eax,%eax
}
80106c65:	5b                   	pop    %ebx
80106c66:	5e                   	pop    %esi
80106c67:	5f                   	pop    %edi
80106c68:	5d                   	pop    %ebp
80106c69:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106c6a:	83 ec 0c             	sub    $0xc,%esp
80106c6d:	68 c8 7d 10 80       	push   $0x80107dc8
80106c72:	e8 f9 96 ff ff       	call   80100370 <panic>
80106c77:	89 f6                	mov    %esi,%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c80 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c86:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c8c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c8e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c94:	83 ec 1c             	sub    $0x1c,%esp
80106c97:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106c9a:	39 d3                	cmp    %edx,%ebx
80106c9c:	73 66                	jae    80106d04 <deallocuvm.part.0+0x84>
80106c9e:	89 d6                	mov    %edx,%esi
80106ca0:	eb 3d                	jmp    80106cdf <deallocuvm.part.0+0x5f>
80106ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ca8:	8b 10                	mov    (%eax),%edx
80106caa:	f6 c2 01             	test   $0x1,%dl
80106cad:	74 26                	je     80106cd5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106caf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106cb5:	74 58                	je     80106d0f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106cb7:	83 ec 0c             	sub    $0xc,%esp
80106cba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106cc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cc3:	52                   	push   %edx
80106cc4:	e8 e7 b9 ff ff       	call   801026b0 <kfree>
      *pte = 0;
80106cc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ccc:	83 c4 10             	add    $0x10,%esp
80106ccf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106cd5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cdb:	39 f3                	cmp    %esi,%ebx
80106cdd:	73 25                	jae    80106d04 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106cdf:	31 c9                	xor    %ecx,%ecx
80106ce1:	89 da                	mov    %ebx,%edx
80106ce3:	89 f8                	mov    %edi,%eax
80106ce5:	e8 86 fe ff ff       	call   80106b70 <walkpgdir>
    if(!pte)
80106cea:	85 c0                	test   %eax,%eax
80106cec:	75 ba                	jne    80106ca8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106cee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106cf4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106cfa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d00:	39 f3                	cmp    %esi,%ebx
80106d02:	72 db                	jb     80106cdf <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d0a:	5b                   	pop    %ebx
80106d0b:	5e                   	pop    %esi
80106d0c:	5f                   	pop    %edi
80106d0d:	5d                   	pop    %ebp
80106d0e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106d0f:	83 ec 0c             	sub    $0xc,%esp
80106d12:	68 8a 77 10 80       	push   $0x8010778a
80106d17:	e8 54 96 ff ff       	call   80100370 <panic>
80106d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d20 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106d26:	e8 65 ce ff ff       	call   80103b90 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d2b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106d31:	31 c9                	xor    %ecx,%ecx
80106d33:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106d38:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
80106d3f:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d46:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106d4b:	31 c9                	xor    %ecx,%ecx
80106d4d:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d54:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d59:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d60:	31 c9                	xor    %ecx,%ecx
80106d62:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
80106d69:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d70:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106d75:	31 c9                	xor    %ecx,%ecx
80106d77:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d7e:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106d85:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d8a:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
80106d91:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
80106d98:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d9f:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80106da6:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
80106dad:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
80106db4:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106dbb:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80106dc2:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80106dc9:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80106dd0:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106dd7:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
80106dde:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80106de5:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
80106dec:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
80106df3:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106dfa:	05 f0 27 11 80       	add    $0x801127f0,%eax
80106dff:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106e03:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e07:	c1 e8 10             	shr    $0x10,%eax
80106e0a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106e0e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e11:	0f 01 10             	lgdtl  (%eax)
}
80106e14:	c9                   	leave  
80106e15:	c3                   	ret    
80106e16:	8d 76 00             	lea    0x0(%esi),%esi
80106e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e20 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e20:	a1 a4 e8 11 80       	mov    0x8011e8a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106e25:	55                   	push   %ebp
80106e26:	89 e5                	mov    %esp,%ebp
80106e28:	05 00 00 00 80       	add    $0x80000000,%eax
80106e2d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106e30:	5d                   	pop    %ebp
80106e31:	c3                   	ret    
80106e32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e40 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
80106e49:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106e4c:	85 f6                	test   %esi,%esi
80106e4e:	0f 84 cd 00 00 00    	je     80106f21 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106e54:	8b 46 08             	mov    0x8(%esi),%eax
80106e57:	85 c0                	test   %eax,%eax
80106e59:	0f 84 dc 00 00 00    	je     80106f3b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106e5f:	8b 7e 04             	mov    0x4(%esi),%edi
80106e62:	85 ff                	test   %edi,%edi
80106e64:	0f 84 c4 00 00 00    	je     80106f2e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80106e6a:	e8 01 da ff ff       	call   80104870 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e6f:	e8 9c cc ff ff       	call   80103b10 <mycpu>
80106e74:	89 c3                	mov    %eax,%ebx
80106e76:	e8 95 cc ff ff       	call   80103b10 <mycpu>
80106e7b:	89 c7                	mov    %eax,%edi
80106e7d:	e8 8e cc ff ff       	call   80103b10 <mycpu>
80106e82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e85:	83 c7 08             	add    $0x8,%edi
80106e88:	e8 83 cc ff ff       	call   80103b10 <mycpu>
80106e8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e90:	83 c0 08             	add    $0x8,%eax
80106e93:	ba 67 00 00 00       	mov    $0x67,%edx
80106e98:	c1 e8 18             	shr    $0x18,%eax
80106e9b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106ea2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106ea9:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106eb0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106eb7:	83 c1 08             	add    $0x8,%ecx
80106eba:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106ec0:	c1 e9 10             	shr    $0x10,%ecx
80106ec3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ec9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106ece:	e8 3d cc ff ff       	call   80103b10 <mycpu>
80106ed3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106eda:	e8 31 cc ff ff       	call   80103b10 <mycpu>
80106edf:	b9 10 00 00 00       	mov    $0x10,%ecx
80106ee4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ee8:	e8 23 cc ff ff       	call   80103b10 <mycpu>
80106eed:	8b 56 08             	mov    0x8(%esi),%edx
80106ef0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106ef6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ef9:	e8 12 cc ff ff       	call   80103b10 <mycpu>
80106efe:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106f02:	b8 28 00 00 00       	mov    $0x28,%eax
80106f07:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f0a:	8b 46 04             	mov    0x4(%esi),%eax
80106f0d:	05 00 00 00 80       	add    $0x80000000,%eax
80106f12:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106f15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f18:	5b                   	pop    %ebx
80106f19:	5e                   	pop    %esi
80106f1a:	5f                   	pop    %edi
80106f1b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106f1c:	e9 3f da ff ff       	jmp    80104960 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106f21:	83 ec 0c             	sub    $0xc,%esp
80106f24:	68 ce 7d 10 80       	push   $0x80107dce
80106f29:	e8 42 94 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106f2e:	83 ec 0c             	sub    $0xc,%esp
80106f31:	68 f9 7d 10 80       	push   $0x80107df9
80106f36:	e8 35 94 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106f3b:	83 ec 0c             	sub    $0xc,%esp
80106f3e:	68 e4 7d 10 80       	push   $0x80107de4
80106f43:	e8 28 94 ff ff       	call   80100370 <panic>
80106f48:	90                   	nop
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f50 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
80106f56:	83 ec 1c             	sub    $0x1c,%esp
80106f59:	8b 75 10             	mov    0x10(%ebp),%esi
80106f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106f62:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106f68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106f6b:	77 49                	ja     80106fb6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106f6d:	e8 ee b8 ff ff       	call   80102860 <kalloc>
  memset(mem, 0, PGSIZE);
80106f72:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106f75:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f77:	68 00 10 00 00       	push   $0x1000
80106f7c:	6a 00                	push   $0x0
80106f7e:	50                   	push   %eax
80106f7f:	e8 9c da ff ff       	call   80104a20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f84:	58                   	pop    %eax
80106f85:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f8b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f90:	5a                   	pop    %edx
80106f91:	6a 06                	push   $0x6
80106f93:	50                   	push   %eax
80106f94:	31 d2                	xor    %edx,%edx
80106f96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f99:	e8 52 fc ff ff       	call   80106bf0 <mappages>
  memmove(mem, init, sz);
80106f9e:	89 75 10             	mov    %esi,0x10(%ebp)
80106fa1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106fa4:	83 c4 10             	add    $0x10,%esp
80106fa7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fad:	5b                   	pop    %ebx
80106fae:	5e                   	pop    %esi
80106faf:	5f                   	pop    %edi
80106fb0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106fb1:	e9 1a db ff ff       	jmp    80104ad0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106fb6:	83 ec 0c             	sub    $0xc,%esp
80106fb9:	68 0d 7e 10 80       	push   $0x80107e0d
80106fbe:	e8 ad 93 ff ff       	call   80100370 <panic>
80106fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fd0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	57                   	push   %edi
80106fd4:	56                   	push   %esi
80106fd5:	53                   	push   %ebx
80106fd6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106fd9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106fe0:	0f 85 91 00 00 00    	jne    80107077 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106fe6:	8b 75 18             	mov    0x18(%ebp),%esi
80106fe9:	31 db                	xor    %ebx,%ebx
80106feb:	85 f6                	test   %esi,%esi
80106fed:	75 1a                	jne    80107009 <loaduvm+0x39>
80106fef:	eb 6f                	jmp    80107060 <loaduvm+0x90>
80106ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ff8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ffe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107004:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107007:	76 57                	jbe    80107060 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107009:	8b 55 0c             	mov    0xc(%ebp),%edx
8010700c:	8b 45 08             	mov    0x8(%ebp),%eax
8010700f:	31 c9                	xor    %ecx,%ecx
80107011:	01 da                	add    %ebx,%edx
80107013:	e8 58 fb ff ff       	call   80106b70 <walkpgdir>
80107018:	85 c0                	test   %eax,%eax
8010701a:	74 4e                	je     8010706a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010701c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010701e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107021:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107026:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010702b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107031:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107034:	01 d9                	add    %ebx,%ecx
80107036:	05 00 00 00 80       	add    $0x80000000,%eax
8010703b:	57                   	push   %edi
8010703c:	51                   	push   %ecx
8010703d:	50                   	push   %eax
8010703e:	ff 75 10             	pushl  0x10(%ebp)
80107041:	e8 3a a9 ff ff       	call   80101980 <readi>
80107046:	83 c4 10             	add    $0x10,%esp
80107049:	39 c7                	cmp    %eax,%edi
8010704b:	74 ab                	je     80106ff8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010704d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107055:	5b                   	pop    %ebx
80107056:	5e                   	pop    %esi
80107057:	5f                   	pop    %edi
80107058:	5d                   	pop    %ebp
80107059:	c3                   	ret    
8010705a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107060:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107063:	31 c0                	xor    %eax,%eax
}
80107065:	5b                   	pop    %ebx
80107066:	5e                   	pop    %esi
80107067:	5f                   	pop    %edi
80107068:	5d                   	pop    %ebp
80107069:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010706a:	83 ec 0c             	sub    $0xc,%esp
8010706d:	68 27 7e 10 80       	push   $0x80107e27
80107072:	e8 f9 92 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107077:	83 ec 0c             	sub    $0xc,%esp
8010707a:	68 c8 7e 10 80       	push   $0x80107ec8
8010707f:	e8 ec 92 ff ff       	call   80100370 <panic>
80107084:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010708a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107090 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
80107096:	83 ec 0c             	sub    $0xc,%esp
80107099:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010709c:	85 ff                	test   %edi,%edi
8010709e:	0f 88 ca 00 00 00    	js     8010716e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
801070a4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801070a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
801070aa:	0f 82 82 00 00 00    	jb     80107132 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
801070b0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801070b6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801070bc:	39 df                	cmp    %ebx,%edi
801070be:	77 43                	ja     80107103 <allocuvm+0x73>
801070c0:	e9 bb 00 00 00       	jmp    80107180 <allocuvm+0xf0>
801070c5:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
801070c8:	83 ec 04             	sub    $0x4,%esp
801070cb:	68 00 10 00 00       	push   $0x1000
801070d0:	6a 00                	push   $0x0
801070d2:	50                   	push   %eax
801070d3:	e8 48 d9 ff ff       	call   80104a20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801070d8:	58                   	pop    %eax
801070d9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070df:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070e4:	5a                   	pop    %edx
801070e5:	6a 06                	push   $0x6
801070e7:	50                   	push   %eax
801070e8:	89 da                	mov    %ebx,%edx
801070ea:	8b 45 08             	mov    0x8(%ebp),%eax
801070ed:	e8 fe fa ff ff       	call   80106bf0 <mappages>
801070f2:	83 c4 10             	add    $0x10,%esp
801070f5:	85 c0                	test   %eax,%eax
801070f7:	78 47                	js     80107140 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801070f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070ff:	39 df                	cmp    %ebx,%edi
80107101:	76 7d                	jbe    80107180 <allocuvm+0xf0>
      // TODO HERE WE CREATE PYSYC MEMORY;
      // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
      // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.
    mem = kalloc();
80107103:	e8 58 b7 ff ff       	call   80102860 <kalloc>
    if(mem == 0){
80107108:	85 c0                	test   %eax,%eax
  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
      // TODO HERE WE CREATE PYSYC MEMORY;
      // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
      // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.
    mem = kalloc();
8010710a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010710c:	75 ba                	jne    801070c8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010710e:	83 ec 0c             	sub    $0xc,%esp
80107111:	68 45 7e 10 80       	push   $0x80107e45
80107116:	e8 45 95 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010711b:	83 c4 10             	add    $0x10,%esp
8010711e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107121:	76 4b                	jbe    8010716e <allocuvm+0xde>
80107123:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107126:	8b 45 08             	mov    0x8(%ebp),%eax
80107129:	89 fa                	mov    %edi,%edx
8010712b:	e8 50 fb ff ff       	call   80106c80 <deallocuvm.part.0>
      // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107130:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107132:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107135:	5b                   	pop    %ebx
80107136:	5e                   	pop    %esi
80107137:	5f                   	pop    %edi
80107138:	5d                   	pop    %ebp
80107139:	c3                   	ret    
8010713a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107140:	83 ec 0c             	sub    $0xc,%esp
80107143:	68 5d 7e 10 80       	push   $0x80107e5d
80107148:	e8 13 95 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010714d:	83 c4 10             	add    $0x10,%esp
80107150:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107153:	76 0d                	jbe    80107162 <allocuvm+0xd2>
80107155:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107158:	8b 45 08             	mov    0x8(%ebp),%eax
8010715b:	89 fa                	mov    %edi,%edx
8010715d:	e8 1e fb ff ff       	call   80106c80 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107162:	83 ec 0c             	sub    $0xc,%esp
80107165:	56                   	push   %esi
80107166:	e8 45 b5 ff ff       	call   801026b0 <kfree>
      return 0;
8010716b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010716e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107171:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107173:	5b                   	pop    %ebx
80107174:	5e                   	pop    %esi
80107175:	5f                   	pop    %edi
80107176:	5d                   	pop    %ebp
80107177:	c3                   	ret    
80107178:	90                   	nop
80107179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107180:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107183:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107185:	5b                   	pop    %ebx
80107186:	5e                   	pop    %esi
80107187:	5f                   	pop    %edi
80107188:	5d                   	pop    %ebp
80107189:	c3                   	ret    
8010718a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107190 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	8b 55 0c             	mov    0xc(%ebp),%edx
80107196:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107199:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010719c:	39 d1                	cmp    %edx,%ecx
8010719e:	73 10                	jae    801071b0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801071a0:	5d                   	pop    %ebp
801071a1:	e9 da fa ff ff       	jmp    80106c80 <deallocuvm.part.0>
801071a6:	8d 76 00             	lea    0x0(%esi),%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071b0:	89 d0                	mov    %edx,%eax
801071b2:	5d                   	pop    %ebp
801071b3:	c3                   	ret    
801071b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 0c             	sub    $0xc,%esp
801071c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801071cc:	85 f6                	test   %esi,%esi
801071ce:	74 59                	je     80107229 <freevm+0x69>
801071d0:	31 c9                	xor    %ecx,%ecx
801071d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071d7:	89 f0                	mov    %esi,%eax
801071d9:	e8 a2 fa ff ff       	call   80106c80 <deallocuvm.part.0>
801071de:	89 f3                	mov    %esi,%ebx
801071e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071e6:	eb 0f                	jmp    801071f7 <freevm+0x37>
801071e8:	90                   	nop
801071e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071f0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801071f3:	39 fb                	cmp    %edi,%ebx
801071f5:	74 23                	je     8010721a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071f7:	8b 03                	mov    (%ebx),%eax
801071f9:	a8 01                	test   $0x1,%al
801071fb:	74 f3                	je     801071f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801071fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107202:	83 ec 0c             	sub    $0xc,%esp
80107205:	83 c3 04             	add    $0x4,%ebx
80107208:	05 00 00 00 80       	add    $0x80000000,%eax
8010720d:	50                   	push   %eax
8010720e:	e8 9d b4 ff ff       	call   801026b0 <kfree>
80107213:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107216:	39 fb                	cmp    %edi,%ebx
80107218:	75 dd                	jne    801071f7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010721a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010721d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107220:	5b                   	pop    %ebx
80107221:	5e                   	pop    %esi
80107222:	5f                   	pop    %edi
80107223:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107224:	e9 87 b4 ff ff       	jmp    801026b0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107229:	83 ec 0c             	sub    $0xc,%esp
8010722c:	68 79 7e 10 80       	push   $0x80107e79
80107231:	e8 3a 91 ff ff       	call   80100370 <panic>
80107236:	8d 76 00             	lea    0x0(%esi),%esi
80107239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107240 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	56                   	push   %esi
80107244:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107245:	e8 16 b6 ff ff       	call   80102860 <kalloc>
8010724a:	85 c0                	test   %eax,%eax
8010724c:	74 6a                	je     801072b8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010724e:	83 ec 04             	sub    $0x4,%esp
80107251:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107253:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107258:	68 00 10 00 00       	push   $0x1000
8010725d:	6a 00                	push   $0x0
8010725f:	50                   	push   %eax
80107260:	e8 bb d7 ff ff       	call   80104a20 <memset>
80107265:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107268:	8b 43 04             	mov    0x4(%ebx),%eax
8010726b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010726e:	83 ec 08             	sub    $0x8,%esp
80107271:	8b 13                	mov    (%ebx),%edx
80107273:	ff 73 0c             	pushl  0xc(%ebx)
80107276:	50                   	push   %eax
80107277:	29 c1                	sub    %eax,%ecx
80107279:	89 f0                	mov    %esi,%eax
8010727b:	e8 70 f9 ff ff       	call   80106bf0 <mappages>
80107280:	83 c4 10             	add    $0x10,%esp
80107283:	85 c0                	test   %eax,%eax
80107285:	78 19                	js     801072a0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107287:	83 c3 10             	add    $0x10,%ebx
8010728a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107290:	75 d6                	jne    80107268 <setupkvm+0x28>
80107292:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107294:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107297:	5b                   	pop    %ebx
80107298:	5e                   	pop    %esi
80107299:	5d                   	pop    %ebp
8010729a:	c3                   	ret    
8010729b:	90                   	nop
8010729c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
801072a0:	83 ec 0c             	sub    $0xc,%esp
801072a3:	56                   	push   %esi
801072a4:	e8 17 ff ff ff       	call   801071c0 <freevm>
      return 0;
801072a9:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
801072ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
801072af:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
801072b1:	5b                   	pop    %ebx
801072b2:	5e                   	pop    %esi
801072b3:	5d                   	pop    %ebp
801072b4:	c3                   	ret    
801072b5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801072b8:	31 c0                	xor    %eax,%eax
801072ba:	eb d8                	jmp    80107294 <setupkvm+0x54>
801072bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072c0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801072c6:	e8 75 ff ff ff       	call   80107240 <setupkvm>
801072cb:	a3 a4 e8 11 80       	mov    %eax,0x8011e8a4
801072d0:	05 00 00 00 80       	add    $0x80000000,%eax
801072d5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801072d8:	c9                   	leave  
801072d9:	c3                   	ret    
801072da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072e1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072e3:	89 e5                	mov    %esp,%ebp
801072e5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072eb:	8b 45 08             	mov    0x8(%ebp),%eax
801072ee:	e8 7d f8 ff ff       	call   80106b70 <walkpgdir>
  if(pte == 0)
801072f3:	85 c0                	test   %eax,%eax
801072f5:	74 05                	je     801072fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801072f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072fa:	c9                   	leave  
801072fb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801072fc:	83 ec 0c             	sub    $0xc,%esp
801072ff:	68 8a 7e 10 80       	push   $0x80107e8a
80107304:	e8 67 90 ff ff       	call   80100370 <panic>
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107310 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	57                   	push   %edi
80107314:	56                   	push   %esi
80107315:	53                   	push   %ebx
80107316:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107319:	e8 22 ff ff ff       	call   80107240 <setupkvm>
8010731e:	85 c0                	test   %eax,%eax
80107320:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107323:	0f 84 b2 00 00 00    	je     801073db <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107329:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010732c:	85 c9                	test   %ecx,%ecx
8010732e:	0f 84 9c 00 00 00    	je     801073d0 <copyuvm+0xc0>
80107334:	31 f6                	xor    %esi,%esi
80107336:	eb 4a                	jmp    80107382 <copyuvm+0x72>
80107338:	90                   	nop
80107339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107340:	83 ec 04             	sub    $0x4,%esp
80107343:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107349:	68 00 10 00 00       	push   $0x1000
8010734e:	57                   	push   %edi
8010734f:	50                   	push   %eax
80107350:	e8 7b d7 ff ff       	call   80104ad0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107355:	58                   	pop    %eax
80107356:	5a                   	pop    %edx
80107357:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
8010735d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107360:	ff 75 e4             	pushl  -0x1c(%ebp)
80107363:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107368:	52                   	push   %edx
80107369:	89 f2                	mov    %esi,%edx
8010736b:	e8 80 f8 ff ff       	call   80106bf0 <mappages>
80107370:	83 c4 10             	add    $0x10,%esp
80107373:	85 c0                	test   %eax,%eax
80107375:	78 3e                	js     801073b5 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107377:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010737d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107380:	76 4e                	jbe    801073d0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107382:	8b 45 08             	mov    0x8(%ebp),%eax
80107385:	31 c9                	xor    %ecx,%ecx
80107387:	89 f2                	mov    %esi,%edx
80107389:	e8 e2 f7 ff ff       	call   80106b70 <walkpgdir>
8010738e:	85 c0                	test   %eax,%eax
80107390:	74 5a                	je     801073ec <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107392:	8b 18                	mov    (%eax),%ebx
80107394:	f6 c3 01             	test   $0x1,%bl
80107397:	74 46                	je     801073df <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107399:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010739b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801073a1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801073a4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
801073aa:	e8 b1 b4 ff ff       	call   80102860 <kalloc>
801073af:	85 c0                	test   %eax,%eax
801073b1:	89 c3                	mov    %eax,%ebx
801073b3:	75 8b                	jne    80107340 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801073b5:	83 ec 0c             	sub    $0xc,%esp
801073b8:	ff 75 e0             	pushl  -0x20(%ebp)
801073bb:	e8 00 fe ff ff       	call   801071c0 <freevm>
  return 0;
801073c0:	83 c4 10             	add    $0x10,%esp
801073c3:	31 c0                	xor    %eax,%eax
}
801073c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073c8:	5b                   	pop    %ebx
801073c9:	5e                   	pop    %esi
801073ca:	5f                   	pop    %edi
801073cb:	5d                   	pop    %ebp
801073cc:	c3                   	ret    
801073cd:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801073d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
801073d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d6:	5b                   	pop    %ebx
801073d7:	5e                   	pop    %esi
801073d8:	5f                   	pop    %edi
801073d9:	5d                   	pop    %ebp
801073da:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801073db:	31 c0                	xor    %eax,%eax
801073dd:	eb e6                	jmp    801073c5 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801073df:	83 ec 0c             	sub    $0xc,%esp
801073e2:	68 ae 7e 10 80       	push   $0x80107eae
801073e7:	e8 84 8f ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801073ec:	83 ec 0c             	sub    $0xc,%esp
801073ef:	68 94 7e 10 80       	push   $0x80107e94
801073f4:	e8 77 8f ff ff       	call   80100370 <panic>
801073f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107400 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107400:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107401:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107403:	89 e5                	mov    %esp,%ebp
80107405:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107408:	8b 55 0c             	mov    0xc(%ebp),%edx
8010740b:	8b 45 08             	mov    0x8(%ebp),%eax
8010740e:	e8 5d f7 ff ff       	call   80106b70 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107413:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107415:	89 c2                	mov    %eax,%edx
80107417:	83 e2 05             	and    $0x5,%edx
8010741a:	83 fa 05             	cmp    $0x5,%edx
8010741d:	75 11                	jne    80107430 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010741f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107424:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107425:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010742a:	c3                   	ret    
8010742b:	90                   	nop
8010742c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107430:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107432:	c9                   	leave  
80107433:	c3                   	ret    
80107434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010743a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107440 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
80107446:	83 ec 1c             	sub    $0x1c,%esp
80107449:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010744c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010744f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107452:	85 db                	test   %ebx,%ebx
80107454:	75 40                	jne    80107496 <copyout+0x56>
80107456:	eb 70                	jmp    801074c8 <copyout+0x88>
80107458:	90                   	nop
80107459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107460:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107463:	89 f1                	mov    %esi,%ecx
80107465:	29 d1                	sub    %edx,%ecx
80107467:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010746d:	39 d9                	cmp    %ebx,%ecx
8010746f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107472:	29 f2                	sub    %esi,%edx
80107474:	83 ec 04             	sub    $0x4,%esp
80107477:	01 d0                	add    %edx,%eax
80107479:	51                   	push   %ecx
8010747a:	57                   	push   %edi
8010747b:	50                   	push   %eax
8010747c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010747f:	e8 4c d6 ff ff       	call   80104ad0 <memmove>
    len -= n;
    buf += n;
80107484:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107487:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010748a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107490:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107492:	29 cb                	sub    %ecx,%ebx
80107494:	74 32                	je     801074c8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107496:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107498:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010749b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010749e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801074a4:	56                   	push   %esi
801074a5:	ff 75 08             	pushl  0x8(%ebp)
801074a8:	e8 53 ff ff ff       	call   80107400 <uva2ka>
    if(pa0 == 0)
801074ad:	83 c4 10             	add    $0x10,%esp
801074b0:	85 c0                	test   %eax,%eax
801074b2:	75 ac                	jne    80107460 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801074b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801074b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801074bc:	5b                   	pop    %ebx
801074bd:	5e                   	pop    %esi
801074be:	5f                   	pop    %edi
801074bf:	5d                   	pop    %ebp
801074c0:	c3                   	ret    
801074c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801074cb:	31 c0                	xor    %eax,%eax
}
801074cd:	5b                   	pop    %ebx
801074ce:	5e                   	pop    %esi
801074cf:	5f                   	pop    %edi
801074d0:	5d                   	pop    %ebp
801074d1:	c3                   	ret    
