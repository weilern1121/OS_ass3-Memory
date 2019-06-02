
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 2c                	jle    49 <main+0x49>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	83 c3 04             	add    $0x4,%ebx
  30:	e8 0b 02 00 00       	call   240 <atoi>
  35:	89 04 24             	mov    %eax,(%esp)
  38:	e8 a5 02 00 00       	call   2e2 <kill>
  for(i=1; i<argc; i++)
  3d:	83 c4 10             	add    $0x10,%esp
  40:	39 f3                	cmp    %esi,%ebx
  42:	75 e4                	jne    28 <main+0x28>
  exit();
  44:	e8 69 02 00 00       	call   2b2 <exit>
    printf(2, "usage: kill pid...\n");
  49:	50                   	push   %eax
  4a:	50                   	push   %eax
  4b:	68 78 0a 00 00       	push   $0xa78
  50:	6a 02                	push   $0x2
  52:	e8 d9 03 00 00       	call   430 <printf>
    exit();
  57:	e8 56 02 00 00       	call   2b2 <exit>
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 45 08             	mov    0x8(%ebp),%eax
  67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	89 c2                	mov    %eax,%edx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  70:	83 c1 01             	add    $0x1,%ecx
  73:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  77:	83 c2 01             	add    $0x1,%edx
  7a:	84 db                	test   %bl,%bl
  7c:	88 5a ff             	mov    %bl,-0x1(%edx)
  7f:	75 ef                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  81:	5b                   	pop    %ebx
  82:	5d                   	pop    %ebp
  83:	c3                   	ret    
  84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 55 08             	mov    0x8(%ebp),%edx
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  9a:	0f b6 02             	movzbl (%edx),%eax
  9d:	0f b6 19             	movzbl (%ecx),%ebx
  a0:	84 c0                	test   %al,%al
  a2:	75 1c                	jne    c0 <strcmp+0x30>
  a4:	eb 2a                	jmp    d0 <strcmp+0x40>
  a6:	8d 76 00             	lea    0x0(%esi),%esi
  a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  b0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  b3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  b6:	83 c1 01             	add    $0x1,%ecx
  b9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
  bc:	84 c0                	test   %al,%al
  be:	74 10                	je     d0 <strcmp+0x40>
  c0:	38 d8                	cmp    %bl,%al
  c2:	74 ec                	je     b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  c4:	29 d8                	sub    %ebx,%eax
}
  c6:	5b                   	pop    %ebx
  c7:	5d                   	pop    %ebp
  c8:	c3                   	ret    
  c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  d0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  d2:	29 d8                	sub    %ebx,%eax
}
  d4:	5b                   	pop    %ebx
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strlen>:

uint
strlen(char *s)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  e6:	80 39 00             	cmpb   $0x0,(%ecx)
  e9:	74 15                	je     100 <strlen+0x20>
  eb:	31 d2                	xor    %edx,%edx
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	83 c2 01             	add    $0x1,%edx
  f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f7:	89 d0                	mov    %edx,%eax
  f9:	75 f5                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 100:	31 c0                	xor    %eax,%eax
}
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <memset>:

void*
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 117:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 d7                	mov    %edx,%edi
 11f:	fc                   	cld    
 120:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 122:	89 d0                	mov    %edx,%eax
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 13a:	0f b6 10             	movzbl (%eax),%edx
 13d:	84 d2                	test   %dl,%dl
 13f:	74 1d                	je     15e <strchr+0x2e>
    if(*s == c)
 141:	38 d3                	cmp    %dl,%bl
 143:	89 d9                	mov    %ebx,%ecx
 145:	75 0d                	jne    154 <strchr+0x24>
 147:	eb 17                	jmp    160 <strchr+0x30>
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 150:	38 ca                	cmp    %cl,%dl
 152:	74 0c                	je     160 <strchr+0x30>
  for(; *s; s++)
 154:	83 c0 01             	add    $0x1,%eax
 157:	0f b6 10             	movzbl (%eax),%edx
 15a:	84 d2                	test   %dl,%dl
 15c:	75 f2                	jne    150 <strchr+0x20>
      return (char*)s;
  return 0;
 15e:	31 c0                	xor    %eax,%eax
}
 160:	5b                   	pop    %ebx
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <gets>:

char*
gets(char *buf, int max)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 176:	31 f6                	xor    %esi,%esi
 178:	89 f3                	mov    %esi,%ebx
{
 17a:	83 ec 1c             	sub    $0x1c,%esp
 17d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 180:	eb 2f                	jmp    1b1 <gets+0x41>
 182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 188:	8d 45 e7             	lea    -0x19(%ebp),%eax
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	6a 01                	push   $0x1
 190:	50                   	push   %eax
 191:	6a 00                	push   $0x0
 193:	e8 32 01 00 00       	call   2ca <read>
    if(cc < 1)
 198:	83 c4 10             	add    $0x10,%esp
 19b:	85 c0                	test   %eax,%eax
 19d:	7e 1c                	jle    1bb <gets+0x4b>
      break;
    buf[i++] = c;
 19f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a3:	83 c7 01             	add    $0x1,%edi
 1a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1a9:	3c 0a                	cmp    $0xa,%al
 1ab:	74 23                	je     1d0 <gets+0x60>
 1ad:	3c 0d                	cmp    $0xd,%al
 1af:	74 1f                	je     1d0 <gets+0x60>
  for(i=0; i+1 < max; ){
 1b1:	83 c3 01             	add    $0x1,%ebx
 1b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b7:	89 fe                	mov    %edi,%esi
 1b9:	7c cd                	jl     188 <gets+0x18>
 1bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 1c0:	c6 03 00             	movb   $0x0,(%ebx)
}
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
  buf[i] = '\0';
 1da:	c6 03 00             	movb   $0x0,(%ebx)
}
 1dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e0:	5b                   	pop    %ebx
 1e1:	5e                   	pop    %esi
 1e2:	5f                   	pop    %edi
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    
 1e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <stat>:

int
stat(char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 00                	push   $0x0
 1fa:	ff 75 08             	pushl  0x8(%ebp)
 1fd:	e8 f0 00 00 00       	call   2f2 <open>
  if(fd < 0)
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 c0                	test   %eax,%eax
 207:	78 27                	js     230 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	ff 75 0c             	pushl  0xc(%ebp)
 20f:	89 c3                	mov    %eax,%ebx
 211:	50                   	push   %eax
 212:	e8 f3 00 00 00       	call   30a <fstat>
  close(fd);
 217:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 21a:	89 c6                	mov    %eax,%esi
  close(fd);
 21c:	e8 b9 00 00 00       	call   2da <close>
  return r;
 221:	83 c4 10             	add    $0x10,%esp
}
 224:	8d 65 f8             	lea    -0x8(%ebp),%esp
 227:	89 f0                	mov    %esi,%eax
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 230:	be ff ff ff ff       	mov    $0xffffffff,%esi
 235:	eb ed                	jmp    224 <stat+0x34>
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <atoi>:

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 247:	0f be 11             	movsbl (%ecx),%edx
 24a:	8d 42 d0             	lea    -0x30(%edx),%eax
 24d:	3c 09                	cmp    $0x9,%al
  n = 0;
 24f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 254:	77 1f                	ja     275 <atoi+0x35>
 256:	8d 76 00             	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 260:	8d 04 80             	lea    (%eax,%eax,4),%eax
 263:	83 c1 01             	add    $0x1,%ecx
 266:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 26a:	0f be 11             	movsbl (%ecx),%edx
 26d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
  return n;
}
 275:	5b                   	pop    %ebx
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    
 278:	90                   	nop
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
 285:	8b 5d 10             	mov    0x10(%ebp),%ebx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 28e:	85 db                	test   %ebx,%ebx
 290:	7e 14                	jle    2a6 <memmove+0x26>
 292:	31 d2                	xor    %edx,%edx
 294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 298:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 29c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 29f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2a2:	39 d3                	cmp    %edx,%ebx
 2a4:	75 f2                	jne    298 <memmove+0x18>
  return vdst;
}
 2a6:	5b                   	pop    %ebx
 2a7:	5e                   	pop    %esi
 2a8:	5d                   	pop    %ebp
 2a9:	c3                   	ret    

000002aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2aa:	b8 01 00 00 00       	mov    $0x1,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <exit>:
SYSCALL(exit)
 2b2:	b8 02 00 00 00       	mov    $0x2,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <wait>:
SYSCALL(wait)
 2ba:	b8 03 00 00 00       	mov    $0x3,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <pipe>:
SYSCALL(pipe)
 2c2:	b8 04 00 00 00       	mov    $0x4,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <read>:
SYSCALL(read)
 2ca:	b8 05 00 00 00       	mov    $0x5,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <write>:
SYSCALL(write)
 2d2:	b8 10 00 00 00       	mov    $0x10,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <close>:
SYSCALL(close)
 2da:	b8 15 00 00 00       	mov    $0x15,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <kill>:
SYSCALL(kill)
 2e2:	b8 06 00 00 00       	mov    $0x6,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <exec>:
SYSCALL(exec)
 2ea:	b8 07 00 00 00       	mov    $0x7,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <open>:
SYSCALL(open)
 2f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <mknod>:
SYSCALL(mknod)
 2fa:	b8 11 00 00 00       	mov    $0x11,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <unlink>:
SYSCALL(unlink)
 302:	b8 12 00 00 00       	mov    $0x12,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <fstat>:
SYSCALL(fstat)
 30a:	b8 08 00 00 00       	mov    $0x8,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <link>:
SYSCALL(link)
 312:	b8 13 00 00 00       	mov    $0x13,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <mkdir>:
SYSCALL(mkdir)
 31a:	b8 14 00 00 00       	mov    $0x14,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <chdir>:
SYSCALL(chdir)
 322:	b8 09 00 00 00       	mov    $0x9,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <dup>:
SYSCALL(dup)
 32a:	b8 0a 00 00 00       	mov    $0xa,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <getpid>:
SYSCALL(getpid)
 332:	b8 0b 00 00 00       	mov    $0xb,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sbrk>:
SYSCALL(sbrk)
 33a:	b8 0c 00 00 00       	mov    $0xc,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sleep>:
SYSCALL(sleep)
 342:	b8 0d 00 00 00       	mov    $0xd,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <uptime>:
SYSCALL(uptime)
 34a:	b8 0e 00 00 00       	mov    $0xe,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <turnOnPM>:
SYSCALL(turnOnPM)
 352:	b8 17 00 00 00       	mov    $0x17,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <checkOnPM>:
SYSCALL(checkOnPM)
 35a:	b8 18 00 00 00       	mov    $0x18,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <turnOffW>:
SYSCALL(turnOffW)
 362:	b8 19 00 00 00       	mov    $0x19,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <turnOnW>:
SYSCALL(turnOnW)
 36a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <turnOffPM>:
SYSCALL(turnOffPM)
 372:	b8 1b 00 00 00       	mov    $0x1b,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <updatePTE>:
SYSCALL(updatePTE)
 37a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <updateProc>:
SYSCALL(updateProc)
 382:	b8 1d 00 00 00       	mov    $0x1d,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    
 38a:	66 90                	xchg   %ax,%ax
 38c:	66 90                	xchg   %ax,%ax
 38e:	66 90                	xchg   %ax,%ax

