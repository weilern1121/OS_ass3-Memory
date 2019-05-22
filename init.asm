
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 d0 08 00 00       	push   $0x8d0
  19:	e8 64 03 00 00       	call   382 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 9f 00 00 00    	js     c8 <main+0xc8>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 87 03 00 00       	call   3ba <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 7b 03 00 00       	call   3ba <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(;;){
    printf(1, "init: starting sh\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 d8 08 00 00       	push   $0x8d8
  50:	6a 01                	push   $0x1
  52:	e8 39 04 00 00       	call   490 <printf>
    pid = fork();
  57:	e8 de 02 00 00       	call   33a <fork>
    if(pid < 0){
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	85 c0                	test   %eax,%eax
    pid = fork();
  61:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  63:	78 2c                	js     91 <main+0x91>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  65:	74 3d                	je     a4 <main+0xa4>
  67:	89 f6                	mov    %esi,%esi
  69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  70:	e8 d5 02 00 00       	call   34a <wait>
  75:	85 c0                	test   %eax,%eax
  77:	78 cf                	js     48 <main+0x48>
  79:	39 c3                	cmp    %eax,%ebx
  7b:	74 cb                	je     48 <main+0x48>
      printf(1, "zombie!\n");
  7d:	83 ec 08             	sub    $0x8,%esp
  80:	68 17 09 00 00       	push   $0x917
  85:	6a 01                	push   $0x1
  87:	e8 04 04 00 00       	call   490 <printf>
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	eb df                	jmp    70 <main+0x70>
      printf(1, "init: fork failed\n");
  91:	53                   	push   %ebx
  92:	53                   	push   %ebx
  93:	68 eb 08 00 00       	push   $0x8eb
  98:	6a 01                	push   $0x1
  9a:	e8 f1 03 00 00       	call   490 <printf>
      exit();
  9f:	e8 9e 02 00 00       	call   342 <exit>
      exec("sh", argv);
  a4:	50                   	push   %eax
  a5:	50                   	push   %eax
  a6:	68 64 0c 00 00       	push   $0xc64
  ab:	68 fe 08 00 00       	push   $0x8fe
  b0:	e8 c5 02 00 00       	call   37a <exec>
      printf(1, "init: exec sh failed\n");
  b5:	5a                   	pop    %edx
  b6:	59                   	pop    %ecx
  b7:	68 01 09 00 00       	push   $0x901
  bc:	6a 01                	push   $0x1
  be:	e8 cd 03 00 00       	call   490 <printf>
      exit();
  c3:	e8 7a 02 00 00       	call   342 <exit>
    mknod("console", 1, 1);
  c8:	50                   	push   %eax
  c9:	6a 01                	push   $0x1
  cb:	6a 01                	push   $0x1
  cd:	68 d0 08 00 00       	push   $0x8d0
  d2:	e8 b3 02 00 00       	call   38a <mknod>
    open("console", O_RDWR);
  d7:	58                   	pop    %eax
  d8:	5a                   	pop    %edx
  d9:	6a 02                	push   $0x2
  db:	68 d0 08 00 00       	push   $0x8d0
  e0:	e8 9d 02 00 00       	call   382 <open>
  e5:	83 c4 10             	add    $0x10,%esp
  e8:	e9 3c ff ff ff       	jmp    29 <main+0x29>
  ed:	66 90                	xchg   %ax,%ax
  ef:	90                   	nop

000000f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	53                   	push   %ebx
  f4:	8b 45 08             	mov    0x8(%ebp),%eax
  f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fa:	89 c2                	mov    %eax,%edx
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 100:	83 c1 01             	add    $0x1,%ecx
 103:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 107:	83 c2 01             	add    $0x1,%edx
 10a:	84 db                	test   %bl,%bl
 10c:	88 5a ff             	mov    %bl,-0x1(%edx)
 10f:	75 ef                	jne    100 <strcpy+0x10>
    ;
  return os;
}
 111:	5b                   	pop    %ebx
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    
 114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 11a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	8b 55 08             	mov    0x8(%ebp),%edx
 127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 12a:	0f b6 02             	movzbl (%edx),%eax
 12d:	0f b6 19             	movzbl (%ecx),%ebx
 130:	84 c0                	test   %al,%al
 132:	75 1c                	jne    150 <strcmp+0x30>
 134:	eb 2a                	jmp    160 <strcmp+0x40>
 136:	8d 76 00             	lea    0x0(%esi),%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 140:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 143:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 146:	83 c1 01             	add    $0x1,%ecx
 149:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 14c:	84 c0                	test   %al,%al
 14e:	74 10                	je     160 <strcmp+0x40>
 150:	38 d8                	cmp    %bl,%al
 152:	74 ec                	je     140 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 154:	29 d8                	sub    %ebx,%eax
}
 156:	5b                   	pop    %ebx
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 160:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 162:	29 d8                	sub    %ebx,%eax
}
 164:	5b                   	pop    %ebx
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    
 167:	89 f6                	mov    %esi,%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <strlen>:

