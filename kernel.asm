
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
8010004c:	68 60 7f 10 80       	push   $0x80107f60
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 f5 49 00 00       	call   80104a50 <initlock>
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
80100092:	68 67 7f 10 80       	push   $0x80107f67
80100097:	50                   	push   %eax
80100098:	e8 a3 48 00 00       	call   80104940 <initsleeplock>
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
801000e4:	e8 57 4a 00 00       	call   80104b40 <acquire>
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
80100162:	e8 f9 4a 00 00       	call   80104c60 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 48 00 00       	call   80104980 <acquiresleep>
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
80100193:	68 6e 7f 10 80       	push   $0x80107f6e
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
801001ae:	e8 6d 48 00 00       	call   80104a20 <holdingsleep>
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
801001cc:	68 7f 7f 10 80       	push   $0x80107f7f
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
801001ef:	e8 2c 48 00 00       	call   80104a20 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 47 00 00       	call   801049e0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 30 49 00 00       	call   80104b40 <acquire>
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
8010025c:	e9 ff 49 00 00       	jmp    80104c60 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 7f 10 80       	push   $0x80107f86
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
8010028c:	e8 af 48 00 00       	call   80104b40 <acquire>
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
801002c5:	e8 06 42 00 00       	call   801044d0 <sleep>
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
801002ef:	e8 6c 49 00 00       	call   80104c60 <release>
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
8010034d:	e8 0e 49 00 00       	call   80104c60 <release>
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
801003b2:	68 8d 7f 10 80       	push   $0x80107f8d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 ad 8a 10 80 	movl   $0x80108aad,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 93 46 00 00       	call   80104a70 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 7f 10 80       	push   $0x80107fa1
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
8010043a:	e8 21 61 00 00       	call   80106560 <uartputc>
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
801004ec:	e8 6f 60 00 00       	call   80106560 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 63 60 00 00       	call   80106560 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 57 60 00 00       	call   80106560 <uartputc>
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
80100524:	e8 47 48 00 00       	call   80104d70 <memmove>
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
80100541:	e8 7a 47 00 00       	call   80104cc0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 7f 10 80       	push   $0x80107fa5
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
801005b1:	0f b6 92 d0 7f 10 80 	movzbl -0x7fef8030(%edx),%edx
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
8010061b:	e8 20 45 00 00       	call   80104b40 <acquire>
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
80100647:	e8 14 46 00 00       	call   80104c60 <release>
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
8010071f:	e8 3c 45 00 00       	call   80104c60 <release>
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
801007d0:	ba b8 7f 10 80       	mov    $0x80107fb8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 4b 43 00 00       	call   80104b40 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 7f 10 80       	push   $0x80107fbf
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
80100823:	e8 18 43 00 00       	call   80104b40 <acquire>
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
80100888:	e8 d3 43 00 00       	call   80104c60 <release>
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
80100916:	e8 25 3e 00 00       	call   80104740 <wakeup>
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
80100997:	e9 84 3e 00 00       	jmp    80104820 <procdump>
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
801009c6:	68 c8 7f 10 80       	push   $0x80107fc8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 7b 40 00 00       	call   80104a50 <initlock>

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
80100a94:	e8 57 71 00 00       	call   80107bf0 <setupkvm>
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
80100ab9:	0f 84 be 02 00 00    	je     80100d7d <exec+0x36d>
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
80100af6:	e8 45 6d 00 00       	call   80107840 <allocuvm>
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
80100b28:	e8 83 68 00 00       	call   801073b0 <loaduvm>
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
80100b72:	e8 b9 6f 00 00       	call   80107b30 <freevm>
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
80100baa:	e8 91 6c 00 00       	call   80107840 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
        freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 6a 6f 00 00       	call   80107b30 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
    return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
        end_op();
80100bd3:	e8 88 24 00 00       	call   80103060 <end_op>
        cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 e1 7f 10 80       	push   $0x80107fe1
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
80100c06:	e8 85 70 00 00       	call   80107c90 <clearpteu>
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
80100c39:	e8 a2 42 00 00       	call   80104ee0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	59                   	pop    %ecx
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 8f 42 00 00       	call   80104ee0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 4e 72 00 00       	call   80107eb0 <copyout>
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
80100cc9:	e8 e2 71 00 00       	call   80107eb0 <copyout>
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
80100d0c:	e8 8f 41 00 00       	call   80104ea0 <safestrcpy>
    curproc->pgdir = pgdir;
80100d11:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
    oldpgdir = curproc->pgdir;
80100d17:	89 d8                	mov    %ebx,%eax
80100d19:	8b 5b 04             	mov    0x4(%ebx),%ebx
    curproc->pgdir = pgdir;
