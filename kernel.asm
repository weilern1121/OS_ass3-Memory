
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
8010004c:	68 e0 7b 10 80       	push   $0x80107be0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 75 48 00 00       	call   801048d0 <initlock>
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
80100092:	68 e7 7b 10 80       	push   $0x80107be7
80100097:	50                   	push   %eax
80100098:	e8 23 47 00 00       	call   801047c0 <initsleeplock>
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
801000e4:	e8 d7 48 00 00       	call   801049c0 <acquire>
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
80100162:	e8 79 49 00 00       	call   80104ae0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 46 00 00       	call   80104800 <acquiresleep>
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
80100193:	68 ee 7b 10 80       	push   $0x80107bee
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
  iderw(b);
801001c4:	e9 27 23 00 00       	jmp    801024f0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 7b 10 80       	push   $0x80107bff
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
8010020b:	e8 b0 47 00 00       	call   801049c0 <acquire>
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
8010025c:	e9 7f 48 00 00       	jmp    80104ae0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 7c 10 80       	push   $0x80107c06
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
8010028c:	e8 2f 47 00 00       	call   801049c0 <acquire>
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
801002c5:	e8 e6 40 00 00       	call   801043b0 <sleep>
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
801002ef:	e8 ec 47 00 00       	call   80104ae0 <release>
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
8010034d:	e8 8e 47 00 00       	call   80104ae0 <release>
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
801003b2:	68 0d 7c 10 80       	push   $0x80107c0d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 45 86 10 80 	movl   $0x80108645,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 13 45 00 00       	call   801048f0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 7c 10 80       	push   $0x80107c21
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
8010043a:	e8 e1 5f 00 00       	call   80106420 <uartputc>
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
801004ec:	e8 2f 5f 00 00       	call   80106420 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 23 5f 00 00       	call   80106420 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 17 5f 00 00       	call   80106420 <uartputc>
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
80100524:	e8 c7 46 00 00       	call   80104bf0 <memmove>
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
80100541:	e8 fa 45 00 00       	call   80104b40 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 7c 10 80       	push   $0x80107c25
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
801005b1:	0f b6 92 50 7c 10 80 	movzbl -0x7fef83b0(%edx),%edx
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
8010061b:	e8 a0 43 00 00       	call   801049c0 <acquire>
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
80100647:	e8 94 44 00 00       	call   80104ae0 <release>
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
8010071f:	e8 bc 43 00 00       	call   80104ae0 <release>
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
801007d0:	ba 38 7c 10 80       	mov    $0x80107c38,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 cb 41 00 00       	call   801049c0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 7c 10 80       	push   $0x80107c3f
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
80100823:	e8 98 41 00 00       	call   801049c0 <acquire>
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
80100888:	e8 53 42 00 00       	call   80104ae0 <release>
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
80100916:	e8 f5 3c 00 00       	call   80104610 <wakeup>
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
80100997:	e9 54 3d 00 00       	jmp    801046f0 <procdump>
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
801009c6:	68 48 7c 10 80       	push   $0x80107c48
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 fb 3e 00 00       	call   801048d0 <initlock>

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
80100a94:	e8 a7 6e 00 00       	call   80107940 <setupkvm>
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
80100ab9:	0f 84 bb 02 00 00    	je     80100d7a <exec+0x36a>
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
80100af6:	e8 25 6b 00 00       	call   80107620 <allocuvm>
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
80100b28:	e8 43 67 00 00       	call   80107270 <loaduvm>
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
80100b72:	e8 49 6d 00 00       	call   801078c0 <freevm>
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
80100baa:	e8 71 6a 00 00       	call   80107620 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
        freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 fa 6c 00 00       	call   801078c0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
        end_op();
80100bd3:	e8 08 24 00 00       	call   80102fe0 <end_op>
        cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 61 7c 10 80       	push   $0x80107c61
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
80100c06:	e8 d5 6d 00 00       	call   801079e0 <clearpteu>
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
80100c39:	e8 22 41 00 00       	call   80104d60 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	59                   	pop    %ecx
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 0f 41 00 00       	call   80104d60 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ce 6e 00 00       	call   80107b30 <copyout>
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
80100cc9:	e8 62 6e 00 00       	call   80107b30 <copyout>
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
80100d0c:	e8 0f 40 00 00       	call   80104d20 <safestrcpy>
    oldpgdir = curproc->pgdir;
80100d11:	89 d8                	mov    %ebx,%eax
    if (curproc->pid > 2) {
80100d13:	83 c4 10             	add    $0x10,%esp
    curproc->pgdir = pgdir;
80100d16:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
    if (curproc->pid > 2) {
80100d1c:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
    oldpgdir = curproc->pgdir;
80100d20:	8b 5b 04             	mov    0x4(%ebx),%ebx
    curproc->pgdir = pgdir;
80100d23:	89 50 04             	mov    %edx,0x4(%eax)
    if (curproc->pid > 2) {
80100d26:	7e 1d                	jle    80100d45 <exec+0x335>
        removeSwapFile(curproc);
80100d28:	83 ec 0c             	sub    $0xc,%esp
80100d2b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d31:	e8 ba 12 00 00       	call   80101ff0 <removeSwapFile>
        createSwapFile(curproc);
80100d36:	58                   	pop    %eax
80100d37:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d3d:	e8 ae 14 00 00       	call   801021f0 <createSwapFile>
80100d42:	83 c4 10             	add    $0x10,%esp
    curproc->sz = sz;
80100d45:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    switchuvm(curproc);
80100d4b:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80100d4e:	89 31                	mov    %esi,(%ecx)
    curproc->tf->eip = elf.entry;  // main
80100d50:	8b 41 18             	mov    0x18(%ecx),%eax
80100d53:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d59:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
80100d5c:	8b 41 18             	mov    0x18(%ecx),%eax
80100d5f:	89 78 44             	mov    %edi,0x44(%eax)
    switchuvm(curproc);
80100d62:	51                   	push   %ecx
80100d63:	e8 78 63 00 00       	call   801070e0 <switchuvm>
    freevm(oldpgdir);
80100d68:	89 1c 24             	mov    %ebx,(%esp)
80100d6b:	e8 50 6b 00 00       	call   801078c0 <freevm>
    return 0;
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	31 c0                	xor    %eax,%eax
80100d75:	e9 02 fd ff ff       	jmp    80100a7c <exec+0x6c>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100d7a:	be 00 20 00 00       	mov    $0x2000,%esi
80100d7f:	e9 0d fe ff ff       	jmp    80100b91 <exec+0x181>
80100d84:	66 90                	xchg   %ax,%ax
80100d86:	66 90                	xchg   %ax,%ax
80100d88:	66 90                	xchg   %ax,%ax
80100d8a:	66 90                	xchg   %ax,%ax
80100d8c:	66 90                	xchg   %ax,%ax
80100d8e:	66 90                	xchg   %ax,%ax

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
80100d96:	68 6d 7c 10 80       	push   $0x80107c6d
80100d9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100da0:	e8 2b 3b 00 00       	call   801048d0 <initlock>
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
80100dc1:	e8 fa 3b 00 00       	call   801049c0 <acquire>
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
80100df1:	e8 ea 3c 00 00       	call   80104ae0 <release>
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
80100e0a:	e8 d1 3c 00 00       	call   80104ae0 <release>
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
80100e2f:	e8 8c 3b 00 00       	call   801049c0 <acquire>
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
80100e4c:	e8 8f 3c 00 00       	call   80104ae0 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 74 7c 10 80       	push   $0x80107c74
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
80100e81:	e8 3a 3b 00 00       	call   801049c0 <acquire>
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
80100eac:	e9 2f 3c 00 00       	jmp    80104ae0 <release>
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
80100ed8:	e8 03 3c 00 00       	call   80104ae0 <release>
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
80100f32:	68 7c 7c 10 80       	push   $0x80107c7c
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
80101012:	68 86 7c 10 80       	push   $0x80107c86
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
80101125:	68 8f 7c 10 80       	push   $0x80107c8f
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 95 7c 10 80       	push   $0x80107c95
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
801011e4:	68 9f 7c 10 80       	push   $0x80107c9f
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
80101225:	e8 16 39 00 00       	call   80104b40 <memset>
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
8010126a:	e8 51 37 00 00       	call   801049c0 <acquire>
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
801012cf:	e8 0c 38 00 00       	call   80104ae0 <release>

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
801012fd:	e8 de 37 00 00       	call   80104ae0 <release>
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
80101312:	68 b5 7c 10 80       	push   $0x80107cb5
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
801013e7:	68 c5 7c 10 80       	push   $0x80107cc5
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
80101421:	e8 ca 37 00 00       	call   80104bf0 <memmove>
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
801014b4:	68 d8 7c 10 80       	push   $0x80107cd8
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
801014cc:	68 eb 7c 10 80       	push   $0x80107ceb
801014d1:	68 e0 19 11 80       	push   $0x801119e0
801014d6:	e8 f5 33 00 00       	call   801048d0 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 f2 7c 10 80       	push   $0x80107cf2
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 cc 32 00 00       	call   801047c0 <initsleeplock>
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
80101539:	68 9c 7d 10 80       	push   $0x80107d9c
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
801015ce:	e8 6d 35 00 00       	call   80104b40 <memset>
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
80101603:	68 f8 7c 10 80       	push   $0x80107cf8
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
80101671:	e8 7a 35 00 00       	call   80104bf0 <memmove>
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
8010169f:	e8 1c 33 00 00       	call   801049c0 <acquire>
  ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016a8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016af:	e8 2c 34 00 00       	call   80104ae0 <release>
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
801016e2:	e8 19 31 00 00       	call   80104800 <acquiresleep>
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
80101758:	e8 93 34 00 00       	call   80104bf0 <memmove>
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
8010177d:	68 10 7d 10 80       	push   $0x80107d10
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 0a 7d 10 80       	push   $0x80107d0a
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
801017b3:	e8 e8 30 00 00       	call   801048a0 <holdingsleep>
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
801017cf:	e9 8c 30 00 00       	jmp    80104860 <releasesleep>
    panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 1f 7d 10 80       	push   $0x80107d1f
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
80101800:	e8 fb 2f 00 00       	call   80104800 <acquiresleep>
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
8010181a:	e8 41 30 00 00       	call   80104860 <releasesleep>
  acquire(&icache.lock);
8010181f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101826:	e8 95 31 00 00       	call   801049c0 <acquire>
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
80101840:	e9 9b 32 00 00       	jmp    80104ae0 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 e0 19 11 80       	push   $0x801119e0
80101850:	e8 6b 31 00 00       	call   801049c0 <acquire>
    int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101858:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010185f:	e8 7c 32 00 00       	call   80104ae0 <release>
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
80101a47:	e8 a4 31 00 00       	call   80104bf0 <memmove>
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
80101b43:	e8 a8 30 00 00       	call   80104bf0 <memmove>
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
80101bde:	e8 7d 30 00 00       	call   80104c60 <strncmp>
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
80101c3d:	e8 1e 30 00 00       	call   80104c60 <strncmp>
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
80101c82:	68 39 7d 10 80       	push   $0x80107d39
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 27 7d 10 80       	push   $0x80107d27
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
80101cc9:	e8 f2 2c 00 00       	call   801049c0 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cd9:	e8 02 2e 00 00       	call   80104ae0 <release>
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
80101d35:	e8 b6 2e 00 00       	call   80104bf0 <memmove>
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
80101dc8:	e8 23 2e 00 00       	call   80104bf0 <memmove>
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
80101ebd:	e8 fe 2d 00 00       	call   80104cc0 <strncpy>
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
80101efb:	68 48 7d 10 80       	push   $0x80107d48
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 91 83 10 80       	push   $0x80108391
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
80102001:	68 55 7d 10 80       	push   $0x80107d55
80102006:	56                   	push   %esi
80102007:	e8 e4 2b 00 00       	call   80104bf0 <memmove>
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
80102062:	68 5d 7d 10 80       	push   $0x80107d5d
80102067:	53                   	push   %ebx
80102068:	e8 f3 2b 00 00       	call   80104c60 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010206d:	83 c4 10             	add    $0x10,%esp
80102070:	85 c0                	test   %eax,%eax
80102072:	0f 84 f8 00 00 00    	je     80102170 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102078:	83 ec 04             	sub    $0x4,%esp
8010207b:	6a 0e                	push   $0xe
8010207d:	68 5c 7d 10 80       	push   $0x80107d5c
80102082:	53                   	push   %ebx
80102083:	e8 d8 2b 00 00       	call   80104c60 <strncmp>
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
801020d7:	e8 64 2a 00 00       	call   80104b40 <memset>
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
80102144:	e8 d7 31 00 00       	call   80105320 <isdirempty>
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
801021cc:	68 71 7d 10 80       	push   $0x80107d71
801021d1:	e8 ba e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021d6:	83 ec 0c             	sub    $0xc,%esp
801021d9:	68 5f 7d 10 80       	push   $0x80107d5f
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
80102200:	68 55 7d 10 80       	push   $0x80107d55
80102205:	56                   	push   %esi
80102206:	e8 e5 29 00 00       	call   80104bf0 <memmove>
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
80102225:	e8 06 33 00 00       	call   80105530 <create>
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
80102279:	68 80 7d 10 80       	push   $0x80107d80
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
801023ab:	68 f8 7d 10 80       	push   $0x80107df8
801023b0:	e8 db df ff ff       	call   80100390 <panic>
    panic("idestart");
801023b5:	83 ec 0c             	sub    $0xc,%esp
801023b8:	68 ef 7d 10 80       	push   $0x80107def
801023bd:	e8 ce df ff ff       	call   80100390 <panic>
801023c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <ideinit>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023d6:	68 0a 7e 10 80       	push   $0x80107e0a
801023db:	68 80 b5 10 80       	push   $0x8010b580
801023e0:	e8 eb 24 00 00       	call   801048d0 <initlock>
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
8010245e:	e8 5d 25 00 00       	call   801049c0 <acquire>

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
801024c1:	e8 4a 21 00 00       	call   80104610 <wakeup>

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
801024df:	e8 fc 25 00 00       	call   80104ae0 <release>

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
801024fe:	e8 9d 23 00 00       	call   801048a0 <holdingsleep>
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
80102538:	e8 83 24 00 00       	call   801049c0 <acquire>

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
80102589:	e8 22 1e 00 00       	call   801043b0 <sleep>
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
801025a6:	e9 35 25 00 00       	jmp    80104ae0 <release>
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
801025ca:	68 24 7e 10 80       	push   $0x80107e24
801025cf:	e8 bc dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	68 0e 7e 10 80       	push   $0x80107e0e
801025dc:	e8 af dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025e1:	83 ec 0c             	sub    $0xc,%esp
801025e4:	68 39 7e 10 80       	push   $0x80107e39
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
80102637:	68 58 7e 10 80       	push   $0x80107e58
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
801026f2:	81 fb cc 5b 12 80    	cmp    $0x80125bcc,%ebx
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
80102712:	e8 29 24 00 00       	call   80104b40 <memset>

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
8010274b:	e9 90 23 00 00       	jmp    80104ae0 <release>
    acquire(&kmem.lock);
80102750:	83 ec 0c             	sub    $0xc,%esp
80102753:	68 40 36 11 80       	push   $0x80113640
80102758:	e8 63 22 00 00       	call   801049c0 <acquire>
8010275d:	83 c4 10             	add    $0x10,%esp
80102760:	eb c2                	jmp    80102724 <kfree+0x44>
    panic("kfree");
80102762:	83 ec 0c             	sub    $0xc,%esp
80102765:	68 8a 7e 10 80       	push   $0x80107e8a
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
801027cb:	68 90 7e 10 80       	push   $0x80107e90
801027d0:	68 40 36 11 80       	push   $0x80113640
801027d5:	e8 f6 20 00 00       	call   801048d0 <initlock>
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
801028c3:	e8 f8 20 00 00       	call   801049c0 <acquire>
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
801028f1:	e8 ea 21 00 00       	call   80104ae0 <release>
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
80102943:	0f b6 82 c0 7f 10 80 	movzbl -0x7fef8040(%edx),%eax
8010294a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010294c:	0f b6 82 c0 7e 10 80 	movzbl -0x7fef8140(%edx),%eax
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
80102963:	8b 04 85 a0 7e 10 80 	mov    -0x7fef8160(,%eax,4),%eax
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
80102988:	0f b6 82 c0 7f 10 80 	movzbl -0x7fef8040(%edx),%eax
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
80102d07:	e8 84 1e 00 00       	call   80104b90 <memcmp>
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
80102e34:	e8 b7 1d 00 00       	call   80104bf0 <memmove>
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
80102eda:	68 c0 80 10 80       	push   $0x801080c0
80102edf:	68 80 36 11 80       	push   $0x80113680
80102ee4:	e8 e7 19 00 00       	call   801048d0 <initlock>
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
80102f7b:	e8 40 1a 00 00       	call   801049c0 <acquire>
80102f80:	83 c4 10             	add    $0x10,%esp
80102f83:	eb 18                	jmp    80102f9d <begin_op+0x2d>
80102f85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f88:	83 ec 08             	sub    $0x8,%esp
80102f8b:	68 80 36 11 80       	push   $0x80113680
80102f90:	68 80 36 11 80       	push   $0x80113680
80102f95:	e8 16 14 00 00       	call   801043b0 <sleep>
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
80102fcc:	e8 0f 1b 00 00       	call   80104ae0 <release>
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
80102fee:	e8 cd 19 00 00       	call   801049c0 <acquire>
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
8010302c:	e8 af 1a 00 00       	call   80104ae0 <release>
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
80103086:	e8 65 1b 00 00       	call   80104bf0 <memmove>
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
801030cf:	e8 ec 18 00 00       	call   801049c0 <acquire>
    wakeup(&log);
801030d4:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
801030db:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
801030e2:	00 00 00 
    wakeup(&log);
801030e5:	e8 26 15 00 00       	call   80104610 <wakeup>
    release(&log.lock);
801030ea:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030f1:	e8 ea 19 00 00       	call   80104ae0 <release>
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
80103110:	e8 fb 14 00 00       	call   80104610 <wakeup>
  release(&log.lock);
80103115:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
8010311c:	e8 bf 19 00 00       	call   80104ae0 <release>
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
8010312f:	68 c4 80 10 80       	push   $0x801080c4
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
8010317e:	e8 3d 18 00 00       	call   801049c0 <acquire>
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
801031cd:	e9 0e 19 00 00       	jmp    80104ae0 <release>
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
801031f9:	68 d3 80 10 80       	push   $0x801080d3
801031fe:	e8 8d d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103203:	83 ec 0c             	sub    $0xc,%esp
80103206:	68 e9 80 10 80       	push   $0x801080e9
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
80103228:	68 04 81 10 80       	push   $0x80108104
8010322d:	e8 2e d4 ff ff       	call   80100660 <cprintf>
    idtinit();       // load idt register
80103232:	e8 d9 2b 00 00       	call   80105e10 <idtinit>
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
8010324a:	e8 61 0e 00 00       	call   801040b0 <scheduler>
8010324f:	90                   	nop

80103250 <mpenter>:
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103256:	e8 65 3e 00 00       	call   801070c0 <switchkvm>
  seginit();
8010325b:	e8 90 3d 00 00       	call   80106ff0 <seginit>
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
80103287:	68 cc 5b 12 80       	push   $0x80125bcc
8010328c:	e8 2f f5 ff ff       	call   801027c0 <kinit1>
  kvmalloc();      // kernel page table
80103291:	e8 2a 47 00 00       	call   801079c0 <kvmalloc>
  mpinit();        // detect other processors
80103296:	e8 75 01 00 00       	call   80103410 <mpinit>
  lapicinit();     // interrupt controller
8010329b:	e8 60 f7 ff ff       	call   80102a00 <lapicinit>
  seginit();       // segment descriptors
801032a0:	e8 4b 3d 00 00       	call   80106ff0 <seginit>
  picinit();       // disable pic
801032a5:	e8 46 03 00 00       	call   801035f0 <picinit>
  ioapicinit();    // another interrupt controller
801032aa:	e8 41 f3 ff ff       	call   801025f0 <ioapicinit>
  consoleinit();   // console hardware
801032af:	e8 0c d7 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801032b4:	e8 a7 30 00 00       	call   80106360 <uartinit>
  pinit();         // process table
801032b9:	e8 e2 08 00 00       	call   80103ba0 <pinit>
  tvinit();        // trap vectors
801032be:	e8 cd 2a 00 00       	call   80105d90 <tvinit>
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
801032e4:	e8 07 19 00 00       	call   80104bf0 <memmove>

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
801033be:	68 18 81 10 80       	push   $0x80108118
801033c3:	56                   	push   %esi
801033c4:	e8 c7 17 00 00       	call   80104b90 <memcmp>
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
8010347c:	68 35 81 10 80       	push   $0x80108135
80103481:	56                   	push   %esi
80103482:	e8 09 17 00 00       	call   80104b90 <memcmp>
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
80103510:	ff 24 95 5c 81 10 80 	jmp    *-0x7fef7ea4(,%edx,4)
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
801035c3:	68 1d 81 10 80       	push   $0x8010811d
801035c8:	e8 c3 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801035cd:	83 ec 0c             	sub    $0xc,%esp
801035d0:	68 3c 81 10 80       	push   $0x8010813c
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
801036cb:	68 70 81 10 80       	push   $0x80108170
801036d0:	50                   	push   %eax
801036d1:	e8 fa 11 00 00       	call   801048d0 <initlock>
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
8010372f:	e8 8c 12 00 00       	call   801049c0 <acquire>
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
8010374f:	e8 bc 0e 00 00       	call   80104610 <wakeup>
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
80103774:	e9 67 13 00 00       	jmp    80104ae0 <release>
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103780:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103786:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103789:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103790:	00 00 00 
    wakeup(&p->nwrite);
80103793:	50                   	push   %eax
80103794:	e8 77 0e 00 00       	call   80104610 <wakeup>
80103799:	83 c4 10             	add    $0x10,%esp
8010379c:	eb b9                	jmp    80103757 <pipeclose+0x37>
8010379e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
801037a3:	53                   	push   %ebx
801037a4:	e8 37 13 00 00       	call   80104ae0 <release>
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
801037cd:	e8 ee 11 00 00       	call   801049c0 <acquire>
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
80103824:	e8 e7 0d 00 00       	call   80104610 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103829:	5a                   	pop    %edx
8010382a:	59                   	pop    %ecx
8010382b:	53                   	push   %ebx
8010382c:	56                   	push   %esi
8010382d:	e8 7e 0b 00 00       	call   801043b0 <sleep>
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
80103864:	e8 77 12 00 00       	call   80104ae0 <release>
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
801038b3:	e8 58 0d 00 00       	call   80104610 <wakeup>
  release(&p->lock);
801038b8:	89 1c 24             	mov    %ebx,(%esp)
801038bb:	e8 20 12 00 00       	call   80104ae0 <release>
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
801038e0:	e8 db 10 00 00       	call   801049c0 <acquire>
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
80103915:	e8 96 0a 00 00       	call   801043b0 <sleep>
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
8010394e:	e8 8d 11 00 00       	call   80104ae0 <release>
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
801039a7:	e8 64 0c 00 00       	call   80104610 <wakeup>
  release(&p->lock);
801039ac:	89 34 24             	mov    %esi,(%esp)
801039af:	e8 2c 11 00 00       	call   80104ae0 <release>
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
801039e1:	e8 da 0f 00 00       	call   801049c0 <acquire>
801039e6:	83 c4 10             	add    $0x10,%esp
801039e9:	eb 17                	jmp    80103a02 <allocproc+0x32>
801039eb:	90                   	nop
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039f0:	81 c3 18 04 00 00    	add    $0x418,%ebx
801039f6:	81 fb 54 53 12 80    	cmp    $0x80125354,%ebx
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
80103a29:	e8 b2 10 00 00       	call   80104ae0 <release>

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
80103a52:	c7 40 14 82 5d 10 80 	movl   $0x80105d82,0x14(%eax)
    p->context = (struct context *) sp;
80103a59:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103a5c:	6a 14                	push   $0x14
80103a5e:	6a 00                	push   $0x0
80103a60:	50                   	push   %eax
80103a61:	e8 da 10 00 00       	call   80104b40 <memset>
    p->context->eip = (uint) forkret;
80103a66:	8b 43 1c             	mov    0x1c(%ebx),%eax
    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103a69:	8d 93 00 04 00 00    	lea    0x400(%ebx),%edx
80103a6f:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint) forkret;
80103a72:	c7 40 10 30 3b 10 80 	movl   $0x80103b30,0x10(%eax)
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103a79:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
    p->pagesCounter = 0;
80103a7f:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
80103a86:	00 00 00 
    p->nextpageid = 1;
80103a89:	c7 83 08 04 00 00 01 	movl   $0x1,0x408(%ebx)
80103a90:	00 00 00 
    p->pagesequel = 0;
80103a93:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80103a9a:	00 00 00 
    p->pagesinSwap = 0;
80103a9d:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80103aa4:	00 00 00 
        p->swapFileEntries[k]=0;
80103aa7:	c7 83 00 04 00 00 00 	movl   $0x0,0x400(%ebx)
80103aae:	00 00 00 
80103ab1:	c7 83 04 04 00 00 00 	movl   $0x0,0x404(%ebx)
80103ab8:	00 00 00 
80103abb:	90                   	nop
80103abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
        pg->offset = 0;
80103ac0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        pg->pageid = 0;
80103ac7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103ace:	83 c0 1c             	add    $0x1c,%eax
        pg->present = 0;
80103ad1:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
        pg->sequel = 0;
80103ad8:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
        pg->physAdress = 0;
80103adf:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        pg->virtAdress = 0;
80103ae6:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103aed:	39 c2                	cmp    %eax,%edx
80103aef:	77 cf                	ja     80103ac0 <allocproc+0xf0>
    }


    return p;
}
80103af1:	89 d8                	mov    %ebx,%eax
80103af3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103af6:	c9                   	leave  
80103af7:	c3                   	ret    
80103af8:	90                   	nop
80103af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80103b00:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80103b03:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
80103b05:	68 20 4d 11 80       	push   $0x80114d20
80103b0a:	e8 d1 0f 00 00       	call   80104ae0 <release>
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
80103b22:	eb cd                	jmp    80103af1 <allocproc+0x121>
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
80103b3b:	e8 a0 0f 00 00       	call   80104ae0 <release>

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
80103ba6:	68 75 81 10 80       	push   $0x80108175
80103bab:	68 20 4d 11 80       	push   $0x80114d20
80103bb0:	e8 1b 0d 00 00       	call   801048d0 <initlock>
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
80103c20:	68 7c 81 10 80       	push   $0x8010817c
80103c25:	e8 66 c7 ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
80103c2a:	83 ec 0c             	sub    $0xc,%esp
80103c2d:	68 58 82 10 80       	push   $0x80108258
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
80103c67:	e8 14 0d 00 00       	call   80104980 <pushcli>
    c = mycpu();
80103c6c:	e8 4f ff ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
80103c71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103c77:	e8 04 0e 00 00       	call   80104a80 <popcli>
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
80103ca3:	e8 98 3c 00 00       	call   80107940 <setupkvm>
80103ca8:	85 c0                	test   %eax,%eax
80103caa:	89 43 04             	mov    %eax,0x4(%ebx)
80103cad:	0f 84 bd 00 00 00    	je     80103d70 <userinit+0xe0>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103cb3:	83 ec 04             	sub    $0x4,%esp
80103cb6:	68 2c 00 00 00       	push   $0x2c
80103cbb:	68 60 b4 10 80       	push   $0x8010b460
80103cc0:	50                   	push   %eax
80103cc1:	e8 2a 35 00 00       	call   801071f0 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103cc6:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103cc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103ccf:	6a 4c                	push   $0x4c
80103cd1:	6a 00                	push   $0x0
80103cd3:	ff 73 18             	pushl  0x18(%ebx)
80103cd6:	e8 65 0e 00 00       	call   80104b40 <memset>
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
80103d2f:	68 a5 81 10 80       	push   $0x801081a5
80103d34:	50                   	push   %eax
80103d35:	e8 e6 0f 00 00       	call   80104d20 <safestrcpy>
    p->cwd = namei("/");
80103d3a:	c7 04 24 ae 81 10 80 	movl   $0x801081ae,(%esp)
80103d41:	e8 da e1 ff ff       	call   80101f20 <namei>
80103d46:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103d49:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80103d50:	e8 6b 0c 00 00       	call   801049c0 <acquire>
    p->state = RUNNABLE;
80103d55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103d5c:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80103d63:	e8 78 0d 00 00       	call   80104ae0 <release>
}
80103d68:	83 c4 10             	add    $0x10,%esp
80103d6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d6e:	c9                   	leave  
80103d6f:	c3                   	ret    
        panic("userinit: out of memory?");
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	68 8c 81 10 80       	push   $0x8010818c
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
80103d88:	e8 f3 0b 00 00       	call   80104980 <pushcli>
    c = mycpu();
80103d8d:	e8 2e fe ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
80103d92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103d98:	e8 e3 0c 00 00       	call   80104a80 <popcli>
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
80103dac:	e8 2f 33 00 00       	call   801070e0 <switchuvm>
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
80103dca:	e8 51 38 00 00       	call   80107620 <allocuvm>
80103dcf:	83 c4 10             	add    $0x10,%esp
80103dd2:	85 c0                	test   %eax,%eax
80103dd4:	75 d0                	jne    80103da6 <growproc+0x26>
            return -1;
80103dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ddb:	eb d9                	jmp    80103db6 <growproc+0x36>
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi
        curproc->pagesCounter +=(PGROUNDUP(n)/PGSIZE);
80103de0:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n , 1)) == 0)
80103de6:	01 c6                	add    %eax,%esi
        curproc->pagesCounter +=(PGROUNDUP(n)/PGSIZE);
