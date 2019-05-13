
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  11:	e8 64 02 00 00       	call   27a <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ee 02 00 00       	call   312 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  27:	e8 56 02 00 00       	call   282 <exit>
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <strcpy>:
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  34:	8b 45 08             	mov    0x8(%ebp),%eax
  37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  3a:	89 c2                	mov    %eax,%edx
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  40:	83 c1 01             	add    $0x1,%ecx
  43:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  47:	83 c2 01             	add    $0x1,%edx
  4a:	84 db                	test   %bl,%bl
  4c:	88 5a ff             	mov    %bl,-0x1(%edx)
  4f:	75 ef                	jne    40 <strcpy+0x10>
  51:	5b                   	pop    %ebx
  52:	5d                   	pop    %ebp
  53:	c3                   	ret    
  54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000060 <strcmp>:
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 55 08             	mov    0x8(%ebp),%edx
  67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  6a:	0f b6 02             	movzbl (%edx),%eax
  6d:	0f b6 19             	movzbl (%ecx),%ebx
  70:	84 c0                	test   %al,%al
  72:	75 1c                	jne    90 <strcmp+0x30>
  74:	eb 2a                	jmp    a0 <strcmp+0x40>
  76:	8d 76 00             	lea    0x0(%esi),%esi
  79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  80:	83 c2 01             	add    $0x1,%edx
  83:	0f b6 02             	movzbl (%edx),%eax
  86:	83 c1 01             	add    $0x1,%ecx
  89:	0f b6 19             	movzbl (%ecx),%ebx
  8c:	84 c0                	test   %al,%al
  8e:	74 10                	je     a0 <strcmp+0x40>
  90:	38 d8                	cmp    %bl,%al
  92:	74 ec                	je     80 <strcmp+0x20>
  94:	29 d8                	sub    %ebx,%eax
  96:	5b                   	pop    %ebx
  97:	5d                   	pop    %ebp
  98:	c3                   	ret    
  99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  a0:	31 c0                	xor    %eax,%eax
  a2:	29 d8                	sub    %ebx,%eax
  a4:	5b                   	pop    %ebx
  a5:	5d                   	pop    %ebp
  a6:	c3                   	ret    
  a7:	89 f6                	mov    %esi,%esi
  a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000b0 <strlen>:
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b6:	80 39 00             	cmpb   $0x0,(%ecx)
  b9:	74 15                	je     d0 <strlen+0x20>
  bb:	31 d2                	xor    %edx,%edx
  bd:	8d 76 00             	lea    0x0(%esi),%esi
  c0:	83 c2 01             	add    $0x1,%edx
  c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  c7:	89 d0                	mov    %edx,%eax
  c9:	75 f5                	jne    c0 <strlen+0x10>
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    
  cd:	8d 76 00             	lea    0x0(%esi),%esi
  d0:	31 c0                	xor    %eax,%eax
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    
  d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000e0 <memset>:
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	57                   	push   %edi
  e4:	8b 55 08             	mov    0x8(%ebp),%edx
  e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	89 d7                	mov    %edx,%edi
  ef:	fc                   	cld    
  f0:	f3 aa                	rep stos %al,%es:(%edi)
  f2:	89 d0                	mov    %edx,%eax
  f4:	5f                   	pop    %edi
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    
  f7:	89 f6                	mov    %esi,%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <strchr>:
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 10a:	0f b6 10             	movzbl (%eax),%edx
 10d:	84 d2                	test   %dl,%dl
 10f:	74 1d                	je     12e <strchr+0x2e>
 111:	38 d3                	cmp    %dl,%bl
 113:	89 d9                	mov    %ebx,%ecx
 115:	75 0d                	jne    124 <strchr+0x24>
 117:	eb 17                	jmp    130 <strchr+0x30>
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 120:	38 ca                	cmp    %cl,%dl
 122:	74 0c                	je     130 <strchr+0x30>
 124:	83 c0 01             	add    $0x1,%eax
 127:	0f b6 10             	movzbl (%eax),%edx
 12a:	84 d2                	test   %dl,%dl
 12c:	75 f2                	jne    120 <strchr+0x20>
 12e:	31 c0                	xor    %eax,%eax
 130:	5b                   	pop    %ebx
 131:	5d                   	pop    %ebp
 132:	c3                   	ret    
 133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000140 <gets>:
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
 146:	31 f6                	xor    %esi,%esi
 148:	89 f3                	mov    %esi,%ebx
 14a:	83 ec 1c             	sub    $0x1c,%esp
 14d:	8b 7d 08             	mov    0x8(%ebp),%edi
 150:	eb 2f                	jmp    181 <gets+0x41>
 152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 158:	8d 45 e7             	lea    -0x19(%ebp),%eax
 15b:	83 ec 04             	sub    $0x4,%esp
 15e:	6a 01                	push   $0x1
 160:	50                   	push   %eax
 161:	6a 00                	push   $0x0
 163:	e8 32 01 00 00       	call   29a <read>
 168:	83 c4 10             	add    $0x10,%esp
 16b:	85 c0                	test   %eax,%eax
 16d:	7e 1c                	jle    18b <gets+0x4b>
 16f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 173:	83 c7 01             	add    $0x1,%edi
 176:	88 47 ff             	mov    %al,-0x1(%edi)
 179:	3c 0a                	cmp    $0xa,%al
 17b:	74 23                	je     1a0 <gets+0x60>
 17d:	3c 0d                	cmp    $0xd,%al
 17f:	74 1f                	je     1a0 <gets+0x60>
 181:	83 c3 01             	add    $0x1,%ebx
 184:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 187:	89 fe                	mov    %edi,%esi
 189:	7c cd                	jl     158 <gets+0x18>
 18b:	89 f3                	mov    %esi,%ebx
 18d:	8b 45 08             	mov    0x8(%ebp),%eax
 190:	c6 03 00             	movb   $0x0,(%ebx)
 193:	8d 65 f4             	lea    -0xc(%ebp),%esp
 196:	5b                   	pop    %ebx
 197:	5e                   	pop    %esi
 198:	5f                   	pop    %edi
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    
 19b:	90                   	nop
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a0:	8b 75 08             	mov    0x8(%ebp),%esi
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	01 de                	add    %ebx,%esi
 1a8:	89 f3                	mov    %esi,%ebx
 1aa:	c6 03 00             	movb   $0x0,(%ebx)
 1ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1b0:	5b                   	pop    %ebx
 1b1:	5e                   	pop    %esi
 1b2:	5f                   	pop    %edi
 1b3:	5d                   	pop    %ebp
 1b4:	c3                   	ret    
 1b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <stat>:
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	56                   	push   %esi
 1c4:	53                   	push   %ebx
 1c5:	83 ec 08             	sub    $0x8,%esp
 1c8:	6a 00                	push   $0x0
 1ca:	ff 75 08             	pushl  0x8(%ebp)
 1cd:	e8 f0 00 00 00       	call   2c2 <open>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	85 c0                	test   %eax,%eax
 1d7:	78 27                	js     200 <stat+0x40>
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	ff 75 0c             	pushl  0xc(%ebp)
 1df:	89 c3                	mov    %eax,%ebx
 1e1:	50                   	push   %eax
 1e2:	e8 f3 00 00 00       	call   2da <fstat>
 1e7:	89 1c 24             	mov    %ebx,(%esp)
 1ea:	89 c6                	mov    %eax,%esi
 1ec:	e8 b9 00 00 00       	call   2aa <close>
 1f1:	83 c4 10             	add    $0x10,%esp
 1f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1f7:	89 f0                	mov    %esi,%eax
 1f9:	5b                   	pop    %ebx
 1fa:	5e                   	pop    %esi
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
 200:	be ff ff ff ff       	mov    $0xffffffff,%esi
 205:	eb ed                	jmp    1f4 <stat+0x34>
 207:	89 f6                	mov    %esi,%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000210 <atoi>:
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 4d 08             	mov    0x8(%ebp),%ecx
 217:	0f be 11             	movsbl (%ecx),%edx
 21a:	8d 42 d0             	lea    -0x30(%edx),%eax
 21d:	3c 09                	cmp    $0x9,%al
 21f:	b8 00 00 00 00       	mov    $0x0,%eax
 224:	77 1f                	ja     245 <atoi+0x35>
 226:	8d 76 00             	lea    0x0(%esi),%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 230:	8d 04 80             	lea    (%eax,%eax,4),%eax
 233:	83 c1 01             	add    $0x1,%ecx
 236:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 23a:	0f be 11             	movsbl (%ecx),%edx
 23d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 240:	80 fb 09             	cmp    $0x9,%bl
 243:	76 eb                	jbe    230 <atoi+0x20>
 245:	5b                   	pop    %ebx
 246:	5d                   	pop    %ebp
 247:	c3                   	ret    
 248:	90                   	nop
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000250 <memmove>:
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	56                   	push   %esi
 254:	53                   	push   %ebx
 255:	8b 5d 10             	mov    0x10(%ebp),%ebx
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	8b 75 0c             	mov    0xc(%ebp),%esi
 25e:	85 db                	test   %ebx,%ebx
 260:	7e 14                	jle    276 <memmove+0x26>
 262:	31 d2                	xor    %edx,%edx
 264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 268:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 26c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 26f:	83 c2 01             	add    $0x1,%edx
 272:	39 d3                	cmp    %edx,%ebx
 274:	75 f2                	jne    268 <memmove+0x18>
 276:	5b                   	pop    %ebx
 277:	5e                   	pop    %esi
 278:	5d                   	pop    %ebp
 279:	c3                   	ret    