80100d1c:	89 50 04             	mov    %edx,0x4(%eax)
    if (notShell()) {
80100d1f:	e8 fc 2e 00 00       	call   80103c20 <notShell>
80100d24:	83 c4 10             	add    $0x10,%esp
80100d27:	85 c0                	test   %eax,%eax
80100d29:	74 1d                	je     80100d48 <exec+0x338>
        removeSwapFile(curproc);
80100d2b:	83 ec 0c             	sub    $0xc,%esp
80100d2e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d34:	e8 b7 12 00 00       	call   80101ff0 <removeSwapFile>
        createSwapFile(curproc);
80100d39:	58                   	pop    %eax
80100d3a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d40:	e8 ab 14 00 00       	call   801021f0 <createSwapFile>
80100d45:	83 c4 10             	add    $0x10,%esp
    curproc->sz = sz;
80100d48:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    switchuvm(curproc);
80100d4e:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80100d51:	89 31                	mov    %esi,(%ecx)
    curproc->tf->eip = elf.entry;  // main
80100d53:	8b 41 18             	mov    0x18(%ecx),%eax
80100d56:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d5c:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
80100d5f:	8b 41 18             	mov    0x18(%ecx),%eax
80100d62:	89 78 44             	mov    %edi,0x44(%eax)
    switchuvm(curproc);
80100d65:	51                   	push   %ecx
80100d66:	e8 b5 64 00 00       	call   80107220 <switchuvm>
    freevm(oldpgdir);
80100d6b:	89 1c 24             	mov    %ebx,(%esp)
80100d6e:	e8 bd 6d 00 00       	call   80107b30 <freevm>
    return 0;
80100d73:	83 c4 10             	add    $0x10,%esp
80100d76:	31 c0                	xor    %eax,%eax
80100d78:	e9 ff fc ff ff       	jmp    80100a7c <exec+0x6c>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100d7d:	be 00 20 00 00       	mov    $0x2000,%esi
80100d82:	e9 0a fe ff ff       	jmp    80100b91 <exec+0x181>
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
80100d96:	68 ed 7f 10 80       	push   $0x80107fed
80100d9b:	68 e0 0f 11 80       	push   $0x80110fe0
80100da0:	e8 ab 3c 00 00       	call   80104a50 <initlock>
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
80100dc1:	e8 7a 3d 00 00       	call   80104b40 <acquire>
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
80100df1:	e8 6a 3e 00 00       	call   80104c60 <release>
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
80100e0a:	e8 51 3e 00 00       	call   80104c60 <release>
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
80100e2f:	e8 0c 3d 00 00       	call   80104b40 <acquire>
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
80100e4c:	e8 0f 3e 00 00       	call   80104c60 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 f4 7f 10 80       	push   $0x80107ff4
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
80100e81:	e8 ba 3c 00 00       	call   80104b40 <acquire>
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
80100eac:	e9 af 3d 00 00       	jmp    80104c60 <release>
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
80100ed8:	e8 83 3d 00 00       	call   80104c60 <release>
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
80100f32:	68 fc 7f 10 80       	push   $0x80107ffc
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
80101012:	68 06 80 10 80       	push   $0x80108006
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
80101125:	68 0f 80 10 80       	push   $0x8010800f
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 15 80 10 80       	push   $0x80108015
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
801011e4:	68 1f 80 10 80       	push   $0x8010801f
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
80101225:	e8 96 3a 00 00       	call   80104cc0 <memset>
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
8010126a:	e8 d1 38 00 00       	call   80104b40 <acquire>
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
801012cf:	e8 8c 39 00 00       	call   80104c60 <release>

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
801012fd:	e8 5e 39 00 00       	call   80104c60 <release>
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
80101312:	68 35 80 10 80       	push   $0x80108035
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
801013e7:	68 45 80 10 80       	push   $0x80108045
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
80101421:	e8 4a 39 00 00       	call   80104d70 <memmove>
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
801014b4:	68 58 80 10 80       	push   $0x80108058
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
801014cc:	68 6b 80 10 80       	push   $0x8010806b
801014d1:	68 00 1a 11 80       	push   $0x80111a00
801014d6:	e8 75 35 00 00       	call   80104a50 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 72 80 10 80       	push   $0x80108072
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 4c 34 00 00       	call   80104940 <initsleeplock>
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
80101539:	68 1c 81 10 80       	push   $0x8010811c
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
801015ce:	e8 ed 36 00 00       	call   80104cc0 <memset>
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
80101603:	68 78 80 10 80       	push   $0x80108078
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
80101671:	e8 fa 36 00 00       	call   80104d70 <memmove>
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
8010169f:	e8 9c 34 00 00       	call   80104b40 <acquire>
  ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016a8:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801016af:	e8 ac 35 00 00       	call   80104c60 <release>
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
801016e2:	e8 99 32 00 00       	call   80104980 <acquiresleep>
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
80101758:	e8 13 36 00 00       	call   80104d70 <memmove>
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
8010177d:	68 90 80 10 80       	push   $0x80108090
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 8a 80 10 80       	push   $0x8010808a
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
801017b3:	e8 68 32 00 00       	call   80104a20 <holdingsleep>
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
801017cf:	e9 0c 32 00 00       	jmp    801049e0 <releasesleep>
    panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 9f 80 10 80       	push   $0x8010809f
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
80101800:	e8 7b 31 00 00       	call   80104980 <acquiresleep>
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
8010181a:	e8 c1 31 00 00       	call   801049e0 <releasesleep>
  acquire(&icache.lock);
8010181f:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101826:	e8 15 33 00 00       	call   80104b40 <acquire>
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
80101840:	e9 1b 34 00 00       	jmp    80104c60 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 00 1a 11 80       	push   $0x80111a00
80101850:	e8 eb 32 00 00       	call   80104b40 <acquire>
    int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101858:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010185f:	e8 fc 33 00 00       	call   80104c60 <release>
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
80101a47:	e8 24 33 00 00       	call   80104d70 <memmove>
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
80101b43:	e8 28 32 00 00       	call   80104d70 <memmove>
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
80101bde:	e8 fd 31 00 00       	call   80104de0 <strncmp>
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
80101c3d:	e8 9e 31 00 00       	call   80104de0 <strncmp>
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
80101c82:	68 b9 80 10 80       	push   $0x801080b9
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 a7 80 10 80       	push   $0x801080a7
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
80101cc9:	e8 72 2e 00 00       	call   80104b40 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101cd9:	e8 82 2f 00 00       	call   80104c60 <release>
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
80101d35:	e8 36 30 00 00       	call   80104d70 <memmove>
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
80101dc8:	e8 a3 2f 00 00       	call   80104d70 <memmove>
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
80101ebd:	e8 7e 2f 00 00       	call   80104e40 <strncpy>
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
80101efb:	68 c8 80 10 80       	push   $0x801080c8
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 51 87 10 80       	push   $0x80108751
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
80102001:	68 d5 80 10 80       	push   $0x801080d5
80102006:	56                   	push   %esi
80102007:	e8 64 2d 00 00       	call   80104d70 <memmove>
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
80102062:	68 dd 80 10 80       	push   $0x801080dd
80102067:	53                   	push   %ebx
80102068:	e8 73 2d 00 00       	call   80104de0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010206d:	83 c4 10             	add    $0x10,%esp
80102070:	85 c0                	test   %eax,%eax
80102072:	0f 84 f8 00 00 00    	je     80102170 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102078:	83 ec 04             	sub    $0x4,%esp
8010207b:	6a 0e                	push   $0xe
8010207d:	68 dc 80 10 80       	push   $0x801080dc
80102082:	53                   	push   %ebx
80102083:	e8 58 2d 00 00       	call   80104de0 <strncmp>
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
801020d7:	e8 e4 2b 00 00       	call   80104cc0 <memset>
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
80102144:	e8 57 33 00 00       	call   801054a0 <isdirempty>
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
801021cc:	68 f1 80 10 80       	push   $0x801080f1
801021d1:	e8 ba e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021d6:	83 ec 0c             	sub    $0xc,%esp
801021d9:	68 df 80 10 80       	push   $0x801080df
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
80102200:	68 d5 80 10 80       	push   $0x801080d5
80102205:	56                   	push   %esi
80102206:	e8 65 2b 00 00       	call   80104d70 <memmove>
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
80102225:	e8 86 34 00 00       	call   801056b0 <create>
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
80102279:	68 00 81 10 80       	push   $0x80108100
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
801023ab:	68 78 81 10 80       	push   $0x80108178
801023b0:	e8 db df ff ff       	call   80100390 <panic>
    panic("idestart");
801023b5:	83 ec 0c             	sub    $0xc,%esp
801023b8:	68 6f 81 10 80       	push   $0x8010816f
801023bd:	e8 ce df ff ff       	call   80100390 <panic>
801023c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <ideinit>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023d6:	68 8a 81 10 80       	push   $0x8010818a
801023db:	68 80 b5 10 80       	push   $0x8010b580
801023e0:	e8 6b 26 00 00       	call   80104a50 <initlock>
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
8010245e:	e8 dd 26 00 00       	call   80104b40 <acquire>

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
801024c1:	e8 7a 22 00 00       	call   80104740 <wakeup>

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
801024df:	e8 7c 27 00 00       	call   80104c60 <release>

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
801024fe:	e8 1d 25 00 00       	call   80104a20 <holdingsleep>
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
80102538:	e8 03 26 00 00       	call   80104b40 <acquire>

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
80102589:	e8 42 1f 00 00       	call   801044d0 <sleep>
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
801025a6:	e9 b5 26 00 00       	jmp    80104c60 <release>
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
801025ca:	68 a4 81 10 80       	push   $0x801081a4
801025cf:	e8 bc dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	68 8e 81 10 80       	push   $0x8010818e
801025dc:	e8 af dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025e1:	83 ec 0c             	sub    $0xc,%esp
801025e4:	68 b9 81 10 80       	push   $0x801081b9
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
80102637:	68 d8 81 10 80       	push   $0x801081d8
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
8010271b:	e8 20 24 00 00       	call   80104b40 <acquire>
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
80102751:	e8 0a 25 00 00       	call   80104c60 <release>
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
80102792:	e8 29 25 00 00       	call   80104cc0 <memset>

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
801027cb:	e9 90 24 00 00       	jmp    80104c60 <release>
    acquire(&kmem.lock);
801027d0:	83 ec 0c             	sub    $0xc,%esp
801027d3:	68 60 36 11 80       	push   $0x80113660
801027d8:	e8 63 23 00 00       	call   80104b40 <acquire>
801027dd:	83 c4 10             	add    $0x10,%esp
801027e0:	eb c2                	jmp    801027a4 <kfree+0x44>
    panic("kfree");
801027e2:	83 ec 0c             	sub    $0xc,%esp
801027e5:	68 0a 82 10 80       	push   $0x8010820a
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
8010284b:	68 10 82 10 80       	push   $0x80108210
80102850:	68 60 36 11 80       	push   $0x80113660
80102855:	e8 f6 21 00 00       	call   80104a50 <initlock>
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
80102943:	e8 f8 21 00 00       	call   80104b40 <acquire>
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
80102971:	e8 ea 22 00 00       	call   80104c60 <release>
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
801029c3:	0f b6 82 40 83 10 80 	movzbl -0x7fef7cc0(%edx),%eax
801029ca:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801029cc:	0f b6 82 40 82 10 80 	movzbl -0x7fef7dc0(%edx),%eax
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
801029e3:	8b 04 85 20 82 10 80 	mov    -0x7fef7de0(,%eax,4),%eax
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
80102a08:	0f b6 82 40 83 10 80 	movzbl -0x7fef7cc0(%edx),%eax
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
80102d87:	e8 84 1f 00 00       	call   80104d10 <memcmp>
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
80102eb4:	e8 b7 1e 00 00       	call   80104d70 <memmove>
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
80102f5a:	68 40 84 10 80       	push   $0x80108440
80102f5f:	68 a0 36 11 80       	push   $0x801136a0
80102f64:	e8 e7 1a 00 00       	call   80104a50 <initlock>
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
80102ffb:	e8 40 1b 00 00       	call   80104b40 <acquire>
80103000:	83 c4 10             	add    $0x10,%esp
80103003:	eb 18                	jmp    8010301d <begin_op+0x2d>
80103005:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103008:	83 ec 08             	sub    $0x8,%esp
8010300b:	68 a0 36 11 80       	push   $0x801136a0
80103010:	68 a0 36 11 80       	push   $0x801136a0
80103015:	e8 b6 14 00 00       	call   801044d0 <sleep>
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
8010304c:	e8 0f 1c 00 00       	call   80104c60 <release>
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
8010306e:	e8 cd 1a 00 00       	call   80104b40 <acquire>
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
801030ac:	e8 af 1b 00 00       	call   80104c60 <release>
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
80103106:	e8 65 1c 00 00       	call   80104d70 <memmove>
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
8010314f:	e8 ec 19 00 00       	call   80104b40 <acquire>
    wakeup(&log);
80103154:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
8010315b:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80103162:	00 00 00 
    wakeup(&log);
80103165:	e8 d6 15 00 00       	call   80104740 <wakeup>
    release(&log.lock);
8010316a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103171:	e8 ea 1a 00 00       	call   80104c60 <release>
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
80103190:	e8 ab 15 00 00       	call   80104740 <wakeup>
  release(&log.lock);
80103195:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
8010319c:	e8 bf 1a 00 00       	call   80104c60 <release>
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
801031af:	68 44 84 10 80       	push   $0x80108444
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
801031fe:	e8 3d 19 00 00       	call   80104b40 <acquire>
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
8010324d:	e9 0e 1a 00 00       	jmp    80104c60 <release>
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
80103279:	68 53 84 10 80       	push   $0x80108453
8010327e:	e8 0d d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103283:	83 ec 0c             	sub    $0xc,%esp
80103286:	68 69 84 10 80       	push   $0x80108469
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
801032a8:	68 84 84 10 80       	push   $0x80108484
801032ad:	e8 ae d3 ff ff       	call   80100660 <cprintf>
    idtinit();       // load idt register
801032b2:	e8 d9 2c 00 00       	call   80105f90 <idtinit>
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
801032ca:	e8 01 0f 00 00       	call   801041d0 <scheduler>
801032cf:	90                   	nop

801032d0 <mpenter>:
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801032d6:	e8 25 3f 00 00       	call   80107200 <switchkvm>
  seginit();
801032db:	e8 50 3e 00 00       	call   80107130 <seginit>
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
80103311:	e8 5a 49 00 00       	call   80107c70 <kvmalloc>
  mpinit();        // detect other processors
80103316:	e8 75 01 00 00       	call   80103490 <mpinit>
  lapicinit();     // interrupt controller
8010331b:	e8 60 f7 ff ff       	call   80102a80 <lapicinit>
  seginit();       // segment descriptors
80103320:	e8 0b 3e 00 00       	call   80107130 <seginit>
  picinit();       // disable pic
80103325:	e8 46 03 00 00       	call   80103670 <picinit>
  ioapicinit();    // another interrupt controller
8010332a:	e8 c1 f2 ff ff       	call   801025f0 <ioapicinit>
  consoleinit();   // console hardware
8010332f:	e8 8c d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103334:	e8 67 31 00 00       	call   801064a0 <uartinit>
  pinit();         // process table
80103339:	e8 02 09 00 00       	call   80103c40 <pinit>
  tvinit();        // trap vectors
8010333e:	e8 cd 2b 00 00       	call   80105f10 <tvinit>
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
80103364:	e8 07 1a 00 00       	call   80104d70 <memmove>

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
8010343e:	68 98 84 10 80       	push   $0x80108498
80103443:	56                   	push   %esi
80103444:	e8 c7 18 00 00       	call   80104d10 <memcmp>
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
801034fc:	68 b5 84 10 80       	push   $0x801084b5
80103501:	56                   	push   %esi
80103502:	e8 09 18 00 00       	call   80104d10 <memcmp>
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
80103590:	ff 24 95 dc 84 10 80 	jmp    *-0x7fef7b24(,%edx,4)
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
80103643:	68 9d 84 10 80       	push   $0x8010849d
80103648:	e8 43 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010364d:	83 ec 0c             	sub    $0xc,%esp
80103650:	68 bc 84 10 80       	push   $0x801084bc
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
8010374b:	68 f0 84 10 80       	push   $0x801084f0
80103750:	50                   	push   %eax
80103751:	e8 fa 12 00 00       	call   80104a50 <initlock>
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
801037af:	e8 8c 13 00 00       	call   80104b40 <acquire>
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
801037cf:	e8 6c 0f 00 00       	call   80104740 <wakeup>
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
801037f4:	e9 67 14 00 00       	jmp    80104c60 <release>
801037f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103800:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103806:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103809:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103810:	00 00 00 
    wakeup(&p->nwrite);
80103813:	50                   	push   %eax
80103814:	e8 27 0f 00 00       	call   80104740 <wakeup>
80103819:	83 c4 10             	add    $0x10,%esp
8010381c:	eb b9                	jmp    801037d7 <pipeclose+0x37>
8010381e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103820:	83 ec 0c             	sub    $0xc,%esp
80103823:	53                   	push   %ebx
80103824:	e8 37 14 00 00       	call   80104c60 <release>
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
8010384d:	e8 ee 12 00 00       	call   80104b40 <acquire>
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
801038a4:	e8 97 0e 00 00       	call   80104740 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038a9:	5a                   	pop    %edx
801038aa:	59                   	pop    %ecx
801038ab:	53                   	push   %ebx
801038ac:	56                   	push   %esi
801038ad:	e8 1e 0c 00 00       	call   801044d0 <sleep>
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
801038e4:	e8 77 13 00 00       	call   80104c60 <release>
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
80103933:	e8 08 0e 00 00       	call   80104740 <wakeup>
  release(&p->lock);
80103938:	89 1c 24             	mov    %ebx,(%esp)
8010393b:	e8 20 13 00 00       	call   80104c60 <release>
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
80103960:	e8 db 11 00 00       	call   80104b40 <acquire>
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
80103995:	e8 36 0b 00 00       	call   801044d0 <sleep>
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
801039ce:	e8 8d 12 00 00       	call   80104c60 <release>
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
80103a27:	e8 14 0d 00 00       	call   80104740 <wakeup>
  release(&p->lock);
80103a2c:	89 34 24             	mov    %esi,(%esp)
80103a2f:	e8 2c 12 00 00       	call   80104c60 <release>
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
static struct proc *
allocproc(void) {
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
#endif


    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a54:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
allocproc(void) {
80103a59:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80103a5c:	68 40 4d 11 80       	push   $0x80114d40
80103a61:	e8 da 10 00 00       	call   80104b40 <acquire>
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
80103aa9:	e8 b2 11 00 00       	call   80104c60 <release>

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
80103ad2:	c7 40 14 02 5f 10 80 	movl   $0x80105f02,0x14(%eax)
    p->context = (struct context *) sp;
80103ad9:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103adc:	6a 14                	push   $0x14
80103ade:	6a 00                	push   $0x0
80103ae0:	50                   	push   %eax
80103ae1:	e8 da 11 00 00       	call   80104cc0 <memset>
    p->context->eip = (uint) forkret;
80103ae6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103ae9:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
80103aef:	8d 93 40 04 00 00    	lea    0x440(%ebx),%edx
80103af5:	83 c4 10             	add    $0x10,%esp
80103af8:	c7 40 10 d0 3b 10 80 	movl   $0x80103bd0,0x10(%eax)

    //TODO INIT PROC PAGES FIELDS
#if(defined(LIFO) || defined(SCFIFO))
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
#endif

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
80103baa:	e8 b1 10 00 00       	call   80104c60 <release>
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
80103bdb:	e8 80 10 00 00       	call   80104c60 <release>

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
    return nextpid > 2;
80103c20:	31 c0                	xor    %eax,%eax
80103c22:	83 3d 04 b0 10 80 02 	cmpl   $0x2,0x8010b004
int notShell(void) {
80103c29:	55                   	push   %ebp
80103c2a:	89 e5                	mov    %esp,%ebp
}
80103c2c:	5d                   	pop    %ebp
    return nextpid > 2;
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
pinit(void) {
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103c46:	68 f5 84 10 80       	push   $0x801084f5
80103c4b:	68 40 4d 11 80       	push   $0x80114d40
80103c50:	e8 fb 0d 00 00       	call   80104a50 <initlock>
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
80103cc0:	68 fc 84 10 80       	push   $0x801084fc
80103cc5:	e8 c6 c6 ff ff       	call   80100390 <panic>
        panic("mycpu called with interrupts enabled\n");
80103cca:	83 ec 0c             	sub    $0xc,%esp
80103ccd:	68 e8 85 10 80       	push   $0x801085e8
80103cd2:	e8 b9 c6 ff ff       	call   80100390 <panic>
80103cd7:	89 f6                	mov    %esi,%esi
80103cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ce0 <cpuid>:
cpuid() {
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103ce6:	e8 75 ff ff ff       	call   80103c60 <mycpu>
80103ceb:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103cf0:	c9                   	leave  
    return mycpu() - cpus;
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
80103d07:	e8 f4 0d 00 00       	call   80104b00 <pushcli>
    c = mycpu();
80103d0c:	e8 4f ff ff ff       	call   80103c60 <mycpu>
    p = c->proc;
80103d11:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103d17:	e8 e4 0e 00 00       	call   80104c00 <popcli>
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
80103d4d:	e8 9e 3e 00 00       	call   80107bf0 <setupkvm>
80103d52:	85 c0                	test   %eax,%eax
80103d54:	89 43 04             	mov    %eax,0x4(%ebx)
80103d57:	0f 84 bd 00 00 00    	je     80103e1a <userinit+0xea>
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
80103d5d:	83 ec 04             	sub    $0x4,%esp
80103d60:	68 2c 00 00 00       	push   $0x2c
80103d65:	68 60 b4 10 80       	push   $0x8010b460
80103d6a:	50                   	push   %eax
80103d6b:	e8 c0 35 00 00       	call   80107330 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103d70:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103d73:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103d79:	6a 4c                	push   $0x4c
80103d7b:	6a 00                	push   $0x0
80103d7d:	ff 73 18             	pushl  0x18(%ebx)
80103d80:	e8 3b 0f 00 00       	call   80104cc0 <memset>
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
80103dd9:	68 25 85 10 80       	push   $0x80108525
80103dde:	50                   	push   %eax
80103ddf:	e8 bc 10 00 00       	call   80104ea0 <safestrcpy>
    p->cwd = namei("/");
80103de4:	c7 04 24 2e 85 10 80 	movl   $0x8010852e,(%esp)
80103deb:	e8 30 e1 ff ff       	call   80101f20 <namei>
80103df0:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103df3:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103dfa:	e8 41 0d 00 00       	call   80104b40 <acquire>
    p->state = RUNNABLE;
80103dff:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103e06:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103e0d:	e8 4e 0e 00 00       	call   80104c60 <release>
}
80103e12:	83 c4 10             	add    $0x10,%esp
80103e15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e18:	c9                   	leave  
80103e19:	c3                   	ret    
        panic("userinit: out of memory?");
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	68 0c 85 10 80       	push   $0x8010850c
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
80103e38:	e8 c3 0c 00 00       	call   80104b00 <pushcli>
    c = mycpu();
80103e3d:	e8 1e fe ff ff       	call   80103c60 <mycpu>
    p = c->proc;
80103e42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103e48:	e8 b3 0d 00 00       	call   80104c00 <popcli>
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
80103e5c:	e8 bf 33 00 00       	call   80107220 <switchuvm>
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
80103e7a:	e8 c1 39 00 00       	call   80107840 <allocuvm>
80103e7f:	83 c4 10             	add    $0x10,%esp
80103e82:	85 c0                	test   %eax,%eax
80103e84:	75 d0                	jne    80103e56 <growproc+0x26>
            return -1;
80103e86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e8b:	eb d9                	jmp    80103e66 <growproc+0x36>
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
        curproc->pagesCounter += (PGROUNDUP(n) / PGSIZE);
80103e90:	8d 96 ff 0f 00 00    	lea    0xfff(%esi),%edx
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
80103e96:	01 c6                	add    %eax,%esi
        curproc->pagesCounter += (PGROUNDUP(n) / PGSIZE);
80103e98:	c1 fa 0c             	sar    $0xc,%edx
80103e9b:	01 93 44 04 00 00    	add    %edx,0x444(%ebx)
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
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
80103ec9:	e8 32 0c 00 00       	call   80104b00 <pushcli>
    c = mycpu();
80103ece:	e8 8d fd ff ff       	call   80103c60 <mycpu>
    p = c->proc;
80103ed3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ed9:	e8 22 0d 00 00       	call   80104c00 <popcli>
    if ((np = allocproc()) == 0) {
80103ede:	e8 6d fb ff ff       	call   80103a50 <allocproc>
80103ee3:	85 c0                	test   %eax,%eax
80103ee5:	0f 84 a4 02 00 00    	je     8010418f <fork+0x2cf>
    if (firstRun) {
80103eeb:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
80103ef1:	89 c2                	mov    %eax,%edx
80103ef3:	85 c9                	test   %ecx,%ecx
80103ef5:	0f 85 75 02 00 00    	jne    80104170 <fork+0x2b0>
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
80103f0e:	e8 fd 3d 00 00       	call   80107d10 <copyuvm>
80103f13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f16:	83 c4 10             	add    $0x10,%esp
80103f19:	85 c0                	test   %eax,%eax
80103f1b:	89 42 04             	mov    %eax,0x4(%edx)
80103f1e:	0f 84 75 02 00 00    	je     80104199 <fork+0x2d9>
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
    if (notShell()) {
80103f38:	83 3d 04 b0 10 80 02 	cmpl   $0x2,0x8010b004
80103f3f:	0f 8f a3 00 00 00    	jg     80103fe8 <fork+0x128>
    np->tf->eax = 0;
80103f45:	8b 42 18             	mov    0x18(%edx),%eax
    for (i = 0; i < NOFILE; i++)
80103f48:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80103f4a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (curproc->ofile[i])
80103f58:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f5c:	85 c0                	test   %eax,%eax
80103f5e:	74 16                	je     80103f76 <fork+0xb6>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103f60:	83 ec 0c             	sub    $0xc,%esp
80103f63:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103f66:	50                   	push   %eax
80103f67:	e8 b4 ce ff ff       	call   80100e20 <filedup>
80103f6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f6f:	83 c4 10             	add    $0x10,%esp
80103f72:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++)
80103f76:	83 c6 01             	add    $0x1,%esi
80103f79:	83 fe 10             	cmp    $0x10,%esi
80103f7c:	75 da                	jne    80103f58 <fork+0x98>
    np->cwd = idup(curproc->cwd);
80103f7e:	83 ec 0c             	sub    $0xc,%esp
80103f81:	ff 73 68             	pushl  0x68(%ebx)
80103f84:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f87:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
80103f8a:	e8 01 d7 ff ff       	call   80101690 <idup>
80103f8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f92:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
80103f95:	89 42 68             	mov    %eax,0x68(%edx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f98:	8d 42 6c             	lea    0x6c(%edx),%eax
80103f9b:	6a 10                	push   $0x10
80103f9d:	53                   	push   %ebx
80103f9e:	50                   	push   %eax
80103f9f:	e8 fc 0e 00 00       	call   80104ea0 <safestrcpy>
    pid = np->pid;
80103fa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fa7:	8b 72 10             	mov    0x10(%edx),%esi
    acquire(&ptable.lock);
80103faa:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103fb1:	e8 8a 0b 00 00       	call   80104b40 <acquire>
    np->state = RUNNABLE;
80103fb6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fb9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
    release(&ptable.lock);
80103fc0:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
80103fc7:	e8 94 0c 00 00       	call   80104c60 <release>
    firstRun = 0;
80103fcc:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80103fd3:	00 00 00 
    return pid;
80103fd6:	83 c4 10             	add    $0x10,%esp
}
80103fd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fdc:	89 f0                	mov    %esi,%eax
80103fde:	5b                   	pop    %ebx
80103fdf:	5e                   	pop    %esi
80103fe0:	5f                   	pop    %edi
80103fe1:	5d                   	pop    %ebp
80103fe2:	c3                   	ret    
80103fe3:	90                   	nop
80103fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        np->nextpageid = curproc->nextpageid;
80103fe8:	8b 83 40 04 00 00    	mov    0x440(%ebx),%eax
80103fee:	89 82 40 04 00 00    	mov    %eax,0x440(%edx)
        np->pagesCounter = curproc->pagesCounter;
80103ff4:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
80103ffa:	89 82 44 04 00 00    	mov    %eax,0x444(%edx)
        np->pagesequel = curproc->pagesequel;
80104000:	8b 83 4c 04 00 00    	mov    0x44c(%ebx),%eax
80104006:	89 82 4c 04 00 00    	mov    %eax,0x44c(%edx)
        np->pagesinSwap = curproc->pagesinSwap;
8010400c:	8b 83 48 04 00 00    	mov    0x448(%ebx),%eax
80104012:	89 82 48 04 00 00    	mov    %eax,0x448(%edx)
        np->protectedPages = curproc->protectedPages;
80104018:	8b 83 50 04 00 00    	mov    0x450(%ebx),%eax
        np->pageFaults = 0;
8010401e:	c7 82 54 04 00 00 00 	movl   $0x0,0x454(%edx)
80104025:	00 00 00 
        np->totalPagesInSwap = 0;
80104028:	c7 82 58 04 00 00 00 	movl   $0x0,0x458(%edx)
8010402f:	00 00 00 
        np->protectedPages = curproc->protectedPages;
80104032:	89 82 50 04 00 00    	mov    %eax,0x450(%edx)
        for(int k=0; k<MAX_PSYC_PAGES ; k++)
80104038:	31 c0                	xor    %eax,%eax
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            np->swapFileEntries[k]=curproc->swapFileEntries[k];
80104040:	8b 8c 83 00 04 00 00 	mov    0x400(%ebx,%eax,4),%ecx
80104047:	89 8c 82 00 04 00 00 	mov    %ecx,0x400(%edx,%eax,4)
        for(int k=0; k<MAX_PSYC_PAGES ; k++)
8010404e:	83 c0 01             	add    $0x1,%eax
80104051:	83 f8 10             	cmp    $0x10,%eax
80104054:	75 ea                	jne    80104040 <fork+0x180>
        for( pg = np->pages , cg = curproc->pages;
80104056:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
8010405c:	8d 8b 80 00 00 00    	lea    0x80(%ebx),%ecx
                pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80104062:	8d ba 00 04 00 00    	lea    0x400(%edx),%edi
80104068:	90                   	nop
80104069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            pg->offset = cg->offset;
80104070:	8b 71 10             	mov    0x10(%ecx),%esi
                pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
80104073:	83 c0 1c             	add    $0x1c,%eax
80104076:	83 c1 1c             	add    $0x1c,%ecx
            pg->offset = cg->offset;
80104079:	89 70 f4             	mov    %esi,-0xc(%eax)
            pg->pageid = cg->pageid;
8010407c:	8b 71 e8             	mov    -0x18(%ecx),%esi
8010407f:	89 70 e8             	mov    %esi,-0x18(%eax)
            pg->present = cg->present;
80104082:	8b 71 f0             	mov    -0x10(%ecx),%esi
80104085:	89 70 f0             	mov    %esi,-0x10(%eax)
            pg->sequel = cg->sequel;
80104088:	8b 71 ec             	mov    -0x14(%ecx),%esi
8010408b:	89 70 ec             	mov    %esi,-0x14(%eax)
            pg->physAdress = cg->physAdress;
8010408e:	8b 71 f8             	mov    -0x8(%ecx),%esi
80104091:	89 70 f8             	mov    %esi,-0x8(%eax)
            pg->virtAdress = cg->virtAdress;
80104094:	8b 71 fc             	mov    -0x4(%ecx),%esi
80104097:	89 70 fc             	mov    %esi,-0x4(%eax)
        for( pg = np->pages , cg = curproc->pages;
8010409a:	39 c7                	cmp    %eax,%edi
8010409c:	77 d2                	ja     80104070 <fork+0x1b0>
        if (!firstRun) {
8010409e:	8b 3d 08 b0 10 80    	mov    0x8010b008,%edi
801040a4:	85 ff                	test   %edi,%edi
801040a6:	0f 85 99 fe ff ff    	jne    80103f45 <fork+0x85>
            for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
801040ac:	83 bb 44 04 00 00 10 	cmpl   $0x10,0x444(%ebx)
801040b3:	7f 44                	jg     801040f9 <fork+0x239>
801040b5:	e9 8b fe ff ff       	jmp    80103f45 <fork+0x85>
801040ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
801040c0:	68 00 10 00 00       	push   $0x1000
801040c5:	51                   	push   %ecx
801040c6:	68 40 3d 11 80       	push   $0x80113d40
801040cb:	52                   	push   %edx
801040cc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801040cf:	e8 bc e1 ff ff       	call   80102290 <writeToSwapFile>
801040d4:	83 c4 10             	add    $0x10,%esp
801040d7:	83 f8 ff             	cmp    $0xffffffff,%eax
801040da:	89 c6                	mov    %eax,%esi
801040dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040df:	0f 84 a2 00 00 00    	je     80104187 <fork+0x2c7>
            for( int k = 0 ; k < curproc->pagesCounter - MAX_PSYC_PAGES ; k++ ){
801040e5:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
801040eb:	83 c7 01             	add    $0x1,%edi
801040ee:	83 e8 10             	sub    $0x10,%eax
801040f1:	39 f8                	cmp    %edi,%eax
801040f3:	0f 8e 4c fe ff ff    	jle    80103f45 <fork+0x85>
                memset(buffer, 0, PGSIZE);
801040f9:	83 ec 04             	sub    $0x4,%esp
801040fc:	89 55 e0             	mov    %edx,-0x20(%ebp)
801040ff:	68 00 10 00 00       	push   $0x1000
80104104:	6a 00                	push   $0x0
80104106:	68 40 3d 11 80       	push   $0x80113d40
8010410b:	e8 b0 0b 00 00       	call   80104cc0 <memset>
80104110:	89 f9                	mov    %edi,%ecx
                if (readFromSwapFile(curproc, buffer, k * PGSIZE, PGSIZE) == -1) {
80104112:	68 00 10 00 00       	push   $0x1000
80104117:	c1 e1 0c             	shl    $0xc,%ecx
8010411a:	51                   	push   %ecx
8010411b:	68 40 3d 11 80       	push   $0x80113d40
80104120:	53                   	push   %ebx
80104121:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80104124:	e8 97 e1 ff ff       	call   801022c0 <readFromSwapFile>
80104129:	83 c4 20             	add    $0x20,%esp
8010412c:	83 f8 ff             	cmp    $0xffffffff,%eax
8010412f:	89 c6                	mov    %eax,%esi
80104131:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104134:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104137:	75 87                	jne    801040c0 <fork+0x200>
                    kfree(np->kstack);
80104139:	83 ec 0c             	sub    $0xc,%esp
8010413c:	ff 72 08             	pushl  0x8(%edx)
8010413f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
                    kfree(np->kstack);
80104142:	e8 19 e6 ff ff       	call   80102760 <kfree>
                    np->kstack = 0;
80104147:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010414a:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
                    np->state = UNUSED;
80104151:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
                    removeSwapFile(np); //clear swapFile
80104158:	89 14 24             	mov    %edx,(%esp)
8010415b:	e8 90 de ff ff       	call   80101ff0 <removeSwapFile>
                    return -1;
80104160:	83 c4 10             	add    $0x10,%esp
}
80104163:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104166:	89 f0                	mov    %esi,%eax
80104168:	5b                   	pop    %ebx
80104169:	5e                   	pop    %esi
8010416a:	5f                   	pop    %edi
8010416b:	5d                   	pop    %ebp
8010416c:	c3                   	ret    
8010416d:	8d 76 00             	lea    0x0(%esi),%esi
        createSwapFile(curproc);
80104170:	83 ec 0c             	sub    $0xc,%esp
80104173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104176:	53                   	push   %ebx
80104177:	e8 74 e0 ff ff       	call   801021f0 <createSwapFile>
8010417c:	83 c4 10             	add    $0x10,%esp
8010417f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104182:	e9 74 fd ff ff       	jmp    80103efb <fork+0x3b>
                    kfree(np->kstack);
80104187:	83 ec 0c             	sub    $0xc,%esp
8010418a:	ff 72 08             	pushl  0x8(%edx)
8010418d:	eb b3                	jmp    80104142 <fork+0x282>
        return -1;
8010418f:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104194:	e9 40 fe ff ff       	jmp    80103fd9 <fork+0x119>
        kfree(np->kstack);
80104199:	83 ec 0c             	sub    $0xc,%esp
8010419c:	ff 72 08             	pushl  0x8(%edx)
        return -1;
8010419f:	be ff ff ff ff       	mov    $0xffffffff,%esi
        kfree(np->kstack);
801041a4:	e8 b7 e5 ff ff       	call   80102760 <kfree>
        np->kstack = 0;
801041a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        return -1;
801041ac:	83 c4 10             	add    $0x10,%esp
        np->kstack = 0;
801041af:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
        np->state = UNUSED;
801041b6:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
        return -1;
801041bd:	e9 17 fe ff ff       	jmp    80103fd9 <fork+0x119>
801041c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041d0 <scheduler>:
scheduler(void) {
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
801041d9:	e8 82 fa ff ff       	call   80103c60 <mycpu>
801041de:	8d 78 04             	lea    0x4(%eax),%edi
801041e1:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801041e3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041ea:	00 00 00 
801041ed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801041f0:	fb                   	sti    
        acquire(&ptable.lock);
801041f1:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041f4:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
        acquire(&ptable.lock);
801041f9:	68 40 4d 11 80       	push   $0x80114d40
801041fe:	e8 3d 09 00 00       	call   80104b40 <acquire>
80104203:	83 c4 10             	add    $0x10,%esp
80104206:	8d 76 00             	lea    0x0(%esi),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (p->state != RUNNABLE)
80104210:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104214:	75 33                	jne    80104249 <scheduler+0x79>
            switchuvm(p);
80104216:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80104219:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
8010421f:	53                   	push   %ebx
80104220:	e8 fb 2f 00 00       	call   80107220 <switchuvm>
            swtch(&(c->scheduler), p->context);
80104225:	58                   	pop    %eax
80104226:	5a                   	pop    %edx
80104227:	ff 73 1c             	pushl  0x1c(%ebx)
8010422a:	57                   	push   %edi
            p->state = RUNNING;
8010422b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80104232:	e8 c4 0c 00 00       	call   80104efb <swtch>
            switchkvm();
80104237:	e8 c4 2f 00 00       	call   80107200 <switchkvm>
            c->proc = 0;
8010423c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104243:	00 00 00 
80104246:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104249:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
8010424f:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
80104255:	72 b9                	jb     80104210 <scheduler+0x40>
        release(&ptable.lock);
80104257:	83 ec 0c             	sub    $0xc,%esp
8010425a:	68 40 4d 11 80       	push   $0x80114d40
8010425f:	e8 fc 09 00 00       	call   80104c60 <release>
        sti();
80104264:	83 c4 10             	add    $0x10,%esp
80104267:	eb 87                	jmp    801041f0 <scheduler+0x20>
80104269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104270 <sched>:
sched(void) {
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	56                   	push   %esi
80104274:	53                   	push   %ebx
    pushcli();
80104275:	e8 86 08 00 00       	call   80104b00 <pushcli>
    c = mycpu();
8010427a:	e8 e1 f9 ff ff       	call   80103c60 <mycpu>
    p = c->proc;
8010427f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104285:	e8 76 09 00 00       	call   80104c00 <popcli>
    if (!holding(&ptable.lock))
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	68 40 4d 11 80       	push   $0x80114d40
80104292:	e8 29 08 00 00       	call   80104ac0 <holding>
80104297:	83 c4 10             	add    $0x10,%esp
8010429a:	85 c0                	test   %eax,%eax
8010429c:	74 4f                	je     801042ed <sched+0x7d>
    if (mycpu()->ncli != 1)
8010429e:	e8 bd f9 ff ff       	call   80103c60 <mycpu>
801042a3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042aa:	75 68                	jne    80104314 <sched+0xa4>
    if (p->state == RUNNING)
801042ac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801042b0:	74 55                	je     80104307 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042b2:	9c                   	pushf  
801042b3:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801042b4:	f6 c4 02             	test   $0x2,%ah
801042b7:	75 41                	jne    801042fa <sched+0x8a>
    intena = mycpu()->intena;
801042b9:	e8 a2 f9 ff ff       	call   80103c60 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
801042be:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
801042c1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
801042c7:	e8 94 f9 ff ff       	call   80103c60 <mycpu>
801042cc:	83 ec 08             	sub    $0x8,%esp
801042cf:	ff 70 04             	pushl  0x4(%eax)
801042d2:	53                   	push   %ebx
801042d3:	e8 23 0c 00 00       	call   80104efb <swtch>
    mycpu()->intena = intena;
801042d8:	e8 83 f9 ff ff       	call   80103c60 <mycpu>
}
801042dd:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
801042e0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042e9:	5b                   	pop    %ebx
801042ea:	5e                   	pop    %esi
801042eb:	5d                   	pop    %ebp
801042ec:	c3                   	ret    
        panic("sched ptable.lock");
801042ed:	83 ec 0c             	sub    $0xc,%esp
801042f0:	68 30 85 10 80       	push   $0x80108530
801042f5:	e8 96 c0 ff ff       	call   80100390 <panic>
        panic("sched interruptible");
801042fa:	83 ec 0c             	sub    $0xc,%esp
801042fd:	68 5c 85 10 80       	push   $0x8010855c
80104302:	e8 89 c0 ff ff       	call   80100390 <panic>
        panic("sched running");
80104307:	83 ec 0c             	sub    $0xc,%esp
8010430a:	68 4e 85 10 80       	push   $0x8010854e
8010430f:	e8 7c c0 ff ff       	call   80100390 <panic>
        panic("sched locks");
80104314:	83 ec 0c             	sub    $0xc,%esp
80104317:	68 42 85 10 80       	push   $0x80108542
8010431c:	e8 6f c0 ff ff       	call   80100390 <panic>
80104321:	eb 0d                	jmp    80104330 <exit>
80104323:	90                   	nop
80104324:	90                   	nop
80104325:	90                   	nop
80104326:	90                   	nop
80104327:	90                   	nop
80104328:	90                   	nop
80104329:	90                   	nop
8010432a:	90                   	nop
8010432b:	90                   	nop
8010432c:	90                   	nop
8010432d:	90                   	nop
8010432e:	90                   	nop
8010432f:	90                   	nop

80104330 <exit>:
exit(void) {
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
80104336:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104339:	e8 c2 07 00 00       	call   80104b00 <pushcli>
    c = mycpu();
8010433e:	e8 1d f9 ff ff       	call   80103c60 <mycpu>
    p = c->proc;
80104343:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104349:	e8 b2 08 00 00       	call   80104c00 <popcli>
    if (curproc == initproc)
8010434e:	39 1d bc b5 10 80    	cmp    %ebx,0x8010b5bc
80104354:	8d 73 28             	lea    0x28(%ebx),%esi
80104357:	8d 7b 68             	lea    0x68(%ebx),%edi
8010435a:	0f 84 11 01 00 00    	je     80104471 <exit+0x141>
        if (curproc->ofile[fd]) {
80104360:	8b 06                	mov    (%esi),%eax
80104362:	85 c0                	test   %eax,%eax
80104364:	74 12                	je     80104378 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104366:	83 ec 0c             	sub    $0xc,%esp
80104369:	50                   	push   %eax
8010436a:	e8 01 cb ff ff       	call   80100e70 <fileclose>
            curproc->ofile[fd] = 0;
8010436f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104375:	83 c4 10             	add    $0x10,%esp
80104378:	83 c6 04             	add    $0x4,%esi
    for (fd = 0; fd < NOFILE; fd++) {
8010437b:	39 fe                	cmp    %edi,%esi
8010437d:	75 e1                	jne    80104360 <exit+0x30>
    begin_op();
8010437f:	e8 6c ec ff ff       	call   80102ff0 <begin_op>
    iput(curproc->cwd);
80104384:	83 ec 0c             	sub    $0xc,%esp
80104387:	ff 73 68             	pushl  0x68(%ebx)
8010438a:	e8 61 d4 ff ff       	call   801017f0 <iput>
    end_op();
8010438f:	e8 cc ec ff ff       	call   80103060 <end_op>
    if (curproc->pid > 2)
80104394:	83 c4 10             	add    $0x10,%esp
80104397:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
    curproc->cwd = 0;
8010439b:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
    if (curproc->pid > 2)
801043a2:	7e 0c                	jle    801043b0 <exit+0x80>
            removeSwapFile(curproc);
801043a4:	83 ec 0c             	sub    $0xc,%esp
801043a7:	53                   	push   %ebx
801043a8:	e8 43 dc ff ff       	call   80101ff0 <removeSwapFile>
801043ad:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
801043b0:	83 ec 0c             	sub    $0xc,%esp
801043b3:	68 40 4d 11 80       	push   $0x80114d40
801043b8:	e8 83 07 00 00       	call   80104b40 <acquire>
    wakeup1(curproc->parent);
801043bd:	8b 53 14             	mov    0x14(%ebx),%edx
801043c0:	83 c4 10             	add    $0x10,%esp
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043c3:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
801043c8:	eb 12                	jmp    801043dc <exit+0xac>
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043d0:	05 5c 04 00 00       	add    $0x45c,%eax
801043d5:	3d 74 64 12 80       	cmp    $0x80126474,%eax
801043da:	73 1e                	jae    801043fa <exit+0xca>
        if (p->state == SLEEPING && p->chan == chan)
801043dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043e0:	75 ee                	jne    801043d0 <exit+0xa0>
801043e2:	3b 50 20             	cmp    0x20(%eax),%edx
801043e5:	75 e9                	jne    801043d0 <exit+0xa0>
            p->state = RUNNABLE;
801043e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ee:	05 5c 04 00 00       	add    $0x45c,%eax
801043f3:	3d 74 64 12 80       	cmp    $0x80126474,%eax
801043f8:	72 e2                	jb     801043dc <exit+0xac>
            p->parent = initproc;
801043fa:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104400:	ba 74 4d 11 80       	mov    $0x80114d74,%edx
80104405:	eb 17                	jmp    8010441e <exit+0xee>
80104407:	89 f6                	mov    %esi,%esi
80104409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104410:	81 c2 5c 04 00 00    	add    $0x45c,%edx
80104416:	81 fa 74 64 12 80    	cmp    $0x80126474,%edx
8010441c:	73 3a                	jae    80104458 <exit+0x128>
        if (p->parent == curproc) {
8010441e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104421:	75 ed                	jne    80104410 <exit+0xe0>
            if (p->state == ZOMBIE)
80104423:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104427:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE)
8010442a:	75 e4                	jne    80104410 <exit+0xe0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010442c:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
80104431:	eb 11                	jmp    80104444 <exit+0x114>
80104433:	90                   	nop
80104434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104438:	05 5c 04 00 00       	add    $0x45c,%eax
8010443d:	3d 74 64 12 80       	cmp    $0x80126474,%eax
80104442:	73 cc                	jae    80104410 <exit+0xe0>
        if (p->state == SLEEPING && p->chan == chan)
80104444:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104448:	75 ee                	jne    80104438 <exit+0x108>
8010444a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010444d:	75 e9                	jne    80104438 <exit+0x108>
            p->state = RUNNABLE;
8010444f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104456:	eb e0                	jmp    80104438 <exit+0x108>
    curproc->state = ZOMBIE;
80104458:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
    sched();
8010445f:	e8 0c fe ff ff       	call   80104270 <sched>
    panic("zombie exit");
80104464:	83 ec 0c             	sub    $0xc,%esp
80104467:	68 7d 85 10 80       	push   $0x8010857d
8010446c:	e8 1f bf ff ff       	call   80100390 <panic>
        panic("init exiting");
80104471:	83 ec 0c             	sub    $0xc,%esp
80104474:	68 70 85 10 80       	push   $0x80108570
80104479:	e8 12 bf ff ff       	call   80100390 <panic>
8010447e:	66 90                	xchg   %ax,%ax

80104480 <yield>:
yield(void) {
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104487:	68 40 4d 11 80       	push   $0x80114d40
8010448c:	e8 af 06 00 00       	call   80104b40 <acquire>
    pushcli();
80104491:	e8 6a 06 00 00       	call   80104b00 <pushcli>
    c = mycpu();
80104496:	e8 c5 f7 ff ff       	call   80103c60 <mycpu>
    p = c->proc;
8010449b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801044a1:	e8 5a 07 00 00       	call   80104c00 <popcli>
    myproc()->state = RUNNABLE;
801044a6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
801044ad:	e8 be fd ff ff       	call   80104270 <sched>
    release(&ptable.lock);
801044b2:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
801044b9:	e8 a2 07 00 00       	call   80104c60 <release>
}
801044be:	83 c4 10             	add    $0x10,%esp
801044c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c4:	c9                   	leave  
801044c5:	c3                   	ret    
801044c6:	8d 76 00             	lea    0x0(%esi),%esi
801044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044d0 <sleep>:
sleep(void *chan, struct spinlock *lk) {
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	57                   	push   %edi
801044d4:	56                   	push   %esi
801044d5:	53                   	push   %ebx
801044d6:	83 ec 0c             	sub    $0xc,%esp
801044d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801044dc:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
801044df:	e8 1c 06 00 00       	call   80104b00 <pushcli>
    c = mycpu();
801044e4:	e8 77 f7 ff ff       	call   80103c60 <mycpu>
    p = c->proc;
801044e9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801044ef:	e8 0c 07 00 00       	call   80104c00 <popcli>
    if (p == 0)
801044f4:	85 db                	test   %ebx,%ebx
801044f6:	0f 84 87 00 00 00    	je     80104583 <sleep+0xb3>
    if (lk == 0)
801044fc:	85 f6                	test   %esi,%esi
801044fe:	74 76                	je     80104576 <sleep+0xa6>
    if (lk != &ptable.lock) {  //DOC: sleeplock0
80104500:	81 fe 40 4d 11 80    	cmp    $0x80114d40,%esi
80104506:	74 50                	je     80104558 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104508:	83 ec 0c             	sub    $0xc,%esp
8010450b:	68 40 4d 11 80       	push   $0x80114d40
80104510:	e8 2b 06 00 00       	call   80104b40 <acquire>
        release(lk);
80104515:	89 34 24             	mov    %esi,(%esp)
80104518:	e8 43 07 00 00       	call   80104c60 <release>
    p->chan = chan;
8010451d:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104520:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104527:	e8 44 fd ff ff       	call   80104270 <sched>
    p->chan = 0;
8010452c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80104533:	c7 04 24 40 4d 11 80 	movl   $0x80114d40,(%esp)
8010453a:	e8 21 07 00 00       	call   80104c60 <release>
        acquire(lk);
8010453f:	89 75 08             	mov    %esi,0x8(%ebp)
80104542:	83 c4 10             	add    $0x10,%esp
}
80104545:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104548:	5b                   	pop    %ebx
80104549:	5e                   	pop    %esi
8010454a:	5f                   	pop    %edi
8010454b:	5d                   	pop    %ebp
        acquire(lk);
8010454c:	e9 ef 05 00 00       	jmp    80104b40 <acquire>
80104551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104558:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010455b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104562:	e8 09 fd ff ff       	call   80104270 <sched>
    p->chan = 0;
80104567:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010456e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104571:	5b                   	pop    %ebx
80104572:	5e                   	pop    %esi
80104573:	5f                   	pop    %edi
80104574:	5d                   	pop    %ebp
80104575:	c3                   	ret    
        panic("sleep without lk");
80104576:	83 ec 0c             	sub    $0xc,%esp
80104579:	68 8f 85 10 80       	push   $0x8010858f
8010457e:	e8 0d be ff ff       	call   80100390 <panic>
        panic("sleep");
80104583:	83 ec 0c             	sub    $0xc,%esp
80104586:	68 89 85 10 80       	push   $0x80108589
8010458b:	e8 00 be ff ff       	call   80100390 <panic>

80104590 <wait>:
wait(void) {
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	56                   	push   %esi
80104595:	53                   	push   %ebx
80104596:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104599:	e8 62 05 00 00       	call   80104b00 <pushcli>
    c = mycpu();
8010459e:	e8 bd f6 ff ff       	call   80103c60 <mycpu>
    p = c->proc;
801045a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801045a9:	e8 52 06 00 00       	call   80104c00 <popcli>
    acquire(&ptable.lock);
801045ae:	83 ec 0c             	sub    $0xc,%esp
801045b1:	68 40 4d 11 80       	push   $0x80114d40
801045b6:	e8 85 05 00 00       	call   80104b40 <acquire>
801045bb:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
801045be:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045c0:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
801045c5:	eb 17                	jmp    801045de <wait+0x4e>
801045c7:	89 f6                	mov    %esi,%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801045d0:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
801045d6:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
801045dc:	73 1e                	jae    801045fc <wait+0x6c>
            if (p->parent != curproc)
801045de:	39 73 14             	cmp    %esi,0x14(%ebx)
801045e1:	75 ed                	jne    801045d0 <wait+0x40>
            if (p->state == ZOMBIE) {
801045e3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801045e7:	74 3f                	je     80104628 <wait+0x98>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045e9:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
            havekids = 1;
801045ef:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045f4:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
801045fa:	72 e2                	jb     801045de <wait+0x4e>
        if (!havekids || curproc->killed) {
801045fc:	85 c0                	test   %eax,%eax
801045fe:	0f 84 23 01 00 00    	je     80104727 <wait+0x197>
80104604:	8b 46 24             	mov    0x24(%esi),%eax
80104607:	85 c0                	test   %eax,%eax
80104609:	0f 85 18 01 00 00    	jne    80104727 <wait+0x197>
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010460f:	83 ec 08             	sub    $0x8,%esp
80104612:	68 40 4d 11 80       	push   $0x80114d40
80104617:	56                   	push   %esi
80104618:	e8 b3 fe ff ff       	call   801044d0 <sleep>
        havekids = 0;
8010461d:	83 c4 10             	add    $0x10,%esp
80104620:	eb 9c                	jmp    801045be <wait+0x2e>
80104622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                kfree(p->kstack);
80104628:	83 ec 0c             	sub    $0xc,%esp
                pid = p->pid;
8010462b:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
8010462e:	ff 73 08             	pushl  0x8(%ebx)
80104631:	8d bb 40 04 00 00    	lea    0x440(%ebx),%edi
80104637:	e8 24 e1 ff ff       	call   80102760 <kfree>
                p->kstack = 0;
8010463c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104643:	5a                   	pop    %edx
80104644:	ff 73 04             	pushl  0x4(%ebx)
80104647:	e8 e4 34 00 00       	call   80107b30 <freevm>
8010464c:	8d 8b 00 04 00 00    	lea    0x400(%ebx),%ecx
                p->pid = 0;
80104652:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80104659:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104660:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
80104664:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
8010466b:	83 c4 10             	add    $0x10,%esp
                p->state = UNUSED;
8010466e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->pagesCounter = -1;
80104675:	c7 83 44 04 00 00 ff 	movl   $0xffffffff,0x444(%ebx)
8010467c:	ff ff ff 
8010467f:	89 ca                	mov    %ecx,%edx
                p->nextpageid = 0;
80104681:	c7 83 40 04 00 00 00 	movl   $0x0,0x440(%ebx)
80104688:	00 00 00 
                p->pagesequel = 0;
8010468b:	c7 83 4c 04 00 00 00 	movl   $0x0,0x44c(%ebx)
80104692:	00 00 00 
                p->pagesinSwap = 0;
80104695:	89 c8                	mov    %ecx,%eax
80104697:	c7 83 48 04 00 00 00 	movl   $0x0,0x448(%ebx)
8010469e:	00 00 00 
801046a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    p->swapFileEntries[k]=0;
801046a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801046ae:	83 c0 04             	add    $0x4,%eax
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
801046b1:	39 c7                	cmp    %eax,%edi
801046b3:	75 f3                	jne    801046a8 <wait+0x118>
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801046b5:	83 eb 80             	sub    $0xffffff80,%ebx
801046b8:	90                   	nop
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    pg->active = 0;
801046c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
                    pg->offset = 0;
801046c6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801046cd:	83 c3 1c             	add    $0x1c,%ebx
                    pg->pageid = 0;
801046d0:	c7 43 e8 00 00 00 00 	movl   $0x0,-0x18(%ebx)
                    pg->present = -1;
801046d7:	c7 43 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebx)
                    pg->sequel = -1;
801046de:	c7 43 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebx)
                    pg->physAdress = 0;
801046e5:	c7 43 f8 00 00 00 00 	movl   $0x0,-0x8(%ebx)
                    pg->virtAdress = 0;
801046ec:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
801046f3:	39 cb                	cmp    %ecx,%ebx
801046f5:	72 c9                	jb     801046c0 <wait+0x130>
801046f7:	89 f6                	mov    %esi,%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                    p->swapFileEntries[k]=0;
80104700:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
80104706:	83 c2 04             	add    $0x4,%edx
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
80104709:	39 d0                	cmp    %edx,%eax
8010470b:	75 f3                	jne    80104700 <wait+0x170>
                release(&ptable.lock);
8010470d:	83 ec 0c             	sub    $0xc,%esp
80104710:	68 40 4d 11 80       	push   $0x80114d40
80104715:	e8 46 05 00 00       	call   80104c60 <release>
                return pid;
8010471a:	83 c4 10             	add    $0x10,%esp
}
8010471d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104720:	89 f0                	mov    %esi,%eax
80104722:	5b                   	pop    %ebx
80104723:	5e                   	pop    %esi
80104724:	5f                   	pop    %edi
80104725:	5d                   	pop    %ebp
80104726:	c3                   	ret    
            release(&ptable.lock);
80104727:	83 ec 0c             	sub    $0xc,%esp
            return -1;
8010472a:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
8010472f:	68 40 4d 11 80       	push   $0x80114d40
80104734:	e8 27 05 00 00       	call   80104c60 <release>
            return -1;
80104739:	83 c4 10             	add    $0x10,%esp
8010473c:	eb df                	jmp    8010471d <wait+0x18d>
8010473e:	66 90                	xchg   %ax,%ax

80104740 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	53                   	push   %ebx
80104744:	83 ec 10             	sub    $0x10,%esp
80104747:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010474a:	68 40 4d 11 80       	push   $0x80114d40
8010474f:	e8 ec 03 00 00       	call   80104b40 <acquire>
80104754:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104757:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
8010475c:	eb 0e                	jmp    8010476c <wakeup+0x2c>
8010475e:	66 90                	xchg   %ax,%ax
80104760:	05 5c 04 00 00       	add    $0x45c,%eax
80104765:	3d 74 64 12 80       	cmp    $0x80126474,%eax
8010476a:	73 1e                	jae    8010478a <wakeup+0x4a>
        if (p->state == SLEEPING && p->chan == chan)
8010476c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104770:	75 ee                	jne    80104760 <wakeup+0x20>
80104772:	3b 58 20             	cmp    0x20(%eax),%ebx
80104775:	75 e9                	jne    80104760 <wakeup+0x20>
            p->state = RUNNABLE;
80104777:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010477e:	05 5c 04 00 00       	add    $0x45c,%eax
80104783:	3d 74 64 12 80       	cmp    $0x80126474,%eax
80104788:	72 e2                	jb     8010476c <wakeup+0x2c>
    wakeup1(chan);
    release(&ptable.lock);
8010478a:	c7 45 08 40 4d 11 80 	movl   $0x80114d40,0x8(%ebp)
}
80104791:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104794:	c9                   	leave  
    release(&ptable.lock);
80104795:	e9 c6 04 00 00       	jmp    80104c60 <release>
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 10             	sub    $0x10,%esp
801047a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
801047aa:	68 40 4d 11 80       	push   $0x80114d40
801047af:	e8 8c 03 00 00       	call   80104b40 <acquire>
801047b4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801047b7:	b8 74 4d 11 80       	mov    $0x80114d74,%eax
801047bc:	eb 0e                	jmp    801047cc <kill+0x2c>
801047be:	66 90                	xchg   %ax,%ax
801047c0:	05 5c 04 00 00       	add    $0x45c,%eax
801047c5:	3d 74 64 12 80       	cmp    $0x80126474,%eax
801047ca:	73 34                	jae    80104800 <kill+0x60>
        if (p->pid == pid) {
801047cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801047cf:	75 ef                	jne    801047c0 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
801047d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
801047d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
801047dc:	75 07                	jne    801047e5 <kill+0x45>
                p->state = RUNNABLE;
801047de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            release(&ptable.lock);
801047e5:	83 ec 0c             	sub    $0xc,%esp
801047e8:	68 40 4d 11 80       	push   $0x80114d40
801047ed:	e8 6e 04 00 00       	call   80104c60 <release>
            return 0;
801047f2:	83 c4 10             	add    $0x10,%esp
801047f5:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801047f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047fa:	c9                   	leave  
801047fb:	c3                   	ret    
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80104800:	83 ec 0c             	sub    $0xc,%esp
80104803:	68 40 4d 11 80       	push   $0x80114d40
80104808:	e8 53 04 00 00       	call   80104c60 <release>
    return -1;
8010480d:	83 c4 10             	add    $0x10,%esp
80104810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104815:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104818:	c9                   	leave  
80104819:	c3                   	ret    
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104820 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	53                   	push   %ebx
80104826:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int currentFreePages = 0;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104829:	bb 74 4d 11 80       	mov    $0x80114d74,%ebx
procdump(void) {
8010482e:	83 ec 3c             	sub    $0x3c,%esp
80104831:	eb 27                	jmp    8010485a <procdump+0x3a>
80104833:	90                   	nop
80104834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80104838:	83 ec 0c             	sub    $0xc,%esp
8010483b:	68 ad 8a 10 80       	push   $0x80108aad
80104840:	e8 1b be ff ff       	call   80100660 <cprintf>
80104845:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104848:	81 c3 5c 04 00 00    	add    $0x45c,%ebx
8010484e:	81 fb 74 64 12 80    	cmp    $0x80126474,%ebx
80104854:	0f 83 b6 00 00 00    	jae    80104910 <procdump+0xf0>
        if (p->state == UNUSED)
8010485a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010485d:	85 c0                	test   %eax,%eax
8010485f:	74 e7                	je     80104848 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104861:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104864:	ba a0 85 10 80       	mov    $0x801085a0,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104869:	77 11                	ja     8010487c <procdump+0x5c>
8010486b:	8b 14 85 34 86 10 80 	mov    -0x7fef79cc(,%eax,4),%edx
            state = "???";
80104872:	b8 a0 85 10 80       	mov    $0x801085a0,%eax
80104877:	85 d2                	test   %edx,%edx
80104879:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %d %d %d %d %d %s", p->pid, state, p->name,
8010487c:	8b 83 48 04 00 00    	mov    0x448(%ebx),%eax
80104882:	8b 8b 44 04 00 00    	mov    0x444(%ebx),%ecx
80104888:	83 ec 0c             	sub    $0xc,%esp
8010488b:	ff b3 58 04 00 00    	pushl  0x458(%ebx)
80104891:	ff b3 54 04 00 00    	pushl  0x454(%ebx)
80104897:	ff b3 50 04 00 00    	pushl  0x450(%ebx)
8010489d:	29 c1                	sub    %eax,%ecx
8010489f:	50                   	push   %eax
801048a0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801048a3:	51                   	push   %ecx
801048a4:	50                   	push   %eax
801048a5:	52                   	push   %edx
801048a6:	ff 73 10             	pushl  0x10(%ebx)
801048a9:	68 a4 85 10 80       	push   $0x801085a4
801048ae:	e8 ad bd ff ff       	call   80100660 <cprintf>
        if (p->state == SLEEPING) {
801048b3:	83 c4 30             	add    $0x30,%esp
801048b6:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801048ba:	0f 85 78 ff ff ff    	jne    80104838 <procdump+0x18>
            getcallerpcs((uint *) p->context->ebp + 2, pc);
801048c0:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048c3:	83 ec 08             	sub    $0x8,%esp
801048c6:	8d 7d c0             	lea    -0x40(%ebp),%edi
801048c9:	50                   	push   %eax
801048ca:	8b 43 1c             	mov    0x1c(%ebx),%eax
801048cd:	8b 40 0c             	mov    0xc(%eax),%eax
801048d0:	83 c0 08             	add    $0x8,%eax
801048d3:	50                   	push   %eax
801048d4:	e8 97 01 00 00       	call   80104a70 <getcallerpcs>
801048d9:	83 c4 10             	add    $0x10,%esp
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            for (i = 0; i < 10 && pc[i] != 0; i++)
801048e0:	8b 17                	mov    (%edi),%edx
801048e2:	85 d2                	test   %edx,%edx
801048e4:	0f 84 4e ff ff ff    	je     80104838 <procdump+0x18>
                cprintf(" %p", pc[i]);
801048ea:	83 ec 08             	sub    $0x8,%esp
801048ed:	83 c7 04             	add    $0x4,%edi
801048f0:	52                   	push   %edx
801048f1:	68 a1 7f 10 80       	push   $0x80107fa1
801048f6:	e8 65 bd ff ff       	call   80100660 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801048fb:	83 c4 10             	add    $0x10,%esp
801048fe:	39 fe                	cmp    %edi,%esi
80104900:	75 de                	jne    801048e0 <procdump+0xc0>
80104902:	e9 31 ff ff ff       	jmp    80104838 <procdump+0x18>
80104907:	89 f6                	mov    %esi,%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
    currentFreePages = kallocCount();
80104910:	e8 cb dd ff ff       	call   801026e0 <kallocCount>
    currentFreePages = 100 * currentFreePages;
80104915:	6b c0 64             	imul   $0x64,%eax,%eax
    cprintf(" %d / %d free pages in the system", currentFreePages, totalAvailablePages);
80104918:	83 ec 04             	sub    $0x4,%esp
8010491b:	ff 35 b8 b5 10 80    	pushl  0x8010b5b8
80104921:	50                   	push   %eax
80104922:	68 10 86 10 80       	push   $0x80108610
80104927:	e8 34 bd ff ff       	call   80100660 <cprintf>
}
8010492c:	83 c4 10             	add    $0x10,%esp
8010492f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104932:	5b                   	pop    %ebx
80104933:	5e                   	pop    %esi
80104934:	5f                   	pop    %edi
80104935:	5d                   	pop    %ebp
80104936:	c3                   	ret    
80104937:	66 90                	xchg   %ax,%ax
80104939:	66 90                	xchg   %ax,%ax
8010493b:	66 90                	xchg   %ax,%ax
8010493d:	66 90                	xchg   %ax,%ax
8010493f:	90                   	nop

80104940 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 0c             	sub    $0xc,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010494a:	68 4c 86 10 80       	push   $0x8010864c
8010494f:	8d 43 04             	lea    0x4(%ebx),%eax
80104952:	50                   	push   %eax
80104953:	e8 f8 00 00 00       	call   80104a50 <initlock>
  lk->name = name;
80104958:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010495b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104961:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104964:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010496b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010496e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104971:	c9                   	leave  
80104972:	c3                   	ret    
80104973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104988:	83 ec 0c             	sub    $0xc,%esp
8010498b:	8d 73 04             	lea    0x4(%ebx),%esi
8010498e:	56                   	push   %esi
8010498f:	e8 ac 01 00 00       	call   80104b40 <acquire>
  while (lk->locked) {
80104994:	8b 13                	mov    (%ebx),%edx
80104996:	83 c4 10             	add    $0x10,%esp
80104999:	85 d2                	test   %edx,%edx
8010499b:	74 16                	je     801049b3 <acquiresleep+0x33>
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049a0:	83 ec 08             	sub    $0x8,%esp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	e8 26 fb ff ff       	call   801044d0 <sleep>
  while (lk->locked) {
801049aa:	8b 03                	mov    (%ebx),%eax
801049ac:	83 c4 10             	add    $0x10,%esp
801049af:	85 c0                	test   %eax,%eax
801049b1:	75 ed                	jne    801049a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801049b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049b9:	e8 42 f3 ff ff       	call   80103d00 <myproc>
801049be:	8b 40 10             	mov    0x10(%eax),%eax
801049c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049ca:	5b                   	pop    %ebx
801049cb:	5e                   	pop    %esi
801049cc:	5d                   	pop    %ebp
  release(&lk->lk);
801049cd:	e9 8e 02 00 00       	jmp    80104c60 <release>
801049d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	8d 73 04             	lea    0x4(%ebx),%esi
801049ee:	56                   	push   %esi
801049ef:	e8 4c 01 00 00       	call   80104b40 <acquire>
  lk->locked = 0;
801049f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a01:	89 1c 24             	mov    %ebx,(%esp)
80104a04:	e8 37 fd ff ff       	call   80104740 <wakeup>
  release(&lk->lk);
80104a09:	89 75 08             	mov    %esi,0x8(%ebp)
80104a0c:	83 c4 10             	add    $0x10,%esp
}
80104a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a12:	5b                   	pop    %ebx
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
  release(&lk->lk);
80104a15:	e9 46 02 00 00       	jmp    80104c60 <release>
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104a28:	83 ec 0c             	sub    $0xc,%esp
80104a2b:	8d 5e 04             	lea    0x4(%esi),%ebx
80104a2e:	53                   	push   %ebx
80104a2f:	e8 0c 01 00 00       	call   80104b40 <acquire>
  r = lk->locked;
80104a34:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104a36:	89 1c 24             	mov    %ebx,(%esp)
80104a39:	e8 22 02 00 00       	call   80104c60 <release>
  return r;
}
80104a3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a41:	89 f0                	mov    %esi,%eax
80104a43:	5b                   	pop    %ebx
80104a44:	5e                   	pop    %esi
80104a45:	5d                   	pop    %ebp
80104a46:	c3                   	ret    
80104a47:	66 90                	xchg   %ax,%ax
80104a49:	66 90                	xchg   %ax,%ax
80104a4b:	66 90                	xchg   %ax,%ax
80104a4d:	66 90                	xchg   %ax,%ax
80104a4f:	90                   	nop

80104a50 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a5f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a69:	5d                   	pop    %ebp
80104a6a:	c3                   	ret    
80104a6b:	90                   	nop
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a70 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a70:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a71:	31 d2                	xor    %edx,%edx
{
80104a73:	89 e5                	mov    %esp,%ebp
80104a75:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a76:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a7c:	83 e8 08             	sub    $0x8,%eax
80104a7f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a80:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a86:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a8c:	77 1a                	ja     80104aa8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a8e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a91:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a94:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a97:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a99:	83 fa 0a             	cmp    $0xa,%edx
80104a9c:	75 e2                	jne    80104a80 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a9e:	5b                   	pop    %ebx
80104a9f:	5d                   	pop    %ebp
80104aa0:	c3                   	ret    
80104aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aa8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104aab:	83 c1 28             	add    $0x28,%ecx
80104aae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ab0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ab6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ab9:	39 c1                	cmp    %eax,%ecx
80104abb:	75 f3                	jne    80104ab0 <getcallerpcs+0x40>
}
80104abd:	5b                   	pop    %ebx
80104abe:	5d                   	pop    %ebp
80104abf:	c3                   	ret    

80104ac0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
80104ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104aca:	8b 02                	mov    (%edx),%eax
80104acc:	85 c0                	test   %eax,%eax
80104ace:	75 10                	jne    80104ae0 <holding+0x20>
}
80104ad0:	83 c4 04             	add    $0x4,%esp
80104ad3:	31 c0                	xor    %eax,%eax
80104ad5:	5b                   	pop    %ebx
80104ad6:	5d                   	pop    %ebp
80104ad7:	c3                   	ret    
80104ad8:	90                   	nop
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104ae0:	8b 5a 08             	mov    0x8(%edx),%ebx
80104ae3:	e8 78 f1 ff ff       	call   80103c60 <mycpu>
80104ae8:	39 c3                	cmp    %eax,%ebx
80104aea:	0f 94 c0             	sete   %al
}
80104aed:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104af0:	0f b6 c0             	movzbl %al,%eax
}
80104af3:	5b                   	pop    %ebx
80104af4:	5d                   	pop    %ebp
80104af5:	c3                   	ret    
80104af6:	8d 76 00             	lea    0x0(%esi),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 04             	sub    $0x4,%esp
80104b07:	9c                   	pushf  
80104b08:	5b                   	pop    %ebx
  asm volatile("cli");
80104b09:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b0a:	e8 51 f1 ff ff       	call   80103c60 <mycpu>
80104b0f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b15:	85 c0                	test   %eax,%eax
80104b17:	75 11                	jne    80104b2a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b19:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b1f:	e8 3c f1 ff ff       	call   80103c60 <mycpu>
80104b24:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b2a:	e8 31 f1 ff ff       	call   80103c60 <mycpu>
80104b2f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b36:	83 c4 04             	add    $0x4,%esp
80104b39:	5b                   	pop    %ebx
80104b3a:	5d                   	pop    %ebp
80104b3b:	c3                   	ret    
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b40 <acquire>:
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	56                   	push   %esi
80104b44:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b45:	e8 b6 ff ff ff       	call   80104b00 <pushcli>
  if(holding(lk))
80104b4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104b4d:	8b 03                	mov    (%ebx),%eax
80104b4f:	85 c0                	test   %eax,%eax
80104b51:	0f 85 81 00 00 00    	jne    80104bd8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104b57:	ba 01 00 00 00       	mov    $0x1,%edx
80104b5c:	eb 05                	jmp    80104b63 <acquire+0x23>
80104b5e:	66 90                	xchg   %ax,%ax
80104b60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b63:	89 d0                	mov    %edx,%eax
80104b65:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104b68:	85 c0                	test   %eax,%eax
80104b6a:	75 f4                	jne    80104b60 <acquire+0x20>
  __sync_synchronize();
80104b6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b74:	e8 e7 f0 ff ff       	call   80103c60 <mycpu>
  for(i = 0; i < 10; i++){
80104b79:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
80104b7b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
80104b7e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104b81:	89 e8                	mov    %ebp,%eax
80104b83:	90                   	nop
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b88:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b8e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b94:	77 1a                	ja     80104bb0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104b96:	8b 58 04             	mov    0x4(%eax),%ebx
80104b99:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b9c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b9f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ba1:	83 fa 0a             	cmp    $0xa,%edx
80104ba4:	75 e2                	jne    80104b88 <acquire+0x48>
}
80104ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ba9:	5b                   	pop    %ebx
80104baa:	5e                   	pop    %esi
80104bab:	5d                   	pop    %ebp
80104bac:	c3                   	ret    
80104bad:	8d 76 00             	lea    0x0(%esi),%esi
80104bb0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104bb3:	83 c1 28             	add    $0x28,%ecx
80104bb6:	8d 76 00             	lea    0x0(%esi),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104bc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104bc6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104bc9:	39 c8                	cmp    %ecx,%eax
80104bcb:	75 f3                	jne    80104bc0 <acquire+0x80>
}
80104bcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bd0:	5b                   	pop    %ebx
80104bd1:	5e                   	pop    %esi
80104bd2:	5d                   	pop    %ebp
80104bd3:	c3                   	ret    
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104bd8:	8b 73 08             	mov    0x8(%ebx),%esi
80104bdb:	e8 80 f0 ff ff       	call   80103c60 <mycpu>
80104be0:	39 c6                	cmp    %eax,%esi
80104be2:	0f 85 6f ff ff ff    	jne    80104b57 <acquire+0x17>
    panic("acquire");
80104be8:	83 ec 0c             	sub    $0xc,%esp
80104beb:	68 57 86 10 80       	push   $0x80108657
80104bf0:	e8 9b b7 ff ff       	call   80100390 <panic>
80104bf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <popcli>:

void
popcli(void)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c06:	9c                   	pushf  
80104c07:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c08:	f6 c4 02             	test   $0x2,%ah
80104c0b:	75 35                	jne    80104c42 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c0d:	e8 4e f0 ff ff       	call   80103c60 <mycpu>
80104c12:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c19:	78 34                	js     80104c4f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c1b:	e8 40 f0 ff ff       	call   80103c60 <mycpu>
80104c20:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c26:	85 d2                	test   %edx,%edx
80104c28:	74 06                	je     80104c30 <popcli+0x30>
    sti();
}
80104c2a:	c9                   	leave  
80104c2b:	c3                   	ret    
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c30:	e8 2b f0 ff ff       	call   80103c60 <mycpu>
80104c35:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c3b:	85 c0                	test   %eax,%eax
80104c3d:	74 eb                	je     80104c2a <popcli+0x2a>
  asm volatile("sti");
80104c3f:	fb                   	sti    
}
80104c40:	c9                   	leave  
80104c41:	c3                   	ret    
    panic("popcli - interruptible");
80104c42:	83 ec 0c             	sub    $0xc,%esp
80104c45:	68 5f 86 10 80       	push   $0x8010865f
80104c4a:	e8 41 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104c4f:	83 ec 0c             	sub    $0xc,%esp
80104c52:	68 76 86 10 80       	push   $0x80108676
80104c57:	e8 34 b7 ff ff       	call   80100390 <panic>
80104c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c60 <release>:
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
80104c65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104c68:	8b 03                	mov    (%ebx),%eax
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	74 0c                	je     80104c7a <release+0x1a>
80104c6e:	8b 73 08             	mov    0x8(%ebx),%esi
80104c71:	e8 ea ef ff ff       	call   80103c60 <mycpu>
80104c76:	39 c6                	cmp    %eax,%esi
80104c78:	74 16                	je     80104c90 <release+0x30>
    panic("release");
80104c7a:	83 ec 0c             	sub    $0xc,%esp
80104c7d:	68 7d 86 10 80       	push   $0x8010867d
80104c82:	e8 09 b7 ff ff       	call   80100390 <panic>
80104c87:	89 f6                	mov    %esi,%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104c90:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c97:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c9e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104ca3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ca9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cac:	5b                   	pop    %ebx
80104cad:	5e                   	pop    %esi
80104cae:	5d                   	pop    %ebp
  popcli();
80104caf:	e9 4c ff ff ff       	jmp    80104c00 <popcli>
80104cb4:	66 90                	xchg   %ax,%ax
80104cb6:	66 90                	xchg   %ax,%ax
80104cb8:	66 90                	xchg   %ax,%ax
80104cba:	66 90                	xchg   %ax,%ax
80104cbc:	66 90                	xchg   %ax,%ax
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104ccb:	f6 c2 03             	test   $0x3,%dl
80104cce:	75 05                	jne    80104cd5 <memset+0x15>
80104cd0:	f6 c1 03             	test   $0x3,%cl
80104cd3:	74 13                	je     80104ce8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104cd5:	89 d7                	mov    %edx,%edi
80104cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cda:	fc                   	cld    
80104cdb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104cdd:	5b                   	pop    %ebx
80104cde:	89 d0                	mov    %edx,%eax
80104ce0:	5f                   	pop    %edi
80104ce1:	5d                   	pop    %ebp
80104ce2:	c3                   	ret    
80104ce3:	90                   	nop
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104ce8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cec:	c1 e9 02             	shr    $0x2,%ecx
80104cef:	89 f8                	mov    %edi,%eax
80104cf1:	89 fb                	mov    %edi,%ebx
80104cf3:	c1 e0 18             	shl    $0x18,%eax
80104cf6:	c1 e3 10             	shl    $0x10,%ebx
80104cf9:	09 d8                	or     %ebx,%eax
80104cfb:	09 f8                	or     %edi,%eax
80104cfd:	c1 e7 08             	shl    $0x8,%edi
80104d00:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d02:	89 d7                	mov    %edx,%edi
80104d04:	fc                   	cld    
80104d05:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104d07:	5b                   	pop    %ebx
80104d08:	89 d0                	mov    %edx,%eax
80104d0a:	5f                   	pop    %edi
80104d0b:	5d                   	pop    %ebp
80104d0c:	c3                   	ret    
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi

80104d10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
80104d15:	53                   	push   %ebx
80104d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d19:	8b 75 08             	mov    0x8(%ebp),%esi
80104d1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d1f:	85 db                	test   %ebx,%ebx
80104d21:	74 29                	je     80104d4c <memcmp+0x3c>
    if(*s1 != *s2)
80104d23:	0f b6 16             	movzbl (%esi),%edx
80104d26:	0f b6 0f             	movzbl (%edi),%ecx
80104d29:	38 d1                	cmp    %dl,%cl
80104d2b:	75 2b                	jne    80104d58 <memcmp+0x48>
80104d2d:	b8 01 00 00 00       	mov    $0x1,%eax
80104d32:	eb 14                	jmp    80104d48 <memcmp+0x38>
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d38:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d3c:	83 c0 01             	add    $0x1,%eax
80104d3f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104d44:	38 ca                	cmp    %cl,%dl
80104d46:	75 10                	jne    80104d58 <memcmp+0x48>
  while(n-- > 0){
80104d48:	39 d8                	cmp    %ebx,%eax
80104d4a:	75 ec                	jne    80104d38 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d4c:	5b                   	pop    %ebx
  return 0;
80104d4d:	31 c0                	xor    %eax,%eax
}
80104d4f:	5e                   	pop    %esi
80104d50:	5f                   	pop    %edi
80104d51:	5d                   	pop    %ebp
80104d52:	c3                   	ret    
80104d53:	90                   	nop
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104d58:	0f b6 c2             	movzbl %dl,%eax
}
80104d5b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104d5c:	29 c8                	sub    %ecx,%eax
}
80104d5e:	5e                   	pop    %esi
80104d5f:	5f                   	pop    %edi
80104d60:	5d                   	pop    %ebp
80104d61:	c3                   	ret    
80104d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	8b 45 08             	mov    0x8(%ebp),%eax
80104d78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d7b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d7e:	39 c3                	cmp    %eax,%ebx
80104d80:	73 26                	jae    80104da8 <memmove+0x38>
80104d82:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104d85:	39 c8                	cmp    %ecx,%eax
80104d87:	73 1f                	jae    80104da8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104d89:	85 f6                	test   %esi,%esi
80104d8b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104d8e:	74 0f                	je     80104d9f <memmove+0x2f>
      *--d = *--s;
80104d90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104d97:	83 ea 01             	sub    $0x1,%edx
80104d9a:	83 fa ff             	cmp    $0xffffffff,%edx
80104d9d:	75 f1                	jne    80104d90 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d9f:	5b                   	pop    %ebx
80104da0:	5e                   	pop    %esi
80104da1:	5d                   	pop    %ebp
80104da2:	c3                   	ret    
80104da3:	90                   	nop
80104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104da8:	31 d2                	xor    %edx,%edx
80104daa:	85 f6                	test   %esi,%esi
80104dac:	74 f1                	je     80104d9f <memmove+0x2f>
80104dae:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104db0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104db4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104db7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104dba:	39 d6                	cmp    %edx,%esi
80104dbc:	75 f2                	jne    80104db0 <memmove+0x40>
}
80104dbe:	5b                   	pop    %ebx
80104dbf:	5e                   	pop    %esi
80104dc0:	5d                   	pop    %ebp
80104dc1:	c3                   	ret    
80104dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104dd3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104dd4:	eb 9a                	jmp    80104d70 <memmove>
80104dd6:	8d 76 00             	lea    0x0(%esi),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
80104de5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104de8:	53                   	push   %ebx
80104de9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104def:	85 ff                	test   %edi,%edi
80104df1:	74 2f                	je     80104e22 <strncmp+0x42>
80104df3:	0f b6 01             	movzbl (%ecx),%eax
80104df6:	0f b6 1e             	movzbl (%esi),%ebx
80104df9:	84 c0                	test   %al,%al
80104dfb:	74 37                	je     80104e34 <strncmp+0x54>
80104dfd:	38 c3                	cmp    %al,%bl
80104dff:	75 33                	jne    80104e34 <strncmp+0x54>
80104e01:	01 f7                	add    %esi,%edi
80104e03:	eb 13                	jmp    80104e18 <strncmp+0x38>
80104e05:	8d 76 00             	lea    0x0(%esi),%esi
80104e08:	0f b6 01             	movzbl (%ecx),%eax
80104e0b:	84 c0                	test   %al,%al
80104e0d:	74 21                	je     80104e30 <strncmp+0x50>
80104e0f:	0f b6 1a             	movzbl (%edx),%ebx
80104e12:	89 d6                	mov    %edx,%esi
80104e14:	38 d8                	cmp    %bl,%al
80104e16:	75 1c                	jne    80104e34 <strncmp+0x54>
    n--, p++, q++;
80104e18:	8d 56 01             	lea    0x1(%esi),%edx
80104e1b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e1e:	39 fa                	cmp    %edi,%edx
80104e20:	75 e6                	jne    80104e08 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e22:	5b                   	pop    %ebx
    return 0;
80104e23:	31 c0                	xor    %eax,%eax
}
80104e25:	5e                   	pop    %esi
80104e26:	5f                   	pop    %edi
80104e27:	5d                   	pop    %ebp
80104e28:	c3                   	ret    
80104e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e30:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e34:	29 d8                	sub    %ebx,%eax
}
80104e36:	5b                   	pop    %ebx
80104e37:	5e                   	pop    %esi
80104e38:	5f                   	pop    %edi
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret    
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
80104e45:	8b 45 08             	mov    0x8(%ebp),%eax
80104e48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e4e:	89 c2                	mov    %eax,%edx
80104e50:	eb 19                	jmp    80104e6b <strncpy+0x2b>
80104e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e58:	83 c3 01             	add    $0x1,%ebx
80104e5b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e5f:	83 c2 01             	add    $0x1,%edx
80104e62:	84 c9                	test   %cl,%cl
80104e64:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e67:	74 09                	je     80104e72 <strncpy+0x32>
80104e69:	89 f1                	mov    %esi,%ecx
80104e6b:	85 c9                	test   %ecx,%ecx
80104e6d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104e70:	7f e6                	jg     80104e58 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e72:	31 c9                	xor    %ecx,%ecx
80104e74:	85 f6                	test   %esi,%esi
80104e76:	7e 17                	jle    80104e8f <strncpy+0x4f>
80104e78:	90                   	nop
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e80:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104e84:	89 f3                	mov    %esi,%ebx
80104e86:	83 c1 01             	add    $0x1,%ecx
80104e89:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104e8b:	85 db                	test   %ebx,%ebx
80104e8d:	7f f1                	jg     80104e80 <strncpy+0x40>
  return os;
}
80104e8f:	5b                   	pop    %ebx
80104e90:	5e                   	pop    %esi
80104e91:	5d                   	pop    %ebp
80104e92:	c3                   	ret    
80104e93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80104eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104eae:	85 c9                	test   %ecx,%ecx
80104eb0:	7e 26                	jle    80104ed8 <safestrcpy+0x38>
80104eb2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104eb6:	89 c1                	mov    %eax,%ecx
80104eb8:	eb 17                	jmp    80104ed1 <safestrcpy+0x31>
80104eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ec0:	83 c2 01             	add    $0x1,%edx
80104ec3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ec7:	83 c1 01             	add    $0x1,%ecx
80104eca:	84 db                	test   %bl,%bl
80104ecc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104ecf:	74 04                	je     80104ed5 <safestrcpy+0x35>
80104ed1:	39 f2                	cmp    %esi,%edx
80104ed3:	75 eb                	jne    80104ec0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ed5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ed8:	5b                   	pop    %ebx
80104ed9:	5e                   	pop    %esi
80104eda:	5d                   	pop    %ebp
80104edb:	c3                   	ret    
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <strlen>:

int
strlen(const char *s)
{
80104ee0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ee1:	31 c0                	xor    %eax,%eax
{
80104ee3:	89 e5                	mov    %esp,%ebp
80104ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ee8:	80 3a 00             	cmpb   $0x0,(%edx)
80104eeb:	74 0c                	je     80104ef9 <strlen+0x19>
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
80104ef0:	83 c0 01             	add    $0x1,%eax
80104ef3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ef7:	75 f7                	jne    80104ef0 <strlen+0x10>
    ;
  return n;
}
80104ef9:	5d                   	pop    %ebp
80104efa:	c3                   	ret    

80104efb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104efb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104eff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104f03:	55                   	push   %ebp
  pushl %ebx
80104f04:	53                   	push   %ebx
  pushl %esi
80104f05:	56                   	push   %esi
  pushl %edi
80104f06:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f07:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f09:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104f0b:	5f                   	pop    %edi
  popl %esi
80104f0c:	5e                   	pop    %esi
  popl %ebx
80104f0d:	5b                   	pop    %ebx
  popl %ebp
80104f0e:	5d                   	pop    %ebp
  ret
80104f0f:	c3                   	ret    

80104f10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	53                   	push   %ebx
80104f14:	83 ec 04             	sub    $0x4,%esp
80104f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f1a:	e8 e1 ed ff ff       	call   80103d00 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f1f:	8b 00                	mov    (%eax),%eax
80104f21:	39 d8                	cmp    %ebx,%eax
80104f23:	76 1b                	jbe    80104f40 <fetchint+0x30>
80104f25:	8d 53 04             	lea    0x4(%ebx),%edx
80104f28:	39 d0                	cmp    %edx,%eax
80104f2a:	72 14                	jb     80104f40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f2f:	8b 13                	mov    (%ebx),%edx
80104f31:	89 10                	mov    %edx,(%eax)
  return 0;
80104f33:	31 c0                	xor    %eax,%eax
}
80104f35:	83 c4 04             	add    $0x4,%esp
80104f38:	5b                   	pop    %ebx
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    
80104f3b:	90                   	nop
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f45:	eb ee                	jmp    80104f35 <fetchint+0x25>
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	53                   	push   %ebx
80104f54:	83 ec 04             	sub    $0x4,%esp
80104f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f5a:	e8 a1 ed ff ff       	call   80103d00 <myproc>

  if(addr >= curproc->sz)
80104f5f:	39 18                	cmp    %ebx,(%eax)
80104f61:	76 29                	jbe    80104f8c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f66:	89 da                	mov    %ebx,%edx
80104f68:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104f6a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104f6c:	39 c3                	cmp    %eax,%ebx
80104f6e:	73 1c                	jae    80104f8c <fetchstr+0x3c>
    if(*s == 0)
80104f70:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f73:	75 10                	jne    80104f85 <fetchstr+0x35>
80104f75:	eb 39                	jmp    80104fb0 <fetchstr+0x60>
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f80:	80 3a 00             	cmpb   $0x0,(%edx)
80104f83:	74 1b                	je     80104fa0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104f85:	83 c2 01             	add    $0x1,%edx
80104f88:	39 d0                	cmp    %edx,%eax
80104f8a:	77 f4                	ja     80104f80 <fetchstr+0x30>
    return -1;
80104f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104f91:	83 c4 04             	add    $0x4,%esp
80104f94:	5b                   	pop    %ebx
80104f95:	5d                   	pop    %ebp
80104f96:	c3                   	ret    
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fa0:	83 c4 04             	add    $0x4,%esp
80104fa3:	89 d0                	mov    %edx,%eax
80104fa5:	29 d8                	sub    %ebx,%eax
80104fa7:	5b                   	pop    %ebx
80104fa8:	5d                   	pop    %ebp
80104fa9:	c3                   	ret    
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104fb0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104fb2:	eb dd                	jmp    80104f91 <fetchstr+0x41>
80104fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104fc0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fc5:	e8 36 ed ff ff       	call   80103d00 <myproc>
80104fca:	8b 40 18             	mov    0x18(%eax),%eax
80104fcd:	8b 55 08             	mov    0x8(%ebp),%edx
80104fd0:	8b 40 44             	mov    0x44(%eax),%eax
80104fd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fd6:	e8 25 ed ff ff       	call   80103d00 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fdb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fdd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fe0:	39 c6                	cmp    %eax,%esi
80104fe2:	73 1c                	jae    80105000 <argint+0x40>
80104fe4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fe7:	39 d0                	cmp    %edx,%eax
80104fe9:	72 15                	jb     80105000 <argint+0x40>
  *ip = *(int*)(addr);
80104feb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fee:	8b 53 04             	mov    0x4(%ebx),%edx
80104ff1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ff3:	31 c0                	xor    %eax,%eax
}
80104ff5:	5b                   	pop    %ebx
80104ff6:	5e                   	pop    %esi
80104ff7:	5d                   	pop    %ebp
80104ff8:	c3                   	ret    
80104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105005:	eb ee                	jmp    80104ff5 <argint+0x35>
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	83 ec 10             	sub    $0x10,%esp
80105018:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010501b:	e8 e0 ec ff ff       	call   80103d00 <myproc>
80105020:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105022:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105025:	83 ec 08             	sub    $0x8,%esp
80105028:	50                   	push   %eax
80105029:	ff 75 08             	pushl  0x8(%ebp)
8010502c:	e8 8f ff ff ff       	call   80104fc0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105031:	83 c4 10             	add    $0x10,%esp
80105034:	85 c0                	test   %eax,%eax
80105036:	78 28                	js     80105060 <argptr+0x50>
80105038:	85 db                	test   %ebx,%ebx
8010503a:	78 24                	js     80105060 <argptr+0x50>
8010503c:	8b 16                	mov    (%esi),%edx
8010503e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105041:	39 c2                	cmp    %eax,%edx
80105043:	76 1b                	jbe    80105060 <argptr+0x50>
80105045:	01 c3                	add    %eax,%ebx
80105047:	39 da                	cmp    %ebx,%edx
80105049:	72 15                	jb     80105060 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010504b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010504e:	89 02                	mov    %eax,(%edx)
  return 0;
80105050:	31 c0                	xor    %eax,%eax
}
80105052:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105055:	5b                   	pop    %ebx
80105056:	5e                   	pop    %esi
80105057:	5d                   	pop    %ebp
80105058:	c3                   	ret    
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105065:	eb eb                	jmp    80105052 <argptr+0x42>
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105076:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105079:	50                   	push   %eax
8010507a:	ff 75 08             	pushl  0x8(%ebp)
8010507d:	e8 3e ff ff ff       	call   80104fc0 <argint>
80105082:	83 c4 10             	add    $0x10,%esp
80105085:	85 c0                	test   %eax,%eax
80105087:	78 17                	js     801050a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105089:	83 ec 08             	sub    $0x8,%esp
8010508c:	ff 75 0c             	pushl  0xc(%ebp)
8010508f:	ff 75 f4             	pushl  -0xc(%ebp)
80105092:	e8 b9 fe ff ff       	call   80104f50 <fetchstr>
80105097:	83 c4 10             	add    $0x10,%esp
}
8010509a:	c9                   	leave  
8010509b:	c3                   	ret    
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050a5:	c9                   	leave  
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	53                   	push   %ebx
801050b4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050b7:	e8 44 ec ff ff       	call   80103d00 <myproc>
801050bc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050be:	8b 40 18             	mov    0x18(%eax),%eax
801050c1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050c4:	8d 50 ff             	lea    -0x1(%eax),%edx
801050c7:	83 fa 15             	cmp    $0x15,%edx
801050ca:	77 1c                	ja     801050e8 <syscall+0x38>
801050cc:	8b 14 85 c0 86 10 80 	mov    -0x7fef7940(,%eax,4),%edx
801050d3:	85 d2                	test   %edx,%edx
801050d5:	74 11                	je     801050e8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801050d7:	ff d2                	call   *%edx
801050d9:	8b 53 18             	mov    0x18(%ebx),%edx
801050dc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050e2:	c9                   	leave  
801050e3:	c3                   	ret    
801050e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801050e8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050e9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801050ec:	50                   	push   %eax
801050ed:	ff 73 10             	pushl  0x10(%ebx)
801050f0:	68 85 86 10 80       	push   $0x80108685
801050f5:	e8 66 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801050fa:	8b 43 18             	mov    0x18(%ebx),%eax
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105107:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010510a:	c9                   	leave  
8010510b:	c3                   	ret    
8010510c:	66 90                	xchg   %ax,%ax
8010510e:	66 90                	xchg   %ax,%ax

80105110 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
80105115:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105117:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010511a:	89 d6                	mov    %edx,%esi
8010511c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010511f:	50                   	push   %eax
80105120:	6a 00                	push   $0x0
80105122:	e8 99 fe ff ff       	call   80104fc0 <argint>
80105127:	83 c4 10             	add    $0x10,%esp
8010512a:	85 c0                	test   %eax,%eax
8010512c:	78 2a                	js     80105158 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010512e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105132:	77 24                	ja     80105158 <argfd.constprop.0+0x48>
80105134:	e8 c7 eb ff ff       	call   80103d00 <myproc>
80105139:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010513c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105140:	85 c0                	test   %eax,%eax
80105142:	74 14                	je     80105158 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105144:	85 db                	test   %ebx,%ebx
80105146:	74 02                	je     8010514a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105148:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010514a:	89 06                	mov    %eax,(%esi)
  return 0;
8010514c:	31 c0                	xor    %eax,%eax
}
8010514e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105151:	5b                   	pop    %ebx
80105152:	5e                   	pop    %esi
80105153:	5d                   	pop    %ebp
80105154:	c3                   	ret    
80105155:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010515d:	eb ef                	jmp    8010514e <argfd.constprop.0+0x3e>
8010515f:	90                   	nop

