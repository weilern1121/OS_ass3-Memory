#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()
char buffer[PGSIZE];

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void) {
    struct cpu *c;

    // Map "logical" addresses to virtual addresses using identity map.
    // Cannot share a CODE descriptor for both kernel and user
    // because it would have to have DPL_USR, but the CPU forbids
    // an interrupt from CPL=0 to DPL=3.
    c = &cpus[cpuid()];
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
    lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc) {
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
    if (*pde & PTE_P) {
        pgtab = (pte_t *) P2V(PTE_ADDR(*pde));
    } else {
        if (!alloc || (pgtab = (pte_t *) kalloc()) == 0)
            return 0;
        // Make sure all those PTE_P bits are zero.
        memset(pgtab, 0, PGSIZE);
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
}


//global use for walkpgdir
pte_t *
walkpgdir2(pde_t *pgdir, const void *va, int alloc) {
    return walkpgdir(pgdir, va, alloc);
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
    char *a, *last;
    pte_t *pte;

    a = (char *) PGROUNDDOWN((uint) va);
    last = (char *) PGROUNDDOWN(((uint) va) + size - 1);
    for (;;) {
        if ((pte = walkpgdir(pgdir, a, 1)) == 0)
            return -1;
        if (*pte & PTE_P)
            panic("remap");
        *pte = pa | perm | PTE_P;
        if (a == last)
            break;
        a += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
}


// global use for mappages
int
mappages2(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
    return mappages(pgdir, va, size, pa, perm);
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
    void *virt;
    uint phys_start;
    uint phys_end;
    int perm;
} kmap[] = {
        {(void *) KERNBASE, 0,             EXTMEM,  PTE_W}, // I/O space
        {(void *) KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
        {(void *) data,     V2P(data),     PHYSTOP, PTE_W}, // kern data+memory
        {(void *) DEVSPACE, DEVSPACE, 0,            PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t *
setupkvm(void) {
    pde_t *pgdir;
    struct kmap *k;

    if ((pgdir = (pde_t *) kalloc()) == 0)
        return 0;
    memset(pgdir, 0, PGSIZE);
    if (P2V(PHYSTOP) > (void *) DEVSPACE)
        panic("PHYSTOP too high");
    for (k = kmap; k < &kmap[NELEM(kmap)];
    k++)
    if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                 (uint) k->phys_start, k->perm) < 0) {
        freevm(pgdir);
        return 0;
    }
    return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void) {
    kpgdir = setupkvm();
    switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void) {
    lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p) {
    if (p == 0)
        panic("switchuvm: no process");
    if (p->kstack == 0)
        panic("switchuvm: no kstack");
    if (p->pgdir == 0)
        panic("switchuvm: no pgdir");

    pushcli();
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                  sizeof(mycpu()->ts) - 1, 0);
    mycpu()->gdt[SEG_TSS].s = 0;
    mycpu()->ts.ss0 = SEG_KDATA << 3;
    mycpu()->ts.esp0 = (uint) p->kstack + KSTACKSIZE;
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    mycpu()->ts.iomb = (ushort) 0xFFFF;
    ltr(SEG_TSS << 3);
    lcr3(V2P(p->pgdir));  // switch to process's address space
    popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz) {
    char *mem;

    if (sz >= PGSIZE)
        panic("inituvm: more than a page");
    mem = kalloc();
    memset(mem, 0, PGSIZE);
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
    memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
    uint i, pa, n;
    pte_t *pte;

    if ((uint) addr % PGSIZE != 0)
        panic("loaduvm: addr must be page aligned");
    for (i = 0; i < sz; i += PGSIZE) {
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0)
            panic("loaduvm: address should exist");
        pa = PTE_ADDR(*pte);
        if (sz - i < PGSIZE)
            n = sz - i;
        else
            n = PGSIZE;
        if (readi(ip, P2V(pa), offset + i, n) != n)
            return -1;
    }
    return 0;
}

int
findFreeEntryInSwapFile(struct proc *p) {
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
        if (!p->swapFileEntries[i])
            return i;
    }
    return -1;
}

//TODO - make sure that before calling to this func to check:
//TODO - #if( defined(LIFO) || defined(SCFIFO))
void
swapOutPage(struct proc *p, pde_t *pgdir) {
    pde_t *pgtble;
    struct page *pg = 0;
    int tmpOffset = findFreeEntryInSwapFile(p);
    if (tmpOffset == -1) {//validy check
        cprintf("p->entries:\t");
        for (int i = 0; i < MAX_PSYC_PAGES; i++) {

            cprintf("%d  ", p->swapFileEntries[i]);
        }
        panic("ERROR - there is no free entry in p->swapFileEntries!\n");

    }

    int swapWriteOffset = tmpOffset * PGSIZE; //calculate offset

#if(defined(LIFO))
    int maxSeq = 0;
    struct page *cg;
    for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES]; cg++) {
        if (cg->active && cg->present && cg->sequel > maxSeq) {
            pg = cg;
            maxSeq = cg->sequel;
        }
    }