80103de8:	c1 fa 0c             	sar    $0xc,%edx
80103deb:	01 93 0c 04 00 00    	add    %edx,0x40c(%ebx)
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n , 1)) == 0)
80103df1:	6a 01                	push   $0x1
80103df3:	56                   	push   %esi
80103df4:	50                   	push   %eax
80103df5:	ff 73 04             	pushl  0x4(%ebx)
80103df8:	e8 63 36 00 00       	call   80107460 <deallocuvm>
80103dfd:	83 c4 10             	add    $0x10,%esp
80103e00:	85 c0                	test   %eax,%eax
80103e02:	75 a2                	jne    80103da6 <growproc+0x26>
80103e04:	eb d0                	jmp    80103dd6 <growproc+0x56>
80103e06:	8d 76 00             	lea    0x0(%esi),%esi
80103e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e10 <fork>:
fork(void) {
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80103e19:	e8 62 0b 00 00       	call   80104980 <pushcli>
    c = mycpu();
80103e1e:	e8 9d fd ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
80103e23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103e29:	e8 52 0c 00 00       	call   80104a80 <popcli>
    if ((np = allocproc()) == 0) {
80103e2e:	e8 9d fb ff ff       	call   801039d0 <allocproc>
80103e33:	85 c0                	test   %eax,%eax
80103e35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e38:	0f 84 3b 02 00 00    	je     80104079 <fork+0x269>
    if (firstRun) {
80103e3e:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
80103e44:	85 c9                	test   %ecx,%ecx
80103e46:	0f 85 1c 02 00 00    	jne    80104068 <fork+0x258>
    createSwapFile(np);
80103e4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103e4f:	83 ec 0c             	sub    $0xc,%esp
80103e52:	57                   	push   %edi
80103e53:	e8 98 e3 ff ff       	call   801021f0 <createSwapFile>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103e58:	58                   	pop    %eax
80103e59:	5a                   	pop    %edx
80103e5a:	ff 33                	pushl  (%ebx)
80103e5c:	ff 73 04             	pushl  0x4(%ebx)
80103e5f:	e8 ac 3b 00 00       	call   80107a10 <copyuvm>
80103e64:	83 c4 10             	add    $0x10,%esp
80103e67:	85 c0                	test   %eax,%eax
80103e69:	89 47 04             	mov    %eax,0x4(%edi)
80103e6c:	0f 84 0e 02 00 00    	je     80104080 <fork+0x270>
    np->sz = curproc->sz;
80103e72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e75:	8b 03                	mov    (%ebx),%eax
    *np->tf = *curproc->tf;
80103e77:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->sz = curproc->sz;
80103e7c:	89 02                	mov    %eax,(%edx)
    np->parent = curproc;
80103e7e:	89 5a 14             	mov    %ebx,0x14(%edx)
    *np->tf = *curproc->tf;
80103e81:	8b 7a 18             	mov    0x18(%edx),%edi
80103e84:	8b 73 18             	mov    0x18(%ebx),%esi
80103e87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->nextpageid = curproc->nextpageid;
80103e89:	89 d7                	mov    %edx,%edi
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103e8b:	8d b7 00 04 00 00    	lea    0x400(%edi),%esi
    np->nextpageid = curproc->nextpageid;
80103e91:	8b 83 08 04 00 00    	mov    0x408(%ebx),%eax
80103e97:	89 82 08 04 00 00    	mov    %eax,0x408(%edx)
    np->pagesCounter = curproc->pagesCounter;
80103e9d:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
80103ea3:	89 82 0c 04 00 00    	mov    %eax,0x40c(%edx)
    np->pagesequel = curproc->pagesequel;
80103ea9:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
80103eaf:	89 82 14 04 00 00    	mov    %eax,0x414(%edx)
    np->pagesinSwap = curproc->pagesinSwap;
80103eb5:	8b 83 10 04 00 00    	mov    0x410(%ebx),%eax
80103ebb:	89 82 10 04 00 00    	mov    %eax,0x410(%edx)
        np->swapFileEntries[k]=curproc->swapFileEntries[k];
80103ec1:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
80103ec7:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
80103ecd:	8b 83 04 04 00 00    	mov    0x404(%ebx),%eax
80103ed3:	89 82 04 04 00 00    	mov    %eax,0x404(%edx)
    for( pg = np->pages , cg = curproc->pages;
80103ed9:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
80103edf:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80103ee5:	8d 76 00             	lea    0x0(%esi),%esi
        pg->offset = cg->offset;
80103ee8:	8b 4a 10             	mov    0x10(%edx),%ecx
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103eeb:	83 c0 1c             	add    $0x1c,%eax
80103eee:	83 c2 1c             	add    $0x1c,%edx
        pg->offset = cg->offset;
80103ef1:	89 48 f4             	mov    %ecx,-0xc(%eax)
        pg->pageid = cg->pageid;
80103ef4:	8b 4a e8             	mov    -0x18(%edx),%ecx
80103ef7:	89 48 e8             	mov    %ecx,-0x18(%eax)
        pg->present = cg->present;
80103efa:	8b 4a f0             	mov    -0x10(%edx),%ecx
80103efd:	89 48 f0             	mov    %ecx,-0x10(%eax)
        pg->sequel = cg->sequel;
80103f00:	8b 4a ec             	mov    -0x14(%edx),%ecx
80103f03:	89 48 ec             	mov    %ecx,-0x14(%eax)
        pg->physAdress = cg->physAdress;
80103f06:	8b 4a f8             	mov    -0x8(%edx),%ecx
80103f09:	89 48 f8             	mov    %ecx,-0x8(%eax)
        pg->virtAdress = cg->virtAdress;
80103f0c:	8b 4a fc             	mov    -0x4(%edx),%ecx
80103f0f:	89 48 fc             	mov    %ecx,-0x4(%eax)
    for( pg = np->pages , cg = curproc->pages;
80103f12:	39 f0                	cmp    %esi,%eax
80103f14:	72 d2                	jb     80103ee8 <fork+0xd8>
    if (!firstRun) {
80103f16:	8b 3d 08 b0 10 80    	mov    0x8010b008,%edi
80103f1c:	85 ff                	test   %edi,%edi
80103f1e:	0f 85 ac 00 00 00    	jne    80103fd0 <fork+0x1c0>
        for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80103f24:	83 bb 0c 04 00 00 02 	cmpl   $0x2,0x40c(%ebx)
80103f2b:	7f 38                	jg     80103f65 <fork+0x155>
80103f2d:	e9 9e 00 00 00       	jmp    80103fd0 <fork+0x1c0>
80103f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
80103f38:	68 00 10 00 00       	push   $0x1000
80103f3d:	52                   	push   %edx
80103f3e:	68 20 3d 11 80       	push   $0x80113d20
80103f43:	ff 75 e4             	pushl  -0x1c(%ebp)
80103f46:	e8 45 e3 ff ff       	call   80102290 <writeToSwapFile>
80103f4b:	83 c4 10             	add    $0x10,%esp
80103f4e:	83 f8 ff             	cmp    $0xffffffff,%eax
80103f51:	89 c6                	mov    %eax,%esi
80103f53:	74 4a                	je     80103f9f <fork+0x18f>
        for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80103f55:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
80103f5b:	83 c7 01             	add    $0x1,%edi
80103f5e:	83 e8 02             	sub    $0x2,%eax
80103f61:	39 f8                	cmp    %edi,%eax
80103f63:	7e 6b                	jle    80103fd0 <fork+0x1c0>
            memset(buffer, 0, PGSIZE);
80103f65:	83 ec 04             	sub    $0x4,%esp
80103f68:	68 00 10 00 00       	push   $0x1000
80103f6d:	6a 00                	push   $0x0
80103f6f:	68 20 3d 11 80       	push   $0x80113d20
80103f74:	e8 c7 0b 00 00       	call   80104b40 <memset>
80103f79:	89 fa                	mov    %edi,%edx
            if (readFromSwapFile(curproc, buffer, k * PGSIZE, PGSIZE) == -1) {
80103f7b:	68 00 10 00 00       	push   $0x1000
80103f80:	c1 e2 0c             	shl    $0xc,%edx
80103f83:	52                   	push   %edx
80103f84:	68 20 3d 11 80       	push   $0x80113d20
80103f89:	53                   	push   %ebx
80103f8a:	89 55 e0             	mov    %edx,-0x20(%ebp)
80103f8d:	e8 2e e3 ff ff       	call   801022c0 <readFromSwapFile>
80103f92:	83 c4 20             	add    $0x20,%esp
80103f95:	83 f8 ff             	cmp    $0xffffffff,%eax
80103f98:	89 c6                	mov    %eax,%esi
80103f9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103f9d:	75 99                	jne    80103f38 <fork+0x128>
                kfree(np->kstack);
80103f9f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103fa2:	83 ec 0c             	sub    $0xc,%esp
80103fa5:	ff 73 08             	pushl  0x8(%ebx)
80103fa8:	e8 33 e7 ff ff       	call   801026e0 <kfree>
                np->kstack = 0;
80103fad:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                np->state = UNUSED;
80103fb4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                removeSwapFile(np); //clear swapFile
80103fbb:	89 1c 24             	mov    %ebx,(%esp)
80103fbe:	e8 2d e0 ff ff       	call   80101ff0 <removeSwapFile>
                return -1;
80103fc3:	83 c4 10             	add    $0x10,%esp
}
80103fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fc9:	89 f0                	mov    %esi,%eax
80103fcb:	5b                   	pop    %ebx
80103fcc:	5e                   	pop    %esi
80103fcd:	5f                   	pop    %edi
80103fce:	5d                   	pop    %ebp
80103fcf:	c3                   	ret    
    np->tf->eax = 0;
80103fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    for (i = 0; i < NOFILE; i++)
80103fd3:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80103fd5:	8b 40 18             	mov    0x18(%eax),%eax
80103fd8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103fdf:	90                   	nop
        if (curproc->ofile[i])
80103fe0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103fe4:	85 c0                	test   %eax,%eax
80103fe6:	74 13                	je     80103ffb <fork+0x1eb>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103fe8:	83 ec 0c             	sub    $0xc,%esp
80103feb:	50                   	push   %eax
80103fec:	e8 2f ce ff ff       	call   80100e20 <filedup>
80103ff1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103ff4:	83 c4 10             	add    $0x10,%esp
80103ff7:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103ffb:	83 c6 01             	add    $0x1,%esi
80103ffe:	83 fe 10             	cmp    $0x10,%esi
80104001:	75 dd                	jne    80103fe0 <fork+0x1d0>
    np->cwd = idup(curproc->cwd);
80104003:	83 ec 0c             	sub    $0xc,%esp
80104006:	ff 73 68             	pushl  0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104009:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
8010400c:	e8 7f d6 ff ff       	call   80101690 <idup>
80104011:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104014:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
80104017:	89 46 68             	mov    %eax,0x68(%esi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010401a:	8d 46 6c             	lea    0x6c(%esi),%eax
8010401d:	6a 10                	push   $0x10
8010401f:	53                   	push   %ebx
80104020:	89 f3                	mov    %esi,%ebx
80104022:	50                   	push   %eax
80104023:	e8 f8 0c 00 00       	call   80104d20 <safestrcpy>
    pid = np->pid;
80104028:	8b 76 10             	mov    0x10(%esi),%esi
    acquire(&ptable.lock);
8010402b:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80104032:	e8 89 09 00 00       	call   801049c0 <acquire>
    np->state = RUNNABLE;
80104037:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
8010403e:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80104045:	e8 96 0a 00 00       	call   80104ae0 <release>
    firstRun = 0;
8010404a:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104051:	00 00 00 
    return pid;
80104054:	83 c4 10             	add    $0x10,%esp
}
80104057:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010405a:	89 f0                	mov    %esi,%eax
8010405c:	5b                   	pop    %ebx
8010405d:	5e                   	pop    %esi
8010405e:	5f                   	pop    %edi
8010405f:	5d                   	pop    %ebp
80104060:	c3                   	ret    
80104061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        createSwapFile(curproc);
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	53                   	push   %ebx
8010406c:	e8 7f e1 ff ff       	call   801021f0 <createSwapFile>
80104071:	83 c4 10             	add    $0x10,%esp
80104074:	e9 d3 fd ff ff       	jmp    80103e4c <fork+0x3c>
        return -1;
80104079:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010407e:	eb d7                	jmp    80104057 <fork+0x247>
        kfree(np->kstack);
80104080:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104083:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80104086:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->kstack);
8010408b:	ff 73 08             	pushl  0x8(%ebx)
8010408e:	e8 4d e6 ff ff       	call   801026e0 <kfree>
        np->kstack = 0;
80104093:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
8010409a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
801040a1:	83 c4 10             	add    $0x10,%esp
801040a4:	eb b1                	jmp    80104057 <fork+0x247>
801040a6:	8d 76 00             	lea    0x0(%esi),%esi
801040a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040b0 <scheduler>:
scheduler(void) {
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	57                   	push   %edi
801040b4:	56                   	push   %esi
801040b5:	53                   	push   %ebx
801040b6:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
801040b9:	e8 02 fb ff ff       	call   80103bc0 <mycpu>
801040be:	8d 78 04             	lea    0x4(%eax),%edi
801040c1:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801040c3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040ca:	00 00 00 
801040cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801040d0:	fb                   	sti    
        acquire(&ptable.lock);
801040d1:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040d4:	bb 54 4d 11 80       	mov    $0x80114d54,%ebx
        acquire(&ptable.lock);
801040d9:	68 20 4d 11 80       	push   $0x80114d20
801040de:	e8 dd 08 00 00       	call   801049c0 <acquire>
801040e3:	83 c4 10             	add    $0x10,%esp
801040e6:	8d 76 00             	lea    0x0(%esi),%esi
801040e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (p->state != RUNNABLE)
801040f0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801040f4:	75 33                	jne    80104129 <scheduler+0x79>
            switchuvm(p);
801040f6:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
801040f9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
801040ff:	53                   	push   %ebx
80104100:	e8 db 2f 00 00       	call   801070e0 <switchuvm>
            swtch(&(c->scheduler), p->context);
80104105:	58                   	pop    %eax
80104106:	5a                   	pop    %edx
80104107:	ff 73 1c             	pushl  0x1c(%ebx)
8010410a:	57                   	push   %edi
            p->state = RUNNING;
8010410b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80104112:	e8 64 0c 00 00       	call   80104d7b <swtch>
            switchkvm();
80104117:	e8 a4 2f 00 00       	call   801070c0 <switchkvm>
            c->proc = 0;
8010411c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104123:	00 00 00 
80104126:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104129:	81 c3 18 04 00 00    	add    $0x418,%ebx
8010412f:	81 fb 54 53 12 80    	cmp    $0x80125354,%ebx
80104135:	72 b9                	jb     801040f0 <scheduler+0x40>
        release(&ptable.lock);
80104137:	83 ec 0c             	sub    $0xc,%esp
8010413a:	68 20 4d 11 80       	push   $0x80114d20
8010413f:	e8 9c 09 00 00       	call   80104ae0 <release>
        sti();
80104144:	83 c4 10             	add    $0x10,%esp
80104147:	eb 87                	jmp    801040d0 <scheduler+0x20>
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104150 <sched>:
sched(void) {
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	56                   	push   %esi
80104154:	53                   	push   %ebx
    pushcli();
80104155:	e8 26 08 00 00       	call   80104980 <pushcli>
    c = mycpu();
8010415a:	e8 61 fa ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
8010415f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104165:	e8 16 09 00 00       	call   80104a80 <popcli>
    if (!holding(&ptable.lock))
8010416a:	83 ec 0c             	sub    $0xc,%esp
8010416d:	68 20 4d 11 80       	push   $0x80114d20
80104172:	e8 c9 07 00 00       	call   80104940 <holding>
80104177:	83 c4 10             	add    $0x10,%esp
8010417a:	85 c0                	test   %eax,%eax
8010417c:	74 4f                	je     801041cd <sched+0x7d>
    if (mycpu()->ncli != 1)
8010417e:	e8 3d fa ff ff       	call   80103bc0 <mycpu>
80104183:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010418a:	75 68                	jne    801041f4 <sched+0xa4>
    if (p->state == RUNNING)
8010418c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104190:	74 55                	je     801041e7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104192:	9c                   	pushf  
80104193:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80104194:	f6 c4 02             	test   $0x2,%ah
80104197:	75 41                	jne    801041da <sched+0x8a>
    intena = mycpu()->intena;
80104199:	e8 22 fa ff ff       	call   80103bc0 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
8010419e:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
801041a1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
801041a7:	e8 14 fa ff ff       	call   80103bc0 <mycpu>
801041ac:	83 ec 08             	sub    $0x8,%esp
801041af:	ff 70 04             	pushl  0x4(%eax)
801041b2:	53                   	push   %ebx
801041b3:	e8 c3 0b 00 00       	call   80104d7b <swtch>
    mycpu()->intena = intena;
801041b8:	e8 03 fa ff ff       	call   80103bc0 <mycpu>
}
801041bd:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
801041c0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801041c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c9:	5b                   	pop    %ebx
801041ca:	5e                   	pop    %esi
801041cb:	5d                   	pop    %ebp
801041cc:	c3                   	ret    
        panic("sched ptable.lock");
801041cd:	83 ec 0c             	sub    $0xc,%esp
801041d0:	68 b0 81 10 80       	push   $0x801081b0
801041d5:	e8 b6 c1 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
801041da:	83 ec 0c             	sub    $0xc,%esp
801041dd:	68 dc 81 10 80       	push   $0x801081dc
801041e2:	e8 a9 c1 ff ff       	call   80100390 <panic>
        panic("sched running");
801041e7:	83 ec 0c             	sub    $0xc,%esp
801041ea:	68 ce 81 10 80       	push   $0x801081ce
801041ef:	e8 9c c1 ff ff       	call   80100390 <panic>
        panic("sched locks");
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	68 c2 81 10 80       	push   $0x801081c2
801041fc:	e8 8f c1 ff ff       	call   80100390 <panic>
80104201:	eb 0d                	jmp    80104210 <exit>
80104203:	90                   	nop
80104204:	90                   	nop
80104205:	90                   	nop
80104206:	90                   	nop
80104207:	90                   	nop
80104208:	90                   	nop
80104209:	90                   	nop
8010420a:	90                   	nop
8010420b:	90                   	nop
8010420c:	90                   	nop
8010420d:	90                   	nop
8010420e:	90                   	nop
8010420f:	90                   	nop

80104210 <exit>:
exit(void) {
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
80104216:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104219:	e8 62 07 00 00       	call   80104980 <pushcli>
    c = mycpu();
8010421e:	e8 9d f9 ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
80104223:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104229:	e8 52 08 00 00       	call   80104a80 <popcli>
    if (curproc == initproc)
8010422e:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80104234:	8d 73 28             	lea    0x28(%ebx),%esi
80104237:	8d 7b 68             	lea    0x68(%ebx),%edi
8010423a:	0f 84 11 01 00 00    	je     80104351 <exit+0x141>
        if (curproc->ofile[fd]) {
80104240:	8b 06                	mov    (%esi),%eax
80104242:	85 c0                	test   %eax,%eax
80104244:	74 12                	je     80104258 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	50                   	push   %eax
8010424a:	e8 21 cc ff ff       	call   80100e70 <fileclose>
            curproc->ofile[fd] = 0;
8010424f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104255:	83 c4 10             	add    $0x10,%esp
80104258:	83 c6 04             	add    $0x4,%esi
    for (fd = 0; fd < NOFILE; fd++) {
8010425b:	39 fe                	cmp    %edi,%esi
8010425d:	75 e1                	jne    80104240 <exit+0x30>
    begin_op();
8010425f:	e8 0c ed ff ff       	call   80102f70 <begin_op>
    iput(curproc->cwd);
80104264:	83 ec 0c             	sub    $0xc,%esp
80104267:	ff 73 68             	pushl  0x68(%ebx)
8010426a:	e8 81 d5 ff ff       	call   801017f0 <iput>
    end_op();
8010426f:	e8 6c ed ff ff       	call   80102fe0 <end_op>
    if (curproc->pid > 2)
80104274:	83 c4 10             	add    $0x10,%esp
80104277:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
    curproc->cwd = 0;
8010427b:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
    if (curproc->pid > 2)
80104282:	7e 0c                	jle    80104290 <exit+0x80>
        removeSwapFile(curproc);
80104284:	83 ec 0c             	sub    $0xc,%esp
80104287:	53                   	push   %ebx
80104288:	e8 63 dd ff ff       	call   80101ff0 <removeSwapFile>
8010428d:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
80104290:	83 ec 0c             	sub    $0xc,%esp
80104293:	68 20 4d 11 80       	push   $0x80114d20
80104298:	e8 23 07 00 00       	call   801049c0 <acquire>
    wakeup1(curproc->parent);
8010429d:	8b 53 14             	mov    0x14(%ebx),%edx
801042a0:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042a3:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
801042a8:	eb 12                	jmp    801042bc <exit+0xac>
801042aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042b0:	05 18 04 00 00       	add    $0x418,%eax
801042b5:	3d 54 53 12 80       	cmp    $0x80125354,%eax
801042ba:	73 1e                	jae    801042da <exit+0xca>
        if (p->state == SLEEPING && p->chan == chan)
801042bc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042c0:	75 ee                	jne    801042b0 <exit+0xa0>
801042c2:	3b 50 20             	cmp    0x20(%eax),%edx
801042c5:	75 e9                	jne    801042b0 <exit+0xa0>
            p->state = RUNNABLE;
801042c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ce:	05 18 04 00 00       	add    $0x418,%eax
801042d3:	3d 54 53 12 80       	cmp    $0x80125354,%eax
801042d8:	72 e2                	jb     801042bc <exit+0xac>
            p->parent = initproc;
801042da:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042e0:	ba 54 4d 11 80       	mov    $0x80114d54,%edx
801042e5:	eb 17                	jmp    801042fe <exit+0xee>
801042e7:	89 f6                	mov    %esi,%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801042f0:	81 c2 18 04 00 00    	add    $0x418,%edx
801042f6:	81 fa 54 53 12 80    	cmp    $0x80125354,%edx
801042fc:	73 3a                	jae    80104338 <exit+0x128>
        if (p->parent == curproc) {
801042fe:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104301:	75 ed                	jne    801042f0 <exit+0xe0>
            if (p->state == ZOMBIE)
80104303:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104307:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010430a:	75 e4                	jne    801042f0 <exit+0xe0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010430c:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
80104311:	eb 11                	jmp    80104324 <exit+0x114>
80104313:	90                   	nop
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104318:	05 18 04 00 00       	add    $0x418,%eax
8010431d:	3d 54 53 12 80       	cmp    $0x80125354,%eax
80104322:	73 cc                	jae    801042f0 <exit+0xe0>
        if (p->state == SLEEPING && p->chan == chan)
80104324:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104328:	75 ee                	jne    80104318 <exit+0x108>
8010432a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010432d:	75 e9                	jne    80104318 <exit+0x108>
            p->state = RUNNABLE;
8010432f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104336:	eb e0                	jmp    80104318 <exit+0x108>
    curproc->state = ZOMBIE;
80104338:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
    sched();
8010433f:	e8 0c fe ff ff       	call   80104150 <sched>
    panic("zombie exit");
80104344:	83 ec 0c             	sub    $0xc,%esp
80104347:	68 fd 81 10 80       	push   $0x801081fd
8010434c:	e8 3f c0 ff ff       	call   80100390 <panic>
        panic("init exiting");
80104351:	83 ec 0c             	sub    $0xc,%esp
80104354:	68 f0 81 10 80       	push   $0x801081f0
80104359:	e8 32 c0 ff ff       	call   80100390 <panic>
8010435e:	66 90                	xchg   %ax,%ax

80104360 <yield>:
yield(void) {
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104367:	68 20 4d 11 80       	push   $0x80114d20
8010436c:	e8 4f 06 00 00       	call   801049c0 <acquire>
    pushcli();
80104371:	e8 0a 06 00 00       	call   80104980 <pushcli>
    c = mycpu();
80104376:	e8 45 f8 ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
8010437b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104381:	e8 fa 06 00 00       	call   80104a80 <popcli>
    myproc()->state = RUNNABLE;
80104386:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
8010438d:	e8 be fd ff ff       	call   80104150 <sched>
    release(&ptable.lock);
80104392:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
80104399:	e8 42 07 00 00       	call   80104ae0 <release>
}
8010439e:	83 c4 10             	add    $0x10,%esp
801043a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a4:	c9                   	leave  
801043a5:	c3                   	ret    
801043a6:	8d 76 00             	lea    0x0(%esi),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <sleep>:
sleep(void *chan, struct spinlock *lk) {
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	57                   	push   %edi
801043b4:	56                   	push   %esi
801043b5:	53                   	push   %ebx
801043b6:	83 ec 0c             	sub    $0xc,%esp
801043b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043bc:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
801043bf:	e8 bc 05 00 00       	call   80104980 <pushcli>
    c = mycpu();
801043c4:	e8 f7 f7 ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
801043c9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801043cf:	e8 ac 06 00 00       	call   80104a80 <popcli>
    if (p == 0)
801043d4:	85 db                	test   %ebx,%ebx
801043d6:	0f 84 87 00 00 00    	je     80104463 <sleep+0xb3>
    if (lk == 0)
801043dc:	85 f6                	test   %esi,%esi
801043de:	74 76                	je     80104456 <sleep+0xa6>
    if (lk != &ptable.lock) {  //DOC: sleeplock0
801043e0:	81 fe 20 4d 11 80    	cmp    $0x80114d20,%esi
801043e6:	74 50                	je     80104438 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	68 20 4d 11 80       	push   $0x80114d20
801043f0:	e8 cb 05 00 00       	call   801049c0 <acquire>
        release(lk);
801043f5:	89 34 24             	mov    %esi,(%esp)
801043f8:	e8 e3 06 00 00       	call   80104ae0 <release>
    p->chan = chan;
801043fd:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104400:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104407:	e8 44 fd ff ff       	call   80104150 <sched>
    p->chan = 0;
8010440c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80104413:	c7 04 24 20 4d 11 80 	movl   $0x80114d20,(%esp)
8010441a:	e8 c1 06 00 00       	call   80104ae0 <release>
        acquire(lk);
8010441f:	89 75 08             	mov    %esi,0x8(%ebp)
80104422:	83 c4 10             	add    $0x10,%esp
}
80104425:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104428:	5b                   	pop    %ebx
80104429:	5e                   	pop    %esi
8010442a:	5f                   	pop    %edi
8010442b:	5d                   	pop    %ebp
        acquire(lk);
8010442c:	e9 8f 05 00 00       	jmp    801049c0 <acquire>
80104431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104438:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010443b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104442:	e8 09 fd ff ff       	call   80104150 <sched>
    p->chan = 0;
80104447:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010444e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104451:	5b                   	pop    %ebx
80104452:	5e                   	pop    %esi
80104453:	5f                   	pop    %edi
80104454:	5d                   	pop    %ebp
80104455:	c3                   	ret    
        panic("sleep without lk");
80104456:	83 ec 0c             	sub    $0xc,%esp
80104459:	68 0f 82 10 80       	push   $0x8010820f
8010445e:	e8 2d bf ff ff       	call   80100390 <panic>
        panic("sleep");
80104463:	83 ec 0c             	sub    $0xc,%esp
80104466:	68 09 82 10 80       	push   $0x80108209
8010446b:	e8 20 bf ff ff       	call   80100390 <panic>

80104470 <wait>:
wait(void) {
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
    pushcli();
80104475:	e8 06 05 00 00       	call   80104980 <pushcli>
    c = mycpu();
8010447a:	e8 41 f7 ff ff       	call   80103bc0 <mycpu>
    p = c->proc;
8010447f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104485:	e8 f6 05 00 00       	call   80104a80 <popcli>
    acquire(&ptable.lock);
8010448a:	83 ec 0c             	sub    $0xc,%esp
8010448d:	68 20 4d 11 80       	push   $0x80114d20
80104492:	e8 29 05 00 00       	call   801049c0 <acquire>
80104497:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
8010449a:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010449c:	bb 54 4d 11 80       	mov    $0x80114d54,%ebx
801044a1:	eb 13                	jmp    801044b6 <wait+0x46>
801044a3:	90                   	nop
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a8:	81 c3 18 04 00 00    	add    $0x418,%ebx
801044ae:	81 fb 54 53 12 80    	cmp    $0x80125354,%ebx
801044b4:	73 1e                	jae    801044d4 <wait+0x64>
            if (p->parent != curproc)
801044b6:	39 73 14             	cmp    %esi,0x14(%ebx)
801044b9:	75 ed                	jne    801044a8 <wait+0x38>
            if (p->state == ZOMBIE) {
801044bb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044bf:	74 3f                	je     80104500 <wait+0x90>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044c1:	81 c3 18 04 00 00    	add    $0x418,%ebx
            havekids = 1;
801044c7:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044cc:	81 fb 54 53 12 80    	cmp    $0x80125354,%ebx
801044d2:	72 e2                	jb     801044b6 <wait+0x46>
        if (!havekids || curproc->killed) {
801044d4:	85 c0                	test   %eax,%eax
801044d6:	0f 84 18 01 00 00    	je     801045f4 <wait+0x184>
801044dc:	8b 46 24             	mov    0x24(%esi),%eax
801044df:	85 c0                	test   %eax,%eax
801044e1:	0f 85 0d 01 00 00    	jne    801045f4 <wait+0x184>
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801044e7:	83 ec 08             	sub    $0x8,%esp
801044ea:	68 20 4d 11 80       	push   $0x80114d20
801044ef:	56                   	push   %esi
801044f0:	e8 bb fe ff ff       	call   801043b0 <sleep>
        havekids = 0;
801044f5:	83 c4 10             	add    $0x10,%esp
801044f8:	eb a0                	jmp    8010449a <wait+0x2a>
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                kfree(p->kstack);
80104500:	83 ec 0c             	sub    $0xc,%esp
80104503:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
80104506:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80104509:	e8 d2 e1 ff ff       	call   801026e0 <kfree>
                freevm(p->pgdir);
8010450e:	5a                   	pop    %edx
8010450f:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
80104512:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104519:	e8 a2 33 00 00       	call   801078c0 <freevm>
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010451e:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80104524:	8d 93 00 04 00 00    	lea    0x400(%ebx),%edx
                p->pid = 0;
8010452a:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104531:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104538:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010453c:	83 c4 10             	add    $0x10,%esp
                p->killed = 0;
8010453f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80104546:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->pagesCounter = -1;
8010454d:	c7 83 0c 04 00 00 ff 	movl   $0xffffffff,0x40c(%ebx)
80104554:	ff ff ff 
                p->nextpageid = 0;
80104557:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
8010455e:	00 00 00 
                p->pagesequel = 0;
80104561:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104568:	00 00 00 
                p->pagesinSwap = 0;
8010456b:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104572:	00 00 00 
                    p->swapFileEntries[k]=0;
80104575:	c7 83 00 04 00 00 00 	movl   $0x0,0x400(%ebx)
8010457c:	00 00 00 
8010457f:	c7 83 04 04 00 00 00 	movl   $0x0,0x404(%ebx)
80104586:	00 00 00 
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    pg->active = 0;
80104590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                    pg->offset = 0;
80104596:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
8010459d:	83 c0 1c             	add    $0x1c,%eax
                    pg->pageid = 0;
801045a0:	c7 40 e8 00 00 00 00 	movl   $0x0,-0x18(%eax)
                    pg->present = -1;
801045a7:	c7 40 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%eax)
                    pg->sequel = -1;
801045ae:	c7 40 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%eax)
                    pg->physAdress = 0;
801045b5:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
                    pg->virtAdress = 0;
801045bc:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801045c3:	39 c2                	cmp    %eax,%edx
801045c5:	77 c9                	ja     80104590 <wait+0x120>
                release(&ptable.lock);
801045c7:	83 ec 0c             	sub    $0xc,%esp
                    p->swapFileEntries[k]=0;
801045ca:	c7 83 00 04 00 00 00 	movl   $0x0,0x400(%ebx)
801045d1:	00 00 00 
801045d4:	c7 83 04 04 00 00 00 	movl   $0x0,0x404(%ebx)
801045db:	00 00 00 
                release(&ptable.lock);
801045de:	68 20 4d 11 80       	push   $0x80114d20
801045e3:	e8 f8 04 00 00       	call   80104ae0 <release>
                return pid;
801045e8:	83 c4 10             	add    $0x10,%esp
}
801045eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045ee:	89 f0                	mov    %esi,%eax
801045f0:	5b                   	pop    %ebx
801045f1:	5e                   	pop    %esi
801045f2:	5d                   	pop    %ebp
801045f3:	c3                   	ret    
            release(&ptable.lock);
801045f4:	83 ec 0c             	sub    $0xc,%esp
            return -1;
801045f7:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
801045fc:	68 20 4d 11 80       	push   $0x80114d20
80104601:	e8 da 04 00 00       	call   80104ae0 <release>
            return -1;
80104606:	83 c4 10             	add    $0x10,%esp
80104609:	eb e0                	jmp    801045eb <wait+0x17b>
8010460b:	90                   	nop
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104610 <wakeup>:
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
8010461f:	e8 9c 03 00 00       	call   801049c0 <acquire>
80104624:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104627:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
8010462c:	eb 0e                	jmp    8010463c <wakeup+0x2c>
8010462e:	66 90                	xchg   %ax,%ax
80104630:	05 18 04 00 00       	add    $0x418,%eax
80104635:	3d 54 53 12 80       	cmp    $0x80125354,%eax
8010463a:	73 1e                	jae    8010465a <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan)
8010463c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104640:	75 ee                	jne    80104630 <wakeup+0x20>
80104642:	3b 58 20             	cmp    0x20(%eax),%ebx
80104645:	75 e9                	jne    80104630 <wakeup+0x20>
            p->state = RUNNABLE;
80104647:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010464e:	05 18 04 00 00       	add    $0x418,%eax
80104653:	3d 54 53 12 80       	cmp    $0x80125354,%eax
80104658:	72 e2                	jb     8010463c <wakeup+0x2c>
    wakeup1(chan);
    release(&ptable.lock);
8010465a:	c7 45 08 20 4d 11 80 	movl   $0x80114d20,0x8(%ebp)
}
80104661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104664:	c9                   	leave  
    release(&ptable.lock);
80104665:	e9 76 04 00 00       	jmp    80104ae0 <release>
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
8010467f:	e8 3c 03 00 00       	call   801049c0 <acquire>
80104684:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104687:	b8 54 4d 11 80       	mov    $0x80114d54,%eax
8010468c:	eb 0e                	jmp    8010469c <kill+0x2c>
8010468e:	66 90                	xchg   %ax,%ax
80104690:	05 18 04 00 00       	add    $0x418,%eax
80104695:	3d 54 53 12 80       	cmp    $0x80125354,%eax
8010469a:	73 34                	jae    801046d0 <kill+0x60>
        if (p->pid == pid) {
8010469c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010469f:	75 ef                	jne    80104690 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
801046a1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
801046a5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
801046ac:	75 07                	jne    801046b5 <kill+0x45>
                p->state = RUNNABLE;
801046ae:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
801046b5:	83 ec 0c             	sub    $0xc,%esp
801046b8:	68 20 4d 11 80       	push   $0x80114d20
801046bd:	e8 1e 04 00 00       	call   80104ae0 <release>
            return 0;
801046c2:	83 c4 10             	add    $0x10,%esp
801046c5:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801046c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046ca:	c9                   	leave  
801046cb:	c3                   	ret    
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801046d0:	83 ec 0c             	sub    $0xc,%esp
801046d3:	68 20 4d 11 80       	push   $0x80114d20
801046d8:	e8 03 04 00 00       	call   80104ae0 <release>
    return -1;
801046dd:	83 c4 10             	add    $0x10,%esp
801046e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046e8:	c9                   	leave  
801046e9:	c3                   	ret    
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046f0 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	56                   	push   %esi
801046f5:	53                   	push   %ebx
801046f6:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801046f9:	bb 54 4d 11 80       	mov    $0x80114d54,%ebx
procdump(void) {
801046fe:	83 ec 3c             	sub    $0x3c,%esp
80104701:	eb 27                	jmp    8010472a <procdump+0x3a>
80104703:	90                   	nop
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104708:	83 ec 0c             	sub    $0xc,%esp
8010470b:	68 45 86 10 80       	push   $0x80108645
80104710:	e8 4b bf ff ff       	call   80100660 <cprintf>
80104715:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104718:	81 c3 18 04 00 00    	add    $0x418,%ebx
8010471e:	81 fb 54 53 12 80    	cmp    $0x80125354,%ebx
80104724:	0f 83 86 00 00 00    	jae    801047b0 <procdump+0xc0>
        if (p->state == UNUSED)
8010472a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010472d:	85 c0                	test   %eax,%eax
8010472f:	74 e7                	je     80104718 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104731:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104734:	ba 20 82 10 80       	mov    $0x80108220,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104739:	77 11                	ja     8010474c <procdump+0x5c>
8010473b:	8b 14 85 80 82 10 80 	mov    -0x7fef7d80(,%eax,4),%edx
            state = "???";
80104742:	b8 20 82 10 80       	mov    $0x80108220,%eax
80104747:	85 d2                	test   %edx,%edx
80104749:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
8010474c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010474f:	50                   	push   %eax
80104750:	52                   	push   %edx
80104751:	ff 73 10             	pushl  0x10(%ebx)
80104754:	68 24 82 10 80       	push   $0x80108224
80104759:	e8 02 bf ff ff       	call   80100660 <cprintf>
        if (p->state == SLEEPING) {
8010475e:	83 c4 10             	add    $0x10,%esp
80104761:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104765:	75 a1                	jne    80104708 <procdump+0x18>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
80104767:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010476a:	83 ec 08             	sub    $0x8,%esp
8010476d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104770:	50                   	push   %eax
80104771:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104774:	8b 40 0c             	mov    0xc(%eax),%eax
80104777:	83 c0 08             	add    $0x8,%eax
8010477a:	50                   	push   %eax
8010477b:	e8 70 01 00 00       	call   801048f0 <getcallerpcs>
80104780:	83 c4 10             	add    $0x10,%esp
80104783:	90                   	nop
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
80104788:	8b 17                	mov    (%edi),%edx
8010478a:	85 d2                	test   %edx,%edx
8010478c:	0f 84 76 ff ff ff    	je     80104708 <procdump+0x18>
                cprintf(" %p", pc[i]);
80104792:	83 ec 08             	sub    $0x8,%esp
80104795:	83 c7 04             	add    $0x4,%edi
80104798:	52                   	push   %edx
80104799:	68 21 7c 10 80       	push   $0x80107c21
8010479e:	e8 bd be ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801047a3:	83 c4 10             	add    $0x10,%esp
801047a6:	39 fe                	cmp    %edi,%esi
801047a8:	75 de                	jne    80104788 <procdump+0x98>
801047aa:	e9 59 ff ff ff       	jmp    80104708 <procdump+0x18>
801047af:	90                   	nop
    }
}
801047b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047b3:	5b                   	pop    %ebx
801047b4:	5e                   	pop    %esi
801047b5:	5f                   	pop    %edi
801047b6:	5d                   	pop    %ebp
801047b7:	c3                   	ret    
801047b8:	66 90                	xchg   %ax,%ax
801047ba:	66 90                	xchg   %ax,%ax
801047bc:	66 90                	xchg   %ax,%ax
801047be:	66 90                	xchg   %ax,%ax

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
801047ca:	68 98 82 10 80       	push   $0x80108298
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
  lk->pid = 0;
801047e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801047eb:	89 43 38             	mov    %eax,0x38(%ebx)
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
8010480f:	e8 ac 01 00 00       	call   801049c0 <acquire>
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
80104825:	e8 86 fb ff ff       	call   801043b0 <sleep>
  while (lk->locked) {
8010482a:	8b 03                	mov    (%ebx),%eax
8010482c:	83 c4 10             	add    $0x10,%esp
8010482f:	85 c0                	test   %eax,%eax
80104831:	75 ed                	jne    80104820 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104833:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104839:	e8 22 f4 ff ff       	call   80103c60 <myproc>
8010483e:	8b 40 10             	mov    0x10(%eax),%eax
80104841:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104844:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104847:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010484a:	5b                   	pop    %ebx
8010484b:	5e                   	pop    %esi
8010484c:	5d                   	pop    %ebp
  release(&lk->lk);
8010484d:	e9 8e 02 00 00       	jmp    80104ae0 <release>
80104852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <releasesleep>:

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
8010486f:	e8 4c 01 00 00       	call   801049c0 <acquire>
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
  release(&lk->lk);
80104895:	e9 46 02 00 00       	jmp    80104ae0 <release>
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048a0 <holdingsleep>:

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
801048af:	e8 0c 01 00 00       	call   801049c0 <acquire>
  r = lk->locked;
801048b4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801048b6:	89 1c 24             	mov    %ebx,(%esp)
801048b9:	e8 22 02 00 00       	call   80104ae0 <release>
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
  lk->name = name;
801048df:	89 50 04             	mov    %edx,0x4(%eax)
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
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048f1:	31 d2                	xor    %edx,%edx
{
801048f3:	89 e5                	mov    %esp,%ebp
801048f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801048f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801048f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801048fc:	83 e8 08             	sub    $0x8,%eax
801048ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104900:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104906:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010490c:	77 1a                	ja     80104928 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010490e:	8b 58 04             	mov    0x4(%eax),%ebx
80104911:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104914:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104917:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104919:	83 fa 0a             	cmp    $0xa,%edx
8010491c:	75 e2                	jne    80104900 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010491e:	5b                   	pop    %ebx
8010491f:	5d                   	pop    %ebp
80104920:	c3                   	ret    
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104928:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010492b:	83 c1 28             	add    $0x28,%ecx
8010492e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104930:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104936:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104939:	39 c1                	cmp    %eax,%ecx
8010493b:	75 f3                	jne    80104930 <getcallerpcs+0x40>
}
8010493d:	5b                   	pop    %ebx
8010493e:	5d                   	pop    %ebp
8010493f:	c3                   	ret    

80104940 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 04             	sub    $0x4,%esp
80104947:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010494a:	8b 02                	mov    (%edx),%eax
8010494c:	85 c0                	test   %eax,%eax
8010494e:	75 10                	jne    80104960 <holding+0x20>
}
80104950:	83 c4 04             	add    $0x4,%esp
80104953:	31 c0                	xor    %eax,%eax
80104955:	5b                   	pop    %ebx
80104956:	5d                   	pop    %ebp
80104957:	c3                   	ret    
80104958:	90                   	nop
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104960:	8b 5a 08             	mov    0x8(%edx),%ebx
80104963:	e8 58 f2 ff ff       	call   80103bc0 <mycpu>
80104968:	39 c3                	cmp    %eax,%ebx
8010496a:	0f 94 c0             	sete   %al
}
8010496d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104970:	0f b6 c0             	movzbl %al,%eax
}
80104973:	5b                   	pop    %ebx
80104974:	5d                   	pop    %ebp
80104975:	c3                   	ret    
80104976:	8d 76 00             	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 04             	sub    $0x4,%esp
80104987:	9c                   	pushf  
80104988:	5b                   	pop    %ebx
  asm volatile("cli");
80104989:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010498a:	e8 31 f2 ff ff       	call   80103bc0 <mycpu>
8010498f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104995:	85 c0                	test   %eax,%eax
80104997:	75 11                	jne    801049aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104999:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010499f:	e8 1c f2 ff ff       	call   80103bc0 <mycpu>
801049a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801049aa:	e8 11 f2 ff ff       	call   80103bc0 <mycpu>
801049af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049b6:	83 c4 04             	add    $0x4,%esp
801049b9:	5b                   	pop    %ebx
801049ba:	5d                   	pop    %ebp
801049bb:	c3                   	ret    
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049c0 <acquire>:
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801049c5:	e8 b6 ff ff ff       	call   80104980 <pushcli>
  if(holding(lk))
801049ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801049cd:	8b 03                	mov    (%ebx),%eax
801049cf:	85 c0                	test   %eax,%eax
801049d1:	0f 85 81 00 00 00    	jne    80104a58 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801049d7:	ba 01 00 00 00       	mov    $0x1,%edx
801049dc:	eb 05                	jmp    801049e3 <acquire+0x23>
801049de:	66 90                	xchg   %ax,%ax
801049e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049e3:	89 d0                	mov    %edx,%eax
801049e5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801049e8:	85 c0                	test   %eax,%eax
801049ea:	75 f4                	jne    801049e0 <acquire+0x20>
  __sync_synchronize();
801049ec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801049f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049f4:	e8 c7 f1 ff ff       	call   80103bc0 <mycpu>
  for(i = 0; i < 10; i++){
801049f9:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
801049fb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
801049fe:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104a01:	89 e8                	mov    %ebp,%eax
80104a03:	90                   	nop
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a08:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a0e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a14:	77 1a                	ja     80104a30 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104a16:	8b 58 04             	mov    0x4(%eax),%ebx
80104a19:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a1c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a1f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a21:	83 fa 0a             	cmp    $0xa,%edx
80104a24:	75 e2                	jne    80104a08 <acquire+0x48>
}
80104a26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a29:	5b                   	pop    %ebx
80104a2a:	5e                   	pop    %esi
80104a2b:	5d                   	pop    %ebp
80104a2c:	c3                   	ret    
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi
80104a30:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a33:	83 c1 28             	add    $0x28,%ecx
80104a36:	8d 76 00             	lea    0x0(%esi),%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104a40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a46:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a49:	39 c8                	cmp    %ecx,%eax
80104a4b:	75 f3                	jne    80104a40 <acquire+0x80>
}
80104a4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a50:	5b                   	pop    %ebx
80104a51:	5e                   	pop    %esi
80104a52:	5d                   	pop    %ebp
80104a53:	c3                   	ret    
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104a58:	8b 73 08             	mov    0x8(%ebx),%esi
80104a5b:	e8 60 f1 ff ff       	call   80103bc0 <mycpu>
80104a60:	39 c6                	cmp    %eax,%esi
80104a62:	0f 85 6f ff ff ff    	jne    801049d7 <acquire+0x17>
    panic("acquire");
80104a68:	83 ec 0c             	sub    $0xc,%esp
80104a6b:	68 a3 82 10 80       	push   $0x801082a3
80104a70:	e8 1b b9 ff ff       	call   80100390 <panic>
80104a75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <popcli>:

void
popcli(void)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a86:	9c                   	pushf  
80104a87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a88:	f6 c4 02             	test   $0x2,%ah
80104a8b:	75 35                	jne    80104ac2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a8d:	e8 2e f1 ff ff       	call   80103bc0 <mycpu>
80104a92:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a99:	78 34                	js     80104acf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a9b:	e8 20 f1 ff ff       	call   80103bc0 <mycpu>
80104aa0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104aa6:	85 d2                	test   %edx,%edx
80104aa8:	74 06                	je     80104ab0 <popcli+0x30>
    sti();
}
80104aaa:	c9                   	leave  
80104aab:	c3                   	ret    
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ab0:	e8 0b f1 ff ff       	call   80103bc0 <mycpu>
80104ab5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104abb:	85 c0                	test   %eax,%eax
80104abd:	74 eb                	je     80104aaa <popcli+0x2a>
  asm volatile("sti");
80104abf:	fb                   	sti    
}
80104ac0:	c9                   	leave  
80104ac1:	c3                   	ret    
    panic("popcli - interruptible");
80104ac2:	83 ec 0c             	sub    $0xc,%esp
80104ac5:	68 ab 82 10 80       	push   $0x801082ab
80104aca:	e8 c1 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104acf:	83 ec 0c             	sub    $0xc,%esp
80104ad2:	68 c2 82 10 80       	push   $0x801082c2
80104ad7:	e8 b4 b8 ff ff       	call   80100390 <panic>
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <release>:
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	56                   	push   %esi
80104ae4:	53                   	push   %ebx
80104ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104ae8:	8b 03                	mov    (%ebx),%eax
80104aea:	85 c0                	test   %eax,%eax
80104aec:	74 0c                	je     80104afa <release+0x1a>
80104aee:	8b 73 08             	mov    0x8(%ebx),%esi
80104af1:	e8 ca f0 ff ff       	call   80103bc0 <mycpu>
80104af6:	39 c6                	cmp    %eax,%esi
80104af8:	74 16                	je     80104b10 <release+0x30>
    panic("release");
80104afa:	83 ec 0c             	sub    $0xc,%esp
80104afd:	68 c9 82 10 80       	push   $0x801082c9
80104b02:	e8 89 b8 ff ff       	call   80100390 <panic>
80104b07:	89 f6                	mov    %esi,%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104b10:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b17:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b1e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b23:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b29:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b2c:	5b                   	pop    %ebx
80104b2d:	5e                   	pop    %esi
80104b2e:	5d                   	pop    %ebp
  popcli();
80104b2f:	e9 4c ff ff ff       	jmp    80104a80 <popcli>
80104b34:	66 90                	xchg   %ax,%ax
80104b36:	66 90                	xchg   %ax,%ax
80104b38:	66 90                	xchg   %ax,%ax
80104b3a:	66 90                	xchg   %ax,%ax
80104b3c:	66 90                	xchg   %ax,%ax
80104b3e:	66 90                	xchg   %ax,%ax

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
    c &= 0xFF;
80104b68:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b6c:	c1 e9 02             	shr    $0x2,%ecx
80104b6f:	89 f8                	mov    %edi,%eax
80104b71:	89 fb                	mov    %edi,%ebx
80104b73:	c1 e0 18             	shl    $0x18,%eax
80104b76:	c1 e3 10             	shl    $0x10,%ebx
80104b79:	09 d8                	or     %ebx,%eax
80104b7b:	09 f8                	or     %edi,%eax
80104b7d:	c1 e7 08             	shl    $0x8,%edi
80104b80:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104b82:	89 d7                	mov    %edx,%edi
80104b84:	fc                   	cld    
80104b85:	f3 ab                	rep stos %eax,%es:(%edi)
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
80104b95:	53                   	push   %ebx
80104b96:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b99:	8b 75 08             	mov    0x8(%ebp),%esi
80104b9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b9f:	85 db                	test   %ebx,%ebx
80104ba1:	74 29                	je     80104bcc <memcmp+0x3c>
    if(*s1 != *s2)
80104ba3:	0f b6 16             	movzbl (%esi),%edx
80104ba6:	0f b6 0f             	movzbl (%edi),%ecx
80104ba9:	38 d1                	cmp    %dl,%cl
80104bab:	75 2b                	jne    80104bd8 <memcmp+0x48>
80104bad:	b8 01 00 00 00       	mov    $0x1,%eax
80104bb2:	eb 14                	jmp    80104bc8 <memcmp+0x38>
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bb8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104bbc:	83 c0 01             	add    $0x1,%eax
80104bbf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104bc4:	38 ca                	cmp    %cl,%dl
80104bc6:	75 10                	jne    80104bd8 <memcmp+0x48>
  while(n-- > 0){
80104bc8:	39 d8                	cmp    %ebx,%eax
80104bca:	75 ec                	jne    80104bb8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104bcc:	5b                   	pop    %ebx
  return 0;
80104bcd:	31 c0                	xor    %eax,%eax
}
80104bcf:	5e                   	pop    %esi
80104bd0:	5f                   	pop    %edi
80104bd1:	5d                   	pop    %ebp
80104bd2:	c3                   	ret    
80104bd3:	90                   	nop
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104bd8:	0f b6 c2             	movzbl %dl,%eax
}
80104bdb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104bdc:	29 c8                	sub    %ecx,%eax
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
80104bf8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104bfb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104bfe:	39 c3                	cmp    %eax,%ebx
80104c00:	73 26                	jae    80104c28 <memmove+0x38>
80104c02:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104c05:	39 c8                	cmp    %ecx,%eax
80104c07:	73 1f                	jae    80104c28 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104c09:	85 f6                	test   %esi,%esi
80104c0b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104c0e:	74 0f                	je     80104c1f <memmove+0x2f>
      *--d = *--s;
80104c10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104c17:	83 ea 01             	sub    $0x1,%edx
80104c1a:	83 fa ff             	cmp    $0xffffffff,%edx
80104c1d:	75 f1                	jne    80104c10 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c1f:	5b                   	pop    %ebx
80104c20:	5e                   	pop    %esi
80104c21:	5d                   	pop    %ebp
80104c22:	c3                   	ret    
80104c23:	90                   	nop
80104c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104c28:	31 d2                	xor    %edx,%edx
80104c2a:	85 f6                	test   %esi,%esi
80104c2c:	74 f1                	je     80104c1f <memmove+0x2f>
80104c2e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104c30:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104c37:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104c3a:	39 d6                	cmp    %edx,%esi
80104c3c:	75 f2                	jne    80104c30 <memmove+0x40>
}
80104c3e:	5b                   	pop    %ebx
80104c3f:	5e                   	pop    %esi
80104c40:	5d                   	pop    %ebp
80104c41:	c3                   	ret    
80104c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104c53:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104c54:	eb 9a                	jmp    80104bf0 <memmove>
80104c56:	8d 76 00             	lea    0x0(%esi),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
80104c65:	8b 7d 10             	mov    0x10(%ebp),%edi
80104c68:	53                   	push   %ebx
80104c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104c6f:	85 ff                	test   %edi,%edi
80104c71:	74 2f                	je     80104ca2 <strncmp+0x42>
80104c73:	0f b6 01             	movzbl (%ecx),%eax
80104c76:	0f b6 1e             	movzbl (%esi),%ebx
80104c79:	84 c0                	test   %al,%al
80104c7b:	74 37                	je     80104cb4 <strncmp+0x54>
80104c7d:	38 c3                	cmp    %al,%bl
80104c7f:	75 33                	jne    80104cb4 <strncmp+0x54>
80104c81:	01 f7                	add    %esi,%edi
80104c83:	eb 13                	jmp    80104c98 <strncmp+0x38>
80104c85:	8d 76 00             	lea    0x0(%esi),%esi
80104c88:	0f b6 01             	movzbl (%ecx),%eax
80104c8b:	84 c0                	test   %al,%al
80104c8d:	74 21                	je     80104cb0 <strncmp+0x50>
80104c8f:	0f b6 1a             	movzbl (%edx),%ebx
80104c92:	89 d6                	mov    %edx,%esi
80104c94:	38 d8                	cmp    %bl,%al
80104c96:	75 1c                	jne    80104cb4 <strncmp+0x54>
    n--, p++, q++;
80104c98:	8d 56 01             	lea    0x1(%esi),%edx
80104c9b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c9e:	39 fa                	cmp    %edi,%edx
80104ca0:	75 e6                	jne    80104c88 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104ca2:	5b                   	pop    %ebx
    return 0;
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	5e                   	pop    %esi
80104ca6:	5f                   	pop    %edi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104cb4:	29 d8                	sub    %ebx,%eax
}
80104cb6:	5b                   	pop    %ebx
80104cb7:	5e                   	pop    %esi
80104cb8:	5f                   	pop    %edi
80104cb9:	5d                   	pop    %ebp
80104cba:	c3                   	ret    
80104cbb:	90                   	nop
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cc0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ccb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cce:	89 c2                	mov    %eax,%edx
80104cd0:	eb 19                	jmp    80104ceb <strncpy+0x2b>
80104cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cd8:	83 c3 01             	add    $0x1,%ebx
80104cdb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104cdf:	83 c2 01             	add    $0x1,%edx
80104ce2:	84 c9                	test   %cl,%cl
80104ce4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ce7:	74 09                	je     80104cf2 <strncpy+0x32>
80104ce9:	89 f1                	mov    %esi,%ecx
80104ceb:	85 c9                	test   %ecx,%ecx
80104ced:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104cf0:	7f e6                	jg     80104cd8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104cf2:	31 c9                	xor    %ecx,%ecx
80104cf4:	85 f6                	test   %esi,%esi
80104cf6:	7e 17                	jle    80104d0f <strncpy+0x4f>
80104cf8:	90                   	nop
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104d00:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104d04:	89 f3                	mov    %esi,%ebx
80104d06:	83 c1 01             	add    $0x1,%ecx
80104d09:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104d0b:	85 db                	test   %ebx,%ebx
80104d0d:	7f f1                	jg     80104d00 <strncpy+0x40>
  return os;
}
80104d0f:	5b                   	pop    %ebx
80104d10:	5e                   	pop    %esi
80104d11:	5d                   	pop    %ebp
80104d12:	c3                   	ret    
80104d13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
80104d25:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d28:	8b 45 08             	mov    0x8(%ebp),%eax
80104d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104d2e:	85 c9                	test   %ecx,%ecx
80104d30:	7e 26                	jle    80104d58 <safestrcpy+0x38>
80104d32:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104d36:	89 c1                	mov    %eax,%ecx
80104d38:	eb 17                	jmp    80104d51 <safestrcpy+0x31>
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d40:	83 c2 01             	add    $0x1,%edx
80104d43:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104d47:	83 c1 01             	add    $0x1,%ecx
80104d4a:	84 db                	test   %bl,%bl
80104d4c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104d4f:	74 04                	je     80104d55 <safestrcpy+0x35>
80104d51:	39 f2                	cmp    %esi,%edx
80104d53:	75 eb                	jne    80104d40 <safestrcpy+0x20>
    ;
  *s = 0;
80104d55:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104d58:	5b                   	pop    %ebx
80104d59:	5e                   	pop    %esi
80104d5a:	5d                   	pop    %ebp
80104d5b:	c3                   	ret    
80104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d60 <strlen>:

int
strlen(const char *s)
{
80104d60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d61:	31 c0                	xor    %eax,%eax
{
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d68:	80 3a 00             	cmpb   $0x0,(%edx)
80104d6b:	74 0c                	je     80104d79 <strlen+0x19>
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi
80104d70:	83 c0 01             	add    $0x1,%eax
80104d73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d77:	75 f7                	jne    80104d70 <strlen+0x10>
    ;
  return n;
}
80104d79:	5d                   	pop    %ebp
80104d7a:	c3                   	ret    

80104d7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104d83:	55                   	push   %ebp
  pushl %ebx
80104d84:	53                   	push   %ebx
  pushl %esi
80104d85:	56                   	push   %esi
  pushl %edi
80104d86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104d87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104d89:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104d8b:	5f                   	pop    %edi
  popl %esi
80104d8c:	5e                   	pop    %esi
  popl %ebx
80104d8d:	5b                   	pop    %ebx
  popl %ebp
80104d8e:	5d                   	pop    %ebp
  ret
80104d8f:	c3                   	ret    

80104d90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 04             	sub    $0x4,%esp
80104d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d9a:	e8 c1 ee ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d9f:	8b 00                	mov    (%eax),%eax
80104da1:	39 d8                	cmp    %ebx,%eax
80104da3:	76 1b                	jbe    80104dc0 <fetchint+0x30>
80104da5:	8d 53 04             	lea    0x4(%ebx),%edx
80104da8:	39 d0                	cmp    %edx,%eax
80104daa:	72 14                	jb     80104dc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104dac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104daf:	8b 13                	mov    (%ebx),%edx
80104db1:	89 10                	mov    %edx,(%eax)
  return 0;
80104db3:	31 c0                	xor    %eax,%eax
}
80104db5:	83 c4 04             	add    $0x4,%esp
80104db8:	5b                   	pop    %ebx
80104db9:	5d                   	pop    %ebp
80104dba:	c3                   	ret    
80104dbb:	90                   	nop
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb ee                	jmp    80104db5 <fetchint+0x25>
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	53                   	push   %ebx
80104dd4:	83 ec 04             	sub    $0x4,%esp
80104dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dda:	e8 81 ee ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz)
80104ddf:	39 18                	cmp    %ebx,(%eax)
80104de1:	76 29                	jbe    80104e0c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104de6:	89 da                	mov    %ebx,%edx
80104de8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104dea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104dec:	39 c3                	cmp    %eax,%ebx
80104dee:	73 1c                	jae    80104e0c <fetchstr+0x3c>
    if(*s == 0)
