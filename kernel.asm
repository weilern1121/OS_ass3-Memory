
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
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 32 10 80       	mov    $0x801032a0,%eax
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
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 40 7d 10 80       	push   $0x80107d40
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 b5 49 00 00       	call   80104a10 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
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
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 7d 10 80       	push   $0x80107d47
80100097:	50                   	push   %eax
80100098:	e8 63 48 00 00       	call   80104900 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax

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
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
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
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 27 4a 00 00       	call   80104b10 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 c9 4a 00 00       	call   80104c30 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 47 00 00       	call   80104940 <acquiresleep>
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
80100193:	68 4e 7d 10 80       	push   $0x80107d4e
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
801001ae:	e8 2d 48 00 00       	call   801049e0 <holdingsleep>
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
801001cc:	68 5f 7d 10 80       	push   $0x80107d5f
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
801001ef:	e8 ec 47 00 00       	call   801049e0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 47 00 00       	call   801049a0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 00 49 00 00       	call   80104b10 <acquire>
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
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
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
8010025c:	e9 cf 49 00 00       	jmp    80104c30 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 7d 10 80       	push   $0x80107d66
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
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 7f 48 00 00       	call   80104b10 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002a6:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
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
801002b8:	68 c0 0f 11 80       	push   $0x80110fc0
801002bd:	e8 be 41 00 00       	call   80104480 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 b9 39 00 00       	call   80103c90 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 45 49 00 00       	call   80104c30 <release>
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
8010030b:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 40 0f 11 80 	movsbl -0x7feef0c0(%edx),%edx
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
80100346:	e8 e5 48 00 00       	call   80104c30 <release>
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
80100360:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
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
80100389:	e8 a2 27 00 00       	call   80102b30 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 6d 7d 10 80       	push   $0x80107d6d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 39 88 10 80 	movl   $0x80108839,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 73 46 00 00       	call   80104a30 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 81 7d 10 80       	push   $0x80107d81
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
8010041a:	e8 01 61 00 00       	call   80106520 <uartputc>
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
801004d3:	e8 48 60 00 00       	call   80106520 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 3c 60 00 00       	call   80106520 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 30 60 00 00       	call   80106520 <uartputc>
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
80100514:	e8 17 48 00 00       	call   80104d30 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 52 47 00 00       	call   80104c80 <memset>
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
80100540:	68 85 7d 10 80       	push   $0x80107d85
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
801005b1:	0f b6 92 b0 7d 10 80 	movzbl -0x7fef8250(%edx),%edx
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
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 f0 44 00 00       	call   80104b10 <acquire>
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
80100647:	e8 e4 45 00 00       	call   80104c30 <release>
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
8010070d:	e8 1e 45 00 00       	call   80104c30 <release>
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
80100788:	b8 98 7d 10 80       	mov    $0x80107d98,%eax
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
801007c8:	e8 43 43 00 00       	call   80104b10 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 9f 7d 10 80       	push   $0x80107d9f
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
80100803:	e8 08 43 00 00       	call   80104b10 <acquire>
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
80100831:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100836:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
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
80100868:	e8 c3 43 00 00       	call   80104c30 <release>
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
80100889:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
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
801008a8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
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
801008ec:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
801008f1:	68 c0 0f 11 80       	push   $0x80110fc0
801008f6:	e8 f5 3d 00 00       	call   801046f0 <wakeup>
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
80100908:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010090d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100934:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
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
80100948:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
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
80100977:	e9 64 3e 00 00       	jmp    801047e0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
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
801009a6:	68 a8 7d 10 80       	push   $0x80107da8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 5b 40 00 00       	call   80104a10 <initlock>

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
801009bb:	c7 05 8c 19 11 80 00 	movl   $0x80100600,0x8011198c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
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
801009fc:	e8 8f 32 00 00       	call   80103c90 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

    begin_op();
80100a07:	e8 84 25 00 00       	call   80102f90 <begin_op>

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
80100a4f:	e8 ac 25 00 00       	call   80103000 <end_op>
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
80100a74:	e8 27 70 00 00       	call   80107aa0 <setupkvm>
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
80100b04:	e8 f7 6c 00 00       	call   80107800 <allocuvm>
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
80100b3a:	e8 a1 68 00 00       	call   801073e0 <loaduvm>
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
80100b59:	e8 c2 6e 00 00       	call   80107a20 <freevm>
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
80100b6f:	e8 8c 24 00 00       	call   80103000 <end_op>
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
80100b95:	e8 66 6c 00 00       	call   80107800 <allocuvm>
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
80100bac:	e8 6f 6e 00 00       	call   80107a20 <freevm>
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
80100bbe:	e8 3d 24 00 00       	call   80103000 <end_op>
        cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 c1 7d 10 80       	push   $0x80107dc1
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
80100bf1:	e8 4a 6f 00 00       	call   80107b40 <clearpteu>
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
80100c2d:	e8 8e 42 00 00       	call   80104ec0 <strlen>
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
80100c40:	e8 7b 42 00 00       	call   80104ec0 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 4a 70 00 00       	call   80107ca0 <copyout>
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
80100cbd:	e8 de 6f 00 00       	call   80107ca0 <copyout>
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
80100d02:	e8 79 41 00 00       	call   80104e80 <safestrcpy>

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
    curproc->pgdir = pgdir;
80100d07:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
        if (*s == '/')
            last = s + 1;
    safestrcpy(curproc->name, last, sizeof(curproc->name));

    // Commit to the user image.
    oldpgdir = curproc->pgdir;
80100d0d:	89 d8                	mov    %ebx,%eax
80100d0f:	8b 5b 04             	mov    0x4(%ebx),%ebx
    curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
    //TODO WE NEED CLOSE AND OPEN SWAP
#if(defined(LIFO) || defined(SCFIFO))
    if (notShell()) {
80100d15:	e8 96 2e 00 00       	call   80103bb0 <notShell>
80100d1a:	83 c4 10             	add    $0x10,%esp
80100d1d:	85 c0                	test   %eax,%eax
80100d1f:	74 1d                	je     80100d3e <exec+0x34e>
        removeSwapFile(curproc);
80100d21:	83 ec 0c             	sub    $0xc,%esp
80100d24:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d2a:	e8 a1 12 00 00       	call   80101fd0 <removeSwapFile>
        createSwapFile(curproc);
80100d2f:	58                   	pop    %eax
80100d30:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d36:	e8 95 14 00 00       	call   801021d0 <createSwapFile>
80100d3b:	83 c4 10             	add    $0x10,%esp
    }
#endif
    curproc->sz = sz;
80100d3e:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    curproc->tf->eip = elf.entry;  // main
    curproc->tf->esp = sp;
    switchuvm(curproc);
80100d44:	83 ec 0c             	sub    $0xc,%esp
    if (notShell()) {
        removeSwapFile(curproc);
        createSwapFile(curproc);
    }
#endif
    curproc->sz = sz;
80100d47:	89 31                	mov    %esi,(%ecx)
    curproc->tf->eip = elf.entry;  // main
80100d49:	8b 41 18             	mov    0x18(%ecx),%eax
80100d4c:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d52:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
80100d55:	8b 41 18             	mov    0x18(%ecx),%eax
80100d58:	89 78 44             	mov    %edi,0x44(%eax)
    switchuvm(curproc);
80100d5b:	51                   	push   %ecx
80100d5c:	e8 ef 64 00 00       	call   80107250 <switchuvm>
    freevm(oldpgdir);
80100d61:	89 1c 24             	mov    %ebx,(%esp)
80100d64:	e8 b7 6c 00 00       	call   80107a20 <freevm>
    if (DEBUGMODE == 1)
        cprintf(">EXEC-DONE!\t");
    return 0;
80100d69:	83 c4 10             	add    $0x10,%esp
80100d6c:	31 c0                	xor    %eax,%eax
80100d6e:	e9 e9 fc ff ff       	jmp    80100a5c <exec+0x6c>
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
80100d86:	68 cd 7d 10 80       	push   $0x80107dcd
80100d8b:	68 e0 0f 11 80       	push   $0x80110fe0
80100d90:	e8 7b 3c 00 00       	call   80104a10 <initlock>
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
80100da4:	bb 14 10 11 80       	mov    $0x80111014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da9:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100dac:	68 e0 0f 11 80       	push   $0x80110fe0
80100db1:	e8 5a 3d 00 00       	call   80104b10 <acquire>
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	eb 10                	jmp    80100dcb <filealloc+0x2b>
80100dbb:	90                   	nop
80100dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
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
80100ddc:	68 e0 0f 11 80       	push   $0x80110fe0
80100de1:	e8 4a 3e 00 00       	call   80104c30 <release>
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
80100df3:	68 e0 0f 11 80       	push   $0x80110fe0
80100df8:	e8 33 3e 00 00       	call   80104c30 <release>
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
80100e1a:	68 e0 0f 11 80       	push   $0x80110fe0
80100e1f:	e8 ec 3c 00 00       	call   80104b10 <acquire>
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
80100e37:	68 e0 0f 11 80       	push   $0x80110fe0
80100e3c:	e8 ef 3d 00 00       	call   80104c30 <release>
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
80100e4b:	68 d4 7d 10 80       	push   $0x80107dd4
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
80100e6c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e71:	e8 9a 3c 00 00       	call   80104b10 <acquire>
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
80100e8e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
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
80100e9c:	e9 8f 3d 00 00       	jmp    80104c30 <release>
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
80100ec0:	68 e0 0f 11 80       	push   $0x80110fe0
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
80100ec8:	e8 63 3d 00 00       	call   80104c30 <release>

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
80100ef1:	e8 3a 28 00 00       	call   80103730 <pipeclose>
80100ef6:	83 c4 10             	add    $0x10,%esp
80100ef9:	eb df                	jmp    80100eda <fileclose+0x7a>
80100efb:	90                   	nop
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100f00:	e8 8b 20 00 00       	call   80102f90 <begin_op>
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
80100f1a:	e9 e1 20 00 00       	jmp    80103000 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	68 dc 7d 10 80       	push   $0x80107ddc
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
80100fed:	e9 de 28 00 00       	jmp    801038d0 <piperead>
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
80101002:	68 e6 7d 10 80       	push   $0x80107de6
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
80101069:	e8 92 1f 00 00       	call   80103000 <end_op>
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
80101096:	e8 f5 1e 00 00       	call   80102f90 <begin_op>
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
801010cd:	e8 2e 1f 00 00       	call   80103000 <end_op>

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
8010110c:	e9 bf 26 00 00       	jmp    801037d0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101111:	83 ec 0c             	sub    $0xc,%esp
80101114:	68 ef 7d 10 80       	push   $0x80107def
80101119:	e8 52 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010111e:	83 ec 0c             	sub    $0xc,%esp
80101121:	68 f5 7d 10 80       	push   $0x80107df5
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
80101139:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
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
8010115c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101162:	50                   	push   %eax
80101163:	ff 75 d8             	pushl  -0x28(%ebp)
80101166:	e8 65 ef ff ff       	call   801000d0 <bread>
8010116b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010116e:	a1 e0 19 11 80       	mov    0x801119e0,%eax
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
801011c7:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801011cd:	77 82                	ja     80101151 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	68 ff 7d 10 80       	push   $0x80107dff
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
801011ed:	e8 7e 1f 00 00       	call   80103170 <log_write>
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
80101215:	e8 66 3a 00 00       	call   80104c80 <memset>
  log_write(bp);
8010121a:	89 1c 24             	mov    %ebx,(%esp)
8010121d:	e8 4e 1f 00 00       	call   80103170 <log_write>
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
8010124a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
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
80101255:	68 00 1a 11 80       	push   $0x80111a00
8010125a:	e8 b1 38 00 00       	call   80104b10 <acquire>
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
8010127a:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
8010129a:	68 00 1a 11 80       	push   $0x80111a00

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010129f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012a2:	e8 89 39 00 00       	call   80104c30 <release>
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
801012c3:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
801012ea:	68 00 1a 11 80       	push   $0x80111a00
801012ef:	e8 3c 39 00 00       	call   80104c30 <release>

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
80101304:	68 15 7e 10 80       	push   $0x80107e15
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
8010137d:	e8 ee 1d 00 00       	call   80103170 <log_write>
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
801013ca:	68 25 7e 10 80       	push   $0x80107e25
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
80101401:	e8 2a 39 00 00       	call   80104d30 <memmove>
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
8010142c:	68 e0 19 11 80       	push   $0x801119e0
80101431:	50                   	push   %eax
80101432:	e8 a9 ff ff ff       	call   801013e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101437:	58                   	pop    %eax
80101438:	5a                   	pop    %edx
80101439:	89 da                	mov    %ebx,%edx
8010143b:	c1 ea 0c             	shr    $0xc,%edx
8010143e:	03 15 f8 19 11 80    	add    0x801119f8,%edx
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
8010147c:	e8 ef 1c 00 00       	call   80103170 <log_write>
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
80101496:	68 38 7e 10 80       	push   $0x80107e38
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
801014a4:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
801014a9:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801014ac:	68 4b 7e 10 80       	push   $0x80107e4b
801014b1:	68 00 1a 11 80       	push   $0x80111a00
801014b6:	e8 55 35 00 00       	call   80104a10 <initlock>
801014bb:	83 c4 10             	add    $0x10,%esp
801014be:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014c0:	83 ec 08             	sub    $0x8,%esp
801014c3:	68 52 7e 10 80       	push   $0x80107e52
801014c8:	53                   	push   %ebx
801014c9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014cf:	e8 2c 34 00 00       	call   80104900 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014d4:	83 c4 10             	add    $0x10,%esp
801014d7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014dd:	75 e1                	jne    801014c0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014df:	83 ec 08             	sub    $0x8,%esp
801014e2:	68 e0 19 11 80       	push   $0x801119e0
801014e7:	ff 75 08             	pushl  0x8(%ebp)
801014ea:	e8 f1 fe ff ff       	call   801013e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ef:	ff 35 f8 19 11 80    	pushl  0x801119f8
801014f5:	ff 35 f4 19 11 80    	pushl  0x801119f4
801014fb:	ff 35 f0 19 11 80    	pushl  0x801119f0
80101501:	ff 35 ec 19 11 80    	pushl  0x801119ec
80101507:	ff 35 e8 19 11 80    	pushl  0x801119e8
8010150d:	ff 35 e4 19 11 80    	pushl  0x801119e4
80101513:	ff 35 e0 19 11 80    	pushl  0x801119e0
80101519:	68 fc 7e 10 80       	push   $0x80107efc
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
80101539:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
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
8010156f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101575:	76 69                	jbe    801015e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101577:	89 d8                	mov    %ebx,%eax
80101579:	83 ec 08             	sub    $0x8,%esp
8010157c:	c1 e8 03             	shr    $0x3,%eax
8010157f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
801015ae:	e8 cd 36 00 00       	call   80104c80 <memset>
      dip->type = type;
801015b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015bd:	89 3c 24             	mov    %edi,(%esp)
801015c0:	e8 ab 1b 00 00       	call   80103170 <log_write>
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
801015e3:	68 58 7e 10 80       	push   $0x80107e58
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
80101604:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101651:	e8 da 36 00 00       	call   80104d30 <memmove>
  log_write(bp);
80101656:	89 34 24             	mov    %esi,(%esp)
80101659:	e8 12 1b 00 00       	call   80103170 <log_write>
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
8010167a:	68 00 1a 11 80       	push   $0x80111a00
8010167f:	e8 8c 34 00 00       	call   80104b10 <acquire>
  ip->ref++;
80101684:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101688:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010168f:	e8 9c 35 00 00       	call   80104c30 <release>
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
801016c2:	e8 79 32 00 00       	call   80104940 <acquiresleep>

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
801016e9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101738:	e8 f3 35 00 00       	call   80104d30 <memmove>
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
8010175d:	68 70 7e 10 80       	push   $0x80107e70
80101762:	e8 09 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101767:	83 ec 0c             	sub    $0xc,%esp
8010176a:	68 6a 7e 10 80       	push   $0x80107e6a
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
80101793:	e8 48 32 00 00       	call   801049e0 <holdingsleep>
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
801017af:	e9 ec 31 00 00       	jmp    801049a0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017b4:	83 ec 0c             	sub    $0xc,%esp
801017b7:	68 7f 7e 10 80       	push   $0x80107e7f
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
801017e0:	e8 5b 31 00 00       	call   80104940 <acquiresleep>
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
801017fa:	e8 a1 31 00 00       	call   801049a0 <releasesleep>

  acquire(&icache.lock);
801017ff:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101806:	e8 05 33 00 00       	call   80104b10 <acquire>
  ip->ref--;
8010180b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010180f:	83 c4 10             	add    $0x10,%esp
80101812:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
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
80101820:	e9 0b 34 00 00       	jmp    80104c30 <release>
80101825:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101828:	83 ec 0c             	sub    $0xc,%esp
8010182b:	68 00 1a 11 80       	push   $0x80111a00
80101830:	e8 db 32 00 00       	call   80104b10 <acquire>
    int r = ip->ref;
80101835:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101838:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010183f:	e8 ec 33 00 00       	call   80104c30 <release>
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
80101a28:	e8 03 33 00 00       	call   80104d30 <memmove>
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
80101a5a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
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
80101b24:	e8 07 32 00 00       	call   80104d30 <memmove>
    log_write(bp);
80101b29:	89 3c 24             	mov    %edi,(%esp)
80101b2c:	e8 3f 16 00 00       	call   80103170 <log_write>
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
80101b6a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
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
80101bbe:	e8 ed 31 00 00       	call   80104db0 <strncmp>
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
80101c25:	e8 86 31 00 00       	call   80104db0 <strncmp>
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
80101c5d:	68 99 7e 10 80       	push   $0x80107e99
80101c62:	e8 09 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c67:	83 ec 0c             	sub    $0xc,%esp
80101c6a:	68 87 7e 10 80       	push   $0x80107e87
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
80101c99:	e8 f2 1f 00 00       	call   80103c90 <myproc>
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
80101ca4:	68 00 1a 11 80       	push   $0x80111a00
80101ca9:	e8 62 2e 00 00       	call   80104b10 <acquire>
  ip->ref++;
80101cae:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cb2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101cb9:	e8 72 2f 00 00       	call   80104c30 <release>
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
80101d15:	e8 16 30 00 00       	call   80104d30 <memmove>
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
80101da4:	e8 87 2f 00 00       	call   80104d30 <memmove>
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
80101e8d:	e8 8e 2f 00 00       	call   80104e20 <strncpy>
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
80101ecb:	68 a8 7e 10 80       	push   $0x80107ea8
80101ed0:	e8 9b e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 31 85 10 80       	push   $0x80108531
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
80101fe1:	68 b5 7e 10 80       	push   $0x80107eb5
80101fe6:	56                   	push   %esi
80101fe7:	e8 44 2d 00 00       	call   80104d30 <memmove>
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
80102014:	e8 77 0f 00 00       	call   80102f90 <begin_op>
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
80102042:	68 bd 7e 10 80       	push   $0x80107ebd
80102047:	53                   	push   %ebx
80102048:	e8 63 2d 00 00       	call   80104db0 <strncmp>
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
8010205d:	68 bc 7e 10 80       	push   $0x80107ebc
80102062:	53                   	push   %ebx
80102063:	e8 48 2d 00 00       	call   80104db0 <strncmp>
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
801020b7:	e8 c4 2b 00 00       	call   80104c80 <memset>
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
8010210d:	e8 ee 0e 00 00       	call   80103000 <end_op>

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
80102124:	e8 67 33 00 00       	call   80105490 <isdirempty>
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
80102159:	e8 a2 0e 00 00       	call   80103000 <end_op>
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
8010219a:	e8 61 0e 00 00       	call   80103000 <end_op>
    return -1;
8010219f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021a4:	e9 6e ff ff ff       	jmp    80102117 <removeSwapFile+0x147>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801021a9:	83 ec 0c             	sub    $0xc,%esp
801021ac:	68 d1 7e 10 80       	push   $0x80107ed1
801021b1:	e8 ba e1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801021b6:	83 ec 0c             	sub    $0xc,%esp
801021b9:	68 bf 7e 10 80       	push   $0x80107ebf
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
801021e0:	68 b5 7e 10 80       	push   $0x80107eb5
801021e5:	56                   	push   %esi
801021e6:	e8 45 2b 00 00       	call   80104d30 <memmove>
    itoa(p->pid, path + 6);
801021eb:	58                   	pop    %eax
801021ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
801021ef:	5a                   	pop    %edx
801021f0:	50                   	push   %eax
801021f1:	ff 73 10             	pushl  0x10(%ebx)
801021f4:	e8 37 fd ff ff       	call   80101f30 <itoa>

    begin_op();
801021f9:	e8 92 0d 00 00       	call   80102f90 <begin_op>
    struct inode *in = create(path, T_FILE, 0, 0);
801021fe:	6a 00                	push   $0x0
80102200:	6a 00                	push   $0x0
80102202:	6a 02                	push   $0x2
80102204:	56                   	push   %esi
80102205:	e8 96 34 00 00       	call   801056a0 <create>
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
80102248:	e8 b3 0d 00 00       	call   80103000 <end_op>

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
80102259:	68 e0 7e 10 80       	push   $0x80107ee0
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
80102380:	68 58 7f 10 80       	push   $0x80107f58
80102385:	e8 e6 df ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010238a:	83 ec 0c             	sub    $0xc,%esp
8010238d:	68 4f 7f 10 80       	push   $0x80107f4f
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
801023a6:	68 6a 7f 10 80       	push   $0x80107f6a
801023ab:	68 80 b5 10 80       	push   $0x8010b580
801023b0:	e8 5b 26 00 00       	call   80104a10 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023b5:	58                   	pop    %eax
801023b6:	a1 20 3d 11 80       	mov    0x80113d20,%eax
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
801023fa:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
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
80102429:	68 80 b5 10 80       	push   $0x8010b580
8010242e:	e8 dd 26 00 00       	call   80104b10 <acquire>

  if((b = idequeue) == 0){
80102433:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102439:	83 c4 10             	add    $0x10,%esp
8010243c:	85 db                	test   %ebx,%ebx
8010243e:	74 34                	je     80102474 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102440:	8b 43 58             	mov    0x58(%ebx),%eax
80102443:	a3 64 b5 10 80       	mov    %eax,0x8010b564

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
8010245e:	e8 8d 22 00 00       	call   801046f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102463:	a1 64 b5 10 80       	mov    0x8010b564,%eax
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
80102477:	68 80 b5 10 80       	push   $0x8010b580
8010247c:	e8 af 27 00 00       	call   80104c30 <release>
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
801024ce:	e8 0d 25 00 00       	call   801049e0 <holdingsleep>
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
801024f3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801024f8:	85 c0                	test   %eax,%eax
801024fa:	0f 84 98 00 00 00    	je     80102598 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 80 b5 10 80       	push   $0x8010b580
80102508:	e8 03 26 00 00       	call   80104b10 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010250d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
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
80102536:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
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
80102553:	68 80 b5 10 80       	push   $0x8010b580
80102558:	53                   	push   %ebx
80102559:	e8 22 1f 00 00       	call   80104480 <sleep>
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
8010256b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102575:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102576:	e9 b5 26 00 00       	jmp    80104c30 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010257b:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
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
8010258e:	68 6e 7f 10 80       	push   $0x80107f6e
80102593:	e8 d8 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	68 99 7f 10 80       	push   $0x80107f99
801025a0:	e8 cb dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801025a5:	83 ec 0c             	sub    $0xc,%esp
801025a8:	68 84 7f 10 80       	push   $0x80107f84
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
801025c1:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
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
801025d9:	8b 15 54 36 11 80    	mov    0x80113654,%edx
801025df:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801025e8:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025ee:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
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
8010260a:	68 b8 7f 10 80       	push   $0x80107fb8
8010260f:	e8 4c e0 ff ff       	call   80100660 <cprintf>
80102614:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102632:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102650:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102671:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102685:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102696:	a1 54 36 11 80       	mov    0x80113654,%eax
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

801026b0 <kallocCount>:


//called once via userinit to count number of pages
int
kallocCount(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	53                   	push   %ebx
801026b4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;
  int count = 0;
  if(kmem.use_lock) //lock check
801026b7:	a1 94 36 11 80       	mov    0x80113694,%eax
801026bc:	85 c0                	test   %eax,%eax
801026be:	75 38                	jne    801026f8 <kallocCount+0x48>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026c0:	8b 15 98 36 11 80    	mov    0x80113698,%edx
  //count all the pages by iterating the freelist
  while(r){
801026c6:	85 d2                	test   %edx,%edx
801026c8:	74 51                	je     8010271b <kallocCount+0x6b>


//called once via userinit to count number of pages
int
kallocCount(void)
{
801026ca:	31 db                	xor    %ebx,%ebx
801026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
  r = kmem.freelist;
  //count all the pages by iterating the freelist
  while(r){
    count++;
    r = r->next;
801026d0:	8b 12                	mov    (%edx),%edx
  if(kmem.use_lock) //lock check
    acquire(&kmem.lock);
  r = kmem.freelist;
  //count all the pages by iterating the freelist
  while(r){
    count++;
801026d2:	83 c3 01             	add    $0x1,%ebx
  int count = 0;
  if(kmem.use_lock) //lock check
    acquire(&kmem.lock);
  r = kmem.freelist;
  //count all the pages by iterating the freelist
  while(r){
801026d5:	85 d2                	test   %edx,%edx
801026d7:	75 f7                	jne    801026d0 <kallocCount+0x20>
    count++;
    r = r->next;
  }
  if(kmem.use_lock)//lock check
801026d9:	85 c0                	test   %eax,%eax
801026db:	74 10                	je     801026ed <kallocCount+0x3d>
    release(&kmem.lock);
801026dd:	83 ec 0c             	sub    $0xc,%esp
801026e0:	68 60 36 11 80       	push   $0x80113660
801026e5:	e8 46 25 00 00       	call   80104c30 <release>
801026ea:	83 c4 10             	add    $0x10,%esp
  return count;
}
801026ed:	89 d8                	mov    %ebx,%eax
801026ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026f2:	c9                   	leave  
801026f3:	c3                   	ret    
801026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
kallocCount(void)
{
  struct run *r;
  int count = 0;
  if(kmem.use_lock) //lock check
    acquire(&kmem.lock);
801026f8:	83 ec 0c             	sub    $0xc,%esp
//called once via userinit to count number of pages
int
kallocCount(void)
{
  struct run *r;
  int count = 0;
801026fb:	31 db                	xor    %ebx,%ebx
  if(kmem.use_lock) //lock check
    acquire(&kmem.lock);
801026fd:	68 60 36 11 80       	push   $0x80113660
80102702:	e8 09 24 00 00       	call   80104b10 <acquire>
  r = kmem.freelist;
80102707:	8b 15 98 36 11 80    	mov    0x80113698,%edx
  //count all the pages by iterating the freelist
  while(r){
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	a1 94 36 11 80       	mov    0x80113694,%eax
80102715:	85 d2                	test   %edx,%edx
80102717:	75 b1                	jne    801026ca <kallocCount+0x1a>
80102719:	eb be                	jmp    801026d9 <kallocCount+0x29>
//called once via userinit to count number of pages
int
kallocCount(void)
{
  struct run *r;
  int count = 0;
8010271b:	31 db                	xor    %ebx,%ebx
    count++;
    r = r->next;
  }
  if(kmem.use_lock)//lock check
    release(&kmem.lock);
  return count;
8010271d:	eb ce                	jmp    801026ed <kallocCount+0x3d>
8010271f:	90                   	nop

80102720 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	53                   	push   %ebx
80102724:	83 ec 04             	sub    $0x4,%esp
80102727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010272a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102730:	75 70                	jne    801027a2 <kfree+0x82>
80102732:	81 fb ec 6c 12 80    	cmp    $0x80126cec,%ebx
80102738:	72 68                	jb     801027a2 <kfree+0x82>
8010273a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102740:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102745:	77 5b                	ja     801027a2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102747:	83 ec 04             	sub    $0x4,%esp
8010274a:	68 00 10 00 00       	push   $0x1000
8010274f:	6a 01                	push   $0x1
80102751:	53                   	push   %ebx
80102752:	e8 29 25 00 00       	call   80104c80 <memset>

  if(kmem.use_lock)
80102757:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010275d:	83 c4 10             	add    $0x10,%esp
80102760:	85 d2                	test   %edx,%edx
80102762:	75 2c                	jne    80102790 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102764:	a1 98 36 11 80       	mov    0x80113698,%eax
80102769:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010276b:	a1 94 36 11 80       	mov    0x80113694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102770:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
80102776:	85 c0                	test   %eax,%eax
80102778:	75 06                	jne    80102780 <kfree+0x60>
    release(&kmem.lock);
}
8010277a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277d:	c9                   	leave  
8010277e:	c3                   	ret    
8010277f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102780:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010278a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010278b:	e9 a0 24 00 00       	jmp    80104c30 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 60 36 11 80       	push   $0x80113660
80102798:	e8 73 23 00 00       	call   80104b10 <acquire>
8010279d:	83 c4 10             	add    $0x10,%esp
801027a0:	eb c2                	jmp    80102764 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801027a2:	83 ec 0c             	sub    $0xc,%esp
801027a5:	68 ea 7f 10 80       	push   $0x80107fea
801027aa:	e8 c1 db ff ff       	call   80100370 <panic>
801027af:	90                   	nop

801027b0 <freerange>:
}


void
freerange(void *vstart, void *vend)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	56                   	push   %esi
801027b4:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027b5:	8b 45 08             	mov    0x8(%ebp),%eax
}


void
freerange(void *vstart, void *vend)
{
801027b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027cd:	39 de                	cmp    %ebx,%esi
801027cf:	72 23                	jb     801027f4 <freerange+0x44>
801027d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027de:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027e7:	50                   	push   %eax
801027e8:	e8 33 ff ff ff       	call   80102720 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ed:	83 c4 10             	add    $0x10,%esp
801027f0:	39 f3                	cmp    %esi,%ebx
801027f2:	76 e4                	jbe    801027d8 <freerange+0x28>
    kfree(p);
}
801027f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027f7:	5b                   	pop    %ebx
801027f8:	5e                   	pop    %esi
801027f9:	5d                   	pop    %ebp
801027fa:	c3                   	ret    
801027fb:	90                   	nop
801027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102800 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	56                   	push   %esi
80102804:	53                   	push   %ebx
80102805:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102808:	83 ec 08             	sub    $0x8,%esp
8010280b:	68 f0 7f 10 80       	push   $0x80107ff0
80102810:	68 60 36 11 80       	push   $0x80113660
80102815:	e8 f6 21 00 00       	call   80104a10 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010281a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010281d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102820:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102827:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010282a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102830:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102836:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010283c:	39 de                	cmp    %ebx,%esi
8010283e:	72 1c                	jb     8010285c <kinit1+0x5c>
    kfree(p);
80102840:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102846:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102849:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010284f:	50                   	push   %eax
80102850:	e8 cb fe ff ff       	call   80102720 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102855:	83 c4 10             	add    $0x10,%esp
80102858:	39 de                	cmp    %ebx,%esi
8010285a:	73 e4                	jae    80102840 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010285c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010285f:	5b                   	pop    %ebx
80102860:	5e                   	pop    %esi
80102861:	5d                   	pop    %ebp
80102862:	c3                   	ret    
80102863:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102870 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	56                   	push   %esi
80102874:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102875:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102878:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010287b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102881:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102887:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010288d:	39 de                	cmp    %ebx,%esi
8010288f:	72 23                	jb     801028b4 <kinit2+0x44>
80102891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102898:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010289e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028a7:	50                   	push   %eax
801028a8:	e8 73 fe ff ff       	call   80102720 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ad:	83 c4 10             	add    $0x10,%esp
801028b0:	39 de                	cmp    %ebx,%esi
801028b2:	73 e4                	jae    80102898 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801028b4:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
801028bb:	00 00 00 
}
801028be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028c1:	5b                   	pop    %ebx
801028c2:	5e                   	pop    %esi
801028c3:	5d                   	pop    %ebp
801028c4:	c3                   	ret    
801028c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801028d0:	55                   	push   %ebp
801028d1:	89 e5                	mov    %esp,%ebp
801028d3:	53                   	push   %ebx
801028d4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801028d7:	a1 94 36 11 80       	mov    0x80113694,%eax
801028dc:	85 c0                	test   %eax,%eax
801028de:	75 30                	jne    80102910 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801028e0:	8b 1d 98 36 11 80    	mov    0x80113698,%ebx
  if(r)
801028e6:	85 db                	test   %ebx,%ebx
801028e8:	74 1c                	je     80102906 <kalloc+0x36>
    kmem.freelist = r->next;
801028ea:	8b 13                	mov    (%ebx),%edx
801028ec:	89 15 98 36 11 80    	mov    %edx,0x80113698
  if(kmem.use_lock)
801028f2:	85 c0                	test   %eax,%eax
801028f4:	74 10                	je     80102906 <kalloc+0x36>
    release(&kmem.lock);
801028f6:	83 ec 0c             	sub    $0xc,%esp
801028f9:	68 60 36 11 80       	push   $0x80113660
801028fe:	e8 2d 23 00 00       	call   80104c30 <release>
80102903:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102906:	89 d8                	mov    %ebx,%eax
80102908:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010290b:	c9                   	leave  
8010290c:	c3                   	ret    
8010290d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102910:	83 ec 0c             	sub    $0xc,%esp
80102913:	68 60 36 11 80       	push   $0x80113660
80102918:	e8 f3 21 00 00       	call   80104b10 <acquire>
  r = kmem.freelist;
8010291d:	8b 1d 98 36 11 80    	mov    0x80113698,%ebx
  if(r)
80102923:	83 c4 10             	add    $0x10,%esp
80102926:	a1 94 36 11 80       	mov    0x80113694,%eax
8010292b:	85 db                	test   %ebx,%ebx
8010292d:	75 bb                	jne    801028ea <kalloc+0x1a>
8010292f:	eb c1                	jmp    801028f2 <kalloc+0x22>
80102931:	66 90                	xchg   %ax,%ax
80102933:	66 90                	xchg   %ax,%ax
80102935:	66 90                	xchg   %ax,%ax
80102937:	66 90                	xchg   %ax,%ax
80102939:	66 90                	xchg   %ax,%ax
8010293b:	66 90                	xchg   %ax,%ax
8010293d:	66 90                	xchg   %ax,%ax
8010293f:	90                   	nop

80102940 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102940:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102941:	ba 64 00 00 00       	mov    $0x64,%edx
80102946:	89 e5                	mov    %esp,%ebp
80102948:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102949:	a8 01                	test   $0x1,%al
8010294b:	0f 84 af 00 00 00    	je     80102a00 <kbdgetc+0xc0>
80102951:	ba 60 00 00 00       	mov    $0x60,%edx
80102956:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102957:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010295a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102960:	74 7e                	je     801029e0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102962:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102964:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010296a:	79 24                	jns    80102990 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010296c:	f6 c1 40             	test   $0x40,%cl
8010296f:	75 05                	jne    80102976 <kbdgetc+0x36>
80102971:	89 c2                	mov    %eax,%edx
80102973:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102976:	0f b6 82 20 81 10 80 	movzbl -0x7fef7ee0(%edx),%eax
8010297d:	83 c8 40             	or     $0x40,%eax
80102980:	0f b6 c0             	movzbl %al,%eax
80102983:	f7 d0                	not    %eax
80102985:	21 c8                	and    %ecx,%eax
80102987:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010298c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010298e:	5d                   	pop    %ebp
8010298f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102990:	f6 c1 40             	test   $0x40,%cl
80102993:	74 09                	je     8010299e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102995:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102998:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010299b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010299e:	0f b6 82 20 81 10 80 	movzbl -0x7fef7ee0(%edx),%eax
801029a5:	09 c1                	or     %eax,%ecx
801029a7:	0f b6 82 20 80 10 80 	movzbl -0x7fef7fe0(%edx),%eax
801029ae:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029b0:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801029b2:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801029b8:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801029bb:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801029be:	8b 04 85 00 80 10 80 	mov    -0x7fef8000(,%eax,4),%eax
801029c5:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801029c9:	74 c3                	je     8010298e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
801029cb:	8d 50 9f             	lea    -0x61(%eax),%edx
801029ce:	83 fa 19             	cmp    $0x19,%edx
801029d1:	77 1d                	ja     801029f0 <kbdgetc+0xb0>
      c += 'A' - 'a';
801029d3:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029d6:	5d                   	pop    %ebp
801029d7:	c3                   	ret    
801029d8:	90                   	nop
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801029e0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801029e2:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029e9:	5d                   	pop    %ebp
801029ea:	c3                   	ret    
801029eb:	90                   	nop
801029ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801029f0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029f3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801029f6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801029f7:	83 f9 19             	cmp    $0x19,%ecx
801029fa:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801029fd:	c3                   	ret    
801029fe:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a05:	5d                   	pop    %ebp
80102a06:	c3                   	ret    
80102a07:	89 f6                	mov    %esi,%esi
80102a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a10 <kbdintr>:

void
kbdintr(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a16:	68 40 29 10 80       	push   $0x80102940
80102a1b:	e8 d0 dd ff ff       	call   801007f0 <consoleintr>
}
80102a20:	83 c4 10             	add    $0x10,%esp
80102a23:	c9                   	leave  
80102a24:	c3                   	ret    
80102a25:	66 90                	xchg   %ax,%ax
80102a27:	66 90                	xchg   %ax,%ax
80102a29:	66 90                	xchg   %ax,%ax
80102a2b:	66 90                	xchg   %ax,%ax
80102a2d:	66 90                	xchg   %ax,%ax
80102a2f:	90                   	nop

80102a30 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a30:	a1 9c 36 11 80       	mov    0x8011369c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102a35:	55                   	push   %ebp
80102a36:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a38:	85 c0                	test   %eax,%eax
80102a3a:	0f 84 c8 00 00 00    	je     80102b08 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a40:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a47:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a4d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a57:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a5a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a61:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a64:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a67:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a6e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a71:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a74:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a7b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a7e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a81:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a88:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a8e:	8b 50 30             	mov    0x30(%eax),%edx
80102a91:	c1 ea 10             	shr    $0x10,%edx
80102a94:	80 fa 03             	cmp    $0x3,%dl
80102a97:	77 77                	ja     80102b10 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a99:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102aa0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aa6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102aad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ab3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102aba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102abd:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ac0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ac7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aca:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102acd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ad4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ada:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ae1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae4:	8b 50 20             	mov    0x20(%eax),%edx
80102ae7:	89 f6                	mov    %esi,%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102af0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102af6:	80 e6 10             	and    $0x10,%dh
80102af9:	75 f5                	jne    80102af0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102afb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b02:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b05:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b08:	5d                   	pop    %ebp
80102b09:	c3                   	ret    
80102b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b10:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b17:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b1a:	8b 50 20             	mov    0x20(%eax),%edx
80102b1d:	e9 77 ff ff ff       	jmp    80102a99 <lapicinit+0x69>
80102b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b30 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102b30:	a1 9c 36 11 80       	mov    0x8011369c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102b35:	55                   	push   %ebp
80102b36:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b38:	85 c0                	test   %eax,%eax
80102b3a:	74 0c                	je     80102b48 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102b3c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102b3f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102b40:	c1 e8 18             	shr    $0x18,%eax
}
80102b43:	c3                   	ret    
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102b48:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102b4a:	5d                   	pop    %ebp
80102b4b:	c3                   	ret    
80102b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b50 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b50:	a1 9c 36 11 80       	mov    0x8011369c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102b55:	55                   	push   %ebp
80102b56:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b58:	85 c0                	test   %eax,%eax
80102b5a:	74 0d                	je     80102b69 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b5c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b63:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b66:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102b69:	5d                   	pop    %ebp
80102b6a:	c3                   	ret    
80102b6b:	90                   	nop
80102b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b70 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
}
80102b73:	5d                   	pop    %ebp
80102b74:	c3                   	ret    
80102b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b80:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b81:	ba 70 00 00 00       	mov    $0x70,%edx
80102b86:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b8b:	89 e5                	mov    %esp,%ebp
80102b8d:	53                   	push   %ebx
80102b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b94:	ee                   	out    %al,(%dx)
80102b95:	ba 71 00 00 00       	mov    $0x71,%edx
80102b9a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b9f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ba0:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ba2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ba5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102bab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bad:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102bb0:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bb3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bb5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102bb8:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bbe:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102bc3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bc9:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bcc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102bd3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd6:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bd9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102be0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102be3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102be6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bec:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bf5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bf8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bfe:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102c01:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c07:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102c0a:	5b                   	pop    %ebx
80102c0b:	5d                   	pop    %ebp
80102c0c:	c3                   	ret    
80102c0d:	8d 76 00             	lea    0x0(%esi),%esi

80102c10 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102c10:	55                   	push   %ebp
80102c11:	ba 70 00 00 00       	mov    $0x70,%edx
80102c16:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c1b:	89 e5                	mov    %esp,%ebp
80102c1d:	57                   	push   %edi
80102c1e:	56                   	push   %esi
80102c1f:	53                   	push   %ebx
80102c20:	83 ec 4c             	sub    $0x4c,%esp
80102c23:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c24:	ba 71 00 00 00       	mov    $0x71,%edx
80102c29:	ec                   	in     (%dx),%al
80102c2a:	83 e0 04             	and    $0x4,%eax
80102c2d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c30:	31 db                	xor    %ebx,%ebx
80102c32:	88 45 b7             	mov    %al,-0x49(%ebp)
80102c35:	bf 70 00 00 00       	mov    $0x70,%edi
80102c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c40:	89 d8                	mov    %ebx,%eax
80102c42:	89 fa                	mov    %edi,%edx
80102c44:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c45:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c4a:	89 ca                	mov    %ecx,%edx
80102c4c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c4d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c50:	89 fa                	mov    %edi,%edx
80102c52:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c55:	b8 02 00 00 00       	mov    $0x2,%eax
80102c5a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5b:	89 ca                	mov    %ecx,%edx
80102c5d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c5e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c61:	89 fa                	mov    %edi,%edx
80102c63:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c66:	b8 04 00 00 00       	mov    $0x4,%eax
80102c6b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c6f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 fa                	mov    %edi,%edx
80102c74:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c77:	b8 07 00 00 00       	mov    $0x7,%eax
80102c7c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7d:	89 ca                	mov    %ecx,%edx
80102c7f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c80:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c83:	89 fa                	mov    %edi,%edx
80102c85:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c88:	b8 08 00 00 00       	mov    $0x8,%eax
80102c8d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8e:	89 ca                	mov    %ecx,%edx
80102c90:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c91:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c94:	89 fa                	mov    %edi,%edx
80102c96:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102c99:	b8 09 00 00 00       	mov    $0x9,%eax
80102c9e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9f:	89 ca                	mov    %ecx,%edx
80102ca1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102ca2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca5:	89 fa                	mov    %edi,%edx
80102ca7:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102caa:	b8 0a 00 00 00       	mov    $0xa,%eax
80102caf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb0:	89 ca                	mov    %ecx,%edx
80102cb2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102cb3:	84 c0                	test   %al,%al
80102cb5:	78 89                	js     80102c40 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb7:	89 d8                	mov    %ebx,%eax
80102cb9:	89 fa                	mov    %edi,%edx
80102cbb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbc:	89 ca                	mov    %ecx,%edx
80102cbe:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102cbf:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc2:	89 fa                	mov    %edi,%edx
80102cc4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102cc7:	b8 02 00 00 00       	mov    $0x2,%eax
80102ccc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccd:	89 ca                	mov    %ecx,%edx
80102ccf:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102cd0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd3:	89 fa                	mov    %edi,%edx
80102cd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102cd8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cdd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cde:	89 ca                	mov    %ecx,%edx
80102ce0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102ce1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce4:	89 fa                	mov    %edi,%edx
80102ce6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ce9:	b8 07 00 00 00       	mov    $0x7,%eax
80102cee:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cef:	89 ca                	mov    %ecx,%edx
80102cf1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102cf2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf5:	89 fa                	mov    %edi,%edx
80102cf7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102cfa:	b8 08 00 00 00       	mov    $0x8,%eax
80102cff:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d00:	89 ca                	mov    %ecx,%edx
80102d02:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102d03:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d06:	89 fa                	mov    %edi,%edx
80102d08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d0b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d10:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d11:	89 ca                	mov    %ecx,%edx
80102d13:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102d14:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d17:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102d1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d1d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d20:	6a 18                	push   $0x18
80102d22:	56                   	push   %esi
80102d23:	50                   	push   %eax
80102d24:	e8 a7 1f 00 00       	call   80104cd0 <memcmp>
80102d29:	83 c4 10             	add    $0x10,%esp
80102d2c:	85 c0                	test   %eax,%eax
80102d2e:	0f 85 0c ff ff ff    	jne    80102c40 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102d34:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102d38:	75 78                	jne    80102db2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d3a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d3d:	89 c2                	mov    %eax,%edx
80102d3f:	83 e0 0f             	and    $0xf,%eax
80102d42:	c1 ea 04             	shr    $0x4,%edx
80102d45:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d48:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d4b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d4e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d51:	89 c2                	mov    %eax,%edx
80102d53:	83 e0 0f             	and    $0xf,%eax
80102d56:	c1 ea 04             	shr    $0x4,%edx
80102d59:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d5f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d62:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d65:	89 c2                	mov    %eax,%edx
80102d67:	83 e0 0f             	and    $0xf,%eax
80102d6a:	c1 ea 04             	shr    $0x4,%edx
80102d6d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d70:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d73:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d76:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d79:	89 c2                	mov    %eax,%edx
80102d7b:	83 e0 0f             	and    $0xf,%eax
80102d7e:	c1 ea 04             	shr    $0x4,%edx
80102d81:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d84:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d87:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d8a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d8d:	89 c2                	mov    %eax,%edx
80102d8f:	83 e0 0f             	and    $0xf,%eax
80102d92:	c1 ea 04             	shr    $0x4,%edx
80102d95:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d98:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d9b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102da1:	89 c2                	mov    %eax,%edx
80102da3:	83 e0 0f             	and    $0xf,%eax
80102da6:	c1 ea 04             	shr    $0x4,%edx
80102da9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dac:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102daf:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102db2:	8b 75 08             	mov    0x8(%ebp),%esi
80102db5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102db8:	89 06                	mov    %eax,(%esi)
80102dba:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102dbd:	89 46 04             	mov    %eax,0x4(%esi)
80102dc0:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102dc3:	89 46 08             	mov    %eax,0x8(%esi)
80102dc6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dc9:	89 46 0c             	mov    %eax,0xc(%esi)
80102dcc:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102dcf:	89 46 10             	mov    %eax,0x10(%esi)
80102dd2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102dd5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102dd8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102de2:	5b                   	pop    %ebx
80102de3:	5e                   	pop    %esi
80102de4:	5f                   	pop    %edi
80102de5:	5d                   	pop    %ebp
80102de6:	c3                   	ret    
80102de7:	66 90                	xchg   %ax,%ax
80102de9:	66 90                	xchg   %ax,%ax
80102deb:	66 90                	xchg   %ax,%ax
80102ded:	66 90                	xchg   %ax,%ax
80102def:	90                   	nop

80102df0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102df0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102df6:	85 c9                	test   %ecx,%ecx
80102df8:	0f 8e 85 00 00 00    	jle    80102e83 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102dfe:	55                   	push   %ebp
80102dff:	89 e5                	mov    %esp,%ebp
80102e01:	57                   	push   %edi
80102e02:	56                   	push   %esi
80102e03:	53                   	push   %ebx
80102e04:	31 db                	xor    %ebx,%ebx
80102e06:	83 ec 0c             	sub    $0xc,%esp
80102e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e10:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e15:	83 ec 08             	sub    $0x8,%esp
80102e18:	01 d8                	add    %ebx,%eax
80102e1a:	83 c0 01             	add    $0x1,%eax
80102e1d:	50                   	push   %eax
80102e1e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102e24:	e8 a7 d2 ff ff       	call   801000d0 <bread>
80102e29:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e2b:	58                   	pop    %eax
80102e2c:	5a                   	pop    %edx
80102e2d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102e34:	ff 35 e4 36 11 80    	pushl  0x801136e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e3a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e3d:	e8 8e d2 ff ff       	call   801000d0 <bread>
80102e42:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e44:	8d 47 5c             	lea    0x5c(%edi),%eax
80102e47:	83 c4 0c             	add    $0xc,%esp
80102e4a:	68 00 02 00 00       	push   $0x200
80102e4f:	50                   	push   %eax
80102e50:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e53:	50                   	push   %eax
80102e54:	e8 d7 1e 00 00       	call   80104d30 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e59:	89 34 24             	mov    %esi,(%esp)
80102e5c:	e8 3f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e61:	89 3c 24             	mov    %edi,(%esp)
80102e64:	e8 77 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e69:	89 34 24             	mov    %esi,(%esp)
80102e6c:	e8 6f d3 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e71:	83 c4 10             	add    $0x10,%esp
80102e74:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102e7a:	7f 94                	jg     80102e10 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e7f:	5b                   	pop    %ebx
80102e80:	5e                   	pop    %esi
80102e81:	5f                   	pop    %edi
80102e82:	5d                   	pop    %ebp
80102e83:	f3 c3                	repz ret 
80102e85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	53                   	push   %ebx
80102e94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e97:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102e9d:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102ea3:	e8 28 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ea8:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102eae:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102eb1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102eb3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102eb5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102eb8:	7e 1f                	jle    80102ed9 <write_head+0x49>
80102eba:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102ec1:	31 d2                	xor    %edx,%edx
80102ec3:	90                   	nop
80102ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ec8:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102ece:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102ed2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ed5:	39 c2                	cmp    %eax,%edx
80102ed7:	75 ef                	jne    80102ec8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102ed9:	83 ec 0c             	sub    $0xc,%esp
80102edc:	53                   	push   %ebx
80102edd:	e8 be d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ee2:	89 1c 24             	mov    %ebx,(%esp)
80102ee5:	e8 f6 d2 ff ff       	call   801001e0 <brelse>
}
80102eea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eed:	c9                   	leave  
80102eee:	c3                   	ret    
80102eef:	90                   	nop

80102ef0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	53                   	push   %ebx
80102ef4:	83 ec 2c             	sub    $0x2c,%esp
80102ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102efa:	68 20 82 10 80       	push   $0x80108220
80102eff:	68 a0 36 11 80       	push   $0x801136a0
80102f04:	e8 07 1b 00 00       	call   80104a10 <initlock>
  readsb(dev, &sb);
80102f09:	58                   	pop    %eax
80102f0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f0d:	5a                   	pop    %edx
80102f0e:	50                   	push   %eax
80102f0f:	53                   	push   %ebx
80102f10:	e8 cb e4 ff ff       	call   801013e0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102f15:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102f18:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102f1b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102f1c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102f22:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102f28:	a3 d4 36 11 80       	mov    %eax,0x801136d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102f2d:	5a                   	pop    %edx
80102f2e:	50                   	push   %eax
80102f2f:	53                   	push   %ebx
80102f30:	e8 9b d1 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102f35:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f38:	83 c4 10             	add    $0x10,%esp
80102f3b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102f3d:	89 0d e8 36 11 80    	mov    %ecx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102f43:	7e 1c                	jle    80102f61 <initlog+0x71>
80102f45:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102f4c:	31 d2                	xor    %edx,%edx
80102f4e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f50:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f54:	83 c2 04             	add    $0x4,%edx
80102f57:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102f5d:	39 da                	cmp    %ebx,%edx
80102f5f:	75 ef                	jne    80102f50 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102f61:	83 ec 0c             	sub    $0xc,%esp
80102f64:	50                   	push   %eax
80102f65:	e8 76 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f6a:	e8 81 fe ff ff       	call   80102df0 <install_trans>
  log.lh.n = 0;
80102f6f:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102f76:	00 00 00 
  write_head(); // clear the log
80102f79:	e8 12 ff ff ff       	call   80102e90 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102f7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f81:	c9                   	leave  
80102f82:	c3                   	ret    
80102f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f96:	68 a0 36 11 80       	push   $0x801136a0
80102f9b:	e8 70 1b 00 00       	call   80104b10 <acquire>
80102fa0:	83 c4 10             	add    $0x10,%esp
80102fa3:	eb 18                	jmp    80102fbd <begin_op+0x2d>
80102fa5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102fa8:	83 ec 08             	sub    $0x8,%esp
80102fab:	68 a0 36 11 80       	push   $0x801136a0
80102fb0:	68 a0 36 11 80       	push   $0x801136a0
80102fb5:	e8 c6 14 00 00       	call   80104480 <sleep>
80102fba:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102fbd:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102fc2:	85 c0                	test   %eax,%eax
80102fc4:	75 e2                	jne    80102fa8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fc6:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102fcb:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102fd1:	83 c0 01             	add    $0x1,%eax
80102fd4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fd7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fda:	83 fa 1e             	cmp    $0x1e,%edx
80102fdd:	7f c9                	jg     80102fa8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fdf:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102fe2:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102fe7:	68 a0 36 11 80       	push   $0x801136a0
80102fec:	e8 3f 1c 00 00       	call   80104c30 <release>
      break;
    }
  }
}
80102ff1:	83 c4 10             	add    $0x10,%esp
80102ff4:	c9                   	leave  
80102ff5:	c3                   	ret    
80102ff6:	8d 76 00             	lea    0x0(%esi),%esi
80102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103000 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
80103005:	53                   	push   %ebx
80103006:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103009:	68 a0 36 11 80       	push   $0x801136a0
8010300e:	e8 fd 1a 00 00       	call   80104b10 <acquire>
  log.outstanding -= 1;
80103013:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80103018:	8b 1d e0 36 11 80    	mov    0x801136e0,%ebx
8010301e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80103021:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80103024:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80103026:	a3 dc 36 11 80       	mov    %eax,0x801136dc
  if(log.committing)
8010302b:	0f 85 23 01 00 00    	jne    80103154 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103031:	85 c0                	test   %eax,%eax
80103033:	0f 85 f7 00 00 00    	jne    80103130 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103039:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
8010303c:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80103043:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80103046:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103048:	68 a0 36 11 80       	push   $0x801136a0
8010304d:	e8 de 1b 00 00       	call   80104c30 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103052:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80103058:	83 c4 10             	add    $0x10,%esp
8010305b:	85 c9                	test   %ecx,%ecx
8010305d:	0f 8e 8a 00 00 00    	jle    801030ed <end_op+0xed>
80103063:	90                   	nop
80103064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103068:	a1 d4 36 11 80       	mov    0x801136d4,%eax
8010306d:	83 ec 08             	sub    $0x8,%esp
80103070:	01 d8                	add    %ebx,%eax
80103072:	83 c0 01             	add    $0x1,%eax
80103075:	50                   	push   %eax
80103076:	ff 35 e4 36 11 80    	pushl  0x801136e4
8010307c:	e8 4f d0 ff ff       	call   801000d0 <bread>
80103081:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103083:	58                   	pop    %eax
80103084:	5a                   	pop    %edx
80103085:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
8010308c:	ff 35 e4 36 11 80    	pushl  0x801136e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103092:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103095:	e8 36 d0 ff ff       	call   801000d0 <bread>
8010309a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010309c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010309f:	83 c4 0c             	add    $0xc,%esp
801030a2:	68 00 02 00 00       	push   $0x200
801030a7:	50                   	push   %eax
801030a8:	8d 46 5c             	lea    0x5c(%esi),%eax
801030ab:	50                   	push   %eax
801030ac:	e8 7f 1c 00 00       	call   80104d30 <memmove>
    bwrite(to);  // write the log
801030b1:	89 34 24             	mov    %esi,(%esp)
801030b4:	e8 e7 d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
801030b9:	89 3c 24             	mov    %edi,(%esp)
801030bc:	e8 1f d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
801030c1:	89 34 24             	mov    %esi,(%esp)
801030c4:	e8 17 d1 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030c9:	83 c4 10             	add    $0x10,%esp
801030cc:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
801030d2:	7c 94                	jl     80103068 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030d4:	e8 b7 fd ff ff       	call   80102e90 <write_head>
    install_trans(); // Now install writes to home locations
801030d9:	e8 12 fd ff ff       	call   80102df0 <install_trans>
    log.lh.n = 0;
801030de:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
801030e5:	00 00 00 
    write_head();    // Erase the transaction from the log
801030e8:	e8 a3 fd ff ff       	call   80102e90 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
801030ed:	83 ec 0c             	sub    $0xc,%esp
801030f0:	68 a0 36 11 80       	push   $0x801136a0
801030f5:	e8 16 1a 00 00       	call   80104b10 <acquire>
    log.committing = 0;
    wakeup(&log);
801030fa:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80103101:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80103108:	00 00 00 
    wakeup(&log);
8010310b:	e8 e0 15 00 00       	call   801046f0 <wakeup>
    release(&log.lock);
80103110:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103117:	e8 14 1b 00 00       	call   80104c30 <release>
8010311c:	83 c4 10             	add    $0x10,%esp
  }
}
8010311f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103122:	5b                   	pop    %ebx
80103123:	5e                   	pop    %esi
80103124:	5f                   	pop    %edi
80103125:	5d                   	pop    %ebp
80103126:	c3                   	ret    
80103127:	89 f6                	mov    %esi,%esi
80103129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103130:	83 ec 0c             	sub    $0xc,%esp
80103133:	68 a0 36 11 80       	push   $0x801136a0
80103138:	e8 b3 15 00 00       	call   801046f0 <wakeup>
  }
  release(&log.lock);
8010313d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103144:	e8 e7 1a 00 00       	call   80104c30 <release>
80103149:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
8010314c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010314f:	5b                   	pop    %ebx
80103150:	5e                   	pop    %esi
80103151:	5f                   	pop    %edi
80103152:	5d                   	pop    %ebp
80103153:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80103154:	83 ec 0c             	sub    $0xc,%esp
80103157:	68 24 82 10 80       	push   $0x80108224
8010315c:	e8 0f d2 ff ff       	call   80100370 <panic>
80103161:	eb 0d                	jmp    80103170 <log_write>
80103163:	90                   	nop
80103164:	90                   	nop
80103165:	90                   	nop
80103166:	90                   	nop
80103167:	90                   	nop
80103168:	90                   	nop
80103169:	90                   	nop
8010316a:	90                   	nop
8010316b:	90                   	nop
8010316c:	90                   	nop
8010316d:	90                   	nop
8010316e:	90                   	nop
8010316f:	90                   	nop

80103170 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	53                   	push   %ebx
80103174:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103177:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010317d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103180:	83 fa 1d             	cmp    $0x1d,%edx
80103183:	0f 8f 97 00 00 00    	jg     80103220 <log_write+0xb0>
80103189:	a1 d8 36 11 80       	mov    0x801136d8,%eax
8010318e:	83 e8 01             	sub    $0x1,%eax
80103191:	39 c2                	cmp    %eax,%edx
80103193:	0f 8d 87 00 00 00    	jge    80103220 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103199:	a1 dc 36 11 80       	mov    0x801136dc,%eax
8010319e:	85 c0                	test   %eax,%eax
801031a0:	0f 8e 87 00 00 00    	jle    8010322d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
801031a6:	83 ec 0c             	sub    $0xc,%esp
801031a9:	68 a0 36 11 80       	push   $0x801136a0
801031ae:	e8 5d 19 00 00       	call   80104b10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801031b3:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	83 fa 00             	cmp    $0x0,%edx
801031bf:	7e 50                	jle    80103211 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031c1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801031c4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031c6:	3b 0d ec 36 11 80    	cmp    0x801136ec,%ecx
801031cc:	75 0b                	jne    801031d9 <log_write+0x69>
801031ce:	eb 38                	jmp    80103208 <log_write+0x98>
801031d0:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
801031d7:	74 2f                	je     80103208 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801031d9:	83 c0 01             	add    $0x1,%eax
801031dc:	39 d0                	cmp    %edx,%eax
801031de:	75 f0                	jne    801031d0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801031e0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
801031e7:	83 c2 01             	add    $0x1,%edx
801031ea:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
801031f0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801031f3:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
801031fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031fd:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
801031fe:	e9 2d 1a 00 00       	jmp    80104c30 <release>
80103203:	90                   	nop
80103204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103208:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
8010320f:	eb df                	jmp    801031f0 <log_write+0x80>
80103211:	8b 43 08             	mov    0x8(%ebx),%eax
80103214:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80103219:	75 d5                	jne    801031f0 <log_write+0x80>
8010321b:	eb ca                	jmp    801031e7 <log_write+0x77>
8010321d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103220:	83 ec 0c             	sub    $0xc,%esp
80103223:	68 33 82 10 80       	push   $0x80108233
80103228:	e8 43 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010322d:	83 ec 0c             	sub    $0xc,%esp
80103230:	68 49 82 10 80       	push   $0x80108249
80103235:	e8 36 d1 ff ff       	call   80100370 <panic>
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <mpmain>:
  mpmain();
}

// Common CPU setup code.
static void
mpmain(void) {
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	53                   	push   %ebx
80103244:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103247:	e8 24 0a 00 00       	call   80103c70 <cpuid>
8010324c:	89 c3                	mov    %eax,%ebx
8010324e:	e8 1d 0a 00 00       	call   80103c70 <cpuid>
80103253:	83 ec 04             	sub    $0x4,%esp
80103256:	53                   	push   %ebx
80103257:	50                   	push   %eax
80103258:	68 64 82 10 80       	push   $0x80108264
8010325d:	e8 fe d3 ff ff       	call   80100660 <cprintf>
    idtinit();       // load idt register
80103262:	e8 f9 2c 00 00       	call   80105f60 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103267:	e8 84 09 00 00       	call   80103bf0 <mycpu>
8010326c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010326e:	b8 01 00 00 00       	mov    $0x1,%eax
80103273:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
8010327a:	e8 e1 0e 00 00       	call   80104160 <scheduler>
8010327f:	90                   	nop

80103280 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103286:	e8 a5 3f 00 00       	call   80107230 <switchkvm>
  seginit();
8010328b:	e8 60 3e 00 00       	call   801070f0 <seginit>
  lapicinit();
80103290:	e8 9b f7 ff ff       	call   80102a30 <lapicinit>
  mpmain();
80103295:	e8 a6 ff ff ff       	call   80103240 <mpmain>
8010329a:	66 90                	xchg   %ax,%ax
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801032a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801032a4:	83 e4 f0             	and    $0xfffffff0,%esp
801032a7:	ff 71 fc             	pushl  -0x4(%ecx)
801032aa:	55                   	push   %ebp
801032ab:	89 e5                	mov    %esp,%ebp
801032ad:	53                   	push   %ebx
801032ae:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801032af:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801032b4:	83 ec 08             	sub    $0x8,%esp
801032b7:	68 00 00 40 80       	push   $0x80400000
801032bc:	68 ec 6c 12 80       	push   $0x80126cec
801032c1:	e8 3a f5 ff ff       	call   80102800 <kinit1>
  kvmalloc();      // kernel page table
801032c6:	e8 55 48 00 00       	call   80107b20 <kvmalloc>
  mpinit();        // detect other processors
801032cb:	e8 70 01 00 00       	call   80103440 <mpinit>
  lapicinit();     // interrupt controller
801032d0:	e8 5b f7 ff ff       	call   80102a30 <lapicinit>
  seginit();       // segment descriptors
801032d5:	e8 16 3e 00 00       	call   801070f0 <seginit>
  picinit();       // disable pic
801032da:	e8 31 03 00 00       	call   80103610 <picinit>
  ioapicinit();    // another interrupt controller
801032df:	e8 dc f2 ff ff       	call   801025c0 <ioapicinit>
  consoleinit();   // console hardware
801032e4:	e8 b7 d6 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
801032e9:	e8 72 31 00 00       	call   80106460 <uartinit>
  pinit();         // process table
801032ee:	e8 dd 08 00 00       	call   80103bd0 <pinit>
  tvinit();        // trap vectors
801032f3:	e8 c8 2b 00 00       	call   80105ec0 <tvinit>
  binit();         // buffer cache
801032f8:	e8 43 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032fd:	e8 7e da ff ff       	call   80100d80 <fileinit>
  ideinit();       // disk 
80103302:	e8 99 f0 ff ff       	call   801023a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103307:	83 c4 0c             	add    $0xc,%esp
8010330a:	68 8a 00 00 00       	push   $0x8a
8010330f:	68 8c b4 10 80       	push   $0x8010b48c
80103314:	68 00 70 00 80       	push   $0x80007000
80103319:	e8 12 1a 00 00       	call   80104d30 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010331e:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103325:	00 00 00 
80103328:	83 c4 10             	add    $0x10,%esp
8010332b:	05 a0 37 11 80       	add    $0x801137a0,%eax
80103330:	39 d8                	cmp    %ebx,%eax
80103332:	76 6f                	jbe    801033a3 <main+0x103>
80103334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103338:	e8 b3 08 00 00       	call   80103bf0 <mycpu>
8010333d:	39 d8                	cmp    %ebx,%eax
8010333f:	74 49                	je     8010338a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103341:	e8 8a f5 ff ff       	call   801028d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80103346:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
8010334b:	c7 05 f8 6f 00 80 80 	movl   $0x80103280,0x80006ff8
80103352:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103355:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010335c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010335f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103364:	0f b6 03             	movzbl (%ebx),%eax
80103367:	83 ec 08             	sub    $0x8,%esp
8010336a:	68 00 70 00 00       	push   $0x7000
8010336f:	50                   	push   %eax
80103370:	e8 0b f8 ff ff       	call   80102b80 <lapicstartap>
80103375:	83 c4 10             	add    $0x10,%esp
80103378:	90                   	nop
80103379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103380:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103386:	85 c0                	test   %eax,%eax
80103388:	74 f6                	je     80103380 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010338a:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103391:	00 00 00 
80103394:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010339a:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010339f:	39 c3                	cmp    %eax,%ebx
801033a1:	72 95                	jb     80103338 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033a3:	83 ec 08             	sub    $0x8,%esp
801033a6:	68 00 00 00 8e       	push   $0x8e000000
801033ab:	68 00 00 40 80       	push   $0x80400000
801033b0:	e8 bb f4 ff ff       	call   80102870 <kinit2>
  userinit();      // first user process
801033b5:	e8 06 09 00 00       	call   80103cc0 <userinit>
  mpmain();        // finish this processor's setup
801033ba:	e8 81 fe ff ff       	call   80103240 <mpmain>
801033bf:	90                   	nop

801033c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801033c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033cb:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
801033cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033cf:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801033d2:	39 de                	cmp    %ebx,%esi
801033d4:	73 48                	jae    8010341e <mpsearch1+0x5e>
801033d6:	8d 76 00             	lea    0x0(%esi),%esi
801033d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033e0:	83 ec 04             	sub    $0x4,%esp
801033e3:	8d 7e 10             	lea    0x10(%esi),%edi
801033e6:	6a 04                	push   $0x4
801033e8:	68 78 82 10 80       	push   $0x80108278
801033ed:	56                   	push   %esi
801033ee:	e8 dd 18 00 00       	call   80104cd0 <memcmp>
801033f3:	83 c4 10             	add    $0x10,%esp
801033f6:	85 c0                	test   %eax,%eax
801033f8:	75 1e                	jne    80103418 <mpsearch1+0x58>
801033fa:	8d 7e 10             	lea    0x10(%esi),%edi
801033fd:	89 f2                	mov    %esi,%edx
801033ff:	31 c9                	xor    %ecx,%ecx
80103401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103408:	0f b6 02             	movzbl (%edx),%eax
8010340b:	83 c2 01             	add    $0x1,%edx
8010340e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103410:	39 fa                	cmp    %edi,%edx
80103412:	75 f4                	jne    80103408 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103414:	84 c9                	test   %cl,%cl
80103416:	74 10                	je     80103428 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103418:	39 fb                	cmp    %edi,%ebx
8010341a:	89 fe                	mov    %edi,%esi
8010341c:	77 c2                	ja     801033e0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010341e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103421:	31 c0                	xor    %eax,%eax
}
80103423:	5b                   	pop    %ebx
80103424:	5e                   	pop    %esi
80103425:	5f                   	pop    %edi
80103426:	5d                   	pop    %ebp
80103427:	c3                   	ret    
80103428:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010342b:	89 f0                	mov    %esi,%eax
8010342d:	5b                   	pop    %ebx
8010342e:	5e                   	pop    %esi
8010342f:	5f                   	pop    %edi
80103430:	5d                   	pop    %ebp
80103431:	c3                   	ret    
80103432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103440 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103449:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103450:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103457:	c1 e0 08             	shl    $0x8,%eax
8010345a:	09 d0                	or     %edx,%eax
8010345c:	c1 e0 04             	shl    $0x4,%eax
8010345f:	85 c0                	test   %eax,%eax
80103461:	75 1b                	jne    8010347e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103463:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010346a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103471:	c1 e0 08             	shl    $0x8,%eax
80103474:	09 d0                	or     %edx,%eax
80103476:	c1 e0 0a             	shl    $0xa,%eax
80103479:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010347e:	ba 00 04 00 00       	mov    $0x400,%edx
80103483:	e8 38 ff ff ff       	call   801033c0 <mpsearch1>
80103488:	85 c0                	test   %eax,%eax
8010348a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010348d:	0f 84 37 01 00 00    	je     801035ca <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103496:	8b 58 04             	mov    0x4(%eax),%ebx
80103499:	85 db                	test   %ebx,%ebx
8010349b:	0f 84 43 01 00 00    	je     801035e4 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801034a7:	83 ec 04             	sub    $0x4,%esp
801034aa:	6a 04                	push   $0x4
801034ac:	68 7d 82 10 80       	push   $0x8010827d
801034b1:	56                   	push   %esi
801034b2:	e8 19 18 00 00       	call   80104cd0 <memcmp>
801034b7:	83 c4 10             	add    $0x10,%esp
801034ba:	85 c0                	test   %eax,%eax
801034bc:	0f 85 22 01 00 00    	jne    801035e4 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801034c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801034c9:	3c 01                	cmp    $0x1,%al
801034cb:	74 08                	je     801034d5 <mpinit+0x95>
801034cd:	3c 04                	cmp    $0x4,%al
801034cf:	0f 85 0f 01 00 00    	jne    801035e4 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801034d5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801034dc:	85 ff                	test   %edi,%edi
801034de:	74 21                	je     80103501 <mpinit+0xc1>
801034e0:	31 d2                	xor    %edx,%edx
801034e2:	31 c0                	xor    %eax,%eax
801034e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801034e8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801034ef:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801034f0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034f3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801034f5:	39 c7                	cmp    %eax,%edi
801034f7:	75 ef                	jne    801034e8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801034f9:	84 d2                	test   %dl,%dl
801034fb:	0f 85 e3 00 00 00    	jne    801035e4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103501:	85 f6                	test   %esi,%esi
80103503:	0f 84 db 00 00 00    	je     801035e4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103509:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010350f:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103514:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010351b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103521:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103526:	01 d6                	add    %edx,%esi
80103528:	90                   	nop
80103529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103530:	39 c6                	cmp    %eax,%esi
80103532:	76 23                	jbe    80103557 <mpinit+0x117>
80103534:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103537:	80 fa 04             	cmp    $0x4,%dl
8010353a:	0f 87 c0 00 00 00    	ja     80103600 <mpinit+0x1c0>
80103540:	ff 24 95 bc 82 10 80 	jmp    *-0x7fef7d44(,%edx,4)
80103547:	89 f6                	mov    %esi,%esi
80103549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103550:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103553:	39 c6                	cmp    %eax,%esi
80103555:	77 dd                	ja     80103534 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103557:	85 db                	test   %ebx,%ebx
80103559:	0f 84 92 00 00 00    	je     801035f1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010355f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103562:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103566:	74 15                	je     8010357d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103568:	ba 22 00 00 00       	mov    $0x22,%edx
8010356d:	b8 70 00 00 00       	mov    $0x70,%eax
80103572:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103573:	ba 23 00 00 00       	mov    $0x23,%edx
80103578:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103579:	83 c8 01             	or     $0x1,%eax
8010357c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010357d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103580:	5b                   	pop    %ebx
80103581:	5e                   	pop    %esi
80103582:	5f                   	pop    %edi
80103583:	5d                   	pop    %ebp
80103584:	c3                   	ret    
80103585:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103588:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
8010358e:	83 f9 07             	cmp    $0x7,%ecx
80103591:	7f 19                	jg     801035ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103593:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103597:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010359d:	83 c1 01             	add    $0x1,%ecx
801035a0:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035a6:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801035ac:	83 c0 14             	add    $0x14,%eax
      continue;
801035af:	e9 7c ff ff ff       	jmp    80103530 <mpinit+0xf0>
801035b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801035b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801035bc:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801035bf:	88 15 80 37 11 80    	mov    %dl,0x80113780
      p += sizeof(struct mpioapic);
      continue;
801035c5:	e9 66 ff ff ff       	jmp    80103530 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801035ca:	ba 00 00 01 00       	mov    $0x10000,%edx
801035cf:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801035d4:	e8 e7 fd ff ff       	call   801033c0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035d9:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801035db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035de:	0f 85 af fe ff ff    	jne    80103493 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801035e4:	83 ec 0c             	sub    $0xc,%esp
801035e7:	68 82 82 10 80       	push   $0x80108282
801035ec:	e8 7f cd ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 9c 82 10 80       	push   $0x8010829c
801035f9:	e8 72 cd ff ff       	call   80100370 <panic>
801035fe:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103600:	31 db                	xor    %ebx,%ebx
80103602:	e9 30 ff ff ff       	jmp    80103537 <mpinit+0xf7>
80103607:	66 90                	xchg   %ax,%ax
80103609:	66 90                	xchg   %ax,%ax
8010360b:	66 90                	xchg   %ax,%ax
8010360d:	66 90                	xchg   %ax,%ax
8010360f:	90                   	nop

80103610 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103610:	55                   	push   %ebp
80103611:	ba 21 00 00 00       	mov    $0x21,%edx
80103616:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010361b:	89 e5                	mov    %esp,%ebp
8010361d:	ee                   	out    %al,(%dx)
8010361e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103623:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103624:	5d                   	pop    %ebp
80103625:	c3                   	ret    
80103626:	66 90                	xchg   %ax,%ax
80103628:	66 90                	xchg   %ax,%ax
8010362a:	66 90                	xchg   %ax,%ax
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 0c             	sub    $0xc,%esp
80103639:	8b 75 08             	mov    0x8(%ebp),%esi
8010363c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010363f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103645:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010364b:	e8 50 d7 ff ff       	call   80100da0 <filealloc>
80103650:	85 c0                	test   %eax,%eax
80103652:	89 06                	mov    %eax,(%esi)
80103654:	0f 84 a8 00 00 00    	je     80103702 <pipealloc+0xd2>
8010365a:	e8 41 d7 ff ff       	call   80100da0 <filealloc>
8010365f:	85 c0                	test   %eax,%eax
80103661:	89 03                	mov    %eax,(%ebx)
80103663:	0f 84 87 00 00 00    	je     801036f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103669:	e8 62 f2 ff ff       	call   801028d0 <kalloc>
8010366e:	85 c0                	test   %eax,%eax
80103670:	89 c7                	mov    %eax,%edi
80103672:	0f 84 b0 00 00 00    	je     80103728 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103678:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010367b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103682:	00 00 00 
  p->writeopen = 1;
80103685:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010368c:	00 00 00 
  p->nwrite = 0;
8010368f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103696:	00 00 00 
  p->nread = 0;
80103699:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036a0:	00 00 00 
  initlock(&p->lock, "pipe");
801036a3:	68 d0 82 10 80       	push   $0x801082d0
801036a8:	50                   	push   %eax
801036a9:	e8 62 13 00 00       	call   80104a10 <initlock>
  (*f0)->type = FD_PIPE;
801036ae:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036b0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801036b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036b9:	8b 06                	mov    (%esi),%eax
801036bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036bf:	8b 06                	mov    (%esi),%eax
801036c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036c5:	8b 06                	mov    (%esi),%eax
801036c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036ca:	8b 03                	mov    (%ebx),%eax
801036cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036d2:	8b 03                	mov    (%ebx),%eax
801036d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036d8:	8b 03                	mov    (%ebx),%eax
801036da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036de:	8b 03                	mov    (%ebx),%eax
801036e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036e6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036e8:	5b                   	pop    %ebx
801036e9:	5e                   	pop    %esi
801036ea:	5f                   	pop    %edi
801036eb:	5d                   	pop    %ebp
801036ec:	c3                   	ret    
801036ed:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036f0:	8b 06                	mov    (%esi),%eax
801036f2:	85 c0                	test   %eax,%eax
801036f4:	74 1e                	je     80103714 <pipealloc+0xe4>
    fileclose(*f0);
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	50                   	push   %eax
801036fa:	e8 61 d7 ff ff       	call   80100e60 <fileclose>
801036ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103702:	8b 03                	mov    (%ebx),%eax
80103704:	85 c0                	test   %eax,%eax
80103706:	74 0c                	je     80103714 <pipealloc+0xe4>
    fileclose(*f1);
80103708:	83 ec 0c             	sub    $0xc,%esp
8010370b:	50                   	push   %eax
8010370c:	e8 4f d7 ff ff       	call   80100e60 <fileclose>
80103711:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103714:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103717:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010371c:	5b                   	pop    %ebx
8010371d:	5e                   	pop    %esi
8010371e:	5f                   	pop    %edi
8010371f:	5d                   	pop    %ebp
80103720:	c3                   	ret    
80103721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103728:	8b 06                	mov    (%esi),%eax
8010372a:	85 c0                	test   %eax,%eax
8010372c:	75 c8                	jne    801036f6 <pipealloc+0xc6>
8010372e:	eb d2                	jmp    80103702 <pipealloc+0xd2>

80103730 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx
80103735:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103738:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	53                   	push   %ebx
8010373f:	e8 cc 13 00 00       	call   80104b10 <acquire>
  if(writable){
80103744:	83 c4 10             	add    $0x10,%esp
80103747:	85 f6                	test   %esi,%esi
80103749:	74 45                	je     80103790 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010374b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103751:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103754:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010375b:	00 00 00 
    wakeup(&p->nread);
8010375e:	50                   	push   %eax
8010375f:	e8 8c 0f 00 00       	call   801046f0 <wakeup>
80103764:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103767:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010376d:	85 d2                	test   %edx,%edx
8010376f:	75 0a                	jne    8010377b <pipeclose+0x4b>
80103771:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103777:	85 c0                	test   %eax,%eax
80103779:	74 35                	je     801037b0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010377b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010377e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103781:	5b                   	pop    %ebx
80103782:	5e                   	pop    %esi
80103783:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103784:	e9 a7 14 00 00       	jmp    80104c30 <release>
80103789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103790:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103796:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103799:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037a0:	00 00 00 
    wakeup(&p->nwrite);
801037a3:	50                   	push   %eax
801037a4:	e8 47 0f 00 00       	call   801046f0 <wakeup>
801037a9:	83 c4 10             	add    $0x10,%esp
801037ac:	eb b9                	jmp    80103767 <pipeclose+0x37>
801037ae:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801037b0:	83 ec 0c             	sub    $0xc,%esp
801037b3:	53                   	push   %ebx
801037b4:	e8 77 14 00 00       	call   80104c30 <release>
    kfree((char*)p);
801037b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037bc:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801037bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037c2:	5b                   	pop    %ebx
801037c3:	5e                   	pop    %esi
801037c4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801037c5:	e9 56 ef ff ff       	jmp    80102720 <kfree>
801037ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037d0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	57                   	push   %edi
801037d4:	56                   	push   %esi
801037d5:	53                   	push   %ebx
801037d6:	83 ec 28             	sub    $0x28,%esp
801037d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037dc:	53                   	push   %ebx
801037dd:	e8 2e 13 00 00       	call   80104b10 <acquire>
  for(i = 0; i < n; i++){
801037e2:	8b 45 10             	mov    0x10(%ebp),%eax
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	85 c0                	test   %eax,%eax
801037ea:	0f 8e b9 00 00 00    	jle    801038a9 <pipewrite+0xd9>
801037f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037f3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037ff:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103805:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103808:	03 4d 10             	add    0x10(%ebp),%ecx
8010380b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010380e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103814:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010381a:	39 d0                	cmp    %edx,%eax
8010381c:	74 38                	je     80103856 <pipewrite+0x86>
8010381e:	eb 59                	jmp    80103879 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103820:	e8 6b 04 00 00       	call   80103c90 <myproc>
80103825:	8b 48 24             	mov    0x24(%eax),%ecx
80103828:	85 c9                	test   %ecx,%ecx
8010382a:	75 34                	jne    80103860 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010382c:	83 ec 0c             	sub    $0xc,%esp
8010382f:	57                   	push   %edi
80103830:	e8 bb 0e 00 00       	call   801046f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103835:	58                   	pop    %eax
80103836:	5a                   	pop    %edx
80103837:	53                   	push   %ebx
80103838:	56                   	push   %esi
80103839:	e8 42 0c 00 00       	call   80104480 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010383e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103844:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010384a:	83 c4 10             	add    $0x10,%esp
8010384d:	05 00 02 00 00       	add    $0x200,%eax
80103852:	39 c2                	cmp    %eax,%edx
80103854:	75 2a                	jne    80103880 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103856:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010385c:	85 c0                	test   %eax,%eax
8010385e:	75 c0                	jne    80103820 <pipewrite+0x50>
        release(&p->lock);
80103860:	83 ec 0c             	sub    $0xc,%esp
80103863:	53                   	push   %ebx
80103864:	e8 c7 13 00 00       	call   80104c30 <release>
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
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103879:	89 c2                	mov    %eax,%edx
8010387b:	90                   	nop
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103880:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103883:	8d 42 01             	lea    0x1(%edx),%eax
80103886:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010388a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103890:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103896:	0f b6 09             	movzbl (%ecx),%ecx
80103899:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010389d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801038a0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801038a3:	0f 85 65 ff ff ff    	jne    8010380e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038a9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038af:	83 ec 0c             	sub    $0xc,%esp
801038b2:	50                   	push   %eax
801038b3:	e8 38 0e 00 00       	call   801046f0 <wakeup>
  release(&p->lock);
801038b8:	89 1c 24             	mov    %ebx,(%esp)
801038bb:	e8 70 13 00 00       	call   80104c30 <release>
  return n;
801038c0:	83 c4 10             	add    $0x10,%esp
801038c3:	8b 45 10             	mov    0x10(%ebp),%eax
801038c6:	eb a9                	jmp    80103871 <pipewrite+0xa1>
801038c8:	90                   	nop
801038c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038d0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	83 ec 18             	sub    $0x18,%esp
801038d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038df:	53                   	push   %ebx
801038e0:	e8 2b 12 00 00       	call   80104b10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038e5:	83 c4 10             	add    $0x10,%esp
801038e8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038ee:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801038f4:	75 6a                	jne    80103960 <piperead+0x90>
801038f6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801038fc:	85 f6                	test   %esi,%esi
801038fe:	0f 84 cc 00 00 00    	je     801039d0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103904:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010390a:	eb 2d                	jmp    80103939 <piperead+0x69>
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103910:	83 ec 08             	sub    $0x8,%esp
80103913:	53                   	push   %ebx
80103914:	56                   	push   %esi
80103915:	e8 66 0b 00 00       	call   80104480 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010391a:	83 c4 10             	add    $0x10,%esp
8010391d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103923:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103929:	75 35                	jne    80103960 <piperead+0x90>
8010392b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103931:	85 d2                	test   %edx,%edx
80103933:	0f 84 97 00 00 00    	je     801039d0 <piperead+0x100>
    if(myproc()->killed){
80103939:	e8 52 03 00 00       	call   80103c90 <myproc>
8010393e:	8b 48 24             	mov    0x24(%eax),%ecx
80103941:	85 c9                	test   %ecx,%ecx
80103943:	74 cb                	je     80103910 <piperead+0x40>
      release(&p->lock);
80103945:	83 ec 0c             	sub    $0xc,%esp
80103948:	53                   	push   %ebx
80103949:	e8 e2 12 00 00       	call   80104c30 <release>
      return -1;
8010394e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103951:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103954:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103959:	5b                   	pop    %ebx
8010395a:	5e                   	pop    %esi
8010395b:	5f                   	pop    %edi
8010395c:	5d                   	pop    %ebp
8010395d:	c3                   	ret    
8010395e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103960:	8b 45 10             	mov    0x10(%ebp),%eax
80103963:	85 c0                	test   %eax,%eax
80103965:	7e 69                	jle    801039d0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103967:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010396d:	31 c9                	xor    %ecx,%ecx
8010396f:	eb 15                	jmp    80103986 <piperead+0xb6>
80103971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103978:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010397e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103984:	74 5a                	je     801039e0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103986:	8d 70 01             	lea    0x1(%eax),%esi
80103989:	25 ff 01 00 00       	and    $0x1ff,%eax
8010398e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103994:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103999:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010399c:	83 c1 01             	add    $0x1,%ecx
8010399f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801039a2:	75 d4                	jne    80103978 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801039a4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801039aa:	83 ec 0c             	sub    $0xc,%esp
801039ad:	50                   	push   %eax
801039ae:	e8 3d 0d 00 00       	call   801046f0 <wakeup>
  release(&p->lock);
801039b3:	89 1c 24             	mov    %ebx,(%esp)
801039b6:	e8 75 12 00 00       	call   80104c30 <release>
  return i;
801039bb:	8b 45 10             	mov    0x10(%ebp),%eax
801039be:	83 c4 10             	add    $0x10,%esp
}
801039c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039c4:	5b                   	pop    %ebx
801039c5:	5e                   	pop    %esi
801039c6:	5f                   	pop    %edi
801039c7:	5d                   	pop    %ebp
801039c8:	c3                   	ret    
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039d0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801039d7:	eb cb                	jmp    801039a4 <piperead+0xd4>
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039e0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801039e3:	eb bf                	jmp    801039a4 <piperead+0xd4>
801039e5:	66 90                	xchg   %ax,%ax
801039e7:	66 90                	xchg   %ax,%ax
801039e9:	66 90                	xchg   %ax,%ax
801039eb:	66 90                	xchg   %ax,%ax
801039ed:	66 90                	xchg   %ax,%ax
801039ef:	90                   	nop

801039f0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	53                   	push   %ebx
#endif


    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039f4:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
801039f9:	83 ec 10             	sub    $0x10,%esp
#if(defined(LIFO) || defined(SCFIFO))
    struct page *pg;
#endif


    acquire(&ptable.lock);
801039fc:	68 40 4d 11 80       	push   $0x80114d40
80103a01:	e8 0a 11 00 00       	call   80104b10 <acquire>
80103a06:	83 c4 10             	add    $0x10,%esp
80103a09:	eb 17                	jmp    80103a22 <allocproc+0x32>
80103a0b:	90                   	nop
80103a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a10:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
80103a16:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
80103a1c:	0f 84 1e 01 00 00    	je     80103b40 <allocproc+0x150>
        if (p->state == UNUSED)
80103a22:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a25:	85 c0                	test   %eax,%eax
80103a27:	75 e7                	jne    80103a10 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103a29:	a1 04 b0 10 80       	mov    0x8010b004,%eax

    release(&ptable.lock);
80103a2e:	83 ec 0c             	sub    $0xc,%esp

    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
80103a31:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;

    release(&ptable.lock);
80103a38:	68 40 4d 11 80       	push   $0x80114d40
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103a3d:	8d 50 01             	lea    0x1(%eax),%edx
80103a40:	89 43 10             	mov    %eax,0x10(%ebx)
80103a43:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

    release(&ptable.lock);
80103a49:	e8 e2 11 00 00       	call   80104c30 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
80103a4e:	e8 7d ee ff ff       	call   801028d0 <kalloc>
80103a53:	83 c4 10             	add    $0x10,%esp
80103a56:	85 c0                	test   %eax,%eax
80103a58:	89 43 08             	mov    %eax,0x8(%ebx)
80103a5b:	0f 84 f6 00 00 00    	je     80103b57 <allocproc+0x167>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103a61:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
80103a67:	83 ec 04             	sub    $0x4,%esp
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
80103a6a:	05 9c 0f 00 00       	add    $0xf9c,%eax
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103a6f:	89 53 18             	mov    %edx,0x18(%ebx)
    p->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;
80103a72:	c7 40 14 b2 5e 10 80 	movl   $0x80105eb2,0x14(%eax)

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
80103a79:	6a 14                	push   $0x14
80103a7b:	6a 00                	push   $0x0
80103a7d:	50                   	push   %eax
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
80103a7e:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103a81:	e8 fa 11 00 00       	call   80104c80 <memset>
    p->context->eip = (uint) forkret;
80103a86:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a89:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
80103a8f:	8d 93 40 04 00 00    	lea    0x440(%ebx),%edx
80103a95:	83 c4 10             	add    $0x10,%esp
80103a98:	c7 40 10 60 3b 10 80 	movl   $0x80103b60,0x10(%eax)

    //TODO INIT PROC PAGES FIELDS
#if(defined(LIFO) || defined(SCFIFO))
    p->pagesCounter = 0;
80103a9f:	c7 83 44 04 00 00 00 	movl   $0x0,0x444(%ebx)
80103aa6:	00 00 00 
80103aa9:	89 c8                	mov    %ecx,%eax
    p->nextpageid = 1;
80103aab:	c7 83 40 04 00 00 01 	movl   $0x1,0x440(%ebx)
80103ab2:	00 00 00 
//    p->swapOffset = 0;
    p->pagesequel = 0;
80103ab5:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
80103abc:	00 00 00 
    p->pagesinSwap = 0;
80103abf:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
80103ac6:	00 00 00 
    p->protectedPages = 0;
80103ac9:	c7 83 50 04 00 00 00 	movl   $0x0,0x450(%ebx)
80103ad0:	00 00 00 
    p->pageFaults = 0;
80103ad3:	c7 83 54 04 00 00 00 	movl   $0x0,0x454(%ebx)
80103ada:	00 00 00 
    p->totalPagesInSwap = 0;
80103add:	c7 83 58 04 00 00 00 	movl   $0x0,0x458(%ebx)
80103ae4:	00 00 00 
80103ae7:	89 f6                	mov    %esi,%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;
80103af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103af6:	83 c0 04             	add    $0x4,%eax
    p->pagesinSwap = 0;
    p->protectedPages = 0;
    p->pageFaults = 0;
    p->totalPagesInSwap = 0;
    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103af9:	39 d0                	cmp    %edx,%eax
80103afb:	75 f3                	jne    80103af0 <allocproc+0x100>
        p->swapFileEntries[k]=0;

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103afd:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103b03:	90                   	nop
80103b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
        pg->offset = 0;
80103b08:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        pg->pageid = 0;
80103b0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103b16:	83 c0 1c             	add    $0x1c,%eax
    {
        pg->offset = 0;
        pg->pageid = 0;
        pg->present = 0;
80103b19:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
        pg->sequel = 0;
80103b20:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
        pg->physAdress = 0;
80103b27:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        pg->virtAdress = 0;
80103b2e:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103b35:	39 c8                	cmp    %ecx,%eax
80103b37:	72 cf                	jb     80103b08 <allocproc+0x118>
80103b39:	89 d8                	mov    %ebx,%eax
        pg->virtAdress = 0;
    }
#endif

    return p;
}
80103b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b3e:	c9                   	leave  
80103b3f:	c3                   	ret    

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED)
            goto found;

    release(&ptable.lock);
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	68 40 4d 11 80       	push   $0x80114d40
80103b48:	e8 e3 10 00 00       	call   80104c30 <release>
    return 0;
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	31 c0                	xor    %eax,%eax
        pg->virtAdress = 0;
    }
#endif

    return p;
}
80103b52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b55:	c9                   	leave  
80103b56:	c3                   	ret    

    release(&ptable.lock);

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
        p->state = UNUSED;
80103b57:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103b5e:	eb db                	jmp    80103b3b <allocproc+0x14b>

80103b60 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103b66:	68 40 4d 11 80       	push   $0x80114d40
80103b6b:	e8 c0 10 00 00       	call   80104c30 <release>

    if (first) {
80103b70:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b75:	83 c4 10             	add    $0x10,%esp
80103b78:	85 c0                	test   %eax,%eax
80103b7a:	75 04                	jne    80103b80 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103b7c:	c9                   	leave  
80103b7d:	c3                   	ret    
80103b7e:	66 90                	xchg   %ax,%ax
    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
80103b80:	83 ec 0c             	sub    $0xc,%esp

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
80103b83:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b8a:	00 00 00 
        iinit(ROOTDEV);
80103b8d:	6a 01                	push   $0x1
80103b8f:	e8 0c d9 ff ff       	call   801014a0 <iinit>
        initlog(ROOTDEV);
80103b94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b9b:	e8 50 f3 ff ff       	call   80102ef0 <initlog>
80103ba0:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103ba3:	c9                   	leave  
80103ba4:	c3                   	ret    
80103ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bb0 <notShell>:
extern void trapret(void);

static void wakeup1(void *chan);

int notShell(void) {
    return nextpid > 2;
80103bb0:	31 c0                	xor    %eax,%eax
80103bb2:	83 3d 04 b0 10 80 02 	cmpl   $0x2,0x8010b004

extern void trapret(void);

static void wakeup1(void *chan);

int notShell(void) {
80103bb9:	55                   	push   %ebp
80103bba:	89 e5                	mov    %esp,%ebp
    return nextpid > 2;
}
80103bbc:	5d                   	pop    %ebp
extern void trapret(void);

static void wakeup1(void *chan);

int notShell(void) {
    return nextpid > 2;
80103bbd:	0f 9f c0             	setg   %al
}
80103bc0:	c3                   	ret    
80103bc1:	eb 0d                	jmp    80103bd0 <pinit>
80103bc3:	90                   	nop
80103bc4:	90                   	nop
80103bc5:	90                   	nop
80103bc6:	90                   	nop
80103bc7:	90                   	nop
80103bc8:	90                   	nop
80103bc9:	90                   	nop
80103bca:	90                   	nop
80103bcb:	90                   	nop
80103bcc:	90                   	nop
80103bcd:	90                   	nop
80103bce:	90                   	nop
80103bcf:	90                   	nop

80103bd0 <pinit>:

void
pinit(void) {
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103bd6:	68 d5 82 10 80       	push   $0x801082d5
80103bdb:	68 40 4d 11 80       	push   $0x80114d40
80103be0:	e8 2b 0e 00 00       	call   80104a10 <initlock>
}
80103be5:	83 c4 10             	add    $0x10,%esp
80103be8:	c9                   	leave  
80103be9:	c3                   	ret    
80103bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bf0 <mycpu>:
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void) {
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	56                   	push   %esi
80103bf4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bf5:	9c                   	pushf  
80103bf6:	58                   	pop    %eax
    int apicid, i;

    if (readeflags() & FL_IF)
80103bf7:	f6 c4 02             	test   $0x2,%ah
80103bfa:	75 5b                	jne    80103c57 <mycpu+0x67>
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
80103bfc:	e8 2f ef ff ff       	call   80102b30 <lapicid>
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103c01:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
80103c07:	85 f6                	test   %esi,%esi
80103c09:	7e 3f                	jle    80103c4a <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
80103c0b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103c12:	39 d0                	cmp    %edx,%eax
80103c14:	74 30                	je     80103c46 <mycpu+0x56>
80103c16:	b9 50 38 11 80       	mov    $0x80113850,%ecx
80103c1b:	31 d2                	xor    %edx,%edx
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103c20:	83 c2 01             	add    $0x1,%edx
80103c23:	39 f2                	cmp    %esi,%edx
80103c25:	74 23                	je     80103c4a <mycpu+0x5a>
        if (cpus[i].apicid == apicid)
80103c27:	0f b6 19             	movzbl (%ecx),%ebx
80103c2a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103c30:	39 d8                	cmp    %ebx,%eax
80103c32:	75 ec                	jne    80103c20 <mycpu+0x30>
            return &cpus[i];
80103c34:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
    }
    panic("unknown apicid\n");
}
80103c3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c3d:	5b                   	pop    %ebx
    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
            return &cpus[i];
80103c3e:	05 a0 37 11 80       	add    $0x801137a0,%eax
    }
    panic("unknown apicid\n");
}
80103c43:	5e                   	pop    %esi
80103c44:	5d                   	pop    %ebp
80103c45:	c3                   	ret    
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
80103c46:	31 d2                	xor    %edx,%edx
80103c48:	eb ea                	jmp    80103c34 <mycpu+0x44>
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
80103c4a:	83 ec 0c             	sub    $0xc,%esp
80103c4d:	68 dc 82 10 80       	push   $0x801082dc
80103c52:	e8 19 c7 ff ff       	call   80100370 <panic>
struct cpu *
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
        panic("mycpu called with interrupts enabled\n");
80103c57:	83 ec 0c             	sub    $0xc,%esp
80103c5a:	68 c8 83 10 80       	push   $0x801083c8
80103c5f:	e8 0c c7 ff ff       	call   80100370 <panic>
80103c64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c70 <cpuid>:
    initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103c76:	e8 75 ff ff ff       	call   80103bf0 <mycpu>
80103c7b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103c80:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
    return mycpu() - cpus;
80103c81:	c1 f8 04             	sar    $0x4,%eax
80103c84:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c8a:	c3                   	ret    
80103c8b:	90                   	nop
80103c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c90 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void) {
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	53                   	push   %ebx
80103c94:	83 ec 04             	sub    $0x4,%esp
    struct cpu *c;
    struct proc *p;
    pushcli();
80103c97:	e8 34 0e 00 00       	call   80104ad0 <pushcli>
    c = mycpu();
80103c9c:	e8 4f ff ff ff       	call   80103bf0 <mycpu>
    p = c->proc;
80103ca1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ca7:	e8 14 0f 00 00       	call   80104bc0 <popcli>
    return p;
}
80103cac:	83 c4 04             	add    $0x4,%esp
80103caf:	89 d8                	mov    %ebx,%eax
80103cb1:	5b                   	pop    %ebx
80103cb2:	5d                   	pop    %ebp
80103cb3:	c3                   	ret    
80103cb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103cc0 <userinit>:
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	53                   	push   %ebx
80103cc4:	83 ec 04             	sub    $0x4,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    // before first alloc, check total space for ^P
    totalAvailablePages = kallocCount();
80103cc7:	e8 e4 e9 ff ff       	call   801026b0 <kallocCount>
80103ccc:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8

    p = allocproc();
80103cd1:	e8 1a fd ff ff       	call   801039f0 <allocproc>
80103cd6:	89 c3                	mov    %eax,%ebx

    initproc = p;
80103cd8:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
    if ((p->pgdir = setupkvm()) == 0)
80103cdd:	e8 be 3d 00 00       	call   80107aa0 <setupkvm>
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	89 43 04             	mov    %eax,0x4(%ebx)
80103ce7:	0f 84 bd 00 00 00    	je     80103daa <userinit+0xea>
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103ced:	83 ec 04             	sub    $0x4,%esp
80103cf0:	68 2c 00 00 00       	push   $0x2c
80103cf5:	68 60 b4 10 80       	push   $0x8010b460
80103cfa:	50                   	push   %eax
80103cfb:	e8 60 36 00 00       	call   80107360 <inituvm>
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
80103d00:	83 c4 0c             	add    $0xc,%esp

    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
80103d03:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103d09:	6a 4c                	push   $0x4c
80103d0b:	6a 00                	push   $0x0
80103d0d:	ff 73 18             	pushl  0x18(%ebx)
80103d10:	e8 6b 0f 00 00       	call   80104c80 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d15:	8b 43 18             	mov    0x18(%ebx),%eax
80103d18:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d1d:	b9 23 00 00 00       	mov    $0x23,%ecx
    p->tf->ss = p->tf->ds;
    p->tf->eflags = FL_IF;
    p->tf->esp = PGSIZE;
    p->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
80103d22:	83 c4 0c             	add    $0xc,%esp
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d25:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d29:	8b 43 18             	mov    0x18(%ebx),%eax
80103d2c:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103d30:	8b 43 18             	mov    0x18(%ebx),%eax
80103d33:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d37:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103d3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103d3e:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d42:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103d46:	8b 43 18             	mov    0x18(%ebx),%eax
80103d49:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103d50:	8b 43 18             	mov    0x18(%ebx),%eax
80103d53:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103d5a:	8b 43 18             	mov    0x18(%ebx),%eax
80103d5d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    safestrcpy(p->name, "initcode", sizeof(p->name));
80103d64:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d67:	6a 10                	push   $0x10
80103d69:	68 05 83 10 80       	push   $0x80108305
80103d6e:	50                   	push   %eax
80103d6f:	e8 0c 11 00 00       	call   80104e80 <safestrcpy>
    p->cwd = namei("/");
80103d74:	c7 04 24 0e 83 10 80 	movl   $0x8010830e,(%esp)
80103d7b:	e8 70 e1 ff ff       	call   80101ef0 <namei>
80103d80:	89 43 68             	mov    %eax,0x68(%ebx)

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
80103d83:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103d8a:	e8 81 0d 00 00       	call   80104b10 <acquire>

    p->state = RUNNABLE;
80103d8f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

    release(&ptable.lock);
80103d96:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103d9d:	e8 8e 0e 00 00       	call   80104c30 <release>
}
80103da2:	83 c4 10             	add    $0x10,%esp
80103da5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103da8:	c9                   	leave  
80103da9:	c3                   	ret    

    p = allocproc();

    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 ec 82 10 80       	push   $0x801082ec
80103db2:	e8 b9 c5 ff ff       	call   80100370 <panic>
80103db7:	89 f6                	mov    %esi,%esi
80103db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dc0 <growproc>:
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	56                   	push   %esi
80103dc4:	53                   	push   %ebx
80103dc5:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103dc8:	e8 03 0d 00 00       	call   80104ad0 <pushcli>
    c = mycpu();
80103dcd:	e8 1e fe ff ff       	call   80103bf0 <mycpu>
    p = c->proc;
80103dd2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103dd8:	e8 e3 0d 00 00       	call   80104bc0 <popcli>
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();

    sz = curproc->sz;
    if (n > 0) {
80103ddd:	83 fe 00             	cmp    $0x0,%esi
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();

    sz = curproc->sz;
80103de0:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103de2:	7e 34                	jle    80103e18 <growproc+0x58>
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103de4:	83 ec 04             	sub    $0x4,%esp
80103de7:	01 c6                	add    %eax,%esi
80103de9:	56                   	push   %esi
80103dea:	50                   	push   %eax
80103deb:	ff 73 04             	pushl  0x4(%ebx)
80103dee:	e8 0d 3a 00 00       	call   80107800 <allocuvm>
80103df3:	83 c4 10             	add    $0x10,%esp
80103df6:	85 c0                	test   %eax,%eax
80103df8:	74 46                	je     80103e40 <growproc+0x80>
        curproc->pagesCounter += (PGROUNDUP(n) / PGSIZE);
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
            return -1;
    }
    curproc->sz = sz;
    switchuvm(curproc);
80103dfa:	83 ec 0c             	sub    $0xc,%esp
    } else if (n < 0) {
        curproc->pagesCounter += (PGROUNDUP(n) / PGSIZE);
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
            return -1;
    }
    curproc->sz = sz;
80103dfd:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103dff:	53                   	push   %ebx
80103e00:	e8 4b 34 00 00       	call   80107250 <switchuvm>
    return 0;
80103e05:	83 c4 10             	add    $0x10,%esp
80103e08:	31 c0                	xor    %eax,%eax
}
80103e0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e0d:	5b                   	pop    %ebx
80103e0e:	5e                   	pop    %esi
80103e0f:	5d                   	pop    %ebp
80103e10:	c3                   	ret    
80103e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
80103e18:	74 e0                	je     80103dfa <growproc+0x3a>
        curproc->pagesCounter += (PGROUNDUP(n) / PGSIZE);
80103e1a:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
80103e20:	01 c6                	add    %eax,%esi
    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
        curproc->pagesCounter += (PGROUNDUP(n) / PGSIZE);
80103e22:	c1 fa 0c             	sar    $0xc,%edx
80103e25:	01 93 44 04 00 00    	add    %edx,0x444(%ebx)
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
80103e2b:	6a 01                	push   $0x1
80103e2d:	56                   	push   %esi
80103e2e:	50                   	push   %eax
80103e2f:	ff 73 04             	pushl  0x4(%ebx)
80103e32:	e8 09 38 00 00       	call   80107640 <deallocuvm>
80103e37:	83 c4 10             	add    $0x10,%esp
80103e3a:	85 c0                	test   %eax,%eax
80103e3c:	75 bc                	jne    80103dfa <growproc+0x3a>
80103e3e:	66 90                	xchg   %ax,%ax
    struct proc *curproc = myproc();

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
80103e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e45:	eb c3                	jmp    80103e0a <growproc+0x4a>
80103e47:	89 f6                	mov    %esi,%esi
80103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e50 <fork>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80103e59:	e8 72 0c 00 00       	call   80104ad0 <pushcli>
    c = mycpu();
80103e5e:	e8 8d fd ff ff       	call   80103bf0 <mycpu>
    p = c->proc;
80103e63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103e69:	e8 52 0d 00 00       	call   80104bc0 <popcli>
    struct proc *curproc = myproc();
#if(defined(LIFO) || defined(SCFIFO))
    struct page *pg , *cg;
#endif
    // Allocate process.
    if ((np = allocproc()) == 0) {
80103e6e:	e8 7d fb ff ff       	call   801039f0 <allocproc>
80103e73:	85 c0                	test   %eax,%eax
80103e75:	0f 84 a4 02 00 00    	je     8010411f <fork+0x2cf>
        return -1;
    }

#if(defined(LIFO) || defined(SCFIFO))

    if (firstRun) {
80103e7b:	8b 35 08 b0 10 80    	mov    0x8010b008,%esi
80103e81:	89 c2                	mov    %eax,%edx
80103e83:	85 f6                	test   %esi,%esi
80103e85:	0f 85 75 02 00 00    	jne    80104100 <fork+0x2b0>
        createSwapFile(curproc);
    }


    createSwapFile(np);
80103e8b:	83 ec 0c             	sub    $0xc,%esp
80103e8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103e91:	52                   	push   %edx
80103e92:	e8 39 e3 ff ff       	call   801021d0 <createSwapFile>
#endif

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103e97:	5a                   	pop    %edx
80103e98:	59                   	pop    %ecx
80103e99:	ff 33                	pushl  (%ebx)
80103e9b:	ff 73 04             	pushl  0x4(%ebx)
80103e9e:	e8 cd 3c 00 00       	call   80107b70 <copyuvm>
80103ea3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ea6:	83 c4 10             	add    $0x10,%esp
80103ea9:	85 c0                	test   %eax,%eax
80103eab:	89 42 04             	mov    %eax,0x4(%edx)
80103eae:	0f 84 75 02 00 00    	je     80104129 <fork+0x2d9>
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103eb4:	8b 03                	mov    (%ebx),%eax
    np->parent = curproc;
    *np->tf = *curproc->tf;
80103eb6:	b9 13 00 00 00       	mov    $0x13,%ecx
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
    np->parent = curproc;
80103ebb:	89 5a 14             	mov    %ebx,0x14(%edx)
    *np->tf = *curproc->tf;
80103ebe:	8b 7a 18             	mov    0x18(%edx),%edi
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
80103ec1:	89 02                	mov    %eax,(%edx)
    np->parent = curproc;
    *np->tf = *curproc->tf;
80103ec3:	8b 73 18             	mov    0x18(%ebx),%esi
80103ec6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    if (notShell()) {
80103ec8:	83 3d 04 b0 10 80 02 	cmpl   $0x2,0x8010b004
80103ecf:	0f 8f a3 00 00 00    	jg     80103f78 <fork+0x128>
            }
        }
#endif
    }
    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80103ed5:	8b 42 18             	mov    0x18(%edx),%eax

    for (i = 0; i < NOFILE; i++)
80103ed8:	31 f6                	xor    %esi,%esi
            }
        }
#endif
    }
    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80103eda:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
80103ee8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103eec:	85 c0                	test   %eax,%eax
80103eee:	74 16                	je     80103f06 <fork+0xb6>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103ef0:	83 ec 0c             	sub    $0xc,%esp
80103ef3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103ef6:	50                   	push   %eax
80103ef7:	e8 14 cf ff ff       	call   80100e10 <filedup>
80103efc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103eff:	83 c4 10             	add    $0x10,%esp
80103f02:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
#endif
    }
    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
80103f06:	83 c6 01             	add    $0x1,%esi
80103f09:	83 fe 10             	cmp    $0x10,%esi
80103f0c:	75 da                	jne    80103ee8 <fork+0x98>
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103f0e:	83 ec 0c             	sub    $0xc,%esp
80103f11:	ff 73 68             	pushl  0x68(%ebx)
80103f14:	89 55 e4             	mov    %edx,-0x1c(%ebp)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f17:	83 c3 6c             	add    $0x6c,%ebx
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103f1a:	e8 51 d7 ff ff       	call   80101670 <idup>
80103f1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f22:	83 c4 0c             	add    $0xc,%esp
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);
80103f25:	89 42 68             	mov    %eax,0x68(%edx)

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f28:	8d 42 6c             	lea    0x6c(%edx),%eax
80103f2b:	6a 10                	push   $0x10
80103f2d:	53                   	push   %ebx
80103f2e:	50                   	push   %eax
80103f2f:	e8 4c 0f 00 00       	call   80104e80 <safestrcpy>

    pid = np->pid;
80103f34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f37:	8b 72 10             	mov    0x10(%edx),%esi

    acquire(&ptable.lock);
80103f3a:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103f41:	e8 ca 0b 00 00       	call   80104b10 <acquire>

    np->state = RUNNABLE;
80103f46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f49:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)

    release(&ptable.lock);
80103f50:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103f57:	e8 d4 0c 00 00       	call   80104c30 <release>

    firstRun = 0;
80103f5c:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80103f63:	00 00 00 
    return pid;
80103f66:	83 c4 10             	add    $0x10,%esp
}
80103f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f6c:	89 f0                	mov    %esi,%eax
80103f6e:	5b                   	pop    %ebx
80103f6f:	5e                   	pop    %esi
80103f70:	5f                   	pop    %edi
80103f71:	5d                   	pop    %ebp
80103f72:	c3                   	ret    
80103f73:	90                   	nop
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->parent = curproc;
    *np->tf = *curproc->tf;
    if (notShell()) {
#if(defined(LIFO) || defined(SCFIFO))
        //copy pagging
        np->nextpageid = curproc->nextpageid;
80103f78:	8b 83 40 04 00 00    	mov    0x440(%ebx),%eax
80103f7e:	89 82 40 04 00 00    	mov    %eax,0x440(%edx)
        np->pagesCounter = curproc->pagesCounter;
80103f84:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
80103f8a:	89 82 44 04 00 00    	mov    %eax,0x444(%edx)
    //    np->swapOffset = curproc->swapOffset;
        np->pagesequel = curproc->pagesequel;
80103f90:	8b 83 4c 04 00 00    	mov    0x44c(%ebx),%eax
80103f96:	89 82 4c 04 00 00    	mov    %eax,0x44c(%edx)
        np->pagesinSwap = curproc->pagesinSwap;
80103f9c:	8b 83 48 04 00 00    	mov    0x448(%ebx),%eax
80103fa2:	89 82 48 04 00 00    	mov    %eax,0x448(%edx)
        np->protectedPages = curproc->protectedPages;
80103fa8:	8b 83 50 04 00 00    	mov    0x450(%ebx),%eax
        np->pageFaults = 0;
80103fae:	c7 82 54 04 00 00 00 	movl   $0x0,0x454(%edx)
80103fb5:	00 00 00 
        np->totalPagesInSwap = 0;
80103fb8:	c7 82 58 04 00 00 00 	movl   $0x0,0x458(%edx)
80103fbf:	00 00 00 
        np->nextpageid = curproc->nextpageid;
        np->pagesCounter = curproc->pagesCounter;
    //    np->swapOffset = curproc->swapOffset;
        np->pagesequel = curproc->pagesequel;
        np->pagesinSwap = curproc->pagesinSwap;
        np->protectedPages = curproc->protectedPages;
80103fc2:	89 82 50 04 00 00    	mov    %eax,0x450(%edx)
        np->pageFaults = 0;
        np->totalPagesInSwap = 0;
        //copy swap table
        for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103fc8:	31 c0                	xor    %eax,%eax
80103fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            np->swapFileEntries[k]=curproc->swapFileEntries[k];
80103fd0:	8b 8c 83 00 04 00 00 	mov    0x400(%ebx,%eax,4),%ecx
80103fd7:	89 8c 82 00 04 00 00 	mov    %ecx,0x400(%edx,%eax,4)
        np->pagesinSwap = curproc->pagesinSwap;
        np->protectedPages = curproc->protectedPages;
        np->pageFaults = 0;
        np->totalPagesInSwap = 0;
        //copy swap table
        for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103fde:	83 c0 01             	add    $0x1,%eax
80103fe1:	83 f8 10             	cmp    $0x10,%eax
80103fe4:	75 ea                	jne    80103fd0 <fork+0x180>
            np->swapFileEntries[k]=curproc->swapFileEntries[k];

        //copy pages
        for( pg = np->pages , cg = curproc->pages;
80103fe6:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
80103fec:	8d 8b 80 00 00 00    	lea    0x80(%ebx),%ecx
                pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103ff2:	8d ba 00 04 00 00    	lea    0x400(%edx),%edi
80103ff8:	90                   	nop
80103ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        {
            pg->offset = cg->offset;
80104000:	8b 71 10             	mov    0x10(%ecx),%esi
        for(int k=0; k<MAX_PSYC_PAGES ; k++)
            np->swapFileEntries[k]=curproc->swapFileEntries[k];

        //copy pages
        for( pg = np->pages , cg = curproc->pages;
                pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80104003:	83 c0 1c             	add    $0x1c,%eax
80104006:	83 c1 1c             	add    $0x1c,%ecx
        {
            pg->offset = cg->offset;
80104009:	89 70 f4             	mov    %esi,-0xc(%eax)
            pg->pageid = cg->pageid;
8010400c:	8b 71 e8             	mov    -0x18(%ecx),%esi
8010400f:	89 70 e8             	mov    %esi,-0x18(%eax)
            pg->present = cg->present;
80104012:	8b 71 f0             	mov    -0x10(%ecx),%esi
80104015:	89 70 f0             	mov    %esi,-0x10(%eax)
            pg->sequel = cg->sequel;
80104018:	8b 71 ec             	mov    -0x14(%ecx),%esi
8010401b:	89 70 ec             	mov    %esi,-0x14(%eax)
            pg->physAdress = cg->physAdress;
8010401e:	8b 71 f8             	mov    -0x8(%ecx),%esi
80104021:	89 70 f8             	mov    %esi,-0x8(%eax)
            pg->virtAdress = cg->virtAdress;
80104024:	8b 71 fc             	mov    -0x4(%ecx),%esi
80104027:	89 70 fc             	mov    %esi,-0x4(%eax)
        //copy swap table
        for(int k=0; k<MAX_PSYC_PAGES ; k++)
            np->swapFileEntries[k]=curproc->swapFileEntries[k];

        //copy pages
        for( pg = np->pages , cg = curproc->pages;
8010402a:	39 f8                	cmp    %edi,%eax
8010402c:	72 d2                	jb     80104000 <fork+0x1b0>
            pg->physAdress = cg->physAdress;
            pg->virtAdress = cg->virtAdress;
        }

        //TODO FIRST RUN IN BEFORE SHEL LOADED
        if (!firstRun) {
8010402e:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104033:	85 c0                	test   %eax,%eax
80104035:	0f 85 9a fe ff ff    	jne    80103ed5 <fork+0x85>
            //PAGECOUNTER-16= PAGES IN SWAP FILE
            for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
8010403b:	83 bb 44 04 00 00 10 	cmpl   $0x10,0x444(%ebx)
80104042:	0f 8e 8d fe ff ff    	jle    80103ed5 <fork+0x85>
80104048:	31 ff                	xor    %edi,%edi
8010404a:	eb 3d                	jmp    80104089 <fork+0x239>
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    np->state = UNUSED;
                    removeSwapFile(np); //clear swapFile
                    return -1;
                }

                if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
80104050:	68 00 10 00 00       	push   $0x1000
80104055:	51                   	push   %ecx
80104056:	68 40 3d 11 80       	push   $0x80113d40
8010405b:	52                   	push   %edx
8010405c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010405f:	e8 0c e2 ff ff       	call   80102270 <writeToSwapFile>
80104064:	83 c4 10             	add    $0x10,%esp
80104067:	83 f8 ff             	cmp    $0xffffffff,%eax
8010406a:	89 c6                	mov    %eax,%esi
8010406c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010406f:	0f 84 a2 00 00 00    	je     80104117 <fork+0x2c7>
        }

        //TODO FIRST RUN IN BEFORE SHEL LOADED
        if (!firstRun) {
            //PAGECOUNTER-16= PAGES IN SWAP FILE
            for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80104075:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
8010407b:	83 c7 01             	add    $0x1,%edi
8010407e:	83 e8 10             	sub    $0x10,%eax
80104081:	39 f8                	cmp    %edi,%eax
80104083:	0f 8e 4c fe ff ff    	jle    80103ed5 <fork+0x85>
                memset(buffer, 0, PGSIZE);
80104089:	83 ec 04             	sub    $0x4,%esp
8010408c:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010408f:	68 00 10 00 00       	push   $0x1000
80104094:	6a 00                	push   $0x0
80104096:	68 40 3d 11 80       	push   $0x80113d40
8010409b:	e8 e0 0b 00 00       	call   80104c80 <memset>
801040a0:	89 f9                	mov    %edi,%ecx

                if (readFromSwapFile(curproc, buffer, k * PGSIZE, PGSIZE) == -1) {
801040a2:	68 00 10 00 00       	push   $0x1000
801040a7:	c1 e1 0c             	shl    $0xc,%ecx
801040aa:	51                   	push   %ecx
801040ab:	68 40 3d 11 80       	push   $0x80113d40
801040b0:	53                   	push   %ebx
801040b1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801040b4:	e8 e7 e1 ff ff       	call   801022a0 <readFromSwapFile>
801040b9:	83 c4 20             	add    $0x20,%esp
801040bc:	83 f8 ff             	cmp    $0xffffffff,%eax
801040bf:	89 c6                	mov    %eax,%esi
801040c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801040c7:	75 87                	jne    80104050 <fork+0x200>
                    kfree(np->kstack);
801040c9:	83 ec 0c             	sub    $0xc,%esp
801040cc:	ff 72 08             	pushl  0x8(%edx)
801040cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
                    removeSwapFile(np); //clear swapFile
                    return -1;
                }

                if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
                    kfree(np->kstack);
801040d2:	e8 49 e6 ff ff       	call   80102720 <kfree>
                    np->kstack = 0;
801040d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040da:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
                    np->state = UNUSED;
801040e1:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
                    removeSwapFile(np); //clear swapFile
801040e8:	89 14 24             	mov    %edx,(%esp)
801040eb:	e8 e0 de ff ff       	call   80101fd0 <removeSwapFile>
                    return -1;
801040f0:	83 c4 10             	add    $0x10,%esp

    release(&ptable.lock);

    firstRun = 0;
    return pid;
}
801040f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040f6:	89 f0                	mov    %esi,%eax
801040f8:	5b                   	pop    %ebx
801040f9:	5e                   	pop    %esi
801040fa:	5f                   	pop    %edi
801040fb:	5d                   	pop    %ebp
801040fc:	c3                   	ret    
801040fd:	8d 76 00             	lea    0x0(%esi),%esi
    }

#if(defined(LIFO) || defined(SCFIFO))

    if (firstRun) {
        createSwapFile(curproc);
80104100:	83 ec 0c             	sub    $0xc,%esp
80104103:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104106:	53                   	push   %ebx
80104107:	e8 c4 e0 ff ff       	call   801021d0 <createSwapFile>
8010410c:	83 c4 10             	add    $0x10,%esp
8010410f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104112:	e9 74 fd ff ff       	jmp    80103e8b <fork+0x3b>
                    removeSwapFile(np); //clear swapFile
                    return -1;
                }

                if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
                    kfree(np->kstack);
80104117:	83 ec 0c             	sub    $0xc,%esp
8010411a:	ff 72 08             	pushl  0x8(%edx)
8010411d:	eb b3                	jmp    801040d2 <fork+0x282>
#if(defined(LIFO) || defined(SCFIFO))
    struct page *pg , *cg;
#endif
    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
8010411f:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104124:	e9 40 fe ff ff       	jmp    80103f69 <fork+0x119>
    createSwapFile(np);
#endif

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
80104129:	83 ec 0c             	sub    $0xc,%esp
8010412c:	ff 72 08             	pushl  0x8(%edx)
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
8010412f:	be ff ff ff ff       	mov    $0xffffffff,%esi
    createSwapFile(np);
#endif

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
80104134:	e8 e7 e5 ff ff       	call   80102720 <kfree>
        np->kstack = 0;
80104139:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        np->state = UNUSED;
        return -1;
8010413c:	83 c4 10             	add    $0x10,%esp
#endif

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
        np->kstack = 0;
8010413f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
        np->state = UNUSED;
80104146:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
        return -1;
8010414d:	e9 17 fe ff ff       	jmp    80103f69 <fork+0x119>
80104152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104160 <scheduler>:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	57                   	push   %edi
80104164:	56                   	push   %esi
80104165:	53                   	push   %ebx
80104166:	83 ec 0c             	sub    $0xc,%esp
    struct proc *p;
    struct cpu *c = mycpu();
80104169:	e8 82 fa ff ff       	call   80103bf0 <mycpu>
8010416e:	8d 78 04             	lea    0x4(%eax),%edi
80104171:	89 c6                	mov    %eax,%esi
    c->proc = 0;
80104173:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010417a:	00 00 00 
8010417d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80104180:	fb                   	sti    
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80104181:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104184:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80104189:	68 40 4d 11 80       	push   $0x80114d40
8010418e:	e8 7d 09 00 00       	call   80104b10 <acquire>
80104193:	83 c4 10             	add    $0x10,%esp
80104196:	eb 16                	jmp    801041ae <scheduler+0x4e>
80104198:	90                   	nop
80104199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041a0:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
801041a6:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
801041ac:	74 52                	je     80104200 <scheduler+0xa0>
            if (p->state != RUNNABLE)
801041ae:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041b2:	75 ec                	jne    801041a0 <scheduler+0x40>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
801041b4:	83 ec 0c             	sub    $0xc,%esp
                continue;

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
801041b7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
801041bd:	53                   	push   %ebx
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041be:	81 c3 5c 04 00 00    	add    $0x45c,%ebx

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
801041c4:	e8 87 30 00 00       	call   80107250 <switchuvm>
            p->state = RUNNING;

            swtch(&(c->scheduler), p->context);
801041c9:	58                   	pop    %eax
801041ca:	5a                   	pop    %edx
801041cb:	ff b3 c0 fb ff ff    	pushl  -0x440(%ebx)
801041d1:	57                   	push   %edi
            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
            p->state = RUNNING;
801041d2:	c7 83 b0 fb ff ff 04 	movl   $0x4,-0x450(%ebx)
801041d9:	00 00 00 

            swtch(&(c->scheduler), p->context);
801041dc:	e8 fa 0c 00 00       	call   80104edb <swtch>
            switchkvm();
801041e1:	e8 4a 30 00 00       	call   80107230 <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
801041e6:	83 c4 10             	add    $0x10,%esp
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041e9:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
            swtch(&(c->scheduler), p->context);
            switchkvm();

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
801041ef:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801041f6:	00 00 00 
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041f9:	75 b3                	jne    801041ae <scheduler+0x4e>
801041fb:	90                   	nop
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&ptable.lock);
80104200:	83 ec 0c             	sub    $0xc,%esp
80104203:	68 40 4d 11 80       	push   $0x80114d40
80104208:	e8 23 0a 00 00       	call   80104c30 <release>

    }
8010420d:	83 c4 10             	add    $0x10,%esp
80104210:	e9 6b ff ff ff       	jmp    80104180 <scheduler+0x20>
80104215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104225:	e8 a6 08 00 00       	call   80104ad0 <pushcli>
    c = mycpu();
8010422a:	e8 c1 f9 ff ff       	call   80103bf0 <mycpu>
    p = c->proc;
8010422f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104235:	e8 86 09 00 00       	call   80104bc0 <popcli>
void
sched(void) {
    int intena;
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
8010423a:	83 ec 0c             	sub    $0xc,%esp
8010423d:	68 40 4d 11 80       	push   $0x80114d40
80104242:	e8 49 08 00 00       	call   80104a90 <holding>
80104247:	83 c4 10             	add    $0x10,%esp
8010424a:	85 c0                	test   %eax,%eax
8010424c:	74 4f                	je     8010429d <sched+0x7d>
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
8010424e:	e8 9d f9 ff ff       	call   80103bf0 <mycpu>
80104253:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010425a:	75 68                	jne    801042c4 <sched+0xa4>
        panic("sched locks");
    if (p->state == RUNNING)
8010425c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104260:	74 55                	je     801042b7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104262:	9c                   	pushf  
80104263:	58                   	pop    %eax
        panic("sched running");
    if (readeflags() & FL_IF)
80104264:	f6 c4 02             	test   $0x2,%ah
80104267:	75 41                	jne    801042aa <sched+0x8a>
        panic("sched interruptible");
    intena = mycpu()->intena;
80104269:	e8 82 f9 ff ff       	call   80103bf0 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
8010426e:	83 c3 1c             	add    $0x1c,%ebx
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
80104271:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
80104277:	e8 74 f9 ff ff       	call   80103bf0 <mycpu>
8010427c:	83 ec 08             	sub    $0x8,%esp
8010427f:	ff 70 04             	pushl  0x4(%eax)
80104282:	53                   	push   %ebx
80104283:	e8 53 0c 00 00       	call   80104edb <swtch>
    mycpu()->intena = intena;
80104288:	e8 63 f9 ff ff       	call   80103bf0 <mycpu>
}
8010428d:	83 c4 10             	add    $0x10,%esp
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
    swtch(&p->context, mycpu()->scheduler);
    mycpu()->intena = intena;
80104290:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104296:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104299:	5b                   	pop    %ebx
8010429a:	5e                   	pop    %esi
8010429b:	5d                   	pop    %ebp
8010429c:	c3                   	ret    
sched(void) {
    int intena;
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	68 10 83 10 80       	push   $0x80108310
801042a5:	e8 c6 c0 ff ff       	call   80100370 <panic>
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
801042aa:	83 ec 0c             	sub    $0xc,%esp
801042ad:	68 3c 83 10 80       	push   $0x8010833c
801042b2:	e8 b9 c0 ff ff       	call   80100370 <panic>
    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
801042b7:	83 ec 0c             	sub    $0xc,%esp
801042ba:	68 2e 83 10 80       	push   $0x8010832e
801042bf:	e8 ac c0 ff ff       	call   80100370 <panic>
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
801042c4:	83 ec 0c             	sub    $0xc,%esp
801042c7:	68 22 83 10 80       	push   $0x80108322
801042cc:	e8 9f c0 ff ff       	call   80100370 <panic>
801042d1:	eb 0d                	jmp    801042e0 <exit>
801042d3:	90                   	nop
801042d4:	90                   	nop
801042d5:	90                   	nop
801042d6:	90                   	nop
801042d7:	90                   	nop
801042d8:	90                   	nop
801042d9:	90                   	nop
801042da:	90                   	nop
801042db:	90                   	nop
801042dc:	90                   	nop
801042dd:	90                   	nop
801042de:	90                   	nop
801042df:	90                   	nop

801042e0 <exit>:

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	57                   	push   %edi
801042e4:	56                   	push   %esi
801042e5:	53                   	push   %ebx
801042e6:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
801042e9:	e8 e2 07 00 00       	call   80104ad0 <pushcli>
    c = mycpu();
801042ee:	e8 fd f8 ff ff       	call   80103bf0 <mycpu>
    p = c->proc;
801042f3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801042f9:	e8 c2 08 00 00       	call   80104bc0 <popcli>
exit(void) {
    struct proc *curproc = myproc();
    struct proc *p;
    int fd;

    if (curproc == initproc)
801042fe:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
80104304:	8d 5e 28             	lea    0x28(%esi),%ebx
80104307:	8d 7e 68             	lea    0x68(%esi),%edi
8010430a:	0f 84 12 01 00 00    	je     80104422 <exit+0x142>
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
80104310:	8b 03                	mov    (%ebx),%eax
80104312:	85 c0                	test   %eax,%eax
80104314:	74 12                	je     80104328 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	50                   	push   %eax
8010431a:	e8 41 cb ff ff       	call   80100e60 <fileclose>
            curproc->ofile[fd] = 0;
8010431f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104325:	83 c4 10             	add    $0x10,%esp
80104328:	83 c3 04             	add    $0x4,%ebx

    if (curproc == initproc)
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
8010432b:	39 df                	cmp    %ebx,%edi
8010432d:	75 e1                	jne    80104310 <exit+0x30>
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }

    begin_op();
8010432f:	e8 5c ec ff ff       	call   80102f90 <begin_op>
    iput(curproc->cwd);
80104334:	83 ec 0c             	sub    $0xc,%esp
80104337:	ff 76 68             	pushl  0x68(%esi)
8010433a:	e8 91 d4 ff ff       	call   801017d0 <iput>
    end_op();
8010433f:	e8 bc ec ff ff       	call   80103000 <end_op>
    curproc->cwd = 0;

#if(defined(LIFO) || defined(SCFIFO))
    if (curproc->pid > 2)
80104344:	83 c4 10             	add    $0x10,%esp
80104347:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
    }

    begin_op();
    iput(curproc->cwd);
    end_op();
    curproc->cwd = 0;
8010434b:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

#if(defined(LIFO) || defined(SCFIFO))
    if (curproc->pid > 2)
80104352:	0f 8f b9 00 00 00    	jg     80104411 <exit+0x131>
            removeSwapFile(curproc);
#endif

    acquire(&ptable.lock);
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	68 40 4d 11 80       	push   $0x80114d40
80104360:	e8 ab 07 00 00       	call   80104b10 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);
80104365:	8b 56 14             	mov    0x14(%esi),%edx
80104368:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010436b:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
80104370:	eb 12                	jmp    80104384 <exit+0xa4>
80104372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104378:	05 5c 04 00 00       	add    $0x45c,%eax
8010437d:	3d 74 64 12 80       	cmp    $0x80126474,%eax
80104382:	74 1e                	je     801043a2 <exit+0xc2>
        if (p->state == SLEEPING && p->chan == chan)
80104384:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104388:	75 ee                	jne    80104378 <exit+0x98>
8010438a:	3b 50 20             	cmp    0x20(%eax),%edx
8010438d:	75 e9                	jne    80104378 <exit+0x98>
            p->state = RUNNABLE;
8010438f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104396:	05 5c 04 00 00       	add    $0x45c,%eax
8010439b:	3d 74 64 12 80       	cmp    $0x80126474,%eax
801043a0:	75 e2                	jne    80104384 <exit+0xa4>
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
801043a2:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
801043a8:	ba 74 4d 11 80       	mov    $0x80114d74,%edx
801043ad:	eb 0f                	jmp    801043be <exit+0xde>
801043af:	90                   	nop

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043b0:	81 c2 5c 04 00 00    	add    $0x45c,%edx
801043b6:	81 fa 74 64 12 80    	cmp    $0x80126474,%edx
801043bc:	74 3a                	je     801043f8 <exit+0x118>
        if (p->parent == curproc) {
801043be:	39 72 14             	cmp    %esi,0x14(%edx)
801043c1:	75 ed                	jne    801043b0 <exit+0xd0>
            p->parent = initproc;
            if (p->state == ZOMBIE)
801043c3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
801043c7:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
801043ca:	75 e4                	jne    801043b0 <exit+0xd0>
801043cc:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
801043d1:	eb 11                	jmp    801043e4 <exit+0x104>
801043d3:	90                   	nop
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043d8:	05 5c 04 00 00       	add    $0x45c,%eax
801043dd:	3d 74 64 12 80       	cmp    $0x80126474,%eax
801043e2:	74 cc                	je     801043b0 <exit+0xd0>
        if (p->state == SLEEPING && p->chan == chan)
801043e4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043e8:	75 ee                	jne    801043d8 <exit+0xf8>
801043ea:	3b 48 20             	cmp    0x20(%eax),%ecx
801043ed:	75 e9                	jne    801043d8 <exit+0xf8>
            p->state = RUNNABLE;
801043ef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043f6:	eb e0                	jmp    801043d8 <exit+0xf8>
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;
801043f8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    sched();
801043ff:	e8 1c fe ff ff       	call   80104220 <sched>
    panic("zombie exit");
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	68 5d 83 10 80       	push   $0x8010835d
8010440c:	e8 5f bf ff ff       	call   80100370 <panic>
    end_op();
    curproc->cwd = 0;

#if(defined(LIFO) || defined(SCFIFO))
    if (curproc->pid > 2)
            removeSwapFile(curproc);
80104411:	83 ec 0c             	sub    $0xc,%esp
80104414:	56                   	push   %esi
80104415:	e8 b6 db ff ff       	call   80101fd0 <removeSwapFile>
8010441a:	83 c4 10             	add    $0x10,%esp
8010441d:	e9 36 ff ff ff       	jmp    80104358 <exit+0x78>
    struct proc *curproc = myproc();
    struct proc *p;
    int fd;

    if (curproc == initproc)
        panic("init exiting");
80104422:	83 ec 0c             	sub    $0xc,%esp
80104425:	68 50 83 10 80       	push   $0x80108350
8010442a:	e8 41 bf ff ff       	call   80100370 <panic>
8010442f:	90                   	nop

80104430 <yield>:
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
80104434:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104437:	68 40 4d 11 80       	push   $0x80114d40
8010443c:	e8 cf 06 00 00       	call   80104b10 <acquire>
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104441:	e8 8a 06 00 00       	call   80104ad0 <pushcli>
    c = mycpu();
80104446:	e8 a5 f7 ff ff       	call   80103bf0 <mycpu>
    p = c->proc;
8010444b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104451:	e8 6a 07 00 00       	call   80104bc0 <popcli>

// Give up the CPU for one scheduling round.
void
yield(void) {
    acquire(&ptable.lock);  //DOC: yieldlock
    myproc()->state = RUNNABLE;
80104456:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
8010445d:	e8 be fd ff ff       	call   80104220 <sched>
    release(&ptable.lock);
80104462:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80104469:	e8 c2 07 00 00       	call   80104c30 <release>
}
8010446e:	83 c4 10             	add    $0x10,%esp
80104471:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104474:	c9                   	leave  
80104475:	c3                   	ret    
80104476:	8d 76 00             	lea    0x0(%esi),%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104480 <sleep>:
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	57                   	push   %edi
80104484:	56                   	push   %esi
80104485:	53                   	push   %ebx
80104486:	83 ec 0c             	sub    $0xc,%esp
80104489:	8b 7d 08             	mov    0x8(%ebp),%edi
8010448c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
8010448f:	e8 3c 06 00 00       	call   80104ad0 <pushcli>
    c = mycpu();
80104494:	e8 57 f7 ff ff       	call   80103bf0 <mycpu>
    p = c->proc;
80104499:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010449f:	e8 1c 07 00 00       	call   80104bc0 <popcli>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
    struct proc *p = myproc();

    if (p == 0)
801044a4:	85 db                	test   %ebx,%ebx
801044a6:	0f 84 87 00 00 00    	je     80104533 <sleep+0xb3>
        panic("sleep");

    if (lk == 0)
801044ac:	85 f6                	test   %esi,%esi
801044ae:	74 76                	je     80104526 <sleep+0xa6>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {  //DOC: sleeplock0
801044b0:	81 fe 40 4d 11 80    	cmp    $0x80114d40,%esi
801044b6:	74 50                	je     80104508 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	68 40 4d 11 80       	push   $0x80114d40
801044c0:	e8 4b 06 00 00       	call   80104b10 <acquire>
        release(lk);
801044c5:	89 34 24             	mov    %esi,(%esp)
801044c8:	e8 63 07 00 00       	call   80104c30 <release>
    }
    // Go to sleep.
    p->chan = chan;
801044cd:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
801044d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

    sched();
801044d7:	e8 44 fd ff ff       	call   80104220 <sched>

    // Tidy up.
    p->chan = 0;
801044dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
801044e3:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
801044ea:	e8 41 07 00 00       	call   80104c30 <release>
        acquire(lk);
801044ef:	89 75 08             	mov    %esi,0x8(%ebp)
801044f2:	83 c4 10             	add    $0x10,%esp
    }
}
801044f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044f8:	5b                   	pop    %ebx
801044f9:	5e                   	pop    %esi
801044fa:	5f                   	pop    %edi
801044fb:	5d                   	pop    %ebp
    p->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
801044fc:	e9 0f 06 00 00       	jmp    80104b10 <acquire>
80104501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (lk != &ptable.lock) {  //DOC: sleeplock0
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }
    // Go to sleep.
    p->chan = chan;
80104508:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010450b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

    sched();
80104512:	e8 09 fd ff ff       	call   80104220 <sched>

    // Tidy up.
    p->chan = 0;
80104517:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}
8010451e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104521:	5b                   	pop    %ebx
80104522:	5e                   	pop    %esi
80104523:	5f                   	pop    %edi
80104524:	5d                   	pop    %ebp
80104525:	c3                   	ret    

    if (p == 0)
        panic("sleep");

    if (lk == 0)
        panic("sleep without lk");
80104526:	83 ec 0c             	sub    $0xc,%esp
80104529:	68 6f 83 10 80       	push   $0x8010836f
8010452e:	e8 3d be ff ff       	call   80100370 <panic>
void
sleep(void *chan, struct spinlock *lk) {
    struct proc *p = myproc();

    if (p == 0)
        panic("sleep");
80104533:	83 ec 0c             	sub    $0xc,%esp
80104536:	68 69 83 10 80       	push   $0x80108369
8010453b:	e8 30 be ff ff       	call   80100370 <panic>

80104540 <wait>:
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	53                   	push   %ebx
80104546:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
80104549:	e8 82 05 00 00       	call   80104ad0 <pushcli>
    c = mycpu();
8010454e:	e8 9d f6 ff ff       	call   80103bf0 <mycpu>
    p = c->proc;
80104553:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104559:	e8 62 06 00 00       	call   80104bc0 <popcli>
    int havekids, pid;
    struct proc *curproc = myproc();
#if(defined(LIFO) || defined(SCFIFO))
    struct page *pg;
#endif
    acquire(&ptable.lock);
8010455e:	83 ec 0c             	sub    $0xc,%esp
80104561:	68 40 4d 11 80       	push   $0x80114d40
80104566:	e8 a5 05 00 00       	call   80104b10 <acquire>
8010456b:	83 c4 10             	add    $0x10,%esp
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
8010456e:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104570:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
80104575:	eb 17                	jmp    8010458e <wait+0x4e>
80104577:	89 f6                	mov    %esi,%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104580:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
80104586:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
8010458c:	74 22                	je     801045b0 <wait+0x70>
            if (p->parent != curproc)
8010458e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104591:	75 ed                	jne    80104580 <wait+0x40>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
80104593:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104597:	74 3d                	je     801045d6 <wait+0x96>
#endif
    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104599:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
            if (p->parent != curproc)
                continue;
            havekids = 1;
8010459f:	b8 01 00 00 00       	mov    $0x1,%eax
#endif
    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045a4:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
801045aa:	75 e2                	jne    8010458e <wait+0x4e>
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
801045b0:	85 c0                	test   %eax,%eax
801045b2:	0f 84 0f 01 00 00    	je     801046c7 <wait+0x187>
801045b8:	8b 46 24             	mov    0x24(%esi),%eax
801045bb:	85 c0                	test   %eax,%eax
801045bd:	0f 85 04 01 00 00    	jne    801046c7 <wait+0x187>
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801045c3:	83 ec 08             	sub    $0x8,%esp
801045c6:	68 40 4d 11 80       	push   $0x80114d40
801045cb:	56                   	push   %esi
801045cc:	e8 af fe ff ff       	call   80104480 <sleep>
    }
801045d1:	83 c4 10             	add    $0x10,%esp
801045d4:	eb 98                	jmp    8010456e <wait+0x2e>
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
801045d6:	83 ec 0c             	sub    $0xc,%esp
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
801045d9:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
801045dc:	ff 73 08             	pushl  0x8(%ebx)
801045df:	e8 3c e1 ff ff       	call   80102720 <kfree>
                p->kstack = 0;
801045e4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
801045eb:	5a                   	pop    %edx
801045ec:	ff 73 04             	pushl  0x4(%ebx)
801045ef:	e8 2c 34 00 00       	call   80107a20 <freevm>
801045f4:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
801045fa:	8d 93 40 04 00 00    	lea    0x440(%ebx),%edx
                p->pid = 0;
80104600:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104607:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
8010460e:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
80104612:	83 c4 10             	add    $0x10,%esp
                p->killed = 0;
80104615:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
8010461c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
80104623:	89 c8                	mov    %ecx,%eax
#if(defined(LIFO) || defined(SCFIFO))
                p->pagesCounter = -1;
80104625:	c7 83 44 04 00 00 ff 	movl   $0xffffffff,0x444(%ebx)
8010462c:	ff ff ff 
                p->nextpageid = 0;
8010462f:	c7 83 40 04 00 00 00 	movl   $0x0,0x440(%ebx)
80104636:	00 00 00 
            //                p->swapOffset = 0;
                p->pagesequel = 0;
                p->pagesinSwap = 0;
80104639:	89 cf                	mov    %ecx,%edi
                p->state = UNUSED;
#if(defined(LIFO) || defined(SCFIFO))
                p->pagesCounter = -1;
                p->nextpageid = 0;
            //                p->swapOffset = 0;
                p->pagesequel = 0;
8010463b:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
80104642:	00 00 00 
                p->pagesinSwap = 0;
80104645:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
8010464c:	00 00 00 
8010464f:	90                   	nop
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
                    p->swapFileEntries[k]=0;
80104650:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80104656:	83 c7 04             	add    $0x4,%edi
                p->nextpageid = 0;
            //                p->swapOffset = 0;
                p->pagesequel = 0;
                p->pagesinSwap = 0;
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
80104659:	39 d7                	cmp    %edx,%edi
8010465b:	75 f3                	jne    80104650 <wait+0x110>
                    p->swapFileEntries[k]=0;

                //init proc's pages
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010465d:	83 eb 80             	sub    $0xffffff80,%ebx
                {
                    pg->active = 0;
80104660:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
                    pg->offset = 0;
80104666:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
                    p->swapFileEntries[k]=0;

                //init proc's pages
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010466d:	83 c3 1c             	add    $0x1c,%ebx
                {
                    pg->active = 0;
                    pg->offset = 0;
                    pg->pageid = 0;
80104670:	c7 43 e8 00 00 00 00 	movl   $0x0,-0x18(%ebx)
                    pg->present = -1;
80104677:	c7 43 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebx)
                    pg->sequel = -1;
8010467e:	c7 43 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebx)
                    pg->physAdress = 0;
80104685:	c7 43 f8 00 00 00 00 	movl   $0x0,-0x8(%ebx)
                    pg->virtAdress = 0;
8010468c:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
                    p->swapFileEntries[k]=0;

                //init proc's pages
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80104693:	39 d9                	cmp    %ebx,%ecx
80104695:	77 c9                	ja     80104660 <wait+0x120>
80104697:	89 f6                	mov    %esi,%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    pg->physAdress = 0;
                    pg->virtAdress = 0;
                }
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
                    p->swapFileEntries[k]=0;
801046a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801046a6:	83 c0 04             	add    $0x4,%eax
                    pg->sequel = -1;
                    pg->physAdress = 0;
                    pg->virtAdress = 0;
                }
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
801046a9:	39 d0                	cmp    %edx,%eax
801046ab:	75 f3                	jne    801046a0 <wait+0x160>
                    p->swapFileEntries[k]=0;

#endif

                release(&ptable.lock);
801046ad:	83 ec 0c             	sub    $0xc,%esp
801046b0:	68 40 4d 11 80       	push   $0x80114d40
801046b5:	e8 76 05 00 00       	call   80104c30 <release>
                return pid;
801046ba:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801046bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
                    p->swapFileEntries[k]=0;

#endif

                release(&ptable.lock);
                return pid;
801046c0:	89 f0                	mov    %esi,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801046c2:	5b                   	pop    %ebx
801046c3:	5e                   	pop    %esi
801046c4:	5f                   	pop    %edi
801046c5:	5d                   	pop    %ebp
801046c6:	c3                   	ret    
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
801046c7:	83 ec 0c             	sub    $0xc,%esp
801046ca:	68 40 4d 11 80       	push   $0x80114d40
801046cf:	e8 5c 05 00 00       	call   80104c30 <release>
            return -1;
801046d4:	83 c4 10             	add    $0x10,%esp
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801046d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
            return -1;
801046da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}
801046df:	5b                   	pop    %ebx
801046e0:	5e                   	pop    %esi
801046e1:	5f                   	pop    %edi
801046e2:	5d                   	pop    %ebp
801046e3:	c3                   	ret    
801046e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801046f0 <wakeup>:
            p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 10             	sub    $0x10,%esp
801046f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
801046fa:	68 40 4d 11 80       	push   $0x80114d40
801046ff:	e8 0c 04 00 00       	call   80104b10 <acquire>
80104704:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104707:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
8010470c:	eb 0e                	jmp    8010471c <wakeup+0x2c>
8010470e:	66 90                	xchg   %ax,%ax
80104710:	05 5c 04 00 00       	add    $0x45c,%eax
80104715:	3d 74 64 12 80       	cmp    $0x80126474,%eax
8010471a:	74 1e                	je     8010473a <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan)
8010471c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104720:	75 ee                	jne    80104710 <wakeup+0x20>
80104722:	3b 58 20             	cmp    0x20(%eax),%ebx
80104725:	75 e9                	jne    80104710 <wakeup+0x20>
            p->state = RUNNABLE;
80104727:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010472e:	05 5c 04 00 00       	add    $0x45c,%eax
80104733:	3d 74 64 12 80       	cmp    $0x80126474,%eax
80104738:	75 e2                	jne    8010471c <wakeup+0x2c>
// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
8010473a:	c7 45 08 40 4d 11 80 	movl   $0x80114d40,0x8(%ebp)
}
80104741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104744:	c9                   	leave  
// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
80104745:	e9 e6 04 00 00       	jmp    80104c30 <release>
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104750 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 10             	sub    $0x10,%esp
80104757:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
8010475a:	68 40 4d 11 80       	push   $0x80114d40
8010475f:	e8 ac 03 00 00       	call   80104b10 <acquire>
80104764:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104767:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
8010476c:	eb 0e                	jmp    8010477c <kill+0x2c>
8010476e:	66 90                	xchg   %ax,%ax
80104770:	05 5c 04 00 00       	add    $0x45c,%eax
80104775:	3d 74 64 12 80       	cmp    $0x80126474,%eax
8010477a:	74 3c                	je     801047b8 <kill+0x68>
        if (p->pid == pid) {
8010477c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010477f:	75 ef                	jne    80104770 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
80104781:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
    struct proc *p;

    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
80104785:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
8010478c:	74 1a                	je     801047a8 <kill+0x58>
                p->state = RUNNABLE;
            release(&ptable.lock);
8010478e:	83 ec 0c             	sub    $0xc,%esp
80104791:	68 40 4d 11 80       	push   $0x80114d40
80104796:	e8 95 04 00 00       	call   80104c30 <release>
            return 0;
8010479b:	83 c4 10             	add    $0x10,%esp
8010479e:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801047a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a3:	c9                   	leave  
801047a4:	c3                   	ret    
801047a5:	8d 76 00             	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
                p->state = RUNNABLE;
801047a8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801047af:	eb dd                	jmp    8010478e <kill+0x3e>
801047b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
801047b8:	83 ec 0c             	sub    $0xc,%esp
801047bb:	68 40 4d 11 80       	push   $0x80114d40
801047c0:	e8 6b 04 00 00       	call   80104c30 <release>
    return -1;
801047c5:	83 c4 10             	add    $0x10,%esp
801047c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d0:	c9                   	leave  
801047d1:	c3                   	ret    
801047d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047e0 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	57                   	push   %edi
801047e4:	56                   	push   %esi
801047e5:	53                   	push   %ebx
801047e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801047e9:	bb e0 4d 11 80       	mov    $0x80114de0,%ebx
801047ee:	83 ec 3c             	sub    $0x3c,%esp
801047f1:	eb 27                	jmp    8010481a <procdump+0x3a>
801047f3:	90                   	nop
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
801047f8:	83 ec 0c             	sub    $0xc,%esp
801047fb:	68 39 88 10 80       	push   $0x80108839
80104800:	e8 5b be ff ff       	call   80100660 <cprintf>
80104805:	83 c4 10             	add    $0x10,%esp
80104808:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
    int currentFreePages = 0;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010480e:	81 fb e0 64 12 80    	cmp    $0x801264e0,%ebx
80104814:	0f 84 b6 00 00 00    	je     801048d0 <procdump+0xf0>
        if (p->state == UNUSED)
8010481a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010481d:	85 c0                	test   %eax,%eax
8010481f:	74 e7                	je     80104808 <procdump+0x28>
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104821:	83 f8 05             	cmp    $0x5,%eax
            state = states[p->state];
        else
            state = "???";
80104824:	ba 80 83 10 80       	mov    $0x80108380,%edx
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104829:	77 11                	ja     8010483c <procdump+0x5c>
8010482b:	8b 14 85 14 84 10 80 	mov    -0x7fef7bec(,%eax,4),%edx
            state = states[p->state];
        else
            state = "???";
80104832:	b8 80 83 10 80       	mov    $0x80108380,%eax
80104837:	85 d2                	test   %edx,%edx
80104839:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %d %d %d %d %d %s", p->pid, state, p->name,
                (p->pagesCounter - p->pagesinSwap), p->pagesinSwap, p->protectedPages,
8010483c:	8b 83 dc 03 00 00    	mov    0x3dc(%ebx),%eax
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d %s %d %d %d %d %d %s", p->pid, state, p->name,
80104842:	8b 8b d8 03 00 00    	mov    0x3d8(%ebx),%ecx
80104848:	83 ec 0c             	sub    $0xc,%esp
8010484b:	ff b3 ec 03 00 00    	pushl  0x3ec(%ebx)
80104851:	ff b3 e8 03 00 00    	pushl  0x3e8(%ebx)
80104857:	ff b3 e4 03 00 00    	pushl  0x3e4(%ebx)
8010485d:	29 c1                	sub    %eax,%ecx
8010485f:	50                   	push   %eax
80104860:	51                   	push   %ecx
80104861:	53                   	push   %ebx
80104862:	52                   	push   %edx
80104863:	ff 73 a4             	pushl  -0x5c(%ebx)
80104866:	68 84 83 10 80       	push   $0x80108384
8010486b:	e8 f0 bd ff ff       	call   80100660 <cprintf>
                (p->pagesCounter - p->pagesinSwap), p->pagesinSwap, p->protectedPages,
                p->pageFaults, p->totalPagesInSwap);
        if (p->state == SLEEPING) {
80104870:	83 c4 30             	add    $0x30,%esp
80104873:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104877:	0f 85 7b ff ff ff    	jne    801047f8 <procdump+0x18>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
8010487d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104880:	83 ec 08             	sub    $0x8,%esp
80104883:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104886:	50                   	push   %eax
80104887:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010488a:	8b 40 0c             	mov    0xc(%eax),%eax
8010488d:	83 c0 08             	add    $0x8,%eax
80104890:	50                   	push   %eax
80104891:	e8 9a 01 00 00       	call   80104a30 <getcallerpcs>
80104896:	83 c4 10             	add    $0x10,%esp
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
801048a0:	8b 17                	mov    (%edi),%edx
801048a2:	85 d2                	test   %edx,%edx
801048a4:	0f 84 4e ff ff ff    	je     801047f8 <procdump+0x18>
                cprintf(" %p", pc[i]);
801048aa:	83 ec 08             	sub    $0x8,%esp
801048ad:	83 c7 04             	add    $0x4,%edi
801048b0:	52                   	push   %edx
801048b1:	68 81 7d 10 80       	push   $0x80107d81
801048b6:	e8 a5 bd ff ff       	call   80100660 <cprintf>
        cprintf("%d %s %d %d %d %d %d %s", p->pid, state, p->name,
                (p->pagesCounter - p->pagesinSwap), p->pagesinSwap, p->protectedPages,
                p->pageFaults, p->totalPagesInSwap);
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
801048bb:	83 c4 10             	add    $0x10,%esp
801048be:	39 f7                	cmp    %esi,%edi
801048c0:	75 de                	jne    801048a0 <procdump+0xc0>
801048c2:	e9 31 ff ff ff       	jmp    801047f8 <procdump+0x18>
801048c7:	89 f6                	mov    %esi,%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
    currentFreePages = kallocCount();
801048d0:	e8 db dd ff ff       	call   801026b0 <kallocCount>
    cprintf(" %d / %d free pages in the system", currentFreePages, totalAvailablePages);
801048d5:	83 ec 04             	sub    $0x4,%esp
801048d8:	ff 35 b8 b5 10 80    	pushl  0x8010b5b8
801048de:	50                   	push   %eax
801048df:	68 f0 83 10 80       	push   $0x801083f0
801048e4:	e8 77 bd ff ff       	call   80100660 <cprintf>
}
801048e9:	83 c4 10             	add    $0x10,%esp
801048ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048ef:	5b                   	pop    %ebx
801048f0:	5e                   	pop    %esi
801048f1:	5f                   	pop    %edi
801048f2:	5d                   	pop    %ebp
801048f3:	c3                   	ret    
801048f4:	66 90                	xchg   %ax,%ax
801048f6:	66 90                	xchg   %ax,%ax
801048f8:	66 90                	xchg   %ax,%ax
801048fa:	66 90                	xchg   %ax,%ax
801048fc:	66 90                	xchg   %ax,%ax
801048fe:	66 90                	xchg   %ax,%ax

80104900 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	83 ec 0c             	sub    $0xc,%esp
80104907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010490a:	68 2c 84 10 80       	push   $0x8010842c
8010490f:	8d 43 04             	lea    0x4(%ebx),%eax
80104912:	50                   	push   %eax
80104913:	e8 f8 00 00 00       	call   80104a10 <initlock>
  lk->name = name;
80104918:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010491b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104921:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104924:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010492b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010492e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104931:	c9                   	leave  
80104932:	c3                   	ret    
80104933:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104940 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	8d 73 04             	lea    0x4(%ebx),%esi
8010494e:	56                   	push   %esi
8010494f:	e8 bc 01 00 00       	call   80104b10 <acquire>
  while (lk->locked) {
80104954:	8b 13                	mov    (%ebx),%edx
80104956:	83 c4 10             	add    $0x10,%esp
80104959:	85 d2                	test   %edx,%edx
8010495b:	74 16                	je     80104973 <acquiresleep+0x33>
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104960:	83 ec 08             	sub    $0x8,%esp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	e8 16 fb ff ff       	call   80104480 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010496a:	8b 03                	mov    (%ebx),%eax
8010496c:	83 c4 10             	add    $0x10,%esp
8010496f:	85 c0                	test   %eax,%eax
80104971:	75 ed                	jne    80104960 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104973:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104979:	e8 12 f3 ff ff       	call   80103c90 <myproc>
8010497e:	8b 40 10             	mov    0x10(%eax),%eax
80104981:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104984:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104987:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010498a:	5b                   	pop    %ebx
8010498b:	5e                   	pop    %esi
8010498c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010498d:	e9 9e 02 00 00       	jmp    80104c30 <release>
80104992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049a0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049a8:	83 ec 0c             	sub    $0xc,%esp
801049ab:	8d 73 04             	lea    0x4(%ebx),%esi
801049ae:	56                   	push   %esi
801049af:	e8 5c 01 00 00       	call   80104b10 <acquire>
  lk->locked = 0;
801049b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049c1:	89 1c 24             	mov    %ebx,(%esp)
801049c4:	e8 27 fd ff ff       	call   801046f0 <wakeup>
  release(&lk->lk);
801049c9:	89 75 08             	mov    %esi,0x8(%ebp)
801049cc:	83 c4 10             	add    $0x10,%esp
}
801049cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d2:	5b                   	pop    %ebx
801049d3:	5e                   	pop    %esi
801049d4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801049d5:	e9 56 02 00 00       	jmp    80104c30 <release>
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049e0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	8d 5e 04             	lea    0x4(%esi),%ebx
801049ee:	53                   	push   %ebx
801049ef:	e8 1c 01 00 00       	call   80104b10 <acquire>
  r = lk->locked;
801049f4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801049f6:	89 1c 24             	mov    %ebx,(%esp)
801049f9:	e8 32 02 00 00       	call   80104c30 <release>
  return r;
}
801049fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a01:	89 f0                	mov    %esi,%eax
80104a03:	5b                   	pop    %ebx
80104a04:	5e                   	pop    %esi
80104a05:	5d                   	pop    %ebp
80104a06:	c3                   	ret    
80104a07:	66 90                	xchg   %ax,%ax
80104a09:	66 90                	xchg   %ax,%ax
80104a0b:	66 90                	xchg   %ax,%ax
80104a0d:	66 90                	xchg   %ax,%ax
80104a0f:	90                   	nop

80104a10 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104a1f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104a22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a29:	5d                   	pop    %ebp
80104a2a:	c3                   	ret    
80104a2b:	90                   	nop
80104a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a30 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a34:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a3a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104a3d:	31 c0                	xor    %eax,%eax
80104a3f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a40:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104a46:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a4c:	77 1a                	ja     80104a68 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a4e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104a51:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a54:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104a57:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a59:	83 f8 0a             	cmp    $0xa,%eax
80104a5c:	75 e2                	jne    80104a40 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a5e:	5b                   	pop    %ebx
80104a5f:	5d                   	pop    %ebp
80104a60:	c3                   	ret    
80104a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104a68:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104a6f:	83 c0 01             	add    $0x1,%eax
80104a72:	83 f8 0a             	cmp    $0xa,%eax
80104a75:	74 e7                	je     80104a5e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104a77:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104a7e:	83 c0 01             	add    $0x1,%eax
80104a81:	83 f8 0a             	cmp    $0xa,%eax
80104a84:	75 e2                	jne    80104a68 <getcallerpcs+0x38>
80104a86:	eb d6                	jmp    80104a5e <getcallerpcs+0x2e>
80104a88:	90                   	nop
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a90 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
80104a97:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104a9a:	8b 02                	mov    (%edx),%eax
80104a9c:	85 c0                	test   %eax,%eax
80104a9e:	75 10                	jne    80104ab0 <holding+0x20>
}
80104aa0:	83 c4 04             	add    $0x4,%esp
80104aa3:	31 c0                	xor    %eax,%eax
80104aa5:	5b                   	pop    %ebx
80104aa6:	5d                   	pop    %ebp
80104aa7:	c3                   	ret    
80104aa8:	90                   	nop
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104ab0:	8b 5a 08             	mov    0x8(%edx),%ebx
80104ab3:	e8 38 f1 ff ff       	call   80103bf0 <mycpu>
80104ab8:	39 c3                	cmp    %eax,%ebx
80104aba:	0f 94 c0             	sete   %al
}
80104abd:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104ac0:	0f b6 c0             	movzbl %al,%eax
}
80104ac3:	5b                   	pop    %ebx
80104ac4:	5d                   	pop    %ebp
80104ac5:	c3                   	ret    
80104ac6:	8d 76 00             	lea    0x0(%esi),%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
80104ad7:	9c                   	pushf  
80104ad8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104ad9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104ada:	e8 11 f1 ff ff       	call   80103bf0 <mycpu>
80104adf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ae5:	85 c0                	test   %eax,%eax
80104ae7:	75 11                	jne    80104afa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104ae9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104aef:	e8 fc f0 ff ff       	call   80103bf0 <mycpu>
80104af4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104afa:	e8 f1 f0 ff ff       	call   80103bf0 <mycpu>
80104aff:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b06:	83 c4 04             	add    $0x4,%esp
80104b09:	5b                   	pop    %ebx
80104b0a:	5d                   	pop    %ebp
80104b0b:	c3                   	ret    
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b10 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b15:	e8 b6 ff ff ff       	call   80104ad0 <pushcli>
  if(holding(lk))
80104b1a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104b1d:	8b 03                	mov    (%ebx),%eax
80104b1f:	85 c0                	test   %eax,%eax
80104b21:	75 7d                	jne    80104ba0 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104b23:	ba 01 00 00 00       	mov    $0x1,%edx
80104b28:	eb 09                	jmp    80104b33 <acquire+0x23>
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b30:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b33:	89 d0                	mov    %edx,%eax
80104b35:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104b38:	85 c0                	test   %eax,%eax
80104b3a:	75 f4                	jne    80104b30 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104b3c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b44:	e8 a7 f0 ff ff       	call   80103bf0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104b49:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104b4b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104b4e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b51:	31 c0                	xor    %eax,%eax
80104b53:	90                   	nop
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b58:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104b5e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b64:	77 1a                	ja     80104b80 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b66:	8b 5a 04             	mov    0x4(%edx),%ebx
80104b69:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b6c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104b6f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b71:	83 f8 0a             	cmp    $0xa,%eax
80104b74:	75 e2                	jne    80104b58 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b79:	5b                   	pop    %ebx
80104b7a:	5e                   	pop    %esi
80104b7b:	5d                   	pop    %ebp
80104b7c:	c3                   	ret    
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104b80:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b87:	83 c0 01             	add    $0x1,%eax
80104b8a:	83 f8 0a             	cmp    $0xa,%eax
80104b8d:	74 e7                	je     80104b76 <acquire+0x66>
    pcs[i] = 0;
80104b8f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b96:	83 c0 01             	add    $0x1,%eax
80104b99:	83 f8 0a             	cmp    $0xa,%eax
80104b9c:	75 e2                	jne    80104b80 <acquire+0x70>
80104b9e:	eb d6                	jmp    80104b76 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104ba0:	8b 73 08             	mov    0x8(%ebx),%esi
80104ba3:	e8 48 f0 ff ff       	call   80103bf0 <mycpu>
80104ba8:	39 c6                	cmp    %eax,%esi
80104baa:	0f 85 73 ff ff ff    	jne    80104b23 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104bb0:	83 ec 0c             	sub    $0xc,%esp
80104bb3:	68 37 84 10 80       	push   $0x80108437
80104bb8:	e8 b3 b7 ff ff       	call   80100370 <panic>
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi

80104bc0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bc6:	9c                   	pushf  
80104bc7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bc8:	f6 c4 02             	test   $0x2,%ah
80104bcb:	75 52                	jne    80104c1f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104bcd:	e8 1e f0 ff ff       	call   80103bf0 <mycpu>
80104bd2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104bd8:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104bdb:	85 d2                	test   %edx,%edx
80104bdd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104be3:	78 2d                	js     80104c12 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104be5:	e8 06 f0 ff ff       	call   80103bf0 <mycpu>
80104bea:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104bf0:	85 d2                	test   %edx,%edx
80104bf2:	74 0c                	je     80104c00 <popcli+0x40>
    sti();
}
80104bf4:	c9                   	leave  
80104bf5:	c3                   	ret    
80104bf6:	8d 76 00             	lea    0x0(%esi),%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c00:	e8 eb ef ff ff       	call   80103bf0 <mycpu>
80104c05:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c0b:	85 c0                	test   %eax,%eax
80104c0d:	74 e5                	je     80104bf4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104c0f:	fb                   	sti    
    sti();
}
80104c10:	c9                   	leave  
80104c11:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104c12:	83 ec 0c             	sub    $0xc,%esp
80104c15:	68 56 84 10 80       	push   $0x80108456
80104c1a:	e8 51 b7 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104c1f:	83 ec 0c             	sub    $0xc,%esp
80104c22:	68 3f 84 10 80       	push   $0x8010843f
80104c27:	e8 44 b7 ff ff       	call   80100370 <panic>
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c30 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
80104c35:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104c38:	8b 03                	mov    (%ebx),%eax
80104c3a:	85 c0                	test   %eax,%eax
80104c3c:	75 12                	jne    80104c50 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104c3e:	83 ec 0c             	sub    $0xc,%esp
80104c41:	68 5d 84 10 80       	push   $0x8010845d
80104c46:	e8 25 b7 ff ff       	call   80100370 <panic>
80104c4b:	90                   	nop
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104c50:	8b 73 08             	mov    0x8(%ebx),%esi
80104c53:	e8 98 ef ff ff       	call   80103bf0 <mycpu>
80104c58:	39 c6                	cmp    %eax,%esi
80104c5a:	75 e2                	jne    80104c3e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
80104c5c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c63:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104c6a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c6f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104c75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c78:	5b                   	pop    %ebx
80104c79:	5e                   	pop    %esi
80104c7a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104c7b:	e9 40 ff ff ff       	jmp    80104bc0 <popcli>

80104c80 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	53                   	push   %ebx
80104c85:	8b 55 08             	mov    0x8(%ebp),%edx
80104c88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104c8b:	f6 c2 03             	test   $0x3,%dl
80104c8e:	75 05                	jne    80104c95 <memset+0x15>
80104c90:	f6 c1 03             	test   $0x3,%cl
80104c93:	74 13                	je     80104ca8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104c95:	89 d7                	mov    %edx,%edi
80104c97:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c9a:	fc                   	cld    
80104c9b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104c9d:	5b                   	pop    %ebx
80104c9e:	89 d0                	mov    %edx,%eax
80104ca0:	5f                   	pop    %edi
80104ca1:	5d                   	pop    %ebp
80104ca2:	c3                   	ret    
80104ca3:	90                   	nop
80104ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104ca8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104cac:	c1 e9 02             	shr    $0x2,%ecx
80104caf:	89 fb                	mov    %edi,%ebx
80104cb1:	89 f8                	mov    %edi,%eax
80104cb3:	c1 e3 18             	shl    $0x18,%ebx
80104cb6:	c1 e0 10             	shl    $0x10,%eax
80104cb9:	09 d8                	or     %ebx,%eax
80104cbb:	09 f8                	or     %edi,%eax
80104cbd:	c1 e7 08             	shl    $0x8,%edi
80104cc0:	09 f8                	or     %edi,%eax
80104cc2:	89 d7                	mov    %edx,%edi
80104cc4:	fc                   	cld    
80104cc5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104cc7:	5b                   	pop    %ebx
80104cc8:	89 d0                	mov    %edx,%eax
80104cca:	5f                   	pop    %edi
80104ccb:	5d                   	pop    %ebp
80104ccc:	c3                   	ret    
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi

80104cd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	8b 45 10             	mov    0x10(%ebp),%eax
80104cd8:	53                   	push   %ebx
80104cd9:	8b 75 0c             	mov    0xc(%ebp),%esi
80104cdc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104cdf:	85 c0                	test   %eax,%eax
80104ce1:	74 29                	je     80104d0c <memcmp+0x3c>
    if(*s1 != *s2)
80104ce3:	0f b6 13             	movzbl (%ebx),%edx
80104ce6:	0f b6 0e             	movzbl (%esi),%ecx
80104ce9:	38 d1                	cmp    %dl,%cl
80104ceb:	75 2b                	jne    80104d18 <memcmp+0x48>
80104ced:	8d 78 ff             	lea    -0x1(%eax),%edi
80104cf0:	31 c0                	xor    %eax,%eax
80104cf2:	eb 14                	jmp    80104d08 <memcmp+0x38>
80104cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cf8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104cfd:	83 c0 01             	add    $0x1,%eax
80104d00:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d04:	38 ca                	cmp    %cl,%dl
80104d06:	75 10                	jne    80104d18 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d08:	39 f8                	cmp    %edi,%eax
80104d0a:	75 ec                	jne    80104cf8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d0c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104d0d:	31 c0                	xor    %eax,%eax
}
80104d0f:	5e                   	pop    %esi
80104d10:	5f                   	pop    %edi
80104d11:	5d                   	pop    %ebp
80104d12:	c3                   	ret    
80104d13:	90                   	nop
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104d18:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104d1b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104d1c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104d1e:	5e                   	pop    %esi
80104d1f:	5f                   	pop    %edi
80104d20:	5d                   	pop    %ebp
80104d21:	c3                   	ret    
80104d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
80104d35:	8b 45 08             	mov    0x8(%ebp),%eax
80104d38:	8b 75 0c             	mov    0xc(%ebp),%esi
80104d3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d3e:	39 c6                	cmp    %eax,%esi
80104d40:	73 2e                	jae    80104d70 <memmove+0x40>
80104d42:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104d45:	39 c8                	cmp    %ecx,%eax
80104d47:	73 27                	jae    80104d70 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104d49:	85 db                	test   %ebx,%ebx
80104d4b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104d4e:	74 17                	je     80104d67 <memmove+0x37>
      *--d = *--s;
80104d50:	29 d9                	sub    %ebx,%ecx
80104d52:	89 cb                	mov    %ecx,%ebx
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d58:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d5c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104d5f:	83 ea 01             	sub    $0x1,%edx
80104d62:	83 fa ff             	cmp    $0xffffffff,%edx
80104d65:	75 f1                	jne    80104d58 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d67:	5b                   	pop    %ebx
80104d68:	5e                   	pop    %esi
80104d69:	5d                   	pop    %ebp
80104d6a:	c3                   	ret    
80104d6b:	90                   	nop
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104d70:	31 d2                	xor    %edx,%edx
80104d72:	85 db                	test   %ebx,%ebx
80104d74:	74 f1                	je     80104d67 <memmove+0x37>
80104d76:	8d 76 00             	lea    0x0(%esi),%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104d80:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104d84:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104d87:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104d8a:	39 d3                	cmp    %edx,%ebx
80104d8c:	75 f2                	jne    80104d80 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104d8e:	5b                   	pop    %ebx
80104d8f:	5e                   	pop    %esi
80104d90:	5d                   	pop    %ebp
80104d91:	c3                   	ret    
80104d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104da3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104da4:	eb 8a                	jmp    80104d30 <memmove>
80104da6:	8d 76 00             	lea    0x0(%esi),%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	57                   	push   %edi
80104db4:	56                   	push   %esi
80104db5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104db8:	53                   	push   %ebx
80104db9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104dbc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104dbf:	85 c9                	test   %ecx,%ecx
80104dc1:	74 37                	je     80104dfa <strncmp+0x4a>
80104dc3:	0f b6 17             	movzbl (%edi),%edx
80104dc6:	0f b6 1e             	movzbl (%esi),%ebx
80104dc9:	84 d2                	test   %dl,%dl
80104dcb:	74 3f                	je     80104e0c <strncmp+0x5c>
80104dcd:	38 d3                	cmp    %dl,%bl
80104dcf:	75 3b                	jne    80104e0c <strncmp+0x5c>
80104dd1:	8d 47 01             	lea    0x1(%edi),%eax
80104dd4:	01 cf                	add    %ecx,%edi
80104dd6:	eb 1b                	jmp    80104df3 <strncmp+0x43>
80104dd8:	90                   	nop
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104de0:	0f b6 10             	movzbl (%eax),%edx
80104de3:	84 d2                	test   %dl,%dl
80104de5:	74 21                	je     80104e08 <strncmp+0x58>
80104de7:	0f b6 19             	movzbl (%ecx),%ebx
80104dea:	83 c0 01             	add    $0x1,%eax
80104ded:	89 ce                	mov    %ecx,%esi
80104def:	38 da                	cmp    %bl,%dl
80104df1:	75 19                	jne    80104e0c <strncmp+0x5c>
80104df3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104df5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104df8:	75 e6                	jne    80104de0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104dfa:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104dfb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104dfd:	5e                   	pop    %esi
80104dfe:	5f                   	pop    %edi
80104dff:	5d                   	pop    %ebp
80104e00:	c3                   	ret    
80104e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e08:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e0c:	0f b6 c2             	movzbl %dl,%eax
80104e0f:	29 d8                	sub    %ebx,%eax
}
80104e11:	5b                   	pop    %ebx
80104e12:	5e                   	pop    %esi
80104e13:	5f                   	pop    %edi
80104e14:	5d                   	pop    %ebp
80104e15:	c3                   	ret    
80104e16:	8d 76 00             	lea    0x0(%esi),%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	56                   	push   %esi
80104e24:	53                   	push   %ebx
80104e25:	8b 45 08             	mov    0x8(%ebp),%eax
80104e28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e2e:	89 c2                	mov    %eax,%edx
80104e30:	eb 19                	jmp    80104e4b <strncpy+0x2b>
80104e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e38:	83 c3 01             	add    $0x1,%ebx
80104e3b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e3f:	83 c2 01             	add    $0x1,%edx
80104e42:	84 c9                	test   %cl,%cl
80104e44:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e47:	74 09                	je     80104e52 <strncpy+0x32>
80104e49:	89 f1                	mov    %esi,%ecx
80104e4b:	85 c9                	test   %ecx,%ecx
80104e4d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104e50:	7f e6                	jg     80104e38 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e52:	31 c9                	xor    %ecx,%ecx
80104e54:	85 f6                	test   %esi,%esi
80104e56:	7e 17                	jle    80104e6f <strncpy+0x4f>
80104e58:	90                   	nop
80104e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e60:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104e64:	89 f3                	mov    %esi,%ebx
80104e66:	83 c1 01             	add    $0x1,%ecx
80104e69:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104e6b:	85 db                	test   %ebx,%ebx
80104e6d:	7f f1                	jg     80104e60 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104e6f:	5b                   	pop    %ebx
80104e70:	5e                   	pop    %esi
80104e71:	5d                   	pop    %ebp
80104e72:	c3                   	ret    
80104e73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
80104e85:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e88:	8b 45 08             	mov    0x8(%ebp),%eax
80104e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104e8e:	85 c9                	test   %ecx,%ecx
80104e90:	7e 26                	jle    80104eb8 <safestrcpy+0x38>
80104e92:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104e96:	89 c1                	mov    %eax,%ecx
80104e98:	eb 17                	jmp    80104eb1 <safestrcpy+0x31>
80104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ea0:	83 c2 01             	add    $0x1,%edx
80104ea3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ea7:	83 c1 01             	add    $0x1,%ecx
80104eaa:	84 db                	test   %bl,%bl
80104eac:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104eaf:	74 04                	je     80104eb5 <safestrcpy+0x35>
80104eb1:	39 f2                	cmp    %esi,%edx
80104eb3:	75 eb                	jne    80104ea0 <safestrcpy+0x20>
    ;
  *s = 0;
80104eb5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104eb8:	5b                   	pop    %ebx
80104eb9:	5e                   	pop    %esi
80104eba:	5d                   	pop    %ebp
80104ebb:	c3                   	ret    
80104ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ec0 <strlen>:

int
strlen(const char *s)
{
80104ec0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ec1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104ec8:	80 3a 00             	cmpb   $0x0,(%edx)
80104ecb:	74 0c                	je     80104ed9 <strlen+0x19>
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
80104ed0:	83 c0 01             	add    $0x1,%eax
80104ed3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ed7:	75 f7                	jne    80104ed0 <strlen+0x10>
    ;
  return n;
}
80104ed9:	5d                   	pop    %ebp
80104eda:	c3                   	ret    

80104edb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104edb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104edf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104ee3:	55                   	push   %ebp
  pushl %ebx
80104ee4:	53                   	push   %ebx
  pushl %esi
80104ee5:	56                   	push   %esi
  pushl %edi
80104ee6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ee7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ee9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104eeb:	5f                   	pop    %edi
  popl %esi
80104eec:	5e                   	pop    %esi
  popl %ebx
80104eed:	5b                   	pop    %ebx
  popl %ebp
80104eee:	5d                   	pop    %ebp
  ret
80104eef:	c3                   	ret    

80104ef0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	53                   	push   %ebx
80104ef4:	83 ec 04             	sub    $0x4,%esp
80104ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104efa:	e8 91 ed ff ff       	call   80103c90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eff:	8b 00                	mov    (%eax),%eax
80104f01:	39 d8                	cmp    %ebx,%eax
80104f03:	76 1b                	jbe    80104f20 <fetchint+0x30>
80104f05:	8d 53 04             	lea    0x4(%ebx),%edx
80104f08:	39 d0                	cmp    %edx,%eax
80104f0a:	72 14                	jb     80104f20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f0f:	8b 13                	mov    (%ebx),%edx
80104f11:	89 10                	mov    %edx,(%eax)
  return 0;
80104f13:	31 c0                	xor    %eax,%eax
}
80104f15:	83 c4 04             	add    $0x4,%esp
80104f18:	5b                   	pop    %ebx
80104f19:	5d                   	pop    %ebp
80104f1a:	c3                   	ret    
80104f1b:	90                   	nop
80104f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f25:	eb ee                	jmp    80104f15 <fetchint+0x25>
80104f27:	89 f6                	mov    %esi,%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	53                   	push   %ebx
80104f34:	83 ec 04             	sub    $0x4,%esp
80104f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f3a:	e8 51 ed ff ff       	call   80103c90 <myproc>

  if(addr >= curproc->sz)
80104f3f:	39 18                	cmp    %ebx,(%eax)
80104f41:	76 29                	jbe    80104f6c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f46:	89 da                	mov    %ebx,%edx
80104f48:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104f4a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104f4c:	39 c3                	cmp    %eax,%ebx
80104f4e:	73 1c                	jae    80104f6c <fetchstr+0x3c>
    if(*s == 0)
80104f50:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f53:	75 10                	jne    80104f65 <fetchstr+0x35>
80104f55:	eb 29                	jmp    80104f80 <fetchstr+0x50>
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f60:	80 3a 00             	cmpb   $0x0,(%edx)
80104f63:	74 1b                	je     80104f80 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104f65:	83 c2 01             	add    $0x1,%edx
80104f68:	39 d0                	cmp    %edx,%eax
80104f6a:	77 f4                	ja     80104f60 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104f6c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104f6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104f74:	5b                   	pop    %ebx
80104f75:	5d                   	pop    %ebp
80104f76:	c3                   	ret    
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f80:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104f83:	89 d0                	mov    %edx,%eax
80104f85:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104f87:	5b                   	pop    %ebx
80104f88:	5d                   	pop    %ebp
80104f89:	c3                   	ret    
80104f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f95:	e8 f6 ec ff ff       	call   80103c90 <myproc>
80104f9a:	8b 40 18             	mov    0x18(%eax),%eax
80104f9d:	8b 55 08             	mov    0x8(%ebp),%edx
80104fa0:	8b 40 44             	mov    0x44(%eax),%eax
80104fa3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104fa6:	e8 e5 ec ff ff       	call   80103c90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fab:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fad:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fb0:	39 c6                	cmp    %eax,%esi
80104fb2:	73 1c                	jae    80104fd0 <argint+0x40>
80104fb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fb7:	39 d0                	cmp    %edx,%eax
80104fb9:	72 15                	jb     80104fd0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fbe:	8b 53 04             	mov    0x4(%ebx),%edx
80104fc1:	89 10                	mov    %edx,(%eax)
  return 0;
80104fc3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104fc5:	5b                   	pop    %ebx
80104fc6:	5e                   	pop    %esi
80104fc7:	5d                   	pop    %ebp
80104fc8:	c3                   	ret    
80104fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd5:	eb ee                	jmp    80104fc5 <argint+0x35>
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fe0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
80104fe5:	83 ec 10             	sub    $0x10,%esp
80104fe8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104feb:	e8 a0 ec ff ff       	call   80103c90 <myproc>
80104ff0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ff2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ff5:	83 ec 08             	sub    $0x8,%esp
80104ff8:	50                   	push   %eax
80104ff9:	ff 75 08             	pushl  0x8(%ebp)
80104ffc:	e8 8f ff ff ff       	call   80104f90 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105001:	c1 e8 1f             	shr    $0x1f,%eax
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	84 c0                	test   %al,%al
80105009:	75 2d                	jne    80105038 <argptr+0x58>
8010500b:	89 d8                	mov    %ebx,%eax
8010500d:	c1 e8 1f             	shr    $0x1f,%eax
80105010:	84 c0                	test   %al,%al
80105012:	75 24                	jne    80105038 <argptr+0x58>
80105014:	8b 16                	mov    (%esi),%edx
80105016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105019:	39 c2                	cmp    %eax,%edx
8010501b:	76 1b                	jbe    80105038 <argptr+0x58>
8010501d:	01 c3                	add    %eax,%ebx
8010501f:	39 da                	cmp    %ebx,%edx
80105021:	72 15                	jb     80105038 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80105023:	8b 55 0c             	mov    0xc(%ebp),%edx
80105026:	89 02                	mov    %eax,(%edx)
  return 0;
80105028:	31 c0                	xor    %eax,%eax
}
8010502a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010502d:	5b                   	pop    %ebx
8010502e:	5e                   	pop    %esi
8010502f:	5d                   	pop    %ebp
80105030:	c3                   	ret    
80105031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80105038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503d:	eb eb                	jmp    8010502a <argptr+0x4a>
8010503f:	90                   	nop

80105040 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105046:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105049:	50                   	push   %eax
8010504a:	ff 75 08             	pushl  0x8(%ebp)
8010504d:	e8 3e ff ff ff       	call   80104f90 <argint>
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	85 c0                	test   %eax,%eax
80105057:	78 17                	js     80105070 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105059:	83 ec 08             	sub    $0x8,%esp
8010505c:	ff 75 0c             	pushl  0xc(%ebp)
8010505f:	ff 75 f4             	pushl  -0xc(%ebp)
80105062:	e8 c9 fe ff ff       	call   80104f30 <fetchstr>
80105067:	83 c4 10             	add    $0x10,%esp
}
8010506a:	c9                   	leave  
8010506b:	c3                   	ret    
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80105075:	c9                   	leave  
80105076:	c3                   	ret    
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105085:	e8 06 ec ff ff       	call   80103c90 <myproc>

  num = curproc->tf->eax;
8010508a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010508d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010508f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105092:	8d 50 ff             	lea    -0x1(%eax),%edx
80105095:	83 fa 15             	cmp    $0x15,%edx
80105098:	77 1e                	ja     801050b8 <syscall+0x38>
8010509a:	8b 14 85 a0 84 10 80 	mov    -0x7fef7b60(,%eax,4),%edx
801050a1:	85 d2                	test   %edx,%edx
801050a3:	74 13                	je     801050b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801050a5:	ff d2                	call   *%edx
801050a7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050ad:	5b                   	pop    %ebx
801050ae:	5e                   	pop    %esi
801050af:	5d                   	pop    %ebp
801050b0:	c3                   	ret    
801050b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801050b8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050b9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801050bc:	50                   	push   %eax
801050bd:	ff 73 10             	pushl  0x10(%ebx)
801050c0:	68 65 84 10 80       	push   $0x80108465
801050c5:	e8 96 b5 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801050ca:	8b 43 18             	mov    0x18(%ebx),%eax
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801050d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050da:	5b                   	pop    %ebx
801050db:	5e                   	pop    %esi
801050dc:	5d                   	pop    %ebp
801050dd:	c3                   	ret    
801050de:	66 90                	xchg   %ax,%ax

801050e0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
801050e5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801050e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801050ea:	89 d3                	mov    %edx,%ebx
801050ec:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801050ef:	50                   	push   %eax
801050f0:	6a 00                	push   $0x0
801050f2:	e8 99 fe ff ff       	call   80104f90 <argint>
801050f7:	83 c4 10             	add    $0x10,%esp
801050fa:	85 c0                	test   %eax,%eax
801050fc:	78 32                	js     80105130 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050fe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105102:	77 2c                	ja     80105130 <argfd.constprop.0+0x50>
80105104:	e8 87 eb ff ff       	call   80103c90 <myproc>
80105109:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010510c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105110:	85 c0                	test   %eax,%eax
80105112:	74 1c                	je     80105130 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105114:	85 f6                	test   %esi,%esi
80105116:	74 02                	je     8010511a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105118:	89 16                	mov    %edx,(%esi)
  if(pf)
8010511a:	85 db                	test   %ebx,%ebx
8010511c:	74 22                	je     80105140 <argfd.constprop.0+0x60>
    *pf = f;
8010511e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105120:	31 c0                	xor    %eax,%eax
}
80105122:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105125:	5b                   	pop    %ebx
80105126:	5e                   	pop    %esi
80105127:	5d                   	pop    %ebp
80105128:	c3                   	ret    
80105129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105130:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105133:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105138:	5b                   	pop    %ebx
80105139:	5e                   	pop    %esi
8010513a:	5d                   	pop    %ebp
8010513b:	c3                   	ret    
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105140:	31 c0                	xor    %eax,%eax
80105142:	eb de                	jmp    80105122 <argfd.constprop.0+0x42>
80105144:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010514a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105150 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105150:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105151:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105153:	89 e5                	mov    %esp,%ebp
80105155:	56                   	push   %esi
80105156:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105157:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010515a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010515d:	e8 7e ff ff ff       	call   801050e0 <argfd.constprop.0>
80105162:	85 c0                	test   %eax,%eax
80105164:	78 1a                	js     80105180 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105166:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105168:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010516b:	e8 20 eb ff ff       	call   80103c90 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105170:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105174:	85 d2                	test   %edx,%edx
80105176:	74 18                	je     80105190 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105178:	83 c3 01             	add    $0x1,%ebx
8010517b:	83 fb 10             	cmp    $0x10,%ebx
8010517e:	75 f0                	jne    80105170 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105180:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105183:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105188:	5b                   	pop    %ebx
80105189:	5e                   	pop    %esi
8010518a:	5d                   	pop    %ebp
8010518b:	c3                   	ret    
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105190:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105194:	83 ec 0c             	sub    $0xc,%esp
80105197:	ff 75 f4             	pushl  -0xc(%ebp)
8010519a:	e8 71 bc ff ff       	call   80100e10 <filedup>
  return fd;
8010519f:	83 c4 10             	add    $0x10,%esp
}
801051a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801051a5:	89 d8                	mov    %ebx,%eax
}
801051a7:	5b                   	pop    %ebx
801051a8:	5e                   	pop    %esi
801051a9:	5d                   	pop    %ebp
801051aa:	c3                   	ret    
801051ab:	90                   	nop
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051b0 <sys_read>:

int
sys_read(void)
{
801051b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051b1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051bb:	e8 20 ff ff ff       	call   801050e0 <argfd.constprop.0>
801051c0:	85 c0                	test   %eax,%eax
801051c2:	78 4c                	js     80105210 <sys_read+0x60>
801051c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c7:	83 ec 08             	sub    $0x8,%esp
801051ca:	50                   	push   %eax
801051cb:	6a 02                	push   $0x2
801051cd:	e8 be fd ff ff       	call   80104f90 <argint>
801051d2:	83 c4 10             	add    $0x10,%esp
801051d5:	85 c0                	test   %eax,%eax
801051d7:	78 37                	js     80105210 <sys_read+0x60>
801051d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051dc:	83 ec 04             	sub    $0x4,%esp
801051df:	ff 75 f0             	pushl  -0x10(%ebp)
801051e2:	50                   	push   %eax
801051e3:	6a 01                	push   $0x1
801051e5:	e8 f6 fd ff ff       	call   80104fe0 <argptr>
801051ea:	83 c4 10             	add    $0x10,%esp
801051ed:	85 c0                	test   %eax,%eax
801051ef:	78 1f                	js     80105210 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801051f1:	83 ec 04             	sub    $0x4,%esp
801051f4:	ff 75 f0             	pushl  -0x10(%ebp)
801051f7:	ff 75 f4             	pushl  -0xc(%ebp)
801051fa:	ff 75 ec             	pushl  -0x14(%ebp)
801051fd:	e8 7e bd ff ff       	call   80100f80 <fileread>
80105202:	83 c4 10             	add    $0x10,%esp
}
80105205:	c9                   	leave  
80105206:	c3                   	ret    
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105215:	c9                   	leave  
80105216:	c3                   	ret    
80105217:	89 f6                	mov    %esi,%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105220 <sys_write>:

int
sys_write(void)
{
80105220:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105221:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105223:	89 e5                	mov    %esp,%ebp
80105225:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105228:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010522b:	e8 b0 fe ff ff       	call   801050e0 <argfd.constprop.0>
80105230:	85 c0                	test   %eax,%eax
80105232:	78 4c                	js     80105280 <sys_write+0x60>
80105234:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105237:	83 ec 08             	sub    $0x8,%esp
8010523a:	50                   	push   %eax
8010523b:	6a 02                	push   $0x2
8010523d:	e8 4e fd ff ff       	call   80104f90 <argint>
80105242:	83 c4 10             	add    $0x10,%esp
80105245:	85 c0                	test   %eax,%eax
80105247:	78 37                	js     80105280 <sys_write+0x60>
80105249:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010524c:	83 ec 04             	sub    $0x4,%esp
8010524f:	ff 75 f0             	pushl  -0x10(%ebp)
80105252:	50                   	push   %eax
80105253:	6a 01                	push   $0x1
80105255:	e8 86 fd ff ff       	call   80104fe0 <argptr>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	85 c0                	test   %eax,%eax
8010525f:	78 1f                	js     80105280 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105261:	83 ec 04             	sub    $0x4,%esp
80105264:	ff 75 f0             	pushl  -0x10(%ebp)
80105267:	ff 75 f4             	pushl  -0xc(%ebp)
8010526a:	ff 75 ec             	pushl  -0x14(%ebp)
8010526d:	e8 9e bd ff ff       	call   80101010 <filewrite>
80105272:	83 c4 10             	add    $0x10,%esp
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_close>:

int
sys_close(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105296:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105299:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010529c:	e8 3f fe ff ff       	call   801050e0 <argfd.constprop.0>
801052a1:	85 c0                	test   %eax,%eax
801052a3:	78 2b                	js     801052d0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801052a5:	e8 e6 e9 ff ff       	call   80103c90 <myproc>
801052aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801052ad:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
801052b0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801052b7:	00 
  fileclose(f);
801052b8:	ff 75 f4             	pushl  -0xc(%ebp)
801052bb:	e8 a0 bb ff ff       	call   80100e60 <fileclose>
  return 0;
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	31 c0                	xor    %eax,%eax
}
801052c5:	c9                   	leave  
801052c6:	c3                   	ret    
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_fstat>:

int
sys_fstat(void)
{
801052e0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052e1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801052e3:	89 e5                	mov    %esp,%ebp
801052e5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052e8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801052eb:	e8 f0 fd ff ff       	call   801050e0 <argfd.constprop.0>
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 2c                	js     80105320 <sys_fstat+0x40>
801052f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052f7:	83 ec 04             	sub    $0x4,%esp
801052fa:	6a 14                	push   $0x14
801052fc:	50                   	push   %eax
801052fd:	6a 01                	push   $0x1
801052ff:	e8 dc fc ff ff       	call   80104fe0 <argptr>
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	85 c0                	test   %eax,%eax
80105309:	78 15                	js     80105320 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010530b:	83 ec 08             	sub    $0x8,%esp
8010530e:	ff 75 f4             	pushl  -0xc(%ebp)
80105311:	ff 75 f0             	pushl  -0x10(%ebp)
80105314:	e8 17 bc ff ff       	call   80100f30 <filestat>
80105319:	83 c4 10             	add    $0x10,%esp
}
8010531c:	c9                   	leave  
8010531d:	c3                   	ret    
8010531e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
80105335:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105336:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105339:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010533c:	50                   	push   %eax
8010533d:	6a 00                	push   $0x0
8010533f:	e8 fc fc ff ff       	call   80105040 <argstr>
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	85 c0                	test   %eax,%eax
80105349:	0f 88 fb 00 00 00    	js     8010544a <sys_link+0x11a>
8010534f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105352:	83 ec 08             	sub    $0x8,%esp
80105355:	50                   	push   %eax
80105356:	6a 01                	push   $0x1
80105358:	e8 e3 fc ff ff       	call   80105040 <argstr>
8010535d:	83 c4 10             	add    $0x10,%esp
80105360:	85 c0                	test   %eax,%eax
80105362:	0f 88 e2 00 00 00    	js     8010544a <sys_link+0x11a>
    return -1;

  begin_op();
80105368:	e8 23 dc ff ff       	call   80102f90 <begin_op>
  if((ip = namei(old)) == 0){
8010536d:	83 ec 0c             	sub    $0xc,%esp
80105370:	ff 75 d4             	pushl  -0x2c(%ebp)
80105373:	e8 78 cb ff ff       	call   80101ef0 <namei>
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	85 c0                	test   %eax,%eax
8010537d:	89 c3                	mov    %eax,%ebx
8010537f:	0f 84 f3 00 00 00    	je     80105478 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105385:	83 ec 0c             	sub    $0xc,%esp
80105388:	50                   	push   %eax
80105389:	e8 12 c3 ff ff       	call   801016a0 <ilock>
  if(ip->type == T_DIR){
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105396:	0f 84 c4 00 00 00    	je     80105460 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010539c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801053a1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801053a4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801053a7:	53                   	push   %ebx
801053a8:	e8 43 c2 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
801053ad:	89 1c 24             	mov    %ebx,(%esp)
801053b0:	e8 cb c3 ff ff       	call   80101780 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801053b5:	58                   	pop    %eax
801053b6:	5a                   	pop    %edx
801053b7:	57                   	push   %edi
801053b8:	ff 75 d0             	pushl  -0x30(%ebp)
801053bb:	e8 50 cb ff ff       	call   80101f10 <nameiparent>
801053c0:	83 c4 10             	add    $0x10,%esp
801053c3:	85 c0                	test   %eax,%eax
801053c5:	89 c6                	mov    %eax,%esi
801053c7:	74 5b                	je     80105424 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	50                   	push   %eax
801053cd:	e8 ce c2 ff ff       	call   801016a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	8b 03                	mov    (%ebx),%eax
801053d7:	39 06                	cmp    %eax,(%esi)
801053d9:	75 3d                	jne    80105418 <sys_link+0xe8>
801053db:	83 ec 04             	sub    $0x4,%esp
801053de:	ff 73 04             	pushl  0x4(%ebx)
801053e1:	57                   	push   %edi
801053e2:	56                   	push   %esi
801053e3:	e8 48 ca ff ff       	call   80101e30 <dirlink>
801053e8:	83 c4 10             	add    $0x10,%esp
801053eb:	85 c0                	test   %eax,%eax
801053ed:	78 29                	js     80105418 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801053ef:	83 ec 0c             	sub    $0xc,%esp
801053f2:	56                   	push   %esi
801053f3:	e8 38 c5 ff ff       	call   80101930 <iunlockput>
  iput(ip);
801053f8:	89 1c 24             	mov    %ebx,(%esp)
801053fb:	e8 d0 c3 ff ff       	call   801017d0 <iput>

  end_op();
80105400:	e8 fb db ff ff       	call   80103000 <end_op>

  return 0;
80105405:	83 c4 10             	add    $0x10,%esp
80105408:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010540a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010540d:	5b                   	pop    %ebx
8010540e:	5e                   	pop    %esi
8010540f:	5f                   	pop    %edi
80105410:	5d                   	pop    %ebp
80105411:	c3                   	ret    
80105412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105418:	83 ec 0c             	sub    $0xc,%esp
8010541b:	56                   	push   %esi
8010541c:	e8 0f c5 ff ff       	call   80101930 <iunlockput>
    goto bad;
80105421:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	53                   	push   %ebx
80105428:	e8 73 c2 ff ff       	call   801016a0 <ilock>
  ip->nlink--;
8010542d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105432:	89 1c 24             	mov    %ebx,(%esp)
80105435:	e8 b6 c1 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
8010543a:	89 1c 24             	mov    %ebx,(%esp)
8010543d:	e8 ee c4 ff ff       	call   80101930 <iunlockput>
  end_op();
80105442:	e8 b9 db ff ff       	call   80103000 <end_op>
  return -1;
80105447:	83 c4 10             	add    $0x10,%esp
}
8010544a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010544d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105452:	5b                   	pop    %ebx
80105453:	5e                   	pop    %esi
80105454:	5f                   	pop    %edi
80105455:	5d                   	pop    %ebp
80105456:	c3                   	ret    
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	53                   	push   %ebx
80105464:	e8 c7 c4 ff ff       	call   80101930 <iunlockput>
    end_op();
80105469:	e8 92 db ff ff       	call   80103000 <end_op>
    return -1;
8010546e:	83 c4 10             	add    $0x10,%esp
80105471:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105476:	eb 92                	jmp    8010540a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105478:	e8 83 db ff ff       	call   80103000 <end_op>
    return -1;
8010547d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105482:	eb 86                	jmp    8010540a <sys_link+0xda>
80105484:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010548a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105490 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
80105495:	53                   	push   %ebx
80105496:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105499:	bb 20 00 00 00       	mov    $0x20,%ebx
8010549e:	83 ec 1c             	sub    $0x1c,%esp
801054a1:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054a4:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801054a8:	77 0e                	ja     801054b8 <isdirempty+0x28>
801054aa:	eb 34                	jmp    801054e0 <isdirempty+0x50>
801054ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054b0:	83 c3 10             	add    $0x10,%ebx
801054b3:	39 5e 58             	cmp    %ebx,0x58(%esi)
801054b6:	76 28                	jbe    801054e0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054b8:	6a 10                	push   $0x10
801054ba:	53                   	push   %ebx
801054bb:	57                   	push   %edi
801054bc:	56                   	push   %esi
801054bd:	e8 be c4 ff ff       	call   80101980 <readi>
801054c2:	83 c4 10             	add    $0x10,%esp
801054c5:	83 f8 10             	cmp    $0x10,%eax
801054c8:	75 23                	jne    801054ed <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801054ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054cf:	74 df                	je     801054b0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801054d1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
801054d4:	31 c0                	xor    %eax,%eax
  }
  return 1;
}
801054d6:	5b                   	pop    %ebx
801054d7:	5e                   	pop    %esi
801054d8:	5f                   	pop    %edi
801054d9:	5d                   	pop    %ebp
801054da:	c3                   	ret    
801054db:	90                   	nop
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801054e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801054e8:	5b                   	pop    %ebx
801054e9:	5e                   	pop    %esi
801054ea:	5f                   	pop    %edi
801054eb:	5d                   	pop    %ebp
801054ec:	c3                   	ret    
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801054ed:	83 ec 0c             	sub    $0xc,%esp
801054f0:	68 fc 84 10 80       	push   $0x801084fc
801054f5:	e8 76 ae ff ff       	call   80100370 <panic>
801054fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105500 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
80105505:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105506:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105509:	83 ec 44             	sub    $0x44,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010550c:	50                   	push   %eax
8010550d:	6a 00                	push   $0x0
8010550f:	e8 2c fb ff ff       	call   80105040 <argstr>
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	85 c0                	test   %eax,%eax
80105519:	0f 88 51 01 00 00    	js     80105670 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010551f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105522:	e8 69 da ff ff       	call   80102f90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105527:	83 ec 08             	sub    $0x8,%esp
8010552a:	53                   	push   %ebx
8010552b:	ff 75 c0             	pushl  -0x40(%ebp)
8010552e:	e8 dd c9 ff ff       	call   80101f10 <nameiparent>
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	85 c0                	test   %eax,%eax
80105538:	89 c6                	mov    %eax,%esi
8010553a:	0f 84 37 01 00 00    	je     80105677 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	50                   	push   %eax
80105544:	e8 57 c1 ff ff       	call   801016a0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105549:	58                   	pop    %eax
8010554a:	5a                   	pop    %edx
8010554b:	68 bd 7e 10 80       	push   $0x80107ebd
80105550:	53                   	push   %ebx
80105551:	e8 5a c6 ff ff       	call   80101bb0 <namecmp>
80105556:	83 c4 10             	add    $0x10,%esp
80105559:	85 c0                	test   %eax,%eax
8010555b:	0f 84 d3 00 00 00    	je     80105634 <sys_unlink+0x134>
80105561:	83 ec 08             	sub    $0x8,%esp
80105564:	68 bc 7e 10 80       	push   $0x80107ebc
80105569:	53                   	push   %ebx
8010556a:	e8 41 c6 ff ff       	call   80101bb0 <namecmp>
8010556f:	83 c4 10             	add    $0x10,%esp
80105572:	85 c0                	test   %eax,%eax
80105574:	0f 84 ba 00 00 00    	je     80105634 <sys_unlink+0x134>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010557a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010557d:	83 ec 04             	sub    $0x4,%esp
80105580:	50                   	push   %eax
80105581:	53                   	push   %ebx
80105582:	56                   	push   %esi
80105583:	e8 48 c6 ff ff       	call   80101bd0 <dirlookup>
80105588:	83 c4 10             	add    $0x10,%esp
8010558b:	85 c0                	test   %eax,%eax
8010558d:	89 c3                	mov    %eax,%ebx
8010558f:	0f 84 9f 00 00 00    	je     80105634 <sys_unlink+0x134>
    goto bad;
  ilock(ip);
80105595:	83 ec 0c             	sub    $0xc,%esp
80105598:	50                   	push   %eax
80105599:	e8 02 c1 ff ff       	call   801016a0 <ilock>

  if(ip->nlink < 1)
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801055a6:	0f 8e e4 00 00 00    	jle    80105690 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801055ac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055b1:	74 65                	je     80105618 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801055b3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801055b6:	83 ec 04             	sub    $0x4,%esp
801055b9:	6a 10                	push   $0x10
801055bb:	6a 00                	push   $0x0
801055bd:	57                   	push   %edi
801055be:	e8 bd f6 ff ff       	call   80104c80 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055c3:	6a 10                	push   $0x10
801055c5:	ff 75 c4             	pushl  -0x3c(%ebp)
801055c8:	57                   	push   %edi
801055c9:	56                   	push   %esi
801055ca:	e8 b1 c4 ff ff       	call   80101a80 <writei>
801055cf:	83 c4 20             	add    $0x20,%esp
801055d2:	83 f8 10             	cmp    $0x10,%eax
801055d5:	0f 85 a8 00 00 00    	jne    80105683 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801055db:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055e0:	74 76                	je     80105658 <sys_unlink+0x158>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801055e2:	83 ec 0c             	sub    $0xc,%esp
801055e5:	56                   	push   %esi
801055e6:	e8 45 c3 ff ff       	call   80101930 <iunlockput>

  ip->nlink--;
801055eb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055f0:	89 1c 24             	mov    %ebx,(%esp)
801055f3:	e8 f8 bf ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
801055f8:	89 1c 24             	mov    %ebx,(%esp)
801055fb:	e8 30 c3 ff ff       	call   80101930 <iunlockput>

  end_op();
80105600:	e8 fb d9 ff ff       	call   80103000 <end_op>

  return 0;
80105605:	83 c4 10             	add    $0x10,%esp
80105608:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010560a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010560d:	5b                   	pop    %ebx
8010560e:	5e                   	pop    %esi
8010560f:	5f                   	pop    %edi
80105610:	5d                   	pop    %ebp
80105611:	c3                   	ret    
80105612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	53                   	push   %ebx
8010561c:	e8 6f fe ff ff       	call   80105490 <isdirempty>
80105621:	83 c4 10             	add    $0x10,%esp
80105624:	85 c0                	test   %eax,%eax
80105626:	75 8b                	jne    801055b3 <sys_unlink+0xb3>
    iunlockput(ip);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	53                   	push   %ebx
8010562c:	e8 ff c2 ff ff       	call   80101930 <iunlockput>
    goto bad;
80105631:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105634:	83 ec 0c             	sub    $0xc,%esp
80105637:	56                   	push   %esi
80105638:	e8 f3 c2 ff ff       	call   80101930 <iunlockput>
  end_op();
8010563d:	e8 be d9 ff ff       	call   80103000 <end_op>
  return -1;
80105642:	83 c4 10             	add    $0x10,%esp
}
80105645:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105648:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564d:	5b                   	pop    %ebx
8010564e:	5e                   	pop    %esi
8010564f:	5f                   	pop    %edi
80105650:	5d                   	pop    %ebp
80105651:	c3                   	ret    
80105652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105658:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	56                   	push   %esi
80105661:	e8 8a bf ff ff       	call   801015f0 <iupdate>
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	e9 74 ff ff ff       	jmp    801055e2 <sys_unlink+0xe2>
8010566e:	66 90                	xchg   %ax,%ax
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105675:	eb 93                	jmp    8010560a <sys_unlink+0x10a>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80105677:	e8 84 d9 ff ff       	call   80103000 <end_op>
    return -1;
8010567c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105681:	eb 87                	jmp    8010560a <sys_unlink+0x10a>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105683:	83 ec 0c             	sub    $0xc,%esp
80105686:	68 d1 7e 10 80       	push   $0x80107ed1
8010568b:	e8 e0 ac ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105690:	83 ec 0c             	sub    $0xc,%esp
80105693:	68 bf 7e 10 80       	push   $0x80107ebf
80105698:	e8 d3 ac ff ff       	call   80100370 <panic>
8010569d:	8d 76 00             	lea    0x0(%esi),%esi

801056a0 <create>:
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
801056a5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056a6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
801056a9:	83 ec 44             	sub    $0x44,%esp
801056ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801056af:	8b 55 10             	mov    0x10(%ebp),%edx
801056b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056b5:	56                   	push   %esi
801056b6:	ff 75 08             	pushl  0x8(%ebp)
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
801056b9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801056bc:	89 55 c0             	mov    %edx,-0x40(%ebp)
801056bf:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056c2:	e8 49 c8 ff ff       	call   80101f10 <nameiparent>
801056c7:	83 c4 10             	add    $0x10,%esp
801056ca:	85 c0                	test   %eax,%eax
801056cc:	0f 84 ee 00 00 00    	je     801057c0 <create+0x120>
    return 0;
  ilock(dp);
801056d2:	83 ec 0c             	sub    $0xc,%esp
801056d5:	89 c7                	mov    %eax,%edi
801056d7:	50                   	push   %eax
801056d8:	e8 c3 bf ff ff       	call   801016a0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801056dd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801056e0:	83 c4 0c             	add    $0xc,%esp
801056e3:	50                   	push   %eax
801056e4:	56                   	push   %esi
801056e5:	57                   	push   %edi
801056e6:	e8 e5 c4 ff ff       	call   80101bd0 <dirlookup>
801056eb:	83 c4 10             	add    $0x10,%esp
801056ee:	85 c0                	test   %eax,%eax
801056f0:	89 c3                	mov    %eax,%ebx
801056f2:	74 4c                	je     80105740 <create+0xa0>
    iunlockput(dp);
801056f4:	83 ec 0c             	sub    $0xc,%esp
801056f7:	57                   	push   %edi
801056f8:	e8 33 c2 ff ff       	call   80101930 <iunlockput>
    ilock(ip);
801056fd:	89 1c 24             	mov    %ebx,(%esp)
80105700:	e8 9b bf ff ff       	call   801016a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105705:	83 c4 10             	add    $0x10,%esp
80105708:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010570d:	75 11                	jne    80105720 <create+0x80>
8010570f:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80105714:	89 d8                	mov    %ebx,%eax
80105716:	75 08                	jne    80105720 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105718:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010571b:	5b                   	pop    %ebx
8010571c:	5e                   	pop    %esi
8010571d:	5f                   	pop    %edi
8010571e:	5d                   	pop    %ebp
8010571f:	c3                   	ret    
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	53                   	push   %ebx
80105724:	e8 07 c2 ff ff       	call   80101930 <iunlockput>
    return 0;
80105729:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010572c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010572f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105731:	5b                   	pop    %ebx
80105732:	5e                   	pop    %esi
80105733:	5f                   	pop    %edi
80105734:	5d                   	pop    %ebp
80105735:	c3                   	ret    
80105736:	8d 76 00             	lea    0x0(%esi),%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105740:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105744:	83 ec 08             	sub    $0x8,%esp
80105747:	50                   	push   %eax
80105748:	ff 37                	pushl  (%edi)
8010574a:	e8 e1 bd ff ff       	call   80101530 <ialloc>
8010574f:	83 c4 10             	add    $0x10,%esp
80105752:	85 c0                	test   %eax,%eax
80105754:	89 c3                	mov    %eax,%ebx
80105756:	0f 84 cc 00 00 00    	je     80105828 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	50                   	push   %eax
80105760:	e8 3b bf ff ff       	call   801016a0 <ilock>
  ip->major = major;
80105765:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105769:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010576d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105771:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105775:	b8 01 00 00 00       	mov    $0x1,%eax
8010577a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010577e:	89 1c 24             	mov    %ebx,(%esp)
80105781:	e8 6a be ff ff       	call   801015f0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010578e:	74 40                	je     801057d0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105790:	83 ec 04             	sub    $0x4,%esp
80105793:	ff 73 04             	pushl  0x4(%ebx)
80105796:	56                   	push   %esi
80105797:	57                   	push   %edi
80105798:	e8 93 c6 ff ff       	call   80101e30 <dirlink>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	78 77                	js     8010581b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801057a4:	83 ec 0c             	sub    $0xc,%esp
801057a7:	57                   	push   %edi
801057a8:	e8 83 c1 ff ff       	call   80101930 <iunlockput>

  return ip;
801057ad:	83 c4 10             	add    $0x10,%esp
}
801057b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801057b3:	89 d8                	mov    %ebx,%eax
}
801057b5:	5b                   	pop    %ebx
801057b6:	5e                   	pop    %esi
801057b7:	5f                   	pop    %edi
801057b8:	5d                   	pop    %ebp
801057b9:	c3                   	ret    
801057ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801057c0:	31 c0                	xor    %eax,%eax
801057c2:	e9 51 ff ff ff       	jmp    80105718 <create+0x78>
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801057d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801057d5:	83 ec 0c             	sub    $0xc,%esp
801057d8:	57                   	push   %edi
801057d9:	e8 12 be ff ff       	call   801015f0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057de:	83 c4 0c             	add    $0xc,%esp
801057e1:	ff 73 04             	pushl  0x4(%ebx)
801057e4:	68 bd 7e 10 80       	push   $0x80107ebd
801057e9:	53                   	push   %ebx
801057ea:	e8 41 c6 ff ff       	call   80101e30 <dirlink>
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	85 c0                	test   %eax,%eax
801057f4:	78 18                	js     8010580e <create+0x16e>
801057f6:	83 ec 04             	sub    $0x4,%esp
801057f9:	ff 77 04             	pushl  0x4(%edi)
801057fc:	68 bc 7e 10 80       	push   $0x80107ebc
80105801:	53                   	push   %ebx
80105802:	e8 29 c6 ff ff       	call   80101e30 <dirlink>
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	85 c0                	test   %eax,%eax
8010580c:	79 82                	jns    80105790 <create+0xf0>
      panic("create dots");
8010580e:	83 ec 0c             	sub    $0xc,%esp
80105811:	68 1d 85 10 80       	push   $0x8010851d
80105816:	e8 55 ab ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010581b:	83 ec 0c             	sub    $0xc,%esp
8010581e:	68 29 85 10 80       	push   $0x80108529
80105823:	e8 48 ab ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	68 0e 85 10 80       	push   $0x8010850e
80105830:	e8 3b ab ff ff       	call   80100370 <panic>
80105835:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	56                   	push   %esi
80105845:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105846:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105849:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010584c:	50                   	push   %eax
8010584d:	6a 00                	push   $0x0
8010584f:	e8 ec f7 ff ff       	call   80105040 <argstr>
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	85 c0                	test   %eax,%eax
80105859:	0f 88 9e 00 00 00    	js     801058fd <sys_open+0xbd>
8010585f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105862:	83 ec 08             	sub    $0x8,%esp
80105865:	50                   	push   %eax
80105866:	6a 01                	push   $0x1
80105868:	e8 23 f7 ff ff       	call   80104f90 <argint>
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	85 c0                	test   %eax,%eax
80105872:	0f 88 85 00 00 00    	js     801058fd <sys_open+0xbd>
    return -1;

  begin_op();
80105878:	e8 13 d7 ff ff       	call   80102f90 <begin_op>

  if(omode & O_CREATE){
8010587d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105881:	0f 85 89 00 00 00    	jne    80105910 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105887:	83 ec 0c             	sub    $0xc,%esp
8010588a:	ff 75 e0             	pushl  -0x20(%ebp)
8010588d:	e8 5e c6 ff ff       	call   80101ef0 <namei>
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	85 c0                	test   %eax,%eax
80105897:	89 c6                	mov    %eax,%esi
80105899:	0f 84 88 00 00 00    	je     80105927 <sys_open+0xe7>
      end_op();
      return -1;
    }
    ilock(ip);
8010589f:	83 ec 0c             	sub    $0xc,%esp
801058a2:	50                   	push   %eax
801058a3:	e8 f8 bd ff ff       	call   801016a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058a8:	83 c4 10             	add    $0x10,%esp
801058ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058b0:	0f 84 ca 00 00 00    	je     80105980 <sys_open+0x140>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058b6:	e8 e5 b4 ff ff       	call   80100da0 <filealloc>
801058bb:	85 c0                	test   %eax,%eax
801058bd:	89 c7                	mov    %eax,%edi
801058bf:	74 2b                	je     801058ec <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801058c1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801058c3:	e8 c8 e3 ff ff       	call   80103c90 <myproc>
801058c8:	90                   	nop
801058c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801058d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058d4:	85 d2                	test   %edx,%edx
801058d6:	74 60                	je     80105938 <sys_open+0xf8>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801058d8:	83 c3 01             	add    $0x1,%ebx
801058db:	83 fb 10             	cmp    $0x10,%ebx
801058de:	75 f0                	jne    801058d0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	57                   	push   %edi
801058e4:	e8 77 b5 ff ff       	call   80100e60 <fileclose>
801058e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801058ec:	83 ec 0c             	sub    $0xc,%esp
801058ef:	56                   	push   %esi
801058f0:	e8 3b c0 ff ff       	call   80101930 <iunlockput>
    end_op();
801058f5:	e8 06 d7 ff ff       	call   80103000 <end_op>
    return -1;
801058fa:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801058fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105905:	5b                   	pop    %ebx
80105906:	5e                   	pop    %esi
80105907:	5f                   	pop    %edi
80105908:	5d                   	pop    %ebp
80105909:	c3                   	ret    
8010590a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105910:	6a 00                	push   $0x0
80105912:	6a 00                	push   $0x0
80105914:	6a 02                	push   $0x2
80105916:	ff 75 e0             	pushl  -0x20(%ebp)
80105919:	e8 82 fd ff ff       	call   801056a0 <create>
    if(ip == 0){
8010591e:	83 c4 10             	add    $0x10,%esp
80105921:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105923:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105925:	75 8f                	jne    801058b6 <sys_open+0x76>
      end_op();
80105927:	e8 d4 d6 ff ff       	call   80103000 <end_op>
      return -1;
8010592c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105931:	eb 41                	jmp    80105974 <sys_open+0x134>
80105933:	90                   	nop
80105934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105938:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
8010593b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010593f:	56                   	push   %esi
80105940:	e8 3b be ff ff       	call   80101780 <iunlock>
  end_op();
80105945:	e8 b6 d6 ff ff       	call   80103000 <end_op>

  f->type = FD_INODE;
8010594a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105950:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105953:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105956:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105959:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105960:	89 d0                	mov    %edx,%eax
80105962:	83 e0 01             	and    $0x1,%eax
80105965:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105968:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010596b:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010596e:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105972:	89 d8                	mov    %ebx,%eax
}
80105974:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105977:	5b                   	pop    %ebx
80105978:	5e                   	pop    %esi
80105979:	5f                   	pop    %edi
8010597a:	5d                   	pop    %ebp
8010597b:	c3                   	ret    
8010597c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105980:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105983:	85 c9                	test   %ecx,%ecx
80105985:	0f 84 2b ff ff ff    	je     801058b6 <sys_open+0x76>
8010598b:	e9 5c ff ff ff       	jmp    801058ec <sys_open+0xac>

80105990 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105996:	e8 f5 d5 ff ff       	call   80102f90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010599b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010599e:	83 ec 08             	sub    $0x8,%esp
801059a1:	50                   	push   %eax
801059a2:	6a 00                	push   $0x0
801059a4:	e8 97 f6 ff ff       	call   80105040 <argstr>
801059a9:	83 c4 10             	add    $0x10,%esp
801059ac:	85 c0                	test   %eax,%eax
801059ae:	78 30                	js     801059e0 <sys_mkdir+0x50>
801059b0:	6a 00                	push   $0x0
801059b2:	6a 00                	push   $0x0
801059b4:	6a 01                	push   $0x1
801059b6:	ff 75 f4             	pushl  -0xc(%ebp)
801059b9:	e8 e2 fc ff ff       	call   801056a0 <create>
801059be:	83 c4 10             	add    $0x10,%esp
801059c1:	85 c0                	test   %eax,%eax
801059c3:	74 1b                	je     801059e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059c5:	83 ec 0c             	sub    $0xc,%esp
801059c8:	50                   	push   %eax
801059c9:	e8 62 bf ff ff       	call   80101930 <iunlockput>
  end_op();
801059ce:	e8 2d d6 ff ff       	call   80103000 <end_op>
  return 0;
801059d3:	83 c4 10             	add    $0x10,%esp
801059d6:	31 c0                	xor    %eax,%eax
}
801059d8:	c9                   	leave  
801059d9:	c3                   	ret    
801059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801059e0:	e8 1b d6 ff ff       	call   80103000 <end_op>
    return -1;
801059e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801059ea:	c9                   	leave  
801059eb:	c3                   	ret    
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_mknod>:

int
sys_mknod(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059f6:	e8 95 d5 ff ff       	call   80102f90 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059fe:	83 ec 08             	sub    $0x8,%esp
80105a01:	50                   	push   %eax
80105a02:	6a 00                	push   $0x0
80105a04:	e8 37 f6 ff ff       	call   80105040 <argstr>
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	85 c0                	test   %eax,%eax
80105a0e:	78 60                	js     80105a70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a10:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a13:	83 ec 08             	sub    $0x8,%esp
80105a16:	50                   	push   %eax
80105a17:	6a 01                	push   $0x1
80105a19:	e8 72 f5 ff ff       	call   80104f90 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	85 c0                	test   %eax,%eax
80105a23:	78 4b                	js     80105a70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105a25:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a28:	83 ec 08             	sub    $0x8,%esp
80105a2b:	50                   	push   %eax
80105a2c:	6a 02                	push   $0x2
80105a2e:	e8 5d f5 ff ff       	call   80104f90 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	85 c0                	test   %eax,%eax
80105a38:	78 36                	js     80105a70 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a3a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a3e:	50                   	push   %eax
80105a3f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105a43:	50                   	push   %eax
80105a44:	6a 03                	push   $0x3
80105a46:	ff 75 ec             	pushl  -0x14(%ebp)
80105a49:	e8 52 fc ff ff       	call   801056a0 <create>
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	85 c0                	test   %eax,%eax
80105a53:	74 1b                	je     80105a70 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a55:	83 ec 0c             	sub    $0xc,%esp
80105a58:	50                   	push   %eax
80105a59:	e8 d2 be ff ff       	call   80101930 <iunlockput>
  end_op();
80105a5e:	e8 9d d5 ff ff       	call   80103000 <end_op>
  return 0;
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	31 c0                	xor    %eax,%eax
}
80105a68:	c9                   	leave  
80105a69:	c3                   	ret    
80105a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105a70:	e8 8b d5 ff ff       	call   80103000 <end_op>
    return -1;
80105a75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105a7a:	c9                   	leave  
80105a7b:	c3                   	ret    
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <sys_chdir>:

int
sys_chdir(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	56                   	push   %esi
80105a84:	53                   	push   %ebx
80105a85:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a88:	e8 03 e2 ff ff       	call   80103c90 <myproc>
80105a8d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a8f:	e8 fc d4 ff ff       	call   80102f90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a97:	83 ec 08             	sub    $0x8,%esp
80105a9a:	50                   	push   %eax
80105a9b:	6a 00                	push   $0x0
80105a9d:	e8 9e f5 ff ff       	call   80105040 <argstr>
80105aa2:	83 c4 10             	add    $0x10,%esp
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	78 77                	js     80105b20 <sys_chdir+0xa0>
80105aa9:	83 ec 0c             	sub    $0xc,%esp
80105aac:	ff 75 f4             	pushl  -0xc(%ebp)
80105aaf:	e8 3c c4 ff ff       	call   80101ef0 <namei>
80105ab4:	83 c4 10             	add    $0x10,%esp
80105ab7:	85 c0                	test   %eax,%eax
80105ab9:	89 c3                	mov    %eax,%ebx
80105abb:	74 63                	je     80105b20 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	50                   	push   %eax
80105ac1:	e8 da bb ff ff       	call   801016a0 <ilock>
  if(ip->type != T_DIR){
80105ac6:	83 c4 10             	add    $0x10,%esp
80105ac9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ace:	75 30                	jne    80105b00 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	53                   	push   %ebx
80105ad4:	e8 a7 bc ff ff       	call   80101780 <iunlock>
  iput(curproc->cwd);
80105ad9:	58                   	pop    %eax
80105ada:	ff 76 68             	pushl  0x68(%esi)
80105add:	e8 ee bc ff ff       	call   801017d0 <iput>
  end_op();
80105ae2:	e8 19 d5 ff ff       	call   80103000 <end_op>
  curproc->cwd = ip;
80105ae7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105aea:	83 c4 10             	add    $0x10,%esp
80105aed:	31 c0                	xor    %eax,%eax
}
80105aef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105af2:	5b                   	pop    %ebx
80105af3:	5e                   	pop    %esi
80105af4:	5d                   	pop    %ebp
80105af5:	c3                   	ret    
80105af6:	8d 76 00             	lea    0x0(%esi),%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	53                   	push   %ebx
80105b04:	e8 27 be ff ff       	call   80101930 <iunlockput>
    end_op();
80105b09:	e8 f2 d4 ff ff       	call   80103000 <end_op>
    return -1;
80105b0e:	83 c4 10             	add    $0x10,%esp
80105b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b16:	eb d7                	jmp    80105aef <sys_chdir+0x6f>
80105b18:	90                   	nop
80105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105b20:	e8 db d4 ff ff       	call   80103000 <end_op>
    return -1;
80105b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2a:	eb c3                	jmp    80105aef <sys_chdir+0x6f>
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	57                   	push   %edi
80105b34:	56                   	push   %esi
80105b35:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b36:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
80105b3c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b42:	50                   	push   %eax
80105b43:	6a 00                	push   $0x0
80105b45:	e8 f6 f4 ff ff       	call   80105040 <argstr>
80105b4a:	83 c4 10             	add    $0x10,%esp
80105b4d:	85 c0                	test   %eax,%eax
80105b4f:	78 7f                	js     80105bd0 <sys_exec+0xa0>
80105b51:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b57:	83 ec 08             	sub    $0x8,%esp
80105b5a:	50                   	push   %eax
80105b5b:	6a 01                	push   $0x1
80105b5d:	e8 2e f4 ff ff       	call   80104f90 <argint>
80105b62:	83 c4 10             	add    $0x10,%esp
80105b65:	85 c0                	test   %eax,%eax
80105b67:	78 67                	js     80105bd0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b69:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b6f:	83 ec 04             	sub    $0x4,%esp
80105b72:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105b78:	68 80 00 00 00       	push   $0x80
80105b7d:	6a 00                	push   $0x0
80105b7f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b85:	50                   	push   %eax
80105b86:	31 db                	xor    %ebx,%ebx
80105b88:	e8 f3 f0 ff ff       	call   80104c80 <memset>
80105b8d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b90:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b96:	83 ec 08             	sub    $0x8,%esp
80105b99:	57                   	push   %edi
80105b9a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105b9d:	50                   	push   %eax
80105b9e:	e8 4d f3 ff ff       	call   80104ef0 <fetchint>
80105ba3:	83 c4 10             	add    $0x10,%esp
80105ba6:	85 c0                	test   %eax,%eax
80105ba8:	78 26                	js     80105bd0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105baa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bb0:	85 c0                	test   %eax,%eax
80105bb2:	74 2c                	je     80105be0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bb4:	83 ec 08             	sub    $0x8,%esp
80105bb7:	56                   	push   %esi
80105bb8:	50                   	push   %eax
80105bb9:	e8 72 f3 ff ff       	call   80104f30 <fetchstr>
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	85 c0                	test   %eax,%eax
80105bc3:	78 0b                	js     80105bd0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105bc5:	83 c3 01             	add    $0x1,%ebx
80105bc8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105bcb:	83 fb 20             	cmp    $0x20,%ebx
80105bce:	75 c0                	jne    80105b90 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105bd8:	5b                   	pop    %ebx
80105bd9:	5e                   	pop    %esi
80105bda:	5f                   	pop    %edi
80105bdb:	5d                   	pop    %ebp
80105bdc:	c3                   	ret    
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105be0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105be6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105be9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105bf0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105bf4:	50                   	push   %eax
80105bf5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105bfb:	e8 f0 ad ff ff       	call   801009f0 <exec>
80105c00:	83 c4 10             	add    $0x10,%esp
}
80105c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c06:	5b                   	pop    %ebx
80105c07:	5e                   	pop    %esi
80105c08:	5f                   	pop    %edi
80105c09:	5d                   	pop    %ebp
80105c0a:	c3                   	ret    
80105c0b:	90                   	nop
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c10 <sys_pipe>:

int
sys_pipe(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
80105c15:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c16:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105c19:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c1c:	6a 08                	push   $0x8
80105c1e:	50                   	push   %eax
80105c1f:	6a 00                	push   $0x0
80105c21:	e8 ba f3 ff ff       	call   80104fe0 <argptr>
80105c26:	83 c4 10             	add    $0x10,%esp
80105c29:	85 c0                	test   %eax,%eax
80105c2b:	78 4a                	js     80105c77 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c2d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c30:	83 ec 08             	sub    $0x8,%esp
80105c33:	50                   	push   %eax
80105c34:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c37:	50                   	push   %eax
80105c38:	e8 f3 d9 ff ff       	call   80103630 <pipealloc>
80105c3d:	83 c4 10             	add    $0x10,%esp
80105c40:	85 c0                	test   %eax,%eax
80105c42:	78 33                	js     80105c77 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105c44:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c46:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105c49:	e8 42 e0 ff ff       	call   80103c90 <myproc>
80105c4e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105c50:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c54:	85 f6                	test   %esi,%esi
80105c56:	74 30                	je     80105c88 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105c58:	83 c3 01             	add    $0x1,%ebx
80105c5b:	83 fb 10             	cmp    $0x10,%ebx
80105c5e:	75 f0                	jne    80105c50 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105c60:	83 ec 0c             	sub    $0xc,%esp
80105c63:	ff 75 e0             	pushl  -0x20(%ebp)
80105c66:	e8 f5 b1 ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
80105c6b:	58                   	pop    %eax
80105c6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c6f:	e8 ec b1 ff ff       	call   80100e60 <fileclose>
    return -1;
80105c74:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105c7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105c7f:	5b                   	pop    %ebx
80105c80:	5e                   	pop    %esi
80105c81:	5f                   	pop    %edi
80105c82:	5d                   	pop    %ebp
80105c83:	c3                   	ret    
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105c88:	8d 73 08             	lea    0x8(%ebx),%esi
80105c8b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c8f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105c92:	e8 f9 df ff ff       	call   80103c90 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105c97:	31 d2                	xor    %edx,%edx
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ca0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105ca4:	85 c9                	test   %ecx,%ecx
80105ca6:	74 18                	je     80105cc0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105ca8:	83 c2 01             	add    $0x1,%edx
80105cab:	83 fa 10             	cmp    $0x10,%edx
80105cae:	75 f0                	jne    80105ca0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105cb0:	e8 db df ff ff       	call   80103c90 <myproc>
80105cb5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105cbc:	00 
80105cbd:	eb a1                	jmp    80105c60 <sys_pipe+0x50>
80105cbf:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105cc0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105cc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cc7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105cc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ccc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105ccf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105cd2:	31 c0                	xor    %eax,%eax
}
80105cd4:	5b                   	pop    %ebx
80105cd5:	5e                   	pop    %esi
80105cd6:	5f                   	pop    %edi
80105cd7:	5d                   	pop    %ebp
80105cd8:	c3                   	ret    
80105cd9:	66 90                	xchg   %ax,%ax
80105cdb:	66 90                	xchg   %ax,%ax
80105cdd:	66 90                	xchg   %ax,%ax
80105cdf:	90                   	nop

80105ce0 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105ce6:	e8 45 e7 ff ff       	call   80104430 <yield>
  return 0;
}
80105ceb:	31 c0                	xor    %eax,%eax
80105ced:	c9                   	leave  
80105cee:	c3                   	ret    
80105cef:	90                   	nop

80105cf0 <sys_fork>:

int
sys_fork(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105cf3:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105cf4:	e9 57 e1 ff ff       	jmp    80103e50 <fork>
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_exit>:
}

int
sys_exit(void)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d06:	e8 d5 e5 ff ff       	call   801042e0 <exit>
  return 0;  // not reached
}
80105d0b:	31 c0                	xor    %eax,%eax
80105d0d:	c9                   	leave  
80105d0e:	c3                   	ret    
80105d0f:	90                   	nop

80105d10 <sys_wait>:

int
sys_wait(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d13:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105d14:	e9 27 e8 ff ff       	jmp    80104540 <wait>
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d20 <sys_kill>:
}

int
sys_kill(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d29:	50                   	push   %eax
80105d2a:	6a 00                	push   $0x0
80105d2c:	e8 5f f2 ff ff       	call   80104f90 <argint>
80105d31:	83 c4 10             	add    $0x10,%esp
80105d34:	85 c0                	test   %eax,%eax
80105d36:	78 18                	js     80105d50 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d3e:	e8 0d ea ff ff       	call   80104750 <kill>
80105d43:	83 c4 10             	add    $0x10,%esp
}
80105d46:	c9                   	leave  
80105d47:	c3                   	ret    
80105d48:	90                   	nop
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105d55:	c9                   	leave  
80105d56:	c3                   	ret    
80105d57:	89 f6                	mov    %esi,%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d60 <sys_getpid>:

int
sys_getpid(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d66:	e8 25 df ff ff       	call   80103c90 <myproc>
80105d6b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d6e:	c9                   	leave  
80105d6f:	c3                   	ret    

80105d70 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105d77:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d7a:	50                   	push   %eax
80105d7b:	6a 00                	push   $0x0
80105d7d:	e8 0e f2 ff ff       	call   80104f90 <argint>
80105d82:	83 c4 10             	add    $0x10,%esp
80105d85:	85 c0                	test   %eax,%eax
80105d87:	78 27                	js     80105db0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105d89:	e8 02 df ff ff       	call   80103c90 <myproc>
  if(growproc(n) < 0)
80105d8e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105d91:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d93:	ff 75 f4             	pushl  -0xc(%ebp)
80105d96:	e8 25 e0 ff ff       	call   80103dc0 <growproc>
80105d9b:	83 c4 10             	add    $0x10,%esp
80105d9e:	85 c0                	test   %eax,%eax
80105da0:	78 0e                	js     80105db0 <sys_sbrk+0x40>
    return -1;
  return addr;
80105da2:	89 d8                	mov    %ebx,%eax
}
80105da4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105da7:	c9                   	leave  
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db5:	eb ed                	jmp    80105da4 <sys_sbrk+0x34>
80105db7:	89 f6                	mov    %esi,%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dc0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105dc7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105dca:	50                   	push   %eax
80105dcb:	6a 00                	push   $0x0
80105dcd:	e8 be f1 ff ff       	call   80104f90 <argint>
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	0f 88 8a 00 00 00    	js     80105e67 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105ddd:	83 ec 0c             	sub    $0xc,%esp
80105de0:	68 a0 64 12 80       	push   $0x801264a0
80105de5:	e8 26 ed ff ff       	call   80104b10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ded:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105df0:	8b 1d e0 6c 12 80    	mov    0x80126ce0,%ebx
  while(ticks - ticks0 < n){
80105df6:	85 d2                	test   %edx,%edx
80105df8:	75 27                	jne    80105e21 <sys_sleep+0x61>
80105dfa:	eb 54                	jmp    80105e50 <sys_sleep+0x90>
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e00:	83 ec 08             	sub    $0x8,%esp
80105e03:	68 a0 64 12 80       	push   $0x801264a0
80105e08:	68 e0 6c 12 80       	push   $0x80126ce0
80105e0d:	e8 6e e6 ff ff       	call   80104480 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e12:	a1 e0 6c 12 80       	mov    0x80126ce0,%eax
80105e17:	83 c4 10             	add    $0x10,%esp
80105e1a:	29 d8                	sub    %ebx,%eax
80105e1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e1f:	73 2f                	jae    80105e50 <sys_sleep+0x90>
    if(myproc()->killed){
80105e21:	e8 6a de ff ff       	call   80103c90 <myproc>
80105e26:	8b 40 24             	mov    0x24(%eax),%eax
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	74 d3                	je     80105e00 <sys_sleep+0x40>
      release(&tickslock);
80105e2d:	83 ec 0c             	sub    $0xc,%esp
80105e30:	68 a0 64 12 80       	push   $0x801264a0
80105e35:	e8 f6 ed ff ff       	call   80104c30 <release>
      return -1;
80105e3a:	83 c4 10             	add    $0x10,%esp
80105e3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105e42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e45:	c9                   	leave  
80105e46:	c3                   	ret    
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	68 a0 64 12 80       	push   $0x801264a0
80105e58:	e8 d3 ed ff ff       	call   80104c30 <release>
  return 0;
80105e5d:	83 c4 10             	add    $0x10,%esp
80105e60:	31 c0                	xor    %eax,%eax
}
80105e62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e65:	c9                   	leave  
80105e66:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105e67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6c:	eb d4                	jmp    80105e42 <sys_sleep+0x82>
80105e6e:	66 90                	xchg   %ax,%ax

80105e70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	53                   	push   %ebx
80105e74:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105e77:	68 a0 64 12 80       	push   $0x801264a0
80105e7c:	e8 8f ec ff ff       	call   80104b10 <acquire>
  xticks = ticks;
80105e81:	8b 1d e0 6c 12 80    	mov    0x80126ce0,%ebx
  release(&tickslock);
80105e87:	c7 04 24 a0 64 12 80 	movl   $0x801264a0,(%esp)
80105e8e:	e8 9d ed ff ff       	call   80104c30 <release>
  return xticks;
}
80105e93:	89 d8                	mov    %ebx,%eax
80105e95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e98:	c9                   	leave  
80105e99:	c3                   	ret    

80105e9a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e9a:	1e                   	push   %ds
  pushl %es
80105e9b:	06                   	push   %es
  pushl %fs
80105e9c:	0f a0                	push   %fs
  pushl %gs
80105e9e:	0f a8                	push   %gs
  pushal
80105ea0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ea1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ea5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ea7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ea9:	54                   	push   %esp
  call trap
80105eaa:	e8 e1 00 00 00       	call   80105f90 <trap>
  addl $4, %esp
80105eaf:	83 c4 04             	add    $0x4,%esp

80105eb2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105eb2:	61                   	popa   
  popl %gs
80105eb3:	0f a9                	pop    %gs
  popl %fs
80105eb5:	0f a1                	pop    %fs
  popl %es
80105eb7:	07                   	pop    %es
  popl %ds
80105eb8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105eb9:	83 c4 08             	add    $0x8,%esp
  iret
80105ebc:	cf                   	iret   
80105ebd:	66 90                	xchg   %ax,%ax
80105ebf:	90                   	nop

80105ec0 <tvinit>:

void
tvinit(void) {
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105ec0:	31 c0                	xor    %eax,%eax
80105ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ec8:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105ecf:	b9 08 00 00 00       	mov    $0x8,%ecx
80105ed4:	c6 04 c5 e4 64 12 80 	movb   $0x0,-0x7fed9b1c(,%eax,8)
80105edb:	00 
80105edc:	66 89 0c c5 e2 64 12 	mov    %cx,-0x7fed9b1e(,%eax,8)
80105ee3:	80 
80105ee4:	c6 04 c5 e5 64 12 80 	movb   $0x8e,-0x7fed9b1b(,%eax,8)
80105eeb:	8e 
80105eec:	66 89 14 c5 e0 64 12 	mov    %dx,-0x7fed9b20(,%eax,8)
80105ef3:	80 
80105ef4:	c1 ea 10             	shr    $0x10,%edx
80105ef7:	66 89 14 c5 e6 64 12 	mov    %dx,-0x7fed9b1a(,%eax,8)
80105efe:	80 
80105eff:	83 c0 01             	add    $0x1,%eax
80105f02:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f07:	75 bf                	jne    80105ec8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks, virtualAddr, problematicPage;
struct proc *p;

void
tvinit(void) {
80105f09:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105f0a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks, virtualAddr, problematicPage;
struct proc *p;

void
tvinit(void) {
80105f0f:	89 e5                	mov    %esp,%ebp
80105f11:	83 ec 10             	sub    $0x10,%esp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105f14:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

    initlock(&tickslock, "time");
80105f19:	68 39 85 10 80       	push   $0x80108539
80105f1e:	68 a0 64 12 80       	push   $0x801264a0
void
tvinit(void) {
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105f23:	66 89 15 e2 66 12 80 	mov    %dx,0x801266e2
80105f2a:	c6 05 e4 66 12 80 00 	movb   $0x0,0x801266e4
80105f31:	66 a3 e0 66 12 80    	mov    %ax,0x801266e0
80105f37:	c1 e8 10             	shr    $0x10,%eax
80105f3a:	c6 05 e5 66 12 80 ef 	movb   $0xef,0x801266e5
80105f41:	66 a3 e6 66 12 80    	mov    %ax,0x801266e6

    initlock(&tickslock, "time");
80105f47:	e8 c4 ea ff ff       	call   80104a10 <initlock>
}
80105f4c:	83 c4 10             	add    $0x10,%esp
80105f4f:	c9                   	leave  
80105f50:	c3                   	ret    
80105f51:	eb 0d                	jmp    80105f60 <idtinit>
80105f53:	90                   	nop
80105f54:	90                   	nop
80105f55:	90                   	nop
80105f56:	90                   	nop
80105f57:	90                   	nop
80105f58:	90                   	nop
80105f59:	90                   	nop
80105f5a:	90                   	nop
80105f5b:	90                   	nop
80105f5c:	90                   	nop
80105f5d:	90                   	nop
80105f5e:	90                   	nop
80105f5f:	90                   	nop

80105f60 <idtinit>:

void
idtinit(void) {
80105f60:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105f61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f66:	89 e5                	mov    %esp,%ebp
80105f68:	83 ec 10             	sub    $0x10,%esp
80105f6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f6f:	b8 e0 64 12 80       	mov    $0x801264e0,%eax
80105f74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f78:	c1 e8 10             	shr    $0x10,%eax
80105f7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105f7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f82:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80105f85:	c9                   	leave  
80105f86:	c3                   	ret    
80105f87:	89 f6                	mov    %esi,%esi
80105f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	57                   	push   %edi
80105f94:	56                   	push   %esi
80105f95:	53                   	push   %ebx
80105f96:	83 ec 1c             	sub    $0x1c,%esp
80105f99:	8b 75 08             	mov    0x8(%ebp),%esi
    if (tf->trapno == T_SYSCALL) {
80105f9c:	8b 46 30             	mov    0x30(%esi),%eax
80105f9f:	83 f8 40             	cmp    $0x40,%eax
80105fa2:	0f 84 98 02 00 00    	je     80106240 <trap+0x2b0>
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
80105fa8:	83 e8 0e             	sub    $0xe,%eax
80105fab:	83 f8 31             	cmp    $0x31,%eax
80105fae:	0f 87 cc 02 00 00    	ja     80106280 <trap+0x2f0>
80105fb4:	ff 24 85 a8 86 10 80 	jmp    *-0x7fef7958(,%eax,4)
80105fbb:	90                   	nop
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            break;

            //CASE TRAP 14 PGFLT IF IN SWITCH FILE: BRING FROM THERE, ELSE GO DEFAULT
#if (defined(SCFIFO) || defined(LIFO))
        case T_PGFLT:
            p = myproc();
80105fc0:	e8 cb dc ff ff       	call   80103c90 <myproc>
80105fc5:	a3 80 64 12 80       	mov    %eax,0x80126480

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105fca:	0f 20 d2             	mov    %cr2,%edx
            pte_t *currPTE;

            virtualAddr = rcr2();
            problematicPage = PGROUNDDOWN(virtualAddr);
            //first we need to check if page is in swap
            for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++)
80105fcd:	31 ff                	xor    %edi,%edi
            struct page *cg = 0;
            int i;
            char *newAddr;
            pte_t *currPTE;

            virtualAddr = rcr2();
80105fcf:	89 15 e4 6c 12 80    	mov    %edx,0x80126ce4
            problematicPage = PGROUNDDOWN(virtualAddr);
80105fd5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
            //first we need to check if page is in swap
            for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++)
80105fdb:	39 90 98 00 00 00    	cmp    %edx,0x98(%eax)
            int i;
            char *newAddr;
            pte_t *currPTE;

            virtualAddr = rcr2();
            problematicPage = PGROUNDDOWN(virtualAddr);
80105fe1:	89 15 84 64 12 80    	mov    %edx,0x80126484
            //first we need to check if page is in swap
            for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++)
80105fe7:	8d 98 80 00 00 00    	lea    0x80(%eax),%ebx
80105fed:	8d 88 00 04 00 00    	lea    0x400(%eax),%ecx
80105ff3:	75 10                	jne    80106005 <trap+0x75>
80105ff5:	eb 18                	jmp    8010600f <trap+0x7f>
80105ff7:	89 f6                	mov    %esi,%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106000:	39 53 18             	cmp    %edx,0x18(%ebx)
80106003:	74 0a                	je     8010600f <trap+0x7f>
80106005:	83 c3 1c             	add    $0x1c,%ebx
80106008:	83 c7 01             	add    $0x1,%edi
8010600b:	39 cb                	cmp    %ecx,%ebx
8010600d:	72 f1                	jb     80106000 <trap+0x70>
                ;
            if (cg == &p->pages[MAX_TOTAL_PAGES]) { //if true -didn't find the addr -error
8010600f:	39 d9                	cmp    %ebx,%ecx
80106011:	0f 84 ae 03 00 00    	je     801063c5 <trap+0x435>
                panic("Error- didn't find the trap's page in T_PGFLT\n");
            }

            //must update page faults for proc.
            p->pageFaults++;
80106017:	83 80 54 04 00 00 01 	addl   $0x1,0x454(%eax)

            //Got here - cg is the page that is in swapFile; i is its location in array
            //Now- check if all 16 pages are in RAM

            //TODO = check if page is in secondary memory
            if (!cg->active || cg->present) {
8010601e:	8b 0b                	mov    (%ebx),%ecx
80106020:	85 c9                	test   %ecx,%ecx
80106022:	0f 84 d0 02 00 00    	je     801062f8 <trap+0x368>
80106028:	8b 53 0c             	mov    0xc(%ebx),%edx
8010602b:	85 d2                	test   %edx,%edx
8010602d:	0f 85 dd 02 00 00    	jne    80106310 <trap+0x380>
                if(cg->present)
                    panic("Error - problematic page is present!\n");
                panic("Error - problematic page is not active!\n");
            }

            if ((p->pagesCounter - p->pagesinSwap) >= 16) {
80106033:	8b 90 44 04 00 00    	mov    0x444(%eax),%edx
80106039:	2b 90 48 04 00 00    	sub    0x448(%eax),%edx
8010603f:	83 fa 0f             	cmp    $0xf,%edx
80106042:	0f 8f 1c 03 00 00    	jg     80106364 <trap+0x3d4>
                swapOutPage(p, p->pgdir); //func in vm.c - same use in allocuvm
            }

            //got here - there is a room for a new page

            if ((newAddr = kalloc()) == 0) {
80106048:	e8 83 c8 ff ff       	call   801028d0 <kalloc>
8010604d:	85 c0                	test   %eax,%eax
8010604f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106052:	0f 84 20 03 00 00    	je     80106378 <trap+0x3e8>
                cprintf("Error- kalloc in T_PGFLT\n");
                break;
            }

            memset(newAddr, 0, PGSIZE); //clean the page
80106058:	83 ec 04             	sub    $0x4,%esp
8010605b:	68 00 10 00 00       	push   $0x1000
80106060:	6a 00                	push   $0x0
80106062:	ff 75 e4             	pushl  -0x1c(%ebp)
80106065:	e8 16 ec ff ff       	call   80104c80 <memset>

            //bring page from swapFile
            if (readFromSwapFile(p, newAddr, cg->offset, PGSIZE) == -1)
8010606a:	68 00 10 00 00       	push   $0x1000
8010606f:	ff 73 10             	pushl  0x10(%ebx)
80106072:	ff 75 e4             	pushl  -0x1c(%ebp)
80106075:	ff 35 80 64 12 80    	pushl  0x80126480
8010607b:	e8 20 c2 ff ff       	call   801022a0 <readFromSwapFile>
80106080:	83 c4 20             	add    $0x20,%esp
80106083:	83 f8 ff             	cmp    $0xffffffff,%eax
80106086:	0f 84 2c 03 00 00    	je     801063b8 <trap+0x428>
                panic("error - read from swapfile in T_PGFLT");

            currPTE = walkpgdir2(p->pgdir, (void *) virtualAddr, 0);
8010608c:	a1 80 64 12 80       	mov    0x80126480,%eax
80106091:	83 ec 04             	sub    $0x4,%esp
80106094:	6a 00                	push   $0x0
80106096:	ff 35 e4 6c 12 80    	pushl  0x80126ce4
8010609c:	ff 70 04             	pushl  0x4(%eax)
8010609f:	e8 4c 11 00 00       	call   801071f0 <walkpgdir2>
801060a4:	89 c2                	mov    %eax,%edx
            //update flags - in page, not yet in RAM
            *currPTE = PTE_P_0(*currPTE);
            *currPTE = PTE_PG_1(*currPTE);
801060a6:	8b 00                	mov    (%eax),%eax
801060a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
801060ab:	83 e0 fe             	and    $0xfffffffe,%eax
801060ae:	80 cc 02             	or     $0x2,%ah
801060b1:	89 02                	mov    %eax,(%edx)

            mappages2(p->pgdir, (void *) problematicPage, PGSIZE, V2P(newAddr), PTE_U | PTE_W);
801060b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060b6:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801060bd:	05 00 00 00 80       	add    $0x80000000,%eax
801060c2:	50                   	push   %eax
801060c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060c6:	a1 80 64 12 80       	mov    0x80126480,%eax
801060cb:	68 00 10 00 00       	push   $0x1000
801060d0:	ff 35 84 64 12 80    	pushl  0x80126484
801060d6:	ff 70 04             	pushl  0x4(%eax)
801060d9:	e8 32 11 00 00       	call   80107210 <mappages2>
            //update flags - if got here the page is in RAM!
            *currPTE = PTE_P_1(*currPTE);
            *currPTE = PTE_PG_0(*currPTE);
801060de:	8b 55 dc             	mov    -0x24(%ebp),%edx
            //update proc
            p->swapFileEntries[i] = 0; //clean entry- page is in RAM
//            p->pagesCounter++;
            p->pagesinSwap--;

            lapiceoi();
801060e1:	83 c4 20             	add    $0x20,%esp
            *currPTE = PTE_PG_1(*currPTE);

            mappages2(p->pgdir, (void *) problematicPage, PGSIZE, V2P(newAddr), PTE_U | PTE_W);
            //update flags - if got here the page is in RAM!
            *currPTE = PTE_P_1(*currPTE);
            *currPTE = PTE_PG_0(*currPTE);
801060e4:	8b 0a                	mov    (%edx),%ecx
801060e6:	80 e5 fd             	and    $0xfd,%ch
801060e9:	89 c8                	mov    %ecx,%eax
801060eb:	83 c8 01             	or     $0x1,%eax
801060ee:	89 02                	mov    %eax,(%edx)

            //update page
            cg->offset = 0;
            cg->virtAdress = newAddr;
            cg->active = 1;
801060f0:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
            *currPTE = PTE_P_1(*currPTE);
            *currPTE = PTE_PG_0(*currPTE);

            //update page
            cg->offset = 0;
            cg->virtAdress = newAddr;
801060f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            cg->active = 1;
            cg->present = 1;
            cg->sequel = p->pagesequel++;
801060f9:	a1 80 64 12 80       	mov    0x80126480,%eax
            //update flags - if got here the page is in RAM!
            *currPTE = PTE_P_1(*currPTE);
            *currPTE = PTE_PG_0(*currPTE);

            //update page
            cg->offset = 0;
801060fe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
            cg->virtAdress = newAddr;
            cg->active = 1;
            cg->present = 1;
80106105:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
            *currPTE = PTE_P_1(*currPTE);
            *currPTE = PTE_PG_0(*currPTE);

            //update page
            cg->offset = 0;
            cg->virtAdress = newAddr;
8010610c:	89 53 18             	mov    %edx,0x18(%ebx)
            cg->active = 1;
            cg->present = 1;
            cg->sequel = p->pagesequel++;
8010610f:	8b 90 4c 04 00 00    	mov    0x44c(%eax),%edx
80106115:	8d 4a 01             	lea    0x1(%edx),%ecx
80106118:	89 88 4c 04 00 00    	mov    %ecx,0x44c(%eax)
            //TODO
            cg->physAdress = (char *) V2P(newAddr);
8010611e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
            //update page
            cg->offset = 0;
            cg->virtAdress = newAddr;
            cg->active = 1;
            cg->present = 1;
            cg->sequel = p->pagesequel++;
80106121:	89 53 08             	mov    %edx,0x8(%ebx)
            //TODO
            cg->physAdress = (char *) V2P(newAddr);
80106124:	89 4b 14             	mov    %ecx,0x14(%ebx)

            //update proc
            p->swapFileEntries[i] = 0; //clean entry- page is in RAM
80106127:	c7 84 b8 00 04 00 00 	movl   $0x0,0x400(%eax,%edi,4)
8010612e:	00 00 00 00 
//            p->pagesCounter++;
            p->pagesinSwap--;
80106132:	83 a8 48 04 00 00 01 	subl   $0x1,0x448(%eax)

            lapiceoi();
80106139:	e8 12 ca ff ff       	call   80102b50 <lapiceoi>
8010613e:	66 90                	xchg   %ax,%ax
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106140:	e8 4b db ff ff       	call   80103c90 <myproc>
80106145:	85 c0                	test   %eax,%eax
80106147:	74 0c                	je     80106155 <trap+0x1c5>
80106149:	e8 42 db ff ff       	call   80103c90 <myproc>
8010614e:	8b 50 24             	mov    0x24(%eax),%edx
80106151:	85 d2                	test   %edx,%edx
80106153:	75 4b                	jne    801061a0 <trap+0x210>
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80106155:	e8 36 db ff ff       	call   80103c90 <myproc>
8010615a:	85 c0                	test   %eax,%eax
8010615c:	74 0b                	je     80106169 <trap+0x1d9>
8010615e:	e8 2d db ff ff       	call   80103c90 <myproc>
80106163:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106167:	74 4f                	je     801061b8 <trap+0x228>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106169:	e8 22 db ff ff       	call   80103c90 <myproc>
8010616e:	85 c0                	test   %eax,%eax
80106170:	74 1d                	je     8010618f <trap+0x1ff>
80106172:	e8 19 db ff ff       	call   80103c90 <myproc>
80106177:	8b 40 24             	mov    0x24(%eax),%eax
8010617a:	85 c0                	test   %eax,%eax
8010617c:	74 11                	je     8010618f <trap+0x1ff>
8010617e:	0f b7 46 3c          	movzwl 0x3c(%esi),%eax
80106182:	83 e0 03             	and    $0x3,%eax
80106185:	66 83 f8 03          	cmp    $0x3,%ax
80106189:	0f 84 de 00 00 00    	je     8010626d <trap+0x2dd>
        exit();
}
8010618f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106192:	5b                   	pop    %ebx
80106193:	5e                   	pop    %esi
80106194:	5f                   	pop    %edi
80106195:	5d                   	pop    %ebp
80106196:	c3                   	ret    
80106197:	89 f6                	mov    %esi,%esi
80106199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801061a0:	0f b7 46 3c          	movzwl 0x3c(%esi),%eax
801061a4:	83 e0 03             	and    $0x3,%eax
801061a7:	66 83 f8 03          	cmp    $0x3,%ax
801061ab:	75 a8                	jne    80106155 <trap+0x1c5>
        exit();
801061ad:	e8 2e e1 ff ff       	call   801042e0 <exit>
801061b2:	eb a1                	jmp    80106155 <trap+0x1c5>
801061b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
801061b8:	83 7e 30 20          	cmpl   $0x20,0x30(%esi)
801061bc:	75 ab                	jne    80106169 <trap+0x1d9>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();
801061be:	e8 6d e2 ff ff       	call   80104430 <yield>
801061c3:	eb a4                	jmp    80106169 <trap+0x1d9>
801061c5:	8d 76 00             	lea    0x0(%esi),%esi
        return;
    }

    switch (tf->trapno) {
        case T_IRQ0 + IRQ_TIMER:
            if (cpuid() == 0) {
801061c8:	e8 a3 da ff ff       	call   80103c70 <cpuid>
801061cd:	85 c0                	test   %eax,%eax
801061cf:	0f 84 5b 01 00 00    	je     80106330 <trap+0x3a0>
            }
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE:
            ideintr();
            lapiceoi();
801061d5:	e8 76 c9 ff ff       	call   80102b50 <lapiceoi>
            break;
801061da:	e9 61 ff ff ff       	jmp    80106140 <trap+0x1b0>
801061df:	90                   	nop
        case T_IRQ0 + IRQ_IDE + 1:
            // Bochs generates spurious IDE1 interrupts.
            break;
        case T_IRQ0 + IRQ_KBD:
            kbdintr();
801061e0:	e8 2b c8 ff ff       	call   80102a10 <kbdintr>
            lapiceoi();
801061e5:	e8 66 c9 ff ff       	call   80102b50 <lapiceoi>
            break;
801061ea:	e9 51 ff ff ff       	jmp    80106140 <trap+0x1b0>
801061ef:	90                   	nop
        case T_IRQ0 + IRQ_COM1:
            uartintr();
801061f0:	e8 5b 03 00 00       	call   80106550 <uartintr>
            lapiceoi();
801061f5:	e8 56 c9 ff ff       	call   80102b50 <lapiceoi>
            break;
801061fa:	e9 41 ff ff ff       	jmp    80106140 <trap+0x1b0>
801061ff:	90                   	nop
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106200:	0f b7 5e 3c          	movzwl 0x3c(%esi),%ebx
80106204:	8b 7e 38             	mov    0x38(%esi),%edi
80106207:	e8 64 da ff ff       	call   80103c70 <cpuid>
8010620c:	57                   	push   %edi
8010620d:	53                   	push   %ebx
8010620e:	50                   	push   %eax
8010620f:	68 60 85 10 80       	push   $0x80108560
80106214:	e8 47 a4 ff ff       	call   80100660 <cprintf>
                    cpuid(), tf->cs, tf->eip);
            lapiceoi();
80106219:	e8 32 c9 ff ff       	call   80102b50 <lapiceoi>
            break;
8010621e:	83 c4 10             	add    $0x10,%esp
80106221:	e9 1a ff ff ff       	jmp    80106140 <trap+0x1b0>
80106226:	8d 76 00             	lea    0x0(%esi),%esi
80106229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                release(&tickslock);
            }
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE:
            ideintr();
80106230:	e8 eb c1 ff ff       	call   80102420 <ideintr>
80106235:	eb 9e                	jmp    801061d5 <trap+0x245>
80106237:	89 f6                	mov    %esi,%esi
80106239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
    if (tf->trapno == T_SYSCALL) {
        if (myproc()->killed)
80106240:	e8 4b da ff ff       	call   80103c90 <myproc>
80106245:	8b 78 24             	mov    0x24(%eax),%edi
80106248:	85 ff                	test   %edi,%edi
8010624a:	0f 85 d0 00 00 00    	jne    80106320 <trap+0x390>
            exit();
        myproc()->tf = tf;
80106250:	e8 3b da ff ff       	call   80103c90 <myproc>
80106255:	89 70 18             	mov    %esi,0x18(%eax)
        syscall();
80106258:	e8 23 ee ff ff       	call   80105080 <syscall>
        if (myproc()->killed)
8010625d:	e8 2e da ff ff       	call   80103c90 <myproc>
80106262:	8b 58 24             	mov    0x24(%eax),%ebx
80106265:	85 db                	test   %ebx,%ebx
80106267:	0f 84 22 ff ff ff    	je     8010618f <trap+0x1ff>
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();
}
8010626d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106270:	5b                   	pop    %ebx
80106271:	5e                   	pop    %esi
80106272:	5f                   	pop    %edi
80106273:	5d                   	pop    %ebp
        if (myproc()->killed)
            exit();
        myproc()->tf = tf;
        syscall();
        if (myproc()->killed)
            exit();
80106274:	e9 67 e0 ff ff       	jmp    801042e0 <exit>
80106279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
#endif


            //PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80106280:	e8 0b da ff ff       	call   80103c90 <myproc>
80106285:	85 c0                	test   %eax,%eax
80106287:	0f 84 00 01 00 00    	je     8010638d <trap+0x3fd>
8010628d:	f6 46 3c 03          	testb  $0x3,0x3c(%esi)
80106291:	0f 84 f6 00 00 00    	je     8010638d <trap+0x3fd>
80106297:	0f 20 d1             	mov    %cr2,%ecx
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
8010629a:	8b 56 38             	mov    0x38(%esi),%edx
8010629d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801062a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801062a3:	e8 c8 d9 ff ff       	call   80103c70 <cpuid>
801062a8:	89 c7                	mov    %eax,%edi
801062aa:	8b 46 34             	mov    0x34(%esi),%eax
801062ad:	8b 5e 30             	mov    0x30(%esi),%ebx
801062b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
801062b3:	e8 d8 d9 ff ff       	call   80103c90 <myproc>
801062b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062bb:	e8 d0 d9 ff ff       	call   80103c90 <myproc>
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801062c0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801062c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801062c6:	51                   	push   %ecx
801062c7:	52                   	push   %edx
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
801062c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801062cb:	57                   	push   %edi
801062cc:	ff 75 e4             	pushl  -0x1c(%ebp)
801062cf:	53                   	push   %ebx
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
801062d0:	83 c2 6c             	add    $0x6c,%edx
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801062d3:	52                   	push   %edx
801062d4:	ff 70 10             	pushl  0x10(%eax)
801062d7:	68 64 86 10 80       	push   $0x80108664
801062dc:	e8 7f a3 ff ff       	call   80100660 <cprintf>
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
801062e1:	83 c4 20             	add    $0x20,%esp
801062e4:	e8 a7 d9 ff ff       	call   80103c90 <myproc>
801062e9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801062f0:	e9 4b fe ff ff       	jmp    80106140 <trap+0x1b0>
801062f5:	8d 76 00             	lea    0x0(%esi),%esi
            //Got here - cg is the page that is in swapFile; i is its location in array
            //Now- check if all 16 pages are in RAM

            //TODO = check if page is in secondary memory
            if (!cg->active || cg->present) {
                if(cg->present)
801062f8:	8b 4b 0c             	mov    0xc(%ebx),%ecx
801062fb:	85 c9                	test   %ecx,%ecx
801062fd:	75 11                	jne    80106310 <trap+0x380>
                    panic("Error - problematic page is present!\n");
                panic("Error - problematic page is not active!\n");
801062ff:	83 ec 0c             	sub    $0xc,%esp
80106302:	68 dc 85 10 80       	push   $0x801085dc
80106307:	e8 64 a0 ff ff       	call   80100370 <panic>
8010630c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            //Now- check if all 16 pages are in RAM

            //TODO = check if page is in secondary memory
            if (!cg->active || cg->present) {
                if(cg->present)
                    panic("Error - problematic page is present!\n");
80106310:	83 ec 0c             	sub    $0xc,%esp
80106313:	68 b4 85 10 80       	push   $0x801085b4
80106318:	e8 53 a0 ff ff       	call   80100370 <panic>
8010631d:	8d 76 00             	lea    0x0(%esi),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
    if (tf->trapno == T_SYSCALL) {
        if (myproc()->killed)
            exit();
80106320:	e8 bb df ff ff       	call   801042e0 <exit>
80106325:	e9 26 ff ff ff       	jmp    80106250 <trap+0x2c0>
8010632a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }

    switch (tf->trapno) {
        case T_IRQ0 + IRQ_TIMER:
            if (cpuid() == 0) {
                acquire(&tickslock);
80106330:	83 ec 0c             	sub    $0xc,%esp
80106333:	68 a0 64 12 80       	push   $0x801264a0
80106338:	e8 d3 e7 ff ff       	call   80104b10 <acquire>
                ticks++;
                wakeup(&ticks);
8010633d:	c7 04 24 e0 6c 12 80 	movl   $0x80126ce0,(%esp)

    switch (tf->trapno) {
        case T_IRQ0 + IRQ_TIMER:
            if (cpuid() == 0) {
                acquire(&tickslock);
                ticks++;
80106344:	83 05 e0 6c 12 80 01 	addl   $0x1,0x80126ce0
                wakeup(&ticks);
8010634b:	e8 a0 e3 ff ff       	call   801046f0 <wakeup>
                release(&tickslock);
80106350:	c7 04 24 a0 64 12 80 	movl   $0x801264a0,(%esp)
80106357:	e8 d4 e8 ff ff       	call   80104c30 <release>
8010635c:	83 c4 10             	add    $0x10,%esp
8010635f:	e9 71 fe ff ff       	jmp    801061d5 <trap+0x245>
                panic("Error - problematic page is not active!\n");
            }

            if ((p->pagesCounter - p->pagesinSwap) >= 16) {
                //if true - there is no room for another page- need to swap out
                swapOutPage(p, p->pgdir); //func in vm.c - same use in allocuvm
80106364:	83 ec 08             	sub    $0x8,%esp
80106367:	ff 70 04             	pushl  0x4(%eax)
8010636a:	50                   	push   %eax
8010636b:	e8 60 11 00 00       	call   801074d0 <swapOutPage>
80106370:	83 c4 10             	add    $0x10,%esp
80106373:	e9 d0 fc ff ff       	jmp    80106048 <trap+0xb8>
            }

            //got here - there is a room for a new page

            if ((newAddr = kalloc()) == 0) {
                cprintf("Error- kalloc in T_PGFLT\n");
80106378:	83 ec 0c             	sub    $0xc,%esp
8010637b:	68 3e 85 10 80       	push   $0x8010853e
80106380:	e8 db a2 ff ff       	call   80100660 <cprintf>
                break;
80106385:	83 c4 10             	add    $0x10,%esp
80106388:	e9 b3 fd ff ff       	jmp    80106140 <trap+0x1b0>
8010638d:	0f 20 d7             	mov    %cr2,%edi

            //PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
                // In kernel, it must be our mistake.
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106390:	8b 5e 38             	mov    0x38(%esi),%ebx
80106393:	e8 d8 d8 ff ff       	call   80103c70 <cpuid>
80106398:	83 ec 0c             	sub    $0xc,%esp
8010639b:	57                   	push   %edi
8010639c:	53                   	push   %ebx
8010639d:	50                   	push   %eax
8010639e:	ff 76 30             	pushl  0x30(%esi)
801063a1:	68 30 86 10 80       	push   $0x80108630
801063a6:	e8 b5 a2 ff ff       	call   80100660 <cprintf>
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
801063ab:	83 c4 14             	add    $0x14,%esp
801063ae:	68 58 85 10 80       	push   $0x80108558
801063b3:	e8 b8 9f ff ff       	call   80100370 <panic>

            memset(newAddr, 0, PGSIZE); //clean the page

            //bring page from swapFile
            if (readFromSwapFile(p, newAddr, cg->offset, PGSIZE) == -1)
                panic("error - read from swapfile in T_PGFLT");
801063b8:	83 ec 0c             	sub    $0xc,%esp
801063bb:	68 08 86 10 80       	push   $0x80108608
801063c0:	e8 ab 9f ff ff       	call   80100370 <panic>
            problematicPage = PGROUNDDOWN(virtualAddr);
            //first we need to check if page is in swap
            for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++)
                ;
            if (cg == &p->pages[MAX_TOTAL_PAGES]) { //if true -didn't find the addr -error
                panic("Error- didn't find the trap's page in T_PGFLT\n");
801063c5:	83 ec 0c             	sub    $0xc,%esp
801063c8:	68 84 85 10 80       	push   $0x80108584
801063cd:	e8 9e 9f ff ff       	call   80100370 <panic>
801063d2:	66 90                	xchg   %ax,%ax
801063d4:	66 90                	xchg   %ax,%ax
801063d6:	66 90                	xchg   %ax,%ax
801063d8:	66 90                	xchg   %ax,%ax
801063da:	66 90                	xchg   %ax,%ax
801063dc:	66 90                	xchg   %ax,%ax
801063de:	66 90                	xchg   %ax,%ax

801063e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801063e0:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801063e5:	55                   	push   %ebp
801063e6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801063e8:	85 c0                	test   %eax,%eax
801063ea:	74 1c                	je     80106408 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063ec:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063f1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801063f2:	a8 01                	test   $0x1,%al
801063f4:	74 12                	je     80106408 <uartgetc+0x28>
801063f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063fb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801063fc:	0f b6 c0             	movzbl %al,%eax
}
801063ff:	5d                   	pop    %ebp
80106400:	c3                   	ret    
80106401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010640d:	5d                   	pop    %ebp
8010640e:	c3                   	ret    
8010640f:	90                   	nop

80106410 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	57                   	push   %edi
80106414:	56                   	push   %esi
80106415:	53                   	push   %ebx
80106416:	89 c7                	mov    %eax,%edi
80106418:	bb 80 00 00 00       	mov    $0x80,%ebx
8010641d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106422:	83 ec 0c             	sub    $0xc,%esp
80106425:	eb 1b                	jmp    80106442 <uartputc.part.0+0x32>
80106427:	89 f6                	mov    %esi,%esi
80106429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106430:	83 ec 0c             	sub    $0xc,%esp
80106433:	6a 0a                	push   $0xa
80106435:	e8 36 c7 ff ff       	call   80102b70 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010643a:	83 c4 10             	add    $0x10,%esp
8010643d:	83 eb 01             	sub    $0x1,%ebx
80106440:	74 07                	je     80106449 <uartputc.part.0+0x39>
80106442:	89 f2                	mov    %esi,%edx
80106444:	ec                   	in     (%dx),%al
80106445:	a8 20                	test   $0x20,%al
80106447:	74 e7                	je     80106430 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106449:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010644e:	89 f8                	mov    %edi,%eax
80106450:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106454:	5b                   	pop    %ebx
80106455:	5e                   	pop    %esi
80106456:	5f                   	pop    %edi
80106457:	5d                   	pop    %ebp
80106458:	c3                   	ret    
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106460 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106460:	55                   	push   %ebp
80106461:	31 c9                	xor    %ecx,%ecx
80106463:	89 c8                	mov    %ecx,%eax
80106465:	89 e5                	mov    %esp,%ebp
80106467:	57                   	push   %edi
80106468:	56                   	push   %esi
80106469:	53                   	push   %ebx
8010646a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010646f:	89 da                	mov    %ebx,%edx
80106471:	83 ec 0c             	sub    $0xc,%esp
80106474:	ee                   	out    %al,(%dx)
80106475:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010647a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010647f:	89 fa                	mov    %edi,%edx
80106481:	ee                   	out    %al,(%dx)
80106482:	b8 0c 00 00 00       	mov    $0xc,%eax
80106487:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010648c:	ee                   	out    %al,(%dx)
8010648d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106492:	89 c8                	mov    %ecx,%eax
80106494:	89 f2                	mov    %esi,%edx
80106496:	ee                   	out    %al,(%dx)
80106497:	b8 03 00 00 00       	mov    $0x3,%eax
8010649c:	89 fa                	mov    %edi,%edx
8010649e:	ee                   	out    %al,(%dx)
8010649f:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064a4:	89 c8                	mov    %ecx,%eax
801064a6:	ee                   	out    %al,(%dx)
801064a7:	b8 01 00 00 00       	mov    $0x1,%eax
801064ac:	89 f2                	mov    %esi,%edx
801064ae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064af:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064b4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801064b5:	3c ff                	cmp    $0xff,%al
801064b7:	74 5a                	je     80106513 <uartinit+0xb3>
    return;
  uart = 1;
801064b9:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801064c0:	00 00 00 
801064c3:	89 da                	mov    %ebx,%edx
801064c5:	ec                   	in     (%dx),%al
801064c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064cb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801064cc:	83 ec 08             	sub    $0x8,%esp
801064cf:	bb 70 87 10 80       	mov    $0x80108770,%ebx
801064d4:	6a 00                	push   $0x0
801064d6:	6a 04                	push   $0x4
801064d8:	e8 93 c1 ff ff       	call   80102670 <ioapicenable>
801064dd:	83 c4 10             	add    $0x10,%esp
801064e0:	b8 78 00 00 00       	mov    $0x78,%eax
801064e5:	eb 13                	jmp    801064fa <uartinit+0x9a>
801064e7:	89 f6                	mov    %esi,%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801064f0:	83 c3 01             	add    $0x1,%ebx
801064f3:	0f be 03             	movsbl (%ebx),%eax
801064f6:	84 c0                	test   %al,%al
801064f8:	74 19                	je     80106513 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
801064fa:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80106500:	85 d2                	test   %edx,%edx
80106502:	74 ec                	je     801064f0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106504:	83 c3 01             	add    $0x1,%ebx
80106507:	e8 04 ff ff ff       	call   80106410 <uartputc.part.0>
8010650c:	0f be 03             	movsbl (%ebx),%eax
8010650f:	84 c0                	test   %al,%al
80106511:	75 e7                	jne    801064fa <uartinit+0x9a>
    uartputc(*p);
}
80106513:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106516:	5b                   	pop    %ebx
80106517:	5e                   	pop    %esi
80106518:	5f                   	pop    %edi
80106519:	5d                   	pop    %ebp
8010651a:	c3                   	ret    
8010651b:	90                   	nop
8010651c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106520 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106520:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106526:	55                   	push   %ebp
80106527:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106529:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010652b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010652e:	74 10                	je     80106540 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106530:	5d                   	pop    %ebp
80106531:	e9 da fe ff ff       	jmp    80106410 <uartputc.part.0>
80106536:	8d 76 00             	lea    0x0(%esi),%esi
80106539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106540:	5d                   	pop    %ebp
80106541:	c3                   	ret    
80106542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106550 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106556:	68 e0 63 10 80       	push   $0x801063e0
8010655b:	e8 90 a2 ff ff       	call   801007f0 <consoleintr>
}
80106560:	83 c4 10             	add    $0x10,%esp
80106563:	c9                   	leave  
80106564:	c3                   	ret    

80106565 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $0
80106567:	6a 00                	push   $0x0
  jmp alltraps
80106569:	e9 2c f9 ff ff       	jmp    80105e9a <alltraps>

8010656e <vector1>:
.globl vector1
vector1:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $1
80106570:	6a 01                	push   $0x1
  jmp alltraps
80106572:	e9 23 f9 ff ff       	jmp    80105e9a <alltraps>

80106577 <vector2>:
.globl vector2
vector2:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $2
80106579:	6a 02                	push   $0x2
  jmp alltraps
8010657b:	e9 1a f9 ff ff       	jmp    80105e9a <alltraps>

80106580 <vector3>:
.globl vector3
vector3:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $3
80106582:	6a 03                	push   $0x3
  jmp alltraps
80106584:	e9 11 f9 ff ff       	jmp    80105e9a <alltraps>

80106589 <vector4>:
.globl vector4
vector4:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $4
8010658b:	6a 04                	push   $0x4
  jmp alltraps
8010658d:	e9 08 f9 ff ff       	jmp    80105e9a <alltraps>

80106592 <vector5>:
.globl vector5
vector5:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $5
80106594:	6a 05                	push   $0x5
  jmp alltraps
80106596:	e9 ff f8 ff ff       	jmp    80105e9a <alltraps>

8010659b <vector6>:
.globl vector6
vector6:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $6
8010659d:	6a 06                	push   $0x6
  jmp alltraps
8010659f:	e9 f6 f8 ff ff       	jmp    80105e9a <alltraps>

801065a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $7
801065a6:	6a 07                	push   $0x7
  jmp alltraps
801065a8:	e9 ed f8 ff ff       	jmp    80105e9a <alltraps>

801065ad <vector8>:
.globl vector8
vector8:
  pushl $8
801065ad:	6a 08                	push   $0x8
  jmp alltraps
801065af:	e9 e6 f8 ff ff       	jmp    80105e9a <alltraps>

801065b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $9
801065b6:	6a 09                	push   $0x9
  jmp alltraps
801065b8:	e9 dd f8 ff ff       	jmp    80105e9a <alltraps>

801065bd <vector10>:
.globl vector10
vector10:
  pushl $10
801065bd:	6a 0a                	push   $0xa
  jmp alltraps
801065bf:	e9 d6 f8 ff ff       	jmp    80105e9a <alltraps>

801065c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801065c4:	6a 0b                	push   $0xb
  jmp alltraps
801065c6:	e9 cf f8 ff ff       	jmp    80105e9a <alltraps>

801065cb <vector12>:
.globl vector12
vector12:
  pushl $12
801065cb:	6a 0c                	push   $0xc
  jmp alltraps
801065cd:	e9 c8 f8 ff ff       	jmp    80105e9a <alltraps>

801065d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801065d2:	6a 0d                	push   $0xd
  jmp alltraps
801065d4:	e9 c1 f8 ff ff       	jmp    80105e9a <alltraps>

801065d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801065d9:	6a 0e                	push   $0xe
  jmp alltraps
801065db:	e9 ba f8 ff ff       	jmp    80105e9a <alltraps>

801065e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $15
801065e2:	6a 0f                	push   $0xf
  jmp alltraps
801065e4:	e9 b1 f8 ff ff       	jmp    80105e9a <alltraps>

801065e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $16
801065eb:	6a 10                	push   $0x10
  jmp alltraps
801065ed:	e9 a8 f8 ff ff       	jmp    80105e9a <alltraps>

801065f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801065f2:	6a 11                	push   $0x11
  jmp alltraps
801065f4:	e9 a1 f8 ff ff       	jmp    80105e9a <alltraps>

801065f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $18
801065fb:	6a 12                	push   $0x12
  jmp alltraps
801065fd:	e9 98 f8 ff ff       	jmp    80105e9a <alltraps>

80106602 <vector19>:
.globl vector19
vector19:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $19
80106604:	6a 13                	push   $0x13
  jmp alltraps
80106606:	e9 8f f8 ff ff       	jmp    80105e9a <alltraps>

8010660b <vector20>:
.globl vector20
vector20:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $20
8010660d:	6a 14                	push   $0x14
  jmp alltraps
8010660f:	e9 86 f8 ff ff       	jmp    80105e9a <alltraps>

80106614 <vector21>:
.globl vector21
vector21:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $21
80106616:	6a 15                	push   $0x15
  jmp alltraps
80106618:	e9 7d f8 ff ff       	jmp    80105e9a <alltraps>

8010661d <vector22>:
.globl vector22
vector22:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $22
8010661f:	6a 16                	push   $0x16
  jmp alltraps
80106621:	e9 74 f8 ff ff       	jmp    80105e9a <alltraps>

80106626 <vector23>:
.globl vector23
vector23:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $23
80106628:	6a 17                	push   $0x17
  jmp alltraps
8010662a:	e9 6b f8 ff ff       	jmp    80105e9a <alltraps>

8010662f <vector24>:
.globl vector24
vector24:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $24
80106631:	6a 18                	push   $0x18
  jmp alltraps
80106633:	e9 62 f8 ff ff       	jmp    80105e9a <alltraps>

80106638 <vector25>:
.globl vector25
vector25:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $25
8010663a:	6a 19                	push   $0x19
  jmp alltraps
8010663c:	e9 59 f8 ff ff       	jmp    80105e9a <alltraps>

80106641 <vector26>:
.globl vector26
vector26:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $26
80106643:	6a 1a                	push   $0x1a
  jmp alltraps
80106645:	e9 50 f8 ff ff       	jmp    80105e9a <alltraps>

8010664a <vector27>:
.globl vector27
vector27:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $27
8010664c:	6a 1b                	push   $0x1b
  jmp alltraps
8010664e:	e9 47 f8 ff ff       	jmp    80105e9a <alltraps>

80106653 <vector28>:
.globl vector28
vector28:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $28
80106655:	6a 1c                	push   $0x1c
  jmp alltraps
80106657:	e9 3e f8 ff ff       	jmp    80105e9a <alltraps>

8010665c <vector29>:
.globl vector29
vector29:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $29
8010665e:	6a 1d                	push   $0x1d
  jmp alltraps
80106660:	e9 35 f8 ff ff       	jmp    80105e9a <alltraps>

80106665 <vector30>:
.globl vector30
vector30:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $30
80106667:	6a 1e                	push   $0x1e
  jmp alltraps
80106669:	e9 2c f8 ff ff       	jmp    80105e9a <alltraps>

8010666e <vector31>:
.globl vector31
vector31:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $31
80106670:	6a 1f                	push   $0x1f
  jmp alltraps
80106672:	e9 23 f8 ff ff       	jmp    80105e9a <alltraps>

80106677 <vector32>:
.globl vector32
vector32:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $32
80106679:	6a 20                	push   $0x20
  jmp alltraps
8010667b:	e9 1a f8 ff ff       	jmp    80105e9a <alltraps>

80106680 <vector33>:
.globl vector33
vector33:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $33
80106682:	6a 21                	push   $0x21
  jmp alltraps
80106684:	e9 11 f8 ff ff       	jmp    80105e9a <alltraps>

80106689 <vector34>:
.globl vector34
vector34:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $34
8010668b:	6a 22                	push   $0x22
  jmp alltraps
8010668d:	e9 08 f8 ff ff       	jmp    80105e9a <alltraps>

80106692 <vector35>:
.globl vector35
vector35:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $35
80106694:	6a 23                	push   $0x23
  jmp alltraps
80106696:	e9 ff f7 ff ff       	jmp    80105e9a <alltraps>

8010669b <vector36>:
.globl vector36
vector36:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $36
8010669d:	6a 24                	push   $0x24
  jmp alltraps
8010669f:	e9 f6 f7 ff ff       	jmp    80105e9a <alltraps>

801066a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $37
801066a6:	6a 25                	push   $0x25
  jmp alltraps
801066a8:	e9 ed f7 ff ff       	jmp    80105e9a <alltraps>

801066ad <vector38>:
.globl vector38
vector38:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $38
801066af:	6a 26                	push   $0x26
  jmp alltraps
801066b1:	e9 e4 f7 ff ff       	jmp    80105e9a <alltraps>

801066b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $39
801066b8:	6a 27                	push   $0x27
  jmp alltraps
801066ba:	e9 db f7 ff ff       	jmp    80105e9a <alltraps>

801066bf <vector40>:
.globl vector40
vector40:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $40
801066c1:	6a 28                	push   $0x28
  jmp alltraps
801066c3:	e9 d2 f7 ff ff       	jmp    80105e9a <alltraps>

801066c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $41
801066ca:	6a 29                	push   $0x29
  jmp alltraps
801066cc:	e9 c9 f7 ff ff       	jmp    80105e9a <alltraps>

801066d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $42
801066d3:	6a 2a                	push   $0x2a
  jmp alltraps
801066d5:	e9 c0 f7 ff ff       	jmp    80105e9a <alltraps>

801066da <vector43>:
.globl vector43
vector43:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $43
801066dc:	6a 2b                	push   $0x2b
  jmp alltraps
801066de:	e9 b7 f7 ff ff       	jmp    80105e9a <alltraps>

801066e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $44
801066e5:	6a 2c                	push   $0x2c
  jmp alltraps
801066e7:	e9 ae f7 ff ff       	jmp    80105e9a <alltraps>

801066ec <vector45>:
.globl vector45
vector45:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $45
801066ee:	6a 2d                	push   $0x2d
  jmp alltraps
801066f0:	e9 a5 f7 ff ff       	jmp    80105e9a <alltraps>

801066f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $46
801066f7:	6a 2e                	push   $0x2e
  jmp alltraps
801066f9:	e9 9c f7 ff ff       	jmp    80105e9a <alltraps>

801066fe <vector47>:
.globl vector47
vector47:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $47
80106700:	6a 2f                	push   $0x2f
  jmp alltraps
80106702:	e9 93 f7 ff ff       	jmp    80105e9a <alltraps>

80106707 <vector48>:
.globl vector48
vector48:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $48
80106709:	6a 30                	push   $0x30
  jmp alltraps
8010670b:	e9 8a f7 ff ff       	jmp    80105e9a <alltraps>

80106710 <vector49>:
.globl vector49
vector49:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $49
80106712:	6a 31                	push   $0x31
  jmp alltraps
80106714:	e9 81 f7 ff ff       	jmp    80105e9a <alltraps>

80106719 <vector50>:
.globl vector50
vector50:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $50
8010671b:	6a 32                	push   $0x32
  jmp alltraps
8010671d:	e9 78 f7 ff ff       	jmp    80105e9a <alltraps>

80106722 <vector51>:
.globl vector51
vector51:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $51
80106724:	6a 33                	push   $0x33
  jmp alltraps
80106726:	e9 6f f7 ff ff       	jmp    80105e9a <alltraps>

8010672b <vector52>:
.globl vector52
vector52:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $52
8010672d:	6a 34                	push   $0x34
  jmp alltraps
8010672f:	e9 66 f7 ff ff       	jmp    80105e9a <alltraps>

80106734 <vector53>:
.globl vector53
vector53:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $53
80106736:	6a 35                	push   $0x35
  jmp alltraps
80106738:	e9 5d f7 ff ff       	jmp    80105e9a <alltraps>

8010673d <vector54>:
.globl vector54
vector54:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $54
8010673f:	6a 36                	push   $0x36
  jmp alltraps
80106741:	e9 54 f7 ff ff       	jmp    80105e9a <alltraps>

80106746 <vector55>:
.globl vector55
vector55:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $55
80106748:	6a 37                	push   $0x37
  jmp alltraps
8010674a:	e9 4b f7 ff ff       	jmp    80105e9a <alltraps>

8010674f <vector56>:
.globl vector56
vector56:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $56
80106751:	6a 38                	push   $0x38
  jmp alltraps
80106753:	e9 42 f7 ff ff       	jmp    80105e9a <alltraps>

80106758 <vector57>:
.globl vector57
vector57:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $57
8010675a:	6a 39                	push   $0x39
  jmp alltraps
8010675c:	e9 39 f7 ff ff       	jmp    80105e9a <alltraps>

80106761 <vector58>:
.globl vector58
vector58:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $58
80106763:	6a 3a                	push   $0x3a
  jmp alltraps
80106765:	e9 30 f7 ff ff       	jmp    80105e9a <alltraps>

8010676a <vector59>:
.globl vector59
vector59:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $59
8010676c:	6a 3b                	push   $0x3b
  jmp alltraps
8010676e:	e9 27 f7 ff ff       	jmp    80105e9a <alltraps>

80106773 <vector60>:
.globl vector60
vector60:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $60
80106775:	6a 3c                	push   $0x3c
  jmp alltraps
80106777:	e9 1e f7 ff ff       	jmp    80105e9a <alltraps>

8010677c <vector61>:
.globl vector61
vector61:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $61
8010677e:	6a 3d                	push   $0x3d
  jmp alltraps
80106780:	e9 15 f7 ff ff       	jmp    80105e9a <alltraps>

80106785 <vector62>:
.globl vector62
vector62:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $62
80106787:	6a 3e                	push   $0x3e
  jmp alltraps
80106789:	e9 0c f7 ff ff       	jmp    80105e9a <alltraps>

8010678e <vector63>:
.globl vector63
vector63:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $63
80106790:	6a 3f                	push   $0x3f
  jmp alltraps
80106792:	e9 03 f7 ff ff       	jmp    80105e9a <alltraps>

80106797 <vector64>:
.globl vector64
vector64:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $64
80106799:	6a 40                	push   $0x40
  jmp alltraps
8010679b:	e9 fa f6 ff ff       	jmp    80105e9a <alltraps>

801067a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $65
801067a2:	6a 41                	push   $0x41
  jmp alltraps
801067a4:	e9 f1 f6 ff ff       	jmp    80105e9a <alltraps>

801067a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $66
801067ab:	6a 42                	push   $0x42
  jmp alltraps
801067ad:	e9 e8 f6 ff ff       	jmp    80105e9a <alltraps>

801067b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $67
801067b4:	6a 43                	push   $0x43
  jmp alltraps
801067b6:	e9 df f6 ff ff       	jmp    80105e9a <alltraps>

801067bb <vector68>:
.globl vector68
vector68:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $68
801067bd:	6a 44                	push   $0x44
  jmp alltraps
801067bf:	e9 d6 f6 ff ff       	jmp    80105e9a <alltraps>

801067c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $69
801067c6:	6a 45                	push   $0x45
  jmp alltraps
801067c8:	e9 cd f6 ff ff       	jmp    80105e9a <alltraps>

801067cd <vector70>:
.globl vector70
vector70:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $70
801067cf:	6a 46                	push   $0x46
  jmp alltraps
801067d1:	e9 c4 f6 ff ff       	jmp    80105e9a <alltraps>

801067d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $71
801067d8:	6a 47                	push   $0x47
  jmp alltraps
801067da:	e9 bb f6 ff ff       	jmp    80105e9a <alltraps>

801067df <vector72>:
.globl vector72
vector72:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $72
801067e1:	6a 48                	push   $0x48
  jmp alltraps
801067e3:	e9 b2 f6 ff ff       	jmp    80105e9a <alltraps>

801067e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $73
801067ea:	6a 49                	push   $0x49
  jmp alltraps
801067ec:	e9 a9 f6 ff ff       	jmp    80105e9a <alltraps>

801067f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $74
801067f3:	6a 4a                	push   $0x4a
  jmp alltraps
801067f5:	e9 a0 f6 ff ff       	jmp    80105e9a <alltraps>

801067fa <vector75>:
.globl vector75
vector75:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $75
801067fc:	6a 4b                	push   $0x4b
  jmp alltraps
801067fe:	e9 97 f6 ff ff       	jmp    80105e9a <alltraps>

80106803 <vector76>:
.globl vector76
vector76:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $76
80106805:	6a 4c                	push   $0x4c
  jmp alltraps
80106807:	e9 8e f6 ff ff       	jmp    80105e9a <alltraps>

8010680c <vector77>:
.globl vector77
vector77:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $77
8010680e:	6a 4d                	push   $0x4d
  jmp alltraps
80106810:	e9 85 f6 ff ff       	jmp    80105e9a <alltraps>

80106815 <vector78>:
.globl vector78
vector78:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $78
80106817:	6a 4e                	push   $0x4e
  jmp alltraps
80106819:	e9 7c f6 ff ff       	jmp    80105e9a <alltraps>

8010681e <vector79>:
.globl vector79
vector79:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $79
80106820:	6a 4f                	push   $0x4f
  jmp alltraps
80106822:	e9 73 f6 ff ff       	jmp    80105e9a <alltraps>

80106827 <vector80>:
.globl vector80
vector80:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $80
80106829:	6a 50                	push   $0x50
  jmp alltraps
8010682b:	e9 6a f6 ff ff       	jmp    80105e9a <alltraps>

80106830 <vector81>:
.globl vector81
vector81:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $81
80106832:	6a 51                	push   $0x51
  jmp alltraps
80106834:	e9 61 f6 ff ff       	jmp    80105e9a <alltraps>

80106839 <vector82>:
.globl vector82
vector82:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $82
8010683b:	6a 52                	push   $0x52
  jmp alltraps
8010683d:	e9 58 f6 ff ff       	jmp    80105e9a <alltraps>

80106842 <vector83>:
.globl vector83
vector83:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $83
80106844:	6a 53                	push   $0x53
  jmp alltraps
80106846:	e9 4f f6 ff ff       	jmp    80105e9a <alltraps>

8010684b <vector84>:
.globl vector84
vector84:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $84
8010684d:	6a 54                	push   $0x54
  jmp alltraps
8010684f:	e9 46 f6 ff ff       	jmp    80105e9a <alltraps>

80106854 <vector85>:
.globl vector85
vector85:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $85
80106856:	6a 55                	push   $0x55
  jmp alltraps
80106858:	e9 3d f6 ff ff       	jmp    80105e9a <alltraps>

8010685d <vector86>:
.globl vector86
vector86:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $86
8010685f:	6a 56                	push   $0x56
  jmp alltraps
80106861:	e9 34 f6 ff ff       	jmp    80105e9a <alltraps>

80106866 <vector87>:
.globl vector87
vector87:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $87
80106868:	6a 57                	push   $0x57
  jmp alltraps
8010686a:	e9 2b f6 ff ff       	jmp    80105e9a <alltraps>

8010686f <vector88>:
.globl vector88
vector88:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $88
80106871:	6a 58                	push   $0x58
  jmp alltraps
80106873:	e9 22 f6 ff ff       	jmp    80105e9a <alltraps>

80106878 <vector89>:
.globl vector89
vector89:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $89
8010687a:	6a 59                	push   $0x59
  jmp alltraps
8010687c:	e9 19 f6 ff ff       	jmp    80105e9a <alltraps>

80106881 <vector90>:
.globl vector90
vector90:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $90
80106883:	6a 5a                	push   $0x5a
  jmp alltraps
80106885:	e9 10 f6 ff ff       	jmp    80105e9a <alltraps>

8010688a <vector91>:
.globl vector91
vector91:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $91
8010688c:	6a 5b                	push   $0x5b
  jmp alltraps
8010688e:	e9 07 f6 ff ff       	jmp    80105e9a <alltraps>

80106893 <vector92>:
.globl vector92
vector92:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $92
80106895:	6a 5c                	push   $0x5c
  jmp alltraps
80106897:	e9 fe f5 ff ff       	jmp    80105e9a <alltraps>

8010689c <vector93>:
.globl vector93
vector93:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $93
8010689e:	6a 5d                	push   $0x5d
  jmp alltraps
801068a0:	e9 f5 f5 ff ff       	jmp    80105e9a <alltraps>

801068a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $94
801068a7:	6a 5e                	push   $0x5e
  jmp alltraps
801068a9:	e9 ec f5 ff ff       	jmp    80105e9a <alltraps>

801068ae <vector95>:
.globl vector95
vector95:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $95
801068b0:	6a 5f                	push   $0x5f
  jmp alltraps
801068b2:	e9 e3 f5 ff ff       	jmp    80105e9a <alltraps>

801068b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $96
801068b9:	6a 60                	push   $0x60
  jmp alltraps
801068bb:	e9 da f5 ff ff       	jmp    80105e9a <alltraps>

801068c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $97
801068c2:	6a 61                	push   $0x61
  jmp alltraps
801068c4:	e9 d1 f5 ff ff       	jmp    80105e9a <alltraps>

801068c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $98
801068cb:	6a 62                	push   $0x62
  jmp alltraps
801068cd:	e9 c8 f5 ff ff       	jmp    80105e9a <alltraps>

801068d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $99
801068d4:	6a 63                	push   $0x63
  jmp alltraps
801068d6:	e9 bf f5 ff ff       	jmp    80105e9a <alltraps>

801068db <vector100>:
.globl vector100
vector100:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $100
801068dd:	6a 64                	push   $0x64
  jmp alltraps
801068df:	e9 b6 f5 ff ff       	jmp    80105e9a <alltraps>

801068e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $101
801068e6:	6a 65                	push   $0x65
  jmp alltraps
801068e8:	e9 ad f5 ff ff       	jmp    80105e9a <alltraps>

801068ed <vector102>:
.globl vector102
vector102:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $102
801068ef:	6a 66                	push   $0x66
  jmp alltraps
801068f1:	e9 a4 f5 ff ff       	jmp    80105e9a <alltraps>

801068f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $103
801068f8:	6a 67                	push   $0x67
  jmp alltraps
801068fa:	e9 9b f5 ff ff       	jmp    80105e9a <alltraps>

801068ff <vector104>:
.globl vector104
vector104:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $104
80106901:	6a 68                	push   $0x68
  jmp alltraps
80106903:	e9 92 f5 ff ff       	jmp    80105e9a <alltraps>

80106908 <vector105>:
.globl vector105
vector105:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $105
8010690a:	6a 69                	push   $0x69
  jmp alltraps
8010690c:	e9 89 f5 ff ff       	jmp    80105e9a <alltraps>

80106911 <vector106>:
.globl vector106
vector106:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $106
80106913:	6a 6a                	push   $0x6a
  jmp alltraps
80106915:	e9 80 f5 ff ff       	jmp    80105e9a <alltraps>

8010691a <vector107>:
.globl vector107
vector107:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $107
8010691c:	6a 6b                	push   $0x6b
  jmp alltraps
8010691e:	e9 77 f5 ff ff       	jmp    80105e9a <alltraps>

80106923 <vector108>:
.globl vector108
vector108:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $108
80106925:	6a 6c                	push   $0x6c
  jmp alltraps
80106927:	e9 6e f5 ff ff       	jmp    80105e9a <alltraps>

8010692c <vector109>:
.globl vector109
vector109:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $109
8010692e:	6a 6d                	push   $0x6d
  jmp alltraps
80106930:	e9 65 f5 ff ff       	jmp    80105e9a <alltraps>

80106935 <vector110>:
.globl vector110
vector110:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $110
80106937:	6a 6e                	push   $0x6e
  jmp alltraps
80106939:	e9 5c f5 ff ff       	jmp    80105e9a <alltraps>

8010693e <vector111>:
.globl vector111
vector111:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $111
80106940:	6a 6f                	push   $0x6f
  jmp alltraps
80106942:	e9 53 f5 ff ff       	jmp    80105e9a <alltraps>

80106947 <vector112>:
.globl vector112
vector112:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $112
80106949:	6a 70                	push   $0x70
  jmp alltraps
8010694b:	e9 4a f5 ff ff       	jmp    80105e9a <alltraps>

80106950 <vector113>:
.globl vector113
vector113:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $113
80106952:	6a 71                	push   $0x71
  jmp alltraps
80106954:	e9 41 f5 ff ff       	jmp    80105e9a <alltraps>

80106959 <vector114>:
.globl vector114
vector114:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $114
8010695b:	6a 72                	push   $0x72
  jmp alltraps
8010695d:	e9 38 f5 ff ff       	jmp    80105e9a <alltraps>

80106962 <vector115>:
.globl vector115
vector115:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $115
80106964:	6a 73                	push   $0x73
  jmp alltraps
80106966:	e9 2f f5 ff ff       	jmp    80105e9a <alltraps>

8010696b <vector116>:
.globl vector116
vector116:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $116
8010696d:	6a 74                	push   $0x74
  jmp alltraps
8010696f:	e9 26 f5 ff ff       	jmp    80105e9a <alltraps>

80106974 <vector117>:
.globl vector117
vector117:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $117
80106976:	6a 75                	push   $0x75
  jmp alltraps
80106978:	e9 1d f5 ff ff       	jmp    80105e9a <alltraps>

8010697d <vector118>:
.globl vector118
vector118:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $118
8010697f:	6a 76                	push   $0x76
  jmp alltraps
80106981:	e9 14 f5 ff ff       	jmp    80105e9a <alltraps>

80106986 <vector119>:
.globl vector119
vector119:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $119
80106988:	6a 77                	push   $0x77
  jmp alltraps
8010698a:	e9 0b f5 ff ff       	jmp    80105e9a <alltraps>

8010698f <vector120>:
.globl vector120
vector120:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $120
80106991:	6a 78                	push   $0x78
  jmp alltraps
80106993:	e9 02 f5 ff ff       	jmp    80105e9a <alltraps>

80106998 <vector121>:
.globl vector121
vector121:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $121
8010699a:	6a 79                	push   $0x79
  jmp alltraps
8010699c:	e9 f9 f4 ff ff       	jmp    80105e9a <alltraps>

801069a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $122
801069a3:	6a 7a                	push   $0x7a
  jmp alltraps
801069a5:	e9 f0 f4 ff ff       	jmp    80105e9a <alltraps>

801069aa <vector123>:
.globl vector123
vector123:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $123
801069ac:	6a 7b                	push   $0x7b
  jmp alltraps
801069ae:	e9 e7 f4 ff ff       	jmp    80105e9a <alltraps>

801069b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $124
801069b5:	6a 7c                	push   $0x7c
  jmp alltraps
801069b7:	e9 de f4 ff ff       	jmp    80105e9a <alltraps>

801069bc <vector125>:
.globl vector125
vector125:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $125
801069be:	6a 7d                	push   $0x7d
  jmp alltraps
801069c0:	e9 d5 f4 ff ff       	jmp    80105e9a <alltraps>

801069c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $126
801069c7:	6a 7e                	push   $0x7e
  jmp alltraps
801069c9:	e9 cc f4 ff ff       	jmp    80105e9a <alltraps>

801069ce <vector127>:
.globl vector127
vector127:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $127
801069d0:	6a 7f                	push   $0x7f
  jmp alltraps
801069d2:	e9 c3 f4 ff ff       	jmp    80105e9a <alltraps>

801069d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $128
801069d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801069de:	e9 b7 f4 ff ff       	jmp    80105e9a <alltraps>

801069e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $129
801069e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801069ea:	e9 ab f4 ff ff       	jmp    80105e9a <alltraps>

801069ef <vector130>:
.globl vector130
vector130:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $130
801069f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801069f6:	e9 9f f4 ff ff       	jmp    80105e9a <alltraps>

801069fb <vector131>:
.globl vector131
vector131:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $131
801069fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a02:	e9 93 f4 ff ff       	jmp    80105e9a <alltraps>

80106a07 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $132
80106a09:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a0e:	e9 87 f4 ff ff       	jmp    80105e9a <alltraps>

80106a13 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $133
80106a15:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a1a:	e9 7b f4 ff ff       	jmp    80105e9a <alltraps>

80106a1f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $134
80106a21:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a26:	e9 6f f4 ff ff       	jmp    80105e9a <alltraps>

80106a2b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $135
80106a2d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a32:	e9 63 f4 ff ff       	jmp    80105e9a <alltraps>

80106a37 <vector136>:
.globl vector136
vector136:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $136
80106a39:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a3e:	e9 57 f4 ff ff       	jmp    80105e9a <alltraps>

80106a43 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $137
80106a45:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a4a:	e9 4b f4 ff ff       	jmp    80105e9a <alltraps>

80106a4f <vector138>:
.globl vector138
vector138:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $138
80106a51:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a56:	e9 3f f4 ff ff       	jmp    80105e9a <alltraps>

80106a5b <vector139>:
.globl vector139
vector139:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $139
80106a5d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a62:	e9 33 f4 ff ff       	jmp    80105e9a <alltraps>

80106a67 <vector140>:
.globl vector140
vector140:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $140
80106a69:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a6e:	e9 27 f4 ff ff       	jmp    80105e9a <alltraps>

80106a73 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $141
80106a75:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a7a:	e9 1b f4 ff ff       	jmp    80105e9a <alltraps>

80106a7f <vector142>:
.globl vector142
vector142:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $142
80106a81:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a86:	e9 0f f4 ff ff       	jmp    80105e9a <alltraps>

80106a8b <vector143>:
.globl vector143
vector143:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $143
80106a8d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a92:	e9 03 f4 ff ff       	jmp    80105e9a <alltraps>

80106a97 <vector144>:
.globl vector144
vector144:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $144
80106a99:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a9e:	e9 f7 f3 ff ff       	jmp    80105e9a <alltraps>

80106aa3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $145
80106aa5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106aaa:	e9 eb f3 ff ff       	jmp    80105e9a <alltraps>

80106aaf <vector146>:
.globl vector146
vector146:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $146
80106ab1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ab6:	e9 df f3 ff ff       	jmp    80105e9a <alltraps>

80106abb <vector147>:
.globl vector147
vector147:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $147
80106abd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ac2:	e9 d3 f3 ff ff       	jmp    80105e9a <alltraps>

80106ac7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $148
80106ac9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ace:	e9 c7 f3 ff ff       	jmp    80105e9a <alltraps>

80106ad3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $149
80106ad5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106ada:	e9 bb f3 ff ff       	jmp    80105e9a <alltraps>

80106adf <vector150>:
.globl vector150
vector150:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $150
80106ae1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ae6:	e9 af f3 ff ff       	jmp    80105e9a <alltraps>

80106aeb <vector151>:
.globl vector151
vector151:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $151
80106aed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106af2:	e9 a3 f3 ff ff       	jmp    80105e9a <alltraps>

80106af7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $152
80106af9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106afe:	e9 97 f3 ff ff       	jmp    80105e9a <alltraps>

80106b03 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $153
80106b05:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b0a:	e9 8b f3 ff ff       	jmp    80105e9a <alltraps>

80106b0f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $154
80106b11:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b16:	e9 7f f3 ff ff       	jmp    80105e9a <alltraps>

80106b1b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $155
80106b1d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b22:	e9 73 f3 ff ff       	jmp    80105e9a <alltraps>

80106b27 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $156
80106b29:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b2e:	e9 67 f3 ff ff       	jmp    80105e9a <alltraps>

80106b33 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $157
80106b35:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b3a:	e9 5b f3 ff ff       	jmp    80105e9a <alltraps>

80106b3f <vector158>:
.globl vector158
vector158:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $158
80106b41:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b46:	e9 4f f3 ff ff       	jmp    80105e9a <alltraps>

80106b4b <vector159>:
.globl vector159
vector159:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $159
80106b4d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b52:	e9 43 f3 ff ff       	jmp    80105e9a <alltraps>

80106b57 <vector160>:
.globl vector160
vector160:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $160
80106b59:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b5e:	e9 37 f3 ff ff       	jmp    80105e9a <alltraps>

80106b63 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $161
80106b65:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b6a:	e9 2b f3 ff ff       	jmp    80105e9a <alltraps>

80106b6f <vector162>:
.globl vector162
vector162:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $162
80106b71:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b76:	e9 1f f3 ff ff       	jmp    80105e9a <alltraps>

80106b7b <vector163>:
.globl vector163
vector163:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $163
80106b7d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b82:	e9 13 f3 ff ff       	jmp    80105e9a <alltraps>

80106b87 <vector164>:
.globl vector164
vector164:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $164
80106b89:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b8e:	e9 07 f3 ff ff       	jmp    80105e9a <alltraps>

80106b93 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $165
80106b95:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b9a:	e9 fb f2 ff ff       	jmp    80105e9a <alltraps>

80106b9f <vector166>:
.globl vector166
vector166:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $166
80106ba1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ba6:	e9 ef f2 ff ff       	jmp    80105e9a <alltraps>

80106bab <vector167>:
.globl vector167
vector167:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $167
80106bad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106bb2:	e9 e3 f2 ff ff       	jmp    80105e9a <alltraps>

80106bb7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $168
80106bb9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106bbe:	e9 d7 f2 ff ff       	jmp    80105e9a <alltraps>

80106bc3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $169
80106bc5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106bca:	e9 cb f2 ff ff       	jmp    80105e9a <alltraps>

80106bcf <vector170>:
.globl vector170
vector170:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $170
80106bd1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106bd6:	e9 bf f2 ff ff       	jmp    80105e9a <alltraps>

80106bdb <vector171>:
.globl vector171
vector171:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $171
80106bdd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106be2:	e9 b3 f2 ff ff       	jmp    80105e9a <alltraps>

80106be7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $172
80106be9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106bee:	e9 a7 f2 ff ff       	jmp    80105e9a <alltraps>

80106bf3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $173
80106bf5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106bfa:	e9 9b f2 ff ff       	jmp    80105e9a <alltraps>

80106bff <vector174>:
.globl vector174
vector174:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $174
80106c01:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c06:	e9 8f f2 ff ff       	jmp    80105e9a <alltraps>

80106c0b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $175
80106c0d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c12:	e9 83 f2 ff ff       	jmp    80105e9a <alltraps>

80106c17 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $176
80106c19:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c1e:	e9 77 f2 ff ff       	jmp    80105e9a <alltraps>

80106c23 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $177
80106c25:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c2a:	e9 6b f2 ff ff       	jmp    80105e9a <alltraps>

80106c2f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $178
80106c31:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c36:	e9 5f f2 ff ff       	jmp    80105e9a <alltraps>

80106c3b <vector179>:
.globl vector179
vector179:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $179
80106c3d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c42:	e9 53 f2 ff ff       	jmp    80105e9a <alltraps>

80106c47 <vector180>:
.globl vector180
vector180:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $180
80106c49:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c4e:	e9 47 f2 ff ff       	jmp    80105e9a <alltraps>

80106c53 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $181
80106c55:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c5a:	e9 3b f2 ff ff       	jmp    80105e9a <alltraps>

80106c5f <vector182>:
.globl vector182
vector182:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $182
80106c61:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c66:	e9 2f f2 ff ff       	jmp    80105e9a <alltraps>

80106c6b <vector183>:
.globl vector183
vector183:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $183
80106c6d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c72:	e9 23 f2 ff ff       	jmp    80105e9a <alltraps>

80106c77 <vector184>:
.globl vector184
vector184:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $184
80106c79:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c7e:	e9 17 f2 ff ff       	jmp    80105e9a <alltraps>

80106c83 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $185
80106c85:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c8a:	e9 0b f2 ff ff       	jmp    80105e9a <alltraps>

80106c8f <vector186>:
.globl vector186
vector186:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $186
80106c91:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c96:	e9 ff f1 ff ff       	jmp    80105e9a <alltraps>

80106c9b <vector187>:
.globl vector187
vector187:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $187
80106c9d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ca2:	e9 f3 f1 ff ff       	jmp    80105e9a <alltraps>

80106ca7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $188
80106ca9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106cae:	e9 e7 f1 ff ff       	jmp    80105e9a <alltraps>

80106cb3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $189
80106cb5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106cba:	e9 db f1 ff ff       	jmp    80105e9a <alltraps>

80106cbf <vector190>:
.globl vector190
vector190:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $190
80106cc1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106cc6:	e9 cf f1 ff ff       	jmp    80105e9a <alltraps>

80106ccb <vector191>:
.globl vector191
vector191:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $191
80106ccd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106cd2:	e9 c3 f1 ff ff       	jmp    80105e9a <alltraps>

80106cd7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $192
80106cd9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106cde:	e9 b7 f1 ff ff       	jmp    80105e9a <alltraps>

80106ce3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $193
80106ce5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106cea:	e9 ab f1 ff ff       	jmp    80105e9a <alltraps>

80106cef <vector194>:
.globl vector194
vector194:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $194
80106cf1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106cf6:	e9 9f f1 ff ff       	jmp    80105e9a <alltraps>

80106cfb <vector195>:
.globl vector195
vector195:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $195
80106cfd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d02:	e9 93 f1 ff ff       	jmp    80105e9a <alltraps>

80106d07 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $196
80106d09:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d0e:	e9 87 f1 ff ff       	jmp    80105e9a <alltraps>

80106d13 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $197
80106d15:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d1a:	e9 7b f1 ff ff       	jmp    80105e9a <alltraps>

80106d1f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $198
80106d21:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d26:	e9 6f f1 ff ff       	jmp    80105e9a <alltraps>

80106d2b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $199
80106d2d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d32:	e9 63 f1 ff ff       	jmp    80105e9a <alltraps>

80106d37 <vector200>:
.globl vector200
vector200:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $200
80106d39:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d3e:	e9 57 f1 ff ff       	jmp    80105e9a <alltraps>

80106d43 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $201
80106d45:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d4a:	e9 4b f1 ff ff       	jmp    80105e9a <alltraps>

80106d4f <vector202>:
.globl vector202
vector202:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $202
80106d51:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d56:	e9 3f f1 ff ff       	jmp    80105e9a <alltraps>

80106d5b <vector203>:
.globl vector203
vector203:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $203
80106d5d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d62:	e9 33 f1 ff ff       	jmp    80105e9a <alltraps>

80106d67 <vector204>:
.globl vector204
vector204:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $204
80106d69:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d6e:	e9 27 f1 ff ff       	jmp    80105e9a <alltraps>

80106d73 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $205
80106d75:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d7a:	e9 1b f1 ff ff       	jmp    80105e9a <alltraps>

80106d7f <vector206>:
.globl vector206
vector206:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $206
80106d81:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d86:	e9 0f f1 ff ff       	jmp    80105e9a <alltraps>

80106d8b <vector207>:
.globl vector207
vector207:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $207
80106d8d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d92:	e9 03 f1 ff ff       	jmp    80105e9a <alltraps>

80106d97 <vector208>:
.globl vector208
vector208:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $208
80106d99:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d9e:	e9 f7 f0 ff ff       	jmp    80105e9a <alltraps>

80106da3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $209
80106da5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106daa:	e9 eb f0 ff ff       	jmp    80105e9a <alltraps>

80106daf <vector210>:
.globl vector210
vector210:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $210
80106db1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106db6:	e9 df f0 ff ff       	jmp    80105e9a <alltraps>

80106dbb <vector211>:
.globl vector211
vector211:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $211
80106dbd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106dc2:	e9 d3 f0 ff ff       	jmp    80105e9a <alltraps>

80106dc7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $212
80106dc9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106dce:	e9 c7 f0 ff ff       	jmp    80105e9a <alltraps>

80106dd3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $213
80106dd5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106dda:	e9 bb f0 ff ff       	jmp    80105e9a <alltraps>

80106ddf <vector214>:
.globl vector214
vector214:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $214
80106de1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106de6:	e9 af f0 ff ff       	jmp    80105e9a <alltraps>

80106deb <vector215>:
.globl vector215
vector215:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $215
80106ded:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106df2:	e9 a3 f0 ff ff       	jmp    80105e9a <alltraps>

80106df7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $216
80106df9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106dfe:	e9 97 f0 ff ff       	jmp    80105e9a <alltraps>

80106e03 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $217
80106e05:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e0a:	e9 8b f0 ff ff       	jmp    80105e9a <alltraps>

80106e0f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $218
80106e11:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e16:	e9 7f f0 ff ff       	jmp    80105e9a <alltraps>

80106e1b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $219
80106e1d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e22:	e9 73 f0 ff ff       	jmp    80105e9a <alltraps>

80106e27 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $220
80106e29:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e2e:	e9 67 f0 ff ff       	jmp    80105e9a <alltraps>

80106e33 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $221
80106e35:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e3a:	e9 5b f0 ff ff       	jmp    80105e9a <alltraps>

80106e3f <vector222>:
.globl vector222
vector222:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $222
80106e41:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e46:	e9 4f f0 ff ff       	jmp    80105e9a <alltraps>

80106e4b <vector223>:
.globl vector223
vector223:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $223
80106e4d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e52:	e9 43 f0 ff ff       	jmp    80105e9a <alltraps>

80106e57 <vector224>:
.globl vector224
vector224:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $224
80106e59:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e5e:	e9 37 f0 ff ff       	jmp    80105e9a <alltraps>

80106e63 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $225
80106e65:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e6a:	e9 2b f0 ff ff       	jmp    80105e9a <alltraps>

80106e6f <vector226>:
.globl vector226
vector226:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $226
80106e71:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e76:	e9 1f f0 ff ff       	jmp    80105e9a <alltraps>

80106e7b <vector227>:
.globl vector227
vector227:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $227
80106e7d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e82:	e9 13 f0 ff ff       	jmp    80105e9a <alltraps>

80106e87 <vector228>:
.globl vector228
vector228:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $228
80106e89:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e8e:	e9 07 f0 ff ff       	jmp    80105e9a <alltraps>

80106e93 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $229
80106e95:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e9a:	e9 fb ef ff ff       	jmp    80105e9a <alltraps>

80106e9f <vector230>:
.globl vector230
vector230:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $230
80106ea1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ea6:	e9 ef ef ff ff       	jmp    80105e9a <alltraps>

80106eab <vector231>:
.globl vector231
vector231:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $231
80106ead:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106eb2:	e9 e3 ef ff ff       	jmp    80105e9a <alltraps>

80106eb7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $232
80106eb9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ebe:	e9 d7 ef ff ff       	jmp    80105e9a <alltraps>

80106ec3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $233
80106ec5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106eca:	e9 cb ef ff ff       	jmp    80105e9a <alltraps>

80106ecf <vector234>:
.globl vector234
vector234:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $234
80106ed1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ed6:	e9 bf ef ff ff       	jmp    80105e9a <alltraps>

80106edb <vector235>:
.globl vector235
vector235:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $235
80106edd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ee2:	e9 b3 ef ff ff       	jmp    80105e9a <alltraps>

80106ee7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $236
80106ee9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106eee:	e9 a7 ef ff ff       	jmp    80105e9a <alltraps>

80106ef3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $237
80106ef5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106efa:	e9 9b ef ff ff       	jmp    80105e9a <alltraps>

80106eff <vector238>:
.globl vector238
vector238:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $238
80106f01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f06:	e9 8f ef ff ff       	jmp    80105e9a <alltraps>

80106f0b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $239
80106f0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f12:	e9 83 ef ff ff       	jmp    80105e9a <alltraps>

80106f17 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $240
80106f19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f1e:	e9 77 ef ff ff       	jmp    80105e9a <alltraps>

80106f23 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $241
80106f25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f2a:	e9 6b ef ff ff       	jmp    80105e9a <alltraps>

80106f2f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $242
80106f31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f36:	e9 5f ef ff ff       	jmp    80105e9a <alltraps>

80106f3b <vector243>:
.globl vector243
vector243:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $243
80106f3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f42:	e9 53 ef ff ff       	jmp    80105e9a <alltraps>

80106f47 <vector244>:
.globl vector244
vector244:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $244
80106f49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f4e:	e9 47 ef ff ff       	jmp    80105e9a <alltraps>

80106f53 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $245
80106f55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f5a:	e9 3b ef ff ff       	jmp    80105e9a <alltraps>

80106f5f <vector246>:
.globl vector246
vector246:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $246
80106f61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f66:	e9 2f ef ff ff       	jmp    80105e9a <alltraps>

80106f6b <vector247>:
.globl vector247
vector247:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $247
80106f6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f72:	e9 23 ef ff ff       	jmp    80105e9a <alltraps>

80106f77 <vector248>:
.globl vector248
vector248:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $248
80106f79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f7e:	e9 17 ef ff ff       	jmp    80105e9a <alltraps>

80106f83 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $249
80106f85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f8a:	e9 0b ef ff ff       	jmp    80105e9a <alltraps>

80106f8f <vector250>:
.globl vector250
vector250:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $250
80106f91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f96:	e9 ff ee ff ff       	jmp    80105e9a <alltraps>

80106f9b <vector251>:
.globl vector251
vector251:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $251
80106f9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106fa2:	e9 f3 ee ff ff       	jmp    80105e9a <alltraps>

80106fa7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $252
80106fa9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106fae:	e9 e7 ee ff ff       	jmp    80105e9a <alltraps>

80106fb3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $253
80106fb5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106fba:	e9 db ee ff ff       	jmp    80105e9a <alltraps>

80106fbf <vector254>:
.globl vector254
vector254:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $254
80106fc1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106fc6:	e9 cf ee ff ff       	jmp    80105e9a <alltraps>

80106fcb <vector255>:
.globl vector255
vector255:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $255
80106fcd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106fd2:	e9 c3 ee ff ff       	jmp    80105e9a <alltraps>
80106fd7:	66 90                	xchg   %ax,%ax
80106fd9:	66 90                	xchg   %ax,%ax
80106fdb:	66 90                	xchg   %ax,%ax
80106fdd:	66 90                	xchg   %ax,%ax
80106fdf:	90                   	nop

80106fe0 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
80106fe6:	89 d3                	mov    %edx,%ebx
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80106fe8:	c1 ea 16             	shr    $0x16,%edx
80106feb:	8d 3c 90             	lea    (%eax,%edx,4),%edi

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106fee:	83 ec 0c             	sub    $0xc,%esp
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
80106ff1:	8b 07                	mov    (%edi),%eax
80106ff3:	a8 01                	test   $0x1,%al
80106ff5:	74 29                	je     80107020 <walkpgdir+0x40>
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
80106ff7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ffc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
}
80107002:	8d 65 f4             	lea    -0xc(%ebp),%esp
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
80107005:	c1 eb 0a             	shr    $0xa,%ebx
80107008:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010700e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80107011:	5b                   	pop    %ebx
80107012:	5e                   	pop    %esi
80107013:	5f                   	pop    %edi
80107014:	5d                   	pop    %ebp
80107015:	c3                   	ret    
80107016:	8d 76 00             	lea    0x0(%esi),%esi
80107019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
    } else {
        if (!alloc || (pgtab = (pte_t *) kalloc()) == 0)
80107020:	85 c9                	test   %ecx,%ecx
80107022:	74 2c                	je     80107050 <walkpgdir+0x70>
80107024:	e8 a7 b8 ff ff       	call   801028d0 <kalloc>
80107029:	85 c0                	test   %eax,%eax
8010702b:	89 c6                	mov    %eax,%esi
8010702d:	74 21                	je     80107050 <walkpgdir+0x70>
            return 0;
        // Make sure all those PTE_P bits are zero.
        memset(pgtab, 0, PGSIZE);
8010702f:	83 ec 04             	sub    $0x4,%esp
80107032:	68 00 10 00 00       	push   $0x1000
80107037:	6a 00                	push   $0x0
80107039:	50                   	push   %eax
8010703a:	e8 41 dc ff ff       	call   80104c80 <memset>
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010703f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107045:	83 c4 10             	add    $0x10,%esp
80107048:	83 c8 07             	or     $0x7,%eax
8010704b:	89 07                	mov    %eax,(%edi)
8010704d:	eb b3                	jmp    80107002 <walkpgdir+0x22>
8010704f:	90                   	nop
    }
    return &pgtab[PTX(va)];
}
80107050:	8d 65 f4             	lea    -0xc(%ebp),%esp
    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
    } else {
        if (!alloc || (pgtab = (pte_t *) kalloc()) == 0)
            return 0;
80107053:	31 c0                	xor    %eax,%eax
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
}
80107055:	5b                   	pop    %ebx
80107056:	5e                   	pop    %esi
80107057:	5f                   	pop    %edi
80107058:	5d                   	pop    %ebp
80107059:	c3                   	ret    
8010705a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107060 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
    char *a, *last;
    pte_t *pte;

    a = (char *) PGROUNDDOWN((uint) va);
80107066:	89 d3                	mov    %edx,%ebx
80107068:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
8010706e:	83 ec 1c             	sub    $0x1c,%esp
80107071:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    char *a, *last;
    pte_t *pte;

    a = (char *) PGROUNDDOWN((uint) va);
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
80107074:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107078:	8b 7d 08             	mov    0x8(%ebp),%edi
8010707b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107080:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
            panic("remap");
        *pte = pa | perm | PTE_P;
80107083:	8b 45 0c             	mov    0xc(%ebp),%eax
80107086:	29 df                	sub    %ebx,%edi
80107088:	83 c8 01             	or     $0x1,%eax
8010708b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010708e:	eb 15                	jmp    801070a5 <mappages+0x45>
    a = (char *) PGROUNDDOWN((uint) va);
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
80107090:	f6 00 01             	testb  $0x1,(%eax)
80107093:	75 45                	jne    801070da <mappages+0x7a>
            panic("remap");
        *pte = pa | perm | PTE_P;
80107095:	0b 75 dc             	or     -0x24(%ebp),%esi
        if (a == last)
80107098:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
            panic("remap");
        *pte = pa | perm | PTE_P;
8010709b:	89 30                	mov    %esi,(%eax)
        if (a == last)
8010709d:	74 31                	je     801070d0 <mappages+0x70>
            break;
        a += PGSIZE;
8010709f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pte_t *pte;

    a = (char *) PGROUNDDOWN((uint) va);
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
801070a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801070ad:	89 da                	mov    %ebx,%edx
801070af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801070b2:	e8 29 ff ff ff       	call   80106fe0 <walkpgdir>
801070b7:	85 c0                	test   %eax,%eax
801070b9:	75 d5                	jne    80107090 <mappages+0x30>
            break;
        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
}
801070bb:	8d 65 f4             	lea    -0xc(%ebp),%esp

    a = (char *) PGROUNDDOWN((uint) va);
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
801070be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            break;
        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
}
801070c3:	5b                   	pop    %ebx
801070c4:	5e                   	pop    %esi
801070c5:	5f                   	pop    %edi
801070c6:	5d                   	pop    %ebp
801070c7:	c3                   	ret    
801070c8:	90                   	nop
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        if (a == last)
            break;
        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
801070d3:	31 c0                	xor    %eax,%eax
}
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
            panic("remap");
801070da:	83 ec 0c             	sub    $0xc,%esp
801070dd:	68 78 87 10 80       	push   $0x80108778
801070e2:	e8 89 92 ff ff       	call   80100370 <panic>
801070e7:	89 f6                	mov    %esi,%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070f0 <seginit>:
char buffer[PGSIZE];

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void) {
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	83 ec 18             	sub    $0x18,%esp

    // Map "logical" addresses to virtual addresses using identity map.
    // Cannot share a CODE descriptor for both kernel and user
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpuid()];
801070f6:	e8 75 cb ff ff       	call   80103c70 <cpuid>
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
801070fb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107101:	31 c9                	xor    %ecx,%ecx
80107103:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107108:	66 89 90 18 38 11 80 	mov    %dx,-0x7feec7e8(%eax)
8010710f:	66 89 88 1a 38 11 80 	mov    %cx,-0x7feec7e6(%eax)
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107116:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010711b:	31 c9                	xor    %ecx,%ecx
8010711d:	66 89 90 20 38 11 80 	mov    %dx,-0x7feec7e0(%eax)
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80107124:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    // Cannot share a CODE descriptor for both kernel and user
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpuid()];
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107129:	66 89 88 22 38 11 80 	mov    %cx,-0x7feec7de(%eax)
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80107130:	31 c9                	xor    %ecx,%ecx
80107132:	66 89 90 28 38 11 80 	mov    %dx,-0x7feec7d8(%eax)
80107139:	66 89 88 2a 38 11 80 	mov    %cx,-0x7feec7d6(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107140:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107145:	31 c9                	xor    %ecx,%ecx
80107147:	66 89 90 30 38 11 80 	mov    %dx,-0x7feec7d0(%eax)
    // Map "logical" addresses to virtual addresses using identity map.
    // Cannot share a CODE descriptor for both kernel and user
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpuid()];
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010714e:	c6 80 1c 38 11 80 00 	movb   $0x0,-0x7feec7e4(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107155:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010715a:	c6 80 1d 38 11 80 9a 	movb   $0x9a,-0x7feec7e3(%eax)
80107161:	c6 80 1e 38 11 80 cf 	movb   $0xcf,-0x7feec7e2(%eax)
80107168:	c6 80 1f 38 11 80 00 	movb   $0x0,-0x7feec7e1(%eax)
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010716f:	c6 80 24 38 11 80 00 	movb   $0x0,-0x7feec7dc(%eax)
80107176:	c6 80 25 38 11 80 92 	movb   $0x92,-0x7feec7db(%eax)
8010717d:	c6 80 26 38 11 80 cf 	movb   $0xcf,-0x7feec7da(%eax)
80107184:	c6 80 27 38 11 80 00 	movb   $0x0,-0x7feec7d9(%eax)
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
8010718b:	c6 80 2c 38 11 80 00 	movb   $0x0,-0x7feec7d4(%eax)
80107192:	c6 80 2d 38 11 80 fa 	movb   $0xfa,-0x7feec7d3(%eax)
80107199:	c6 80 2e 38 11 80 cf 	movb   $0xcf,-0x7feec7d2(%eax)
801071a0:	c6 80 2f 38 11 80 00 	movb   $0x0,-0x7feec7d1(%eax)
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071a7:	66 89 88 32 38 11 80 	mov    %cx,-0x7feec7ce(%eax)
801071ae:	c6 80 34 38 11 80 00 	movb   $0x0,-0x7feec7cc(%eax)
801071b5:	c6 80 35 38 11 80 f2 	movb   $0xf2,-0x7feec7cb(%eax)
801071bc:	c6 80 36 38 11 80 cf 	movb   $0xcf,-0x7feec7ca(%eax)
801071c3:	c6 80 37 38 11 80 00 	movb   $0x0,-0x7feec7c9(%eax)
    lgdt(c->gdt, sizeof(c->gdt));
801071ca:	05 10 38 11 80       	add    $0x80113810,%eax
801071cf:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801071d3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801071d7:	c1 e8 10             	shr    $0x10,%eax
801071da:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801071de:	8d 45 f2             	lea    -0xe(%ebp),%eax
801071e1:	0f 01 10             	lgdtl  (%eax)
}
801071e4:	c9                   	leave  
801071e5:	c3                   	ret    
801071e6:	8d 76 00             	lea    0x0(%esi),%esi
801071e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071f0 <walkpgdir2>:
}


//global use for walkpgdir
pte_t *
walkpgdir2(pde_t *pgdir, const void *va, int alloc) {
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
    return walkpgdir(pgdir, va, alloc);
801071f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801071f6:	8b 55 0c             	mov    0xc(%ebp),%edx
801071f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801071fc:	5d                   	pop    %ebp


//global use for walkpgdir
pte_t *
walkpgdir2(pde_t *pgdir, const void *va, int alloc) {
    return walkpgdir(pgdir, va, alloc);
801071fd:	e9 de fd ff ff       	jmp    80106fe0 <walkpgdir>
80107202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107210 <mappages2>:
}


// global use for mappages
int
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
    return mappages(pgdir, va, size, pa, perm);
80107213:	8b 4d 18             	mov    0x18(%ebp),%ecx
}


// global use for mappages
int
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80107216:	8b 55 0c             	mov    0xc(%ebp),%edx
80107219:	8b 45 08             	mov    0x8(%ebp),%eax
    return mappages(pgdir, va, size, pa, perm);
8010721c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010721f:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107222:	89 4d 08             	mov    %ecx,0x8(%ebp)
80107225:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
80107228:	5d                   	pop    %ebp


// global use for mappages
int
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
    return mappages(pgdir, va, size, pa, perm);
80107229:	e9 32 fe ff ff       	jmp    80107060 <mappages>
8010722e:	66 90                	xchg   %ax,%ax

80107230 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107230:	a1 e8 6c 12 80       	mov    0x80126ce8,%eax
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void) {
80107235:	55                   	push   %ebp
80107236:	89 e5                	mov    %esp,%ebp
80107238:	05 00 00 00 80       	add    $0x80000000,%eax
8010723d:	0f 22 d8             	mov    %eax,%cr3
    lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107240:	5d                   	pop    %ebp
80107241:	c3                   	ret    
80107242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107250 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p) {
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
80107256:	83 ec 1c             	sub    $0x1c,%esp
80107259:	8b 75 08             	mov    0x8(%ebp),%esi
    if (p == 0)
8010725c:	85 f6                	test   %esi,%esi
8010725e:	0f 84 cd 00 00 00    	je     80107331 <switchuvm+0xe1>
        panic("switchuvm: no process");
    if (p->kstack == 0)
80107264:	8b 46 08             	mov    0x8(%esi),%eax
80107267:	85 c0                	test   %eax,%eax
80107269:	0f 84 dc 00 00 00    	je     8010734b <switchuvm+0xfb>
        panic("switchuvm: no kstack");
    if (p->pgdir == 0)
8010726f:	8b 7e 04             	mov    0x4(%esi),%edi
80107272:	85 ff                	test   %edi,%edi
80107274:	0f 84 c4 00 00 00    	je     8010733e <switchuvm+0xee>
        panic("switchuvm: no pgdir");

    pushcli();
8010727a:	e8 51 d8 ff ff       	call   80104ad0 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010727f:	e8 6c c9 ff ff       	call   80103bf0 <mycpu>
80107284:	89 c3                	mov    %eax,%ebx
80107286:	e8 65 c9 ff ff       	call   80103bf0 <mycpu>
8010728b:	89 c7                	mov    %eax,%edi
8010728d:	e8 5e c9 ff ff       	call   80103bf0 <mycpu>
80107292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107295:	83 c7 08             	add    $0x8,%edi
80107298:	e8 53 c9 ff ff       	call   80103bf0 <mycpu>
8010729d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072a0:	83 c0 08             	add    $0x8,%eax
801072a3:	ba 67 00 00 00       	mov    $0x67,%edx
801072a8:	c1 e8 18             	shr    $0x18,%eax
801072ab:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801072b2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072b9:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801072c0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801072c7:	83 c1 08             	add    $0x8,%ecx
801072ca:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072d0:	c1 e9 10             	shr    $0x10,%ecx
801072d3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
    mycpu()->gdt[SEG_TSS].s = 0;
    mycpu()->ts.ss0 = SEG_KDATA << 3;
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    mycpu()->ts.iomb = (ushort) 0xFFFF;
801072d9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
        panic("switchuvm: no pgdir");

    pushcli();
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                  sizeof(mycpu()->ts) - 1, 0);
    mycpu()->gdt[SEG_TSS].s = 0;
801072de:	e8 0d c9 ff ff       	call   80103bf0 <mycpu>
801072e3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
801072ea:	e8 01 c9 ff ff       	call   80103bf0 <mycpu>
801072ef:	b9 10 00 00 00       	mov    $0x10,%ecx
801072f4:	66 89 48 10          	mov    %cx,0x10(%eax)
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
801072f8:	e8 f3 c8 ff ff       	call   80103bf0 <mycpu>
801072fd:	8b 56 08             	mov    0x8(%esi),%edx
80107300:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107306:	89 48 0c             	mov    %ecx,0xc(%eax)
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80107309:	e8 e2 c8 ff ff       	call   80103bf0 <mycpu>
8010730e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107312:	b8 28 00 00 00       	mov    $0x28,%eax
80107317:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010731a:	8b 46 04             	mov    0x4(%esi),%eax
8010731d:	05 00 00 00 80       	add    $0x80000000,%eax
80107322:	0f 22 d8             	mov    %eax,%cr3
    ltr(SEG_TSS << 3);
    lcr3(V2P(p->pgdir));  // switch to process's address space
    popcli();
}
80107325:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107328:	5b                   	pop    %ebx
80107329:	5e                   	pop    %esi
8010732a:	5f                   	pop    %edi
8010732b:	5d                   	pop    %ebp
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    mycpu()->ts.iomb = (ushort) 0xFFFF;
    ltr(SEG_TSS << 3);
    lcr3(V2P(p->pgdir));  // switch to process's address space
    popcli();
8010732c:	e9 8f d8 ff ff       	jmp    80104bc0 <popcli>

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p) {
    if (p == 0)
        panic("switchuvm: no process");
80107331:	83 ec 0c             	sub    $0xc,%esp
80107334:	68 7e 87 10 80       	push   $0x8010877e
80107339:	e8 32 90 ff ff       	call   80100370 <panic>
    if (p->kstack == 0)
        panic("switchuvm: no kstack");
    if (p->pgdir == 0)
        panic("switchuvm: no pgdir");
8010733e:	83 ec 0c             	sub    $0xc,%esp
80107341:	68 a9 87 10 80       	push   $0x801087a9
80107346:	e8 25 90 ff ff       	call   80100370 <panic>
void
switchuvm(struct proc *p) {
    if (p == 0)
        panic("switchuvm: no process");
    if (p->kstack == 0)
        panic("switchuvm: no kstack");
8010734b:	83 ec 0c             	sub    $0xc,%esp
8010734e:	68 94 87 10 80       	push   $0x80108794
80107353:	e8 18 90 ff ff       	call   80100370 <panic>
80107358:	90                   	nop
80107359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107360 <inituvm>:
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz) {
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 1c             	sub    $0x1c,%esp
80107369:	8b 75 10             	mov    0x10(%ebp),%esi
8010736c:	8b 45 08             	mov    0x8(%ebp),%eax
8010736f:	8b 7d 0c             	mov    0xc(%ebp),%edi
    char *mem;

    if (sz >= PGSIZE)
80107372:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz) {
80107378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    char *mem;

    if (sz >= PGSIZE)
8010737b:	77 49                	ja     801073c6 <inituvm+0x66>
        panic("inituvm: more than a page");
    mem = kalloc();
8010737d:	e8 4e b5 ff ff       	call   801028d0 <kalloc>
    memset(mem, 0, PGSIZE);
80107382:	83 ec 04             	sub    $0x4,%esp
inituvm(pde_t *pgdir, char *init, uint sz) {
    char *mem;

    if (sz >= PGSIZE)
        panic("inituvm: more than a page");
    mem = kalloc();
80107385:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80107387:	68 00 10 00 00       	push   $0x1000
8010738c:	6a 00                	push   $0x0
8010738e:	50                   	push   %eax
8010738f:	e8 ec d8 ff ff       	call   80104c80 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107394:	58                   	pop    %eax
80107395:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010739b:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073a0:	5a                   	pop    %edx
801073a1:	6a 06                	push   $0x6
801073a3:	50                   	push   %eax
801073a4:	31 d2                	xor    %edx,%edx
801073a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073a9:	e8 b2 fc ff ff       	call   80107060 <mappages>
    memmove(mem, init, sz);
801073ae:	89 75 10             	mov    %esi,0x10(%ebp)
801073b1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801073b4:	83 c4 10             	add    $0x10,%esp
801073b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801073ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073bd:	5b                   	pop    %ebx
801073be:	5e                   	pop    %esi
801073bf:	5f                   	pop    %edi
801073c0:	5d                   	pop    %ebp
    if (sz >= PGSIZE)
        panic("inituvm: more than a page");
    mem = kalloc();
    memset(mem, 0, PGSIZE);
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
    memmove(mem, init, sz);
801073c1:	e9 6a d9 ff ff       	jmp    80104d30 <memmove>
void
inituvm(pde_t *pgdir, char *init, uint sz) {
    char *mem;

    if (sz >= PGSIZE)
        panic("inituvm: more than a page");
801073c6:	83 ec 0c             	sub    $0xc,%esp
801073c9:	68 bd 87 10 80       	push   $0x801087bd
801073ce:	e8 9d 8f ff ff       	call   80100370 <panic>
801073d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073e0 <loaduvm>:
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 0c             	sub    $0xc,%esp
    uint i, pa, n;
    pte_t *pte;

    if ((uint) addr % PGSIZE != 0)
801073e9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801073f0:	0f 85 91 00 00 00    	jne    80107487 <loaduvm+0xa7>
        panic("loaduvm: addr must be page aligned");
    for (i = 0; i < sz; i += PGSIZE) {
801073f6:	8b 75 18             	mov    0x18(%ebp),%esi
801073f9:	31 db                	xor    %ebx,%ebx
801073fb:	85 f6                	test   %esi,%esi
801073fd:	75 1a                	jne    80107419 <loaduvm+0x39>
801073ff:	eb 6f                	jmp    80107470 <loaduvm+0x90>
80107401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107408:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010740e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107414:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107417:	76 57                	jbe    80107470 <loaduvm+0x90>
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
80107419:	8b 55 0c             	mov    0xc(%ebp),%edx
8010741c:	8b 45 08             	mov    0x8(%ebp),%eax
8010741f:	31 c9                	xor    %ecx,%ecx
80107421:	01 da                	add    %ebx,%edx
80107423:	e8 b8 fb ff ff       	call   80106fe0 <walkpgdir>
80107428:	85 c0                	test   %eax,%eax
8010742a:	74 4e                	je     8010747a <loaduvm+0x9a>
            panic("loaduvm: address should exist");
        pa = PTE_ADDR(*pte);
8010742c:	8b 00                	mov    (%eax),%eax
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, P2V(pa), offset + i, n) != n)
8010742e:	8b 4d 14             	mov    0x14(%ebp),%ecx
        panic("loaduvm: addr must be page aligned");
    for (i = 0; i < sz; i += PGSIZE) {
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
            panic("loaduvm: address should exist");
        pa = PTE_ADDR(*pte);
        if (sz - i < PGSIZE)
80107431:	bf 00 10 00 00       	mov    $0x1000,%edi
    if ((uint) addr % PGSIZE != 0)
        panic("loaduvm: addr must be page aligned");
    for (i = 0; i < sz; i += PGSIZE) {
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
            panic("loaduvm: address should exist");
        pa = PTE_ADDR(*pte);
80107436:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE)
8010743b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107441:	0f 46 fe             	cmovbe %esi,%edi
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, P2V(pa), offset + i, n) != n)
80107444:	01 d9                	add    %ebx,%ecx
80107446:	05 00 00 00 80       	add    $0x80000000,%eax
8010744b:	57                   	push   %edi
8010744c:	51                   	push   %ecx
8010744d:	50                   	push   %eax
8010744e:	ff 75 10             	pushl  0x10(%ebp)
80107451:	e8 2a a5 ff ff       	call   80101980 <readi>
80107456:	83 c4 10             	add    $0x10,%esp
80107459:	39 c7                	cmp    %eax,%edi
8010745b:	74 ab                	je     80107408 <loaduvm+0x28>
            return -1;
    }
    return 0;
}
8010745d:	8d 65 f4             	lea    -0xc(%ebp),%esp
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, P2V(pa), offset + i, n) != n)
            return -1;
80107460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    return 0;
}
80107465:	5b                   	pop    %ebx
80107466:	5e                   	pop    %esi
80107467:	5f                   	pop    %edi
80107468:	5d                   	pop    %ebp
80107469:	c3                   	ret    
8010746a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107470:	8d 65 f4             	lea    -0xc(%ebp),%esp
        else
            n = PGSIZE;
        if (readi(ip, P2V(pa), offset + i, n) != n)
            return -1;
    }
    return 0;
80107473:	31 c0                	xor    %eax,%eax
}
80107475:	5b                   	pop    %ebx
80107476:	5e                   	pop    %esi
80107477:	5f                   	pop    %edi
80107478:	5d                   	pop    %ebp
80107479:	c3                   	ret    

    if ((uint) addr % PGSIZE != 0)
        panic("loaduvm: addr must be page aligned");
    for (i = 0; i < sz; i += PGSIZE) {
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
            panic("loaduvm: address should exist");
8010747a:	83 ec 0c             	sub    $0xc,%esp
8010747d:	68 d7 87 10 80       	push   $0x801087d7
80107482:	e8 e9 8e ff ff       	call   80100370 <panic>
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
    uint i, pa, n;
    pte_t *pte;

    if ((uint) addr % PGSIZE != 0)
        panic("loaduvm: addr must be page aligned");
80107487:	83 ec 0c             	sub    $0xc,%esp
8010748a:	68 9c 88 10 80       	push   $0x8010889c
8010748f:	e8 dc 8e ff ff       	call   80100370 <panic>
80107494:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010749a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801074a0 <findFreeEntryInSwapFile>:
    }
    return 0;
}

int
findFreeEntryInSwapFile(struct proc *p) {
801074a0:	55                   	push   %ebp
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
801074a1:	31 c0                	xor    %eax,%eax
    }
    return 0;
}

int
findFreeEntryInSwapFile(struct proc *p) {
801074a3:	89 e5                	mov    %esp,%ebp
801074a5:	8b 55 08             	mov    0x8(%ebp),%edx
801074a8:	90                   	nop
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
        if (!p->swapFileEntries[i])
801074b0:	8b 8c 82 00 04 00 00 	mov    0x400(%edx,%eax,4),%ecx
801074b7:	85 c9                	test   %ecx,%ecx
801074b9:	74 0d                	je     801074c8 <findFreeEntryInSwapFile+0x28>
    return 0;
}

int
findFreeEntryInSwapFile(struct proc *p) {
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
801074bb:	83 c0 01             	add    $0x1,%eax
801074be:	83 f8 10             	cmp    $0x10,%eax
801074c1:	75 ed                	jne    801074b0 <findFreeEntryInSwapFile+0x10>
        if (!p->swapFileEntries[i])
            return i;
    }
    return -1;
801074c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074c8:	5d                   	pop    %ebp
801074c9:	c3                   	ret    
801074ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074d0 <swapOutPage>:

//TODO - make sure that before calling to this func to check:
//TODO - #if( defined(LIFO) || defined(SCFIFO))
void
swapOutPage(struct proc *p, pde_t *pgdir) {
801074d0:	55                   	push   %ebp
    return 0;
}

int
findFreeEntryInSwapFile(struct proc *p) {
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
801074d1:	31 c0                	xor    %eax,%eax
}

//TODO - make sure that before calling to this func to check:
//TODO - #if( defined(LIFO) || defined(SCFIFO))
void
swapOutPage(struct proc *p, pde_t *pgdir) {
801074d3:	89 e5                	mov    %esp,%ebp
801074d5:	57                   	push   %edi
801074d6:	56                   	push   %esi
801074d7:	53                   	push   %ebx
801074d8:	83 ec 1c             	sub    $0x1c,%esp
801074db:	8b 5d 08             	mov    0x8(%ebp),%ebx
801074de:	66 90                	xchg   %ax,%ax
}

int
findFreeEntryInSwapFile(struct proc *p) {
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
        if (!p->swapFileEntries[i])
801074e0:	8b b4 83 00 04 00 00 	mov    0x400(%ebx,%eax,4),%esi
801074e7:	85 f6                	test   %esi,%esi
801074e9:	74 4d                	je     80107538 <swapOutPage+0x68>
    return 0;
}

int
findFreeEntryInSwapFile(struct proc *p) {
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
801074eb:	83 c0 01             	add    $0x1,%eax
801074ee:	83 f8 10             	cmp    $0x10,%eax
801074f1:	75 ed                	jne    801074e0 <swapOutPage+0x10>
swapOutPage(struct proc *p, pde_t *pgdir) {
    pde_t *pgtble;
    struct page *pg = 0;
    int tmpOffset = findFreeEntryInSwapFile(p);
    if (tmpOffset == -1) {//validy check
        cprintf("p->entries:\t");
801074f3:	83 ec 0c             	sub    $0xc,%esp
801074f6:	8d b3 00 04 00 00    	lea    0x400(%ebx),%esi
801074fc:	81 c3 40 04 00 00    	add    $0x440,%ebx
80107502:	68 fa 87 10 80       	push   $0x801087fa
80107507:	e8 54 91 ff ff       	call   80100660 <cprintf>
8010750c:	83 c4 10             	add    $0x10,%esp
        for (int i = 0; i < MAX_PSYC_PAGES; i++) {

            cprintf("%d  ", p->swapFileEntries[i]);
8010750f:	83 ec 08             	sub    $0x8,%esp
80107512:	ff 36                	pushl  (%esi)
80107514:	83 c6 04             	add    $0x4,%esi
80107517:	68 f5 87 10 80       	push   $0x801087f5
8010751c:	e8 3f 91 ff ff       	call   80100660 <cprintf>
    pde_t *pgtble;
    struct page *pg = 0;
    int tmpOffset = findFreeEntryInSwapFile(p);
    if (tmpOffset == -1) {//validy check
        cprintf("p->entries:\t");
        for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80107521:	83 c4 10             	add    $0x10,%esp
80107524:	39 f3                	cmp    %esi,%ebx
80107526:	75 e7                	jne    8010750f <swapOutPage+0x3f>

            cprintf("%d  ", p->swapFileEntries[i]);
        }
        panic("ERROR - there is no free entry in p->swapFileEntries!\n");
80107528:	83 ec 0c             	sub    $0xc,%esp
8010752b:	68 c0 88 10 80       	push   $0x801088c0
80107530:	e8 3b 8e ff ff       	call   80100370 <panic>
80107535:	8d 76 00             	lea    0x0(%esi),%esi
80107538:	89 45 e0             	mov    %eax,-0x20(%ebp)

//#endif


#elif(defined(SCFIFO))
    int minSeq = p->pagesequel, found = 0;
8010753b:	8b bb 4c 04 00 00    	mov    0x44c(%ebx),%edi
        }
        panic("ERROR - there is no free entry in p->swapFileEntries!\n");

    }

    int swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
80107541:	c1 e0 0c             	shl    $0xc,%eax
80107544:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    char *tmpAdress;
    pde_t *tmppgtble;
    struct page *sg;
    while (!found) {
        //find page with min pagesequel
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
80107547:	8d 93 00 04 00 00    	lea    0x400(%ebx),%edx
8010754d:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80107553:	31 f6                	xor    %esi,%esi
80107555:	8d 76 00             	lea    0x0(%esi),%esi
            if (sg->active && sg->present && sg->sequel < minSeq) {
80107558:	8b 08                	mov    (%eax),%ecx
8010755a:	85 c9                	test   %ecx,%ecx
8010755c:	74 12                	je     80107570 <swapOutPage+0xa0>
8010755e:	8b 48 0c             	mov    0xc(%eax),%ecx
80107561:	85 c9                	test   %ecx,%ecx
80107563:	74 0b                	je     80107570 <swapOutPage+0xa0>
80107565:	8b 48 08             	mov    0x8(%eax),%ecx
80107568:	39 f9                	cmp    %edi,%ecx
8010756a:	7d 04                	jge    80107570 <swapOutPage+0xa0>
8010756c:	89 cf                	mov    %ecx,%edi
8010756e:	89 c6                	mov    %eax,%esi
    char *tmpAdress;
    pde_t *tmppgtble;
    struct page *sg;
    while (!found) {
        //find page with min pagesequel
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
80107570:	83 c0 1c             	add    $0x1c,%eax
80107573:	39 d0                	cmp    %edx,%eax
80107575:	72 e1                	jb     80107558 <swapOutPage+0x88>
                minSeq = sg->sequel;
            }
        }
        //got here- pg have the min pagesequel
        tmpAdress = pg->virtAdress;
        tmppgtble = walkpgdir(pgdir, tmpAdress, 0);
80107577:	8b 56 18             	mov    0x18(%esi),%edx
8010757a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010757d:	31 c9                	xor    %ecx,%ecx
8010757f:	e8 5c fa ff ff       	call   80106fe0 <walkpgdir>
        if (*tmppgtble & PTE_A) { //if legal addr and acces bit is on - move to end of page queue
80107584:	8b 10                	mov    (%eax),%edx
80107586:	f6 c2 20             	test   $0x20,%dl
80107589:	0f 84 9d 00 00 00    	je     8010762c <swapOutPage+0x15c>
            *tmppgtble = PTE_A_0(*tmppgtble);
8010758f:	83 e2 df             	and    $0xffffffdf,%edx
#endif

    //got here - pg is the page to swap out (in both cases)

    //write the page to swapFile
    writeToSwapFile(p, pg->physAdress, (uint) swapWriteOffset, PGSIZE);
80107592:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        }
        //got here- pg have the min pagesequel
        tmpAdress = pg->virtAdress;
        tmppgtble = walkpgdir(pgdir, tmpAdress, 0);
        if (*tmppgtble & PTE_A) { //if legal addr and acces bit is on - move to end of page queue
            *tmppgtble = PTE_A_0(*tmppgtble);
80107595:	89 10                	mov    %edx,(%eax)
            pg->sequel = p->pagesequel++;
80107597:	8b 83 4c 04 00 00    	mov    0x44c(%ebx),%eax
8010759d:	8d 50 01             	lea    0x1(%eax),%edx
801075a0:	89 93 4c 04 00 00    	mov    %edx,0x44c(%ebx)
801075a6:	89 46 08             	mov    %eax,0x8(%esi)
#endif

    //got here - pg is the page to swap out (in both cases)

    //write the page to swapFile
    writeToSwapFile(p, pg->physAdress, (uint) swapWriteOffset, PGSIZE);
801075a9:	68 00 10 00 00       	push   $0x1000
801075ae:	57                   	push   %edi
801075af:	ff 76 14             	pushl  0x14(%esi)
801075b2:	53                   	push   %ebx
801075b3:	e8 b8 ac ff ff       	call   80102270 <writeToSwapFile>
    pg->physAdress = 0;
    pg->sequel = 0;

    //must update page swapping for proc.

    p->swapFileEntries[tmpOffset] = 1; //update that this entry is swapped out
801075b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    //got here - pg is the page to swap out (in both cases)

    //write the page to swapFile
    writeToSwapFile(p, pg->physAdress, (uint) swapWriteOffset, PGSIZE);
    //update page
    pg->present = 0;
801075bb:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    p->swapFileEntries[tmpOffset] = 1; //update that this entry is swapped out
    p->totalPagesInSwap++;
    p->pagesinSwap++;

    //update pte
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
801075c2:	31 c9                	xor    %ecx,%ecx

    //write the page to swapFile
    writeToSwapFile(p, pg->physAdress, (uint) swapWriteOffset, PGSIZE);
    //update page
    pg->present = 0;
    pg->offset = (uint) swapWriteOffset;
801075c4:	89 7e 10             	mov    %edi,0x10(%esi)
    pg->physAdress = 0;
801075c7:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
    pg->sequel = 0;
801075ce:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)

    //must update page swapping for proc.

    p->swapFileEntries[tmpOffset] = 1; //update that this entry is swapped out
801075d5:	c7 84 83 00 04 00 00 	movl   $0x1,0x400(%ebx,%eax,4)
801075dc:	01 00 00 00 
    p->totalPagesInSwap++;
801075e0:	83 83 58 04 00 00 01 	addl   $0x1,0x458(%ebx)
    p->pagesinSwap++;
801075e7:	83 83 48 04 00 00 01 	addl   $0x1,0x448(%ebx)

    //update pte
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
801075ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801075f1:	8b 56 18             	mov    0x18(%esi),%edx
801075f4:	e8 e7 f9 ff ff       	call   80106fe0 <walkpgdir>
    *pgtble = PTE_P_0(*pgtble);
801075f9:	8b 10                	mov    (%eax),%edx
    *pgtble = PTE_PG_1(*pgtble);
801075fb:	89 d1                	mov    %edx,%ecx
    kfree(P2V(PTE_ADDR(*pgtble)));
801075fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    p->pagesinSwap++;

    //update pte
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
    *pgtble = PTE_P_0(*pgtble);
    *pgtble = PTE_PG_1(*pgtble);
80107603:	83 e1 fe             	and    $0xfffffffe,%ecx
    kfree(P2V(PTE_ADDR(*pgtble)));
80107606:	81 c2 00 00 00 80    	add    $0x80000000,%edx
    p->pagesinSwap++;

    //update pte
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
    *pgtble = PTE_P_0(*pgtble);
    *pgtble = PTE_PG_1(*pgtble);
8010760c:	80 cd 02             	or     $0x2,%ch
8010760f:	89 08                	mov    %ecx,(%eax)
    kfree(P2V(PTE_ADDR(*pgtble)));
80107611:	89 14 24             	mov    %edx,(%esp)
80107614:	e8 07 b1 ff ff       	call   80102720 <kfree>
80107619:	8b 43 04             	mov    0x4(%ebx),%eax
8010761c:	05 00 00 00 80       	add    $0x80000000,%eax
80107621:	0f 22 d8             	mov    %eax,%cr3
    lcr3(V2P(p->pgdir));
}
80107624:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107627:	5b                   	pop    %ebx
80107628:	5e                   	pop    %esi
80107629:	5f                   	pop    %edi
8010762a:	5d                   	pop    %ebp
8010762b:	c3                   	ret    
        //TODO - from here possible change
        else {
            if (*tmppgtble & !PTE_A) //if legal addr and bit is off - this is the page to swap out
                found = 1;
            else
                panic("Error - tmppgtble = walkpgdir(pgdir, tmpAdress, 0);\n");
8010762c:	83 ec 0c             	sub    $0xc,%esp
8010762f:	68 f8 88 10 80       	push   $0x801088f8
80107634:	e8 37 8d ff ff       	call   80100370 <panic>
80107639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107640 <deallocuvm>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int growproc) {
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	57                   	push   %edi
80107644:	56                   	push   %esi
80107645:	53                   	push   %ebx
80107646:	83 ec 1c             	sub    $0x1c,%esp
        cprintf("DEALLOCUVM-");
    pte_t *pte;
    uint a, pa;
#if(defined(LIFO) || defined(SCFIFO))
    struct page *pg;
        struct proc *p = myproc();
80107649:	e8 42 c6 ff ff       	call   80103c90 <myproc>
8010764e:	89 45 e0             	mov    %eax,-0x20(%ebp)
#endif
    if (newsz >= oldsz) {
80107651:	8b 45 0c             	mov    0xc(%ebp),%eax
80107654:	39 45 10             	cmp    %eax,0x10(%ebp)
80107657:	0f 83 c1 00 00 00    	jae    8010771e <deallocuvm+0xde>
        if (DEBUGMODE == 2 && notShell())
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
8010765d:	8b 45 10             	mov    0x10(%ebp),%eax
80107660:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
                    pa = PTE_ADDR(*pte);
                    if (pa == 0)
                        panic("kfree");
                    if (p->pid > 2 && growproc) {
                        //scan pages table and remove page that page.virtAdress == a
                        for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107666:	8b 45 e0             	mov    -0x20(%ebp),%eax
        if (DEBUGMODE == 2 && notShell())
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
80107669:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; a < oldsz; a += PGSIZE) {
8010766f:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
                    pa = PTE_ADDR(*pte);
                    if (pa == 0)
                        panic("kfree");
                    if (p->pid > 2 && growproc) {
                        //scan pages table and remove page that page.virtAdress == a
                        for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107672:	8d b8 00 04 00 00    	lea    0x400(%eax),%edi
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
    for (; a < oldsz; a += PGSIZE) {
80107678:	0f 86 9d 00 00 00    	jbe    8010771b <deallocuvm+0xdb>
8010767e:	66 90                	xchg   %ax,%ax
        pte = walkpgdir(pgdir, (char *) a, 0);
80107680:	8b 45 08             	mov    0x8(%ebp),%eax
80107683:	31 c9                	xor    %ecx,%ecx
80107685:	89 da                	mov    %ebx,%edx
80107687:	e8 54 f9 ff ff       	call   80106fe0 <walkpgdir>
        if (!pte)
8010768c:	85 c0                	test   %eax,%eax
8010768e:	0f 84 0c 01 00 00    	je     801077a0 <deallocuvm+0x160>
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        else if ((*pte & PTE_P) != 0) {
80107694:	8b 30                	mov    (%eax),%esi
80107696:	f7 c6 01 00 00 00    	test   $0x1,%esi
8010769c:	0f 84 8e 00 00 00    	je     80107730 <deallocuvm+0xf0>
            pa = PTE_ADDR(*pte);
            if (pa == 0)
801076a2:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801076a8:	0f 84 34 01 00 00    	je     801077e2 <deallocuvm+0x1a2>
801076ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                panic("kfree");


#if(defined(LIFO) || defined(SCFIFO))
            if (notShell() && growproc) {
801076b1:	e8 fa c4 ff ff       	call   80103bb0 <notShell>
801076b6:	8b 55 14             	mov    0x14(%ebp),%edx
801076b9:	85 d2                	test   %edx,%edx
801076bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076be:	74 2e                	je     801076ee <deallocuvm+0xae>
801076c0:	85 c0                	test   %eax,%eax
801076c2:	74 2a                	je     801076ee <deallocuvm+0xae>
                    //scan pages table and remove page that page.virtAdress == a
                    for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801076c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076c7:	83 e8 80             	sub    $0xffffff80,%eax
801076ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                        if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
801076d0:	8b 08                	mov    (%eax),%ecx
801076d2:	85 c9                	test   %ecx,%ecx
801076d4:	74 09                	je     801076df <deallocuvm+0x9f>
801076d6:	3b 58 18             	cmp    0x18(%eax),%ebx
801076d9:	0f 84 d9 00 00 00    	je     801077b8 <deallocuvm+0x178>


#if(defined(LIFO) || defined(SCFIFO))
            if (notShell() && growproc) {
                    //scan pages table and remove page that page.virtAdress == a
                    for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801076df:	83 c0 1c             	add    $0x1c,%eax
801076e2:	39 f8                	cmp    %edi,%eax
801076e4:	72 ea                	jb     801076d0 <deallocuvm+0x90>
                            //update proc
                            p->pagesCounter--;
                            break;
                        }
                    }
                    if (pg == &p->pages[MAX_TOTAL_PAGES])//if true ->didn't find the virtAdress
801076e6:	39 f8                	cmp    %edi,%eax
801076e8:	0f 84 01 01 00 00    	je     801077ef <deallocuvm+0x1af>
                }
#endif


            char *v = P2V(pa);
            kfree(v);
801076ee:	83 ec 0c             	sub    $0xc,%esp
801076f1:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801076f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801076fa:	56                   	push   %esi
801076fb:	e8 20 b0 ff ff       	call   80102720 <kfree>
            *pte = 0;
80107700:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107703:	83 c4 10             	add    $0x10,%esp
80107706:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
    for (; a < oldsz; a += PGSIZE) {
8010770c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107712:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107715:	0f 87 65 ff ff ff    	ja     80107680 <deallocuvm+0x40>
#endif
        }
    }
    if (DEBUGMODE == 2 && notShell())
        cprintf(">DEALLOCUVM-DONE!\t");
    return newsz;
8010771b:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010771e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107721:	5b                   	pop    %ebx
80107722:	5e                   	pop    %esi
80107723:	5f                   	pop    %edi
80107724:	5d                   	pop    %ebp
80107725:	c3                   	ret    
80107726:	8d 76 00             	lea    0x0(%esi),%esi
80107729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            char *v = P2V(pa);
            kfree(v);
            *pte = 0;
        } else {
#if(defined(LIFO) || defined(SCFIFO))
            if ((*pte & PTE_PG) != 0) {
80107730:	f7 c6 00 02 00 00    	test   $0x200,%esi
80107736:	74 d4                	je     8010770c <deallocuvm+0xcc>
                    pa = PTE_ADDR(*pte);
                    if (pa == 0)
80107738:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
8010773e:	0f 84 9e 00 00 00    	je     801077e2 <deallocuvm+0x1a2>
                        panic("kfree");
                    if (p->pid > 2 && growproc) {
80107744:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107747:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010774b:	7e bf                	jle    8010770c <deallocuvm+0xcc>
8010774d:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107750:	85 c9                	test   %ecx,%ecx
80107752:	74 b8                	je     8010770c <deallocuvm+0xcc>
                        //scan pages table and remove page that page.virtAdress == a
                        for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107754:	83 e8 80             	sub    $0xffffff80,%eax
80107757:	eb 0e                	jmp    80107767 <deallocuvm+0x127>
80107759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107760:	83 c0 1c             	add    $0x1c,%eax
80107763:	39 f8                	cmp    %edi,%eax
80107765:	73 a5                	jae    8010770c <deallocuvm+0xcc>
                            if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
80107767:	8b 10                	mov    (%eax),%edx
80107769:	85 d2                	test   %edx,%edx
8010776b:	74 f3                	je     80107760 <deallocuvm+0x120>
8010776d:	3b 58 18             	cmp    0x18(%eax),%ebx
80107770:	75 ee                	jne    80107760 <deallocuvm+0x120>
                            {
                                //remove page
                                pg->virtAdress = 0;
80107772:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
                                pg->active = 0;
80107779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                                pg->offset = 0;      //TODO - check if there is a need to save offset
8010777f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                                pg->present = 0;
80107786:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

                                //update proc
                                p->pagesCounter--;
8010778d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107790:	83 a8 44 04 00 00 01 	subl   $0x1,0x444(%eax)
                                break;
80107797:	e9 70 ff ff ff       	jmp    8010770c <deallocuvm+0xcc>
8010779c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    a = PGROUNDUP(newsz);
    for (; a < oldsz; a += PGSIZE) {
        pte = walkpgdir(pgdir, (char *) a, 0);
        if (!pte)
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801077a0:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801077a6:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
801077ac:	e9 5b ff ff ff       	jmp    8010770c <deallocuvm+0xcc>
801077b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                            pg->active = 0;
                            pg->offset = 0;      //TODO - check if there is a need to save offset
                            pg->present = 0;

                            //update proc
                            p->pagesCounter--;
801077b8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
                    //scan pages table and remove page that page.virtAdress == a
                    for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
                        if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
                        {
                            //remove page
                            pg->virtAdress = 0;
801077bb:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
                            pg->active = 0;
801077c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                            pg->offset = 0;      //TODO - check if there is a need to save offset
801077c8:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                            pg->present = 0;
801077cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

                            //update proc
                            p->pagesCounter--;
801077d6:	83 a9 44 04 00 00 01 	subl   $0x1,0x444(%ecx)
                            break;
801077dd:	e9 04 ff ff ff       	jmp    801076e6 <deallocuvm+0xa6>
        if (!pte)
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        else if ((*pte & PTE_P) != 0) {
            pa = PTE_ADDR(*pte);
            if (pa == 0)
                panic("kfree");
801077e2:	83 ec 0c             	sub    $0xc,%esp
801077e5:	68 ea 7f 10 80       	push   $0x80107fea
801077ea:	e8 81 8b ff ff       	call   80100370 <panic>
                            p->pagesCounter--;
                            break;
                        }
                    }
                    if (pg == &p->pages[MAX_TOTAL_PAGES])//if true ->didn't find the virtAdress
                        panic("deallocuvm Error - didn't find the virtAdress!");
801077ef:	83 ec 0c             	sub    $0xc,%esp
801077f2:	68 30 89 10 80       	push   $0x80108930
801077f7:	e8 74 8b ff ff       	call   80100370 <panic>
801077fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107800 <allocuvm>:


// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	57                   	push   %edi
80107804:	56                   	push   %esi
80107805:	53                   	push   %ebx
80107806:	83 ec 1c             	sub    $0x1c,%esp
        cprintf("ALLOCUVM-");
    char *mem;
    uint a;
#if(defined(LIFO) || defined(SCFIFO))
    pde_t *pgtble;
    struct proc *p = myproc();
80107809:	e8 82 c4 ff ff       	call   80103c90 <myproc>
    struct page *pg = 0;
#endif

    if (newsz >= KERNBASE)
8010780e:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107811:	85 c9                	test   %ecx,%ecx
80107813:	0f 88 af 01 00 00    	js     801079c8 <allocuvm+0x1c8>
80107819:	89 c6                	mov    %eax,%esi
        return 0;
    if (newsz < oldsz)
8010781b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010781e:	39 45 10             	cmp    %eax,0x10(%ebp)
80107821:	0f 82 47 01 00 00    	jb     8010796e <allocuvm+0x16e>
        return oldsz;

    a = PGROUNDUP(oldsz);
80107827:	8b 45 0c             	mov    0xc(%ebp),%eax
8010782a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010782f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    for (; a < newsz; a += PGSIZE) {
80107834:	39 45 10             	cmp    %eax,0x10(%ebp)
    if (newsz >= KERNBASE)
        return 0;
    if (newsz < oldsz)
        return oldsz;

    a = PGROUNDUP(oldsz);
80107837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (; a < newsz; a += PGSIZE) {
8010783a:	0f 86 2b 01 00 00    	jbe    8010796b <allocuvm+0x16b>
        }

#if(defined(LIFO) || defined(SCFIFO))
        if (notShell()) {
            //INIT PAGE STRUCT
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107840:	8d 9e 00 04 00 00    	lea    0x400(%esi),%ebx
80107846:	8d 76 00             	lea    0x0(%esi),%esi
80107849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    a = PGROUNDUP(oldsz);
    for (; a < newsz; a += PGSIZE) {
        // TODO HERE WE CREATE PYSYC MEMORY;
        // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
        // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.
        if (notShell()) {
80107850:	e8 5b c3 ff ff       	call   80103bb0 <notShell>
80107855:	85 c0                	test   %eax,%eax
80107857:	74 24                	je     8010787d <allocuvm+0x7d>
#if(defined(LIFO) || defined(SCFIFO))
            if (p->pagesCounter == MAX_TOTAL_PAGES)
80107859:	8b 86 44 04 00 00    	mov    0x444(%esi),%eax
8010785f:	83 f8 20             	cmp    $0x20,%eax
80107862:	0f 84 aa 01 00 00    	je     80107a12 <allocuvm+0x212>
                panic("got 32 pages and requested for another page!");

    //    cprintf("p->pagesCounter=%d\tp->pagesinSwap=%d\tMAX_PSYC_PAGES=%d\n",p->pagesCounter , p->pagesinSwap , MAX_PSYC_PAGES);
            // if number of pages overall minus pages in swap is more than 16 we have prob
            if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2) {
80107868:	2b 86 48 04 00 00    	sub    0x448(%esi),%eax
8010786e:	83 f8 0f             	cmp    $0xf,%eax
80107871:	7e 0a                	jle    8010787d <allocuvm+0x7d>
80107873:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80107877:	0f 8f 03 01 00 00    	jg     80107980 <allocuvm+0x180>
                swapOutPage(p, pgdir); //this func includes remove page, update proc and update PTE
            }
#endif
        }

        mem = kalloc();
8010787d:	e8 4e b0 ff ff       	call   801028d0 <kalloc>
        if (mem == 0) {
80107882:	85 c0                	test   %eax,%eax
                swapOutPage(p, pgdir); //this func includes remove page, update proc and update PTE
            }
#endif
        }

        mem = kalloc();
80107884:	89 c7                	mov    %eax,%edi
        if (mem == 0) {
80107886:	0f 84 12 01 00 00    	je     8010799e <allocuvm+0x19e>
            deallocuvm(pgdir, newsz, oldsz, 0);
            if (DEBUGMODE == 2 && notShell())
                cprintf(">ALLOCUVM-FAILED-mem == 0\t");
            return 0;
        }
        memset(mem, 0, PGSIZE);
8010788c:	83 ec 04             	sub    $0x4,%esp
8010788f:	68 00 10 00 00       	push   $0x1000
80107894:	6a 00                	push   $0x0
80107896:	50                   	push   %eax
80107897:	e8 e4 d3 ff ff       	call   80104c80 <memset>
        if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
8010789c:	58                   	pop    %eax
8010789d:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801078a3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078a8:	5a                   	pop    %edx
801078a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801078ac:	6a 06                	push   $0x6
801078ae:	50                   	push   %eax
801078af:	8b 45 08             	mov    0x8(%ebp),%eax
801078b2:	e8 a9 f7 ff ff       	call   80107060 <mappages>
801078b7:	83 c4 10             	add    $0x10,%esp
801078ba:	85 c0                	test   %eax,%eax
801078bc:	0f 88 10 01 00 00    	js     801079d2 <allocuvm+0x1d2>
                cprintf(">ALLOCUVM-FAILED-mappages<0\t");
            return 0;
        }

#if(defined(LIFO) || defined(SCFIFO))
        if (notShell()) {
801078c2:	e8 e9 c2 ff ff       	call   80103bb0 <notShell>
801078c7:	85 c0                	test   %eax,%eax
801078c9:	0f 84 89 00 00 00    	je     80107958 <allocuvm+0x158>
            //INIT PAGE STRUCT
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
                if (!pg->active)
801078cf:	8b 8e 80 00 00 00    	mov    0x80(%esi),%ecx
        }

#if(defined(LIFO) || defined(SCFIFO))
        if (notShell()) {
            //INIT PAGE STRUCT
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801078d5:	8d 86 80 00 00 00    	lea    0x80(%esi),%eax
                if (!pg->active)
801078db:	85 c9                	test   %ecx,%ecx
801078dd:	74 12                	je     801078f1 <allocuvm+0xf1>
801078df:	90                   	nop
        }

#if(defined(LIFO) || defined(SCFIFO))
        if (notShell()) {
            //INIT PAGE STRUCT
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801078e0:	83 c0 1c             	add    $0x1c,%eax
801078e3:	39 d8                	cmp    %ebx,%eax
801078e5:	0f 83 1a 01 00 00    	jae    80107a05 <allocuvm+0x205>
                if (!pg->active)
801078eb:	8b 10                	mov    (%eax),%edx
801078ed:	85 d2                	test   %edx,%edx
801078ef:	75 ef                	jne    801078e0 <allocuvm+0xe0>
            }

            panic("no page in proc");

            foundpage:
            p->pagesCounter++;
801078f1:	83 86 44 04 00 00 01 	addl   $0x1,0x444(%esi)
            pg->active = 1;
801078f8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
            pg->pageid = p->nextpageid++;
801078fe:	8b 96 40 04 00 00    	mov    0x440(%esi),%edx
80107904:	8d 4a 01             	lea    0x1(%edx),%ecx
80107907:	89 8e 40 04 00 00    	mov    %ecx,0x440(%esi)
8010790d:	89 50 04             	mov    %edx,0x4(%eax)
            pg->present = 1;
80107910:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
            pg->offset = 0;
80107917:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
            pg->sequel = p->pagesequel++;
8010791e:	8b 96 4c 04 00 00    	mov    0x44c(%esi),%edx
80107924:	8d 4a 01             	lea    0x1(%edx),%ecx
80107927:	89 8e 4c 04 00 00    	mov    %ecx,0x44c(%esi)
8010792d:	89 50 08             	mov    %edx,0x8(%eax)
            pg->physAdress = mem;
            pg->virtAdress = (char *) a;

            //update pte of the page
            pgtble = walkpgdir(pgdir, (char *) a, 0);
80107930:	31 c9                	xor    %ecx,%ecx
            pg->pageid = p->nextpageid++;
            pg->present = 1;
            pg->offset = 0;
            pg->sequel = p->pagesequel++;
            pg->physAdress = mem;
            pg->virtAdress = (char *) a;
80107932:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            pg->active = 1;
            pg->pageid = p->nextpageid++;
            pg->present = 1;
            pg->offset = 0;
            pg->sequel = p->pagesequel++;
            pg->physAdress = mem;
80107935:	89 78 14             	mov    %edi,0x14(%eax)
            pg->virtAdress = (char *) a;
80107938:	89 50 18             	mov    %edx,0x18(%eax)

            //update pte of the page
            pgtble = walkpgdir(pgdir, (char *) a, 0);
8010793b:	8b 45 08             	mov    0x8(%ebp),%eax
8010793e:	e8 9d f6 ff ff       	call   80106fe0 <walkpgdir>
            *pgtble = PTE_P_1(*pgtble);  // Present
            *pgtble = PTE_PG_0(*pgtble); // Not Paged out to secondary storage
80107943:	8b 10                	mov    (%eax),%edx
80107945:	80 e6 fd             	and    $0xfd,%dh
80107948:	83 ca 01             	or     $0x1,%edx
8010794b:	89 10                	mov    %edx,(%eax)
8010794d:	8b 46 04             	mov    0x4(%esi),%eax
80107950:	05 00 00 00 80       	add    $0x80000000,%eax
80107955:	0f 22 d8             	mov    %eax,%cr3
        return 0;
    if (newsz < oldsz)
        return oldsz;

    a = PGROUNDUP(oldsz);
    for (; a < newsz; a += PGSIZE) {
80107958:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
8010795f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107962:	39 45 10             	cmp    %eax,0x10(%ebp)
80107965:	0f 87 e5 fe ff ff    	ja     80107850 <allocuvm+0x50>
8010796b:	8b 45 10             	mov    0x10(%ebp),%eax
    }

    if (DEBUGMODE == 2 && notShell())
        cprintf(">ALLOCUVM-DONE!\t");
    return newsz;
}
8010796e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107971:	5b                   	pop    %ebx
80107972:	5e                   	pop    %esi
80107973:	5f                   	pop    %edi
80107974:	5d                   	pop    %ebp
80107975:	c3                   	ret    
80107976:	8d 76 00             	lea    0x0(%esi),%esi
80107979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    //    cprintf("p->pagesCounter=%d\tp->pagesinSwap=%d\tMAX_PSYC_PAGES=%d\n",p->pagesCounter , p->pagesinSwap , MAX_PSYC_PAGES);
            // if number of pages overall minus pages in swap is more than 16 we have prob
            if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2) {
                //find the page to swap out
                //got here - the page to swat out is pg
                swapOutPage(p, pgdir); //this func includes remove page, update proc and update PTE
80107980:	83 ec 08             	sub    $0x8,%esp
80107983:	ff 75 08             	pushl  0x8(%ebp)
80107986:	56                   	push   %esi
80107987:	e8 44 fb ff ff       	call   801074d0 <swapOutPage>
8010798c:	83 c4 10             	add    $0x10,%esp
            }
#endif
        }

        mem = kalloc();
8010798f:	e8 3c af ff ff       	call   801028d0 <kalloc>
        if (mem == 0) {
80107994:	85 c0                	test   %eax,%eax
                swapOutPage(p, pgdir); //this func includes remove page, update proc and update PTE
            }
#endif
        }

        mem = kalloc();
80107996:	89 c7                	mov    %eax,%edi
        if (mem == 0) {
80107998:	0f 85 ee fe ff ff    	jne    8010788c <allocuvm+0x8c>
            cprintf("allocuvm out of memory\n");
8010799e:	83 ec 0c             	sub    $0xc,%esp
801079a1:	68 07 88 10 80       	push   $0x80108807
801079a6:	e8 b5 8c ff ff       	call   80100660 <cprintf>
            deallocuvm(pgdir, newsz, oldsz, 0);
801079ab:	6a 00                	push   $0x0
801079ad:	ff 75 0c             	pushl  0xc(%ebp)
801079b0:	ff 75 10             	pushl  0x10(%ebp)
801079b3:	ff 75 08             	pushl  0x8(%ebp)
801079b6:	e8 85 fc ff ff       	call   80107640 <deallocuvm>
            if (DEBUGMODE == 2 && notShell())
                cprintf(">ALLOCUVM-FAILED-mem == 0\t");
            return 0;
801079bb:	83 c4 20             	add    $0x20,%esp
    }

    if (DEBUGMODE == 2 && notShell())
        cprintf(">ALLOCUVM-DONE!\t");
    return newsz;
}
801079be:	8d 65 f4             	lea    -0xc(%ebp),%esp
        if (mem == 0) {
            cprintf("allocuvm out of memory\n");
            deallocuvm(pgdir, newsz, oldsz, 0);
            if (DEBUGMODE == 2 && notShell())
                cprintf(">ALLOCUVM-FAILED-mem == 0\t");
            return 0;
801079c1:	31 c0                	xor    %eax,%eax
    }

    if (DEBUGMODE == 2 && notShell())
        cprintf(">ALLOCUVM-DONE!\t");
    return newsz;
}
801079c3:	5b                   	pop    %ebx
801079c4:	5e                   	pop    %esi
801079c5:	5f                   	pop    %edi
801079c6:	5d                   	pop    %ebp
801079c7:	c3                   	ret    
801079c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    struct proc *p = myproc();
    struct page *pg = 0;
#endif

    if (newsz >= KERNBASE)
        return 0;
801079cb:	31 c0                	xor    %eax,%eax
    }

    if (DEBUGMODE == 2 && notShell())
        cprintf(">ALLOCUVM-DONE!\t");
    return newsz;
}
801079cd:	5b                   	pop    %ebx
801079ce:	5e                   	pop    %esi
801079cf:	5f                   	pop    %edi
801079d0:	5d                   	pop    %ebp
801079d1:	c3                   	ret    
                cprintf(">ALLOCUVM-FAILED-mem == 0\t");
            return 0;
        }
        memset(mem, 0, PGSIZE);
        if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
            cprintf("allocuvm out of memory (2)\n");
801079d2:	83 ec 0c             	sub    $0xc,%esp
801079d5:	68 1f 88 10 80       	push   $0x8010881f
801079da:	e8 81 8c ff ff       	call   80100660 <cprintf>
            deallocuvm(pgdir, newsz, oldsz, 0);
801079df:	6a 00                	push   $0x0
801079e1:	ff 75 0c             	pushl  0xc(%ebp)
801079e4:	ff 75 10             	pushl  0x10(%ebp)
801079e7:	ff 75 08             	pushl  0x8(%ebp)
801079ea:	e8 51 fc ff ff       	call   80107640 <deallocuvm>
            kfree(mem);
801079ef:	83 c4 14             	add    $0x14,%esp
801079f2:	57                   	push   %edi
801079f3:	e8 28 ad ff ff       	call   80102720 <kfree>
            if (DEBUGMODE == 2 && notShell())
                cprintf(">ALLOCUVM-FAILED-mappages<0\t");
            return 0;
801079f8:	83 c4 10             	add    $0x10,%esp
    }

    if (DEBUGMODE == 2 && notShell())
        cprintf(">ALLOCUVM-DONE!\t");
    return newsz;
}
801079fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
            cprintf("allocuvm out of memory (2)\n");
            deallocuvm(pgdir, newsz, oldsz, 0);
            kfree(mem);
            if (DEBUGMODE == 2 && notShell())
                cprintf(">ALLOCUVM-FAILED-mappages<0\t");
            return 0;
801079fe:	31 c0                	xor    %eax,%eax
    }

    if (DEBUGMODE == 2 && notShell())
        cprintf(">ALLOCUVM-DONE!\t");
    return newsz;
}
80107a00:	5b                   	pop    %ebx
80107a01:	5e                   	pop    %esi
80107a02:	5f                   	pop    %edi
80107a03:	5d                   	pop    %ebp
80107a04:	c3                   	ret    
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
                if (!pg->active)
                    goto foundpage;
            }

            panic("no page in proc");
80107a05:	83 ec 0c             	sub    $0xc,%esp
80107a08:	68 3b 88 10 80       	push   $0x8010883b
80107a0d:	e8 5e 89 ff ff       	call   80100370 <panic>
        // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
        // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.
        if (notShell()) {
#if(defined(LIFO) || defined(SCFIFO))
            if (p->pagesCounter == MAX_TOTAL_PAGES)
                panic("got 32 pages and requested for another page!");
80107a12:	83 ec 0c             	sub    $0xc,%esp
80107a15:	68 60 89 10 80       	push   $0x80108960
80107a1a:	e8 51 89 ff ff       	call   80100370 <panic>
80107a1f:	90                   	nop

80107a20 <freevm>:
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir) {
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
80107a23:	57                   	push   %edi
80107a24:	56                   	push   %esi
80107a25:	53                   	push   %ebx
80107a26:	83 ec 0c             	sub    $0xc,%esp
80107a29:	8b 75 08             	mov    0x8(%ebp),%esi
    if (DEBUGMODE == 2 && notShell())
        cprintf("FREEVM");
    uint i;

    if (pgdir == 0)
80107a2c:	85 f6                	test   %esi,%esi
80107a2e:	74 59                	je     80107a89 <freevm+0x69>
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0, 0);
80107a30:	6a 00                	push   $0x0
80107a32:	6a 00                	push   $0x0
80107a34:	89 f3                	mov    %esi,%ebx
80107a36:	68 00 00 00 80       	push   $0x80000000
80107a3b:	56                   	push   %esi
80107a3c:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107a42:	e8 f9 fb ff ff       	call   80107640 <deallocuvm>
80107a47:	83 c4 10             	add    $0x10,%esp
80107a4a:	eb 0b                	jmp    80107a57 <freevm+0x37>
80107a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a50:	83 c3 04             	add    $0x4,%ebx
    for (i = 0; i < NPDENTRIES; i++) {
80107a53:	39 fb                	cmp    %edi,%ebx
80107a55:	74 23                	je     80107a7a <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
80107a57:	8b 03                	mov    (%ebx),%eax
80107a59:	a8 01                	test   $0x1,%al
80107a5b:	74 f3                	je     80107a50 <freevm+0x30>
            char *v = P2V(PTE_ADDR(pgdir[i]));
            kfree(v);
80107a5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a62:	83 ec 0c             	sub    $0xc,%esp
80107a65:	83 c3 04             	add    $0x4,%ebx
80107a68:	05 00 00 00 80       	add    $0x80000000,%eax
80107a6d:	50                   	push   %eax
80107a6e:	e8 ad ac ff ff       	call   80102720 <kfree>
80107a73:	83 c4 10             	add    $0x10,%esp
    uint i;

    if (pgdir == 0)
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0, 0);
    for (i = 0; i < NPDENTRIES; i++) {
80107a76:	39 fb                	cmp    %edi,%ebx
80107a78:	75 dd                	jne    80107a57 <freevm+0x37>
        if (pgdir[i] & PTE_P) {
            char *v = P2V(PTE_ADDR(pgdir[i]));
            kfree(v);
        }
    }
    kfree((char *) pgdir);
80107a7a:	89 75 08             	mov    %esi,0x8(%ebp)
    if (DEBUGMODE == 2 && notShell())
        cprintf(">FREEVM-DONE!\t");
}
80107a7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a80:	5b                   	pop    %ebx
80107a81:	5e                   	pop    %esi
80107a82:	5f                   	pop    %edi
80107a83:	5d                   	pop    %ebp
        if (pgdir[i] & PTE_P) {
            char *v = P2V(PTE_ADDR(pgdir[i]));
            kfree(v);
        }
    }
    kfree((char *) pgdir);
80107a84:	e9 97 ac ff ff       	jmp    80102720 <kfree>
    if (DEBUGMODE == 2 && notShell())
        cprintf("FREEVM");
    uint i;

    if (pgdir == 0)
        panic("freevm: no pgdir");
80107a89:	83 ec 0c             	sub    $0xc,%esp
80107a8c:	68 4b 88 10 80       	push   $0x8010884b
80107a91:	e8 da 88 ff ff       	call   80100370 <panic>
80107a96:	8d 76 00             	lea    0x0(%esi),%esi
80107a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107aa0 <setupkvm>:
        {(void *) DEVSPACE, DEVSPACE, 0,            PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t *
setupkvm(void) {
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	56                   	push   %esi
80107aa4:	53                   	push   %ebx
    pde_t *pgdir;
    struct kmap *k;

    if ((pgdir = (pde_t *) kalloc()) == 0)
80107aa5:	e8 26 ae ff ff       	call   801028d0 <kalloc>
80107aaa:	85 c0                	test   %eax,%eax
80107aac:	74 6a                	je     80107b18 <setupkvm+0x78>
        return 0;
    memset(pgdir, 0, PGSIZE);
80107aae:	83 ec 04             	sub    $0x4,%esp
80107ab1:	89 c6                	mov    %eax,%esi
    if (P2V(PHYSTOP) > (void *) DEVSPACE)
        panic("PHYSTOP too high");
    for (k = kmap; k < &kmap[NELEM(kmap)];
80107ab3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
    pde_t *pgdir;
    struct kmap *k;

    if ((pgdir = (pde_t *) kalloc()) == 0)
        return 0;
    memset(pgdir, 0, PGSIZE);
80107ab8:	68 00 10 00 00       	push   $0x1000
80107abd:	6a 00                	push   $0x0
80107abf:	50                   	push   %eax
80107ac0:	e8 bb d1 ff ff       	call   80104c80 <memset>
80107ac5:	83 c4 10             	add    $0x10,%esp
    if (P2V(PHYSTOP) > (void *) DEVSPACE)
        panic("PHYSTOP too high");
    for (k = kmap; k < &kmap[NELEM(kmap)];
    k++)
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107ac8:	8b 43 04             	mov    0x4(%ebx),%eax
80107acb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107ace:	83 ec 08             	sub    $0x8,%esp
80107ad1:	8b 13                	mov    (%ebx),%edx
80107ad3:	ff 73 0c             	pushl  0xc(%ebx)
80107ad6:	50                   	push   %eax
80107ad7:	29 c1                	sub    %eax,%ecx
80107ad9:	89 f0                	mov    %esi,%eax
80107adb:	e8 80 f5 ff ff       	call   80107060 <mappages>
80107ae0:	83 c4 10             	add    $0x10,%esp
80107ae3:	85 c0                	test   %eax,%eax
80107ae5:	78 19                	js     80107b00 <setupkvm+0x60>
        return 0;
    memset(pgdir, 0, PGSIZE);
    if (P2V(PHYSTOP) > (void *) DEVSPACE)
        panic("PHYSTOP too high");
    for (k = kmap; k < &kmap[NELEM(kmap)];
    k++)
80107ae7:	83 c3 10             	add    $0x10,%ebx
    if ((pgdir = (pde_t *) kalloc()) == 0)
        return 0;
    memset(pgdir, 0, PGSIZE);
    if (P2V(PHYSTOP) > (void *) DEVSPACE)
        panic("PHYSTOP too high");
    for (k = kmap; k < &kmap[NELEM(kmap)];
80107aea:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107af0:	75 d6                	jne    80107ac8 <setupkvm+0x28>
80107af2:	89 f0                	mov    %esi,%eax
                 (uint) k->phys_start, k->perm) < 0) {
        freevm(pgdir);
        return 0;
    }
    return pgdir;
}
80107af4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107af7:	5b                   	pop    %ebx
80107af8:	5e                   	pop    %esi
80107af9:	5d                   	pop    %ebp
80107afa:	c3                   	ret    
80107afb:	90                   	nop
80107afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        panic("PHYSTOP too high");
    for (k = kmap; k < &kmap[NELEM(kmap)];
    k++)
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                 (uint) k->phys_start, k->perm) < 0) {
        freevm(pgdir);
80107b00:	83 ec 0c             	sub    $0xc,%esp
80107b03:	56                   	push   %esi
80107b04:	e8 17 ff ff ff       	call   80107a20 <freevm>
        return 0;
80107b09:	83 c4 10             	add    $0x10,%esp
    }
    return pgdir;
}
80107b0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    for (k = kmap; k < &kmap[NELEM(kmap)];
    k++)
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                 (uint) k->phys_start, k->perm) < 0) {
        freevm(pgdir);
        return 0;
80107b0f:	31 c0                	xor    %eax,%eax
    }
    return pgdir;
}
80107b11:	5b                   	pop    %ebx
80107b12:	5e                   	pop    %esi
80107b13:	5d                   	pop    %ebp
80107b14:	c3                   	ret    
80107b15:	8d 76 00             	lea    0x0(%esi),%esi
setupkvm(void) {
    pde_t *pgdir;
    struct kmap *k;

    if ((pgdir = (pde_t *) kalloc()) == 0)
        return 0;
80107b18:	31 c0                	xor    %eax,%eax
80107b1a:	eb d8                	jmp    80107af4 <setupkvm+0x54>
80107b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107b20 <kvmalloc>:
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void) {
80107b20:	55                   	push   %ebp
80107b21:	89 e5                	mov    %esp,%ebp
80107b23:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
80107b26:	e8 75 ff ff ff       	call   80107aa0 <setupkvm>
80107b2b:	a3 e8 6c 12 80       	mov    %eax,0x80126ce8
80107b30:	05 00 00 00 80       	add    $0x80000000,%eax
80107b35:	0f 22 d8             	mov    %eax,%cr3
    switchkvm();
}
80107b38:	c9                   	leave  
80107b39:	c3                   	ret    
80107b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b40 <clearpteu>:
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva) {
80107b40:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80107b41:	31 c9                	xor    %ecx,%ecx
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva) {
80107b43:	89 e5                	mov    %esp,%ebp
80107b45:	83 ec 08             	sub    $0x8,%esp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80107b48:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b4b:	8b 45 08             	mov    0x8(%ebp),%eax
80107b4e:	e8 8d f4 ff ff       	call   80106fe0 <walkpgdir>
    if (pte == 0)
80107b53:	85 c0                	test   %eax,%eax
80107b55:	74 05                	je     80107b5c <clearpteu+0x1c>
        panic("clearpteu");
    *pte &= ~PTE_U;
80107b57:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107b5a:	c9                   	leave  
80107b5b:	c3                   	ret    
clearpteu(pde_t *pgdir, char *uva) {
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
    if (pte == 0)
        panic("clearpteu");
80107b5c:	83 ec 0c             	sub    $0xc,%esp
80107b5f:	68 5c 88 10 80       	push   $0x8010885c
80107b64:	e8 07 88 ff ff       	call   80100370 <panic>
80107b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b70 <copyuvm>:
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz) {
80107b70:	55                   	push   %ebp
80107b71:	89 e5                	mov    %esp,%ebp
80107b73:	57                   	push   %edi
80107b74:	56                   	push   %esi
80107b75:	53                   	push   %ebx
80107b76:	83 ec 1c             	sub    $0x1c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0)
80107b79:	e8 22 ff ff ff       	call   80107aa0 <setupkvm>
80107b7e:	85 c0                	test   %eax,%eax
80107b80:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b83:	0f 84 b2 00 00 00    	je     80107c3b <copyuvm+0xcb>
        return 0;
    for (i = 0; i < sz; i += PGSIZE) {
80107b89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107b8c:	85 c9                	test   %ecx,%ecx
80107b8e:	0f 84 9c 00 00 00    	je     80107c30 <copyuvm+0xc0>
80107b94:	31 f6                	xor    %esi,%esi
80107b96:	eb 4a                	jmp    80107be2 <copyuvm+0x72>
80107b98:	90                   	nop
80107b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0)
            goto bad;
        memmove(mem, (char *) P2V(pa), PGSIZE);
80107ba0:	83 ec 04             	sub    $0x4,%esp
80107ba3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107ba9:	68 00 10 00 00       	push   $0x1000
80107bae:	57                   	push   %edi
80107baf:	50                   	push   %eax
80107bb0:	e8 7b d1 ff ff       	call   80104d30 <memmove>
        if (mappages(d, (void *) i, PGSIZE, V2P(mem), flags) < 0)
80107bb5:	58                   	pop    %eax
80107bb6:	5a                   	pop    %edx
80107bb7:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80107bbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107bc0:	ff 75 e4             	pushl  -0x1c(%ebp)
80107bc3:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107bc8:	52                   	push   %edx
80107bc9:	89 f2                	mov    %esi,%edx
80107bcb:	e8 90 f4 ff ff       	call   80107060 <mappages>
80107bd0:	83 c4 10             	add    $0x10,%esp
80107bd3:	85 c0                	test   %eax,%eax
80107bd5:	78 3e                	js     80107c15 <copyuvm+0xa5>
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0)
        return 0;
    for (i = 0; i < sz; i += PGSIZE) {
80107bd7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107bdd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107be0:	76 4e                	jbe    80107c30 <copyuvm+0xc0>
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107be2:	8b 45 08             	mov    0x8(%ebp),%eax
80107be5:	31 c9                	xor    %ecx,%ecx
80107be7:	89 f2                	mov    %esi,%edx
80107be9:	e8 f2 f3 ff ff       	call   80106fe0 <walkpgdir>
80107bee:	85 c0                	test   %eax,%eax
80107bf0:	74 5a                	je     80107c4c <copyuvm+0xdc>
            panic("copyuvm: pte should exist");
        if (!(*pte & PTE_P))
80107bf2:	8b 18                	mov    (%eax),%ebx
80107bf4:	f6 c3 01             	test   $0x1,%bl
80107bf7:	74 46                	je     80107c3f <copyuvm+0xcf>
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
80107bf9:	89 df                	mov    %ebx,%edi
        flags = PTE_FLAGS(*pte);
80107bfb:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107c01:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    for (i = 0; i < sz; i += PGSIZE) {
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
        if (!(*pte & PTE_P))
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
80107c04:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0)
80107c0a:	e8 c1 ac ff ff       	call   801028d0 <kalloc>
80107c0f:	85 c0                	test   %eax,%eax
80107c11:	89 c3                	mov    %eax,%ebx
80107c13:	75 8b                	jne    80107ba0 <copyuvm+0x30>
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-DONE!\t");
    return d;

    bad:
    freevm(d);
80107c15:	83 ec 0c             	sub    $0xc,%esp
80107c18:	ff 75 e0             	pushl  -0x20(%ebp)
80107c1b:	e8 00 fe ff ff       	call   80107a20 <freevm>
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-FAILED!\t");
    return 0;
80107c20:	83 c4 10             	add    $0x10,%esp
80107c23:	31 c0                	xor    %eax,%eax
}
80107c25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c28:	5b                   	pop    %ebx
80107c29:	5e                   	pop    %esi
80107c2a:	5f                   	pop    %edi
80107c2b:	5d                   	pop    %ebp
80107c2c:	c3                   	ret    
80107c2d:	8d 76 00             	lea    0x0(%esi),%esi
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0)
        return 0;
    for (i = 0; i < sz; i += PGSIZE) {
80107c30:	8b 45 e0             	mov    -0x20(%ebp),%eax
    bad:
    freevm(d);
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-FAILED!\t");
    return 0;
}
80107c33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c36:	5b                   	pop    %ebx
80107c37:	5e                   	pop    %esi
80107c38:	5f                   	pop    %edi
80107c39:	5d                   	pop    %ebp
80107c3a:	c3                   	ret    
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0)
        return 0;
80107c3b:	31 c0                	xor    %eax,%eax
80107c3d:	eb e6                	jmp    80107c25 <copyuvm+0xb5>
    for (i = 0; i < sz; i += PGSIZE) {
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
        if (!(*pte & PTE_P))
            panic("copyuvm: page not present");
80107c3f:	83 ec 0c             	sub    $0xc,%esp
80107c42:	68 80 88 10 80       	push   $0x80108880
80107c47:	e8 24 87 ff ff       	call   80100370 <panic>

    if ((d = setupkvm()) == 0)
        return 0;
    for (i = 0; i < sz; i += PGSIZE) {
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
80107c4c:	83 ec 0c             	sub    $0xc,%esp
80107c4f:	68 66 88 10 80       	push   $0x80108866
80107c54:	e8 17 87 ff ff       	call   80100370 <panic>
80107c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c60 <uva2ka>:
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva) {
80107c60:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80107c61:	31 c9                	xor    %ecx,%ecx
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva) {
80107c63:	89 e5                	mov    %esp,%ebp
80107c65:	83 ec 08             	sub    $0x8,%esp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80107c68:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c6e:	e8 6d f3 ff ff       	call   80106fe0 <walkpgdir>
    if ((*pte & PTE_P) == 0)
80107c73:	8b 00                	mov    (%eax),%eax
        return 0;
    if ((*pte & PTE_U) == 0)
80107c75:	89 c2                	mov    %eax,%edx
80107c77:	83 e2 05             	and    $0x5,%edx
80107c7a:	83 fa 05             	cmp    $0x5,%edx
80107c7d:	75 11                	jne    80107c90 <uva2ka+0x30>
        return 0;
    return (char *) P2V(PTE_ADDR(*pte));
80107c7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107c84:	c9                   	leave  
    pte = walkpgdir(pgdir, uva, 0);
    if ((*pte & PTE_P) == 0)
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    return (char *) P2V(PTE_ADDR(*pte));
80107c85:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107c8a:	c3                   	ret    
80107c8b:	90                   	nop
80107c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    pte = walkpgdir(pgdir, uva, 0);
    if ((*pte & PTE_P) == 0)
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
80107c90:	31 c0                	xor    %eax,%eax
    return (char *) P2V(PTE_ADDR(*pte));
}
80107c92:	c9                   	leave  
80107c93:	c3                   	ret    
80107c94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107ca0 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len) {
80107ca0:	55                   	push   %ebp
80107ca1:	89 e5                	mov    %esp,%ebp
80107ca3:	57                   	push   %edi
80107ca4:	56                   	push   %esi
80107ca5:	53                   	push   %ebx
80107ca6:	83 ec 1c             	sub    $0x1c,%esp
80107ca9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107cac:	8b 55 0c             	mov    0xc(%ebp),%edx
80107caf:	8b 7d 10             	mov    0x10(%ebp),%edi
    char *buf, *pa0;
    uint n, va0;

    buf = (char *) p;
    while (len > 0) {
80107cb2:	85 db                	test   %ebx,%ebx
80107cb4:	75 40                	jne    80107cf6 <copyout+0x56>
80107cb6:	eb 70                	jmp    80107d28 <copyout+0x88>
80107cb8:	90                   	nop
80107cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        va0 = (uint) PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char *) va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (va - va0);
80107cc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107cc3:	89 f1                	mov    %esi,%ecx
80107cc5:	29 d1                	sub    %edx,%ecx
80107cc7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107ccd:	39 d9                	cmp    %ebx,%ecx
80107ccf:	0f 47 cb             	cmova  %ebx,%ecx
        if (n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
80107cd2:	29 f2                	sub    %esi,%edx
80107cd4:	83 ec 04             	sub    $0x4,%esp
80107cd7:	01 d0                	add    %edx,%eax
80107cd9:	51                   	push   %ecx
80107cda:	57                   	push   %edi
80107cdb:	50                   	push   %eax
80107cdc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107cdf:	e8 4c d0 ff ff       	call   80104d30 <memmove>
        len -= n;
        buf += n;
80107ce4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
copyout(pde_t *pgdir, uint va, void *p, uint len) {
    char *buf, *pa0;
    uint n, va0;

    buf = (char *) p;
    while (len > 0) {
80107ce7:	83 c4 10             	add    $0x10,%esp
        if (n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
        len -= n;
        buf += n;
        va = va0 + PGSIZE;
80107cea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
        n = PGSIZE - (va - va0);
        if (n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
        len -= n;
        buf += n;
80107cf0:	01 cf                	add    %ecx,%edi
copyout(pde_t *pgdir, uint va, void *p, uint len) {
    char *buf, *pa0;
    uint n, va0;

    buf = (char *) p;
    while (len > 0) {
80107cf2:	29 cb                	sub    %ecx,%ebx
80107cf4:	74 32                	je     80107d28 <copyout+0x88>
        va0 = (uint) PGROUNDDOWN(va);
80107cf6:	89 d6                	mov    %edx,%esi
        pa0 = uva2ka(pgdir, (char *) va0);
80107cf8:	83 ec 08             	sub    $0x8,%esp
    char *buf, *pa0;
    uint n, va0;

    buf = (char *) p;
    while (len > 0) {
        va0 = (uint) PGROUNDDOWN(va);
80107cfb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107cfe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        pa0 = uva2ka(pgdir, (char *) va0);
80107d04:	56                   	push   %esi
80107d05:	ff 75 08             	pushl  0x8(%ebp)
80107d08:	e8 53 ff ff ff       	call   80107c60 <uva2ka>
        if (pa0 == 0)
80107d0d:	83 c4 10             	add    $0x10,%esp
80107d10:	85 c0                	test   %eax,%eax
80107d12:	75 ac                	jne    80107cc0 <copyout+0x20>
        len -= n;
        buf += n;
        va = va0 + PGSIZE;
    }
    return 0;
}
80107d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
    buf = (char *) p;
    while (len > 0) {
        va0 = (uint) PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char *) va0);
        if (pa0 == 0)
            return -1;
80107d17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        len -= n;
        buf += n;
        va = va0 + PGSIZE;
    }
    return 0;
}
80107d1c:	5b                   	pop    %ebx
80107d1d:	5e                   	pop    %esi
80107d1e:	5f                   	pop    %edi
80107d1f:	5d                   	pop    %ebp
80107d20:	c3                   	ret    
80107d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
        memmove(pa0 + (va - va0), buf, n);
        len -= n;
        buf += n;
        va = va0 + PGSIZE;
    }
    return 0;
80107d2b:	31 c0                	xor    %eax,%eax
}
80107d2d:	5b                   	pop    %ebx
80107d2e:	5e                   	pop    %esi
80107d2f:	5f                   	pop    %edi
80107d30:	5d                   	pop    %ebp
80107d31:	c3                   	ret    