00000390 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 399:	85 d2                	test   %edx,%edx
{
 39b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 39e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 3a0:	79 76                	jns    418 <printint+0x88>
 3a2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3a6:	74 70                	je     418 <printint+0x88>
    x = -xx;
 3a8:	f7 d8                	neg    %eax
    neg = 1;
 3aa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3b1:	31 f6                	xor    %esi,%esi
 3b3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3b6:	eb 0a                	jmp    3c2 <printint+0x32>
 3b8:	90                   	nop
 3b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 3c0:	89 fe                	mov    %edi,%esi
 3c2:	31 d2                	xor    %edx,%edx
 3c4:	8d 7e 01             	lea    0x1(%esi),%edi
 3c7:	f7 f1                	div    %ecx
 3c9:	0f b6 92 94 0a 00 00 	movzbl 0xa94(%edx),%edx
  }while((x /= base) != 0);
 3d0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3d2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 3d5:	75 e9                	jne    3c0 <printint+0x30>
  if(neg)
 3d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3da:	85 c0                	test   %eax,%eax
 3dc:	74 08                	je     3e6 <printint+0x56>
    buf[i++] = '-';
 3de:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 3e3:	8d 7e 02             	lea    0x2(%esi),%edi
 3e6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 3ea:	8b 7d c0             	mov    -0x40(%ebp),%edi
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
 3f0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 3f3:	83 ec 04             	sub    $0x4,%esp
 3f6:	83 ee 01             	sub    $0x1,%esi
 3f9:	6a 01                	push   $0x1
 3fb:	53                   	push   %ebx
 3fc:	57                   	push   %edi
 3fd:	88 45 d7             	mov    %al,-0x29(%ebp)
 400:	e8 cd fe ff ff       	call   2d2 <write>

  while(--i >= 0)
 405:	83 c4 10             	add    $0x10,%esp
 408:	39 de                	cmp    %ebx,%esi
 40a:	75 e4                	jne    3f0 <printint+0x60>
    putc(fd, buf[i]);
}
 40c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 40f:	5b                   	pop    %ebx
 410:	5e                   	pop    %esi
 411:	5f                   	pop    %edi
 412:	5d                   	pop    %ebp
 413:	c3                   	ret    
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 418:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 41f:	eb 90                	jmp    3b1 <printint+0x21>
 421:	eb 0d                	jmp    430 <printf>
 423:	90                   	nop
 424:	90                   	nop
 425:	90                   	nop
 426:	90                   	nop
 427:	90                   	nop
 428:	90                   	nop
 429:	90                   	nop
 42a:	90                   	nop
 42b:	90                   	nop
 42c:	90                   	nop
 42d:	90                   	nop
 42e:	90                   	nop
 42f:	90                   	nop

