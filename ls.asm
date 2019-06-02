
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
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
  1b:	7e 24                	jle    41 <main+0x41>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	83 c3 04             	add    $0x4,%ebx
  30:	e8 cb 00 00 00       	call   100 <ls>
  for(i=1; i<argc; i++)
  35:	83 c4 10             	add    $0x10,%esp
  38:	39 f3                	cmp    %esi,%ebx
  3a:	75 ec                	jne    28 <main+0x28>
  exit();
  3c:	e8 41 05 00 00       	call   582 <exit>
    ls(".");
  41:	83 ec 0c             	sub    $0xc,%esp
  44:	68 90 0d 00 00       	push   $0xd90
  49:	e8 b2 00 00 00       	call   100 <ls>
    exit();
  4e:	e8 2f 05 00 00       	call   582 <exit>
  53:	66 90                	xchg   %ax,%ax
  55:	66 90                	xchg   %ax,%ax
  57:	66 90                	xchg   %ax,%ax
  59:	66 90                	xchg   %ax,%ax
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <fmtname>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	53                   	push   %ebx
  6c:	e8 3f 03 00 00       	call   3b0 <strlen>
  71:	83 c4 10             	add    $0x10,%esp
  74:	01 d8                	add    %ebx,%eax
  76:	73 0f                	jae    87 <fmtname+0x27>
  78:	eb 12                	jmp    8c <fmtname+0x2c>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  80:	83 e8 01             	sub    $0x1,%eax
  83:	39 c3                	cmp    %eax,%ebx
  85:	77 05                	ja     8c <fmtname+0x2c>
  87:	80 38 2f             	cmpb   $0x2f,(%eax)
  8a:	75 f4                	jne    80 <fmtname+0x20>
  p++;
  8c:	8d 58 01             	lea    0x1(%eax),%ebx
  if(strlen(p) >= DIRSIZ)
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	53                   	push   %ebx
  93:	e8 18 03 00 00       	call   3b0 <strlen>
  98:	83 c4 10             	add    $0x10,%esp
  9b:	83 f8 0d             	cmp    $0xd,%eax
  9e:	77 4a                	ja     ea <fmtname+0x8a>
  memmove(buf, p, strlen(p));
  a0:	83 ec 0c             	sub    $0xc,%esp
  a3:	53                   	push   %ebx
  a4:	e8 07 03 00 00       	call   3b0 <strlen>
  a9:	83 c4 0c             	add    $0xc,%esp
  ac:	50                   	push   %eax
  ad:	53                   	push   %ebx
  ae:	68 d4 11 00 00       	push   $0x11d4
  b3:	e8 98 04 00 00       	call   550 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  b8:	89 1c 24             	mov    %ebx,(%esp)
  bb:	e8 f0 02 00 00       	call   3b0 <strlen>
  c0:	89 1c 24             	mov    %ebx,(%esp)
  c3:	89 c6                	mov    %eax,%esi
  return buf;
  c5:	bb d4 11 00 00       	mov    $0x11d4,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	e8 e1 02 00 00       	call   3b0 <strlen>
  cf:	ba 0e 00 00 00       	mov    $0xe,%edx
  d4:	83 c4 0c             	add    $0xc,%esp
  d7:	05 d4 11 00 00       	add    $0x11d4,%eax
  dc:	29 f2                	sub    %esi,%edx
  de:	52                   	push   %edx
  df:	6a 20                	push   $0x20
  e1:	50                   	push   %eax
  e2:	e8 f9 02 00 00       	call   3e0 <memset>
  return buf;
  e7:	83 c4 10             	add    $0x10,%esp
}
  ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ed:	89 d8                	mov    %ebx,%eax
  ef:	5b                   	pop    %ebx
  f0:	5e                   	pop    %esi
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    
  f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <ls>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 64 02 00 00    	sub    $0x264,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
 10f:	6a 00                	push   $0x0
 111:	57                   	push   %edi
 112:	e8 ab 04 00 00       	call   5c2 <open>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	78 52                	js     170 <ls+0x70>
  if(fstat(fd, &st) < 0){
 11e:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 124:	83 ec 08             	sub    $0x8,%esp
 127:	89 c3                	mov    %eax,%ebx
 129:	56                   	push   %esi
 12a:	50                   	push   %eax
 12b:	e8 aa 04 00 00       	call   5da <fstat>
 130:	83 c4 10             	add    $0x10,%esp
 133:	85 c0                	test   %eax,%eax
 135:	0f 88 c5 00 00 00    	js     200 <ls+0x100>
  switch(st.type){
 13b:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 142:	66 83 f8 01          	cmp    $0x1,%ax
 146:	0f 84 84 00 00 00    	je     1d0 <ls+0xd0>
 14c:	66 83 f8 02          	cmp    $0x2,%ax
 150:	74 3e                	je     190 <ls+0x90>
  close(fd);
 152:	83 ec 0c             	sub    $0xc,%esp
 155:	53                   	push   %ebx
 156:	e8 4f 04 00 00       	call   5aa <close>
 15b:	83 c4 10             	add    $0x10,%esp
}
 15e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 161:	5b                   	pop    %ebx
 162:	5e                   	pop    %esi
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    
 166:	8d 76 00             	lea    0x0(%esi),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    printf(2, "ls: cannot open %s\n", path);
 170:	83 ec 04             	sub    $0x4,%esp
 173:	57                   	push   %edi
 174:	68 48 0d 00 00       	push   $0xd48
 179:	6a 02                	push   $0x2
 17b:	e8 80 05 00 00       	call   700 <printf>
    return;
 180:	83 c4 10             	add    $0x10,%esp
}
 183:	8d 65 f4             	lea    -0xc(%ebp),%esp
 186:	5b                   	pop    %ebx
 187:	5e                   	pop    %esi
 188:	5f                   	pop    %edi
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    
 18b:	90                   	nop
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 190:	83 ec 0c             	sub    $0xc,%esp
 193:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 199:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 19f:	57                   	push   %edi
 1a0:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 1a6:	e8 b5 fe ff ff       	call   60 <fmtname>
 1ab:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 1b1:	59                   	pop    %ecx
 1b2:	5f                   	pop    %edi
 1b3:	52                   	push   %edx
 1b4:	56                   	push   %esi
 1b5:	6a 02                	push   $0x2
 1b7:	50                   	push   %eax
 1b8:	68 70 0d 00 00       	push   $0xd70
 1bd:	6a 01                	push   $0x1
 1bf:	e8 3c 05 00 00       	call   700 <printf>
    break;
 1c4:	83 c4 20             	add    $0x20,%esp
 1c7:	eb 89                	jmp    152 <ls+0x52>
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1d0:	83 ec 0c             	sub    $0xc,%esp
 1d3:	57                   	push   %edi
 1d4:	e8 d7 01 00 00       	call   3b0 <strlen>
 1d9:	83 c0 10             	add    $0x10,%eax
 1dc:	83 c4 10             	add    $0x10,%esp
 1df:	3d 00 02 00 00       	cmp    $0x200,%eax
 1e4:	76 42                	jbe    228 <ls+0x128>
      printf(1, "ls: path too long\n");
 1e6:	83 ec 08             	sub    $0x8,%esp
 1e9:	68 7d 0d 00 00       	push   $0xd7d
 1ee:	6a 01                	push   $0x1
 1f0:	e8 0b 05 00 00       	call   700 <printf>
      break;
 1f5:	83 c4 10             	add    $0x10,%esp
 1f8:	e9 55 ff ff ff       	jmp    152 <ls+0x52>
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "ls: cannot stat %s\n", path);
 200:	83 ec 04             	sub    $0x4,%esp
 203:	57                   	push   %edi
 204:	68 5c 0d 00 00       	push   $0xd5c
 209:	6a 02                	push   $0x2
 20b:	e8 f0 04 00 00       	call   700 <printf>
    close(fd);
 210:	89 1c 24             	mov    %ebx,(%esp)
 213:	e8 92 03 00 00       	call   5aa <close>
    return;
 218:	83 c4 10             	add    $0x10,%esp
}
 21b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21e:	5b                   	pop    %ebx
 21f:	5e                   	pop    %esi
 220:	5f                   	pop    %edi
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    
 223:	90                   	nop
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    strcpy(buf, path);
 228:	83 ec 08             	sub    $0x8,%esp
 22b:	57                   	push   %edi
 22c:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 232:	57                   	push   %edi
 233:	e8 f8 00 00 00       	call   330 <strcpy>
    p = buf+strlen(buf);
 238:	89 3c 24             	mov    %edi,(%esp)
 23b:	e8 70 01 00 00       	call   3b0 <strlen>
 240:	01 f8                	add    %edi,%eax
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 242:	83 c4 10             	add    $0x10,%esp
    *p++ = '/';
 245:	8d 48 01             	lea    0x1(%eax),%ecx
    p = buf+strlen(buf);
 248:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    *p++ = '/';
 24e:	c6 00 2f             	movb   $0x2f,(%eax)
 251:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 257:	89 f6                	mov    %esi,%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 260:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 266:	83 ec 04             	sub    $0x4,%esp
 269:	6a 10                	push   $0x10
 26b:	50                   	push   %eax
 26c:	53                   	push   %ebx
 26d:	e8 28 03 00 00       	call   59a <read>
 272:	83 c4 10             	add    $0x10,%esp
 275:	83 f8 10             	cmp    $0x10,%eax
 278:	0f 85 d4 fe ff ff    	jne    152 <ls+0x52>
      if(de.inum == 0)
 27e:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 285:	00 
 286:	74 d8                	je     260 <ls+0x160>
      memmove(p, de.name, DIRSIZ);
 288:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 28e:	83 ec 04             	sub    $0x4,%esp
 291:	6a 0e                	push   $0xe
 293:	50                   	push   %eax
 294:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 29a:	e8 b1 02 00 00       	call   550 <memmove>
      p[DIRSIZ] = 0;
 29f:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 2a5:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 2a9:	58                   	pop    %eax
 2aa:	5a                   	pop    %edx
 2ab:	56                   	push   %esi
 2ac:	57                   	push   %edi
 2ad:	e8 0e 02 00 00       	call   4c0 <stat>
 2b2:	83 c4 10             	add    $0x10,%esp
 2b5:	85 c0                	test   %eax,%eax
 2b7:	78 5f                	js     318 <ls+0x218>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 2b9:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 2c0:	83 ec 0c             	sub    $0xc,%esp
 2c3:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 2c9:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 2cf:	57                   	push   %edi
 2d0:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 2d6:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 2dc:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 2e2:	e8 79 fd ff ff       	call   60 <fmtname>
 2e7:	5a                   	pop    %edx
 2e8:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 2ee:	59                   	pop    %ecx
 2ef:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 2f5:	51                   	push   %ecx
 2f6:	52                   	push   %edx
 2f7:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 2fd:	50                   	push   %eax
 2fe:	68 70 0d 00 00       	push   $0xd70
 303:	6a 01                	push   $0x1
 305:	e8 f6 03 00 00       	call   700 <printf>
 30a:	83 c4 20             	add    $0x20,%esp
 30d:	e9 4e ff ff ff       	jmp    260 <ls+0x160>
 312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "ls: cannot stat %s\n", buf);
 318:	83 ec 04             	sub    $0x4,%esp
 31b:	57                   	push   %edi
 31c:	68 5c 0d 00 00       	push   $0xd5c
 321:	6a 01                	push   $0x1
 323:	e8 d8 03 00 00       	call   700 <printf>
        continue;
 328:	83 c4 10             	add    $0x10,%esp
 32b:	e9 30 ff ff ff       	jmp    260 <ls+0x160>

