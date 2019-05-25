
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 41                	jle    5f <main+0x5f>
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
  23:	eb 1b                	jmp    40 <main+0x40>
  25:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  28:	68 10 08 00 00       	push   $0x810
  2d:	ff 74 9f fc          	pushl  -0x4(%edi,%ebx,4)
  31:	68 12 08 00 00       	push   $0x812
  36:	6a 01                	push   $0x1
  38:	e8 c3 03 00 00       	call   400 <printf>
  3d:	83 c4 10             	add    $0x10,%esp
  40:	83 c3 01             	add    $0x1,%ebx
  43:	39 de                	cmp    %ebx,%esi
  45:	75 e1                	jne    28 <main+0x28>
  47:	68 17 08 00 00       	push   $0x817
  4c:	ff 74 b7 fc          	pushl  -0x4(%edi,%esi,4)
  50:	68 12 08 00 00       	push   $0x812
  55:	6a 01                	push   $0x1
  57:	e8 a4 03 00 00       	call   400 <printf>
  5c:	83 c4 10             	add    $0x10,%esp
  exit();
  5f:	e8 4e 02 00 00       	call   2b2 <exit>
  64:	66 90                	xchg   %ax,%ax
  66:	66 90                	xchg   %ax,%ax
  68:	66 90                	xchg   %ax,%ax
  6a:	66 90                	xchg   %ax,%ax
  6c:	66 90                	xchg   %ax,%ax
  6e:	66 90                	xchg   %ax,%ax

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	8b 45 08             	mov    0x8(%ebp),%eax
  77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	89 c2                	mov    %eax,%edx
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	83 c1 01             	add    $0x1,%ecx
  83:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  87:	83 c2 01             	add    $0x1,%edx
  8a:	84 db                	test   %bl,%bl
  8c:	88 5a ff             	mov    %bl,-0x1(%edx)
  8f:	75 ef                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  91:	5b                   	pop    %ebx
  92:	5d                   	pop    %ebp
  93:	c3                   	ret    
  94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	56                   	push   %esi
  a4:	53                   	push   %ebx
  a5:	8b 55 08             	mov    0x8(%ebp),%edx
  a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ab:	0f b6 02             	movzbl (%edx),%eax
  ae:	0f b6 19             	movzbl (%ecx),%ebx
  b1:	84 c0                	test   %al,%al
  b3:	75 1e                	jne    d3 <strcmp+0x33>
  b5:	eb 29                	jmp    e0 <strcmp+0x40>
  b7:	89 f6                	mov    %esi,%esi
  b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  c0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  c6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  cd:	84 c0                	test   %al,%al
  cf:	74 0f                	je     e0 <strcmp+0x40>
  d1:	89 f1                	mov    %esi,%ecx
  d3:	38 d8                	cmp    %bl,%al
  d5:	74 e9                	je     c0 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d7:	29 d8                	sub    %ebx,%eax
}
  d9:	5b                   	pop    %ebx
  da:	5e                   	pop    %esi
  db:	5d                   	pop    %ebp
  dc:	c3                   	ret    
  dd:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e0:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e2:	29 d8                	sub    %ebx,%eax
}
  e4:	5b                   	pop    %ebx
  e5:	5e                   	pop    %esi
  e6:	5d                   	pop    %ebp
  e7:	c3                   	ret    
  e8:	90                   	nop
  e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000f0 <strlen>:

uint
strlen(char *s)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  f6:	80 39 00             	cmpb   $0x0,(%ecx)
  f9:	74 12                	je     10d <strlen+0x1d>
  fb:	31 d2                	xor    %edx,%edx
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	83 c2 01             	add    $0x1,%edx
 103:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 107:	89 d0                	mov    %edx,%eax
 109:	75 f5                	jne    100 <strlen+0x10>
    ;
  return n;
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 10d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 10f:	5d                   	pop    %ebp
 110:	c3                   	ret    
 111:	eb 0d                	jmp    120 <memset>
 113:	90                   	nop
 114:	90                   	nop
 115:	90                   	nop
 116:	90                   	nop
 117:	90                   	nop
 118:	90                   	nop
 119:	90                   	nop
 11a:	90                   	nop
 11b:	90                   	nop
 11c:	90                   	nop
 11d:	90                   	nop
 11e:	90                   	nop
 11f:	90                   	nop

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	89 d0                	mov    %edx,%eax
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	89 f6                	mov    %esi,%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	53                   	push   %ebx
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	74 1d                	je     16e <strchr+0x2e>
    if(*s == c)
 151:	38 d3                	cmp    %dl,%bl
 153:	89 d9                	mov    %ebx,%ecx
 155:	75 0d                	jne    164 <strchr+0x24>
 157:	eb 17                	jmp    170 <strchr+0x30>
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 160:	38 ca                	cmp    %cl,%dl
 162:	74 0c                	je     170 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 164:	83 c0 01             	add    $0x1,%eax
 167:	0f b6 10             	movzbl (%eax),%edx
 16a:	84 d2                	test   %dl,%dl
 16c:	75 f2                	jne    160 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 16e:	31 c0                	xor    %eax,%eax
}
 170:	5b                   	pop    %ebx
 171:	5d                   	pop    %ebp
 172:	c3                   	ret    
 173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
 185:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 188:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 18b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18e:	eb 29                	jmp    1b9 <gets+0x39>
    cc = read(0, &c, 1);
 190:	83 ec 04             	sub    $0x4,%esp
 193:	6a 01                	push   $0x1
 195:	57                   	push   %edi
 196:	6a 00                	push   $0x0
 198:	e8 2d 01 00 00       	call   2ca <read>
    if(cc < 1)
 19d:	83 c4 10             	add    $0x10,%esp
 1a0:	85 c0                	test   %eax,%eax
 1a2:	7e 1d                	jle    1c1 <gets+0x41>
      break;
    buf[i++] = c;
 1a4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a8:	8b 55 08             	mov    0x8(%ebp),%edx
 1ab:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1ad:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 1af:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1b3:	74 1b                	je     1d0 <gets+0x50>
 1b5:	3c 0d                	cmp    $0xd,%al
 1b7:	74 17                	je     1d0 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b9:	8d 5e 01             	lea    0x1(%esi),%ebx
 1bc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1bf:	7c cf                	jl     190 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1cb:	5b                   	pop    %ebx
 1cc:	5e                   	pop    %esi
 1cd:	5f                   	pop    %edi
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    
 1e1:	eb 0d                	jmp    1f0 <stat>
 1e3:	90                   	nop
 1e4:	90                   	nop
 1e5:	90                   	nop
 1e6:	90                   	nop
 1e7:	90                   	nop
 1e8:	90                   	nop
 1e9:	90                   	nop
 1ea:	90                   	nop
 1eb:	90                   	nop
 1ec:	90                   	nop
 1ed:	90                   	nop
 1ee:	90                   	nop
 1ef:	90                   	nop

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
 217:	89 c6                	mov    %eax,%esi
  close(fd);
 219:	89 1c 24             	mov    %ebx,(%esp)
 21c:	e8 b9 00 00 00       	call   2da <close>
  return r;
 221:	83 c4 10             	add    $0x10,%esp
 224:	89 f0                	mov    %esi,%eax
}
 226:	8d 65 f8             	lea    -0x8(%ebp),%esp
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 235:	eb ef                	jmp    226 <stat+0x36>
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <atoi>:
  return r;
}

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
 24f:	b8 00 00 00 00       	mov    $0x0,%eax
 254:	77 1f                	ja     275 <atoi+0x35>
 256:	8d 76 00             	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 260:	8d 04 80             	lea    (%eax,%eax,4),%eax
 263:	83 c1 01             	add    $0x1,%ecx
 266:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26a:	0f be 11             	movsbl (%ecx),%edx
 26d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
    n = n*10 + *s++ - '0';
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
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a2:	39 da                	cmp    %ebx,%edx
 2a4:	75 f2                	jne    298 <memmove+0x18>
    *dst++ = *src++;
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
 3a1:	0f b6 92 20 08 00 00 	movzbl 0x820(%edx),%edx
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
 51b:	b8 19 08 00 00       	mov    $0x819,%eax
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
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a1:	a1 60 0b 00 00       	mov    0xb60,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a6:	89 e5                	mov    %esp,%ebp
 5a8:	57                   	push   %edi
 5a9:	56                   	push   %esi
 5aa:	53                   	push   %ebx
 5ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ae:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b3:	39 c8                	cmp    %ecx,%eax
 5b5:	73 19                	jae    5d0 <free+0x30>
 5b7:	89 f6                	mov    %esi,%esi
 5b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 5c0:	39 d1                	cmp    %edx,%ecx
 5c2:	72 1c                	jb     5e0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c4:	39 d0                	cmp    %edx,%eax
 5c6:	73 18                	jae    5e0 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c8:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ca:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5cc:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ce:	72 f0                	jb     5c0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d0:	39 d0                	cmp    %edx,%eax
 5d2:	72 f4                	jb     5c8 <free+0x28>
 5d4:	39 d1                	cmp    %edx,%ecx
 5d6:	73 f0                	jae    5c8 <free+0x28>
 5d8:	90                   	nop
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5e3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5e6:	39 d7                	cmp    %edx,%edi
 5e8:	74 19                	je     603 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ed:	8b 50 04             	mov    0x4(%eax),%edx
 5f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5f3:	39 f1                	cmp    %esi,%ecx
 5f5:	74 23                	je     61a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5f7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5f9:	a3 60 0b 00 00       	mov    %eax,0xb60
}
 5fe:	5b                   	pop    %ebx
 5ff:	5e                   	pop    %esi
 600:	5f                   	pop    %edi
 601:	5d                   	pop    %ebp
 602:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 603:	03 72 04             	add    0x4(%edx),%esi
 606:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 609:	8b 10                	mov    (%eax),%edx
 60b:	8b 12                	mov    (%edx),%edx
 60d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 610:	8b 50 04             	mov    0x4(%eax),%edx
 613:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 616:	39 f1                	cmp    %esi,%ecx
 618:	75 dd                	jne    5f7 <free+0x57>
    p->s.size += bp->s.size;
 61a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 61d:	a3 60 0b 00 00       	mov    %eax,0xb60
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 622:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 625:	8b 53 f8             	mov    -0x8(%ebx),%edx
 628:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 62a:	5b                   	pop    %ebx
 62b:	5e                   	pop    %esi
 62c:	5f                   	pop    %edi
 62d:	5d                   	pop    %ebp
 62e:	c3                   	ret    
 62f:	90                   	nop

