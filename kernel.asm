
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
8010002d:	b8 f0 32 10 80       	mov    $0x801032f0,%eax
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
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 7d 10 80       	push   $0x80107d40
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 d5 49 00 00       	call   80104a30 <initlock>
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
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 7d 10 80       	push   $0x80107d47
80100097:	50                   	push   %eax
80100098:	e8 83 48 00 00       	call   80104920 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
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
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 37 4a 00 00       	call   80104b20 <acquire>
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
80100162:	e8 d9 4a 00 00       	call   80104c40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 47 00 00       	call   80104960 <acquiresleep>
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
80100193:	68 4e 7d 10 80       	push   $0x80107d4e
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
801001ae:	e8 4d 48 00 00       	call   80104a00 <holdingsleep>
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
801001cc:	68 5f 7d 10 80       	push   $0x80107d5f
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
801001ef:	e8 0c 48 00 00       	call   80104a00 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 47 00 00       	call   801049c0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 10 49 00 00       	call   80104b20 <acquire>
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
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
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
  release(&bcache.lock);
8010025c:	e9 df 49 00 00       	jmp    80104c40 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 7d 10 80       	push   $0x80107d66
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
8010028c:	e8 8f 48 00 00       	call   80104b20 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a7:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
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
801002c0:	68 c0 0f 11 80       	push   $0x80110fc0
801002c5:	e8 e6 41 00 00       	call   801044b0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 20 3a 00 00       	call   80103d00 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 4c 49 00 00       	call   80104c40 <release>
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
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
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
8010034d:	e8 ee 48 00 00       	call   80104c40 <release>
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
80100372:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
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
801003a9:	e8 d2 27 00 00       	call   80102b80 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 6d 7d 10 80       	push   $0x80107d6d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 42 88 10 80 	movl   $0x80108842,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 73 46 00 00       	call   80104a50 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 81 7d 10 80       	push   $0x80107d81
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
8010043a:	e8 01 61 00 00       	call   80106540 <uartputc>
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
801004ec:	e8 4f 60 00 00       	call   80106540 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 43 60 00 00       	call   80106540 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 37 60 00 00       	call   80106540 <uartputc>
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
80100524:	e8 27 48 00 00       	call   80104d50 <memmove>
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
80100541:	e8 5a 47 00 00       	call   80104ca0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 85 7d 10 80       	push   $0x80107d85
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
801005b1:	0f b6 92 b0 7d 10 80 	movzbl -0x7fef8250(%edx),%edx
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
8010061b:	e8 00 45 00 00       	call   80104b20 <acquire>
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
80100647:	e8 f4 45 00 00       	call   80104c40 <release>
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
8010071f:	e8 1c 45 00 00       	call   80104c40 <release>
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
801007d0:	ba 98 7d 10 80       	mov    $0x80107d98,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 2b 43 00 00       	call   80104b20 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 9f 7d 10 80       	push   $0x80107d9f
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
80100823:	e8 f8 42 00 00       	call   80104b20 <acquire>
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
80100851:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100856:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
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
80100888:	e8 b3 43 00 00       	call   80104c40 <release>
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
801008a9:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100911:	68 c0 0f 11 80       	push   $0x80110fc0
80100916:	e8 05 3e 00 00       	call   80104720 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010093d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100964:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
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
80100997:	e9 64 3e 00 00       	jmp    80104800 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
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
801009c6:	68 a8 7d 10 80       	push   $0x80107da8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 5b 40 00 00       	call   80104a30 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 8c 19 11 80 00 	movl   $0x80100600,0x8011198c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
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
80100a1c:	e8 df 32 00 00       	call   80103d00 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

    begin_op();
80100a27:	e8 c4 25 00 00       	call   80102ff0 <begin_op>

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
80100a6f:	e8 ec 25 00 00       	call   80103060 <end_op>
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
80100a94:	e8 17 70 00 00       	call   80107ab0 <setupkvm>
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
80100af6:	e8 e5 6c 00 00       	call   801077e0 <allocuvm>
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
80100b28:	e8 63 68 00 00       	call   80107390 <loaduvm>
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
80100b72:	e8 b9 6e 00 00       	call   80107a30 <freevm>
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
80100b9a:	e8 c1 24 00 00       	call   80103060 <end_op>
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 31 6c 00 00       	call   801077e0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
        freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 6a 6e 00 00       	call   80107a30 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
        end_op();
80100bd3:	e8 88 24 00 00       	call   80103060 <end_op>
        cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 c1 7d 10 80       	push   $0x80107dc1
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
80100c06:	e8 45 6f 00 00       	call   80107b50 <clearpteu>
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
80100c39:	e8 82 42 00 00       	call   80104ec0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	59                   	pop    %ecx
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 6f 42 00 00       	call   80104ec0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 3e 70 00 00       	call   80107ca0 <copyout>
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
80100cc9:	e8 d2 6f 00 00       	call   80107ca0 <copyout>
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
80100d0c:	e8 6f 41 00 00       	call   80104e80 <safestrcpy>
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
80100d63:	e8 98 64 00 00       	call   80107200 <switchuvm>
    freevm(oldpgdir);
80100d68:	89 1c 24             	mov    %ebx,(%esp)
80100d6b:	e8 c0 6c 00 00       	call   80107a30 <freevm>
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
80100d96:	68 cd 7d 10 80       	push   $0x80107dcd
80100d9b:	68 e0 0f 11 80       	push   $0x80110fe0
80100da0:	e8 8b 3c 00 00       	call   80104a30 <initlock>
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
80100db4:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100db9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dbc:	68 e0 0f 11 80       	push   $0x80110fe0
80100dc1:	e8 5a 3d 00 00       	call   80104b20 <acquire>
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	eb 10                	jmp    80100ddb <filealloc+0x2b>
80100dcb:	90                   	nop
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
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
80100dec:	68 e0 0f 11 80       	push   $0x80110fe0
80100df1:	e8 4a 3e 00 00       	call   80104c40 <release>
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
80100e05:	68 e0 0f 11 80       	push   $0x80110fe0
80100e0a:	e8 31 3e 00 00       	call   80104c40 <release>
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
80100e2a:	68 e0 0f 11 80       	push   $0x80110fe0
80100e2f:	e8 ec 3c 00 00       	call   80104b20 <acquire>
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
80100e47:	68 e0 0f 11 80       	push   $0x80110fe0
80100e4c:	e8 ef 3d 00 00       	call   80104c40 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 d4 7d 10 80       	push   $0x80107dd4
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
80100e7c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e81:	e8 9a 3c 00 00       	call   80104b20 <acquire>
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
80100e9e:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
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
80100eac:	e9 8f 3d 00 00       	jmp    80104c40 <release>
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
80100ed0:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ed8:	e8 63 3d 00 00       	call   80104c40 <release>
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
80100f01:	e8 9a 28 00 00       	call   801037a0 <pipeclose>
80100f06:	83 c4 10             	add    $0x10,%esp
80100f09:	eb df                	jmp    80100eea <fileclose+0x7a>
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f10:	e8 db 20 00 00       	call   80102ff0 <begin_op>
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
80100f2a:	e9 31 21 00 00       	jmp    80103060 <end_op>
    panic("fileclose");
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	68 dc 7d 10 80       	push   $0x80107ddc
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
80100ffd:	e9 4e 29 00 00       	jmp    80103950 <piperead>
80101002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101008:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010100d:	eb d7                	jmp    80100fe6 <fileread+0x56>
  panic("fileread");
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 e6 7d 10 80       	push   $0x80107de6
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
80101079:	e8 e2 1f 00 00       	call   80103060 <end_op>
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
801010a6:	e8 45 1f 00 00       	call   80102ff0 <begin_op>
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
801010dd:	e8 7e 1f 00 00       	call   80103060 <end_op>
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
8010111d:	e9 1e 27 00 00       	jmp    80103840 <pipewrite>
        panic("short filewrite");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 ef 7d 10 80       	push   $0x80107def
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 f5 7d 10 80       	push   $0x80107df5
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
80101149:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
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
8010116c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101172:	50                   	push   %eax
80101173:	ff 75 d8             	pushl  -0x28(%ebp)
80101176:	e8 55 ef ff ff       	call   801000d0 <bread>
8010117b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117e:	a1 e0 19 11 80       	mov    0x801119e0,%eax
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
801011d9:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801011df:	77 80                	ja     80101161 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011e1:	83 ec 0c             	sub    $0xc,%esp
801011e4:	68 ff 7d 10 80       	push   $0x80107dff
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
801011fd:	e8 be 1f 00 00       	call   801031c0 <log_write>
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
80101225:	e8 76 3a 00 00       	call   80104ca0 <memset>
  log_write(bp);
8010122a:	89 1c 24             	mov    %ebx,(%esp)
8010122d:	e8 8e 1f 00 00       	call   801031c0 <log_write>
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
8010125a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010125f:	83 ec 28             	sub    $0x28,%esp
80101262:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101265:	68 00 1a 11 80       	push   $0x80111a00
8010126a:	e8 b1 38 00 00       	call   80104b20 <acquire>
8010126f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101275:	eb 17                	jmp    8010128e <iget+0x3e>
80101277:	89 f6                	mov    %esi,%esi
80101279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101280:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101286:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
801012a8:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
801012ca:	68 00 1a 11 80       	push   $0x80111a00
801012cf:	e8 6c 39 00 00       	call   80104c40 <release>

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
801012f5:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
801012fa:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012fd:	e8 3e 39 00 00       	call   80104c40 <release>
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
80101312:	68 15 7e 10 80       	push   $0x80107e15
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
8010138e:	e8 2d 1e 00 00       	call   801031c0 <log_write>
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
801013e7:	68 25 7e 10 80       	push   $0x80107e25
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
80101421:	e8 2a 39 00 00       	call   80104d50 <memmove>
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
8010144c:	68 e0 19 11 80       	push   $0x801119e0
80101451:	50                   	push   %eax
80101452:	e8 a9 ff ff ff       	call   80101400 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101457:	58                   	pop    %eax
80101458:	5a                   	pop    %edx
80101459:	89 da                	mov    %ebx,%edx
8010145b:	c1 ea 0c             	shr    $0xc,%edx
8010145e:	03 15 f8 19 11 80    	add    0x801119f8,%edx
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
8010149a:	e8 21 1d 00 00       	call   801031c0 <log_write>
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
801014b4:	68 38 7e 10 80       	push   $0x80107e38
801014b9:	e8 d2 ee ff ff       	call   80100390 <panic>
801014be:	66 90                	xchg   %ax,%ax

801014c0 <iinit>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
801014c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014cc:	68 4b 7e 10 80       	push   $0x80107e4b
801014d1:	68 00 1a 11 80       	push   $0x80111a00
801014d6:	e8 55 35 00 00       	call   80104a30 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 52 7e 10 80       	push   $0x80107e52
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 2c 34 00 00       	call   80104920 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014f4:	83 c4 10             	add    $0x10,%esp
801014f7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014fd:	75 e1                	jne    801014e0 <iinit+0x20>
  readsb(dev, &sb);
801014ff:	83 ec 08             	sub    $0x8,%esp
80101502:	68 e0 19 11 80       	push   $0x801119e0
80101507:	ff 75 08             	pushl  0x8(%ebp)
8010150a:	e8 f1 fe ff ff       	call   80101400 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010150f:	ff 35 f8 19 11 80    	pushl  0x801119f8
80101515:	ff 35 f4 19 11 80    	pushl  0x801119f4
8010151b:	ff 35 f0 19 11 80    	pushl  0x801119f0
80101521:	ff 35 ec 19 11 80    	pushl  0x801119ec
80101527:	ff 35 e8 19 11 80    	pushl  0x801119e8
8010152d:	ff 35 e4 19 11 80    	pushl  0x801119e4
80101533:	ff 35 e0 19 11 80    	pushl  0x801119e0
80101539:	68 fc 7e 10 80       	push   $0x80107efc
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
80101559:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
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
8010158f:	39 1d e8 19 11 80    	cmp    %ebx,0x801119e8
80101595:	76 69                	jbe    80101600 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101597:	89 d8                	mov    %ebx,%eax
80101599:	83 ec 08             	sub    $0x8,%esp
8010159c:	c1 e8 03             	shr    $0x3,%eax
8010159f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
801015ce:	e8 cd 36 00 00       	call   80104ca0 <memset>
      dip->type = type;
801015d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015dd:	89 3c 24             	mov    %edi,(%esp)
801015e0:	e8 db 1b 00 00       	call   801031c0 <log_write>
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
80101603:	68 58 7e 10 80       	push   $0x80107e58
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
80101624:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101671:	e8 da 36 00 00       	call   80104d50 <memmove>
  log_write(bp);
80101676:	89 34 24             	mov    %esi,(%esp)
80101679:	e8 42 1b 00 00       	call   801031c0 <log_write>
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
8010169a:	68 00 1a 11 80       	push   $0x80111a00
8010169f:	e8 7c 34 00 00       	call   80104b20 <acquire>
  ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016a8:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801016af:	e8 8c 35 00 00       	call   80104c40 <release>
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
801016e2:	e8 79 32 00 00       	call   80104960 <acquiresleep>
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
80101709:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101758:	e8 f3 35 00 00       	call   80104d50 <memmove>
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
8010177d:	68 70 7e 10 80       	push   $0x80107e70
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 6a 7e 10 80       	push   $0x80107e6a
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
801017b3:	e8 48 32 00 00       	call   80104a00 <holdingsleep>
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
801017cf:	e9 ec 31 00 00       	jmp    801049c0 <releasesleep>
    panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 7f 7e 10 80       	push   $0x80107e7f
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
80101800:	e8 5b 31 00 00       	call   80104960 <acquiresleep>
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
8010181a:	e8 a1 31 00 00       	call   801049c0 <releasesleep>
  acquire(&icache.lock);
8010181f:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101826:	e8 f5 32 00 00       	call   80104b20 <acquire>
  ip->ref--;
8010182b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
80101839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5f                   	pop    %edi
8010183f:	5d                   	pop    %ebp
  release(&icache.lock);
80101840:	e9 fb 33 00 00       	jmp    80104c40 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 00 1a 11 80       	push   $0x80111a00
80101850:	e8 cb 32 00 00       	call   80104b20 <acquire>
    int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101858:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010185f:	e8 dc 33 00 00       	call   80104c40 <release>
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
80101a47:	e8 04 33 00 00       	call   80104d50 <memmove>
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
80101a7a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
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
80101b43:	e8 08 32 00 00       	call   80104d50 <memmove>
    log_write(bp);
80101b48:	89 3c 24             	mov    %edi,(%esp)
80101b4b:	e8 70 16 00 00       	call   801031c0 <log_write>
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
80101b8a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
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
80101bde:	e8 dd 31 00 00       	call   80104dc0 <strncmp>
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
80101c3d:	e8 7e 31 00 00       	call   80104dc0 <strncmp>
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
80101c82:	68 99 7e 10 80       	push   $0x80107e99
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 87 7e 10 80       	push   $0x80107e87
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
80101cb9:	e8 42 20 00 00       	call   80103d00 <myproc>
  acquire(&icache.lock);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cc1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cc4:	68 00 1a 11 80       	push   $0x80111a00
80101cc9:	e8 52 2e 00 00       	call   80104b20 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101cd9:	e8 62 2f 00 00       	call   80104c40 <release>
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
80101d35:	e8 16 30 00 00       	call   80104d50 <memmove>
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
80101dc8:	e8 83 2f 00 00       	call   80104d50 <memmove>
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
80101ebd:	e8 5e 2f 00 00       	call   80104e20 <strncpy>
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
80101efb:	68 a8 7e 10 80       	push   $0x80107ea8
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 31 85 10 80       	push   $0x80108531
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
80102001:	68 b5 7e 10 80       	push   $0x80107eb5
80102006:	56                   	push   %esi
80102007:	e8 44 2d 00 00       	call   80104d50 <memmove>
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
80102034:	e8 b7 0f 00 00       	call   80102ff0 <begin_op>
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
80102062:	68 bd 7e 10 80       	push   $0x80107ebd
80102067:	53                   	push   %ebx
80102068:	e8 53 2d 00 00       	call   80104dc0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010206d:	83 c4 10             	add    $0x10,%esp
80102070:	85 c0                	test   %eax,%eax
80102072:	0f 84 f8 00 00 00    	je     80102170 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102078:	83 ec 04             	sub    $0x4,%esp
8010207b:	6a 0e                	push   $0xe
8010207d:	68 bc 7e 10 80       	push   $0x80107ebc
80102082:	53                   	push   %ebx
80102083:	e8 38 2d 00 00       	call   80104dc0 <strncmp>
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
801020d7:	e8 c4 2b 00 00       	call   80104ca0 <memset>
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
8010212d:	e8 2e 0f 00 00       	call   80103060 <end_op>

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
80102144:	e8 37 33 00 00       	call   80105480 <isdirempty>
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
80102181:	e8 da 0e 00 00       	call   80103060 <end_op>
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
801021ba:	e8 a1 0e 00 00       	call   80103060 <end_op>
    return -1;
801021bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c4:	e9 6e ff ff ff       	jmp    80102137 <removeSwapFile+0x147>
    panic("unlink: writei");
801021c9:	83 ec 0c             	sub    $0xc,%esp
801021cc:	68 d1 7e 10 80       	push   $0x80107ed1
801021d1:	e8 ba e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021d6:	83 ec 0c             	sub    $0xc,%esp
801021d9:	68 bf 7e 10 80       	push   $0x80107ebf
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
80102200:	68 b5 7e 10 80       	push   $0x80107eb5
80102205:	56                   	push   %esi
80102206:	e8 45 2b 00 00       	call   80104d50 <memmove>
    itoa(p->pid, path + 6);
8010220b:	58                   	pop    %eax
8010220c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010220f:	5a                   	pop    %edx
80102210:	50                   	push   %eax
80102211:	ff 73 10             	pushl  0x10(%ebx)
80102214:	e8 47 fd ff ff       	call   80101f60 <itoa>

    begin_op();
80102219:	e8 d2 0d 00 00       	call   80102ff0 <begin_op>
    struct inode *in = create(path, T_FILE, 0, 0);
8010221e:	6a 00                	push   $0x0
80102220:	6a 00                	push   $0x0
80102222:	6a 02                	push   $0x2
80102224:	56                   	push   %esi
80102225:	e8 66 34 00 00       	call   80105690 <create>
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
80102268:	e8 f3 0d 00 00       	call   80103060 <end_op>

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
80102279:	68 e0 7e 10 80       	push   $0x80107ee0
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
801023ab:	68 58 7f 10 80       	push   $0x80107f58
801023b0:	e8 db df ff ff       	call   80100390 <panic>
    panic("idestart");
801023b5:	83 ec 0c             	sub    $0xc,%esp
801023b8:	68 4f 7f 10 80       	push   $0x80107f4f
801023bd:	e8 ce df ff ff       	call   80100390 <panic>
801023c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <ideinit>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023d6:	68 6a 7f 10 80       	push   $0x80107f6a
801023db:	68 80 b5 10 80       	push   $0x8010b580
801023e0:	e8 4b 26 00 00       	call   80104a30 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023e5:	58                   	pop    %eax
801023e6:	a1 20 3d 11 80       	mov    0x80113d20,%eax
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
8010245e:	e8 bd 26 00 00       	call   80104b20 <acquire>

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
801024c1:	e8 5a 22 00 00       	call   80104720 <wakeup>

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
801024df:	e8 5c 27 00 00       	call   80104c40 <release>

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
801024fe:	e8 fd 24 00 00       	call   80104a00 <holdingsleep>
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
80102538:	e8 e3 25 00 00       	call   80104b20 <acquire>

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
80102589:	e8 22 1f 00 00       	call   801044b0 <sleep>
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
801025a6:	e9 95 26 00 00       	jmp    80104c40 <release>
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
801025ca:	68 84 7f 10 80       	push   $0x80107f84
801025cf:	e8 bc dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	68 6e 7f 10 80       	push   $0x80107f6e
801025dc:	e8 af dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025e1:	83 ec 0c             	sub    $0xc,%esp
801025e4:	68 99 7f 10 80       	push   $0x80107f99
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
801025f1:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
801025f8:	00 c0 fe 
{
801025fb:	89 e5                	mov    %esp,%ebp
801025fd:	56                   	push   %esi
801025fe:	53                   	push   %ebx
  ioapic->reg = reg;
801025ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102606:	00 00 00 
  return ioapic->data;
80102609:	a1 54 36 11 80       	mov    0x80113654,%eax
8010260e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102617:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010261d:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
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
80102637:	68 b8 7f 10 80       	push   $0x80107fb8
8010263c:	e8 1f e0 ff ff       	call   80100660 <cprintf>
80102641:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102662:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

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
80102680:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
801026a1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
801026b5:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801026c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026c6:	a1 54 36 11 80       	mov    0x80113654,%eax
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

801026e0 <kallocCount>:
int
kallocCount(void)
{
  struct run *r;
  int count = 0;
  if(kmem.use_lock)
801026e0:	8b 15 94 36 11 80    	mov    0x80113694,%edx
801026e6:	85 d2                	test   %edx,%edx
801026e8:	75 26                	jne    80102710 <kallocCount+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026ea:	8b 15 98 36 11 80    	mov    0x80113698,%edx
  while(r){
801026f0:	85 d2                	test   %edx,%edx
801026f2:	74 14                	je     80102708 <kallocCount+0x28>
801026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    count++;
    kmem.freelist = r->next;
801026f8:	8b 02                	mov    (%edx),%eax
801026fa:	a3 98 36 11 80       	mov    %eax,0x80113698
801026ff:	eb f7                	jmp    801026f8 <kallocCount+0x18>
80102701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return count;
}
80102708:	31 c0                	xor    %eax,%eax
8010270a:	c3                   	ret    
8010270b:	90                   	nop
8010270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	83 ec 14             	sub    $0x14,%esp
    acquire(&kmem.lock);
80102716:	68 60 36 11 80       	push   $0x80113660
8010271b:	e8 00 24 00 00       	call   80104b20 <acquire>
  r = kmem.freelist;
80102720:	8b 15 98 36 11 80    	mov    0x80113698,%edx
  while(r){
80102726:	83 c4 10             	add    $0x10,%esp
80102729:	85 d2                	test   %edx,%edx
8010272b:	74 13                	je     80102740 <kallocCount+0x60>
8010272d:	8d 76 00             	lea    0x0(%esi),%esi
    kmem.freelist = r->next;
80102730:	8b 02                	mov    (%edx),%eax
80102732:	a3 98 36 11 80       	mov    %eax,0x80113698
80102737:	eb f7                	jmp    80102730 <kallocCount+0x50>
80102739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
80102740:	a1 94 36 11 80       	mov    0x80113694,%eax
80102745:	85 c0                	test   %eax,%eax
80102747:	74 10                	je     80102759 <kallocCount+0x79>
    release(&kmem.lock);
80102749:	83 ec 0c             	sub    $0xc,%esp
8010274c:	68 60 36 11 80       	push   $0x80113660
80102751:	e8 ea 24 00 00       	call   80104c40 <release>
80102756:	83 c4 10             	add    $0x10,%esp
}
80102759:	31 c0                	xor    %eax,%eax
8010275b:	c9                   	leave  
8010275c:	c3                   	ret    
8010275d:	8d 76 00             	lea    0x0(%esi),%esi

80102760 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	53                   	push   %ebx
80102764:	83 ec 04             	sub    $0x4,%esp
80102767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010276a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102770:	75 70                	jne    801027e2 <kfree+0x82>
80102772:	81 fb ec 6c 12 80    	cmp    $0x80126cec,%ebx
80102778:	72 68                	jb     801027e2 <kfree+0x82>
8010277a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102780:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102785:	77 5b                	ja     801027e2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102787:	83 ec 04             	sub    $0x4,%esp
8010278a:	68 00 10 00 00       	push   $0x1000
8010278f:	6a 01                	push   $0x1
80102791:	53                   	push   %ebx
80102792:	e8 09 25 00 00       	call   80104ca0 <memset>

  if(kmem.use_lock)
80102797:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010279d:	83 c4 10             	add    $0x10,%esp
801027a0:	85 d2                	test   %edx,%edx
801027a2:	75 2c                	jne    801027d0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801027a4:	a1 98 36 11 80       	mov    0x80113698,%eax
801027a9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801027ab:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
801027b0:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
801027b6:	85 c0                	test   %eax,%eax
801027b8:	75 06                	jne    801027c0 <kfree+0x60>
    release(&kmem.lock);
}
801027ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027bd:	c9                   	leave  
801027be:	c3                   	ret    
801027bf:	90                   	nop
    release(&kmem.lock);
801027c0:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
801027c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ca:	c9                   	leave  
    release(&kmem.lock);
801027cb:	e9 70 24 00 00       	jmp    80104c40 <release>
    acquire(&kmem.lock);
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	68 60 36 11 80       	push   $0x80113660
801027d8:	e8 43 23 00 00       	call   80104b20 <acquire>
801027dd:	83 c4 10             	add    $0x10,%esp
801027e0:	eb c2                	jmp    801027a4 <kfree+0x44>
    panic("kfree");
801027e2:	83 ec 0c             	sub    $0xc,%esp
801027e5:	68 ea 7f 10 80       	push   $0x80107fea
801027ea:	e8 a1 db ff ff       	call   80100390 <panic>
801027ef:	90                   	nop

801027f0 <freerange>:
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	56                   	push   %esi
801027f4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027f5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801027fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102801:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102807:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010280d:	39 de                	cmp    %ebx,%esi
8010280f:	72 23                	jb     80102834 <freerange+0x44>
80102811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102818:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010281e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102821:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102827:	50                   	push   %eax
80102828:	e8 33 ff ff ff       	call   80102760 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010282d:	83 c4 10             	add    $0x10,%esp
80102830:	39 f3                	cmp    %esi,%ebx
80102832:	76 e4                	jbe    80102818 <freerange+0x28>
}
80102834:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102837:	5b                   	pop    %ebx
80102838:	5e                   	pop    %esi
80102839:	5d                   	pop    %ebp
8010283a:	c3                   	ret    
8010283b:	90                   	nop
8010283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102840 <kinit1>:
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
80102843:	56                   	push   %esi
80102844:	53                   	push   %ebx
80102845:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102848:	83 ec 08             	sub    $0x8,%esp
8010284b:	68 f0 7f 10 80       	push   $0x80107ff0
80102850:	68 60 36 11 80       	push   $0x80113660
80102855:	e8 d6 21 00 00       	call   80104a30 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010285a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010285d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102860:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102867:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010286a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102870:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102876:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010287c:	39 de                	cmp    %ebx,%esi
8010287e:	72 1c                	jb     8010289c <kinit1+0x5c>
    kfree(p);
80102880:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102886:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102889:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010288f:	50                   	push   %eax
80102890:	e8 cb fe ff ff       	call   80102760 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102895:	83 c4 10             	add    $0x10,%esp
80102898:	39 de                	cmp    %ebx,%esi
8010289a:	73 e4                	jae    80102880 <kinit1+0x40>
}
8010289c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010289f:	5b                   	pop    %ebx
801028a0:	5e                   	pop    %esi
801028a1:	5d                   	pop    %ebp
801028a2:	c3                   	ret    
801028a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028b0 <kinit2>:
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	56                   	push   %esi
801028b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801028bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028cd:	39 de                	cmp    %ebx,%esi
801028cf:	72 23                	jb     801028f4 <kinit2+0x44>
801028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801028d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028e7:	50                   	push   %eax
801028e8:	e8 73 fe ff ff       	call   80102760 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ed:	83 c4 10             	add    $0x10,%esp
801028f0:	39 de                	cmp    %ebx,%esi
801028f2:	73 e4                	jae    801028d8 <kinit2+0x28>
  kmem.use_lock = 1;
801028f4:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
801028fb:	00 00 00 
}
801028fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102901:	5b                   	pop    %ebx
80102902:	5e                   	pop    %esi
80102903:	5d                   	pop    %ebp
80102904:	c3                   	ret    
80102905:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102910 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102910:	a1 94 36 11 80       	mov    0x80113694,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	75 1f                	jne    80102938 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102919:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010291e:	85 c0                	test   %eax,%eax
80102920:	74 0e                	je     80102930 <kalloc+0x20>
    kmem.freelist = r->next;
80102922:	8b 10                	mov    (%eax),%edx
80102924:	89 15 98 36 11 80    	mov    %edx,0x80113698
8010292a:	c3                   	ret    
8010292b:	90                   	nop
8010292c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102930:	f3 c3                	repz ret 
80102932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102938:	55                   	push   %ebp
80102939:	89 e5                	mov    %esp,%ebp
8010293b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010293e:	68 60 36 11 80       	push   $0x80113660
80102943:	e8 d8 21 00 00       	call   80104b20 <acquire>
  r = kmem.freelist;
80102948:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010294d:	83 c4 10             	add    $0x10,%esp
80102950:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102956:	85 c0                	test   %eax,%eax
80102958:	74 08                	je     80102962 <kalloc+0x52>
    kmem.freelist = r->next;
8010295a:	8b 08                	mov    (%eax),%ecx
8010295c:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102962:	85 d2                	test   %edx,%edx
80102964:	74 16                	je     8010297c <kalloc+0x6c>
    release(&kmem.lock);
80102966:	83 ec 0c             	sub    $0xc,%esp
80102969:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010296c:	68 60 36 11 80       	push   $0x80113660
80102971:	e8 ca 22 00 00       	call   80104c40 <release>
  return (char*)r;
80102976:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102979:	83 c4 10             	add    $0x10,%esp
}
8010297c:	c9                   	leave  
8010297d:	c3                   	ret    
8010297e:	66 90                	xchg   %ax,%ax

80102980 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102980:	ba 64 00 00 00       	mov    $0x64,%edx
80102985:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102986:	a8 01                	test   $0x1,%al
80102988:	0f 84 c2 00 00 00    	je     80102a50 <kbdgetc+0xd0>
8010298e:	ba 60 00 00 00       	mov    $0x60,%edx
80102993:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102994:	0f b6 d0             	movzbl %al,%edx
80102997:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010299d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801029a3:	0f 84 7f 00 00 00    	je     80102a28 <kbdgetc+0xa8>
{
801029a9:	55                   	push   %ebp
801029aa:	89 e5                	mov    %esp,%ebp
801029ac:	53                   	push   %ebx
801029ad:	89 cb                	mov    %ecx,%ebx
801029af:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801029b2:	84 c0                	test   %al,%al
801029b4:	78 4a                	js     80102a00 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801029b6:	85 db                	test   %ebx,%ebx
801029b8:	74 09                	je     801029c3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029ba:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801029bd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801029c0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801029c3:	0f b6 82 20 81 10 80 	movzbl -0x7fef7ee0(%edx),%eax
801029ca:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801029cc:	0f b6 82 20 80 10 80 	movzbl -0x7fef7fe0(%edx),%eax
801029d3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029d5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801029d7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801029dd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801029e0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029e3:	8b 04 85 00 80 10 80 	mov    -0x7fef8000(,%eax,4),%eax
801029ea:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801029ee:	74 31                	je     80102a21 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801029f0:	8d 50 9f             	lea    -0x61(%eax),%edx
801029f3:	83 fa 19             	cmp    $0x19,%edx
801029f6:	77 40                	ja     80102a38 <kbdgetc+0xb8>
      c += 'A' - 'a';
801029f8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029fb:	5b                   	pop    %ebx
801029fc:	5d                   	pop    %ebp
801029fd:	c3                   	ret    
801029fe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102a00:	83 e0 7f             	and    $0x7f,%eax
80102a03:	85 db                	test   %ebx,%ebx
80102a05:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102a08:	0f b6 82 20 81 10 80 	movzbl -0x7fef7ee0(%edx),%eax
80102a0f:	83 c8 40             	or     $0x40,%eax
80102a12:	0f b6 c0             	movzbl %al,%eax
80102a15:	f7 d0                	not    %eax
80102a17:	21 c1                	and    %eax,%ecx
    return 0;
80102a19:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102a1b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102a21:	5b                   	pop    %ebx
80102a22:	5d                   	pop    %ebp
80102a23:	c3                   	ret    
80102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102a28:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102a2b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a2d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102a33:	c3                   	ret    
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102a38:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a3b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102a3e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102a3f:	83 f9 1a             	cmp    $0x1a,%ecx
80102a42:	0f 42 c2             	cmovb  %edx,%eax
}
80102a45:	5d                   	pop    %ebp
80102a46:	c3                   	ret    
80102a47:	89 f6                	mov    %esi,%esi
80102a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a55:	c3                   	ret    
80102a56:	8d 76 00             	lea    0x0(%esi),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <kbdintr>:

void
kbdintr(void)
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a66:	68 80 29 10 80       	push   $0x80102980
80102a6b:	e8 a0 dd ff ff       	call   80100810 <consoleintr>
}
80102a70:	83 c4 10             	add    $0x10,%esp
80102a73:	c9                   	leave  
80102a74:	c3                   	ret    
80102a75:	66 90                	xchg   %ax,%ax
80102a77:	66 90                	xchg   %ax,%ax
80102a79:	66 90                	xchg   %ax,%ax
80102a7b:	66 90                	xchg   %ax,%ax
80102a7d:	66 90                	xchg   %ax,%ax
80102a7f:	90                   	nop

80102a80 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a80:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102a85:	55                   	push   %ebp
80102a86:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a88:	85 c0                	test   %eax,%eax
80102a8a:	0f 84 c8 00 00 00    	je     80102b58 <lapicinit+0xd8>
  lapic[index] = value;
80102a90:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a97:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a9d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102aa4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aaa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102ab1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ab7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102abe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ac4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102acb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ace:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ad1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ad8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102adb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ade:	8b 50 30             	mov    0x30(%eax),%edx
80102ae1:	c1 ea 10             	shr    $0x10,%edx
80102ae4:	80 fa 03             	cmp    $0x3,%dl
80102ae7:	77 77                	ja     80102b60 <lapicinit+0xe0>
  lapic[index] = value;
80102ae9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102af0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102af6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102afd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b00:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b03:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b0a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b0d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b10:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b17:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b1a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b1d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b2a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b31:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b34:	8b 50 20             	mov    0x20(%eax),%edx
80102b37:	89 f6                	mov    %esi,%esi
80102b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102b40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102b46:	80 e6 10             	and    $0x10,%dh
80102b49:	75 f5                	jne    80102b40 <lapicinit+0xc0>
  lapic[index] = value;
80102b4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b55:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b58:	5d                   	pop    %ebp
80102b59:	c3                   	ret    
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102b60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6a:	8b 50 20             	mov    0x20(%eax),%edx
80102b6d:	e9 77 ff ff ff       	jmp    80102ae9 <lapicinit+0x69>
80102b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b80:	8b 15 9c 36 11 80    	mov    0x8011369c,%edx
{
80102b86:	55                   	push   %ebp
80102b87:	31 c0                	xor    %eax,%eax
80102b89:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b8b:	85 d2                	test   %edx,%edx
80102b8d:	74 06                	je     80102b95 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102b8f:	8b 42 20             	mov    0x20(%edx),%eax
80102b92:	c1 e8 18             	shr    $0x18,%eax
}
80102b95:	5d                   	pop    %ebp
80102b96:	c3                   	ret    
80102b97:	89 f6                	mov    %esi,%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ba0:	a1 9c 36 11 80       	mov    0x8011369c,%eax
{
80102ba5:	55                   	push   %ebp
80102ba6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ba8:	85 c0                	test   %eax,%eax
80102baa:	74 0d                	je     80102bb9 <lapiceoi+0x19>
  lapic[index] = value;
80102bac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bb3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102bb9:	5d                   	pop    %ebp
80102bba:	c3                   	ret    
80102bbb:	90                   	nop
80102bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102bc0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
}
80102bc3:	5d                   	pop    %ebp
80102bc4:	c3                   	ret    
80102bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bd0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102bd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102bd6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bdb:	89 e5                	mov    %esp,%ebp
80102bdd:	53                   	push   %ebx
80102bde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102be1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102be4:	ee                   	out    %al,(%dx)
80102be5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bea:	ba 71 00 00 00       	mov    $0x71,%edx
80102bef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102bf0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102bf2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102bf5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102bfb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bfd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102c00:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102c03:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c05:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c08:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c0e:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102c13:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c19:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c1c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c23:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c26:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c29:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c30:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c33:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c36:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c3c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c3f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c45:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c48:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c51:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c57:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102c5a:	5b                   	pop    %ebx
80102c5b:	5d                   	pop    %ebp
80102c5c:	c3                   	ret    
80102c5d:	8d 76 00             	lea    0x0(%esi),%esi

80102c60 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102c60:	55                   	push   %ebp
80102c61:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c66:	ba 70 00 00 00       	mov    $0x70,%edx
80102c6b:	89 e5                	mov    %esp,%ebp
80102c6d:	57                   	push   %edi
80102c6e:	56                   	push   %esi
80102c6f:	53                   	push   %ebx
80102c70:	83 ec 4c             	sub    $0x4c,%esp
80102c73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c74:	ba 71 00 00 00       	mov    $0x71,%edx
80102c79:	ec                   	in     (%dx),%al
80102c7a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c82:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c85:	8d 76 00             	lea    0x0(%esi),%esi
80102c88:	31 c0                	xor    %eax,%eax
80102c8a:	89 da                	mov    %ebx,%edx
80102c8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c92:	89 ca                	mov    %ecx,%edx
80102c94:	ec                   	in     (%dx),%al
80102c95:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c98:	89 da                	mov    %ebx,%edx
80102c9a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca0:	89 ca                	mov    %ecx,%edx
80102ca2:	ec                   	in     (%dx),%al
80102ca3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca6:	89 da                	mov    %ebx,%edx
80102ca8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cae:	89 ca                	mov    %ecx,%edx
80102cb0:	ec                   	in     (%dx),%al
80102cb1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb4:	89 da                	mov    %ebx,%edx
80102cb6:	b8 07 00 00 00       	mov    $0x7,%eax
80102cbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbc:	89 ca                	mov    %ecx,%edx
80102cbe:	ec                   	in     (%dx),%al
80102cbf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc2:	89 da                	mov    %ebx,%edx
80102cc4:	b8 08 00 00 00       	mov    $0x8,%eax
80102cc9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cca:	89 ca                	mov    %ecx,%edx
80102ccc:	ec                   	in     (%dx),%al
80102ccd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ccf:	89 da                	mov    %ebx,%edx
80102cd1:	b8 09 00 00 00       	mov    $0x9,%eax
80102cd6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd7:	89 ca                	mov    %ecx,%edx
80102cd9:	ec                   	in     (%dx),%al
80102cda:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cdc:	89 da                	mov    %ebx,%edx
80102cde:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ce3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce4:	89 ca                	mov    %ecx,%edx
80102ce6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ce7:	84 c0                	test   %al,%al
80102ce9:	78 9d                	js     80102c88 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102ceb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102cef:	89 fa                	mov    %edi,%edx
80102cf1:	0f b6 fa             	movzbl %dl,%edi
80102cf4:	89 f2                	mov    %esi,%edx
80102cf6:	0f b6 f2             	movzbl %dl,%esi
80102cf9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cfc:	89 da                	mov    %ebx,%edx
80102cfe:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d01:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d04:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d08:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d0b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d0f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d12:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d19:	31 c0                	xor    %eax,%eax
80102d1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d1c:	89 ca                	mov    %ecx,%edx
80102d1e:	ec                   	in     (%dx),%al
80102d1f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d22:	89 da                	mov    %ebx,%edx
80102d24:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d27:	b8 02 00 00 00       	mov    $0x2,%eax
80102d2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2d:	89 ca                	mov    %ecx,%edx
80102d2f:	ec                   	in     (%dx),%al
80102d30:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d33:	89 da                	mov    %ebx,%edx
80102d35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d38:	b8 04 00 00 00       	mov    $0x4,%eax
80102d3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d3e:	89 ca                	mov    %ecx,%edx
80102d40:	ec                   	in     (%dx),%al
80102d41:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d44:	89 da                	mov    %ebx,%edx
80102d46:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d49:	b8 07 00 00 00       	mov    $0x7,%eax
80102d4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d4f:	89 ca                	mov    %ecx,%edx
80102d51:	ec                   	in     (%dx),%al
80102d52:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d55:	89 da                	mov    %ebx,%edx
80102d57:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d5a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d60:	89 ca                	mov    %ecx,%edx
80102d62:	ec                   	in     (%dx),%al
80102d63:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d66:	89 da                	mov    %ebx,%edx
80102d68:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d6b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d70:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d71:	89 ca                	mov    %ecx,%edx
80102d73:	ec                   	in     (%dx),%al
80102d74:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d77:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102d7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d7d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d80:	6a 18                	push   $0x18
80102d82:	50                   	push   %eax
80102d83:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d86:	50                   	push   %eax
80102d87:	e8 64 1f 00 00       	call   80104cf0 <memcmp>
80102d8c:	83 c4 10             	add    $0x10,%esp
80102d8f:	85 c0                	test   %eax,%eax
80102d91:	0f 85 f1 fe ff ff    	jne    80102c88 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d97:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d9b:	75 78                	jne    80102e15 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102da0:	89 c2                	mov    %eax,%edx
80102da2:	83 e0 0f             	and    $0xf,%eax
80102da5:	c1 ea 04             	shr    $0x4,%edx
80102da8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102db1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102db4:	89 c2                	mov    %eax,%edx
80102db6:	83 e0 0f             	and    $0xf,%eax
80102db9:	c1 ea 04             	shr    $0x4,%edx
80102dbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dc2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102dc5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102dc8:	89 c2                	mov    %eax,%edx
80102dca:	83 e0 0f             	and    $0xf,%eax
80102dcd:	c1 ea 04             	shr    $0x4,%edx
80102dd0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dd3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dd6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102dd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ddc:	89 c2                	mov    %eax,%edx
80102dde:	83 e0 0f             	and    $0xf,%eax
80102de1:	c1 ea 04             	shr    $0x4,%edx
80102de4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102de7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ded:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102df0:	89 c2                	mov    %eax,%edx
80102df2:	83 e0 0f             	and    $0xf,%eax
80102df5:	c1 ea 04             	shr    $0x4,%edx
80102df8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dfb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dfe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e01:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e04:	89 c2                	mov    %eax,%edx
80102e06:	83 e0 0f             	and    $0xf,%eax
80102e09:	c1 ea 04             	shr    $0x4,%edx
80102e0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e12:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e15:	8b 75 08             	mov    0x8(%ebp),%esi
80102e18:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e1b:	89 06                	mov    %eax,(%esi)
80102e1d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e20:	89 46 04             	mov    %eax,0x4(%esi)
80102e23:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e26:	89 46 08             	mov    %eax,0x8(%esi)
80102e29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e2c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e2f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e32:	89 46 10             	mov    %eax,0x10(%esi)
80102e35:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e38:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102e3b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e45:	5b                   	pop    %ebx
80102e46:	5e                   	pop    %esi
80102e47:	5f                   	pop    %edi
80102e48:	5d                   	pop    %ebp
80102e49:	c3                   	ret    
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e50:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e56:	85 c9                	test   %ecx,%ecx
80102e58:	0f 8e 8a 00 00 00    	jle    80102ee8 <install_trans+0x98>
{
80102e5e:	55                   	push   %ebp
80102e5f:	89 e5                	mov    %esp,%ebp
80102e61:	57                   	push   %edi
80102e62:	56                   	push   %esi
80102e63:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102e64:	31 db                	xor    %ebx,%ebx
{
80102e66:	83 ec 0c             	sub    $0xc,%esp
80102e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e70:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102e94:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
80102ea2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ea4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102ea7:	83 c4 0c             	add    $0xc,%esp
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 97 1e 00 00       	call   80104d50 <memmove>
    bwrite(dbuf);  // write dst to disk
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 df d2 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 17 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 0f d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102eda:	7f 94                	jg     80102e70 <install_trans+0x20>
  }
}
80102edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102edf:	5b                   	pop    %ebx
80102ee0:	5e                   	pop    %esi
80102ee1:	5f                   	pop    %edi
80102ee2:	5d                   	pop    %ebp
80102ee3:	c3                   	ret    
80102ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ee8:	f3 c3                	repz ret 
80102eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ef0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	56                   	push   %esi
80102ef4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ef5:	83 ec 08             	sub    $0x8,%esp
80102ef8:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102efe:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102f04:	e8 c7 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102f09:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f0f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f12:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102f14:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102f16:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102f19:	7e 16                	jle    80102f31 <write_head+0x41>
80102f1b:	c1 e3 02             	shl    $0x2,%ebx
80102f1e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102f20:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102f26:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102f2a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102f2d:	39 da                	cmp    %ebx,%edx
80102f2f:	75 ef                	jne    80102f20 <write_head+0x30>
  }
  bwrite(buf);
80102f31:	83 ec 0c             	sub    $0xc,%esp
80102f34:	56                   	push   %esi
80102f35:	e8 66 d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102f3a:	89 34 24             	mov    %esi,(%esp)
80102f3d:	e8 9e d2 ff ff       	call   801001e0 <brelse>
}
80102f42:	83 c4 10             	add    $0x10,%esp
80102f45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f48:	5b                   	pop    %ebx
80102f49:	5e                   	pop    %esi
80102f4a:	5d                   	pop    %ebp
80102f4b:	c3                   	ret    
80102f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f50 <initlog>:
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	53                   	push   %ebx
80102f54:	83 ec 2c             	sub    $0x2c,%esp
80102f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102f5a:	68 20 82 10 80       	push   $0x80108220
80102f5f:	68 a0 36 11 80       	push   $0x801136a0
80102f64:	e8 c7 1a 00 00       	call   80104a30 <initlock>
  readsb(dev, &sb);
80102f69:	58                   	pop    %eax
80102f6a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f6d:	5a                   	pop    %edx
80102f6e:	50                   	push   %eax
80102f6f:	53                   	push   %ebx
80102f70:	e8 8b e4 ff ff       	call   80101400 <readsb>
  log.size = sb.nlog;
80102f75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f7b:	59                   	pop    %ecx
  log.dev = dev;
80102f7c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102f82:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  log.start = sb.logstart;
80102f88:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  struct buf *buf = bread(log.dev, log.start);
80102f8d:	5a                   	pop    %edx
80102f8e:	50                   	push   %eax
80102f8f:	53                   	push   %ebx
80102f90:	e8 3b d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102f95:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f98:	83 c4 10             	add    $0x10,%esp
80102f9b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102f9d:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102fa3:	7e 1c                	jle    80102fc1 <initlog+0x71>
80102fa5:	c1 e3 02             	shl    $0x2,%ebx
80102fa8:	31 d2                	xor    %edx,%edx
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102fb0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102fb4:	83 c2 04             	add    $0x4,%edx
80102fb7:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102fbd:	39 d3                	cmp    %edx,%ebx
80102fbf:	75 ef                	jne    80102fb0 <initlog+0x60>
  brelse(buf);
80102fc1:	83 ec 0c             	sub    $0xc,%esp
80102fc4:	50                   	push   %eax
80102fc5:	e8 16 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102fca:	e8 81 fe ff ff       	call   80102e50 <install_trans>
  log.lh.n = 0;
80102fcf:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102fd6:	00 00 00 
  write_head(); // clear the log
80102fd9:	e8 12 ff ff ff       	call   80102ef0 <write_head>
}
80102fde:	83 c4 10             	add    $0x10,%esp
80102fe1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fe4:	c9                   	leave  
80102fe5:	c3                   	ret    
80102fe6:	8d 76 00             	lea    0x0(%esi),%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ff0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ff6:	68 a0 36 11 80       	push   $0x801136a0
80102ffb:	e8 20 1b 00 00       	call   80104b20 <acquire>
80103000:	83 c4 10             	add    $0x10,%esp
80103003:	eb 18                	jmp    8010301d <begin_op+0x2d>
80103005:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103008:	83 ec 08             	sub    $0x8,%esp
8010300b:	68 a0 36 11 80       	push   $0x801136a0
80103010:	68 a0 36 11 80       	push   $0x801136a0
80103015:	e8 96 14 00 00       	call   801044b0 <sleep>
8010301a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010301d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80103022:	85 c0                	test   %eax,%eax
80103024:	75 e2                	jne    80103008 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103026:	a1 dc 36 11 80       	mov    0x801136dc,%eax
8010302b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80103031:	83 c0 01             	add    $0x1,%eax
80103034:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103037:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010303a:	83 fa 1e             	cmp    $0x1e,%edx
8010303d:	7f c9                	jg     80103008 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010303f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103042:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80103047:	68 a0 36 11 80       	push   $0x801136a0
8010304c:	e8 ef 1b 00 00       	call   80104c40 <release>
      break;
    }
  }
}
80103051:	83 c4 10             	add    $0x10,%esp
80103054:	c9                   	leave  
80103055:	c3                   	ret    
80103056:	8d 76 00             	lea    0x0(%esi),%esi
80103059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103060 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	57                   	push   %edi
80103064:	56                   	push   %esi
80103065:	53                   	push   %ebx
80103066:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103069:	68 a0 36 11 80       	push   $0x801136a0
8010306e:	e8 ad 1a 00 00       	call   80104b20 <acquire>
  log.outstanding -= 1;
80103073:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80103078:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
8010307e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103081:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103084:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103086:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
8010308c:	0f 85 1a 01 00 00    	jne    801031ac <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103092:	85 db                	test   %ebx,%ebx
80103094:	0f 85 ee 00 00 00    	jne    80103188 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010309a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010309d:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
801030a4:	00 00 00 
  release(&log.lock);
801030a7:	68 a0 36 11 80       	push   $0x801136a0
801030ac:	e8 8f 1b 00 00       	call   80104c40 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801030b1:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c9                	test   %ecx,%ecx
801030bc:	0f 8e 85 00 00 00    	jle    80103147 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801030c2:	a1 d4 36 11 80       	mov    0x801136d4,%eax
801030c7:	83 ec 08             	sub    $0x8,%esp
801030ca:	01 d8                	add    %ebx,%eax
801030cc:	83 c0 01             	add    $0x1,%eax
801030cf:	50                   	push   %eax
801030d0:	ff 35 e4 36 11 80    	pushl  0x801136e4
801030d6:	e8 f5 cf ff ff       	call   801000d0 <bread>
801030db:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030dd:	58                   	pop    %eax
801030de:	5a                   	pop    %edx
801030df:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
801030e6:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
801030ec:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030ef:	e8 dc cf ff ff       	call   801000d0 <bread>
801030f4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030f6:	8d 40 5c             	lea    0x5c(%eax),%eax
801030f9:	83 c4 0c             	add    $0xc,%esp
801030fc:	68 00 02 00 00       	push   $0x200
80103101:	50                   	push   %eax
80103102:	8d 46 5c             	lea    0x5c(%esi),%eax
80103105:	50                   	push   %eax
80103106:	e8 45 1c 00 00       	call   80104d50 <memmove>
    bwrite(to);  // write the log
8010310b:	89 34 24             	mov    %esi,(%esp)
8010310e:	e8 8d d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103113:	89 3c 24             	mov    %edi,(%esp)
80103116:	e8 c5 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010311b:	89 34 24             	mov    %esi,(%esp)
8010311e:	e8 bd d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103123:	83 c4 10             	add    $0x10,%esp
80103126:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
8010312c:	7c 94                	jl     801030c2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010312e:	e8 bd fd ff ff       	call   80102ef0 <write_head>
    install_trans(); // Now install writes to home locations
80103133:	e8 18 fd ff ff       	call   80102e50 <install_trans>
    log.lh.n = 0;
80103138:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
8010313f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103142:	e8 a9 fd ff ff       	call   80102ef0 <write_head>
    acquire(&log.lock);
80103147:	83 ec 0c             	sub    $0xc,%esp
8010314a:	68 a0 36 11 80       	push   $0x801136a0
8010314f:	e8 cc 19 00 00       	call   80104b20 <acquire>
    wakeup(&log);
80103154:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
8010315b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80103162:	00 00 00 
    wakeup(&log);
80103165:	e8 b6 15 00 00       	call   80104720 <wakeup>
    release(&log.lock);
8010316a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103171:	e8 ca 1a 00 00       	call   80104c40 <release>
80103176:	83 c4 10             	add    $0x10,%esp
}
80103179:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010317c:	5b                   	pop    %ebx
8010317d:	5e                   	pop    %esi
8010317e:	5f                   	pop    %edi
8010317f:	5d                   	pop    %ebp
80103180:	c3                   	ret    
80103181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103188:	83 ec 0c             	sub    $0xc,%esp
8010318b:	68 a0 36 11 80       	push   $0x801136a0
80103190:	e8 8b 15 00 00       	call   80104720 <wakeup>
  release(&log.lock);
80103195:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
8010319c:	e8 9f 1a 00 00       	call   80104c40 <release>
801031a1:	83 c4 10             	add    $0x10,%esp
}
801031a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a7:	5b                   	pop    %ebx
801031a8:	5e                   	pop    %esi
801031a9:	5f                   	pop    %edi
801031aa:	5d                   	pop    %ebp
801031ab:	c3                   	ret    
    panic("log.committing");
801031ac:	83 ec 0c             	sub    $0xc,%esp
801031af:	68 24 82 10 80       	push   $0x80108224
801031b4:	e8 d7 d1 ff ff       	call   80100390 <panic>
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	53                   	push   %ebx
801031c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031c7:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
801031cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031d0:	83 fa 1d             	cmp    $0x1d,%edx
801031d3:	0f 8f 9d 00 00 00    	jg     80103276 <log_write+0xb6>
801031d9:	a1 d8 36 11 80       	mov    0x801136d8,%eax
801031de:	83 e8 01             	sub    $0x1,%eax
801031e1:	39 c2                	cmp    %eax,%edx
801031e3:	0f 8d 8d 00 00 00    	jge    80103276 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801031e9:	a1 dc 36 11 80       	mov    0x801136dc,%eax
801031ee:	85 c0                	test   %eax,%eax
801031f0:	0f 8e 8d 00 00 00    	jle    80103283 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801031f6:	83 ec 0c             	sub    $0xc,%esp
801031f9:	68 a0 36 11 80       	push   $0x801136a0
801031fe:	e8 1d 19 00 00       	call   80104b20 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103203:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	83 f9 00             	cmp    $0x0,%ecx
8010320f:	7e 57                	jle    80103268 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103211:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103214:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103216:	3b 15 ec 36 11 80    	cmp    0x801136ec,%edx
8010321c:	75 0b                	jne    80103229 <log_write+0x69>
8010321e:	eb 38                	jmp    80103258 <log_write+0x98>
80103220:	39 14 85 ec 36 11 80 	cmp    %edx,-0x7feec914(,%eax,4)
80103227:	74 2f                	je     80103258 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103229:	83 c0 01             	add    $0x1,%eax
8010322c:	39 c1                	cmp    %eax,%ecx
8010322e:	75 f0                	jne    80103220 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103230:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103237:	83 c0 01             	add    $0x1,%eax
8010323a:	a3 e8 36 11 80       	mov    %eax,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
8010323f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103242:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80103249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010324c:	c9                   	leave  
  release(&log.lock);
8010324d:	e9 ee 19 00 00       	jmp    80104c40 <release>
80103252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103258:	89 14 85 ec 36 11 80 	mov    %edx,-0x7feec914(,%eax,4)
8010325f:	eb de                	jmp    8010323f <log_write+0x7f>
80103261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103268:	8b 43 08             	mov    0x8(%ebx),%eax
8010326b:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80103270:	75 cd                	jne    8010323f <log_write+0x7f>
80103272:	31 c0                	xor    %eax,%eax
80103274:	eb c1                	jmp    80103237 <log_write+0x77>
    panic("too big a transaction");
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	68 33 82 10 80       	push   $0x80108233
8010327e:	e8 0d d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103283:	83 ec 0c             	sub    $0xc,%esp
80103286:	68 49 82 10 80       	push   $0x80108249
8010328b:	e8 00 d1 ff ff       	call   80100390 <panic>

80103290 <mpmain>:
  mpmain();
}

// Common CPU setup code.
static void
mpmain(void) {
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	53                   	push   %ebx
80103294:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103297:	e8 44 0a 00 00       	call   80103ce0 <cpuid>
8010329c:	89 c3                	mov    %eax,%ebx
8010329e:	e8 3d 0a 00 00       	call   80103ce0 <cpuid>
801032a3:	83 ec 04             	sub    $0x4,%esp
801032a6:	53                   	push   %ebx
801032a7:	50                   	push   %eax
801032a8:	68 64 82 10 80       	push   $0x80108264
801032ad:	e8 ae d3 ff ff       	call   80100660 <cprintf>
    idtinit();       // load idt register
801032b2:	e8 b9 2c 00 00       	call   80105f70 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
801032b7:	e8 a4 09 00 00       	call   80103c60 <mycpu>
801032bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801032be:	b8 01 00 00 00       	mov    $0x1,%eax
801032c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
801032ca:	e8 e1 0e 00 00       	call   801041b0 <scheduler>
801032cf:	90                   	nop

801032d0 <mpenter>:
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801032d6:	e8 05 3f 00 00       	call   801071e0 <switchkvm>
  seginit();
801032db:	e8 30 3e 00 00       	call   80107110 <seginit>
  lapicinit();
801032e0:	e8 9b f7 ff ff       	call   80102a80 <lapicinit>
  mpmain();
801032e5:	e8 a6 ff ff ff       	call   80103290 <mpmain>
801032ea:	66 90                	xchg   %ax,%ax
801032ec:	66 90                	xchg   %ax,%ax
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <main>:
{
801032f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801032f4:	83 e4 f0             	and    $0xfffffff0,%esp
801032f7:	ff 71 fc             	pushl  -0x4(%ecx)
801032fa:	55                   	push   %ebp
801032fb:	89 e5                	mov    %esp,%ebp
801032fd:	53                   	push   %ebx
801032fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801032ff:	83 ec 08             	sub    $0x8,%esp
80103302:	68 00 00 40 80       	push   $0x80400000
80103307:	68 ec 6c 12 80       	push   $0x80126cec
8010330c:	e8 2f f5 ff ff       	call   80102840 <kinit1>
  kvmalloc();      // kernel page table
80103311:	e8 1a 48 00 00       	call   80107b30 <kvmalloc>
  mpinit();        // detect other processors
80103316:	e8 75 01 00 00       	call   80103490 <mpinit>
  lapicinit();     // interrupt controller
8010331b:	e8 60 f7 ff ff       	call   80102a80 <lapicinit>
  seginit();       // segment descriptors
80103320:	e8 eb 3d 00 00       	call   80107110 <seginit>
  picinit();       // disable pic
80103325:	e8 46 03 00 00       	call   80103670 <picinit>
  ioapicinit();    // another interrupt controller
8010332a:	e8 c1 f2 ff ff       	call   801025f0 <ioapicinit>
  consoleinit();   // console hardware
8010332f:	e8 8c d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103334:	e8 47 31 00 00       	call   80106480 <uartinit>
  pinit();         // process table
80103339:	e8 02 09 00 00       	call   80103c40 <pinit>
  tvinit();        // trap vectors
8010333e:	e8 ad 2b 00 00       	call   80105ef0 <tvinit>
  binit();         // buffer cache
80103343:	e8 f8 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103348:	e8 43 da ff ff       	call   80100d90 <fileinit>
  ideinit();       // disk 
8010334d:	e8 7e f0 ff ff       	call   801023d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103352:	83 c4 0c             	add    $0xc,%esp
80103355:	68 8a 00 00 00       	push   $0x8a
8010335a:	68 8c b4 10 80       	push   $0x8010b48c
8010335f:	68 00 70 00 80       	push   $0x80007000
80103364:	e8 e7 19 00 00       	call   80104d50 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103369:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103370:	00 00 00 
80103373:	83 c4 10             	add    $0x10,%esp
80103376:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010337b:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80103380:	76 71                	jbe    801033f3 <main+0x103>
80103382:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80103387:	89 f6                	mov    %esi,%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103390:	e8 cb 08 00 00       	call   80103c60 <mycpu>
80103395:	39 d8                	cmp    %ebx,%eax
80103397:	74 41                	je     801033da <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103399:	e8 72 f5 ff ff       	call   80102910 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010339e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801033a3:	c7 05 f8 6f 00 80 d0 	movl   $0x801032d0,0x80006ff8
801033aa:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801033ad:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801033b4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801033b7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801033bc:	0f b6 03             	movzbl (%ebx),%eax
801033bf:	83 ec 08             	sub    $0x8,%esp
801033c2:	68 00 70 00 00       	push   $0x7000
801033c7:	50                   	push   %eax
801033c8:	e8 03 f8 ff ff       	call   80102bd0 <lapicstartap>
801033cd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801033d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801033d6:	85 c0                	test   %eax,%eax
801033d8:	74 f6                	je     801033d0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801033da:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801033e1:	00 00 00 
801033e4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801033ea:	05 a0 37 11 80       	add    $0x801137a0,%eax
801033ef:	39 c3                	cmp    %eax,%ebx
801033f1:	72 9d                	jb     80103390 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033f3:	83 ec 08             	sub    $0x8,%esp
801033f6:	68 00 00 00 8e       	push   $0x8e000000
801033fb:	68 00 00 40 80       	push   $0x80400000
80103400:	e8 ab f4 ff ff       	call   801028b0 <kinit2>
  userinit();      // first user process
80103405:	e8 26 09 00 00       	call   80103d30 <userinit>
  mpmain();        // finish this processor's setup
8010340a:	e8 81 fe ff ff       	call   80103290 <mpmain>
8010340f:	90                   	nop

80103410 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103415:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010341b:	53                   	push   %ebx
  e = addr+len;
8010341c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010341f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103422:	39 de                	cmp    %ebx,%esi
80103424:	72 10                	jb     80103436 <mpsearch1+0x26>
80103426:	eb 50                	jmp    80103478 <mpsearch1+0x68>
80103428:	90                   	nop
80103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103430:	39 fb                	cmp    %edi,%ebx
80103432:	89 fe                	mov    %edi,%esi
80103434:	76 42                	jbe    80103478 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103436:	83 ec 04             	sub    $0x4,%esp
80103439:	8d 7e 10             	lea    0x10(%esi),%edi
8010343c:	6a 04                	push   $0x4
8010343e:	68 78 82 10 80       	push   $0x80108278
80103443:	56                   	push   %esi
80103444:	e8 a7 18 00 00       	call   80104cf0 <memcmp>
80103449:	83 c4 10             	add    $0x10,%esp
8010344c:	85 c0                	test   %eax,%eax
8010344e:	75 e0                	jne    80103430 <mpsearch1+0x20>
80103450:	89 f1                	mov    %esi,%ecx
80103452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103458:	0f b6 11             	movzbl (%ecx),%edx
8010345b:	83 c1 01             	add    $0x1,%ecx
8010345e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103460:	39 f9                	cmp    %edi,%ecx
80103462:	75 f4                	jne    80103458 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103464:	84 c0                	test   %al,%al
80103466:	75 c8                	jne    80103430 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103468:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010346b:	89 f0                	mov    %esi,%eax
8010346d:	5b                   	pop    %ebx
8010346e:	5e                   	pop    %esi
8010346f:	5f                   	pop    %edi
80103470:	5d                   	pop    %ebp
80103471:	c3                   	ret    
80103472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103478:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010347b:	31 f6                	xor    %esi,%esi
}
8010347d:	89 f0                	mov    %esi,%eax
8010347f:	5b                   	pop    %ebx
80103480:	5e                   	pop    %esi
80103481:	5f                   	pop    %edi
80103482:	5d                   	pop    %ebp
80103483:	c3                   	ret    
80103484:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010348a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103490 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103499:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801034a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801034a7:	c1 e0 08             	shl    $0x8,%eax
801034aa:	09 d0                	or     %edx,%eax
801034ac:	c1 e0 04             	shl    $0x4,%eax
801034af:	85 c0                	test   %eax,%eax
801034b1:	75 1b                	jne    801034ce <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801034b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801034ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801034c1:	c1 e0 08             	shl    $0x8,%eax
801034c4:	09 d0                	or     %edx,%eax
801034c6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801034c9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801034ce:	ba 00 04 00 00       	mov    $0x400,%edx
801034d3:	e8 38 ff ff ff       	call   80103410 <mpsearch1>
801034d8:	85 c0                	test   %eax,%eax
801034da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034dd:	0f 84 3d 01 00 00    	je     80103620 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034e6:	8b 58 04             	mov    0x4(%eax),%ebx
801034e9:	85 db                	test   %ebx,%ebx
801034eb:	0f 84 4f 01 00 00    	je     80103640 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034f1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801034f7:	83 ec 04             	sub    $0x4,%esp
801034fa:	6a 04                	push   $0x4
801034fc:	68 95 82 10 80       	push   $0x80108295
80103501:	56                   	push   %esi
80103502:	e8 e9 17 00 00       	call   80104cf0 <memcmp>
80103507:	83 c4 10             	add    $0x10,%esp
8010350a:	85 c0                	test   %eax,%eax
8010350c:	0f 85 2e 01 00 00    	jne    80103640 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103512:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103519:	3c 01                	cmp    $0x1,%al
8010351b:	0f 95 c2             	setne  %dl
8010351e:	3c 04                	cmp    $0x4,%al
80103520:	0f 95 c0             	setne  %al
80103523:	20 c2                	and    %al,%dl
80103525:	0f 85 15 01 00 00    	jne    80103640 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010352b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103532:	66 85 ff             	test   %di,%di
80103535:	74 1a                	je     80103551 <mpinit+0xc1>
80103537:	89 f0                	mov    %esi,%eax
80103539:	01 f7                	add    %esi,%edi
  sum = 0;
8010353b:	31 d2                	xor    %edx,%edx
8010353d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103540:	0f b6 08             	movzbl (%eax),%ecx
80103543:	83 c0 01             	add    $0x1,%eax
80103546:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103548:	39 c7                	cmp    %eax,%edi
8010354a:	75 f4                	jne    80103540 <mpinit+0xb0>
8010354c:	84 d2                	test   %dl,%dl
8010354e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103551:	85 f6                	test   %esi,%esi
80103553:	0f 84 e7 00 00 00    	je     80103640 <mpinit+0x1b0>
80103559:	84 d2                	test   %dl,%dl
8010355b:	0f 85 df 00 00 00    	jne    80103640 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103561:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103567:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010356c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103573:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103579:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010357e:	01 d6                	add    %edx,%esi
80103580:	39 c6                	cmp    %eax,%esi
80103582:	76 23                	jbe    801035a7 <mpinit+0x117>
    switch(*p){
80103584:	0f b6 10             	movzbl (%eax),%edx
80103587:	80 fa 04             	cmp    $0x4,%dl
8010358a:	0f 87 ca 00 00 00    	ja     8010365a <mpinit+0x1ca>
80103590:	ff 24 95 bc 82 10 80 	jmp    *-0x7fef7d44(,%edx,4)
80103597:	89 f6                	mov    %esi,%esi
80103599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801035a0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035a3:	39 c6                	cmp    %eax,%esi
801035a5:	77 dd                	ja     80103584 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801035a7:	85 db                	test   %ebx,%ebx
801035a9:	0f 84 9e 00 00 00    	je     8010364d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801035af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035b2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801035b6:	74 15                	je     801035cd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035b8:	b8 70 00 00 00       	mov    $0x70,%eax
801035bd:	ba 22 00 00 00       	mov    $0x22,%edx
801035c2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035c3:	ba 23 00 00 00       	mov    $0x23,%edx
801035c8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801035c9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035cc:	ee                   	out    %al,(%dx)
  }
}
801035cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035d0:	5b                   	pop    %ebx
801035d1:	5e                   	pop    %esi
801035d2:	5f                   	pop    %edi
801035d3:	5d                   	pop    %ebp
801035d4:	c3                   	ret    
801035d5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801035d8:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
801035de:	83 f9 07             	cmp    $0x7,%ecx
801035e1:	7f 19                	jg     801035fc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035e3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801035e7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801035ed:	83 c1 01             	add    $0x1,%ecx
801035f0:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035f6:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
801035fc:	83 c0 14             	add    $0x14,%eax
      continue;
801035ff:	e9 7c ff ff ff       	jmp    80103580 <mpinit+0xf0>
80103604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103608:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010360c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010360f:	88 15 80 37 11 80    	mov    %dl,0x80113780
      continue;
80103615:	e9 66 ff ff ff       	jmp    80103580 <mpinit+0xf0>
8010361a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103620:	ba 00 00 01 00       	mov    $0x10000,%edx
80103625:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010362a:	e8 e1 fd ff ff       	call   80103410 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010362f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103631:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103634:	0f 85 a9 fe ff ff    	jne    801034e3 <mpinit+0x53>
8010363a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	68 7d 82 10 80       	push   $0x8010827d
80103648:	e8 43 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010364d:	83 ec 0c             	sub    $0xc,%esp
80103650:	68 9c 82 10 80       	push   $0x8010829c
80103655:	e8 36 cd ff ff       	call   80100390 <panic>
      ismp = 0;
8010365a:	31 db                	xor    %ebx,%ebx
8010365c:	e9 26 ff ff ff       	jmp    80103587 <mpinit+0xf7>
80103661:	66 90                	xchg   %ax,%ax
80103663:	66 90                	xchg   %ax,%ax
80103665:	66 90                	xchg   %ax,%ax
80103667:	66 90                	xchg   %ax,%ax
80103669:	66 90                	xchg   %ax,%ax
8010366b:	66 90                	xchg   %ax,%ax
8010366d:	66 90                	xchg   %ax,%ax
8010366f:	90                   	nop

80103670 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103670:	55                   	push   %ebp
80103671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103676:	ba 21 00 00 00       	mov    $0x21,%edx
8010367b:	89 e5                	mov    %esp,%ebp
8010367d:	ee                   	out    %al,(%dx)
8010367e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103683:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103684:	5d                   	pop    %ebp
80103685:	c3                   	ret    
80103686:	66 90                	xchg   %ax,%ax
80103688:	66 90                	xchg   %ax,%ax
8010368a:	66 90                	xchg   %ax,%ax
8010368c:	66 90                	xchg   %ax,%ax
8010368e:	66 90                	xchg   %ax,%ax

80103690 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 0c             	sub    $0xc,%esp
80103699:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010369c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010369f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801036a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801036ab:	e8 00 d7 ff ff       	call   80100db0 <filealloc>
801036b0:	85 c0                	test   %eax,%eax
801036b2:	89 03                	mov    %eax,(%ebx)
801036b4:	74 22                	je     801036d8 <pipealloc+0x48>
801036b6:	e8 f5 d6 ff ff       	call   80100db0 <filealloc>
801036bb:	85 c0                	test   %eax,%eax
801036bd:	89 06                	mov    %eax,(%esi)
801036bf:	74 3f                	je     80103700 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801036c1:	e8 4a f2 ff ff       	call   80102910 <kalloc>
801036c6:	85 c0                	test   %eax,%eax
801036c8:	89 c7                	mov    %eax,%edi
801036ca:	75 54                	jne    80103720 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036cc:	8b 03                	mov    (%ebx),%eax
801036ce:	85 c0                	test   %eax,%eax
801036d0:	75 34                	jne    80103706 <pipealloc+0x76>
801036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801036d8:	8b 06                	mov    (%esi),%eax
801036da:	85 c0                	test   %eax,%eax
801036dc:	74 0c                	je     801036ea <pipealloc+0x5a>
    fileclose(*f1);
801036de:	83 ec 0c             	sub    $0xc,%esp
801036e1:	50                   	push   %eax
801036e2:	e8 89 d7 ff ff       	call   80100e70 <fileclose>
801036e7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801036ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036f2:	5b                   	pop    %ebx
801036f3:	5e                   	pop    %esi
801036f4:	5f                   	pop    %edi
801036f5:	5d                   	pop    %ebp
801036f6:	c3                   	ret    
801036f7:	89 f6                	mov    %esi,%esi
801036f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103700:	8b 03                	mov    (%ebx),%eax
80103702:	85 c0                	test   %eax,%eax
80103704:	74 e4                	je     801036ea <pipealloc+0x5a>
    fileclose(*f0);
80103706:	83 ec 0c             	sub    $0xc,%esp
80103709:	50                   	push   %eax
8010370a:	e8 61 d7 ff ff       	call   80100e70 <fileclose>
  if(*f1)
8010370f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103711:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103714:	85 c0                	test   %eax,%eax
80103716:	75 c6                	jne    801036de <pipealloc+0x4e>
80103718:	eb d0                	jmp    801036ea <pipealloc+0x5a>
8010371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103720:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103723:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010372a:	00 00 00 
  p->writeopen = 1;
8010372d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103734:	00 00 00 
  p->nwrite = 0;
80103737:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010373e:	00 00 00 
  p->nread = 0;
80103741:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103748:	00 00 00 
  initlock(&p->lock, "pipe");
8010374b:	68 d0 82 10 80       	push   $0x801082d0
80103750:	50                   	push   %eax
80103751:	e8 da 12 00 00       	call   80104a30 <initlock>
  (*f0)->type = FD_PIPE;
80103756:	8b 03                	mov    (%ebx),%eax
  return 0;
80103758:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010375b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103761:	8b 03                	mov    (%ebx),%eax
80103763:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103767:	8b 03                	mov    (%ebx),%eax
80103769:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010376d:	8b 03                	mov    (%ebx),%eax
8010376f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103772:	8b 06                	mov    (%esi),%eax
80103774:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010377a:	8b 06                	mov    (%esi),%eax
8010377c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103780:	8b 06                	mov    (%esi),%eax
80103782:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103786:	8b 06                	mov    (%esi),%eax
80103788:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010378b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010378e:	31 c0                	xor    %eax,%eax
}
80103790:	5b                   	pop    %ebx
80103791:	5e                   	pop    %esi
80103792:	5f                   	pop    %edi
80103793:	5d                   	pop    %ebp
80103794:	c3                   	ret    
80103795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	56                   	push   %esi
801037a4:	53                   	push   %ebx
801037a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801037ab:	83 ec 0c             	sub    $0xc,%esp
801037ae:	53                   	push   %ebx
801037af:	e8 6c 13 00 00       	call   80104b20 <acquire>
  if(writable){
801037b4:	83 c4 10             	add    $0x10,%esp
801037b7:	85 f6                	test   %esi,%esi
801037b9:	74 45                	je     80103800 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801037bb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037c1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801037c4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801037cb:	00 00 00 
    wakeup(&p->nread);
801037ce:	50                   	push   %eax
801037cf:	e8 4c 0f 00 00       	call   80104720 <wakeup>
801037d4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801037d7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801037dd:	85 d2                	test   %edx,%edx
801037df:	75 0a                	jne    801037eb <pipeclose+0x4b>
801037e1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801037e7:	85 c0                	test   %eax,%eax
801037e9:	74 35                	je     80103820 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801037eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801037ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037f1:	5b                   	pop    %ebx
801037f2:	5e                   	pop    %esi
801037f3:	5d                   	pop    %ebp
    release(&p->lock);
801037f4:	e9 47 14 00 00       	jmp    80104c40 <release>
801037f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103800:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103806:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103809:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103810:	00 00 00 
    wakeup(&p->nwrite);
80103813:	50                   	push   %eax
80103814:	e8 07 0f 00 00       	call   80104720 <wakeup>
80103819:	83 c4 10             	add    $0x10,%esp
8010381c:	eb b9                	jmp    801037d7 <pipeclose+0x37>
8010381e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103820:	83 ec 0c             	sub    $0xc,%esp
80103823:	53                   	push   %ebx
80103824:	e8 17 14 00 00       	call   80104c40 <release>
    kfree((char*)p);
80103829:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010382c:	83 c4 10             	add    $0x10,%esp
}
8010382f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103832:	5b                   	pop    %ebx
80103833:	5e                   	pop    %esi
80103834:	5d                   	pop    %ebp
    kfree((char*)p);
80103835:	e9 26 ef ff ff       	jmp    80102760 <kfree>
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103840 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 28             	sub    $0x28,%esp
80103849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010384c:	53                   	push   %ebx
8010384d:	e8 ce 12 00 00       	call   80104b20 <acquire>
  for(i = 0; i < n; i++){
80103852:	8b 45 10             	mov    0x10(%ebp),%eax
80103855:	83 c4 10             	add    $0x10,%esp
80103858:	85 c0                	test   %eax,%eax
8010385a:	0f 8e c9 00 00 00    	jle    80103929 <pipewrite+0xe9>
80103860:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103863:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103869:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010386f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103872:	03 4d 10             	add    0x10(%ebp),%ecx
80103875:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103878:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010387e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103884:	39 d0                	cmp    %edx,%eax
80103886:	75 71                	jne    801038f9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103888:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010388e:	85 c0                	test   %eax,%eax
80103890:	74 4e                	je     801038e0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103892:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103898:	eb 3a                	jmp    801038d4 <pipewrite+0x94>
8010389a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801038a0:	83 ec 0c             	sub    $0xc,%esp
801038a3:	57                   	push   %edi
801038a4:	e8 77 0e 00 00       	call   80104720 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038a9:	5a                   	pop    %edx
801038aa:	59                   	pop    %ecx
801038ab:	53                   	push   %ebx
801038ac:	56                   	push   %esi
801038ad:	e8 fe 0b 00 00       	call   801044b0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038b2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038b8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801038be:	83 c4 10             	add    $0x10,%esp
801038c1:	05 00 02 00 00       	add    $0x200,%eax
801038c6:	39 c2                	cmp    %eax,%edx
801038c8:	75 36                	jne    80103900 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801038ca:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801038d0:	85 c0                	test   %eax,%eax
801038d2:	74 0c                	je     801038e0 <pipewrite+0xa0>
801038d4:	e8 27 04 00 00       	call   80103d00 <myproc>
801038d9:	8b 40 24             	mov    0x24(%eax),%eax
801038dc:	85 c0                	test   %eax,%eax
801038de:	74 c0                	je     801038a0 <pipewrite+0x60>
        release(&p->lock);
801038e0:	83 ec 0c             	sub    $0xc,%esp
801038e3:	53                   	push   %ebx
801038e4:	e8 57 13 00 00       	call   80104c40 <release>
        return -1;
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801038f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038f4:	5b                   	pop    %ebx
801038f5:	5e                   	pop    %esi
801038f6:	5f                   	pop    %edi
801038f7:	5d                   	pop    %ebp
801038f8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038f9:	89 c2                	mov    %eax,%edx
801038fb:	90                   	nop
801038fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103900:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103903:	8d 42 01             	lea    0x1(%edx),%eax
80103906:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010390c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103912:	83 c6 01             	add    $0x1,%esi
80103915:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103919:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010391c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010391f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103923:	0f 85 4f ff ff ff    	jne    80103878 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103929:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010392f:	83 ec 0c             	sub    $0xc,%esp
80103932:	50                   	push   %eax
80103933:	e8 e8 0d 00 00       	call   80104720 <wakeup>
  release(&p->lock);
80103938:	89 1c 24             	mov    %ebx,(%esp)
8010393b:	e8 00 13 00 00       	call   80104c40 <release>
  return n;
80103940:	83 c4 10             	add    $0x10,%esp
80103943:	8b 45 10             	mov    0x10(%ebp),%eax
80103946:	eb a9                	jmp    801038f1 <pipewrite+0xb1>
80103948:	90                   	nop
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103950 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	57                   	push   %edi
80103954:	56                   	push   %esi
80103955:	53                   	push   %ebx
80103956:	83 ec 18             	sub    $0x18,%esp
80103959:	8b 75 08             	mov    0x8(%ebp),%esi
8010395c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010395f:	56                   	push   %esi
80103960:	e8 bb 11 00 00       	call   80104b20 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103965:	83 c4 10             	add    $0x10,%esp
80103968:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010396e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103974:	75 6a                	jne    801039e0 <piperead+0x90>
80103976:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010397c:	85 db                	test   %ebx,%ebx
8010397e:	0f 84 c4 00 00 00    	je     80103a48 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103984:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010398a:	eb 2d                	jmp    801039b9 <piperead+0x69>
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103990:	83 ec 08             	sub    $0x8,%esp
80103993:	56                   	push   %esi
80103994:	53                   	push   %ebx
80103995:	e8 16 0b 00 00       	call   801044b0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010399a:	83 c4 10             	add    $0x10,%esp
8010399d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039a3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039a9:	75 35                	jne    801039e0 <piperead+0x90>
801039ab:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801039b1:	85 d2                	test   %edx,%edx
801039b3:	0f 84 8f 00 00 00    	je     80103a48 <piperead+0xf8>
    if(myproc()->killed){
801039b9:	e8 42 03 00 00       	call   80103d00 <myproc>
801039be:	8b 48 24             	mov    0x24(%eax),%ecx
801039c1:	85 c9                	test   %ecx,%ecx
801039c3:	74 cb                	je     80103990 <piperead+0x40>
      release(&p->lock);
801039c5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801039c8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801039cd:	56                   	push   %esi
801039ce:	e8 6d 12 00 00       	call   80104c40 <release>
      return -1;
801039d3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801039d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039d9:	89 d8                	mov    %ebx,%eax
801039db:	5b                   	pop    %ebx
801039dc:	5e                   	pop    %esi
801039dd:	5f                   	pop    %edi
801039de:	5d                   	pop    %ebp
801039df:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039e0:	8b 45 10             	mov    0x10(%ebp),%eax
801039e3:	85 c0                	test   %eax,%eax
801039e5:	7e 61                	jle    80103a48 <piperead+0xf8>
    if(p->nread == p->nwrite)
801039e7:	31 db                	xor    %ebx,%ebx
801039e9:	eb 13                	jmp    801039fe <piperead+0xae>
801039eb:	90                   	nop
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039f0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039f6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039fc:	74 1f                	je     80103a1d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801039fe:	8d 41 01             	lea    0x1(%ecx),%eax
80103a01:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103a07:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103a0d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103a12:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a15:	83 c3 01             	add    $0x1,%ebx
80103a18:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a1b:	75 d3                	jne    801039f0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a1d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a23:	83 ec 0c             	sub    $0xc,%esp
80103a26:	50                   	push   %eax
80103a27:	e8 f4 0c 00 00       	call   80104720 <wakeup>
  release(&p->lock);
80103a2c:	89 34 24             	mov    %esi,(%esp)
80103a2f:	e8 0c 12 00 00       	call   80104c40 <release>
  return i;
80103a34:	83 c4 10             	add    $0x10,%esp
}
80103a37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a3a:	89 d8                	mov    %ebx,%eax
80103a3c:	5b                   	pop    %ebx
80103a3d:	5e                   	pop    %esi
80103a3e:	5f                   	pop    %edi
80103a3f:	5d                   	pop    %ebp
80103a40:	c3                   	ret    
80103a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a48:	31 db                	xor    %ebx,%ebx
80103a4a:	eb d1                	jmp    80103a1d <piperead+0xcd>
80103a4c:	66 90                	xchg   %ax,%ax
80103a4e:	66 90                	xchg   %ax,%ax

80103a50 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void) {
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
    struct page *pg;
    char *sp;

    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a54:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
allocproc(void) {
80103a59:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80103a5c:	68 40 4d 11 80       	push   $0x80114d40
80103a61:	e8 ba 10 00 00       	call   80104b20 <acquire>
80103a66:	83 c4 10             	add    $0x10,%esp
80103a69:	eb 17                	jmp    80103a82 <allocproc+0x32>
80103a6b:	90                   	nop
80103a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a70:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
80103a76:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
80103a7c:	0f 83 1e 01 00 00    	jae    80103ba0 <allocproc+0x150>
        if (p->state == UNUSED)
80103a82:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a85:	85 c0                	test   %eax,%eax
80103a87:	75 e7                	jne    80103a70 <allocproc+0x20>
    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;
80103a89:	a1 04 b0 10 80       	mov    0x8010b004,%eax

    release(&ptable.lock);
80103a8e:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
80103a91:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80103a98:	8d 50 01             	lea    0x1(%eax),%edx
80103a9b:	89 43 10             	mov    %eax,0x10(%ebx)
    release(&ptable.lock);
80103a9e:	68 40 4d 11 80       	push   $0x80114d40
    p->pid = nextpid++;
80103aa3:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    release(&ptable.lock);
80103aa9:	e8 92 11 00 00       	call   80104c40 <release>

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
80103aae:	e8 5d ee ff ff       	call   80102910 <kalloc>
80103ab3:	83 c4 10             	add    $0x10,%esp
80103ab6:	85 c0                	test   %eax,%eax
80103ab8:	89 43 08             	mov    %eax,0x8(%ebx)
80103abb:	0f 84 f8 00 00 00    	je     80103bb9 <allocproc+0x169>
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80103ac1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
80103ac7:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103aca:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103acf:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint *) sp = (uint) trapret;
80103ad2:	c7 40 14 e2 5e 10 80 	movl   $0x80105ee2,0x14(%eax)
    p->context = (struct context *) sp;
80103ad9:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103adc:	6a 14                	push   $0x14
80103ade:	6a 00                	push   $0x0
80103ae0:	50                   	push   %eax
80103ae1:	e8 ba 11 00 00       	call   80104ca0 <memset>
    p->context->eip = (uint) forkret;
80103ae6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103ae9:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
80103aef:	8d 93 40 04 00 00    	lea    0x440(%ebx),%edx
80103af5:	83 c4 10             	add    $0x10,%esp
80103af8:	c7 40 10 d0 3b 10 80 	movl   $0x80103bd0,0x10(%eax)

    //TODO INIT PROC PAGES FIELDS
    p->pagesCounter = 0;
80103aff:	c7 83 44 04 00 00 00 	movl   $0x0,0x444(%ebx)
80103b06:	00 00 00 
80103b09:	89 c8                	mov    %ecx,%eax
    p->nextpageid = 1;
80103b0b:	c7 83 40 04 00 00 01 	movl   $0x1,0x440(%ebx)
80103b12:	00 00 00 
//    p->swapOffset = 0;
    p->pagesequel = 0;
80103b15:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
80103b1c:	00 00 00 
    p->pagesinSwap = 0;
80103b1f:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
80103b26:	00 00 00 
    p->protectedPages = 0;
80103b29:	c7 83 50 04 00 00 00 	movl   $0x0,0x450(%ebx)
80103b30:	00 00 00 
    p->pageFaults = 0;
80103b33:	c7 83 54 04 00 00 00 	movl   $0x0,0x454(%ebx)
80103b3a:	00 00 00 
    p->totalPagesInSwap = 0;
80103b3d:	c7 83 58 04 00 00 00 	movl   $0x0,0x458(%ebx)
80103b44:	00 00 00 
80103b47:	89 f6                	mov    %esi,%esi
80103b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;
80103b50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103b56:	83 c0 04             	add    $0x4,%eax
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103b59:	39 d0                	cmp    %edx,%eax
80103b5b:	75 f3                	jne    80103b50 <allocproc+0x100>

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103b5d:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103b63:	90                   	nop
80103b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
        pg->offset = 0;
80103b68:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        pg->pageid = 0;
80103b6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103b76:	83 c0 1c             	add    $0x1c,%eax
        pg->present = 0;
80103b79:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
        pg->sequel = 0;
80103b80:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
        pg->physAdress = 0;
80103b87:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        pg->virtAdress = 0;
80103b8e:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80103b95:	39 c8                	cmp    %ecx,%eax
80103b97:	72 cf                	jb     80103b68 <allocproc+0x118>
    }


    return p;
}
80103b99:	89 d8                	mov    %ebx,%eax
80103b9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b9e:	c9                   	leave  
80103b9f:	c3                   	ret    
    release(&ptable.lock);
80103ba0:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80103ba3:	31 db                	xor    %ebx,%ebx
    release(&ptable.lock);
80103ba5:	68 40 4d 11 80       	push   $0x80114d40
80103baa:	e8 91 10 00 00       	call   80104c40 <release>
}
80103baf:	89 d8                	mov    %ebx,%eax
    return 0;
80103bb1:	83 c4 10             	add    $0x10,%esp
}
80103bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bb7:	c9                   	leave  
80103bb8:	c3                   	ret    
        p->state = UNUSED;
80103bb9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103bc0:	31 db                	xor    %ebx,%ebx
80103bc2:	eb d5                	jmp    80103b99 <allocproc+0x149>
80103bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bd0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103bd6:	68 40 4d 11 80       	push   $0x80114d40
80103bdb:	e8 60 10 00 00       	call   80104c40 <release>

    if (first) {
80103be0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103be5:	83 c4 10             	add    $0x10,%esp
80103be8:	85 c0                	test   %eax,%eax
80103bea:	75 04                	jne    80103bf0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103bec:	c9                   	leave  
80103bed:	c3                   	ret    
80103bee:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
80103bf0:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
80103bf3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103bfa:	00 00 00 
        iinit(ROOTDEV);
80103bfd:	6a 01                	push   $0x1
80103bff:	e8 bc d8 ff ff       	call   801014c0 <iinit>
        initlog(ROOTDEV);
80103c04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c0b:	e8 40 f3 ff ff       	call   80102f50 <initlog>
80103c10:	83 c4 10             	add    $0x10,%esp
}
80103c13:	c9                   	leave  
80103c14:	c3                   	ret    
80103c15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c20 <notShell>:
    return nextpid>3;
80103c20:	31 c0                	xor    %eax,%eax
80103c22:	83 3d 04 b0 10 80 03 	cmpl   $0x3,0x8010b004
int notShell(void){
80103c29:	55                   	push   %ebp
80103c2a:	89 e5                	mov    %esp,%ebp
}
80103c2c:	5d                   	pop    %ebp
    return nextpid>3;
80103c2d:	0f 9f c0             	setg   %al
}
80103c30:	c3                   	ret    
80103c31:	eb 0d                	jmp    80103c40 <pinit>
80103c33:	90                   	nop
80103c34:	90                   	nop
80103c35:	90                   	nop
80103c36:	90                   	nop
80103c37:	90                   	nop
80103c38:	90                   	nop
80103c39:	90                   	nop
80103c3a:	90                   	nop
80103c3b:	90                   	nop
80103c3c:	90                   	nop
80103c3d:	90                   	nop
80103c3e:	90                   	nop
80103c3f:	90                   	nop

80103c40 <pinit>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103c46:	68 d5 82 10 80       	push   $0x801082d5
80103c4b:	68 40 4d 11 80       	push   $0x80114d40
80103c50:	e8 db 0d 00 00       	call   80104a30 <initlock>
}
80103c55:	83 c4 10             	add    $0x10,%esp
80103c58:	c9                   	leave  
80103c59:	c3                   	ret    
80103c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c60 <mycpu>:
mycpu(void) {
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	56                   	push   %esi
80103c64:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c65:	9c                   	pushf  
80103c66:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80103c67:	f6 c4 02             	test   $0x2,%ah
80103c6a:	75 5e                	jne    80103cca <mycpu+0x6a>
    apicid = lapicid();
80103c6c:	e8 0f ef ff ff       	call   80102b80 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103c71:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
80103c77:	85 f6                	test   %esi,%esi
80103c79:	7e 42                	jle    80103cbd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103c7b:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103c82:	39 d0                	cmp    %edx,%eax
80103c84:	74 30                	je     80103cb6 <mycpu+0x56>
80103c86:	b9 50 38 11 80       	mov    $0x80113850,%ecx
    for (i = 0; i < ncpu; ++i) {
80103c8b:	31 d2                	xor    %edx,%edx
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
80103c90:	83 c2 01             	add    $0x1,%edx
80103c93:	39 f2                	cmp    %esi,%edx
80103c95:	74 26                	je     80103cbd <mycpu+0x5d>
        if (cpus[i].apicid == apicid)
80103c97:	0f b6 19             	movzbl (%ecx),%ebx
80103c9a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103ca0:	39 c3                	cmp    %eax,%ebx
80103ca2:	75 ec                	jne    80103c90 <mycpu+0x30>
80103ca4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103caa:	05 a0 37 11 80       	add    $0x801137a0,%eax
}
80103caf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cb2:	5b                   	pop    %ebx
80103cb3:	5e                   	pop    %esi
80103cb4:	5d                   	pop    %ebp
80103cb5:	c3                   	ret    
        if (cpus[i].apicid == apicid)
80103cb6:	b8 a0 37 11 80       	mov    $0x801137a0,%eax
            return &cpus[i];
80103cbb:	eb f2                	jmp    80103caf <mycpu+0x4f>
    panic("unknown apicid\n");
80103cbd:	83 ec 0c             	sub    $0xc,%esp
80103cc0:	68 dc 82 10 80       	push   $0x801082dc
80103cc5:	e8 c6 c6 ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
80103cca:	83 ec 0c             	sub    $0xc,%esp
80103ccd:	68 c8 83 10 80       	push   $0x801083c8
80103cd2:	e8 b9 c6 ff ff       	call   80100390 <panic>
80103cd7:	89 f6                	mov    %esi,%esi
80103cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ce0 <cpuid>:
cpuid() {
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ce6:	e8 75 ff ff ff       	call   80103c60 <mycpu>
80103ceb:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103cf0:	c9                   	leave  
  return mycpu()-cpus;
80103cf1:	c1 f8 04             	sar    $0x4,%eax
80103cf4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103cfa:	c3                   	ret    
80103cfb:	90                   	nop
80103cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d00 <myproc>:
myproc(void) {
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	53                   	push   %ebx
80103d04:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103d07:	e8 d4 0d 00 00       	call   80104ae0 <pushcli>
    c = mycpu();
80103d0c:	e8 4f ff ff ff       	call   80103c60 <mycpu>
    p = c->proc;
80103d11:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103d17:	e8 c4 0e 00 00       	call   80104be0 <popcli>
}
80103d1c:	83 c4 04             	add    $0x4,%esp
80103d1f:	89 d8                	mov    %ebx,%eax
80103d21:	5b                   	pop    %ebx
80103d22:	5d                   	pop    %ebp
80103d23:	c3                   	ret    
80103d24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d30 <userinit>:
userinit(void) {
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	53                   	push   %ebx
80103d34:	83 ec 04             	sub    $0x4,%esp
    totalAvailablePages = kallocCount();
80103d37:	e8 a4 e9 ff ff       	call   801026e0 <kallocCount>
80103d3c:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
    p = allocproc();
80103d41:	e8 0a fd ff ff       	call   80103a50 <allocproc>
80103d46:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103d48:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
    if ((p->pgdir = setupkvm()) == 0)
80103d4d:	e8 5e 3d 00 00       	call   80107ab0 <setupkvm>
80103d52:	85 c0                	test   %eax,%eax
80103d54:	89 43 04             	mov    %eax,0x4(%ebx)
80103d57:	0f 84 bd 00 00 00    	je     80103e1a <userinit+0xea>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103d5d:	83 ec 04             	sub    $0x4,%esp
80103d60:	68 2c 00 00 00       	push   $0x2c
80103d65:	68 60 b4 10 80       	push   $0x8010b460
80103d6a:	50                   	push   %eax
80103d6b:	e8 a0 35 00 00       	call   80107310 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103d70:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103d73:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103d79:	6a 4c                	push   $0x4c
80103d7b:	6a 00                	push   $0x0
80103d7d:	ff 73 18             	pushl  0x18(%ebx)
80103d80:	e8 1b 0f 00 00       	call   80104ca0 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d85:	8b 43 18             	mov    0x18(%ebx),%eax
80103d88:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d8d:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103d92:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d95:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d99:	8b 43 18             	mov    0x18(%ebx),%eax
80103d9c:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103da0:	8b 43 18             	mov    0x18(%ebx),%eax
80103da3:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103da7:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103dab:	8b 43 18             	mov    0x18(%ebx),%eax
80103dae:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103db2:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103db6:	8b 43 18             	mov    0x18(%ebx),%eax
80103db9:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103dc0:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc3:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103dca:	8b 43 18             	mov    0x18(%ebx),%eax
80103dcd:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103dd4:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103dd7:	6a 10                	push   $0x10
80103dd9:	68 05 83 10 80       	push   $0x80108305
80103dde:	50                   	push   %eax
80103ddf:	e8 9c 10 00 00       	call   80104e80 <safestrcpy>
    p->cwd = namei("/");
80103de4:	c7 04 24 0e 83 10 80 	movl   $0x8010830e,(%esp)
80103deb:	e8 30 e1 ff ff       	call   80101f20 <namei>
80103df0:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103df3:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103dfa:	e8 21 0d 00 00       	call   80104b20 <acquire>
    p->state = RUNNABLE;
80103dff:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103e06:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103e0d:	e8 2e 0e 00 00       	call   80104c40 <release>
}
80103e12:	83 c4 10             	add    $0x10,%esp
80103e15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e18:	c9                   	leave  
80103e19:	c3                   	ret    
        panic("userinit: out of memory?");
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	68 ec 82 10 80       	push   $0x801082ec
80103e22:	e8 69 c5 ff ff       	call   80100390 <panic>
80103e27:	89 f6                	mov    %esi,%esi
80103e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e30 <growproc>:
growproc(int n) {
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
80103e35:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103e38:	e8 a3 0c 00 00       	call   80104ae0 <pushcli>
    c = mycpu();
80103e3d:	e8 1e fe ff ff       	call   80103c60 <mycpu>
    p = c->proc;
80103e42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103e48:	e8 93 0d 00 00       	call   80104be0 <popcli>
    if (n > 0) {
80103e4d:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103e50:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103e52:	7f 1c                	jg     80103e70 <growproc+0x40>
    } else if (n < 0) {
80103e54:	75 3a                	jne    80103e90 <growproc+0x60>
    switchuvm(curproc);
80103e56:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103e59:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103e5b:	53                   	push   %ebx
80103e5c:	e8 9f 33 00 00       	call   80107200 <switchuvm>
    return 0;
80103e61:	83 c4 10             	add    $0x10,%esp
80103e64:	31 c0                	xor    %eax,%eax
}
80103e66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e69:	5b                   	pop    %ebx
80103e6a:	5e                   	pop    %esi
80103e6b:	5d                   	pop    %ebp
80103e6c:	c3                   	ret    
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e70:	83 ec 04             	sub    $0x4,%esp
80103e73:	01 c6                	add    %eax,%esi
80103e75:	56                   	push   %esi
80103e76:	50                   	push   %eax
80103e77:	ff 73 04             	pushl  0x4(%ebx)
80103e7a:	e8 61 39 00 00       	call   801077e0 <allocuvm>
80103e7f:	83 c4 10             	add    $0x10,%esp
80103e82:	85 c0                	test   %eax,%eax
80103e84:	75 d0                	jne    80103e56 <growproc+0x26>
            return -1;
80103e86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e8b:	eb d9                	jmp    80103e66 <growproc+0x36>
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
        curproc->pagesCounter +=(PGROUNDUP(n)/PGSIZE);
80103e90:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n , 1)) == 0)
80103e96:	01 c6                	add    %eax,%esi
        curproc->pagesCounter +=(PGROUNDUP(n)/PGSIZE);
80103e98:	c1 fa 0c             	sar    $0xc,%edx
80103e9b:	01 93 44 04 00 00    	add    %edx,0x444(%ebx)
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n , 1)) == 0)
80103ea1:	6a 01                	push   $0x1
80103ea3:	56                   	push   %esi
80103ea4:	50                   	push   %eax
80103ea5:	ff 73 04             	pushl  0x4(%ebx)
80103ea8:	e8 73 37 00 00       	call   80107620 <deallocuvm>
80103ead:	83 c4 10             	add    $0x10,%esp
80103eb0:	85 c0                	test   %eax,%eax
80103eb2:	75 a2                	jne    80103e56 <growproc+0x26>
80103eb4:	eb d0                	jmp    80103e86 <growproc+0x56>
80103eb6:	8d 76 00             	lea    0x0(%esi),%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ec0 <fork>:
fork(void) {
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80103ec9:	e8 12 0c 00 00       	call   80104ae0 <pushcli>
    c = mycpu();
80103ece:	e8 8d fd ff ff       	call   80103c60 <mycpu>
    p = c->proc;
80103ed3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ed9:	e8 02 0d 00 00       	call   80104be0 <popcli>
    if ((np = allocproc()) == 0) {
80103ede:	e8 6d fb ff ff       	call   80103a50 <allocproc>
80103ee3:	85 c0                	test   %eax,%eax
80103ee5:	0f 84 97 02 00 00    	je     80104182 <fork+0x2c2>
    if (firstRun) {
80103eeb:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
80103ef1:	89 c2                	mov    %eax,%edx
80103ef3:	85 c9                	test   %ecx,%ecx
80103ef5:	0f 85 65 02 00 00    	jne    80104160 <fork+0x2a0>
    createSwapFile(np);
80103efb:	83 ec 0c             	sub    $0xc,%esp
80103efe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103f01:	52                   	push   %edx
80103f02:	e8 e9 e2 ff ff       	call   801021f0 <createSwapFile>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103f07:	58                   	pop    %eax
80103f08:	5a                   	pop    %edx
80103f09:	ff 33                	pushl  (%ebx)
80103f0b:	ff 73 04             	pushl  0x4(%ebx)
80103f0e:	e8 6d 3c 00 00       	call   80107b80 <copyuvm>
80103f13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f16:	83 c4 10             	add    $0x10,%esp
80103f19:	85 c0                	test   %eax,%eax
80103f1b:	89 42 04             	mov    %eax,0x4(%edx)
80103f1e:	0f 84 65 02 00 00    	je     80104189 <fork+0x2c9>
    np->sz = curproc->sz;
80103f24:	8b 03                	mov    (%ebx),%eax
    *np->tf = *curproc->tf;
80103f26:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->parent = curproc;
80103f2b:	89 5a 14             	mov    %ebx,0x14(%edx)
    *np->tf = *curproc->tf;
80103f2e:	8b 7a 18             	mov    0x18(%edx),%edi
    np->sz = curproc->sz;
80103f31:	89 02                	mov    %eax,(%edx)
    *np->tf = *curproc->tf;
80103f33:	8b 73 18             	mov    0x18(%ebx),%esi
80103f36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->nextpageid = curproc->nextpageid;
80103f38:	8b 83 40 04 00 00    	mov    0x440(%ebx),%eax
80103f3e:	89 82 40 04 00 00    	mov    %eax,0x440(%edx)
    np->pagesCounter = curproc->pagesCounter;
80103f44:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
80103f4a:	89 82 44 04 00 00    	mov    %eax,0x444(%edx)
    np->pagesequel = curproc->pagesequel;
80103f50:	8b 83 4c 04 00 00    	mov    0x44c(%ebx),%eax
80103f56:	89 82 4c 04 00 00    	mov    %eax,0x44c(%edx)
    np->pagesinSwap = curproc->pagesinSwap;
80103f5c:	8b 83 48 04 00 00    	mov    0x448(%ebx),%eax
80103f62:	89 82 48 04 00 00    	mov    %eax,0x448(%edx)
    np->protectedPages = curproc->protectedPages;
80103f68:	8b 83 50 04 00 00    	mov    0x450(%ebx),%eax
    np->pageFaults = 0;
80103f6e:	c7 82 54 04 00 00 00 	movl   $0x0,0x454(%edx)
80103f75:	00 00 00 
    np->totalPagesInSwap = 0;
80103f78:	c7 82 58 04 00 00 00 	movl   $0x0,0x458(%edx)
80103f7f:	00 00 00 
    np->protectedPages = curproc->protectedPages;
80103f82:	89 82 50 04 00 00    	mov    %eax,0x450(%edx)
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103f88:	31 c0                	xor    %eax,%eax
80103f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        np->swapFileEntries[k]=curproc->swapFileEntries[k];
80103f90:	8b 8c 83 00 04 00 00 	mov    0x400(%ebx,%eax,4),%ecx
80103f97:	89 8c 82 00 04 00 00 	mov    %ecx,0x400(%edx,%eax,4)
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
80103f9e:	83 c0 01             	add    $0x1,%eax
80103fa1:	83 f8 10             	cmp    $0x10,%eax
80103fa4:	75 ea                	jne    80103f90 <fork+0xd0>
    for( pg = np->pages , cg = curproc->pages;
80103fa6:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
80103fac:	8d 8b 80 00 00 00    	lea    0x80(%ebx),%ecx
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103fb2:	8d ba 00 04 00 00    	lea    0x400(%edx),%edi
80103fb8:	90                   	nop
80103fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        pg->offset = cg->offset;
80103fc0:	8b 71 10             	mov    0x10(%ecx),%esi
            pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80103fc3:	83 c0 1c             	add    $0x1c,%eax
80103fc6:	83 c1 1c             	add    $0x1c,%ecx
        pg->offset = cg->offset;
80103fc9:	89 70 f4             	mov    %esi,-0xc(%eax)
        pg->pageid = cg->pageid;
80103fcc:	8b 71 e8             	mov    -0x18(%ecx),%esi
80103fcf:	89 70 e8             	mov    %esi,-0x18(%eax)
        pg->present = cg->present;
80103fd2:	8b 71 f0             	mov    -0x10(%ecx),%esi
80103fd5:	89 70 f0             	mov    %esi,-0x10(%eax)
        pg->sequel = cg->sequel;
80103fd8:	8b 71 ec             	mov    -0x14(%ecx),%esi
80103fdb:	89 70 ec             	mov    %esi,-0x14(%eax)
        pg->physAdress = cg->physAdress;
80103fde:	8b 71 f8             	mov    -0x8(%ecx),%esi
80103fe1:	89 70 f8             	mov    %esi,-0x8(%eax)
        pg->virtAdress = cg->virtAdress;
80103fe4:	8b 71 fc             	mov    -0x4(%ecx),%esi
80103fe7:	89 70 fc             	mov    %esi,-0x4(%eax)
    for( pg = np->pages , cg = curproc->pages;
80103fea:	39 c7                	cmp    %eax,%edi
80103fec:	77 d2                	ja     80103fc0 <fork+0x100>
    if (!firstRun) {
80103fee:	8b 3d 08 b0 10 80    	mov    0x8010b008,%edi
80103ff4:	85 ff                	test   %edi,%edi
80103ff6:	0f 85 c4 00 00 00    	jne    801040c0 <fork+0x200>
        for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80103ffc:	83 bb 44 04 00 00 10 	cmpl   $0x10,0x444(%ebx)
80104003:	7f 40                	jg     80104045 <fork+0x185>
80104005:	e9 b6 00 00 00       	jmp    801040c0 <fork+0x200>
8010400a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
80104010:	68 00 10 00 00       	push   $0x1000
80104015:	51                   	push   %ecx
80104016:	68 40 3d 11 80       	push   $0x80113d40
8010401b:	52                   	push   %edx
8010401c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010401f:	e8 6c e2 ff ff       	call   80102290 <writeToSwapFile>
80104024:	83 c4 10             	add    $0x10,%esp
80104027:	83 f8 ff             	cmp    $0xffffffff,%eax
8010402a:	89 c6                	mov    %eax,%esi
8010402c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010402f:	0f 84 42 01 00 00    	je     80104177 <fork+0x2b7>
        for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
80104035:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
8010403b:	83 c7 01             	add    $0x1,%edi
8010403e:	83 e8 10             	sub    $0x10,%eax
80104041:	39 f8                	cmp    %edi,%eax
80104043:	7e 7b                	jle    801040c0 <fork+0x200>
            memset(buffer, 0, PGSIZE);
80104045:	83 ec 04             	sub    $0x4,%esp
80104048:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010404b:	68 00 10 00 00       	push   $0x1000
80104050:	6a 00                	push   $0x0
80104052:	68 40 3d 11 80       	push   $0x80113d40
80104057:	e8 44 0c 00 00       	call   80104ca0 <memset>
8010405c:	89 f9                	mov    %edi,%ecx
            if (readFromSwapFile(curproc, buffer, k * PGSIZE, PGSIZE) == -1) {
8010405e:	68 00 10 00 00       	push   $0x1000
80104063:	c1 e1 0c             	shl    $0xc,%ecx
80104066:	51                   	push   %ecx
80104067:	68 40 3d 11 80       	push   $0x80113d40
8010406c:	53                   	push   %ebx
8010406d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80104070:	e8 4b e2 ff ff       	call   801022c0 <readFromSwapFile>
80104075:	83 c4 20             	add    $0x20,%esp
80104078:	83 f8 ff             	cmp    $0xffffffff,%eax
8010407b:	89 c6                	mov    %eax,%esi
8010407d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104080:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104083:	75 8b                	jne    80104010 <fork+0x150>
                kfree(np->kstack);
80104085:	83 ec 0c             	sub    $0xc,%esp
80104088:	ff 72 08             	pushl  0x8(%edx)
8010408b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
                kfree(np->kstack);
8010408e:	e8 cd e6 ff ff       	call   80102760 <kfree>
                np->kstack = 0;
80104093:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104096:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
                np->state = UNUSED;
8010409d:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
                removeSwapFile(np); //clear swapFile
801040a4:	89 14 24             	mov    %edx,(%esp)
801040a7:	e8 44 df ff ff       	call   80101ff0 <removeSwapFile>
                return -1;
801040ac:	83 c4 10             	add    $0x10,%esp
}
801040af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040b2:	89 f0                	mov    %esi,%eax
801040b4:	5b                   	pop    %ebx
801040b5:	5e                   	pop    %esi
801040b6:	5f                   	pop    %edi
801040b7:	5d                   	pop    %ebp
801040b8:	c3                   	ret    
801040b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    np->tf->eax = 0;
801040c0:	8b 42 18             	mov    0x18(%edx),%eax
    for (i = 0; i < NOFILE; i++)
801040c3:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
801040c5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801040cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[i])
801040d0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801040d4:	85 c0                	test   %eax,%eax
801040d6:	74 16                	je     801040ee <fork+0x22e>
            np->ofile[i] = filedup(curproc->ofile[i]);
801040d8:	83 ec 0c             	sub    $0xc,%esp
801040db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801040de:	50                   	push   %eax
801040df:	e8 3c cd ff ff       	call   80100e20 <filedup>
801040e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040e7:	83 c4 10             	add    $0x10,%esp
801040ea:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++)
801040ee:	83 c6 01             	add    $0x1,%esi
801040f1:	83 fe 10             	cmp    $0x10,%esi
801040f4:	75 da                	jne    801040d0 <fork+0x210>
    np->cwd = idup(curproc->cwd);
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	ff 73 68             	pushl  0x68(%ebx)
801040fc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040ff:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
80104102:	e8 89 d5 ff ff       	call   80101690 <idup>
80104107:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010410a:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
8010410d:	89 42 68             	mov    %eax,0x68(%edx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104110:	8d 42 6c             	lea    0x6c(%edx),%eax
80104113:	6a 10                	push   $0x10
80104115:	53                   	push   %ebx
80104116:	50                   	push   %eax
80104117:	e8 64 0d 00 00       	call   80104e80 <safestrcpy>
    pid = np->pid;
8010411c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010411f:	8b 72 10             	mov    0x10(%edx),%esi
    acquire(&ptable.lock);
80104122:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80104129:	e8 f2 09 00 00       	call   80104b20 <acquire>
    np->state = RUNNABLE;
8010412e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104131:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
    release(&ptable.lock);
80104138:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
8010413f:	e8 fc 0a 00 00       	call   80104c40 <release>
    firstRun = 0;
80104144:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
8010414b:	00 00 00 
    return pid;
8010414e:	83 c4 10             	add    $0x10,%esp
}
80104151:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104154:	89 f0                	mov    %esi,%eax
80104156:	5b                   	pop    %ebx
80104157:	5e                   	pop    %esi
80104158:	5f                   	pop    %edi
80104159:	5d                   	pop    %ebp
8010415a:	c3                   	ret    
8010415b:	90                   	nop
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        createSwapFile(curproc);
80104160:	83 ec 0c             	sub    $0xc,%esp
80104163:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104166:	53                   	push   %ebx
80104167:	e8 84 e0 ff ff       	call   801021f0 <createSwapFile>
8010416c:	83 c4 10             	add    $0x10,%esp
8010416f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104172:	e9 84 fd ff ff       	jmp    80103efb <fork+0x3b>
                kfree(np->kstack);
80104177:	83 ec 0c             	sub    $0xc,%esp
8010417a:	ff 72 08             	pushl  0x8(%edx)
8010417d:	e9 0c ff ff ff       	jmp    8010408e <fork+0x1ce>
        return -1;
80104182:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104187:	eb c8                	jmp    80104151 <fork+0x291>
        kfree(np->kstack);
80104189:	83 ec 0c             	sub    $0xc,%esp
8010418c:	ff 72 08             	pushl  0x8(%edx)
        return -1;
8010418f:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->kstack);
80104194:	e8 c7 e5 ff ff       	call   80102760 <kfree>
        np->kstack = 0;
80104199:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        return -1;
8010419c:	83 c4 10             	add    $0x10,%esp
        np->kstack = 0;
8010419f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
        np->state = UNUSED;
801041a6:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
        return -1;
801041ad:	eb a2                	jmp    80104151 <fork+0x291>
801041af:	90                   	nop

801041b0 <scheduler>:
scheduler(void) {
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	57                   	push   %edi
801041b4:	56                   	push   %esi
801041b5:	53                   	push   %ebx
801041b6:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
801041b9:	e8 a2 fa ff ff       	call   80103c60 <mycpu>
801041be:	8d 78 04             	lea    0x4(%eax),%edi
801041c1:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801041c3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041ca:	00 00 00 
801041cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801041d0:	fb                   	sti    
        acquire(&ptable.lock);
801041d1:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041d4:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
        acquire(&ptable.lock);
801041d9:	68 40 4d 11 80       	push   $0x80114d40
801041de:	e8 3d 09 00 00       	call   80104b20 <acquire>
801041e3:	83 c4 10             	add    $0x10,%esp
801041e6:	8d 76 00             	lea    0x0(%esi),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (p->state != RUNNABLE)
801041f0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041f4:	75 33                	jne    80104229 <scheduler+0x79>
            switchuvm(p);
801041f6:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
801041f9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
801041ff:	53                   	push   %ebx
80104200:	e8 fb 2f 00 00       	call   80107200 <switchuvm>
            swtch(&(c->scheduler), p->context);
80104205:	58                   	pop    %eax
80104206:	5a                   	pop    %edx
80104207:	ff 73 1c             	pushl  0x1c(%ebx)
8010420a:	57                   	push   %edi
            p->state = RUNNING;
8010420b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80104212:	e8 c4 0c 00 00       	call   80104edb <swtch>
            switchkvm();
80104217:	e8 c4 2f 00 00       	call   801071e0 <switchkvm>
            c->proc = 0;
8010421c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104223:	00 00 00 
80104226:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104229:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
8010422f:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
80104235:	72 b9                	jb     801041f0 <scheduler+0x40>
        release(&ptable.lock);
80104237:	83 ec 0c             	sub    $0xc,%esp
8010423a:	68 40 4d 11 80       	push   $0x80114d40
8010423f:	e8 fc 09 00 00       	call   80104c40 <release>
        sti();
80104244:	83 c4 10             	add    $0x10,%esp
80104247:	eb 87                	jmp    801041d0 <scheduler+0x20>
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <sched>:
sched(void) {
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
    pushcli();
80104255:	e8 86 08 00 00       	call   80104ae0 <pushcli>
    c = mycpu();
8010425a:	e8 01 fa ff ff       	call   80103c60 <mycpu>
    p = c->proc;
8010425f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104265:	e8 76 09 00 00       	call   80104be0 <popcli>
    if (!holding(&ptable.lock))
8010426a:	83 ec 0c             	sub    $0xc,%esp
8010426d:	68 40 4d 11 80       	push   $0x80114d40
80104272:	e8 29 08 00 00       	call   80104aa0 <holding>
80104277:	83 c4 10             	add    $0x10,%esp
8010427a:	85 c0                	test   %eax,%eax
8010427c:	74 4f                	je     801042cd <sched+0x7d>
    if (mycpu()->ncli != 1)
8010427e:	e8 dd f9 ff ff       	call   80103c60 <mycpu>
80104283:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010428a:	75 68                	jne    801042f4 <sched+0xa4>
    if (p->state == RUNNING)
8010428c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104290:	74 55                	je     801042e7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104292:	9c                   	pushf  
80104293:	58                   	pop    %eax
    if (readeflags() & FL_IF)
80104294:	f6 c4 02             	test   $0x2,%ah
80104297:	75 41                	jne    801042da <sched+0x8a>
    intena = mycpu()->intena;
80104299:	e8 c2 f9 ff ff       	call   80103c60 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
8010429e:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
801042a1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
801042a7:	e8 b4 f9 ff ff       	call   80103c60 <mycpu>
801042ac:	83 ec 08             	sub    $0x8,%esp
801042af:	ff 70 04             	pushl  0x4(%eax)
801042b2:	53                   	push   %ebx
801042b3:	e8 23 0c 00 00       	call   80104edb <swtch>
    mycpu()->intena = intena;
801042b8:	e8 a3 f9 ff ff       	call   80103c60 <mycpu>
}
801042bd:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
801042c0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042c9:	5b                   	pop    %ebx
801042ca:	5e                   	pop    %esi
801042cb:	5d                   	pop    %ebp
801042cc:	c3                   	ret    
        panic("sched ptable.lock");
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	68 10 83 10 80       	push   $0x80108310
801042d5:	e8 b6 c0 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
801042da:	83 ec 0c             	sub    $0xc,%esp
801042dd:	68 3c 83 10 80       	push   $0x8010833c
801042e2:	e8 a9 c0 ff ff       	call   80100390 <panic>
        panic("sched running");
801042e7:	83 ec 0c             	sub    $0xc,%esp
801042ea:	68 2e 83 10 80       	push   $0x8010832e
801042ef:	e8 9c c0 ff ff       	call   80100390 <panic>
        panic("sched locks");
801042f4:	83 ec 0c             	sub    $0xc,%esp
801042f7:	68 22 83 10 80       	push   $0x80108322
801042fc:	e8 8f c0 ff ff       	call   80100390 <panic>
80104301:	eb 0d                	jmp    80104310 <exit>
80104303:	90                   	nop
80104304:	90                   	nop
80104305:	90                   	nop
80104306:	90                   	nop
80104307:	90                   	nop
80104308:	90                   	nop
80104309:	90                   	nop
8010430a:	90                   	nop
8010430b:	90                   	nop
8010430c:	90                   	nop
8010430d:	90                   	nop
8010430e:	90                   	nop
8010430f:	90                   	nop

80104310 <exit>:
exit(void) {
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	56                   	push   %esi
80104315:	53                   	push   %ebx
80104316:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104319:	e8 c2 07 00 00       	call   80104ae0 <pushcli>
    c = mycpu();
8010431e:	e8 3d f9 ff ff       	call   80103c60 <mycpu>
    p = c->proc;
80104323:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104329:	e8 b2 08 00 00       	call   80104be0 <popcli>
    if (curproc == initproc)
8010432e:	39 1d bc b5 10 80    	cmp    %ebx,0x8010b5bc
80104334:	8d 73 28             	lea    0x28(%ebx),%esi
80104337:	8d 7b 68             	lea    0x68(%ebx),%edi
8010433a:	0f 84 11 01 00 00    	je     80104451 <exit+0x141>
        if (curproc->ofile[fd]) {
80104340:	8b 06                	mov    (%esi),%eax
80104342:	85 c0                	test   %eax,%eax
80104344:	74 12                	je     80104358 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104346:	83 ec 0c             	sub    $0xc,%esp
80104349:	50                   	push   %eax
8010434a:	e8 21 cb ff ff       	call   80100e70 <fileclose>
            curproc->ofile[fd] = 0;
8010434f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104355:	83 c4 10             	add    $0x10,%esp
80104358:	83 c6 04             	add    $0x4,%esi
    for (fd = 0; fd < NOFILE; fd++) {
8010435b:	39 fe                	cmp    %edi,%esi
8010435d:	75 e1                	jne    80104340 <exit+0x30>
    begin_op();
8010435f:	e8 8c ec ff ff       	call   80102ff0 <begin_op>
    iput(curproc->cwd);
80104364:	83 ec 0c             	sub    $0xc,%esp
80104367:	ff 73 68             	pushl  0x68(%ebx)
8010436a:	e8 81 d4 ff ff       	call   801017f0 <iput>
    end_op();
8010436f:	e8 ec ec ff ff       	call   80103060 <end_op>
    if (curproc->pid > 2)
80104374:	83 c4 10             	add    $0x10,%esp
80104377:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
    curproc->cwd = 0;
8010437b:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
    if (curproc->pid > 2)
80104382:	7e 0c                	jle    80104390 <exit+0x80>
        removeSwapFile(curproc);
80104384:	83 ec 0c             	sub    $0xc,%esp
80104387:	53                   	push   %ebx
80104388:	e8 63 dc ff ff       	call   80101ff0 <removeSwapFile>
8010438d:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
80104390:	83 ec 0c             	sub    $0xc,%esp
80104393:	68 40 4d 11 80       	push   $0x80114d40
80104398:	e8 83 07 00 00       	call   80104b20 <acquire>
    wakeup1(curproc->parent);
8010439d:	8b 53 14             	mov    0x14(%ebx),%edx
801043a0:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043a3:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
801043a8:	eb 12                	jmp    801043bc <exit+0xac>
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043b0:	05 5c 04 00 00       	add    $0x45c,%eax
801043b5:	3d 74 64 12 80       	cmp    $0x80126474,%eax
801043ba:	73 1e                	jae    801043da <exit+0xca>
        if (p->state == SLEEPING && p->chan == chan)
801043bc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043c0:	75 ee                	jne    801043b0 <exit+0xa0>
801043c2:	3b 50 20             	cmp    0x20(%eax),%edx
801043c5:	75 e9                	jne    801043b0 <exit+0xa0>
            p->state = RUNNABLE;
801043c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ce:	05 5c 04 00 00       	add    $0x45c,%eax
801043d3:	3d 74 64 12 80       	cmp    $0x80126474,%eax
801043d8:	72 e2                	jb     801043bc <exit+0xac>
            p->parent = initproc;
801043da:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043e0:	ba 74 4d 11 80       	mov    $0x80114d74,%edx
801043e5:	eb 17                	jmp    801043fe <exit+0xee>
801043e7:	89 f6                	mov    %esi,%esi
801043e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801043f0:	81 c2 5c 04 00 00    	add    $0x45c,%edx
801043f6:	81 fa 74 64 12 80    	cmp    $0x80126474,%edx
801043fc:	73 3a                	jae    80104438 <exit+0x128>
        if (p->parent == curproc) {
801043fe:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104401:	75 ed                	jne    801043f0 <exit+0xe0>
            if (p->state == ZOMBIE)
80104403:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104407:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010440a:	75 e4                	jne    801043f0 <exit+0xe0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010440c:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
80104411:	eb 11                	jmp    80104424 <exit+0x114>
80104413:	90                   	nop
80104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104418:	05 5c 04 00 00       	add    $0x45c,%eax
8010441d:	3d 74 64 12 80       	cmp    $0x80126474,%eax
80104422:	73 cc                	jae    801043f0 <exit+0xe0>
        if (p->state == SLEEPING && p->chan == chan)
80104424:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104428:	75 ee                	jne    80104418 <exit+0x108>
8010442a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010442d:	75 e9                	jne    80104418 <exit+0x108>
            p->state = RUNNABLE;
8010442f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104436:	eb e0                	jmp    80104418 <exit+0x108>
    curproc->state = ZOMBIE;
80104438:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
    sched();
8010443f:	e8 0c fe ff ff       	call   80104250 <sched>
    panic("zombie exit");
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	68 5d 83 10 80       	push   $0x8010835d
8010444c:	e8 3f bf ff ff       	call   80100390 <panic>
        panic("init exiting");
80104451:	83 ec 0c             	sub    $0xc,%esp
80104454:	68 50 83 10 80       	push   $0x80108350
80104459:	e8 32 bf ff ff       	call   80100390 <panic>
8010445e:	66 90                	xchg   %ax,%ax

80104460 <yield>:
yield(void) {
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104467:	68 40 4d 11 80       	push   $0x80114d40
8010446c:	e8 af 06 00 00       	call   80104b20 <acquire>
    pushcli();
80104471:	e8 6a 06 00 00       	call   80104ae0 <pushcli>
    c = mycpu();
80104476:	e8 e5 f7 ff ff       	call   80103c60 <mycpu>
    p = c->proc;
8010447b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104481:	e8 5a 07 00 00       	call   80104be0 <popcli>
    myproc()->state = RUNNABLE;
80104486:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
8010448d:	e8 be fd ff ff       	call   80104250 <sched>
    release(&ptable.lock);
80104492:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80104499:	e8 a2 07 00 00       	call   80104c40 <release>
}
8010449e:	83 c4 10             	add    $0x10,%esp
801044a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044a4:	c9                   	leave  
801044a5:	c3                   	ret    
801044a6:	8d 76 00             	lea    0x0(%esi),%esi
801044a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044b0 <sleep>:
sleep(void *chan, struct spinlock *lk) {
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	57                   	push   %edi
801044b4:	56                   	push   %esi
801044b5:	53                   	push   %ebx
801044b6:	83 ec 0c             	sub    $0xc,%esp
801044b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801044bc:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
801044bf:	e8 1c 06 00 00       	call   80104ae0 <pushcli>
    c = mycpu();
801044c4:	e8 97 f7 ff ff       	call   80103c60 <mycpu>
    p = c->proc;
801044c9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801044cf:	e8 0c 07 00 00       	call   80104be0 <popcli>
    if (p == 0)
801044d4:	85 db                	test   %ebx,%ebx
801044d6:	0f 84 87 00 00 00    	je     80104563 <sleep+0xb3>
    if (lk == 0)
801044dc:	85 f6                	test   %esi,%esi
801044de:	74 76                	je     80104556 <sleep+0xa6>
    if (lk != &ptable.lock) {  //DOC: sleeplock0
801044e0:	81 fe 40 4d 11 80    	cmp    $0x80114d40,%esi
801044e6:	74 50                	je     80104538 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
801044e8:	83 ec 0c             	sub    $0xc,%esp
801044eb:	68 40 4d 11 80       	push   $0x80114d40
801044f0:	e8 2b 06 00 00       	call   80104b20 <acquire>
        release(lk);
801044f5:	89 34 24             	mov    %esi,(%esp)
801044f8:	e8 43 07 00 00       	call   80104c40 <release>
    p->chan = chan;
801044fd:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104500:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104507:	e8 44 fd ff ff       	call   80104250 <sched>
    p->chan = 0;
8010450c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80104513:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
8010451a:	e8 21 07 00 00       	call   80104c40 <release>
        acquire(lk);
8010451f:	89 75 08             	mov    %esi,0x8(%ebp)
80104522:	83 c4 10             	add    $0x10,%esp
}
80104525:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104528:	5b                   	pop    %ebx
80104529:	5e                   	pop    %esi
8010452a:	5f                   	pop    %edi
8010452b:	5d                   	pop    %ebp
        acquire(lk);
8010452c:	e9 ef 05 00 00       	jmp    80104b20 <acquire>
80104531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104538:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010453b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104542:	e8 09 fd ff ff       	call   80104250 <sched>
    p->chan = 0;
80104547:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010454e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104551:	5b                   	pop    %ebx
80104552:	5e                   	pop    %esi
80104553:	5f                   	pop    %edi
80104554:	5d                   	pop    %ebp
80104555:	c3                   	ret    
        panic("sleep without lk");
80104556:	83 ec 0c             	sub    $0xc,%esp
80104559:	68 6f 83 10 80       	push   $0x8010836f
8010455e:	e8 2d be ff ff       	call   80100390 <panic>
        panic("sleep");
80104563:	83 ec 0c             	sub    $0xc,%esp
80104566:	68 69 83 10 80       	push   $0x80108369
8010456b:	e8 20 be ff ff       	call   80100390 <panic>

80104570 <wait>:
wait(void) {
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	57                   	push   %edi
80104574:	56                   	push   %esi
80104575:	53                   	push   %ebx
80104576:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104579:	e8 62 05 00 00       	call   80104ae0 <pushcli>
    c = mycpu();
8010457e:	e8 dd f6 ff ff       	call   80103c60 <mycpu>
    p = c->proc;
80104583:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104589:	e8 52 06 00 00       	call   80104be0 <popcli>
    acquire(&ptable.lock);
8010458e:	83 ec 0c             	sub    $0xc,%esp
80104591:	68 40 4d 11 80       	push   $0x80114d40
80104596:	e8 85 05 00 00       	call   80104b20 <acquire>
8010459b:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
8010459e:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045a0:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
801045a5:	eb 17                	jmp    801045be <wait+0x4e>
801045a7:	89 f6                	mov    %esi,%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801045b0:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
801045b6:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
801045bc:	73 1e                	jae    801045dc <wait+0x6c>
            if (p->parent != curproc)
801045be:	39 73 14             	cmp    %esi,0x14(%ebx)
801045c1:	75 ed                	jne    801045b0 <wait+0x40>
            if (p->state == ZOMBIE) {
801045c3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801045c7:	74 3f                	je     80104608 <wait+0x98>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045c9:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
            havekids = 1;
801045cf:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045d4:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
801045da:	72 e2                	jb     801045be <wait+0x4e>
        if (!havekids || curproc->killed) {
801045dc:	85 c0                	test   %eax,%eax
801045de:	0f 84 23 01 00 00    	je     80104707 <wait+0x197>
801045e4:	8b 46 24             	mov    0x24(%esi),%eax
801045e7:	85 c0                	test   %eax,%eax
801045e9:	0f 85 18 01 00 00    	jne    80104707 <wait+0x197>
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801045ef:	83 ec 08             	sub    $0x8,%esp
801045f2:	68 40 4d 11 80       	push   $0x80114d40
801045f7:	56                   	push   %esi
801045f8:	e8 b3 fe ff ff       	call   801044b0 <sleep>
        havekids = 0;
801045fd:	83 c4 10             	add    $0x10,%esp
80104600:	eb 9c                	jmp    8010459e <wait+0x2e>
80104602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                kfree(p->kstack);
80104608:	83 ec 0c             	sub    $0xc,%esp
                pid = p->pid;
8010460b:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
8010460e:	ff 73 08             	pushl  0x8(%ebx)
80104611:	8d bb 40 04 00 00    	lea    0x440(%ebx),%edi
80104617:	e8 44 e1 ff ff       	call   80102760 <kfree>
                p->kstack = 0;
8010461c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104623:	5a                   	pop    %edx
80104624:	ff 73 04             	pushl  0x4(%ebx)
80104627:	e8 04 34 00 00       	call   80107a30 <freevm>
8010462c:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
                p->pid = 0;
80104632:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104639:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104640:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
80104644:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
8010464b:	83 c4 10             	add    $0x10,%esp
                p->state = UNUSED;
8010464e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->pagesCounter = -1;
80104655:	c7 83 44 04 00 00 ff 	movl   $0xffffffff,0x444(%ebx)
8010465c:	ff ff ff 
8010465f:	89 ca                	mov    %ecx,%edx
                p->nextpageid = 0;
80104661:	c7 83 40 04 00 00 00 	movl   $0x0,0x440(%ebx)
80104668:	00 00 00 
                p->pagesequel = 0;
8010466b:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
80104672:	00 00 00 
                p->pagesinSwap = 0;
80104675:	89 c8                	mov    %ecx,%eax
80104677:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
8010467e:	00 00 00 
80104681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    p->swapFileEntries[k]=0;
80104688:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010468e:	83 c0 04             	add    $0x4,%eax
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
80104691:	39 c7                	cmp    %eax,%edi
80104693:	75 f3                	jne    80104688 <wait+0x118>
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
80104695:	83 eb 80             	sub    $0xffffff80,%ebx
80104698:	90                   	nop
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    pg->active = 0;
801046a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
                    pg->offset = 0;
801046a6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801046ad:	83 c3 1c             	add    $0x1c,%ebx
                    pg->pageid = 0;
801046b0:	c7 43 e8 00 00 00 00 	movl   $0x0,-0x18(%ebx)
                    pg->present = -1;
801046b7:	c7 43 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebx)
                    pg->sequel = -1;
801046be:	c7 43 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebx)
                    pg->physAdress = 0;
801046c5:	c7 43 f8 00 00 00 00 	movl   $0x0,-0x8(%ebx)
                    pg->virtAdress = 0;
801046cc:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801046d3:	39 cb                	cmp    %ecx,%ebx
801046d5:	72 c9                	jb     801046a0 <wait+0x130>
801046d7:	89 f6                	mov    %esi,%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    p->swapFileEntries[k]=0;
801046e0:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
801046e6:	83 c2 04             	add    $0x4,%edx
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
801046e9:	39 d0                	cmp    %edx,%eax
801046eb:	75 f3                	jne    801046e0 <wait+0x170>
                release(&ptable.lock);
801046ed:	83 ec 0c             	sub    $0xc,%esp
801046f0:	68 40 4d 11 80       	push   $0x80114d40
801046f5:	e8 46 05 00 00       	call   80104c40 <release>
                return pid;
801046fa:	83 c4 10             	add    $0x10,%esp
}
801046fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104700:	89 f0                	mov    %esi,%eax
80104702:	5b                   	pop    %ebx
80104703:	5e                   	pop    %esi
80104704:	5f                   	pop    %edi
80104705:	5d                   	pop    %ebp
80104706:	c3                   	ret    
            release(&ptable.lock);
80104707:	83 ec 0c             	sub    $0xc,%esp
            return -1;
8010470a:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
8010470f:	68 40 4d 11 80       	push   $0x80114d40
80104714:	e8 27 05 00 00       	call   80104c40 <release>
            return -1;
80104719:	83 c4 10             	add    $0x10,%esp
8010471c:	eb df                	jmp    801046fd <wait+0x18d>
8010471e:	66 90                	xchg   %ax,%ax

80104720 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 10             	sub    $0x10,%esp
80104727:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010472a:	68 40 4d 11 80       	push   $0x80114d40
8010472f:	e8 ec 03 00 00       	call   80104b20 <acquire>
80104734:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104737:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
8010473c:	eb 0e                	jmp    8010474c <wakeup+0x2c>
8010473e:	66 90                	xchg   %ax,%ax
80104740:	05 5c 04 00 00       	add    $0x45c,%eax
80104745:	3d 74 64 12 80       	cmp    $0x80126474,%eax
8010474a:	73 1e                	jae    8010476a <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan)
8010474c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104750:	75 ee                	jne    80104740 <wakeup+0x20>
80104752:	3b 58 20             	cmp    0x20(%eax),%ebx
80104755:	75 e9                	jne    80104740 <wakeup+0x20>
            p->state = RUNNABLE;
80104757:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010475e:	05 5c 04 00 00       	add    $0x45c,%eax
80104763:	3d 74 64 12 80       	cmp    $0x80126474,%eax
80104768:	72 e2                	jb     8010474c <wakeup+0x2c>
    wakeup1(chan);
    release(&ptable.lock);
8010476a:	c7 45 08 40 4d 11 80 	movl   $0x80114d40,0x8(%ebp)
}
80104771:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104774:	c9                   	leave  
    release(&ptable.lock);
80104775:	e9 c6 04 00 00       	jmp    80104c40 <release>
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 10             	sub    $0x10,%esp
80104787:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
8010478a:	68 40 4d 11 80       	push   $0x80114d40
8010478f:	e8 8c 03 00 00       	call   80104b20 <acquire>
80104794:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104797:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
8010479c:	eb 0e                	jmp    801047ac <kill+0x2c>
8010479e:	66 90                	xchg   %ax,%ax
801047a0:	05 5c 04 00 00       	add    $0x45c,%eax
801047a5:	3d 74 64 12 80       	cmp    $0x80126474,%eax
801047aa:	73 34                	jae    801047e0 <kill+0x60>
        if (p->pid == pid) {
801047ac:	39 58 10             	cmp    %ebx,0x10(%eax)
801047af:	75 ef                	jne    801047a0 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
801047b1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
801047b5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
801047bc:	75 07                	jne    801047c5 <kill+0x45>
                p->state = RUNNABLE;
801047be:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
801047c5:	83 ec 0c             	sub    $0xc,%esp
801047c8:	68 40 4d 11 80       	push   $0x80114d40
801047cd:	e8 6e 04 00 00       	call   80104c40 <release>
            return 0;
801047d2:	83 c4 10             	add    $0x10,%esp
801047d5:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801047d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047da:	c9                   	leave  
801047db:	c3                   	ret    
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
801047e0:	83 ec 0c             	sub    $0xc,%esp
801047e3:	68 40 4d 11 80       	push   $0x80114d40
801047e8:	e8 53 04 00 00       	call   80104c40 <release>
    return -1;
801047ed:	83 c4 10             	add    $0x10,%esp
801047f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f8:	c9                   	leave  
801047f9:	c3                   	ret    
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104800 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	57                   	push   %edi
80104804:	56                   	push   %esi
80104805:	53                   	push   %ebx
80104806:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int currentFreePages = 0;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104809:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
procdump(void) {
8010480e:	83 ec 3c             	sub    $0x3c,%esp
80104811:	eb 27                	jmp    8010483a <procdump+0x3a>
80104813:	90                   	nop
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	68 42 88 10 80       	push   $0x80108842
80104820:	e8 3b be ff ff       	call   80100660 <cprintf>
80104825:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104828:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
8010482e:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
80104834:	0f 83 b6 00 00 00    	jae    801048f0 <procdump+0xf0>
        if (p->state == UNUSED)
8010483a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010483d:	85 c0                	test   %eax,%eax
8010483f:	74 e7                	je     80104828 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104841:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104844:	ba 80 83 10 80       	mov    $0x80108380,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104849:	77 11                	ja     8010485c <procdump+0x5c>
8010484b:	8b 14 85 14 84 10 80 	mov    -0x7fef7bec(,%eax,4),%edx
            state = "???";
80104852:	b8 80 83 10 80       	mov    $0x80108380,%eax
80104857:	85 d2                	test   %edx,%edx
80104859:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %d %d %d %d %d %s", p->pid, state, p->name,
8010485c:	8b 83 48 04 00 00    	mov    0x448(%ebx),%eax
80104862:	8b 8b 44 04 00 00    	mov    0x444(%ebx),%ecx
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	ff b3 58 04 00 00    	pushl  0x458(%ebx)
80104871:	ff b3 54 04 00 00    	pushl  0x454(%ebx)
80104877:	ff b3 50 04 00 00    	pushl  0x450(%ebx)
8010487d:	29 c1                	sub    %eax,%ecx
8010487f:	50                   	push   %eax
80104880:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104883:	51                   	push   %ecx
80104884:	50                   	push   %eax
80104885:	52                   	push   %edx
80104886:	ff 73 10             	pushl  0x10(%ebx)
80104889:	68 84 83 10 80       	push   $0x80108384
8010488e:	e8 cd bd ff ff       	call   80100660 <cprintf>
        if (p->state == SLEEPING) {
80104893:	83 c4 30             	add    $0x30,%esp
80104896:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
8010489a:	0f 85 78 ff ff ff    	jne    80104818 <procdump+0x18>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
801048a0:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048a3:	83 ec 08             	sub    $0x8,%esp
801048a6:	8d 7d c0             	lea    -0x40(%ebp),%edi
801048a9:	50                   	push   %eax
801048aa:	8b 43 1c             	mov    0x1c(%ebx),%eax
801048ad:	8b 40 0c             	mov    0xc(%eax),%eax
801048b0:	83 c0 08             	add    $0x8,%eax
801048b3:	50                   	push   %eax
801048b4:	e8 97 01 00 00       	call   80104a50 <getcallerpcs>
801048b9:	83 c4 10             	add    $0x10,%esp
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
801048c0:	8b 17                	mov    (%edi),%edx
801048c2:	85 d2                	test   %edx,%edx
801048c4:	0f 84 4e ff ff ff    	je     80104818 <procdump+0x18>
                cprintf(" %p", pc[i]);
801048ca:	83 ec 08             	sub    $0x8,%esp
801048cd:	83 c7 04             	add    $0x4,%edi
801048d0:	52                   	push   %edx
801048d1:	68 81 7d 10 80       	push   $0x80107d81
801048d6:	e8 85 bd ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801048db:	83 c4 10             	add    $0x10,%esp
801048de:	39 fe                	cmp    %edi,%esi
801048e0:	75 de                	jne    801048c0 <procdump+0xc0>
801048e2:	e9 31 ff ff ff       	jmp    80104818 <procdump+0x18>
801048e7:	89 f6                	mov    %esi,%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
    currentFreePages = kallocCount();
801048f0:	e8 eb dd ff ff       	call   801026e0 <kallocCount>
    currentFreePages = 100 * currentFreePages;
801048f5:	6b c0 64             	imul   $0x64,%eax,%eax
    cprintf(" %d / %d free pages in the system" , currentFreePages , totalAvailablePages );
801048f8:	83 ec 04             	sub    $0x4,%esp
801048fb:	ff 35 b8 b5 10 80    	pushl  0x8010b5b8
80104901:	50                   	push   %eax
80104902:	68 f0 83 10 80       	push   $0x801083f0
80104907:	e8 54 bd ff ff       	call   80100660 <cprintf>
}
8010490c:	83 c4 10             	add    $0x10,%esp
8010490f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104912:	5b                   	pop    %ebx
80104913:	5e                   	pop    %esi
80104914:	5f                   	pop    %edi
80104915:	5d                   	pop    %ebp
80104916:	c3                   	ret    
80104917:	66 90                	xchg   %ax,%ax
80104919:	66 90                	xchg   %ax,%ax
8010491b:	66 90                	xchg   %ax,%ax
8010491d:	66 90                	xchg   %ax,%ax
8010491f:	90                   	nop

80104920 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 0c             	sub    $0xc,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010492a:	68 2c 84 10 80       	push   $0x8010842c
8010492f:	8d 43 04             	lea    0x4(%ebx),%eax
80104932:	50                   	push   %eax
80104933:	e8 f8 00 00 00       	call   80104a30 <initlock>
  lk->name = name;
80104938:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010493b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104941:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104944:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010494b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010494e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104951:	c9                   	leave  
80104952:	c3                   	ret    
80104953:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104960 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104968:	83 ec 0c             	sub    $0xc,%esp
8010496b:	8d 73 04             	lea    0x4(%ebx),%esi
8010496e:	56                   	push   %esi
8010496f:	e8 ac 01 00 00       	call   80104b20 <acquire>
  while (lk->locked) {
80104974:	8b 13                	mov    (%ebx),%edx
80104976:	83 c4 10             	add    $0x10,%esp
80104979:	85 d2                	test   %edx,%edx
8010497b:	74 16                	je     80104993 <acquiresleep+0x33>
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104980:	83 ec 08             	sub    $0x8,%esp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	e8 26 fb ff ff       	call   801044b0 <sleep>
  while (lk->locked) {
8010498a:	8b 03                	mov    (%ebx),%eax
8010498c:	83 c4 10             	add    $0x10,%esp
8010498f:	85 c0                	test   %eax,%eax
80104991:	75 ed                	jne    80104980 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104993:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104999:	e8 62 f3 ff ff       	call   80103d00 <myproc>
8010499e:	8b 40 10             	mov    0x10(%eax),%eax
801049a1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049a4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049aa:	5b                   	pop    %ebx
801049ab:	5e                   	pop    %esi
801049ac:	5d                   	pop    %ebp
  release(&lk->lk);
801049ad:	e9 8e 02 00 00       	jmp    80104c40 <release>
801049b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	8d 73 04             	lea    0x4(%ebx),%esi
801049ce:	56                   	push   %esi
801049cf:	e8 4c 01 00 00       	call   80104b20 <acquire>
  lk->locked = 0;
801049d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049da:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049e1:	89 1c 24             	mov    %ebx,(%esp)
801049e4:	e8 37 fd ff ff       	call   80104720 <wakeup>
  release(&lk->lk);
801049e9:	89 75 08             	mov    %esi,0x8(%ebp)
801049ec:	83 c4 10             	add    $0x10,%esp
}
801049ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049f2:	5b                   	pop    %ebx
801049f3:	5e                   	pop    %esi
801049f4:	5d                   	pop    %ebp
  release(&lk->lk);
801049f5:	e9 46 02 00 00       	jmp    80104c40 <release>
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a00 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	53                   	push   %ebx
80104a05:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	8d 5e 04             	lea    0x4(%esi),%ebx
80104a0e:	53                   	push   %ebx
80104a0f:	e8 0c 01 00 00       	call   80104b20 <acquire>
  r = lk->locked;
80104a14:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104a16:	89 1c 24             	mov    %ebx,(%esp)
80104a19:	e8 22 02 00 00       	call   80104c40 <release>
  return r;
}
80104a1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a21:	89 f0                	mov    %esi,%eax
80104a23:	5b                   	pop    %ebx
80104a24:	5e                   	pop    %esi
80104a25:	5d                   	pop    %ebp
80104a26:	c3                   	ret    
80104a27:	66 90                	xchg   %ax,%ax
80104a29:	66 90                	xchg   %ax,%ax
80104a2b:	66 90                	xchg   %ax,%ax
80104a2d:	66 90                	xchg   %ax,%ax
80104a2f:	90                   	nop

80104a30 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a3f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret    
80104a4b:	90                   	nop
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a50:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a51:	31 d2                	xor    %edx,%edx
{
80104a53:	89 e5                	mov    %esp,%ebp
80104a55:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a56:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a5c:	83 e8 08             	sub    $0x8,%eax
80104a5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a60:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a6c:	77 1a                	ja     80104a88 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a6e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a71:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a74:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a77:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a79:	83 fa 0a             	cmp    $0xa,%edx
80104a7c:	75 e2                	jne    80104a60 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a7e:	5b                   	pop    %ebx
80104a7f:	5d                   	pop    %ebp
80104a80:	c3                   	ret    
80104a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a88:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a8b:	83 c1 28             	add    $0x28,%ecx
80104a8e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104a90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a96:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a99:	39 c1                	cmp    %eax,%ecx
80104a9b:	75 f3                	jne    80104a90 <getcallerpcs+0x40>
}
80104a9d:	5b                   	pop    %ebx
80104a9e:	5d                   	pop    %ebp
80104a9f:	c3                   	ret    

80104aa0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 04             	sub    $0x4,%esp
80104aa7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104aaa:	8b 02                	mov    (%edx),%eax
80104aac:	85 c0                	test   %eax,%eax
80104aae:	75 10                	jne    80104ac0 <holding+0x20>
}
80104ab0:	83 c4 04             	add    $0x4,%esp
80104ab3:	31 c0                	xor    %eax,%eax
80104ab5:	5b                   	pop    %ebx
80104ab6:	5d                   	pop    %ebp
80104ab7:	c3                   	ret    
80104ab8:	90                   	nop
80104ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104ac0:	8b 5a 08             	mov    0x8(%edx),%ebx
80104ac3:	e8 98 f1 ff ff       	call   80103c60 <mycpu>
80104ac8:	39 c3                	cmp    %eax,%ebx
80104aca:	0f 94 c0             	sete   %al
}
80104acd:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104ad0:	0f b6 c0             	movzbl %al,%eax
}
80104ad3:	5b                   	pop    %ebx
80104ad4:	5d                   	pop    %ebp
80104ad5:	c3                   	ret    
80104ad6:	8d 76 00             	lea    0x0(%esi),%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ae0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
80104ae7:	9c                   	pushf  
80104ae8:	5b                   	pop    %ebx
  asm volatile("cli");
80104ae9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104aea:	e8 71 f1 ff ff       	call   80103c60 <mycpu>
80104aef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104af5:	85 c0                	test   %eax,%eax
80104af7:	75 11                	jne    80104b0a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104af9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104aff:	e8 5c f1 ff ff       	call   80103c60 <mycpu>
80104b04:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b0a:	e8 51 f1 ff ff       	call   80103c60 <mycpu>
80104b0f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b16:	83 c4 04             	add    $0x4,%esp
80104b19:	5b                   	pop    %ebx
80104b1a:	5d                   	pop    %ebp
80104b1b:	c3                   	ret    
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b20 <acquire>:
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b25:	e8 b6 ff ff ff       	call   80104ae0 <pushcli>
  if(holding(lk))
80104b2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104b2d:	8b 03                	mov    (%ebx),%eax
80104b2f:	85 c0                	test   %eax,%eax
80104b31:	0f 85 81 00 00 00    	jne    80104bb8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104b37:	ba 01 00 00 00       	mov    $0x1,%edx
80104b3c:	eb 05                	jmp    80104b43 <acquire+0x23>
80104b3e:	66 90                	xchg   %ax,%ax
80104b40:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b43:	89 d0                	mov    %edx,%eax
80104b45:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104b48:	85 c0                	test   %eax,%eax
80104b4a:	75 f4                	jne    80104b40 <acquire+0x20>
  __sync_synchronize();
80104b4c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b54:	e8 07 f1 ff ff       	call   80103c60 <mycpu>
  for(i = 0; i < 10; i++){
80104b59:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
80104b5b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
80104b5e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104b61:	89 e8                	mov    %ebp,%eax
80104b63:	90                   	nop
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b68:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b6e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b74:	77 1a                	ja     80104b90 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104b76:	8b 58 04             	mov    0x4(%eax),%ebx
80104b79:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b7c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b7f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b81:	83 fa 0a             	cmp    $0xa,%edx
80104b84:	75 e2                	jne    80104b68 <acquire+0x48>
}
80104b86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b89:	5b                   	pop    %ebx
80104b8a:	5e                   	pop    %esi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
80104b90:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b93:	83 c1 28             	add    $0x28,%ecx
80104b96:	8d 76 00             	lea    0x0(%esi),%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ba6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ba9:	39 c8                	cmp    %ecx,%eax
80104bab:	75 f3                	jne    80104ba0 <acquire+0x80>
}
80104bad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb0:	5b                   	pop    %ebx
80104bb1:	5e                   	pop    %esi
80104bb2:	5d                   	pop    %ebp
80104bb3:	c3                   	ret    
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104bb8:	8b 73 08             	mov    0x8(%ebx),%esi
80104bbb:	e8 a0 f0 ff ff       	call   80103c60 <mycpu>
80104bc0:	39 c6                	cmp    %eax,%esi
80104bc2:	0f 85 6f ff ff ff    	jne    80104b37 <acquire+0x17>
    panic("acquire");
80104bc8:	83 ec 0c             	sub    $0xc,%esp
80104bcb:	68 37 84 10 80       	push   $0x80108437
80104bd0:	e8 bb b7 ff ff       	call   80100390 <panic>
80104bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <popcli>:

void
popcli(void)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104be6:	9c                   	pushf  
80104be7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104be8:	f6 c4 02             	test   $0x2,%ah
80104beb:	75 35                	jne    80104c22 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104bed:	e8 6e f0 ff ff       	call   80103c60 <mycpu>
80104bf2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104bf9:	78 34                	js     80104c2f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bfb:	e8 60 f0 ff ff       	call   80103c60 <mycpu>
80104c00:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c06:	85 d2                	test   %edx,%edx
80104c08:	74 06                	je     80104c10 <popcli+0x30>
    sti();
}
80104c0a:	c9                   	leave  
80104c0b:	c3                   	ret    
80104c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c10:	e8 4b f0 ff ff       	call   80103c60 <mycpu>
80104c15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c1b:	85 c0                	test   %eax,%eax
80104c1d:	74 eb                	je     80104c0a <popcli+0x2a>
  asm volatile("sti");
80104c1f:	fb                   	sti    
}
80104c20:	c9                   	leave  
80104c21:	c3                   	ret    
    panic("popcli - interruptible");
80104c22:	83 ec 0c             	sub    $0xc,%esp
80104c25:	68 3f 84 10 80       	push   $0x8010843f
80104c2a:	e8 61 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104c2f:	83 ec 0c             	sub    $0xc,%esp
80104c32:	68 56 84 10 80       	push   $0x80108456
80104c37:	e8 54 b7 ff ff       	call   80100390 <panic>
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c40 <release>:
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
80104c45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104c48:	8b 03                	mov    (%ebx),%eax
80104c4a:	85 c0                	test   %eax,%eax
80104c4c:	74 0c                	je     80104c5a <release+0x1a>
80104c4e:	8b 73 08             	mov    0x8(%ebx),%esi
80104c51:	e8 0a f0 ff ff       	call   80103c60 <mycpu>
80104c56:	39 c6                	cmp    %eax,%esi
80104c58:	74 16                	je     80104c70 <release+0x30>
    panic("release");
80104c5a:	83 ec 0c             	sub    $0xc,%esp
80104c5d:	68 5d 84 10 80       	push   $0x8010845d
80104c62:	e8 29 b7 ff ff       	call   80100390 <panic>
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104c70:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c77:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c7e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c83:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c89:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c8c:	5b                   	pop    %ebx
80104c8d:	5e                   	pop    %esi
80104c8e:	5d                   	pop    %ebp
  popcli();
80104c8f:	e9 4c ff ff ff       	jmp    80104be0 <popcli>
80104c94:	66 90                	xchg   %ax,%ax
80104c96:	66 90                	xchg   %ax,%ax
80104c98:	66 90                	xchg   %ax,%ax
80104c9a:	66 90                	xchg   %ax,%ax
80104c9c:	66 90                	xchg   %ax,%ax
80104c9e:	66 90                	xchg   %ax,%ax

80104ca0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	57                   	push   %edi
80104ca4:	53                   	push   %ebx
80104ca5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ca8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104cab:	f6 c2 03             	test   $0x3,%dl
80104cae:	75 05                	jne    80104cb5 <memset+0x15>
80104cb0:	f6 c1 03             	test   $0x3,%cl
80104cb3:	74 13                	je     80104cc8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104cb5:	89 d7                	mov    %edx,%edi
80104cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cba:	fc                   	cld    
80104cbb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104cbd:	5b                   	pop    %ebx
80104cbe:	89 d0                	mov    %edx,%eax
80104cc0:	5f                   	pop    %edi
80104cc1:	5d                   	pop    %ebp
80104cc2:	c3                   	ret    
80104cc3:	90                   	nop
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104cc8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104ccc:	c1 e9 02             	shr    $0x2,%ecx
80104ccf:	89 f8                	mov    %edi,%eax
80104cd1:	89 fb                	mov    %edi,%ebx
80104cd3:	c1 e0 18             	shl    $0x18,%eax
80104cd6:	c1 e3 10             	shl    $0x10,%ebx
80104cd9:	09 d8                	or     %ebx,%eax
80104cdb:	09 f8                	or     %edi,%eax
80104cdd:	c1 e7 08             	shl    $0x8,%edi
80104ce0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ce2:	89 d7                	mov    %edx,%edi
80104ce4:	fc                   	cld    
80104ce5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104ce7:	5b                   	pop    %ebx
80104ce8:	89 d0                	mov    %edx,%eax
80104cea:	5f                   	pop    %edi
80104ceb:	5d                   	pop    %ebp
80104cec:	c3                   	ret    
80104ced:	8d 76 00             	lea    0x0(%esi),%esi

80104cf0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
80104cf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104cf9:	8b 75 08             	mov    0x8(%ebp),%esi
80104cfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104cff:	85 db                	test   %ebx,%ebx
80104d01:	74 29                	je     80104d2c <memcmp+0x3c>
    if(*s1 != *s2)
80104d03:	0f b6 16             	movzbl (%esi),%edx
80104d06:	0f b6 0f             	movzbl (%edi),%ecx
80104d09:	38 d1                	cmp    %dl,%cl
80104d0b:	75 2b                	jne    80104d38 <memcmp+0x48>
80104d0d:	b8 01 00 00 00       	mov    $0x1,%eax
80104d12:	eb 14                	jmp    80104d28 <memcmp+0x38>
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d18:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d1c:	83 c0 01             	add    $0x1,%eax
80104d1f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104d24:	38 ca                	cmp    %cl,%dl
80104d26:	75 10                	jne    80104d38 <memcmp+0x48>
  while(n-- > 0){
80104d28:	39 d8                	cmp    %ebx,%eax
80104d2a:	75 ec                	jne    80104d18 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d2c:	5b                   	pop    %ebx
  return 0;
80104d2d:	31 c0                	xor    %eax,%eax
}
80104d2f:	5e                   	pop    %esi
80104d30:	5f                   	pop    %edi
80104d31:	5d                   	pop    %ebp
80104d32:	c3                   	ret    
80104d33:	90                   	nop
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104d38:	0f b6 c2             	movzbl %dl,%eax
}
80104d3b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104d3c:	29 c8                	sub    %ecx,%eax
}
80104d3e:	5e                   	pop    %esi
80104d3f:	5f                   	pop    %edi
80104d40:	5d                   	pop    %ebp
80104d41:	c3                   	ret    
80104d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d50 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
80104d55:	8b 45 08             	mov    0x8(%ebp),%eax
80104d58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d5b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d5e:	39 c3                	cmp    %eax,%ebx
80104d60:	73 26                	jae    80104d88 <memmove+0x38>
80104d62:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104d65:	39 c8                	cmp    %ecx,%eax
80104d67:	73 1f                	jae    80104d88 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104d69:	85 f6                	test   %esi,%esi
80104d6b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104d6e:	74 0f                	je     80104d7f <memmove+0x2f>
      *--d = *--s;
80104d70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104d77:	83 ea 01             	sub    $0x1,%edx
80104d7a:	83 fa ff             	cmp    $0xffffffff,%edx
80104d7d:	75 f1                	jne    80104d70 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d7f:	5b                   	pop    %ebx
80104d80:	5e                   	pop    %esi
80104d81:	5d                   	pop    %ebp
80104d82:	c3                   	ret    
80104d83:	90                   	nop
80104d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104d88:	31 d2                	xor    %edx,%edx
80104d8a:	85 f6                	test   %esi,%esi
80104d8c:	74 f1                	je     80104d7f <memmove+0x2f>
80104d8e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104d90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104d97:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104d9a:	39 d6                	cmp    %edx,%esi
80104d9c:	75 f2                	jne    80104d90 <memmove+0x40>
}
80104d9e:	5b                   	pop    %ebx
80104d9f:	5e                   	pop    %esi
80104da0:	5d                   	pop    %ebp
80104da1:	c3                   	ret    
80104da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104db3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104db4:	eb 9a                	jmp    80104d50 <memmove>
80104db6:	8d 76 00             	lea    0x0(%esi),%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dc0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	57                   	push   %edi
80104dc4:	56                   	push   %esi
80104dc5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104dc8:	53                   	push   %ebx
80104dc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104dcf:	85 ff                	test   %edi,%edi
80104dd1:	74 2f                	je     80104e02 <strncmp+0x42>
80104dd3:	0f b6 01             	movzbl (%ecx),%eax
80104dd6:	0f b6 1e             	movzbl (%esi),%ebx
80104dd9:	84 c0                	test   %al,%al
80104ddb:	74 37                	je     80104e14 <strncmp+0x54>
80104ddd:	38 c3                	cmp    %al,%bl
80104ddf:	75 33                	jne    80104e14 <strncmp+0x54>
80104de1:	01 f7                	add    %esi,%edi
80104de3:	eb 13                	jmp    80104df8 <strncmp+0x38>
80104de5:	8d 76 00             	lea    0x0(%esi),%esi
80104de8:	0f b6 01             	movzbl (%ecx),%eax
80104deb:	84 c0                	test   %al,%al
80104ded:	74 21                	je     80104e10 <strncmp+0x50>
80104def:	0f b6 1a             	movzbl (%edx),%ebx
80104df2:	89 d6                	mov    %edx,%esi
80104df4:	38 d8                	cmp    %bl,%al
80104df6:	75 1c                	jne    80104e14 <strncmp+0x54>
    n--, p++, q++;
80104df8:	8d 56 01             	lea    0x1(%esi),%edx
80104dfb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104dfe:	39 fa                	cmp    %edi,%edx
80104e00:	75 e6                	jne    80104de8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e02:	5b                   	pop    %ebx
    return 0;
80104e03:	31 c0                	xor    %eax,%eax
}
80104e05:	5e                   	pop    %esi
80104e06:	5f                   	pop    %edi
80104e07:	5d                   	pop    %ebp
80104e08:	c3                   	ret    
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e10:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e14:	29 d8                	sub    %ebx,%eax
}
80104e16:	5b                   	pop    %ebx
80104e17:	5e                   	pop    %esi
80104e18:	5f                   	pop    %edi
80104e19:	5d                   	pop    %ebp
80104e1a:	c3                   	ret    
80104e1b:	90                   	nop
80104e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
  while(n-- > 0)
80104e6b:	85 db                	test   %ebx,%ebx
80104e6d:	7f f1                	jg     80104e60 <strncpy+0x40>
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
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	8b 55 08             	mov    0x8(%ebp),%edx
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
80104efa:	e8 01 ee ff ff       	call   80103d00 <myproc>

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
80104f3a:	e8 c1 ed ff ff       	call   80103d00 <myproc>

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
80104f55:	eb 39                	jmp    80104f90 <fetchstr+0x60>
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f60:	80 3a 00             	cmpb   $0x0,(%edx)
80104f63:	74 1b                	je     80104f80 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104f65:	83 c2 01             	add    $0x1,%edx
80104f68:	39 d0                	cmp    %edx,%eax
80104f6a:	77 f4                	ja     80104f60 <fetchstr+0x30>
    return -1;
80104f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104f71:	83 c4 04             	add    $0x4,%esp
80104f74:	5b                   	pop    %ebx
80104f75:	5d                   	pop    %ebp
80104f76:	c3                   	ret    
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f80:	83 c4 04             	add    $0x4,%esp
80104f83:	89 d0                	mov    %edx,%eax
80104f85:	29 d8                	sub    %ebx,%eax
80104f87:	5b                   	pop    %ebx
80104f88:	5d                   	pop    %ebp
80104f89:	c3                   	ret    
80104f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104f90:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104f92:	eb dd                	jmp    80104f71 <fetchstr+0x41>
80104f94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104fa0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fa5:	e8 56 ed ff ff       	call   80103d00 <myproc>
80104faa:	8b 40 18             	mov    0x18(%eax),%eax
80104fad:	8b 55 08             	mov    0x8(%ebp),%edx
80104fb0:	8b 40 44             	mov    0x44(%eax),%eax
80104fb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fb6:	e8 45 ed ff ff       	call   80103d00 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fbb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fbd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fc0:	39 c6                	cmp    %eax,%esi
80104fc2:	73 1c                	jae    80104fe0 <argint+0x40>
80104fc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fc7:	39 d0                	cmp    %edx,%eax
80104fc9:	72 15                	jb     80104fe0 <argint+0x40>
  *ip = *(int*)(addr);
80104fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fce:	8b 53 04             	mov    0x4(%ebx),%edx
80104fd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104fd3:	31 c0                	xor    %eax,%eax
}
80104fd5:	5b                   	pop    %ebx
80104fd6:	5e                   	pop    %esi
80104fd7:	5d                   	pop    %ebp
80104fd8:	c3                   	ret    
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fe5:	eb ee                	jmp    80104fd5 <argint+0x35>
80104fe7:	89 f6                	mov    %esi,%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ff0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
80104ff5:	83 ec 10             	sub    $0x10,%esp
80104ff8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104ffb:	e8 00 ed ff ff       	call   80103d00 <myproc>
80105000:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105002:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105005:	83 ec 08             	sub    $0x8,%esp
80105008:	50                   	push   %eax
80105009:	ff 75 08             	pushl  0x8(%ebp)
8010500c:	e8 8f ff ff ff       	call   80104fa0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105011:	83 c4 10             	add    $0x10,%esp
80105014:	85 c0                	test   %eax,%eax
80105016:	78 28                	js     80105040 <argptr+0x50>
80105018:	85 db                	test   %ebx,%ebx
8010501a:	78 24                	js     80105040 <argptr+0x50>
8010501c:	8b 16                	mov    (%esi),%edx
8010501e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105021:	39 c2                	cmp    %eax,%edx
80105023:	76 1b                	jbe    80105040 <argptr+0x50>
80105025:	01 c3                	add    %eax,%ebx
80105027:	39 da                	cmp    %ebx,%edx
80105029:	72 15                	jb     80105040 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010502b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010502e:	89 02                	mov    %eax,(%edx)
  return 0;
80105030:	31 c0                	xor    %eax,%eax
}
80105032:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105035:	5b                   	pop    %ebx
80105036:	5e                   	pop    %esi
80105037:	5d                   	pop    %ebp
80105038:	c3                   	ret    
80105039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105045:	eb eb                	jmp    80105032 <argptr+0x42>
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105056:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105059:	50                   	push   %eax
8010505a:	ff 75 08             	pushl  0x8(%ebp)
8010505d:	e8 3e ff ff ff       	call   80104fa0 <argint>
80105062:	83 c4 10             	add    $0x10,%esp
80105065:	85 c0                	test   %eax,%eax
80105067:	78 17                	js     80105080 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105069:	83 ec 08             	sub    $0x8,%esp
8010506c:	ff 75 0c             	pushl  0xc(%ebp)
8010506f:	ff 75 f4             	pushl  -0xc(%ebp)
80105072:	e8 b9 fe ff ff       	call   80104f30 <fetchstr>
80105077:	83 c4 10             	add    $0x10,%esp
}
8010507a:	c9                   	leave  
8010507b:	c3                   	ret    
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105085:	c9                   	leave  
80105086:	c3                   	ret    
80105087:	89 f6                	mov    %esi,%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105090 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	53                   	push   %ebx
80105094:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105097:	e8 64 ec ff ff       	call   80103d00 <myproc>
8010509c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010509e:	8b 40 18             	mov    0x18(%eax),%eax
801050a1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801050a7:	83 fa 15             	cmp    $0x15,%edx
801050aa:	77 1c                	ja     801050c8 <syscall+0x38>
801050ac:	8b 14 85 a0 84 10 80 	mov    -0x7fef7b60(,%eax,4),%edx
801050b3:	85 d2                	test   %edx,%edx
801050b5:	74 11                	je     801050c8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801050b7:	ff d2                	call   *%edx
801050b9:	8b 53 18             	mov    0x18(%ebx),%edx
801050bc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050c2:	c9                   	leave  
801050c3:	c3                   	ret    
801050c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801050c8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050c9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801050cc:	50                   	push   %eax
801050cd:	ff 73 10             	pushl  0x10(%ebx)
801050d0:	68 65 84 10 80       	push   $0x80108465
801050d5:	e8 86 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801050da:	8b 43 18             	mov    0x18(%ebx),%eax
801050dd:	83 c4 10             	add    $0x10,%esp
801050e0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801050e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050ea:	c9                   	leave  
801050eb:	c3                   	ret    
801050ec:	66 90                	xchg   %ax,%ax
801050ee:	66 90                	xchg   %ax,%ax

801050f0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	56                   	push   %esi
801050f4:	53                   	push   %ebx
801050f5:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801050f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801050fa:	89 d6                	mov    %edx,%esi
801050fc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050ff:	50                   	push   %eax
80105100:	6a 00                	push   $0x0
80105102:	e8 99 fe ff ff       	call   80104fa0 <argint>
80105107:	83 c4 10             	add    $0x10,%esp
8010510a:	85 c0                	test   %eax,%eax
8010510c:	78 2a                	js     80105138 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010510e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105112:	77 24                	ja     80105138 <argfd.constprop.0+0x48>
80105114:	e8 e7 eb ff ff       	call   80103d00 <myproc>
80105119:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010511c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105120:	85 c0                	test   %eax,%eax
80105122:	74 14                	je     80105138 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105124:	85 db                	test   %ebx,%ebx
80105126:	74 02                	je     8010512a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105128:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010512a:	89 06                	mov    %eax,(%esi)
  return 0;
8010512c:	31 c0                	xor    %eax,%eax
}
8010512e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105131:	5b                   	pop    %ebx
80105132:	5e                   	pop    %esi
80105133:	5d                   	pop    %ebp
80105134:	c3                   	ret    
80105135:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513d:	eb ef                	jmp    8010512e <argfd.constprop.0+0x3e>
8010513f:	90                   	nop

80105140 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105140:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105141:	31 c0                	xor    %eax,%eax
{
80105143:	89 e5                	mov    %esp,%ebp
80105145:	56                   	push   %esi
80105146:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105147:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010514a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010514d:	e8 9e ff ff ff       	call   801050f0 <argfd.constprop.0>
80105152:	85 c0                	test   %eax,%eax
80105154:	78 42                	js     80105198 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105156:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105159:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010515b:	e8 a0 eb ff ff       	call   80103d00 <myproc>
80105160:	eb 0e                	jmp    80105170 <sys_dup+0x30>
80105162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105168:	83 c3 01             	add    $0x1,%ebx
8010516b:	83 fb 10             	cmp    $0x10,%ebx
8010516e:	74 28                	je     80105198 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105170:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105174:	85 d2                	test   %edx,%edx
80105176:	75 f0                	jne    80105168 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105178:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010517c:	83 ec 0c             	sub    $0xc,%esp
8010517f:	ff 75 f4             	pushl  -0xc(%ebp)
80105182:	e8 99 bc ff ff       	call   80100e20 <filedup>
  return fd;
80105187:	83 c4 10             	add    $0x10,%esp
}
8010518a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010518d:	89 d8                	mov    %ebx,%eax
8010518f:	5b                   	pop    %ebx
80105190:	5e                   	pop    %esi
80105191:	5d                   	pop    %ebp
80105192:	c3                   	ret    
80105193:	90                   	nop
80105194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105198:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010519b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051a0:	89 d8                	mov    %ebx,%eax
801051a2:	5b                   	pop    %ebx
801051a3:	5e                   	pop    %esi
801051a4:	5d                   	pop    %ebp
801051a5:	c3                   	ret    
801051a6:	8d 76 00             	lea    0x0(%esi),%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
{
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051bb:	e8 30 ff ff ff       	call   801050f0 <argfd.constprop.0>
801051c0:	85 c0                	test   %eax,%eax
801051c2:	78 4c                	js     80105210 <sys_read+0x60>
801051c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c7:	83 ec 08             	sub    $0x8,%esp
801051ca:	50                   	push   %eax
801051cb:	6a 02                	push   $0x2
801051cd:	e8 ce fd ff ff       	call   80104fa0 <argint>
801051d2:	83 c4 10             	add    $0x10,%esp
801051d5:	85 c0                	test   %eax,%eax
801051d7:	78 37                	js     80105210 <sys_read+0x60>
801051d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051dc:	83 ec 04             	sub    $0x4,%esp
801051df:	ff 75 f0             	pushl  -0x10(%ebp)
801051e2:	50                   	push   %eax
801051e3:	6a 01                	push   $0x1
801051e5:	e8 06 fe ff ff       	call   80104ff0 <argptr>
801051ea:	83 c4 10             	add    $0x10,%esp
801051ed:	85 c0                	test   %eax,%eax
801051ef:	78 1f                	js     80105210 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801051f1:	83 ec 04             	sub    $0x4,%esp
801051f4:	ff 75 f0             	pushl  -0x10(%ebp)
801051f7:	ff 75 f4             	pushl  -0xc(%ebp)
801051fa:	ff 75 ec             	pushl  -0x14(%ebp)
801051fd:	e8 8e bd ff ff       	call   80100f90 <fileread>
80105202:	83 c4 10             	add    $0x10,%esp
}
80105205:	c9                   	leave  
80105206:	c3                   	ret    
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
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
{
80105223:	89 e5                	mov    %esp,%ebp
80105225:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105228:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010522b:	e8 c0 fe ff ff       	call   801050f0 <argfd.constprop.0>
80105230:	85 c0                	test   %eax,%eax
80105232:	78 4c                	js     80105280 <sys_write+0x60>
80105234:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105237:	83 ec 08             	sub    $0x8,%esp
8010523a:	50                   	push   %eax
8010523b:	6a 02                	push   $0x2
8010523d:	e8 5e fd ff ff       	call   80104fa0 <argint>
80105242:	83 c4 10             	add    $0x10,%esp
80105245:	85 c0                	test   %eax,%eax
80105247:	78 37                	js     80105280 <sys_write+0x60>
80105249:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010524c:	83 ec 04             	sub    $0x4,%esp
8010524f:	ff 75 f0             	pushl  -0x10(%ebp)
80105252:	50                   	push   %eax
80105253:	6a 01                	push   $0x1
80105255:	e8 96 fd ff ff       	call   80104ff0 <argptr>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	85 c0                	test   %eax,%eax
8010525f:	78 1f                	js     80105280 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105261:	83 ec 04             	sub    $0x4,%esp
80105264:	ff 75 f0             	pushl  -0x10(%ebp)
80105267:	ff 75 f4             	pushl  -0xc(%ebp)
8010526a:	ff 75 ec             	pushl  -0x14(%ebp)
8010526d:	e8 ae bd ff ff       	call   80101020 <filewrite>
80105272:	83 c4 10             	add    $0x10,%esp
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
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
8010529c:	e8 4f fe ff ff       	call   801050f0 <argfd.constprop.0>
801052a1:	85 c0                	test   %eax,%eax
801052a3:	78 2b                	js     801052d0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801052a5:	e8 56 ea ff ff       	call   80103d00 <myproc>
801052aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801052ad:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801052b0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801052b7:	00 
  fileclose(f);
801052b8:	ff 75 f4             	pushl  -0xc(%ebp)
801052bb:	e8 b0 bb ff ff       	call   80100e70 <fileclose>
  return 0;
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	31 c0                	xor    %eax,%eax
}
801052c5:	c9                   	leave  
801052c6:	c3                   	ret    
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
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
{
801052e3:	89 e5                	mov    %esp,%ebp
801052e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801052e8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801052eb:	e8 00 fe ff ff       	call   801050f0 <argfd.constprop.0>
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 2c                	js     80105320 <sys_fstat+0x40>
801052f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052f7:	83 ec 04             	sub    $0x4,%esp
801052fa:	6a 14                	push   $0x14
801052fc:	50                   	push   %eax
801052fd:	6a 01                	push   $0x1
801052ff:	e8 ec fc ff ff       	call   80104ff0 <argptr>
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	85 c0                	test   %eax,%eax
80105309:	78 15                	js     80105320 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010530b:	83 ec 08             	sub    $0x8,%esp
8010530e:	ff 75 f4             	pushl  -0xc(%ebp)
80105311:	ff 75 f0             	pushl  -0x10(%ebp)
80105314:	e8 27 bc ff ff       	call   80100f40 <filestat>
80105319:	83 c4 10             	add    $0x10,%esp
}
8010531c:	c9                   	leave  
8010531d:	c3                   	ret    
8010531e:	66 90                	xchg   %ax,%ax
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
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
{
80105339:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010533c:	50                   	push   %eax
8010533d:	6a 00                	push   $0x0
8010533f:	e8 0c fd ff ff       	call   80105050 <argstr>
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	85 c0                	test   %eax,%eax
80105349:	0f 88 fb 00 00 00    	js     8010544a <sys_link+0x11a>
8010534f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105352:	83 ec 08             	sub    $0x8,%esp
80105355:	50                   	push   %eax
80105356:	6a 01                	push   $0x1
80105358:	e8 f3 fc ff ff       	call   80105050 <argstr>
8010535d:	83 c4 10             	add    $0x10,%esp
80105360:	85 c0                	test   %eax,%eax
80105362:	0f 88 e2 00 00 00    	js     8010544a <sys_link+0x11a>
    return -1;

  begin_op();
80105368:	e8 83 dc ff ff       	call   80102ff0 <begin_op>
  if((ip = namei(old)) == 0){
8010536d:	83 ec 0c             	sub    $0xc,%esp
80105370:	ff 75 d4             	pushl  -0x2c(%ebp)
80105373:	e8 a8 cb ff ff       	call   80101f20 <namei>
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	85 c0                	test   %eax,%eax
8010537d:	89 c3                	mov    %eax,%ebx
8010537f:	0f 84 ea 00 00 00    	je     8010546f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105385:	83 ec 0c             	sub    $0xc,%esp
80105388:	50                   	push   %eax
80105389:	e8 32 c3 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105396:	0f 84 bb 00 00 00    	je     80105457 <sys_link+0x127>
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
  iupdate(ip);
801053a7:	53                   	push   %ebx
801053a8:	e8 63 c2 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
801053ad:	89 1c 24             	mov    %ebx,(%esp)
801053b0:	e8 eb c3 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053b5:	58                   	pop    %eax
801053b6:	5a                   	pop    %edx
801053b7:	57                   	push   %edi
801053b8:	ff 75 d0             	pushl  -0x30(%ebp)
801053bb:	e8 80 cb ff ff       	call   80101f40 <nameiparent>
801053c0:	83 c4 10             	add    $0x10,%esp
801053c3:	85 c0                	test   %eax,%eax
801053c5:	89 c6                	mov    %eax,%esi
801053c7:	74 5b                	je     80105424 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	50                   	push   %eax
801053cd:	e8 ee c2 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	8b 03                	mov    (%ebx),%eax
801053d7:	39 06                	cmp    %eax,(%esi)
801053d9:	75 3d                	jne    80105418 <sys_link+0xe8>
801053db:	83 ec 04             	sub    $0x4,%esp
801053de:	ff 73 04             	pushl  0x4(%ebx)
801053e1:	57                   	push   %edi
801053e2:	56                   	push   %esi
801053e3:	e8 78 ca ff ff       	call   80101e60 <dirlink>
801053e8:	83 c4 10             	add    $0x10,%esp
801053eb:	85 c0                	test   %eax,%eax
801053ed:	78 29                	js     80105418 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801053ef:	83 ec 0c             	sub    $0xc,%esp
801053f2:	56                   	push   %esi
801053f3:	e8 58 c5 ff ff       	call   80101950 <iunlockput>
  iput(ip);
801053f8:	89 1c 24             	mov    %ebx,(%esp)
801053fb:	e8 f0 c3 ff ff       	call   801017f0 <iput>

  end_op();
80105400:	e8 5b dc ff ff       	call   80103060 <end_op>

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
    iunlockput(dp);
80105418:	83 ec 0c             	sub    $0xc,%esp
8010541b:	56                   	push   %esi
8010541c:	e8 2f c5 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105421:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	53                   	push   %ebx
80105428:	e8 93 c2 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
8010542d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105432:	89 1c 24             	mov    %ebx,(%esp)
80105435:	e8 d6 c1 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
8010543a:	89 1c 24             	mov    %ebx,(%esp)
8010543d:	e8 0e c5 ff ff       	call   80101950 <iunlockput>
  end_op();
80105442:	e8 19 dc ff ff       	call   80103060 <end_op>
  return -1;
80105447:	83 c4 10             	add    $0x10,%esp
}
8010544a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010544d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105452:	5b                   	pop    %ebx
80105453:	5e                   	pop    %esi
80105454:	5f                   	pop    %edi
80105455:	5d                   	pop    %ebp
80105456:	c3                   	ret    
    iunlockput(ip);
80105457:	83 ec 0c             	sub    $0xc,%esp
8010545a:	53                   	push   %ebx
8010545b:	e8 f0 c4 ff ff       	call   80101950 <iunlockput>
    end_op();
80105460:	e8 fb db ff ff       	call   80103060 <end_op>
    return -1;
80105465:	83 c4 10             	add    $0x10,%esp
80105468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546d:	eb 9b                	jmp    8010540a <sys_link+0xda>
    end_op();
8010546f:	e8 ec db ff ff       	call   80103060 <end_op>
    return -1;
80105474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105479:	eb 8f                	jmp    8010540a <sys_link+0xda>
8010547b:	90                   	nop
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	57                   	push   %edi
80105484:	56                   	push   %esi
80105485:	53                   	push   %ebx
80105486:	83 ec 1c             	sub    $0x1c,%esp
80105489:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010548c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105490:	76 3e                	jbe    801054d0 <isdirempty+0x50>
80105492:	bb 20 00 00 00       	mov    $0x20,%ebx
80105497:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010549a:	eb 0c                	jmp    801054a8 <isdirempty+0x28>
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054a0:	83 c3 10             	add    $0x10,%ebx
801054a3:	3b 5e 58             	cmp    0x58(%esi),%ebx
801054a6:	73 28                	jae    801054d0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054a8:	6a 10                	push   $0x10
801054aa:	53                   	push   %ebx
801054ab:	57                   	push   %edi
801054ac:	56                   	push   %esi
801054ad:	e8 ee c4 ff ff       	call   801019a0 <readi>
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	83 f8 10             	cmp    $0x10,%eax
801054b8:	75 23                	jne    801054dd <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801054ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054bf:	74 df                	je     801054a0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801054c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801054c4:	31 c0                	xor    %eax,%eax
}
801054c6:	5b                   	pop    %ebx
801054c7:	5e                   	pop    %esi
801054c8:	5f                   	pop    %edi
801054c9:	5d                   	pop    %ebp
801054ca:	c3                   	ret    
801054cb:	90                   	nop
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801054d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801054d8:	5b                   	pop    %ebx
801054d9:	5e                   	pop    %esi
801054da:	5f                   	pop    %edi
801054db:	5d                   	pop    %ebp
801054dc:	c3                   	ret    
      panic("isdirempty: readi");
801054dd:	83 ec 0c             	sub    $0xc,%esp
801054e0:	68 fc 84 10 80       	push   $0x801084fc
801054e5:	e8 a6 ae ff ff       	call   80100390 <panic>
801054ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054f0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
801054f5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801054f9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801054fc:	50                   	push   %eax
801054fd:	6a 00                	push   $0x0
801054ff:	e8 4c fb ff ff       	call   80105050 <argstr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	0f 88 51 01 00 00    	js     80105660 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010550f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105512:	e8 d9 da ff ff       	call   80102ff0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105517:	83 ec 08             	sub    $0x8,%esp
8010551a:	53                   	push   %ebx
8010551b:	ff 75 c0             	pushl  -0x40(%ebp)
8010551e:	e8 1d ca ff ff       	call   80101f40 <nameiparent>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	89 c6                	mov    %eax,%esi
8010552a:	0f 84 37 01 00 00    	je     80105667 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	50                   	push   %eax
80105534:	e8 87 c1 ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105539:	58                   	pop    %eax
8010553a:	5a                   	pop    %edx
8010553b:	68 bd 7e 10 80       	push   $0x80107ebd
80105540:	53                   	push   %ebx
80105541:	e8 8a c6 ff ff       	call   80101bd0 <namecmp>
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	85 c0                	test   %eax,%eax
8010554b:	0f 84 d7 00 00 00    	je     80105628 <sys_unlink+0x138>
80105551:	83 ec 08             	sub    $0x8,%esp
80105554:	68 bc 7e 10 80       	push   $0x80107ebc
80105559:	53                   	push   %ebx
8010555a:	e8 71 c6 ff ff       	call   80101bd0 <namecmp>
8010555f:	83 c4 10             	add    $0x10,%esp
80105562:	85 c0                	test   %eax,%eax
80105564:	0f 84 be 00 00 00    	je     80105628 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010556a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010556d:	83 ec 04             	sub    $0x4,%esp
80105570:	50                   	push   %eax
80105571:	53                   	push   %ebx
80105572:	56                   	push   %esi
80105573:	e8 78 c6 ff ff       	call   80101bf0 <dirlookup>
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	85 c0                	test   %eax,%eax
8010557d:	89 c3                	mov    %eax,%ebx
8010557f:	0f 84 a3 00 00 00    	je     80105628 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105585:	83 ec 0c             	sub    $0xc,%esp
80105588:	50                   	push   %eax
80105589:	e8 32 c1 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105596:	0f 8e e4 00 00 00    	jle    80105680 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010559c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055a1:	74 65                	je     80105608 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801055a3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801055a6:	83 ec 04             	sub    $0x4,%esp
801055a9:	6a 10                	push   $0x10
801055ab:	6a 00                	push   $0x0
801055ad:	57                   	push   %edi
801055ae:	e8 ed f6 ff ff       	call   80104ca0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055b3:	6a 10                	push   $0x10
801055b5:	ff 75 c4             	pushl  -0x3c(%ebp)
801055b8:	57                   	push   %edi
801055b9:	56                   	push   %esi
801055ba:	e8 e1 c4 ff ff       	call   80101aa0 <writei>
801055bf:	83 c4 20             	add    $0x20,%esp
801055c2:	83 f8 10             	cmp    $0x10,%eax
801055c5:	0f 85 a8 00 00 00    	jne    80105673 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801055cb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055d0:	74 6e                	je     80105640 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801055d2:	83 ec 0c             	sub    $0xc,%esp
801055d5:	56                   	push   %esi
801055d6:	e8 75 c3 ff ff       	call   80101950 <iunlockput>

  ip->nlink--;
801055db:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055e0:	89 1c 24             	mov    %ebx,(%esp)
801055e3:	e8 28 c0 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
801055e8:	89 1c 24             	mov    %ebx,(%esp)
801055eb:	e8 60 c3 ff ff       	call   80101950 <iunlockput>

  end_op();
801055f0:	e8 6b da ff ff       	call   80103060 <end_op>

  return 0;
801055f5:	83 c4 10             	add    $0x10,%esp
801055f8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801055fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055fd:	5b                   	pop    %ebx
801055fe:	5e                   	pop    %esi
801055ff:	5f                   	pop    %edi
80105600:	5d                   	pop    %ebp
80105601:	c3                   	ret    
80105602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105608:	83 ec 0c             	sub    $0xc,%esp
8010560b:	53                   	push   %ebx
8010560c:	e8 6f fe ff ff       	call   80105480 <isdirempty>
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	85 c0                	test   %eax,%eax
80105616:	75 8b                	jne    801055a3 <sys_unlink+0xb3>
    iunlockput(ip);
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	53                   	push   %ebx
8010561c:	e8 2f c3 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105621:	83 c4 10             	add    $0x10,%esp
80105624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	56                   	push   %esi
8010562c:	e8 1f c3 ff ff       	call   80101950 <iunlockput>
  end_op();
80105631:	e8 2a da ff ff       	call   80103060 <end_op>
  return -1;
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563e:	eb ba                	jmp    801055fa <sys_unlink+0x10a>
    dp->nlink--;
80105640:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105645:	83 ec 0c             	sub    $0xc,%esp
80105648:	56                   	push   %esi
80105649:	e8 c2 bf ff ff       	call   80101610 <iupdate>
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	e9 7c ff ff ff       	jmp    801055d2 <sys_unlink+0xe2>
80105656:	8d 76 00             	lea    0x0(%esi),%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105665:	eb 93                	jmp    801055fa <sys_unlink+0x10a>
    end_op();
80105667:	e8 f4 d9 ff ff       	call   80103060 <end_op>
    return -1;
8010566c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105671:	eb 87                	jmp    801055fa <sys_unlink+0x10a>
    panic("unlink: writei");
80105673:	83 ec 0c             	sub    $0xc,%esp
80105676:	68 d1 7e 10 80       	push   $0x80107ed1
8010567b:	e8 10 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105680:	83 ec 0c             	sub    $0xc,%esp
80105683:	68 bf 7e 10 80       	push   $0x80107ebf
80105688:	e8 03 ad ff ff       	call   80100390 <panic>
8010568d:	8d 76 00             	lea    0x0(%esi),%esi

80105690 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	57                   	push   %edi
80105694:	56                   	push   %esi
80105695:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105696:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105699:	83 ec 44             	sub    $0x44,%esp
8010569c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010569f:	8b 55 10             	mov    0x10(%ebp),%edx
801056a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801056a5:	56                   	push   %esi
801056a6:	ff 75 08             	pushl  0x8(%ebp)
{
801056a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801056ac:	89 55 c0             	mov    %edx,-0x40(%ebp)
801056af:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801056b2:	e8 89 c8 ff ff       	call   80101f40 <nameiparent>
801056b7:	83 c4 10             	add    $0x10,%esp
801056ba:	85 c0                	test   %eax,%eax
801056bc:	0f 84 4e 01 00 00    	je     80105810 <create+0x180>
    return 0;
  ilock(dp);
801056c2:	83 ec 0c             	sub    $0xc,%esp
801056c5:	89 c3                	mov    %eax,%ebx
801056c7:	50                   	push   %eax
801056c8:	e8 f3 bf ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801056cd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801056d0:	83 c4 0c             	add    $0xc,%esp
801056d3:	50                   	push   %eax
801056d4:	56                   	push   %esi
801056d5:	53                   	push   %ebx
801056d6:	e8 15 c5 ff ff       	call   80101bf0 <dirlookup>
801056db:	83 c4 10             	add    $0x10,%esp
801056de:	85 c0                	test   %eax,%eax
801056e0:	89 c7                	mov    %eax,%edi
801056e2:	74 3c                	je     80105720 <create+0x90>
    iunlockput(dp);
801056e4:	83 ec 0c             	sub    $0xc,%esp
801056e7:	53                   	push   %ebx
801056e8:	e8 63 c2 ff ff       	call   80101950 <iunlockput>
    ilock(ip);
801056ed:	89 3c 24             	mov    %edi,(%esp)
801056f0:	e8 cb bf ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801056f5:	83 c4 10             	add    $0x10,%esp
801056f8:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801056fd:	0f 85 9d 00 00 00    	jne    801057a0 <create+0x110>
80105703:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105708:	0f 85 92 00 00 00    	jne    801057a0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010570e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105711:	89 f8                	mov    %edi,%eax
80105713:	5b                   	pop    %ebx
80105714:	5e                   	pop    %esi
80105715:	5f                   	pop    %edi
80105716:	5d                   	pop    %ebp
80105717:	c3                   	ret    
80105718:	90                   	nop
80105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80105720:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105724:	83 ec 08             	sub    $0x8,%esp
80105727:	50                   	push   %eax
80105728:	ff 33                	pushl  (%ebx)
8010572a:	e8 21 be ff ff       	call   80101550 <ialloc>
8010572f:	83 c4 10             	add    $0x10,%esp
80105732:	85 c0                	test   %eax,%eax
80105734:	89 c7                	mov    %eax,%edi
80105736:	0f 84 e8 00 00 00    	je     80105824 <create+0x194>
  ilock(ip);
8010573c:	83 ec 0c             	sub    $0xc,%esp
8010573f:	50                   	push   %eax
80105740:	e8 7b bf ff ff       	call   801016c0 <ilock>
  ip->major = major;
80105745:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105749:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010574d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105751:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105755:	b8 01 00 00 00       	mov    $0x1,%eax
8010575a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010575e:	89 3c 24             	mov    %edi,(%esp)
80105761:	e8 aa be ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010576e:	74 50                	je     801057c0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105770:	83 ec 04             	sub    $0x4,%esp
80105773:	ff 77 04             	pushl  0x4(%edi)
80105776:	56                   	push   %esi
80105777:	53                   	push   %ebx
80105778:	e8 e3 c6 ff ff       	call   80101e60 <dirlink>
8010577d:	83 c4 10             	add    $0x10,%esp
80105780:	85 c0                	test   %eax,%eax
80105782:	0f 88 8f 00 00 00    	js     80105817 <create+0x187>
  iunlockput(dp);
80105788:	83 ec 0c             	sub    $0xc,%esp
8010578b:	53                   	push   %ebx
8010578c:	e8 bf c1 ff ff       	call   80101950 <iunlockput>
  return ip;
80105791:	83 c4 10             	add    $0x10,%esp
}
80105794:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105797:	89 f8                	mov    %edi,%eax
80105799:	5b                   	pop    %ebx
8010579a:	5e                   	pop    %esi
8010579b:	5f                   	pop    %edi
8010579c:	5d                   	pop    %ebp
8010579d:	c3                   	ret    
8010579e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801057a0:	83 ec 0c             	sub    $0xc,%esp
801057a3:	57                   	push   %edi
    return 0;
801057a4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801057a6:	e8 a5 c1 ff ff       	call   80101950 <iunlockput>
    return 0;
801057ab:	83 c4 10             	add    $0x10,%esp
}
801057ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b1:	89 f8                	mov    %edi,%eax
801057b3:	5b                   	pop    %ebx
801057b4:	5e                   	pop    %esi
801057b5:	5f                   	pop    %edi
801057b6:	5d                   	pop    %ebp
801057b7:	c3                   	ret    
801057b8:	90                   	nop
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801057c0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801057c5:	83 ec 0c             	sub    $0xc,%esp
801057c8:	53                   	push   %ebx
801057c9:	e8 42 be ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057ce:	83 c4 0c             	add    $0xc,%esp
801057d1:	ff 77 04             	pushl  0x4(%edi)
801057d4:	68 bd 7e 10 80       	push   $0x80107ebd
801057d9:	57                   	push   %edi
801057da:	e8 81 c6 ff ff       	call   80101e60 <dirlink>
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	85 c0                	test   %eax,%eax
801057e4:	78 1c                	js     80105802 <create+0x172>
801057e6:	83 ec 04             	sub    $0x4,%esp
801057e9:	ff 73 04             	pushl  0x4(%ebx)
801057ec:	68 bc 7e 10 80       	push   $0x80107ebc
801057f1:	57                   	push   %edi
801057f2:	e8 69 c6 ff ff       	call   80101e60 <dirlink>
801057f7:	83 c4 10             	add    $0x10,%esp
801057fa:	85 c0                	test   %eax,%eax
801057fc:	0f 89 6e ff ff ff    	jns    80105770 <create+0xe0>
      panic("create dots");
80105802:	83 ec 0c             	sub    $0xc,%esp
80105805:	68 1d 85 10 80       	push   $0x8010851d
8010580a:	e8 81 ab ff ff       	call   80100390 <panic>
8010580f:	90                   	nop
    return 0;
80105810:	31 ff                	xor    %edi,%edi
80105812:	e9 f7 fe ff ff       	jmp    8010570e <create+0x7e>
    panic("create: dirlink");
80105817:	83 ec 0c             	sub    $0xc,%esp
8010581a:	68 29 85 10 80       	push   $0x80108529
8010581f:	e8 6c ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105824:	83 ec 0c             	sub    $0xc,%esp
80105827:	68 0e 85 10 80       	push   $0x8010850e
8010582c:	e8 5f ab ff ff       	call   80100390 <panic>
80105831:	eb 0d                	jmp    80105840 <sys_open>
80105833:	90                   	nop
80105834:	90                   	nop
80105835:	90                   	nop
80105836:	90                   	nop
80105837:	90                   	nop
80105838:	90                   	nop
80105839:	90                   	nop
8010583a:	90                   	nop
8010583b:	90                   	nop
8010583c:	90                   	nop
8010583d:	90                   	nop
8010583e:	90                   	nop
8010583f:	90                   	nop

80105840 <sys_open>:

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
{
80105849:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010584c:	50                   	push   %eax
8010584d:	6a 00                	push   $0x0
8010584f:	e8 fc f7 ff ff       	call   80105050 <argstr>
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	85 c0                	test   %eax,%eax
80105859:	0f 88 1d 01 00 00    	js     8010597c <sys_open+0x13c>
8010585f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105862:	83 ec 08             	sub    $0x8,%esp
80105865:	50                   	push   %eax
80105866:	6a 01                	push   $0x1
80105868:	e8 33 f7 ff ff       	call   80104fa0 <argint>
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	85 c0                	test   %eax,%eax
80105872:	0f 88 04 01 00 00    	js     8010597c <sys_open+0x13c>
    return -1;

  begin_op();
80105878:	e8 73 d7 ff ff       	call   80102ff0 <begin_op>

  if(omode & O_CREATE){
8010587d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105881:	0f 85 a9 00 00 00    	jne    80105930 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105887:	83 ec 0c             	sub    $0xc,%esp
8010588a:	ff 75 e0             	pushl  -0x20(%ebp)
8010588d:	e8 8e c6 ff ff       	call   80101f20 <namei>
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	85 c0                	test   %eax,%eax
80105897:	89 c6                	mov    %eax,%esi
80105899:	0f 84 ac 00 00 00    	je     8010594b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010589f:	83 ec 0c             	sub    $0xc,%esp
801058a2:	50                   	push   %eax
801058a3:	e8 18 be ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058a8:	83 c4 10             	add    $0x10,%esp
801058ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058b0:	0f 84 aa 00 00 00    	je     80105960 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058b6:	e8 f5 b4 ff ff       	call   80100db0 <filealloc>
801058bb:	85 c0                	test   %eax,%eax
801058bd:	89 c7                	mov    %eax,%edi
801058bf:	0f 84 a6 00 00 00    	je     8010596b <sys_open+0x12b>
  struct proc *curproc = myproc();
801058c5:	e8 36 e4 ff ff       	call   80103d00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ca:	31 db                	xor    %ebx,%ebx
801058cc:	eb 0e                	jmp    801058dc <sys_open+0x9c>
801058ce:	66 90                	xchg   %ax,%ax
801058d0:	83 c3 01             	add    $0x1,%ebx
801058d3:	83 fb 10             	cmp    $0x10,%ebx
801058d6:	0f 84 ac 00 00 00    	je     80105988 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801058dc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801058e0:	85 d2                	test   %edx,%edx
801058e2:	75 ec                	jne    801058d0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058e4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801058e7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801058eb:	56                   	push   %esi
801058ec:	e8 af be ff ff       	call   801017a0 <iunlock>
  end_op();
801058f1:	e8 6a d7 ff ff       	call   80103060 <end_op>

  f->type = FD_INODE;
801058f6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801058fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058ff:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105902:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105905:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010590c:	89 d0                	mov    %edx,%eax
8010590e:	f7 d0                	not    %eax
80105910:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105913:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105916:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105919:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010591d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105920:	89 d8                	mov    %ebx,%eax
80105922:	5b                   	pop    %ebx
80105923:	5e                   	pop    %esi
80105924:	5f                   	pop    %edi
80105925:	5d                   	pop    %ebp
80105926:	c3                   	ret    
80105927:	89 f6                	mov    %esi,%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105930:	6a 00                	push   $0x0
80105932:	6a 00                	push   $0x0
80105934:	6a 02                	push   $0x2
80105936:	ff 75 e0             	pushl  -0x20(%ebp)
80105939:	e8 52 fd ff ff       	call   80105690 <create>
    if(ip == 0){
8010593e:	83 c4 10             	add    $0x10,%esp
80105941:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105943:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105945:	0f 85 6b ff ff ff    	jne    801058b6 <sys_open+0x76>
      end_op();
8010594b:	e8 10 d7 ff ff       	call   80103060 <end_op>
      return -1;
80105950:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105955:	eb c6                	jmp    8010591d <sys_open+0xdd>
80105957:	89 f6                	mov    %esi,%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105960:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105963:	85 c9                	test   %ecx,%ecx
80105965:	0f 84 4b ff ff ff    	je     801058b6 <sys_open+0x76>
    iunlockput(ip);
8010596b:	83 ec 0c             	sub    $0xc,%esp
8010596e:	56                   	push   %esi
8010596f:	e8 dc bf ff ff       	call   80101950 <iunlockput>
    end_op();
80105974:	e8 e7 d6 ff ff       	call   80103060 <end_op>
    return -1;
80105979:	83 c4 10             	add    $0x10,%esp
8010597c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105981:	eb 9a                	jmp    8010591d <sys_open+0xdd>
80105983:	90                   	nop
80105984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105988:	83 ec 0c             	sub    $0xc,%esp
8010598b:	57                   	push   %edi
8010598c:	e8 df b4 ff ff       	call   80100e70 <fileclose>
80105991:	83 c4 10             	add    $0x10,%esp
80105994:	eb d5                	jmp    8010596b <sys_open+0x12b>
80105996:	8d 76 00             	lea    0x0(%esi),%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059a6:	e8 45 d6 ff ff       	call   80102ff0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ae:	83 ec 08             	sub    $0x8,%esp
801059b1:	50                   	push   %eax
801059b2:	6a 00                	push   $0x0
801059b4:	e8 97 f6 ff ff       	call   80105050 <argstr>
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	85 c0                	test   %eax,%eax
801059be:	78 30                	js     801059f0 <sys_mkdir+0x50>
801059c0:	6a 00                	push   $0x0
801059c2:	6a 00                	push   $0x0
801059c4:	6a 01                	push   $0x1
801059c6:	ff 75 f4             	pushl  -0xc(%ebp)
801059c9:	e8 c2 fc ff ff       	call   80105690 <create>
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	85 c0                	test   %eax,%eax
801059d3:	74 1b                	je     801059f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059d5:	83 ec 0c             	sub    $0xc,%esp
801059d8:	50                   	push   %eax
801059d9:	e8 72 bf ff ff       	call   80101950 <iunlockput>
  end_op();
801059de:	e8 7d d6 ff ff       	call   80103060 <end_op>
  return 0;
801059e3:	83 c4 10             	add    $0x10,%esp
801059e6:	31 c0                	xor    %eax,%eax
}
801059e8:	c9                   	leave  
801059e9:	c3                   	ret    
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801059f0:	e8 6b d6 ff ff       	call   80103060 <end_op>
    return -1;
801059f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059fa:	c9                   	leave  
801059fb:	c3                   	ret    
801059fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_mknod>:

int
sys_mknod(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a06:	e8 e5 d5 ff ff       	call   80102ff0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a0e:	83 ec 08             	sub    $0x8,%esp
80105a11:	50                   	push   %eax
80105a12:	6a 00                	push   $0x0
80105a14:	e8 37 f6 ff ff       	call   80105050 <argstr>
80105a19:	83 c4 10             	add    $0x10,%esp
80105a1c:	85 c0                	test   %eax,%eax
80105a1e:	78 60                	js     80105a80 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a20:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a23:	83 ec 08             	sub    $0x8,%esp
80105a26:	50                   	push   %eax
80105a27:	6a 01                	push   $0x1
80105a29:	e8 72 f5 ff ff       	call   80104fa0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a2e:	83 c4 10             	add    $0x10,%esp
80105a31:	85 c0                	test   %eax,%eax
80105a33:	78 4b                	js     80105a80 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a35:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a38:	83 ec 08             	sub    $0x8,%esp
80105a3b:	50                   	push   %eax
80105a3c:	6a 02                	push   $0x2
80105a3e:	e8 5d f5 ff ff       	call   80104fa0 <argint>
     argint(1, &major) < 0 ||
80105a43:	83 c4 10             	add    $0x10,%esp
80105a46:	85 c0                	test   %eax,%eax
80105a48:	78 36                	js     80105a80 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a4a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a4e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a4f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a53:	50                   	push   %eax
80105a54:	6a 03                	push   $0x3
80105a56:	ff 75 ec             	pushl  -0x14(%ebp)
80105a59:	e8 32 fc ff ff       	call   80105690 <create>
80105a5e:	83 c4 10             	add    $0x10,%esp
80105a61:	85 c0                	test   %eax,%eax
80105a63:	74 1b                	je     80105a80 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a65:	83 ec 0c             	sub    $0xc,%esp
80105a68:	50                   	push   %eax
80105a69:	e8 e2 be ff ff       	call   80101950 <iunlockput>
  end_op();
80105a6e:	e8 ed d5 ff ff       	call   80103060 <end_op>
  return 0;
80105a73:	83 c4 10             	add    $0x10,%esp
80105a76:	31 c0                	xor    %eax,%eax
}
80105a78:	c9                   	leave  
80105a79:	c3                   	ret    
80105a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105a80:	e8 db d5 ff ff       	call   80103060 <end_op>
    return -1;
80105a85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a8a:	c9                   	leave  
80105a8b:	c3                   	ret    
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a90 <sys_chdir>:

int
sys_chdir(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	56                   	push   %esi
80105a94:	53                   	push   %ebx
80105a95:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a98:	e8 63 e2 ff ff       	call   80103d00 <myproc>
80105a9d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a9f:	e8 4c d5 ff ff       	call   80102ff0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aa7:	83 ec 08             	sub    $0x8,%esp
80105aaa:	50                   	push   %eax
80105aab:	6a 00                	push   $0x0
80105aad:	e8 9e f5 ff ff       	call   80105050 <argstr>
80105ab2:	83 c4 10             	add    $0x10,%esp
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	78 77                	js     80105b30 <sys_chdir+0xa0>
80105ab9:	83 ec 0c             	sub    $0xc,%esp
80105abc:	ff 75 f4             	pushl  -0xc(%ebp)
80105abf:	e8 5c c4 ff ff       	call   80101f20 <namei>
80105ac4:	83 c4 10             	add    $0x10,%esp
80105ac7:	85 c0                	test   %eax,%eax
80105ac9:	89 c3                	mov    %eax,%ebx
80105acb:	74 63                	je     80105b30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105acd:	83 ec 0c             	sub    $0xc,%esp
80105ad0:	50                   	push   %eax
80105ad1:	e8 ea bb ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105ad6:	83 c4 10             	add    $0x10,%esp
80105ad9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ade:	75 30                	jne    80105b10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	53                   	push   %ebx
80105ae4:	e8 b7 bc ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105ae9:	58                   	pop    %eax
80105aea:	ff 76 68             	pushl  0x68(%esi)
80105aed:	e8 fe bc ff ff       	call   801017f0 <iput>
  end_op();
80105af2:	e8 69 d5 ff ff       	call   80103060 <end_op>
  curproc->cwd = ip;
80105af7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	31 c0                	xor    %eax,%eax
}
80105aff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b02:	5b                   	pop    %ebx
80105b03:	5e                   	pop    %esi
80105b04:	5d                   	pop    %ebp
80105b05:	c3                   	ret    
80105b06:	8d 76 00             	lea    0x0(%esi),%esi
80105b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	53                   	push   %ebx
80105b14:	e8 37 be ff ff       	call   80101950 <iunlockput>
    end_op();
80105b19:	e8 42 d5 ff ff       	call   80103060 <end_op>
    return -1;
80105b1e:	83 c4 10             	add    $0x10,%esp
80105b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b26:	eb d7                	jmp    80105aff <sys_chdir+0x6f>
80105b28:	90                   	nop
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b30:	e8 2b d5 ff ff       	call   80103060 <end_op>
    return -1;
80105b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3a:	eb c3                	jmp    80105aff <sys_chdir+0x6f>
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <sys_exec>:

int
sys_exec(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
80105b45:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b46:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b4c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b52:	50                   	push   %eax
80105b53:	6a 00                	push   $0x0
80105b55:	e8 f6 f4 ff ff       	call   80105050 <argstr>
80105b5a:	83 c4 10             	add    $0x10,%esp
80105b5d:	85 c0                	test   %eax,%eax
80105b5f:	0f 88 87 00 00 00    	js     80105bec <sys_exec+0xac>
80105b65:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b6b:	83 ec 08             	sub    $0x8,%esp
80105b6e:	50                   	push   %eax
80105b6f:	6a 01                	push   $0x1
80105b71:	e8 2a f4 ff ff       	call   80104fa0 <argint>
80105b76:	83 c4 10             	add    $0x10,%esp
80105b79:	85 c0                	test   %eax,%eax
80105b7b:	78 6f                	js     80105bec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b7d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b83:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105b86:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105b88:	68 80 00 00 00       	push   $0x80
80105b8d:	6a 00                	push   $0x0
80105b8f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b95:	50                   	push   %eax
80105b96:	e8 05 f1 ff ff       	call   80104ca0 <memset>
80105b9b:	83 c4 10             	add    $0x10,%esp
80105b9e:	eb 2c                	jmp    80105bcc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105ba0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ba6:	85 c0                	test   %eax,%eax
80105ba8:	74 56                	je     80105c00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105baa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105bb0:	83 ec 08             	sub    $0x8,%esp
80105bb3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105bb6:	52                   	push   %edx
80105bb7:	50                   	push   %eax
80105bb8:	e8 73 f3 ff ff       	call   80104f30 <fetchstr>
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	85 c0                	test   %eax,%eax
80105bc2:	78 28                	js     80105bec <sys_exec+0xac>
  for(i=0;; i++){
80105bc4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105bc7:	83 fb 20             	cmp    $0x20,%ebx
80105bca:	74 20                	je     80105bec <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bcc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bd2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105bd9:	83 ec 08             	sub    $0x8,%esp
80105bdc:	57                   	push   %edi
80105bdd:	01 f0                	add    %esi,%eax
80105bdf:	50                   	push   %eax
80105be0:	e8 0b f3 ff ff       	call   80104ef0 <fetchint>
80105be5:	83 c4 10             	add    $0x10,%esp
80105be8:	85 c0                	test   %eax,%eax
80105bea:	79 b4                	jns    80105ba0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105bec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105bef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bf4:	5b                   	pop    %ebx
80105bf5:	5e                   	pop    %esi
80105bf6:	5f                   	pop    %edi
80105bf7:	5d                   	pop    %ebp
80105bf8:	c3                   	ret    
80105bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c00:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c06:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105c09:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c10:	00 00 00 00 
  return exec(path, argv);
80105c14:	50                   	push   %eax
80105c15:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c1b:	e8 f0 ad ff ff       	call   80100a10 <exec>
80105c20:	83 c4 10             	add    $0x10,%esp
}
80105c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c26:	5b                   	pop    %ebx
80105c27:	5e                   	pop    %esi
80105c28:	5f                   	pop    %edi
80105c29:	5d                   	pop    %ebp
80105c2a:	c3                   	ret    
80105c2b:	90                   	nop
80105c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c30 <sys_pipe>:

int
sys_pipe(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	57                   	push   %edi
80105c34:	56                   	push   %esi
80105c35:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c36:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c3c:	6a 08                	push   $0x8
80105c3e:	50                   	push   %eax
80105c3f:	6a 00                	push   $0x0
80105c41:	e8 aa f3 ff ff       	call   80104ff0 <argptr>
80105c46:	83 c4 10             	add    $0x10,%esp
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	0f 88 ae 00 00 00    	js     80105cff <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c51:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c54:	83 ec 08             	sub    $0x8,%esp
80105c57:	50                   	push   %eax
80105c58:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c5b:	50                   	push   %eax
80105c5c:	e8 2f da ff ff       	call   80103690 <pipealloc>
80105c61:	83 c4 10             	add    $0x10,%esp
80105c64:	85 c0                	test   %eax,%eax
80105c66:	0f 88 93 00 00 00    	js     80105cff <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c6c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c6f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c71:	e8 8a e0 ff ff       	call   80103d00 <myproc>
80105c76:	eb 10                	jmp    80105c88 <sys_pipe+0x58>
80105c78:	90                   	nop
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105c80:	83 c3 01             	add    $0x1,%ebx
80105c83:	83 fb 10             	cmp    $0x10,%ebx
80105c86:	74 60                	je     80105ce8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105c88:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c8c:	85 f6                	test   %esi,%esi
80105c8e:	75 f0                	jne    80105c80 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105c90:	8d 73 08             	lea    0x8(%ebx),%esi
80105c93:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105c9a:	e8 61 e0 ff ff       	call   80103d00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c9f:	31 d2                	xor    %edx,%edx
80105ca1:	eb 0d                	jmp    80105cb0 <sys_pipe+0x80>
80105ca3:	90                   	nop
80105ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ca8:	83 c2 01             	add    $0x1,%edx
80105cab:	83 fa 10             	cmp    $0x10,%edx
80105cae:	74 28                	je     80105cd8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105cb0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cb4:	85 c9                	test   %ecx,%ecx
80105cb6:	75 f0                	jne    80105ca8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105cb8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105cbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cbf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105cc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cc4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105cc7:	31 c0                	xor    %eax,%eax
}
80105cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ccc:	5b                   	pop    %ebx
80105ccd:	5e                   	pop    %esi
80105cce:	5f                   	pop    %edi
80105ccf:	5d                   	pop    %ebp
80105cd0:	c3                   	ret    
80105cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105cd8:	e8 23 e0 ff ff       	call   80103d00 <myproc>
80105cdd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ce4:	00 
80105ce5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105ce8:	83 ec 0c             	sub    $0xc,%esp
80105ceb:	ff 75 e0             	pushl  -0x20(%ebp)
80105cee:	e8 7d b1 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105cf3:	58                   	pop    %eax
80105cf4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cf7:	e8 74 b1 ff ff       	call   80100e70 <fileclose>
    return -1;
80105cfc:	83 c4 10             	add    $0x10,%esp
80105cff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d04:	eb c3                	jmp    80105cc9 <sys_pipe+0x99>
80105d06:	66 90                	xchg   %ax,%ax
80105d08:	66 90                	xchg   %ax,%ax
80105d0a:	66 90                	xchg   %ax,%ax
80105d0c:	66 90                	xchg   %ax,%ax
80105d0e:	66 90                	xchg   %ax,%ax

80105d10 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105d16:	e8 45 e7 ff ff       	call   80104460 <yield>
  return 0;
}
80105d1b:	31 c0                	xor    %eax,%eax
80105d1d:	c9                   	leave  
80105d1e:	c3                   	ret    
80105d1f:	90                   	nop

80105d20 <sys_fork>:

int
sys_fork(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105d23:	5d                   	pop    %ebp
  return fork();
80105d24:	e9 97 e1 ff ff       	jmp    80103ec0 <fork>
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d30 <sys_exit>:

int
sys_exit(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d36:	e8 d5 e5 ff ff       	call   80104310 <exit>
  return 0;  // not reached
}
80105d3b:	31 c0                	xor    %eax,%eax
80105d3d:	c9                   	leave  
80105d3e:	c3                   	ret    
80105d3f:	90                   	nop

80105d40 <sys_wait>:

int
sys_wait(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d43:	5d                   	pop    %ebp
  return wait();
80105d44:	e9 27 e8 ff ff       	jmp    80104570 <wait>
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_kill>:

int
sys_kill(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d59:	50                   	push   %eax
80105d5a:	6a 00                	push   $0x0
80105d5c:	e8 3f f2 ff ff       	call   80104fa0 <argint>
80105d61:	83 c4 10             	add    $0x10,%esp
80105d64:	85 c0                	test   %eax,%eax
80105d66:	78 18                	js     80105d80 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d68:	83 ec 0c             	sub    $0xc,%esp
80105d6b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d6e:	e8 0d ea ff ff       	call   80104780 <kill>
80105d73:	83 c4 10             	add    $0x10,%esp
}
80105d76:	c9                   	leave  
80105d77:	c3                   	ret    
80105d78:	90                   	nop
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d85:	c9                   	leave  
80105d86:	c3                   	ret    
80105d87:	89 f6                	mov    %esi,%esi
80105d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d90 <sys_getpid>:

int
sys_getpid(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d96:	e8 65 df ff ff       	call   80103d00 <myproc>
80105d9b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d9e:	c9                   	leave  
80105d9f:	c3                   	ret    

80105da0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105da4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105da7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105daa:	50                   	push   %eax
80105dab:	6a 00                	push   $0x0
80105dad:	e8 ee f1 ff ff       	call   80104fa0 <argint>
80105db2:	83 c4 10             	add    $0x10,%esp
80105db5:	85 c0                	test   %eax,%eax
80105db7:	78 27                	js     80105de0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105db9:	e8 42 df ff ff       	call   80103d00 <myproc>
  if(growproc(n) < 0)
80105dbe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105dc1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105dc3:	ff 75 f4             	pushl  -0xc(%ebp)
80105dc6:	e8 65 e0 ff ff       	call   80103e30 <growproc>
80105dcb:	83 c4 10             	add    $0x10,%esp
80105dce:	85 c0                	test   %eax,%eax
80105dd0:	78 0e                	js     80105de0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105dd2:	89 d8                	mov    %ebx,%eax
80105dd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dd7:	c9                   	leave  
80105dd8:	c3                   	ret    
80105dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105de0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105de5:	eb eb                	jmp    80105dd2 <sys_sbrk+0x32>
80105de7:	89 f6                	mov    %esi,%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105df0 <sys_sleep>:

int
sys_sleep(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105df7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dfa:	50                   	push   %eax
80105dfb:	6a 00                	push   $0x0
80105dfd:	e8 9e f1 ff ff       	call   80104fa0 <argint>
80105e02:	83 c4 10             	add    $0x10,%esp
80105e05:	85 c0                	test   %eax,%eax
80105e07:	0f 88 8a 00 00 00    	js     80105e97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e0d:	83 ec 0c             	sub    $0xc,%esp
80105e10:	68 a0 64 12 80       	push   $0x801264a0
80105e15:	e8 06 ed ff ff       	call   80104b20 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e1d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e20:	8b 1d e0 6c 12 80    	mov    0x80126ce0,%ebx
  while(ticks - ticks0 < n){
80105e26:	85 d2                	test   %edx,%edx
80105e28:	75 27                	jne    80105e51 <sys_sleep+0x61>
80105e2a:	eb 54                	jmp    80105e80 <sys_sleep+0x90>
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e30:	83 ec 08             	sub    $0x8,%esp
80105e33:	68 a0 64 12 80       	push   $0x801264a0
80105e38:	68 e0 6c 12 80       	push   $0x80126ce0
80105e3d:	e8 6e e6 ff ff       	call   801044b0 <sleep>
  while(ticks - ticks0 < n){
80105e42:	a1 e0 6c 12 80       	mov    0x80126ce0,%eax
80105e47:	83 c4 10             	add    $0x10,%esp
80105e4a:	29 d8                	sub    %ebx,%eax
80105e4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e4f:	73 2f                	jae    80105e80 <sys_sleep+0x90>
    if(myproc()->killed){
80105e51:	e8 aa de ff ff       	call   80103d00 <myproc>
80105e56:	8b 40 24             	mov    0x24(%eax),%eax
80105e59:	85 c0                	test   %eax,%eax
80105e5b:	74 d3                	je     80105e30 <sys_sleep+0x40>
      release(&tickslock);
80105e5d:	83 ec 0c             	sub    $0xc,%esp
80105e60:	68 a0 64 12 80       	push   $0x801264a0
80105e65:	e8 d6 ed ff ff       	call   80104c40 <release>
      return -1;
80105e6a:	83 c4 10             	add    $0x10,%esp
80105e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105e72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e75:	c9                   	leave  
80105e76:	c3                   	ret    
80105e77:	89 f6                	mov    %esi,%esi
80105e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	68 a0 64 12 80       	push   $0x801264a0
80105e88:	e8 b3 ed ff ff       	call   80104c40 <release>
  return 0;
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	31 c0                	xor    %eax,%eax
}
80105e92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
    return -1;
80105e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9c:	eb f4                	jmp    80105e92 <sys_sleep+0xa2>
80105e9e:	66 90                	xchg   %ax,%ax

80105ea0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	53                   	push   %ebx
80105ea4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ea7:	68 a0 64 12 80       	push   $0x801264a0
80105eac:	e8 6f ec ff ff       	call   80104b20 <acquire>
  xticks = ticks;
80105eb1:	8b 1d e0 6c 12 80    	mov    0x80126ce0,%ebx
  release(&tickslock);
80105eb7:	c7 04 24 a0 64 12 80 	movl   $0x801264a0,(%esp)
80105ebe:	e8 7d ed ff ff       	call   80104c40 <release>
  return xticks;
}
80105ec3:	89 d8                	mov    %ebx,%eax
80105ec5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ec8:	c9                   	leave  
80105ec9:	c3                   	ret    

80105eca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105eca:	1e                   	push   %ds
  pushl %es
80105ecb:	06                   	push   %es
  pushl %fs
80105ecc:	0f a0                	push   %fs
  pushl %gs
80105ece:	0f a8                	push   %gs
  pushal
80105ed0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ed1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ed5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ed7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ed9:	54                   	push   %esp
  call trap
80105eda:	e8 c1 00 00 00       	call   80105fa0 <trap>
  addl $4, %esp
80105edf:	83 c4 04             	add    $0x4,%esp

80105ee2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ee2:	61                   	popa   
  popl %gs
80105ee3:	0f a9                	pop    %gs
  popl %fs
80105ee5:	0f a1                	pop    %fs
  popl %es
80105ee7:	07                   	pop    %es
  popl %ds
80105ee8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ee9:	83 c4 08             	add    $0x8,%esp
  iret
80105eec:	cf                   	iret   
80105eed:	66 90                	xchg   %ax,%ax
80105eef:	90                   	nop

80105ef0 <tvinit>:
struct spinlock tickslock;
uint ticks, virtualAddr, problematicPage;
struct proc *p;

void
tvinit(void) {
80105ef0:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105ef1:	31 c0                	xor    %eax,%eax
tvinit(void) {
80105ef3:	89 e5                	mov    %esp,%ebp
80105ef5:	83 ec 08             	sub    $0x8,%esp
80105ef8:	90                   	nop
80105ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105f00:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105f07:	c7 04 c5 e2 64 12 80 	movl   $0x8e000008,-0x7fed9b1e(,%eax,8)
80105f0e:	08 00 00 8e 
80105f12:	66 89 14 c5 e0 64 12 	mov    %dx,-0x7fed9b20(,%eax,8)
80105f19:	80 
80105f1a:	c1 ea 10             	shr    $0x10,%edx
80105f1d:	66 89 14 c5 e6 64 12 	mov    %dx,-0x7fed9b1a(,%eax,8)
80105f24:	80 
80105f25:	83 c0 01             	add    $0x1,%eax
80105f28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f2d:	75 d1                	jne    80105f00 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105f2f:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

    initlock(&tickslock, "time");
80105f34:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105f37:	c7 05 e2 66 12 80 08 	movl   $0xef000008,0x801266e2
80105f3e:	00 00 ef 
    initlock(&tickslock, "time");
80105f41:	68 39 85 10 80       	push   $0x80108539
80105f46:	68 a0 64 12 80       	push   $0x801264a0
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105f4b:	66 a3 e0 66 12 80    	mov    %ax,0x801266e0
80105f51:	c1 e8 10             	shr    $0x10,%eax
80105f54:	66 a3 e6 66 12 80    	mov    %ax,0x801266e6
    initlock(&tickslock, "time");
80105f5a:	e8 d1 ea ff ff       	call   80104a30 <initlock>
}
80105f5f:	83 c4 10             	add    $0x10,%esp
80105f62:	c9                   	leave  
80105f63:	c3                   	ret    
80105f64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f70 <idtinit>:

void
idtinit(void) {
80105f70:	55                   	push   %ebp
  pd[0] = size-1;
80105f71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f76:	89 e5                	mov    %esp,%ebp
80105f78:	83 ec 10             	sub    $0x10,%esp
80105f7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f7f:	b8 e0 64 12 80       	mov    $0x801264e0,%eax
80105f84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f88:	c1 e8 10             	shr    $0x10,%eax
80105f8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f92:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80105f95:	c9                   	leave  
80105f96:	c3                   	ret    
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fa0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	57                   	push   %edi
80105fa4:	56                   	push   %esi
80105fa5:	53                   	push   %ebx
80105fa6:	83 ec 1c             	sub    $0x1c,%esp
80105fa9:	8b 75 08             	mov    0x8(%ebp),%esi
    if (tf->trapno == T_SYSCALL) {
80105fac:	8b 46 30             	mov    0x30(%esi),%eax
80105faf:	83 f8 40             	cmp    $0x40,%eax
80105fb2:	0f 84 00 02 00 00    	je     801061b8 <trap+0x218>
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
80105fb8:	83 e8 0e             	sub    $0xe,%eax
80105fbb:	83 f8 31             	cmp    $0x31,%eax
80105fbe:	0f 87 dc 02 00 00    	ja     801062a0 <trap+0x300>
80105fc4:	ff 24 85 a8 86 10 80 	jmp    *-0x7fef7958(,%eax,4)
80105fcb:	90                   	nop
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            lapiceoi();
            break;

            //CASE TRAP 14 PGFLT IF IN SWITCH FILE: BRING FROM THERE, ELSE GO DEFAULT
        case T_PGFLT:
            p = myproc();
80105fd0:	e8 2b dd ff ff       	call   80103d00 <myproc>
80105fd5:	a3 80 64 12 80       	mov    %eax,0x80126480

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105fda:	0f 20 d2             	mov    %cr2,%edx
            pte_t *currPTE;

            virtualAddr = rcr2();
            problematicPage = PGROUNDDOWN(virtualAddr);
            //first we need to check if page is in swap
            for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++)
80105fdd:	31 ff                	xor    %edi,%edi
            virtualAddr = rcr2();
80105fdf:	89 15 e4 6c 12 80    	mov    %edx,0x80126ce4
            problematicPage = PGROUNDDOWN(virtualAddr);
80105fe5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
            for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++)
80105feb:	39 90 98 00 00 00    	cmp    %edx,0x98(%eax)
            problematicPage = PGROUNDDOWN(virtualAddr);
80105ff1:	89 15 84 64 12 80    	mov    %edx,0x80126484
            for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++)
80105ff7:	8d 98 80 00 00 00    	lea    0x80(%eax),%ebx
80105ffd:	8d 88 00 04 00 00    	lea    0x400(%eax),%ecx
80106003:	75 10                	jne    80106015 <trap+0x75>
80106005:	eb 1e                	jmp    80106025 <trap+0x85>
80106007:	89 f6                	mov    %esi,%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106010:	39 53 18             	cmp    %edx,0x18(%ebx)
80106013:	74 10                	je     80106025 <trap+0x85>
80106015:	83 c3 1c             	add    $0x1c,%ebx
80106018:	83 c7 01             	add    $0x1,%edi
8010601b:	39 cb                	cmp    %ecx,%ebx
8010601d:	72 f1                	jb     80106010 <trap+0x70>
                ;
            if (cg == &p->pages[MAX_TOTAL_PAGES]) { //if true -didn't find the addr -error
8010601f:	0f 84 c0 03 00 00    	je     801063e5 <trap+0x445>
                panic("Error- didn't find the trap's page in T_PGFLT\n");
            }

            //must update page faults for proc.
            p->pageFaults++;
80106025:	83 80 54 04 00 00 01 	addl   $0x1,0x454(%eax)

            //Got here - cg is the page that is in swapFile; i is its location in array
            //Now- check if all 16 pages are in RAM

            //TODO = check if page is in secondary memory
            if (!cg->active || cg->present) {
8010602c:	8b 0b                	mov    (%ebx),%ecx
8010602e:	85 c9                	test   %ecx,%ecx
80106030:	0f 84 e2 02 00 00    	je     80106318 <trap+0x378>
80106036:	8b 53 0c             	mov    0xc(%ebx),%edx
80106039:	85 d2                	test   %edx,%edx
8010603b:	0f 85 ff 02 00 00    	jne    80106340 <trap+0x3a0>
                if(cg->present)
                    panic("Error - problematic page is present!\n");
                panic("Error - problematic page is not active!\n");
            }

            if ((p->pagesCounter - p->pagesinSwap) >= 16) {
80106041:	8b 90 44 04 00 00    	mov    0x444(%eax),%edx
80106047:	2b 90 48 04 00 00    	sub    0x448(%eax),%edx
8010604d:	83 fa 0f             	cmp    $0xf,%edx
80106050:	0f 8f 2e 03 00 00    	jg     80106384 <trap+0x3e4>
                swapOutPage(p, p->pgdir); //func in vm.c - same use in allocuvm
            }

            //got here - there is a room for a new page

            if ((newAddr = kalloc()) == 0) {
80106056:	e8 b5 c8 ff ff       	call   80102910 <kalloc>
8010605b:	85 c0                	test   %eax,%eax
8010605d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106060:	0f 84 32 03 00 00    	je     80106398 <trap+0x3f8>
                cprintf("Error- kalloc in T_PGFLT\n");
                break;
            }

            memset(newAddr, 0, PGSIZE); //clean the page
80106066:	83 ec 04             	sub    $0x4,%esp
80106069:	68 00 10 00 00       	push   $0x1000
8010606e:	6a 00                	push   $0x0
80106070:	ff 75 e4             	pushl  -0x1c(%ebp)
80106073:	e8 28 ec ff ff       	call   80104ca0 <memset>

            //bring page from swapFile
            if (readFromSwapFile(p, newAddr, cg->offset, PGSIZE) == -1)
80106078:	68 00 10 00 00       	push   $0x1000
8010607d:	ff 73 10             	pushl  0x10(%ebx)
80106080:	ff 75 e4             	pushl  -0x1c(%ebp)
80106083:	ff 35 80 64 12 80    	pushl  0x80126480
80106089:	e8 32 c2 ff ff       	call   801022c0 <readFromSwapFile>
8010608e:	83 c4 20             	add    $0x20,%esp
80106091:	83 f8 ff             	cmp    $0xffffffff,%eax
80106094:	0f 84 3e 03 00 00    	je     801063d8 <trap+0x438>
                panic("error - read from swapfile in T_PGFLT");

            currPTE = walkpgdir2(p->pgdir, (void *) virtualAddr, 0);
8010609a:	a1 80 64 12 80       	mov    0x80126480,%eax
8010609f:	83 ec 04             	sub    $0x4,%esp
801060a2:	6a 00                	push   $0x0
801060a4:	ff 35 e4 6c 12 80    	pushl  0x80126ce4
801060aa:	ff 70 04             	pushl  0x4(%eax)
801060ad:	e8 ee 10 00 00       	call   801071a0 <walkpgdir2>
801060b2:	89 c2                	mov    %eax,%edx
            //update flags - in page, not yet in RAM
            *currPTE = PTE_P_0(*currPTE);
801060b4:	8b 00                	mov    (%eax),%eax
            *currPTE = PTE_PG_1(*currPTE);
801060b6:	89 55 dc             	mov    %edx,-0x24(%ebp)
            *currPTE = PTE_P_0(*currPTE);
801060b9:	83 e0 fe             	and    $0xfffffffe,%eax
            *currPTE = PTE_PG_1(*currPTE);
801060bc:	80 cc 02             	or     $0x2,%ah
801060bf:	89 02                	mov    %eax,(%edx)

            mappages2(p->pgdir, (void *) problematicPage, PGSIZE, V2P(newAddr), PTE_U | PTE_W);
801060c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060c4:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801060cb:	05 00 00 00 80       	add    $0x80000000,%eax
801060d0:	50                   	push   %eax
801060d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060d4:	a1 80 64 12 80       	mov    0x80126480,%eax
801060d9:	68 00 10 00 00       	push   $0x1000
801060de:	ff 35 84 64 12 80    	pushl  0x80126484
801060e4:	ff 70 04             	pushl  0x4(%eax)
801060e7:	e8 d4 10 00 00       	call   801071c0 <mappages2>
            //update flags - if got here the page is in RAM!
            *currPTE = PTE_P_1(*currPTE);
            *currPTE = PTE_PG_0(*currPTE);
801060ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
            //update proc
            p->swapFileEntries[i] = 0; //clean entry- page is in RAM
//            p->pagesCounter++;
            p->pagesinSwap--;

            lapiceoi();
801060ef:	83 c4 20             	add    $0x20,%esp
            *currPTE = PTE_PG_0(*currPTE);
801060f2:	8b 0a                	mov    (%edx),%ecx
801060f4:	80 e5 fd             	and    $0xfd,%ch
801060f7:	89 c8                	mov    %ecx,%eax
801060f9:	83 c8 01             	or     $0x1,%eax
801060fc:	89 02                	mov    %eax,(%edx)
            cg->active = 1;
801060fe:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
            cg->virtAdress = newAddr;
80106104:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            cg->sequel = p->pagesequel++;
80106107:	a1 80 64 12 80       	mov    0x80126480,%eax
            cg->offset = 0;
8010610c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
            cg->present = 1;
80106113:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
            cg->virtAdress = newAddr;
8010611a:	89 53 18             	mov    %edx,0x18(%ebx)
            cg->sequel = p->pagesequel++;
8010611d:	8b 90 4c 04 00 00    	mov    0x44c(%eax),%edx
80106123:	8d 4a 01             	lea    0x1(%edx),%ecx
80106126:	89 88 4c 04 00 00    	mov    %ecx,0x44c(%eax)
            cg->physAdress = (char *) V2P(newAddr);
8010612c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
            cg->sequel = p->pagesequel++;
8010612f:	89 53 08             	mov    %edx,0x8(%ebx)
            cg->physAdress = (char *) V2P(newAddr);
80106132:	89 4b 14             	mov    %ecx,0x14(%ebx)
            p->swapFileEntries[i] = 0; //clean entry- page is in RAM
80106135:	c7 84 b8 00 04 00 00 	movl   $0x0,0x400(%eax,%edi,4)
8010613c:	00 00 00 00 
            p->pagesinSwap--;
80106140:	83 a8 48 04 00 00 01 	subl   $0x1,0x448(%eax)
            lapiceoi();
80106147:	e8 54 ca ff ff       	call   80102ba0 <lapiceoi>
8010614c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106150:	e8 ab db ff ff       	call   80103d00 <myproc>
80106155:	85 c0                	test   %eax,%eax
80106157:	74 1d                	je     80106176 <trap+0x1d6>
80106159:	e8 a2 db ff ff       	call   80103d00 <myproc>
8010615e:	8b 50 24             	mov    0x24(%eax),%edx
80106161:	85 d2                	test   %edx,%edx
80106163:	74 11                	je     80106176 <trap+0x1d6>
80106165:	0f b7 46 3c          	movzwl 0x3c(%esi),%eax
80106169:	83 e0 03             	and    $0x3,%eax
8010616c:	66 83 f8 03          	cmp    $0x3,%ax
80106170:	0f 84 ba 01 00 00    	je     80106330 <trap+0x390>
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80106176:	e8 85 db ff ff       	call   80103d00 <myproc>
8010617b:	85 c0                	test   %eax,%eax
8010617d:	74 0b                	je     8010618a <trap+0x1ea>
8010617f:	e8 7c db ff ff       	call   80103d00 <myproc>
80106184:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106188:	74 66                	je     801061f0 <trap+0x250>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
8010618a:	e8 71 db ff ff       	call   80103d00 <myproc>
8010618f:	85 c0                	test   %eax,%eax
80106191:	74 19                	je     801061ac <trap+0x20c>
80106193:	e8 68 db ff ff       	call   80103d00 <myproc>
80106198:	8b 40 24             	mov    0x24(%eax),%eax
8010619b:	85 c0                	test   %eax,%eax
8010619d:	74 0d                	je     801061ac <trap+0x20c>
8010619f:	0f b7 46 3c          	movzwl 0x3c(%esi),%eax
801061a3:	83 e0 03             	and    $0x3,%eax
801061a6:	66 83 f8 03          	cmp    $0x3,%ax
801061aa:	74 35                	je     801061e1 <trap+0x241>
        exit();
}
801061ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061af:	5b                   	pop    %ebx
801061b0:	5e                   	pop    %esi
801061b1:	5f                   	pop    %edi
801061b2:	5d                   	pop    %ebp
801061b3:	c3                   	ret    
801061b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed)
801061b8:	e8 43 db ff ff       	call   80103d00 <myproc>
801061bd:	8b 78 24             	mov    0x24(%eax),%edi
801061c0:	85 ff                	test   %edi,%edi
801061c2:	0f 85 c8 00 00 00    	jne    80106290 <trap+0x2f0>
        myproc()->tf = tf;
801061c8:	e8 33 db ff ff       	call   80103d00 <myproc>
801061cd:	89 70 18             	mov    %esi,0x18(%eax)
        syscall();
801061d0:	e8 bb ee ff ff       	call   80105090 <syscall>
        if (myproc()->killed)
801061d5:	e8 26 db ff ff       	call   80103d00 <myproc>
801061da:	8b 58 24             	mov    0x24(%eax),%ebx
801061dd:	85 db                	test   %ebx,%ebx
801061df:	74 cb                	je     801061ac <trap+0x20c>
}
801061e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061e4:	5b                   	pop    %ebx
801061e5:	5e                   	pop    %esi
801061e6:	5f                   	pop    %edi
801061e7:	5d                   	pop    %ebp
            exit();
801061e8:	e9 23 e1 ff ff       	jmp    80104310 <exit>
801061ed:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
801061f0:	83 7e 30 20          	cmpl   $0x20,0x30(%esi)
801061f4:	75 94                	jne    8010618a <trap+0x1ea>
        yield();
801061f6:	e8 65 e2 ff ff       	call   80104460 <yield>
801061fb:	eb 8d                	jmp    8010618a <trap+0x1ea>
801061fd:	8d 76 00             	lea    0x0(%esi),%esi
            if (cpuid() == 0) {
80106200:	e8 db da ff ff       	call   80103ce0 <cpuid>
80106205:	85 c0                	test   %eax,%eax
80106207:	0f 84 43 01 00 00    	je     80106350 <trap+0x3b0>
            lapiceoi();
8010620d:	e8 8e c9 ff ff       	call   80102ba0 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106212:	e8 e9 da ff ff       	call   80103d00 <myproc>
80106217:	85 c0                	test   %eax,%eax
80106219:	0f 85 3a ff ff ff    	jne    80106159 <trap+0x1b9>
8010621f:	e9 52 ff ff ff       	jmp    80106176 <trap+0x1d6>
80106224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80106228:	e8 33 c8 ff ff       	call   80102a60 <kbdintr>
            lapiceoi();
8010622d:	e8 6e c9 ff ff       	call   80102ba0 <lapiceoi>
            break;
80106232:	e9 19 ff ff ff       	jmp    80106150 <trap+0x1b0>
80106237:	89 f6                	mov    %esi,%esi
80106239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            uartintr();
80106240:	e8 2b 03 00 00       	call   80106570 <uartintr>
            lapiceoi();
80106245:	e8 56 c9 ff ff       	call   80102ba0 <lapiceoi>
            break;
8010624a:	e9 01 ff ff ff       	jmp    80106150 <trap+0x1b0>
8010624f:	90                   	nop
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106250:	0f b7 5e 3c          	movzwl 0x3c(%esi),%ebx
80106254:	8b 7e 38             	mov    0x38(%esi),%edi
80106257:	e8 84 da ff ff       	call   80103ce0 <cpuid>
8010625c:	57                   	push   %edi
8010625d:	53                   	push   %ebx
8010625e:	50                   	push   %eax
8010625f:	68 60 85 10 80       	push   $0x80108560
80106264:	e8 f7 a3 ff ff       	call   80100660 <cprintf>
            lapiceoi();
80106269:	e8 32 c9 ff ff       	call   80102ba0 <lapiceoi>
            break;
8010626e:	83 c4 10             	add    $0x10,%esp
80106271:	e9 da fe ff ff       	jmp    80106150 <trap+0x1b0>
80106276:	8d 76 00             	lea    0x0(%esi),%esi
80106279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            ideintr();
80106280:	e8 cb c1 ff ff       	call   80102450 <ideintr>
80106285:	eb 86                	jmp    8010620d <trap+0x26d>
80106287:	89 f6                	mov    %esi,%esi
80106289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            exit();
80106290:	e8 7b e0 ff ff       	call   80104310 <exit>
80106295:	e9 2e ff ff ff       	jmp    801061c8 <trap+0x228>
8010629a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (myproc() == 0 || (tf->cs & 3) == 0) {
801062a0:	e8 5b da ff ff       	call   80103d00 <myproc>
801062a5:	85 c0                	test   %eax,%eax
801062a7:	0f 84 00 01 00 00    	je     801063ad <trap+0x40d>
801062ad:	f6 46 3c 03          	testb  $0x3,0x3c(%esi)
801062b1:	0f 84 f6 00 00 00    	je     801063ad <trap+0x40d>
801062b7:	0f 20 d1             	mov    %cr2,%ecx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801062ba:	8b 56 38             	mov    0x38(%esi),%edx
801062bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801062c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801062c3:	e8 18 da ff ff       	call   80103ce0 <cpuid>
801062c8:	89 c7                	mov    %eax,%edi
801062ca:	8b 46 34             	mov    0x34(%esi),%eax
801062cd:	8b 5e 30             	mov    0x30(%esi),%ebx
801062d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    myproc()->pid, myproc()->name, tf->trapno,
801062d3:	e8 28 da ff ff       	call   80103d00 <myproc>
801062d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062db:	e8 20 da ff ff       	call   80103d00 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801062e0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801062e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801062e6:	51                   	push   %ecx
801062e7:	52                   	push   %edx
                    myproc()->pid, myproc()->name, tf->trapno,
801062e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801062eb:	57                   	push   %edi
801062ec:	ff 75 e4             	pushl  -0x1c(%ebp)
801062ef:	53                   	push   %ebx
                    myproc()->pid, myproc()->name, tf->trapno,
801062f0:	83 c2 6c             	add    $0x6c,%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801062f3:	52                   	push   %edx
801062f4:	ff 70 10             	pushl  0x10(%eax)
801062f7:	68 64 86 10 80       	push   $0x80108664
801062fc:	e8 5f a3 ff ff       	call   80100660 <cprintf>
            myproc()->killed = 1;
80106301:	83 c4 20             	add    $0x20,%esp
80106304:	e8 f7 d9 ff ff       	call   80103d00 <myproc>
80106309:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106310:	e9 3b fe ff ff       	jmp    80106150 <trap+0x1b0>
80106315:	8d 76 00             	lea    0x0(%esi),%esi
                if(cg->present)
80106318:	8b 4b 0c             	mov    0xc(%ebx),%ecx
8010631b:	85 c9                	test   %ecx,%ecx
8010631d:	75 21                	jne    80106340 <trap+0x3a0>
                panic("Error - problematic page is not active!\n");
8010631f:	83 ec 0c             	sub    $0xc,%esp
80106322:	68 dc 85 10 80       	push   $0x801085dc
80106327:	e8 64 a0 ff ff       	call   80100390 <panic>
8010632c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        exit();
80106330:	e8 db df ff ff       	call   80104310 <exit>
80106335:	e9 3c fe ff ff       	jmp    80106176 <trap+0x1d6>
8010633a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    panic("Error - problematic page is present!\n");
80106340:	83 ec 0c             	sub    $0xc,%esp
80106343:	68 b4 85 10 80       	push   $0x801085b4
80106348:	e8 43 a0 ff ff       	call   80100390 <panic>
8010634d:	8d 76 00             	lea    0x0(%esi),%esi
                acquire(&tickslock);
80106350:	83 ec 0c             	sub    $0xc,%esp
80106353:	68 a0 64 12 80       	push   $0x801264a0
80106358:	e8 c3 e7 ff ff       	call   80104b20 <acquire>
                wakeup(&ticks);
8010635d:	c7 04 24 e0 6c 12 80 	movl   $0x80126ce0,(%esp)
                ticks++;
80106364:	83 05 e0 6c 12 80 01 	addl   $0x1,0x80126ce0
                wakeup(&ticks);
8010636b:	e8 b0 e3 ff ff       	call   80104720 <wakeup>
                release(&tickslock);
80106370:	c7 04 24 a0 64 12 80 	movl   $0x801264a0,(%esp)
80106377:	e8 c4 e8 ff ff       	call   80104c40 <release>
8010637c:	83 c4 10             	add    $0x10,%esp
8010637f:	e9 89 fe ff ff       	jmp    8010620d <trap+0x26d>
                swapOutPage(p, p->pgdir); //func in vm.c - same use in allocuvm
80106384:	83 ec 08             	sub    $0x8,%esp
80106387:	ff 70 04             	pushl  0x4(%eax)
8010638a:	50                   	push   %eax
8010638b:	e8 f0 10 00 00       	call   80107480 <swapOutPage>
80106390:	83 c4 10             	add    $0x10,%esp
80106393:	e9 be fc ff ff       	jmp    80106056 <trap+0xb6>
                cprintf("Error- kalloc in T_PGFLT\n");
80106398:	83 ec 0c             	sub    $0xc,%esp
8010639b:	68 3e 85 10 80       	push   $0x8010853e
801063a0:	e8 bb a2 ff ff       	call   80100660 <cprintf>
                break;
801063a5:	83 c4 10             	add    $0x10,%esp
801063a8:	e9 a3 fd ff ff       	jmp    80106150 <trap+0x1b0>
801063ad:	0f 20 d7             	mov    %cr2,%edi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801063b0:	8b 5e 38             	mov    0x38(%esi),%ebx
801063b3:	e8 28 d9 ff ff       	call   80103ce0 <cpuid>
801063b8:	83 ec 0c             	sub    $0xc,%esp
801063bb:	57                   	push   %edi
801063bc:	53                   	push   %ebx
801063bd:	50                   	push   %eax
801063be:	ff 76 30             	pushl  0x30(%esi)
801063c1:	68 30 86 10 80       	push   $0x80108630
801063c6:	e8 95 a2 ff ff       	call   80100660 <cprintf>
                panic("trap");
801063cb:	83 c4 14             	add    $0x14,%esp
801063ce:	68 58 85 10 80       	push   $0x80108558
801063d3:	e8 b8 9f ff ff       	call   80100390 <panic>
                panic("error - read from swapfile in T_PGFLT");
801063d8:	83 ec 0c             	sub    $0xc,%esp
801063db:	68 08 86 10 80       	push   $0x80108608
801063e0:	e8 ab 9f ff ff       	call   80100390 <panic>
                panic("Error- didn't find the trap's page in T_PGFLT\n");
801063e5:	83 ec 0c             	sub    $0xc,%esp
801063e8:	68 84 85 10 80       	push   $0x80108584
801063ed:	e8 9e 9f ff ff       	call   80100390 <panic>
801063f2:	66 90                	xchg   %ax,%ax
801063f4:	66 90                	xchg   %ax,%ax
801063f6:	66 90                	xchg   %ax,%ax
801063f8:	66 90                	xchg   %ax,%ax
801063fa:	66 90                	xchg   %ax,%ax
801063fc:	66 90                	xchg   %ax,%ax
801063fe:	66 90                	xchg   %ax,%ax

80106400 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106400:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
{
80106405:	55                   	push   %ebp
80106406:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106408:	85 c0                	test   %eax,%eax
8010640a:	74 1c                	je     80106428 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010640c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106411:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106412:	a8 01                	test   $0x1,%al
80106414:	74 12                	je     80106428 <uartgetc+0x28>
80106416:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010641b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010641c:	0f b6 c0             	movzbl %al,%eax
}
8010641f:	5d                   	pop    %ebp
80106420:	c3                   	ret    
80106421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010642d:	5d                   	pop    %ebp
8010642e:	c3                   	ret    
8010642f:	90                   	nop

80106430 <uartputc.part.0>:
uartputc(int c)
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	57                   	push   %edi
80106434:	56                   	push   %esi
80106435:	53                   	push   %ebx
80106436:	89 c7                	mov    %eax,%edi
80106438:	bb 80 00 00 00       	mov    $0x80,%ebx
8010643d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106442:	83 ec 0c             	sub    $0xc,%esp
80106445:	eb 1b                	jmp    80106462 <uartputc.part.0+0x32>
80106447:	89 f6                	mov    %esi,%esi
80106449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106450:	83 ec 0c             	sub    $0xc,%esp
80106453:	6a 0a                	push   $0xa
80106455:	e8 66 c7 ff ff       	call   80102bc0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010645a:	83 c4 10             	add    $0x10,%esp
8010645d:	83 eb 01             	sub    $0x1,%ebx
80106460:	74 07                	je     80106469 <uartputc.part.0+0x39>
80106462:	89 f2                	mov    %esi,%edx
80106464:	ec                   	in     (%dx),%al
80106465:	a8 20                	test   $0x20,%al
80106467:	74 e7                	je     80106450 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106469:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010646e:	89 f8                	mov    %edi,%eax
80106470:	ee                   	out    %al,(%dx)
}
80106471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106474:	5b                   	pop    %ebx
80106475:	5e                   	pop    %esi
80106476:	5f                   	pop    %edi
80106477:	5d                   	pop    %ebp
80106478:	c3                   	ret    
80106479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106480 <uartinit>:
{
80106480:	55                   	push   %ebp
80106481:	31 c9                	xor    %ecx,%ecx
80106483:	89 c8                	mov    %ecx,%eax
80106485:	89 e5                	mov    %esp,%ebp
80106487:	57                   	push   %edi
80106488:	56                   	push   %esi
80106489:	53                   	push   %ebx
8010648a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010648f:	89 da                	mov    %ebx,%edx
80106491:	83 ec 0c             	sub    $0xc,%esp
80106494:	ee                   	out    %al,(%dx)
80106495:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010649a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010649f:	89 fa                	mov    %edi,%edx
801064a1:	ee                   	out    %al,(%dx)
801064a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801064a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ac:	ee                   	out    %al,(%dx)
801064ad:	be f9 03 00 00       	mov    $0x3f9,%esi
801064b2:	89 c8                	mov    %ecx,%eax
801064b4:	89 f2                	mov    %esi,%edx
801064b6:	ee                   	out    %al,(%dx)
801064b7:	b8 03 00 00 00       	mov    $0x3,%eax
801064bc:	89 fa                	mov    %edi,%edx
801064be:	ee                   	out    %al,(%dx)
801064bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064c4:	89 c8                	mov    %ecx,%eax
801064c6:	ee                   	out    %al,(%dx)
801064c7:	b8 01 00 00 00       	mov    $0x1,%eax
801064cc:	89 f2                	mov    %esi,%edx
801064ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064d4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801064d5:	3c ff                	cmp    $0xff,%al
801064d7:	74 5a                	je     80106533 <uartinit+0xb3>
  uart = 1;
801064d9:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801064e0:	00 00 00 
801064e3:	89 da                	mov    %ebx,%edx
801064e5:	ec                   	in     (%dx),%al
801064e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064eb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801064ec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801064ef:	bb 70 87 10 80       	mov    $0x80108770,%ebx
  ioapicenable(IRQ_COM1, 0);
801064f4:	6a 00                	push   $0x0
801064f6:	6a 04                	push   $0x4
801064f8:	e8 a3 c1 ff ff       	call   801026a0 <ioapicenable>
801064fd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106500:	b8 78 00 00 00       	mov    $0x78,%eax
80106505:	eb 13                	jmp    8010651a <uartinit+0x9a>
80106507:	89 f6                	mov    %esi,%esi
80106509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106510:	83 c3 01             	add    $0x1,%ebx
80106513:	0f be 03             	movsbl (%ebx),%eax
80106516:	84 c0                	test   %al,%al
80106518:	74 19                	je     80106533 <uartinit+0xb3>
  if(!uart)
8010651a:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80106520:	85 d2                	test   %edx,%edx
80106522:	74 ec                	je     80106510 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106524:	83 c3 01             	add    $0x1,%ebx
80106527:	e8 04 ff ff ff       	call   80106430 <uartputc.part.0>
8010652c:	0f be 03             	movsbl (%ebx),%eax
8010652f:	84 c0                	test   %al,%al
80106531:	75 e7                	jne    8010651a <uartinit+0x9a>
}
80106533:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106536:	5b                   	pop    %ebx
80106537:	5e                   	pop    %esi
80106538:	5f                   	pop    %edi
80106539:	5d                   	pop    %ebp
8010653a:	c3                   	ret    
8010653b:	90                   	nop
8010653c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106540 <uartputc>:
  if(!uart)
80106540:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
80106546:	55                   	push   %ebp
80106547:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106549:	85 d2                	test   %edx,%edx
{
8010654b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010654e:	74 10                	je     80106560 <uartputc+0x20>
}
80106550:	5d                   	pop    %ebp
80106551:	e9 da fe ff ff       	jmp    80106430 <uartputc.part.0>
80106556:	8d 76 00             	lea    0x0(%esi),%esi
80106559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106560:	5d                   	pop    %ebp
80106561:	c3                   	ret    
80106562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106570 <uartintr>:

void
uartintr(void)
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106576:	68 00 64 10 80       	push   $0x80106400
8010657b:	e8 90 a2 ff ff       	call   80100810 <consoleintr>
}
80106580:	83 c4 10             	add    $0x10,%esp
80106583:	c9                   	leave  
80106584:	c3                   	ret    

80106585 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106585:	6a 00                	push   $0x0
  pushl $0
80106587:	6a 00                	push   $0x0
  jmp alltraps
80106589:	e9 3c f9 ff ff       	jmp    80105eca <alltraps>

8010658e <vector1>:
.globl vector1
vector1:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $1
80106590:	6a 01                	push   $0x1
  jmp alltraps
80106592:	e9 33 f9 ff ff       	jmp    80105eca <alltraps>

80106597 <vector2>:
.globl vector2
vector2:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $2
80106599:	6a 02                	push   $0x2
  jmp alltraps
8010659b:	e9 2a f9 ff ff       	jmp    80105eca <alltraps>

801065a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801065a0:	6a 00                	push   $0x0
  pushl $3
801065a2:	6a 03                	push   $0x3
  jmp alltraps
801065a4:	e9 21 f9 ff ff       	jmp    80105eca <alltraps>

801065a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $4
801065ab:	6a 04                	push   $0x4
  jmp alltraps
801065ad:	e9 18 f9 ff ff       	jmp    80105eca <alltraps>

801065b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $5
801065b4:	6a 05                	push   $0x5
  jmp alltraps
801065b6:	e9 0f f9 ff ff       	jmp    80105eca <alltraps>

801065bb <vector6>:
.globl vector6
vector6:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $6
801065bd:	6a 06                	push   $0x6
  jmp alltraps
801065bf:	e9 06 f9 ff ff       	jmp    80105eca <alltraps>

801065c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $7
801065c6:	6a 07                	push   $0x7
  jmp alltraps
801065c8:	e9 fd f8 ff ff       	jmp    80105eca <alltraps>

801065cd <vector8>:
.globl vector8
vector8:
  pushl $8
801065cd:	6a 08                	push   $0x8
  jmp alltraps
801065cf:	e9 f6 f8 ff ff       	jmp    80105eca <alltraps>

801065d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $9
801065d6:	6a 09                	push   $0x9
  jmp alltraps
801065d8:	e9 ed f8 ff ff       	jmp    80105eca <alltraps>

801065dd <vector10>:
.globl vector10
vector10:
  pushl $10
801065dd:	6a 0a                	push   $0xa
  jmp alltraps
801065df:	e9 e6 f8 ff ff       	jmp    80105eca <alltraps>

801065e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801065e4:	6a 0b                	push   $0xb
  jmp alltraps
801065e6:	e9 df f8 ff ff       	jmp    80105eca <alltraps>

801065eb <vector12>:
.globl vector12
vector12:
  pushl $12
801065eb:	6a 0c                	push   $0xc
  jmp alltraps
801065ed:	e9 d8 f8 ff ff       	jmp    80105eca <alltraps>

801065f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801065f2:	6a 0d                	push   $0xd
  jmp alltraps
801065f4:	e9 d1 f8 ff ff       	jmp    80105eca <alltraps>

801065f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801065f9:	6a 0e                	push   $0xe
  jmp alltraps
801065fb:	e9 ca f8 ff ff       	jmp    80105eca <alltraps>

80106600 <vector15>:
.globl vector15
vector15:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $15
80106602:	6a 0f                	push   $0xf
  jmp alltraps
80106604:	e9 c1 f8 ff ff       	jmp    80105eca <alltraps>

80106609 <vector16>:
.globl vector16
vector16:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $16
8010660b:	6a 10                	push   $0x10
  jmp alltraps
8010660d:	e9 b8 f8 ff ff       	jmp    80105eca <alltraps>

80106612 <vector17>:
.globl vector17
vector17:
  pushl $17
80106612:	6a 11                	push   $0x11
  jmp alltraps
80106614:	e9 b1 f8 ff ff       	jmp    80105eca <alltraps>

80106619 <vector18>:
.globl vector18
vector18:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $18
8010661b:	6a 12                	push   $0x12
  jmp alltraps
8010661d:	e9 a8 f8 ff ff       	jmp    80105eca <alltraps>

80106622 <vector19>:
.globl vector19
vector19:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $19
80106624:	6a 13                	push   $0x13
  jmp alltraps
80106626:	e9 9f f8 ff ff       	jmp    80105eca <alltraps>

8010662b <vector20>:
.globl vector20
vector20:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $20
8010662d:	6a 14                	push   $0x14
  jmp alltraps
8010662f:	e9 96 f8 ff ff       	jmp    80105eca <alltraps>

80106634 <vector21>:
.globl vector21
vector21:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $21
80106636:	6a 15                	push   $0x15
  jmp alltraps
80106638:	e9 8d f8 ff ff       	jmp    80105eca <alltraps>

8010663d <vector22>:
.globl vector22
vector22:
  pushl $0
8010663d:	6a 00                	push   $0x0
  pushl $22
8010663f:	6a 16                	push   $0x16
  jmp alltraps
80106641:	e9 84 f8 ff ff       	jmp    80105eca <alltraps>

80106646 <vector23>:
.globl vector23
vector23:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $23
80106648:	6a 17                	push   $0x17
  jmp alltraps
8010664a:	e9 7b f8 ff ff       	jmp    80105eca <alltraps>

8010664f <vector24>:
.globl vector24
vector24:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $24
80106651:	6a 18                	push   $0x18
  jmp alltraps
80106653:	e9 72 f8 ff ff       	jmp    80105eca <alltraps>

80106658 <vector25>:
.globl vector25
vector25:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $25
8010665a:	6a 19                	push   $0x19
  jmp alltraps
8010665c:	e9 69 f8 ff ff       	jmp    80105eca <alltraps>

80106661 <vector26>:
.globl vector26
vector26:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $26
80106663:	6a 1a                	push   $0x1a
  jmp alltraps
80106665:	e9 60 f8 ff ff       	jmp    80105eca <alltraps>

8010666a <vector27>:
.globl vector27
vector27:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $27
8010666c:	6a 1b                	push   $0x1b
  jmp alltraps
8010666e:	e9 57 f8 ff ff       	jmp    80105eca <alltraps>

80106673 <vector28>:
.globl vector28
vector28:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $28
80106675:	6a 1c                	push   $0x1c
  jmp alltraps
80106677:	e9 4e f8 ff ff       	jmp    80105eca <alltraps>

8010667c <vector29>:
.globl vector29
vector29:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $29
8010667e:	6a 1d                	push   $0x1d
  jmp alltraps
80106680:	e9 45 f8 ff ff       	jmp    80105eca <alltraps>

80106685 <vector30>:
.globl vector30
vector30:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $30
80106687:	6a 1e                	push   $0x1e
  jmp alltraps
80106689:	e9 3c f8 ff ff       	jmp    80105eca <alltraps>

8010668e <vector31>:
.globl vector31
vector31:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $31
80106690:	6a 1f                	push   $0x1f
  jmp alltraps
80106692:	e9 33 f8 ff ff       	jmp    80105eca <alltraps>

80106697 <vector32>:
.globl vector32
vector32:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $32
80106699:	6a 20                	push   $0x20
  jmp alltraps
8010669b:	e9 2a f8 ff ff       	jmp    80105eca <alltraps>

801066a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $33
801066a2:	6a 21                	push   $0x21
  jmp alltraps
801066a4:	e9 21 f8 ff ff       	jmp    80105eca <alltraps>

801066a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $34
801066ab:	6a 22                	push   $0x22
  jmp alltraps
801066ad:	e9 18 f8 ff ff       	jmp    80105eca <alltraps>

801066b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $35
801066b4:	6a 23                	push   $0x23
  jmp alltraps
801066b6:	e9 0f f8 ff ff       	jmp    80105eca <alltraps>

801066bb <vector36>:
.globl vector36
vector36:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $36
801066bd:	6a 24                	push   $0x24
  jmp alltraps
801066bf:	e9 06 f8 ff ff       	jmp    80105eca <alltraps>

801066c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $37
801066c6:	6a 25                	push   $0x25
  jmp alltraps
801066c8:	e9 fd f7 ff ff       	jmp    80105eca <alltraps>

801066cd <vector38>:
.globl vector38
vector38:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $38
801066cf:	6a 26                	push   $0x26
  jmp alltraps
801066d1:	e9 f4 f7 ff ff       	jmp    80105eca <alltraps>

801066d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $39
801066d8:	6a 27                	push   $0x27
  jmp alltraps
801066da:	e9 eb f7 ff ff       	jmp    80105eca <alltraps>

801066df <vector40>:
.globl vector40
vector40:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $40
801066e1:	6a 28                	push   $0x28
  jmp alltraps
801066e3:	e9 e2 f7 ff ff       	jmp    80105eca <alltraps>

801066e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $41
801066ea:	6a 29                	push   $0x29
  jmp alltraps
801066ec:	e9 d9 f7 ff ff       	jmp    80105eca <alltraps>

801066f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $42
801066f3:	6a 2a                	push   $0x2a
  jmp alltraps
801066f5:	e9 d0 f7 ff ff       	jmp    80105eca <alltraps>

801066fa <vector43>:
.globl vector43
vector43:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $43
801066fc:	6a 2b                	push   $0x2b
  jmp alltraps
801066fe:	e9 c7 f7 ff ff       	jmp    80105eca <alltraps>

80106703 <vector44>:
.globl vector44
vector44:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $44
80106705:	6a 2c                	push   $0x2c
  jmp alltraps
80106707:	e9 be f7 ff ff       	jmp    80105eca <alltraps>

8010670c <vector45>:
.globl vector45
vector45:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $45
8010670e:	6a 2d                	push   $0x2d
  jmp alltraps
80106710:	e9 b5 f7 ff ff       	jmp    80105eca <alltraps>

80106715 <vector46>:
.globl vector46
vector46:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $46
80106717:	6a 2e                	push   $0x2e
  jmp alltraps
80106719:	e9 ac f7 ff ff       	jmp    80105eca <alltraps>

8010671e <vector47>:
.globl vector47
vector47:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $47
80106720:	6a 2f                	push   $0x2f
  jmp alltraps
80106722:	e9 a3 f7 ff ff       	jmp    80105eca <alltraps>

80106727 <vector48>:
.globl vector48
vector48:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $48
80106729:	6a 30                	push   $0x30
  jmp alltraps
8010672b:	e9 9a f7 ff ff       	jmp    80105eca <alltraps>

80106730 <vector49>:
.globl vector49
vector49:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $49
80106732:	6a 31                	push   $0x31
  jmp alltraps
80106734:	e9 91 f7 ff ff       	jmp    80105eca <alltraps>

80106739 <vector50>:
.globl vector50
vector50:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $50
8010673b:	6a 32                	push   $0x32
  jmp alltraps
8010673d:	e9 88 f7 ff ff       	jmp    80105eca <alltraps>

80106742 <vector51>:
.globl vector51
vector51:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $51
80106744:	6a 33                	push   $0x33
  jmp alltraps
80106746:	e9 7f f7 ff ff       	jmp    80105eca <alltraps>

8010674b <vector52>:
.globl vector52
vector52:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $52
8010674d:	6a 34                	push   $0x34
  jmp alltraps
8010674f:	e9 76 f7 ff ff       	jmp    80105eca <alltraps>

80106754 <vector53>:
.globl vector53
vector53:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $53
80106756:	6a 35                	push   $0x35
  jmp alltraps
80106758:	e9 6d f7 ff ff       	jmp    80105eca <alltraps>

8010675d <vector54>:
.globl vector54
vector54:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $54
8010675f:	6a 36                	push   $0x36
  jmp alltraps
80106761:	e9 64 f7 ff ff       	jmp    80105eca <alltraps>

80106766 <vector55>:
.globl vector55
vector55:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $55
80106768:	6a 37                	push   $0x37
  jmp alltraps
8010676a:	e9 5b f7 ff ff       	jmp    80105eca <alltraps>

8010676f <vector56>:
.globl vector56
vector56:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $56
80106771:	6a 38                	push   $0x38
  jmp alltraps
80106773:	e9 52 f7 ff ff       	jmp    80105eca <alltraps>

80106778 <vector57>:
.globl vector57
vector57:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $57
8010677a:	6a 39                	push   $0x39
  jmp alltraps
8010677c:	e9 49 f7 ff ff       	jmp    80105eca <alltraps>

80106781 <vector58>:
.globl vector58
vector58:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $58
80106783:	6a 3a                	push   $0x3a
  jmp alltraps
80106785:	e9 40 f7 ff ff       	jmp    80105eca <alltraps>

8010678a <vector59>:
.globl vector59
vector59:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $59
8010678c:	6a 3b                	push   $0x3b
  jmp alltraps
8010678e:	e9 37 f7 ff ff       	jmp    80105eca <alltraps>

80106793 <vector60>:
.globl vector60
vector60:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $60
80106795:	6a 3c                	push   $0x3c
  jmp alltraps
80106797:	e9 2e f7 ff ff       	jmp    80105eca <alltraps>

8010679c <vector61>:
.globl vector61
vector61:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $61
8010679e:	6a 3d                	push   $0x3d
  jmp alltraps
801067a0:	e9 25 f7 ff ff       	jmp    80105eca <alltraps>

801067a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $62
801067a7:	6a 3e                	push   $0x3e
  jmp alltraps
801067a9:	e9 1c f7 ff ff       	jmp    80105eca <alltraps>

801067ae <vector63>:
.globl vector63
vector63:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $63
801067b0:	6a 3f                	push   $0x3f
  jmp alltraps
801067b2:	e9 13 f7 ff ff       	jmp    80105eca <alltraps>

801067b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $64
801067b9:	6a 40                	push   $0x40
  jmp alltraps
801067bb:	e9 0a f7 ff ff       	jmp    80105eca <alltraps>

801067c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $65
801067c2:	6a 41                	push   $0x41
  jmp alltraps
801067c4:	e9 01 f7 ff ff       	jmp    80105eca <alltraps>

801067c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $66
801067cb:	6a 42                	push   $0x42
  jmp alltraps
801067cd:	e9 f8 f6 ff ff       	jmp    80105eca <alltraps>

801067d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $67
801067d4:	6a 43                	push   $0x43
  jmp alltraps
801067d6:	e9 ef f6 ff ff       	jmp    80105eca <alltraps>

801067db <vector68>:
.globl vector68
vector68:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $68
801067dd:	6a 44                	push   $0x44
  jmp alltraps
801067df:	e9 e6 f6 ff ff       	jmp    80105eca <alltraps>

801067e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $69
801067e6:	6a 45                	push   $0x45
  jmp alltraps
801067e8:	e9 dd f6 ff ff       	jmp    80105eca <alltraps>

801067ed <vector70>:
.globl vector70
vector70:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $70
801067ef:	6a 46                	push   $0x46
  jmp alltraps
801067f1:	e9 d4 f6 ff ff       	jmp    80105eca <alltraps>

801067f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $71
801067f8:	6a 47                	push   $0x47
  jmp alltraps
801067fa:	e9 cb f6 ff ff       	jmp    80105eca <alltraps>

801067ff <vector72>:
.globl vector72
vector72:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $72
80106801:	6a 48                	push   $0x48
  jmp alltraps
80106803:	e9 c2 f6 ff ff       	jmp    80105eca <alltraps>

80106808 <vector73>:
.globl vector73
vector73:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $73
8010680a:	6a 49                	push   $0x49
  jmp alltraps
8010680c:	e9 b9 f6 ff ff       	jmp    80105eca <alltraps>

80106811 <vector74>:
.globl vector74
vector74:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $74
80106813:	6a 4a                	push   $0x4a
  jmp alltraps
80106815:	e9 b0 f6 ff ff       	jmp    80105eca <alltraps>

8010681a <vector75>:
.globl vector75
vector75:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $75
8010681c:	6a 4b                	push   $0x4b
  jmp alltraps
8010681e:	e9 a7 f6 ff ff       	jmp    80105eca <alltraps>

80106823 <vector76>:
.globl vector76
vector76:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $76
80106825:	6a 4c                	push   $0x4c
  jmp alltraps
80106827:	e9 9e f6 ff ff       	jmp    80105eca <alltraps>

8010682c <vector77>:
.globl vector77
vector77:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $77
8010682e:	6a 4d                	push   $0x4d
  jmp alltraps
80106830:	e9 95 f6 ff ff       	jmp    80105eca <alltraps>

80106835 <vector78>:
.globl vector78
vector78:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $78
80106837:	6a 4e                	push   $0x4e
  jmp alltraps
80106839:	e9 8c f6 ff ff       	jmp    80105eca <alltraps>

8010683e <vector79>:
.globl vector79
vector79:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $79
80106840:	6a 4f                	push   $0x4f
  jmp alltraps
80106842:	e9 83 f6 ff ff       	jmp    80105eca <alltraps>

80106847 <vector80>:
.globl vector80
vector80:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $80
80106849:	6a 50                	push   $0x50
  jmp alltraps
8010684b:	e9 7a f6 ff ff       	jmp    80105eca <alltraps>

80106850 <vector81>:
.globl vector81
vector81:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $81
80106852:	6a 51                	push   $0x51
  jmp alltraps
80106854:	e9 71 f6 ff ff       	jmp    80105eca <alltraps>

80106859 <vector82>:
.globl vector82
vector82:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $82
8010685b:	6a 52                	push   $0x52
  jmp alltraps
8010685d:	e9 68 f6 ff ff       	jmp    80105eca <alltraps>

80106862 <vector83>:
.globl vector83
vector83:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $83
80106864:	6a 53                	push   $0x53
  jmp alltraps
80106866:	e9 5f f6 ff ff       	jmp    80105eca <alltraps>

8010686b <vector84>:
.globl vector84
vector84:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $84
8010686d:	6a 54                	push   $0x54
  jmp alltraps
8010686f:	e9 56 f6 ff ff       	jmp    80105eca <alltraps>

80106874 <vector85>:
.globl vector85
vector85:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $85
80106876:	6a 55                	push   $0x55
  jmp alltraps
80106878:	e9 4d f6 ff ff       	jmp    80105eca <alltraps>

8010687d <vector86>:
.globl vector86
vector86:
  pushl $0
8010687d:	6a 00                	push   $0x0
  pushl $86
8010687f:	6a 56                	push   $0x56
  jmp alltraps
80106881:	e9 44 f6 ff ff       	jmp    80105eca <alltraps>

80106886 <vector87>:
.globl vector87
vector87:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $87
80106888:	6a 57                	push   $0x57
  jmp alltraps
8010688a:	e9 3b f6 ff ff       	jmp    80105eca <alltraps>

8010688f <vector88>:
.globl vector88
vector88:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $88
80106891:	6a 58                	push   $0x58
  jmp alltraps
80106893:	e9 32 f6 ff ff       	jmp    80105eca <alltraps>

80106898 <vector89>:
.globl vector89
vector89:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $89
8010689a:	6a 59                	push   $0x59
  jmp alltraps
8010689c:	e9 29 f6 ff ff       	jmp    80105eca <alltraps>

801068a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $90
801068a3:	6a 5a                	push   $0x5a
  jmp alltraps
801068a5:	e9 20 f6 ff ff       	jmp    80105eca <alltraps>

801068aa <vector91>:
.globl vector91
vector91:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $91
801068ac:	6a 5b                	push   $0x5b
  jmp alltraps
801068ae:	e9 17 f6 ff ff       	jmp    80105eca <alltraps>

801068b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $92
801068b5:	6a 5c                	push   $0x5c
  jmp alltraps
801068b7:	e9 0e f6 ff ff       	jmp    80105eca <alltraps>

801068bc <vector93>:
.globl vector93
vector93:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $93
801068be:	6a 5d                	push   $0x5d
  jmp alltraps
801068c0:	e9 05 f6 ff ff       	jmp    80105eca <alltraps>

801068c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $94
801068c7:	6a 5e                	push   $0x5e
  jmp alltraps
801068c9:	e9 fc f5 ff ff       	jmp    80105eca <alltraps>

801068ce <vector95>:
.globl vector95
vector95:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $95
801068d0:	6a 5f                	push   $0x5f
  jmp alltraps
801068d2:	e9 f3 f5 ff ff       	jmp    80105eca <alltraps>

801068d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $96
801068d9:	6a 60                	push   $0x60
  jmp alltraps
801068db:	e9 ea f5 ff ff       	jmp    80105eca <alltraps>

801068e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $97
801068e2:	6a 61                	push   $0x61
  jmp alltraps
801068e4:	e9 e1 f5 ff ff       	jmp    80105eca <alltraps>

801068e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801068e9:	6a 00                	push   $0x0
  pushl $98
801068eb:	6a 62                	push   $0x62
  jmp alltraps
801068ed:	e9 d8 f5 ff ff       	jmp    80105eca <alltraps>

801068f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $99
801068f4:	6a 63                	push   $0x63
  jmp alltraps
801068f6:	e9 cf f5 ff ff       	jmp    80105eca <alltraps>

801068fb <vector100>:
.globl vector100
vector100:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $100
801068fd:	6a 64                	push   $0x64
  jmp alltraps
801068ff:	e9 c6 f5 ff ff       	jmp    80105eca <alltraps>

80106904 <vector101>:
.globl vector101
vector101:
  pushl $0
80106904:	6a 00                	push   $0x0
  pushl $101
80106906:	6a 65                	push   $0x65
  jmp alltraps
80106908:	e9 bd f5 ff ff       	jmp    80105eca <alltraps>

8010690d <vector102>:
.globl vector102
vector102:
  pushl $0
8010690d:	6a 00                	push   $0x0
  pushl $102
8010690f:	6a 66                	push   $0x66
  jmp alltraps
80106911:	e9 b4 f5 ff ff       	jmp    80105eca <alltraps>

80106916 <vector103>:
.globl vector103
vector103:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $103
80106918:	6a 67                	push   $0x67
  jmp alltraps
8010691a:	e9 ab f5 ff ff       	jmp    80105eca <alltraps>

8010691f <vector104>:
.globl vector104
vector104:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $104
80106921:	6a 68                	push   $0x68
  jmp alltraps
80106923:	e9 a2 f5 ff ff       	jmp    80105eca <alltraps>

80106928 <vector105>:
.globl vector105
vector105:
  pushl $0
80106928:	6a 00                	push   $0x0
  pushl $105
8010692a:	6a 69                	push   $0x69
  jmp alltraps
8010692c:	e9 99 f5 ff ff       	jmp    80105eca <alltraps>

80106931 <vector106>:
.globl vector106
vector106:
  pushl $0
80106931:	6a 00                	push   $0x0
  pushl $106
80106933:	6a 6a                	push   $0x6a
  jmp alltraps
80106935:	e9 90 f5 ff ff       	jmp    80105eca <alltraps>

8010693a <vector107>:
.globl vector107
vector107:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $107
8010693c:	6a 6b                	push   $0x6b
  jmp alltraps
8010693e:	e9 87 f5 ff ff       	jmp    80105eca <alltraps>

80106943 <vector108>:
.globl vector108
vector108:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $108
80106945:	6a 6c                	push   $0x6c
  jmp alltraps
80106947:	e9 7e f5 ff ff       	jmp    80105eca <alltraps>

8010694c <vector109>:
.globl vector109
vector109:
  pushl $0
8010694c:	6a 00                	push   $0x0
  pushl $109
8010694e:	6a 6d                	push   $0x6d
  jmp alltraps
80106950:	e9 75 f5 ff ff       	jmp    80105eca <alltraps>

80106955 <vector110>:
.globl vector110
vector110:
  pushl $0
80106955:	6a 00                	push   $0x0
  pushl $110
80106957:	6a 6e                	push   $0x6e
  jmp alltraps
80106959:	e9 6c f5 ff ff       	jmp    80105eca <alltraps>

8010695e <vector111>:
.globl vector111
vector111:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $111
80106960:	6a 6f                	push   $0x6f
  jmp alltraps
80106962:	e9 63 f5 ff ff       	jmp    80105eca <alltraps>

80106967 <vector112>:
.globl vector112
vector112:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $112
80106969:	6a 70                	push   $0x70
  jmp alltraps
8010696b:	e9 5a f5 ff ff       	jmp    80105eca <alltraps>

80106970 <vector113>:
.globl vector113
vector113:
  pushl $0
80106970:	6a 00                	push   $0x0
  pushl $113
80106972:	6a 71                	push   $0x71
  jmp alltraps
80106974:	e9 51 f5 ff ff       	jmp    80105eca <alltraps>

80106979 <vector114>:
.globl vector114
vector114:
  pushl $0
80106979:	6a 00                	push   $0x0
  pushl $114
8010697b:	6a 72                	push   $0x72
  jmp alltraps
8010697d:	e9 48 f5 ff ff       	jmp    80105eca <alltraps>

80106982 <vector115>:
.globl vector115
vector115:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $115
80106984:	6a 73                	push   $0x73
  jmp alltraps
80106986:	e9 3f f5 ff ff       	jmp    80105eca <alltraps>

8010698b <vector116>:
.globl vector116
vector116:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $116
8010698d:	6a 74                	push   $0x74
  jmp alltraps
8010698f:	e9 36 f5 ff ff       	jmp    80105eca <alltraps>

80106994 <vector117>:
.globl vector117
vector117:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $117
80106996:	6a 75                	push   $0x75
  jmp alltraps
80106998:	e9 2d f5 ff ff       	jmp    80105eca <alltraps>

8010699d <vector118>:
.globl vector118
vector118:
  pushl $0
8010699d:	6a 00                	push   $0x0
  pushl $118
8010699f:	6a 76                	push   $0x76
  jmp alltraps
801069a1:	e9 24 f5 ff ff       	jmp    80105eca <alltraps>

801069a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801069a6:	6a 00                	push   $0x0
  pushl $119
801069a8:	6a 77                	push   $0x77
  jmp alltraps
801069aa:	e9 1b f5 ff ff       	jmp    80105eca <alltraps>

801069af <vector120>:
.globl vector120
vector120:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $120
801069b1:	6a 78                	push   $0x78
  jmp alltraps
801069b3:	e9 12 f5 ff ff       	jmp    80105eca <alltraps>

801069b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801069b8:	6a 00                	push   $0x0
  pushl $121
801069ba:	6a 79                	push   $0x79
  jmp alltraps
801069bc:	e9 09 f5 ff ff       	jmp    80105eca <alltraps>

801069c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801069c1:	6a 00                	push   $0x0
  pushl $122
801069c3:	6a 7a                	push   $0x7a
  jmp alltraps
801069c5:	e9 00 f5 ff ff       	jmp    80105eca <alltraps>

801069ca <vector123>:
.globl vector123
vector123:
  pushl $0
801069ca:	6a 00                	push   $0x0
  pushl $123
801069cc:	6a 7b                	push   $0x7b
  jmp alltraps
801069ce:	e9 f7 f4 ff ff       	jmp    80105eca <alltraps>

801069d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $124
801069d5:	6a 7c                	push   $0x7c
  jmp alltraps
801069d7:	e9 ee f4 ff ff       	jmp    80105eca <alltraps>

801069dc <vector125>:
.globl vector125
vector125:
  pushl $0
801069dc:	6a 00                	push   $0x0
  pushl $125
801069de:	6a 7d                	push   $0x7d
  jmp alltraps
801069e0:	e9 e5 f4 ff ff       	jmp    80105eca <alltraps>

801069e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801069e5:	6a 00                	push   $0x0
  pushl $126
801069e7:	6a 7e                	push   $0x7e
  jmp alltraps
801069e9:	e9 dc f4 ff ff       	jmp    80105eca <alltraps>

801069ee <vector127>:
.globl vector127
vector127:
  pushl $0
801069ee:	6a 00                	push   $0x0
  pushl $127
801069f0:	6a 7f                	push   $0x7f
  jmp alltraps
801069f2:	e9 d3 f4 ff ff       	jmp    80105eca <alltraps>

801069f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $128
801069f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801069fe:	e9 c7 f4 ff ff       	jmp    80105eca <alltraps>

80106a03 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $129
80106a05:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a0a:	e9 bb f4 ff ff       	jmp    80105eca <alltraps>

80106a0f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $130
80106a11:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a16:	e9 af f4 ff ff       	jmp    80105eca <alltraps>

80106a1b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $131
80106a1d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a22:	e9 a3 f4 ff ff       	jmp    80105eca <alltraps>

80106a27 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $132
80106a29:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a2e:	e9 97 f4 ff ff       	jmp    80105eca <alltraps>

80106a33 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $133
80106a35:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a3a:	e9 8b f4 ff ff       	jmp    80105eca <alltraps>

80106a3f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $134
80106a41:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a46:	e9 7f f4 ff ff       	jmp    80105eca <alltraps>

80106a4b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $135
80106a4d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a52:	e9 73 f4 ff ff       	jmp    80105eca <alltraps>

80106a57 <vector136>:
.globl vector136
vector136:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $136
80106a59:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a5e:	e9 67 f4 ff ff       	jmp    80105eca <alltraps>

80106a63 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $137
80106a65:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a6a:	e9 5b f4 ff ff       	jmp    80105eca <alltraps>

80106a6f <vector138>:
.globl vector138
vector138:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $138
80106a71:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a76:	e9 4f f4 ff ff       	jmp    80105eca <alltraps>

80106a7b <vector139>:
.globl vector139
vector139:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $139
80106a7d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a82:	e9 43 f4 ff ff       	jmp    80105eca <alltraps>

80106a87 <vector140>:
.globl vector140
vector140:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $140
80106a89:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a8e:	e9 37 f4 ff ff       	jmp    80105eca <alltraps>

80106a93 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $141
80106a95:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a9a:	e9 2b f4 ff ff       	jmp    80105eca <alltraps>

80106a9f <vector142>:
.globl vector142
vector142:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $142
80106aa1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106aa6:	e9 1f f4 ff ff       	jmp    80105eca <alltraps>

80106aab <vector143>:
.globl vector143
vector143:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $143
80106aad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ab2:	e9 13 f4 ff ff       	jmp    80105eca <alltraps>

80106ab7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $144
80106ab9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106abe:	e9 07 f4 ff ff       	jmp    80105eca <alltraps>

80106ac3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $145
80106ac5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106aca:	e9 fb f3 ff ff       	jmp    80105eca <alltraps>

80106acf <vector146>:
.globl vector146
vector146:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $146
80106ad1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ad6:	e9 ef f3 ff ff       	jmp    80105eca <alltraps>

80106adb <vector147>:
.globl vector147
vector147:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $147
80106add:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ae2:	e9 e3 f3 ff ff       	jmp    80105eca <alltraps>

80106ae7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $148
80106ae9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106aee:	e9 d7 f3 ff ff       	jmp    80105eca <alltraps>

80106af3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $149
80106af5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106afa:	e9 cb f3 ff ff       	jmp    80105eca <alltraps>

80106aff <vector150>:
.globl vector150
vector150:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $150
80106b01:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b06:	e9 bf f3 ff ff       	jmp    80105eca <alltraps>

80106b0b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $151
80106b0d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b12:	e9 b3 f3 ff ff       	jmp    80105eca <alltraps>

80106b17 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $152
80106b19:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b1e:	e9 a7 f3 ff ff       	jmp    80105eca <alltraps>

80106b23 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $153
80106b25:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b2a:	e9 9b f3 ff ff       	jmp    80105eca <alltraps>

80106b2f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $154
80106b31:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b36:	e9 8f f3 ff ff       	jmp    80105eca <alltraps>

80106b3b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $155
80106b3d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b42:	e9 83 f3 ff ff       	jmp    80105eca <alltraps>

80106b47 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $156
80106b49:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b4e:	e9 77 f3 ff ff       	jmp    80105eca <alltraps>

80106b53 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $157
80106b55:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b5a:	e9 6b f3 ff ff       	jmp    80105eca <alltraps>

80106b5f <vector158>:
.globl vector158
vector158:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $158
80106b61:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b66:	e9 5f f3 ff ff       	jmp    80105eca <alltraps>

80106b6b <vector159>:
.globl vector159
vector159:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $159
80106b6d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b72:	e9 53 f3 ff ff       	jmp    80105eca <alltraps>

80106b77 <vector160>:
.globl vector160
vector160:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $160
80106b79:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b7e:	e9 47 f3 ff ff       	jmp    80105eca <alltraps>

80106b83 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $161
80106b85:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b8a:	e9 3b f3 ff ff       	jmp    80105eca <alltraps>

80106b8f <vector162>:
.globl vector162
vector162:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $162
80106b91:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b96:	e9 2f f3 ff ff       	jmp    80105eca <alltraps>

80106b9b <vector163>:
.globl vector163
vector163:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $163
80106b9d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ba2:	e9 23 f3 ff ff       	jmp    80105eca <alltraps>

80106ba7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $164
80106ba9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106bae:	e9 17 f3 ff ff       	jmp    80105eca <alltraps>

80106bb3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $165
80106bb5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106bba:	e9 0b f3 ff ff       	jmp    80105eca <alltraps>

80106bbf <vector166>:
.globl vector166
vector166:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $166
80106bc1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106bc6:	e9 ff f2 ff ff       	jmp    80105eca <alltraps>

80106bcb <vector167>:
.globl vector167
vector167:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $167
80106bcd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106bd2:	e9 f3 f2 ff ff       	jmp    80105eca <alltraps>

80106bd7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $168
80106bd9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106bde:	e9 e7 f2 ff ff       	jmp    80105eca <alltraps>

80106be3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $169
80106be5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106bea:	e9 db f2 ff ff       	jmp    80105eca <alltraps>

80106bef <vector170>:
.globl vector170
vector170:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $170
80106bf1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106bf6:	e9 cf f2 ff ff       	jmp    80105eca <alltraps>

80106bfb <vector171>:
.globl vector171
vector171:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $171
80106bfd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c02:	e9 c3 f2 ff ff       	jmp    80105eca <alltraps>

80106c07 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $172
80106c09:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c0e:	e9 b7 f2 ff ff       	jmp    80105eca <alltraps>

80106c13 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $173
80106c15:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c1a:	e9 ab f2 ff ff       	jmp    80105eca <alltraps>

80106c1f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $174
80106c21:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c26:	e9 9f f2 ff ff       	jmp    80105eca <alltraps>

80106c2b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $175
80106c2d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c32:	e9 93 f2 ff ff       	jmp    80105eca <alltraps>

80106c37 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $176
80106c39:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c3e:	e9 87 f2 ff ff       	jmp    80105eca <alltraps>

80106c43 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $177
80106c45:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c4a:	e9 7b f2 ff ff       	jmp    80105eca <alltraps>

80106c4f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $178
80106c51:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c56:	e9 6f f2 ff ff       	jmp    80105eca <alltraps>

80106c5b <vector179>:
.globl vector179
vector179:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $179
80106c5d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c62:	e9 63 f2 ff ff       	jmp    80105eca <alltraps>

80106c67 <vector180>:
.globl vector180
vector180:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $180
80106c69:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c6e:	e9 57 f2 ff ff       	jmp    80105eca <alltraps>

80106c73 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $181
80106c75:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c7a:	e9 4b f2 ff ff       	jmp    80105eca <alltraps>

80106c7f <vector182>:
.globl vector182
vector182:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $182
80106c81:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c86:	e9 3f f2 ff ff       	jmp    80105eca <alltraps>

80106c8b <vector183>:
.globl vector183
vector183:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $183
80106c8d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c92:	e9 33 f2 ff ff       	jmp    80105eca <alltraps>

80106c97 <vector184>:
.globl vector184
vector184:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $184
80106c99:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c9e:	e9 27 f2 ff ff       	jmp    80105eca <alltraps>

80106ca3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $185
80106ca5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106caa:	e9 1b f2 ff ff       	jmp    80105eca <alltraps>

80106caf <vector186>:
.globl vector186
vector186:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $186
80106cb1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106cb6:	e9 0f f2 ff ff       	jmp    80105eca <alltraps>

80106cbb <vector187>:
.globl vector187
vector187:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $187
80106cbd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106cc2:	e9 03 f2 ff ff       	jmp    80105eca <alltraps>

80106cc7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $188
80106cc9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106cce:	e9 f7 f1 ff ff       	jmp    80105eca <alltraps>

80106cd3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $189
80106cd5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106cda:	e9 eb f1 ff ff       	jmp    80105eca <alltraps>

80106cdf <vector190>:
.globl vector190
vector190:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $190
80106ce1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106ce6:	e9 df f1 ff ff       	jmp    80105eca <alltraps>

80106ceb <vector191>:
.globl vector191
vector191:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $191
80106ced:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106cf2:	e9 d3 f1 ff ff       	jmp    80105eca <alltraps>

80106cf7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $192
80106cf9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106cfe:	e9 c7 f1 ff ff       	jmp    80105eca <alltraps>

80106d03 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $193
80106d05:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d0a:	e9 bb f1 ff ff       	jmp    80105eca <alltraps>

80106d0f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $194
80106d11:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d16:	e9 af f1 ff ff       	jmp    80105eca <alltraps>

80106d1b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $195
80106d1d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d22:	e9 a3 f1 ff ff       	jmp    80105eca <alltraps>

80106d27 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $196
80106d29:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d2e:	e9 97 f1 ff ff       	jmp    80105eca <alltraps>

80106d33 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $197
80106d35:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d3a:	e9 8b f1 ff ff       	jmp    80105eca <alltraps>

80106d3f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $198
80106d41:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d46:	e9 7f f1 ff ff       	jmp    80105eca <alltraps>

80106d4b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $199
80106d4d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d52:	e9 73 f1 ff ff       	jmp    80105eca <alltraps>

80106d57 <vector200>:
.globl vector200
vector200:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $200
80106d59:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d5e:	e9 67 f1 ff ff       	jmp    80105eca <alltraps>

80106d63 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $201
80106d65:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d6a:	e9 5b f1 ff ff       	jmp    80105eca <alltraps>

80106d6f <vector202>:
.globl vector202
vector202:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $202
80106d71:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d76:	e9 4f f1 ff ff       	jmp    80105eca <alltraps>

80106d7b <vector203>:
.globl vector203
vector203:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $203
80106d7d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d82:	e9 43 f1 ff ff       	jmp    80105eca <alltraps>

80106d87 <vector204>:
.globl vector204
vector204:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $204
80106d89:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d8e:	e9 37 f1 ff ff       	jmp    80105eca <alltraps>

80106d93 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $205
80106d95:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d9a:	e9 2b f1 ff ff       	jmp    80105eca <alltraps>

80106d9f <vector206>:
.globl vector206
vector206:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $206
80106da1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106da6:	e9 1f f1 ff ff       	jmp    80105eca <alltraps>

80106dab <vector207>:
.globl vector207
vector207:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $207
80106dad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106db2:	e9 13 f1 ff ff       	jmp    80105eca <alltraps>

80106db7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $208
80106db9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106dbe:	e9 07 f1 ff ff       	jmp    80105eca <alltraps>

80106dc3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $209
80106dc5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106dca:	e9 fb f0 ff ff       	jmp    80105eca <alltraps>

80106dcf <vector210>:
.globl vector210
vector210:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $210
80106dd1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106dd6:	e9 ef f0 ff ff       	jmp    80105eca <alltraps>

80106ddb <vector211>:
.globl vector211
vector211:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $211
80106ddd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106de2:	e9 e3 f0 ff ff       	jmp    80105eca <alltraps>

80106de7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $212
80106de9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106dee:	e9 d7 f0 ff ff       	jmp    80105eca <alltraps>

80106df3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $213
80106df5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106dfa:	e9 cb f0 ff ff       	jmp    80105eca <alltraps>

80106dff <vector214>:
.globl vector214
vector214:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $214
80106e01:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e06:	e9 bf f0 ff ff       	jmp    80105eca <alltraps>

80106e0b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $215
80106e0d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e12:	e9 b3 f0 ff ff       	jmp    80105eca <alltraps>

80106e17 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $216
80106e19:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e1e:	e9 a7 f0 ff ff       	jmp    80105eca <alltraps>

80106e23 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $217
80106e25:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e2a:	e9 9b f0 ff ff       	jmp    80105eca <alltraps>

80106e2f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $218
80106e31:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e36:	e9 8f f0 ff ff       	jmp    80105eca <alltraps>

80106e3b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $219
80106e3d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e42:	e9 83 f0 ff ff       	jmp    80105eca <alltraps>

80106e47 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $220
80106e49:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e4e:	e9 77 f0 ff ff       	jmp    80105eca <alltraps>

80106e53 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $221
80106e55:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e5a:	e9 6b f0 ff ff       	jmp    80105eca <alltraps>

80106e5f <vector222>:
.globl vector222
vector222:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $222
80106e61:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e66:	e9 5f f0 ff ff       	jmp    80105eca <alltraps>

80106e6b <vector223>:
.globl vector223
vector223:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $223
80106e6d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e72:	e9 53 f0 ff ff       	jmp    80105eca <alltraps>

80106e77 <vector224>:
.globl vector224
vector224:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $224
80106e79:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e7e:	e9 47 f0 ff ff       	jmp    80105eca <alltraps>

80106e83 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $225
80106e85:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e8a:	e9 3b f0 ff ff       	jmp    80105eca <alltraps>

80106e8f <vector226>:
.globl vector226
vector226:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $226
80106e91:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e96:	e9 2f f0 ff ff       	jmp    80105eca <alltraps>

80106e9b <vector227>:
.globl vector227
vector227:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $227
80106e9d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ea2:	e9 23 f0 ff ff       	jmp    80105eca <alltraps>

80106ea7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $228
80106ea9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106eae:	e9 17 f0 ff ff       	jmp    80105eca <alltraps>

80106eb3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $229
80106eb5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106eba:	e9 0b f0 ff ff       	jmp    80105eca <alltraps>

80106ebf <vector230>:
.globl vector230
vector230:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $230
80106ec1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ec6:	e9 ff ef ff ff       	jmp    80105eca <alltraps>

80106ecb <vector231>:
.globl vector231
vector231:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $231
80106ecd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ed2:	e9 f3 ef ff ff       	jmp    80105eca <alltraps>

80106ed7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $232
80106ed9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ede:	e9 e7 ef ff ff       	jmp    80105eca <alltraps>

80106ee3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $233
80106ee5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106eea:	e9 db ef ff ff       	jmp    80105eca <alltraps>

80106eef <vector234>:
.globl vector234
vector234:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $234
80106ef1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ef6:	e9 cf ef ff ff       	jmp    80105eca <alltraps>

80106efb <vector235>:
.globl vector235
vector235:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $235
80106efd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f02:	e9 c3 ef ff ff       	jmp    80105eca <alltraps>

80106f07 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $236
80106f09:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f0e:	e9 b7 ef ff ff       	jmp    80105eca <alltraps>

80106f13 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $237
80106f15:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f1a:	e9 ab ef ff ff       	jmp    80105eca <alltraps>

80106f1f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $238
80106f21:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f26:	e9 9f ef ff ff       	jmp    80105eca <alltraps>

80106f2b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $239
80106f2d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f32:	e9 93 ef ff ff       	jmp    80105eca <alltraps>

80106f37 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $240
80106f39:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f3e:	e9 87 ef ff ff       	jmp    80105eca <alltraps>

80106f43 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $241
80106f45:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f4a:	e9 7b ef ff ff       	jmp    80105eca <alltraps>

80106f4f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $242
80106f51:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f56:	e9 6f ef ff ff       	jmp    80105eca <alltraps>

80106f5b <vector243>:
.globl vector243
vector243:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $243
80106f5d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f62:	e9 63 ef ff ff       	jmp    80105eca <alltraps>

80106f67 <vector244>:
.globl vector244
vector244:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $244
80106f69:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f6e:	e9 57 ef ff ff       	jmp    80105eca <alltraps>

80106f73 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $245
80106f75:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f7a:	e9 4b ef ff ff       	jmp    80105eca <alltraps>

80106f7f <vector246>:
.globl vector246
vector246:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $246
80106f81:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f86:	e9 3f ef ff ff       	jmp    80105eca <alltraps>

80106f8b <vector247>:
.globl vector247
vector247:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $247
80106f8d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f92:	e9 33 ef ff ff       	jmp    80105eca <alltraps>

80106f97 <vector248>:
.globl vector248
vector248:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $248
80106f99:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f9e:	e9 27 ef ff ff       	jmp    80105eca <alltraps>

80106fa3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $249
80106fa5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106faa:	e9 1b ef ff ff       	jmp    80105eca <alltraps>

80106faf <vector250>:
.globl vector250
vector250:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $250
80106fb1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106fb6:	e9 0f ef ff ff       	jmp    80105eca <alltraps>

80106fbb <vector251>:
.globl vector251
vector251:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $251
80106fbd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106fc2:	e9 03 ef ff ff       	jmp    80105eca <alltraps>

80106fc7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $252
80106fc9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106fce:	e9 f7 ee ff ff       	jmp    80105eca <alltraps>

80106fd3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $253
80106fd5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106fda:	e9 eb ee ff ff       	jmp    80105eca <alltraps>

80106fdf <vector254>:
.globl vector254
vector254:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $254
80106fe1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106fe6:	e9 df ee ff ff       	jmp    80105eca <alltraps>

80106feb <vector255>:
.globl vector255
vector255:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $255
80106fed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ff2:	e9 d3 ee ff ff       	jmp    80105eca <alltraps>
80106ff7:	66 90                	xchg   %ax,%ax
80106ff9:	66 90                	xchg   %ax,%ax
80106ffb:	66 90                	xchg   %ax,%ax
80106ffd:	66 90                	xchg   %ax,%ax
80106fff:	90                   	nop

80107000 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
//    if (DEBUGMODE == 2&& notShell())
//        cprintf("WALKPGDIR-");
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80107006:	89 d3                	mov    %edx,%ebx
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80107008:	89 d7                	mov    %edx,%edi
    pde = &pgdir[PDX(va)];
8010700a:	c1 eb 16             	shr    $0x16,%ebx
8010700d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80107010:	83 ec 0c             	sub    $0xc,%esp
    if (*pde & PTE_P) {
80107013:	8b 06                	mov    (%esi),%eax
80107015:	a8 01                	test   $0x1,%al
80107017:	74 27                	je     80107040 <walkpgdir+0x40>
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
80107019:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010701e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
//    if (DEBUGMODE == 2&& notShell())
//        cprintf(">WALKPGDIR-DONE!\t");
    return &pgtab[PTX(va)];
80107024:	c1 ef 0a             	shr    $0xa,%edi
}
80107027:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return &pgtab[PTX(va)];
8010702a:	89 fa                	mov    %edi,%edx
8010702c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107032:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107035:	5b                   	pop    %ebx
80107036:	5e                   	pop    %esi
80107037:	5f                   	pop    %edi
80107038:	5d                   	pop    %ebp
80107039:	c3                   	ret    
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!alloc)
80107040:	85 c9                	test   %ecx,%ecx
80107042:	74 2c                	je     80107070 <walkpgdir+0x70>
        if ((pgtab = (pte_t *) kalloc()) == 0)
80107044:	e8 c7 b8 ff ff       	call   80102910 <kalloc>
80107049:	85 c0                	test   %eax,%eax
8010704b:	89 c3                	mov    %eax,%ebx
8010704d:	74 21                	je     80107070 <walkpgdir+0x70>
        memset(pgtab, 0, PGSIZE);
8010704f:	83 ec 04             	sub    $0x4,%esp
80107052:	68 00 10 00 00       	push   $0x1000
80107057:	6a 00                	push   $0x0
80107059:	50                   	push   %eax
8010705a:	e8 41 dc ff ff       	call   80104ca0 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010705f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107065:	83 c4 10             	add    $0x10,%esp
80107068:	83 c8 07             	or     $0x7,%eax
8010706b:	89 06                	mov    %eax,(%esi)
8010706d:	eb b5                	jmp    80107024 <walkpgdir+0x24>
8010706f:	90                   	nop
}
80107070:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80107073:	31 c0                	xor    %eax,%eax
}
80107075:	5b                   	pop    %ebx
80107076:	5e                   	pop    %esi
80107077:	5f                   	pop    %edi
80107078:	5d                   	pop    %ebp
80107079:	c3                   	ret    
8010707a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107080 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
    char *a, *last;
    pte_t *pte;

    a = (char *) PGROUNDDOWN((uint) va);
80107086:	89 d3                	mov    %edx,%ebx
80107088:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
8010708e:	83 ec 1c             	sub    $0x1c,%esp
80107091:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
80107094:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107098:	8b 7d 08             	mov    0x8(%ebp),%edi
8010709b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
            panic("remap");
        *pte = pa | perm | PTE_P;
801070a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a6:	29 df                	sub    %ebx,%edi
801070a8:	83 c8 01             	or     $0x1,%eax
801070ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
801070ae:	eb 15                	jmp    801070c5 <mappages+0x45>
        if (*pte & PTE_P)
801070b0:	f6 00 01             	testb  $0x1,(%eax)
801070b3:	75 45                	jne    801070fa <mappages+0x7a>
        *pte = pa | perm | PTE_P;
801070b5:	0b 75 dc             	or     -0x24(%ebp),%esi
        if (a == last)
801070b8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
        *pte = pa | perm | PTE_P;
801070bb:	89 30                	mov    %esi,(%eax)
        if (a == last)
801070bd:	74 31                	je     801070f0 <mappages+0x70>
            break;
        a += PGSIZE;
801070bf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
801070c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070c8:	b9 01 00 00 00       	mov    $0x1,%ecx
801070cd:	89 da                	mov    %ebx,%edx
801070cf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801070d2:	e8 29 ff ff ff       	call   80107000 <walkpgdir>
801070d7:	85 c0                	test   %eax,%eax
801070d9:	75 d5                	jne    801070b0 <mappages+0x30>
        pa += PGSIZE;
    }
    return 0;
}
801070db:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
801070de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070e3:	5b                   	pop    %ebx
801070e4:	5e                   	pop    %esi
801070e5:	5f                   	pop    %edi
801070e6:	5d                   	pop    %ebp
801070e7:	c3                   	ret    
801070e8:	90                   	nop
801070e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801070f3:	31 c0                	xor    %eax,%eax
}
801070f5:	5b                   	pop    %ebx
801070f6:	5e                   	pop    %esi
801070f7:	5f                   	pop    %edi
801070f8:	5d                   	pop    %ebp
801070f9:	c3                   	ret    
            panic("remap");
801070fa:	83 ec 0c             	sub    $0xc,%esp
801070fd:	68 78 87 10 80       	push   $0x80108778
80107102:	e8 89 92 ff ff       	call   80100390 <panic>
80107107:	89 f6                	mov    %esi,%esi
80107109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107110 <seginit>:
seginit(void) {
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
80107116:	e8 c5 cb ff ff       	call   80103ce0 <cpuid>
8010711b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107121:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107126:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010712a:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80107131:	ff 00 00 
80107134:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
8010713b:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010713e:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80107145:	ff 00 00 
80107148:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
8010714f:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80107152:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80107159:	ff 00 00 
8010715c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107163:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107166:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
8010716d:	ff 00 00 
80107170:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80107177:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
8010717a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
8010717f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107183:	c1 e8 10             	shr    $0x10,%eax
80107186:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010718a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010718d:	0f 01 10             	lgdtl  (%eax)
}
80107190:	c9                   	leave  
80107191:	c3                   	ret    
80107192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071a0 <walkpgdir2>:
walkpgdir2(pde_t *pgdir, const void *va, int alloc) {
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
    return walkpgdir(pgdir, va, alloc);
801071a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801071a6:	8b 55 0c             	mov    0xc(%ebp),%edx
801071a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801071ac:	5d                   	pop    %ebp
    return walkpgdir(pgdir, va, alloc);
801071ad:	e9 4e fe ff ff       	jmp    80107000 <walkpgdir>
801071b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071c0 <mappages2>:

// global use for mappages
int
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
    return mappages(pgdir, va, size, pa, perm);
801071c3:	8b 4d 18             	mov    0x18(%ebp),%ecx
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801071c6:	8b 55 0c             	mov    0xc(%ebp),%edx
801071c9:	8b 45 08             	mov    0x8(%ebp),%eax
    return mappages(pgdir, va, size, pa, perm);
801071cc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801071cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
801071d2:	89 4d 08             	mov    %ecx,0x8(%ebp)
801071d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
801071d8:	5d                   	pop    %ebp
    return mappages(pgdir, va, size, pa, perm);
801071d9:	e9 a2 fe ff ff       	jmp    80107080 <mappages>
801071de:	66 90                	xchg   %ax,%ax

801071e0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void) {
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801071e0:	a1 e8 6c 12 80       	mov    0x80126ce8,%eax
switchkvm(void) {
801071e5:	55                   	push   %ebp
801071e6:	89 e5                	mov    %esp,%ebp
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801071e8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071ed:	0f 22 d8             	mov    %eax,%cr3
}
801071f0:	5d                   	pop    %ebp
801071f1:	c3                   	ret    
801071f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107200 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p) {
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 1c             	sub    $0x1c,%esp
80107209:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (p == 0)
8010720c:	85 db                	test   %ebx,%ebx
8010720e:	0f 84 cb 00 00 00    	je     801072df <switchuvm+0xdf>
        panic("switchuvm: no process");
    if (p->kstack == 0)
80107214:	8b 43 08             	mov    0x8(%ebx),%eax
80107217:	85 c0                	test   %eax,%eax
80107219:	0f 84 da 00 00 00    	je     801072f9 <switchuvm+0xf9>
        panic("switchuvm: no kstack");
    if (p->pgdir == 0)
8010721f:	8b 43 04             	mov    0x4(%ebx),%eax
80107222:	85 c0                	test   %eax,%eax
80107224:	0f 84 c2 00 00 00    	je     801072ec <switchuvm+0xec>
        panic("switchuvm: no pgdir");

    pushcli();
8010722a:	e8 b1 d8 ff ff       	call   80104ae0 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010722f:	e8 2c ca ff ff       	call   80103c60 <mycpu>
80107234:	89 c6                	mov    %eax,%esi
80107236:	e8 25 ca ff ff       	call   80103c60 <mycpu>
8010723b:	89 c7                	mov    %eax,%edi
8010723d:	e8 1e ca ff ff       	call   80103c60 <mycpu>
80107242:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107245:	83 c7 08             	add    $0x8,%edi
80107248:	e8 13 ca ff ff       	call   80103c60 <mycpu>
8010724d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107250:	83 c0 08             	add    $0x8,%eax
80107253:	ba 67 00 00 00       	mov    $0x67,%edx
80107258:	c1 e8 18             	shr    $0x18,%eax
8010725b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107262:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107269:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
    mycpu()->gdt[SEG_TSS].s = 0;
    mycpu()->ts.ss0 = SEG_KDATA << 3;
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    mycpu()->ts.iomb = (ushort) 0xFFFF;
8010726f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107274:	83 c1 08             	add    $0x8,%ecx
80107277:	c1 e9 10             	shr    $0x10,%ecx
8010727a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107280:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107285:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
8010728c:	be 10 00 00 00       	mov    $0x10,%esi
    mycpu()->gdt[SEG_TSS].s = 0;
80107291:	e8 ca c9 ff ff       	call   80103c60 <mycpu>
80107296:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
8010729d:	e8 be c9 ff ff       	call   80103c60 <mycpu>
801072a2:	66 89 70 10          	mov    %si,0x10(%eax)
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
801072a6:	8b 73 08             	mov    0x8(%ebx),%esi
801072a9:	e8 b2 c9 ff ff       	call   80103c60 <mycpu>
801072ae:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072b4:	89 70 0c             	mov    %esi,0xc(%eax)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
801072b7:	e8 a4 c9 ff ff       	call   80103c60 <mycpu>
801072bc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801072c0:	b8 28 00 00 00       	mov    $0x28,%eax
801072c5:	0f 00 d8             	ltr    %ax
    ltr(SEG_TSS << 3);
    lcr3(V2P(p->pgdir));  // switch to process's address space
801072c8:	8b 43 04             	mov    0x4(%ebx),%eax
801072cb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072d0:	0f 22 d8             	mov    %eax,%cr3
    popcli();
}
801072d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072d6:	5b                   	pop    %ebx
801072d7:	5e                   	pop    %esi
801072d8:	5f                   	pop    %edi
801072d9:	5d                   	pop    %ebp
    popcli();
801072da:	e9 01 d9 ff ff       	jmp    80104be0 <popcli>
        panic("switchuvm: no process");
801072df:	83 ec 0c             	sub    $0xc,%esp
801072e2:	68 7e 87 10 80       	push   $0x8010877e
801072e7:	e8 a4 90 ff ff       	call   80100390 <panic>
        panic("switchuvm: no pgdir");
801072ec:	83 ec 0c             	sub    $0xc,%esp
801072ef:	68 a9 87 10 80       	push   $0x801087a9
801072f4:	e8 97 90 ff ff       	call   80100390 <panic>
        panic("switchuvm: no kstack");
801072f9:	83 ec 0c             	sub    $0xc,%esp
801072fc:	68 94 87 10 80       	push   $0x80108794
80107301:	e8 8a 90 ff ff       	call   80100390 <panic>
80107306:	8d 76 00             	lea    0x0(%esi),%esi
80107309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107310 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz) {
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	57                   	push   %edi
80107314:	56                   	push   %esi
80107315:	53                   	push   %ebx
80107316:	83 ec 1c             	sub    $0x1c,%esp
80107319:	8b 75 10             	mov    0x10(%ebp),%esi
8010731c:	8b 45 08             	mov    0x8(%ebp),%eax
8010731f:	8b 7d 0c             	mov    0xc(%ebp),%edi
    char *mem;

    if (sz >= PGSIZE)
80107322:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
inituvm(pde_t *pgdir, char *init, uint sz) {
80107328:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE)
8010732b:	77 49                	ja     80107376 <inituvm+0x66>
        panic("inituvm: more than a page");
    mem = kalloc();
8010732d:	e8 de b5 ff ff       	call   80102910 <kalloc>
    memset(mem, 0, PGSIZE);
80107332:	83 ec 04             	sub    $0x4,%esp
    mem = kalloc();
80107335:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80107337:	68 00 10 00 00       	push   $0x1000
8010733c:	6a 00                	push   $0x0
8010733e:	50                   	push   %eax
8010733f:	e8 5c d9 ff ff       	call   80104ca0 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107344:	58                   	pop    %eax
80107345:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010734b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107350:	5a                   	pop    %edx
80107351:	6a 06                	push   $0x6
80107353:	50                   	push   %eax
80107354:	31 d2                	xor    %edx,%edx
80107356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107359:	e8 22 fd ff ff       	call   80107080 <mappages>
    memmove(mem, init, sz);
8010735e:	89 75 10             	mov    %esi,0x10(%ebp)
80107361:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107364:	83 c4 10             	add    $0x10,%esp
80107367:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010736a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010736d:	5b                   	pop    %ebx
8010736e:	5e                   	pop    %esi
8010736f:	5f                   	pop    %edi
80107370:	5d                   	pop    %ebp
    memmove(mem, init, sz);
80107371:	e9 da d9 ff ff       	jmp    80104d50 <memmove>
        panic("inituvm: more than a page");
80107376:	83 ec 0c             	sub    $0xc,%esp
80107379:	68 bd 87 10 80       	push   $0x801087bd
8010737e:	e8 0d 90 ff ff       	call   80100390 <panic>
80107383:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107390 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	53                   	push   %ebx
80107396:	83 ec 0c             	sub    $0xc,%esp
    uint i, pa, n;
    pte_t *pte;

    if ((uint) addr % PGSIZE != 0)
80107399:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801073a0:	0f 85 91 00 00 00    	jne    80107437 <loaduvm+0xa7>
        panic("loaduvm: addr must be page aligned");
    for (i = 0; i < sz; i += PGSIZE) {
801073a6:	8b 75 18             	mov    0x18(%ebp),%esi
801073a9:	31 db                	xor    %ebx,%ebx
801073ab:	85 f6                	test   %esi,%esi
801073ad:	75 1a                	jne    801073c9 <loaduvm+0x39>
801073af:	eb 6f                	jmp    80107420 <loaduvm+0x90>
801073b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073be:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801073c4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801073c7:	76 57                	jbe    80107420 <loaduvm+0x90>
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
801073c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801073cc:	8b 45 08             	mov    0x8(%ebp),%eax
801073cf:	31 c9                	xor    %ecx,%ecx
801073d1:	01 da                	add    %ebx,%edx
801073d3:	e8 28 fc ff ff       	call   80107000 <walkpgdir>
801073d8:	85 c0                	test   %eax,%eax
801073da:	74 4e                	je     8010742a <loaduvm+0x9a>
            panic("loaduvm: address should exist");
        pa = PTE_ADDR(*pte);
801073dc:	8b 00                	mov    (%eax),%eax
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, P2V(pa), offset + i, n) != n)
801073de:	8b 4d 14             	mov    0x14(%ebp),%ecx
        if (sz - i < PGSIZE)
801073e1:	bf 00 10 00 00       	mov    $0x1000,%edi
        pa = PTE_ADDR(*pte);
801073e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE)
801073eb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801073f1:	0f 46 fe             	cmovbe %esi,%edi
        if (readi(ip, P2V(pa), offset + i, n) != n)
801073f4:	01 d9                	add    %ebx,%ecx
801073f6:	05 00 00 00 80       	add    $0x80000000,%eax
801073fb:	57                   	push   %edi
801073fc:	51                   	push   %ecx
801073fd:	50                   	push   %eax
801073fe:	ff 75 10             	pushl  0x10(%ebp)
80107401:	e8 9a a5 ff ff       	call   801019a0 <readi>
80107406:	83 c4 10             	add    $0x10,%esp
80107409:	39 f8                	cmp    %edi,%eax
8010740b:	74 ab                	je     801073b8 <loaduvm+0x28>
            return -1;
    }
    return 0;
}
8010740d:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107415:	5b                   	pop    %ebx
80107416:	5e                   	pop    %esi
80107417:	5f                   	pop    %edi
80107418:	5d                   	pop    %ebp
80107419:	c3                   	ret    
8010741a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107420:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107423:	31 c0                	xor    %eax,%eax
}
80107425:	5b                   	pop    %ebx
80107426:	5e                   	pop    %esi
80107427:	5f                   	pop    %edi
80107428:	5d                   	pop    %ebp
80107429:	c3                   	ret    
            panic("loaduvm: address should exist");
8010742a:	83 ec 0c             	sub    $0xc,%esp
8010742d:	68 d7 87 10 80       	push   $0x801087d7
80107432:	e8 59 8f ff ff       	call   80100390 <panic>
        panic("loaduvm: addr must be page aligned");
80107437:	83 ec 0c             	sub    $0xc,%esp
8010743a:	68 a4 88 10 80       	push   $0x801088a4
8010743f:	e8 4c 8f ff ff       	call   80100390 <panic>
80107444:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010744a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107450 <findFreeEntryInSwapFile>:

int
findFreeEntryInSwapFile(struct proc *p) {
80107450:	55                   	push   %ebp
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80107451:	31 c0                	xor    %eax,%eax
findFreeEntryInSwapFile(struct proc *p) {
80107453:	89 e5                	mov    %esp,%ebp
80107455:	8b 55 08             	mov    0x8(%ebp),%edx
80107458:	eb 0e                	jmp    80107468 <findFreeEntryInSwapFile+0x18>
8010745a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80107460:	83 c0 01             	add    $0x1,%eax
80107463:	83 f8 10             	cmp    $0x10,%eax
80107466:	74 10                	je     80107478 <findFreeEntryInSwapFile+0x28>
        if (!p->swapFileEntries[i])
80107468:	8b 8c 82 00 04 00 00 	mov    0x400(%edx,%eax,4),%ecx
8010746f:	85 c9                	test   %ecx,%ecx
80107471:	75 ed                	jne    80107460 <findFreeEntryInSwapFile+0x10>
            return i;
    }
    return -1;
}
80107473:	5d                   	pop    %ebp
80107474:	c3                   	ret    
80107475:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107478:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010747d:	5d                   	pop    %ebp
8010747e:	c3                   	ret    
8010747f:	90                   	nop

80107480 <swapOutPage>:


void
swapOutPage(struct proc *p, pde_t *pgdir) {
80107480:	55                   	push   %ebp
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80107481:	31 c0                	xor    %eax,%eax
swapOutPage(struct proc *p, pde_t *pgdir) {
80107483:	89 e5                	mov    %esp,%ebp
80107485:	57                   	push   %edi
80107486:	56                   	push   %esi
80107487:	53                   	push   %ebx
80107488:	83 ec 1c             	sub    $0x1c,%esp
8010748b:	8b 75 08             	mov    0x8(%ebp),%esi
8010748e:	eb 0c                	jmp    8010749c <swapOutPage+0x1c>
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80107490:	83 c0 01             	add    $0x1,%eax
80107493:	83 f8 10             	cmp    $0x10,%eax
80107496:	0f 84 34 01 00 00    	je     801075d0 <swapOutPage+0x150>
        if (!p->swapFileEntries[i])
8010749c:	8b 94 86 00 04 00 00 	mov    0x400(%esi,%eax,4),%edx
801074a3:	85 d2                	test   %edx,%edx
801074a5:	75 e9                	jne    80107490 <swapOutPage+0x10>
801074a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
        }
        panic("ERROR - there is no free entry in p->swapFileEntries!\n");

    }

    int swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
801074aa:	c1 e0 0c             	shl    $0xc,%eax

//#if( defined(LIFO))
    int maxSeq = 0;
    struct page *cg;
    for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
801074ad:	8d 9e 00 04 00 00    	lea    0x400(%esi),%ebx
    int swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
801074b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
801074b6:	8d 86 80 00 00 00    	lea    0x80(%esi),%eax
    struct page *pg = 0;
801074bc:	31 ff                	xor    %edi,%edi
    for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
801074be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (cg->active && cg->present && cg->sequel > maxSeq) {
801074c8:	8b 08                	mov    (%eax),%ecx
801074ca:	85 c9                	test   %ecx,%ecx
801074cc:	74 12                	je     801074e0 <swapOutPage+0x60>
801074ce:	8b 48 0c             	mov    0xc(%eax),%ecx
801074d1:	85 c9                	test   %ecx,%ecx
801074d3:	74 0b                	je     801074e0 <swapOutPage+0x60>
801074d5:	8b 48 08             	mov    0x8(%eax),%ecx
801074d8:	39 d1                	cmp    %edx,%ecx
801074da:	7e 04                	jle    801074e0 <swapOutPage+0x60>
801074dc:	89 ca                	mov    %ecx,%edx
801074de:	89 c7                	mov    %eax,%edi
    for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
801074e0:	83 c0 1c             	add    $0x1c,%eax
801074e3:	39 d8                	cmp    %ebx,%eax
801074e5:	72 e1                	jb     801074c8 <swapOutPage+0x48>

//#endif


//#if( defined(SCFIFO))
    int minSeq = p->pagesequel , found = 0;
801074e7:	8b 86 4c 04 00 00    	mov    0x44c(%esi),%eax
801074ed:	89 75 08             	mov    %esi,0x8(%ebp)
801074f0:	89 c6                	mov    %eax,%esi
    char *tmpAdress;
    struct page *sg;
    while( !found ) {
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
801074f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074f5:	8d 76 00             	lea    0x0(%esi),%esi
            if (sg->active && sg->present && sg->sequel < minSeq) {
801074f8:	8b 08                	mov    (%eax),%ecx
801074fa:	85 c9                	test   %ecx,%ecx
801074fc:	74 12                	je     80107510 <swapOutPage+0x90>
801074fe:	8b 50 0c             	mov    0xc(%eax),%edx
80107501:	85 d2                	test   %edx,%edx
80107503:	74 0b                	je     80107510 <swapOutPage+0x90>
80107505:	8b 50 08             	mov    0x8(%eax),%edx
80107508:	39 f2                	cmp    %esi,%edx
8010750a:	7d 04                	jge    80107510 <swapOutPage+0x90>
8010750c:	89 d6                	mov    %edx,%esi
8010750e:	89 c7                	mov    %eax,%edi
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
80107510:	83 c0 1c             	add    $0x1c,%eax
80107513:	39 d8                	cmp    %ebx,%eax
80107515:	72 e1                	jb     801074f8 <swapOutPage+0x78>
                minSeq = sg->sequel;
            }
        }

        tmpAdress = pg->virtAdress;
        tmppgtble = walkpgdir(pgdir, (char *) tmpAdress, 0);
80107517:	8b 57 18             	mov    0x18(%edi),%edx
8010751a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010751d:	31 c9                	xor    %ecx,%ecx
8010751f:	e8 dc fa ff ff       	call   80107000 <walkpgdir>
        if (*tmppgtble & PTE_A) {
80107524:	8b 10                	mov    (%eax),%edx
80107526:	f6 c2 20             	test   $0x20,%dl
80107529:	74 c7                	je     801074f2 <swapOutPage+0x72>
8010752b:	8b 75 08             	mov    0x8(%ebp),%esi
            *tmppgtble = PTE_A_0(*tmppgtble);
8010752e:	83 e2 df             	and    $0xffffffdf,%edx
    }

//#endif

    //write the page to swapFile
    writeToSwapFile(p, pg->physAdress, (uint) swapWriteOffset, PGSIZE);
80107531:	8b 5d e0             	mov    -0x20(%ebp),%ebx
            *tmppgtble = PTE_A_0(*tmppgtble);
80107534:	89 10                	mov    %edx,(%eax)
            pg->sequel = p->pagesequel++;
80107536:	8b 86 4c 04 00 00    	mov    0x44c(%esi),%eax
8010753c:	8d 50 01             	lea    0x1(%eax),%edx
8010753f:	89 96 4c 04 00 00    	mov    %edx,0x44c(%esi)
80107545:	89 47 08             	mov    %eax,0x8(%edi)
    writeToSwapFile(p, pg->physAdress, (uint) swapWriteOffset, PGSIZE);
80107548:	68 00 10 00 00       	push   $0x1000
8010754d:	53                   	push   %ebx
8010754e:	ff 77 14             	pushl  0x14(%edi)
80107551:	56                   	push   %esi
80107552:	e8 39 ad ff ff       	call   80102290 <writeToSwapFile>
    pg->physAdress = 0;
    pg->sequel = 0;

    //must update page swaping for proc.

    p->swapFileEntries[tmpOffset] = 1; //update that this entry is swapped out
80107557:	8b 45 dc             	mov    -0x24(%ebp),%eax
    pg->present = 0;
8010755a:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    p->totalPagesInSwap++;
    p->pagesinSwap++;

    //update pte
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
80107561:	31 c9                	xor    %ecx,%ecx
    pg->offset = (uint) swapWriteOffset;
80107563:	89 5f 10             	mov    %ebx,0x10(%edi)
    pg->physAdress = 0;
80107566:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    pg->sequel = 0;
8010756d:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    p->swapFileEntries[tmpOffset] = 1; //update that this entry is swapped out
80107574:	c7 84 86 00 04 00 00 	movl   $0x1,0x400(%esi,%eax,4)
8010757b:	01 00 00 00 
    p->totalPagesInSwap++;
8010757f:	83 86 58 04 00 00 01 	addl   $0x1,0x458(%esi)
    p->pagesinSwap++;
80107586:	83 86 48 04 00 00 01 	addl   $0x1,0x448(%esi)
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
8010758d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107590:	8b 57 18             	mov    0x18(%edi),%edx
80107593:	e8 68 fa ff ff       	call   80107000 <walkpgdir>
    *pgtble = PTE_P_0(*pgtble);
80107598:	8b 10                	mov    (%eax),%edx
8010759a:	89 d1                	mov    %edx,%ecx
    *pgtble = PTE_PG_1(*pgtble);
    kfree(P2V(PTE_ADDR(*pgtble)));
8010759c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    *pgtble = PTE_P_0(*pgtble);
801075a2:	83 e1 fe             	and    $0xfffffffe,%ecx
    kfree(P2V(PTE_ADDR(*pgtble)));
801075a5:	81 c2 00 00 00 80    	add    $0x80000000,%edx
    *pgtble = PTE_PG_1(*pgtble);
801075ab:	80 cd 02             	or     $0x2,%ch
801075ae:	89 08                	mov    %ecx,(%eax)
    kfree(P2V(PTE_ADDR(*pgtble)));
801075b0:	89 14 24             	mov    %edx,(%esp)
801075b3:	e8 a8 b1 ff ff       	call   80102760 <kfree>
    lcr3(V2P(p->pgdir));
801075b8:	8b 46 04             	mov    0x4(%esi),%eax
801075bb:	05 00 00 00 80       	add    $0x80000000,%eax
801075c0:	0f 22 d8             	mov    %eax,%cr3
}
801075c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075c6:	5b                   	pop    %ebx
801075c7:	5e                   	pop    %esi
801075c8:	5f                   	pop    %edi
801075c9:	5d                   	pop    %ebp
801075ca:	c3                   	ret    
801075cb:	90                   	nop
801075cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("p->entries:\t");
801075d0:	83 ec 0c             	sub    $0xc,%esp
801075d3:	8d 9e 00 04 00 00    	lea    0x400(%esi),%ebx
801075d9:	81 c6 40 04 00 00    	add    $0x440,%esi
801075df:	68 fa 87 10 80       	push   $0x801087fa
801075e4:	e8 77 90 ff ff       	call   80100660 <cprintf>
801075e9:	83 c4 10             	add    $0x10,%esp
            cprintf("%d  ",p->swapFileEntries[i]);
801075ec:	83 ec 08             	sub    $0x8,%esp
801075ef:	ff 33                	pushl  (%ebx)
801075f1:	83 c3 04             	add    $0x4,%ebx
801075f4:	68 f5 87 10 80       	push   $0x801087f5
801075f9:	e8 62 90 ff ff       	call   80100660 <cprintf>
        for (int i = 0; i < MAX_PSYC_PAGES; i++){
801075fe:	83 c4 10             	add    $0x10,%esp
80107601:	39 f3                	cmp    %esi,%ebx
80107603:	75 e7                	jne    801075ec <swapOutPage+0x16c>
        panic("ERROR - there is no free entry in p->swapFileEntries!\n");
80107605:	83 ec 0c             	sub    $0xc,%esp
80107608:	68 c8 88 10 80       	push   $0x801088c8
8010760d:	e8 7e 8d ff ff       	call   80100390 <panic>
80107612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107620 <deallocuvm>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int growproc) {
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
80107626:	83 ec 1c             	sub    $0x1c,%esp
80107629:	8b 75 0c             	mov    0xc(%ebp),%esi
    if (DEBUGMODE == 2 && notShell())
        cprintf("DEALLOCUVM-");
    pte_t *pte;
    uint a, pa;
    struct page *pg;
    struct proc *p = myproc();
8010762c:	e8 cf c6 ff ff       	call   80103d00 <myproc>

    if (newsz >= oldsz) {
80107631:	39 75 10             	cmp    %esi,0x10(%ebp)
80107634:	0f 83 5e 01 00 00    	jae    80107798 <deallocuvm+0x178>
8010763a:	89 c7                	mov    %eax,%edi
        if (DEBUGMODE == 2 && notShell())
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
8010763c:	8b 45 10             	mov    0x10(%ebp),%eax
8010763f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107645:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; a < oldsz; a += PGSIZE) {
8010764b:	39 de                	cmp    %ebx,%esi
8010764d:	0f 86 df 00 00 00    	jbe    80107732 <deallocuvm+0x112>
            pa = PTE_ADDR(*pte);
            if (pa == 0)
                panic("kfree");
            if (p->pid > 2 && growproc) {
                //scan pages table and remove page that page.virtAdress == a
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107653:	8d 87 00 04 00 00    	lea    0x400(%edi),%eax
80107659:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010765c:	eb 4b                	jmp    801076a9 <deallocuvm+0x89>
8010765e:	66 90                	xchg   %ax,%ax
            if (pa == 0)
80107660:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107666:	0f 84 63 01 00 00    	je     801077cf <deallocuvm+0x1af>
            if (p->pid > 2 && growproc) {
8010766c:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107670:	7e 0b                	jle    8010767d <deallocuvm+0x5d>
80107672:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107675:	85 c9                	test   %ecx,%ecx
80107677:	0f 85 db 00 00 00    	jne    80107758 <deallocuvm+0x138>
            kfree(v);
8010767d:	83 ec 0c             	sub    $0xc,%esp
            char *v = P2V(pa);
80107680:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107686:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            kfree(v);
80107689:	52                   	push   %edx
8010768a:	e8 d1 b0 ff ff       	call   80102760 <kfree>
            *pte = 0;
8010768f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107692:	83 c4 10             	add    $0x10,%esp
80107695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; a < oldsz; a += PGSIZE) {
8010769b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076a1:	39 de                	cmp    %ebx,%esi
801076a3:	0f 86 89 00 00 00    	jbe    80107732 <deallocuvm+0x112>
        pte = walkpgdir(pgdir, (char *) a, 0);
801076a9:	8b 45 08             	mov    0x8(%ebp),%eax
801076ac:	31 c9                	xor    %ecx,%ecx
801076ae:	89 da                	mov    %ebx,%edx
801076b0:	e8 4b f9 ff ff       	call   80107000 <walkpgdir>
        if (!pte)
801076b5:	85 c0                	test   %eax,%eax
801076b7:	0f 84 83 00 00 00    	je     80107740 <deallocuvm+0x120>
        else if ((*pte & PTE_P) != 0) {
801076bd:	8b 10                	mov    (%eax),%edx
801076bf:	f6 c2 01             	test   $0x1,%dl
801076c2:	75 9c                	jne    80107660 <deallocuvm+0x40>
        } else if ((*pte & PTE_PG) != 0) {
801076c4:	f6 c6 02             	test   $0x2,%dh
801076c7:	74 d2                	je     8010769b <deallocuvm+0x7b>
            if (pa == 0)
801076c9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801076cf:	0f 84 fa 00 00 00    	je     801077cf <deallocuvm+0x1af>
            if (p->pid > 2 && growproc) {
801076d5:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
801076d9:	7e c0                	jle    8010769b <deallocuvm+0x7b>
801076db:	8b 45 14             	mov    0x14(%ebp),%eax
801076de:	85 c0                	test   %eax,%eax
801076e0:	74 b9                	je     8010769b <deallocuvm+0x7b>
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801076e2:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
801076e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801076eb:	eb 0a                	jmp    801076f7 <deallocuvm+0xd7>
801076ed:	8d 76 00             	lea    0x0(%esi),%esi
801076f0:	83 c0 1c             	add    $0x1c,%eax
801076f3:	39 d0                	cmp    %edx,%eax
801076f5:	73 a4                	jae    8010769b <deallocuvm+0x7b>
                    if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
801076f7:	8b 08                	mov    (%eax),%ecx
801076f9:	85 c9                	test   %ecx,%ecx
801076fb:	74 f3                	je     801076f0 <deallocuvm+0xd0>
801076fd:	3b 58 18             	cmp    0x18(%eax),%ebx
80107700:	75 ee                	jne    801076f0 <deallocuvm+0xd0>
    for (; a < oldsz; a += PGSIZE) {
80107702:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                    {
                        //remove page
                        pg->virtAdress = 0;
80107708:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
                        pg->active = 0;
8010770f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                        pg->offset = 0;      //TODO - check if there is a need to save offset
80107715:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                        pg->present = 0;
8010771c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

                        //update proc
                        p->pagesCounter--;
80107723:	83 af 44 04 00 00 01 	subl   $0x1,0x444(%edi)
    for (; a < oldsz; a += PGSIZE) {
8010772a:	39 de                	cmp    %ebx,%esi
8010772c:	0f 87 77 ff ff ff    	ja     801076a9 <deallocuvm+0x89>
            }
        }
    }
    if (DEBUGMODE == 2 && notShell())
        cprintf(">DEALLOCUVM-DONE!\t");
    return newsz;
80107732:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107735:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107738:	5b                   	pop    %ebx
80107739:	5e                   	pop    %esi
8010773a:	5f                   	pop    %edi
8010773b:	5d                   	pop    %ebp
8010773c:	c3                   	ret    
8010773d:	8d 76 00             	lea    0x0(%esi),%esi
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107740:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107746:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
8010774c:	e9 4a ff ff ff       	jmp    8010769b <deallocuvm+0x7b>
80107751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107758:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010775b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010775e:	8d 8f 80 00 00 00    	lea    0x80(%edi),%ecx
80107764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
80107768:	83 39 00             	cmpl   $0x0,(%ecx)
8010776b:	74 05                	je     80107772 <deallocuvm+0x152>
8010776d:	3b 59 18             	cmp    0x18(%ecx),%ebx
80107770:	74 36                	je     801077a8 <deallocuvm+0x188>
                for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107772:	83 c1 1c             	add    $0x1c,%ecx
80107775:	39 c1                	cmp    %eax,%ecx
80107777:	72 ef                	jb     80107768 <deallocuvm+0x148>
80107779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
                if (pg == &p->pages[MAX_TOTAL_PAGES])//if true ->didn't find the virtAdress
8010777c:	39 4d e0             	cmp    %ecx,-0x20(%ebp)
8010777f:	0f 85 f8 fe ff ff    	jne    8010767d <deallocuvm+0x5d>
                    panic("deallocuvm Error - didn't find the virtAdress!");
80107785:	83 ec 0c             	sub    $0xc,%esp
80107788:	68 00 89 10 80       	push   $0x80108900
8010778d:	e8 fe 8b ff ff       	call   80100390 <panic>
80107792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107798:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return oldsz;
8010779b:	89 f0                	mov    %esi,%eax
}
8010779d:	5b                   	pop    %ebx
8010779e:	5e                   	pop    %esi
8010779f:	5f                   	pop    %edi
801077a0:	5d                   	pop    %ebp
801077a1:	c3                   	ret    
801077a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                        pg->virtAdress = 0;
801077a8:	c7 41 18 00 00 00 00 	movl   $0x0,0x18(%ecx)
                        pg->active = 0;
801077af:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
                        pg->offset = 0;      //TODO - check if there is a need to save offset
801077b5:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
                        pg->present = 0;
801077bc:	c7 41 0c 00 00 00 00 	movl   $0x0,0xc(%ecx)
801077c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
                        p->pagesCounter--;
801077c6:	83 af 44 04 00 00 01 	subl   $0x1,0x444(%edi)
                        break;
801077cd:	eb ad                	jmp    8010777c <deallocuvm+0x15c>
                panic("kfree");
801077cf:	83 ec 0c             	sub    $0xc,%esp
801077d2:	68 ea 7f 10 80       	push   $0x80107fea
801077d7:	e8 b4 8b ff ff       	call   80100390 <panic>
801077dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077e0 <allocuvm>:
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
801077e5:	53                   	push   %ebx
801077e6:	83 ec 28             	sub    $0x28,%esp
    cprintf("FUCKYOU1");
801077e9:	68 07 88 10 80       	push   $0x80108807
801077ee:	e8 6d 8e ff ff       	call   80100660 <cprintf>
    struct proc *p = myproc();
801077f3:	e8 08 c5 ff ff       	call   80103d00 <myproc>
801077f8:	89 c3                	mov    %eax,%ebx
    if (newsz >= KERNBASE) {
801077fa:	8b 45 10             	mov    0x10(%ebp),%eax
801077fd:	83 c4 10             	add    $0x10,%esp
80107800:	85 c0                	test   %eax,%eax
80107802:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107805:	0f 88 b5 01 00 00    	js     801079c0 <allocuvm+0x1e0>
    if (newsz < oldsz) {
8010780b:	3b 45 0c             	cmp    0xc(%ebp),%eax
        return oldsz;
8010780e:	8b 45 0c             	mov    0xc(%ebp),%eax
    if (newsz < oldsz) {
80107811:	0f 82 49 01 00 00    	jb     80107960 <allocuvm+0x180>
    a = PGROUNDUP(oldsz);
80107817:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010781d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    for (; a < newsz; a += PGSIZE) {
80107823:	39 75 10             	cmp    %esi,0x10(%ebp)
80107826:	0f 86 37 01 00 00    	jbe    80107963 <allocuvm+0x183>
        if (p->pagesCounter == MAX_TOTAL_PAGES)
8010782c:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
80107832:	83 f8 20             	cmp    $0x20,%eax
80107835:	0f 84 df 01 00 00    	je     80107a1a <allocuvm+0x23a>
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
8010783b:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
80107841:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80107844:	eb 28                	jmp    8010786e <allocuvm+0x8e>
80107846:	8d 76 00             	lea    0x0(%esi),%esi
80107849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for (; a < newsz; a += PGSIZE) {
80107850:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107856:	39 75 10             	cmp    %esi,0x10(%ebp)
80107859:	0f 86 04 01 00 00    	jbe    80107963 <allocuvm+0x183>
        if (p->pagesCounter == MAX_TOTAL_PAGES)
8010785f:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
80107865:	83 f8 20             	cmp    $0x20,%eax
80107868:	0f 84 ac 01 00 00    	je     80107a1a <allocuvm+0x23a>
        if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2) {
8010786e:	2b 83 48 04 00 00    	sub    0x448(%ebx),%eax
80107874:	83 f8 0f             	cmp    $0xf,%eax
80107877:	7e 0a                	jle    80107883 <allocuvm+0xa3>
80107879:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
8010787d:	0f 8f ed 00 00 00    	jg     80107970 <allocuvm+0x190>
        mem = kalloc();
80107883:	e8 88 b0 ff ff       	call   80102910 <kalloc>
        if (mem == 0) {
80107888:	85 c0                	test   %eax,%eax
        mem = kalloc();
8010788a:	89 c7                	mov    %eax,%edi
        if (mem == 0) {
8010788c:	0f 84 fc 00 00 00    	je     8010798e <allocuvm+0x1ae>
        memset(mem, 0, PGSIZE);
80107892:	83 ec 04             	sub    $0x4,%esp
80107895:	68 00 10 00 00       	push   $0x1000
8010789a:	6a 00                	push   $0x0
8010789c:	50                   	push   %eax
8010789d:	e8 fe d3 ff ff       	call   80104ca0 <memset>
        if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
801078a2:	59                   	pop    %ecx
801078a3:	58                   	pop    %eax
801078a4:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801078aa:	6a 06                	push   $0x6
801078ac:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078b1:	89 f2                	mov    %esi,%edx
801078b3:	50                   	push   %eax
801078b4:	8b 45 08             	mov    0x8(%ebp),%eax
801078b7:	e8 c4 f7 ff ff       	call   80107080 <mappages>
801078bc:	83 c4 10             	add    $0x10,%esp
801078bf:	85 c0                	test   %eax,%eax
801078c1:	0f 88 0b 01 00 00    	js     801079d2 <allocuvm+0x1f2>
        if (p->pid > 2) {
801078c7:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801078cb:	7e 83                	jle    80107850 <allocuvm+0x70>
                if (!pg->active)
801078cd:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801078d3:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
                if (!pg->active)
801078d9:	85 d2                	test   %edx,%edx
801078db:	74 14                	je     801078f1 <allocuvm+0x111>
801078dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801078e0:	83 c0 1c             	add    $0x1c,%eax
801078e3:	39 d0                	cmp    %edx,%eax
801078e5:	0f 83 22 01 00 00    	jae    80107a0d <allocuvm+0x22d>
                if (!pg->active)
801078eb:	8b 08                	mov    (%eax),%ecx
801078ed:	85 c9                	test   %ecx,%ecx
801078ef:	75 ef                	jne    801078e0 <allocuvm+0x100>
            p->pagesCounter++;
801078f1:	83 83 44 04 00 00 01 	addl   $0x1,0x444(%ebx)
            pg->active = 1;
801078f8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
            pg->pageid = p->nextpageid++;
801078fe:	8b 93 40 04 00 00    	mov    0x440(%ebx),%edx
80107904:	8d 4a 01             	lea    0x1(%edx),%ecx
80107907:	89 8b 40 04 00 00    	mov    %ecx,0x440(%ebx)
8010790d:	89 50 04             	mov    %edx,0x4(%eax)
            pg->present = 1;
80107910:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
            pg->offset = 0;
80107917:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
            pg->sequel = p->pagesequel++;
8010791e:	8b 93 4c 04 00 00    	mov    0x44c(%ebx),%edx
80107924:	8d 4a 01             	lea    0x1(%edx),%ecx
80107927:	89 8b 4c 04 00 00    	mov    %ecx,0x44c(%ebx)
8010792d:	89 50 08             	mov    %edx,0x8(%eax)
            pgtble = walkpgdir(pgdir, (char *) a, 0);
80107930:	31 c9                	xor    %ecx,%ecx
            pg->physAdress = mem;
80107932:	89 78 14             	mov    %edi,0x14(%eax)
            pg->virtAdress = (char *) a;
80107935:	89 70 18             	mov    %esi,0x18(%eax)
            pgtble = walkpgdir(pgdir, (char *) a, 0);
80107938:	89 f2                	mov    %esi,%edx
8010793a:	8b 45 08             	mov    0x8(%ebp),%eax
8010793d:	e8 be f6 ff ff       	call   80107000 <walkpgdir>
            *pgtble = PTE_PG_0(*pgtble); // Not Paged out to secondary storage
80107942:	8b 10                	mov    (%eax),%edx
80107944:	80 e6 fd             	and    $0xfd,%dh
80107947:	83 ca 01             	or     $0x1,%edx
8010794a:	89 10                	mov    %edx,(%eax)
            lcr3(V2P(p->pgdir));
8010794c:	8b 43 04             	mov    0x4(%ebx),%eax
8010794f:	05 00 00 00 80       	add    $0x80000000,%eax
80107954:	0f 22 d8             	mov    %eax,%cr3
80107957:	e9 f4 fe ff ff       	jmp    80107850 <allocuvm+0x70>
8010795c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return oldsz;
80107960:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107966:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107969:	5b                   	pop    %ebx
8010796a:	5e                   	pop    %esi
8010796b:	5f                   	pop    %edi
8010796c:	5d                   	pop    %ebp
8010796d:	c3                   	ret    
8010796e:	66 90                	xchg   %ax,%ax
            swapOutPage(p, pgdir); //this func includes remove page, update proc and update PTE
80107970:	83 ec 08             	sub    $0x8,%esp
80107973:	ff 75 08             	pushl  0x8(%ebp)
80107976:	53                   	push   %ebx
80107977:	e8 04 fb ff ff       	call   80107480 <swapOutPage>
8010797c:	83 c4 10             	add    $0x10,%esp
        mem = kalloc();
8010797f:	e8 8c af ff ff       	call   80102910 <kalloc>
        if (mem == 0) {
80107984:	85 c0                	test   %eax,%eax
        mem = kalloc();
80107986:	89 c7                	mov    %eax,%edi
        if (mem == 0) {
80107988:	0f 85 04 ff ff ff    	jne    80107892 <allocuvm+0xb2>
            cprintf("allocuvm out of memory\n");
8010798e:	83 ec 0c             	sub    $0xc,%esp
80107991:	68 10 88 10 80       	push   $0x80108810
80107996:	e8 c5 8c ff ff       	call   80100660 <cprintf>
            deallocuvm(pgdir, newsz, oldsz, 0);
8010799b:	6a 00                	push   $0x0
8010799d:	ff 75 0c             	pushl  0xc(%ebp)
801079a0:	ff 75 10             	pushl  0x10(%ebp)
801079a3:	ff 75 08             	pushl  0x8(%ebp)
801079a6:	e8 75 fc ff ff       	call   80107620 <deallocuvm>
            return 0;
801079ab:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801079b2:	83 c4 20             	add    $0x20,%esp
}
801079b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079bb:	5b                   	pop    %ebx
801079bc:	5e                   	pop    %esi
801079bd:	5f                   	pop    %edi
801079be:	5d                   	pop    %ebp
801079bf:	c3                   	ret    
        return 0;
801079c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801079c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079cd:	5b                   	pop    %ebx
801079ce:	5e                   	pop    %esi
801079cf:	5f                   	pop    %edi
801079d0:	5d                   	pop    %ebp
801079d1:	c3                   	ret    
            cprintf("allocuvm out of memory (2)\n");
801079d2:	83 ec 0c             	sub    $0xc,%esp
801079d5:	68 28 88 10 80       	push   $0x80108828
801079da:	e8 81 8c ff ff       	call   80100660 <cprintf>
            deallocuvm(pgdir, newsz, oldsz, 0);
801079df:	6a 00                	push   $0x0
801079e1:	ff 75 0c             	pushl  0xc(%ebp)
801079e4:	ff 75 10             	pushl  0x10(%ebp)
801079e7:	ff 75 08             	pushl  0x8(%ebp)
801079ea:	e8 31 fc ff ff       	call   80107620 <deallocuvm>
            kfree(mem);
801079ef:	83 c4 14             	add    $0x14,%esp
801079f2:	57                   	push   %edi
801079f3:	e8 68 ad ff ff       	call   80102760 <kfree>
            return 0;
801079f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801079ff:	83 c4 10             	add    $0x10,%esp
}
80107a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a08:	5b                   	pop    %ebx
80107a09:	5e                   	pop    %esi
80107a0a:	5f                   	pop    %edi
80107a0b:	5d                   	pop    %ebp
80107a0c:	c3                   	ret    
            panic("no page in proc");
80107a0d:	83 ec 0c             	sub    $0xc,%esp
80107a10:	68 44 88 10 80       	push   $0x80108844
80107a15:	e8 76 89 ff ff       	call   80100390 <panic>
            panic("got 32 pages and requested for another page!");
80107a1a:	83 ec 0c             	sub    $0xc,%esp
80107a1d:	68 30 89 10 80       	push   $0x80108930
80107a22:	e8 69 89 ff ff       	call   80100390 <panic>
80107a27:	89 f6                	mov    %esi,%esi
80107a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir) {
80107a30:	55                   	push   %ebp
80107a31:	89 e5                	mov    %esp,%ebp
80107a33:	57                   	push   %edi
80107a34:	56                   	push   %esi
80107a35:	53                   	push   %ebx
80107a36:	83 ec 0c             	sub    $0xc,%esp
80107a39:	8b 75 08             	mov    0x8(%ebp),%esi
    if (DEBUGMODE == 2 && notShell())
        cprintf("FREEVM");
    uint i;

    if (pgdir == 0)
80107a3c:	85 f6                	test   %esi,%esi
80107a3e:	74 59                	je     80107a99 <freevm+0x69>
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0, 0);
80107a40:	6a 00                	push   $0x0
80107a42:	6a 00                	push   $0x0
80107a44:	89 f3                	mov    %esi,%ebx
80107a46:	68 00 00 00 80       	push   $0x80000000
80107a4b:	56                   	push   %esi
80107a4c:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107a52:	e8 c9 fb ff ff       	call   80107620 <deallocuvm>
80107a57:	83 c4 10             	add    $0x10,%esp
80107a5a:	eb 0b                	jmp    80107a67 <freevm+0x37>
80107a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a60:	83 c3 04             	add    $0x4,%ebx
    for (i = 0; i < NPDENTRIES; i++) {
80107a63:	39 fb                	cmp    %edi,%ebx
80107a65:	74 23                	je     80107a8a <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
80107a67:	8b 03                	mov    (%ebx),%eax
80107a69:	a8 01                	test   $0x1,%al
80107a6b:	74 f3                	je     80107a60 <freevm+0x30>
            char *v = P2V(PTE_ADDR(pgdir[i]));
80107a6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(v);
80107a72:	83 ec 0c             	sub    $0xc,%esp
80107a75:	83 c3 04             	add    $0x4,%ebx
            char *v = P2V(PTE_ADDR(pgdir[i]));
80107a78:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(v);
80107a7d:	50                   	push   %eax
80107a7e:	e8 dd ac ff ff       	call   80102760 <kfree>
80107a83:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80107a86:	39 fb                	cmp    %edi,%ebx
80107a88:	75 dd                	jne    80107a67 <freevm+0x37>
        }
    }
    kfree((char *) pgdir);
80107a8a:	89 75 08             	mov    %esi,0x8(%ebp)
    if (DEBUGMODE == 2 && notShell())
        cprintf(">FREEVM-DONE!\t");
}
80107a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a90:	5b                   	pop    %ebx
80107a91:	5e                   	pop    %esi
80107a92:	5f                   	pop    %edi
80107a93:	5d                   	pop    %ebp
    kfree((char *) pgdir);
80107a94:	e9 c7 ac ff ff       	jmp    80102760 <kfree>
        panic("freevm: no pgdir");
80107a99:	83 ec 0c             	sub    $0xc,%esp
80107a9c:	68 54 88 10 80       	push   $0x80108854
80107aa1:	e8 ea 88 ff ff       	call   80100390 <panic>
80107aa6:	8d 76 00             	lea    0x0(%esi),%esi
80107aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ab0 <setupkvm>:
setupkvm(void) {
80107ab0:	55                   	push   %ebp
80107ab1:	89 e5                	mov    %esp,%ebp
80107ab3:	56                   	push   %esi
80107ab4:	53                   	push   %ebx
    if ((pgdir = (pde_t *) kalloc()) == 0)
80107ab5:	e8 56 ae ff ff       	call   80102910 <kalloc>
80107aba:	85 c0                	test   %eax,%eax
80107abc:	89 c6                	mov    %eax,%esi
80107abe:	74 42                	je     80107b02 <setupkvm+0x52>
    memset(pgdir, 0, PGSIZE);
80107ac0:	83 ec 04             	sub    $0x4,%esp
    for (k = kmap; k < &kmap[NELEM(kmap)];
80107ac3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
    memset(pgdir, 0, PGSIZE);
80107ac8:	68 00 10 00 00       	push   $0x1000
80107acd:	6a 00                	push   $0x0
80107acf:	50                   	push   %eax
80107ad0:	e8 cb d1 ff ff       	call   80104ca0 <memset>
80107ad5:	83 c4 10             	add    $0x10,%esp
                 (uint) k->phys_start, k->perm) < 0) {
80107ad8:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107adb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107ade:	83 ec 08             	sub    $0x8,%esp
80107ae1:	8b 13                	mov    (%ebx),%edx
80107ae3:	ff 73 0c             	pushl  0xc(%ebx)
80107ae6:	50                   	push   %eax
80107ae7:	29 c1                	sub    %eax,%ecx
80107ae9:	89 f0                	mov    %esi,%eax
80107aeb:	e8 90 f5 ff ff       	call   80107080 <mappages>
80107af0:	83 c4 10             	add    $0x10,%esp
80107af3:	85 c0                	test   %eax,%eax
80107af5:	78 19                	js     80107b10 <setupkvm+0x60>
    k++)
80107af7:	83 c3 10             	add    $0x10,%ebx
    for (k = kmap; k < &kmap[NELEM(kmap)];
80107afa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107b00:	75 d6                	jne    80107ad8 <setupkvm+0x28>
}
80107b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b05:	89 f0                	mov    %esi,%eax
80107b07:	5b                   	pop    %ebx
80107b08:	5e                   	pop    %esi
80107b09:	5d                   	pop    %ebp
80107b0a:	c3                   	ret    
80107b0b:	90                   	nop
80107b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        freevm(pgdir);
80107b10:	83 ec 0c             	sub    $0xc,%esp
80107b13:	56                   	push   %esi
        return 0;
80107b14:	31 f6                	xor    %esi,%esi
        freevm(pgdir);
80107b16:	e8 15 ff ff ff       	call   80107a30 <freevm>
        return 0;
80107b1b:	83 c4 10             	add    $0x10,%esp
}
80107b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b21:	89 f0                	mov    %esi,%eax
80107b23:	5b                   	pop    %ebx
80107b24:	5e                   	pop    %esi
80107b25:	5d                   	pop    %ebp
80107b26:	c3                   	ret    
80107b27:	89 f6                	mov    %esi,%esi
80107b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b30 <kvmalloc>:
kvmalloc(void) {
80107b30:	55                   	push   %ebp
80107b31:	89 e5                	mov    %esp,%ebp
80107b33:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
80107b36:	e8 75 ff ff ff       	call   80107ab0 <setupkvm>
80107b3b:	a3 e8 6c 12 80       	mov    %eax,0x80126ce8
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b40:	05 00 00 00 80       	add    $0x80000000,%eax
80107b45:	0f 22 d8             	mov    %eax,%cr3
}
80107b48:	c9                   	leave  
80107b49:	c3                   	ret    
80107b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva) {
80107b50:	55                   	push   %ebp
    if (DEBUGMODE == 2 && notShell())
        cprintf("CLEARPTEU-");
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80107b51:	31 c9                	xor    %ecx,%ecx
clearpteu(pde_t *pgdir, char *uva) {
80107b53:	89 e5                	mov    %esp,%ebp
80107b55:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
80107b58:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107b5e:	e8 9d f4 ff ff       	call   80107000 <walkpgdir>
    if (pte == 0)
80107b63:	85 c0                	test   %eax,%eax
80107b65:	74 05                	je     80107b6c <clearpteu+0x1c>
        panic("clearpteu");
    *pte &= ~PTE_U;
80107b67:	83 20 fb             	andl   $0xfffffffb,(%eax)
    if (DEBUGMODE == 2 && notShell())
        cprintf(">CLEARPTEU-DONE!\t");
}
80107b6a:	c9                   	leave  
80107b6b:	c3                   	ret    
        panic("clearpteu");
80107b6c:	83 ec 0c             	sub    $0xc,%esp
80107b6f:	68 65 88 10 80       	push   $0x80108865
80107b74:	e8 17 88 ff ff       	call   80100390 <panic>
80107b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz) {
80107b80:	55                   	push   %ebp
80107b81:	89 e5                	mov    %esp,%ebp
80107b83:	57                   	push   %edi
80107b84:	56                   	push   %esi
80107b85:	53                   	push   %ebx
80107b86:	83 ec 1c             	sub    $0x1c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0)
80107b89:	e8 22 ff ff ff       	call   80107ab0 <setupkvm>
80107b8e:	85 c0                	test   %eax,%eax
80107b90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b93:	0f 84 a0 00 00 00    	je     80107c39 <copyuvm+0xb9>
        return 0;
    for (i = 0; i < sz; i += PGSIZE) {
80107b99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107b9c:	85 c9                	test   %ecx,%ecx
80107b9e:	0f 84 95 00 00 00    	je     80107c39 <copyuvm+0xb9>
80107ba4:	31 f6                	xor    %esi,%esi
80107ba6:	eb 4e                	jmp    80107bf6 <copyuvm+0x76>
80107ba8:	90                   	nop
80107ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0)
            goto bad;
        memmove(mem, (char *) P2V(pa), PGSIZE);
80107bb0:	83 ec 04             	sub    $0x4,%esp
80107bb3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107bb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107bbc:	68 00 10 00 00       	push   $0x1000
80107bc1:	57                   	push   %edi
80107bc2:	50                   	push   %eax
80107bc3:	e8 88 d1 ff ff       	call   80104d50 <memmove>
        if (mappages(d, (void *) i, PGSIZE, V2P(mem), flags) < 0)
80107bc8:	58                   	pop    %eax
80107bc9:	5a                   	pop    %edx
80107bca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107bcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107bd0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107bd5:	53                   	push   %ebx
80107bd6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107bdc:	52                   	push   %edx
80107bdd:	89 f2                	mov    %esi,%edx
80107bdf:	e8 9c f4 ff ff       	call   80107080 <mappages>
80107be4:	83 c4 10             	add    $0x10,%esp
80107be7:	85 c0                	test   %eax,%eax
80107be9:	78 39                	js     80107c24 <copyuvm+0xa4>
    for (i = 0; i < sz; i += PGSIZE) {
80107beb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107bf1:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107bf4:	76 43                	jbe    80107c39 <copyuvm+0xb9>
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf9:	31 c9                	xor    %ecx,%ecx
80107bfb:	89 f2                	mov    %esi,%edx
80107bfd:	e8 fe f3 ff ff       	call   80107000 <walkpgdir>
80107c02:	85 c0                	test   %eax,%eax
80107c04:	74 3e                	je     80107c44 <copyuvm+0xc4>
        if (!(*pte & PTE_P))
80107c06:	8b 18                	mov    (%eax),%ebx
80107c08:	f6 c3 01             	test   $0x1,%bl
80107c0b:	74 44                	je     80107c51 <copyuvm+0xd1>
        pa = PTE_ADDR(*pte);
80107c0d:	89 df                	mov    %ebx,%edi
        flags = PTE_FLAGS(*pte);
80107c0f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
        pa = PTE_ADDR(*pte);
80107c15:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
        if ((mem = kalloc()) == 0)
80107c1b:	e8 f0 ac ff ff       	call   80102910 <kalloc>
80107c20:	85 c0                	test   %eax,%eax
80107c22:	75 8c                	jne    80107bb0 <copyuvm+0x30>
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-DONE!\t");
    return d;

    bad:
    freevm(d);
80107c24:	83 ec 0c             	sub    $0xc,%esp
80107c27:	ff 75 e0             	pushl  -0x20(%ebp)
80107c2a:	e8 01 fe ff ff       	call   80107a30 <freevm>
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-FAILED!\t");
    return 0;
80107c2f:	83 c4 10             	add    $0x10,%esp
80107c32:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107c39:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c3f:	5b                   	pop    %ebx
80107c40:	5e                   	pop    %esi
80107c41:	5f                   	pop    %edi
80107c42:	5d                   	pop    %ebp
80107c43:	c3                   	ret    
            panic("copyuvm: pte should exist");
80107c44:	83 ec 0c             	sub    $0xc,%esp
80107c47:	68 6f 88 10 80       	push   $0x8010886f
80107c4c:	e8 3f 87 ff ff       	call   80100390 <panic>
            panic("copyuvm: page not present");
80107c51:	83 ec 0c             	sub    $0xc,%esp
80107c54:	68 89 88 10 80       	push   $0x80108889
80107c59:	e8 32 87 ff ff       	call   80100390 <panic>
80107c5e:	66 90                	xchg   %ax,%ax

80107c60 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva) {
80107c60:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80107c61:	31 c9                	xor    %ecx,%ecx
uva2ka(pde_t *pgdir, char *uva) {
80107c63:	89 e5                	mov    %esp,%ebp
80107c65:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
80107c68:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c6e:	e8 8d f3 ff ff       	call   80107000 <walkpgdir>
    if ((*pte & PTE_P) == 0)
80107c73:	8b 00                	mov    (%eax),%eax
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    return (char *) P2V(PTE_ADDR(*pte));
}
80107c75:	c9                   	leave  
    if ((*pte & PTE_U) == 0)
80107c76:	89 c2                	mov    %eax,%edx
    return (char *) P2V(PTE_ADDR(*pte));
80107c78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((*pte & PTE_U) == 0)
80107c7d:	83 e2 05             	and    $0x5,%edx
    return (char *) P2V(PTE_ADDR(*pte));
80107c80:	05 00 00 00 80       	add    $0x80000000,%eax
80107c85:	83 fa 05             	cmp    $0x5,%edx
80107c88:	ba 00 00 00 00       	mov    $0x0,%edx
80107c8d:	0f 45 c2             	cmovne %edx,%eax
}
80107c90:	c3                   	ret    
80107c91:	eb 0d                	jmp    80107ca0 <copyout>
80107c93:	90                   	nop
80107c94:	90                   	nop
80107c95:	90                   	nop
80107c96:	90                   	nop
80107c97:	90                   	nop
80107c98:	90                   	nop
80107c99:	90                   	nop
80107c9a:	90                   	nop
80107c9b:	90                   	nop
80107c9c:	90                   	nop
80107c9d:	90                   	nop
80107c9e:	90                   	nop
80107c9f:	90                   	nop

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
80107cdf:	e8 6c d0 ff ff       	call   80104d50 <memmove>
        len -= n;
        buf += n;
80107ce4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    while (len > 0) {
80107ce7:	83 c4 10             	add    $0x10,%esp
        va = va0 + PGSIZE;
80107cea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
        buf += n;
80107cf0:	01 cf                	add    %ecx,%edi
    while (len > 0) {
80107cf2:	29 cb                	sub    %ecx,%ebx
80107cf4:	74 32                	je     80107d28 <copyout+0x88>
        va0 = (uint) PGROUNDDOWN(va);
80107cf6:	89 d6                	mov    %edx,%esi
        pa0 = uva2ka(pgdir, (char *) va0);
80107cf8:	83 ec 08             	sub    $0x8,%esp
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
    }
    return 0;
}
80107d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107d17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d1c:	5b                   	pop    %ebx
80107d1d:	5e                   	pop    %esi
80107d1e:	5f                   	pop    %edi
80107d1f:	5d                   	pop    %ebp
80107d20:	c3                   	ret    
80107d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107d2b:	31 c0                	xor    %eax,%eax
}
80107d2d:	5b                   	pop    %ebx
80107d2e:	5e                   	pop    %esi
80107d2f:	5f                   	pop    %edi
80107d30:	5d                   	pop    %ebp
80107d31:	c3                   	ret    
