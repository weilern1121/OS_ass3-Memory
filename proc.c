#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
    struct spinlock lock;
    struct proc proc[NPROC];
} ptable;

static struct proc *initproc;
char buffer[PGSIZE];

int totalAvailablePages = 0;
int nextpid = 1;

extern void forkret(void);

extern void trapret(void);

static void wakeup1(void *chan);

int notShell(void) {
    return myproc()->pid > 2;
}

void
pinit(void) {
    initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
    return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
    c = mycpu();
    p = c->proc;
    popcli();
    return p;
}


void
printCurrFrame(void){
    struct  proc *p=myproc();
    struct  page *pg;
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
        cprintf("pageID:%d\toffset:%d\t\tactive:%d\tpresent:%d\tsequal:%d\tphysAdress:%d\t\tvirtAdress:%d\n ",
                pg->pageid,pg->offset,pg->active,pg->present,pg->sequel,pg->physAdress,pg->virtAdress);
    cprintf("\n\n swapFileEntries:\t");
    for(int i=0; i<16; i++)
        cprintf("%d\t",p->swapFileEntries[i]);
    cprintf("\n\n");
}


void
panic2(char * str){
    printCurrFrame();
    panic(str);
}


//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
    struct proc *p;
    char *sp;
#if(defined(LIFO) || defined(SCFIFO))
    struct page *pg;
#endif


    acquire(&ptable.lock);

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED)
            goto found;

    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;

    release(&ptable.lock);

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
        p->state = UNUSED;
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
    p->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint) forkret;

    //TODO INIT PROC PAGES FIELDS
#if(defined(LIFO) || defined(SCFIFO))
    p->pagesCounter = 0;
    p->nextpageid = 1;
    p->pagesequel = 0;
    p->pagesinSwap = 0;

    p->protectedPages = 0;
    p->pageFaults = 0;
    p->totalPagesInSwap = 0;

    //init swap table
    for(int k=0; k<MAX_PSYC_PAGES ; k++)
        p->swapFileEntries[k]=0;

    //init proc's pages
    for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
    {
        pg->active = 0;
        pg->pageid = 0;
        pg->sequel = 0;
        pg->present = 0;
        pg->offset = 0;
        pg->physAdress = 0;
        pg->virtAdress = 0;
    }
#endif

    return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    // before first alloc, check total space for ^P minus 60 init pages.
    totalAvailablePages = kallocCount() - 60;

    p = allocproc();

    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    p->tf->es = p->tf->ds;
    p->tf->ss = p->tf->ds;
    p->tf->eflags = FL_IF;
    p->tf->esp = PGSIZE;
    p->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
    p->cwd = namei("/");

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);

    p->state = RUNNABLE;

    release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n, 1)) == 0)
            return -1;
    }
    curproc->sz = sz;
    switchuvm(curproc);
    return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();
#if(defined(LIFO) || defined(SCFIFO))
    struct page *pg , *cg;
#endif
    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
    }

#if(defined(LIFO) || defined(SCFIFO))

    createSwapFile(np);
#endif

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
    np->parent = curproc;
    *np->tf = *curproc->tf;


    if (notShell()) {
#if(defined(LIFO) || defined(SCFIFO))
        //copy pagging

        np->nextpageid = curproc->nextpageid;
        np->pagesCounter = curproc->pagesCounter;
        np->pagesinSwap = curproc->pagesinSwap;
        np->pagesequel = curproc->pagesequel;

        np->protectedPages = curproc->protectedPages;
        np->pageFaults = 0;
        np->totalPagesInSwap = 0;

        //copy swap table
        for(int k=0; k<MAX_PSYC_PAGES ; k++)
            np->swapFileEntries[k]=curproc->swapFileEntries[k];

        //copy pages
        for( pg = np->pages , cg = curproc->pages;
                pg < &np->pages[MAX_TOTAL_PAGES]; pg++ , cg++)
        {
            pg->active = cg->active;
            pg->pageid = cg->pageid;
            pg->sequel = cg->sequel;
            pg->present = cg->present;
            pg->offset = cg->offset;
            pg->physAdress = cg->physAdress;
            pg->virtAdress = cg->virtAdress;
        }

             //PAGECOUNTER-16= PAGES IN SWAP FILE
        for( int k = 0 ; k < MAX_PSYC_PAGES ; k++ ){
            if( curproc->swapFileEntries[k] > 0 ) {

                memset(buffer, 0, PGSIZE);

                if (readFromSwapFile(curproc, buffer, k * PGSIZE, PGSIZE) == -1) {
                    kfree(np->kstack);
                    np->kstack = 0;
                    np->state = UNUSED;
                    removeSwapFile(np); //clear swapFile
                    panic2( "FORK READ ");
                }

                if (writeToSwapFile(np, buffer, k * PGSIZE, PGSIZE) == -1) {
                    kfree(np->kstack);
                    np->kstack = 0;
                    np->state = UNUSED;
                    removeSwapFile(np); //clear swapFile
                    panic2( "FORK WRITE ");
                }
            }

        }

#endif
    }


    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));

    pid = np->pid;

    acquire(&ptable.lock);

    np->state = RUNNABLE;

    release(&ptable.lock);

    return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
    struct proc *curproc = myproc();
    struct proc *p;
    int fd;

    if (curproc == initproc)
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }

    begin_op();
    iput(curproc->cwd);
    end_op();
    curproc->cwd = 0;