80105160 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105160:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105161:	31 c0                	xor    %eax,%eax
{
80105163:	89 e5                	mov    %esp,%ebp
80105165:	56                   	push   %esi
80105166:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105167:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010516a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010516d:	e8 9e ff ff ff       	call   80105110 <argfd.constprop.0>
80105172:	85 c0                	test   %eax,%eax
80105174:	78 42                	js     801051b8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105176:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105179:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010517b:	e8 80 eb ff ff       	call   80103d00 <myproc>
80105180:	eb 0e                	jmp    80105190 <sys_dup+0x30>
80105182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105188:	83 c3 01             	add    $0x1,%ebx
8010518b:	83 fb 10             	cmp    $0x10,%ebx
8010518e:	74 28                	je     801051b8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105190:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105194:	85 d2                	test   %edx,%edx
80105196:	75 f0                	jne    80105188 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105198:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010519c:	83 ec 0c             	sub    $0xc,%esp
8010519f:	ff 75 f4             	pushl  -0xc(%ebp)
801051a2:	e8 79 bc ff ff       	call   80100e20 <filedup>
  return fd;
801051a7:	83 c4 10             	add    $0x10,%esp
}
801051aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ad:	89 d8                	mov    %ebx,%eax
801051af:	5b                   	pop    %ebx
801051b0:	5e                   	pop    %esi
801051b1:	5d                   	pop    %ebp
801051b2:	c3                   	ret    
801051b3:	90                   	nop
801051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051c0:	89 d8                	mov    %ebx,%eax
801051c2:	5b                   	pop    %ebx
801051c3:	5e                   	pop    %esi
801051c4:	5d                   	pop    %ebp
801051c5:	c3                   	ret    
801051c6:	8d 76 00             	lea    0x0(%esi),%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <sys_read>:

int
sys_read(void)
{
801051d0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d1:	31 c0                	xor    %eax,%eax
{
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051db:	e8 30 ff ff ff       	call   80105110 <argfd.constprop.0>
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 4c                	js     80105230 <sys_read+0x60>
801051e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	50                   	push   %eax
801051eb:	6a 02                	push   $0x2
801051ed:	e8 ce fd ff ff       	call   80104fc0 <argint>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	78 37                	js     80105230 <sys_read+0x60>
801051f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fc:	83 ec 04             	sub    $0x4,%esp
801051ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105202:	50                   	push   %eax
80105203:	6a 01                	push   $0x1
80105205:	e8 06 fe ff ff       	call   80105010 <argptr>
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	85 c0                	test   %eax,%eax
8010520f:	78 1f                	js     80105230 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105211:	83 ec 04             	sub    $0x4,%esp
80105214:	ff 75 f0             	pushl  -0x10(%ebp)
80105217:	ff 75 f4             	pushl  -0xc(%ebp)
8010521a:	ff 75 ec             	pushl  -0x14(%ebp)
8010521d:	e8 6e bd ff ff       	call   80100f90 <fileread>
80105222:	83 c4 10             	add    $0x10,%esp
}
80105225:	c9                   	leave  
80105226:	c3                   	ret    
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <sys_write>:

int
sys_write(void)
{
80105240:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105241:	31 c0                	xor    %eax,%eax
{
80105243:	89 e5                	mov    %esp,%ebp
80105245:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105248:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010524b:	e8 c0 fe ff ff       	call   80105110 <argfd.constprop.0>
80105250:	85 c0                	test   %eax,%eax
80105252:	78 4c                	js     801052a0 <sys_write+0x60>
80105254:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105257:	83 ec 08             	sub    $0x8,%esp
8010525a:	50                   	push   %eax
8010525b:	6a 02                	push   $0x2
8010525d:	e8 5e fd ff ff       	call   80104fc0 <argint>
80105262:	83 c4 10             	add    $0x10,%esp
80105265:	85 c0                	test   %eax,%eax
80105267:	78 37                	js     801052a0 <sys_write+0x60>
80105269:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010526c:	83 ec 04             	sub    $0x4,%esp
8010526f:	ff 75 f0             	pushl  -0x10(%ebp)
80105272:	50                   	push   %eax
80105273:	6a 01                	push   $0x1
80105275:	e8 96 fd ff ff       	call   80105010 <argptr>
8010527a:	83 c4 10             	add    $0x10,%esp
8010527d:	85 c0                	test   %eax,%eax
8010527f:	78 1f                	js     801052a0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105281:	83 ec 04             	sub    $0x4,%esp
80105284:	ff 75 f0             	pushl  -0x10(%ebp)
80105287:	ff 75 f4             	pushl  -0xc(%ebp)
8010528a:	ff 75 ec             	pushl  -0x14(%ebp)
8010528d:	e8 8e bd ff ff       	call   80101020 <filewrite>
80105292:	83 c4 10             	add    $0x10,%esp
}
80105295:	c9                   	leave  
80105296:	c3                   	ret    
80105297:	89 f6                	mov    %esi,%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_close>:

int
sys_close(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801052b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052bc:	e8 4f fe ff ff       	call   80105110 <argfd.constprop.0>
801052c1:	85 c0                	test   %eax,%eax
801052c3:	78 2b                	js     801052f0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801052c5:	e8 36 ea ff ff       	call   80103d00 <myproc>
801052ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801052cd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801052d0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801052d7:	00 
  fileclose(f);
801052d8:	ff 75 f4             	pushl  -0xc(%ebp)
801052db:	e8 90 bb ff ff       	call   80100e70 <fileclose>
  return 0;
801052e0:	83 c4 10             	add    $0x10,%esp
801052e3:	31 c0                	xor    %eax,%eax
}
801052e5:	c9                   	leave  
801052e6:	c3                   	ret    
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f5:	c9                   	leave  
801052f6:	c3                   	ret    
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <sys_fstat>:

int
sys_fstat(void)
{
80105300:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105301:	31 c0                	xor    %eax,%eax
{
80105303:	89 e5                	mov    %esp,%ebp
80105305:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105308:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010530b:	e8 00 fe ff ff       	call   80105110 <argfd.constprop.0>
80105310:	85 c0                	test   %eax,%eax
80105312:	78 2c                	js     80105340 <sys_fstat+0x40>
80105314:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105317:	83 ec 04             	sub    $0x4,%esp
8010531a:	6a 14                	push   $0x14
8010531c:	50                   	push   %eax
8010531d:	6a 01                	push   $0x1
8010531f:	e8 ec fc ff ff       	call   80105010 <argptr>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	78 15                	js     80105340 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010532b:	83 ec 08             	sub    $0x8,%esp
8010532e:	ff 75 f4             	pushl  -0xc(%ebp)
80105331:	ff 75 f0             	pushl  -0x10(%ebp)
80105334:	e8 07 bc ff ff       	call   80100f40 <filestat>
80105339:	83 c4 10             	add    $0x10,%esp
}
8010533c:	c9                   	leave  
8010533d:	c3                   	ret    
8010533e:	66 90                	xchg   %ax,%ax
    return -1;
80105340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105345:	c9                   	leave  
80105346:	c3                   	ret    
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	57                   	push   %edi
80105354:	56                   	push   %esi
80105355:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105356:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105359:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010535c:	50                   	push   %eax
8010535d:	6a 00                	push   $0x0
8010535f:	e8 0c fd ff ff       	call   80105070 <argstr>
80105364:	83 c4 10             	add    $0x10,%esp
80105367:	85 c0                	test   %eax,%eax
80105369:	0f 88 fb 00 00 00    	js     8010546a <sys_link+0x11a>
8010536f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105372:	83 ec 08             	sub    $0x8,%esp
80105375:	50                   	push   %eax
80105376:	6a 01                	push   $0x1
80105378:	e8 f3 fc ff ff       	call   80105070 <argstr>
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	85 c0                	test   %eax,%eax
80105382:	0f 88 e2 00 00 00    	js     8010546a <sys_link+0x11a>
    return -1;

  begin_op();
80105388:	e8 63 dc ff ff       	call   80102ff0 <begin_op>
  if((ip = namei(old)) == 0){
8010538d:	83 ec 0c             	sub    $0xc,%esp
80105390:	ff 75 d4             	pushl  -0x2c(%ebp)
80105393:	e8 88 cb ff ff       	call   80101f20 <namei>
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	85 c0                	test   %eax,%eax
8010539d:	89 c3                	mov    %eax,%ebx
8010539f:	0f 84 ea 00 00 00    	je     8010548f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801053a5:	83 ec 0c             	sub    $0xc,%esp
801053a8:	50                   	push   %eax
801053a9:	e8 12 c3 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053b6:	0f 84 bb 00 00 00    	je     80105477 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801053bc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801053c1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801053c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053c7:	53                   	push   %ebx
801053c8:	e8 43 c2 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
801053cd:	89 1c 24             	mov    %ebx,(%esp)
801053d0:	e8 cb c3 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053d5:	58                   	pop    %eax
801053d6:	5a                   	pop    %edx
801053d7:	57                   	push   %edi
801053d8:	ff 75 d0             	pushl  -0x30(%ebp)
801053db:	e8 60 cb ff ff       	call   80101f40 <nameiparent>
801053e0:	83 c4 10             	add    $0x10,%esp
801053e3:	85 c0                	test   %eax,%eax
801053e5:	89 c6                	mov    %eax,%esi
801053e7:	74 5b                	je     80105444 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801053e9:	83 ec 0c             	sub    $0xc,%esp
801053ec:	50                   	push   %eax
801053ed:	e8 ce c2 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053f2:	83 c4 10             	add    $0x10,%esp
801053f5:	8b 03                	mov    (%ebx),%eax
801053f7:	39 06                	cmp    %eax,(%esi)
801053f9:	75 3d                	jne    80105438 <sys_link+0xe8>
801053fb:	83 ec 04             	sub    $0x4,%esp
801053fe:	ff 73 04             	pushl  0x4(%ebx)
80105401:	57                   	push   %edi
80105402:	56                   	push   %esi
80105403:	e8 58 ca ff ff       	call   80101e60 <dirlink>
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	85 c0                	test   %eax,%eax
8010540d:	78 29                	js     80105438 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010540f:	83 ec 0c             	sub    $0xc,%esp
80105412:	56                   	push   %esi
80105413:	e8 38 c5 ff ff       	call   80101950 <iunlockput>
  iput(ip);
80105418:	89 1c 24             	mov    %ebx,(%esp)
8010541b:	e8 d0 c3 ff ff       	call   801017f0 <iput>

  end_op();
80105420:	e8 3b dc ff ff       	call   80103060 <end_op>

  return 0;
80105425:	83 c4 10             	add    $0x10,%esp
80105428:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010542a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010542d:	5b                   	pop    %ebx
8010542e:	5e                   	pop    %esi
8010542f:	5f                   	pop    %edi
80105430:	5d                   	pop    %ebp
80105431:	c3                   	ret    
80105432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105438:	83 ec 0c             	sub    $0xc,%esp
8010543b:	56                   	push   %esi
8010543c:	e8 0f c5 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105441:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105444:	83 ec 0c             	sub    $0xc,%esp
80105447:	53                   	push   %ebx
80105448:	e8 73 c2 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
8010544d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105452:	89 1c 24             	mov    %ebx,(%esp)
80105455:	e8 b6 c1 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
8010545a:	89 1c 24             	mov    %ebx,(%esp)
8010545d:	e8 ee c4 ff ff       	call   80101950 <iunlockput>
  end_op();
80105462:	e8 f9 db ff ff       	call   80103060 <end_op>
  return -1;
80105467:	83 c4 10             	add    $0x10,%esp
}
8010546a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010546d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105472:	5b                   	pop    %ebx
80105473:	5e                   	pop    %esi
80105474:	5f                   	pop    %edi
80105475:	5d                   	pop    %ebp
80105476:	c3                   	ret    
    iunlockput(ip);
80105477:	83 ec 0c             	sub    $0xc,%esp
8010547a:	53                   	push   %ebx
8010547b:	e8 d0 c4 ff ff       	call   80101950 <iunlockput>
    end_op();
80105480:	e8 db db ff ff       	call   80103060 <end_op>
    return -1;
80105485:	83 c4 10             	add    $0x10,%esp
80105488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010548d:	eb 9b                	jmp    8010542a <sys_link+0xda>
    end_op();
8010548f:	e8 cc db ff ff       	call   80103060 <end_op>
    return -1;
80105494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105499:	eb 8f                	jmp    8010542a <sys_link+0xda>
8010549b:	90                   	nop
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054a0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
801054a5:	53                   	push   %ebx
801054a6:	83 ec 1c             	sub    $0x1c,%esp
801054a9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054ac:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801054b0:	76 3e                	jbe    801054f0 <isdirempty+0x50>
801054b2:	bb 20 00 00 00       	mov    $0x20,%ebx
801054b7:	8d 7d d8             	lea    -0x28(%ebp),%edi
801054ba:	eb 0c                	jmp    801054c8 <isdirempty+0x28>
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054c0:	83 c3 10             	add    $0x10,%ebx
801054c3:	3b 5e 58             	cmp    0x58(%esi),%ebx
801054c6:	73 28                	jae    801054f0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054c8:	6a 10                	push   $0x10
801054ca:	53                   	push   %ebx
801054cb:	57                   	push   %edi
801054cc:	56                   	push   %esi
801054cd:	e8 ce c4 ff ff       	call   801019a0 <readi>
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	83 f8 10             	cmp    $0x10,%eax
801054d8:	75 23                	jne    801054fd <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801054da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054df:	74 df                	je     801054c0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801054e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801054e4:	31 c0                	xor    %eax,%eax
}
801054e6:	5b                   	pop    %ebx
801054e7:	5e                   	pop    %esi
801054e8:	5f                   	pop    %edi
801054e9:	5d                   	pop    %ebp
801054ea:	c3                   	ret    
801054eb:	90                   	nop
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801054f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801054f8:	5b                   	pop    %ebx
801054f9:	5e                   	pop    %esi
801054fa:	5f                   	pop    %edi
801054fb:	5d                   	pop    %ebp
801054fc:	c3                   	ret    
      panic("isdirempty: readi");
801054fd:	83 ec 0c             	sub    $0xc,%esp
80105500:	68 1c 87 10 80       	push   $0x8010871c
80105505:	e8 86 ae ff ff       	call   80100390 <panic>
8010550a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105510 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105516:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105519:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010551c:	50                   	push   %eax
8010551d:	6a 00                	push   $0x0
8010551f:	e8 4c fb ff ff       	call   80105070 <argstr>
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	85 c0                	test   %eax,%eax
80105529:	0f 88 51 01 00 00    	js     80105680 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010552f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105532:	e8 b9 da ff ff       	call   80102ff0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105537:	83 ec 08             	sub    $0x8,%esp
8010553a:	53                   	push   %ebx
8010553b:	ff 75 c0             	pushl  -0x40(%ebp)
8010553e:	e8 fd c9 ff ff       	call   80101f40 <nameiparent>
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	89 c6                	mov    %eax,%esi
8010554a:	0f 84 37 01 00 00    	je     80105687 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	50                   	push   %eax
80105554:	e8 67 c1 ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105559:	58                   	pop    %eax
8010555a:	5a                   	pop    %edx
8010555b:	68 dd 80 10 80       	push   $0x801080dd
80105560:	53                   	push   %ebx
80105561:	e8 6a c6 ff ff       	call   80101bd0 <namecmp>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	0f 84 d7 00 00 00    	je     80105648 <sys_unlink+0x138>
80105571:	83 ec 08             	sub    $0x8,%esp
80105574:	68 dc 80 10 80       	push   $0x801080dc
80105579:	53                   	push   %ebx
8010557a:	e8 51 c6 ff ff       	call   80101bd0 <namecmp>
8010557f:	83 c4 10             	add    $0x10,%esp
80105582:	85 c0                	test   %eax,%eax
80105584:	0f 84 be 00 00 00    	je     80105648 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010558a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010558d:	83 ec 04             	sub    $0x4,%esp
80105590:	50                   	push   %eax
80105591:	53                   	push   %ebx
80105592:	56                   	push   %esi
80105593:	e8 58 c6 ff ff       	call   80101bf0 <dirlookup>
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	85 c0                	test   %eax,%eax
8010559d:	89 c3                	mov    %eax,%ebx
8010559f:	0f 84 a3 00 00 00    	je     80105648 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
801055a5:	83 ec 0c             	sub    $0xc,%esp
801055a8:	50                   	push   %eax
801055a9:	e8 12 c1 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
801055ae:	83 c4 10             	add    $0x10,%esp
801055b1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801055b6:	0f 8e e4 00 00 00    	jle    801056a0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801055bc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055c1:	74 65                	je     80105628 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801055c3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801055c6:	83 ec 04             	sub    $0x4,%esp
801055c9:	6a 10                	push   $0x10
801055cb:	6a 00                	push   $0x0
801055cd:	57                   	push   %edi
801055ce:	e8 ed f6 ff ff       	call   80104cc0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055d3:	6a 10                	push   $0x10
801055d5:	ff 75 c4             	pushl  -0x3c(%ebp)
801055d8:	57                   	push   %edi
801055d9:	56                   	push   %esi
801055da:	e8 c1 c4 ff ff       	call   80101aa0 <writei>
801055df:	83 c4 20             	add    $0x20,%esp
801055e2:	83 f8 10             	cmp    $0x10,%eax
801055e5:	0f 85 a8 00 00 00    	jne    80105693 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801055eb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055f0:	74 6e                	je     80105660 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801055f2:	83 ec 0c             	sub    $0xc,%esp
801055f5:	56                   	push   %esi
801055f6:	e8 55 c3 ff ff       	call   80101950 <iunlockput>

  ip->nlink--;
801055fb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105600:	89 1c 24             	mov    %ebx,(%esp)
80105603:	e8 08 c0 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
80105608:	89 1c 24             	mov    %ebx,(%esp)
8010560b:	e8 40 c3 ff ff       	call   80101950 <iunlockput>

  end_op();
80105610:	e8 4b da ff ff       	call   80103060 <end_op>

  return 0;
80105615:	83 c4 10             	add    $0x10,%esp
80105618:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010561a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010561d:	5b                   	pop    %ebx
8010561e:	5e                   	pop    %esi
8010561f:	5f                   	pop    %edi
80105620:	5d                   	pop    %ebp
80105621:	c3                   	ret    
80105622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	53                   	push   %ebx
8010562c:	e8 6f fe ff ff       	call   801054a0 <isdirempty>
80105631:	83 c4 10             	add    $0x10,%esp
80105634:	85 c0                	test   %eax,%eax
80105636:	75 8b                	jne    801055c3 <sys_unlink+0xb3>
    iunlockput(ip);
80105638:	83 ec 0c             	sub    $0xc,%esp
8010563b:	53                   	push   %ebx
8010563c:	e8 0f c3 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105641:	83 c4 10             	add    $0x10,%esp
80105644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	56                   	push   %esi
8010564c:	e8 ff c2 ff ff       	call   80101950 <iunlockput>
  end_op();
80105651:	e8 0a da ff ff       	call   80103060 <end_op>
  return -1;
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565e:	eb ba                	jmp    8010561a <sys_unlink+0x10a>
    dp->nlink--;
80105660:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105665:	83 ec 0c             	sub    $0xc,%esp
80105668:	56                   	push   %esi
80105669:	e8 a2 bf ff ff       	call   80101610 <iupdate>
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	e9 7c ff ff ff       	jmp    801055f2 <sys_unlink+0xe2>
80105676:	8d 76 00             	lea    0x0(%esi),%esi
80105679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105685:	eb 93                	jmp    8010561a <sys_unlink+0x10a>
    end_op();
80105687:	e8 d4 d9 ff ff       	call   80103060 <end_op>
    return -1;
8010568c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105691:	eb 87                	jmp    8010561a <sys_unlink+0x10a>
    panic("unlink: writei");
80105693:	83 ec 0c             	sub    $0xc,%esp
80105696:	68 f1 80 10 80       	push   $0x801080f1
8010569b:	e8 f0 ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	68 df 80 10 80       	push   $0x801080df
801056a8:	e8 e3 ac ff ff       	call   80100390 <panic>
801056ad:	8d 76 00             	lea    0x0(%esi),%esi

801056b0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
801056b5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056b6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801056b9:	83 ec 44             	sub    $0x44,%esp
801056bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801056bf:	8b 55 10             	mov    0x10(%ebp),%edx
801056c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801056c5:	56                   	push   %esi
801056c6:	ff 75 08             	pushl  0x8(%ebp)
{
801056c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801056cc:	89 55 c0             	mov    %edx,-0x40(%ebp)
801056cf:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801056d2:	e8 69 c8 ff ff       	call   80101f40 <nameiparent>
801056d7:	83 c4 10             	add    $0x10,%esp
801056da:	85 c0                	test   %eax,%eax
801056dc:	0f 84 4e 01 00 00    	je     80105830 <create+0x180>
    return 0;
  ilock(dp);
801056e2:	83 ec 0c             	sub    $0xc,%esp
801056e5:	89 c3                	mov    %eax,%ebx
801056e7:	50                   	push   %eax
801056e8:	e8 d3 bf ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801056ed:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801056f0:	83 c4 0c             	add    $0xc,%esp
801056f3:	50                   	push   %eax
801056f4:	56                   	push   %esi
801056f5:	53                   	push   %ebx
801056f6:	e8 f5 c4 ff ff       	call   80101bf0 <dirlookup>
801056fb:	83 c4 10             	add    $0x10,%esp
801056fe:	85 c0                	test   %eax,%eax
80105700:	89 c7                	mov    %eax,%edi
80105702:	74 3c                	je     80105740 <create+0x90>
    iunlockput(dp);
80105704:	83 ec 0c             	sub    $0xc,%esp
80105707:	53                   	push   %ebx
80105708:	e8 43 c2 ff ff       	call   80101950 <iunlockput>
    ilock(ip);
8010570d:	89 3c 24             	mov    %edi,(%esp)
80105710:	e8 ab bf ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105715:	83 c4 10             	add    $0x10,%esp
80105718:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010571d:	0f 85 9d 00 00 00    	jne    801057c0 <create+0x110>
80105723:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105728:	0f 85 92 00 00 00    	jne    801057c0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010572e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105731:	89 f8                	mov    %edi,%eax
80105733:	5b                   	pop    %ebx
80105734:	5e                   	pop    %esi
80105735:	5f                   	pop    %edi
80105736:	5d                   	pop    %ebp
80105737:	c3                   	ret    
80105738:	90                   	nop
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80105740:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105744:	83 ec 08             	sub    $0x8,%esp
80105747:	50                   	push   %eax
80105748:	ff 33                	pushl  (%ebx)
8010574a:	e8 01 be ff ff       	call   80101550 <ialloc>
8010574f:	83 c4 10             	add    $0x10,%esp
80105752:	85 c0                	test   %eax,%eax
80105754:	89 c7                	mov    %eax,%edi
80105756:	0f 84 e8 00 00 00    	je     80105844 <create+0x194>
  ilock(ip);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	50                   	push   %eax
80105760:	e8 5b bf ff ff       	call   801016c0 <ilock>
  ip->major = major;
80105765:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105769:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010576d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105771:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105775:	b8 01 00 00 00       	mov    $0x1,%eax
8010577a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010577e:	89 3c 24             	mov    %edi,(%esp)
80105781:	e8 8a be ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010578e:	74 50                	je     801057e0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105790:	83 ec 04             	sub    $0x4,%esp
80105793:	ff 77 04             	pushl  0x4(%edi)
80105796:	56                   	push   %esi
80105797:	53                   	push   %ebx
80105798:	e8 c3 c6 ff ff       	call   80101e60 <dirlink>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	0f 88 8f 00 00 00    	js     80105837 <create+0x187>
  iunlockput(dp);
801057a8:	83 ec 0c             	sub    $0xc,%esp
801057ab:	53                   	push   %ebx
801057ac:	e8 9f c1 ff ff       	call   80101950 <iunlockput>
  return ip;
801057b1:	83 c4 10             	add    $0x10,%esp
}
801057b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b7:	89 f8                	mov    %edi,%eax
801057b9:	5b                   	pop    %ebx
801057ba:	5e                   	pop    %esi
801057bb:	5f                   	pop    %edi
801057bc:	5d                   	pop    %ebp
801057bd:	c3                   	ret    
801057be:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	57                   	push   %edi
    return 0;
801057c4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801057c6:	e8 85 c1 ff ff       	call   80101950 <iunlockput>
    return 0;
801057cb:	83 c4 10             	add    $0x10,%esp
}
801057ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d1:	89 f8                	mov    %edi,%eax
801057d3:	5b                   	pop    %ebx
801057d4:	5e                   	pop    %esi
801057d5:	5f                   	pop    %edi
801057d6:	5d                   	pop    %ebp
801057d7:	c3                   	ret    
801057d8:	90                   	nop
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801057e0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801057e5:	83 ec 0c             	sub    $0xc,%esp
801057e8:	53                   	push   %ebx
801057e9:	e8 22 be ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057ee:	83 c4 0c             	add    $0xc,%esp
801057f1:	ff 77 04             	pushl  0x4(%edi)
801057f4:	68 dd 80 10 80       	push   $0x801080dd
801057f9:	57                   	push   %edi
801057fa:	e8 61 c6 ff ff       	call   80101e60 <dirlink>
801057ff:	83 c4 10             	add    $0x10,%esp
80105802:	85 c0                	test   %eax,%eax
80105804:	78 1c                	js     80105822 <create+0x172>
80105806:	83 ec 04             	sub    $0x4,%esp
80105809:	ff 73 04             	pushl  0x4(%ebx)
8010580c:	68 dc 80 10 80       	push   $0x801080dc
80105811:	57                   	push   %edi
80105812:	e8 49 c6 ff ff       	call   80101e60 <dirlink>
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	85 c0                	test   %eax,%eax
8010581c:	0f 89 6e ff ff ff    	jns    80105790 <create+0xe0>
      panic("create dots");
80105822:	83 ec 0c             	sub    $0xc,%esp
80105825:	68 3d 87 10 80       	push   $0x8010873d
8010582a:	e8 61 ab ff ff       	call   80100390 <panic>
8010582f:	90                   	nop
    return 0;
80105830:	31 ff                	xor    %edi,%edi
80105832:	e9 f7 fe ff ff       	jmp    8010572e <create+0x7e>
    panic("create: dirlink");
80105837:	83 ec 0c             	sub    $0xc,%esp
8010583a:	68 49 87 10 80       	push   $0x80108749
8010583f:	e8 4c ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105844:	83 ec 0c             	sub    $0xc,%esp
80105847:	68 2e 87 10 80       	push   $0x8010872e
8010584c:	e8 3f ab ff ff       	call   80100390 <panic>
80105851:	eb 0d                	jmp    80105860 <sys_open>
80105853:	90                   	nop
80105854:	90                   	nop
80105855:	90                   	nop
80105856:	90                   	nop
80105857:	90                   	nop
80105858:	90                   	nop
80105859:	90                   	nop
8010585a:	90                   	nop
8010585b:	90                   	nop
8010585c:	90                   	nop
8010585d:	90                   	nop
8010585e:	90                   	nop
8010585f:	90                   	nop

80105860 <sys_open>:

int
sys_open(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105866:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105869:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010586c:	50                   	push   %eax
8010586d:	6a 00                	push   $0x0
8010586f:	e8 fc f7 ff ff       	call   80105070 <argstr>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	0f 88 1d 01 00 00    	js     8010599c <sys_open+0x13c>
8010587f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105882:	83 ec 08             	sub    $0x8,%esp
80105885:	50                   	push   %eax
80105886:	6a 01                	push   $0x1
80105888:	e8 33 f7 ff ff       	call   80104fc0 <argint>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	0f 88 04 01 00 00    	js     8010599c <sys_open+0x13c>
    return -1;

  begin_op();
80105898:	e8 53 d7 ff ff       	call   80102ff0 <begin_op>

  if(omode & O_CREATE){
8010589d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058a1:	0f 85 a9 00 00 00    	jne    80105950 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058a7:	83 ec 0c             	sub    $0xc,%esp
801058aa:	ff 75 e0             	pushl  -0x20(%ebp)
801058ad:	e8 6e c6 ff ff       	call   80101f20 <namei>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	89 c6                	mov    %eax,%esi
801058b9:	0f 84 ac 00 00 00    	je     8010596b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
801058bf:	83 ec 0c             	sub    $0xc,%esp
801058c2:	50                   	push   %eax
801058c3:	e8 f8 bd ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058c8:	83 c4 10             	add    $0x10,%esp
801058cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058d0:	0f 84 aa 00 00 00    	je     80105980 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058d6:	e8 d5 b4 ff ff       	call   80100db0 <filealloc>
801058db:	85 c0                	test   %eax,%eax
801058dd:	89 c7                	mov    %eax,%edi
801058df:	0f 84 a6 00 00 00    	je     8010598b <sys_open+0x12b>
  struct proc *curproc = myproc();
801058e5:	e8 16 e4 ff ff       	call   80103d00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ea:	31 db                	xor    %ebx,%ebx
801058ec:	eb 0e                	jmp    801058fc <sys_open+0x9c>
801058ee:	66 90                	xchg   %ax,%ax
801058f0:	83 c3 01             	add    $0x1,%ebx
801058f3:	83 fb 10             	cmp    $0x10,%ebx
801058f6:	0f 84 ac 00 00 00    	je     801059a8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801058fc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105900:	85 d2                	test   %edx,%edx
80105902:	75 ec                	jne    801058f0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105904:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105907:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010590b:	56                   	push   %esi
8010590c:	e8 8f be ff ff       	call   801017a0 <iunlock>
  end_op();
80105911:	e8 4a d7 ff ff       	call   80103060 <end_op>

  f->type = FD_INODE;
80105916:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010591c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010591f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105922:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105925:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010592c:	89 d0                	mov    %edx,%eax
8010592e:	f7 d0                	not    %eax
80105930:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105933:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105936:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105939:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010593d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105940:	89 d8                	mov    %ebx,%eax
80105942:	5b                   	pop    %ebx
80105943:	5e                   	pop    %esi
80105944:	5f                   	pop    %edi
80105945:	5d                   	pop    %ebp
80105946:	c3                   	ret    
80105947:	89 f6                	mov    %esi,%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105950:	6a 00                	push   $0x0
80105952:	6a 00                	push   $0x0
80105954:	6a 02                	push   $0x2
80105956:	ff 75 e0             	pushl  -0x20(%ebp)
80105959:	e8 52 fd ff ff       	call   801056b0 <create>
    if(ip == 0){
8010595e:	83 c4 10             	add    $0x10,%esp
80105961:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105963:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105965:	0f 85 6b ff ff ff    	jne    801058d6 <sys_open+0x76>
      end_op();
8010596b:	e8 f0 d6 ff ff       	call   80103060 <end_op>
      return -1;
80105970:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105975:	eb c6                	jmp    8010593d <sys_open+0xdd>
80105977:	89 f6                	mov    %esi,%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105980:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105983:	85 c9                	test   %ecx,%ecx
80105985:	0f 84 4b ff ff ff    	je     801058d6 <sys_open+0x76>
    iunlockput(ip);
8010598b:	83 ec 0c             	sub    $0xc,%esp
8010598e:	56                   	push   %esi
8010598f:	e8 bc bf ff ff       	call   80101950 <iunlockput>
    end_op();
80105994:	e8 c7 d6 ff ff       	call   80103060 <end_op>
    return -1;
80105999:	83 c4 10             	add    $0x10,%esp
8010599c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059a1:	eb 9a                	jmp    8010593d <sys_open+0xdd>
801059a3:	90                   	nop
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	57                   	push   %edi
801059ac:	e8 bf b4 ff ff       	call   80100e70 <fileclose>
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	eb d5                	jmp    8010598b <sys_open+0x12b>
801059b6:	8d 76 00             	lea    0x0(%esi),%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059c6:	e8 25 d6 ff ff       	call   80102ff0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ce:	83 ec 08             	sub    $0x8,%esp
801059d1:	50                   	push   %eax
801059d2:	6a 00                	push   $0x0
801059d4:	e8 97 f6 ff ff       	call   80105070 <argstr>
801059d9:	83 c4 10             	add    $0x10,%esp
801059dc:	85 c0                	test   %eax,%eax
801059de:	78 30                	js     80105a10 <sys_mkdir+0x50>
801059e0:	6a 00                	push   $0x0
801059e2:	6a 00                	push   $0x0
801059e4:	6a 01                	push   $0x1
801059e6:	ff 75 f4             	pushl  -0xc(%ebp)
801059e9:	e8 c2 fc ff ff       	call   801056b0 <create>
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	85 c0                	test   %eax,%eax
801059f3:	74 1b                	je     80105a10 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059f5:	83 ec 0c             	sub    $0xc,%esp
801059f8:	50                   	push   %eax
801059f9:	e8 52 bf ff ff       	call   80101950 <iunlockput>
  end_op();
801059fe:	e8 5d d6 ff ff       	call   80103060 <end_op>
  return 0;
80105a03:	83 c4 10             	add    $0x10,%esp
80105a06:	31 c0                	xor    %eax,%eax
}
80105a08:	c9                   	leave  
80105a09:	c3                   	ret    
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105a10:	e8 4b d6 ff ff       	call   80103060 <end_op>
    return -1;
80105a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a1a:	c9                   	leave  
80105a1b:	c3                   	ret    
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_mknod>:

int
sys_mknod(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a26:	e8 c5 d5 ff ff       	call   80102ff0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a2e:	83 ec 08             	sub    $0x8,%esp
80105a31:	50                   	push   %eax
80105a32:	6a 00                	push   $0x0
80105a34:	e8 37 f6 ff ff       	call   80105070 <argstr>
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	85 c0                	test   %eax,%eax
80105a3e:	78 60                	js     80105aa0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a43:	83 ec 08             	sub    $0x8,%esp
80105a46:	50                   	push   %eax
80105a47:	6a 01                	push   $0x1
80105a49:	e8 72 f5 ff ff       	call   80104fc0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	85 c0                	test   %eax,%eax
80105a53:	78 4b                	js     80105aa0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a58:	83 ec 08             	sub    $0x8,%esp
80105a5b:	50                   	push   %eax
80105a5c:	6a 02                	push   $0x2
80105a5e:	e8 5d f5 ff ff       	call   80104fc0 <argint>
     argint(1, &major) < 0 ||
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 c0                	test   %eax,%eax
80105a68:	78 36                	js     80105aa0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a6a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a6e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a6f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a73:	50                   	push   %eax
80105a74:	6a 03                	push   $0x3
80105a76:	ff 75 ec             	pushl  -0x14(%ebp)
80105a79:	e8 32 fc ff ff       	call   801056b0 <create>
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	74 1b                	je     80105aa0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a85:	83 ec 0c             	sub    $0xc,%esp
80105a88:	50                   	push   %eax
80105a89:	e8 c2 be ff ff       	call   80101950 <iunlockput>
  end_op();
80105a8e:	e8 cd d5 ff ff       	call   80103060 <end_op>
  return 0;
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	31 c0                	xor    %eax,%eax
}
80105a98:	c9                   	leave  
80105a99:	c3                   	ret    
80105a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105aa0:	e8 bb d5 ff ff       	call   80103060 <end_op>
    return -1;
80105aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aaa:	c9                   	leave  
80105aab:	c3                   	ret    
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_chdir>:

int
sys_chdir(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	56                   	push   %esi
80105ab4:	53                   	push   %ebx
80105ab5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ab8:	e8 43 e2 ff ff       	call   80103d00 <myproc>
80105abd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105abf:	e8 2c d5 ff ff       	call   80102ff0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac7:	83 ec 08             	sub    $0x8,%esp
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 9e f5 ff ff       	call   80105070 <argstr>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 77                	js     80105b50 <sys_chdir+0xa0>
80105ad9:	83 ec 0c             	sub    $0xc,%esp
80105adc:	ff 75 f4             	pushl  -0xc(%ebp)
80105adf:	e8 3c c4 ff ff       	call   80101f20 <namei>
80105ae4:	83 c4 10             	add    $0x10,%esp
80105ae7:	85 c0                	test   %eax,%eax
80105ae9:	89 c3                	mov    %eax,%ebx
80105aeb:	74 63                	je     80105b50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105aed:	83 ec 0c             	sub    $0xc,%esp
80105af0:	50                   	push   %eax
80105af1:	e8 ca bb ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105afe:	75 30                	jne    80105b30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	53                   	push   %ebx
80105b04:	e8 97 bc ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105b09:	58                   	pop    %eax
80105b0a:	ff 76 68             	pushl  0x68(%esi)
80105b0d:	e8 de bc ff ff       	call   801017f0 <iput>
  end_op();
80105b12:	e8 49 d5 ff ff       	call   80103060 <end_op>
  curproc->cwd = ip;
80105b17:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	31 c0                	xor    %eax,%eax
}
80105b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b22:	5b                   	pop    %ebx
80105b23:	5e                   	pop    %esi
80105b24:	5d                   	pop    %ebp
80105b25:	c3                   	ret    
80105b26:	8d 76 00             	lea    0x0(%esi),%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	53                   	push   %ebx
80105b34:	e8 17 be ff ff       	call   80101950 <iunlockput>
    end_op();
80105b39:	e8 22 d5 ff ff       	call   80103060 <end_op>
    return -1;
80105b3e:	83 c4 10             	add    $0x10,%esp
80105b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b46:	eb d7                	jmp    80105b1f <sys_chdir+0x6f>
80105b48:	90                   	nop
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b50:	e8 0b d5 ff ff       	call   80103060 <end_op>
    return -1;
80105b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5a:	eb c3                	jmp    80105b1f <sys_chdir+0x6f>
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b60 <sys_exec>:

int
sys_exec(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b66:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b6c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b72:	50                   	push   %eax
80105b73:	6a 00                	push   $0x0
80105b75:	e8 f6 f4 ff ff       	call   80105070 <argstr>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	0f 88 87 00 00 00    	js     80105c0c <sys_exec+0xac>
80105b85:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b8b:	83 ec 08             	sub    $0x8,%esp
80105b8e:	50                   	push   %eax
80105b8f:	6a 01                	push   $0x1
80105b91:	e8 2a f4 ff ff       	call   80104fc0 <argint>
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	78 6f                	js     80105c0c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b9d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ba3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105ba6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ba8:	68 80 00 00 00       	push   $0x80
80105bad:	6a 00                	push   $0x0
80105baf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105bb5:	50                   	push   %eax
80105bb6:	e8 05 f1 ff ff       	call   80104cc0 <memset>
80105bbb:	83 c4 10             	add    $0x10,%esp
80105bbe:	eb 2c                	jmp    80105bec <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105bc0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bc6:	85 c0                	test   %eax,%eax
80105bc8:	74 56                	je     80105c20 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105bd0:	83 ec 08             	sub    $0x8,%esp
80105bd3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105bd6:	52                   	push   %edx
80105bd7:	50                   	push   %eax
80105bd8:	e8 73 f3 ff ff       	call   80104f50 <fetchstr>
80105bdd:	83 c4 10             	add    $0x10,%esp
80105be0:	85 c0                	test   %eax,%eax
80105be2:	78 28                	js     80105c0c <sys_exec+0xac>
  for(i=0;; i++){
80105be4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105be7:	83 fb 20             	cmp    $0x20,%ebx
80105bea:	74 20                	je     80105c0c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bf2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105bf9:	83 ec 08             	sub    $0x8,%esp
80105bfc:	57                   	push   %edi
80105bfd:	01 f0                	add    %esi,%eax
80105bff:	50                   	push   %eax
80105c00:	e8 0b f3 ff ff       	call   80104f10 <fetchint>
80105c05:	83 c4 10             	add    $0x10,%esp
80105c08:	85 c0                	test   %eax,%eax
80105c0a:	79 b4                	jns    80105bc0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c14:	5b                   	pop    %ebx
80105c15:	5e                   	pop    %esi
80105c16:	5f                   	pop    %edi
80105c17:	5d                   	pop    %ebp
80105c18:	c3                   	ret    
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c20:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c26:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105c29:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c30:	00 00 00 00 
  return exec(path, argv);
80105c34:	50                   	push   %eax
80105c35:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c3b:	e8 d0 ad ff ff       	call   80100a10 <exec>
80105c40:	83 c4 10             	add    $0x10,%esp
}
80105c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c46:	5b                   	pop    %ebx
80105c47:	5e                   	pop    %esi
80105c48:	5f                   	pop    %edi
80105c49:	5d                   	pop    %ebp
80105c4a:	c3                   	ret    
80105c4b:	90                   	nop
80105c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c50 <sys_pipe>:

int
sys_pipe(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	57                   	push   %edi
80105c54:	56                   	push   %esi
80105c55:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c56:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c59:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c5c:	6a 08                	push   $0x8
80105c5e:	50                   	push   %eax
80105c5f:	6a 00                	push   $0x0
80105c61:	e8 aa f3 ff ff       	call   80105010 <argptr>
80105c66:	83 c4 10             	add    $0x10,%esp
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	0f 88 ae 00 00 00    	js     80105d1f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c71:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c74:	83 ec 08             	sub    $0x8,%esp
80105c77:	50                   	push   %eax
80105c78:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c7b:	50                   	push   %eax
80105c7c:	e8 0f da ff ff       	call   80103690 <pipealloc>
80105c81:	83 c4 10             	add    $0x10,%esp
80105c84:	85 c0                	test   %eax,%eax
80105c86:	0f 88 93 00 00 00    	js     80105d1f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c8c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c8f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c91:	e8 6a e0 ff ff       	call   80103d00 <myproc>
80105c96:	eb 10                	jmp    80105ca8 <sys_pipe+0x58>
80105c98:	90                   	nop
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105ca0:	83 c3 01             	add    $0x1,%ebx
80105ca3:	83 fb 10             	cmp    $0x10,%ebx
80105ca6:	74 60                	je     80105d08 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105ca8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cac:	85 f6                	test   %esi,%esi
80105cae:	75 f0                	jne    80105ca0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105cb0:	8d 73 08             	lea    0x8(%ebx),%esi
80105cb3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cba:	e8 41 e0 ff ff       	call   80103d00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cbf:	31 d2                	xor    %edx,%edx
80105cc1:	eb 0d                	jmp    80105cd0 <sys_pipe+0x80>
80105cc3:	90                   	nop
80105cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cc8:	83 c2 01             	add    $0x1,%edx
80105ccb:	83 fa 10             	cmp    $0x10,%edx
80105cce:	74 28                	je     80105cf8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105cd0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cd4:	85 c9                	test   %ecx,%ecx
80105cd6:	75 f0                	jne    80105cc8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105cd8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cdf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ce1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ce4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ce7:	31 c0                	xor    %eax,%eax
}
80105ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cec:	5b                   	pop    %ebx
80105ced:	5e                   	pop    %esi
80105cee:	5f                   	pop    %edi
80105cef:	5d                   	pop    %ebp
80105cf0:	c3                   	ret    
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105cf8:	e8 03 e0 ff ff       	call   80103d00 <myproc>
80105cfd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d04:	00 
80105d05:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105d08:	83 ec 0c             	sub    $0xc,%esp
80105d0b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d0e:	e8 5d b1 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105d13:	58                   	pop    %eax
80105d14:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d17:	e8 54 b1 ff ff       	call   80100e70 <fileclose>
    return -1;
80105d1c:	83 c4 10             	add    $0x10,%esp
80105d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d24:	eb c3                	jmp    80105ce9 <sys_pipe+0x99>
80105d26:	66 90                	xchg   %ax,%ax
80105d28:	66 90                	xchg   %ax,%ax
80105d2a:	66 90                	xchg   %ax,%ax
80105d2c:	66 90                	xchg   %ax,%ax
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105d36:	e8 45 e7 ff ff       	call   80104480 <yield>
  return 0;
}
80105d3b:	31 c0                	xor    %eax,%eax
80105d3d:	c9                   	leave  
80105d3e:	c3                   	ret    
80105d3f:	90                   	nop

80105d40 <sys_fork>:

int
sys_fork(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105d43:	5d                   	pop    %ebp
  return fork();
80105d44:	e9 77 e1 ff ff       	jmp    80103ec0 <fork>
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_exit>:

int
sys_exit(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d56:	e8 d5 e5 ff ff       	call   80104330 <exit>
  return 0;  // not reached
}
80105d5b:	31 c0                	xor    %eax,%eax
80105d5d:	c9                   	leave  
80105d5e:	c3                   	ret    
80105d5f:	90                   	nop

80105d60 <sys_wait>:

int
sys_wait(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d63:	5d                   	pop    %ebp
  return wait();
80105d64:	e9 27 e8 ff ff       	jmp    80104590 <wait>
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_kill>:

int
sys_kill(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d79:	50                   	push   %eax
80105d7a:	6a 00                	push   $0x0
80105d7c:	e8 3f f2 ff ff       	call   80104fc0 <argint>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	78 18                	js     80105da0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8e:	e8 0d ea ff ff       	call   801047a0 <kill>
80105d93:	83 c4 10             	add    $0x10,%esp
}
80105d96:	c9                   	leave  
80105d97:	c3                   	ret    
80105d98:	90                   	nop
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105da5:	c9                   	leave  
80105da6:	c3                   	ret    
80105da7:	89 f6                	mov    %esi,%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105db0 <sys_getpid>:

int
sys_getpid(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105db6:	e8 45 df ff ff       	call   80103d00 <myproc>
80105dbb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dbe:	c9                   	leave  
80105dbf:	c3                   	ret    

80105dc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105dc7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dca:	50                   	push   %eax
80105dcb:	6a 00                	push   $0x0
80105dcd:	e8 ee f1 ff ff       	call   80104fc0 <argint>
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	78 27                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105dd9:	e8 22 df ff ff       	call   80103d00 <myproc>
  if(growproc(n) < 0)
80105dde:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105de1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105de3:	ff 75 f4             	pushl  -0xc(%ebp)
80105de6:	e8 45 e0 ff ff       	call   80103e30 <growproc>
80105deb:	83 c4 10             	add    $0x10,%esp
80105dee:	85 c0                	test   %eax,%eax
80105df0:	78 0e                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105df2:	89 d8                	mov    %ebx,%eax
80105df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105df7:	c9                   	leave  
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e05:	eb eb                	jmp    80105df2 <sys_sbrk+0x32>
80105e07:	89 f6                	mov    %esi,%esi
80105e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e10 <sys_sleep>:

int
sys_sleep(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e1a:	50                   	push   %eax
80105e1b:	6a 00                	push   $0x0
80105e1d:	e8 9e f1 ff ff       	call   80104fc0 <argint>
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	85 c0                	test   %eax,%eax
80105e27:	0f 88 8a 00 00 00    	js     80105eb7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e2d:	83 ec 0c             	sub    $0xc,%esp
80105e30:	68 a0 64 12 80       	push   $0x801264a0
80105e35:	e8 06 ed ff ff       	call   80104b40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e3d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e40:	8b 1d e0 6c 12 80    	mov    0x80126ce0,%ebx
  while(ticks - ticks0 < n){
80105e46:	85 d2                	test   %edx,%edx
80105e48:	75 27                	jne    80105e71 <sys_sleep+0x61>
80105e4a:	eb 54                	jmp    80105ea0 <sys_sleep+0x90>
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e50:	83 ec 08             	sub    $0x8,%esp
80105e53:	68 a0 64 12 80       	push   $0x801264a0
80105e58:	68 e0 6c 12 80       	push   $0x80126ce0
80105e5d:	e8 6e e6 ff ff       	call   801044d0 <sleep>
  while(ticks - ticks0 < n){
80105e62:	a1 e0 6c 12 80       	mov    0x80126ce0,%eax
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	29 d8                	sub    %ebx,%eax
80105e6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e6f:	73 2f                	jae    80105ea0 <sys_sleep+0x90>
    if(myproc()->killed){
80105e71:	e8 8a de ff ff       	call   80103d00 <myproc>
80105e76:	8b 40 24             	mov    0x24(%eax),%eax
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	74 d3                	je     80105e50 <sys_sleep+0x40>
      release(&tickslock);
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	68 a0 64 12 80       	push   $0x801264a0
80105e85:	e8 d6 ed ff ff       	call   80104c60 <release>
      return -1;
80105e8a:	83 c4 10             	add    $0x10,%esp
80105e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105e92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
80105e97:	89 f6                	mov    %esi,%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	68 a0 64 12 80       	push   $0x801264a0
80105ea8:	e8 b3 ed ff ff       	call   80104c60 <release>
  return 0;
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	31 c0                	xor    %eax,%eax
}
80105eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eb5:	c9                   	leave  
80105eb6:	c3                   	ret    
    return -1;
80105eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebc:	eb f4                	jmp    80105eb2 <sys_sleep+0xa2>
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	53                   	push   %ebx
80105ec4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ec7:	68 a0 64 12 80       	push   $0x801264a0
80105ecc:	e8 6f ec ff ff       	call   80104b40 <acquire>
  xticks = ticks;
80105ed1:	8b 1d e0 6c 12 80    	mov    0x80126ce0,%ebx
  release(&tickslock);
80105ed7:	c7 04 24 a0 64 12 80 	movl   $0x801264a0,(%esp)
80105ede:	e8 7d ed ff ff       	call   80104c60 <release>
  return xticks;
}
80105ee3:	89 d8                	mov    %ebx,%eax
80105ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ee8:	c9                   	leave  
80105ee9:	c3                   	ret    

80105eea <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105eea:	1e                   	push   %ds
  pushl %es
80105eeb:	06                   	push   %es
  pushl %fs
80105eec:	0f a0                	push   %fs
  pushl %gs
80105eee:	0f a8                	push   %gs
  pushal
80105ef0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ef1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ef5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ef7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ef9:	54                   	push   %esp
  call trap
80105efa:	e8 c1 00 00 00       	call   80105fc0 <trap>
  addl $4, %esp
80105eff:	83 c4 04             	add    $0x4,%esp

80105f02 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f02:	61                   	popa   
  popl %gs
80105f03:	0f a9                	pop    %gs
  popl %fs
80105f05:	0f a1                	pop    %fs
  popl %es
80105f07:	07                   	pop    %es
  popl %ds
80105f08:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f09:	83 c4 08             	add    $0x8,%esp
  iret
80105f0c:	cf                   	iret   
80105f0d:	66 90                	xchg   %ax,%ax
80105f0f:	90                   	nop

80105f10 <tvinit>:
struct spinlock tickslock;
uint ticks, virtualAddr, problematicPage;
struct proc *p;

void
tvinit(void) {
80105f10:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105f11:	31 c0                	xor    %eax,%eax
tvinit(void) {
80105f13:	89 e5                	mov    %esp,%ebp
80105f15:	83 ec 08             	sub    $0x8,%esp
80105f18:	90                   	nop
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105f20:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105f27:	c7 04 c5 e2 64 12 80 	movl   $0x8e000008,-0x7fed9b1e(,%eax,8)
80105f2e:	08 00 00 8e 
80105f32:	66 89 14 c5 e0 64 12 	mov    %dx,-0x7fed9b20(,%eax,8)
80105f39:	80 
80105f3a:	c1 ea 10             	shr    $0x10,%edx
80105f3d:	66 89 14 c5 e6 64 12 	mov    %dx,-0x7fed9b1a(,%eax,8)
80105f44:	80 
80105f45:	83 c0 01             	add    $0x1,%eax
80105f48:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f4d:	75 d1                	jne    80105f20 <tvinit+0x10>
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105f4f:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

    initlock(&tickslock, "time");
80105f54:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105f57:	c7 05 e2 66 12 80 08 	movl   $0xef000008,0x801266e2
80105f5e:	00 00 ef 
    initlock(&tickslock, "time");
80105f61:	68 59 87 10 80       	push   $0x80108759
80105f66:	68 a0 64 12 80       	push   $0x801264a0
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105f6b:	66 a3 e0 66 12 80    	mov    %ax,0x801266e0
80105f71:	c1 e8 10             	shr    $0x10,%eax
80105f74:	66 a3 e6 66 12 80    	mov    %ax,0x801266e6
    initlock(&tickslock, "time");
80105f7a:	e8 d1 ea ff ff       	call   80104a50 <initlock>
}
80105f7f:	83 c4 10             	add    $0x10,%esp
80105f82:	c9                   	leave  
80105f83:	c3                   	ret    
80105f84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f90 <idtinit>:

void
idtinit(void) {
80105f90:	55                   	push   %ebp
  pd[0] = size-1;
80105f91:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f96:	89 e5                	mov    %esp,%ebp
80105f98:	83 ec 10             	sub    $0x10,%esp
80105f9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f9f:	b8 e0 64 12 80       	mov    $0x801264e0,%eax
80105fa4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fa8:	c1 e8 10             	shr    $0x10,%eax
80105fab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105faf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fb2:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80105fb5:	c9                   	leave  
80105fb6:	c3                   	ret    
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fc0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	57                   	push   %edi
80105fc4:	56                   	push   %esi
80105fc5:	53                   	push   %ebx
80105fc6:	83 ec 1c             	sub    $0x1c,%esp
80105fc9:	8b 75 08             	mov    0x8(%ebp),%esi
    if (tf->trapno == T_SYSCALL) {
80105fcc:	8b 46 30             	mov    0x30(%esi),%eax
80105fcf:	83 f8 40             	cmp    $0x40,%eax
80105fd2:	0f 84 00 02 00 00    	je     801061d8 <trap+0x218>
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
80105fd8:	83 e8 0e             	sub    $0xe,%eax
80105fdb:	83 f8 31             	cmp    $0x31,%eax
80105fde:	0f 87 dc 02 00 00    	ja     801062c0 <trap+0x300>
80105fe4:	ff 24 85 c8 88 10 80 	jmp    *-0x7fef7738(,%eax,4)
80105feb:	90                   	nop
80105fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            break;

            //CASE TRAP 14 PGFLT IF IN SWITCH FILE: BRING FROM THERE, ELSE GO DEFAULT
#if (defined(SCFIFO) || defined(LIFO))
        case T_PGFLT:
            p = myproc();
80105ff0:	e8 0b dd ff ff       	call   80103d00 <myproc>
80105ff5:	a3 80 64 12 80       	mov    %eax,0x80126480

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ffa:	0f 20 d2             	mov    %cr2,%edx
            pte_t *currPTE;

            virtualAddr = rcr2();
            problematicPage = PGROUNDDOWN(virtualAddr);
            //first we need to check if page is in swap
            for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++)
80105ffd:	31 ff                	xor    %edi,%edi
            virtualAddr = rcr2();
80105fff:	89 15 e4 6c 12 80    	mov    %edx,0x80126ce4
            problematicPage = PGROUNDDOWN(virtualAddr);
80106005:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
            for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++)
8010600b:	39 90 98 00 00 00    	cmp    %edx,0x98(%eax)
            problematicPage = PGROUNDDOWN(virtualAddr);
80106011:	89 15 84 64 12 80    	mov    %edx,0x80126484
            for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES] && cg->virtAdress != (char *) problematicPage; cg++, i++)
80106017:	8d 98 80 00 00 00    	lea    0x80(%eax),%ebx
8010601d:	8d 88 00 04 00 00    	lea    0x400(%eax),%ecx
80106023:	75 10                	jne    80106035 <trap+0x75>
80106025:	eb 1e                	jmp    80106045 <trap+0x85>
80106027:	89 f6                	mov    %esi,%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106030:	39 53 18             	cmp    %edx,0x18(%ebx)
80106033:	74 10                	je     80106045 <trap+0x85>
80106035:	83 c3 1c             	add    $0x1c,%ebx
80106038:	83 c7 01             	add    $0x1,%edi
8010603b:	39 cb                	cmp    %ecx,%ebx
8010603d:	72 f1                	jb     80106030 <trap+0x70>
                ;
            if (cg == &p->pages[MAX_TOTAL_PAGES]) { //if true -didn't find the addr -error
8010603f:	0f 84 c0 03 00 00    	je     80106405 <trap+0x445>
                panic("Error- didn't find the trap's page in T_PGFLT\n");
            }

            //must update page faults for proc.
            p->pageFaults++;
80106045:	83 80 54 04 00 00 01 	addl   $0x1,0x454(%eax)

            //Got here - cg is the page that is in swapFile; i is its location in array
            //Now- check if all 16 pages are in RAM

            //TODO = check if page is in secondary memory
            if (!cg->active || cg->present) {
8010604c:	8b 0b                	mov    (%ebx),%ecx
8010604e:	85 c9                	test   %ecx,%ecx
80106050:	0f 84 e2 02 00 00    	je     80106338 <trap+0x378>
80106056:	8b 53 0c             	mov    0xc(%ebx),%edx
80106059:	85 d2                	test   %edx,%edx
8010605b:	0f 85 ff 02 00 00    	jne    80106360 <trap+0x3a0>
                if(cg->present)
                    panic("Error - problematic page is present!\n");
                panic("Error - problematic page is not active!\n");
            }

            if ((p->pagesCounter - p->pagesinSwap) >= 16) {
80106061:	8b 90 44 04 00 00    	mov    0x444(%eax),%edx
80106067:	2b 90 48 04 00 00    	sub    0x448(%eax),%edx
8010606d:	83 fa 0f             	cmp    $0xf,%edx
80106070:	0f 8f 2e 03 00 00    	jg     801063a4 <trap+0x3e4>
                swapOutPage(p, p->pgdir); //func in vm.c - same use in allocuvm
            }

            //got here - there is a room for a new page

            if ((newAddr = kalloc()) == 0) {
80106076:	e8 95 c8 ff ff       	call   80102910 <kalloc>
8010607b:	85 c0                	test   %eax,%eax
8010607d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106080:	0f 84 32 03 00 00    	je     801063b8 <trap+0x3f8>
                cprintf("Error- kalloc in T_PGFLT\n");
                break;
            }

            memset(newAddr, 0, PGSIZE); //clean the page
80106086:	83 ec 04             	sub    $0x4,%esp
80106089:	68 00 10 00 00       	push   $0x1000
8010608e:	6a 00                	push   $0x0
80106090:	ff 75 e4             	pushl  -0x1c(%ebp)
80106093:	e8 28 ec ff ff       	call   80104cc0 <memset>

            //bring page from swapFile
            if (readFromSwapFile(p, newAddr, cg->offset, PGSIZE) == -1)
80106098:	68 00 10 00 00       	push   $0x1000
8010609d:	ff 73 10             	pushl  0x10(%ebx)
801060a0:	ff 75 e4             	pushl  -0x1c(%ebp)
801060a3:	ff 35 80 64 12 80    	pushl  0x80126480
801060a9:	e8 12 c2 ff ff       	call   801022c0 <readFromSwapFile>
801060ae:	83 c4 20             	add    $0x20,%esp
801060b1:	83 f8 ff             	cmp    $0xffffffff,%eax
801060b4:	0f 84 3e 03 00 00    	je     801063f8 <trap+0x438>
                panic("error - read from swapfile in T_PGFLT");

            currPTE = walkpgdir2(p->pgdir, (void *) virtualAddr, 0);
801060ba:	a1 80 64 12 80       	mov    0x80126480,%eax
801060bf:	83 ec 04             	sub    $0x4,%esp
801060c2:	6a 00                	push   $0x0
801060c4:	ff 35 e4 6c 12 80    	pushl  0x80126ce4
801060ca:	ff 70 04             	pushl  0x4(%eax)
801060cd:	e8 ee 10 00 00       	call   801071c0 <walkpgdir2>
801060d2:	89 c2                	mov    %eax,%edx
            //update flags - in page, not yet in RAM
            *currPTE = PTE_P_0(*currPTE);
801060d4:	8b 00                	mov    (%eax),%eax
            *currPTE = PTE_PG_1(*currPTE);
801060d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
            *currPTE = PTE_P_0(*currPTE);
801060d9:	83 e0 fe             	and    $0xfffffffe,%eax
            *currPTE = PTE_PG_1(*currPTE);
801060dc:	80 cc 02             	or     $0x2,%ah
801060df:	89 02                	mov    %eax,(%edx)

            mappages2(p->pgdir, (void *) problematicPage, PGSIZE, V2P(newAddr), PTE_U | PTE_W);
801060e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060e4:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
801060eb:	05 00 00 00 80       	add    $0x80000000,%eax
801060f0:	50                   	push   %eax
801060f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060f4:	a1 80 64 12 80       	mov    0x80126480,%eax
801060f9:	68 00 10 00 00       	push   $0x1000
801060fe:	ff 35 84 64 12 80    	pushl  0x80126484
80106104:	ff 70 04             	pushl  0x4(%eax)
80106107:	e8 d4 10 00 00       	call   801071e0 <mappages2>
            //update flags - if got here the page is in RAM!
            *currPTE = PTE_P_1(*currPTE);
            *currPTE = PTE_PG_0(*currPTE);
8010610c:	8b 55 dc             	mov    -0x24(%ebp),%edx
            //update proc
            p->swapFileEntries[i] = 0; //clean entry- page is in RAM
//            p->pagesCounter++;
            p->pagesinSwap--;

            lapiceoi();
8010610f:	83 c4 20             	add    $0x20,%esp
            *currPTE = PTE_PG_0(*currPTE);
80106112:	8b 0a                	mov    (%edx),%ecx
80106114:	80 e5 fd             	and    $0xfd,%ch
80106117:	89 c8                	mov    %ecx,%eax
80106119:	83 c8 01             	or     $0x1,%eax
8010611c:	89 02                	mov    %eax,(%edx)
            cg->active = 1;
8010611e:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
            cg->virtAdress = newAddr;
80106124:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            cg->sequel = p->pagesequel++;
80106127:	a1 80 64 12 80       	mov    0x80126480,%eax
            cg->offset = 0;
8010612c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
            cg->present = 1;
80106133:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
            cg->virtAdress = newAddr;
8010613a:	89 53 18             	mov    %edx,0x18(%ebx)
            cg->sequel = p->pagesequel++;
8010613d:	8b 90 4c 04 00 00    	mov    0x44c(%eax),%edx
80106143:	8d 4a 01             	lea    0x1(%edx),%ecx
80106146:	89 88 4c 04 00 00    	mov    %ecx,0x44c(%eax)
            cg->physAdress = (char *) V2P(newAddr);
8010614c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
            cg->sequel = p->pagesequel++;
8010614f:	89 53 08             	mov    %edx,0x8(%ebx)
            cg->physAdress = (char *) V2P(newAddr);
80106152:	89 4b 14             	mov    %ecx,0x14(%ebx)
            p->swapFileEntries[i] = 0; //clean entry- page is in RAM
80106155:	c7 84 b8 00 04 00 00 	movl   $0x0,0x400(%eax,%edi,4)
8010615c:	00 00 00 00 
            p->pagesinSwap--;
80106160:	83 a8 48 04 00 00 01 	subl   $0x1,0x448(%eax)
            lapiceoi();
80106167:	e8 34 ca ff ff       	call   80102ba0 <lapiceoi>
8010616c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106170:	e8 8b db ff ff       	call   80103d00 <myproc>
80106175:	85 c0                	test   %eax,%eax
80106177:	74 1d                	je     80106196 <trap+0x1d6>
80106179:	e8 82 db ff ff       	call   80103d00 <myproc>
8010617e:	8b 50 24             	mov    0x24(%eax),%edx
80106181:	85 d2                	test   %edx,%edx
80106183:	74 11                	je     80106196 <trap+0x1d6>
80106185:	0f b7 46 3c          	movzwl 0x3c(%esi),%eax
80106189:	83 e0 03             	and    $0x3,%eax
8010618c:	66 83 f8 03          	cmp    $0x3,%ax
80106190:	0f 84 ba 01 00 00    	je     80106350 <trap+0x390>
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80106196:	e8 65 db ff ff       	call   80103d00 <myproc>
8010619b:	85 c0                	test   %eax,%eax
8010619d:	74 0b                	je     801061aa <trap+0x1ea>
8010619f:	e8 5c db ff ff       	call   80103d00 <myproc>
801061a4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801061a8:	74 66                	je     80106210 <trap+0x250>
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
801061aa:	e8 51 db ff ff       	call   80103d00 <myproc>
801061af:	85 c0                	test   %eax,%eax
801061b1:	74 19                	je     801061cc <trap+0x20c>
801061b3:	e8 48 db ff ff       	call   80103d00 <myproc>
801061b8:	8b 40 24             	mov    0x24(%eax),%eax
801061bb:	85 c0                	test   %eax,%eax
801061bd:	74 0d                	je     801061cc <trap+0x20c>
801061bf:	0f b7 46 3c          	movzwl 0x3c(%esi),%eax
801061c3:	83 e0 03             	and    $0x3,%eax
801061c6:	66 83 f8 03          	cmp    $0x3,%ax
801061ca:	74 35                	je     80106201 <trap+0x241>
        exit();
}
801061cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061cf:	5b                   	pop    %ebx
801061d0:	5e                   	pop    %esi
801061d1:	5f                   	pop    %edi
801061d2:	5d                   	pop    %ebp
801061d3:	c3                   	ret    
801061d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed)
801061d8:	e8 23 db ff ff       	call   80103d00 <myproc>
801061dd:	8b 78 24             	mov    0x24(%eax),%edi
801061e0:	85 ff                	test   %edi,%edi
801061e2:	0f 85 c8 00 00 00    	jne    801062b0 <trap+0x2f0>
        myproc()->tf = tf;
801061e8:	e8 13 db ff ff       	call   80103d00 <myproc>
801061ed:	89 70 18             	mov    %esi,0x18(%eax)
        syscall();
801061f0:	e8 bb ee ff ff       	call   801050b0 <syscall>
        if (myproc()->killed)
801061f5:	e8 06 db ff ff       	call   80103d00 <myproc>
801061fa:	8b 58 24             	mov    0x24(%eax),%ebx
801061fd:	85 db                	test   %ebx,%ebx
801061ff:	74 cb                	je     801061cc <trap+0x20c>
}
80106201:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106204:	5b                   	pop    %ebx
80106205:	5e                   	pop    %esi
80106206:	5f                   	pop    %edi
80106207:	5d                   	pop    %ebp
            exit();
80106208:	e9 23 e1 ff ff       	jmp    80104330 <exit>
8010620d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
80106210:	83 7e 30 20          	cmpl   $0x20,0x30(%esi)
80106214:	75 94                	jne    801061aa <trap+0x1ea>
        yield();
80106216:	e8 65 e2 ff ff       	call   80104480 <yield>
8010621b:	eb 8d                	jmp    801061aa <trap+0x1ea>
8010621d:	8d 76 00             	lea    0x0(%esi),%esi
            if (cpuid() == 0) {
80106220:	e8 bb da ff ff       	call   80103ce0 <cpuid>
80106225:	85 c0                	test   %eax,%eax
80106227:	0f 84 43 01 00 00    	je     80106370 <trap+0x3b0>
            lapiceoi();
8010622d:	e8 6e c9 ff ff       	call   80102ba0 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106232:	e8 c9 da ff ff       	call   80103d00 <myproc>
80106237:	85 c0                	test   %eax,%eax
80106239:	0f 85 3a ff ff ff    	jne    80106179 <trap+0x1b9>
8010623f:	e9 52 ff ff ff       	jmp    80106196 <trap+0x1d6>
80106244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80106248:	e8 13 c8 ff ff       	call   80102a60 <kbdintr>
            lapiceoi();
8010624d:	e8 4e c9 ff ff       	call   80102ba0 <lapiceoi>
            break;
80106252:	e9 19 ff ff ff       	jmp    80106170 <trap+0x1b0>
80106257:	89 f6                	mov    %esi,%esi
80106259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            uartintr();
80106260:	e8 2b 03 00 00       	call   80106590 <uartintr>
            lapiceoi();
80106265:	e8 36 c9 ff ff       	call   80102ba0 <lapiceoi>
            break;
8010626a:	e9 01 ff ff ff       	jmp    80106170 <trap+0x1b0>
8010626f:	90                   	nop
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106270:	0f b7 5e 3c          	movzwl 0x3c(%esi),%ebx
80106274:	8b 7e 38             	mov    0x38(%esi),%edi
80106277:	e8 64 da ff ff       	call   80103ce0 <cpuid>
8010627c:	57                   	push   %edi
8010627d:	53                   	push   %ebx
8010627e:	50                   	push   %eax
8010627f:	68 80 87 10 80       	push   $0x80108780
80106284:	e8 d7 a3 ff ff       	call   80100660 <cprintf>
            lapiceoi();
80106289:	e8 12 c9 ff ff       	call   80102ba0 <lapiceoi>
            break;
8010628e:	83 c4 10             	add    $0x10,%esp
80106291:	e9 da fe ff ff       	jmp    80106170 <trap+0x1b0>
80106296:	8d 76 00             	lea    0x0(%esi),%esi
80106299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            ideintr();
801062a0:	e8 ab c1 ff ff       	call   80102450 <ideintr>
801062a5:	eb 86                	jmp    8010622d <trap+0x26d>
801062a7:	89 f6                	mov    %esi,%esi
801062a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            exit();
801062b0:	e8 7b e0 ff ff       	call   80104330 <exit>
801062b5:	e9 2e ff ff ff       	jmp    801061e8 <trap+0x228>
801062ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (myproc() == 0 || (tf->cs & 3) == 0) {
801062c0:	e8 3b da ff ff       	call   80103d00 <myproc>
801062c5:	85 c0                	test   %eax,%eax
801062c7:	0f 84 00 01 00 00    	je     801063cd <trap+0x40d>
801062cd:	f6 46 3c 03          	testb  $0x3,0x3c(%esi)
801062d1:	0f 84 f6 00 00 00    	je     801063cd <trap+0x40d>
801062d7:	0f 20 d1             	mov    %cr2,%ecx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801062da:	8b 56 38             	mov    0x38(%esi),%edx
801062dd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801062e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801062e3:	e8 f8 d9 ff ff       	call   80103ce0 <cpuid>
801062e8:	89 c7                	mov    %eax,%edi
801062ea:	8b 46 34             	mov    0x34(%esi),%eax
801062ed:	8b 5e 30             	mov    0x30(%esi),%ebx
801062f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    myproc()->pid, myproc()->name, tf->trapno,
801062f3:	e8 08 da ff ff       	call   80103d00 <myproc>
801062f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062fb:	e8 00 da ff ff       	call   80103d00 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80106300:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106303:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106306:	51                   	push   %ecx
80106307:	52                   	push   %edx
                    myproc()->pid, myproc()->name, tf->trapno,
80106308:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
8010630b:	57                   	push   %edi
8010630c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010630f:	53                   	push   %ebx
                    myproc()->pid, myproc()->name, tf->trapno,
80106310:	83 c2 6c             	add    $0x6c,%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80106313:	52                   	push   %edx
80106314:	ff 70 10             	pushl  0x10(%eax)
80106317:	68 84 88 10 80       	push   $0x80108884
8010631c:	e8 3f a3 ff ff       	call   80100660 <cprintf>
            myproc()->killed = 1;
80106321:	83 c4 20             	add    $0x20,%esp
80106324:	e8 d7 d9 ff ff       	call   80103d00 <myproc>
80106329:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106330:	e9 3b fe ff ff       	jmp    80106170 <trap+0x1b0>
80106335:	8d 76 00             	lea    0x0(%esi),%esi
                if(cg->present)
80106338:	8b 4b 0c             	mov    0xc(%ebx),%ecx
8010633b:	85 c9                	test   %ecx,%ecx
8010633d:	75 21                	jne    80106360 <trap+0x3a0>
                panic("Error - problematic page is not active!\n");
8010633f:	83 ec 0c             	sub    $0xc,%esp
80106342:	68 fc 87 10 80       	push   $0x801087fc
80106347:	e8 44 a0 ff ff       	call   80100390 <panic>
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        exit();
80106350:	e8 db df ff ff       	call   80104330 <exit>
80106355:	e9 3c fe ff ff       	jmp    80106196 <trap+0x1d6>
8010635a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    panic("Error - problematic page is present!\n");
80106360:	83 ec 0c             	sub    $0xc,%esp
80106363:	68 d4 87 10 80       	push   $0x801087d4
80106368:	e8 23 a0 ff ff       	call   80100390 <panic>
8010636d:	8d 76 00             	lea    0x0(%esi),%esi
                acquire(&tickslock);
80106370:	83 ec 0c             	sub    $0xc,%esp
80106373:	68 a0 64 12 80       	push   $0x801264a0
80106378:	e8 c3 e7 ff ff       	call   80104b40 <acquire>
                wakeup(&ticks);
8010637d:	c7 04 24 e0 6c 12 80 	movl   $0x80126ce0,(%esp)
                ticks++;
80106384:	83 05 e0 6c 12 80 01 	addl   $0x1,0x80126ce0
                wakeup(&ticks);
8010638b:	e8 b0 e3 ff ff       	call   80104740 <wakeup>
                release(&tickslock);
80106390:	c7 04 24 a0 64 12 80 	movl   $0x801264a0,(%esp)
80106397:	e8 c4 e8 ff ff       	call   80104c60 <release>
8010639c:	83 c4 10             	add    $0x10,%esp
8010639f:	e9 89 fe ff ff       	jmp    8010622d <trap+0x26d>
                swapOutPage(p, p->pgdir); //func in vm.c - same use in allocuvm
801063a4:	83 ec 08             	sub    $0x8,%esp
801063a7:	ff 70 04             	pushl  0x4(%eax)
801063aa:	50                   	push   %eax
801063ab:	e8 f0 10 00 00       	call   801074a0 <swapOutPage>
801063b0:	83 c4 10             	add    $0x10,%esp
801063b3:	e9 be fc ff ff       	jmp    80106076 <trap+0xb6>
                cprintf("Error- kalloc in T_PGFLT\n");
801063b8:	83 ec 0c             	sub    $0xc,%esp
801063bb:	68 5e 87 10 80       	push   $0x8010875e
801063c0:	e8 9b a2 ff ff       	call   80100660 <cprintf>
                break;
801063c5:	83 c4 10             	add    $0x10,%esp
801063c8:	e9 a3 fd ff ff       	jmp    80106170 <trap+0x1b0>
801063cd:	0f 20 d7             	mov    %cr2,%edi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801063d0:	8b 5e 38             	mov    0x38(%esi),%ebx
801063d3:	e8 08 d9 ff ff       	call   80103ce0 <cpuid>
801063d8:	83 ec 0c             	sub    $0xc,%esp
801063db:	57                   	push   %edi
801063dc:	53                   	push   %ebx
801063dd:	50                   	push   %eax
801063de:	ff 76 30             	pushl  0x30(%esi)
801063e1:	68 50 88 10 80       	push   $0x80108850
801063e6:	e8 75 a2 ff ff       	call   80100660 <cprintf>
                panic("trap");
801063eb:	83 c4 14             	add    $0x14,%esp
801063ee:	68 78 87 10 80       	push   $0x80108778
801063f3:	e8 98 9f ff ff       	call   80100390 <panic>
                panic("error - read from swapfile in T_PGFLT");
801063f8:	83 ec 0c             	sub    $0xc,%esp
801063fb:	68 28 88 10 80       	push   $0x80108828
80106400:	e8 8b 9f ff ff       	call   80100390 <panic>
                panic("Error- didn't find the trap's page in T_PGFLT\n");
80106405:	83 ec 0c             	sub    $0xc,%esp
80106408:	68 a4 87 10 80       	push   $0x801087a4
8010640d:	e8 7e 9f ff ff       	call   80100390 <panic>
80106412:	66 90                	xchg   %ax,%ax
80106414:	66 90                	xchg   %ax,%ax
80106416:	66 90                	xchg   %ax,%ax
80106418:	66 90                	xchg   %ax,%ax
8010641a:	66 90                	xchg   %ax,%ax
8010641c:	66 90                	xchg   %ax,%ax
8010641e:	66 90                	xchg   %ax,%ax

80106420 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106420:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
{
80106425:	55                   	push   %ebp
80106426:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106428:	85 c0                	test   %eax,%eax
8010642a:	74 1c                	je     80106448 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010642c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106431:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106432:	a8 01                	test   $0x1,%al
80106434:	74 12                	je     80106448 <uartgetc+0x28>
80106436:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010643b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010643c:	0f b6 c0             	movzbl %al,%eax
}
8010643f:	5d                   	pop    %ebp
80106440:	c3                   	ret    
80106441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010644d:	5d                   	pop    %ebp
8010644e:	c3                   	ret    
8010644f:	90                   	nop

80106450 <uartputc.part.0>:
uartputc(int c)
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	57                   	push   %edi
80106454:	56                   	push   %esi
80106455:	53                   	push   %ebx
80106456:	89 c7                	mov    %eax,%edi
80106458:	bb 80 00 00 00       	mov    $0x80,%ebx
8010645d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106462:	83 ec 0c             	sub    $0xc,%esp
80106465:	eb 1b                	jmp    80106482 <uartputc.part.0+0x32>
80106467:	89 f6                	mov    %esi,%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106470:	83 ec 0c             	sub    $0xc,%esp
80106473:	6a 0a                	push   $0xa
80106475:	e8 46 c7 ff ff       	call   80102bc0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010647a:	83 c4 10             	add    $0x10,%esp
8010647d:	83 eb 01             	sub    $0x1,%ebx
80106480:	74 07                	je     80106489 <uartputc.part.0+0x39>
80106482:	89 f2                	mov    %esi,%edx
80106484:	ec                   	in     (%dx),%al
80106485:	a8 20                	test   $0x20,%al
80106487:	74 e7                	je     80106470 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106489:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010648e:	89 f8                	mov    %edi,%eax
80106490:	ee                   	out    %al,(%dx)
}
80106491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106494:	5b                   	pop    %ebx
80106495:	5e                   	pop    %esi
80106496:	5f                   	pop    %edi
80106497:	5d                   	pop    %ebp
80106498:	c3                   	ret    
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064a0 <uartinit>:
{
801064a0:	55                   	push   %ebp
801064a1:	31 c9                	xor    %ecx,%ecx
801064a3:	89 c8                	mov    %ecx,%eax
801064a5:	89 e5                	mov    %esp,%ebp
801064a7:	57                   	push   %edi
801064a8:	56                   	push   %esi
801064a9:	53                   	push   %ebx
801064aa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801064af:	89 da                	mov    %ebx,%edx
801064b1:	83 ec 0c             	sub    $0xc,%esp
801064b4:	ee                   	out    %al,(%dx)
801064b5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801064ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801064bf:	89 fa                	mov    %edi,%edx
801064c1:	ee                   	out    %al,(%dx)
801064c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801064c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064cc:	ee                   	out    %al,(%dx)
801064cd:	be f9 03 00 00       	mov    $0x3f9,%esi
801064d2:	89 c8                	mov    %ecx,%eax
801064d4:	89 f2                	mov    %esi,%edx
801064d6:	ee                   	out    %al,(%dx)
801064d7:	b8 03 00 00 00       	mov    $0x3,%eax
801064dc:	89 fa                	mov    %edi,%edx
801064de:	ee                   	out    %al,(%dx)
801064df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064e4:	89 c8                	mov    %ecx,%eax
801064e6:	ee                   	out    %al,(%dx)
801064e7:	b8 01 00 00 00       	mov    $0x1,%eax
801064ec:	89 f2                	mov    %esi,%edx
801064ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064f4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801064f5:	3c ff                	cmp    $0xff,%al
801064f7:	74 5a                	je     80106553 <uartinit+0xb3>
  uart = 1;
801064f9:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
80106500:	00 00 00 
80106503:	89 da                	mov    %ebx,%edx
80106505:	ec                   	in     (%dx),%al
80106506:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010650b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010650c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010650f:	bb 90 89 10 80       	mov    $0x80108990,%ebx
  ioapicenable(IRQ_COM1, 0);
80106514:	6a 00                	push   $0x0
80106516:	6a 04                	push   $0x4
80106518:	e8 83 c1 ff ff       	call   801026a0 <ioapicenable>
8010651d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106520:	b8 78 00 00 00       	mov    $0x78,%eax
80106525:	eb 13                	jmp    8010653a <uartinit+0x9a>
80106527:	89 f6                	mov    %esi,%esi
80106529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106530:	83 c3 01             	add    $0x1,%ebx
80106533:	0f be 03             	movsbl (%ebx),%eax
80106536:	84 c0                	test   %al,%al
80106538:	74 19                	je     80106553 <uartinit+0xb3>
  if(!uart)
8010653a:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80106540:	85 d2                	test   %edx,%edx
80106542:	74 ec                	je     80106530 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106544:	83 c3 01             	add    $0x1,%ebx
80106547:	e8 04 ff ff ff       	call   80106450 <uartputc.part.0>
8010654c:	0f be 03             	movsbl (%ebx),%eax
8010654f:	84 c0                	test   %al,%al
80106551:	75 e7                	jne    8010653a <uartinit+0x9a>
}
80106553:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106556:	5b                   	pop    %ebx
80106557:	5e                   	pop    %esi
80106558:	5f                   	pop    %edi
80106559:	5d                   	pop    %ebp
8010655a:	c3                   	ret    
8010655b:	90                   	nop
8010655c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106560 <uartputc>:
  if(!uart)
80106560:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
80106566:	55                   	push   %ebp
80106567:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106569:	85 d2                	test   %edx,%edx
{
8010656b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010656e:	74 10                	je     80106580 <uartputc+0x20>
}
80106570:	5d                   	pop    %ebp
80106571:	e9 da fe ff ff       	jmp    80106450 <uartputc.part.0>
80106576:	8d 76 00             	lea    0x0(%esi),%esi
80106579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106580:	5d                   	pop    %ebp
80106581:	c3                   	ret    
80106582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106590 <uartintr>:

void
uartintr(void)
{
80106590:	55                   	push   %ebp
80106591:	89 e5                	mov    %esp,%ebp
80106593:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106596:	68 20 64 10 80       	push   $0x80106420
8010659b:	e8 70 a2 ff ff       	call   80100810 <consoleintr>
}
801065a0:	83 c4 10             	add    $0x10,%esp
801065a3:	c9                   	leave  
801065a4:	c3                   	ret    

801065a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $0
801065a7:	6a 00                	push   $0x0
  jmp alltraps
801065a9:	e9 3c f9 ff ff       	jmp    80105eea <alltraps>

801065ae <vector1>:
.globl vector1
vector1:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $1
801065b0:	6a 01                	push   $0x1
  jmp alltraps
801065b2:	e9 33 f9 ff ff       	jmp    80105eea <alltraps>

801065b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $2
801065b9:	6a 02                	push   $0x2
  jmp alltraps
801065bb:	e9 2a f9 ff ff       	jmp    80105eea <alltraps>

801065c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801065c0:	6a 00                	push   $0x0
  pushl $3
801065c2:	6a 03                	push   $0x3
  jmp alltraps
801065c4:	e9 21 f9 ff ff       	jmp    80105eea <alltraps>

801065c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801065c9:	6a 00                	push   $0x0
  pushl $4
801065cb:	6a 04                	push   $0x4
  jmp alltraps
801065cd:	e9 18 f9 ff ff       	jmp    80105eea <alltraps>

801065d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $5
801065d4:	6a 05                	push   $0x5
  jmp alltraps
801065d6:	e9 0f f9 ff ff       	jmp    80105eea <alltraps>

801065db <vector6>:
.globl vector6
vector6:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $6
801065dd:	6a 06                	push   $0x6
  jmp alltraps
801065df:	e9 06 f9 ff ff       	jmp    80105eea <alltraps>

801065e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801065e4:	6a 00                	push   $0x0
  pushl $7
801065e6:	6a 07                	push   $0x7
  jmp alltraps
801065e8:	e9 fd f8 ff ff       	jmp    80105eea <alltraps>

801065ed <vector8>:
.globl vector8
vector8:
  pushl $8
801065ed:	6a 08                	push   $0x8
  jmp alltraps
801065ef:	e9 f6 f8 ff ff       	jmp    80105eea <alltraps>

801065f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $9
801065f6:	6a 09                	push   $0x9
  jmp alltraps
801065f8:	e9 ed f8 ff ff       	jmp    80105eea <alltraps>

801065fd <vector10>:
.globl vector10
vector10:
  pushl $10
801065fd:	6a 0a                	push   $0xa
  jmp alltraps
801065ff:	e9 e6 f8 ff ff       	jmp    80105eea <alltraps>

80106604 <vector11>:
.globl vector11
vector11:
  pushl $11
80106604:	6a 0b                	push   $0xb
  jmp alltraps
80106606:	e9 df f8 ff ff       	jmp    80105eea <alltraps>

8010660b <vector12>:
.globl vector12
vector12:
  pushl $12
8010660b:	6a 0c                	push   $0xc
  jmp alltraps
8010660d:	e9 d8 f8 ff ff       	jmp    80105eea <alltraps>

80106612 <vector13>:
.globl vector13
vector13:
  pushl $13
80106612:	6a 0d                	push   $0xd
  jmp alltraps
80106614:	e9 d1 f8 ff ff       	jmp    80105eea <alltraps>

80106619 <vector14>:
.globl vector14
vector14:
  pushl $14
80106619:	6a 0e                	push   $0xe
  jmp alltraps
8010661b:	e9 ca f8 ff ff       	jmp    80105eea <alltraps>

80106620 <vector15>:
.globl vector15
vector15:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $15
80106622:	6a 0f                	push   $0xf
  jmp alltraps
80106624:	e9 c1 f8 ff ff       	jmp    80105eea <alltraps>

80106629 <vector16>:
.globl vector16
vector16:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $16
8010662b:	6a 10                	push   $0x10
  jmp alltraps
8010662d:	e9 b8 f8 ff ff       	jmp    80105eea <alltraps>

80106632 <vector17>:
.globl vector17
vector17:
  pushl $17
80106632:	6a 11                	push   $0x11
  jmp alltraps
80106634:	e9 b1 f8 ff ff       	jmp    80105eea <alltraps>

80106639 <vector18>:
.globl vector18
vector18:
  pushl $0
80106639:	6a 00                	push   $0x0
  pushl $18
8010663b:	6a 12                	push   $0x12
  jmp alltraps
8010663d:	e9 a8 f8 ff ff       	jmp    80105eea <alltraps>

80106642 <vector19>:
.globl vector19
vector19:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $19
80106644:	6a 13                	push   $0x13
  jmp alltraps
80106646:	e9 9f f8 ff ff       	jmp    80105eea <alltraps>

8010664b <vector20>:
.globl vector20
vector20:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $20
8010664d:	6a 14                	push   $0x14
  jmp alltraps
8010664f:	e9 96 f8 ff ff       	jmp    80105eea <alltraps>

80106654 <vector21>:
.globl vector21
vector21:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $21
80106656:	6a 15                	push   $0x15
  jmp alltraps
80106658:	e9 8d f8 ff ff       	jmp    80105eea <alltraps>

8010665d <vector22>:
.globl vector22
vector22:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $22
8010665f:	6a 16                	push   $0x16
  jmp alltraps
80106661:	e9 84 f8 ff ff       	jmp    80105eea <alltraps>

80106666 <vector23>:
.globl vector23
vector23:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $23
80106668:	6a 17                	push   $0x17
  jmp alltraps
8010666a:	e9 7b f8 ff ff       	jmp    80105eea <alltraps>

8010666f <vector24>:
.globl vector24
vector24:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $24
80106671:	6a 18                	push   $0x18
  jmp alltraps
80106673:	e9 72 f8 ff ff       	jmp    80105eea <alltraps>

80106678 <vector25>:
.globl vector25
vector25:
  pushl $0
80106678:	6a 00                	push   $0x0
  pushl $25
8010667a:	6a 19                	push   $0x19
  jmp alltraps
8010667c:	e9 69 f8 ff ff       	jmp    80105eea <alltraps>

80106681 <vector26>:
.globl vector26
vector26:
  pushl $0
80106681:	6a 00                	push   $0x0
  pushl $26
80106683:	6a 1a                	push   $0x1a
  jmp alltraps
80106685:	e9 60 f8 ff ff       	jmp    80105eea <alltraps>

8010668a <vector27>:
.globl vector27
vector27:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $27
8010668c:	6a 1b                	push   $0x1b
  jmp alltraps
8010668e:	e9 57 f8 ff ff       	jmp    80105eea <alltraps>

80106693 <vector28>:
.globl vector28
vector28:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $28
80106695:	6a 1c                	push   $0x1c
  jmp alltraps
80106697:	e9 4e f8 ff ff       	jmp    80105eea <alltraps>

8010669c <vector29>:
.globl vector29
vector29:
  pushl $0
8010669c:	6a 00                	push   $0x0
  pushl $29
8010669e:	6a 1d                	push   $0x1d
  jmp alltraps
801066a0:	e9 45 f8 ff ff       	jmp    80105eea <alltraps>

801066a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801066a5:	6a 00                	push   $0x0
  pushl $30
801066a7:	6a 1e                	push   $0x1e
  jmp alltraps
801066a9:	e9 3c f8 ff ff       	jmp    80105eea <alltraps>

801066ae <vector31>:
.globl vector31
vector31:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $31
801066b0:	6a 1f                	push   $0x1f
  jmp alltraps
801066b2:	e9 33 f8 ff ff       	jmp    80105eea <alltraps>

801066b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $32
801066b9:	6a 20                	push   $0x20
  jmp alltraps
801066bb:	e9 2a f8 ff ff       	jmp    80105eea <alltraps>

801066c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801066c0:	6a 00                	push   $0x0
  pushl $33
801066c2:	6a 21                	push   $0x21
  jmp alltraps
801066c4:	e9 21 f8 ff ff       	jmp    80105eea <alltraps>

801066c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801066c9:	6a 00                	push   $0x0
  pushl $34
801066cb:	6a 22                	push   $0x22
  jmp alltraps
801066cd:	e9 18 f8 ff ff       	jmp    80105eea <alltraps>

801066d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $35
801066d4:	6a 23                	push   $0x23
  jmp alltraps
801066d6:	e9 0f f8 ff ff       	jmp    80105eea <alltraps>

801066db <vector36>:
.globl vector36
vector36:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $36
801066dd:	6a 24                	push   $0x24
  jmp alltraps
801066df:	e9 06 f8 ff ff       	jmp    80105eea <alltraps>

801066e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801066e4:	6a 00                	push   $0x0
  pushl $37
801066e6:	6a 25                	push   $0x25
  jmp alltraps
801066e8:	e9 fd f7 ff ff       	jmp    80105eea <alltraps>

801066ed <vector38>:
.globl vector38
vector38:
  pushl $0
801066ed:	6a 00                	push   $0x0
  pushl $38
801066ef:	6a 26                	push   $0x26
  jmp alltraps
801066f1:	e9 f4 f7 ff ff       	jmp    80105eea <alltraps>

801066f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801066f6:	6a 00                	push   $0x0
  pushl $39
801066f8:	6a 27                	push   $0x27
  jmp alltraps
801066fa:	e9 eb f7 ff ff       	jmp    80105eea <alltraps>

801066ff <vector40>:
.globl vector40
vector40:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $40
80106701:	6a 28                	push   $0x28
  jmp alltraps
80106703:	e9 e2 f7 ff ff       	jmp    80105eea <alltraps>

80106708 <vector41>:
.globl vector41
vector41:
  pushl $0
80106708:	6a 00                	push   $0x0
  pushl $41
8010670a:	6a 29                	push   $0x29
  jmp alltraps
8010670c:	e9 d9 f7 ff ff       	jmp    80105eea <alltraps>

80106711 <vector42>:
.globl vector42
vector42:
  pushl $0
80106711:	6a 00                	push   $0x0
  pushl $42
80106713:	6a 2a                	push   $0x2a
  jmp alltraps
80106715:	e9 d0 f7 ff ff       	jmp    80105eea <alltraps>

8010671a <vector43>:
.globl vector43
vector43:
  pushl $0
8010671a:	6a 00                	push   $0x0
  pushl $43
8010671c:	6a 2b                	push   $0x2b
  jmp alltraps
8010671e:	e9 c7 f7 ff ff       	jmp    80105eea <alltraps>

80106723 <vector44>:
.globl vector44
vector44:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $44
80106725:	6a 2c                	push   $0x2c
  jmp alltraps
80106727:	e9 be f7 ff ff       	jmp    80105eea <alltraps>

8010672c <vector45>:
.globl vector45
vector45:
  pushl $0
8010672c:	6a 00                	push   $0x0
  pushl $45
8010672e:	6a 2d                	push   $0x2d
  jmp alltraps
80106730:	e9 b5 f7 ff ff       	jmp    80105eea <alltraps>

80106735 <vector46>:
.globl vector46
vector46:
  pushl $0
80106735:	6a 00                	push   $0x0
  pushl $46
80106737:	6a 2e                	push   $0x2e
  jmp alltraps
80106739:	e9 ac f7 ff ff       	jmp    80105eea <alltraps>

8010673e <vector47>:
.globl vector47
vector47:
  pushl $0
8010673e:	6a 00                	push   $0x0
  pushl $47
80106740:	6a 2f                	push   $0x2f
  jmp alltraps
80106742:	e9 a3 f7 ff ff       	jmp    80105eea <alltraps>

80106747 <vector48>:
.globl vector48
vector48:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $48
80106749:	6a 30                	push   $0x30
  jmp alltraps
8010674b:	e9 9a f7 ff ff       	jmp    80105eea <alltraps>

80106750 <vector49>:
.globl vector49
vector49:
  pushl $0
80106750:	6a 00                	push   $0x0
  pushl $49
80106752:	6a 31                	push   $0x31
  jmp alltraps
80106754:	e9 91 f7 ff ff       	jmp    80105eea <alltraps>

80106759 <vector50>:
.globl vector50
vector50:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $50
8010675b:	6a 32                	push   $0x32
  jmp alltraps
8010675d:	e9 88 f7 ff ff       	jmp    80105eea <alltraps>

80106762 <vector51>:
.globl vector51
vector51:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $51
80106764:	6a 33                	push   $0x33
  jmp alltraps
80106766:	e9 7f f7 ff ff       	jmp    80105eea <alltraps>

8010676b <vector52>:
.globl vector52
vector52:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $52
8010676d:	6a 34                	push   $0x34
  jmp alltraps
8010676f:	e9 76 f7 ff ff       	jmp    80105eea <alltraps>

80106774 <vector53>:
.globl vector53
vector53:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $53
80106776:	6a 35                	push   $0x35
  jmp alltraps
80106778:	e9 6d f7 ff ff       	jmp    80105eea <alltraps>

8010677d <vector54>:
.globl vector54
vector54:
  pushl $0
8010677d:	6a 00                	push   $0x0
  pushl $54
8010677f:	6a 36                	push   $0x36
  jmp alltraps
80106781:	e9 64 f7 ff ff       	jmp    80105eea <alltraps>

80106786 <vector55>:
.globl vector55
vector55:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $55
80106788:	6a 37                	push   $0x37
  jmp alltraps
8010678a:	e9 5b f7 ff ff       	jmp    80105eea <alltraps>

8010678f <vector56>:
.globl vector56
vector56:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $56
80106791:	6a 38                	push   $0x38
  jmp alltraps
80106793:	e9 52 f7 ff ff       	jmp    80105eea <alltraps>

80106798 <vector57>:
.globl vector57
vector57:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $57
8010679a:	6a 39                	push   $0x39
  jmp alltraps
8010679c:	e9 49 f7 ff ff       	jmp    80105eea <alltraps>

801067a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801067a1:	6a 00                	push   $0x0
  pushl $58
801067a3:	6a 3a                	push   $0x3a
  jmp alltraps
801067a5:	e9 40 f7 ff ff       	jmp    80105eea <alltraps>

801067aa <vector59>:
.globl vector59
vector59:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $59
801067ac:	6a 3b                	push   $0x3b
  jmp alltraps
801067ae:	e9 37 f7 ff ff       	jmp    80105eea <alltraps>

801067b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $60
801067b5:	6a 3c                	push   $0x3c
  jmp alltraps
801067b7:	e9 2e f7 ff ff       	jmp    80105eea <alltraps>

801067bc <vector61>:
.globl vector61
vector61:
  pushl $0
801067bc:	6a 00                	push   $0x0
  pushl $61
801067be:	6a 3d                	push   $0x3d
  jmp alltraps
801067c0:	e9 25 f7 ff ff       	jmp    80105eea <alltraps>

801067c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801067c5:	6a 00                	push   $0x0
  pushl $62
801067c7:	6a 3e                	push   $0x3e
  jmp alltraps
801067c9:	e9 1c f7 ff ff       	jmp    80105eea <alltraps>

801067ce <vector63>:
.globl vector63
vector63:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $63
801067d0:	6a 3f                	push   $0x3f
  jmp alltraps
801067d2:	e9 13 f7 ff ff       	jmp    80105eea <alltraps>

801067d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $64
801067d9:	6a 40                	push   $0x40
  jmp alltraps
801067db:	e9 0a f7 ff ff       	jmp    80105eea <alltraps>

801067e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801067e0:	6a 00                	push   $0x0
  pushl $65
801067e2:	6a 41                	push   $0x41
  jmp alltraps
801067e4:	e9 01 f7 ff ff       	jmp    80105eea <alltraps>

801067e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $66
801067eb:	6a 42                	push   $0x42
  jmp alltraps
801067ed:	e9 f8 f6 ff ff       	jmp    80105eea <alltraps>

801067f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $67
801067f4:	6a 43                	push   $0x43
  jmp alltraps
801067f6:	e9 ef f6 ff ff       	jmp    80105eea <alltraps>

801067fb <vector68>:
.globl vector68
vector68:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $68
801067fd:	6a 44                	push   $0x44
  jmp alltraps
801067ff:	e9 e6 f6 ff ff       	jmp    80105eea <alltraps>

80106804 <vector69>:
.globl vector69
vector69:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $69
80106806:	6a 45                	push   $0x45
  jmp alltraps
80106808:	e9 dd f6 ff ff       	jmp    80105eea <alltraps>

8010680d <vector70>:
.globl vector70
vector70:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $70
8010680f:	6a 46                	push   $0x46
  jmp alltraps
80106811:	e9 d4 f6 ff ff       	jmp    80105eea <alltraps>

80106816 <vector71>:
.globl vector71
vector71:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $71
80106818:	6a 47                	push   $0x47
  jmp alltraps
8010681a:	e9 cb f6 ff ff       	jmp    80105eea <alltraps>

8010681f <vector72>:
.globl vector72
vector72:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $72
80106821:	6a 48                	push   $0x48
  jmp alltraps
80106823:	e9 c2 f6 ff ff       	jmp    80105eea <alltraps>

80106828 <vector73>:
.globl vector73
vector73:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $73
8010682a:	6a 49                	push   $0x49
  jmp alltraps
8010682c:	e9 b9 f6 ff ff       	jmp    80105eea <alltraps>

80106831 <vector74>:
.globl vector74
vector74:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $74
80106833:	6a 4a                	push   $0x4a
  jmp alltraps
80106835:	e9 b0 f6 ff ff       	jmp    80105eea <alltraps>

8010683a <vector75>:
.globl vector75
vector75:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $75
8010683c:	6a 4b                	push   $0x4b
  jmp alltraps
8010683e:	e9 a7 f6 ff ff       	jmp    80105eea <alltraps>

80106843 <vector76>:
.globl vector76
vector76:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $76
80106845:	6a 4c                	push   $0x4c
  jmp alltraps
80106847:	e9 9e f6 ff ff       	jmp    80105eea <alltraps>

8010684c <vector77>:
.globl vector77
vector77:
  pushl $0
8010684c:	6a 00                	push   $0x0
  pushl $77
8010684e:	6a 4d                	push   $0x4d
  jmp alltraps
80106850:	e9 95 f6 ff ff       	jmp    80105eea <alltraps>

80106855 <vector78>:
.globl vector78
vector78:
  pushl $0
80106855:	6a 00                	push   $0x0
  pushl $78
80106857:	6a 4e                	push   $0x4e
  jmp alltraps
80106859:	e9 8c f6 ff ff       	jmp    80105eea <alltraps>

8010685e <vector79>:
.globl vector79
vector79:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $79
80106860:	6a 4f                	push   $0x4f
  jmp alltraps
80106862:	e9 83 f6 ff ff       	jmp    80105eea <alltraps>

80106867 <vector80>:
.globl vector80
vector80:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $80
80106869:	6a 50                	push   $0x50
  jmp alltraps
8010686b:	e9 7a f6 ff ff       	jmp    80105eea <alltraps>

80106870 <vector81>:
.globl vector81
vector81:
  pushl $0
80106870:	6a 00                	push   $0x0
  pushl $81
80106872:	6a 51                	push   $0x51
  jmp alltraps
80106874:	e9 71 f6 ff ff       	jmp    80105eea <alltraps>

80106879 <vector82>:
.globl vector82
vector82:
  pushl $0
80106879:	6a 00                	push   $0x0
  pushl $82
8010687b:	6a 52                	push   $0x52
  jmp alltraps
8010687d:	e9 68 f6 ff ff       	jmp    80105eea <alltraps>

80106882 <vector83>:
.globl vector83
vector83:
  pushl $0
80106882:	6a 00                	push   $0x0
  pushl $83
80106884:	6a 53                	push   $0x53
  jmp alltraps
80106886:	e9 5f f6 ff ff       	jmp    80105eea <alltraps>

8010688b <vector84>:
.globl vector84
vector84:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $84
8010688d:	6a 54                	push   $0x54
  jmp alltraps
8010688f:	e9 56 f6 ff ff       	jmp    80105eea <alltraps>

80106894 <vector85>:
.globl vector85
vector85:
  pushl $0
80106894:	6a 00                	push   $0x0
  pushl $85
80106896:	6a 55                	push   $0x55
  jmp alltraps
80106898:	e9 4d f6 ff ff       	jmp    80105eea <alltraps>

8010689d <vector86>:
.globl vector86
vector86:
  pushl $0
8010689d:	6a 00                	push   $0x0
  pushl $86
8010689f:	6a 56                	push   $0x56
  jmp alltraps
801068a1:	e9 44 f6 ff ff       	jmp    80105eea <alltraps>

801068a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801068a6:	6a 00                	push   $0x0
  pushl $87
801068a8:	6a 57                	push   $0x57
  jmp alltraps
801068aa:	e9 3b f6 ff ff       	jmp    80105eea <alltraps>

801068af <vector88>:
.globl vector88
vector88:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $88
801068b1:	6a 58                	push   $0x58
  jmp alltraps
801068b3:	e9 32 f6 ff ff       	jmp    80105eea <alltraps>

801068b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801068b8:	6a 00                	push   $0x0
  pushl $89
801068ba:	6a 59                	push   $0x59
  jmp alltraps
801068bc:	e9 29 f6 ff ff       	jmp    80105eea <alltraps>

801068c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801068c1:	6a 00                	push   $0x0
  pushl $90
801068c3:	6a 5a                	push   $0x5a
  jmp alltraps
801068c5:	e9 20 f6 ff ff       	jmp    80105eea <alltraps>

801068ca <vector91>:
.globl vector91
vector91:
  pushl $0
801068ca:	6a 00                	push   $0x0
  pushl $91
801068cc:	6a 5b                	push   $0x5b
  jmp alltraps
801068ce:	e9 17 f6 ff ff       	jmp    80105eea <alltraps>

801068d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $92
801068d5:	6a 5c                	push   $0x5c
  jmp alltraps
801068d7:	e9 0e f6 ff ff       	jmp    80105eea <alltraps>

801068dc <vector93>:
.globl vector93
vector93:
  pushl $0
801068dc:	6a 00                	push   $0x0
  pushl $93
801068de:	6a 5d                	push   $0x5d
  jmp alltraps
801068e0:	e9 05 f6 ff ff       	jmp    80105eea <alltraps>

801068e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801068e5:	6a 00                	push   $0x0
  pushl $94
801068e7:	6a 5e                	push   $0x5e
  jmp alltraps
801068e9:	e9 fc f5 ff ff       	jmp    80105eea <alltraps>

801068ee <vector95>:
.globl vector95
vector95:
  pushl $0
801068ee:	6a 00                	push   $0x0
  pushl $95
801068f0:	6a 5f                	push   $0x5f
  jmp alltraps
801068f2:	e9 f3 f5 ff ff       	jmp    80105eea <alltraps>

801068f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $96
801068f9:	6a 60                	push   $0x60
  jmp alltraps
801068fb:	e9 ea f5 ff ff       	jmp    80105eea <alltraps>

80106900 <vector97>:
.globl vector97
vector97:
  pushl $0
80106900:	6a 00                	push   $0x0
  pushl $97
80106902:	6a 61                	push   $0x61
  jmp alltraps
80106904:	e9 e1 f5 ff ff       	jmp    80105eea <alltraps>

80106909 <vector98>:
.globl vector98
vector98:
  pushl $0
80106909:	6a 00                	push   $0x0
  pushl $98
8010690b:	6a 62                	push   $0x62
  jmp alltraps
8010690d:	e9 d8 f5 ff ff       	jmp    80105eea <alltraps>

80106912 <vector99>:
.globl vector99
vector99:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $99
80106914:	6a 63                	push   $0x63
  jmp alltraps
80106916:	e9 cf f5 ff ff       	jmp    80105eea <alltraps>

8010691b <vector100>:
.globl vector100
vector100:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $100
8010691d:	6a 64                	push   $0x64
  jmp alltraps
8010691f:	e9 c6 f5 ff ff       	jmp    80105eea <alltraps>

80106924 <vector101>:
.globl vector101
vector101:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $101
80106926:	6a 65                	push   $0x65
  jmp alltraps
80106928:	e9 bd f5 ff ff       	jmp    80105eea <alltraps>

8010692d <vector102>:
.globl vector102
vector102:
  pushl $0
8010692d:	6a 00                	push   $0x0
  pushl $102
8010692f:	6a 66                	push   $0x66
  jmp alltraps
80106931:	e9 b4 f5 ff ff       	jmp    80105eea <alltraps>

80106936 <vector103>:
.globl vector103
vector103:
  pushl $0
80106936:	6a 00                	push   $0x0
  pushl $103
80106938:	6a 67                	push   $0x67
  jmp alltraps
8010693a:	e9 ab f5 ff ff       	jmp    80105eea <alltraps>

8010693f <vector104>:
.globl vector104
vector104:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $104
80106941:	6a 68                	push   $0x68
  jmp alltraps
80106943:	e9 a2 f5 ff ff       	jmp    80105eea <alltraps>

80106948 <vector105>:
.globl vector105
vector105:
  pushl $0
80106948:	6a 00                	push   $0x0
  pushl $105
8010694a:	6a 69                	push   $0x69
  jmp alltraps
8010694c:	e9 99 f5 ff ff       	jmp    80105eea <alltraps>

80106951 <vector106>:
.globl vector106
vector106:
  pushl $0
80106951:	6a 00                	push   $0x0
  pushl $106
80106953:	6a 6a                	push   $0x6a
  jmp alltraps
80106955:	e9 90 f5 ff ff       	jmp    80105eea <alltraps>

8010695a <vector107>:
.globl vector107
vector107:
  pushl $0
8010695a:	6a 00                	push   $0x0
  pushl $107
8010695c:	6a 6b                	push   $0x6b
  jmp alltraps
8010695e:	e9 87 f5 ff ff       	jmp    80105eea <alltraps>

80106963 <vector108>:
.globl vector108
vector108:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $108
80106965:	6a 6c                	push   $0x6c
  jmp alltraps
80106967:	e9 7e f5 ff ff       	jmp    80105eea <alltraps>

8010696c <vector109>:
.globl vector109
vector109:
  pushl $0
8010696c:	6a 00                	push   $0x0
  pushl $109
8010696e:	6a 6d                	push   $0x6d
  jmp alltraps
80106970:	e9 75 f5 ff ff       	jmp    80105eea <alltraps>

80106975 <vector110>:
.globl vector110
vector110:
  pushl $0
80106975:	6a 00                	push   $0x0
  pushl $110
80106977:	6a 6e                	push   $0x6e
  jmp alltraps
80106979:	e9 6c f5 ff ff       	jmp    80105eea <alltraps>

8010697e <vector111>:
.globl vector111
vector111:
  pushl $0
8010697e:	6a 00                	push   $0x0
  pushl $111
80106980:	6a 6f                	push   $0x6f
  jmp alltraps
80106982:	e9 63 f5 ff ff       	jmp    80105eea <alltraps>

80106987 <vector112>:
.globl vector112
vector112:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $112
80106989:	6a 70                	push   $0x70
  jmp alltraps
8010698b:	e9 5a f5 ff ff       	jmp    80105eea <alltraps>

80106990 <vector113>:
.globl vector113
vector113:
  pushl $0
80106990:	6a 00                	push   $0x0
  pushl $113
80106992:	6a 71                	push   $0x71
  jmp alltraps
80106994:	e9 51 f5 ff ff       	jmp    80105eea <alltraps>

80106999 <vector114>:
.globl vector114
vector114:
  pushl $0
80106999:	6a 00                	push   $0x0
  pushl $114
8010699b:	6a 72                	push   $0x72
  jmp alltraps
8010699d:	e9 48 f5 ff ff       	jmp    80105eea <alltraps>

801069a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801069a2:	6a 00                	push   $0x0
  pushl $115
801069a4:	6a 73                	push   $0x73
  jmp alltraps
801069a6:	e9 3f f5 ff ff       	jmp    80105eea <alltraps>

801069ab <vector116>:
.globl vector116
vector116:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $116
801069ad:	6a 74                	push   $0x74
  jmp alltraps
801069af:	e9 36 f5 ff ff       	jmp    80105eea <alltraps>

801069b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801069b4:	6a 00                	push   $0x0
  pushl $117
801069b6:	6a 75                	push   $0x75
  jmp alltraps
801069b8:	e9 2d f5 ff ff       	jmp    80105eea <alltraps>

801069bd <vector118>:
.globl vector118
vector118:
  pushl $0
801069bd:	6a 00                	push   $0x0
  pushl $118
801069bf:	6a 76                	push   $0x76
  jmp alltraps
801069c1:	e9 24 f5 ff ff       	jmp    80105eea <alltraps>

801069c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801069c6:	6a 00                	push   $0x0
  pushl $119
801069c8:	6a 77                	push   $0x77
  jmp alltraps
801069ca:	e9 1b f5 ff ff       	jmp    80105eea <alltraps>

801069cf <vector120>:
.globl vector120
vector120:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $120
801069d1:	6a 78                	push   $0x78
  jmp alltraps
801069d3:	e9 12 f5 ff ff       	jmp    80105eea <alltraps>

801069d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801069d8:	6a 00                	push   $0x0
  pushl $121
801069da:	6a 79                	push   $0x79
  jmp alltraps
801069dc:	e9 09 f5 ff ff       	jmp    80105eea <alltraps>

801069e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801069e1:	6a 00                	push   $0x0
  pushl $122
801069e3:	6a 7a                	push   $0x7a
  jmp alltraps
801069e5:	e9 00 f5 ff ff       	jmp    80105eea <alltraps>

801069ea <vector123>:
.globl vector123
vector123:
  pushl $0
801069ea:	6a 00                	push   $0x0
  pushl $123
801069ec:	6a 7b                	push   $0x7b
  jmp alltraps
801069ee:	e9 f7 f4 ff ff       	jmp    80105eea <alltraps>

801069f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $124
801069f5:	6a 7c                	push   $0x7c
  jmp alltraps
801069f7:	e9 ee f4 ff ff       	jmp    80105eea <alltraps>

801069fc <vector125>:
.globl vector125
vector125:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $125
801069fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106a00:	e9 e5 f4 ff ff       	jmp    80105eea <alltraps>

80106a05 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a05:	6a 00                	push   $0x0
  pushl $126
80106a07:	6a 7e                	push   $0x7e
  jmp alltraps
80106a09:	e9 dc f4 ff ff       	jmp    80105eea <alltraps>

80106a0e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a0e:	6a 00                	push   $0x0
  pushl $127
80106a10:	6a 7f                	push   $0x7f
  jmp alltraps
80106a12:	e9 d3 f4 ff ff       	jmp    80105eea <alltraps>

80106a17 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $128
80106a19:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a1e:	e9 c7 f4 ff ff       	jmp    80105eea <alltraps>

80106a23 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $129
80106a25:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a2a:	e9 bb f4 ff ff       	jmp    80105eea <alltraps>

80106a2f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $130
80106a31:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a36:	e9 af f4 ff ff       	jmp    80105eea <alltraps>

80106a3b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $131
80106a3d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a42:	e9 a3 f4 ff ff       	jmp    80105eea <alltraps>

80106a47 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $132
80106a49:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a4e:	e9 97 f4 ff ff       	jmp    80105eea <alltraps>

80106a53 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $133
80106a55:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a5a:	e9 8b f4 ff ff       	jmp    80105eea <alltraps>

80106a5f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $134
80106a61:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a66:	e9 7f f4 ff ff       	jmp    80105eea <alltraps>

80106a6b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $135
80106a6d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a72:	e9 73 f4 ff ff       	jmp    80105eea <alltraps>

80106a77 <vector136>:
.globl vector136
vector136:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $136
80106a79:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a7e:	e9 67 f4 ff ff       	jmp    80105eea <alltraps>

80106a83 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $137
80106a85:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a8a:	e9 5b f4 ff ff       	jmp    80105eea <alltraps>

80106a8f <vector138>:
.globl vector138
vector138:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $138
80106a91:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a96:	e9 4f f4 ff ff       	jmp    80105eea <alltraps>

80106a9b <vector139>:
.globl vector139
vector139:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $139
80106a9d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106aa2:	e9 43 f4 ff ff       	jmp    80105eea <alltraps>

80106aa7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $140
80106aa9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106aae:	e9 37 f4 ff ff       	jmp    80105eea <alltraps>

80106ab3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $141
80106ab5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106aba:	e9 2b f4 ff ff       	jmp    80105eea <alltraps>

80106abf <vector142>:
.globl vector142
vector142:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $142
80106ac1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106ac6:	e9 1f f4 ff ff       	jmp    80105eea <alltraps>

80106acb <vector143>:
.globl vector143
vector143:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $143
80106acd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ad2:	e9 13 f4 ff ff       	jmp    80105eea <alltraps>

80106ad7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $144
80106ad9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ade:	e9 07 f4 ff ff       	jmp    80105eea <alltraps>

80106ae3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $145
80106ae5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106aea:	e9 fb f3 ff ff       	jmp    80105eea <alltraps>

80106aef <vector146>:
.globl vector146
vector146:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $146
80106af1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106af6:	e9 ef f3 ff ff       	jmp    80105eea <alltraps>

80106afb <vector147>:
.globl vector147
vector147:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $147
80106afd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b02:	e9 e3 f3 ff ff       	jmp    80105eea <alltraps>

80106b07 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $148
80106b09:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b0e:	e9 d7 f3 ff ff       	jmp    80105eea <alltraps>

80106b13 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $149
80106b15:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b1a:	e9 cb f3 ff ff       	jmp    80105eea <alltraps>

80106b1f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $150
80106b21:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b26:	e9 bf f3 ff ff       	jmp    80105eea <alltraps>

80106b2b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $151
80106b2d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b32:	e9 b3 f3 ff ff       	jmp    80105eea <alltraps>

80106b37 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $152
80106b39:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b3e:	e9 a7 f3 ff ff       	jmp    80105eea <alltraps>

80106b43 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $153
80106b45:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b4a:	e9 9b f3 ff ff       	jmp    80105eea <alltraps>

80106b4f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $154
80106b51:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b56:	e9 8f f3 ff ff       	jmp    80105eea <alltraps>

80106b5b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $155
80106b5d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b62:	e9 83 f3 ff ff       	jmp    80105eea <alltraps>

80106b67 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $156
80106b69:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b6e:	e9 77 f3 ff ff       	jmp    80105eea <alltraps>

80106b73 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $157
80106b75:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b7a:	e9 6b f3 ff ff       	jmp    80105eea <alltraps>

80106b7f <vector158>:
.globl vector158
vector158:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $158
80106b81:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b86:	e9 5f f3 ff ff       	jmp    80105eea <alltraps>

80106b8b <vector159>:
.globl vector159
vector159:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $159
80106b8d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b92:	e9 53 f3 ff ff       	jmp    80105eea <alltraps>

80106b97 <vector160>:
.globl vector160
vector160:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $160
80106b99:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b9e:	e9 47 f3 ff ff       	jmp    80105eea <alltraps>

80106ba3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $161
80106ba5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106baa:	e9 3b f3 ff ff       	jmp    80105eea <alltraps>

80106baf <vector162>:
.globl vector162
vector162:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $162
80106bb1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106bb6:	e9 2f f3 ff ff       	jmp    80105eea <alltraps>

80106bbb <vector163>:
.globl vector163
vector163:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $163
80106bbd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106bc2:	e9 23 f3 ff ff       	jmp    80105eea <alltraps>

80106bc7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $164
80106bc9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106bce:	e9 17 f3 ff ff       	jmp    80105eea <alltraps>

80106bd3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $165
80106bd5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106bda:	e9 0b f3 ff ff       	jmp    80105eea <alltraps>

80106bdf <vector166>:
.globl vector166
vector166:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $166
80106be1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106be6:	e9 ff f2 ff ff       	jmp    80105eea <alltraps>

80106beb <vector167>:
.globl vector167
vector167:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $167
80106bed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106bf2:	e9 f3 f2 ff ff       	jmp    80105eea <alltraps>

80106bf7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $168
80106bf9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106bfe:	e9 e7 f2 ff ff       	jmp    80105eea <alltraps>

80106c03 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $169
80106c05:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c0a:	e9 db f2 ff ff       	jmp    80105eea <alltraps>

80106c0f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $170
80106c11:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c16:	e9 cf f2 ff ff       	jmp    80105eea <alltraps>

80106c1b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $171
80106c1d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c22:	e9 c3 f2 ff ff       	jmp    80105eea <alltraps>

80106c27 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $172
80106c29:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c2e:	e9 b7 f2 ff ff       	jmp    80105eea <alltraps>

80106c33 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $173
80106c35:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c3a:	e9 ab f2 ff ff       	jmp    80105eea <alltraps>

80106c3f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $174
80106c41:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c46:	e9 9f f2 ff ff       	jmp    80105eea <alltraps>

80106c4b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $175
80106c4d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c52:	e9 93 f2 ff ff       	jmp    80105eea <alltraps>

80106c57 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $176
80106c59:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c5e:	e9 87 f2 ff ff       	jmp    80105eea <alltraps>

80106c63 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $177
80106c65:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c6a:	e9 7b f2 ff ff       	jmp    80105eea <alltraps>

80106c6f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $178
80106c71:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c76:	e9 6f f2 ff ff       	jmp    80105eea <alltraps>

80106c7b <vector179>:
.globl vector179
vector179:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $179
80106c7d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c82:	e9 63 f2 ff ff       	jmp    80105eea <alltraps>

80106c87 <vector180>:
.globl vector180
vector180:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $180
80106c89:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c8e:	e9 57 f2 ff ff       	jmp    80105eea <alltraps>

80106c93 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $181
80106c95:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c9a:	e9 4b f2 ff ff       	jmp    80105eea <alltraps>

80106c9f <vector182>:
.globl vector182
vector182:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $182
80106ca1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ca6:	e9 3f f2 ff ff       	jmp    80105eea <alltraps>

80106cab <vector183>:
.globl vector183
vector183:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $183
80106cad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106cb2:	e9 33 f2 ff ff       	jmp    80105eea <alltraps>

80106cb7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $184
80106cb9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cbe:	e9 27 f2 ff ff       	jmp    80105eea <alltraps>

80106cc3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $185
80106cc5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cca:	e9 1b f2 ff ff       	jmp    80105eea <alltraps>

80106ccf <vector186>:
.globl vector186
vector186:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $186
80106cd1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106cd6:	e9 0f f2 ff ff       	jmp    80105eea <alltraps>

80106cdb <vector187>:
.globl vector187
vector187:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $187
80106cdd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ce2:	e9 03 f2 ff ff       	jmp    80105eea <alltraps>

80106ce7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $188
80106ce9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106cee:	e9 f7 f1 ff ff       	jmp    80105eea <alltraps>

80106cf3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $189
80106cf5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106cfa:	e9 eb f1 ff ff       	jmp    80105eea <alltraps>

80106cff <vector190>:
.globl vector190
vector190:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $190
80106d01:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d06:	e9 df f1 ff ff       	jmp    80105eea <alltraps>

80106d0b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $191
80106d0d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d12:	e9 d3 f1 ff ff       	jmp    80105eea <alltraps>

80106d17 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $192
80106d19:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d1e:	e9 c7 f1 ff ff       	jmp    80105eea <alltraps>

80106d23 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $193
80106d25:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d2a:	e9 bb f1 ff ff       	jmp    80105eea <alltraps>

80106d2f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $194
80106d31:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d36:	e9 af f1 ff ff       	jmp    80105eea <alltraps>

80106d3b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $195
80106d3d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d42:	e9 a3 f1 ff ff       	jmp    80105eea <alltraps>

80106d47 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $196
80106d49:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d4e:	e9 97 f1 ff ff       	jmp    80105eea <alltraps>

80106d53 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $197
80106d55:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d5a:	e9 8b f1 ff ff       	jmp    80105eea <alltraps>

80106d5f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $198
80106d61:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d66:	e9 7f f1 ff ff       	jmp    80105eea <alltraps>

80106d6b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $199
80106d6d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d72:	e9 73 f1 ff ff       	jmp    80105eea <alltraps>

80106d77 <vector200>:
.globl vector200
vector200:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $200
80106d79:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d7e:	e9 67 f1 ff ff       	jmp    80105eea <alltraps>

80106d83 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $201
80106d85:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d8a:	e9 5b f1 ff ff       	jmp    80105eea <alltraps>

80106d8f <vector202>:
.globl vector202
vector202:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $202
80106d91:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d96:	e9 4f f1 ff ff       	jmp    80105eea <alltraps>

80106d9b <vector203>:
.globl vector203
vector203:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $203
80106d9d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106da2:	e9 43 f1 ff ff       	jmp    80105eea <alltraps>

80106da7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $204
80106da9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106dae:	e9 37 f1 ff ff       	jmp    80105eea <alltraps>

80106db3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $205
80106db5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dba:	e9 2b f1 ff ff       	jmp    80105eea <alltraps>

80106dbf <vector206>:
.globl vector206
vector206:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $206
80106dc1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106dc6:	e9 1f f1 ff ff       	jmp    80105eea <alltraps>

80106dcb <vector207>:
.globl vector207
vector207:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $207
80106dcd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106dd2:	e9 13 f1 ff ff       	jmp    80105eea <alltraps>

80106dd7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $208
80106dd9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106dde:	e9 07 f1 ff ff       	jmp    80105eea <alltraps>

80106de3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $209
80106de5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106dea:	e9 fb f0 ff ff       	jmp    80105eea <alltraps>

80106def <vector210>:
.globl vector210
vector210:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $210
80106df1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106df6:	e9 ef f0 ff ff       	jmp    80105eea <alltraps>

80106dfb <vector211>:
.globl vector211
vector211:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $211
80106dfd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e02:	e9 e3 f0 ff ff       	jmp    80105eea <alltraps>

80106e07 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $212
80106e09:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e0e:	e9 d7 f0 ff ff       	jmp    80105eea <alltraps>

80106e13 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $213
80106e15:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e1a:	e9 cb f0 ff ff       	jmp    80105eea <alltraps>

80106e1f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $214
80106e21:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e26:	e9 bf f0 ff ff       	jmp    80105eea <alltraps>

80106e2b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $215
80106e2d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e32:	e9 b3 f0 ff ff       	jmp    80105eea <alltraps>

80106e37 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $216
80106e39:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e3e:	e9 a7 f0 ff ff       	jmp    80105eea <alltraps>

80106e43 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $217
80106e45:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e4a:	e9 9b f0 ff ff       	jmp    80105eea <alltraps>

80106e4f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $218
80106e51:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e56:	e9 8f f0 ff ff       	jmp    80105eea <alltraps>

80106e5b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $219
80106e5d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e62:	e9 83 f0 ff ff       	jmp    80105eea <alltraps>

80106e67 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $220
80106e69:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e6e:	e9 77 f0 ff ff       	jmp    80105eea <alltraps>

80106e73 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $221
80106e75:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e7a:	e9 6b f0 ff ff       	jmp    80105eea <alltraps>

80106e7f <vector222>:
.globl vector222
vector222:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $222
80106e81:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e86:	e9 5f f0 ff ff       	jmp    80105eea <alltraps>

80106e8b <vector223>:
.globl vector223
vector223:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $223
80106e8d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e92:	e9 53 f0 ff ff       	jmp    80105eea <alltraps>

80106e97 <vector224>:
.globl vector224
vector224:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $224
80106e99:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e9e:	e9 47 f0 ff ff       	jmp    80105eea <alltraps>

80106ea3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $225
80106ea5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106eaa:	e9 3b f0 ff ff       	jmp    80105eea <alltraps>

80106eaf <vector226>:
.globl vector226
vector226:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $226
80106eb1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106eb6:	e9 2f f0 ff ff       	jmp    80105eea <alltraps>

80106ebb <vector227>:
.globl vector227
vector227:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $227
80106ebd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ec2:	e9 23 f0 ff ff       	jmp    80105eea <alltraps>

80106ec7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $228
80106ec9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106ece:	e9 17 f0 ff ff       	jmp    80105eea <alltraps>

80106ed3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $229
80106ed5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106eda:	e9 0b f0 ff ff       	jmp    80105eea <alltraps>

80106edf <vector230>:
.globl vector230
vector230:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $230
80106ee1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ee6:	e9 ff ef ff ff       	jmp    80105eea <alltraps>

80106eeb <vector231>:
.globl vector231
vector231:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $231
80106eed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ef2:	e9 f3 ef ff ff       	jmp    80105eea <alltraps>

80106ef7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $232
80106ef9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106efe:	e9 e7 ef ff ff       	jmp    80105eea <alltraps>

80106f03 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $233
80106f05:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f0a:	e9 db ef ff ff       	jmp    80105eea <alltraps>

80106f0f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $234
80106f11:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f16:	e9 cf ef ff ff       	jmp    80105eea <alltraps>

80106f1b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $235
80106f1d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f22:	e9 c3 ef ff ff       	jmp    80105eea <alltraps>

80106f27 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $236
80106f29:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f2e:	e9 b7 ef ff ff       	jmp    80105eea <alltraps>

80106f33 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $237
80106f35:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f3a:	e9 ab ef ff ff       	jmp    80105eea <alltraps>

80106f3f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $238
80106f41:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f46:	e9 9f ef ff ff       	jmp    80105eea <alltraps>

80106f4b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $239
80106f4d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f52:	e9 93 ef ff ff       	jmp    80105eea <alltraps>

80106f57 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $240
80106f59:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f5e:	e9 87 ef ff ff       	jmp    80105eea <alltraps>

80106f63 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $241
80106f65:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f6a:	e9 7b ef ff ff       	jmp    80105eea <alltraps>

80106f6f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $242
80106f71:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f76:	e9 6f ef ff ff       	jmp    80105eea <alltraps>

80106f7b <vector243>:
.globl vector243
vector243:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $243
80106f7d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f82:	e9 63 ef ff ff       	jmp    80105eea <alltraps>

80106f87 <vector244>:
.globl vector244
vector244:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $244
80106f89:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f8e:	e9 57 ef ff ff       	jmp    80105eea <alltraps>

80106f93 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $245
80106f95:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f9a:	e9 4b ef ff ff       	jmp    80105eea <alltraps>

80106f9f <vector246>:
.globl vector246
vector246:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $246
80106fa1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fa6:	e9 3f ef ff ff       	jmp    80105eea <alltraps>

80106fab <vector247>:
.globl vector247
vector247:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $247
80106fad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106fb2:	e9 33 ef ff ff       	jmp    80105eea <alltraps>

80106fb7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $248
80106fb9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106fbe:	e9 27 ef ff ff       	jmp    80105eea <alltraps>

80106fc3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $249
80106fc5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106fca:	e9 1b ef ff ff       	jmp    80105eea <alltraps>

80106fcf <vector250>:
.globl vector250
vector250:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $250
80106fd1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106fd6:	e9 0f ef ff ff       	jmp    80105eea <alltraps>

80106fdb <vector251>:
.globl vector251
vector251:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $251
80106fdd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106fe2:	e9 03 ef ff ff       	jmp    80105eea <alltraps>

80106fe7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $252
80106fe9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106fee:	e9 f7 ee ff ff       	jmp    80105eea <alltraps>

80106ff3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $253
80106ff5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106ffa:	e9 eb ee ff ff       	jmp    80105eea <alltraps>

80106fff <vector254>:
.globl vector254
vector254:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $254
80107001:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107006:	e9 df ee ff ff       	jmp    80105eea <alltraps>

8010700b <vector255>:
.globl vector255
vector255:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $255
8010700d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107012:	e9 d3 ee ff ff       	jmp    80105eea <alltraps>
80107017:	66 90                	xchg   %ax,%ax
80107019:	66 90                	xchg   %ax,%ax
8010701b:	66 90                	xchg   %ax,%ax
8010701d:	66 90                	xchg   %ax,%ax
8010701f:	90                   	nop

80107020 <walkpgdir>:

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	56                   	push   %esi
80107025:	53                   	push   %ebx
//    if (DEBUGMODE == 2&& notShell())
//        cprintf("WALKPGDIR-");
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80107026:	89 d3                	mov    %edx,%ebx
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80107028:	89 d7                	mov    %edx,%edi
    pde = &pgdir[PDX(va)];
8010702a:	c1 eb 16             	shr    $0x16,%ebx
8010702d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80107030:	83 ec 0c             	sub    $0xc,%esp
    if (*pde & PTE_P) {
80107033:	8b 06                	mov    (%esi),%eax
80107035:	a8 01                	test   $0x1,%al
80107037:	74 27                	je     80107060 <walkpgdir+0x40>
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
80107039:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010703e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
//    if (DEBUGMODE == 2&& notShell())
//        cprintf(">WALKPGDIR-DONE!\t");
    return &pgtab[PTX(va)];
80107044:	c1 ef 0a             	shr    $0xa,%edi
}
80107047:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return &pgtab[PTX(va)];
8010704a:	89 fa                	mov    %edi,%edx
8010704c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107052:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107055:	5b                   	pop    %ebx
80107056:	5e                   	pop    %esi
80107057:	5f                   	pop    %edi
80107058:	5d                   	pop    %ebp
80107059:	c3                   	ret    
8010705a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!alloc)
80107060:	85 c9                	test   %ecx,%ecx
80107062:	74 2c                	je     80107090 <walkpgdir+0x70>
        if ((pgtab = (pte_t *) kalloc()) == 0)
80107064:	e8 a7 b8 ff ff       	call   80102910 <kalloc>
80107069:	85 c0                	test   %eax,%eax
8010706b:	89 c3                	mov    %eax,%ebx
8010706d:	74 21                	je     80107090 <walkpgdir+0x70>
        memset(pgtab, 0, PGSIZE);
8010706f:	83 ec 04             	sub    $0x4,%esp
80107072:	68 00 10 00 00       	push   $0x1000
80107077:	6a 00                	push   $0x0
80107079:	50                   	push   %eax
8010707a:	e8 41 dc ff ff       	call   80104cc0 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010707f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107085:	83 c4 10             	add    $0x10,%esp
80107088:	83 c8 07             	or     $0x7,%eax
8010708b:	89 06                	mov    %eax,(%esi)
8010708d:	eb b5                	jmp    80107044 <walkpgdir+0x24>
8010708f:	90                   	nop
}
80107090:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80107093:	31 c0                	xor    %eax,%eax
}
80107095:	5b                   	pop    %ebx
80107096:	5e                   	pop    %esi
80107097:	5f                   	pop    %edi
80107098:	5d                   	pop    %ebp
80107099:	c3                   	ret    
8010709a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070a0 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
    char *a, *last;
    pte_t *pte;

    a = (char *) PGROUNDDOWN((uint) va);
801070a6:	89 d3                	mov    %edx,%ebx
801070a8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801070ae:	83 ec 1c             	sub    $0x1c,%esp
801070b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
801070b4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801070b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801070bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
            panic("remap");
        *pte = pa | perm | PTE_P;
801070c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801070c6:	29 df                	sub    %ebx,%edi
801070c8:	83 c8 01             	or     $0x1,%eax
801070cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801070ce:	eb 15                	jmp    801070e5 <mappages+0x45>
        if (*pte & PTE_P)
801070d0:	f6 00 01             	testb  $0x1,(%eax)
801070d3:	75 45                	jne    8010711a <mappages+0x7a>
        *pte = pa | perm | PTE_P;
801070d5:	0b 75 dc             	or     -0x24(%ebp),%esi
        if (a == last)
801070d8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
        *pte = pa | perm | PTE_P;
801070db:	89 30                	mov    %esi,(%eax)
        if (a == last)
801070dd:	74 31                	je     80107110 <mappages+0x70>
            break;
        a += PGSIZE;
801070df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
801070e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070e8:	b9 01 00 00 00       	mov    $0x1,%ecx
801070ed:	89 da                	mov    %ebx,%edx
801070ef:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801070f2:	e8 29 ff ff ff       	call   80107020 <walkpgdir>
801070f7:	85 c0                	test   %eax,%eax
801070f9:	75 d5                	jne    801070d0 <mappages+0x30>
        pa += PGSIZE;
    }
    return 0;
}
801070fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
801070fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107103:	5b                   	pop    %ebx
80107104:	5e                   	pop    %esi
80107105:	5f                   	pop    %edi
80107106:	5d                   	pop    %ebp
80107107:	c3                   	ret    
80107108:	90                   	nop
80107109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107110:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107113:	31 c0                	xor    %eax,%eax
}
80107115:	5b                   	pop    %ebx
80107116:	5e                   	pop    %esi
80107117:	5f                   	pop    %edi
80107118:	5d                   	pop    %ebp
80107119:	c3                   	ret    
            panic("remap");
