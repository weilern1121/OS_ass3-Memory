
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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	bb 01 00 00 00       	mov    $0x1,%ebx
  16:	83 ec 08             	sub    $0x8,%esp
  19:	8b 31                	mov    (%ecx),%esi
  1b:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1e:	83 fe 01             	cmp    $0x1,%esi
  21:	7e 1f                	jle    42 <main+0x42>
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 34 9f             	pushl  (%edi,%ebx,4)

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
  2e:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
  31:	e8 ca 00 00 00       	call   100 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
  36:	83 c4 10             	add    $0x10,%esp
  39:	39 de                	cmp    %ebx,%esi
  3b:	75 eb                	jne    28 <main+0x28>
    ls(argv[i]);
  exit();
  3d:	e8 50 05 00 00       	call   592 <exit>
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    ls(".");
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	68 38 0b 00 00       	push   $0xb38
  4a:	e8 b1 00 00 00       	call   100 <ls>
    exit();
  4f:	e8 3e 05 00 00       	call   592 <exit>
  54:	66 90                	xchg   %ax,%ax
  56:	66 90                	xchg   %ax,%ax
  58:	66 90                	xchg   %ax,%ax
  5a:	66 90                	xchg   %ax,%ax
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	53                   	push   %ebx
  6c:	e8 4f 03 00 00       	call   3c0 <strlen>
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
    ;
  p++;
  8c:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	53                   	push   %ebx
  93:	e8 28 03 00 00       	call   3c0 <strlen>
  98:	83 c4 10             	add    $0x10,%esp
  9b:	83 f8 0d             	cmp    $0xd,%eax
  9e:	77 4a                	ja     ea <fmtname+0x8a>
    return p;
  memmove(buf, p, strlen(p));
  a0:	83 ec 0c             	sub    $0xc,%esp
  a3:	53                   	push   %ebx
  a4:	e8 17 03 00 00       	call   3c0 <strlen>
  a9:	83 c4 0c             	add    $0xc,%esp
  ac:	50                   	push   %eax
  ad:	53                   	push   %ebx
  ae:	68 e8 0e 00 00       	push   $0xee8
  b3:	e8 a8 04 00 00       	call   560 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  b8:	89 1c 24             	mov    %ebx,(%esp)
  bb:	e8 00 03 00 00       	call   3c0 <strlen>
  c0:	89 1c 24             	mov    %ebx,(%esp)
  c3:	89 c6                	mov    %eax,%esi
  return buf;
  c5:	bb e8 0e 00 00       	mov    $0xee8,%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	e8 f1 02 00 00       	call   3c0 <strlen>
  cf:	ba 0e 00 00 00       	mov    $0xe,%edx
  d4:	83 c4 0c             	add    $0xc,%esp
  d7:	05 e8 0e 00 00       	add    $0xee8,%eax
  dc:	29 f2                	sub    %esi,%edx
  de:	52                   	push   %edx
  df:	6a 20                	push   $0x20
  e1:	50                   	push   %eax
  e2:	e8 09 03 00 00       	call   3f0 <memset>
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