#if(defined(LIFO) || defined(SCFIFO))
    if (notShell())
            removeSwapFile(curproc);
#endif

    acquire(&ptable.lock);

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
            if (p->state == ZOMBIE)
                wakeup1(initproc);
        }
    }

    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;

    //check VERBOSE for task 4
#if (defined(TRUE))
    procdump();
#endif
    sched();
    panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
    struct proc *p;
    int havekids, pid;
    struct proc *curproc = myproc();
#if(defined(LIFO) || defined(SCFIFO))
    struct page *pg;
#endif
    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
                freevm(p->pgdir);
                p->pid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
#if(defined(LIFO) || defined(SCFIFO))

                p->nextpageid = 0;
                p->pagesCounter = 0;
                p->pagesinSwap = 0;
                p->pagesequel = 0;

                p->protectedPages = 0;
                p->pageFaults = 0;
                p->totalPagesInSwap = 0;


                //init proc's pages
                for( pg = p->pages ; pg < &p->pages[MAX_TOTAL_PAGES]; pg++ )
                {
                    pg->active = 0;
                    pg->pageid = 0;
                    pg->sequel = 0;
                    pg->present = 0;
                    pg->offset = 0;
                    pg->physAdress = 0;
                    pg->virtAdress = 0;
                }
                //init swap table
                for(int k=0; k<MAX_PSYC_PAGES ; k++)
                    p->swapFileEntries[k]=0;

#endif

                release(&ptable.lock);
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
    struct proc *p;
    struct cpu *c = mycpu();
    c->proc = 0;


    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->state != RUNNABLE)
                continue;

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
            p->state = RUNNING;

            swtch(&(c->scheduler), p->context);
            switchkvm();

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&ptable.lock);

    }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
    int intena;
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
    swtch(&p->context, mycpu()->scheduler);
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
    acquire(&ptable.lock);  //DOC: yieldlock
    myproc()->state = RUNNABLE;
    sched();
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
    struct proc *p = myproc();

    if (p == 0)
        panic("sleep");

    if (lk == 0)
        panic("sleep without lk");

    // Must acquire ptable.lock in order to
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {  //DOC: sleeplock0
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }
    // Go to sleep.
    p->chan = chan;
    p->state = SLEEPING;

    sched();

    // Tidy up.
    p->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == SLEEPING && p->chan == chan)
            p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
    struct proc *p;

    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
                p->state = RUNNABLE;
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
    static char *states[] = {
            [UNUSED]    "unused",
            [EMBRYO]    "embryo",
            [SLEEPING]  "sleep ",
            [RUNNABLE]  "runble",
            [RUNNING]   "run   ",
            [ZOMBIE]    "zombie"
    };
    int i;
    int currentFreePages = 0;
    struct proc *p;
    char *state;
    uint pc[10];
    pte_t *currPTE;
    struct page *cg = 0;
    int protected = 0;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";

       for (cg = p->pages ; cg < &p->pages[MAX_TOTAL_PAGES]; cg++ ) {
           if(cg->active){
               currPTE = walkpgdir2(p->pgdir, cg->virtAdress, 0);
               if( ( *currPTE & PTE_W ) == 0 )
                   protected++;
           }

        }
       //p->protectedPages = protected;

        cprintf("%d %s %d %d %d %d %d %s", p->pid, state,
                p->pagesCounter, p->pagesinSwap, p->protectedPages,
                p->pageFaults, p->totalPagesInSwap, p->name);
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
    currentFreePages = kallocCount();
    cprintf(" %d / %d free pages in the system", currentFreePages, totalAvailablePages);
}



//turn on PM( pmalloced ) flag
void
turnOnPM( void *p ){
    pte_t *pte;
    pte = walkpgdir2(myproc()->pgdir, p, 0); //find the address
    *pte = PTE_PM_1(*pte); //turn on flag, defined in mmu.h
    updatePTE();
}