0000027a <fork>:
 27a:	b8 01 00 00 00       	mov    $0x1,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <exit>:
 282:	b8 02 00 00 00       	mov    $0x2,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <wait>:
 28a:	b8 03 00 00 00       	mov    $0x3,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <pipe>:
 292:	b8 04 00 00 00       	mov    $0x4,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <read>:
 29a:	b8 05 00 00 00       	mov    $0x5,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <write>:
 2a2:	b8 10 00 00 00       	mov    $0x10,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <close>:
 2aa:	b8 15 00 00 00       	mov    $0x15,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <kill>:
 2b2:	b8 06 00 00 00       	mov    $0x6,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <exec>:
 2ba:	b8 07 00 00 00       	mov    $0x7,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <open>:
 2c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <mknod>:
 2ca:	b8 11 00 00 00       	mov    $0x11,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <unlink>:
 2d2:	b8 12 00 00 00       	mov    $0x12,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <fstat>:
 2da:	b8 08 00 00 00       	mov    $0x8,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <link>:
 2e2:	b8 13 00 00 00       	mov    $0x13,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <mkdir>:
 2ea:	b8 14 00 00 00       	mov    $0x14,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <chdir>:
 2f2:	b8 09 00 00 00       	mov    $0x9,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <dup>:
 2fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <getpid>:
 302:	b8 0b 00 00 00       	mov    $0xb,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <sbrk>:
 30a:	b8 0c 00 00 00       	mov    $0xc,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <sleep>:
 312:	b8 0d 00 00 00       	mov    $0xd,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <uptime>:
 31a:	b8 0e 00 00 00       	mov    $0xe,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    
 322:	66 90                	xchg   %ax,%ax
 324:	66 90                	xchg   %ax,%ax
 326:	66 90                	xchg   %ax,%ax
 328:	66 90                	xchg   %ax,%ax
 32a:	66 90                	xchg   %ax,%ax
 32c:	66 90                	xchg   %ax,%ax
 32e:	66 90                	xchg   %ax,%ax

