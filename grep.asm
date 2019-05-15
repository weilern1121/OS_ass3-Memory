
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
  19:	83 f8 01             	cmp    $0x1,%eax
  }
}

int
main(int argc, char *argv[])
{
  1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int fd, i;
  char *pattern;

  if(argc <= 1){
  1f:	7e 76                	jle    97 <main+0x97>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  21:	8b 43 04             	mov    0x4(%ebx),%eax
  24:	83 c3 08             	add    $0x8,%ebx

  if(argc <= 2){
  27:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  2b:	be 02 00 00 00       	mov    $0x2,%esi

  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  30:	89 45 e0             	mov    %eax,-0x20(%ebp)

  if(argc <= 2){
  33:	74 53                	je     88 <main+0x88>
  35:	8d 76 00             	lea    0x0(%esi),%esi
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  38:	83 ec 08             	sub    $0x8,%esp
  3b:	6a 00                	push   $0x0
  3d:	ff 33                	pushl  (%ebx)
  3f:	e8 6e 05 00 00       	call   5b2 <open>
  44:	83 c4 10             	add    $0x10,%esp
  47:	85 c0                	test   %eax,%eax
  49:	89 c7                	mov    %eax,%edi
  4b:	78 27                	js     74 <main+0x74>
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  4d:	83 ec 08             	sub    $0x8,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  50:	83 c6 01             	add    $0x1,%esi
  53:	83 c3 04             	add    $0x4,%ebx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  56:	50                   	push   %eax
  57:	ff 75 e0             	pushl  -0x20(%ebp)
  5a:	e8 c1 01 00 00       	call   220 <grep>
    close(fd);
  5f:	89 3c 24             	mov    %edi,(%esp)
  62:	e8 33 05 00 00       	call   59a <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  67:	83 c4 10             	add    $0x10,%esp
  6a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  6d:	7f c9                	jg     38 <main+0x38>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
  6f:	e8 fe 04 00 00       	call   572 <exit>
    exit();
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
  74:	50                   	push   %eax
  75:	ff 33                	pushl  (%ebx)
  77:	68 f0 0a 00 00       	push   $0xaf0
  7c:	6a 01                	push   $0x1
  7e:	e8 3d 06 00 00       	call   6c0 <printf>
      exit();
  83:	e8 ea 04 00 00       	call   572 <exit>
    exit();
  }
  pattern = argv[1];

  if(argc <= 2){
    grep(pattern, 0);
  88:	52                   	push   %edx
  89:	52                   	push   %edx
  8a:	6a 00                	push   $0x0
  8c:	50                   	push   %eax
  8d:	e8 8e 01 00 00       	call   220 <grep>
    exit();
  92:	e8 db 04 00 00       	call   572 <exit>
{
  int fd, i;
  char *pattern;

  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
  97:	51                   	push   %ecx
  98:	51                   	push   %ecx
  99:	68 d0 0a 00 00       	push   $0xad0
  9e:	6a 02                	push   $0x2
  a0:	e8 1b 06 00 00       	call   6c0 <printf>
    exit();
  a5:	e8 c8 04 00 00       	call   572 <exit>
  aa:	66 90                	xchg   %ax,%ax
  ac:	66 90                	xchg   %ax,%ax
  ae:	66 90                	xchg   %ax,%ax

000000b0 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	83 ec 0c             	sub    $0xc,%esp
  b9:	8b 75 08             	mov    0x8(%ebp),%esi
  bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  c8:	83 ec 08             	sub    $0x8,%esp
  cb:	53                   	push   %ebx
  cc:	57                   	push   %edi
  cd:	e8 3e 00 00 00       	call   110 <matchhere>
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	85 c0                	test   %eax,%eax
  d7:	75 1f                	jne    f8 <matchstar+0x48>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  d9:	0f be 13             	movsbl (%ebx),%edx
  dc:	84 d2                	test   %dl,%dl
  de:	74 0c                	je     ec <matchstar+0x3c>
  e0:	83 c3 01             	add    $0x1,%ebx
  e3:	83 fe 2e             	cmp    $0x2e,%esi
  e6:	74 e0                	je     c8 <matchstar+0x18>
  e8:	39 f2                	cmp    %esi,%edx
  ea:	74 dc                	je     c8 <matchstar+0x18>
  return 0;
}
  ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ef:	5b                   	pop    %ebx
  f0:	5e                   	pop    %esi
  f1:	5f                   	pop    %edi
  f2:	5d                   	pop    %ebp
  f3:	c3                   	ret    
  f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  fb:	b8 01 00 00 00       	mov    $0x1,%eax
  }while(*text!='\0' && (*text++==c || c=='.'));
  return 0;
}
 100:	5b                   	pop    %ebx
 101:	5e                   	pop    %esi
 102:	5f                   	pop    %edi
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    
 105:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	56                   	push   %esi
 115:	53                   	push   %ebx
 116:	83 ec 0c             	sub    $0xc,%esp
 119:	8b 45 08             	mov    0x8(%ebp),%eax
 11c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(re[0] == '\0')
 11f:	0f b6 18             	movzbl (%eax),%ebx
 122:	84 db                	test   %bl,%bl
 124:	74 63                	je     189 <matchhere+0x79>
    return 1;
  if(re[1] == '*')
 126:	0f be 50 01          	movsbl 0x1(%eax),%edx
 12a:	80 fa 2a             	cmp    $0x2a,%dl
 12d:	74 7b                	je     1aa <matchhere+0x9a>
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
 12f:	80 fb 24             	cmp    $0x24,%bl
 132:	75 08                	jne    13c <matchhere+0x2c>
 134:	84 d2                	test   %dl,%dl
 136:	0f 84 8a 00 00 00    	je     1c6 <matchhere+0xb6>
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 13c:	0f b6 37             	movzbl (%edi),%esi
 13f:	89 f1                	mov    %esi,%ecx
 141:	84 c9                	test   %cl,%cl
 143:	74 5b                	je     1a0 <matchhere+0x90>
 145:	38 cb                	cmp    %cl,%bl
 147:	74 05                	je     14e <matchhere+0x3e>
 149:	80 fb 2e             	cmp    $0x2e,%bl
 14c:	75 52                	jne    1a0 <matchhere+0x90>
    return matchhere(re+1, text+1);
 14e:	83 c7 01             	add    $0x1,%edi
 151:	83 c0 01             	add    $0x1,%eax
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
 154:	84 d2                	test   %dl,%dl
 156:	74 31                	je     189 <matchhere+0x79>
    return 1;
  if(re[1] == '*')
 158:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
 15c:	80 fb 2a             	cmp    $0x2a,%bl
 15f:	74 4c                	je     1ad <matchhere+0x9d>
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
 161:	80 fa 24             	cmp    $0x24,%dl
 164:	75 04                	jne    16a <matchhere+0x5a>
 166:	84 db                	test   %bl,%bl
 168:	74 5c                	je     1c6 <matchhere+0xb6>
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 16a:	0f b6 37             	movzbl (%edi),%esi
 16d:	89 f1                	mov    %esi,%ecx
 16f:	84 c9                	test   %cl,%cl
 171:	74 2d                	je     1a0 <matchhere+0x90>
 173:	80 fa 2e             	cmp    $0x2e,%dl
 176:	74 04                	je     17c <matchhere+0x6c>
 178:	38 d1                	cmp    %dl,%cl
 17a:	75 24                	jne    1a0 <matchhere+0x90>
 17c:	0f be d3             	movsbl %bl,%edx
    return matchhere(re+1, text+1);
 17f:	83 c7 01             	add    $0x1,%edi
 182:	83 c0 01             	add    $0x1,%eax
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
 185:	84 d2                	test   %dl,%dl
 187:	75 cf                	jne    158 <matchhere+0x48>
    return 1;
 189:	b8 01 00 00 00       	mov    $0x1,%eax
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
 18e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 191:	5b                   	pop    %ebx
 192:	5e                   	pop    %esi
 193:	5f                   	pop    %edi
 194:	5d                   	pop    %ebp
 195:	c3                   	ret    
 196:	8d 76 00             	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 1a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
 1a3:	31 c0                	xor    %eax,%eax
}
 1a5:	5b                   	pop    %ebx
 1a6:	5e                   	pop    %esi
 1a7:	5f                   	pop    %edi
 1a8:	5d                   	pop    %ebp
 1a9:	c3                   	ret    
// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
 1aa:	0f be d3             	movsbl %bl,%edx
    return matchstar(re[0], re+2, text);
 1ad:	83 ec 04             	sub    $0x4,%esp
 1b0:	83 c0 02             	add    $0x2,%eax
 1b3:	57                   	push   %edi
 1b4:	50                   	push   %eax
 1b5:	52                   	push   %edx
 1b6:	e8 f5 fe ff ff       	call   b0 <matchstar>
 1bb:	83 c4 10             	add    $0x10,%esp
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
 1be:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c1:	5b                   	pop    %ebx
 1c2:	5e                   	pop    %esi
 1c3:	5f                   	pop    %edi
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
 1c6:	31 c0                	xor    %eax,%eax
 1c8:	80 3f 00             	cmpb   $0x0,(%edi)
 1cb:	0f 94 c0             	sete   %al
 1ce:	eb be                	jmp    18e <matchhere+0x7e>

000001d0 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	56                   	push   %esi
 1d4:	53                   	push   %ebx
 1d5:	8b 75 08             	mov    0x8(%ebp),%esi
 1d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
 1db:	80 3e 5e             	cmpb   $0x5e,(%esi)
 1de:	75 11                	jne    1f1 <match+0x21>
 1e0:	eb 2c                	jmp    20e <match+0x3e>
 1e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
 1e8:	83 c3 01             	add    $0x1,%ebx
 1eb:	80 7b ff 00          	cmpb   $0x0,-0x1(%ebx)
 1ef:	74 16                	je     207 <match+0x37>
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
 1f1:	83 ec 08             	sub    $0x8,%esp
 1f4:	53                   	push   %ebx
 1f5:	56                   	push   %esi
 1f6:	e8 15 ff ff ff       	call   110 <matchhere>
 1fb:	83 c4 10             	add    $0x10,%esp
 1fe:	85 c0                	test   %eax,%eax
 200:	74 e6                	je     1e8 <match+0x18>
      return 1;
 202:	b8 01 00 00 00       	mov    $0x1,%eax
  }while(*text++ != '\0');
  return 0;
}
 207:	8d 65 f8             	lea    -0x8(%ebp),%esp
 20a:	5b                   	pop    %ebx
 20b:	5e                   	pop    %esi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 20e:	83 c6 01             	add    $0x1,%esi
 211:	89 75 08             	mov    %esi,0x8(%ebp)
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
  return 0;
}
 214:	8d 65 f8             	lea    -0x8(%ebp),%esp
 217:	5b                   	pop    %ebx
 218:	5e                   	pop    %esi
 219:	5d                   	pop    %ebp

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 21a:	e9 f1 fe ff ff       	jmp    110 <matchhere>
 21f:	90                   	nop