//#endif


#elif(defined(SCFIFO))
    int minSeq = p->pagesequel, found = 0;
    char *tmpAdress;
    pde_t *tmppgtble;
    struct page *sg;
    while (!found) {
        //find page with min pagesequel
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
            if (sg->active && sg->present && sg->sequel < minSeq) {
                pg = sg;
                minSeq = sg->sequel;
            }
        }
        //got here- pg have the min pagesequel
        tmpAdress = pg->virtAdress;
        tmppgtble = walkpgdir(pgdir, tmpAdress, 0);
        if (*tmppgtble & PTE_A) { //if legal addr and acces bit is on - move to end of page queue
            *tmppgtble = PTE_A_0(*tmppgtble);
            pg->sequel = p->pagesequel++;
            found = 1; //TODO - found = 1 is in wrong location - it will exit when find page to skip
        }
        //TODO - from here possible change
        else {
            if (*tmppgtble & !PTE_A) //if legal addr and bit is off - this is the page to swap out
                found = 1;
            else
                panic("Error - tmppgtble = walkpgdir(pgdir, tmpAdress, 0);\n");
        }
        //TODO - until here
    }

#endif

    //got here - pg is the page to swap out (in both cases)

    //write the page to swapFile
    writeToSwapFile(p, pg->physAdress, (uint) swapWriteOffset, PGSIZE);
    //update page
    pg->present = 0;
    pg->offset = (uint) swapWriteOffset;
    pg->physAdress = 0;
    pg->sequel = 0;

    //must update page swapping for proc.

    p->swapFileEntries[tmpOffset] = 1; //update that this entry is swapped out
    p->totalPagesInSwap++;
    p->pagesinSwap++;

    //update pte
    pgtble = walkpgdir(pgdir, (void *) pg->virtAdress, 0);
    *pgtble = PTE_P_0(*pgtble);
    *pgtble = PTE_PG_1(*pgtble);
    kfree(P2V(PTE_ADDR(*pgtble)));
    lcr3(V2P(p->pgdir));
}


// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
    if (DEBUGMODE == 2 && notShell())
        cprintf("ALLOCUVM-");
    char *mem;
    uint a;
#if(defined(LIFO) || defined(SCFIFO))
    pde_t *pgtble;
    struct proc *p = myproc();
    struct page *pg = 0;