void
ls(char *path)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 64 02 00 00    	sub    $0x264,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
 10f:	6a 00                	push   $0x0
 111:	57                   	push   %edi
 112:	e8 bb 04 00 00       	call   5d2 <open>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	0f 88 9e 01 00 00    	js     2c0 <ls+0x1c0>
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
 122:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 128:	83 ec 08             	sub    $0x8,%esp
 12b:	89 c3                	mov    %eax,%ebx
 12d:	56                   	push   %esi
 12e:	50                   	push   %eax
 12f:	e8 b6 04 00 00       	call   5ea <fstat>
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	0f 88 c1 01 00 00    	js     300 <ls+0x200>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 13f:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 146:	66 83 f8 01          	cmp    $0x1,%ax
 14a:	74 54                	je     1a0 <ls+0xa0>
 14c:	66 83 f8 02          	cmp    $0x2,%ax
 150:	75 37                	jne    189 <ls+0x89>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 152:	83 ec 0c             	sub    $0xc,%esp
 155:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 15b:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 161:	57                   	push   %edi
 162:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 168:	e8 f3 fe ff ff       	call   60 <fmtname>
 16d:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 173:	59                   	pop    %ecx
 174:	5f                   	pop    %edi
 175:	52                   	push   %edx
 176:	56                   	push   %esi
 177:	6a 02                	push   $0x2
 179:	50                   	push   %eax
 17a:	68 18 0b 00 00       	push   $0xb18
 17f:	6a 01                	push   $0x1
 181:	e8 5a 05 00 00       	call   6e0 <printf>
    break;
 186:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 189:	83 ec 0c             	sub    $0xc,%esp
 18c:	53                   	push   %ebx
 18d:	e8 28 04 00 00       	call   5ba <close>
 192:	83 c4 10             	add    $0x10,%esp
}
 195:	8d 65 f4             	lea    -0xc(%ebp),%esp
 198:	5b                   	pop    %ebx
 199:	5e                   	pop    %esi
 19a:	5f                   	pop    %edi
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret    
 19d:	8d 76 00             	lea    0x0(%esi),%esi
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1a0:	83 ec 0c             	sub    $0xc,%esp
 1a3:	57                   	push   %edi
 1a4:	e8 17 02 00 00       	call   3c0 <strlen>
 1a9:	83 c0 10             	add    $0x10,%eax
 1ac:	83 c4 10             	add    $0x10,%esp
 1af:	3d 00 02 00 00       	cmp    $0x200,%eax
 1b4:	0f 87 26 01 00 00    	ja     2e0 <ls+0x1e0>
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
 1ba:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1c0:	83 ec 08             	sub    $0x8,%esp
 1c3:	57                   	push   %edi
 1c4:	8d bd c4 fd ff ff    	lea    -0x23c(%ebp),%edi
 1ca:	50                   	push   %eax
 1cb:	e8 70 01 00 00       	call   340 <strcpy>
    p = buf+strlen(buf);
 1d0:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1d6:	89 04 24             	mov    %eax,(%esp)
 1d9:	e8 e2 01 00 00       	call   3c0 <strlen>
 1de:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e4:	83 c4 10             	add    $0x10,%esp
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
 1e7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    *p++ = '/';
 1ea:	8d 84 05 e9 fd ff ff 	lea    -0x217(%ebp,%eax,1),%eax
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
 1f1:	89 8d a8 fd ff ff    	mov    %ecx,-0x258(%ebp)
    *p++ = '/';
 1f7:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 1fd:	c6 01 2f             	movb   $0x2f,(%ecx)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 200:	83 ec 04             	sub    $0x4,%esp
 203:	6a 10                	push   $0x10
 205:	57                   	push   %edi
 206:	53                   	push   %ebx
 207:	e8 9e 03 00 00       	call   5aa <read>
 20c:	83 c4 10             	add    $0x10,%esp
 20f:	83 f8 10             	cmp    $0x10,%eax
 212:	0f 85 71 ff ff ff    	jne    189 <ls+0x89>
      if(de.inum == 0)
 218:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 21f:	00 
 220:	74 de                	je     200 <ls+0x100>
        continue;
      memmove(p, de.name, DIRSIZ);
 222:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 228:	83 ec 04             	sub    $0x4,%esp
 22b:	6a 0e                	push   $0xe
 22d:	50                   	push   %eax
 22e:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 234:	e8 27 03 00 00       	call   560 <memmove>
      p[DIRSIZ] = 0;
 239:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 23f:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 243:	58                   	pop    %eax
 244:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 24a:	5a                   	pop    %edx
 24b:	56                   	push   %esi
 24c:	50                   	push   %eax
 24d:	e8 7e 02 00 00       	call   4d0 <stat>
 252:	83 c4 10             	add    $0x10,%esp
 255:	85 c0                	test   %eax,%eax
 257:	0f 88 c3 00 00 00    	js     320 <ls+0x220>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 25d:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 263:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 26a:	83 ec 0c             	sub    $0xc,%esp
 26d:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 273:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 279:	8d 8d e8 fd ff ff    	lea    -0x218(%ebp),%ecx
 27f:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 285:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 28b:	51                   	push   %ecx
 28c:	e8 cf fd ff ff       	call   60 <fmtname>
 291:	5a                   	pop    %edx
 292:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 298:	59                   	pop    %ecx
 299:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 29f:	51                   	push   %ecx
 2a0:	52                   	push   %edx
 2a1:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 2a7:	50                   	push   %eax
 2a8:	68 18 0b 00 00       	push   $0xb18
 2ad:	6a 01                	push   $0x1
 2af:	e8 2c 04 00 00       	call   6e0 <printf>
 2b4:	83 c4 20             	add    $0x20,%esp
 2b7:	e9 44 ff ff ff       	jmp    200 <ls+0x100>
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	57                   	push   %edi
 2c4:	68 f0 0a 00 00       	push   $0xaf0
 2c9:	6a 02                	push   $0x2
 2cb:	e8 10 04 00 00       	call   6e0 <printf>
    return;
 2d0:	83 c4 10             	add    $0x10,%esp
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}
 2d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    
 2db:	90                   	nop
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
 2e0:	83 ec 08             	sub    $0x8,%esp
 2e3:	68 25 0b 00 00       	push   $0xb25
 2e8:	6a 01                	push   $0x1
 2ea:	e8 f1 03 00 00       	call   6e0 <printf>
      break;
 2ef:	83 c4 10             	add    $0x10,%esp
 2f2:	e9 92 fe ff ff       	jmp    189 <ls+0x89>
 2f7:	89 f6                	mov    %esi,%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
 300:	83 ec 04             	sub    $0x4,%esp
 303:	57                   	push   %edi
 304:	68 04 0b 00 00       	push   $0xb04
 309:	6a 02                	push   $0x2
 30b:	e8 d0 03 00 00       	call   6e0 <printf>
    close(fd);
 310:	89 1c 24             	mov    %ebx,(%esp)
 313:	e8 a2 02 00 00       	call   5ba <close>
    return;
 318:	83 c4 10             	add    $0x10,%esp
 31b:	e9 75 fe ff ff       	jmp    195 <ls+0x95>
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf(1, "ls: cannot stat %s\n", buf);
 320:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 326:	83 ec 04             	sub    $0x4,%esp
 329:	50                   	push   %eax
 32a:	68 04 0b 00 00       	push   $0xb04
 32f:	6a 01                	push   $0x1
 331:	e8 aa 03 00 00       	call   6e0 <printf>
        continue;
 336:	83 c4 10             	add    $0x10,%esp
 339:	e9 c2 fe ff ff       	jmp    200 <ls+0x100>
 33e:	66 90                	xchg   %ax,%ax