00000220 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	53                   	push   %ebx
 226:	83 ec 1c             	sub    $0x1c,%esp
 229:	8b 75 08             	mov    0x8(%ebp),%esi
  int n, m;
  char *p, *q;

  m = 0;
 22c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 233:	90                   	nop
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 238:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 23b:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 240:	83 ec 04             	sub    $0x4,%esp
 243:	29 c8                	sub    %ecx,%eax
 245:	50                   	push   %eax
 246:	8d 81 60 0f 00 00    	lea    0xf60(%ecx),%eax
 24c:	50                   	push   %eax
 24d:	ff 75 0c             	pushl  0xc(%ebp)
 250:	e8 35 03 00 00       	call   58a <read>
 255:	83 c4 10             	add    $0x10,%esp
 258:	85 c0                	test   %eax,%eax
 25a:	0f 8e ac 00 00 00    	jle    30c <grep+0xec>
    m += n;
 260:	01 45 e4             	add    %eax,-0x1c(%ebp)
    buf[m] = '\0';
    p = buf;
 263:	bb 60 0f 00 00       	mov    $0xf60,%ebx
  int n, m;
  char *p, *q;

  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
 268:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    buf[m] = '\0';
 26b:	c6 82 60 0f 00 00 00 	movb   $0x0,0xf60(%edx)
 272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    p = buf;
    while((q = strchr(p, '\n')) != 0){
 278:	83 ec 08             	sub    $0x8,%esp
 27b:	6a 0a                	push   $0xa
 27d:	53                   	push   %ebx
 27e:	e8 6d 01 00 00       	call   3f0 <strchr>
 283:	83 c4 10             	add    $0x10,%esp
 286:	85 c0                	test   %eax,%eax
 288:	89 c7                	mov    %eax,%edi
 28a:	74 3c                	je     2c8 <grep+0xa8>
      *q = 0;
      if(match(pattern, p)){
 28c:	83 ec 08             	sub    $0x8,%esp
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      *q = 0;
 28f:	c6 07 00             	movb   $0x0,(%edi)
      if(match(pattern, p)){
 292:	53                   	push   %ebx
 293:	56                   	push   %esi
 294:	e8 37 ff ff ff       	call   1d0 <match>
 299:	83 c4 10             	add    $0x10,%esp
 29c:	85 c0                	test   %eax,%eax
 29e:	75 08                	jne    2a8 <grep+0x88>
 2a0:	8d 5f 01             	lea    0x1(%edi),%ebx
 2a3:	eb d3                	jmp    278 <grep+0x58>
 2a5:	8d 76 00             	lea    0x0(%esi),%esi
        *q = '\n';
 2a8:	c6 07 0a             	movb   $0xa,(%edi)
        write(1, p, q+1 - p);
 2ab:	83 c7 01             	add    $0x1,%edi
 2ae:	83 ec 04             	sub    $0x4,%esp
 2b1:	89 f8                	mov    %edi,%eax
 2b3:	29 d8                	sub    %ebx,%eax
 2b5:	50                   	push   %eax
 2b6:	53                   	push   %ebx
 2b7:	89 fb                	mov    %edi,%ebx
 2b9:	6a 01                	push   $0x1
 2bb:	e8 d2 02 00 00       	call   592 <write>
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	eb b3                	jmp    278 <grep+0x58>
 2c5:	8d 76 00             	lea    0x0(%esi),%esi
      }
      p = q+1;
    }
    if(p == buf)
 2c8:	81 fb 60 0f 00 00    	cmp    $0xf60,%ebx
 2ce:	74 30                	je     300 <grep+0xe0>
      m = 0;
    if(m > 0){
 2d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2d3:	85 c0                	test   %eax,%eax
 2d5:	0f 8e 5d ff ff ff    	jle    238 <grep+0x18>
      m -= p - buf;
 2db:	89 d8                	mov    %ebx,%eax
      memmove(buf, p, m);
 2dd:	83 ec 04             	sub    $0x4,%esp
      p = q+1;
    }
    if(p == buf)
      m = 0;
    if(m > 0){
      m -= p - buf;
 2e0:	2d 60 0f 00 00       	sub    $0xf60,%eax
 2e5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
 2e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      memmove(buf, p, m);
 2eb:	51                   	push   %ecx
 2ec:	53                   	push   %ebx
 2ed:	68 60 0f 00 00       	push   $0xf60
 2f2:	e8 49 02 00 00       	call   540 <memmove>
 2f7:	83 c4 10             	add    $0x10,%esp
 2fa:	e9 39 ff ff ff       	jmp    238 <grep+0x18>
 2ff:	90                   	nop
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
      m = 0;
 300:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 307:	e9 2c ff ff ff       	jmp    238 <grep+0x18>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 30c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 30f:	5b                   	pop    %ebx
 310:	5e                   	pop    %esi
 311:	5f                   	pop    %edi
 312:	5d                   	pop    %ebp
 313:	c3                   	ret    
 314:	66 90                	xchg   %ax,%ax
 316:	66 90                	xchg   %ax,%ax
 318:	66 90                	xchg   %ax,%ax
 31a:	66 90                	xchg   %ax,%ax
 31c:	66 90                	xchg   %ax,%ax
 31e:	66 90                	xchg   %ax,%ax

00000320 <strcpy>:
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	53                   	push   %ebx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 32a:	89 c2                	mov    %eax,%edx
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 330:	83 c1 01             	add    $0x1,%ecx
 333:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 337:	83 c2 01             	add    $0x1,%edx
 33a:	84 db                	test   %bl,%bl
 33c:	88 5a ff             	mov    %bl,-0x1(%edx)
 33f:	75 ef                	jne    330 <strcpy+0x10>
 341:	5b                   	pop    %ebx
 342:	5d                   	pop    %ebp
 343:	c3                   	ret    
 344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 34a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000350 <strcmp>:
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	53                   	push   %ebx
 354:	8b 55 08             	mov    0x8(%ebp),%edx
 357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 35a:	0f b6 02             	movzbl (%edx),%eax
 35d:	0f b6 19             	movzbl (%ecx),%ebx
 360:	84 c0                	test   %al,%al
 362:	75 1c                	jne    380 <strcmp+0x30>
 364:	eb 2a                	jmp    390 <strcmp+0x40>
 366:	8d 76 00             	lea    0x0(%esi),%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 370:	83 c2 01             	add    $0x1,%edx
 373:	0f b6 02             	movzbl (%edx),%eax
 376:	83 c1 01             	add    $0x1,%ecx
 379:	0f b6 19             	movzbl (%ecx),%ebx
 37c:	84 c0                	test   %al,%al
 37e:	74 10                	je     390 <strcmp+0x40>
 380:	38 d8                	cmp    %bl,%al
 382:	74 ec                	je     370 <strcmp+0x20>
 384:	29 d8                	sub    %ebx,%eax
 386:	5b                   	pop    %ebx
 387:	5d                   	pop    %ebp
 388:	c3                   	ret    
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 390:	31 c0                	xor    %eax,%eax
 392:	29 d8                	sub    %ebx,%eax
 394:	5b                   	pop    %ebx
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    
 397:	89 f6                	mov    %esi,%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003a0 <strlen>:
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3a6:	80 39 00             	cmpb   $0x0,(%ecx)
 3a9:	74 15                	je     3c0 <strlen+0x20>
 3ab:	31 d2                	xor    %edx,%edx
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
 3b0:	83 c2 01             	add    $0x1,%edx
 3b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3b7:	89 d0                	mov    %edx,%eax
 3b9:	75 f5                	jne    3b0 <strlen+0x10>
 3bb:	5d                   	pop    %ebp
 3bc:	c3                   	ret    
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	31 c0                	xor    %eax,%eax
 3c2:	5d                   	pop    %ebp
 3c3:	c3                   	ret    
 3c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003d0 <memset>:
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	8b 55 08             	mov    0x8(%ebp),%edx
 3d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	89 d7                	mov    %edx,%edi
 3df:	fc                   	cld    
 3e0:	f3 aa                	rep stos %al,%es:(%edi)
 3e2:	89 d0                	mov    %edx,%eax
 3e4:	5f                   	pop    %edi
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret    
 3e7:	89 f6                	mov    %esi,%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003f0 <strchr>:
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	53                   	push   %ebx
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3fa:	0f b6 10             	movzbl (%eax),%edx
 3fd:	84 d2                	test   %dl,%dl
 3ff:	74 1d                	je     41e <strchr+0x2e>
 401:	38 d3                	cmp    %dl,%bl
 403:	89 d9                	mov    %ebx,%ecx
 405:	75 0d                	jne    414 <strchr+0x24>
 407:	eb 17                	jmp    420 <strchr+0x30>
 409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 410:	38 ca                	cmp    %cl,%dl
 412:	74 0c                	je     420 <strchr+0x30>
 414:	83 c0 01             	add    $0x1,%eax
 417:	0f b6 10             	movzbl (%eax),%edx
 41a:	84 d2                	test   %dl,%dl
 41c:	75 f2                	jne    410 <strchr+0x20>
 41e:	31 c0                	xor    %eax,%eax
 420:	5b                   	pop    %ebx
 421:	5d                   	pop    %ebp
 422:	c3                   	ret    
 423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <gets>:
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	31 f6                	xor    %esi,%esi
 438:	89 f3                	mov    %esi,%ebx
 43a:	83 ec 1c             	sub    $0x1c,%esp
 43d:	8b 7d 08             	mov    0x8(%ebp),%edi
 440:	eb 2f                	jmp    471 <gets+0x41>
 442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 448:	8d 45 e7             	lea    -0x19(%ebp),%eax
 44b:	83 ec 04             	sub    $0x4,%esp
 44e:	6a 01                	push   $0x1
 450:	50                   	push   %eax
 451:	6a 00                	push   $0x0
 453:	e8 32 01 00 00       	call   58a <read>
 458:	83 c4 10             	add    $0x10,%esp
 45b:	85 c0                	test   %eax,%eax
 45d:	7e 1c                	jle    47b <gets+0x4b>
 45f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 463:	83 c7 01             	add    $0x1,%edi
 466:	88 47 ff             	mov    %al,-0x1(%edi)
 469:	3c 0a                	cmp    $0xa,%al
 46b:	74 23                	je     490 <gets+0x60>
 46d:	3c 0d                	cmp    $0xd,%al
 46f:	74 1f                	je     490 <gets+0x60>
 471:	83 c3 01             	add    $0x1,%ebx
 474:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 477:	89 fe                	mov    %edi,%esi
 479:	7c cd                	jl     448 <gets+0x18>
 47b:	89 f3                	mov    %esi,%ebx
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	c6 03 00             	movb   $0x0,(%ebx)
 483:	8d 65 f4             	lea    -0xc(%ebp),%esp
 486:	5b                   	pop    %ebx
 487:	5e                   	pop    %esi
 488:	5f                   	pop    %edi
 489:	5d                   	pop    %ebp
 48a:	c3                   	ret    
 48b:	90                   	nop
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 490:	8b 75 08             	mov    0x8(%ebp),%esi
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	01 de                	add    %ebx,%esi
 498:	89 f3                	mov    %esi,%ebx
 49a:	c6 03 00             	movb   $0x0,(%ebx)
 49d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a0:	5b                   	pop    %ebx
 4a1:	5e                   	pop    %esi
 4a2:	5f                   	pop    %edi
 4a3:	5d                   	pop    %ebp
 4a4:	c3                   	ret    
 4a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004b0 <stat>:
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	56                   	push   %esi
 4b4:	53                   	push   %ebx
 4b5:	83 ec 08             	sub    $0x8,%esp
 4b8:	6a 00                	push   $0x0
 4ba:	ff 75 08             	pushl  0x8(%ebp)
 4bd:	e8 f0 00 00 00       	call   5b2 <open>
 4c2:	83 c4 10             	add    $0x10,%esp
 4c5:	85 c0                	test   %eax,%eax
 4c7:	78 27                	js     4f0 <stat+0x40>
 4c9:	83 ec 08             	sub    $0x8,%esp
 4cc:	ff 75 0c             	pushl  0xc(%ebp)
 4cf:	89 c3                	mov    %eax,%ebx
 4d1:	50                   	push   %eax
 4d2:	e8 f3 00 00 00       	call   5ca <fstat>
 4d7:	89 1c 24             	mov    %ebx,(%esp)
 4da:	89 c6                	mov    %eax,%esi
 4dc:	e8 b9 00 00 00       	call   59a <close>
 4e1:	83 c4 10             	add    $0x10,%esp
 4e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4e7:	89 f0                	mov    %esi,%eax
 4e9:	5b                   	pop    %ebx
 4ea:	5e                   	pop    %esi
 4eb:	5d                   	pop    %ebp
 4ec:	c3                   	ret    
 4ed:	8d 76 00             	lea    0x0(%esi),%esi
 4f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4f5:	eb ed                	jmp    4e4 <stat+0x34>
 4f7:	89 f6                	mov    %esi,%esi
 4f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000500 <atoi>:
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	53                   	push   %ebx
 504:	8b 4d 08             	mov    0x8(%ebp),%ecx
 507:	0f be 11             	movsbl (%ecx),%edx
 50a:	8d 42 d0             	lea    -0x30(%edx),%eax
 50d:	3c 09                	cmp    $0x9,%al
 50f:	b8 00 00 00 00       	mov    $0x0,%eax
 514:	77 1f                	ja     535 <atoi+0x35>
 516:	8d 76 00             	lea    0x0(%esi),%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 520:	8d 04 80             	lea    (%eax,%eax,4),%eax
 523:	83 c1 01             	add    $0x1,%ecx
 526:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 52a:	0f be 11             	movsbl (%ecx),%edx
 52d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 530:	80 fb 09             	cmp    $0x9,%bl
 533:	76 eb                	jbe    520 <atoi+0x20>
 535:	5b                   	pop    %ebx
 536:	5d                   	pop    %ebp
 537:	c3                   	ret    
 538:	90                   	nop
 539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000540 <memmove>:
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	56                   	push   %esi
 544:	53                   	push   %ebx
 545:	8b 5d 10             	mov    0x10(%ebp),%ebx
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	8b 75 0c             	mov    0xc(%ebp),%esi
 54e:	85 db                	test   %ebx,%ebx
 550:	7e 14                	jle    566 <memmove+0x26>
 552:	31 d2                	xor    %edx,%edx
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 558:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 55c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 55f:	83 c2 01             	add    $0x1,%edx
 562:	39 d3                	cmp    %edx,%ebx
 564:	75 f2                	jne    558 <memmove+0x18>
 566:	5b                   	pop    %ebx
 567:	5e                   	pop    %esi
 568:	5d                   	pop    %ebp
 569:	c3                   	ret    

0000056a <fork>:
 56a:	b8 01 00 00 00       	mov    $0x1,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <exit>:
 572:	b8 02 00 00 00       	mov    $0x2,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <wait>:
 57a:	b8 03 00 00 00       	mov    $0x3,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <pipe>:
 582:	b8 04 00 00 00       	mov    $0x4,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <read>:
 58a:	b8 05 00 00 00       	mov    $0x5,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <write>:
 592:	b8 10 00 00 00       	mov    $0x10,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <close>:
 59a:	b8 15 00 00 00       	mov    $0x15,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <kill>:
 5a2:	b8 06 00 00 00       	mov    $0x6,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <exec>:
 5aa:	b8 07 00 00 00       	mov    $0x7,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <open>:
 5b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <mknod>:
 5ba:	b8 11 00 00 00       	mov    $0x11,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <unlink>:
 5c2:	b8 12 00 00 00       	mov    $0x12,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <fstat>:
 5ca:	b8 08 00 00 00       	mov    $0x8,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <link>:
 5d2:	b8 13 00 00 00       	mov    $0x13,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <mkdir>:
 5da:	b8 14 00 00 00       	mov    $0x14,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <chdir>:
 5e2:	b8 09 00 00 00       	mov    $0x9,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <dup>:
 5ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <getpid>:
 5f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <sbrk>:
 5fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <sleep>:
 602:	b8 0d 00 00 00       	mov    $0xd,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <uptime>:
 60a:	b8 0e 00 00 00       	mov    $0xe,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    
 612:	66 90                	xchg   %ax,%ax
 614:	66 90                	xchg   %ax,%ax
 616:	66 90                	xchg   %ax,%ax
 618:	66 90                	xchg   %ax,%ax
 61a:	66 90                	xchg   %ax,%ax
 61c:	66 90                	xchg   %ax,%ax
 61e:	66 90                	xchg   %ax,%ax

00000620 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	89 c6                	mov    %eax,%esi
 628:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 62b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 62e:	85 db                	test   %ebx,%ebx
 630:	74 7e                	je     6b0 <printint+0x90>
 632:	89 d0                	mov    %edx,%eax
 634:	c1 e8 1f             	shr    $0x1f,%eax
 637:	84 c0                	test   %al,%al
 639:	74 75                	je     6b0 <printint+0x90>
    neg = 1;
    x = -xx;
 63b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 63d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 644:	f7 d8                	neg    %eax
 646:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 649:	31 ff                	xor    %edi,%edi
 64b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 64e:	89 ce                	mov    %ecx,%esi
 650:	eb 08                	jmp    65a <printint+0x3a>
 652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 658:	89 cf                	mov    %ecx,%edi
 65a:	31 d2                	xor    %edx,%edx
 65c:	8d 4f 01             	lea    0x1(%edi),%ecx
 65f:	f7 f6                	div    %esi
 661:	0f b6 92 10 0b 00 00 	movzbl 0xb10(%edx),%edx
  }while((x /= base) != 0);
 668:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 66a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 66d:	75 e9                	jne    658 <printint+0x38>
  if(neg)
 66f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 672:	8b 75 c0             	mov    -0x40(%ebp),%esi
 675:	85 c0                	test   %eax,%eax
 677:	74 08                	je     681 <printint+0x61>
    buf[i++] = '-';
 679:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 67e:	8d 4f 02             	lea    0x2(%edi),%ecx
 681:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 685:	8d 76 00             	lea    0x0(%esi),%esi
 688:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 68b:	83 ec 04             	sub    $0x4,%esp
 68e:	83 ef 01             	sub    $0x1,%edi
 691:	6a 01                	push   $0x1
 693:	53                   	push   %ebx
 694:	56                   	push   %esi
 695:	88 45 d7             	mov    %al,-0x29(%ebp)
 698:	e8 f5 fe ff ff       	call   592 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 69d:	83 c4 10             	add    $0x10,%esp
 6a0:	39 df                	cmp    %ebx,%edi
 6a2:	75 e4                	jne    688 <printint+0x68>
    putc(fd, buf[i]);
}
 6a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a7:	5b                   	pop    %ebx
 6a8:	5e                   	pop    %esi
 6a9:	5f                   	pop    %edi
 6aa:	5d                   	pop    %ebp
 6ab:	c3                   	ret    
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6b0:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6b2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6b9:	eb 8b                	jmp    646 <printint+0x26>
 6bb:	90                   	nop
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006c0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6c9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6cc:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6cf:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6d5:	0f b6 1e             	movzbl (%esi),%ebx
 6d8:	83 c6 01             	add    $0x1,%esi
 6db:	84 db                	test   %bl,%bl
 6dd:	0f 84 b0 00 00 00    	je     793 <printf+0xd3>
 6e3:	31 d2                	xor    %edx,%edx
 6e5:	eb 39                	jmp    720 <printf+0x60>
 6e7:	89 f6                	mov    %esi,%esi
 6e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6f0:	83 f8 25             	cmp    $0x25,%eax
 6f3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 6f6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6fb:	74 18                	je     715 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6fd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 700:	83 ec 04             	sub    $0x4,%esp
 703:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 706:	6a 01                	push   $0x1
 708:	50                   	push   %eax
 709:	57                   	push   %edi
 70a:	e8 83 fe ff ff       	call   592 <write>
 70f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 712:	83 c4 10             	add    $0x10,%esp
 715:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 718:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 71c:	84 db                	test   %bl,%bl
 71e:	74 73                	je     793 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 720:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 722:	0f be cb             	movsbl %bl,%ecx
 725:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 728:	74 c6                	je     6f0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 72a:	83 fa 25             	cmp    $0x25,%edx
 72d:	75 e6                	jne    715 <printf+0x55>
      if(c == 'd'){
 72f:	83 f8 64             	cmp    $0x64,%eax
 732:	0f 84 f8 00 00 00    	je     830 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 738:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 73e:	83 f9 70             	cmp    $0x70,%ecx
 741:	74 5d                	je     7a0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 743:	83 f8 73             	cmp    $0x73,%eax
 746:	0f 84 84 00 00 00    	je     7d0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 74c:	83 f8 63             	cmp    $0x63,%eax
 74f:	0f 84 ea 00 00 00    	je     83f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 755:	83 f8 25             	cmp    $0x25,%eax
 758:	0f 84 c2 00 00 00    	je     820 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 75e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 761:	83 ec 04             	sub    $0x4,%esp
 764:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 768:	6a 01                	push   $0x1
 76a:	50                   	push   %eax
 76b:	57                   	push   %edi
 76c:	e8 21 fe ff ff       	call   592 <write>
 771:	83 c4 0c             	add    $0xc,%esp
 774:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 777:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 77a:	6a 01                	push   $0x1
 77c:	50                   	push   %eax
 77d:	57                   	push   %edi
 77e:	83 c6 01             	add    $0x1,%esi
 781:	e8 0c fe ff ff       	call   592 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 786:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 78a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 78d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 78f:	84 db                	test   %bl,%bl
 791:	75 8d                	jne    720 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 793:	8d 65 f4             	lea    -0xc(%ebp),%esp
 796:	5b                   	pop    %ebx
 797:	5e                   	pop    %esi
 798:	5f                   	pop    %edi
 799:	5d                   	pop    %ebp
 79a:	c3                   	ret    
 79b:	90                   	nop
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 7a0:	83 ec 0c             	sub    $0xc,%esp
 7a3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7a8:	6a 00                	push   $0x0
 7aa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7ad:	89 f8                	mov    %edi,%eax
 7af:	8b 13                	mov    (%ebx),%edx
 7b1:	e8 6a fe ff ff       	call   620 <printint>
        ap++;
 7b6:	89 d8                	mov    %ebx,%eax
 7b8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7bb:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 7bd:	83 c0 04             	add    $0x4,%eax
 7c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7c3:	e9 4d ff ff ff       	jmp    715 <printf+0x55>
 7c8:	90                   	nop
 7c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 7d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7d3:	8b 18                	mov    (%eax),%ebx
        ap++;
 7d5:	83 c0 04             	add    $0x4,%eax
 7d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 7db:	b8 06 0b 00 00       	mov    $0xb06,%eax
 7e0:	85 db                	test   %ebx,%ebx
 7e2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 7e5:	0f b6 03             	movzbl (%ebx),%eax
 7e8:	84 c0                	test   %al,%al
 7ea:	74 23                	je     80f <printf+0x14f>
 7ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7f0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7f3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 7f6:	83 ec 04             	sub    $0x4,%esp
 7f9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 7fb:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7fe:	50                   	push   %eax
 7ff:	57                   	push   %edi
 800:	e8 8d fd ff ff       	call   592 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 805:	0f b6 03             	movzbl (%ebx),%eax
 808:	83 c4 10             	add    $0x10,%esp
 80b:	84 c0                	test   %al,%al
 80d:	75 e1                	jne    7f0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 80f:	31 d2                	xor    %edx,%edx
 811:	e9 ff fe ff ff       	jmp    715 <printf+0x55>
 816:	8d 76 00             	lea    0x0(%esi),%esi
 819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 820:	83 ec 04             	sub    $0x4,%esp
 823:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 826:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 829:	6a 01                	push   $0x1
 82b:	e9 4c ff ff ff       	jmp    77c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 830:	83 ec 0c             	sub    $0xc,%esp
 833:	b9 0a 00 00 00       	mov    $0xa,%ecx
 838:	6a 01                	push   $0x1
 83a:	e9 6b ff ff ff       	jmp    7aa <printf+0xea>
 83f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 842:	83 ec 04             	sub    $0x4,%esp
 845:	8b 03                	mov    (%ebx),%eax
 847:	6a 01                	push   $0x1
 849:	88 45 e4             	mov    %al,-0x1c(%ebp)
 84c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 84f:	50                   	push   %eax
 850:	57                   	push   %edi
 851:	e8 3c fd ff ff       	call   592 <write>
 856:	e9 5b ff ff ff       	jmp    7b6 <printf+0xf6>
 85b:	66 90                	xchg   %ax,%ax
 85d:	66 90                	xchg   %ax,%ax
 85f:	90                   	nop

00000860 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 860:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 861:	a1 40 0f 00 00       	mov    0xf40,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 866:	89 e5                	mov    %esp,%ebp
 868:	57                   	push   %edi
 869:	56                   	push   %esi
 86a:	53                   	push   %ebx
 86b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 870:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 873:	39 c8                	cmp    %ecx,%eax
 875:	73 19                	jae    890 <free+0x30>
 877:	89 f6                	mov    %esi,%esi
 879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 880:	39 d1                	cmp    %edx,%ecx
 882:	72 1c                	jb     8a0 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 884:	39 d0                	cmp    %edx,%eax
 886:	73 18                	jae    8a0 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 888:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88e:	72 f0                	jb     880 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	39 d0                	cmp    %edx,%eax
 892:	72 f4                	jb     888 <free+0x28>
 894:	39 d1                	cmp    %edx,%ecx
 896:	73 f0                	jae    888 <free+0x28>
 898:	90                   	nop
 899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 8a0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8a3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8a6:	39 d7                	cmp    %edx,%edi
 8a8:	74 19                	je     8c3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8ad:	8b 50 04             	mov    0x4(%eax),%edx
 8b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8b3:	39 f1                	cmp    %esi,%ecx
 8b5:	74 23                	je     8da <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8b7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8b9:	a3 40 0f 00 00       	mov    %eax,0xf40
}
 8be:	5b                   	pop    %ebx
 8bf:	5e                   	pop    %esi
 8c0:	5f                   	pop    %edi
 8c1:	5d                   	pop    %ebp
 8c2:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c3:	03 72 04             	add    0x4(%edx),%esi
 8c6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c9:	8b 10                	mov    (%eax),%edx
 8cb:	8b 12                	mov    (%edx),%edx
 8cd:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8d0:	8b 50 04             	mov    0x4(%eax),%edx
 8d3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8d6:	39 f1                	cmp    %esi,%ecx
 8d8:	75 dd                	jne    8b7 <free+0x57>
    p->s.size += bp->s.size;
 8da:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 8dd:	a3 40 0f 00 00       	mov    %eax,0xf40
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8e2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8e5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8e8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 8ea:	5b                   	pop    %ebx
 8eb:	5e                   	pop    %esi
 8ec:	5f                   	pop    %edi
 8ed:	5d                   	pop    %ebp
 8ee:	c3                   	ret    
 8ef:	90                   	nop