8010711a:	83 ec 0c             	sub    $0xc,%esp
8010711d:	68 98 89 10 80       	push   $0x80108998
80107122:	e8 69 92 ff ff       	call   80100390 <panic>
80107127:	89 f6                	mov    %esi,%esi
80107129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107130 <seginit>:
seginit(void) {
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
80107136:	e8 a5 cb ff ff       	call   80103ce0 <cpuid>
8010713b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107141:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107146:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010714a:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80107151:	ff 00 00 
80107154:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
8010715b:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010715e:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80107165:	ff 00 00 
80107168:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
8010716f:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80107172:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80107179:	ff 00 00 
8010717c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107183:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107186:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
8010718d:	ff 00 00 
80107190:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80107197:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
8010719a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
8010719f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801071a3:	c1 e8 10             	shr    $0x10,%eax
801071a6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801071aa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801071ad:	0f 01 10             	lgdtl  (%eax)
}
801071b0:	c9                   	leave  
801071b1:	c3                   	ret    
801071b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071c0 <walkpgdir2>:
walkpgdir2(pde_t *pgdir, const void *va, int alloc) {
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
    return walkpgdir(pgdir, va, alloc);
801071c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801071c6:	8b 55 0c             	mov    0xc(%ebp),%edx
801071c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801071cc:	5d                   	pop    %ebp
    return walkpgdir(pgdir, va, alloc);
801071cd:	e9 4e fe ff ff       	jmp    80107020 <walkpgdir>
801071d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071e0 <mappages2>:

// global use for mappages
int
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
    return mappages(pgdir, va, size, pa, perm);
801071e3:	8b 4d 18             	mov    0x18(%ebp),%ecx
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
801071e6:	8b 55 0c             	mov    0xc(%ebp),%edx
801071e9:	8b 45 08             	mov    0x8(%ebp),%eax
    return mappages(pgdir, va, size, pa, perm);
801071ec:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801071ef:	8b 4d 14             	mov    0x14(%ebp),%ecx
801071f2:	89 4d 08             	mov    %ecx,0x8(%ebp)
801071f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
801071f8:	5d                   	pop    %ebp
    return mappages(pgdir, va, size, pa, perm);
801071f9:	e9 a2 fe ff ff       	jmp    801070a0 <mappages>
801071fe:	66 90                	xchg   %ax,%ax

80107200 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void) {
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107200:	a1 e8 6c 12 80       	mov    0x80126ce8,%eax
switchkvm(void) {
80107205:	55                   	push   %ebp
80107206:	89 e5                	mov    %esp,%ebp
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107208:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010720d:	0f 22 d8             	mov    %eax,%cr3
}
80107210:	5d                   	pop    %ebp
80107211:	c3                   	ret    
80107212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107220 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p) {
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	53                   	push   %ebx
80107226:	83 ec 1c             	sub    $0x1c,%esp
80107229:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (p == 0)
8010722c:	85 db                	test   %ebx,%ebx
8010722e:	0f 84 cb 00 00 00    	je     801072ff <switchuvm+0xdf>
        panic("switchuvm: no process");
    if (p->kstack == 0)
80107234:	8b 43 08             	mov    0x8(%ebx),%eax
80107237:	85 c0                	test   %eax,%eax
80107239:	0f 84 da 00 00 00    	je     80107319 <switchuvm+0xf9>
        panic("switchuvm: no kstack");
    if (p->pgdir == 0)
8010723f:	8b 43 04             	mov    0x4(%ebx),%eax
80107242:	85 c0                	test   %eax,%eax
80107244:	0f 84 c2 00 00 00    	je     8010730c <switchuvm+0xec>
        panic("switchuvm: no pgdir");

    pushcli();
8010724a:	e8 b1 d8 ff ff       	call   80104b00 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010724f:	e8 0c ca ff ff       	call   80103c60 <mycpu>
80107254:	89 c6                	mov    %eax,%esi
80107256:	e8 05 ca ff ff       	call   80103c60 <mycpu>
8010725b:	89 c7                	mov    %eax,%edi
8010725d:	e8 fe c9 ff ff       	call   80103c60 <mycpu>
80107262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107265:	83 c7 08             	add    $0x8,%edi
80107268:	e8 f3 c9 ff ff       	call   80103c60 <mycpu>
8010726d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107270:	83 c0 08             	add    $0x8,%eax
80107273:	ba 67 00 00 00       	mov    $0x67,%edx
80107278:	c1 e8 18             	shr    $0x18,%eax
8010727b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107282:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107289:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
    mycpu()->gdt[SEG_TSS].s = 0;
    mycpu()->ts.ss0 = SEG_KDATA << 3;
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    mycpu()->ts.iomb = (ushort) 0xFFFF;
8010728f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107294:	83 c1 08             	add    $0x8,%ecx
80107297:	c1 e9 10             	shr    $0x10,%ecx
8010729a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801072a0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072a5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
801072ac:	be 10 00 00 00       	mov    $0x10,%esi
    mycpu()->gdt[SEG_TSS].s = 0;
801072b1:	e8 aa c9 ff ff       	call   80103c60 <mycpu>
801072b6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
801072bd:	e8 9e c9 ff ff       	call   80103c60 <mycpu>
801072c2:	66 89 70 10          	mov    %si,0x10(%eax)
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
801072c6:	8b 73 08             	mov    0x8(%ebx),%esi
801072c9:	e8 92 c9 ff ff       	call   80103c60 <mycpu>
801072ce:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072d4:	89 70 0c             	mov    %esi,0xc(%eax)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
801072d7:	e8 84 c9 ff ff       	call   80103c60 <mycpu>
801072dc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801072e0:	b8 28 00 00 00       	mov    $0x28,%eax
801072e5:	0f 00 d8             	ltr    %ax
    ltr(SEG_TSS << 3);
    lcr3(V2P(p->pgdir));  // switch to process's address space
801072e8:	8b 43 04             	mov    0x4(%ebx),%eax
801072eb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072f0:	0f 22 d8             	mov    %eax,%cr3
    popcli();
}
801072f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f6:	5b                   	pop    %ebx
801072f7:	5e                   	pop    %esi
801072f8:	5f                   	pop    %edi
801072f9:	5d                   	pop    %ebp
    popcli();