80104df0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104df3:	75 10                	jne    80104e05 <fetchstr+0x35>
80104df5:	eb 39                	jmp    80104e30 <fetchstr+0x60>
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e00:	80 3a 00             	cmpb   $0x0,(%edx)
80104e03:	74 1b                	je     80104e20 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104e05:	83 c2 01             	add    $0x1,%edx
80104e08:	39 d0                	cmp    %edx,%eax
80104e0a:	77 f4                	ja     80104e00 <fetchstr+0x30>
    return -1;
80104e0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104e11:	83 c4 04             	add    $0x4,%esp
80104e14:	5b                   	pop    %ebx
80104e15:	5d                   	pop    %ebp
80104e16:	c3                   	ret    
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e20:	83 c4 04             	add    $0x4,%esp
80104e23:	89 d0                	mov    %edx,%eax
80104e25:	29 d8                	sub    %ebx,%eax
80104e27:	5b                   	pop    %ebx
80104e28:	5d                   	pop    %ebp
80104e29:	c3                   	ret    
80104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104e30:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104e32:	eb dd                	jmp    80104e11 <fetchstr+0x41>
80104e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e45:	e8 16 ee ff ff       	call   80103c60 <myproc>
80104e4a:	8b 40 18             	mov    0x18(%eax),%eax
80104e4d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e50:	8b 40 44             	mov    0x44(%eax),%eax
80104e53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e56:	e8 05 ee ff ff       	call   80103c60 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e5b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e5d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e60:	39 c6                	cmp    %eax,%esi
80104e62:	73 1c                	jae    80104e80 <argint+0x40>
80104e64:	8d 53 08             	lea    0x8(%ebx),%edx
80104e67:	39 d0                	cmp    %edx,%eax
80104e69:	72 15                	jb     80104e80 <argint+0x40>
  *ip = *(int*)(addr);
80104e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e71:	89 10                	mov    %edx,(%eax)
  return 0;
80104e73:	31 c0                	xor    %eax,%eax
}
80104e75:	5b                   	pop    %ebx
80104e76:	5e                   	pop    %esi
80104e77:	5d                   	pop    %ebp
80104e78:	c3                   	ret    
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e85:	eb ee                	jmp    80104e75 <argint+0x35>
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
80104e95:	83 ec 10             	sub    $0x10,%esp
80104e98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104e9b:	e8 c0 ed ff ff       	call   80103c60 <myproc>
80104ea0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ea2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ea5:	83 ec 08             	sub    $0x8,%esp
80104ea8:	50                   	push   %eax
80104ea9:	ff 75 08             	pushl  0x8(%ebp)
80104eac:	e8 8f ff ff ff       	call   80104e40 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104eb1:	83 c4 10             	add    $0x10,%esp
80104eb4:	85 c0                	test   %eax,%eax
80104eb6:	78 28                	js     80104ee0 <argptr+0x50>
80104eb8:	85 db                	test   %ebx,%ebx
80104eba:	78 24                	js     80104ee0 <argptr+0x50>
80104ebc:	8b 16                	mov    (%esi),%edx
80104ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec1:	39 c2                	cmp    %eax,%edx
80104ec3:	76 1b                	jbe    80104ee0 <argptr+0x50>
80104ec5:	01 c3                	add    %eax,%ebx
80104ec7:	39 da                	cmp    %ebx,%edx
80104ec9:	72 15                	jb     80104ee0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ece:	89 02                	mov    %eax,(%edx)
  return 0;
80104ed0:	31 c0                	xor    %eax,%eax
}
80104ed2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed5:	5b                   	pop    %ebx
80104ed6:	5e                   	pop    %esi
80104ed7:	5d                   	pop    %ebp
80104ed8:	c3                   	ret    
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee5:	eb eb                	jmp    80104ed2 <argptr+0x42>
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ef0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ef6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ef9:	50                   	push   %eax
80104efa:	ff 75 08             	pushl  0x8(%ebp)
80104efd:	e8 3e ff ff ff       	call   80104e40 <argint>
80104f02:	83 c4 10             	add    $0x10,%esp
80104f05:	85 c0                	test   %eax,%eax
80104f07:	78 17                	js     80104f20 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f09:	83 ec 08             	sub    $0x8,%esp
80104f0c:	ff 75 0c             	pushl  0xc(%ebp)
80104f0f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f12:	e8 b9 fe ff ff       	call   80104dd0 <fetchstr>
80104f17:	83 c4 10             	add    $0x10,%esp
}
80104f1a:	c9                   	leave  
80104f1b:	c3                   	ret    
80104f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f25:	c9                   	leave  
80104f26:	c3                   	ret    
80104f27:	89 f6                	mov    %esi,%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f30 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	53                   	push   %ebx
80104f34:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f37:	e8 24 ed ff ff       	call   80103c60 <myproc>
80104f3c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f3e:	8b 40 18             	mov    0x18(%eax),%eax
80104f41:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f44:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f47:	83 fa 15             	cmp    $0x15,%edx
80104f4a:	77 1c                	ja     80104f68 <syscall+0x38>
80104f4c:	8b 14 85 00 83 10 80 	mov    -0x7fef7d00(,%eax,4),%edx
80104f53:	85 d2                	test   %edx,%edx
80104f55:	74 11                	je     80104f68 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104f57:	ff d2                	call   *%edx
80104f59:	8b 53 18             	mov    0x18(%ebx),%edx
80104f5c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f62:	c9                   	leave  
80104f63:	c3                   	ret    
80104f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104f68:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f69:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104f6c:	50                   	push   %eax
80104f6d:	ff 73 10             	pushl  0x10(%ebx)
80104f70:	68 d1 82 10 80       	push   $0x801082d1
80104f75:	e8 e6 b6 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104f7a:	8b 43 18             	mov    0x18(%ebx),%eax
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f8a:	c9                   	leave  
80104f8b:	c3                   	ret    
80104f8c:	66 90                	xchg   %ax,%ax
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
80104f95:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104f97:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104f9a:	89 d6                	mov    %edx,%esi
80104f9c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f9f:	50                   	push   %eax
80104fa0:	6a 00                	push   $0x0
80104fa2:	e8 99 fe ff ff       	call   80104e40 <argint>
80104fa7:	83 c4 10             	add    $0x10,%esp
80104faa:	85 c0                	test   %eax,%eax
80104fac:	78 2a                	js     80104fd8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fb2:	77 24                	ja     80104fd8 <argfd.constprop.0+0x48>
80104fb4:	e8 a7 ec ff ff       	call   80103c60 <myproc>
80104fb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fbc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	74 14                	je     80104fd8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80104fc4:	85 db                	test   %ebx,%ebx
80104fc6:	74 02                	je     80104fca <argfd.constprop.0+0x3a>
    *pfd = fd;
80104fc8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
80104fca:	89 06                	mov    %eax,(%esi)
  return 0;
80104fcc:	31 c0                	xor    %eax,%eax
}
80104fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd1:	5b                   	pop    %ebx
80104fd2:	5e                   	pop    %esi
80104fd3:	5d                   	pop    %ebp
80104fd4:	c3                   	ret    
80104fd5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	eb ef                	jmp    80104fce <argfd.constprop.0+0x3e>
80104fdf:	90                   	nop

80104fe0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104fe0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104fe1:	31 c0                	xor    %eax,%eax
{
80104fe3:	89 e5                	mov    %esp,%ebp
80104fe5:	56                   	push   %esi
80104fe6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104fe7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104fea:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104fed:	e8 9e ff ff ff       	call   80104f90 <argfd.constprop.0>
80104ff2:	85 c0                	test   %eax,%eax
80104ff4:	78 42                	js     80105038 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104ff6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ff9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104ffb:	e8 60 ec ff ff       	call   80103c60 <myproc>
80105000:	eb 0e                	jmp    80105010 <sys_dup+0x30>
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105008:	83 c3 01             	add    $0x1,%ebx
8010500b:	83 fb 10             	cmp    $0x10,%ebx
8010500e:	74 28                	je     80105038 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105010:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105014:	85 d2                	test   %edx,%edx
80105016:	75 f0                	jne    80105008 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105018:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010501c:	83 ec 0c             	sub    $0xc,%esp
8010501f:	ff 75 f4             	pushl  -0xc(%ebp)
80105022:	e8 f9 bd ff ff       	call   80100e20 <filedup>
  return fd;
80105027:	83 c4 10             	add    $0x10,%esp
}
8010502a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010502d:	89 d8                	mov    %ebx,%eax
8010502f:	5b                   	pop    %ebx
80105030:	5e                   	pop    %esi
80105031:	5d                   	pop    %ebp
80105032:	c3                   	ret    
80105033:	90                   	nop
80105034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105038:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010503b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105040:	89 d8                	mov    %ebx,%eax
80105042:	5b                   	pop    %ebx
80105043:	5e                   	pop    %esi
80105044:	5d                   	pop    %ebp
80105045:	c3                   	ret    
80105046:	8d 76 00             	lea    0x0(%esi),%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <sys_read>:

int
sys_read(void)
{
80105050:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105051:	31 c0                	xor    %eax,%eax
{
80105053:	89 e5                	mov    %esp,%ebp
80105055:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105058:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010505b:	e8 30 ff ff ff       	call   80104f90 <argfd.constprop.0>
80105060:	85 c0                	test   %eax,%eax
80105062:	78 4c                	js     801050b0 <sys_read+0x60>
80105064:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105067:	83 ec 08             	sub    $0x8,%esp
8010506a:	50                   	push   %eax
8010506b:	6a 02                	push   $0x2
8010506d:	e8 ce fd ff ff       	call   80104e40 <argint>
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	85 c0                	test   %eax,%eax
80105077:	78 37                	js     801050b0 <sys_read+0x60>
80105079:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010507c:	83 ec 04             	sub    $0x4,%esp
8010507f:	ff 75 f0             	pushl  -0x10(%ebp)
80105082:	50                   	push   %eax
80105083:	6a 01                	push   $0x1
80105085:	e8 06 fe ff ff       	call   80104e90 <argptr>
8010508a:	83 c4 10             	add    $0x10,%esp
8010508d:	85 c0                	test   %eax,%eax
8010508f:	78 1f                	js     801050b0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105091:	83 ec 04             	sub    $0x4,%esp
80105094:	ff 75 f0             	pushl  -0x10(%ebp)
80105097:	ff 75 f4             	pushl  -0xc(%ebp)
8010509a:	ff 75 ec             	pushl  -0x14(%ebp)
8010509d:	e8 ee be ff ff       	call   80100f90 <fileread>
801050a2:	83 c4 10             	add    $0x10,%esp
}
801050a5:	c9                   	leave  
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050b5:	c9                   	leave  
801050b6:	c3                   	ret    
801050b7:	89 f6                	mov    %esi,%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050c0 <sys_write>:

int
sys_write(void)
{
801050c0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050c1:	31 c0                	xor    %eax,%eax
{
801050c3:	89 e5                	mov    %esp,%ebp
801050c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050cb:	e8 c0 fe ff ff       	call   80104f90 <argfd.constprop.0>
801050d0:	85 c0                	test   %eax,%eax
801050d2:	78 4c                	js     80105120 <sys_write+0x60>
801050d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050d7:	83 ec 08             	sub    $0x8,%esp
801050da:	50                   	push   %eax
801050db:	6a 02                	push   $0x2
801050dd:	e8 5e fd ff ff       	call   80104e40 <argint>
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	85 c0                	test   %eax,%eax
801050e7:	78 37                	js     80105120 <sys_write+0x60>
801050e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ec:	83 ec 04             	sub    $0x4,%esp
801050ef:	ff 75 f0             	pushl  -0x10(%ebp)
801050f2:	50                   	push   %eax
801050f3:	6a 01                	push   $0x1
801050f5:	e8 96 fd ff ff       	call   80104e90 <argptr>
801050fa:	83 c4 10             	add    $0x10,%esp
801050fd:	85 c0                	test   %eax,%eax
801050ff:	78 1f                	js     80105120 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105101:	83 ec 04             	sub    $0x4,%esp
80105104:	ff 75 f0             	pushl  -0x10(%ebp)
80105107:	ff 75 f4             	pushl  -0xc(%ebp)
8010510a:	ff 75 ec             	pushl  -0x14(%ebp)
8010510d:	e8 0e bf ff ff       	call   80101020 <filewrite>
80105112:	83 c4 10             	add    $0x10,%esp
}
80105115:	c9                   	leave  
80105116:	c3                   	ret    
80105117:	89 f6                	mov    %esi,%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105125:	c9                   	leave  
80105126:	c3                   	ret    
80105127:	89 f6                	mov    %esi,%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <sys_close>:

int
sys_close(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105136:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105139:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010513c:	e8 4f fe ff ff       	call   80104f90 <argfd.constprop.0>
80105141:	85 c0                	test   %eax,%eax
80105143:	78 2b                	js     80105170 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105145:	e8 16 eb ff ff       	call   80103c60 <myproc>
8010514a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010514d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105150:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105157:	00 
  fileclose(f);
80105158:	ff 75 f4             	pushl  -0xc(%ebp)
8010515b:	e8 10 bd ff ff       	call   80100e70 <fileclose>
  return 0;
80105160:	83 c4 10             	add    $0x10,%esp
80105163:	31 c0                	xor    %eax,%eax
}
80105165:	c9                   	leave  
80105166:	c3                   	ret    
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105175:	c9                   	leave  
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <sys_fstat>:

int
sys_fstat(void)
{
80105180:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105181:	31 c0                	xor    %eax,%eax
{
80105183:	89 e5                	mov    %esp,%ebp
80105185:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105188:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010518b:	e8 00 fe ff ff       	call   80104f90 <argfd.constprop.0>
80105190:	85 c0                	test   %eax,%eax
80105192:	78 2c                	js     801051c0 <sys_fstat+0x40>
80105194:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105197:	83 ec 04             	sub    $0x4,%esp
8010519a:	6a 14                	push   $0x14
8010519c:	50                   	push   %eax
8010519d:	6a 01                	push   $0x1
8010519f:	e8 ec fc ff ff       	call   80104e90 <argptr>
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	85 c0                	test   %eax,%eax
801051a9:	78 15                	js     801051c0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801051ab:	83 ec 08             	sub    $0x8,%esp
801051ae:	ff 75 f4             	pushl  -0xc(%ebp)
801051b1:	ff 75 f0             	pushl  -0x10(%ebp)
801051b4:	e8 87 bd ff ff       	call   80100f40 <filestat>
801051b9:	83 c4 10             	add    $0x10,%esp
}
801051bc:	c9                   	leave  
801051bd:	c3                   	ret    
801051be:	66 90                	xchg   %ax,%ax
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	57                   	push   %edi
801051d4:	56                   	push   %esi
801051d5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051d9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051dc:	50                   	push   %eax
801051dd:	6a 00                	push   $0x0
801051df:	e8 0c fd ff ff       	call   80104ef0 <argstr>
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	85 c0                	test   %eax,%eax
801051e9:	0f 88 fb 00 00 00    	js     801052ea <sys_link+0x11a>
801051ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051f2:	83 ec 08             	sub    $0x8,%esp
801051f5:	50                   	push   %eax
801051f6:	6a 01                	push   $0x1
801051f8:	e8 f3 fc ff ff       	call   80104ef0 <argstr>
801051fd:	83 c4 10             	add    $0x10,%esp
80105200:	85 c0                	test   %eax,%eax
80105202:	0f 88 e2 00 00 00    	js     801052ea <sys_link+0x11a>
    return -1;

  begin_op();
80105208:	e8 63 dd ff ff       	call   80102f70 <begin_op>
  if((ip = namei(old)) == 0){
8010520d:	83 ec 0c             	sub    $0xc,%esp
80105210:	ff 75 d4             	pushl  -0x2c(%ebp)
80105213:	e8 08 cd ff ff       	call   80101f20 <namei>
80105218:	83 c4 10             	add    $0x10,%esp
8010521b:	85 c0                	test   %eax,%eax
8010521d:	89 c3                	mov    %eax,%ebx
8010521f:	0f 84 ea 00 00 00    	je     8010530f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105225:	83 ec 0c             	sub    $0xc,%esp
80105228:	50                   	push   %eax
80105229:	e8 92 c4 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105236:	0f 84 bb 00 00 00    	je     801052f7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010523c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105241:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105244:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105247:	53                   	push   %ebx
80105248:	e8 c3 c3 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
8010524d:	89 1c 24             	mov    %ebx,(%esp)
80105250:	e8 4b c5 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105255:	58                   	pop    %eax
80105256:	5a                   	pop    %edx
80105257:	57                   	push   %edi
80105258:	ff 75 d0             	pushl  -0x30(%ebp)
8010525b:	e8 e0 cc ff ff       	call   80101f40 <nameiparent>
80105260:	83 c4 10             	add    $0x10,%esp
80105263:	85 c0                	test   %eax,%eax
80105265:	89 c6                	mov    %eax,%esi
80105267:	74 5b                	je     801052c4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105269:	83 ec 0c             	sub    $0xc,%esp
8010526c:	50                   	push   %eax
8010526d:	e8 4e c4 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105272:	83 c4 10             	add    $0x10,%esp
80105275:	8b 03                	mov    (%ebx),%eax
80105277:	39 06                	cmp    %eax,(%esi)
80105279:	75 3d                	jne    801052b8 <sys_link+0xe8>
8010527b:	83 ec 04             	sub    $0x4,%esp
8010527e:	ff 73 04             	pushl  0x4(%ebx)
80105281:	57                   	push   %edi
80105282:	56                   	push   %esi
80105283:	e8 d8 cb ff ff       	call   80101e60 <dirlink>
80105288:	83 c4 10             	add    $0x10,%esp
8010528b:	85 c0                	test   %eax,%eax
8010528d:	78 29                	js     801052b8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	56                   	push   %esi
80105293:	e8 b8 c6 ff ff       	call   80101950 <iunlockput>
  iput(ip);
80105298:	89 1c 24             	mov    %ebx,(%esp)
8010529b:	e8 50 c5 ff ff       	call   801017f0 <iput>

  end_op();
801052a0:	e8 3b dd ff ff       	call   80102fe0 <end_op>

  return 0;
801052a5:	83 c4 10             	add    $0x10,%esp
801052a8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801052aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ad:	5b                   	pop    %ebx
801052ae:	5e                   	pop    %esi
801052af:	5f                   	pop    %edi
801052b0:	5d                   	pop    %ebp
801052b1:	c3                   	ret    
801052b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052b8:	83 ec 0c             	sub    $0xc,%esp
801052bb:	56                   	push   %esi
801052bc:	e8 8f c6 ff ff       	call   80101950 <iunlockput>
    goto bad;
801052c1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052c4:	83 ec 0c             	sub    $0xc,%esp
801052c7:	53                   	push   %ebx
801052c8:	e8 f3 c3 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
801052cd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052d2:	89 1c 24             	mov    %ebx,(%esp)
801052d5:	e8 36 c3 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
801052da:	89 1c 24             	mov    %ebx,(%esp)
801052dd:	e8 6e c6 ff ff       	call   80101950 <iunlockput>
  end_op();
801052e2:	e8 f9 dc ff ff       	call   80102fe0 <end_op>
  return -1;
801052e7:	83 c4 10             	add    $0x10,%esp
}
801052ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801052ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f2:	5b                   	pop    %ebx
801052f3:	5e                   	pop    %esi
801052f4:	5f                   	pop    %edi
801052f5:	5d                   	pop    %ebp
801052f6:	c3                   	ret    
    iunlockput(ip);
801052f7:	83 ec 0c             	sub    $0xc,%esp
801052fa:	53                   	push   %ebx
801052fb:	e8 50 c6 ff ff       	call   80101950 <iunlockput>
    end_op();
80105300:	e8 db dc ff ff       	call   80102fe0 <end_op>
    return -1;
80105305:	83 c4 10             	add    $0x10,%esp
80105308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530d:	eb 9b                	jmp    801052aa <sys_link+0xda>
    end_op();
8010530f:	e8 cc dc ff ff       	call   80102fe0 <end_op>
    return -1;
80105314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105319:	eb 8f                	jmp    801052aa <sys_link+0xda>
8010531b:	90                   	nop
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105320 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
80105325:	53                   	push   %ebx
80105326:	83 ec 1c             	sub    $0x1c,%esp
80105329:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010532c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105330:	76 3e                	jbe    80105370 <isdirempty+0x50>
80105332:	bb 20 00 00 00       	mov    $0x20,%ebx
80105337:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010533a:	eb 0c                	jmp    80105348 <isdirempty+0x28>
8010533c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105340:	83 c3 10             	add    $0x10,%ebx
80105343:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105346:	73 28                	jae    80105370 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105348:	6a 10                	push   $0x10
8010534a:	53                   	push   %ebx
8010534b:	57                   	push   %edi
8010534c:	56                   	push   %esi
8010534d:	e8 4e c6 ff ff       	call   801019a0 <readi>
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	83 f8 10             	cmp    $0x10,%eax
80105358:	75 23                	jne    8010537d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010535a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010535f:	74 df                	je     80105340 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105361:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105364:	31 c0                	xor    %eax,%eax
}
80105366:	5b                   	pop    %ebx
80105367:	5e                   	pop    %esi
80105368:	5f                   	pop    %edi
80105369:	5d                   	pop    %ebp
8010536a:	c3                   	ret    
8010536b:	90                   	nop
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105373:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105378:	5b                   	pop    %ebx
80105379:	5e                   	pop    %esi
8010537a:	5f                   	pop    %edi
8010537b:	5d                   	pop    %ebp
8010537c:	c3                   	ret    
      panic("isdirempty: readi");
8010537d:	83 ec 0c             	sub    $0xc,%esp
80105380:	68 5c 83 10 80       	push   $0x8010835c
80105385:	e8 06 b0 ff ff       	call   80100390 <panic>
8010538a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105390 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
80105395:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105396:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105399:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010539c:	50                   	push   %eax
8010539d:	6a 00                	push   $0x0
8010539f:	e8 4c fb ff ff       	call   80104ef0 <argstr>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	0f 88 51 01 00 00    	js     80105500 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801053af:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801053b2:	e8 b9 db ff ff       	call   80102f70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053b7:	83 ec 08             	sub    $0x8,%esp
801053ba:	53                   	push   %ebx
801053bb:	ff 75 c0             	pushl  -0x40(%ebp)
801053be:	e8 7d cb ff ff       	call   80101f40 <nameiparent>
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	85 c0                	test   %eax,%eax
801053c8:	89 c6                	mov    %eax,%esi
801053ca:	0f 84 37 01 00 00    	je     80105507 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	50                   	push   %eax
801053d4:	e8 e7 c2 ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053d9:	58                   	pop    %eax
801053da:	5a                   	pop    %edx
801053db:	68 5d 7d 10 80       	push   $0x80107d5d
801053e0:	53                   	push   %ebx
801053e1:	e8 ea c7 ff ff       	call   80101bd0 <namecmp>
801053e6:	83 c4 10             	add    $0x10,%esp
801053e9:	85 c0                	test   %eax,%eax
801053eb:	0f 84 d7 00 00 00    	je     801054c8 <sys_unlink+0x138>
801053f1:	83 ec 08             	sub    $0x8,%esp
801053f4:	68 5c 7d 10 80       	push   $0x80107d5c
801053f9:	53                   	push   %ebx
801053fa:	e8 d1 c7 ff ff       	call   80101bd0 <namecmp>
801053ff:	83 c4 10             	add    $0x10,%esp
80105402:	85 c0                	test   %eax,%eax
80105404:	0f 84 be 00 00 00    	je     801054c8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010540a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010540d:	83 ec 04             	sub    $0x4,%esp
80105410:	50                   	push   %eax
80105411:	53                   	push   %ebx
80105412:	56                   	push   %esi
80105413:	e8 d8 c7 ff ff       	call   80101bf0 <dirlookup>
80105418:	83 c4 10             	add    $0x10,%esp
8010541b:	85 c0                	test   %eax,%eax
8010541d:	89 c3                	mov    %eax,%ebx
8010541f:	0f 84 a3 00 00 00    	je     801054c8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105425:	83 ec 0c             	sub    $0xc,%esp
80105428:	50                   	push   %eax
80105429:	e8 92 c2 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105436:	0f 8e e4 00 00 00    	jle    80105520 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010543c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105441:	74 65                	je     801054a8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105443:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105446:	83 ec 04             	sub    $0x4,%esp
80105449:	6a 10                	push   $0x10
8010544b:	6a 00                	push   $0x0
8010544d:	57                   	push   %edi
8010544e:	e8 ed f6 ff ff       	call   80104b40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105453:	6a 10                	push   $0x10
80105455:	ff 75 c4             	pushl  -0x3c(%ebp)
80105458:	57                   	push   %edi
80105459:	56                   	push   %esi
8010545a:	e8 41 c6 ff ff       	call   80101aa0 <writei>
8010545f:	83 c4 20             	add    $0x20,%esp
80105462:	83 f8 10             	cmp    $0x10,%eax
80105465:	0f 85 a8 00 00 00    	jne    80105513 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010546b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105470:	74 6e                	je     801054e0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105472:	83 ec 0c             	sub    $0xc,%esp
80105475:	56                   	push   %esi
80105476:	e8 d5 c4 ff ff       	call   80101950 <iunlockput>

  ip->nlink--;
8010547b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105480:	89 1c 24             	mov    %ebx,(%esp)
80105483:	e8 88 c1 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
80105488:	89 1c 24             	mov    %ebx,(%esp)
8010548b:	e8 c0 c4 ff ff       	call   80101950 <iunlockput>

  end_op();
80105490:	e8 4b db ff ff       	call   80102fe0 <end_op>

  return 0;
80105495:	83 c4 10             	add    $0x10,%esp
80105498:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010549a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010549d:	5b                   	pop    %ebx
8010549e:	5e                   	pop    %esi
8010549f:	5f                   	pop    %edi
801054a0:	5d                   	pop    %ebp
801054a1:	c3                   	ret    
801054a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	53                   	push   %ebx
801054ac:	e8 6f fe ff ff       	call   80105320 <isdirempty>
801054b1:	83 c4 10             	add    $0x10,%esp
801054b4:	85 c0                	test   %eax,%eax
801054b6:	75 8b                	jne    80105443 <sys_unlink+0xb3>
    iunlockput(ip);
801054b8:	83 ec 0c             	sub    $0xc,%esp
801054bb:	53                   	push   %ebx
801054bc:	e8 8f c4 ff ff       	call   80101950 <iunlockput>
    goto bad;
801054c1:	83 c4 10             	add    $0x10,%esp
801054c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801054c8:	83 ec 0c             	sub    $0xc,%esp
801054cb:	56                   	push   %esi
801054cc:	e8 7f c4 ff ff       	call   80101950 <iunlockput>
  end_op();
801054d1:	e8 0a db ff ff       	call   80102fe0 <end_op>
  return -1;
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054de:	eb ba                	jmp    8010549a <sys_unlink+0x10a>
    dp->nlink--;
801054e0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801054e5:	83 ec 0c             	sub    $0xc,%esp
801054e8:	56                   	push   %esi
801054e9:	e8 22 c1 ff ff       	call   80101610 <iupdate>
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	e9 7c ff ff ff       	jmp    80105472 <sys_unlink+0xe2>
801054f6:	8d 76 00             	lea    0x0(%esi),%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105505:	eb 93                	jmp    8010549a <sys_unlink+0x10a>
    end_op();
80105507:	e8 d4 da ff ff       	call   80102fe0 <end_op>
    return -1;
8010550c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105511:	eb 87                	jmp    8010549a <sys_unlink+0x10a>
    panic("unlink: writei");
80105513:	83 ec 0c             	sub    $0xc,%esp
80105516:	68 71 7d 10 80       	push   $0x80107d71
8010551b:	e8 70 ae ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	68 5f 7d 10 80       	push   $0x80107d5f
80105528:	e8 63 ae ff ff       	call   80100390 <panic>
8010552d:	8d 76 00             	lea    0x0(%esi),%esi

80105530 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
80105535:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105536:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105539:	83 ec 44             	sub    $0x44,%esp
8010553c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010553f:	8b 55 10             	mov    0x10(%ebp),%edx
80105542:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105545:	56                   	push   %esi
80105546:	ff 75 08             	pushl  0x8(%ebp)
{
80105549:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010554c:	89 55 c0             	mov    %edx,-0x40(%ebp)
8010554f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105552:	e8 e9 c9 ff ff       	call   80101f40 <nameiparent>
80105557:	83 c4 10             	add    $0x10,%esp
8010555a:	85 c0                	test   %eax,%eax
8010555c:	0f 84 4e 01 00 00    	je     801056b0 <create+0x180>
    return 0;
  ilock(dp);
80105562:	83 ec 0c             	sub    $0xc,%esp
80105565:	89 c3                	mov    %eax,%ebx
80105567:	50                   	push   %eax
80105568:	e8 53 c1 ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010556d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105570:	83 c4 0c             	add    $0xc,%esp
80105573:	50                   	push   %eax
80105574:	56                   	push   %esi
80105575:	53                   	push   %ebx
80105576:	e8 75 c6 ff ff       	call   80101bf0 <dirlookup>
8010557b:	83 c4 10             	add    $0x10,%esp
8010557e:	85 c0                	test   %eax,%eax
80105580:	89 c7                	mov    %eax,%edi
80105582:	74 3c                	je     801055c0 <create+0x90>
    iunlockput(dp);
80105584:	83 ec 0c             	sub    $0xc,%esp
80105587:	53                   	push   %ebx
80105588:	e8 c3 c3 ff ff       	call   80101950 <iunlockput>
    ilock(ip);
8010558d:	89 3c 24             	mov    %edi,(%esp)
80105590:	e8 2b c1 ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105595:	83 c4 10             	add    $0x10,%esp
80105598:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010559d:	0f 85 9d 00 00 00    	jne    80105640 <create+0x110>
801055a3:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801055a8:	0f 85 92 00 00 00    	jne    80105640 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801055ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055b1:	89 f8                	mov    %edi,%eax
801055b3:	5b                   	pop    %ebx
801055b4:	5e                   	pop    %esi
801055b5:	5f                   	pop    %edi
801055b6:	5d                   	pop    %ebp
801055b7:	c3                   	ret    
801055b8:	90                   	nop
801055b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801055c0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801055c4:	83 ec 08             	sub    $0x8,%esp
801055c7:	50                   	push   %eax
801055c8:	ff 33                	pushl  (%ebx)
801055ca:	e8 81 bf ff ff       	call   80101550 <ialloc>
801055cf:	83 c4 10             	add    $0x10,%esp
801055d2:	85 c0                	test   %eax,%eax
801055d4:	89 c7                	mov    %eax,%edi
801055d6:	0f 84 e8 00 00 00    	je     801056c4 <create+0x194>
  ilock(ip);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	50                   	push   %eax
801055e0:	e8 db c0 ff ff       	call   801016c0 <ilock>
  ip->major = major;
801055e5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801055e9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801055ed:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801055f1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801055f5:	b8 01 00 00 00       	mov    $0x1,%eax
801055fa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801055fe:	89 3c 24             	mov    %edi,(%esp)
80105601:	e8 0a c0 ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010560e:	74 50                	je     80105660 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105610:	83 ec 04             	sub    $0x4,%esp
80105613:	ff 77 04             	pushl  0x4(%edi)
80105616:	56                   	push   %esi
80105617:	53                   	push   %ebx
80105618:	e8 43 c8 ff ff       	call   80101e60 <dirlink>
8010561d:	83 c4 10             	add    $0x10,%esp
80105620:	85 c0                	test   %eax,%eax
80105622:	0f 88 8f 00 00 00    	js     801056b7 <create+0x187>
  iunlockput(dp);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	53                   	push   %ebx
8010562c:	e8 1f c3 ff ff       	call   80101950 <iunlockput>
  return ip;
80105631:	83 c4 10             	add    $0x10,%esp
}
80105634:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105637:	89 f8                	mov    %edi,%eax
80105639:	5b                   	pop    %ebx
8010563a:	5e                   	pop    %esi
8010563b:	5f                   	pop    %edi
8010563c:	5d                   	pop    %ebp
8010563d:	c3                   	ret    
8010563e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	57                   	push   %edi
    return 0;
80105644:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105646:	e8 05 c3 ff ff       	call   80101950 <iunlockput>
    return 0;
8010564b:	83 c4 10             	add    $0x10,%esp
}
8010564e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105651:	89 f8                	mov    %edi,%eax
80105653:	5b                   	pop    %ebx
80105654:	5e                   	pop    %esi
80105655:	5f                   	pop    %edi
80105656:	5d                   	pop    %ebp
80105657:	c3                   	ret    
80105658:	90                   	nop
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105660:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105665:	83 ec 0c             	sub    $0xc,%esp
80105668:	53                   	push   %ebx
80105669:	e8 a2 bf ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010566e:	83 c4 0c             	add    $0xc,%esp
80105671:	ff 77 04             	pushl  0x4(%edi)
80105674:	68 5d 7d 10 80       	push   $0x80107d5d
80105679:	57                   	push   %edi
8010567a:	e8 e1 c7 ff ff       	call   80101e60 <dirlink>
8010567f:	83 c4 10             	add    $0x10,%esp
80105682:	85 c0                	test   %eax,%eax
80105684:	78 1c                	js     801056a2 <create+0x172>
80105686:	83 ec 04             	sub    $0x4,%esp
80105689:	ff 73 04             	pushl  0x4(%ebx)
8010568c:	68 5c 7d 10 80       	push   $0x80107d5c
80105691:	57                   	push   %edi
80105692:	e8 c9 c7 ff ff       	call   80101e60 <dirlink>
80105697:	83 c4 10             	add    $0x10,%esp
8010569a:	85 c0                	test   %eax,%eax
8010569c:	0f 89 6e ff ff ff    	jns    80105610 <create+0xe0>
      panic("create dots");
801056a2:	83 ec 0c             	sub    $0xc,%esp
801056a5:	68 7d 83 10 80       	push   $0x8010837d
801056aa:	e8 e1 ac ff ff       	call   80100390 <panic>
801056af:	90                   	nop
    return 0;
801056b0:	31 ff                	xor    %edi,%edi
801056b2:	e9 f7 fe ff ff       	jmp    801055ae <create+0x7e>
    panic("create: dirlink");
801056b7:	83 ec 0c             	sub    $0xc,%esp
801056ba:	68 89 83 10 80       	push   $0x80108389
801056bf:	e8 cc ac ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801056c4:	83 ec 0c             	sub    $0xc,%esp
801056c7:	68 6e 83 10 80       	push   $0x8010836e
801056cc:	e8 bf ac ff ff       	call   80100390 <panic>
801056d1:	eb 0d                	jmp    801056e0 <sys_open>
801056d3:	90                   	nop
801056d4:	90                   	nop
801056d5:	90                   	nop
801056d6:	90                   	nop
801056d7:	90                   	nop
801056d8:	90                   	nop
801056d9:	90                   	nop
801056da:	90                   	nop
801056db:	90                   	nop
801056dc:	90                   	nop
801056dd:	90                   	nop
801056de:	90                   	nop
801056df:	90                   	nop

801056e0 <sys_open>:

int
sys_open(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
801056e5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801056e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056ec:	50                   	push   %eax
801056ed:	6a 00                	push   $0x0
801056ef:	e8 fc f7 ff ff       	call   80104ef0 <argstr>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	85 c0                	test   %eax,%eax
801056f9:	0f 88 1d 01 00 00    	js     8010581c <sys_open+0x13c>
801056ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105702:	83 ec 08             	sub    $0x8,%esp
80105705:	50                   	push   %eax
80105706:	6a 01                	push   $0x1
80105708:	e8 33 f7 ff ff       	call   80104e40 <argint>
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	85 c0                	test   %eax,%eax
80105712:	0f 88 04 01 00 00    	js     8010581c <sys_open+0x13c>
    return -1;

  begin_op();
80105718:	e8 53 d8 ff ff       	call   80102f70 <begin_op>

  if(omode & O_CREATE){
8010571d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105721:	0f 85 a9 00 00 00    	jne    801057d0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105727:	83 ec 0c             	sub    $0xc,%esp
8010572a:	ff 75 e0             	pushl  -0x20(%ebp)
8010572d:	e8 ee c7 ff ff       	call   80101f20 <namei>
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	85 c0                	test   %eax,%eax
80105737:	89 c6                	mov    %eax,%esi
80105739:	0f 84 ac 00 00 00    	je     801057eb <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010573f:	83 ec 0c             	sub    $0xc,%esp
80105742:	50                   	push   %eax
80105743:	e8 78 bf ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105750:	0f 84 aa 00 00 00    	je     80105800 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105756:	e8 55 b6 ff ff       	call   80100db0 <filealloc>
8010575b:	85 c0                	test   %eax,%eax
8010575d:	89 c7                	mov    %eax,%edi
8010575f:	0f 84 a6 00 00 00    	je     8010580b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105765:	e8 f6 e4 ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010576a:	31 db                	xor    %ebx,%ebx
8010576c:	eb 0e                	jmp    8010577c <sys_open+0x9c>
8010576e:	66 90                	xchg   %ax,%ax
80105770:	83 c3 01             	add    $0x1,%ebx
80105773:	83 fb 10             	cmp    $0x10,%ebx
80105776:	0f 84 ac 00 00 00    	je     80105828 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010577c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105780:	85 d2                	test   %edx,%edx
80105782:	75 ec                	jne    80105770 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105784:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105787:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010578b:	56                   	push   %esi
8010578c:	e8 0f c0 ff ff       	call   801017a0 <iunlock>
  end_op();
80105791:	e8 4a d8 ff ff       	call   80102fe0 <end_op>

  f->type = FD_INODE;
80105796:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010579c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010579f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801057a2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801057a5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801057ac:	89 d0                	mov    %edx,%eax
801057ae:	f7 d0                	not    %eax
801057b0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057b3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801057b6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057b9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801057bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c0:	89 d8                	mov    %ebx,%eax
801057c2:	5b                   	pop    %ebx
801057c3:	5e                   	pop    %esi
801057c4:	5f                   	pop    %edi
801057c5:	5d                   	pop    %ebp
801057c6:	c3                   	ret    
801057c7:	89 f6                	mov    %esi,%esi
801057c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801057d0:	6a 00                	push   $0x0
801057d2:	6a 00                	push   $0x0
801057d4:	6a 02                	push   $0x2
801057d6:	ff 75 e0             	pushl  -0x20(%ebp)
801057d9:	e8 52 fd ff ff       	call   80105530 <create>
    if(ip == 0){
801057de:	83 c4 10             	add    $0x10,%esp
801057e1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801057e3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801057e5:	0f 85 6b ff ff ff    	jne    80105756 <sys_open+0x76>
      end_op();
801057eb:	e8 f0 d7 ff ff       	call   80102fe0 <end_op>
      return -1;
801057f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057f5:	eb c6                	jmp    801057bd <sys_open+0xdd>
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105800:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105803:	85 c9                	test   %ecx,%ecx
80105805:	0f 84 4b ff ff ff    	je     80105756 <sys_open+0x76>
    iunlockput(ip);
8010580b:	83 ec 0c             	sub    $0xc,%esp
8010580e:	56                   	push   %esi
8010580f:	e8 3c c1 ff ff       	call   80101950 <iunlockput>
    end_op();
80105814:	e8 c7 d7 ff ff       	call   80102fe0 <end_op>
    return -1;
80105819:	83 c4 10             	add    $0x10,%esp
8010581c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105821:	eb 9a                	jmp    801057bd <sys_open+0xdd>
80105823:	90                   	nop
80105824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	57                   	push   %edi
8010582c:	e8 3f b6 ff ff       	call   80100e70 <fileclose>
80105831:	83 c4 10             	add    $0x10,%esp
80105834:	eb d5                	jmp    8010580b <sys_open+0x12b>
80105836:	8d 76 00             	lea    0x0(%esi),%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <sys_mkdir>:

int
sys_mkdir(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105846:	e8 25 d7 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010584b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010584e:	83 ec 08             	sub    $0x8,%esp
80105851:	50                   	push   %eax
80105852:	6a 00                	push   $0x0
80105854:	e8 97 f6 ff ff       	call   80104ef0 <argstr>
80105859:	83 c4 10             	add    $0x10,%esp
8010585c:	85 c0                	test   %eax,%eax
8010585e:	78 30                	js     80105890 <sys_mkdir+0x50>
80105860:	6a 00                	push   $0x0
80105862:	6a 00                	push   $0x0
80105864:	6a 01                	push   $0x1
80105866:	ff 75 f4             	pushl  -0xc(%ebp)
80105869:	e8 c2 fc ff ff       	call   80105530 <create>
8010586e:	83 c4 10             	add    $0x10,%esp
80105871:	85 c0                	test   %eax,%eax
80105873:	74 1b                	je     80105890 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105875:	83 ec 0c             	sub    $0xc,%esp
80105878:	50                   	push   %eax
80105879:	e8 d2 c0 ff ff       	call   80101950 <iunlockput>
  end_op();
8010587e:	e8 5d d7 ff ff       	call   80102fe0 <end_op>
  return 0;
80105883:	83 c4 10             	add    $0x10,%esp
80105886:	31 c0                	xor    %eax,%eax
}
80105888:	c9                   	leave  
80105889:	c3                   	ret    
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105890:	e8 4b d7 ff ff       	call   80102fe0 <end_op>
    return -1;
80105895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010589a:	c9                   	leave  
8010589b:	c3                   	ret    
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_mknod>:

int
sys_mknod(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801058a6:	e8 c5 d6 ff ff       	call   80102f70 <begin_op>
  if((argstr(0, &path)) < 0 ||
801058ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058ae:	83 ec 08             	sub    $0x8,%esp
801058b1:	50                   	push   %eax
801058b2:	6a 00                	push   $0x0
801058b4:	e8 37 f6 ff ff       	call   80104ef0 <argstr>
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	85 c0                	test   %eax,%eax
801058be:	78 60                	js     80105920 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801058c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058c3:	83 ec 08             	sub    $0x8,%esp
801058c6:	50                   	push   %eax
801058c7:	6a 01                	push   $0x1
801058c9:	e8 72 f5 ff ff       	call   80104e40 <argint>
  if((argstr(0, &path)) < 0 ||
801058ce:	83 c4 10             	add    $0x10,%esp
801058d1:	85 c0                	test   %eax,%eax
801058d3:	78 4b                	js     80105920 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801058d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d8:	83 ec 08             	sub    $0x8,%esp
801058db:	50                   	push   %eax
801058dc:	6a 02                	push   $0x2
801058de:	e8 5d f5 ff ff       	call   80104e40 <argint>
     argint(1, &major) < 0 ||
801058e3:	83 c4 10             	add    $0x10,%esp
801058e6:	85 c0                	test   %eax,%eax
801058e8:	78 36                	js     80105920 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801058ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801058ee:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
801058ef:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
801058f3:	50                   	push   %eax
801058f4:	6a 03                	push   $0x3
801058f6:	ff 75 ec             	pushl  -0x14(%ebp)
801058f9:	e8 32 fc ff ff       	call   80105530 <create>
801058fe:	83 c4 10             	add    $0x10,%esp
80105901:	85 c0                	test   %eax,%eax
80105903:	74 1b                	je     80105920 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105905:	83 ec 0c             	sub    $0xc,%esp
80105908:	50                   	push   %eax
80105909:	e8 42 c0 ff ff       	call   80101950 <iunlockput>
  end_op();
8010590e:	e8 cd d6 ff ff       	call   80102fe0 <end_op>
  return 0;
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	31 c0                	xor    %eax,%eax
}
80105918:	c9                   	leave  
80105919:	c3                   	ret    
8010591a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105920:	e8 bb d6 ff ff       	call   80102fe0 <end_op>
    return -1;
80105925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010592a:	c9                   	leave  
8010592b:	c3                   	ret    
8010592c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_chdir>:

int
sys_chdir(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	56                   	push   %esi
80105934:	53                   	push   %ebx
80105935:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105938:	e8 23 e3 ff ff       	call   80103c60 <myproc>
8010593d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010593f:	e8 2c d6 ff ff       	call   80102f70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105944:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105947:	83 ec 08             	sub    $0x8,%esp
8010594a:	50                   	push   %eax
8010594b:	6a 00                	push   $0x0
8010594d:	e8 9e f5 ff ff       	call   80104ef0 <argstr>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 77                	js     801059d0 <sys_chdir+0xa0>
80105959:	83 ec 0c             	sub    $0xc,%esp
8010595c:	ff 75 f4             	pushl  -0xc(%ebp)
8010595f:	e8 bc c5 ff ff       	call   80101f20 <namei>
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	85 c0                	test   %eax,%eax
80105969:	89 c3                	mov    %eax,%ebx
8010596b:	74 63                	je     801059d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010596d:	83 ec 0c             	sub    $0xc,%esp
80105970:	50                   	push   %eax
80105971:	e8 4a bd ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010597e:	75 30                	jne    801059b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105980:	83 ec 0c             	sub    $0xc,%esp
80105983:	53                   	push   %ebx
80105984:	e8 17 be ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105989:	58                   	pop    %eax
8010598a:	ff 76 68             	pushl  0x68(%esi)
8010598d:	e8 5e be ff ff       	call   801017f0 <iput>
  end_op();
80105992:	e8 49 d6 ff ff       	call   80102fe0 <end_op>
  curproc->cwd = ip;
80105997:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010599a:	83 c4 10             	add    $0x10,%esp
8010599d:	31 c0                	xor    %eax,%eax
}
8010599f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059a2:	5b                   	pop    %ebx
801059a3:	5e                   	pop    %esi
801059a4:	5d                   	pop    %ebp
801059a5:	c3                   	ret    
801059a6:	8d 76 00             	lea    0x0(%esi),%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	53                   	push   %ebx
801059b4:	e8 97 bf ff ff       	call   80101950 <iunlockput>
    end_op();
801059b9:	e8 22 d6 ff ff       	call   80102fe0 <end_op>
    return -1;
801059be:	83 c4 10             	add    $0x10,%esp
801059c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c6:	eb d7                	jmp    8010599f <sys_chdir+0x6f>
801059c8:	90                   	nop
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801059d0:	e8 0b d6 ff ff       	call   80102fe0 <end_op>
    return -1;
801059d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059da:	eb c3                	jmp    8010599f <sys_chdir+0x6f>
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_exec>:

int
sys_exec(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	56                   	push   %esi
801059e5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059e6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801059ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059f2:	50                   	push   %eax
801059f3:	6a 00                	push   $0x0
801059f5:	e8 f6 f4 ff ff       	call   80104ef0 <argstr>
801059fa:	83 c4 10             	add    $0x10,%esp
801059fd:	85 c0                	test   %eax,%eax
801059ff:	0f 88 87 00 00 00    	js     80105a8c <sys_exec+0xac>
80105a05:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a0b:	83 ec 08             	sub    $0x8,%esp
80105a0e:	50                   	push   %eax
80105a0f:	6a 01                	push   $0x1
80105a11:	e8 2a f4 ff ff       	call   80104e40 <argint>
80105a16:	83 c4 10             	add    $0x10,%esp
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	78 6f                	js     80105a8c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a1d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a23:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105a26:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a28:	68 80 00 00 00       	push   $0x80
80105a2d:	6a 00                	push   $0x0
80105a2f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a35:	50                   	push   %eax
80105a36:	e8 05 f1 ff ff       	call   80104b40 <memset>
80105a3b:	83 c4 10             	add    $0x10,%esp
80105a3e:	eb 2c                	jmp    80105a6c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105a40:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a46:	85 c0                	test   %eax,%eax
80105a48:	74 56                	je     80105aa0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a4a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105a50:	83 ec 08             	sub    $0x8,%esp
80105a53:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105a56:	52                   	push   %edx
80105a57:	50                   	push   %eax
80105a58:	e8 73 f3 ff ff       	call   80104dd0 <fetchstr>
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	85 c0                	test   %eax,%eax
80105a62:	78 28                	js     80105a8c <sys_exec+0xac>
  for(i=0;; i++){
80105a64:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a67:	83 fb 20             	cmp    $0x20,%ebx
80105a6a:	74 20                	je     80105a8c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a6c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a72:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105a79:	83 ec 08             	sub    $0x8,%esp
80105a7c:	57                   	push   %edi
80105a7d:	01 f0                	add    %esi,%eax
80105a7f:	50                   	push   %eax
80105a80:	e8 0b f3 ff ff       	call   80104d90 <fetchint>
80105a85:	83 c4 10             	add    $0x10,%esp
80105a88:	85 c0                	test   %eax,%eax
80105a8a:	79 b4                	jns    80105a40 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a94:	5b                   	pop    %ebx
80105a95:	5e                   	pop    %esi
80105a96:	5f                   	pop    %edi
80105a97:	5d                   	pop    %ebp
80105a98:	c3                   	ret    
80105a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105aa0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105aa6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105aa9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ab0:	00 00 00 00 
  return exec(path, argv);
80105ab4:	50                   	push   %eax
80105ab5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105abb:	e8 50 af ff ff       	call   80100a10 <exec>
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
{
80105ad9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105adc:	6a 08                	push   $0x8
80105ade:	50                   	push   %eax
80105adf:	6a 00                	push   $0x0
80105ae1:	e8 aa f3 ff ff       	call   80104e90 <argptr>
80105ae6:	83 c4 10             	add    $0x10,%esp
80105ae9:	85 c0                	test   %eax,%eax
80105aeb:	0f 88 ae 00 00 00    	js     80105b9f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105af1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105af4:	83 ec 08             	sub    $0x8,%esp
80105af7:	50                   	push   %eax
80105af8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105afb:	50                   	push   %eax
80105afc:	e8 0f db ff ff       	call   80103610 <pipealloc>
80105b01:	83 c4 10             	add    $0x10,%esp
80105b04:	85 c0                	test   %eax,%eax
80105b06:	0f 88 93 00 00 00    	js     80105b9f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b0c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b0f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b11:	e8 4a e1 ff ff       	call   80103c60 <myproc>
80105b16:	eb 10                	jmp    80105b28 <sys_pipe+0x58>
80105b18:	90                   	nop
80105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b20:	83 c3 01             	add    $0x1,%ebx
80105b23:	83 fb 10             	cmp    $0x10,%ebx
80105b26:	74 60                	je     80105b88 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105b28:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b2c:	85 f6                	test   %esi,%esi
80105b2e:	75 f0                	jne    80105b20 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105b30:	8d 73 08             	lea    0x8(%ebx),%esi
80105b33:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b3a:	e8 21 e1 ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b3f:	31 d2                	xor    %edx,%edx
80105b41:	eb 0d                	jmp    80105b50 <sys_pipe+0x80>
80105b43:	90                   	nop
80105b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b48:	83 c2 01             	add    $0x1,%edx
80105b4b:	83 fa 10             	cmp    $0x10,%edx
80105b4e:	74 28                	je     80105b78 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105b50:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b54:	85 c9                	test   %ecx,%ecx
80105b56:	75 f0                	jne    80105b48 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105b58:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105b5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b5f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b64:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b67:	31 c0                	xor    %eax,%eax
}
80105b69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b6c:	5b                   	pop    %ebx
80105b6d:	5e                   	pop    %esi
80105b6e:	5f                   	pop    %edi
80105b6f:	5d                   	pop    %ebp
80105b70:	c3                   	ret    
80105b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105b78:	e8 e3 e0 ff ff       	call   80103c60 <myproc>
80105b7d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b84:	00 
80105b85:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105b88:	83 ec 0c             	sub    $0xc,%esp
80105b8b:	ff 75 e0             	pushl  -0x20(%ebp)
80105b8e:	e8 dd b2 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105b93:	58                   	pop    %eax
80105b94:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b97:	e8 d4 b2 ff ff       	call   80100e70 <fileclose>
    return -1;
80105b9c:	83 c4 10             	add    $0x10,%esp
80105b9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ba4:	eb c3                	jmp    80105b69 <sys_pipe+0x99>
80105ba6:	66 90                	xchg   %ax,%ax
80105ba8:	66 90                	xchg   %ax,%ax
80105baa:	66 90                	xchg   %ax,%ax
80105bac:	66 90                	xchg   %ax,%ax
80105bae:	66 90                	xchg   %ax,%ax

80105bb0 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105bb6:	e8 a5 e7 ff ff       	call   80104360 <yield>
  return 0;
}
80105bbb:	31 c0                	xor    %eax,%eax
80105bbd:	c9                   	leave  
80105bbe:	c3                   	ret    
80105bbf:	90                   	nop

80105bc0 <sys_fork>:

int
sys_fork(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105bc3:	5d                   	pop    %ebp
  return fork();
80105bc4:	e9 47 e2 ff ff       	jmp    80103e10 <fork>
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_exit>:

int
sys_exit(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105bd6:	e8 35 e6 ff ff       	call   80104210 <exit>
  return 0;  // not reached
}
80105bdb:	31 c0                	xor    %eax,%eax
80105bdd:	c9                   	leave  
80105bde:	c3                   	ret    
80105bdf:	90                   	nop

80105be0 <sys_wait>:

int
sys_wait(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105be3:	5d                   	pop    %ebp
  return wait();
80105be4:	e9 87 e8 ff ff       	jmp    80104470 <wait>
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_kill>:

int
sys_kill(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bf9:	50                   	push   %eax
80105bfa:	6a 00                	push   $0x0
80105bfc:	e8 3f f2 ff ff       	call   80104e40 <argint>
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	85 c0                	test   %eax,%eax
80105c06:	78 18                	js     80105c20 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c08:	83 ec 0c             	sub    $0xc,%esp
80105c0b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c0e:	e8 5d ea ff ff       	call   80104670 <kill>
80105c13:	83 c4 10             	add    $0x10,%esp
}
80105c16:	c9                   	leave  
80105c17:	c3                   	ret    
80105c18:	90                   	nop
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    
80105c27:	89 f6                	mov    %esi,%esi
80105c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c30 <sys_getpid>:

int
sys_getpid(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c36:	e8 25 e0 ff ff       	call   80103c60 <myproc>
80105c3b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c3e:	c9                   	leave  
80105c3f:	c3                   	ret    

80105c40 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c4a:	50                   	push   %eax
80105c4b:	6a 00                	push   $0x0
80105c4d:	e8 ee f1 ff ff       	call   80104e40 <argint>
80105c52:	83 c4 10             	add    $0x10,%esp
80105c55:	85 c0                	test   %eax,%eax
80105c57:	78 27                	js     80105c80 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c59:	e8 02 e0 ff ff       	call   80103c60 <myproc>
  if(growproc(n) < 0)
80105c5e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c61:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c63:	ff 75 f4             	pushl  -0xc(%ebp)
80105c66:	e8 15 e1 ff ff       	call   80103d80 <growproc>
80105c6b:	83 c4 10             	add    $0x10,%esp
80105c6e:	85 c0                	test   %eax,%eax
80105c70:	78 0e                	js     80105c80 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c72:	89 d8                	mov    %ebx,%eax
80105c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c77:	c9                   	leave  
80105c78:	c3                   	ret    
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c80:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c85:	eb eb                	jmp    80105c72 <sys_sbrk+0x32>
80105c87:	89 f6                	mov    %esi,%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c90 <sys_sleep>:

int
sys_sleep(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c9a:	50                   	push   %eax
80105c9b:	6a 00                	push   $0x0
80105c9d:	e8 9e f1 ff ff       	call   80104e40 <argint>
80105ca2:	83 c4 10             	add    $0x10,%esp
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	0f 88 8a 00 00 00    	js     80105d37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105cad:	83 ec 0c             	sub    $0xc,%esp
80105cb0:	68 80 53 12 80       	push   $0x80125380
80105cb5:	e8 06 ed ff ff       	call   801049c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cbd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105cc0:	8b 1d c0 5b 12 80    	mov    0x80125bc0,%ebx
  while(ticks - ticks0 < n){
80105cc6:	85 d2                	test   %edx,%edx
80105cc8:	75 27                	jne    80105cf1 <sys_sleep+0x61>
80105cca:	eb 54                	jmp    80105d20 <sys_sleep+0x90>
80105ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105cd0:	83 ec 08             	sub    $0x8,%esp
80105cd3:	68 80 53 12 80       	push   $0x80125380
80105cd8:	68 c0 5b 12 80       	push   $0x80125bc0
80105cdd:	e8 ce e6 ff ff       	call   801043b0 <sleep>
  while(ticks - ticks0 < n){
80105ce2:	a1 c0 5b 12 80       	mov    0x80125bc0,%eax
80105ce7:	83 c4 10             	add    $0x10,%esp
80105cea:	29 d8                	sub    %ebx,%eax
80105cec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105cef:	73 2f                	jae    80105d20 <sys_sleep+0x90>
    if(myproc()->killed){
80105cf1:	e8 6a df ff ff       	call   80103c60 <myproc>
80105cf6:	8b 40 24             	mov    0x24(%eax),%eax
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	74 d3                	je     80105cd0 <sys_sleep+0x40>
      release(&tickslock);
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	68 80 53 12 80       	push   $0x80125380
80105d05:	e8 d6 ed ff ff       	call   80104ae0 <release>
      return -1;
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105d20:	83 ec 0c             	sub    $0xc,%esp
80105d23:	68 80 53 12 80       	push   $0x80125380
80105d28:	e8 b3 ed ff ff       	call   80104ae0 <release>
  return 0;
80105d2d:	83 c4 10             	add    $0x10,%esp
80105d30:	31 c0                	xor    %eax,%eax
}
80105d32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d35:	c9                   	leave  
80105d36:	c3                   	ret    
    return -1;
80105d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3c:	eb f4                	jmp    80105d32 <sys_sleep+0xa2>
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	53                   	push   %ebx
80105d44:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d47:	68 80 53 12 80       	push   $0x80125380
80105d4c:	e8 6f ec ff ff       	call   801049c0 <acquire>
  xticks = ticks;
80105d51:	8b 1d c0 5b 12 80    	mov    0x80125bc0,%ebx
  release(&tickslock);
80105d57:	c7 04 24 80 53 12 80 	movl   $0x80125380,(%esp)
80105d5e:	e8 7d ed ff ff       	call   80104ae0 <release>
  return xticks;
}
80105d63:	89 d8                	mov    %ebx,%eax
80105d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d68:	c9                   	leave  
80105d69:	c3                   	ret    

80105d6a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d6a:	1e                   	push   %ds
  pushl %es
80105d6b:	06                   	push   %es
  pushl %fs
80105d6c:	0f a0                	push   %fs
  pushl %gs
80105d6e:	0f a8                	push   %gs
  pushal
80105d70:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d71:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d75:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d77:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d79:	54                   	push   %esp
  call trap
80105d7a:	e8 c1 00 00 00       	call   80105e40 <trap>
  addl $4, %esp
80105d7f:	83 c4 04             	add    $0x4,%esp

80105d82 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d82:	61                   	popa   
  popl %gs
80105d83:	0f a9                	pop    %gs
  popl %fs
80105d85:	0f a1                	pop    %fs
  popl %es
80105d87:	07                   	pop    %es
  popl %ds
80105d88:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d89:	83 c4 08             	add    $0x8,%esp
  iret
80105d8c:	cf                   	iret   
80105d8d:	66 90                	xchg   %ax,%ax
80105d8f:	90                   	nop

80105d90 <tvinit>:
struct spinlock tickslock;
uint ticks, virtualAddr, problematicPage;
struct proc *p;

void
tvinit(void) {
80105d90:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105d91:	31 c0                	xor    %eax,%eax
tvinit(void) {
80105d93:	89 e5                	mov    %esp,%ebp
80105d95:	83 ec 08             	sub    $0x8,%esp
80105d98:	90                   	nop
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105da0:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105da7:	c7 04 c5 c2 53 12 80 	movl   $0x8e000008,-0x7fedac3e(,%eax,8)
80105dae:	08 00 00 8e 
80105db2:	66 89 14 c5 c0 53 12 	mov    %dx,-0x7fedac40(,%eax,8)
80105db9:	80 
80105dba:	c1 ea 10             	shr    $0x10,%edx
80105dbd:	66 89 14 c5 c6 53 12 	mov    %dx,-0x7fedac3a(,%eax,8)
80105dc4:	80 
80105dc5:	83 c0 01             	add    $0x1,%eax
80105dc8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105dcd:	75 d1                	jne    80105da0 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105dcf:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

    initlock(&tickslock, "time");
80105dd4:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105dd7:	c7 05 c2 55 12 80 08 	movl   $0xef000008,0x801255c2
80105dde:	00 00 ef 
    initlock(&tickslock, "time");
80105de1:	68 99 83 10 80       	push   $0x80108399
80105de6:	68 80 53 12 80       	push   $0x80125380
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105deb:	66 a3 c0 55 12 80    	mov    %ax,0x801255c0
80105df1:	c1 e8 10             	shr    $0x10,%eax
80105df4:	66 a3 c6 55 12 80    	mov    %ax,0x801255c6
    initlock(&tickslock, "time");
80105dfa:	e8 d1 ea ff ff       	call   801048d0 <initlock>
}
80105dff:	83 c4 10             	add    $0x10,%esp
80105e02:	c9                   	leave  
80105e03:	c3                   	ret    
80105e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105e10 <idtinit>:

void
idtinit(void) {
80105e10:	55                   	push   %ebp
  pd[0] = size-1;
80105e11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e16:	89 e5                	mov    %esp,%ebp
80105e18:	83 ec 10             	sub    $0x10,%esp
80105e1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e1f:	b8 c0 53 12 80       	mov    $0x801253c0,%eax
80105e24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e28:	c1 e8 10             	shr    $0x10,%eax
80105e2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e32:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80105e35:	c9                   	leave  
80105e36:	c3                   	ret    
80105e37:	89 f6                	mov    %esi,%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	57                   	push   %edi
80105e44:	56                   	push   %esi
80105e45:	53                   	push   %ebx
80105e46:	83 ec 1c             	sub    $0x1c,%esp
80105e49:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (tf->trapno == T_SYSCALL) {
80105e4c:	8b 47 30             	mov    0x30(%edi),%eax
80105e4f:	83 f8 40             	cmp    $0x40,%eax
80105e52:	0f 84 f0 00 00 00    	je     80105f48 <trap+0x108>
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
80105e58:	83 e8 0e             	sub    $0xe,%eax
80105e5b:	83 f8 31             	cmp    $0x31,%eax
80105e5e:	77 10                	ja     80105e70 <trap+0x30>
80105e60:	ff 24 85 b4 84 10 80 	jmp    *-0x7fef7b4c(,%eax,4)
80105e67:	89 f6                	mov    %esi,%esi
80105e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi



            //PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80105e70:	e8 eb dd ff ff       	call   80103c60 <myproc>
80105e75:	85 c0                	test   %eax,%eax
80105e77:	0f 84 24 04 00 00    	je     801062a1 <trap+0x461>
80105e7d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105e81:	0f 84 1a 04 00 00    	je     801062a1 <trap+0x461>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e87:	0f 20 d1             	mov    %cr2,%ecx
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e8a:	8b 57 38             	mov    0x38(%edi),%edx
80105e8d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105e90:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105e93:	e8 a8 dd ff ff       	call   80103c40 <cpuid>
80105e98:	8b 77 34             	mov    0x34(%edi),%esi
80105e9b:	8b 5f 30             	mov    0x30(%edi),%ebx
80105e9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
80105ea1:	e8 ba dd ff ff       	call   80103c60 <myproc>
80105ea6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ea9:	e8 b2 dd ff ff       	call   80103c60 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eae:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105eb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105eb4:	51                   	push   %ecx
80105eb5:	52                   	push   %edx
                    myproc()->pid, myproc()->name, tf->trapno,
80105eb6:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eb9:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ebc:	56                   	push   %esi
80105ebd:	53                   	push   %ebx
                    myproc()->pid, myproc()->name, tf->trapno,
80105ebe:	83 c2 6c             	add    $0x6c,%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ec1:	52                   	push   %edx
80105ec2:	ff 70 10             	pushl  0x10(%eax)
80105ec5:	68 70 84 10 80       	push   $0x80108470
80105eca:	e8 91 a7 ff ff       	call   80100660 <cprintf>
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
80105ecf:	83 c4 20             	add    $0x20,%esp
80105ed2:	e8 89 dd ff ff       	call   80103c60 <myproc>
80105ed7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105ede:	66 90                	xchg   %ax,%ax
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105ee0:	e8 7b dd ff ff       	call   80103c60 <myproc>
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	74 1d                	je     80105f06 <trap+0xc6>
80105ee9:	e8 72 dd ff ff       	call   80103c60 <myproc>
80105eee:	8b 50 24             	mov    0x24(%eax),%edx
80105ef1:	85 d2                	test   %edx,%edx
80105ef3:	74 11                	je     80105f06 <trap+0xc6>
80105ef5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ef9:	83 e0 03             	and    $0x3,%eax
80105efc:	66 83 f8 03          	cmp    $0x3,%ax
80105f00:	0f 84 8a 02 00 00    	je     80106190 <trap+0x350>
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80105f06:	e8 55 dd ff ff       	call   80103c60 <myproc>
80105f0b:	85 c0                	test   %eax,%eax
80105f0d:	74 0b                	je     80105f1a <trap+0xda>
80105f0f:	e8 4c dd ff ff       	call   80103c60 <myproc>
80105f14:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f18:	74 66                	je     80105f80 <trap+0x140>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80105f1a:	e8 41 dd ff ff       	call   80103c60 <myproc>
80105f1f:	85 c0                	test   %eax,%eax
80105f21:	74 19                	je     80105f3c <trap+0xfc>
80105f23:	e8 38 dd ff ff       	call   80103c60 <myproc>
80105f28:	8b 40 24             	mov    0x24(%eax),%eax
80105f2b:	85 c0                	test   %eax,%eax
80105f2d:	74 0d                	je     80105f3c <trap+0xfc>
80105f2f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f33:	83 e0 03             	and    $0x3,%eax
80105f36:	66 83 f8 03          	cmp    $0x3,%ax
80105f3a:	74 35                	je     80105f71 <trap+0x131>
        exit();
}
80105f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f3f:	5b                   	pop    %ebx
80105f40:	5e                   	pop    %esi
80105f41:	5f                   	pop    %edi
80105f42:	5d                   	pop    %ebp
80105f43:	c3                   	ret    
80105f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed)
80105f48:	e8 13 dd ff ff       	call   80103c60 <myproc>
80105f4d:	8b 58 24             	mov    0x24(%eax),%ebx
80105f50:	85 db                	test   %ebx,%ebx
80105f52:	0f 85 98 01 00 00    	jne    801060f0 <trap+0x2b0>
        myproc()->tf = tf;
80105f58:	e8 03 dd ff ff       	call   80103c60 <myproc>
80105f5d:	89 78 18             	mov    %edi,0x18(%eax)
        syscall();
80105f60:	e8 cb ef ff ff       	call   80104f30 <syscall>
        if (myproc()->killed)
80105f65:	e8 f6 dc ff ff       	call   80103c60 <myproc>
80105f6a:	8b 48 24             	mov    0x24(%eax),%ecx
80105f6d:	85 c9                	test   %ecx,%ecx
80105f6f:	74 cb                	je     80105f3c <trap+0xfc>
}
80105f71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f74:	5b                   	pop    %ebx
80105f75:	5e                   	pop    %esi
80105f76:	5f                   	pop    %edi
80105f77:	5d                   	pop    %ebp
            exit();
80105f78:	e9 93 e2 ff ff       	jmp    80104210 <exit>
80105f7d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
80105f80:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105f84:	75 94                	jne    80105f1a <trap+0xda>
        yield();
80105f86:	e8 d5 e3 ff ff       	call   80104360 <yield>
80105f8b:	eb 8d                	jmp    80105f1a <trap+0xda>
80105f8d:	8d 76 00             	lea    0x0(%esi),%esi
            p = myproc();
80105f90:	e8 cb dc ff ff       	call   80103c60 <myproc>
80105f95:	a3 60 53 12 80       	mov    %eax,0x80125360
80105f9a:	0f 20 d2             	mov    %cr2,%edx
            virtualAddr = rcr2();
80105f9d:	89 15 c4 5b 12 80    	mov    %edx,0x80125bc4
            problematicPage = PGROUNDDOWN(virtualAddr);
80105fa3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
            for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
80105fa9:	8d 88 80 00 00 00    	lea    0x80(%eax),%ecx
            problematicPage = PGROUNDDOWN(virtualAddr);
80105faf:	89 15 64 53 12 80    	mov    %edx,0x80125364
                if (cg->present == 0 || cg->active == 0)
80105fb5:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
            for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
80105fbb:	8d b0 00 04 00 00    	lea    0x400(%eax),%esi
                if (cg->present == 0 || cg->active == 0)
80105fc1:	85 d2                	test   %edx,%edx
80105fc3:	0f 84 37 01 00 00    	je     80106100 <trap+0x2c0>
80105fc9:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
80105fcf:	85 db                	test   %ebx,%ebx
80105fd1:	0f 84 29 01 00 00    	je     80106100 <trap+0x2c0>
            for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
80105fd7:	89 ca                	mov    %ecx,%edx
80105fd9:	eb 18                	jmp    80105ff3 <trap+0x1b3>
80105fdb:	90                   	nop
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                if (cg->present == 0 || cg->active == 0)
80105fe0:	83 7a 0c 00          	cmpl   $0x0,0xc(%edx)
80105fe4:	0f 84 16 01 00 00    	je     80106100 <trap+0x2c0>
80105fea:	83 3a 00             	cmpl   $0x0,(%edx)
80105fed:	0f 84 0d 01 00 00    	je     80106100 <trap+0x2c0>
            for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
80105ff3:	83 c2 1c             	add    $0x1c,%edx
80105ff6:	39 f2                	cmp    %esi,%edx
80105ff8:	72 e6                	jb     80105fe0 <trap+0x1a0>
            int maxSeq = 0, i;
80105ffa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            struct page *cg = 0, *pg = 0;
80106001:	be 00 00 00 00       	mov    $0x0,%esi
            if (cg == &p->pages[MAX_TOTAL_PAGES]) { //if true - there is a room for another page- need to swap out
80106006:	74 0a                	je     80106012 <trap+0x1d2>
80106008:	e9 f5 00 00 00       	jmp    80106102 <trap+0x2c2>
8010600d:	8d 76 00             	lea    0x0(%esi),%esi
80106010:	8b 19                	mov    (%ecx),%ebx
                    if (cg->active && cg->present && cg->sequel > maxSeq) {
80106012:	85 db                	test   %ebx,%ebx
80106014:	74 1a                	je     80106030 <trap+0x1f0>
80106016:	8b 59 0c             	mov    0xc(%ecx),%ebx
80106019:	85 db                	test   %ebx,%ebx
8010601b:	74 13                	je     80106030 <trap+0x1f0>
8010601d:	8b 59 08             	mov    0x8(%ecx),%ebx
80106020:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80106023:	7e 0b                	jle    80106030 <trap+0x1f0>
80106025:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106028:	89 ce                	mov    %ecx,%esi
8010602a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
80106030:	83 c1 1c             	add    $0x1c,%ecx
80106033:	39 ca                	cmp    %ecx,%edx
80106035:	77 d9                	ja     80106010 <trap+0x1d0>
80106037:	e9 c6 00 00 00       	jmp    80106102 <trap+0x2c2>
8010603c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ideintr();
80106040:	e8 0b c4 ff ff       	call   80102450 <ideintr>
            lapiceoi();
80106045:	e8 d6 ca ff ff       	call   80102b20 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010604a:	e8 11 dc ff ff       	call   80103c60 <myproc>
8010604f:	85 c0                	test   %eax,%eax
80106051:	0f 85 92 fe ff ff    	jne    80105ee9 <trap+0xa9>
80106057:	e9 aa fe ff ff       	jmp    80105f06 <trap+0xc6>
8010605c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80106060:	e8 7b c9 ff ff       	call   801029e0 <kbdintr>
            lapiceoi();
80106065:	e8 b6 ca ff ff       	call   80102b20 <lapiceoi>
            break;
8010606a:	e9 71 fe ff ff       	jmp    80105ee0 <trap+0xa0>
8010606f:	90                   	nop
            uartintr();
80106070:	e8 db 03 00 00       	call   80106450 <uartintr>
            lapiceoi();
80106075:	e8 a6 ca ff ff       	call   80102b20 <lapiceoi>
            break;
8010607a:	e9 61 fe ff ff       	jmp    80105ee0 <trap+0xa0>
8010607f:	90                   	nop
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106080:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106084:	8b 77 38             	mov    0x38(%edi),%esi
80106087:	e8 b4 db ff ff       	call   80103c40 <cpuid>
8010608c:	56                   	push   %esi
8010608d:	53                   	push   %ebx
8010608e:	50                   	push   %eax
8010608f:	68 c0 83 10 80       	push   $0x801083c0
80106094:	e8 c7 a5 ff ff       	call   80100660 <cprintf>
            lapiceoi();
80106099:	e8 82 ca ff ff       	call   80102b20 <lapiceoi>
            break;
8010609e:	83 c4 10             	add    $0x10,%esp
801060a1:	e9 3a fe ff ff       	jmp    80105ee0 <trap+0xa0>
801060a6:	8d 76 00             	lea    0x0(%esi),%esi
801060a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (cpuid() == 0) {
801060b0:	e8 8b db ff ff       	call   80103c40 <cpuid>
801060b5:	85 c0                	test   %eax,%eax
801060b7:	75 8c                	jne    80106045 <trap+0x205>
                acquire(&tickslock);
801060b9:	83 ec 0c             	sub    $0xc,%esp
801060bc:	68 80 53 12 80       	push   $0x80125380
801060c1:	e8 fa e8 ff ff       	call   801049c0 <acquire>
                wakeup(&ticks);
801060c6:	c7 04 24 c0 5b 12 80 	movl   $0x80125bc0,(%esp)
                ticks++;
801060cd:	83 05 c0 5b 12 80 01 	addl   $0x1,0x80125bc0
                wakeup(&ticks);
801060d4:	e8 37 e5 ff ff       	call   80104610 <wakeup>
                release(&tickslock);
801060d9:	c7 04 24 80 53 12 80 	movl   $0x80125380,(%esp)
801060e0:	e8 fb e9 ff ff       	call   80104ae0 <release>
801060e5:	83 c4 10             	add    $0x10,%esp
801060e8:	e9 58 ff ff ff       	jmp    80106045 <trap+0x205>
801060ed:	8d 76 00             	lea    0x0(%esi),%esi
            exit();
801060f0:	e8 1b e1 ff ff       	call   80104210 <exit>
801060f5:	e9 5e fe ff ff       	jmp    80105f58 <trap+0x118>
801060fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            struct page *cg = 0, *pg = 0;
80106100:	31 f6                	xor    %esi,%esi
            swapOutPage(p, pg, p->pgdir); //func in vm.c - same use in allocuvm
80106102:	83 ec 04             	sub    $0x4,%esp
80106105:	ff 70 04             	pushl  0x4(%eax)
80106108:	56                   	push   %esi
80106109:	50                   	push   %eax
8010610a:	e8 51 12 00 00       	call   80107360 <swapOutPage>
            newAddr = kalloc();
8010610f:	e8 7c c7 ff ff       	call   80102890 <kalloc>
            if (!newAddr) {
80106114:	83 c4 10             	add    $0x10,%esp
80106117:	85 c0                	test   %eax,%eax
            newAddr = kalloc();
80106119:	89 c6                	mov    %eax,%esi
            if (!newAddr) {
8010611b:	0f 84 5f 01 00 00    	je     80106280 <trap+0x440>
            memset(newAddr, 0, PGSIZE); //clean the page
80106121:	83 ec 04             	sub    $0x4,%esp
80106124:	68 00 10 00 00       	push   $0x1000
80106129:	6a 00                	push   $0x0
8010612b:	50                   	push   %eax
8010612c:	e8 0f ea ff ff       	call   80104b40 <memset>
            for (cg = p->pages, i=0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++);
80106131:	8b 0d 60 53 12 80    	mov    0x80125360,%ecx
80106137:	a1 64 53 12 80       	mov    0x80125364,%eax
8010613c:	83 c4 10             	add    $0x10,%esp
8010613f:	39 81 98 00 00 00    	cmp    %eax,0x98(%ecx)
80106145:	8d 99 80 00 00 00    	lea    0x80(%ecx),%ebx
8010614b:	8d 91 00 04 00 00    	lea    0x400(%ecx),%edx
80106151:	0f 84 3e 01 00 00    	je     80106295 <trap+0x455>
80106157:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010615a:	31 c9                	xor    %ecx,%ecx
8010615c:	eb 07                	jmp    80106165 <trap+0x325>
8010615e:	66 90                	xchg   %ax,%ax
80106160:	39 43 18             	cmp    %eax,0x18(%ebx)
80106163:	74 3b                	je     801061a0 <trap+0x360>
80106165:	83 c3 1c             	add    $0x1c,%ebx
80106168:	83 c1 01             	add    $0x1,%ecx
8010616b:	39 da                	cmp    %ebx,%edx
8010616d:	77 f1                	ja     80106160 <trap+0x320>
8010616f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106172:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            if (cg == &p->pages[MAX_TOTAL_PAGES]) { //if true -didn't find the addr -error
80106175:	75 2f                	jne    801061a6 <trap+0x366>
                cprintf("Error- didn't find the trap's page in T_PGFLT\n");
80106177:	83 ec 0c             	sub    $0xc,%esp
8010617a:	68 e4 83 10 80       	push   $0x801083e4
8010617f:	e8 dc a4 ff ff       	call   80100660 <cprintf>
                break;
80106184:	83 c4 10             	add    $0x10,%esp
80106187:	e9 54 fd ff ff       	jmp    80105ee0 <trap+0xa0>
8010618c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        exit();
80106190:	e8 7b e0 ff ff       	call   80104210 <exit>
80106195:	e9 6c fd ff ff       	jmp    80105f06 <trap+0xc6>
8010619a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061a0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801061a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            if (readFromSwapFile(p, newAddr, cg->offset * PGSIZE, PGSIZE) == -1)
801061a6:	68 00 10 00 00       	push   $0x1000
801061ab:	8b 43 10             	mov    0x10(%ebx),%eax
801061ae:	c1 e0 0c             	shl    $0xc,%eax
801061b1:	50                   	push   %eax
801061b2:	56                   	push   %esi
801061b3:	51                   	push   %ecx
801061b4:	e8 07 c1 ff ff       	call   801022c0 <readFromSwapFile>
801061b9:	83 c4 10             	add    $0x10,%esp
801061bc:	83 f8 ff             	cmp    $0xffffffff,%eax
801061bf:	0f 84 07 01 00 00    	je     801062cc <trap+0x48c>
            currPTE=walkpgdir2(p->pgdir, (void *) virtualAddr, 0);
801061c5:	a1 60 53 12 80       	mov    0x80125360,%eax
801061ca:	83 ec 04             	sub    $0x4,%esp
801061cd:	6a 00                	push   $0x0
801061cf:	ff 35 c4 5b 12 80    	pushl  0x80125bc4
801061d5:	ff 70 04             	pushl  0x4(%eax)
801061d8:	e8 a3 0e 00 00       	call   80107080 <walkpgdir2>
801061dd:	89 c2                	mov    %eax,%edx
            *currPTE=PTE_P_0(*currPTE);
801061df:	8b 00                	mov    (%eax),%eax
            *currPTE=PTE_PG_1(*currPTE);
801061e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            *currPTE=PTE_P_0(*currPTE);
801061e4:	83 e0 fe             	and    $0xfffffffe,%eax
            *currPTE=PTE_PG_1(*currPTE);
801061e7:	80 cc 02             	or     $0x2,%ah
801061ea:	89 02                	mov    %eax,(%edx)
            mappages2(p->pgdir,(void *) problematicPage,PGSIZE,V2P(newAddr),PTE_U | PTE_W);
801061ec:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801061f2:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801061f9:	50                   	push   %eax
801061fa:	a1 60 53 12 80       	mov    0x80125360,%eax
801061ff:	68 00 10 00 00       	push   $0x1000
80106204:	ff 35 64 53 12 80    	pushl  0x80125364
8010620a:	ff 70 04             	pushl  0x4(%eax)
8010620d:	e8 8e 0e 00 00       	call   801070a0 <mappages2>
            *currPTE=PTE_PG_0(*currPTE);
80106212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            lapiceoi();
80106215:	83 c4 20             	add    $0x20,%esp
            *currPTE=PTE_PG_0(*currPTE);
80106218:	8b 02                	mov    (%edx),%eax
8010621a:	80 e4 fd             	and    $0xfd,%ah
8010621d:	83 c8 01             	or     $0x1,%eax
80106220:	89 02                	mov    %eax,(%edx)
            cg->active=1;
80106222:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
            cg->sequel=p->pagesequel++;
80106228:	a1 60 53 12 80       	mov    0x80125360,%eax
            cg->virtAdress=newAddr;
8010622d:	89 73 18             	mov    %esi,0x18(%ebx)
            cg->offset=0;
80106230:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
            cg->present=1;
80106237:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
            p->swapFileEntries[i]=0;
8010623e:	8b 75 e0             	mov    -0x20(%ebp),%esi
            cg->sequel=p->pagesequel++;
80106241:	8b 90 14 04 00 00    	mov    0x414(%eax),%edx
80106247:	8d 4a 01             	lea    0x1(%edx),%ecx
8010624a:	89 88 14 04 00 00    	mov    %ecx,0x414(%eax)
80106250:	89 53 08             	mov    %edx,0x8(%ebx)
            p->swapFileEntries[i]=0;
80106253:	c7 84 b0 00 04 00 00 	movl   $0x0,0x400(%eax,%esi,4)
8010625a:	00 00 00 00 
            p->pagesCounter++;
8010625e:	83 80 0c 04 00 00 01 	addl   $0x1,0x40c(%eax)
            p->pagesinSwap--;
80106265:	83 a8 10 04 00 00 01 	subl   $0x1,0x410(%eax)
            lapiceoi();
8010626c:	e8 af c8 ff ff       	call   80102b20 <lapiceoi>
            break;
80106271:	e9 6a fc ff ff       	jmp    80105ee0 <trap+0xa0>
80106276:	8d 76 00             	lea    0x0(%esi),%esi
80106279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                cprintf("Error- kalloc in T_PGFLT\n");
80106280:	83 ec 0c             	sub    $0xc,%esp
80106283:	68 9e 83 10 80       	push   $0x8010839e
80106288:	e8 d3 a3 ff ff       	call   80100660 <cprintf>
                break;
8010628d:	83 c4 10             	add    $0x10,%esp
80106290:	e9 4b fc ff ff       	jmp    80105ee0 <trap+0xa0>
            for (cg = p->pages, i=0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++);
80106295:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010629c:	e9 05 ff ff ff       	jmp    801061a6 <trap+0x366>
801062a1:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062a4:	8b 5f 38             	mov    0x38(%edi),%ebx
801062a7:	e8 94 d9 ff ff       	call   80103c40 <cpuid>
801062ac:	83 ec 0c             	sub    $0xc,%esp
801062af:	56                   	push   %esi
801062b0:	53                   	push   %ebx
801062b1:	50                   	push   %eax
801062b2:	ff 77 30             	pushl  0x30(%edi)
801062b5:	68 3c 84 10 80       	push   $0x8010843c
801062ba:	e8 a1 a3 ff ff       	call   80100660 <cprintf>
                panic("trap");
801062bf:	83 c4 14             	add    $0x14,%esp
801062c2:	68 b8 83 10 80       	push   $0x801083b8
801062c7:	e8 c4 a0 ff ff       	call   80100390 <panic>
                panic("error - read from swapfile in T_PGFLT");
801062cc:	83 ec 0c             	sub    $0xc,%esp
801062cf:	68 14 84 10 80       	push   $0x80108414
801062d4:	e8 b7 a0 ff ff       	call   80100390 <panic>
801062d9:	66 90                	xchg   %ax,%ax
801062db:	66 90                	xchg   %ax,%ax
801062dd:	66 90                	xchg   %ax,%ax
801062df:	90                   	nop

801062e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801062e0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
801062e5:	55                   	push   %ebp
801062e6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801062e8:	85 c0                	test   %eax,%eax
801062ea:	74 1c                	je     80106308 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062ec:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062f1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062f2:	a8 01                	test   $0x1,%al
801062f4:	74 12                	je     80106308 <uartgetc+0x28>
801062f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062fb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801062fc:	0f b6 c0             	movzbl %al,%eax
}
801062ff:	5d                   	pop    %ebp
80106300:	c3                   	ret    
80106301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010630d:	5d                   	pop    %ebp
8010630e:	c3                   	ret    
8010630f:	90                   	nop

80106310 <uartputc.part.0>:
uartputc(int c)
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
80106313:	57                   	push   %edi
80106314:	56                   	push   %esi
80106315:	53                   	push   %ebx
80106316:	89 c7                	mov    %eax,%edi
80106318:	bb 80 00 00 00       	mov    $0x80,%ebx
8010631d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106322:	83 ec 0c             	sub    $0xc,%esp
80106325:	eb 1b                	jmp    80106342 <uartputc.part.0+0x32>
80106327:	89 f6                	mov    %esi,%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106330:	83 ec 0c             	sub    $0xc,%esp
80106333:	6a 0a                	push   $0xa
80106335:	e8 06 c8 ff ff       	call   80102b40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010633a:	83 c4 10             	add    $0x10,%esp
8010633d:	83 eb 01             	sub    $0x1,%ebx
80106340:	74 07                	je     80106349 <uartputc.part.0+0x39>
80106342:	89 f2                	mov    %esi,%edx
80106344:	ec                   	in     (%dx),%al
80106345:	a8 20                	test   $0x20,%al
80106347:	74 e7                	je     80106330 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106349:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010634e:	89 f8                	mov    %edi,%eax
80106350:	ee                   	out    %al,(%dx)
}
80106351:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106354:	5b                   	pop    %ebx
80106355:	5e                   	pop    %esi
80106356:	5f                   	pop    %edi
80106357:	5d                   	pop    %ebp
80106358:	c3                   	ret    
80106359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106360 <uartinit>:
{
80106360:	55                   	push   %ebp
80106361:	31 c9                	xor    %ecx,%ecx
80106363:	89 c8                	mov    %ecx,%eax
80106365:	89 e5                	mov    %esp,%ebp
80106367:	57                   	push   %edi
80106368:	56                   	push   %esi
80106369:	53                   	push   %ebx
8010636a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010636f:	89 da                	mov    %ebx,%edx
80106371:	83 ec 0c             	sub    $0xc,%esp
80106374:	ee                   	out    %al,(%dx)
80106375:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010637a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010637f:	89 fa                	mov    %edi,%edx
80106381:	ee                   	out    %al,(%dx)
80106382:	b8 0c 00 00 00       	mov    $0xc,%eax
80106387:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010638c:	ee                   	out    %al,(%dx)
8010638d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106392:	89 c8                	mov    %ecx,%eax
80106394:	89 f2                	mov    %esi,%edx
80106396:	ee                   	out    %al,(%dx)
80106397:	b8 03 00 00 00       	mov    $0x3,%eax
8010639c:	89 fa                	mov    %edi,%edx
8010639e:	ee                   	out    %al,(%dx)
8010639f:	ba fc 03 00 00       	mov    $0x3fc,%edx
801063a4:	89 c8                	mov    %ecx,%eax
801063a6:	ee                   	out    %al,(%dx)
801063a7:	b8 01 00 00 00       	mov    $0x1,%eax
801063ac:	89 f2                	mov    %esi,%edx
801063ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063af:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063b4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801063b5:	3c ff                	cmp    $0xff,%al
801063b7:	74 5a                	je     80106413 <uartinit+0xb3>
  uart = 1;
801063b9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801063c0:	00 00 00 
801063c3:	89 da                	mov    %ebx,%edx
801063c5:	ec                   	in     (%dx),%al
801063c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063cb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801063cc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801063cf:	bb 7c 85 10 80       	mov    $0x8010857c,%ebx
  ioapicenable(IRQ_COM1, 0);
801063d4:	6a 00                	push   $0x0
801063d6:	6a 04                	push   $0x4
801063d8:	e8 c3 c2 ff ff       	call   801026a0 <ioapicenable>
801063dd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801063e0:	b8 78 00 00 00       	mov    $0x78,%eax
801063e5:	eb 13                	jmp    801063fa <uartinit+0x9a>
801063e7:	89 f6                	mov    %esi,%esi
801063e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801063f0:	83 c3 01             	add    $0x1,%ebx
801063f3:	0f be 03             	movsbl (%ebx),%eax
801063f6:	84 c0                	test   %al,%al
801063f8:	74 19                	je     80106413 <uartinit+0xb3>
  if(!uart)
801063fa:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106400:	85 d2                	test   %edx,%edx
80106402:	74 ec                	je     801063f0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106404:	83 c3 01             	add    $0x1,%ebx
80106407:	e8 04 ff ff ff       	call   80106310 <uartputc.part.0>
8010640c:	0f be 03             	movsbl (%ebx),%eax
8010640f:	84 c0                	test   %al,%al
80106411:	75 e7                	jne    801063fa <uartinit+0x9a>
}
80106413:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106416:	5b                   	pop    %ebx
80106417:	5e                   	pop    %esi
80106418:	5f                   	pop    %edi
80106419:	5d                   	pop    %ebp
8010641a:	c3                   	ret    
8010641b:	90                   	nop
8010641c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106420 <uartputc>:
  if(!uart)
80106420:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106426:	55                   	push   %ebp
80106427:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106429:	85 d2                	test   %edx,%edx
{
8010642b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010642e:	74 10                	je     80106440 <uartputc+0x20>
}
80106430:	5d                   	pop    %ebp
80106431:	e9 da fe ff ff       	jmp    80106310 <uartputc.part.0>
80106436:	8d 76 00             	lea    0x0(%esi),%esi
80106439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106440:	5d                   	pop    %ebp
80106441:	c3                   	ret    
80106442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106450 <uartintr>:

void
uartintr(void)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106456:	68 e0 62 10 80       	push   $0x801062e0
8010645b:	e8 b0 a3 ff ff       	call   80100810 <consoleintr>
}
80106460:	83 c4 10             	add    $0x10,%esp
80106463:	c9                   	leave  
80106464:	c3                   	ret    

80106465 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106465:	6a 00                	push   $0x0
  pushl $0
80106467:	6a 00                	push   $0x0
  jmp alltraps
80106469:	e9 fc f8 ff ff       	jmp    80105d6a <alltraps>

8010646e <vector1>:
.globl vector1
vector1:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $1
80106470:	6a 01                	push   $0x1
  jmp alltraps
80106472:	e9 f3 f8 ff ff       	jmp    80105d6a <alltraps>

80106477 <vector2>:
.globl vector2
vector2:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $2
80106479:	6a 02                	push   $0x2
  jmp alltraps
8010647b:	e9 ea f8 ff ff       	jmp    80105d6a <alltraps>

80106480 <vector3>:
.globl vector3
vector3:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $3
80106482:	6a 03                	push   $0x3
  jmp alltraps
80106484:	e9 e1 f8 ff ff       	jmp    80105d6a <alltraps>

80106489 <vector4>:
.globl vector4
vector4:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $4
8010648b:	6a 04                	push   $0x4
  jmp alltraps
8010648d:	e9 d8 f8 ff ff       	jmp    80105d6a <alltraps>

80106492 <vector5>:
.globl vector5
vector5:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $5
80106494:	6a 05                	push   $0x5
  jmp alltraps
80106496:	e9 cf f8 ff ff       	jmp    80105d6a <alltraps>

8010649b <vector6>:
.globl vector6
vector6:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $6
8010649d:	6a 06                	push   $0x6
  jmp alltraps
8010649f:	e9 c6 f8 ff ff       	jmp    80105d6a <alltraps>

801064a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $7
801064a6:	6a 07                	push   $0x7
  jmp alltraps
801064a8:	e9 bd f8 ff ff       	jmp    80105d6a <alltraps>

801064ad <vector8>:
.globl vector8
vector8:
  pushl $8
801064ad:	6a 08                	push   $0x8
  jmp alltraps
801064af:	e9 b6 f8 ff ff       	jmp    80105d6a <alltraps>

801064b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801064b4:	6a 00                	push   $0x0
  pushl $9
801064b6:	6a 09                	push   $0x9
  jmp alltraps
801064b8:	e9 ad f8 ff ff       	jmp    80105d6a <alltraps>

801064bd <vector10>:
.globl vector10
vector10:
  pushl $10
801064bd:	6a 0a                	push   $0xa
  jmp alltraps
801064bf:	e9 a6 f8 ff ff       	jmp    80105d6a <alltraps>

801064c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801064c4:	6a 0b                	push   $0xb
  jmp alltraps
801064c6:	e9 9f f8 ff ff       	jmp    80105d6a <alltraps>

801064cb <vector12>:
.globl vector12
vector12:
  pushl $12
801064cb:	6a 0c                	push   $0xc
  jmp alltraps
801064cd:	e9 98 f8 ff ff       	jmp    80105d6a <alltraps>

801064d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801064d2:	6a 0d                	push   $0xd
  jmp alltraps
801064d4:	e9 91 f8 ff ff       	jmp    80105d6a <alltraps>

801064d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801064d9:	6a 0e                	push   $0xe
  jmp alltraps
801064db:	e9 8a f8 ff ff       	jmp    80105d6a <alltraps>

801064e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $15
801064e2:	6a 0f                	push   $0xf
  jmp alltraps
801064e4:	e9 81 f8 ff ff       	jmp    80105d6a <alltraps>

801064e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $16
801064eb:	6a 10                	push   $0x10
  jmp alltraps
801064ed:	e9 78 f8 ff ff       	jmp    80105d6a <alltraps>

801064f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801064f2:	6a 11                	push   $0x11
  jmp alltraps
801064f4:	e9 71 f8 ff ff       	jmp    80105d6a <alltraps>

801064f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801064f9:	6a 00                	push   $0x0
  pushl $18
801064fb:	6a 12                	push   $0x12
  jmp alltraps
801064fd:	e9 68 f8 ff ff       	jmp    80105d6a <alltraps>

80106502 <vector19>:
.globl vector19
vector19:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $19
80106504:	6a 13                	push   $0x13
  jmp alltraps
80106506:	e9 5f f8 ff ff       	jmp    80105d6a <alltraps>

8010650b <vector20>:
.globl vector20
vector20:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $20
8010650d:	6a 14                	push   $0x14
  jmp alltraps
8010650f:	e9 56 f8 ff ff       	jmp    80105d6a <alltraps>

80106514 <vector21>:
.globl vector21
vector21:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $21
80106516:	6a 15                	push   $0x15
  jmp alltraps
80106518:	e9 4d f8 ff ff       	jmp    80105d6a <alltraps>

8010651d <vector22>:
.globl vector22
vector22:
  pushl $0
8010651d:	6a 00                	push   $0x0
  pushl $22
8010651f:	6a 16                	push   $0x16
  jmp alltraps
80106521:	e9 44 f8 ff ff       	jmp    80105d6a <alltraps>

80106526 <vector23>:
.globl vector23
vector23:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $23
80106528:	6a 17                	push   $0x17
  jmp alltraps
8010652a:	e9 3b f8 ff ff       	jmp    80105d6a <alltraps>

8010652f <vector24>:
.globl vector24
vector24:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $24
80106531:	6a 18                	push   $0x18
  jmp alltraps
80106533:	e9 32 f8 ff ff       	jmp    80105d6a <alltraps>

80106538 <vector25>:
.globl vector25
vector25:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $25
8010653a:	6a 19                	push   $0x19
  jmp alltraps
8010653c:	e9 29 f8 ff ff       	jmp    80105d6a <alltraps>

80106541 <vector26>:
.globl vector26
vector26:
  pushl $0
80106541:	6a 00                	push   $0x0
  pushl $26
80106543:	6a 1a                	push   $0x1a
  jmp alltraps
80106545:	e9 20 f8 ff ff       	jmp    80105d6a <alltraps>

8010654a <vector27>:
.globl vector27
vector27:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $27
8010654c:	6a 1b                	push   $0x1b
  jmp alltraps
8010654e:	e9 17 f8 ff ff       	jmp    80105d6a <alltraps>

80106553 <vector28>:
.globl vector28
vector28:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $28
80106555:	6a 1c                	push   $0x1c
  jmp alltraps
80106557:	e9 0e f8 ff ff       	jmp    80105d6a <alltraps>

8010655c <vector29>:
.globl vector29
vector29:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $29
8010655e:	6a 1d                	push   $0x1d
  jmp alltraps
80106560:	e9 05 f8 ff ff       	jmp    80105d6a <alltraps>

80106565 <vector30>:
.globl vector30
vector30:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $30
80106567:	6a 1e                	push   $0x1e
  jmp alltraps
80106569:	e9 fc f7 ff ff       	jmp    80105d6a <alltraps>

8010656e <vector31>:
.globl vector31
vector31:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $31
80106570:	6a 1f                	push   $0x1f
  jmp alltraps
80106572:	e9 f3 f7 ff ff       	jmp    80105d6a <alltraps>

80106577 <vector32>:
.globl vector32
vector32:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $32
80106579:	6a 20                	push   $0x20
  jmp alltraps
8010657b:	e9 ea f7 ff ff       	jmp    80105d6a <alltraps>

80106580 <vector33>:
.globl vector33
vector33:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $33
80106582:	6a 21                	push   $0x21
  jmp alltraps
80106584:	e9 e1 f7 ff ff       	jmp    80105d6a <alltraps>

80106589 <vector34>:
.globl vector34
vector34:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $34
8010658b:	6a 22                	push   $0x22
  jmp alltraps
8010658d:	e9 d8 f7 ff ff       	jmp    80105d6a <alltraps>

80106592 <vector35>:
.globl vector35
vector35:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $35
80106594:	6a 23                	push   $0x23
  jmp alltraps
80106596:	e9 cf f7 ff ff       	jmp    80105d6a <alltraps>

8010659b <vector36>:
.globl vector36
vector36:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $36
8010659d:	6a 24                	push   $0x24
  jmp alltraps
8010659f:	e9 c6 f7 ff ff       	jmp    80105d6a <alltraps>

801065a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $37
801065a6:	6a 25                	push   $0x25
  jmp alltraps
801065a8:	e9 bd f7 ff ff       	jmp    80105d6a <alltraps>

801065ad <vector38>:
.globl vector38
vector38:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $38
801065af:	6a 26                	push   $0x26
  jmp alltraps
801065b1:	e9 b4 f7 ff ff       	jmp    80105d6a <alltraps>

801065b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $39
801065b8:	6a 27                	push   $0x27
  jmp alltraps
801065ba:	e9 ab f7 ff ff       	jmp    80105d6a <alltraps>

801065bf <vector40>:
.globl vector40
vector40:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $40
801065c1:	6a 28                	push   $0x28
  jmp alltraps
801065c3:	e9 a2 f7 ff ff       	jmp    80105d6a <alltraps>

801065c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801065c8:	6a 00                	push   $0x0
  pushl $41
801065ca:	6a 29                	push   $0x29
  jmp alltraps
801065cc:	e9 99 f7 ff ff       	jmp    80105d6a <alltraps>

801065d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801065d1:	6a 00                	push   $0x0
  pushl $42
801065d3:	6a 2a                	push   $0x2a
  jmp alltraps
801065d5:	e9 90 f7 ff ff       	jmp    80105d6a <alltraps>

801065da <vector43>:
.globl vector43
vector43:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $43
801065dc:	6a 2b                	push   $0x2b
  jmp alltraps
801065de:	e9 87 f7 ff ff       	jmp    80105d6a <alltraps>

801065e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $44
801065e5:	6a 2c                	push   $0x2c
  jmp alltraps
801065e7:	e9 7e f7 ff ff       	jmp    80105d6a <alltraps>

801065ec <vector45>:
.globl vector45
vector45:
  pushl $0
801065ec:	6a 00                	push   $0x0
  pushl $45
801065ee:	6a 2d                	push   $0x2d
  jmp alltraps
801065f0:	e9 75 f7 ff ff       	jmp    80105d6a <alltraps>

801065f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801065f5:	6a 00                	push   $0x0
  pushl $46
801065f7:	6a 2e                	push   $0x2e
  jmp alltraps
801065f9:	e9 6c f7 ff ff       	jmp    80105d6a <alltraps>

801065fe <vector47>:
.globl vector47
vector47:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $47
80106600:	6a 2f                	push   $0x2f
  jmp alltraps
80106602:	e9 63 f7 ff ff       	jmp    80105d6a <alltraps>

80106607 <vector48>:
.globl vector48
vector48:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $48
80106609:	6a 30                	push   $0x30
  jmp alltraps
8010660b:	e9 5a f7 ff ff       	jmp    80105d6a <alltraps>

80106610 <vector49>:
.globl vector49
vector49:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $49
80106612:	6a 31                	push   $0x31
  jmp alltraps
80106614:	e9 51 f7 ff ff       	jmp    80105d6a <alltraps>

80106619 <vector50>:
.globl vector50
vector50:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $50
8010661b:	6a 32                	push   $0x32
  jmp alltraps
8010661d:	e9 48 f7 ff ff       	jmp    80105d6a <alltraps>

80106622 <vector51>:
.globl vector51
vector51:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $51
80106624:	6a 33                	push   $0x33
  jmp alltraps
80106626:	e9 3f f7 ff ff       	jmp    80105d6a <alltraps>

8010662b <vector52>:
.globl vector52
vector52:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $52
8010662d:	6a 34                	push   $0x34
  jmp alltraps
8010662f:	e9 36 f7 ff ff       	jmp    80105d6a <alltraps>

80106634 <vector53>:
.globl vector53
vector53:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $53
80106636:	6a 35                	push   $0x35
  jmp alltraps
80106638:	e9 2d f7 ff ff       	jmp    80105d6a <alltraps>

8010663d <vector54>:
.globl vector54
vector54:
  pushl $0
8010663d:	6a 00                	push   $0x0
  pushl $54
8010663f:	6a 36                	push   $0x36
  jmp alltraps
80106641:	e9 24 f7 ff ff       	jmp    80105d6a <alltraps>

80106646 <vector55>:
.globl vector55
vector55:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $55
80106648:	6a 37                	push   $0x37
  jmp alltraps
8010664a:	e9 1b f7 ff ff       	jmp    80105d6a <alltraps>

8010664f <vector56>:
.globl vector56
vector56:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $56
80106651:	6a 38                	push   $0x38
  jmp alltraps
80106653:	e9 12 f7 ff ff       	jmp    80105d6a <alltraps>

80106658 <vector57>:
.globl vector57
vector57:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $57
8010665a:	6a 39                	push   $0x39
  jmp alltraps
8010665c:	e9 09 f7 ff ff       	jmp    80105d6a <alltraps>

80106661 <vector58>:
.globl vector58
vector58:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $58
80106663:	6a 3a                	push   $0x3a
  jmp alltraps
80106665:	e9 00 f7 ff ff       	jmp    80105d6a <alltraps>

8010666a <vector59>:
.globl vector59
vector59:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $59
8010666c:	6a 3b                	push   $0x3b
  jmp alltraps
8010666e:	e9 f7 f6 ff ff       	jmp    80105d6a <alltraps>

80106673 <vector60>:
.globl vector60
vector60:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $60
80106675:	6a 3c                	push   $0x3c
  jmp alltraps
80106677:	e9 ee f6 ff ff       	jmp    80105d6a <alltraps>

8010667c <vector61>:
.globl vector61
vector61:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $61
8010667e:	6a 3d                	push   $0x3d
  jmp alltraps
80106680:	e9 e5 f6 ff ff       	jmp    80105d6a <alltraps>

80106685 <vector62>:
.globl vector62
vector62:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $62
80106687:	6a 3e                	push   $0x3e
  jmp alltraps
80106689:	e9 dc f6 ff ff       	jmp    80105d6a <alltraps>

8010668e <vector63>:
.globl vector63
vector63:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $63
80106690:	6a 3f                	push   $0x3f
  jmp alltraps
80106692:	e9 d3 f6 ff ff       	jmp    80105d6a <alltraps>

80106697 <vector64>:
.globl vector64
vector64:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $64
80106699:	6a 40                	push   $0x40
  jmp alltraps
8010669b:	e9 ca f6 ff ff       	jmp    80105d6a <alltraps>

801066a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $65
801066a2:	6a 41                	push   $0x41
  jmp alltraps
801066a4:	e9 c1 f6 ff ff       	jmp    80105d6a <alltraps>

801066a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $66
801066ab:	6a 42                	push   $0x42
  jmp alltraps
801066ad:	e9 b8 f6 ff ff       	jmp    80105d6a <alltraps>

801066b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $67
801066b4:	6a 43                	push   $0x43
  jmp alltraps
801066b6:	e9 af f6 ff ff       	jmp    80105d6a <alltraps>

801066bb <vector68>:
.globl vector68
vector68:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $68
801066bd:	6a 44                	push   $0x44
  jmp alltraps
801066bf:	e9 a6 f6 ff ff       	jmp    80105d6a <alltraps>

801066c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $69
801066c6:	6a 45                	push   $0x45
  jmp alltraps
801066c8:	e9 9d f6 ff ff       	jmp    80105d6a <alltraps>

801066cd <vector70>:
.globl vector70
vector70:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $70
801066cf:	6a 46                	push   $0x46
  jmp alltraps
801066d1:	e9 94 f6 ff ff       	jmp    80105d6a <alltraps>

801066d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $71
801066d8:	6a 47                	push   $0x47
  jmp alltraps
801066da:	e9 8b f6 ff ff       	jmp    80105d6a <alltraps>

801066df <vector72>:
.globl vector72
vector72:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $72
801066e1:	6a 48                	push   $0x48
  jmp alltraps
801066e3:	e9 82 f6 ff ff       	jmp    80105d6a <alltraps>

801066e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $73
801066ea:	6a 49                	push   $0x49
  jmp alltraps
801066ec:	e9 79 f6 ff ff       	jmp    80105d6a <alltraps>

801066f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $74
801066f3:	6a 4a                	push   $0x4a
  jmp alltraps
801066f5:	e9 70 f6 ff ff       	jmp    80105d6a <alltraps>

801066fa <vector75>:
.globl vector75
vector75:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $75
801066fc:	6a 4b                	push   $0x4b
  jmp alltraps
801066fe:	e9 67 f6 ff ff       	jmp    80105d6a <alltraps>

80106703 <vector76>:
.globl vector76
vector76:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $76
80106705:	6a 4c                	push   $0x4c
  jmp alltraps
80106707:	e9 5e f6 ff ff       	jmp    80105d6a <alltraps>

8010670c <vector77>:
.globl vector77
vector77:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $77
8010670e:	6a 4d                	push   $0x4d
  jmp alltraps
80106710:	e9 55 f6 ff ff       	jmp    80105d6a <alltraps>

80106715 <vector78>:
.globl vector78
vector78:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $78
80106717:	6a 4e                	push   $0x4e
  jmp alltraps
80106719:	e9 4c f6 ff ff       	jmp    80105d6a <alltraps>

8010671e <vector79>:
.globl vector79
vector79:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $79
80106720:	6a 4f                	push   $0x4f
  jmp alltraps
80106722:	e9 43 f6 ff ff       	jmp    80105d6a <alltraps>

80106727 <vector80>:
.globl vector80
vector80:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $80
80106729:	6a 50                	push   $0x50
  jmp alltraps
8010672b:	e9 3a f6 ff ff       	jmp    80105d6a <alltraps>

80106730 <vector81>:
.globl vector81
vector81:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $81
80106732:	6a 51                	push   $0x51
  jmp alltraps
80106734:	e9 31 f6 ff ff       	jmp    80105d6a <alltraps>

80106739 <vector82>:
.globl vector82
vector82:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $82
8010673b:	6a 52                	push   $0x52
  jmp alltraps
8010673d:	e9 28 f6 ff ff       	jmp    80105d6a <alltraps>

80106742 <vector83>:
.globl vector83
vector83:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $83
80106744:	6a 53                	push   $0x53
  jmp alltraps
80106746:	e9 1f f6 ff ff       	jmp    80105d6a <alltraps>

8010674b <vector84>:
.globl vector84
vector84:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $84
8010674d:	6a 54                	push   $0x54
  jmp alltraps
8010674f:	e9 16 f6 ff ff       	jmp    80105d6a <alltraps>

80106754 <vector85>:
.globl vector85
vector85:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $85
80106756:	6a 55                	push   $0x55
  jmp alltraps
80106758:	e9 0d f6 ff ff       	jmp    80105d6a <alltraps>

8010675d <vector86>:
.globl vector86
vector86:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $86
8010675f:	6a 56                	push   $0x56
  jmp alltraps
80106761:	e9 04 f6 ff ff       	jmp    80105d6a <alltraps>

80106766 <vector87>:
.globl vector87
vector87:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $87
80106768:	6a 57                	push   $0x57
  jmp alltraps
8010676a:	e9 fb f5 ff ff       	jmp    80105d6a <alltraps>

8010676f <vector88>:
.globl vector88
vector88:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $88
80106771:	6a 58                	push   $0x58
  jmp alltraps
80106773:	e9 f2 f5 ff ff       	jmp    80105d6a <alltraps>

80106778 <vector89>:
.globl vector89
vector89:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $89
8010677a:	6a 59                	push   $0x59
  jmp alltraps
8010677c:	e9 e9 f5 ff ff       	jmp    80105d6a <alltraps>

80106781 <vector90>:
.globl vector90
vector90:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $90
80106783:	6a 5a                	push   $0x5a
  jmp alltraps
80106785:	e9 e0 f5 ff ff       	jmp    80105d6a <alltraps>

8010678a <vector91>:
.globl vector91
vector91:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $91
8010678c:	6a 5b                	push   $0x5b
  jmp alltraps
8010678e:	e9 d7 f5 ff ff       	jmp    80105d6a <alltraps>

80106793 <vector92>:
.globl vector92
vector92:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $92
80106795:	6a 5c                	push   $0x5c
  jmp alltraps
80106797:	e9 ce f5 ff ff       	jmp    80105d6a <alltraps>

8010679c <vector93>:
.globl vector93
vector93:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $93
8010679e:	6a 5d                	push   $0x5d
  jmp alltraps
801067a0:	e9 c5 f5 ff ff       	jmp    80105d6a <alltraps>

801067a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $94
801067a7:	6a 5e                	push   $0x5e
  jmp alltraps
801067a9:	e9 bc f5 ff ff       	jmp    80105d6a <alltraps>

801067ae <vector95>:
.globl vector95
vector95:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $95
801067b0:	6a 5f                	push   $0x5f
  jmp alltraps
801067b2:	e9 b3 f5 ff ff       	jmp    80105d6a <alltraps>

801067b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $96
801067b9:	6a 60                	push   $0x60
  jmp alltraps
801067bb:	e9 aa f5 ff ff       	jmp    80105d6a <alltraps>

801067c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $97
801067c2:	6a 61                	push   $0x61
  jmp alltraps
801067c4:	e9 a1 f5 ff ff       	jmp    80105d6a <alltraps>

801067c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $98
801067cb:	6a 62                	push   $0x62
  jmp alltraps
801067cd:	e9 98 f5 ff ff       	jmp    80105d6a <alltraps>

801067d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $99
801067d4:	6a 63                	push   $0x63
  jmp alltraps
801067d6:	e9 8f f5 ff ff       	jmp    80105d6a <alltraps>

801067db <vector100>:
.globl vector100
vector100:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $100
801067dd:	6a 64                	push   $0x64
  jmp alltraps
801067df:	e9 86 f5 ff ff       	jmp    80105d6a <alltraps>

801067e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $101
801067e6:	6a 65                	push   $0x65
  jmp alltraps
801067e8:	e9 7d f5 ff ff       	jmp    80105d6a <alltraps>

801067ed <vector102>:
.globl vector102
vector102:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $102
801067ef:	6a 66                	push   $0x66
  jmp alltraps
801067f1:	e9 74 f5 ff ff       	jmp    80105d6a <alltraps>

801067f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $103
801067f8:	6a 67                	push   $0x67
  jmp alltraps
801067fa:	e9 6b f5 ff ff       	jmp    80105d6a <alltraps>

801067ff <vector104>:
.globl vector104
vector104:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $104
80106801:	6a 68                	push   $0x68
  jmp alltraps
80106803:	e9 62 f5 ff ff       	jmp    80105d6a <alltraps>

80106808 <vector105>:
.globl vector105
vector105:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $105
8010680a:	6a 69                	push   $0x69
  jmp alltraps
8010680c:	e9 59 f5 ff ff       	jmp    80105d6a <alltraps>

80106811 <vector106>:
.globl vector106
vector106:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $106
80106813:	6a 6a                	push   $0x6a
  jmp alltraps
80106815:	e9 50 f5 ff ff       	jmp    80105d6a <alltraps>

8010681a <vector107>:
.globl vector107
vector107:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $107
8010681c:	6a 6b                	push   $0x6b
  jmp alltraps
8010681e:	e9 47 f5 ff ff       	jmp    80105d6a <alltraps>

80106823 <vector108>:
.globl vector108
vector108:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $108
80106825:	6a 6c                	push   $0x6c
  jmp alltraps
80106827:	e9 3e f5 ff ff       	jmp    80105d6a <alltraps>

8010682c <vector109>:
.globl vector109
vector109:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $109
8010682e:	6a 6d                	push   $0x6d
  jmp alltraps
80106830:	e9 35 f5 ff ff       	jmp    80105d6a <alltraps>

80106835 <vector110>:
.globl vector110
vector110:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $110
80106837:	6a 6e                	push   $0x6e
  jmp alltraps
80106839:	e9 2c f5 ff ff       	jmp    80105d6a <alltraps>

8010683e <vector111>:
.globl vector111
vector111:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $111
80106840:	6a 6f                	push   $0x6f
  jmp alltraps
80106842:	e9 23 f5 ff ff       	jmp    80105d6a <alltraps>

80106847 <vector112>:
.globl vector112
vector112:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $112
80106849:	6a 70                	push   $0x70
  jmp alltraps
8010684b:	e9 1a f5 ff ff       	jmp    80105d6a <alltraps>

80106850 <vector113>:
.globl vector113
vector113:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $113
80106852:	6a 71                	push   $0x71
  jmp alltraps
80106854:	e9 11 f5 ff ff       	jmp    80105d6a <alltraps>

80106859 <vector114>:
.globl vector114
vector114:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $114
8010685b:	6a 72                	push   $0x72
  jmp alltraps
8010685d:	e9 08 f5 ff ff       	jmp    80105d6a <alltraps>

80106862 <vector115>:
.globl vector115
vector115:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $115
80106864:	6a 73                	push   $0x73
  jmp alltraps
80106866:	e9 ff f4 ff ff       	jmp    80105d6a <alltraps>

8010686b <vector116>:
.globl vector116
vector116:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $116
8010686d:	6a 74                	push   $0x74
  jmp alltraps
8010686f:	e9 f6 f4 ff ff       	jmp    80105d6a <alltraps>

80106874 <vector117>:
.globl vector117
vector117:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $117
80106876:	6a 75                	push   $0x75
  jmp alltraps
80106878:	e9 ed f4 ff ff       	jmp    80105d6a <alltraps>

8010687d <vector118>:
.globl vector118
vector118:
  pushl $0
8010687d:	6a 00                	push   $0x0
  pushl $118
8010687f:	6a 76                	push   $0x76
  jmp alltraps
80106881:	e9 e4 f4 ff ff       	jmp    80105d6a <alltraps>

80106886 <vector119>:
.globl vector119
vector119:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $119
80106888:	6a 77                	push   $0x77
  jmp alltraps
8010688a:	e9 db f4 ff ff       	jmp    80105d6a <alltraps>

8010688f <vector120>:
.globl vector120
vector120:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $120
80106891:	6a 78                	push   $0x78
  jmp alltraps
80106893:	e9 d2 f4 ff ff       	jmp    80105d6a <alltraps>

80106898 <vector121>:
.globl vector121
vector121:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $121
8010689a:	6a 79                	push   $0x79
  jmp alltraps
8010689c:	e9 c9 f4 ff ff       	jmp    80105d6a <alltraps>

801068a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $122
801068a3:	6a 7a                	push   $0x7a
  jmp alltraps
801068a5:	e9 c0 f4 ff ff       	jmp    80105d6a <alltraps>

801068aa <vector123>:
.globl vector123
vector123:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $123
801068ac:	6a 7b                	push   $0x7b
  jmp alltraps
801068ae:	e9 b7 f4 ff ff       	jmp    80105d6a <alltraps>

801068b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $124
801068b5:	6a 7c                	push   $0x7c
  jmp alltraps
801068b7:	e9 ae f4 ff ff       	jmp    80105d6a <alltraps>

801068bc <vector125>:
.globl vector125
vector125:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $125
801068be:	6a 7d                	push   $0x7d
  jmp alltraps
801068c0:	e9 a5 f4 ff ff       	jmp    80105d6a <alltraps>

801068c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $126
801068c7:	6a 7e                	push   $0x7e
  jmp alltraps
801068c9:	e9 9c f4 ff ff       	jmp    80105d6a <alltraps>

801068ce <vector127>:
.globl vector127
vector127:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $127
801068d0:	6a 7f                	push   $0x7f
  jmp alltraps
801068d2:	e9 93 f4 ff ff       	jmp    80105d6a <alltraps>

801068d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $128
801068d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801068de:	e9 87 f4 ff ff       	jmp    80105d6a <alltraps>

801068e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $129
801068e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068ea:	e9 7b f4 ff ff       	jmp    80105d6a <alltraps>

801068ef <vector130>:
.globl vector130
vector130:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $130
801068f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068f6:	e9 6f f4 ff ff       	jmp    80105d6a <alltraps>

801068fb <vector131>:
.globl vector131
vector131:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $131
801068fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106902:	e9 63 f4 ff ff       	jmp    80105d6a <alltraps>

80106907 <vector132>:
.globl vector132
vector132:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $132
80106909:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010690e:	e9 57 f4 ff ff       	jmp    80105d6a <alltraps>

80106913 <vector133>:
.globl vector133
vector133:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $133
80106915:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010691a:	e9 4b f4 ff ff       	jmp    80105d6a <alltraps>

8010691f <vector134>:
.globl vector134
vector134:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $134
80106921:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106926:	e9 3f f4 ff ff       	jmp    80105d6a <alltraps>

8010692b <vector135>:
.globl vector135
vector135:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $135
8010692d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106932:	e9 33 f4 ff ff       	jmp    80105d6a <alltraps>

80106937 <vector136>:
.globl vector136
vector136:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $136
80106939:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010693e:	e9 27 f4 ff ff       	jmp    80105d6a <alltraps>

80106943 <vector137>:
.globl vector137
vector137:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $137
80106945:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010694a:	e9 1b f4 ff ff       	jmp    80105d6a <alltraps>

8010694f <vector138>:
.globl vector138
vector138:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $138
80106951:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106956:	e9 0f f4 ff ff       	jmp    80105d6a <alltraps>

8010695b <vector139>:
.globl vector139
vector139:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $139
8010695d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106962:	e9 03 f4 ff ff       	jmp    80105d6a <alltraps>

80106967 <vector140>:
.globl vector140
vector140:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $140
80106969:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010696e:	e9 f7 f3 ff ff       	jmp    80105d6a <alltraps>

80106973 <vector141>:
.globl vector141
vector141:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $141
80106975:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010697a:	e9 eb f3 ff ff       	jmp    80105d6a <alltraps>

8010697f <vector142>:
.globl vector142
vector142:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $142
80106981:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106986:	e9 df f3 ff ff       	jmp    80105d6a <alltraps>

8010698b <vector143>:
.globl vector143
vector143:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $143
8010698d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106992:	e9 d3 f3 ff ff       	jmp    80105d6a <alltraps>

80106997 <vector144>:
.globl vector144
vector144:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $144
80106999:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010699e:	e9 c7 f3 ff ff       	jmp    80105d6a <alltraps>

801069a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $145
801069a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801069aa:	e9 bb f3 ff ff       	jmp    80105d6a <alltraps>

801069af <vector146>:
.globl vector146
vector146:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $146
801069b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801069b6:	e9 af f3 ff ff       	jmp    80105d6a <alltraps>

801069bb <vector147>:
.globl vector147
vector147:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $147
801069bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801069c2:	e9 a3 f3 ff ff       	jmp    80105d6a <alltraps>

801069c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $148
801069c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801069ce:	e9 97 f3 ff ff       	jmp    80105d6a <alltraps>

801069d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $149
801069d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801069da:	e9 8b f3 ff ff       	jmp    80105d6a <alltraps>

801069df <vector150>:
.globl vector150
vector150:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $150
801069e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069e6:	e9 7f f3 ff ff       	jmp    80105d6a <alltraps>

801069eb <vector151>:
.globl vector151
vector151:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $151
801069ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069f2:	e9 73 f3 ff ff       	jmp    80105d6a <alltraps>

801069f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $152
801069f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069fe:	e9 67 f3 ff ff       	jmp    80105d6a <alltraps>

80106a03 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $153
80106a05:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a0a:	e9 5b f3 ff ff       	jmp    80105d6a <alltraps>

80106a0f <vector154>:
.globl vector154
vector154:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $154
80106a11:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a16:	e9 4f f3 ff ff       	jmp    80105d6a <alltraps>

80106a1b <vector155>:
.globl vector155
vector155:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $155
80106a1d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a22:	e9 43 f3 ff ff       	jmp    80105d6a <alltraps>

80106a27 <vector156>:
.globl vector156
vector156:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $156
80106a29:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a2e:	e9 37 f3 ff ff       	jmp    80105d6a <alltraps>

80106a33 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $157
80106a35:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a3a:	e9 2b f3 ff ff       	jmp    80105d6a <alltraps>

80106a3f <vector158>:
.globl vector158
vector158:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $158
80106a41:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a46:	e9 1f f3 ff ff       	jmp    80105d6a <alltraps>

80106a4b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $159
80106a4d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a52:	e9 13 f3 ff ff       	jmp    80105d6a <alltraps>

80106a57 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $160
80106a59:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a5e:	e9 07 f3 ff ff       	jmp    80105d6a <alltraps>

80106a63 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $161
80106a65:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a6a:	e9 fb f2 ff ff       	jmp    80105d6a <alltraps>

80106a6f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $162
80106a71:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a76:	e9 ef f2 ff ff       	jmp    80105d6a <alltraps>

80106a7b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $163
80106a7d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a82:	e9 e3 f2 ff ff       	jmp    80105d6a <alltraps>

80106a87 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $164
80106a89:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a8e:	e9 d7 f2 ff ff       	jmp    80105d6a <alltraps>

80106a93 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $165
80106a95:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a9a:	e9 cb f2 ff ff       	jmp    80105d6a <alltraps>

80106a9f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $166
80106aa1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106aa6:	e9 bf f2 ff ff       	jmp    80105d6a <alltraps>

80106aab <vector167>:
.globl vector167
vector167:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $167
80106aad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ab2:	e9 b3 f2 ff ff       	jmp    80105d6a <alltraps>

80106ab7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $168
80106ab9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106abe:	e9 a7 f2 ff ff       	jmp    80105d6a <alltraps>

80106ac3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $169
80106ac5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106aca:	e9 9b f2 ff ff       	jmp    80105d6a <alltraps>

80106acf <vector170>:
.globl vector170
vector170:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $170
80106ad1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ad6:	e9 8f f2 ff ff       	jmp    80105d6a <alltraps>

80106adb <vector171>:
.globl vector171
vector171:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $171
80106add:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ae2:	e9 83 f2 ff ff       	jmp    80105d6a <alltraps>

80106ae7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $172
80106ae9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106aee:	e9 77 f2 ff ff       	jmp    80105d6a <alltraps>

80106af3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $173
80106af5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106afa:	e9 6b f2 ff ff       	jmp    80105d6a <alltraps>

80106aff <vector174>:
.globl vector174
vector174:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $174
80106b01:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b06:	e9 5f f2 ff ff       	jmp    80105d6a <alltraps>

80106b0b <vector175>:
.globl vector175
vector175:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $175
80106b0d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b12:	e9 53 f2 ff ff       	jmp    80105d6a <alltraps>

80106b17 <vector176>:
.globl vector176
vector176:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $176
80106b19:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b1e:	e9 47 f2 ff ff       	jmp    80105d6a <alltraps>

80106b23 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $177
80106b25:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b2a:	e9 3b f2 ff ff       	jmp    80105d6a <alltraps>

80106b2f <vector178>:
.globl vector178
vector178:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $178
80106b31:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b36:	e9 2f f2 ff ff       	jmp    80105d6a <alltraps>

80106b3b <vector179>:
.globl vector179
vector179:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $179
80106b3d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b42:	e9 23 f2 ff ff       	jmp    80105d6a <alltraps>

80106b47 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $180
80106b49:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b4e:	e9 17 f2 ff ff       	jmp    80105d6a <alltraps>

80106b53 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $181
80106b55:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b5a:	e9 0b f2 ff ff       	jmp    80105d6a <alltraps>

80106b5f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $182
80106b61:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b66:	e9 ff f1 ff ff       	jmp    80105d6a <alltraps>

80106b6b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $183
80106b6d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b72:	e9 f3 f1 ff ff       	jmp    80105d6a <alltraps>

80106b77 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $184
80106b79:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b7e:	e9 e7 f1 ff ff       	jmp    80105d6a <alltraps>

80106b83 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $185
80106b85:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b8a:	e9 db f1 ff ff       	jmp    80105d6a <alltraps>

80106b8f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $186
80106b91:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b96:	e9 cf f1 ff ff       	jmp    80105d6a <alltraps>

80106b9b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $187
80106b9d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ba2:	e9 c3 f1 ff ff       	jmp    80105d6a <alltraps>

80106ba7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $188
80106ba9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106bae:	e9 b7 f1 ff ff       	jmp    80105d6a <alltraps>

80106bb3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $189
80106bb5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106bba:	e9 ab f1 ff ff       	jmp    80105d6a <alltraps>

80106bbf <vector190>:
.globl vector190
vector190:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $190
80106bc1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106bc6:	e9 9f f1 ff ff       	jmp    80105d6a <alltraps>

80106bcb <vector191>:
.globl vector191
vector191:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $191
80106bcd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106bd2:	e9 93 f1 ff ff       	jmp    80105d6a <alltraps>

80106bd7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $192
80106bd9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106bde:	e9 87 f1 ff ff       	jmp    80105d6a <alltraps>

80106be3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $193
80106be5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106bea:	e9 7b f1 ff ff       	jmp    80105d6a <alltraps>

80106bef <vector194>:
.globl vector194
vector194:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $194
80106bf1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106bf6:	e9 6f f1 ff ff       	jmp    80105d6a <alltraps>

80106bfb <vector195>:
.globl vector195
vector195:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $195
80106bfd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c02:	e9 63 f1 ff ff       	jmp    80105d6a <alltraps>

80106c07 <vector196>:
.globl vector196
vector196:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $196
80106c09:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c0e:	e9 57 f1 ff ff       	jmp    80105d6a <alltraps>

80106c13 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $197
80106c15:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c1a:	e9 4b f1 ff ff       	jmp    80105d6a <alltraps>

80106c1f <vector198>:
.globl vector198
vector198:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $198
80106c21:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c26:	e9 3f f1 ff ff       	jmp    80105d6a <alltraps>

80106c2b <vector199>:
.globl vector199
vector199:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $199
80106c2d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c32:	e9 33 f1 ff ff       	jmp    80105d6a <alltraps>

80106c37 <vector200>:
.globl vector200
vector200:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $200
80106c39:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c3e:	e9 27 f1 ff ff       	jmp    80105d6a <alltraps>

80106c43 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $201
80106c45:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c4a:	e9 1b f1 ff ff       	jmp    80105d6a <alltraps>

80106c4f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $202
80106c51:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c56:	e9 0f f1 ff ff       	jmp    80105d6a <alltraps>

80106c5b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $203
80106c5d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c62:	e9 03 f1 ff ff       	jmp    80105d6a <alltraps>

80106c67 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $204
80106c69:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c6e:	e9 f7 f0 ff ff       	jmp    80105d6a <alltraps>

80106c73 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $205
80106c75:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c7a:	e9 eb f0 ff ff       	jmp    80105d6a <alltraps>

80106c7f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $206
80106c81:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c86:	e9 df f0 ff ff       	jmp    80105d6a <alltraps>

80106c8b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $207
80106c8d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c92:	e9 d3 f0 ff ff       	jmp    80105d6a <alltraps>

80106c97 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $208
80106c99:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c9e:	e9 c7 f0 ff ff       	jmp    80105d6a <alltraps>

80106ca3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $209
80106ca5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106caa:	e9 bb f0 ff ff       	jmp    80105d6a <alltraps>

80106caf <vector210>:
.globl vector210
vector210:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $210
80106cb1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106cb6:	e9 af f0 ff ff       	jmp    80105d6a <alltraps>

80106cbb <vector211>:
.globl vector211
vector211:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $211
80106cbd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106cc2:	e9 a3 f0 ff ff       	jmp    80105d6a <alltraps>

80106cc7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $212
80106cc9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106cce:	e9 97 f0 ff ff       	jmp    80105d6a <alltraps>

80106cd3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $213
80106cd5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106cda:	e9 8b f0 ff ff       	jmp    80105d6a <alltraps>

80106cdf <vector214>:
.globl vector214
vector214:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $214
80106ce1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ce6:	e9 7f f0 ff ff       	jmp    80105d6a <alltraps>

80106ceb <vector215>:
.globl vector215
vector215:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $215
80106ced:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106cf2:	e9 73 f0 ff ff       	jmp    80105d6a <alltraps>

80106cf7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $216
80106cf9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cfe:	e9 67 f0 ff ff       	jmp    80105d6a <alltraps>

80106d03 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $217
80106d05:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d0a:	e9 5b f0 ff ff       	jmp    80105d6a <alltraps>

80106d0f <vector218>:
.globl vector218
vector218:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $218
80106d11:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d16:	e9 4f f0 ff ff       	jmp    80105d6a <alltraps>

80106d1b <vector219>:
.globl vector219
vector219:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $219
80106d1d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d22:	e9 43 f0 ff ff       	jmp    80105d6a <alltraps>

80106d27 <vector220>:
.globl vector220
vector220:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $220
80106d29:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d2e:	e9 37 f0 ff ff       	jmp    80105d6a <alltraps>

80106d33 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $221
80106d35:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d3a:	e9 2b f0 ff ff       	jmp    80105d6a <alltraps>

80106d3f <vector222>:
.globl vector222
vector222:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $222
80106d41:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d46:	e9 1f f0 ff ff       	jmp    80105d6a <alltraps>

80106d4b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $223
80106d4d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d52:	e9 13 f0 ff ff       	jmp    80105d6a <alltraps>

80106d57 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $224
80106d59:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d5e:	e9 07 f0 ff ff       	jmp    80105d6a <alltraps>

80106d63 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $225
80106d65:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d6a:	e9 fb ef ff ff       	jmp    80105d6a <alltraps>

80106d6f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $226
80106d71:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d76:	e9 ef ef ff ff       	jmp    80105d6a <alltraps>

80106d7b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $227
80106d7d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d82:	e9 e3 ef ff ff       	jmp    80105d6a <alltraps>

80106d87 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $228
80106d89:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d8e:	e9 d7 ef ff ff       	jmp    80105d6a <alltraps>

80106d93 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $229
80106d95:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d9a:	e9 cb ef ff ff       	jmp    80105d6a <alltraps>

80106d9f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $230
80106da1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106da6:	e9 bf ef ff ff       	jmp    80105d6a <alltraps>

80106dab <vector231>:
.globl vector231
vector231:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $231
80106dad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106db2:	e9 b3 ef ff ff       	jmp    80105d6a <alltraps>

80106db7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $232
80106db9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106dbe:	e9 a7 ef ff ff       	jmp    80105d6a <alltraps>

80106dc3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $233
80106dc5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106dca:	e9 9b ef ff ff       	jmp    80105d6a <alltraps>

80106dcf <vector234>:
.globl vector234
vector234:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $234
80106dd1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106dd6:	e9 8f ef ff ff       	jmp    80105d6a <alltraps>

80106ddb <vector235>:
.globl vector235
vector235:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $235
80106ddd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106de2:	e9 83 ef ff ff       	jmp    80105d6a <alltraps>

80106de7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $236
80106de9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106dee:	e9 77 ef ff ff       	jmp    80105d6a <alltraps>

80106df3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $237
80106df5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106dfa:	e9 6b ef ff ff       	jmp    80105d6a <alltraps>

80106dff <vector238>:
.globl vector238
vector238:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $238
80106e01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e06:	e9 5f ef ff ff       	jmp    80105d6a <alltraps>

80106e0b <vector239>:
.globl vector239
vector239:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $239
80106e0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e12:	e9 53 ef ff ff       	jmp    80105d6a <alltraps>

80106e17 <vector240>:
.globl vector240
vector240:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $240
80106e19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e1e:	e9 47 ef ff ff       	jmp    80105d6a <alltraps>

80106e23 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $241
80106e25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e2a:	e9 3b ef ff ff       	jmp    80105d6a <alltraps>

80106e2f <vector242>:
.globl vector242
vector242:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $242
80106e31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e36:	e9 2f ef ff ff       	jmp    80105d6a <alltraps>

80106e3b <vector243>:
.globl vector243
vector243:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $243
80106e3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e42:	e9 23 ef ff ff       	jmp    80105d6a <alltraps>

80106e47 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $244
80106e49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e4e:	e9 17 ef ff ff       	jmp    80105d6a <alltraps>

80106e53 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $245
80106e55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e5a:	e9 0b ef ff ff       	jmp    80105d6a <alltraps>

80106e5f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $246
80106e61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e66:	e9 ff ee ff ff       	jmp    80105d6a <alltraps>

80106e6b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $247
80106e6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e72:	e9 f3 ee ff ff       	jmp    80105d6a <alltraps>

80106e77 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $248
80106e79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e7e:	e9 e7 ee ff ff       	jmp    80105d6a <alltraps>

80106e83 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $249
80106e85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e8a:	e9 db ee ff ff       	jmp    80105d6a <alltraps>

80106e8f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $250
80106e91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e96:	e9 cf ee ff ff       	jmp    80105d6a <alltraps>

80106e9b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $251
80106e9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ea2:	e9 c3 ee ff ff       	jmp    80105d6a <alltraps>

80106ea7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $252
80106ea9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106eae:	e9 b7 ee ff ff       	jmp    80105d6a <alltraps>

80106eb3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $253
80106eb5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106eba:	e9 ab ee ff ff       	jmp    80105d6a <alltraps>

80106ebf <vector254>:
.globl vector254
vector254:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $254
80106ec1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ec6:	e9 9f ee ff ff       	jmp    80105d6a <alltraps>

80106ecb <vector255>:
.globl vector255
vector255:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $255
80106ecd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ed2:	e9 93 ee ff ff       	jmp    80105d6a <alltraps>
80106ed7:	66 90                	xchg   %ax,%ax
80106ed9:	66 90                	xchg   %ax,%ax
80106edb:	66 90                	xchg   %ax,%ax
80106edd:	66 90                	xchg   %ax,%ax
80106edf:	90                   	nop

80106ee0 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	53                   	push   %ebx
//    if (DEBUGMODE == 2&& notShell())
//        cprintf("WALKPGDIR-");
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80106ee6:	89 d3                	mov    %edx,%ebx
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106ee8:	89 d7                	mov    %edx,%edi
    pde = &pgdir[PDX(va)];
80106eea:	c1 eb 16             	shr    $0x16,%ebx
80106eed:	8d 34 98             	lea    (%eax,%ebx,4),%esi
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106ef0:	83 ec 0c             	sub    $0xc,%esp
    if (*pde & PTE_P) {
80106ef3:	8b 06                	mov    (%esi),%eax
80106ef5:	a8 01                	test   $0x1,%al
80106ef7:	74 27                	je     80106f20 <walkpgdir+0x40>
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
80106ef9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106efe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
//    if (DEBUGMODE == 2&& notShell())
//        cprintf(">WALKPGDIR-DONE!\t");
    return &pgtab[PTX(va)];
80106f04:	c1 ef 0a             	shr    $0xa,%edi
}
80106f07:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return &pgtab[PTX(va)];
80106f0a:	89 fa                	mov    %edi,%edx
80106f0c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106f12:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106f15:	5b                   	pop    %ebx
80106f16:	5e                   	pop    %esi
80106f17:	5f                   	pop    %edi
80106f18:	5d                   	pop    %ebp
80106f19:	c3                   	ret    
80106f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!alloc)
80106f20:	85 c9                	test   %ecx,%ecx
80106f22:	74 2c                	je     80106f50 <walkpgdir+0x70>
        if ((pgtab = (pte_t *) kalloc()) == 0)
80106f24:	e8 67 b9 ff ff       	call   80102890 <kalloc>
80106f29:	85 c0                	test   %eax,%eax
80106f2b:	89 c3                	mov    %eax,%ebx
80106f2d:	74 21                	je     80106f50 <walkpgdir+0x70>
        memset(pgtab, 0, PGSIZE);
80106f2f:	83 ec 04             	sub    $0x4,%esp
80106f32:	68 00 10 00 00       	push   $0x1000
80106f37:	6a 00                	push   $0x0
80106f39:	50                   	push   %eax
80106f3a:	e8 01 dc ff ff       	call   80104b40 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f3f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f45:	83 c4 10             	add    $0x10,%esp
80106f48:	83 c8 07             	or     $0x7,%eax
80106f4b:	89 06                	mov    %eax,(%esi)
80106f4d:	eb b5                	jmp    80106f04 <walkpgdir+0x24>
80106f4f:	90                   	nop
}
80106f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80106f53:	31 c0                	xor    %eax,%eax
}
80106f55:	5b                   	pop    %ebx
80106f56:	5e                   	pop    %esi
80106f57:	5f                   	pop    %edi
80106f58:	5d                   	pop    %ebp
80106f59:	c3                   	ret    
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f60 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
    char *a, *last;
    pte_t *pte;

    a = (char *) PGROUNDDOWN((uint) va);
80106f66:	89 d3                	mov    %edx,%ebx
80106f68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80106f6e:	83 ec 1c             	sub    $0x1c,%esp
80106f71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
80106f74:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f78:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f80:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
            panic("remap");
        *pte = pa | perm | PTE_P;
80106f83:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f86:	29 df                	sub    %ebx,%edi
80106f88:	83 c8 01             	or     $0x1,%eax
80106f8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f8e:	eb 15                	jmp    80106fa5 <mappages+0x45>
        if (*pte & PTE_P)
80106f90:	f6 00 01             	testb  $0x1,(%eax)
80106f93:	75 45                	jne    80106fda <mappages+0x7a>
        *pte = pa | perm | PTE_P;
80106f95:	0b 75 dc             	or     -0x24(%ebp),%esi
        if (a == last)
80106f98:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
        *pte = pa | perm | PTE_P;
80106f9b:	89 30                	mov    %esi,(%eax)
        if (a == last)
80106f9d:	74 31                	je     80106fd0 <mappages+0x70>
            break;
        a += PGSIZE;
80106f9f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
80106fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fa8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106fad:	89 da                	mov    %ebx,%edx
80106faf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106fb2:	e8 29 ff ff ff       	call   80106ee0 <walkpgdir>
80106fb7:	85 c0                	test   %eax,%eax
80106fb9:	75 d5                	jne    80106f90 <mappages+0x30>
        pa += PGSIZE;
    }
    return 0;
}
80106fbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80106fbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fc3:	5b                   	pop    %ebx
80106fc4:	5e                   	pop    %esi
80106fc5:	5f                   	pop    %edi
80106fc6:	5d                   	pop    %ebp
80106fc7:	c3                   	ret    
80106fc8:	90                   	nop
80106fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106fd3:	31 c0                	xor    %eax,%eax
}
80106fd5:	5b                   	pop    %ebx
80106fd6:	5e                   	pop    %esi
80106fd7:	5f                   	pop    %edi
80106fd8:	5d                   	pop    %ebp
80106fd9:	c3                   	ret    
            panic("remap");
80106fda:	83 ec 0c             	sub    $0xc,%esp
80106fdd:	68 84 85 10 80       	push   $0x80108584
80106fe2:	e8 a9 93 ff ff       	call   80100390 <panic>
80106fe7:	89 f6                	mov    %esi,%esi
80106fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ff0 <seginit>:
seginit(void) {
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
80106ff6:	e8 45 cc ff ff       	call   80103c40 <cpuid>
80106ffb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107001:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107006:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010700a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107011:	ff 00 00 
80107014:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010701b:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010701e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107025:	ff 00 00 
80107028:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
8010702f:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80107032:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80107039:	ff 00 00 
8010703c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107043:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107046:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
8010704d:	ff 00 00 
80107050:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80107057:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
8010705a:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
8010705f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107063:	c1 e8 10             	shr    $0x10,%eax
80107066:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010706a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010706d:	0f 01 10             	lgdtl  (%eax)
}
80107070:	c9                   	leave  
80107071:	c3                   	ret    
80107072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107080 <walkpgdir2>:
walkpgdir2(pde_t *pgdir, const void *va, int alloc) {
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
    return walkpgdir(pgdir, va, alloc);
80107083:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107086:	8b 55 0c             	mov    0xc(%ebp),%edx
80107089:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010708c:	5d                   	pop    %ebp
    return walkpgdir(pgdir, va, alloc);
8010708d:	e9 4e fe ff ff       	jmp    80106ee0 <walkpgdir>
80107092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070a0 <mappages2>:

// global use for mappages
int
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
    return mappages(pgdir, va, size, pa, perm);
801070a3:	8b 4d 18             	mov    0x18(%ebp),%ecx
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801070a6:	8b 55 0c             	mov    0xc(%ebp),%edx
801070a9:	8b 45 08             	mov    0x8(%ebp),%eax
    return mappages(pgdir, va, size, pa, perm);
801070ac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801070af:	8b 4d 14             	mov    0x14(%ebp),%ecx
801070b2:	89 4d 08             	mov    %ecx,0x8(%ebp)
801070b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
801070b8:	5d                   	pop    %ebp
    return mappages(pgdir, va, size, pa, perm);
801070b9:	e9 a2 fe ff ff       	jmp    80106f60 <mappages>
801070be:	66 90                	xchg   %ax,%ax

801070c0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void) {
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801070c0:	a1 c8 5b 12 80       	mov    0x80125bc8,%eax
switchkvm(void) {
801070c5:	55                   	push   %ebp
801070c6:	89 e5                	mov    %esp,%ebp
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801070c8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070cd:	0f 22 d8             	mov    %eax,%cr3
}
801070d0:	5d                   	pop    %ebp
801070d1:	c3                   	ret    
801070d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070e0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p) {
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (p == 0)
801070ec:	85 db                	test   %ebx,%ebx
801070ee:	0f 84 cb 00 00 00    	je     801071bf <switchuvm+0xdf>
        panic("switchuvm: no process");
    if (p->kstack == 0)
801070f4:	8b 43 08             	mov    0x8(%ebx),%eax
801070f7:	85 c0                	test   %eax,%eax
801070f9:	0f 84 da 00 00 00    	je     801071d9 <switchuvm+0xf9>
        panic("switchuvm: no kstack");
    if (p->pgdir == 0)
801070ff:	8b 43 04             	mov    0x4(%ebx),%eax
80107102:	85 c0                	test   %eax,%eax
80107104:	0f 84 c2 00 00 00    	je     801071cc <switchuvm+0xec>
        panic("switchuvm: no pgdir");

    pushcli();
8010710a:	e8 71 d8 ff ff       	call   80104980 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010710f:	e8 ac ca ff ff       	call   80103bc0 <mycpu>
80107114:	89 c6                	mov    %eax,%esi
80107116:	e8 a5 ca ff ff       	call   80103bc0 <mycpu>
8010711b:	89 c7                	mov    %eax,%edi
8010711d:	e8 9e ca ff ff       	call   80103bc0 <mycpu>
80107122:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107125:	83 c7 08             	add    $0x8,%edi
80107128:	e8 93 ca ff ff       	call   80103bc0 <mycpu>
8010712d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107130:	83 c0 08             	add    $0x8,%eax
80107133:	ba 67 00 00 00       	mov    $0x67,%edx
80107138:	c1 e8 18             	shr    $0x18,%eax
8010713b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107142:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107149:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
    mycpu()->gdt[SEG_TSS].s = 0;
    mycpu()->ts.ss0 = SEG_KDATA << 3;
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    mycpu()->ts.iomb = (ushort) 0xFFFF;
8010714f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107154:	83 c1 08             	add    $0x8,%ecx
80107157:	c1 e9 10             	shr    $0x10,%ecx
8010715a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107160:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107165:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
8010716c:	be 10 00 00 00       	mov    $0x10,%esi
    mycpu()->gdt[SEG_TSS].s = 0;
80107171:	e8 4a ca ff ff       	call   80103bc0 <mycpu>
80107176:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
8010717d:	e8 3e ca ff ff       	call   80103bc0 <mycpu>
80107182:	66 89 70 10          	mov    %si,0x10(%eax)
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
80107186:	8b 73 08             	mov    0x8(%ebx),%esi
80107189:	e8 32 ca ff ff       	call   80103bc0 <mycpu>
8010718e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107194:	89 70 0c             	mov    %esi,0xc(%eax)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80107197:	e8 24 ca ff ff       	call   80103bc0 <mycpu>
8010719c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801071a0:	b8 28 00 00 00       	mov    $0x28,%eax
801071a5:	0f 00 d8             	ltr    %ax
    ltr(SEG_TSS << 3);
    lcr3(V2P(p->pgdir));  // switch to process's address space
801071a8:	8b 43 04             	mov    0x4(%ebx),%eax
801071ab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071b0:	0f 22 d8             	mov    %eax,%cr3
    popcli();
}
801071b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071b6:	5b                   	pop    %ebx
801071b7:	5e                   	pop    %esi
801071b8:	5f                   	pop    %edi
801071b9:	5d                   	pop    %ebp
    popcli();
801071ba:	e9 c1 d8 ff ff       	jmp    80104a80 <popcli>
        panic("switchuvm: no process");
801071bf:	83 ec 0c             	sub    $0xc,%esp
801071c2:	68 8a 85 10 80       	push   $0x8010858a
801071c7:	e8 c4 91 ff ff       	call   80100390 <panic>
        panic("switchuvm: no pgdir");
801071cc:	83 ec 0c             	sub    $0xc,%esp
801071cf:	68 b5 85 10 80       	push   $0x801085b5
801071d4:	e8 b7 91 ff ff       	call   80100390 <panic>
        panic("switchuvm: no kstack");
801071d9:	83 ec 0c             	sub    $0xc,%esp
801071dc:	68 a0 85 10 80       	push   $0x801085a0
801071e1:	e8 aa 91 ff ff       	call   80100390 <panic>
801071e6:	8d 76 00             	lea    0x0(%esi),%esi
801071e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071f0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz) {
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 1c             	sub    $0x1c,%esp
801071f9:	8b 75 10             	mov    0x10(%ebp),%esi
801071fc:	8b 45 08             	mov    0x8(%ebp),%eax
801071ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
    char *mem;

    if (sz >= PGSIZE)
80107202:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
inituvm(pde_t *pgdir, char *init, uint sz) {
80107208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE)
8010720b:	77 49                	ja     80107256 <inituvm+0x66>
        panic("inituvm: more than a page");
    mem = kalloc();
8010720d:	e8 7e b6 ff ff       	call   80102890 <kalloc>
    memset(mem, 0, PGSIZE);
80107212:	83 ec 04             	sub    $0x4,%esp
    mem = kalloc();
80107215:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80107217:	68 00 10 00 00       	push   $0x1000
8010721c:	6a 00                	push   $0x0
8010721e:	50                   	push   %eax
8010721f:	e8 1c d9 ff ff       	call   80104b40 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107224:	58                   	pop    %eax
80107225:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010722b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107230:	5a                   	pop    %edx
80107231:	6a 06                	push   $0x6
80107233:	50                   	push   %eax
80107234:	31 d2                	xor    %edx,%edx
80107236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107239:	e8 22 fd ff ff       	call   80106f60 <mappages>
    memmove(mem, init, sz);
8010723e:	89 75 10             	mov    %esi,0x10(%ebp)
80107241:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107244:	83 c4 10             	add    $0x10,%esp
80107247:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010724a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010724d:	5b                   	pop    %ebx
8010724e:	5e                   	pop    %esi
8010724f:	5f                   	pop    %edi
80107250:	5d                   	pop    %ebp
    memmove(mem, init, sz);
80107251:	e9 9a d9 ff ff       	jmp    80104bf0 <memmove>
        panic("inituvm: more than a page");
80107256:	83 ec 0c             	sub    $0xc,%esp
80107259:	68 c9 85 10 80       	push   $0x801085c9
8010725e:	e8 2d 91 ff ff       	call   80100390 <panic>
80107263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107270 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 0c             	sub    $0xc,%esp
    uint i, pa, n;
    pte_t *pte;

    if ((uint) addr % PGSIZE != 0)
80107279:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107280:	0f 85 91 00 00 00    	jne    80107317 <loaduvm+0xa7>
        panic("loaduvm: addr must be page aligned");
    for (i = 0; i < sz; i += PGSIZE) {
80107286:	8b 75 18             	mov    0x18(%ebp),%esi
80107289:	31 db                	xor    %ebx,%ebx
8010728b:	85 f6                	test   %esi,%esi
8010728d:	75 1a                	jne    801072a9 <loaduvm+0x39>
8010728f:	eb 6f                	jmp    80107300 <loaduvm+0x90>
80107291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107298:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010729e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801072a4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801072a7:	76 57                	jbe    80107300 <loaduvm+0x90>
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
801072a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801072ac:	8b 45 08             	mov    0x8(%ebp),%eax
801072af:	31 c9                	xor    %ecx,%ecx
801072b1:	01 da                	add    %ebx,%edx
801072b3:	e8 28 fc ff ff       	call   80106ee0 <walkpgdir>
801072b8:	85 c0                	test   %eax,%eax
801072ba:	74 4e                	je     8010730a <loaduvm+0x9a>
            panic("loaduvm: address should exist");
        pa = PTE_ADDR(*pte);
801072bc:	8b 00                	mov    (%eax),%eax
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, P2V(pa), offset + i, n) != n)
801072be:	8b 4d 14             	mov    0x14(%ebp),%ecx
        if (sz - i < PGSIZE)
801072c1:	bf 00 10 00 00       	mov    $0x1000,%edi
        pa = PTE_ADDR(*pte);
801072c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE)
801072cb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801072d1:	0f 46 fe             	cmovbe %esi,%edi
        if (readi(ip, P2V(pa), offset + i, n) != n)
801072d4:	01 d9                	add    %ebx,%ecx
801072d6:	05 00 00 00 80       	add    $0x80000000,%eax
801072db:	57                   	push   %edi
801072dc:	51                   	push   %ecx
801072dd:	50                   	push   %eax
801072de:	ff 75 10             	pushl  0x10(%ebp)
801072e1:	e8 ba a6 ff ff       	call   801019a0 <readi>
801072e6:	83 c4 10             	add    $0x10,%esp
801072e9:	39 f8                	cmp    %edi,%eax
801072eb:	74 ab                	je     80107298 <loaduvm+0x28>
            return -1;
    }
    return 0;
}
801072ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
801072f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072f5:	5b                   	pop    %ebx
801072f6:	5e                   	pop    %esi
801072f7:	5f                   	pop    %edi
801072f8:	5d                   	pop    %ebp
801072f9:	c3                   	ret    
801072fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107300:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107303:	31 c0                	xor    %eax,%eax
}
80107305:	5b                   	pop    %ebx
80107306:	5e                   	pop    %esi
80107307:	5f                   	pop    %edi
80107308:	5d                   	pop    %ebp
80107309:	c3                   	ret    
            panic("loaduvm: address should exist");
8010730a:	83 ec 0c             	sub    $0xc,%esp
8010730d:	68 e3 85 10 80       	push   $0x801085e3
80107312:	e8 79 90 ff ff       	call   80100390 <panic>
        panic("loaduvm: addr must be page aligned");
80107317:	83 ec 0c             	sub    $0xc,%esp
8010731a:	68 a8 86 10 80       	push   $0x801086a8
8010731f:	e8 6c 90 ff ff       	call   80100390 <panic>
80107324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010732a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107330 <findFreeEntryInSwapFile>:

int
findFreeEntryInSwapFile(struct proc *p) {
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	8b 55 08             	mov    0x8(%ebp),%edx
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
        if (!p->swapFileEntries[i])
80107336:	8b 82 00 04 00 00    	mov    0x400(%edx),%eax
8010733c:	85 c0                	test   %eax,%eax
8010733e:	74 0f                	je     8010734f <findFreeEntryInSwapFile+0x1f>
            return i;
    }
    return -1;
80107340:	83 ba 04 04 00 00 01 	cmpl   $0x1,0x404(%edx)
80107347:	19 c0                	sbb    %eax,%eax
80107349:	83 e0 02             	and    $0x2,%eax
8010734c:	83 e8 01             	sub    $0x1,%eax
}
8010734f:	5d                   	pop    %ebp
80107350:	c3                   	ret    
80107351:	eb 0d                	jmp    80107360 <swapOutPage>
80107353:	90                   	nop
80107354:	90                   	nop
80107355:	90                   	nop
80107356:	90                   	nop
80107357:	90                   	nop
80107358:	90                   	nop
80107359:	90                   	nop
8010735a:	90                   	nop
8010735b:	90                   	nop
8010735c:	90                   	nop
8010735d:	90                   	nop
8010735e:	90                   	nop
8010735f:	90                   	nop

80107360 <swapOutPage>:


void
swapOutPage(struct proc *p, struct page *pg, pde_t *pgdir) {
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 1c             	sub    $0x1c,%esp
80107369:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010736c:	8b 75 0c             	mov    0xc(%ebp),%esi
        if (!p->swapFileEntries[i])
8010736f:	8b bb 00 04 00 00    	mov    0x400(%ebx),%edi
80107375:	85 ff                	test   %edi,%edi
80107377:	74 4f                	je     801073c8 <swapOutPage+0x68>
80107379:	8b bb 04 04 00 00    	mov    0x404(%ebx),%edi
8010737f:	85 ff                	test   %edi,%edi
80107381:	0f 84 c9 00 00 00    	je     80107450 <swapOutPage+0xf0>
    pde_t *pgtble;
    int tmpOffset = findFreeEntryInSwapFile(p);
    if (tmpOffset == -1) {//validy check
        cprintf("p->entries:\t");
80107387:	83 ec 0c             	sub    $0xc,%esp
8010738a:	68 01 86 10 80       	push   $0x80108601
8010738f:	e8 cc 92 ff ff       	call   80100660 <cprintf>
        for (int i = 0; i < MAX_PSYC_PAGES; i++){

            cprintf("%d  ",p->swapFileEntries[i]);
80107394:	58                   	pop    %eax
80107395:	5a                   	pop    %edx
80107396:	ff b3 00 04 00 00    	pushl  0x400(%ebx)
8010739c:	68 0e 86 10 80       	push   $0x8010860e
801073a1:	e8 ba 92 ff ff       	call   80100660 <cprintf>
801073a6:	59                   	pop    %ecx
801073a7:	5e                   	pop    %esi
801073a8:	ff b3 04 04 00 00    	pushl  0x404(%ebx)
801073ae:	68 0e 86 10 80       	push   $0x8010860e
801073b3:	e8 a8 92 ff ff       	call   80100660 <cprintf>
        }
        panic("ERROR - there is no free entry in p->swapFileEntries!\n");
801073b8:	c7 04 24 cc 86 10 80 	movl   $0x801086cc,(%esp)
801073bf:	e8 cc 8f ff ff       	call   80100390 <panic>
801073c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (!p->swapFileEntries[i])
801073c8:	31 d2                	xor    %edx,%edx

    }

    int swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
    //write the page to swapFile
    writeToSwapFile(p, pg->physAdress, (uint) swapWriteOffset, PGSIZE);
801073ca:	68 00 10 00 00       	push   $0x1000
801073cf:	52                   	push   %edx
801073d0:	ff 76 14             	pushl  0x14(%esi)
801073d3:	53                   	push   %ebx
801073d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801073d7:	e8 b4 ae ff ff       	call   80102290 <writeToSwapFile>
    //update page
    pg->present = 0;
    pg->offset = (uint) swapWriteOffset;
801073dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    pg->present = 0;
801073df:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    //update proc
    p->swapFileEntries[tmpOffset] = 1; //update that this entry is swapped out
    p->pagesinSwap++;

    //update pte
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
801073e6:	31 c9                	xor    %ecx,%ecx
    pg->physAdress = 0;
801073e8:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
    pg->sequel = 0;
801073ef:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
801073f6:	8b 45 10             	mov    0x10(%ebp),%eax
    pg->offset = (uint) swapWriteOffset;
801073f9:	89 56 10             	mov    %edx,0x10(%esi)
    p->swapFileEntries[tmpOffset] = 1; //update that this entry is swapped out
801073fc:	c7 84 bb 00 04 00 00 	movl   $0x1,0x400(%ebx,%edi,4)
80107403:	01 00 00 00 
    p->pagesinSwap++;
80107407:	83 83 10 04 00 00 01 	addl   $0x1,0x410(%ebx)
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
8010740e:	8b 56 18             	mov    0x18(%esi),%edx
80107411:	e8 ca fa ff ff       	call   80106ee0 <walkpgdir>
    *pgtble = PTE_P_0(*pgtble);
80107416:	8b 10                	mov    (%eax),%edx
80107418:	89 d1                	mov    %edx,%ecx
    *pgtble = PTE_PG_1(*pgtble);
    kfree(P2V(PTE_ADDR(*pgtble)));
8010741a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    *pgtble = PTE_P_0(*pgtble);
80107420:	83 e1 fe             	and    $0xfffffffe,%ecx
    kfree(P2V(PTE_ADDR(*pgtble)));
80107423:	81 c2 00 00 00 80    	add    $0x80000000,%edx
    *pgtble = PTE_PG_1(*pgtble);
80107429:	80 cd 02             	or     $0x2,%ch
8010742c:	89 08                	mov    %ecx,(%eax)
    kfree(P2V(PTE_ADDR(*pgtble)));
8010742e:	89 14 24             	mov    %edx,(%esp)
80107431:	e8 aa b2 ff ff       	call   801026e0 <kfree>
    lcr3(V2P(p->pgdir));
80107436:	8b 43 04             	mov    0x4(%ebx),%eax
80107439:	05 00 00 00 80       	add    $0x80000000,%eax
8010743e:	0f 22 d8             	mov    %eax,%cr3
}
80107441:	83 c4 10             	add    $0x10,%esp
80107444:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107447:	5b                   	pop    %ebx
80107448:	5e                   	pop    %esi
80107449:	5f                   	pop    %edi
8010744a:	5d                   	pop    %ebp
8010744b:	c3                   	ret    
8010744c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (!p->swapFileEntries[i])
80107450:	ba 00 10 00 00       	mov    $0x1000,%edx
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80107455:	bf 01 00 00 00       	mov    $0x1,%edi
8010745a:	e9 6b ff ff ff       	jmp    801073ca <swapOutPage+0x6a>
8010745f:	90                   	nop

80107460 <deallocuvm>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int growproc) {
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	57                   	push   %edi
80107464:	56                   	push   %esi
80107465:	53                   	push   %ebx
80107466:	83 ec 1c             	sub    $0x1c,%esp
80107469:	8b 75 0c             	mov    0xc(%ebp),%esi
    if (DEBUGMODE == 2 && notShell())
        cprintf("DEALLOCUVM-");
    pte_t *pte;
    uint a, pa;
    struct page *pg;
    struct proc *p = myproc();
8010746c:	e8 ef c7 ff ff       	call   80103c60 <myproc>

    if (newsz >= oldsz) {
80107471:	39 75 10             	cmp    %esi,0x10(%ebp)
80107474:	0f 83 5e 01 00 00    	jae    801075d8 <deallocuvm+0x178>
8010747a:	89 c7                	mov    %eax,%edi
        if (DEBUGMODE == 2 && notShell())
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
8010747c:	8b 45 10             	mov    0x10(%ebp),%eax
8010747f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107485:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; a < oldsz; a += PGSIZE) {
8010748b:	39 de                	cmp    %ebx,%esi
8010748d:	0f 86 df 00 00 00    	jbe    80107572 <deallocuvm+0x112>
            pa = PTE_ADDR(*pte);
            if (pa == 0)
                panic("kfree");
            if (p->pid > 2 && growproc) {
                //scan pages table and remove page that page.virtAdress == a
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107493:	8d 87 00 04 00 00    	lea    0x400(%edi),%eax
80107499:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010749c:	eb 4b                	jmp    801074e9 <deallocuvm+0x89>
8010749e:	66 90                	xchg   %ax,%ax
            if (pa == 0)
801074a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801074a6:	0f 84 63 01 00 00    	je     8010760f <deallocuvm+0x1af>
            if (p->pid > 2 && growproc) {
801074ac:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
801074b0:	7e 0b                	jle    801074bd <deallocuvm+0x5d>
801074b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
801074b5:	85 c9                	test   %ecx,%ecx
801074b7:	0f 85 db 00 00 00    	jne    80107598 <deallocuvm+0x138>
            kfree(v);
801074bd:	83 ec 0c             	sub    $0xc,%esp
            char *v = P2V(pa);
801074c0:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801074c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            kfree(v);
801074c9:	52                   	push   %edx
801074ca:	e8 11 b2 ff ff       	call   801026e0 <kfree>
            *pte = 0;
801074cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074d2:	83 c4 10             	add    $0x10,%esp
801074d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; a < oldsz; a += PGSIZE) {
801074db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074e1:	39 de                	cmp    %ebx,%esi
801074e3:	0f 86 89 00 00 00    	jbe    80107572 <deallocuvm+0x112>
        pte = walkpgdir(pgdir, (char *) a, 0);
801074e9:	8b 45 08             	mov    0x8(%ebp),%eax
801074ec:	31 c9                	xor    %ecx,%ecx
801074ee:	89 da                	mov    %ebx,%edx
801074f0:	e8 eb f9 ff ff       	call   80106ee0 <walkpgdir>
        if (!pte)
801074f5:	85 c0                	test   %eax,%eax
801074f7:	0f 84 83 00 00 00    	je     80107580 <deallocuvm+0x120>
        else if ((*pte & PTE_P) != 0) {
801074fd:	8b 10                	mov    (%eax),%edx
801074ff:	f6 c2 01             	test   $0x1,%dl
80107502:	75 9c                	jne    801074a0 <deallocuvm+0x40>
        } else if ((*pte & PTE_PG) != 0) {
80107504:	f6 c6 02             	test   $0x2,%dh
80107507:	74 d2                	je     801074db <deallocuvm+0x7b>
            if (pa == 0)
80107509:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010750f:	0f 84 fa 00 00 00    	je     8010760f <deallocuvm+0x1af>
            if (p->pid > 2 && growproc) {
80107515:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107519:	7e c0                	jle    801074db <deallocuvm+0x7b>
8010751b:	8b 45 14             	mov    0x14(%ebp),%eax
8010751e:	85 c0                	test   %eax,%eax
80107520:	74 b9                	je     801074db <deallocuvm+0x7b>
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107522:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
80107528:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010752b:	eb 0a                	jmp    80107537 <deallocuvm+0xd7>
8010752d:	8d 76 00             	lea    0x0(%esi),%esi
80107530:	83 c0 1c             	add    $0x1c,%eax
80107533:	39 d0                	cmp    %edx,%eax
80107535:	73 a4                	jae    801074db <deallocuvm+0x7b>
                    if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
80107537:	8b 08                	mov    (%eax),%ecx
80107539:	85 c9                	test   %ecx,%ecx
8010753b:	74 f3                	je     80107530 <deallocuvm+0xd0>
8010753d:	3b 58 18             	cmp    0x18(%eax),%ebx
80107540:	75 ee                	jne    80107530 <deallocuvm+0xd0>
    for (; a < oldsz; a += PGSIZE) {
80107542:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                    {
                        //remove page
                        pg->virtAdress = 0;
80107548:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
                        pg->active = 0;
8010754f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                        pg->offset = 0;      //TODO - check if there is a need to save offset
80107555:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                        pg->present = 0;
8010755c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

                        //update proc
                        p->pagesCounter--;
80107563:	83 af 0c 04 00 00 01 	subl   $0x1,0x40c(%edi)
    for (; a < oldsz; a += PGSIZE) {
8010756a:	39 de                	cmp    %ebx,%esi
8010756c:	0f 87 77 ff ff ff    	ja     801074e9 <deallocuvm+0x89>
            }
        }
    }
    if (DEBUGMODE == 2 && notShell())
        cprintf(">DEALLOCUVM-DONE!\t");
    return newsz;
80107572:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107578:	5b                   	pop    %ebx
80107579:	5e                   	pop    %esi
8010757a:	5f                   	pop    %edi
8010757b:	5d                   	pop    %ebp
8010757c:	c3                   	ret    
8010757d:	8d 76 00             	lea    0x0(%esi),%esi
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107580:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107586:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
8010758c:	e9 4a ff ff ff       	jmp    801074db <deallocuvm+0x7b>
80107591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010759b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010759e:	8d 8f 80 00 00 00    	lea    0x80(%edi),%ecx
801075a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
801075a8:	83 39 00             	cmpl   $0x0,(%ecx)
801075ab:	74 05                	je     801075b2 <deallocuvm+0x152>
801075ad:	3b 59 18             	cmp    0x18(%ecx),%ebx
801075b0:	74 36                	je     801075e8 <deallocuvm+0x188>
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801075b2:	83 c1 1c             	add    $0x1c,%ecx
801075b5:	39 c1                	cmp    %eax,%ecx
801075b7:	72 ef                	jb     801075a8 <deallocuvm+0x148>
801075b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
                if (pg == &p->pages[MAX_TOTAL_PAGES])//if true ->didn't find the virtAdress
801075bc:	39 4d e0             	cmp    %ecx,-0x20(%ebp)
801075bf:	0f 85 f8 fe ff ff    	jne    801074bd <deallocuvm+0x5d>
                    panic("deallocuvm Error - didn't find the virtAdress!");
801075c5:	83 ec 0c             	sub    $0xc,%esp
801075c8:	68 04 87 10 80       	push   $0x80108704
801075cd:	e8 be 8d ff ff       	call   80100390 <panic>
801075d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
801075d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return oldsz;
801075db:	89 f0                	mov    %esi,%eax
}
801075dd:	5b                   	pop    %ebx
801075de:	5e                   	pop    %esi
801075df:	5f                   	pop    %edi
801075e0:	5d                   	pop    %ebp
801075e1:	c3                   	ret    
801075e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                        pg->virtAdress = 0;
801075e8:	c7 41 18 00 00 00 00 	movl   $0x0,0x18(%ecx)
                        pg->active = 0;
801075ef:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
                        pg->offset = 0;      //TODO - check if there is a need to save offset
801075f5:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
                        pg->present = 0;
801075fc:	c7 41 0c 00 00 00 00 	movl   $0x0,0xc(%ecx)
80107603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
                        p->pagesCounter--;
80107606:	83 af 0c 04 00 00 01 	subl   $0x1,0x40c(%edi)
                        break;
8010760d:	eb ad                	jmp    801075bc <deallocuvm+0x15c>
                panic("kfree");
8010760f:	83 ec 0c             	sub    $0xc,%esp
80107612:	68 8a 7e 10 80       	push   $0x80107e8a
80107617:	e8 74 8d ff ff       	call   80100390 <panic>
8010761c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107620 <allocuvm>:
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
80107626:	83 ec 1c             	sub    $0x1c,%esp
    struct proc *p = myproc();
80107629:	e8 32 c6 ff ff       	call   80103c60 <myproc>
8010762e:	89 c6                	mov    %eax,%esi
    if (newsz >= KERNBASE) {
80107630:	8b 45 10             	mov    0x10(%ebp),%eax
80107633:	85 c0                	test   %eax,%eax
80107635:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107638:	0f 88 12 02 00 00    	js     80107850 <allocuvm+0x230>
    if (newsz < oldsz) {
8010763e:	3b 45 0c             	cmp    0xc(%ebp),%eax
        return oldsz;
80107641:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (newsz < oldsz) {
80107644:	0f 82 66 01 00 00    	jb     801077b0 <allocuvm+0x190>
    a = PGROUNDUP(oldsz);
8010764a:	05 ff 0f 00 00       	add    $0xfff,%eax
8010764f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    for (; a < newsz; a += PGSIZE) {
80107654:	39 45 10             	cmp    %eax,0x10(%ebp)
    a = PGROUNDUP(oldsz);
80107657:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (; a < newsz; a += PGSIZE) {
8010765a:	0f 86 53 01 00 00    	jbe    801077b3 <allocuvm+0x193>
        if (p->pagesCounter == MAX_TOTAL_PAGES)
80107660:	8b 86 0c 04 00 00    	mov    0x40c(%esi),%eax
80107666:	83 f8 20             	cmp    $0x20,%eax
80107669:	0f 84 3b 02 00 00    	je     801078aa <allocuvm+0x28a>
            for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
8010766f:	8d 8e 00 04 00 00    	lea    0x400(%esi),%ecx
    struct page *pg = 0, *cg = 0;
80107675:	31 db                	xor    %ebx,%ebx
    int maxSeq = 0;
80107677:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
            for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
8010767e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80107681:	eb 27                	jmp    801076aa <allocuvm+0x8a>
80107683:	90                   	nop
80107684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (; a < newsz; a += PGSIZE) {
80107688:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
8010768f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107692:	39 45 10             	cmp    %eax,0x10(%ebp)
80107695:	0f 86 18 01 00 00    	jbe    801077b3 <allocuvm+0x193>
        if (p->pagesCounter == MAX_TOTAL_PAGES)
8010769b:	8b 86 0c 04 00 00    	mov    0x40c(%esi),%eax
801076a1:	83 f8 20             	cmp    $0x20,%eax
801076a4:	0f 84 00 02 00 00    	je     801078aa <allocuvm+0x28a>
        if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2) {
801076aa:	2b 86 10 04 00 00    	sub    0x410(%esi),%eax
801076b0:	83 f8 01             	cmp    $0x1,%eax
801076b3:	7e 0a                	jle    801076bf <allocuvm+0x9f>
801076b5:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
801076b9:	0f 8f 01 01 00 00    	jg     801077c0 <allocuvm+0x1a0>
        mem = kalloc();
801076bf:	e8 cc b1 ff ff       	call   80102890 <kalloc>
        if (mem == 0) {
801076c4:	85 c0                	test   %eax,%eax
        mem = kalloc();
801076c6:	89 c7                	mov    %eax,%edi
        if (mem == 0) {
801076c8:	0f 84 48 01 00 00    	je     80107816 <allocuvm+0x1f6>
        memset(mem, 0, PGSIZE);
801076ce:	83 ec 04             	sub    $0x4,%esp
801076d1:	68 00 10 00 00       	push   $0x1000
801076d6:	6a 00                	push   $0x0
801076d8:	50                   	push   %eax
801076d9:	e8 62 d4 ff ff       	call   80104b40 <memset>
        if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
801076de:	58                   	pop    %eax
801076df:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801076e5:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076ea:	5a                   	pop    %edx
801076eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076ee:	6a 06                	push   $0x6
801076f0:	50                   	push   %eax
801076f1:	8b 45 08             	mov    0x8(%ebp),%eax
801076f4:	e8 67 f8 ff ff       	call   80106f60 <mappages>
801076f9:	83 c4 10             	add    $0x10,%esp
801076fc:	85 c0                	test   %eax,%eax
801076fe:	0f 88 5e 01 00 00    	js     80107862 <allocuvm+0x242>
        if (p->pid > 2) {
80107704:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80107708:	0f 8e 7a ff ff ff    	jle    80107688 <allocuvm+0x68>
                if (!pg->active)
8010770e:	8b 8e 80 00 00 00    	mov    0x80(%esi),%ecx
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107714:	8d 9e 80 00 00 00    	lea    0x80(%esi),%ebx
8010771a:	8b 45 dc             	mov    -0x24(%ebp),%eax
                if (!pg->active)
8010771d:	85 c9                	test   %ecx,%ecx
8010771f:	74 18                	je     80107739 <allocuvm+0x119>
80107721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107728:	83 c3 1c             	add    $0x1c,%ebx
8010772b:	39 c3                	cmp    %eax,%ebx
8010772d:	0f 83 6a 01 00 00    	jae    8010789d <allocuvm+0x27d>
                if (!pg->active)
80107733:	8b 13                	mov    (%ebx),%edx
80107735:	85 d2                	test   %edx,%edx
80107737:	75 ef                	jne    80107728 <allocuvm+0x108>
            p->pagesCounter++;
80107739:	83 86 0c 04 00 00 01 	addl   $0x1,0x40c(%esi)
            pg->active = 1;
80107740:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
            pgtble = walkpgdir(pgdir, (char *) a, 0);
80107746:	31 c9                	xor    %ecx,%ecx
            pg->pageid = p->nextpageid++;
80107748:	8b 86 08 04 00 00    	mov    0x408(%esi),%eax
8010774e:	8d 50 01             	lea    0x1(%eax),%edx
80107751:	89 96 08 04 00 00    	mov    %edx,0x408(%esi)
80107757:	89 43 04             	mov    %eax,0x4(%ebx)
            pg->present = 1;
8010775a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
            pg->offset = 0;
80107761:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
            pg->sequel = p->pagesequel++;
80107768:	8b 86 14 04 00 00    	mov    0x414(%esi),%eax
8010776e:	8d 50 01             	lea    0x1(%eax),%edx
80107771:	89 96 14 04 00 00    	mov    %edx,0x414(%esi)
80107777:	89 43 08             	mov    %eax,0x8(%ebx)
            pg->virtAdress = (char *) a;
8010777a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
            pg->physAdress = mem;
8010777d:	89 7b 14             	mov    %edi,0x14(%ebx)
            pg->virtAdress = (char *) a;
80107780:	89 43 18             	mov    %eax,0x18(%ebx)
            pgtble = walkpgdir(pgdir, (char *) a, 0);
80107783:	89 c2                	mov    %eax,%edx
80107785:	8b 45 08             	mov    0x8(%ebp),%eax
80107788:	e8 53 f7 ff ff       	call   80106ee0 <walkpgdir>
            *pgtble = PTE_PG_0(*pgtble); // Not Paged out to secondary storage
8010778d:	8b 10                	mov    (%eax),%edx
8010778f:	80 e6 fd             	and    $0xfd,%dh
80107792:	83 ca 01             	or     $0x1,%edx
80107795:	89 10                	mov    %edx,(%eax)
            lcr3(V2P(p->pgdir));
80107797:	8b 46 04             	mov    0x4(%esi),%eax
8010779a:	05 00 00 00 80       	add    $0x80000000,%eax
8010779f:	0f 22 d8             	mov    %eax,%cr3
801077a2:	e9 e1 fe ff ff       	jmp    80107688 <allocuvm+0x68>
801077a7:	89 f6                	mov    %esi,%esi
801077a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return oldsz;
801077b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
}
801077b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077b9:	5b                   	pop    %ebx
801077ba:	5e                   	pop    %esi
801077bb:	5f                   	pop    %edi
801077bc:	5d                   	pop    %ebp
801077bd:	c3                   	ret    
801077be:	66 90                	xchg   %ax,%ax
            for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
801077c0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801077c3:	8d 86 80 00 00 00    	lea    0x80(%esi),%eax
801077c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                if (cg->active && cg->present && cg->sequel > maxSeq) {
801077d0:	8b 38                	mov    (%eax),%edi
801077d2:	85 ff                	test   %edi,%edi
801077d4:	74 1a                	je     801077f0 <allocuvm+0x1d0>
801077d6:	8b 48 0c             	mov    0xc(%eax),%ecx
801077d9:	85 c9                	test   %ecx,%ecx
801077db:	74 13                	je     801077f0 <allocuvm+0x1d0>
801077dd:	8b 48 08             	mov    0x8(%eax),%ecx
801077e0:	3b 4d d8             	cmp    -0x28(%ebp),%ecx
801077e3:	7e 0b                	jle    801077f0 <allocuvm+0x1d0>
801077e5:	89 c3                	mov    %eax,%ebx
801077e7:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801077ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
801077f0:	83 c0 1c             	add    $0x1c,%eax
801077f3:	39 d0                	cmp    %edx,%eax
801077f5:	72 d9                	jb     801077d0 <allocuvm+0x1b0>
            swapOutPage(p, pg, pgdir); //this func includes remove page, update proc and update PTE
801077f7:	83 ec 04             	sub    $0x4,%esp
801077fa:	ff 75 08             	pushl  0x8(%ebp)
801077fd:	53                   	push   %ebx
801077fe:	56                   	push   %esi
801077ff:	e8 5c fb ff ff       	call   80107360 <swapOutPage>
80107804:	83 c4 10             	add    $0x10,%esp
        mem = kalloc();
80107807:	e8 84 b0 ff ff       	call   80102890 <kalloc>
        if (mem == 0) {
8010780c:	85 c0                	test   %eax,%eax
        mem = kalloc();
8010780e:	89 c7                	mov    %eax,%edi
        if (mem == 0) {
80107810:	0f 85 b8 fe ff ff    	jne    801076ce <allocuvm+0xae>
            cprintf("allocuvm out of memory\n");
80107816:	83 ec 0c             	sub    $0xc,%esp
80107819:	68 13 86 10 80       	push   $0x80108613
8010781e:	e8 3d 8e ff ff       	call   80100660 <cprintf>
            deallocuvm(pgdir, newsz, oldsz, 0);
80107823:	6a 00                	push   $0x0
80107825:	ff 75 0c             	pushl  0xc(%ebp)
80107828:	ff 75 10             	pushl  0x10(%ebp)
8010782b:	ff 75 08             	pushl  0x8(%ebp)
8010782e:	e8 2d fc ff ff       	call   80107460 <deallocuvm>
            return 0;
80107833:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010783a:	83 c4 20             	add    $0x20,%esp
}
8010783d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107840:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107843:	5b                   	pop    %ebx
80107844:	5e                   	pop    %esi
80107845:	5f                   	pop    %edi
80107846:	5d                   	pop    %ebp
80107847:	c3                   	ret    
80107848:	90                   	nop
80107849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return 0;
80107850:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107857:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010785a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010785d:	5b                   	pop    %ebx
8010785e:	5e                   	pop    %esi
8010785f:	5f                   	pop    %edi
80107860:	5d                   	pop    %ebp
80107861:	c3                   	ret    
            cprintf("allocuvm out of memory (2)\n");
80107862:	83 ec 0c             	sub    $0xc,%esp
80107865:	68 2b 86 10 80       	push   $0x8010862b
8010786a:	e8 f1 8d ff ff       	call   80100660 <cprintf>
            deallocuvm(pgdir, newsz, oldsz, 0);
8010786f:	6a 00                	push   $0x0
80107871:	ff 75 0c             	pushl  0xc(%ebp)
80107874:	ff 75 10             	pushl  0x10(%ebp)
80107877:	ff 75 08             	pushl  0x8(%ebp)
8010787a:	e8 e1 fb ff ff       	call   80107460 <deallocuvm>
            kfree(mem);
8010787f:	83 c4 14             	add    $0x14,%esp
80107882:	57                   	push   %edi
80107883:	e8 58 ae ff ff       	call   801026e0 <kfree>
            return 0;
80107888:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010788f:	83 c4 10             	add    $0x10,%esp
}
80107892:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107895:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107898:	5b                   	pop    %ebx
80107899:	5e                   	pop    %esi
8010789a:	5f                   	pop    %edi
8010789b:	5d                   	pop    %ebp
8010789c:	c3                   	ret    
            panic("no page in proc");
8010789d:	83 ec 0c             	sub    $0xc,%esp
801078a0:	68 47 86 10 80       	push   $0x80108647
801078a5:	e8 e6 8a ff ff       	call   80100390 <panic>
            panic("got 32 pages and requested for another page!");
801078aa:	83 ec 0c             	sub    $0xc,%esp
801078ad:	68 34 87 10 80       	push   $0x80108734
801078b2:	e8 d9 8a ff ff       	call   80100390 <panic>
801078b7:	89 f6                	mov    %esi,%esi
801078b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir) {
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	57                   	push   %edi
801078c4:	56                   	push   %esi
801078c5:	53                   	push   %ebx
801078c6:	83 ec 0c             	sub    $0xc,%esp
801078c9:	8b 75 08             	mov    0x8(%ebp),%esi
    if (DEBUGMODE == 2 && notShell())
        cprintf("FREEVM");
    uint i;

    if (pgdir == 0)
801078cc:	85 f6                	test   %esi,%esi
801078ce:	74 59                	je     80107929 <freevm+0x69>
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0, 0);
801078d0:	6a 00                	push   $0x0
801078d2:	6a 00                	push   $0x0
801078d4:	89 f3                	mov    %esi,%ebx
801078d6:	68 00 00 00 80       	push   $0x80000000
801078db:	56                   	push   %esi
801078dc:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801078e2:	e8 79 fb ff ff       	call   80107460 <deallocuvm>
801078e7:	83 c4 10             	add    $0x10,%esp
801078ea:	eb 0b                	jmp    801078f7 <freevm+0x37>
801078ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078f0:	83 c3 04             	add    $0x4,%ebx
    for (i = 0; i < NPDENTRIES; i++) {
801078f3:	39 fb                	cmp    %edi,%ebx
801078f5:	74 23                	je     8010791a <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
801078f7:	8b 03                	mov    (%ebx),%eax
801078f9:	a8 01                	test   $0x1,%al
801078fb:	74 f3                	je     801078f0 <freevm+0x30>
            char *v = P2V(PTE_ADDR(pgdir[i]));
801078fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(v);
80107902:	83 ec 0c             	sub    $0xc,%esp
80107905:	83 c3 04             	add    $0x4,%ebx
            char *v = P2V(PTE_ADDR(pgdir[i]));
80107908:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(v);
8010790d:	50                   	push   %eax
8010790e:	e8 cd ad ff ff       	call   801026e0 <kfree>
80107913:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80107916:	39 fb                	cmp    %edi,%ebx
80107918:	75 dd                	jne    801078f7 <freevm+0x37>
        }
    }
    kfree((char *) pgdir);
8010791a:	89 75 08             	mov    %esi,0x8(%ebp)
    if (DEBUGMODE == 2 && notShell())
        cprintf(">FREEVM-DONE!\t");
}
8010791d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107920:	5b                   	pop    %ebx
80107921:	5e                   	pop    %esi
80107922:	5f                   	pop    %edi
80107923:	5d                   	pop    %ebp
    kfree((char *) pgdir);
80107924:	e9 b7 ad ff ff       	jmp    801026e0 <kfree>
        panic("freevm: no pgdir");
80107929:	83 ec 0c             	sub    $0xc,%esp
8010792c:	68 57 86 10 80       	push   $0x80108657
80107931:	e8 5a 8a ff ff       	call   80100390 <panic>
80107936:	8d 76 00             	lea    0x0(%esi),%esi
80107939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107940 <setupkvm>:
setupkvm(void) {
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	56                   	push   %esi
80107944:	53                   	push   %ebx
    if ((pgdir = (pde_t *) kalloc()) == 0)
80107945:	e8 46 af ff ff       	call   80102890 <kalloc>
8010794a:	85 c0                	test   %eax,%eax
8010794c:	89 c6                	mov    %eax,%esi
8010794e:	74 42                	je     80107992 <setupkvm+0x52>
    memset(pgdir, 0, PGSIZE);
80107950:	83 ec 04             	sub    $0x4,%esp
    for (k = kmap; k < &kmap[NELEM(kmap)];
80107953:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
    memset(pgdir, 0, PGSIZE);
80107958:	68 00 10 00 00       	push   $0x1000
8010795d:	6a 00                	push   $0x0
8010795f:	50                   	push   %eax
80107960:	e8 db d1 ff ff       	call   80104b40 <memset>
80107965:	83 c4 10             	add    $0x10,%esp
                 (uint) k->phys_start, k->perm) < 0) {
80107968:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010796b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010796e:	83 ec 08             	sub    $0x8,%esp
80107971:	8b 13                	mov    (%ebx),%edx
80107973:	ff 73 0c             	pushl  0xc(%ebx)
80107976:	50                   	push   %eax
80107977:	29 c1                	sub    %eax,%ecx
80107979:	89 f0                	mov    %esi,%eax
8010797b:	e8 e0 f5 ff ff       	call   80106f60 <mappages>
80107980:	83 c4 10             	add    $0x10,%esp
80107983:	85 c0                	test   %eax,%eax
80107985:	78 19                	js     801079a0 <setupkvm+0x60>
    k++)
80107987:	83 c3 10             	add    $0x10,%ebx
    for (k = kmap; k < &kmap[NELEM(kmap)];
8010798a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107990:	75 d6                	jne    80107968 <setupkvm+0x28>
}
80107992:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107995:	89 f0                	mov    %esi,%eax
80107997:	5b                   	pop    %ebx
80107998:	5e                   	pop    %esi
80107999:	5d                   	pop    %ebp
8010799a:	c3                   	ret    
8010799b:	90                   	nop
8010799c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        freevm(pgdir);
801079a0:	83 ec 0c             	sub    $0xc,%esp
801079a3:	56                   	push   %esi
        return 0;
801079a4:	31 f6                	xor    %esi,%esi
        freevm(pgdir);
801079a6:	e8 15 ff ff ff       	call   801078c0 <freevm>
        return 0;
801079ab:	83 c4 10             	add    $0x10,%esp
}
801079ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079b1:	89 f0                	mov    %esi,%eax
801079b3:	5b                   	pop    %ebx
801079b4:	5e                   	pop    %esi
801079b5:	5d                   	pop    %ebp
801079b6:	c3                   	ret    
801079b7:	89 f6                	mov    %esi,%esi
801079b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079c0 <kvmalloc>:
kvmalloc(void) {
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
801079c6:	e8 75 ff ff ff       	call   80107940 <setupkvm>
801079cb:	a3 c8 5b 12 80       	mov    %eax,0x80125bc8
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801079d0:	05 00 00 00 80       	add    $0x80000000,%eax
801079d5:	0f 22 d8             	mov    %eax,%cr3
}
801079d8:	c9                   	leave  
801079d9:	c3                   	ret    
801079da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva) {
801079e0:	55                   	push   %ebp
    if (DEBUGMODE == 2 && notShell())
        cprintf("CLEARPTEU-");
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
801079e1:	31 c9                	xor    %ecx,%ecx
clearpteu(pde_t *pgdir, char *uva) {
801079e3:	89 e5                	mov    %esp,%ebp
801079e5:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
801079e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801079eb:	8b 45 08             	mov    0x8(%ebp),%eax
801079ee:	e8 ed f4 ff ff       	call   80106ee0 <walkpgdir>
    if (pte == 0)
801079f3:	85 c0                	test   %eax,%eax
801079f5:	74 05                	je     801079fc <clearpteu+0x1c>
        panic("clearpteu");
    *pte &= ~PTE_U;
801079f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
    if (DEBUGMODE == 2 && notShell())
        cprintf(">CLEARPTEU-DONE!\t");
}
801079fa:	c9                   	leave  
801079fb:	c3                   	ret    
        panic("clearpteu");
801079fc:	83 ec 0c             	sub    $0xc,%esp
801079ff:	68 68 86 10 80       	push   $0x80108668
80107a04:	e8 87 89 ff ff       	call   80100390 <panic>
80107a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz) {
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	57                   	push   %edi
80107a14:	56                   	push   %esi
80107a15:	53                   	push   %ebx
80107a16:	83 ec 1c             	sub    $0x1c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0)
80107a19:	e8 22 ff ff ff       	call   80107940 <setupkvm>
80107a1e:	85 c0                	test   %eax,%eax
80107a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a23:	0f 84 a0 00 00 00    	je     80107ac9 <copyuvm+0xb9>
        return 0;
    for (i = 0; i < sz; i += PGSIZE) {
80107a29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a2c:	85 c9                	test   %ecx,%ecx
80107a2e:	0f 84 95 00 00 00    	je     80107ac9 <copyuvm+0xb9>
80107a34:	31 f6                	xor    %esi,%esi
80107a36:	eb 4e                	jmp    80107a86 <copyuvm+0x76>
80107a38:	90                   	nop
80107a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0)
            goto bad;
        memmove(mem, (char *) P2V(pa), PGSIZE);
80107a40:	83 ec 04             	sub    $0x4,%esp
80107a43:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a4c:	68 00 10 00 00       	push   $0x1000
80107a51:	57                   	push   %edi
80107a52:	50                   	push   %eax
80107a53:	e8 98 d1 ff ff       	call   80104bf0 <memmove>
        if (mappages(d, (void *) i, PGSIZE, V2P(mem), flags) < 0)
80107a58:	58                   	pop    %eax
80107a59:	5a                   	pop    %edx
80107a5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a60:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a65:	53                   	push   %ebx
80107a66:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107a6c:	52                   	push   %edx
80107a6d:	89 f2                	mov    %esi,%edx
80107a6f:	e8 ec f4 ff ff       	call   80106f60 <mappages>
80107a74:	83 c4 10             	add    $0x10,%esp
80107a77:	85 c0                	test   %eax,%eax
80107a79:	78 39                	js     80107ab4 <copyuvm+0xa4>
    for (i = 0; i < sz; i += PGSIZE) {
80107a7b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a81:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a84:	76 43                	jbe    80107ac9 <copyuvm+0xb9>
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a86:	8b 45 08             	mov    0x8(%ebp),%eax
80107a89:	31 c9                	xor    %ecx,%ecx
80107a8b:	89 f2                	mov    %esi,%edx
80107a8d:	e8 4e f4 ff ff       	call   80106ee0 <walkpgdir>
80107a92:	85 c0                	test   %eax,%eax
80107a94:	74 3e                	je     80107ad4 <copyuvm+0xc4>
        if (!(*pte & PTE_P))
80107a96:	8b 18                	mov    (%eax),%ebx
80107a98:	f6 c3 01             	test   $0x1,%bl
80107a9b:	74 44                	je     80107ae1 <copyuvm+0xd1>
        pa = PTE_ADDR(*pte);
80107a9d:	89 df                	mov    %ebx,%edi
        flags = PTE_FLAGS(*pte);
80107a9f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
        pa = PTE_ADDR(*pte);
80107aa5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        if ((mem = kalloc()) == 0)
80107aab:	e8 e0 ad ff ff       	call   80102890 <kalloc>
80107ab0:	85 c0                	test   %eax,%eax
80107ab2:	75 8c                	jne    80107a40 <copyuvm+0x30>
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-DONE!\t");
    return d;

    bad:
    freevm(d);
80107ab4:	83 ec 0c             	sub    $0xc,%esp
80107ab7:	ff 75 e0             	pushl  -0x20(%ebp)
80107aba:	e8 01 fe ff ff       	call   801078c0 <freevm>
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-FAILED!\t");
    return 0;
80107abf:	83 c4 10             	add    $0x10,%esp
80107ac2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107acf:	5b                   	pop    %ebx
80107ad0:	5e                   	pop    %esi
80107ad1:	5f                   	pop    %edi
80107ad2:	5d                   	pop    %ebp
80107ad3:	c3                   	ret    
            panic("copyuvm: pte should exist");
80107ad4:	83 ec 0c             	sub    $0xc,%esp
80107ad7:	68 72 86 10 80       	push   $0x80108672
80107adc:	e8 af 88 ff ff       	call   80100390 <panic>
            panic("copyuvm: page not present");
80107ae1:	83 ec 0c             	sub    $0xc,%esp
80107ae4:	68 8c 86 10 80       	push   $0x8010868c
80107ae9:	e8 a2 88 ff ff       	call   80100390 <panic>
80107aee:	66 90                	xchg   %ax,%ax

80107af0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva) {
80107af0:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80107af1:	31 c9                	xor    %ecx,%ecx
uva2ka(pde_t *pgdir, char *uva) {
80107af3:	89 e5                	mov    %esp,%ebp
80107af5:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
80107af8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107afb:	8b 45 08             	mov    0x8(%ebp),%eax
80107afe:	e8 dd f3 ff ff       	call   80106ee0 <walkpgdir>
    if ((*pte & PTE_P) == 0)
80107b03:	8b 00                	mov    (%eax),%eax
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    return (char *) P2V(PTE_ADDR(*pte));
}
80107b05:	c9                   	leave  
    if ((*pte & PTE_U) == 0)
80107b06:	89 c2                	mov    %eax,%edx
    return (char *) P2V(PTE_ADDR(*pte));
80107b08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((*pte & PTE_U) == 0)
80107b0d:	83 e2 05             	and    $0x5,%edx
    return (char *) P2V(PTE_ADDR(*pte));
80107b10:	05 00 00 00 80       	add    $0x80000000,%eax
80107b15:	83 fa 05             	cmp    $0x5,%edx
80107b18:	ba 00 00 00 00       	mov    $0x0,%edx
80107b1d:	0f 45 c2             	cmovne %edx,%eax
}
80107b20:	c3                   	ret    
80107b21:	eb 0d                	jmp    80107b30 <copyout>
80107b23:	90                   	nop
80107b24:	90                   	nop
80107b25:	90                   	nop
80107b26:	90                   	nop
80107b27:	90                   	nop
80107b28:	90                   	nop
80107b29:	90                   	nop
80107b2a:	90                   	nop
80107b2b:	90                   	nop
80107b2c:	90                   	nop
80107b2d:	90                   	nop
80107b2e:	90                   	nop
80107b2f:	90                   	nop

80107b30 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len) {
80107b30:	55                   	push   %ebp
80107b31:	89 e5                	mov    %esp,%ebp
80107b33:	57                   	push   %edi
80107b34:	56                   	push   %esi
80107b35:	53                   	push   %ebx
80107b36:	83 ec 1c             	sub    $0x1c,%esp
80107b39:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b3f:	8b 7d 10             	mov    0x10(%ebp),%edi
    char *buf, *pa0;
    uint n, va0;

    buf = (char *) p;
    while (len > 0) {
80107b42:	85 db                	test   %ebx,%ebx
80107b44:	75 40                	jne    80107b86 <copyout+0x56>
80107b46:	eb 70                	jmp    80107bb8 <copyout+0x88>
80107b48:	90                   	nop
80107b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        va0 = (uint) PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char *) va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (va - va0);
80107b50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b53:	89 f1                	mov    %esi,%ecx
80107b55:	29 d1                	sub    %edx,%ecx
80107b57:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107b5d:	39 d9                	cmp    %ebx,%ecx
80107b5f:	0f 47 cb             	cmova  %ebx,%ecx
        if (n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
80107b62:	29 f2                	sub    %esi,%edx
80107b64:	83 ec 04             	sub    $0x4,%esp
80107b67:	01 d0                	add    %edx,%eax
80107b69:	51                   	push   %ecx
80107b6a:	57                   	push   %edi
80107b6b:	50                   	push   %eax
80107b6c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107b6f:	e8 7c d0 ff ff       	call   80104bf0 <memmove>
        len -= n;
        buf += n;
80107b74:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    while (len > 0) {
80107b77:	83 c4 10             	add    $0x10,%esp
        va = va0 + PGSIZE;
80107b7a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
        buf += n;
80107b80:	01 cf                	add    %ecx,%edi
    while (len > 0) {
80107b82:	29 cb                	sub    %ecx,%ebx
80107b84:	74 32                	je     80107bb8 <copyout+0x88>
        va0 = (uint) PGROUNDDOWN(va);
80107b86:	89 d6                	mov    %edx,%esi
        pa0 = uva2ka(pgdir, (char *) va0);
80107b88:	83 ec 08             	sub    $0x8,%esp
        va0 = (uint) PGROUNDDOWN(va);
80107b8b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107b8e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        pa0 = uva2ka(pgdir, (char *) va0);
80107b94:	56                   	push   %esi
80107b95:	ff 75 08             	pushl  0x8(%ebp)
80107b98:	e8 53 ff ff ff       	call   80107af0 <uva2ka>
        if (pa0 == 0)
80107b9d:	83 c4 10             	add    $0x10,%esp
80107ba0:	85 c0                	test   %eax,%eax
80107ba2:	75 ac                	jne    80107b50 <copyout+0x20>
    }
    return 0;
}
80107ba4:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107ba7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bac:	5b                   	pop    %ebx
80107bad:	5e                   	pop    %esi
80107bae:	5f                   	pop    %edi
80107baf:	5d                   	pop    %ebp
80107bb0:	c3                   	ret    
80107bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107bbb:	31 c0                	xor    %eax,%eax
}
80107bbd:	5b                   	pop    %ebx
80107bbe:	5e                   	pop    %esi
80107bbf:	5f                   	pop    %edi
80107bc0:	5d                   	pop    %ebp
80107bc1:	c3                   	ret    