00000630 <morecore>:

static Header*
morecore(uint nu)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	53                   	push   %ebx
 634:	83 ec 04             	sub    $0x4,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 637:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 63c:	76 3a                	jbe    678 <morecore+0x48>
 63e:	89 c3                	mov    %eax,%ebx
 640:	8d 04 c5 00 00 00 00 	lea    0x0(,%eax,8),%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 647:	83 ec 0c             	sub    $0xc,%esp
 64a:	50                   	push   %eax
 64b:	e8 ea fc ff ff       	call   33a <sbrk>
  if(p == (char*)-1)
 650:	83 c4 10             	add    $0x10,%esp
 653:	83 f8 ff             	cmp    $0xffffffff,%eax
 656:	74 30                	je     688 <morecore+0x58>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 658:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 65b:	83 ec 0c             	sub    $0xc,%esp
 65e:	83 c0 08             	add    $0x8,%eax
 661:	50                   	push   %eax
 662:	e8 39 ff ff ff       	call   5a0 <free>
  return freep;
 667:	a1 60 0b 00 00       	mov    0xb60,%eax
 66c:	83 c4 10             	add    $0x10,%esp
}
 66f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 672:	c9                   	leave  
 673:	c3                   	ret    
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 678:	b8 00 80 00 00       	mov    $0x8000,%eax
{
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
 67d:	bb 00 10 00 00       	mov    $0x1000,%ebx
 682:	eb c3                	jmp    647 <morecore+0x17>
 684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
 688:	31 c0                	xor    %eax,%eax
 68a:	eb e3                	jmp    66f <morecore+0x3f>
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000690 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	53                   	push   %ebx
 694:	83 ec 04             	sub    $0x4,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 697:	8b 45 08             	mov    0x8(%ebp),%eax
 69a:	8d 58 07             	lea    0x7(%eax),%ebx
    if((prevp = freep) == 0){
 69d:	a1 60 0b 00 00       	mov    0xb60,%eax
malloc(uint nbytes)
{
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a2:	c1 eb 03             	shr    $0x3,%ebx
 6a5:	83 c3 01             	add    $0x1,%ebx
    if((prevp = freep) == 0){
 6a8:	85 c0                	test   %eax,%eax
 6aa:	74 52                	je     6fe <malloc+0x6e>
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b0:	8b 10                	mov    (%eax),%edx
        if(p->s.size >= nunits){
 6b2:	8b 4a 04             	mov    0x4(%edx),%ecx
 6b5:	39 cb                	cmp    %ecx,%ebx
 6b7:	76 1f                	jbe    6d8 <malloc+0x48>
                p->s.size = nunits;
            }
            freep = prevp;
            return (void*)(p + 1);
        }
        if(p == freep)
 6b9:	39 15 60 0b 00 00    	cmp    %edx,0xb60
 6bf:	89 d0                	mov    %edx,%eax
 6c1:	75 ed                	jne    6b0 <malloc+0x20>
            if((p = morecore(nunits)) == 0)
 6c3:	89 d8                	mov    %ebx,%eax
 6c5:	e8 66 ff ff ff       	call   630 <morecore>
 6ca:	85 c0                	test   %eax,%eax
 6cc:	75 e2                	jne    6b0 <malloc+0x20>
                return 0;
 6ce:	31 c0                	xor    %eax,%eax
 6d0:	eb 1d                	jmp    6ef <malloc+0x5f>
 6d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size >= nunits){
            if(p->s.size == nunits)
 6d8:	39 cb                	cmp    %ecx,%ebx
 6da:	74 1c                	je     6f8 <malloc+0x68>
                prevp->s.ptr = p->s.ptr;
            else {
                p->s.size -= nunits;
 6dc:	29 d9                	sub    %ebx,%ecx
 6de:	89 4a 04             	mov    %ecx,0x4(%edx)
                p += p->s.size;
 6e1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
                p->s.size = nunits;
 6e4:	89 5a 04             	mov    %ebx,0x4(%edx)
            }
            freep = prevp;
 6e7:	a3 60 0b 00 00       	mov    %eax,0xb60
            return (void*)(p + 1);
 6ec:	8d 42 08             	lea    0x8(%edx),%eax
        }
        if(p == freep)
            if((p = morecore(nunits)) == 0)
                return 0;
    }
}
 6ef:	83 c4 04             	add    $0x4,%esp
 6f2:	5b                   	pop    %ebx
 6f3:	5d                   	pop    %ebp
 6f4:	c3                   	ret    
 6f5:	8d 76 00             	lea    0x0(%esi),%esi
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size >= nunits){
            if(p->s.size == nunits)
                prevp->s.ptr = p->s.ptr;
 6f8:	8b 0a                	mov    (%edx),%ecx
 6fa:	89 08                	mov    %ecx,(%eax)
 6fc:	eb e9                	jmp    6e7 <malloc+0x57>
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
        base.s.ptr = freep = prevp = &base;
 6fe:	c7 05 60 0b 00 00 64 	movl   $0xb64,0xb60
 705:	0b 00 00 
 708:	c7 05 64 0b 00 00 64 	movl   $0xb64,0xb64
 70f:	0b 00 00 
        base.s.size = 0;
 712:	ba 64 0b 00 00       	mov    $0xb64,%edx
 717:	c7 05 68 0b 00 00 00 	movl   $0x0,0xb68
 71e:	00 00 00 
 721:	eb 96                	jmp    6b9 <malloc+0x29>
 723:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000730 <pmalloc>:

// TODO we are not sure where we should do the page protected and read only PTE_W...

void*
pmalloc()
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	83 ec 08             	sub    $0x8,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = ( 4096 + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
 736:	a1 60 0b 00 00       	mov    0xb60,%eax
 73b:	85 c0                	test   %eax,%eax
 73d:	74 46                	je     785 <pmalloc+0x55>
 73f:	90                   	nop
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 740:	8b 10                	mov    (%eax),%edx
        if(p->s.size == nunits){
 742:	81 7a 04 01 02 00 00 	cmpl   $0x201,0x4(%edx)
 749:	74 25                	je     770 <pmalloc+0x40>
            freep = prevp;
            (p+1)->x = 1;
            return (void*)(p + 1);
        }

        if(p == freep)
 74b:	39 15 60 0b 00 00    	cmp    %edx,0xb60
 751:	89 d0                	mov    %edx,%eax
 753:	75 eb                	jne    740 <pmalloc+0x10>
            if((p = morecore(nunits)) == 0)
 755:	b8 01 02 00 00       	mov    $0x201,%eax
 75a:	e8 d1 fe ff ff       	call   630 <morecore>
 75f:	85 c0                	test   %eax,%eax
 761:	75 dd                	jne    740 <pmalloc+0x10>
                return 0;
 763:	31 c0                	xor    %eax,%eax
    }
}
 765:	c9                   	leave  
 766:	c3                   	ret    
 767:	89 f6                	mov    %esi,%esi
 769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size == nunits){
            prevp->s.ptr = p->s.ptr;
 770:	8b 0a                	mov    (%edx),%ecx
            freep = prevp;
 772:	a3 60 0b 00 00       	mov    %eax,0xb60
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size == nunits){
            prevp->s.ptr = p->s.ptr;
 777:	89 08                	mov    %ecx,(%eax)
            freep = prevp;
            (p+1)->x = 1;
 779:	c7 42 08 01 00 00 00 	movl   $0x1,0x8(%edx)
            return (void*)(p + 1);
 780:	8d 42 08             	lea    0x8(%edx),%eax

        if(p == freep)
            if((p = morecore(nunits)) == 0)
                return 0;
    }
}
 783:	c9                   	leave  
 784:	c3                   	ret    
    Header *p, *prevp;
    uint nunits;

    nunits = ( 4096 + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
        base.s.ptr = freep = prevp = &base;
 785:	c7 05 60 0b 00 00 64 	movl   $0xb64,0xb60
 78c:	0b 00 00 
 78f:	c7 05 64 0b 00 00 64 	movl   $0xb64,0xb64
 796:	0b 00 00 
        base.s.size = 0;
 799:	ba 64 0b 00 00       	mov    $0xb64,%edx
 79e:	c7 05 68 0b 00 00 00 	movl   $0x0,0xb68
 7a5:	00 00 00 
 7a8:	eb a1                	jmp    74b <pmalloc+0x1b>
 7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000007b0 <protect_page>:
    }
}