00000330 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 33a:	89 c2                	mov    %eax,%edx
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 340:	83 c1 01             	add    $0x1,%ecx
 343:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 347:	83 c2 01             	add    $0x1,%edx
 34a:	84 db                	test   %bl,%bl
 34c:	88 5a ff             	mov    %bl,-0x1(%edx)
 34f:	75 ef                	jne    340 <strcpy+0x10>
    ;
  return os;
}
 351:	5b                   	pop    %ebx
 352:	5d                   	pop    %ebp
 353:	c3                   	ret    
 354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 35a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 55 08             	mov    0x8(%ebp),%edx
 367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 36a:	0f b6 02             	movzbl (%edx),%eax
 36d:	0f b6 19             	movzbl (%ecx),%ebx
 370:	84 c0                	test   %al,%al
 372:	75 1c                	jne    390 <strcmp+0x30>
 374:	eb 2a                	jmp    3a0 <strcmp+0x40>
 376:	8d 76 00             	lea    0x0(%esi),%esi
 379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 380:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 383:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 386:	83 c1 01             	add    $0x1,%ecx
 389:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 38c:	84 c0                	test   %al,%al
 38e:	74 10                	je     3a0 <strcmp+0x40>
 390:	38 d8                	cmp    %bl,%al
 392:	74 ec                	je     380 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 394:	29 d8                	sub    %ebx,%eax
}
 396:	5b                   	pop    %ebx
 397:	5d                   	pop    %ebp
 398:	c3                   	ret    
 399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3a2:	29 d8                	sub    %ebx,%eax
}
 3a4:	5b                   	pop    %ebx
 3a5:	5d                   	pop    %ebp
 3a6:	c3                   	ret    
 3a7:	89 f6                	mov    %esi,%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <strlen>:

uint
strlen(char *s)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3b6:	80 39 00             	cmpb   $0x0,(%ecx)
 3b9:	74 15                	je     3d0 <strlen+0x20>
 3bb:	31 d2                	xor    %edx,%edx
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	83 c2 01             	add    $0x1,%edx
 3c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3c7:	89 d0                	mov    %edx,%eax
 3c9:	75 f5                	jne    3c0 <strlen+0x10>
    ;
  return n;
}
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 3d0:	31 c0                	xor    %eax,%eax
}
 3d2:	5d                   	pop    %ebp
 3d3:	c3                   	ret    
 3d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	89 d7                	mov    %edx,%edi
 3ef:	fc                   	cld    
 3f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3f2:	89 d0                	mov    %edx,%eax
 3f4:	5f                   	pop    %edi
 3f5:	5d                   	pop    %ebp
 3f6:	c3                   	ret    
 3f7:	89 f6                	mov    %esi,%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <strchr>:

char*
strchr(const char *s, char c)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	53                   	push   %ebx
 404:	8b 45 08             	mov    0x8(%ebp),%eax
 407:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 40a:	0f b6 10             	movzbl (%eax),%edx
 40d:	84 d2                	test   %dl,%dl
 40f:	74 1d                	je     42e <strchr+0x2e>
    if(*s == c)
 411:	38 d3                	cmp    %dl,%bl
 413:	89 d9                	mov    %ebx,%ecx
 415:	75 0d                	jne    424 <strchr+0x24>
 417:	eb 17                	jmp    430 <strchr+0x30>
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 420:	38 ca                	cmp    %cl,%dl
 422:	74 0c                	je     430 <strchr+0x30>
  for(; *s; s++)
 424:	83 c0 01             	add    $0x1,%eax
 427:	0f b6 10             	movzbl (%eax),%edx
 42a:	84 d2                	test   %dl,%dl
 42c:	75 f2                	jne    420 <strchr+0x20>
      return (char*)s;
  return 0;
 42e:	31 c0                	xor    %eax,%eax
}
 430:	5b                   	pop    %ebx
 431:	5d                   	pop    %ebp
 432:	c3                   	ret    
 433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000440 <gets>:

char*
gets(char *buf, int max)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 446:	31 f6                	xor    %esi,%esi
 448:	89 f3                	mov    %esi,%ebx
{
 44a:	83 ec 1c             	sub    $0x1c,%esp
 44d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 450:	eb 2f                	jmp    481 <gets+0x41>
 452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 458:	8d 45 e7             	lea    -0x19(%ebp),%eax
 45b:	83 ec 04             	sub    $0x4,%esp
 45e:	6a 01                	push   $0x1
 460:	50                   	push   %eax
 461:	6a 00                	push   $0x0
 463:	e8 32 01 00 00       	call   59a <read>
    if(cc < 1)
 468:	83 c4 10             	add    $0x10,%esp
 46b:	85 c0                	test   %eax,%eax
 46d:	7e 1c                	jle    48b <gets+0x4b>
      break;
    buf[i++] = c;
 46f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 473:	83 c7 01             	add    $0x1,%edi
 476:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 479:	3c 0a                	cmp    $0xa,%al
 47b:	74 23                	je     4a0 <gets+0x60>
 47d:	3c 0d                	cmp    $0xd,%al
 47f:	74 1f                	je     4a0 <gets+0x60>
  for(i=0; i+1 < max; ){
 481:	83 c3 01             	add    $0x1,%ebx
 484:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 487:	89 fe                	mov    %edi,%esi
 489:	7c cd                	jl     458 <gets+0x18>
 48b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 490:	c6 03 00             	movb   $0x0,(%ebx)
}
 493:	8d 65 f4             	lea    -0xc(%ebp),%esp
 496:	5b                   	pop    %ebx
 497:	5e                   	pop    %esi
 498:	5f                   	pop    %edi
 499:	5d                   	pop    %ebp
 49a:	c3                   	ret    
 49b:	90                   	nop
 49c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a0:	8b 75 08             	mov    0x8(%ebp),%esi
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	01 de                	add    %ebx,%esi
 4a8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4aa:	c6 03 00             	movb   $0x0,(%ebx)
}
 4ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b0:	5b                   	pop    %ebx
 4b1:	5e                   	pop    %esi
 4b2:	5f                   	pop    %edi
 4b3:	5d                   	pop    %ebp
 4b4:	c3                   	ret    
 4b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004c0 <stat>:

int
stat(char *n, struct stat *st)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	56                   	push   %esi
 4c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c5:	83 ec 08             	sub    $0x8,%esp
 4c8:	6a 00                	push   $0x0
 4ca:	ff 75 08             	pushl  0x8(%ebp)
 4cd:	e8 f0 00 00 00       	call   5c2 <open>
  if(fd < 0)
 4d2:	83 c4 10             	add    $0x10,%esp
 4d5:	85 c0                	test   %eax,%eax
 4d7:	78 27                	js     500 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4d9:	83 ec 08             	sub    $0x8,%esp
 4dc:	ff 75 0c             	pushl  0xc(%ebp)
 4df:	89 c3                	mov    %eax,%ebx
 4e1:	50                   	push   %eax
 4e2:	e8 f3 00 00 00       	call   5da <fstat>
  close(fd);
 4e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ea:	89 c6                	mov    %eax,%esi
  close(fd);
 4ec:	e8 b9 00 00 00       	call   5aa <close>
  return r;
 4f1:	83 c4 10             	add    $0x10,%esp
}
 4f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4f7:	89 f0                	mov    %esi,%eax
 4f9:	5b                   	pop    %ebx
 4fa:	5e                   	pop    %esi
 4fb:	5d                   	pop    %ebp
 4fc:	c3                   	ret    
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 500:	be ff ff ff ff       	mov    $0xffffffff,%esi
 505:	eb ed                	jmp    4f4 <stat+0x34>
 507:	89 f6                	mov    %esi,%esi
 509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000510 <atoi>:

int
atoi(const char *s)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	53                   	push   %ebx
 514:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 517:	0f be 11             	movsbl (%ecx),%edx
 51a:	8d 42 d0             	lea    -0x30(%edx),%eax
 51d:	3c 09                	cmp    $0x9,%al
  n = 0;
 51f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 524:	77 1f                	ja     545 <atoi+0x35>
 526:	8d 76 00             	lea    0x0(%esi),%esi
 529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 530:	8d 04 80             	lea    (%eax,%eax,4),%eax
 533:	83 c1 01             	add    $0x1,%ecx
 536:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 53a:	0f be 11             	movsbl (%ecx),%edx
 53d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 540:	80 fb 09             	cmp    $0x9,%bl
 543:	76 eb                	jbe    530 <atoi+0x20>
  return n;
}
 545:	5b                   	pop    %ebx
 546:	5d                   	pop    %ebp
 547:	c3                   	ret    
 548:	90                   	nop
 549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000550 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	56                   	push   %esi
 554:	53                   	push   %ebx
 555:	8b 5d 10             	mov    0x10(%ebp),%ebx
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 55e:	85 db                	test   %ebx,%ebx
 560:	7e 14                	jle    576 <memmove+0x26>
 562:	31 d2                	xor    %edx,%edx
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 568:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 56c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 56f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 572:	39 d3                	cmp    %edx,%ebx
 574:	75 f2                	jne    568 <memmove+0x18>
  return vdst;
}
 576:	5b                   	pop    %ebx
 577:	5e                   	pop    %esi
 578:	5d                   	pop    %ebp
 579:	c3                   	ret    

0000057a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 57a:	b8 01 00 00 00       	mov    $0x1,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <exit>:
SYSCALL(exit)
 582:	b8 02 00 00 00       	mov    $0x2,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <wait>:
SYSCALL(wait)
 58a:	b8 03 00 00 00       	mov    $0x3,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <pipe>:
SYSCALL(pipe)
 592:	b8 04 00 00 00       	mov    $0x4,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <read>:
SYSCALL(read)
 59a:	b8 05 00 00 00       	mov    $0x5,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <write>:
SYSCALL(write)
 5a2:	b8 10 00 00 00       	mov    $0x10,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <close>:
SYSCALL(close)
 5aa:	b8 15 00 00 00       	mov    $0x15,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <kill>:
SYSCALL(kill)
 5b2:	b8 06 00 00 00       	mov    $0x6,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <exec>:
SYSCALL(exec)
 5ba:	b8 07 00 00 00       	mov    $0x7,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <open>:
SYSCALL(open)
 5c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <mknod>:
SYSCALL(mknod)
 5ca:	b8 11 00 00 00       	mov    $0x11,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <unlink>:
SYSCALL(unlink)
 5d2:	b8 12 00 00 00       	mov    $0x12,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <fstat>:
SYSCALL(fstat)
 5da:	b8 08 00 00 00       	mov    $0x8,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <link>:
SYSCALL(link)
 5e2:	b8 13 00 00 00       	mov    $0x13,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <mkdir>:
SYSCALL(mkdir)
 5ea:	b8 14 00 00 00       	mov    $0x14,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <chdir>:
SYSCALL(chdir)
 5f2:	b8 09 00 00 00       	mov    $0x9,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <dup>:
SYSCALL(dup)
 5fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <getpid>:
SYSCALL(getpid)
 602:	b8 0b 00 00 00       	mov    $0xb,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <sbrk>:
SYSCALL(sbrk)
 60a:	b8 0c 00 00 00       	mov    $0xc,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <sleep>:
SYSCALL(sleep)
 612:	b8 0d 00 00 00       	mov    $0xd,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <uptime>:
SYSCALL(uptime)
 61a:	b8 0e 00 00 00       	mov    $0xe,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <turnOnPM>:
SYSCALL(turnOnPM)
 622:	b8 17 00 00 00       	mov    $0x17,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <checkOnPM>:
SYSCALL(checkOnPM)
 62a:	b8 18 00 00 00       	mov    $0x18,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <turnOffW>:
SYSCALL(turnOffW)
 632:	b8 19 00 00 00       	mov    $0x19,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <turnOnW>:
SYSCALL(turnOnW)
 63a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <turnOffPM>:
SYSCALL(turnOffPM)
 642:	b8 1b 00 00 00       	mov    $0x1b,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <updatePTE>:
SYSCALL(updatePTE)
 64a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <updateProc>:
SYSCALL(updateProc)
 652:	b8 1d 00 00 00       	mov    $0x1d,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    
 65a:	66 90                	xchg   %ax,%ax
 65c:	66 90                	xchg   %ax,%ax
 65e:	66 90                	xchg   %ax,%ax

00000660 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 669:	85 d2                	test   %edx,%edx
{
 66b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 66e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 670:	79 76                	jns    6e8 <printint+0x88>
 672:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 676:	74 70                	je     6e8 <printint+0x88>
    x = -xx;
 678:	f7 d8                	neg    %eax
    neg = 1;
 67a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 681:	31 f6                	xor    %esi,%esi
 683:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 686:	eb 0a                	jmp    692 <printint+0x32>
 688:	90                   	nop
 689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 690:	89 fe                	mov    %edi,%esi
 692:	31 d2                	xor    %edx,%edx
 694:	8d 7e 01             	lea    0x1(%esi),%edi
 697:	f7 f1                	div    %ecx
 699:	0f b6 92 9c 0d 00 00 	movzbl 0xd9c(%edx),%edx
  }while((x /= base) != 0);
 6a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 6a2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 6a5:	75 e9                	jne    690 <printint+0x30>
  if(neg)
 6a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6aa:	85 c0                	test   %eax,%eax
 6ac:	74 08                	je     6b6 <printint+0x56>
    buf[i++] = '-';
 6ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 6b3:	8d 7e 02             	lea    0x2(%esi),%edi
 6b6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 6ba:	8b 7d c0             	mov    -0x40(%ebp),%edi
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
 6c0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 6c3:	83 ec 04             	sub    $0x4,%esp
 6c6:	83 ee 01             	sub    $0x1,%esi
 6c9:	6a 01                	push   $0x1
 6cb:	53                   	push   %ebx
 6cc:	57                   	push   %edi
 6cd:	88 45 d7             	mov    %al,-0x29(%ebp)
 6d0:	e8 cd fe ff ff       	call   5a2 <write>

  while(--i >= 0)
 6d5:	83 c4 10             	add    $0x10,%esp
 6d8:	39 de                	cmp    %ebx,%esi
 6da:	75 e4                	jne    6c0 <printint+0x60>
    putc(fd, buf[i]);
}
 6dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6df:	5b                   	pop    %ebx
 6e0:	5e                   	pop    %esi
 6e1:	5f                   	pop    %edi
 6e2:	5d                   	pop    %ebp
 6e3:	c3                   	ret    
 6e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6e8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6ef:	eb 90                	jmp    681 <printint+0x21>
 6f1:	eb 0d                	jmp    700 <printf>
 6f3:	90                   	nop
 6f4:	90                   	nop
 6f5:	90                   	nop
 6f6:	90                   	nop
 6f7:	90                   	nop
 6f8:	90                   	nop
 6f9:	90                   	nop
 6fa:	90                   	nop
 6fb:	90                   	nop
 6fc:	90                   	nop
 6fd:	90                   	nop
 6fe:	90                   	nop
 6ff:	90                   	nop