00000340 <strcpy>:
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 34a:	89 c2                	mov    %eax,%edx
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 350:	83 c1 01             	add    $0x1,%ecx
 353:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 357:	83 c2 01             	add    $0x1,%edx
 35a:	84 db                	test   %bl,%bl
 35c:	88 5a ff             	mov    %bl,-0x1(%edx)
 35f:	75 ef                	jne    350 <strcpy+0x10>
 361:	5b                   	pop    %ebx
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    
 364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 36a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000370 <strcmp>:
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 55 08             	mov    0x8(%ebp),%edx
 377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 37a:	0f b6 02             	movzbl (%edx),%eax
 37d:	0f b6 19             	movzbl (%ecx),%ebx
 380:	84 c0                	test   %al,%al
 382:	75 1c                	jne    3a0 <strcmp+0x30>
 384:	eb 2a                	jmp    3b0 <strcmp+0x40>
 386:	8d 76 00             	lea    0x0(%esi),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 390:	83 c2 01             	add    $0x1,%edx
 393:	0f b6 02             	movzbl (%edx),%eax
 396:	83 c1 01             	add    $0x1,%ecx
 399:	0f b6 19             	movzbl (%ecx),%ebx
 39c:	84 c0                	test   %al,%al
 39e:	74 10                	je     3b0 <strcmp+0x40>
 3a0:	38 d8                	cmp    %bl,%al
 3a2:	74 ec                	je     390 <strcmp+0x20>
 3a4:	29 d8                	sub    %ebx,%eax
 3a6:	5b                   	pop    %ebx
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3b0:	31 c0                	xor    %eax,%eax
 3b2:	29 d8                	sub    %ebx,%eax
 3b4:	5b                   	pop    %ebx
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret    
 3b7:	89 f6                	mov    %esi,%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003c0 <strlen>:
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3c6:	80 39 00             	cmpb   $0x0,(%ecx)
 3c9:	74 15                	je     3e0 <strlen+0x20>
 3cb:	31 d2                	xor    %edx,%edx
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
 3d0:	83 c2 01             	add    $0x1,%edx
 3d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3d7:	89 d0                	mov    %edx,%eax
 3d9:	75 f5                	jne    3d0 <strlen+0x10>
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
 3e0:	31 c0                	xor    %eax,%eax
 3e2:	5d                   	pop    %ebp
 3e3:	c3                   	ret    
 3e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003f0 <memset>:
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	8b 55 08             	mov    0x8(%ebp),%edx
 3f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	89 d7                	mov    %edx,%edi
 3ff:	fc                   	cld    
 400:	f3 aa                	rep stos %al,%es:(%edi)
 402:	89 d0                	mov    %edx,%eax
 404:	5f                   	pop    %edi
 405:	5d                   	pop    %ebp
 406:	c3                   	ret    
 407:	89 f6                	mov    %esi,%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <strchr>:
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	53                   	push   %ebx
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 41a:	0f b6 10             	movzbl (%eax),%edx
 41d:	84 d2                	test   %dl,%dl
 41f:	74 1d                	je     43e <strchr+0x2e>
 421:	38 d3                	cmp    %dl,%bl
 423:	89 d9                	mov    %ebx,%ecx
 425:	75 0d                	jne    434 <strchr+0x24>
 427:	eb 17                	jmp    440 <strchr+0x30>
 429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 430:	38 ca                	cmp    %cl,%dl
 432:	74 0c                	je     440 <strchr+0x30>
 434:	83 c0 01             	add    $0x1,%eax
 437:	0f b6 10             	movzbl (%eax),%edx
 43a:	84 d2                	test   %dl,%dl
 43c:	75 f2                	jne    430 <strchr+0x20>
 43e:	31 c0                	xor    %eax,%eax
 440:	5b                   	pop    %ebx
 441:	5d                   	pop    %ebp
 442:	c3                   	ret    
 443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <gets>:
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
 456:	31 f6                	xor    %esi,%esi
 458:	89 f3                	mov    %esi,%ebx
 45a:	83 ec 1c             	sub    $0x1c,%esp
 45d:	8b 7d 08             	mov    0x8(%ebp),%edi
 460:	eb 2f                	jmp    491 <gets+0x41>
 462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 468:	8d 45 e7             	lea    -0x19(%ebp),%eax
 46b:	83 ec 04             	sub    $0x4,%esp
 46e:	6a 01                	push   $0x1
 470:	50                   	push   %eax
 471:	6a 00                	push   $0x0
 473:	e8 32 01 00 00       	call   5aa <read>
 478:	83 c4 10             	add    $0x10,%esp
 47b:	85 c0                	test   %eax,%eax
 47d:	7e 1c                	jle    49b <gets+0x4b>
 47f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 483:	83 c7 01             	add    $0x1,%edi
 486:	88 47 ff             	mov    %al,-0x1(%edi)
 489:	3c 0a                	cmp    $0xa,%al
 48b:	74 23                	je     4b0 <gets+0x60>
 48d:	3c 0d                	cmp    $0xd,%al
 48f:	74 1f                	je     4b0 <gets+0x60>
 491:	83 c3 01             	add    $0x1,%ebx
 494:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 497:	89 fe                	mov    %edi,%esi
 499:	7c cd                	jl     468 <gets+0x18>
 49b:	89 f3                	mov    %esi,%ebx
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
 4a0:	c6 03 00             	movb   $0x0,(%ebx)
 4a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a6:	5b                   	pop    %ebx
 4a7:	5e                   	pop    %esi
 4a8:	5f                   	pop    %edi
 4a9:	5d                   	pop    %ebp
 4aa:	c3                   	ret    
 4ab:	90                   	nop
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b0:	8b 75 08             	mov    0x8(%ebp),%esi
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	01 de                	add    %ebx,%esi
 4b8:	89 f3                	mov    %esi,%ebx
 4ba:	c6 03 00             	movb   $0x0,(%ebx)
 4bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c0:	5b                   	pop    %ebx
 4c1:	5e                   	pop    %esi
 4c2:	5f                   	pop    %edi
 4c3:	5d                   	pop    %ebp
 4c4:	c3                   	ret    
 4c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004d0 <stat>:
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	56                   	push   %esi
 4d4:	53                   	push   %ebx
 4d5:	83 ec 08             	sub    $0x8,%esp
 4d8:	6a 00                	push   $0x0
 4da:	ff 75 08             	pushl  0x8(%ebp)
 4dd:	e8 f0 00 00 00       	call   5d2 <open>
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	85 c0                	test   %eax,%eax
 4e7:	78 27                	js     510 <stat+0x40>
 4e9:	83 ec 08             	sub    $0x8,%esp
 4ec:	ff 75 0c             	pushl  0xc(%ebp)
 4ef:	89 c3                	mov    %eax,%ebx
 4f1:	50                   	push   %eax
 4f2:	e8 f3 00 00 00       	call   5ea <fstat>
 4f7:	89 1c 24             	mov    %ebx,(%esp)
 4fa:	89 c6                	mov    %eax,%esi
 4fc:	e8 b9 00 00 00       	call   5ba <close>
 501:	83 c4 10             	add    $0x10,%esp
 504:	8d 65 f8             	lea    -0x8(%ebp),%esp
 507:	89 f0                	mov    %esi,%eax
 509:	5b                   	pop    %ebx
 50a:	5e                   	pop    %esi
 50b:	5d                   	pop    %ebp
 50c:	c3                   	ret    
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	be ff ff ff ff       	mov    $0xffffffff,%esi
 515:	eb ed                	jmp    504 <stat+0x34>
 517:	89 f6                	mov    %esi,%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000520 <atoi>:
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	53                   	push   %ebx
 524:	8b 4d 08             	mov    0x8(%ebp),%ecx
 527:	0f be 11             	movsbl (%ecx),%edx
 52a:	8d 42 d0             	lea    -0x30(%edx),%eax
 52d:	3c 09                	cmp    $0x9,%al
 52f:	b8 00 00 00 00       	mov    $0x0,%eax
 534:	77 1f                	ja     555 <atoi+0x35>
 536:	8d 76 00             	lea    0x0(%esi),%esi
 539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 540:	8d 04 80             	lea    (%eax,%eax,4),%eax
 543:	83 c1 01             	add    $0x1,%ecx
 546:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 54a:	0f be 11             	movsbl (%ecx),%edx
 54d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 550:	80 fb 09             	cmp    $0x9,%bl
 553:	76 eb                	jbe    540 <atoi+0x20>
 555:	5b                   	pop    %ebx
 556:	5d                   	pop    %ebp
 557:	c3                   	ret    
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000560 <memmove>:
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
 565:	8b 5d 10             	mov    0x10(%ebp),%ebx
 568:	8b 45 08             	mov    0x8(%ebp),%eax
 56b:	8b 75 0c             	mov    0xc(%ebp),%esi
 56e:	85 db                	test   %ebx,%ebx
 570:	7e 14                	jle    586 <memmove+0x26>
 572:	31 d2                	xor    %edx,%edx
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 578:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 57c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 57f:	83 c2 01             	add    $0x1,%edx
 582:	39 d3                	cmp    %edx,%ebx
 584:	75 f2                	jne    578 <memmove+0x18>
 586:	5b                   	pop    %ebx
 587:	5e                   	pop    %esi
 588:	5d                   	pop    %ebp
 589:	c3                   	ret    