801072fa:	e9 01 d9 ff ff       	jmp    80104c00 <popcli>
        panic("switchuvm: no process");
801072ff:	83 ec 0c             	sub    $0xc,%esp
80107302:	68 9e 89 10 80       	push   $0x8010899e
80107307:	e8 84 90 ff ff       	call   80100390 <panic>
        panic("switchuvm: no pgdir");
8010730c:	83 ec 0c             	sub    $0xc,%esp
8010730f:	68 c9 89 10 80       	push   $0x801089c9
80107314:	e8 77 90 ff ff       	call   80100390 <panic>
        panic("switchuvm: no kstack");
80107319:	83 ec 0c             	sub    $0xc,%esp
8010731c:	68 b4 89 10 80       	push   $0x801089b4
80107321:	e8 6a 90 ff ff       	call   80100390 <panic>
80107326:	8d 76 00             	lea    0x0(%esi),%esi
80107329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107330 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz) {
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 1c             	sub    $0x1c,%esp
80107339:	8b 75 10             	mov    0x10(%ebp),%esi
8010733c:	8b 45 08             	mov    0x8(%ebp),%eax
8010733f:	8b 7d 0c             	mov    0xc(%ebp),%edi
    char *mem;

    if (sz >= PGSIZE)
80107342:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
inituvm(pde_t *pgdir, char *init, uint sz) {
80107348:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE)
8010734b:	77 49                	ja     80107396 <inituvm+0x66>
        panic("inituvm: more than a page");
    mem = kalloc();
8010734d:	e8 be b5 ff ff       	call   80102910 <kalloc>
    memset(mem, 0, PGSIZE);
80107352:	83 ec 04             	sub    $0x4,%esp
    mem = kalloc();
80107355:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80107357:	68 00 10 00 00       	push   $0x1000
8010735c:	6a 00                	push   $0x0
8010735e:	50                   	push   %eax
8010735f:	e8 5c d9 ff ff       	call   80104cc0 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107364:	58                   	pop    %eax
80107365:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010736b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107370:	5a                   	pop    %edx
80107371:	6a 06                	push   $0x6
80107373:	50                   	push   %eax
80107374:	31 d2                	xor    %edx,%edx
80107376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107379:	e8 22 fd ff ff       	call   801070a0 <mappages>
    memmove(mem, init, sz);
8010737e:	89 75 10             	mov    %esi,0x10(%ebp)
80107381:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107384:	83 c4 10             	add    $0x10,%esp
80107387:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010738a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010738d:	5b                   	pop    %ebx
8010738e:	5e                   	pop    %esi
8010738f:	5f                   	pop    %edi
80107390:	5d                   	pop    %ebp
    memmove(mem, init, sz);
80107391:	e9 da d9 ff ff       	jmp    80104d70 <memmove>
        panic("inituvm: more than a page");
80107396:	83 ec 0c             	sub    $0xc,%esp
80107399:	68 dd 89 10 80       	push   $0x801089dd
8010739e:	e8 ed 8f ff ff       	call   80100390 <panic>
801073a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073b0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	57                   	push   %edi
801073b4:	56                   	push   %esi
801073b5:	53                   	push   %ebx
801073b6:	83 ec 0c             	sub    $0xc,%esp
    uint i, pa, n;
    pte_t *pte;

    if ((uint) addr % PGSIZE != 0)
801073b9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801073c0:	0f 85 91 00 00 00    	jne    80107457 <loaduvm+0xa7>
        panic("loaduvm: addr must be page aligned");
    for (i = 0; i < sz; i += PGSIZE) {
801073c6:	8b 75 18             	mov    0x18(%ebp),%esi
801073c9:	31 db                	xor    %ebx,%ebx
801073cb:	85 f6                	test   %esi,%esi
801073cd:	75 1a                	jne    801073e9 <loaduvm+0x39>
801073cf:	eb 6f                	jmp    80107440 <loaduvm+0x90>
801073d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073de:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801073e4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801073e7:	76 57                	jbe    80107440 <loaduvm+0x90>
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
801073e9:	8b 55 0c             	mov    0xc(%ebp),%edx
801073ec:	8b 45 08             	mov    0x8(%ebp),%eax
801073ef:	31 c9                	xor    %ecx,%ecx
801073f1:	01 da                	add    %ebx,%edx
801073f3:	e8 28 fc ff ff       	call   80107020 <walkpgdir>
801073f8:	85 c0                	test   %eax,%eax
801073fa:	74 4e                	je     8010744a <loaduvm+0x9a>
            panic("loaduvm: address should exist");
        pa = PTE_ADDR(*pte);
801073fc:	8b 00                	mov    (%eax),%eax
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, P2V(pa), offset + i, n) != n)
801073fe:	8b 4d 14             	mov    0x14(%ebp),%ecx
        if (sz - i < PGSIZE)