uint
strlen(char *s)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 176:	80 39 00             	cmpb   $0x0,(%ecx)
 179:	74 15                	je     190 <strlen+0x20>
 17b:	31 d2                	xor    %edx,%edx
 17d:	8d 76 00             	lea    0x0(%esi),%esi
 180:	83 c2 01             	add    $0x1,%edx
 183:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 187:	89 d0                	mov    %edx,%eax
 189:	75 f5                	jne    180 <strlen+0x10>
    ;
  return n;
}
 18b:	5d                   	pop    %ebp
 18c:	c3                   	ret    
 18d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 190:	31 c0                	xor    %eax,%eax
}
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    
 194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 19a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	89 d7                	mov    %edx,%edi
 1af:	fc                   	cld    
 1b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1b2:	89 d0                	mov    %edx,%eax
 1b4:	5f                   	pop    %edi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	89 f6                	mov    %esi,%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1ca:	0f b6 10             	movzbl (%eax),%edx
 1cd:	84 d2                	test   %dl,%dl
 1cf:	74 1d                	je     1ee <strchr+0x2e>
    if(*s == c)
 1d1:	38 d3                	cmp    %dl,%bl
 1d3:	89 d9                	mov    %ebx,%ecx
 1d5:	75 0d                	jne    1e4 <strchr+0x24>
 1d7:	eb 17                	jmp    1f0 <strchr+0x30>
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1e0:	38 ca                	cmp    %cl,%dl
 1e2:	74 0c                	je     1f0 <strchr+0x30>
  for(; *s; s++)
 1e4:	83 c0 01             	add    $0x1,%eax
 1e7:	0f b6 10             	movzbl (%eax),%edx
 1ea:	84 d2                	test   %dl,%dl
 1ec:	75 f2                	jne    1e0 <strchr+0x20>
      return (char*)s;
  return 0;
 1ee:	31 c0                	xor    %eax,%eax
}
 1f0:	5b                   	pop    %ebx
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    
 1f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
 205:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 206:	31 f6                	xor    %esi,%esi
 208:	89 f3                	mov    %esi,%ebx
{
 20a:	83 ec 1c             	sub    $0x1c,%esp
 20d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 210:	eb 2f                	jmp    241 <gets+0x41>
 212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 218:	8d 45 e7             	lea    -0x19(%ebp),%eax
 21b:	83 ec 04             	sub    $0x4,%esp
 21e:	6a 01                	push   $0x1
 220:	50                   	push   %eax
 221:	6a 00                	push   $0x0
 223:	e8 32 01 00 00       	call   35a <read>
    if(cc < 1)
 228:	83 c4 10             	add    $0x10,%esp
 22b:	85 c0                	test   %eax,%eax
 22d:	7e 1c                	jle    24b <gets+0x4b>
      break;
    buf[i++] = c;
 22f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 233:	83 c7 01             	add    $0x1,%edi
 236:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 239:	3c 0a                	cmp    $0xa,%al
 23b:	74 23                	je     260 <gets+0x60>
 23d:	3c 0d                	cmp    $0xd,%al
 23f:	74 1f                	je     260 <gets+0x60>
  for(i=0; i+1 < max; ){
 241:	83 c3 01             	add    $0x1,%ebx
 244:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 247:	89 fe                	mov    %edi,%esi
 249:	7c cd                	jl     218 <gets+0x18>
 24b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 250:	c6 03 00             	movb   $0x0,(%ebx)
}
 253:	8d 65 f4             	lea    -0xc(%ebp),%esp
 256:	5b                   	pop    %ebx
 257:	5e                   	pop    %esi
 258:	5f                   	pop    %edi
 259:	5d                   	pop    %ebp
 25a:	c3                   	ret    
 25b:	90                   	nop
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 260:	8b 75 08             	mov    0x8(%ebp),%esi
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	01 de                	add    %ebx,%esi
 268:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 26a:	c6 03 00             	movb   $0x0,(%ebx)
}
 26d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 270:	5b                   	pop    %ebx
 271:	5e                   	pop    %esi
 272:	5f                   	pop    %edi
 273:	5d                   	pop    %ebp
 274:	c3                   	ret    
 275:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <stat>:

int
stat(char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 285:	83 ec 08             	sub    $0x8,%esp
 288:	6a 00                	push   $0x0
 28a:	ff 75 08             	pushl  0x8(%ebp)
 28d:	e8 f0 00 00 00       	call   382 <open>
  if(fd < 0)
 292:	83 c4 10             	add    $0x10,%esp
 295:	85 c0                	test   %eax,%eax
 297:	78 27                	js     2c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 299:	83 ec 08             	sub    $0x8,%esp
 29c:	ff 75 0c             	pushl  0xc(%ebp)
 29f:	89 c3                	mov    %eax,%ebx
 2a1:	50                   	push   %eax
 2a2:	e8 f3 00 00 00       	call   39a <fstat>
  close(fd);
 2a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2aa:	89 c6                	mov    %eax,%esi
  close(fd);
 2ac:	e8 b9 00 00 00       	call   36a <close>
  return r;
 2b1:	83 c4 10             	add    $0x10,%esp
}
 2b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b7:	89 f0                	mov    %esi,%eax
 2b9:	5b                   	pop    %ebx
 2ba:	5e                   	pop    %esi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2c5:	eb ed                	jmp    2b4 <stat+0x34>
 2c7:	89 f6                	mov    %esi,%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d7:	0f be 11             	movsbl (%ecx),%edx
 2da:	8d 42 d0             	lea    -0x30(%edx),%eax
 2dd:	3c 09                	cmp    $0x9,%al
  n = 0;
 2df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2e4:	77 1f                	ja     305 <atoi+0x35>
 2e6:	8d 76 00             	lea    0x0(%esi),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2f3:	83 c1 01             	add    $0x1,%ecx
 2f6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2fa:	0f be 11             	movsbl (%ecx),%edx
 2fd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 300:	80 fb 09             	cmp    $0x9,%bl
 303:	76 eb                	jbe    2f0 <atoi+0x20>
  return n;
}
 305:	5b                   	pop    %ebx
 306:	5d                   	pop    %ebp
 307:	c3                   	ret    
 308:	90                   	nop
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000310 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	56                   	push   %esi
 314:	53                   	push   %ebx
 315:	8b 5d 10             	mov    0x10(%ebp),%ebx
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31e:	85 db                	test   %ebx,%ebx
 320:	7e 14                	jle    336 <memmove+0x26>
 322:	31 d2                	xor    %edx,%edx
 324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 328:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 32c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 32f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 332:	39 d3                	cmp    %edx,%ebx
 334:	75 f2                	jne    328 <memmove+0x18>
  return vdst;
}
 336:	5b                   	pop    %ebx
 337:	5e                   	pop    %esi
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    

0000033a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33a:	b8 01 00 00 00       	mov    $0x1,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <exit>:
SYSCALL(exit)
 342:	b8 02 00 00 00       	mov    $0x2,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <wait>:
SYSCALL(wait)
 34a:	b8 03 00 00 00       	mov    $0x3,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <pipe>:
SYSCALL(pipe)
 352:	b8 04 00 00 00       	mov    $0x4,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <read>:
SYSCALL(read)
 35a:	b8 05 00 00 00       	mov    $0x5,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <write>:
SYSCALL(write)
 362:	b8 10 00 00 00       	mov    $0x10,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <close>:
SYSCALL(close)
 36a:	b8 15 00 00 00       	mov    $0x15,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <kill>:
SYSCALL(kill)
 372:	b8 06 00 00 00       	mov    $0x6,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <exec>:
SYSCALL(exec)
 37a:	b8 07 00 00 00       	mov    $0x7,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <open>:
SYSCALL(open)
 382:	b8 0f 00 00 00       	mov    $0xf,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <mknod>:
SYSCALL(mknod)
 38a:	b8 11 00 00 00       	mov    $0x11,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <unlink>:
SYSCALL(unlink)
 392:	b8 12 00 00 00       	mov    $0x12,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <fstat>:
SYSCALL(fstat)
 39a:	b8 08 00 00 00       	mov    $0x8,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <link>:
SYSCALL(link)
 3a2:	b8 13 00 00 00       	mov    $0x13,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <mkdir>:
SYSCALL(mkdir)
 3aa:	b8 14 00 00 00       	mov    $0x14,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <chdir>:
SYSCALL(chdir)
 3b2:	b8 09 00 00 00       	mov    $0x9,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <dup>:
SYSCALL(dup)
 3ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <getpid>:
SYSCALL(getpid)
 3c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <sbrk>:
SYSCALL(sbrk)
 3ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <sleep>:
SYSCALL(sleep)
 3d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <uptime>:
SYSCALL(uptime)
 3da:	b8 0e 00 00 00       	mov    $0xe,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    
 3e2:	66 90                	xchg   %ax,%ax
 3e4:	66 90                	xchg   %ax,%ax
 3e6:	66 90                	xchg   %ax,%ax
 3e8:	66 90                	xchg   %ax,%ax
 3ea:	66 90                	xchg   %ax,%ax
 3ec:	66 90                	xchg   %ax,%ax
 3ee:	66 90                	xchg   %ax,%ax

000003f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f9:	85 d2                	test   %edx,%edx
{
 3fb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 3fe:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 400:	79 76                	jns    478 <printint+0x88>
 402:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 406:	74 70                	je     478 <printint+0x88>
    x = -xx;
 408:	f7 d8                	neg    %eax
    neg = 1;
 40a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 411:	31 f6                	xor    %esi,%esi
 413:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 416:	eb 0a                	jmp    422 <printint+0x32>
 418:	90                   	nop
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 420:	89 fe                	mov    %edi,%esi
 422:	31 d2                	xor    %edx,%edx
 424:	8d 7e 01             	lea    0x1(%esi),%edi
 427:	f7 f1                	div    %ecx
 429:	0f b6 92 28 09 00 00 	movzbl 0x928(%edx),%edx
  }while((x /= base) != 0);
 430:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 432:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 435:	75 e9                	jne    420 <printint+0x30>
  if(neg)
 437:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 43a:	85 c0                	test   %eax,%eax
 43c:	74 08                	je     446 <printint+0x56>
    buf[i++] = '-';
 43e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 443:	8d 7e 02             	lea    0x2(%esi),%edi
 446:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 44a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 44d:	8d 76 00             	lea    0x0(%esi),%esi
 450:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 453:	83 ec 04             	sub    $0x4,%esp
 456:	83 ee 01             	sub    $0x1,%esi
 459:	6a 01                	push   $0x1
 45b:	53                   	push   %ebx
 45c:	57                   	push   %edi
 45d:	88 45 d7             	mov    %al,-0x29(%ebp)
 460:	e8 fd fe ff ff       	call   362 <write>

  while(--i >= 0)
 465:	83 c4 10             	add    $0x10,%esp
 468:	39 de                	cmp    %ebx,%esi
 46a:	75 e4                	jne    450 <printint+0x60>
    putc(fd, buf[i]);
}
 46c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 46f:	5b                   	pop    %ebx
 470:	5e                   	pop    %esi
 471:	5f                   	pop    %edi
 472:	5d                   	pop    %ebp
 473:	c3                   	ret    
 474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 478:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 47f:	eb 90                	jmp    411 <printint+0x21>
 481:	eb 0d                	jmp    490 <printf>
 483:	90                   	nop
 484:	90                   	nop
 485:	90                   	nop
 486:	90                   	nop
 487:	90                   	nop
 488:	90                   	nop
 489:	90                   	nop
 48a:	90                   	nop
 48b:	90                   	nop
 48c:	90                   	nop
 48d:	90                   	nop
 48e:	90                   	nop
 48f:	90                   	nop