#endif

    if (newsz >= KERNBASE)
        return 0;
    if (newsz < oldsz)
        return oldsz;

    a = PGROUNDUP(oldsz);
    for (; a < newsz; a += PGSIZE) {
        // TODO HERE WE CREATE PYSYC MEMORY;
        // TODO HERE WE SHOULD CHECK NUM OF PAGES AND IF NOT MAX PAGES.
        // TODO DEAL WITH MOVING PAGES TO SWAP FILE USING FS FUNCTIONS.
        if (notShell()) {
#if(defined(LIFO) || defined(SCFIFO))
            if (p->pagesCounter == MAX_TOTAL_PAGES)
                panic("got 32 pages and requested for another page!");

    //    cprintf("p->pagesCounter=%d\tp->pagesinSwap=%d\tMAX_PSYC_PAGES=%d\n",p->pagesCounter , p->pagesinSwap , MAX_PSYC_PAGES);
            // if number of pages overall minus pages in swap is more than 16 we have prob
            if (p->pagesCounter - p->pagesinSwap >= MAX_PSYC_PAGES && p->pid > 2) {
                //find the page to swap out
                //got here - the page to swat out is pg
                swapOutPage(p, pgdir); //this func includes remove page, update proc and update PTE
            }
#endif
        }

        mem = kalloc();
        if (mem == 0) {
            cprintf("allocuvm out of memory\n");
            deallocuvm(pgdir, newsz, oldsz, 0);
            if (DEBUGMODE == 2 && notShell())
                cprintf(">ALLOCUVM-FAILED-mem == 0\t");
            return 0;
        }
        memset(mem, 0, PGSIZE);
        if (mappages(pgdir, (char *) a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
            cprintf("allocuvm out of memory (2)\n");
            deallocuvm(pgdir, newsz, oldsz, 0);
            kfree(mem);
            if (DEBUGMODE == 2 && notShell())
                cprintf(">ALLOCUVM-FAILED-mappages<0\t");
            return 0;
        }

#if(defined(LIFO) || defined(SCFIFO))
        if (notShell()) {
            //INIT PAGE STRUCT
            for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
                if (!pg->active)
                    goto foundpage;
            }

            panic("no page in proc");

            foundpage:
            p->pagesCounter++;
            pg->active = 1;
            pg->pageid = p->nextpageid++;
            pg->present = 1;
            pg->offset = 0;
            pg->sequel = p->pagesequel++;
            pg->physAdress = mem;
            pg->virtAdress = (char *) a;

            //update pte of the page
            pgtble = walkpgdir(pgdir, (char *) a, 0);
            *pgtble = PTE_P_1(*pgtble);  // Present
            *pgtble = PTE_PG_0(*pgtble); // Not Paged out to secondary storage
            lcr3(V2P(p->pgdir));
        }


#endif

    }

    if (DEBUGMODE == 2 && notShell())
        cprintf(">ALLOCUVM-DONE!\t");
    return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz, int growproc) {
    if (DEBUGMODE == 2)
        cprintf("DEALLOCUVM-");
    pte_t *pte;
    uint a, pa;
#if(defined(LIFO) || defined(SCFIFO))
    struct page *pg;
        struct proc *p = myproc();
#endif
    if (newsz >= oldsz) {
        if (DEBUGMODE == 2 && notShell())
            cprintf(">DEALLOCUVM-FAILED!-newsz >= oldsz\t");
        return oldsz;
    }

    a = PGROUNDUP(newsz);
    for (; a < oldsz; a += PGSIZE) {
        pte = walkpgdir(pgdir, (char *) a, 0);
        if (!pte)
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        else if ((*pte & PTE_P) != 0) {
            pa = PTE_ADDR(*pte);
            if (pa == 0)
                panic("kfree");


#if(defined(LIFO) || defined(SCFIFO))
            if (notShell() && growproc) {
                    //scan pages table and remove page that page.virtAdress == a
                    for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
                        if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
                        {
                            //remove page
                            pg->virtAdress = 0;
                            pg->active = 0;
                            pg->offset = 0;      //TODO - check if there is a need to save offset
                            pg->present = 0;

                            //update proc
                            p->pagesCounter--;
                            break;
                        }
                    }
                    if (pg == &p->pages[MAX_TOTAL_PAGES])//if true ->didn't find the virtAdress
                        panic("deallocuvm Error - didn't find the virtAdress!");
                    //if got here -here is a free page
                }
#endif


            char *v = P2V(pa);
            kfree(v);
            *pte = 0;
        } else {
#if(defined(LIFO) || defined(SCFIFO))
            if ((*pte & PTE_PG) != 0) {
                    pa = PTE_ADDR(*pte);
                    if (pa == 0)
                        panic("kfree");
                    if (p->pid > 2 && growproc) {
                        //scan pages table and remove page that page.virtAdress == a
                        for (pg = p->pages; pg < &p->pages[MAX_TOTAL_PAGES]; pg++) {
                            if (pg->active && pg->virtAdress == (char *) a) //if true -> free page
                            {
                                //remove page
                                pg->virtAdress = 0;
                                pg->active = 0;
                                pg->offset = 0;      //TODO - check if there is a need to save offset
                                pg->present = 0;

                                //update proc
                                p->pagesCounter--;
                                break;
                            }
                        }
                    }
                }
#endif
        }
    }
    if (DEBUGMODE == 2 && notShell())
        cprintf(">DEALLOCUVM-DONE!\t");
    return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir) {
    if (DEBUGMODE == 2 && notShell())
        cprintf("FREEVM");
    uint i;

    if (pgdir == 0)
        panic("freevm: no pgdir");
    deallocuvm(pgdir, KERNBASE, 0, 0);
    for (i = 0; i < NPDENTRIES; i++) {
        if (pgdir[i] & PTE_P) {
            char *v = P2V(PTE_ADDR(pgdir[i]));
            kfree(v);
        }
    }
    kfree((char *) pgdir);
    if (DEBUGMODE == 2 && notShell())
        cprintf(">FREEVM-DONE!\t");
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva) {
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
    if (pte == 0)
        panic("clearpteu");
    *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz) {
    if (DEBUGMODE == 2 && notShell())
        cprintf("COPYUVM-");
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0)
        return 0;
    for (i = 0; i < sz; i += PGSIZE) {
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
            panic("copyuvm: pte should exist");
        if (!(*pte & PTE_P))
            panic("copyuvm: page not present");
        pa = PTE_ADDR(*pte);
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0)
            goto bad;
        memmove(mem, (char *) P2V(pa), PGSIZE);
        if (mappages(d, (void *) i, PGSIZE, V2P(mem), flags) < 0)
            goto bad;
    }
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-DONE!\t");
    return d;

    bad:
    freevm(d);
    if (DEBUGMODE == 2 && notShell())
        cprintf(">COPYUVM-FAILED!\t");
    return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva) {
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
    if ((*pte & PTE_P) == 0)
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    return (char *) P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len) {
    char *buf, *pa0;
    uint n, va0;

    buf = (char *) p;
    while (len > 0) {
        va0 = (uint) PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char *) va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (va - va0);
        if (n > len)
            n = len;
        memmove(pa0 + (va - va0), buf, n);
        len -= n;
        buf += n;
        va = va0 + PGSIZE;
    }
    return 0;
}

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