int protect_page(void* ap)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
    Header *p;
    if( ap )
 7b6:	85 c0                	test   %eax,%eax
 7b8:	74 1e                	je     7d8 <protect_page+0x28>
    {
        if( (uint)ap % 4096 != 0 )
 7ba:	a9 ff 0f 00 00       	test   $0xfff,%eax
 7bf:	75 17                	jne    7d8 <protect_page+0x28>
            return -1;

        p = ap;
        if( !p->pmalloced )
 7c1:	8b 10                	mov    (%eax),%edx
 7c3:	85 d2                	test   %edx,%edx
 7c5:	74 11                	je     7d8 <protect_page+0x28>
            return -1;

        p->protected = 1;
 7c7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        return 1;
 7cd:	b8 01 00 00 00       	mov    $0x1,%eax
    }
    else
        return -1;
}
 7d2:	5d                   	pop    %ebp
 7d3:	c3                   	ret    
 7d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

        p->protected = 1;
        return 1;
    }
    else
        return -1;
 7d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 7dd:	5d                   	pop    %ebp
 7de:	c3                   	ret    
 7df:	90                   	nop

000007e0 <pfree>:



int pfree(void* ap) {
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	8b 45 08             	mov    0x8(%ebp),%eax
    Header *p;
    if (ap) {
 7e6:	85 c0                	test   %eax,%eax
 7e8:	74 1e                	je     808 <pfree+0x28>
        if ((uint) ap % 4096 != 0)
 7ea:	a9 ff 0f 00 00       	test   $0xfff,%eax
 7ef:	75 17                	jne    808 <pfree+0x28>
            return -1;

        p = ap;
        if (p->protected) {
 7f1:	8b 10                	mov    (%eax),%edx
 7f3:	85 d2                	test   %edx,%edx
 7f5:	74 11                	je     808 <pfree+0x28>
            free(ap);
 7f7:	50                   	push   %eax
 7f8:	e8 a3 fd ff ff       	call   5a0 <free>
            return 1;
 7fd:	58                   	pop    %eax
 7fe:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    return -1;
}
 803:	c9                   	leave  
 804:	c3                   	ret    
 805:	8d 76 00             	lea    0x0(%esi),%esi
        if (p->protected) {
            free(ap);
            return 1;
        }
    }
    return -1;
 808:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 80d:	c9                   	leave  
 80e:	c3                   	ret    