00000430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 439:	8b 75 0c             	mov    0xc(%ebp),%esi
 43c:	0f b6 1e             	movzbl (%esi),%ebx
 43f:	84 db                	test   %bl,%bl
 441:	0f 84 b3 00 00 00    	je     4fa <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 447:	8d 45 10             	lea    0x10(%ebp),%eax
 44a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 44d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 44f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 452:	eb 2f                	jmp    483 <printf+0x53>
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 458:	83 f8 25             	cmp    $0x25,%eax
 45b:	0f 84 a7 00 00 00    	je     508 <printf+0xd8>
  write(fd, &c, 1);
 461:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 464:	83 ec 04             	sub    $0x4,%esp
 467:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 46a:	6a 01                	push   $0x1
 46c:	50                   	push   %eax
 46d:	ff 75 08             	pushl  0x8(%ebp)
 470:	e8 5d fe ff ff       	call   2d2 <write>
 475:	83 c4 10             	add    $0x10,%esp
 478:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 47b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 47f:	84 db                	test   %bl,%bl
 481:	74 77                	je     4fa <printf+0xca>
    if(state == 0){
 483:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 485:	0f be cb             	movsbl %bl,%ecx
 488:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 48b:	74 cb                	je     458 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 48d:	83 ff 25             	cmp    $0x25,%edi
 490:	75 e6                	jne    478 <printf+0x48>
      if(c == 'd'){
 492:	83 f8 64             	cmp    $0x64,%eax
 495:	0f 84 05 01 00 00    	je     5a0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 49b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4a1:	83 f9 70             	cmp    $0x70,%ecx
 4a4:	74 72                	je     518 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4a6:	83 f8 73             	cmp    $0x73,%eax
 4a9:	0f 84 99 00 00 00    	je     548 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4af:	83 f8 63             	cmp    $0x63,%eax
 4b2:	0f 84 08 01 00 00    	je     5c0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4b8:	83 f8 25             	cmp    $0x25,%eax
 4bb:	0f 84 ef 00 00 00    	je     5b0 <printf+0x180>
  write(fd, &c, 1);
 4c1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c4:	83 ec 04             	sub    $0x4,%esp
 4c7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4cb:	6a 01                	push   $0x1
 4cd:	50                   	push   %eax
 4ce:	ff 75 08             	pushl  0x8(%ebp)
 4d1:	e8 fc fd ff ff       	call   2d2 <write>
 4d6:	83 c4 0c             	add    $0xc,%esp
 4d9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4dc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4df:	6a 01                	push   $0x1
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 4ea:	e8 e3 fd ff ff       	call   2d2 <write>
  for(i = 0; fmt[i]; i++){
 4ef:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 4f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4f6:	84 db                	test   %bl,%bl
 4f8:	75 89                	jne    483 <printf+0x53>
    }
  }
}
 4fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4fd:	5b                   	pop    %ebx
 4fe:	5e                   	pop    %esi
 4ff:	5f                   	pop    %edi
 500:	5d                   	pop    %ebp
 501:	c3                   	ret    
 502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 508:	bf 25 00 00 00       	mov    $0x25,%edi
 50d:	e9 66 ff ff ff       	jmp    478 <printf+0x48>
 512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 518:	83 ec 0c             	sub    $0xc,%esp
 51b:	b9 10 00 00 00       	mov    $0x10,%ecx
 520:	6a 00                	push   $0x0
 522:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 525:	8b 45 08             	mov    0x8(%ebp),%eax
 528:	8b 17                	mov    (%edi),%edx
 52a:	e8 61 fe ff ff       	call   390 <printint>
        ap++;
 52f:	89 f8                	mov    %edi,%eax
 531:	83 c4 10             	add    $0x10,%esp
      state = 0;
 534:	31 ff                	xor    %edi,%edi
        ap++;
 536:	83 c0 04             	add    $0x4,%eax
 539:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 53c:	e9 37 ff ff ff       	jmp    478 <printf+0x48>
 541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 548:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 54b:	8b 08                	mov    (%eax),%ecx
        ap++;
 54d:	83 c0 04             	add    $0x4,%eax
 550:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 553:	85 c9                	test   %ecx,%ecx
 555:	0f 84 8e 00 00 00    	je     5e9 <printf+0x1b9>
        while(*s != 0){
 55b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 55e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 560:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 562:	84 c0                	test   %al,%al
 564:	0f 84 0e ff ff ff    	je     478 <printf+0x48>
 56a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 56d:	89 de                	mov    %ebx,%esi
 56f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 572:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 575:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 578:	83 ec 04             	sub    $0x4,%esp
          s++;
 57b:	83 c6 01             	add    $0x1,%esi
 57e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 581:	6a 01                	push   $0x1
 583:	57                   	push   %edi
 584:	53                   	push   %ebx
 585:	e8 48 fd ff ff       	call   2d2 <write>
        while(*s != 0){
 58a:	0f b6 06             	movzbl (%esi),%eax
 58d:	83 c4 10             	add    $0x10,%esp
 590:	84 c0                	test   %al,%al
 592:	75 e4                	jne    578 <printf+0x148>
 594:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 597:	31 ff                	xor    %edi,%edi
 599:	e9 da fe ff ff       	jmp    478 <printf+0x48>
 59e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 5a0:	83 ec 0c             	sub    $0xc,%esp
 5a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5a8:	6a 01                	push   $0x1
 5aa:	e9 73 ff ff ff       	jmp    522 <printf+0xf2>
 5af:	90                   	nop
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
 5b3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5b6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5b9:	6a 01                	push   $0x1
 5bb:	e9 21 ff ff ff       	jmp    4e1 <printf+0xb1>
        putc(fd, *ap);
 5c0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 5c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5c6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 5c8:	6a 01                	push   $0x1
        ap++;
 5ca:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 5cd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5d3:	50                   	push   %eax
 5d4:	ff 75 08             	pushl  0x8(%ebp)
 5d7:	e8 f6 fc ff ff       	call   2d2 <write>
        ap++;
 5dc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5df:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e2:	31 ff                	xor    %edi,%edi
 5e4:	e9 8f fe ff ff       	jmp    478 <printf+0x48>
          s = "(null)";
 5e9:	bb 8c 0a 00 00       	mov    $0xa8c,%ebx
        while(*s != 0){
 5ee:	b8 28 00 00 00       	mov    $0x28,%eax
 5f3:	e9 72 ff ff ff       	jmp    56a <printf+0x13a>
 5f8:	66 90                	xchg   %ax,%ax
 5fa:	66 90                	xchg   %ax,%ax
 5fc:	66 90                	xchg   %ax,%ax
 5fe:	66 90                	xchg   %ax,%ax

00000600 <free>:


/*-------  pmalloc struct  ---------------*/

void
free(void *ap) {
 600:	55                   	push   %ebp
    if (DEBUGMODE == 3)
        printf(1, "FREE-\t");
    Header *bp, *p;

    bp = (Header *) ap - 1;
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	a1 64 0e 00 00       	mov    0xe64,%eax
free(void *ap) {
 606:	89 e5                	mov    %esp,%ebp
 608:	57                   	push   %edi
 609:	56                   	push   %esi
 60a:	53                   	push   %ebx
 60b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = (Header *) ap - 1;
 60e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 618:	39 c8                	cmp    %ecx,%eax
 61a:	8b 10                	mov    (%eax),%edx
 61c:	73 32                	jae    650 <free+0x50>
 61e:	39 d1                	cmp    %edx,%ecx
 620:	72 04                	jb     626 <free+0x26>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 622:	39 d0                	cmp    %edx,%eax
 624:	72 32                	jb     658 <free+0x58>
            break;
    if (bp + bp->s.size == p->s.ptr) {
 626:	8b 73 fc             	mov    -0x4(%ebx),%esi
 629:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 62c:	39 fa                	cmp    %edi,%edx
 62e:	74 30                	je     660 <free+0x60>
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    } else
        bp->s.ptr = p->s.ptr;
 630:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 633:	8b 50 04             	mov    0x4(%eax),%edx
 636:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 639:	39 f1                	cmp    %esi,%ecx
 63b:	74 3a                	je     677 <free+0x77>
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    } else
        p->s.ptr = bp;
 63d:	89 08                	mov    %ecx,(%eax)
    freep = p;
 63f:	a3 64 0e 00 00       	mov    %eax,0xe64
    if (DEBUGMODE == 3)
        printf(1, ">FREE-DONE!\t");
}
 644:	5b                   	pop    %ebx
 645:	5e                   	pop    %esi
 646:	5f                   	pop    %edi
 647:	5d                   	pop    %ebp
 648:	c3                   	ret    
 649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 650:	39 d0                	cmp    %edx,%eax
 652:	72 04                	jb     658 <free+0x58>
 654:	39 d1                	cmp    %edx,%ecx
 656:	72 ce                	jb     626 <free+0x26>
free(void *ap) {
 658:	89 d0                	mov    %edx,%eax
 65a:	eb bc                	jmp    618 <free+0x18>
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        bp->s.size += p->s.ptr->s.size;
 660:	03 72 04             	add    0x4(%edx),%esi
 663:	89 73 fc             	mov    %esi,-0x4(%ebx)
        bp->s.ptr = p->s.ptr->s.ptr;
 666:	8b 10                	mov    (%eax),%edx
 668:	8b 12                	mov    (%edx),%edx
 66a:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 673:	39 f1                	cmp    %esi,%ecx
 675:	75 c6                	jne    63d <free+0x3d>
        p->s.size += bp->s.size;
 677:	03 53 fc             	add    -0x4(%ebx),%edx
    freep = p;
 67a:	a3 64 0e 00 00       	mov    %eax,0xe64
        p->s.size += bp->s.size;
 67f:	89 50 04             	mov    %edx,0x4(%eax)
        p->s.ptr = bp->s.ptr;
 682:	8b 53 f8             	mov    -0x8(%ebx),%edx
 685:	89 10                	mov    %edx,(%eax)
}
 687:	5b                   	pop    %ebx
 688:	5e                   	pop    %esi
 689:	5f                   	pop    %edi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret    
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000690 <malloc>:
    return freep;
}


void *
malloc(uint nbytes) {
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	53                   	push   %ebx
 696:	83 ec 0c             	sub    $0xc,%esp
    if (DEBUGMODE == 3)
        printf(1, "MALLOC-");
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
    if ((prevp = freep) == 0) {
 69c:	8b 15 64 0e 00 00    	mov    0xe64,%edx
    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 6a2:	8d 78 07             	lea    0x7(%eax),%edi
 6a5:	c1 ef 03             	shr    $0x3,%edi
 6a8:	83 c7 01             	add    $0x1,%edi
    if ((prevp = freep) == 0) {
 6ab:	85 d2                	test   %edx,%edx
 6ad:	0f 84 9d 00 00 00    	je     750 <malloc+0xc0>
 6b3:	8b 02                	mov    (%edx),%eax
 6b5:	8b 48 04             	mov    0x4(%eax),%ecx
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
        if (p->s.size >= nunits) {
 6b8:	39 cf                	cmp    %ecx,%edi
 6ba:	76 6c                	jbe    728 <malloc+0x98>
 6bc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6c2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6c7:	0f 43 df             	cmovae %edi,%ebx
    p = sbrk(nu * sizeof(Header));
 6ca:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6d1:	eb 0e                	jmp    6e1 <malloc+0x51>
 6d3:	90                   	nop
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 6d8:	8b 02                	mov    (%edx),%eax
        if (p->s.size >= nunits) {
 6da:	8b 48 04             	mov    0x4(%eax),%ecx
 6dd:	39 f9                	cmp    %edi,%ecx
 6df:	73 47                	jae    728 <malloc+0x98>
            freep = prevp;
            if (DEBUGMODE == 3)
                printf(1, ">MALLOC-done!\t");
            return (void *) (p + 1);
        }
        if (p == freep)
 6e1:	39 05 64 0e 00 00    	cmp    %eax,0xe64
 6e7:	89 c2                	mov    %eax,%edx
 6e9:	75 ed                	jne    6d8 <malloc+0x48>
    p = sbrk(nu * sizeof(Header));
 6eb:	83 ec 0c             	sub    $0xc,%esp
 6ee:	56                   	push   %esi
 6ef:	e8 46 fc ff ff       	call   33a <sbrk>
    if (p == (char *) -1)
 6f4:	83 c4 10             	add    $0x10,%esp
 6f7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6fa:	74 1c                	je     718 <malloc+0x88>
    hp->s.size = nu;
 6fc:	89 58 04             	mov    %ebx,0x4(%eax)
    free((void *) (hp + 1));
 6ff:	83 ec 0c             	sub    $0xc,%esp
 702:	83 c0 08             	add    $0x8,%eax
 705:	50                   	push   %eax
 706:	e8 f5 fe ff ff       	call   600 <free>
    return freep;
 70b:	8b 15 64 0e 00 00    	mov    0xe64,%edx
            if ((p = morecore(nunits)) == 0)
 711:	83 c4 10             	add    $0x10,%esp
 714:	85 d2                	test   %edx,%edx
 716:	75 c0                	jne    6d8 <malloc+0x48>
                return 0;
    }
}
 718:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return 0;
 71b:	31 c0                	xor    %eax,%eax
}
 71d:	5b                   	pop    %ebx
 71e:	5e                   	pop    %esi
 71f:	5f                   	pop    %edi
 720:	5d                   	pop    %ebp
 721:	c3                   	ret    
 722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (p->s.size == nunits)
 728:	39 cf                	cmp    %ecx,%edi
 72a:	74 54                	je     780 <malloc+0xf0>
                p->s.size -= nunits;
 72c:	29 f9                	sub    %edi,%ecx
 72e:	89 48 04             	mov    %ecx,0x4(%eax)
                p += p->s.size;
 731:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
                p->s.size = nunits;
 734:	89 78 04             	mov    %edi,0x4(%eax)
            freep = prevp;
 737:	89 15 64 0e 00 00    	mov    %edx,0xe64
}
 73d:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return (void *) (p + 1);
 740:	83 c0 08             	add    $0x8,%eax
}
 743:	5b                   	pop    %ebx
 744:	5e                   	pop    %esi
 745:	5f                   	pop    %edi
 746:	5d                   	pop    %ebp
 747:	c3                   	ret    
 748:	90                   	nop
 749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        base.s.ptr = freep = prevp = &base;
 750:	c7 05 64 0e 00 00 68 	movl   $0xe68,0xe64
 757:	0e 00 00 
 75a:	c7 05 68 0e 00 00 68 	movl   $0xe68,0xe68
 761:	0e 00 00 
        base.s.size = 0;
 764:	b8 68 0e 00 00       	mov    $0xe68,%eax
 769:	c7 05 6c 0e 00 00 00 	movl   $0x0,0xe6c
 770:	00 00 00 
 773:	e9 44 ff ff ff       	jmp    6bc <malloc+0x2c>
 778:	90                   	nop
 779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                prevp->s.ptr = p->s.ptr;
 780:	8b 08                	mov    (%eax),%ecx
 782:	89 0a                	mov    %ecx,(%edx)
 784:	eb b1                	jmp    737 <malloc+0xa7>
 786:	8d 76 00             	lea    0x0(%esi),%esi
 789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000790 <pmalloc>:


void *
pmalloc(void) {
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	56                   	push   %esi
 794:	53                   	push   %ebx
    if (DEBUGMODE == 3)
        printf(1, "PMALLOC-");
    struct PMHeader *nh = malloc(sizeof(struct PMHeader));
 795:	83 ec 0c             	sub    $0xc,%esp
 798:	6a 10                	push   $0x10
 79a:	e8 f1 fe ff ff       	call   690 <malloc>
    char *tmpAdr = sbrk(4096); //point to the first free place
 79f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    struct PMHeader *nh = malloc(sizeof(struct PMHeader));
 7a6:	89 c3                	mov    %eax,%ebx
    char *tmpAdr = sbrk(4096); //point to the first free place
 7a8:	e8 8d fb ff ff       	call   33a <sbrk>
    if ((int) tmpAdr % 4096 != 0) //if not align->fix this
 7ad:	83 c4 10             	add    $0x10,%esp
 7b0:	a9 ff 0f 00 00       	test   $0xfff,%eax
    char *tmpAdr = sbrk(4096); //point to the first free place
 7b5:	89 c6                	mov    %eax,%esi
    if ((int) tmpAdr % 4096 != 0) //if not align->fix this
 7b7:	74 03                	je     7bc <pmalloc+0x2c>
        *tmpAdr = (char) PGROUNDUP((int) tmpAdr);
 7b9:	c6 00 00             	movb   $0x0,(%eax)

    //init PMHeader
    nh->PMheaderID = nextID++;
 7bc:	a1 54 0e 00 00       	mov    0xe54,%eax
    nh->PMnext = 0;
 7c1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    nh->PMadress = tmpAdr;
 7c8:	89 73 04             	mov    %esi,0x4(%ebx)
    nh->PMprotectedPage = 0;
 7cb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    nh->PMheaderID = nextID++;
 7d2:	8d 50 01             	lea    0x1(%eax),%edx
 7d5:	89 15 54 0e 00 00    	mov    %edx,0xe54
 7db:	89 03                	mov    %eax,(%ebx)

    //if first-> PMpage=tail=nh
    if (PMcounter == 0) {
 7dd:	8b 15 58 0e 00 00    	mov    0xe58,%edx
 7e3:	85 d2                	test   %edx,%edx
 7e5:	74 39                	je     820 <pmalloc+0x90>
        PMinit = nh; //set PMinit link
        tail = nh;
    } else { //else- add new page to the end of PMlist
        tail->PMnext = nh;
 7e7:	a1 5c 0e 00 00       	mov    0xe5c,%eax
        tail = tail->PMnext;
 7ec:	89 1d 5c 0e 00 00    	mov    %ebx,0xe5c
        tail->PMnext = nh;
 7f2:	89 58 08             	mov    %ebx,0x8(%eax)
 7f5:	8b 43 04             	mov    0x4(%ebx),%eax
    }
    //turn PMflag on and W flag off
    turnOnW(nh->PMadress);//TODO
 7f8:	83 ec 0c             	sub    $0xc,%esp
 7fb:	50                   	push   %eax
 7fc:	e8 69 fb ff ff       	call   36a <turnOnW>
    turnOnPM(nh->PMadress);
 801:	58                   	pop    %eax
 802:	ff 73 04             	pushl  0x4(%ebx)
 805:	e8 48 fb ff ff       	call   352 <turnOnPM>
    //fresh PTE
    updatePTE();
 80a:	e8 6b fb ff ff       	call   37a <updatePTE>
    PMcounter++;
 80f:	83 05 58 0e 00 00 01 	addl   $0x1,0xe58
    if (DEBUGMODE == 3)
        printf(1, ">PMALLOC-DONE!\n");
    return tmpAdr;
}
 816:	8d 65 f8             	lea    -0x8(%ebp),%esp
 819:	89 f0                	mov    %esi,%eax
 81b:	5b                   	pop    %ebx
 81c:	5e                   	pop    %esi
 81d:	5d                   	pop    %ebp
 81e:	c3                   	ret    
 81f:	90                   	nop
        PMinit = nh; //set PMinit link
 820:	89 1d 60 0e 00 00    	mov    %ebx,0xe60
        tail = nh;
 826:	89 1d 5c 0e 00 00    	mov    %ebx,0xe5c
    char *tmpAdr = sbrk(4096); //point to the first free place
 82c:	89 f0                	mov    %esi,%eax
 82e:	eb c8                	jmp    7f8 <pmalloc+0x68>

00000830 <protect_page>:

int
protect_page(void *ap) {
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	53                   	push   %ebx
 834:	83 ec 04             	sub    $0x4,%esp
 837:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE == 3)
        printf(1, "PROTECT_PAGE-");
    if (ap) {
 83a:	85 db                	test   %ebx,%ebx
 83c:	74 7a                	je     8b8 <protect_page+0x88>
        if ((int) ap % 4096 != 0) {
 83e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
 844:	75 72                	jne    8b8 <protect_page+0x88>
            if (DEBUGMODE == 3)
                printf(1, ">PROTECT_PAGE-ERROR-NOT_ALIGN!\n");
            return -1;
        }
        if (checkOnPM(ap)) { //if PTE_PM off -can't protect not pmalloc page
 846:	83 ec 0c             	sub    $0xc,%esp
 849:	53                   	push   %ebx
 84a:	e8 0b fb ff ff       	call   35a <checkOnPM>
 84f:	83 c4 10             	add    $0x10,%esp
 852:	85 c0                	test   %eax,%eax
 854:	74 62                	je     8b8 <protect_page+0x88>
            turnOffW(ap);
 856:	83 ec 0c             	sub    $0xc,%esp
 859:	53                   	push   %ebx
 85a:	e8 03 fb ff ff       	call   362 <turnOffW>
            updatePTE();
 85f:	e8 16 fb ff ff       	call   37a <updatePTE>
            updateProc(1); // protectedPages++
 864:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 86b:	e8 12 fb ff ff       	call   382 <updateProc>
            //turn on flag
            struct PMHeader *PMap = PMinit;
 870:	a1 60 0e 00 00       	mov    0xe60,%eax
            while (PMap->PMnext != 0 && PMap->PMadress != ap)
 875:	83 c4 10             	add    $0x10,%esp
 878:	eb 0c                	jmp    886 <protect_page+0x56>
 87a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 880:	39 cb                	cmp    %ecx,%ebx
 882:	74 10                	je     894 <protect_page+0x64>
 884:	89 d0                	mov    %edx,%eax
 886:	8b 50 08             	mov    0x8(%eax),%edx
 889:	8b 48 04             	mov    0x4(%eax),%ecx
 88c:	85 d2                	test   %edx,%edx
 88e:	75 f0                	jne    880 <protect_page+0x50>
                PMap = PMap->PMnext;
            if (PMap->PMadress != ap) {
 890:	39 cb                	cmp    %ecx,%ebx
 892:	75 11                	jne    8a5 <protect_page+0x75>
                printf(2, "PROBLEM with ap:%d\n", ap);
                return -1;
            }
            //got here ->MPap points the protected link
            PMap->PMprotectedPage = 1;//turn on FLAG
 894:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
            if (DEBUGMODE == 3)
                printf(1, ">PROTECT_PAGE-DONE!\n");
            return 1;
 89b:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    if (DEBUGMODE == 3)
        printf(1, ">PROTECT_PAGE-ERROR!\n");
    return -1;
}
 8a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8a3:	c9                   	leave  
 8a4:	c3                   	ret    
                printf(2, "PROBLEM with ap:%d\n", ap);
 8a5:	83 ec 04             	sub    $0x4,%esp
 8a8:	53                   	push   %ebx
 8a9:	68 a5 0a 00 00       	push   $0xaa5
 8ae:	6a 02                	push   $0x2
 8b0:	e8 7b fb ff ff       	call   430 <printf>
 8b5:	83 c4 10             	add    $0x10,%esp
 8b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 8bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8c0:	c9                   	leave  
 8c1:	c3                   	ret    
 8c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008d0 <printPMList>:


void
printPMList(void) {
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	56                   	push   %esi
 8d4:	53                   	push   %ebx
    struct PMHeader *tmp2 = PMinit;
 8d5:	8b 1d 60 0e 00 00    	mov    0xe60,%ebx
    printf(1, "\nPMlist:\t");
 8db:	83 ec 08             	sub    $0x8,%esp
 8de:	68 b9 0a 00 00       	push   $0xab9
 8e3:	6a 01                	push   $0x1
 8e5:	e8 46 fb ff ff       	call   430 <printf>
    for (int i = 0; i < PMcounter; i++, tmp2 = tmp2->PMnext)
 8ea:	a1 58 0e 00 00       	mov    0xe58,%eax
 8ef:	83 c4 10             	add    $0x10,%esp
 8f2:	85 c0                	test   %eax,%eax
 8f4:	7e 2d                	jle    923 <printPMList+0x53>
 8f6:	31 f6                	xor    %esi,%esi
 8f8:	90                   	nop
 8f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(2, "%d\t", tmp2->PMadress);
 900:	83 ec 04             	sub    $0x4,%esp
 903:	ff 73 04             	pushl  0x4(%ebx)
    for (int i = 0; i < PMcounter; i++, tmp2 = tmp2->PMnext)
 906:	83 c6 01             	add    $0x1,%esi
        printf(2, "%d\t", tmp2->PMadress);
 909:	68 c3 0a 00 00       	push   $0xac3
 90e:	6a 02                	push   $0x2
 910:	e8 1b fb ff ff       	call   430 <printf>
    for (int i = 0; i < PMcounter; i++, tmp2 = tmp2->PMnext)
 915:	83 c4 10             	add    $0x10,%esp
 918:	39 35 58 0e 00 00    	cmp    %esi,0xe58
 91e:	8b 5b 08             	mov    0x8(%ebx),%ebx
 921:	7f dd                	jg     900 <printPMList+0x30>
    printf(1, "\n\n");
 923:	83 ec 08             	sub    $0x8,%esp
 926:	68 c7 0a 00 00       	push   $0xac7
 92b:	6a 01                	push   $0x1
 92d:	e8 fe fa ff ff       	call   430 <printf>
}
 932:	83 c4 10             	add    $0x10,%esp
 935:	8d 65 f8             	lea    -0x8(%ebp),%esp
 938:	5b                   	pop    %ebx
 939:	5e                   	pop    %esi
 93a:	5d                   	pop    %ebp
 93b:	c3                   	ret    
 93c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000940 <checkIfPM>:

//return 1 if ap is address of PMALLOC page ; 0 otherwise
int
checkIfPM(void *p) {
    struct PMHeader *tmp = PMinit;
    for (int i = 0; i < PMcounter; i++) {
 940:	8b 15 58 0e 00 00    	mov    0xe58,%edx
    struct PMHeader *tmp = PMinit;
 946:	a1 60 0e 00 00       	mov    0xe60,%eax
    for (int i = 0; i < PMcounter; i++) {
 94b:	85 d2                	test   %edx,%edx
 94d:	7e 11                	jle    960 <checkIfPM+0x20>
checkIfPM(void *p) {
 94f:	55                   	push   %ebp
 950:	89 e5                	mov    %esp,%ebp
        if (tmp->PMadress == p)
 952:	8b 55 08             	mov    0x8(%ebp),%edx
 955:	39 50 04             	cmp    %edx,0x4(%eax)
            return 1;
    }
    return 0;
}
 958:	5d                   	pop    %ebp
        if (tmp->PMadress == p)
 959:	0f 94 c0             	sete   %al
 95c:	0f b6 c0             	movzbl %al,%eax
}
 95f:	c3                   	ret    
    return 0;
 960:	31 c0                	xor    %eax,%eax
}
 962:	c3                   	ret    
 963:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000970 <pfree>:
pfree(void *ap) {
    if (DEBUGMODE == 3)
        printf(1, "PFREE-");

    //validation check
    if (PMcounter == 0) {
 970:	a1 58 0e 00 00       	mov    0xe58,%eax
pfree(void *ap) {
 975:	55                   	push   %ebp
 976:	89 e5                	mov    %esp,%ebp
 978:	56                   	push   %esi
 979:	53                   	push   %ebx
        if (DEBUGMODE == 3)
            printf(1, "PFREE-ERROR!->not have pages that were pmallocced\n");
        return -1;
    }

    if (ap) {
 97a:	85 c0                	test   %eax,%eax
pfree(void *ap) {
 97c:	8b 75 08             	mov    0x8(%ebp),%esi
    if (ap) {
 97f:	74 1b                	je     99c <pfree+0x2c>
 981:	85 f6                	test   %esi,%esi
 983:	74 17                	je     99c <pfree+0x2c>
        struct PMHeader *PMap = PMinit;
        struct PMHeader *tmp = PMinit;
        //check aligned
        if ((int) ap % 4096 != 0) {
 985:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
        struct PMHeader *PMap = PMinit;
 98b:	8b 1d 60 0e 00 00    	mov    0xe60,%ebx
        if ((int) ap % 4096 != 0) {
 991:	75 09                	jne    99c <pfree+0x2c>
    for (int i = 0; i < PMcounter; i++) {
 993:	85 c0                	test   %eax,%eax
 995:	7e 05                	jle    99c <pfree+0x2c>
        if (tmp->PMadress == p)
 997:	3b 73 04             	cmp    0x4(%ebx),%esi
 99a:	74 14                	je     9b0 <pfree+0x40>
            return -1;
        }
    }
    if (DEBUGMODE == 3)
        printf(1, ">PFREE-ERROR!\t");
    return -1;
 99c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 9a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
 9a4:	5b                   	pop    %ebx
 9a5:	5e                   	pop    %esi
 9a6:	5d                   	pop    %ebp
 9a7:	c3                   	ret    
 9a8:	90                   	nop
 9a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            turnOffW(PMap);
 9b0:	83 ec 0c             	sub    $0xc,%esp
 9b3:	53                   	push   %ebx
 9b4:	e8 a9 f9 ff ff       	call   362 <turnOffW>
            turnOffPM(PMap);
 9b9:	89 1c 24             	mov    %ebx,(%esp)
 9bc:	e8 b1 f9 ff ff       	call   372 <turnOffPM>
            updatePTE();
 9c1:	e8 b4 f9 ff ff       	call   37a <updatePTE>
            PMcounter--;
 9c6:	a1 58 0e 00 00       	mov    0xe58,%eax
            if (PMcounter == 0) {//if true ->reset PMlist
 9cb:	83 c4 10             	add    $0x10,%esp
            PMcounter--;
 9ce:	83 e8 01             	sub    $0x1,%eax
            if (PMcounter == 0) {//if true ->reset PMlist
 9d1:	85 c0                	test   %eax,%eax
            PMcounter--;
 9d3:	a3 58 0e 00 00       	mov    %eax,0xe58
            if (PMcounter == 0) {//if true ->reset PMlist
 9d8:	74 46                	je     a20 <pfree+0xb0>
 9da:	89 d8                	mov    %ebx,%eax
 9dc:	eb 08                	jmp    9e6 <pfree+0x76>
 9de:	66 90                	xchg   %ax,%ax
                while (PMap->PMnext != 0 && PMap->PMadress != ap)
 9e0:	39 ce                	cmp    %ecx,%esi
 9e2:	74 10                	je     9f4 <pfree+0x84>
 9e4:	89 d0                	mov    %edx,%eax
 9e6:	8b 50 08             	mov    0x8(%eax),%edx
 9e9:	8b 48 04             	mov    0x4(%eax),%ecx
 9ec:	85 d2                	test   %edx,%edx
 9ee:	75 f0                	jne    9e0 <pfree+0x70>
                if (PMap->PMadress != ap) {
 9f0:	39 ce                	cmp    %ecx,%esi
 9f2:	75 65                	jne    a59 <pfree+0xe9>
                if (tmp->PMheaderID == PMap->PMheaderID) {//happens when both point on the first link
 9f4:	8b 08                	mov    (%eax),%ecx
 9f6:	39 0b                	cmp    %ecx,(%ebx)
 9f8:	75 08                	jne    a02 <pfree+0x92>
 9fa:	eb 44                	jmp    a40 <pfree+0xd0>
 9fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a00:	89 c3                	mov    %eax,%ebx
                    while (tmp->PMnext->PMheaderID != PMap->PMheaderID)
 a02:	8b 43 08             	mov    0x8(%ebx),%eax
 a05:	3b 08                	cmp    (%eax),%ecx
 a07:	75 f7                	jne    a00 <pfree+0x90>
                    tmp->PMnext = PMap->PMnext;
 a09:	89 53 08             	mov    %edx,0x8(%ebx)
}
 a0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
 a0f:	b8 01 00 00 00       	mov    $0x1,%eax
}
 a14:	5b                   	pop    %ebx
 a15:	5e                   	pop    %esi
 a16:	5d                   	pop    %ebp
 a17:	c3                   	ret    
 a18:	90                   	nop
 a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                PMinit = 0;
 a20:	c7 05 60 0e 00 00 00 	movl   $0x0,0xe60
 a27:	00 00 00 
                tail = 0;
 a2a:	c7 05 5c 0e 00 00 00 	movl   $0x0,0xe5c
 a31:	00 00 00 
}
 a34:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
 a37:	b8 01 00 00 00       	mov    $0x1,%eax
}
 a3c:	5b                   	pop    %ebx
 a3d:	5e                   	pop    %esi
 a3e:	5d                   	pop    %ebp
 a3f:	c3                   	ret    
                    PMinit = PMinit->PMnext;
 a40:	a1 60 0e 00 00       	mov    0xe60,%eax
 a45:	8b 40 08             	mov    0x8(%eax),%eax
 a48:	a3 60 0e 00 00       	mov    %eax,0xe60
}
 a4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
 a50:	b8 01 00 00 00       	mov    $0x1,%eax
}
 a55:	5b                   	pop    %ebx
 a56:	5e                   	pop    %esi
 a57:	5d                   	pop    %ebp
 a58:	c3                   	ret    
                    printf(2, "PROBLEM with ap:%d\n", ap);
 a59:	83 ec 04             	sub    $0x4,%esp
 a5c:	56                   	push   %esi
 a5d:	68 a5 0a 00 00       	push   $0xaa5
 a62:	6a 02                	push   $0x2
 a64:	e8 c7 f9 ff ff       	call   430 <printf>
                    return -1;
 a69:	83 c4 10             	add    $0x10,%esp
 a6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 a71:	e9 2b ff ff ff       	jmp    9a1 <pfree+0x31>