00000330 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	56                   	push   %esi
 335:	53                   	push   %ebx
 336:	89 c6                	mov    %eax,%esi
 338:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 33b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 33e:	85 db                	test   %ebx,%ebx
 340:	74 7e                	je     3c0 <printint+0x90>
 342:	89 d0                	mov    %edx,%eax
 344:	c1 e8 1f             	shr    $0x1f,%eax
 347:	84 c0                	test   %al,%al
 349:	74 75                	je     3c0 <printint+0x90>
    neg = 1;
    x = -xx;
 34b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 34d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 354:	f7 d8                	neg    %eax
 356:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 359:	31 ff                	xor    %edi,%edi
 35b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 35e:	89 ce                	mov    %ecx,%esi
 360:	eb 08                	jmp    36a <printint+0x3a>
 362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 368:	89 cf                	mov    %ecx,%edi
 36a:	31 d2                	xor    %edx,%edx
 36c:	8d 4f 01             	lea    0x1(%edi),%ecx
 36f:	f7 f6                	div    %esi
 371:	0f b6 92 00 07 00 00 	movzbl 0x700(%edx),%edx
  }while((x /= base) != 0);
 378:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 37a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 37d:	75 e9                	jne    368 <printint+0x38>
  if(neg)
 37f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 382:	8b 75 c0             	mov    -0x40(%ebp),%esi
 385:	85 c0                	test   %eax,%eax
 387:	74 08                	je     391 <printint+0x61>
    buf[i++] = '-';
 389:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 38e:	8d 4f 02             	lea    0x2(%edi),%ecx
 391:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 395:	8d 76 00             	lea    0x0(%esi),%esi
 398:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 39b:	83 ec 04             	sub    $0x4,%esp
 39e:	83 ef 01             	sub    $0x1,%edi
 3a1:	6a 01                	push   $0x1
 3a3:	53                   	push   %ebx
 3a4:	56                   	push   %esi
 3a5:	88 45 d7             	mov    %al,-0x29(%ebp)
 3a8:	e8 f5 fe ff ff       	call   2a2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3ad:	83 c4 10             	add    $0x10,%esp
 3b0:	39 df                	cmp    %ebx,%edi
 3b2:	75 e4                	jne    398 <printint+0x68>
    putc(fd, buf[i]);
}
 3b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b7:	5b                   	pop    %ebx
 3b8:	5e                   	pop    %esi
 3b9:	5f                   	pop    %edi
 3ba:	5d                   	pop    %ebp
 3bb:	c3                   	ret    
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c0:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3c9:	eb 8b                	jmp    356 <printint+0x26>
 3cb:	90                   	nop
 3cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003d0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3d6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3d9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3dc:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3df:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3e5:	0f b6 1e             	movzbl (%esi),%ebx
 3e8:	83 c6 01             	add    $0x1,%esi
 3eb:	84 db                	test   %bl,%bl
 3ed:	0f 84 b0 00 00 00    	je     4a3 <printf+0xd3>
 3f3:	31 d2                	xor    %edx,%edx
 3f5:	eb 39                	jmp    430 <printf+0x60>
 3f7:	89 f6                	mov    %esi,%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 400:	83 f8 25             	cmp    $0x25,%eax
 403:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 406:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 40b:	74 18                	je     425 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 40d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 410:	83 ec 04             	sub    $0x4,%esp
 413:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 416:	6a 01                	push   $0x1
 418:	50                   	push   %eax
 419:	57                   	push   %edi
 41a:	e8 83 fe ff ff       	call   2a2 <write>
 41f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 422:	83 c4 10             	add    $0x10,%esp
 425:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 428:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 42c:	84 db                	test   %bl,%bl
 42e:	74 73                	je     4a3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 430:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 432:	0f be cb             	movsbl %bl,%ecx
 435:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 438:	74 c6                	je     400 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 43a:	83 fa 25             	cmp    $0x25,%edx
 43d:	75 e6                	jne    425 <printf+0x55>
      if(c == 'd'){
 43f:	83 f8 64             	cmp    $0x64,%eax
 442:	0f 84 f8 00 00 00    	je     540 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 448:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 44e:	83 f9 70             	cmp    $0x70,%ecx
 451:	74 5d                	je     4b0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 453:	83 f8 73             	cmp    $0x73,%eax
 456:	0f 84 84 00 00 00    	je     4e0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 45c:	83 f8 63             	cmp    $0x63,%eax
 45f:	0f 84 ea 00 00 00    	je     54f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 465:	83 f8 25             	cmp    $0x25,%eax
 468:	0f 84 c2 00 00 00    	je     530 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 46e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 471:	83 ec 04             	sub    $0x4,%esp
 474:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 478:	6a 01                	push   $0x1
 47a:	50                   	push   %eax
 47b:	57                   	push   %edi
 47c:	e8 21 fe ff ff       	call   2a2 <write>
 481:	83 c4 0c             	add    $0xc,%esp
 484:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 487:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 48a:	6a 01                	push   $0x1
 48c:	50                   	push   %eax
 48d:	57                   	push   %edi
 48e:	83 c6 01             	add    $0x1,%esi
 491:	e8 0c fe ff ff       	call   2a2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 496:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 49a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 49d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 49f:	84 db                	test   %bl,%bl
 4a1:	75 8d                	jne    430 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 4a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a6:	5b                   	pop    %ebx
 4a7:	5e                   	pop    %esi
 4a8:	5f                   	pop    %edi
 4a9:	5d                   	pop    %ebp
 4aa:	c3                   	ret    
 4ab:	90                   	nop
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4b0:	83 ec 0c             	sub    $0xc,%esp
 4b3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b8:	6a 00                	push   $0x0
 4ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4bd:	89 f8                	mov    %edi,%eax
 4bf:	8b 13                	mov    (%ebx),%edx
 4c1:	e8 6a fe ff ff       	call   330 <printint>
        ap++;
 4c6:	89 d8                	mov    %ebx,%eax
 4c8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4cb:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 4cd:	83 c0 04             	add    $0x4,%eax
 4d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4d3:	e9 4d ff ff ff       	jmp    425 <printf+0x55>
 4d8:	90                   	nop
 4d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 4e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4e3:	8b 18                	mov    (%eax),%ebx
        ap++;
 4e5:	83 c0 04             	add    $0x4,%eax
 4e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 4eb:	b8 f8 06 00 00       	mov    $0x6f8,%eax
 4f0:	85 db                	test   %ebx,%ebx
 4f2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 4f5:	0f b6 03             	movzbl (%ebx),%eax
 4f8:	84 c0                	test   %al,%al
 4fa:	74 23                	je     51f <printf+0x14f>
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 500:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 503:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 506:	83 ec 04             	sub    $0x4,%esp
 509:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 50b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 50e:	50                   	push   %eax
 50f:	57                   	push   %edi
 510:	e8 8d fd ff ff       	call   2a2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 515:	0f b6 03             	movzbl (%ebx),%eax
 518:	83 c4 10             	add    $0x10,%esp
 51b:	84 c0                	test   %al,%al
 51d:	75 e1                	jne    500 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51f:	31 d2                	xor    %edx,%edx
 521:	e9 ff fe ff ff       	jmp    425 <printf+0x55>
 526:	8d 76 00             	lea    0x0(%esi),%esi
 529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 530:	83 ec 04             	sub    $0x4,%esp
 533:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 536:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 539:	6a 01                	push   $0x1
 53b:	e9 4c ff ff ff       	jmp    48c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 540:	83 ec 0c             	sub    $0xc,%esp
 543:	b9 0a 00 00 00       	mov    $0xa,%ecx
 548:	6a 01                	push   $0x1
 54a:	e9 6b ff ff ff       	jmp    4ba <printf+0xea>
 54f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 552:	83 ec 04             	sub    $0x4,%esp
 555:	8b 03                	mov    (%ebx),%eax
 557:	6a 01                	push   $0x1
 559:	88 45 e4             	mov    %al,-0x1c(%ebp)
 55c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 55f:	50                   	push   %eax
 560:	57                   	push   %edi
 561:	e8 3c fd ff ff       	call   2a2 <write>
 566:	e9 5b ff ff ff       	jmp    4c6 <printf+0xf6>
 56b:	66 90                	xchg   %ax,%ax
 56d:	66 90                	xchg   %ax,%ax
 56f:	90                   	nop

00000570 <free>:
 570:	55                   	push   %ebp
 571:	a1 a4 09 00 00       	mov    0x9a4,%eax
 576:	89 e5                	mov    %esp,%ebp
 578:	57                   	push   %edi
 579:	56                   	push   %esi
 57a:	53                   	push   %ebx
 57b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 57e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 588:	39 c8                	cmp    %ecx,%eax
 58a:	8b 10                	mov    (%eax),%edx
 58c:	73 32                	jae    5c0 <free+0x50>
 58e:	39 d1                	cmp    %edx,%ecx
 590:	72 04                	jb     596 <free+0x26>
 592:	39 d0                	cmp    %edx,%eax
 594:	72 32                	jb     5c8 <free+0x58>
 596:	8b 73 fc             	mov    -0x4(%ebx),%esi
 599:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 59c:	39 fa                	cmp    %edi,%edx
 59e:	74 30                	je     5d0 <free+0x60>
 5a0:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5a3:	8b 50 04             	mov    0x4(%eax),%edx
 5a6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5a9:	39 f1                	cmp    %esi,%ecx
 5ab:	74 3a                	je     5e7 <free+0x77>
 5ad:	89 08                	mov    %ecx,(%eax)
 5af:	a3 a4 09 00 00       	mov    %eax,0x9a4
 5b4:	5b                   	pop    %ebx
 5b5:	5e                   	pop    %esi
 5b6:	5f                   	pop    %edi
 5b7:	5d                   	pop    %ebp
 5b8:	c3                   	ret    
 5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5c0:	39 d0                	cmp    %edx,%eax
 5c2:	72 04                	jb     5c8 <free+0x58>
 5c4:	39 d1                	cmp    %edx,%ecx
 5c6:	72 ce                	jb     596 <free+0x26>
 5c8:	89 d0                	mov    %edx,%eax
 5ca:	eb bc                	jmp    588 <free+0x18>
 5cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5d0:	03 72 04             	add    0x4(%edx),%esi
 5d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
 5d6:	8b 10                	mov    (%eax),%edx
 5d8:	8b 12                	mov    (%edx),%edx
 5da:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5dd:	8b 50 04             	mov    0x4(%eax),%edx
 5e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5e3:	39 f1                	cmp    %esi,%ecx
 5e5:	75 c6                	jne    5ad <free+0x3d>
 5e7:	03 53 fc             	add    -0x4(%ebx),%edx
 5ea:	a3 a4 09 00 00       	mov    %eax,0x9a4
 5ef:	89 50 04             	mov    %edx,0x4(%eax)
 5f2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5f5:	89 10                	mov    %edx,(%eax)
 5f7:	5b                   	pop    %ebx
 5f8:	5e                   	pop    %esi
 5f9:	5f                   	pop    %edi
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret    
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000600 <malloc>:
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
 606:	83 ec 0c             	sub    $0xc,%esp
 609:	8b 45 08             	mov    0x8(%ebp),%eax
 60c:	8b 15 a4 09 00 00    	mov    0x9a4,%edx
 612:	8d 78 07             	lea    0x7(%eax),%edi
 615:	c1 ef 03             	shr    $0x3,%edi
 618:	83 c7 01             	add    $0x1,%edi
 61b:	85 d2                	test   %edx,%edx
 61d:	0f 84 9d 00 00 00    	je     6c0 <malloc+0xc0>
 623:	8b 02                	mov    (%edx),%eax
 625:	8b 48 04             	mov    0x4(%eax),%ecx
 628:	39 cf                	cmp    %ecx,%edi
 62a:	76 6c                	jbe    698 <malloc+0x98>
 62c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 632:	bb 00 10 00 00       	mov    $0x1000,%ebx
 637:	0f 43 df             	cmovae %edi,%ebx
 63a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 641:	eb 0e                	jmp    651 <malloc+0x51>
 643:	90                   	nop
 644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 648:	8b 02                	mov    (%edx),%eax
 64a:	8b 48 04             	mov    0x4(%eax),%ecx
 64d:	39 f9                	cmp    %edi,%ecx
 64f:	73 47                	jae    698 <malloc+0x98>
 651:	39 05 a4 09 00 00    	cmp    %eax,0x9a4
 657:	89 c2                	mov    %eax,%edx
 659:	75 ed                	jne    648 <malloc+0x48>
 65b:	83 ec 0c             	sub    $0xc,%esp
 65e:	56                   	push   %esi
 65f:	e8 a6 fc ff ff       	call   30a <sbrk>
 664:	83 c4 10             	add    $0x10,%esp
 667:	83 f8 ff             	cmp    $0xffffffff,%eax
 66a:	74 1c                	je     688 <malloc+0x88>
 66c:	89 58 04             	mov    %ebx,0x4(%eax)
 66f:	83 ec 0c             	sub    $0xc,%esp
 672:	83 c0 08             	add    $0x8,%eax
 675:	50                   	push   %eax
 676:	e8 f5 fe ff ff       	call   570 <free>
 67b:	8b 15 a4 09 00 00    	mov    0x9a4,%edx
 681:	83 c4 10             	add    $0x10,%esp
 684:	85 d2                	test   %edx,%edx
 686:	75 c0                	jne    648 <malloc+0x48>
 688:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68b:	31 c0                	xor    %eax,%eax
 68d:	5b                   	pop    %ebx
 68e:	5e                   	pop    %esi
 68f:	5f                   	pop    %edi
 690:	5d                   	pop    %ebp
 691:	c3                   	ret    
 692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 698:	39 cf                	cmp    %ecx,%edi
 69a:	74 54                	je     6f0 <malloc+0xf0>
 69c:	29 f9                	sub    %edi,%ecx
 69e:	89 48 04             	mov    %ecx,0x4(%eax)
 6a1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
 6a4:	89 78 04             	mov    %edi,0x4(%eax)
 6a7:	89 15 a4 09 00 00    	mov    %edx,0x9a4
 6ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6b0:	83 c0 08             	add    $0x8,%eax
 6b3:	5b                   	pop    %ebx
 6b4:	5e                   	pop    %esi
 6b5:	5f                   	pop    %edi
 6b6:	5d                   	pop    %ebp
 6b7:	c3                   	ret    
 6b8:	90                   	nop
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6c0:	c7 05 a4 09 00 00 a8 	movl   $0x9a8,0x9a4
 6c7:	09 00 00 
 6ca:	c7 05 a8 09 00 00 a8 	movl   $0x9a8,0x9a8
 6d1:	09 00 00 
 6d4:	b8 a8 09 00 00       	mov    $0x9a8,%eax
 6d9:	c7 05 ac 09 00 00 00 	movl   $0x0,0x9ac
 6e0:	00 00 00 
 6e3:	e9 44 ff ff ff       	jmp    62c <malloc+0x2c>
 6e8:	90                   	nop
 6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6f0:	8b 08                	mov    (%eax),%ecx
 6f2:	89 0a                	mov    %ecx,(%edx)
 6f4:	eb b1                	jmp    6a7 <malloc+0xa7>