00000490 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
 496:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 499:	8b 75 0c             	mov    0xc(%ebp),%esi
 49c:	0f b6 1e             	movzbl (%esi),%ebx
 49f:	84 db                	test   %bl,%bl
 4a1:	0f 84 b3 00 00 00    	je     55a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 4a7:	8d 45 10             	lea    0x10(%ebp),%eax
 4aa:	83 c6 01             	add    $0x1,%esi
  state = 0;
 4ad:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 4af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4b2:	eb 2f                	jmp    4e3 <printf+0x53>
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4b8:	83 f8 25             	cmp    $0x25,%eax
 4bb:	0f 84 a7 00 00 00    	je     568 <printf+0xd8>
  write(fd, &c, 1);
 4c1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4c4:	83 ec 04             	sub    $0x4,%esp
 4c7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4ca:	6a 01                	push   $0x1
 4cc:	50                   	push   %eax
 4cd:	ff 75 08             	pushl  0x8(%ebp)
 4d0:	e8 8d fe ff ff       	call   362 <write>
 4d5:	83 c4 10             	add    $0x10,%esp
 4d8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4db:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4df:	84 db                	test   %bl,%bl
 4e1:	74 77                	je     55a <printf+0xca>
    if(state == 0){
 4e3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 4e5:	0f be cb             	movsbl %bl,%ecx
 4e8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4eb:	74 cb                	je     4b8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ed:	83 ff 25             	cmp    $0x25,%edi
 4f0:	75 e6                	jne    4d8 <printf+0x48>
      if(c == 'd'){
 4f2:	83 f8 64             	cmp    $0x64,%eax
 4f5:	0f 84 05 01 00 00    	je     600 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4fb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 501:	83 f9 70             	cmp    $0x70,%ecx
 504:	74 72                	je     578 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 506:	83 f8 73             	cmp    $0x73,%eax
 509:	0f 84 99 00 00 00    	je     5a8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 50f:	83 f8 63             	cmp    $0x63,%eax
 512:	0f 84 08 01 00 00    	je     620 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 518:	83 f8 25             	cmp    $0x25,%eax
 51b:	0f 84 ef 00 00 00    	je     610 <printf+0x180>
  write(fd, &c, 1);
 521:	8d 45 e7             	lea    -0x19(%ebp),%eax
 524:	83 ec 04             	sub    $0x4,%esp
 527:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 52b:	6a 01                	push   $0x1
 52d:	50                   	push   %eax
 52e:	ff 75 08             	pushl  0x8(%ebp)
 531:	e8 2c fe ff ff       	call   362 <write>
 536:	83 c4 0c             	add    $0xc,%esp
 539:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 53c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 53f:	6a 01                	push   $0x1
 541:	50                   	push   %eax
 542:	ff 75 08             	pushl  0x8(%ebp)
 545:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 548:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 54a:	e8 13 fe ff ff       	call   362 <write>
  for(i = 0; fmt[i]; i++){
 54f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 553:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 556:	84 db                	test   %bl,%bl
 558:	75 89                	jne    4e3 <printf+0x53>
    }
  }
}
 55a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55d:	5b                   	pop    %ebx
 55e:	5e                   	pop    %esi
 55f:	5f                   	pop    %edi
 560:	5d                   	pop    %ebp
 561:	c3                   	ret    
 562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 568:	bf 25 00 00 00       	mov    $0x25,%edi
 56d:	e9 66 ff ff ff       	jmp    4d8 <printf+0x48>
 572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 578:	83 ec 0c             	sub    $0xc,%esp
 57b:	b9 10 00 00 00       	mov    $0x10,%ecx
 580:	6a 00                	push   $0x0
 582:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 585:	8b 45 08             	mov    0x8(%ebp),%eax
 588:	8b 17                	mov    (%edi),%edx
 58a:	e8 61 fe ff ff       	call   3f0 <printint>
        ap++;
 58f:	89 f8                	mov    %edi,%eax
 591:	83 c4 10             	add    $0x10,%esp
      state = 0;
 594:	31 ff                	xor    %edi,%edi
        ap++;
 596:	83 c0 04             	add    $0x4,%eax
 599:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 59c:	e9 37 ff ff ff       	jmp    4d8 <printf+0x48>
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5ab:	8b 08                	mov    (%eax),%ecx
        ap++;
 5ad:	83 c0 04             	add    $0x4,%eax
 5b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 5b3:	85 c9                	test   %ecx,%ecx
 5b5:	0f 84 8e 00 00 00    	je     649 <printf+0x1b9>
        while(*s != 0){
 5bb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 5be:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 5c0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 5c2:	84 c0                	test   %al,%al
 5c4:	0f 84 0e ff ff ff    	je     4d8 <printf+0x48>
 5ca:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5cd:	89 de                	mov    %ebx,%esi
 5cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5d2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5d5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5d8:	83 ec 04             	sub    $0x4,%esp
          s++;
 5db:	83 c6 01             	add    $0x1,%esi
 5de:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 5e1:	6a 01                	push   $0x1
 5e3:	57                   	push   %edi
 5e4:	53                   	push   %ebx
 5e5:	e8 78 fd ff ff       	call   362 <write>
        while(*s != 0){
 5ea:	0f b6 06             	movzbl (%esi),%eax
 5ed:	83 c4 10             	add    $0x10,%esp
 5f0:	84 c0                	test   %al,%al
 5f2:	75 e4                	jne    5d8 <printf+0x148>
 5f4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5f7:	31 ff                	xor    %edi,%edi
 5f9:	e9 da fe ff ff       	jmp    4d8 <printf+0x48>
 5fe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	b9 0a 00 00 00       	mov    $0xa,%ecx
 608:	6a 01                	push   $0x1
 60a:	e9 73 ff ff ff       	jmp    582 <printf+0xf2>
 60f:	90                   	nop
  write(fd, &c, 1);
 610:	83 ec 04             	sub    $0x4,%esp
 613:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 616:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 619:	6a 01                	push   $0x1
 61b:	e9 21 ff ff ff       	jmp    541 <printf+0xb1>
        putc(fd, *ap);
 620:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 623:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 626:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 628:	6a 01                	push   $0x1
        ap++;
 62a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 62d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 630:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 633:	50                   	push   %eax
 634:	ff 75 08             	pushl  0x8(%ebp)
 637:	e8 26 fd ff ff       	call   362 <write>
        ap++;
 63c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 63f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 642:	31 ff                	xor    %edi,%edi
 644:	e9 8f fe ff ff       	jmp    4d8 <printf+0x48>
          s = "(null)";
 649:	bb 20 09 00 00       	mov    $0x920,%ebx
        while(*s != 0){
 64e:	b8 28 00 00 00       	mov    $0x28,%eax
 653:	e9 72 ff ff ff       	jmp    5ca <printf+0x13a>
 658:	66 90                	xchg   %ax,%ax
 65a:	66 90                	xchg   %ax,%ax
 65c:	66 90                	xchg   %ax,%ax
 65e:	66 90                	xchg   %ax,%ax

00000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	a1 6c 0c 00 00       	mov    0xc6c,%eax
{
 666:	89 e5                	mov    %esp,%ebp
 668:	57                   	push   %edi
 669:	56                   	push   %esi
 66a:	53                   	push   %ebx
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 66e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 678:	39 c8                	cmp    %ecx,%eax
 67a:	8b 10                	mov    (%eax),%edx
 67c:	73 32                	jae    6b0 <free+0x50>
 67e:	39 d1                	cmp    %edx,%ecx
 680:	72 04                	jb     686 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 682:	39 d0                	cmp    %edx,%eax
 684:	72 32                	jb     6b8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 686:	8b 73 fc             	mov    -0x4(%ebx),%esi
 689:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 68c:	39 fa                	cmp    %edi,%edx
 68e:	74 30                	je     6c0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 690:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 693:	8b 50 04             	mov    0x4(%eax),%edx
 696:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 699:	39 f1                	cmp    %esi,%ecx
 69b:	74 3a                	je     6d7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 69d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 69f:	a3 6c 0c 00 00       	mov    %eax,0xc6c
}
 6a4:	5b                   	pop    %ebx
 6a5:	5e                   	pop    %esi
 6a6:	5f                   	pop    %edi
 6a7:	5d                   	pop    %ebp
 6a8:	c3                   	ret    
 6a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b0:	39 d0                	cmp    %edx,%eax
 6b2:	72 04                	jb     6b8 <free+0x58>
 6b4:	39 d1                	cmp    %edx,%ecx
 6b6:	72 ce                	jb     686 <free+0x26>
{
 6b8:	89 d0                	mov    %edx,%eax
 6ba:	eb bc                	jmp    678 <free+0x18>
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 6c0:	03 72 04             	add    0x4(%edx),%esi
 6c3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c6:	8b 10                	mov    (%eax),%edx
 6c8:	8b 12                	mov    (%edx),%edx
 6ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6cd:	8b 50 04             	mov    0x4(%eax),%edx
 6d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6d3:	39 f1                	cmp    %esi,%ecx
 6d5:	75 c6                	jne    69d <free+0x3d>
    p->s.size += bp->s.size;
 6d7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6da:	a3 6c 0c 00 00       	mov    %eax,0xc6c
    p->s.size += bp->s.size;
 6df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6e5:	89 10                	mov    %edx,(%eax)
}
 6e7:	5b                   	pop    %ebx
 6e8:	5e                   	pop    %esi
 6e9:	5f                   	pop    %edi
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret    
 6ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006f0 <morecore>:

static Header*
morecore(uint nu)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	53                   	push   %ebx
 6f4:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6f9:	83 ec 10             	sub    $0x10,%esp
 6fc:	3d 00 10 00 00       	cmp    $0x1000,%eax
 701:	0f 43 d8             	cmovae %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 704:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 70b:	50                   	push   %eax
 70c:	e8 b9 fc ff ff       	call   3ca <sbrk>
  if(p == (char*)-1)
 711:	83 c4 10             	add    $0x10,%esp
 714:	83 f8 ff             	cmp    $0xffffffff,%eax
 717:	74 1f                	je     738 <morecore+0x48>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 719:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 71c:	83 ec 0c             	sub    $0xc,%esp
 71f:	83 c0 08             	add    $0x8,%eax
 722:	50                   	push   %eax
 723:	e8 38 ff ff ff       	call   660 <free>
  return freep;
 728:	a1 6c 0c 00 00       	mov    0xc6c,%eax
 72d:	83 c4 10             	add    $0x10,%esp
}
 730:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 733:	c9                   	leave  
 734:	c3                   	ret    
 735:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
 738:	31 c0                	xor    %eax,%eax
 73a:	eb f4                	jmp    730 <morecore+0x40>
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000740 <malloc>:

void*
malloc(uint nbytes)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	53                   	push   %ebx
 744:	83 ec 04             	sub    $0x4,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 747:	8b 45 08             	mov    0x8(%ebp),%eax
 74a:	8d 58 07             	lea    0x7(%eax),%ebx
    if((prevp = freep) == 0){
 74d:	a1 6c 0c 00 00       	mov    0xc6c,%eax
    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 752:	c1 eb 03             	shr    $0x3,%ebx
 755:	83 c3 01             	add    $0x1,%ebx
    if((prevp = freep) == 0){
 758:	85 c0                	test   %eax,%eax
 75a:	74 54                	je     7b0 <malloc+0x70>
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 760:	8b 10                	mov    (%eax),%edx
        if(p->s.size >= nunits){
 762:	8b 4a 04             	mov    0x4(%edx),%ecx
 765:	39 d9                	cmp    %ebx,%ecx
 767:	73 27                	jae    790 <malloc+0x50>
                p->s.size = nunits;
            }
            freep = prevp;
            return (void*)(p + 1);
        }
        if(p == freep)
 769:	39 15 6c 0c 00 00    	cmp    %edx,0xc6c
 76f:	89 d0                	mov    %edx,%eax
 771:	75 ed                	jne    760 <malloc+0x20>
            if((p = morecore(nunits)) == 0)
 773:	89 d8                	mov    %ebx,%eax
 775:	e8 76 ff ff ff       	call   6f0 <morecore>
 77a:	85 c0                	test   %eax,%eax
 77c:	75 e2                	jne    760 <malloc+0x20>
                return 0;
    }
}
 77e:	83 c4 04             	add    $0x4,%esp
                return 0;
 781:	31 c0                	xor    %eax,%eax
}
 783:	5b                   	pop    %ebx
 784:	5d                   	pop    %ebp
 785:	c3                   	ret    
 786:	8d 76 00             	lea    0x0(%esi),%esi
 789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if(p->s.size == nunits)
 790:	39 cb                	cmp    %ecx,%ebx
 792:	74 44                	je     7d8 <malloc+0x98>
                p->s.size -= nunits;
 794:	29 d9                	sub    %ebx,%ecx
 796:	89 4a 04             	mov    %ecx,0x4(%edx)
                p += p->s.size;
 799:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
                p->s.size = nunits;
 79c:	89 5a 04             	mov    %ebx,0x4(%edx)
            freep = prevp;
 79f:	a3 6c 0c 00 00       	mov    %eax,0xc6c
}
 7a4:	83 c4 04             	add    $0x4,%esp
            return (void*)(p + 1);
 7a7:	8d 42 08             	lea    0x8(%edx),%eax
}
 7aa:	5b                   	pop    %ebx
 7ab:	5d                   	pop    %ebp
 7ac:	c3                   	ret    
 7ad:	8d 76 00             	lea    0x0(%esi),%esi
        base.s.ptr = freep = prevp = &base;
 7b0:	c7 05 6c 0c 00 00 70 	movl   $0xc70,0xc6c
 7b7:	0c 00 00 
 7ba:	c7 05 70 0c 00 00 70 	movl   $0xc70,0xc70
 7c1:	0c 00 00 
        base.s.size = 0;
 7c4:	ba 70 0c 00 00       	mov    $0xc70,%edx
 7c9:	c7 05 74 0c 00 00 00 	movl   $0x0,0xc74
 7d0:	00 00 00 
 7d3:	eb 94                	jmp    769 <malloc+0x29>
 7d5:	8d 76 00             	lea    0x0(%esi),%esi
                prevp->s.ptr = p->s.ptr;
 7d8:	8b 0a                	mov    (%edx),%ecx
 7da:	89 08                	mov    %ecx,(%eax)
 7dc:	eb c1                	jmp    79f <malloc+0x5f>
 7de:	66 90                	xchg   %ax,%ax