0000058a <fork>:
 58a:	b8 01 00 00 00       	mov    $0x1,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <exit>:
 592:	b8 02 00 00 00       	mov    $0x2,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <wait>:
 59a:	b8 03 00 00 00       	mov    $0x3,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <pipe>:
 5a2:	b8 04 00 00 00       	mov    $0x4,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <read>:
 5aa:	b8 05 00 00 00       	mov    $0x5,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <write>:
 5b2:	b8 10 00 00 00       	mov    $0x10,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <close>:
 5ba:	b8 15 00 00 00       	mov    $0x15,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <kill>:
 5c2:	b8 06 00 00 00       	mov    $0x6,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <exec>:
 5ca:	b8 07 00 00 00       	mov    $0x7,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <open>:
 5d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <mknod>:
 5da:	b8 11 00 00 00       	mov    $0x11,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <unlink>:
 5e2:	b8 12 00 00 00       	mov    $0x12,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <fstat>:
 5ea:	b8 08 00 00 00       	mov    $0x8,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <link>:
 5f2:	b8 13 00 00 00       	mov    $0x13,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <mkdir>:
 5fa:	b8 14 00 00 00       	mov    $0x14,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <chdir>:
 602:	b8 09 00 00 00       	mov    $0x9,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <dup>:
 60a:	b8 0a 00 00 00       	mov    $0xa,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <getpid>:
 612:	b8 0b 00 00 00       	mov    $0xb,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <sbrk>:
 61a:	b8 0c 00 00 00       	mov    $0xc,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <sleep>:
 622:	b8 0d 00 00 00       	mov    $0xd,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <uptime>:
 62a:	b8 0e 00 00 00       	mov    $0xe,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    
 632:	66 90                	xchg   %ax,%ax
 634:	66 90                	xchg   %ax,%ax
 636:	66 90                	xchg   %ax,%ax
 638:	66 90                	xchg   %ax,%ax
 63a:	66 90                	xchg   %ax,%ax
 63c:	66 90                	xchg   %ax,%ax
 63e:	66 90                	xchg   %ax,%ax

