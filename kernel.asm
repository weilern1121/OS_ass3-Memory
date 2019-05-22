
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
8010002d:	b8 20 32 10 80       	mov    $0x80103220,%eax
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
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 78 10 80       	push   $0x801078e0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 75 48 00 00       	call   801048d0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
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
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 78 10 80       	push   $0x801078e7
80100097:	50                   	push   %eax
80100098:	e8 23 47 00 00       	call   801047c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

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
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
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
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 e7 48 00 00       	call   801049d0 <acquire>

  // Is the block already cached?
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
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
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
80100162:	e8 89 49 00 00       	call   80104af0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 46 00 00       	call   80104800 <acquiresleep>
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
8010017e:	e8 2d 23 00 00       	call   801024b0 <iderw>
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
80100193:	68 ee 78 10 80       	push   $0x801078ee
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
801001ae:	e8 ed 46 00 00       	call   801048a0 <holdingsleep>
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
801001c4:	e9 e7 22 00 00       	jmp    801024b0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 78 10 80       	push   $0x801078ff
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
801001ef:	e8 ac 46 00 00       	call   801048a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 46 00 00       	call   80104860 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 c0 47 00 00       	call   801049d0 <acquire>
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
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
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
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 8f 48 00 00       	jmp    80104af0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 79 10 80       	push   $0x80107906
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
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 3f 47 00 00       	call   801049d0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002a6:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 a0 0f 11 80       	push   $0x80110fa0
801002bd:	e8 de 40 00 00       	call   801043a0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 19 39 00 00       	call   80103bf0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 05 48 00 00       	call   80104af0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 9d 13 00 00       	call   80101690 <ilock>
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
8010030b:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%edx
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
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 a5 47 00 00       	call   80104af0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 3d 13 00 00       	call   80101690 <ilock>

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
80100360:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
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
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
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
80100389:	e8 22 27 00 00       	call   80102ab0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 0d 79 10 80       	push   $0x8010790d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 e3 82 10 80 	movl   $0x801082e3,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 33 45 00 00       	call   801048f0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 21 79 10 80       	push   $0x80107921
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
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
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
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
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
8010041a:	e8 e1 5d 00 00       	call   80106200 <uartputc>
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
801004d3:	e8 28 5d 00 00       	call   80106200 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 1c 5d 00 00       	call   80106200 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 10 5d 00 00       	call   80106200 <uartputc>
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
80100514:	e8 d7 46 00 00       	call   80104bf0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 12 46 00 00       	call   80104b40 <memset>
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
80100540:	68 25 79 10 80       	push   $0x80107925
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
801005b1:	0f b6 92 50 79 10 80 	movzbl -0x7fef86b0(%edx),%edx
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
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 b0 43 00 00       	call   801049d0 <acquire>
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
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 a4 44 00 00       	call   80104af0 <release>
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
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
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
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 de 43 00 00       	call   80104af0 <release>
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
80100788:	b8 38 79 10 80       	mov    $0x80107938,%eax
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
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 03 42 00 00       	call   801049d0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 3f 79 10 80       	push   $0x8010793f
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
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 c8 41 00 00       	call   801049d0 <acquire>
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
80100831:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100836:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 83 42 00 00       	call   80104af0 <release>
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
80100889:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
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
801008a8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
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
801008ec:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801008f1:	68 a0 0f 11 80       	push   $0x80110fa0
801008f6:	e8 15 3d 00 00       	call   80104610 <wakeup>
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
80100908:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010090d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100934:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
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
80100948:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
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
80100977:	e9 84 3d 00 00       	jmp    80104700 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
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
801009a6:	68 48 79 10 80       	push   $0x80107948
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 1b 3f 00 00       	call   801048d0 <initlock>

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
801009bb:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 82 1c 00 00       	call   80102660 <ioapicenable>
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
801009fc:	e8 ef 31 00 00       	call   80103bf0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

    begin_op();
80100a07:	e8 04 25 00 00       	call   80102f10 <begin_op>

    if ((ip = namei(path)) == 0) {
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 c9 14 00 00       	call   80101ee0 <namei>
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
80100a28:	e8 63 0c 00 00       	call   80101690 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char *) &elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 32 0f 00 00       	call   80101970 <readi>
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
80100a4a:	e8 d1 0e 00 00       	call   80101920 <iunlockput>
        end_op();
80100a4f:	e8 2c 25 00 00       	call   80102f80 <end_op>
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
80100a74:	e8 b7 6b 00 00       	call   80107630 <setupkvm>
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
80100ac8:	e8 a3 0e 00 00       	call   80101970 <readi>
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
80100b04:	e8 b7 67 00 00       	call   801072c0 <allocuvm>
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
80100b3a:	e8 41 65 00 00       	call   80107080 <loaduvm>
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
80100b59:	e8 52 6a 00 00       	call   801075b0 <freevm>
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
80100b6a:	e8 b1 0d 00 00       	call   80101920 <iunlockput>
    end_op();
80100b6f:	e8 0c 24 00 00       	call   80102f80 <end_op>
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
80100b95:	e8 26 67 00 00       	call   801072c0 <allocuvm>
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
80100bac:	e8 ff 69 00 00       	call   801075b0 <freevm>
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
80100bbe:	e8 bd 23 00 00       	call   80102f80 <end_op>
        cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 61 79 10 80       	push   $0x80107961
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
80100bf1:	e8 da 6a 00 00       	call   801076d0 <clearpteu>
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
80100c2d:	e8 4e 41 00 00       	call   80104d80 <strlen>
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
80100c40:	e8 3b 41 00 00       	call   80104d80 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 da 6b 00 00       	call   80107830 <copyout>
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
80100cbd:	e8 6e 6b 00 00       	call   80107830 <copyout>
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
80100d02:	e8 39 40 00 00       	call   80104d40 <safestrcpy>

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
80100d07:	89 d8                	mov    %ebx,%eax
    curproc->pgdir = pgdir;
    //TODO WE NEED CLOSE AND OPEN SWAP
    if (curproc->pid > 2) {
80100d09:	83 c4 10             	add    $0x10,%esp
            last = s + 1;
    safestrcpy(curproc->name, last, sizeof(curproc->name));

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
    curproc->pgdir = pgdir;
80100d0c:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    //TODO WE NEED CLOSE AND OPEN SWAP
    if (curproc->pid > 2) {
80100d12:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
        if (*s == '/')
            last = s + 1;
    safestrcpy(curproc->name, last, sizeof(curproc->name));

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
80100d16:	8b 5b 04             	mov    0x4(%ebx),%ebx
    curproc->pgdir = pgdir;
80100d19:	89 48 04             	mov    %ecx,0x4(%eax)
    //TODO WE NEED CLOSE AND OPEN SWAP
    if (curproc->pid > 2) {
80100d1c:	7e 1d                	jle    80100d3b <exec+0x34b>
        removeSwapFile(curproc);
80100d1e:	83 ec 0c             	sub    $0xc,%esp
80100d21:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d27:	e8 94 12 00 00       	call   80101fc0 <removeSwapFile>
        createSwapFile(curproc);
80100d2c:	58                   	pop    %eax
80100d2d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d33:	e8 88 14 00 00       	call   801021c0 <createSwapFile>
80100d38:	83 c4 10             	add    $0x10,%esp
    }
    curproc->sz = sz;
80100d3b:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    curproc->tf->eip = elf.entry;  // main
    curproc->tf->esp = sp;
    switchuvm(curproc);
80100d41:	83 ec 0c             	sub    $0xc,%esp
    //TODO WE NEED CLOSE AND OPEN SWAP
    if (curproc->pid > 2) {
        removeSwapFile(curproc);
        createSwapFile(curproc);
    }
    curproc->sz = sz;
80100d44:	89 31                	mov    %esi,(%ecx)
    curproc->tf->eip = elf.entry;  // main
80100d46:	8b 41 18             	mov    0x18(%ecx),%eax
80100d49:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d4f:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
80100d52:	8b 41 18             	mov    0x18(%ecx),%eax
80100d55:	89 78 44             	mov    %edi,0x44(%eax)
    switchuvm(curproc);
80100d58:	51                   	push   %ecx
80100d59:	e8 92 61 00 00       	call   80106ef0 <switchuvm>
    freevm(oldpgdir);
80100d5e:	89 1c 24             	mov    %ebx,(%esp)
80100d61:	e8 4a 68 00 00       	call   801075b0 <freevm>
    if (DEBUGMODE == 1)
        cprintf(">EXEC-DONE!\t");
    return 0;
80100d66:	83 c4 10             	add    $0x10,%esp
80100d69:	31 c0                	xor    %eax,%eax
80100d6b:	e9 ec fc ff ff       	jmp    80100a5c <exec+0x6c>

80100d70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d76:	68 6d 79 10 80       	push   $0x8010796d
80100d7b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d80:	e8 4b 3b 00 00       	call   801048d0 <initlock>
}
80100d85:	83 c4 10             	add    $0x10,%esp
80100d88:	c9                   	leave  
80100d89:	c3                   	ret    
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d94:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d99:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d9c:	68 c0 0f 11 80       	push   $0x80110fc0
80100da1:	e8 2a 3c 00 00       	call   801049d0 <acquire>
80100da6:	83 c4 10             	add    $0x10,%esp
80100da9:	eb 10                	jmp    80100dbb <filealloc+0x2b>
80100dab:	90                   	nop
80100dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db0:	83 c3 18             	add    $0x18,%ebx
80100db3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100db9:	74 25                	je     80100de0 <filealloc+0x50>
    if(f->ref == 0){
80100dbb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dbe:	85 c0                	test   %eax,%eax
80100dc0:	75 ee                	jne    80100db0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dc2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100dc5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dcc:	68 c0 0f 11 80       	push   $0x80110fc0
80100dd1:	e8 1a 3d 00 00       	call   80104af0 <release>
      return f;
80100dd6:	89 d8                	mov    %ebx,%eax
80100dd8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ddb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dde:	c9                   	leave  
80100ddf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100de0:	83 ec 0c             	sub    $0xc,%esp
80100de3:	68 c0 0f 11 80       	push   $0x80110fc0
80100de8:	e8 03 3d 00 00       	call   80104af0 <release>
  return 0;
80100ded:	83 c4 10             	add    $0x10,%esp
80100df0:	31 c0                	xor    %eax,%eax
}
80100df2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df5:	c9                   	leave  
80100df6:	c3                   	ret    
80100df7:	89 f6                	mov    %esi,%esi
80100df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e00 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
80100e04:	83 ec 10             	sub    $0x10,%esp
80100e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e0a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e0f:	e8 bc 3b 00 00       	call   801049d0 <acquire>
  if(f->ref < 1)
80100e14:	8b 43 04             	mov    0x4(%ebx),%eax
80100e17:	83 c4 10             	add    $0x10,%esp
80100e1a:	85 c0                	test   %eax,%eax
80100e1c:	7e 1a                	jle    80100e38 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e1e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e21:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e24:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e27:	68 c0 0f 11 80       	push   $0x80110fc0
80100e2c:	e8 bf 3c 00 00       	call   80104af0 <release>
  return f;
}
80100e31:	89 d8                	mov    %ebx,%eax
80100e33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e36:	c9                   	leave  
80100e37:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e38:	83 ec 0c             	sub    $0xc,%esp
80100e3b:	68 74 79 10 80       	push   $0x80107974
80100e40:	e8 2b f5 ff ff       	call   80100370 <panic>
80100e45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e50 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	57                   	push   %edi
80100e54:	56                   	push   %esi
80100e55:	53                   	push   %ebx
80100e56:	83 ec 28             	sub    $0x28,%esp
80100e59:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e5c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e61:	e8 6a 3b 00 00       	call   801049d0 <acquire>
  if(f->ref < 1)
80100e66:	8b 47 04             	mov    0x4(%edi),%eax
80100e69:	83 c4 10             	add    $0x10,%esp
80100e6c:	85 c0                	test   %eax,%eax
80100e6e:	0f 8e 9b 00 00 00    	jle    80100f0f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e74:	83 e8 01             	sub    $0x1,%eax
80100e77:	85 c0                	test   %eax,%eax
80100e79:	89 47 04             	mov    %eax,0x4(%edi)
80100e7c:	74 1a                	je     80100e98 <fileclose+0x48>
    release(&ftable.lock);
80100e7e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e88:	5b                   	pop    %ebx
80100e89:	5e                   	pop    %esi
80100e8a:	5f                   	pop    %edi
80100e8b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e8c:	e9 5f 3c 00 00       	jmp    80104af0 <release>
80100e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e98:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e9c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e9e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ea1:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100ea4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eaa:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ead:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100eb0:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100eb8:	e8 33 3c 00 00       	call   80104af0 <release>

  if(ff.type == FD_PIPE)
80100ebd:	83 c4 10             	add    $0x10,%esp
80100ec0:	83 fb 01             	cmp    $0x1,%ebx
80100ec3:	74 13                	je     80100ed8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ec5:	83 fb 02             	cmp    $0x2,%ebx
80100ec8:	74 26                	je     80100ef0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ecd:	5b                   	pop    %ebx
80100ece:	5e                   	pop    %esi
80100ecf:	5f                   	pop    %edi
80100ed0:	5d                   	pop    %ebp
80100ed1:	c3                   	ret    
80100ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ed8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100edc:	83 ec 08             	sub    $0x8,%esp
80100edf:	53                   	push   %ebx
80100ee0:	56                   	push   %esi
80100ee1:	e8 ca 27 00 00       	call   801036b0 <pipeclose>
80100ee6:	83 c4 10             	add    $0x10,%esp
80100ee9:	eb df                	jmp    80100eca <fileclose+0x7a>
80100eeb:	90                   	nop
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ef0:	e8 1b 20 00 00       	call   80102f10 <begin_op>
    iput(ff.ip);
80100ef5:	83 ec 0c             	sub    $0xc,%esp
80100ef8:	ff 75 e0             	pushl  -0x20(%ebp)
80100efb:	e8 c0 08 00 00       	call   801017c0 <iput>
    end_op();
80100f00:	83 c4 10             	add    $0x10,%esp
  }
}
80100f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f06:	5b                   	pop    %ebx
80100f07:	5e                   	pop    %esi
80100f08:	5f                   	pop    %edi
80100f09:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100f0a:	e9 71 20 00 00       	jmp    80102f80 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	68 7c 79 10 80       	push   $0x8010797c
80100f17:	e8 54 f4 ff ff       	call   80100370 <panic>
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
80100f24:	83 ec 04             	sub    $0x4,%esp
80100f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f2a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f2d:	75 31                	jne    80100f60 <filestat+0x40>
    ilock(f->ip);
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	ff 73 10             	pushl  0x10(%ebx)
80100f35:	e8 56 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f3a:	58                   	pop    %eax
80100f3b:	5a                   	pop    %edx
80100f3c:	ff 75 0c             	pushl  0xc(%ebp)
80100f3f:	ff 73 10             	pushl  0x10(%ebx)
80100f42:	e8 f9 09 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f47:	59                   	pop    %ecx
80100f48:	ff 73 10             	pushl  0x10(%ebx)
80100f4b:	e8 20 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f50:	83 c4 10             	add    $0x10,%esp
80100f53:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f58:	c9                   	leave  
80100f59:	c3                   	ret    
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f68:	c9                   	leave  
80100f69:	c3                   	ret    
80100f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f70 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 0c             	sub    $0xc,%esp
80100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f82:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f86:	74 60                	je     80100fe8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f88:	8b 03                	mov    (%ebx),%eax
80100f8a:	83 f8 01             	cmp    $0x1,%eax
80100f8d:	74 41                	je     80100fd0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f8f:	83 f8 02             	cmp    $0x2,%eax
80100f92:	75 5b                	jne    80100fef <fileread+0x7f>
    ilock(f->ip);
80100f94:	83 ec 0c             	sub    $0xc,%esp
80100f97:	ff 73 10             	pushl  0x10(%ebx)
80100f9a:	e8 f1 06 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9f:	57                   	push   %edi
80100fa0:	ff 73 14             	pushl  0x14(%ebx)
80100fa3:	56                   	push   %esi
80100fa4:	ff 73 10             	pushl  0x10(%ebx)
80100fa7:	e8 c4 09 00 00       	call   80101970 <readi>
80100fac:	83 c4 20             	add    $0x20,%esp
80100faf:	85 c0                	test   %eax,%eax
80100fb1:	89 c6                	mov    %eax,%esi
80100fb3:	7e 03                	jle    80100fb8 <fileread+0x48>
      f->off += r;
80100fb5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fb8:	83 ec 0c             	sub    $0xc,%esp
80100fbb:	ff 73 10             	pushl  0x10(%ebx)
80100fbe:	e8 ad 07 00 00       	call   80101770 <iunlock>
    return r;
80100fc3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fc6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fcb:	5b                   	pop    %ebx
80100fcc:	5e                   	pop    %esi
80100fcd:	5f                   	pop    %edi
80100fce:	5d                   	pop    %ebp
80100fcf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fd0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fd3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd9:	5b                   	pop    %ebx
80100fda:	5e                   	pop    %esi
80100fdb:	5f                   	pop    %edi
80100fdc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fdd:	e9 6e 28 00 00       	jmp    80103850 <piperead>
80100fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fed:	eb d9                	jmp    80100fc8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	68 86 79 10 80       	push   $0x80107986
80100ff7:	e8 74 f3 ff ff       	call   80100370 <panic>
80100ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101000 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 1c             	sub    $0x1c,%esp
80101009:	8b 75 08             	mov    0x8(%ebp),%esi
8010100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010100f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101013:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101016:	8b 45 10             	mov    0x10(%ebp),%eax
80101019:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010101c:	0f 84 aa 00 00 00    	je     801010cc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101022:	8b 06                	mov    (%esi),%eax
80101024:	83 f8 01             	cmp    $0x1,%eax
80101027:	0f 84 c2 00 00 00    	je     801010ef <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102d:	83 f8 02             	cmp    $0x2,%eax
80101030:	0f 85 d8 00 00 00    	jne    8010110e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101039:	31 ff                	xor    %edi,%edi
8010103b:	85 c0                	test   %eax,%eax
8010103d:	7f 34                	jg     80101073 <filewrite+0x73>
8010103f:	e9 9c 00 00 00       	jmp    801010e0 <filewrite+0xe0>
80101044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101048:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101051:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101054:	e8 17 07 00 00       	call   80101770 <iunlock>
      end_op();
80101059:	e8 22 1f 00 00       	call   80102f80 <end_op>
8010105e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101061:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101064:	39 d8                	cmp    %ebx,%eax
80101066:	0f 85 95 00 00 00    	jne    80101101 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010106c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010106e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101071:	7e 6d                	jle    801010e0 <filewrite+0xe0>
      int n1 = n - i;
80101073:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101076:	b8 00 06 00 00       	mov    $0x600,%eax
8010107b:	29 fb                	sub    %edi,%ebx
8010107d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101083:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101086:	e8 85 1e 00 00       	call   80102f10 <begin_op>
      ilock(f->ip);
8010108b:	83 ec 0c             	sub    $0xc,%esp
8010108e:	ff 76 10             	pushl  0x10(%esi)
80101091:	e8 fa 05 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101096:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101099:	53                   	push   %ebx
8010109a:	ff 76 14             	pushl  0x14(%esi)
8010109d:	01 f8                	add    %edi,%eax
8010109f:	50                   	push   %eax
801010a0:	ff 76 10             	pushl  0x10(%esi)
801010a3:	e8 c8 09 00 00       	call   80101a70 <writei>
801010a8:	83 c4 20             	add    $0x20,%esp
801010ab:	85 c0                	test   %eax,%eax
801010ad:	7f 99                	jg     80101048 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	ff 76 10             	pushl  0x10(%esi)
801010b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010b8:	e8 b3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010bd:	e8 be 1e 00 00       	call   80102f80 <end_op>

      if(r < 0)
801010c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010c5:	83 c4 10             	add    $0x10,%esp
801010c8:	85 c0                	test   %eax,%eax
801010ca:	74 98                	je     80101064 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010d4:	5b                   	pop    %ebx
801010d5:	5e                   	pop    %esi
801010d6:	5f                   	pop    %edi
801010d7:	5d                   	pop    %ebp
801010d8:	c3                   	ret    
801010d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010e0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010e3:	75 e7                	jne    801010cc <filewrite+0xcc>
  }
  panic("filewrite");
}
801010e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e8:	89 f8                	mov    %edi,%eax
801010ea:	5b                   	pop    %ebx
801010eb:	5e                   	pop    %esi
801010ec:	5f                   	pop    %edi
801010ed:	5d                   	pop    %ebp
801010ee:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010ef:	8b 46 0c             	mov    0xc(%esi),%eax
801010f2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f8:	5b                   	pop    %ebx
801010f9:	5e                   	pop    %esi
801010fa:	5f                   	pop    %edi
801010fb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010fc:	e9 4f 26 00 00       	jmp    80103750 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101101:	83 ec 0c             	sub    $0xc,%esp
80101104:	68 8f 79 10 80       	push   $0x8010798f
80101109:	e8 62 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010110e:	83 ec 0c             	sub    $0xc,%esp
80101111:	68 95 79 10 80       	push   $0x80107995
80101116:	e8 55 f2 ff ff       	call   80100370 <panic>
8010111b:	66 90                	xchg   %ax,%ax
8010111d:	66 90                	xchg   %ax,%ax
8010111f:	90                   	nop

80101120 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101129:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010112f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101132:	85 c9                	test   %ecx,%ecx
80101134:	0f 84 85 00 00 00    	je     801011bf <balloc+0x9f>
8010113a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101141:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101144:	83 ec 08             	sub    $0x8,%esp
80101147:	89 f0                	mov    %esi,%eax
80101149:	c1 f8 0c             	sar    $0xc,%eax
8010114c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101152:	50                   	push   %eax
80101153:	ff 75 d8             	pushl  -0x28(%ebp)
80101156:	e8 75 ef ff ff       	call   801000d0 <bread>
8010115b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101163:	83 c4 10             	add    $0x10,%esp
80101166:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101169:	31 c0                	xor    %eax,%eax
8010116b:	eb 2d                	jmp    8010119a <balloc+0x7a>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101170:	89 c1                	mov    %eax,%ecx
80101172:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101177:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010117a:	83 e1 07             	and    $0x7,%ecx
8010117d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010117f:	89 c1                	mov    %eax,%ecx
80101181:	c1 f9 03             	sar    $0x3,%ecx
80101184:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101189:	85 d7                	test   %edx,%edi
8010118b:	74 43                	je     801011d0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010118d:	83 c0 01             	add    $0x1,%eax
80101190:	83 c6 01             	add    $0x1,%esi
80101193:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101198:	74 05                	je     8010119f <balloc+0x7f>
8010119a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010119d:	72 d1                	jb     80101170 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801011a5:	e8 36 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011aa:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011b1:	83 c4 10             	add    $0x10,%esp
801011b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b7:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801011bd:	77 82                	ja     80101141 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011bf:	83 ec 0c             	sub    $0xc,%esp
801011c2:	68 9f 79 10 80       	push   $0x8010799f
801011c7:	e8 a4 f1 ff ff       	call   80100370 <panic>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011d0:	09 fa                	or     %edi,%edx
801011d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011d5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011d8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011dc:	57                   	push   %edi
801011dd:	e8 0e 1f 00 00       	call   801030f0 <log_write>
        brelse(bp);
801011e2:	89 3c 24             	mov    %edi,(%esp)
801011e5:	e8 f6 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ea:	58                   	pop    %eax
801011eb:	5a                   	pop    %edx
801011ec:	56                   	push   %esi
801011ed:	ff 75 d8             	pushl  -0x28(%ebp)
801011f0:	e8 db ee ff ff       	call   801000d0 <bread>
801011f5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011fa:	83 c4 0c             	add    $0xc,%esp
801011fd:	68 00 02 00 00       	push   $0x200
80101202:	6a 00                	push   $0x0
80101204:	50                   	push   %eax
80101205:	e8 36 39 00 00       	call   80104b40 <memset>
  log_write(bp);
8010120a:	89 1c 24             	mov    %ebx,(%esp)
8010120d:	e8 de 1e 00 00       	call   801030f0 <log_write>
  brelse(bp);
80101212:	89 1c 24             	mov    %ebx,(%esp)
80101215:	e8 c6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010121a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121d:	89 f0                	mov    %esi,%eax
8010121f:	5b                   	pop    %ebx
80101220:	5e                   	pop    %esi
80101221:	5f                   	pop    %edi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
80101224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010122a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101230 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101238:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010123f:	83 ec 28             	sub    $0x28,%esp
80101242:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101245:	68 e0 19 11 80       	push   $0x801119e0
8010124a:	e8 81 37 00 00       	call   801049d0 <acquire>
8010124f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101252:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101255:	eb 1b                	jmp    80101272 <iget+0x42>
80101257:	89 f6                	mov    %esi,%esi
80101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101260:	85 f6                	test   %esi,%esi
80101262:	74 44                	je     801012a8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101264:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010126a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101270:	74 4e                	je     801012c0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101272:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101275:	85 c9                	test   %ecx,%ecx
80101277:	7e e7                	jle    80101260 <iget+0x30>
80101279:	39 3b                	cmp    %edi,(%ebx)
8010127b:	75 e3                	jne    80101260 <iget+0x30>
8010127d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101280:	75 de                	jne    80101260 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101282:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101285:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101288:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010128a:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010128f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101292:	e8 59 38 00 00       	call   80104af0 <release>
      return ip;
80101297:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010129a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010129d:	89 f0                	mov    %esi,%eax
8010129f:	5b                   	pop    %ebx
801012a0:	5e                   	pop    %esi
801012a1:	5f                   	pop    %edi
801012a2:	5d                   	pop    %ebp
801012a3:	c3                   	ret    
801012a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012a8:	85 c9                	test   %ecx,%ecx
801012aa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ad:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012b3:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012b9:	75 b7                	jne    80101272 <iget+0x42>
801012bb:	90                   	nop
801012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012c0:	85 f6                	test   %esi,%esi
801012c2:	74 2d                	je     801012f1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012c4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012c7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012c9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012cc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012d3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012da:	68 e0 19 11 80       	push   $0x801119e0
801012df:	e8 0c 38 00 00       	call   80104af0 <release>

  return ip;
801012e4:	83 c4 10             	add    $0x10,%esp
}
801012e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ea:	89 f0                	mov    %esi,%eax
801012ec:	5b                   	pop    %ebx
801012ed:	5e                   	pop    %esi
801012ee:	5f                   	pop    %edi
801012ef:	5d                   	pop    %ebp
801012f0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 b5 79 10 80       	push   $0x801079b5
801012f9:	e8 72 f0 ff ff       	call   80100370 <panic>
801012fe:	66 90                	xchg   %ax,%ax

80101300 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	56                   	push   %esi
80101305:	53                   	push   %ebx
80101306:	89 c6                	mov    %eax,%esi
80101308:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010130b:	83 fa 0b             	cmp    $0xb,%edx
8010130e:	77 18                	ja     80101328 <bmap+0x28>
80101310:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101313:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101316:	85 c0                	test   %eax,%eax
80101318:	74 76                	je     80101390 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010131a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131d:	5b                   	pop    %ebx
8010131e:	5e                   	pop    %esi
8010131f:	5f                   	pop    %edi
80101320:	5d                   	pop    %ebp
80101321:	c3                   	ret    
80101322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101328:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010132b:	83 fb 7f             	cmp    $0x7f,%ebx
8010132e:	0f 87 83 00 00 00    	ja     801013b7 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101334:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010133a:	85 c0                	test   %eax,%eax
8010133c:	74 6a                	je     801013a8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010133e:	83 ec 08             	sub    $0x8,%esp
80101341:	50                   	push   %eax
80101342:	ff 36                	pushl  (%esi)
80101344:	e8 87 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101349:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010134d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101350:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101352:	8b 1a                	mov    (%edx),%ebx
80101354:	85 db                	test   %ebx,%ebx
80101356:	75 1d                	jne    80101375 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101358:	8b 06                	mov    (%esi),%eax
8010135a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010135d:	e8 be fd ff ff       	call   80101120 <balloc>
80101362:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101365:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101368:	89 c3                	mov    %eax,%ebx
8010136a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010136c:	57                   	push   %edi
8010136d:	e8 7e 1d 00 00       	call   801030f0 <log_write>
80101372:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101375:	83 ec 0c             	sub    $0xc,%esp
80101378:	57                   	push   %edi
80101379:	e8 62 ee ff ff       	call   801001e0 <brelse>
8010137e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101381:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101384:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101386:	5b                   	pop    %ebx
80101387:	5e                   	pop    %esi
80101388:	5f                   	pop    %edi
80101389:	5d                   	pop    %ebp
8010138a:	c3                   	ret    
8010138b:	90                   	nop
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101390:	8b 06                	mov    (%esi),%eax
80101392:	e8 89 fd ff ff       	call   80101120 <balloc>
80101397:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139d:	5b                   	pop    %ebx
8010139e:	5e                   	pop    %esi
8010139f:	5f                   	pop    %edi
801013a0:	5d                   	pop    %ebp
801013a1:	c3                   	ret    
801013a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a8:	8b 06                	mov    (%esi),%eax
801013aa:	e8 71 fd ff ff       	call   80101120 <balloc>
801013af:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013b5:	eb 87                	jmp    8010133e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801013b7:	83 ec 0c             	sub    $0xc,%esp
801013ba:	68 c5 79 10 80       	push   $0x801079c5
801013bf:	e8 ac ef ff ff       	call   80100370 <panic>
801013c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013d0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

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
801013f1:	e8 fa 37 00 00       	call   80104bf0 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 c0 19 11 80       	push   $0x801119c0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101443:	ba 01 00 00 00       	mov    $0x1,%edx
80101448:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010144b:	c1 fb 03             	sar    $0x3,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 27                	je     80101483 <bfree+0x73>
8010145c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010145e:	f7 d2                	not    %edx
80101460:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101462:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101465:	21 d0                	and    %edx,%eax
80101467:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010146b:	56                   	push   %esi
8010146c:	e8 7f 1c 00 00       	call   801030f0 <log_write>
  brelse(bp);
80101471:	89 34 24             	mov    %esi,(%esp)
80101474:	e8 67 ed ff ff       	call   801001e0 <brelse>
}
80101479:	83 c4 10             	add    $0x10,%esp
8010147c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147f:	5b                   	pop    %ebx
80101480:	5e                   	pop    %esi
80101481:	5d                   	pop    %ebp
80101482:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101483:	83 ec 0c             	sub    $0xc,%esp
80101486:	68 d8 79 10 80       	push   $0x801079d8
8010148b:	e8 e0 ee ff ff       	call   80100370 <panic>

80101490 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010149c:	68 eb 79 10 80       	push   $0x801079eb
801014a1:	68 e0 19 11 80       	push   $0x801119e0
801014a6:	e8 25 34 00 00       	call   801048d0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 f2 79 10 80       	push   $0x801079f2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 fc 32 00 00       	call   801047c0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 c0 19 11 80       	push   $0x801119c0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 d8 19 11 80    	pushl  0x801119d8
801014e5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801014eb:	ff 35 d0 19 11 80    	pushl  0x801119d0
801014f1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801014f7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801014fd:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101503:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101509:	68 9c 7a 10 80       	push   $0x80107a9c
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
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
8010159e:	e8 9d 35 00 00       	call   80104b40 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 3b 1b 00 00       	call   801030f0 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015cb:	e9 60 fc ff ff       	jmp    80101230 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 f8 79 10 80       	push   $0x801079f8
801015d8:	e8 93 ed ff ff       	call   80100370 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
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
80101641:	e8 aa 35 00 00       	call   80104bf0 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 a2 1a 00 00       	call   801030f0 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 e0 19 11 80       	push   $0x801119e0
8010166f:	e8 5c 33 00 00       	call   801049d0 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010167f:	e8 6c 34 00 00       	call   80104af0 <release>
  return ip;
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 49 31 00 00       	call   80104800 <acquiresleep>

  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
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
80101728:	e8 c3 34 00 00       	call   80104bf0 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 10 7a 10 80       	push   $0x80107a10
80101752:	e8 19 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 0a 7a 10 80       	push   $0x80107a0a
8010175f:	e8 0c ec ff ff       	call   80100370 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
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
80101783:	e8 18 31 00 00       	call   801048a0 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010179f:	e9 bc 30 00 00       	jmp    80104860 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 1f 7a 10 80       	push   $0x80107a1f
801017ac:	e8 bf eb ff ff       	call   80100370 <panic>
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
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017cc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 2b 30 00 00       	call   80104800 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017e4:	74 32                	je     80101818 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 71 30 00 00       	call   80104860 <releasesleep>

  acquire(&icache.lock);
801017ef:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801017f6:	e8 d5 31 00 00       	call   801049d0 <acquire>
  ip->ref--;
801017fb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101810:	e9 db 32 00 00       	jmp    80104af0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 e0 19 11 80       	push   $0x801119e0
80101820:	e8 ab 31 00 00       	call   801049d0 <acquire>
    int r = ip->ref;
80101825:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101828:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010182f:	e8 bc 32 00 00       	call   80104af0 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fb 01             	cmp    $0x1,%ebx
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fb                	cmp    %edi,%ebx
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 13                	mov    (%ebx),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 06                	mov    (%esi),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101880:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101887:	56                   	push   %esi
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101893:	89 34 24             	mov    %esi,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 36                	pushl  (%esi)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fb                	cmp    %edi,%ebx
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 13                	mov    (%ebx),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 06                	mov    (%esi),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    }
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101902:	8b 06                	mov    (%esi),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
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
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
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
8010197c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010197f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101987:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010198a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010198d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 f0                	cmp    %esi,%eax
801019a1:	0f 82 c1 00 00 00    	jb     80101a68 <readi+0xf8>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 fa                	mov    %edi,%edx
801019ac:	01 f2                	add    %esi,%edx
801019ae:	0f 82 b4 00 00 00    	jb     80101a68 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c1                	mov    %eax,%ecx
801019b6:	29 f1                	sub    %esi,%ecx
801019b8:	39 d0                	cmp    %edx,%eax
801019ba:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019c1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6d                	je     80101a33 <readi+0xc3>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 21 f9 ff ff       	call   80101300 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019e5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ea:	e8 e1 e6 ff ff       	call   801000d0 <bread>
801019ef:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019f4:	89 f1                	mov    %esi,%ecx
801019f6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019fc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a02:	29 cb                	sub    %ecx,%ebx
80101a04:	29 f8                	sub    %edi,%eax
80101a06:	39 c3                	cmp    %eax,%ebx
80101a08:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101a0f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
80101a12:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a14:	50                   	push   %eax
80101a15:	ff 75 e0             	pushl  -0x20(%ebp)
80101a18:	e8 d3 31 00 00       	call   80104bf0 <memmove>
    brelse(bp);
80101a1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a20:	89 14 24             	mov    %edx,(%esp)
80101a23:	e8 b8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a28:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2b:	83 c4 10             	add    $0x10,%esp
80101a2e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a31:	77 9d                	ja     801019d0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a39:	5b                   	pop    %ebx
80101a3a:	5e                   	pop    %esi
80101a3b:	5f                   	pop    %edi
80101a3c:	5d                   	pop    %ebp
80101a3d:	c3                   	ret    
80101a3e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 1e                	ja     80101a68 <readi+0xf8>
80101a4a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 13                	je     80101a68 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
80101a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a6d:	eb c7                	jmp    80101a36 <readi+0xc6>
80101a6f:	90                   	nop

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
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

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
80101aa8:	89 f8                	mov    %edi,%eax
80101aaa:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101aac:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab1:	0f 87 d9 00 00 00    	ja     80101b90 <writei+0x120>
80101ab7:	39 c6                	cmp    %eax,%esi
80101ab9:	0f 87 d1 00 00 00    	ja     80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101abf:	85 ff                	test   %edi,%edi
80101ac1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ac8:	74 78                	je     80101b42 <writei+0xd2>
80101aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ada:	c1 ea 09             	shr    $0x9,%edx
80101add:	89 f8                	mov    %edi,%eax
80101adf:	e8 1c f8 ff ff       	call   80101300 <bmap>
80101ae4:	83 ec 08             	sub    $0x8,%esp
80101ae7:	50                   	push   %eax
80101ae8:	ff 37                	pushl  (%edi)
80101aea:	e8 e1 e5 ff ff       	call   801000d0 <bread>
80101aef:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101af4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101af7:	89 f1                	mov    %esi,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101b02:	29 cb                	sub    %ecx,%ebx
80101b04:	39 c3                	cmp    %eax,%ebx
80101b06:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b09:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101b0d:	53                   	push   %ebx
80101b0e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b11:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b13:	50                   	push   %eax
80101b14:	e8 d7 30 00 00       	call   80104bf0 <memmove>
    log_write(bp);
80101b19:	89 3c 24             	mov    %edi,(%esp)
80101b1c:	e8 cf 15 00 00       	call   801030f0 <log_write>
    brelse(bp);
80101b21:	89 3c 24             	mov    %edi,(%esp)
80101b24:	e8 b7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2f:	83 c4 10             	add    $0x10,%esp
80101b32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b35:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b38:	77 96                	ja     80101ad0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b40:	77 36                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b48:	5b                   	pop    %ebx
80101b49:	5e                   	pop    %esi
80101b4a:	5f                   	pop    %edi
80101b4b:	5d                   	pop    %ebp
80101b4c:	c3                   	ret    
80101b4d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b6                	jmp    80101b42 <writei+0xd2>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ae                	jmp    80101b45 <writei+0xd5>
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
80101bae:	e8 bd 30 00 00       	call   80104c70 <strncmp>
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
80101bd1:	0f 85 80 00 00 00    	jne    80101c57 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	75 0d                	jne    80101bf0 <dirlookup+0x30>
80101be3:	eb 5b                	jmp    80101c40 <dirlookup+0x80>
80101be5:	8d 76 00             	lea    0x0(%esi),%esi
80101be8:	83 c7 10             	add    $0x10,%edi
80101beb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bee:	76 50                	jbe    80101c40 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bf0:	6a 10                	push   $0x10
80101bf2:	57                   	push   %edi
80101bf3:	56                   	push   %esi
80101bf4:	53                   	push   %ebx
80101bf5:	e8 76 fd ff ff       	call   80101970 <readi>
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	83 f8 10             	cmp    $0x10,%eax
80101c00:	75 48                	jne    80101c4a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101c02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c07:	74 df                	je     80101be8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c09:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c0c:	83 ec 04             	sub    $0x4,%esp
80101c0f:	6a 0e                	push   $0xe
80101c11:	50                   	push   %eax
80101c12:	ff 75 0c             	pushl  0xc(%ebp)
80101c15:	e8 56 30 00 00       	call   80104c70 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c1a:	83 c4 10             	add    $0x10,%esp
80101c1d:	85 c0                	test   %eax,%eax
80101c1f:	75 c7                	jne    80101be8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c21:	8b 45 10             	mov    0x10(%ebp),%eax
80101c24:	85 c0                	test   %eax,%eax
80101c26:	74 05                	je     80101c2d <dirlookup+0x6d>
        *poff = off;
80101c28:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c2d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c31:	8b 03                	mov    (%ebx),%eax
80101c33:	e8 f8 f5 ff ff       	call   80101230 <iget>
    }
  }

  return 0;
}
80101c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3b:	5b                   	pop    %ebx
80101c3c:	5e                   	pop    %esi
80101c3d:	5f                   	pop    %edi
80101c3e:	5d                   	pop    %ebp
80101c3f:	c3                   	ret    
80101c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c43:	31 c0                	xor    %eax,%eax
}
80101c45:	5b                   	pop    %ebx
80101c46:	5e                   	pop    %esi
80101c47:	5f                   	pop    %edi
80101c48:	5d                   	pop    %ebp
80101c49:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c4a:	83 ec 0c             	sub    $0xc,%esp
80101c4d:	68 39 7a 10 80       	push   $0x80107a39
80101c52:	e8 19 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c57:	83 ec 0c             	sub    $0xc,%esp
80101c5a:	68 27 7a 10 80       	push   $0x80107a27
80101c5f:	e8 0c e7 ff ff       	call   80100370 <panic>
80101c64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c83:	0f 84 53 01 00 00    	je     80101ddc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 62 1f 00 00       	call   80103bf0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c94:	68 e0 19 11 80       	push   $0x801119e0
80101c99:	e8 32 2d 00 00       	call   801049d0 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101ca9:	e8 42 2e 00 00       	call   80104af0 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
    path++;
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 e3 00 00 00    	je     80101dad <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	89 da                	mov    %ebx,%edx
80101ccf:	84 c0                	test   %al,%al
80101cd1:	0f 84 ac 00 00 00    	je     80101d83 <namex+0x113>
80101cd7:	3c 2f                	cmp    $0x2f,%al
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a3 00 00 00       	jmp    80101d83 <namex+0x113>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 8d 00 00 00    	jle    80101d88 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 e6 2e 00 00       	call   80104bf0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 7f 00 00 00    	jne    80101dbe <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 a3 00 00 00    	je     80101df2 <namex+0x182>
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
80101d60:	74 5c                	je     80101dbe <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
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
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d83:	31 c9                	xor    %ecx,%ecx
80101d85:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d88:	83 ec 04             	sub    $0x4,%esp
80101d8b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d8e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d91:	51                   	push   %ecx
80101d92:	53                   	push   %ebx
80101d93:	57                   	push   %edi
80101d94:	e8 57 2e 00 00       	call   80104bf0 <memmove>
    name[len] = 0;
80101d99:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d9f:	83 c4 10             	add    $0x10,%esp
80101da2:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101da6:	89 d3                	mov    %edx,%ebx
80101da8:	e9 65 ff ff ff       	jmp    80101d12 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dad:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101db0:	85 c0                	test   %eax,%eax
80101db2:	75 54                	jne    80101e08 <namex+0x198>
80101db4:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db9:	5b                   	pop    %ebx
80101dba:	5e                   	pop    %esi
80101dbb:	5f                   	pop    %edi
80101dbc:	5d                   	pop    %ebp
80101dbd:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dbe:	83 ec 0c             	sub    $0xc,%esp
80101dc1:	56                   	push   %esi
80101dc2:	e8 a9 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dc7:	89 34 24             	mov    %esi,(%esp)
80101dca:	e8 f1 f9 ff ff       	call   801017c0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dcf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dd5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd7:	5b                   	pop    %ebx
80101dd8:	5e                   	pop    %esi
80101dd9:	5f                   	pop    %edi
80101dda:	5d                   	pop    %ebp
80101ddb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101ddc:	ba 01 00 00 00       	mov    $0x1,%edx
80101de1:	b8 01 00 00 00       	mov    $0x1,%eax
80101de6:	e8 45 f4 ff ff       	call   80101230 <iget>
80101deb:	89 c6                	mov    %eax,%esi
80101ded:	e9 c9 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101df2:	83 ec 0c             	sub    $0xc,%esp
80101df5:	56                   	push   %esi
80101df6:	e8 75 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101dfb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e01:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e03:	5b                   	pop    %ebx
80101e04:	5e                   	pop    %esi
80101e05:	5f                   	pop    %edi
80101e06:	5d                   	pop    %ebp
80101e07:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e08:	83 ec 0c             	sub    $0xc,%esp
80101e0b:	56                   	push   %esi
80101e0c:	e8 af f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e11:	83 c4 10             	add    $0x10,%esp
80101e14:	31 c0                	xor    %eax,%eax
80101e16:	eb 9e                	jmp    80101db6 <namex+0x146>
80101e18:	90                   	nop
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 89 fd ff ff       	call   80101bc0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e56:	76 19                	jbe    80101e71 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 0e fb ff ff       	call   80101970 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 5e 2e 00 00       	call   80104ce0 <strncpy>
  de.inum = inum;
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8e:	e8 dd fb ff ff       	call   80101a70 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e9b:	31 c0                	xor    %eax,%eax
}
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 12 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 48 7a 10 80       	push   $0x80107a48
80101ec0:	e8 ab e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 91 80 10 80       	push   $0x80108091
80101ecd:	e8 9e e4 ff ff       	call   80100370 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 7d fd ff ff       	call   80101c70 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f0f:	e9 5c fd ff ff       	jmp    80101c70 <namex>
80101f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f20 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f20:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f21:	b8 38 39 00 00       	mov    $0x3938,%eax


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f26:	89 e5                	mov    %esp,%ebp
80101f28:	57                   	push   %edi
80101f29:	56                   	push   %esi
80101f2a:	53                   	push   %ebx
80101f2b:	83 ec 10             	sub    $0x10,%esp
80101f2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f31:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f38:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f3f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101f43:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101f47:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101f4a:	85 c9                	test   %ecx,%ecx
80101f4c:	78 62                	js     80101fb0 <itoa+0x90>
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
80101f4e:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f50:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f55:	8d 76 00             	lea    0x0(%esi),%esi
80101f58:	89 d8                	mov    %ebx,%eax
80101f5a:	c1 fb 1f             	sar    $0x1f,%ebx
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
    do{ //Move to where representation ends
        ++p;
80101f5d:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101f60:	f7 ef                	imul   %edi
80101f62:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101f65:	29 da                	sub    %ebx,%edx
80101f67:	89 d3                	mov    %edx,%ebx
80101f69:	75 ed                	jne    80101f58 <itoa+0x38>
    *p = '\0';
80101f6b:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f6e:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101f73:	90                   	nop
80101f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f78:	89 c8                	mov    %ecx,%eax
80101f7a:	83 ee 01             	sub    $0x1,%esi
80101f7d:	f7 eb                	imul   %ebx
80101f7f:	89 c8                	mov    %ecx,%eax
80101f81:	c1 f8 1f             	sar    $0x1f,%eax
80101f84:	c1 fa 02             	sar    $0x2,%edx
80101f87:	29 c2                	sub    %eax,%edx
80101f89:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101f8c:	01 c0                	add    %eax,%eax
80101f8e:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101f90:	85 d2                	test   %edx,%edx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f92:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101f97:	89 d1                	mov    %edx,%ecx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f99:	88 06                	mov    %al,(%esi)
        i = i/10;
    }while(i);
80101f9b:	75 db                	jne    80101f78 <itoa+0x58>
    return b;
}
80101f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fa0:	83 c4 10             	add    $0x10,%esp
80101fa3:	5b                   	pop    %ebx
80101fa4:	5e                   	pop    %esi
80101fa5:	5f                   	pop    %edi
80101fa6:	5d                   	pop    %ebp
80101fa7:	c3                   	ret    
80101fa8:	90                   	nop
80101fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80101fb0:	89 f0                	mov    %esi,%eax
        i *= -1;
80101fb2:	f7 d9                	neg    %ecx

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80101fb4:	8d 76 01             	lea    0x1(%esi),%esi
80101fb7:	c6 00 2d             	movb   $0x2d,(%eax)
80101fba:	eb 92                	jmp    80101f4e <itoa+0x2e>
80101fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fc0 <removeSwapFile>:
    return b;
}
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
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fc9:	83 ec 40             	sub    $0x40,%esp
80101fcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101fcf:	6a 06                	push   $0x6
80101fd1:	68 55 7a 10 80       	push   $0x80107a55
80101fd6:	56                   	push   %esi
80101fd7:	e8 14 2c 00 00       	call   80104bf0 <memmove>
  itoa(p->pid, path+ 6);
80101fdc:	58                   	pop    %eax
80101fdd:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80101fe0:	5a                   	pop    %edx
80101fe1:	50                   	push   %eax
80101fe2:	ff 73 10             	pushl  0x10(%ebx)
80101fe5:	e8 36 ff ff ff       	call   80101f20 <itoa>
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
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101ffb:	8d 5d ca             	lea    -0x36(%ebp),%ebx

  if(0 == p->swapFile)
  {
    return -1;
  }
  fileclose(p->swapFile);
80101ffe:	50                   	push   %eax
80101fff:	e8 4c ee ff ff       	call   80100e50 <fileclose>

  begin_op();
80102004:	e8 07 0f 00 00       	call   80102f10 <begin_op>
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80102009:	89 f0                	mov    %esi,%eax
8010200b:	89 d9                	mov    %ebx,%ecx
8010200d:	ba 01 00 00 00       	mov    $0x1,%edx
80102012:	e8 59 fc ff ff       	call   80101c70 <namex>
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010201c:	89 c6                	mov    %eax,%esi
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
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
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
8010202d:	83 c4 0c             	add    $0xc,%esp
80102030:	6a 0e                	push   $0xe
80102032:	68 5d 7a 10 80       	push   $0x80107a5d
80102037:	53                   	push   %ebx
80102038:	e8 33 2c 00 00       	call   80104c70 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010203d:	83 c4 10             	add    $0x10,%esp
80102040:	85 c0                	test   %eax,%eax
80102042:	0f 84 f0 00 00 00    	je     80102138 <removeSwapFile+0x178>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80102048:	83 ec 04             	sub    $0x4,%esp
8010204b:	6a 0e                	push   $0xe
8010204d:	68 5c 7a 10 80       	push   $0x80107a5c
80102052:	53                   	push   %ebx
80102053:	e8 18 2c 00 00       	call   80104c70 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	85 c0                	test   %eax,%eax
8010205d:	0f 84 d5 00 00 00    	je     80102138 <removeSwapFile+0x178>
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
80102078:	0f 84 ba 00 00 00    	je     80102138 <removeSwapFile+0x178>
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
801020a7:	e8 94 2a 00 00       	call   80104b40 <memset>
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

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
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

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801020ed:	89 1c 24             	mov    %ebx,(%esp)
801020f0:	e8 7b f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
801020f5:	89 1c 24             	mov    %ebx,(%esp)
801020f8:	e8 c3 f6 ff ff       	call   801017c0 <iput>

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();
801020fd:	e8 7e 0e 00 00       	call   80102f80 <end_op>

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
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	53                   	push   %ebx
80102114:	e8 37 32 00 00       	call   80105350 <isdirempty>
80102119:	83 c4 10             	add    $0x10,%esp
8010211c:	85 c0                	test   %eax,%eax
8010211e:	0f 85 78 ff ff ff    	jne    8010209c <removeSwapFile+0xdc>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102124:	83 ec 0c             	sub    $0xc,%esp
80102127:	53                   	push   %ebx
80102128:	e8 43 f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
8010212d:	89 1c 24             	mov    %ebx,(%esp)
80102130:	e8 8b f6 ff ff       	call   801017c0 <iput>
80102135:	83 c4 10             	add    $0x10,%esp

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	56                   	push   %esi
8010213c:	e8 2f f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
80102141:	89 34 24             	mov    %esi,(%esp)
80102144:	e8 77 f6 ff ff       	call   801017c0 <iput>

  return 0;

  bad:
    iunlockput(dp);
    end_op();
80102149:	e8 32 0e 00 00       	call   80102f80 <end_op>
    return -1;
8010214e:	83 c4 10             	add    $0x10,%esp

}
80102151:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

  bad:
    iunlockput(dp);
    end_op();
    return -1;
80102154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
80102159:	5b                   	pop    %ebx
8010215a:	5e                   	pop    %esi
8010215b:	5f                   	pop    %edi
8010215c:	5d                   	pop    %ebp
8010215d:	c3                   	ret    
8010215e:	66 90                	xchg   %ax,%ax

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
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
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
  {
    return -1;
80102180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102185:	e9 7d ff ff ff       	jmp    80102107 <removeSwapFile+0x147>
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
  {
    end_op();
8010218a:	e8 f1 0d 00 00       	call   80102f80 <end_op>
    return -1;
8010218f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102194:	e9 6e ff ff ff       	jmp    80102107 <removeSwapFile+0x147>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80102199:	83 ec 0c             	sub    $0xc,%esp
8010219c:	68 71 7a 10 80       	push   $0x80107a71
801021a1:	e8 ca e1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801021a6:	83 ec 0c             	sub    $0xc,%esp
801021a9:	68 5f 7a 10 80       	push   $0x80107a5f
801021ae:	e8 bd e1 ff ff       	call   80100370 <panic>
801021b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <createSwapFile>:
}


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
}


//return 0 on success
int
createSwapFile(struct proc* p) {
801021c8:	83 ec 14             	sub    $0x14,%esp
801021cb:	8b 5d 08             	mov    0x8(%ebp),%ebx

    char path[DIGITS];
    memmove(path, "/.swap", 6);
801021ce:	6a 06                	push   $0x6
801021d0:	68 55 7a 10 80       	push   $0x80107a55
801021d5:	56                   	push   %esi
801021d6:	e8 15 2a 00 00       	call   80104bf0 <memmove>
    itoa(p->pid, path + 6);
801021db:	58                   	pop    %eax
801021dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801021df:	5a                   	pop    %edx
801021e0:	50                   	push   %eax
801021e1:	ff 73 10             	pushl  0x10(%ebx)
801021e4:	e8 37 fd ff ff       	call   80101f20 <itoa>

    begin_op();
801021e9:	e8 22 0d 00 00       	call   80102f10 <begin_op>
    struct inode *in = create(path, T_FILE, 0, 0);
801021ee:	6a 00                	push   $0x0
801021f0:	6a 00                	push   $0x0
801021f2:	6a 02                	push   $0x2
801021f4:	56                   	push   %esi
801021f5:	e8 66 33 00 00       	call   80105560 <create>
    iunlock(in);
801021fa:	83 c4 14             	add    $0x14,%esp
    char path[DIGITS];
    memmove(path, "/.swap", 6);
    itoa(p->pid, path + 6);

    begin_op();
    struct inode *in = create(path, T_FILE, 0, 0);
801021fd:	89 c6                	mov    %eax,%esi
    iunlock(in);
801021ff:	50                   	push   %eax
80102200:	e8 6b f5 ff ff       	call   80101770 <iunlock>

    p->swapFile = filealloc();
80102205:	e8 86 eb ff ff       	call   80100d90 <filealloc>
    if (p->swapFile == 0)
8010220a:	83 c4 10             	add    $0x10,%esp
8010220d:	85 c0                	test   %eax,%eax

    begin_op();
    struct inode *in = create(path, T_FILE, 0, 0);
    iunlock(in);

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
80102238:	e8 43 0d 00 00       	call   80102f80 <end_op>

    return 0;
}
8010223d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102240:	31 c0                	xor    %eax,%eax
80102242:	5b                   	pop    %ebx
80102243:	5e                   	pop    %esi
80102244:	5d                   	pop    %ebp
80102245:	c3                   	ret    
    struct inode *in = create(path, T_FILE, 0, 0);
    iunlock(in);

    p->swapFile = filealloc();
    if (p->swapFile == 0)
        panic("no slot for files on /store");
80102246:	83 ec 0c             	sub    $0xc,%esp
80102249:	68 80 7a 10 80       	push   $0x80107a80
8010224e:	e8 1d e1 ff ff       	call   80100370 <panic>
80102253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102260 <writeToSwapFile>:
}

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
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return filewrite(p->swapFile, buffer, size);
8010227c:	e9 7f ed ff ff       	jmp    80101000 <filewrite>
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
}

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
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return fileread(p->swapFile, buffer,  size);
801022ac:	e9 bf ec ff ff       	jmp    80100f70 <fileread>
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
  if(b == 0)
801022c1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022c3:	89 e5                	mov    %esp,%ebp
801022c5:	56                   	push   %esi
801022c6:	53                   	push   %ebx
  if(b == 0)
801022c7:	0f 84 ad 00 00 00    	je     8010237a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022cd:	8b 58 08             	mov    0x8(%eax),%ebx
801022d0:	89 c1                	mov    %eax,%ecx
801022d2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022d8:	0f 87 8f 00 00 00    	ja     8010236d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022de:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022e3:	90                   	nop
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e9:	83 e0 c0             	and    $0xffffffc0,%eax
801022ec:	3c 40                	cmp    $0x40,%al
801022ee:	75 f8                	jne    801022e8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022f0:	31 f6                	xor    %esi,%esi
801022f2:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022f7:	89 f0                	mov    %esi,%eax
801022f9:	ee                   	out    %al,(%dx)
801022fa:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022ff:	b8 01 00 00 00       	mov    $0x1,%eax
80102304:	ee                   	out    %al,(%dx)
80102305:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010230a:	89 d8                	mov    %ebx,%eax
8010230c:	ee                   	out    %al,(%dx)
8010230d:	89 d8                	mov    %ebx,%eax
8010230f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102314:	c1 f8 08             	sar    $0x8,%eax
80102317:	ee                   	out    %al,(%dx)
80102318:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010231d:	89 f0                	mov    %esi,%eax
8010231f:	ee                   	out    %al,(%dx)
80102320:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102324:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102329:	83 e0 01             	and    $0x1,%eax
8010232c:	c1 e0 04             	shl    $0x4,%eax
8010232f:	83 c8 e0             	or     $0xffffffe0,%eax
80102332:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102333:	f6 01 04             	testb  $0x4,(%ecx)
80102336:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010233b:	75 13                	jne    80102350 <idestart+0x90>
8010233d:	b8 20 00 00 00       	mov    $0x20,%eax
80102342:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102343:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102346:	5b                   	pop    %ebx
80102347:	5e                   	pop    %esi
80102348:	5d                   	pop    %ebp
80102349:	c3                   	ret    
8010234a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102350:	b8 30 00 00 00       	mov    $0x30,%eax
80102355:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102356:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010235b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010235e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102363:	fc                   	cld    
80102364:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102366:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102369:	5b                   	pop    %ebx
8010236a:	5e                   	pop    %esi
8010236b:	5d                   	pop    %ebp
8010236c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010236d:	83 ec 0c             	sub    $0xc,%esp
80102370:	68 f8 7a 10 80       	push   $0x80107af8
80102375:	e8 f6 df ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010237a:	83 ec 0c             	sub    $0xc,%esp
8010237d:	68 ef 7a 10 80       	push   $0x80107aef
80102382:	e8 e9 df ff ff       	call   80100370 <panic>
80102387:	89 f6                	mov    %esi,%esi
80102389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102390 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102396:	68 0a 7b 10 80       	push   $0x80107b0a
8010239b:	68 80 b5 10 80       	push   $0x8010b580
801023a0:	e8 2b 25 00 00       	call   801048d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023a5:	58                   	pop    %eax
801023a6:	a1 00 3d 11 80       	mov    0x80113d00,%eax
801023ab:	5a                   	pop    %edx
801023ac:	83 e8 01             	sub    $0x1,%eax
801023af:	50                   	push   %eax
801023b0:	6a 0e                	push   $0xe
801023b2:	e8 a9 02 00 00       	call   80102660 <ioapicenable>
801023b7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023ba:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023bf:	90                   	nop
801023c0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023c1:	83 e0 c0             	and    $0xffffffc0,%eax
801023c4:	3c 40                	cmp    $0x40,%al
801023c6:	75 f8                	jne    801023c0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023c8:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023cd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023d2:	ee                   	out    %al,(%dx)
801023d3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023dd:	eb 06                	jmp    801023e5 <ideinit+0x55>
801023df:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801023e0:	83 e9 01             	sub    $0x1,%ecx
801023e3:	74 0f                	je     801023f4 <ideinit+0x64>
801023e5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023e6:	84 c0                	test   %al,%al
801023e8:	74 f6                	je     801023e0 <ideinit+0x50>
      havedisk1 = 1;
801023ea:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801023f1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023f4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023f9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023fe:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801023ff:	c9                   	leave  
80102400:	c3                   	ret    
80102401:	eb 0d                	jmp    80102410 <ideintr>
80102403:	90                   	nop
80102404:	90                   	nop
80102405:	90                   	nop
80102406:	90                   	nop
80102407:	90                   	nop
80102408:	90                   	nop
80102409:	90                   	nop
8010240a:	90                   	nop
8010240b:	90                   	nop
8010240c:	90                   	nop
8010240d:	90                   	nop
8010240e:	90                   	nop
8010240f:	90                   	nop

80102410 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	57                   	push   %edi
80102414:	56                   	push   %esi
80102415:	53                   	push   %ebx
80102416:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102419:	68 80 b5 10 80       	push   $0x8010b580
8010241e:	e8 ad 25 00 00       	call   801049d0 <acquire>

  if((b = idequeue) == 0){
80102423:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102429:	83 c4 10             	add    $0x10,%esp
8010242c:	85 db                	test   %ebx,%ebx
8010242e:	74 34                	je     80102464 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102430:	8b 43 58             	mov    0x58(%ebx),%eax
80102433:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102438:	8b 33                	mov    (%ebx),%esi
8010243a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102440:	74 3e                	je     80102480 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102442:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102445:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102448:	83 ce 02             	or     $0x2,%esi
8010244b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010244d:	53                   	push   %ebx
8010244e:	e8 bd 21 00 00       	call   80104610 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102453:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102458:	83 c4 10             	add    $0x10,%esp
8010245b:	85 c0                	test   %eax,%eax
8010245d:	74 05                	je     80102464 <ideintr+0x54>
    idestart(idequeue);
8010245f:	e8 5c fe ff ff       	call   801022c0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102464:	83 ec 0c             	sub    $0xc,%esp
80102467:	68 80 b5 10 80       	push   $0x8010b580
8010246c:	e8 7f 26 00 00       	call   80104af0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102474:	5b                   	pop    %ebx
80102475:	5e                   	pop    %esi
80102476:	5f                   	pop    %edi
80102477:	5d                   	pop    %ebp
80102478:	c3                   	ret    
80102479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102480:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102485:	8d 76 00             	lea    0x0(%esi),%esi
80102488:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102489:	89 c1                	mov    %eax,%ecx
8010248b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010248e:	80 f9 40             	cmp    $0x40,%cl
80102491:	75 f5                	jne    80102488 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102493:	a8 21                	test   $0x21,%al
80102495:	75 ab                	jne    80102442 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102497:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010249a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010249f:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024a4:	fc                   	cld    
801024a5:	f3 6d                	rep insl (%dx),%es:(%edi)
801024a7:	8b 33                	mov    (%ebx),%esi
801024a9:	eb 97                	jmp    80102442 <ideintr+0x32>
801024ab:	90                   	nop
801024ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 10             	sub    $0x10,%esp
801024b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801024bd:	50                   	push   %eax
801024be:	e8 dd 23 00 00       	call   801048a0 <holdingsleep>
801024c3:	83 c4 10             	add    $0x10,%esp
801024c6:	85 c0                	test   %eax,%eax
801024c8:	0f 84 ad 00 00 00    	je     8010257b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024ce:	8b 03                	mov    (%ebx),%eax
801024d0:	83 e0 06             	and    $0x6,%eax
801024d3:	83 f8 02             	cmp    $0x2,%eax
801024d6:	0f 84 b9 00 00 00    	je     80102595 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024dc:	8b 53 04             	mov    0x4(%ebx),%edx
801024df:	85 d2                	test   %edx,%edx
801024e1:	74 0d                	je     801024f0 <iderw+0x40>
801024e3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801024e8:	85 c0                	test   %eax,%eax
801024ea:	0f 84 98 00 00 00    	je     80102588 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024f0:	83 ec 0c             	sub    $0xc,%esp
801024f3:	68 80 b5 10 80       	push   $0x8010b580
801024f8:	e8 d3 24 00 00       	call   801049d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024fd:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102503:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102506:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010250d:	85 d2                	test   %edx,%edx
8010250f:	75 09                	jne    8010251a <iderw+0x6a>
80102511:	eb 58                	jmp    8010256b <iderw+0xbb>
80102513:	90                   	nop
80102514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102518:	89 c2                	mov    %eax,%edx
8010251a:	8b 42 58             	mov    0x58(%edx),%eax
8010251d:	85 c0                	test   %eax,%eax
8010251f:	75 f7                	jne    80102518 <iderw+0x68>
80102521:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102524:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102526:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010252c:	74 44                	je     80102572 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010252e:	8b 03                	mov    (%ebx),%eax
80102530:	83 e0 06             	and    $0x6,%eax
80102533:	83 f8 02             	cmp    $0x2,%eax
80102536:	74 23                	je     8010255b <iderw+0xab>
80102538:	90                   	nop
80102539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102540:	83 ec 08             	sub    $0x8,%esp
80102543:	68 80 b5 10 80       	push   $0x8010b580
80102548:	53                   	push   %ebx
80102549:	e8 52 1e 00 00       	call   801043a0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010254e:	8b 03                	mov    (%ebx),%eax
80102550:	83 c4 10             	add    $0x10,%esp
80102553:	83 e0 06             	and    $0x6,%eax
80102556:	83 f8 02             	cmp    $0x2,%eax
80102559:	75 e5                	jne    80102540 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010255b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102565:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102566:	e9 85 25 00 00       	jmp    80104af0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010256b:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102570:	eb b2                	jmp    80102524 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102572:	89 d8                	mov    %ebx,%eax
80102574:	e8 47 fd ff ff       	call   801022c0 <idestart>
80102579:	eb b3                	jmp    8010252e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010257b:	83 ec 0c             	sub    $0xc,%esp
8010257e:	68 0e 7b 10 80       	push   $0x80107b0e
80102583:	e8 e8 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	68 39 7b 10 80       	push   $0x80107b39
80102590:	e8 db dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102595:	83 ec 0c             	sub    $0xc,%esp
80102598:	68 24 7b 10 80       	push   $0x80107b24
8010259d:	e8 ce dd ff ff       	call   80100370 <panic>
801025a2:	66 90                	xchg   %ax,%ax
801025a4:	66 90                	xchg   %ax,%ax
801025a6:	66 90                	xchg   %ax,%ax
801025a8:	66 90                	xchg   %ax,%ax
801025aa:	66 90                	xchg   %ax,%ax
801025ac:	66 90                	xchg   %ax,%ax
801025ae:	66 90                	xchg   %ax,%ax

801025b0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025b0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025b1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801025b8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025bb:	89 e5                	mov    %esp,%ebp
801025bd:	56                   	push   %esi
801025be:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025bf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025c6:	00 00 00 
  return ioapic->data;
801025c9:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801025cf:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025d2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801025d8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025de:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025e5:	89 f0                	mov    %esi,%eax
801025e7:	c1 e8 10             	shr    $0x10,%eax
801025ea:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801025ed:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025f0:	c1 e8 18             	shr    $0x18,%eax
801025f3:	39 d0                	cmp    %edx,%eax
801025f5:	74 16                	je     8010260d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025f7:	83 ec 0c             	sub    $0xc,%esp
801025fa:	68 58 7b 10 80       	push   $0x80107b58
801025ff:	e8 5c e0 ff ff       	call   80100660 <cprintf>
80102604:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010260a:	83 c4 10             	add    $0x10,%esp
8010260d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102610:	ba 10 00 00 00       	mov    $0x10,%edx
80102615:	b8 20 00 00 00       	mov    $0x20,%eax
8010261a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102620:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102622:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102628:	89 c3                	mov    %eax,%ebx
8010262a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102630:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102633:	89 59 10             	mov    %ebx,0x10(%ecx)
80102636:	8d 5a 01             	lea    0x1(%edx),%ebx
80102639:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010263c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010263e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102640:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102646:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010264d:	75 d1                	jne    80102620 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010264f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102652:	5b                   	pop    %ebx
80102653:	5e                   	pop    %esi
80102654:	5d                   	pop    %ebp
80102655:	c3                   	ret    
80102656:	8d 76 00             	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102660:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102661:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102667:	89 e5                	mov    %esp,%ebp
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010266c:	8d 50 20             	lea    0x20(%eax),%edx
8010266f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102673:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102675:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010267b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010267e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102681:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102684:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102686:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010268b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010268e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	66 90                	xchg   %ax,%ax
80102695:	66 90                	xchg   %ax,%ax
80102697:	66 90                	xchg   %ax,%ax
80102699:	66 90                	xchg   %ax,%ax
8010269b:	66 90                	xchg   %ax,%ax
8010269d:	66 90                	xchg   %ax,%ax
8010269f:	90                   	nop

801026a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	53                   	push   %ebx
801026a4:	83 ec 04             	sub    $0x4,%esp
801026a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026b0:	75 70                	jne    80102722 <kfree+0x82>
801026b2:	81 fb a8 69 12 80    	cmp    $0x801269a8,%ebx
801026b8:	72 68                	jb     80102722 <kfree+0x82>
801026ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026c5:	77 5b                	ja     80102722 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026c7:	83 ec 04             	sub    $0x4,%esp
801026ca:	68 00 10 00 00       	push   $0x1000
801026cf:	6a 01                	push   $0x1
801026d1:	53                   	push   %ebx
801026d2:	e8 69 24 00 00       	call   80104b40 <memset>

  if(kmem.use_lock)
801026d7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801026dd:	83 c4 10             	add    $0x10,%esp
801026e0:	85 d2                	test   %edx,%edx
801026e2:	75 2c                	jne    80102710 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026e4:	a1 78 36 11 80       	mov    0x80113678,%eax
801026e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026eb:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801026f0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801026f6:	85 c0                	test   %eax,%eax
801026f8:	75 06                	jne    80102700 <kfree+0x60>
    release(&kmem.lock);
}
801026fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026fd:	c9                   	leave  
801026fe:	c3                   	ret    
801026ff:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102700:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102707:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010270a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010270b:	e9 e0 23 00 00       	jmp    80104af0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102710:	83 ec 0c             	sub    $0xc,%esp
80102713:	68 40 36 11 80       	push   $0x80113640
80102718:	e8 b3 22 00 00       	call   801049d0 <acquire>
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	eb c2                	jmp    801026e4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102722:	83 ec 0c             	sub    $0xc,%esp
80102725:	68 8a 7b 10 80       	push   $0x80107b8a
8010272a:	e8 41 dc ff ff       	call   80100370 <panic>
8010272f:	90                   	nop

80102730 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	56                   	push   %esi
80102734:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102735:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102738:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010273b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102741:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102747:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010274d:	39 de                	cmp    %ebx,%esi
8010274f:	72 23                	jb     80102774 <freerange+0x44>
80102751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102758:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010275e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102761:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102767:	50                   	push   %eax
80102768:	e8 33 ff ff ff       	call   801026a0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010276d:	83 c4 10             	add    $0x10,%esp
80102770:	39 f3                	cmp    %esi,%ebx
80102772:	76 e4                	jbe    80102758 <freerange+0x28>
    kfree(p);
}
80102774:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102777:	5b                   	pop    %ebx
80102778:	5e                   	pop    %esi
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	56                   	push   %esi
80102784:	53                   	push   %ebx
80102785:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102788:	83 ec 08             	sub    $0x8,%esp
8010278b:	68 90 7b 10 80       	push   $0x80107b90
80102790:	68 40 36 11 80       	push   $0x80113640
80102795:	e8 36 21 00 00       	call   801048d0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010279a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010279d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801027a0:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801027a7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027aa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027bc:	39 de                	cmp    %ebx,%esi
801027be:	72 1c                	jb     801027dc <kinit1+0x5c>
    kfree(p);
801027c0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027c6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027cf:	50                   	push   %eax
801027d0:	e8 cb fe ff ff       	call   801026a0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d5:	83 c4 10             	add    $0x10,%esp
801027d8:	39 de                	cmp    %ebx,%esi
801027da:	73 e4                	jae    801027c0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801027dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027df:	5b                   	pop    %ebx
801027e0:	5e                   	pop    %esi
801027e1:	5d                   	pop    %ebp
801027e2:	c3                   	ret    
801027e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	56                   	push   %esi
801027f4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801027f8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102801:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102807:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010280d:	39 de                	cmp    %ebx,%esi
8010280f:	72 23                	jb     80102834 <kinit2+0x44>
80102811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102818:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010281e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102821:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102827:	50                   	push   %eax
80102828:	e8 73 fe ff ff       	call   801026a0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010282d:	83 c4 10             	add    $0x10,%esp
80102830:	39 de                	cmp    %ebx,%esi
80102832:	73 e4                	jae    80102818 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102834:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010283b:	00 00 00 
}
8010283e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102841:	5b                   	pop    %ebx
80102842:	5e                   	pop    %esi
80102843:	5d                   	pop    %ebp
80102844:	c3                   	ret    
80102845:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102850 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	53                   	push   %ebx
80102854:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102857:	a1 74 36 11 80       	mov    0x80113674,%eax
8010285c:	85 c0                	test   %eax,%eax
8010285e:	75 30                	jne    80102890 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102860:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102866:	85 db                	test   %ebx,%ebx
80102868:	74 1c                	je     80102886 <kalloc+0x36>
    kmem.freelist = r->next;
8010286a:	8b 13                	mov    (%ebx),%edx
8010286c:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
80102872:	85 c0                	test   %eax,%eax
80102874:	74 10                	je     80102886 <kalloc+0x36>
    release(&kmem.lock);
80102876:	83 ec 0c             	sub    $0xc,%esp
80102879:	68 40 36 11 80       	push   $0x80113640
8010287e:	e8 6d 22 00 00       	call   80104af0 <release>
80102883:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102886:	89 d8                	mov    %ebx,%eax
80102888:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010288b:	c9                   	leave  
8010288c:	c3                   	ret    
8010288d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102890:	83 ec 0c             	sub    $0xc,%esp
80102893:	68 40 36 11 80       	push   $0x80113640
80102898:	e8 33 21 00 00       	call   801049d0 <acquire>
  r = kmem.freelist;
8010289d:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
801028a3:	83 c4 10             	add    $0x10,%esp
801028a6:	a1 74 36 11 80       	mov    0x80113674,%eax
801028ab:	85 db                	test   %ebx,%ebx
801028ad:	75 bb                	jne    8010286a <kalloc+0x1a>
801028af:	eb c1                	jmp    80102872 <kalloc+0x22>
801028b1:	66 90                	xchg   %ax,%ax
801028b3:	66 90                	xchg   %ax,%ax
801028b5:	66 90                	xchg   %ax,%ax
801028b7:	66 90                	xchg   %ax,%ax
801028b9:	66 90                	xchg   %ax,%ax
801028bb:	66 90                	xchg   %ax,%ax
801028bd:	66 90                	xchg   %ax,%ax
801028bf:	90                   	nop

801028c0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801028c0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c1:	ba 64 00 00 00       	mov    $0x64,%edx
801028c6:	89 e5                	mov    %esp,%ebp
801028c8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028c9:	a8 01                	test   $0x1,%al
801028cb:	0f 84 af 00 00 00    	je     80102980 <kbdgetc+0xc0>
801028d1:	ba 60 00 00 00       	mov    $0x60,%edx
801028d6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028d7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801028da:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028e0:	74 7e                	je     80102960 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028e2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028e4:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028ea:	79 24                	jns    80102910 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028ec:	f6 c1 40             	test   $0x40,%cl
801028ef:	75 05                	jne    801028f6 <kbdgetc+0x36>
801028f1:	89 c2                	mov    %eax,%edx
801028f3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801028f6:	0f b6 82 c0 7c 10 80 	movzbl -0x7fef8340(%edx),%eax
801028fd:	83 c8 40             	or     $0x40,%eax
80102900:	0f b6 c0             	movzbl %al,%eax
80102903:	f7 d0                	not    %eax
80102905:	21 c8                	and    %ecx,%eax
80102907:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010290c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010290e:	5d                   	pop    %ebp
8010290f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102910:	f6 c1 40             	test   $0x40,%cl
80102913:	74 09                	je     8010291e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102915:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102918:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010291b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010291e:	0f b6 82 c0 7c 10 80 	movzbl -0x7fef8340(%edx),%eax
80102925:	09 c1                	or     %eax,%ecx
80102927:	0f b6 82 c0 7b 10 80 	movzbl -0x7fef8440(%edx),%eax
8010292e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102930:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102932:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102938:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010293b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010293e:	8b 04 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%eax
80102945:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102949:	74 c3                	je     8010290e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010294b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010294e:	83 fa 19             	cmp    $0x19,%edx
80102951:	77 1d                	ja     80102970 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102953:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102956:	5d                   	pop    %ebp
80102957:	c3                   	ret    
80102958:	90                   	nop
80102959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102960:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102962:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102969:	5d                   	pop    %ebp
8010296a:	c3                   	ret    
8010296b:	90                   	nop
8010296c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102970:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102973:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102976:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102977:	83 f9 19             	cmp    $0x19,%ecx
8010297a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010297d:	c3                   	ret    
8010297e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102985:	5d                   	pop    %ebp
80102986:	c3                   	ret    
80102987:	89 f6                	mov    %esi,%esi
80102989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102990 <kbdintr>:

void
kbdintr(void)
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
80102993:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102996:	68 c0 28 10 80       	push   $0x801028c0
8010299b:	e8 50 de ff ff       	call   801007f0 <consoleintr>
}
801029a0:	83 c4 10             	add    $0x10,%esp
801029a3:	c9                   	leave  
801029a4:	c3                   	ret    
801029a5:	66 90                	xchg   %ax,%ax
801029a7:	66 90                	xchg   %ax,%ax
801029a9:	66 90                	xchg   %ax,%ax
801029ab:	66 90                	xchg   %ax,%ax
801029ad:	66 90                	xchg   %ax,%ax
801029af:	90                   	nop

801029b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029b0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801029b5:	55                   	push   %ebp
801029b6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029b8:	85 c0                	test   %eax,%eax
801029ba:	0f 84 c8 00 00 00    	je     80102a88 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029c0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029c7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ca:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029cd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029da:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029e1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029e4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029e7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029ee:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029f1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029f4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029fb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029fe:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a01:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a08:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a0e:	8b 50 30             	mov    0x30(%eax),%edx
80102a11:	c1 ea 10             	shr    $0x10,%edx
80102a14:	80 fa 03             	cmp    $0x3,%dl
80102a17:	77 77                	ja     80102a90 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a19:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a20:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a23:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a26:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a2d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a30:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a33:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a3a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a40:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a47:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a4d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a57:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a5a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a61:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a64:	8b 50 20             	mov    0x20(%eax),%edx
80102a67:	89 f6                	mov    %esi,%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a70:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a76:	80 e6 10             	and    $0x10,%dh
80102a79:	75 f5                	jne    80102a70 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a7b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a82:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a85:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a88:	5d                   	pop    %ebp
80102a89:	c3                   	ret    
80102a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a90:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a97:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9a:	8b 50 20             	mov    0x20(%eax),%edx
80102a9d:	e9 77 ff ff ff       	jmp    80102a19 <lapicinit+0x69>
80102aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ab0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102ab0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102ab5:	55                   	push   %ebp
80102ab6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102ab8:	85 c0                	test   %eax,%eax
80102aba:	74 0c                	je     80102ac8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102abc:	8b 40 20             	mov    0x20(%eax),%eax
}
80102abf:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102ac0:	c1 e8 18             	shr    $0x18,%eax
}
80102ac3:	c3                   	ret    
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102ac8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102aca:	5d                   	pop    %ebp
80102acb:	c3                   	ret    
80102acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ad0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ad0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ad5:	55                   	push   %ebp
80102ad6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ad8:	85 c0                	test   %eax,%eax
80102ada:	74 0d                	je     80102ae9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102adc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ae3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102ae9:	5d                   	pop    %ebp
80102aea:	c3                   	ret    
80102aeb:	90                   	nop
80102aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102af0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
}
80102af3:	5d                   	pop    %ebp
80102af4:	c3                   	ret    
80102af5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b00 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b00:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b01:	ba 70 00 00 00       	mov    $0x70,%edx
80102b06:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b0b:	89 e5                	mov    %esp,%ebp
80102b0d:	53                   	push   %ebx
80102b0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b14:	ee                   	out    %al,(%dx)
80102b15:	ba 71 00 00 00       	mov    $0x71,%edx
80102b1a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b1f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b20:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b22:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b25:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b2b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b2d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b30:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b33:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b35:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b38:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b3e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102b43:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b49:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b4c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b53:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b56:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b59:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b60:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b63:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b66:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b6c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b6f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b75:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b78:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b7e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b81:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b87:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102b8a:	5b                   	pop    %ebx
80102b8b:	5d                   	pop    %ebp
80102b8c:	c3                   	ret    
80102b8d:	8d 76 00             	lea    0x0(%esi),%esi

80102b90 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102b90:	55                   	push   %ebp
80102b91:	ba 70 00 00 00       	mov    $0x70,%edx
80102b96:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b9b:	89 e5                	mov    %esp,%ebp
80102b9d:	57                   	push   %edi
80102b9e:	56                   	push   %esi
80102b9f:	53                   	push   %ebx
80102ba0:	83 ec 4c             	sub    $0x4c,%esp
80102ba3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ba9:	ec                   	in     (%dx),%al
80102baa:	83 e0 04             	and    $0x4,%eax
80102bad:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb0:	31 db                	xor    %ebx,%ebx
80102bb2:	88 45 b7             	mov    %al,-0x49(%ebp)
80102bb5:	bf 70 00 00 00       	mov    $0x70,%edi
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bc0:	89 d8                	mov    %ebx,%eax
80102bc2:	89 fa                	mov    %edi,%edx
80102bc4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bca:	89 ca                	mov    %ecx,%edx
80102bcc:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102bcd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd0:	89 fa                	mov    %edi,%edx
80102bd2:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102bd5:	b8 02 00 00 00       	mov    $0x2,%eax
80102bda:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdb:	89 ca                	mov    %ecx,%edx
80102bdd:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102bde:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be1:	89 fa                	mov    %edi,%edx
80102be3:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102be6:	b8 04 00 00 00       	mov    $0x4,%eax
80102beb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bec:	89 ca                	mov    %ecx,%edx
80102bee:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102bef:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf2:	89 fa                	mov    %edi,%edx
80102bf4:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bf7:	b8 07 00 00 00       	mov    $0x7,%eax
80102bfc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfd:	89 ca                	mov    %ecx,%edx
80102bff:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c00:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c03:	89 fa                	mov    %edi,%edx
80102c05:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c08:	b8 08 00 00 00       	mov    $0x8,%eax
80102c0d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0e:	89 ca                	mov    %ecx,%edx
80102c10:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c11:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c14:	89 fa                	mov    %edi,%edx
80102c16:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102c19:	b8 09 00 00 00       	mov    $0x9,%eax
80102c1e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1f:	89 ca                	mov    %ecx,%edx
80102c21:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c22:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c25:	89 fa                	mov    %edi,%edx
80102c27:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102c2a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c2f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c30:	89 ca                	mov    %ecx,%edx
80102c32:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c33:	84 c0                	test   %al,%al
80102c35:	78 89                	js     80102bc0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c37:	89 d8                	mov    %ebx,%eax
80102c39:	89 fa                	mov    %edi,%edx
80102c3b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3c:	89 ca                	mov    %ecx,%edx
80102c3e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c3f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c42:	89 fa                	mov    %edi,%edx
80102c44:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c47:	b8 02 00 00 00       	mov    $0x2,%eax
80102c4c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4d:	89 ca                	mov    %ecx,%edx
80102c4f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c50:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c53:	89 fa                	mov    %edi,%edx
80102c55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c58:	b8 04 00 00 00       	mov    $0x4,%eax
80102c5d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5e:	89 ca                	mov    %ecx,%edx
80102c60:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c61:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c64:	89 fa                	mov    %edi,%edx
80102c66:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c69:	b8 07 00 00 00       	mov    $0x7,%eax
80102c6e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6f:	89 ca                	mov    %ecx,%edx
80102c71:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c72:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c75:	89 fa                	mov    %edi,%edx
80102c77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c7a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c7f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c80:	89 ca                	mov    %ecx,%edx
80102c82:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c83:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c86:	89 fa                	mov    %edi,%edx
80102c88:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c8b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c90:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c91:	89 ca                	mov    %ecx,%edx
80102c93:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c94:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c97:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c9d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ca0:	6a 18                	push   $0x18
80102ca2:	56                   	push   %esi
80102ca3:	50                   	push   %eax
80102ca4:	e8 e7 1e 00 00       	call   80104b90 <memcmp>
80102ca9:	83 c4 10             	add    $0x10,%esp
80102cac:	85 c0                	test   %eax,%eax
80102cae:	0f 85 0c ff ff ff    	jne    80102bc0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102cb4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102cb8:	75 78                	jne    80102d32 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cba:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cbd:	89 c2                	mov    %eax,%edx
80102cbf:	83 e0 0f             	and    $0xf,%eax
80102cc2:	c1 ea 04             	shr    $0x4,%edx
80102cc5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cc8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ccb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cce:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cd1:	89 c2                	mov    %eax,%edx
80102cd3:	83 e0 0f             	and    $0xf,%eax
80102cd6:	c1 ea 04             	shr    $0x4,%edx
80102cd9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cdc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cdf:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ce2:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ce5:	89 c2                	mov    %eax,%edx
80102ce7:	83 e0 0f             	and    $0xf,%eax
80102cea:	c1 ea 04             	shr    $0x4,%edx
80102ced:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cf0:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cf6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cf9:	89 c2                	mov    %eax,%edx
80102cfb:	83 e0 0f             	and    $0xf,%eax
80102cfe:	c1 ea 04             	shr    $0x4,%edx
80102d01:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d04:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d07:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d0a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d0d:	89 c2                	mov    %eax,%edx
80102d0f:	83 e0 0f             	and    $0xf,%eax
80102d12:	c1 ea 04             	shr    $0x4,%edx
80102d15:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d18:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d1b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d21:	89 c2                	mov    %eax,%edx
80102d23:	83 e0 0f             	and    $0xf,%eax
80102d26:	c1 ea 04             	shr    $0x4,%edx
80102d29:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d32:	8b 75 08             	mov    0x8(%ebp),%esi
80102d35:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d38:	89 06                	mov    %eax,(%esi)
80102d3a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d3d:	89 46 04             	mov    %eax,0x4(%esi)
80102d40:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d43:	89 46 08             	mov    %eax,0x8(%esi)
80102d46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d49:	89 46 0c             	mov    %eax,0xc(%esi)
80102d4c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d4f:	89 46 10             	mov    %eax,0x10(%esi)
80102d52:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d55:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d58:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d62:	5b                   	pop    %ebx
80102d63:	5e                   	pop    %esi
80102d64:	5f                   	pop    %edi
80102d65:	5d                   	pop    %ebp
80102d66:	c3                   	ret    
80102d67:	66 90                	xchg   %ax,%ax
80102d69:	66 90                	xchg   %ax,%ax
80102d6b:	66 90                	xchg   %ax,%ax
80102d6d:	66 90                	xchg   %ax,%ax
80102d6f:	90                   	nop

80102d70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d70:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102d76:	85 c9                	test   %ecx,%ecx
80102d78:	0f 8e 85 00 00 00    	jle    80102e03 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102d7e:	55                   	push   %ebp
80102d7f:	89 e5                	mov    %esp,%ebp
80102d81:	57                   	push   %edi
80102d82:	56                   	push   %esi
80102d83:	53                   	push   %ebx
80102d84:	31 db                	xor    %ebx,%ebx
80102d86:	83 ec 0c             	sub    $0xc,%esp
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d90:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102d95:	83 ec 08             	sub    $0x8,%esp
80102d98:	01 d8                	add    %ebx,%eax
80102d9a:	83 c0 01             	add    $0x1,%eax
80102d9d:	50                   	push   %eax
80102d9e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102da4:	e8 27 d3 ff ff       	call   801000d0 <bread>
80102da9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dab:	58                   	pop    %eax
80102dac:	5a                   	pop    %edx
80102dad:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102db4:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dba:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dbd:	e8 0e d3 ff ff       	call   801000d0 <bread>
80102dc2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dc4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102dc7:	83 c4 0c             	add    $0xc,%esp
80102dca:	68 00 02 00 00       	push   $0x200
80102dcf:	50                   	push   %eax
80102dd0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dd3:	50                   	push   %eax
80102dd4:	e8 17 1e 00 00       	call   80104bf0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102dd9:	89 34 24             	mov    %esi,(%esp)
80102ddc:	e8 bf d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102de1:	89 3c 24             	mov    %edi,(%esp)
80102de4:	e8 f7 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102de9:	89 34 24             	mov    %esi,(%esp)
80102dec:	e8 ef d3 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102dfa:	7f 94                	jg     80102d90 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dff:	5b                   	pop    %ebx
80102e00:	5e                   	pop    %esi
80102e01:	5f                   	pop    %edi
80102e02:	5d                   	pop    %ebp
80102e03:	f3 c3                	repz ret 
80102e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
80102e14:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e17:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102e1d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e23:	e8 a8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e28:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e2e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e31:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e33:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e35:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e38:	7e 1f                	jle    80102e59 <write_head+0x49>
80102e3a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102e41:	31 d2                	xor    %edx,%edx
80102e43:	90                   	nop
80102e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e48:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102e4e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102e52:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e55:	39 c2                	cmp    %eax,%edx
80102e57:	75 ef                	jne    80102e48 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102e59:	83 ec 0c             	sub    $0xc,%esp
80102e5c:	53                   	push   %ebx
80102e5d:	e8 3e d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e62:	89 1c 24             	mov    %ebx,(%esp)
80102e65:	e8 76 d3 ff ff       	call   801001e0 <brelse>
}
80102e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e6d:	c9                   	leave  
80102e6e:	c3                   	ret    
80102e6f:	90                   	nop

80102e70 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 2c             	sub    $0x2c,%esp
80102e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e7a:	68 c0 7d 10 80       	push   $0x80107dc0
80102e7f:	68 80 36 11 80       	push   $0x80113680
80102e84:	e8 47 1a 00 00       	call   801048d0 <initlock>
  readsb(dev, &sb);
80102e89:	58                   	pop    %eax
80102e8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e8d:	5a                   	pop    %edx
80102e8e:	50                   	push   %eax
80102e8f:	53                   	push   %ebx
80102e90:	e8 3b e5 ff ff       	call   801013d0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102e95:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102e98:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e9b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102e9c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ea2:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ea8:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ead:	5a                   	pop    %edx
80102eae:	50                   	push   %eax
80102eaf:	53                   	push   %ebx
80102eb0:	e8 1b d2 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102eb5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102eb8:	83 c4 10             	add    $0x10,%esp
80102ebb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ebd:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102ec3:	7e 1c                	jle    80102ee1 <initlog+0x71>
80102ec5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102ecc:	31 d2                	xor    %edx,%edx
80102ece:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ed0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ed4:	83 c2 04             	add    $0x4,%edx
80102ed7:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102edd:	39 da                	cmp    %ebx,%edx
80102edf:	75 ef                	jne    80102ed0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102ee1:	83 ec 0c             	sub    $0xc,%esp
80102ee4:	50                   	push   %eax
80102ee5:	e8 f6 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102eea:	e8 81 fe ff ff       	call   80102d70 <install_trans>
  log.lh.n = 0;
80102eef:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ef6:	00 00 00 
  write_head(); // clear the log
80102ef9:	e8 12 ff ff ff       	call   80102e10 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102efe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f01:	c9                   	leave  
80102f02:	c3                   	ret    
80102f03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f16:	68 80 36 11 80       	push   $0x80113680
80102f1b:	e8 b0 1a 00 00       	call   801049d0 <acquire>
80102f20:	83 c4 10             	add    $0x10,%esp
80102f23:	eb 18                	jmp    80102f3d <begin_op+0x2d>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f28:	83 ec 08             	sub    $0x8,%esp
80102f2b:	68 80 36 11 80       	push   $0x80113680
80102f30:	68 80 36 11 80       	push   $0x80113680
80102f35:	e8 66 14 00 00       	call   801043a0 <sleep>
80102f3a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102f3d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	75 e2                	jne    80102f28 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f46:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f4b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f51:	83 c0 01             	add    $0x1,%eax
80102f54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f5a:	83 fa 1e             	cmp    $0x1e,%edx
80102f5d:	7f c9                	jg     80102f28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f5f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102f62:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102f67:	68 80 36 11 80       	push   $0x80113680
80102f6c:	e8 7f 1b 00 00       	call   80104af0 <release>
      break;
    }
  }
}
80102f71:	83 c4 10             	add    $0x10,%esp
80102f74:	c9                   	leave  
80102f75:	c3                   	ret    
80102f76:	8d 76 00             	lea    0x0(%esi),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
80102f85:	53                   	push   %ebx
80102f86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f89:	68 80 36 11 80       	push   $0x80113680
80102f8e:	e8 3d 1a 00 00       	call   801049d0 <acquire>
  log.outstanding -= 1;
80102f93:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102f98:	8b 1d c0 36 11 80    	mov    0x801136c0,%ebx
80102f9e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102fa1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102fa4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102fa6:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102fab:	0f 85 23 01 00 00    	jne    801030d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fb1:	85 c0                	test   %eax,%eax
80102fb3:	0f 85 f7 00 00 00    	jne    801030b0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fb9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102fbc:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102fc3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fc6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fc8:	68 80 36 11 80       	push   $0x80113680
80102fcd:	e8 1e 1b 00 00       	call   80104af0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fd2:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102fd8:	83 c4 10             	add    $0x10,%esp
80102fdb:	85 c9                	test   %ecx,%ecx
80102fdd:	0f 8e 8a 00 00 00    	jle    8010306d <end_op+0xed>
80102fe3:	90                   	nop
80102fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fe8:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102fed:	83 ec 08             	sub    $0x8,%esp
80102ff0:	01 d8                	add    %ebx,%eax
80102ff2:	83 c0 01             	add    $0x1,%eax
80102ff5:	50                   	push   %eax
80102ff6:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ffc:	e8 cf d0 ff ff       	call   801000d0 <bread>
80103001:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103003:	58                   	pop    %eax
80103004:	5a                   	pop    %edx
80103005:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
8010300c:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103012:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103015:	e8 b6 d0 ff ff       	call   801000d0 <bread>
8010301a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010301c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010301f:	83 c4 0c             	add    $0xc,%esp
80103022:	68 00 02 00 00       	push   $0x200
80103027:	50                   	push   %eax
80103028:	8d 46 5c             	lea    0x5c(%esi),%eax
8010302b:	50                   	push   %eax
8010302c:	e8 bf 1b 00 00       	call   80104bf0 <memmove>
    bwrite(to);  // write the log
80103031:	89 34 24             	mov    %esi,(%esp)
80103034:	e8 67 d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103039:	89 3c 24             	mov    %edi,(%esp)
8010303c:	e8 9f d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
80103041:	89 34 24             	mov    %esi,(%esp)
80103044:	e8 97 d1 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103049:	83 c4 10             	add    $0x10,%esp
8010304c:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80103052:	7c 94                	jl     80102fe8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103054:	e8 b7 fd ff ff       	call   80102e10 <write_head>
    install_trans(); // Now install writes to home locations
80103059:	e8 12 fd ff ff       	call   80102d70 <install_trans>
    log.lh.n = 0;
8010305e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80103065:	00 00 00 
    write_head();    // Erase the transaction from the log
80103068:	e8 a3 fd ff ff       	call   80102e10 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010306d:	83 ec 0c             	sub    $0xc,%esp
80103070:	68 80 36 11 80       	push   $0x80113680
80103075:	e8 56 19 00 00       	call   801049d0 <acquire>
    log.committing = 0;
    wakeup(&log);
8010307a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80103081:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80103088:	00 00 00 
    wakeup(&log);
8010308b:	e8 80 15 00 00       	call   80104610 <wakeup>
    release(&log.lock);
80103090:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103097:	e8 54 1a 00 00       	call   80104af0 <release>
8010309c:	83 c4 10             	add    $0x10,%esp
  }
}
8010309f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030a2:	5b                   	pop    %ebx
801030a3:	5e                   	pop    %esi
801030a4:	5f                   	pop    %edi
801030a5:	5d                   	pop    %ebp
801030a6:	c3                   	ret    
801030a7:	89 f6                	mov    %esi,%esi
801030a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801030b0:	83 ec 0c             	sub    $0xc,%esp
801030b3:	68 80 36 11 80       	push   $0x80113680
801030b8:	e8 53 15 00 00       	call   80104610 <wakeup>
  }
  release(&log.lock);
801030bd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030c4:	e8 27 1a 00 00       	call   80104af0 <release>
801030c9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
801030cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cf:	5b                   	pop    %ebx
801030d0:	5e                   	pop    %esi
801030d1:	5f                   	pop    %edi
801030d2:	5d                   	pop    %ebp
801030d3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
801030d4:	83 ec 0c             	sub    $0xc,%esp
801030d7:	68 c4 7d 10 80       	push   $0x80107dc4
801030dc:	e8 8f d2 ff ff       	call   80100370 <panic>
801030e1:	eb 0d                	jmp    801030f0 <log_write>
801030e3:	90                   	nop
801030e4:	90                   	nop
801030e5:	90                   	nop
801030e6:	90                   	nop
801030e7:	90                   	nop
801030e8:	90                   	nop
801030e9:	90                   	nop
801030ea:	90                   	nop
801030eb:	90                   	nop
801030ec:	90                   	nop
801030ed:	90                   	nop
801030ee:	90                   	nop
801030ef:	90                   	nop

801030f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	53                   	push   %ebx
801030f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030f7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103100:	83 fa 1d             	cmp    $0x1d,%edx
80103103:	0f 8f 97 00 00 00    	jg     801031a0 <log_write+0xb0>
80103109:	a1 b8 36 11 80       	mov    0x801136b8,%eax
8010310e:	83 e8 01             	sub    $0x1,%eax
80103111:	39 c2                	cmp    %eax,%edx
80103113:	0f 8d 87 00 00 00    	jge    801031a0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103119:	a1 bc 36 11 80       	mov    0x801136bc,%eax
8010311e:	85 c0                	test   %eax,%eax
80103120:	0f 8e 87 00 00 00    	jle    801031ad <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103126:	83 ec 0c             	sub    $0xc,%esp
80103129:	68 80 36 11 80       	push   $0x80113680
8010312e:	e8 9d 18 00 00       	call   801049d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103133:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80103139:	83 c4 10             	add    $0x10,%esp
8010313c:	83 fa 00             	cmp    $0x0,%edx
8010313f:	7e 50                	jle    80103191 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103141:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103144:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103146:	3b 0d cc 36 11 80    	cmp    0x801136cc,%ecx
8010314c:	75 0b                	jne    80103159 <log_write+0x69>
8010314e:	eb 38                	jmp    80103188 <log_write+0x98>
80103150:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80103157:	74 2f                	je     80103188 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103159:	83 c0 01             	add    $0x1,%eax
8010315c:	39 d0                	cmp    %edx,%eax
8010315e:	75 f0                	jne    80103150 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103160:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103167:	83 c2 01             	add    $0x1,%edx
8010316a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80103170:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103173:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
8010317a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010317d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010317e:	e9 6d 19 00 00       	jmp    80104af0 <release>
80103183:	90                   	nop
80103184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103188:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
8010318f:	eb df                	jmp    80103170 <log_write+0x80>
80103191:	8b 43 08             	mov    0x8(%ebx),%eax
80103194:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80103199:	75 d5                	jne    80103170 <log_write+0x80>
8010319b:	eb ca                	jmp    80103167 <log_write+0x77>
8010319d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
801031a0:	83 ec 0c             	sub    $0xc,%esp
801031a3:	68 d3 7d 10 80       	push   $0x80107dd3
801031a8:	e8 c3 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
801031ad:	83 ec 0c             	sub    $0xc,%esp
801031b0:	68 e9 7d 10 80       	push   $0x80107de9
801031b5:	e8 b6 d1 ff ff       	call   80100370 <panic>
801031ba:	66 90                	xchg   %ax,%ax
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <mpmain>:
  mpmain();
}

// Common CPU setup code.
static void
mpmain(void) {
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	53                   	push   %ebx
801031c4:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031c7:	e8 04 0a 00 00       	call   80103bd0 <cpuid>
801031cc:	89 c3                	mov    %eax,%ebx
801031ce:	e8 fd 09 00 00       	call   80103bd0 <cpuid>
801031d3:	83 ec 04             	sub    $0x4,%esp
801031d6:	53                   	push   %ebx
801031d7:	50                   	push   %eax
801031d8:	68 04 7e 10 80       	push   $0x80107e04
801031dd:	e8 7e d4 ff ff       	call   80100660 <cprintf>
    idtinit();       // load idt register
801031e2:	e8 39 2c 00 00       	call   80105e20 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031e7:	e8 64 09 00 00       	call   80103b50 <mycpu>
801031ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031ee:	b8 01 00 00 00       	mov    $0x1,%eax
801031f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
801031fa:	e8 81 0e 00 00       	call   80104080 <scheduler>
801031ff:	90                   	nop

80103200 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103206:	e8 c5 3c 00 00       	call   80106ed0 <switchkvm>
  seginit();
8010320b:	e8 c0 3b 00 00       	call   80106dd0 <seginit>
  lapicinit();
80103210:	e8 9b f7 ff ff       	call   801029b0 <lapicinit>
  mpmain();
80103215:	e8 a6 ff ff ff       	call   801031c0 <mpmain>
8010321a:	66 90                	xchg   %ax,%ax
8010321c:	66 90                	xchg   %ax,%ax
8010321e:	66 90                	xchg   %ax,%ax

80103220 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103220:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103224:	83 e4 f0             	and    $0xfffffff0,%esp
80103227:	ff 71 fc             	pushl  -0x4(%ecx)
8010322a:	55                   	push   %ebp
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	53                   	push   %ebx
8010322e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010322f:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103234:	83 ec 08             	sub    $0x8,%esp
80103237:	68 00 00 40 80       	push   $0x80400000
8010323c:	68 a8 69 12 80       	push   $0x801269a8
80103241:	e8 3a f5 ff ff       	call   80102780 <kinit1>
  kvmalloc();      // kernel page table
80103246:	e8 65 44 00 00       	call   801076b0 <kvmalloc>
  mpinit();        // detect other processors
8010324b:	e8 70 01 00 00       	call   801033c0 <mpinit>
  lapicinit();     // interrupt controller
80103250:	e8 5b f7 ff ff       	call   801029b0 <lapicinit>
  seginit();       // segment descriptors
80103255:	e8 76 3b 00 00       	call   80106dd0 <seginit>
  picinit();       // disable pic
8010325a:	e8 31 03 00 00       	call   80103590 <picinit>
  ioapicinit();    // another interrupt controller
8010325f:	e8 4c f3 ff ff       	call   801025b0 <ioapicinit>
  consoleinit();   // console hardware
80103264:	e8 37 d7 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103269:	e8 d2 2e 00 00       	call   80106140 <uartinit>
  pinit();         // process table
8010326e:	e8 bd 08 00 00       	call   80103b30 <pinit>
  tvinit();        // trap vectors
80103273:	e8 08 2b 00 00       	call   80105d80 <tvinit>
  binit();         // buffer cache
80103278:	e8 c3 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010327d:	e8 ee da ff ff       	call   80100d70 <fileinit>
  ideinit();       // disk 
80103282:	e8 09 f1 ff ff       	call   80102390 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103287:	83 c4 0c             	add    $0xc,%esp
8010328a:	68 8a 00 00 00       	push   $0x8a
8010328f:	68 8c b4 10 80       	push   $0x8010b48c
80103294:	68 00 70 00 80       	push   $0x80007000
80103299:	e8 52 19 00 00       	call   80104bf0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010329e:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801032a5:	00 00 00 
801032a8:	83 c4 10             	add    $0x10,%esp
801032ab:	05 80 37 11 80       	add    $0x80113780,%eax
801032b0:	39 d8                	cmp    %ebx,%eax
801032b2:	76 6f                	jbe    80103323 <main+0x103>
801032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801032b8:	e8 93 08 00 00       	call   80103b50 <mycpu>
801032bd:	39 d8                	cmp    %ebx,%eax
801032bf:	74 49                	je     8010330a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032c1:	e8 8a f5 ff ff       	call   80102850 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032c6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801032cb:	c7 05 f8 6f 00 80 00 	movl   $0x80103200,0x80006ff8
801032d2:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032d5:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032dc:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801032df:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032e4:	0f b6 03             	movzbl (%ebx),%eax
801032e7:	83 ec 08             	sub    $0x8,%esp
801032ea:	68 00 70 00 00       	push   $0x7000
801032ef:	50                   	push   %eax
801032f0:	e8 0b f8 ff ff       	call   80102b00 <lapicstartap>
801032f5:	83 c4 10             	add    $0x10,%esp
801032f8:	90                   	nop
801032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103300:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103306:	85 c0                	test   %eax,%eax
80103308:	74 f6                	je     80103300 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010330a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103311:	00 00 00 
80103314:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010331a:	05 80 37 11 80       	add    $0x80113780,%eax
8010331f:	39 c3                	cmp    %eax,%ebx
80103321:	72 95                	jb     801032b8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103323:	83 ec 08             	sub    $0x8,%esp
80103326:	68 00 00 00 8e       	push   $0x8e000000
8010332b:	68 00 00 40 80       	push   $0x80400000
80103330:	e8 bb f4 ff ff       	call   801027f0 <kinit2>
  userinit();      // first user process
80103335:	e8 e6 08 00 00       	call   80103c20 <userinit>
  mpmain();        // finish this processor's setup
8010333a:	e8 81 fe ff ff       	call   801031c0 <mpmain>
8010333f:	90                   	nop

80103340 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103345:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010334b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010334c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010334f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103352:	39 de                	cmp    %ebx,%esi
80103354:	73 48                	jae    8010339e <mpsearch1+0x5e>
80103356:	8d 76 00             	lea    0x0(%esi),%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103360:	83 ec 04             	sub    $0x4,%esp
80103363:	8d 7e 10             	lea    0x10(%esi),%edi
80103366:	6a 04                	push   $0x4
80103368:	68 18 7e 10 80       	push   $0x80107e18
8010336d:	56                   	push   %esi
8010336e:	e8 1d 18 00 00       	call   80104b90 <memcmp>
80103373:	83 c4 10             	add    $0x10,%esp
80103376:	85 c0                	test   %eax,%eax
80103378:	75 1e                	jne    80103398 <mpsearch1+0x58>
8010337a:	8d 7e 10             	lea    0x10(%esi),%edi
8010337d:	89 f2                	mov    %esi,%edx
8010337f:	31 c9                	xor    %ecx,%ecx
80103381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103388:	0f b6 02             	movzbl (%edx),%eax
8010338b:	83 c2 01             	add    $0x1,%edx
8010338e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103390:	39 fa                	cmp    %edi,%edx
80103392:	75 f4                	jne    80103388 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103394:	84 c9                	test   %cl,%cl
80103396:	74 10                	je     801033a8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103398:	39 fb                	cmp    %edi,%ebx
8010339a:	89 fe                	mov    %edi,%esi
8010339c:	77 c2                	ja     80103360 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010339e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801033a1:	31 c0                	xor    %eax,%eax
}
801033a3:	5b                   	pop    %ebx
801033a4:	5e                   	pop    %esi
801033a5:	5f                   	pop    %edi
801033a6:	5d                   	pop    %ebp
801033a7:	c3                   	ret    
801033a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ab:	89 f0                	mov    %esi,%eax
801033ad:	5b                   	pop    %ebx
801033ae:	5e                   	pop    %esi
801033af:	5f                   	pop    %edi
801033b0:	5d                   	pop    %ebp
801033b1:	c3                   	ret    
801033b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
801033c5:	53                   	push   %ebx
801033c6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033d7:	c1 e0 08             	shl    $0x8,%eax
801033da:	09 d0                	or     %edx,%eax
801033dc:	c1 e0 04             	shl    $0x4,%eax
801033df:	85 c0                	test   %eax,%eax
801033e1:	75 1b                	jne    801033fe <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801033e3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033ea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033f1:	c1 e0 08             	shl    $0x8,%eax
801033f4:	09 d0                	or     %edx,%eax
801033f6:	c1 e0 0a             	shl    $0xa,%eax
801033f9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801033fe:	ba 00 04 00 00       	mov    $0x400,%edx
80103403:	e8 38 ff ff ff       	call   80103340 <mpsearch1>
80103408:	85 c0                	test   %eax,%eax
8010340a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010340d:	0f 84 37 01 00 00    	je     8010354a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103416:	8b 58 04             	mov    0x4(%eax),%ebx
80103419:	85 db                	test   %ebx,%ebx
8010341b:	0f 84 43 01 00 00    	je     80103564 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103421:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103427:	83 ec 04             	sub    $0x4,%esp
8010342a:	6a 04                	push   $0x4
8010342c:	68 1d 7e 10 80       	push   $0x80107e1d
80103431:	56                   	push   %esi
80103432:	e8 59 17 00 00       	call   80104b90 <memcmp>
80103437:	83 c4 10             	add    $0x10,%esp
8010343a:	85 c0                	test   %eax,%eax
8010343c:	0f 85 22 01 00 00    	jne    80103564 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103442:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103449:	3c 01                	cmp    $0x1,%al
8010344b:	74 08                	je     80103455 <mpinit+0x95>
8010344d:	3c 04                	cmp    $0x4,%al
8010344f:	0f 85 0f 01 00 00    	jne    80103564 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103455:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010345c:	85 ff                	test   %edi,%edi
8010345e:	74 21                	je     80103481 <mpinit+0xc1>
80103460:	31 d2                	xor    %edx,%edx
80103462:	31 c0                	xor    %eax,%eax
80103464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103468:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010346f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103470:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103473:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103475:	39 c7                	cmp    %eax,%edi
80103477:	75 ef                	jne    80103468 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103479:	84 d2                	test   %dl,%dl
8010347b:	0f 85 e3 00 00 00    	jne    80103564 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103481:	85 f6                	test   %esi,%esi
80103483:	0f 84 db 00 00 00    	je     80103564 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103489:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010348f:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103494:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010349b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801034a1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034a6:	01 d6                	add    %edx,%esi
801034a8:	90                   	nop
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034b0:	39 c6                	cmp    %eax,%esi
801034b2:	76 23                	jbe    801034d7 <mpinit+0x117>
801034b4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801034b7:	80 fa 04             	cmp    $0x4,%dl
801034ba:	0f 87 c0 00 00 00    	ja     80103580 <mpinit+0x1c0>
801034c0:	ff 24 95 5c 7e 10 80 	jmp    *-0x7fef81a4(,%edx,4)
801034c7:	89 f6                	mov    %esi,%esi
801034c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034d0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034d3:	39 c6                	cmp    %eax,%esi
801034d5:	77 dd                	ja     801034b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034d7:	85 db                	test   %ebx,%ebx
801034d9:	0f 84 92 00 00 00    	je     80103571 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034e2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801034e6:	74 15                	je     801034fd <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034e8:	ba 22 00 00 00       	mov    $0x22,%edx
801034ed:	b8 70 00 00 00       	mov    $0x70,%eax
801034f2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034f3:	ba 23 00 00 00       	mov    $0x23,%edx
801034f8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034f9:	83 c8 01             	or     $0x1,%eax
801034fc:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801034fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103500:	5b                   	pop    %ebx
80103501:	5e                   	pop    %esi
80103502:	5f                   	pop    %edi
80103503:	5d                   	pop    %ebp
80103504:	c3                   	ret    
80103505:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103508:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
8010350e:	83 f9 07             	cmp    $0x7,%ecx
80103511:	7f 19                	jg     8010352c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103513:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103517:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010351d:	83 c1 01             	add    $0x1,%ecx
80103520:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103526:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010352c:	83 c0 14             	add    $0x14,%eax
      continue;
8010352f:	e9 7c ff ff ff       	jmp    801034b0 <mpinit+0xf0>
80103534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103538:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010353c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010353f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
80103545:	e9 66 ff ff ff       	jmp    801034b0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010354a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010354f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103554:	e8 e7 fd ff ff       	call   80103340 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103559:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010355b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010355e:	0f 85 af fe ff ff    	jne    80103413 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103564:	83 ec 0c             	sub    $0xc,%esp
80103567:	68 22 7e 10 80       	push   $0x80107e22
8010356c:	e8 ff cd ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103571:	83 ec 0c             	sub    $0xc,%esp
80103574:	68 3c 7e 10 80       	push   $0x80107e3c
80103579:	e8 f2 cd ff ff       	call   80100370 <panic>
8010357e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103580:	31 db                	xor    %ebx,%ebx
80103582:	e9 30 ff ff ff       	jmp    801034b7 <mpinit+0xf7>
80103587:	66 90                	xchg   %ax,%ax
80103589:	66 90                	xchg   %ax,%ax
8010358b:	66 90                	xchg   %ax,%ax
8010358d:	66 90                	xchg   %ax,%ax
8010358f:	90                   	nop

80103590 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103590:	55                   	push   %ebp
80103591:	ba 21 00 00 00       	mov    $0x21,%edx
80103596:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010359b:	89 e5                	mov    %esp,%ebp
8010359d:	ee                   	out    %al,(%dx)
8010359e:	ba a1 00 00 00       	mov    $0xa1,%edx
801035a3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035a4:	5d                   	pop    %ebp
801035a5:	c3                   	ret    
801035a6:	66 90                	xchg   %ax,%ax
801035a8:	66 90                	xchg   %ax,%ax
801035aa:	66 90                	xchg   %ax,%ax
801035ac:	66 90                	xchg   %ax,%ax
801035ae:	66 90                	xchg   %ax,%ax

801035b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	57                   	push   %edi
801035b4:	56                   	push   %esi
801035b5:	53                   	push   %ebx
801035b6:	83 ec 0c             	sub    $0xc,%esp
801035b9:	8b 75 08             	mov    0x8(%ebp),%esi
801035bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801035c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035cb:	e8 c0 d7 ff ff       	call   80100d90 <filealloc>
801035d0:	85 c0                	test   %eax,%eax
801035d2:	89 06                	mov    %eax,(%esi)
801035d4:	0f 84 a8 00 00 00    	je     80103682 <pipealloc+0xd2>
801035da:	e8 b1 d7 ff ff       	call   80100d90 <filealloc>
801035df:	85 c0                	test   %eax,%eax
801035e1:	89 03                	mov    %eax,(%ebx)
801035e3:	0f 84 87 00 00 00    	je     80103670 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035e9:	e8 62 f2 ff ff       	call   80102850 <kalloc>
801035ee:	85 c0                	test   %eax,%eax
801035f0:	89 c7                	mov    %eax,%edi
801035f2:	0f 84 b0 00 00 00    	je     801036a8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035f8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801035fb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103602:	00 00 00 
  p->writeopen = 1;
80103605:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010360c:	00 00 00 
  p->nwrite = 0;
8010360f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103616:	00 00 00 
  p->nread = 0;
80103619:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103620:	00 00 00 
  initlock(&p->lock, "pipe");
80103623:	68 70 7e 10 80       	push   $0x80107e70
80103628:	50                   	push   %eax
80103629:	e8 a2 12 00 00       	call   801048d0 <initlock>
  (*f0)->type = FD_PIPE;
8010362e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103630:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103633:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103639:	8b 06                	mov    (%esi),%eax
8010363b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010363f:	8b 06                	mov    (%esi),%eax
80103641:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103645:	8b 06                	mov    (%esi),%eax
80103647:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010364a:	8b 03                	mov    (%ebx),%eax
8010364c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103652:	8b 03                	mov    (%ebx),%eax
80103654:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103658:	8b 03                	mov    (%ebx),%eax
8010365a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010365e:	8b 03                	mov    (%ebx),%eax
80103660:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103663:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103666:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103668:	5b                   	pop    %ebx
80103669:	5e                   	pop    %esi
8010366a:	5f                   	pop    %edi
8010366b:	5d                   	pop    %ebp
8010366c:	c3                   	ret    
8010366d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103670:	8b 06                	mov    (%esi),%eax
80103672:	85 c0                	test   %eax,%eax
80103674:	74 1e                	je     80103694 <pipealloc+0xe4>
    fileclose(*f0);
80103676:	83 ec 0c             	sub    $0xc,%esp
80103679:	50                   	push   %eax
8010367a:	e8 d1 d7 ff ff       	call   80100e50 <fileclose>
8010367f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103682:	8b 03                	mov    (%ebx),%eax
80103684:	85 c0                	test   %eax,%eax
80103686:	74 0c                	je     80103694 <pipealloc+0xe4>
    fileclose(*f1);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	50                   	push   %eax
8010368c:	e8 bf d7 ff ff       	call   80100e50 <fileclose>
80103691:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103694:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036a8:	8b 06                	mov    (%esi),%eax
801036aa:	85 c0                	test   %eax,%eax
801036ac:	75 c8                	jne    80103676 <pipealloc+0xc6>
801036ae:	eb d2                	jmp    80103682 <pipealloc+0xd2>

801036b0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	56                   	push   %esi
801036b4:	53                   	push   %ebx
801036b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036bb:	83 ec 0c             	sub    $0xc,%esp
801036be:	53                   	push   %ebx
801036bf:	e8 0c 13 00 00       	call   801049d0 <acquire>
  if(writable){
801036c4:	83 c4 10             	add    $0x10,%esp
801036c7:	85 f6                	test   %esi,%esi
801036c9:	74 45                	je     80103710 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801036cb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036d1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801036d4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036db:	00 00 00 
    wakeup(&p->nread);
801036de:	50                   	push   %eax
801036df:	e8 2c 0f 00 00       	call   80104610 <wakeup>
801036e4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036e7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036ed:	85 d2                	test   %edx,%edx
801036ef:	75 0a                	jne    801036fb <pipeclose+0x4b>
801036f1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036f7:	85 c0                	test   %eax,%eax
801036f9:	74 35                	je     80103730 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103701:	5b                   	pop    %ebx
80103702:	5e                   	pop    %esi
80103703:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103704:	e9 e7 13 00 00       	jmp    80104af0 <release>
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103710:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103716:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103719:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103720:	00 00 00 
    wakeup(&p->nwrite);
80103723:	50                   	push   %eax
80103724:	e8 e7 0e 00 00       	call   80104610 <wakeup>
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	eb b9                	jmp    801036e7 <pipeclose+0x37>
8010372e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	53                   	push   %ebx
80103734:	e8 b7 13 00 00       	call   80104af0 <release>
    kfree((char*)p);
80103739:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010373c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010373f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103742:	5b                   	pop    %ebx
80103743:	5e                   	pop    %esi
80103744:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103745:	e9 56 ef ff ff       	jmp    801026a0 <kfree>
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103750 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 28             	sub    $0x28,%esp
80103759:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010375c:	53                   	push   %ebx
8010375d:	e8 6e 12 00 00       	call   801049d0 <acquire>
  for(i = 0; i < n; i++){
80103762:	8b 45 10             	mov    0x10(%ebp),%eax
80103765:	83 c4 10             	add    $0x10,%esp
80103768:	85 c0                	test   %eax,%eax
8010376a:	0f 8e b9 00 00 00    	jle    80103829 <pipewrite+0xd9>
80103770:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103773:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103779:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010377f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103785:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103788:	03 4d 10             	add    0x10(%ebp),%ecx
8010378b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010378e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103794:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010379a:	39 d0                	cmp    %edx,%eax
8010379c:	74 38                	je     801037d6 <pipewrite+0x86>
8010379e:	eb 59                	jmp    801037f9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801037a0:	e8 4b 04 00 00       	call   80103bf0 <myproc>
801037a5:	8b 48 24             	mov    0x24(%eax),%ecx
801037a8:	85 c9                	test   %ecx,%ecx
801037aa:	75 34                	jne    801037e0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037ac:	83 ec 0c             	sub    $0xc,%esp
801037af:	57                   	push   %edi
801037b0:	e8 5b 0e 00 00       	call   80104610 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037b5:	58                   	pop    %eax
801037b6:	5a                   	pop    %edx
801037b7:	53                   	push   %ebx
801037b8:	56                   	push   %esi
801037b9:	e8 e2 0b 00 00       	call   801043a0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037be:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037c4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037ca:	83 c4 10             	add    $0x10,%esp
801037cd:	05 00 02 00 00       	add    $0x200,%eax
801037d2:	39 c2                	cmp    %eax,%edx
801037d4:	75 2a                	jne    80103800 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801037d6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037dc:	85 c0                	test   %eax,%eax
801037de:	75 c0                	jne    801037a0 <pipewrite+0x50>
        release(&p->lock);
801037e0:	83 ec 0c             	sub    $0xc,%esp
801037e3:	53                   	push   %ebx
801037e4:	e8 07 13 00 00       	call   80104af0 <release>
        return -1;
801037e9:	83 c4 10             	add    $0x10,%esp
801037ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f4:	5b                   	pop    %ebx
801037f5:	5e                   	pop    %esi
801037f6:	5f                   	pop    %edi
801037f7:	5d                   	pop    %ebp
801037f8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f9:	89 c2                	mov    %eax,%edx
801037fb:	90                   	nop
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103800:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103803:	8d 42 01             	lea    0x1(%edx),%eax
80103806:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010380a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103810:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103816:	0f b6 09             	movzbl (%ecx),%ecx
80103819:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010381d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103820:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103823:	0f 85 65 ff ff ff    	jne    8010378e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103829:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010382f:	83 ec 0c             	sub    $0xc,%esp
80103832:	50                   	push   %eax
80103833:	e8 d8 0d 00 00       	call   80104610 <wakeup>
  release(&p->lock);
80103838:	89 1c 24             	mov    %ebx,(%esp)
8010383b:	e8 b0 12 00 00       	call   80104af0 <release>
  return n;
80103840:	83 c4 10             	add    $0x10,%esp
80103843:	8b 45 10             	mov    0x10(%ebp),%eax
80103846:	eb a9                	jmp    801037f1 <pipewrite+0xa1>
80103848:	90                   	nop
80103849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103850 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	57                   	push   %edi
80103854:	56                   	push   %esi
80103855:	53                   	push   %ebx
80103856:	83 ec 18             	sub    $0x18,%esp
80103859:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010385c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010385f:	53                   	push   %ebx
80103860:	e8 6b 11 00 00       	call   801049d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010386e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103874:	75 6a                	jne    801038e0 <piperead+0x90>
80103876:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010387c:	85 f6                	test   %esi,%esi
8010387e:	0f 84 cc 00 00 00    	je     80103950 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103884:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010388a:	eb 2d                	jmp    801038b9 <piperead+0x69>
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103890:	83 ec 08             	sub    $0x8,%esp
80103893:	53                   	push   %ebx
80103894:	56                   	push   %esi
80103895:	e8 06 0b 00 00       	call   801043a0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010389a:	83 c4 10             	add    $0x10,%esp
8010389d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801038a3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801038a9:	75 35                	jne    801038e0 <piperead+0x90>
801038ab:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801038b1:	85 d2                	test   %edx,%edx
801038b3:	0f 84 97 00 00 00    	je     80103950 <piperead+0x100>
    if(myproc()->killed){
801038b9:	e8 32 03 00 00       	call   80103bf0 <myproc>
801038be:	8b 48 24             	mov    0x24(%eax),%ecx
801038c1:	85 c9                	test   %ecx,%ecx
801038c3:	74 cb                	je     80103890 <piperead+0x40>
      release(&p->lock);
801038c5:	83 ec 0c             	sub    $0xc,%esp
801038c8:	53                   	push   %ebx
801038c9:	e8 22 12 00 00       	call   80104af0 <release>
      return -1;
801038ce:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038d1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801038d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038d9:	5b                   	pop    %ebx
801038da:	5e                   	pop    %esi
801038db:	5f                   	pop    %edi
801038dc:	5d                   	pop    %ebp
801038dd:	c3                   	ret    
801038de:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038e0:	8b 45 10             	mov    0x10(%ebp),%eax
801038e3:	85 c0                	test   %eax,%eax
801038e5:	7e 69                	jle    80103950 <piperead+0x100>
    if(p->nread == p->nwrite)
801038e7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038ed:	31 c9                	xor    %ecx,%ecx
801038ef:	eb 15                	jmp    80103906 <piperead+0xb6>
801038f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038f8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038fe:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103904:	74 5a                	je     80103960 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103906:	8d 70 01             	lea    0x1(%eax),%esi
80103909:	25 ff 01 00 00       	and    $0x1ff,%eax
8010390e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103914:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103919:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010391c:	83 c1 01             	add    $0x1,%ecx
8010391f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103922:	75 d4                	jne    801038f8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103924:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010392a:	83 ec 0c             	sub    $0xc,%esp
8010392d:	50                   	push   %eax
8010392e:	e8 dd 0c 00 00       	call   80104610 <wakeup>
  release(&p->lock);
80103933:	89 1c 24             	mov    %ebx,(%esp)
80103936:	e8 b5 11 00 00       	call   80104af0 <release>
  return i;
8010393b:	8b 45 10             	mov    0x10(%ebp),%eax
8010393e:	83 c4 10             	add    $0x10,%esp
}
80103941:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103944:	5b                   	pop    %ebx
80103945:	5e                   	pop    %esi
80103946:	5f                   	pop    %edi
80103947:	5d                   	pop    %ebp
80103948:	c3                   	ret    
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103950:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103957:	eb cb                	jmp    80103924 <piperead+0xd4>
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103960:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103963:	eb bf                	jmp    80103924 <piperead+0xd4>
80103965:	66 90                	xchg   %ax,%ax
80103967:	66 90                	xchg   %ax,%ax
80103969:	66 90                	xchg   %ax,%ax
8010396b:	66 90                	xchg   %ax,%ax
8010396d:	66 90                	xchg   %ax,%ax
8010396f:	90                   	nop

80103970 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void) {
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	53                   	push   %ebx
    struct page *pg;
    char *sp;

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103974:	bb 54 4d 11 80       	mov    $0x80114d54,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void) {
80103979:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    struct page *pg;
    char *sp;

    acquire(&ptable.lock);
8010397c:	68 20 4d 11 80       	push   $0x80114d20
80103981:	e8 4a 10 00 00       	call   801049d0 <acquire>
80103986:	83 c4 10             	add    $0x10,%esp
80103989:	eb 17                	jmp    801039a2 <allocproc+0x32>
8010398b:	90                   	nop
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103990:	81 c3 50 04 00 00    	add    $0x450,%ebx
80103996:	81 fb 54 61 12 80    	cmp    $0x80126154,%ebx
8010399c:	0f 84 fe 00 00 00    	je     80103aa0 <allocproc+0x130>
        if (p->state == UNUSED)
801039a2:	8b 43 0c             	mov    0xc(%ebx),%eax
801039a5:	85 c0                	test   %eax,%eax
801039a7:	75 e7                	jne    80103990 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
801039a9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

    release(&ptable.lock);
801039ae:	83 ec 0c             	sub    $0xc,%esp

    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
801039b1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;

    release(&ptable.lock);
801039b8:	68 20 4d 11 80       	push   $0x80114d20
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
801039bd:	8d 50 01             	lea    0x1(%eax),%edx
801039c0:	89 43 10             	mov    %eax,0x10(%ebx)
801039c3:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

    release(&ptable.lock);
801039c9:	e8 22 11 00 00       	call   80104af0 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
801039ce:	e8 7d ee ff ff       	call   80102850 <kalloc>
801039d3:	83 c4 10             	add    $0x10,%esp
801039d6:	85 c0                	test   %eax,%eax
801039d8:	89 43 08             	mov    %eax,0x8(%ebx)
801039db:	0f 84 d6 00 00 00    	je     80103ab7 <allocproc+0x147>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
801039e1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
801039e7:	83 ec 04             	sub    $0x4,%esp
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
801039ea:	05 9c 0f 00 00       	add    $0xf9c,%eax
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
801039ef:	89 53 18             	mov    %edx,0x18(%ebx)
    p->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;
801039f2:	c7 40 14 72 5d 10 80 	movl   $0x80105d72,0x14(%eax)

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
801039f9:	6a 14                	push   $0x14
801039fb:	6a 00                	push   $0x0
801039fd:	50                   	push   %eax
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
801039fe:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103a01:	e8 3a 11 00 00       	call   80104b40 <memset>
    p->context->eip = (uint) forkret;
80103a06:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a09:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
80103a0f:	8d 93 40 04 00 00    	lea    0x440(%ebx),%edx
80103a15:	83 c4 10             	add    $0x10,%esp
80103a18:	c7 40 10 c0 3a 10 80 	movl   $0x80103ac0,0x10(%eax)

    //TODO INIT PROC PAGES FIELDS
    p->pagesCounter = 0;
80103a1f:	c7 83 44 04 00 00 00 	movl   $0x0,0x444(%ebx)
80103a26:	00 00 00 
80103a29:	89 c8                	mov    %ecx,%eax
    p->nextpageid = 1;
80103a2b:	c7 83 40 04 00 00 01 	movl   $0x1,0x440(%ebx)
80103a32:	00 00 00 
//    p->swapOffset = 0;
    p->pagesequel = 0;
80103a35:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
80103a3c:	00 00 00 
    p->pagesinSwap = 0;
80103a3f:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
80103a46:	00 00 00 
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;
80103a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103a56:	83 c0 04             	add    $0x4,%eax
//    p->swapOffset = 0;
    p->pagesequel = 0;
    p->pagesinSwap = 0;

    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103a59:	39 d0                	cmp    %edx,%eax
80103a5b:	75 f3                	jne    80103a50 <allocproc+0xe0>
        p->swapFileEntries[k]=0;

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103a5d:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103a63:	90                   	nop
80103a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
        pg->offset = 0;
80103a68:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        pg->pageid = 0;
80103a6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103a76:	83 c0 1c             	add    $0x1c,%eax
    {
        pg->offset = 0;
        pg->pageid = 0;
        pg->present = 0;
80103a79:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
        pg->sequel = 0;
80103a80:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
        pg->physAdress = 0;
80103a87:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        pg->virtAdress = 0;
80103a8e:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103a95:	39 c8                	cmp    %ecx,%eax
80103a97:	72 cf                	jb     80103a68 <allocproc+0xf8>
80103a99:	89 d8                	mov    %ebx,%eax
        pg->virtAdress = 0;
    }


    return p;
}
80103a9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a9e:	c9                   	leave  
80103a9f:	c3                   	ret    

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED)
            goto found;

    release(&ptable.lock);
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 20 4d 11 80       	push   $0x80114d20
80103aa8:	e8 43 10 00 00       	call   80104af0 <release>
    return 0;
80103aad:	83 c4 10             	add    $0x10,%esp
80103ab0:	31 c0                	xor    %eax,%eax
        pg->virtAdress = 0;
    }


    return p;
}
80103ab2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab5:	c9                   	leave  
80103ab6:	c3                   	ret    

    release(&ptable.lock);

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
        p->state = UNUSED;
80103ab7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103abe:	eb db                	jmp    80103a9b <allocproc+0x12b>

80103ac0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103ac6:	68 20 4d 11 80       	push   $0x80114d20
80103acb:	e8 20 10 00 00       	call   80104af0 <release>

    if (first) {
80103ad0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103ad5:	83 c4 10             	add    $0x10,%esp
80103ad8:	85 c0                	test   %eax,%eax
80103ada:	75 04                	jne    80103ae0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103adc:	c9                   	leave  
80103add:	c3                   	ret    
80103ade:	66 90                	xchg   %ax,%ax
    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
80103ae0:	83 ec 0c             	sub    $0xc,%esp

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
80103ae3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103aea:	00 00 00 
        iinit(ROOTDEV);
80103aed:	6a 01                	push   $0x1
80103aef:	e8 9c d9 ff ff       	call   80101490 <iinit>
        initlog(ROOTDEV);
80103af4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103afb:	e8 70 f3 ff ff       	call   80102e70 <initlog>
80103b00:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103b03:	c9                   	leave  
80103b04:	c3                   	ret    
80103b05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b10 <notShell>:
extern void trapret(void);

static void wakeup1(void *chan);

int notShell(void){
    return nextpid>3;
80103b10:	31 c0                	xor    %eax,%eax
80103b12:	83 3d 04 b0 10 80 03 	cmpl   $0x3,0x8010b004
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

int notShell(void){
80103b19:	55                   	push   %ebp
80103b1a:	89 e5                	mov    %esp,%ebp
    return nextpid>3;
}
80103b1c:	5d                   	pop    %ebp
extern void trapret(void);

static void wakeup1(void *chan);

int notShell(void){
    return nextpid>3;
80103b1d:	0f 9f c0             	setg   %al
}
80103b20:	c3                   	ret    
80103b21:	eb 0d                	jmp    80103b30 <pinit>
80103b23:	90                   	nop
80103b24:	90                   	nop
80103b25:	90                   	nop
80103b26:	90                   	nop
80103b27:	90                   	nop
80103b28:	90                   	nop
80103b29:	90                   	nop
80103b2a:	90                   	nop
80103b2b:	90                   	nop
80103b2c:	90                   	nop
80103b2d:	90                   	nop
80103b2e:	90                   	nop
80103b2f:	90                   	nop

80103b30 <pinit>:

void
pinit(void)
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b36:	68 75 7e 10 80       	push   $0x80107e75
80103b3b:	68 20 4d 11 80       	push   $0x80114d20
80103b40:	e8 8b 0d 00 00       	call   801048d0 <initlock>
}
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	c9                   	leave  
80103b49:	c3                   	ret    
80103b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b50 <mycpu>:
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void) {
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	56                   	push   %esi
80103b54:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b55:	9c                   	pushf  
80103b56:	58                   	pop    %eax
    int apicid, i;

    if (readeflags() & FL_IF)
80103b57:	f6 c4 02             	test   $0x2,%ah
80103b5a:	75 5b                	jne    80103bb7 <mycpu+0x67>
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
80103b5c:	e8 4f ef ff ff       	call   80102ab0 <lapicid>
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103b61:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103b67:	85 f6                	test   %esi,%esi
80103b69:	7e 3f                	jle    80103baa <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
80103b6b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103b72:	39 d0                	cmp    %edx,%eax
80103b74:	74 30                	je     80103ba6 <mycpu+0x56>
80103b76:	b9 30 38 11 80       	mov    $0x80113830,%ecx
80103b7b:	31 d2                	xor    %edx,%edx
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103b80:	83 c2 01             	add    $0x1,%edx
80103b83:	39 f2                	cmp    %esi,%edx
80103b85:	74 23                	je     80103baa <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
80103b87:	0f b6 19             	movzbl (%ecx),%ebx
80103b8a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b90:	39 d8                	cmp    %ebx,%eax
80103b92:	75 ec                	jne    80103b80 <mycpu+0x30>
            return &cpus[i];
80103b94:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
    }
    panic("unknown apicid\n");
}
80103b9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b9d:	5b                   	pop    %ebx
    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
            return &cpus[i];
80103b9e:	05 80 37 11 80       	add    $0x80113780,%eax
    }
    panic("unknown apicid\n");
}
80103ba3:	5e                   	pop    %esi
80103ba4:	5d                   	pop    %ebp
80103ba5:	c3                   	ret    
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103ba6:	31 d2                	xor    %edx,%edx
80103ba8:	eb ea                	jmp    80103b94 <mycpu+0x44>
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
80103baa:	83 ec 0c             	sub    $0xc,%esp
80103bad:	68 7c 7e 10 80       	push   $0x80107e7c
80103bb2:	e8 b9 c7 ff ff       	call   80100370 <panic>
struct cpu*
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
        panic("mycpu called with interrupts enabled\n");
80103bb7:	83 ec 0c             	sub    $0xc,%esp
80103bba:	68 58 7f 10 80       	push   $0x80107f58
80103bbf:	e8 ac c7 ff ff       	call   80100370 <panic>
80103bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bd0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103bd6:	e8 75 ff ff ff       	call   80103b50 <mycpu>
80103bdb:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103be0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103be1:	c1 f8 04             	sar    $0x4,%eax
80103be4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bea:	c3                   	ret    
80103beb:	90                   	nop
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bf0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	53                   	push   %ebx
80103bf4:	83 ec 04             	sub    $0x4,%esp
    struct cpu *c;
    struct proc *p;
    pushcli();
80103bf7:	e8 94 0d 00 00       	call   80104990 <pushcli>
    c = mycpu();
80103bfc:	e8 4f ff ff ff       	call   80103b50 <mycpu>
    p = c->proc;
80103c01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103c07:	e8 74 0e 00 00       	call   80104a80 <popcli>
    return p;
}
80103c0c:	83 c4 04             	add    $0x4,%esp
80103c0f:	89 d8                	mov    %ebx,%eax
80103c11:	5b                   	pop    %ebx
80103c12:	5d                   	pop    %ebp
80103c13:	c3                   	ret    
80103c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c20 <userinit>:
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	53                   	push   %ebx
80103c24:	83 ec 04             	sub    $0x4,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
80103c27:	e8 44 fd ff ff       	call   80103970 <allocproc>
80103c2c:	89 c3                	mov    %eax,%ebx

    initproc = p;
80103c2e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
    if ((p->pgdir = setupkvm()) == 0)
80103c33:	e8 f8 39 00 00       	call   80107630 <setupkvm>
80103c38:	85 c0                	test   %eax,%eax
80103c3a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c3d:	0f 84 bd 00 00 00    	je     80103d00 <userinit+0xe0>
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103c43:	83 ec 04             	sub    $0x4,%esp
80103c46:	68 2c 00 00 00       	push   $0x2c
80103c4b:	68 60 b4 10 80       	push   $0x8010b460
80103c50:	50                   	push   %eax
80103c51:	e8 aa 33 00 00       	call   80107000 <inituvm>
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
80103c56:	83 c4 0c             	add    $0xc,%esp

    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
80103c59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103c5f:	6a 4c                	push   $0x4c
80103c61:	6a 00                	push   $0x0
80103c63:	ff 73 18             	pushl  0x18(%ebx)
80103c66:	e8 d5 0e 00 00       	call   80104b40 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c6b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c6e:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c73:	b9 23 00 00 00       	mov    $0x23,%ecx
    p->tf->ss = p->tf->ds;
    p->tf->eflags = FL_IF;
    p->tf->esp = PGSIZE;
    p->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
80103c78:	83 c4 0c             	add    $0xc,%esp
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c7b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c82:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103c86:	8b 43 18             	mov    0x18(%ebx),%eax
80103c89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c8d:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103c91:	8b 43 18             	mov    0x18(%ebx),%eax
80103c94:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c98:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103c9c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c9f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103ca6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ca9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103cb0:	8b 43 18             	mov    0x18(%ebx),%eax
80103cb3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
80103cba:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103cbd:	6a 10                	push   $0x10
80103cbf:	68 a5 7e 10 80       	push   $0x80107ea5
80103cc4:	50                   	push   %eax
80103cc5:	e8 76 10 00 00       	call   80104d40 <safestrcpy>
    p->cwd = namei("/");
80103cca:	c7 04 24 ae 7e 10 80 	movl   $0x80107eae,(%esp)
80103cd1:	e8 0a e2 ff ff       	call   80101ee0 <namei>
80103cd6:	89 43 68             	mov    %eax,0x68(%ebx)

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
80103cd9:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80103ce0:	e8 eb 0c 00 00       	call   801049d0 <acquire>

    p->state = RUNNABLE;
80103ce5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

    release(&ptable.lock);
80103cec:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80103cf3:	e8 f8 0d 00 00       	call   80104af0 <release>
}
80103cf8:	83 c4 10             	add    $0x10,%esp
80103cfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cfe:	c9                   	leave  
80103cff:	c3                   	ret    

    p = allocproc();

    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
80103d00:	83 ec 0c             	sub    $0xc,%esp
80103d03:	68 8c 7e 10 80       	push   $0x80107e8c
80103d08:	e8 63 c6 ff ff       	call   80100370 <panic>
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi

80103d10 <growproc>:
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	56                   	push   %esi
80103d14:	53                   	push   %ebx
80103d15:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103d18:	e8 73 0c 00 00       	call   80104990 <pushcli>
    c = mycpu();
80103d1d:	e8 2e fe ff ff       	call   80103b50 <mycpu>
    p = c->proc;
80103d22:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103d28:	e8 53 0d 00 00       	call   80104a80 <popcli>
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();

    sz = curproc->sz;
    if (n > 0) {
80103d2d:	83 fe 00             	cmp    $0x0,%esi
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();

    sz = curproc->sz;
80103d30:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103d32:	7e 34                	jle    80103d68 <growproc+0x58>
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d34:	83 ec 04             	sub    $0x4,%esp
80103d37:	01 c6                	add    %eax,%esi
80103d39:	56                   	push   %esi
80103d3a:	50                   	push   %eax
80103d3b:	ff 73 04             	pushl  0x4(%ebx)
80103d3e:	e8 7d 35 00 00       	call   801072c0 <allocuvm>
80103d43:	83 c4 10             	add    $0x10,%esp
80103d46:	85 c0                	test   %eax,%eax
80103d48:	74 46                	je     80103d90 <growproc+0x80>
        curproc->pagesCounter +=(PGROUNDUP(n)/PGSIZE);
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n , 1)) == 0)
            return -1;
    }
    curproc->sz = sz;
    switchuvm(curproc);
80103d4a:	83 ec 0c             	sub    $0xc,%esp
    } else if (n < 0) {
        curproc->pagesCounter +=(PGROUNDUP(n)/PGSIZE);
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n , 1)) == 0)
            return -1;
    }
    curproc->sz = sz;
80103d4d:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103d4f:	53                   	push   %ebx
80103d50:	e8 9b 31 00 00       	call   80106ef0 <switchuvm>
    return 0;
80103d55:	83 c4 10             	add    $0x10,%esp
80103d58:	31 c0                	xor    %eax,%eax
}
80103d5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d5d:	5b                   	pop    %ebx
80103d5e:	5e                   	pop    %esi
80103d5f:	5d                   	pop    %ebp
80103d60:	c3                   	ret    
80103d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
80103d68:	74 e0                	je     80103d4a <growproc+0x3a>
        curproc->pagesCounter +=(PGROUNDUP(n)/PGSIZE);
80103d6a:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n , 1)) == 0)
80103d70:	01 c6                	add    %eax,%esi
    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
        curproc->pagesCounter +=(PGROUNDUP(n)/PGSIZE);
80103d72:	c1 fa 0c             	sar    $0xc,%edx
80103d75:	01 93 44 04 00 00    	add    %edx,0x444(%ebx)
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n , 1)) == 0)
80103d7b:	6a 01                	push   $0x1
80103d7d:	56                   	push   %esi
80103d7e:	50                   	push   %eax
80103d7f:	ff 73 04             	pushl  0x4(%ebx)
80103d82:	e8 e9 33 00 00       	call   80107170 <deallocuvm>
80103d87:	83 c4 10             	add    $0x10,%esp
80103d8a:	85 c0                	test   %eax,%eax
80103d8c:	75 bc                	jne    80103d4a <growproc+0x3a>
80103d8e:	66 90                	xchg   %ax,%ax
    struct proc *curproc = myproc();

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
80103d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d95:	eb c3                	jmp    80103d5a <growproc+0x4a>
80103d97:	89 f6                	mov    %esi,%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103da9:	e8 e2 0b 00 00       	call   80104990 <pushcli>
    c = mycpu();
80103dae:	e8 9d fd ff ff       	call   80103b50 <mycpu>
    p = c->proc;
80103db3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103db9:	e8 c2 0c 00 00       	call   80104a80 <popcli>
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();
    struct page *pg , *cg;
    // Allocate process.
    if ((np = allocproc()) == 0) {
80103dbe:	e8 ad fb ff ff       	call   80103970 <allocproc>
80103dc3:	85 c0                	test   %eax,%eax
80103dc5:	0f 84 80 02 00 00    	je     8010404b <fork+0x2ab>
        return -1;
    }


    if (firstRun) {
80103dcb:	8b 35 08 b0 10 80    	mov    0x8010b008,%esi
80103dd1:	89 c2                	mov    %eax,%edx
80103dd3:	85 f6                	test   %esi,%esi
80103dd5:	0f 85 45 02 00 00    	jne    80104020 <fork+0x280>
        createSwapFile(curproc);
    }


    createSwapFile(np);
80103ddb:	83 ec 0c             	sub    $0xc,%esp
80103dde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103de1:	52                   	push   %edx
80103de2:	e8 d9 e3 ff ff       	call   801021c0 <createSwapFile>

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103de7:	5a                   	pop    %edx
80103de8:	59                   	pop    %ecx
80103de9:	ff 33                	pushl  (%ebx)
80103deb:	ff 73 04             	pushl  0x4(%ebx)
80103dee:	e8 0d 39 00 00       	call   80107700 <copyuvm>
80103df3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103df6:	83 c4 10             	add    $0x10,%esp
80103df9:	85 c0                	test   %eax,%eax
80103dfb:	89 42 04             	mov    %eax,0x4(%edx)
80103dfe:	0f 84 4e 02 00 00    	je     80104052 <fork+0x2b2>
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103e04:	8b 03                	mov    (%ebx),%eax
    np->parent = curproc;
    *np->tf = *curproc->tf;
80103e06:	b9 13 00 00 00       	mov    $0x13,%ecx
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
    np->parent = curproc;
80103e0b:	89 5a 14             	mov    %ebx,0x14(%edx)
    *np->tf = *curproc->tf;
80103e0e:	8b 7a 18             	mov    0x18(%edx),%edi
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103e11:	89 02                	mov    %eax,(%edx)
    np->parent = curproc;
    *np->tf = *curproc->tf;
80103e13:	8b 73 18             	mov    0x18(%ebx),%esi
80103e16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    np->nextpageid = curproc->nextpageid;
80103e18:	8b 83 40 04 00 00    	mov    0x440(%ebx),%eax
80103e1e:	89 82 40 04 00 00    	mov    %eax,0x440(%edx)
    np->pagesCounter = curproc->pagesCounter;
80103e24:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
80103e2a:	89 82 44 04 00 00    	mov    %eax,0x444(%edx)
//    np->swapOffset = curproc->swapOffset;
    np->pagesequel = curproc->pagesequel;
80103e30:	8b 83 4c 04 00 00    	mov    0x44c(%ebx),%eax
80103e36:	89 82 4c 04 00 00    	mov    %eax,0x44c(%edx)
    np->pagesinSwap = curproc->pagesinSwap;
80103e3c:	8b 83 48 04 00 00    	mov    0x448(%ebx),%eax
80103e42:	89 82 48 04 00 00    	mov    %eax,0x448(%edx)

    //copy swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103e48:	31 c0                	xor    %eax,%eax
80103e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        np->swapFileEntries[k]=curproc->swapFileEntries[k];
80103e50:	8b 8c 83 00 04 00 00 	mov    0x400(%ebx,%eax,4),%ecx
80103e57:	89 8c 82 00 04 00 00 	mov    %ecx,0x400(%edx,%eax,4)
//    np->swapOffset = curproc->swapOffset;
    np->pagesequel = curproc->pagesequel;
    np->pagesinSwap = curproc->pagesinSwap;

    //copy swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103e5e:	83 c0 01             	add    $0x1,%eax
80103e61:	83 f8 10             	cmp    $0x10,%eax
80103e64:	75 ea                	jne    80103e50 <fork+0xb0>
        np->swapFileEntries[k]=curproc->swapFileEntries[k];

    //copy pages
    for( pg = np->pages , cg = curproc->pages;
80103e66:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
80103e6c:	8d 8b 80 00 00 00    	lea    0x80(%ebx),%ecx
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103e72:	8d ba 00 04 00 00    	lea    0x400(%edx),%edi
80103e78:	90                   	nop
80103e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    {
        pg->offset = cg->offset;
80103e80:	8b 71 10             	mov    0x10(%ecx),%esi
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        np->swapFileEntries[k]=curproc->swapFileEntries[k];

    //copy pages
    for( pg = np->pages , cg = curproc->pages;
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103e83:	83 c0 1c             	add    $0x1c,%eax
80103e86:	83 c1 1c             	add    $0x1c,%ecx
    {
        pg->offset = cg->offset;
80103e89:	89 70 f4             	mov    %esi,-0xc(%eax)
        pg->pageid = cg->pageid;
80103e8c:	8b 71 e8             	mov    -0x18(%ecx),%esi
80103e8f:	89 70 e8             	mov    %esi,-0x18(%eax)
        pg->present = cg->present;
80103e92:	8b 71 f0             	mov    -0x10(%ecx),%esi
80103e95:	89 70 f0             	mov    %esi,-0x10(%eax)
        pg->sequel = cg->sequel;
80103e98:	8b 71 ec             	mov    -0x14(%ecx),%esi
80103e9b:	89 70 ec             	mov    %esi,-0x14(%eax)
        pg->physAdress = cg->physAdress;
80103e9e:	8b 71 f8             	mov    -0x8(%ecx),%esi
80103ea1:	89 70 f8             	mov    %esi,-0x8(%eax)
        pg->virtAdress = cg->virtAdress;
80103ea4:	8b 71 fc             	mov    -0x4(%ecx),%esi
80103ea7:	89 70 fc             	mov    %esi,-0x4(%eax)
    //copy swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        np->swapFileEntries[k]=curproc->swapFileEntries[k];

    //copy pages
    for( pg = np->pages , cg = curproc->pages;
80103eaa:	39 f8                	cmp    %edi,%eax
80103eac:	72 d2                	jb     80103e80 <fork+0xe0>
        pg->physAdress = cg->physAdress;
        pg->virtAdress = cg->virtAdress;
    }

    //TODO FIRST RUN IN BEFORE SHEL LOADED
    if (!firstRun) {
80103eae:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80103eb3:	85 c0                	test   %eax,%eax
80103eb5:	0f 85 c5 00 00 00    	jne    80103f80 <fork+0x1e0>
        //TODO PAGECOUNTER-16= PAGES IN SWAP FILE
        for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80103ebb:	83 bb 44 04 00 00 10 	cmpl   $0x10,0x444(%ebx)
80103ec2:	0f 8e b8 00 00 00    	jle    80103f80 <fork+0x1e0>
80103ec8:	31 ff                	xor    %edi,%edi
80103eca:	eb 39                	jmp    80103f05 <fork+0x165>
80103ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                np->state = UNUSED;
                removeSwapFile(np); //clear swapFile
                return -1;
            }

            if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
80103ed0:	68 00 10 00 00       	push   $0x1000
80103ed5:	51                   	push   %ecx
80103ed6:	68 20 3d 11 80       	push   $0x80113d20
80103edb:	52                   	push   %edx
80103edc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103edf:	e8 7c e3 ff ff       	call   80102260 <writeToSwapFile>
80103ee4:	83 c4 10             	add    $0x10,%esp
80103ee7:	83 f8 ff             	cmp    $0xffffffff,%eax
80103eea:	89 c6                	mov    %eax,%esi
80103eec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103eef:	0f 84 4b 01 00 00    	je     80104040 <fork+0x2a0>
    }

    //TODO FIRST RUN IN BEFORE SHEL LOADED
    if (!firstRun) {
        //TODO PAGECOUNTER-16= PAGES IN SWAP FILE
        for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80103ef5:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
80103efb:	83 c7 01             	add    $0x1,%edi
80103efe:	83 e8 10             	sub    $0x10,%eax
80103f01:	39 f8                	cmp    %edi,%eax
80103f03:	7e 7b                	jle    80103f80 <fork+0x1e0>
        //while (sizeof(curproc->swapFile) >= k * PGSIZE) {
            memset(buffer, 0, PGSIZE);
80103f05:	83 ec 04             	sub    $0x4,%esp
80103f08:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103f0b:	68 00 10 00 00       	push   $0x1000
80103f10:	6a 00                	push   $0x0
80103f12:	68 20 3d 11 80       	push   $0x80113d20
80103f17:	e8 24 0c 00 00       	call   80104b40 <memset>
80103f1c:	89 f9                	mov    %edi,%ecx

            if (readFromSwapFile(curproc, buffer, k * PGSIZE, PGSIZE) == -1) {
80103f1e:	68 00 10 00 00       	push   $0x1000
80103f23:	c1 e1 0c             	shl    $0xc,%ecx
80103f26:	51                   	push   %ecx
80103f27:	68 20 3d 11 80       	push   $0x80113d20
80103f2c:	53                   	push   %ebx
80103f2d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103f30:	e8 5b e3 ff ff       	call   80102290 <readFromSwapFile>
80103f35:	83 c4 20             	add    $0x20,%esp
80103f38:	83 f8 ff             	cmp    $0xffffffff,%eax
80103f3b:	89 c6                	mov    %eax,%esi
80103f3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f40:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103f43:	75 8b                	jne    80103ed0 <fork+0x130>
                kfree(np->kstack);
80103f45:	83 ec 0c             	sub    $0xc,%esp
80103f48:	ff 72 08             	pushl  0x8(%edx)
80103f4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
                removeSwapFile(np); //clear swapFile
                return -1;
            }

            if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
                kfree(np->kstack);
80103f4e:	e8 4d e7 ff ff       	call   801026a0 <kfree>
                np->kstack = 0;
80103f53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f56:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
                np->state = UNUSED;
80103f5d:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
                removeSwapFile(np); //clear swapFile
80103f64:	89 14 24             	mov    %edx,(%esp)
80103f67:	e8 54 e0 ff ff       	call   80101fc0 <removeSwapFile>
                return -1;
80103f6c:	83 c4 10             	add    $0x10,%esp

    release(&ptable.lock);

    firstRun = 0;
    return pid;
}
80103f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f72:	89 f0                	mov    %esi,%eax
80103f74:	5b                   	pop    %ebx
80103f75:	5e                   	pop    %esi
80103f76:	5f                   	pop    %edi
80103f77:	5d                   	pop    %ebp
80103f78:	c3                   	ret    
80103f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
    }


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80103f80:	8b 42 18             	mov    0x18(%edx),%eax

    for (i = 0; i < NOFILE; i++)
80103f83:	31 f6                	xor    %esi,%esi
        }
    }


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80103f85:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
80103f90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f94:	85 c0                	test   %eax,%eax
80103f96:	74 16                	je     80103fae <fork+0x20e>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103f98:	83 ec 0c             	sub    $0xc,%esp
80103f9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103f9e:	50                   	push   %eax
80103f9f:	e8 5c ce ff ff       	call   80100e00 <filedup>
80103fa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fa7:	83 c4 10             	add    $0x10,%esp
80103faa:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103fae:	83 c6 01             	add    $0x1,%esi
80103fb1:	83 fe 10             	cmp    $0x10,%esi
80103fb4:	75 da                	jne    80103f90 <fork+0x1f0>
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103fb6:	83 ec 0c             	sub    $0xc,%esp
80103fb9:	ff 73 68             	pushl  0x68(%ebx)
80103fbc:	89 55 e4             	mov    %edx,-0x1c(%ebp)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103fbf:	83 c3 6c             	add    $0x6c,%ebx
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103fc2:	e8 99 d6 ff ff       	call   80101660 <idup>
80103fc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103fca:	83 c4 0c             	add    $0xc,%esp
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103fcd:	89 42 68             	mov    %eax,0x68(%edx)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103fd0:	8d 42 6c             	lea    0x6c(%edx),%eax
80103fd3:	6a 10                	push   $0x10
80103fd5:	53                   	push   %ebx
80103fd6:	50                   	push   %eax
80103fd7:	e8 64 0d 00 00       	call   80104d40 <safestrcpy>

    pid = np->pid;
80103fdc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fdf:	8b 72 10             	mov    0x10(%edx),%esi

    acquire(&ptable.lock);
80103fe2:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80103fe9:	e8 e2 09 00 00       	call   801049d0 <acquire>

    np->state = RUNNABLE;
80103fee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ff1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)

    release(&ptable.lock);
80103ff8:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80103fff:	e8 ec 0a 00 00       	call   80104af0 <release>

    firstRun = 0;
80104004:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
8010400b:	00 00 00 
    return pid;
8010400e:	83 c4 10             	add    $0x10,%esp
}
80104011:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104014:	89 f0                	mov    %esi,%eax
80104016:	5b                   	pop    %ebx
80104017:	5e                   	pop    %esi
80104018:	5f                   	pop    %edi
80104019:	5d                   	pop    %ebp
8010401a:	c3                   	ret    
8010401b:	90                   	nop
8010401c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
    }


    if (firstRun) {
        createSwapFile(curproc);
80104020:	83 ec 0c             	sub    $0xc,%esp
80104023:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104026:	53                   	push   %ebx
80104027:	e8 94 e1 ff ff       	call   801021c0 <createSwapFile>
8010402c:	83 c4 10             	add    $0x10,%esp
8010402f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104032:	e9 a4 fd ff ff       	jmp    80103ddb <fork+0x3b>
80104037:	89 f6                	mov    %esi,%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                removeSwapFile(np); //clear swapFile
                return -1;
            }

            if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
                kfree(np->kstack);
80104040:	83 ec 0c             	sub    $0xc,%esp
80104043:	ff 72 08             	pushl  0x8(%edx)
80104046:	e9 03 ff ff ff       	jmp    80103f4e <fork+0x1ae>
    struct proc *np;
    struct proc *curproc = myproc();
    struct page *pg , *cg;
    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
8010404b:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104050:	eb bf                	jmp    80104011 <fork+0x271>

    createSwapFile(np);

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
80104052:	83 ec 0c             	sub    $0xc,%esp
80104055:	ff 72 08             	pushl  0x8(%edx)
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
80104058:	be ff ff ff ff       	mov    $0xffffffff,%esi

    createSwapFile(np);

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
8010405d:	e8 3e e6 ff ff       	call   801026a0 <kfree>
        np->kstack = 0;
80104062:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        np->state = UNUSED;
        return -1;
80104065:	83 c4 10             	add    $0x10,%esp
    createSwapFile(np);

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
        np->kstack = 0;
80104068:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
        np->state = UNUSED;
8010406f:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
        return -1;
80104076:	eb 99                	jmp    80104011 <fork+0x271>
80104078:	90                   	nop
80104079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104080 <scheduler>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	83 ec 0c             	sub    $0xc,%esp
    struct proc *p;
    struct cpu *c = mycpu();
80104089:	e8 c2 fa ff ff       	call   80103b50 <mycpu>
8010408e:	8d 78 04             	lea    0x4(%eax),%edi
80104091:	89 c6                	mov    %eax,%esi
    c->proc = 0;
80104093:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010409a:	00 00 00 
8010409d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
801040a0:	fb                   	sti    
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
801040a1:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040a4:	bb 54 4d 11 80       	mov    $0x80114d54,%ebx
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
801040a9:	68 20 4d 11 80       	push   $0x80114d20
801040ae:	e8 1d 09 00 00       	call   801049d0 <acquire>
801040b3:	83 c4 10             	add    $0x10,%esp
801040b6:	eb 16                	jmp    801040ce <scheduler+0x4e>
801040b8:	90                   	nop
801040b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040c0:	81 c3 50 04 00 00    	add    $0x450,%ebx
801040c6:	81 fb 54 61 12 80    	cmp    $0x80126154,%ebx
801040cc:	74 52                	je     80104120 <scheduler+0xa0>
            if (p->state != RUNNABLE)
801040ce:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801040d2:	75 ec                	jne    801040c0 <scheduler+0x40>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
801040d4:	83 ec 0c             	sub    $0xc,%esp
                continue;

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
801040d7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
801040dd:	53                   	push   %ebx
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040de:	81 c3 50 04 00 00    	add    $0x450,%ebx

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
801040e4:	e8 07 2e 00 00       	call   80106ef0 <switchuvm>
            p->state = RUNNING;

            swtch(&(c->scheduler), p->context);
801040e9:	58                   	pop    %eax
801040ea:	5a                   	pop    %edx
801040eb:	ff b3 cc fb ff ff    	pushl  -0x434(%ebx)
801040f1:	57                   	push   %edi
            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
            p->state = RUNNING;
801040f2:	c7 83 bc fb ff ff 04 	movl   $0x4,-0x444(%ebx)
801040f9:	00 00 00 

            swtch(&(c->scheduler), p->context);
801040fc:	e8 9a 0c 00 00       	call   80104d9b <swtch>
            switchkvm();
80104101:	e8 ca 2d 00 00       	call   80106ed0 <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80104106:	83 c4 10             	add    $0x10,%esp
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104109:	81 fb 54 61 12 80    	cmp    $0x80126154,%ebx
            swtch(&(c->scheduler), p->context);
            switchkvm();

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
8010410f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104116:	00 00 00 
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104119:	75 b3                	jne    801040ce <scheduler+0x4e>
8010411b:	90                   	nop
8010411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&ptable.lock);
80104120:	83 ec 0c             	sub    $0xc,%esp
80104123:	68 20 4d 11 80       	push   $0x80114d20
80104128:	e8 c3 09 00 00       	call   80104af0 <release>

    }
8010412d:	83 c4 10             	add    $0x10,%esp
80104130:	e9 6b ff ff ff       	jmp    801040a0 <scheduler+0x20>
80104135:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104140 <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	56                   	push   %esi
80104144:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104145:	e8 46 08 00 00       	call   80104990 <pushcli>
    c = mycpu();
8010414a:	e8 01 fa ff ff       	call   80103b50 <mycpu>
    p = c->proc;
8010414f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104155:	e8 26 09 00 00       	call   80104a80 <popcli>
void
sched(void) {
    int intena;
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
8010415a:	83 ec 0c             	sub    $0xc,%esp
8010415d:	68 20 4d 11 80       	push   $0x80114d20
80104162:	e8 e9 07 00 00       	call   80104950 <holding>
80104167:	83 c4 10             	add    $0x10,%esp
8010416a:	85 c0                	test   %eax,%eax
8010416c:	74 4f                	je     801041bd <sched+0x7d>
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
8010416e:	e8 dd f9 ff ff       	call   80103b50 <mycpu>
80104173:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010417a:	75 68                	jne    801041e4 <sched+0xa4>
        panic("sched locks");
    if (p->state == RUNNING)
8010417c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104180:	74 55                	je     801041d7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104182:	9c                   	pushf  
80104183:	58                   	pop    %eax
        panic("sched running");
    if (readeflags() & FL_IF)
80104184:	f6 c4 02             	test   $0x2,%ah
80104187:	75 41                	jne    801041ca <sched+0x8a>
        panic("sched interruptible");
    intena = mycpu()->intena;
80104189:	e8 c2 f9 ff ff       	call   80103b50 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
8010418e:	83 c3 1c             	add    $0x1c,%ebx
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
80104191:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
80104197:	e8 b4 f9 ff ff       	call   80103b50 <mycpu>
8010419c:	83 ec 08             	sub    $0x8,%esp
8010419f:	ff 70 04             	pushl  0x4(%eax)
801041a2:	53                   	push   %ebx
801041a3:	e8 f3 0b 00 00       	call   80104d9b <swtch>
    mycpu()->intena = intena;
801041a8:	e8 a3 f9 ff ff       	call   80103b50 <mycpu>
}
801041ad:	83 c4 10             	add    $0x10,%esp
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
    swtch(&p->context, mycpu()->scheduler);
    mycpu()->intena = intena;
801041b0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801041b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041b9:	5b                   	pop    %ebx
801041ba:	5e                   	pop    %esi
801041bb:	5d                   	pop    %ebp
801041bc:	c3                   	ret    
sched(void) {
    int intena;
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
801041bd:	83 ec 0c             	sub    $0xc,%esp
801041c0:	68 b0 7e 10 80       	push   $0x80107eb0
801041c5:	e8 a6 c1 ff ff       	call   80100370 <panic>
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
801041ca:	83 ec 0c             	sub    $0xc,%esp
801041cd:	68 dc 7e 10 80       	push   $0x80107edc
801041d2:	e8 99 c1 ff ff       	call   80100370 <panic>
    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
801041d7:	83 ec 0c             	sub    $0xc,%esp
801041da:	68 ce 7e 10 80       	push   $0x80107ece
801041df:	e8 8c c1 ff ff       	call   80100370 <panic>
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
801041e4:	83 ec 0c             	sub    $0xc,%esp
801041e7:	68 c2 7e 10 80       	push   $0x80107ec2
801041ec:	e8 7f c1 ff ff       	call   80100370 <panic>
801041f1:	eb 0d                	jmp    80104200 <exit>
801041f3:	90                   	nop
801041f4:	90                   	nop
801041f5:	90                   	nop
801041f6:	90                   	nop
801041f7:	90                   	nop
801041f8:	90                   	nop
801041f9:	90                   	nop
801041fa:	90                   	nop
801041fb:	90                   	nop
801041fc:	90                   	nop
801041fd:	90                   	nop
801041fe:	90                   	nop
801041ff:	90                   	nop

80104200 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	57                   	push   %edi
80104204:	56                   	push   %esi
80104205:	53                   	push   %ebx
80104206:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104209:	e8 82 07 00 00       	call   80104990 <pushcli>
    c = mycpu();
8010420e:	e8 3d f9 ff ff       	call   80103b50 <mycpu>
    p = c->proc;
80104213:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104219:	e8 62 08 00 00       	call   80104a80 <popcli>
exit(void) {
    struct proc *curproc = myproc();
    struct proc *p;
    int fd;

    if (curproc == initproc)
8010421e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104224:	8d 5e 28             	lea    0x28(%esi),%ebx
80104227:	8d 7e 68             	lea    0x68(%esi),%edi
8010422a:	0f 84 12 01 00 00    	je     80104342 <exit+0x142>
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
80104230:	8b 03                	mov    (%ebx),%eax
80104232:	85 c0                	test   %eax,%eax
80104234:	74 12                	je     80104248 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104236:	83 ec 0c             	sub    $0xc,%esp
80104239:	50                   	push   %eax
8010423a:	e8 11 cc ff ff       	call   80100e50 <fileclose>
            curproc->ofile[fd] = 0;
8010423f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104245:	83 c4 10             	add    $0x10,%esp
80104248:	83 c3 04             	add    $0x4,%ebx

    if (curproc == initproc)
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
8010424b:	39 df                	cmp    %ebx,%edi
8010424d:	75 e1                	jne    80104230 <exit+0x30>
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }

    begin_op();
8010424f:	e8 bc ec ff ff       	call   80102f10 <begin_op>
    iput(curproc->cwd);
80104254:	83 ec 0c             	sub    $0xc,%esp
80104257:	ff 76 68             	pushl  0x68(%esi)
8010425a:	e8 61 d5 ff ff       	call   801017c0 <iput>
    end_op();
8010425f:	e8 1c ed ff ff       	call   80102f80 <end_op>
    curproc->cwd = 0;

    if (curproc->pid > 2)
80104264:	83 c4 10             	add    $0x10,%esp
80104267:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
    }

    begin_op();
    iput(curproc->cwd);
    end_op();
    curproc->cwd = 0;
8010426b:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

    if (curproc->pid > 2)
80104272:	0f 8f b9 00 00 00    	jg     80104331 <exit+0x131>
        removeSwapFile(curproc);

    acquire(&ptable.lock);
80104278:	83 ec 0c             	sub    $0xc,%esp
8010427b:	68 20 4d 11 80       	push   $0x80114d20
80104280:	e8 4b 07 00 00       	call   801049d0 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);
80104285:	8b 56 14             	mov    0x14(%esi),%edx
80104288:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010428b:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
80104290:	eb 12                	jmp    801042a4 <exit+0xa4>
80104292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104298:	05 50 04 00 00       	add    $0x450,%eax
8010429d:	3d 54 61 12 80       	cmp    $0x80126154,%eax
801042a2:	74 1e                	je     801042c2 <exit+0xc2>
        if (p->state == SLEEPING && p->chan == chan)
801042a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042a8:	75 ee                	jne    80104298 <exit+0x98>
801042aa:	3b 50 20             	cmp    0x20(%eax),%edx
801042ad:	75 e9                	jne    80104298 <exit+0x98>
            p->state = RUNNABLE;
801042af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042b6:	05 50 04 00 00       	add    $0x450,%eax
801042bb:	3d 54 61 12 80       	cmp    $0x80126154,%eax
801042c0:	75 e2                	jne    801042a4 <exit+0xa4>
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
801042c2:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
801042c8:	ba 54 4d 11 80       	mov    $0x80114d54,%edx
801042cd:	eb 0f                	jmp    801042de <exit+0xde>
801042cf:	90                   	nop

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042d0:	81 c2 50 04 00 00    	add    $0x450,%edx
801042d6:	81 fa 54 61 12 80    	cmp    $0x80126154,%edx
801042dc:	74 3a                	je     80104318 <exit+0x118>
        if (p->parent == curproc) {
801042de:	39 72 14             	cmp    %esi,0x14(%edx)
801042e1:	75 ed                	jne    801042d0 <exit+0xd0>
            p->parent = initproc;
            if (p->state == ZOMBIE)
801042e3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
801042e7:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
801042ea:	75 e4                	jne    801042d0 <exit+0xd0>
801042ec:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
801042f1:	eb 11                	jmp    80104304 <exit+0x104>
801042f3:	90                   	nop
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f8:	05 50 04 00 00       	add    $0x450,%eax
801042fd:	3d 54 61 12 80       	cmp    $0x80126154,%eax
80104302:	74 cc                	je     801042d0 <exit+0xd0>
        if (p->state == SLEEPING && p->chan == chan)
80104304:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104308:	75 ee                	jne    801042f8 <exit+0xf8>
8010430a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010430d:	75 e9                	jne    801042f8 <exit+0xf8>
            p->state = RUNNABLE;
8010430f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104316:	eb e0                	jmp    801042f8 <exit+0xf8>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;
80104318:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    sched();
8010431f:	e8 1c fe ff ff       	call   80104140 <sched>
    panic("zombie exit");
80104324:	83 ec 0c             	sub    $0xc,%esp
80104327:	68 fd 7e 10 80       	push   $0x80107efd
8010432c:	e8 3f c0 ff ff       	call   80100370 <panic>
    iput(curproc->cwd);
    end_op();
    curproc->cwd = 0;

    if (curproc->pid > 2)
        removeSwapFile(curproc);
80104331:	83 ec 0c             	sub    $0xc,%esp
80104334:	56                   	push   %esi
80104335:	e8 86 dc ff ff       	call   80101fc0 <removeSwapFile>
8010433a:	83 c4 10             	add    $0x10,%esp
8010433d:	e9 36 ff ff ff       	jmp    80104278 <exit+0x78>
    struct proc *curproc = myproc();
    struct proc *p;
    int fd;

    if (curproc == initproc)
        panic("init exiting");
80104342:	83 ec 0c             	sub    $0xc,%esp
80104345:	68 f0 7e 10 80       	push   $0x80107ef0
8010434a:	e8 21 c0 ff ff       	call   80100370 <panic>
8010434f:	90                   	nop

80104350 <yield>:
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104357:	68 20 4d 11 80       	push   $0x80114d20
8010435c:	e8 6f 06 00 00       	call   801049d0 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104361:	e8 2a 06 00 00       	call   80104990 <pushcli>
    c = mycpu();
80104366:	e8 e5 f7 ff ff       	call   80103b50 <mycpu>
    p = c->proc;
8010436b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104371:	e8 0a 07 00 00       	call   80104a80 <popcli>

// Give up the CPU for one scheduling round.
void
yield(void) {
    acquire(&ptable.lock);  //DOC: yieldlock
    myproc()->state = RUNNABLE;
80104376:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
8010437d:	e8 be fd ff ff       	call   80104140 <sched>
    release(&ptable.lock);
80104382:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80104389:	e8 62 07 00 00       	call   80104af0 <release>
}
8010438e:	83 c4 10             	add    $0x10,%esp
80104391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104394:	c9                   	leave  
80104395:	c3                   	ret    
80104396:	8d 76 00             	lea    0x0(%esi),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <sleep>:
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	83 ec 0c             	sub    $0xc,%esp
801043a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043ac:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801043af:	e8 dc 05 00 00       	call   80104990 <pushcli>
    c = mycpu();
801043b4:	e8 97 f7 ff ff       	call   80103b50 <mycpu>
    p = c->proc;
801043b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801043bf:	e8 bc 06 00 00       	call   80104a80 <popcli>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
    struct proc *p = myproc();

    if (p == 0)
801043c4:	85 db                	test   %ebx,%ebx
801043c6:	0f 84 87 00 00 00    	je     80104453 <sleep+0xb3>
        panic("sleep");

    if (lk == 0)
801043cc:	85 f6                	test   %esi,%esi
801043ce:	74 76                	je     80104446 <sleep+0xa6>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {  //DOC: sleeplock0
801043d0:	81 fe 20 4d 11 80    	cmp    $0x80114d20,%esi
801043d6:	74 50                	je     80104428 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 20 4d 11 80       	push   $0x80114d20
801043e0:	e8 eb 05 00 00       	call   801049d0 <acquire>
        release(lk);
801043e5:	89 34 24             	mov    %esi,(%esp)
801043e8:	e8 03 07 00 00       	call   80104af0 <release>
    }
    // Go to sleep.
    p->chan = chan;
801043ed:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
801043f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

    sched();
801043f7:	e8 44 fd ff ff       	call   80104140 <sched>

    // Tidy up.
    p->chan = 0;
801043fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
80104403:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
8010440a:	e8 e1 06 00 00       	call   80104af0 <release>
        acquire(lk);
8010440f:	89 75 08             	mov    %esi,0x8(%ebp)
80104412:	83 c4 10             	add    $0x10,%esp
    }
}
80104415:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104418:	5b                   	pop    %ebx
80104419:	5e                   	pop    %esi
8010441a:	5f                   	pop    %edi
8010441b:	5d                   	pop    %ebp
    p->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
8010441c:	e9 af 05 00 00       	jmp    801049d0 <acquire>
80104421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (lk != &ptable.lock) {  //DOC: sleeplock0
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }
    // Go to sleep.
    p->chan = chan;
80104428:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010442b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

    sched();
80104432:	e8 09 fd ff ff       	call   80104140 <sched>

    // Tidy up.
    p->chan = 0;
80104437:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}
8010443e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104441:	5b                   	pop    %ebx
80104442:	5e                   	pop    %esi
80104443:	5f                   	pop    %edi
80104444:	5d                   	pop    %ebp
80104445:	c3                   	ret    

    if (p == 0)
        panic("sleep");

    if (lk == 0)
        panic("sleep without lk");
80104446:	83 ec 0c             	sub    $0xc,%esp
80104449:	68 0f 7f 10 80       	push   $0x80107f0f
8010444e:	e8 1d bf ff ff       	call   80100370 <panic>
void
sleep(void *chan, struct spinlock *lk) {
    struct proc *p = myproc();

    if (p == 0)
        panic("sleep");
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 09 7f 10 80       	push   $0x80107f09
8010445b:	e8 10 bf ff ff       	call   80100370 <panic>

80104460 <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	53                   	push   %ebx
80104466:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104469:	e8 22 05 00 00       	call   80104990 <pushcli>
    c = mycpu();
8010446e:	e8 dd f6 ff ff       	call   80103b50 <mycpu>
    p = c->proc;
80104473:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104479:	e8 02 06 00 00       	call   80104a80 <popcli>
    struct proc *p;
    struct page *pg;
    int havekids, pid;
    struct proc *curproc = myproc();

    acquire(&ptable.lock);
8010447e:	83 ec 0c             	sub    $0xc,%esp
80104481:	68 20 4d 11 80       	push   $0x80114d20
80104486:	e8 45 05 00 00       	call   801049d0 <acquire>
8010448b:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
8010448e:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104490:	bb 54 4d 11 80       	mov    $0x80114d54,%ebx
80104495:	eb 17                	jmp    801044ae <wait+0x4e>
80104497:	89 f6                	mov    %esi,%esi
80104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801044a0:	81 c3 50 04 00 00    	add    $0x450,%ebx
801044a6:	81 fb 54 61 12 80    	cmp    $0x80126154,%ebx
801044ac:	74 22                	je     801044d0 <wait+0x70>
            if (p->parent != curproc)
801044ae:	39 73 14             	cmp    %esi,0x14(%ebx)
801044b1:	75 ed                	jne    801044a0 <wait+0x40>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
801044b3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044b7:	74 3d                	je     801044f6 <wait+0x96>

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044b9:	81 c3 50 04 00 00    	add    $0x450,%ebx
            if (p->parent != curproc)
                continue;
            havekids = 1;
801044bf:	b8 01 00 00 00       	mov    $0x1,%eax

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044c4:	81 fb 54 61 12 80    	cmp    $0x80126154,%ebx
801044ca:	75 e2                	jne    801044ae <wait+0x4e>
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
801044d0:	85 c0                	test   %eax,%eax
801044d2:	0f 84 0f 01 00 00    	je     801045e7 <wait+0x187>
801044d8:	8b 46 24             	mov    0x24(%esi),%eax
801044db:	85 c0                	test   %eax,%eax
801044dd:	0f 85 04 01 00 00    	jne    801045e7 <wait+0x187>
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801044e3:	83 ec 08             	sub    $0x8,%esp
801044e6:	68 20 4d 11 80       	push   $0x80114d20
801044eb:	56                   	push   %esi
801044ec:	e8 af fe ff ff       	call   801043a0 <sleep>
    }
801044f1:	83 c4 10             	add    $0x10,%esp
801044f4:	eb 98                	jmp    8010448e <wait+0x2e>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
801044f6:	83 ec 0c             	sub    $0xc,%esp
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
801044f9:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
801044fc:	ff 73 08             	pushl  0x8(%ebx)
801044ff:	e8 9c e1 ff ff       	call   801026a0 <kfree>
                p->kstack = 0;
80104504:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
8010450b:	5a                   	pop    %edx
8010450c:	ff 73 04             	pushl  0x4(%ebx)
8010450f:	e8 9c 30 00 00       	call   801075b0 <freevm>
80104514:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
8010451a:	8d 93 40 04 00 00    	lea    0x440(%ebx),%edx
                p->pid = 0;
80104520:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104527:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
8010452e:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
80104532:	83 c4 10             	add    $0x10,%esp
                p->killed = 0;
80104535:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
8010453c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80104543:	89 c8                	mov    %ecx,%eax
                p->pagesCounter = -1;
80104545:	c7 83 44 04 00 00 ff 	movl   $0xffffffff,0x444(%ebx)
8010454c:	ff ff ff 
                p->nextpageid = 0;
8010454f:	c7 83 40 04 00 00 00 	movl   $0x0,0x440(%ebx)
80104556:	00 00 00 
//                p->swapOffset = 0;
                p->pagesequel = 0;
                p->pagesinSwap = 0;
80104559:	89 cf                	mov    %ecx,%edi
                p->killed = 0;
                p->state = UNUSED;
                p->pagesCounter = -1;
                p->nextpageid = 0;
//                p->swapOffset = 0;
                p->pagesequel = 0;
8010455b:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
80104562:	00 00 00 
                p->pagesinSwap = 0;
80104565:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
8010456c:	00 00 00 
8010456f:	90                   	nop
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
                    p->swapFileEntries[k]=0;
80104570:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80104576:	83 c7 04             	add    $0x4,%edi
                p->nextpageid = 0;
//                p->swapOffset = 0;
                p->pagesequel = 0;
                p->pagesinSwap = 0;
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
80104579:	39 d7                	cmp    %edx,%edi
8010457b:	75 f3                	jne    80104570 <wait+0x110>
                    p->swapFileEntries[k]=0;

                //init proc's pages
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010457d:	83 eb 80             	sub    $0xffffff80,%ebx
                {
                    pg->active = 0;
80104580:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
                    pg->offset = 0;
80104586:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
                    p->swapFileEntries[k]=0;

                //init proc's pages
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010458d:	83 c3 1c             	add    $0x1c,%ebx
                {
                    pg->active = 0;
                    pg->offset = 0;
                    pg->pageid = 0;
80104590:	c7 43 e8 00 00 00 00 	movl   $0x0,-0x18(%ebx)
                    pg->present = -1;
80104597:	c7 43 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebx)
                    pg->sequel = -1;
8010459e:	c7 43 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebx)
                    pg->physAdress = 0;
801045a5:	c7 43 f8 00 00 00 00 	movl   $0x0,-0x8(%ebx)
                    pg->virtAdress = 0;
801045ac:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
                    p->swapFileEntries[k]=0;

                //init proc's pages
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801045b3:	39 d9                	cmp    %ebx,%ecx
801045b5:	77 c9                	ja     80104580 <wait+0x120>
801045b7:	89 f6                	mov    %esi,%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    pg->physAdress = 0;
                    pg->virtAdress = 0;
                }
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
                    p->swapFileEntries[k]=0;
801045c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801045c6:	83 c0 04             	add    $0x4,%eax
                    pg->sequel = -1;
                    pg->physAdress = 0;
                    pg->virtAdress = 0;
                }
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
801045c9:	39 d0                	cmp    %edx,%eax
801045cb:	75 f3                	jne    801045c0 <wait+0x160>
                    p->swapFileEntries[k]=0;

                release(&ptable.lock);
801045cd:	83 ec 0c             	sub    $0xc,%esp
801045d0:	68 20 4d 11 80       	push   $0x80114d20
801045d5:	e8 16 05 00 00       	call   80104af0 <release>
                return pid;
801045da:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801045dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
                    p->swapFileEntries[k]=0;

                release(&ptable.lock);
                return pid;
801045e0:	89 f0                	mov    %esi,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801045e2:	5b                   	pop    %ebx
801045e3:	5e                   	pop    %esi
801045e4:	5f                   	pop    %edi
801045e5:	5d                   	pop    %ebp
801045e6:	c3                   	ret    
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
801045e7:	83 ec 0c             	sub    $0xc,%esp
801045ea:	68 20 4d 11 80       	push   $0x80114d20
801045ef:	e8 fc 04 00 00       	call   80104af0 <release>
            return -1;
801045f4:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801045f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
            return -1;
801045fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801045ff:	5b                   	pop    %ebx
80104600:	5e                   	pop    %esi
80104601:	5f                   	pop    %edi
80104602:	5d                   	pop    %ebp
80104603:	c3                   	ret    
80104604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010460a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104610 <wakeup>:
            p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 10             	sub    $0x10,%esp
80104617:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010461a:	68 20 4d 11 80       	push   $0x80114d20
8010461f:	e8 ac 03 00 00       	call   801049d0 <acquire>
80104624:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104627:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
8010462c:	eb 0e                	jmp    8010463c <wakeup+0x2c>
8010462e:	66 90                	xchg   %ax,%ax
80104630:	05 50 04 00 00       	add    $0x450,%eax
80104635:	3d 54 61 12 80       	cmp    $0x80126154,%eax
8010463a:	74 1e                	je     8010465a <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan)
8010463c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104640:	75 ee                	jne    80104630 <wakeup+0x20>
80104642:	3b 58 20             	cmp    0x20(%eax),%ebx
80104645:	75 e9                	jne    80104630 <wakeup+0x20>
            p->state = RUNNABLE;
80104647:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010464e:	05 50 04 00 00       	add    $0x450,%eax
80104653:	3d 54 61 12 80       	cmp    $0x80126154,%eax
80104658:	75 e2                	jne    8010463c <wakeup+0x2c>
// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
8010465a:	c7 45 08 20 4d 11 80 	movl   $0x80114d20,0x8(%ebp)
}
80104661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104664:	c9                   	leave  
// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
80104665:	e9 86 04 00 00       	jmp    80104af0 <release>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104670 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	83 ec 10             	sub    $0x10,%esp
80104677:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
8010467a:	68 20 4d 11 80       	push   $0x80114d20
8010467f:	e8 4c 03 00 00       	call   801049d0 <acquire>
80104684:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104687:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
8010468c:	eb 0e                	jmp    8010469c <kill+0x2c>
8010468e:	66 90                	xchg   %ax,%ax
80104690:	05 50 04 00 00       	add    $0x450,%eax
80104695:	3d 54 61 12 80       	cmp    $0x80126154,%eax
8010469a:	74 3c                	je     801046d8 <kill+0x68>
        if (p->pid == pid) {
8010469c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010469f:	75 ef                	jne    80104690 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
801046a1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
    struct proc *p;

    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
801046a5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
801046ac:	74 1a                	je     801046c8 <kill+0x58>
                p->state = RUNNABLE;
            release(&ptable.lock);
801046ae:	83 ec 0c             	sub    $0xc,%esp
801046b1:	68 20 4d 11 80       	push   $0x80114d20
801046b6:	e8 35 04 00 00       	call   80104af0 <release>
            return 0;
801046bb:	83 c4 10             	add    $0x10,%esp
801046be:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801046c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c3:	c9                   	leave  
801046c4:	c3                   	ret    
801046c5:	8d 76 00             	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
                p->state = RUNNABLE;
801046c8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046cf:	eb dd                	jmp    801046ae <kill+0x3e>
801046d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	68 20 4d 11 80       	push   $0x80114d20
801046e0:	e8 0b 04 00 00       	call   80104af0 <release>
    return -1;
801046e5:	83 c4 10             	add    $0x10,%esp
801046e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f0:	c9                   	leave  
801046f1:	c3                   	ret    
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
80104705:	53                   	push   %ebx
80104706:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104709:	bb c0 4d 11 80       	mov    $0x80114dc0,%ebx
8010470e:	83 ec 3c             	sub    $0x3c,%esp
80104711:	eb 27                	jmp    8010473a <procdump+0x3a>
80104713:	90                   	nop
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104718:	83 ec 0c             	sub    $0xc,%esp
8010471b:	68 e3 82 10 80       	push   $0x801082e3
80104720:	e8 3b bf ff ff       	call   80100660 <cprintf>
80104725:	83 c4 10             	add    $0x10,%esp
80104728:	81 c3 50 04 00 00    	add    $0x450,%ebx
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010472e:	81 fb c0 61 12 80    	cmp    $0x801261c0,%ebx
80104734:	0f 84 7e 00 00 00    	je     801047b8 <procdump+0xb8>
        if (p->state == UNUSED)
8010473a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010473d:	85 c0                	test   %eax,%eax
8010473f:	74 e7                	je     80104728 <procdump+0x28>
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104741:	83 f8 05             	cmp    $0x5,%eax
            state = states[p->state];
        else
            state = "???";
80104744:	ba 20 7f 10 80       	mov    $0x80107f20,%edx
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104749:	77 11                	ja     8010475c <procdump+0x5c>
8010474b:	8b 14 85 80 7f 10 80 	mov    -0x7fef8080(,%eax,4),%edx
            state = states[p->state];
        else
            state = "???";
80104752:	b8 20 7f 10 80       	mov    $0x80107f20,%eax
80104757:	85 d2                	test   %edx,%edx
80104759:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
8010475c:	53                   	push   %ebx
8010475d:	52                   	push   %edx
8010475e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104761:	68 24 7f 10 80       	push   $0x80107f24
80104766:	e8 f5 be ff ff       	call   80100660 <cprintf>
        if (p->state == SLEEPING) {
8010476b:	83 c4 10             	add    $0x10,%esp
8010476e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104772:	75 a4                	jne    80104718 <procdump+0x18>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
80104774:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104777:	83 ec 08             	sub    $0x8,%esp
8010477a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010477d:	50                   	push   %eax
8010477e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104781:	8b 40 0c             	mov    0xc(%eax),%eax
80104784:	83 c0 08             	add    $0x8,%eax
80104787:	50                   	push   %eax
80104788:	e8 63 01 00 00       	call   801048f0 <getcallerpcs>
8010478d:	83 c4 10             	add    $0x10,%esp
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104790:	8b 17                	mov    (%edi),%edx
80104792:	85 d2                	test   %edx,%edx
80104794:	74 82                	je     80104718 <procdump+0x18>
                cprintf(" %p", pc[i]);
80104796:	83 ec 08             	sub    $0x8,%esp
80104799:	83 c7 04             	add    $0x4,%edi
8010479c:	52                   	push   %edx
8010479d:	68 21 79 10 80       	push   $0x80107921
801047a2:	e8 b9 be ff ff       	call   80100660 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
801047a7:	83 c4 10             	add    $0x10,%esp
801047aa:	39 f7                	cmp    %esi,%edi
801047ac:	75 e2                	jne    80104790 <procdump+0x90>
801047ae:	e9 65 ff ff ff       	jmp    80104718 <procdump+0x18>
801047b3:	90                   	nop
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
801047b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047bb:	5b                   	pop    %ebx
801047bc:	5e                   	pop    %esi
801047bd:	5f                   	pop    %edi
801047be:	5d                   	pop    %ebp
801047bf:	c3                   	ret    

801047c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	53                   	push   %ebx
801047c4:	83 ec 0c             	sub    $0xc,%esp
801047c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801047ca:	68 98 7f 10 80       	push   $0x80107f98
801047cf:	8d 43 04             	lea    0x4(%ebx),%eax
801047d2:	50                   	push   %eax
801047d3:	e8 f8 00 00 00       	call   801048d0 <initlock>
  lk->name = name;
801047d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801047db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801047e1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801047e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801047eb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801047ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f1:	c9                   	leave  
801047f2:	c3                   	ret    
801047f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	8d 73 04             	lea    0x4(%ebx),%esi
8010480e:	56                   	push   %esi
8010480f:	e8 bc 01 00 00       	call   801049d0 <acquire>
  while (lk->locked) {
80104814:	8b 13                	mov    (%ebx),%edx
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	85 d2                	test   %edx,%edx
8010481b:	74 16                	je     80104833 <acquiresleep+0x33>
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104820:	83 ec 08             	sub    $0x8,%esp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	e8 76 fb ff ff       	call   801043a0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010482a:	8b 03                	mov    (%ebx),%eax
8010482c:	83 c4 10             	add    $0x10,%esp
8010482f:	85 c0                	test   %eax,%eax
80104831:	75 ed                	jne    80104820 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104833:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104839:	e8 b2 f3 ff ff       	call   80103bf0 <myproc>
8010483e:	8b 40 10             	mov    0x10(%eax),%eax
80104841:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104844:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104847:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010484a:	5b                   	pop    %ebx
8010484b:	5e                   	pop    %esi
8010484c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010484d:	e9 9e 02 00 00       	jmp    80104af0 <release>
80104852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
80104865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	8d 73 04             	lea    0x4(%ebx),%esi
8010486e:	56                   	push   %esi
8010486f:	e8 5c 01 00 00       	call   801049d0 <acquire>
  lk->locked = 0;
80104874:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010487a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104881:	89 1c 24             	mov    %ebx,(%esp)
80104884:	e8 87 fd ff ff       	call   80104610 <wakeup>
  release(&lk->lk);
80104889:	89 75 08             	mov    %esi,0x8(%ebp)
8010488c:	83 c4 10             	add    $0x10,%esp
}
8010488f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104892:	5b                   	pop    %ebx
80104893:	5e                   	pop    %esi
80104894:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104895:	e9 56 02 00 00       	jmp    80104af0 <release>
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048a0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	8d 5e 04             	lea    0x4(%esi),%ebx
801048ae:	53                   	push   %ebx
801048af:	e8 1c 01 00 00       	call   801049d0 <acquire>
  r = lk->locked;
801048b4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801048b6:	89 1c 24             	mov    %ebx,(%esp)
801048b9:	e8 32 02 00 00       	call   80104af0 <release>
  return r;
}
801048be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048c1:	89 f0                	mov    %esi,%eax
801048c3:	5b                   	pop    %ebx
801048c4:	5e                   	pop    %esi
801048c5:	5d                   	pop    %ebp
801048c6:	c3                   	ret    
801048c7:	66 90                	xchg   %ax,%ax
801048c9:	66 90                	xchg   %ax,%ax
801048cb:	66 90                	xchg   %ax,%ax
801048cd:	66 90                	xchg   %ax,%ax
801048cf:	90                   	nop

801048d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801048d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801048d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801048df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801048e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	90                   	nop
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048f4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048fa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801048fd:	31 c0                	xor    %eax,%eax
801048ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104900:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104906:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010490c:	77 1a                	ja     80104928 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010490e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104911:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104914:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104917:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104919:	83 f8 0a             	cmp    $0xa,%eax
8010491c:	75 e2                	jne    80104900 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010491e:	5b                   	pop    %ebx
8010491f:	5d                   	pop    %ebp
80104920:	c3                   	ret    
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104928:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010492f:	83 c0 01             	add    $0x1,%eax
80104932:	83 f8 0a             	cmp    $0xa,%eax
80104935:	74 e7                	je     8010491e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104937:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010493e:	83 c0 01             	add    $0x1,%eax
80104941:	83 f8 0a             	cmp    $0xa,%eax
80104944:	75 e2                	jne    80104928 <getcallerpcs+0x38>
80104946:	eb d6                	jmp    8010491e <getcallerpcs+0x2e>
80104948:	90                   	nop
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104950 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 04             	sub    $0x4,%esp
80104957:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010495a:	8b 02                	mov    (%edx),%eax
8010495c:	85 c0                	test   %eax,%eax
8010495e:	75 10                	jne    80104970 <holding+0x20>
}
80104960:	83 c4 04             	add    $0x4,%esp
80104963:	31 c0                	xor    %eax,%eax
80104965:	5b                   	pop    %ebx
80104966:	5d                   	pop    %ebp
80104967:	c3                   	ret    
80104968:	90                   	nop
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104970:	8b 5a 08             	mov    0x8(%edx),%ebx
80104973:	e8 d8 f1 ff ff       	call   80103b50 <mycpu>
80104978:	39 c3                	cmp    %eax,%ebx
8010497a:	0f 94 c0             	sete   %al
}
8010497d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104980:	0f b6 c0             	movzbl %al,%eax
}
80104983:	5b                   	pop    %ebx
80104984:	5d                   	pop    %ebp
80104985:	c3                   	ret    
80104986:	8d 76 00             	lea    0x0(%esi),%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104990 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 04             	sub    $0x4,%esp
80104997:	9c                   	pushf  
80104998:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104999:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010499a:	e8 b1 f1 ff ff       	call   80103b50 <mycpu>
8010499f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049a5:	85 c0                	test   %eax,%eax
801049a7:	75 11                	jne    801049ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801049a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801049af:	e8 9c f1 ff ff       	call   80103b50 <mycpu>
801049b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801049ba:	e8 91 f1 ff ff       	call   80103b50 <mycpu>
801049bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049c6:	83 c4 04             	add    $0x4,%esp
801049c9:	5b                   	pop    %ebx
801049ca:	5d                   	pop    %ebp
801049cb:	c3                   	ret    
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049d0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801049d5:	e8 b6 ff ff ff       	call   80104990 <pushcli>
  if(holding(lk))
801049da:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801049dd:	8b 03                	mov    (%ebx),%eax
801049df:	85 c0                	test   %eax,%eax
801049e1:	75 7d                	jne    80104a60 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801049e3:	ba 01 00 00 00       	mov    $0x1,%edx
801049e8:	eb 09                	jmp    801049f3 <acquire+0x23>
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049f3:	89 d0                	mov    %edx,%eax
801049f5:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801049f8:	85 c0                	test   %eax,%eax
801049fa:	75 f4                	jne    801049f0 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801049fc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a04:	e8 47 f1 ff ff       	call   80103b50 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a09:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104a0b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a0e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a11:	31 c0                	xor    %eax,%eax
80104a13:	90                   	nop
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a18:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104a1e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a24:	77 1a                	ja     80104a40 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a26:	8b 5a 04             	mov    0x4(%edx),%ebx
80104a29:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a2c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104a2f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a31:	83 f8 0a             	cmp    $0xa,%eax
80104a34:	75 e2                	jne    80104a18 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104a36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a39:	5b                   	pop    %ebx
80104a3a:	5e                   	pop    %esi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104a40:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104a47:	83 c0 01             	add    $0x1,%eax
80104a4a:	83 f8 0a             	cmp    $0xa,%eax
80104a4d:	74 e7                	je     80104a36 <acquire+0x66>
    pcs[i] = 0;
80104a4f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104a56:	83 c0 01             	add    $0x1,%eax
80104a59:	83 f8 0a             	cmp    $0xa,%eax
80104a5c:	75 e2                	jne    80104a40 <acquire+0x70>
80104a5e:	eb d6                	jmp    80104a36 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104a60:	8b 73 08             	mov    0x8(%ebx),%esi
80104a63:	e8 e8 f0 ff ff       	call   80103b50 <mycpu>
80104a68:	39 c6                	cmp    %eax,%esi
80104a6a:	0f 85 73 ff ff ff    	jne    801049e3 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104a70:	83 ec 0c             	sub    $0xc,%esp
80104a73:	68 a3 7f 10 80       	push   $0x80107fa3
80104a78:	e8 f3 b8 ff ff       	call   80100370 <panic>
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi

80104a80 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a86:	9c                   	pushf  
80104a87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a88:	f6 c4 02             	test   $0x2,%ah
80104a8b:	75 52                	jne    80104adf <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a8d:	e8 be f0 ff ff       	call   80103b50 <mycpu>
80104a92:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104a98:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104a9b:	85 d2                	test   %edx,%edx
80104a9d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104aa3:	78 2d                	js     80104ad2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104aa5:	e8 a6 f0 ff ff       	call   80103b50 <mycpu>
80104aaa:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ab0:	85 d2                	test   %edx,%edx
80104ab2:	74 0c                	je     80104ac0 <popcli+0x40>
    sti();
}
80104ab4:	c9                   	leave  
80104ab5:	c3                   	ret    
80104ab6:	8d 76 00             	lea    0x0(%esi),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ac0:	e8 8b f0 ff ff       	call   80103b50 <mycpu>
80104ac5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104acb:	85 c0                	test   %eax,%eax
80104acd:	74 e5                	je     80104ab4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104acf:	fb                   	sti    
    sti();
}
80104ad0:	c9                   	leave  
80104ad1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104ad2:	83 ec 0c             	sub    $0xc,%esp
80104ad5:	68 c2 7f 10 80       	push   $0x80107fc2
80104ada:	e8 91 b8 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104adf:	83 ec 0c             	sub    $0xc,%esp
80104ae2:	68 ab 7f 10 80       	push   $0x80107fab
80104ae7:	e8 84 b8 ff ff       	call   80100370 <panic>
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104af0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104af8:	8b 03                	mov    (%ebx),%eax
80104afa:	85 c0                	test   %eax,%eax
80104afc:	75 12                	jne    80104b10 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104afe:	83 ec 0c             	sub    $0xc,%esp
80104b01:	68 c9 7f 10 80       	push   $0x80107fc9
80104b06:	e8 65 b8 ff ff       	call   80100370 <panic>
80104b0b:	90                   	nop
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104b10:	8b 73 08             	mov    0x8(%ebx),%esi
80104b13:	e8 38 f0 ff ff       	call   80103b50 <mycpu>
80104b18:	39 c6                	cmp    %eax,%esi
80104b1a:	75 e2                	jne    80104afe <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
80104b1c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b23:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104b2a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b2f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b38:	5b                   	pop    %ebx
80104b39:	5e                   	pop    %esi
80104b3a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104b3b:	e9 40 ff ff ff       	jmp    80104a80 <popcli>

80104b40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	53                   	push   %ebx
80104b45:	8b 55 08             	mov    0x8(%ebp),%edx
80104b48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b4b:	f6 c2 03             	test   $0x3,%dl
80104b4e:	75 05                	jne    80104b55 <memset+0x15>
80104b50:	f6 c1 03             	test   $0x3,%cl
80104b53:	74 13                	je     80104b68 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104b55:	89 d7                	mov    %edx,%edi
80104b57:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5a:	fc                   	cld    
80104b5b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b5d:	5b                   	pop    %ebx
80104b5e:	89 d0                	mov    %edx,%eax
80104b60:	5f                   	pop    %edi
80104b61:	5d                   	pop    %ebp
80104b62:	c3                   	ret    
80104b63:	90                   	nop
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104b68:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104b6c:	c1 e9 02             	shr    $0x2,%ecx
80104b6f:	89 fb                	mov    %edi,%ebx
80104b71:	89 f8                	mov    %edi,%eax
80104b73:	c1 e3 18             	shl    $0x18,%ebx
80104b76:	c1 e0 10             	shl    $0x10,%eax
80104b79:	09 d8                	or     %ebx,%eax
80104b7b:	09 f8                	or     %edi,%eax
80104b7d:	c1 e7 08             	shl    $0x8,%edi
80104b80:	09 f8                	or     %edi,%eax
80104b82:	89 d7                	mov    %edx,%edi
80104b84:	fc                   	cld    
80104b85:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b87:	5b                   	pop    %ebx
80104b88:	89 d0                	mov    %edx,%eax
80104b8a:	5f                   	pop    %edi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi

80104b90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
80104b95:	8b 45 10             	mov    0x10(%ebp),%eax
80104b98:	53                   	push   %ebx
80104b99:	8b 75 0c             	mov    0xc(%ebp),%esi
80104b9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b9f:	85 c0                	test   %eax,%eax
80104ba1:	74 29                	je     80104bcc <memcmp+0x3c>
    if(*s1 != *s2)
80104ba3:	0f b6 13             	movzbl (%ebx),%edx
80104ba6:	0f b6 0e             	movzbl (%esi),%ecx
80104ba9:	38 d1                	cmp    %dl,%cl
80104bab:	75 2b                	jne    80104bd8 <memcmp+0x48>
80104bad:	8d 78 ff             	lea    -0x1(%eax),%edi
80104bb0:	31 c0                	xor    %eax,%eax
80104bb2:	eb 14                	jmp    80104bc8 <memcmp+0x38>
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bb8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104bbd:	83 c0 01             	add    $0x1,%eax
80104bc0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104bc4:	38 ca                	cmp    %cl,%dl
80104bc6:	75 10                	jne    80104bd8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bc8:	39 f8                	cmp    %edi,%eax
80104bca:	75 ec                	jne    80104bb8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104bcc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104bcd:	31 c0                	xor    %eax,%eax
}
80104bcf:	5e                   	pop    %esi
80104bd0:	5f                   	pop    %edi
80104bd1:	5d                   	pop    %ebp
80104bd2:	c3                   	ret    
80104bd3:	90                   	nop
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104bd8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104bdb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104bdc:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104bde:	5e                   	pop    %esi
80104bdf:	5f                   	pop    %edi
80104be0:	5d                   	pop    %ebp
80104be1:	c3                   	ret    
80104be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf8:	8b 75 0c             	mov    0xc(%ebp),%esi
80104bfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104bfe:	39 c6                	cmp    %eax,%esi
80104c00:	73 2e                	jae    80104c30 <memmove+0x40>
80104c02:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104c05:	39 c8                	cmp    %ecx,%eax
80104c07:	73 27                	jae    80104c30 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104c09:	85 db                	test   %ebx,%ebx
80104c0b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104c0e:	74 17                	je     80104c27 <memmove+0x37>
      *--d = *--s;
80104c10:	29 d9                	sub    %ebx,%ecx
80104c12:	89 cb                	mov    %ecx,%ebx
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c18:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c1c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104c1f:	83 ea 01             	sub    $0x1,%edx
80104c22:	83 fa ff             	cmp    $0xffffffff,%edx
80104c25:	75 f1                	jne    80104c18 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c27:	5b                   	pop    %ebx
80104c28:	5e                   	pop    %esi
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    
80104c2b:	90                   	nop
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104c30:	31 d2                	xor    %edx,%edx
80104c32:	85 db                	test   %ebx,%ebx
80104c34:	74 f1                	je     80104c27 <memmove+0x37>
80104c36:	8d 76 00             	lea    0x0(%esi),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104c40:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104c44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104c47:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104c4a:	39 d3                	cmp    %edx,%ebx
80104c4c:	75 f2                	jne    80104c40 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104c4e:	5b                   	pop    %ebx
80104c4f:	5e                   	pop    %esi
80104c50:	5d                   	pop    %ebp
80104c51:	c3                   	ret    
80104c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104c63:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104c64:	eb 8a                	jmp    80104bf0 <memmove>
80104c66:	8d 76 00             	lea    0x0(%esi),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c78:	53                   	push   %ebx
80104c79:	8b 7d 08             	mov    0x8(%ebp),%edi
80104c7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104c7f:	85 c9                	test   %ecx,%ecx
80104c81:	74 37                	je     80104cba <strncmp+0x4a>
80104c83:	0f b6 17             	movzbl (%edi),%edx
80104c86:	0f b6 1e             	movzbl (%esi),%ebx
80104c89:	84 d2                	test   %dl,%dl
80104c8b:	74 3f                	je     80104ccc <strncmp+0x5c>
80104c8d:	38 d3                	cmp    %dl,%bl
80104c8f:	75 3b                	jne    80104ccc <strncmp+0x5c>
80104c91:	8d 47 01             	lea    0x1(%edi),%eax
80104c94:	01 cf                	add    %ecx,%edi
80104c96:	eb 1b                	jmp    80104cb3 <strncmp+0x43>
80104c98:	90                   	nop
80104c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ca0:	0f b6 10             	movzbl (%eax),%edx
80104ca3:	84 d2                	test   %dl,%dl
80104ca5:	74 21                	je     80104cc8 <strncmp+0x58>
80104ca7:	0f b6 19             	movzbl (%ecx),%ebx
80104caa:	83 c0 01             	add    $0x1,%eax
80104cad:	89 ce                	mov    %ecx,%esi
80104caf:	38 da                	cmp    %bl,%dl
80104cb1:	75 19                	jne    80104ccc <strncmp+0x5c>
80104cb3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104cb5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104cb8:	75 e6                	jne    80104ca0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104cba:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104cbb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104cbd:	5e                   	pop    %esi
80104cbe:	5f                   	pop    %edi
80104cbf:	5d                   	pop    %ebp
80104cc0:	c3                   	ret    
80104cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cc8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ccc:	0f b6 c2             	movzbl %dl,%eax
80104ccf:	29 d8                	sub    %ebx,%eax
}
80104cd1:	5b                   	pop    %ebx
80104cd2:	5e                   	pop    %esi
80104cd3:	5f                   	pop    %edi
80104cd4:	5d                   	pop    %ebp
80104cd5:	c3                   	ret    
80104cd6:	8d 76 00             	lea    0x0(%esi),%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
80104ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ceb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cee:	89 c2                	mov    %eax,%edx
80104cf0:	eb 19                	jmp    80104d0b <strncpy+0x2b>
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cf8:	83 c3 01             	add    $0x1,%ebx
80104cfb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104cff:	83 c2 01             	add    $0x1,%edx
80104d02:	84 c9                	test   %cl,%cl
80104d04:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d07:	74 09                	je     80104d12 <strncpy+0x32>
80104d09:	89 f1                	mov    %esi,%ecx
80104d0b:	85 c9                	test   %ecx,%ecx
80104d0d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104d10:	7f e6                	jg     80104cf8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d12:	31 c9                	xor    %ecx,%ecx
80104d14:	85 f6                	test   %esi,%esi
80104d16:	7e 17                	jle    80104d2f <strncpy+0x4f>
80104d18:	90                   	nop
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104d20:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104d24:	89 f3                	mov    %esi,%ebx
80104d26:	83 c1 01             	add    $0x1,%ecx
80104d29:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104d2b:	85 db                	test   %ebx,%ebx
80104d2d:	7f f1                	jg     80104d20 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104d2f:	5b                   	pop    %ebx
80104d30:	5e                   	pop    %esi
80104d31:	5d                   	pop    %ebp
80104d32:	c3                   	ret    
80104d33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d48:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104d4e:	85 c9                	test   %ecx,%ecx
80104d50:	7e 26                	jle    80104d78 <safestrcpy+0x38>
80104d52:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104d56:	89 c1                	mov    %eax,%ecx
80104d58:	eb 17                	jmp    80104d71 <safestrcpy+0x31>
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d60:	83 c2 01             	add    $0x1,%edx
80104d63:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104d67:	83 c1 01             	add    $0x1,%ecx
80104d6a:	84 db                	test   %bl,%bl
80104d6c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104d6f:	74 04                	je     80104d75 <safestrcpy+0x35>
80104d71:	39 f2                	cmp    %esi,%edx
80104d73:	75 eb                	jne    80104d60 <safestrcpy+0x20>
    ;
  *s = 0;
80104d75:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104d78:	5b                   	pop    %ebx
80104d79:	5e                   	pop    %esi
80104d7a:	5d                   	pop    %ebp
80104d7b:	c3                   	ret    
80104d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d80 <strlen>:

int
strlen(const char *s)
{
80104d80:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d81:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104d88:	80 3a 00             	cmpb   $0x0,(%edx)
80104d8b:	74 0c                	je     80104d99 <strlen+0x19>
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
80104d90:	83 c0 01             	add    $0x1,%eax
80104d93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d97:	75 f7                	jne    80104d90 <strlen+0x10>
    ;
  return n;
}
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    

80104d9b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d9b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d9f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104da3:	55                   	push   %ebp
  pushl %ebx
80104da4:	53                   	push   %ebx
  pushl %esi
80104da5:	56                   	push   %esi
  pushl %edi
80104da6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104da7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104da9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104dab:	5f                   	pop    %edi
  popl %esi
80104dac:	5e                   	pop    %esi
  popl %ebx
80104dad:	5b                   	pop    %ebx
  popl %ebp
80104dae:	5d                   	pop    %ebp
  ret
80104daf:	c3                   	ret    

80104db0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	53                   	push   %ebx
80104db4:	83 ec 04             	sub    $0x4,%esp
80104db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104dba:	e8 31 ee ff ff       	call   80103bf0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dbf:	8b 00                	mov    (%eax),%eax
80104dc1:	39 d8                	cmp    %ebx,%eax
80104dc3:	76 1b                	jbe    80104de0 <fetchint+0x30>
80104dc5:	8d 53 04             	lea    0x4(%ebx),%edx
80104dc8:	39 d0                	cmp    %edx,%eax
80104dca:	72 14                	jb     80104de0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dcf:	8b 13                	mov    (%ebx),%edx
80104dd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104dd3:	31 c0                	xor    %eax,%eax
}
80104dd5:	83 c4 04             	add    $0x4,%esp
80104dd8:	5b                   	pop    %ebx
80104dd9:	5d                   	pop    %ebp
80104dda:	c3                   	ret    
80104ddb:	90                   	nop
80104ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de5:	eb ee                	jmp    80104dd5 <fetchint+0x25>
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	53                   	push   %ebx
80104df4:	83 ec 04             	sub    $0x4,%esp
80104df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dfa:	e8 f1 ed ff ff       	call   80103bf0 <myproc>

  if(addr >= curproc->sz)
80104dff:	39 18                	cmp    %ebx,(%eax)
80104e01:	76 29                	jbe    80104e2c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104e06:	89 da                	mov    %ebx,%edx
80104e08:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104e0a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104e0c:	39 c3                	cmp    %eax,%ebx
80104e0e:	73 1c                	jae    80104e2c <fetchstr+0x3c>
    if(*s == 0)
80104e10:	80 3b 00             	cmpb   $0x0,(%ebx)
80104e13:	75 10                	jne    80104e25 <fetchstr+0x35>
80104e15:	eb 29                	jmp    80104e40 <fetchstr+0x50>
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e20:	80 3a 00             	cmpb   $0x0,(%edx)
80104e23:	74 1b                	je     80104e40 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104e25:	83 c2 01             	add    $0x1,%edx
80104e28:	39 d0                	cmp    %edx,%eax
80104e2a:	77 f4                	ja     80104e20 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104e2c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104e2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104e34:	5b                   	pop    %ebx
80104e35:	5d                   	pop    %ebp
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e40:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104e43:	89 d0                	mov    %edx,%eax
80104e45:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104e47:	5b                   	pop    %ebx
80104e48:	5d                   	pop    %ebp
80104e49:	c3                   	ret    
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e55:	e8 96 ed ff ff       	call   80103bf0 <myproc>
80104e5a:	8b 40 18             	mov    0x18(%eax),%eax
80104e5d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e60:	8b 40 44             	mov    0x44(%eax),%eax
80104e63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104e66:	e8 85 ed ff ff       	call   80103bf0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e6b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e6d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e70:	39 c6                	cmp    %eax,%esi
80104e72:	73 1c                	jae    80104e90 <argint+0x40>
80104e74:	8d 53 08             	lea    0x8(%ebx),%edx
80104e77:	39 d0                	cmp    %edx,%eax
80104e79:	72 15                	jb     80104e90 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e81:	89 10                	mov    %edx,(%eax)
  return 0;
80104e83:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104e85:	5b                   	pop    %ebx
80104e86:	5e                   	pop    %esi
80104e87:	5d                   	pop    %ebp
80104e88:	c3                   	ret    
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e95:	eb ee                	jmp    80104e85 <argint+0x35>
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	83 ec 10             	sub    $0x10,%esp
80104ea8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104eab:	e8 40 ed ff ff       	call   80103bf0 <myproc>
80104eb0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104eb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eb5:	83 ec 08             	sub    $0x8,%esp
80104eb8:	50                   	push   %eax
80104eb9:	ff 75 08             	pushl  0x8(%ebp)
80104ebc:	e8 8f ff ff ff       	call   80104e50 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ec1:	c1 e8 1f             	shr    $0x1f,%eax
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	84 c0                	test   %al,%al
80104ec9:	75 2d                	jne    80104ef8 <argptr+0x58>
80104ecb:	89 d8                	mov    %ebx,%eax
80104ecd:	c1 e8 1f             	shr    $0x1f,%eax
80104ed0:	84 c0                	test   %al,%al
80104ed2:	75 24                	jne    80104ef8 <argptr+0x58>
80104ed4:	8b 16                	mov    (%esi),%edx
80104ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed9:	39 c2                	cmp    %eax,%edx
80104edb:	76 1b                	jbe    80104ef8 <argptr+0x58>
80104edd:	01 c3                	add    %eax,%ebx
80104edf:	39 da                	cmp    %ebx,%edx
80104ee1:	72 15                	jb     80104ef8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ee6:	89 02                	mov    %eax,(%edx)
  return 0;
80104ee8:	31 c0                	xor    %eax,%eax
}
80104eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eed:	5b                   	pop    %ebx
80104eee:	5e                   	pop    %esi
80104eef:	5d                   	pop    %ebp
80104ef0:	c3                   	ret    
80104ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104efd:	eb eb                	jmp    80104eea <argptr+0x4a>
80104eff:	90                   	nop

80104f00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f09:	50                   	push   %eax
80104f0a:	ff 75 08             	pushl  0x8(%ebp)
80104f0d:	e8 3e ff ff ff       	call   80104e50 <argint>
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	85 c0                	test   %eax,%eax
80104f17:	78 17                	js     80104f30 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f19:	83 ec 08             	sub    $0x8,%esp
80104f1c:	ff 75 0c             	pushl  0xc(%ebp)
80104f1f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f22:	e8 c9 fe ff ff       	call   80104df0 <fetchstr>
80104f27:	83 c4 10             	add    $0x10,%esp
}
80104f2a:	c9                   	leave  
80104f2b:	c3                   	ret    
80104f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104f35:	c9                   	leave  
80104f36:	c3                   	ret    
80104f37:	89 f6                	mov    %esi,%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f40 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104f45:	e8 a6 ec ff ff       	call   80103bf0 <myproc>

  num = curproc->tf->eax;
80104f4a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104f4d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f4f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f52:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f55:	83 fa 15             	cmp    $0x15,%edx
80104f58:	77 1e                	ja     80104f78 <syscall+0x38>
80104f5a:	8b 14 85 00 80 10 80 	mov    -0x7fef8000(,%eax,4),%edx
80104f61:	85 d2                	test   %edx,%edx
80104f63:	74 13                	je     80104f78 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104f65:	ff d2                	call   *%edx
80104f67:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f6d:	5b                   	pop    %ebx
80104f6e:	5e                   	pop    %esi
80104f6f:	5d                   	pop    %ebp
80104f70:	c3                   	ret    
80104f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104f78:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f79:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104f7c:	50                   	push   %eax
80104f7d:	ff 73 10             	pushl  0x10(%ebx)
80104f80:	68 d1 7f 10 80       	push   $0x80107fd1
80104f85:	e8 d6 b6 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104f8a:	8b 43 18             	mov    0x18(%ebx),%eax
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104f97:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f9a:	5b                   	pop    %ebx
80104f9b:	5e                   	pop    %esi
80104f9c:	5d                   	pop    %ebp
80104f9d:	c3                   	ret    
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
80104fa5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104fa7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104faa:	89 d3                	mov    %edx,%ebx
80104fac:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104faf:	50                   	push   %eax
80104fb0:	6a 00                	push   $0x0
80104fb2:	e8 99 fe ff ff       	call   80104e50 <argint>
80104fb7:	83 c4 10             	add    $0x10,%esp
80104fba:	85 c0                	test   %eax,%eax
80104fbc:	78 32                	js     80104ff0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fbe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fc2:	77 2c                	ja     80104ff0 <argfd.constprop.0+0x50>
80104fc4:	e8 27 ec ff ff       	call   80103bf0 <myproc>
80104fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fcc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104fd0:	85 c0                	test   %eax,%eax
80104fd2:	74 1c                	je     80104ff0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104fd4:	85 f6                	test   %esi,%esi
80104fd6:	74 02                	je     80104fda <argfd.constprop.0+0x3a>
    *pfd = fd;
80104fd8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104fda:	85 db                	test   %ebx,%ebx
80104fdc:	74 22                	je     80105000 <argfd.constprop.0+0x60>
    *pf = f;
80104fde:	89 03                	mov    %eax,(%ebx)
  return 0;
80104fe0:	31 c0                	xor    %eax,%eax
}
80104fe2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fe5:	5b                   	pop    %ebx
80104fe6:	5e                   	pop    %esi
80104fe7:	5d                   	pop    %ebp
80104fe8:	c3                   	ret    
80104fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ff0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104ff8:	5b                   	pop    %ebx
80104ff9:	5e                   	pop    %esi
80104ffa:	5d                   	pop    %ebp
80104ffb:	c3                   	ret    
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105000:	31 c0                	xor    %eax,%eax
80105002:	eb de                	jmp    80104fe2 <argfd.constprop.0+0x42>
80105004:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010500a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
  return -1;
}

int
sys_dup(void)
{
80105013:	89 e5                	mov    %esp,%ebp
80105015:	56                   	push   %esi
80105016:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105017:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010501a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010501d:	e8 7e ff ff ff       	call   80104fa0 <argfd.constprop.0>
80105022:	85 c0                	test   %eax,%eax
80105024:	78 1a                	js     80105040 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105026:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105028:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010502b:	e8 c0 eb ff ff       	call   80103bf0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105030:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105034:	85 d2                	test   %edx,%edx
80105036:	74 18                	je     80105050 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105038:	83 c3 01             	add    $0x1,%ebx
8010503b:	83 fb 10             	cmp    $0x10,%ebx
8010503e:	75 f0                	jne    80105030 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105040:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105043:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105048:	5b                   	pop    %ebx
80105049:	5e                   	pop    %esi
8010504a:	5d                   	pop    %ebp
8010504b:	c3                   	ret    
8010504c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105050:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105054:	83 ec 0c             	sub    $0xc,%esp
80105057:	ff 75 f4             	pushl  -0xc(%ebp)
8010505a:	e8 a1 bd ff ff       	call   80100e00 <filedup>
  return fd;
8010505f:	83 c4 10             	add    $0x10,%esp
}
80105062:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105065:	89 d8                	mov    %ebx,%eax
}
80105067:	5b                   	pop    %ebx
80105068:	5e                   	pop    %esi
80105069:	5d                   	pop    %ebp
8010506a:	c3                   	ret    
8010506b:	90                   	nop
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105070 <sys_read>:

int
sys_read(void)
{
80105070:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105071:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105073:	89 e5                	mov    %esp,%ebp
80105075:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105078:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010507b:	e8 20 ff ff ff       	call   80104fa0 <argfd.constprop.0>
80105080:	85 c0                	test   %eax,%eax
80105082:	78 4c                	js     801050d0 <sys_read+0x60>
80105084:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105087:	83 ec 08             	sub    $0x8,%esp
8010508a:	50                   	push   %eax
8010508b:	6a 02                	push   $0x2
8010508d:	e8 be fd ff ff       	call   80104e50 <argint>
80105092:	83 c4 10             	add    $0x10,%esp
80105095:	85 c0                	test   %eax,%eax
80105097:	78 37                	js     801050d0 <sys_read+0x60>
80105099:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010509c:	83 ec 04             	sub    $0x4,%esp
8010509f:	ff 75 f0             	pushl  -0x10(%ebp)
801050a2:	50                   	push   %eax
801050a3:	6a 01                	push   $0x1
801050a5:	e8 f6 fd ff ff       	call   80104ea0 <argptr>
801050aa:	83 c4 10             	add    $0x10,%esp
801050ad:	85 c0                	test   %eax,%eax
801050af:	78 1f                	js     801050d0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801050b1:	83 ec 04             	sub    $0x4,%esp
801050b4:	ff 75 f0             	pushl  -0x10(%ebp)
801050b7:	ff 75 f4             	pushl  -0xc(%ebp)
801050ba:	ff 75 ec             	pushl  -0x14(%ebp)
801050bd:	e8 ae be ff ff       	call   80100f70 <fileread>
801050c2:	83 c4 10             	add    $0x10,%esp
}
801050c5:	c9                   	leave  
801050c6:	c3                   	ret    
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
801050d5:	c9                   	leave  
801050d6:	c3                   	ret    
801050d7:	89 f6                	mov    %esi,%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050e0 <sys_write>:

int
sys_write(void)
{
801050e0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050e1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
801050e3:	89 e5                	mov    %esp,%ebp
801050e5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050e8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050eb:	e8 b0 fe ff ff       	call   80104fa0 <argfd.constprop.0>
801050f0:	85 c0                	test   %eax,%eax
801050f2:	78 4c                	js     80105140 <sys_write+0x60>
801050f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050f7:	83 ec 08             	sub    $0x8,%esp
801050fa:	50                   	push   %eax
801050fb:	6a 02                	push   $0x2
801050fd:	e8 4e fd ff ff       	call   80104e50 <argint>
80105102:	83 c4 10             	add    $0x10,%esp
80105105:	85 c0                	test   %eax,%eax
80105107:	78 37                	js     80105140 <sys_write+0x60>
80105109:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010510c:	83 ec 04             	sub    $0x4,%esp
8010510f:	ff 75 f0             	pushl  -0x10(%ebp)
80105112:	50                   	push   %eax
80105113:	6a 01                	push   $0x1
80105115:	e8 86 fd ff ff       	call   80104ea0 <argptr>
8010511a:	83 c4 10             	add    $0x10,%esp
8010511d:	85 c0                	test   %eax,%eax
8010511f:	78 1f                	js     80105140 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105121:	83 ec 04             	sub    $0x4,%esp
80105124:	ff 75 f0             	pushl  -0x10(%ebp)
80105127:	ff 75 f4             	pushl  -0xc(%ebp)
8010512a:	ff 75 ec             	pushl  -0x14(%ebp)
8010512d:	e8 ce be ff ff       	call   80101000 <filewrite>
80105132:	83 c4 10             	add    $0x10,%esp
}
80105135:	c9                   	leave  
80105136:	c3                   	ret    
80105137:	89 f6                	mov    %esi,%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105145:	c9                   	leave  
80105146:	c3                   	ret    
80105147:	89 f6                	mov    %esi,%esi
80105149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105150 <sys_close>:

int
sys_close(void)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105156:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105159:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010515c:	e8 3f fe ff ff       	call   80104fa0 <argfd.constprop.0>
80105161:	85 c0                	test   %eax,%eax
80105163:	78 2b                	js     80105190 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105165:	e8 86 ea ff ff       	call   80103bf0 <myproc>
8010516a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010516d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105170:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105177:	00 
  fileclose(f);
80105178:	ff 75 f4             	pushl  -0xc(%ebp)
8010517b:	e8 d0 bc ff ff       	call   80100e50 <fileclose>
  return 0;
80105180:	83 c4 10             	add    $0x10,%esp
80105183:	31 c0                	xor    %eax,%eax
}
80105185:	c9                   	leave  
80105186:	c3                   	ret    
80105187:	89 f6                	mov    %esi,%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105195:	c9                   	leave  
80105196:	c3                   	ret    
80105197:	89 f6                	mov    %esi,%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051a0 <sys_fstat>:

int
sys_fstat(void)
{
801051a0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051a1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801051a3:	89 e5                	mov    %esp,%ebp
801051a5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051a8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801051ab:	e8 f0 fd ff ff       	call   80104fa0 <argfd.constprop.0>
801051b0:	85 c0                	test   %eax,%eax
801051b2:	78 2c                	js     801051e0 <sys_fstat+0x40>
801051b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051b7:	83 ec 04             	sub    $0x4,%esp
801051ba:	6a 14                	push   $0x14
801051bc:	50                   	push   %eax
801051bd:	6a 01                	push   $0x1
801051bf:	e8 dc fc ff ff       	call   80104ea0 <argptr>
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	85 c0                	test   %eax,%eax
801051c9:	78 15                	js     801051e0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801051cb:	83 ec 08             	sub    $0x8,%esp
801051ce:	ff 75 f4             	pushl  -0xc(%ebp)
801051d1:	ff 75 f0             	pushl  -0x10(%ebp)
801051d4:	e8 47 bd ff ff       	call   80100f20 <filestat>
801051d9:	83 c4 10             	add    $0x10,%esp
}
801051dc:	c9                   	leave  
801051dd:	c3                   	ret    
801051de:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
801051e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
801051e5:	c9                   	leave  
801051e6:	c3                   	ret    
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051f0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	57                   	push   %edi
801051f4:	56                   	push   %esi
801051f5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051f6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801051f9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051fc:	50                   	push   %eax
801051fd:	6a 00                	push   $0x0
801051ff:	e8 fc fc ff ff       	call   80104f00 <argstr>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
80105209:	0f 88 fb 00 00 00    	js     8010530a <sys_link+0x11a>
8010520f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105212:	83 ec 08             	sub    $0x8,%esp
80105215:	50                   	push   %eax
80105216:	6a 01                	push   $0x1
80105218:	e8 e3 fc ff ff       	call   80104f00 <argstr>
8010521d:	83 c4 10             	add    $0x10,%esp
80105220:	85 c0                	test   %eax,%eax
80105222:	0f 88 e2 00 00 00    	js     8010530a <sys_link+0x11a>
    return -1;

  begin_op();
80105228:	e8 e3 dc ff ff       	call   80102f10 <begin_op>
  if((ip = namei(old)) == 0){
8010522d:	83 ec 0c             	sub    $0xc,%esp
80105230:	ff 75 d4             	pushl  -0x2c(%ebp)
80105233:	e8 a8 cc ff ff       	call   80101ee0 <namei>
80105238:	83 c4 10             	add    $0x10,%esp
8010523b:	85 c0                	test   %eax,%eax
8010523d:	89 c3                	mov    %eax,%ebx
8010523f:	0f 84 f3 00 00 00    	je     80105338 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105245:	83 ec 0c             	sub    $0xc,%esp
80105248:	50                   	push   %eax
80105249:	e8 42 c4 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
8010524e:	83 c4 10             	add    $0x10,%esp
80105251:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105256:	0f 84 c4 00 00 00    	je     80105320 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010525c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105261:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105264:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105267:	53                   	push   %ebx
80105268:	e8 73 c3 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
8010526d:	89 1c 24             	mov    %ebx,(%esp)
80105270:	e8 fb c4 ff ff       	call   80101770 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105275:	58                   	pop    %eax
80105276:	5a                   	pop    %edx
80105277:	57                   	push   %edi
80105278:	ff 75 d0             	pushl  -0x30(%ebp)
8010527b:	e8 80 cc ff ff       	call   80101f00 <nameiparent>
80105280:	83 c4 10             	add    $0x10,%esp
80105283:	85 c0                	test   %eax,%eax
80105285:	89 c6                	mov    %eax,%esi
80105287:	74 5b                	je     801052e4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105289:	83 ec 0c             	sub    $0xc,%esp
8010528c:	50                   	push   %eax
8010528d:	e8 fe c3 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	8b 03                	mov    (%ebx),%eax
80105297:	39 06                	cmp    %eax,(%esi)
80105299:	75 3d                	jne    801052d8 <sys_link+0xe8>
8010529b:	83 ec 04             	sub    $0x4,%esp
8010529e:	ff 73 04             	pushl  0x4(%ebx)
801052a1:	57                   	push   %edi
801052a2:	56                   	push   %esi
801052a3:	e8 78 cb ff ff       	call   80101e20 <dirlink>
801052a8:	83 c4 10             	add    $0x10,%esp
801052ab:	85 c0                	test   %eax,%eax
801052ad:	78 29                	js     801052d8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801052af:	83 ec 0c             	sub    $0xc,%esp
801052b2:	56                   	push   %esi
801052b3:	e8 68 c6 ff ff       	call   80101920 <iunlockput>
  iput(ip);
801052b8:	89 1c 24             	mov    %ebx,(%esp)
801052bb:	e8 00 c5 ff ff       	call   801017c0 <iput>

  end_op();
801052c0:	e8 bb dc ff ff       	call   80102f80 <end_op>

  return 0;
801052c5:	83 c4 10             	add    $0x10,%esp
801052c8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801052ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052cd:	5b                   	pop    %ebx
801052ce:	5e                   	pop    %esi
801052cf:	5f                   	pop    %edi
801052d0:	5d                   	pop    %ebp
801052d1:	c3                   	ret    
801052d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
801052d8:	83 ec 0c             	sub    $0xc,%esp
801052db:	56                   	push   %esi
801052dc:	e8 3f c6 ff ff       	call   80101920 <iunlockput>
    goto bad;
801052e1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
801052e4:	83 ec 0c             	sub    $0xc,%esp
801052e7:	53                   	push   %ebx
801052e8:	e8 a3 c3 ff ff       	call   80101690 <ilock>
  ip->nlink--;
801052ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052f2:	89 1c 24             	mov    %ebx,(%esp)
801052f5:	e8 e6 c2 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
801052fa:	89 1c 24             	mov    %ebx,(%esp)
801052fd:	e8 1e c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105302:	e8 79 dc ff ff       	call   80102f80 <end_op>
  return -1;
80105307:	83 c4 10             	add    $0x10,%esp
}
8010530a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010530d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105312:	5b                   	pop    %ebx
80105313:	5e                   	pop    %esi
80105314:	5f                   	pop    %edi
80105315:	5d                   	pop    %ebp
80105316:	c3                   	ret    
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	53                   	push   %ebx
80105324:	e8 f7 c5 ff ff       	call   80101920 <iunlockput>
    end_op();
80105329:	e8 52 dc ff ff       	call   80102f80 <end_op>
    return -1;
8010532e:	83 c4 10             	add    $0x10,%esp
80105331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105336:	eb 92                	jmp    801052ca <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105338:	e8 43 dc ff ff       	call   80102f80 <end_op>
    return -1;
8010533d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105342:	eb 86                	jmp    801052ca <sys_link+0xda>
80105344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010534a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105350 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	57                   	push   %edi
80105354:	56                   	push   %esi
80105355:	53                   	push   %ebx
80105356:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105359:	bb 20 00 00 00       	mov    $0x20,%ebx
8010535e:	83 ec 1c             	sub    $0x1c,%esp
80105361:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105364:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105368:	77 0e                	ja     80105378 <isdirempty+0x28>
8010536a:	eb 34                	jmp    801053a0 <isdirempty+0x50>
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105370:	83 c3 10             	add    $0x10,%ebx
80105373:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105376:	76 28                	jbe    801053a0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105378:	6a 10                	push   $0x10
8010537a:	53                   	push   %ebx
8010537b:	57                   	push   %edi
8010537c:	56                   	push   %esi
8010537d:	e8 ee c5 ff ff       	call   80101970 <readi>
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

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
80105394:	31 c0                	xor    %eax,%eax
  }
  return 1;
}
80105396:	5b                   	pop    %ebx
80105397:	5e                   	pop    %esi
80105398:	5f                   	pop    %edi
80105399:	5d                   	pop    %ebp
8010539a:	c3                   	ret    
8010539b:	90                   	nop
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801053a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801053a8:	5b                   	pop    %ebx
801053a9:	5e                   	pop    %esi
801053aa:	5f                   	pop    %edi
801053ab:	5d                   	pop    %ebp
801053ac:	c3                   	ret    
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801053ad:	83 ec 0c             	sub    $0xc,%esp
801053b0:	68 5c 80 10 80       	push   $0x8010805c
801053b5:	e8 b6 af ff ff       	call   80100370 <panic>
801053ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053c0 <sys_unlink>:
}

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
}

//PAGEBREAK!
int
sys_unlink(void)
{
801053c9:	83 ec 44             	sub    $0x44,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801053cc:	50                   	push   %eax
801053cd:	6a 00                	push   $0x0
801053cf:	e8 2c fb ff ff       	call   80104f00 <argstr>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	0f 88 51 01 00 00    	js     80105530 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801053df:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
801053e2:	e8 29 db ff ff       	call   80102f10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053e7:	83 ec 08             	sub    $0x8,%esp
801053ea:	53                   	push   %ebx
801053eb:	ff 75 c0             	pushl  -0x40(%ebp)
801053ee:	e8 0d cb ff ff       	call   80101f00 <nameiparent>
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
80105404:	e8 87 c2 ff ff       	call   80101690 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105409:	58                   	pop    %eax
8010540a:	5a                   	pop    %edx
8010540b:	68 5d 7a 10 80       	push   $0x80107a5d
80105410:	53                   	push   %ebx
80105411:	e8 8a c7 ff ff       	call   80101ba0 <namecmp>
80105416:	83 c4 10             	add    $0x10,%esp
80105419:	85 c0                	test   %eax,%eax
8010541b:	0f 84 d3 00 00 00    	je     801054f4 <sys_unlink+0x134>
80105421:	83 ec 08             	sub    $0x8,%esp
80105424:	68 5c 7a 10 80       	push   $0x80107a5c
80105429:	53                   	push   %ebx
8010542a:	e8 71 c7 ff ff       	call   80101ba0 <namecmp>
8010542f:	83 c4 10             	add    $0x10,%esp
80105432:	85 c0                	test   %eax,%eax
80105434:	0f 84 ba 00 00 00    	je     801054f4 <sys_unlink+0x134>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010543a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010543d:	83 ec 04             	sub    $0x4,%esp
80105440:	50                   	push   %eax
80105441:	53                   	push   %ebx
80105442:	56                   	push   %esi
80105443:	e8 78 c7 ff ff       	call   80101bc0 <dirlookup>
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	85 c0                	test   %eax,%eax
8010544d:	89 c3                	mov    %eax,%ebx
8010544f:	0f 84 9f 00 00 00    	je     801054f4 <sys_unlink+0x134>
    goto bad;
  ilock(ip);
80105455:	83 ec 0c             	sub    $0xc,%esp
80105458:	50                   	push   %eax
80105459:	e8 32 c2 ff ff       	call   80101690 <ilock>

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
8010547e:	e8 bd f6 ff ff       	call   80104b40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105483:	6a 10                	push   $0x10
80105485:	ff 75 c4             	pushl  -0x3c(%ebp)
80105488:	57                   	push   %edi
80105489:	56                   	push   %esi
8010548a:	e8 e1 c5 ff ff       	call   80101a70 <writei>
8010548f:	83 c4 20             	add    $0x20,%esp
80105492:	83 f8 10             	cmp    $0x10,%eax
80105495:	0f 85 a8 00 00 00    	jne    80105543 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010549b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a0:	74 76                	je     80105518 <sys_unlink+0x158>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801054a2:	83 ec 0c             	sub    $0xc,%esp
801054a5:	56                   	push   %esi
801054a6:	e8 75 c4 ff ff       	call   80101920 <iunlockput>

  ip->nlink--;
801054ab:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054b0:	89 1c 24             	mov    %ebx,(%esp)
801054b3:	e8 28 c1 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
801054b8:	89 1c 24             	mov    %ebx,(%esp)
801054bb:	e8 60 c4 ff ff       	call   80101920 <iunlockput>

  end_op();
801054c0:	e8 bb da ff ff       	call   80102f80 <end_op>

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
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
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
801054ec:	e8 2f c4 ff ff       	call   80101920 <iunlockput>
    goto bad;
801054f1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
801054f4:	83 ec 0c             	sub    $0xc,%esp
801054f7:	56                   	push   %esi
801054f8:	e8 23 c4 ff ff       	call   80101920 <iunlockput>
  end_op();
801054fd:	e8 7e da ff ff       	call   80102f80 <end_op>
  return -1;
80105502:	83 c4 10             	add    $0x10,%esp
}
80105505:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010550d:	5b                   	pop    %ebx
8010550e:	5e                   	pop    %esi
8010550f:	5f                   	pop    %edi
80105510:	5d                   	pop    %ebp
80105511:	c3                   	ret    
80105512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105518:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
8010551d:	83 ec 0c             	sub    $0xc,%esp
80105520:	56                   	push   %esi
80105521:	e8 ba c0 ff ff       	call   801015e0 <iupdate>
80105526:	83 c4 10             	add    $0x10,%esp
80105529:	e9 74 ff ff ff       	jmp    801054a2 <sys_unlink+0xe2>
8010552e:	66 90                	xchg   %ax,%ax
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105535:	eb 93                	jmp    801054ca <sys_unlink+0x10a>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80105537:	e8 44 da ff ff       	call   80102f80 <end_op>
    return -1;
8010553c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105541:	eb 87                	jmp    801054ca <sys_unlink+0x10a>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105543:	83 ec 0c             	sub    $0xc,%esp
80105546:	68 71 7a 10 80       	push   $0x80107a71
8010554b:	e8 20 ae ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	68 5f 7a 10 80       	push   $0x80107a5f
80105558:	e8 13 ae ff ff       	call   80100370 <panic>
8010555d:	8d 76 00             	lea    0x0(%esi),%esi

80105560 <create>:
  return -1;
}

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
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105569:	83 ec 44             	sub    $0x44,%esp
8010556c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010556f:	8b 55 10             	mov    0x10(%ebp),%edx
80105572:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105575:	56                   	push   %esi
80105576:	ff 75 08             	pushl  0x8(%ebp)
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105579:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010557c:	89 55 c0             	mov    %edx,-0x40(%ebp)
8010557f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105582:	e8 79 c9 ff ff       	call   80101f00 <nameiparent>
80105587:	83 c4 10             	add    $0x10,%esp
8010558a:	85 c0                	test   %eax,%eax
8010558c:	0f 84 ee 00 00 00    	je     80105680 <create+0x120>
    return 0;
  ilock(dp);
80105592:	83 ec 0c             	sub    $0xc,%esp
80105595:	89 c7                	mov    %eax,%edi
80105597:	50                   	push   %eax
80105598:	e8 f3 c0 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010559d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801055a0:	83 c4 0c             	add    $0xc,%esp
801055a3:	50                   	push   %eax
801055a4:	56                   	push   %esi
801055a5:	57                   	push   %edi
801055a6:	e8 15 c6 ff ff       	call   80101bc0 <dirlookup>
801055ab:	83 c4 10             	add    $0x10,%esp
801055ae:	85 c0                	test   %eax,%eax
801055b0:	89 c3                	mov    %eax,%ebx
801055b2:	74 4c                	je     80105600 <create+0xa0>
    iunlockput(dp);
801055b4:	83 ec 0c             	sub    $0xc,%esp
801055b7:	57                   	push   %edi
801055b8:	e8 63 c3 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
801055bd:	89 1c 24             	mov    %ebx,(%esp)
801055c0:	e8 cb c0 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801055c5:	83 c4 10             	add    $0x10,%esp
801055c8:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801055cd:	75 11                	jne    801055e0 <create+0x80>
801055cf:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801055d4:	89 d8                	mov    %ebx,%eax
801055d6:	75 08                	jne    801055e0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801055d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055db:	5b                   	pop    %ebx
801055dc:	5e                   	pop    %esi
801055dd:	5f                   	pop    %edi
801055de:	5d                   	pop    %ebp
801055df:	c3                   	ret    
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	53                   	push   %ebx
801055e4:	e8 37 c3 ff ff       	call   80101920 <iunlockput>
    return 0;
801055e9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801055ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801055ef:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801055f1:	5b                   	pop    %ebx
801055f2:	5e                   	pop    %esi
801055f3:	5f                   	pop    %edi
801055f4:	5d                   	pop    %ebp
801055f5:	c3                   	ret    
801055f6:	8d 76 00             	lea    0x0(%esi),%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105600:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105604:	83 ec 08             	sub    $0x8,%esp
80105607:	50                   	push   %eax
80105608:	ff 37                	pushl  (%edi)
8010560a:	e8 11 bf ff ff       	call   80101520 <ialloc>
8010560f:	83 c4 10             	add    $0x10,%esp
80105612:	85 c0                	test   %eax,%eax
80105614:	89 c3                	mov    %eax,%ebx
80105616:	0f 84 cc 00 00 00    	je     801056e8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010561c:	83 ec 0c             	sub    $0xc,%esp
8010561f:	50                   	push   %eax
80105620:	e8 6b c0 ff ff       	call   80101690 <ilock>
  ip->major = major;
80105625:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105629:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010562d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105631:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105635:	b8 01 00 00 00       	mov    $0x1,%eax
8010563a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010563e:	89 1c 24             	mov    %ebx,(%esp)
80105641:	e8 9a bf ff ff       	call   801015e0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105646:	83 c4 10             	add    $0x10,%esp
80105649:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010564e:	74 40                	je     80105690 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105650:	83 ec 04             	sub    $0x4,%esp
80105653:	ff 73 04             	pushl  0x4(%ebx)
80105656:	56                   	push   %esi
80105657:	57                   	push   %edi
80105658:	e8 c3 c7 ff ff       	call   80101e20 <dirlink>
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	85 c0                	test   %eax,%eax
80105662:	78 77                	js     801056db <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105664:	83 ec 0c             	sub    $0xc,%esp
80105667:	57                   	push   %edi
80105668:	e8 b3 c2 ff ff       	call   80101920 <iunlockput>

  return ip;
8010566d:	83 c4 10             	add    $0x10,%esp
}
80105670:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80105673:	89 d8                	mov    %ebx,%eax
}
80105675:	5b                   	pop    %ebx
80105676:	5e                   	pop    %esi
80105677:	5f                   	pop    %edi
80105678:	5d                   	pop    %ebp
80105679:	c3                   	ret    
8010567a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105680:	31 c0                	xor    %eax,%eax
80105682:	e9 51 ff ff ff       	jmp    801055d8 <create+0x78>
80105687:	89 f6                	mov    %esi,%esi
80105689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105690:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105695:	83 ec 0c             	sub    $0xc,%esp
80105698:	57                   	push   %edi
80105699:	e8 42 bf ff ff       	call   801015e0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010569e:	83 c4 0c             	add    $0xc,%esp
801056a1:	ff 73 04             	pushl  0x4(%ebx)
801056a4:	68 5d 7a 10 80       	push   $0x80107a5d
801056a9:	53                   	push   %ebx
801056aa:	e8 71 c7 ff ff       	call   80101e20 <dirlink>
801056af:	83 c4 10             	add    $0x10,%esp
801056b2:	85 c0                	test   %eax,%eax
801056b4:	78 18                	js     801056ce <create+0x16e>
801056b6:	83 ec 04             	sub    $0x4,%esp
801056b9:	ff 77 04             	pushl  0x4(%edi)
801056bc:	68 5c 7a 10 80       	push   $0x80107a5c
801056c1:	53                   	push   %ebx
801056c2:	e8 59 c7 ff ff       	call   80101e20 <dirlink>
801056c7:	83 c4 10             	add    $0x10,%esp
801056ca:	85 c0                	test   %eax,%eax
801056cc:	79 82                	jns    80105650 <create+0xf0>
      panic("create dots");
801056ce:	83 ec 0c             	sub    $0xc,%esp
801056d1:	68 7d 80 10 80       	push   $0x8010807d
801056d6:	e8 95 ac ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801056db:	83 ec 0c             	sub    $0xc,%esp
801056de:	68 89 80 10 80       	push   $0x80108089
801056e3:	e8 88 ac ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801056e8:	83 ec 0c             	sub    $0xc,%esp
801056eb:	68 6e 80 10 80       	push   $0x8010806e
801056f0:	e8 7b ac ff ff       	call   80100370 <panic>
801056f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
80105705:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105706:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105709:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010570c:	50                   	push   %eax
8010570d:	6a 00                	push   $0x0
8010570f:	e8 ec f7 ff ff       	call   80104f00 <argstr>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	0f 88 9e 00 00 00    	js     801057bd <sys_open+0xbd>
8010571f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105722:	83 ec 08             	sub    $0x8,%esp
80105725:	50                   	push   %eax
80105726:	6a 01                	push   $0x1
80105728:	e8 23 f7 ff ff       	call   80104e50 <argint>
8010572d:	83 c4 10             	add    $0x10,%esp
80105730:	85 c0                	test   %eax,%eax
80105732:	0f 88 85 00 00 00    	js     801057bd <sys_open+0xbd>
    return -1;

  begin_op();
80105738:	e8 d3 d7 ff ff       	call   80102f10 <begin_op>

  if(omode & O_CREATE){
8010573d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105741:	0f 85 89 00 00 00    	jne    801057d0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105747:	83 ec 0c             	sub    $0xc,%esp
8010574a:	ff 75 e0             	pushl  -0x20(%ebp)
8010574d:	e8 8e c7 ff ff       	call   80101ee0 <namei>
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	85 c0                	test   %eax,%eax
80105757:	89 c6                	mov    %eax,%esi
80105759:	0f 84 88 00 00 00    	je     801057e7 <sys_open+0xe7>
      end_op();
      return -1;
    }
    ilock(ip);
8010575f:	83 ec 0c             	sub    $0xc,%esp
80105762:	50                   	push   %eax
80105763:	e8 28 bf ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105768:	83 c4 10             	add    $0x10,%esp
8010576b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105770:	0f 84 ca 00 00 00    	je     80105840 <sys_open+0x140>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105776:	e8 15 b6 ff ff       	call   80100d90 <filealloc>
8010577b:	85 c0                	test   %eax,%eax
8010577d:	89 c7                	mov    %eax,%edi
8010577f:	74 2b                	je     801057ac <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105781:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105783:	e8 68 e4 ff ff       	call   80103bf0 <myproc>
80105788:	90                   	nop
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105790:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105794:	85 d2                	test   %edx,%edx
80105796:	74 60                	je     801057f8 <sys_open+0xf8>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105798:	83 c3 01             	add    $0x1,%ebx
8010579b:	83 fb 10             	cmp    $0x10,%ebx
8010579e:	75 f0                	jne    80105790 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	57                   	push   %edi
801057a4:	e8 a7 b6 ff ff       	call   80100e50 <fileclose>
801057a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801057ac:	83 ec 0c             	sub    $0xc,%esp
801057af:	56                   	push   %esi
801057b0:	e8 6b c1 ff ff       	call   80101920 <iunlockput>
    end_op();
801057b5:	e8 c6 d7 ff ff       	call   80102f80 <end_op>
    return -1;
801057ba:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801057bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801057c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801057c5:	5b                   	pop    %ebx
801057c6:	5e                   	pop    %esi
801057c7:	5f                   	pop    %edi
801057c8:	5d                   	pop    %ebp
801057c9:	c3                   	ret    
801057ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801057d0:	6a 00                	push   $0x0
801057d2:	6a 00                	push   $0x0
801057d4:	6a 02                	push   $0x2
801057d6:	ff 75 e0             	pushl  -0x20(%ebp)
801057d9:	e8 82 fd ff ff       	call   80105560 <create>
    if(ip == 0){
801057de:	83 c4 10             	add    $0x10,%esp
801057e1:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801057e3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801057e5:	75 8f                	jne    80105776 <sys_open+0x76>
      end_op();
801057e7:	e8 94 d7 ff ff       	call   80102f80 <end_op>
      return -1;
801057ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f1:	eb 41                	jmp    80105834 <sys_open+0x134>
801057f3:	90                   	nop
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057f8:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801057fb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057ff:	56                   	push   %esi
80105800:	e8 6b bf ff ff       	call   80101770 <iunlock>
  end_op();
80105805:	e8 76 d7 ff ff       	call   80102f80 <end_op>

  f->type = FD_INODE;
8010580a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105810:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105813:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105816:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105819:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105820:	89 d0                	mov    %edx,%eax
80105822:	83 e0 01             	and    $0x1,%eax
80105825:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105828:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010582b:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010582e:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105832:	89 d8                	mov    %ebx,%eax
}
80105834:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105837:	5b                   	pop    %ebx
80105838:	5e                   	pop    %esi
80105839:	5f                   	pop    %edi
8010583a:	5d                   	pop    %ebp
8010583b:	c3                   	ret    
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105840:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105843:	85 c9                	test   %ecx,%ecx
80105845:	0f 84 2b ff ff ff    	je     80105776 <sys_open+0x76>
8010584b:	e9 5c ff ff ff       	jmp    801057ac <sys_open+0xac>

80105850 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105856:	e8 b5 d6 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010585b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010585e:	83 ec 08             	sub    $0x8,%esp
80105861:	50                   	push   %eax
80105862:	6a 00                	push   $0x0
80105864:	e8 97 f6 ff ff       	call   80104f00 <argstr>
80105869:	83 c4 10             	add    $0x10,%esp
8010586c:	85 c0                	test   %eax,%eax
8010586e:	78 30                	js     801058a0 <sys_mkdir+0x50>
80105870:	6a 00                	push   $0x0
80105872:	6a 00                	push   $0x0
80105874:	6a 01                	push   $0x1
80105876:	ff 75 f4             	pushl  -0xc(%ebp)
80105879:	e8 e2 fc ff ff       	call   80105560 <create>
8010587e:	83 c4 10             	add    $0x10,%esp
80105881:	85 c0                	test   %eax,%eax
80105883:	74 1b                	je     801058a0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105885:	83 ec 0c             	sub    $0xc,%esp
80105888:	50                   	push   %eax
80105889:	e8 92 c0 ff ff       	call   80101920 <iunlockput>
  end_op();
8010588e:	e8 ed d6 ff ff       	call   80102f80 <end_op>
  return 0;
80105893:	83 c4 10             	add    $0x10,%esp
80105896:	31 c0                	xor    %eax,%eax
}
80105898:	c9                   	leave  
80105899:	c3                   	ret    
8010589a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801058a0:	e8 db d6 ff ff       	call   80102f80 <end_op>
    return -1;
801058a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801058aa:	c9                   	leave  
801058ab:	c3                   	ret    
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_mknod>:

int
sys_mknod(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801058b6:	e8 55 d6 ff ff       	call   80102f10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801058bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058be:	83 ec 08             	sub    $0x8,%esp
801058c1:	50                   	push   %eax
801058c2:	6a 00                	push   $0x0
801058c4:	e8 37 f6 ff ff       	call   80104f00 <argstr>
801058c9:	83 c4 10             	add    $0x10,%esp
801058cc:	85 c0                	test   %eax,%eax
801058ce:	78 60                	js     80105930 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801058d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d3:	83 ec 08             	sub    $0x8,%esp
801058d6:	50                   	push   %eax
801058d7:	6a 01                	push   $0x1
801058d9:	e8 72 f5 ff ff       	call   80104e50 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801058de:	83 c4 10             	add    $0x10,%esp
801058e1:	85 c0                	test   %eax,%eax
801058e3:	78 4b                	js     80105930 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801058e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058e8:	83 ec 08             	sub    $0x8,%esp
801058eb:	50                   	push   %eax
801058ec:	6a 02                	push   $0x2
801058ee:	e8 5d f5 ff ff       	call   80104e50 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	78 36                	js     80105930 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801058fa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801058fe:	50                   	push   %eax
801058ff:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105903:	50                   	push   %eax
80105904:	6a 03                	push   $0x3
80105906:	ff 75 ec             	pushl  -0x14(%ebp)
80105909:	e8 52 fc ff ff       	call   80105560 <create>
8010590e:	83 c4 10             	add    $0x10,%esp
80105911:	85 c0                	test   %eax,%eax
80105913:	74 1b                	je     80105930 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105915:	83 ec 0c             	sub    $0xc,%esp
80105918:	50                   	push   %eax
80105919:	e8 02 c0 ff ff       	call   80101920 <iunlockput>
  end_op();
8010591e:	e8 5d d6 ff ff       	call   80102f80 <end_op>
  return 0;
80105923:	83 c4 10             	add    $0x10,%esp
80105926:	31 c0                	xor    %eax,%eax
}
80105928:	c9                   	leave  
80105929:	c3                   	ret    
8010592a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105930:	e8 4b d6 ff ff       	call   80102f80 <end_op>
    return -1;
80105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010593a:	c9                   	leave  
8010593b:	c3                   	ret    
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_chdir>:

int
sys_chdir(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	56                   	push   %esi
80105944:	53                   	push   %ebx
80105945:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105948:	e8 a3 e2 ff ff       	call   80103bf0 <myproc>
8010594d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010594f:	e8 bc d5 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105957:	83 ec 08             	sub    $0x8,%esp
8010595a:	50                   	push   %eax
8010595b:	6a 00                	push   $0x0
8010595d:	e8 9e f5 ff ff       	call   80104f00 <argstr>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	78 77                	js     801059e0 <sys_chdir+0xa0>
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	ff 75 f4             	pushl  -0xc(%ebp)
8010596f:	e8 6c c5 ff ff       	call   80101ee0 <namei>
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	85 c0                	test   %eax,%eax
80105979:	89 c3                	mov    %eax,%ebx
8010597b:	74 63                	je     801059e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010597d:	83 ec 0c             	sub    $0xc,%esp
80105980:	50                   	push   %eax
80105981:	e8 0a bd ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010598e:	75 30                	jne    801059c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	53                   	push   %ebx
80105994:	e8 d7 bd ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105999:	58                   	pop    %eax
8010599a:	ff 76 68             	pushl  0x68(%esi)
8010599d:	e8 1e be ff ff       	call   801017c0 <iput>
  end_op();
801059a2:	e8 d9 d5 ff ff       	call   80102f80 <end_op>
  curproc->cwd = ip;
801059a7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	31 c0                	xor    %eax,%eax
}
801059af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059b2:	5b                   	pop    %ebx
801059b3:	5e                   	pop    %esi
801059b4:	5d                   	pop    %ebp
801059b5:	c3                   	ret    
801059b6:	8d 76 00             	lea    0x0(%esi),%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	53                   	push   %ebx
801059c4:	e8 57 bf ff ff       	call   80101920 <iunlockput>
    end_op();
801059c9:	e8 b2 d5 ff ff       	call   80102f80 <end_op>
    return -1;
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d6:	eb d7                	jmp    801059af <sys_chdir+0x6f>
801059d8:	90                   	nop
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801059e0:	e8 9b d5 ff ff       	call   80102f80 <end_op>
    return -1;
801059e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ea:	eb c3                	jmp    801059af <sys_chdir+0x6f>
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059f6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801059fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a02:	50                   	push   %eax
80105a03:	6a 00                	push   $0x0
80105a05:	e8 f6 f4 ff ff       	call   80104f00 <argstr>
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	78 7f                	js     80105a90 <sys_exec+0xa0>
80105a11:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a17:	83 ec 08             	sub    $0x8,%esp
80105a1a:	50                   	push   %eax
80105a1b:	6a 01                	push   $0x1
80105a1d:	e8 2e f4 ff ff       	call   80104e50 <argint>
80105a22:	83 c4 10             	add    $0x10,%esp
80105a25:	85 c0                	test   %eax,%eax
80105a27:	78 67                	js     80105a90 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a29:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a2f:	83 ec 04             	sub    $0x4,%esp
80105a32:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105a38:	68 80 00 00 00       	push   $0x80
80105a3d:	6a 00                	push   $0x0
80105a3f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a45:	50                   	push   %eax
80105a46:	31 db                	xor    %ebx,%ebx
80105a48:	e8 f3 f0 ff ff       	call   80104b40 <memset>
80105a4d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a50:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a56:	83 ec 08             	sub    $0x8,%esp
80105a59:	57                   	push   %edi
80105a5a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105a5d:	50                   	push   %eax
80105a5e:	e8 4d f3 ff ff       	call   80104db0 <fetchint>
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 c0                	test   %eax,%eax
80105a68:	78 26                	js     80105a90 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105a6a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a70:	85 c0                	test   %eax,%eax
80105a72:	74 2c                	je     80105aa0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a74:	83 ec 08             	sub    $0x8,%esp
80105a77:	56                   	push   %esi
80105a78:	50                   	push   %eax
80105a79:	e8 72 f3 ff ff       	call   80104df0 <fetchstr>
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	78 0b                	js     80105a90 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105a85:	83 c3 01             	add    $0x1,%ebx
80105a88:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105a8b:	83 fb 20             	cmp    $0x20,%ebx
80105a8e:	75 c0                	jne    80105a50 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105a90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105a98:	5b                   	pop    %ebx
80105a99:	5e                   	pop    %esi
80105a9a:	5f                   	pop    %edi
80105a9b:	5d                   	pop    %ebp
80105a9c:	c3                   	ret    
80105a9d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105aa0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105aa6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105aa9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ab0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105ab4:	50                   	push   %eax
80105ab5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105abb:	e8 30 af ff ff       	call   801009f0 <exec>
80105ac0:	83 c4 10             	add    $0x10,%esp
}
80105ac3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ac6:	5b                   	pop    %ebx
80105ac7:	5e                   	pop    %esi
80105ac8:	5f                   	pop    %edi
80105ac9:	5d                   	pop    %ebp
80105aca:	c3                   	ret    
80105acb:	90                   	nop
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_pipe>:

int
sys_pipe(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	57                   	push   %edi
80105ad4:	56                   	push   %esi
80105ad5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ad6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105ad9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105adc:	6a 08                	push   $0x8
80105ade:	50                   	push   %eax
80105adf:	6a 00                	push   $0x0
80105ae1:	e8 ba f3 ff ff       	call   80104ea0 <argptr>
80105ae6:	83 c4 10             	add    $0x10,%esp
80105ae9:	85 c0                	test   %eax,%eax
80105aeb:	78 4a                	js     80105b37 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105aed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105af0:	83 ec 08             	sub    $0x8,%esp
80105af3:	50                   	push   %eax
80105af4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105af7:	50                   	push   %eax
80105af8:	e8 b3 da ff ff       	call   801035b0 <pipealloc>
80105afd:	83 c4 10             	add    $0x10,%esp
80105b00:	85 c0                	test   %eax,%eax
80105b02:	78 33                	js     80105b37 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b04:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b06:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105b09:	e8 e2 e0 ff ff       	call   80103bf0 <myproc>
80105b0e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105b10:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b14:	85 f6                	test   %esi,%esi
80105b16:	74 30                	je     80105b48 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b18:	83 c3 01             	add    $0x1,%ebx
80105b1b:	83 fb 10             	cmp    $0x10,%ebx
80105b1e:	75 f0                	jne    80105b10 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	ff 75 e0             	pushl  -0x20(%ebp)
80105b26:	e8 25 b3 ff ff       	call   80100e50 <fileclose>
    fileclose(wf);
80105b2b:	58                   	pop    %eax
80105b2c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b2f:	e8 1c b3 ff ff       	call   80100e50 <fileclose>
    return -1;
80105b34:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105b3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105b3f:	5b                   	pop    %ebx
80105b40:	5e                   	pop    %esi
80105b41:	5f                   	pop    %edi
80105b42:	5d                   	pop    %ebp
80105b43:	c3                   	ret    
80105b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105b48:	8d 73 08             	lea    0x8(%ebx),%esi
80105b4b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b4f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105b52:	e8 99 e0 ff ff       	call   80103bf0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105b57:	31 d2                	xor    %edx,%edx
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b60:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b64:	85 c9                	test   %ecx,%ecx
80105b66:	74 18                	je     80105b80 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b68:	83 c2 01             	add    $0x1,%edx
80105b6b:	83 fa 10             	cmp    $0x10,%edx
80105b6e:	75 f0                	jne    80105b60 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105b70:	e8 7b e0 ff ff       	call   80103bf0 <myproc>
80105b75:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b7c:	00 
80105b7d:	eb a1                	jmp    80105b20 <sys_pipe+0x50>
80105b7f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105b80:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105b84:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b87:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b89:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b8c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105b8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105b92:	31 c0                	xor    %eax,%eax
}
80105b94:	5b                   	pop    %ebx
80105b95:	5e                   	pop    %esi
80105b96:	5f                   	pop    %edi
80105b97:	5d                   	pop    %ebp
80105b98:	c3                   	ret    
80105b99:	66 90                	xchg   %ax,%ax
80105b9b:	66 90                	xchg   %ax,%ax
80105b9d:	66 90                	xchg   %ax,%ax
80105b9f:	90                   	nop

80105ba0 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105ba6:	e8 a5 e7 ff ff       	call   80104350 <yield>
  return 0;
}
80105bab:	31 c0                	xor    %eax,%eax
80105bad:	c9                   	leave  
80105bae:	c3                   	ret    
80105baf:	90                   	nop

80105bb0 <sys_fork>:

int
sys_fork(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105bb3:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105bb4:	e9 e7 e1 ff ff       	jmp    80103da0 <fork>
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <sys_exit>:
}

int
sys_exit(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105bc6:	e8 35 e6 ff ff       	call   80104200 <exit>
  return 0;  // not reached
}
80105bcb:	31 c0                	xor    %eax,%eax
80105bcd:	c9                   	leave  
80105bce:	c3                   	ret    
80105bcf:	90                   	nop

80105bd0 <sys_wait>:

int
sys_wait(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105bd3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105bd4:	e9 87 e8 ff ff       	jmp    80104460 <wait>
80105bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105be0 <sys_kill>:
}

int
sys_kill(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105be6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105be9:	50                   	push   %eax
80105bea:	6a 00                	push   $0x0
80105bec:	e8 5f f2 ff ff       	call   80104e50 <argint>
80105bf1:	83 c4 10             	add    $0x10,%esp
80105bf4:	85 c0                	test   %eax,%eax
80105bf6:	78 18                	js     80105c10 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105bf8:	83 ec 0c             	sub    $0xc,%esp
80105bfb:	ff 75 f4             	pushl  -0xc(%ebp)
80105bfe:	e8 6d ea ff ff       	call   80104670 <kill>
80105c03:	83 c4 10             	add    $0x10,%esp
}
80105c06:	c9                   	leave  
80105c07:	c3                   	ret    
80105c08:	90                   	nop
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105c15:	c9                   	leave  
80105c16:	c3                   	ret    
80105c17:	89 f6                	mov    %esi,%esi
80105c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c20 <sys_getpid>:

int
sys_getpid(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c26:	e8 c5 df ff ff       	call   80103bf0 <myproc>
80105c2b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c2e:	c9                   	leave  
80105c2f:	c3                   	ret    

80105c30 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105c37:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c3a:	50                   	push   %eax
80105c3b:	6a 00                	push   $0x0
80105c3d:	e8 0e f2 ff ff       	call   80104e50 <argint>
80105c42:	83 c4 10             	add    $0x10,%esp
80105c45:	85 c0                	test   %eax,%eax
80105c47:	78 27                	js     80105c70 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c49:	e8 a2 df ff ff       	call   80103bf0 <myproc>
  if(growproc(n) < 0)
80105c4e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105c51:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c53:	ff 75 f4             	pushl  -0xc(%ebp)
80105c56:	e8 b5 e0 ff ff       	call   80103d10 <growproc>
80105c5b:	83 c4 10             	add    $0x10,%esp
80105c5e:	85 c0                	test   %eax,%eax
80105c60:	78 0e                	js     80105c70 <sys_sbrk+0x40>
    return -1;
  return addr;
80105c62:	89 d8                	mov    %ebx,%eax
}
80105c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c67:	c9                   	leave  
80105c68:	c3                   	ret    
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c75:	eb ed                	jmp    80105c64 <sys_sbrk+0x34>
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c80 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105c87:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c8a:	50                   	push   %eax
80105c8b:	6a 00                	push   $0x0
80105c8d:	e8 be f1 ff ff       	call   80104e50 <argint>
80105c92:	83 c4 10             	add    $0x10,%esp
80105c95:	85 c0                	test   %eax,%eax
80105c97:	0f 88 8a 00 00 00    	js     80105d27 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c9d:	83 ec 0c             	sub    $0xc,%esp
80105ca0:	68 60 61 12 80       	push   $0x80126160
80105ca5:	e8 26 ed ff ff       	call   801049d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105caa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cad:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105cb0:	8b 1d a0 69 12 80    	mov    0x801269a0,%ebx
  while(ticks - ticks0 < n){
80105cb6:	85 d2                	test   %edx,%edx
80105cb8:	75 27                	jne    80105ce1 <sys_sleep+0x61>
80105cba:	eb 54                	jmp    80105d10 <sys_sleep+0x90>
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105cc0:	83 ec 08             	sub    $0x8,%esp
80105cc3:	68 60 61 12 80       	push   $0x80126160
80105cc8:	68 a0 69 12 80       	push   $0x801269a0
80105ccd:	e8 ce e6 ff ff       	call   801043a0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cd2:	a1 a0 69 12 80       	mov    0x801269a0,%eax
80105cd7:	83 c4 10             	add    $0x10,%esp
80105cda:	29 d8                	sub    %ebx,%eax
80105cdc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105cdf:	73 2f                	jae    80105d10 <sys_sleep+0x90>
    if(myproc()->killed){
80105ce1:	e8 0a df ff ff       	call   80103bf0 <myproc>
80105ce6:	8b 40 24             	mov    0x24(%eax),%eax
80105ce9:	85 c0                	test   %eax,%eax
80105ceb:	74 d3                	je     80105cc0 <sys_sleep+0x40>
      release(&tickslock);
80105ced:	83 ec 0c             	sub    $0xc,%esp
80105cf0:	68 60 61 12 80       	push   $0x80126160
80105cf5:	e8 f6 ed ff ff       	call   80104af0 <release>
      return -1;
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105d02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
80105d07:	89 f6                	mov    %esi,%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	68 60 61 12 80       	push   $0x80126160
80105d18:	e8 d3 ed ff ff       	call   80104af0 <release>
  return 0;
80105d1d:	83 c4 10             	add    $0x10,%esp
80105d20:	31 c0                	xor    %eax,%eax
}
80105d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d25:	c9                   	leave  
80105d26:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105d27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2c:	eb d4                	jmp    80105d02 <sys_sleep+0x82>
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	53                   	push   %ebx
80105d34:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d37:	68 60 61 12 80       	push   $0x80126160
80105d3c:	e8 8f ec ff ff       	call   801049d0 <acquire>
  xticks = ticks;
80105d41:	8b 1d a0 69 12 80    	mov    0x801269a0,%ebx
  release(&tickslock);
80105d47:	c7 04 24 60 61 12 80 	movl   $0x80126160,(%esp)
80105d4e:	e8 9d ed ff ff       	call   80104af0 <release>
  return xticks;
}
80105d53:	89 d8                	mov    %ebx,%eax
80105d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d58:	c9                   	leave  
80105d59:	c3                   	ret    

80105d5a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d5a:	1e                   	push   %ds
  pushl %es
80105d5b:	06                   	push   %es
  pushl %fs
80105d5c:	0f a0                	push   %fs
  pushl %gs
80105d5e:	0f a8                	push   %gs
  pushal
80105d60:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d61:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d65:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d67:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d69:	54                   	push   %esp
  call trap
80105d6a:	e8 e1 00 00 00       	call   80105e50 <trap>
  addl $4, %esp
80105d6f:	83 c4 04             	add    $0x4,%esp

80105d72 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d72:	61                   	popa   
  popl %gs
80105d73:	0f a9                	pop    %gs
  popl %fs
80105d75:	0f a1                	pop    %fs
  popl %es
80105d77:	07                   	pop    %es
  popl %ds
80105d78:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d79:	83 c4 08             	add    $0x8,%esp
  iret
80105d7c:	cf                   	iret   
80105d7d:	66 90                	xchg   %ax,%ax
80105d7f:	90                   	nop

80105d80 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105d80:	31 c0                	xor    %eax,%eax
80105d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d88:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105d8f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105d94:	c6 04 c5 a4 61 12 80 	movb   $0x0,-0x7fed9e5c(,%eax,8)
80105d9b:	00 
80105d9c:	66 89 0c c5 a2 61 12 	mov    %cx,-0x7fed9e5e(,%eax,8)
80105da3:	80 
80105da4:	c6 04 c5 a5 61 12 80 	movb   $0x8e,-0x7fed9e5b(,%eax,8)
80105dab:	8e 
80105dac:	66 89 14 c5 a0 61 12 	mov    %dx,-0x7fed9e60(,%eax,8)
80105db3:	80 
80105db4:	c1 ea 10             	shr    $0x10,%edx
80105db7:	66 89 14 c5 a6 61 12 	mov    %dx,-0x7fed9e5a(,%eax,8)
80105dbe:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105dbf:	83 c0 01             	add    $0x1,%eax
80105dc2:	3d 00 01 00 00       	cmp    $0x100,%eax
80105dc7:	75 bf                	jne    80105d88 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105dc9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dca:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105dcf:	89 e5                	mov    %esp,%ebp
80105dd1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dd4:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

  initlock(&tickslock, "time");
80105dd9:	68 99 80 10 80       	push   $0x80108099
80105dde:	68 60 61 12 80       	push   $0x80126160
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105de3:	66 89 15 a2 63 12 80 	mov    %dx,0x801263a2
80105dea:	c6 05 a4 63 12 80 00 	movb   $0x0,0x801263a4
80105df1:	66 a3 a0 63 12 80    	mov    %ax,0x801263a0
80105df7:	c1 e8 10             	shr    $0x10,%eax
80105dfa:	c6 05 a5 63 12 80 ef 	movb   $0xef,0x801263a5
80105e01:	66 a3 a6 63 12 80    	mov    %ax,0x801263a6

  initlock(&tickslock, "time");
80105e07:	e8 c4 ea ff ff       	call   801048d0 <initlock>
}
80105e0c:	83 c4 10             	add    $0x10,%esp
80105e0f:	c9                   	leave  
80105e10:	c3                   	ret    
80105e11:	eb 0d                	jmp    80105e20 <idtinit>
80105e13:	90                   	nop
80105e14:	90                   	nop
80105e15:	90                   	nop
80105e16:	90                   	nop
80105e17:	90                   	nop
80105e18:	90                   	nop
80105e19:	90                   	nop
80105e1a:	90                   	nop
80105e1b:	90                   	nop
80105e1c:	90                   	nop
80105e1d:	90                   	nop
80105e1e:	90                   	nop
80105e1f:	90                   	nop

80105e20 <idtinit>:

void
idtinit(void)
{
80105e20:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105e21:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e26:	89 e5                	mov    %esp,%ebp
80105e28:	83 ec 10             	sub    $0x10,%esp
80105e2b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e2f:	b8 a0 61 12 80       	mov    $0x801261a0,%eax
80105e34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e38:	c1 e8 10             	shr    $0x10,%eax
80105e3b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105e3f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e42:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e45:	c9                   	leave  
80105e46:	c3                   	ret    
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e50 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	57                   	push   %edi
80105e54:	56                   	push   %esi
80105e55:	53                   	push   %ebx
80105e56:	83 ec 1c             	sub    $0x1c,%esp
80105e59:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105e5c:	8b 47 30             	mov    0x30(%edi),%eax
80105e5f:	83 f8 40             	cmp    $0x40,%eax
80105e62:	0f 84 b8 01 00 00    	je     80106020 <trap+0x1d0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e68:	83 e8 0e             	sub    $0xe,%eax
80105e6b:	83 f8 31             	cmp    $0x31,%eax
80105e6e:	77 40                	ja     80105eb0 <trap+0x60>
80105e70:	ff 24 85 64 81 10 80 	jmp    *-0x7fef7e9c(,%eax,4)
80105e77:	89 f6                	mov    %esi,%esi
80105e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

    //TODO CASE TRAP 14 PGFLT IF IN SWITCH FILE: BRING FROM THERE, ELSE GO DEFAULT
  case T_PGFLT:
          cprintf( " FUCK %d pages %d swap %d overall " , myproc()->pagesCounter , myproc()->pagesinSwap , myproc()->nextpageid);
80105e80:	e8 6b dd ff ff       	call   80103bf0 <myproc>
80105e85:	8b b0 40 04 00 00    	mov    0x440(%eax),%esi
80105e8b:	e8 60 dd ff ff       	call   80103bf0 <myproc>
80105e90:	8b 98 48 04 00 00    	mov    0x448(%eax),%ebx
80105e96:	e8 55 dd ff ff       	call   80103bf0 <myproc>
80105e9b:	56                   	push   %esi
80105e9c:	53                   	push   %ebx
80105e9d:	ff b0 44 04 00 00    	pushl  0x444(%eax)
80105ea3:	68 c8 80 10 80       	push   $0x801080c8
80105ea8:	e8 b3 a7 ff ff       	call   80100660 <cprintf>
80105ead:	83 c4 10             	add    $0x10,%esp
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105eb0:	e8 3b dd ff ff       	call   80103bf0 <myproc>
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	0f 84 d7 01 00 00    	je     80106094 <trap+0x244>
80105ebd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105ec1:	0f 84 cd 01 00 00    	je     80106094 <trap+0x244>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ec7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eca:	8b 57 38             	mov    0x38(%edi),%edx
80105ecd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105ed0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105ed3:	e8 f8 dc ff ff       	call   80103bd0 <cpuid>
80105ed8:	8b 77 34             	mov    0x34(%edi),%esi
80105edb:	8b 5f 30             	mov    0x30(%edi),%ebx
80105ede:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105ee1:	e8 0a dd ff ff       	call   80103bf0 <myproc>
80105ee6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ee9:	e8 02 dd ff ff       	call   80103bf0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ef1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ef4:	51                   	push   %ecx
80105ef5:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105ef6:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ef9:	ff 75 e4             	pushl  -0x1c(%ebp)
80105efc:	56                   	push   %esi
80105efd:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105efe:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f01:	52                   	push   %edx
80105f02:	ff 70 10             	pushl  0x10(%eax)
80105f05:	68 20 81 10 80       	push   $0x80108120
80105f0a:	e8 51 a7 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105f0f:	83 c4 20             	add    $0x20,%esp
80105f12:	e8 d9 dc ff ff       	call   80103bf0 <myproc>
80105f17:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f1e:	e8 cd dc ff ff       	call   80103bf0 <myproc>
80105f23:	85 c0                	test   %eax,%eax
80105f25:	74 0c                	je     80105f33 <trap+0xe3>
80105f27:	e8 c4 dc ff ff       	call   80103bf0 <myproc>
80105f2c:	8b 50 24             	mov    0x24(%eax),%edx
80105f2f:	85 d2                	test   %edx,%edx
80105f31:	75 45                	jne    80105f78 <trap+0x128>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105f33:	e8 b8 dc ff ff       	call   80103bf0 <myproc>
80105f38:	85 c0                	test   %eax,%eax
80105f3a:	74 0b                	je     80105f47 <trap+0xf7>
80105f3c:	e8 af dc ff ff       	call   80103bf0 <myproc>
80105f41:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f45:	74 49                	je     80105f90 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f47:	e8 a4 dc ff ff       	call   80103bf0 <myproc>
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	74 1d                	je     80105f6d <trap+0x11d>
80105f50:	e8 9b dc ff ff       	call   80103bf0 <myproc>
80105f55:	8b 40 24             	mov    0x24(%eax),%eax
80105f58:	85 c0                	test   %eax,%eax
80105f5a:	74 11                	je     80105f6d <trap+0x11d>
80105f5c:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f60:	83 e0 03             	and    $0x3,%eax
80105f63:	66 83 f8 03          	cmp    $0x3,%ax
80105f67:	0f 84 dc 00 00 00    	je     80106049 <trap+0x1f9>
    exit();
}
80105f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f70:	5b                   	pop    %ebx
80105f71:	5e                   	pop    %esi
80105f72:	5f                   	pop    %edi
80105f73:	5d                   	pop    %ebp
80105f74:	c3                   	ret    
80105f75:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f78:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f7c:	83 e0 03             	and    $0x3,%eax
80105f7f:	66 83 f8 03          	cmp    $0x3,%ax
80105f83:	75 ae                	jne    80105f33 <trap+0xe3>
    exit();
80105f85:	e8 76 e2 ff ff       	call   80104200 <exit>
80105f8a:	eb a7                	jmp    80105f33 <trap+0xe3>
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105f90:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105f94:	75 b1                	jne    80105f47 <trap+0xf7>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105f96:	e8 b5 e3 ff ff       	call   80104350 <yield>
80105f9b:	eb aa                	jmp    80105f47 <trap+0xf7>
80105f9d:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105fa0:	e8 2b dc ff ff       	call   80103bd0 <cpuid>
80105fa5:	85 c0                	test   %eax,%eax
80105fa7:	0f 84 b3 00 00 00    	je     80106060 <trap+0x210>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105fad:	e8 1e cb ff ff       	call   80102ad0 <lapiceoi>
    break;
80105fb2:	e9 67 ff ff ff       	jmp    80105f1e <trap+0xce>
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105fc0:	e8 cb c9 ff ff       	call   80102990 <kbdintr>
    lapiceoi();
80105fc5:	e8 06 cb ff ff       	call   80102ad0 <lapiceoi>
    break;
80105fca:	e9 4f ff ff ff       	jmp    80105f1e <trap+0xce>
80105fcf:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105fd0:	e8 5b 02 00 00       	call   80106230 <uartintr>
    lapiceoi();
80105fd5:	e8 f6 ca ff ff       	call   80102ad0 <lapiceoi>
    break;
80105fda:	e9 3f ff ff ff       	jmp    80105f1e <trap+0xce>
80105fdf:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105fe0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105fe4:	8b 77 38             	mov    0x38(%edi),%esi
80105fe7:	e8 e4 db ff ff       	call   80103bd0 <cpuid>
80105fec:	56                   	push   %esi
80105fed:	53                   	push   %ebx
80105fee:	50                   	push   %eax
80105fef:	68 a4 80 10 80       	push   $0x801080a4
80105ff4:	e8 67 a6 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105ff9:	e8 d2 ca ff ff       	call   80102ad0 <lapiceoi>
    break;
80105ffe:	83 c4 10             	add    $0x10,%esp
80106001:	e9 18 ff ff ff       	jmp    80105f1e <trap+0xce>
80106006:	8d 76 00             	lea    0x0(%esi),%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106010:	e8 fb c3 ff ff       	call   80102410 <ideintr>
80106015:	eb 96                	jmp    80105fad <trap+0x15d>
80106017:	89 f6                	mov    %esi,%esi
80106019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106020:	e8 cb db ff ff       	call   80103bf0 <myproc>
80106025:	8b 58 24             	mov    0x24(%eax),%ebx
80106028:	85 db                	test   %ebx,%ebx
8010602a:	75 2c                	jne    80106058 <trap+0x208>
      exit();
    myproc()->tf = tf;
8010602c:	e8 bf db ff ff       	call   80103bf0 <myproc>
80106031:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106034:	e8 07 ef ff ff       	call   80104f40 <syscall>
    if(myproc()->killed)
80106039:	e8 b2 db ff ff       	call   80103bf0 <myproc>
8010603e:	8b 48 24             	mov    0x24(%eax),%ecx
80106041:	85 c9                	test   %ecx,%ecx
80106043:	0f 84 24 ff ff ff    	je     80105f6d <trap+0x11d>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106049:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010604c:	5b                   	pop    %ebx
8010604d:	5e                   	pop    %esi
8010604e:	5f                   	pop    %edi
8010604f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106050:	e9 ab e1 ff ff       	jmp    80104200 <exit>
80106055:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106058:	e8 a3 e1 ff ff       	call   80104200 <exit>
8010605d:	eb cd                	jmp    8010602c <trap+0x1dc>
8010605f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106060:	83 ec 0c             	sub    $0xc,%esp
80106063:	68 60 61 12 80       	push   $0x80126160
80106068:	e8 63 e9 ff ff       	call   801049d0 <acquire>
      ticks++;
      wakeup(&ticks);
8010606d:	c7 04 24 a0 69 12 80 	movl   $0x801269a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80106074:	83 05 a0 69 12 80 01 	addl   $0x1,0x801269a0
      wakeup(&ticks);
8010607b:	e8 90 e5 ff ff       	call   80104610 <wakeup>
      release(&tickslock);
80106080:	c7 04 24 60 61 12 80 	movl   $0x80126160,(%esp)
80106087:	e8 64 ea ff ff       	call   80104af0 <release>
8010608c:	83 c4 10             	add    $0x10,%esp
8010608f:	e9 19 ff ff ff       	jmp    80105fad <trap+0x15d>
80106094:	0f 20 d6             	mov    %cr2,%esi
          cprintf( " FUCK %d pages %d swap %d overall " , myproc()->pagesCounter , myproc()->pagesinSwap , myproc()->nextpageid);
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106097:	8b 5f 38             	mov    0x38(%edi),%ebx
8010609a:	e8 31 db ff ff       	call   80103bd0 <cpuid>
8010609f:	83 ec 0c             	sub    $0xc,%esp
801060a2:	56                   	push   %esi
801060a3:	53                   	push   %ebx
801060a4:	50                   	push   %eax
801060a5:	ff 77 30             	pushl  0x30(%edi)
801060a8:	68 ec 80 10 80       	push   $0x801080ec
801060ad:	e8 ae a5 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801060b2:	83 c4 14             	add    $0x14,%esp
801060b5:	68 9e 80 10 80       	push   $0x8010809e
801060ba:	e8 b1 a2 ff ff       	call   80100370 <panic>
801060bf:	90                   	nop

801060c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060c0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801060c5:	55                   	push   %ebp
801060c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060c8:	85 c0                	test   %eax,%eax
801060ca:	74 1c                	je     801060e8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060cc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060d1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801060d2:	a8 01                	test   $0x1,%al
801060d4:	74 12                	je     801060e8 <uartgetc+0x28>
801060d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060db:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060dc:	0f b6 c0             	movzbl %al,%eax
}
801060df:	5d                   	pop    %ebp
801060e0:	c3                   	ret    
801060e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801060e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801060ed:	5d                   	pop    %ebp
801060ee:	c3                   	ret    
801060ef:	90                   	nop

801060f0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	57                   	push   %edi
801060f4:	56                   	push   %esi
801060f5:	53                   	push   %ebx
801060f6:	89 c7                	mov    %eax,%edi
801060f8:	bb 80 00 00 00       	mov    $0x80,%ebx
801060fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106102:	83 ec 0c             	sub    $0xc,%esp
80106105:	eb 1b                	jmp    80106122 <uartputc.part.0+0x32>
80106107:	89 f6                	mov    %esi,%esi
80106109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	6a 0a                	push   $0xa
80106115:	e8 d6 c9 ff ff       	call   80102af0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010611a:	83 c4 10             	add    $0x10,%esp
8010611d:	83 eb 01             	sub    $0x1,%ebx
80106120:	74 07                	je     80106129 <uartputc.part.0+0x39>
80106122:	89 f2                	mov    %esi,%edx
80106124:	ec                   	in     (%dx),%al
80106125:	a8 20                	test   $0x20,%al
80106127:	74 e7                	je     80106110 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106129:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010612e:	89 f8                	mov    %edi,%eax
80106130:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106131:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106134:	5b                   	pop    %ebx
80106135:	5e                   	pop    %esi
80106136:	5f                   	pop    %edi
80106137:	5d                   	pop    %ebp
80106138:	c3                   	ret    
80106139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106140 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106140:	55                   	push   %ebp
80106141:	31 c9                	xor    %ecx,%ecx
80106143:	89 c8                	mov    %ecx,%eax
80106145:	89 e5                	mov    %esp,%ebp
80106147:	57                   	push   %edi
80106148:	56                   	push   %esi
80106149:	53                   	push   %ebx
8010614a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010614f:	89 da                	mov    %ebx,%edx
80106151:	83 ec 0c             	sub    $0xc,%esp
80106154:	ee                   	out    %al,(%dx)
80106155:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010615a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010615f:	89 fa                	mov    %edi,%edx
80106161:	ee                   	out    %al,(%dx)
80106162:	b8 0c 00 00 00       	mov    $0xc,%eax
80106167:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010616c:	ee                   	out    %al,(%dx)
8010616d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106172:	89 c8                	mov    %ecx,%eax
80106174:	89 f2                	mov    %esi,%edx
80106176:	ee                   	out    %al,(%dx)
80106177:	b8 03 00 00 00       	mov    $0x3,%eax
8010617c:	89 fa                	mov    %edi,%edx
8010617e:	ee                   	out    %al,(%dx)
8010617f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106184:	89 c8                	mov    %ecx,%eax
80106186:	ee                   	out    %al,(%dx)
80106187:	b8 01 00 00 00       	mov    $0x1,%eax
8010618c:	89 f2                	mov    %esi,%edx
8010618e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010618f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106194:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106195:	3c ff                	cmp    $0xff,%al
80106197:	74 5a                	je     801061f3 <uartinit+0xb3>
    return;
  uart = 1;
80106199:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801061a0:	00 00 00 
801061a3:	89 da                	mov    %ebx,%edx
801061a5:	ec                   	in     (%dx),%al
801061a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061ab:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801061ac:	83 ec 08             	sub    $0x8,%esp
801061af:	bb 2c 82 10 80       	mov    $0x8010822c,%ebx
801061b4:	6a 00                	push   $0x0
801061b6:	6a 04                	push   $0x4
801061b8:	e8 a3 c4 ff ff       	call   80102660 <ioapicenable>
801061bd:	83 c4 10             	add    $0x10,%esp
801061c0:	b8 78 00 00 00       	mov    $0x78,%eax
801061c5:	eb 13                	jmp    801061da <uartinit+0x9a>
801061c7:	89 f6                	mov    %esi,%esi
801061c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801061d0:	83 c3 01             	add    $0x1,%ebx
801061d3:	0f be 03             	movsbl (%ebx),%eax
801061d6:	84 c0                	test   %al,%al
801061d8:	74 19                	je     801061f3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
801061da:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801061e0:	85 d2                	test   %edx,%edx
801061e2:	74 ec                	je     801061d0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801061e4:	83 c3 01             	add    $0x1,%ebx
801061e7:	e8 04 ff ff ff       	call   801060f0 <uartputc.part.0>
801061ec:	0f be 03             	movsbl (%ebx),%eax
801061ef:	84 c0                	test   %al,%al
801061f1:	75 e7                	jne    801061da <uartinit+0x9a>
    uartputc(*p);
}
801061f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061f6:	5b                   	pop    %ebx
801061f7:	5e                   	pop    %esi
801061f8:	5f                   	pop    %edi
801061f9:	5d                   	pop    %ebp
801061fa:	c3                   	ret    
801061fb:	90                   	nop
801061fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106200 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106200:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106206:	55                   	push   %ebp
80106207:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106209:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010620b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010620e:	74 10                	je     80106220 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106210:	5d                   	pop    %ebp
80106211:	e9 da fe ff ff       	jmp    801060f0 <uartputc.part.0>
80106216:	8d 76 00             	lea    0x0(%esi),%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106220:	5d                   	pop    %ebp
80106221:	c3                   	ret    
80106222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106230 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106236:	68 c0 60 10 80       	push   $0x801060c0
8010623b:	e8 b0 a5 ff ff       	call   801007f0 <consoleintr>
}
80106240:	83 c4 10             	add    $0x10,%esp
80106243:	c9                   	leave  
80106244:	c3                   	ret    

80106245 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $0
80106247:	6a 00                	push   $0x0
  jmp alltraps
80106249:	e9 0c fb ff ff       	jmp    80105d5a <alltraps>

8010624e <vector1>:
.globl vector1
vector1:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $1
80106250:	6a 01                	push   $0x1
  jmp alltraps
80106252:	e9 03 fb ff ff       	jmp    80105d5a <alltraps>

80106257 <vector2>:
.globl vector2
vector2:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $2
80106259:	6a 02                	push   $0x2
  jmp alltraps
8010625b:	e9 fa fa ff ff       	jmp    80105d5a <alltraps>

80106260 <vector3>:
.globl vector3
vector3:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $3
80106262:	6a 03                	push   $0x3
  jmp alltraps
80106264:	e9 f1 fa ff ff       	jmp    80105d5a <alltraps>

80106269 <vector4>:
.globl vector4
vector4:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $4
8010626b:	6a 04                	push   $0x4
  jmp alltraps
8010626d:	e9 e8 fa ff ff       	jmp    80105d5a <alltraps>

80106272 <vector5>:
.globl vector5
vector5:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $5
80106274:	6a 05                	push   $0x5
  jmp alltraps
80106276:	e9 df fa ff ff       	jmp    80105d5a <alltraps>

8010627b <vector6>:
.globl vector6
vector6:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $6
8010627d:	6a 06                	push   $0x6
  jmp alltraps
8010627f:	e9 d6 fa ff ff       	jmp    80105d5a <alltraps>

80106284 <vector7>:
.globl vector7
vector7:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $7
80106286:	6a 07                	push   $0x7
  jmp alltraps
80106288:	e9 cd fa ff ff       	jmp    80105d5a <alltraps>

8010628d <vector8>:
.globl vector8
vector8:
  pushl $8
8010628d:	6a 08                	push   $0x8
  jmp alltraps
8010628f:	e9 c6 fa ff ff       	jmp    80105d5a <alltraps>

80106294 <vector9>:
.globl vector9
vector9:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $9
80106296:	6a 09                	push   $0x9
  jmp alltraps
80106298:	e9 bd fa ff ff       	jmp    80105d5a <alltraps>

8010629d <vector10>:
.globl vector10
vector10:
  pushl $10
8010629d:	6a 0a                	push   $0xa
  jmp alltraps
8010629f:	e9 b6 fa ff ff       	jmp    80105d5a <alltraps>

801062a4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062a4:	6a 0b                	push   $0xb
  jmp alltraps
801062a6:	e9 af fa ff ff       	jmp    80105d5a <alltraps>

801062ab <vector12>:
.globl vector12
vector12:
  pushl $12
801062ab:	6a 0c                	push   $0xc
  jmp alltraps
801062ad:	e9 a8 fa ff ff       	jmp    80105d5a <alltraps>

801062b2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062b2:	6a 0d                	push   $0xd
  jmp alltraps
801062b4:	e9 a1 fa ff ff       	jmp    80105d5a <alltraps>

801062b9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062b9:	6a 0e                	push   $0xe
  jmp alltraps
801062bb:	e9 9a fa ff ff       	jmp    80105d5a <alltraps>

801062c0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $15
801062c2:	6a 0f                	push   $0xf
  jmp alltraps
801062c4:	e9 91 fa ff ff       	jmp    80105d5a <alltraps>

801062c9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $16
801062cb:	6a 10                	push   $0x10
  jmp alltraps
801062cd:	e9 88 fa ff ff       	jmp    80105d5a <alltraps>

801062d2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062d2:	6a 11                	push   $0x11
  jmp alltraps
801062d4:	e9 81 fa ff ff       	jmp    80105d5a <alltraps>

801062d9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $18
801062db:	6a 12                	push   $0x12
  jmp alltraps
801062dd:	e9 78 fa ff ff       	jmp    80105d5a <alltraps>

801062e2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $19
801062e4:	6a 13                	push   $0x13
  jmp alltraps
801062e6:	e9 6f fa ff ff       	jmp    80105d5a <alltraps>

801062eb <vector20>:
.globl vector20
vector20:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $20
801062ed:	6a 14                	push   $0x14
  jmp alltraps
801062ef:	e9 66 fa ff ff       	jmp    80105d5a <alltraps>

801062f4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $21
801062f6:	6a 15                	push   $0x15
  jmp alltraps
801062f8:	e9 5d fa ff ff       	jmp    80105d5a <alltraps>

801062fd <vector22>:
.globl vector22
vector22:
  pushl $0
801062fd:	6a 00                	push   $0x0
  pushl $22
801062ff:	6a 16                	push   $0x16
  jmp alltraps
80106301:	e9 54 fa ff ff       	jmp    80105d5a <alltraps>

80106306 <vector23>:
.globl vector23
vector23:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $23
80106308:	6a 17                	push   $0x17
  jmp alltraps
8010630a:	e9 4b fa ff ff       	jmp    80105d5a <alltraps>

8010630f <vector24>:
.globl vector24
vector24:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $24
80106311:	6a 18                	push   $0x18
  jmp alltraps
80106313:	e9 42 fa ff ff       	jmp    80105d5a <alltraps>

80106318 <vector25>:
.globl vector25
vector25:
  pushl $0
80106318:	6a 00                	push   $0x0
  pushl $25
8010631a:	6a 19                	push   $0x19
  jmp alltraps
8010631c:	e9 39 fa ff ff       	jmp    80105d5a <alltraps>

80106321 <vector26>:
.globl vector26
vector26:
  pushl $0
80106321:	6a 00                	push   $0x0
  pushl $26
80106323:	6a 1a                	push   $0x1a
  jmp alltraps
80106325:	e9 30 fa ff ff       	jmp    80105d5a <alltraps>

8010632a <vector27>:
.globl vector27
vector27:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $27
8010632c:	6a 1b                	push   $0x1b
  jmp alltraps
8010632e:	e9 27 fa ff ff       	jmp    80105d5a <alltraps>

80106333 <vector28>:
.globl vector28
vector28:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $28
80106335:	6a 1c                	push   $0x1c
  jmp alltraps
80106337:	e9 1e fa ff ff       	jmp    80105d5a <alltraps>

8010633c <vector29>:
.globl vector29
vector29:
  pushl $0
8010633c:	6a 00                	push   $0x0
  pushl $29
8010633e:	6a 1d                	push   $0x1d
  jmp alltraps
80106340:	e9 15 fa ff ff       	jmp    80105d5a <alltraps>

80106345 <vector30>:
.globl vector30
vector30:
  pushl $0
80106345:	6a 00                	push   $0x0
  pushl $30
80106347:	6a 1e                	push   $0x1e
  jmp alltraps
80106349:	e9 0c fa ff ff       	jmp    80105d5a <alltraps>

8010634e <vector31>:
.globl vector31
vector31:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $31
80106350:	6a 1f                	push   $0x1f
  jmp alltraps
80106352:	e9 03 fa ff ff       	jmp    80105d5a <alltraps>

80106357 <vector32>:
.globl vector32
vector32:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $32
80106359:	6a 20                	push   $0x20
  jmp alltraps
8010635b:	e9 fa f9 ff ff       	jmp    80105d5a <alltraps>

80106360 <vector33>:
.globl vector33
vector33:
  pushl $0
80106360:	6a 00                	push   $0x0
  pushl $33
80106362:	6a 21                	push   $0x21
  jmp alltraps
80106364:	e9 f1 f9 ff ff       	jmp    80105d5a <alltraps>

80106369 <vector34>:
.globl vector34
vector34:
  pushl $0
80106369:	6a 00                	push   $0x0
  pushl $34
8010636b:	6a 22                	push   $0x22
  jmp alltraps
8010636d:	e9 e8 f9 ff ff       	jmp    80105d5a <alltraps>

80106372 <vector35>:
.globl vector35
vector35:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $35
80106374:	6a 23                	push   $0x23
  jmp alltraps
80106376:	e9 df f9 ff ff       	jmp    80105d5a <alltraps>

8010637b <vector36>:
.globl vector36
vector36:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $36
8010637d:	6a 24                	push   $0x24
  jmp alltraps
8010637f:	e9 d6 f9 ff ff       	jmp    80105d5a <alltraps>

80106384 <vector37>:
.globl vector37
vector37:
  pushl $0
80106384:	6a 00                	push   $0x0
  pushl $37
80106386:	6a 25                	push   $0x25
  jmp alltraps
80106388:	e9 cd f9 ff ff       	jmp    80105d5a <alltraps>

8010638d <vector38>:
.globl vector38
vector38:
  pushl $0
8010638d:	6a 00                	push   $0x0
  pushl $38
8010638f:	6a 26                	push   $0x26
  jmp alltraps
80106391:	e9 c4 f9 ff ff       	jmp    80105d5a <alltraps>

80106396 <vector39>:
.globl vector39
vector39:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $39
80106398:	6a 27                	push   $0x27
  jmp alltraps
8010639a:	e9 bb f9 ff ff       	jmp    80105d5a <alltraps>

8010639f <vector40>:
.globl vector40
vector40:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $40
801063a1:	6a 28                	push   $0x28
  jmp alltraps
801063a3:	e9 b2 f9 ff ff       	jmp    80105d5a <alltraps>

801063a8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063a8:	6a 00                	push   $0x0
  pushl $41
801063aa:	6a 29                	push   $0x29
  jmp alltraps
801063ac:	e9 a9 f9 ff ff       	jmp    80105d5a <alltraps>

801063b1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063b1:	6a 00                	push   $0x0
  pushl $42
801063b3:	6a 2a                	push   $0x2a
  jmp alltraps
801063b5:	e9 a0 f9 ff ff       	jmp    80105d5a <alltraps>

801063ba <vector43>:
.globl vector43
vector43:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $43
801063bc:	6a 2b                	push   $0x2b
  jmp alltraps
801063be:	e9 97 f9 ff ff       	jmp    80105d5a <alltraps>

801063c3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $44
801063c5:	6a 2c                	push   $0x2c
  jmp alltraps
801063c7:	e9 8e f9 ff ff       	jmp    80105d5a <alltraps>

801063cc <vector45>:
.globl vector45
vector45:
  pushl $0
801063cc:	6a 00                	push   $0x0
  pushl $45
801063ce:	6a 2d                	push   $0x2d
  jmp alltraps
801063d0:	e9 85 f9 ff ff       	jmp    80105d5a <alltraps>

801063d5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063d5:	6a 00                	push   $0x0
  pushl $46
801063d7:	6a 2e                	push   $0x2e
  jmp alltraps
801063d9:	e9 7c f9 ff ff       	jmp    80105d5a <alltraps>

801063de <vector47>:
.globl vector47
vector47:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $47
801063e0:	6a 2f                	push   $0x2f
  jmp alltraps
801063e2:	e9 73 f9 ff ff       	jmp    80105d5a <alltraps>

801063e7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $48
801063e9:	6a 30                	push   $0x30
  jmp alltraps
801063eb:	e9 6a f9 ff ff       	jmp    80105d5a <alltraps>

801063f0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $49
801063f2:	6a 31                	push   $0x31
  jmp alltraps
801063f4:	e9 61 f9 ff ff       	jmp    80105d5a <alltraps>

801063f9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $50
801063fb:	6a 32                	push   $0x32
  jmp alltraps
801063fd:	e9 58 f9 ff ff       	jmp    80105d5a <alltraps>

80106402 <vector51>:
.globl vector51
vector51:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $51
80106404:	6a 33                	push   $0x33
  jmp alltraps
80106406:	e9 4f f9 ff ff       	jmp    80105d5a <alltraps>

8010640b <vector52>:
.globl vector52
vector52:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $52
8010640d:	6a 34                	push   $0x34
  jmp alltraps
8010640f:	e9 46 f9 ff ff       	jmp    80105d5a <alltraps>

80106414 <vector53>:
.globl vector53
vector53:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $53
80106416:	6a 35                	push   $0x35
  jmp alltraps
80106418:	e9 3d f9 ff ff       	jmp    80105d5a <alltraps>

8010641d <vector54>:
.globl vector54
vector54:
  pushl $0
8010641d:	6a 00                	push   $0x0
  pushl $54
8010641f:	6a 36                	push   $0x36
  jmp alltraps
80106421:	e9 34 f9 ff ff       	jmp    80105d5a <alltraps>

80106426 <vector55>:
.globl vector55
vector55:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $55
80106428:	6a 37                	push   $0x37
  jmp alltraps
8010642a:	e9 2b f9 ff ff       	jmp    80105d5a <alltraps>

8010642f <vector56>:
.globl vector56
vector56:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $56
80106431:	6a 38                	push   $0x38
  jmp alltraps
80106433:	e9 22 f9 ff ff       	jmp    80105d5a <alltraps>

80106438 <vector57>:
.globl vector57
vector57:
  pushl $0
80106438:	6a 00                	push   $0x0
  pushl $57
8010643a:	6a 39                	push   $0x39
  jmp alltraps
8010643c:	e9 19 f9 ff ff       	jmp    80105d5a <alltraps>

80106441 <vector58>:
.globl vector58
vector58:
  pushl $0
80106441:	6a 00                	push   $0x0
  pushl $58
80106443:	6a 3a                	push   $0x3a
  jmp alltraps
80106445:	e9 10 f9 ff ff       	jmp    80105d5a <alltraps>

8010644a <vector59>:
.globl vector59
vector59:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $59
8010644c:	6a 3b                	push   $0x3b
  jmp alltraps
8010644e:	e9 07 f9 ff ff       	jmp    80105d5a <alltraps>

80106453 <vector60>:
.globl vector60
vector60:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $60
80106455:	6a 3c                	push   $0x3c
  jmp alltraps
80106457:	e9 fe f8 ff ff       	jmp    80105d5a <alltraps>

8010645c <vector61>:
.globl vector61
vector61:
  pushl $0
8010645c:	6a 00                	push   $0x0
  pushl $61
8010645e:	6a 3d                	push   $0x3d
  jmp alltraps
80106460:	e9 f5 f8 ff ff       	jmp    80105d5a <alltraps>

80106465 <vector62>:
.globl vector62
vector62:
  pushl $0
80106465:	6a 00                	push   $0x0
  pushl $62
80106467:	6a 3e                	push   $0x3e
  jmp alltraps
80106469:	e9 ec f8 ff ff       	jmp    80105d5a <alltraps>

8010646e <vector63>:
.globl vector63
vector63:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $63
80106470:	6a 3f                	push   $0x3f
  jmp alltraps
80106472:	e9 e3 f8 ff ff       	jmp    80105d5a <alltraps>

80106477 <vector64>:
.globl vector64
vector64:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $64
80106479:	6a 40                	push   $0x40
  jmp alltraps
8010647b:	e9 da f8 ff ff       	jmp    80105d5a <alltraps>

80106480 <vector65>:
.globl vector65
vector65:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $65
80106482:	6a 41                	push   $0x41
  jmp alltraps
80106484:	e9 d1 f8 ff ff       	jmp    80105d5a <alltraps>

80106489 <vector66>:
.globl vector66
vector66:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $66
8010648b:	6a 42                	push   $0x42
  jmp alltraps
8010648d:	e9 c8 f8 ff ff       	jmp    80105d5a <alltraps>

80106492 <vector67>:
.globl vector67
vector67:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $67
80106494:	6a 43                	push   $0x43
  jmp alltraps
80106496:	e9 bf f8 ff ff       	jmp    80105d5a <alltraps>

8010649b <vector68>:
.globl vector68
vector68:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $68
8010649d:	6a 44                	push   $0x44
  jmp alltraps
8010649f:	e9 b6 f8 ff ff       	jmp    80105d5a <alltraps>

801064a4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $69
801064a6:	6a 45                	push   $0x45
  jmp alltraps
801064a8:	e9 ad f8 ff ff       	jmp    80105d5a <alltraps>

801064ad <vector70>:
.globl vector70
vector70:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $70
801064af:	6a 46                	push   $0x46
  jmp alltraps
801064b1:	e9 a4 f8 ff ff       	jmp    80105d5a <alltraps>

801064b6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $71
801064b8:	6a 47                	push   $0x47
  jmp alltraps
801064ba:	e9 9b f8 ff ff       	jmp    80105d5a <alltraps>

801064bf <vector72>:
.globl vector72
vector72:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $72
801064c1:	6a 48                	push   $0x48
  jmp alltraps
801064c3:	e9 92 f8 ff ff       	jmp    80105d5a <alltraps>

801064c8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $73
801064ca:	6a 49                	push   $0x49
  jmp alltraps
801064cc:	e9 89 f8 ff ff       	jmp    80105d5a <alltraps>

801064d1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064d1:	6a 00                	push   $0x0
  pushl $74
801064d3:	6a 4a                	push   $0x4a
  jmp alltraps
801064d5:	e9 80 f8 ff ff       	jmp    80105d5a <alltraps>

801064da <vector75>:
.globl vector75
vector75:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $75
801064dc:	6a 4b                	push   $0x4b
  jmp alltraps
801064de:	e9 77 f8 ff ff       	jmp    80105d5a <alltraps>

801064e3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $76
801064e5:	6a 4c                	push   $0x4c
  jmp alltraps
801064e7:	e9 6e f8 ff ff       	jmp    80105d5a <alltraps>

801064ec <vector77>:
.globl vector77
vector77:
  pushl $0
801064ec:	6a 00                	push   $0x0
  pushl $77
801064ee:	6a 4d                	push   $0x4d
  jmp alltraps
801064f0:	e9 65 f8 ff ff       	jmp    80105d5a <alltraps>

801064f5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064f5:	6a 00                	push   $0x0
  pushl $78
801064f7:	6a 4e                	push   $0x4e
  jmp alltraps
801064f9:	e9 5c f8 ff ff       	jmp    80105d5a <alltraps>

801064fe <vector79>:
.globl vector79
vector79:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $79
80106500:	6a 4f                	push   $0x4f
  jmp alltraps
80106502:	e9 53 f8 ff ff       	jmp    80105d5a <alltraps>

80106507 <vector80>:
.globl vector80
vector80:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $80
80106509:	6a 50                	push   $0x50
  jmp alltraps
8010650b:	e9 4a f8 ff ff       	jmp    80105d5a <alltraps>

80106510 <vector81>:
.globl vector81
vector81:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $81
80106512:	6a 51                	push   $0x51
  jmp alltraps
80106514:	e9 41 f8 ff ff       	jmp    80105d5a <alltraps>

80106519 <vector82>:
.globl vector82
vector82:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $82
8010651b:	6a 52                	push   $0x52
  jmp alltraps
8010651d:	e9 38 f8 ff ff       	jmp    80105d5a <alltraps>

80106522 <vector83>:
.globl vector83
vector83:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $83
80106524:	6a 53                	push   $0x53
  jmp alltraps
80106526:	e9 2f f8 ff ff       	jmp    80105d5a <alltraps>

8010652b <vector84>:
.globl vector84
vector84:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $84
8010652d:	6a 54                	push   $0x54
  jmp alltraps
8010652f:	e9 26 f8 ff ff       	jmp    80105d5a <alltraps>

80106534 <vector85>:
.globl vector85
vector85:
  pushl $0
80106534:	6a 00                	push   $0x0
  pushl $85
80106536:	6a 55                	push   $0x55
  jmp alltraps
80106538:	e9 1d f8 ff ff       	jmp    80105d5a <alltraps>

8010653d <vector86>:
.globl vector86
vector86:
  pushl $0
8010653d:	6a 00                	push   $0x0
  pushl $86
8010653f:	6a 56                	push   $0x56
  jmp alltraps
80106541:	e9 14 f8 ff ff       	jmp    80105d5a <alltraps>

80106546 <vector87>:
.globl vector87
vector87:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $87
80106548:	6a 57                	push   $0x57
  jmp alltraps
8010654a:	e9 0b f8 ff ff       	jmp    80105d5a <alltraps>

8010654f <vector88>:
.globl vector88
vector88:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $88
80106551:	6a 58                	push   $0x58
  jmp alltraps
80106553:	e9 02 f8 ff ff       	jmp    80105d5a <alltraps>

80106558 <vector89>:
.globl vector89
vector89:
  pushl $0
80106558:	6a 00                	push   $0x0
  pushl $89
8010655a:	6a 59                	push   $0x59
  jmp alltraps
8010655c:	e9 f9 f7 ff ff       	jmp    80105d5a <alltraps>

80106561 <vector90>:
.globl vector90
vector90:
  pushl $0
80106561:	6a 00                	push   $0x0
  pushl $90
80106563:	6a 5a                	push   $0x5a
  jmp alltraps
80106565:	e9 f0 f7 ff ff       	jmp    80105d5a <alltraps>

8010656a <vector91>:
.globl vector91
vector91:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $91
8010656c:	6a 5b                	push   $0x5b
  jmp alltraps
8010656e:	e9 e7 f7 ff ff       	jmp    80105d5a <alltraps>

80106573 <vector92>:
.globl vector92
vector92:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $92
80106575:	6a 5c                	push   $0x5c
  jmp alltraps
80106577:	e9 de f7 ff ff       	jmp    80105d5a <alltraps>

8010657c <vector93>:
.globl vector93
vector93:
  pushl $0
8010657c:	6a 00                	push   $0x0
  pushl $93
8010657e:	6a 5d                	push   $0x5d
  jmp alltraps
80106580:	e9 d5 f7 ff ff       	jmp    80105d5a <alltraps>

80106585 <vector94>:
.globl vector94
vector94:
  pushl $0
80106585:	6a 00                	push   $0x0
  pushl $94
80106587:	6a 5e                	push   $0x5e
  jmp alltraps
80106589:	e9 cc f7 ff ff       	jmp    80105d5a <alltraps>

8010658e <vector95>:
.globl vector95
vector95:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $95
80106590:	6a 5f                	push   $0x5f
  jmp alltraps
80106592:	e9 c3 f7 ff ff       	jmp    80105d5a <alltraps>

80106597 <vector96>:
.globl vector96
vector96:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $96
80106599:	6a 60                	push   $0x60
  jmp alltraps
8010659b:	e9 ba f7 ff ff       	jmp    80105d5a <alltraps>

801065a0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065a0:	6a 00                	push   $0x0
  pushl $97
801065a2:	6a 61                	push   $0x61
  jmp alltraps
801065a4:	e9 b1 f7 ff ff       	jmp    80105d5a <alltraps>

801065a9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $98
801065ab:	6a 62                	push   $0x62
  jmp alltraps
801065ad:	e9 a8 f7 ff ff       	jmp    80105d5a <alltraps>

801065b2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $99
801065b4:	6a 63                	push   $0x63
  jmp alltraps
801065b6:	e9 9f f7 ff ff       	jmp    80105d5a <alltraps>

801065bb <vector100>:
.globl vector100
vector100:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $100
801065bd:	6a 64                	push   $0x64
  jmp alltraps
801065bf:	e9 96 f7 ff ff       	jmp    80105d5a <alltraps>

801065c4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $101
801065c6:	6a 65                	push   $0x65
  jmp alltraps
801065c8:	e9 8d f7 ff ff       	jmp    80105d5a <alltraps>

801065cd <vector102>:
.globl vector102
vector102:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $102
801065cf:	6a 66                	push   $0x66
  jmp alltraps
801065d1:	e9 84 f7 ff ff       	jmp    80105d5a <alltraps>

801065d6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $103
801065d8:	6a 67                	push   $0x67
  jmp alltraps
801065da:	e9 7b f7 ff ff       	jmp    80105d5a <alltraps>

801065df <vector104>:
.globl vector104
vector104:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $104
801065e1:	6a 68                	push   $0x68
  jmp alltraps
801065e3:	e9 72 f7 ff ff       	jmp    80105d5a <alltraps>

801065e8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $105
801065ea:	6a 69                	push   $0x69
  jmp alltraps
801065ec:	e9 69 f7 ff ff       	jmp    80105d5a <alltraps>

801065f1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $106
801065f3:	6a 6a                	push   $0x6a
  jmp alltraps
801065f5:	e9 60 f7 ff ff       	jmp    80105d5a <alltraps>

801065fa <vector107>:
.globl vector107
vector107:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $107
801065fc:	6a 6b                	push   $0x6b
  jmp alltraps
801065fe:	e9 57 f7 ff ff       	jmp    80105d5a <alltraps>

80106603 <vector108>:
.globl vector108
vector108:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $108
80106605:	6a 6c                	push   $0x6c
  jmp alltraps
80106607:	e9 4e f7 ff ff       	jmp    80105d5a <alltraps>

8010660c <vector109>:
.globl vector109
vector109:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $109
8010660e:	6a 6d                	push   $0x6d
  jmp alltraps
80106610:	e9 45 f7 ff ff       	jmp    80105d5a <alltraps>

80106615 <vector110>:
.globl vector110
vector110:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $110
80106617:	6a 6e                	push   $0x6e
  jmp alltraps
80106619:	e9 3c f7 ff ff       	jmp    80105d5a <alltraps>

8010661e <vector111>:
.globl vector111
vector111:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $111
80106620:	6a 6f                	push   $0x6f
  jmp alltraps
80106622:	e9 33 f7 ff ff       	jmp    80105d5a <alltraps>

80106627 <vector112>:
.globl vector112
vector112:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $112
80106629:	6a 70                	push   $0x70
  jmp alltraps
8010662b:	e9 2a f7 ff ff       	jmp    80105d5a <alltraps>

80106630 <vector113>:
.globl vector113
vector113:
  pushl $0
80106630:	6a 00                	push   $0x0
  pushl $113
80106632:	6a 71                	push   $0x71
  jmp alltraps
80106634:	e9 21 f7 ff ff       	jmp    80105d5a <alltraps>

80106639 <vector114>:
.globl vector114
vector114:
  pushl $0
80106639:	6a 00                	push   $0x0
  pushl $114
8010663b:	6a 72                	push   $0x72
  jmp alltraps
8010663d:	e9 18 f7 ff ff       	jmp    80105d5a <alltraps>

80106642 <vector115>:
.globl vector115
vector115:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $115
80106644:	6a 73                	push   $0x73
  jmp alltraps
80106646:	e9 0f f7 ff ff       	jmp    80105d5a <alltraps>

8010664b <vector116>:
.globl vector116
vector116:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $116
8010664d:	6a 74                	push   $0x74
  jmp alltraps
8010664f:	e9 06 f7 ff ff       	jmp    80105d5a <alltraps>

80106654 <vector117>:
.globl vector117
vector117:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $117
80106656:	6a 75                	push   $0x75
  jmp alltraps
80106658:	e9 fd f6 ff ff       	jmp    80105d5a <alltraps>

8010665d <vector118>:
.globl vector118
vector118:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $118
8010665f:	6a 76                	push   $0x76
  jmp alltraps
80106661:	e9 f4 f6 ff ff       	jmp    80105d5a <alltraps>

80106666 <vector119>:
.globl vector119
vector119:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $119
80106668:	6a 77                	push   $0x77
  jmp alltraps
8010666a:	e9 eb f6 ff ff       	jmp    80105d5a <alltraps>

8010666f <vector120>:
.globl vector120
vector120:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $120
80106671:	6a 78                	push   $0x78
  jmp alltraps
80106673:	e9 e2 f6 ff ff       	jmp    80105d5a <alltraps>

80106678 <vector121>:
.globl vector121
vector121:
  pushl $0
80106678:	6a 00                	push   $0x0
  pushl $121
8010667a:	6a 79                	push   $0x79
  jmp alltraps
8010667c:	e9 d9 f6 ff ff       	jmp    80105d5a <alltraps>

80106681 <vector122>:
.globl vector122
vector122:
  pushl $0
80106681:	6a 00                	push   $0x0
  pushl $122
80106683:	6a 7a                	push   $0x7a
  jmp alltraps
80106685:	e9 d0 f6 ff ff       	jmp    80105d5a <alltraps>

8010668a <vector123>:
.globl vector123
vector123:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $123
8010668c:	6a 7b                	push   $0x7b
  jmp alltraps
8010668e:	e9 c7 f6 ff ff       	jmp    80105d5a <alltraps>

80106693 <vector124>:
.globl vector124
vector124:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $124
80106695:	6a 7c                	push   $0x7c
  jmp alltraps
80106697:	e9 be f6 ff ff       	jmp    80105d5a <alltraps>

8010669c <vector125>:
.globl vector125
vector125:
  pushl $0
8010669c:	6a 00                	push   $0x0
  pushl $125
8010669e:	6a 7d                	push   $0x7d
  jmp alltraps
801066a0:	e9 b5 f6 ff ff       	jmp    80105d5a <alltraps>

801066a5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066a5:	6a 00                	push   $0x0
  pushl $126
801066a7:	6a 7e                	push   $0x7e
  jmp alltraps
801066a9:	e9 ac f6 ff ff       	jmp    80105d5a <alltraps>

801066ae <vector127>:
.globl vector127
vector127:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $127
801066b0:	6a 7f                	push   $0x7f
  jmp alltraps
801066b2:	e9 a3 f6 ff ff       	jmp    80105d5a <alltraps>

801066b7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $128
801066b9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066be:	e9 97 f6 ff ff       	jmp    80105d5a <alltraps>

801066c3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $129
801066c5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066ca:	e9 8b f6 ff ff       	jmp    80105d5a <alltraps>

801066cf <vector130>:
.globl vector130
vector130:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $130
801066d1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066d6:	e9 7f f6 ff ff       	jmp    80105d5a <alltraps>

801066db <vector131>:
.globl vector131
vector131:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $131
801066dd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066e2:	e9 73 f6 ff ff       	jmp    80105d5a <alltraps>

801066e7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $132
801066e9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066ee:	e9 67 f6 ff ff       	jmp    80105d5a <alltraps>

801066f3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $133
801066f5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066fa:	e9 5b f6 ff ff       	jmp    80105d5a <alltraps>

801066ff <vector134>:
.globl vector134
vector134:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $134
80106701:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106706:	e9 4f f6 ff ff       	jmp    80105d5a <alltraps>

8010670b <vector135>:
.globl vector135
vector135:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $135
8010670d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106712:	e9 43 f6 ff ff       	jmp    80105d5a <alltraps>

80106717 <vector136>:
.globl vector136
vector136:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $136
80106719:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010671e:	e9 37 f6 ff ff       	jmp    80105d5a <alltraps>

80106723 <vector137>:
.globl vector137
vector137:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $137
80106725:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010672a:	e9 2b f6 ff ff       	jmp    80105d5a <alltraps>

8010672f <vector138>:
.globl vector138
vector138:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $138
80106731:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106736:	e9 1f f6 ff ff       	jmp    80105d5a <alltraps>

8010673b <vector139>:
.globl vector139
vector139:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $139
8010673d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106742:	e9 13 f6 ff ff       	jmp    80105d5a <alltraps>

80106747 <vector140>:
.globl vector140
vector140:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $140
80106749:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010674e:	e9 07 f6 ff ff       	jmp    80105d5a <alltraps>

80106753 <vector141>:
.globl vector141
vector141:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $141
80106755:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010675a:	e9 fb f5 ff ff       	jmp    80105d5a <alltraps>

8010675f <vector142>:
.globl vector142
vector142:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $142
80106761:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106766:	e9 ef f5 ff ff       	jmp    80105d5a <alltraps>

8010676b <vector143>:
.globl vector143
vector143:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $143
8010676d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106772:	e9 e3 f5 ff ff       	jmp    80105d5a <alltraps>

80106777 <vector144>:
.globl vector144
vector144:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $144
80106779:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010677e:	e9 d7 f5 ff ff       	jmp    80105d5a <alltraps>

80106783 <vector145>:
.globl vector145
vector145:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $145
80106785:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010678a:	e9 cb f5 ff ff       	jmp    80105d5a <alltraps>

8010678f <vector146>:
.globl vector146
vector146:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $146
80106791:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106796:	e9 bf f5 ff ff       	jmp    80105d5a <alltraps>

8010679b <vector147>:
.globl vector147
vector147:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $147
8010679d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067a2:	e9 b3 f5 ff ff       	jmp    80105d5a <alltraps>

801067a7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $148
801067a9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067ae:	e9 a7 f5 ff ff       	jmp    80105d5a <alltraps>

801067b3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $149
801067b5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067ba:	e9 9b f5 ff ff       	jmp    80105d5a <alltraps>

801067bf <vector150>:
.globl vector150
vector150:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $150
801067c1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067c6:	e9 8f f5 ff ff       	jmp    80105d5a <alltraps>

801067cb <vector151>:
.globl vector151
vector151:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $151
801067cd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067d2:	e9 83 f5 ff ff       	jmp    80105d5a <alltraps>

801067d7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $152
801067d9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067de:	e9 77 f5 ff ff       	jmp    80105d5a <alltraps>

801067e3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $153
801067e5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067ea:	e9 6b f5 ff ff       	jmp    80105d5a <alltraps>

801067ef <vector154>:
.globl vector154
vector154:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $154
801067f1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067f6:	e9 5f f5 ff ff       	jmp    80105d5a <alltraps>

801067fb <vector155>:
.globl vector155
vector155:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $155
801067fd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106802:	e9 53 f5 ff ff       	jmp    80105d5a <alltraps>

80106807 <vector156>:
.globl vector156
vector156:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $156
80106809:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010680e:	e9 47 f5 ff ff       	jmp    80105d5a <alltraps>

80106813 <vector157>:
.globl vector157
vector157:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $157
80106815:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010681a:	e9 3b f5 ff ff       	jmp    80105d5a <alltraps>

8010681f <vector158>:
.globl vector158
vector158:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $158
80106821:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106826:	e9 2f f5 ff ff       	jmp    80105d5a <alltraps>

8010682b <vector159>:
.globl vector159
vector159:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $159
8010682d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106832:	e9 23 f5 ff ff       	jmp    80105d5a <alltraps>

80106837 <vector160>:
.globl vector160
vector160:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $160
80106839:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010683e:	e9 17 f5 ff ff       	jmp    80105d5a <alltraps>

80106843 <vector161>:
.globl vector161
vector161:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $161
80106845:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010684a:	e9 0b f5 ff ff       	jmp    80105d5a <alltraps>

8010684f <vector162>:
.globl vector162
vector162:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $162
80106851:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106856:	e9 ff f4 ff ff       	jmp    80105d5a <alltraps>

8010685b <vector163>:
.globl vector163
vector163:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $163
8010685d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106862:	e9 f3 f4 ff ff       	jmp    80105d5a <alltraps>

80106867 <vector164>:
.globl vector164
vector164:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $164
80106869:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010686e:	e9 e7 f4 ff ff       	jmp    80105d5a <alltraps>

80106873 <vector165>:
.globl vector165
vector165:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $165
80106875:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010687a:	e9 db f4 ff ff       	jmp    80105d5a <alltraps>

8010687f <vector166>:
.globl vector166
vector166:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $166
80106881:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106886:	e9 cf f4 ff ff       	jmp    80105d5a <alltraps>

8010688b <vector167>:
.globl vector167
vector167:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $167
8010688d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106892:	e9 c3 f4 ff ff       	jmp    80105d5a <alltraps>

80106897 <vector168>:
.globl vector168
vector168:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $168
80106899:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010689e:	e9 b7 f4 ff ff       	jmp    80105d5a <alltraps>

801068a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $169
801068a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068aa:	e9 ab f4 ff ff       	jmp    80105d5a <alltraps>

801068af <vector170>:
.globl vector170
vector170:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $170
801068b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068b6:	e9 9f f4 ff ff       	jmp    80105d5a <alltraps>

801068bb <vector171>:
.globl vector171
vector171:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $171
801068bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068c2:	e9 93 f4 ff ff       	jmp    80105d5a <alltraps>

801068c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $172
801068c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068ce:	e9 87 f4 ff ff       	jmp    80105d5a <alltraps>

801068d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $173
801068d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068da:	e9 7b f4 ff ff       	jmp    80105d5a <alltraps>

801068df <vector174>:
.globl vector174
vector174:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $174
801068e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068e6:	e9 6f f4 ff ff       	jmp    80105d5a <alltraps>

801068eb <vector175>:
.globl vector175
vector175:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $175
801068ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068f2:	e9 63 f4 ff ff       	jmp    80105d5a <alltraps>

801068f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $176
801068f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068fe:	e9 57 f4 ff ff       	jmp    80105d5a <alltraps>

80106903 <vector177>:
.globl vector177
vector177:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $177
80106905:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010690a:	e9 4b f4 ff ff       	jmp    80105d5a <alltraps>

8010690f <vector178>:
.globl vector178
vector178:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $178
80106911:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106916:	e9 3f f4 ff ff       	jmp    80105d5a <alltraps>

8010691b <vector179>:
.globl vector179
vector179:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $179
8010691d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106922:	e9 33 f4 ff ff       	jmp    80105d5a <alltraps>

80106927 <vector180>:
.globl vector180
vector180:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $180
80106929:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010692e:	e9 27 f4 ff ff       	jmp    80105d5a <alltraps>

80106933 <vector181>:
.globl vector181
vector181:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $181
80106935:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010693a:	e9 1b f4 ff ff       	jmp    80105d5a <alltraps>

8010693f <vector182>:
.globl vector182
vector182:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $182
80106941:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106946:	e9 0f f4 ff ff       	jmp    80105d5a <alltraps>

8010694b <vector183>:
.globl vector183
vector183:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $183
8010694d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106952:	e9 03 f4 ff ff       	jmp    80105d5a <alltraps>

80106957 <vector184>:
.globl vector184
vector184:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $184
80106959:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010695e:	e9 f7 f3 ff ff       	jmp    80105d5a <alltraps>

80106963 <vector185>:
.globl vector185
vector185:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $185
80106965:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010696a:	e9 eb f3 ff ff       	jmp    80105d5a <alltraps>

8010696f <vector186>:
.globl vector186
vector186:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $186
80106971:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106976:	e9 df f3 ff ff       	jmp    80105d5a <alltraps>

8010697b <vector187>:
.globl vector187
vector187:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $187
8010697d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106982:	e9 d3 f3 ff ff       	jmp    80105d5a <alltraps>

80106987 <vector188>:
.globl vector188
vector188:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $188
80106989:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010698e:	e9 c7 f3 ff ff       	jmp    80105d5a <alltraps>

80106993 <vector189>:
.globl vector189
vector189:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $189
80106995:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010699a:	e9 bb f3 ff ff       	jmp    80105d5a <alltraps>

8010699f <vector190>:
.globl vector190
vector190:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $190
801069a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069a6:	e9 af f3 ff ff       	jmp    80105d5a <alltraps>

801069ab <vector191>:
.globl vector191
vector191:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $191
801069ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069b2:	e9 a3 f3 ff ff       	jmp    80105d5a <alltraps>

801069b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $192
801069b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069be:	e9 97 f3 ff ff       	jmp    80105d5a <alltraps>

801069c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $193
801069c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069ca:	e9 8b f3 ff ff       	jmp    80105d5a <alltraps>

801069cf <vector194>:
.globl vector194
vector194:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $194
801069d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069d6:	e9 7f f3 ff ff       	jmp    80105d5a <alltraps>

801069db <vector195>:
.globl vector195
vector195:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $195
801069dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069e2:	e9 73 f3 ff ff       	jmp    80105d5a <alltraps>

801069e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $196
801069e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069ee:	e9 67 f3 ff ff       	jmp    80105d5a <alltraps>

801069f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $197
801069f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069fa:	e9 5b f3 ff ff       	jmp    80105d5a <alltraps>

801069ff <vector198>:
.globl vector198
vector198:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $198
80106a01:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a06:	e9 4f f3 ff ff       	jmp    80105d5a <alltraps>

80106a0b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $199
80106a0d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a12:	e9 43 f3 ff ff       	jmp    80105d5a <alltraps>

80106a17 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $200
80106a19:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a1e:	e9 37 f3 ff ff       	jmp    80105d5a <alltraps>

80106a23 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $201
80106a25:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a2a:	e9 2b f3 ff ff       	jmp    80105d5a <alltraps>

80106a2f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $202
80106a31:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a36:	e9 1f f3 ff ff       	jmp    80105d5a <alltraps>

80106a3b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $203
80106a3d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a42:	e9 13 f3 ff ff       	jmp    80105d5a <alltraps>

80106a47 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $204
80106a49:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a4e:	e9 07 f3 ff ff       	jmp    80105d5a <alltraps>

80106a53 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $205
80106a55:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a5a:	e9 fb f2 ff ff       	jmp    80105d5a <alltraps>

80106a5f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $206
80106a61:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a66:	e9 ef f2 ff ff       	jmp    80105d5a <alltraps>

80106a6b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $207
80106a6d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a72:	e9 e3 f2 ff ff       	jmp    80105d5a <alltraps>

80106a77 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $208
80106a79:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a7e:	e9 d7 f2 ff ff       	jmp    80105d5a <alltraps>

80106a83 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $209
80106a85:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a8a:	e9 cb f2 ff ff       	jmp    80105d5a <alltraps>

80106a8f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $210
80106a91:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a96:	e9 bf f2 ff ff       	jmp    80105d5a <alltraps>

80106a9b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $211
80106a9d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106aa2:	e9 b3 f2 ff ff       	jmp    80105d5a <alltraps>

80106aa7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $212
80106aa9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106aae:	e9 a7 f2 ff ff       	jmp    80105d5a <alltraps>

80106ab3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $213
80106ab5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106aba:	e9 9b f2 ff ff       	jmp    80105d5a <alltraps>

80106abf <vector214>:
.globl vector214
vector214:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $214
80106ac1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ac6:	e9 8f f2 ff ff       	jmp    80105d5a <alltraps>

80106acb <vector215>:
.globl vector215
vector215:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $215
80106acd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ad2:	e9 83 f2 ff ff       	jmp    80105d5a <alltraps>

80106ad7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $216
80106ad9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ade:	e9 77 f2 ff ff       	jmp    80105d5a <alltraps>

80106ae3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $217
80106ae5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aea:	e9 6b f2 ff ff       	jmp    80105d5a <alltraps>

80106aef <vector218>:
.globl vector218
vector218:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $218
80106af1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106af6:	e9 5f f2 ff ff       	jmp    80105d5a <alltraps>

80106afb <vector219>:
.globl vector219
vector219:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $219
80106afd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b02:	e9 53 f2 ff ff       	jmp    80105d5a <alltraps>

80106b07 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $220
80106b09:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b0e:	e9 47 f2 ff ff       	jmp    80105d5a <alltraps>

80106b13 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $221
80106b15:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b1a:	e9 3b f2 ff ff       	jmp    80105d5a <alltraps>

80106b1f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $222
80106b21:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b26:	e9 2f f2 ff ff       	jmp    80105d5a <alltraps>

80106b2b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $223
80106b2d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b32:	e9 23 f2 ff ff       	jmp    80105d5a <alltraps>

80106b37 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $224
80106b39:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b3e:	e9 17 f2 ff ff       	jmp    80105d5a <alltraps>

80106b43 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $225
80106b45:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b4a:	e9 0b f2 ff ff       	jmp    80105d5a <alltraps>

80106b4f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $226
80106b51:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b56:	e9 ff f1 ff ff       	jmp    80105d5a <alltraps>

80106b5b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $227
80106b5d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b62:	e9 f3 f1 ff ff       	jmp    80105d5a <alltraps>

80106b67 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $228
80106b69:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b6e:	e9 e7 f1 ff ff       	jmp    80105d5a <alltraps>

80106b73 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $229
80106b75:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b7a:	e9 db f1 ff ff       	jmp    80105d5a <alltraps>

80106b7f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $230
80106b81:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b86:	e9 cf f1 ff ff       	jmp    80105d5a <alltraps>

80106b8b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $231
80106b8d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b92:	e9 c3 f1 ff ff       	jmp    80105d5a <alltraps>

80106b97 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $232
80106b99:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b9e:	e9 b7 f1 ff ff       	jmp    80105d5a <alltraps>

80106ba3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $233
80106ba5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106baa:	e9 ab f1 ff ff       	jmp    80105d5a <alltraps>

80106baf <vector234>:
.globl vector234
vector234:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $234
80106bb1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106bb6:	e9 9f f1 ff ff       	jmp    80105d5a <alltraps>

80106bbb <vector235>:
.globl vector235
vector235:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $235
80106bbd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106bc2:	e9 93 f1 ff ff       	jmp    80105d5a <alltraps>

80106bc7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $236
80106bc9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bce:	e9 87 f1 ff ff       	jmp    80105d5a <alltraps>

80106bd3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $237
80106bd5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106bda:	e9 7b f1 ff ff       	jmp    80105d5a <alltraps>

80106bdf <vector238>:
.globl vector238
vector238:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $238
80106be1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106be6:	e9 6f f1 ff ff       	jmp    80105d5a <alltraps>

80106beb <vector239>:
.globl vector239
vector239:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $239
80106bed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bf2:	e9 63 f1 ff ff       	jmp    80105d5a <alltraps>

80106bf7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $240
80106bf9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bfe:	e9 57 f1 ff ff       	jmp    80105d5a <alltraps>

80106c03 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $241
80106c05:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c0a:	e9 4b f1 ff ff       	jmp    80105d5a <alltraps>

80106c0f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $242
80106c11:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c16:	e9 3f f1 ff ff       	jmp    80105d5a <alltraps>

80106c1b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $243
80106c1d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c22:	e9 33 f1 ff ff       	jmp    80105d5a <alltraps>

80106c27 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $244
80106c29:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c2e:	e9 27 f1 ff ff       	jmp    80105d5a <alltraps>

80106c33 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $245
80106c35:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c3a:	e9 1b f1 ff ff       	jmp    80105d5a <alltraps>

80106c3f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $246
80106c41:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c46:	e9 0f f1 ff ff       	jmp    80105d5a <alltraps>

80106c4b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $247
80106c4d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c52:	e9 03 f1 ff ff       	jmp    80105d5a <alltraps>

80106c57 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $248
80106c59:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c5e:	e9 f7 f0 ff ff       	jmp    80105d5a <alltraps>

80106c63 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $249
80106c65:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c6a:	e9 eb f0 ff ff       	jmp    80105d5a <alltraps>

80106c6f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $250
80106c71:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c76:	e9 df f0 ff ff       	jmp    80105d5a <alltraps>

80106c7b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $251
80106c7d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c82:	e9 d3 f0 ff ff       	jmp    80105d5a <alltraps>

80106c87 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $252
80106c89:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c8e:	e9 c7 f0 ff ff       	jmp    80105d5a <alltraps>

80106c93 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $253
80106c95:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c9a:	e9 bb f0 ff ff       	jmp    80105d5a <alltraps>

80106c9f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $254
80106ca1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ca6:	e9 af f0 ff ff       	jmp    80105d5a <alltraps>

80106cab <vector255>:
.globl vector255
vector255:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $255
80106cad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106cb2:	e9 a3 f0 ff ff       	jmp    80105d5a <alltraps>
80106cb7:	66 90                	xchg   %ax,%ax
80106cb9:	66 90                	xchg   %ax,%ax
80106cbb:	66 90                	xchg   %ax,%ax
80106cbd:	66 90                	xchg   %ax,%ax
80106cbf:	90                   	nop

80106cc0 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	89 d3                	mov    %edx,%ebx
//    if (DEBUGMODE == 2&& notShell())
//        cprintf("WALKPGDIR-");
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80106cc8:	c1 ea 16             	shr    $0x16,%edx
80106ccb:	8d 3c 90             	lea    (%eax,%edx,4),%edi

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106cce:	83 ec 0c             	sub    $0xc,%esp
//        cprintf("WALKPGDIR-");
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
80106cd1:	8b 07                	mov    (%edi),%eax
80106cd3:	a8 01                	test   $0x1,%al
80106cd5:	74 29                	je     80106d00 <walkpgdir+0x40>
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
80106cd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cdc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
//    if (DEBUGMODE == 2&& notShell())
//        cprintf(">WALKPGDIR-DONE!\t");
    return &pgtab[PTX(va)];
}
80106ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
//    if (DEBUGMODE == 2&& notShell())
//        cprintf(">WALKPGDIR-DONE!\t");
    return &pgtab[PTX(va)];
80106ce5:	c1 eb 0a             	shr    $0xa,%ebx
80106ce8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106cee:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106cf1:	5b                   	pop    %ebx
80106cf2:	5e                   	pop    %esi
80106cf3:	5f                   	pop    %edi
80106cf4:	5d                   	pop    %ebp
80106cf5:	c3                   	ret    
80106cf6:	8d 76 00             	lea    0x0(%esi),%esi
80106cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
    } else {
        if (!alloc)
80106d00:	85 c9                	test   %ecx,%ecx
80106d02:	74 2c                	je     80106d30 <walkpgdir+0x70>

        // TODO HERE WE CREATE PYSYC MEMORY;
        // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
        // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.

        if ((pgtab = (pte_t *) kalloc()) == 0)
80106d04:	e8 47 bb ff ff       	call   80102850 <kalloc>
80106d09:	85 c0                	test   %eax,%eax
80106d0b:	89 c6                	mov    %eax,%esi
80106d0d:	74 21                	je     80106d30 <walkpgdir+0x70>
            return 0;
        // Make sure all those PTE_P bits are zero.
        memset(pgtab, 0, PGSIZE);
80106d0f:	83 ec 04             	sub    $0x4,%esp
80106d12:	68 00 10 00 00       	push   $0x1000
80106d17:	6a 00                	push   $0x0
80106d19:	50                   	push   %eax
80106d1a:	e8 21 de ff ff       	call   80104b40 <memset>
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d1f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d25:	83 c4 10             	add    $0x10,%esp
80106d28:	83 c8 07             	or     $0x7,%eax
80106d2b:	89 07                	mov    %eax,(%edi)
80106d2d:	eb b3                	jmp    80106ce2 <walkpgdir+0x22>
80106d2f:	90                   	nop
    }
//    if (DEBUGMODE == 2&& notShell())
//        cprintf(">WALKPGDIR-DONE!\t");
    return &pgtab[PTX(va)];
}
80106d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
    } else {
        if (!alloc)
            return 0;
80106d33:	31 c0                	xor    %eax,%eax
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
//    if (DEBUGMODE == 2&& notShell())
//        cprintf(">WALKPGDIR-DONE!\t");
    return &pgtab[PTX(va)];
}
80106d35:	5b                   	pop    %ebx
80106d36:	5e                   	pop    %esi
80106d37:	5f                   	pop    %edi
80106d38:	5d                   	pop    %ebp
80106d39:	c3                   	ret    
80106d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d40 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d46:	89 d3                	mov    %edx,%ebx
80106d48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d4e:	83 ec 1c             	sub    $0x1c,%esp
80106d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d58:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d60:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d63:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d66:	29 df                	sub    %ebx,%edi
80106d68:	83 c8 01             	or     $0x1,%eax
80106d6b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d6e:	eb 15                	jmp    80106d85 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106d70:	f6 00 01             	testb  $0x1,(%eax)
80106d73:	75 45                	jne    80106dba <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d75:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106d78:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d7b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d7d:	74 31                	je     80106db0 <mappages+0x70>
      break;
    a += PGSIZE;
80106d7f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d88:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d8d:	89 da                	mov    %ebx,%edx
80106d8f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106d92:	e8 29 ff ff ff       	call   80106cc0 <walkpgdir>
80106d97:	85 c0                	test   %eax,%eax
80106d99:	75 d5                	jne    80106d70 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106d9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106da3:	5b                   	pop    %ebx
80106da4:	5e                   	pop    %esi
80106da5:	5f                   	pop    %edi
80106da6:	5d                   	pop    %ebp
80106da7:	c3                   	ret    
80106da8:	90                   	nop
80106da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106db0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106db3:	31 c0                	xor    %eax,%eax
}
80106db5:	5b                   	pop    %ebx
80106db6:	5e                   	pop    %esi
80106db7:	5f                   	pop    %edi
80106db8:	5d                   	pop    %ebp
80106db9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106dba:	83 ec 0c             	sub    $0xc,%esp
80106dbd:	68 34 82 10 80       	push   $0x80108234
80106dc2:	e8 a9 95 ff ff       	call   80100370 <panic>
80106dc7:	89 f6                	mov    %esi,%esi
80106dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dd0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106dd6:	e8 f5 cd ff ff       	call   80103bd0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ddb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106de1:	31 c9                	xor    %ecx,%ecx
80106de3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106de8:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
80106def:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106df6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106dfb:	31 c9                	xor    %ecx,%ecx
80106dfd:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e04:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e09:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e10:	31 c9                	xor    %ecx,%ecx
80106e12:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80106e19:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e20:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106e25:	31 c9                	xor    %ecx,%ecx
80106e27:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e2e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106e35:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e3a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80106e41:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80106e48:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e4f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
80106e56:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
80106e5d:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
80106e64:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e6b:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
80106e72:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
80106e79:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
80106e80:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e87:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
80106e8e:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
80106e95:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
80106e9c:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
80106ea3:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106eaa:	05 f0 37 11 80       	add    $0x801137f0,%eax
80106eaf:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106eb3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106eb7:	c1 e8 10             	shr    $0x10,%eax
80106eba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106ebe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ec1:	0f 01 10             	lgdtl  (%eax)
}
80106ec4:	c9                   	leave  
80106ec5:	c3                   	ret    
80106ec6:	8d 76 00             	lea    0x0(%esi),%esi
80106ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ed0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ed0:	a1 a4 69 12 80       	mov    0x801269a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106ed5:	55                   	push   %ebp
80106ed6:	89 e5                	mov    %esp,%ebp
80106ed8:	05 00 00 00 80       	add    $0x80000000,%eax
80106edd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106ee0:	5d                   	pop    %ebp
80106ee1:	c3                   	ret    
80106ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ef0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 1c             	sub    $0x1c,%esp
80106ef9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106efc:	85 f6                	test   %esi,%esi
80106efe:	0f 84 cd 00 00 00    	je     80106fd1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106f04:	8b 46 08             	mov    0x8(%esi),%eax
80106f07:	85 c0                	test   %eax,%eax
80106f09:	0f 84 dc 00 00 00    	je     80106feb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106f0f:	8b 7e 04             	mov    0x4(%esi),%edi
80106f12:	85 ff                	test   %edi,%edi
80106f14:	0f 84 c4 00 00 00    	je     80106fde <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80106f1a:	e8 71 da ff ff       	call   80104990 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f1f:	e8 2c cc ff ff       	call   80103b50 <mycpu>
80106f24:	89 c3                	mov    %eax,%ebx
80106f26:	e8 25 cc ff ff       	call   80103b50 <mycpu>
80106f2b:	89 c7                	mov    %eax,%edi
80106f2d:	e8 1e cc ff ff       	call   80103b50 <mycpu>
80106f32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f35:	83 c7 08             	add    $0x8,%edi
80106f38:	e8 13 cc ff ff       	call   80103b50 <mycpu>
80106f3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f40:	83 c0 08             	add    $0x8,%eax
80106f43:	ba 67 00 00 00       	mov    $0x67,%edx
80106f48:	c1 e8 18             	shr    $0x18,%eax
80106f4b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106f52:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106f59:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106f60:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106f67:	83 c1 08             	add    $0x8,%ecx
80106f6a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106f70:	c1 e9 10             	shr    $0x10,%ecx
80106f73:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f79:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106f7e:	e8 cd cb ff ff       	call   80103b50 <mycpu>
80106f83:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f8a:	e8 c1 cb ff ff       	call   80103b50 <mycpu>
80106f8f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106f94:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f98:	e8 b3 cb ff ff       	call   80103b50 <mycpu>
80106f9d:	8b 56 08             	mov    0x8(%esi),%edx
80106fa0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106fa6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fa9:	e8 a2 cb ff ff       	call   80103b50 <mycpu>
80106fae:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106fb2:	b8 28 00 00 00       	mov    $0x28,%eax
80106fb7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fba:	8b 46 04             	mov    0x4(%esi),%eax
80106fbd:	05 00 00 00 80       	add    $0x80000000,%eax
80106fc2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106fc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fc8:	5b                   	pop    %ebx
80106fc9:	5e                   	pop    %esi
80106fca:	5f                   	pop    %edi
80106fcb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106fcc:	e9 af da ff ff       	jmp    80104a80 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106fd1:	83 ec 0c             	sub    $0xc,%esp
80106fd4:	68 3a 82 10 80       	push   $0x8010823a
80106fd9:	e8 92 93 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106fde:	83 ec 0c             	sub    $0xc,%esp
80106fe1:	68 65 82 10 80       	push   $0x80108265
80106fe6:	e8 85 93 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106feb:	83 ec 0c             	sub    $0xc,%esp
80106fee:	68 50 82 10 80       	push   $0x80108250
80106ff3:	e8 78 93 ff ff       	call   80100370 <panic>
80106ff8:	90                   	nop
80106ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107000 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
80107006:	83 ec 1c             	sub    $0x1c,%esp
80107009:	8b 75 10             	mov    0x10(%ebp),%esi
8010700c:	8b 45 08             	mov    0x8(%ebp),%eax
8010700f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107012:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107018:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010701b:	77 49                	ja     80107066 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010701d:	e8 2e b8 ff ff       	call   80102850 <kalloc>
  memset(mem, 0, PGSIZE);
80107022:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107025:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107027:	68 00 10 00 00       	push   $0x1000
8010702c:	6a 00                	push   $0x0
8010702e:	50                   	push   %eax
8010702f:	e8 0c db ff ff       	call   80104b40 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107034:	58                   	pop    %eax
80107035:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010703b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107040:	5a                   	pop    %edx
80107041:	6a 06                	push   $0x6
80107043:	50                   	push   %eax
80107044:	31 d2                	xor    %edx,%edx
80107046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107049:	e8 f2 fc ff ff       	call   80106d40 <mappages>
  memmove(mem, init, sz);
8010704e:	89 75 10             	mov    %esi,0x10(%ebp)
80107051:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107054:	83 c4 10             	add    $0x10,%esp
80107057:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010705a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010705d:	5b                   	pop    %ebx
8010705e:	5e                   	pop    %esi
8010705f:	5f                   	pop    %edi
80107060:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107061:	e9 8a db ff ff       	jmp    80104bf0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107066:	83 ec 0c             	sub    $0xc,%esp
80107069:	68 79 82 10 80       	push   $0x80108279
8010706e:	e8 fd 92 ff ff       	call   80100370 <panic>
80107073:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107080 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107089:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107090:	0f 85 91 00 00 00    	jne    80107127 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107096:	8b 75 18             	mov    0x18(%ebp),%esi
80107099:	31 db                	xor    %ebx,%ebx
8010709b:	85 f6                	test   %esi,%esi
8010709d:	75 1a                	jne    801070b9 <loaduvm+0x39>
8010709f:	eb 6f                	jmp    80107110 <loaduvm+0x90>
801070a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070ae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801070b4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801070b7:	76 57                	jbe    80107110 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801070bc:	8b 45 08             	mov    0x8(%ebp),%eax
801070bf:	31 c9                	xor    %ecx,%ecx
801070c1:	01 da                	add    %ebx,%edx
801070c3:	e8 f8 fb ff ff       	call   80106cc0 <walkpgdir>
801070c8:	85 c0                	test   %eax,%eax
801070ca:	74 4e                	je     8010711a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801070cc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
801070d1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801070d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070db:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801070e1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070e4:	01 d9                	add    %ebx,%ecx
801070e6:	05 00 00 00 80       	add    $0x80000000,%eax
801070eb:	57                   	push   %edi
801070ec:	51                   	push   %ecx
801070ed:	50                   	push   %eax
801070ee:	ff 75 10             	pushl  0x10(%ebp)
801070f1:	e8 7a a8 ff ff       	call   80101970 <readi>
801070f6:	83 c4 10             	add    $0x10,%esp
801070f9:	39 c7                	cmp    %eax,%edi
801070fb:	74 ab                	je     801070a8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801070fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107105:	5b                   	pop    %ebx
80107106:	5e                   	pop    %esi
80107107:	5f                   	pop    %edi
80107108:	5d                   	pop    %ebp
80107109:	c3                   	ret    
8010710a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107110:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107113:	31 c0                	xor    %eax,%eax
}
80107115:	5b                   	pop    %ebx
80107116:	5e                   	pop    %esi
80107117:	5f                   	pop    %edi
80107118:	5d                   	pop    %ebp
80107119:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010711a:	83 ec 0c             	sub    $0xc,%esp
8010711d:	68 93 82 10 80       	push   $0x80108293
80107122:	e8 49 92 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107127:	83 ec 0c             	sub    $0xc,%esp
8010712a:	68 44 83 10 80       	push   $0x80108344
8010712f:	e8 3c 92 ff ff       	call   80100370 <panic>
80107134:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010713a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107140 <findFreeEntryInSwapFile>:
  }
  return 0;
}

int
findFreeEntryInSwapFile(struct proc *p){
80107140:	55                   	push   %ebp
  for(int i=0; i<MAX_PSYC_PAGES; i++){
80107141:	31 c0                	xor    %eax,%eax
  }
  return 0;
}

int
findFreeEntryInSwapFile(struct proc *p){
80107143:	89 e5                	mov    %esp,%ebp
80107145:	8b 55 08             	mov    0x8(%ebp),%edx
80107148:	90                   	nop
80107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(int i=0; i<MAX_PSYC_PAGES; i++){
    if(!p->swapFileEntries[i])
80107150:	8b 8c 82 00 04 00 00 	mov    0x400(%edx,%eax,4),%ecx
80107157:	85 c9                	test   %ecx,%ecx
80107159:	74 0d                	je     80107168 <findFreeEntryInSwapFile+0x28>
  return 0;
}

int
findFreeEntryInSwapFile(struct proc *p){
  for(int i=0; i<MAX_PSYC_PAGES; i++){
8010715b:	83 c0 01             	add    $0x1,%eax
8010715e:	83 f8 10             	cmp    $0x10,%eax
80107161:	75 ed                	jne    80107150 <findFreeEntryInSwapFile+0x10>
    if(!p->swapFileEntries[i])
      return i;
  }
  return -1;
80107163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107168:	5d                   	pop    %ebp
80107169:	c3                   	ret    
8010716a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107170 <deallocuvm>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz , int growproc) {
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
80107176:	83 ec 1c             	sub    $0x1c,%esp
    if (DEBUGMODE == 2 && notShell())
        cprintf("DEALLOCUVM-");
    pte_t *pte;
    uint a, pa;
    struct page *pg;
    struct proc *p = myproc();
80107179:	e8 72 ca ff ff       	call   80103bf0 <myproc>
8010717e:	89 c7                	mov    %eax,%edi

    if (newsz >= oldsz) {
80107180:	8b 45 0c             	mov    0xc(%ebp),%eax
80107183:	39 45 10             	cmp    %eax,0x10(%ebp)
80107186:	0f 83 a5 00 00 00    	jae    80107231 <deallocuvm+0xc1>
        if (DEBUGMODE == 2 && notShell())
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
8010718c:	8b 45 10             	mov    0x10(%ebp),%eax
        } else if ((*pte & PTE_PG) != 0) {
            pa = PTE_ADDR(*pte);
            if (pa == 0)
                panic("kfree");
            if (p->pid > 2 && growproc){
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
8010718f:	8d b7 00 04 00 00    	lea    0x400(%edi),%esi
        if (DEBUGMODE == 2 && notShell())
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
80107195:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010719b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; a < oldsz; a += PGSIZE) {
801071a1:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801071a4:	0f 86 84 00 00 00    	jbe    8010722e <deallocuvm+0xbe>
801071aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pte = walkpgdir(pgdir, (char *) a, 0);
801071b0:	8b 45 08             	mov    0x8(%ebp),%eax
801071b3:	31 c9                	xor    %ecx,%ecx
801071b5:	89 da                	mov    %ebx,%edx
801071b7:	e8 04 fb ff ff       	call   80106cc0 <walkpgdir>
        if (!pte)
801071bc:	85 c0                	test   %eax,%eax
801071be:	0f 84 c4 00 00 00    	je     80107288 <deallocuvm+0x118>
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        else if ((*pte & PTE_P) != 0) {
801071c4:	8b 10                	mov    (%eax),%edx
801071c6:	f6 c2 01             	test   $0x1,%dl
801071c9:	74 75                	je     80107240 <deallocuvm+0xd0>
            pa = PTE_ADDR(*pte);
            if (pa == 0)
801071cb:	89 d1                	mov    %edx,%ecx
801071cd:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
801071d3:	0f 84 d2 00 00 00    	je     801072ab <deallocuvm+0x13b>
                panic("kfree");
            if (p->pid > 2 && growproc){
801071d9:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
801071dd:	7e 26                	jle    80107205 <deallocuvm+0x95>
801071df:	8b 55 14             	mov    0x14(%ebp),%edx
801071e2:	85 d2                	test   %edx,%edx
801071e4:	74 1f                	je     80107205 <deallocuvm+0x95>
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801071e6:	8d 97 80 00 00 00    	lea    0x80(%edi),%edx
801071ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    if ( pg->active && pg->virtAdress == (char *)a )
801071f0:	83 3a 00             	cmpl   $0x0,(%edx)
801071f3:	74 09                	je     801071fe <deallocuvm+0x8e>
801071f5:	3b 5a 18             	cmp    0x18(%edx),%ebx
801071f8:	0f 84 a2 00 00 00    	je     801072a0 <deallocuvm+0x130>
        else if ((*pte & PTE_P) != 0) {
            pa = PTE_ADDR(*pte);
            if (pa == 0)
                panic("kfree");
            if (p->pid > 2 && growproc){
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801071fe:	83 c2 1c             	add    $0x1c,%edx
80107201:	39 f2                	cmp    %esi,%edx
80107203:	72 eb                	jb     801071f0 <deallocuvm+0x80>
                        //must cleare page


                }
            char *v = P2V(pa);
            kfree(v);
80107205:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
8010720b:	83 ec 0c             	sub    $0xc,%esp
8010720e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107211:	52                   	push   %edx
80107212:	e8 89 b4 ff ff       	call   801026a0 <kfree>
            *pte = 0;
80107217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010721a:	83 c4 10             	add    $0x10,%esp
8010721d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
    for (; a < oldsz; a += PGSIZE) {
80107223:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107229:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
8010722c:	77 82                	ja     801071b0 <deallocuvm+0x40>

        }
    }
    if (DEBUGMODE == 2 && notShell())
        cprintf(">DEALLOCUVM-DONE!\t");
    return newsz;
8010722e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107231:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107234:	5b                   	pop    %ebx
80107235:	5e                   	pop    %esi
80107236:	5f                   	pop    %edi
80107237:	5d                   	pop    %ebp
80107238:	c3                   	ret    
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

                }
            char *v = P2V(pa);
            kfree(v);
            *pte = 0;
        } else if ((*pte & PTE_PG) != 0) {
80107240:	f6 c6 02             	test   $0x2,%dh
80107243:	74 de                	je     80107223 <deallocuvm+0xb3>
            pa = PTE_ADDR(*pte);
            if (pa == 0)
80107245:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010724b:	74 5e                	je     801072ab <deallocuvm+0x13b>
                panic("kfree");
            if (p->pid > 2 && growproc){
8010724d:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107251:	7e d0                	jle    80107223 <deallocuvm+0xb3>
80107253:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107256:	85 c9                	test   %ecx,%ecx
80107258:	74 c9                	je     80107223 <deallocuvm+0xb3>
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
8010725a:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
80107260:	eb 0d                	jmp    8010726f <deallocuvm+0xff>
80107262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107268:	83 c0 1c             	add    $0x1c,%eax
8010726b:	39 f0                	cmp    %esi,%eax
8010726d:	73 b4                	jae    80107223 <deallocuvm+0xb3>
                    if ( pg->active && pg->virtAdress == (char *)a )
8010726f:	8b 10                	mov    (%eax),%edx
80107271:	85 d2                	test   %edx,%edx
80107273:	74 f3                	je     80107268 <deallocuvm+0xf8>
80107275:	3b 58 18             	cmp    0x18(%eax),%ebx
80107278:	75 ee                	jne    80107268 <deallocuvm+0xf8>
                    {
                        pg->active = 0;
8010727a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                        break;
80107280:	eb a1                	jmp    80107223 <deallocuvm+0xb3>
80107282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    a = PGROUNDUP(newsz);
    for (; a < oldsz; a += PGSIZE) {
        pte = walkpgdir(pgdir, (char *) a, 0);
        if (!pte)
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107288:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010728e:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
80107294:	eb 8d                	jmp    80107223 <deallocuvm+0xb3>
80107296:	8d 76 00             	lea    0x0(%esi),%esi
80107299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                panic("kfree");
            if (p->pid > 2 && growproc){
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
                    if ( pg->active && pg->virtAdress == (char *)a )
                    {
                        pg->active = 0;
801072a0:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
                        break;
801072a6:	e9 5a ff ff ff       	jmp    80107205 <deallocuvm+0x95>
        if (!pte)
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        else if ((*pte & PTE_P) != 0) {
            pa = PTE_ADDR(*pte);
            if (pa == 0)
                panic("kfree");
801072ab:	83 ec 0c             	sub    $0xc,%esp
801072ae:	68 8a 7b 10 80       	push   $0x80107b8a
801072b3:	e8 b8 90 ff ff       	call   80100370 <panic>
801072b8:	90                   	nop
801072b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072c0 <allocuvm>:
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	57                   	push   %edi
801072c4:	56                   	push   %esi
801072c5:	53                   	push   %ebx
801072c6:	83 ec 1c             	sub    $0x1c,%esp
  if (DEBUGMODE == 2&& notShell())
    cprintf("ALLOCUVM-");
  char *mem;
  uint a;
  int maxSeq = 0, swapWriteOffset,tmpOffset;
  struct proc *p = myproc();
801072c9:	e8 22 c9 ff ff       	call   80103bf0 <myproc>
  struct page *pg=0, *cg=0;
  pde_t *pgtble;

  if (newsz >= KERNBASE){
801072ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
801072d1:	85 db                	test   %ebx,%ebx
801072d3:	0f 88 87 02 00 00    	js     80107560 <allocuvm+0x2a0>
801072d9:	89 c6                	mov    %eax,%esi
    if (DEBUGMODE == 2&& notShell())
      cprintf(">ALLOCUVM-FAILED");
    return 0;
  }
  if (newsz < oldsz){
801072db:	8b 45 0c             	mov    0xc(%ebp),%eax
801072de:	39 45 10             	cmp    %eax,0x10(%ebp)
801072e1:	0f 82 e4 00 00 00    	jb     801073cb <allocuvm+0x10b>
      cprintf(">ALLOCUVM-FAILED");
    return oldsz;
  }


  a = PGROUNDUP(oldsz);
801072e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801072ea:	05 ff 0f 00 00       	add    $0xfff,%eax
801072ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for (; a < newsz; a += PGSIZE) {
801072f4:	39 45 10             	cmp    %eax,0x10(%ebp)
      cprintf(">ALLOCUVM-FAILED");
    return oldsz;
  }


  a = PGROUNDUP(oldsz);
801072f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for (; a < newsz; a += PGSIZE) {
801072fa:	0f 86 6a 02 00 00    	jbe    8010756a <allocuvm+0x2aa>
      // TODO HERE WE CREATE PYSYC MEMORY;
      // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
      // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.

    if(p->pagesCounter == MAX_TOTAL_PAGES)
80107300:	8b 86 44 04 00 00    	mov    0x444(%esi),%eax
80107306:	83 f8 20             	cmp    $0x20,%eax
80107309:	0f 84 3e 02 00 00    	je     8010754d <allocuvm+0x28d>
      panic("got 32 pages and requested for another page!");

    // if number of pages overall minus pages in swap is more than 16 we have prob
    if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2 ) {
      //find the page to swap out - by LIFO
      for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
8010730f:	8d 8e 00 04 00 00    	lea    0x400(%esi),%ecx
  for (; a < newsz; a += PGSIZE) {
      // TODO HERE WE CREATE PYSYC MEMORY;
      // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
      // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.

    if(p->pagesCounter == MAX_TOTAL_PAGES)
80107315:	31 db                	xor    %ebx,%ebx
80107317:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
      panic("got 32 pages and requested for another page!");

    // if number of pages overall minus pages in swap is more than 16 we have prob
    if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2 ) {
      //find the page to swap out - by LIFO
      for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
8010731e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80107321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    if(p->pagesCounter == MAX_TOTAL_PAGES)
      panic("got 32 pages and requested for another page!");

    // if number of pages overall minus pages in swap is more than 16 we have prob
    if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2 ) {
80107328:	2b 86 48 04 00 00    	sub    0x448(%esi),%eax
8010732e:	83 f8 0f             	cmp    $0xf,%eax
80107331:	0f 8e 20 01 00 00    	jle    80107457 <allocuvm+0x197>
80107337:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
8010733b:	0f 8e 16 01 00 00    	jle    80107457 <allocuvm+0x197>
      //find the page to swap out - by LIFO
      for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
80107341:	8b 7d dc             	mov    -0x24(%ebp),%edi
80107344:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107347:	8d 86 80 00 00 00    	lea    0x80(%esi),%eax
8010734d:	8d 76 00             	lea    0x0(%esi),%esi
          if (cg->active && cg->present && cg->sequel > maxSeq) {
80107350:	8b 08                	mov    (%eax),%ecx
80107352:	85 c9                	test   %ecx,%ecx
80107354:	74 1a                	je     80107370 <allocuvm+0xb0>
80107356:	8b 48 0c             	mov    0xc(%eax),%ecx
80107359:	85 c9                	test   %ecx,%ecx
8010735b:	74 13                	je     80107370 <allocuvm+0xb0>
8010735d:	8b 48 08             	mov    0x8(%eax),%ecx
80107360:	39 f9                	cmp    %edi,%ecx
80107362:	7e 0c                	jle    80107370 <allocuvm+0xb0>
80107364:	89 c3                	mov    %eax,%ebx
80107366:	89 cf                	mov    %ecx,%edi
80107368:	90                   	nop
80107369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("got 32 pages and requested for another page!");

    // if number of pages overall minus pages in swap is more than 16 we have prob
    if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2 ) {
      //find the page to swap out - by LIFO
      for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
80107370:	83 c0 1c             	add    $0x1c,%eax
80107373:	39 d0                	cmp    %edx,%eax
80107375:	72 d9                	jb     80107350 <allocuvm+0x90>
80107377:	89 7d dc             	mov    %edi,-0x24(%ebp)
8010737a:	31 ff                	xor    %edi,%edi
8010737c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
findFreeEntryInSwapFile(struct proc *p){
  for(int i=0; i<MAX_PSYC_PAGES; i++){
    if(!p->swapFileEntries[i])
80107380:	8b 8c be 00 04 00 00 	mov    0x400(%esi,%edi,4),%ecx
80107387:	85 c9                	test   %ecx,%ecx
80107389:	74 4d                	je     801073d8 <allocuvm+0x118>
  return 0;
}

int
findFreeEntryInSwapFile(struct proc *p){
  for(int i=0; i<MAX_PSYC_PAGES; i++){
8010738b:	83 c7 01             	add    $0x1,%edi
8010738e:	83 ff 10             	cmp    $0x10,%edi
80107391:	75 ed                	jne    80107380 <allocuvm+0xc0>
          }
      }
        //got here - the page to swat out is pg
      tmpOffset=findFreeEntryInSwapFile(p);
      if(tmpOffset  == -1) //validy check
          panic("ERROR - there is no free entry in p->swapFileEntries!\n");
80107393:	83 ec 0c             	sub    $0xc,%esp
80107396:	68 98 83 10 80       	push   $0x80108398
8010739b:	e8 d0 8f ff ff       	call   80100370 <panic>
        cprintf(">ALLOCUVM-FAILED-mem == 0\t");
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
      cprintf("allocuvm out of memory (2)\n");
801073a0:	83 ec 0c             	sub    $0xc,%esp
801073a3:	68 c9 82 10 80       	push   $0x801082c9
801073a8:	e8 b3 92 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz , 0);
801073ad:	6a 00                	push   $0x0
801073af:	ff 75 0c             	pushl  0xc(%ebp)
801073b2:	ff 75 10             	pushl  0x10(%ebp)
801073b5:	ff 75 08             	pushl  0x8(%ebp)
801073b8:	e8 b3 fd ff ff       	call   80107170 <deallocuvm>
      kfree(mem);
801073bd:	83 c4 14             	add    $0x14,%esp
801073c0:	57                   	push   %edi
801073c1:	e8 da b2 ff ff       	call   801026a0 <kfree>
      if (DEBUGMODE == 2&& notShell())
        cprintf(">ALLOCUVM-FAILED-mappages<0\t");
      return 0;
801073c6:	83 c4 10             	add    $0x10,%esp
801073c9:	31 c0                	xor    %eax,%eax

  }
  if (DEBUGMODE == 2&& notShell())
    cprintf(">ALLOCUVM-DONE!\t");
  return newsz;
}
801073cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ce:	5b                   	pop    %ebx
801073cf:	5e                   	pop    %esi
801073d0:	5f                   	pop    %edi
801073d1:	5d                   	pop    %ebp
801073d2:	c3                   	ret    
801073d3:	90                   	nop
801073d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(tmpOffset  == -1) //validy check
          panic("ERROR - there is no free entry in p->swapFileEntries!\n");

      swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
        //write the page to swapFile
      writeToSwapFile(p ,pg->physAdress, (uint) swapWriteOffset, PGSIZE);
801073d8:	89 fa                	mov    %edi,%edx
801073da:	68 00 10 00 00       	push   $0x1000
801073df:	c1 e2 0c             	shl    $0xc,%edx
801073e2:	52                   	push   %edx
801073e3:	ff 73 14             	pushl  0x14(%ebx)
801073e6:	56                   	push   %esi
801073e7:	89 55 d8             	mov    %edx,-0x28(%ebp)
801073ea:	e8 71 ae ff ff       	call   80102260 <writeToSwapFile>
      //update page
      pg->present = 0;
      pg->offset = (uint) swapWriteOffset;
801073ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
      pg->physAdress = 0;
801073f2:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

      //update proc
      p->swapFileEntries[tmpOffset] = 1; //update that this entry is taken
      p->pagesinSwap++;

      pgtble = walkpgdir( pgdir ,(void *)pg->physAdress , 0 );
801073f9:	31 c9                	xor    %ecx,%ecx

      swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
        //write the page to swapFile
      writeToSwapFile(p ,pg->physAdress, (uint) swapWriteOffset, PGSIZE);
      //update page
      pg->present = 0;
801073fb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
      pg->offset = (uint) swapWriteOffset;
      pg->physAdress = 0;
      pg->sequel = 0;
80107402:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)

      //update proc
      p->swapFileEntries[tmpOffset] = 1; //update that this entry is taken
      p->pagesinSwap++;

      pgtble = walkpgdir( pgdir ,(void *)pg->physAdress , 0 );
80107409:	8b 45 08             	mov    0x8(%ebp),%eax
      swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
        //write the page to swapFile
      writeToSwapFile(p ,pg->physAdress, (uint) swapWriteOffset, PGSIZE);
      //update page
      pg->present = 0;
      pg->offset = (uint) swapWriteOffset;
8010740c:	89 53 10             	mov    %edx,0x10(%ebx)
      pg->physAdress = 0;
      pg->sequel = 0;

      //update proc
      p->swapFileEntries[tmpOffset] = 1; //update that this entry is taken
8010740f:	c7 84 be 00 04 00 00 	movl   $0x1,0x400(%esi,%edi,4)
80107416:	01 00 00 00 
      p->pagesinSwap++;
8010741a:	83 86 48 04 00 00 01 	addl   $0x1,0x448(%esi)

      pgtble = walkpgdir( pgdir ,(void *)pg->physAdress , 0 );
80107421:	8b 53 14             	mov    0x14(%ebx),%edx
80107424:	e8 97 f8 ff ff       	call   80106cc0 <walkpgdir>
      *pgtble = PTE_P_0(*pgtble);
80107429:	8b 10                	mov    (%eax),%edx
      *pgtble = PTE_PG_1(*pgtble);
8010742b:	89 d1                	mov    %edx,%ecx

      kfree( P2V( PTE_ADDR( *pgtble ) ) );
8010742d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      p->swapFileEntries[tmpOffset] = 1; //update that this entry is taken
      p->pagesinSwap++;

      pgtble = walkpgdir( pgdir ,(void *)pg->physAdress , 0 );
      *pgtble = PTE_P_0(*pgtble);
      *pgtble = PTE_PG_1(*pgtble);
80107433:	83 e1 fe             	and    $0xfffffffe,%ecx

      kfree( P2V( PTE_ADDR( *pgtble ) ) );
80107436:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      p->swapFileEntries[tmpOffset] = 1; //update that this entry is taken
      p->pagesinSwap++;

      pgtble = walkpgdir( pgdir ,(void *)pg->physAdress , 0 );
      *pgtble = PTE_P_0(*pgtble);
      *pgtble = PTE_PG_1(*pgtble);
8010743c:	80 cd 02             	or     $0x2,%ch
8010743f:	89 08                	mov    %ecx,(%eax)

      kfree( P2V( PTE_ADDR( *pgtble ) ) );
80107441:	89 14 24             	mov    %edx,(%esp)
80107444:	e8 57 b2 ff ff       	call   801026a0 <kfree>
80107449:	8b 46 04             	mov    0x4(%esi),%eax
8010744c:	05 00 00 00 80       	add    $0x80000000,%eax
80107451:	0f 22 d8             	mov    %eax,%cr3
80107454:	83 c4 10             	add    $0x10,%esp
      lcr3(V2P(p->pgdir));

    }

    mem = kalloc();
80107457:	e8 f4 b3 ff ff       	call   80102850 <kalloc>
    if (mem == 0) {
8010745c:	85 c0                	test   %eax,%eax
      kfree( P2V( PTE_ADDR( *pgtble ) ) );
      lcr3(V2P(p->pgdir));

    }

    mem = kalloc();
8010745e:	89 c7                	mov    %eax,%edi
    if (mem == 0) {
80107460:	0f 84 0f 01 00 00    	je     80107575 <allocuvm+0x2b5>
      deallocuvm(pgdir, newsz, oldsz , 0);
      if (DEBUGMODE == 2&& notShell())
        cprintf(">ALLOCUVM-FAILED-mem == 0\t");
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107466:	83 ec 04             	sub    $0x4,%esp
80107469:	68 00 10 00 00       	push   $0x1000
8010746e:	6a 00                	push   $0x0
80107470:	50                   	push   %eax
80107471:	e8 ca d6 ff ff       	call   80104b40 <memset>
    if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80107476:	58                   	pop    %eax
80107477:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
8010747d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107482:	5a                   	pop    %edx
80107483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107486:	6a 06                	push   $0x6
80107488:	50                   	push   %eax
80107489:	8b 45 08             	mov    0x8(%ebp),%eax
8010748c:	e8 af f8 ff ff       	call   80106d40 <mappages>
80107491:	83 c4 10             	add    $0x10,%esp
80107494:	85 c0                	test   %eax,%eax
80107496:	0f 88 04 ff ff ff    	js     801073a0 <allocuvm+0xe0>
        cprintf(">ALLOCUVM-FAILED-mappages<0\t");
      return 0;
    }


    if(p->pid > 2) {
8010749c:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
801074a0:	0f 8e 89 00 00 00    	jle    8010752f <allocuvm+0x26f>
      //TODO INIT PAGE STRUCT
      for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
        if (!pg->active)
801074a6:	8b 8e 80 00 00 00    	mov    0x80(%esi),%ecx
    }


    if(p->pid > 2) {
      //TODO INIT PAGE STRUCT
      for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801074ac:	8d 9e 80 00 00 00    	lea    0x80(%esi),%ebx
801074b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
        if (!pg->active)
801074b5:	85 c9                	test   %ecx,%ecx
801074b7:	74 18                	je     801074d1 <allocuvm+0x211>
801074b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }


    if(p->pid > 2) {
      //TODO INIT PAGE STRUCT
      for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801074c0:	83 c3 1c             	add    $0x1c,%ebx
801074c3:	39 c3                	cmp    %eax,%ebx
801074c5:	0f 83 d4 00 00 00    	jae    8010759f <allocuvm+0x2df>
        if (!pg->active)
801074cb:	8b 13                	mov    (%ebx),%edx
801074cd:	85 d2                	test   %edx,%edx
801074cf:	75 ef                	jne    801074c0 <allocuvm+0x200>
      }

      panic("no page in proc");

        foundpage:
      p->pagesCounter++;
801074d1:	83 86 44 04 00 00 01 	addl   $0x1,0x444(%esi)
      pg->active = 1;
801074d8:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      pg->sequel = p->pagesequel++;
      pg->physAdress = mem;
      pg->virtAdress = (char *)a;


      pgtble = walkpgdir(pgdir, (char *)a, 0);
801074de:	31 c9                	xor    %ecx,%ecx
      panic("no page in proc");

        foundpage:
      p->pagesCounter++;
      pg->active = 1;
      pg->pageid = p->nextpageid++;
801074e0:	8b 86 40 04 00 00    	mov    0x440(%esi),%eax
801074e6:	8d 50 01             	lea    0x1(%eax),%edx
801074e9:	89 96 40 04 00 00    	mov    %edx,0x440(%esi)
801074ef:	89 43 04             	mov    %eax,0x4(%ebx)
      pg->present = 1;
801074f2:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
      pg->offset = 0;
801074f9:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
      pg->sequel = p->pagesequel++;
80107500:	8b 86 4c 04 00 00    	mov    0x44c(%esi),%eax
80107506:	8d 50 01             	lea    0x1(%eax),%edx
80107509:	89 96 4c 04 00 00    	mov    %edx,0x44c(%esi)
8010750f:	89 43 08             	mov    %eax,0x8(%ebx)
      pg->physAdress = mem;
      pg->virtAdress = (char *)a;
80107512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      pg->active = 1;
      pg->pageid = p->nextpageid++;
      pg->present = 1;
      pg->offset = 0;
      pg->sequel = p->pagesequel++;
      pg->physAdress = mem;
80107515:	89 7b 14             	mov    %edi,0x14(%ebx)
      pg->virtAdress = (char *)a;


      pgtble = walkpgdir(pgdir, (char *)a, 0);
80107518:	89 c2                	mov    %eax,%edx
      pg->pageid = p->nextpageid++;
      pg->present = 1;
      pg->offset = 0;
      pg->sequel = p->pagesequel++;
      pg->physAdress = mem;
      pg->virtAdress = (char *)a;
8010751a:	89 43 18             	mov    %eax,0x18(%ebx)


      pgtble = walkpgdir(pgdir, (char *)a, 0);
8010751d:	8b 45 08             	mov    0x8(%ebp),%eax
80107520:	e8 9b f7 ff ff       	call   80106cc0 <walkpgdir>
      *pgtble = PTE_P_1(*pgtble);  // Present
      *pgtble = PTE_PG_0(*pgtble); // Not Paged out to secondary storage
80107525:	8b 10                	mov    (%eax),%edx
80107527:	80 e6 fd             	and    $0xfd,%dh
8010752a:	83 ca 01             	or     $0x1,%edx
8010752d:	89 10                	mov    %edx,(%eax)
    return oldsz;
  }


  a = PGROUNDUP(oldsz);
  for (; a < newsz; a += PGSIZE) {
8010752f:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
80107536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107539:	39 45 10             	cmp    %eax,0x10(%ebp)
8010753c:	76 2c                	jbe    8010756a <allocuvm+0x2aa>
      // TODO HERE WE CREATE PYSYC MEMORY;
      // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
      // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.

    if(p->pagesCounter == MAX_TOTAL_PAGES)
8010753e:	8b 86 44 04 00 00    	mov    0x444(%esi),%eax
80107544:	83 f8 20             	cmp    $0x20,%eax
80107547:	0f 85 db fd ff ff    	jne    80107328 <allocuvm+0x68>
      panic("got 32 pages and requested for another page!");
8010754d:	83 ec 0c             	sub    $0xc,%esp
80107550:	68 68 83 10 80       	push   $0x80108368
80107555:	e8 16 8e ff ff       	call   80100370 <panic>
8010755a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  }
  if (DEBUGMODE == 2&& notShell())
    cprintf(">ALLOCUVM-DONE!\t");
  return newsz;
}
80107560:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde_t *pgtble;

  if (newsz >= KERNBASE){
    if (DEBUGMODE == 2&& notShell())
      cprintf(">ALLOCUVM-FAILED");
    return 0;
80107563:	31 c0                	xor    %eax,%eax

  }
  if (DEBUGMODE == 2&& notShell())
    cprintf(">ALLOCUVM-DONE!\t");
  return newsz;
}
80107565:	5b                   	pop    %ebx
80107566:	5e                   	pop    %esi
80107567:	5f                   	pop    %edi
80107568:	5d                   	pop    %ebp
80107569:	c3                   	ret    
    return oldsz;
  }


  a = PGROUNDUP(oldsz);
  for (; a < newsz; a += PGSIZE) {
8010756a:	8b 45 10             	mov    0x10(%ebp),%eax

  }
  if (DEBUGMODE == 2&& notShell())
    cprintf(">ALLOCUVM-DONE!\t");
  return newsz;
}
8010756d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107570:	5b                   	pop    %ebx
80107571:	5e                   	pop    %esi
80107572:	5f                   	pop    %edi
80107573:	5d                   	pop    %ebp
80107574:	c3                   	ret    

    }

    mem = kalloc();
    if (mem == 0) {
      cprintf("allocuvm out of memory\n");
80107575:	83 ec 0c             	sub    $0xc,%esp
80107578:	68 b1 82 10 80       	push   $0x801082b1
8010757d:	e8 de 90 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz , 0);
80107582:	6a 00                	push   $0x0
80107584:	ff 75 0c             	pushl  0xc(%ebp)
80107587:	ff 75 10             	pushl  0x10(%ebp)
8010758a:	ff 75 08             	pushl  0x8(%ebp)
8010758d:	e8 de fb ff ff       	call   80107170 <deallocuvm>
      if (DEBUGMODE == 2&& notShell())
        cprintf(">ALLOCUVM-FAILED-mem == 0\t");
      return 0;
80107592:	83 c4 20             	add    $0x20,%esp

  }
  if (DEBUGMODE == 2&& notShell())
    cprintf(">ALLOCUVM-DONE!\t");
  return newsz;
}
80107595:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if (mem == 0) {
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz , 0);
      if (DEBUGMODE == 2&& notShell())
        cprintf(">ALLOCUVM-FAILED-mem == 0\t");
      return 0;
80107598:	31 c0                	xor    %eax,%eax

  }
  if (DEBUGMODE == 2&& notShell())
    cprintf(">ALLOCUVM-DONE!\t");
  return newsz;
}
8010759a:	5b                   	pop    %ebx
8010759b:	5e                   	pop    %esi
8010759c:	5f                   	pop    %edi
8010759d:	5d                   	pop    %ebp
8010759e:	c3                   	ret    
      for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
        if (!pg->active)
          goto foundpage;
      }

      panic("no page in proc");
8010759f:	83 ec 0c             	sub    $0xc,%esp
801075a2:	68 e5 82 10 80       	push   $0x801082e5
801075a7:	e8 c4 8d ff ff       	call   80100370 <panic>
801075ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801075b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
801075b5:	53                   	push   %ebx
801075b6:	83 ec 0c             	sub    $0xc,%esp
801075b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if (DEBUGMODE == 2&& notShell())
    cprintf("FREEVM");
  uint i;

  if(pgdir == 0)
801075bc:	85 f6                	test   %esi,%esi
801075be:	74 59                	je     80107619 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0 , 0);
801075c0:	6a 00                	push   $0x0
801075c2:	6a 00                	push   $0x0
801075c4:	89 f3                	mov    %esi,%ebx
801075c6:	68 00 00 00 80       	push   $0x80000000
801075cb:	56                   	push   %esi
801075cc:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801075d2:	e8 99 fb ff ff       	call   80107170 <deallocuvm>
801075d7:	83 c4 10             	add    $0x10,%esp
801075da:	eb 0b                	jmp    801075e7 <freevm+0x37>
801075dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075e0:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
801075e3:	39 fb                	cmp    %edi,%ebx
801075e5:	74 23                	je     8010760a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801075e7:	8b 03                	mov    (%ebx),%eax
801075e9:	a8 01                	test   $0x1,%al
801075eb:	74 f3                	je     801075e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801075ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075f2:	83 ec 0c             	sub    $0xc,%esp
801075f5:	83 c3 04             	add    $0x4,%ebx
801075f8:	05 00 00 00 80       	add    $0x80000000,%eax
801075fd:	50                   	push   %eax
801075fe:	e8 9d b0 ff ff       	call   801026a0 <kfree>
80107603:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0 , 0);
  for(i = 0; i < NPDENTRIES; i++){
80107606:	39 fb                	cmp    %edi,%ebx
80107608:	75 dd                	jne    801075e7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010760a:	89 75 08             	mov    %esi,0x8(%ebp)
  if (DEBUGMODE == 2&& notShell())
    cprintf(">FREEVM-DONE!\t");
}
8010760d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107610:	5b                   	pop    %ebx
80107611:	5e                   	pop    %esi
80107612:	5f                   	pop    %edi
80107613:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107614:	e9 87 b0 ff ff       	jmp    801026a0 <kfree>
  if (DEBUGMODE == 2&& notShell())
    cprintf("FREEVM");
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107619:	83 ec 0c             	sub    $0xc,%esp
8010761c:	68 f5 82 10 80       	push   $0x801082f5
80107621:	e8 4a 8d ff ff       	call   80100370 <panic>
80107626:	8d 76 00             	lea    0x0(%esi),%esi
80107629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107630 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	56                   	push   %esi
80107634:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107635:	e8 16 b2 ff ff       	call   80102850 <kalloc>
8010763a:	85 c0                	test   %eax,%eax
8010763c:	74 6a                	je     801076a8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010763e:	83 ec 04             	sub    $0x4,%esp
80107641:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107643:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107648:	68 00 10 00 00       	push   $0x1000
8010764d:	6a 00                	push   $0x0
8010764f:	50                   	push   %eax
80107650:	e8 eb d4 ff ff       	call   80104b40 <memset>
80107655:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107658:	8b 43 04             	mov    0x4(%ebx),%eax
8010765b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010765e:	83 ec 08             	sub    $0x8,%esp
80107661:	8b 13                	mov    (%ebx),%edx
80107663:	ff 73 0c             	pushl  0xc(%ebx)
80107666:	50                   	push   %eax
80107667:	29 c1                	sub    %eax,%ecx
80107669:	89 f0                	mov    %esi,%eax
8010766b:	e8 d0 f6 ff ff       	call   80106d40 <mappages>
80107670:	83 c4 10             	add    $0x10,%esp
80107673:	85 c0                	test   %eax,%eax
80107675:	78 19                	js     80107690 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107677:	83 c3 10             	add    $0x10,%ebx
8010767a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107680:	75 d6                	jne    80107658 <setupkvm+0x28>
80107682:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107687:	5b                   	pop    %ebx
80107688:	5e                   	pop    %esi
80107689:	5d                   	pop    %ebp
8010768a:	c3                   	ret    
8010768b:	90                   	nop
8010768c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107690:	83 ec 0c             	sub    $0xc,%esp
80107693:	56                   	push   %esi
80107694:	e8 17 ff ff ff       	call   801075b0 <freevm>
      return 0;
80107699:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010769c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010769f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
801076a1:	5b                   	pop    %ebx
801076a2:	5e                   	pop    %esi
801076a3:	5d                   	pop    %ebp
801076a4:	c3                   	ret    
801076a5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801076a8:	31 c0                	xor    %eax,%eax
801076aa:	eb d8                	jmp    80107684 <setupkvm+0x54>
801076ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801076b0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801076b6:	e8 75 ff ff ff       	call   80107630 <setupkvm>
801076bb:	a3 a4 69 12 80       	mov    %eax,0x801269a4
801076c0:	05 00 00 00 80       	add    $0x80000000,%eax
801076c5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801076c8:	c9                   	leave  
801076c9:	c3                   	ret    
801076ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801076d0:	55                   	push   %ebp
  if (DEBUGMODE == 2&& notShell())
    cprintf("CLEARPTEU-");
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076d1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801076d3:	89 e5                	mov    %esp,%ebp
801076d5:	83 ec 08             	sub    $0x8,%esp
  if (DEBUGMODE == 2&& notShell())
    cprintf("CLEARPTEU-");
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801076db:	8b 45 08             	mov    0x8(%ebp),%eax
801076de:	e8 dd f5 ff ff       	call   80106cc0 <walkpgdir>
  if(pte == 0)
801076e3:	85 c0                	test   %eax,%eax
801076e5:	74 05                	je     801076ec <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801076e7:	83 20 fb             	andl   $0xfffffffb,(%eax)
  if (DEBUGMODE == 2&& notShell())
    cprintf(">CLEARPTEU-DONE!\t");
}
801076ea:	c9                   	leave  
801076eb:	c3                   	ret    
    cprintf("CLEARPTEU-");
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801076ec:	83 ec 0c             	sub    $0xc,%esp
801076ef:	68 06 83 10 80       	push   $0x80108306
801076f4:	e8 77 8c ff ff       	call   80100370 <panic>
801076f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107700 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	57                   	push   %edi
80107704:	56                   	push   %esi
80107705:	53                   	push   %ebx
80107706:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107709:	e8 22 ff ff ff       	call   80107630 <setupkvm>
8010770e:	85 c0                	test   %eax,%eax
80107710:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107713:	0f 84 b2 00 00 00    	je     801077cb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107719:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010771c:	85 c9                	test   %ecx,%ecx
8010771e:	0f 84 9c 00 00 00    	je     801077c0 <copyuvm+0xc0>
80107724:	31 f6                	xor    %esi,%esi
80107726:	eb 4a                	jmp    80107772 <copyuvm+0x72>
80107728:	90                   	nop
80107729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107730:	83 ec 04             	sub    $0x4,%esp
80107733:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107739:	68 00 10 00 00       	push   $0x1000
8010773e:	57                   	push   %edi
8010773f:	50                   	push   %eax
80107740:	e8 ab d4 ff ff       	call   80104bf0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107745:	58                   	pop    %eax
80107746:	5a                   	pop    %edx
80107747:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
8010774d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107750:	ff 75 e4             	pushl  -0x1c(%ebp)
80107753:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107758:	52                   	push   %edx
80107759:	89 f2                	mov    %esi,%edx
8010775b:	e8 e0 f5 ff ff       	call   80106d40 <mappages>
80107760:	83 c4 10             	add    $0x10,%esp
80107763:	85 c0                	test   %eax,%eax
80107765:	78 3e                	js     801077a5 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107767:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010776d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107770:	76 4e                	jbe    801077c0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107772:	8b 45 08             	mov    0x8(%ebp),%eax
80107775:	31 c9                	xor    %ecx,%ecx
80107777:	89 f2                	mov    %esi,%edx
80107779:	e8 42 f5 ff ff       	call   80106cc0 <walkpgdir>
8010777e:	85 c0                	test   %eax,%eax
80107780:	74 5a                	je     801077dc <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107782:	8b 18                	mov    (%eax),%ebx
80107784:	f6 c3 01             	test   $0x1,%bl
80107787:	74 46                	je     801077cf <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107789:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010778b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107791:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107794:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010779a:	e8 b1 b0 ff ff       	call   80102850 <kalloc>
8010779f:	85 c0                	test   %eax,%eax
801077a1:	89 c3                	mov    %eax,%ebx
801077a3:	75 8b                	jne    80107730 <copyuvm+0x30>
  if (DEBUGMODE == 2&& notShell())
    cprintf(">COPYUVM-DONE!\t");
  return d;

bad:
  freevm(d);
801077a5:	83 ec 0c             	sub    $0xc,%esp
801077a8:	ff 75 e0             	pushl  -0x20(%ebp)
801077ab:	e8 00 fe ff ff       	call   801075b0 <freevm>
  if (DEBUGMODE == 2&& notShell())
    cprintf(">COPYUVM-FAILED!\t");
  return 0;
801077b0:	83 c4 10             	add    $0x10,%esp
801077b3:	31 c0                	xor    %eax,%eax
}
801077b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077b8:	5b                   	pop    %ebx
801077b9:	5e                   	pop    %esi
801077ba:	5f                   	pop    %edi
801077bb:	5d                   	pop    %ebp
801077bc:	c3                   	ret    
801077bd:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
bad:
  freevm(d);
  if (DEBUGMODE == 2&& notShell())
    cprintf(">COPYUVM-FAILED!\t");
  return 0;
}
801077c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077c6:	5b                   	pop    %ebx
801077c7:	5e                   	pop    %esi
801077c8:	5f                   	pop    %edi
801077c9:	5d                   	pop    %ebp
801077ca:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801077cb:	31 c0                	xor    %eax,%eax
801077cd:	eb e6                	jmp    801077b5 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801077cf:	83 ec 0c             	sub    $0xc,%esp
801077d2:	68 2a 83 10 80       	push   $0x8010832a
801077d7:	e8 94 8b ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801077dc:	83 ec 0c             	sub    $0xc,%esp
801077df:	68 10 83 10 80       	push   $0x80108310
801077e4:	e8 87 8b ff ff       	call   80100370 <panic>
801077e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801077f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077f1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801077f3:	89 e5                	mov    %esp,%ebp
801077f5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801077fb:	8b 45 08             	mov    0x8(%ebp),%eax
801077fe:	e8 bd f4 ff ff       	call   80106cc0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107803:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107805:	89 c2                	mov    %eax,%edx
80107807:	83 e2 05             	and    $0x5,%edx
8010780a:	83 fa 05             	cmp    $0x5,%edx
8010780d:	75 11                	jne    80107820 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010780f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107814:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107815:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010781a:	c3                   	ret    
8010781b:	90                   	nop
8010781c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107820:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107822:	c9                   	leave  
80107823:	c3                   	ret    
80107824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010782a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107830 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	57                   	push   %edi
80107834:	56                   	push   %esi
80107835:	53                   	push   %ebx
80107836:	83 ec 1c             	sub    $0x1c,%esp
80107839:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010783c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010783f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107842:	85 db                	test   %ebx,%ebx
80107844:	75 40                	jne    80107886 <copyout+0x56>
80107846:	eb 70                	jmp    801078b8 <copyout+0x88>
80107848:	90                   	nop
80107849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107850:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107853:	89 f1                	mov    %esi,%ecx
80107855:	29 d1                	sub    %edx,%ecx
80107857:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010785d:	39 d9                	cmp    %ebx,%ecx
8010785f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107862:	29 f2                	sub    %esi,%edx
80107864:	83 ec 04             	sub    $0x4,%esp
80107867:	01 d0                	add    %edx,%eax
80107869:	51                   	push   %ecx
8010786a:	57                   	push   %edi
8010786b:	50                   	push   %eax
8010786c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010786f:	e8 7c d3 ff ff       	call   80104bf0 <memmove>
    len -= n;
    buf += n;
80107874:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107877:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010787a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107880:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107882:	29 cb                	sub    %ecx,%ebx
80107884:	74 32                	je     801078b8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107886:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107888:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010788b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010788e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107894:	56                   	push   %esi
80107895:	ff 75 08             	pushl  0x8(%ebp)
80107898:	e8 53 ff ff ff       	call   801077f0 <uva2ka>
    if(pa0 == 0)
8010789d:	83 c4 10             	add    $0x10,%esp
801078a0:	85 c0                	test   %eax,%eax
801078a2:	75 ac                	jne    80107850 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801078a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801078a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801078ac:	5b                   	pop    %ebx
801078ad:	5e                   	pop    %esi
801078ae:	5f                   	pop    %edi
801078af:	5d                   	pop    %ebp
801078b0:	c3                   	ret    
801078b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801078bb:	31 c0                	xor    %eax,%eax
}
801078bd:	5b                   	pop    %ebx
801078be:	5e                   	pop    %esi
801078bf:	5f                   	pop    %edi
801078c0:	5d                   	pop    %ebp
801078c1:	c3                   	ret    