000007e0 <pmalloc>:

// TODO we are not sure where we should do the page protected and read only PTE_W...

void*
pmalloc()
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	83 ec 08             	sub    $0x8,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = ( 4096 + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
 7e6:	8b 0d 6c 0c 00 00    	mov    0xc6c,%ecx
 7ec:	85 c9                	test   %ecx,%ecx
 7ee:	74 58                	je     848 <pmalloc+0x68>
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f0:	8b 01                	mov    (%ecx),%eax
        if(p->s.size == nunits){
 7f2:	81 78 04 01 02 00 00 	cmpl   $0x201,0x4(%eax)
 7f9:	75 18                	jne    813 <pmalloc+0x33>
 7fb:	eb 2c                	jmp    829 <pmalloc+0x49>
 7fd:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 800:	8b 10                	mov    (%eax),%edx
        if(p->s.size == nunits){
 802:	81 7a 04 01 02 00 00 	cmpl   $0x201,0x4(%edx)
 809:	74 22                	je     82d <pmalloc+0x4d>
 80b:	8b 0d 6c 0c 00 00    	mov    0xc6c,%ecx
 811:	89 d0                	mov    %edx,%eax
            freep = prevp;
            (p+1)->x = 1;
            return (void*)(p + 1);
        }

        if(p == freep)
 813:	39 c1                	cmp    %eax,%ecx
 815:	75 e9                	jne    800 <pmalloc+0x20>
            if((p = morecore(nunits)) == 0)
 817:	b8 01 02 00 00       	mov    $0x201,%eax
 81c:	e8 cf fe ff ff       	call   6f0 <morecore>
 821:	85 c0                	test   %eax,%eax
 823:	75 db                	jne    800 <pmalloc+0x20>
                return 0;
 825:	31 c0                	xor    %eax,%eax
    }
}
 827:	c9                   	leave  
 828:	c3                   	ret    
        if(p->s.size == nunits){
 829:	89 c2                	mov    %eax,%edx
 82b:	89 c8                	mov    %ecx,%eax
            prevp->s.ptr = p->s.ptr;
 82d:	8b 0a                	mov    (%edx),%ecx
            freep = prevp;
 82f:	a3 6c 0c 00 00       	mov    %eax,0xc6c
            prevp->s.ptr = p->s.ptr;
 834:	89 08                	mov    %ecx,(%eax)
            (p+1)->x = 1;
 836:	c7 42 08 01 00 00 00 	movl   $0x1,0x8(%edx)
            return (void*)(p + 1);
 83d:	8d 42 08             	lea    0x8(%edx),%eax
}
 840:	c9                   	leave  
 841:	c3                   	ret    
 842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        base.s.size = 0;
 848:	b9 70 0c 00 00       	mov    $0xc70,%ecx
        base.s.ptr = freep = prevp = &base;
 84d:	c7 05 6c 0c 00 00 70 	movl   $0xc70,0xc6c
 854:	0c 00 00 
 857:	c7 05 70 0c 00 00 70 	movl   $0xc70,0xc70
 85e:	0c 00 00 
        base.s.size = 0;
 861:	c7 05 74 0c 00 00 00 	movl   $0x0,0xc74
 868:	00 00 00 
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86b:	89 c8                	mov    %ecx,%eax
 86d:	eb a4                	jmp    813 <pmalloc+0x33>
 86f:	90                   	nop