00000640 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	89 c6                	mov    %eax,%esi
 648:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 64e:	85 db                	test   %ebx,%ebx
 650:	74 7e                	je     6d0 <printint+0x90>
 652:	89 d0                	mov    %edx,%eax
 654:	c1 e8 1f             	shr    $0x1f,%eax
 657:	84 c0                	test   %al,%al
 659:	74 75                	je     6d0 <printint+0x90>
    neg = 1;
    x = -xx;
 65b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 65d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 664:	f7 d8                	neg    %eax
 666:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 669:	31 ff                	xor    %edi,%edi
 66b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 66e:	89 ce                	mov    %ecx,%esi
 670:	eb 08                	jmp    67a <printint+0x3a>
 672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 678:	89 cf                	mov    %ecx,%edi
 67a:	31 d2                	xor    %edx,%edx
 67c:	8d 4f 01             	lea    0x1(%edi),%ecx
 67f:	f7 f6                	div    %esi
 681:	0f b6 92 44 0b 00 00 	movzbl 0xb44(%edx),%edx
  }while((x /= base) != 0);
 688:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 68a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 68d:	75 e9                	jne    678 <printint+0x38>
  if(neg)
 68f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 692:	8b 75 c0             	mov    -0x40(%ebp),%esi
 695:	85 c0                	test   %eax,%eax
 697:	74 08                	je     6a1 <printint+0x61>
    buf[i++] = '-';
 699:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 69e:	8d 4f 02             	lea    0x2(%edi),%ecx
 6a1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 6a5:	8d 76 00             	lea    0x0(%esi),%esi
 6a8:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ab:	83 ec 04             	sub    $0x4,%esp
 6ae:	83 ef 01             	sub    $0x1,%edi
 6b1:	6a 01                	push   $0x1
 6b3:	53                   	push   %ebx
 6b4:	56                   	push   %esi
 6b5:	88 45 d7             	mov    %al,-0x29(%ebp)
 6b8:	e8 f5 fe ff ff       	call   5b2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6bd:	83 c4 10             	add    $0x10,%esp
 6c0:	39 df                	cmp    %ebx,%edi
 6c2:	75 e4                	jne    6a8 <printint+0x68>
    putc(fd, buf[i]);
}
 6c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c7:	5b                   	pop    %ebx
 6c8:	5e                   	pop    %esi
 6c9:	5f                   	pop    %edi
 6ca:	5d                   	pop    %ebp
 6cb:	c3                   	ret    
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6d0:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6d2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6d9:	eb 8b                	jmp    666 <printint+0x26>
 6db:	90                   	nop
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006e0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6e9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ec:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6f5:	0f b6 1e             	movzbl (%esi),%ebx
 6f8:	83 c6 01             	add    $0x1,%esi
 6fb:	84 db                	test   %bl,%bl
 6fd:	0f 84 b0 00 00 00    	je     7b3 <printf+0xd3>
 703:	31 d2                	xor    %edx,%edx
 705:	eb 39                	jmp    740 <printf+0x60>
 707:	89 f6                	mov    %esi,%esi
 709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 710:	83 f8 25             	cmp    $0x25,%eax
 713:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 716:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 71b:	74 18                	je     735 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 71d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 720:	83 ec 04             	sub    $0x4,%esp
 723:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 726:	6a 01                	push   $0x1
 728:	50                   	push   %eax
 729:	57                   	push   %edi
 72a:	e8 83 fe ff ff       	call   5b2 <write>
 72f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 732:	83 c4 10             	add    $0x10,%esp
 735:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 738:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 73c:	84 db                	test   %bl,%bl
 73e:	74 73                	je     7b3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 740:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 742:	0f be cb             	movsbl %bl,%ecx
 745:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 748:	74 c6                	je     710 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 74a:	83 fa 25             	cmp    $0x25,%edx
 74d:	75 e6                	jne    735 <printf+0x55>
      if(c == 'd'){
 74f:	83 f8 64             	cmp    $0x64,%eax
 752:	0f 84 f8 00 00 00    	je     850 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 758:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 75e:	83 f9 70             	cmp    $0x70,%ecx
 761:	74 5d                	je     7c0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 763:	83 f8 73             	cmp    $0x73,%eax
 766:	0f 84 84 00 00 00    	je     7f0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 76c:	83 f8 63             	cmp    $0x63,%eax
 76f:	0f 84 ea 00 00 00    	je     85f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 775:	83 f8 25             	cmp    $0x25,%eax
 778:	0f 84 c2 00 00 00    	je     840 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 77e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 781:	83 ec 04             	sub    $0x4,%esp
 784:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 788:	6a 01                	push   $0x1
 78a:	50                   	push   %eax
 78b:	57                   	push   %edi
 78c:	e8 21 fe ff ff       	call   5b2 <write>
 791:	83 c4 0c             	add    $0xc,%esp
 794:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 797:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 79a:	6a 01                	push   $0x1
 79c:	50                   	push   %eax
 79d:	57                   	push   %edi
 79e:	83 c6 01             	add    $0x1,%esi
 7a1:	e8 0c fe ff ff       	call   5b2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7a6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7aa:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7ad:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7af:	84 db                	test   %bl,%bl
 7b1:	75 8d                	jne    740 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7b6:	5b                   	pop    %ebx
 7b7:	5e                   	pop    %esi
 7b8:	5f                   	pop    %edi
 7b9:	5d                   	pop    %ebp
 7ba:	c3                   	ret    
 7bb:	90                   	nop
 7bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7c0:	83 ec 0c             	sub    $0xc,%esp
 7c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7c8:	6a 00                	push   $0x0
 7ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7cd:	89 f8                	mov    %edi,%eax
 7cf:	8b 13                	mov    (%ebx),%edx
 7d1:	e8 6a fe ff ff       	call   640 <printint>
        ap++;
 7d6:	89 d8                	mov    %ebx,%eax
 7d8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7db:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 7dd:	83 c0 04             	add    $0x4,%eax
 7e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7e3:	e9 4d ff ff ff       	jmp    735 <printf+0x55>
 7e8:	90                   	nop
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 7f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7f3:	8b 18                	mov    (%eax),%ebx
        ap++;
 7f5:	83 c0 04             	add    $0x4,%eax
 7f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 7fb:	b8 3a 0b 00 00       	mov    $0xb3a,%eax
 800:	85 db                	test   %ebx,%ebx
 802:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 805:	0f b6 03             	movzbl (%ebx),%eax
 808:	84 c0                	test   %al,%al
 80a:	74 23                	je     82f <printf+0x14f>
 80c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 810:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 813:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 816:	83 ec 04             	sub    $0x4,%esp
 819:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 81b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 81e:	50                   	push   %eax
 81f:	57                   	push   %edi
 820:	e8 8d fd ff ff       	call   5b2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 825:	0f b6 03             	movzbl (%ebx),%eax
 828:	83 c4 10             	add    $0x10,%esp
 82b:	84 c0                	test   %al,%al
 82d:	75 e1                	jne    810 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 82f:	31 d2                	xor    %edx,%edx
 831:	e9 ff fe ff ff       	jmp    735 <printf+0x55>
 836:	8d 76 00             	lea    0x0(%esi),%esi
 839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 840:	83 ec 04             	sub    $0x4,%esp
 843:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 846:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 849:	6a 01                	push   $0x1
 84b:	e9 4c ff ff ff       	jmp    79c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 850:	83 ec 0c             	sub    $0xc,%esp
 853:	b9 0a 00 00 00       	mov    $0xa,%ecx
 858:	6a 01                	push   $0x1
 85a:	e9 6b ff ff ff       	jmp    7ca <printf+0xea>
 85f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 862:	83 ec 04             	sub    $0x4,%esp
 865:	8b 03                	mov    (%ebx),%eax
 867:	6a 01                	push   $0x1
 869:	88 45 e4             	mov    %al,-0x1c(%ebp)
 86c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 86f:	50                   	push   %eax
 870:	57                   	push   %edi
 871:	e8 3c fd ff ff       	call   5b2 <write>
 876:	e9 5b ff ff ff       	jmp    7d6 <printf+0xf6>
 87b:	66 90                	xchg   %ax,%ax
 87d:	66 90                	xchg   %ax,%ax
 87f:	90                   	nop

00000880 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 880:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 881:	a1 f8 0e 00 00       	mov    0xef8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 886:	89 e5                	mov    %esp,%ebp
 888:	57                   	push   %edi
 889:	56                   	push   %esi
 88a:	53                   	push   %ebx
 88b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 890:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 893:	39 c8                	cmp    %ecx,%eax
 895:	73 19                	jae    8b0 <free+0x30>
 897:	89 f6                	mov    %esi,%esi
 899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 8a0:	39 d1                	cmp    %edx,%ecx
 8a2:	72 1c                	jb     8c0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a4:	39 d0                	cmp    %edx,%eax
 8a6:	73 18                	jae    8c0 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a8:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8aa:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ac:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ae:	72 f0                	jb     8a0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b0:	39 d0                	cmp    %edx,%eax
 8b2:	72 f4                	jb     8a8 <free+0x28>
 8b4:	39 d1                	cmp    %edx,%ecx
 8b6:	73 f0                	jae    8a8 <free+0x28>
 8b8:	90                   	nop
 8b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8c3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8c6:	39 d7                	cmp    %edx,%edi
 8c8:	74 19                	je     8e3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8cd:	8b 50 04             	mov    0x4(%eax),%edx
 8d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8d3:	39 f1                	cmp    %esi,%ecx
 8d5:	74 23                	je     8fa <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8d7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8d9:	a3 f8 0e 00 00       	mov    %eax,0xef8
}
 8de:	5b                   	pop    %ebx
 8df:	5e                   	pop    %esi
 8e0:	5f                   	pop    %edi
 8e1:	5d                   	pop    %ebp
 8e2:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e3:	03 72 04             	add    0x4(%edx),%esi
 8e6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e9:	8b 10                	mov    (%eax),%edx
 8eb:	8b 12                	mov    (%edx),%edx
 8ed:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8f0:	8b 50 04             	mov    0x4(%eax),%edx
 8f3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8f6:	39 f1                	cmp    %esi,%ecx
 8f8:	75 dd                	jne    8d7 <free+0x57>
    p->s.size += bp->s.size;
 8fa:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 8fd:	a3 f8 0e 00 00       	mov    %eax,0xef8
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 902:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 905:	8b 53 f8             	mov    -0x8(%ebx),%edx
 908:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 90a:	5b                   	pop    %ebx
 90b:	5e                   	pop    %esi
 90c:	5f                   	pop    %edi
 90d:	5d                   	pop    %ebp
 90e:	c3                   	ret    
 90f:	90                   	nop

