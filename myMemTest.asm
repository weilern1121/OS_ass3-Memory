
_myMemTest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
            printf(2, "ERROR- wrong test_ID %d \n\n", testNum);
            return;
    }
}

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 10             	sub    $0x10,%esp
    run_test(11); //Test to part 1 - pmalloc, protected and pfree
  11:	6a 0b                	push   $0xb
  13:	e8 58 03 00 00       	call   370 <run_test>
    run_test(12);//Test for part 1 - pmalloc, protected,pfree,malloc and free
  18:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  1f:	e8 4c 03 00 00       	call   370 <run_test>
    run_test(21);//Test for part 2 - Paging framework
  24:	c7 04 24 15 00 00 00 	movl   $0x15,(%esp)
  2b:	e8 40 03 00 00       	call   370 <run_test>
//    run_test(32);//Test for part 3.2 - trnmnt_tree alloc,dealloc,acquire, release

    exit();
  30:	e8 fd 06 00 00       	call   732 <exit>
  35:	66 90                	xchg   %ax,%ax
  37:	66 90                	xchg   %ax,%ax
  39:	66 90                	xchg   %ax,%ax
  3b:	66 90                	xchg   %ax,%ax
  3d:	66 90                	xchg   %ax,%ax
  3f:	90                   	nop