80107401:	bf 00 10 00 00       	mov    $0x1000,%edi
        pa = PTE_ADDR(*pte);
80107406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE)
8010740b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107411:	0f 46 fe             	cmovbe %esi,%edi
        if (readi(ip, P2V(pa), offset + i, n) != n)
80107414:	01 d9                	add    %ebx,%ecx
80107416:	05 00 00 00 80       	add    $0x80000000,%eax
8010741b:	57                   	push   %edi
8010741c:	51                   	push   %ecx
8010741d:	50                   	push   %eax
8010741e:	ff 75 10             	pushl  0x10(%ebp)
80107421:	e8 7a a5 ff ff       	call   801019a0 <readi>
80107426:	83 c4 10             	add    $0x10,%esp
80107429:	39 f8                	cmp    %edi,%eax
8010742b:	74 ab                	je     801073d8 <loaduvm+0x28>
            return -1;
    }
    return 0;
}
8010742d:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107435:	5b                   	pop    %ebx
80107436:	5e                   	pop    %esi
80107437:	5f                   	pop    %edi
80107438:	5d                   	pop    %ebp
80107439:	c3                   	ret    
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107440:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107443:	31 c0                	xor    %eax,%eax
}
80107445:	5b                   	pop    %ebx
80107446:	5e                   	pop    %esi
80107447:	5f                   	pop    %edi
80107448:	5d                   	pop    %ebp
80107449:	c3                   	ret    
            panic("loaduvm: address should exist");
8010744a:	83 ec 0c             	sub    $0xc,%esp
8010744d:	68 f7 89 10 80       	push   $0x801089f7
80107452:	e8 39 8f ff ff       	call   80100390 <panic>
        panic("loaduvm: addr must be page aligned");
80107457:	83 ec 0c             	sub    $0xc,%esp
8010745a:	68 9c 8b 10 80       	push   $0x80108b9c
8010745f:	e8 2c 8f ff ff       	call   80100390 <panic>
80107464:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010746a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107470 <findFreeEntryInSwapFile>:

int
findFreeEntryInSwapFile(struct proc *p) {
80107470:	55                   	push   %ebp
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80107471:	31 c0                	xor    %eax,%eax
findFreeEntryInSwapFile(struct proc *p) {
80107473:	89 e5                	mov    %esp,%ebp
80107475:	8b 55 08             	mov    0x8(%ebp),%edx
80107478:	eb 0e                	jmp    80107488 <findFreeEntryInSwapFile+0x18>
8010747a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
80107480:	83 c0 01             	add    $0x1,%eax
80107483:	83 f8 10             	cmp    $0x10,%eax
80107486:	74 10                	je     80107498 <findFreeEntryInSwapFile+0x28>
        if (!p->swapFileEntries[i])
80107488:	8b 8c 82 00 04 00 00 	mov    0x400(%edx,%eax,4),%ecx
8010748f:	85 c9                	test   %ecx,%ecx
80107491:	75 ed                	jne    80107480 <findFreeEntryInSwapFile+0x10>
            return i;
    }
    return -1;
}
80107493:	5d                   	pop    %ebp
80107494:	c3                   	ret    
80107495:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010749d:	5d                   	pop    %ebp
8010749e:	c3                   	ret    
8010749f:	90                   	nop

801074a0 <swapOutPage>:

//TODO - make sure that before calling to this func to check:
//TODO - #if( defined(LIFO) || defined(SCFIFO))
void
swapOutPage(struct proc *p, pde_t *pgdir) {
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	57                   	push   %edi
801074a4:	56                   	push   %esi
801074a5:	53                   	push   %ebx
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
801074a6:	31 db                	xor    %ebx,%ebx
swapOutPage(struct proc *p, pde_t *pgdir) {
801074a8:	83 ec 1c             	sub    $0x1c,%esp
801074ab:	8b 75 08             	mov    0x8(%ebp),%esi
801074ae:	eb 0c                	jmp    801074bc <swapOutPage+0x1c>
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
801074b0:	83 c3 01             	add    $0x1,%ebx
801074b3:	83 fb 10             	cmp    $0x10,%ebx
801074b6:	0f 84 14 01 00 00    	je     801075d0 <swapOutPage+0x130>
        if (!p->swapFileEntries[i])
801074bc:	8b bc 9e 00 04 00 00 	mov    0x400(%esi,%ebx,4),%edi
801074c3:	85 ff                	test   %edi,%edi
801074c5:	75 e9                	jne    801074b0 <swapOutPage+0x10>
        }
        panic("ERROR - there is no free entry in p->swapFileEntries!\n");

    }

    int swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
801074c7:	89 d8                	mov    %ebx,%eax
    char *tmpAdress;
    pde_t *tmppgtble;
    struct page *sg;
    while (!found) {
        //find page with min pagesequel
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
801074c9:	8d 96 00 04 00 00    	lea    0x400(%esi),%edx
    struct page *pg = 0;
801074cf:	31 ff                	xor    %edi,%edi
    int swapWriteOffset = tmpOffset * PGSIZE; //calculate offset
801074d1:	c1 e0 0c             	shl    $0xc,%eax
801074d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    int minSeq = p->pagesequel, found = 0;
801074d7:	8b 86 4c 04 00 00    	mov    0x44c(%esi),%eax
801074dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
801074e0:	8d 86 80 00 00 00    	lea    0x80(%esi),%eax
801074e6:	8d 76 00             	lea    0x0(%esi),%esi
801074e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (sg->active && sg->present && sg->sequel < minSeq) {
801074f0:	8b 08                	mov    (%eax),%ecx
801074f2:	85 c9                	test   %ecx,%ecx
801074f4:	74 1a                	je     80107510 <swapOutPage+0x70>
801074f6:	8b 48 0c             	mov    0xc(%eax),%ecx
801074f9:	85 c9                	test   %ecx,%ecx
801074fb:	74 13                	je     80107510 <swapOutPage+0x70>
801074fd:	8b 48 08             	mov    0x8(%eax),%ecx
80107500:	3b 4d e4             	cmp    -0x1c(%ebp),%ecx
80107503:	7d 0b                	jge    80107510 <swapOutPage+0x70>
80107505:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107508:	89 c7                	mov    %eax,%edi
8010750a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
80107510:	83 c0 1c             	add    $0x1c,%eax
80107513:	39 c2                	cmp    %eax,%edx
80107515:	77 d9                	ja     801074f0 <swapOutPage+0x50>
                minSeq = sg->sequel;
            }
        }
        //got here- pg have the min pagesequel
        tmpAdress = pg->virtAdress;
        tmppgtble = walkpgdir(pgdir, tmpAdress, 0);
