
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
  if(argc != 3){
   7:	83 39 03             	cmpl   $0x3,(%ecx)
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   a:	ff 71 fc             	pushl  -0x4(%ecx)
   d:	55                   	push   %ebp
   e:	89 e5                	mov    %esp,%ebp
  10:	53                   	push   %ebx
  11:	51                   	push   %ecx
  12:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  15:	74 14                	je     2b <main+0x2b>
    printf(2, "Usage: ln old new\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 28 07 00 00       	push   $0x728
  1f:	6a 02                	push   $0x2
  21:	e8 da 03 00 00       	call   400 <printf>
    exit();
  26:	e8 87 02 00 00       	call   2b2 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2b:	50                   	push   %eax
  2c:	50                   	push   %eax
  2d:	ff 73 08             	pushl  0x8(%ebx)
  30:	ff 73 04             	pushl  0x4(%ebx)
  33:	e8 da 02 00 00       	call   312 <link>
  38:	83 c4 10             	add    $0x10,%esp
  3b:	85 c0                	test   %eax,%eax
  3d:	78 05                	js     44 <main+0x44>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  3f:	e8 6e 02 00 00       	call   2b2 <exit>
  if(argc != 3){
    printf(2, "Usage: ln old new\n");
    exit();
  }
  if(link(argv[1], argv[2]) < 0)
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  44:	ff 73 08             	pushl  0x8(%ebx)
  47:	ff 73 04             	pushl  0x4(%ebx)
  4a:	68 3b 07 00 00       	push   $0x73b
  4f:	6a 02                	push   $0x2
  51:	e8 aa 03 00 00       	call   400 <printf>
  56:	83 c4 10             	add    $0x10,%esp
  59:	eb e4                	jmp    3f <main+0x3f>
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <strcpy>:
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 45 08             	mov    0x8(%ebp),%eax
  67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  6a:	89 c2                	mov    %eax,%edx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  70:	83 c1 01             	add    $0x1,%ecx
  73:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  77:	83 c2 01             	add    $0x1,%edx
  7a:	84 db                	test   %bl,%bl
  7c:	88 5a ff             	mov    %bl,-0x1(%edx)
  7f:	75 ef                	jne    70 <strcpy+0x10>
  81:	5b                   	pop    %ebx
  82:	5d                   	pop    %ebp
  83:	c3                   	ret    
  84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000090 <strcmp>:
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 55 08             	mov    0x8(%ebp),%edx
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  9a:	0f b6 02             	movzbl (%edx),%eax
  9d:	0f b6 19             	movzbl (%ecx),%ebx
  a0:	84 c0                	test   %al,%al
  a2:	75 1c                	jne    c0 <strcmp+0x30>
  a4:	eb 2a                	jmp    d0 <strcmp+0x40>
  a6:	8d 76 00             	lea    0x0(%esi),%esi
  a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  b0:	83 c2 01             	add    $0x1,%edx
  b3:	0f b6 02             	movzbl (%edx),%eax
  b6:	83 c1 01             	add    $0x1,%ecx
  b9:	0f b6 19             	movzbl (%ecx),%ebx
  bc:	84 c0                	test   %al,%al
  be:	74 10                	je     d0 <strcmp+0x40>
  c0:	38 d8                	cmp    %bl,%al
  c2:	74 ec                	je     b0 <strcmp+0x20>
  c4:	29 d8                	sub    %ebx,%eax
  c6:	5b                   	pop    %ebx
  c7:	5d                   	pop    %ebp
  c8:	c3                   	ret    
  c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  d0:	31 c0                	xor    %eax,%eax
  d2:	29 d8                	sub    %ebx,%eax
  d4:	5b                   	pop    %ebx
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strlen>:
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e6:	80 39 00             	cmpb   $0x0,(%ecx)
  e9:	74 15                	je     100 <strlen+0x20>
  eb:	31 d2                	xor    %edx,%edx
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	83 c2 01             	add    $0x1,%edx
  f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f7:	89 d0                	mov    %edx,%eax
  f9:	75 f5                	jne    f0 <strlen+0x10>
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	31 c0                	xor    %eax,%eax
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <memset>:
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	8b 55 08             	mov    0x8(%ebp),%edx
 117:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 d7                	mov    %edx,%edi
 11f:	fc                   	cld    
 120:	f3 aa                	rep stos %al,%es:(%edi)
 122:	89 d0                	mov    %edx,%eax
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <strchr>:
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 13a:	0f b6 10             	movzbl (%eax),%edx
 13d:	84 d2                	test   %dl,%dl
 13f:	74 1d                	je     15e <strchr+0x2e>
 141:	38 d3                	cmp    %dl,%bl
 143:	89 d9                	mov    %ebx,%ecx
 145:	75 0d                	jne    154 <strchr+0x24>
 147:	eb 17                	jmp    160 <strchr+0x30>
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 150:	38 ca                	cmp    %cl,%dl
 152:	74 0c                	je     160 <strchr+0x30>
 154:	83 c0 01             	add    $0x1,%eax
 157:	0f b6 10             	movzbl (%eax),%edx
 15a:	84 d2                	test   %dl,%dl
 15c:	75 f2                	jne    150 <strchr+0x20>
 15e:	31 c0                	xor    %eax,%eax
 160:	5b                   	pop    %ebx
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <gets>:
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
 176:	31 f6                	xor    %esi,%esi
 178:	89 f3                	mov    %esi,%ebx
 17a:	83 ec 1c             	sub    $0x1c,%esp
 17d:	8b 7d 08             	mov    0x8(%ebp),%edi
 180:	eb 2f                	jmp    1b1 <gets+0x41>
 182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 188:	8d 45 e7             	lea    -0x19(%ebp),%eax
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	6a 01                	push   $0x1
 190:	50                   	push   %eax
 191:	6a 00                	push   $0x0
 193:	e8 32 01 00 00       	call   2ca <read>
 198:	83 c4 10             	add    $0x10,%esp
 19b:	85 c0                	test   %eax,%eax
 19d:	7e 1c                	jle    1bb <gets+0x4b>
 19f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a3:	83 c7 01             	add    $0x1,%edi
 1a6:	88 47 ff             	mov    %al,-0x1(%edi)
 1a9:	3c 0a                	cmp    $0xa,%al
 1ab:	74 23                	je     1d0 <gets+0x60>
 1ad:	3c 0d                	cmp    $0xd,%al
 1af:	74 1f                	je     1d0 <gets+0x60>
 1b1:	83 c3 01             	add    $0x1,%ebx
 1b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b7:	89 fe                	mov    %edi,%esi
 1b9:	7c cd                	jl     188 <gets+0x18>
 1bb:	89 f3                	mov    %esi,%ebx
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	c6 03 00             	movb   $0x0,(%ebx)
 1c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5f                   	pop    %edi
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    
 1cb:	90                   	nop
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d0:	8b 75 08             	mov    0x8(%ebp),%esi
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	01 de                	add    %ebx,%esi
 1d8:	89 f3                	mov    %esi,%ebx
 1da:	c6 03 00             	movb   $0x0,(%ebx)
 1dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e0:	5b                   	pop    %ebx
 1e1:	5e                   	pop    %esi
 1e2:	5f                   	pop    %edi
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    
 1e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <stat>:
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 00                	push   $0x0
 1fa:	ff 75 08             	pushl  0x8(%ebp)
 1fd:	e8 f0 00 00 00       	call   2f2 <open>
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 c0                	test   %eax,%eax
 207:	78 27                	js     230 <stat+0x40>
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	ff 75 0c             	pushl  0xc(%ebp)
 20f:	89 c3                	mov    %eax,%ebx
 211:	50                   	push   %eax
 212:	e8 f3 00 00 00       	call   30a <fstat>
 217:	89 1c 24             	mov    %ebx,(%esp)
 21a:	89 c6                	mov    %eax,%esi
 21c:	e8 b9 00 00 00       	call   2da <close>
 221:	83 c4 10             	add    $0x10,%esp
 224:	8d 65 f8             	lea    -0x8(%ebp),%esp
 227:	89 f0                	mov    %esi,%eax
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
 230:	be ff ff ff ff       	mov    $0xffffffff,%esi
 235:	eb ed                	jmp    224 <stat+0x34>
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <atoi>:
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 4d 08             	mov    0x8(%ebp),%ecx
 247:	0f be 11             	movsbl (%ecx),%edx
 24a:	8d 42 d0             	lea    -0x30(%edx),%eax
 24d:	3c 09                	cmp    $0x9,%al
 24f:	b8 00 00 00 00       	mov    $0x0,%eax
 254:	77 1f                	ja     275 <atoi+0x35>
 256:	8d 76 00             	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 260:	8d 04 80             	lea    (%eax,%eax,4),%eax
 263:	83 c1 01             	add    $0x1,%ecx
 266:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 26a:	0f be 11             	movsbl (%ecx),%edx
 26d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
 275:	5b                   	pop    %ebx
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    
 278:	90                   	nop
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <memmove>:
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
 285:	8b 5d 10             	mov    0x10(%ebp),%ebx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8b 75 0c             	mov    0xc(%ebp),%esi
 28e:	85 db                	test   %ebx,%ebx
 290:	7e 14                	jle    2a6 <memmove+0x26>
 292:	31 d2                	xor    %edx,%edx
 294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 298:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 29c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 29f:	83 c2 01             	add    $0x1,%edx
 2a2:	39 d3                	cmp    %edx,%ebx
 2a4:	75 f2                	jne    298 <memmove+0x18>
 2a6:	5b                   	pop    %ebx
 2a7:	5e                   	pop    %esi
 2a8:	5d                   	pop    %ebp
 2a9:	c3                   	ret    

000002aa <fork>:
 2aa:	b8 01 00 00 00       	mov    $0x1,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <exit>:
 2b2:	b8 02 00 00 00       	mov    $0x2,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <wait>:
 2ba:	b8 03 00 00 00       	mov    $0x3,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <pipe>:
 2c2:	b8 04 00 00 00       	mov    $0x4,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <read>:
 2ca:	b8 05 00 00 00       	mov    $0x5,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <write>:
 2d2:	b8 10 00 00 00       	mov    $0x10,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <close>:
 2da:	b8 15 00 00 00       	mov    $0x15,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <kill>:
 2e2:	b8 06 00 00 00       	mov    $0x6,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <exec>:
 2ea:	b8 07 00 00 00       	mov    $0x7,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <open>:
 2f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <mknod>:
 2fa:	b8 11 00 00 00       	mov    $0x11,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <unlink>:
 302:	b8 12 00 00 00       	mov    $0x12,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <fstat>:
 30a:	b8 08 00 00 00       	mov    $0x8,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <link>:
 312:	b8 13 00 00 00       	mov    $0x13,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <mkdir>:
 31a:	b8 14 00 00 00       	mov    $0x14,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <chdir>:
 322:	b8 09 00 00 00       	mov    $0x9,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <dup>:
 32a:	b8 0a 00 00 00       	mov    $0xa,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <getpid>:
 332:	b8 0b 00 00 00       	mov    $0xb,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sbrk>:
 33a:	b8 0c 00 00 00       	mov    $0xc,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sleep>:
 342:	b8 0d 00 00 00       	mov    $0xd,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <uptime>:
 34a:	b8 0e 00 00 00       	mov    $0xe,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    
 352:	66 90                	xchg   %ax,%ax
 354:	66 90                	xchg   %ax,%ax
 356:	66 90                	xchg   %ax,%ax
 358:	66 90                	xchg   %ax,%ax
 35a:	66 90                	xchg   %ax,%ax
 35c:	66 90                	xchg   %ax,%ax
 35e:	66 90                	xchg   %ax,%ax

00000360 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
 366:	89 c6                	mov    %eax,%esi
 368:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 36b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 36e:	85 db                	test   %ebx,%ebx
 370:	74 7e                	je     3f0 <printint+0x90>
 372:	89 d0                	mov    %edx,%eax
 374:	c1 e8 1f             	shr    $0x1f,%eax
 377:	84 c0                	test   %al,%al
 379:	74 75                	je     3f0 <printint+0x90>
    neg = 1;
    x = -xx;
 37b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 37d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 384:	f7 d8                	neg    %eax
 386:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 389:	31 ff                	xor    %edi,%edi
 38b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 38e:	89 ce                	mov    %ecx,%esi
 390:	eb 08                	jmp    39a <printint+0x3a>
 392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 398:	89 cf                	mov    %ecx,%edi
 39a:	31 d2                	xor    %edx,%edx
 39c:	8d 4f 01             	lea    0x1(%edi),%ecx
 39f:	f7 f6                	div    %esi
 3a1:	0f b6 92 58 07 00 00 	movzbl 0x758(%edx),%edx
  }while((x /= base) != 0);
 3a8:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3aa:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 3ad:	75 e9                	jne    398 <printint+0x38>
  if(neg)
 3af:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3b2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 3b5:	85 c0                	test   %eax,%eax
 3b7:	74 08                	je     3c1 <printint+0x61>
    buf[i++] = '-';
 3b9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 3be:	8d 4f 02             	lea    0x2(%edi),%ecx
 3c1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 3c5:	8d 76 00             	lea    0x0(%esi),%esi
 3c8:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3cb:	83 ec 04             	sub    $0x4,%esp
 3ce:	83 ef 01             	sub    $0x1,%edi
 3d1:	6a 01                	push   $0x1
 3d3:	53                   	push   %ebx
 3d4:	56                   	push   %esi
 3d5:	88 45 d7             	mov    %al,-0x29(%ebp)
 3d8:	e8 f5 fe ff ff       	call   2d2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3dd:	83 c4 10             	add    $0x10,%esp
 3e0:	39 df                	cmp    %ebx,%edi
 3e2:	75 e4                	jne    3c8 <printint+0x68>
    putc(fd, buf[i]);
}
 3e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e7:	5b                   	pop    %ebx
 3e8:	5e                   	pop    %esi
 3e9:	5f                   	pop    %edi
 3ea:	5d                   	pop    %ebp
 3eb:	c3                   	ret    
 3ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f0:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3f9:	eb 8b                	jmp    386 <printint+0x26>
 3fb:	90                   	nop
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000400 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 406:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 409:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 40c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 40f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 412:	89 45 d0             	mov    %eax,-0x30(%ebp)
 415:	0f b6 1e             	movzbl (%esi),%ebx
 418:	83 c6 01             	add    $0x1,%esi
 41b:	84 db                	test   %bl,%bl
 41d:	0f 84 b0 00 00 00    	je     4d3 <printf+0xd3>
 423:	31 d2                	xor    %edx,%edx
 425:	eb 39                	jmp    460 <printf+0x60>
 427:	89 f6                	mov    %esi,%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 430:	83 f8 25             	cmp    $0x25,%eax
 433:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 436:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 43b:	74 18                	je     455 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 43d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 440:	83 ec 04             	sub    $0x4,%esp
 443:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 446:	6a 01                	push   $0x1
 448:	50                   	push   %eax
 449:	57                   	push   %edi
 44a:	e8 83 fe ff ff       	call   2d2 <write>
 44f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 452:	83 c4 10             	add    $0x10,%esp
 455:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 458:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 45c:	84 db                	test   %bl,%bl
 45e:	74 73                	je     4d3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 460:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 462:	0f be cb             	movsbl %bl,%ecx
 465:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 468:	74 c6                	je     430 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 46a:	83 fa 25             	cmp    $0x25,%edx
 46d:	75 e6                	jne    455 <printf+0x55>
      if(c == 'd'){
 46f:	83 f8 64             	cmp    $0x64,%eax
 472:	0f 84 f8 00 00 00    	je     570 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 478:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 47e:	83 f9 70             	cmp    $0x70,%ecx
 481:	74 5d                	je     4e0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 483:	83 f8 73             	cmp    $0x73,%eax
 486:	0f 84 84 00 00 00    	je     510 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 48c:	83 f8 63             	cmp    $0x63,%eax
 48f:	0f 84 ea 00 00 00    	je     57f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 495:	83 f8 25             	cmp    $0x25,%eax
 498:	0f 84 c2 00 00 00    	je     560 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 49e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4a1:	83 ec 04             	sub    $0x4,%esp
 4a4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4a8:	6a 01                	push   $0x1
 4aa:	50                   	push   %eax
 4ab:	57                   	push   %edi
 4ac:	e8 21 fe ff ff       	call   2d2 <write>
 4b1:	83 c4 0c             	add    $0xc,%esp
 4b4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4b7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4ba:	6a 01                	push   $0x1
 4bc:	50                   	push   %eax
 4bd:	57                   	push   %edi
 4be:	83 c6 01             	add    $0x1,%esi
 4c1:	e8 0c fe ff ff       	call   2d2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ca:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4cd:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4cf:	84 db                	test   %bl,%bl
 4d1:	75 8d                	jne    460 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d6:	5b                   	pop    %ebx
 4d7:	5e                   	pop    %esi
 4d8:	5f                   	pop    %edi
 4d9:	5d                   	pop    %ebp
 4da:	c3                   	ret    
 4db:	90                   	nop
 4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4e0:	83 ec 0c             	sub    $0xc,%esp
 4e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4e8:	6a 00                	push   $0x0
 4ea:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4ed:	89 f8                	mov    %edi,%eax
 4ef:	8b 13                	mov    (%ebx),%edx
 4f1:	e8 6a fe ff ff       	call   360 <printint>
        ap++;
 4f6:	89 d8                	mov    %ebx,%eax
 4f8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4fb:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 4fd:	83 c0 04             	add    $0x4,%eax
 500:	89 45 d0             	mov    %eax,-0x30(%ebp)
 503:	e9 4d ff ff ff       	jmp    455 <printf+0x55>
 508:	90                   	nop
 509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 510:	8b 45 d0             	mov    -0x30(%ebp),%eax
 513:	8b 18                	mov    (%eax),%ebx
        ap++;
 515:	83 c0 04             	add    $0x4,%eax
 518:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 51b:	b8 4f 07 00 00       	mov    $0x74f,%eax
 520:	85 db                	test   %ebx,%ebx
 522:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 525:	0f b6 03             	movzbl (%ebx),%eax
 528:	84 c0                	test   %al,%al
 52a:	74 23                	je     54f <printf+0x14f>
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 530:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 533:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 536:	83 ec 04             	sub    $0x4,%esp
 539:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 53b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53e:	50                   	push   %eax
 53f:	57                   	push   %edi
 540:	e8 8d fd ff ff       	call   2d2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 545:	0f b6 03             	movzbl (%ebx),%eax
 548:	83 c4 10             	add    $0x10,%esp
 54b:	84 c0                	test   %al,%al
 54d:	75 e1                	jne    530 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 54f:	31 d2                	xor    %edx,%edx
 551:	e9 ff fe ff ff       	jmp    455 <printf+0x55>
 556:	8d 76 00             	lea    0x0(%esi),%esi
 559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 560:	83 ec 04             	sub    $0x4,%esp
 563:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 566:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 569:	6a 01                	push   $0x1
 56b:	e9 4c ff ff ff       	jmp    4bc <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 570:	83 ec 0c             	sub    $0xc,%esp
 573:	b9 0a 00 00 00       	mov    $0xa,%ecx
 578:	6a 01                	push   $0x1
 57a:	e9 6b ff ff ff       	jmp    4ea <printf+0xea>
 57f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 582:	83 ec 04             	sub    $0x4,%esp
 585:	8b 03                	mov    (%ebx),%eax
 587:	6a 01                	push   $0x1
 589:	88 45 e4             	mov    %al,-0x1c(%ebp)
 58c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 58f:	50                   	push   %eax
 590:	57                   	push   %edi
 591:	e8 3c fd ff ff       	call   2d2 <write>
 596:	e9 5b ff ff ff       	jmp    4f6 <printf+0xf6>
 59b:	66 90                	xchg   %ax,%ax
 59d:	66 90                	xchg   %ax,%ax
 59f:	90                   	nop

000005a0 <free>:
 5a0:	55                   	push   %ebp
 5a1:	a1 00 0a 00 00       	mov    0xa00,%eax
 5a6:	89 e5                	mov    %esp,%ebp
 5a8:	57                   	push   %edi
 5a9:	56                   	push   %esi
 5aa:	53                   	push   %ebx
 5ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 5b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5b8:	39 c8                	cmp    %ecx,%eax
 5ba:	8b 10                	mov    (%eax),%edx
 5bc:	73 32                	jae    5f0 <free+0x50>
 5be:	39 d1                	cmp    %edx,%ecx
 5c0:	72 04                	jb     5c6 <free+0x26>
 5c2:	39 d0                	cmp    %edx,%eax
 5c4:	72 32                	jb     5f8 <free+0x58>
 5c6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5c9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5cc:	39 fa                	cmp    %edi,%edx
 5ce:	74 30                	je     600 <free+0x60>
 5d0:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5d3:	8b 50 04             	mov    0x4(%eax),%edx
 5d6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5d9:	39 f1                	cmp    %esi,%ecx
 5db:	74 3a                	je     617 <free+0x77>
 5dd:	89 08                	mov    %ecx,(%eax)
 5df:	a3 00 0a 00 00       	mov    %eax,0xa00
 5e4:	5b                   	pop    %ebx
 5e5:	5e                   	pop    %esi
 5e6:	5f                   	pop    %edi
 5e7:	5d                   	pop    %ebp
 5e8:	c3                   	ret    
 5e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f0:	39 d0                	cmp    %edx,%eax
 5f2:	72 04                	jb     5f8 <free+0x58>
 5f4:	39 d1                	cmp    %edx,%ecx
 5f6:	72 ce                	jb     5c6 <free+0x26>
 5f8:	89 d0                	mov    %edx,%eax
 5fa:	eb bc                	jmp    5b8 <free+0x18>
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 600:	03 72 04             	add    0x4(%edx),%esi
 603:	89 73 fc             	mov    %esi,-0x4(%ebx)
 606:	8b 10                	mov    (%eax),%edx
 608:	8b 12                	mov    (%edx),%edx
 60a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 60d:	8b 50 04             	mov    0x4(%eax),%edx
 610:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 613:	39 f1                	cmp    %esi,%ecx
 615:	75 c6                	jne    5dd <free+0x3d>
 617:	03 53 fc             	add    -0x4(%ebx),%edx
 61a:	a3 00 0a 00 00       	mov    %eax,0xa00
 61f:	89 50 04             	mov    %edx,0x4(%eax)
 622:	8b 53 f8             	mov    -0x8(%ebx),%edx
 625:	89 10                	mov    %edx,(%eax)
 627:	5b                   	pop    %ebx
 628:	5e                   	pop    %esi
 629:	5f                   	pop    %edi
 62a:	5d                   	pop    %ebp
 62b:	c3                   	ret    
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000630 <malloc>:
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	83 ec 0c             	sub    $0xc,%esp
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	8b 15 00 0a 00 00    	mov    0xa00,%edx
 642:	8d 78 07             	lea    0x7(%eax),%edi
 645:	c1 ef 03             	shr    $0x3,%edi
 648:	83 c7 01             	add    $0x1,%edi
 64b:	85 d2                	test   %edx,%edx
 64d:	0f 84 9d 00 00 00    	je     6f0 <malloc+0xc0>
 653:	8b 02                	mov    (%edx),%eax
 655:	8b 48 04             	mov    0x4(%eax),%ecx
 658:	39 cf                	cmp    %ecx,%edi
 65a:	76 6c                	jbe    6c8 <malloc+0x98>
 65c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 662:	bb 00 10 00 00       	mov    $0x1000,%ebx
 667:	0f 43 df             	cmovae %edi,%ebx
 66a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 671:	eb 0e                	jmp    681 <malloc+0x51>
 673:	90                   	nop
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 678:	8b 02                	mov    (%edx),%eax
 67a:	8b 48 04             	mov    0x4(%eax),%ecx
 67d:	39 f9                	cmp    %edi,%ecx
 67f:	73 47                	jae    6c8 <malloc+0x98>
 681:	39 05 00 0a 00 00    	cmp    %eax,0xa00
 687:	89 c2                	mov    %eax,%edx
 689:	75 ed                	jne    678 <malloc+0x48>
 68b:	83 ec 0c             	sub    $0xc,%esp
 68e:	56                   	push   %esi
 68f:	e8 a6 fc ff ff       	call   33a <sbrk>
 694:	83 c4 10             	add    $0x10,%esp
 697:	83 f8 ff             	cmp    $0xffffffff,%eax
 69a:	74 1c                	je     6b8 <malloc+0x88>
 69c:	89 58 04             	mov    %ebx,0x4(%eax)
 69f:	83 ec 0c             	sub    $0xc,%esp
 6a2:	83 c0 08             	add    $0x8,%eax
 6a5:	50                   	push   %eax
 6a6:	e8 f5 fe ff ff       	call   5a0 <free>
 6ab:	8b 15 00 0a 00 00    	mov    0xa00,%edx
 6b1:	83 c4 10             	add    $0x10,%esp
 6b4:	85 d2                	test   %edx,%edx
 6b6:	75 c0                	jne    678 <malloc+0x48>
 6b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6bb:	31 c0                	xor    %eax,%eax
 6bd:	5b                   	pop    %ebx
 6be:	5e                   	pop    %esi
 6bf:	5f                   	pop    %edi
 6c0:	5d                   	pop    %ebp
 6c1:	c3                   	ret    
 6c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6c8:	39 cf                	cmp    %ecx,%edi
 6ca:	74 54                	je     720 <malloc+0xf0>
 6cc:	29 f9                	sub    %edi,%ecx
 6ce:	89 48 04             	mov    %ecx,0x4(%eax)
 6d1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
 6d4:	89 78 04             	mov    %edi,0x4(%eax)
 6d7:	89 15 00 0a 00 00    	mov    %edx,0xa00
 6dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e0:	83 c0 08             	add    $0x8,%eax
 6e3:	5b                   	pop    %ebx
 6e4:	5e                   	pop    %esi
 6e5:	5f                   	pop    %edi
 6e6:	5d                   	pop    %ebp
 6e7:	c3                   	ret    
 6e8:	90                   	nop
 6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6f0:	c7 05 00 0a 00 00 04 	movl   $0xa04,0xa00
 6f7:	0a 00 00 
 6fa:	c7 05 04 0a 00 00 04 	movl   $0xa04,0xa04
 701:	0a 00 00 
 704:	b8 04 0a 00 00       	mov    $0xa04,%eax
 709:	c7 05 08 0a 00 00 00 	movl   $0x0,0xa08
 710:	00 00 00 
 713:	e9 44 ff ff ff       	jmp    65c <malloc+0x2c>
 718:	90                   	nop
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 720:	8b 08                	mov    (%eax),%ecx
 722:	89 0a                	mov    %ecx,(%edx)
 724:	eb b1                	jmp    6d7 <malloc+0xa7>