000008f0 <morecore>:

static Header*
morecore(uint nu)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	53                   	push   %ebx
 8f4:	83 ec 04             	sub    $0x4,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8f7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 8fc:	76 3a                	jbe    938 <morecore+0x48>
 8fe:	89 c3                	mov    %eax,%ebx
 900:	8d 04 c5 00 00 00 00 	lea    0x0(,%eax,8),%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 907:	83 ec 0c             	sub    $0xc,%esp
 90a:	50                   	push   %eax
 90b:	e8 ea fc ff ff       	call   5fa <sbrk>
  if(p == (char*)-1)
 910:	83 c4 10             	add    $0x10,%esp
 913:	83 f8 ff             	cmp    $0xffffffff,%eax
 916:	74 30                	je     948 <morecore+0x58>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 918:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 91b:	83 ec 0c             	sub    $0xc,%esp
 91e:	83 c0 08             	add    $0x8,%eax
 921:	50                   	push   %eax
 922:	e8 39 ff ff ff       	call   860 <free>
  return freep;
 927:	a1 40 0f 00 00       	mov    0xf40,%eax
 92c:	83 c4 10             	add    $0x10,%esp
}
 92f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 932:	c9                   	leave  
 933:	c3                   	ret    
 934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 938:	b8 00 80 00 00       	mov    $0x8000,%eax
{
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
 93d:	bb 00 10 00 00       	mov    $0x1000,%ebx
 942:	eb c3                	jmp    907 <morecore+0x17>
 944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1)
    return 0;
 948:	31 c0                	xor    %eax,%eax
 94a:	eb e3                	jmp    92f <morecore+0x3f>
 94c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000950 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	53                   	push   %ebx
 954:	83 ec 04             	sub    $0x4,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 957:	8b 45 08             	mov    0x8(%ebp),%eax
 95a:	8d 58 07             	lea    0x7(%eax),%ebx
    if((prevp = freep) == 0){
 95d:	a1 40 0f 00 00       	mov    0xf40,%eax
malloc(uint nbytes)
{
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 962:	c1 eb 03             	shr    $0x3,%ebx
 965:	83 c3 01             	add    $0x1,%ebx
    if((prevp = freep) == 0){
 968:	85 c0                	test   %eax,%eax
 96a:	74 52                	je     9be <malloc+0x6e>
 96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 970:	8b 10                	mov    (%eax),%edx
        if(p->s.size >= nunits){
 972:	8b 4a 04             	mov    0x4(%edx),%ecx
 975:	39 cb                	cmp    %ecx,%ebx
 977:	76 1f                	jbe    998 <malloc+0x48>
                p->s.size = nunits;
            }
            freep = prevp;
            return (void*)(p + 1);
        }
        if(p == freep)
 979:	39 15 40 0f 00 00    	cmp    %edx,0xf40
 97f:	89 d0                	mov    %edx,%eax
 981:	75 ed                	jne    970 <malloc+0x20>
            if((p = morecore(nunits)) == 0)
 983:	89 d8                	mov    %ebx,%eax
 985:	e8 66 ff ff ff       	call   8f0 <morecore>
 98a:	85 c0                	test   %eax,%eax
 98c:	75 e2                	jne    970 <malloc+0x20>
                return 0;
 98e:	31 c0                	xor    %eax,%eax
 990:	eb 1d                	jmp    9af <malloc+0x5f>
 992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size >= nunits){
            if(p->s.size == nunits)
 998:	39 cb                	cmp    %ecx,%ebx
 99a:	74 1c                	je     9b8 <malloc+0x68>
                prevp->s.ptr = p->s.ptr;
            else {
                p->s.size -= nunits;
 99c:	29 d9                	sub    %ebx,%ecx
 99e:	89 4a 04             	mov    %ecx,0x4(%edx)
                p += p->s.size;
 9a1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
                p->s.size = nunits;
 9a4:	89 5a 04             	mov    %ebx,0x4(%edx)
            }
            freep = prevp;
 9a7:	a3 40 0f 00 00       	mov    %eax,0xf40
            return (void*)(p + 1);
 9ac:	8d 42 08             	lea    0x8(%edx),%eax
        }
        if(p == freep)
            if((p = morecore(nunits)) == 0)
                return 0;
    }
}
 9af:	83 c4 04             	add    $0x4,%esp
 9b2:	5b                   	pop    %ebx
 9b3:	5d                   	pop    %ebp
 9b4:	c3                   	ret    
 9b5:	8d 76 00             	lea    0x0(%esi),%esi
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size >= nunits){
            if(p->s.size == nunits)
                prevp->s.ptr = p->s.ptr;
 9b8:	8b 0a                	mov    (%edx),%ecx
 9ba:	89 08                	mov    %ecx,(%eax)
 9bc:	eb e9                	jmp    9a7 <malloc+0x57>
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
        base.s.ptr = freep = prevp = &base;
 9be:	c7 05 40 0f 00 00 44 	movl   $0xf44,0xf40
 9c5:	0f 00 00 
 9c8:	c7 05 44 0f 00 00 44 	movl   $0xf44,0xf44
 9cf:	0f 00 00 
        base.s.size = 0;
 9d2:	ba 44 0f 00 00       	mov    $0xf44,%edx
 9d7:	c7 05 48 0f 00 00 00 	movl   $0x0,0xf48
 9de:	00 00 00 
 9e1:	eb 96                	jmp    979 <malloc+0x29>
 9e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 9e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009f0 <pmalloc>:

// TODO we are not sure where we should do the page protected and read only PTE_W...

void*
pmalloc()
{
 9f0:	55                   	push   %ebp
 9f1:	89 e5                	mov    %esp,%ebp
 9f3:	83 ec 08             	sub    $0x8,%esp
    Header *p, *prevp;
    uint nunits;

    nunits = ( 4096 + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
 9f6:	a1 40 0f 00 00       	mov    0xf40,%eax
 9fb:	85 c0                	test   %eax,%eax
 9fd:	74 46                	je     a45 <pmalloc+0x55>
 9ff:	90                   	nop
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a00:	8b 10                	mov    (%eax),%edx
        if(p->s.size == nunits){
 a02:	81 7a 04 01 02 00 00 	cmpl   $0x201,0x4(%edx)
 a09:	74 25                	je     a30 <pmalloc+0x40>
            freep = prevp;
            (p+1)->x = 1;
            return (void*)(p + 1);
        }

        if(p == freep)
 a0b:	39 15 40 0f 00 00    	cmp    %edx,0xf40
 a11:	89 d0                	mov    %edx,%eax
 a13:	75 eb                	jne    a00 <pmalloc+0x10>
            if((p = morecore(nunits)) == 0)
 a15:	b8 01 02 00 00       	mov    $0x201,%eax
 a1a:	e8 d1 fe ff ff       	call   8f0 <morecore>
 a1f:	85 c0                	test   %eax,%eax
 a21:	75 dd                	jne    a00 <pmalloc+0x10>
                return 0;
 a23:	31 c0                	xor    %eax,%eax
    }
}
 a25:	c9                   	leave  
 a26:	c3                   	ret    
 a27:	89 f6                	mov    %esi,%esi
 a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size == nunits){
            prevp->s.ptr = p->s.ptr;
 a30:	8b 0a                	mov    (%edx),%ecx
            freep = prevp;
 a32:	a3 40 0f 00 00       	mov    %eax,0xf40
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
        if(p->s.size == nunits){
            prevp->s.ptr = p->s.ptr;
 a37:	89 08                	mov    %ecx,(%eax)
            freep = prevp;
            (p+1)->x = 1;
 a39:	c7 42 08 01 00 00 00 	movl   $0x1,0x8(%edx)
            return (void*)(p + 1);
 a40:	8d 42 08             	lea    0x8(%edx),%eax

        if(p == freep)
            if((p = morecore(nunits)) == 0)
                return 0;
    }
}
 a43:	c9                   	leave  
 a44:	c3                   	ret    
    Header *p, *prevp;
    uint nunits;

    nunits = ( 4096 + sizeof(Header) - 1)/sizeof(Header) + 1;
    if((prevp = freep) == 0){
        base.s.ptr = freep = prevp = &base;
 a45:	c7 05 40 0f 00 00 44 	movl   $0xf44,0xf40
 a4c:	0f 00 00 
 a4f:	c7 05 44 0f 00 00 44 	movl   $0xf44,0xf44
 a56:	0f 00 00 
        base.s.size = 0;
 a59:	ba 44 0f 00 00       	mov    $0xf44,%edx
 a5e:	c7 05 48 0f 00 00 00 	movl   $0x0,0xf48
 a65:	00 00 00 
 a68:	eb a1                	jmp    a0b <pmalloc+0x1b>
 a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000a70 <protect_page>:
    }
}