00000040 <validation_check>:
int validation_check(void *a, int PMALLOCFLAG){
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	83 ec 18             	sub    $0x18,%esp
  46:	8b 45 08             	mov    0x8(%ebp),%eax
    if (!a) {
  49:	85 c0                	test   %eax,%eax
  4b:	74 4b                	je     98 <validation_check+0x58>
    if ((int) a % 4096 != 0) {
  4d:	a9 ff 0f 00 00       	test   $0xfff,%eax
  52:	74 0c                	je     60 <validation_check+0x20>
        if(PMALLOCFLAG)
  54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  57:	85 c9                	test   %ecx,%ecx
  59:	75 5d                	jne    b8 <validation_check+0x78>
        return 0;
  5b:	31 c0                	xor    %eax,%eax
}
  5d:	c9                   	leave  
  5e:	c3                   	ret    
  5f:	90                   	nop
    if (!checkOnPM(a)) {
  60:	83 ec 0c             	sub    $0xc,%esp
  63:	50                   	push   %eax
  64:	e8 71 07 00 00       	call   7da <checkOnPM>
  69:	83 c4 10             	add    $0x10,%esp
  6c:	85 c0                	test   %eax,%eax
  6e:	75 60                	jne    d0 <validation_check+0x90>
        if(PMALLOCFLAG)
  70:	8b 55 0c             	mov    0xc(%ebp),%edx
  73:	85 d2                	test   %edx,%edx
  75:	74 e4                	je     5b <validation_check+0x1b>
            printf(1, "ERROR in test_1_1 -> pmalloc not FLAGed PTE_PM & PTE_W!\n");
  77:	83 ec 08             	sub    $0x8,%esp
  7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  7d:	68 68 0f 00 00       	push   $0xf68
  82:	6a 01                	push   $0x1
  84:	e8 27 08 00 00       	call   8b0 <printf>
  89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8c:	83 c4 10             	add    $0x10,%esp
}
  8f:	c9                   	leave  
  90:	c3                   	ret    
  91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(PMALLOCFLAG)
  98:	8b 45 0c             	mov    0xc(%ebp),%eax
  9b:	85 c0                	test   %eax,%eax
  9d:	74 bc                	je     5b <validation_check+0x1b>
            printf(1, "ERROR in test_1_1 -> pmalloc returned addres 0!\n");
  9f:	83 ec 08             	sub    $0x8,%esp
  a2:	68 f8 0e 00 00       	push   $0xef8
  a7:	6a 01                	push   $0x1
  a9:	e8 02 08 00 00       	call   8b0 <printf>
  ae:	83 c4 10             	add    $0x10,%esp
        return 0;
  b1:	31 c0                	xor    %eax,%eax
}
  b3:	c9                   	leave  
  b4:	c3                   	ret    
  b5:	8d 76 00             	lea    0x0(%esi),%esi
            printf(1, "ERROR in test_1_1 -> pmalloc returned not aligned addres!\n");
  b8:	83 ec 08             	sub    $0x8,%esp
  bb:	68 2c 0f 00 00       	push   $0xf2c
  c0:	6a 01                	push   $0x1
  c2:	e8 e9 07 00 00       	call   8b0 <printf>
  c7:	83 c4 10             	add    $0x10,%esp
        return 0;
  ca:	31 c0                	xor    %eax,%eax
  cc:	eb 8f                	jmp    5d <validation_check+0x1d>
  ce:	66 90                	xchg   %ax,%ax
    return 1;
  d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  d5:	c9                   	leave  
  d6:	c3                   	ret    
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <protect_page_test>:
int protect_page_test(void* a){
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
}
  e3:	5d                   	pop    %ebp
    return protect_page(a);
  e4:	e9 c7 0b 00 00       	jmp    cb0 <protect_page>
  e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000f0 <test_1_1>:
int test_1_1(void) {
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	56                   	push   %esi
  f4:	53                   	push   %ebx
    int i = 0;
  f5:	31 db                	xor    %ebx,%ebx
int test_1_1(void) {
  f7:	83 ec 20             	sub    $0x20,%esp
    void *arr[] = {a, b, c, d, e}; //array of pointers to pmallocs
  fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 101:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
 108:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 10f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 116:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        arr[i]=pmalloc();
 11d:	e8 ee 0a 00 00       	call   c10 <pmalloc>
        if(!validation_check(arr[i],1))
 122:	83 ec 08             	sub    $0x8,%esp
        arr[i]=pmalloc();
 125:	89 44 9d e4          	mov    %eax,-0x1c(%ebp,%ebx,4)
        if(!validation_check(arr[i],1))
 129:	6a 01                	push   $0x1
 12b:	50                   	push   %eax
 12c:	e8 0f ff ff ff       	call   40 <validation_check>
 131:	83 c4 10             	add    $0x10,%esp
 134:	85 c0                	test   %eax,%eax
 136:	74 68                	je     1a0 <test_1_1+0xb0>
    for (; i < 5; i++) { //pmalloc each pointer
 138:	83 c3 01             	add    $0x1,%ebx
 13b:	83 fb 05             	cmp    $0x5,%ebx
 13e:	75 dd                	jne    11d <test_1_1+0x2d>
    for (i=0; i < 5; i++) { //protect each pointer
 140:	31 db                	xor    %ebx,%ebx
    return protect_page(a);
 142:	83 ec 0c             	sub    $0xc,%esp
 145:	ff 74 9d e4          	pushl  -0x1c(%ebp,%ebx,4)
 149:	e8 62 0b 00 00       	call   cb0 <protect_page>
        if (protect_page_test(arr[i]) != 1) //if got failed in one of the checks - test failed
 14e:	83 c4 10             	add    $0x10,%esp
 151:	83 f8 01             	cmp    $0x1,%eax
 154:	75 4a                	jne    1a0 <test_1_1+0xb0>
    for (i=0; i < 5; i++) { //protect each pointer
 156:	83 c3 01             	add    $0x1,%ebx
 159:	83 fb 05             	cmp    $0x5,%ebx
 15c:	75 e4                	jne    142 <test_1_1+0x52>
    for (i=0; i < 5; i++) { //pfree each pointer
 15e:	31 db                	xor    %ebx,%ebx
        if(!validation_check(arr[i],1))
 160:	8b 74 9d e4          	mov    -0x1c(%ebp,%ebx,4),%esi
 164:	83 ec 08             	sub    $0x8,%esp
 167:	6a 01                	push   $0x1
 169:	56                   	push   %esi
 16a:	e8 d1 fe ff ff       	call   40 <validation_check>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	85 c0                	test   %eax,%eax
 174:	74 2a                	je     1a0 <test_1_1+0xb0>
        if(pfree(arr[i]) != 1)
 176:	83 ec 0c             	sub    $0xc,%esp
 179:	56                   	push   %esi
 17a:	e8 71 0c 00 00       	call   df0 <pfree>
 17f:	83 c4 10             	add    $0x10,%esp
 182:	83 f8 01             	cmp    $0x1,%eax
 185:	75 19                	jne    1a0 <test_1_1+0xb0>
    for (i=0; i < 5; i++) { //pfree each pointer
 187:	83 c3 01             	add    $0x1,%ebx
 18a:	83 fb 05             	cmp    $0x5,%ebx
 18d:	75 d1                	jne    160 <test_1_1+0x70>
}
 18f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 192:	5b                   	pop    %ebx
 193:	5e                   	pop    %esi
 194:	5d                   	pop    %ebp
 195:	c3                   	ret    
 196:	8d 76 00             	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 1a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 0;
 1a3:	31 c0                	xor    %eax,%eax
}
 1a5:	5b                   	pop    %ebx
 1a6:	5e                   	pop    %esi
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001b0 <test_1_2>:
int test_1_2(void) {
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	56                   	push   %esi
 1b5:	8d 45 d0             	lea    -0x30(%ebp),%eax
 1b8:	53                   	push   %ebx
 1b9:	8d 5d dc             	lea    -0x24(%ebp),%ebx
 1bc:	83 ec 3c             	sub    $0x3c,%esp
    void *arr[] = {a, b, c, d, e, f}; //array of pointers to pmallocs
 1bf:	89 c6                	mov    %eax,%esi
 1c1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
 1c8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 1cf:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 1d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 1dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 1e4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1eb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        arr[i]=pmalloc();
 1ee:	e8 1d 0a 00 00       	call   c10 <pmalloc>
        if(!validation_check(arr[i],1))
 1f3:	83 ec 08             	sub    $0x8,%esp
        arr[i]=pmalloc();
 1f6:	89 06                	mov    %eax,(%esi)
        if(!validation_check(arr[i],1))
 1f8:	6a 01                	push   $0x1
 1fa:	50                   	push   %eax
 1fb:	e8 40 fe ff ff       	call   40 <validation_check>
 200:	83 c4 10             	add    $0x10,%esp
 203:	85 c0                	test   %eax,%eax
 205:	0f 84 e5 00 00 00    	je     2f0 <test_1_2+0x140>
 20b:	83 c6 04             	add    $0x4,%esi
    for (; i < 3; i++) { //pmalloc each pointer
 20e:	39 de                	cmp    %ebx,%esi
 210:	75 dc                	jne    1ee <test_1_2+0x3e>
 212:	8d 7d d0             	lea    -0x30(%ebp),%edi
        arr[i]=malloc(4096);
 215:	83 ec 0c             	sub    $0xc,%esp
 218:	68 00 10 00 00       	push   $0x1000
 21d:	e8 ee 08 00 00       	call   b10 <malloc>
 222:	89 47 0c             	mov    %eax,0xc(%edi)
        if(validation_check(arr[i],0))
 225:	5a                   	pop    %edx
 226:	59                   	pop    %ecx
 227:	6a 00                	push   $0x0
 229:	50                   	push   %eax
 22a:	e8 11 fe ff ff       	call   40 <validation_check>
 22f:	83 c4 10             	add    $0x10,%esp
 232:	85 c0                	test   %eax,%eax
 234:	89 c3                	mov    %eax,%ebx
 236:	0f 85 b4 00 00 00    	jne    2f0 <test_1_2+0x140>
 23c:	83 c7 04             	add    $0x4,%edi
    for (; i < 6; i++) { //pmalloc each pointer
 23f:	39 f7                	cmp    %esi,%edi
 241:	75 d2                	jne    215 <test_1_2+0x65>
 243:	8d 55 d0             	lea    -0x30(%ebp),%edx
    return protect_page(a);
 246:	83 ec 0c             	sub    $0xc,%esp
 249:	ff 32                	pushl  (%edx)
 24b:	89 55 c0             	mov    %edx,-0x40(%ebp)
 24e:	e8 5d 0a 00 00       	call   cb0 <protect_page>
        if (protect_page_test(arr[i]) != 1) //if got failed in one of the checks - test failed
 253:	83 c4 10             	add    $0x10,%esp
 256:	83 f8 01             	cmp    $0x1,%eax
    return protect_page(a);
 259:	89 c6                	mov    %eax,%esi
        if (protect_page_test(arr[i]) != 1) //if got failed in one of the checks - test failed
 25b:	0f 85 8f 00 00 00    	jne    2f0 <test_1_2+0x140>
 261:	8b 55 c0             	mov    -0x40(%ebp),%edx
 264:	83 c2 04             	add    $0x4,%edx
    for (i=0; i < 3; i++) { //protect each pointer
 267:	39 fa                	cmp    %edi,%edx
 269:	75 db                	jne    246 <test_1_2+0x96>
    return protect_page(a);
 26b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 26e:	83 ec 0c             	sub    $0xc,%esp
 271:	ff 70 0c             	pushl  0xc(%eax)
 274:	e8 37 0a 00 00       	call   cb0 <protect_page>
        if (protect_page_test(arr[i]) == 1)
 279:	83 c4 10             	add    $0x10,%esp
 27c:	83 f8 01             	cmp    $0x1,%eax
 27f:	74 6f                	je     2f0 <test_1_2+0x140>
 281:	83 45 c4 04          	addl   $0x4,-0x3c(%ebp)
 285:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    for (; i < 6; i++) { //protect each pointer
 288:	39 c7                	cmp    %eax,%edi
 28a:	75 df                	jne    26b <test_1_2+0xbb>
        if(i<3) { //if PMALLOC
 28c:	83 fb 02             	cmp    $0x2,%ebx
 28f:	8b 7c 9d d0          	mov    -0x30(%ebp,%ebx,4),%edi
 293:	7f 3b                	jg     2d0 <test_1_2+0x120>
            if (!validation_check(arr[i],1))
 295:	83 ec 08             	sub    $0x8,%esp
 298:	6a 01                	push   $0x1
 29a:	57                   	push   %edi
 29b:	e8 a0 fd ff ff       	call   40 <validation_check>
 2a0:	83 c4 10             	add    $0x10,%esp
 2a3:	85 c0                	test   %eax,%eax
 2a5:	74 49                	je     2f0 <test_1_2+0x140>
            if (pfree(arr[i]) != 1)
 2a7:	83 ec 0c             	sub    $0xc,%esp
 2aa:	57                   	push   %edi
 2ab:	e8 40 0b 00 00       	call   df0 <pfree>
 2b0:	83 c4 10             	add    $0x10,%esp
 2b3:	83 f8 01             	cmp    $0x1,%eax
 2b6:	75 38                	jne    2f0 <test_1_2+0x140>
    for (i=0; i < 6; i++) { //pfree each pointer
 2b8:	83 c3 01             	add    $0x1,%ebx
 2bb:	83 fb 06             	cmp    $0x6,%ebx
 2be:	75 cc                	jne    28c <test_1_2+0xdc>
}
 2c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2c3:	89 f0                	mov    %esi,%eax
 2c5:	5b                   	pop    %ebx
 2c6:	5e                   	pop    %esi
 2c7:	5f                   	pop    %edi
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret    
 2ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (pfree(arr[i]) == 1)
 2d0:	83 ec 0c             	sub    $0xc,%esp
 2d3:	57                   	push   %edi
 2d4:	e8 17 0b 00 00       	call   df0 <pfree>
 2d9:	83 c4 10             	add    $0x10,%esp
 2dc:	83 f8 01             	cmp    $0x1,%eax
 2df:	74 0f                	je     2f0 <test_1_2+0x140>
            free(arr[i]);
 2e1:	83 ec 0c             	sub    $0xc,%esp
 2e4:	57                   	push   %edi
 2e5:	e8 96 07 00 00       	call   a80 <free>
 2ea:	83 c4 10             	add    $0x10,%esp
 2ed:	eb c9                	jmp    2b8 <test_1_2+0x108>
 2ef:	90                   	nop
}
 2f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
 2f3:	31 f6                	xor    %esi,%esi
}
 2f5:	89 f0                	mov    %esi,%eax
 2f7:	5b                   	pop    %ebx
 2f8:	5e                   	pop    %esi
 2f9:	5f                   	pop    %edi
 2fa:	5d                   	pop    %ebp
 2fb:	c3                   	ret    
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000300 <test_21>:
int test_21(void) {
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	56                   	push   %esi
 304:	53                   	push   %ebx
    void *a=malloc(10*PGSIZE);
 305:	83 ec 0c             	sub    $0xc,%esp
 308:	68 00 a0 00 00       	push   $0xa000
 30d:	e8 fe 07 00 00       	call   b10 <malloc>
 312:	89 c3                	mov    %eax,%ebx
    void *b=pmalloc();
 314:	e8 f7 08 00 00       	call   c10 <pmalloc>
    memset(a,5,10*PGSIZE);
 319:	83 c4 0c             	add    $0xc,%esp
    void *b=pmalloc();
 31c:	89 c6                	mov    %eax,%esi
    memset(a,5,10*PGSIZE);
 31e:	68 00 a0 00 00       	push   $0xa000
 323:	6a 05                	push   $0x5
 325:	53                   	push   %ebx
 326:	e8 65 02 00 00       	call   590 <memset>
    free(a);
 32b:	89 1c 24             	mov    %ebx,(%esp)
 32e:	e8 4d 07 00 00       	call   a80 <free>
    pfree(b);
 333:	89 34 24             	mov    %esi,(%esp)
 336:	e8 b5 0a 00 00       	call   df0 <pfree>
}
 33b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 33e:	b8 01 00 00 00       	mov    $0x1,%eax
 343:	5b                   	pop    %ebx
 344:	5e                   	pop    %esi
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    
 347:	89 f6                	mov    %esi,%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000350 <test_31>:
int test_31(void) {
 350:	55                   	push   %ebp
}
 351:	b8 01 00 00 00       	mov    $0x1,%eax
int test_31(void) {
 356:	89 e5                	mov    %esp,%ebp
}
 358:	5d                   	pop    %ebp
 359:	c3                   	ret    
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000360 <test_32>:
 360:	55                   	push   %ebp
 361:	b8 01 00 00 00       	mov    $0x1,%eax
 366:	89 e5                	mov    %esp,%ebp
 368:	5d                   	pop    %ebp
 369:	c3                   	ret    
 36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000370 <run_test>:
void run_test(int testNum) {
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	83 ec 08             	sub    $0x8,%esp
 376:	8b 45 08             	mov    0x8(%ebp),%eax
    switch (testNum) {
 379:	83 f8 0c             	cmp    $0xc,%eax
 37c:	0f 84 d6 00 00 00    	je     458 <run_test+0xe8>
 382:	7e 7c                	jle    400 <run_test+0x90>
 384:	83 f8 15             	cmp    $0x15,%eax
 387:	74 3f                	je     3c8 <run_test+0x58>
 389:	83 f8 20             	cmp    $0x20,%eax
 38c:	0f 85 ae 00 00 00    	jne    440 <run_test+0xd0>
            printf(1, "-- Start test 3.2 --\n");
 392:	83 ec 08             	sub    $0x8,%esp
 395:	68 7c 10 00 00       	push   $0x107c
 39a:	6a 01                	push   $0x1
 39c:	e8 0f 05 00 00       	call   8b0 <printf>
            printf(1, "\n-- Test 3.2 Passed! --\n");
 3a1:	58                   	pop    %eax
 3a2:	5a                   	pop    %edx
 3a3:	68 92 10 00 00       	push   $0x1092
 3a8:	6a 01                	push   $0x1
 3aa:	e8 01 05 00 00       	call   8b0 <printf>
            printf(1, "\n");
 3af:	59                   	pop    %ecx
 3b0:	58                   	pop    %eax
 3b1:	68 c4 10 00 00       	push   $0x10c4
 3b6:	6a 01                	push   $0x1
 3b8:	e8 f3 04 00 00       	call   8b0 <printf>
            break;
 3bd:	83 c4 10             	add    $0x10,%esp
}
 3c0:	c9                   	leave  
 3c1:	c3                   	ret    
 3c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            printf(1, "-- Start test 2.1 --\n");
 3c8:	83 ec 08             	sub    $0x8,%esp
 3cb:	68 34 10 00 00       	push   $0x1034
 3d0:	6a 01                	push   $0x1
 3d2:	e8 d9 04 00 00       	call   8b0 <printf>
            if(test_21())
 3d7:	e8 24 ff ff ff       	call   300 <test_21>
 3dc:	83 c4 10             	add    $0x10,%esp
 3df:	85 c0                	test   %eax,%eax
 3e1:	0f 84 e1 00 00 00    	je     4c8 <run_test+0x158>
                printf(1, "-- Test 2.1 Passed! --\n");
 3e7:	83 ec 08             	sub    $0x8,%esp
 3ea:	68 4a 10 00 00       	push   $0x104a
 3ef:	6a 01                	push   $0x1
 3f1:	e8 ba 04 00 00       	call   8b0 <printf>
 3f6:	83 c4 10             	add    $0x10,%esp
}
 3f9:	c9                   	leave  
 3fa:	c3                   	ret    
 3fb:	90                   	nop
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch (testNum) {
 400:	83 f8 0b             	cmp    $0xb,%eax
 403:	75 3b                	jne    440 <run_test+0xd0>
            printf(1, "-- Start test 1.1 --\n");
 405:	83 ec 08             	sub    $0x8,%esp
 408:	68 a4 0f 00 00       	push   $0xfa4
 40d:	6a 01                	push   $0x1
 40f:	e8 9c 04 00 00       	call   8b0 <printf>
            if (test_1_1())
 414:	e8 d7 fc ff ff       	call   f0 <test_1_1>
 419:	83 c4 10             	add    $0x10,%esp
 41c:	85 c0                	test   %eax,%eax
 41e:	0f 84 8c 00 00 00    	je     4b0 <run_test+0x140>
                printf(1, "-- Test 1.1 Passed! --\n");
 424:	83 ec 08             	sub    $0x8,%esp
 427:	68 ba 0f 00 00       	push   $0xfba
 42c:	6a 01                	push   $0x1
 42e:	e8 7d 04 00 00       	call   8b0 <printf>
 433:	83 c4 10             	add    $0x10,%esp
}
 436:	c9                   	leave  
 437:	c3                   	ret    
 438:	90                   	nop
 439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(2, "ERROR- wrong test_ID %d \n\n", testNum);
 440:	83 ec 04             	sub    $0x4,%esp
 443:	50                   	push   %eax
 444:	68 ab 10 00 00       	push   $0x10ab
 449:	6a 02                	push   $0x2
 44b:	e8 60 04 00 00       	call   8b0 <printf>
            return;
 450:	83 c4 10             	add    $0x10,%esp
}
 453:	c9                   	leave  
 454:	c3                   	ret    
 455:	8d 76 00             	lea    0x0(%esi),%esi
            printf(1, "-- Start test 1.2 --\n");
 458:	83 ec 08             	sub    $0x8,%esp
 45b:	68 ec 0f 00 00       	push   $0xfec
 460:	6a 01                	push   $0x1
 462:	e8 49 04 00 00       	call   8b0 <printf>
            sleep(250);
 467:	c7 04 24 fa 00 00 00 	movl   $0xfa,(%esp)
 46e:	e8 4f 03 00 00       	call   7c2 <sleep>
            if(test_1_2())
 473:	e8 38 fd ff ff       	call   1b0 <test_1_2>
 478:	83 c4 10             	add    $0x10,%esp
 47b:	85 c0                	test   %eax,%eax
 47d:	74 19                	je     498 <run_test+0x128>
                printf(1, "-- Test 1.2 Passed! --\n");
 47f:	83 ec 08             	sub    $0x8,%esp
 482:	68 02 10 00 00       	push   $0x1002
 487:	6a 01                	push   $0x1
 489:	e8 22 04 00 00       	call   8b0 <printf>
 48e:	83 c4 10             	add    $0x10,%esp
}
 491:	c9                   	leave  
 492:	c3                   	ret    
 493:	90                   	nop
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                printf(1, "-- Failed in test 1.2 --\n");
 498:	83 ec 08             	sub    $0x8,%esp
 49b:	68 1a 10 00 00       	push   $0x101a
 4a0:	6a 01                	push   $0x1
 4a2:	e8 09 04 00 00       	call   8b0 <printf>
 4a7:	83 c4 10             	add    $0x10,%esp
}
 4aa:	c9                   	leave  
 4ab:	c3                   	ret    
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                printf(1, "-- Failed in test 1.1 --\n");
 4b0:	83 ec 08             	sub    $0x8,%esp
 4b3:	68 d2 0f 00 00       	push   $0xfd2
 4b8:	6a 01                	push   $0x1
 4ba:	e8 f1 03 00 00       	call   8b0 <printf>
 4bf:	83 c4 10             	add    $0x10,%esp
}
 4c2:	c9                   	leave  
 4c3:	c3                   	ret    
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                printf(1, "-- Failed in test 2.1 --\n");
 4c8:	83 ec 08             	sub    $0x8,%esp
 4cb:	68 62 10 00 00       	push   $0x1062
 4d0:	6a 01                	push   $0x1
 4d2:	e8 d9 03 00 00       	call   8b0 <printf>
 4d7:	83 c4 10             	add    $0x10,%esp
}
 4da:	c9                   	leave  
 4db:	c3                   	ret    
 4dc:	66 90                	xchg   %ax,%ax
 4de:	66 90                	xchg   %ax,%ax

000004e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	53                   	push   %ebx
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4ea:	89 c2                	mov    %eax,%edx
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4f0:	83 c1 01             	add    $0x1,%ecx
 4f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 4f7:	83 c2 01             	add    $0x1,%edx
 4fa:	84 db                	test   %bl,%bl
 4fc:	88 5a ff             	mov    %bl,-0x1(%edx)
 4ff:	75 ef                	jne    4f0 <strcpy+0x10>
    ;
  return os;
}
 501:	5b                   	pop    %ebx
 502:	5d                   	pop    %ebp
 503:	c3                   	ret    
 504:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 50a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000510 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	53                   	push   %ebx
 514:	8b 55 08             	mov    0x8(%ebp),%edx
 517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 51a:	0f b6 02             	movzbl (%edx),%eax
 51d:	0f b6 19             	movzbl (%ecx),%ebx
 520:	84 c0                	test   %al,%al
 522:	75 1c                	jne    540 <strcmp+0x30>
 524:	eb 2a                	jmp    550 <strcmp+0x40>
 526:	8d 76 00             	lea    0x0(%esi),%esi
 529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 530:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 533:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 536:	83 c1 01             	add    $0x1,%ecx
 539:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 53c:	84 c0                	test   %al,%al
 53e:	74 10                	je     550 <strcmp+0x40>
 540:	38 d8                	cmp    %bl,%al
 542:	74 ec                	je     530 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 544:	29 d8                	sub    %ebx,%eax
}
 546:	5b                   	pop    %ebx
 547:	5d                   	pop    %ebp
 548:	c3                   	ret    
 549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 550:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 552:	29 d8                	sub    %ebx,%eax
}
 554:	5b                   	pop    %ebx
 555:	5d                   	pop    %ebp
 556:	c3                   	ret    
 557:	89 f6                	mov    %esi,%esi
 559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000560 <strlen>:

uint
strlen(char *s)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 566:	80 39 00             	cmpb   $0x0,(%ecx)
 569:	74 15                	je     580 <strlen+0x20>
 56b:	31 d2                	xor    %edx,%edx
 56d:	8d 76 00             	lea    0x0(%esi),%esi
 570:	83 c2 01             	add    $0x1,%edx
 573:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 577:	89 d0                	mov    %edx,%eax
 579:	75 f5                	jne    570 <strlen+0x10>
    ;
  return n;
}
 57b:	5d                   	pop    %ebp
 57c:	c3                   	ret    
 57d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 580:	31 c0                	xor    %eax,%eax
}
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    
 584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 58a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000590 <memset>:

void*
memset(void *dst, int c, uint n)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 597:	8b 4d 10             	mov    0x10(%ebp),%ecx
 59a:	8b 45 0c             	mov    0xc(%ebp),%eax
 59d:	89 d7                	mov    %edx,%edi
 59f:	fc                   	cld    
 5a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5a2:	89 d0                	mov    %edx,%eax
 5a4:	5f                   	pop    %edi
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret    
 5a7:	89 f6                	mov    %esi,%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005b0 <strchr>:

char*
strchr(const char *s, char c)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	53                   	push   %ebx
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 5ba:	0f b6 10             	movzbl (%eax),%edx
 5bd:	84 d2                	test   %dl,%dl
 5bf:	74 1d                	je     5de <strchr+0x2e>
    if(*s == c)
 5c1:	38 d3                	cmp    %dl,%bl
 5c3:	89 d9                	mov    %ebx,%ecx
 5c5:	75 0d                	jne    5d4 <strchr+0x24>
 5c7:	eb 17                	jmp    5e0 <strchr+0x30>
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5d0:	38 ca                	cmp    %cl,%dl
 5d2:	74 0c                	je     5e0 <strchr+0x30>
  for(; *s; s++)
 5d4:	83 c0 01             	add    $0x1,%eax
 5d7:	0f b6 10             	movzbl (%eax),%edx
 5da:	84 d2                	test   %dl,%dl
 5dc:	75 f2                	jne    5d0 <strchr+0x20>
      return (char*)s;
  return 0;
 5de:	31 c0                	xor    %eax,%eax
}
 5e0:	5b                   	pop    %ebx
 5e1:	5d                   	pop    %ebp
 5e2:	c3                   	ret    
 5e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005f0 <gets>:

char*
gets(char *buf, int max)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	56                   	push   %esi
 5f5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5f6:	31 f6                	xor    %esi,%esi
 5f8:	89 f3                	mov    %esi,%ebx
{
 5fa:	83 ec 1c             	sub    $0x1c,%esp
 5fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 600:	eb 2f                	jmp    631 <gets+0x41>
 602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 608:	8d 45 e7             	lea    -0x19(%ebp),%eax
 60b:	83 ec 04             	sub    $0x4,%esp
 60e:	6a 01                	push   $0x1
 610:	50                   	push   %eax
 611:	6a 00                	push   $0x0
 613:	e8 32 01 00 00       	call   74a <read>
    if(cc < 1)
 618:	83 c4 10             	add    $0x10,%esp
 61b:	85 c0                	test   %eax,%eax
 61d:	7e 1c                	jle    63b <gets+0x4b>
      break;
    buf[i++] = c;
 61f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 623:	83 c7 01             	add    $0x1,%edi
 626:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 629:	3c 0a                	cmp    $0xa,%al
 62b:	74 23                	je     650 <gets+0x60>
 62d:	3c 0d                	cmp    $0xd,%al
 62f:	74 1f                	je     650 <gets+0x60>
  for(i=0; i+1 < max; ){
 631:	83 c3 01             	add    $0x1,%ebx
 634:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 637:	89 fe                	mov    %edi,%esi
 639:	7c cd                	jl     608 <gets+0x18>
 63b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 640:	c6 03 00             	movb   $0x0,(%ebx)
}
 643:	8d 65 f4             	lea    -0xc(%ebp),%esp
 646:	5b                   	pop    %ebx
 647:	5e                   	pop    %esi
 648:	5f                   	pop    %edi
 649:	5d                   	pop    %ebp
 64a:	c3                   	ret    
 64b:	90                   	nop
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 650:	8b 75 08             	mov    0x8(%ebp),%esi
 653:	8b 45 08             	mov    0x8(%ebp),%eax
 656:	01 de                	add    %ebx,%esi
 658:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 65a:	c6 03 00             	movb   $0x0,(%ebx)
}
 65d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 660:	5b                   	pop    %ebx
 661:	5e                   	pop    %esi
 662:	5f                   	pop    %edi
 663:	5d                   	pop    %ebp
 664:	c3                   	ret    
 665:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000670 <stat>:

int
stat(char *n, struct stat *st)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	56                   	push   %esi
 674:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 675:	83 ec 08             	sub    $0x8,%esp
 678:	6a 00                	push   $0x0
 67a:	ff 75 08             	pushl  0x8(%ebp)
 67d:	e8 f0 00 00 00       	call   772 <open>
  if(fd < 0)
 682:	83 c4 10             	add    $0x10,%esp
 685:	85 c0                	test   %eax,%eax
 687:	78 27                	js     6b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 689:	83 ec 08             	sub    $0x8,%esp
 68c:	ff 75 0c             	pushl  0xc(%ebp)
 68f:	89 c3                	mov    %eax,%ebx
 691:	50                   	push   %eax
 692:	e8 f3 00 00 00       	call   78a <fstat>
  close(fd);
 697:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 69a:	89 c6                	mov    %eax,%esi
  close(fd);
 69c:	e8 b9 00 00 00       	call   75a <close>
  return r;
 6a1:	83 c4 10             	add    $0x10,%esp
}
 6a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6a7:	89 f0                	mov    %esi,%eax
 6a9:	5b                   	pop    %ebx
 6aa:	5e                   	pop    %esi
 6ab:	5d                   	pop    %ebp
 6ac:	c3                   	ret    
 6ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 6b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6b5:	eb ed                	jmp    6a4 <stat+0x34>
 6b7:	89 f6                	mov    %esi,%esi
 6b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006c0 <atoi>:

int
atoi(const char *s)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	53                   	push   %ebx
 6c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6c7:	0f be 11             	movsbl (%ecx),%edx
 6ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 6cd:	3c 09                	cmp    $0x9,%al
  n = 0;
 6cf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 6d4:	77 1f                	ja     6f5 <atoi+0x35>
 6d6:	8d 76 00             	lea    0x0(%esi),%esi
 6d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 6e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 6e3:	83 c1 01             	add    $0x1,%ecx
 6e6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 6ea:	0f be 11             	movsbl (%ecx),%edx
 6ed:	8d 5a d0             	lea    -0x30(%edx),%ebx
 6f0:	80 fb 09             	cmp    $0x9,%bl
 6f3:	76 eb                	jbe    6e0 <atoi+0x20>
  return n;
}
 6f5:	5b                   	pop    %ebx
 6f6:	5d                   	pop    %ebp
 6f7:	c3                   	ret    
 6f8:	90                   	nop
 6f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000700 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	56                   	push   %esi
 704:	53                   	push   %ebx
 705:	8b 5d 10             	mov    0x10(%ebp),%ebx
 708:	8b 45 08             	mov    0x8(%ebp),%eax
 70b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 70e:	85 db                	test   %ebx,%ebx
 710:	7e 14                	jle    726 <memmove+0x26>
 712:	31 d2                	xor    %edx,%edx
 714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 718:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 71c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 71f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 722:	39 d3                	cmp    %edx,%ebx
 724:	75 f2                	jne    718 <memmove+0x18>
  return vdst;
}
 726:	5b                   	pop    %ebx
 727:	5e                   	pop    %esi
 728:	5d                   	pop    %ebp
 729:	c3                   	ret    

0000072a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 72a:	b8 01 00 00 00       	mov    $0x1,%eax
 72f:	cd 40                	int    $0x40
 731:	c3                   	ret    

00000732 <exit>:
SYSCALL(exit)
 732:	b8 02 00 00 00       	mov    $0x2,%eax
 737:	cd 40                	int    $0x40
 739:	c3                   	ret    

0000073a <wait>:
SYSCALL(wait)
 73a:	b8 03 00 00 00       	mov    $0x3,%eax
 73f:	cd 40                	int    $0x40
 741:	c3                   	ret    

00000742 <pipe>:
SYSCALL(pipe)
 742:	b8 04 00 00 00       	mov    $0x4,%eax
 747:	cd 40                	int    $0x40
 749:	c3                   	ret    

0000074a <read>:
SYSCALL(read)
 74a:	b8 05 00 00 00       	mov    $0x5,%eax
 74f:	cd 40                	int    $0x40
 751:	c3                   	ret    

00000752 <write>:
SYSCALL(write)
 752:	b8 10 00 00 00       	mov    $0x10,%eax
 757:	cd 40                	int    $0x40
 759:	c3                   	ret    

0000075a <close>:
SYSCALL(close)
 75a:	b8 15 00 00 00       	mov    $0x15,%eax
 75f:	cd 40                	int    $0x40
 761:	c3                   	ret    

00000762 <kill>:
SYSCALL(kill)
 762:	b8 06 00 00 00       	mov    $0x6,%eax
 767:	cd 40                	int    $0x40
 769:	c3                   	ret    

0000076a <exec>:
SYSCALL(exec)
 76a:	b8 07 00 00 00       	mov    $0x7,%eax
 76f:	cd 40                	int    $0x40
 771:	c3                   	ret    

00000772 <open>:
SYSCALL(open)
 772:	b8 0f 00 00 00       	mov    $0xf,%eax
 777:	cd 40                	int    $0x40
 779:	c3                   	ret    

0000077a <mknod>:
SYSCALL(mknod)
 77a:	b8 11 00 00 00       	mov    $0x11,%eax
 77f:	cd 40                	int    $0x40
 781:	c3                   	ret    

00000782 <unlink>:
SYSCALL(unlink)
 782:	b8 12 00 00 00       	mov    $0x12,%eax
 787:	cd 40                	int    $0x40
 789:	c3                   	ret    

0000078a <fstat>:
SYSCALL(fstat)
 78a:	b8 08 00 00 00       	mov    $0x8,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <link>:
SYSCALL(link)
 792:	b8 13 00 00 00       	mov    $0x13,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <mkdir>:
SYSCALL(mkdir)
 79a:	b8 14 00 00 00       	mov    $0x14,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <chdir>:
SYSCALL(chdir)
 7a2:	b8 09 00 00 00       	mov    $0x9,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <dup>:
SYSCALL(dup)
 7aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <getpid>:
SYSCALL(getpid)
 7b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <sbrk>:
SYSCALL(sbrk)
 7ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <sleep>:
SYSCALL(sleep)
 7c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <uptime>:
SYSCALL(uptime)
 7ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <turnOnPM>:
SYSCALL(turnOnPM)
 7d2:	b8 17 00 00 00       	mov    $0x17,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <checkOnPM>:
SYSCALL(checkOnPM)
 7da:	b8 18 00 00 00       	mov    $0x18,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <turnOffW>:
SYSCALL(turnOffW)
 7e2:	b8 19 00 00 00       	mov    $0x19,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <turnOnW>:
SYSCALL(turnOnW)
 7ea:	b8 1a 00 00 00       	mov    $0x1a,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <turnOffPM>:
SYSCALL(turnOffPM)
 7f2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <updatePTE>:
SYSCALL(updatePTE)
 7fa:	b8 1c 00 00 00       	mov    $0x1c,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <updateProc>:
SYSCALL(updateProc)
 802:	b8 1d 00 00 00       	mov    $0x1d,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    
 80a:	66 90                	xchg   %ax,%ax
 80c:	66 90                	xchg   %ax,%ax
 80e:	66 90                	xchg   %ax,%ax

00000810 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 810:	55                   	push   %ebp
 811:	89 e5                	mov    %esp,%ebp
 813:	57                   	push   %edi
 814:	56                   	push   %esi
 815:	53                   	push   %ebx
 816:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 819:	85 d2                	test   %edx,%edx
{
 81b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 81e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 820:	79 76                	jns    898 <printint+0x88>
 822:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 826:	74 70                	je     898 <printint+0x88>
    x = -xx;
 828:	f7 d8                	neg    %eax
    neg = 1;
 82a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 831:	31 f6                	xor    %esi,%esi
 833:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 836:	eb 0a                	jmp    842 <printint+0x32>
 838:	90                   	nop
 839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 840:	89 fe                	mov    %edi,%esi
 842:	31 d2                	xor    %edx,%edx
 844:	8d 7e 01             	lea    0x1(%esi),%edi
 847:	f7 f1                	div    %ecx
 849:	0f b6 92 d0 10 00 00 	movzbl 0x10d0(%edx),%edx
  }while((x /= base) != 0);
 850:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 852:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 855:	75 e9                	jne    840 <printint+0x30>
  if(neg)
 857:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 85a:	85 c0                	test   %eax,%eax
 85c:	74 08                	je     866 <printint+0x56>
    buf[i++] = '-';
 85e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 863:	8d 7e 02             	lea    0x2(%esi),%edi
 866:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 86a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 86d:	8d 76 00             	lea    0x0(%esi),%esi
 870:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 873:	83 ec 04             	sub    $0x4,%esp
 876:	83 ee 01             	sub    $0x1,%esi
 879:	6a 01                	push   $0x1
 87b:	53                   	push   %ebx
 87c:	57                   	push   %edi
 87d:	88 45 d7             	mov    %al,-0x29(%ebp)
 880:	e8 cd fe ff ff       	call   752 <write>

  while(--i >= 0)
 885:	83 c4 10             	add    $0x10,%esp
 888:	39 de                	cmp    %ebx,%esi
 88a:	75 e4                	jne    870 <printint+0x60>
    putc(fd, buf[i]);
}
 88c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 88f:	5b                   	pop    %ebx
 890:	5e                   	pop    %esi
 891:	5f                   	pop    %edi
 892:	5d                   	pop    %ebp
 893:	c3                   	ret    
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 898:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 89f:	eb 90                	jmp    831 <printint+0x21>
 8a1:	eb 0d                	jmp    8b0 <printf>
 8a3:	90                   	nop
 8a4:	90                   	nop
 8a5:	90                   	nop
 8a6:	90                   	nop
 8a7:	90                   	nop
 8a8:	90                   	nop
 8a9:	90                   	nop
 8aa:	90                   	nop
 8ab:	90                   	nop
 8ac:	90                   	nop
 8ad:	90                   	nop
 8ae:	90                   	nop
 8af:	90                   	nop