80107517:	8b 57 18             	mov    0x18(%edi),%edx
8010751a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010751d:	31 c9                	xor    %ecx,%ecx
8010751f:	e8 fc fa ff ff       	call   80107020 <walkpgdir>
        if (*tmppgtble & PTE_A) { //if legal addr and acces bit is on - move to end of page queue
80107524:	8b 10                	mov    (%eax),%edx
80107526:	f6 c2 20             	test   $0x20,%dl
80107529:	0f 84 e3 00 00 00    	je     80107612 <swapOutPage+0x172>
            *tmppgtble = PTE_A_0(*tmppgtble);
8010752f:	83 e2 df             	and    $0xffffffdf,%edx
80107532:	89 10                	mov    %edx,(%eax)
            pg->sequel = p->pagesequel++;
80107534:	8b 86 4c 04 00 00    	mov    0x44c(%esi),%eax
8010753a:	8d 50 01             	lea    0x1(%eax),%edx
8010753d:	89 96 4c 04 00 00    	mov    %edx,0x44c(%esi)
80107543:	89 47 08             	mov    %eax,0x8(%edi)
#endif

    //got here - pg is the page to swap out (in both cases)

    //write the page to swapFile
    writeToSwapFile(p, pg->physAdress, (uint) swapWriteOffset, PGSIZE);
80107546:	68 00 10 00 00       	push   $0x1000
8010754b:	ff 75 e0             	pushl  -0x20(%ebp)
8010754e:	ff 77 14             	pushl  0x14(%edi)
80107551:	56                   	push   %esi
80107552:	e8 39 ad ff ff       	call   80102290 <writeToSwapFile>
    //update page
    pg->present = 0;
    pg->offset = (uint) swapWriteOffset;
80107557:	8b 45 e0             	mov    -0x20(%ebp),%eax
    pg->present = 0;
8010755a:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    p->swapFileEntries[tmpOffset] = 1; //update that this entry is swapped out
    p->totalPagesInSwap++;
    p->pagesinSwap++;

    //update pte
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
80107561:	31 c9                	xor    %ecx,%ecx
    pg->physAdress = 0;
80107563:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    pg->sequel = 0;
8010756a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    pg->offset = (uint) swapWriteOffset;
80107571:	89 47 10             	mov    %eax,0x10(%edi)
    p->swapFileEntries[tmpOffset] = 1; //update that this entry is swapped out
80107574:	c7 84 9e 00 04 00 00 	movl   $0x1,0x400(%esi,%ebx,4)
8010757b:	01 00 00 00 
    p->totalPagesInSwap++;
8010757f:	83 86 58 04 00 00 01 	addl   $0x1,0x458(%esi)
    p->pagesinSwap++;
80107586:	83 86 48 04 00 00 01 	addl   $0x1,0x448(%esi)
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
8010758d:	8b 57 18             	mov    0x18(%edi),%edx
80107590:	8b 45 0c             	mov    0xc(%ebp),%eax
80107593:	e8 88 fa ff ff       	call   80107020 <walkpgdir>
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
801075df:	68 1a 8a 10 80       	push   $0x80108a1a
801075e4:	e8 77 90 ff ff       	call   80100660 <cprintf>
801075e9:	83 c4 10             	add    $0x10,%esp
            cprintf("%d  ", p->swapFileEntries[i]);
801075ec:	83 ec 08             	sub    $0x8,%esp
801075ef:	ff 33                	pushl  (%ebx)
801075f1:	83 c3 04             	add    $0x4,%ebx
801075f4:	68 15 8a 10 80       	push   $0x80108a15
801075f9:	e8 62 90 ff ff       	call   80100660 <cprintf>
        for (int i = 0; i < MAX_PSYC_PAGES; i++) {
801075fe:	83 c4 10             	add    $0x10,%esp
80107601:	39 f3                	cmp    %esi,%ebx
80107603:	75 e7                	jne    801075ec <swapOutPage+0x14c>
        panic("ERROR - there is no free entry in p->swapFileEntries!\n");
80107605:	83 ec 0c             	sub    $0xc,%esp
80107608:	68 c0 8b 10 80       	push   $0x80108bc0
8010760d:	e8 7e 8d ff ff       	call   80100390 <panic>
                panic("Error - tmppgtble = walkpgdir(pgdir, tmpAdress, 0);\n");
80107612:	83 ec 0c             	sub    $0xc,%esp
80107615:	68 f8 8b 10 80       	push   $0x80108bf8
8010761a:	e8 71 8d ff ff       	call   80100390 <panic>
8010761f:	90                   	nop

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
80107626:	83 ec 28             	sub    $0x28,%esp
80107629:	8b 75 0c             	mov    0xc(%ebp),%esi
        if (DEBUGMODE == 2)
            cprintf("DEALLOCUVM-");
8010762c:	68 27 8a 10 80       	push   $0x80108a27
80107631:	e8 2a 90 ff ff       	call   80100660 <cprintf>
        pte_t *pte;
        uint a, pa;
#if(defined(LIFO) || defined(SCFIFO))
        struct page *pg;
        struct proc *p = myproc();
80107636:	e8 c5 c6 ff ff       	call   80103d00 <myproc>
#endif
        if (newsz >= oldsz) {
8010763b:	83 c4 10             	add    $0x10,%esp
8010763e:	39 75 10             	cmp    %esi,0x10(%ebp)
80107641:	0f 83 b9 01 00 00    	jae    80107800 <deallocuvm+0x1e0>
80107647:	89 c7                	mov    %eax,%edi
            if (DEBUGMODE == 2 && notShell())
                cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
            return oldsz;
        }

        a = PGROUNDUP(newsz);
80107649:	8b 45 10             	mov    0x10(%ebp),%eax
8010764c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107652:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
        for (; a < oldsz; a += PGSIZE) {
80107658:	39 de                	cmp    %ebx,%esi
8010765a:	0f 86 e8 00 00 00    	jbe    80107748 <deallocuvm+0x128>
                    pa = PTE_ADDR(*pte);
                    if (pa == 0)
                        panic("kfree");
                    if (p->pid > 2 && growproc) {
                        //scan pages table and remove page that page.virtAdress == a
                        for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107660:	8d 87 00 04 00 00    	lea    0x400(%edi),%eax
80107666:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107669:	eb 4e                	jmp    801076b9 <deallocuvm+0x99>
8010766b:	90                   	nop
8010766c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                if (pa == 0)
80107670:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107676:	0f 84 ab 01 00 00    	je     80107827 <deallocuvm+0x207>
                if (p->pid > 2 && growproc) {
8010767c:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107680:	7e 0b                	jle    8010768d <deallocuvm+0x6d>
80107682:	8b 4d 14             	mov    0x14(%ebp),%ecx
80107685:	85 c9                	test   %ecx,%ecx
80107687:	0f 85 eb 00 00 00    	jne    80107778 <deallocuvm+0x158>
                kfree(v);
8010768d:	83 ec 0c             	sub    $0xc,%esp
                char *v = P2V(pa);
80107690:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                kfree(v);
80107699:	52                   	push   %edx
8010769a:	e8 c1 b0 ff ff       	call   80102760 <kfree>
                *pte = 0;
8010769f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076a2:	83 c4 10             	add    $0x10,%esp
801076a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        for (; a < oldsz; a += PGSIZE) {
801076ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076b1:	39 de                	cmp    %ebx,%esi
801076b3:	0f 86 8f 00 00 00    	jbe    80107748 <deallocuvm+0x128>
            pte = walkpgdir(pgdir, (char *) a, 0);
801076b9:	8b 45 08             	mov    0x8(%ebp),%eax
801076bc:	31 c9                	xor    %ecx,%ecx
801076be:	89 da                	mov    %ebx,%edx
801076c0:	e8 5b f9 ff ff       	call   80107020 <walkpgdir>
            if (!pte)
801076c5:	85 c0                	test   %eax,%eax
801076c7:	0f 84 93 00 00 00    	je     80107760 <deallocuvm+0x140>
            else if ((*pte & PTE_P) != 0) {
801076cd:	8b 10                	mov    (%eax),%edx
801076cf:	f6 c2 01             	test   $0x1,%dl
801076d2:	75 9c                	jne    80107670 <deallocuvm+0x50>
                if ((*pte & PTE_PG) != 0) {
801076d4:	f6 c6 02             	test   $0x2,%dh
801076d7:	74 d2                	je     801076ab <deallocuvm+0x8b>
                    if (pa == 0)
801076d9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801076df:	0f 84 42 01 00 00    	je     80107827 <deallocuvm+0x207>
                    if (p->pid > 2 && growproc) {
801076e5:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
801076e9:	7e c0                	jle    801076ab <deallocuvm+0x8b>
801076eb:	8b 45 14             	mov    0x14(%ebp),%eax
801076ee:	85 c0                	test   %eax,%eax
801076f0:	74 b9                	je     801076ab <deallocuvm+0x8b>
                        for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
801076f2:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
801076f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801076fb:	eb 0a                	jmp    80107707 <deallocuvm+0xe7>
801076fd:	8d 76 00             	lea    0x0(%esi),%esi
80107700:	83 c0 1c             	add    $0x1c,%eax
80107703:	39 d0                	cmp    %edx,%eax
80107705:	73 a4                	jae    801076ab <deallocuvm+0x8b>
                            if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
80107707:	8b 08                	mov    (%eax),%ecx
80107709:	85 c9                	test   %ecx,%ecx
8010770b:	74 f3                	je     80107700 <deallocuvm+0xe0>
8010770d:	3b 58 18             	cmp    0x18(%eax),%ebx
80107710:	75 ee                	jne    80107700 <deallocuvm+0xe0>
        for (; a < oldsz; a += PGSIZE) {
80107712:	81 c3 00 10 00 00    	add    $0x1000,%ebx
                            {
                                //remove page
                                pg->virtAdress = 0;
80107718:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
                                pg->active = 0;
8010771f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                                pg->offset = 0;      //TODO - check if there is a need to save offset
80107725:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                                pg->present = 0;
8010772c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

                                //update proc
                                p->pagesCounter--;
80107733:	83 af 44 04 00 00 01 	subl   $0x1,0x444(%edi)
        for (; a < oldsz; a += PGSIZE) {
8010773a:	39 de                	cmp    %ebx,%esi
8010773c:	0f 87 77 ff ff ff    	ja     801076b9 <deallocuvm+0x99>
80107742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    }
                }
#endif
            }
        }
        if (DEBUGMODE == 2 && notShell())
80107748:	e8 d3 c4 ff ff       	call   80103c20 <notShell>
8010774d:	85 c0                	test   %eax,%eax
8010774f:	75 67                	jne    801077b8 <deallocuvm+0x198>
            cprintf(">DEALLOCUVM-DONE!\t");
        return newsz;
80107751:	8b 45 10             	mov    0x10(%ebp),%eax
    }
80107754:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107757:	5b                   	pop    %ebx
80107758:	5e                   	pop    %esi
80107759:	5f                   	pop    %edi
8010775a:	5d                   	pop    %ebp
8010775b:	c3                   	ret    
8010775c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107760:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107766:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
8010776c:	e9 3a ff ff ff       	jmp    801076ab <deallocuvm+0x8b>
80107771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107778:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010777b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010777e:	8d 8f 80 00 00 00    	lea    0x80(%edi),%ecx
80107784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                        if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
80107788:	83 39 00             	cmpl   $0x0,(%ecx)
8010778b:	74 05                	je     80107792 <deallocuvm+0x172>
8010778d:	3b 59 18             	cmp    0x18(%ecx),%ebx
80107790:	74 3e                	je     801077d0 <deallocuvm+0x1b0>
                    for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107792:	83 c1 1c             	add    $0x1c,%ecx
80107795:	39 c1                	cmp    %eax,%ecx
80107797:	72 ef                	jb     80107788 <deallocuvm+0x168>
80107799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
                    if (pg == &p->pages[MAX_TOTAL_PAGES])//if true ->didn't find the virtAdress
8010779c:	39 4d e0             	cmp    %ecx,-0x20(%ebp)
8010779f:	0f 85 e8 fe ff ff    	jne    8010768d <deallocuvm+0x6d>
                        panic("deallocuvm Error - didn't find the virtAdress!");
801077a5:	83 ec 0c             	sub    $0xc,%esp
801077a8:	68 54 8c 10 80       	push   $0x80108c54
801077ad:	e8 de 8b ff ff       	call   80100390 <panic>
801077b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            cprintf(">DEALLOCUVM-DONE!\t");
801077b8:	83 ec 0c             	sub    $0xc,%esp
801077bb:	68 33 8a 10 80       	push   $0x80108a33
801077c0:	e8 9b 8e ff ff       	call   80100660 <cprintf>
801077c5:	83 c4 10             	add    $0x10,%esp
801077c8:	eb 87                	jmp    80107751 <deallocuvm+0x131>
801077ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                            pg->virtAdress = 0;
801077d0:	c7 41 18 00 00 00 00 	movl   $0x0,0x18(%ecx)
                            pg->active = 0;
801077d7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
                            pg->offset = 0;      //TODO - check if there is a need to save offset
801077dd:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
                            pg->present = 0;
801077e4:	c7 41 0c 00 00 00 00 	movl   $0x0,0xc(%ecx)
801077eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
                            p->pagesCounter--;
801077ee:	83 af 44 04 00 00 01 	subl   $0x1,0x444(%edi)
                            break;
801077f5:	eb a5                	jmp    8010779c <deallocuvm+0x17c>
801077f7:	89 f6                	mov    %esi,%esi
801077f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (DEBUGMODE == 2 && notShell())
80107800:	e8 1b c4 ff ff       	call   80103c20 <notShell>
80107805:	85 c0                	test   %eax,%eax
80107807:	75 0a                	jne    80107813 <deallocuvm+0x1f3>
            return oldsz;
80107809:	89 f0                	mov    %esi,%eax
    }
8010780b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010780e:	5b                   	pop    %ebx
8010780f:	5e                   	pop    %esi
80107810:	5f                   	pop    %edi
80107811:	5d                   	pop    %ebp
80107812:	c3                   	ret    
                cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
80107813:	83 ec 0c             	sub    $0xc,%esp
80107816:	68 30 8c 10 80       	push   $0x80108c30
8010781b:	e8 40 8e ff ff       	call   80100660 <cprintf>
80107820:	83 c4 10             	add    $0x10,%esp
            return oldsz;
80107823:	89 f0                	mov    %esi,%eax
80107825:	eb e4                	jmp    8010780b <deallocuvm+0x1eb>
                    panic("kfree");
80107827:	83 ec 0c             	sub    $0xc,%esp
8010782a:	68 0a 82 10 80       	push   $0x8010820a
8010782f:	e8 5c 8b ff ff       	call   80100390 <panic>
80107834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010783a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107840 <allocuvm>:
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	57                   	push   %edi
80107844:	56                   	push   %esi
80107845:	53                   	push   %ebx
80107846:	83 ec 28             	sub    $0x28,%esp
        cprintf("ALLOCUVM-");
80107849:	68 29 8a 10 80       	push   $0x80108a29
8010784e:	e8 0d 8e ff ff       	call   80100660 <cprintf>
    cprintf("FUCKYOU1");
80107853:	c7 04 24 46 8a 10 80 	movl   $0x80108a46,(%esp)
8010785a:	e8 01 8e ff ff       	call   80100660 <cprintf>
    struct proc *p = myproc();
8010785f:	e8 9c c4 ff ff       	call   80103d00 <myproc>
80107864:	89 c3                	mov    %eax,%ebx
    if (newsz >= KERNBASE) {
80107866:	8b 45 10             	mov    0x10(%ebp),%eax
80107869:	83 c4 10             	add    $0x10,%esp
8010786c:	85 c0                	test   %eax,%eax
8010786e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107871:	0f 88 03 02 00 00    	js     80107a7a <allocuvm+0x23a>
    if (newsz < oldsz) {
80107877:	8b 45 0c             	mov    0xc(%ebp),%eax
8010787a:	39 45 10             	cmp    %eax,0x10(%ebp)
8010787d:	0f 82 dd 01 00 00    	jb     80107a60 <allocuvm+0x220>
    a = PGROUNDUP(oldsz);
80107883:	8b 45 0c             	mov    0xc(%ebp),%eax
80107886:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010788c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    for (; a < newsz; a += PGSIZE) {
80107892:	39 75 10             	cmp    %esi,0x10(%ebp)
80107895:	0f 86 3b 01 00 00    	jbe    801079d6 <allocuvm+0x196>
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
8010789b:	8d 83 00 04 00 00    	lea    0x400(%ebx),%eax
801078a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801078a4:	eb 19                	jmp    801078bf <allocuvm+0x7f>
801078a6:	8d 76 00             	lea    0x0(%esi),%esi
801078a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for (; a < newsz; a += PGSIZE) {
801078b0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078b6:	39 75 10             	cmp    %esi,0x10(%ebp)
801078b9:	0f 86 17 01 00 00    	jbe    801079d6 <allocuvm+0x196>
        if(notShell()) {
801078bf:	e8 5c c3 ff ff       	call   80103c20 <notShell>
801078c4:	85 c0                	test   %eax,%eax
801078c6:	74 24                	je     801078ec <allocuvm+0xac>
            if (p->pagesCounter == MAX_TOTAL_PAGES)
801078c8:	8b 83 44 04 00 00    	mov    0x444(%ebx),%eax
801078ce:	83 f8 20             	cmp    $0x20,%eax
801078d1:	0f 84 3d 02 00 00    	je     80107b14 <allocuvm+0x2d4>
            if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2) {
801078d7:	2b 83 48 04 00 00    	sub    0x448(%ebx),%eax
801078dd:	83 f8 0f             	cmp    $0xf,%eax
801078e0:	7e 0a                	jle    801078ec <allocuvm+0xac>
801078e2:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801078e6:	0f 8f 0c 01 00 00    	jg     801079f8 <allocuvm+0x1b8>
        mem = kalloc();
801078ec:	e8 1f b0 ff ff       	call   80102910 <kalloc>
        if (mem == 0) {
801078f1:	85 c0                	test   %eax,%eax
        mem = kalloc();
801078f3:	89 c7                	mov    %eax,%edi
        if (mem == 0) {
801078f5:	0f 84 1b 01 00 00    	je     80107a16 <allocuvm+0x1d6>
        memset(mem, 0, PGSIZE);
801078fb:	83 ec 04             	sub    $0x4,%esp
801078fe:	68 00 10 00 00       	push   $0x1000
80107903:	6a 00                	push   $0x0
80107905:	50                   	push   %eax
80107906:	e8 b5 d3 ff ff       	call   80104cc0 <memset>
        if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
8010790b:	59                   	pop    %ecx
8010790c:	58                   	pop    %eax
8010790d:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107913:	6a 06                	push   $0x6
80107915:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010791a:	89 f2                	mov    %esi,%edx
8010791c:	50                   	push   %eax
8010791d:	8b 45 08             	mov    0x8(%ebp),%eax
80107920:	e8 7b f7 ff ff       	call   801070a0 <mappages>
80107925:	83 c4 10             	add    $0x10,%esp
80107928:	85 c0                	test   %eax,%eax
8010792a:	0f 88 89 01 00 00    	js     80107ab9 <allocuvm+0x279>
        if (notShell()) {
80107930:	e8 eb c2 ff ff       	call   80103c20 <notShell>
80107935:	85 c0                	test   %eax,%eax
80107937:	0f 84 73 ff ff ff    	je     801078b0 <allocuvm+0x70>
                if (!pg->active)
8010793d:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107943:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
                if (!pg->active)
80107949:	85 d2                	test   %edx,%edx
8010794b:	74 14                	je     80107961 <allocuvm+0x121>
8010794d:	8b 55 e0             	mov    -0x20(%ebp),%edx
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
80107950:	83 c0 1c             	add    $0x1c,%eax
80107953:	39 d0                	cmp    %edx,%eax
80107955:	0f 83 ac 01 00 00    	jae    80107b07 <allocuvm+0x2c7>
                if (!pg->active)
8010795b:	8b 08                	mov    (%eax),%ecx
8010795d:	85 c9                	test   %ecx,%ecx
8010795f:	75 ef                	jne    80107950 <allocuvm+0x110>
            p->pagesCounter++;
80107961:	83 83 44 04 00 00 01 	addl   $0x1,0x444(%ebx)
            pg->active = 1;
80107968:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
            pg->pageid = p->nextpageid++;
8010796e:	8b 93 40 04 00 00    	mov    0x440(%ebx),%edx
80107974:	8d 4a 01             	lea    0x1(%edx),%ecx
80107977:	89 8b 40 04 00 00    	mov    %ecx,0x440(%ebx)
8010797d:	89 50 04             	mov    %edx,0x4(%eax)
            pg->present = 1;
80107980:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
            pg->offset = 0;
80107987:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
            pg->sequel = p->pagesequel++;
8010798e:	8b 93 4c 04 00 00    	mov    0x44c(%ebx),%edx
80107994:	8d 4a 01             	lea    0x1(%edx),%ecx
80107997:	89 8b 4c 04 00 00    	mov    %ecx,0x44c(%ebx)
8010799d:	89 50 08             	mov    %edx,0x8(%eax)
            pgtble = walkpgdir(pgdir, (char *) a, 0);
801079a0:	31 c9                	xor    %ecx,%ecx
            pg->physAdress = mem;
801079a2:	89 78 14             	mov    %edi,0x14(%eax)
            pg->virtAdress = (char *) a;
801079a5:	89 70 18             	mov    %esi,0x18(%eax)
            pgtble = walkpgdir(pgdir, (char *) a, 0);
801079a8:	89 f2                	mov    %esi,%edx
801079aa:	8b 45 08             	mov    0x8(%ebp),%eax
801079ad:	e8 6e f6 ff ff       	call   80107020 <walkpgdir>
            *pgtble = PTE_PG_0(*pgtble); // Not Paged out to secondary storage
801079b2:	8b 10                	mov    (%eax),%edx
801079b4:	80 e6 fd             	and    $0xfd,%dh
801079b7:	83 ca 01             	or     $0x1,%edx
801079ba:	89 10                	mov    %edx,(%eax)
            lcr3(V2P(p->pgdir));
801079bc:	8b 43 04             	mov    0x4(%ebx),%eax
801079bf:	05 00 00 00 80       	add    $0x80000000,%eax
801079c4:	0f 22 d8             	mov    %eax,%cr3
    for (; a < newsz; a += PGSIZE) {
801079c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801079cd:	39 75 10             	cmp    %esi,0x10(%ebp)
801079d0:	0f 87 e9 fe ff ff    	ja     801078bf <allocuvm+0x7f>
        if (DEBUGMODE == 2 && notShell())
801079d6:	e8 45 c2 ff ff       	call   80103c20 <notShell>
801079db:	85 c0                	test   %eax,%eax
801079dd:	0f 84 8c 00 00 00    	je     80107a6f <allocuvm+0x22f>
            cprintf(">ALLOCUVM-DONE!\t");
801079e3:	83 ec 0c             	sub    $0xc,%esp
801079e6:	68 dc 8a 10 80       	push   $0x80108adc
801079eb:	e8 70 8c ff ff       	call   80100660 <cprintf>
801079f0:	83 c4 10             	add    $0x10,%esp
801079f3:	eb 7a                	jmp    80107a6f <allocuvm+0x22f>
801079f5:	8d 76 00             	lea    0x0(%esi),%esi
                swapOutPage(p, pgdir); //this func includes remove page, update proc and update PTE
801079f8:	83 ec 08             	sub    $0x8,%esp
801079fb:	ff 75 08             	pushl  0x8(%ebp)
801079fe:	53                   	push   %ebx
801079ff:	e8 9c fa ff ff       	call   801074a0 <swapOutPage>
80107a04:	83 c4 10             	add    $0x10,%esp
        mem = kalloc();
80107a07:	e8 04 af ff ff       	call   80102910 <kalloc>
        if (mem == 0) {
80107a0c:	85 c0                	test   %eax,%eax
        mem = kalloc();
80107a0e:	89 c7                	mov    %eax,%edi
        if (mem == 0) {
80107a10:	0f 85 e5 fe ff ff    	jne    801078fb <allocuvm+0xbb>
            cprintf("allocuvm out of memory\n");
80107a16:	83 ec 0c             	sub    $0xc,%esp
80107a19:	68 60 8a 10 80       	push   $0x80108a60
80107a1e:	e8 3d 8c ff ff       	call   80100660 <cprintf>
            deallocuvm(pgdir, newsz, oldsz, 0);
80107a23:	6a 00                	push   $0x0
80107a25:	ff 75 0c             	pushl  0xc(%ebp)
80107a28:	ff 75 10             	pushl  0x10(%ebp)
80107a2b:	ff 75 08             	pushl  0x8(%ebp)
80107a2e:	e8 ed fb ff ff       	call   80107620 <deallocuvm>
            if (DEBUGMODE == 2 && notShell())
80107a33:	83 c4 20             	add    $0x20,%esp
80107a36:	e8 e5 c1 ff ff       	call   80103c20 <notShell>
80107a3b:	85 c0                	test   %eax,%eax
80107a3d:	74 44                	je     80107a83 <allocuvm+0x243>
                cprintf(">ALLOCUVM-FAILED-mem == 0\t");
80107a3f:	83 ec 0c             	sub    $0xc,%esp
80107a42:	68 78 8a 10 80       	push   $0x80108a78
80107a47:	e8 14 8c ff ff       	call   80100660 <cprintf>
80107a4c:	83 c4 10             	add    $0x10,%esp
            return 0;
80107a4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107a56:	eb 17                	jmp    80107a6f <allocuvm+0x22f>
80107a58:	90                   	nop
80107a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (DEBUGMODE == 2 && notShell())
80107a60:	e8 bb c1 ff ff       	call   80103c20 <notShell>
80107a65:	85 c0                	test   %eax,%eax
80107a67:	75 2c                	jne    80107a95 <allocuvm+0x255>
        return oldsz;
80107a69:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a75:	5b                   	pop    %ebx
80107a76:	5e                   	pop    %esi
80107a77:	5f                   	pop    %edi
80107a78:	5d                   	pop    %ebp
80107a79:	c3                   	ret    
        if (DEBUGMODE == 2 && notShell())
80107a7a:	e8 a1 c1 ff ff       	call   80103c20 <notShell>
80107a7f:	85 c0                	test   %eax,%eax
80107a81:	75 24                	jne    80107aa7 <allocuvm+0x267>
        return 0;
80107a83:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107a8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a90:	5b                   	pop    %ebx
80107a91:	5e                   	pop    %esi
80107a92:	5f                   	pop    %edi
80107a93:	5d                   	pop    %ebp
80107a94:	c3                   	ret    
            cprintf(">ALLOCUVM-FAILED");
80107a95:	83 ec 0c             	sub    $0xc,%esp
80107a98:	68 4f 8a 10 80       	push   $0x80108a4f
80107a9d:	e8 be 8b ff ff       	call   80100660 <cprintf>
80107aa2:	83 c4 10             	add    $0x10,%esp
80107aa5:	eb c2                	jmp    80107a69 <allocuvm+0x229>
            cprintf(">ALLOCUVM-FAILED");
80107aa7:	83 ec 0c             	sub    $0xc,%esp
80107aaa:	68 4f 8a 10 80       	push   $0x80108a4f
80107aaf:	e8 ac 8b ff ff       	call   80100660 <cprintf>
80107ab4:	83 c4 10             	add    $0x10,%esp
80107ab7:	eb ca                	jmp    80107a83 <allocuvm+0x243>
            cprintf("allocuvm out of memory (2)\n");
80107ab9:	83 ec 0c             	sub    $0xc,%esp
80107abc:	68 93 8a 10 80       	push   $0x80108a93
80107ac1:	e8 9a 8b ff ff       	call   80100660 <cprintf>
            deallocuvm(pgdir, newsz, oldsz, 0);
80107ac6:	6a 00                	push   $0x0
80107ac8:	ff 75 0c             	pushl  0xc(%ebp)
80107acb:	ff 75 10             	pushl  0x10(%ebp)
80107ace:	ff 75 08             	pushl  0x8(%ebp)
80107ad1:	e8 4a fb ff ff       	call   80107620 <deallocuvm>
            kfree(mem);
80107ad6:	83 c4 14             	add    $0x14,%esp
80107ad9:	57                   	push   %edi
80107ada:	e8 81 ac ff ff       	call   80102760 <kfree>
            if (DEBUGMODE == 2 && notShell())
80107adf:	e8 3c c1 ff ff       	call   80103c20 <notShell>
80107ae4:	83 c4 10             	add    $0x10,%esp
80107ae7:	85 c0                	test   %eax,%eax
80107ae9:	74 98                	je     80107a83 <allocuvm+0x243>
                cprintf(">ALLOCUVM-FAILED-mappages<0\t");
80107aeb:	83 ec 0c             	sub    $0xc,%esp
80107aee:	68 af 8a 10 80       	push   $0x80108aaf
80107af3:	e8 68 8b ff ff       	call   80100660 <cprintf>
80107af8:	83 c4 10             	add    $0x10,%esp
            return 0;
80107afb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107b02:	e9 68 ff ff ff       	jmp    80107a6f <allocuvm+0x22f>
            panic("no page in proc");
80107b07:	83 ec 0c             	sub    $0xc,%esp
80107b0a:	68 cc 8a 10 80       	push   $0x80108acc
80107b0f:	e8 7c 88 ff ff       	call   80100390 <panic>
                panic("got 32 pages and requested for another page!");
80107b14:	83 ec 0c             	sub    $0xc,%esp
80107b17:	68 84 8c 10 80       	push   $0x80108c84
80107b1c:	e8 6f 88 ff ff       	call   80100390 <panic>
80107b21:	eb 0d                	jmp    80107b30 <freevm>
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

80107b30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir) {
80107b30:	55                   	push   %ebp
80107b31:	89 e5                	mov    %esp,%ebp
80107b33:	57                   	push   %edi
80107b34:	56                   	push   %esi
80107b35:	53                   	push   %ebx
80107b36:	83 ec 0c             	sub    $0xc,%esp
80107b39:	8b 75 08             	mov    0x8(%ebp),%esi
        if (DEBUGMODE == 2 && notShell())
80107b3c:	e8 df c0 ff ff       	call   80103c20 <notShell>
80107b41:	85 c0                	test   %eax,%eax
80107b43:	0f 85 81 00 00 00    	jne    80107bca <freevm+0x9a>
            cprintf("FREEVM");
        uint i;

        if (pgdir == 0)
80107b49:	85 f6                	test   %esi,%esi
80107b4b:	0f 84 8e 00 00 00    	je     80107bdf <freevm+0xaf>
            panic("freevm: no pgdir");
        deallocuvm(pgdir, KERNBASE, 0, 0);
80107b51:	6a 00                	push   $0x0
80107b53:	6a 00                	push   $0x0
80107b55:	89 f3                	mov    %esi,%ebx
80107b57:	68 00 00 00 80       	push   $0x80000000
80107b5c:	56                   	push   %esi
80107b5d:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107b63:	e8 b8 fa ff ff       	call   80107620 <deallocuvm>
80107b68:	83 c4 10             	add    $0x10,%esp
80107b6b:	eb 0a                	jmp    80107b77 <freevm+0x47>
80107b6d:	8d 76 00             	lea    0x0(%esi),%esi
80107b70:	83 c3 04             	add    $0x4,%ebx
        for (i = 0; i < NPDENTRIES; i++) {
80107b73:	39 fb                	cmp    %edi,%ebx
80107b75:	74 23                	je     80107b9a <freevm+0x6a>
            if (pgdir[i] & PTE_P) {
80107b77:	8b 03                	mov    (%ebx),%eax
80107b79:	a8 01                	test   $0x1,%al
80107b7b:	74 f3                	je     80107b70 <freevm+0x40>
                char *v = P2V(PTE_ADDR(pgdir[i]));
80107b7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
                kfree(v);
80107b82:	83 ec 0c             	sub    $0xc,%esp
80107b85:	83 c3 04             	add    $0x4,%ebx
                char *v = P2V(PTE_ADDR(pgdir[i]));
80107b88:	05 00 00 00 80       	add    $0x80000000,%eax
                kfree(v);
80107b8d:	50                   	push   %eax
80107b8e:	e8 cd ab ff ff       	call   80102760 <kfree>
80107b93:	83 c4 10             	add    $0x10,%esp
        for (i = 0; i < NPDENTRIES; i++) {
80107b96:	39 fb                	cmp    %edi,%ebx
80107b98:	75 dd                	jne    80107b77 <freevm+0x47>
            }
        }
        kfree((char *) pgdir);
80107b9a:	83 ec 0c             	sub    $0xc,%esp
80107b9d:	56                   	push   %esi
80107b9e:	e8 bd ab ff ff       	call   80102760 <kfree>
        if (DEBUGMODE == 2 && notShell())
80107ba3:	e8 78 c0 ff ff       	call   80103c20 <notShell>
80107ba8:	83 c4 10             	add    $0x10,%esp
80107bab:	85 c0                	test   %eax,%eax
80107bad:	75 08                	jne    80107bb7 <freevm+0x87>
            cprintf(">FREEVM-DONE!\t");
    }
80107baf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bb2:	5b                   	pop    %ebx
80107bb3:	5e                   	pop    %esi
80107bb4:	5f                   	pop    %edi
80107bb5:	5d                   	pop    %ebp
80107bb6:	c3                   	ret    
            cprintf(">FREEVM-DONE!\t");
80107bb7:	c7 45 08 05 8b 10 80 	movl   $0x80108b05,0x8(%ebp)
    }
80107bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bc1:	5b                   	pop    %ebx
80107bc2:	5e                   	pop    %esi
80107bc3:	5f                   	pop    %edi
80107bc4:	5d                   	pop    %ebp
            cprintf(">FREEVM-DONE!\t");
80107bc5:	e9 96 8a ff ff       	jmp    80100660 <cprintf>
            cprintf("FREEVM");
80107bca:	83 ec 0c             	sub    $0xc,%esp
80107bcd:	68 ed 8a 10 80       	push   $0x80108aed
80107bd2:	e8 89 8a ff ff       	call   80100660 <cprintf>
80107bd7:	83 c4 10             	add    $0x10,%esp
80107bda:	e9 6a ff ff ff       	jmp    80107b49 <freevm+0x19>
            panic("freevm: no pgdir");
80107bdf:	83 ec 0c             	sub    $0xc,%esp
80107be2:	68 f4 8a 10 80       	push   $0x80108af4
80107be7:	e8 a4 87 ff ff       	call   80100390 <panic>
80107bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107bf0 <setupkvm>:
setupkvm(void) {
80107bf0:	55                   	push   %ebp
80107bf1:	89 e5                	mov    %esp,%ebp
80107bf3:	56                   	push   %esi
80107bf4:	53                   	push   %ebx
    if ((pgdir = (pde_t *) kalloc()) == 0)
80107bf5:	e8 16 ad ff ff       	call   80102910 <kalloc>
80107bfa:	85 c0                	test   %eax,%eax
80107bfc:	89 c6                	mov    %eax,%esi
80107bfe:	74 42                	je     80107c42 <setupkvm+0x52>
    memset(pgdir, 0, PGSIZE);
80107c00:	83 ec 04             	sub    $0x4,%esp
    for (k = kmap; k < &kmap[NELEM(kmap)];
80107c03:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
    memset(pgdir, 0, PGSIZE);
80107c08:	68 00 10 00 00       	push   $0x1000
80107c0d:	6a 00                	push   $0x0
80107c0f:	50                   	push   %eax
80107c10:	e8 ab d0 ff ff       	call   80104cc0 <memset>
80107c15:	83 c4 10             	add    $0x10,%esp
                 (uint) k->phys_start, k->perm) < 0) {
80107c18:	8b 43 04             	mov    0x4(%ebx),%eax
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107c1b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107c1e:	83 ec 08             	sub    $0x8,%esp
80107c21:	8b 13                	mov    (%ebx),%edx
80107c23:	ff 73 0c             	pushl  0xc(%ebx)
80107c26:	50                   	push   %eax
80107c27:	29 c1                	sub    %eax,%ecx
80107c29:	89 f0                	mov    %esi,%eax
80107c2b:	e8 70 f4 ff ff       	call   801070a0 <mappages>
80107c30:	83 c4 10             	add    $0x10,%esp
80107c33:	85 c0                	test   %eax,%eax
80107c35:	78 19                	js     80107c50 <setupkvm+0x60>
    k++)
80107c37:	83 c3 10             	add    $0x10,%ebx
    for (k = kmap; k < &kmap[NELEM(kmap)];
80107c3a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107c40:	75 d6                	jne    80107c18 <setupkvm+0x28>
}
80107c42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c45:	89 f0                	mov    %esi,%eax
80107c47:	5b                   	pop    %ebx
80107c48:	5e                   	pop    %esi
80107c49:	5d                   	pop    %ebp
80107c4a:	c3                   	ret    
80107c4b:	90                   	nop
80107c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        freevm(pgdir);
80107c50:	83 ec 0c             	sub    $0xc,%esp
80107c53:	56                   	push   %esi
        return 0;
80107c54:	31 f6                	xor    %esi,%esi
        freevm(pgdir);
80107c56:	e8 d5 fe ff ff       	call   80107b30 <freevm>
        return 0;
80107c5b:	83 c4 10             	add    $0x10,%esp
}
80107c5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c61:	89 f0                	mov    %esi,%eax
80107c63:	5b                   	pop    %ebx
80107c64:	5e                   	pop    %esi
80107c65:	5d                   	pop    %ebp
80107c66:	c3                   	ret    
80107c67:	89 f6                	mov    %esi,%esi
80107c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c70 <kvmalloc>:
kvmalloc(void) {
80107c70:	55                   	push   %ebp
80107c71:	89 e5                	mov    %esp,%ebp
80107c73:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
80107c76:	e8 75 ff ff ff       	call   80107bf0 <setupkvm>
80107c7b:	a3 e8 6c 12 80       	mov    %eax,0x80126ce8
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107c80:	05 00 00 00 80       	add    $0x80000000,%eax
80107c85:	0f 22 d8             	mov    %eax,%cr3
}
80107c88:	c9                   	leave  
80107c89:	c3                   	ret    
80107c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
    void
    clearpteu(pde_t *pgdir, char *uva) {
80107c90:	55                   	push   %ebp
80107c91:	89 e5                	mov    %esp,%ebp
80107c93:	56                   	push   %esi
80107c94:	53                   	push   %ebx
80107c95:	8b 75 0c             	mov    0xc(%ebp),%esi
80107c98:	8b 5d 08             	mov    0x8(%ebp),%ebx
        if (DEBUGMODE == 2 && notShell())
80107c9b:	e8 80 bf ff ff       	call   80103c20 <notShell>
80107ca0:	85 c0                	test   %eax,%eax
80107ca2:	75 44                	jne    80107ce8 <clearpteu+0x58>
            cprintf("CLEARPTEU-");
        pte_t *pte;

        pte = walkpgdir(pgdir, uva, 0);
80107ca4:	31 c9                	xor    %ecx,%ecx
80107ca6:	89 f2                	mov    %esi,%edx
80107ca8:	89 d8                	mov    %ebx,%eax
80107caa:	e8 71 f3 ff ff       	call   80107020 <walkpgdir>
        if (pte == 0)
80107caf:	85 c0                	test   %eax,%eax
80107cb1:	74 47                	je     80107cfa <clearpteu+0x6a>
            panic("clearpteu");
        *pte &= ~PTE_U;
80107cb3:	83 20 fb             	andl   $0xfffffffb,(%eax)
        if (DEBUGMODE == 2 && notShell())
80107cb6:	e8 65 bf ff ff       	call   80103c20 <notShell>
80107cbb:	85 c0                	test   %eax,%eax
80107cbd:	75 11                	jne    80107cd0 <clearpteu+0x40>
            cprintf(">CLEARPTEU-DONE!\t");
    }
80107cbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107cc2:	5b                   	pop    %ebx
80107cc3:	5e                   	pop    %esi
80107cc4:	5d                   	pop    %ebp
80107cc5:	c3                   	ret    
80107cc6:	8d 76 00             	lea    0x0(%esi),%esi
80107cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            cprintf(">CLEARPTEU-DONE!\t");
80107cd0:	c7 45 08 29 8b 10 80 	movl   $0x80108b29,0x8(%ebp)
    }
80107cd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107cda:	5b                   	pop    %ebx
80107cdb:	5e                   	pop    %esi
80107cdc:	5d                   	pop    %ebp
            cprintf(">CLEARPTEU-DONE!\t");
80107cdd:	e9 7e 89 ff ff       	jmp    80100660 <cprintf>
80107ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            cprintf("CLEARPTEU-");
80107ce8:	83 ec 0c             	sub    $0xc,%esp
80107ceb:	68 14 8b 10 80       	push   $0x80108b14
80107cf0:	e8 6b 89 ff ff       	call   80100660 <cprintf>
80107cf5:	83 c4 10             	add    $0x10,%esp
80107cf8:	eb aa                	jmp    80107ca4 <clearpteu+0x14>
            panic("clearpteu");
80107cfa:	83 ec 0c             	sub    $0xc,%esp
80107cfd:	68 1f 8b 10 80       	push   $0x80108b1f
80107d02:	e8 89 86 ff ff       	call   80100390 <panic>
80107d07:	89 f6                	mov    %esi,%esi
80107d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
    pde_t *
    copyuvm(pde_t *pgdir, uint sz) {
80107d10:	55                   	push   %ebp
80107d11:	89 e5                	mov    %esp,%ebp
80107d13:	57                   	push   %edi
80107d14:	56                   	push   %esi
80107d15:	53                   	push   %ebx
80107d16:	83 ec 1c             	sub    $0x1c,%esp
        if (DEBUGMODE == 2 && notShell())
80107d19:	e8 02 bf ff ff       	call   80103c20 <notShell>
80107d1e:	85 c0                	test   %eax,%eax
80107d20:	0f 85 ea 00 00 00    	jne    80107e10 <copyuvm+0x100>
        pde_t *d;
        pte_t *pte;
        uint pa, i, flags;
        char *mem;

        if ((d = setupkvm()) == 0)
80107d26:	e8 c5 fe ff ff       	call   80107bf0 <setupkvm>
80107d2b:	85 c0                	test   %eax,%eax
80107d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d30:	0f 84 a9 00 00 00    	je     80107ddf <copyuvm+0xcf>
            return 0;
        for (i = 0; i < sz; i += PGSIZE) {
80107d36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107d39:	85 c9                	test   %ecx,%ecx
80107d3b:	0f 84 e7 00 00 00    	je     80107e28 <copyuvm+0x118>
80107d41:	31 f6                	xor    %esi,%esi
80107d43:	eb 4d                	jmp    80107d92 <copyuvm+0x82>
80107d45:	8d 76 00             	lea    0x0(%esi),%esi
                panic("copyuvm: page not present");
            pa = PTE_ADDR(*pte);
            flags = PTE_FLAGS(*pte);
            if ((mem = kalloc()) == 0)
                goto bad;
            memmove(mem, (char *) P2V(pa), PGSIZE);
80107d48:	83 ec 04             	sub    $0x4,%esp
80107d4b:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d54:	68 00 10 00 00       	push   $0x1000
80107d59:	57                   	push   %edi
80107d5a:	50                   	push   %eax
80107d5b:	e8 10 d0 ff ff       	call   80104d70 <memmove>
            if (mappages(d, (void *) i, PGSIZE, V2P(mem), flags) < 0)
80107d60:	58                   	pop    %eax
80107d61:	5a                   	pop    %edx
80107d62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107d65:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d68:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d6d:	53                   	push   %ebx
80107d6e:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107d74:	52                   	push   %edx
80107d75:	89 f2                	mov    %esi,%edx
80107d77:	e8 24 f3 ff ff       	call   801070a0 <mappages>
80107d7c:	83 c4 10             	add    $0x10,%esp
80107d7f:	85 c0                	test   %eax,%eax
80107d81:	78 45                	js     80107dc8 <copyuvm+0xb8>
        for (i = 0; i < sz; i += PGSIZE) {
80107d83:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107d89:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107d8c:	0f 86 96 00 00 00    	jbe    80107e28 <copyuvm+0x118>
            if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107d92:	8b 45 08             	mov    0x8(%ebp),%eax
80107d95:	31 c9                	xor    %ecx,%ecx
80107d97:	89 f2                	mov    %esi,%edx
80107d99:	e8 82 f2 ff ff       	call   80107020 <walkpgdir>
80107d9e:	85 c0                	test   %eax,%eax
80107da0:	0f 84 a6 00 00 00    	je     80107e4c <copyuvm+0x13c>
            if (!(*pte & PTE_P))
80107da6:	8b 18                	mov    (%eax),%ebx
80107da8:	f6 c3 01             	test   $0x1,%bl
80107dab:	0f 84 a8 00 00 00    	je     80107e59 <copyuvm+0x149>
            pa = PTE_ADDR(*pte);
80107db1:	89 df                	mov    %ebx,%edi
            flags = PTE_FLAGS(*pte);
80107db3:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
            pa = PTE_ADDR(*pte);
80107db9:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
            if ((mem = kalloc()) == 0)
80107dbf:	e8 4c ab ff ff       	call   80102910 <kalloc>
80107dc4:	85 c0                	test   %eax,%eax
80107dc6:	75 80                	jne    80107d48 <copyuvm+0x38>
        if (DEBUGMODE == 2 && notShell())
            cprintf(">COPYUVM-DONE!\t");
        return d;

        bad:
        freevm(d);
80107dc8:	83 ec 0c             	sub    $0xc,%esp
80107dcb:	ff 75 e0             	pushl  -0x20(%ebp)
80107dce:	e8 5d fd ff ff       	call   80107b30 <freevm>
        if (DEBUGMODE == 2 && notShell())
80107dd3:	e8 48 be ff ff       	call   80103c20 <notShell>
80107dd8:	83 c4 10             	add    $0x10,%esp
80107ddb:	85 c0                	test   %eax,%eax
80107ddd:	75 19                	jne    80107df8 <copyuvm+0xe8>
            cprintf(">COPYUVM-FAILED!\t");
        return 0;
80107ddf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    }
80107de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107de9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dec:	5b                   	pop    %ebx
80107ded:	5e                   	pop    %esi
80107dee:	5f                   	pop    %edi
80107def:	5d                   	pop    %ebp
80107df0:	c3                   	ret    
80107df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cprintf(">COPYUVM-FAILED!\t");
80107df8:	83 ec 0c             	sub    $0xc,%esp
80107dfb:	68 88 8b 10 80       	push   $0x80108b88
80107e00:	e8 5b 88 ff ff       	call   80100660 <cprintf>
80107e05:	83 c4 10             	add    $0x10,%esp
80107e08:	eb d5                	jmp    80107ddf <copyuvm+0xcf>
80107e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            cprintf("COPYUVM-");
80107e10:	83 ec 0c             	sub    $0xc,%esp
80107e13:	68 3b 8b 10 80       	push   $0x80108b3b
80107e18:	e8 43 88 ff ff       	call   80100660 <cprintf>
80107e1d:	83 c4 10             	add    $0x10,%esp
80107e20:	e9 01 ff ff ff       	jmp    80107d26 <copyuvm+0x16>
80107e25:	8d 76 00             	lea    0x0(%esi),%esi
        if (DEBUGMODE == 2 && notShell())
80107e28:	e8 f3 bd ff ff       	call   80103c20 <notShell>
80107e2d:	85 c0                	test   %eax,%eax
80107e2f:	74 b5                	je     80107de6 <copyuvm+0xd6>
            cprintf(">COPYUVM-DONE!\t");
80107e31:	83 ec 0c             	sub    $0xc,%esp
80107e34:	68 78 8b 10 80       	push   $0x80108b78
80107e39:	e8 22 88 ff ff       	call   80100660 <cprintf>
    }
80107e3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
            cprintf(">COPYUVM-DONE!\t");
80107e41:	83 c4 10             	add    $0x10,%esp
    }
80107e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e47:	5b                   	pop    %ebx
80107e48:	5e                   	pop    %esi
80107e49:	5f                   	pop    %edi
80107e4a:	5d                   	pop    %ebp
80107e4b:	c3                   	ret    
                panic("copyuvm: pte should exist");
80107e4c:	83 ec 0c             	sub    $0xc,%esp
80107e4f:	68 44 8b 10 80       	push   $0x80108b44
80107e54:	e8 37 85 ff ff       	call   80100390 <panic>
                panic("copyuvm: page not present");
80107e59:	83 ec 0c             	sub    $0xc,%esp
80107e5c:	68 5e 8b 10 80       	push   $0x80108b5e
80107e61:	e8 2a 85 ff ff       	call   80100390 <panic>
80107e66:	8d 76 00             	lea    0x0(%esi),%esi
80107e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
    char *
    uva2ka(pde_t *pgdir, char *uva) {
80107e70:	55                   	push   %ebp
        pte_t *pte;

        pte = walkpgdir(pgdir, uva, 0);
80107e71:	31 c9                	xor    %ecx,%ecx
    uva2ka(pde_t *pgdir, char *uva) {
80107e73:	89 e5                	mov    %esp,%ebp
80107e75:	83 ec 08             	sub    $0x8,%esp
        pte = walkpgdir(pgdir, uva, 0);
80107e78:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e7e:	e8 9d f1 ff ff       	call   80107020 <walkpgdir>
        if ((*pte & PTE_P) == 0)
80107e83:	8b 00                	mov    (%eax),%eax
            return 0;
        if ((*pte & PTE_U) == 0)
            return 0;
        return (char *) P2V(PTE_ADDR(*pte));
    }
80107e85:	c9                   	leave  
        if ((*pte & PTE_U) == 0)
80107e86:	89 c2                	mov    %eax,%edx
        return (char *) P2V(PTE_ADDR(*pte));
80107e88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if ((*pte & PTE_U) == 0)
80107e8d:	83 e2 05             	and    $0x5,%edx
        return (char *) P2V(PTE_ADDR(*pte));
80107e90:	05 00 00 00 80       	add    $0x80000000,%eax
80107e95:	83 fa 05             	cmp    $0x5,%edx
80107e98:	ba 00 00 00 00       	mov    $0x0,%edx
80107e9d:	0f 45 c2             	cmovne %edx,%eax
    }
80107ea0:	c3                   	ret    
80107ea1:	eb 0d                	jmp    80107eb0 <copyout>
80107ea3:	90                   	nop
80107ea4:	90                   	nop
80107ea5:	90                   	nop
80107ea6:	90                   	nop
80107ea7:	90                   	nop
80107ea8:	90                   	nop
80107ea9:	90                   	nop
80107eaa:	90                   	nop
80107eab:	90                   	nop
80107eac:	90                   	nop
80107ead:	90                   	nop
80107eae:	90                   	nop
80107eaf:	90                   	nop

80107eb0 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
    int
    copyout(pde_t *pgdir, uint va, void *p, uint len) {
80107eb0:	55                   	push   %ebp
80107eb1:	89 e5                	mov    %esp,%ebp
80107eb3:	57                   	push   %edi
80107eb4:	56                   	push   %esi
80107eb5:	53                   	push   %ebx
80107eb6:	83 ec 1c             	sub    $0x1c,%esp
80107eb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ebf:	8b 7d 10             	mov    0x10(%ebp),%edi
        char *buf, *pa0;
        uint n, va0;

        buf = (char *) p;
        while (len > 0) {
80107ec2:	85 db                	test   %ebx,%ebx
80107ec4:	75 40                	jne    80107f06 <copyout+0x56>
80107ec6:	eb 70                	jmp    80107f38 <copyout+0x88>
80107ec8:	90                   	nop
80107ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            va0 = (uint) PGROUNDDOWN(va);
            pa0 = uva2ka(pgdir, (char *) va0);
            if (pa0 == 0)
                return -1;
            n = PGSIZE - (va - va0);
80107ed0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107ed3:	89 f1                	mov    %esi,%ecx
80107ed5:	29 d1                	sub    %edx,%ecx
80107ed7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107edd:	39 d9                	cmp    %ebx,%ecx
80107edf:	0f 47 cb             	cmova  %ebx,%ecx
            if (n > len)
                n = len;
            memmove(pa0 + (va - va0), buf, n);
80107ee2:	29 f2                	sub    %esi,%edx
80107ee4:	83 ec 04             	sub    $0x4,%esp
80107ee7:	01 d0                	add    %edx,%eax
80107ee9:	51                   	push   %ecx
80107eea:	57                   	push   %edi
80107eeb:	50                   	push   %eax
80107eec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107eef:	e8 7c ce ff ff       	call   80104d70 <memmove>
            len -= n;
            buf += n;
80107ef4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        while (len > 0) {
80107ef7:	83 c4 10             	add    $0x10,%esp
            va = va0 + PGSIZE;
80107efa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
            buf += n;
80107f00:	01 cf                	add    %ecx,%edi
        while (len > 0) {
80107f02:	29 cb                	sub    %ecx,%ebx
80107f04:	74 32                	je     80107f38 <copyout+0x88>
            va0 = (uint) PGROUNDDOWN(va);
80107f06:	89 d6                	mov    %edx,%esi
            pa0 = uva2ka(pgdir, (char *) va0);
80107f08:	83 ec 08             	sub    $0x8,%esp
            va0 = (uint) PGROUNDDOWN(va);
80107f0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107f0e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
            pa0 = uva2ka(pgdir, (char *) va0);
80107f14:	56                   	push   %esi
80107f15:	ff 75 08             	pushl  0x8(%ebp)
80107f18:	e8 53 ff ff ff       	call   80107e70 <uva2ka>
            if (pa0 == 0)
80107f1d:	83 c4 10             	add    $0x10,%esp
80107f20:	85 c0                	test   %eax,%eax
80107f22:	75 ac                	jne    80107ed0 <copyout+0x20>
        }
        return 0;
    }
80107f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return -1;
80107f27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
80107f2c:	5b                   	pop    %ebx
80107f2d:	5e                   	pop    %esi
80107f2e:	5f                   	pop    %edi
80107f2f:	5d                   	pop    %ebp
80107f30:	c3                   	ret    
80107f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
80107f3b:	31 c0                	xor    %eax,%eax
    }
80107f3d:	5b                   	pop    %ebx
80107f3e:	5e                   	pop    %esi
80107f3f:	5f                   	pop    %edi
80107f40:	5d                   	pop    %ebp
80107f41:	c3                   	ret    