00000870 <protect_page>:


int protect_page(void* ap)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	8b 45 08             	mov    0x8(%ebp),%eax
    Header *p;
    if( ap )
 876:	85 c0                	test   %eax,%eax
 878:	74 1e                	je     898 <protect_page+0x28>
    {
        if( (uint)ap % 4096 != 0 )
 87a:	a9 ff 0f 00 00       	test   $0xfff,%eax
 87f:	75 17                	jne    898 <protect_page+0x28>
            return -1;

        p = ap;
        if( !p->pmalloced )
 881:	8b 10                	mov    (%eax),%edx
 883:	85 d2                	test   %edx,%edx
 885:	74 11                	je     898 <protect_page+0x28>
            return -1;

        p->protected = 1;
 887:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        return 1;
 88d:	b8 01 00 00 00       	mov    $0x1,%eax
    }
    else
        return -1;
}
 892:	5d                   	pop    %ebp
 893:	c3                   	ret    
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
 898:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 89d:	5d                   	pop    %ebp
 89e:	c3                   	ret    
 89f:	90                   	nop

000008a0 <pfree>:



int pfree(void* ap) {
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	8b 45 08             	mov    0x8(%ebp),%eax
    Header *p;
    if (ap) {
 8a6:	85 c0                	test   %eax,%eax
 8a8:	74 1e                	je     8c8 <pfree+0x28>
        if ((uint) ap % 4096 != 0)
 8aa:	a9 ff 0f 00 00       	test   $0xfff,%eax
 8af:	75 17                	jne    8c8 <pfree+0x28>
            return -1;

        p = ap;
        if (p->protected) {
 8b1:	8b 10                	mov    (%eax),%edx
 8b3:	85 d2                	test   %edx,%edx
 8b5:	74 11                	je     8c8 <pfree+0x28>
            free(ap);
 8b7:	50                   	push   %eax
 8b8:	e8 a3 fd ff ff       	call   660 <free>
            return 1;
 8bd:	58                   	pop    %eax
 8be:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    return -1;
}
 8c3:	c9                   	leave  
 8c4:	c3                   	ret    
 8c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 8c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 8cd:	c9                   	leave  
 8ce:	c3                   	ret    