000008b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	57                   	push   %edi
 8b4:	56                   	push   %esi
 8b5:	53                   	push   %ebx
 8b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8b9:	8b 75 0c             	mov    0xc(%ebp),%esi
 8bc:	0f b6 1e             	movzbl (%esi),%ebx
 8bf:	84 db                	test   %bl,%bl
 8c1:	0f 84 b3 00 00 00    	je     97a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 8c7:	8d 45 10             	lea    0x10(%ebp),%eax
 8ca:	83 c6 01             	add    $0x1,%esi
  state = 0;
 8cd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 8cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 8d2:	eb 2f                	jmp    903 <printf+0x53>
 8d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 8d8:	83 f8 25             	cmp    $0x25,%eax
 8db:	0f 84 a7 00 00 00    	je     988 <printf+0xd8>
  write(fd, &c, 1);
 8e1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 8e4:	83 ec 04             	sub    $0x4,%esp
 8e7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 8ea:	6a 01                	push   $0x1
 8ec:	50                   	push   %eax
 8ed:	ff 75 08             	pushl  0x8(%ebp)
 8f0:	e8 5d fe ff ff       	call   752 <write>
 8f5:	83 c4 10             	add    $0x10,%esp
 8f8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 8fb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 8ff:	84 db                	test   %bl,%bl
 901:	74 77                	je     97a <printf+0xca>
    if(state == 0){
 903:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 905:	0f be cb             	movsbl %bl,%ecx
 908:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 90b:	74 cb                	je     8d8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 90d:	83 ff 25             	cmp    $0x25,%edi
 910:	75 e6                	jne    8f8 <printf+0x48>
      if(c == 'd'){
 912:	83 f8 64             	cmp    $0x64,%eax
 915:	0f 84 05 01 00 00    	je     a20 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 91b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 921:	83 f9 70             	cmp    $0x70,%ecx
 924:	74 72                	je     998 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 926:	83 f8 73             	cmp    $0x73,%eax
 929:	0f 84 99 00 00 00    	je     9c8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 92f:	83 f8 63             	cmp    $0x63,%eax
 932:	0f 84 08 01 00 00    	je     a40 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 938:	83 f8 25             	cmp    $0x25,%eax
 93b:	0f 84 ef 00 00 00    	je     a30 <printf+0x180>
  write(fd, &c, 1);
 941:	8d 45 e7             	lea    -0x19(%ebp),%eax
 944:	83 ec 04             	sub    $0x4,%esp
 947:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 94b:	6a 01                	push   $0x1
 94d:	50                   	push   %eax
 94e:	ff 75 08             	pushl  0x8(%ebp)
 951:	e8 fc fd ff ff       	call   752 <write>
 956:	83 c4 0c             	add    $0xc,%esp
 959:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 95c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 95f:	6a 01                	push   $0x1
 961:	50                   	push   %eax
 962:	ff 75 08             	pushl  0x8(%ebp)
 965:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 968:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 96a:	e8 e3 fd ff ff       	call   752 <write>
  for(i = 0; fmt[i]; i++){
 96f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 973:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 976:	84 db                	test   %bl,%bl
 978:	75 89                	jne    903 <printf+0x53>
    }
  }
}
 97a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 97d:	5b                   	pop    %ebx
 97e:	5e                   	pop    %esi
 97f:	5f                   	pop    %edi
 980:	5d                   	pop    %ebp
 981:	c3                   	ret    
 982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 988:	bf 25 00 00 00       	mov    $0x25,%edi
 98d:	e9 66 ff ff ff       	jmp    8f8 <printf+0x48>
 992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 998:	83 ec 0c             	sub    $0xc,%esp
 99b:	b9 10 00 00 00       	mov    $0x10,%ecx
 9a0:	6a 00                	push   $0x0
 9a2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 9a5:	8b 45 08             	mov    0x8(%ebp),%eax
 9a8:	8b 17                	mov    (%edi),%edx
 9aa:	e8 61 fe ff ff       	call   810 <printint>
        ap++;
 9af:	89 f8                	mov    %edi,%eax
 9b1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9b4:	31 ff                	xor    %edi,%edi
        ap++;
 9b6:	83 c0 04             	add    $0x4,%eax
 9b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 9bc:	e9 37 ff ff ff       	jmp    8f8 <printf+0x48>
 9c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 9c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 9cb:	8b 08                	mov    (%eax),%ecx
        ap++;
 9cd:	83 c0 04             	add    $0x4,%eax
 9d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 9d3:	85 c9                	test   %ecx,%ecx
 9d5:	0f 84 8e 00 00 00    	je     a69 <printf+0x1b9>
        while(*s != 0){
 9db:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 9de:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 9e0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 9e2:	84 c0                	test   %al,%al
 9e4:	0f 84 0e ff ff ff    	je     8f8 <printf+0x48>
 9ea:	89 75 d0             	mov    %esi,-0x30(%ebp)
 9ed:	89 de                	mov    %ebx,%esi
 9ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 9f2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 9f5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 9f8:	83 ec 04             	sub    $0x4,%esp
          s++;
 9fb:	83 c6 01             	add    $0x1,%esi
 9fe:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 a01:	6a 01                	push   $0x1
 a03:	57                   	push   %edi
 a04:	53                   	push   %ebx
 a05:	e8 48 fd ff ff       	call   752 <write>
        while(*s != 0){
 a0a:	0f b6 06             	movzbl (%esi),%eax
 a0d:	83 c4 10             	add    $0x10,%esp
 a10:	84 c0                	test   %al,%al
 a12:	75 e4                	jne    9f8 <printf+0x148>
 a14:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 a17:	31 ff                	xor    %edi,%edi
 a19:	e9 da fe ff ff       	jmp    8f8 <printf+0x48>
 a1e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 a20:	83 ec 0c             	sub    $0xc,%esp
 a23:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a28:	6a 01                	push   $0x1
 a2a:	e9 73 ff ff ff       	jmp    9a2 <printf+0xf2>
 a2f:	90                   	nop
  write(fd, &c, 1);
 a30:	83 ec 04             	sub    $0x4,%esp
 a33:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 a36:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 a39:	6a 01                	push   $0x1
 a3b:	e9 21 ff ff ff       	jmp    961 <printf+0xb1>
        putc(fd, *ap);
 a40:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 a43:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a46:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 a48:	6a 01                	push   $0x1
        ap++;
 a4a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 a4d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 a50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 a53:	50                   	push   %eax
 a54:	ff 75 08             	pushl  0x8(%ebp)
 a57:	e8 f6 fc ff ff       	call   752 <write>
        ap++;
 a5c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 a5f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a62:	31 ff                	xor    %edi,%edi
 a64:	e9 8f fe ff ff       	jmp    8f8 <printf+0x48>
          s = "(null)";
 a69:	bb c6 10 00 00       	mov    $0x10c6,%ebx
        while(*s != 0){
 a6e:	b8 28 00 00 00       	mov    $0x28,%eax
 a73:	e9 72 ff ff ff       	jmp    9ea <printf+0x13a>
 a78:	66 90                	xchg   %ax,%ax
 a7a:	66 90                	xchg   %ax,%ax
 a7c:	66 90                	xchg   %ax,%ax
 a7e:	66 90                	xchg   %ax,%ax

00000a80 <free>:


/*-------  pmalloc struct  ---------------*/

void
free(void *ap) {
 a80:	55                   	push   %ebp
    if (DEBUGMODE == 3)
        printf(1, "FREE-\t");
    Header *bp, *p;

    bp = (Header *) ap - 1;
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a81:	a1 1c 16 00 00       	mov    0x161c,%eax
free(void *ap) {
 a86:	89 e5                	mov    %esp,%ebp
 a88:	57                   	push   %edi
 a89:	56                   	push   %esi
 a8a:	53                   	push   %ebx
 a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = (Header *) ap - 1;
 a8e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a98:	39 c8                	cmp    %ecx,%eax
 a9a:	8b 10                	mov    (%eax),%edx
 a9c:	73 32                	jae    ad0 <free+0x50>
 a9e:	39 d1                	cmp    %edx,%ecx
 aa0:	72 04                	jb     aa6 <free+0x26>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa2:	39 d0                	cmp    %edx,%eax
 aa4:	72 32                	jb     ad8 <free+0x58>
            break;
    if (bp + bp->s.size == p->s.ptr) {
 aa6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 aa9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 aac:	39 fa                	cmp    %edi,%edx
 aae:	74 30                	je     ae0 <free+0x60>
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    } else
        bp->s.ptr = p->s.ptr;
 ab0:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 ab3:	8b 50 04             	mov    0x4(%eax),%edx
 ab6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ab9:	39 f1                	cmp    %esi,%ecx
 abb:	74 3a                	je     af7 <free+0x77>
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    } else
        p->s.ptr = bp;
 abd:	89 08                	mov    %ecx,(%eax)
    freep = p;
 abf:	a3 1c 16 00 00       	mov    %eax,0x161c
    if (DEBUGMODE == 3)
        printf(1, ">FREE-DONE!\t");
}
 ac4:	5b                   	pop    %ebx
 ac5:	5e                   	pop    %esi
 ac6:	5f                   	pop    %edi
 ac7:	5d                   	pop    %ebp
 ac8:	c3                   	ret    
 ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad0:	39 d0                	cmp    %edx,%eax
 ad2:	72 04                	jb     ad8 <free+0x58>
 ad4:	39 d1                	cmp    %edx,%ecx
 ad6:	72 ce                	jb     aa6 <free+0x26>
free(void *ap) {
 ad8:	89 d0                	mov    %edx,%eax
 ada:	eb bc                	jmp    a98 <free+0x18>
 adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        bp->s.size += p->s.ptr->s.size;
 ae0:	03 72 04             	add    0x4(%edx),%esi
 ae3:	89 73 fc             	mov    %esi,-0x4(%ebx)
        bp->s.ptr = p->s.ptr->s.ptr;
 ae6:	8b 10                	mov    (%eax),%edx
 ae8:	8b 12                	mov    (%edx),%edx
 aea:	89 53 f8             	mov    %edx,-0x8(%ebx)
    if (p + p->s.size == bp) {
 aed:	8b 50 04             	mov    0x4(%eax),%edx
 af0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 af3:	39 f1                	cmp    %esi,%ecx
 af5:	75 c6                	jne    abd <free+0x3d>
        p->s.size += bp->s.size;
 af7:	03 53 fc             	add    -0x4(%ebx),%edx
    freep = p;
 afa:	a3 1c 16 00 00       	mov    %eax,0x161c
        p->s.size += bp->s.size;
 aff:	89 50 04             	mov    %edx,0x4(%eax)
        p->s.ptr = bp->s.ptr;
 b02:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b05:	89 10                	mov    %edx,(%eax)
}
 b07:	5b                   	pop    %ebx
 b08:	5e                   	pop    %esi
 b09:	5f                   	pop    %edi
 b0a:	5d                   	pop    %ebp
 b0b:	c3                   	ret    
 b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b10 <malloc>:
    return freep;
}


void *
malloc(uint nbytes) {
 b10:	55                   	push   %ebp
 b11:	89 e5                	mov    %esp,%ebp
 b13:	57                   	push   %edi
 b14:	56                   	push   %esi
 b15:	53                   	push   %ebx
 b16:	83 ec 0c             	sub    $0xc,%esp
    if (DEBUGMODE == 3)
        printf(1, "MALLOC-");
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 b19:	8b 45 08             	mov    0x8(%ebp),%eax
    if ((prevp = freep) == 0) {
 b1c:	8b 15 1c 16 00 00    	mov    0x161c,%edx
    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 b22:	8d 78 07             	lea    0x7(%eax),%edi
 b25:	c1 ef 03             	shr    $0x3,%edi
 b28:	83 c7 01             	add    $0x1,%edi
    if ((prevp = freep) == 0) {
 b2b:	85 d2                	test   %edx,%edx
 b2d:	0f 84 9d 00 00 00    	je     bd0 <malloc+0xc0>
 b33:	8b 02                	mov    (%edx),%eax
 b35:	8b 48 04             	mov    0x4(%eax),%ecx
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
        if (p->s.size >= nunits) {
 b38:	39 cf                	cmp    %ecx,%edi
 b3a:	76 6c                	jbe    ba8 <malloc+0x98>
 b3c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 b42:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b47:	0f 43 df             	cmovae %edi,%ebx
    p = sbrk(nu * sizeof(Header));
 b4a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 b51:	eb 0e                	jmp    b61 <malloc+0x51>
 b53:	90                   	nop
 b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b58:	8b 02                	mov    (%edx),%eax
        if (p->s.size >= nunits) {
 b5a:	8b 48 04             	mov    0x4(%eax),%ecx
 b5d:	39 f9                	cmp    %edi,%ecx
 b5f:	73 47                	jae    ba8 <malloc+0x98>
            freep = prevp;
            if (DEBUGMODE == 3)
                printf(1, ">MALLOC-done!\t");
            return (void *) (p + 1);
        }
        if (p == freep)
 b61:	39 05 1c 16 00 00    	cmp    %eax,0x161c
 b67:	89 c2                	mov    %eax,%edx
 b69:	75 ed                	jne    b58 <malloc+0x48>
    p = sbrk(nu * sizeof(Header));
 b6b:	83 ec 0c             	sub    $0xc,%esp
 b6e:	56                   	push   %esi
 b6f:	e8 46 fc ff ff       	call   7ba <sbrk>
    if (p == (char *) -1)
 b74:	83 c4 10             	add    $0x10,%esp
 b77:	83 f8 ff             	cmp    $0xffffffff,%eax
 b7a:	74 1c                	je     b98 <malloc+0x88>
    hp->s.size = nu;
 b7c:	89 58 04             	mov    %ebx,0x4(%eax)
    free((void *) (hp + 1));
 b7f:	83 ec 0c             	sub    $0xc,%esp
 b82:	83 c0 08             	add    $0x8,%eax
 b85:	50                   	push   %eax
 b86:	e8 f5 fe ff ff       	call   a80 <free>
    return freep;
 b8b:	8b 15 1c 16 00 00    	mov    0x161c,%edx
            if ((p = morecore(nunits)) == 0)
 b91:	83 c4 10             	add    $0x10,%esp
 b94:	85 d2                	test   %edx,%edx
 b96:	75 c0                	jne    b58 <malloc+0x48>
                return 0;
    }
}
 b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return 0;
 b9b:	31 c0                	xor    %eax,%eax
}
 b9d:	5b                   	pop    %ebx
 b9e:	5e                   	pop    %esi
 b9f:	5f                   	pop    %edi
 ba0:	5d                   	pop    %ebp
 ba1:	c3                   	ret    
 ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if (p->s.size == nunits)
 ba8:	39 cf                	cmp    %ecx,%edi
 baa:	74 54                	je     c00 <malloc+0xf0>
                p->s.size -= nunits;
 bac:	29 f9                	sub    %edi,%ecx
 bae:	89 48 04             	mov    %ecx,0x4(%eax)
                p += p->s.size;
 bb1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
                p->s.size = nunits;
 bb4:	89 78 04             	mov    %edi,0x4(%eax)
            freep = prevp;
 bb7:	89 15 1c 16 00 00    	mov    %edx,0x161c
}
 bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return (void *) (p + 1);
 bc0:	83 c0 08             	add    $0x8,%eax
}
 bc3:	5b                   	pop    %ebx
 bc4:	5e                   	pop    %esi
 bc5:	5f                   	pop    %edi
 bc6:	5d                   	pop    %ebp
 bc7:	c3                   	ret    
 bc8:	90                   	nop
 bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        base.s.ptr = freep = prevp = &base;
 bd0:	c7 05 1c 16 00 00 20 	movl   $0x1620,0x161c
 bd7:	16 00 00 
 bda:	c7 05 20 16 00 00 20 	movl   $0x1620,0x1620
 be1:	16 00 00 
        base.s.size = 0;
 be4:	b8 20 16 00 00       	mov    $0x1620,%eax
 be9:	c7 05 24 16 00 00 00 	movl   $0x0,0x1624
 bf0:	00 00 00 
 bf3:	e9 44 ff ff ff       	jmp    b3c <malloc+0x2c>
 bf8:	90                   	nop
 bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                prevp->s.ptr = p->s.ptr;
 c00:	8b 08                	mov    (%eax),%ecx
 c02:	89 0a                	mov    %ecx,(%edx)
 c04:	eb b1                	jmp    bb7 <malloc+0xa7>
 c06:	8d 76 00             	lea    0x0(%esi),%esi
 c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c10 <pmalloc>:


void *
pmalloc(void) {
 c10:	55                   	push   %ebp
 c11:	89 e5                	mov    %esp,%ebp
 c13:	56                   	push   %esi
 c14:	53                   	push   %ebx
    if (DEBUGMODE == 3)
        printf(1, "PMALLOC-");
    struct PMHeader *nh = malloc(sizeof(struct PMHeader));
 c15:	83 ec 0c             	sub    $0xc,%esp
 c18:	6a 10                	push   $0x10
 c1a:	e8 f1 fe ff ff       	call   b10 <malloc>
    char *tmpAdr = sbrk(4096); //point to the first free place
 c1f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    struct PMHeader *nh = malloc(sizeof(struct PMHeader));
 c26:	89 c3                	mov    %eax,%ebx
    char *tmpAdr = sbrk(4096); //point to the first free place
 c28:	e8 8d fb ff ff       	call   7ba <sbrk>
    if ((int) tmpAdr % 4096 != 0) //if not align->fix this
 c2d:	83 c4 10             	add    $0x10,%esp
 c30:	a9 ff 0f 00 00       	test   $0xfff,%eax
    char *tmpAdr = sbrk(4096); //point to the first free place
 c35:	89 c6                	mov    %eax,%esi
    if ((int) tmpAdr % 4096 != 0) //if not align->fix this
 c37:	74 03                	je     c3c <pmalloc+0x2c>
        *tmpAdr = (char) PGROUNDUP((int) tmpAdr);
 c39:	c6 00 00             	movb   $0x0,(%eax)

    //init PMHeader
    nh->PMheaderID = nextID++;
 c3c:	a1 0c 16 00 00       	mov    0x160c,%eax
    nh->PMnext = 0;
 c41:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    nh->PMadress = tmpAdr;
 c48:	89 73 04             	mov    %esi,0x4(%ebx)
    nh->PMprotectedPage = 0;
 c4b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    nh->PMheaderID = nextID++;
 c52:	8d 50 01             	lea    0x1(%eax),%edx
 c55:	89 15 0c 16 00 00    	mov    %edx,0x160c
 c5b:	89 03                	mov    %eax,(%ebx)

    //if first-> PMpage=tail=nh
    if (PMcounter == 0) {
 c5d:	8b 15 10 16 00 00    	mov    0x1610,%edx
 c63:	85 d2                	test   %edx,%edx
 c65:	74 39                	je     ca0 <pmalloc+0x90>
        PMinit = nh; //set PMinit link
        tail = nh;
    } else { //else- add new page to the end of PMlist
        tail->PMnext = nh;
 c67:	a1 14 16 00 00       	mov    0x1614,%eax
        tail = tail->PMnext;
 c6c:	89 1d 14 16 00 00    	mov    %ebx,0x1614
        tail->PMnext = nh;
 c72:	89 58 08             	mov    %ebx,0x8(%eax)
 c75:	8b 43 04             	mov    0x4(%ebx),%eax
    }
    //turn PMflag on and W flag off
    turnOnW(nh->PMadress);//TODO
 c78:	83 ec 0c             	sub    $0xc,%esp
 c7b:	50                   	push   %eax
 c7c:	e8 69 fb ff ff       	call   7ea <turnOnW>
    turnOnPM(nh->PMadress);
 c81:	58                   	pop    %eax
 c82:	ff 73 04             	pushl  0x4(%ebx)
 c85:	e8 48 fb ff ff       	call   7d2 <turnOnPM>
    //fresh PTE
    updatePTE();
 c8a:	e8 6b fb ff ff       	call   7fa <updatePTE>
    PMcounter++;
 c8f:	83 05 10 16 00 00 01 	addl   $0x1,0x1610
    if (DEBUGMODE == 3)
        printf(1, ">PMALLOC-DONE!\n");
    return tmpAdr;
}
 c96:	8d 65 f8             	lea    -0x8(%ebp),%esp
 c99:	89 f0                	mov    %esi,%eax
 c9b:	5b                   	pop    %ebx
 c9c:	5e                   	pop    %esi
 c9d:	5d                   	pop    %ebp
 c9e:	c3                   	ret    
 c9f:	90                   	nop
        PMinit = nh; //set PMinit link
 ca0:	89 1d 18 16 00 00    	mov    %ebx,0x1618
        tail = nh;
 ca6:	89 1d 14 16 00 00    	mov    %ebx,0x1614
    char *tmpAdr = sbrk(4096); //point to the first free place
 cac:	89 f0                	mov    %esi,%eax
 cae:	eb c8                	jmp    c78 <pmalloc+0x68>

00000cb0 <protect_page>:

int
protect_page(void *ap) {
 cb0:	55                   	push   %ebp
 cb1:	89 e5                	mov    %esp,%ebp
 cb3:	53                   	push   %ebx
 cb4:	83 ec 04             	sub    $0x4,%esp
 cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (DEBUGMODE == 3)
        printf(1, "PROTECT_PAGE-");
    if (ap) {
 cba:	85 db                	test   %ebx,%ebx
 cbc:	74 7a                	je     d38 <protect_page+0x88>
        if ((int) ap % 4096 != 0) {
 cbe:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
 cc4:	75 72                	jne    d38 <protect_page+0x88>
            if (DEBUGMODE == 3)
                printf(1, ">PROTECT_PAGE-ERROR-NOT_ALIGN!\n");
            return -1;
        }
        if (checkOnPM(ap)) { //if PTE_PM off -can't protect not pmalloc page
 cc6:	83 ec 0c             	sub    $0xc,%esp
 cc9:	53                   	push   %ebx
 cca:	e8 0b fb ff ff       	call   7da <checkOnPM>
 ccf:	83 c4 10             	add    $0x10,%esp
 cd2:	85 c0                	test   %eax,%eax
 cd4:	74 62                	je     d38 <protect_page+0x88>
            turnOffW(ap);
 cd6:	83 ec 0c             	sub    $0xc,%esp
 cd9:	53                   	push   %ebx
 cda:	e8 03 fb ff ff       	call   7e2 <turnOffW>
            updatePTE();
 cdf:	e8 16 fb ff ff       	call   7fa <updatePTE>
            updateProc(1); // protectedPages++
 ce4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 ceb:	e8 12 fb ff ff       	call   802 <updateProc>
            //turn on flag
            struct PMHeader *PMap = PMinit;
 cf0:	a1 18 16 00 00       	mov    0x1618,%eax
            while (PMap->PMnext != 0 && PMap->PMadress != ap)
 cf5:	83 c4 10             	add    $0x10,%esp
 cf8:	eb 0c                	jmp    d06 <protect_page+0x56>
 cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 d00:	39 cb                	cmp    %ecx,%ebx
 d02:	74 10                	je     d14 <protect_page+0x64>
 d04:	89 d0                	mov    %edx,%eax
 d06:	8b 50 08             	mov    0x8(%eax),%edx
 d09:	8b 48 04             	mov    0x4(%eax),%ecx
 d0c:	85 d2                	test   %edx,%edx
 d0e:	75 f0                	jne    d00 <protect_page+0x50>
                PMap = PMap->PMnext;
            if (PMap->PMadress != ap) {
 d10:	39 cb                	cmp    %ecx,%ebx
 d12:	75 11                	jne    d25 <protect_page+0x75>
                printf(2, "PROBLEM with ap:%d\n", ap);
                return -1;
            }
            //got here ->MPap points the protected link
            PMap->PMprotectedPage = 1;//turn on FLAG
 d14:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
            if (DEBUGMODE == 3)
                printf(1, ">PROTECT_PAGE-DONE!\n");
            return 1;
 d1b:	b8 01 00 00 00       	mov    $0x1,%eax
        }
    }
    if (DEBUGMODE == 3)
        printf(1, ">PROTECT_PAGE-ERROR!\n");
    return -1;
}
 d20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 d23:	c9                   	leave  
 d24:	c3                   	ret    
                printf(2, "PROBLEM with ap:%d\n", ap);
 d25:	83 ec 04             	sub    $0x4,%esp
 d28:	53                   	push   %ebx
 d29:	68 e1 10 00 00       	push   $0x10e1
 d2e:	6a 02                	push   $0x2
 d30:	e8 7b fb ff ff       	call   8b0 <printf>
 d35:	83 c4 10             	add    $0x10,%esp
 d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 d3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 d40:	c9                   	leave  
 d41:	c3                   	ret    
 d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d50 <printPMList>:


void
printPMList(void) {
 d50:	55                   	push   %ebp
 d51:	89 e5                	mov    %esp,%ebp
 d53:	56                   	push   %esi
 d54:	53                   	push   %ebx
    struct PMHeader *tmp2 = PMinit;
 d55:	8b 1d 18 16 00 00    	mov    0x1618,%ebx
    printf(1, "\nPMlist:\t");
 d5b:	83 ec 08             	sub    $0x8,%esp
 d5e:	68 f5 10 00 00       	push   $0x10f5
 d63:	6a 01                	push   $0x1
 d65:	e8 46 fb ff ff       	call   8b0 <printf>
    for (int i = 0; i < PMcounter; i++, tmp2 = tmp2->PMnext)
 d6a:	a1 10 16 00 00       	mov    0x1610,%eax
 d6f:	83 c4 10             	add    $0x10,%esp
 d72:	85 c0                	test   %eax,%eax
 d74:	7e 2d                	jle    da3 <printPMList+0x53>
 d76:	31 f6                	xor    %esi,%esi
 d78:	90                   	nop
 d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(2, "%d\t", tmp2->PMadress);
 d80:	83 ec 04             	sub    $0x4,%esp
 d83:	ff 73 04             	pushl  0x4(%ebx)
    for (int i = 0; i < PMcounter; i++, tmp2 = tmp2->PMnext)
 d86:	83 c6 01             	add    $0x1,%esi
        printf(2, "%d\t", tmp2->PMadress);
 d89:	68 ff 10 00 00       	push   $0x10ff
 d8e:	6a 02                	push   $0x2
 d90:	e8 1b fb ff ff       	call   8b0 <printf>
    for (int i = 0; i < PMcounter; i++, tmp2 = tmp2->PMnext)
 d95:	83 c4 10             	add    $0x10,%esp
 d98:	39 35 10 16 00 00    	cmp    %esi,0x1610
 d9e:	8b 5b 08             	mov    0x8(%ebx),%ebx
 da1:	7f dd                	jg     d80 <printPMList+0x30>
    printf(1, "\n\n");
 da3:	83 ec 08             	sub    $0x8,%esp
 da6:	68 c3 10 00 00       	push   $0x10c3
 dab:	6a 01                	push   $0x1
 dad:	e8 fe fa ff ff       	call   8b0 <printf>
}
 db2:	83 c4 10             	add    $0x10,%esp
 db5:	8d 65 f8             	lea    -0x8(%ebp),%esp
 db8:	5b                   	pop    %ebx
 db9:	5e                   	pop    %esi
 dba:	5d                   	pop    %ebp
 dbb:	c3                   	ret    
 dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000dc0 <checkIfPM>:

//return 1 if ap is address of PMALLOC page ; 0 otherwise
int
checkIfPM(void *p) {
    struct PMHeader *tmp = PMinit;
    for (int i = 0; i < PMcounter; i++) {
 dc0:	8b 15 10 16 00 00    	mov    0x1610,%edx
    struct PMHeader *tmp = PMinit;
 dc6:	a1 18 16 00 00       	mov    0x1618,%eax
    for (int i = 0; i < PMcounter; i++) {
 dcb:	85 d2                	test   %edx,%edx
 dcd:	7e 11                	jle    de0 <checkIfPM+0x20>
checkIfPM(void *p) {
 dcf:	55                   	push   %ebp
 dd0:	89 e5                	mov    %esp,%ebp
        if (tmp->PMadress == p)
 dd2:	8b 55 08             	mov    0x8(%ebp),%edx
 dd5:	39 50 04             	cmp    %edx,0x4(%eax)
            return 1;
    }
    return 0;
}
 dd8:	5d                   	pop    %ebp
        if (tmp->PMadress == p)
 dd9:	0f 94 c0             	sete   %al
 ddc:	0f b6 c0             	movzbl %al,%eax
}
 ddf:	c3                   	ret    
    return 0;
 de0:	31 c0                	xor    %eax,%eax
}
 de2:	c3                   	ret    
 de3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000df0 <pfree>:
pfree(void *ap) {
    if (DEBUGMODE == 3)
        printf(1, "PFREE-");

    //validation check
    if (PMcounter == 0) {
 df0:	a1 10 16 00 00       	mov    0x1610,%eax
pfree(void *ap) {
 df5:	55                   	push   %ebp
 df6:	89 e5                	mov    %esp,%ebp
 df8:	56                   	push   %esi
 df9:	53                   	push   %ebx
        if (DEBUGMODE == 3)
            printf(1, "PFREE-ERROR!->not have pages that were pmallocced\n");
        return -1;
    }

    if (ap) {
 dfa:	85 c0                	test   %eax,%eax
pfree(void *ap) {
 dfc:	8b 75 08             	mov    0x8(%ebp),%esi
    if (ap) {
 dff:	74 1b                	je     e1c <pfree+0x2c>
 e01:	85 f6                	test   %esi,%esi
 e03:	74 17                	je     e1c <pfree+0x2c>
        struct PMHeader *PMap = PMinit;
        struct PMHeader *tmp = PMinit;
        //check aligned
        if ((int) ap % 4096 != 0) {
 e05:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
        struct PMHeader *PMap = PMinit;
 e0b:	8b 1d 18 16 00 00    	mov    0x1618,%ebx
        if ((int) ap % 4096 != 0) {
 e11:	75 09                	jne    e1c <pfree+0x2c>
    for (int i = 0; i < PMcounter; i++) {
 e13:	85 c0                	test   %eax,%eax
 e15:	7e 05                	jle    e1c <pfree+0x2c>
        if (tmp->PMadress == p)
 e17:	3b 73 04             	cmp    0x4(%ebx),%esi
 e1a:	74 14                	je     e30 <pfree+0x40>
            return -1;
        }
    }
    if (DEBUGMODE == 3)
        printf(1, ">PFREE-ERROR!\t");
    return -1;
 e1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 e21:	8d 65 f8             	lea    -0x8(%ebp),%esp
 e24:	5b                   	pop    %ebx
 e25:	5e                   	pop    %esi
 e26:	5d                   	pop    %ebp
 e27:	c3                   	ret    
 e28:	90                   	nop
 e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            turnOffW(PMap);
 e30:	83 ec 0c             	sub    $0xc,%esp
 e33:	53                   	push   %ebx
 e34:	e8 a9 f9 ff ff       	call   7e2 <turnOffW>
            turnOffPM(PMap);
 e39:	89 1c 24             	mov    %ebx,(%esp)
 e3c:	e8 b1 f9 ff ff       	call   7f2 <turnOffPM>
            updatePTE();
 e41:	e8 b4 f9 ff ff       	call   7fa <updatePTE>
            PMcounter--;
 e46:	a1 10 16 00 00       	mov    0x1610,%eax
            if (PMcounter == 0) {//if true ->reset PMlist
 e4b:	83 c4 10             	add    $0x10,%esp
            PMcounter--;
 e4e:	83 e8 01             	sub    $0x1,%eax
            if (PMcounter == 0) {//if true ->reset PMlist
 e51:	85 c0                	test   %eax,%eax
            PMcounter--;
 e53:	a3 10 16 00 00       	mov    %eax,0x1610
            if (PMcounter == 0) {//if true ->reset PMlist
 e58:	74 46                	je     ea0 <pfree+0xb0>
 e5a:	89 d8                	mov    %ebx,%eax
 e5c:	eb 08                	jmp    e66 <pfree+0x76>
 e5e:	66 90                	xchg   %ax,%ax
                while (PMap->PMnext != 0 && PMap->PMadress != ap)
 e60:	39 ce                	cmp    %ecx,%esi
 e62:	74 10                	je     e74 <pfree+0x84>
 e64:	89 d0                	mov    %edx,%eax
 e66:	8b 50 08             	mov    0x8(%eax),%edx
 e69:	8b 48 04             	mov    0x4(%eax),%ecx
 e6c:	85 d2                	test   %edx,%edx
 e6e:	75 f0                	jne    e60 <pfree+0x70>
                if (PMap->PMadress != ap) {
 e70:	39 ce                	cmp    %ecx,%esi
 e72:	75 65                	jne    ed9 <pfree+0xe9>
                if (tmp->PMheaderID == PMap->PMheaderID) {//happens when both point on the first link
 e74:	8b 08                	mov    (%eax),%ecx
 e76:	39 0b                	cmp    %ecx,(%ebx)
 e78:	75 08                	jne    e82 <pfree+0x92>
 e7a:	eb 44                	jmp    ec0 <pfree+0xd0>
 e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 e80:	89 c3                	mov    %eax,%ebx
                    while (tmp->PMnext->PMheaderID != PMap->PMheaderID)
 e82:	8b 43 08             	mov    0x8(%ebx),%eax
 e85:	3b 08                	cmp    (%eax),%ecx
 e87:	75 f7                	jne    e80 <pfree+0x90>
                    tmp->PMnext = PMap->PMnext;
 e89:	89 53 08             	mov    %edx,0x8(%ebx)
}
 e8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
 e8f:	b8 01 00 00 00       	mov    $0x1,%eax
}
 e94:	5b                   	pop    %ebx
 e95:	5e                   	pop    %esi
 e96:	5d                   	pop    %ebp
 e97:	c3                   	ret    
 e98:	90                   	nop
 e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                PMinit = 0;
 ea0:	c7 05 18 16 00 00 00 	movl   $0x0,0x1618
 ea7:	00 00 00 
                tail = 0;
 eaa:	c7 05 14 16 00 00 00 	movl   $0x0,0x1614
 eb1:	00 00 00 
}
 eb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
 eb7:	b8 01 00 00 00       	mov    $0x1,%eax
}
 ebc:	5b                   	pop    %ebx
 ebd:	5e                   	pop    %esi
 ebe:	5d                   	pop    %ebp
 ebf:	c3                   	ret    
                    PMinit = PMinit->PMnext;
 ec0:	a1 18 16 00 00       	mov    0x1618,%eax
 ec5:	8b 40 08             	mov    0x8(%eax),%eax
 ec8:	a3 18 16 00 00       	mov    %eax,0x1618
}
 ecd:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 1;
 ed0:	b8 01 00 00 00       	mov    $0x1,%eax
}
 ed5:	5b                   	pop    %ebx
 ed6:	5e                   	pop    %esi
 ed7:	5d                   	pop    %ebp
 ed8:	c3                   	ret    
                    printf(2, "PROBLEM with ap:%d\n", ap);
 ed9:	83 ec 04             	sub    $0x4,%esp
 edc:	56                   	push   %esi
 edd:	68 e1 10 00 00       	push   $0x10e1
 ee2:	6a 02                	push   $0x2
 ee4:	e8 c7 f9 ff ff       	call   8b0 <printf>
                    return -1;
 ee9:	83 c4 10             	add    $0x10,%esp
 eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 ef1:	e9 2b ff ff ff       	jmp    e21 <pfree+0x31>
