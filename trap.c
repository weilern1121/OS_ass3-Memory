#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks, virtualAddr, problematicPage;
struct proc *p;

void
tvinit(void) {
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

    initlock(&tickslock, "time");
}

void
idtinit(void) {
    lidt(idt, sizeof(idt));
}

//used to locate page index ofp age in  p->swapFileEntries
int findIndexByPageId(uint num) {
    struct proc *p = myproc();
    for (int i=0; i<16 ;i++) {
        //if this is the pid of file ->return index
        if (p->swapFileEntries[i] == num)
            return i;
    }
    return -1;
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
    if (tf->trapno == T_SYSCALL) {
        if (myproc()->killed)
            exit();
        myproc()->tf = tf;
        syscall();
        if (myproc()->killed)
            exit();
        return;
    }

    switch (tf->trapno) {
        case T_IRQ0 + IRQ_TIMER:
            if (cpuid() == 0) {
                acquire(&tickslock);
                ticks++;
                wakeup(&ticks);
                release(&tickslock);
            }
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE:
            ideintr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE + 1:
            // Bochs generates spurious IDE1 interrupts.
            break;
        case T_IRQ0 + IRQ_KBD:
            kbdintr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_COM1:
            uartintr();
            lapiceoi();
            break;
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
                    cpuid(), tf->cs, tf->eip);
            lapiceoi();
            break;

            //CASE TRAP 14 PGFLT IF IN SWITCH FILE: BRING FROM THERE, ELSE GO DEFAULT
#if (defined(SCFIFO) || defined(LIFO))
        case T_PGFLT:
            p = myproc();
            struct page *cg = 0;
            int i;
            char *newAddr;
            pte_t *currPTE;

            virtualAddr = rcr2();
            problematicPage = PGROUNDDOWN(virtualAddr);
            //first we need to check if page is in swap
            /*for (cg = p->pages; cg < &p->pages[MAX_TOTAL_PAGES] ; cg++ )
                cprintf(" FUCK IT IS : %d %d    he is inside swap: %d \n" , cg->pageid, cg->virtAdress, cg->present);

            */for (cg = p->pages, i = 0; cg < &p->pages[MAX_TOTAL_PAGES]; cg++, i++) {
        if (cg->virtAdress == (char *) problematicPage && !cg->present)
            goto noProbPage;
    }

        noProbPage:
            if (cg == &p->pages[MAX_TOTAL_PAGES]) { //if true -didn't find the addr -error
                panic("Error- didn't find the trap's page in T_PGFLT\n");
            }
            //must update page faults for proc.
            p->pageFaults++;

            //Got here - cg is the page that is in swapFile; i is its location in array
            //Now- check if all 16 pages are in RAM

            //TODO = check if page is in secondary memory
            if ((!cg->active) || cg->present) {
                if (cg->present)
                    panic("Error - problematic page is present!\n");
                panic("Error - problematic page is not active!\n");
            }

            if ((p->pagesCounter - p->pagesinSwap) >= 16) {
                //if true - there is no room for another page- need to swap out
                swapOutPage(p, p->pgdir); //func in vm.c - same use in allocuvm
            }

            //got here - there is a room for a new page

            if ((newAddr = kalloc()) == 0) {
                cprintf("Error- kalloc in T_PGFLT\n");
                break;
            }

            memset(newAddr, 0, PGSIZE); //clean the page

            //bring page from swapFile
            if (readFromSwapFile(p, newAddr, cg->offset, PGSIZE) == -1)
                panic("error - read from swapfile in T_PGFLT");

            currPTE = walkpgdir2(p->pgdir, (void *) virtualAddr, 0);
            //update flags - in page, not yet in RAM
            *currPTE = PTE_P_0(*currPTE);
            *currPTE = PTE_PG_1(*currPTE);

            mappages2(p->pgdir, (void *) problematicPage, PGSIZE, V2P(newAddr), PTE_U | PTE_W);
            //update flags - if got here the page is in RAM!
            *currPTE = PTE_P_1(*currPTE);
            *currPTE = PTE_PG_0(*currPTE);

            //update page
            i = findIndexByPageId(cg->pageid);
            if (i == -1)
                panic("didn't find the page offset!\n");
            cg->offset = 0;
            cg->virtAdress = (char *) problematicPage;
            cg->active = 1;
            cg->present = 1;
            cg->sequel = p->pagesequel++;
            //TODO
            cg->physAdress = (char *) V2P(newAddr);

            //update proc

            p->swapFileEntries[i] = 0; //clean entry- page is in RAM
//            p->pagesCounter++;
            p->pagesinSwap--;

            lapiceoi();
            break;
#endif


            //PAGEBREAK: 13
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
                // In kernel, it must be our mistake.
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
        tf->trapno == T_IRQ0 + IRQ_TIMER)
        yield();

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();
}