00000910 <morecore>:

static Header*
morecore(uint nu)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	53                   	push   %ebx
 914:	83 ec 04             	sub    $0x4,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 917:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 91c:	76 3a                	jbe    958 <morecore+0x48>
 91e:	89 c3                	mov    %eax,%ebx
 920:	8d 04 c5 00 00 00 00 	lea    0x0(,%eax,8),%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 927:	83 ec 0c             	sub    $0xc,%esp
 92a:	50                   	push   %eax
 92b:	e8 ea fc ff ff       	call   61a <sbrk>
  if(p == (char*)-1)
 930:	83 c4 10             	add    $0x10,%esp
 933:	83 f8 ff             	cmp    $0xffffffff,%eax
 936:	74 30                	je     968 <morecore+0x58>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 938:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 93b:	83 ec 0c             	sub    $0xc,%esp
 93e:	83 c0 08             	add    $0x8,%eax
 941:	50                   	push   %eax
 942:	e8 39 ff ff ff       	call   880 <free>
  return freep;
 947:	a1 f8 0e 00 00       	mov    0xef8,%eax
 94c:	83 c4 10             	add    $0x10,%esp
}
 94f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 952:	c9                   	leave  
 953:	c3                   	ret    
 954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 958:	b8 00 80 00 00       	mov    $0x8000,%eax
{
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
 95d:	bb 00 10 00 00       	mov    $0x1000,%ebx
 962:	eb c3                	jmp    927 <morecore+0x17>
 964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
 968:	31 c0                	xor    %eax,%eax
 96a:	eb e3                	jmp    94f <morecore+0x3f>
 96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000970 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 970:	55                   	push   %ebp
 971:	89 e5                	mov    %esp,%ebp
 973:	53                   	push   %ebx
 974:	83 ec 04             	sub    $0x4,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 977:	8b 45 08             	mov    0x8(%ebp),%eax
 97a:	8d 58 07             	lea    0x7(%eax),%ebx
    if((prevp = freep) == 0){
 97d:	a1 f8 0e 00 00       	mov    0xef8,%eax
malloc(uint nbytes)
{
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 982:	c1 eb 03             	shr    $0x3,%ebx
 985:	83 c3 01             	add    $0x1,%ebx
    if((prevp = freep) == 0){
 988:	85 c0                	test   %eax,%eax
 98a:	74 52                	je     9de <malloc+0x6e>
 98c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	8b 10                	mov    (%eax),%edx
        if(p->s.size >= nunits){
 992:	8b 4a 04             	mov    0x4(%edx),%ecx
 995:	39 cb                	cmp    %ecx,%ebx
 997:	76 1f                	jbe    9b8 <malloc+0x48>
                p->s.size = nunits;
            }
            freep = prevp;
            return (void*)(p + 1);
        }
        if(p == freep)
 999:	39 15 f8 0e 00 00    	cmp    %edx,0xef8
 99f:	89 d0                	mov    %edx,%eax
 9a1:	75 ed                	jne    990 <malloc+0x20>
            if((p = morecore(nunits)) == 0)
 9a3:	89 d8                	mov    %ebx,%eax
 9a5:	e8 66 ff ff ff       	call   910 <morecore>
 9aa:	85 c0                	test   %eax,%eax
 9ac:	75 e2                	jne    990 <malloc+0x20>
                return 0;
 9ae:	31 c0                	xor    %eax,%eax
 9b0:	eb 1d                	jmp    9cf <malloc+0x5f>
 9b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size >= nunits){
            if(p->s.size == nunits)
 9b8:	39 cb                	cmp    %ecx,%ebx
 9ba:	74 1c                	je     9d8 <malloc+0x68>
                prevp->s.ptr = p->s.ptr;
            else {
                p->s.size -= nunits;
 9bc:	29 d9                	sub    %ebx,%ecx
 9be:	89 4a 04             	mov    %ecx,0x4(%edx)
                p += p->s.size;
 9c1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
                p->s.size = nunits;
 9c4:	89 5a 04             	mov    %ebx,0x4(%edx)
            }
            freep = prevp;
 9c7:	a3 f8 0e 00 00       	mov    %eax,0xef8
            return (void*)(p + 1);
 9cc:	8d 42 08             	lea    0x8(%edx),%eax
        }
        if(p == freep)
            if((p = morecore(nunits)) == 0)
                return 0;
    }
}
 9cf:	83 c4 04             	add    $0x4,%esp
 9d2:	5b                   	pop    %ebx
 9d3:	5d                   	pop    %ebp
 9d4:	c3                   	ret    
 9d5:	8d 76 00             	lea    0x0(%esi),%esi
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size >= nunits){
            if(p->s.size == nunits)
                prevp->s.ptr = p->s.ptr;
 9d8:	8b 0a                	mov    (%edx),%ecx
 9da:	89 08                	mov    %ecx,(%eax)
 9dc:	eb e9                	jmp    9c7 <malloc+0x57>
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
        base.s.ptr = freep = prevp = &base;
 9de:	c7 05 f8 0e 00 00 fc 	movl   $0xefc,0xef8
 9e5:	0e 00 00 
 9e8:	c7 05 fc 0e 00 00 fc 	movl   $0xefc,0xefc
 9ef:	0e 00 00 
        base.s.size = 0;
 9f2:	ba fc 0e 00 00       	mov    $0xefc,%edx
 9f7:	c7 05 00 0f 00 00 00 	movl   $0x0,0xf00
 9fe:	00 00 00 
 a01:	eb 96                	jmp    999 <malloc+0x29>
 a03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a10 <pmalloc>:

// TODO we are not sure where we should do the page protected and read only PTE_W...

void*
pmalloc()
{
 a10:	55                   	push   %ebp
 a11:	89 e5                	mov    %esp,%ebp
 a13:	83 ec 08             	sub    $0x8,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = ( 4096 + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
 a16:	a1 f8 0e 00 00       	mov    0xef8,%eax
 a1b:	85 c0                	test   %eax,%eax
 a1d:	74 46                	je     a65 <pmalloc+0x55>
 a1f:	90                   	nop
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a20:	8b 10                	mov    (%eax),%edx
        if(p->s.size == nunits){
 a22:	81 7a 04 01 02 00 00 	cmpl   $0x201,0x4(%edx)
 a29:	74 25                	je     a50 <pmalloc+0x40>
            freep = prevp;
            (p+1)->x = 1;
            return (void*)(p + 1);
        }

        if(p == freep)
 a2b:	39 15 f8 0e 00 00    	cmp    %edx,0xef8
 a31:	89 d0                	mov    %edx,%eax
 a33:	75 eb                	jne    a20 <pmalloc+0x10>
            if((p = morecore(nunits)) == 0)
 a35:	b8 01 02 00 00       	mov    $0x201,%eax
 a3a:	e8 d1 fe ff ff       	call   910 <morecore>
 a3f:	85 c0                	test   %eax,%eax
 a41:	75 dd                	jne    a20 <pmalloc+0x10>
                return 0;
 a43:	31 c0                	xor    %eax,%eax
    }
}
 a45:	c9                   	leave  
 a46:	c3                   	ret    
 a47:	89 f6                	mov    %esi,%esi
 a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size == nunits){
            prevp->s.ptr = p->s.ptr;
 a50:	8b 0a                	mov    (%edx),%ecx
            freep = prevp;
 a52:	a3 f8 0e 00 00       	mov    %eax,0xef8
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size == nunits){
            prevp->s.ptr = p->s.ptr;
 a57:	89 08                	mov    %ecx,(%eax)
            freep = prevp;
            (p+1)->x = 1;
 a59:	c7 42 08 01 00 00 00 	movl   $0x1,0x8(%edx)
            return (void*)(p + 1);
 a60:	8d 42 08             	lea    0x8(%edx),%eax

        if(p == freep)
            if((p = morecore(nunits)) == 0)
                return 0;
    }
}
 a63:	c9                   	leave  
 a64:	c3                   	ret    
    Header *p, *prevp;
    uint nunits;

    nunits = ( 4096 + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
        base.s.ptr = freep = prevp = &base;
 a65:	c7 05 f8 0e 00 00 fc 	movl   $0xefc,0xef8
 a6c:	0e 00 00 
 a6f:	c7 05 fc 0e 00 00 fc 	movl   $0xefc,0xefc
 a76:	0e 00 00 
        base.s.size = 0;
 a79:	ba fc 0e 00 00       	mov    $0xefc,%edx
 a7e:	c7 05 00 0f 00 00 00 	movl   $0x0,0xf00
 a85:	00 00 00 
 a88:	eb a1                	jmp    a2b <pmalloc+0x1b>
 a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000a90 <protect_page>:
    }
}


