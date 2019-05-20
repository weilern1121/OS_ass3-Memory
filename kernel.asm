
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
8010002d:	b8 00 32 10 80       	mov    $0x80103200,%eax
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
8010004c:	68 a0 72 10 80       	push   $0x801072a0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 15 45 00 00       	call   80104570 <initlock>

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
80100092:	68 a7 72 10 80       	push   $0x801072a7
80100097:	50                   	push   %eax
80100098:	e8 c3 43 00 00       	call   80104460 <initsleeplock>
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
801000e4:	e8 87 45 00 00       	call   80104670 <acquire>

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
80100162:	e8 29 46 00 00       	call   80104790 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 43 00 00       	call   801044a0 <acquiresleep>
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
8010017e:	e8 0d 23 00 00       	call   80102490 <iderw>
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
80100193:	68 ae 72 10 80       	push   $0x801072ae
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
801001ae:	e8 8d 43 00 00       	call   80104540 <holdingsleep>
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
801001c4:	e9 c7 22 00 00       	jmp    80102490 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 72 10 80       	push   $0x801072bf
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
801001ef:	e8 4c 43 00 00       	call   80104540 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 42 00 00       	call   80104500 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 60 44 00 00       	call   80104670 <acquire>
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
8010025c:	e9 2f 45 00 00       	jmp    80104790 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 72 10 80       	push   $0x801072c6
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
80100280:	e8 cb 14 00 00       	call   80101750 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 df 43 00 00       	call   80104670 <acquire>
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
801002bd:	e8 3e 3e 00 00       	call   80104100 <sleep>

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
801002d2:	e8 49 38 00 00       	call   80103b20 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 a5 44 00 00       	call   80104790 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 7d 13 00 00       	call   80101670 <ilock>
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
80100346:	e8 45 44 00 00       	call   80104790 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 1d 13 00 00       	call   80101670 <ilock>

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
80100389:	e8 02 27 00 00       	call   80102a90 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 cd 72 10 80       	push   $0x801072cd
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 37 7c 10 80 	movl   $0x80107c37,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 d3 41 00 00       	call   80104590 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 e1 72 10 80       	push   $0x801072e1
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
8010041a:	e8 51 5a 00 00       	call   80105e70 <uartputc>
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
801004d3:	e8 98 59 00 00       	call   80105e70 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 8c 59 00 00       	call   80105e70 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 80 59 00 00       	call   80105e70 <uartputc>
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
80100514:	e8 77 43 00 00       	call   80104890 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 b2 42 00 00       	call   801047e0 <memset>
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
80100540:	68 e5 72 10 80       	push   $0x801072e5
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
801005b1:	0f b6 92 10 73 10 80 	movzbl -0x7fef8cf0(%edx),%edx
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
8010060f:	e8 3c 11 00 00       	call   80101750 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 50 40 00 00       	call   80104670 <acquire>
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
80100647:	e8 44 41 00 00       	call   80104790 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 10 00 00       	call   80101670 <ilock>

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
8010070d:	e8 7e 40 00 00       	call   80104790 <release>
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
80100788:	b8 f8 72 10 80       	mov    $0x801072f8,%eax
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
801007c8:	e8 a3 3e 00 00       	call   80104670 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 ff 72 10 80       	push   $0x801072ff
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
80100803:	e8 68 3e 00 00       	call   80104670 <acquire>
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
80100868:	e8 23 3f 00 00       	call   80104790 <release>
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
801008f6:	e8 b5 39 00 00       	call   801042b0 <wakeup>
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
80100977:	e9 24 3a 00 00       	jmp    801043a0 <procdump>
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
801009a6:	68 08 73 10 80       	push   $0x80107308
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 bb 3b 00 00       	call   80104570 <initlock>

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
801009d9:	e8 62 1c 00 00       	call   80102640 <ioapicenable>
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
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 1f 31 00 00       	call   80103b20 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 e4 24 00 00       	call   80102ef0 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 a9 14 00 00       	call   80101ec0 <namei>
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
80100a28:	e8 43 0c 00 00       	call   80101670 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 12 0f 00 00       	call   80101950 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 b1 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a4f:	e8 0c 25 00 00       	call   80102f60 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
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
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 87 65 00 00       	call   80107000 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
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
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 83 0e 00 00       	call   80101950 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 47 63 00 00       	call   80106e50 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 51 62 00 00       	call   80106d90 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 22 64 00 00       	call   80106f80 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 91 0d 00 00       	call   80101900 <iunlockput>
  end_op();
80100b6f:	e8 ec 23 00 00       	call   80102f60 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 b6 62 00 00       	call   80106e50 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 cf 63 00 00       	call   80106f80 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 9d 23 00 00       	call   80102f60 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 21 73 10 80       	push   $0x80107321
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 aa 64 00 00       	call   801070a0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
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
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 ee 3d 00 00       	call   80104a20 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 db 3d 00 00       	call   80104a20 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 aa 65 00 00       	call   80107200 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 40 65 00 00       	call   80107200 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 db 3c 00 00       	call   801049e0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 cf 5e 00 00       	call   80106c00 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 47 62 00 00       	call   80106f80 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 2d 73 10 80       	push   $0x8010732d
80100d5b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d60:	e8 0b 38 00 00       	call   80104570 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d81:	e8 ea 38 00 00       	call   80104670 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100db1:	e8 da 39 00 00       	call   80104790 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc8:	e8 c3 39 00 00       	call   80104790 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 c0 ff 10 80       	push   $0x8010ffc0
80100def:	e8 7c 38 00 00       	call   80104670 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e0c:	e8 7f 39 00 00       	call   80104790 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 34 73 10 80       	push   $0x80107334
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 2a 38 00 00       	call   80104670 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 1f 39 00 00       	jmp    80104790 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 f3 38 00 00       	call   80104790 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 ca 27 00 00       	call   80103690 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 1b 20 00 00       	call   80102ef0 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 c0 08 00 00       	call   801017a0 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 71 20 00 00       	jmp    80102f60 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 3c 73 10 80       	push   $0x8010733c
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 56 07 00 00       	call   80101670 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 f9 09 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 20 08 00 00       	call   80101750 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 f1 06 00 00       	call   80101670 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 c4 09 00 00       	call   80101950 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 ad 07 00 00       	call   80101750 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 6e 28 00 00       	jmp    80103830 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 46 73 10 80       	push   $0x80107346
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 17 07 00 00       	call   80101750 <iunlock>
      end_op();
80101039:	e8 22 1f 00 00       	call   80102f60 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 06 00 00       	mov    $0x600,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 85 1e 00 00       	call   80102ef0 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 fa 05 00 00       	call   80101670 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 c8 09 00 00       	call   80101a50 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 b3 06 00 00       	call   80101750 <iunlock>
      end_op();
8010109d:	e8 be 1e 00 00       	call   80102f60 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 4f 26 00 00       	jmp    80103730 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 4f 73 10 80       	push   $0x8010734f
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 55 73 10 80       	push   $0x80107355
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101109:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010110f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101112:	85 c9                	test   %ecx,%ecx
80101114:	0f 84 85 00 00 00    	je     8010119f <balloc+0x9f>
8010111a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101121:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	89 f0                	mov    %esi,%eax
80101129:	c1 f8 0c             	sar    $0xc,%eax
8010112c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101132:	50                   	push   %eax
80101133:	ff 75 d8             	pushl  -0x28(%ebp)
80101136:	e8 95 ef ff ff       	call   801000d0 <bread>
8010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010113e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101143:	83 c4 10             	add    $0x10,%esp
80101146:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101149:	31 c0                	xor    %eax,%eax
8010114b:	eb 2d                	jmp    8010117a <balloc+0x7a>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101150:	89 c1                	mov    %eax,%ecx
80101152:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115f:	89 c1                	mov    %eax,%ecx
80101161:	c1 f9 03             	sar    $0x3,%ecx
80101164:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101169:	85 d7                	test   %edx,%edi
8010116b:	74 43                	je     801011b0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116d:	83 c0 01             	add    $0x1,%eax
80101170:	83 c6 01             	add    $0x1,%esi
80101173:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101178:	74 05                	je     8010117f <balloc+0x7f>
8010117a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010117d:	72 d1                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 75 e4             	pushl  -0x1c(%ebp)
80101185:	e8 56 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101197:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010119d:	77 82                	ja     80101121 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	68 5f 73 10 80       	push   $0x8010735f
801011a7:	e8 c4 f1 ff ff       	call   80100370 <panic>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b0:	09 fa                	or     %edi,%edx
801011b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011b5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011bc:	57                   	push   %edi
801011bd:	e8 0e 1f 00 00       	call   801030d0 <log_write>
        brelse(bp);
801011c2:	89 3c 24             	mov    %edi,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	56                   	push   %esi
801011cd:	ff 75 d8             	pushl  -0x28(%ebp)
801011d0:	e8 fb ee ff ff       	call   801000d0 <bread>
801011d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011da:	83 c4 0c             	add    $0xc,%esp
801011dd:	68 00 02 00 00       	push   $0x200
801011e2:	6a 00                	push   $0x0
801011e4:	50                   	push   %eax
801011e5:	e8 f6 35 00 00       	call   801047e0 <memset>
  log_write(bp);
801011ea:	89 1c 24             	mov    %ebx,(%esp)
801011ed:	e8 de 1e 00 00       	call   801030d0 <log_write>
  brelse(bp);
801011f2:	89 1c 24             	mov    %ebx,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret    
80101204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010120a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101218:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 28             	sub    $0x28,%esp
80101222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101225:	68 e0 09 11 80       	push   $0x801109e0
8010122a:	e8 41 34 00 00       	call   80104670 <acquire>
8010122f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101235:	eb 1b                	jmp    80101252 <iget+0x42>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101240:	85 f6                	test   %esi,%esi
80101242:	74 44                	je     80101288 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010124a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101250:	74 4e                	je     801012a0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101252:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101255:	85 c9                	test   %ecx,%ecx
80101257:	7e e7                	jle    80101240 <iget+0x30>
80101259:	39 3b                	cmp    %edi,(%ebx)
8010125b:	75 e3                	jne    80101240 <iget+0x30>
8010125d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101260:	75 de                	jne    80101240 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101262:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101265:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101268:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126a:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010126f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101272:	e8 19 35 00 00       	call   80104790 <release>
      return ip;
80101277:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101299:	75 b7                	jne    80101252 <iget+0x42>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 2d                	je     801012d1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 e0 09 11 80       	push   $0x801109e0
801012bf:	e8 cc 34 00 00       	call   80104790 <release>

  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 75 73 10 80       	push   $0x80107375
801012d9:	e8 92 f0 ff ff       	call   80100370 <panic>
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c6                	mov    %eax,%esi
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 76                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010130b:	83 fb 7f             	cmp    $0x7f,%ebx
8010130e:	0f 87 83 00 00 00    	ja     80101397 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101314:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	74 6a                	je     80101388 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131e:	83 ec 08             	sub    $0x8,%esp
80101321:	50                   	push   %eax
80101322:	ff 36                	pushl  (%esi)
80101324:	e8 a7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101329:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010132d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101330:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101332:	8b 1a                	mov    (%edx),%ebx
80101334:	85 db                	test   %ebx,%ebx
80101336:	75 1d                	jne    80101355 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010133d:	e8 be fd ff ff       	call   80101100 <balloc>
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101348:	89 c3                	mov    %eax,%ebx
8010134a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 7e 1d 00 00       	call   801030d0 <log_write>
80101352:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	57                   	push   %edi
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>
8010135e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101364:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 06                	mov    (%esi),%eax
80101372:	e8 89 fd ff ff       	call   80101100 <balloc>
80101377:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101388:	8b 06                	mov    (%esi),%eax
8010138a:	e8 71 fd ff ff       	call   80101100 <balloc>
8010138f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101395:	eb 87                	jmp    8010131e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101397:	83 ec 0c             	sub    $0xc,%esp
8010139a:	68 85 73 10 80       	push   $0x80107385
8010139f:	e8 cc ef ff ff       	call   80100370 <panic>
801013a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013b0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b8:	83 ec 08             	sub    $0x8,%esp
801013bb:	6a 01                	push   $0x1
801013bd:	ff 75 08             	pushl  0x8(%ebp)
801013c0:	e8 0b ed ff ff       	call   801000d0 <bread>
801013c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ca:	83 c4 0c             	add    $0xc,%esp
801013cd:	6a 1c                	push   $0x1c
801013cf:	50                   	push   %eax
801013d0:	56                   	push   %esi
801013d1:	e8 ba 34 00 00       	call   80104890 <memmove>
  brelse(bp);
801013d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e2:	e9 f9 ed ff ff       	jmp    801001e0 <brelse>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
801013f7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	68 c0 09 11 80       	push   $0x801109c0
80101401:	50                   	push   %eax
80101402:	e8 a9 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101407:	58                   	pop    %eax
80101408:	5a                   	pop    %edx
80101409:	89 da                	mov    %ebx,%edx
8010140b:	c1 ea 0c             	shr    $0xc,%edx
8010140e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101414:	52                   	push   %edx
80101415:	56                   	push   %esi
80101416:	e8 b5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101423:	ba 01 00 00 00       	mov    $0x1,%edx
80101428:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142b:	c1 fb 03             	sar    $0x3,%ebx
8010142e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101431:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101433:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101438:	85 d1                	test   %edx,%ecx
8010143a:	74 27                	je     80101463 <bfree+0x73>
8010143c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010143e:	f7 d2                	not    %edx
80101440:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101442:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101445:	21 d0                	and    %edx,%eax
80101447:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010144b:	56                   	push   %esi
8010144c:	e8 7f 1c 00 00       	call   801030d0 <log_write>
  brelse(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 87 ed ff ff       	call   801001e0 <brelse>
}
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5d                   	pop    %ebp
80101462:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101463:	83 ec 0c             	sub    $0xc,%esp
80101466:	68 98 73 10 80       	push   $0x80107398
8010146b:	e8 00 ef ff ff       	call   80100370 <panic>

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101479:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	68 ab 73 10 80       	push   $0x801073ab
80101481:	68 e0 09 11 80       	push   $0x801109e0
80101486:	e8 e5 30 00 00       	call   80104570 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 b2 73 10 80       	push   $0x801073b2
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 bc 2f 00 00       	call   80104460 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a4:	83 c4 10             	add    $0x10,%esp
801014a7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014ad:	75 e1                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	68 c0 09 11 80       	push   $0x801109c0
801014b7:	ff 75 08             	pushl  0x8(%ebp)
801014ba:	e8 f1 fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014bf:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014c5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014cb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014d1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014d7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014dd:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014e3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014e9:	68 5c 74 10 80       	push   $0x8010745c
801014ee:	e8 6d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014f3:	83 c4 30             	add    $0x30,%esp
801014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f9:	c9                   	leave  
801014fa:	c3                   	ret    
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	8b 75 08             	mov    0x8(%ebp),%esi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 91 00 00 00    	jbe    801015b0 <ialloc+0xb0>
8010151f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101524:	eb 21                	jmp    80101547 <ialloc+0x47>
80101526:	8d 76 00             	lea    0x0(%esi),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101530:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101536:	57                   	push   %edi
80101537:	e8 a4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 c4 10             	add    $0x10,%esp
8010153f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101545:	76 69                	jbe    801015b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101547:	89 d8                	mov    %ebx,%eax
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	c1 e8 03             	shr    $0x3,%eax
8010154f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101555:	50                   	push   %eax
80101556:	56                   	push   %esi
80101557:	e8 74 eb ff ff       	call   801000d0 <bread>
8010155c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010155e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101560:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101563:	83 e0 07             	and    $0x7,%eax
80101566:	c1 e0 06             	shl    $0x6,%eax
80101569:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010156d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101571:	75 bd                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101573:	83 ec 04             	sub    $0x4,%esp
80101576:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101579:	6a 40                	push   $0x40
8010157b:	6a 00                	push   $0x0
8010157d:	51                   	push   %ecx
8010157e:	e8 5d 32 00 00       	call   801047e0 <memset>
      dip->type = type;
80101583:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101587:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010158a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010158d:	89 3c 24             	mov    %edi,(%esp)
80101590:	e8 3b 1b 00 00       	call   801030d0 <log_write>
      brelse(bp);
80101595:	89 3c 24             	mov    %edi,(%esp)
80101598:	e8 43 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010159d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015a3:	89 da                	mov    %ebx,%edx
801015a5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a7:	5b                   	pop    %ebx
801015a8:	5e                   	pop    %esi
801015a9:	5f                   	pop    %edi
801015aa:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ab:	e9 60 fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015b0:	83 ec 0c             	sub    $0xc,%esp
801015b3:	68 b8 73 10 80       	push   $0x801073b8
801015b8:	e8 b3 ed ff ff       	call   80100370 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ce:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d1:	c1 e8 03             	shr    $0x3,%eax
801015d4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015da:	50                   	push   %eax
801015db:	ff 73 a4             	pushl  -0x5c(%ebx)
801015de:	e8 ed ea ff ff       	call   801000d0 <bread>
801015e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ec:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ef:	83 e0 07             	and    $0x7,%eax
801015f2:	c1 e0 06             	shl    $0x6,%eax
801015f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101600:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101603:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101607:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010160b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010160f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101613:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101617:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010161a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161d:	6a 34                	push   $0x34
8010161f:	53                   	push   %ebx
80101620:	50                   	push   %eax
80101621:	e8 6a 32 00 00       	call   80104890 <memmove>
  log_write(bp);
80101626:	89 34 24             	mov    %esi,(%esp)
80101629:	e8 a2 1a 00 00       	call   801030d0 <log_write>
  brelse(bp);
8010162e:	89 75 08             	mov    %esi,0x8(%ebp)
80101631:	83 c4 10             	add    $0x10,%esp
}
80101634:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010163a:	e9 a1 eb ff ff       	jmp    801001e0 <brelse>
8010163f:	90                   	nop

80101640 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	83 ec 10             	sub    $0x10,%esp
80101647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010164a:	68 e0 09 11 80       	push   $0x801109e0
8010164f:	e8 1c 30 00 00       	call   80104670 <acquire>
  ip->ref++;
80101654:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101658:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010165f:	e8 2c 31 00 00       	call   80104790 <release>
  return ip;
}
80101664:	89 d8                	mov    %ebx,%eax
80101666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101669:	c9                   	leave  
8010166a:	c3                   	ret    
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101678:	85 db                	test   %ebx,%ebx
8010167a:	0f 84 b7 00 00 00    	je     80101737 <ilock+0xc7>
80101680:	8b 53 08             	mov    0x8(%ebx),%edx
80101683:	85 d2                	test   %edx,%edx
80101685:	0f 8e ac 00 00 00    	jle    80101737 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010168b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010168e:	83 ec 0c             	sub    $0xc,%esp
80101691:	50                   	push   %eax
80101692:	e8 09 2e 00 00       	call   801044a0 <acquiresleep>

  if(ip->valid == 0){
80101697:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010169a:	83 c4 10             	add    $0x10,%esp
8010169d:	85 c0                	test   %eax,%eax
8010169f:	74 0f                	je     801016b0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a4:	5b                   	pop    %ebx
801016a5:	5e                   	pop    %esi
801016a6:	5d                   	pop    %ebp
801016a7:	c3                   	ret    
801016a8:	90                   	nop
801016a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b0:	8b 43 04             	mov    0x4(%ebx),%eax
801016b3:	83 ec 08             	sub    $0x8,%esp
801016b6:	c1 e8 03             	shr    $0x3,%eax
801016b9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016bf:	50                   	push   %eax
801016c0:	ff 33                	pushl  (%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
801016c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016d9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	50                   	push   %eax
80101704:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101707:	50                   	push   %eax
80101708:	e8 83 31 00 00       	call   80104890 <memmove>
    brelse(bp);
8010170d:	89 34 24             	mov    %esi,(%esp)
80101710:	e8 cb ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101715:	83 c4 10             	add    $0x10,%esp
80101718:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010171d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101724:	0f 85 77 ff ff ff    	jne    801016a1 <ilock+0x31>
      panic("ilock: no type");
8010172a:	83 ec 0c             	sub    $0xc,%esp
8010172d:	68 d0 73 10 80       	push   $0x801073d0
80101732:	e8 39 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 ca 73 10 80       	push   $0x801073ca
8010173f:	e8 2c ec ff ff       	call   80100370 <panic>
80101744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010174a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101750 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	74 28                	je     80101784 <iunlock+0x34>
8010175c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010175f:	83 ec 0c             	sub    $0xc,%esp
80101762:	56                   	push   %esi
80101763:	e8 d8 2d 00 00       	call   80104540 <holdingsleep>
80101768:	83 c4 10             	add    $0x10,%esp
8010176b:	85 c0                	test   %eax,%eax
8010176d:	74 15                	je     80101784 <iunlock+0x34>
8010176f:	8b 43 08             	mov    0x8(%ebx),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	7e 0e                	jle    80101784 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101776:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101779:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177c:	5b                   	pop    %ebx
8010177d:	5e                   	pop    %esi
8010177e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010177f:	e9 7c 2d 00 00       	jmp    80104500 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 df 73 10 80       	push   $0x801073df
8010178c:	e8 df eb ff ff       	call   80100370 <panic>
80101791:	eb 0d                	jmp    801017a0 <iput>
80101793:	90                   	nop
80101794:	90                   	nop
80101795:	90                   	nop
80101796:	90                   	nop
80101797:	90                   	nop
80101798:	90                   	nop
80101799:	90                   	nop
8010179a:	90                   	nop
8010179b:	90                   	nop
8010179c:	90                   	nop
8010179d:	90                   	nop
8010179e:	90                   	nop
8010179f:	90                   	nop

801017a0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 28             	sub    $0x28,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ac:	8d 7e 0c             	lea    0xc(%esi),%edi
801017af:	57                   	push   %edi
801017b0:	e8 eb 2c 00 00       	call   801044a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017b5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 d2                	test   %edx,%edx
801017bd:	74 07                	je     801017c6 <iput+0x26>
801017bf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017c4:	74 32                	je     801017f8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017c6:	83 ec 0c             	sub    $0xc,%esp
801017c9:	57                   	push   %edi
801017ca:	e8 31 2d 00 00       	call   80104500 <releasesleep>

  acquire(&icache.lock);
801017cf:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017d6:	e8 95 2e 00 00       	call   80104670 <acquire>
  ip->ref--;
801017db:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ec:	5b                   	pop    %ebx
801017ed:	5e                   	pop    %esi
801017ee:	5f                   	pop    %edi
801017ef:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017f0:	e9 9b 2f 00 00       	jmp    80104790 <release>
801017f5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 e0 09 11 80       	push   $0x801109e0
80101800:	e8 6b 2e 00 00       	call   80104670 <acquire>
    int r = ip->ref;
80101805:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101808:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010180f:	e8 7c 2f 00 00       	call   80104790 <release>
    if(r == 1){
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	83 fb 01             	cmp    $0x1,%ebx
8010181a:	75 aa                	jne    801017c6 <iput+0x26>
8010181c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101822:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101825:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101828:	89 cf                	mov    %ecx,%edi
8010182a:	eb 0b                	jmp    80101837 <iput+0x97>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101830:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101833:	39 fb                	cmp    %edi,%ebx
80101835:	74 19                	je     80101850 <iput+0xb0>
    if(ip->addrs[i]){
80101837:	8b 13                	mov    (%ebx),%edx
80101839:	85 d2                	test   %edx,%edx
8010183b:	74 f3                	je     80101830 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010183d:	8b 06                	mov    (%esi),%eax
8010183f:	e8 ac fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101844:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010184a:	eb e4                	jmp    80101830 <iput+0x90>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101850:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101856:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101859:	85 c0                	test   %eax,%eax
8010185b:	75 33                	jne    80101890 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010185d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101860:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101867:	56                   	push   %esi
80101868:	e8 53 fd ff ff       	call   801015c0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010186d:	31 c0                	xor    %eax,%eax
8010186f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101873:	89 34 24             	mov    %esi,(%esp)
80101876:	e8 45 fd ff ff       	call   801015c0 <iupdate>
      ip->valid = 0;
8010187b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101882:	83 c4 10             	add    $0x10,%esp
80101885:	e9 3c ff ff ff       	jmp    801017c6 <iput+0x26>
8010188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	83 ec 08             	sub    $0x8,%esp
80101893:	50                   	push   %eax
80101894:	ff 36                	pushl  (%esi)
80101896:	e8 35 e8 ff ff       	call   801000d0 <bread>
8010189b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018a1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018a7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	89 cf                	mov    %ecx,%edi
801018af:	eb 0e                	jmp    801018bf <iput+0x11f>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018bb:	39 fb                	cmp    %edi,%ebx
801018bd:	74 0f                	je     801018ce <iput+0x12e>
      if(a[j])
801018bf:	8b 13                	mov    (%ebx),%edx
801018c1:	85 d2                	test   %edx,%edx
801018c3:	74 f3                	je     801018b8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018c5:	8b 06                	mov    (%esi),%eax
801018c7:	e8 24 fb ff ff       	call   801013f0 <bfree>
801018cc:	eb ea                	jmp    801018b8 <iput+0x118>
    }
    brelse(bp);
801018ce:	83 ec 0c             	sub    $0xc,%esp
801018d1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018d7:	e8 04 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018dc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e2:	8b 06                	mov    (%esi),%eax
801018e4:	e8 07 fb ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018e9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f0:	00 00 00 
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	e9 62 ff ff ff       	jmp    8010185d <iput+0xbd>
801018fb:	90                   	nop
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 10             	sub    $0x10,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	53                   	push   %ebx
8010190b:	e8 40 fe ff ff       	call   80101750 <iunlock>
  iput(ip);
80101910:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101913:	83 c4 10             	add    $0x10,%esp
}
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010191a:	e9 81 fe ff ff       	jmp    801017a0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 1c             	sub    $0x1c,%esp
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101962:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101967:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010196a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010196d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101970:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101973:	0f 84 a7 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101979:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010197c:	8b 40 58             	mov    0x58(%eax),%eax
8010197f:	39 f0                	cmp    %esi,%eax
80101981:	0f 82 c1 00 00 00    	jb     80101a48 <readi+0xf8>
80101987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010198a:	89 fa                	mov    %edi,%edx
8010198c:	01 f2                	add    %esi,%edx
8010198e:	0f 82 b4 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101994:	89 c1                	mov    %eax,%ecx
80101996:	29 f1                	sub    %esi,%ecx
80101998:	39 d0                	cmp    %edx,%eax
8010199a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199d:	31 ff                	xor    %edi,%edi
8010199f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a4:	74 6d                	je     80101a13 <readi+0xc3>
801019a6:	8d 76 00             	lea    0x0(%esi),%esi
801019a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019b3:	89 f2                	mov    %esi,%edx
801019b5:	c1 ea 09             	shr    $0x9,%edx
801019b8:	89 d8                	mov    %ebx,%eax
801019ba:	e8 21 f9 ff ff       	call   801012e0 <bmap>
801019bf:	83 ec 08             	sub    $0x8,%esp
801019c2:	50                   	push   %eax
801019c3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019c5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ca:	e8 01 e7 ff ff       	call   801000d0 <bread>
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019d4:	89 f1                	mov    %esi,%ecx
801019d6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019dc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019e2:	29 cb                	sub    %ecx,%ebx
801019e4:	29 f8                	sub    %edi,%eax
801019e6:	39 c3                	cmp    %eax,%ebx
801019e8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019eb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019ef:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f0:	01 df                	add    %ebx,%edi
801019f2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019f4:	50                   	push   %eax
801019f5:	ff 75 e0             	pushl  -0x20(%ebp)
801019f8:	e8 93 2e 00 00       	call   80104890 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	83 c4 10             	add    $0x10,%esp
80101a0e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a11:	77 9d                	ja     801019b0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a19:	5b                   	pop    %ebx
80101a1a:	5e                   	pop    %esi
80101a1b:	5f                   	pop    %edi
80101a1c:	5d                   	pop    %ebp
80101a1d:	c3                   	ret    
80101a1e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a35:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3b:	5b                   	pop    %ebx
80101a3c:	5e                   	pop    %esi
80101a3d:	5f                   	pop    %edi
80101a3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a3f:	ff e0                	jmp    *%eax
80101a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c7                	jmp    80101a16 <readi+0xc6>
80101a4f:	90                   	nop

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 1c             	sub    $0x1c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a70:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 eb 00 00 00    	jb     80101b70 <writei+0x120>
80101a85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a88:	89 f8                	mov    %edi,%eax
80101a8a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a8c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a91:	0f 87 d9 00 00 00    	ja     80101b70 <writei+0x120>
80101a97:	39 c6                	cmp    %eax,%esi
80101a99:	0f 87 d1 00 00 00    	ja     80101b70 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9f:	85 ff                	test   %edi,%edi
80101aa1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa8:	74 78                	je     80101b22 <writei+0xd2>
80101aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ab3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aba:	c1 ea 09             	shr    $0x9,%edx
80101abd:	89 f8                	mov    %edi,%eax
80101abf:	e8 1c f8 ff ff       	call   801012e0 <bmap>
80101ac4:	83 ec 08             	sub    $0x8,%esp
80101ac7:	50                   	push   %eax
80101ac8:	ff 37                	pushl  (%edi)
80101aca:	e8 01 e6 ff ff       	call   801000d0 <bread>
80101acf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ad4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ad7:	89 f1                	mov    %esi,%ecx
80101ad9:	83 c4 0c             	add    $0xc,%esp
80101adc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ae2:	29 cb                	sub    %ecx,%ebx
80101ae4:	39 c3                	cmp    %eax,%ebx
80101ae6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101aed:	53                   	push   %ebx
80101aee:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	50                   	push   %eax
80101af4:	e8 97 2d 00 00       	call   80104890 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 cf 15 00 00       	call   801030d0 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b0f:	83 c4 10             	add    $0x10,%esp
80101b12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b15:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b18:	77 96                	ja     80101ab0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b20:	77 36                	ja     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 36                	ja     80101b70 <writei+0x120>
80101b3a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 2b                	je     80101b70 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b5b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b61:	50                   	push   %eax
80101b62:	e8 59 fa ff ff       	call   801015c0 <iupdate>
80101b67:	83 c4 10             	add    $0x10,%esp
80101b6a:	eb b6                	jmp    80101b22 <writei+0xd2>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b75:	eb ae                	jmp    80101b25 <writei+0xd5>
80101b77:	89 f6                	mov    %esi,%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	6a 0e                	push   $0xe
80101b88:	ff 75 0c             	pushl  0xc(%ebp)
80101b8b:	ff 75 08             	pushl  0x8(%ebp)
80101b8e:	e8 7d 2d 00 00       	call   80104910 <strncmp>
}
80101b93:	c9                   	leave  
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 80 00 00 00    	jne    80101c37 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 5b                	jmp    80101c20 <dirlookup+0x80>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 50                	jbe    80101c20 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	6a 10                	push   $0x10
80101bd2:	57                   	push   %edi
80101bd3:	56                   	push   %esi
80101bd4:	53                   	push   %ebx
80101bd5:	e8 76 fd ff ff       	call   80101950 <readi>
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	83 f8 10             	cmp    $0x10,%eax
80101be0:	75 48                	jne    80101c2a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101be2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101be7:	74 df                	je     80101bc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101be9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bec:	83 ec 04             	sub    $0x4,%esp
80101bef:	6a 0e                	push   $0xe
80101bf1:	50                   	push   %eax
80101bf2:	ff 75 0c             	pushl  0xc(%ebp)
80101bf5:	e8 16 2d 00 00       	call   80104910 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	85 c0                	test   %eax,%eax
80101bff:	75 c7                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c01:	8b 45 10             	mov    0x10(%ebp),%eax
80101c04:	85 c0                	test   %eax,%eax
80101c06:	74 05                	je     80101c0d <dirlookup+0x6d>
        *poff = off;
80101c08:	8b 45 10             	mov    0x10(%ebp),%eax
80101c0b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c0d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c11:	8b 03                	mov    (%ebx),%eax
80101c13:	e8 f8 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
80101c1f:	c3                   	ret    
80101c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c23:	31 c0                	xor    %eax,%eax
}
80101c25:	5b                   	pop    %ebx
80101c26:	5e                   	pop    %esi
80101c27:	5f                   	pop    %edi
80101c28:	5d                   	pop    %ebp
80101c29:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c2a:	83 ec 0c             	sub    $0xc,%esp
80101c2d:	68 f9 73 10 80       	push   $0x801073f9
80101c32:	e8 39 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	68 e7 73 10 80       	push   $0x801073e7
80101c3f:	e8 2c e7 ff ff       	call   80100370 <panic>
80101c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	89 cf                	mov    %ecx,%edi
80101c58:	89 c3                	mov    %eax,%ebx
80101c5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c5d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c63:	0f 84 53 01 00 00    	je     80101dbc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c69:	e8 b2 1e 00 00       	call   80103b20 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c6e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c71:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c74:	68 e0 09 11 80       	push   $0x801109e0
80101c79:	e8 f2 29 00 00       	call   80104670 <acquire>
  ip->ref++;
80101c7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c82:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c89:	e8 02 2b 00 00       	call   80104790 <release>
80101c8e:	83 c4 10             	add    $0x10,%esp
80101c91:	eb 08                	jmp    80101c9b <namex+0x4b>
80101c93:	90                   	nop
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c98:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c9b:	0f b6 03             	movzbl (%ebx),%eax
80101c9e:	3c 2f                	cmp    $0x2f,%al
80101ca0:	74 f6                	je     80101c98 <namex+0x48>
    path++;
  if(*path == 0)
80101ca2:	84 c0                	test   %al,%al
80101ca4:	0f 84 e3 00 00 00    	je     80101d8d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101caa:	0f b6 03             	movzbl (%ebx),%eax
80101cad:	89 da                	mov    %ebx,%edx
80101caf:	84 c0                	test   %al,%al
80101cb1:	0f 84 ac 00 00 00    	je     80101d63 <namex+0x113>
80101cb7:	3c 2f                	cmp    $0x2f,%al
80101cb9:	75 09                	jne    80101cc4 <namex+0x74>
80101cbb:	e9 a3 00 00 00       	jmp    80101d63 <namex+0x113>
80101cc0:	84 c0                	test   %al,%al
80101cc2:	74 0a                	je     80101cce <namex+0x7e>
    path++;
80101cc4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cc7:	0f b6 02             	movzbl (%edx),%eax
80101cca:	3c 2f                	cmp    $0x2f,%al
80101ccc:	75 f2                	jne    80101cc0 <namex+0x70>
80101cce:	89 d1                	mov    %edx,%ecx
80101cd0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cd2:	83 f9 0d             	cmp    $0xd,%ecx
80101cd5:	0f 8e 8d 00 00 00    	jle    80101d68 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cdb:	83 ec 04             	sub    $0x4,%esp
80101cde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ce1:	6a 0e                	push   $0xe
80101ce3:	53                   	push   %ebx
80101ce4:	57                   	push   %edi
80101ce5:	e8 a6 2b 00 00       	call   80104890 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101ced:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cf0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cf5:	75 11                	jne    80101d08 <namex+0xb8>
80101cf7:	89 f6                	mov    %esi,%esi
80101cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d00:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d06:	74 f8                	je     80101d00 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
80101d0b:	56                   	push   %esi
80101d0c:	e8 5f f9 ff ff       	call   80101670 <ilock>
    if(ip->type != T_DIR){
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d19:	0f 85 7f 00 00 00    	jne    80101d9e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d22:	85 d2                	test   %edx,%edx
80101d24:	74 09                	je     80101d2f <namex+0xdf>
80101d26:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d29:	0f 84 a3 00 00 00    	je     80101dd2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d2f:	83 ec 04             	sub    $0x4,%esp
80101d32:	6a 00                	push   $0x0
80101d34:	57                   	push   %edi
80101d35:	56                   	push   %esi
80101d36:	e8 65 fe ff ff       	call   80101ba0 <dirlookup>
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	85 c0                	test   %eax,%eax
80101d40:	74 5c                	je     80101d9e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d42:	83 ec 0c             	sub    $0xc,%esp
80101d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d48:	56                   	push   %esi
80101d49:	e8 02 fa ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d4e:	89 34 24             	mov    %esi,(%esp)
80101d51:	e8 4a fa ff ff       	call   801017a0 <iput>
80101d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d59:	83 c4 10             	add    $0x10,%esp
80101d5c:	89 c6                	mov    %eax,%esi
80101d5e:	e9 38 ff ff ff       	jmp    80101c9b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d63:	31 c9                	xor    %ecx,%ecx
80101d65:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d68:	83 ec 04             	sub    $0x4,%esp
80101d6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d71:	51                   	push   %ecx
80101d72:	53                   	push   %ebx
80101d73:	57                   	push   %edi
80101d74:	e8 17 2b 00 00       	call   80104890 <memmove>
    name[len] = 0;
80101d79:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d7f:	83 c4 10             	add    $0x10,%esp
80101d82:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d86:	89 d3                	mov    %edx,%ebx
80101d88:	e9 65 ff ff ff       	jmp    80101cf2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d90:	85 c0                	test   %eax,%eax
80101d92:	75 54                	jne    80101de8 <namex+0x198>
80101d94:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d99:	5b                   	pop    %ebx
80101d9a:	5e                   	pop    %esi
80101d9b:	5f                   	pop    %edi
80101d9c:	5d                   	pop    %ebp
80101d9d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d9e:	83 ec 0c             	sub    $0xc,%esp
80101da1:	56                   	push   %esi
80101da2:	e8 a9 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101da7:	89 34 24             	mov    %esi,(%esp)
80101daa:	e8 f1 f9 ff ff       	call   801017a0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101daf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101db5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db7:	5b                   	pop    %ebx
80101db8:	5e                   	pop    %esi
80101db9:	5f                   	pop    %edi
80101dba:	5d                   	pop    %ebp
80101dbb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dbc:	ba 01 00 00 00       	mov    $0x1,%edx
80101dc1:	b8 01 00 00 00       	mov    $0x1,%eax
80101dc6:	e8 45 f4 ff ff       	call   80101210 <iget>
80101dcb:	89 c6                	mov    %eax,%esi
80101dcd:	e9 c9 fe ff ff       	jmp    80101c9b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dd2:	83 ec 0c             	sub    $0xc,%esp
80101dd5:	56                   	push   %esi
80101dd6:	e8 75 f9 ff ff       	call   80101750 <iunlock>
      return ip;
80101ddb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101de1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de3:	5b                   	pop    %ebx
80101de4:	5e                   	pop    %esi
80101de5:	5f                   	pop    %edi
80101de6:	5d                   	pop    %ebp
80101de7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	56                   	push   %esi
80101dec:	e8 af f9 ff ff       	call   801017a0 <iput>
    return 0;
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	31 c0                	xor    %eax,%eax
80101df6:	eb 9e                	jmp    80101d96 <namex+0x146>
80101df8:	90                   	nop
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 20             	sub    $0x20,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	6a 00                	push   $0x0
80101e0e:	ff 75 0c             	pushl  0xc(%ebp)
80101e11:	53                   	push   %ebx
80101e12:	e8 89 fd ff ff       	call   80101ba0 <dirlookup>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	85 c0                	test   %eax,%eax
80101e1c:	75 67                	jne    80101e85 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e24:	85 ff                	test   %edi,%edi
80101e26:	74 29                	je     80101e51 <dirlink+0x51>
80101e28:	31 ff                	xor    %edi,%edi
80101e2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2d:	eb 09                	jmp    80101e38 <dirlink+0x38>
80101e2f:	90                   	nop
80101e30:	83 c7 10             	add    $0x10,%edi
80101e33:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e36:	76 19                	jbe    80101e51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 0e fb ff ff       	call   80101950 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 4e                	jne    80101e98 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	75 df                	jne    80101e30 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e54:	83 ec 04             	sub    $0x4,%esp
80101e57:	6a 0e                	push   $0xe
80101e59:	ff 75 0c             	pushl  0xc(%ebp)
80101e5c:	50                   	push   %eax
80101e5d:	e8 1e 2b 00 00       	call   80104980 <strncpy>
  de.inum = inum;
80101e62:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e65:	6a 10                	push   $0x10
80101e67:	57                   	push   %edi
80101e68:	56                   	push   %esi
80101e69:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6e:	e8 dd fb ff ff       	call   80101a50 <writei>
80101e73:	83 c4 20             	add    $0x20,%esp
80101e76:	83 f8 10             	cmp    $0x10,%eax
80101e79:	75 2a                	jne    80101ea5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e7b:	31 c0                	xor    %eax,%eax
}
80101e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e80:	5b                   	pop    %ebx
80101e81:	5e                   	pop    %esi
80101e82:	5f                   	pop    %edi
80101e83:	5d                   	pop    %ebp
80101e84:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	50                   	push   %eax
80101e89:	e8 12 f9 ff ff       	call   801017a0 <iput>
    return -1;
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e96:	eb e5                	jmp    80101e7d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e98:	83 ec 0c             	sub    $0xc,%esp
80101e9b:	68 08 74 10 80       	push   $0x80107408
80101ea0:	e8 cb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 51 7a 10 80       	push   $0x80107a51
80101ead:	e8 be e4 ff ff       	call   80100370 <panic>
80101eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ec0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ece:	e8 7d fd ff ff       	call   80101c50 <namex>
}
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ee0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ee1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ee6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eee:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101eef:	e9 5c fd ff ff       	jmp    80101c50 <namex>
80101ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f00 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f00:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f01:	b8 38 39 00 00       	mov    $0x3938,%eax


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f06:	89 e5                	mov    %esp,%ebp
80101f08:	57                   	push   %edi
80101f09:	56                   	push   %esi
80101f0a:	53                   	push   %ebx
80101f0b:	83 ec 10             	sub    $0x10,%esp
80101f0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f11:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f18:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f1f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101f23:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101f27:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101f2a:	85 c9                	test   %ecx,%ecx
80101f2c:	78 62                	js     80101f90 <itoa+0x90>
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
80101f2e:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f30:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f35:	8d 76 00             	lea    0x0(%esi),%esi
80101f38:	89 d8                	mov    %ebx,%eax
80101f3a:	c1 fb 1f             	sar    $0x1f,%ebx
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
    do{ //Move to where representation ends
        ++p;
80101f3d:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101f40:	f7 ef                	imul   %edi
80101f42:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101f45:	29 da                	sub    %ebx,%edx
80101f47:	89 d3                	mov    %edx,%ebx
80101f49:	75 ed                	jne    80101f38 <itoa+0x38>
    *p = '\0';
80101f4b:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f4e:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101f53:	90                   	nop
80101f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f58:	89 c8                	mov    %ecx,%eax
80101f5a:	83 ee 01             	sub    $0x1,%esi
80101f5d:	f7 eb                	imul   %ebx
80101f5f:	89 c8                	mov    %ecx,%eax
80101f61:	c1 f8 1f             	sar    $0x1f,%eax
80101f64:	c1 fa 02             	sar    $0x2,%edx
80101f67:	29 c2                	sub    %eax,%edx
80101f69:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101f6c:	01 c0                	add    %eax,%eax
80101f6e:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101f70:	85 d2                	test   %edx,%edx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f72:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101f77:	89 d1                	mov    %edx,%ecx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f79:	88 06                	mov    %al,(%esi)
        i = i/10;
    }while(i);
80101f7b:	75 db                	jne    80101f58 <itoa+0x58>
    return b;
}
80101f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f80:	83 c4 10             	add    $0x10,%esp
80101f83:	5b                   	pop    %ebx
80101f84:	5e                   	pop    %esi
80101f85:	5f                   	pop    %edi
80101f86:	5d                   	pop    %ebp
80101f87:	c3                   	ret    
80101f88:	90                   	nop
80101f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80101f90:	89 f0                	mov    %esi,%eax
        i *= -1;
80101f92:	f7 d9                	neg    %ecx

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80101f94:	8d 76 01             	lea    0x1(%esi),%esi
80101f97:	c6 00 2d             	movb   $0x2d,(%eax)
80101f9a:	eb 92                	jmp    80101f2e <itoa+0x2e>
80101f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fa0 <removeSwapFile>:
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	57                   	push   %edi
80101fa4:	56                   	push   %esi
80101fa5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101fa6:	8d 75 bc             	lea    -0x44(%ebp),%esi
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fa9:	83 ec 40             	sub    $0x40,%esp
80101fac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101faf:	6a 06                	push   $0x6
80101fb1:	68 15 74 10 80       	push   $0x80107415
80101fb6:	56                   	push   %esi
80101fb7:	e8 d4 28 00 00       	call   80104890 <memmove>
  itoa(p->pid, path+ 6);
80101fbc:	58                   	pop    %eax
80101fbd:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80101fc0:	5a                   	pop    %edx
80101fc1:	50                   	push   %eax
80101fc2:	ff 73 10             	pushl  0x10(%ebx)
80101fc5:	e8 36 ff ff ff       	call   80101f00 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
80101fca:	8b 43 7c             	mov    0x7c(%ebx),%eax
80101fcd:	83 c4 10             	add    $0x10,%esp
80101fd0:	85 c0                	test   %eax,%eax
80101fd2:	0f 84 88 01 00 00    	je     80102160 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80101fd8:	83 ec 0c             	sub    $0xc,%esp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101fdb:	8d 5d ca             	lea    -0x36(%ebp),%ebx

  if(0 == p->swapFile)
  {
    return -1;
  }
  fileclose(p->swapFile);
80101fde:	50                   	push   %eax
80101fdf:	e8 4c ee ff ff       	call   80100e30 <fileclose>

  begin_op();
80101fe4:	e8 07 0f 00 00       	call   80102ef0 <begin_op>
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101fe9:	89 f0                	mov    %esi,%eax
80101feb:	89 d9                	mov    %ebx,%ecx
80101fed:	ba 01 00 00 00       	mov    $0x1,%edx
80101ff2:	e8 59 fc ff ff       	call   80101c50 <namex>
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101ffc:	89 c6                	mov    %eax,%esi
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
80101ffe:	0f 84 66 01 00 00    	je     8010216a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102004:	83 ec 0c             	sub    $0xc,%esp
80102007:	50                   	push   %eax
80102008:	e8 63 f6 ff ff       	call   80101670 <ilock>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
8010200d:	83 c4 0c             	add    $0xc,%esp
80102010:	6a 0e                	push   $0xe
80102012:	68 1d 74 10 80       	push   $0x8010741d
80102017:	53                   	push   %ebx
80102018:	e8 f3 28 00 00       	call   80104910 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010201d:	83 c4 10             	add    $0x10,%esp
80102020:	85 c0                	test   %eax,%eax
80102022:	0f 84 f0 00 00 00    	je     80102118 <removeSwapFile+0x178>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80102028:	83 ec 04             	sub    $0x4,%esp
8010202b:	6a 0e                	push   $0xe
8010202d:	68 1c 74 10 80       	push   $0x8010741c
80102032:	53                   	push   %ebx
80102033:	e8 d8 28 00 00       	call   80104910 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102038:	83 c4 10             	add    $0x10,%esp
8010203b:	85 c0                	test   %eax,%eax
8010203d:	0f 84 d5 00 00 00    	je     80102118 <removeSwapFile+0x178>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102043:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102046:	83 ec 04             	sub    $0x4,%esp
80102049:	50                   	push   %eax
8010204a:	53                   	push   %ebx
8010204b:	56                   	push   %esi
8010204c:	e8 4f fb ff ff       	call   80101ba0 <dirlookup>
80102051:	83 c4 10             	add    $0x10,%esp
80102054:	85 c0                	test   %eax,%eax
80102056:	89 c3                	mov    %eax,%ebx
80102058:	0f 84 ba 00 00 00    	je     80102118 <removeSwapFile+0x178>
    goto bad;
  ilock(ip);
8010205e:	83 ec 0c             	sub    $0xc,%esp
80102061:	50                   	push   %eax
80102062:	e8 09 f6 ff ff       	call   80101670 <ilock>

  if(ip->nlink < 1)
80102067:	83 c4 10             	add    $0x10,%esp
8010206a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010206f:	0f 8e 11 01 00 00    	jle    80102186 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102075:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010207a:	74 74                	je     801020f0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010207c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010207f:	83 ec 04             	sub    $0x4,%esp
80102082:	6a 10                	push   $0x10
80102084:	6a 00                	push   $0x0
80102086:	57                   	push   %edi
80102087:	e8 54 27 00 00       	call   801047e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010208c:	6a 10                	push   $0x10
8010208e:	ff 75 b8             	pushl  -0x48(%ebp)
80102091:	57                   	push   %edi
80102092:	56                   	push   %esi
80102093:	e8 b8 f9 ff ff       	call   80101a50 <writei>
80102098:	83 c4 20             	add    $0x20,%esp
8010209b:	83 f8 10             	cmp    $0x10,%eax
8010209e:	0f 85 d5 00 00 00    	jne    80102179 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020a4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020a9:	0f 84 91 00 00 00    	je     80102140 <removeSwapFile+0x1a0>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801020af:	83 ec 0c             	sub    $0xc,%esp
801020b2:	56                   	push   %esi
801020b3:	e8 98 f6 ff ff       	call   80101750 <iunlock>
  iput(ip);
801020b8:	89 34 24             	mov    %esi,(%esp)
801020bb:	e8 e0 f6 ff ff       	call   801017a0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801020c0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801020c5:	89 1c 24             	mov    %ebx,(%esp)
801020c8:	e8 f3 f4 ff ff       	call   801015c0 <iupdate>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801020cd:	89 1c 24             	mov    %ebx,(%esp)
801020d0:	e8 7b f6 ff ff       	call   80101750 <iunlock>
  iput(ip);
801020d5:	89 1c 24             	mov    %ebx,(%esp)
801020d8:	e8 c3 f6 ff ff       	call   801017a0 <iput>

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();
801020dd:	e8 7e 0e 00 00       	call   80102f60 <end_op>

  return 0;
801020e2:	83 c4 10             	add    $0x10,%esp
801020e5:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801020e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020ea:	5b                   	pop    %ebx
801020eb:	5e                   	pop    %esi
801020ec:	5f                   	pop    %edi
801020ed:	5d                   	pop    %ebp
801020ee:	c3                   	ret    
801020ef:	90                   	nop
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801020f0:	83 ec 0c             	sub    $0xc,%esp
801020f3:	53                   	push   %ebx
801020f4:	e8 f7 2e 00 00       	call   80104ff0 <isdirempty>
801020f9:	83 c4 10             	add    $0x10,%esp
801020fc:	85 c0                	test   %eax,%eax
801020fe:	0f 85 78 ff ff ff    	jne    8010207c <removeSwapFile+0xdc>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102104:	83 ec 0c             	sub    $0xc,%esp
80102107:	53                   	push   %ebx
80102108:	e8 43 f6 ff ff       	call   80101750 <iunlock>
  iput(ip);
8010210d:	89 1c 24             	mov    %ebx,(%esp)
80102110:	e8 8b f6 ff ff       	call   801017a0 <iput>
80102115:	83 c4 10             	add    $0x10,%esp

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102118:	83 ec 0c             	sub    $0xc,%esp
8010211b:	56                   	push   %esi
8010211c:	e8 2f f6 ff ff       	call   80101750 <iunlock>
  iput(ip);
80102121:	89 34 24             	mov    %esi,(%esp)
80102124:	e8 77 f6 ff ff       	call   801017a0 <iput>

  return 0;

  bad:
    iunlockput(dp);
    end_op();
80102129:	e8 32 0e 00 00       	call   80102f60 <end_op>
    return -1;
8010212e:	83 c4 10             	add    $0x10,%esp

}
80102131:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

  bad:
    iunlockput(dp);
    end_op();
    return -1;
80102134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
80102139:	5b                   	pop    %ebx
8010213a:	5e                   	pop    %esi
8010213b:	5f                   	pop    %edi
8010213c:	5d                   	pop    %ebp
8010213d:	c3                   	ret    
8010213e:	66 90                	xchg   %ax,%ax

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80102140:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	56                   	push   %esi
80102149:	e8 72 f4 ff ff       	call   801015c0 <iupdate>
8010214e:	83 c4 10             	add    $0x10,%esp
80102151:	e9 59 ff ff ff       	jmp    801020af <removeSwapFile+0x10f>
80102156:	8d 76 00             	lea    0x0(%esi),%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
  {
    return -1;
80102160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102165:	e9 7d ff ff ff       	jmp    801020e7 <removeSwapFile+0x147>
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
  {
    end_op();
8010216a:	e8 f1 0d 00 00       	call   80102f60 <end_op>
    return -1;
8010216f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102174:	e9 6e ff ff ff       	jmp    801020e7 <removeSwapFile+0x147>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80102179:	83 ec 0c             	sub    $0xc,%esp
8010217c:	68 31 74 10 80       	push   $0x80107431
80102181:	e8 ea e1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80102186:	83 ec 0c             	sub    $0xc,%esp
80102189:	68 1f 74 10 80       	push   $0x8010741f
8010218e:	e8 dd e1 ff ff       	call   80100370 <panic>
80102193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021a0 <createSwapFile>:
}


//return 0 on success
int
createSwapFile(struct proc* p) {
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	56                   	push   %esi
801021a4:	53                   	push   %ebx

    char path[DIGITS];
    memmove(path, "/.swap", 6);
801021a5:	8d 75 ea             	lea    -0x16(%ebp),%esi
}


//return 0 on success
int
createSwapFile(struct proc* p) {
801021a8:	83 ec 14             	sub    $0x14,%esp
801021ab:	8b 5d 08             	mov    0x8(%ebp),%ebx

    char path[DIGITS];
    memmove(path, "/.swap", 6);
801021ae:	6a 06                	push   $0x6
801021b0:	68 15 74 10 80       	push   $0x80107415
801021b5:	56                   	push   %esi
801021b6:	e8 d5 26 00 00       	call   80104890 <memmove>
    itoa(p->pid, path + 6);
801021bb:	58                   	pop    %eax
801021bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801021bf:	5a                   	pop    %edx
801021c0:	50                   	push   %eax
801021c1:	ff 73 10             	pushl  0x10(%ebx)
801021c4:	e8 37 fd ff ff       	call   80101f00 <itoa>

    begin_op();
801021c9:	e8 22 0d 00 00       	call   80102ef0 <begin_op>
    struct inode *in = create(path, T_FILE, 0, 0);
801021ce:	6a 00                	push   $0x0
801021d0:	6a 00                	push   $0x0
801021d2:	6a 02                	push   $0x2
801021d4:	56                   	push   %esi
801021d5:	e8 26 30 00 00       	call   80105200 <create>
    iunlock(in);
801021da:	83 c4 14             	add    $0x14,%esp
    char path[DIGITS];
    memmove(path, "/.swap", 6);
    itoa(p->pid, path + 6);

    begin_op();
    struct inode *in = create(path, T_FILE, 0, 0);
801021dd:	89 c6                	mov    %eax,%esi
    iunlock(in);
801021df:	50                   	push   %eax
801021e0:	e8 6b f5 ff ff       	call   80101750 <iunlock>

    p->swapFile = filealloc();
801021e5:	e8 86 eb ff ff       	call   80100d70 <filealloc>
    if (p->swapFile == 0)
801021ea:	83 c4 10             	add    $0x10,%esp
801021ed:	85 c0                	test   %eax,%eax

    begin_op();
    struct inode *in = create(path, T_FILE, 0, 0);
    iunlock(in);

    p->swapFile = filealloc();
801021ef:	89 43 7c             	mov    %eax,0x7c(%ebx)
    if (p->swapFile == 0)
801021f2:	74 32                	je     80102226 <createSwapFile+0x86>
        panic("no slot for files on /store");

    p->swapFile->ip = in;
801021f4:	89 70 10             	mov    %esi,0x10(%eax)
    p->swapFile->type = FD_INODE;
801021f7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801021fa:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    p->swapFile->off = 0;
80102200:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102203:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    p->swapFile->readable = O_WRONLY;
8010220a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010220d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
    p->swapFile->writable = O_RDWR;
80102211:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102214:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102218:	e8 43 0d 00 00       	call   80102f60 <end_op>

    return 0;
}
8010221d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102220:	31 c0                	xor    %eax,%eax
80102222:	5b                   	pop    %ebx
80102223:	5e                   	pop    %esi
80102224:	5d                   	pop    %ebp
80102225:	c3                   	ret    
    struct inode *in = create(path, T_FILE, 0, 0);
    iunlock(in);

    p->swapFile = filealloc();
    if (p->swapFile == 0)
        panic("no slot for files on /store");
80102226:	83 ec 0c             	sub    $0xc,%esp
80102229:	68 40 74 10 80       	push   $0x80107440
8010222e:	e8 3d e1 ff ff       	call   80100370 <panic>
80102233:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102240 <writeToSwapFile>:
}

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102246:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102249:	8b 50 7c             	mov    0x7c(%eax),%edx
8010224c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010224f:	8b 55 14             	mov    0x14(%ebp),%edx
80102252:	89 55 10             	mov    %edx,0x10(%ebp)
80102255:	8b 40 7c             	mov    0x7c(%eax),%eax
80102258:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010225b:	5d                   	pop    %ebp
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return filewrite(p->swapFile, buffer, size);
8010225c:	e9 7f ed ff ff       	jmp    80100fe0 <filewrite>
80102261:	eb 0d                	jmp    80102270 <readFromSwapFile>
80102263:	90                   	nop
80102264:	90                   	nop
80102265:	90                   	nop
80102266:	90                   	nop
80102267:	90                   	nop
80102268:	90                   	nop
80102269:	90                   	nop
8010226a:	90                   	nop
8010226b:	90                   	nop
8010226c:	90                   	nop
8010226d:	90                   	nop
8010226e:	90                   	nop
8010226f:	90                   	nop

80102270 <readFromSwapFile>:
}

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102276:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102279:	8b 50 7c             	mov    0x7c(%eax),%edx
8010227c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010227f:	8b 55 14             	mov    0x14(%ebp),%edx
80102282:	89 55 10             	mov    %edx,0x10(%ebp)
80102285:	8b 40 7c             	mov    0x7c(%eax),%eax
80102288:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010228b:	5d                   	pop    %ebp
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return fileread(p->swapFile, buffer,  size);
8010228c:	e9 bf ec ff ff       	jmp    80100f50 <fileread>
80102291:	66 90                	xchg   %ax,%ax
80102293:	66 90                	xchg   %ax,%ax
80102295:	66 90                	xchg   %ax,%ax
80102297:	66 90                	xchg   %ax,%ax
80102299:	66 90                	xchg   %ax,%ax
8010229b:	66 90                	xchg   %ax,%ax
8010229d:	66 90                	xchg   %ax,%ax
8010229f:	90                   	nop

801022a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022a0:	55                   	push   %ebp
  if(b == 0)
801022a1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022a3:	89 e5                	mov    %esp,%ebp
801022a5:	56                   	push   %esi
801022a6:	53                   	push   %ebx
  if(b == 0)
801022a7:	0f 84 ad 00 00 00    	je     8010235a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022ad:	8b 58 08             	mov    0x8(%eax),%ebx
801022b0:	89 c1                	mov    %eax,%ecx
801022b2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022b8:	0f 87 8f 00 00 00    	ja     8010234d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022be:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022c3:	90                   	nop
801022c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022c8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c9:	83 e0 c0             	and    $0xffffffc0,%eax
801022cc:	3c 40                	cmp    $0x40,%al
801022ce:	75 f8                	jne    801022c8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d0:	31 f6                	xor    %esi,%esi
801022d2:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022d7:	89 f0                	mov    %esi,%eax
801022d9:	ee                   	out    %al,(%dx)
801022da:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022df:	b8 01 00 00 00       	mov    $0x1,%eax
801022e4:	ee                   	out    %al,(%dx)
801022e5:	ba f3 01 00 00       	mov    $0x1f3,%edx
801022ea:	89 d8                	mov    %ebx,%eax
801022ec:	ee                   	out    %al,(%dx)
801022ed:	89 d8                	mov    %ebx,%eax
801022ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
801022f4:	c1 f8 08             	sar    $0x8,%eax
801022f7:	ee                   	out    %al,(%dx)
801022f8:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022fd:	89 f0                	mov    %esi,%eax
801022ff:	ee                   	out    %al,(%dx)
80102300:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102304:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102309:	83 e0 01             	and    $0x1,%eax
8010230c:	c1 e0 04             	shl    $0x4,%eax
8010230f:	83 c8 e0             	or     $0xffffffe0,%eax
80102312:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102313:	f6 01 04             	testb  $0x4,(%ecx)
80102316:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010231b:	75 13                	jne    80102330 <idestart+0x90>
8010231d:	b8 20 00 00 00       	mov    $0x20,%eax
80102322:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102323:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102326:	5b                   	pop    %ebx
80102327:	5e                   	pop    %esi
80102328:	5d                   	pop    %ebp
80102329:	c3                   	ret    
8010232a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102330:	b8 30 00 00 00       	mov    $0x30,%eax
80102335:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102336:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010233b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010233e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102343:	fc                   	cld    
80102344:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102346:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102349:	5b                   	pop    %ebx
8010234a:	5e                   	pop    %esi
8010234b:	5d                   	pop    %ebp
8010234c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010234d:	83 ec 0c             	sub    $0xc,%esp
80102350:	68 b8 74 10 80       	push   $0x801074b8
80102355:	e8 16 e0 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010235a:	83 ec 0c             	sub    $0xc,%esp
8010235d:	68 af 74 10 80       	push   $0x801074af
80102362:	e8 09 e0 ff ff       	call   80100370 <panic>
80102367:	89 f6                	mov    %esi,%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102370 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102376:	68 ca 74 10 80       	push   $0x801074ca
8010237b:	68 80 a5 10 80       	push   $0x8010a580
80102380:	e8 eb 21 00 00       	call   80104570 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102385:	58                   	pop    %eax
80102386:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010238b:	5a                   	pop    %edx
8010238c:	83 e8 01             	sub    $0x1,%eax
8010238f:	50                   	push   %eax
80102390:	6a 0e                	push   $0xe
80102392:	e8 a9 02 00 00       	call   80102640 <ioapicenable>
80102397:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010239a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010239f:	90                   	nop
801023a0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023a1:	83 e0 c0             	and    $0xffffffc0,%eax
801023a4:	3c 40                	cmp    $0x40,%al
801023a6:	75 f8                	jne    801023a0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023a8:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023ad:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023b2:	ee                   	out    %al,(%dx)
801023b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023bd:	eb 06                	jmp    801023c5 <ideinit+0x55>
801023bf:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801023c0:	83 e9 01             	sub    $0x1,%ecx
801023c3:	74 0f                	je     801023d4 <ideinit+0x64>
801023c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023c6:	84 c0                	test   %al,%al
801023c8:	74 f6                	je     801023c0 <ideinit+0x50>
      havedisk1 = 1;
801023ca:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801023d1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023d4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023d9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023de:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801023df:	c9                   	leave  
801023e0:	c3                   	ret    
801023e1:	eb 0d                	jmp    801023f0 <ideintr>
801023e3:	90                   	nop
801023e4:	90                   	nop
801023e5:	90                   	nop
801023e6:	90                   	nop
801023e7:	90                   	nop
801023e8:	90                   	nop
801023e9:	90                   	nop
801023ea:	90                   	nop
801023eb:	90                   	nop
801023ec:	90                   	nop
801023ed:	90                   	nop
801023ee:	90                   	nop
801023ef:	90                   	nop

801023f0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	57                   	push   %edi
801023f4:	56                   	push   %esi
801023f5:	53                   	push   %ebx
801023f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801023f9:	68 80 a5 10 80       	push   $0x8010a580
801023fe:	e8 6d 22 00 00       	call   80104670 <acquire>

  if((b = idequeue) == 0){
80102403:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102409:	83 c4 10             	add    $0x10,%esp
8010240c:	85 db                	test   %ebx,%ebx
8010240e:	74 34                	je     80102444 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102410:	8b 43 58             	mov    0x58(%ebx),%eax
80102413:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102418:	8b 33                	mov    (%ebx),%esi
8010241a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102420:	74 3e                	je     80102460 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102422:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102425:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102428:	83 ce 02             	or     $0x2,%esi
8010242b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010242d:	53                   	push   %ebx
8010242e:	e8 7d 1e 00 00       	call   801042b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102433:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102438:	83 c4 10             	add    $0x10,%esp
8010243b:	85 c0                	test   %eax,%eax
8010243d:	74 05                	je     80102444 <ideintr+0x54>
    idestart(idequeue);
8010243f:	e8 5c fe ff ff       	call   801022a0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102444:	83 ec 0c             	sub    $0xc,%esp
80102447:	68 80 a5 10 80       	push   $0x8010a580
8010244c:	e8 3f 23 00 00       	call   80104790 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102454:	5b                   	pop    %ebx
80102455:	5e                   	pop    %esi
80102456:	5f                   	pop    %edi
80102457:	5d                   	pop    %ebp
80102458:	c3                   	ret    
80102459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102460:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102465:	8d 76 00             	lea    0x0(%esi),%esi
80102468:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102469:	89 c1                	mov    %eax,%ecx
8010246b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010246e:	80 f9 40             	cmp    $0x40,%cl
80102471:	75 f5                	jne    80102468 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102473:	a8 21                	test   $0x21,%al
80102475:	75 ab                	jne    80102422 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102477:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010247a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010247f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102484:	fc                   	cld    
80102485:	f3 6d                	rep insl (%dx),%es:(%edi)
80102487:	8b 33                	mov    (%ebx),%esi
80102489:	eb 97                	jmp    80102422 <ideintr+0x32>
8010248b:	90                   	nop
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102490 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 10             	sub    $0x10,%esp
80102497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010249a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010249d:	50                   	push   %eax
8010249e:	e8 9d 20 00 00       	call   80104540 <holdingsleep>
801024a3:	83 c4 10             	add    $0x10,%esp
801024a6:	85 c0                	test   %eax,%eax
801024a8:	0f 84 ad 00 00 00    	je     8010255b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024ae:	8b 03                	mov    (%ebx),%eax
801024b0:	83 e0 06             	and    $0x6,%eax
801024b3:	83 f8 02             	cmp    $0x2,%eax
801024b6:	0f 84 b9 00 00 00    	je     80102575 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024bc:	8b 53 04             	mov    0x4(%ebx),%edx
801024bf:	85 d2                	test   %edx,%edx
801024c1:	74 0d                	je     801024d0 <iderw+0x40>
801024c3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801024c8:	85 c0                	test   %eax,%eax
801024ca:	0f 84 98 00 00 00    	je     80102568 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	68 80 a5 10 80       	push   $0x8010a580
801024d8:	e8 93 21 00 00       	call   80104670 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024dd:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801024e3:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801024e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024ed:	85 d2                	test   %edx,%edx
801024ef:	75 09                	jne    801024fa <iderw+0x6a>
801024f1:	eb 58                	jmp    8010254b <iderw+0xbb>
801024f3:	90                   	nop
801024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f8:	89 c2                	mov    %eax,%edx
801024fa:	8b 42 58             	mov    0x58(%edx),%eax
801024fd:	85 c0                	test   %eax,%eax
801024ff:	75 f7                	jne    801024f8 <iderw+0x68>
80102501:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102504:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102506:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010250c:	74 44                	je     80102552 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010250e:	8b 03                	mov    (%ebx),%eax
80102510:	83 e0 06             	and    $0x6,%eax
80102513:	83 f8 02             	cmp    $0x2,%eax
80102516:	74 23                	je     8010253b <iderw+0xab>
80102518:	90                   	nop
80102519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102520:	83 ec 08             	sub    $0x8,%esp
80102523:	68 80 a5 10 80       	push   $0x8010a580
80102528:	53                   	push   %ebx
80102529:	e8 d2 1b 00 00       	call   80104100 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010252e:	8b 03                	mov    (%ebx),%eax
80102530:	83 c4 10             	add    $0x10,%esp
80102533:	83 e0 06             	and    $0x6,%eax
80102536:	83 f8 02             	cmp    $0x2,%eax
80102539:	75 e5                	jne    80102520 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010253b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102545:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102546:	e9 45 22 00 00       	jmp    80104790 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010254b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102550:	eb b2                	jmp    80102504 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102552:	89 d8                	mov    %ebx,%eax
80102554:	e8 47 fd ff ff       	call   801022a0 <idestart>
80102559:	eb b3                	jmp    8010250e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010255b:	83 ec 0c             	sub    $0xc,%esp
8010255e:	68 ce 74 10 80       	push   $0x801074ce
80102563:	e8 08 de ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	68 f9 74 10 80       	push   $0x801074f9
80102570:	e8 fb dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102575:	83 ec 0c             	sub    $0xc,%esp
80102578:	68 e4 74 10 80       	push   $0x801074e4
8010257d:	e8 ee dd ff ff       	call   80100370 <panic>
80102582:	66 90                	xchg   %ax,%ax
80102584:	66 90                	xchg   %ax,%ax
80102586:	66 90                	xchg   %ax,%ax
80102588:	66 90                	xchg   %ax,%ax
8010258a:	66 90                	xchg   %ax,%ax
8010258c:	66 90                	xchg   %ax,%ax
8010258e:	66 90                	xchg   %ax,%ax

80102590 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102590:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102591:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102598:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010259b:	89 e5                	mov    %esp,%ebp
8010259d:	56                   	push   %esi
8010259e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010259f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025a6:	00 00 00 
  return ioapic->data;
801025a9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801025af:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025b2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801025b8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025be:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025c5:	89 f0                	mov    %esi,%eax
801025c7:	c1 e8 10             	shr    $0x10,%eax
801025ca:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801025cd:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025d0:	c1 e8 18             	shr    $0x18,%eax
801025d3:	39 d0                	cmp    %edx,%eax
801025d5:	74 16                	je     801025ed <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025d7:	83 ec 0c             	sub    $0xc,%esp
801025da:	68 18 75 10 80       	push   $0x80107518
801025df:	e8 7c e0 ff ff       	call   80100660 <cprintf>
801025e4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801025ea:	83 c4 10             	add    $0x10,%esp
801025ed:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025f0:	ba 10 00 00 00       	mov    $0x10,%edx
801025f5:	b8 20 00 00 00       	mov    $0x20,%eax
801025fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102600:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102602:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102608:	89 c3                	mov    %eax,%ebx
8010260a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102610:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102613:	89 59 10             	mov    %ebx,0x10(%ecx)
80102616:	8d 5a 01             	lea    0x1(%edx),%ebx
80102619:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010261c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010261e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102620:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102626:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010262d:	75 d1                	jne    80102600 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010262f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102632:	5b                   	pop    %ebx
80102633:	5e                   	pop    %esi
80102634:	5d                   	pop    %ebp
80102635:	c3                   	ret    
80102636:	8d 76 00             	lea    0x0(%esi),%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102640 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102640:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102641:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102647:	89 e5                	mov    %esp,%ebp
80102649:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010264c:	8d 50 20             	lea    0x20(%eax),%edx
8010264f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102653:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102655:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010265b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010265e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102661:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102664:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102666:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010266b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010266e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	66 90                	xchg   %ax,%ax
80102675:	66 90                	xchg   %ax,%ax
80102677:	66 90                	xchg   %ax,%ax
80102679:	66 90                	xchg   %ax,%ax
8010267b:	66 90                	xchg   %ax,%ax
8010267d:	66 90                	xchg   %ax,%ax
8010267f:	90                   	nop

80102680 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	53                   	push   %ebx
80102684:	83 ec 04             	sub    $0x4,%esp
80102687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010268a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102690:	75 70                	jne    80102702 <kfree+0x82>
80102692:	81 fb a8 65 11 80    	cmp    $0x801165a8,%ebx
80102698:	72 68                	jb     80102702 <kfree+0x82>
8010269a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026a5:	77 5b                	ja     80102702 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026a7:	83 ec 04             	sub    $0x4,%esp
801026aa:	68 00 10 00 00       	push   $0x1000
801026af:	6a 01                	push   $0x1
801026b1:	53                   	push   %ebx
801026b2:	e8 29 21 00 00       	call   801047e0 <memset>

  if(kmem.use_lock)
801026b7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801026bd:	83 c4 10             	add    $0x10,%esp
801026c0:	85 d2                	test   %edx,%edx
801026c2:	75 2c                	jne    801026f0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026c4:	a1 78 26 11 80       	mov    0x80112678,%eax
801026c9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026cb:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801026d0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801026d6:	85 c0                	test   %eax,%eax
801026d8:	75 06                	jne    801026e0 <kfree+0x60>
    release(&kmem.lock);
}
801026da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026dd:	c9                   	leave  
801026de:	c3                   	ret    
801026df:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801026e0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801026e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026ea:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801026eb:	e9 a0 20 00 00       	jmp    80104790 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	68 40 26 11 80       	push   $0x80112640
801026f8:	e8 73 1f 00 00       	call   80104670 <acquire>
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	eb c2                	jmp    801026c4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102702:	83 ec 0c             	sub    $0xc,%esp
80102705:	68 4a 75 10 80       	push   $0x8010754a
8010270a:	e8 61 dc ff ff       	call   80100370 <panic>
8010270f:	90                   	nop

80102710 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	56                   	push   %esi
80102714:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102715:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102718:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010271b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102721:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102727:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010272d:	39 de                	cmp    %ebx,%esi
8010272f:	72 23                	jb     80102754 <freerange+0x44>
80102731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102738:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010273e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102741:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102747:	50                   	push   %eax
80102748:	e8 33 ff ff ff       	call   80102680 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	39 f3                	cmp    %esi,%ebx
80102752:	76 e4                	jbe    80102738 <freerange+0x28>
    kfree(p);
}
80102754:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102757:	5b                   	pop    %ebx
80102758:	5e                   	pop    %esi
80102759:	5d                   	pop    %ebp
8010275a:	c3                   	ret    
8010275b:	90                   	nop
8010275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102760 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	56                   	push   %esi
80102764:	53                   	push   %ebx
80102765:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102768:	83 ec 08             	sub    $0x8,%esp
8010276b:	68 50 75 10 80       	push   $0x80107550
80102770:	68 40 26 11 80       	push   $0x80112640
80102775:	e8 f6 1d 00 00       	call   80104570 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010277a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102780:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102787:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010278a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102790:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102796:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010279c:	39 de                	cmp    %ebx,%esi
8010279e:	72 1c                	jb     801027bc <kinit1+0x5c>
    kfree(p);
801027a0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027a6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027af:	50                   	push   %eax
801027b0:	e8 cb fe ff ff       	call   80102680 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027b5:	83 c4 10             	add    $0x10,%esp
801027b8:	39 de                	cmp    %ebx,%esi
801027ba:	73 e4                	jae    801027a0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801027bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027bf:	5b                   	pop    %ebx
801027c0:	5e                   	pop    %esi
801027c1:	5d                   	pop    %ebp
801027c2:	c3                   	ret    
801027c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027d0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	56                   	push   %esi
801027d4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027d5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801027d8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ed:	39 de                	cmp    %ebx,%esi
801027ef:	72 23                	jb     80102814 <kinit2+0x44>
801027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027fe:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102801:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102807:	50                   	push   %eax
80102808:	e8 73 fe ff ff       	call   80102680 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010280d:	83 c4 10             	add    $0x10,%esp
80102810:	39 de                	cmp    %ebx,%esi
80102812:	73 e4                	jae    801027f8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102814:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010281b:	00 00 00 
}
8010281e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102821:	5b                   	pop    %ebx
80102822:	5e                   	pop    %esi
80102823:	5d                   	pop    %ebp
80102824:	c3                   	ret    
80102825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102830 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	53                   	push   %ebx
80102834:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102837:	a1 74 26 11 80       	mov    0x80112674,%eax
8010283c:	85 c0                	test   %eax,%eax
8010283e:	75 30                	jne    80102870 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102840:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102846:	85 db                	test   %ebx,%ebx
80102848:	74 1c                	je     80102866 <kalloc+0x36>
    kmem.freelist = r->next;
8010284a:	8b 13                	mov    (%ebx),%edx
8010284c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102852:	85 c0                	test   %eax,%eax
80102854:	74 10                	je     80102866 <kalloc+0x36>
    release(&kmem.lock);
80102856:	83 ec 0c             	sub    $0xc,%esp
80102859:	68 40 26 11 80       	push   $0x80112640
8010285e:	e8 2d 1f 00 00       	call   80104790 <release>
80102863:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102866:	89 d8                	mov    %ebx,%eax
80102868:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010286b:	c9                   	leave  
8010286c:	c3                   	ret    
8010286d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102870:	83 ec 0c             	sub    $0xc,%esp
80102873:	68 40 26 11 80       	push   $0x80112640
80102878:	e8 f3 1d 00 00       	call   80104670 <acquire>
  r = kmem.freelist;
8010287d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102883:	83 c4 10             	add    $0x10,%esp
80102886:	a1 74 26 11 80       	mov    0x80112674,%eax
8010288b:	85 db                	test   %ebx,%ebx
8010288d:	75 bb                	jne    8010284a <kalloc+0x1a>
8010288f:	eb c1                	jmp    80102852 <kalloc+0x22>
80102891:	66 90                	xchg   %ax,%ax
80102893:	66 90                	xchg   %ax,%ax
80102895:	66 90                	xchg   %ax,%ax
80102897:	66 90                	xchg   %ax,%ax
80102899:	66 90                	xchg   %ax,%ax
8010289b:	66 90                	xchg   %ax,%ax
8010289d:	66 90                	xchg   %ax,%ax
8010289f:	90                   	nop

801028a0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801028a0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a1:	ba 64 00 00 00       	mov    $0x64,%edx
801028a6:	89 e5                	mov    %esp,%ebp
801028a8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028a9:	a8 01                	test   $0x1,%al
801028ab:	0f 84 af 00 00 00    	je     80102960 <kbdgetc+0xc0>
801028b1:	ba 60 00 00 00       	mov    $0x60,%edx
801028b6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028b7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801028ba:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028c0:	74 7e                	je     80102940 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028c2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028c4:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028ca:	79 24                	jns    801028f0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028cc:	f6 c1 40             	test   $0x40,%cl
801028cf:	75 05                	jne    801028d6 <kbdgetc+0x36>
801028d1:	89 c2                	mov    %eax,%edx
801028d3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801028d6:	0f b6 82 80 76 10 80 	movzbl -0x7fef8980(%edx),%eax
801028dd:	83 c8 40             	or     $0x40,%eax
801028e0:	0f b6 c0             	movzbl %al,%eax
801028e3:	f7 d0                	not    %eax
801028e5:	21 c8                	and    %ecx,%eax
801028e7:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801028ec:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028ee:	5d                   	pop    %ebp
801028ef:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028f0:	f6 c1 40             	test   $0x40,%cl
801028f3:	74 09                	je     801028fe <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028f5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028f8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028fb:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801028fe:	0f b6 82 80 76 10 80 	movzbl -0x7fef8980(%edx),%eax
80102905:	09 c1                	or     %eax,%ecx
80102907:	0f b6 82 80 75 10 80 	movzbl -0x7fef8a80(%edx),%eax
8010290e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102910:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102912:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102918:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010291b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010291e:	8b 04 85 60 75 10 80 	mov    -0x7fef8aa0(,%eax,4),%eax
80102925:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102929:	74 c3                	je     801028ee <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010292b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010292e:	83 fa 19             	cmp    $0x19,%edx
80102931:	77 1d                	ja     80102950 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102933:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102936:	5d                   	pop    %ebp
80102937:	c3                   	ret    
80102938:	90                   	nop
80102939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102940:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102942:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102949:	5d                   	pop    %ebp
8010294a:	c3                   	ret    
8010294b:	90                   	nop
8010294c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102950:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102953:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102956:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102957:	83 f9 19             	cmp    $0x19,%ecx
8010295a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010295d:	c3                   	ret    
8010295e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102965:	5d                   	pop    %ebp
80102966:	c3                   	ret    
80102967:	89 f6                	mov    %esi,%esi
80102969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102970 <kbdintr>:

void
kbdintr(void)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102976:	68 a0 28 10 80       	push   $0x801028a0
8010297b:	e8 70 de ff ff       	call   801007f0 <consoleintr>
}
80102980:	83 c4 10             	add    $0x10,%esp
80102983:	c9                   	leave  
80102984:	c3                   	ret    
80102985:	66 90                	xchg   %ax,%ax
80102987:	66 90                	xchg   %ax,%ax
80102989:	66 90                	xchg   %ax,%ax
8010298b:	66 90                	xchg   %ax,%ax
8010298d:	66 90                	xchg   %ax,%ax
8010298f:	90                   	nop

80102990 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102990:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102995:	55                   	push   %ebp
80102996:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102998:	85 c0                	test   %eax,%eax
8010299a:	0f 84 c8 00 00 00    	je     80102a68 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029a0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029a7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029aa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ad:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ba:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029c1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029c4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029c7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029ce:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029d1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029d4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029db:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029de:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029e1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029ee:	8b 50 30             	mov    0x30(%eax),%edx
801029f1:	c1 ea 10             	shr    $0x10,%edx
801029f4:	80 fa 03             	cmp    $0x3,%dl
801029f7:	77 77                	ja     80102a70 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029f9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a03:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a06:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a0d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a10:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a13:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a1a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a20:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a27:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a2d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a3a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a41:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a44:	8b 50 20             	mov    0x20(%eax),%edx
80102a47:	89 f6                	mov    %esi,%esi
80102a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a50:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a56:	80 e6 10             	and    $0x10,%dh
80102a59:	75 f5                	jne    80102a50 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a62:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a65:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a68:	5d                   	pop    %ebp
80102a69:	c3                   	ret    
80102a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a70:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a77:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a7a:	8b 50 20             	mov    0x20(%eax),%edx
80102a7d:	e9 77 ff ff ff       	jmp    801029f9 <lapicinit+0x69>
80102a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a90 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102a90:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102a95:	55                   	push   %ebp
80102a96:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102a98:	85 c0                	test   %eax,%eax
80102a9a:	74 0c                	je     80102aa8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102a9c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102a9f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102aa0:	c1 e8 18             	shr    $0x18,%eax
}
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102aa8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102aaa:	5d                   	pop    %ebp
80102aab:	c3                   	ret    
80102aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ab0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ab0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ab5:	55                   	push   %ebp
80102ab6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ab8:	85 c0                	test   %eax,%eax
80102aba:	74 0d                	je     80102ac9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102abc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ac3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102ac9:	5d                   	pop    %ebp
80102aca:	c3                   	ret    
80102acb:	90                   	nop
80102acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ad0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
}
80102ad3:	5d                   	pop    %ebp
80102ad4:	c3                   	ret    
80102ad5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ae0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae1:	ba 70 00 00 00       	mov    $0x70,%edx
80102ae6:	b8 0f 00 00 00       	mov    $0xf,%eax
80102aeb:	89 e5                	mov    %esp,%ebp
80102aed:	53                   	push   %ebx
80102aee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102af1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102af4:	ee                   	out    %al,(%dx)
80102af5:	ba 71 00 00 00       	mov    $0x71,%edx
80102afa:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b00:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b02:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b0d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b10:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b13:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b15:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b18:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b1e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102b23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b29:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b36:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b43:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b4c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b55:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b5e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b67:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102b6a:	5b                   	pop    %ebx
80102b6b:	5d                   	pop    %ebp
80102b6c:	c3                   	ret    
80102b6d:	8d 76 00             	lea    0x0(%esi),%esi

80102b70 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102b70:	55                   	push   %ebp
80102b71:	ba 70 00 00 00       	mov    $0x70,%edx
80102b76:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b7b:	89 e5                	mov    %esp,%ebp
80102b7d:	57                   	push   %edi
80102b7e:	56                   	push   %esi
80102b7f:	53                   	push   %ebx
80102b80:	83 ec 4c             	sub    $0x4c,%esp
80102b83:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b84:	ba 71 00 00 00       	mov    $0x71,%edx
80102b89:	ec                   	in     (%dx),%al
80102b8a:	83 e0 04             	and    $0x4,%eax
80102b8d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b90:	31 db                	xor    %ebx,%ebx
80102b92:	88 45 b7             	mov    %al,-0x49(%ebp)
80102b95:	bf 70 00 00 00       	mov    $0x70,%edi
80102b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ba0:	89 d8                	mov    %ebx,%eax
80102ba2:	89 fa                	mov    %edi,%edx
80102ba4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102baa:	89 ca                	mov    %ecx,%edx
80102bac:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102bad:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb0:	89 fa                	mov    %edi,%edx
80102bb2:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102bb5:	b8 02 00 00 00       	mov    $0x2,%eax
80102bba:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbb:	89 ca                	mov    %ecx,%edx
80102bbd:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102bbe:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc1:	89 fa                	mov    %edi,%edx
80102bc3:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102bc6:	b8 04 00 00 00       	mov    $0x4,%eax
80102bcb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcc:	89 ca                	mov    %ecx,%edx
80102bce:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102bcf:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd2:	89 fa                	mov    %edi,%edx
80102bd4:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bd7:	b8 07 00 00 00       	mov    $0x7,%eax
80102bdc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdd:	89 ca                	mov    %ecx,%edx
80102bdf:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102be0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be3:	89 fa                	mov    %edi,%edx
80102be5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102be8:	b8 08 00 00 00       	mov    $0x8,%eax
80102bed:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bee:	89 ca                	mov    %ecx,%edx
80102bf0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102bf1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf4:	89 fa                	mov    %edi,%edx
80102bf6:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102bf9:	b8 09 00 00 00       	mov    $0x9,%eax
80102bfe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bff:	89 ca                	mov    %ecx,%edx
80102c01:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c02:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c05:	89 fa                	mov    %edi,%edx
80102c07:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102c0a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c0f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c10:	89 ca                	mov    %ecx,%edx
80102c12:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c13:	84 c0                	test   %al,%al
80102c15:	78 89                	js     80102ba0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c17:	89 d8                	mov    %ebx,%eax
80102c19:	89 fa                	mov    %edi,%edx
80102c1b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1c:	89 ca                	mov    %ecx,%edx
80102c1e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c1f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c22:	89 fa                	mov    %edi,%edx
80102c24:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c27:	b8 02 00 00 00       	mov    $0x2,%eax
80102c2c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2d:	89 ca                	mov    %ecx,%edx
80102c2f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c30:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c33:	89 fa                	mov    %edi,%edx
80102c35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c38:	b8 04 00 00 00       	mov    $0x4,%eax
80102c3d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3e:	89 ca                	mov    %ecx,%edx
80102c40:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c41:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c44:	89 fa                	mov    %edi,%edx
80102c46:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c49:	b8 07 00 00 00       	mov    $0x7,%eax
80102c4e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4f:	89 ca                	mov    %ecx,%edx
80102c51:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c52:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c55:	89 fa                	mov    %edi,%edx
80102c57:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c5a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c5f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c60:	89 ca                	mov    %ecx,%edx
80102c62:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c63:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c66:	89 fa                	mov    %edi,%edx
80102c68:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c6b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c70:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c71:	89 ca                	mov    %ecx,%edx
80102c73:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c74:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c77:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102c7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c7d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c80:	6a 18                	push   $0x18
80102c82:	56                   	push   %esi
80102c83:	50                   	push   %eax
80102c84:	e8 a7 1b 00 00       	call   80104830 <memcmp>
80102c89:	83 c4 10             	add    $0x10,%esp
80102c8c:	85 c0                	test   %eax,%eax
80102c8e:	0f 85 0c ff ff ff    	jne    80102ba0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102c94:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102c98:	75 78                	jne    80102d12 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c9a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c9d:	89 c2                	mov    %eax,%edx
80102c9f:	83 e0 0f             	and    $0xf,%eax
80102ca2:	c1 ea 04             	shr    $0x4,%edx
80102ca5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ca8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cab:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cae:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cb1:	89 c2                	mov    %eax,%edx
80102cb3:	83 e0 0f             	and    $0xf,%eax
80102cb6:	c1 ea 04             	shr    $0x4,%edx
80102cb9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cbc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cbf:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102cc2:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cc5:	89 c2                	mov    %eax,%edx
80102cc7:	83 e0 0f             	and    $0xf,%eax
80102cca:	c1 ea 04             	shr    $0x4,%edx
80102ccd:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cd0:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cd3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cd6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cd9:	89 c2                	mov    %eax,%edx
80102cdb:	83 e0 0f             	and    $0xf,%eax
80102cde:	c1 ea 04             	shr    $0x4,%edx
80102ce1:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ce4:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ce7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cea:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ced:	89 c2                	mov    %eax,%edx
80102cef:	83 e0 0f             	and    $0xf,%eax
80102cf2:	c1 ea 04             	shr    $0x4,%edx
80102cf5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cf8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cfb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102cfe:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d01:	89 c2                	mov    %eax,%edx
80102d03:	83 e0 0f             	and    $0xf,%eax
80102d06:	c1 ea 04             	shr    $0x4,%edx
80102d09:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d0c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d0f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d12:	8b 75 08             	mov    0x8(%ebp),%esi
80102d15:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d18:	89 06                	mov    %eax,(%esi)
80102d1a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d1d:	89 46 04             	mov    %eax,0x4(%esi)
80102d20:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d23:	89 46 08             	mov    %eax,0x8(%esi)
80102d26:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d29:	89 46 0c             	mov    %eax,0xc(%esi)
80102d2c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d2f:	89 46 10             	mov    %eax,0x10(%esi)
80102d32:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d35:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d38:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d42:	5b                   	pop    %ebx
80102d43:	5e                   	pop    %esi
80102d44:	5f                   	pop    %edi
80102d45:	5d                   	pop    %ebp
80102d46:	c3                   	ret    
80102d47:	66 90                	xchg   %ax,%ax
80102d49:	66 90                	xchg   %ax,%ax
80102d4b:	66 90                	xchg   %ax,%ax
80102d4d:	66 90                	xchg   %ax,%ax
80102d4f:	90                   	nop

80102d50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d50:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d56:	85 c9                	test   %ecx,%ecx
80102d58:	0f 8e 85 00 00 00    	jle    80102de3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102d5e:	55                   	push   %ebp
80102d5f:	89 e5                	mov    %esp,%ebp
80102d61:	57                   	push   %edi
80102d62:	56                   	push   %esi
80102d63:	53                   	push   %ebx
80102d64:	31 db                	xor    %ebx,%ebx
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d70:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d75:	83 ec 08             	sub    $0x8,%esp
80102d78:	01 d8                	add    %ebx,%eax
80102d7a:	83 c0 01             	add    $0x1,%eax
80102d7d:	50                   	push   %eax
80102d7e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d84:	e8 47 d3 ff ff       	call   801000d0 <bread>
80102d89:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d8b:	58                   	pop    %eax
80102d8c:	5a                   	pop    %edx
80102d8d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102d94:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d9d:	e8 2e d3 ff ff       	call   801000d0 <bread>
80102da2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102da4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102da7:	83 c4 0c             	add    $0xc,%esp
80102daa:	68 00 02 00 00       	push   $0x200
80102daf:	50                   	push   %eax
80102db0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102db3:	50                   	push   %eax
80102db4:	e8 d7 1a 00 00       	call   80104890 <memmove>
    bwrite(dbuf);  // write dst to disk
80102db9:	89 34 24             	mov    %esi,(%esp)
80102dbc:	e8 df d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102dc1:	89 3c 24             	mov    %edi,(%esp)
80102dc4:	e8 17 d4 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102dc9:	89 34 24             	mov    %esi,(%esp)
80102dcc:	e8 0f d4 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dd1:	83 c4 10             	add    $0x10,%esp
80102dd4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102dda:	7f 94                	jg     80102d70 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ddf:	5b                   	pop    %ebx
80102de0:	5e                   	pop    %esi
80102de1:	5f                   	pop    %edi
80102de2:	5d                   	pop    %ebp
80102de3:	f3 c3                	repz ret 
80102de5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102df0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102df7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102dfd:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e03:	e8 c8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e08:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e0e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e11:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e13:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e15:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e18:	7e 1f                	jle    80102e39 <write_head+0x49>
80102e1a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102e21:	31 d2                	xor    %edx,%edx
80102e23:	90                   	nop
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e28:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102e2e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102e32:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e35:	39 c2                	cmp    %eax,%edx
80102e37:	75 ef                	jne    80102e28 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102e39:	83 ec 0c             	sub    $0xc,%esp
80102e3c:	53                   	push   %ebx
80102e3d:	e8 5e d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e42:	89 1c 24             	mov    %ebx,(%esp)
80102e45:	e8 96 d3 ff ff       	call   801001e0 <brelse>
}
80102e4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e4d:	c9                   	leave  
80102e4e:	c3                   	ret    
80102e4f:	90                   	nop

80102e50 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 2c             	sub    $0x2c,%esp
80102e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e5a:	68 80 77 10 80       	push   $0x80107780
80102e5f:	68 80 26 11 80       	push   $0x80112680
80102e64:	e8 07 17 00 00       	call   80104570 <initlock>
  readsb(dev, &sb);
80102e69:	58                   	pop    %eax
80102e6a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e6d:	5a                   	pop    %edx
80102e6e:	50                   	push   %eax
80102e6f:	53                   	push   %ebx
80102e70:	e8 3b e5 ff ff       	call   801013b0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102e75:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102e78:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e7b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102e7c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102e82:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102e88:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e8d:	5a                   	pop    %edx
80102e8e:	50                   	push   %eax
80102e8f:	53                   	push   %ebx
80102e90:	e8 3b d2 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102e95:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e98:	83 c4 10             	add    $0x10,%esp
80102e9b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102e9d:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ea3:	7e 1c                	jle    80102ec1 <initlog+0x71>
80102ea5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102eac:	31 d2                	xor    %edx,%edx
80102eae:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102eb0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102eb4:	83 c2 04             	add    $0x4,%edx
80102eb7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ebd:	39 da                	cmp    %ebx,%edx
80102ebf:	75 ef                	jne    80102eb0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102ec1:	83 ec 0c             	sub    $0xc,%esp
80102ec4:	50                   	push   %eax
80102ec5:	e8 16 d3 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102eca:	e8 81 fe ff ff       	call   80102d50 <install_trans>
  log.lh.n = 0;
80102ecf:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ed6:	00 00 00 
  write_head(); // clear the log
80102ed9:	e8 12 ff ff ff       	call   80102df0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102ede:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ee1:	c9                   	leave  
80102ee2:	c3                   	ret    
80102ee3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ef0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ef6:	68 80 26 11 80       	push   $0x80112680
80102efb:	e8 70 17 00 00       	call   80104670 <acquire>
80102f00:	83 c4 10             	add    $0x10,%esp
80102f03:	eb 18                	jmp    80102f1d <begin_op+0x2d>
80102f05:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f08:	83 ec 08             	sub    $0x8,%esp
80102f0b:	68 80 26 11 80       	push   $0x80112680
80102f10:	68 80 26 11 80       	push   $0x80112680
80102f15:	e8 e6 11 00 00       	call   80104100 <sleep>
80102f1a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102f1d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102f22:	85 c0                	test   %eax,%eax
80102f24:	75 e2                	jne    80102f08 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f26:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f2b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f31:	83 c0 01             	add    $0x1,%eax
80102f34:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f37:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f3a:	83 fa 1e             	cmp    $0x1e,%edx
80102f3d:	7f c9                	jg     80102f08 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f3f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102f42:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102f47:	68 80 26 11 80       	push   $0x80112680
80102f4c:	e8 3f 18 00 00       	call   80104790 <release>
      break;
    }
  }
}
80102f51:	83 c4 10             	add    $0x10,%esp
80102f54:	c9                   	leave  
80102f55:	c3                   	ret    
80102f56:	8d 76 00             	lea    0x0(%esi),%esi
80102f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f60 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	57                   	push   %edi
80102f64:	56                   	push   %esi
80102f65:	53                   	push   %ebx
80102f66:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f69:	68 80 26 11 80       	push   $0x80112680
80102f6e:	e8 fd 16 00 00       	call   80104670 <acquire>
  log.outstanding -= 1;
80102f73:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102f78:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102f7e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102f81:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102f84:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102f86:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102f8b:	0f 85 23 01 00 00    	jne    801030b4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f91:	85 c0                	test   %eax,%eax
80102f93:	0f 85 f7 00 00 00    	jne    80103090 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f99:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102f9c:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102fa3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fa6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fa8:	68 80 26 11 80       	push   $0x80112680
80102fad:	e8 de 17 00 00       	call   80104790 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fb2:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102fb8:	83 c4 10             	add    $0x10,%esp
80102fbb:	85 c9                	test   %ecx,%ecx
80102fbd:	0f 8e 8a 00 00 00    	jle    8010304d <end_op+0xed>
80102fc3:	90                   	nop
80102fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fc8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102fcd:	83 ec 08             	sub    $0x8,%esp
80102fd0:	01 d8                	add    %ebx,%eax
80102fd2:	83 c0 01             	add    $0x1,%eax
80102fd5:	50                   	push   %eax
80102fd6:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102fdc:	e8 ef d0 ff ff       	call   801000d0 <bread>
80102fe1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fe3:	58                   	pop    %eax
80102fe4:	5a                   	pop    %edx
80102fe5:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102fec:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ff2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ff5:	e8 d6 d0 ff ff       	call   801000d0 <bread>
80102ffa:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ffc:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fff:	83 c4 0c             	add    $0xc,%esp
80103002:	68 00 02 00 00       	push   $0x200
80103007:	50                   	push   %eax
80103008:	8d 46 5c             	lea    0x5c(%esi),%eax
8010300b:	50                   	push   %eax
8010300c:	e8 7f 18 00 00       	call   80104890 <memmove>
    bwrite(to);  // write the log
80103011:	89 34 24             	mov    %esi,(%esp)
80103014:	e8 87 d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103019:	89 3c 24             	mov    %edi,(%esp)
8010301c:	e8 bf d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
80103021:	89 34 24             	mov    %esi,(%esp)
80103024:	e8 b7 d1 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103029:	83 c4 10             	add    $0x10,%esp
8010302c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80103032:	7c 94                	jl     80102fc8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103034:	e8 b7 fd ff ff       	call   80102df0 <write_head>
    install_trans(); // Now install writes to home locations
80103039:	e8 12 fd ff ff       	call   80102d50 <install_trans>
    log.lh.n = 0;
8010303e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80103045:	00 00 00 
    write_head();    // Erase the transaction from the log
80103048:	e8 a3 fd ff ff       	call   80102df0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010304d:	83 ec 0c             	sub    $0xc,%esp
80103050:	68 80 26 11 80       	push   $0x80112680
80103055:	e8 16 16 00 00       	call   80104670 <acquire>
    log.committing = 0;
    wakeup(&log);
8010305a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80103061:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80103068:	00 00 00 
    wakeup(&log);
8010306b:	e8 40 12 00 00       	call   801042b0 <wakeup>
    release(&log.lock);
80103070:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80103077:	e8 14 17 00 00       	call   80104790 <release>
8010307c:	83 c4 10             	add    $0x10,%esp
  }
}
8010307f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103082:	5b                   	pop    %ebx
80103083:	5e                   	pop    %esi
80103084:	5f                   	pop    %edi
80103085:	5d                   	pop    %ebp
80103086:	c3                   	ret    
80103087:	89 f6                	mov    %esi,%esi
80103089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103090:	83 ec 0c             	sub    $0xc,%esp
80103093:	68 80 26 11 80       	push   $0x80112680
80103098:	e8 13 12 00 00       	call   801042b0 <wakeup>
  }
  release(&log.lock);
8010309d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801030a4:	e8 e7 16 00 00       	call   80104790 <release>
801030a9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
801030ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030af:	5b                   	pop    %ebx
801030b0:	5e                   	pop    %esi
801030b1:	5f                   	pop    %edi
801030b2:	5d                   	pop    %ebp
801030b3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
801030b4:	83 ec 0c             	sub    $0xc,%esp
801030b7:	68 84 77 10 80       	push   $0x80107784
801030bc:	e8 af d2 ff ff       	call   80100370 <panic>
801030c1:	eb 0d                	jmp    801030d0 <log_write>
801030c3:	90                   	nop
801030c4:	90                   	nop
801030c5:	90                   	nop
801030c6:	90                   	nop
801030c7:	90                   	nop
801030c8:	90                   	nop
801030c9:	90                   	nop
801030ca:	90                   	nop
801030cb:	90                   	nop
801030cc:	90                   	nop
801030cd:	90                   	nop
801030ce:	90                   	nop
801030cf:	90                   	nop

801030d0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	53                   	push   %ebx
801030d4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030d7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030e0:	83 fa 1d             	cmp    $0x1d,%edx
801030e3:	0f 8f 97 00 00 00    	jg     80103180 <log_write+0xb0>
801030e9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
801030ee:	83 e8 01             	sub    $0x1,%eax
801030f1:	39 c2                	cmp    %eax,%edx
801030f3:	0f 8d 87 00 00 00    	jge    80103180 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030f9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
801030fe:	85 c0                	test   %eax,%eax
80103100:	0f 8e 87 00 00 00    	jle    8010318d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103106:	83 ec 0c             	sub    $0xc,%esp
80103109:	68 80 26 11 80       	push   $0x80112680
8010310e:	e8 5d 15 00 00       	call   80104670 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103113:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80103119:	83 c4 10             	add    $0x10,%esp
8010311c:	83 fa 00             	cmp    $0x0,%edx
8010311f:	7e 50                	jle    80103171 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103121:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103124:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103126:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
8010312c:	75 0b                	jne    80103139 <log_write+0x69>
8010312e:	eb 38                	jmp    80103168 <log_write+0x98>
80103130:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80103137:	74 2f                	je     80103168 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103139:	83 c0 01             	add    $0x1,%eax
8010313c:	39 d0                	cmp    %edx,%eax
8010313e:	75 f0                	jne    80103130 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103140:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103147:	83 c2 01             	add    $0x1,%edx
8010314a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80103150:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103153:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
8010315a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010315d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010315e:	e9 2d 16 00 00       	jmp    80104790 <release>
80103163:	90                   	nop
80103164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103168:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
8010316f:	eb df                	jmp    80103150 <log_write+0x80>
80103171:	8b 43 08             	mov    0x8(%ebx),%eax
80103174:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80103179:	75 d5                	jne    80103150 <log_write+0x80>
8010317b:	eb ca                	jmp    80103147 <log_write+0x77>
8010317d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103180:	83 ec 0c             	sub    $0xc,%esp
80103183:	68 93 77 10 80       	push   $0x80107793
80103188:	e8 e3 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010318d:	83 ec 0c             	sub    $0xc,%esp
80103190:	68 a9 77 10 80       	push   $0x801077a9
80103195:	e8 d6 d1 ff ff       	call   80100370 <panic>
8010319a:	66 90                	xchg   %ax,%ax
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <mpmain>:
  mpmain();
}

// Common CPU setup code.
static void
mpmain(void) {
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	53                   	push   %ebx
801031a4:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031a7:	e8 54 09 00 00       	call   80103b00 <cpuid>
801031ac:	89 c3                	mov    %eax,%ebx
801031ae:	e8 4d 09 00 00       	call   80103b00 <cpuid>
801031b3:	83 ec 04             	sub    $0x4,%esp
801031b6:	53                   	push   %ebx
801031b7:	50                   	push   %eax
801031b8:	68 c4 77 10 80       	push   $0x801077c4
801031bd:	e8 9e d4 ff ff       	call   80100660 <cprintf>
    idtinit();       // load idt register
801031c2:	e8 f9 28 00 00       	call   80105ac0 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031c7:	e8 b4 08 00 00       	call   80103a80 <mycpu>
801031cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031ce:	b8 01 00 00 00       	mov    $0x1,%eax
801031d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
801031da:	e8 31 0c 00 00       	call   80103e10 <scheduler>
801031df:	90                   	nop

801031e0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031e6:	e8 f5 39 00 00       	call   80106be0 <switchkvm>
  seginit();
801031eb:	e8 f0 38 00 00       	call   80106ae0 <seginit>
  lapicinit();
801031f0:	e8 9b f7 ff ff       	call   80102990 <lapicinit>
  mpmain();
801031f5:	e8 a6 ff ff ff       	call   801031a0 <mpmain>
801031fa:	66 90                	xchg   %ax,%ax
801031fc:	66 90                	xchg   %ax,%ax
801031fe:	66 90                	xchg   %ax,%ax

80103200 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103200:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103204:	83 e4 f0             	and    $0xfffffff0,%esp
80103207:	ff 71 fc             	pushl  -0x4(%ecx)
8010320a:	55                   	push   %ebp
8010320b:	89 e5                	mov    %esp,%ebp
8010320d:	53                   	push   %ebx
8010320e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010320f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103214:	83 ec 08             	sub    $0x8,%esp
80103217:	68 00 00 40 80       	push   $0x80400000
8010321c:	68 a8 65 11 80       	push   $0x801165a8
80103221:	e8 3a f5 ff ff       	call   80102760 <kinit1>
  kvmalloc();      // kernel page table
80103226:	e8 55 3e 00 00       	call   80107080 <kvmalloc>
  mpinit();        // detect other processors
8010322b:	e8 70 01 00 00       	call   801033a0 <mpinit>
  lapicinit();     // interrupt controller
80103230:	e8 5b f7 ff ff       	call   80102990 <lapicinit>
  seginit();       // segment descriptors
80103235:	e8 a6 38 00 00       	call   80106ae0 <seginit>
  picinit();       // disable pic
8010323a:	e8 31 03 00 00       	call   80103570 <picinit>
  ioapicinit();    // another interrupt controller
8010323f:	e8 4c f3 ff ff       	call   80102590 <ioapicinit>
  consoleinit();   // console hardware
80103244:	e8 57 d7 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103249:	e8 62 2b 00 00       	call   80105db0 <uartinit>
  pinit();         // process table
8010324e:	e8 0d 08 00 00       	call   80103a60 <pinit>
  tvinit();        // trap vectors
80103253:	e8 c8 27 00 00       	call   80105a20 <tvinit>
  binit();         // buffer cache
80103258:	e8 e3 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010325d:	e8 ee da ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80103262:	e8 09 f1 ff ff       	call   80102370 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103267:	83 c4 0c             	add    $0xc,%esp
8010326a:	68 8a 00 00 00       	push   $0x8a
8010326f:	68 8c a4 10 80       	push   $0x8010a48c
80103274:	68 00 70 00 80       	push   $0x80007000
80103279:	e8 12 16 00 00       	call   80104890 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010327e:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103285:	00 00 00 
80103288:	83 c4 10             	add    $0x10,%esp
8010328b:	05 80 27 11 80       	add    $0x80112780,%eax
80103290:	39 d8                	cmp    %ebx,%eax
80103292:	76 6f                	jbe    80103303 <main+0x103>
80103294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103298:	e8 e3 07 00 00       	call   80103a80 <mycpu>
8010329d:	39 d8                	cmp    %ebx,%eax
8010329f:	74 49                	je     801032ea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032a1:	e8 8a f5 ff ff       	call   80102830 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032a6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801032ab:	c7 05 f8 6f 00 80 e0 	movl   $0x801031e0,0x80006ff8
801032b2:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032b5:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801032bc:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801032bf:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032c4:	0f b6 03             	movzbl (%ebx),%eax
801032c7:	83 ec 08             	sub    $0x8,%esp
801032ca:	68 00 70 00 00       	push   $0x7000
801032cf:	50                   	push   %eax
801032d0:	e8 0b f8 ff ff       	call   80102ae0 <lapicstartap>
801032d5:	83 c4 10             	add    $0x10,%esp
801032d8:	90                   	nop
801032d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032e6:	85 c0                	test   %eax,%eax
801032e8:	74 f6                	je     801032e0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801032ea:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801032f1:	00 00 00 
801032f4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032fa:	05 80 27 11 80       	add    $0x80112780,%eax
801032ff:	39 c3                	cmp    %eax,%ebx
80103301:	72 95                	jb     80103298 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103303:	83 ec 08             	sub    $0x8,%esp
80103306:	68 00 00 00 8e       	push   $0x8e000000
8010330b:	68 00 00 40 80       	push   $0x80400000
80103310:	e8 bb f4 ff ff       	call   801027d0 <kinit2>
  userinit();      // first user process
80103315:	e8 36 08 00 00       	call   80103b50 <userinit>
  mpmain();        // finish this processor's setup
8010331a:	e8 81 fe ff ff       	call   801031a0 <mpmain>
8010331f:	90                   	nop

80103320 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103325:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010332b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010332c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010332f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103332:	39 de                	cmp    %ebx,%esi
80103334:	73 48                	jae    8010337e <mpsearch1+0x5e>
80103336:	8d 76 00             	lea    0x0(%esi),%esi
80103339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103340:	83 ec 04             	sub    $0x4,%esp
80103343:	8d 7e 10             	lea    0x10(%esi),%edi
80103346:	6a 04                	push   $0x4
80103348:	68 d8 77 10 80       	push   $0x801077d8
8010334d:	56                   	push   %esi
8010334e:	e8 dd 14 00 00       	call   80104830 <memcmp>
80103353:	83 c4 10             	add    $0x10,%esp
80103356:	85 c0                	test   %eax,%eax
80103358:	75 1e                	jne    80103378 <mpsearch1+0x58>
8010335a:	8d 7e 10             	lea    0x10(%esi),%edi
8010335d:	89 f2                	mov    %esi,%edx
8010335f:	31 c9                	xor    %ecx,%ecx
80103361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103368:	0f b6 02             	movzbl (%edx),%eax
8010336b:	83 c2 01             	add    $0x1,%edx
8010336e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103370:	39 fa                	cmp    %edi,%edx
80103372:	75 f4                	jne    80103368 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103374:	84 c9                	test   %cl,%cl
80103376:	74 10                	je     80103388 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103378:	39 fb                	cmp    %edi,%ebx
8010337a:	89 fe                	mov    %edi,%esi
8010337c:	77 c2                	ja     80103340 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010337e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103381:	31 c0                	xor    %eax,%eax
}
80103383:	5b                   	pop    %ebx
80103384:	5e                   	pop    %esi
80103385:	5f                   	pop    %edi
80103386:	5d                   	pop    %ebp
80103387:	c3                   	ret    
80103388:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010338b:	89 f0                	mov    %esi,%eax
8010338d:	5b                   	pop    %ebx
8010338e:	5e                   	pop    %esi
8010338f:	5f                   	pop    %edi
80103390:	5d                   	pop    %ebp
80103391:	c3                   	ret    
80103392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
801033a5:	53                   	push   %ebx
801033a6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033b7:	c1 e0 08             	shl    $0x8,%eax
801033ba:	09 d0                	or     %edx,%eax
801033bc:	c1 e0 04             	shl    $0x4,%eax
801033bf:	85 c0                	test   %eax,%eax
801033c1:	75 1b                	jne    801033de <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801033c3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033ca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033d1:	c1 e0 08             	shl    $0x8,%eax
801033d4:	09 d0                	or     %edx,%eax
801033d6:	c1 e0 0a             	shl    $0xa,%eax
801033d9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801033de:	ba 00 04 00 00       	mov    $0x400,%edx
801033e3:	e8 38 ff ff ff       	call   80103320 <mpsearch1>
801033e8:	85 c0                	test   %eax,%eax
801033ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801033ed:	0f 84 37 01 00 00    	je     8010352a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801033f6:	8b 58 04             	mov    0x4(%eax),%ebx
801033f9:	85 db                	test   %ebx,%ebx
801033fb:	0f 84 43 01 00 00    	je     80103544 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103401:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103407:	83 ec 04             	sub    $0x4,%esp
8010340a:	6a 04                	push   $0x4
8010340c:	68 dd 77 10 80       	push   $0x801077dd
80103411:	56                   	push   %esi
80103412:	e8 19 14 00 00       	call   80104830 <memcmp>
80103417:	83 c4 10             	add    $0x10,%esp
8010341a:	85 c0                	test   %eax,%eax
8010341c:	0f 85 22 01 00 00    	jne    80103544 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103422:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103429:	3c 01                	cmp    $0x1,%al
8010342b:	74 08                	je     80103435 <mpinit+0x95>
8010342d:	3c 04                	cmp    $0x4,%al
8010342f:	0f 85 0f 01 00 00    	jne    80103544 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103435:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010343c:	85 ff                	test   %edi,%edi
8010343e:	74 21                	je     80103461 <mpinit+0xc1>
80103440:	31 d2                	xor    %edx,%edx
80103442:	31 c0                	xor    %eax,%eax
80103444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103448:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010344f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103450:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103453:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103455:	39 c7                	cmp    %eax,%edi
80103457:	75 ef                	jne    80103448 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103459:	84 d2                	test   %dl,%dl
8010345b:	0f 85 e3 00 00 00    	jne    80103544 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103461:	85 f6                	test   %esi,%esi
80103463:	0f 84 db 00 00 00    	je     80103544 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103469:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010346f:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103474:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010347b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103481:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103486:	01 d6                	add    %edx,%esi
80103488:	90                   	nop
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103490:	39 c6                	cmp    %eax,%esi
80103492:	76 23                	jbe    801034b7 <mpinit+0x117>
80103494:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103497:	80 fa 04             	cmp    $0x4,%dl
8010349a:	0f 87 c0 00 00 00    	ja     80103560 <mpinit+0x1c0>
801034a0:	ff 24 95 1c 78 10 80 	jmp    *-0x7fef87e4(,%edx,4)
801034a7:	89 f6                	mov    %esi,%esi
801034a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034b0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034b3:	39 c6                	cmp    %eax,%esi
801034b5:	77 dd                	ja     80103494 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034b7:	85 db                	test   %ebx,%ebx
801034b9:	0f 84 92 00 00 00    	je     80103551 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034c2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801034c6:	74 15                	je     801034dd <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034c8:	ba 22 00 00 00       	mov    $0x22,%edx
801034cd:	b8 70 00 00 00       	mov    $0x70,%eax
801034d2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034d3:	ba 23 00 00 00       	mov    $0x23,%edx
801034d8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d9:	83 c8 01             	or     $0x1,%eax
801034dc:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801034dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034e0:	5b                   	pop    %ebx
801034e1:	5e                   	pop    %esi
801034e2:	5f                   	pop    %edi
801034e3:	5d                   	pop    %ebp
801034e4:	c3                   	ret    
801034e5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801034e8:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
801034ee:	83 f9 07             	cmp    $0x7,%ecx
801034f1:	7f 19                	jg     8010350c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034f3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801034f7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801034fd:	83 c1 01             	add    $0x1,%ecx
80103500:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103506:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010350c:	83 c0 14             	add    $0x14,%eax
      continue;
8010350f:	e9 7c ff ff ff       	jmp    80103490 <mpinit+0xf0>
80103514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103518:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010351c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010351f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103525:	e9 66 ff ff ff       	jmp    80103490 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010352a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010352f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103534:	e8 e7 fd ff ff       	call   80103320 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103539:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010353b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010353e:	0f 85 af fe ff ff    	jne    801033f3 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103544:	83 ec 0c             	sub    $0xc,%esp
80103547:	68 e2 77 10 80       	push   $0x801077e2
8010354c:	e8 1f ce ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103551:	83 ec 0c             	sub    $0xc,%esp
80103554:	68 fc 77 10 80       	push   $0x801077fc
80103559:	e8 12 ce ff ff       	call   80100370 <panic>
8010355e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103560:	31 db                	xor    %ebx,%ebx
80103562:	e9 30 ff ff ff       	jmp    80103497 <mpinit+0xf7>
80103567:	66 90                	xchg   %ax,%ax
80103569:	66 90                	xchg   %ax,%ax
8010356b:	66 90                	xchg   %ax,%ax
8010356d:	66 90                	xchg   %ax,%ax
8010356f:	90                   	nop

80103570 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103570:	55                   	push   %ebp
80103571:	ba 21 00 00 00       	mov    $0x21,%edx
80103576:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010357b:	89 e5                	mov    %esp,%ebp
8010357d:	ee                   	out    %al,(%dx)
8010357e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103583:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103584:	5d                   	pop    %ebp
80103585:	c3                   	ret    
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
80103599:	8b 75 08             	mov    0x8(%ebp),%esi
8010359c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010359f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801035a5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035ab:	e8 c0 d7 ff ff       	call   80100d70 <filealloc>
801035b0:	85 c0                	test   %eax,%eax
801035b2:	89 06                	mov    %eax,(%esi)
801035b4:	0f 84 a8 00 00 00    	je     80103662 <pipealloc+0xd2>
801035ba:	e8 b1 d7 ff ff       	call   80100d70 <filealloc>
801035bf:	85 c0                	test   %eax,%eax
801035c1:	89 03                	mov    %eax,(%ebx)
801035c3:	0f 84 87 00 00 00    	je     80103650 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035c9:	e8 62 f2 ff ff       	call   80102830 <kalloc>
801035ce:	85 c0                	test   %eax,%eax
801035d0:	89 c7                	mov    %eax,%edi
801035d2:	0f 84 b0 00 00 00    	je     80103688 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035d8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801035db:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035e2:	00 00 00 
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
80103603:	68 30 78 10 80       	push   $0x80107830
80103608:	50                   	push   %eax
80103609:	e8 62 0f 00 00       	call   80104570 <initlock>
  (*f0)->type = FD_PIPE;
8010360e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103610:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103613:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103619:	8b 06                	mov    (%esi),%eax
8010361b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010361f:	8b 06                	mov    (%esi),%eax
80103621:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103625:	8b 06                	mov    (%esi),%eax
80103627:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010362a:	8b 03                	mov    (%ebx),%eax
8010362c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103632:	8b 03                	mov    (%ebx),%eax
80103634:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103638:	8b 03                	mov    (%ebx),%eax
8010363a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010363e:	8b 03                	mov    (%ebx),%eax
80103640:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103643:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103646:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103648:	5b                   	pop    %ebx
80103649:	5e                   	pop    %esi
8010364a:	5f                   	pop    %edi
8010364b:	5d                   	pop    %ebp
8010364c:	c3                   	ret    
8010364d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103650:	8b 06                	mov    (%esi),%eax
80103652:	85 c0                	test   %eax,%eax
80103654:	74 1e                	je     80103674 <pipealloc+0xe4>
    fileclose(*f0);
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	50                   	push   %eax
8010365a:	e8 d1 d7 ff ff       	call   80100e30 <fileclose>
8010365f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103662:	8b 03                	mov    (%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	74 0c                	je     80103674 <pipealloc+0xe4>
    fileclose(*f1);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	50                   	push   %eax
8010366c:	e8 bf d7 ff ff       	call   80100e30 <fileclose>
80103671:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103674:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103688:	8b 06                	mov    (%esi),%eax
8010368a:	85 c0                	test   %eax,%eax
8010368c:	75 c8                	jne    80103656 <pipealloc+0xc6>
8010368e:	eb d2                	jmp    80103662 <pipealloc+0xd2>

80103690 <pipeclose>:
  return -1;
}

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
8010369f:	e8 cc 0f 00 00       	call   80104670 <acquire>
  if(writable){
801036a4:	83 c4 10             	add    $0x10,%esp
801036a7:	85 f6                	test   %esi,%esi
801036a9:	74 45                	je     801036f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801036ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801036b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036bb:	00 00 00 
    wakeup(&p->nread);
801036be:	50                   	push   %eax
801036bf:	e8 ec 0b 00 00       	call   801042b0 <wakeup>
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
801036d9:	74 35                	je     80103710 <pipeclose+0x80>
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
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036e4:	e9 a7 10 00 00       	jmp    80104790 <release>
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801036f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801036f6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801036f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103700:	00 00 00 
    wakeup(&p->nwrite);
80103703:	50                   	push   %eax
80103704:	e8 a7 0b 00 00       	call   801042b0 <wakeup>
80103709:	83 c4 10             	add    $0x10,%esp
8010370c:	eb b9                	jmp    801036c7 <pipeclose+0x37>
8010370e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	53                   	push   %ebx
80103714:	e8 77 10 00 00       	call   80104790 <release>
    kfree((char*)p);
80103719:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010371c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010371f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103722:	5b                   	pop    %ebx
80103723:	5e                   	pop    %esi
80103724:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103725:	e9 56 ef ff ff       	jmp    80102680 <kfree>
8010372a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103730 <pipewrite>:
}

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
8010373d:	e8 2e 0f 00 00       	call   80104670 <acquire>
  for(i = 0; i < n; i++){
80103742:	8b 45 10             	mov    0x10(%ebp),%eax
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	85 c0                	test   %eax,%eax
8010374a:	0f 8e b9 00 00 00    	jle    80103809 <pipewrite+0xd9>
80103750:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103753:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103759:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010375f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103765:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103768:	03 4d 10             	add    0x10(%ebp),%ecx
8010376b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010376e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103774:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010377a:	39 d0                	cmp    %edx,%eax
8010377c:	74 38                	je     801037b6 <pipewrite+0x86>
8010377e:	eb 59                	jmp    801037d9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103780:	e8 9b 03 00 00       	call   80103b20 <myproc>
80103785:	8b 48 24             	mov    0x24(%eax),%ecx
80103788:	85 c9                	test   %ecx,%ecx
8010378a:	75 34                	jne    801037c0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010378c:	83 ec 0c             	sub    $0xc,%esp
8010378f:	57                   	push   %edi
80103790:	e8 1b 0b 00 00       	call   801042b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103795:	58                   	pop    %eax
80103796:	5a                   	pop    %edx
80103797:	53                   	push   %ebx
80103798:	56                   	push   %esi
80103799:	e8 62 09 00 00       	call   80104100 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010379e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037a4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037aa:	83 c4 10             	add    $0x10,%esp
801037ad:	05 00 02 00 00       	add    $0x200,%eax
801037b2:	39 c2                	cmp    %eax,%edx
801037b4:	75 2a                	jne    801037e0 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801037b6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037bc:	85 c0                	test   %eax,%eax
801037be:	75 c0                	jne    80103780 <pipewrite+0x50>
        release(&p->lock);
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	53                   	push   %ebx
801037c4:	e8 c7 0f 00 00       	call   80104790 <release>
        return -1;
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d4:	5b                   	pop    %ebx
801037d5:	5e                   	pop    %esi
801037d6:	5f                   	pop    %edi
801037d7:	5d                   	pop    %ebp
801037d8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037d9:	89 c2                	mov    %eax,%edx
801037db:	90                   	nop
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801037e3:	8d 42 01             	lea    0x1(%edx),%eax
801037e6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801037ea:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037f0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801037f6:	0f b6 09             	movzbl (%ecx),%ecx
801037f9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801037fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103800:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103803:	0f 85 65 ff ff ff    	jne    8010376e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103809:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010380f:	83 ec 0c             	sub    $0xc,%esp
80103812:	50                   	push   %eax
80103813:	e8 98 0a 00 00       	call   801042b0 <wakeup>
  release(&p->lock);
80103818:	89 1c 24             	mov    %ebx,(%esp)
8010381b:	e8 70 0f 00 00       	call   80104790 <release>
  return n;
80103820:	83 c4 10             	add    $0x10,%esp
80103823:	8b 45 10             	mov    0x10(%ebp),%eax
80103826:	eb a9                	jmp    801037d1 <pipewrite+0xa1>
80103828:	90                   	nop
80103829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103830 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	57                   	push   %edi
80103834:	56                   	push   %esi
80103835:	53                   	push   %ebx
80103836:	83 ec 18             	sub    $0x18,%esp
80103839:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010383c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010383f:	53                   	push   %ebx
80103840:	e8 2b 0e 00 00       	call   80104670 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103845:	83 c4 10             	add    $0x10,%esp
80103848:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010384e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103854:	75 6a                	jne    801038c0 <piperead+0x90>
80103856:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010385c:	85 f6                	test   %esi,%esi
8010385e:	0f 84 cc 00 00 00    	je     80103930 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103864:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010386a:	eb 2d                	jmp    80103899 <piperead+0x69>
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103870:	83 ec 08             	sub    $0x8,%esp
80103873:	53                   	push   %ebx
80103874:	56                   	push   %esi
80103875:	e8 86 08 00 00       	call   80104100 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010387a:	83 c4 10             	add    $0x10,%esp
8010387d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103883:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103889:	75 35                	jne    801038c0 <piperead+0x90>
8010388b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103891:	85 d2                	test   %edx,%edx
80103893:	0f 84 97 00 00 00    	je     80103930 <piperead+0x100>
    if(myproc()->killed){
80103899:	e8 82 02 00 00       	call   80103b20 <myproc>
8010389e:	8b 48 24             	mov    0x24(%eax),%ecx
801038a1:	85 c9                	test   %ecx,%ecx
801038a3:	74 cb                	je     80103870 <piperead+0x40>
      release(&p->lock);
801038a5:	83 ec 0c             	sub    $0xc,%esp
801038a8:	53                   	push   %ebx
801038a9:	e8 e2 0e 00 00       	call   80104790 <release>
      return -1;
801038ae:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038b1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801038b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038b9:	5b                   	pop    %ebx
801038ba:	5e                   	pop    %esi
801038bb:	5f                   	pop    %edi
801038bc:	5d                   	pop    %ebp
801038bd:	c3                   	ret    
801038be:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038c0:	8b 45 10             	mov    0x10(%ebp),%eax
801038c3:	85 c0                	test   %eax,%eax
801038c5:	7e 69                	jle    80103930 <piperead+0x100>
    if(p->nread == p->nwrite)
801038c7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038cd:	31 c9                	xor    %ecx,%ecx
801038cf:	eb 15                	jmp    801038e6 <piperead+0xb6>
801038d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038d8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038de:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801038e4:	74 5a                	je     80103940 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038e6:	8d 70 01             	lea    0x1(%eax),%esi
801038e9:	25 ff 01 00 00       	and    $0x1ff,%eax
801038ee:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801038f4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801038f9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038fc:	83 c1 01             	add    $0x1,%ecx
801038ff:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103902:	75 d4                	jne    801038d8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103904:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010390a:	83 ec 0c             	sub    $0xc,%esp
8010390d:	50                   	push   %eax
8010390e:	e8 9d 09 00 00       	call   801042b0 <wakeup>
  release(&p->lock);
80103913:	89 1c 24             	mov    %ebx,(%esp)
80103916:	e8 75 0e 00 00       	call   80104790 <release>
  return i;
8010391b:	8b 45 10             	mov    0x10(%ebp),%eax
8010391e:	83 c4 10             	add    $0x10,%esp
}
80103921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103924:	5b                   	pop    %ebx
80103925:	5e                   	pop    %esi
80103926:	5f                   	pop    %edi
80103927:	5d                   	pop    %ebp
80103928:	c3                   	ret    
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103930:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103937:	eb cb                	jmp    80103904 <piperead+0xd4>
80103939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103940:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103943:	eb bf                	jmp    80103904 <piperead+0xd4>
80103945:	66 90                	xchg   %ax,%ax
80103947:	66 90                	xchg   %ax,%ax
80103949:	66 90                	xchg   %ax,%ax
8010394b:	66 90                	xchg   %ax,%ax
8010394d:	66 90                	xchg   %ax,%ax
8010394f:	90                   	nop

80103950 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103954:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103959:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010395c:	68 20 3d 11 80       	push   $0x80113d20
80103961:	e8 0a 0d 00 00       	call   80104670 <acquire>
80103966:	83 c4 10             	add    $0x10,%esp
80103969:	eb 10                	jmp    8010397b <allocproc+0x2b>
8010396b:	90                   	nop
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103970:	83 eb 80             	sub    $0xffffff80,%ebx
80103973:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
80103979:	74 75                	je     801039f0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010397b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010397e:	85 c0                	test   %eax,%eax
80103980:	75 ee                	jne    80103970 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103982:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103987:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010398a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103991:	68 20 3d 11 80       	push   $0x80113d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103996:	8d 50 01             	lea    0x1(%eax),%edx
80103999:	89 43 10             	mov    %eax,0x10(%ebx)
8010399c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
801039a2:	e8 e9 0d 00 00       	call   80104790 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039a7:	e8 84 ee ff ff       	call   80102830 <kalloc>
801039ac:	83 c4 10             	add    $0x10,%esp
801039af:	85 c0                	test   %eax,%eax
801039b1:	89 43 08             	mov    %eax,0x8(%ebx)
801039b4:	74 51                	je     80103a07 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039b6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039bc:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801039bf:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039c4:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801039c7:	c7 40 14 12 5a 10 80 	movl   $0x80105a12,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039ce:	6a 14                	push   $0x14
801039d0:	6a 00                	push   $0x0
801039d2:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801039d3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039d6:	e8 05 0e 00 00       	call   801047e0 <memset>
  p->context->eip = (uint)forkret;
801039db:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801039de:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
801039e1:	c7 40 10 10 3a 10 80 	movl   $0x80103a10,0x10(%eax)

  return p;
801039e8:	89 d8                	mov    %ebx,%eax
}
801039ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039ed:	c9                   	leave  
801039ee:	c3                   	ret    
801039ef:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801039f0:	83 ec 0c             	sub    $0xc,%esp
801039f3:	68 20 3d 11 80       	push   $0x80113d20
801039f8:	e8 93 0d 00 00       	call   80104790 <release>
  return 0;
801039fd:	83 c4 10             	add    $0x10,%esp
80103a00:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103a02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a05:	c9                   	leave  
80103a06:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103a07:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a0e:	eb da                	jmp    801039ea <allocproc+0x9a>

80103a10 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a16:	68 20 3d 11 80       	push   $0x80113d20
80103a1b:	e8 70 0d 00 00       	call   80104790 <release>

  if (first) {
80103a20:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	85 c0                	test   %eax,%eax
80103a2a:	75 04                	jne    80103a30 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a2c:	c9                   	leave  
80103a2d:	c3                   	ret    
80103a2e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103a30:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103a33:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103a3a:	00 00 00 
    iinit(ROOTDEV);
80103a3d:	6a 01                	push   $0x1
80103a3f:	e8 2c da ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103a44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a4b:	e8 00 f4 ff ff       	call   80102e50 <initlog>
80103a50:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a53:	c9                   	leave  
80103a54:	c3                   	ret    
80103a55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a60 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a66:	68 35 78 10 80       	push   $0x80107835
80103a6b:	68 20 3d 11 80       	push   $0x80113d20
80103a70:	e8 fb 0a 00 00       	call   80104570 <initlock>
}
80103a75:	83 c4 10             	add    $0x10,%esp
80103a78:	c9                   	leave  
80103a79:	c3                   	ret    
80103a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a80 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	56                   	push   %esi
80103a84:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a85:	9c                   	pushf  
80103a86:	58                   	pop    %eax
  int apicid, i;

  if(readeflags()&FL_IF)
80103a87:	f6 c4 02             	test   $0x2,%ah
80103a8a:	75 5b                	jne    80103ae7 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
80103a8c:	e8 ff ef ff ff       	call   80102a90 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103a91:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103a97:	85 f6                	test   %esi,%esi
80103a99:	7e 3f                	jle    80103ada <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103a9b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103aa2:	39 d0                	cmp    %edx,%eax
80103aa4:	74 30                	je     80103ad6 <mycpu+0x56>
80103aa6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
80103aab:	31 d2                	xor    %edx,%edx
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103ab0:	83 c2 01             	add    $0x1,%edx
80103ab3:	39 f2                	cmp    %esi,%edx
80103ab5:	74 23                	je     80103ada <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103ab7:	0f b6 19             	movzbl (%ecx),%ebx
80103aba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103ac0:	39 d8                	cmp    %ebx,%eax
80103ac2:	75 ec                	jne    80103ab0 <mycpu+0x30>
      return &cpus[i];
80103ac4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103aca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103acd:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103ace:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103ad3:	5e                   	pop    %esi
80103ad4:	5d                   	pop    %ebp
80103ad5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103ad6:	31 d2                	xor    %edx,%edx
80103ad8:	eb ea                	jmp    80103ac4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	68 3c 78 10 80       	push   $0x8010783c
80103ae2:	e8 89 c8 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;

  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103ae7:	83 ec 0c             	sub    $0xc,%esp
80103aea:	68 18 79 10 80       	push   $0x80107918
80103aef:	e8 7c c8 ff ff       	call   80100370 <panic>
80103af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b00 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b06:	e8 75 ff ff ff       	call   80103a80 <mycpu>
80103b0b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103b10:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103b11:	c1 f8 04             	sar    $0x4,%eax
80103b14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b1a:	c3                   	ret    
80103b1b:	90                   	nop
80103b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b20 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b27:	e8 04 0b 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103b2c:	e8 4f ff ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103b31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b37:	e8 e4 0b 00 00       	call   80104720 <popcli>
  return p;
}
80103b3c:	83 c4 04             	add    $0x4,%esp
80103b3f:	89 d8                	mov    %ebx,%eax
80103b41:	5b                   	pop    %ebx
80103b42:	5d                   	pop    %ebp
80103b43:	c3                   	ret    
80103b44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b50 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	53                   	push   %ebx
80103b54:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103b57:	e8 f4 fd ff ff       	call   80103950 <allocproc>
80103b5c:	89 c3                	mov    %eax,%ebx

  initproc = p;
80103b5e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103b63:	e8 98 34 00 00       	call   80107000 <setupkvm>
80103b68:	85 c0                	test   %eax,%eax
80103b6a:	89 43 04             	mov    %eax,0x4(%ebx)
80103b6d:	0f 84 bd 00 00 00    	je     80103c30 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b73:	83 ec 04             	sub    $0x4,%esp
80103b76:	68 2c 00 00 00       	push   $0x2c
80103b7b:	68 60 a4 10 80       	push   $0x8010a460
80103b80:	50                   	push   %eax
80103b81:	e8 8a 31 00 00       	call   80106d10 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103b86:	83 c4 0c             	add    $0xc,%esp

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103b89:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b8f:	6a 4c                	push   $0x4c
80103b91:	6a 00                	push   $0x0
80103b93:	ff 73 18             	pushl  0x18(%ebx)
80103b96:	e8 45 0c 00 00       	call   801047e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b9b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b9e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ba3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ba8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103baf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bb6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bbd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bc1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bc8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bcc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bcf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103bd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103be0:	8b 43 18             	mov    0x18(%ebx),%eax
80103be3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bea:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bed:	6a 10                	push   $0x10
80103bef:	68 65 78 10 80       	push   $0x80107865
80103bf4:	50                   	push   %eax
80103bf5:	e8 e6 0d 00 00       	call   801049e0 <safestrcpy>
  p->cwd = namei("/");
80103bfa:	c7 04 24 6e 78 10 80 	movl   $0x8010786e,(%esp)
80103c01:	e8 ba e2 ff ff       	call   80101ec0 <namei>
80103c06:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103c09:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c10:	e8 5b 0a 00 00       	call   80104670 <acquire>

  p->state = RUNNABLE;
80103c15:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103c1c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c23:	e8 68 0b 00 00       	call   80104790 <release>
}
80103c28:	83 c4 10             	add    $0x10,%esp
80103c2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c2e:	c9                   	leave  
80103c2f:	c3                   	ret    

  p = allocproc();

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	68 4c 78 10 80       	push   $0x8010784c
80103c38:	e8 33 c7 ff ff       	call   80100370 <panic>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi

80103c40 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
80103c45:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c48:	e8 e3 09 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103c4d:	e8 2e fe ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103c52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c58:	e8 c3 0a 00 00       	call   80104720 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103c5d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103c60:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c62:	7e 34                	jle    80103c98 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c64:	83 ec 04             	sub    $0x4,%esp
80103c67:	01 c6                	add    %eax,%esi
80103c69:	56                   	push   %esi
80103c6a:	50                   	push   %eax
80103c6b:	ff 73 04             	pushl  0x4(%ebx)
80103c6e:	e8 dd 31 00 00       	call   80106e50 <allocuvm>
80103c73:	83 c4 10             	add    $0x10,%esp
80103c76:	85 c0                	test   %eax,%eax
80103c78:	74 36                	je     80103cb0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103c7a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103c7d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c7f:	53                   	push   %ebx
80103c80:	e8 7b 2f 00 00       	call   80106c00 <switchuvm>
  return 0;
80103c85:	83 c4 10             	add    $0x10,%esp
80103c88:	31 c0                	xor    %eax,%eax
}
80103c8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c8d:	5b                   	pop    %ebx
80103c8e:	5e                   	pop    %esi
80103c8f:	5d                   	pop    %ebp
80103c90:	c3                   	ret    
80103c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103c98:	74 e0                	je     80103c7a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c9a:	83 ec 04             	sub    $0x4,%esp
80103c9d:	01 c6                	add    %eax,%esi
80103c9f:	56                   	push   %esi
80103ca0:	50                   	push   %eax
80103ca1:	ff 73 04             	pushl  0x4(%ebx)
80103ca4:	e8 a7 32 00 00       	call   80106f50 <deallocuvm>
80103ca9:	83 c4 10             	add    $0x10,%esp
80103cac:	85 c0                	test   %eax,%eax
80103cae:	75 ca                	jne    80103c7a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cb5:	eb d3                	jmp    80103c8a <growproc+0x4a>
80103cb7:	89 f6                	mov    %esi,%esi
80103cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cc0 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	57                   	push   %edi
80103cc4:	56                   	push   %esi
80103cc5:	53                   	push   %ebx
80103cc6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103cc9:	e8 62 09 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103cce:	e8 ad fd ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103cd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd9:	e8 42 0a 00 00       	call   80104720 <popcli>
fork(void) {
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();
    // Allocate process.
    if ((np = allocproc()) == 0) {
80103cde:	e8 6d fc ff ff       	call   80103950 <allocproc>
80103ce3:	85 c0                	test   %eax,%eax
80103ce5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ce8:	0f 84 f3 00 00 00    	je     80103de1 <fork+0x121>
        return -1;
    }


    if (firstRun)
80103cee:	8b 0d 08 a0 10 80    	mov    0x8010a008,%ecx
80103cf4:	85 c9                	test   %ecx,%ecx
80103cf6:	0f 85 d4 00 00 00    	jne    80103dd0 <fork+0x110>
        createSwapFile(curproc);

    createSwapFile(np);
80103cfc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103cff:	83 ec 0c             	sub    $0xc,%esp
80103d02:	57                   	push   %edi
80103d03:	e8 98 e4 ff ff       	call   801021a0 <createSwapFile>

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103d08:	58                   	pop    %eax
80103d09:	5a                   	pop    %edx
80103d0a:	ff 33                	pushl  (%ebx)
80103d0c:	ff 73 04             	pushl  0x4(%ebx)
80103d0f:	e8 bc 33 00 00       	call   801070d0 <copyuvm>
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	85 c0                	test   %eax,%eax
80103d19:	89 47 04             	mov    %eax,0x4(%edi)
80103d1c:	0f 84 c6 00 00 00    	je     80103de8 <fork+0x128>
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103d22:	8b 03                	mov    (%ebx),%eax
80103d24:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d27:	89 01                	mov    %eax,(%ecx)
    np->parent = curproc;
80103d29:	89 59 14             	mov    %ebx,0x14(%ecx)
    *np->tf = *curproc->tf;
80103d2c:	89 c8                	mov    %ecx,%eax
80103d2e:	8b 79 18             	mov    0x18(%ecx),%edi
80103d31:	8b 73 18             	mov    0x18(%ebx),%esi
80103d34:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103d3b:	31 f6                	xor    %esi,%esi
        }
    }


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80103d3d:	8b 40 18             	mov    0x18(%eax),%eax
80103d40:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103d47:	89 f6                	mov    %esi,%esi
80103d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
80103d50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d54:	85 c0                	test   %eax,%eax
80103d56:	74 13                	je     80103d6b <fork+0xab>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103d58:	83 ec 0c             	sub    $0xc,%esp
80103d5b:	50                   	push   %eax
80103d5c:	e8 7f d0 ff ff       	call   80100de0 <filedup>
80103d61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d64:	83 c4 10             	add    $0x10,%esp
80103d67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103d6b:	83 c6 01             	add    $0x1,%esi
80103d6e:	83 fe 10             	cmp    $0x10,%esi
80103d71:	75 dd                	jne    80103d50 <fork+0x90>
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103d73:	83 ec 0c             	sub    $0xc,%esp
80103d76:	ff 73 68             	pushl  0x68(%ebx)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d79:	83 c3 6c             	add    $0x6c,%ebx
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103d7c:	e8 bf d8 ff ff       	call   80101640 <idup>
80103d81:	8b 7d e4             	mov    -0x1c(%ebp),%edi

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d84:	83 c4 0c             	add    $0xc,%esp
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103d87:	89 47 68             	mov    %eax,0x68(%edi)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d8d:	6a 10                	push   $0x10
80103d8f:	53                   	push   %ebx
80103d90:	50                   	push   %eax
80103d91:	e8 4a 0c 00 00       	call   801049e0 <safestrcpy>

    pid = np->pid;
80103d96:	8b 5f 10             	mov    0x10(%edi),%ebx

    acquire(&ptable.lock);
80103d99:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103da0:	e8 cb 08 00 00       	call   80104670 <acquire>

    np->state = RUNNABLE;
80103da5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

    release(&ptable.lock);
80103dac:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103db3:	e8 d8 09 00 00       	call   80104790 <release>

    firstRun = 0;
80103db8:	c7 05 08 a0 10 80 00 	movl   $0x0,0x8010a008
80103dbf:	00 00 00 
    return pid;
80103dc2:	83 c4 10             	add    $0x10,%esp
80103dc5:	89 d8                	mov    %ebx,%eax
}
80103dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dca:	5b                   	pop    %ebx
80103dcb:	5e                   	pop    %esi
80103dcc:	5f                   	pop    %edi
80103dcd:	5d                   	pop    %ebp
80103dce:	c3                   	ret    
80103dcf:	90                   	nop
        return -1;
    }


    if (firstRun)
        createSwapFile(curproc);
80103dd0:	83 ec 0c             	sub    $0xc,%esp
80103dd3:	53                   	push   %ebx
80103dd4:	e8 c7 e3 ff ff       	call   801021a0 <createSwapFile>
80103dd9:	83 c4 10             	add    $0x10,%esp
80103ddc:	e9 1b ff ff ff       	jmp    80103cfc <fork+0x3c>
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();
    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
80103de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103de6:	eb df                	jmp    80103dc7 <fork+0x107>

    createSwapFile(np);

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
80103de8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103deb:	83 ec 0c             	sub    $0xc,%esp
80103dee:	ff 77 08             	pushl  0x8(%edi)
80103df1:	e8 8a e8 ff ff       	call   80102680 <kfree>
        np->kstack = 0;
80103df6:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
        np->state = UNUSED;
80103dfd:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
        return -1;
80103e04:	83 c4 10             	add    $0x10,%esp
80103e07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e0c:	eb b9                	jmp    80103dc7 <fork+0x107>
80103e0e:	66 90                	xchg   %ax,%ax

80103e10 <scheduler>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 0c             	sub    $0xc,%esp
    struct proc *p;
    struct cpu *c = mycpu();
80103e19:	e8 62 fc ff ff       	call   80103a80 <mycpu>
80103e1e:	8d 78 04             	lea    0x4(%eax),%edi
80103e21:	89 c6                	mov    %eax,%esi
    c->proc = 0;
80103e23:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e2a:	00 00 00 
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103e30:	fb                   	sti    
     for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103e31:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e34:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
     for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80103e39:	68 20 3d 11 80       	push   $0x80113d20
80103e3e:	e8 2d 08 00 00       	call   80104670 <acquire>
80103e43:	83 c4 10             	add    $0x10,%esp
80103e46:	eb 13                	jmp    80103e5b <scheduler+0x4b>
80103e48:	90                   	nop
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e50:	83 eb 80             	sub    $0xffffff80,%ebx
80103e53:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
80103e59:	74 45                	je     80103ea0 <scheduler+0x90>
            if (p->state != RUNNABLE)
80103e5b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e5f:	75 ef                	jne    80103e50 <scheduler+0x40>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
80103e61:	83 ec 0c             	sub    $0xc,%esp
                continue;

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
80103e64:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
80103e6a:	53                   	push   %ebx
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e6b:	83 eb 80             	sub    $0xffffff80,%ebx

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
80103e6e:	e8 8d 2d 00 00       	call   80106c00 <switchuvm>
            p->state = RUNNING;

            swtch(&(c->scheduler), p->context);
80103e73:	58                   	pop    %eax
80103e74:	5a                   	pop    %edx
80103e75:	ff 73 9c             	pushl  -0x64(%ebx)
80103e78:	57                   	push   %edi
            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
            p->state = RUNNING;
80103e79:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)

            swtch(&(c->scheduler), p->context);
80103e80:	e8 b6 0b 00 00       	call   80104a3b <swtch>
            switchkvm();
80103e85:	e8 56 2d 00 00       	call   80106be0 <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80103e8a:	83 c4 10             	add    $0x10,%esp
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e8d:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
            swtch(&(c->scheduler), p->context);
            switchkvm();

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80103e93:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e9a:	00 00 00 
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e9d:	75 bc                	jne    80103e5b <scheduler+0x4b>
80103e9f:	90                   	nop

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&ptable.lock);
80103ea0:	83 ec 0c             	sub    $0xc,%esp
80103ea3:	68 20 3d 11 80       	push   $0x80113d20
80103ea8:	e8 e3 08 00 00       	call   80104790 <release>

    }
80103ead:	83 c4 10             	add    $0x10,%esp
80103eb0:	e9 7b ff ff ff       	jmp    80103e30 <scheduler+0x20>
80103eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ec0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ec5:	e8 66 07 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103eca:	e8 b1 fb ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103ecf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ed5:	e8 46 08 00 00       	call   80104720 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 20 3d 11 80       	push   $0x80113d20
80103ee2:	e8 09 07 00 00       	call   801045f0 <holding>
80103ee7:	83 c4 10             	add    $0x10,%esp
80103eea:	85 c0                	test   %eax,%eax
80103eec:	74 4f                	je     80103f3d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103eee:	e8 8d fb ff ff       	call   80103a80 <mycpu>
80103ef3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103efa:	75 68                	jne    80103f64 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103efc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f00:	74 55                	je     80103f57 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f02:	9c                   	pushf  
80103f03:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103f04:	f6 c4 02             	test   $0x2,%ah
80103f07:	75 41                	jne    80103f4a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103f09:	e8 72 fb ff ff       	call   80103a80 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f0e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103f11:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f17:	e8 64 fb ff ff       	call   80103a80 <mycpu>
80103f1c:	83 ec 08             	sub    $0x8,%esp
80103f1f:	ff 70 04             	pushl  0x4(%eax)
80103f22:	53                   	push   %ebx
80103f23:	e8 13 0b 00 00       	call   80104a3b <swtch>
  mycpu()->intena = intena;
80103f28:	e8 53 fb ff ff       	call   80103a80 <mycpu>
}
80103f2d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103f30:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f39:	5b                   	pop    %ebx
80103f3a:	5e                   	pop    %esi
80103f3b:	5d                   	pop    %ebp
80103f3c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103f3d:	83 ec 0c             	sub    $0xc,%esp
80103f40:	68 70 78 10 80       	push   $0x80107870
80103f45:	e8 26 c4 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 9c 78 10 80       	push   $0x8010789c
80103f52:	e8 19 c4 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	68 8e 78 10 80       	push   $0x8010788e
80103f5f:	e8 0c c4 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	68 82 78 10 80       	push   $0x80107882
80103f6c:	e8 ff c3 ff ff       	call   80100370 <panic>
80103f71:	eb 0d                	jmp    80103f80 <exit>
80103f73:	90                   	nop
80103f74:	90                   	nop
80103f75:	90                   	nop
80103f76:	90                   	nop
80103f77:	90                   	nop
80103f78:	90                   	nop
80103f79:	90                   	nop
80103f7a:	90                   	nop
80103f7b:	90                   	nop
80103f7c:	90                   	nop
80103f7d:	90                   	nop
80103f7e:	90                   	nop
80103f7f:	90                   	nop

80103f80 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	57                   	push   %edi
80103f84:	56                   	push   %esi
80103f85:	53                   	push   %ebx
80103f86:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f89:	e8 a2 06 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103f8e:	e8 ed fa ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80103f93:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f99:	e8 82 07 00 00       	call   80104720 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103f9e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103fa4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103fa7:	8d 7e 68             	lea    0x68(%esi),%edi
80103faa:	0f 84 e7 00 00 00    	je     80104097 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103fb0:	8b 03                	mov    (%ebx),%eax
80103fb2:	85 c0                	test   %eax,%eax
80103fb4:	74 12                	je     80103fc8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103fb6:	83 ec 0c             	sub    $0xc,%esp
80103fb9:	50                   	push   %eax
80103fba:	e8 71 ce ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103fbf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103fc5:	83 c4 10             	add    $0x10,%esp
80103fc8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103fcb:	39 df                	cmp    %ebx,%edi
80103fcd:	75 e1                	jne    80103fb0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103fcf:	e8 1c ef ff ff       	call   80102ef0 <begin_op>
  iput(curproc->cwd);
80103fd4:	83 ec 0c             	sub    $0xc,%esp
80103fd7:	ff 76 68             	pushl  0x68(%esi)
80103fda:	e8 c1 d7 ff ff       	call   801017a0 <iput>
  end_op();
80103fdf:	e8 7c ef ff ff       	call   80102f60 <end_op>
  curproc->cwd = 0;
80103fe4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103feb:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ff2:	e8 79 06 00 00       	call   80104670 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103ff7:	8b 56 14             	mov    0x14(%esi),%edx
80103ffa:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ffd:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104002:	eb 0e                	jmp    80104012 <exit+0x92>
80104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104008:	83 e8 80             	sub    $0xffffff80,%eax
8010400b:	3d 54 5d 11 80       	cmp    $0x80115d54,%eax
80104010:	74 1c                	je     8010402e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80104012:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104016:	75 f0                	jne    80104008 <exit+0x88>
80104018:	3b 50 20             	cmp    0x20(%eax),%edx
8010401b:	75 eb                	jne    80104008 <exit+0x88>
      p->state = RUNNABLE;
8010401d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104024:	83 e8 80             	sub    $0xffffff80,%eax
80104027:	3d 54 5d 11 80       	cmp    $0x80115d54,%eax
8010402c:	75 e4                	jne    80104012 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
8010402e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80104034:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104039:	eb 10                	jmp    8010404b <exit+0xcb>
8010403b:	90                   	nop
8010403c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104040:	83 ea 80             	sub    $0xffffff80,%edx
80104043:	81 fa 54 5d 11 80    	cmp    $0x80115d54,%edx
80104049:	74 33                	je     8010407e <exit+0xfe>
    if(p->parent == curproc){
8010404b:	39 72 14             	cmp    %esi,0x14(%edx)
8010404e:	75 f0                	jne    80104040 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80104050:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104054:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104057:	75 e7                	jne    80104040 <exit+0xc0>
80104059:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010405e:	eb 0a                	jmp    8010406a <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104060:	83 e8 80             	sub    $0xffffff80,%eax
80104063:	3d 54 5d 11 80       	cmp    $0x80115d54,%eax
80104068:	74 d6                	je     80104040 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010406a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010406e:	75 f0                	jne    80104060 <exit+0xe0>
80104070:	3b 48 20             	cmp    0x20(%eax),%ecx
80104073:	75 eb                	jne    80104060 <exit+0xe0>
      p->state = RUNNABLE;
80104075:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010407c:	eb e2                	jmp    80104060 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
8010407e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104085:	e8 36 fe ff ff       	call   80103ec0 <sched>
  panic("zombie exit");
8010408a:	83 ec 0c             	sub    $0xc,%esp
8010408d:	68 bd 78 10 80       	push   $0x801078bd
80104092:	e8 d9 c2 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80104097:	83 ec 0c             	sub    $0xc,%esp
8010409a:	68 b0 78 10 80       	push   $0x801078b0
8010409f:	e8 cc c2 ff ff       	call   80100370 <panic>
801040a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801040b0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	53                   	push   %ebx
801040b4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040b7:	68 20 3d 11 80       	push   $0x80113d20
801040bc:	e8 af 05 00 00       	call   80104670 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801040c1:	e8 6a 05 00 00       	call   80104630 <pushcli>
  c = mycpu();
801040c6:	e8 b5 f9 ff ff       	call   80103a80 <mycpu>
  p = c->proc;
801040cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040d1:	e8 4a 06 00 00       	call   80104720 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
801040d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040dd:	e8 de fd ff ff       	call   80103ec0 <sched>
  release(&ptable.lock);
801040e2:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801040e9:	e8 a2 06 00 00       	call   80104790 <release>
}
801040ee:	83 c4 10             	add    $0x10,%esp
801040f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f4:	c9                   	leave  
801040f5:	c3                   	ret    
801040f6:	8d 76 00             	lea    0x0(%esi),%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104100 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	53                   	push   %ebx
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	8b 7d 08             	mov    0x8(%ebp),%edi
8010410c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010410f:	e8 1c 05 00 00       	call   80104630 <pushcli>
  c = mycpu();
80104114:	e8 67 f9 ff ff       	call   80103a80 <mycpu>
  p = c->proc;
80104119:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010411f:	e8 fc 05 00 00       	call   80104720 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
80104124:	85 db                	test   %ebx,%ebx
80104126:	0f 84 87 00 00 00    	je     801041b3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
8010412c:	85 f6                	test   %esi,%esi
8010412e:	74 76                	je     801041a6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104130:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104136:	74 50                	je     80104188 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	68 20 3d 11 80       	push   $0x80113d20
80104140:	e8 2b 05 00 00       	call   80104670 <acquire>
    release(lk);
80104145:	89 34 24             	mov    %esi,(%esp)
80104148:	e8 43 06 00 00       	call   80104790 <release>
  }
  // Go to sleep.
  p->chan = chan;
8010414d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104150:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104157:	e8 64 fd ff ff       	call   80103ec0 <sched>

  // Tidy up.
  p->chan = 0;
8010415c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80104163:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010416a:	e8 21 06 00 00       	call   80104790 <release>
    acquire(lk);
8010416f:	89 75 08             	mov    %esi,0x8(%ebp)
80104172:	83 c4 10             	add    $0x10,%esp
  }
}
80104175:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104178:	5b                   	pop    %ebx
80104179:	5e                   	pop    %esi
8010417a:	5f                   	pop    %edi
8010417b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
8010417c:	e9 ef 04 00 00       	jmp    80104670 <acquire>
80104181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80104188:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010418b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104192:	e8 29 fd ff ff       	call   80103ec0 <sched>

  // Tidy up.
  p->chan = 0;
80104197:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010419e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041a1:	5b                   	pop    %ebx
801041a2:	5e                   	pop    %esi
801041a3:	5f                   	pop    %edi
801041a4:	5d                   	pop    %ebp
801041a5:	c3                   	ret    

  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	68 cf 78 10 80       	push   $0x801078cf
801041ae:	e8 bd c1 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
    panic("sleep");
801041b3:	83 ec 0c             	sub    $0xc,%esp
801041b6:	68 c9 78 10 80       	push   $0x801078c9
801041bb:	e8 b0 c1 ff ff       	call   80100370 <panic>

801041c0 <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	56                   	push   %esi
801041c4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041c5:	e8 66 04 00 00       	call   80104630 <pushcli>
  c = mycpu();
801041ca:	e8 b1 f8 ff ff       	call   80103a80 <mycpu>
  p = c->proc;
801041cf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041d5:	e8 46 05 00 00       	call   80104720 <popcli>
wait(void) {
    struct proc *p;
    int havekids, pid;
    struct proc *curproc = myproc();

    acquire(&ptable.lock);
801041da:	83 ec 0c             	sub    $0xc,%esp
801041dd:	68 20 3d 11 80       	push   $0x80113d20
801041e2:	e8 89 04 00 00       	call   80104670 <acquire>
801041e7:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
801041ea:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041ec:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801041f1:	eb 10                	jmp    80104203 <wait+0x43>
801041f3:	90                   	nop
801041f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f8:	83 eb 80             	sub    $0xffffff80,%ebx
801041fb:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
80104201:	74 1d                	je     80104220 <wait+0x60>
            if (p->parent != curproc)
80104203:	39 73 14             	cmp    %esi,0x14(%ebx)
80104206:	75 f0                	jne    801041f8 <wait+0x38>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
80104208:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010420c:	74 30                	je     8010423e <wait+0x7e>

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010420e:	83 eb 80             	sub    $0xffffff80,%ebx
            if (p->parent != curproc)
                continue;
            havekids = 1;
80104211:	b8 01 00 00 00       	mov    $0x1,%eax

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104216:	81 fb 54 5d 11 80    	cmp    $0x80115d54,%ebx
8010421c:	75 e5                	jne    80104203 <wait+0x43>
8010421e:	66 90                	xchg   %ax,%ax
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
80104220:	85 c0                	test   %eax,%eax
80104222:	74 70                	je     80104294 <wait+0xd4>
80104224:	8b 46 24             	mov    0x24(%esi),%eax
80104227:	85 c0                	test   %eax,%eax
80104229:	75 69                	jne    80104294 <wait+0xd4>
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010422b:	83 ec 08             	sub    $0x8,%esp
8010422e:	68 20 3d 11 80       	push   $0x80113d20
80104233:	56                   	push   %esi
80104234:	e8 c7 fe ff ff       	call   80104100 <sleep>
    }
80104239:	83 c4 10             	add    $0x10,%esp
8010423c:	eb ac                	jmp    801041ea <wait+0x2a>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
8010423e:	83 ec 0c             	sub    $0xc,%esp
80104241:	ff 73 08             	pushl  0x8(%ebx)
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
80104244:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80104247:	e8 34 e4 ff ff       	call   80102680 <kfree>
                p->kstack = 0;
                freevm(p->pgdir);
8010424c:	5a                   	pop    %edx
8010424d:	ff 73 04             	pushl  0x4(%ebx)
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
80104250:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104257:	e8 24 2d 00 00       	call   80106f80 <freevm>
                p->pid = 0;
8010425c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104263:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
8010426a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
8010426e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104275:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                //removeSwapFile(p);
                release(&ptable.lock);
8010427c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104283:	e8 08 05 00 00       	call   80104790 <release>
                return pid;
80104288:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
8010428b:	8d 65 f8             	lea    -0x8(%ebp),%esp
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                //removeSwapFile(p);
                release(&ptable.lock);
                return pid;
8010428e:	89 f0                	mov    %esi,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
80104290:	5b                   	pop    %ebx
80104291:	5e                   	pop    %esi
80104292:	5d                   	pop    %ebp
80104293:	c3                   	ret    
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
80104294:	83 ec 0c             	sub    $0xc,%esp
80104297:	68 20 3d 11 80       	push   $0x80113d20
8010429c:	e8 ef 04 00 00       	call   80104790 <release>
            return -1;
801042a1:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801042a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
            return -1;
801042a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801042ac:	5b                   	pop    %ebx
801042ad:	5e                   	pop    %esi
801042ae:	5d                   	pop    %ebp
801042af:	c3                   	ret    

801042b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 10             	sub    $0x10,%esp
801042b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042ba:	68 20 3d 11 80       	push   $0x80113d20
801042bf:	e8 ac 03 00 00       	call   80104670 <acquire>
801042c4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042c7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801042cc:	eb 0c                	jmp    801042da <wakeup+0x2a>
801042ce:	66 90                	xchg   %ax,%ax
801042d0:	83 e8 80             	sub    $0xffffff80,%eax
801042d3:	3d 54 5d 11 80       	cmp    $0x80115d54,%eax
801042d8:	74 1c                	je     801042f6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801042da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042de:	75 f0                	jne    801042d0 <wakeup+0x20>
801042e0:	3b 58 20             	cmp    0x20(%eax),%ebx
801042e3:	75 eb                	jne    801042d0 <wakeup+0x20>
      p->state = RUNNABLE;
801042e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ec:	83 e8 80             	sub    $0xffffff80,%eax
801042ef:	3d 54 5d 11 80       	cmp    $0x80115d54,%eax
801042f4:	75 e4                	jne    801042da <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801042f6:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
801042fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104300:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104301:	e9 8a 04 00 00       	jmp    80104790 <release>
80104306:	8d 76 00             	lea    0x0(%esi),%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104310 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 10             	sub    $0x10,%esp
80104317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010431a:	68 20 3d 11 80       	push   $0x80113d20
8010431f:	e8 4c 03 00 00       	call   80104670 <acquire>
80104324:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104327:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010432c:	eb 0c                	jmp    8010433a <kill+0x2a>
8010432e:	66 90                	xchg   %ax,%ax
80104330:	83 e8 80             	sub    $0xffffff80,%eax
80104333:	3d 54 5d 11 80       	cmp    $0x80115d54,%eax
80104338:	74 3e                	je     80104378 <kill+0x68>
    if(p->pid == pid){
8010433a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010433d:	75 f1                	jne    80104330 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010433f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104343:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010434a:	74 1c                	je     80104368 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010434c:	83 ec 0c             	sub    $0xc,%esp
8010434f:	68 20 3d 11 80       	push   $0x80113d20
80104354:	e8 37 04 00 00       	call   80104790 <release>
      return 0;
80104359:	83 c4 10             	add    $0x10,%esp
8010435c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010435e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104361:	c9                   	leave  
80104362:	c3                   	ret    
80104363:	90                   	nop
80104364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104368:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010436f:	eb db                	jmp    8010434c <kill+0x3c>
80104371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	68 20 3d 11 80       	push   $0x80113d20
80104380:	e8 0b 04 00 00       	call   80104790 <release>
  return -1;
80104385:	83 c4 10             	add    $0x10,%esp
80104388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010438d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104390:	c9                   	leave  
80104391:	c3                   	ret    
80104392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043a9:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801043ae:	83 ec 3c             	sub    $0x3c,%esp
801043b1:	eb 24                	jmp    801043d7 <procdump+0x37>
801043b3:	90                   	nop
801043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043b8:	83 ec 0c             	sub    $0xc,%esp
801043bb:	68 37 7c 10 80       	push   $0x80107c37
801043c0:	e8 9b c2 ff ff       	call   80100660 <cprintf>
801043c5:	83 c4 10             	add    $0x10,%esp
801043c8:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043cb:	81 fb c0 5d 11 80    	cmp    $0x80115dc0,%ebx
801043d1:	0f 84 81 00 00 00    	je     80104458 <procdump+0xb8>
    if(p->state == UNUSED)
801043d7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043da:	85 c0                	test   %eax,%eax
801043dc:	74 ea                	je     801043c8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043de:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801043e1:	ba e0 78 10 80       	mov    $0x801078e0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043e6:	77 11                	ja     801043f9 <procdump+0x59>
801043e8:	8b 14 85 40 79 10 80 	mov    -0x7fef86c0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801043ef:	b8 e0 78 10 80       	mov    $0x801078e0,%eax
801043f4:	85 d2                	test   %edx,%edx
801043f6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801043f9:	53                   	push   %ebx
801043fa:	52                   	push   %edx
801043fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801043fe:	68 e4 78 10 80       	push   $0x801078e4
80104403:	e8 58 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104408:	83 c4 10             	add    $0x10,%esp
8010440b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010440f:	75 a7                	jne    801043b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104411:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104414:	83 ec 08             	sub    $0x8,%esp
80104417:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010441a:	50                   	push   %eax
8010441b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010441e:	8b 40 0c             	mov    0xc(%eax),%eax
80104421:	83 c0 08             	add    $0x8,%eax
80104424:	50                   	push   %eax
80104425:	e8 66 01 00 00       	call   80104590 <getcallerpcs>
8010442a:	83 c4 10             	add    $0x10,%esp
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104430:	8b 17                	mov    (%edi),%edx
80104432:	85 d2                	test   %edx,%edx
80104434:	74 82                	je     801043b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104436:	83 ec 08             	sub    $0x8,%esp
80104439:	83 c7 04             	add    $0x4,%edi
8010443c:	52                   	push   %edx
8010443d:	68 e1 72 10 80       	push   $0x801072e1
80104442:	e8 19 c2 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104447:	83 c4 10             	add    $0x10,%esp
8010444a:	39 f7                	cmp    %esi,%edi
8010444c:	75 e2                	jne    80104430 <procdump+0x90>
8010444e:	e9 65 ff ff ff       	jmp    801043b8 <procdump+0x18>
80104453:	90                   	nop
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104458:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010445b:	5b                   	pop    %ebx
8010445c:	5e                   	pop    %esi
8010445d:	5f                   	pop    %edi
8010445e:	5d                   	pop    %ebp
8010445f:	c3                   	ret    

80104460 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 0c             	sub    $0xc,%esp
80104467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010446a:	68 58 79 10 80       	push   $0x80107958
8010446f:	8d 43 04             	lea    0x4(%ebx),%eax
80104472:	50                   	push   %eax
80104473:	e8 f8 00 00 00       	call   80104570 <initlock>
  lk->name = name;
80104478:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010447b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104481:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104484:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010448b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010448e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104491:	c9                   	leave  
80104492:	c3                   	ret    
80104493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044a8:	83 ec 0c             	sub    $0xc,%esp
801044ab:	8d 73 04             	lea    0x4(%ebx),%esi
801044ae:	56                   	push   %esi
801044af:	e8 bc 01 00 00       	call   80104670 <acquire>
  while (lk->locked) {
801044b4:	8b 13                	mov    (%ebx),%edx
801044b6:	83 c4 10             	add    $0x10,%esp
801044b9:	85 d2                	test   %edx,%edx
801044bb:	74 16                	je     801044d3 <acquiresleep+0x33>
801044bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044c0:	83 ec 08             	sub    $0x8,%esp
801044c3:	56                   	push   %esi
801044c4:	53                   	push   %ebx
801044c5:	e8 36 fc ff ff       	call   80104100 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801044ca:	8b 03                	mov    (%ebx),%eax
801044cc:	83 c4 10             	add    $0x10,%esp
801044cf:	85 c0                	test   %eax,%eax
801044d1:	75 ed                	jne    801044c0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801044d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044d9:	e8 42 f6 ff ff       	call   80103b20 <myproc>
801044de:	8b 40 10             	mov    0x10(%eax),%eax
801044e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044ea:	5b                   	pop    %ebx
801044eb:	5e                   	pop    %esi
801044ec:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801044ed:	e9 9e 02 00 00       	jmp    80104790 <release>
801044f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104500 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104508:	83 ec 0c             	sub    $0xc,%esp
8010450b:	8d 73 04             	lea    0x4(%ebx),%esi
8010450e:	56                   	push   %esi
8010450f:	e8 5c 01 00 00       	call   80104670 <acquire>
  lk->locked = 0;
80104514:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010451a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104521:	89 1c 24             	mov    %ebx,(%esp)
80104524:	e8 87 fd ff ff       	call   801042b0 <wakeup>
  release(&lk->lk);
80104529:	89 75 08             	mov    %esi,0x8(%ebp)
8010452c:	83 c4 10             	add    $0x10,%esp
}
8010452f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104532:	5b                   	pop    %ebx
80104533:	5e                   	pop    %esi
80104534:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104535:	e9 56 02 00 00       	jmp    80104790 <release>
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104540 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	56                   	push   %esi
80104544:	53                   	push   %ebx
80104545:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104548:	83 ec 0c             	sub    $0xc,%esp
8010454b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010454e:	53                   	push   %ebx
8010454f:	e8 1c 01 00 00       	call   80104670 <acquire>
  r = lk->locked;
80104554:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104556:	89 1c 24             	mov    %ebx,(%esp)
80104559:	e8 32 02 00 00       	call   80104790 <release>
  return r;
}
8010455e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104561:	89 f0                	mov    %esi,%eax
80104563:	5b                   	pop    %ebx
80104564:	5e                   	pop    %esi
80104565:	5d                   	pop    %ebp
80104566:	c3                   	ret    
80104567:	66 90                	xchg   %ax,%ax
80104569:	66 90                	xchg   %ax,%ax
8010456b:	66 90                	xchg   %ax,%ax
8010456d:	66 90                	xchg   %ax,%ax
8010456f:	90                   	nop

80104570 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104576:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010457f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104582:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104589:	5d                   	pop    %ebp
8010458a:	c3                   	ret    
8010458b:	90                   	nop
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104590 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104594:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104597:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010459a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010459d:	31 c0                	xor    %eax,%eax
8010459f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801045a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045ac:	77 1a                	ja     801045c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801045b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045b4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801045b7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045b9:	83 f8 0a             	cmp    $0xa,%eax
801045bc:	75 e2                	jne    801045a0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045be:	5b                   	pop    %ebx
801045bf:	5d                   	pop    %ebp
801045c0:	c3                   	ret    
801045c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801045c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801045cf:	83 c0 01             	add    $0x1,%eax
801045d2:	83 f8 0a             	cmp    $0xa,%eax
801045d5:	74 e7                	je     801045be <getcallerpcs+0x2e>
    pcs[i] = 0;
801045d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801045de:	83 c0 01             	add    $0x1,%eax
801045e1:	83 f8 0a             	cmp    $0xa,%eax
801045e4:	75 e2                	jne    801045c8 <getcallerpcs+0x38>
801045e6:	eb d6                	jmp    801045be <getcallerpcs+0x2e>
801045e8:	90                   	nop
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045f0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 04             	sub    $0x4,%esp
801045f7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801045fa:	8b 02                	mov    (%edx),%eax
801045fc:	85 c0                	test   %eax,%eax
801045fe:	75 10                	jne    80104610 <holding+0x20>
}
80104600:	83 c4 04             	add    $0x4,%esp
80104603:	31 c0                	xor    %eax,%eax
80104605:	5b                   	pop    %ebx
80104606:	5d                   	pop    %ebp
80104607:	c3                   	ret    
80104608:	90                   	nop
80104609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104610:	8b 5a 08             	mov    0x8(%edx),%ebx
80104613:	e8 68 f4 ff ff       	call   80103a80 <mycpu>
80104618:	39 c3                	cmp    %eax,%ebx
8010461a:	0f 94 c0             	sete   %al
}
8010461d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104620:	0f b6 c0             	movzbl %al,%eax
}
80104623:	5b                   	pop    %ebx
80104624:	5d                   	pop    %ebp
80104625:	c3                   	ret    
80104626:	8d 76 00             	lea    0x0(%esi),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 04             	sub    $0x4,%esp
80104637:	9c                   	pushf  
80104638:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104639:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010463a:	e8 41 f4 ff ff       	call   80103a80 <mycpu>
8010463f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104645:	85 c0                	test   %eax,%eax
80104647:	75 11                	jne    8010465a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104649:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010464f:	e8 2c f4 ff ff       	call   80103a80 <mycpu>
80104654:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010465a:	e8 21 f4 ff ff       	call   80103a80 <mycpu>
8010465f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104666:	83 c4 04             	add    $0x4,%esp
80104669:	5b                   	pop    %ebx
8010466a:	5d                   	pop    %ebp
8010466b:	c3                   	ret    
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104670 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104675:	e8 b6 ff ff ff       	call   80104630 <pushcli>
  if(holding(lk))
8010467a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010467d:	8b 03                	mov    (%ebx),%eax
8010467f:	85 c0                	test   %eax,%eax
80104681:	75 7d                	jne    80104700 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104683:	ba 01 00 00 00       	mov    $0x1,%edx
80104688:	eb 09                	jmp    80104693 <acquire+0x23>
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104690:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104693:	89 d0                	mov    %edx,%eax
80104695:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104698:	85 c0                	test   %eax,%eax
8010469a:	75 f4                	jne    80104690 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010469c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801046a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046a4:	e8 d7 f3 ff ff       	call   80103a80 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801046a9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801046ab:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801046ae:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046b1:	31 c0                	xor    %eax,%eax
801046b3:	90                   	nop
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046b8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801046be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046c4:	77 1a                	ja     801046e0 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046c6:	8b 5a 04             	mov    0x4(%edx),%ebx
801046c9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046cc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801046cf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046d1:	83 f8 0a             	cmp    $0xa,%eax
801046d4:	75 e2                	jne    801046b8 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801046d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046d9:	5b                   	pop    %ebx
801046da:	5e                   	pop    %esi
801046db:	5d                   	pop    %ebp
801046dc:	c3                   	ret    
801046dd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801046e0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801046e7:	83 c0 01             	add    $0x1,%eax
801046ea:	83 f8 0a             	cmp    $0xa,%eax
801046ed:	74 e7                	je     801046d6 <acquire+0x66>
    pcs[i] = 0;
801046ef:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801046f6:	83 c0 01             	add    $0x1,%eax
801046f9:	83 f8 0a             	cmp    $0xa,%eax
801046fc:	75 e2                	jne    801046e0 <acquire+0x70>
801046fe:	eb d6                	jmp    801046d6 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104700:	8b 73 08             	mov    0x8(%ebx),%esi
80104703:	e8 78 f3 ff ff       	call   80103a80 <mycpu>
80104708:	39 c6                	cmp    %eax,%esi
8010470a:	0f 85 73 ff ff ff    	jne    80104683 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104710:	83 ec 0c             	sub    $0xc,%esp
80104713:	68 63 79 10 80       	push   $0x80107963
80104718:	e8 53 bc ff ff       	call   80100370 <panic>
8010471d:	8d 76 00             	lea    0x0(%esi),%esi

80104720 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104726:	9c                   	pushf  
80104727:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104728:	f6 c4 02             	test   $0x2,%ah
8010472b:	75 52                	jne    8010477f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010472d:	e8 4e f3 ff ff       	call   80103a80 <mycpu>
80104732:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104738:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010473b:	85 d2                	test   %edx,%edx
8010473d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104743:	78 2d                	js     80104772 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104745:	e8 36 f3 ff ff       	call   80103a80 <mycpu>
8010474a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104750:	85 d2                	test   %edx,%edx
80104752:	74 0c                	je     80104760 <popcli+0x40>
    sti();
}
80104754:	c9                   	leave  
80104755:	c3                   	ret    
80104756:	8d 76 00             	lea    0x0(%esi),%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104760:	e8 1b f3 ff ff       	call   80103a80 <mycpu>
80104765:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010476b:	85 c0                	test   %eax,%eax
8010476d:	74 e5                	je     80104754 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010476f:	fb                   	sti    
    sti();
}
80104770:	c9                   	leave  
80104771:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104772:	83 ec 0c             	sub    $0xc,%esp
80104775:	68 82 79 10 80       	push   $0x80107982
8010477a:	e8 f1 bb ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010477f:	83 ec 0c             	sub    $0xc,%esp
80104782:	68 6b 79 10 80       	push   $0x8010796b
80104787:	e8 e4 bb ff ff       	call   80100370 <panic>
8010478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104790 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104798:	8b 03                	mov    (%ebx),%eax
8010479a:	85 c0                	test   %eax,%eax
8010479c:	75 12                	jne    801047b0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010479e:	83 ec 0c             	sub    $0xc,%esp
801047a1:	68 89 79 10 80       	push   $0x80107989
801047a6:	e8 c5 bb ff ff       	call   80100370 <panic>
801047ab:	90                   	nop
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801047b0:	8b 73 08             	mov    0x8(%ebx),%esi
801047b3:	e8 c8 f2 ff ff       	call   80103a80 <mycpu>
801047b8:	39 c6                	cmp    %eax,%esi
801047ba:	75 e2                	jne    8010479e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
801047bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801047c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801047ca:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801047d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d8:	5b                   	pop    %ebx
801047d9:	5e                   	pop    %esi
801047da:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801047db:	e9 40 ff ff ff       	jmp    80104720 <popcli>

801047e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	57                   	push   %edi
801047e4:	53                   	push   %ebx
801047e5:	8b 55 08             	mov    0x8(%ebp),%edx
801047e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801047eb:	f6 c2 03             	test   $0x3,%dl
801047ee:	75 05                	jne    801047f5 <memset+0x15>
801047f0:	f6 c1 03             	test   $0x3,%cl
801047f3:	74 13                	je     80104808 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801047f5:	89 d7                	mov    %edx,%edi
801047f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801047fa:	fc                   	cld    
801047fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801047fd:	5b                   	pop    %ebx
801047fe:	89 d0                	mov    %edx,%eax
80104800:	5f                   	pop    %edi
80104801:	5d                   	pop    %ebp
80104802:	c3                   	ret    
80104803:	90                   	nop
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104808:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010480c:	c1 e9 02             	shr    $0x2,%ecx
8010480f:	89 fb                	mov    %edi,%ebx
80104811:	89 f8                	mov    %edi,%eax
80104813:	c1 e3 18             	shl    $0x18,%ebx
80104816:	c1 e0 10             	shl    $0x10,%eax
80104819:	09 d8                	or     %ebx,%eax
8010481b:	09 f8                	or     %edi,%eax
8010481d:	c1 e7 08             	shl    $0x8,%edi
80104820:	09 f8                	or     %edi,%eax
80104822:	89 d7                	mov    %edx,%edi
80104824:	fc                   	cld    
80104825:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104827:	5b                   	pop    %ebx
80104828:	89 d0                	mov    %edx,%eax
8010482a:	5f                   	pop    %edi
8010482b:	5d                   	pop    %ebp
8010482c:	c3                   	ret    
8010482d:	8d 76 00             	lea    0x0(%esi),%esi

80104830 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	56                   	push   %esi
80104835:	8b 45 10             	mov    0x10(%ebp),%eax
80104838:	53                   	push   %ebx
80104839:	8b 75 0c             	mov    0xc(%ebp),%esi
8010483c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010483f:	85 c0                	test   %eax,%eax
80104841:	74 29                	je     8010486c <memcmp+0x3c>
    if(*s1 != *s2)
80104843:	0f b6 13             	movzbl (%ebx),%edx
80104846:	0f b6 0e             	movzbl (%esi),%ecx
80104849:	38 d1                	cmp    %dl,%cl
8010484b:	75 2b                	jne    80104878 <memcmp+0x48>
8010484d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104850:	31 c0                	xor    %eax,%eax
80104852:	eb 14                	jmp    80104868 <memcmp+0x38>
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104858:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010485d:	83 c0 01             	add    $0x1,%eax
80104860:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104864:	38 ca                	cmp    %cl,%dl
80104866:	75 10                	jne    80104878 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104868:	39 f8                	cmp    %edi,%eax
8010486a:	75 ec                	jne    80104858 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010486c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010486d:	31 c0                	xor    %eax,%eax
}
8010486f:	5e                   	pop    %esi
80104870:	5f                   	pop    %edi
80104871:	5d                   	pop    %ebp
80104872:	c3                   	ret    
80104873:	90                   	nop
80104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104878:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010487b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010487c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010487e:	5e                   	pop    %esi
8010487f:	5f                   	pop    %edi
80104880:	5d                   	pop    %ebp
80104881:	c3                   	ret    
80104882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104890 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	8b 45 08             	mov    0x8(%ebp),%eax
80104898:	8b 75 0c             	mov    0xc(%ebp),%esi
8010489b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010489e:	39 c6                	cmp    %eax,%esi
801048a0:	73 2e                	jae    801048d0 <memmove+0x40>
801048a2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801048a5:	39 c8                	cmp    %ecx,%eax
801048a7:	73 27                	jae    801048d0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801048a9:	85 db                	test   %ebx,%ebx
801048ab:	8d 53 ff             	lea    -0x1(%ebx),%edx
801048ae:	74 17                	je     801048c7 <memmove+0x37>
      *--d = *--s;
801048b0:	29 d9                	sub    %ebx,%ecx
801048b2:	89 cb                	mov    %ecx,%ebx
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048b8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801048bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801048bf:	83 ea 01             	sub    $0x1,%edx
801048c2:	83 fa ff             	cmp    $0xffffffff,%edx
801048c5:	75 f1                	jne    801048b8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048c7:	5b                   	pop    %ebx
801048c8:	5e                   	pop    %esi
801048c9:	5d                   	pop    %ebp
801048ca:	c3                   	ret    
801048cb:	90                   	nop
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801048d0:	31 d2                	xor    %edx,%edx
801048d2:	85 db                	test   %ebx,%ebx
801048d4:	74 f1                	je     801048c7 <memmove+0x37>
801048d6:	8d 76 00             	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801048e0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801048e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801048e7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801048ea:	39 d3                	cmp    %edx,%ebx
801048ec:	75 f2                	jne    801048e0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801048ee:	5b                   	pop    %ebx
801048ef:	5e                   	pop    %esi
801048f0:	5d                   	pop    %ebp
801048f1:	c3                   	ret    
801048f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104903:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104904:	eb 8a                	jmp    80104890 <memmove>
80104906:	8d 76 00             	lea    0x0(%esi),%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104910 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	56                   	push   %esi
80104915:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104918:	53                   	push   %ebx
80104919:	8b 7d 08             	mov    0x8(%ebp),%edi
8010491c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010491f:	85 c9                	test   %ecx,%ecx
80104921:	74 37                	je     8010495a <strncmp+0x4a>
80104923:	0f b6 17             	movzbl (%edi),%edx
80104926:	0f b6 1e             	movzbl (%esi),%ebx
80104929:	84 d2                	test   %dl,%dl
8010492b:	74 3f                	je     8010496c <strncmp+0x5c>
8010492d:	38 d3                	cmp    %dl,%bl
8010492f:	75 3b                	jne    8010496c <strncmp+0x5c>
80104931:	8d 47 01             	lea    0x1(%edi),%eax
80104934:	01 cf                	add    %ecx,%edi
80104936:	eb 1b                	jmp    80104953 <strncmp+0x43>
80104938:	90                   	nop
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104940:	0f b6 10             	movzbl (%eax),%edx
80104943:	84 d2                	test   %dl,%dl
80104945:	74 21                	je     80104968 <strncmp+0x58>
80104947:	0f b6 19             	movzbl (%ecx),%ebx
8010494a:	83 c0 01             	add    $0x1,%eax
8010494d:	89 ce                	mov    %ecx,%esi
8010494f:	38 da                	cmp    %bl,%dl
80104951:	75 19                	jne    8010496c <strncmp+0x5c>
80104953:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104955:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104958:	75 e6                	jne    80104940 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010495a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010495b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010495d:	5e                   	pop    %esi
8010495e:	5f                   	pop    %edi
8010495f:	5d                   	pop    %ebp
80104960:	c3                   	ret    
80104961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104968:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010496c:	0f b6 c2             	movzbl %dl,%eax
8010496f:	29 d8                	sub    %ebx,%eax
}
80104971:	5b                   	pop    %ebx
80104972:	5e                   	pop    %esi
80104973:	5f                   	pop    %edi
80104974:	5d                   	pop    %ebp
80104975:	c3                   	ret    
80104976:	8d 76 00             	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	8b 45 08             	mov    0x8(%ebp),%eax
80104988:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010498b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010498e:	89 c2                	mov    %eax,%edx
80104990:	eb 19                	jmp    801049ab <strncpy+0x2b>
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104998:	83 c3 01             	add    $0x1,%ebx
8010499b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010499f:	83 c2 01             	add    $0x1,%edx
801049a2:	84 c9                	test   %cl,%cl
801049a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801049a7:	74 09                	je     801049b2 <strncpy+0x32>
801049a9:	89 f1                	mov    %esi,%ecx
801049ab:	85 c9                	test   %ecx,%ecx
801049ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801049b0:	7f e6                	jg     80104998 <strncpy+0x18>
    ;
  while(n-- > 0)
801049b2:	31 c9                	xor    %ecx,%ecx
801049b4:	85 f6                	test   %esi,%esi
801049b6:	7e 17                	jle    801049cf <strncpy+0x4f>
801049b8:	90                   	nop
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801049c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801049c4:	89 f3                	mov    %esi,%ebx
801049c6:	83 c1 01             	add    $0x1,%ecx
801049c9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801049cb:	85 db                	test   %ebx,%ebx
801049cd:	7f f1                	jg     801049c0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801049cf:	5b                   	pop    %ebx
801049d0:	5e                   	pop    %esi
801049d1:	5d                   	pop    %ebp
801049d2:	c3                   	ret    
801049d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049e8:	8b 45 08             	mov    0x8(%ebp),%eax
801049eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801049ee:	85 c9                	test   %ecx,%ecx
801049f0:	7e 26                	jle    80104a18 <safestrcpy+0x38>
801049f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801049f6:	89 c1                	mov    %eax,%ecx
801049f8:	eb 17                	jmp    80104a11 <safestrcpy+0x31>
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a00:	83 c2 01             	add    $0x1,%edx
80104a03:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104a07:	83 c1 01             	add    $0x1,%ecx
80104a0a:	84 db                	test   %bl,%bl
80104a0c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104a0f:	74 04                	je     80104a15 <safestrcpy+0x35>
80104a11:	39 f2                	cmp    %esi,%edx
80104a13:	75 eb                	jne    80104a00 <safestrcpy+0x20>
    ;
  *s = 0;
80104a15:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104a18:	5b                   	pop    %ebx
80104a19:	5e                   	pop    %esi
80104a1a:	5d                   	pop    %ebp
80104a1b:	c3                   	ret    
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a20 <strlen>:

int
strlen(const char *s)
{
80104a20:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a21:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104a23:	89 e5                	mov    %esp,%ebp
80104a25:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104a28:	80 3a 00             	cmpb   $0x0,(%edx)
80104a2b:	74 0c                	je     80104a39 <strlen+0x19>
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi
80104a30:	83 c0 01             	add    $0x1,%eax
80104a33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a37:	75 f7                	jne    80104a30 <strlen+0x10>
    ;
  return n;
}
80104a39:	5d                   	pop    %ebp
80104a3a:	c3                   	ret    

80104a3b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a3b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a3f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104a43:	55                   	push   %ebp
  pushl %ebx
80104a44:	53                   	push   %ebx
  pushl %esi
80104a45:	56                   	push   %esi
  pushl %edi
80104a46:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a47:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a49:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104a4b:	5f                   	pop    %edi
  popl %esi
80104a4c:	5e                   	pop    %esi
  popl %ebx
80104a4d:	5b                   	pop    %ebx
  popl %ebp
80104a4e:	5d                   	pop    %ebp
  ret
80104a4f:	c3                   	ret    

80104a50 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 04             	sub    $0x4,%esp
80104a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a5a:	e8 c1 f0 ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a5f:	8b 00                	mov    (%eax),%eax
80104a61:	39 d8                	cmp    %ebx,%eax
80104a63:	76 1b                	jbe    80104a80 <fetchint+0x30>
80104a65:	8d 53 04             	lea    0x4(%ebx),%edx
80104a68:	39 d0                	cmp    %edx,%eax
80104a6a:	72 14                	jb     80104a80 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a6f:	8b 13                	mov    (%ebx),%edx
80104a71:	89 10                	mov    %edx,(%eax)
  return 0;
80104a73:	31 c0                	xor    %eax,%eax
}
80104a75:	83 c4 04             	add    $0x4,%esp
80104a78:	5b                   	pop    %ebx
80104a79:	5d                   	pop    %ebp
80104a7a:	c3                   	ret    
80104a7b:	90                   	nop
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a85:	eb ee                	jmp    80104a75 <fetchint+0x25>
80104a87:	89 f6                	mov    %esi,%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
80104a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a9a:	e8 81 f0 ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz)
80104a9f:	39 18                	cmp    %ebx,(%eax)
80104aa1:	76 29                	jbe    80104acc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104aa3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104aa6:	89 da                	mov    %ebx,%edx
80104aa8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104aaa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104aac:	39 c3                	cmp    %eax,%ebx
80104aae:	73 1c                	jae    80104acc <fetchstr+0x3c>
    if(*s == 0)
80104ab0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104ab3:	75 10                	jne    80104ac5 <fetchstr+0x35>
80104ab5:	eb 29                	jmp    80104ae0 <fetchstr+0x50>
80104ab7:	89 f6                	mov    %esi,%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ac0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ac3:	74 1b                	je     80104ae0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104ac5:	83 c2 01             	add    $0x1,%edx
80104ac8:	39 d0                	cmp    %edx,%eax
80104aca:	77 f4                	ja     80104ac0 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104acc:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104acf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104ad4:	5b                   	pop    %ebx
80104ad5:	5d                   	pop    %ebp
80104ad6:	c3                   	ret    
80104ad7:	89 f6                	mov    %esi,%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ae0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104ae3:	89 d0                	mov    %edx,%eax
80104ae5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ae7:	5b                   	pop    %ebx
80104ae8:	5d                   	pop    %ebp
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
80104af5:	e8 26 f0 ff ff       	call   80103b20 <myproc>
80104afa:	8b 40 18             	mov    0x18(%eax),%eax
80104afd:	8b 55 08             	mov    0x8(%ebp),%edx
80104b00:	8b 40 44             	mov    0x44(%eax),%eax
80104b03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104b06:	e8 15 f0 ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b0b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b0d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b10:	39 c6                	cmp    %eax,%esi
80104b12:	73 1c                	jae    80104b30 <argint+0x40>
80104b14:	8d 53 08             	lea    0x8(%ebx),%edx
80104b17:	39 d0                	cmp    %edx,%eax
80104b19:	72 15                	jb     80104b30 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b1e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b21:	89 10                	mov    %edx,(%eax)
  return 0;
80104b23:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104b25:	5b                   	pop    %ebx
80104b26:	5e                   	pop    %esi
80104b27:	5d                   	pop    %ebp
80104b28:	c3                   	ret    
80104b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b35:	eb ee                	jmp    80104b25 <argint+0x35>
80104b37:	89 f6                	mov    %esi,%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	56                   	push   %esi
80104b44:	53                   	push   %ebx
80104b45:	83 ec 10             	sub    $0x10,%esp
80104b48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104b4b:	e8 d0 ef ff ff       	call   80103b20 <myproc>
80104b50:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104b52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b55:	83 ec 08             	sub    $0x8,%esp
80104b58:	50                   	push   %eax
80104b59:	ff 75 08             	pushl  0x8(%ebp)
80104b5c:	e8 8f ff ff ff       	call   80104af0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b61:	c1 e8 1f             	shr    $0x1f,%eax
80104b64:	83 c4 10             	add    $0x10,%esp
80104b67:	84 c0                	test   %al,%al
80104b69:	75 2d                	jne    80104b98 <argptr+0x58>
80104b6b:	89 d8                	mov    %ebx,%eax
80104b6d:	c1 e8 1f             	shr    $0x1f,%eax
80104b70:	84 c0                	test   %al,%al
80104b72:	75 24                	jne    80104b98 <argptr+0x58>
80104b74:	8b 16                	mov    (%esi),%edx
80104b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b79:	39 c2                	cmp    %eax,%edx
80104b7b:	76 1b                	jbe    80104b98 <argptr+0x58>
80104b7d:	01 c3                	add    %eax,%ebx
80104b7f:	39 da                	cmp    %ebx,%edx
80104b81:	72 15                	jb     80104b98 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104b83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b86:	89 02                	mov    %eax,(%edx)
  return 0;
80104b88:	31 c0                	xor    %eax,%eax
}
80104b8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b8d:	5b                   	pop    %ebx
80104b8e:	5e                   	pop    %esi
80104b8f:	5d                   	pop    %ebp
80104b90:	c3                   	ret    
80104b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b9d:	eb eb                	jmp    80104b8a <argptr+0x4a>
80104b9f:	90                   	nop

80104ba0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ba6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ba9:	50                   	push   %eax
80104baa:	ff 75 08             	pushl  0x8(%ebp)
80104bad:	e8 3e ff ff ff       	call   80104af0 <argint>
80104bb2:	83 c4 10             	add    $0x10,%esp
80104bb5:	85 c0                	test   %eax,%eax
80104bb7:	78 17                	js     80104bd0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104bb9:	83 ec 08             	sub    $0x8,%esp
80104bbc:	ff 75 0c             	pushl  0xc(%ebp)
80104bbf:	ff 75 f4             	pushl  -0xc(%ebp)
80104bc2:	e8 c9 fe ff ff       	call   80104a90 <fetchstr>
80104bc7:	83 c4 10             	add    $0x10,%esp
}
80104bca:	c9                   	leave  
80104bcb:	c3                   	ret    
80104bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104bd5:	c9                   	leave  
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104be5:	e8 36 ef ff ff       	call   80103b20 <myproc>

  num = curproc->tf->eax;
80104bea:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104bed:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104bef:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104bf2:	8d 50 ff             	lea    -0x1(%eax),%edx
80104bf5:	83 fa 15             	cmp    $0x15,%edx
80104bf8:	77 1e                	ja     80104c18 <syscall+0x38>
80104bfa:	8b 14 85 c0 79 10 80 	mov    -0x7fef8640(,%eax,4),%edx
80104c01:	85 d2                	test   %edx,%edx
80104c03:	74 13                	je     80104c18 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104c05:	ff d2                	call   *%edx
80104c07:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c0d:	5b                   	pop    %ebx
80104c0e:	5e                   	pop    %esi
80104c0f:	5d                   	pop    %ebp
80104c10:	c3                   	ret    
80104c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104c18:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c19:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104c1c:	50                   	push   %eax
80104c1d:	ff 73 10             	pushl  0x10(%ebx)
80104c20:	68 91 79 10 80       	push   $0x80107991
80104c25:	e8 36 ba ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104c2a:	8b 43 18             	mov    0x18(%ebx),%eax
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104c37:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c3a:	5b                   	pop    %ebx
80104c3b:	5e                   	pop    %esi
80104c3c:	5d                   	pop    %ebp
80104c3d:	c3                   	ret    
80104c3e:	66 90                	xchg   %ax,%ax

80104c40 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
80104c45:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104c47:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104c4a:	89 d3                	mov    %edx,%ebx
80104c4c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104c4f:	50                   	push   %eax
80104c50:	6a 00                	push   $0x0
80104c52:	e8 99 fe ff ff       	call   80104af0 <argint>
80104c57:	83 c4 10             	add    $0x10,%esp
80104c5a:	85 c0                	test   %eax,%eax
80104c5c:	78 32                	js     80104c90 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c5e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c62:	77 2c                	ja     80104c90 <argfd.constprop.0+0x50>
80104c64:	e8 b7 ee ff ff       	call   80103b20 <myproc>
80104c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c6c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c70:	85 c0                	test   %eax,%eax
80104c72:	74 1c                	je     80104c90 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104c74:	85 f6                	test   %esi,%esi
80104c76:	74 02                	je     80104c7a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104c78:	89 16                	mov    %edx,(%esi)
  if(pf)
80104c7a:	85 db                	test   %ebx,%ebx
80104c7c:	74 22                	je     80104ca0 <argfd.constprop.0+0x60>
    *pf = f;
80104c7e:	89 03                	mov    %eax,(%ebx)
  return 0;
80104c80:	31 c0                	xor    %eax,%eax
}
80104c82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c85:	5b                   	pop    %ebx
80104c86:	5e                   	pop    %esi
80104c87:	5d                   	pop    %ebp
80104c88:	c3                   	ret    
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c90:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104c93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104c98:	5b                   	pop    %ebx
80104c99:	5e                   	pop    %esi
80104c9a:	5d                   	pop    %ebp
80104c9b:	c3                   	ret    
80104c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104ca0:	31 c0                	xor    %eax,%eax
80104ca2:	eb de                	jmp    80104c82 <argfd.constprop.0+0x42>
80104ca4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104caa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104cb0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104cb0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104cb1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104cb3:	89 e5                	mov    %esp,%ebp
80104cb5:	56                   	push   %esi
80104cb6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104cb7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104cba:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104cbd:	e8 7e ff ff ff       	call   80104c40 <argfd.constprop.0>
80104cc2:	85 c0                	test   %eax,%eax
80104cc4:	78 1a                	js     80104ce0 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104cc6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104cc8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104ccb:	e8 50 ee ff ff       	call   80103b20 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104cd0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104cd4:	85 d2                	test   %edx,%edx
80104cd6:	74 18                	je     80104cf0 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104cd8:	83 c3 01             	add    $0x1,%ebx
80104cdb:	83 fb 10             	cmp    $0x10,%ebx
80104cde:	75 f0                	jne    80104cd0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104ce0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104ce3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104ce8:	5b                   	pop    %ebx
80104ce9:	5e                   	pop    %esi
80104cea:	5d                   	pop    %ebp
80104ceb:	c3                   	ret    
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104cf0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104cf4:	83 ec 0c             	sub    $0xc,%esp
80104cf7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cfa:	e8 e1 c0 ff ff       	call   80100de0 <filedup>
  return fd;
80104cff:	83 c4 10             	add    $0x10,%esp
}
80104d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104d05:	89 d8                	mov    %ebx,%eax
}
80104d07:	5b                   	pop    %ebx
80104d08:	5e                   	pop    %esi
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret    
80104d0b:	90                   	nop
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d10 <sys_read>:

int
sys_read(void)
{
80104d10:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d11:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104d13:	89 e5                	mov    %esp,%ebp
80104d15:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d1b:	e8 20 ff ff ff       	call   80104c40 <argfd.constprop.0>
80104d20:	85 c0                	test   %eax,%eax
80104d22:	78 4c                	js     80104d70 <sys_read+0x60>
80104d24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d27:	83 ec 08             	sub    $0x8,%esp
80104d2a:	50                   	push   %eax
80104d2b:	6a 02                	push   $0x2
80104d2d:	e8 be fd ff ff       	call   80104af0 <argint>
80104d32:	83 c4 10             	add    $0x10,%esp
80104d35:	85 c0                	test   %eax,%eax
80104d37:	78 37                	js     80104d70 <sys_read+0x60>
80104d39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d3c:	83 ec 04             	sub    $0x4,%esp
80104d3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d42:	50                   	push   %eax
80104d43:	6a 01                	push   $0x1
80104d45:	e8 f6 fd ff ff       	call   80104b40 <argptr>
80104d4a:	83 c4 10             	add    $0x10,%esp
80104d4d:	85 c0                	test   %eax,%eax
80104d4f:	78 1f                	js     80104d70 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104d51:	83 ec 04             	sub    $0x4,%esp
80104d54:	ff 75 f0             	pushl  -0x10(%ebp)
80104d57:	ff 75 f4             	pushl  -0xc(%ebp)
80104d5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d5d:	e8 ee c1 ff ff       	call   80100f50 <fileread>
80104d62:	83 c4 10             	add    $0x10,%esp
}
80104d65:	c9                   	leave  
80104d66:	c3                   	ret    
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104d75:	c9                   	leave  
80104d76:	c3                   	ret    
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d80 <sys_write>:

int
sys_write(void)
{
80104d80:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d81:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d88:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d8b:	e8 b0 fe ff ff       	call   80104c40 <argfd.constprop.0>
80104d90:	85 c0                	test   %eax,%eax
80104d92:	78 4c                	js     80104de0 <sys_write+0x60>
80104d94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d97:	83 ec 08             	sub    $0x8,%esp
80104d9a:	50                   	push   %eax
80104d9b:	6a 02                	push   $0x2
80104d9d:	e8 4e fd ff ff       	call   80104af0 <argint>
80104da2:	83 c4 10             	add    $0x10,%esp
80104da5:	85 c0                	test   %eax,%eax
80104da7:	78 37                	js     80104de0 <sys_write+0x60>
80104da9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dac:	83 ec 04             	sub    $0x4,%esp
80104daf:	ff 75 f0             	pushl  -0x10(%ebp)
80104db2:	50                   	push   %eax
80104db3:	6a 01                	push   $0x1
80104db5:	e8 86 fd ff ff       	call   80104b40 <argptr>
80104dba:	83 c4 10             	add    $0x10,%esp
80104dbd:	85 c0                	test   %eax,%eax
80104dbf:	78 1f                	js     80104de0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104dc1:	83 ec 04             	sub    $0x4,%esp
80104dc4:	ff 75 f0             	pushl  -0x10(%ebp)
80104dc7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dca:	ff 75 ec             	pushl  -0x14(%ebp)
80104dcd:	e8 0e c2 ff ff       	call   80100fe0 <filewrite>
80104dd2:	83 c4 10             	add    $0x10,%esp
}
80104dd5:	c9                   	leave  
80104dd6:	c3                   	ret    
80104dd7:	89 f6                	mov    %esi,%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104de5:	c9                   	leave  
80104de6:	c3                   	ret    
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <sys_close>:

int
sys_close(void)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104df6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104df9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dfc:	e8 3f fe ff ff       	call   80104c40 <argfd.constprop.0>
80104e01:	85 c0                	test   %eax,%eax
80104e03:	78 2b                	js     80104e30 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104e05:	e8 16 ed ff ff       	call   80103b20 <myproc>
80104e0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e0d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104e10:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e17:	00 
  fileclose(f);
80104e18:	ff 75 f4             	pushl  -0xc(%ebp)
80104e1b:	e8 10 c0 ff ff       	call   80100e30 <fileclose>
  return 0;
80104e20:	83 c4 10             	add    $0x10,%esp
80104e23:	31 c0                	xor    %eax,%eax
}
80104e25:	c9                   	leave  
80104e26:	c3                   	ret    
80104e27:	89 f6                	mov    %esi,%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <sys_fstat>:

int
sys_fstat(void)
{
80104e40:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e41:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e48:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e4b:	e8 f0 fd ff ff       	call   80104c40 <argfd.constprop.0>
80104e50:	85 c0                	test   %eax,%eax
80104e52:	78 2c                	js     80104e80 <sys_fstat+0x40>
80104e54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e57:	83 ec 04             	sub    $0x4,%esp
80104e5a:	6a 14                	push   $0x14
80104e5c:	50                   	push   %eax
80104e5d:	6a 01                	push   $0x1
80104e5f:	e8 dc fc ff ff       	call   80104b40 <argptr>
80104e64:	83 c4 10             	add    $0x10,%esp
80104e67:	85 c0                	test   %eax,%eax
80104e69:	78 15                	js     80104e80 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104e6b:	83 ec 08             	sub    $0x8,%esp
80104e6e:	ff 75 f4             	pushl  -0xc(%ebp)
80104e71:	ff 75 f0             	pushl  -0x10(%ebp)
80104e74:	e8 87 c0 ff ff       	call   80100f00 <filestat>
80104e79:	83 c4 10             	add    $0x10,%esp
}
80104e7c:	c9                   	leave  
80104e7d:	c3                   	ret    
80104e7e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104e85:	c9                   	leave  
80104e86:	c3                   	ret    
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	57                   	push   %edi
80104e94:	56                   	push   %esi
80104e95:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e96:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104e99:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e9c:	50                   	push   %eax
80104e9d:	6a 00                	push   $0x0
80104e9f:	e8 fc fc ff ff       	call   80104ba0 <argstr>
80104ea4:	83 c4 10             	add    $0x10,%esp
80104ea7:	85 c0                	test   %eax,%eax
80104ea9:	0f 88 fb 00 00 00    	js     80104faa <sys_link+0x11a>
80104eaf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104eb2:	83 ec 08             	sub    $0x8,%esp
80104eb5:	50                   	push   %eax
80104eb6:	6a 01                	push   $0x1
80104eb8:	e8 e3 fc ff ff       	call   80104ba0 <argstr>
80104ebd:	83 c4 10             	add    $0x10,%esp
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	0f 88 e2 00 00 00    	js     80104faa <sys_link+0x11a>
    return -1;

  begin_op();
80104ec8:	e8 23 e0 ff ff       	call   80102ef0 <begin_op>
  if((ip = namei(old)) == 0){
80104ecd:	83 ec 0c             	sub    $0xc,%esp
80104ed0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104ed3:	e8 e8 cf ff ff       	call   80101ec0 <namei>
80104ed8:	83 c4 10             	add    $0x10,%esp
80104edb:	85 c0                	test   %eax,%eax
80104edd:	89 c3                	mov    %eax,%ebx
80104edf:	0f 84 f3 00 00 00    	je     80104fd8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104ee5:	83 ec 0c             	sub    $0xc,%esp
80104ee8:	50                   	push   %eax
80104ee9:	e8 82 c7 ff ff       	call   80101670 <ilock>
  if(ip->type == T_DIR){
80104eee:	83 c4 10             	add    $0x10,%esp
80104ef1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ef6:	0f 84 c4 00 00 00    	je     80104fc0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104efc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f01:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104f04:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104f07:	53                   	push   %ebx
80104f08:	e8 b3 c6 ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
80104f0d:	89 1c 24             	mov    %ebx,(%esp)
80104f10:	e8 3b c8 ff ff       	call   80101750 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104f15:	58                   	pop    %eax
80104f16:	5a                   	pop    %edx
80104f17:	57                   	push   %edi
80104f18:	ff 75 d0             	pushl  -0x30(%ebp)
80104f1b:	e8 c0 cf ff ff       	call   80101ee0 <nameiparent>
80104f20:	83 c4 10             	add    $0x10,%esp
80104f23:	85 c0                	test   %eax,%eax
80104f25:	89 c6                	mov    %eax,%esi
80104f27:	74 5b                	je     80104f84 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104f29:	83 ec 0c             	sub    $0xc,%esp
80104f2c:	50                   	push   %eax
80104f2d:	e8 3e c7 ff ff       	call   80101670 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f32:	83 c4 10             	add    $0x10,%esp
80104f35:	8b 03                	mov    (%ebx),%eax
80104f37:	39 06                	cmp    %eax,(%esi)
80104f39:	75 3d                	jne    80104f78 <sys_link+0xe8>
80104f3b:	83 ec 04             	sub    $0x4,%esp
80104f3e:	ff 73 04             	pushl  0x4(%ebx)
80104f41:	57                   	push   %edi
80104f42:	56                   	push   %esi
80104f43:	e8 b8 ce ff ff       	call   80101e00 <dirlink>
80104f48:	83 c4 10             	add    $0x10,%esp
80104f4b:	85 c0                	test   %eax,%eax
80104f4d:	78 29                	js     80104f78 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104f4f:	83 ec 0c             	sub    $0xc,%esp
80104f52:	56                   	push   %esi
80104f53:	e8 a8 c9 ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104f58:	89 1c 24             	mov    %ebx,(%esp)
80104f5b:	e8 40 c8 ff ff       	call   801017a0 <iput>

  end_op();
80104f60:	e8 fb df ff ff       	call   80102f60 <end_op>

  return 0;
80104f65:	83 c4 10             	add    $0x10,%esp
80104f68:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f6d:	5b                   	pop    %ebx
80104f6e:	5e                   	pop    %esi
80104f6f:	5f                   	pop    %edi
80104f70:	5d                   	pop    %ebp
80104f71:	c3                   	ret    
80104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104f78:	83 ec 0c             	sub    $0xc,%esp
80104f7b:	56                   	push   %esi
80104f7c:	e8 7f c9 ff ff       	call   80101900 <iunlockput>
    goto bad;
80104f81:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104f84:	83 ec 0c             	sub    $0xc,%esp
80104f87:	53                   	push   %ebx
80104f88:	e8 e3 c6 ff ff       	call   80101670 <ilock>
  ip->nlink--;
80104f8d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f92:	89 1c 24             	mov    %ebx,(%esp)
80104f95:	e8 26 c6 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104f9a:	89 1c 24             	mov    %ebx,(%esp)
80104f9d:	e8 5e c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104fa2:	e8 b9 df ff ff       	call   80102f60 <end_op>
  return -1;
80104fa7:	83 c4 10             	add    $0x10,%esp
}
80104faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104fad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fb2:	5b                   	pop    %ebx
80104fb3:	5e                   	pop    %esi
80104fb4:	5f                   	pop    %edi
80104fb5:	5d                   	pop    %ebp
80104fb6:	c3                   	ret    
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
80104fc3:	53                   	push   %ebx
80104fc4:	e8 37 c9 ff ff       	call   80101900 <iunlockput>
    end_op();
80104fc9:	e8 92 df ff ff       	call   80102f60 <end_op>
    return -1;
80104fce:	83 c4 10             	add    $0x10,%esp
80104fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd6:	eb 92                	jmp    80104f6a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104fd8:	e8 83 df ff ff       	call   80102f60 <end_op>
    return -1;
80104fdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe2:	eb 86                	jmp    80104f6a <sys_link+0xda>
80104fe4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ff0 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	57                   	push   %edi
80104ff4:	56                   	push   %esi
80104ff5:	53                   	push   %ebx
80104ff6:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104ff9:	bb 20 00 00 00       	mov    $0x20,%ebx
80104ffe:	83 ec 1c             	sub    $0x1c,%esp
80105001:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105004:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105008:	77 0e                	ja     80105018 <isdirempty+0x28>
8010500a:	eb 34                	jmp    80105040 <isdirempty+0x50>
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105010:	83 c3 10             	add    $0x10,%ebx
80105013:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105016:	76 28                	jbe    80105040 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105018:	6a 10                	push   $0x10
8010501a:	53                   	push   %ebx
8010501b:	57                   	push   %edi
8010501c:	56                   	push   %esi
8010501d:	e8 2e c9 ff ff       	call   80101950 <readi>
80105022:	83 c4 10             	add    $0x10,%esp
80105025:	83 f8 10             	cmp    $0x10,%eax
80105028:	75 23                	jne    8010504d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010502a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010502f:	74 df                	je     80105010 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105031:	8d 65 f4             	lea    -0xc(%ebp),%esp

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
80105034:	31 c0                	xor    %eax,%eax
  }
  return 1;
}
80105036:	5b                   	pop    %ebx
80105037:	5e                   	pop    %esi
80105038:	5f                   	pop    %edi
80105039:	5d                   	pop    %ebp
8010503a:	c3                   	ret    
8010503b:	90                   	nop
8010503c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105040:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105043:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105048:	5b                   	pop    %ebx
80105049:	5e                   	pop    %esi
8010504a:	5f                   	pop    %edi
8010504b:	5d                   	pop    %ebp
8010504c:	c3                   	ret    
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010504d:	83 ec 0c             	sub    $0xc,%esp
80105050:	68 1c 7a 10 80       	push   $0x80107a1c
80105055:	e8 16 b3 ff ff       	call   80100370 <panic>
8010505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105060 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105066:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105069:	83 ec 44             	sub    $0x44,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010506c:	50                   	push   %eax
8010506d:	6a 00                	push   $0x0
8010506f:	e8 2c fb ff ff       	call   80104ba0 <argstr>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	0f 88 51 01 00 00    	js     801051d0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010507f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105082:	e8 69 de ff ff       	call   80102ef0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105087:	83 ec 08             	sub    $0x8,%esp
8010508a:	53                   	push   %ebx
8010508b:	ff 75 c0             	pushl  -0x40(%ebp)
8010508e:	e8 4d ce ff ff       	call   80101ee0 <nameiparent>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	89 c6                	mov    %eax,%esi
8010509a:	0f 84 37 01 00 00    	je     801051d7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
801050a0:	83 ec 0c             	sub    $0xc,%esp
801050a3:	50                   	push   %eax
801050a4:	e8 c7 c5 ff ff       	call   80101670 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050a9:	58                   	pop    %eax
801050aa:	5a                   	pop    %edx
801050ab:	68 1d 74 10 80       	push   $0x8010741d
801050b0:	53                   	push   %ebx
801050b1:	e8 ca ca ff ff       	call   80101b80 <namecmp>
801050b6:	83 c4 10             	add    $0x10,%esp
801050b9:	85 c0                	test   %eax,%eax
801050bb:	0f 84 d3 00 00 00    	je     80105194 <sys_unlink+0x134>
801050c1:	83 ec 08             	sub    $0x8,%esp
801050c4:	68 1c 74 10 80       	push   $0x8010741c
801050c9:	53                   	push   %ebx
801050ca:	e8 b1 ca ff ff       	call   80101b80 <namecmp>
801050cf:	83 c4 10             	add    $0x10,%esp
801050d2:	85 c0                	test   %eax,%eax
801050d4:	0f 84 ba 00 00 00    	je     80105194 <sys_unlink+0x134>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801050da:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050dd:	83 ec 04             	sub    $0x4,%esp
801050e0:	50                   	push   %eax
801050e1:	53                   	push   %ebx
801050e2:	56                   	push   %esi
801050e3:	e8 b8 ca ff ff       	call   80101ba0 <dirlookup>
801050e8:	83 c4 10             	add    $0x10,%esp
801050eb:	85 c0                	test   %eax,%eax
801050ed:	89 c3                	mov    %eax,%ebx
801050ef:	0f 84 9f 00 00 00    	je     80105194 <sys_unlink+0x134>
    goto bad;
  ilock(ip);
801050f5:	83 ec 0c             	sub    $0xc,%esp
801050f8:	50                   	push   %eax
801050f9:	e8 72 c5 ff ff       	call   80101670 <ilock>

  if(ip->nlink < 1)
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105106:	0f 8e e4 00 00 00    	jle    801051f0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010510c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105111:	74 65                	je     80105178 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105113:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105116:	83 ec 04             	sub    $0x4,%esp
80105119:	6a 10                	push   $0x10
8010511b:	6a 00                	push   $0x0
8010511d:	57                   	push   %edi
8010511e:	e8 bd f6 ff ff       	call   801047e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105123:	6a 10                	push   $0x10
80105125:	ff 75 c4             	pushl  -0x3c(%ebp)
80105128:	57                   	push   %edi
80105129:	56                   	push   %esi
8010512a:	e8 21 c9 ff ff       	call   80101a50 <writei>
8010512f:	83 c4 20             	add    $0x20,%esp
80105132:	83 f8 10             	cmp    $0x10,%eax
80105135:	0f 85 a8 00 00 00    	jne    801051e3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010513b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105140:	74 76                	je     801051b8 <sys_unlink+0x158>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105142:	83 ec 0c             	sub    $0xc,%esp
80105145:	56                   	push   %esi
80105146:	e8 b5 c7 ff ff       	call   80101900 <iunlockput>

  ip->nlink--;
8010514b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105150:	89 1c 24             	mov    %ebx,(%esp)
80105153:	e8 68 c4 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80105158:	89 1c 24             	mov    %ebx,(%esp)
8010515b:	e8 a0 c7 ff ff       	call   80101900 <iunlockput>

  end_op();
80105160:	e8 fb dd ff ff       	call   80102f60 <end_op>

  return 0;
80105165:	83 c4 10             	add    $0x10,%esp
80105168:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010516a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010516d:	5b                   	pop    %ebx
8010516e:	5e                   	pop    %esi
8010516f:	5f                   	pop    %edi
80105170:	5d                   	pop    %ebp
80105171:	c3                   	ret    
80105172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105178:	83 ec 0c             	sub    $0xc,%esp
8010517b:	53                   	push   %ebx
8010517c:	e8 6f fe ff ff       	call   80104ff0 <isdirempty>
80105181:	83 c4 10             	add    $0x10,%esp
80105184:	85 c0                	test   %eax,%eax
80105186:	75 8b                	jne    80105113 <sys_unlink+0xb3>
    iunlockput(ip);
80105188:	83 ec 0c             	sub    $0xc,%esp
8010518b:	53                   	push   %ebx
8010518c:	e8 6f c7 ff ff       	call   80101900 <iunlockput>
    goto bad;
80105191:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105194:	83 ec 0c             	sub    $0xc,%esp
80105197:	56                   	push   %esi
80105198:	e8 63 c7 ff ff       	call   80101900 <iunlockput>
  end_op();
8010519d:	e8 be dd ff ff       	call   80102f60 <end_op>
  return -1;
801051a2:	83 c4 10             	add    $0x10,%esp
}
801051a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801051a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051ad:	5b                   	pop    %ebx
801051ae:	5e                   	pop    %esi
801051af:	5f                   	pop    %edi
801051b0:	5d                   	pop    %ebp
801051b1:	c3                   	ret    
801051b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801051b8:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801051bd:	83 ec 0c             	sub    $0xc,%esp
801051c0:	56                   	push   %esi
801051c1:	e8 fa c3 ff ff       	call   801015c0 <iupdate>
801051c6:	83 c4 10             	add    $0x10,%esp
801051c9:	e9 74 ff ff ff       	jmp    80105142 <sys_unlink+0xe2>
801051ce:	66 90                	xchg   %ax,%ax
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d5:	eb 93                	jmp    8010516a <sys_unlink+0x10a>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801051d7:	e8 84 dd ff ff       	call   80102f60 <end_op>
    return -1;
801051dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e1:	eb 87                	jmp    8010516a <sys_unlink+0x10a>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801051e3:	83 ec 0c             	sub    $0xc,%esp
801051e6:	68 31 74 10 80       	push   $0x80107431
801051eb:	e8 80 b1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801051f0:	83 ec 0c             	sub    $0xc,%esp
801051f3:	68 1f 74 10 80       	push   $0x8010741f
801051f8:	e8 73 b1 ff ff       	call   80100370 <panic>
801051fd:	8d 76 00             	lea    0x0(%esi),%esi

80105200 <create>:
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
80105205:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105206:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105209:	83 ec 44             	sub    $0x44,%esp
8010520c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010520f:	8b 55 10             	mov    0x10(%ebp),%edx
80105212:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105215:	56                   	push   %esi
80105216:	ff 75 08             	pushl  0x8(%ebp)
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105219:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010521c:	89 55 c0             	mov    %edx,-0x40(%ebp)
8010521f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105222:	e8 b9 cc ff ff       	call   80101ee0 <nameiparent>
80105227:	83 c4 10             	add    $0x10,%esp
8010522a:	85 c0                	test   %eax,%eax
8010522c:	0f 84 ee 00 00 00    	je     80105320 <create+0x120>
    return 0;
  ilock(dp);
80105232:	83 ec 0c             	sub    $0xc,%esp
80105235:	89 c7                	mov    %eax,%edi
80105237:	50                   	push   %eax
80105238:	e8 33 c4 ff ff       	call   80101670 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010523d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105240:	83 c4 0c             	add    $0xc,%esp
80105243:	50                   	push   %eax
80105244:	56                   	push   %esi
80105245:	57                   	push   %edi
80105246:	e8 55 c9 ff ff       	call   80101ba0 <dirlookup>
8010524b:	83 c4 10             	add    $0x10,%esp
8010524e:	85 c0                	test   %eax,%eax
80105250:	89 c3                	mov    %eax,%ebx
80105252:	74 4c                	je     801052a0 <create+0xa0>
    iunlockput(dp);
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	57                   	push   %edi
80105258:	e8 a3 c6 ff ff       	call   80101900 <iunlockput>
    ilock(ip);
8010525d:	89 1c 24             	mov    %ebx,(%esp)
80105260:	e8 0b c4 ff ff       	call   80101670 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105265:	83 c4 10             	add    $0x10,%esp
80105268:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010526d:	75 11                	jne    80105280 <create+0x80>
8010526f:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80105274:	89 d8                	mov    %ebx,%eax
80105276:	75 08                	jne    80105280 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010527b:	5b                   	pop    %ebx
8010527c:	5e                   	pop    %esi
8010527d:	5f                   	pop    %edi
8010527e:	5d                   	pop    %ebp
8010527f:	c3                   	ret    
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105280:	83 ec 0c             	sub    $0xc,%esp
80105283:	53                   	push   %ebx
80105284:	e8 77 c6 ff ff       	call   80101900 <iunlockput>
    return 0;
80105289:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010528c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010528f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105291:	5b                   	pop    %ebx
80105292:	5e                   	pop    %esi
80105293:	5f                   	pop    %edi
80105294:	5d                   	pop    %ebp
80105295:	c3                   	ret    
80105296:	8d 76 00             	lea    0x0(%esi),%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801052a0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801052a4:	83 ec 08             	sub    $0x8,%esp
801052a7:	50                   	push   %eax
801052a8:	ff 37                	pushl  (%edi)
801052aa:	e8 51 c2 ff ff       	call   80101500 <ialloc>
801052af:	83 c4 10             	add    $0x10,%esp
801052b2:	85 c0                	test   %eax,%eax
801052b4:	89 c3                	mov    %eax,%ebx
801052b6:	0f 84 cc 00 00 00    	je     80105388 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
801052bc:	83 ec 0c             	sub    $0xc,%esp
801052bf:	50                   	push   %eax
801052c0:	e8 ab c3 ff ff       	call   80101670 <ilock>
  ip->major = major;
801052c5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801052c9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801052cd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801052d1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801052d5:	b8 01 00 00 00       	mov    $0x1,%eax
801052da:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801052de:	89 1c 24             	mov    %ebx,(%esp)
801052e1:	e8 da c2 ff ff       	call   801015c0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801052e6:	83 c4 10             	add    $0x10,%esp
801052e9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801052ee:	74 40                	je     80105330 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801052f0:	83 ec 04             	sub    $0x4,%esp
801052f3:	ff 73 04             	pushl  0x4(%ebx)
801052f6:	56                   	push   %esi
801052f7:	57                   	push   %edi
801052f8:	e8 03 cb ff ff       	call   80101e00 <dirlink>
801052fd:	83 c4 10             	add    $0x10,%esp
80105300:	85 c0                	test   %eax,%eax
80105302:	78 77                	js     8010537b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	57                   	push   %edi
80105308:	e8 f3 c5 ff ff       	call   80101900 <iunlockput>

  return ip;
8010530d:	83 c4 10             	add    $0x10,%esp
}
80105310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80105313:	89 d8                	mov    %ebx,%eax
}
80105315:	5b                   	pop    %ebx
80105316:	5e                   	pop    %esi
80105317:	5f                   	pop    %edi
80105318:	5d                   	pop    %ebp
80105319:	c3                   	ret    
8010531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105320:	31 c0                	xor    %eax,%eax
80105322:	e9 51 ff ff ff       	jmp    80105278 <create+0x78>
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105330:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105335:	83 ec 0c             	sub    $0xc,%esp
80105338:	57                   	push   %edi
80105339:	e8 82 c2 ff ff       	call   801015c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010533e:	83 c4 0c             	add    $0xc,%esp
80105341:	ff 73 04             	pushl  0x4(%ebx)
80105344:	68 1d 74 10 80       	push   $0x8010741d
80105349:	53                   	push   %ebx
8010534a:	e8 b1 ca ff ff       	call   80101e00 <dirlink>
8010534f:	83 c4 10             	add    $0x10,%esp
80105352:	85 c0                	test   %eax,%eax
80105354:	78 18                	js     8010536e <create+0x16e>
80105356:	83 ec 04             	sub    $0x4,%esp
80105359:	ff 77 04             	pushl  0x4(%edi)
8010535c:	68 1c 74 10 80       	push   $0x8010741c
80105361:	53                   	push   %ebx
80105362:	e8 99 ca ff ff       	call   80101e00 <dirlink>
80105367:	83 c4 10             	add    $0x10,%esp
8010536a:	85 c0                	test   %eax,%eax
8010536c:	79 82                	jns    801052f0 <create+0xf0>
      panic("create dots");
8010536e:	83 ec 0c             	sub    $0xc,%esp
80105371:	68 3d 7a 10 80       	push   $0x80107a3d
80105376:	e8 f5 af ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010537b:	83 ec 0c             	sub    $0xc,%esp
8010537e:	68 49 7a 10 80       	push   $0x80107a49
80105383:	e8 e8 af ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105388:	83 ec 0c             	sub    $0xc,%esp
8010538b:	68 2e 7a 10 80       	push   $0x80107a2e
80105390:	e8 db af ff ff       	call   80100370 <panic>
80105395:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801053a9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053ac:	50                   	push   %eax
801053ad:	6a 00                	push   $0x0
801053af:	e8 ec f7 ff ff       	call   80104ba0 <argstr>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	0f 88 9e 00 00 00    	js     8010545d <sys_open+0xbd>
801053bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053c2:	83 ec 08             	sub    $0x8,%esp
801053c5:	50                   	push   %eax
801053c6:	6a 01                	push   $0x1
801053c8:	e8 23 f7 ff ff       	call   80104af0 <argint>
801053cd:	83 c4 10             	add    $0x10,%esp
801053d0:	85 c0                	test   %eax,%eax
801053d2:	0f 88 85 00 00 00    	js     8010545d <sys_open+0xbd>
    return -1;

  begin_op();
801053d8:	e8 13 db ff ff       	call   80102ef0 <begin_op>

  if(omode & O_CREATE){
801053dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801053e1:	0f 85 89 00 00 00    	jne    80105470 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053e7:	83 ec 0c             	sub    $0xc,%esp
801053ea:	ff 75 e0             	pushl  -0x20(%ebp)
801053ed:	e8 ce ca ff ff       	call   80101ec0 <namei>
801053f2:	83 c4 10             	add    $0x10,%esp
801053f5:	85 c0                	test   %eax,%eax
801053f7:	89 c6                	mov    %eax,%esi
801053f9:	0f 84 88 00 00 00    	je     80105487 <sys_open+0xe7>
      end_op();
      return -1;
    }
    ilock(ip);
801053ff:	83 ec 0c             	sub    $0xc,%esp
80105402:	50                   	push   %eax
80105403:	e8 68 c2 ff ff       	call   80101670 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105410:	0f 84 ca 00 00 00    	je     801054e0 <sys_open+0x140>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105416:	e8 55 b9 ff ff       	call   80100d70 <filealloc>
8010541b:	85 c0                	test   %eax,%eax
8010541d:	89 c7                	mov    %eax,%edi
8010541f:	74 2b                	je     8010544c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105421:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105423:	e8 f8 e6 ff ff       	call   80103b20 <myproc>
80105428:	90                   	nop
80105429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105430:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105434:	85 d2                	test   %edx,%edx
80105436:	74 60                	je     80105498 <sys_open+0xf8>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105438:	83 c3 01             	add    $0x1,%ebx
8010543b:	83 fb 10             	cmp    $0x10,%ebx
8010543e:	75 f0                	jne    80105430 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	57                   	push   %edi
80105444:	e8 e7 b9 ff ff       	call   80100e30 <fileclose>
80105449:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010544c:	83 ec 0c             	sub    $0xc,%esp
8010544f:	56                   	push   %esi
80105450:	e8 ab c4 ff ff       	call   80101900 <iunlockput>
    end_op();
80105455:	e8 06 db ff ff       	call   80102f60 <end_op>
    return -1;
8010545a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010545d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105465:	5b                   	pop    %ebx
80105466:	5e                   	pop    %esi
80105467:	5f                   	pop    %edi
80105468:	5d                   	pop    %ebp
80105469:	c3                   	ret    
8010546a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105470:	6a 00                	push   $0x0
80105472:	6a 00                	push   $0x0
80105474:	6a 02                	push   $0x2
80105476:	ff 75 e0             	pushl  -0x20(%ebp)
80105479:	e8 82 fd ff ff       	call   80105200 <create>
    if(ip == 0){
8010547e:	83 c4 10             	add    $0x10,%esp
80105481:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105483:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105485:	75 8f                	jne    80105416 <sys_open+0x76>
      end_op();
80105487:	e8 d4 da ff ff       	call   80102f60 <end_op>
      return -1;
8010548c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105491:	eb 41                	jmp    801054d4 <sys_open+0x134>
80105493:	90                   	nop
80105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105498:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
8010549b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010549f:	56                   	push   %esi
801054a0:	e8 ab c2 ff ff       	call   80101750 <iunlock>
  end_op();
801054a5:	e8 b6 da ff ff       	call   80102f60 <end_op>

  f->type = FD_INODE;
801054aa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054b3:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801054b6:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801054b9:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054c0:	89 d0                	mov    %edx,%eax
801054c2:	83 e0 01             	and    $0x1,%eax
801054c5:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054c8:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054cb:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054ce:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
801054d2:	89 d8                	mov    %ebx,%eax
}
801054d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054d7:	5b                   	pop    %ebx
801054d8:	5e                   	pop    %esi
801054d9:	5f                   	pop    %edi
801054da:	5d                   	pop    %ebp
801054db:	c3                   	ret    
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801054e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054e3:	85 c9                	test   %ecx,%ecx
801054e5:	0f 84 2b ff ff ff    	je     80105416 <sys_open+0x76>
801054eb:	e9 5c ff ff ff       	jmp    8010544c <sys_open+0xac>

801054f0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054f6:	e8 f5 d9 ff ff       	call   80102ef0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054fe:	83 ec 08             	sub    $0x8,%esp
80105501:	50                   	push   %eax
80105502:	6a 00                	push   $0x0
80105504:	e8 97 f6 ff ff       	call   80104ba0 <argstr>
80105509:	83 c4 10             	add    $0x10,%esp
8010550c:	85 c0                	test   %eax,%eax
8010550e:	78 30                	js     80105540 <sys_mkdir+0x50>
80105510:	6a 00                	push   $0x0
80105512:	6a 00                	push   $0x0
80105514:	6a 01                	push   $0x1
80105516:	ff 75 f4             	pushl  -0xc(%ebp)
80105519:	e8 e2 fc ff ff       	call   80105200 <create>
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	85 c0                	test   %eax,%eax
80105523:	74 1b                	je     80105540 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105525:	83 ec 0c             	sub    $0xc,%esp
80105528:	50                   	push   %eax
80105529:	e8 d2 c3 ff ff       	call   80101900 <iunlockput>
  end_op();
8010552e:	e8 2d da ff ff       	call   80102f60 <end_op>
  return 0;
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	31 c0                	xor    %eax,%eax
}
80105538:	c9                   	leave  
80105539:	c3                   	ret    
8010553a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105540:	e8 1b da ff ff       	call   80102f60 <end_op>
    return -1;
80105545:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010554a:	c9                   	leave  
8010554b:	c3                   	ret    
8010554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105550 <sys_mknod>:

int
sys_mknod(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105556:	e8 95 d9 ff ff       	call   80102ef0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010555b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010555e:	83 ec 08             	sub    $0x8,%esp
80105561:	50                   	push   %eax
80105562:	6a 00                	push   $0x0
80105564:	e8 37 f6 ff ff       	call   80104ba0 <argstr>
80105569:	83 c4 10             	add    $0x10,%esp
8010556c:	85 c0                	test   %eax,%eax
8010556e:	78 60                	js     801055d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105570:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105573:	83 ec 08             	sub    $0x8,%esp
80105576:	50                   	push   %eax
80105577:	6a 01                	push   $0x1
80105579:	e8 72 f5 ff ff       	call   80104af0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	85 c0                	test   %eax,%eax
80105583:	78 4b                	js     801055d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105585:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105588:	83 ec 08             	sub    $0x8,%esp
8010558b:	50                   	push   %eax
8010558c:	6a 02                	push   $0x2
8010558e:	e8 5d f5 ff ff       	call   80104af0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105593:	83 c4 10             	add    $0x10,%esp
80105596:	85 c0                	test   %eax,%eax
80105598:	78 36                	js     801055d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010559a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010559e:	50                   	push   %eax
8010559f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
801055a3:	50                   	push   %eax
801055a4:	6a 03                	push   $0x3
801055a6:	ff 75 ec             	pushl  -0x14(%ebp)
801055a9:	e8 52 fc ff ff       	call   80105200 <create>
801055ae:	83 c4 10             	add    $0x10,%esp
801055b1:	85 c0                	test   %eax,%eax
801055b3:	74 1b                	je     801055d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801055b5:	83 ec 0c             	sub    $0xc,%esp
801055b8:	50                   	push   %eax
801055b9:	e8 42 c3 ff ff       	call   80101900 <iunlockput>
  end_op();
801055be:	e8 9d d9 ff ff       	call   80102f60 <end_op>
  return 0;
801055c3:	83 c4 10             	add    $0x10,%esp
801055c6:	31 c0                	xor    %eax,%eax
}
801055c8:	c9                   	leave  
801055c9:	c3                   	ret    
801055ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801055d0:	e8 8b d9 ff ff       	call   80102f60 <end_op>
    return -1;
801055d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801055da:	c9                   	leave  
801055db:	c3                   	ret    
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_chdir>:

int
sys_chdir(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	56                   	push   %esi
801055e4:	53                   	push   %ebx
801055e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801055e8:	e8 33 e5 ff ff       	call   80103b20 <myproc>
801055ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801055ef:	e8 fc d8 ff ff       	call   80102ef0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801055f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f7:	83 ec 08             	sub    $0x8,%esp
801055fa:	50                   	push   %eax
801055fb:	6a 00                	push   $0x0
801055fd:	e8 9e f5 ff ff       	call   80104ba0 <argstr>
80105602:	83 c4 10             	add    $0x10,%esp
80105605:	85 c0                	test   %eax,%eax
80105607:	78 77                	js     80105680 <sys_chdir+0xa0>
80105609:	83 ec 0c             	sub    $0xc,%esp
8010560c:	ff 75 f4             	pushl  -0xc(%ebp)
8010560f:	e8 ac c8 ff ff       	call   80101ec0 <namei>
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	85 c0                	test   %eax,%eax
80105619:	89 c3                	mov    %eax,%ebx
8010561b:	74 63                	je     80105680 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010561d:	83 ec 0c             	sub    $0xc,%esp
80105620:	50                   	push   %eax
80105621:	e8 4a c0 ff ff       	call   80101670 <ilock>
  if(ip->type != T_DIR){
80105626:	83 c4 10             	add    $0x10,%esp
80105629:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010562e:	75 30                	jne    80105660 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105630:	83 ec 0c             	sub    $0xc,%esp
80105633:	53                   	push   %ebx
80105634:	e8 17 c1 ff ff       	call   80101750 <iunlock>
  iput(curproc->cwd);
80105639:	58                   	pop    %eax
8010563a:	ff 76 68             	pushl  0x68(%esi)
8010563d:	e8 5e c1 ff ff       	call   801017a0 <iput>
  end_op();
80105642:	e8 19 d9 ff ff       	call   80102f60 <end_op>
  curproc->cwd = ip;
80105647:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010564a:	83 c4 10             	add    $0x10,%esp
8010564d:	31 c0                	xor    %eax,%eax
}
8010564f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105652:	5b                   	pop    %ebx
80105653:	5e                   	pop    %esi
80105654:	5d                   	pop    %ebp
80105655:	c3                   	ret    
80105656:	8d 76 00             	lea    0x0(%esi),%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	53                   	push   %ebx
80105664:	e8 97 c2 ff ff       	call   80101900 <iunlockput>
    end_op();
80105669:	e8 f2 d8 ff ff       	call   80102f60 <end_op>
    return -1;
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105676:	eb d7                	jmp    8010564f <sys_chdir+0x6f>
80105678:	90                   	nop
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105680:	e8 db d8 ff ff       	call   80102f60 <end_op>
    return -1;
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568a:	eb c3                	jmp    8010564f <sys_chdir+0x6f>
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105690 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	57                   	push   %edi
80105694:	56                   	push   %esi
80105695:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105696:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010569c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056a2:	50                   	push   %eax
801056a3:	6a 00                	push   $0x0
801056a5:	e8 f6 f4 ff ff       	call   80104ba0 <argstr>
801056aa:	83 c4 10             	add    $0x10,%esp
801056ad:	85 c0                	test   %eax,%eax
801056af:	78 7f                	js     80105730 <sys_exec+0xa0>
801056b1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056b7:	83 ec 08             	sub    $0x8,%esp
801056ba:	50                   	push   %eax
801056bb:	6a 01                	push   $0x1
801056bd:	e8 2e f4 ff ff       	call   80104af0 <argint>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	78 67                	js     80105730 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056c9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801056cf:	83 ec 04             	sub    $0x4,%esp
801056d2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801056d8:	68 80 00 00 00       	push   $0x80
801056dd:	6a 00                	push   $0x0
801056df:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801056e5:	50                   	push   %eax
801056e6:	31 db                	xor    %ebx,%ebx
801056e8:	e8 f3 f0 ff ff       	call   801047e0 <memset>
801056ed:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056f0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801056f6:	83 ec 08             	sub    $0x8,%esp
801056f9:	57                   	push   %edi
801056fa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801056fd:	50                   	push   %eax
801056fe:	e8 4d f3 ff ff       	call   80104a50 <fetchint>
80105703:	83 c4 10             	add    $0x10,%esp
80105706:	85 c0                	test   %eax,%eax
80105708:	78 26                	js     80105730 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010570a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105710:	85 c0                	test   %eax,%eax
80105712:	74 2c                	je     80105740 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105714:	83 ec 08             	sub    $0x8,%esp
80105717:	56                   	push   %esi
80105718:	50                   	push   %eax
80105719:	e8 72 f3 ff ff       	call   80104a90 <fetchstr>
8010571e:	83 c4 10             	add    $0x10,%esp
80105721:	85 c0                	test   %eax,%eax
80105723:	78 0b                	js     80105730 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105725:	83 c3 01             	add    $0x1,%ebx
80105728:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010572b:	83 fb 20             	cmp    $0x20,%ebx
8010572e:	75 c0                	jne    801056f0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105730:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105733:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105738:	5b                   	pop    %ebx
80105739:	5e                   	pop    %esi
8010573a:	5f                   	pop    %edi
8010573b:	5d                   	pop    %ebp
8010573c:	c3                   	ret    
8010573d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105740:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105746:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105749:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105750:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105754:	50                   	push   %eax
80105755:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010575b:	e8 90 b2 ff ff       	call   801009f0 <exec>
80105760:	83 c4 10             	add    $0x10,%esp
}
80105763:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105766:	5b                   	pop    %ebx
80105767:	5e                   	pop    %esi
80105768:	5f                   	pop    %edi
80105769:	5d                   	pop    %ebp
8010576a:	c3                   	ret    
8010576b:	90                   	nop
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_pipe>:

int
sys_pipe(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
80105775:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105776:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105779:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010577c:	6a 08                	push   $0x8
8010577e:	50                   	push   %eax
8010577f:	6a 00                	push   $0x0
80105781:	e8 ba f3 ff ff       	call   80104b40 <argptr>
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	85 c0                	test   %eax,%eax
8010578b:	78 4a                	js     801057d7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010578d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105790:	83 ec 08             	sub    $0x8,%esp
80105793:	50                   	push   %eax
80105794:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105797:	50                   	push   %eax
80105798:	e8 f3 dd ff ff       	call   80103590 <pipealloc>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 33                	js     801057d7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801057a4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057a6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801057a9:	e8 72 e3 ff ff       	call   80103b20 <myproc>
801057ae:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801057b0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057b4:	85 f6                	test   %esi,%esi
801057b6:	74 30                	je     801057e8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801057b8:	83 c3 01             	add    $0x1,%ebx
801057bb:	83 fb 10             	cmp    $0x10,%ebx
801057be:	75 f0                	jne    801057b0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	ff 75 e0             	pushl  -0x20(%ebp)
801057c6:	e8 65 b6 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
801057cb:	58                   	pop    %eax
801057cc:	ff 75 e4             	pushl  -0x1c(%ebp)
801057cf:	e8 5c b6 ff ff       	call   80100e30 <fileclose>
    return -1;
801057d4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801057d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801057da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801057df:	5b                   	pop    %ebx
801057e0:	5e                   	pop    %esi
801057e1:	5f                   	pop    %edi
801057e2:	5d                   	pop    %ebp
801057e3:	c3                   	ret    
801057e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801057e8:	8d 73 08             	lea    0x8(%ebx),%esi
801057eb:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801057f2:	e8 29 e3 ff ff       	call   80103b20 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801057f7:	31 d2                	xor    %edx,%edx
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105800:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105804:	85 c9                	test   %ecx,%ecx
80105806:	74 18                	je     80105820 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105808:	83 c2 01             	add    $0x1,%edx
8010580b:	83 fa 10             	cmp    $0x10,%edx
8010580e:	75 f0                	jne    80105800 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105810:	e8 0b e3 ff ff       	call   80103b20 <myproc>
80105815:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010581c:	00 
8010581d:	eb a1                	jmp    801057c0 <sys_pipe+0x50>
8010581f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105820:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105824:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105827:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105829:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010582c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010582f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105832:	31 c0                	xor    %eax,%eax
}
80105834:	5b                   	pop    %ebx
80105835:	5e                   	pop    %esi
80105836:	5f                   	pop    %edi
80105837:	5d                   	pop    %ebp
80105838:	c3                   	ret    
80105839:	66 90                	xchg   %ax,%ax
8010583b:	66 90                	xchg   %ax,%ax
8010583d:	66 90                	xchg   %ax,%ax
8010583f:	90                   	nop

80105840 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105846:	e8 65 e8 ff ff       	call   801040b0 <yield>
  return 0;
}
8010584b:	31 c0                	xor    %eax,%eax
8010584d:	c9                   	leave  
8010584e:	c3                   	ret    
8010584f:	90                   	nop

80105850 <sys_fork>:

int
sys_fork(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105853:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105854:	e9 67 e4 ff ff       	jmp    80103cc0 <fork>
80105859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_exit>:
}

int
sys_exit(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	83 ec 08             	sub    $0x8,%esp
  exit();
80105866:	e8 15 e7 ff ff       	call   80103f80 <exit>
  return 0;  // not reached
}
8010586b:	31 c0                	xor    %eax,%eax
8010586d:	c9                   	leave  
8010586e:	c3                   	ret    
8010586f:	90                   	nop

80105870 <sys_wait>:

int
sys_wait(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105873:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105874:	e9 47 e9 ff ff       	jmp    801041c0 <wait>
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_kill>:
}

int
sys_kill(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105886:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105889:	50                   	push   %eax
8010588a:	6a 00                	push   $0x0
8010588c:	e8 5f f2 ff ff       	call   80104af0 <argint>
80105891:	83 c4 10             	add    $0x10,%esp
80105894:	85 c0                	test   %eax,%eax
80105896:	78 18                	js     801058b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105898:	83 ec 0c             	sub    $0xc,%esp
8010589b:	ff 75 f4             	pushl  -0xc(%ebp)
8010589e:	e8 6d ea ff ff       	call   80104310 <kill>
801058a3:	83 c4 10             	add    $0x10,%esp
}
801058a6:	c9                   	leave  
801058a7:	c3                   	ret    
801058a8:	90                   	nop
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801058b5:	c9                   	leave  
801058b6:	c3                   	ret    
801058b7:	89 f6                	mov    %esi,%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058c0 <sys_getpid>:

int
sys_getpid(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058c6:	e8 55 e2 ff ff       	call   80103b20 <myproc>
801058cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801058ce:	c9                   	leave  
801058cf:	c3                   	ret    

801058d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801058d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801058d7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801058da:	50                   	push   %eax
801058db:	6a 00                	push   $0x0
801058dd:	e8 0e f2 ff ff       	call   80104af0 <argint>
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	85 c0                	test   %eax,%eax
801058e7:	78 27                	js     80105910 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801058e9:	e8 32 e2 ff ff       	call   80103b20 <myproc>
  if(growproc(n) < 0)
801058ee:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801058f1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801058f3:	ff 75 f4             	pushl  -0xc(%ebp)
801058f6:	e8 45 e3 ff ff       	call   80103c40 <growproc>
801058fb:	83 c4 10             	add    $0x10,%esp
801058fe:	85 c0                	test   %eax,%eax
80105900:	78 0e                	js     80105910 <sys_sbrk+0x40>
    return -1;
  return addr;
80105902:	89 d8                	mov    %ebx,%eax
}
80105904:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105907:	c9                   	leave  
80105908:	c3                   	ret    
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105915:	eb ed                	jmp    80105904 <sys_sbrk+0x34>
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105924:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105927:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010592a:	50                   	push   %eax
8010592b:	6a 00                	push   $0x0
8010592d:	e8 be f1 ff ff       	call   80104af0 <argint>
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	85 c0                	test   %eax,%eax
80105937:	0f 88 8a 00 00 00    	js     801059c7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010593d:	83 ec 0c             	sub    $0xc,%esp
80105940:	68 60 5d 11 80       	push   $0x80115d60
80105945:	e8 26 ed ff ff       	call   80104670 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010594a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010594d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105950:	8b 1d a0 65 11 80    	mov    0x801165a0,%ebx
  while(ticks - ticks0 < n){
80105956:	85 d2                	test   %edx,%edx
80105958:	75 27                	jne    80105981 <sys_sleep+0x61>
8010595a:	eb 54                	jmp    801059b0 <sys_sleep+0x90>
8010595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105960:	83 ec 08             	sub    $0x8,%esp
80105963:	68 60 5d 11 80       	push   $0x80115d60
80105968:	68 a0 65 11 80       	push   $0x801165a0
8010596d:	e8 8e e7 ff ff       	call   80104100 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105972:	a1 a0 65 11 80       	mov    0x801165a0,%eax
80105977:	83 c4 10             	add    $0x10,%esp
8010597a:	29 d8                	sub    %ebx,%eax
8010597c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010597f:	73 2f                	jae    801059b0 <sys_sleep+0x90>
    if(myproc()->killed){
80105981:	e8 9a e1 ff ff       	call   80103b20 <myproc>
80105986:	8b 40 24             	mov    0x24(%eax),%eax
80105989:	85 c0                	test   %eax,%eax
8010598b:	74 d3                	je     80105960 <sys_sleep+0x40>
      release(&tickslock);
8010598d:	83 ec 0c             	sub    $0xc,%esp
80105990:	68 60 5d 11 80       	push   $0x80115d60
80105995:	e8 f6 ed ff ff       	call   80104790 <release>
      return -1;
8010599a:	83 c4 10             	add    $0x10,%esp
8010599d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801059a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a5:	c9                   	leave  
801059a6:	c3                   	ret    
801059a7:	89 f6                	mov    %esi,%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	68 60 5d 11 80       	push   $0x80115d60
801059b8:	e8 d3 ed ff ff       	call   80104790 <release>
  return 0;
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	31 c0                	xor    %eax,%eax
}
801059c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059c5:	c9                   	leave  
801059c6:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801059c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059cc:	eb d4                	jmp    801059a2 <sys_sleep+0x82>
801059ce:	66 90                	xchg   %ax,%ax

801059d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	53                   	push   %ebx
801059d4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801059d7:	68 60 5d 11 80       	push   $0x80115d60
801059dc:	e8 8f ec ff ff       	call   80104670 <acquire>
  xticks = ticks;
801059e1:	8b 1d a0 65 11 80    	mov    0x801165a0,%ebx
  release(&tickslock);
801059e7:	c7 04 24 60 5d 11 80 	movl   $0x80115d60,(%esp)
801059ee:	e8 9d ed ff ff       	call   80104790 <release>
  return xticks;
}
801059f3:	89 d8                	mov    %ebx,%eax
801059f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059f8:	c9                   	leave  
801059f9:	c3                   	ret    

801059fa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801059fa:	1e                   	push   %ds
  pushl %es
801059fb:	06                   	push   %es
  pushl %fs
801059fc:	0f a0                	push   %fs
  pushl %gs
801059fe:	0f a8                	push   %gs
  pushal
80105a00:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a01:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a05:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a07:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a09:	54                   	push   %esp
  call trap
80105a0a:	e8 e1 00 00 00       	call   80105af0 <trap>
  addl $4, %esp
80105a0f:	83 c4 04             	add    $0x4,%esp

80105a12 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a12:	61                   	popa   
  popl %gs
80105a13:	0f a9                	pop    %gs
  popl %fs
80105a15:	0f a1                	pop    %fs
  popl %es
80105a17:	07                   	pop    %es
  popl %ds
80105a18:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a19:	83 c4 08             	add    $0x8,%esp
  iret
80105a1c:	cf                   	iret   
80105a1d:	66 90                	xchg   %ax,%ax
80105a1f:	90                   	nop

80105a20 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105a20:	31 c0                	xor    %eax,%eax
80105a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a28:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
80105a2f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105a34:	c6 04 c5 a4 5d 11 80 	movb   $0x0,-0x7feea25c(,%eax,8)
80105a3b:	00 
80105a3c:	66 89 0c c5 a2 5d 11 	mov    %cx,-0x7feea25e(,%eax,8)
80105a43:	80 
80105a44:	c6 04 c5 a5 5d 11 80 	movb   $0x8e,-0x7feea25b(,%eax,8)
80105a4b:	8e 
80105a4c:	66 89 14 c5 a0 5d 11 	mov    %dx,-0x7feea260(,%eax,8)
80105a53:	80 
80105a54:	c1 ea 10             	shr    $0x10,%edx
80105a57:	66 89 14 c5 a6 5d 11 	mov    %dx,-0x7feea25a(,%eax,8)
80105a5e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105a5f:	83 c0 01             	add    $0x1,%eax
80105a62:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a67:	75 bf                	jne    80105a28 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a69:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a6a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a6f:	89 e5                	mov    %esp,%ebp
80105a71:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a74:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105a79:	68 59 7a 10 80       	push   $0x80107a59
80105a7e:	68 60 5d 11 80       	push   $0x80115d60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a83:	66 89 15 a2 5f 11 80 	mov    %dx,0x80115fa2
80105a8a:	c6 05 a4 5f 11 80 00 	movb   $0x0,0x80115fa4
80105a91:	66 a3 a0 5f 11 80    	mov    %ax,0x80115fa0
80105a97:	c1 e8 10             	shr    $0x10,%eax
80105a9a:	c6 05 a5 5f 11 80 ef 	movb   $0xef,0x80115fa5
80105aa1:	66 a3 a6 5f 11 80    	mov    %ax,0x80115fa6

  initlock(&tickslock, "time");
80105aa7:	e8 c4 ea ff ff       	call   80104570 <initlock>
}
80105aac:	83 c4 10             	add    $0x10,%esp
80105aaf:	c9                   	leave  
80105ab0:	c3                   	ret    
80105ab1:	eb 0d                	jmp    80105ac0 <idtinit>
80105ab3:	90                   	nop
80105ab4:	90                   	nop
80105ab5:	90                   	nop
80105ab6:	90                   	nop
80105ab7:	90                   	nop
80105ab8:	90                   	nop
80105ab9:	90                   	nop
80105aba:	90                   	nop
80105abb:	90                   	nop
80105abc:	90                   	nop
80105abd:	90                   	nop
80105abe:	90                   	nop
80105abf:	90                   	nop

80105ac0 <idtinit>:

void
idtinit(void)
{
80105ac0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105ac1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ac6:	89 e5                	mov    %esp,%ebp
80105ac8:	83 ec 10             	sub    $0x10,%esp
80105acb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105acf:	b8 a0 5d 11 80       	mov    $0x80115da0,%eax
80105ad4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ad8:	c1 e8 10             	shr    $0x10,%eax
80105adb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105adf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ae2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ae5:	c9                   	leave  
80105ae6:	c3                   	ret    
80105ae7:	89 f6                	mov    %esi,%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105af0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	57                   	push   %edi
80105af4:	56                   	push   %esi
80105af5:	53                   	push   %ebx
80105af6:	83 ec 1c             	sub    $0x1c,%esp
80105af9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105afc:	8b 47 30             	mov    0x30(%edi),%eax
80105aff:	83 f8 40             	cmp    $0x40,%eax
80105b02:	0f 84 88 01 00 00    	je     80105c90 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b08:	83 e8 20             	sub    $0x20,%eax
80105b0b:	83 f8 1f             	cmp    $0x1f,%eax
80105b0e:	77 10                	ja     80105b20 <trap+0x30>
80105b10:	ff 24 85 00 7b 10 80 	jmp    *-0x7fef8500(,%eax,4)
80105b17:	89 f6                	mov    %esi,%esi
80105b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    //TODO CASE TRAP 14 PGFLT IF IN SWITCH FILE: BRING FROM THERE, ELSE GO DEFAULT

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b20:	e8 fb df ff ff       	call   80103b20 <myproc>
80105b25:	85 c0                	test   %eax,%eax
80105b27:	0f 84 d7 01 00 00    	je     80105d04 <trap+0x214>
80105b2d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105b31:	0f 84 cd 01 00 00    	je     80105d04 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b37:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b3a:	8b 57 38             	mov    0x38(%edi),%edx
80105b3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105b40:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105b43:	e8 b8 df ff ff       	call   80103b00 <cpuid>
80105b48:	8b 77 34             	mov    0x34(%edi),%esi
80105b4b:	8b 5f 30             	mov    0x30(%edi),%ebx
80105b4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105b51:	e8 ca df ff ff       	call   80103b20 <myproc>
80105b56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b59:	e8 c2 df ff ff       	call   80103b20 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105b61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105b64:	51                   	push   %ecx
80105b65:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105b66:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b69:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b6c:	56                   	push   %esi
80105b6d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105b6e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b71:	52                   	push   %edx
80105b72:	ff 70 10             	pushl  0x10(%eax)
80105b75:	68 bc 7a 10 80       	push   $0x80107abc
80105b7a:	e8 e1 aa ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105b7f:	83 c4 20             	add    $0x20,%esp
80105b82:	e8 99 df ff ff       	call   80103b20 <myproc>
80105b87:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105b8e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b90:	e8 8b df ff ff       	call   80103b20 <myproc>
80105b95:	85 c0                	test   %eax,%eax
80105b97:	74 0c                	je     80105ba5 <trap+0xb5>
80105b99:	e8 82 df ff ff       	call   80103b20 <myproc>
80105b9e:	8b 50 24             	mov    0x24(%eax),%edx
80105ba1:	85 d2                	test   %edx,%edx
80105ba3:	75 4b                	jne    80105bf0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ba5:	e8 76 df ff ff       	call   80103b20 <myproc>
80105baa:	85 c0                	test   %eax,%eax
80105bac:	74 0b                	je     80105bb9 <trap+0xc9>
80105bae:	e8 6d df ff ff       	call   80103b20 <myproc>
80105bb3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105bb7:	74 4f                	je     80105c08 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bb9:	e8 62 df ff ff       	call   80103b20 <myproc>
80105bbe:	85 c0                	test   %eax,%eax
80105bc0:	74 1d                	je     80105bdf <trap+0xef>
80105bc2:	e8 59 df ff ff       	call   80103b20 <myproc>
80105bc7:	8b 40 24             	mov    0x24(%eax),%eax
80105bca:	85 c0                	test   %eax,%eax
80105bcc:	74 11                	je     80105bdf <trap+0xef>
80105bce:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105bd2:	83 e0 03             	and    $0x3,%eax
80105bd5:	66 83 f8 03          	cmp    $0x3,%ax
80105bd9:	0f 84 da 00 00 00    	je     80105cb9 <trap+0x1c9>
    exit();
}
80105bdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be2:	5b                   	pop    %ebx
80105be3:	5e                   	pop    %esi
80105be4:	5f                   	pop    %edi
80105be5:	5d                   	pop    %ebp
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bf0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105bf4:	83 e0 03             	and    $0x3,%eax
80105bf7:	66 83 f8 03          	cmp    $0x3,%ax
80105bfb:	75 a8                	jne    80105ba5 <trap+0xb5>
    exit();
80105bfd:	e8 7e e3 ff ff       	call   80103f80 <exit>
80105c02:	eb a1                	jmp    80105ba5 <trap+0xb5>
80105c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c08:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105c0c:	75 ab                	jne    80105bb9 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105c0e:	e8 9d e4 ff ff       	call   801040b0 <yield>
80105c13:	eb a4                	jmp    80105bb9 <trap+0xc9>
80105c15:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105c18:	e8 e3 de ff ff       	call   80103b00 <cpuid>
80105c1d:	85 c0                	test   %eax,%eax
80105c1f:	0f 84 ab 00 00 00    	je     80105cd0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105c25:	e8 86 ce ff ff       	call   80102ab0 <lapiceoi>
    break;
80105c2a:	e9 61 ff ff ff       	jmp    80105b90 <trap+0xa0>
80105c2f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105c30:	e8 3b cd ff ff       	call   80102970 <kbdintr>
    lapiceoi();
80105c35:	e8 76 ce ff ff       	call   80102ab0 <lapiceoi>
    break;
80105c3a:	e9 51 ff ff ff       	jmp    80105b90 <trap+0xa0>
80105c3f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105c40:	e8 5b 02 00 00       	call   80105ea0 <uartintr>
    lapiceoi();
80105c45:	e8 66 ce ff ff       	call   80102ab0 <lapiceoi>
    break;
80105c4a:	e9 41 ff ff ff       	jmp    80105b90 <trap+0xa0>
80105c4f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105c50:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105c54:	8b 77 38             	mov    0x38(%edi),%esi
80105c57:	e8 a4 de ff ff       	call   80103b00 <cpuid>
80105c5c:	56                   	push   %esi
80105c5d:	53                   	push   %ebx
80105c5e:	50                   	push   %eax
80105c5f:	68 64 7a 10 80       	push   $0x80107a64
80105c64:	e8 f7 a9 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105c69:	e8 42 ce ff ff       	call   80102ab0 <lapiceoi>
    break;
80105c6e:	83 c4 10             	add    $0x10,%esp
80105c71:	e9 1a ff ff ff       	jmp    80105b90 <trap+0xa0>
80105c76:	8d 76 00             	lea    0x0(%esi),%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105c80:	e8 6b c7 ff ff       	call   801023f0 <ideintr>
80105c85:	eb 9e                	jmp    80105c25 <trap+0x135>
80105c87:	89 f6                	mov    %esi,%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105c90:	e8 8b de ff ff       	call   80103b20 <myproc>
80105c95:	8b 58 24             	mov    0x24(%eax),%ebx
80105c98:	85 db                	test   %ebx,%ebx
80105c9a:	75 2c                	jne    80105cc8 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
80105c9c:	e8 7f de ff ff       	call   80103b20 <myproc>
80105ca1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105ca4:	e8 37 ef ff ff       	call   80104be0 <syscall>
    if(myproc()->killed)
80105ca9:	e8 72 de ff ff       	call   80103b20 <myproc>
80105cae:	8b 48 24             	mov    0x24(%eax),%ecx
80105cb1:	85 c9                	test   %ecx,%ecx
80105cb3:	0f 84 26 ff ff ff    	je     80105bdf <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105cb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cbc:	5b                   	pop    %ebx
80105cbd:	5e                   	pop    %esi
80105cbe:	5f                   	pop    %edi
80105cbf:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105cc0:	e9 bb e2 ff ff       	jmp    80103f80 <exit>
80105cc5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105cc8:	e8 b3 e2 ff ff       	call   80103f80 <exit>
80105ccd:	eb cd                	jmp    80105c9c <trap+0x1ac>
80105ccf:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	68 60 5d 11 80       	push   $0x80115d60
80105cd8:	e8 93 e9 ff ff       	call   80104670 <acquire>
      ticks++;
      wakeup(&ticks);
80105cdd:	c7 04 24 a0 65 11 80 	movl   $0x801165a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105ce4:	83 05 a0 65 11 80 01 	addl   $0x1,0x801165a0
      wakeup(&ticks);
80105ceb:	e8 c0 e5 ff ff       	call   801042b0 <wakeup>
      release(&tickslock);
80105cf0:	c7 04 24 60 5d 11 80 	movl   $0x80115d60,(%esp)
80105cf7:	e8 94 ea ff ff       	call   80104790 <release>
80105cfc:	83 c4 10             	add    $0x10,%esp
80105cff:	e9 21 ff ff ff       	jmp    80105c25 <trap+0x135>
80105d04:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d07:	8b 5f 38             	mov    0x38(%edi),%ebx
80105d0a:	e8 f1 dd ff ff       	call   80103b00 <cpuid>
80105d0f:	83 ec 0c             	sub    $0xc,%esp
80105d12:	56                   	push   %esi
80105d13:	53                   	push   %ebx
80105d14:	50                   	push   %eax
80105d15:	ff 77 30             	pushl  0x30(%edi)
80105d18:	68 88 7a 10 80       	push   $0x80107a88
80105d1d:	e8 3e a9 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105d22:	83 c4 14             	add    $0x14,%esp
80105d25:	68 5e 7a 10 80       	push   $0x80107a5e
80105d2a:	e8 41 a6 ff ff       	call   80100370 <panic>
80105d2f:	90                   	nop

80105d30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d30:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105d35:	55                   	push   %ebp
80105d36:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105d38:	85 c0                	test   %eax,%eax
80105d3a:	74 1c                	je     80105d58 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d3c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d41:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d42:	a8 01                	test   $0x1,%al
80105d44:	74 12                	je     80105d58 <uartgetc+0x28>
80105d46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d4b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d4c:	0f b6 c0             	movzbl %al,%eax
}
80105d4f:	5d                   	pop    %ebp
80105d50:	c3                   	ret    
80105d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105d5d:	5d                   	pop    %ebp
80105d5e:	c3                   	ret    
80105d5f:	90                   	nop

80105d60 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	57                   	push   %edi
80105d64:	56                   	push   %esi
80105d65:	53                   	push   %ebx
80105d66:	89 c7                	mov    %eax,%edi
80105d68:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105d72:	83 ec 0c             	sub    $0xc,%esp
80105d75:	eb 1b                	jmp    80105d92 <uartputc.part.0+0x32>
80105d77:	89 f6                	mov    %esi,%esi
80105d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	6a 0a                	push   $0xa
80105d85:	e8 46 cd ff ff       	call   80102ad0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d8a:	83 c4 10             	add    $0x10,%esp
80105d8d:	83 eb 01             	sub    $0x1,%ebx
80105d90:	74 07                	je     80105d99 <uartputc.part.0+0x39>
80105d92:	89 f2                	mov    %esi,%edx
80105d94:	ec                   	in     (%dx),%al
80105d95:	a8 20                	test   $0x20,%al
80105d97:	74 e7                	je     80105d80 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d9e:	89 f8                	mov    %edi,%eax
80105da0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105da1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da4:	5b                   	pop    %ebx
80105da5:	5e                   	pop    %esi
80105da6:	5f                   	pop    %edi
80105da7:	5d                   	pop    %ebp
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105db0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105db0:	55                   	push   %ebp
80105db1:	31 c9                	xor    %ecx,%ecx
80105db3:	89 c8                	mov    %ecx,%eax
80105db5:	89 e5                	mov    %esp,%ebp
80105db7:	57                   	push   %edi
80105db8:	56                   	push   %esi
80105db9:	53                   	push   %ebx
80105dba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105dbf:	89 da                	mov    %ebx,%edx
80105dc1:	83 ec 0c             	sub    $0xc,%esp
80105dc4:	ee                   	out    %al,(%dx)
80105dc5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105dca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105dcf:	89 fa                	mov    %edi,%edx
80105dd1:	ee                   	out    %al,(%dx)
80105dd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105dd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ddc:	ee                   	out    %al,(%dx)
80105ddd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105de2:	89 c8                	mov    %ecx,%eax
80105de4:	89 f2                	mov    %esi,%edx
80105de6:	ee                   	out    %al,(%dx)
80105de7:	b8 03 00 00 00       	mov    $0x3,%eax
80105dec:	89 fa                	mov    %edi,%edx
80105dee:	ee                   	out    %al,(%dx)
80105def:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105df4:	89 c8                	mov    %ecx,%eax
80105df6:	ee                   	out    %al,(%dx)
80105df7:	b8 01 00 00 00       	mov    $0x1,%eax
80105dfc:	89 f2                	mov    %esi,%edx
80105dfe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105dff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e04:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105e05:	3c ff                	cmp    $0xff,%al
80105e07:	74 5a                	je     80105e63 <uartinit+0xb3>
    return;
  uart = 1;
80105e09:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105e10:	00 00 00 
80105e13:	89 da                	mov    %ebx,%edx
80105e15:	ec                   	in     (%dx),%al
80105e16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e1b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105e1c:	83 ec 08             	sub    $0x8,%esp
80105e1f:	bb 80 7b 10 80       	mov    $0x80107b80,%ebx
80105e24:	6a 00                	push   $0x0
80105e26:	6a 04                	push   $0x4
80105e28:	e8 13 c8 ff ff       	call   80102640 <ioapicenable>
80105e2d:	83 c4 10             	add    $0x10,%esp
80105e30:	b8 78 00 00 00       	mov    $0x78,%eax
80105e35:	eb 13                	jmp    80105e4a <uartinit+0x9a>
80105e37:	89 f6                	mov    %esi,%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105e40:	83 c3 01             	add    $0x1,%ebx
80105e43:	0f be 03             	movsbl (%ebx),%eax
80105e46:	84 c0                	test   %al,%al
80105e48:	74 19                	je     80105e63 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105e4a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105e50:	85 d2                	test   %edx,%edx
80105e52:	74 ec                	je     80105e40 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105e54:	83 c3 01             	add    $0x1,%ebx
80105e57:	e8 04 ff ff ff       	call   80105d60 <uartputc.part.0>
80105e5c:	0f be 03             	movsbl (%ebx),%eax
80105e5f:	84 c0                	test   %al,%al
80105e61:	75 e7                	jne    80105e4a <uartinit+0x9a>
    uartputc(*p);
}
80105e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e66:	5b                   	pop    %ebx
80105e67:	5e                   	pop    %esi
80105e68:	5f                   	pop    %edi
80105e69:	5d                   	pop    %ebp
80105e6a:	c3                   	ret    
80105e6b:	90                   	nop
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e70 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105e70:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105e76:	55                   	push   %ebp
80105e77:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105e79:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105e7e:	74 10                	je     80105e90 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105e80:	5d                   	pop    %ebp
80105e81:	e9 da fe ff ff       	jmp    80105d60 <uartputc.part.0>
80105e86:	8d 76 00             	lea    0x0(%esi),%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e90:	5d                   	pop    %ebp
80105e91:	c3                   	ret    
80105e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ea0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105ea6:	68 30 5d 10 80       	push   $0x80105d30
80105eab:	e8 40 a9 ff ff       	call   801007f0 <consoleintr>
}
80105eb0:	83 c4 10             	add    $0x10,%esp
80105eb3:	c9                   	leave  
80105eb4:	c3                   	ret    

80105eb5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $0
80105eb7:	6a 00                	push   $0x0
  jmp alltraps
80105eb9:	e9 3c fb ff ff       	jmp    801059fa <alltraps>

80105ebe <vector1>:
.globl vector1
vector1:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $1
80105ec0:	6a 01                	push   $0x1
  jmp alltraps
80105ec2:	e9 33 fb ff ff       	jmp    801059fa <alltraps>

80105ec7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $2
80105ec9:	6a 02                	push   $0x2
  jmp alltraps
80105ecb:	e9 2a fb ff ff       	jmp    801059fa <alltraps>

80105ed0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $3
80105ed2:	6a 03                	push   $0x3
  jmp alltraps
80105ed4:	e9 21 fb ff ff       	jmp    801059fa <alltraps>

80105ed9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $4
80105edb:	6a 04                	push   $0x4
  jmp alltraps
80105edd:	e9 18 fb ff ff       	jmp    801059fa <alltraps>

80105ee2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $5
80105ee4:	6a 05                	push   $0x5
  jmp alltraps
80105ee6:	e9 0f fb ff ff       	jmp    801059fa <alltraps>

80105eeb <vector6>:
.globl vector6
vector6:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $6
80105eed:	6a 06                	push   $0x6
  jmp alltraps
80105eef:	e9 06 fb ff ff       	jmp    801059fa <alltraps>

80105ef4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $7
80105ef6:	6a 07                	push   $0x7
  jmp alltraps
80105ef8:	e9 fd fa ff ff       	jmp    801059fa <alltraps>

80105efd <vector8>:
.globl vector8
vector8:
  pushl $8
80105efd:	6a 08                	push   $0x8
  jmp alltraps
80105eff:	e9 f6 fa ff ff       	jmp    801059fa <alltraps>

80105f04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f04:	6a 00                	push   $0x0
  pushl $9
80105f06:	6a 09                	push   $0x9
  jmp alltraps
80105f08:	e9 ed fa ff ff       	jmp    801059fa <alltraps>

80105f0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f0d:	6a 0a                	push   $0xa
  jmp alltraps
80105f0f:	e9 e6 fa ff ff       	jmp    801059fa <alltraps>

80105f14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f14:	6a 0b                	push   $0xb
  jmp alltraps
80105f16:	e9 df fa ff ff       	jmp    801059fa <alltraps>

80105f1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f1b:	6a 0c                	push   $0xc
  jmp alltraps
80105f1d:	e9 d8 fa ff ff       	jmp    801059fa <alltraps>

80105f22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f22:	6a 0d                	push   $0xd
  jmp alltraps
80105f24:	e9 d1 fa ff ff       	jmp    801059fa <alltraps>

80105f29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f29:	6a 0e                	push   $0xe
  jmp alltraps
80105f2b:	e9 ca fa ff ff       	jmp    801059fa <alltraps>

80105f30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $15
80105f32:	6a 0f                	push   $0xf
  jmp alltraps
80105f34:	e9 c1 fa ff ff       	jmp    801059fa <alltraps>

80105f39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $16
80105f3b:	6a 10                	push   $0x10
  jmp alltraps
80105f3d:	e9 b8 fa ff ff       	jmp    801059fa <alltraps>

80105f42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f42:	6a 11                	push   $0x11
  jmp alltraps
80105f44:	e9 b1 fa ff ff       	jmp    801059fa <alltraps>

80105f49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $18
80105f4b:	6a 12                	push   $0x12
  jmp alltraps
80105f4d:	e9 a8 fa ff ff       	jmp    801059fa <alltraps>

80105f52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $19
80105f54:	6a 13                	push   $0x13
  jmp alltraps
80105f56:	e9 9f fa ff ff       	jmp    801059fa <alltraps>

80105f5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $20
80105f5d:	6a 14                	push   $0x14
  jmp alltraps
80105f5f:	e9 96 fa ff ff       	jmp    801059fa <alltraps>

80105f64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $21
80105f66:	6a 15                	push   $0x15
  jmp alltraps
80105f68:	e9 8d fa ff ff       	jmp    801059fa <alltraps>

80105f6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $22
80105f6f:	6a 16                	push   $0x16
  jmp alltraps
80105f71:	e9 84 fa ff ff       	jmp    801059fa <alltraps>

80105f76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $23
80105f78:	6a 17                	push   $0x17
  jmp alltraps
80105f7a:	e9 7b fa ff ff       	jmp    801059fa <alltraps>

80105f7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $24
80105f81:	6a 18                	push   $0x18
  jmp alltraps
80105f83:	e9 72 fa ff ff       	jmp    801059fa <alltraps>

80105f88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $25
80105f8a:	6a 19                	push   $0x19
  jmp alltraps
80105f8c:	e9 69 fa ff ff       	jmp    801059fa <alltraps>

80105f91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105f91:	6a 00                	push   $0x0
  pushl $26
80105f93:	6a 1a                	push   $0x1a
  jmp alltraps
80105f95:	e9 60 fa ff ff       	jmp    801059fa <alltraps>

80105f9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $27
80105f9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105f9e:	e9 57 fa ff ff       	jmp    801059fa <alltraps>

80105fa3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $28
80105fa5:	6a 1c                	push   $0x1c
  jmp alltraps
80105fa7:	e9 4e fa ff ff       	jmp    801059fa <alltraps>

80105fac <vector29>:
.globl vector29
vector29:
  pushl $0
80105fac:	6a 00                	push   $0x0
  pushl $29
80105fae:	6a 1d                	push   $0x1d
  jmp alltraps
80105fb0:	e9 45 fa ff ff       	jmp    801059fa <alltraps>

80105fb5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $30
80105fb7:	6a 1e                	push   $0x1e
  jmp alltraps
80105fb9:	e9 3c fa ff ff       	jmp    801059fa <alltraps>

80105fbe <vector31>:
.globl vector31
vector31:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $31
80105fc0:	6a 1f                	push   $0x1f
  jmp alltraps
80105fc2:	e9 33 fa ff ff       	jmp    801059fa <alltraps>

80105fc7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $32
80105fc9:	6a 20                	push   $0x20
  jmp alltraps
80105fcb:	e9 2a fa ff ff       	jmp    801059fa <alltraps>

80105fd0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $33
80105fd2:	6a 21                	push   $0x21
  jmp alltraps
80105fd4:	e9 21 fa ff ff       	jmp    801059fa <alltraps>

80105fd9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $34
80105fdb:	6a 22                	push   $0x22
  jmp alltraps
80105fdd:	e9 18 fa ff ff       	jmp    801059fa <alltraps>

80105fe2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $35
80105fe4:	6a 23                	push   $0x23
  jmp alltraps
80105fe6:	e9 0f fa ff ff       	jmp    801059fa <alltraps>

80105feb <vector36>:
.globl vector36
vector36:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $36
80105fed:	6a 24                	push   $0x24
  jmp alltraps
80105fef:	e9 06 fa ff ff       	jmp    801059fa <alltraps>

80105ff4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $37
80105ff6:	6a 25                	push   $0x25
  jmp alltraps
80105ff8:	e9 fd f9 ff ff       	jmp    801059fa <alltraps>

80105ffd <vector38>:
.globl vector38
vector38:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $38
80105fff:	6a 26                	push   $0x26
  jmp alltraps
80106001:	e9 f4 f9 ff ff       	jmp    801059fa <alltraps>

80106006 <vector39>:
.globl vector39
vector39:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $39
80106008:	6a 27                	push   $0x27
  jmp alltraps
8010600a:	e9 eb f9 ff ff       	jmp    801059fa <alltraps>

8010600f <vector40>:
.globl vector40
vector40:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $40
80106011:	6a 28                	push   $0x28
  jmp alltraps
80106013:	e9 e2 f9 ff ff       	jmp    801059fa <alltraps>

80106018 <vector41>:
.globl vector41
vector41:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $41
8010601a:	6a 29                	push   $0x29
  jmp alltraps
8010601c:	e9 d9 f9 ff ff       	jmp    801059fa <alltraps>

80106021 <vector42>:
.globl vector42
vector42:
  pushl $0
80106021:	6a 00                	push   $0x0
  pushl $42
80106023:	6a 2a                	push   $0x2a
  jmp alltraps
80106025:	e9 d0 f9 ff ff       	jmp    801059fa <alltraps>

8010602a <vector43>:
.globl vector43
vector43:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $43
8010602c:	6a 2b                	push   $0x2b
  jmp alltraps
8010602e:	e9 c7 f9 ff ff       	jmp    801059fa <alltraps>

80106033 <vector44>:
.globl vector44
vector44:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $44
80106035:	6a 2c                	push   $0x2c
  jmp alltraps
80106037:	e9 be f9 ff ff       	jmp    801059fa <alltraps>

8010603c <vector45>:
.globl vector45
vector45:
  pushl $0
8010603c:	6a 00                	push   $0x0
  pushl $45
8010603e:	6a 2d                	push   $0x2d
  jmp alltraps
80106040:	e9 b5 f9 ff ff       	jmp    801059fa <alltraps>

80106045 <vector46>:
.globl vector46
vector46:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $46
80106047:	6a 2e                	push   $0x2e
  jmp alltraps
80106049:	e9 ac f9 ff ff       	jmp    801059fa <alltraps>

8010604e <vector47>:
.globl vector47
vector47:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $47
80106050:	6a 2f                	push   $0x2f
  jmp alltraps
80106052:	e9 a3 f9 ff ff       	jmp    801059fa <alltraps>

80106057 <vector48>:
.globl vector48
vector48:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $48
80106059:	6a 30                	push   $0x30
  jmp alltraps
8010605b:	e9 9a f9 ff ff       	jmp    801059fa <alltraps>

80106060 <vector49>:
.globl vector49
vector49:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $49
80106062:	6a 31                	push   $0x31
  jmp alltraps
80106064:	e9 91 f9 ff ff       	jmp    801059fa <alltraps>

80106069 <vector50>:
.globl vector50
vector50:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $50
8010606b:	6a 32                	push   $0x32
  jmp alltraps
8010606d:	e9 88 f9 ff ff       	jmp    801059fa <alltraps>

80106072 <vector51>:
.globl vector51
vector51:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $51
80106074:	6a 33                	push   $0x33
  jmp alltraps
80106076:	e9 7f f9 ff ff       	jmp    801059fa <alltraps>

8010607b <vector52>:
.globl vector52
vector52:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $52
8010607d:	6a 34                	push   $0x34
  jmp alltraps
8010607f:	e9 76 f9 ff ff       	jmp    801059fa <alltraps>

80106084 <vector53>:
.globl vector53
vector53:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $53
80106086:	6a 35                	push   $0x35
  jmp alltraps
80106088:	e9 6d f9 ff ff       	jmp    801059fa <alltraps>

8010608d <vector54>:
.globl vector54
vector54:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $54
8010608f:	6a 36                	push   $0x36
  jmp alltraps
80106091:	e9 64 f9 ff ff       	jmp    801059fa <alltraps>

80106096 <vector55>:
.globl vector55
vector55:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $55
80106098:	6a 37                	push   $0x37
  jmp alltraps
8010609a:	e9 5b f9 ff ff       	jmp    801059fa <alltraps>

8010609f <vector56>:
.globl vector56
vector56:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $56
801060a1:	6a 38                	push   $0x38
  jmp alltraps
801060a3:	e9 52 f9 ff ff       	jmp    801059fa <alltraps>

801060a8 <vector57>:
.globl vector57
vector57:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $57
801060aa:	6a 39                	push   $0x39
  jmp alltraps
801060ac:	e9 49 f9 ff ff       	jmp    801059fa <alltraps>

801060b1 <vector58>:
.globl vector58
vector58:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $58
801060b3:	6a 3a                	push   $0x3a
  jmp alltraps
801060b5:	e9 40 f9 ff ff       	jmp    801059fa <alltraps>

801060ba <vector59>:
.globl vector59
vector59:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $59
801060bc:	6a 3b                	push   $0x3b
  jmp alltraps
801060be:	e9 37 f9 ff ff       	jmp    801059fa <alltraps>

801060c3 <vector60>:
.globl vector60
vector60:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $60
801060c5:	6a 3c                	push   $0x3c
  jmp alltraps
801060c7:	e9 2e f9 ff ff       	jmp    801059fa <alltraps>

801060cc <vector61>:
.globl vector61
vector61:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $61
801060ce:	6a 3d                	push   $0x3d
  jmp alltraps
801060d0:	e9 25 f9 ff ff       	jmp    801059fa <alltraps>

801060d5 <vector62>:
.globl vector62
vector62:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $62
801060d7:	6a 3e                	push   $0x3e
  jmp alltraps
801060d9:	e9 1c f9 ff ff       	jmp    801059fa <alltraps>

801060de <vector63>:
.globl vector63
vector63:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $63
801060e0:	6a 3f                	push   $0x3f
  jmp alltraps
801060e2:	e9 13 f9 ff ff       	jmp    801059fa <alltraps>

801060e7 <vector64>:
.globl vector64
vector64:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $64
801060e9:	6a 40                	push   $0x40
  jmp alltraps
801060eb:	e9 0a f9 ff ff       	jmp    801059fa <alltraps>

801060f0 <vector65>:
.globl vector65
vector65:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $65
801060f2:	6a 41                	push   $0x41
  jmp alltraps
801060f4:	e9 01 f9 ff ff       	jmp    801059fa <alltraps>

801060f9 <vector66>:
.globl vector66
vector66:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $66
801060fb:	6a 42                	push   $0x42
  jmp alltraps
801060fd:	e9 f8 f8 ff ff       	jmp    801059fa <alltraps>

80106102 <vector67>:
.globl vector67
vector67:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $67
80106104:	6a 43                	push   $0x43
  jmp alltraps
80106106:	e9 ef f8 ff ff       	jmp    801059fa <alltraps>

8010610b <vector68>:
.globl vector68
vector68:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $68
8010610d:	6a 44                	push   $0x44
  jmp alltraps
8010610f:	e9 e6 f8 ff ff       	jmp    801059fa <alltraps>

80106114 <vector69>:
.globl vector69
vector69:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $69
80106116:	6a 45                	push   $0x45
  jmp alltraps
80106118:	e9 dd f8 ff ff       	jmp    801059fa <alltraps>

8010611d <vector70>:
.globl vector70
vector70:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $70
8010611f:	6a 46                	push   $0x46
  jmp alltraps
80106121:	e9 d4 f8 ff ff       	jmp    801059fa <alltraps>

80106126 <vector71>:
.globl vector71
vector71:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $71
80106128:	6a 47                	push   $0x47
  jmp alltraps
8010612a:	e9 cb f8 ff ff       	jmp    801059fa <alltraps>

8010612f <vector72>:
.globl vector72
vector72:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $72
80106131:	6a 48                	push   $0x48
  jmp alltraps
80106133:	e9 c2 f8 ff ff       	jmp    801059fa <alltraps>

80106138 <vector73>:
.globl vector73
vector73:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $73
8010613a:	6a 49                	push   $0x49
  jmp alltraps
8010613c:	e9 b9 f8 ff ff       	jmp    801059fa <alltraps>

80106141 <vector74>:
.globl vector74
vector74:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $74
80106143:	6a 4a                	push   $0x4a
  jmp alltraps
80106145:	e9 b0 f8 ff ff       	jmp    801059fa <alltraps>

8010614a <vector75>:
.globl vector75
vector75:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $75
8010614c:	6a 4b                	push   $0x4b
  jmp alltraps
8010614e:	e9 a7 f8 ff ff       	jmp    801059fa <alltraps>

80106153 <vector76>:
.globl vector76
vector76:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $76
80106155:	6a 4c                	push   $0x4c
  jmp alltraps
80106157:	e9 9e f8 ff ff       	jmp    801059fa <alltraps>

8010615c <vector77>:
.globl vector77
vector77:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $77
8010615e:	6a 4d                	push   $0x4d
  jmp alltraps
80106160:	e9 95 f8 ff ff       	jmp    801059fa <alltraps>

80106165 <vector78>:
.globl vector78
vector78:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $78
80106167:	6a 4e                	push   $0x4e
  jmp alltraps
80106169:	e9 8c f8 ff ff       	jmp    801059fa <alltraps>

8010616e <vector79>:
.globl vector79
vector79:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $79
80106170:	6a 4f                	push   $0x4f
  jmp alltraps
80106172:	e9 83 f8 ff ff       	jmp    801059fa <alltraps>

80106177 <vector80>:
.globl vector80
vector80:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $80
80106179:	6a 50                	push   $0x50
  jmp alltraps
8010617b:	e9 7a f8 ff ff       	jmp    801059fa <alltraps>

80106180 <vector81>:
.globl vector81
vector81:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $81
80106182:	6a 51                	push   $0x51
  jmp alltraps
80106184:	e9 71 f8 ff ff       	jmp    801059fa <alltraps>

80106189 <vector82>:
.globl vector82
vector82:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $82
8010618b:	6a 52                	push   $0x52
  jmp alltraps
8010618d:	e9 68 f8 ff ff       	jmp    801059fa <alltraps>

80106192 <vector83>:
.globl vector83
vector83:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $83
80106194:	6a 53                	push   $0x53
  jmp alltraps
80106196:	e9 5f f8 ff ff       	jmp    801059fa <alltraps>

8010619b <vector84>:
.globl vector84
vector84:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $84
8010619d:	6a 54                	push   $0x54
  jmp alltraps
8010619f:	e9 56 f8 ff ff       	jmp    801059fa <alltraps>

801061a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $85
801061a6:	6a 55                	push   $0x55
  jmp alltraps
801061a8:	e9 4d f8 ff ff       	jmp    801059fa <alltraps>

801061ad <vector86>:
.globl vector86
vector86:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $86
801061af:	6a 56                	push   $0x56
  jmp alltraps
801061b1:	e9 44 f8 ff ff       	jmp    801059fa <alltraps>

801061b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $87
801061b8:	6a 57                	push   $0x57
  jmp alltraps
801061ba:	e9 3b f8 ff ff       	jmp    801059fa <alltraps>

801061bf <vector88>:
.globl vector88
vector88:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $88
801061c1:	6a 58                	push   $0x58
  jmp alltraps
801061c3:	e9 32 f8 ff ff       	jmp    801059fa <alltraps>

801061c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $89
801061ca:	6a 59                	push   $0x59
  jmp alltraps
801061cc:	e9 29 f8 ff ff       	jmp    801059fa <alltraps>

801061d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $90
801061d3:	6a 5a                	push   $0x5a
  jmp alltraps
801061d5:	e9 20 f8 ff ff       	jmp    801059fa <alltraps>

801061da <vector91>:
.globl vector91
vector91:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $91
801061dc:	6a 5b                	push   $0x5b
  jmp alltraps
801061de:	e9 17 f8 ff ff       	jmp    801059fa <alltraps>

801061e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $92
801061e5:	6a 5c                	push   $0x5c
  jmp alltraps
801061e7:	e9 0e f8 ff ff       	jmp    801059fa <alltraps>

801061ec <vector93>:
.globl vector93
vector93:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $93
801061ee:	6a 5d                	push   $0x5d
  jmp alltraps
801061f0:	e9 05 f8 ff ff       	jmp    801059fa <alltraps>

801061f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $94
801061f7:	6a 5e                	push   $0x5e
  jmp alltraps
801061f9:	e9 fc f7 ff ff       	jmp    801059fa <alltraps>

801061fe <vector95>:
.globl vector95
vector95:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $95
80106200:	6a 5f                	push   $0x5f
  jmp alltraps
80106202:	e9 f3 f7 ff ff       	jmp    801059fa <alltraps>

80106207 <vector96>:
.globl vector96
vector96:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $96
80106209:	6a 60                	push   $0x60
  jmp alltraps
8010620b:	e9 ea f7 ff ff       	jmp    801059fa <alltraps>

80106210 <vector97>:
.globl vector97
vector97:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $97
80106212:	6a 61                	push   $0x61
  jmp alltraps
80106214:	e9 e1 f7 ff ff       	jmp    801059fa <alltraps>

80106219 <vector98>:
.globl vector98
vector98:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $98
8010621b:	6a 62                	push   $0x62
  jmp alltraps
8010621d:	e9 d8 f7 ff ff       	jmp    801059fa <alltraps>

80106222 <vector99>:
.globl vector99
vector99:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $99
80106224:	6a 63                	push   $0x63
  jmp alltraps
80106226:	e9 cf f7 ff ff       	jmp    801059fa <alltraps>

8010622b <vector100>:
.globl vector100
vector100:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $100
8010622d:	6a 64                	push   $0x64
  jmp alltraps
8010622f:	e9 c6 f7 ff ff       	jmp    801059fa <alltraps>

80106234 <vector101>:
.globl vector101
vector101:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $101
80106236:	6a 65                	push   $0x65
  jmp alltraps
80106238:	e9 bd f7 ff ff       	jmp    801059fa <alltraps>

8010623d <vector102>:
.globl vector102
vector102:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $102
8010623f:	6a 66                	push   $0x66
  jmp alltraps
80106241:	e9 b4 f7 ff ff       	jmp    801059fa <alltraps>

80106246 <vector103>:
.globl vector103
vector103:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $103
80106248:	6a 67                	push   $0x67
  jmp alltraps
8010624a:	e9 ab f7 ff ff       	jmp    801059fa <alltraps>

8010624f <vector104>:
.globl vector104
vector104:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $104
80106251:	6a 68                	push   $0x68
  jmp alltraps
80106253:	e9 a2 f7 ff ff       	jmp    801059fa <alltraps>

80106258 <vector105>:
.globl vector105
vector105:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $105
8010625a:	6a 69                	push   $0x69
  jmp alltraps
8010625c:	e9 99 f7 ff ff       	jmp    801059fa <alltraps>

80106261 <vector106>:
.globl vector106
vector106:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $106
80106263:	6a 6a                	push   $0x6a
  jmp alltraps
80106265:	e9 90 f7 ff ff       	jmp    801059fa <alltraps>

8010626a <vector107>:
.globl vector107
vector107:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $107
8010626c:	6a 6b                	push   $0x6b
  jmp alltraps
8010626e:	e9 87 f7 ff ff       	jmp    801059fa <alltraps>

80106273 <vector108>:
.globl vector108
vector108:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $108
80106275:	6a 6c                	push   $0x6c
  jmp alltraps
80106277:	e9 7e f7 ff ff       	jmp    801059fa <alltraps>

8010627c <vector109>:
.globl vector109
vector109:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $109
8010627e:	6a 6d                	push   $0x6d
  jmp alltraps
80106280:	e9 75 f7 ff ff       	jmp    801059fa <alltraps>

80106285 <vector110>:
.globl vector110
vector110:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $110
80106287:	6a 6e                	push   $0x6e
  jmp alltraps
80106289:	e9 6c f7 ff ff       	jmp    801059fa <alltraps>

8010628e <vector111>:
.globl vector111
vector111:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $111
80106290:	6a 6f                	push   $0x6f
  jmp alltraps
80106292:	e9 63 f7 ff ff       	jmp    801059fa <alltraps>

80106297 <vector112>:
.globl vector112
vector112:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $112
80106299:	6a 70                	push   $0x70
  jmp alltraps
8010629b:	e9 5a f7 ff ff       	jmp    801059fa <alltraps>

801062a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $113
801062a2:	6a 71                	push   $0x71
  jmp alltraps
801062a4:	e9 51 f7 ff ff       	jmp    801059fa <alltraps>

801062a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $114
801062ab:	6a 72                	push   $0x72
  jmp alltraps
801062ad:	e9 48 f7 ff ff       	jmp    801059fa <alltraps>

801062b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $115
801062b4:	6a 73                	push   $0x73
  jmp alltraps
801062b6:	e9 3f f7 ff ff       	jmp    801059fa <alltraps>

801062bb <vector116>:
.globl vector116
vector116:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $116
801062bd:	6a 74                	push   $0x74
  jmp alltraps
801062bf:	e9 36 f7 ff ff       	jmp    801059fa <alltraps>

801062c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $117
801062c6:	6a 75                	push   $0x75
  jmp alltraps
801062c8:	e9 2d f7 ff ff       	jmp    801059fa <alltraps>

801062cd <vector118>:
.globl vector118
vector118:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $118
801062cf:	6a 76                	push   $0x76
  jmp alltraps
801062d1:	e9 24 f7 ff ff       	jmp    801059fa <alltraps>

801062d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $119
801062d8:	6a 77                	push   $0x77
  jmp alltraps
801062da:	e9 1b f7 ff ff       	jmp    801059fa <alltraps>

801062df <vector120>:
.globl vector120
vector120:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $120
801062e1:	6a 78                	push   $0x78
  jmp alltraps
801062e3:	e9 12 f7 ff ff       	jmp    801059fa <alltraps>

801062e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $121
801062ea:	6a 79                	push   $0x79
  jmp alltraps
801062ec:	e9 09 f7 ff ff       	jmp    801059fa <alltraps>

801062f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $122
801062f3:	6a 7a                	push   $0x7a
  jmp alltraps
801062f5:	e9 00 f7 ff ff       	jmp    801059fa <alltraps>

801062fa <vector123>:
.globl vector123
vector123:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $123
801062fc:	6a 7b                	push   $0x7b
  jmp alltraps
801062fe:	e9 f7 f6 ff ff       	jmp    801059fa <alltraps>

80106303 <vector124>:
.globl vector124
vector124:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $124
80106305:	6a 7c                	push   $0x7c
  jmp alltraps
80106307:	e9 ee f6 ff ff       	jmp    801059fa <alltraps>

8010630c <vector125>:
.globl vector125
vector125:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $125
8010630e:	6a 7d                	push   $0x7d
  jmp alltraps
80106310:	e9 e5 f6 ff ff       	jmp    801059fa <alltraps>

80106315 <vector126>:
.globl vector126
vector126:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $126
80106317:	6a 7e                	push   $0x7e
  jmp alltraps
80106319:	e9 dc f6 ff ff       	jmp    801059fa <alltraps>

8010631e <vector127>:
.globl vector127
vector127:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $127
80106320:	6a 7f                	push   $0x7f
  jmp alltraps
80106322:	e9 d3 f6 ff ff       	jmp    801059fa <alltraps>

80106327 <vector128>:
.globl vector128
vector128:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $128
80106329:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010632e:	e9 c7 f6 ff ff       	jmp    801059fa <alltraps>

80106333 <vector129>:
.globl vector129
vector129:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $129
80106335:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010633a:	e9 bb f6 ff ff       	jmp    801059fa <alltraps>

8010633f <vector130>:
.globl vector130
vector130:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $130
80106341:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106346:	e9 af f6 ff ff       	jmp    801059fa <alltraps>

8010634b <vector131>:
.globl vector131
vector131:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $131
8010634d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106352:	e9 a3 f6 ff ff       	jmp    801059fa <alltraps>

80106357 <vector132>:
.globl vector132
vector132:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $132
80106359:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010635e:	e9 97 f6 ff ff       	jmp    801059fa <alltraps>

80106363 <vector133>:
.globl vector133
vector133:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $133
80106365:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010636a:	e9 8b f6 ff ff       	jmp    801059fa <alltraps>

8010636f <vector134>:
.globl vector134
vector134:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $134
80106371:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106376:	e9 7f f6 ff ff       	jmp    801059fa <alltraps>

8010637b <vector135>:
.globl vector135
vector135:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $135
8010637d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106382:	e9 73 f6 ff ff       	jmp    801059fa <alltraps>

80106387 <vector136>:
.globl vector136
vector136:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $136
80106389:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010638e:	e9 67 f6 ff ff       	jmp    801059fa <alltraps>

80106393 <vector137>:
.globl vector137
vector137:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $137
80106395:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010639a:	e9 5b f6 ff ff       	jmp    801059fa <alltraps>

8010639f <vector138>:
.globl vector138
vector138:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $138
801063a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801063a6:	e9 4f f6 ff ff       	jmp    801059fa <alltraps>

801063ab <vector139>:
.globl vector139
vector139:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $139
801063ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801063b2:	e9 43 f6 ff ff       	jmp    801059fa <alltraps>

801063b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $140
801063b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801063be:	e9 37 f6 ff ff       	jmp    801059fa <alltraps>

801063c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $141
801063c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801063ca:	e9 2b f6 ff ff       	jmp    801059fa <alltraps>

801063cf <vector142>:
.globl vector142
vector142:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $142
801063d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801063d6:	e9 1f f6 ff ff       	jmp    801059fa <alltraps>

801063db <vector143>:
.globl vector143
vector143:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $143
801063dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801063e2:	e9 13 f6 ff ff       	jmp    801059fa <alltraps>

801063e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $144
801063e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801063ee:	e9 07 f6 ff ff       	jmp    801059fa <alltraps>

801063f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $145
801063f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801063fa:	e9 fb f5 ff ff       	jmp    801059fa <alltraps>

801063ff <vector146>:
.globl vector146
vector146:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $146
80106401:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106406:	e9 ef f5 ff ff       	jmp    801059fa <alltraps>

8010640b <vector147>:
.globl vector147
vector147:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $147
8010640d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106412:	e9 e3 f5 ff ff       	jmp    801059fa <alltraps>

80106417 <vector148>:
.globl vector148
vector148:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $148
80106419:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010641e:	e9 d7 f5 ff ff       	jmp    801059fa <alltraps>

80106423 <vector149>:
.globl vector149
vector149:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $149
80106425:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010642a:	e9 cb f5 ff ff       	jmp    801059fa <alltraps>

8010642f <vector150>:
.globl vector150
vector150:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $150
80106431:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106436:	e9 bf f5 ff ff       	jmp    801059fa <alltraps>

8010643b <vector151>:
.globl vector151
vector151:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $151
8010643d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106442:	e9 b3 f5 ff ff       	jmp    801059fa <alltraps>

80106447 <vector152>:
.globl vector152
vector152:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $152
80106449:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010644e:	e9 a7 f5 ff ff       	jmp    801059fa <alltraps>

80106453 <vector153>:
.globl vector153
vector153:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $153
80106455:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010645a:	e9 9b f5 ff ff       	jmp    801059fa <alltraps>

8010645f <vector154>:
.globl vector154
vector154:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $154
80106461:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106466:	e9 8f f5 ff ff       	jmp    801059fa <alltraps>

8010646b <vector155>:
.globl vector155
vector155:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $155
8010646d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106472:	e9 83 f5 ff ff       	jmp    801059fa <alltraps>

80106477 <vector156>:
.globl vector156
vector156:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $156
80106479:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010647e:	e9 77 f5 ff ff       	jmp    801059fa <alltraps>

80106483 <vector157>:
.globl vector157
vector157:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $157
80106485:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010648a:	e9 6b f5 ff ff       	jmp    801059fa <alltraps>

8010648f <vector158>:
.globl vector158
vector158:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $158
80106491:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106496:	e9 5f f5 ff ff       	jmp    801059fa <alltraps>

8010649b <vector159>:
.globl vector159
vector159:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $159
8010649d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801064a2:	e9 53 f5 ff ff       	jmp    801059fa <alltraps>

801064a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $160
801064a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801064ae:	e9 47 f5 ff ff       	jmp    801059fa <alltraps>

801064b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $161
801064b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801064ba:	e9 3b f5 ff ff       	jmp    801059fa <alltraps>

801064bf <vector162>:
.globl vector162
vector162:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $162
801064c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801064c6:	e9 2f f5 ff ff       	jmp    801059fa <alltraps>

801064cb <vector163>:
.globl vector163
vector163:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $163
801064cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801064d2:	e9 23 f5 ff ff       	jmp    801059fa <alltraps>

801064d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $164
801064d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801064de:	e9 17 f5 ff ff       	jmp    801059fa <alltraps>

801064e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $165
801064e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801064ea:	e9 0b f5 ff ff       	jmp    801059fa <alltraps>

801064ef <vector166>:
.globl vector166
vector166:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $166
801064f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801064f6:	e9 ff f4 ff ff       	jmp    801059fa <alltraps>

801064fb <vector167>:
.globl vector167
vector167:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $167
801064fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106502:	e9 f3 f4 ff ff       	jmp    801059fa <alltraps>

80106507 <vector168>:
.globl vector168
vector168:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $168
80106509:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010650e:	e9 e7 f4 ff ff       	jmp    801059fa <alltraps>

80106513 <vector169>:
.globl vector169
vector169:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $169
80106515:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010651a:	e9 db f4 ff ff       	jmp    801059fa <alltraps>

8010651f <vector170>:
.globl vector170
vector170:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $170
80106521:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106526:	e9 cf f4 ff ff       	jmp    801059fa <alltraps>

8010652b <vector171>:
.globl vector171
vector171:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $171
8010652d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106532:	e9 c3 f4 ff ff       	jmp    801059fa <alltraps>

80106537 <vector172>:
.globl vector172
vector172:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $172
80106539:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010653e:	e9 b7 f4 ff ff       	jmp    801059fa <alltraps>

80106543 <vector173>:
.globl vector173
vector173:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $173
80106545:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010654a:	e9 ab f4 ff ff       	jmp    801059fa <alltraps>

8010654f <vector174>:
.globl vector174
vector174:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $174
80106551:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106556:	e9 9f f4 ff ff       	jmp    801059fa <alltraps>

8010655b <vector175>:
.globl vector175
vector175:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $175
8010655d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106562:	e9 93 f4 ff ff       	jmp    801059fa <alltraps>

80106567 <vector176>:
.globl vector176
vector176:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $176
80106569:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010656e:	e9 87 f4 ff ff       	jmp    801059fa <alltraps>

80106573 <vector177>:
.globl vector177
vector177:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $177
80106575:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010657a:	e9 7b f4 ff ff       	jmp    801059fa <alltraps>

8010657f <vector178>:
.globl vector178
vector178:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $178
80106581:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106586:	e9 6f f4 ff ff       	jmp    801059fa <alltraps>

8010658b <vector179>:
.globl vector179
vector179:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $179
8010658d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106592:	e9 63 f4 ff ff       	jmp    801059fa <alltraps>

80106597 <vector180>:
.globl vector180
vector180:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $180
80106599:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010659e:	e9 57 f4 ff ff       	jmp    801059fa <alltraps>

801065a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $181
801065a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801065aa:	e9 4b f4 ff ff       	jmp    801059fa <alltraps>

801065af <vector182>:
.globl vector182
vector182:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $182
801065b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801065b6:	e9 3f f4 ff ff       	jmp    801059fa <alltraps>

801065bb <vector183>:
.globl vector183
vector183:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $183
801065bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801065c2:	e9 33 f4 ff ff       	jmp    801059fa <alltraps>

801065c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $184
801065c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801065ce:	e9 27 f4 ff ff       	jmp    801059fa <alltraps>

801065d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $185
801065d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801065da:	e9 1b f4 ff ff       	jmp    801059fa <alltraps>

801065df <vector186>:
.globl vector186
vector186:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $186
801065e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801065e6:	e9 0f f4 ff ff       	jmp    801059fa <alltraps>

801065eb <vector187>:
.globl vector187
vector187:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $187
801065ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801065f2:	e9 03 f4 ff ff       	jmp    801059fa <alltraps>

801065f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $188
801065f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801065fe:	e9 f7 f3 ff ff       	jmp    801059fa <alltraps>

80106603 <vector189>:
.globl vector189
vector189:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $189
80106605:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010660a:	e9 eb f3 ff ff       	jmp    801059fa <alltraps>

8010660f <vector190>:
.globl vector190
vector190:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $190
80106611:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106616:	e9 df f3 ff ff       	jmp    801059fa <alltraps>

8010661b <vector191>:
.globl vector191
vector191:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $191
8010661d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106622:	e9 d3 f3 ff ff       	jmp    801059fa <alltraps>

80106627 <vector192>:
.globl vector192
vector192:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $192
80106629:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010662e:	e9 c7 f3 ff ff       	jmp    801059fa <alltraps>

80106633 <vector193>:
.globl vector193
vector193:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $193
80106635:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010663a:	e9 bb f3 ff ff       	jmp    801059fa <alltraps>

8010663f <vector194>:
.globl vector194
vector194:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $194
80106641:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106646:	e9 af f3 ff ff       	jmp    801059fa <alltraps>

8010664b <vector195>:
.globl vector195
vector195:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $195
8010664d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106652:	e9 a3 f3 ff ff       	jmp    801059fa <alltraps>

80106657 <vector196>:
.globl vector196
vector196:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $196
80106659:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010665e:	e9 97 f3 ff ff       	jmp    801059fa <alltraps>

80106663 <vector197>:
.globl vector197
vector197:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $197
80106665:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010666a:	e9 8b f3 ff ff       	jmp    801059fa <alltraps>

8010666f <vector198>:
.globl vector198
vector198:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $198
80106671:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106676:	e9 7f f3 ff ff       	jmp    801059fa <alltraps>

8010667b <vector199>:
.globl vector199
vector199:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $199
8010667d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106682:	e9 73 f3 ff ff       	jmp    801059fa <alltraps>

80106687 <vector200>:
.globl vector200
vector200:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $200
80106689:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010668e:	e9 67 f3 ff ff       	jmp    801059fa <alltraps>

80106693 <vector201>:
.globl vector201
vector201:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $201
80106695:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010669a:	e9 5b f3 ff ff       	jmp    801059fa <alltraps>

8010669f <vector202>:
.globl vector202
vector202:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $202
801066a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801066a6:	e9 4f f3 ff ff       	jmp    801059fa <alltraps>

801066ab <vector203>:
.globl vector203
vector203:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $203
801066ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801066b2:	e9 43 f3 ff ff       	jmp    801059fa <alltraps>

801066b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $204
801066b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801066be:	e9 37 f3 ff ff       	jmp    801059fa <alltraps>

801066c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $205
801066c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801066ca:	e9 2b f3 ff ff       	jmp    801059fa <alltraps>

801066cf <vector206>:
.globl vector206
vector206:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $206
801066d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801066d6:	e9 1f f3 ff ff       	jmp    801059fa <alltraps>

801066db <vector207>:
.globl vector207
vector207:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $207
801066dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801066e2:	e9 13 f3 ff ff       	jmp    801059fa <alltraps>

801066e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $208
801066e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801066ee:	e9 07 f3 ff ff       	jmp    801059fa <alltraps>

801066f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $209
801066f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801066fa:	e9 fb f2 ff ff       	jmp    801059fa <alltraps>

801066ff <vector210>:
.globl vector210
vector210:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $210
80106701:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106706:	e9 ef f2 ff ff       	jmp    801059fa <alltraps>

8010670b <vector211>:
.globl vector211
vector211:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $211
8010670d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106712:	e9 e3 f2 ff ff       	jmp    801059fa <alltraps>

80106717 <vector212>:
.globl vector212
vector212:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $212
80106719:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010671e:	e9 d7 f2 ff ff       	jmp    801059fa <alltraps>

80106723 <vector213>:
.globl vector213
vector213:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $213
80106725:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010672a:	e9 cb f2 ff ff       	jmp    801059fa <alltraps>

8010672f <vector214>:
.globl vector214
vector214:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $214
80106731:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106736:	e9 bf f2 ff ff       	jmp    801059fa <alltraps>

8010673b <vector215>:
.globl vector215
vector215:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $215
8010673d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106742:	e9 b3 f2 ff ff       	jmp    801059fa <alltraps>

80106747 <vector216>:
.globl vector216
vector216:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $216
80106749:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010674e:	e9 a7 f2 ff ff       	jmp    801059fa <alltraps>

80106753 <vector217>:
.globl vector217
vector217:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $217
80106755:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010675a:	e9 9b f2 ff ff       	jmp    801059fa <alltraps>

8010675f <vector218>:
.globl vector218
vector218:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $218
80106761:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106766:	e9 8f f2 ff ff       	jmp    801059fa <alltraps>

8010676b <vector219>:
.globl vector219
vector219:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $219
8010676d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106772:	e9 83 f2 ff ff       	jmp    801059fa <alltraps>

80106777 <vector220>:
.globl vector220
vector220:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $220
80106779:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010677e:	e9 77 f2 ff ff       	jmp    801059fa <alltraps>

80106783 <vector221>:
.globl vector221
vector221:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $221
80106785:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010678a:	e9 6b f2 ff ff       	jmp    801059fa <alltraps>

8010678f <vector222>:
.globl vector222
vector222:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $222
80106791:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106796:	e9 5f f2 ff ff       	jmp    801059fa <alltraps>

8010679b <vector223>:
.globl vector223
vector223:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $223
8010679d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801067a2:	e9 53 f2 ff ff       	jmp    801059fa <alltraps>

801067a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $224
801067a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801067ae:	e9 47 f2 ff ff       	jmp    801059fa <alltraps>

801067b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $225
801067b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801067ba:	e9 3b f2 ff ff       	jmp    801059fa <alltraps>

801067bf <vector226>:
.globl vector226
vector226:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $226
801067c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801067c6:	e9 2f f2 ff ff       	jmp    801059fa <alltraps>

801067cb <vector227>:
.globl vector227
vector227:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $227
801067cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801067d2:	e9 23 f2 ff ff       	jmp    801059fa <alltraps>

801067d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $228
801067d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801067de:	e9 17 f2 ff ff       	jmp    801059fa <alltraps>

801067e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $229
801067e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801067ea:	e9 0b f2 ff ff       	jmp    801059fa <alltraps>

801067ef <vector230>:
.globl vector230
vector230:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $230
801067f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801067f6:	e9 ff f1 ff ff       	jmp    801059fa <alltraps>

801067fb <vector231>:
.globl vector231
vector231:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $231
801067fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106802:	e9 f3 f1 ff ff       	jmp    801059fa <alltraps>

80106807 <vector232>:
.globl vector232
vector232:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $232
80106809:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010680e:	e9 e7 f1 ff ff       	jmp    801059fa <alltraps>

80106813 <vector233>:
.globl vector233
vector233:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $233
80106815:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010681a:	e9 db f1 ff ff       	jmp    801059fa <alltraps>

8010681f <vector234>:
.globl vector234
vector234:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $234
80106821:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106826:	e9 cf f1 ff ff       	jmp    801059fa <alltraps>

8010682b <vector235>:
.globl vector235
vector235:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $235
8010682d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106832:	e9 c3 f1 ff ff       	jmp    801059fa <alltraps>

80106837 <vector236>:
.globl vector236
vector236:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $236
80106839:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010683e:	e9 b7 f1 ff ff       	jmp    801059fa <alltraps>

80106843 <vector237>:
.globl vector237
vector237:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $237
80106845:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010684a:	e9 ab f1 ff ff       	jmp    801059fa <alltraps>

8010684f <vector238>:
.globl vector238
vector238:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $238
80106851:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106856:	e9 9f f1 ff ff       	jmp    801059fa <alltraps>

8010685b <vector239>:
.globl vector239
vector239:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $239
8010685d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106862:	e9 93 f1 ff ff       	jmp    801059fa <alltraps>

80106867 <vector240>:
.globl vector240
vector240:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $240
80106869:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010686e:	e9 87 f1 ff ff       	jmp    801059fa <alltraps>

80106873 <vector241>:
.globl vector241
vector241:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $241
80106875:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010687a:	e9 7b f1 ff ff       	jmp    801059fa <alltraps>

8010687f <vector242>:
.globl vector242
vector242:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $242
80106881:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106886:	e9 6f f1 ff ff       	jmp    801059fa <alltraps>

8010688b <vector243>:
.globl vector243
vector243:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $243
8010688d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106892:	e9 63 f1 ff ff       	jmp    801059fa <alltraps>

80106897 <vector244>:
.globl vector244
vector244:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $244
80106899:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010689e:	e9 57 f1 ff ff       	jmp    801059fa <alltraps>

801068a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $245
801068a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801068aa:	e9 4b f1 ff ff       	jmp    801059fa <alltraps>

801068af <vector246>:
.globl vector246
vector246:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $246
801068b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801068b6:	e9 3f f1 ff ff       	jmp    801059fa <alltraps>

801068bb <vector247>:
.globl vector247
vector247:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $247
801068bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801068c2:	e9 33 f1 ff ff       	jmp    801059fa <alltraps>

801068c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $248
801068c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801068ce:	e9 27 f1 ff ff       	jmp    801059fa <alltraps>

801068d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $249
801068d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801068da:	e9 1b f1 ff ff       	jmp    801059fa <alltraps>

801068df <vector250>:
.globl vector250
vector250:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $250
801068e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801068e6:	e9 0f f1 ff ff       	jmp    801059fa <alltraps>

801068eb <vector251>:
.globl vector251
vector251:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $251
801068ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801068f2:	e9 03 f1 ff ff       	jmp    801059fa <alltraps>

801068f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $252
801068f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801068fe:	e9 f7 f0 ff ff       	jmp    801059fa <alltraps>

80106903 <vector253>:
.globl vector253
vector253:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $253
80106905:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010690a:	e9 eb f0 ff ff       	jmp    801059fa <alltraps>

8010690f <vector254>:
.globl vector254
vector254:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $254
80106911:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106916:	e9 df f0 ff ff       	jmp    801059fa <alltraps>

8010691b <vector255>:
.globl vector255
vector255:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $255
8010691d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106922:	e9 d3 f0 ff ff       	jmp    801059fa <alltraps>
80106927:	66 90                	xchg   %ax,%ax
80106929:	66 90                	xchg   %ax,%ax
8010692b:	66 90                	xchg   %ax,%ax
8010692d:	66 90                	xchg   %ax,%ax
8010692f:	90                   	nop

80106930 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	57                   	push   %edi
80106934:	56                   	push   %esi
80106935:	53                   	push   %ebx
80106936:	89 d3                	mov    %edx,%ebx
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80106938:	c1 ea 16             	shr    $0x16,%edx
8010693b:	8d 3c 90             	lea    (%eax,%edx,4),%edi

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
8010693e:	83 ec 0c             	sub    $0xc,%esp
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
80106941:	8b 07                	mov    (%edi),%eax
80106943:	a8 01                	test   $0x1,%al
80106945:	74 29                	je     80106970 <walkpgdir+0x40>
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
80106947:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010694c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
}
80106952:	8d 65 f4             	lea    -0xc(%ebp),%esp
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
80106955:	c1 eb 0a             	shr    $0xa,%ebx
80106958:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010695e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106961:	5b                   	pop    %ebx
80106962:	5e                   	pop    %esi
80106963:	5f                   	pop    %edi
80106964:	5d                   	pop    %ebp
80106965:	c3                   	ret    
80106966:	8d 76 00             	lea    0x0(%esi),%esi
80106969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
    } else {
        if (!alloc)
80106970:	85 c9                	test   %ecx,%ecx
80106972:	74 2c                	je     801069a0 <walkpgdir+0x70>

        // TODO HERE WE CREATE PYSYC MEMORY;
        // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
        // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.

        if ((pgtab = (pte_t *) kalloc()) == 0)
80106974:	e8 b7 be ff ff       	call   80102830 <kalloc>
80106979:	85 c0                	test   %eax,%eax
8010697b:	89 c6                	mov    %eax,%esi
8010697d:	74 21                	je     801069a0 <walkpgdir+0x70>
            return 0;
        // Make sure all those PTE_P bits are zero.
        memset(pgtab, 0, PGSIZE);
8010697f:	83 ec 04             	sub    $0x4,%esp
80106982:	68 00 10 00 00       	push   $0x1000
80106987:	6a 00                	push   $0x0
80106989:	50                   	push   %eax
8010698a:	e8 51 de ff ff       	call   801047e0 <memset>
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010698f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106995:	83 c4 10             	add    $0x10,%esp
80106998:	83 c8 07             	or     $0x7,%eax
8010699b:	89 07                	mov    %eax,(%edi)
8010699d:	eb b3                	jmp    80106952 <walkpgdir+0x22>
8010699f:	90                   	nop
    }
    return &pgtab[PTX(va)];
}
801069a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
    } else {
        if (!alloc)
            return 0;
801069a3:	31 c0                	xor    %eax,%eax
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
}
801069a5:	5b                   	pop    %ebx
801069a6:	5e                   	pop    %esi
801069a7:	5f                   	pop    %edi
801069a8:	5d                   	pop    %ebp
801069a9:	c3                   	ret    
801069aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801069b6:	89 d3                	mov    %edx,%ebx
801069b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801069be:	83 ec 1c             	sub    $0x1c,%esp
801069c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801069c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801069c8:	8b 7d 08             	mov    0x8(%ebp),%edi
801069cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801069d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801069d6:	29 df                	sub    %ebx,%edi
801069d8:	83 c8 01             	or     $0x1,%eax
801069db:	89 45 dc             	mov    %eax,-0x24(%ebp)
801069de:	eb 15                	jmp    801069f5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801069e0:	f6 00 01             	testb  $0x1,(%eax)
801069e3:	75 45                	jne    80106a2a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801069e5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801069e8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801069eb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801069ed:	74 31                	je     80106a20 <mappages+0x70>
      break;
    a += PGSIZE;
801069ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801069f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801069fd:	89 da                	mov    %ebx,%edx
801069ff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106a02:	e8 29 ff ff ff       	call   80106930 <walkpgdir>
80106a07:	85 c0                	test   %eax,%eax
80106a09:	75 d5                	jne    801069e0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106a0b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106a13:	5b                   	pop    %ebx
80106a14:	5e                   	pop    %esi
80106a15:	5f                   	pop    %edi
80106a16:	5d                   	pop    %ebp
80106a17:	c3                   	ret    
80106a18:	90                   	nop
80106a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106a23:	31 c0                	xor    %eax,%eax
}
80106a25:	5b                   	pop    %ebx
80106a26:	5e                   	pop    %esi
80106a27:	5f                   	pop    %edi
80106a28:	5d                   	pop    %ebp
80106a29:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106a2a:	83 ec 0c             	sub    $0xc,%esp
80106a2d:	68 88 7b 10 80       	push   $0x80107b88
80106a32:	e8 39 99 ff ff       	call   80100370 <panic>
80106a37:	89 f6                	mov    %esi,%esi
80106a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a40 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a46:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a4c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a4e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a54:	83 ec 1c             	sub    $0x1c,%esp
80106a57:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106a5a:	39 d3                	cmp    %edx,%ebx
80106a5c:	73 66                	jae    80106ac4 <deallocuvm.part.0+0x84>
80106a5e:	89 d6                	mov    %edx,%esi
80106a60:	eb 3d                	jmp    80106a9f <deallocuvm.part.0+0x5f>
80106a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106a68:	8b 10                	mov    (%eax),%edx
80106a6a:	f6 c2 01             	test   $0x1,%dl
80106a6d:	74 26                	je     80106a95 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106a6f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a75:	74 58                	je     80106acf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106a77:	83 ec 0c             	sub    $0xc,%esp
80106a7a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a83:	52                   	push   %edx
80106a84:	e8 f7 bb ff ff       	call   80102680 <kfree>
      *pte = 0;
80106a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a8c:	83 c4 10             	add    $0x10,%esp
80106a8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106a95:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a9b:	39 f3                	cmp    %esi,%ebx
80106a9d:	73 25                	jae    80106ac4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106a9f:	31 c9                	xor    %ecx,%ecx
80106aa1:	89 da                	mov    %ebx,%edx
80106aa3:	89 f8                	mov    %edi,%eax
80106aa5:	e8 86 fe ff ff       	call   80106930 <walkpgdir>
    if(!pte)
80106aaa:	85 c0                	test   %eax,%eax
80106aac:	75 ba                	jne    80106a68 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106aae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106ab4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106aba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ac0:	39 f3                	cmp    %esi,%ebx
80106ac2:	72 db                	jb     80106a9f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ac7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106aca:	5b                   	pop    %ebx
80106acb:	5e                   	pop    %esi
80106acc:	5f                   	pop    %edi
80106acd:	5d                   	pop    %ebp
80106ace:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106acf:	83 ec 0c             	sub    $0xc,%esp
80106ad2:	68 4a 75 10 80       	push   $0x8010754a
80106ad7:	e8 94 98 ff ff       	call   80100370 <panic>
80106adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ae0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106ae6:	e8 15 d0 ff ff       	call   80103b00 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106aeb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106af1:	31 c9                	xor    %ecx,%ecx
80106af3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106af8:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
80106aff:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b06:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106b0b:	31 c9                	xor    %ecx,%ecx
80106b0d:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b14:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b19:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b20:	31 c9                	xor    %ecx,%ecx
80106b22:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
80106b29:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b30:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106b35:	31 c9                	xor    %ecx,%ecx
80106b37:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b3e:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106b45:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106b4a:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
80106b51:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
80106b58:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b5f:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80106b66:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
80106b6d:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
80106b74:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b7b:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80106b82:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80106b89:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80106b90:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b97:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
80106b9e:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80106ba5:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
80106bac:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
80106bb3:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106bba:	05 f0 27 11 80       	add    $0x801127f0,%eax
80106bbf:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106bc3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106bc7:	c1 e8 10             	shr    $0x10,%eax
80106bca:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106bce:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bd1:	0f 01 10             	lgdtl  (%eax)
}
80106bd4:	c9                   	leave  
80106bd5:	c3                   	ret    
80106bd6:	8d 76 00             	lea    0x0(%esi),%esi
80106bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106be0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106be0:	a1 a4 65 11 80       	mov    0x801165a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106be5:	55                   	push   %ebp
80106be6:	89 e5                	mov    %esp,%ebp
80106be8:	05 00 00 00 80       	add    $0x80000000,%eax
80106bed:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106bf0:	5d                   	pop    %ebp
80106bf1:	c3                   	ret    
80106bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c00 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
80106c06:	83 ec 1c             	sub    $0x1c,%esp
80106c09:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c0c:	85 f6                	test   %esi,%esi
80106c0e:	0f 84 cd 00 00 00    	je     80106ce1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106c14:	8b 46 08             	mov    0x8(%esi),%eax
80106c17:	85 c0                	test   %eax,%eax
80106c19:	0f 84 dc 00 00 00    	je     80106cfb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106c1f:	8b 7e 04             	mov    0x4(%esi),%edi
80106c22:	85 ff                	test   %edi,%edi
80106c24:	0f 84 c4 00 00 00    	je     80106cee <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80106c2a:	e8 01 da ff ff       	call   80104630 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c2f:	e8 4c ce ff ff       	call   80103a80 <mycpu>
80106c34:	89 c3                	mov    %eax,%ebx
80106c36:	e8 45 ce ff ff       	call   80103a80 <mycpu>
80106c3b:	89 c7                	mov    %eax,%edi
80106c3d:	e8 3e ce ff ff       	call   80103a80 <mycpu>
80106c42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c45:	83 c7 08             	add    $0x8,%edi
80106c48:	e8 33 ce ff ff       	call   80103a80 <mycpu>
80106c4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c50:	83 c0 08             	add    $0x8,%eax
80106c53:	ba 67 00 00 00       	mov    $0x67,%edx
80106c58:	c1 e8 18             	shr    $0x18,%eax
80106c5b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106c62:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106c69:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106c70:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106c77:	83 c1 08             	add    $0x8,%ecx
80106c7a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106c80:	c1 e9 10             	shr    $0x10,%ecx
80106c83:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c89:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106c8e:	e8 ed cd ff ff       	call   80103a80 <mycpu>
80106c93:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c9a:	e8 e1 cd ff ff       	call   80103a80 <mycpu>
80106c9f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106ca4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ca8:	e8 d3 cd ff ff       	call   80103a80 <mycpu>
80106cad:	8b 56 08             	mov    0x8(%esi),%edx
80106cb0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106cb6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cb9:	e8 c2 cd ff ff       	call   80103a80 <mycpu>
80106cbe:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106cc2:	b8 28 00 00 00       	mov    $0x28,%eax
80106cc7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cca:	8b 46 04             	mov    0x4(%esi),%eax
80106ccd:	05 00 00 00 80       	add    $0x80000000,%eax
80106cd2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106cd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cd8:	5b                   	pop    %ebx
80106cd9:	5e                   	pop    %esi
80106cda:	5f                   	pop    %edi
80106cdb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106cdc:	e9 3f da ff ff       	jmp    80104720 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106ce1:	83 ec 0c             	sub    $0xc,%esp
80106ce4:	68 8e 7b 10 80       	push   $0x80107b8e
80106ce9:	e8 82 96 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106cee:	83 ec 0c             	sub    $0xc,%esp
80106cf1:	68 b9 7b 10 80       	push   $0x80107bb9
80106cf6:	e8 75 96 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106cfb:	83 ec 0c             	sub    $0xc,%esp
80106cfe:	68 a4 7b 10 80       	push   $0x80107ba4
80106d03:	e8 68 96 ff ff       	call   80100370 <panic>
80106d08:	90                   	nop
80106d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d10 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
80106d19:	8b 75 10             	mov    0x10(%ebp),%esi
80106d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106d22:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106d28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106d2b:	77 49                	ja     80106d76 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106d2d:	e8 fe ba ff ff       	call   80102830 <kalloc>
  memset(mem, 0, PGSIZE);
80106d32:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106d35:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d37:	68 00 10 00 00       	push   $0x1000
80106d3c:	6a 00                	push   $0x0
80106d3e:	50                   	push   %eax
80106d3f:	e8 9c da ff ff       	call   801047e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d44:	58                   	pop    %eax
80106d45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d50:	5a                   	pop    %edx
80106d51:	6a 06                	push   $0x6
80106d53:	50                   	push   %eax
80106d54:	31 d2                	xor    %edx,%edx
80106d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d59:	e8 52 fc ff ff       	call   801069b0 <mappages>
  memmove(mem, init, sz);
80106d5e:	89 75 10             	mov    %esi,0x10(%ebp)
80106d61:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106d64:	83 c4 10             	add    $0x10,%esp
80106d67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d6d:	5b                   	pop    %ebx
80106d6e:	5e                   	pop    %esi
80106d6f:	5f                   	pop    %edi
80106d70:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106d71:	e9 1a db ff ff       	jmp    80104890 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106d76:	83 ec 0c             	sub    $0xc,%esp
80106d79:	68 cd 7b 10 80       	push   $0x80107bcd
80106d7e:	e8 ed 95 ff ff       	call   80100370 <panic>
80106d83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d90 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
80106d96:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106d99:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106da0:	0f 85 91 00 00 00    	jne    80106e37 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106da6:	8b 75 18             	mov    0x18(%ebp),%esi
80106da9:	31 db                	xor    %ebx,%ebx
80106dab:	85 f6                	test   %esi,%esi
80106dad:	75 1a                	jne    80106dc9 <loaduvm+0x39>
80106daf:	eb 6f                	jmp    80106e20 <loaduvm+0x90>
80106db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106db8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dbe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106dc4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106dc7:	76 57                	jbe    80106e20 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106dc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80106dcf:	31 c9                	xor    %ecx,%ecx
80106dd1:	01 da                	add    %ebx,%edx
80106dd3:	e8 58 fb ff ff       	call   80106930 <walkpgdir>
80106dd8:	85 c0                	test   %eax,%eax
80106dda:	74 4e                	je     80106e2a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106ddc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106dde:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106de1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106de6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106deb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106df1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106df4:	01 d9                	add    %ebx,%ecx
80106df6:	05 00 00 00 80       	add    $0x80000000,%eax
80106dfb:	57                   	push   %edi
80106dfc:	51                   	push   %ecx
80106dfd:	50                   	push   %eax
80106dfe:	ff 75 10             	pushl  0x10(%ebp)
80106e01:	e8 4a ab ff ff       	call   80101950 <readi>
80106e06:	83 c4 10             	add    $0x10,%esp
80106e09:	39 c7                	cmp    %eax,%edi
80106e0b:	74 ab                	je     80106db8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106e15:	5b                   	pop    %ebx
80106e16:	5e                   	pop    %esi
80106e17:	5f                   	pop    %edi
80106e18:	5d                   	pop    %ebp
80106e19:	c3                   	ret    
80106e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106e23:	31 c0                	xor    %eax,%eax
}
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5f                   	pop    %edi
80106e28:	5d                   	pop    %ebp
80106e29:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106e2a:	83 ec 0c             	sub    $0xc,%esp
80106e2d:	68 e7 7b 10 80       	push   $0x80107be7
80106e32:	e8 39 95 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106e37:	83 ec 0c             	sub    $0xc,%esp
80106e3a:	68 88 7c 10 80       	push   $0x80107c88
80106e3f:	e8 2c 95 ff ff       	call   80100370 <panic>
80106e44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e50 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
80106e56:	83 ec 0c             	sub    $0xc,%esp
80106e59:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106e5c:	85 ff                	test   %edi,%edi
80106e5e:	0f 88 ca 00 00 00    	js     80106f2e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106e64:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106e6a:	0f 82 82 00 00 00    	jb     80106ef2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106e70:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106e76:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106e7c:	39 df                	cmp    %ebx,%edi
80106e7e:	77 43                	ja     80106ec3 <allocuvm+0x73>
80106e80:	e9 bb 00 00 00       	jmp    80106f40 <allocuvm+0xf0>
80106e85:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106e88:	83 ec 04             	sub    $0x4,%esp
80106e8b:	68 00 10 00 00       	push   $0x1000
80106e90:	6a 00                	push   $0x0
80106e92:	50                   	push   %eax
80106e93:	e8 48 d9 ff ff       	call   801047e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e98:	58                   	pop    %eax
80106e99:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e9f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ea4:	5a                   	pop    %edx
80106ea5:	6a 06                	push   $0x6
80106ea7:	50                   	push   %eax
80106ea8:	89 da                	mov    %ebx,%edx
80106eaa:	8b 45 08             	mov    0x8(%ebp),%eax
80106ead:	e8 fe fa ff ff       	call   801069b0 <mappages>
80106eb2:	83 c4 10             	add    $0x10,%esp
80106eb5:	85 c0                	test   %eax,%eax
80106eb7:	78 47                	js     80106f00 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106eb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ebf:	39 df                	cmp    %ebx,%edi
80106ec1:	76 7d                	jbe    80106f40 <allocuvm+0xf0>
      // TODO HERE WE CREATE PYSYC MEMORY;
      // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
      // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.
    mem = kalloc();
80106ec3:	e8 68 b9 ff ff       	call   80102830 <kalloc>
    if(mem == 0){
80106ec8:	85 c0                	test   %eax,%eax
  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
      // TODO HERE WE CREATE PYSYC MEMORY;
      // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
      // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.
    mem = kalloc();
80106eca:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106ecc:	75 ba                	jne    80106e88 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106ece:	83 ec 0c             	sub    $0xc,%esp
80106ed1:	68 05 7c 10 80       	push   $0x80107c05
80106ed6:	e8 85 97 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106edb:	83 c4 10             	add    $0x10,%esp
80106ede:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ee1:	76 4b                	jbe    80106f2e <allocuvm+0xde>
80106ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ee6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ee9:	89 fa                	mov    %edi,%edx
80106eeb:	e8 50 fb ff ff       	call   80106a40 <deallocuvm.part.0>
      // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106ef0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106ef2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ef5:	5b                   	pop    %ebx
80106ef6:	5e                   	pop    %esi
80106ef7:	5f                   	pop    %edi
80106ef8:	5d                   	pop    %ebp
80106ef9:	c3                   	ret    
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106f00:	83 ec 0c             	sub    $0xc,%esp
80106f03:	68 1d 7c 10 80       	push   $0x80107c1d
80106f08:	e8 53 97 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106f0d:	83 c4 10             	add    $0x10,%esp
80106f10:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f13:	76 0d                	jbe    80106f22 <allocuvm+0xd2>
80106f15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f18:	8b 45 08             	mov    0x8(%ebp),%eax
80106f1b:	89 fa                	mov    %edi,%edx
80106f1d:	e8 1e fb ff ff       	call   80106a40 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106f22:	83 ec 0c             	sub    $0xc,%esp
80106f25:	56                   	push   %esi
80106f26:	e8 55 b7 ff ff       	call   80102680 <kfree>
      return 0;
80106f2b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106f31:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106f33:	5b                   	pop    %ebx
80106f34:	5e                   	pop    %esi
80106f35:	5f                   	pop    %edi
80106f36:	5d                   	pop    %ebp
80106f37:	c3                   	ret    
80106f38:	90                   	nop
80106f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106f43:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106f45:	5b                   	pop    %ebx
80106f46:	5e                   	pop    %esi
80106f47:	5f                   	pop    %edi
80106f48:	5d                   	pop    %ebp
80106f49:	c3                   	ret    
80106f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f50 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f56:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f59:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106f5c:	39 d1                	cmp    %edx,%ecx
80106f5e:	73 10                	jae    80106f70 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106f60:	5d                   	pop    %ebp
80106f61:	e9 da fa ff ff       	jmp    80106a40 <deallocuvm.part.0>
80106f66:	8d 76 00             	lea    0x0(%esi),%esi
80106f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106f70:	89 d0                	mov    %edx,%eax
80106f72:	5d                   	pop    %ebp
80106f73:	c3                   	ret    
80106f74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	57                   	push   %edi
80106f84:	56                   	push   %esi
80106f85:	53                   	push   %ebx
80106f86:	83 ec 0c             	sub    $0xc,%esp
80106f89:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f8c:	85 f6                	test   %esi,%esi
80106f8e:	74 59                	je     80106fe9 <freevm+0x69>
80106f90:	31 c9                	xor    %ecx,%ecx
80106f92:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f97:	89 f0                	mov    %esi,%eax
80106f99:	e8 a2 fa ff ff       	call   80106a40 <deallocuvm.part.0>
80106f9e:	89 f3                	mov    %esi,%ebx
80106fa0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106fa6:	eb 0f                	jmp    80106fb7 <freevm+0x37>
80106fa8:	90                   	nop
80106fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fb0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106fb3:	39 fb                	cmp    %edi,%ebx
80106fb5:	74 23                	je     80106fda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106fb7:	8b 03                	mov    (%ebx),%eax
80106fb9:	a8 01                	test   $0x1,%al
80106fbb:	74 f3                	je     80106fb0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106fbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fc2:	83 ec 0c             	sub    $0xc,%esp
80106fc5:	83 c3 04             	add    $0x4,%ebx
80106fc8:	05 00 00 00 80       	add    $0x80000000,%eax
80106fcd:	50                   	push   %eax
80106fce:	e8 ad b6 ff ff       	call   80102680 <kfree>
80106fd3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106fd6:	39 fb                	cmp    %edi,%ebx
80106fd8:	75 dd                	jne    80106fb7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106fda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fe0:	5b                   	pop    %ebx
80106fe1:	5e                   	pop    %esi
80106fe2:	5f                   	pop    %edi
80106fe3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106fe4:	e9 97 b6 ff ff       	jmp    80102680 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106fe9:	83 ec 0c             	sub    $0xc,%esp
80106fec:	68 39 7c 10 80       	push   $0x80107c39
80106ff1:	e8 7a 93 ff ff       	call   80100370 <panic>
80106ff6:	8d 76 00             	lea    0x0(%esi),%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107000 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	56                   	push   %esi
80107004:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107005:	e8 26 b8 ff ff       	call   80102830 <kalloc>
8010700a:	85 c0                	test   %eax,%eax
8010700c:	74 6a                	je     80107078 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010700e:	83 ec 04             	sub    $0x4,%esp
80107011:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107013:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107018:	68 00 10 00 00       	push   $0x1000
8010701d:	6a 00                	push   $0x0
8010701f:	50                   	push   %eax
80107020:	e8 bb d7 ff ff       	call   801047e0 <memset>
80107025:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107028:	8b 43 04             	mov    0x4(%ebx),%eax
8010702b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010702e:	83 ec 08             	sub    $0x8,%esp
80107031:	8b 13                	mov    (%ebx),%edx
80107033:	ff 73 0c             	pushl  0xc(%ebx)
80107036:	50                   	push   %eax
80107037:	29 c1                	sub    %eax,%ecx
80107039:	89 f0                	mov    %esi,%eax
8010703b:	e8 70 f9 ff ff       	call   801069b0 <mappages>
80107040:	83 c4 10             	add    $0x10,%esp
80107043:	85 c0                	test   %eax,%eax
80107045:	78 19                	js     80107060 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107047:	83 c3 10             	add    $0x10,%ebx
8010704a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107050:	75 d6                	jne    80107028 <setupkvm+0x28>
80107052:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107054:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107057:	5b                   	pop    %ebx
80107058:	5e                   	pop    %esi
80107059:	5d                   	pop    %ebp
8010705a:	c3                   	ret    
8010705b:	90                   	nop
8010705c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107060:	83 ec 0c             	sub    $0xc,%esp
80107063:	56                   	push   %esi
80107064:	e8 17 ff ff ff       	call   80106f80 <freevm>
      return 0;
80107069:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010706c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010706f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107071:	5b                   	pop    %ebx
80107072:	5e                   	pop    %esi
80107073:	5d                   	pop    %ebp
80107074:	c3                   	ret    
80107075:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107078:	31 c0                	xor    %eax,%eax
8010707a:	eb d8                	jmp    80107054 <setupkvm+0x54>
8010707c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107080 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107086:	e8 75 ff ff ff       	call   80107000 <setupkvm>
8010708b:	a3 a4 65 11 80       	mov    %eax,0x801165a4
80107090:	05 00 00 00 80       	add    $0x80000000,%eax
80107095:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107098:	c9                   	leave  
80107099:	c3                   	ret    
8010709a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801070a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070a1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801070a3:	89 e5                	mov    %esp,%ebp
801070a5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801070ab:	8b 45 08             	mov    0x8(%ebp),%eax
801070ae:	e8 7d f8 ff ff       	call   80106930 <walkpgdir>
  if(pte == 0)
801070b3:	85 c0                	test   %eax,%eax
801070b5:	74 05                	je     801070bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801070b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801070ba:	c9                   	leave  
801070bb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801070bc:	83 ec 0c             	sub    $0xc,%esp
801070bf:	68 4a 7c 10 80       	push   $0x80107c4a
801070c4:	e8 a7 92 ff ff       	call   80100370 <panic>
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801070d9:	e8 22 ff ff ff       	call   80107000 <setupkvm>
801070de:	85 c0                	test   %eax,%eax
801070e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070e3:	0f 84 b2 00 00 00    	je     8010719b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070ec:	85 c9                	test   %ecx,%ecx
801070ee:	0f 84 9c 00 00 00    	je     80107190 <copyuvm+0xc0>
801070f4:	31 f6                	xor    %esi,%esi
801070f6:	eb 4a                	jmp    80107142 <copyuvm+0x72>
801070f8:	90                   	nop
801070f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107100:	83 ec 04             	sub    $0x4,%esp
80107103:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107109:	68 00 10 00 00       	push   $0x1000
8010710e:	57                   	push   %edi
8010710f:	50                   	push   %eax
80107110:	e8 7b d7 ff ff       	call   80104890 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107115:	58                   	pop    %eax
80107116:	5a                   	pop    %edx
80107117:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
8010711d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107120:	ff 75 e4             	pushl  -0x1c(%ebp)
80107123:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107128:	52                   	push   %edx
80107129:	89 f2                	mov    %esi,%edx
8010712b:	e8 80 f8 ff ff       	call   801069b0 <mappages>
80107130:	83 c4 10             	add    $0x10,%esp
80107133:	85 c0                	test   %eax,%eax
80107135:	78 3e                	js     80107175 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107137:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010713d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107140:	76 4e                	jbe    80107190 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107142:	8b 45 08             	mov    0x8(%ebp),%eax
80107145:	31 c9                	xor    %ecx,%ecx
80107147:	89 f2                	mov    %esi,%edx
80107149:	e8 e2 f7 ff ff       	call   80106930 <walkpgdir>
8010714e:	85 c0                	test   %eax,%eax
80107150:	74 5a                	je     801071ac <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107152:	8b 18                	mov    (%eax),%ebx
80107154:	f6 c3 01             	test   $0x1,%bl
80107157:	74 46                	je     8010719f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107159:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010715b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107161:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107164:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010716a:	e8 c1 b6 ff ff       	call   80102830 <kalloc>
8010716f:	85 c0                	test   %eax,%eax
80107171:	89 c3                	mov    %eax,%ebx
80107173:	75 8b                	jne    80107100 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107175:	83 ec 0c             	sub    $0xc,%esp
80107178:	ff 75 e0             	pushl  -0x20(%ebp)
8010717b:	e8 00 fe ff ff       	call   80106f80 <freevm>
  return 0;
80107180:	83 c4 10             	add    $0x10,%esp
80107183:	31 c0                	xor    %eax,%eax
}
80107185:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107188:	5b                   	pop    %ebx
80107189:	5e                   	pop    %esi
8010718a:	5f                   	pop    %edi
8010718b:	5d                   	pop    %ebp
8010718c:	c3                   	ret    
8010718d:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107190:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107193:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107196:	5b                   	pop    %ebx
80107197:	5e                   	pop    %esi
80107198:	5f                   	pop    %edi
80107199:	5d                   	pop    %ebp
8010719a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010719b:	31 c0                	xor    %eax,%eax
8010719d:	eb e6                	jmp    80107185 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
8010719f:	83 ec 0c             	sub    $0xc,%esp
801071a2:	68 6e 7c 10 80       	push   $0x80107c6e
801071a7:	e8 c4 91 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801071ac:	83 ec 0c             	sub    $0xc,%esp
801071af:	68 54 7c 10 80       	push   $0x80107c54
801071b4:	e8 b7 91 ff ff       	call   80100370 <panic>
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071c1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071c3:	89 e5                	mov    %esp,%ebp
801071c5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071cb:	8b 45 08             	mov    0x8(%ebp),%eax
801071ce:	e8 5d f7 ff ff       	call   80106930 <walkpgdir>
  if((*pte & PTE_P) == 0)
801071d3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801071d5:	89 c2                	mov    %eax,%edx
801071d7:	83 e2 05             	and    $0x5,%edx
801071da:	83 fa 05             	cmp    $0x5,%edx
801071dd:	75 11                	jne    801071f0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801071df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801071e4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801071e5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801071ea:	c3                   	ret    
801071eb:	90                   	nop
801071ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801071f0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801071f2:	c9                   	leave  
801071f3:	c3                   	ret    
801071f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
80107206:	83 ec 1c             	sub    $0x1c,%esp
80107209:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010720c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010720f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107212:	85 db                	test   %ebx,%ebx
80107214:	75 40                	jne    80107256 <copyout+0x56>
80107216:	eb 70                	jmp    80107288 <copyout+0x88>
80107218:	90                   	nop
80107219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107220:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107223:	89 f1                	mov    %esi,%ecx
80107225:	29 d1                	sub    %edx,%ecx
80107227:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010722d:	39 d9                	cmp    %ebx,%ecx
8010722f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107232:	29 f2                	sub    %esi,%edx
80107234:	83 ec 04             	sub    $0x4,%esp
80107237:	01 d0                	add    %edx,%eax
80107239:	51                   	push   %ecx
8010723a:	57                   	push   %edi
8010723b:	50                   	push   %eax
8010723c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010723f:	e8 4c d6 ff ff       	call   80104890 <memmove>
    len -= n;
    buf += n;
80107244:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107247:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010724a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107250:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107252:	29 cb                	sub    %ecx,%ebx
80107254:	74 32                	je     80107288 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107256:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107258:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010725b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010725e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107264:	56                   	push   %esi
80107265:	ff 75 08             	pushl  0x8(%ebp)
80107268:	e8 53 ff ff ff       	call   801071c0 <uva2ka>
    if(pa0 == 0)
8010726d:	83 c4 10             	add    $0x10,%esp
80107270:	85 c0                	test   %eax,%eax
80107272:	75 ac                	jne    80107220 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107274:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107277:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010727c:	5b                   	pop    %ebx
8010727d:	5e                   	pop    %esi
8010727e:	5f                   	pop    %edi
8010727f:	5d                   	pop    %ebp
80107280:	c3                   	ret    
80107281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107288:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010728b:	31 c0                	xor    %eax,%eax
}
8010728d:	5b                   	pop    %ebx
8010728e:	5e                   	pop    %esi
8010728f:	5f                   	pop    %edi
80107290:	5d                   	pop    %ebp
80107291:	c3                   	ret    