int protect_page(void* ap)
{
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
 a73:	8b 45 08             	mov    0x8(%ebp),%eax
    Header *p;
    if( ap )
 a76:	85 c0                	test   %eax,%eax
 a78:	74 1e                	je     a98 <protect_page+0x28>
    {
        if( (uint)ap % 4096 != 0 )
 a7a:	a9 ff 0f 00 00       	test   $0xfff,%eax
 a7f:	75 17                	jne    a98 <protect_page+0x28>
            return -1;

        p = ap;
        if( !p->pmalloced )
 a81:	8b 10                	mov    (%eax),%edx
 a83:	85 d2                	test   %edx,%edx
 a85:	74 11                	je     a98 <protect_page+0x28>
            return -1;

        p->protected = 1;
 a87:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        return 1;
 a8d:	b8 01 00 00 00       	mov    $0x1,%eax
    }
    else
        return -1;
}
 a92:	5d                   	pop    %ebp
 a93:	c3                   	ret    
 a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

        p->protected = 1;
        return 1;
    }
    else
        return -1;
 a98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 a9d:	5d                   	pop    %ebp
 a9e:	c3                   	ret    
 a9f:	90                   	nop

00000aa0 <pfree>:



int pfree(void* ap) {
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
 aa3:	8b 45 08             	mov    0x8(%ebp),%eax
    Header *p;
    if (ap) {
 aa6:	85 c0                	test   %eax,%eax
 aa8:	74 1e                	je     ac8 <pfree+0x28>
        if ((uint) ap % 4096 != 0)
 aaa:	a9 ff 0f 00 00       	test   $0xfff,%eax
 aaf:	75 17                	jne    ac8 <pfree+0x28>
            return -1;

        p = ap;
        if (p->protected) {
 ab1:	8b 10                	mov    (%eax),%edx
 ab3:	85 d2                	test   %edx,%edx
 ab5:	74 11                	je     ac8 <pfree+0x28>
            free(ap);
 ab7:	50                   	push   %eax
 ab8:	e8 a3 fd ff ff       	call   860 <free>
            return 1;
 abd:	58                   	pop    %eax
 abe:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    return -1;
}
 ac3:	c9                   	leave  
 ac4:	c3                   	ret    
 ac5:	8d 76 00             	lea    0x0(%esi),%esi
        if (p->protected) {
            free(ap);
            return 1;
        }
    }
    return -1;
 ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 acd:	c9                   	leave  
 ace:	c3                   	ret    