int protect_page(void* ap)
{
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp
 a93:	8b 45 08             	mov    0x8(%ebp),%eax
    Header *p;
    if( ap )
 a96:	85 c0                	test   %eax,%eax
 a98:	74 1e                	je     ab8 <protect_page+0x28>
    {
        if( (uint)ap % 4096 != 0 )
 a9a:	a9 ff 0f 00 00       	test   $0xfff,%eax
 a9f:	75 17                	jne    ab8 <protect_page+0x28>
            return -1;

        p = ap;
        if( !p->pmalloced )
 aa1:	8b 10                	mov    (%eax),%edx
 aa3:	85 d2                	test   %edx,%edx
 aa5:	74 11                	je     ab8 <protect_page+0x28>
            return -1;

        p->protected = 1;
 aa7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        return 1;
 aad:	b8 01 00 00 00       	mov    $0x1,%eax
    }
    else
        return -1;
}
 ab2:	5d                   	pop    %ebp
 ab3:	c3                   	ret    
 ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

        p->protected = 1;
        return 1;
    }
    else
        return -1;
 ab8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 abd:	5d                   	pop    %ebp
 abe:	c3                   	ret    
 abf:	90                   	nop

00000ac0 <pfree>:



int pfree(void* ap) {
 ac0:	55                   	push   %ebp
 ac1:	89 e5                	mov    %esp,%ebp
 ac3:	8b 45 08             	mov    0x8(%ebp),%eax
    Header *p;
    if (ap) {
 ac6:	85 c0                	test   %eax,%eax
 ac8:	74 1e                	je     ae8 <pfree+0x28>
        if ((uint) ap % 4096 != 0)
 aca:	a9 ff 0f 00 00       	test   $0xfff,%eax
 acf:	75 17                	jne    ae8 <pfree+0x28>
            return -1;

        p = ap;
        if (p->protected) {
 ad1:	8b 10                	mov    (%eax),%edx
 ad3:	85 d2                	test   %edx,%edx
 ad5:	74 11                	je     ae8 <pfree+0x28>
            free(ap);
 ad7:	50                   	push   %eax
 ad8:	e8 a3 fd ff ff       	call   880 <free>
            return 1;
 add:	58                   	pop    %eax
 ade:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    return -1;
}
 ae3:	c9                   	leave  
 ae4:	c3                   	ret    
 ae5:	8d 76 00             	lea    0x0(%esi),%esi
        if (p->protected) {
            free(ap);
            return 1;
        }
    }
    return -1;
 ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 aed:	c9                   	leave  
 aee:	c3                   	ret    