00000700 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	53                   	push   %ebx
 706:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 709:	8b 75 0c             	mov    0xc(%ebp),%esi
 70c:	0f b6 1e             	movzbl (%esi),%ebx
 70f:	84 db                	test   %bl,%bl
 711:	0f 84 b3 00 00 00    	je     7ca <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 717:	8d 45 10             	lea    0x10(%ebp),%eax
 71a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 71d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 71f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 722:	eb 2f                	jmp    753 <printf+0x53>
 724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 728:	83 f8 25             	cmp    $0x25,%eax
 72b:	0f 84 a7 00 00 00    	je     7d8 <printf+0xd8>
  write(fd, &c, 1);
 731:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 734:	83 ec 04             	sub    $0x4,%esp
 737:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 73a:	6a 01                	push   $0x1
 73c:	50                   	push   %eax
 73d:	ff 75 08             	pushl  0x8(%ebp)
 740:	e8 5d fe ff ff       	call   5a2 <write>
 745:	83 c4 10             	add    $0x10,%esp
 748:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 74b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 74f:	84 db                	test   %bl,%bl
 751:	74 77                	je     7ca <printf+0xca>
    if(state == 0){
 753:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 755:	0f be cb             	movsbl %bl,%ecx
 758:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 75b:	74 cb                	je     728 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 75d:	83 ff 25             	cmp    $0x25,%edi
 760:	75 e6                	jne    748 <printf+0x48>
      if(c == 'd'){
 762:	83 f8 64             	cmp    $0x64,%eax
 765:	0f 84 05 01 00 00    	je     870 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 76b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 771:	83 f9 70             	cmp    $0x70,%ecx
 774:	74 72                	je     7e8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 776:	83 f8 73             	cmp    $0x73,%eax
 779:	0f 84 99 00 00 00    	je     818 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 77f:	83 f8 63             	cmp    $0x63,%eax
 782:	0f 84 08 01 00 00    	je     890 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 788:	83 f8 25             	cmp    $0x25,%eax
 78b:	0f 84 ef 00 00 00    	je     880 <printf+0x180>
  write(fd, &c, 1);
 791:	8d 45 e7             	lea    -0x19(%ebp),%eax
 794:	83 ec 04             	sub    $0x4,%esp
 797:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 79b:	6a 01                	push   $0x1
 79d:	50                   	push   %eax
 79e:	ff 75 08             	pushl  0x8(%ebp)
 7a1:	e8 fc fd ff ff       	call   5a2 <write>
 7a6:	83 c4 0c             	add    $0xc,%esp
 7a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7ac:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7af:	6a 01                	push   $0x1
 7b1:	50                   	push   %eax
 7b2:	ff 75 08             	pushl  0x8(%ebp)
 7b5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7b8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 7ba:	e8 e3 fd ff ff       	call   5a2 <write>
  for(i = 0; fmt[i]; i++){
 7bf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 7c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7c6:	84 db                	test   %bl,%bl
 7c8:	75 89                	jne    753 <printf+0x53>
    }
  }
}
 7ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7cd:	5b                   	pop    %ebx
 7ce:	5e                   	pop    %esi
 7cf:	5f                   	pop    %edi
 7d0:	5d                   	pop    %ebp
 7d1:	c3                   	ret    
 7d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 7d8:	bf 25 00 00 00       	mov    $0x25,%edi
 7dd:	e9 66 ff ff ff       	jmp    748 <printf+0x48>
 7e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 7e8:	83 ec 0c             	sub    $0xc,%esp
 7eb:	b9 10 00 00 00       	mov    $0x10,%ecx
 7f0:	6a 00                	push   $0x0
 7f2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 7f5:	8b 45 08             	mov    0x8(%ebp),%eax
 7f8:	8b 17                	mov    (%edi),%edx
 7fa:	e8 61 fe ff ff       	call   660 <printint>
        ap++;
 7ff:	89 f8                	mov    %edi,%eax
 801:	83 c4 10             	add    $0x10,%esp
      state = 0;
 804:	31 ff                	xor    %edi,%edi
        ap++;
 806:	83 c0 04             	add    $0x4,%eax
 809:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 80c:	e9 37 ff ff ff       	jmp    748 <printf+0x48>
 811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 818:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 81b:	8b 08                	mov    (%eax),%ecx
        ap++;
 81d:	83 c0 04             	add    $0x4,%eax
 820:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 823:	85 c9                	test   %ecx,%ecx
 825:	0f 84 8e 00 00 00    	je     8b9 <printf+0x1b9>
        while(*s != 0){
 82b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 82e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 830:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 832:	84 c0                	test   %al,%al
 834:	0f 84 0e ff ff ff    	je     748 <printf+0x48>
 83a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 83d:	89 de                	mov    %ebx,%esi
 83f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 842:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 845:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 848:	83 ec 04             	sub    $0x4,%esp
          s++;
 84b:	83 c6 01             	add    $0x1,%esi
 84e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 851:	6a 01                	push   $0x1
 853:	57                   	push   %edi
 854:	53                   	push   %ebx
 855:	e8 48 fd ff ff       	call   5a2 <write>
        while(*s != 0){
 85a:	0f b6 06             	movzbl (%esi),%eax
 85d:	83 c4 10             	add    $0x10,%esp
 860:	84 c0                	test   %al,%al
 862:	75 e4                	jne    848 <printf+0x148>
 864:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 867:	31 ff                	xor    %edi,%edi
 869:	e9 da fe ff ff       	jmp    748 <printf+0x48>
 86e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 870:	83 ec 0c             	sub    $0xc,%esp
 873:	b9 0a 00 00 00       	mov    $0xa,%ecx
 878:	6a 01                	push   $0x1
 87a:	e9 73 ff ff ff       	jmp    7f2 <printf+0xf2>
 87f:	90                   	nop
  write(fd, &c, 1);
 880:	83 ec 04             	sub    $0x4,%esp
 883:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 886:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 889:	6a 01                	push   $0x1
 88b:	e9 21 ff ff ff       	jmp    7b1 <printf+0xb1>
        putc(fd, *ap);
 890:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 893:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 896:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 898:	6a 01                	push   $0x1
        ap++;
 89a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 89d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 8a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8a3:	50                   	push   %eax
 8a4:	ff 75 08             	pushl  0x8(%ebp)
 8a7:	e8 f6 fc ff ff       	call   5a2 <write>
        ap++;
 8ac:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 8af:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8b2:	31 ff                	xor    %edi,%edi
 8b4:	e9 8f fe ff ff       	jmp    748 <printf+0x48>
          s = "(null)";
 8b9:	bb 92 0d 00 00       	mov    $0xd92,%ebx
        while(*s != 0){
 8be:	b8 28 00 00 00       	mov    $0x28,%eax
 8c3:	e9 72 ff ff ff       	jmp    83a <printf+0x13a>
 8c8:	66 90                	xchg   %ax,%ax
 8ca:	66 90                	xchg   %ax,%ax
 8cc:	66 90                	xchg   %ax,%ax
 8ce:	66 90                	xchg   %ax,%ax

000008d0 <free>:


/*-------  pmalloc struct  ---------------*/

void
free(void *ap) {
 8d0:	55                   	push   %ebp
    if (DEBUGMODE == 3)
        printf(1, "FREE-\t");
    Header *bp, *p;

    bp = (Header *) ap - 1;
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d1:	a1 f0 11 00 00       	mov    0x11f0,%eax
free(void *ap) {
 8d6:	89 e5                	mov    %esp,%ebp
 8d8:	57                   	push   %edi
 8d9:	56                   	push   %esi
 8da:	53                   	push   %ebx
 8db:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = (Header *) ap - 1;
 8de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 8e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e8:	39 c8                	cmp    %ecx,%eax
 8ea:	8b 10                	mov    (%eax),%edx
 8ec:	73 32                	jae    920 <free+0x50>
 8ee:	39 d1                	cmp    %edx,%ecx
 8f0:	72 04                	jb     8f6 <free+0x26>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f2:	39 d0                	cmp    %edx,%eax
 8f4:	72 32                	jb     928 <free+0x58>
            break;
    if (bp + bp->s.size == p->s.ptr) {
 8f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8fc:	39 fa                	cmp    %edi,%edx
 8fe:	74 30                	je     930 <free+0x60>
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    } else
        bp->s.ptr = p->s.ptr;
 900:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 903:	8b 50 04             	mov    0x4(%eax),%edx
 906:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 909:	39 f1                	cmp    %esi,%ecx
 90b:	74 3a                	je     947 <free+0x77>
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    } else
        p->s.ptr = bp;
 90d:	89 08                	mov    %ecx,(%eax)
    freep = p;
 90f:	a3 f0 11 00 00       	mov    %eax,0x11f0
    if (DEBUGMODE == 3)
        printf(1, ">FREE-DONE!\t");
}
 914:	5b                   	pop    %ebx
 915:	5e                   	pop    %esi
 916:	5f                   	pop    %edi
 917:	5d                   	pop    %ebp
 918:	c3                   	ret    
 919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 920:	39 d0                	cmp    %edx,%eax
 922:	72 04                	jb     928 <free+0x58>
 924:	39 d1                	cmp    %edx,%ecx
 926:	72 ce                	jb     8f6 <free+0x26>
free(void *ap) {
 928:	89 d0                	mov    %edx,%eax
 92a:	eb bc                	jmp    8e8 <free+0x18>
 92c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        bp->s.size += p->s.ptr->s.size;
 930:	03 72 04             	add    0x4(%edx),%esi
 933:	89 73 fc             	mov    %esi,-0x4(%ebx)
        bp->s.ptr = p->s.ptr->s.ptr;
 936:	8b 10                	mov    (%eax),%edx
 938:	8b 12                	mov    (%edx),%edx
 93a:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 93d:	8b 50 04             	mov    0x4(%eax),%edx
 940:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 943:	39 f1                	cmp    %esi,%ecx
 945:	75 c6                	jne    90d <free+0x3d>
        p->s.size += bp->s.size;
 947:	03 53 fc             	add    -0x4(%ebx),%edx
    freep = p;
 94a:	a3 f0 11 00 00       	mov    %eax,0x11f0
        p->s.size += bp->s.size;
 94f:	89 50 04             	mov    %edx,0x4(%eax)
        p->s.ptr = bp->s.ptr;
 952:	8b 53 f8             	mov    -0x8(%ebx),%edx
 955:	89 10                	mov    %edx,(%eax)
}
 957:	5b                   	pop    %ebx
 958:	5e                   	pop    %esi
 959:	5f                   	pop    %edi
 95a:	5d                   	pop    %ebp
 95b:	c3                   	ret    
 95c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000960 <malloc>:
    return freep;
}


void *
malloc(uint nbytes) {
 960:	55                   	push   %ebp
 961:	89 e5                	mov    %esp,%ebp
 963:	57                   	push   %edi
 964:	56                   	push   %esi
 965:	53                   	push   %ebx
 966:	83 ec 0c             	sub    $0xc,%esp
    if (DEBUGMODE == 3)
        printf(1, "MALLOC-");
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 969:	8b 45 08             	mov    0x8(%ebp),%eax
    if ((prevp = freep) == 0) {
 96c:	8b 15 f0 11 00 00    	mov    0x11f0,%edx
    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 972:	8d 78 07             	lea    0x7(%eax),%edi
 975:	c1 ef 03             	shr    $0x3,%edi
 978:	83 c7 01             	add    $0x1,%edi
    if ((prevp = freep) == 0) {
 97b:	85 d2                	test   %edx,%edx
 97d:	0f 84 9d 00 00 00    	je     a20 <malloc+0xc0>
 983:	8b 02                	mov    (%edx),%eax
 985:	8b 48 04             	mov    0x4(%eax),%ecx
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
        if (p->s.size >= nunits) {
 988:	39 cf                	cmp    %ecx,%edi
 98a:	76 6c                	jbe    9f8 <malloc+0x98>
 98c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 992:	bb 00 10 00 00       	mov    $0x1000,%ebx
 997:	0f 43 df             	cmovae %edi,%ebx
    p = sbrk(nu * sizeof(Header));
 99a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9a1:	eb 0e                	jmp    9b1 <malloc+0x51>
 9a3:	90                   	nop
 9a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9a8:	8b 02                	mov    (%edx),%eax
        if (p->s.size >= nunits) {
 9aa:	8b 48 04             	mov    0x4(%eax),%ecx
 9ad:	39 f9                	cmp    %edi,%ecx
 9af:	73 47                	jae    9f8 <malloc+0x98>
            freep = prevp;
            if (DEBUGMODE == 3)
                printf(1, ">MALLOC-done!\t");
            return (void *) (p + 1);
        }
        if (p == freep)
 9b1:	39 05 f0 11 00 00    	cmp    %eax,0x11f0
 9b7:	89 c2                	mov    %eax,%edx
 9b9:	75 ed                	jne    9a8 <malloc+0x48>
    p = sbrk(nu * sizeof(Header));
 9bb:	83 ec 0c             	sub    $0xc,%esp
 9be:	56                   	push   %esi
 9bf:	e8 46 fc ff ff       	call   60a <sbrk>
    if (p == (char *) -1)
 9c4:	83 c4 10             	add    $0x10,%esp
 9c7:	83 f8 ff             	cmp    $0xffffffff,%eax
 9ca:	74 1c                	je     9e8 <malloc+0x88>
    hp->s.size = nu;
 9cc:	89 58 04             	mov    %ebx,0x4(%eax)
    free((void *) (hp + 1));
 9cf:	83 ec 0c             	sub    $0xc,%esp
 9d2:	83 c0 08             	add    $0x8,%eax
 9d5:	50                   	push   %eax
 9d6:	e8 f5 fe ff ff       	call   8d0 <free>
    return freep;
 9db:	8b 15 f0 11 00 00    	mov    0x11f0,%edx
            if ((p = morecore(nunits)) == 0)
 9e1:	83 c4 10             	add    $0x10,%esp
 9e4:	85 d2                	test   %edx,%edx
 9e6:	75 c0                	jne    9a8 <malloc+0x48>
                return 0;
    }
}
 9e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return 0;
 9eb:	31 c0                	xor    %eax,%eax
}
 9ed:	5b                   	pop    %ebx
 9ee:	5e                   	pop    %esi
 9ef:	5f                   	pop    %edi
 9f0:	5d                   	pop    %ebp
 9f1:	c3                   	ret    
 9f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (p->s.size == nunits)
 9f8:	39 cf                	cmp    %ecx,%edi
 9fa:	74 54                	je     a50 <malloc+0xf0>
                p->s.size -= nunits;
 9fc:	29 f9                	sub    %edi,%ecx
 9fe:	89 48 04             	mov    %ecx,0x4(%eax)
                p += p->s.size;
 a01:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
                p->s.size = nunits;
 a04:	89 78 04             	mov    %edi,0x4(%eax)
            freep = prevp;
 a07:	89 15 f0 11 00 00    	mov    %edx,0x11f0
}
 a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return (void *) (p + 1);
 a10:	83 c0 08             	add    $0x8,%eax
}
 a13:	5b                   	pop    %ebx
 a14:	5e                   	pop    %esi
 a15:	5f                   	pop    %edi
 a16:	5d                   	pop    %ebp
 a17:	c3                   	ret    
 a18:	90                   	nop
 a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        base.s.ptr = freep = prevp = &base;
 a20:	c7 05 f0 11 00 00 f4 	movl   $0x11f4,0x11f0
 a27:	11 00 00 
 a2a:	c7 05 f4 11 00 00 f4 	movl   $0x11f4,0x11f4
 a31:	11 00 00 
        base.s.size = 0;
 a34:	b8 f4 11 00 00       	mov    $0x11f4,%eax
 a39:	c7 05 f8 11 00 00 00 	movl   $0x0,0x11f8
 a40:	00 00 00 
 a43:	e9 44 ff ff ff       	jmp    98c <malloc+0x2c>
 a48:	90                   	nop
 a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                prevp->s.ptr = p->s.ptr;
 a50:	8b 08                	mov    (%eax),%ecx
 a52:	89 0a                	mov    %ecx,(%edx)
 a54:	eb b1                	jmp    a07 <malloc+0xa7>
 a56:	8d 76 00             	lea    0x0(%esi),%esi
 a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a60 <pmalloc>:


void *
pmalloc(void) {
 a60:	55                   	push   %ebp
 a61:	89 e5                	mov    %esp,%ebp
 a63:	56                   	push   %esi
 a64:	53                   	push   %ebx
    if (DEBUGMODE == 3)
        printf(1, "PMALLOC-");
    struct PMHeader *nh = malloc(sizeof(struct PMHeader));
 a65:	83 ec 0c             	sub    $0xc,%esp
 a68:	6a 10                	push   $0x10
 a6a:	e8 f1 fe ff ff       	call   960 <malloc>
    char *tmpAdr = sbrk(4096); //point to the first free place
 a6f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    struct PMHeader *nh = malloc(sizeof(struct PMHeader));
 a76:	89 c3                	mov    %eax,%ebx
    char *tmpAdr = sbrk(4096); //point to the first free place
 a78:	e8 8d fb ff ff       	call   60a <sbrk>
    if ((int) tmpAdr % 4096 != 0) //if not align->fix this
 a7d:	83 c4 10             	add    $0x10,%esp
 a80:	a9 ff 0f 00 00       	test   $0xfff,%eax
    char *tmpAdr = sbrk(4096); //point to the first free place
 a85:	89 c6                	mov    %eax,%esi
    if ((int) tmpAdr % 4096 != 0) //if not align->fix this
 a87:	74 03                	je     a8c <pmalloc+0x2c>
        *tmpAdr = (char) PGROUNDUP((int) tmpAdr);
 a89:	c6 00 00             	movb   $0x0,(%eax)

    //init PMHeader
    nh->PMheaderID = nextID++;
 a8c:	a1 d0 11 00 00       	mov    0x11d0,%eax
    nh->PMnext = 0;
 a91:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    nh->PMadress = tmpAdr;
 a98:	89 73 04             	mov    %esi,0x4(%ebx)
    nh->PMprotectedPage = 0;
 a9b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    nh->PMheaderID = nextID++;
 aa2:	8d 50 01             	lea    0x1(%eax),%edx
 aa5:	89 15 d0 11 00 00    	mov    %edx,0x11d0
 aab:	89 03                	mov    %eax,(%ebx)

    //if first-> PMpage=tail=nh
    if (PMcounter == 0) {
 aad:	8b 15 e4 11 00 00    	mov    0x11e4,%edx
 ab3:	85 d2                	test   %edx,%edx
 ab5:	74 39                	je     af0 <pmalloc+0x90>
        PMinit = nh; //set PMinit link
        tail = nh;
    } else { //else- add new page to the end of PMlist
        tail->PMnext = nh;
 ab7:	a1 e8 11 00 00       	mov    0x11e8,%eax
        tail = tail->PMnext;
 abc:	89 1d e8 11 00 00    	mov    %ebx,0x11e8
        tail->PMnext = nh;
 ac2:	89 58 08             	mov    %ebx,0x8(%eax)
 ac5:	8b 43 04             	mov    0x4(%ebx),%eax
    }
    //turn PMflag on and W flag off
    turnOnW(nh->PMadress);//TODO
 ac8:	83 ec 0c             	sub    $0xc,%esp
 acb:	50                   	push   %eax
 acc:	e8 69 fb ff ff       	call   63a <turnOnW>
    turnOnPM(nh->PMadress);
 ad1:	58                   	pop    %eax
 ad2:	ff 73 04             	pushl  0x4(%ebx)
 ad5:	e8 48 fb ff ff       	call   622 <turnOnPM>
    //fresh PTE
    updatePTE();
 ada:	e8 6b fb ff ff       	call   64a <updatePTE>
    PMcounter++;
 adf:	83 05 e4 11 00 00 01 	addl   $0x1,0x11e4
    if (DEBUGMODE == 3)
        printf(1, ">PMALLOC-DONE!\n");
    return tmpAdr;
}
 ae6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 ae9:	89 f0                	mov    %esi,%eax
 aeb:	5b                   	pop    %ebx
 aec:	5e                   	pop    %esi
 aed:	5d                   	pop    %ebp
 aee:	c3                   	ret    
 aef:	90                   	nop
        PMinit = nh; //set PMinit link
 af0:	89 1d ec 11 00 00    	mov    %ebx,0x11ec
        tail = nh;
 af6:	89 1d e8 11 00 00    	mov    %ebx,0x11e8
    char *tmpAdr = sbrk(4096); //point to the first free place
 afc:	89 f0                	mov    %esi,%eax
 afe:	eb c8                	jmp    ac8 <pmalloc+0x68>

00000b00 <protect_page>:

int
protect_page(void *ap) {
 b00:	55                   	push   %ebp
 b01:	89 e5                	mov    %esp,%ebp
 b03:	53                   	push   %ebx
 b04:	83 ec 04             	sub    $0x4,%esp
 b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE == 3)
        printf(1, "PROTECT_PAGE-");
    if (ap) {
 b0a:	85 db                	test   %ebx,%ebx
 b0c:	74 7a                	je     b88 <protect_page+0x88>
        if ((int) ap % 4096 != 0) {
 b0e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
 b14:	75 72                	jne    b88 <protect_page+0x88>
            if (DEBUGMODE == 3)
                printf(1, ">PROTECT_PAGE-ERROR-NOT_ALIGN!\n");
            return -1;
        }
        if (checkOnPM(ap)) { //if PTE_PM off -can't protect not pmalloc page
 b16:	83 ec 0c             	sub    $0xc,%esp
 b19:	53                   	push   %ebx
 b1a:	e8 0b fb ff ff       	call   62a <checkOnPM>
 b1f:	83 c4 10             	add    $0x10,%esp
 b22:	85 c0                	test   %eax,%eax
 b24:	74 62                	je     b88 <protect_page+0x88>
            turnOffW(ap);
 b26:	83 ec 0c             	sub    $0xc,%esp
 b29:	53                   	push   %ebx
 b2a:	e8 03 fb ff ff       	call   632 <turnOffW>
            updatePTE();
 b2f:	e8 16 fb ff ff       	call   64a <updatePTE>
            updateProc(1); // protectedPages++
 b34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 b3b:	e8 12 fb ff ff       	call   652 <updateProc>
            //turn on flag
            struct PMHeader *PMap = PMinit;
 b40:	a1 ec 11 00 00       	mov    0x11ec,%eax
            while (PMap->PMnext != 0 && PMap->PMadress != ap)
 b45:	83 c4 10             	add    $0x10,%esp
 b48:	eb 0c                	jmp    b56 <protect_page+0x56>
 b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 b50:	39 cb                	cmp    %ecx,%ebx
 b52:	74 10                	je     b64 <protect_page+0x64>
 b54:	89 d0                	mov    %edx,%eax
 b56:	8b 50 08             	mov    0x8(%eax),%edx
 b59:	8b 48 04             	mov    0x4(%eax),%ecx
 b5c:	85 d2                	test   %edx,%edx
 b5e:	75 f0                	jne    b50 <protect_page+0x50>
                PMap = PMap->PMnext;
            if (PMap->PMadress != ap) {
 b60:	39 cb                	cmp    %ecx,%ebx
 b62:	75 11                	jne    b75 <protect_page+0x75>
                printf(2, "PROBLEM with ap:%d\n", ap);
                return -1;
            }
            //got here ->MPap points the protected link
            PMap->PMprotectedPage = 1;//turn on FLAG
 b64:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
            if (DEBUGMODE == 3)
                printf(1, ">PROTECT_PAGE-DONE!\n");
            return 1;
 b6b:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    if (DEBUGMODE == 3)
        printf(1, ">PROTECT_PAGE-ERROR!\n");
    return -1;
}
 b70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 b73:	c9                   	leave  
 b74:	c3                   	ret    
                printf(2, "PROBLEM with ap:%d\n", ap);
 b75:	83 ec 04             	sub    $0x4,%esp
 b78:	53                   	push   %ebx
 b79:	68 ad 0d 00 00       	push   $0xdad
 b7e:	6a 02                	push   $0x2
 b80:	e8 7b fb ff ff       	call   700 <printf>
 b85:	83 c4 10             	add    $0x10,%esp
 b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 b90:	c9                   	leave  
 b91:	c3                   	ret    
 b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000ba0 <printPMList>:


void
printPMList(void) {
 ba0:	55                   	push   %ebp
 ba1:	89 e5                	mov    %esp,%ebp
 ba3:	56                   	push   %esi
 ba4:	53                   	push   %ebx
    struct PMHeader *tmp2 = PMinit;
 ba5:	8b 1d ec 11 00 00    	mov    0x11ec,%ebx
    printf(1, "\nPMlist:\t");
 bab:	83 ec 08             	sub    $0x8,%esp
 bae:	68 c1 0d 00 00       	push   $0xdc1
 bb3:	6a 01                	push   $0x1
 bb5:	e8 46 fb ff ff       	call   700 <printf>
    for (int i = 0; i < PMcounter; i++, tmp2 = tmp2->PMnext)
 bba:	a1 e4 11 00 00       	mov    0x11e4,%eax
 bbf:	83 c4 10             	add    $0x10,%esp
 bc2:	85 c0                	test   %eax,%eax
 bc4:	7e 2d                	jle    bf3 <printPMList+0x53>
 bc6:	31 f6                	xor    %esi,%esi
 bc8:	90                   	nop
 bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(2, "%d\t", tmp2->PMadress);
 bd0:	83 ec 04             	sub    $0x4,%esp
 bd3:	ff 73 04             	pushl  0x4(%ebx)
    for (int i = 0; i < PMcounter; i++, tmp2 = tmp2->PMnext)
 bd6:	83 c6 01             	add    $0x1,%esi
        printf(2, "%d\t", tmp2->PMadress);
 bd9:	68 cb 0d 00 00       	push   $0xdcb
 bde:	6a 02                	push   $0x2
 be0:	e8 1b fb ff ff       	call   700 <printf>
    for (int i = 0; i < PMcounter; i++, tmp2 = tmp2->PMnext)
 be5:	83 c4 10             	add    $0x10,%esp
 be8:	39 35 e4 11 00 00    	cmp    %esi,0x11e4
 bee:	8b 5b 08             	mov    0x8(%ebx),%ebx
 bf1:	7f dd                	jg     bd0 <printPMList+0x30>
    printf(1, "\n\n");
 bf3:	83 ec 08             	sub    $0x8,%esp
 bf6:	68 cf 0d 00 00       	push   $0xdcf
 bfb:	6a 01                	push   $0x1
 bfd:	e8 fe fa ff ff       	call   700 <printf>
}
 c02:	83 c4 10             	add    $0x10,%esp
 c05:	8d 65 f8             	lea    -0x8(%ebp),%esp
 c08:	5b                   	pop    %ebx
 c09:	5e                   	pop    %esi
 c0a:	5d                   	pop    %ebp
 c0b:	c3                   	ret    
 c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c10 <checkIfPM>:

//return 1 if ap is address of PMALLOC page ; 0 otherwise
int
checkIfPM(void *p) {
    struct PMHeader *tmp = PMinit;
    for (int i = 0; i < PMcounter; i++) {
 c10:	8b 15 e4 11 00 00    	mov    0x11e4,%edx
    struct PMHeader *tmp = PMinit;
 c16:	a1 ec 11 00 00       	mov    0x11ec,%eax
    for (int i = 0; i < PMcounter; i++) {
 c1b:	85 d2                	test   %edx,%edx
 c1d:	7e 11                	jle    c30 <checkIfPM+0x20>
checkIfPM(void *p) {
 c1f:	55                   	push   %ebp
 c20:	89 e5                	mov    %esp,%ebp
        if (tmp->PMadress == p)
 c22:	8b 55 08             	mov    0x8(%ebp),%edx
 c25:	39 50 04             	cmp    %edx,0x4(%eax)
            return 1;
    }
    return 0;
}
 c28:	5d                   	pop    %ebp
        if (tmp->PMadress == p)
 c29:	0f 94 c0             	sete   %al
 c2c:	0f b6 c0             	movzbl %al,%eax
}
 c2f:	c3                   	ret    
    return 0;
 c30:	31 c0                	xor    %eax,%eax
}
 c32:	c3                   	ret    
 c33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c40 <pfree>:
pfree(void *ap) {
    if (DEBUGMODE == 3)
        printf(1, "PFREE-");

    //validation check
    if (PMcounter == 0) {
 c40:	a1 e4 11 00 00       	mov    0x11e4,%eax
pfree(void *ap) {
 c45:	55                   	push   %ebp
 c46:	89 e5                	mov    %esp,%ebp
 c48:	56                   	push   %esi
 c49:	53                   	push   %ebx
        if (DEBUGMODE == 3)
            printf(1, "PFREE-ERROR!->not have pages that were pmallocced\n");
        return -1;
    }

    if (ap) {
 c4a:	85 c0                	test   %eax,%eax
pfree(void *ap) {
 c4c:	8b 75 08             	mov    0x8(%ebp),%esi
    if (ap) {
 c4f:	74 1b                	je     c6c <pfree+0x2c>
 c51:	85 f6                	test   %esi,%esi
 c53:	74 17                	je     c6c <pfree+0x2c>
        struct PMHeader *PMap = PMinit;
        struct PMHeader *tmp = PMinit;
        //check aligned
        if ((int) ap % 4096 != 0) {
 c55:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
        struct PMHeader *PMap = PMinit;
 c5b:	8b 1d ec 11 00 00    	mov    0x11ec,%ebx
        if ((int) ap % 4096 != 0) {
 c61:	75 09                	jne    c6c <pfree+0x2c>
    for (int i = 0; i < PMcounter; i++) {
 c63:	85 c0                	test   %eax,%eax
 c65:	7e 05                	jle    c6c <pfree+0x2c>
        if (tmp->PMadress == p)
 c67:	3b 73 04             	cmp    0x4(%ebx),%esi
 c6a:	74 14                	je     c80 <pfree+0x40>
            return -1;
        }
    }
    if (DEBUGMODE == 3)
        printf(1, ">PFREE-ERROR!\t");
    return -1;
 c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 c71:	8d 65 f8             	lea    -0x8(%ebp),%esp
 c74:	5b                   	pop    %ebx
 c75:	5e                   	pop    %esi
 c76:	5d                   	pop    %ebp
 c77:	c3                   	ret    
 c78:	90                   	nop
 c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            turnOffW(PMap);
 c80:	83 ec 0c             	sub    $0xc,%esp
 c83:	53                   	push   %ebx
 c84:	e8 a9 f9 ff ff       	call   632 <turnOffW>
            turnOffPM(PMap);
 c89:	89 1c 24             	mov    %ebx,(%esp)
 c8c:	e8 b1 f9 ff ff       	call   642 <turnOffPM>
            updatePTE();
 c91:	e8 b4 f9 ff ff       	call   64a <updatePTE>
            PMcounter--;
 c96:	a1 e4 11 00 00       	mov    0x11e4,%eax
            if (PMcounter == 0) {//if true ->reset PMlist
 c9b:	83 c4 10             	add    $0x10,%esp
            PMcounter--;
 c9e:	83 e8 01             	sub    $0x1,%eax
            if (PMcounter == 0) {//if true ->reset PMlist
 ca1:	85 c0                	test   %eax,%eax
            PMcounter--;
 ca3:	a3 e4 11 00 00       	mov    %eax,0x11e4
            if (PMcounter == 0) {//if true ->reset PMlist
 ca8:	74 46                	je     cf0 <pfree+0xb0>
 caa:	89 d8                	mov    %ebx,%eax
 cac:	eb 08                	jmp    cb6 <pfree+0x76>
 cae:	66 90                	xchg   %ax,%ax
                while (PMap->PMnext != 0 && PMap->PMadress != ap)
 cb0:	39 ce                	cmp    %ecx,%esi
 cb2:	74 10                	je     cc4 <pfree+0x84>
 cb4:	89 d0                	mov    %edx,%eax
 cb6:	8b 50 08             	mov    0x8(%eax),%edx
 cb9:	8b 48 04             	mov    0x4(%eax),%ecx
 cbc:	85 d2                	test   %edx,%edx
 cbe:	75 f0                	jne    cb0 <pfree+0x70>
                if (PMap->PMadress != ap) {
 cc0:	39 ce                	cmp    %ecx,%esi
 cc2:	75 65                	jne    d29 <pfree+0xe9>
                if (tmp->PMheaderID == PMap->PMheaderID) {//happens when both point on the first link
 cc4:	8b 08                	mov    (%eax),%ecx
 cc6:	39 0b                	cmp    %ecx,(%ebx)
 cc8:	75 08                	jne    cd2 <pfree+0x92>
 cca:	eb 44                	jmp    d10 <pfree+0xd0>
 ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 cd0:	89 c3                	mov    %eax,%ebx
                    while (tmp->PMnext->PMheaderID != PMap->PMheaderID)
 cd2:	8b 43 08             	mov    0x8(%ebx),%eax
 cd5:	3b 08                	cmp    (%eax),%ecx
 cd7:	75 f7                	jne    cd0 <pfree+0x90>
                    tmp->PMnext = PMap->PMnext;
 cd9:	89 53 08             	mov    %edx,0x8(%ebx)
}
 cdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
 cdf:	b8 01 00 00 00       	mov    $0x1,%eax
}
 ce4:	5b                   	pop    %ebx
 ce5:	5e                   	pop    %esi
 ce6:	5d                   	pop    %ebp
 ce7:	c3                   	ret    
 ce8:	90                   	nop
 ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                PMinit = 0;
 cf0:	c7 05 ec 11 00 00 00 	movl   $0x0,0x11ec
 cf7:	00 00 00 
                tail = 0;
 cfa:	c7 05 e8 11 00 00 00 	movl   $0x0,0x11e8
 d01:	00 00 00 
}
 d04:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
 d07:	b8 01 00 00 00       	mov    $0x1,%eax
}
 d0c:	5b                   	pop    %ebx
 d0d:	5e                   	pop    %esi
 d0e:	5d                   	pop    %ebp
 d0f:	c3                   	ret    
                    PMinit = PMinit->PMnext;
 d10:	a1 ec 11 00 00       	mov    0x11ec,%eax
 d15:	8b 40 08             	mov    0x8(%eax),%eax
 d18:	a3 ec 11 00 00       	mov    %eax,0x11ec
}
 d1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
 d20:	b8 01 00 00 00       	mov    $0x1,%eax
}
 d25:	5b                   	pop    %ebx
 d26:	5e                   	pop    %esi
 d27:	5d                   	pop    %ebp
 d28:	c3                   	ret    
                    printf(2, "PROBLEM with ap:%d\n", ap);
 d29:	83 ec 04             	sub    $0x4,%esp
 d2c:	56                   	push   %esi
 d2d:	68 ad 0d 00 00       	push   $0xdad
 d32:	6a 02                	push   $0x2
 d34:	e8 c7 f9 ff ff       	call   700 <printf>
                    return -1;
 d39:	83 c4 10             	add    $0x10,%esp
 d3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 d41:	e9 2b ff ff ff       	jmp    c71 <pfree+0x31>