//turn off PM( pmalloced ) flag
void
turnOffPM( void *p ){
    pte_t *pte;
    pte = walkpgdir2(myproc()->pgdir, p, 0); //find the address
    *pte = PTE_PM_0(*pte); //turn on flag, defined in mmu.h
    updatePTE();
}



//return -1 if not pmalloced, else turn W flag off and return 1
int
turnOffW( void *p ){
    pte_t *pte;
    pte = walkpgdir2(myproc()->pgdir, p, 0);//find the address
    if( ( *pte & PTE_PM ) != 0){//check if flag was on before the syscall
        *pte = PTE_W_0(*pte);
        updatePTE();
        return 1;
    }
    return -1;
}

//return -1 if not pmalloced, else turn W flag on, PM flag off and return 1
int
turnOnW( void *p ){
    pte_t *pte;
    pte = walkpgdir2(myproc()->pgdir, p, 0);//find the address
    *pte = PTE_W_1(*pte);
    updatePTE();
    return 1;
}

//return 1 if PM flag is on and W flag is on
int
checkOnPM( void *p ){
    pte_t *pte;
    pte = walkpgdir2(myproc()->pgdir, p, 0);//find the address
//    if( ( ( *pte & PTE_PM ) != 0) && ( ( *pte & PTE_W ) != 0) ) {
    if( ( ( *pte & PTE_PM ) != 0) ) { //TODO - not sure that need to check PTE_W
        return 1;
    }
    return 0;

}



int
findFreeEntryInSwapFile(struct proc *p) {
    for (int i = 0; i < MAX_PSYC_PAGES; i++) {
        if (p->swapFileEntries[i] == 0)
            return i;
    }
    return -1;
}



//make sure that before calling to this func to check:
//#if( defined(LIFO) || defined(SCFIFO))
void
swapOutPage(struct proc *p, pde_t *pgdir) {
    if (DEBUGMODE == 2 && notShell())
        cprintf("SWAPOUTPAGE-");
    pde_t *pgtble;
    struct page *pg = 0;
    int tmpOffset = findFreeEntryInSwapFile(p);

    if (tmpOffset == -1) {//validation check
        cprintf("p->entries:\t");
        for (int i = 0; i < MAX_PSYC_PAGES; i++) {
            cprintf("%d  ", p->swapFileEntries[i]);
        }
        panic2("ERROR - there is no free entry in p->swapFileEntries!\n");
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

#elif(defined(SCFIFO))

    int minSeq, found = 0, valid = 0;
    char *tmpAdress;
    struct page *sg;
    pde_t *tmppgtble;

    while( !found && valid < MAX_TOTAL_PAGES ) {
        minSeq = p->pagesequel;
        //search for min sequal page
        for (sg = p->pages; sg < &p->pages[MAX_TOTAL_PAGES]; sg++) {
            if (sg->active && sg->present && sg->sequel < minSeq) {
                pg = sg;
                minSeq = sg->sequel;
            }
        }
        tmpAdress = pg->virtAdress;
        tmppgtble = walkpgdir2(pgdir, tmpAdress, 0); //if A_FLAG is on -turn off
        if (*tmppgtble & PTE_A) {
            *tmppgtble = PTE_A_0(*tmppgtble);
            pg->sequel = p->pagesequel++;
            valid++;
        } else
            found = 1;
    }

    if(!found)
        panic2("didnt find page to swap out is SCFIFO");
    //got here- pg have the min pagesequel




#endif


//got here - pg is the page to swap out (in both cases)


    if (writeToSwapFile(p, pg->virtAdress, (uint) swapWriteOffset, PGSIZE) == -1)
        panic2("writeToSwapFile Error!\n");

    //update page
    pg->sequel = 0;
    pg->present = 0;
    pg->offset = (uint) swapWriteOffset;
    pg->physAdress = 0;

//update page swapping for proc.
    p->swapFileEntries[tmpOffset] = pg->pageid; //update that this entry is swapped out for pageID
    p->totalPagesInSwap++;
    p->pagesinSwap++;

//update pte
    pgtble = walkpgdir2(pgdir, (void *) pg->virtAdress, 0);
    *pgtble = PTE_P_0(*pgtble);
    *pgtble = PTE_PG_1(*pgtble);
    kfree(P2V(PTE_ADDR(*pgtble)));

    lcr3(V2P(p->pgdir));


    if (DEBUGMODE == 2 && notShell() )
        cprintf(">SWAPOUTPAGE-DONE!\n");
}

void
updatePTE(void){
    lcr3(V2P(myproc()->pgdir));
}

//called from umalloc
//0/1 - update protectedPages ; 2/3 - update pagesCounter
void
updateProc(int num){
    switch (num) {
        case 1:
            myproc()->protectedPages++;
            break;
        case 0:
            myproc()->protectedPages--;
            break;

    }
}
